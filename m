Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab1CaTTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:19:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:30014 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759135Ab1CaTTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:19:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,277,1299484800"; 
   d="scan'208";a="904180089"
Date: Thu, 31 Mar 2011 12:19:05 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] clocksource: clocksource/clockevent driver for Synopsys
 dw_apb_timer
Message-ID: <20110331121905.0d8bf325@jacob-laptop>
In-Reply-To: <20110331174247.GE3371@pulham.picochip.com>
References: <1301584372-26261-1-git-send-email-jamie@jamieiles.com>
	<alpine.LFD.2.00.1103311719420.22418@localhost6.localdomain6>
	<20110331095051.7933c7b9@jacob-laptop>
	<20110331174247.GE3371@pulham.picochip.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 18:42:47 +0100
Jamie Iles <jamie@jamieiles.com> wrote:

> On Thu, Mar 31, 2011 at 09:50:51AM -0700, jacob pan wrote:
> > On Thu, 31 Mar 2011 17:33:12 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Thu, 31 Mar 2011, Jamie Iles wrote:
> > > 
> > > > This patch adds a driver for the Synopsys DesignWare APB timer
> > > > block found in some ARM systems.  This uses the timers with an
> > > > IRQ as a clockevents device and a timer without an IRQ as a
> > > > clocksource device.
> > > 
> > > Interesting. That's probably the same thing as:
> > > 
> > >      arch/x86/kernel/apb_timer.c
> > > 
> > > So if we merge that thing, then we should make sure, that we can
> > > replace the x86 one with it.
> > > 
> > It seems we have room to consolidate, here is my 2c:
> > 1. need to support multiple timer channels
> > 2. support percpu clockevent, need to deal with cpu online/offline
> > 3. early boot needs. I don't know if abp timer is needed for
> > booting on ARM platforms. But for Moorestown, we need timer before
> > platform bus running. So I guess we cannot enumerate the timer as
> > platform device.
> 
> ARM does need it quite early to calibrate the delay loop but I've
> been registering it early by creating an early_platform_device.  The
> other difference is that x86 doesn't support the clk API.
> 
> How about factoring out the clockevent and clocksource operations 
> (.set_next_event, .set_mode, .read etc) and the bits that actually
> drive the hardware into an apb_timer.c then have stuff that does
> platform device registration or langwell specific stuff in a higher
> layer?
> 
I agree to extract out hardware access bits. how about also include a
common allocation/reservation mechanism for apbt timer channels. i
guess we have to stay with device specific bits. e.g.
struct apbt_dev {
	int irq;
	__iomem *base;
	int channel_id;
	unsigned int flags; /* for possible platform quirks */
};
The allocation should also allow hints or specific request a specific
timer. Our platform has hardcoded usage of timer channels.

Can you be more specific about "higher layer"?, my guess is that you
meant platform code or drivers that uses apb timer. So arch specific
timer code can alloc apb timer and combine with things that is
appropriate for their platform. e.g. clk api.


> It looks like arch/x86/kernel/apb_timer.c would still need some lower 
> level access to the timers for doing things like the calibration in 
> apbt_quick_calibrate() before registering the clocksource.
yeah, we still need some early access. perhaps by-pass the clocksource
as an exception. I don't have a better idea at the moment.
