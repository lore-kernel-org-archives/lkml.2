Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2GXNE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:04:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53181 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2GXNE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:04:58 -0400
Message-ID: <500E9D75.60002@gmail.com>
Date: Tue, 24 Jul 2012 15:04:53 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] gpiolib: fix chip->base handling in of_gpio_simple_xlate()
References: <1342977052-7880-1-git-send-email-zonque@gmail.com> <500D632B.3000206@gmail.com> <201207241256.56535.arnd@arndb.de>
In-Reply-To: <201207241256.56535.arnd@arndb.de>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 24.07.2012 14:56, Arnd Bergmann wrote:
> On Monday 23 July 2012, Daniel Mack wrote:
>> (Cc: Arnd)
>>
>> On 22.07.2012 19:10, Daniel Mack wrote:
>>> of_gpio_simple_xlate() is called for each chip when a GPIO is looked up.
>>> When registering several chips off the same DT node (with different pin
>>> offsets) however, the lookup fails as the GPIO number passed in to
>>> of_gpio_simple_xlate() is likely higher than the chip's ->ngpio value.
>>>
>>> Fix that by taking into account the chip's ->base value, and return the
>>> relative offset of the pin inside the chip.
>>>
>>> Signed-off-by: Daniel Mack <zonque@gmail.com>
>>> Cc: Grant Likely <grant.likely@secretlab.ca>
>>> Cc: Linus Walleij <linus.walleij@stericsson.com>
>>> ---
>>>
>>> I'm currently porting the PXA pieces over to DT, and stumbled over what
>>> looks like an obvious bug to me. Correct me if I'm mistaken, but I see
>>> no reason why one shouldn't be able to instanciate several GPIO chips
>>> from a single DT node.
> 
> But why would you do that? Both the "gpiochip" and its DT representation
> attempt to represent the hardware structure. If they don't match, then
> I'd assume one of them is wrong ;-)

Well, have a look at what's currently there in drivers/gpio/gpio-pxa.c.
There are several gpio_chips that are registered. On the DT side,
however, I would much like to present all GPIO line in one array, so the
numbers match the hardware documentation.

I prepared patches for all that and they work find, the only thing I
need to touch in the core for that is this minor detail.

> 
>>> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
>>> index d18068a..51bc232 100644
>>> --- a/drivers/gpio/gpiolib-of.c
>>> +++ b/drivers/gpio/gpiolib-of.c
>>> @@ -147,13 +147,13 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
>>>  	if (WARN_ON(gpiospec->args_count < gc->of_gpio_n_cells))
>>>  		return -EINVAL;
>>>  
>>> -	if (gpiospec->args[0] >= gc->ngpio)
>>> +	if (gpiospec->args[0] >= gc->ngpio + gc->base)
>>>  		return -EINVAL;
>>>  
>>>  	if (flags)
>>>  		*flags = gpiospec->args[1];
>>>  
>>> -	return gpiospec->args[0];
>>> +	return gpiospec->args[0] - gc->base;
>>>  }
>>>  EXPORT_SYMBOL(of_gpio_simple_xlate);
> 
> Where would that gc->base come from?

It is set up when the chips are initialized. Let's put it that way: why
would we have this ->base if it is practically unusable in devicetree
environments?

And In case ->base equals 0, this patch is a no-op anyway.


Thanks,
Daniel
