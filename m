Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2B1J3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:29:51 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:33231
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932570Ab2B1J3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:29:46 -0500
X-SpamScore: -14
X-BigFish: VS-14(zz154dM1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 28 Feb 2012 17:35:53 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] pinctrl: Assume map table entries can't have a
 NULL name field
Message-ID: <20120228093552.GA9987@shlinux2.ap.freescale.net>
References: <1330386909-17723-1-git-send-email-swarren@nvidia.com>
 <1330386909-17723-2-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1330386909-17723-2-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 04:55:09PM -0700, Stephen Warren wrote:
> pinctrl_register_mappings() already requires that every mapping table
> entry have a non-NULL name field.
> 
> Logically, this makes sense too; drivers should always request a specific
> named state so they know what they're getting. Relying on getting the
> first mentioned state in the mapping table is error-prone, and a nasty
> special case to implement, given that a given the mapping table may define
> multiple states for a device.
> 
> Remove a small part of the documentation that talked about optionally
> requesting a specific state; it's mandatory now.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Update mach-u300/core.c and sirfsoc_uart.c not to request NULL state
> names. Use PINCTRL_STATE_DEFAULT from previous patch.
> 
> This is now conceptually ack'd by Dong Aisheng, although I didn't actually
> include the ack above since I've reworked the patch a little since I last
> posted it (per the v2 changelog above).
> ---
It looks very good to me.

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

>  Documentation/pinctrl.txt         |    7 +++----
>  arch/arm/mach-u300/core.c         |    8 ++++----
>  drivers/pinctrl/core.c            |   17 +++++------------
>  drivers/tty/serial/sirfsoc_uart.c |    2 +-
>  4 files changed, 13 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index 6fe3232..558aac5 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -782,16 +782,19 @@ spi on the second function mapping:
>  static const struct pinctrl_map __initdata mapping[] = {
>  	{
>  		.dev_name = "foo-spi.0",
> +		.name = PINCTRL_STATE_DEFAULT,
>  		.ctrl_dev_name = "pinctrl-foo",
>  		.function = "spi0",
>  	},
>  	{
>  		.dev_name = "foo-i2c.0",
> +		.name = PINCTRL_STATE_DEFAULT,
>  		.ctrl_dev_name = "pinctrl-foo",
>  		.function = "i2c0",
>  	},
>  	{
>  		.dev_name = "foo-mmc.0",
> +		.name = PINCTRL_STATE_DEFAULT,
>  		.ctrl_dev_name = "pinctrl-foo",
>  		.function = "mmc0",
>  	},
> @@ -944,10 +947,6 @@ foo_remove()
>  	pinctrl_put(state->p);
>  }
>  
> -If you want to grab a specific control mapping and not just the first one
> -found for this device you can specify a specific mapping name, for example in
> -the above example the second i2c0 setting: pinctrl_get(&device, "spi0-pos-B");
> -
>  This get/enable/disable/put sequence can just as well be handled by bus drivers
>  if you don't want each and every driver to handle it and you know the
>  arrangement on your bus.
> diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
> index c9050dd..5b37d84 100644
> --- a/arch/arm/mach-u300/core.c
> +++ b/arch/arm/mach-u300/core.c
> @@ -1573,9 +1573,9 @@ static struct pinctrl_map __initdata u300_pinmux_map[] = {
>  	PIN_MAP_SYS_HOG("pinctrl-u300", "emif0"),
>  	PIN_MAP_SYS_HOG("pinctrl-u300", "emif1"),
>  	/* per-device maps for MMC/SD, SPI and UART */
> -	PIN_MAP("MMCSD", "pinctrl-u300", "mmc0", "mmci"),
> -	PIN_MAP("SPI", "pinctrl-u300", "spi0", "pl022"),
> -	PIN_MAP("UART0", "pinctrl-u300", "uart0", "uart0"),
> +	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "mmc0", "mmci"),
> +	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "spi0", "pl022"),
> +	PIN_MAP(PINCTRL_STATE_DEFAULT, "pinctrl-u300", "uart0", "uart0"),
>  };
>  
>  struct u300_mux_hog {
> @@ -1607,7 +1607,7 @@ static int __init u300_pinctrl_fetch(void)
>  		struct pinctrl *p;
>  		int ret;
>  
> -		p = pinctrl_get(u300_mux_hogs[i].dev, NULL);
> +		p = pinctrl_get(u300_mux_hogs[i].dev, PINCTRL_STATE_DEFAULT);
>  		if (IS_ERR(p)) {
>  			pr_err("u300: could not get pinmux hog %s\n",
>  			       u300_mux_hogs[i].name);
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index f25307b..6af6d8d 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -461,8 +461,8 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
>  	int i;
>  	struct pinctrl_map const *map;
>  
> -	/* We must have a dev name */
> -	if (WARN_ON(!dev))
> +	/* We must have both a dev and state name */
> +	if (WARN_ON(!dev || !name))
>  		return ERR_PTR(-EINVAL);
>  
>  	devname = dev_name(dev);
> @@ -504,16 +504,9 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev, const char *name)
>  		if (strcmp(map->dev_name, devname))
>  			continue;
>  
> -		/*
> -		 * If we're looking for a specific named map, this must match,
> -		 * else we loop and look for the next.
> -		 */
> -		if (name != NULL) {
> -			if (map->name == NULL)
> -				continue;
> -			if (strcmp(map->name, name))
> -				continue;
> -		}
> +		/* State name must be the one we're looking for */
> +		if (strcmp(map->name, name))
> +			continue;
>  
>  		ret = pinmux_apply_muxmap(pctldev, p, dev, devname, map);
>  		if (ret) {
> diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
> index c1a871e..3cabb65 100644
> --- a/drivers/tty/serial/sirfsoc_uart.c
> +++ b/drivers/tty/serial/sirfsoc_uart.c
> @@ -673,7 +673,7 @@ int sirfsoc_uart_probe(struct platform_device *pdev)
>  	port->irq = res->start;
>  
>  	if (sirfport->hw_flow_ctrl) {
> -		sirfport->p = pinctrl_get(&pdev->dev, NULL);
> +		sirfport->p = pinctrl_get(&pdev->dev, PINCTRL_STATE_DEFAULT);
>  		ret = IS_ERR(sirfport->p);
>  		if (ret)
>  			goto pin_err;
> -- 
> 1.7.0.4
> 
> 

