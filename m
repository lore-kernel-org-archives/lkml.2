Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1GSAjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 20:39:35 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49734 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GSAjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 20:39:33 -0400
Date: Mon, 18 Jul 2011 17:39:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: current_thread_info() vs task_thread_info(current)
Message-ID: <20110719003930.GF2312@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310988183.13765.56.camel@twins>
 <1310990097.25044.307.camel@pasglop>
 <20110718143731.GA2312@linux.vnet.ibm.com>
 <1311024983.25044.325.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311024983.25044.325.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 07:36:23AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2011-07-18 at 07:37 -0700, Paul E. McKenney wrote:
> > On Mon, Jul 18, 2011 at 09:54:57PM +1000, Benjamin Herrenschmidt wrote:
> > > On Mon, 2011-07-18 at 13:23 +0200, Peter Zijlstra wrote:
> > > 
> > > > So how are we going to solve this? Naively I'd think that
> > > > current_thread_info() is short for task_thread_info(current), and thus
> > > > the platforms for where this isn't true are broken.
> > > > 
> > > > I mean, what use is the thread_info not of a thread?
> > > > 
> > > > Comments?
> > > 
> > > Thomas just hit a bug in the platform code of said platform (powerpc
> > > heh ?) :-)
> > > 
> > > We do it right for hard IRQs and for some reason never did it right for
> > > softirqs.
> > > 
> > > The code is like this for the former:
> > > 
> > > static inline void handle_one_irq(unsigned int irq)
> > > {
> > > 
> > >         .../...
> > > 
> > > 	call_handle_irq(irq, desc, irqtp, desc->handle_irq);
> > > 	current->thread.ksp_limit = saved_sp_limit;
> > > 	irqtp->task = NULL;
> > > 
> > > 	/* Set any flag that may have been set on the
> > > 	 * alternate stack
> > > 	 */
> > > 	if (irqtp->flags)
> > > 		set_bits(irqtp->flags, &curtp->flags);
> > > }
> > > 
> > > So what we need, I suppose is to add those two last line to
> > > do_softirq_onstack() as well.
> > 
> > Hmmm...  Would this explain preempt_count() inexplicably increasing by
> > three across a spin_unlock_irqrestore()?  I ran into this situation when
> > testing on Power over the weekend.
> 
> Hrm, no I don't see that happening no. The preempt count when exiting an
> irq or softirq stack should be the exact same as when entering it, which
> is why we don't bother copying it over. Do you see any case where that
> wouldn't hold ?

Nope, other than seeing preempt_count() transition from zero to three
across a spin_unlock_irqrestore() for no good reason that I could see.

							Thanx, Paul
