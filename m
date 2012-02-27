Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab2B0MOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 07:14:52 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:50816
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751541Ab2B0MOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 07:14:51 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz179dN1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 27 Feb 2012 20:21:18 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/20] pinctrl: Enhance mapping table to support pin
 config operations
Message-ID: <20120227122117.GA15593@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-21-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329720360-23227-21-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:46:00PM -0700, Stephen Warren wrote:
> The pinctrl mapping table can now contain entries to:
> * Set the mux function of a pin group
> * Apply a set of pin config options to a pin or a group
> 
> This allows pinctrl_select_state() to apply pin configs settings as well
> as mux settings.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
....
> -       PIN_MAP("default", "pinctrl-foo", "i2c0", "foo-i2c.0"),
> +	PIN_MAP_MUX_GROUP("foo-i2c.o", "default", "pinctrl-foo", NULL, "i2c0"),
> +};
> +
> +The mapping table may also contain pin configuration entries. It's common for
> +each pin/group to have a number of configuration entries that affect it, so
> +the table entries for configuration reference an array of config parameters
> +and values. An example using the convenience macros is shown below:
> +
> +static unsigned long i2c_grp_configs[] = {
> +	FOO_PIN_DRIVEN,
> +	FOO_PIN_PULLUP,
> +};
> +
> +static unsigned long i2c_pin_configs[] = {
> +	FOO_OPEN_COLLECTOR,
> +	FOO_SLEW_RATE_SLOW,
> +};
> +
> +static struct pinctrl_map __initdata mapping[] = {
> +	PIN_MAP_MUX_GROUP("foo-i2c.0", "default", "pinctrl-foo", "i2c0", "i2c0"),
> +	PIN_MAP_MUX_CONFIGS_GROUP("foo-i2c.0", "default", "pinctrl-foo", "i2c0", i2c_grp_configs),
> +	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", "default", "pinctrl-foo", "i2c0scl", i2c_pin_configs),
> +	PIN_MAP_MUX_CONFIGS_PIN("foo-i2c.0", "default", "pinctrl-foo", "i2c0sda", i2c_pin_configs),
I still have not read all over this patch.
But one question i'm considering is that
will this way here also work for "virtual" group?
For example, the virtual group "i2c_grp_configs" may actually contains
the config for each pin in that group?
The core will handle this difference or let each driver to handle it?

> @@ -1022,7 +1074,7 @@ Since it may be common to request the core to hog a few always-applicable
>  mux settings on the primary pin controller, there is a convenience macro for
>  this:
>  
> -PIN_MAP_SYS_HOG("active", "pinctrl-foo", "power_func")
Hmm?
Why remove this one?

> +PIN_MAP_MUX_GROUP("pinctrl-foo", "active", "pinctrl-foo", NULL, "power_func")
>  
>  This gives the exact same result as the above construction.
>  
> diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
> index eb79a49..599aa79 100644
> --- a/arch/arm/mach-u300/core.c
> +++ b/arch/arm/mach-u300/core.c
> @@ -1554,13 +1554,13 @@ static struct platform_device pinmux_device = {
>  /* Pinmux settings */
>  static struct pinctrl_map __initdata u300_pinmux_map[] = {
>  	/* anonymous maps for chip power and EMIFs */
> -	PIN_MAP_SYS_HOG("default", "pinmux-u300", "power"),
> -	PIN_MAP_SYS_HOG("default", "pinmux-u300", "emif0"),
> -	PIN_MAP_SYS_HOG("default", "pinmux-u300", "emif1"),
> +	PIN_MAP_MUX_GROUP("pinmux-u300", "default", "pinmux-u300", NULL, "power"),
> +	PIN_MAP_MUX_GROUP("pinmux-u300", "default", "pinmux-u300", NULL, "emif0"),
> +	PIN_MAP_MUX_GROUP("pinmux-u300", "default", "pinmux-u300", NULL, "emif1"),
>  	/* per-device maps for MMC/SD, SPI and UART */
> -	PIN_MAP("default", "pinmux-u300", "mmc0", "mmci"),
> -	PIN_MAP("default", "pinmux-u300", "spi0", "pl022"),
> -	PIN_MAP("default", "pinmux-u300", "uart0", "uart0"),
> +	PIN_MAP_MUX_GROUP("mmci",  "default", "pinmux-u300", NULL, "mmc0"),
> +	PIN_MAP_MUX_GROUP("pl022", "default", "pinmux-u300", NULL, "spi0"),
> +	PIN_MAP_MUX_GROUP("uart0", "default", "pinmux-u300", NULL, "uart0"),
>  };
>  
>  struct u300_mux_hog {
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index bab1a69..af4ebe9 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -341,6 +341,31 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
>  }
>  
>  /**
> + * pinctrl_get_pin_id() - returns the group selector for a group
> + * @pctldev: the pin controller handling the group
> + * @pin_group: the pin group to look up
The comment seems not correct here.

> + */
> +int pinctrl_get_pin_id(struct pinctrl_dev *pctldev,
> +		       const char *pin)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < pctldev->desc->npins; i++) {
> +		if (pctldev->desc->pins[i].name == NULL)
> +			continue;
> +		if (!strcmp(pin, pctldev->desc->pins[i].name)) {
> +			dev_dbg(pctldev->dev, "found pin id %u for %s\n",
> +				i, pin);
> +			return i;
It looks actually this is not a PIN id.
It's just the index of the pin array.
Pin has its own id:
struct pinctrl_pin_desc {
	unsigned number;
	const char *name;
};

>  static int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
>  			   unsigned long *config)
>  {
> @@ -260,8 +278,154 @@ unlock:
>  }
>  EXPORT_SYMBOL(pin_config_group_set);
>  
> +int pinconf_map_to_setting(struct pinctrl_map const *map,
> +			  struct pinctrl_setting *setting)
> +{
> +	struct pinctrl_dev *pctldev = setting->pctldev;
> +
> +	switch (setting->type) {
> +	case PIN_MAP_TYPE_CONFIGS_PIN:
> +		setting->data.configs.group_or_pin =
> +			pinctrl_get_pin_id(pctldev,
> +					   map->data.configs.group_or_pin);
> +		if (setting->data.configs.group_or_pin < 0)
> +			return setting->data.configs.group_or_pin;
> +		break;
> +		break;
Two break here.

Regards
Dong Aisheng

