Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab2LLH4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 02:56:07 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50316 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2LLH4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 02:56:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121211162048.6c9206c7@skate>
References: <1350644042-31793-1-git-send-email-linus.walleij@linaro.org>
	<20121211162048.6c9206c7@skate>
Date: Wed, 12 Dec 2012 08:56:03 +0100
Message-ID: <CACRpkdY1wtPSW6Nab0tvcr+CF=Neki1mbZ8EdsHk0xkOTtnL1w@mail.gmail.com>
Subject: Re: [PATCH 3/4 v2] gpio/mvebu: convert to use irq_domain_add_simple()
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 4:20 PM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:

> Unfortunately, this creates the following warning at boot time for each
> GPIO bank:

Grant has a patch in his irqdomain tree that will turn this warning into
a simple pr_info() thing instead. It's not that bad... The immediate
problem will soon go away.

> Of course, the fix should be to remove the irq_alloc_descs() from the
> driver prior to calling irq_domain_add_simple(). But the thing is that
> our gpio-mvebu driver uses the
> irq_alloc_generic_chip()/irq_setup_generic_chip() infrastructure, which
> it seems requires a legacy IRQ domain (it needs the base IRQ number).

Actually it looks like a core infrastructure issue. Sorry for not
spotting this in the first place:

First you allocate some descriptors, just any descriptors, with
mvchip->irqbase = irq_alloc_descs(-1, 0, ngpios, -1);

Then you allocate a generic chip using the obtained
descriptor base:
gc = irq_alloc_generic_chip("mvebu_gpio_irq", 2, mvchip->irqbase,
				    mvchip->membase, handle_level_irq);

Then you set up the generic chip with a nailed down IRQ base number
from step 1:
irq_setup_generic_chip(gc, IRQ_MSK(ngpios), 0,
			       IRQ_NOREQUEST, IRQ_LEVEL | IRQ_NOPROBE);

This, if I understand it correctly, is done because you have two different
chip types on the generic chip: one for high/low level IRQ and another
for rising/falling. (Which is a very nice way to use the generic chip!)

Finally set up the IRQ domain:
mvchip->domain = irq_domain_add_simple(np, mvchip->chip.ngpio,
				       mvchip->irqbase,
				       &irq_domain_simple_ops,
				       mvchip);

So the problem is that you cannot allocate a generic chip
without having a base IRQ at that point, if I understand
correctly. If this was not necessary you would not need to
allocate descriptors in advance.

Or rather: the *real* problem, which will face anyone trying
to implement a combined edge+level IRQ chip in a driver,
is that the generic irqchip does not play well with irqdomain.

Using legacy in this case is clearly wrong, the generic IRQ chip
is not one least bit legacy, it's top-of-the-line IRQ handling,
using generic code as we want.

However it seems generic chips cannot handle sparse IRQs
at all, it requires the descriptors to be allocated before
we create and instance of it.

So I see two solutions:

- Fix the generic chip to handle sparse IRQs by patching
  a lot in kernel/irq/generic-chip.c and allowing to pass
  something like < 0 for irq base.

- Add something like irq_domain_add_generic() for
  generic chips and handle the oddities there.

The latter would be a pretty straight-forward wrapper to legacy
domain as of now.

Any preference? Or should we just consider generic irqchips
a legacy case?

Yours,
Linus Walleij
