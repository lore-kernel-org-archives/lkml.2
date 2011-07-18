Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1GRVjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:39:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:58510 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1GRVjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:39:13 -0400
Subject: Re: current_thread_info() vs task_thread_info(current)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110718143731.GA2312@linux.vnet.ibm.com>
References: <1310988183.13765.56.camel@twins>
	 <1310990097.25044.307.camel@pasglop>
	 <20110718143731.GA2312@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 07:36:23 +1000
Message-ID: <1311024983.25044.325.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 07:37 -0700, Paul E. McKenney wrote:
> On Mon, Jul 18, 2011 at 09:54:57PM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2011-07-18 at 13:23 +0200, Peter Zijlstra wrote:
> > 
> > > So how are we going to solve this? Naively I'd think that
> > > current_thread_info() is short for task_thread_info(current), and thus
> > > the platforms for where this isn't true are broken.
> > > 
> > > I mean, what use is the thread_info not of a thread?
> > > 
> > > Comments?
> > 
> > Thomas just hit a bug in the platform code of said platform (powerpc
> > heh ?) :-)
> > 
> > We do it right for hard IRQs and for some reason never did it right for
> > softirqs.
> > 
> > The code is like this for the former:
> > 
> > static inline void handle_one_irq(unsigned int irq)
> > {
> > 
> >         .../...
> > 
> > 	call_handle_irq(irq, desc, irqtp, desc->handle_irq);
> > 	current->thread.ksp_limit = saved_sp_limit;
> > 	irqtp->task = NULL;
> > 
> > 	/* Set any flag that may have been set on the
> > 	 * alternate stack
> > 	 */
> > 	if (irqtp->flags)
> > 		set_bits(irqtp->flags, &curtp->flags);
> > }
> > 
> > So what we need, I suppose is to add those two last line to
> > do_softirq_onstack() as well.
> 
> Hmmm...  Would this explain preempt_count() inexplicably increasing by
> three across a spin_unlock_irqrestore()?  I ran into this situation when
> testing on Power over the weekend.

Hrm, no I don't see that happening no. The preempt count when exiting an
irq or softirq stack should be the exact same as when entering it, which
is why we don't bother copying it over. Do you see any case where that
wouldn't hold ?

Cheers,
Ben.

> 							Thanx, Paul
> 
> > Now indeed i386 needs a similar treatment on both hard and soft
> > irqs (along with getting rid of that stupid duplication of
> > call_on_stack in there, I don't think it's worth making the code
> > horrible like that to save one clobber and PeterZ reckons we can
> > probably avoid it using always_inline anyways).
> > 
> > I'll let you guys sort i386 out tho, I'll look at fixing ppc tomorrow :-)
> > 
> > Cheers,
> > Ben.
> > 
> > 


