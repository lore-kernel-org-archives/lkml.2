Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0KXWnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:43:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59556 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0KXWnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=HOqxgdZUK5sJE0KM61APqhxV+LnHEiQHp0lvUlhWP7j33p33hjYjzvuExKG9UzOcXo
         daUEjUpstAGuhB+Zas6BSmeZH0jUfyncWtHQC5DG0NCv54aT28IAQKBwRvPpkuJZf+Z4
         jlni2CVEP507IRDXmeza8TxDUU7d/pcjGA1JU=
Date: Wed, 24 Nov 2010 23:42:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states after
 extended grace periods
Message-ID: <20101124234257.36870244@nowhere>
In-Reply-To: <20101124182051.GF2207@linux.vnet.ibm.com>
References: <1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
	<20101124005820.GH8056@linux.vnet.ibm.com>
	<AANLkTikhGErGQrFB-QNiYjWt2PqRGdF+m3kOkt2tmnER@mail.gmail.com>
	<AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
	<20101124062212.GA2165@linux.vnet.ibm.com>
	<AANLkTimjZnAfeuAXU7oXPRG5=qJ2d7aZVoozSm88kXMT@mail.gmail.com>
	<20101124144240.GC2165@linux.vnet.ibm.com>
	<AANLkTi=EA09DACMNLUpTU8qH5wFPdXvOMQzJeejXX170@mail.gmail.com>
	<20101124161513.GA2207@linux.vnet.ibm.com>
	<AANLkTikbZUO6MbSC=uWYp4JRCdHPHrr5Z2_=to1YsC1X@mail.gmail.com>
	<20101124182051.GF2207@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 24 Nov 2010 10:20:51 -0800,
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> a écrit :

> On Wed, Nov 24, 2010 at 06:38:45PM +0100, Frederic Weisbecker wrote:
> > Yeah. I mean, I need to read how the code manages the different
> > queues. But __rcu_process_gp_end() seems to sum it up quite well.
> 
> For advancing callbacks, that is the one!  For invocation of
> callbacks, see rcu_do_batch().

Ok.


> > It's more like couldn't ever stop the tick. But that doesn't
> > concern mainline. This is because I have a hook that prevents the
> > tick from beeing stopped until rcu_pending() == 0.
> 
> That would certainly change behavior!!!  Why did you need to do that?
> 
> Ah, because force_quiescent_state() has not yet been taught about
> dyntick-HPC, got it...

Oh actually I have taught it about that. For such isolated CPU that
doesn't respond, it sends a specific IPI that will restart the tick if
we are not in nohz.

The point in restarting the tick is to find some quiescent states and
also to keep the tick for a little while for potential further grace
periods to complete while we are in the kernel.

This is why I use rcu_pending() from the tick: to check if we still
need the tick for rcu.
 
> > In mainline it doesn't prevent the CPU from going nohz idle though,
> > because the softirq is armed from the tick. Once the softirq is
> > processed, the CPU can go to sleep. On the next timer tick it would
> > again raise the softirq and then could again go to sleep, etc..
> 
> You lost me on this one.  If the CPU goes to sleep (AKA enters
> dyntick-idle mode, right?), then there wouldn't be a next timer tick,
> right?

If there is a timer queued (timer_list or hrtimer), then the next timer
tick is programmed to fire for the next timer. Until then the CPU can
go to sleep and it will be woken up on that next timer interrupt.


> > I still have a trace of that, with my rcu_pending() hook, in
> > dyntick-hpc, that kept
> > returning 1 during at least 100 seconds and on each tick.
> > I did not go really further into this from my code as I immediately
> > switched to tip:master
> > to check if the problem came from my code or not.
> > And then I discovered that rcu_pending() indeed kept returning 1
> > for some while in mainline (don't remember how much could be "some
> > while" though), I saw all these
> > spurious rcu softirq at each ticks caused by rcu_pending() and for
> > random time slices:
> > probably between a wake up from idle and the next grace period, if
> > my theory is right, and I
> > think that happened likely with bh flavour probably because it's
> > subject to less grace periods.
> > 
> > And this is what the second patch fixes in mainline and that also
> > seems to fix my issue in
> > dyntick-hpc.
> > 
> > Probably it happened more easily on dynctick-hpc as I was calling
> > rcu_pending() after
> > calling rcu_enter_nohz() (some buggy part of mine).
> 
> OK, but that is why dyntick-idle is governed by rcu_needs_cpu() rather
> than rcu_pending().  But yes, need to upgrade force_quiescent_state().
> 
> One hacky way to do that would be to replace smp_send_reschedule()
> with an smp_call_function_single() that invoked something like the
> following on the target CPU:
> 
> 	static void rcu_poke_cpu(void *info)
> 	{
> 		raise_softirq(RCU_SOFTIRQ);
> 	}
> 
> So rcu_implicit_offline_qs() does something like the following in
> place of the smp_send_reschedule():
> 
> 	smp_call_function_single(rdp->cpu, rcu_poke_cpu, NULL, 0);
> 
> The call to set_need_resched() can remain as is.
> 
> Of course, a mainline version would need to be a bit more discerning,
> but this should do work just fine for your experimental use.
> 
> This should allow you to revert back to rcu_needs_cpu().
> 
> Or am I missing something here?

So, as I explained above I'm currently using such an alternate IPI. But
raising the softirq would only take care of:

* checking if there is a new grace period (rearm rdp->qs_pending and so)
* take care of callbacks

But it's not enough to track quiescent states. And we have no more timer
interrupts to track them. So we need to restart the tick at least until
we find a quiescent state for the grace period waiting for us.

But I may be missing something either :)


> > Ah, I see what you mean. So you would suggest to even ignore those
> > explicit QS report when in dynticj-hpc mode for CPUs that don't
> > have callbacks?
> > 
> > Why not keeping them?
> 
> My belief is that people needing dyntick-HPC are OK with RCU grace
> periods taking a few jiffies longer than they might otherwise.
> Besides, when you are running dyntick-HPC, you aren't context
> switching much, so keeping the tick doesn't buy you as much reduction
> in grace-period latency.

But don't we still need the tick on such cases, (if we aren't in
userspace) when a grace period starts, to note our grace periods?
The rcu IPI itself doesn't seem to be sufficient for that.

I'm not sure I undrstand what you mean.
