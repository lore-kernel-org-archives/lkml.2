Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2EZQwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 12:52:34 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40403 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2EZQwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 12:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <4FBFBB74.901@wwwdotorg.org>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com>
	<1337952980-14621-6-git-send-email-b29396@freescale.com>
	<4FBFBB74.901@wwwdotorg.org>
Date: Sat, 26 May 2012 09:52:32 -0700
Message-ID: <CAA+hA=QMe6Yo2aLMBcbkYLDXSagb9L919hjdQaq8TyH4uKh9Mw@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] pinctrl: add pinctrl gpio binding support
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 10:03 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/25/2012 07:36 AM, Dong Aisheng wrote:
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> This patch implements a standard common binding for pinctrl gpio ranges.
>> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
>> under their pinctrl devices node with the format:
>> <&gpio $gpio-specifier $pin_offset $count>
>> while the gpio phandle and gpio-specifier are the standard approach
>> to represent a gpio in device tree.
>> Then we can cooperate it with the gpio xlate function to get the gpio number
>> from device tree to set up the gpio ranges map.
>>
>> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
>> to parse and register the gpio ranges from device tree.
>>
>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
>> ---
>> Personally i'm not very satisfied with current solution due to a few reasons:
>> 1) i can not user standard gpio api to get gpio number
>> 2) i need to reinvent a new api of_parse_phandles_with_args_ext which i'm not
>> sure if it can be accepted by DT maintainer.
>> If i did not invent that API, i need to rewrite a lot of duplicated code
>> with slight differences with the exist functions like of_get_named_gpio_flags
>> and of_parse_phandle_with_args for the special pinctrl gpio maps format.
>>
>> So i just sent it out first to see people's comment and if any better solution.
>>
>> One alternative solution is that that the gpio-maps into two parts:
>> pinctrl-gpios = <&gpio_phandle gpio-specifier ..>
>> pinctrl-gpio-maps = <pin_id count ..>
>> Then we can reuse the standard gpio api altough it's not better than the
>> original one.
>
> The problem I see with that is that it splits what is essentially a
> single array with phandle+specifier+pin-id+count into two separate
> arrays. Anyone reading/editing the DT needs to fully understand this,
> and keep the entries in the two properties in the same order. Putting
> everything into a single property makes this much more obvious to me. I
Yes, i agree with you.
That's why i insisted to send this format first.

> personally don't see any issue with the
> of_parse_phandles_with_args_ext() function; it seems pretty clean to me.
>
Thanks, you gave me some confidence on it.

>> diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
>
>> +     if (!nranges) {
>> +             dev_err(pctldev->dev, "no gpio ranges found\n");
>> +             return -ENODEV;
>> +     }
>
> In the case of a generic pinctrl IP block that can support an external
> GPIO controller but happens not to be hooked up to one within a
> particular SoC, that might not be an error. However, that situation is
> pretty unlikely, so I think it's find to call dev_err() for now, and we
> can change it later if we need.
>
>> +             ranges[i].base = ranges[i].gc->of_xlate(ranges[i].gc, &gpiospec, NULL);
>
> I believe Grant wants to change the of_xlate prototype in order to be
> able to return a different gc value, so this will probably need slight
> rework work with that change, once they're both approved. Still, I think
> this is fine for now.
>
I looked Grant's commit 3d0f7cf0f "gpio: Adjust of_xlate API to
support multiple GPIO
chips", it seemed i need make some changes here since
of_node_to_gpiochip is broken now
after support banked gpio. Thus the gc got here may not correct for
some special gpio
controllers.

>> +             if (ranges[i].base < 0) {
>> +                     ret = -EINVAL;
>> +                     goto out;
>> +             }
>> +             ranges[i].base += ranges[i].gc->base;
>> +             ranges[i].pin_base = gpiospec.args[gpiospec.args_count - 2];
>> +             ranges[i].npins = gpiospec.args[gpiospec.args_count - 1];
>> +
>> +             gpiochip_put(ranges[i].gc);
>
> I wonder if this shouldn't happen until the pinctrl device is free'd,
> and all the GPIO ranges are removed from it?
>
Hmm, that may bring some complexities since non-dt case also needs
to be covered if we do that...

> If we don't do that, I would argue that we shouldn't store ranges[i].gc,
> since it might become invalid - I believe the only use of it is within
> this function?
>
In my option, i think it's ok to store it since they're just some data
to describe
hw properties. The gpio function may become invalid but not data.
Is it reasonable to you?

>> +             of_node_put(gpiospec.np);
>> +     }
>
> Aside from the comments I've made, this series all seems reasonable.
> There certainly are alternative ways of doing some of it, but I don't
> see any other approach having any particular advantage over this one.
> So, the series,
>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Thanks.

Regards
Dong Aisheng
