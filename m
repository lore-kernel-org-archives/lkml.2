Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1DCJar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:30:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:57050 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1DCJap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:30:45 -0400
Date: Sun, 3 Apr 2011 11:30:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Jamie Iles <jamie@jamieiles.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
In-Reply-To: <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com> <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6> <20110403025907.GA5670@pulham.picochip.com> <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1548773151-1301823042=:5929"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1548773151-1301823042=:5929
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 2 Apr 2011, Grant Likely wrote:
> Hi Jamie,
> 
> On Sat, Apr 2, 2011 at 8:59 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> > On Sun, Apr 03, 2011 at 12:10:04AM +0200, Thomas Gleixner wrote:
> >> > +
> >> > +   if (port_mask & DW_GPIO_PORTD_MASK)
> >> > +           dw->portd_end = ((cfg2 & GPIO_PORTD_WIDTH_MASK) >>
> >> > +                            GPIO_PORTD_WIDTH_SHIFT) + 1 + dw->portc_end;
> >> > +   else
> >> > +           dw->portd_end = dw->portb_end;
> >> > +}
> >>
> >> So you try to create a linear GPIO space which skips reserved
> >> pins. What's the point of that? It adds useless overhead in the
> >> hotpath for no value. It is confusing as there is no relation between
> >> the HW pin and the gpio number anymore.
> >>
> >> Why can't we just have a linear space where the reserved gpios are
> >> simply not accessible?
> >
> > So the reason here is that the IP may be configured with multiple ports
> > of different sizes.  A real world example we have is port widths of
> > 8-16-1-32 and the only actual reserved GPIO is the single pin on port C.
> > So we could say that the chip supports 128 GPIOs with loads of reserved
> > GPIOs but that didn't seem too intuitive to me.  I'm a bit conflicted on
> > this one.
> 
> The solution here I believe is to simply treat each bank as a separate
> device.  For a generic driver, I see little advantage in linking all
> the banks together unless there are tight interdependencies between
> the banks, which I suspect is unlikely.

Right. There are some chips which have shared base control registers
for the ports (some call them banks) but that can be dealt with as
well.
 
> >> > +   writel(0, INT_EN_REG(dw));
> >> > +   writel(~0, EOI_REG(dw));
> >> > +   for (i = irqs->start; i <= irqs->end; ++i) {
> >> > +           irq_set_chip_and_handler_name(i, &dwgpio_irqchip,
> >> > +                                         handle_simple_irq, "demux");
> >>
> >> Why do you have irq_ack/mask/unmask functions when you use
> >> handle_simple_irq? Just because the random driver you copied from has
> >> them as well? They are never called.
> >
> > So would it be correct to start of with handle_level_irq() then to
> > change the handler in the irq_set_type method with
> > __irq_set_handler_locked().

Yes.
 
> Thomas, I think the IRQ apis are a source of confusion for a lot of
> people.  I find I tend to get lost in the details.  Is there a good
> document covering the current state of irq handling that folks like
> James can be pointed towards?  I don't see much in the Documentation
> directory covering things like how to use irqchips.  Best seems to be
> Documentation/arm/Interrupts which may be out of date.

Yes I know, that documentation sucks. I need to find a few cycles to
update it.

For the question at hand, yes we can change the chip and the handler
in the irq_set_type() callback of the current irq_chip. That avoids
conditionals in the chip functions.

> Actually, there is a starting point you can work with.  Look at
> drivers/gpio/basic_mmio_gpio.c, and see if it can be molded to suit
> your purposes.  (cc'ing Anton as he wrote it).  Start with the basic
> GPIO access, and then look at grafting in the IRQ functionality as a
> second step.
> 
> There don't appear to be any actual users of that driver in mainline
> at the moment, so feel free to propose changes if need be.  I'm not
> hugely thrilled with the current method that the driver uses to define
> the register locations (using named resources).  My instinct would be
> to use a single register resource region with offsets for each
> register type defined from the base of it, but Anton can probably fill
> us in on the reason that approach was used.

Right, that avoids multiple ioremaps for the same physical address
space. There are more odds in that driver. It should setup proper
function pointers for accessing the registers instead of runtime
evaluation of everything.

Thanks,

	tglx


---1463795968-1548773151-1301823042=:5929--
