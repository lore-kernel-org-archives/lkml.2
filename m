Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2LKLib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:38:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:34685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab2LKLia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:38:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,258,1355126400"; 
   d="scan'208";a="179354432"
Message-ID: <50C71BC3.2090006@linux.intel.com>
Date: Tue, 11 Dec 2012 13:40:51 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1] gpio: add Lynxpoint chipset gpio driver.
References: <1354888899-21907-1-git-send-email-mathias.nyman@linux.intel.com> <1354888899-21907-2-git-send-email-mathias.nyman@linux.intel.com> <20121210230749.7820F3E081F@localhost>
In-Reply-To: <20121210230749.7820F3E081F@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 01:07 AM, Grant Likely wrote:
> On Fri,  7 Dec 2012 16:01:39 +0200, Mathias Nyman<mathias.nyman@linux.intel.com>  wrote:
>> Add gpio support for Intel Lynxpoint chipset.
>> Lynxpoint supports 94 gpio pins which can generate interrupts.
>> Driver will fail requests for pins that are marked as owned by ACPI, or
>> set in an alternate mode (non-gpio).
>>
>> Signed-off-by: Mathias Nyman<mathias.nyman@linux.intel.com>
>> ---
>> +static void lp_gpio_set(struct gpio_chip *chip, unsigned gpio, int value)
>> +{
>> +	struct lp_gpio *lg = container_of(chip, struct lp_gpio, chip);
>> +	unsigned long reg = gpio_reg(chip, gpio, LP_CONFIG1);
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&lg->lock, flags);
>> +
>> +	if (value)
>> +		outl(inl(reg) | OUT_LVL_BIT, reg);
>> +	else
>> +		outl(inl(reg)&  ~OUT_LVL_BIT, reg);
>> +
>> +	spin_unlock_irqrestore(&lg->lock, flags);
>> +}
>
> A *lot* of drivers implement their own GPIO ops like this, and they all
> end up looking the same. Please take a look at
> drivers/gpio/gpio-generic.c and see if you can use the stock operations
> provided there.
>
> g.
>

Look quite similar but turns out the only potential generic ones which 
could be used are the bgpio_set() and bgpio_get() funtions. Using them 
would require custom pin2mask, write_reg, read_reg, etc functions.
bgpio_set_direction

I guess using gpio-generic code fits memory mapped devices better. 
Trying to use it for io port devices would require a lot of code mangling.

-Mathias
