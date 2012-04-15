Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2DOPUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 11:20:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39050 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab2DOPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 11:20:51 -0400
Message-ID: <4F8AE761.6000205@openwrt.org>
Date: Sun, 15 Apr 2012 17:21:05 +0200
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>, ralf@linux-mips.org,
        linux-mips@linux-mips.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gpio/MIPS/OCTEON: Add a driver for OCTEON's on-chip
 GPIO pins.
References: <1334275820-7791-1-git-send-email-ddaney.cavm@gmail.com> <1334275820-7791-3-git-send-email-ddaney.cavm@gmail.com> <4F87F868.1080804@openwrt.org> <4F885185.3070005@gmail.com>
In-Reply-To: <4F885185.3070005@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/04/2012 18:17, David Daney a écrit :
> On 04/13/2012 02:56 AM, Florian Fainelli wrote:
>> Hi David,
>>
> [...]
>>> +/*
>>> + * The address offset of the GPIO configuration register for a given
>>> + * line.
>>> + */
>>> +static unsigned int bit_cfg_reg(unsigned int gpio)
>>> +{
>>> + if (gpio< 16)
>>> + return 8 * gpio;
>>> + else
>>> + return 8 * (gpio - 16) + 0x100;
>>> +}
>>
>> You could explicitely inline this one, though the compiler will
>> certainly do it by itself.
>>
>
> I always let the compiler decide.
>
>
> [...]
>>> +
>>> + if (OCTEON_IS_MODEL(OCTEON_CN66XX) ||
>>> + OCTEON_IS_MODEL(OCTEON_CN61XX) ||
>>> + OCTEON_IS_MODEL(OCTEON_CNF71XX))
>>> + chip->ngpio = 20;
>>> + else
>>> + chip->ngpio = 16;
>>
>> What about getting the number of gpios from platform_data and/or device
>> tree?
>>
>
> Actually I am thinking about just setting it to 20 unconditionally.
> Anything requesting a non-present GPIO pin is buggy to begin with.

Since it is exposed by the sysfs entry ngpio, you can consider it being 
part of the ABI, and it can be used by an user to query the number of 
gpios available, and will also serve as the maximum number of gpios for 
gpiolib internally, it is certainly best to make it match what the 
hardware can actually do.

>
>>> +
>>> + chip->direction_input = octeon_gpio_dir_in;
>>> + chip->get = octeon_gpio_get;
>>> + chip->direction_output = octeon_gpio_dir_out;
>>> + chip->set = octeon_gpio_set;
>>> + err = gpiochip_add(chip);
>>> + if (err)
>>> + goto out;
>>> +
>>> + dev_info(&pdev->dev, "version: " DRV_VERSION "\n");
>>> +out:
>>> + return err;
>>> +}
>>> +
>>> +static int __exit octeon_gpio_remove(struct platform_device *pdev)
>>> +{
>>> + struct gpio_chip *chip = pdev->dev.platform_data;
>>> + return gpiochip_remove(chip);
>>> +}
>>> +
>>> +static struct of_device_id octeon_gpio_match[] = {
>>> + {
>>> + .compatible = "cavium,octeon-3860-gpio",
>>> + },
>>> + {},
>>> +};
>>> +MODULE_DEVICE_TABLE(of, octeon_mgmt_match);
>>
>> You are using linux/of.h definitions here but you did not include it.
>> Also, there is a typo, you want octeon_gpio_match instead.
>>
>
> Good catch. I will fix that. There is also a section mismatch I need to
> fix.

