Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2BURqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:46:45 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3191 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2BURqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:46:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 21 Feb 2012 09:46:05 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 09:46:01 -0800
Subject: RE: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Topic: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Index: AczwGH1UKp8RKjHKTkeZnAfTaJOCewAp3Gww
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-9-git-send-email-swarren@nvidia.com>
 <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
In-Reply-To: <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
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

Linus Walleij wrote at Monday, February 20, 2012 2:42 PM:
> On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > pinctrl_register_mappings() already requires that every mapping table
> > entry have a non-NULL name field.
> >
> > Logically, this makes sense too; drivers should always request a specific
> > named state so they know what they're getting. Relying on getting the
> > first mentioned state in the mapping table is error-prone, and a nasty
> > special case to implement, given that a given the mapping table may define
> > multiple states for a device.
> >
> > Update a few places in the code and documentation that still allowed for
> > NULL name fields.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> This causes a regression on U300 and most certainly on the Sirf Prima II
> as well. The U300 can be fixed up as per below:

Oh good point. I'd remembered to update those in later patches, but not
this one...

> diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
> index bb1034f..66555d7 100644
> --- a/arch/arm/mach-u300/core.c
> +++ b/arch/arm/mach-u300/core.c
> @@ -1645,7 +1645,7 @@ static int __init u300_pinctrl_fetch(void)
>                 struct pinctrl *p;
>                 int ret;
> 
> -               p = pinctrl_get(u300_mux_hogs[i].dev, NULL);
> +               p = pinctrl_get(u300_mux_hogs[i].dev, u300_mux_hogs[i].name);
>                 if (IS_ERR(p)) {
>                         pr_err("u300: could not get pinmux hog %s\n",
>                                u300_mux_hogs[i].name);

I don't think that works as-is; currently, the names in the U300 map table
Are MMCSD, SPI, UART0, whereas the names in u300_mux_hogs[] are mmc0, spi0,
uart0. I can easily fix up the u300_mux_hogs[] in the same patch though.

> The drivers/tty/serial/sirfsoc_uart.c asks for it's UART pinctrl like
> this:
> 
> sirfport->p = pinctrl_get(&pdev->dev, NULL);
> 
> I don't know quite what to encode in there, if "default" is sensible

"default" seems reasonable to me.

I couldn't find any mapping table defined for Sirf Prima II; is there
one checked in anywhere?

> we might just
> 
> #define PIN_MAP_NAME_DEFAULT "default"
> In <linux/pinctrl/consumer.h> and <linux/pinctrl/machine.h> alike,
> maybe in some <linux/pinctrl/mapnames.h> that both of these
> include?
> 
> the have the driver ask for:
> 
> sirfport->p = pinctrl_get(&pdev->dev, PIN_MAP_NAME_DEFAULT);
> 
> (Similar changes can be done for U300, naming all its map
> "default".)

I guess we could just modify pinmux_get() such that if NULL is passed as
the state name, it uses "default" instead internally. The disadvantage I
see here is that someone reading the client driver and writing the mapping
table then has to know that pinmux_get() does that internally, rather than
it being obvious right in the client driver code.

--
nvpublic

