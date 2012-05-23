Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501Ab2EWQGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:06:46 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57687 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab2EWQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:06:44 -0400
Date: Wed, 23 May 2012 18:06:33 +0200
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
Message-ID: <20120523160629.GJ1663@somewhere>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-12-git-send-email-fweisbec@gmail.com>
 <20120522171658.GA8087@linux.vnet.ibm.com>
 <20120523135205.GB1663@somewhere>
 <20120523151537.GA2402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523151537.GA2402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 08:15:42AM -0700, Paul E. McKenney wrote:
> On Wed, May 23, 2012 at 03:52:09PM +0200, Frederic Weisbecker wrote:
> > > > +#ifdef CONFIG_CPUSETS_NO_HZ
> > > > +static bool can_stop_adaptive_tick(void)
> > > > +{
> > > > +	if (!sched_can_stop_tick())
> > > > +		return false;
> > > > +
> > > > +	/* Is there a grace period to complete ? */
> > > > +	if (rcu_pending(smp_processor_id()))
> > > 
> > > You lost me on this one.  Why can't this be rcu_needs_cpu()?
> > 
> > We already have an rcu_needs_cpu() check in tick_nohz_stop_sched_tick()
> > that prevents the tick to shut down if the CPU has local callbacks to handle.
> > 
> > The rcu_pending() check is there in case some other CPU is waiting for the
> > current one to help completing a grace period, by reporting a quiescent state
> > for example. This happens because we may stop the tick in the kernel, not only
> > userspace. And if we are in the kernel, we still need to be part of the global
> > state machine.
> 
> Ah!  But RCU will notice that the CPU is in dyntick-idle mode, and will
> therefore take any needed quiescent-state action on that CPU's behalf.
> So there should be no need to call rcu_pending() anywhere outside of the
> RCU core code.


No. If the tick is stopped and we are in the kernel, we may be using RCU
anytime, so we need to be part of the RCU core.
