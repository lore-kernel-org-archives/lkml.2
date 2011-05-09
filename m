Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab1EIUuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:50:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33617 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1EIUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:50:20 -0400
Date: Mon, 9 May 2011 21:50:15 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCHv3] x86, mrst: share APB timer code with other platforms
Message-ID: <20110509205015.GA3341@pulham.picochip.com>
References: <1302606630-12459-1-git-send-email-jamie@jamieiles.com>
 <1304972542.2939.20.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304972542.2939.20.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 01:22:22PM -0700, john stultz wrote:
> On Tue, 2011-04-12 at 12:10 +0100, Jamie Iles wrote:
> > The APB timers are an IP block from Synopsys (DesignWare APB timers)
> > and are also found in other systems including ARM SoC's.  This patch
> > adds functions for creating clock_event_devices and clocksources from
> > APB timers but does not do the resource allocation.  This is handled
> > in a higher layer to allow the timers to be created from multiple
> > methods such as platform_devices.
> > 
> > Changes since v2:
> > 	- Make eoi() for clock_event_device optional for x86 where eoi
> > 	is handled in firmware.
> > Changes since v1:
> > 	- Use the correct timer for clocksource on x86
> > 	- Select the correct timer rating for x86
> > 	- Restore freerunning timer behaviour for oneshot event devices
> > 	- Reenable event irq correctly for hotplug
> 
> Sorry for being slow to review this.

No worries, appreciate the review.

> Just a minor nit below.
> 
> > +struct dw_apb_clocksource *
> > +dw_apb_clocksource_init(unsigned rating, char *name, void __iomem *base,
> > +			unsigned long freq)
> > +{
> > +	struct dw_apb_clocksource *dw_cs = kzalloc(sizeof(*dw_cs), GFP_KERNEL);
> > +
> > +	if (!dw_cs)
> > +		return NULL;
> > +
> > +	dw_cs->timer.base = base;
> > +	dw_cs->timer.freq = freq;
> > +	dw_cs->cs.name = name;
> > +	dw_cs->cs.rating = rating;
> > +	dw_cs->cs.read = __apbt_read_clocksource;
> > +	dw_cs->cs.mask = CLOCKSOURCE_MASK(32);
> > +	dw_cs->cs.flags = CLOCK_SOURCE_IS_CONTINUOUS;
> > +	dw_cs->cs.resume = apbt_restart_clocksource;
> > +
> > +	return dw_cs;
> > +}
> 
> So I don't see anything that frees the dw_apb_clocksource structure
> after it has been allocated. Should this instead be allocated by the
> caller and passed in to be initialized here?

Yeah, either that or I could add a dw_apb_clocksource_remove() that does 
the clocksource_unregister() and kfree().  That's probably a little more 
consistent with the rest of the driver.

Jamie
