Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1ASLaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 06:30:02 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37004 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1ASLaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 06:30:00 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <1295433498.30950.1482.camel@laptop>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295430276.30950.1414.camel@laptop>  <1295433498.30950.1482.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 Jan 2011 12:30:32 +0100
Message-ID: <1295436632.30950.1542.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 11:38 +0100, Peter Zijlstra wrote:

> Hrm, I think the to bit is not needed with the from thing in place, the
> enqueue from _setprio will already have added min_vruntime


Would lead to something like this:

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8108,6 +8108,8 @@ EXPORT_SYMBOL(__might_sleep);
 #ifdef CONFIG_MAGIC_SYSRQ
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
+	struct sched_class *prev_class = p->sched_class;
+	int old_prio = p->prio;
 	int on_rq;
 
 	on_rq = p->se.on_rq;
@@ -8118,6 +8120,8 @@ static void normalize_task(struct rq *rq
 		activate_task(rq, p, 0);
 		resched_task(rq->curr);
 	}
+
+	check_class_changed(rq, p, prev_class, old_prio, task_current(rq, p));
 }
 
 void normalize_rt_tasks(void)
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -4066,11 +4066,30 @@ static void prio_changed_fair(struct rq
 		check_preempt_curr(rq, p, 0);
 }
 
+static void
+switched_from_fair(struct rq *rq, struct task_struct *p, int running)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	/*
+	 * Ensure the task's vruntime is normalized, so that when its
+	 * switched back to the fair class the enqueue_entity(.flags=0) will
+	 * do the right thing.
+	 *
+	 * If it was on_rq, then the dequeue_entity(.flags=0) will already
+	 * have normalized the vruntime, if it was !on_rq, then only when
+	 * the task is sleeping will it still have non-normalized vruntime.
+	 */
+	if (!se->on_rq && p->state != TASK_RUNNING)
+		se->vruntime -= cfs_rq->min_vruntime;
+}
+
 /*
  * We switched to the sched_fair class.
  */
-static void switched_to_fair(struct rq *rq, struct task_struct *p,
-			     int running)
+static void
+switched_to_fair(struct rq *rq, struct task_struct *p, int running)
 {
 	/*
 	 * We were most likely switched from sched_rt, so
@@ -4163,6 +4182,7 @@ static const struct sched_class fair_sch
 	.task_fork		= task_fork_fair,
 
 	.prio_changed		= prio_changed_fair,
+	.switched_from		= switched_from_fair,
 	.switched_to		= switched_to_fair,
 
 	.get_rr_interval	= get_rr_interval_fair,

