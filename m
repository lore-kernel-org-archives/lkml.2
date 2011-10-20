Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1JTNAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:00:35 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:41686 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1JTNAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:00:34 -0400
X-SpamScore: -2
X-BigFish: VS-2(z1039oz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Thu, 20 Oct 2011 21:10:43 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Barry Song <21cnbao@gmail.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
Message-ID: <20111020131042.GH32007@S2100-06.ap.freescale.net>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
 <20111020023140.GC32007@S2100-06.ap.freescale.net>
 <CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 05:17:08PM +0800, Barry Song wrote:
> >> +enum pin_config_param {
> >> +     PIN_CONFIG_BIAS_UNKNOWN,
> >> +     PIN_CONFIG_BIAS_FLOAT,
> >> +     PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
> >> +     PIN_CONFIG_BIAS_PULL_UP,
> >> +     PIN_CONFIG_BIAS_PULL_DOWN,
> >> +     PIN_CONFIG_BIAS_HIGH,
> >> +     PIN_CONFIG_BIAS_GROUND,
> >> +     PIN_CONFIG_DRIVE_UNKNOWN,
> >> +     PIN_CONFIG_DRIVE_PUSH_PULL,
> >> +     PIN_CONFIG_DRIVE_OPEN_DRAIN,
> >> +     PIN_CONFIG_DRIVE_OPEN_SOURCE,
> >> +     PIN_CONFIG_DRIVE_OFF,
> >> +     PIN_CONFIG_INPUT_SCHMITT,
> >> +     PIN_CONFIG_SLEW_RATE_RISING,
> >> +     PIN_CONFIG_SLEW_RATE_FALLING,
> >> +     PIN_CONFIG_LOAD_CAPACITANCE,
> >> +     PIN_CONFIG_WAKEUP_ENABLE,
> >> +     PIN_CONFIG_END,
> >> +};
> >> +
> >
> > IMO, trying to enumerate all possible pin_config options is just to
> > make everyone's life harder.  Firstly, this enumeration is far from
> > completion, for imx6 iomuxc example, we have 3 options for pull-up,
> > 22, 47 and 100 kOhm, and 7 options for driver-strength, 34, 40, 48,
> > 60, 80, 120, and 240 Ohm.  It's just so hard to make this enumeration
> > complete.  Secondly, defining this param as enum requires the API
> > user to call the function multiple times to configure one pin.  For
> > example, if I want to configure pin_foo as slow-slew, open-drain,
> > 100 kOhm pull-up and 120 Ohm driver-strength, I will have to call
> > pin_config(pctldev, pin_foo, ...) 4 times to achieve that.
> >
> > I like Stephen's idea about having 'u32 param' and let pinctrl drivers
> > to encode/decode this u32 for their pinctrl controller.  It makes
> > people's life much easier.
> 
> A multifunctional API is actually  a bad and hard-to-use API. i agree
> we can make param u32 instead of enum and let specific driver
> customizes the param by itself.
> 
> But if there are some common params, for example, PULL, OC/OD,
> WAKEUP_ENABLE, which almost all platforms need,  why don't we make
> them have common definitions like:
> 
> #define PIN_CONFIG_PULL                             0
> #define PIN_CONFIG_OPEN_DRAIN                1
> ....
> #define PIN_CONFIG_USER                            5 (in case)
> 
> if one platform has config not in the up list, then:
> 
> #define PIN_CONFIG_TERGA_XXX                PIN_CONFIG_USER
> #define PIN_CONFIG_TERGA_YYY                (PIN_CONFIG_USER + 1)
> 
> without the common definition from  PIN_CONFIG_PULL to
> PIN_CONFIG_USER, many platforms will need to definite them repeatedly.
> that is what we hate.
> 
I prefer to completely leave the encoding of this 'u32 param' to pinctrl
drivers, so that they can map the bit definition of 'param' to the
controller register as much as they can.  On imx, we have one register
accommodating all pin configuration options for one pin, so we can
write 'param' directly into register with exactly same bit definition
as register.

-- 
Regards,
Shawn

