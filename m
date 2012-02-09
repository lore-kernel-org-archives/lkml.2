Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab2BIPd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:33:57 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61972 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab2BIPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:33:55 -0500
Date: Thu, 9 Feb 2012 16:33:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 45/47] rcu: Allow nesting of
 rcu_idle_enter() and rcu_idle_exit()
Message-ID: <20120209153343.GB22552@somewhere.redhat.com>
References: <20120204014452.GA29811@linux.vnet.ibm.com>
 <1328319922-30828-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328319922-30828-45-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120209040701.GF25473@somewhere.redhat.com>
 <20120209152620.GI32560@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209152620.GI32560@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 07:26:20AM -0800, Paul E. McKenney wrote:
> On Thu, Feb 09, 2012 at 05:07:04AM +0100, Frederic Weisbecker wrote:
> > On Fri, Feb 03, 2012 at 05:45:20PM -0800, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Use of RCU in the idle loop is incorrect, quite a few instances of
> > > just that have made their way into mainline, primarily event tracing.
> > > The problem with RCU read-side critical sections on CPUs that RCU believes
> > > to be idle is that RCU is completely ignoring the CPU, along with any
> > > attempts and RCU read-side critical sections.
> > > 
> > > The approaches of eliminating the offending uses and of pushing the
> > > definition of idle down beyond the offending uses have both proved
> > > impractical.  The new approach is to encapsulate offending uses of RCU
> > > with rcu_idle_exit() and rcu_idle_enter(), but this requires nesting
> > > for code that is invoked both during idle and and during normal execution.
> > > Therefore, this commit modifies rcu_idle_enter() and rcu_idle_exit() to
> > > permit nesting.
> > > 
> > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> > > ---
> > >  kernel/rcu.h     |   21 ++++++++++++++++++++-
> > >  kernel/rcutiny.c |   16 ++++++++++++----
> > >  kernel/rcutree.c |   21 ++++++++++++++-------
> > >  3 files changed, 46 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/kernel/rcu.h b/kernel/rcu.h
> > > index 30876f4..8ba99cd 100644
> > > --- a/kernel/rcu.h
> > > +++ b/kernel/rcu.h
> > > @@ -33,8 +33,27 @@
> > >   * Process-level increment to ->dynticks_nesting field.  This allows for
> > >   * architectures that use half-interrupts and half-exceptions from
> > >   * process context.
> > > + *
> > > + * DYNTICK_TASK_NEST_MASK defines a field of width DYNTICK_TASK_NEST_WIDTH
> > > + * that counts the number of process-based reasons why RCU cannot
> > > + * consider the corresponding CPU to be idle, and DYNTICK_TASK_NEST_VALUE
> > > + * is the value used to increment or decrement this field.
> > > + *
> > > + * The rest of the bits could in principle be used to count interrupts,
> > > + * but this would mean that a negative-one value in the interrupt
> > > + * field could incorrectly zero out the DYNTICK_TASK_NEST_MASK field.
> > > + * We therefore provide a two-bit guard field defined by DYNTICK_TASK_MASK
> > > + * that is set to DYNTICK_TASK_FLAG upon initial exit from idle.
> > > + * The DYNTICK_TASK_EXIT_IDLE value is thus the combined value used upon
> > > + * initial exit from idle.
> > >   */
> > > -#define DYNTICK_TASK_NESTING (LLONG_MAX / 2 - 1)
> > > +#define DYNTICK_TASK_NEST_WIDTH 7
> > > +#define DYNTICK_TASK_NEST_VALUE ((LLONG_MAX >> DYNTICK_TASK_NEST_WIDTH) + 1)
> > > +#define DYNTICK_TASK_NEST_MASK  (LLONG_MAX - DYNTICK_TASK_NEST_VALUE + 1)
> > > +#define DYNTICK_TASK_FLAG	   ((DYNTICK_TASK_NEST_VALUE / 8) * 2)
> > > +#define DYNTICK_TASK_MASK	   ((DYNTICK_TASK_NEST_VALUE / 8) * 3)
> > 
> > There is one unused bit between DYNTICK_TASK_NEST_MASK and DYNTICK_TASK_MASK, is
> > that intentional?
> 
> Yep, it makes it easier for me to read hex dumps of the variables.

I see.
 
> > Also do you want to allow nesting of that kind?
> > 
> > 	rcu_idle_enter();
> > 		rcu_idle_enter();
> > 		rcu_idle_exit();
> > 	rcu_idle_exit()
> 
> No -- only the inverse where you exit idle multiple times.
> 
> > in which case I guess that rcu_irq_enter()/rcu_irq_exit() also need to
> > be updated.
> > 
> > If we have this:
> > 
> > 	rcu_idle_enter()
> > 	rcu_idle_enter()
> > 
> > 	rcu_irq_enter()
> > 	rcu_irq_exit()
> > 
> > 	rcu_idle_exit()
> > 	rcu_idle_exit()
> > 
> > On rcu_irq_enter(), oldval will never be 0 and we'll miss rcu_idle_exit_common().
> > rcu_irq_exit() has a similar problem as it won't enter rcu_idle_enter_common().
> > 
> > Its check on WARN_ON_ONCE(rdtp->dynticks_nesting < 0) is also wrong because after
> > two calls of rcu_idle_enter(), the value of dynticks_nesting is negative : it's
> > -DYNTICK_TASK_NEST_VALUE.
> > 
> > Perhaps this change would allow that. But again that's just in case you need to
> > support that kind of nesting.
> 
> Interesting.  I don't know of a use case for this -- do you have any?
> 
> 							Thanx, Paul

Not really. I was just not sure what you were targeting exactly :)
