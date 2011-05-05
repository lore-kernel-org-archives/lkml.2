Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1EESRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:17:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41990 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1EESQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:16:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6337"; a="89743814"
Message-ID: <4DC2E999.3080101@codeaurora.org>
Date: Thu, 05 May 2011 11:16:57 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

(modified re-send - previous email bounced off lkml)

On 5/2/2011 12:16 PM, Linus Walleij wrote:
> From: Linus Walleij<linus.walleij@linaro.org>
>
> This creates a subsystem for handling of pinmux devices. These are
> devices that enable and disable groups of pins on primarily PGA and
> BGA type of chip packages and common in embedded systems.
>
> This is being done to depopulate the arch/arm/* directory of such
> custom drivers and try to abstract the infrastructure they all
> need. See the Documentation/pinmux.txt file that is part of this
> patch for more details.
>
> Signed-off-by: Linus Walleij<linus.walleij@linaro.org>
> ---
[snip]
> +static struct pinmux_map pmx_mapping[] = {
> +	{
> +		.function = "spi0-1",
> +		.dev_name = "foo-spi.0",
> +	},
> +	{
> +		.function = "i2c0",
> +		.dev_name = "foo-i2c.0",
> +	},
> +};
> +
> +Since the above construct is pretty common there is a helper macro to make
> +it even more compact:
> +
> +static struct pinmux_map pmx_mapping[] = {
> +       PINMUX_MAP("spi0-1", "foo-spi.0"),
> +       PINMUX_MAP("i2c0", "foo-i2c.0"),
> +};
> +
This is great effort and provides a meaningful way for drivers to 
request for an entire group of pin configs rather than individual pin 
settings.
But, the msm tree has a bit more configurations options.
1) For power management we need to specify multiple configs for a 
particular pin. When we boot we have these low power settings for each pin.
     Once the driver needs to use a particular device - it can call to 
install the active/enable settings for that pin.
     Also,  sometimes a pin needs to be configured for alternate usage. 
How can we use this patch to have multiple configs that can be stored in 
the pinmux_map and apply it as needed?
     From your previous gpio_config patch - we could pass in a setting 
for a pin and have it routed through gpiolib.

2) Currently writing the settings (map) for each pin involves just a 
register address and the bits to be toggled. (is this right, or am I 
missing something ?)
     But for the msm - we have different options and possibly different 
register bits to be toggled for selecting a FUNC_SEL , changing the 
Drive Strength and the PULL and for setting the pin as an output/input 
line etc.
     How do we specify a meaningful setting and accomplish multiple 
register writes using your patch ?

3) Each board has upto 200 pins - and with a slight modification to each 
board in hardware, our pinmuxes are modified. So, most likely our pin 
configurations originate (maintained) at the board level. Would it stay 
same in this implementation or we would have to migrate all the config 
information into drivers/pinmux ?

I had upstreamed some patches related to msm gpiomux which provide an 
idea on what we were moving to. Going forward, we would like to use this 
generic library, but is there a way we can bridge this gap?

> +The dev_name here matches to the unique device name that can be used to look
> +up the device struct (just like with clockdev or regulators). The function name
> +must match a function provided by the pinmux driver handling this pin range.
> +You register this pinmux mapping to the pinmux subsystem by simply:
> +
> +       ret = pinmux_register_mappings(&pmx_mapping, ARRAY_SIZE(pmx_mapping));
> +
> +

Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

