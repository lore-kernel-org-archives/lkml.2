Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395Ab2EWUoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:44:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32830 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2EWUoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:44:07 -0400
Message-ID: <4FBD4C13.8080209@wwwdotorg.org>
Date: Wed, 23 May 2012 14:44:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH RFC v3 3/3] pinctrl: add pinctrl gpio binding support
References: <1337779362-31259-1-git-send-email-b29396@freescale.com> <1337779362-31259-3-git-send-email-b29396@freescale.com>
In-Reply-To: <1337779362-31259-3-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 07:22 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This patch implements a standard common binding for pinctrl gpio ranges.
> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
> under their pinctrl devices node with the format:
> <&gpio $gpio_offset $pin_offset $npin>.
> 
> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
> to parse and register the gpio ranges from device tree.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

This is mostly good. Just a few comments:

> +gpio-maps: 4 integers array, each entry in the array represents a gpio
> +range with the format: <&gpio $gpio_offset $pin_offset $count>
> +- gpio: phandle pointing at gpio device node
> +- gpio_offset: integer, the local offset of $gpio
> +- pin_offset: integer, the pin offset or pin id
> +- npins: integer, the gpio ranges starting from pin_offset

This uses a single cell to represent a GPIO ID within a GPIO controller.
The standard GPIO bindings use #gpio-cells, where that's a property in
the GPIO controller's node. I wonder if we shouldn't do the same here,
and call into the GPIO driver to parse #gpio-cells and give back the
Linux GPIO ID, just like of_get_named_gpio_flags() does. This would also
make this code able to cope with the GPIO of_xlate function returning a
different GPIO chip, which Grant put in place for banked GPIO controllers.

> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c

> +int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,

The locking I was talking about before is between the following line:

> +		ranges[i].gc = of_node_to_gpiochip(np_gpio);

and this code:

> +		ranges[i].name = dev_name(pctldev->dev);
> +		ranges[i].base = ranges[i].gc->base + gpio_offset;
> +		ranges[i].pin_base = pin_offset;
> +		ranges[i].npins = npins;

If of_node_to_gpiochip() doesn't mark the GPIO chip as "in use", then
the module that provides that device could be unloaded between the two
blocks of code above.

Re: your locking comments in your other email: ranges[i].gc doesn't
appear to be used anywhere else in pinctrl, so I think it's OK not to
lock the GPIO chip for any more time than between the above two blocks
of code.

Finally, just a minor nit:

> +		ranges[i].gc = of_node_to_gpiochip(np_gpio);
> +		if (!ranges[i].gc) {
> +			dev_err(pctldev->dev,
> +				"can not find gpio chip of node(%s)\n",
> +				np_gpio->name);
> +			of_node_put(np_gpio);
> +			return -EPROBE_DEFER;
> +		}
> +
> +		of_node_put(np_gpio);

could be slightly simpler:

+		ranges[i].gc = of_node_to_gpiochip(np_gpio);
+		of_node_put(np_gpio); <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
+		if (!ranges[i].gc) {
+			dev_err(pctldev->dev,
+				"can not find gpio chip of node(%s)\n",
+				np_gpio->name);
+			return -EPROBE_DEFER;
+		}
