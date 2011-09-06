Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab1IFQfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:35:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33836 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab1IFQfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:35:41 -0400
Date: Tue, 6 Sep 2011 18:35:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/32] nohz: Move ts->idle_calls into strict idle logic
Message-ID: <20110906163527.GE28205@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-10-git-send-email-fweisbec@gmail.com>
 <1314629267.2816.82.camel@twins>
 <20110829173426.GE9748@somewhere.redhat.com>
 <1314640789.2816.122.camel@twins>
 <20110829182354.GH9748@somewhere.redhat.com>
 <1314642803.2816.138.camel@twins>
 <20110830144500.GR9748@somewhere.redhat.com>
 <1314718422.5812.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314718422.5812.18.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 05:33:42PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 16:45 +0200, Frederic Weisbecker wrote:
> > On Mon, Aug 29, 2011 at 08:33:23PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2011-08-29 at 20:23 +0200, Frederic Weisbecker wrote:
> > > 
> > > > > Well, no, on interrupt return you shouldn't do anything. If you've
> > > > > stopped the tick it stays stopped until you do something that needs it,
> > > > > then that action will re-enable it.
> > > > 
> > > > Sure, when something needs the tick in this mode, we usually
> > > > receive an IPI and restart the tick from there but then
> > > > tick_nohz_stop_sched_tick() handles the cases with *needs_cpu()
> > > > very well on interrupt return (our IPI return) by doing a kind
> > > > of "light" HZ mode by logically switching to nohz mode but
> > > > with the next timer happening in HZ, assuming it's a matter
> > > > of one tick and we will switch to a real nohz behaviour soon.
> > > > 
> > > > I don't see a good reason to duplicate that logic with a pure
> > > > restart from the IPI.
> > > 
> > > That sounds like an optimization, and should thus be done later.
> > 
> > The optimization is already there upstream. I can split the logic for
> > non-idle case but I'm not sure about the point of that.
> 
> care to point me to the relevant code, because I can't remember a
> half-assed nohz state.. then again, maybe I didn't look hard enough.

It's in tick_nohz_stop_sched_tick():

	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
	    arch_needs_cpu(cpu)) {
		next_jiffies = last_jiffies + 1;
		delta_jiffies = 1;
	} else {
		/* Get the next timer wheel timer */
		next_jiffies = get_next_timer_interrupt(last_jiffies);
		delta_jiffies = next_jiffies - last_jiffies;
	}

There are two cases:

- tick_nohz_stop_sched_tick() is called from idle. If one of the *_needs_cpu()
is true, then the tick is not stopped. It doesn't even enter the nohz logic.

- tick_nohz_stop_sched_tick() is called from an interrupt exit while we are
idle. If one of the *_needs_cpu() is true, then if the tick was previously
stopped, we program the next timer to be in 1 jiffy but without exiting
nohz mode. Otherwise if the tick was disabled, then we don't stop the tick.

In fact those *_needs_cpu() are treated like timer list timer or hrtimers
that happen in one jiffy from now.

When we are in such a scheme:

	tick_nohz_stop_sched_tick();
	while (!need_resched())
		hlt();
	tick_nohz_restart_sched_tick();

It avoids to go back and forth between hz/nohz logic from inside
the loop.
		
 
> > > > > > That said I wonder if some of the above conditions should restore a periodic
> > > > > > behaviour on interrupt return...
> > > > > 
> > > > > I would expect the tick not to be stopped when tick_nohz_can_stop_tick()
> > > > > returns false. If it returns true, then I expect anything that needs it
> > > > > to re-enable it.
> > > > > 
> > > > 
> > > > Yeah. In the case of need_resched() in idle I believe the CPU doesn't
> > > > really go to sleep later so it should be fine. But for the case of
> > > > softirq pending or nohz_mode, I'm not sure...
> > > 
> > > softirqs shouldn't be pending when you go into nohz mode..
> > 
> > You mean it can't happen or we don't want that to happen?
> 
> We don't want that.. going into nohz with pending softirqs means the
> softirqs will be delayed for an unknown amount of time, this should not
> occur.
> 
> tick_nohz_stop_sched_tick() has:
> 
>         if (unlikely(local_softirq_pending() && cpu_online(cpu))) {                          
>                 static int ratelimit;                                                        
>                                                                                              
>                 if (ratelimit < 10) {                                                        
>                         printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",                
>                                (unsigned int) local_softirq_pending());                      
>                         ratelimit++;                                                         
>                 }                                                                            
>                 goto end;                                                                    
>         }
> 
> which should warn us if this ever was to occur.

Yeah. Moreover that check is weird because if softirqs are pending
at that time, then the softirqd thread should be woken up. Because
either we come from idle and we are not in an interrupt (softirq
raised would use softirqd in not interrupt exit) or we come from
an interrupt and the softirqs have been executed. If there were
too much of them, softirqd would have been woken up as well.

Thus the need_resched() condition that comes before should have exited the
function already.

> > > 
> > > That is, I'm really not seeing what's wrong with the very simple:
> > > 
> > > 
> > >   if (tick_nohz_can_stop_tick())
> > > 	tick_nohz_stop_tick();
> > > 
> > > 
> > > and relying on everybody who invalidates tick_nohz_can_stop_tick(), to
> > > do:
> > > 
> > >   tick_nohz_start_tick();
> > 
> > May be for the non-idle case. But for the idle case I need to ensure
> > this is necessary somewhere.
> 
> How exactly do idle and non-idle differ? Its about stopping the tick,
> regardless of if we're idle or not if someone needs the thing we need to
> start it again.

It may differ because of the way the idle loop is made, considering some
things as 1 jiffy timer to avoid a hard whole tick restart.
