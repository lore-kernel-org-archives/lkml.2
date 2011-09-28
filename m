Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1I1AJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:09:03 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4196 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1I1AJB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:09:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 27 Sep 2011 17:08:56 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Date: Tue, 27 Sep 2011 17:08:52 -0700
Subject: RE: [PATCH 1/2] drivers: create a pin control subsystem v7
Thread-Topic: [PATCH 1/2] drivers: create a pin control subsystem v7
Thread-Index: Acx86j5sttZFdcGmR5GjEzbLTky4ZQAh5+Bg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17395556D5@HQMAIL01.nvidia.com>
References: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321751@HQMAIL01.nvidia.com>
	<CACRpkdZyhkydTutHXfry_dUPK_Ts_jq+5VHcr8XdgrHSExTyww@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1738180167@HQMAIL01.nvidia.com>
 <CACRpkdZiQX0whbC85dN0JmNB=sgWiZ=WiUwkBdrHzFC4awH8YA@mail.gmail.com>
In-Reply-To: <CACRpkdZiQX0whbC85dN0JmNB=sgWiZ=WiUwkBdrHzFC4awH8YA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, September 27, 2011 1:51 AM:
> On Wed, Sep 21, 2011 at 9:45 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Wednesday, September 21, 2011 3:17 AM:
> >> To abstract things the stuff we can do with the group should be
> >> something enumerated too. So:
> >>
> >> pinctrl_config_group(const char *pinctrl_device, const char *group,
> >> const char *mode);
> >> pinctrl_config_pin(const char *pinctrl_device, int pin, const char *mode);
> >>
> >> So the driver need an API to enumerate pin and group modes.
> >>
> >> I might want to save this thing for post-merge of the basic API and
> >> pinmux stuff though so we don't try to push too much upfront
> >> design at once.
> >
> > Yes, adding in a replacement _config API can certainly be a later patch.
> 
> If I'm efficient enough we might get that add-on before the v3.2
> merge window, I'll iterate that patch separately though.
> 
> > One comment on the API above: I think you want "mode" (or "setting"?)
> > /and/ a value parameter; Tegra's pull strength definition for example
> > is:
> >
> > enum tegra_pull_strength {
> >        TEGRA_PULL_0 = 0,
> >        TEGRA_PULL_1,
> > // ... (every value in between)
> >        TEGRA_PULL_30,
> >        TEGRA_PULL_31,
> >        TEGRA_MAX_PULL,
> > };
> >
> > And it seems better to represent that as ("pull", 0) ... ("pull", 31) than
> > "pull0" .. "pull31" such that the value needs to be parsed out of the "mode"
> > string somehow by the driver.
> 
> OK so we might want some public defintion of "things you can do"
> with pins, then an opaque parameter.
> 
> like:
> 
> #define PINCTRL_PULL "pull"
> #define PINCTRL_BIAS "bias"
> #define PINCTRL_LOADCAP "load-capacitance"
> #define PINCTRL_DRIVE "drive"

Yes although Tegra has quite a few more weird options than that; I'm not
sure exactly how many of the options that Tegra supports would be useful
for other SoCs, or what the best way to represent all the device-specific
knobs is. I guess we need another survey of a bunch of SoCs like you did
when designing the pinmux API.

> ...but then it's just simple enumerators, and we might be better off
> with a simple enum after all:
> 
> enum pinctrl_pin_ops {
>     PINCTRL_PULL,
>     PINCTRL_BIAS,
>     PINCTRL_LOADCAP,
>     PINCTRL_DRIVE,
> }
> 
> Surely the device tree will have to translate that enum into strings
> (I guess? Sorry for my low DT competence) but that is more of a
> DT pecularity and can be kept in the DT pin control parser?

DT as a data format can handle strings or integers just fine. However,
there's currently no support for named constants (i.e. #defines) in the
device-tree source format, so strings end up being a lot more self-
documenting. Whatever the DT format ends up being, we can certainly
map from whatever-dt-contains to whatever-Linux-APIs-need inside 
whatever kernel function is written to extract the data from DT.

-- 
nvpublic

