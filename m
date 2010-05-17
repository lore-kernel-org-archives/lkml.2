Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab0EQTD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:03:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:7101 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab0EQTCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:02:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="278095801"
Message-Id: <20100517184027.680459666@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:27:28 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 2/7] softirq: add init_remote_softirq_csd()
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=add_init_remote_softirq_csd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently send_remote_softirq() API's don't allow single call_single_data
struct(like per cpu call_single_data) to be used with multiple
send_remote_softirq() calls in parallel (as each of the send_remote_softirq()
call reinitializes the call_single_data overwriting the inflight usage.

Add a new init_remote_softirq_csd() which will init the call_single_data.
Second send_remote_softirq() from the same cpu will now wait on the csd_lock()
if the prior send_remote_softirq() is not complete.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/interrupt.h |    8 ++++++--
 kernel/softirq.c          |   41 +++++++++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 16 deletions(-)

Index: tip/kernel/softirq.c
===================================================================
--- tip.orig/kernel/softirq.c
+++ tip/kernel/softirq.c
@@ -578,24 +578,23 @@ static void remote_softirq_receive(void 
 	local_irq_restore(flags);
 }
 
-static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
+static int __try_remote_softirq(struct call_single_data *cp, int cpu)
 {
 	if (cpu_online(cpu)) {
-		cp->func = remote_softirq_receive;
-		cp->info = cp;
-		cp->flags = 0;
-		cp->priv = softirq;
-
 		__smp_call_function_single(cpu, cp, 0);
 		return 0;
 	}
 	return 1;
 }
 #else /* CONFIG_USE_GENERIC_SMP_HELPERS */
-static int __try_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
+static int __try_remote_softirq(struct call_single_data *cp, int cpu)
 {
 	return 1;
 }
+static void remote_softirq_receive(void *data)
+{
+	return;
+}
 #endif
 
 /**
@@ -611,12 +610,12 @@ static int __try_remote_softirq(struct c
  * Interrupts must be disabled.
  */
 void __send_remote_softirq(struct call_single_data *cp, int cpu, int this_cpu,
-			   int softirq, int fallback)
+			   int fallback)
 {
 	if (cpu == this_cpu)
-		__local_trigger(cp, softirq);
-	else if (__try_remote_softirq(cp, cpu, softirq) && fallback)
-		__local_trigger(cp, softirq);
+		__local_trigger(cp, cp->priv);
+	else if (__try_remote_softirq(cp, cpu) && fallback)
+		__local_trigger(cp, cp->priv);
 }
 EXPORT_SYMBOL(__send_remote_softirq);
 
@@ -629,19 +628,33 @@ EXPORT_SYMBOL(__send_remote_softirq);
  * Like __send_remote_softirq except that disabling interrupts and
  * computing the current cpu is done for the caller.
  */
-void send_remote_softirq(struct call_single_data *cp, int cpu, int softirq,
-			 int fallback)
+void send_remote_softirq(struct call_single_data *cp, int cpu, int fallback)
 {
 	unsigned long flags;
 	int this_cpu;
 
 	local_irq_save(flags);
 	this_cpu = smp_processor_id();
-	__send_remote_softirq(cp, cpu, this_cpu, softirq, fallback);
+	__send_remote_softirq(cp, cpu, this_cpu, fallback);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(send_remote_softirq);
 
+/***
+ * init_remote_softirq_csd - initialize the smp_call_function_single()'s
+ * call single data that will be later used by send_remote_softirq()
+ * @cp: private SMP call function data area to be initialized
+ * @softirq: the softirq to be used for the work
+ */
+void init_remote_softirq_csd(struct call_single_data *cp, int softirq)
+{
+	cp->func = remote_softirq_receive;
+	cp->info = cp;
+	cp->flags = 0;
+	cp->priv = softirq;
+}
+EXPORT_SYMBOL(init_remote_softirq_csd);
+
 static int __cpuinit remote_softirq_cpu_notify(struct notifier_block *self,
 					       unsigned long action, void *hcpu)
 {
Index: tip/include/linux/interrupt.h
===================================================================
--- tip.orig/include/linux/interrupt.h
+++ tip/include/linux/interrupt.h
@@ -420,13 +420,17 @@ DECLARE_PER_CPU(struct list_head [NR_SOF
  * work will be queued to the local cpu.
  */
 extern void send_remote_softirq(struct call_single_data *cp, int cpu,
-				int softirq, int fallback);
+				int fallback);
 
 /* Like send_remote_softirq(), but the caller must disable local cpu interrupts
  * and compute the current cpu, passed in as 'this_cpu'.
  */
 extern void __send_remote_softirq(struct call_single_data *cp, int cpu,
-				  int this_cpu, int softirq, int fallback);
+				  int this_cpu, int fallback);
+
+/* Initialize the call_single_data to be later used with send_remote_softirq().
+ */
+extern void init_remote_softirq_csd(struct call_single_data *cp, int softirq);
 
 /* Tasklets --- multithreaded analogue of BHs.
 


