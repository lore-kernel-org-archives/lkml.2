Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1HEIGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:06:46 -0400
Received: from trinity.fluff.org ([89.16.178.74]:53366 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab1HEIGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:06:43 -0400
Date: Fri, 5 Aug 2011 09:06:20 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] irq: If an IRQ is a GPIO, request and configure it
Message-ID: <20110805080620.GE28651@trinity.fluff.org>
References: <1312498820-2275-1-git-send-email-swarren@nvidia.com> <1312498820-2275-2-git-send-email-swarren@nvidia.com> <20110805000148.GB13321@opensource.wolfsonmicro.com> <74CDBE0F657A3D45AFBB94109FB122FF049F171EC1@HQMAIL01.nvidia.com> <20110805053510.GA16956@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805053510.GA16956@opensource.wolfsonmicro.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Aug 05, 2011 at 06:35:11AM +0100, Mark Brown wrote:
> On Thu, Aug 04, 2011 at 08:53:34PM -0700, Stephen Warren wrote:
> 
> > Well, things break. This is essentially the problem I was describing in
> > the PATCH 0 email, just with a slightly different motivation.
> 
> There's a bunch of existing code using that idiom.
> 
> > I suppose that an alternative here would be to simply ignore any errors
> > from gpio_request. This might have the benefit of removing the need for
> > the other two patches I posted in the series. However, it seems a little
> > dirty; one benefit of the IRQ code calling gpio_request and honoring
> > errors would be to detect when some completely unrelated code had a bug
> > and had called gpio_request on the GPIO before. Such detection would be
> > non-existent if we don't error out on gpio_request. Perhaps some mechanism
> > is needed to indicate that the driver has explicitly already called
> > gpio_request for a legitimate shared purpose, and only then ignore
> > errors?
> 
> But it's not a bug to use a GPIO as an IRQ source, otherwise we wouldn't
> have gpio_to_irq() in the first place.  Feels like we need a backchannel
> between gpiolib and the IRQ code to do this.  Or perhaps the drivers
> that implement this should be taking care of setting up the GPIO mode?

Converting GPIOs to IRQs is really useful. The reverse mapping is not as
easy, as when go NR->CHIP->to_irq() method, but the reverse is not being
tracked at the moment, which makes life difficult.

I would say that setting the interrupt should deal with all the necessary
configuration to get that interrupt working. In the case of pretty much all
of the SoCs I have been involved with have always set the GPIO's function
to allow the interrupt to pass through.

Whilst there's a case for having this being done either in the core IRQ
code (may break for everyone else) we could quite easily do this in the
GPIO driver.

As a note, we are actuallly trying to remove the irq_to_gpio() calls, as
they are not widely used across the kernel, very sparsely and badly
implemented across ARM and are very rarely used (the IIO system is the
only system currently doing this, for some fairly nasty reasons)

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

