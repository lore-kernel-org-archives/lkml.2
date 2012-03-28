Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2C2BZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:25:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60650 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab2C2BZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:25:23 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 2/4] MIPS: Octeon: Setup irq_domains for interrupts.
To: David Daney <david.daney@cavium.com>, Rob Herring <robherring2@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4F7205F3.3000108@cavium.com>
References: <1332790281-9648-1-git-send-email-ddaney.cavm@gmail.com> <1332790281-9648-3-git-send-email-ddaney.cavm@gmail.com> <4F711E69.1080302@gmail.com> <4F7205F3.3000108@cavium.com>
Date: Wed, 28 Mar 2012 16:22:46 -0600
Message-Id: <20120328222246.8AFA83E0CFE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012 11:24:51 -0700, David Daney <david.daney@cavium.com> wrote:
> On 03/26/2012 06:56 PM, Rob Herring wrote:
> > On 03/26/2012 02:31 PM, David Daney wrote:
> >> From: David Daney<david.daney@cavium.com>
> [...]
> >> +static int octeon_irq_ciu_map(struct irq_domain *d,
> >> +			      unsigned int virq, irq_hw_number_t hw)
> >> +{
> >> +	unsigned int line = hw>>  6;
> >> +	unsigned int bit = hw&  63;
> >> +
> >> +	if (virq>= 256)
> >> +		return -EINVAL;
> >
> > Drop this. You should not care what the virq numbers are.
> 
> 
> I care that they don't overflow the width of octeon_irq_ciu_to_irq (a u8).
> 
> So really I want to say:
> 
>     if (virq >= (1 << sizeof (octeon_irq_ciu_to_irq[0][0]))) {
>         WARN(...);
>         return -EINVAL;
>     }
> 
> 
> I need a map external to any one irq_domain.  The irq handling code 
> handles sources that come from two separate irq_domains, as well as irqs 
> that are not part of any domain.

You can get past this limitation by using the struct irq_data .hwirq and
.domain members for the irq ==> hwirq translation, and for hwirq ==>
irq the code should already have the context to know which user it is.

For the irqs that are not covered by an irq_domain, the driver is free
to set the .hwirq value directly.  Ultimately however, it will
probably be best to add an irq domain for those users also.

...

Howver, I don't understand where the risk is in overflowing
octeon_irq_ciu_to_irq[][].  From what I can see, the virq value isn't
used at all to calculate the array dereference.  line and bit are
calculated from the hwirq value.  What am I missing?

g.
