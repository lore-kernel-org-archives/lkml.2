Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab0DDXhN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 19:37:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42291 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab0DDXhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 19:37:06 -0400
Date: Sun, 4 Apr 2010 16:37:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
Message-ID: <20100404233702.GA24102@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100403223328.GA4507@comet.dominikbrodowski.net>
 <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org>
 <20100404163924.GA18428@comet.dominikbrodowski.net>
 <20100404204725.GC2644@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100404204725.GC2644@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 
> Might this be what is happening to you?
> 
> If so, would you be willing to patch your kernel?  RCU_NEEDS_CPU_FLUSHES
> is currently set to 5, and might be set to (say) 8.  This is defined
> in kernel/rcutree_plugin.h, near line 990.
> 
> Another thing to try would be running with TINY_RCU, at least if it is
> OK that RCU be non-preemptible.

And you did mention offlining some CPUs above.  The folloiwng patch
(from Lai Jiangshan) is needed to handle this case.

							Thanx, Paul

------------------------------------------------------------------------

commit 6a2ae79877827355b747c0b91133a963b74ed396
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Tue Mar 30 18:40:36 2010 +0800

    rcu: ignore offline CPUs in last non-dyntick-idle CPU check
    
    Offline CPUs are not in nohz_cpu_mask, but can be ignored when checking
    for the last non-dyntick-idle CPU.  This patch therefore only checks
    online CPUs for not being dyntick idle, allowing fast entry into
    full-system dyntick-idle state even when there are some offline CPUs.
    
    Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 79b53bd..687c4e9 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1016,7 +1016,7 @@ int rcu_needs_cpu(int cpu)
 
 	/* Don't bother unless we are the last non-dyntick-idle CPU. */
 	for_each_cpu_not(thatcpu, nohz_cpu_mask)
-		if (thatcpu != cpu) {
+		if (cpu_online(thatcpu) && thatcpu != cpu) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);
