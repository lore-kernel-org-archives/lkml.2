Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab0I2Gln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:41:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45739 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751907Ab0I2Glm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:41:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+B1IYsaT2BpPEGv5NELoVwUC+uq8O9K0K8//cCc6
	PBRmfXEq9qLXGe
Subject: Re: broken behavior in cfs when moving threads between cgroups
From: Mike Galbraith <efault@gmx.de>
To: Dima Zavin <dmitriyz@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@google.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1285728812.7440.141.camel@marge.simson.net>
References: <AANLkTinmQOYQAOPkQsZNhJBJtCss3ZtHN_a6h4fpamtz@mail.gmail.com>
	 <1285661878.2795.70.camel@marge.simson.net>
	 <AANLkTikjH1J_nCxZympo9v_VZbptWHBNJ8xh=pFXLRrQ@mail.gmail.com>
	 <1285728812.7440.141.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 08:42:07 +0200
Message-Id: <1285742527.7440.295.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 04:53 +0200, Mike Galbraith wrote:

> ..but, as you noted, moving out then _back_ at forced 0 lag would result
> in bogus vruntime deltas, so lag must be preserved.  The sleeper's
> vruntime has to be set to relative before it's cfs_rq is changed, then
> back to absolute in moved_group_fair() I suppose.

I bent it up like so.

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53eb33c..d2b06a9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1073,7 +1073,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p, int on_rq);
+	void (*moved_group) (struct task_struct *p, int on_rq, int leaving);
 #endif
 };
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 1ab8394..7001d5a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8358,11 +8358,16 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (tsk->sched_class->moved_group)
+		tsk->sched_class->moved_group(tsk, on_rq, 1);
+#endif
+
 	set_task_rq(tsk, task_cpu(tsk));
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk, on_rq);
+		tsk->sched_class->moved_group(tsk, on_rq, 0);
 #endif
 
 	if (unlikely(running))
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9b5b4f8..81885ae 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3824,13 +3824,23 @@ static void set_curr_task_fair(struct rq *rq)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p, int on_rq)
+static void moved_group_fair(struct task_struct *p, int on_rq, int leaving)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
 	update_curr(cfs_rq);
-	if (!on_rq)
-		place_entity(cfs_rq, &p->se, 1);
+
+	/*
+	 * For runnable tasks, vruntime normalization is handled globally by
+	 * dequeue_entity().  task_waking_fair() normalizes sleepers in the
+	 * wakeup path (to allow lag to grow while sleeping), so we have to
+	 * normalize before the task exits it's old cfs_rq, and prepare for
+	 * the impending normalization before that happens.
+	 */
+	if (!on_rq && leaving)
+		p->se.vruntime -= cfs_rq->min_vruntime;
+	else if (!on_rq)
+		p->se.vruntime += cfs_rq->min_vruntime;
 }
 #endif
 


