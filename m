Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab1C3VHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:39652 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426Ab1C3VHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133161"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: venki@google.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [97/275] sched: Fix softirq time accounting
Message-Id: <20110330210535.BE2633E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: 75e1056f5c57050415b64cb761a3acc35d91f013 upstream

Peter Zijlstra found a bug in the way softirq time is accounted in
VIRT_CPU_ACCOUNTING on this thread:

   http://lkml.indiana.edu/hypermail//linux/kernel/1009.2/01366.html

The problem is, softirq processing uses local_bh_disable internally. There
is no way, later in the flow, to differentiate between whether softirq is
being processed or is it just that bh has been disabled. So, a hardirq when bh
is disabled results in time being wrongly accounted as softirq.

Looking at the code a bit more, the problem exists in !VIRT_CPU_ACCOUNTING
as well. As account_system_time() in normal tick based accouting also uses
softirq_count, which will be set even when not in softirq with bh disabled.

Peter also suggested solution of using 2*SOFTIRQ_OFFSET as irq count
for local_bh_{disable,enable} and using just SOFTIRQ_OFFSET while softirq
processing. The patch below does that and adds API in_serving_softirq() which
returns whether we are currently processing softirq or not.

Also changes one of the usages of softirq_count in net/sched/cls_cgroup.c
to in_serving_softirq.

Looks like many usages of in_softirq really want in_serving_softirq. Those
changes can be made individually on a case by case basis.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1286237003-12406-2-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/hardirq.h |    5 ++++
 include/linux/sched.h   |    6 ++---
 kernel/sched.c          |    2 -
 kernel/softirq.c        |   51 ++++++++++++++++++++++++++++++++----------------
 net/sched/cls_cgroup.c  |    2 -
 5 files changed, 44 insertions(+), 22 deletions(-)

Index: linux-2.6.35.y/include/linux/hardirq.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/hardirq.h	2011-03-29 22:51:31.260923281 -0700
+++ linux-2.6.35.y/include/linux/hardirq.h	2011-03-29 23:55:02.073414123 -0700
@@ -64,6 +64,8 @@
 #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
 #define NMI_OFFSET	(1UL << NMI_SHIFT)
 
+#define SOFTIRQ_DISABLE_OFFSET	(2 * SOFTIRQ_OFFSET)
+
 #ifndef PREEMPT_ACTIVE
 #define PREEMPT_ACTIVE_BITS	1
 #define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
@@ -82,10 +84,13 @@
 /*
  * Are we doing bottom half or hardware interrupt processing?
  * Are we in a softirq context? Interrupt context?
+ * in_softirq - Are we currently processing softirq or have bh disabled?
+ * in_serving_softirq - Are we currently processing softirq?
  */
 #define in_irq()		(hardirq_count())
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
+#define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
 
 /*
  * Are we in NMI context?
Index: linux-2.6.35.y/include/linux/sched.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/sched.h	2011-03-29 22:51:31.259923307 -0700
+++ linux-2.6.35.y/include/linux/sched.h	2011-03-29 23:55:01.610425970 -0700
@@ -2363,9 +2363,9 @@
 
 extern int __cond_resched_softirq(void);
 
-#define cond_resched_softirq() ({				\
-	__might_sleep(__FILE__, __LINE__, SOFTIRQ_OFFSET);	\
-	__cond_resched_softirq();				\
+#define cond_resched_softirq() ({					\
+	__might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET);	\
+	__cond_resched_softirq();					\
 })
 
 /*
Index: linux-2.6.35.y/kernel/sched.c
===================================================================
--- linux-2.6.35.y.orig/kernel/sched.c	2011-03-29 23:03:00.067298448 -0700
+++ linux-2.6.35.y/kernel/sched.c	2011-03-29 23:55:00.770447463 -0700
@@ -3363,7 +3363,7 @@
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-	else if (softirq_count())
+	else if (in_serving_softirq())
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
Index: linux-2.6.35.y/kernel/softirq.c
===================================================================
--- linux-2.6.35.y.orig/kernel/softirq.c	2011-03-29 22:51:31.259923307 -0700
+++ linux-2.6.35.y/kernel/softirq.c	2011-03-29 23:55:01.200436460 -0700
@@ -77,11 +77,21 @@
 }
 
 /*
+ * preempt_count and SOFTIRQ_OFFSET usage:
+ * - preempt_count is changed by SOFTIRQ_OFFSET on entering or leaving
+ *   softirq processing.
+ * - preempt_count is changed by SOFTIRQ_DISABLE_OFFSET (= 2 * SOFTIRQ_OFFSET)
+ *   on local_bh_disable or local_bh_enable.
+ * This lets us distinguish between whether we are currently processing
+ * softirq and whether we just have bh disabled.
+ */
+
+/*
  * This one is for softirq.c-internal use,
  * where hardirqs are disabled legitimately:
  */
 #ifdef CONFIG_TRACE_IRQFLAGS
