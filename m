Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3AGQgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:36:47 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53861 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3AGQgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:36:46 -0500
Subject: Re: How kernel handle interrupts[AX88796B network controller]
From: anish kumar <anish198519851985@gmail.com>
To: Woody Wu <narkewoody@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org
In-Reply-To: <20121222151117.GA16992@zuhnb712>
References: <20121220142745.GB3578@zuhnb712>
	 <CAK7N6vq07CHhhOJTgC=5H5f3Nsi_od=qGJjzu01iL1_3AvTWHg@mail.gmail.com>
	 <20121221153451.GB5530@zuhnb712>
	 <1356125583.1598.111.camel@anish-Inspiron-N5050>
	 <20121222151117.GA16992@zuhnb712>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jan 2013 22:06:30 +0530
Message-ID: <1357576590.1637.13.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-22 at 23:11 +0800, Woody Wu wrote:
> On Fri, Dec 21, 2012 at 01:33:03PM -0800, anish kumar wrote:
> > On Fri, 2012-12-21 at 23:34 +0800, Woody Wu wrote:
> > > On Thu, Dec 20, 2012 at 10:05:05AM -0800, anish singh wrote:
> > > > On Dec 20, 2012 6:30 AM, "Woody Wu" <narkewoody@gmail.com> wrote:
> > > > >
> > > > > Hi, List
> > > > >
> > > > > Where is the Kernel code that handles external interrupts? I want to
> > > > > have a look at it but haven't found out where it is.
> > > > >
> > > > > Actually, I have some basic questions about interrupt handling in Linux.
> > > > > 1. After Kernel's ISR received an interrupt, I believe it will invoke a
> > > > >    handler defined in a device driver if any. But it should be the
> > > > >    device driver's responsibility or kernel ISR's responsibility to
> > > > >    clear (or acknowledge) the interrupt?
> > > > If the interrupt in question is currently being handled then in
> > > > the case of edge triggered interrupt we just mask the interrupt,set it
> > > > pending and bail out.Once the interrupt handler completes then we check for
> > > > pending interrupt and handle it.In level triggered we don't do that.
> > > > Kerenel ISR -this is mixture of core kernel interrupt handling code + your
> > > > device driver interrupt handler(if this is chip driver which is supposed to
> > > > get one interrupt and is reponsible for calling other interrupt handlers
> > > > based on the chip register status then you do explicit masking unmasking
> > > > yourself).
> > > > If you device driver is a interrupt controller driver then you register
> > > > your driver with kernel interrupt handling code and need to write some
> > > > callbacks such as .mask,.unmask and so on.This callbacks are called at
> > > > appropiate places whenever the interrupt is raised.This interrupt is then
> > > > passed to drivers who has requested for this interrupt by calling
> > > > request_irq.
> > > > >
> > > > > 2. My device, an AX88796B network controller, asserting the interrupt
> > > > >    line in a level-triggered manner. Now I met problem with the device
> > > > that
> > > > >    might caused by the CPU interrupt mode is not set as level-triggered by
> > > > >    edge trigger.  My CPU is Samsung S3C2410, an ARM920T powered one.  Does
> > > > >    anyone know usually where and how should I do this kind of setting?
> > > > Just pass the parameter "level triggered" in request_irq in your device
> > > > driver.
> > > 
> > > Hi Sign,
> > > 
> > > I searched the interrupt.h for the all the defined flags that I can pass
> > > to the request_irq, but there is no a flag looks like "level triggered".
> > > Would you tell me what you mean the parameter "level triggered"?
> > irq_set_irq_type(info->irq, IRQ_TYPE_LEVEL_LOW)
> > 
> > include/linux/irq.h
> > IRQ_TYPE_LEVEL_HIGH          - high level triggered
> > IRQ_TYPE_LEVEL_LOW           - low level triggered
> 
> Thanks. Now I find the function.
> 
> I searched some code about irq in ARM architecure.  Some other
> people talked about do_IRQ() probabaly is wrong for ARM. There is simply
> no that function in ARM. Maybe the do_IRQ in x86 is replaced by
> handle_IRQ.
arch/arm/kernel/entry-armv.S
__irq_svc is called by the arm processor which in turn calls irq_handler
macro.I think this is the lowest level handler after which linux
interrupt handling takes over.
> 
> For the irq_set_irq_type(), do you think what's the correct place to
> call it? Inside my device driver or outside the device driver (probably
> in the board definition file)? If that should be called inside a device
> driver, should it be the driver probe function or in the open function?
> After or before the invocation of request_irq()?
irq_set_irq_type() should be called by device driver code not by the
board file.It should be called in the probe function AFAIK.
> 
> Sorry for asking too many question.  I found the kernel + device driver
> irq handling part still not clear to me.
You are welcome to ask as many question as you want.
> 
> 
> > > 
> > > Thanks.
> > > 
> > > > >
> > > > >
> > > > > Thanks in advance.
> > > > >
> > > > > --
> > > > > woody
> > > > > I can't go back to yesterday - because I was a different person then.
> > > > >
> > > > > _______________________________________________
> > > > > Kernelnewbies mailing list
> > > > > Kernelnewbies@kernelnewbies.org
> > > > > http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
> > > 
> > 
> 


