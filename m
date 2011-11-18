Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1KRXmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:42:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53487 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab1KRXmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:42:32 -0500
Date: Fri, 18 Nov 2011 15:42:12 -0800
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-56f570e512eeb5b412cb3a62234adc446a8eb32b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111108042736.560831357@google.com>
References: <20111108042736.560831357@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use jump labels to reduce overhead when bandwidth control is inactive
Git-Commit-ID: 56f570e512eeb5b412cb3a62234adc446a8eb32b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:42:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56f570e512eeb5b412cb3a62234adc446a8eb32b
Gitweb:     http://git.kernel.org/tip/56f570e512eeb5b412cb3a62234adc446a8eb32b
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 7 Nov 2011 20:26:33 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Nov 2011 08:48:18 +0100

sched: Use jump labels to reduce overhead when bandwidth control is inactive

Now that the linkage of jump-labels has been fixed they show a measurable
improvement in overhead for the enabled-but-unused case.

Workload is:

 'taskset -c 0 perf stat --repeat 50 -e instructions,cycles,branches
  bash -c "for ((i=0;i<5;i++)); do $(dirname $0)/pipe-test 20000; done"'

There's a speedup for all situations:

                 instructions            cycles                  branches
 -------------------------------------------------------------------------
 Intel Westmere
 base            806611770               745895590               146765378
 +jumplabel      803090165 (-0.44%)      713381840 (-4.36%)      144561130

 AMD Barcelona
 base            824657415               740055589               148855354
 +jumplabel      821056910 (-0.44%)      737558389 (-0.34%)      146635229

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111108042736.560831357@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   33 +++++++++++++++++++++++++++++++--
 kernel/sched_fair.c |   15 ++++++++++++---
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d6b149c..d9d79a4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -72,6 +72,7 @@
 #include <linux/ftrace.h>
 #include <linux/slab.h>
 #include <linux/init_task.h>
+#include <linux/jump_label.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -503,7 +504,32 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
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
@@ -9203,7 +9229,7 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 runtime);
 
 static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 {
-	int i, ret = 0, runtime_enabled;
+	int i, ret = 0, runtime_enabled, runtime_was_enabled;
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
 
 	if (tg == &root_task_group)
@@ -9231,6 +9257,9 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 		goto out_unlock;
 
 	runtime_enabled = quota != RUNTIME_INF;
+	runtime_was_enabled = cfs_b->quota != RUNTIME_INF;
+	account_cfs_bandwidth_used(runtime_enabled, runtime_was_enabled);
+
 	raw_spin_lock_irq(&cfs_b->lock);
 	cfs_b->period = ns_to_ktime(period);
 	cfs_b->quota = quota;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a78ed27..a608593 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1421,7 +1421,7 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 						   unsigned long delta_exec)
 {
-	if (!cfs_rq->runtime_enabled)
+	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
 
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
@@ -1429,13 +1429,13 @@ static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 
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
@@ -1756,6 +1756,9 @@ static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	if (!cfs_rq->runtime_enabled || cfs_rq->nr_running)
 		return;
 
@@ -1801,6 +1804,9 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
  */
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	/* an active group must be handled by the update_curr()->put() path */
 	if (!cfs_rq->runtime_enabled || cfs_rq->curr)
 		return;
@@ -1818,6 +1824,9 @@ static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 /* conditionally throttle active cfs_rq's from put_prev_entity() */
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
+	if (!cfs_bandwidth_used())
+		return;
+
 	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
 		return;
 
