Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2DJNUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:20:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33500 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2DJNU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:20:28 -0400
Date: Tue, 10 Apr 2012 14:23:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] gpio: add MSIC gpio driver
Message-ID: <20120410142304.70091f9a@pyramind.ukuu.org.uk>
In-Reply-To: <20120410131056.GA31551@sirena.org.uk>
References: <20120410131734.28046.25265.stgit@bob.linux.org.uk>
	<20120410131056.GA31551@sirena.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 14:10:56 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Tue, Apr 10, 2012 at 02:18:04PM +0100, Alan Cox wrote:
> 
> > +	if (mg->trig_change_mask) {
> > +		offset = __ffs(mg->trig_change_mask);
> > +
> > +		reg = msic_gpio_to_ireg(offset);
> > +		if (reg < 0)
> > +			goto out;
> > +
> > +		if (mg->trig_type & IRQ_TYPE_EDGE_RISING)
> > +			trig |= MSIC_GPIO_TRIG_RISE;
> > +		if (mg->trig_type & IRQ_TYPE_EDGE_FALLING)
> > +			trig |= MSIC_GPIO_TRIG_FALL;
> > +
> > +		intel_msic_reg_update(reg, trig, MSIC_GPIO_INTCNT_MASK);
> > +		mg->trig_change_mask = 0;
> > +	}
> 
> What happens if we manage to get more than one change flagged while the
> lock is held?

It breaks. 8-). I will take a look at that.

> > +/* Firmware does all the masking and unmasking for us, no masking here. */
> > +static void msic_irq_unmask(struct irq_data *data) { }
> 
> > +static void msic_irq_mask(struct irq_data *data) { }
> 
> Shouldn't these just be omitted if they don't do anything (or
> alternatively, how does the firmware figure out that it needs to do the
> masking and unmasking)?

The IRQ layer requires they are present and calls them without NULL
checks on many paths. I imagine it's better for the normal cases to avoid
the conditional checks on those fast paths.

The gpio code is talking to the firmware controller (via
intel_msic_reg_*) and effectively its poking GPIOs on a separate device
via a messaging interface.

I'll go fix the type change to just keep a per gpio type.


> > +	mg = kzalloc(sizeof(*mg), GFP_KERNEL);
> > +	if (!mg)
> > +		return -ENOMEM;
> 
> devm_kzalloc()

No point - the driver isn't unloadable. Nor does it make sense to make it
so.

Alan
