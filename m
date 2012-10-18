Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2JRQfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:35:46 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53456 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab2JRQfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:35:44 -0400
Date: Thu, 18 Oct 2012 09:35:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: restore correct batch limiting
Message-ID: <20121018163525.GJ2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1350458052.26103.31.camel@edumazet-glaptop>
 <20121018115859.GH2518@linux.vnet.ibm.com>
 <1350564290.26103.1496.camel@edumazet-glaptop>
 <20121018152543.GI2518@linux.vnet.ibm.com>
 <1350576628.32642.14.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350576628.32642.14.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101816-7182-0000-0000-000002E005BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 06:10:28PM +0200, Eric Dumazet wrote:
> On Thu, 2012-10-18 at 08:25 -0700, Paul E. McKenney wrote:
> > On Thu, Oct 18, 2012 at 02:44:50PM +0200, Eric Dumazet wrote:
> 
> > > 
> > > Having 2 billions callbacks on one cpu would be problematic, I really
> > > hope nobody relies on this ;)
> > 
> > Fair point!  ;-)
> > 
> > But just making everything long makes it quite easy to analyze.
> > 
> > > I guess the 10/infinity switch should be smarter.
> > > 
> > > something like the following maybe :
> > > 
> > > rdp->blimit = max(blimit, rdp->qlen >> 6);
> > > 
> > > (if queue is big, dont wait to hit 10000 before allowing more items to
> > > be handled per round)
> > 
> > The -rt guys would not be amused.  :-(
> > 
> > But for non-realtime use, increasing rcutree.blimit either at boot or
> > via sysfs could make sense.  It is also likely that I will move callback
> > processing to a kthread at some point, which would allow some additional
> > flexibility.
> > 
> 
> Ah, I now realize the loop can exceed blimit, but is it true for BH
> variant ? (Not really a problem for 3.6/3.7 kernels, but prior ones)

Yep, applies to all the RCU flavors.

> if (++count >= bl &&
>     (need_resched() ||
>      (!is_idle_task(current) && !rcu_is_callbacks_kthread())))
>         break;
> 
> I wonder if ksoftirqd should be included as well...

This would be safe only if ksoftirqd could be guaranteed to be the
lowest-priority process on the given CPU, which I do not believe to be
the case.  The problem is that if ksoftirqd is not the lowest-priority
process on the given CPU, we can seriously delay that other process
for no good reason.  The fact that ksoftirqd does local_bh_disable()
means that the scheduler cannot preempt it, either.  :-(

> > Furthermore, it would be easy to have one default for non-rt and another
> > for -rt, if that would help.
> > 
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > 
> > > Please dont forget stable teams.  (3.2 + )
> > 
> > Added both, please see below!
> 
> Seems fine to me, thanks Paul !

Thank you for everything on this one!

							Thanx, Paul

