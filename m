Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1AUMYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 07:24:30 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58048 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1AUMY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 07:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ilkVTAZkO/sYHGzHxiznk4fXbVWRG56DQje9mDvGzwmCTbQUjuE6CkAk+oKxX9D/gs
         RZ6E8OTbGzIjYpqJ7TCC7O1yTiRvXouPVc5iQrKQDLKYmKUR+XBDvy7UI+j7YWv5ZTc3
         kYzdhWcQ7J9oPjK8riIKKNharRsT+e/5X+1fY=
Date: Fri, 21 Jan 2011 20:24:12 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bug in scheduler when using rt_mutex
Message-ID: <20110121122412.GA5071@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1295443822.28776.23.camel@laptop>
 <AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
 <1295499568.8027.30.camel@marge.simson.net>
 <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
 <1295503938.8027.59.camel@marge.simson.net>
 <AANLkTi=7YyA-e8HAq+C_prK2EaZKcaTfzDJvmO3e3W=B@mail.gmail.com>
 <1295512625.8027.88.camel@marge.simson.net>
 <AANLkTi=WhLy=4MNdm-HaOUOmbKXsNSJojnzqRTYp6qop@mail.gmail.com>
 <1295518047.8027.104.camel@marge.simson.net>
 <1295608136.28776.266.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1295608136.28776.266.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 12:08:56PM +0100, Peter Zijlstra wrote:
> > That's ok, we don't and aren't supposed to care what happens while he's
> > gone.  But we do have to make sure that vruntime is sane either when he
> > leaves, or when he comes back.  Seems to me the easiest is clip when he
> > leaves to cover him having slept a long time before leaving, then coming
> > back on us as a runner.  If he comes back as a sleeper, he'll be clipped
> > again anyway, so all is well.
> >
> > sched_fork() should probably zero child's vruntime too, so non-fair
> > children can't enter fair_class with some bogus lag they never had.
> 
> Something like so?
> 
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2624,6 +2624,8 @@ void sched_fork(struct task_struct *p, i
>  
>  	if (!rt_prio(p->prio))
>  		p->sched_class = &fair_sched_class;
> +	else
> +		p->se.vruntime = 0;

This can be moved to __sched_fork()

>  
>  	if (p->sched_class->task_fork)
>  		p->sched_class->task_fork(p);
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -4086,8 +4086,14 @@ static void switched_from_fair(struct rq
>  	 * have normalized the vruntime, if it was !on_rq, then only when
>  	 * the task is sleeping will it still have non-normalized vruntime.
>  	 */
> -	if (!se->on_rq && p->state != TASK_RUNNING)
> +	if (!se->on_rq && p->state != TASK_RUNNING) {
> +		/*
> +		 * Fix up our vruntime so that the current sleep doesn't
> +		 * cause 'unlimited' sleep bonus.
> +		 */
> +		place_entity(cfs_rq, se, 0);
>  		se->vruntime -= cfs_rq->min_vruntime;

Now I will say yes.
Though it's same to my suggestion which was rejected by myself :)

Thanks,
Yong
