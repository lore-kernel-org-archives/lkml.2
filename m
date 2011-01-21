Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1AUGTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:19:35 -0500
Received: from smtp.nokia.com ([147.243.1.48]:25134 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1AUGTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:19:33 -0500
Subject: Re: Bug in scheduler when using rt_mutex
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1295507220.11678.45.camel@kolo>
References: <1295275365.12840.13.camel@kolo>
	 <1295280032.30950.128.camel@laptop> <1295339012.11678.35.camel@kolo>
	 <AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	 <1295357746.30950.681.camel@laptop>
	 <AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	 <1295430276.30950.1414.camel@laptop>  <1295433498.30950.1482.camel@laptop>
	 <1295436632.30950.1542.camel@laptop>  <1295441881.11678.41.camel@kolo>
	 <1295442799.11678.43.camel@kolo>  <1295443822.28776.23.camel@laptop>
	 <1295507220.11678.45.camel@kolo>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Fri, 21 Jan 2011 08:25:28 +0200
Message-ID: <1295591128.11678.54.camel@kolo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 09:07 +0200, Onkalo Samu wrote:
> On Wed, 2011-01-19 at 14:30 +0100, ext Peter Zijlstra wrote:
> > On Wed, 2011-01-19 at 15:13 +0200, Onkalo Samu wrote:
> > > 
> > > When the task is sleeping rt_mutex_setprio
> > > doesn't call check_class_changed since the task is not 
> > > in queue at that moment I think. 
> > 
> > Ah, indeed, more changes then..
> > 
> > (I think we can also remove the prio_changed_idle thing, since I think
> > we killed that hotplug usage)
> 
> Doesn't compile because kernel/sched_idletask.c
> functions still use "running" parameter which was removed.
> 

I made similar corrections to sched_idletask.c as you did for other
functions. Seems to work for us.

-Samu

> > 
> 
> > 
> > ---
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -2025,14 +2025,14 @@ inline int task_curr(const struct task_s
> >  
> >  static inline void check_class_changed(struct rq *rq, struct task_struct *p,
> >  				       const struct sched_class *prev_class,
> > -				       int oldprio, int running)
> > +				       int oldprio)
> >  {
> >  	if (prev_class != p->sched_class) {
> >  		if (prev_class->switched_from)
> > -			prev_class->switched_from(rq, p, running);
> > -		p->sched_class->switched_to(rq, p, running);
> > -	} else
> > -		p->sched_class->prio_changed(rq, p, oldprio, running);
> > +			prev_class->switched_from(rq, p);
> > +		p->sched_class->switched_to(rq, p);
> > +	} else if (oldprio != p->prio)
> > +		p->sched_class->prio_changed(rq, p, oldprio);
> >  }
> >  
> >  static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
> > @@ -4570,11 +4570,10 @@ void rt_mutex_setprio(struct task_struct
> >  
> >  	if (running)
> >  		p->sched_class->set_curr_task(rq);
> > -	if (on_rq) {
> > +	if (on_rq)
> >  		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
> >  
> > -		check_class_changed(rq, p, prev_class, oldprio, running);
> > -	}
> > +	check_class_changed(rq, p, prev_class, oldprio);
> >  	task_rq_unlock(rq, &flags);
> >  }
> >  
> > @@ -4902,11 +4901,10 @@ static int __sched_setscheduler(struct t
> >  
> >  	if (running)
> >  		p->sched_class->set_curr_task(rq);
> > -	if (on_rq) {
> > +	if (on_rq)
> >  		activate_task(rq, p, 0);
> >  
> > -		check_class_changed(rq, p, prev_class, oldprio, running);
> > -	}
> > +	check_class_changed(rq, p, prev_class, oldprio);
> >  	__task_rq_unlock(rq);
> >  	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> >  
> > @@ -8109,6 +8107,8 @@ EXPORT_SYMBOL(__might_sleep);
> >  #ifdef CONFIG_MAGIC_SYSRQ
> >  static void normalize_task(struct rq *rq, struct task_struct *p)
> >  {
> > +	struct sched_class *prev_class = p->sched_class;
> > +	int old_prio = p->prio;
> >  	int on_rq;
> >  
> >  	on_rq = p->se.on_rq;
> > @@ -8119,6 +8119,8 @@ static void normalize_task(struct rq *rq
> >  		activate_task(rq, p, 0);
> >  		resched_task(rq->curr);
> >  	}
> > +
> > +	check_class_changed(rq, p, prev_class, old_prio);
> >  }
> >  
> >  void normalize_rt_tasks(void)
> > Index: linux-2.6/kernel/sched_fair.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_fair.c
> > +++ linux-2.6/kernel/sched_fair.c
> > @@ -4054,33 +4054,56 @@ static void task_fork_fair(struct task_s
> >   * Priority of the task has changed. Check to see if we preempt
> >   * the current task.
> >   */
> > -static void prio_changed_fair(struct rq *rq, struct task_struct *p,
> > -			      int oldprio, int running)
> > +static void
> > +prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
> >  {
> > +	if (!p->se.on_rq)
> > +		return;
> > +
> >  	/*
> >  	 * Reschedule if we are currently running on this runqueue and
> >  	 * our priority decreased, or if we are not currently running on
> >  	 * this runqueue and our priority is higher than the current's
> >  	 */
> > -	if (running) {
> > +	if (rq->curr == p) {
> >  		if (p->prio > oldprio)
> >  			resched_task(rq->curr);
> >  	} else
> >  		check_preempt_curr(rq, p, 0);
> >  }
> >  
> > +static void switched_from_fair(struct rq *rq, struct task_struct *p)
> > +{
> > +	struct sched_entity *se = &p->se;
> > +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> > +
> > +	/*
> > +	 * Ensure the task's vruntime is normalized, so that when its
> > +	 * switched back to the fair class the enqueue_entity(.flags=0) will
> > +	 * do the right thing.
> > +	 *
> > +	 * If it was on_rq, then the dequeue_entity(.flags=0) will already
> > +	 * have normalized the vruntime, if it was !on_rq, then only when
> > +	 * the task is sleeping will it still have non-normalized vruntime.
> > +	 */
> > +	if (!se->on_rq && p->state != TASK_RUNNING)
> > +		se->vruntime -= cfs_rq->min_vruntime;
> > +}
> > +
> >  /*
> >   * We switched to the sched_fair class.
> >   */
> > -static void switched_to_fair(struct rq *rq, struct task_struct *p,
> > -			     int running)
> > +static void switched_to_fair(struct rq *rq, struct task_struct *p)
> >  {
> > +	if (!p->se.on_rq)
> > +		return;
> > +
> >  	/*
> >  	 * We were most likely switched from sched_rt, so
> >  	 * kick off the schedule if running, otherwise just see
> >  	 * if we can still preempt the current task.
> >  	 */
> > -	if (running)
> > +	if (rq->curr == p)
> >  		resched_task(rq->curr);
> >  	else
> >  		check_preempt_curr(rq, p, 0);
> > @@ -4166,6 +4189,7 @@ static const struct sched_class fair_sch
> >  	.task_fork		= task_fork_fair,
> >  
> >  	.prio_changed		= prio_changed_fair,
> > +	.switched_from		= switched_from_fair,
> >  	.switched_to		= switched_to_fair,
> >  
> >  	.get_rr_interval	= get_rr_interval_fair,
> > Index: linux-2.6/include/linux/sched.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/sched.h
> > +++ linux-2.6/include/linux/sched.h
> > @@ -1084,12 +1084,10 @@ struct sched_class {
> >  	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
> >  	void (*task_fork) (struct task_struct *p);
> >  
> > -	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
> > -			       int running);
> > -	void (*switched_to) (struct rq *this_rq, struct task_struct *task,
> > -			     int running);
> > +	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
> > +	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
> >  	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
> > -			     int oldprio, int running);
> > +			     int oldprio);
> >  
> >  	unsigned int (*get_rr_interval) (struct rq *rq,
> >  					 struct task_struct *task);
> > Index: linux-2.6/kernel/sched_idletask.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_idletask.c
> > +++ linux-2.6/kernel/sched_idletask.c
> > @@ -52,8 +52,7 @@ static void set_curr_task_idle(struct rq
> >  {
> >  }
> >  
> > -static void switched_to_idle(struct rq *rq, struct task_struct *p,
> > -			     int running)
> > +static void switched_to_idle(struct rq *rq, struct task_struct *p)
> >  {
> >  	/* Can this actually happen?? */
> >  	if (running)
> > @@ -62,8 +61,8 @@ static void switched_to_idle(struct rq *
> >  		check_preempt_curr(rq, p, 0);
> >  }
> >  
> > -static void prio_changed_idle(struct rq *rq, struct task_struct *p,
> > -			      int oldprio, int running)
> > +static void
> > +prio_changed_idle(struct rq *rq, struct task_struct *p, int oldprio)
> >  {
> >  	/* This can happen for hot plug CPUS */
> >  
> > Index: linux-2.6/kernel/sched_rt.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_rt.c
> > +++ linux-2.6/kernel/sched_rt.c
> > @@ -1595,8 +1595,7 @@ static void rq_offline_rt(struct rq *rq)
> >   * When switch from the rt queue, we bring ourselves to a position
> >   * that we might want to pull RT tasks from other runqueues.
> >   */
> > -static void switched_from_rt(struct rq *rq, struct task_struct *p,
> > -			   int running)
> > +static void switched_from_rt(struct rq *rq, struct task_struct *p)
> >  {
> >  	/*
> >  	 * If there are other RT tasks then we will reschedule
> > @@ -1605,7 +1604,7 @@ static void switched_from_rt(struct rq *
> >  	 * we may need to handle the pulling of RT tasks
> >  	 * now.
> >  	 */
> > -	if (!rq->rt.rt_nr_running)
> > +	if (p->se.on_rq && !rq->rt.rt_nr_running)
> >  		pull_rt_task(rq);
> >  }
> >  
> > @@ -1624,8 +1623,7 @@ static inline void init_sched_rt_class(v
> >   * with RT tasks. In this case we try to push them off to
> >   * other runqueues.
> >   */
> > -static void switched_to_rt(struct rq *rq, struct task_struct *p,
> > -			   int running)
> > +static void switched_to_rt(struct rq *rq, struct task_struct *p)
> >  {
> >  	int check_resched = 1;
> >  
> > @@ -1636,7 +1634,7 @@ static void switched_to_rt(struct rq *rq
> >  	 * If that current running task is also an RT task
> >  	 * then see if we can move to another run queue.
> >  	 */
> > -	if (!running) {
> > +	if (p->se.on_rq && rq->curr != p) {
> >  #ifdef CONFIG_SMP
> >  		if (rq->rt.overloaded && push_rt_task(rq) &&
> >  		    /* Don't resched if we changed runqueues */
> > @@ -1652,10 +1650,13 @@ static void switched_to_rt(struct rq *rq
> >   * Priority of the task has changed. This may cause
> >   * us to initiate a push or pull.
> >   */
> > -static void prio_changed_rt(struct rq *rq, struct task_struct *p,
> > -			    int oldprio, int running)
> > +static void
> > +prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
> >  {
> > -	if (running) {
> > +	if (!p->se.on_rq)
> > +		return;
> > +
> > +	if (rq->curr == p) {
> >  #ifdef CONFIG_SMP
> >  		/*
> >  		 * If our priority decreases while running, we
> > Index: linux-2.6/kernel/sched_stoptask.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_stoptask.c
> > +++ linux-2.6/kernel/sched_stoptask.c
> > @@ -59,14 +59,13 @@ static void set_curr_task_stop(struct rq
> >  {
> >  }
> >  
> > -static void switched_to_stop(struct rq *rq, struct task_struct *p,
> > -			     int running)
> > +static void switched_to_stop(struct rq *rq, struct task_struct *p)
> >  {
> >  	BUG(); /* its impossible to change to this class */
> >  }
> >  
> > -static void prio_changed_stop(struct rq *rq, struct task_struct *p,
> > -			      int oldprio, int running)
> > +static void
> > +prio_changed_stop(struct rq *rq, struct task_struct *p, int oldprio)
> >  {
> >  	BUG(); /* how!?, what priority? */
> >  }
> > 
> 


