Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1FCKmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:42:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56144 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752231Ab1FCKmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:42:19 -0400
Date: Fri, 3 Jun 2011 11:42:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Milton Miller <miltonm@bga.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
Message-ID: <20110603104217.GA4777@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <nack-locate@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nack-locate@mdm.bga.com>
X-Cookie: There is a 20% chance of tomorrow.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 04:24:02AM -0500, Milton Miller wrote:
> On Thu, 02 Jun 2011 17:55:13 -0000, Mark Brown wrote:

> >  	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,

> and then right after this the code continues:

>         ret = -EEXIST;
>         if (irq >=0 && start != irq)
>                 goto err;

> This patch enables exactly the calls I want to forbid !  Why do

Which you wish to forbid because...?  You've not articulated any
motivation for doing this which makes it rather hard to engage here.

> you need to verify that there are no irqs between from and irq ?

I don't care if there are IRQs between from and the specified irq, all I
care about is that we get back the irq we requested (apart from anything
else the function will later error out if the allocated IRQ doesn't
match the one that was specified - it seems very clear from both the
code and documentation that if an IRQ is specified we're supposed to get
it back).

 - The specified IRQ is ignored except 

> What is your use case?

I've requested a base IRQ but the only attention that irq_alloc_descs()
is paying to it is that it generates an error rather than allocating
something 

> Change your caller to specify the irq twice if you need a specific irq

This seems like a poor UI for the function, if the user specified an
irq_base and there's a suitable range of IRQs available at that base 
what is the benefit in refusing to allocate there?  That's just going to
make the system fragile against init ordering and driver disabling.

It's also going to be a bit more cumbersome to use:

	if (pdata->irq_base > 0) {
		irq_base = pdata->irq_base;
		from = pdata->irq_base;
	} else {
		irq_base = -1;
		from = 0;
	}

> block, or if you only need one then use the helper irq_alloc_desc_at.

I need about 60 IRQs in the particular driver where I noticed this.

> If you want to change irq_alloc_descs, please make it return -EINVAL
> if irq >=0 && from != irq (like I did).

> See http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/00739.html
> [PATCH RFC 4/4] irq: allow a per-allocation upper limit when allocating irqs

> (and yes, I have made the changes based on the feedback but haven't

I don't really see the relevance of this patch?  You're adding
functionality for limiting the maximum IRQ number allocated which seems
orthogonal to the issue.
