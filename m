Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2KIFuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:50:24 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6834 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2KIFuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:50:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 08 Nov 2012 21:50:18 -0800
Message-ID: <509C990D.50008@nvidia.com>
Date: Fri, 9 Nov 2012 11:17:57 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] gpio: tegra: read output value when gpio is set in direction_out
References: <1352356047-24817-1-git-send-email-ldewangan@nvidia.com> <509BE4AD.30701@wwwdotorg.org>
In-Reply-To: <509BE4AD.30701@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012 10:28 PM, Stephen Warren wrote:
> On 11/07/2012 11:27 PM, Laxman Dewangan wrote:
>> Read the output value when gpio is set for the output mode for
>> gpio_get_value(). Reading input value in direction out does not
>> give correct value.
> That's an unfortunate HW design, but oh well. Do you have any idea why
> reading the input register doesn't work? If you look at the Tegra20 TRM,
> page 666 figure 32 "SFIO/GPIO Pin Multiplexing Architecture", there's
> not indication that the input path wouldn't work if the output path is
> active. Perhaps the issue is in the GPIO module not the pinmux module?
>

I think this is in the gpio controller design. I again check this in 
cardhu wih dumping gpio registers
Bank:Port CNF OE OUT IN INT_STA INT_ENB INT_LVL
2:2       1c  18 08 04 00 00 000000

GPIO pin2,pin3 and pin4 are in gpio mode.
GPIO pin 3 and pin4 are in output mode and pin2 is in input mode.
Set the output to 1 for pin3 and reading back through gpio_in register 
for this pin, it is showing as 0, not 1.


>> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c
>>   static int tegra_gpio_get(struct gpio_chip *chip, unsigned offset)
>>   {
>> +	int bit_val = BIT(GPIO_BIT(offset));
>> +
>> +	/* If gpio is in output mode then read from the out value */
>> +	if (tegra_gpio_readl(GPIO_OE(offset))&  bit_val)
>> +		return !!(tegra_gpio_readl(GPIO_OUT(offset))&  bit_val);
>> +
>>   	return (tegra_gpio_readl(GPIO_IN(offset))>>  GPIO_BIT(offset))&  0x1;
>>   }
> Any chance of using the same kind of logic to isolate the bit value? One
> branch above does !!(val&  mask) and the other (val>>  shift)&  1.

It was going to more than 80 column and hence I did like this.  Let me 
respin this patch to have same kind of.
