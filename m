Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1DKRfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:35:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:30542 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1DKRfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:35:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,340,1299484800"; 
   d="scan'208";a="731880367"
Date: Mon, 11 Apr 2011 10:35:36 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCHv2 1/2] x86, mrst: share APB timer code with other
 platforms
Message-ID: <20110411103536.218c59ec@jacob-laptop>
In-Reply-To: <20110408225530.GJ2933@pulham.picochip.com>
References: <1302273218-7263-1-git-send-email-jamie@jamieiles.com>
	<1302273218-7263-2-git-send-email-jamie@jamieiles.com>
	<20110408150303.67ac8d80@jacob-laptop>
	<20110408225530.GJ2933@pulham.picochip.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011 23:55:30 +0100
Jamie Iles <jamie@jamieiles.com> wrote:

> Hi Jacob,
> 
> On Fri, Apr 08, 2011 at 03:03:03PM -0700, jacob pan wrote:
> > On Fri,  8 Apr 2011 15:33:37 +0100
> > Jamie Iles <jamie@jamieiles.com> wrote:
> > 
> > > The APB timers are an IP block from Synopsys (DesignWare APB
> > > timers) and are also found in other systems including ARM SoC's.
> > > This patch adds functions for creating clock_event_devices and
> > > clocksources from APB timers but does not do the resource
> > > allocation.  This is handled in a higher layer to allow the
> > > timers to be created from multiple methods such as
> > > platform_devices.
> > > 
> > > Changes since v1:
> > > 	- Use the correct timer for clocksource on x86
> > > 	- Select the correct timer rating for x86
> > > 	- Restore freerunning timer behaviour for oneshot event
> > > devices
> > > 	- Reenable event irq correctly for hotplug
> > > 
> > > Cc: John Stultz <johnstul@us.ibm.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > > ---
> > >  arch/x86/Kconfig                   |    1 +
> > >  arch/x86/include/asm/apb_timer.h   |   22 +--
> > >  arch/x86/kernel/apb_timer.c        |  421
> > > ++++++------------------------------
> > > drivers/Kconfig                    |    2 +
> > > drivers/clocksource/Kconfig        |    6 +
> > > drivers/clocksource/Makefile       |    1 +
> > > drivers/clocksource/dw_apb_timer.c |  322
> > > +++++++++++++++++++++++++++ include/linux/dw_apb_timer.h       |
> > > 129 +++++++++++ 8 files changed, 535 insertions(+), 369
> > > deletions(-) create mode 100644 drivers/clocksource/Kconfig
> > > create mode 100644 drivers/clocksource/dw_apb_timer.c create mode
> > > 100644 include/linux/dw_apb_timer.h
> > > 
> > 
> > > +static void apbt_eoi(struct dw_apb_timer *timer)
> > > +{
> > > +	apbt_readl(timer, APBTMR_N_EOI);
> > > +}
> > > +
> > > +static irqreturn_t dw_apb_clockevent_irq(int irq, void *data)
> > > +{
> > > +	struct clock_event_device *evt = data;
> > > +	struct dw_apb_clock_event_device *dw_ced =
> > > ced_to_dw_apb_ced(evt); +
> > > +	if (!evt->event_handler) {
> > > +		pr_info("Spurious APBT timer interrupt %d", irq);
> > > +		return IRQ_NONE;
> > > +	}
> > > +
> > > +	dw_ced->eoi(&dw_ced->timer);
> > I know I proposed this to deal with the fact that X86_MRST does not
> > need eoi. I was hoping gcc to generate nops but it doesn't,
> > especially with FRAME_POINTER turned on in our build.
> >
> > Since this is in the performance critical path and across ARM and
> > X86 architectures, can we use #define to skip eoi() for
> > CONFIG_X86_MRST?
> 
> How about testing if dw_apb_timer::eoi is defined first before
> calling and not defining it for x86?  It's not zero overhead but it's
> less than what there is now.  The call would still be there for ARM
> but I don't have a good feel for how much this overhead is in
> relation to the rest of the IRQ and clock events handling.  I would
> guess that it isn't too significant.
sounds good to me, I agree the check costs less than a function call. My
original concern for check was that since they are in timer interrupt
so the branch prediction may not work well (no history). But a failed
branch prediction should not cost too much for either ATOM or ARM since
both should have shorter pipeline. It would cost a lot more on P4 :).

-- 
Thanks

Jacob
(from Linux laptop)
