Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab0INBVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 21:21:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39263 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0INBVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 21:21:33 -0400
X-Authority-Analysis: v=1.1 cv=FR6uSFBUsHpo/LPxUdUfz19YCIdHKFi4UJmy4GdSgrg= c=1 sm=0 a=g-sa0-2UbzsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VqFD3jB2iIVMlfmvMqIA:9 a=yoA-tB6M3bMcFPUC5MAA:7 a=t9msqxRvD4FVOS_YT3AJnHNdTdoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC] get rid of cpupri lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: ghaskins@novell.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100913211759.GB3207@think>
References: <20100913180415.GT21374@think>
	 <1284405110.17152.86.camel@gandalf.stny.rr.com>
	 <20100913211759.GB3207@think>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Sep 2010 21:21:30 -0400
Message-ID: <1284427290.5701.60.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 17:17 -0400, Chris Mason wrote:
> On Mon, Sep 13, 2010 at 03:11:49PM -0400, Steven Rostedt wrote:
> > On Mon, 2010-09-13 at 14:04 -0400, Chris Mason wrote:
> > > I recently had the chance to try and tune 2.6.32 kernels running oracle
> > > on OLTP workloads.  One of the things oracle loves to do for tuning
> > > these benchmarks is make all the database tasks involved SCHED_FIFO.
> > > This is because they have their own userland locks and if they get
> > > scheduled out, lock contention goes up.
> > 
> > And each thread is bound to its own CPU, right?
> 
> Each to a socket, so they can move between 16 different cpus.
> 
> > 
> > > 
> > > <please insert flames about userland locking here>
> > 
> > Userland locking sucks sucks sucks!!!
> 
> That's pretty weak, you didn't use all the placeholders!
> 
> > 
> > > 
> > > <and here>


And it sucks here
> > > 
> > > <and here>

and it sucks even more here!!!!

Better?

