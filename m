Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418Ab2CBWtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:49:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13805 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821Ab2CBWty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:49:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 Mar 2012 14:49:36 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 2 Mar 2012 14:49:35 -0800
Subject: RE: [PATCH V2 5/6] pinctrl: Enhance mapping table to support pin
 config operations
Thread-Topic: [PATCH V2 5/6] pinctrl: Enhance mapping table to support pin
 config operations
Thread-Index: Acz4Jle8S4nFB79STQ6UpvmK1EvilwAnmfkw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861ABD@HQMAIL01.nvidia.com>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
 <1330460852-23486-6-git-send-email-swarren@nvidia.com>
 <20120301084617.GB14703@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BE86167D@HQMAIL01.nvidia.com>
 <20120302034645.GA19342@shlinux2.ap.freescale.net>
In-Reply-To: <20120302034645.GA19342@shlinux2.ap.freescale.net>
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

Dong Aisheng wrote at Thursday, March 01, 2012 8:47 PM:
> On Thu, Mar 01, 2012 at 08:52:12AM -0800, Stephen Warren wrote:
> > Dong Aisheng wrote at Thursday, March 01, 2012 1:46 AM:
> > > On Tue, Feb 28, 2012 at 01:27:31PM -0700, Stephen Warren wrote:
...
> > > > diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
...
> > > > +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "power"),
> > > > +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "emif0"),
> > > > +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "emif1"),
...
> > > > +	PIN_MAP_MUX_GROUP_DEFAULT("mmci",  "pinctrl-u300", NULL, "mmc0"),
> > > > +	PIN_MAP_MUX_GROUP_DEFAULT("pl022", "pinctrl-u300", NULL, "spi0"),
> > > > +	PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-u300", NULL, "uart0"),
> > >
> > > Although not big issue, but i'm a bit more intended to the original way that
> > > for the NULL group name using:
> > > PIN_MAP_MUX_DEFAULT("mmci",  "pinctrl-u300", "mmc0"),
> > > Or using PIN_MAP_MUX_GROUP_DEFAULT, but just totally remove the optional NULL
> > > group name support to keep consistence and avoid confusing.
> >
> > The group parameter can't be removed, since in general, the mapping table
> > needs some way to indicate which group to activate the function on. For
> > example, consider an I2C controller that can be muxed onto two different
> > sets of pins based on the board layout - you need to specify which to use.
> >
> 
> I did not mean remove the group parameter support, i meant remove the optinal NULL
> group name support to avoid using the macro like:
> PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-u300", NULL, "uart0")
> User should be better to specify a group name for this macro to avoid misleading.

Ah right.

Yes, I'd be perfectly happy removing support for not specifying group
as NULL, and requiring a specific group name to be provided in all cases.
I like being specific:-)

Linus,

What are your thoughts here? IIRC, you were the one who wanted to be
able to specify group==NULL, and have the pinctrl core use the "first"
supported group for the function.

Either way, I think that if we did require non-NULL group, this should
be a separate patch we can introduce after merging my series, to avoid
feature creep.

...
> > > > +		.data.configs = {					\
> > > > +			.group_or_pin = grp,				\
> > > > +			.configs = cfgs,				\
> > > > +			.num_configs = ARRAY_SIZE(cfgs),		\
> > > > +		},							\
> > > > +	}
> > >
> > > It seems you separate the pin mux setting and pin config setting in
> > > different maps.
> > > Can we merge them into one map?
> > > That will save a lot of map entries and improve searching performance.
> >
> > Well, it's technically possible.
> >
> > But then, you'll need macros that just define a mux setting, just configs
> > for groups, or both mux setting and config settings. Then, cross-product
> > that with whether the state name is default or not, and cross-product that
> > with whether the macro should hard-code group to NULL or not etc. etc...
>
> Well, they're indeed a lot.
> But it seems they're not related to whether merging config and mux into one
> map, right?

There's certainly some relationship; see my explanation above re: why
you'd end up with a lot more macros. Of course, if we didn't create all
the special-case macros, this problem wouldn't exist, so I don't think
there would be a problem...

> > It seems like somewhat of a nightmare. Parsing this table is in the slow-
> > path of pinctrl_get() anyway, so I don't think it's an enormous deal.
> >
> > One alternative might be to represent mux settings as just another config
> > on the group though. But that'd require the pin config namespace to have
> > some standardized values and some driver-specific values.
>
> Do you mean treat them all(mux and config) as a config setting?
> Then what benefits can we get?
> Does it have any difference from separate them but still in one map?

I was thinking that we could put the mux values into the config array,
so instead of the mapping table for a combined mux+config entry having
specific fields for:

* pin group to configure
* mux function to set (or set to NULL/-1/... if not used)
* list of config options to set (or NULL if not used)

We could put the mux function into the config array. That way, instead
of having two optional mux and config fields, we'd have 1 mandatory
config field, and the config array may-or-may-not have a mux entry in
it, e.g.:

unsigned long tegra_config_ata[] = {
      TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_MUX, TEGRA_MUX_FUNCTION_SPI1),
	TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_PULL, TEGRA_PINCONFIG_PULL_NONE),
	TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, TEGRA_PINCONFIG_DRIVEN),
};

However, upon further reflection, that might be a bad idea, because then
there would be no way to share common sets of pin config entries between
multiple mapping table entries, since every pin/group would differ in
their mux setting, i.e. the following couldn't share anything:

unsigned long tegra_config_atb[] = {
      TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_MUX, TEGRA_MUX_FUNCTION_SPI2),
	TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_PULL, TEGRA_PINCONFIG_PULL_NONE),
	TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, TEGRA_PINCONFIG_DRIVEN),
};

But with the current scheme the mux setting isn't there, so the two arrays
would be the same and could be shared.

-- 
nvpublic

