Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1CPTyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:54:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40716 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1CPTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:54:49 -0400
Date: Wed, 16 Mar 2011 13:54:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 3/6] gpio: pm8xxx-gpio: Add pm8xxx gpio
 driver
Message-ID: <20110316195444.GB4000@angua.secretlab.ca>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org>
 <1299564590-30116-4-git-send-email-adharmap@codeaurora.org>
 <20110312093645.GL9347@angua.secretlab.ca>
 <4D810797.4090000@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D810797.4090000@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 11:55:19AM -0700, Abhijeet Dharmapurikar wrote:
> 
> >>
> >>diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> >>index 664660e..c5e6f51 100644
> >>--- a/drivers/gpio/Kconfig
> >>+++ b/drivers/gpio/Kconfig
> >>@@ -411,4 +411,14 @@ config GPIO_JANZ_TTL
> >> 	  This driver provides support for driving the pins in output
> >> 	  mode only. Input mode is not supported.
> >>+comment "SSBI GPIO expanders:"
> >
> >SSBI?  Also, the comment seems rather out of place when there
> >currently appears to only be one of such devices.
> 
> SSBI is a bus architecture used to access this device's register
> (actually this is a subdevice in the pmic and ssbi is used to access
> all the registers in the pmic).The bus driver can be found here
> https://patchwork.kernel.org/patch/601771/
> 
> It didnt occur to me that the comment is only meant for buses which
> have more than one gpio devices. I saw
> comment "MODULbus GPIO expanders:"
> comment "AC97 GPIO expanders:"
> both containing single devices and thought it is a norm to add a
> comment  if a device running on a new bus is introduced.
> 
> Let me know if you still think I should remove
> comment "SSBI GPIO expanders:" ?

Yes, remove the comment.  I'll probably also remove the comment for
MODULbus and AC97.

g.

> 
> >>+
> >>+struct pm_gpio_chip {
> >>+	struct list_head	link;
> >>+	struct gpio_chip	gpio_chip;
> >>+	struct mutex		pm_lock;
> >>+	u8			*bank1;
> >>+	int			irq_base;
> >>+};
> >>+
> >>+static LIST_HEAD(pm_gpio_chips);
> >
> >Looks like you need a mutex for protecting this list from mutual access.
> 
> Yes will fix this.
> 
> >
> >>+
> 
> >>+#ifndef __PM8XXX_GPIO_H
> >>+#define __PM8XXX_GPIO_H
> >>+
> >>+#include <linux/errno.h>
> >>+
> >>+#define PM8XXX_GPIO_DEV_NAME	"pm8xxx-gpio"
> >>+
> >>+struct pm8xxx_gpio_core_data {
> >>+	u32	rev;
> >>+	int	ngpios;
> >>+};
> >>+
> >>+struct pm8xxx_gpio_platform_data {
> >>+	struct pm8xxx_gpio_core_data	gpio_cdata;
> >>+	int				gpio_base;
> >>+};
> >
> >There doesn't seem to be any value it splitting pm8xxx_gpio_core_data
> >into a separate structure from what I see in this patch.  How is this
> >going to be used?
> 
> gpio_base comes from the platform data because the board file knows
> where in the global gpio numbers the pm8xxx gpio start. For example
> if the MSM code supports 150 gpios(0 through 149), the board file
> will set gpio_base to indicate pm8xxx gpios should start from 150.
> 
> The pm8xxx_gpio_core_data is meant to be filled in by the pm8921
> core. We have different pmic chips with similar gpio
> implementations. For example 8058 pmic, 8901 pmic and 8921 pmic, all
> have the same gpio implementation but different number of gpio
> lines. The pm8xxx-gpio.c is used for all these pmics. Hence we
> separated core specific gpio information (number of gpio lines
> supported) from board specific gpio information (where in the global
> map the gpio number for this device starts).

I could see the argument if multiple pm8xxx instances pointed to a
single pm8xxx_gpio_core_data structure, but in this case it is simply
encapsulated.  Personally I'd just drop the extra structure.

g.

