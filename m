Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab1G1XqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:46:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:32321 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab1G1Xoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32809084"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: suresh.b.siddha@intel.com, ak@linux.intel.com, stable@kernel.org,
        #@linux.intel.com, 2.6.35+@linux.intel.com, backport@linux.intel.com,
        a@linux.intel.com, week@linux.intel.com, or@linux.intel.com,
        two@linux.intel.com, after@linux.intel.com, this@linux.intel.com,
        gets@linux.intel.com, more@linux.intel.com, testing@linux.intel.com,
        in@linux.intel.com, mainline@linux.intel.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [49/50] x86, mtrr: lock stop machine during MTRR rendezvous sequence
Message-Id: <20110728234454.2DEE52403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Suresh Siddha <suresh.b.siddha@intel.com>

[ upstream commit 6d3321e8e2b3bf6a5892e2ef673c7bf536e3f904 ]

MTRR rendezvous sequence using stop_one_cpu_nowait() can potentially
happen in parallel with another system wide rendezvous using
stop_machine(). This can lead to deadlock (The order in which
works are queued can be different on different cpu's. Some cpu's
will be running the first rendezvous handler and others will be running
the second rendezvous handler. Each set waiting for the other set to join
for the system wide rendezvous, leading to a deadlock).

MTRR rendezvous sequence is not implemented using stop_machine() as this
gets called both from the process context aswell as the cpu online paths
(where the cpu has not come online and the interrupts are disabled etc).
stop_machine() works with only online cpus.

For now, take the stop_machine mutex in the MTRR rendezvous sequence that
gets called from an online cpu (here we are in the process context
and can potentially sleep while taking the mutex). And the MTRR rendezvous
that gets triggered during cpu online doesn't need to take this stop_machine
lock (as the stop_machine() already ensures that there is no cpu hotplug
going on in parallel by doing get_online_cpus())

    TBD: Pursue a cleaner solution of extending the stop_machine()
         infrastructure to handle the case where the calling cpu is
         still not online and use this for MTRR rendezvous sequence.

fixes: https://bugzilla.novell.com/show_bug.cgi?id=672008

Reported-by: Vadim Kotelnikov <vadimuzzz@inbox.ru>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/20110623182056.807230326@sbsiddha-MOBL3.sc.intel.com
Cc: stable@kernel.org # 2.6.35+, backport a week or two after this gets more testing in mainline
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Index: linux-2.6.35.y/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/mtrr/main.c
@@ -247,6 +247,25 @@ set_mtrr(unsigned int reg, unsigned long
 	unsigned long flags;
 	int cpu;
 
+#ifdef CONFIG_SMP
+	/*
+	 * If this cpu is not yet active, we are in the cpu online path. There
+	 * can be no stop_machine() in parallel, as stop machine ensures this
+	 * by using get_online_cpus(). We can skip taking the stop_cpus_mutex,
+	 * as we don't need it and also we can't afford to block while waiting
+	 * for the mutex.
+	 *
+	 * If this cpu is active, we need to prevent stop_machine() happening
+	 * in parallel by taking the stop cpus mutex.
+	 *
+	 * Also, this is called in the context of cpu online path or in the
+	 * context where cpu hotplug is prevented. So checking the active status
+	 * of the raw_smp_processor_id() is safe.
+	 */
+	if (cpu_active(raw_smp_processor_id()))
+		mutex_lock(&stop_cpus_mutex);
+#endif
+
 	preempt_disable();
 
 	data.smp_reg = reg;
@@ -329,6 +348,10 @@ set_mtrr(unsigned int reg, unsigned long
 
 	local_irq_restore(flags);
 	preempt_enable();
+#ifdef CONFIG_SMP
+	if (cpu_active(raw_smp_processor_id()))
+		mutex_unlock(&stop_cpus_mutex);
+#endif
 }
 
 /**
Index: linux-2.6.35.y/include/linux/stop_machine.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/stop_machine.h
+++ linux-2.6.35.y/include/linux/stop_machine.h
@@ -27,6 +27,8 @@ struct cpu_stop_work {
 	struct cpu_stop_done	*done;
 };
 
+extern struct mutex stop_cpus_mutex;
+
 int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg);
 void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 			 struct cpu_stop_work *work_buf);
Index: linux-2.6.35.y/kernel/stop_machine.c
===================================================================
--- linux-2.6.35.y.orig/kernel/stop_machine.c
+++ linux-2.6.35.y/kernel/stop_machine.c
@@ -132,8 +132,8 @@ void stop_one_cpu_nowait(unsigned int cp
 	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), work_buf);
 }
 
+DEFINE_MUTEX(stop_cpus_mutex);
 /* static data for stop_cpus */
-static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
