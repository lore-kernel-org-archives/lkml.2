Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab1LOBmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 20:42:52 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:40016 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab1LOBmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 20:42:51 -0500
Date: Wed, 14 Dec 2011 17:41:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.3
Message-ID: <20111215014113.GJ2862@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111213230243.GA15127@linux.vnet.ibm.com>
 <20111214154736.GA2419@elte.hu>
 <20111214163007.GD10791@somewhere.redhat.com>
 <20111214174736.GF10791@somewhere.redhat.com>
 <1323912922.1984.229.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323912922.1984.229.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11121501-7408-0000-0000-000001451D06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 05:35:22PM -0800, Suresh Siddha wrote:
> On Wed, 2011-12-14 at 09:47 -0800, Frederic Weisbecker wrote:
> > I don't know how you plan to fix the conflict, by redoing the merge or by
> > applying a patch on tip/master.
> > 
> > In any case, here is a patch you can use. Feel free to apply it as is
> > or to just refer to its diff to redo the merge:
> > 
> > (Outrageously only compile tested)
> > 
> > ---
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Date: Wed, 14 Dec 2011 18:36:00 +0100
> > Subject: [PATCH] sched: Only update the CPU idleness in the domain
> >  hierarchy from idle loop entry
> > 
> > We don't need to inform the sched domain hierarchy about the
> > CPU idleness everytime we call tick_nohz_stop_sched_tick() as this
> > includes both idle loop entry and idle interrupt exit.
> > 
> > Doing it once from the idle loop entry is enough, call
> > set_cpu_sd_state_idle() only from tick_nohz_idle_enter() instead
> > to fix this.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> > ---
> >  kernel/time/tick-sched.c |   16 ++++++++--------
> >  1 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 1f6dc515..696c997 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -289,14 +289,6 @@ static void tick_nohz_stop_sched_tick(struct tick_sched *ts)
> >         now = tick_nohz_start_idle(cpu, ts);
> > 
> >         /*
> > -        * Update the idle state in the scheduler domain hierarchy
> > -        * when tick_nohz_stop_sched_tick() is called from the idle loop.
> > -        * State will be updated to busy during the first busy tick after
> > -        * exiting idle.
> > -        */
> > -       set_cpu_sd_state_idle();
> > -
> > -       /*
> >          * If this cpu is offline and it is the one which updates
> >          * jiffies, then give up the assignment and let it be taken by
> >          * the cpu which runs the tick timer next. If we don't drop
> > @@ -483,6 +475,14 @@ void tick_nohz_idle_enter(void)
> >          * update of the idle time accounting in tick_nohz_start_idle().
> >          */
> >         ts->inidle = 1;
> > +
> > +       /*
> > +        * Update the idle state in the scheduler domain hierarchy
> > +        * when tick_nohz_idle_enter() is called from the idle loop.
> > +        * State will be updated to busy during the first busy tick after
> > +        * exiting idle.
> > +        */
> > +       set_cpu_sd_state_idle();
> >         tick_nohz_stop_sched_tick(ts);
> > 
> >         local_irq_enable();
> > --
> > 1.7.5.4
> > 
> > 
> 
> 

