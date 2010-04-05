Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0DEWLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:11:41 -0400
Received: from isilmar.linta.de ([213.133.102.198]:42013 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932080Ab0DEWL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:11:27 -0400
Date: Tue, 6 Apr 2010 00:11:23 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100405221123.GA1903@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Dmitry Torokhov <dtor@mail.ru>
References: <20100404233702.GA24102@linux.vnet.ibm.com> <20100404204725.GC2644@linux.vnet.ibm.com> <20100405210340.GA4638@comet.dominikbrodowski.net> <20100405213852.GI2525@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405213852.GI2525@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 02:38:52PM -0700, Paul E. McKenney wrote:
> On Mon, Apr 05, 2010 at 11:03:40PM +0200, Dominik Brodowski wrote:
> > Paul,
> > 
> > I really appreaciate your reply -- thanks! I've done some more testing in
> > the meantime:
> > 
> > On Sun, Apr 04, 2010 at 01:47:25PM -0700, Paul E. McKenney wrote:
> > > On Sun, Apr 04, 2010 at 06:39:24PM +0200, Dominik Brodowski wrote:
> > > > On Sun, Apr 04, 2010 at 11:17:37AM -0400, Alan Stern wrote:
> > > > > On Sun, 4 Apr 2010, Dominik Brodowski wrote:
> > > > > 
> > > > > > Booting a SMP-capable kernel with "nosmp", or manually offlining one CPU
> > > > > > (or -- though I haven't tested it -- booting a SMP-capable kernel on a
> > > > > > system with merely one CPU) means that in up to about half of the calls to
> > > > > > tick_nohz_stop_sched_tick() are aborted due to rcu_needs_cpu(). This is
> > > > > > quite strange to me: AFAIK, RCU is an excellent tool for SMP, but not really
> > > > > > needed for UP?
> > > > > 
> > > > > I can't answer the real question here, not knowing enough about the RCU
> > > > > implementation.  However, your impression is wrong: RCU very definitely
> > > > > _is_ useful and needed on UP systems.  It coordinates among processes
> > > > > (and interrupt handlers) as well as among processors.
> > > > 
> > > > Okay, but still: can't this be sped up by much on UP (especially if
> > > > CONFIG_RCU_FAST_NO_HZ is set), so that we can go to sleep right away?
> > > 
> > > One situation that will prevent CONFIG_RCU_FAST_NO_HZ from putting the
> > > machine to sleep right away is if there is an RCU callback posted that
> > > spawns another RCU callback, and so on.  CONFIG_RCU_FAST_NO_HZ will handle
> > > one callback that spawns another, but it gives up if the second callback
> > > spawns a third.
> > 
> > Will the remaining callbacks be executed immediately afterwards (due to a
> > need_resched() etc.), or only after the next tick?
> 
> Only after the next tick.  To see why, imagine an RCU callback that
> re-registers itself -- which is a perfectly legal thing to do.  The
> only thing that will happen if we run through grace periods faster is
> that we will have more invocations of that same callback to deal with.
> 
> So we try for a bit, and if that doesn't get rid of all of the callbacks,
> we hold off until the next jiffy.
> 
> > > Might this be what is happening to you?
> > > 
> > > If so, would you be willing to patch your kernel?  RCU_NEEDS_CPU_FLUSHES
> > > is currently set to 5, and might be set to (say) 8.  This is defined
> > > in kernel/rcutree_plugin.h, near line 990.
> > 
> > Applied the patch by Lai Jiangshan, and tested 5 and 8:
> > 
> > 5:	  Wakeups-from-idle: 33.4		(hrtimer_sched_timer: 78 %)
> > 		34% of calls to tick_nohz_stop_sched_tick fail due to
> > 			rcu_needs_cpu()
> > 8:	  Wakeups-from-idle: 36.5		(hrtimer_sched_timer: 83 %)
> > 		37% of calls to tick_nohz_stop_sched_tick fail due to
> > 			rcu_needs_cpu()
> 
> I don't recall your posting wakeups-from-idle for the original -- did
> we get improvement?  You did say "roughly 50%", but...

