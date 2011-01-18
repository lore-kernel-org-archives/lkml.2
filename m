Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1ARTF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:05:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:53025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab1ARTF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:05:57 -0500
Date: Tue, 18 Jan 2011 19:05:26 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bharata@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1294890890.8089.39.camel@marge.simson.net>
References: <1294890890.8089.39.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, autogroup: Fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure
Message-ID: <tip-f44937718ce3b8360f72f6c68c9481712517a867@git.kernel.org>
Git-Commit-ID: f44937718ce3b8360f72f6c68c9481712517a867
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 Jan 2011 19:05:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f44937718ce3b8360f72f6c68c9481712517a867
Gitweb:     http://git.kernel.org/tip/f44937718ce3b8360f72f6c68c9481712517a867
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 13 Jan 2011 04:54:50 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Jan 2011 15:09:42 +0100

sched, autogroup: Fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure

If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
tasks to the root task group, and tell __sched_setscheduler() that it's ok.

Reported-and-tested-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294890890.8089.39.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c           |    3 ++-
 kernel/sched_autogroup.c |   27 +++++++++++++++++++++++++++
 kernel/sched_autogroup.h |    4 ++++
 3 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a0eb094..6cbff6b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4871,7 +4871,8 @@ recheck:
 		 * assigned.
 		 */
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0) {
+				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
+				!task_group_is_autogroup(task_group(p))) {
 			__task_rq_unlock(rq);
 			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 			return -EPERM;
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index 938d52f..9fb6562 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -27,6 +27,11 @@ static inline void autogroup_destroy(struct kref *kref)
 {
 	struct autogroup *ag = container_of(kref, struct autogroup, kref);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/* We've redirected RT tasks to the root task group... */
+	ag->tg->rt_se = NULL;
+	ag->tg->rt_rq = NULL;
+#endif
 	sched_destroy_group(ag->tg);
 }
 
@@ -55,6 +60,10 @@ static inline struct autogroup *autogroup_task_get(struct task_struct *p)
 	return ag;
 }
 
+#ifdef CONFIG_RT_GROUP_SCHED
+static void free_rt_sched_group(struct task_group *tg);
+#endif
+
 static inline struct autogroup *autogroup_create(void)
 {
 	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
@@ -72,6 +81,19 @@ static inline struct autogroup *autogroup_create(void)
 	init_rwsem(&ag->lock);
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
 	ag->tg = tg;
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * Autogroup RT tasks are redirected to the root task group
+	 * so we don't have to move tasks around upon policy change,
+	 * or flail around trying to allocate bandwidth on the fly.
+	 * A bandwidth exception in __sched_setscheduler() allows
+	 * the policy change to proceed.  Thereafter, task_group()
+	 * returns &root_task_group, so zero bandwidth is required.
+	 */
+	free_rt_sched_group(tg);
+	tg->rt_se = root_task_group.rt_se;
+	tg->rt_rq = root_task_group.rt_rq;
+#endif
 	tg->autogroup = ag;
 
 	return ag;
@@ -106,6 +128,11 @@ task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 	return true;
 }
 
+static inline bool task_group_is_autogroup(struct task_group *tg)
+{
+	return tg != &root_task_group && tg->autogroup;
+}
+
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg)
 {
diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
index 5358e24..7b859ff 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -15,6 +15,10 @@ autogroup_task_group(struct task_struct *p, struct task_group *tg);
 
 static inline void autogroup_init(struct task_struct *init_task) {  }
 static inline void autogroup_free(struct task_group *tg) { }
+static inline bool task_group_is_autogroup(struct task_group *tg)
+{
+	return 0;
+}
 
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg)
