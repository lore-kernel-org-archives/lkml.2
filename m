Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0DSOG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:06:56 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42160 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752193Ab0DSOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:06:55 -0400
Date: Mon, 19 Apr 2010 10:06:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC patch] CFS fix place entity spread issue (v2)
Message-ID: <20100419140652.GA26853@Krystal>
References: <20100418131302.GA3614@Krystal> <1271669135.1674.615.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271669135.1674.615.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:55:47 up 86 days, 16:32,  2 users,  load average: 0.09, 0.02,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Sun, 2010-04-18 at 09:13 -0400, Mathieu Desnoyers wrote:
> 
> > Detailed explanation in my ELC2010 presentation at:
> > 
> > http://www.efficios.com/elc2010
> 
> So what happened to comprehensive changelogs?
> 
> > I've torn the CFS scheduler apart in the past days to figure out what is causing
> > this weird behavior, and the culprit seems to be place_entity(). The problem
> > appears to be the cumulative effect of letting the min_vruntime go backward when
> > putting sleepers back on the runqueue.
> 
> Right, that should not happen, ever, min_vruntime should be monotonic.
> Your explanation fails to mention how exactly this happens.
> 
> >  It lets the vruntime spread grow to
> > "entertaining" values (it is supposed to be in the 5ms range, not 18 minutes!).
> > 
> > In the original code, a max between the sched entity vruntime and the calculated
> > vruntime was supposed to "ensure that the thread time never go backward". But I
> > don't see why we even care about that.
> 
> Fairness, a task's vruntime going backwards means it can obtain more
> cputime than a while(1) loop would get, not a good thing.
> 
> >  The key point is that the min_vruntime
> > of the runqueue should not go backward.
> 
> That is certainly important too.
> 
> > I propose to fix this by calculating the relative offset from
> > min_vruntime + sysctl_sched_latency rather than directly from min_vruntime. I
> > also ensure that the value never goes below min_vruntime.
> 
> I'm not sure that's a good idea, that'll end up being a 'fairer'
> scheduler in the strict sense, but I suspect it will break the wakeup
> preemption model we have.
> 
> > Under the Xorg workload, moving a few windows around and starting firefox while
> > executing the wakeup-latency.c program (program waking up every 10ms and
> > reporting wakeup latency), this patch brings worse latency from 60ms down to
> > 12ms. Even doing a kernel compilation at the same time, the worse latency stays
> > around 20ms now.
> 
> That seems nice enough. But really, this changelog doesn't explain the
> cause at all.
> 
> /me goes try and figure out where this min_vruntime goes backwards.
> 
> So update_min_vruntime() is the sole place where we change min_vruntime,
> it is called from update_curr() where we add runtime to the task we're
> currently servicing, and dequeue_entity() where we remove someone from
> the tree.
> 
> These two sites are the only places where min_vruntime can change
> because only adding service to the leftmost task, or removal thereof can
> make the min_vruntime go forward.
> 
> So update_min_vruntime():
> 
>  - takes the smaller vruntime between the current task and the leftmost
> tree entry (current is not in the tree, and we can pass beyond the
> leftmost waiting task due to limited preemption and minimum service
> windows).
> 
>  - set min_vruntime to the larger between the existing min_vruntime and
> the smallest vruntime.
> 
> So colour me confused if I'm not seeing min_vruntime going backwards...

place_entity(), when placing a sleeper on the runqueue, decrements its vruntime
(derived from min_vruntime) from -= thresh (derived from load calculation). So
if we end up with a task woken up that does not consume enough vruntime to pass
the previous min_vruntime value, we effectively decrement min_vruntime.

The other thing I am currently looking into is that, without even considering
the question of going lower than min_vruntime, given that a woken up sleeper
gets an extra share of vruntime (still because of place_entity), it might always
run between -thresh to the previous min_runtime, therefore "stalling" the
min_vruntime values at low values while other threads push the maximum vruntime
higher, therefore increasing the spread. I'm currently doing some tests trying
to cope with this by consuming woken up sleepers vruntime more quickly for a
vruntime duration of "thresh".

I am also testing alternatives ways to deal with the min_vruntime going backward
problem, by keeping a "floor_vruntime", which ensures that place_entity() can
never decrement min_vruntime below the floor value of its previous decrement.

Sorry for the missing changelog info, I was between planes this weekend.
Hopefully my sleep-deprived explanation makes sense. ;)

Thanks,

Mathieu

> 
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
