Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab1AMDy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:54:57 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50444 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750978Ab1AMDyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:54:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18FtNl3230FuHxtUmpYEuGFbyBy0Vx+AMypE57B2b
	fnUsB0+438Gup3
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: bharata@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
	 <1294677746.8345.4.camel@marge.simson.net>
	 <20110111171046.GL4772@in.ibm.com>
	 <1294771686.8006.15.camel@marge.simson.net>
	 <1294810842.8370.7.camel@marge.simson.net>
	 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 04:54:50 +0100
Message-ID: <1294890890.8089.39.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(mailer switched me to work account again.  grrrr, switch yet again:)

On Wed, 2011-01-12 at 14:32 +0800, Yong Zhang wrote:

> Setting rt_runtime both in this patch and the previous one will make tune
> other's rt_runtime/rt_period trouble, I guess.

Yeah, as in making it impossible to allocate even 1 usec :)  We need
zero bandwidth though, so tell  __sched_setscheduler() that autogroups
having zero allocated is perfectly fine.

sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.

If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
tasks to the root task group, and tell __sched_setscheduler() that it's ok.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

---
 kernel/sched.c           |    3 ++-
 kernel/sched_autogroup.c |   27 +++++++++++++++++++++++++++
 kernel/sched_autogroup.h |    4 ++++
 3 files changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched_autogroup.c
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.c
+++ linux-2.6/kernel/sched_autogroup.c
@@ -27,6 +27,11 @@ static inline void autogroup_destroy(str
 {
 	struct autogroup *ag = container_of(kref, struct autogroup, kref);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+	/* We've redirected RT tasks to the root task group... */
+	ag->tg->rt_se = NULL;
+	ag->tg->rt_rq = NULL;
+#endif
 	sched_destroy_group(ag->tg);
 }
 
@@ -55,6 +60,10 @@ static inline struct autogroup *autogrou
 	return ag;
 }
 
+#ifdef CONFIG_RT_GROUP_SCHED
+static void free_rt_sched_group(struct task_group *tg);
+#endif
+
 static inline struct autogroup *autogroup_create(void)
 {
 	struct autogroup *ag = kzalloc(sizeof(*ag), GFP_KERNEL);
@@ -72,6 +81,19 @@ static inline struct autogroup *autogrou
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
@@ -106,6 +128,11 @@ task_wants_autogroup(struct task_struct
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
Index: linux-2.6/kernel/sched_autogroup.h
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.h
+++ linux-2.6/kernel/sched_autogroup.h
@@ -15,6 +15,10 @@ autogroup_task_group(struct task_struct
 
 static inline void autogroup_init(struct task_struct *init_task) {  }
 static inline void autogroup_free(struct task_group *tg) { }
+static inline bool task_group_is_autogroup(struct task_group *tg)
+{
+	return 0;
+}
 
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4874,7 +4874,8 @@ recheck:
 		 * assigned.
 		 */
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0) {
+				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
+				!task_group_is_autogroup(task_group(p))) {
 			__task_rq_unlock(rq);
 			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 			return -EPERM;


