Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab2BDOaz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 09:30:55 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47630 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2BDOay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 09:30:54 -0500
Date: Sat, 4 Feb 2012 06:30:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 14/47] rcu: Limit lazy-callback duration
Message-ID: <20120204143022.GB2467@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328319922-30828-14-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120204135456.GE13382@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120204135456.GE13382@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020414-3270-0000-0000-000003BB9D55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 02:54:58PM +0100, Frederic Weisbecker wrote:
> On Fri, Feb 03, 2012 at 05:44:49PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > Currently, a given CPU is permitted to remain in dyntick-idle mode
> > indefinitely if it has only lazy RCU callbacks queued.  This is vulnerable
> > to corner cases in NUMA systems, so limit the time to six seconds by
> > default.  (Currently controlled by a cpp macro.)
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree_plugin.h |   12 +++++++++++-
> >  1 files changed, 11 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index eeb2cc6..8041310 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -2050,6 +2050,9 @@ static void rcu_prepare_for_idle(int cpu)
> >   *	number, be warned: Setting RCU_IDLE_GP_DELAY too high can hang your
> >   *	system.  And if you are -that- concerned about energy efficiency,
> >   *	just power the system down and be done with it!
> > + * RCU_IDLE_LAZY_GP_DELAY gives the number of jiffies that a CPU is
> > + *	permitted to sleep in dyntick-idle mode with only lazy RCU
> > + *	callbacks pending.  Setting this too high can OOM your system.
> >   *
> >   * The values below work well in practice.  If future workloads require
> >   * adjustment, they can be converted into kernel config parameters, though
> > @@ -2058,11 +2061,13 @@ static void rcu_prepare_for_idle(int cpu)
> >  #define RCU_IDLE_FLUSHES 5		/* Number of dyntick-idle tries. */
> >  #define RCU_IDLE_OPT_FLUSHES 3		/* Optional dyntick-idle tries. */
> >  #define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
> > +#define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
> >  
> >  static DEFINE_PER_CPU(int, rcu_dyntick_drain);
> >  static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
> >  static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
> > -static ktime_t rcu_idle_gp_wait;
> > +static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
> > +static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
> >  
> >  /*
> >   * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
> > @@ -2151,6 +2156,8 @@ static void rcu_prepare_for_idle_init(int cpu)
> >  		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
> >  
> >  		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
> > +		upj = jiffies_to_usecs(6 * HZ);
> 
> I think you meant to use RCU_IDLE_LAZY_GP_DELAY here?

Good catch!!!  Indeed I do, fixed.

> 
> > +		rcu_idle_lazy_gp_wait = ns_to_ktime(upj * (u64)1000);
> >  		firsttime = 0;
> >  	}
> >  }
> > @@ -2225,6 +2232,9 @@ static void rcu_prepare_for_idle(int cpu)
> >  		if (rcu_cpu_has_nonlazy_callbacks(cpu))
> >  			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
> >  				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
> > +		else
> > +			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
> > +				      rcu_idle_lazy_gp_wait, HRTIMER_MODE_REL);
> 
> Might be a good idea to cancel it from rcu_cleanup_after_idle() to avoid
> needless hrtimer interrupt (if something else woke up from idle before it
> triggered).

Very much so!  And rcu_cleanup_after_idle() is in fact defined as:

static void rcu_cleanup_after_idle(int cpu)
{
	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
}

The reason this does not appear in this patch is that it is already in
mainline.

> >  		return; /* Nothing more to do immediately. */
> >  	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
> >  		/* We have hit the limit, so time to give up. */
> > -- 
> > 1.7.8
> > 
> 

