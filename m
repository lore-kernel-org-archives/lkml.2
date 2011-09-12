Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab1ILO1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:27:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146Ab1ILO1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:27:12 -0400
Subject: Re: [PATCH 11/24] C6X: interrupt handling
From: Mark Salter <msalter@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Date: Mon, 12 Sep 2011 10:27:02 -0400
In-Reply-To: <alpine.LFD.2.02.1109091619350.2723@ionos>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <1314826019-22330-12-git-send-email-msalter@redhat.com>
	 <alpine.LFD.2.02.1109091619350.2723@ionos>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1315837623.11280.14.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 16:33 +0200, Thomas Gleixner wrote:
> On Wed, 31 Aug 2011, Mark Salter wrote:
> 
> > + *
> > + *  Large parts taken directly from powerpc.
> 
> Is it really necessary to copy that stuff instead of generalizing it ?
> I guess that's mostly about the reverse map & Co.

I have a patch that takes the code out of powerpc and puts in kernel/irq
where both powerpc and c6x can use it. That leaves us with two files in
kernel/irq trying to manage hw <--> virt mappings. So, some merging of
irqdomain.c and the former powerpc code is needed. I'm not sure how that
should go. At the moment, irqdomain doesn't support dynamic allocation
of irq_descs, so its not currently suitable for powerpc or c6x.


> > +/*
> > + * IRQ controller and virtual interrupts
> > + */
> 
> How different is this from PPC ? Looks fairly familiar to me :)

I had changed it in a few minor ways, but looking again, I probably
didn't need to change it at all. In the patch to generalize it, I
simply did s/NUM_ISA_INTERRUPTS/NR_IRQS_LEGACY/.

> > +static void megamod_irq_cascade(unsigned int irq, struct irq_desc *desc)
> > +{
> > +	struct irq_chip *chip = irq_desc_get_chip(desc);
> > +	struct irq_data *idata = irq_desc_get_irq_data(desc);
> > +	struct megamod_cascade_data *cascade;
> > +	struct megamod_pic *pic;
> > +	u32 events;
> > +	int n, idx;
> > +
> > +	cascade = irq_desc_get_handler_data(desc);
> > +
> > +	pic = cascade->pic;
> > +
> > +	raw_spin_lock(&desc->lock);
> > +
> > +	chip->irq_mask(idata);
> 
> This runs with interrupts disabled, so why the lock, mask and the
> inprogress fiddling? That interrupt cannot be reentered and it is not
> controlled by disable_irq/enable_irq and better not subject to
> free_irq, so why do you need this?

It was leftover cruft from a previous incarnation. Not needed, so
I took it out.

--Mark


