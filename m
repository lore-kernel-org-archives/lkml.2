Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab0JRTZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:25:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:35249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab0JRTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:25:05 -0400
Date: Mon, 18 Oct 2010 19:24:35 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
In-Reply-To: <1286237003-12406-2-git-send-email-venki@google.com>
References: <1286237003-12406-2-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix softirq time accounting
Message-ID: <tip-75e1056f5c57050415b64cb761a3acc35d91f013@git.kernel.org>
Git-Commit-ID: 75e1056f5c57050415b64cb761a3acc35d91f013
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:24:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  75e1056f5c57050415b64cb761a3acc35d91f013
Gitweb:     http://git.kernel.org/tip/75e1056f5c57050415b64cb761a3acc35d91f013
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon, 4 Oct 2010 17:03:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:20 +0200

sched: Fix softirq time accounting

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
LKML-Reference: <1286237003-12406-2-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hardirq.h |    5 ++++
 include/linux/sched.h   |    6 ++--
 kernel/sched.c          |    2 +-
 kernel/softirq.c        |   51 +++++++++++++++++++++++++++++++---------------
 net/sched/cls_cgroup.c  |    2 +-
 5 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..e37a77c 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cdf5669..8744e50 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2366,9 +2366,9 @@ extern int __cond_resched_lock(spinlock_t *lock);
 
 extern int __cond_resched_softirq(void);
 
-#define cond_resched_softirq() ({				\
-	__might_sleep(__FILE__, __LINE__, SOFTIRQ_OFFSET);	\
-	__cond_resched_softirq();				\
+#define cond_resched_softirq() ({					\
+	__might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET);	\
+	__cond_resched_softirq();					\
 })
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 771b518..089be8a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3422,7 +3422,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-	else if (softirq_count())
+	else if (in_serving_softirq())
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 07b4f1b..988dfbe 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -77,11 +77,21 @@ void wakeup_softirqd(void)
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
 
@@ -95,32 +105,43 @@ static void __local_bh_disable(unsigned long ip)
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
@@ -128,12 +149,7 @@ EXPORT_SYMBOL(local_bh_disable);
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
@@ -147,13 +163,13 @@ static inline void _local_bh_enable_ip(unsigned long ip)
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
@@ -198,7 +214,8 @@ asmlinkage void __do_softirq(void)
 	pending = local_softirq_pending();
 	account_system_vtime(current);
 
-	__local_bh_disable((unsigned long)__builtin_return_address(0));
+	__local_bh_disable((unsigned long)__builtin_return_address(0),
+				SOFTIRQ_OFFSET);
 	lockdep_softirq_enter();
 
 	cpu = smp_processor_id();
@@ -245,7 +262,7 @@ restart:
 	lockdep_softirq_exit();
 
 	account_system_vtime(current);
-	_local_bh_enable();
+	__local_bh_enable(SOFTIRQ_OFFSET);
 }
 
 #ifndef __ARCH_HAS_DO_SOFTIRQ
diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 78ef2c5..37dff78 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -123,7 +123,7 @@ static int cls_cgroup_classify(struct sk_buff *skb, struct tcf_proto *tp,
 	 * calls by looking at the number of nested bh disable calls because
 	 * softirqs always disables bh.
 	 */
-	if (softirq_count() != SOFTIRQ_OFFSET) {
+	if (in_serving_softirq()) {
 		/* If there is an sk_classid we'll use that. */
 		if (!skb->sk)
 			return -1;
