Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab1DCEpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 00:45:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52768 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1DCEpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 00:45:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110403025907.GA5670@pulham.picochip.com>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
 <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6> <20110403025907.GA5670@pulham.picochip.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 2 Apr 2011 22:45:32 -0600
X-Google-Sender-Auth: YSlOtxka5hyBN2DOrayy__jmN0M
Message-ID: <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
To: Jamie Iles <jamie@jamieiles.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

On Sat, Apr 2, 2011 at 8:59 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> On Sun, Apr 03, 2011 at 12:10:04AM +0200, Thomas Gleixner wrote:
>> > +
>> > +   if (port_mask & DW_GPIO_PORTD_MASK)
>> > +           dw->portd_end = ((cfg2 & GPIO_PORTD_WIDTH_MASK) >>
>> > +                            GPIO_PORTD_WIDTH_SHIFT) + 1 + dw->portc_end;
>> > +   else
>> > +           dw->portd_end = dw->portb_end;
>> > +}
>>
>> So you try to create a linear GPIO space which skips reserved
>> pins. What's the point of that? It adds useless overhead in the
>> hotpath for no value. It is confusing as there is no relation between
>> the HW pin and the gpio number anymore.
>>
>> Why can't we just have a linear space where the reserved gpios are
>> simply not accessible?
>
> So the reason here is that the IP may be configured with multiple ports
> of different sizes.  A real world example we have is port widths of
> 8-16-1-32 and the only actual reserved GPIO is the single pin on port C.
> So we could say that the chip supports 128 GPIOs with loads of reserved
> GPIOs but that didn't seem too intuitive to me.  I'm a bit conflicted on
> this one.

The solution here I believe is to simply treat each bank as a separate
device.  For a generic driver, I see little advantage in linking all
the banks together unless there are tight interdependencies between
the banks, which I suspect is unlikely.

>> > +   writel(0, INT_EN_REG(dw));
>> > +   writel(~0, EOI_REG(dw));
>> > +   for (i = irqs->start; i <= irqs->end; ++i) {
>> > +           irq_set_chip_and_handler_name(i, &dwgpio_irqchip,
>> > +                                         handle_simple_irq, "demux");
>>
>> Why do you have irq_ack/mask/unmask functions when you use
>> handle_simple_irq? Just because the random driver you copied from has
>> them as well? They are never called.
>
> So would it be correct to start of with handle_level_irq() then to
> change the handler in the irq_set_type method with
> __irq_set_handler_locked().

Thomas, I think the IRQ apis are a source of confusion for a lot of
people.  I find I tend to get lost in the details.  Is there a good
document covering the current state of irq handling that folks like
James can be pointed towards?  I don't see much in the Documentation
directory covering things like how to use irqchips.  Best seems to be
Documentation/arm/Interrupts which may be out of date.

>> > +           irq_set_chip(i, NULL);
>> > +           irq_set_chip_data(i, NULL);
>> > +   }
>> > +}
>>
>> Sigh. This is another incarnation of a bog standard GPIO driver, which
>> has the ever repeating pattern of configuration, input read, output
>> write and interrupt functions. It's about time to stop that nonsense.
>>
>> GPIO implementations are not that different and we really want to
>> abstract out the few implementations and be done with it.
>
> Fair comments.  I don't feel I have the expertise to undertake this
> generic abstraction myself but I'd be more than happy to help out if
> someone else did.

Actually, there is a starting point you can work with.  Look at
drivers/gpio/basic_mmio_gpio.c, and see if it can be molded to suit
your purposes.  (cc'ing Anton as he wrote it).  Start with the basic
GPIO access, and then look at grafting in the IRQ functionality as a
second step.

There don't appear to be any actual users of that driver in mainline
at the moment, so feel free to propose changes if need be.  I'm not
hugely thrilled with the current method that the driver uses to define
the register locations (using named resources).  My instinct would be
to use a single register resource region with offsets for each
register type defined from the base of it, but Anton can probably fill
us in on the reason that approach was used.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
