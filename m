Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab2DFXRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:17:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2DFXRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:17:22 -0400
Date: Fri, 6 Apr 2012 16:17:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, florianSchandinat@gmx.de,
        devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        augulis.darius@gmail.com, ben-linux@fluff.org, lars@metafoo.de,
        patches@linaro.org
Subject: Re: [PATCH v3 1/2] backlight: lcd: add driver for raster-type lcd's
 with gpio controlled panel reset
Message-Id: <20120406161720.cf464c39.akpm@linux-foundation.org>
In-Reply-To: <1332751600-11371-2-git-send-email-thomas.abraham@linaro.org>
References: <1332751600-11371-1-git-send-email-thomas.abraham@linaro.org>
	<1332751600-11371-2-git-send-email-thomas.abraham@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Cc: rpurdie@rpsys.net, florianSchandinat@gmx.de, devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca, rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com, broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com, augulis.darius@gmail.com, ben-linux@fluff.org, lars@metafoo.de, patches@linaro.org

Poor me.  When someone sends a patch like this, I need to go and hunt
down everyone's real names to nicely add them to the changelog's Cc:
list.  I prefer that you do this ;)

You can add Cc:'s to the changelog yourself, of course.  Often that
works out better than having me try to work out who might be
interested in the patch.

On Mon, 26 Mar 2012 14:16:39 +0530
Thomas Abraham <thomas.abraham@linaro.org> wrote:

> Add a lcd panel driver for simple raster-type lcd's which uses a gpio
> controlled panel reset. The driver controls the nRESET line of the panel
> using a gpio connected from the host system. The Vcc supply to the panel
> is (optionally) controlled using a voltage regulator. This driver excludes
> support for lcd panels that use a serial command interface or direct
> memory mapped IO interface.
> 
>
> ...
>
> +struct lcd_pwrctrl {
> +	struct device		*dev;
> +	struct lcd_device	*lcd;
> +	struct lcd_pwrctrl_data	*pdata;
> +	struct regulator	*regulator;
> +	unsigned int		power;
> +	bool			suspended;
> +	bool			pwr_en;

Generally kernel code will avoid these unpronounceable abbreviations. 
So we do

pwr -> power
en -> enable
ctrl -> control

etc.  It results in longer identifiers, but the code is more readable
and, more importantly, more *rememberable*.  

> +};
> +
> +static int lcd_pwrctrl_get_power(struct lcd_device *lcd)
> +{
> +	struct lcd_pwrctrl *lp = lcd_get_data(lcd);
> +	return lp->power;
> +}
> +
> +static int lcd_pwrctrl_set_power(struct lcd_device *lcd, int power)

See, shouldn't that have been lcd_pwrctrl_set_pwr?

If we avoid the abbreviations, such issues do not arise.

> +{
> +	struct lcd_pwrctrl *lp = lcd_get_data(lcd);
> +	struct lcd_pwrctrl_data *pd = lp->pdata;
> +	bool lcd_enable;
> +	int lcd_reset, ret = 0;
> +
> +	lcd_enable = (power == FB_BLANK_POWERDOWN || lp->suspended) ? 0 : 1;

This isn't how to use `bool'.  We can use

	lcd_enable = (power == FB_BLANK_POWERDOWN) || lp->suspended;


> +	lcd_reset = (pd->invert) ? !lcd_enable : lcd_enable;
> +
> +	if (lp->pwr_en == lcd_enable)
> +		return 0;
> +
> +	if (!IS_ERR_OR_NULL(lp->regulator)) {
> +		if (lcd_enable) {
> +			if (regulator_enable(lp->regulator)) {
> +				dev_info(lp->dev, "regulator enable failed\n");
> +				ret = -EPERM;
> +			}
> +		} else {
> +			if (regulator_disable(lp->regulator)) {
> +				dev_info(lp->dev, "regulator disable failed\n");
> +				ret = -EPERM;
> +			}
> +		}
> +	}
> +
> +	gpio_direction_output(lp->pdata->gpio, lcd_reset);
> +	lp->power = power;
> +	lp->pwr_en = lcd_enable;

Again, this could have been any of

	lp->[power|pwr] = [power|pwr];
	lp->[power|pwr]_[en|enable] = lcd_[en|enable];

zillions of combinations!  If we just avoid the abbreviations, there is
only one combination.

> +	return ret;
> +}
> +
>
> ...
>
> +static int __devinit lcd_pwrctrl_probe(struct platform_device *pdev)
> +{
> +	struct lcd_pwrctrl *lp;
> +	struct lcd_pwrctrl_data *pdata = pdev->dev.platform_data;
> +	struct device *dev = &pdev->dev;
> +	int err;
> +
> +#ifdef CONFIG_OF
> +	if (dev->of_node) {
> +		pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata) {
> +			dev_err(dev, "memory allocation for pdata failed\n");
> +			return -ENOMEM;
> +		}
> +		lcd_pwrctrl_parse_dt(dev, pdata);
> +	}
> +#endif
> +
> +	if (!pdata) {
> +		dev_err(dev, "platform data not available\n");
> +		return -EINVAL;
> +	}
> +
> +	lp = devm_kzalloc(dev, sizeof(struct lcd_pwrctrl), GFP_KERNEL);

Nit: I prefer sizeof(*lp) here, so I don't have to scroll back and
check the type of lp.

> +	if (!lp) {
> +		dev_err(dev, "memory allocation failed for private data\n");
> +		return -ENOMEM;
> +	}
> +
> +	err = gpio_request(pdata->gpio, "LCD-nRESET");
> +	if (err) {
> +		dev_err(dev, "gpio [%d] request failed\n", pdata->gpio);
> +		return err;
> +	}
> +
>
> ...
>

The code looks OK to me, but I do think the naming decisions should be
revisited, please.

