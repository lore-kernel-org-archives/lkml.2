Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030402Ab2B2CZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:25:30 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:41074 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757567Ab2B2CZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:25:28 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1454I146fK1432N98dKa706lzz1202hzz8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 29 Feb 2012 10:31:25 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] pinctrl: Introduce PINCTRL_STATE_DEFAULT,
 define hogs as that state
Message-ID: <20120229023124.GB3816@shlinux2.ap.freescale.net>
References: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
 <20120228093015.GC1249@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BDDF1D61@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF1D61@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 09:26:22AM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Tuesday, February 28, 2012 2:30 AM:
> > On Mon, Feb 27, 2012 at 04:55:08PM -0700, Stephen Warren wrote:
> > > This provides a single centralized name for the default state.
> > >
> > > Update PIN_MAP_* macros to use this state name, instead of requiring the
> > > user to pass a state name in.
> ...
> 
> > > diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> 
> > >  static struct pinctrl_map __initdata mapping[] = {
> > > -       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
> > > +	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
> >
> > It seemed Linus already applied your "re-order struct pinctrl_map".
> > This may need change a bit according to that patch.
> 
> Yes, that patch is applied.
> 
> However, note that I deliberately did not change PIN_MAP()'s parameter
> order in that patch. I deferred as much rework of those macros to the
> later patch "pinctrl: Enhance mapping table to support pin config
> operations" to avoid repeatedly changing those macros where possible.
> 
> For reference, the definition of PIN_MAP() at this point in the series
> is:
> 
> #define PIN_MAP(a, b, c, d) \
>         { .name = a, .ctrl_dev_name = b, .function = c, .dev_name = d }
> 
Ok, i see.

> (.group is still allowed to be NULL)
> 
> > > @@ -1078,8 +944,6 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
> > >  			    device_root, pctldev, &pinctrl_groups_ops);
> > >  	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
> > >  			    device_root, pctldev, &pinctrl_gpioranges_ops);
> > > -	debugfs_create_file("pinmux-hogs", S_IFREG | S_IRUGO,
> > > -			    device_root, pctldev, &pinmux_hogs_ops);
> >
> > I see you remove the pinnmux-hogs sysfs file here.
> > I guess you may want to merge it into pinctrl-maps sysfs file since
> > they're almost same(only difference is device name).
> > 
> > Do you think if we can add a special flag for that type of map in sysfs
> > (e.g. a "Hog" flag behind the regular map debug info)?
> > Then users do not need to check device's name to see if it's a hogged function.
> > 
> > (Anyway, it should be in another patch)
> 
> I'd rather not myself; I don't see why "hog" should be a special-case;
> it's just that the pin controller driver's mapping table entries have
> it set up certain pin mux/config settings.
> 
> That said, feel free to submit a patch for this. I'd prefer that any
> text you add to the debugfs files to indicate this "hogging" be in
> addition to anything that's already present rather than replacing it
> (as has unfortunately happened already in "pinmux-pins"), otherwise
> it obscures information.
> 
Yes, correct.

> > > diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> > > index 73fbb27..20e9735 100644
> > > --- a/include/linux/pinctrl/machine.h
> > > +++ b/include/linux/pinctrl/machine.h
> > > @@ -12,6 +12,8 @@
> > >  #ifndef __LINUX_PINCTRL_MACHINE_H
> > >  #define __LINUX_PINCTRL_MACHINE_H
> > >
> > > +#include "pinctrl.h"
> > > +
> > >  /**
> > >   * struct pinctrl_map - boards/machines shall provide this map for devices
> > >   * @dev_name: the name of the device using this specific mapping, the name
> > > @@ -49,17 +51,18 @@ struct pinctrl_map {
> > >   * Convenience macro to map a system function onto a certain pinctrl device,
> > >   * to be hogged by the pin control core until the system shuts down.
> > >   */
> > > -#define PIN_MAP_SYS_HOG(a, b, c) \
> > > -	{ .name = a, .ctrl_dev_name = b, .dev_name = b, .function = c, }
> > > +#define PIN_MAP_SYS_HOG(a, b) \
> > > +	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
> > > +	  .function = b, }
> > >
> > >  /*
> > >   * Convenience macro to map a system function onto a certain pinctrl device
> > >   * using a specified group, to be hogged by the pin control core until the
> > >   * system shuts down.
> > >   */
> > > -#define PIN_MAP_SYS_HOG_GROUP(a, b, c, d)		\
> > > -	{ .name = a, .ctrl_dev_name = b, .dev_name = b, .function = c, \
> > > -	  .group = d, }
> > > +#define PIN_MAP_SYS_HOG_GROUP(a, b, c) \
> > > +	{ .name = PINCTRL_STATE_DEFAULT, .ctrl_dev_name = a, .dev_name = a, \
> > > +	  .function = b, .group = c, }
> > >
> > 
> > In your v1 patch, we discussed about the possible requirement of different state
> > support for hog functions(it seemed still no conclusion, right?).
> 
> I agreed to fully support that. However as I mentioned, the support will be
Great.

> actually implemented in patch "pinctrl: Enhance mapping table to support
> pin config operations" since I was already reworking all the mapping
> table macros there, it felt better to do the rework once in that patch.
> 
Reasonable to me.

> I'm waiting on resolution of the locking patch issue before I repost an
> updated version of the mapping table rework patch that includes this
> support.
> 
Sounds good.

> > Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> 

Regards
Dong Aisheng

