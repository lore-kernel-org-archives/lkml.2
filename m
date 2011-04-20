Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1DTWRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 18:17:46 -0400
Received: from xes-mad.com ([216.165.139.218]:32344 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab1DTWRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 18:17:44 -0400
Subject: Re: [PATCH v5 2/4] gpiolib: Add ability to get GPIO direction
From: Peter Tyser <ptyser@xes-inc.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Alek Du <alek.du@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20110312091846.GJ9347@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
	 <1299022100-14564-2-git-send-email-ptyser@xes-inc.com>
	 <20110306073003.GA29325@angua.secretlab.ca>
	 <1299467241.11719.145.camel@ptyser-laptop>
	 <20110307070816.GC29999@angua.secretlab.ca>
	 <1299544729.6057.73.camel@petert>
	 <20110312091846.GJ9347@angua.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 17:17:07 -0500
Message-ID: <1303337827.13259.2914.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I don't object to a callback hook.  My objection is how it is bodged
> > > on to work around limitations to the direction being cached in the
> > > flags variable.  I want to see a solution that either depends entirely
> > > on the callback, or completely fixes the problems with the cached
> > > value by allowing the driver to update it.
> > 
> > I agree it'd be nice to have each driver implement a get_direction()
> > function and remove the FLAG_DIR_* flags altogether, but didn't want to
> > do the work to 20 drivers which I don't use...  Would you accept a
> > series that:
> > - Added "unknown" direction support (eg patch 1)
> > - Added ability to get GPIO direction (eg patch 2 in this series)
> > - Sequence of patches to add get_direction() to all GPIO drivers (most
> > of which I couldn't test).
> > - Replace checking of FLAG_DIR_* in gpiolib.c with calls to new
> > get_direction() function and remove FLAG_DIR_* flags all together.
> 
> Yes, this sounds perfect to me.

I had a chance to look into this today, but had some follow up questions
and comments.  There are a lot more GPIO drivers than expected...  How
do the 94 driver changes get tested and applied?  I can compile test the
common drivers in drivers/gpio and under arch/powerpc but I don't have
cross compile environments for other architectures and wading through
the config options to enable each driver would be very time consuming to
do manually.  I also can only run-test a handful of the changes.  Most
of the changes are pretty small and straightforward, but I likely missed
a semi-colon here, misspelled a define there, etc.

- Is there a kernel build test server that could be used to weed out any
compile issues?

- Should I post the patches to a website and email each driver's
maintainer for an ACK?  Spamming the lkml with 100 trivial patches seems
like a bad idea.

- If the last patch "gpiolib: Get rid of direction flag" isn't applied,
all drivers would maintain their current functionality as a fallback,
which means the 94 driver-specific changes wouldn't need to be applied
right away.

Any input on how to proceed would be appreciated.  Below is a list of
how the patches are broken up:


gpiolib: Add gpio_get_direction()
    
Consolidate direction detection into one function which is globally
visible.  A GPIO's direction is currently still stored in as an
input/output flag, but this change lays the groundwork to allow GPIO
chips to accurately report their direction in realtime.

The new gpio_get_direction() function returns GPIOF_DIR_IN,
GPIOF_DIR_OUT, or a negative errno if the direction can't be determined.

---

gpiolib: Add chip->get_direction() support

Add a new get_direction() function to the gpio_chip structure.  This is
useful so that the direction of a GPIO can always be acurately
determined.  Previously incorrect directions could be reported prior
to explicitly setting a GPIO's direction, or if its direction was
changed elsewhere, eg in platform code.

At this point it is optional for a chip driver to implement
get_direction().  If get_direction() is not implemented for a GPIO, the
previous method of using a software cached direction will be utilized to
determine its direction.

---

gpio: tnetv107x: Add get_direction()
gpio: scoop: Add get_direction()
gpio: at91: Add get_direction()
gpio: via: Add get_direction()
gpio: max3107: Add get_direction()
gpio: pfc: Add get_direction()
gpio: intel_pmic: Add get_direction()
gpio: ucb1x00: Add get_direction()
gpio: tps65010: Add get_direction()
gpio: tc6393xb: Add get_direction()
gpio: davinci: Add get_direction()
gpio: ep93xx: Add get_direction()
gpio: gemini: Add get_direction()
gpio: ks8695: Add get_direction()
gpio: lpc32xx: Add get_direction()
gpio: msm/trout: Add get_direction()
gpio: msm/gpio-v2: Add get_direction()
gpio: msm/gpio: Add get_direction()
gpio: mxs/gpio: Add get_direction()
gpio: s5p64x0: Add get_direction()
gpio: sa1100: Add get_direction()
gpio: tegra: Add get_direction()
gpio: w90x900: Add get_direction()
gpio: iop: Add get_direction()
gpio: mxc: Add get_direction()
gpio: nomadik: Add get_direction()
gpio: omap: Add get_direction()
gpio: orion: Add get_direction()
gpio: pxa: Add get_direction()
gpio: samsung gpio: Add get_direction()
gpio: samsung gpiolib: Add get_direction()
gpio: stmp3xxx: Add get_direction()
gpio: at32ap: Add get_direction()
gpio: bfin: Add get_direction()
gpio: bf538: Add get_direction()
gpio: coldfire: Add get_direction()
gpio: au1000: Add get_direction()
gpio: ar7: Add get_direction()
gpio: ath79: Add get_direction()
gpio: bcm63xx: Add get_direction()
gpio: jz4740: Add get_direction()
gpio: txx9: Add get_direction()
gpio: loongson: Add get_direction()
gpio: msp71xx: Add get_direction()
gpio: msp71xx-ext: Add get_direction()
gpio: rb532: Add get_direction()
gpio: mpc52xx_gpio: Add get_direction()
gpio: mpc52xx_gpt: Add get_direction()
gpio: gef_gpio: Add get_direction()
gpio: cpm1: Add get_direction()
gpio: cpm_common: Add get_direction()
gpio: mpc8xxx_gpio: Add get_direction()
gpio: ppc4xx_gpio: Add get_direction()
gpio: qe: Add get_direction()
gpio: simple_gpio: Add get_direction()
gpio: s6000: Add get_direction()
gpio: adp5520: Add get_direction()
gpio: adp5588: Add get_direction()
gpio: basic_mmio: Add get_direction()
gpio: bt8xx: Add get_direction()
gpio: cs5535: Add get_direction()
gpio: ichx_gpio: Add get_direction()
gpio: it8761e: Add get_direction()
gpio: langwell: Add get_direction()
gpio: max730x: Add get_direction()
gpio: max732x: Add get_direction()
gpio: mcp23s08: Add get_direction()
gpio: ml_ioh: Add get_direction()
gpio: pca953x: Add get_direction()
gpio: pcf857x: Add get_direction()
gpio: pch: Add get_direction()
gpio: pl061: Add get_direction()
gpio: rdc321x: Add get_direction()
gpio: sch: Add get_direction()
gpio: stmpe: Add get_direction()
gpio: sx150x: Add get_direction()
gpio: tc3589x: Add get_direction()
gpio: timbgpio: Add get_direction()
gpio: twl4030: Add get_direction()
gpio: ucb1400: Add get_direction()
gpio: vr41xx_giu: Add get_direction()
gpio: vx855: Add get_direction()
gpio: wm831x: Add get_direction()
gpio: wm8350: Add get_direction()
gpio: wm8994: Add get_direction()
gpio: xilinx: Add get_direction()
gpio: adp5588-keys: Add get_direction()
gpio: ad7879: Add get_direction()
gpio: asic3: Add get_direction()
gpio: dm355evm_msp: Add get_direction()
gpio: htc-egpio: Add get_direction()
gpio: htc-i2cpld: Add get_direction()
gpio: sm501: Add get_direction()

gpiolib: Get rid of direction flag
    
Previously gpiolib used a cached flag (FLAG_IS_OUT) which was used to
determine the direction of a given GPIO.  There were a few shortcomings
of this method:
 - The initial direction of a GPIO could not be determined and was often
   incorrectly reported for GPIOs exported via sysfs.

 - If platform code changed the direction of a GPIO its flag would not be
   updated and would contain false information.
    
The updated logic to determine a GPIO's direction is now:
 - If possible, call the GPIO chip driver's get_direction() function to
   dynamically determine pin direction.
    
 - Else try and determine the direction of the pin based on the
   presence/lack of the GPIO chip driver's direction_output() and
   direction_input() functions.
    
 - Else report an invalid/unknown GPIO direction.  A GPIO that reports
   an unknown direction can stil be used like a normal GPIO, but its
   current direction can't be determined.
    
If a GPIO chip will be exported via sysfs it is highly recommended that
the chip driver implement get_direction() as some of the sysfs
functionality relies on being able to determine a GPIO's direction.