> > > 
> > > The box I was tuning had 8 sockets and the first thing that jumped out
> > > at me during the run was that we were spending all our system time
> > > inside cpupri_set.  Since the rq lock must be held in cpurpi_set, I
> > > don't think we need the cpupri lock at all.
> > > 
> > > The patch below is entirely untested, mostly because I'm hoping for
> > > hints on good ways to test it.  Clearly Oracle RT isn't the workload we
> > > really want to tune for, but I think this change is generally useful if
> > > we can do it safely.
> > > 
> > > cpusets could also be used to mitigate this problem, but if we can just
> > > avoid the lock it would be nice.
> > > 
> > > diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
> > > index 2722dc1..dd51302 100644
> > > --- a/kernel/sched_cpupri.c
> > > +++ b/kernel/sched_cpupri.c
> > > @@ -115,7 +115,6 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
> > >  {
> > >  	int                 *currpri = &cp->cpu_to_pri[cpu];
> > >  	int                  oldpri  = *currpri;
> > > -	unsigned long        flags;
> > >  
> > >  	newpri = convert_prio(newpri);
> > >  
> > > @@ -134,26 +133,15 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
> > >  	if (likely(newpri != CPUPRI_INVALID)) {
> > >  		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
> > >  
> > > -		raw_spin_lock_irqsave(&vec->lock, flags);
> > > -
> > >  		cpumask_set_cpu(cpu, vec->mask);
> > > -		vec->count++;
> > > -		if (vec->count == 1)
> > > +		if (atomic_inc_return(&vec->count) == 1)
> > >  			set_bit(newpri, cp->pri_active);
> > > -
> > > -		raw_spin_unlock_irqrestore(&vec->lock, flags);
> > 
> > IIRC we tried this at first (Gregory?). The problem is that you just
> > moved the setting of the vec->mask outside of the updating of the vec
> > count. I don't think rq lock helps here at all.
> > 
> 
> Hmm who are we racing with?  There isn't another CPU updating masks for
> this CPU (we have the rq lock).  There could be someone reading the
> various masks but they are already racing because they are lock free.

Does not need to be touching the same CPU, just two different CPUs with
same prio tasks. One losing one, the other gaining one.


if CPU1 newpri == CPU2 oldpri, where CPU2 is losing a task with the
given prio, and CPU1 is gaining a task with the same prio. Going into
this, we have vec->count == 1.


    	   CPU1					   CPU2
	-----------				-----------
					atomic_dec_and_test == true
	atomic_inc_return == 1
	set_bit(newpri, cpu->pri_active)
					clear_bit(oldpri, cpu->pri_active)

Now the bit is cleared when it should be set.


> > I'll look into this too.
> 
> Great, thanks.  You'll notice I don't have any numbers about having
> fixed this...once this lock is gone we slam into the rq locks while
> dealing with the queue of RT overloaded CPUs.

Actually, there's something about the queuing of RT tasks on SMP that I
hate. First, RT and SMP hate each other anyway and never play nice. They
are constantly fighting, and we need to keep pulling them apart on the
playground. First, SMP makes RT sit on the bench for a long time and
keeps it from playing when it wants to, then RT gets back at SMP by
slapping it around, and throwing its tasks all over the place and making
SMP try to go and organize them again. Its a hopeless cause. I think
I'll just send them both off to juvenile detention and let them sulk.
Perhaps they will behave nicer in the future, but I doubt it. They are
just sworn enemies.


When two RT tasks that can both migrate are are scheduled on the same
CPU, the second one that comes in will migrate off of it. On wakeup, it
will see that another RT task is running, and will go find another CPU
to run on if it can. Even if the wake up is higher priority. I need to
change that. Maybe I'll do that tomorrow. The idea was, if you are
waking up, you are most likely cache cold, and why boot off a cache hot
process, when you can easily migrate. But this causes issues when a task
sleeps on a mutex and a lower prio runs in place, and if it wakes up the
higher task, it makes the higher task move to another CPU, even though
the higher task had a cache hot CPU.

Tomorrow, I'll do some traces on this to make sure this is happening and
has the bad behavior that I expect it will have. I'll also do some
benchmarks and see what affects it has. And finally, if everything is as
I feel it will be. I'll write a patch to fix it.

-- Steve


> 
> That one is next ;)
> 
> -chris
> 
> > 
> > -- Steve
> > 
> > >  	}
> > >  	if (likely(oldpri != CPUPRI_INVALID)) {
> > >  		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
> > > -
> > > -		raw_spin_lock_irqsave(&vec->lock, flags);
> > > -
> > > -		vec->count--;
> > > -		if (!vec->count)
> > > +		if (atomic_dec_and_test(&vec->count))
> > >  			clear_bit(oldpri, cp->pri_active);
> > >  		cpumask_clear_cpu(cpu, vec->mask);
> > > -
> > > -		raw_spin_unlock_irqrestore(&vec->lock, flags);
> > >  	}
> > >  
> > >  	*currpri = newpri;
> > > @@ -174,9 +162,8 @@ int cpupri_init(struct cpupri *cp)
> > >  
> > >  	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
> > >  		struct cpupri_vec *vec = &cp->pri_to_cpu[i];
> > > +		atomic_set(&vec->count, 0);
> > >  
> > > -		raw_spin_lock_init(&vec->lock);
> > > -		vec->count = 0;
> > >  		if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
> > >  			goto cleanup;
> > >  	}
> > > diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
> > > index 9fc7d38..fe07002 100644
> > > --- a/kernel/sched_cpupri.h
> > > +++ b/kernel/sched_cpupri.h
> > > @@ -12,8 +12,7 @@
> > >  /* values 2-101 are RT priorities 0-99 */
> > >  
> > >  struct cpupri_vec {
> > > -	raw_spinlock_t lock;
> > > -	int        count;
> > > +	atomic_t   count;
> > >  	cpumask_var_t mask;
> > >  };
> > >  
> > 
> > 


