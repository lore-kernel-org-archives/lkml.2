Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab1FVWbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:31:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:30727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab1FVWbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:31:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,408,1304319600"; 
   d="scan'208";a="17109254"
Message-Id: <20110622222043.862589370@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 22 Jun 2011 15:20:22 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com, stable@kernel.org
Subject: [patch 1/4] x86, mtrr: lock stop machine during MTRR rendezvous sequence
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
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

(will be forwarded to stable series for inclusion in kernels v2.6.35-v2.6.39
 after some testing in mainline).

Reported-by: Vadim Kotelnikov <vadimuzzz@inbox.ru>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org # 2.6.35+, backport a week or two after this gets more testing in mainline
---
 arch/x86/kernel/cpu/mtrr/main.c |   16 ++++++++++++++++
 include/linux/stop_machine.h    |    2 ++
 kernel/stop_machine.c           |    2 +-
 3 files changed, 19 insertions(+), 1 deletion(-)

Index: linux-2.6-tip/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6-tip/arch/x86/kernel/cpu/mtrr/main.c
@@ -248,6 +248,18 @@ set_mtrr(unsigned int reg, unsigned long
 	unsigned long flags;
 	int cpu;
 
+#ifdef CONFIG_SMP
+	/*
+	 * If we are not yet online, then there can be no stop_machine() in
+	 * parallel. Stop machine ensures this by using get_online_cpus().
+	 *
+	 * If we are online, then we need to prevent a stop_machine() happening
+	 * in parallel by taking the stop cpus mutex.
+	 */
+	if (cpu_online(raw_smp_processor_id()))
+		mutex_lock(&stop_cpus_mutex);
+#endif
+
 	preempt_disable();
 
 	data.smp_reg = reg;
@@ -330,6 +342,10 @@ set_mtrr(unsigned int reg, unsigned long
 
 	local_irq_restore(flags);
 	preempt_enable();
+#ifdef CONFIG_SMP
+	if (cpu_online(raw_smp_processor_id()))
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


