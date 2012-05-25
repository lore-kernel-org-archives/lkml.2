Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab2EYREh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:04:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54703 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874Ab2EYRDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:52 -0400
Message-ID: <4FBFBB74.901@wwwdotorg.org>
Date: Fri, 25 May 2012 11:03:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH v4 6/6] pinctrl: add pinctrl gpio binding support
References: <1337952980-14621-1-git-send-email-b29396@freescale.com> <1337952980-14621-6-git-send-email-b29396@freescale.com>
In-Reply-To: <1337952980-14621-6-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 07:36 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This patch implements a standard common binding for pinctrl gpio ranges.
> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
> under their pinctrl devices node with the format:
> <&gpio $gpio-specifier $pin_offset $count>
> while the gpio phandle and gpio-specifier are the standard approach
> to represent a gpio in device tree.
> Then we can cooperate it with the gpio xlate function to get the gpio number
> from device tree to set up the gpio ranges map.
> 
> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
> to parse and register the gpio ranges from device tree.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> Personally i'm not very satisfied with current solution due to a few reasons:
> 1) i can not user standard gpio api to get gpio number
> 2) i need to reinvent a new api of_parse_phandles_with_args_ext which i'm not
> sure if it can be accepted by DT maintainer.
> If i did not invent that API, i need to rewrite a lot of duplicated code
> with slight differences with the exist functions like of_get_named_gpio_flags
> and of_parse_phandle_with_args for the special pinctrl gpio maps format.
> 
> So i just sent it out first to see people's comment and if any better solution.
> 
> One alternative solution is that that the gpio-maps into two parts:
> pinctrl-gpios = <&gpio_phandle gpio-specifier ..>
> pinctrl-gpio-maps = <pin_id count ..>
> Then we can reuse the standard gpio api altough it's not better than the
> original one.

The problem I see with that is that it splits what is essentially a
single array with phandle+specifier+pin-id+count into two separate
arrays. Anyone reading/editing the DT needs to fully understand this,
and keep the entries in the two properties in the same order. Putting
everything into a single property makes this much more obvious to me. I
personally don't see any issue with the
of_parse_phandles_with_args_ext() function; it seems pretty clean to me.

> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c

> +	if (!nranges) {
> +		dev_err(pctldev->dev, "no gpio ranges found\n");
> +		return -ENODEV;
> +	}

In the case of a generic pinctrl IP block that can support an external
GPIO controller but happens not to be hooked up to one within a
particular SoC, that might not be an error. However, that situation is
pretty unlikely, so I think it's find to call dev_err() for now, and we
can change it later if we need.

> +		ranges[i].base = ranges[i].gc->of_xlate(ranges[i].gc, &gpiospec, NULL);

I believe Grant wants to change the of_xlate prototype in order to be
able to return a different gc value, so this will probably need slight
rework work with that change, once they're both approved. Still, I think
this is fine for now.

> +		if (ranges[i].base < 0) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		ranges[i].base += ranges[i].gc->base;
> +		ranges[i].pin_base = gpiospec.args[gpiospec.args_count - 2];
> +		ranges[i].npins = gpiospec.args[gpiospec.args_count - 1];
> +
> +		gpiochip_put(ranges[i].gc);

I wonder if this shouldn't happen until the pinctrl device is free'd,
and all the GPIO ranges are removed from it?

If we don't do that, I would argue that we shouldn't store ranges[i].gc,
since it might become invalid - I believe the only use of it is within
this function?

> +		of_node_put(gpiospec.np);
> +	}

Aside from the comments I've made, this series all seems reasonable.
There certainly are alternative ways of doing some of it, but I don't
see any other approach having any particular advantage over this one.
So, the series,

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
