Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab0I0UgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:36:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30638 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0I0UgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:36:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=HPqvD78Gr4TTN3bQj24dL9ntJcpiMfVIKJYpQ9DP18aokdWfyNlFzmPtaWehS+zAb
	MFbETUbIeLG+W6nf5XQrg==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] si time accounting accounts bh_disable'd time to si
Date: Mon, 27 Sep 2010 13:35:53 -0700
Message-Id: <1285619753-10892-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285003599.2275.756.camel@laptop>
References: <1285003599.2275.756.camel@laptop>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> > You still do have the problem with local_bh_disable() though, since you
>> >> > cannot distinguish between having bh disabled and processing softirq.
>> >> >
>> >> > So a hardirq that hits while you have bh disabled will inflate your
>> >> > softirq time.

>> >> Hmm, that bug is valid for CONFIG_VIRT_CPU_ACCOUNTING=y as well.
>> >
>> > And nobody ever noticed?
>> >
>> Yes. I inherited the API from VIRT_CPU_ACCOUNTING along with this
>> local_bh_disable bug. Agree that we need one extra bit to handle this
>> case. I will take a stab at fixing this along with refresh of this
>> patchset if no one else has beaten me to it until then.
>
>Make sure to only fix the softirq processing on the hardirq tail, not
> the ksoftirqd one :-)

softirq processing from hardirq tail and ksoftirqd are currently
handled in the same way and I didn't see any issues changing both of
them. Am I missing something?

Here's the patch I have for this. 

[PATCH] si time accounting accounts bh_disable'd time to si

Peter Zijlstra found a bug in the way softirq time is accounted in
VIRT_CPU_ACCOUNTING on this thread.
http://lkml.indiana.edu/hypermail//linux/kernel/1009.2/01366.html

The problem is, softirq processing uses local_bh_disable internally and there
would be no way later in the flow to differentiate between whether softirq is
being processed or is it just that bh has been disabled. So, a hardirq when bh
id disabled results in time being wrongly accounted for softirq.

Looking at the code a bit more, the problem exists in !VIRT_CPU_ACCOUNTING
as well. As account_system_time() in normal tick based accouting also uses
softirq_count, which will be set when not in softirq with bh disabled.

Peter also suggested solution of using 2 * SOFTIRQ_OFFSET as irq count
for local_bh_{disable,enable} and using just SOFTIRQ_OFFSET while softirq
processing. The patch below does that and adds API in_serving_softirq() which
returns whether we are currently processing softirq or not.

Also changes one of the usages of softirq_count in net/sched/cls_cgroup.c
to in_serving_softirq.

Looks like many usages of in_softirq really want in_serving_softirq. Those
changes can be made individually on a case by case basis.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 include/linux/hardirq.h |    3 ++
 include/linux/sched.h   |    2 +-
 kernel/sched.c          |    2 +-
 kernel/softirq.c        |   51 +++++++++++++++++++++++++++++++---------------
 net/sched/cls_cgroup.c  |    2 +-
 5 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index d5b3876..1c736ae 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -82,10 +82,13 @@
 /*
  * Are we doing bottom half or hardware interrupt processing?
  * Are we in a softirq context? Interrupt context?
+ * in_softirq answers - are we currently processing softirq or have bh disabled?
+ * in_serving_softirq answers - are we currently processing softirq?
  */
 #define in_irq()		(hardirq_count())
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
+#define in_serving_softirq()	(softirq_count() == SOFTIRQ_OFFSET)
 
 /*
  * Are we in NMI context?
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e2a6db..1c40289 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2368,7 +2368,7 @@ extern int __cond_resched_lock(spinlock_t *lock);
 extern int __cond_resched_softirq(void);
 
 #define cond_resched_softirq() ({				\
-	__might_sleep(__FILE__, __LINE__, SOFTIRQ_OFFSET);	\
+	__might_sleep(__FILE__, __LINE__, SOFTIRQ_OFFSET * 2);	\
 	__cond_resched_softirq();				\
 })
 
diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..b6e714b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3397,7 +3397,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	tmp = cputime_to_cputime64(cputime);
 	if (hardirq_count() - hardirq_offset)
 		cpustat->irq = cputime64_add(cpustat->irq, tmp);
-	else if (softirq_count())
+	else if (in_serving_softirq())
 		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 07b4f1b..7bfc67b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -77,11 +77,21 @@ void wakeup_softirqd(void)
 }
 
 /*
+ * preempt count and SOFTIRQ_OFFSET usage:
+ * - preempt count is changed by SOFTIRQ_OFFSET on entering or leaving
+ *   softirq processing.
+ * - preempt count is changed by 2 * SOFTIRQ_OFFSET on local_bh_disable or
+ *   local_bh_enable.
+ * This lets us distinguish between whether we are currently processing
+ * softirq and whether we have bh disabled.
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
+				2 * SOFTIRQ_OFFSET);
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
+	__local_bh_enable(2 * SOFTIRQ_OFFSET);
 }
 
 EXPORT_SYMBOL(_local_bh_enable);
@@ -147,13 +163,13 @@ static inline void _local_bh_enable_ip(unsigned long ip)
 	/*
 	 * Are softirqs going to be turned on now:
 	 */
-	if (softirq_count() == SOFTIRQ_OFFSET)
+	if (softirq_count() == 2 * SOFTIRQ_OFFSET)
 		trace_softirqs_on(ip);
 	/*
 	 * Keep preemption disabled until we are done with
 	 * softirq processing:
  	 */
- 	sub_preempt_count(SOFTIRQ_OFFSET - 1);
+	sub_preempt_count(2 * SOFTIRQ_OFFSET - 1);
 
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
-- 
1.7.1

