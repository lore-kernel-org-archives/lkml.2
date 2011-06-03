Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1FCOnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:43:46 -0400
Received: from mail4.comsite.net ([205.238.176.238]:44837 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1FCOnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:43:45 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
From: Milton Miller <miltonm@bga.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
Message-ID: <locate-from-more@mdm.bga.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <nack-locate@mdm.bga.com>
 <20110603104217.GA4777@opensource.wolfsonmicro.com>
Date: Fri, 03 Jun 2011 09:43:42 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011 about 11:42:17 +0100, Mark Brown wrote:
> On Fri, Jun 03, 2011 at 04:24:02AM -0500, Milton Miller wrote:
> > On Thu, 02 Jun 2011 17:55:13 -0000, Mark Brown wrote:
> 
> > >  	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
> 
> > and then right after this the code continues:
> 
> >         ret = -EEXIST;
> >         if (irq >=0 && start != irq)
> >                 goto err;
> 
> > This patch enables exactly the calls I want to forbid !  Why do
> 
> Which you wish to forbid because...?  You've not articulated any
> motivation for doing this which makes it rather hard to engage here.

In 2.6.39 all calls to irq_alloc_descs were from the helpers.  Either
from  irq_alloc_descriptor_at , which says "I need this exact irq",
or from irq_alloc_desc, which says "give me any irq".

I treated the arguments to irq_alloc_descs as having grown to
accomidate the two uses having a common allocator with the partially
redunant encoding.  In one case an exact irq was specified (irq >= 0),
and one that allocates from anywhere (irq < 0, all callers passed -1).

Maybe you have a new case.

> 
> > you need to verify that there are no irqs between from and irq ?
> 
> I don't care if there are IRQs between from and the specified irq, all I
> care about is that we get back the irq we requested (apart from anything
> else the function will later error out if the allocated IRQ doesn't
> match the one that was specified - it seems very clear from both the
> code and documentation that if an IRQ is specified we're supposed to get
> it back).
> 
>  - The specified IRQ is ignored except 
> 
> > What is your use case?
> 
> I've requested a base IRQ but the only attention that irq_alloc_descs()
> is paying to it is that it generates an error rather than allocating
> something 

Do you need a specific irq or an allocated one?

Or do you have a case where you don't know?

> 
> > Change your caller to specify the irq twice if you need a specific irq
> 
> This seems like a poor UI for the function, if the user specified an
> irq_base and there's a suitable range of IRQs available at that base 
> what is the benefit in refusing to allocate there?  That's just going to
> make the system fragile against init ordering and driver disabling.

I am thinking two use cases: dynamic in a range, and pre specified
(often by an intermediate layer).

But your example seems to imply a driver used in different environments:

> 
> It's also going to be a bit more cumbersome to use:
> 
> 	if (pdata->irq_base > 0) {
> 		irq_base = pdata->irq_base;
> 		from = pdata->irq_base;
> 	} else {
> 		irq_base = -1;
> 		from = 0;
> 	}
> 
> > block, or if you only need one then use the helper irq_alloc_desc_at.
> 
> I need about 60 IRQs in the particular driver where I noticed this.

Do you need a block of 60?  or just 60 somewhere?

How do you know from = 0 is safe?

> 
> > If you want to change irq_alloc_descs, please make it return -EINVAL
> > if irq >=0 && from != irq (like I did).
> 
> > See http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/00739.html
> > [PATCH RFC 4/4] irq: allow a per-allocation upper limit when allocating irqs
> 
> > (and yes, I have made the changes based on the feedback but haven't
> 
> I don't really see the relevance of this patch?  You're adding
> functionality for limiting the maximum IRQ number allocated which seems
> orthogonal to the issue.

Its relavant in that irq_alloc_descs_range no longer gets both irq and from;
the information is passed to the underling allocator in a different form.

Ie dynamic allocations will be in [x, y), static will be at x.

It may be possible to still pass this information without additional
arguments but I haven't had time to think about it yet.


I'm attending a conference and am quite busy but will see if I can
spend some break time on this.

milton
