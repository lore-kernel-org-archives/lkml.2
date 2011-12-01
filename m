Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1LAJAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:00:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:25555 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1LAJAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:00:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,277,1320652800"; 
   d="scan'208";a="90973640"
Date: Thu, 1 Dec 2011 17:00:21 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kwlee@mtekvision.com" <kwlee@mtekvision.com>,
        "Clark, Joel" <joel.clark@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] Input: tsc2007 - Disable irq when the irq thread is
 handling data
Message-ID: <20111201170021.3556aac3@feng-i7>
In-Reply-To: <20111201084818.GC31610@core.coreip.homeip.net>
References: <1322554378-348-1-git-send-email-feng.tang@intel.com>
	<20111129092208.GA21758@core.coreip.homeip.net>
	<20111130100824.535c7e16@feng-i7>
	<20111201061015.GD16816@core.coreip.homeip.net>
	<20111201143012.498c506c@feng-i7>
	<20111201084818.GC31610@core.coreip.homeip.net>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On Thu, 1 Dec 2011 16:48:18 +0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Thu, Dec 01, 2011 at 02:30:12PM +0800, Feng Tang wrote:
> > Hi Dmitry,
> > 
> > On Thu, 1 Dec 2011 14:10:15 +0800
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > On Wed, Nov 30, 2011 at 10:08:24AM +0800, Feng Tang wrote:
> > > > Hi Dmitry,
> > > > 
> > > > Thanks for the review.
> > > > 
> > > > On Tue, 29 Nov 2011 17:22:08 +0800
> > > > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > 
> > > > > Hi Feng,
> > > > > 
> > > > > On Tue, Nov 29, 2011 at 04:12:57PM +0800, Feng Tang wrote:
> > > > > > The TSC2007 data sheet say in some case the HW may fire some
> > > > > > false interrrupt, which I also met during integrating one
> > > > > > TSC2007 device. So add the disable_irq/enable_irq protection
> > > > > > around data handling.
> > > > > 
> > > > > IRQF_ONESHOT should prevent IRQ from firing again while
> > > > > thread is servicing it. Did you actually observe it not
> > > > > working?
> > > > 
> > > > You are right, the tsc's threaded IRQ function is not
> > > > re-entered, and the driver is working actually. My bad not
> > > > stating the problem clearly. The real problem I want solve is,
> > > > many platforms including ours use a GPIO line as the tsc2007's
> > > > IRQ line, and when these extra tsc2007 IRQ is triggered on the
> > > > gpio line, that GPIO controller will fire up extra noise IRQ
> > > > accordingly, causing its ISR to be called. And my patch is
> > > > trying to let the GPIO controller driver disable that specific
> > > > IRQ pin from tsc2007. As disable_irq will call GPIO irq_chip's
> > > > irq_disable() or mask() hook.
> > > 
> > > But ONESHOT interrupt handler will not unmask interrupt until
> > > thead finishes servicing it so we should not be seeing these
> > > extra IRQs. I'm adding Thomas in case I misunderstand how it
> > > threaded IRQ supposed to work.
> > 
> > I did see these extra IRQs. As the tsc2007 datasheet says, the
> > PENIRQ may be falsely triggered, and that signal is passed to the
> > GPIO controller, if the tsc2007 specific pin is not disabled in
> > GPIOC level, then the GPIOC HW will send out a IRQ anyway. 
> > 
> > While calling the disable_irq(), it will call the irq_chip's
> > (implemented by GPIO controller) irq_disable() or irq_mask() hook
> > to disable that specific line for tsc2007.
> > 
> > I did check the original tsc2007 driver, which used the
> > disable_irq/enable_irq too, which means this problem is a general
> > one and has been seen before.
> > 
> 
> No, the original had disable/enable IRQ because it was the only way to
> stop interrupt storm with combination of hard IRQ + workqueue or
> thread.

My understanding is, if the GPIO line used by tsc2007 is not disabled
in GPIO controller level, the GPIOC will always be triggered by tsc2007
to fire those extra interrupts.

Actually I did try the old version driver (no threaded irq version), which
will see the extra interrupts if the disable_irq/enable_irq is removed.

> 
> BTW, do you have it configured as level or edge interrupt?

I'm now using the falling edge trigger, but I tried the level trigger
which will have more interrupts storm.

Thanks,
Feng

> 
> > Or should we have a another flag in tsc2007 platform data, to let
> > each platform chose whether or not to use the disable/enable_irq
> > according to their platform need.
> > 
> > > 
> > > Also, there is clear_penirq() platform method that is called to
> > > clean penirq state, if needed.
> > 
> > Sadly we don't have a way to clear the irq from TSC2007 on our
> > platform :(
> >
> 
> Thanks.
> 
