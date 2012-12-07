Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181Ab2LGRkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:40:23 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54651 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964891Ab2LGRkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:40:19 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v3 3/9] smp,
 cpu hotplug: Fix smp_call_function_*() to prevent CPU offline properly
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        oleg@redhat.com
Cc: sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        srivatsa.bhat@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 23:08:44 +0530
Message-ID: <20121207173842.27305.52029.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120717-7014-0000-0000-000002500412
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once stop_machine() is gone from the CPU offline path, we won't be able to
depend on preempt_disable() to prevent CPUs from going offline from under us.

Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going offline,
while invoking from atomic context.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/smp.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 29dd40a..ce1a866 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -310,7 +310,8 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 	 * prevent preemption and reschedule on another processor,
 	 * as well as CPU removal
 	 */
-	this_cpu = get_cpu();
+	get_online_cpus_atomic();
+	this_cpu = smp_processor_id();
 
 	/*
 	 * Can deadlock when called with interrupts disabled.
@@ -342,7 +343,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 		}
 	}
 
-	put_cpu();
+	put_online_cpus_atomic();
 
 	return err;
 }
@@ -371,8 +372,10 @@ int smp_call_function_any(const struct cpumask *mask,
 	const struct cpumask *nodemask;
 	int ret;
 
+	get_online_cpus_atomic();
 	/* Try for same CPU (cheapest) */
-	cpu = get_cpu();
+	cpu = smp_processor_id();
+
 	if (cpumask_test_cpu(cpu, mask))
 		goto call;
 
@@ -388,7 +391,7 @@ int smp_call_function_any(const struct cpumask *mask,
 	cpu = cpumask_any_and(mask, cpu_online_mask);
 call:
 	ret = smp_call_function_single(cpu, func, info, wait);
-	put_cpu();
+	put_online_cpus_atomic();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(smp_call_function_any);
@@ -409,14 +412,17 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 	unsigned int this_cpu;
 	unsigned long flags;
 
-	this_cpu = get_cpu();
+	get_online_cpus_atomic();
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
+	put_online_cpus_atomic();
 }
 
 /**
@@ -451,6 +457,8 @@ void smp_call_function_many(const struct cpumask *mask,
 	unsigned long flags;
 	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
 
+	get_online_cpus_atomic();
+
 	/*
 	 * Can deadlock when called with interrupts disabled.
 	 * We allow cpu's that are not yet online though, as no one else can
@@ -467,17 +475,18 @@ void smp_call_function_many(const struct cpumask *mask,
 
 	/* No online cpus?  We're done. */
 	if (cpu >= nr_cpu_ids)
-		return;
+		goto out_unlock;
 
 	/* Do we have another CPU which isn't us? */
 	next_cpu = cpumask_next_and(cpu, mask, cpu_online_mask);
 	if (next_cpu == this_cpu)
-		next_cpu = cpumask_next_and(next_cpu, mask, cpu_online_mask);
+		next_cpu = cpumask_next_and(next_cpu, mask,
+						cpu_online_mask);
 
 	/* Fastpath: do that cpu by itself. */
 	if (next_cpu >= nr_cpu_ids) {
 		smp_call_function_single(cpu, func, info, wait);
-		return;
+		goto out_unlock;
 	}
 
 	data = &__get_cpu_var(cfd_data);
@@ -523,7 +532,7 @@ void smp_call_function_many(const struct cpumask *mask,
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
+	put_online_cpus_atomic();
 }
 EXPORT_SYMBOL(smp_call_function_many);
 
@@ -574,9 +586,9 @@ EXPORT_SYMBOL(smp_call_function_many);
  */
 int smp_call_function(smp_call_func_t func, void *info, int wait)
 {
-	preempt_disable();
+	get_online_cpus_atomic();
 	smp_call_function_many(cpu_online_mask, func, info, wait);
-	preempt_enable();
+	put_online_cpus_atomic();
 
 	return 0;
 }

