Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab1I3NhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:37:04 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63305 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1I3NhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110930021239.GL12606@ponder.secretlab.ca>
References: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
	<20110930021239.GL12606@ponder.secretlab.ca>
Date: Fri, 30 Sep 2011 15:37:01 +0200
Message-ID: <CACRpkdameaz=Ys1A5XAxTN=+zdKQhpkJao57BbYc38uF5wWVHw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 4:12 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

>>  config MACH_U300
>>       bool "U300"
>> +     select PINCTRL
>> +     select PINMUX_U300
>
> Shouldn't PINMUX_U300 select PINCTRL?

It selects PINMUX which is inside the if-clause for the
subsystem:

if PINCTRL

config PINMUX
	bool "Support pinmux controllers"
(...)

config PINMUX_U300
	bool "U300 pinmux driver"
	depends on ARCH_U300
	select PINMUX
(...)

endif

Having PINMUX or PINMUX_U300 select PINCTRL doesn'
work because it is deemed a circular dependency (indeed).
And Kconfig apparently does not resolve dependencies like
this, so it says:

# CONFIG_PINCTRL is not set
CONFIG_PINMUX_U300=y

And:

warning: (MACH_U300) selects PINMUX_U300 which has unmet direct
dependencies (PINCTRL && ARCH_U300)
warning: (MACH_U300) selects PINMUX_U300 which has unmet direct
dependencies (PINCTRL && ARCH_U300)

And then it breaks in the compile.

Actually the same thing seems to go for say this:

select ARCH_REQUIRE_GPIOLIB
select GPIO_FOO

You have to select both from your machine to get that driver,
just selecting GPIO_FOO is unable to auto-select GPIOLIB.

If you like this design pattern I can introduce

ARCH_REQUIRE_PINCTRL

In the same style as GPIOLIB, but it looks a bit
superfluous to me, select PINCTRL should be
fine?

>> +#include "pinmux-u300.h"
>
> There is only one file that uses this header data.  Just put it into
> the .c file.

OK!

>> +static int __init u300_pmx_probe(struct platform_device *pdev)
>> +{
>> +     int ret;
>> +     struct u300_pmx *upmx;
>> +     struct resource *res;
>> +
>> +     /* Create state holders etc for this driver */
>> +     upmx = kzalloc(sizeof(struct u300_pmx), GFP_KERNEL);
>
> devm_kzalloc()

OK, replaced kfree() with devm_kfree() too for consistency.

>> +static int __exit u300_pmx_remove(struct platform_device *pdev)
> __devexit
(...)
>> +     .remove = __exit_p(u300_pmx_remove),
> __devexit_p

But notice, no .probe member and:

>> static int __init u300_pmx_init(void)
>> {
>>        return platform_driver_probe(&u300_pmx_driver, u300_pmx_probe);
>> }

See drivers/base/platform.c:platform_driver_probe():

/**
 * platform_driver_probe - register driver for non-hotpluggable device
 * @drv: platform driver structure
 * @probe: the driver probe routine, probably from an __init section
 *
 * Use this instead of platform_driver_register() when you know the device
 * is not hotpluggable and has already been registered, and you want to
 * remove its run-once probe() infrastructure from memory after the driver
 * has bound to the device.
 *
 * One typical use for this would be with drivers for controllers integrated
 * into system-on-chip processors, where the controller devices have been
 * configured as part of board setup.

This driver won't ever load as a module, and new ones will never be
discovered after boot.

So I kind of like it that way...

Yours,
Linus Walleij
