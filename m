Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1IUJRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:17:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50721 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1IUJRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:17:24 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B7321751@HQMAIL01.nvidia.com>
References: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321751@HQMAIL01.nvidia.com>
Date: Wed, 21 Sep 2011 11:17:23 +0200
Message-ID: <CACRpkdZyhkydTutHXfry_dUPK_Ts_jq+5VHcr8XdgrHSExTyww@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v7
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 11:58 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Friday, September 16, 2011 6:13 AM:
>> This creates a subsystem for handling of pin control devices.
>> These are devices that control different aspects of package
>> pins.
>
> I've read through the documentation and header files, but not the .c files,
> and this looks almost perfect as far as I can tell right now. I'll try to
> review the .c files sometime too.

Great, I'm hunting your Acked-by/Reviewed-by ...

I will likely request inclusion into linux-next soon-ish.

> I just have one comment:
>
>> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
> ...
>> +/* External interface to pinmux */
>> +extern int pinmux_request_gpio(unsigned gpio);
>> +extern void pinmux_free_gpio(unsigned gpio);
>> +extern struct pinmux * __must_check pinmux_get(struct device *dev, const char *name);
>> +extern void pinmux_put(struct pinmux *pmx);
>> +extern int pinmux_enable(struct pinmux *pmx);
>> +extern void pinmux_disable(struct pinmux *pmx);
>> +extern int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data);
>
> That definition of pinmux_config doesn't seem as useful as it could be;

It should be removed. It's just there in the header file, I killed off
the implementation because specific control of a mux doesn't make
sense. We want to do stuff to pin groups directly, not related to
muxing, so that kind of thing needs to be in the generic pinctrl
interface.

> I'd like the ability to execute pinmux_config on a /named/ group, and I
> can certainly see a use-case for applying it to /named/ pins too.

That sounds correct to me.

To abstract things the stuff we can do with the group should be
something enumerated too. So:

pinctrl_config_group(const char *pinctrl_device, const char *group,
const char *mode);
pinctrl_config_pin(const char *pinctrl_device, int pin, const char *mode);

So the driver need an API to enumerate pin and group modes.

I might want to save this thing for post-merge of the basic API and
pinmux stuff though so we don't try to push too much upfront
design at once.

> The issues with applying pinmux_config to a mapping table entry are:
>
> * When there are multiple mapping table entries referenced by one
> pinmux_get, you don't necessarily want to apply the same configuration
> to all of the groups; think of a bus with a combination of low-speed
> output control signals and high-speed input data signals or something
> like that.
>
> * When muxing works in groups, you may want to apply the configuration
> to individual pins rather than the whole groups using in the mapping
> table.

Yeah, we kill this old interface.

Thanks,
Linus Walleij
