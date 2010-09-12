Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0ILJGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 05:06:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:40497 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0ILJGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 05:06:46 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
	 <1284237380.2251.56.camel@laptop>
	 <AANLkTi=a91QX-FLURFWNsjbCS1bDLr6GqSpC4_uzm3ta@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 12 Sep 2010 11:06:32 +0200
Message-ID: <1284282392.2251.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 13:48 -0700, Linus Torvalds wrote:
> On Sat, Sep 11, 2010 at 1:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >From what I can make up:
> >
> >  LAT=`cat /proc/sys/kernel/sched_latency_ns`;
> >  echo $((LAT/8)) > /proc/sys/kernel/sched_min_granularity_ns
> >
> > will give you pretty much the same result as Mathieu's patch.
> 
> Or perhaps not. The point being that Mathieu's patch seems to do this
> dynamically based on number of runnable threads per cpu. Which seems
> to be a good idea.
> 
> IOW, this part:
> 
> -       if (delta_exec < sysctl_sched_min_granularity)
> +       if (delta_exec < __sched_gran(cfs_rq->nr_running))
> 
> seems to be a rather fundamental change, and looks at least
> potentially interesting. It seems to make conceptual sense to take the
> number of running tasks into account at that point, no?

We used to have something like that a long while back, we nixed it
because of the division and replaced it with floor(__sched_gran) (ie.
the smallest value it would ever give).

Smaller values are better for latency, larger values are better for
throughput. So introducing __sched_gran() in order to provide larger
values doesn't make sense to me.

> And I don't like how you dismissed the measured latency improvement.
> And yes, I do think latency matters. A _lot_.

OK, we'll make it better and sacrifice some throughput, can do, no
problem.

> And no, I'm not saying that Mathieu's patch is necessarily good. I
> haven't tried it myself. I don't have _that_ kind of opinion. The
> opinion I do have is that I think it's sad how you dismissed things
> out of hand - and seem to _continue_ to dismiss them without
> apparently actually having looked at the patch at all.

Let me draw you a picture of what this patch looks like to me:

 * is slice length, + is period length

Patch (sched_latency = 10, sched_min_gran = 10/3)


30 |                             +
   |
   |
   |                          +
   |
   |
   |
   |
   |
   |
20 |
   |
   |
   |
   |
   |
   |
   |
   |
   |
10 |  *  +  +  +  +  +  +  +
   |
   |
   |
   |
   |     *
   |
   |        *  *              *  *  *  *  *  *
   |              *  *
   |                    *  *
0  +---------------------------------------------------------
   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16


Normal (sched_latency = 10, sched_min_gran = 10/3)


 30 |                          +
    |
    |
    |                       +
    |
    |
    |
    |                    +
    |
    |
 20 |                 +
    |
    |
    |              +
    |
    |                                   
    |                                
    |           +                   
    |
    |           
 10 |  *  +  +  
    |
    |
    |
    |
    |     *
    |
    |        *  *  *  *  *  *  *  *  *  *  *  *  *  *
    |
    |
 0  +---------------------------------------------------------
    0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16



Normal (sched_latency = 10, sched_min_gran = 10/8)

30 |                             
   |
   |
   |                          
   |
   |
   |
   |
   |
   |
20 |
   |
   |
   |
   |
   |                                   +
   |                                +
   |                             +
   |
   |                          +
10 |  *  +  +  +  +  +  +  +
   |
   |
   |
   |
   |     *
   |
   |        *  *              
   |              *  *
   |                    *  *  *  *  *  *  *  *
0  +---------------------------------------------------------
   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16











