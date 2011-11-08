Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1KHEaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 23:30:12 -0500
Received: from smtp-out.google.com ([74.125.121.67]:10540 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab1KHE3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 23:29:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:subject:references:
	content-disposition:x-system-of-record;
	b=ZIVB4+xBWWGicE4Qi33YGTodHKQvZ/7dnpvx/iAODJhbtaCThXfNI58AuI5d4uElE
	RTLUCVcNN8JPU1pwC38iQ==
Message-Id: <20111108042736.560831357@google.com>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:26:33 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/3] sched: use jump labels to reduce overhead when bandwidth control is inactive
References: <20111108042632.977080206@google.com>
Content-Disposition: inline; filename=sched-bwc-add_jump_labels.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the linkage of jump-labels has been fixed they show a measurable
improvement in overhead for the enabled-but-unused case.

Workload is:
'taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches
bash -c "for ((i=0;i<5;i++)); do $(dirname $0)/pipe-test 20000; done"'

                instructions            cycles                  branches
-------------------------------------------------------------------------
Intel Westmere
base            806611770               745895590               146765378
+jumplabel      803090165 (-0.44)       713381840 (-4.36)       144561130

AMD Barcelona
base            824657415               740055589               148855354
+jumplabel      821056910 (-0.44)       737558389 (-0.34)       146635229


Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |   33 +++++++++++++++++++++++++++++++--
 kernel/sched_fair.c |   17 +++++++++++++----
 2 files changed, 44 insertions(+), 6 deletions(-)

Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/jump_label.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -502,7 +503,32 @@ static void destroy_cfs_bandwidth(struct
 	hrtimer_cancel(&cfs_b->period_timer);
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
-#else
+
+#ifdef HAVE_JUMP_LABEL
+static struct jump_label_key __cfs_bandwidth_used;
+
+static inline bool cfs_bandwidth_used(void)
+{
+	return static_branch(&__cfs_bandwidth_used);
+}
+
+static void account_cfs_bandwidth_used(int enabled, int was_enabled)
+{
+	/* only need to count groups transitioning between enabled/!enabled */
+	if (enabled && !was_enabled)
+		jump_label_inc(&__cfs_bandwidth_used);
+	else if (!enabled && was_enabled)
+		jump_label_dec(&__cfs_bandwidth_used);
+}
+#else /* !HAVE_JUMP_LABEL */
+/* static_branch doesn't help unless supported */
+static int cfs_bandwidth_used(void)
+{
+	return 1;
+}
+static void account_cfs_bandwidth_used(int enabled, int was_enabled) {}
+#endif /* HAVE_JUMP_LABEL */
+#else /* !CONFIG_CFS_BANDWIDTH */
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
 static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
@@ -9188,7 +9214,7 @@ static int __cfs_schedulable(struct task
 
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
-	int i, ret = 0, runtime_enabled;
+	int i, ret = 0, runtime_enabled, runtime_was_enabled;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
 
 	if (tg == &root_task_group)
@@ -9216,6 +9242,9 @@ static int tg_set_cfs_bandwidth(struct t
 		goto out_unlock;
 
 	runtime_enabled = quota != RUNTIME_INF;
+	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
+	account_cfs_bandwidth_used(runtime_enabled, runtime_was_enabled);
+
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1408,7 +1408,7 @@ static void __account_cfs_rq_runtime(str
 static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 						   unsigned long delta_exec)
 {
-	if (!cfs_rq->runtime_enabled)
+	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
 
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
@@ -1416,13 +1416,13 @@ static __always_inline void account_cfs_
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
-	return cfs_rq->throttled;
+	return cfs_bandwidth_used() && cfs_rq->throttled;
 }
 
 /* check whether cfs_rq, or any parent, is throttled */
 static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
 {
-	return cfs_rq->throttle_count;
+	return cfs_bandwidth_used() && cfs_rq->throttle_count;
 }
 
 /*
@@ -1743,6 +1743,9 @@ static void __return_cfs_rq_runtime(stru
 
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	if (!cfs_rq->runtime_enabled || !cfs_rq->nr_running)
 		return;
 
@@ -1788,6 +1791,9 @@ static void do_sched_cfs_slack_timer(str
  */
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	/* an active group must be handled by the update_curr()->put() path */
 	if (!cfs_rq->runtime_enabled || cfs_rq->curr)
 		return;
@@ -1805,6 +1811,9 @@ static void check_enqueue_throttle(struc
 /* conditionally throttle active cfs_rq's from put_prev_entity() */
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
 		return;
 


