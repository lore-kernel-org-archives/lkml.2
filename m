Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1ARVGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:06:25 -0500
Received: from mail4.comsite.net ([205.238.176.238]:62411 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1ARVGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:06:23 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=70.249.75.62;
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH 2/2] consolidate writes in smp_call_funtion_interrupt
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        miltonm@bga.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <smp-call-function-peter-reply@mdm.bga.com>
Message-ID: <smp-call-function-move-writes@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	<1295288253.30950.280.camel@laptop>
	<smp-call-function-peter-reply@mdm.bga.com>
Date: Tue, 18 Jan 2011 15:06:23 -0600
X-Originating-IP: 70.249.75.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to test the cpu mask in the interrupt handler before checking the
refs, otherwise we can start to follow an entry before its deleted and
find it partially initailzed for the next trip.  Presently we also clear
the cpumask bit before executing the called function, which implies
getting write access to the line.  After the function is called we then
decrement refs, and if they go to zero we then unlock the structure.

However, this implies getting write access to the call function data
before and after another the function is called.  If we can assert
that no smp_call_function execution function is allowed to enable
interrupts, then we can move both writes to after the function is
called, hopfully allowing both writes with one cache line bounce.

On a 256 thread system with a kernel compiled for 1024 threads, the
time to execute testcase in the "smp_call_function_many race"
changelog was reduced by about 30-40ms out of about 545 ms.

Signed-off-by: Milton Miller <miltonm@bga.com>
---

I decided to keep this as WARN because its now a buggy function, even
though the stack trace is of no value -- a simple printk would give
us the information needed.

Raw data:

without patch
ipi_test startup took 1219366ns complete 539819014ns total 541038380ns
ipi_test startup took 1695754ns complete 543439872ns total 545135626ns
ipi_test startup took 7513568ns complete 539606362ns total 547119930ns
ipi_test startup took 13304064ns complete 533898562ns total 547202626ns
ipi_test startup took 8668192ns complete 544264074ns total 552932266ns
ipi_test startup took 4977626ns complete 548862684ns total 553840310ns
ipi_test startup took 2144486ns complete 541292318ns total 543436804ns
ipi_test startup took 21245824ns complete 530280180ns total 551526004ns

with patch
ipi_test startup took 5961748ns complete 500859628ns total 506821376ns
ipi_test startup took 8975996ns complete 495098924ns total 504074920ns
ipi_test startup took 19797750ns complete 492204740ns total 512002490ns
ipi_test startup took 14824796ns complete 487495878ns total 502320674ns
ipi_test startup took 11514882ns complete 494439372ns total 505954254ns
ipi_test startup took 8288084ns complete 502570774ns total 510858858ns
ipi_test startup took 6789954ns complete 493388112ns total 500178066ns

	#include <linux/module.h>
	#include <linux/init.h>
	#include <linux/sched.h> /* sched clock */
	
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
		u64 start, started, done;
	
		start = local_clock();
		for_each_online_cpu(cpu) {
			INIT_WORK(&work[cpu], do_ipis);
			schedule_work_on(cpu, &work[cpu]);
		}
		started = local_clock();
		for_each_online_cpu(cpu)
			flush_work(&work[cpu]);
		done = local_clock();
		pr_info("ipi_test startup took %lldns complete %lldns total %lldns\n",
			started-start, done-started, done-start);
	
		return 0;
	}
	
	static void __exit testcase_exit(void)
	{
	}
	
	module_init(testcase_init)
	module_exit(testcase_exit)
	MODULE_LICENSE("GPL");
	MODULE_AUTHOR("Anton Blanchard");
	
	

---
 kernel/smp.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)



Index: common/kernel/smp.c
===================================================================
--- common.orig/kernel/smp.c	2011-01-17 20:16:18.000000000 -0600
+++ common/kernel/smp.c	2011-01-17 20:17:50.000000000 -0600
@@ -193,6 +193,7 @@ void generic_smp_call_function_interrupt
 	 */
 	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
 		int refs;
+		void (*func) (void *info);
 
 		/*
 		 * Since we walk the list without any locks, we might
@@ -212,24 +213,32 @@ void generic_smp_call_function_interrupt
 		if (atomic_read(&data->refs) == 0)
 			continue;
 
-		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask))
-			continue;
-
+		func = data->csd.func;			/* for later warn */
 		data->csd.func(data->csd.info);
 
+		/*
+		 * If the cpu mask is not still set then it enabled interrupts,
+		 * we took another smp interrupt, and executed the function
+		 * twice on this cpu.  In theory that copy decremented refs.
+		 */
+		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask)) {
+			WARN(1, "%pS enabled interrupts and double executed\n",
+			     func);
+			continue;
+		}
+
 		refs = atomic_dec_return(&data->refs);
 		WARN_ON(refs < 0);
-		if (!refs) {
-			WARN_ON(!cpumask_empty(data->cpumask));
-
-			raw_spin_lock(&call_function.lock);
-			list_del_rcu(&data->csd.list);
-			raw_spin_unlock(&call_function.lock);
-		}
 
 		if (refs)
 			continue;
 
+		WARN_ON(!cpumask_empty(data->cpumask));
+
+		raw_spin_lock(&call_function.lock);
+		list_del_rcu(&data->csd.list);
+		raw_spin_unlock(&call_function.lock);
+
 		csd_unlock(&data->csd);
 	}
 
