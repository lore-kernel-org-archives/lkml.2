Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3AGQW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:22:56 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38294 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3AGQWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:22:52 -0500
Subject: Re: How kernel handle interrupts[AX88796B network controller]
From: anish kumar <anish198519851985@gmail.com>
To: Woody Wu <narkewoody@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org
In-Reply-To: <20121224141017.GB2849@zuhnb712>
References: <20121220142745.GB3578@zuhnb712>
	 <CAK7N6vq07CHhhOJTgC=5H5f3Nsi_od=qGJjzu01iL1_3AvTWHg@mail.gmail.com>
	 <20121221153451.GB5530@zuhnb712>
	 <1356125583.1598.111.camel@anish-Inspiron-N5050>
	 <20121224141017.GB2849@zuhnb712>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jan 2013 21:52:37 +0530
Message-ID: <1357575757.1637.9.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-24 at 22:10 +0800, Woody Wu wrote:
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
> Thanks. You saved my ass.
> 
> Be curious, I found the api changes from 2.6 to 3.7.  In 2.6, there are
> pair of funtions, set_irq_type and set_irq_handle (there is no
> irq_set_irq_type in 2.6).  Problem is, I cannot find something like
> irq_set_irq_handle in 3.7.  Does that mean, in 3.7, when
> irq_set_irq_type is changed, the associated flow handler is also
> changed?  In my case, the interrupt was originally assgined with a edge
> flow handler and set type as edge irq. After I, by invoking
> irq_set_irq_type, change it to level irq, I think the flow handler
> should also be changed to a level handle.  Is that happened
> automatically behind?  I search through the code, but did not find where
> is it.
Why not try calling irq_set_irq_type and check what happens?
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


