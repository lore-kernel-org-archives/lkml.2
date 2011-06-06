Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1FFJHC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:07:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46982 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1FFJHA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:07:00 -0400
Subject: Re: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110605191233.GA20462@redhat.com>
References: <20110531172651.GA4478@swordfish.minsk.epam.com>
	 <1307115427.2353.3456.camel@twins>  <20110605191233.GA20462@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 11:06:38 +0200
Message-ID: <1307351198.2353.7415.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 21:12 +0200, Oleg Nesterov wrote:
> On 06/03, Peter Zijlstra wrote:
> >
> > @@ -2200,6 +2201,16 @@ void set_task_cpu(struct task_struct *p,
> >  			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
> >
> >  #ifdef CONFIG_LOCKDEP
> > +	/*
> > +	 * The caller should hold either p->pi_lock or rq->lock, when changing
> > +	 * a task's CPU.
> 
> Is it literally true? IIRC, we need ->pi_lock if the task is not active,
> and rq->lock if p->on_rq = 1. And that is why we do not clear p->on_rq
> between deactivate_task() + activate_task(), correct?
> 
> > +	 *
> > +	 * sched_move_task() holds both and thus holding either pins the cgroup,
> > +	 * see set_task_rq().
> > +	 *
> > +	 * Furthermore, all task_rq users should acquire both locks, see
> > +	 * task_rq_lock().
> > +	 */
> >  	WARN_ON_ONCE(debug_locks && !(lockdep_is_held(&p->pi_lock) ||
> >  				      lockdep_is_held(&task_rq(p)->lock)));
> 
> IOW, perhaps this should be
> 
> 	WARN_ON_ONCE(debug_locks && !lockdep_is_held(p->on_rq ?
> 					&task_rq(p)->lock : &p->pi_lock))
> 
> ?
> 
> Not that I really suggest to change this WARN_ON(), I am just trying
> to recall the new rules.

You're right, p->pi_lock for wakeups, rq->lock for runnable tasks.
