Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2CBDlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 22:41:25 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:59213
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752939Ab2CBDlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 22:41:23 -0500
X-SpamScore: -13
X-BigFish: VS-13(zz9371I146fK1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 2 Mar 2012 11:46:46 +0800
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
Subject: Re: [PATCH V2 5/6] pinctrl: Enhance mapping table to support pin
 config operations
Message-ID: <20120302034645.GA19342@shlinux2.ap.freescale.net>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
 <1330460852-23486-6-git-send-email-swarren@nvidia.com>
 <20120301084617.GB14703@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BE86167D@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE86167D@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 08:52:12AM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Thursday, March 01, 2012 1:46 AM:
> > On Tue, Feb 28, 2012 at 01:27:31PM -0700, Stephen Warren wrote:
...
> > >  This gives the exact same result as the above construction.
> > >
> > > diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
> > > index 18973ca..c965bb5 100644
> > > --- a/arch/arm/mach-u300/core.c
> > > +++ b/arch/arm/mach-u300/core.c
> > > @@ -1569,13 +1569,13 @@ static struct platform_device dma_device = {
> > >  /* Pinmux settings */
> > >  static struct pinctrl_map __initdata u300_pinmux_map[] = {
> > >  	/* anonymous maps for chip power and EMIFs */
> > > -	PIN_MAP_SYS_HOG("pinctrl-u300", "power"),
> > > -	PIN_MAP_SYS_HOG("pinctrl-u300", "emif0"),
> > > -	PIN_MAP_SYS_HOG("pinctrl-u300", "emif1"),
> > > +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "power"),
> > > +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "emif0"),
> > > +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "emif1"),
> > >  	/* per-device maps for MMC/SD, SPI and UART */
> > > -	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "mmc0", "mmci"),
> > > -	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "spi0", "pl022"),
> > > -	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "uart0", "uart0"),
> > > +	PIN_MAP_MUX_GROUP_DEFAULT("mmci",  "pinctrl-u300", NULL, "mmc0"),
> > > +	PIN_MAP_MUX_GROUP_DEFAULT("pl022", "pinctrl-u300", NULL, "spi0"),
> > > +	PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-u300", NULL, "uart0"),
> >
> > Although not big issue, but i'm a bit more intended to the original way that
> > for the NULL group name using:
> > PIN_MAP_MUX_DEFAULT("mmci",  "pinctrl-u300", "mmc0"),
> > Or using PIN_MAP_MUX_GROUP_DEFAULT, but just totally remove the optional NULL
> > group name support to keep consistence and avoid confusing.
> 
> The group parameter can't be removed, since in general, the mapping table
> needs some way to indicate which group to activate the function on. For
> example, consider an I2C controller that can be muxed onto two different
> sets of pins based on the board layout - you need to specify which to use.
> 

I did not mean remove the group parameter support, i meant remove the optinal NULL
group name support to avoid using the macro like:
PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-u300", NULL, "uart0")
User should be better to specify a group name for this macro to avoid misleading.

However if want to support NULL group name, i'd rather like the macro:
PIN_MAP_MUX_DEFAULT("mmci",  "pinctrl-u300", "mmc0"),

> I suppose there could be yet more and more macros for muxing; one set
> that hard-codes group to NULL internally and hence doesn't take a parameter,
> and another that takes the group from a parameter. The set of macros and
> their names would start getting extremely unwieldy then though.
> 
Yes, that's what i mean.

> > > diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> > > index 05d25c8..b572153 100644
> > > --- a/include/linux/pinctrl/machine.h
> > > +++ b/include/linux/pinctrl/machine.h
> > > @@ -14,6 +14,41 @@
> > >
> > >  #include "pinctrl.h"
> > >
> > > +enum pinctrl_map_type {
> > > +	PIN_MAP_TYPE_INVALID,
> > > +	PIN_MAP_TYPE_DUMMY_STATE,
> > > +	PIN_MAP_TYPE_MUX_GROUP,
> > > +	PIN_MAP_TYPE_CONFIGS_PIN,
> > > +	PIN_MAP_TYPE_CONFIGS_GROUP,
> > 
> > Basically it causes a bit confusing to me that we have per pin config
> > but we do not have per pin mux.
> > However, i still have not got a better idea for this issue.
> 
> Well, that's a limitation of how the pinctrl core works right now. It'd
Correct.

> be entirely possible to fix this, I think, and we can easily expand
> that enum if that happens.
> 
Sounds good.
I was not asking you to fix it in this patch.
we can go for it letter since it's another issue and may need some changes
due to core limitation.

> > > +#define PIN_MAP_MUX_CONFIGS_GROUP(dev, state, pinctrl, grp, cfgs)	\
> >
> > Actually this macro is only for pin config setting,
> > maybe PIN_MAP_CONFIGS_GROUP is better, right?
> 
> Oh yes, the macro names should either have "MUX" /or/ "CONFIG", not both.
> I'll fix that.
> 
Sounds good.

> > > +	{								\
> > > +		.dev_name = dev,					\
> > > +		.name = state,						\
> > > +		.type = PIN_MAP_TYPE_CONFIGS_GROUP,			\
> > > +		.ctrl_dev_name = pinctrl,				\
> >
> > We have three entries above duplicated with MUX macro.
> 
> Well yes that's true, but is it really worth fixing? If we fix this,
> Then note that PIN_MUX_DUMMY_STATE also shares the first 3 of those 4
> lines, so we'll end up with a crazy maze of macros by removing all
> possible duplication
> 
> > > +		.data.configs = {					\
> > > +			.group_or_pin = grp,				\
> > > +			.configs = cfgs,				\
> > > +			.num_configs = ARRAY_SIZE(cfgs),		\
> > > +		},							\
> > > +	}
> >
> > It seems you separate the pin mux setting and pin config setting in
> > different maps.
> > Can we merge them into one map?
> > That will save a lot of map entries and improve searching performance.
> 
> Well, it's technically possible.
> 
> But then, you'll need macros that just define a mux setting, just configs
> for groups, or both mux setting and config settings. Then, cross-product
> that with whether the state name is default or not, and cross-product that
> with whether the macro should hard-code group to NULL or not etc. etc...
Well, they're indeed a lot.
But it seems they're not related to whether merging config and mux into one
map, right?
Because we already have and need these macros but just separated into two
parts for mux and config and that does not save too much.
Considering user may add a lot of per pin config entries in map(like tegra),
that will really increase the map table a lot and surely will affect the map
search performance a lot for mux setting.

And if we want to save macros, i'd rather prefer to eliminate the NULL group
name support since it really does not help too much and we already eliminate
the optional NULL state name support, so why not NULL group name?

> It seems like somewhat of a nightmare. Parsing this table is in the slow-
> path of pinctrl_get() anyway, so I don't think it's an enormous deal.
> 
> One alternative might be to represent mux settings as just another config
> on the group though. But that'd require the pin config namespace to have
> some standardized values and some driver-specific values.
> 
Do you mean treat them all(mux and config) as a config setting?
Then what benefits can we get?
Does it have any difference from separate them but still in one map?

> > Another question is that:
> > the current IMX pinmux setting for non-dt is like:
> > #define MX51_I2C_PAD_CTRL       (PAD_CTL_SRE_FAST | PAD_CTL_ODE | \
> >                                 PAD_CTL_DSE_HIGH | PAD_CTL_PUS_100K_UP | \
> > #define MX51_PAD_KEY_COL4__I2C2_SCL	\
> > 	IOMUX_PAD(0x65c, 0x26c, 0x13, 0x9b8, 1, MX51_I2C_PAD_CTRL)
> >
> > This macro includes both mux and config setting.
> > It's very easy and conveniently to use.
> > So i'd really like to see a similar using after migrate to pinctrl subsystem
> > that using a macro to set both.
> >
> > One possible working method i thought is extended macro based on your code:
> >
> > #define PIN_MAP_MUX_CONFIG_GROUP(dev, state, pinctrl, grp, func, cfgs)	\
> > 	PIN_MAP_MUX_GROUP(dev, state, pinctrl, grp, func),		\
> > 	PIN_MAP_CONFIG_GROUP(dev, state, pinctrl, grp, cfgs)
> 
> That's exactly what I've done for the Tegra:
> 
> #define TEGRA_MAP_MUX(_group_, _function_) \
> 	PIN_MAP_MUX_GROUP_HOG_DEFAULT(PINMUX_DEV, _group_, _function_)
> 
> #define TEGRA_MAP_CONF(_group_, _pull_, _drive_) \
> 	PIN_MAP_CONFIGS_GROUP_HOG_DEFAULT(PINMUX_DEV, _group_, tegra_pincfg_pull##_pull_##_##_drive_)
> 
> #define TEGRA_MAP_MUXCONF(_group_, _function_, _pull_, _drive_) \
> 	TEGRA_MAP_MUX(_group_, _function_), \
> 	TEGRA_MAP_CONF(_group_, _pull_, _drive_)
> 
> And the mapping table arrays in the board files use TEGRA_MAP_MUXCONF().
> 
> I'm not convinced it's a good idea to try and come up with common macros
> for this in <pinctrl/machine.h> due to the massive number of macros it'd
> take to represent all possible combinations. And even with such a common
> combo macro, I'd still need to define a custom TEGRA_MAP_MUXCONF in order
> to select which one of the common macros to use (in order to use a shorter
> name in board files than the long common macro names), hard-code the pin
> controller driver name, hard-code the configs array name, etc.
> 
Well, yes that it will increase more macros.
I can accept to let individual driver to define it according to their needs
first.

> > It works for group.
> > However, we can not also do this for per PIN config since PIN_MAP_MUX_*
> > is only for group.
> 
> If you know that your chip muxes per pin, then presumably the pin and
> group names are the same, so your combination macro can simply "call"
> PIN_MAP_CONFIGS_PIN_*() instead of PIN_MAP_CONFIGS_GROUP_*().
Well, the problem is that for virtual groups, the pin and group
name are not the same.
One solution i can see is that user may need to encode all pin configs
of a group in one config array and still use PIN_MAP_CONFIGS_GROUP_*(),
then each pinctrl driver has to decode that config array and do correct
setting.

> 
> Another solution may be to extend the pinctrl core to allow muxing per
> pin where the HW does, so you could use pin-based macros for both mux
> and config. But, lets tackle that after this current round of patches
> is merged.
> 
Yes, agree.

Regards
Dong Aisheng

