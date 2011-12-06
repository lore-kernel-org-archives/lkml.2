Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1LFUXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:23:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1LFUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:23:50 -0500
Date: Tue, 6 Dec 2011 12:23:23 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-vpreo4hal9e0kzqmg5y0io2k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use jump_labels for sched_feat
Git-Commit-ID: f8b6d1cc7dc15cf3de538b864eefaedad7a84d85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:23:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8b6d1cc7dc15cf3de538b864eefaedad7a84d85
Gitweb:     http://git.kernel.org/tip/f8b6d1cc7dc15cf3de538b864eefaedad7a84d85
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 6 Jul 2011 14:20:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:51:26 +0100

sched: Use jump_labels for sched_feat

Now that we initialize jump_labels before sched_init() we can use them
for the debug features without having to worry about a window where
they have the wrong setting.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-vpreo4hal9e0kzqmg5y0io2k@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c     |   46 +++++++++++++++++++++++++++++++++++++++-------
 kernel/sched/features.h |   30 +++++++++++++++---------------
 kernel/sched/sched.h    |   27 +++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9ac22d2..3c5b21e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -149,7 +149,7 @@ static int sched_feat_show(struct seq_file *m, void *v)
 {
 	int i;
 
-	for (i = 0; sched_feat_names[i]; i++) {
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
 		if (!(sysctl_sched_features & (1UL << i)))
 			seq_puts(m, "NO_");
 		seq_printf(m, "%s ", sched_feat_names[i]);
@@ -159,6 +159,36 @@ static int sched_feat_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+#ifdef HAVE_JUMP_LABEL
+
+#define jump_label_key__true  jump_label_key_enabled
+#define jump_label_key__false jump_label_key_disabled
+
+#define SCHED_FEAT(name, enabled)	\
+	jump_label_key__##enabled ,
+
+struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR] = {
+#include "features.h"
+};
+
+#undef SCHED_FEAT
+
+static void sched_feat_disable(int i)
+{
+	if (jump_label_enabled(&sched_feat_keys[i]))
+		jump_label_dec(&sched_feat_keys[i]);
+}
+
+static void sched_feat_enable(int i)
+{
+	if (!jump_label_enabled(&sched_feat_keys[i]))
+		jump_label_inc(&sched_feat_keys[i]);
+}
+#else
+static void sched_feat_disable(int i) { };
+static void sched_feat_enable(int i) { };
+#endif /* HAVE_JUMP_LABEL */
+
 static ssize_t
 sched_feat_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
@@ -182,17 +212,20 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		cmp += 3;
 	}
 
-	for (i = 0; sched_feat_names[i]; i++) {
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
 		if (strcmp(cmp, sched_feat_names[i]) == 0) {
-			if (neg)
+			if (neg) {
 				sysctl_sched_features &= ~(1UL << i);
-			else
+				sched_feat_disable(i);
+			} else {
 				sysctl_sched_features |= (1UL << i);
+				sched_feat_enable(i);
+			}
 			break;
 		}
 	}
 
-	if (!sched_feat_names[i])
+	if (i == __SCHED_FEAT_NR)
 		return -EINVAL;
 
 	*ppos += cnt;
@@ -221,8 +254,7 @@ static __init int sched_init_debug(void)
 	return 0;
 }
 late_initcall(sched_init_debug);
-
-#endif
+#endif /* CONFIG_SCHED_DEBUG */
 
 /*
  * Number of tasks to iterate in a single balance run.
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 8480224..e61fd73 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -3,13 +3,13 @@
  * them to run sooner, but does not allow tons of sleepers to
  * rip the spread apart.
  */
-SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
+SCHED_FEAT(GENTLE_FAIR_SLEEPERS, true)
 
 /*
  * Place new tasks ahead so that they do not starve already running
  * tasks
  */
-SCHED_FEAT(START_DEBIT, 1)
+SCHED_FEAT(START_DEBIT, true)
 
 /*
  * Based on load and program behaviour, see if it makes sense to place
@@ -17,54 +17,54 @@ SCHED_FEAT(START_DEBIT, 1)
  * improve cache locality. Typically used with SYNC wakeups as
  * generated by pipes and the like, see also SYNC_WAKEUPS.
  */
