Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539Ab2B1R0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:26:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6863 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2B1R0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:26:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 28 Feb 2012 09:26:23 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 28 Feb 2012 09:26:22 -0800
Subject: RE: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT, define
 hogs as that state
Thread-Topic: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT,
 define hogs as that state
Thread-Index: Acz1+ri+BoFZxDwgTG26gRW2N6WcrAAQd9+w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF1D61@HQMAIL01.nvidia.com>
References: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
 <20120228093015.GC1249@shlinux2.ap.freescale.net>
In-Reply-To: <20120228093015.GC1249@shlinux2.ap.freescale.net>
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

Dong Aisheng wrote at Tuesday, February 28, 2012 2:30 AM:
> On Mon, Feb 27, 2012 at 04:55:08PM -0700, Stephen Warren wrote:
> > This provides a single centralized name for the default state.
> >
> > Update PIN_MAP_* macros to use this state name, instead of requiring the
> > user to pass a state name in.
...

> > diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt

> >  static struct pinctrl_map __initdata mapping[] = {
> > -       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
> > +	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
>
> It seemed Linus already applied your "re-order struct pinctrl_map".
> This may need change a bit according to that patch.

Yes, that patch is applied.

However, note that I deliberately did not change PIN_MAP()'s parameter
order in that patch. I deferred as much rework of those macros to the
later patch "pinctrl: Enhance mapping table to support pin config
operations" to avoid repeatedly changing those macros where possible.

For reference, the definition of PIN_MAP() at this point in the series
is:

#define PIN_MAP(a, b, c, d) \
        { .name = a, .ctrl_dev_name = b, .function = c, .dev_name = d }


> > @@ -989,7 +989,7 @@ of the pin controller itself, like this:
> >
> >  {
> >  	.dev_name = "pinctrl-foo",
> > -	.name = "POWERMAP"
> > +	.name = PINCTRL_STATE_DEFAULT,
> >  	.ctrl_dev_name = "pinctrl-foo",
> >  	.function = "power_func",
> >  },
>
> ditto

That already matches the order of fields in the struct definition,
which for reference is as follows at this point in the series:

struct pinctrl_map {
        const char *dev_name;
        const char *name;
        const char *ctrl_dev_name;
        const char *function;
        const char *group;
};

(.group is still allowed to be NULL)

> > @@ -1078,8 +944,6 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
> >  			    device_root, pctldev, &pinctrl_groups_ops);
> >  	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
> >  			    device_root, pctldev, &pinctrl_gpioranges_ops);
> > -	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
> > -			    device_root, pctldev, &pinmux_hogs_ops);
>
> I see you remove the pinnmux-hogs sysfs file here.
> I guess you may want to merge it into pinctrl-maps sysfs file since
> they're almost same(only difference is device name).
> 
> Do you think if we can add a special flag for that type of map in sysfs
> (e.g. a "Hog" flag behind the regular map debug info)?
> Then users do not need to check device's name to see if it's a hogged function.
> 
> (Anyway, it should be in another patch)

I'd rather not myself; I don't see why "hog" should be a special-case;
it's just that the pin controller driver's mapping table entries have
it set up certain pin mux/config settings.

That said, feel free to submit a patch for this. I'd prefer that any
text you add to the debugfs files to indicate this "hogging" be in
addition to anything that's already present rather than replacing it
(as has unfortunately happened already in "pinmux-pins"), otherwise
it obscures information.

> > diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> > index 73fbb27..20e9735 100644
> > --- a/include/linux/pinctrl/machine.h
> > +++ b/include/linux/pinctrl/machine.h
> > @@ -12,6 +12,8 @@
> >  #ifndef __LINUX_PINCTRL_MACHINE_H
> >  #define __LINUX_PINCTRL_MACHINE_H
> >
> > +#include "pinctrl.h"
> > +
> >  /**
> >   * struct pinctrl_map - boards/machines shall provide this map for devices
> >   * @dev_name: the name of the device using this specific mapping, the name
> > @@ -49,17 +51,18 @@ struct pinctrl_map {
> >   * Convenience macro to map a system function onto a certain pinctrl device,
> >   * to be hogged by the pin control core until the system shuts down.
> >   */
> > -#define PIN_MAP_SYS_HOG(a, b, c) \
> > -	{ .name = a, .ctrl_dev_name = b, .dev_name = b, .function = c, }
> > +#define PIN_MAP_SYS_HOG(a, b) \
> > +	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
> > +	  .function = b, }
> >
> >  /*
> >   * Convenience macro to map a system function onto a certain pinctrl device
> >   * using a specified group, to be hogged by the pin control core until the
> >   * system shuts down.
> >   */
> > -#define PIN_MAP_SYS_HOG_GROUP(a, b, c, d)		\
> > -	{ .name = a, .ctrl_dev_name = b, .dev_name = b, .function = c, \
> > -	  .group = d, }
> > +#define PIN_MAP_SYS_HOG_GROUP(a, b, c) \
> > +	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
> > +	  .function = b, .group = c, }
> >
> 
> In your v1 patch, we discussed about the possible requirement of different state
> support for hog functions(it seemed still no conclusion, right?).

I agreed to fully support that. However as I mentioned, the support will be
actually implemented in patch "pinctrl: Enhance mapping table to support
pin config operations" since I was already reworking all the mapping
table macros there, it felt better to do the rework once in that patch.

I'm waiting on resolution of the locking patch issue before I repost an
updated version of the mapping table rework patch that includes this
support.

> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Thanks.

-- 
nvpublic

