Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2LDI4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:56:07 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33816 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab2LDI4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:56:04 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH 02/10] smp,
 cpu hotplug: Fix smp_call_function_*() to prevent CPU offline properly
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org
Cc: sbw@mit.edu, tj@kernel.org, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 14:24:28 +0530
Message-ID: <20121204085419.25919.79543.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120408-8878-0000-0000-00000507A821
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

With stop_machine() gone from the CPU offline path, we can't depend on
preempt_disable() to prevent CPUs from going offline from under us.

Use the get/put_online_cpus_stable_atomic() APIs to prevent CPUs from going
offline, while invoking from atomic context.

[ Michael: Designed the synchronization for the IPI case ]
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
[ Srivatsa: Generalized it to work for all cases and wrote the changelog ]
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/smp.c |   54 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 29dd40a..581727c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -310,7 +310,8 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	 * prevent preemption and reschedule on another processor,
 	 * as well as CPU removal
 	 */
-	this_cpu = get_cpu();
+	get_online_cpus_stable_atomic();
+	this_cpu = smp_processor_id();
 
 	/*
 	 * Can deadlock when called with interrupts disabled.
@@ -326,7 +327,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 		func(info);
 		local_irq_restore(flags);
 	} else {
-		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
+		if ((unsigned)cpu < nr_cpu_ids && cpu_online_stable(cpu)) {
 			struct call_single_data *data = &d;
 
 			if (!wait)
@@ -342,7 +343,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 		}
 	}
 
-	put_cpu();
+	put_online_cpus_stable_atomic();
 
 	return err;
 }
@@ -371,8 +372,10 @@ int smp_call_function_any(const struct cpumask *mask,
 	const struct cpumask *nodemask;
 	int ret;
 
+	get_online_cpus_stable_atomic();
 	/* Try for same CPU (cheapest) */
-	cpu = get_cpu();
+	cpu = smp_processor_id();
+
 	if (cpumask_test_cpu(cpu, mask))
 		goto call;
 
@@ -380,15 +383,15 @@ int smp_call_function_any(const struct cpumask *mask,
 	nodemask = cpumask_of_node(cpu_to_node(cpu));
 	for (cpu = cpumask_first_and(nodemask, mask); cpu < nr_cpu_ids;
 	     cpu = cpumask_next_and(cpu, nodemask, mask)) {
-		if (cpu_online(cpu))
+		if (cpu_online_stable(cpu))
 			goto call;
 	}
 
 	/* Any online will do: smp_call_function_single handles nr_cpu_ids. */
-	cpu = cpumask_any_and(mask, cpu_online_mask);
+	cpu = cpumask_any_and(mask, cpu_online_stable_mask);
 call:
 	ret = smp_call_function_single(cpu, func, info, wait);
-	put_cpu();
+	put_online_cpus_stable_atomic();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(smp_call_function_any);
@@ -409,14 +412,17 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 	unsigned int this_cpu;
 	unsigned long flags;
 
-	this_cpu = get_cpu();
+	get_online_cpus_stable_atomic();
+
+	this_cpu = smp_processor_id();
+
 	/*
 	 * Can deadlock when called with interrupts disabled.
 	 * We allow cpu's that are not yet online though, as no one else can
 	 * send smp call function interrupt to this cpu and as such deadlocks
 	 * can't happen.
 	 */
-	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
+	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
 		     && !oops_in_progress);
 
 	if (cpu == this_cpu) {
@@ -427,7 +433,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 		csd_lock(data);
 		generic_exec_single(cpu, data, wait);
 	}
-	put_cpu();
+	put_online_cpus_stable_atomic();
 }
 
 /**
@@ -451,6 +457,8 @@ void smp_call_function_many(const struct cpumask *mask,
 	unsigned long flags;
 	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
 
+	get_online_cpus_stable_atomic();
+
 	/*
 	 * Can deadlock when called with interrupts disabled.
 	 * We allow cpu's that are not yet online though, as no one else can
@@ -461,23 +469,24 @@ void smp_call_function_many(const struct cpumask *mask,
 		     && !oops_in_progress && !early_boot_irqs_disabled);
 
 	/* Try to fastpath.  So, what's a CPU they want? Ignoring this one. */
-	cpu = cpumask_first_and(mask, cpu_online_mask);
+	cpu = cpumask_first_and(mask, cpu_online_stable_mask);
 	if (cpu == this_cpu)
-		cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
+		cpu = cpumask_next_and(cpu, mask, cpu_online_stable_mask);
 
 	/* No online cpus?  We're done. */
 	if (cpu >= nr_cpu_ids)
-		return;
+		goto out_unlock;
 
 	/* Do we have another CPU which isn't us? */
-	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
+	next_cpu = cpumask_next_and(cpu, mask, cpu_online_stable_mask);
 	if (next_cpu == this_cpu)
-		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
+		next_cpu = cpumask_next_and(next_cpu, mask,
+						cpu_online_stable_mask);
 
 	/* Fastpath: do that cpu by itself. */
 	if (next_cpu >= nr_cpu_ids) {
 		smp_call_function_single(cpu, func, info, wait);
-		return;
+		goto out_unlock;
 	}
 
 	data = &__get_cpu_var(cfd_data);
@@ -516,14 +525,14 @@ void smp_call_function_many(const struct cpumask *mask,
 	smp_wmb();
 
 	/* We rely on the "and" being processed before the store */
-	cpumask_and(data->cpumask, mask, cpu_online_mask);
+	cpumask_and(data->cpumask, mask, cpu_online_stable_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
 	refs = cpumask_weight(data->cpumask);
 
 	/* Some callers race with other cpus changing the passed mask */
 	if (unlikely(!refs)) {
 		csd_unlock(&data->csd);
-		return;
+		goto out_unlock;
 	}
 
 	raw_spin_lock_irqsave(&call_function.lock, flags);
@@ -554,6 +563,9 @@ void smp_call_function_many(const struct cpumask *mask,
 	/* Optionally wait for the CPUs to complete */
 	if (wait)
 		csd_lock_wait(&data->csd);
+
+out_unlock:
+	put_online_cpus_stable_atomic();
 }
 EXPORT_SYMBOL(smp_call_function_many);
 
@@ -574,9 +586,9 @@ EXPORT_SYMBOL(smp_call_function_many);
  */
 int smp_call_function(smp_call_func_t func, void *info, int wait)
 {
-	preempt_disable();
-	smp_call_function_many(cpu_online_mask, func, info, wait);
-	preempt_enable();
+	get_online_cpus_stable_atomic();
+	smp_call_function_many(cpu_online_stable_mask, func, info, wait);
+	put_online_cpus_stable_atomic();
 
 	return 0;
 }

