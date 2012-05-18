Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967355Ab2ERUFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 16:05:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35279 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967295Ab2ERUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 16:05:49 -0400
Message-ID: <4FB6AB9A.4080006@wwwdotorg.org>
Date: Fri, 18 May 2012 14:05:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH RFC v2 2/2] pinctrl: add pinctrl gpio binding support
References: <1337346755-8761-1-git-send-email-b29396@freescale.com> <1337346755-8761-2-git-send-email-b29396@freescale.com>
In-Reply-To: <1337346755-8761-2-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 07:12 AM, Dong Aisheng wrote:
> The gpio ranges standard dt binding format is
> <&gpio $gpio_offset $pin_offset $npin>
> 
> The core will parse and register the pinctrl gpio ranges
> from device tree.

Overall this conceptually makes sense, and looks good. Some comments though:

> +/*
> + * pinctrl_dt_add_gpio_range() - parse and register GPIO ranges from device tree
> + * @pctldev: pin controller device to add the range to
> + * @np: the device node contains the property @propname
> + * @propname: a list of phandles of gpios and corresponding data.
> + *  The format is: <&gpio0 $gpio_offset $pin_offset $count>
> + */
> +int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
> +				struct device_node *np,
> +				const char *propname)

If this will be fully standardized, perhaps we should just choose a
standard property name, rather than allowing different drivers to do
different things.

Perhaps "gpio-map"?

> +	nranges = size /4;

Add a space after the /

> +	ranges = devm_kzalloc(pctldev->dev, nranges * sizeof(*ranges),
> +				GFP_KERNEL);
> +	for (i = 0; i < nranges; i++) {
> +			phandle = be32_to_cpup(list++);

Looks like double indentation througout this block?

> +			np_gpio = of_find_node_by_phandle(phandle);
> +			if (!np_gpio) {
> +				dev_err(pctldev->dev,
> +					"failed to find gpio node(%s)\n",
> +					np_gpio->name);

Perhaps devm_kfree(ranges) here so that if this is called multiple times
due to deferred probe, the allocations from the failed attempts don't
accumulate. Same for other error paths.

> +				return -ENODEV;
> +			}
> +
> +			ranges[i].gc = of_node_to_gpiochip(np_gpio);

Of course, there is the outstanding question of whether this API will
exist and how it will work.

I think you can of_node_put(np_gpio) here, before the error-check for
ranges[i].gc, to avoid having to do it in all the error paths below.

Do you need to xxx_get(ranges[i].gc) to prevent it going away, and put()
it when removing the ranges?

> +			if (gpio_offset < 0 ||
> +			    gpio_offset > ranges[i].gc->ngpio ||
> +			    pin_offset < 0 || npins < 0) {

These are all unsigned, so most of those conditions can never be true.

Perhaps replace the remaining check with:

	gpio_offset + npins > ranges[i].gc->ngpio

to make sure the range isn't too long either

> +	pinctrl_add_gpio_ranges(pctldev, ranges, nranges);

I think we should also store ranges somewhere separate in pctldev ...

> +void pinctrl_dt_remove_gpio_ranges(struct pinctrl_dev *pctldev,
> +				   struct pinctrl_gpio_range *ranges,
> +				   unsigned nranges)

... so that this function doesn't need ranges/nranges passed to it; it
can just get them out of pctldec.

Or better yet, what if pinctrl_unregister automatically removed any
ranges registered by pinctrl_dt_add_gpio_ranges, so this function
doesn't even need to exist?
