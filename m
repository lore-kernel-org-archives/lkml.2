Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2FJU3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 16:29:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65515 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2FJU3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 16:29:22 -0400
Date: Sun, 10 Jun 2012 22:29:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rcu: Allow calls to rcu_exit_user_irq from nesting irqs
Message-ID: <20120610202912.GD31957@somewhere.redhat.com>
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
 <20120604181313.GL2490@linux.vnet.ibm.com>
 <CAFTL4hzqa1z4icSBwEqZXLjCrVsG+axm2TaGSaaMXkjazT0Qfw@mail.gmail.com>
 <20120604210709.GO2490@linux.vnet.ibm.com>
 <20120605103055.GA4553@somewhere.redhat.com>
 <20120605234640.GY2388@linux.vnet.ibm.com>
 <20120609225550.GB31957@somewhere.redhat.com>
 <20120610180659.GD2425@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610180659.GD2425@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 11:06:59AM -0700, Paul E. McKenney wrote:
> On Sun, Jun 10, 2012 at 12:55:54AM +0200, Frederic Weisbecker wrote:
> >  void rcu_user_enter_irq(void)
> >  {
> > @@ -478,12 +478,9 @@ void rcu_user_enter_irq(void)
> > 
> >  	local_irq_save(flags);
> >  	rdtp = &__get_cpu_var(rcu_dynticks);
> > -	/*
> > -	 * Ensure this irq is a non nesting one interrupting
> > -	 * a non-idle RCU state.
> > -	 */
> > -	WARN_ON_ONCE(rdtp->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE + 1);
> > -	rdtp->dynticks_nesting = 1;
> > +	/* Ensure we are interrupting a non-idle RCU state */
> > +	WARN_ON_ONCE(!(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK));
> > +	rdtp->dynticks_nesting -= DYNTICK_TASK_EXIT_IDLE;
> 
> This will be broken on architectures that can fail to return from interrupts
> and exceptions and vice versa.  The resulting value of rdtp->dynticks_nesting
> might well go negative, or might fail to reach zero when the outermost
> interrupt returns.
> 
> One workaround would be to add up the relevant fields of preempt_count()
> and assign the result to rdtp->dynticks_nesting.

That's ok. I made rcu_user_enter_irq() to support nesting irqs in order to stay
consistant with the same change in rcu_user_exit_irq(). But this is not necessary.
rcu_user_enter_irq() itself is only called from the outermost irq.

Also there is a sanity check that ensures that in the current code in rcu/idle tree
so rcu_user_enter_irq() can stay as is there.

I'll resend the patch with only the change in rcu_user_exit_irq().

Thanks.
