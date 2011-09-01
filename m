Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab1IAKjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 06:39:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:35064 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab1IAKjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 06:39:09 -0400
Date: Thu, 1 Sep 2011 12:39:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: process time < thread time?
In-Reply-To: <1314871884.7945.20.camel@twins>
Message-ID: <alpine.LFD.2.02.1109011226160.2723@ionos>
References: <20110831.230718.2029810906806382170.davem@davemloft.net>  <alpine.LFD.2.02.1109011148060.2723@ionos> <1314871884.7945.20.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Peter Zijlstra wrote:

> On Thu, 2011-09-01 at 11:56 +0200, Thomas Gleixner wrote:
> > The untested patch below should cure this.
> > 
> 
> > diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> > index 58f405b..42378cb 100644
> > --- a/kernel/posix-cpu-timers.c
> > +++ b/kernel/posix-cpu-timers.c
> > @@ -250,7 +250,7 @@ void thread_group_cputime(struct task_struct *tsk,
> > struct task_cputime *times)
> >         do {
> >                 times->utime = cputime_add(times->utime, t->utime);
> >                 times->stime = cputime_add(times->stime, t->stime);
> > -               times->sum_exec_runtime += t->se.sum_exec_runtime;
> > +               times->sum_exec_runtime += task_sched_runtime(t);
> >         } while_each_thread(tsk, t);
> >  out:
> >         rcu_read_unlock(); 
> 
> I think we just deadlocked:

That's why I said untested :)
 
> cpu_clock_sample_group()
>   CPUCLOCK_SCHED: thread_group_sched_runtime()
>     task_rq_lock()        <-.
>     thread_group_cputime()  |
>       task_sched_runtime()  |
>        task_rq_lock() ------'
> 
> 
> Also, having to take locks here is sad, but yeah if we want to cure this
> there's not much we can do about that.

Yeah :(
 
