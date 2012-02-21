Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2BUNDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:03:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40323 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab2BUNC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:02:59 -0500
Date: Tue, 21 Feb 2012 13:02:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, linux-doc@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Documentation/gpio.txt: Explain expected pinctrl
	interaction
Message-ID: <20120221130227.GA26999@n2100.arm.linux.org.uk>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com> <20120220073941.GC22562@n2100.arm.linux.org.uk> <CACRpkdbMFN3=XTSg1oE310eTHecrs6XaMz+DCNYJzwOg8JEEiQ@mail.gmail.com> <20120221110618.GJ22562@n2100.arm.linux.org.uk> <CACRpkdYzRu4VPKPgxuttuvSDCpfHjvBGGq1rFEDExv1PsoLG=w@mail.gmail.com> <20120221124409.GL22562@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221124409.GL22562@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 12:44:09PM +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 21, 2012 at 01:40:05PM +0100, Linus Walleij wrote:
> > Of course it assumes the SA1100 being converted to use pin control,
> > I looked at it a bit and it seems simple enough since the GAFR
> > register is a single "GPIO or something else"-switch for the GPIOs.
> > (It'd probably need the SA1100 to be a bit more strict in using
> > gpiolib in place for the direct assignments though, else the
> > abstractions get a bit pointless anyway.)
> 
> That's mostly happened through my recent set of 100 or so patches.
> There's a few areas where that's not quite as easy as it should be,
> but on the whole, it's mostly complete.
> 
> The other thing I forgot to mention, and I suspect it's particular to
> SA11x0, is that the GPDR must be set correctly according to the special
> function as well as GAFR.  So, if a special function involves driving
> a pin, the pin must be set as an output in GPDR.  Conversely, if the
> special function involves input only, the pin must be set as an input
> in GPDR.
> 
> So, on SA11x0, gpio and pin configuration are intimately linked.

I should have added - the only places which directly accesses one of the
GPDR/GPSR/GPCR registers are:

drivers/pcmcia/sa1100_shannon.c:        unsigned long levels = GPLR;
drivers/video/sa1100fb.c:           GPDR |= mask;
drivers/input/touchscreen/jornada720_ts.c:      if (GPLR & GPIO_GPIO(9)) {
drivers/input/touchscreen/h3600_ts_input.c:     int down = (GPLR & GPIO_BITSY_ACTION_BUTTON) ? 0 : 1;
drivers/input/touchscreen/h3600_ts_input.c:     int down = (GPLR & GPIO_BITSY_NPOWER_BUTTON) ? 0 : 1;

The shannon thing looks like a bug in my PCMCIA patch series - as soc_common
now deals with GPIOs itself (which I've now fixed.)

The sa1100fb thing is a case of what I described above (correctly
configuring the direction for the pins for the special function in use.)

The touchscreen stuff needs someone who knows that stuff to fix it -
I think the jornada folk have been around recently so maybe they can
look at their driver.

The h3600 ts stuff also looks fairly easy to convert to gpiolib if
someone has the time.  Again, maybe if there's an interested party
with a device that they could test, it could happen.

All other cases of direct GPDR/GPLR/GPSR/GPCR access are in platform
initialization code in arch/arm/mach-sa1100.  So, we're actually very
close to having sa11x0 fully converted to gpiolib.