-static void __local_bh_disable(unsigned long ip)
+static void __local_bh_disable(unsigned long ip, unsigned int cnt)
 {
 	unsigned long flags;
 
@@ -95,32 +105,43 @@
 	 * We must manually increment preempt_count here and manually
 	 * call the trace_preempt_off later.
 	 */
-	preempt_count() += SOFTIRQ_OFFSET;
+	preempt_count() += cnt;
 	/*
 	 * Were softirqs turned off above:
 	 */
-	if (softirq_count() == SOFTIRQ_OFFSET)
+	if (softirq_count() == cnt)
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
 
-	if (preempt_count() == SOFTIRQ_OFFSET)
+	if (preempt_count() == cnt)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 #else /* !CONFIG_TRACE_IRQFLAGS */
-static inline void __local_bh_disable(unsigned long ip)
+static inline void __local_bh_disable(unsigned long ip, unsigned int cnt)
 {
-	add_preempt_count(SOFTIRQ_OFFSET);
+	add_preempt_count(cnt);
 	barrier();
 }
 #endif /* CONFIG_TRACE_IRQFLAGS */
 
 void local_bh_disable(void)
 {
-	__local_bh_disable((unsigned long)__builtin_return_address(0));
+	__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_DISABLE_OFFSET);
 }
 
 EXPORT_SYMBOL(local_bh_disable);
 
+static void __local_bh_enable(unsigned int cnt)
+{
+	WARN_ON_ONCE(in_irq());
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (softirq_count() == cnt)
+		trace_softirqs_on((unsigned long)__builtin_return_address(0));
+	sub_preempt_count(cnt);
+}
+
 /*
  * Special-case - softirqs can safely be enabled in
  * cond_resched_softirq(), or by __do_softirq(),
@@ -128,12 +149,7 @@
  */
 void _local_bh_enable(void)
 {
-	WARN_ON_ONCE(in_irq());
-	WARN_ON_ONCE(!irqs_disabled());
-
-	if (softirq_count() == SOFTIRQ_OFFSET)
-		trace_softirqs_on((unsigned long)__builtin_return_address(0));
-	sub_preempt_count(SOFTIRQ_OFFSET);
+	__local_bh_enable(SOFTIRQ_DISABLE_OFFSET);
 }
 
 EXPORT_SYMBOL(_local_bh_enable);
@@ -147,13 +163,13 @@
 	/*
 	 * Are softirqs going to be turned on now:
 	 */
-	if (softirq_count() == SOFTIRQ_OFFSET)
+	if (softirq_count() == SOFTIRQ_DISABLE_OFFSET)
 		trace_softirqs_on(ip);
 	/*
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
  	 */
- 	sub_preempt_count(SOFTIRQ_OFFSET - 1);
+	sub_preempt_count(SOFTIRQ_DISABLE_OFFSET - 1);
 
 	if (unlikely(!in_interrupt() && local_softirq_pending()))
 		do_softirq();
@@ -198,7 +214,8 @@
 	pending = local_softirq_pending();
 	account_system_vtime(current);
 
-	__local_bh_disable((unsigned long)__builtin_return_address(0));
+	__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
@@ -245,7 +262,7 @@
 	lockdep_softirq_exit();
 
 	account_system_vtime(current);
-	_local_bh_enable();
+	__local_bh_enable(SOFTIRQ_OFFSET);
 }
 
 #ifndef __ARCH_HAS_DO_SOFTIRQ
Index: linux-2.6.35.y/net/sched/cls_cgroup.c
===================================================================
--- linux-2.6.35.y.orig/net/sched/cls_cgroup.c	2011-03-29 22:51:31.259923307 -0700
+++ linux-2.6.35.y/net/sched/cls_cgroup.c	2011-03-29 23:03:00.153296248 -0700
@@ -121,7 +121,7 @@
 	 * calls by looking at the number of nested bh disable calls because
 	 * softirqs always disables bh.
 	 */
-	if (softirq_count() != SOFTIRQ_OFFSET) {
+	if (in_serving_softirq()) {
 		/* If there is an sk_classid we'll use that. */
 		if (!skb->sk)
 			return -1;
