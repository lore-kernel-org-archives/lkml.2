Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395Ab1C3Vzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:55:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:17014 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933359Ab1C3VHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411277129"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: anton@samba.org, miltonm@bga.com, ak@linux.intel.com, mingo@elte.hu,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [68/275] kernel/smp.c: fix smp_call_function_many() SMP race
Message-Id: <20110330210505.45A143E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Anton Blanchard <anton@samba.org>

commit 6dc19899958e420a931274b94019e267e2396d3e upstream.

I noticed a failure where we hit the following WARN_ON in
generic_smp_call_function_interrupt:

                if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
                        continue;

                data->csd.func(data->csd.info);

                refs = atomic_dec_return(&data->refs);
                WARN_ON(refs < 0);      <-------------------------

We atomically tested and cleared our bit in the cpumask, and yet the
number of cpus left (ie refs) was 0.  How can this be?

It turns out commit 54fdade1c3332391948ec43530c02c4794a38172
("generic-ipi: make struct call_function_data lockless") is at fault.  It
removes locking from smp_call_function_many and in doing so creates a
rather complicated race.

The problem comes about because:

 - The smp_call_function_many interrupt handler walks call_function.queue
   without any locking.
 - We reuse a percpu data structure in smp_call_function_many.
 - We do not wait for any RCU grace period before starting the next
   smp_call_function_many.

Imagine a scenario where CPU A does two smp_call_functions back to back,
and CPU B does an smp_call_function in between.  We concentrate on how CPU
C handles the calls:

CPU A            CPU B                  CPU C              CPU D

smp_call_function
                                        smp_call_function_interrupt
                                            walks
					call_function.queue sees
					data from CPU A on list

                 smp_call_function

                                        smp_call_function_interrupt
                                            walks

                                        call_function.queue sees
                                          (stale) CPU A on list
							   smp_call_function int
							   clears last ref on A
							   list_del_rcu, unlock
smp_call_function reuses
percpu *data A
                                         data->cpumask sees and
                                         clears bit in cpumask
                                         might be using old or new fn!
                                         decrements refs below 0

set data->refs (too late!)

The important thing to note is since the interrupt handler walks a
potentially stale call_function.queue without any locking, then another
cpu can view the percpu *data structure at any time, even when the owner
is in the process of initialising it.

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
->refs.  In doing so I missed a critical case but Paul McKenney was able
to spot my bug thankfully :) To ensure we arent viewing previous
iterations the interrupt handler needs to read ->refs then ->cpumask then
->refs _again_.

Thanks to Milton Miller and Paul McKenney for helping to debug this issue.

[miltonm@bga.com: add WARN_ON and BUG_ON, remove extra read of refs before initial read of mask that doesn't help (also noted by Peter Zijlstra), adjust comments, hopefully clarify scenario ]
[miltonm@bga.com: remove excess tests]
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/smp.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Index: linux-2.6.35.y/kernel/smp.c
===================================================================
--- linux-2.6.35.y.orig/kernel/smp.c	2011-03-29 22:51:42.804627906 -0700
+++ linux-2.6.35.y/kernel/smp.c	2011-03-29 23:54:08.137794201 -0700
@@ -194,6 +194,24 @@
 	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
 
+		/*
+		 * Since we walk the list without any locks, we might
+		 * see an entry that was completed, removed from the
+		 * list and is in the process of being reused.
+		 *
+		 * We must check that the cpu is in the cpumask before
+		 * checking the refs, and both must be set before
+		 * executing the callback on this cpu.
+		 */
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
 
@@ -442,11 +460,21 @@
 
 	data = &__get_cpu_var(cfd_data);
 	csd_lock(&data->csd);
+	BUG_ON(atomic_read(&data->refs) || !cpumask_empty(data->cpumask));
 
 	data->csd.func = func;
 	data->csd.info = info;
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
+
+	/*
+	 * To ensure the interrupt handler gets an complete view
+	 * we order the cpumask and refs writes and order the read
+	 * of them in the interrupt handler.  In addition we may
+	 * only clear our own cpu bit from the mask.
+	 */
+	smp_wmb();
+
 	atomic_set(&data->refs, cpumask_weight(data->cpumask));
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
