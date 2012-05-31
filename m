Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab2EaQBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:01:30 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61745 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab2EaQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:01:28 -0400
Date: Thu, 31 May 2012 18:01:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 11/41] nohz/cpuset: Don't turn off the tick if rcu needs
 it
Message-ID: <20120531160117.GD27841@somewhere.redhat.com>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-12-git-send-email-fweisbec@gmail.com>
 <20120522171658.GA8087@linux.vnet.ibm.com>
 <20120523135205.GB1663@somewhere>
 <20120523151537.GA2402@linux.vnet.ibm.com>
 <20120523160629.GJ1663@somewhere>
 <20120523162739.GE2402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523162739.GE2402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:27:39AM -0700, Paul E. McKenney wrote:
> On Wed, May 23, 2012 at 06:06:33PM +0200, Frederic Weisbecker wrote:
> > On Wed, May 23, 2012 at 08:15:42AM -0700, Paul E. McKenney wrote:
> > > On Wed, May 23, 2012 at 03:52:09PM +0200, Frederic Weisbecker wrote:
> > > > > > +#ifdef CONFIG_CPUSETS_NO_HZ
> > > > > > +static bool can_stop_adaptive_tick(void)
> > > > > > +{
> > > > > > +	if (!sched_can_stop_tick())
> > > > > > +		return false;
> > > > > > +
> > > > > > +	/* Is there a grace period to complete ? */
> > > > > > +	if (rcu_pending(smp_processor_id()))
> > > > > 
> > > > > You lost me on this one.  Why can't this be rcu_needs_cpu()?
> > > > 
> > > > We already have an rcu_needs_cpu() check in tick_nohz_stop_sched_tick()
> > > > that prevents the tick to shut down if the CPU has local callbacks to handle.
> > > > 
> > > > The rcu_pending() check is there in case some other CPU is waiting for the
> > > > current one to help completing a grace period, by reporting a quiescent state
> > > > for example. This happens because we may stop the tick in the kernel, not only
> > > > userspace. And if we are in the kernel, we still need to be part of the global
> > > > state machine.
> > > 
> > > Ah!  But RCU will notice that the CPU is in dyntick-idle mode, and will
> > > therefore take any needed quiescent-state action on that CPU's behalf.
> > > So there should be no need to call rcu_pending() anywhere outside of the
> > > RCU core code.
> > 
> > No. If the tick is stopped and we are in the kernel, we may be using RCU
> > anytime, so we need to be part of the RCU core.
> 
> OK, so the only problem is if we spend a long time CPU-bound in the kernel,
> where "long" is milliseconds or tens of milliseconds.  In that case, the
> RCU core will notice that the CPU has not responded but is not idle, for
> example, in rcu_implicit_dynticks_qs().  It can take action at this point
> to get the offending CPU to pay attention to RCU.
> 
> Does this make sense, or am I still missing something?

Yeah that's exactly the purpose of the rcu_pending() check before shutting down
the tick and the IPI to wake it up.
