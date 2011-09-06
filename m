Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1IFO60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:58:26 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35435 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab1IFO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:58:13 -0400
Date: Tue, 6 Sep 2011 16:58:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/4] nohz: Split extended quiescent state handling from
 nohz switch
Message-ID: <20110906145758.GD28205@somewhere.redhat.com>
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
 <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
 <20110904233643.GN2411@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904233643.GN2411@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 04, 2011 at 04:36:43PM -0700, Paul E. McKenney wrote:
> On Sat, Aug 20, 2011 at 07:30:49PM +0200, Frederic Weisbecker wrote:
> > It is assumed that rcu won't be used once we switch to tickless
> > mode and until we restart the tick. However this is not always
> > true, as in x86-64 where we dereference the idle notifiers after
> > the tick is stopped.
> > 
> > To prepare for fixing this, split the tickless mode switching and
> > RCU extended quiescent state logics.
> > Make tick_nohz_stop/restart_sched_tick() RCU agnostic but provide
> > a new pair of APIs tick_nohz_enter/exit_idle() that keep the
> > old behaviour by handling both the nohz mode and RCU extended
> > quiescent states, then convert every archs to use these.
> > 
> > Archs that want to switch to RCU extended QS to some custom points
> > can do it later by changing the parameter in tick_nohz_enter,exit_idle()
> > to false and call rcu_enter,exit() separately.
> 
> This approach looks quite good to me!  A few comments below.
> 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: David Miller <davem@davemloft.net>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> > Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> > Cc: Mike Frysinger <vapier@gentoo.org>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > ---
> 
> [ . . . ]
> 
> > diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
> > index 39a2baa..b30ddf1 100644
> > --- a/arch/powerpc/kernel/idle.c
> > +++ b/arch/powerpc/kernel/idle.c
> > @@ -56,7 +56,7 @@ void cpu_idle(void)
> > 
> >  	set_thread_flag(TIF_POLLING_NRFLAG);
> >  	while (1) {
> > -		tick_nohz_stop_sched_tick(1);
> > +		tick_nohz_enter_idle(true);
> 
> This needs to pass false, as some variants of powerpc use event tracing
> (which in turn uses RCU) just before returning to the hypervisor.

Right. But I wanted this patch to only perform the API conversion, then
later pushdown the rcu_enter_nohz() things.
 
> >  		while (!need_resched() && !cpu_should_die()) {
> >  			ppc64_runlatch_off();
> > 
> > @@ -93,7 +93,7 @@ void cpu_idle(void)
> > 
> >  		HMT_medium();
> >  		ppc64_runlatch_on();
> > -		tick_nohz_restart_sched_tick();
> > +		tick_nohz_exit_idle(true);
> 
> As does this, as some variants of powerpc use event tracing just after
> the hypervisor returns control to the OS.

Right

<snip>
> > +/**
> > + * tick_nohz_enter_idle - stop the tick from the idle task
> > + * @rcu_ext_qs: enter rcu dynticks idle mode
> > + *
> > + * When an arch doesn't make any use of rcu read side critical section
> > + * between tick_nohz_enter_idle() and tick_nohz_exit_idle() it can set
> > + * rcu_ext_qs to 1. Otherwise it needs to call rcu_enter_nohz() itself
> > + * later before the CPU goes to sleep.
> 
> How about something like this?
> 
> + * When an arch doesn't make any use of rcu read side critical section
> + * between tick_nohz_enter_idle() and the time the CPU is put to sleep,
> + * it can set rcu_ext_qs to true. Otherwise it needs set rcu_ext_qs to
> + * false, and then to call rcu_enter_nohz() itself later, but before the
> + * CPU goes to sleep and after its last use of RCU.

Better yeah, I'll use your version ;)
 
> > + */
> > +void tick_nohz_enter_idle(bool rcu_ext_qs)
> > +{
> > +	if (tick_nohz_stop_sched_tick(1) && rcu_ext_qs)
> > +		rcu_enter_nohz();
> >  }
> > 
> >  /**
> > @@ -486,11 +505,12 @@ static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
> >  }
> > 
> >  /**
> > - * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
> > + * tick_nohz_exit_idle - restart the idle tick from the idle task
> > + * @rcu_ext_qs: exit rcu dynticks idle mode
> >   *
> >   * Restart the idle tick when the CPU is woken up from idle
> 
> How about something like the following?
> 
> + * When an arch doesn't make any use of rcu read side critical section
> + * between the time the CPU wakes up and tick_nohz_exit_idle(), it can set
> + * rcu_ext_qs to true. Otherwise it needs set rcu_ext_qs to false, and it
> + * must also have called rcu_enter_nohz() itself earlier, after the CPU
> + * was awakened, but before its first use of RCU.

Right, but to keep things clear, as long as we call tick_nohz_enter_idle(false)
and rcu_enter_nohz() later, we should keep the same mirroring with rcu_exit_nohz()
and tick_nohz_exit_idle(false).
