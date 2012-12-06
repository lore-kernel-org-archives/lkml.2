Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2LFDtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 22:49:49 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:44738 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab2LFDtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 22:49:47 -0500
Message-ID: <1354765784.12428.3.camel@trivette.home.lan>
Subject: Re: [PATCH] gpio: add TS-5500 DIO headers support
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>
Date: Wed, 05 Dec 2012 22:49:44 -0500
In-Reply-To: <CACRpkdbbungMiZ74o=-CfRoLQj127CaWaYr7adKKSquFd=x5qg@mail.gmail.com>
References: <1348620130-25987-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <CACRpkdaaD6HY2o-NNBRZYCXm97Dts7Njzz13Zj7m2ZycV-Ar5g@mail.gmail.com>
	 <1349720405.23690.45.camel@trivette>
	 <CACRpkdbbungMiZ74o=-CfRoLQj127CaWaYr7adKKSquFd=x5qg@mail.gmail.com>
Organization: Savoir-faire Linux Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I rewrote some parts according to your comments, but I still have some
concerns.

On Fri, 2012-10-12 at 22:53 +0200, Linus Walleij wrote:
> >> (...)
> >> > +static int ts5500_gpio_to_irq(struct gpio_chip *chip, unsigned
> offset)
> >> > +{
> >> > +       const struct ts5500_dio line = ts5500_dios[offset];
> >> > +
> >> > +       /* Only a few lines are IRQ-capable */
> >> > +       if (line.irq != NO_IRQ)
> >> > +               return line.irq;
> >> > +
> >> > +       /* This allows to bridge a line with the IRQ line of the
> same header */
> >> > +       if (dio1_irq && offset < 13)
> >> > +               return ts5500_dios[13].irq;
> >> > +       if (dio2_irq && offset > 13 && offset < 26)
> >> > +               return ts5500_dios[26].irq;
> >> > +       if (lcd_irq && offset > 26 && offset < 37)
> >> > +               return ts5500_dios[37].irq;
> >>
> >> Don't do this. Please use irqdomain for converting physical
> >> IRQ numbers to Linux IRQ numbers. (Consult other GPIO
> >> drivers for examples.)
> >>
> >> These magic constants (13, 26, 37) are scary too.
> >>
> >> You should not try to handle each block as a single
> >> IRQ, instead instatiate a struct irq_chip in the driver
> >> and let that use irqdomain do demux the IRQ and
> >> register a range of Linux IRQ numbers, on per pin,
> >> so the GPIO driver will handle the physical IRQ line,
> >> then dispatch to a fan-out handler, so drivers that need
> >> IRQs from the GPIO chip just register IRQ handlers like
> >> anyone else.
> >
> > Do you mean that I should not return the same IRQ line for the same
> > header, but virtual ones? I'll try to find a good example for that.
> 
> Basically Linux IRQs (also sometimes called virtual IRQs) are
> separate from the physical IRQ numbers of the system.
> 
> i.e. what you see in /proc/interrupts has no relation to the physical
> interrupt lines.
> 
> Keep in mind that we're trying to disallow IRQ 0 altogether and some
> platforms use that physical line for stuff.
> 
> So we need to use irqdomain to just grab an IRQ number to reference
> the physical line. And we often do that for the IRQ controller.
> 
> The fact that sometimes the physical line number and the Linux
> IRQ number correspond is just misleading...
> 
> In this case, since you have individual IRQs you want to check
> for different lines, register something with e.g.
> irq_domain_add_simple() to handle all these lines as IRQs.
> 
> It's a bit complex but pays off: all of a sudden you get statistics
> in /proc/interrupts for exactly which GPIO IRQs were fired,
> for example, and they get names if you provide that.
> 
> Look at the other GPIO drivers for many good examples of
> how to do this. gpio-em.c is one example. 

I looked at some drivers and if I'm not mistaken, this case is
different. Technologic Systems platforms (such as the TS-5500) have
several pin blocks. Each block has input-only, input-output or
output-only pins. Only one pin per block is connected to an interrupt
line. But sadly, these interrupt-connected lines are input only.
Here are the details about the TS-5500 pin block "DIO1":

http://wiki.embeddedarm.com/wiki/TS-5500#DIO1_Header

Some GPIO devices need a bidirectional data line which can trigger an
IRQ. In this case, we use a bidirectional pin for data, that we strap to
the IRQ-able pin.

Basically, our setup looks like that:

    +---+ in-only+IRQ
    | D |-------------+  data +--------+
    | I | in/out pin  |-------|  GPIO  |
    | O |-------------+   clk | device |
    | 1 |---------------------|(SHT15) |
    +---+ in/out pin          +--------+

That's why I previously used a dio1_irq platform data field, to return
the interrupt connected to the IRQ-able pin for any GPIO on DIO1, in the
gpio_to_irq() implementation.

A Linux IRQ per pin doesn't seem to be possible because the
irq_create_mapping() documentation says that "Only one mapping per
hardware interrupt is permitted." Should I still implement the
irq_chip/irqdomain for a single IRQ per block? For each pin?
What do you think about this implementation?


Yours,
Vivien

