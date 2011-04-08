Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab1DHWzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:55:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51375 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab1DHWzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:55:33 -0400
Date: Fri, 8 Apr 2011 23:55:30 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2 1/2] x86, mrst: share APB timer code with other
 platforms
Message-ID: <20110408225530.GJ2933@pulham.picochip.com>
References: <1302273218-7263-1-git-send-email-jamie@jamieiles.com>
 <1302273218-7263-2-git-send-email-jamie@jamieiles.com>
 <20110408150303.67ac8d80@jacob-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408150303.67ac8d80@jacob-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacob,

On Fri, Apr 08, 2011 at 03:03:03PM -0700, jacob pan wrote:
> On Fri,  8 Apr 2011 15:33:37 +0100
> Jamie Iles <jamie@jamieiles.com> wrote:
> 
> > The APB timers are an IP block from Synopsys (DesignWare APB timers)
> > and are also found in other systems including ARM SoC's.  This patch
> > adds functions for creating clock_event_devices and clocksources from
> > APB timers but does not do the resource allocation.  This is handled
> > in a higher layer to allow the timers to be created from multiple
> > methods such as platform_devices.
> > 
> > Changes since v1:
> > 	- Use the correct timer for clocksource on x86
> > 	- Select the correct timer rating for x86
> > 	- Restore freerunning timer behaviour for oneshot event
> > devices
> > 	- Reenable event irq correctly for hotplug
> > 
> > Cc: John Stultz <johnstul@us.ibm.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > ---
> >  arch/x86/Kconfig                   |    1 +
> >  arch/x86/include/asm/apb_timer.h   |   22 +--
> >  arch/x86/kernel/apb_timer.c        |  421
> > ++++++------------------------------
> > drivers/Kconfig                    |    2 +
> > drivers/clocksource/Kconfig        |    6 +
> > drivers/clocksource/Makefile       |    1 +
> > drivers/clocksource/dw_apb_timer.c |  322 +++++++++++++++++++++++++++
> > include/linux/dw_apb_timer.h       |  129 +++++++++++ 8 files
> > changed, 535 insertions(+), 369 deletions(-) create mode 100644
> > drivers/clocksource/Kconfig create mode 100644
> > drivers/clocksource/dw_apb_timer.c create mode 100644
> > include/linux/dw_apb_timer.h
> > 
> 
> > +static void apbt_eoi(struct dw_apb_timer *timer)
> > +{
> > +	apbt_readl(timer, APBTMR_N_EOI);
> > +}
> > +
> > +static irqreturn_t dw_apb_clockevent_irq(int irq, void *data)
> > +{
> > +	struct clock_event_device *evt = data;
> > +	struct dw_apb_clock_event_device *dw_ced =
> > ced_to_dw_apb_ced(evt); +
> > +	if (!evt->event_handler) {
> > +		pr_info("Spurious APBT timer interrupt %d", irq);
> > +		return IRQ_NONE;
> > +	}
> > +
> > +	dw_ced->eoi(&dw_ced->timer);
> I know I proposed this to deal with the fact that X86_MRST does not
> need eoi. I was hoping gcc to generate nops but it doesn't, especially
> with FRAME_POINTER turned on in our build.
>
> Since this is in the performance critical path and across ARM and X86
> architectures, can we use #define to skip eoi() for CONFIG_X86_MRST?

How about testing if dw_apb_timer::eoi is defined first before calling 
and not defining it for x86?  It's not zero overhead but it's less than 
what there is now.  The call would still be there for ARM but I don't 
have a good feel for how much this overhead is in relation to the rest 
of the IRQ and clock events handling.  I would guess that it isn't too 
significant.

Jamie
