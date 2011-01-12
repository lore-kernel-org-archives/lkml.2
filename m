Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab1ALEHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 23:07:49 -0500
Received: from ozlabs.org ([203.10.76.45]:36257 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab1ALEHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 23:07:48 -0500
Date: Wed, 12 Jan 2011 15:07:40 +1100
From: Anton Blanchard <anton@samba.org>
To: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, peterz@infradead.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, miltonm@bga.com, benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org
Subject: RE: [PATCH] smp_call_function_many SMP race
Message-ID: <20110112150740.77dde58c@kryten>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I managed to forget all about this bug, probably because of how much it
makes my brain hurt.

The issue is not that we use RCU, but that we use RCU on a static data
structure that gets reused without waiting for an RCU grace period.
Another way to solve this bug would be to dynamically allocate the
structure, assuming we are OK with the overhead.

Anton


From: Anton Blanchard <anton@samba.org>

I noticed a failure where we hit the following WARN_ON in
generic_smp_call_function_interrupt:

                if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
                        continue;

                data->csd.func(data->csd.info);

                refs = atomic_dec_return(&data->refs);
                WARN_ON(refs < 0);      <-------------------------

We atomically tested and cleared our bit in the cpumask, and yet the
number of cpus left (ie refs) was 0. How can this be?

It turns out commit 54fdade1c3332391948ec43530c02c4794a38172
(generic-ipi: make struct call_function_data lockless)
is at fault. It removes locking from smp_call_function_many and in
doing so creates a rather complicated race.

The problem comes about because:

- The smp_call_function_many interrupt handler walks call_function.queue
  without any locking.
- We reuse a percpu data structure in smp_call_function_many.
- We do not wait for any RCU grace period before starting the next
  smp_call_function_many.

Imagine a scenario where CPU A does two smp_call_functions back to
back, and CPU B does an smp_call_function in between. We concentrate on
how CPU C handles the calls:


CPU A                  CPU B                  CPU C

smp_call_function
                                              smp_call_function_interrupt
                                                walks
call_function.queue sees CPU A on list

                         smp_call_function

                                              smp_call_function_interrupt
                                                walks
                                              call_function.queue sees
                                              (stale) CPU A on list
                                              smp_call_function reuses
                                              percpu *data set
                                              data->cpumask sees and
                                              clears bit in cpumask!
                                              sees data->refs is 0!

  set data->refs (too late!)


The important thing to note is since the interrupt handler walks a
potentially stale call_function.queue without any locking, then another
cpu can view the percpu *data structure at any time, even when the
owner is in the process of initialising it.

The following test case hits the WARN_ON 100% of the time on my PowerPC
box (having 128 threads does help :)


#include <linux/module.h>
#include <linux/init.h>

#define ITERATIONS 100

static void do_nothing_ipi(void *dummy)
{
}

static void do_ipis(struct work_struct *dummy)
{
	int i;

	for (i = 0; i < ITERATIONS; i++)
		smp_call_function(do_nothing_ipi, NULL, 1);

	printk(KERN_DEBUG "cpu %d finished\n", smp_processor_id());
}

static struct work_struct work[NR_CPUS];

static int __init testcase_init(void)
{
	int cpu;

	for_each_online_cpu(cpu) {
		INIT_WORK(&work[cpu], do_ipis);
		schedule_work_on(cpu, &work[cpu]);
	}

	return 0;
}

static void __exit testcase_exit(void)
{
}

module_init(testcase_init)
module_exit(testcase_exit)
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Anton Blanchard");


I tried to fix it by ordering the read and the write of ->cpumask and
->refs. In doing so I missed a critical case but Paul McKenney was able
to spot my bug thankfully :) To ensure we arent viewing previous
iterations the interrupt handler needs to read ->refs then ->cpumask
then ->refs _again_.

Thanks to Milton Miller and Paul McKenney for helping to debug this
issue.

---

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c	2010-12-22 17:19:11.262835785 +1100
+++ linux-2.6/kernel/smp.c	2011-01-12 15:03:08.793324402 +1100
@@ -194,6 +194,31 @@ void generic_smp_call_function_interrupt
 	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
 
+		/*
+		 * Since we walk the list without any locks, we might
+		 * see an entry that was completed, removed from the
+		 * list and is in the process of being reused.
+		 *
+		 * Just checking data->refs then data->cpumask is not good
+		 * enough because we could see a non zero data->refs from a
+		 * previous iteration. We need to check data->refs, then
+		 * data->cpumask then data->refs again. Talk about
+		 * complicated!
+		 */
+
+		if (atomic_read(&data->refs) == 0)
+			continue;
+
+		smp_rmb();
+
+		if (!cpumask_test_cpu(cpu, data->cpumask))
+			continue;
+
+		smp_rmb();
+
+		if (atomic_read(&data->refs) == 0)
+			continue;
+
 		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
 			continue;
 
@@ -458,6 +483,14 @@ void smp_call_function_many(const struct
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
+
+	/*
+	 * To ensure the interrupt handler gets an up to date view
+	 * we order the cpumask and refs writes and order the
+	 * read of them in the interrupt handler.
+	 */
+	smp_wmb();
+
 	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
