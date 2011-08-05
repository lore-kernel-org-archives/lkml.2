Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab1HEPpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:45:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2017 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1HEPpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:45:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 05 Aug 2011 08:43:22 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 5 Aug 2011 08:43:20 -0700
Subject: RE: [RFC PATCH 0/3] If an IRQ is a GPIO, request and configure it
Thread-Topic: [RFC PATCH 0/3] If an IRQ is a GPIO, request and configure it
Thread-Index: AcxTU7kZTJWJ/R7oSDW3pBB/bX5AAAAMT1JQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049F171EFC@HQMAIL01.nvidia.com>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com>
 <20110805094017.GC20575@n2100.arm.linux.org.uk>
In-Reply-To: <20110805094017.GC20575@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote at Friday, August 05, 2011 3:40 AM:
> On Thu, Aug 04, 2011 at 05:00:17PM -0600, Stephen Warren wrote:
> > In http://www.spinics.net/lists/linux-tegra/msg01731.html, Mark Brown
> > pointed out that it was a little silly forcing every board or driver
> > to gpio_request() a GPIO that is later converted to an IRQ, and passed
> > to request_irq. The first patch in this series instead makes the core
> > IRQ code perform these calls when appropriate, to avoid duplicating it
> > everywhere.
> 
> Trying to go from IRQ to GPIO is not a good idea - most of the
> IRQ <-> GPIO macros we have today are just plain broken.  Many of them
> just add or subtract a constant, which means non-GPIO IRQs have an
> apparant GPIO number too.  Couple this with the fact that all positive
> GPIO numbers are valid, and this is a recipe for wrong GPIOs getting
> used and GPIOs being requested for non-GPIO IRQs.
> 
> I think this was also discussed in the past, and the conclusion was that
> IRQs should be kept separate from GPIOs.  Maybe views have changed since
> then...
> 
> However, if we do want to do this, then it would be much better to provide
> a new API for requesting GPIO IRQs, eg:
> 
> gpio_request_irq()
> 
> which would wrap around request_threaded_irq(), takes a GPIO number,
> does the GPIO->IRQ conversion internally, and whatever GPIO setup is
> required.  Something like this:

With that approach, drivers need to explicitly know whether they're
passed a GPIO or an IRQ, and do something different, or they need to
choose to only accept a GPIO or IRQ.

Take the case of the WM8903 audio codec, which is the case I was primarily
motivated by.

The struct i2c_board_info for the WM8903 contains a .irq field, which is
already an IRQ number. This IRQ might be a plain IRQ (i.e. a dedicated
interrupt pin on the SoC's package), or a pin that's a GPIO with interrupt
capabilities.

It'd be best if the WM8903 driver could handle either case, and be
Completely unaware of which case was used in practice; it simply wants to
request the interrupt, and have that work appropriately.

Having a separate API for this means pushing this GPIO-vs-IRQ knowledge
into all drivers, which doesn't seem like a good thing.

So it seems like, as was mentioned elsewhere in this thread, the upshot of
this conversation is that interrupt chip drivers should do this internally,
both to avoid requiring a general irq_to_gpio function, and because calling
gpio_direction_input for GPIOs-used-as-IRQs isn't appropriate for all
hardware.

> int gpio_request_threaded_irq(int gpio, irq_handler_t handler,
> 	irq_handler_t thread_fn, unsigned long flags, const char *name,
> 	void *dev)
...

-- 
nvpublic

