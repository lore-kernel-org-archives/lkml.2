Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964884Ab1FWSWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:22:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:61110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933236Ab1FWSWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:22:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,414,1304319600"; 
   d="scan'208";a="17426697"
Message-Id: <20110623182056.807230326@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 23 Jun 2011 11:19:26 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@suse.de,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com, stable@kernel.org
Subject: [patch v2 1/4] x86, mtrr: lock stop machine during MTRR rendezvous sequence
References: <20110623181925.983511592@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=mtrr_stop_machine_quick_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

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
Cc: stable@kernel.org # 2.6.35+, backport a week or two after this gets more testing in mainline
---
 arch/x86/kernel/cpu/mtrr/main.c |   23 +++++++++++++++++++++++
 include/linux/stop_machine.h    |    2 ++
 kernel/stop_machine.c           |    2 +-
 3 files changed, 26 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6-tip/arch/x86/kernel/cpu/mtrr/main.c
@@ -248,6 +248,25 @@ set_mtrr(unsigned int reg, unsigned long
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
@@ -330,6 +349,10 @@ set_mtrr(unsigned int reg, unsigned long
 
 	local_irq_restore(flags);
 	preempt_enable();
+#ifdef CONFIG_SMP
+	if (cpu_active(raw_smp_processor_id()))
+		mutex_unlock(&stop_cpus_mutex);
+#endif
 }
 
 /**
Index: linux-2.6-tip/include/linux/stop_machine.h
===================================================================
--- linux-2.6-tip.orig/include/linux/stop_machine.h
+++ linux-2.6-tip/include/linux/stop_machine.h
@@ -27,6 +27,8 @@ struct cpu_stop_work {
 	struct cpu_stop_done	*done;
 };
 
+extern struct mutex stop_cpus_mutex;
+
 int stop_one_cpu(unsigned int cpu, cpu_stop_fn_t fn, void *arg);
 void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 			 struct cpu_stop_work *work_buf);
Index: linux-2.6-tip/kernel/stop_machine.c
===================================================================
--- linux-2.6-tip.orig/kernel/stop_machine.c
+++ linux-2.6-tip/kernel/stop_machine.c
@@ -132,8 +132,8 @@ void stop_one_cpu_nowait(unsigned int cp
 	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), work_buf);
 }
 
+DEFINE_MUTEX(stop_cpus_mutex);
 /* static data for stop_cpus */
-static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)


