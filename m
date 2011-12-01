Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab1LARkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:40:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:47776 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1LARkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:40:16 -0500
Message-ID: <1322761185.4699.47.camel@twins>
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Date: Thu, 01 Dec 2011 18:39:45 +0100
In-Reply-To: <20111201165009.GB2443@redhat.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <20111201154036.GA2443@redhat.com> <1322756898.4699.30.camel@twins>
	 <20111201165009.GB2443@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 11:50 -0500, Jason Baron wrote:

> I think its just a matter of reversing the true and false returns.
> That is, instead of:

that's the same as !static_branch()

> jump_label_inc/dec(), don't need to be changed, they just mean reverse
> the branch on 0, 1 transitions. Although using the same key in both
> static_branch_true, and static_branch_false, might be confusing. Maybe
> we rename jump_label_inc/dec to static_branch_reverse_inc()/dec()?

Right, that's the problem really. That makes it impossible to make the
control code generic.

What I'd want is something that doesn't out-of-line the branch, is
possibly enabled by default, but has the same inc/dec behaviour, not the
reversed.

---
Subject: sched: Use jump_labels for sched_feat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jul 06 14:20:14 CEST 2011


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/core.c     |   34 +++++++++++++++++++++++++++++-----
 kernel/sched/features.h |   30 +++++++++++++++---------------
 kernel/sched/sched.h    |   27 +++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/sched/core.c
===================================================================
--- linux-2.6.orig/kernel/sched/core.c
+++ linux-2.6/kernel/sched/core.c
@@ -149,7 +149,7 @@ static int sched_feat_show(struct seq_fi
 {
 	int i;
 
-	for (i = 0; sched_feat_names[i]; i++) {
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
 		if (!(sysctl_sched_features & (1UL << i)))
 			seq_puts(m, "NO_");
 		seq_printf(m, "%s ", sched_feat_names[i]);
@@ -182,17 +182,26 @@ sched_feat_write(struct file *filp, cons
 		cmp += 3;
 	}
 
-	for (i = 0; sched_feat_names[i]; i++) {
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
 		if (strcmp(cmp, sched_feat_names[i]) == 0) {
-			if (neg)
+			if (neg) {
 				sysctl_sched_features &= ~(1UL << i);
-			else
+#ifdef HAVE_JUMP_LABEL
+				if (!jump_label_enabled(&sched_feat_keys[i]))
+					jump_label_inc(&sched_feat_keys[i]);
+#endif
+			} else {
 				sysctl_sched_features |= (1UL << i);
+#ifdef HAVE_JUMP_LABEL
+				if (jump_label_enabled(&sched_feat_keys[i]))
+					jump_label_dec(&sched_feat_keys[i]);
+#endif
+			}
 			break;
 		}
 	}
 
-	if (!sched_feat_names[i])
+	if (i == __SCHED_FEAT_NR)
 		return -EINVAL;
 
 	*ppos += cnt;
@@ -222,7 +231,20 @@ static __init int sched_init_debug(void)
 }
 late_initcall(sched_init_debug);
 
+static __init void sched_init_jump_label(void)
+{
+#ifdef HAVE_JUMP_LABEL
+	int i;
+
+	for (i = 0; i < __SCHED_FEAT_NR; i++) {
+		if (sysctl_sched_features & (1UL << i))
+			jump_label_inc(&sched_feat_keys[i]);
+	}
 #endif
+}
+#else /* CONFIG_SCHED_DEBUG */
+static __init void sched_init_jump_label(void) { }
+#endif /* CONFIG_SCHED_DEBUG */
 
 /*
  * Number of tasks to iterate in a single balance run.
@@ -6748,6 +6770,8 @@ void __init sched_init(void)
 	int i, j;
 	unsigned long alloc_size = 0, ptr;
 
+	sched_init_jump_label();
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
Index: linux-2.6/kernel/sched/features.h
===================================================================
--- linux-2.6.orig/kernel/sched/features.h
+++ linux-2.6/kernel/sched/features.h
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
Index: linux-2.6/kernel/sched/sched.h
===================================================================
--- linux-2.6.orig/kernel/sched/sched.h
+++ linux-2.6/kernel/sched/sched.h
@@ -581,6 +581,7 @@ static inline void __set_task_cpu(struct
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
 #ifdef CONFIG_SCHED_DEBUG
+# include <linux/jump_label.h>
 # define const_debug __read_mostly
 #else
 # define const_debug const
@@ -593,11 +594,37 @@ extern const_debug unsigned int sysctl_s
 
 enum {
 #include "features.h"
+	__SCHED_FEAT_NR,
 };
 
 #undef SCHED_FEAT
 
+static __always_inline bool static_branch_true(struct jump_label_key *key)
+{
+	return static_branch(key); /* Not out of line branch. */
+}
+
+static __always_inline bool static_branch_false(struct jump_label_key *key)
+{
+	return static_branch(key); /* Out of line branch. */
+}
+
+#define SCHED_FEAT(name, enabled)					\
+static __always_inline bool static_branch_##name(struct jump_label_key *key) \
+{									\
+	return static_branch_##enabled(key);				\
+}
+
+#include "features.h"
+
+#undef SCHED_FEAT
+
+#if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
+static struct jump_label_key sched_feat_keys[__SCHED_FEAT_NR];
+#define sched_feat(x) (static_branch(&sched_feat_keys[__SCHED_FEAT_##x]))
+#else
 #define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+#endif
 
 static inline u64 global_rt_period(void)
 {

