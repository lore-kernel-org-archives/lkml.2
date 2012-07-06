Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab2GFMxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:53:32 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37402 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab2GFMxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:53:30 -0400
Date: Fri, 6 Jul 2012 05:52:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu] Make RCU_FAST_NO_HZ respect nohz= boot
 parameter
Message-ID: <20120706125206.GQ2522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120705223731.GA27608@linux.vnet.ibm.com>
 <20120705230208.GB26150@leaf>
 <20120706002944.GL2522@linux.vnet.ibm.com>
 <20120706034648.GA27047@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706034648.GA27047@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070612-5518-0000-0000-000005D03AD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 08:46:48PM -0700, Josh Triplett wrote:
> On Thu, Jul 05, 2012 at 05:29:44PM -0700, Paul E. McKenney wrote:
> > On Thu, Jul 05, 2012 at 04:02:08PM -0700, Josh Triplett wrote:
> > > On Thu, Jul 05, 2012 at 03:37:31PM -0700, Paul E. McKenney wrote:
> > > > If the nohz= boot parameter disables nohz, then RCU_FAST_NO_HZ needs to
> > > > also disable itself.  This commit therefore checks for tick_nohz_enabled
> > > > being zero, disabling rcu_prepare_for_idle() if so.  This patch assumes
> > > > that tick_nohz_enabled can change at runtime: If this is not the case,
> > > > then a simpler approach suffices.
> > > 
> > > Allowing nohz to change at runtime seems like an entirely unnecessary
> > > bit of added complexity.  (So does having a boot parameter for it, but
> > > that one at least seems easier to handle.)
> > 
> > I will let representatives from the various distros expound to you on
> > their one-binary-only strategy for kernel builds.  ;-)
> 
> I'm aware.  However, the subset of people wanting to turn off nohz seems
> sufficiently small at this point that I'd *hope* distro kernels could
> just always have it turned on. :)

The people who want it turned on are of course those who care deeply
about latency from idle, which appears to be a not-unimportant group.
My best guess is that a strong desire to switch this at runtime will
come from cloud-computing people who need to support those who care
deeply about latency from idle, but who want to conserve energy when
running other workloads.

> In any case, as I said, the ability to change it at runtime seems like
> the primary bit of complexity; the ability to change it at boot time
> seems straightforward to handle.

I would need to at least have a warning, which ends up retaining most
of the code.  Otherwise, my first notification of the change is "Hey,
we have this weird and difficult-to-reproduce slowdown (or even hang)."
Of course, this will be at a time when this section of code is the
absolute last thing on my mind...

> > > What would the patch look like if you can assume nohz will never change
> > > at runtime?  And does anyone have a use case for changing nohz at
> > > runtime, rather than at boot time?
> > 
> > It would be a little bit simpler, but would break in very odd and
> > difficult-to-debug ways if anyone ever did allow it to change at runtime,
> > for example, to accommodate systems subject to varying workloads.
> 
> Granted, but it doesn't seem worth preemtively making RCU more
> complicated to accomodate a use case that nobody has said they have yet.
> :)

Speaking as the guy who repeatedly put off reducing RCU grace-period
initialization latency until someone actually complained about it,
despite my being quite certain from the get-go that someone was bound
to complain sooner or later, I can certainly appreciate and identify
with that sentiment.

But in the grace-period initialization latency case, the complexity
of the fix was large, and the problem-isolation procedure extremely
straightforward, courtesy of things like the latency tracer.
In constrast, in then case at hand, the incremental complexity is quite
small and the difficulty spotting the problem is likely to be quite large.

Hence my taking a different approach to these two situations.

							Thanx, Paul

