Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0DEVD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:03:57 -0400
Received: from isilmar.linta.de ([213.133.102.198]:48935 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756367Ab0DEVDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:03:50 -0400
Date: Mon, 5 Apr 2010 23:03:40 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100405210340.GA4638@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Dmitry Torokhov <dtor@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404233702.GA24102@linux.vnet.ibm.com>
 <20100404204725.GC2644@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

I really appreaciate your reply -- thanks! I've done some more testing in
the meantime:

On Sun, Apr 04, 2010 at 01:47:25PM -0700, Paul E. McKenney wrote:
> On Sun, Apr 04, 2010 at 06:39:24PM +0200, Dominik Brodowski wrote:
> > On Sun, Apr 04, 2010 at 11:17:37AM -0400, Alan Stern wrote:
> > > On Sun, 4 Apr 2010, Dominik Brodowski wrote:
> > > 
> > > > Booting a SMP-capable kernel with "nosmp", or manually offlining one CPU
> > > > (or -- though I haven't tested it -- booting a SMP-capable kernel on a
> > > > system with merely one CPU) means that in up to about half of the calls to
> > > > tick_nohz_stop_sched_tick() are aborted due to rcu_needs_cpu(). This is
> > > > quite strange to me: AFAIK, RCU is an excellent tool for SMP, but not really
> > > > needed for UP?
> > > 
> > > I can't answer the real question here, not knowing enough about the RCU
> > > implementation.  However, your impression is wrong: RCU very definitely
> > > _is_ useful and needed on UP systems.  It coordinates among processes
> > > (and interrupt handlers) as well as among processors.
> > 
> > Okay, but still: can't this be sped up by much on UP (especially if
> > CONFIG_RCU_FAST_NO_HZ is set), so that we can go to sleep right away?
> 
> One situation that will prevent CONFIG_RCU_FAST_NO_HZ from putting the
> machine to sleep right away is if there is an RCU callback posted that
> spawns another RCU callback, and so on.  CONFIG_RCU_FAST_NO_HZ will handle
> one callback that spawns another, but it gives up if the second callback
> spawns a third.

Will the remaining callbacks be executed immediately afterwards (due to a
need_resched() etc.), or only after the next tick?

> Might this be what is happening to you?
> 
> If so, would you be willing to patch your kernel?  RCU_NEEDS_CPU_FLUSHES
> is currently set to 5, and might be set to (say) 8.  This is defined
> in kernel/rcutree_plugin.h, near line 990.

Applied the patch by Lai Jiangshan, and tested 5 and 8:

5:	  Wakeups-from-idle: 33.4		(hrtimer_sched_timer: 78 %)
		34% of calls to tick_nohz_stop_sched_tick fail due to
			rcu_needs_cpu()
8:	  Wakeups-from-idle: 36.5		(hrtimer_sched_timer: 83 %)
		37% of calls to tick_nohz_stop_sched_tick fail due to
			rcu_needs_cpu()

> Another thing to try would be running with TINY_RCU, at least if it is
> OK that RCU be non-preemptible.

tick_nohz_stop_sched_tick() doesn't fail in this case because of
rcu_needs_cpu(). However, the improvements are hardly recognizable:

TINY_RCU: Wakeups-from-idle: 33.9		(hrtimer_sched_timer: 53 %)

> And you did mention offlining some CPUs above. 

... just for testing how NOHZ works on UP systems ;)

Best,
	Dominik
