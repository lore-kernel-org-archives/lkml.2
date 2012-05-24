Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2EXBmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:42:31 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37151 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2EXBma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:42:30 -0400
MIME-Version: 1.0
In-Reply-To: <4FBD4C13.8080209@wwwdotorg.org>
References: <1337779362-31259-1-git-send-email-b29396@freescale.com>
	<1337779362-31259-3-git-send-email-b29396@freescale.com>
	<4FBD4C13.8080209@wwwdotorg.org>
Date: Thu, 24 May 2012 09:42:29 +0800
Message-ID: <CAA+hA=Rb1Qix67QBthPjo_4d5ATWjA7pePembZRwJkPMtQNpjg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 3/3] pinctrl: add pinctrl gpio binding support
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dong Aisheng <b29396@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 4:44 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/23/2012 07:22 AM, Dong Aisheng wrote:
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> This patch implements a standard common binding for pinctrl gpio ranges.
>> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
>> under their pinctrl devices node with the format:
>> <&gpio $gpio_offset $pin_offset $npin>.
>>
>> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
>> to parse and register the gpio ranges from device tree.
>>
>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
>
> This is mostly good. Just a few comments:
>
>> +gpio-maps: 4 integers array, each entry in the array represents a gpio
>> +range with the format: <&gpio $gpio_offset $pin_offset $count>
>> +- gpio: phandle pointing at gpio device node
>> +- gpio_offset: integer, the local offset of $gpio
>> +- pin_offset: integer, the pin offset or pin id
>> +- npins: integer, the gpio ranges starting from pin_offset
>
> This uses a single cell to represent a GPIO ID within a GPIO controller.
> The standard GPIO bindings use #gpio-cells, where that's a property in
> the GPIO controller's node. I wonder if we shouldn't do the same here,
> and call into the GPIO driver to parse #gpio-cells and give back the
> Linux GPIO ID, just like of_get_named_gpio_flags() does. This would also
> make this code able to cope with the GPIO of_xlate function returning a
> different GPIO chip, which Grant put in place for banked GPIO controllers.
>
I checked the code, the second cell only represents gpio flag in
of_gpio_simple_xlate which seems meaningless to pinctrl, so it looks
increase overhead to pinctrl gpio ranges map.
However, it seems i may have to agree that we need keep align with the
exist of gpio design to use the standard way to get gpio number via
of_xlate function rather than do it privately in pinctrl driver.

One disadvantage is that i can not reuse of_get_named_gpio_flags due
to different format
for gpio-maps, i may have to write a slightly different one as
of_get_named_gpio_flags
for gpio-maps.

>> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
>
>> +int pinctrl_dt_add_gpio_ranges(struct pinctrl_dev *pctldev,
>
> The locking I was talking about before is between the following line:
>
>> +             ranges[i].gc = of_node_to_gpiochip(np_gpio);
>
> and this code:
>
>> +             ranges[i].name = dev_name(pctldev->dev);
>> +             ranges[i].base = ranges[i].gc->base + gpio_offset;
>> +             ranges[i].pin_base = pin_offset;
>> +             ranges[i].npins = npins;
>
> If of_node_to_gpiochip() doesn't mark the GPIO chip as "in use", then
> the module that provides that device could be unloaded between the two
> blocks of code above.
>
Correct.

> Re: your locking comments in your other email: ranges[i].gc doesn't
> appear to be used anywhere else in pinctrl, so I think it's OK not to
> lock the GPIO chip for any more time than between the above two blocks
> of code.
>
So i will add lock between them like:
ranges[i].gc = of_node_to_gpiochip(np_gpio);
if (!try_module_get(ranges[i].gc->owner))
    err...
ranges[i].name = dev_name(pctldev->dev);
ranges[i].base = ranges[i].gc->base + gpio_offset;
ranges[i].pin_base = pin_offset;
ranges[i].npins = npins;
module_put(ranges[i].gc->owner)
If anything wrong please let me know.

> Finally, just a minor nit:
>
>> +             ranges[i].gc = of_node_to_gpiochip(np_gpio);
>> +             if (!ranges[i].gc) {
>> +                     dev_err(pctldev->dev,
>> +                             "can not find gpio chip of node(%s)\n",
>> +                             np_gpio->name);
>> +                     of_node_put(np_gpio);
>> +                     return -EPROBE_DEFER;
>> +             }
>> +
>> +             of_node_put(np_gpio);
>
> could be slightly simpler:
>
> +               ranges[i].gc = of_node_to_gpiochip(np_gpio);
> +               of_node_put(np_gpio); <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
> +               if (!ranges[i].gc) {
> +                       dev_err(pctldev->dev,
> +                               "can not find gpio chip of node(%s)\n",
> +                               np_gpio->name);
Because here still uese np_gpio,  Can i still use it after of_node_put?

> +                       return -EPROBE_DEFER;
> +               }

Regards
Dong Aisheng
