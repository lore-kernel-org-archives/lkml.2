Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab2CAIkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:40:43 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:48348
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753853Ab2CAIkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:40:42 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 1 Mar 2012 16:46:18 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 5/6] pinctrl: Enhance mapping table to support pin
 config operations
Message-ID: <20120301084617.GB14703@shlinux2.ap.freescale.net>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
 <1330460852-23486-6-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330460852-23486-6-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 01:27:31PM -0700, Stephen Warren wrote:
> The pinctrl mapping table can now contain entries to:
> * Set the mux function of a pin group
> * Apply a set of pin config options to a pin or a group
> 
> This allows pinctrl_select_state() to apply pin configs settings as well
> as mux settings.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
....
> +Finally, some devices expect the mapping table to contain certain specific
> +named states. When running on hardware that doesn't need any pin controller
> +configuration, the mapping table must still contain those named states, in
> +order to explicitly indicate that the states were provided and intended to
> +be empty. Table entry macro PIN_MAP_DUMMY_STATE serves the purpose of defining
> +a named state without causing any pin controller to be programmed:
> +
> +static struct pinctrl_map __initdata mapping[] = {
> +	PIN_MAP_DUMMY_STATE("foo-i2c.0", PINCTRL_STATE_DEFAULT),
>  };
Is this used for shared devices between different platforms which may need pinmux
setting while another not?

>  
> -PIN_MAP_SYS_HOG("pinctrl-foo", "power_func")
> +PIN_MAP_MUX_GROUP_HOG("pinctrl-foo", NULL /* group */, "power_func")
Missed state name or should be PIN_MAP_MUX_GROUP_HOG_DEFAULT?

>  
>  This gives the exact same result as the above construction.
>  
> diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
> index 18973ca..c965bb5 100644
> --- a/arch/arm/mach-u300/core.c
> +++ b/arch/arm/mach-u300/core.c
> @@ -1569,13 +1569,13 @@ static struct platform_device dma_device = {
>  /* Pinmux settings */
>  static struct pinctrl_map __initdata u300_pinmux_map[] = {
>  	/* anonymous maps for chip power and EMIFs */
> -	PIN_MAP_SYS_HOG("pinctrl-u300", "power"),
> -	PIN_MAP_SYS_HOG("pinctrl-u300", "emif0"),
> -	PIN_MAP_SYS_HOG("pinctrl-u300", "emif1"),
> +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "power"),
> +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "emif0"),
> +	PIN_MAP_MUX_GROUP_HOG_DEFAULT("pinctrl-u300", NULL, "emif1"),
>  	/* per-device maps for MMC/SD, SPI and UART */
> -	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "mmc0", "mmci"),
> -	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "spi0", "pl022"),
> -	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "uart0", "uart0"),
> +	PIN_MAP_MUX_GROUP_DEFAULT("mmci",  "pinctrl-u300", NULL, "mmc0"),
> +	PIN_MAP_MUX_GROUP_DEFAULT("pl022", "pinctrl-u300", NULL, "spi0"),
> +	PIN_MAP_MUX_GROUP_DEFAULT("uart0", "pinctrl-u300", NULL, "uart0"),
Although not big issue, but i'm a bit more intended to the original way that
for the NULL group name using:
PIN_MAP_MUX_DEFAULT("mmci",  "pinctrl-u300", "mmc0"),
Or using PIN_MAP_MUX_GROUP_DEFAULT, but just totally remove the optional NULL
group name support to keep consistence and avoid confusing.

> diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
> index 05d25c8..b572153 100644
> --- a/include/linux/pinctrl/machine.h
> +++ b/include/linux/pinctrl/machine.h
> @@ -14,6 +14,41 @@
>  
>  #include "pinctrl.h"
>  
> +enum pinctrl_map_type {
> +	PIN_MAP_TYPE_INVALID,
> +	PIN_MAP_TYPE_DUMMY_STATE,
> +	PIN_MAP_TYPE_MUX_GROUP,
> +	PIN_MAP_TYPE_CONFIGS_PIN,
> +	PIN_MAP_TYPE_CONFIGS_GROUP,

Basically it causes a bit confusing to me that we have per pin config
but we do not have per pin mux.
However, i still have not got a better idea for this issue.

> +#define PIN_MAP_MUX_CONFIGS_GROUP(dev, state, pinctrl, grp, cfgs)	\
Actually this macro is only for pin config setting,
maybe PIN_MAP_CONFIGS_GROUP is better, right?

> +	{								\
> +		.dev_name = dev,					\
> +		.name = state,						\
> +		.type = PIN_MAP_TYPE_CONFIGS_GROUP,			\
> +		.ctrl_dev_name = pinctrl,				\
We have three entries above duplicated with MUX macro.

> +		.data.configs = {					\
> +			.group_or_pin = grp,				\
> +			.configs = cfgs,				\
> +			.num_configs = ARRAY_SIZE(cfgs),		\
> +		},							\
> +	}
It seems you separate the pin mux setting and pin config setting in
different maps.
Can we merge them into one map?
That will save a lot of map entries and improve searching performance.

Another question is that:
the current IMX pinmux setting for non-dt is like:
#define MX51_I2C_PAD_CTRL       (PAD_CTL_SRE_FAST | PAD_CTL_ODE | \
                                PAD_CTL_DSE_HIGH | PAD_CTL_PUS_100K_UP | \
#define MX51_PAD_KEY_COL4__I2C2_SCL	\
	IOMUX_PAD(0x65c, 0x26c, 0x13, 0x9b8, 1, MX51_I2C_PAD_CTRL)
This macro includes both mux and config setting.
It's very easy and conveniently to use.
So i'd really like to see a similar using after migrate to pinctrl subsystem
that using a macro to set both.

One possible working method i thought is extended macro based on your code:
#define PIN_MAP_MUX_CONFIG_GROUP(dev, state, pinctrl, grp, func, cfgs)	\
	PIN_MAP_MUX_GROUP(dev, state, pinctrl, grp, func),		\
	PIN_MAP_CONFIG_GROUP(dev, state, pinctrl, grp, cfgs)

It works for group.
However, we can not also do this for per PIN config since PIN_MAP_MUX_*
is only for group.

Regards
Dong Aisheng