-SCHED_FEAT(AFFINE_WAKEUPS, 1)
+SCHED_FEAT(AFFINE_WAKEUPS, true)
 
 /*
  * Prefer to schedule the task we woke last (assuming it failed
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.
  */
-SCHED_FEAT(NEXT_BUDDY, 0)
+SCHED_FEAT(NEXT_BUDDY, false)
 
 /*
  * Prefer to schedule the task that ran last (when we did
  * wake-preempt) as that likely will touch the same data, increases
  * cache locality.
  */
-SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(LAST_BUDDY, true)
 
 /*
  * Consider buddies to be cache hot, decreases the likelyness of a
  * cache buddy being migrated away, increases cache locality.
  */
-SCHED_FEAT(CACHE_HOT_BUDDY, 1)
+SCHED_FEAT(CACHE_HOT_BUDDY, true)
 
 /*
  * Use arch dependent cpu power functions
  */
-SCHED_FEAT(ARCH_POWER, 0)
+SCHED_FEAT(ARCH_POWER, false)
 
-SCHED_FEAT(HRTICK, 0)
-SCHED_FEAT(DOUBLE_TICK, 0)
-SCHED_FEAT(LB_BIAS, 1)
+SCHED_FEAT(HRTICK, false)
+SCHED_FEAT(DOUBLE_TICK, false)
+SCHED_FEAT(LB_BIAS, true)
 
 /*
  * Spin-wait on mutex acquisition when the mutex owner is running on
  * another cpu -- assumes that when the owner is running, it will soon
  * release the lock. Decreases scheduling overhead.
  */
-SCHED_FEAT(OWNER_SPIN, 1)
+SCHED_FEAT(OWNER_SPIN, true)
 
 /*
  * Decrement CPU power based on time not spent running tasks
  */
-SCHED_FEAT(NONTASK_POWER, 1)
+SCHED_FEAT(NONTASK_POWER, true)
 
 /*
  * Queue remote wakeups on the target CPU and process them
  * using the scheduler IPI. Reduces rq->lock contention/bounces.
  */
-SCHED_FEAT(TTWU_QUEUE, 1)
+SCHED_FEAT(TTWU_QUEUE, true)
 
-SCHED_FEAT(FORCE_SD_OVERLAP, 0)
-SCHED_FEAT(RT_RUNTIME_SHARE, 1)
+SCHED_FEAT(FORCE_SD_OVERLAP, false)
+SCHED_FEAT(RT_RUNTIME_SHARE, true)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c248016..d8d3613 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -581,6 +581,7 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
 #ifdef CONFIG_SCHED_DEBUG
+# include <linux/jump_label.h>
 # define const_debug __read_mostly
 #else
 # define const_debug const
@@ -593,11 +594,37 @@ extern const_debug unsigned int sysctl_sched_features;
 
 enum {
 #include "features.h"
+	__SCHED_FEAT_NR,
 };
 
 #undef SCHED_FEAT
 
+#if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
+static __always_inline bool static_branch__true(struct jump_label_key *key)
+{
+	return likely(static_branch(key)); /* Not out of line branch. */
+}
+
+static __always_inline bool static_branch__false(struct jump_label_key *key)
+{
+	return unlikely(static_branch(key)); /* Out of line branch. */
+}
+
+#define SCHED_FEAT(name, enabled)					\
+static __always_inline bool static_branch_##name(struct jump_label_key *key) \
+{									\
+	return static_branch__##enabled(key);				\
+}
+
+#include "features.h"
+
+#undef SCHED_FEAT
+
+extern struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR];
+#define sched_feat(x) (static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x]))
+#else /* !(SCHED_DEBUG && HAVE_JUMP_LABEL) */
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+#endif /* SCHED_DEBUG && HAVE_JUMP_LABEL */
 
 static inline u64 global_rt_period(void)
 {
