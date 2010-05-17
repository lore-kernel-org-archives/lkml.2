Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0EQTCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:02:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:11756 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab0EQTCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:02:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="799226219"
Message-Id: <20100517184027.591595902@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 17 May 2010 11:27:27 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, ego@in.ibm.com,
       LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/7] softirq: Add a no local fallback option to send_remote_softirq
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=no_local_fallback_option_to_send_remote_sofitq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venkatesh Pallipadi <venki@google.com>
Subject: softirq: Add a no local fallback option to send_remote_softirq
send_remote_softirq and __send_remote_softirq fallback to triggering
the softirq on local CPU when __try_remote_softirq fails. In certain
circumstances (like the SCHED_SOFTIRQ usage in following patch), the
softirq should only run on target CPUs if it runs. This new option helps
such callers.

As there seem to be no current users of send_remote_softirq in tree
today, added this option to current API instead of introducing a new
API.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/interrupt.h |    5 +++--
 kernel/softirq.c          |   12 ++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

Index: tip/include/linux/interrupt.h
===================================================================
--- tip.orig/include/linux/interrupt.h
+++ tip/include/linux/interrupt.h
@@ -419,13 +419,14 @@ DECLARE_PER_CPU(struct list_head [NR_SOF
 /* Try to send a softirq to a remote cpu.  If this cannot be done, the
  * work will be queued to the local cpu.
  */
-extern void send_remote_softirq(struct call_single_data *cp, int cpu, int softirq);
+extern void send_remote_softirq(struct call_single_data *cp, int cpu,
+				int softirq, int fallback);
 
 /* Like send_remote_softirq(), but the caller must disable local cpu interrupts
  * and compute the current cpu, passed in as 'this_cpu'.
  */
 extern void __send_remote_softirq(struct call_single_data *cp, int cpu,
-				  int this_cpu, int softirq);
+				  int this_cpu, int softirq, int fallback);
 
 /* Tasklets --- multithreaded analogue of BHs.
 
Index: tip/kernel/softirq.c
===================================================================
--- tip.orig/kernel/softirq.c
+++ tip/kernel/softirq.c
@@ -610,9 +610,12 @@ static int __try_remote_softirq(struct c
  *
  * Interrupts must be disabled.
  */
-void __send_remote_softirq(struct call_single_data *cp, int cpu, int this_cpu, int softirq)
+void __send_remote_softirq(struct call_single_data *cp, int cpu, int this_cpu,
+			   int softirq, int fallback)
 {
-	if (cpu == this_cpu || __try_remote_softirq(cp, cpu, softirq))
+	if (cpu == this_cpu)
+		__local_trigger(cp, softirq);
+	else if (__try_remote_softirq(cp, cpu, softirq) && fallback)
 		__local_trigger(cp, softirq);
 }
 EXPORT_SYMBOL(__send_remote_softirq);
@@ -626,14 +629,15 @@ EXPORT_SYMBOL(__send_remote_softirq);
  * Like __send_remote_softirq except that disabling interrupts and
  * computing the current cpu is done for the caller.
  */
-void send_remote_softirq(struct call_single_data *cp, int cpu, int softirq)
+void send_remote_softirq(struct call_single_data *cp, int cpu, int softirq,
+			 int fallback)
 {
 	unsigned long flags;
 	int this_cpu;
 
 	local_irq_save(flags);
 	this_cpu = smp_processor_id();
-	__send_remote_softirq(cp, cpu, this_cpu, softirq);
+	__send_remote_softirq(cp, cpu, this_cpu, softirq, fallback);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(send_remote_softirq);


