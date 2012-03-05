Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2CEHyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:54:39 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:41448 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756080Ab2CEHyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:54:38 -0500
X-SpamScore: -19
X-BigFish: VS-19(zz9371I146fK179dN1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 5 Mar 2012 15:58:54 +0800
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
Message-ID: <20120305075852.GA21987@shlinux2.ap.freescale.net>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
 <1330460852-23486-6-git-send-email-swarren@nvidia.com>
 <20120301084617.GB14703@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BE86167D@HQMAIL01.nvidia.com>
 <20120302034645.GA19342@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BE861ABD@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE861ABD@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 02:49:35PM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Thursday, March 01, 2012 8:47 PM:
> > On Thu, Mar 01, 2012 at 08:52:12AM -0800, Stephen Warren wrote:
> > > Dong Aisheng wrote at Thursday, March 01, 2012 1:46 AM:
> > > > On Tue, Feb 28, 2012 at 01:27:31PM -0700, Stephen Warren wrote:
.......
> > > > > +		.data.configs = {					\
> > > > > +			.group_or_pin = grp,				\
> > > > > +			.configs = cfgs,				\
> > > > > +			.num_configs = ARRAY_SIZE(cfgs),		\
> > > > > +		},							\
> > > > > +	}
> > > >
> > > > It seems you separate the pin mux setting and pin config setting in
> > > > different maps.
> > > > Can we merge them into one map?
> > > > That will save a lot of map entries and improve searching performance.
> > >
> > > Well, it's technically possible.
> > >
> > > But then, you'll need macros that just define a mux setting, just configs
> > > for groups, or both mux setting and config settings. Then, cross-product
> > > that with whether the state name is default or not, and cross-product that
> > > with whether the macro should hard-code group to NULL or not etc. etc...
> >
> > Well, they're indeed a lot.
> > But it seems they're not related to whether merging config and mux into one
> > map, right?
> 
> There's certainly some relationship; see my explanation above re: why
> you'd end up with a lot more macros. Of course, if we didn't create all
> the special-case macros, this problem wouldn't exist, so I don't think
> there would be a problem...
> 
Hmm, you missed some other words of mine in last mail.
It does not save too much.

And yes, the problem wouldn't exist if do not create all macros.
One way is that we can eliminate NULL group name support to reduce macros
(it seemed you agreed with it).

> > > It seems like somewhat of a nightmare. Parsing this table is in the slow-
> > > path of pinctrl_get() anyway, so I don't think it's an enormous deal.
> > >
> > > One alternative might be to represent mux settings as just another config
> > > on the group though. But that'd require the pin config namespace to have
> > > some standardized values and some driver-specific values.
> >
> > Do you mean treat them all(mux and config) as a config setting?
> > Then what benefits can we get?
> > Does it have any difference from separate them but still in one map?
> 
> I was thinking that we could put the mux values into the config array,
> so instead of the mapping table for a combined mux+config entry having
> specific fields for:
Yes, it is similar as my thinking.
The purpose is the same:
provide a more convenient way for user to use pinctrl, that says, users can use
one macro to define both mux and config.

> 
> * pin group to configure
> * mux function to set (or set to NULL/-1/... if not used)
> * list of config options to set (or NULL if not used)
> 
> We could put the mux function into the config array. That way, instead
> of having two optional mux and config fields, we'd have 1 mandatory
> config field, and the config array may-or-may-not have a mux entry in
> it, e.g.:
> 
> unsigned long tegra_config_ata[] = {
>       TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_MUX, TEGRA_MUX_FUNCTION_SPI1),
> 	TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_PULL, TEGRA_PINCONFIG_PULL_NONE),
> 	TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, TEGRA_PINCONFIG_DRIVEN),
> };
> 
> However, upon further reflection, that might be a bad idea, because then
> there would be no way to share common sets of pin config entries between
> multiple mapping table entries, since every pin/group would differ in
> their mux setting, i.e. the following couldn't share anything:
> 
> unsigned long tegra_config_atb[] = {
>       TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_MUX, TEGRA_MUX_FUNCTION_SPI2),
> 	TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_PULL, TEGRA_PINCONFIG_PULL_NONE),
> 	TEGRA_PINCONF_PACK(TEGRA_PINCONF_PARAM_TRISTATE, TEGRA_PINCONFIG_DRIVEN),
> };
> 
> But with the current scheme the mux setting isn't there, so the two arrays
> would be the same and could be shared.
> 
Yes, so i also prefer to separate them.

Regards
Dong Aisheng

