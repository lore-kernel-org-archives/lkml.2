Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0DPWGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 18:06:44 -0400
Received: from www.tglx.de ([62.245.132.106]:53938 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab0DPWGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 18:06:42 -0400
Date: Sat, 17 Apr 2010 00:06:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: christian pellegrin <chripell@fsfe.org>
cc: feng.tang@intel.com, akpm@linux-foundation.org, greg@kroah.com,
       david-b@pacbell.net, grant.likely@secretlab.ca,
       alan@lxorguk.ukuu.org.uk, spi-devel-general@lists.sourceforge.net,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/4] max3100: added raise_threaded_irq
In-Reply-To: <w2gcabda6421004160918vc5dc5ee2y14a5814b4e8573b3@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1004162143300.3625@localhost.localdomain>
References: <cabda6421003230329w3fe596dbn8e4b37cc36118f9f@mail.gmail.com>  <1269340105-6503-1-git-send-email-chripell@fsfe.org>  <alpine.LFD.2.00.1004160110360.3625@localhost.localdomain> <w2gcabda6421004160918vc5dc5ee2y14a5814b4e8573b3@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian,

On Fri, 16 Apr 2010, christian pellegrin wrote:

> Hi,
> 
> On Fri, Apr 16, 2010 at 1:22 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> >> raise_threaded_irq schedules the execution of an interrupt thread
> >
> > I really have a hard time to understand _WHY_ we want to have that
> > function.
> >
> .....
> >
> > Can you please explain, what you are trying to achieve and why it
> > can't be done with the existing interfaces ?
> >
> 
> The idea was that by using this function we just need one kind of
> deferred work (interrupt threads) instead of two (for example
> interrupt threads and workqueues) in some situations. This is very
> handy with devices that do transmission and reception at the same
> time, for example many SPI devices. The user case is the max3100 UART
> on SPI driver. The same SPI instruction both receives and sends chars.
> So when we need to send a char we just start the interrupt thread
> instead of having another kind of deferred work doing the job. This
> greatly simplifies locking and avoids duplication of functionality
> (otherwise we must have an interrupt thread that does reception and a
> workqueue that does sending and receiving for example) because
> everything is done in just one point. The move from worqueues to
> interrupt threads was motivated by the much smaller latency under load
> of the latter because they are scheduled as RT processes. I hope this
> doesn't sound like a terrible abuse of threaded interrupts. Let me
> know before I try to fix other problems you mentioned.

Thanks for the explanation. Now, that makes a lot of sense and I can
see that it removes a lot of serialization issues and duplicated code
pathes.

So what you want is a mechanism to "inject" interrupts by
software. 

I wonder whether we should restrict this mechanism to threaded
handlers or just implement it in the following way:

int irq_inject(unsigned int irq)
{
        struct irq_desc *desc = irq_to_desc(irq);

	if (!desc)
		return -EINVAL;
	
	local_irq_disable();
        desc->handle_irq(irq, desc);
        local_irq_enable();
	return 0;
}

That would call the real interupt code path as it is called from the
arch/*/kernel/irq.c:entry code and take care of all serialization
issues.

The drawback is that it will increase the irq statistics, but I think
that's really a pure cosmetic problem.

That requires that the primary interrupt handler code knows about the
software "interrupt" event, but that's easy to solve. So the primary
handler would just return IRQ_WAKE_THREAD as it would do for a real
hardware triggered interrupt. But as a goodie that would work for non
threaded interrupts as well.

There is another thing which needs some care: 

This will not work out of the box when the irq is nested into some
demultiplexing thread handler (IRQF_NESTED_THREAD).

I'm too tried to look at this now, but I don't see a real showstopper
there.

Thanks,

	tglx
