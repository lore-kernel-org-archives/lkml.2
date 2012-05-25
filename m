Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab2EYOWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:22:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:38844 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab2EYOWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:22:40 -0400
Date: Fri, 25 May 2012 16:22:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Sverdlin <asv@sysgo.com>
cc: David Daney <ddaney@caviumnetworks.com>,
        Venkat Subbiah <venkat.subbiah@cavium.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Possible race in request_irq() (__setup_irq())
In-Reply-To: <4FBF90B9.7010902@sysgo.com>
Message-ID: <alpine.LFD.2.02.1205251611090.3231@ionos>
References: <4FB39EDA.3030807@sysgo.com> <alpine.LFD.2.02.1205161512270.3231@ionos> <4FBF90B9.7010902@sysgo.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Alexander Sverdlin wrote:
> Hello Thomas, David, Venkat,
> 
> On 05/16/2012 03:44 PM, Thomas Gleixner wrote:
> > Your irq is using handle_percpu_irq() as the flow handler.
> > 
> > handle_percpu_irq() is a special flow handler which does not take the
> > irq descriptor lock for performance reasons. It's a single interrupt
> > number which has a percpu dev_id and can be handled on all cores in
> > parallel.
> > 
> > The interrupts need to be marked as such and requested with
> > request_percpu_irq(). Those interrupts are either marked as
> > NOAUTOENABLE or set up by the low level setup code, which runs on the
> > boot cpu with interrupt enabled.
> > 
> > Those interrupts are marked as percpu and can only be requested with
> > request_percpu_irq().
> > 
> 
> Could someone comment please, why exactly this happens in current linux-next for Octeon:
> 
> In arch/mips/cavium-octeon/octeon-irq.c MBOX IRQs are set up to be handled by handle_percpu_irq():
> 
> static void __init octeon_irq_init_ciu(void)
> {
> ...
> 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX0, 0, 32, chip_mbox, handle_percpu_irq);
> 	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX1, 0, 33, chip_mbox, handle_percpu_irq);
> 
> But in arch/mips/cavium-octeon/smp.c it's requested as normal IRQ:
> 
> void octeon_prepare_cpus(unsigned int max_cpus)
> {
> ...
> 	if (request_irq(OCTEON_IRQ_MBOX0, mailbox_interrupt,
> 			IRQF_PERCPU | IRQF_NO_THREAD, "SMP-IPI",
> 			mailbox_interrupt)) {
> 		panic("Cannot request_irq(OCTEON_IRQ_MBOX0)");
> 	}
> 
> Is it a bug, or some kind of special case?

I forgot the other case where a simple dev_id is used. That one is a
simple per cpu interrupt, which has a regular dev_id. Note the flag:
IRQF_PERCPU. So yes we have two variants, but both are dealing with
per cpu interrupts. The subtle difference is how the dev_id is handled
and how the enable/disable mechanism works.

What are you trying to do/solve ?

Thanks,

	tglx
