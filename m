Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2HHSjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:39:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35737 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2HHSjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:39:06 -0400
Message-ID: <5022B242.1050001@wwwdotorg.org>
Date: Wed, 08 Aug 2012 12:38:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: vt8500-wm8505-linux-kernel@googlegroups.com,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        Neil Zhang <zhangwm@marvell.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Rob Landley <rob@landley.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        Eric Andersson <eric.andersson@unixphere.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        rtc-linux@googlegroups.com, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 8/8] ARM: vt8500: gpio: Devicetree support for arch-vt8500
References: <1344389967-8465-1-git-send-email-linux@prisktech.co.nz> <1344389967-8465-9-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1344389967-8465-9-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 07:39 PM, Tony Prisk wrote:
> Converted the existing arch-vt8500 gpio to a platform_device.
> Added support for WM8505 and WM8650 GPIO controllers.

> diff --git a/drivers/gpio/gpio-vt8500.c b/drivers/gpio/gpio-vt8500.c

> +static struct of_device_id vt8500_gpio_dt_ids[] = {
> +	{ .compatible = "via,vt8500-gpio", .data = &vt8500_data, },
> +	{ .compatible = "wm,wm8505-gpio", .data = &wm8505_data, },
> +	{ .compatible = "wm,wm8650-gpio", .data = &wm8650_data, },
> +	{ /* Sentinel */ },
> +};
> +
> +static int __devinit vt8500_gpio_probe(struct platform_device *pdev)
> +{
> +	void __iomem *gpio_base;
> +	struct device_node *np;
> +	const struct of_device_id *of_id =
> +				of_match_device(vt8500_gpio_dt_ids, &pdev->dev);
> +
> +	if (!of_id) {
> +		dev_err(&pdev->dev, "Failed to find gpio controller\n");
> +		return -ENODEV;
> +	}
> +
> +	np = of_find_matching_node(NULL, vt8500_gpio_dt_ids);

Can't you use pdev->dev.of_node instead of searching for it again?

...
> +	of_node_put(np);

If so, you could also remove that.

> +static int __init vt8500_gpio_init(void)
> +{
> +	return platform_driver_probe(&vt8500_gpio_driver, &vt8500_gpio_probe);
> +}
> +
> +static void __exit vt8500_gpio_exit(void)
> +{
> +	return platform_driver_unregister(&vt8500_gpio_driver);
> +}
> +
> +module_init(vt8500_gpio_init);
> +module_exit(vt8500_gpio_exit);

I think that's all just:

module_platform_driver(vt8500_gpio_driver);

(except that _init uses platform_driver_probe() rather than
platform_driver_register(), which seems unusual. I guess that explains
the of_find_matching_node() above too.)

> +MODULE_LICENSE("GPL");

That should be "GPL v2" given the license header.

