Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0ILUe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:34:57 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46371 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753010Ab0ILUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:34:56 -0400
Date: Sun, 12 Sep 2010 16:34:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
	nr_running
Message-ID: <20100912203454.GC32327@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop> <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com> <1284237380.2251.56.camel@laptop> <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com> <1284282392.2251.81.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284282392.2251.81.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:27:31 up 232 days, 23:04,  4 users,  load average: 0.05, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Sat, 2010-09-11 at 13:48 -0700, Linus Torvalds wrote:
> > On Sat, Sep 11, 2010 at 1:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > >From what I can make up:
> > >
> > >  LAT=`cat /proc/sys/kernel/sched_latency_ns`;
> > >  echo $((LAT/8)) > /proc/sys/kernel/sched_min_granularity_ns
> > >
> > > will give you pretty much the same result as Mathieu's patch.
> > 
> > Or perhaps not. The point being that Mathieu's patch seems to do this
> > dynamically based on number of runnable threads per cpu. Which seems
> > to be a good idea.
> > 
> > IOW, this part:
> > 
> > -       if (delta_exec < sysctl_sched_min_granularity)
> > +       if (delta_exec < __sched_gran(cfs_rq->nr_running))
> > 
> > seems to be a rather fundamental change, and looks at least
> > potentially interesting. It seems to make conceptual sense to take the
> > number of running tasks into account at that point, no?
> 
> We used to have something like that a long while back, we nixed it
> because of the division and replaced it with floor(__sched_gran) (ie.
> the smallest value it would ever give).
> 
> Smaller values are better for latency, larger values are better for
> throughput. So introducing __sched_gran() in order to provide larger
> values doesn't make sense to me.

__sched_gran() provides large values for small nr_running, and smaller values
for larger nr_running.

So for systems with few threads running, we have good throughput (and there does
not seem to be much latency issues there). However for a system with a larger
number of running threads, __sched_gran() dynamically reduces the granularity.

> 
> > And I don't like how you dismissed the measured latency improvement.
> > And yes, I do think latency matters. A _lot_.
> 
> OK, we'll make it better and sacrifice some throughput, can do, no
> problem.

My approach try to get lower latencies without sacrificing throughput when there
are few threads running, which IMHO is the common case where throughput really
matters. A system running tons of threads should already expect some sort of
throughput degradation anyway, so we might as well favor low-latency rather than
throughput on those systems running lots of threads.

> 
> > And no, I'm not saying that Mathieu's patch is necessarily good. I
> > haven't tried it myself. I don't have _that_ kind of opinion. The
> > opinion I do have is that I think it's sad how you dismissed things
> > out of hand - and seem to _continue_ to dismiss them without
> > apparently actually having looked at the patch at all.
> 
> Let me draw you a picture of what this patch looks like to me:
> 
>  * is slice length, + is period length
> 
> Patch (sched_latency = 10, sched_min_gran = 10/3)

Hrm, in sched_fair.c, sysctl_sched_latency is set to 6000000ULL. So this would
be a sched_latency = 6, or am I missing something ? With a sched_latency of 6,
the jump you show below in your graph disappears. So what have I missed ?

I agree with the shape of your graph, I'm just trying to understand why you have
a sched_latency of 10.

Thanks,

Mathieu

> 
> 
> 30 |                             +
>    |
>    |
>    |                          +
>    |
>    |
>    |
>    |
>    |
>    |
> 20 |
>    |
>    |
>    |
>    |
>    |
>    |
>    |
>    |
>    |
> 10 |  *  +  +  +  +  +  +  +
>    |
>    |
>    |
>    |
>    |     *
>    |
>    |        *  *              *  *  *  *  *  *
>    |              *  *
>    |                    *  *
> 0  +---------------------------------------------------------
>    0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
> 
> 
> Normal (sched_latency = 10, sched_min_gran = 10/3)
> 
> 
>  30 |                          +
>     |
>     |
>     |                       +
>     |
>     |
>     |
>     |                    +
>     |
>     |
>  20 |                 +
>     |
>     |
>     |              +
>     |
>     |                                   
>     |                                
>     |           +                   
>     |
>     |           
>  10 |  *  +  +  
>     |
>     |
>     |
>     |
>     |     *
>     |
>     |        *  *  *  *  *  *  *  *  *  *  *  *  *  *
>     |
>     |
>  0  +---------------------------------------------------------
>     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
> 
> 
> 
> Normal (sched_latency = 10, sched_min_gran = 10/8)
> 
> 30 |                             
>    |
>    |
>    |                          
>    |
>    |
>    |
>    |
>    |
>    |
> 20 |
>    |
>    |
>    |
>    |
>    |                                   +
>    |                                +
>    |                             +
>    |
>    |                          +
> 10 |  *  +  +  +  +  +  +  +
>    |
>    |
>    |
>    |
>    |     *
>    |
>    |        *  *              
>    |              *  *
>    |                    *  *  *  *  *  *  *  *
> 0  +---------------------------------------------------------
>    0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