Actually, no. I'd say the 5-to-8 change has no significant effect at all;
for the Patch by Lai Jiangshan, I'd need to re-run the test.

> OK, I see what is happening...
> 
> What happens in the CONFIG_RCU_FAST_NO_HZ case is as follows:
> 
> o	Check to see if the holdoff period is in effect, and if so,
> 	just check to see if RCU needs the CPU for later processing
> 	without attempting to accelerate grace periods.
> 
> o	Check to see if there is some other non-dyntick-idle CPU.
> 	If there is, reset holdoff state and just check to see if
> 	RCU needs the CPU for later processing without attempting to
> 	accelerate grace periods.
> 
> o	Check for initialization and hitting the RCU_NEEDS_CPU_FLUSHES
> 	limit, again doing the "just check" thing if we hit the limit.
> 
> o	For each of RCU-sched and RCU-bh, note a quiescent state
> 	and force the grace-period machinery, noting in each case
> 	whether or not there are callbacks left to invoke.
> 
> o	If there are callbacks left to invoke, raise RCU_SOFTIRQ.
> 	This softirq will process the callbacks.  (Why not just invoke
> 	the softirq function directly?	Because lockdep yells at you
> 	and I do not believe that this is a false positive.)
> 
> o	If there are callbacks left to invoke, tell the caller that
> 	this CPU cannot yet enter dyntick-idle state.
> 
> But if we told the caller that this CPU cannot yet enter dyntick-idle
> state, then we also raised RCU_SOFTIRQ.  Once the softirq returns, we
> should once again try to enter dyntick-idle state.
> 
> So a significant fraction of calls to rcu_needs_cpu() saying "no" does
> not necessarily mean that we are taking significant time to get the
> grace periods and callbacks out of the way.  The funny loop involving
> softirq is required due to locking-design issues.
> 
> Or are you seeing significant delays between successive calls to
> rcu_needs_cpu() on your setup?

Will check this, but all the data I'm seeing points to rcu_needs_cpu() not
leading to additional wakeups. It might just be wrong reports by powertop,
after all, for the UP case. Quoting my original mail:

> 5) powertop and hrtimer_start_range_ns (tick_sched_timer) on a SMP kernel
> booted with "nosmp":
> 
> Wakeups-from-idle per second :  9.9     interval: 15.0s
> ...
>   48.5% (  9.4)     <kernel core> : hrtimer_start (tick_sched_timer) 
>   26.1% (  5.1)     <kernel core> : cursor_timer_handler
>   (cursor_timer_handle
>   20.6% (  4.0)     <kernel core> : usb_hcd_poll_rh_status (rh_timer_func) 
>    1.0% (  0.2)     <kernel core> : arm_supers_timer
>   (sync_supers_timer_fn) 
>    0.7% (  0.1)       <interrupt> : ata_piix 
>    ...
> 
> Accoding to http://www.linuxpowertop.org , the count in the brackets is
> how
> many wakeups per seconds were caused by one source. Adding all _except_
>   48.5% (  9.4)     <kernel core> : hrtimer_start (tick_sched_timer)
> up leads to the 9.9.

Back to your mail:

> > tick_nohz_stop_sched_tick() doesn't fail in this case because of
> > rcu_needs_cpu(). However, the improvements are hardly recognizable:
> > 
> > TINY_RCU: Wakeups-from-idle: 33.9		(hrtimer_sched_timer: 53 %)
> 
> TINY_RCU is set up to automatically do CONFIG_RCU_FAST_NO_HZ, and do
> the same softirq dance, or that is the theory, anyway.  Again, are you
> seeing significant delays between successive calls to rcu_needs_cpu()?

Actually, rcu_needs_cpu() is statically defined to return 0 on TINY_RCU in
include/linux/rcutiny.h .

Best,
	Dominik
