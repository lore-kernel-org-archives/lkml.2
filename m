Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2BXHCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 02:02:33 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:3782
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751985Ab2BXHCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 02:02:31 -0500
X-Greylist: delayed 94906 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Feb 2012 02:02:31 EST
X-SpamScore: -14
X-BigFish: VS-14(zz9371I1dbaL1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 24 Feb 2012 15:09:52 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] pinctrl: Introduce PINCTRL_STATE_DEFAULT define,
 and use it
Message-ID: <20120224070952.GD25789@shlinux2.ap.freescale.net>
References: <1330041880-12406-1-git-send-email-swarren@nvidia.com>
 <20120224032451.GA25789@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC1F@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC1F@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 09:26:14PM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Thursday, February 23, 2012 8:25 PM:
> > On Fri, Feb 24, 2012 at 08:04:38AM +0800, Stephen Warren wrote:
> > > This provides a single centralized name for the default state.
> > >
> > > Update PIN_MAP_* macros to use this state name, instead of requiring the
> > > user to pass a state name in.
> ...
> > > diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> ...
> > > -       PIN_MAP("I2CMAP", "pinctrl-foo", "i2c0", "foo-i2c.0"),
> > > +	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-foo", "i2c0", "foo-i2c.0"),
> >
> > To keep align with the following
> > PIN_MAP_SYS_HOG("pinmux-u300", "power"),
> > Maybe PIN_MAP("pinctrl-foo", "i2c0", "foo-i2c.0") is better, right?
> > 
> > And we may want to add a PIN_MAP_STAT macro, as well as PIN_MAP_SYS_HOG_STAT.
> 
> I don't think so.
> 
> PIN_MAP_SYS_HOG hard-codes the state name inside the macro because its
> sole purpose is to support drivers/pinctrl/core.c's pinctrl_get() call
> for pin hogging purposes, so that state name is always "default", or
> rather, PINCTRL_STATE_DEFAULT.

I'm considering that we may also need to support multi states for system hog
functions, do you agree?
If we support that, it may not mean the system function's state is always "defualt".
And then we may be better to have separate convenience macro for those people
who want to support multi states for system functions.

> 
> The same isn't true of PIN_MAP; it's a general purpose macro intended for
> any device/situation/... I'd rather not keep inventing tons of macros in
> consumer.h and clutter it up.
> 
It's just the basic one and useful.
If we do not do it, i guess people will do it in their drivers
which makes code duplication in kernel.

> I guess if you really want, you can submit a patch to add a macro e.g.
> PIN_MAP_MUX_GROUP_DEFAULT() which hard-codes the default state name if
> you wish, following on from my patch to extend the mapping table to
> support pin config.
> 
> BTW, did you have any further thoughts on (not) allowing NULL state names?
> I'd like to repost the final version of that patch, or rework it so that
> the code actually does allow NULL state names ASAP (i.e. early Friday for
> me), since it blocks some of the later patches in the series. Thanks.
> 
Personally i wish to support NULL state name.
But if it really can't, i can also accept no NULL state names.

You mentioned it may cause many problems on DT side to support NULL state.
I'm still thinking the problems we're facing for dt and if we can fix it.

Thinking the model we discussed in Linaro connect:
sdhci@c8000200 {
	pinctrl-0 = <&pmx_sdhci &pmx_sdhci_active>;
	pinctrl-1 = <&pmx_sdhci &pmx_sdhci_standby>;
	/* An optional list of state names; depends on SDHCI driver */
	pinctrl-names = "active", "suspend";
};
The orginally purpose will convert the id of pinctrl-0 (eg. it's '0' here)
to be the state name if no pincgtrl-names property defined.
I'm wondering can we not use that id, just treat this case as no state names?
If that we can allow dt to define null state names.
And it's easy for map writers to write such map.

But i do not know how much troubles it will be caused in implementation since
you're writing all these code.

What do you think of it?

Regards
Dong Aisheng

