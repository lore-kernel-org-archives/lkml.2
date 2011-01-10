Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1AJQmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:42:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:55966 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753449Ab1AJQmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:42:53 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19do9I6piZdUz4gl2LQCnCg/yNLcwZPwPvcDZSK1k
	RYP2NgCgljPeb7
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: bharata@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1294657154.2016.459.camel@laptop>
References: <20110110091622.GF2772@in.ibm.com>
	 <1294655388.8197.22.camel@marge.simson.net>
	 <1294657154.2016.459.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 17:42:26 +0100
Message-ID: <1294677746.8345.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 11:59 +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-10 at 11:29 +0100, Mike Galbraith wrote:
> >
> > Autogroup does not support realtime task groups, so make selection of
> > SCHED_AUTOGROUP exclude RT_GROUP_SCHED.
> > 

> Uhm, no. The right way is to put tasks back into the root group and then
> perform sched_setscheduler().

I think that would take more lines, this look like a right way too?

sched, autogroup: move tasks to the appropriate runqueue on policy change.

If CONFIG_RT_GROUP_SCHED is set, sched_setscheduler() fails due to autogroup
not allocating rt_runtime.  Fool __sched_setscheduler() into proceeding on, and
move tasks to the appropriate runqueue upon policy change.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

---
 kernel/sched.c           |    9 ++++++---
 kernel/sched_autogroup.c |   18 ++++++++++++++++++
 kernel/sched_autogroup.h |    1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4571,6 +4571,8 @@ void rt_mutex_setprio(struct task_struct
 
 	p->prio = prio;
 
+	autogroup_setscheduler(p, on_rq);
+
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
@@ -4738,7 +4740,7 @@ static struct task_struct *find_process_
 
 /* Actually do priority change: must hold rq lock. */
 static void
-__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
+__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio, int on_rq)
 {
 	BUG_ON(p->se.on_rq);
 
@@ -4752,6 +4754,7 @@ __setscheduler(struct rq *rq, struct tas
 	else
 		p->sched_class = &fair_sched_class;
 	set_load_weight(p);
+	autogroup_setscheduler(p, on_rq);
 }
 
 /*
@@ -4900,7 +4903,7 @@ recheck:
 
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	__setscheduler(rq, p, policy, param->sched_priority);
+	__setscheduler(rq, p, policy, param->sched_priority, on_rq);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
@@ -8116,7 +8119,7 @@ static void normalize_task(struct rq *rq
 	on_rq = p->se.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
-	__setscheduler(rq, p, SCHED_NORMAL, 0);
+	__setscheduler(rq, p, SCHED_NORMAL, 0, on_rq);
 	if (on_rq) {
 		activate_task(rq, p, 0);
 		resched_task(rq->curr);
Index: linux-2.6/kernel/sched_autogroup.c
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.c
+++ linux-2.6/kernel/sched_autogroup.c
@@ -73,6 +73,15 @@ static inline struct autogroup *autogrou
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
 	ag->tg = tg;
 	tg->autogroup = ag;
+#ifdef CONFIG_RT_GROUP_SCHED
+	/*
+	 * HACK: autogroup RT tasks run in the root task group.
+	 * This fools __sched_setscheduler() into proceeding on
+	 * so we can move the task to the appropriate runqueue
+	 * upon scheduling policy change.
+	 */
+	tg->rt_bandwidth.rt_runtime = RUNTIME_INF;
+#endif
 
 	return ag;
 
@@ -143,6 +152,15 @@ autogroup_move_group(struct task_struct
 	autogroup_kref_put(prev);
 }
 
+static inline void
+autogroup_setscheduler(struct task_struct *p, int on_rq)
+{
+	if (p->sched_class->task_move_group)
+		p->sched_class->task_move_group(p, on_rq);
+	else
+		set_task_rq(p, task_cpu(p));
+}
+
 /* Allocates GFP_KERNEL, cannot be called under any spinlock */
 void sched_autogroup_create_attach(struct task_struct *p)
 {
Index: linux-2.6/kernel/sched_autogroup.h
===================================================================
--- linux-2.6.orig/kernel/sched_autogroup.h
+++ linux-2.6/kernel/sched_autogroup.h
@@ -15,6 +15,7 @@ autogroup_task_group(struct task_struct
 
 static inline void autogroup_init(struct task_struct *init_task) {  }
 static inline void autogroup_free(struct task_group *tg) { }
+static inline void autogroup_setscheduler(struct task_struct *p, int on_rq) { }
 
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg)


