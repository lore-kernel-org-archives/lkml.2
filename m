Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2LaNIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 08:08:32 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44399 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2LaNIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 08:08:31 -0500
Message-ID: <50E18E4B.7000107@collabora.co.uk>
Date: Mon, 31 Dec 2012 14:08:27 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-leds@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] leds: leds-gpio: set devm_gpio_request_one() flags
 correctly
References: <1356102464-22234-1-git-send-email-javier.martinez@collabora.co.uk> <CALF0-+XM4EZJHU360AUAUFBPctwO81JQ7kUiH12V2n6x7wCXfA@mail.gmail.com>
In-Reply-To: <CALF0-+XM4EZJHU360AUAUFBPctwO81JQ7kUiH12V2n6x7wCXfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 06:06 PM, Ezequiel Garcia wrote:
> On Fri, Dec 21, 2012 at 12:07 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> commit a99d76f leds: leds-gpio: use gpio_request_one
>>
>> changed the leds-gpio driver to use gpio_request_one() instead
>> of gpio_request() + gpio_direction_output()
>>
>> Unfortunately, it also made a semantic change that breaks the
>> leds-gpio driver.
>>
>> The gpio_request_one() flags parameter was set to:
>>
>> GPIOF_DIR_OUT | (led_dat->active_low ^ state)
>>
>> Since GPIOF_DIR_OUT is 0, the final flags value will just be the
>> XOR'ed value of led_dat->active_low and state.
>>
>> This value were used to distinguish between HIGH/LOW output initial
>> level and call gpio_direction_output() accordingly.
>>
>> With this new semantic gpio_request_one() will take the flags value
>> of 1 as a configuration of input direction (GPIOF_DIR_IN) and will
>> call gpio_direction_input() instead of gpio_direction_output().
>>
>> int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
>> {
>> ..
>>         if (flags & GPIOF_DIR_IN)
>>                 err = gpio_direction_input(gpio);
>>         else
>>                 err = gpio_direction_output(gpio,
>>                                 (flags & GPIOF_INIT_HIGH) ? 1 : 0);
>> ..
>> }
>>
>> The right semantic is to evaluate led_dat->active_low ^ state and
>> set the output initial level explicitly.
>>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>>
>> This makes LEDs to work again on my IGEPv2 board (TI OMAP3 based SoC).
>>
>> I sent this patch before but then realized that I only cc'ed to linux-leds.
>> So, I'm resending the patch cc'ing linux-omap,linux-arm-kernel and LKML to
>> reach a broader audience and have more people review/test the patch.
>>
>> Sorry for the noise if someone got it twice.
>>
>>  drivers/leds/leds-gpio.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
>> index 1885a26..a0d931b 100644
>> --- a/drivers/leds/leds-gpio.c
>> +++ b/drivers/leds/leds-gpio.c
>> @@ -127,8 +127,9 @@ static int create_gpio_led(const struct gpio_led *template,
>>                 led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
>>
>>         ret = devm_gpio_request_one(parent, template->gpio,
>> -                       GPIOF_DIR_OUT | (led_dat->active_low ^ state),
>> -                       template->name);
>> +                                   (led_dat->active_low ^ state) ?
>> +                                   GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
>> +                                   template->name);
>>         if (ret < 0)
>>                 return ret;
>>
>> --
>> 1.7.7.6
>>
> 
> Without this patch my IGEP v2 LEDs were dead,
> and this patch brings them back.
> 
> Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> 
> Thanks,
> 
>     Ezequiel
> 

Hello,

Any news on this?

GPIO LEDs support is still not working on latest mainline kernel and other
people report that this patch solves the issue for them.

Thanks a lot and best regards,
Javier
