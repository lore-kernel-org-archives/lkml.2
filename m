Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1EBILb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:11:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54632 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1EBIL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:11:28 -0400
Date: Mon, 2 May 2011 01:11:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 31/86] rcu: further lower priority in
 rcu_yield()
Message-ID: <20110502081121.GT2297@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-31-git-send-email-paulmck@linux.vnet.ibm.com>
 <1304272264.7417.20.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304272264.7417.20.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 07:51:04PM +0200, Mike Galbraith wrote:
> On Sun, 2011-05-01 at 06:21 -0700, Paul E. McKenney wrote:
> > From: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > Although rcu_yield() dropped from real-time to normal priority, there
> > is always the possibility that the competing tasks have been niced.
> > So nice to 19 in rcu_yield() to help ensure that other tasks have a
> > better chance of running.
> 
> But.. that just prolongs the pain of overhead you _have_ to eat, no?  In
> a brief surge, fine, you can spread the cost out.. but how do you know
> when it's ok to yield?

I modeled this code on the existing code in ksoftirqd.  But yes, this is
a heuristic.  I do believe that it is quite robust, but time will tell.

> (When maintenance threads worrying about their CPU usage is worrisome.)

Indeed.  But I am not introducing this, just moving the existing checking
from ksoftirqd.

So I believe that I am OK here.

							Thanx, Paul

> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 3295c7b..963b4b1 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1561,6 +1561,7 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
> >  	mod_timer(&yield_timer, jiffies + 2);
> >  	sp.sched_priority = 0;
> >  	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
> > +	set_user_nice(current, 19);
> >  	schedule();
> >  	sp.sched_priority = RCU_KTHREAD_PRIO;
> >  	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
> 
> 
