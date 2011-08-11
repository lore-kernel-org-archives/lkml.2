Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1HKM3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:29:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46390 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab1HKM3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:29:08 -0400
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F38838966E@AUSP01VMBX24.collaborationhost.net>
References: <1312978655-18405-1-git-send-email-linus.walleij@stericsson.com>
	<ADE657CA350FB648AAC2C43247A983F001F38838966E@AUSP01VMBX24.collaborationhost.net>
Date: Thu, 11 Aug 2011 14:29:07 +0200
Message-ID: <CACRpkdabHj_C7wgGfu3g6LSsa2iMZS0h279wf6McOxfge9Gm_w@mail.gmail.com>
Subject: Re: [PATCH 10/19] mach-ep93xx: break out GPIO driver specifics
From: Linus Walleij <linus.walleij@linaro.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>, Ryan Mallon <rmallon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 7:23 PM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> On Wednesday, August 10, 2011 5:18 AM, Linus Walleij wrote:

> I'm a bit confused by the intentions of this patch.  Please see below.

The intentions are in path 0, in this case specifically to
let gpio.h be only about generic GPIO and gpiolib and
gpio-<foo>.h be platform and driver specifics.


>> diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
>> index c60f081..94c78bc 100644
>> --- a/arch/arm/mach-ep93xx/core.c
>> +++ b/arch/arm/mach-ep93xx/core.c
>> @@ -38,6 +38,7 @@
>>  #include <mach/fb.h>
>>  #include <mach/ep93xx_keypad.h>
>>  #include <mach/ep93xx_spi.h>
>> +#include <mach/gpio-ep93xx.h>
>
> Why is this additional include needed?  With your change to the ep93xx
> <mach/gpio.h> below, this header is already included by <linux/gpio.h>.

Yes, but it is included in <mach/gpio.h> because the quick
generic gpio macros in there use them, not because it
wants to expose symbols from <mach/gpio-ep93xx.h> to
the entire system, that is just a side effect due to
low encapsulation.

> Since this file actually uses the gpiolib calls, the include of
> <linux/gpio.h> is needed and appropriate.

Yes that one *also*.

Because you do both generic and driver-specific
operations.

The intention is not to minimize the number of #include<>
statements (if we want that we could always rely on
implicit includes from other files, which is an abomonation),
the intention is separation of concerns.

> Question... Shouldn't the gpio_to_irq and irq_to_gpio defines also be moved
> here?

These are currently part of the generic GPIO and gpiolib
since they are defined in <linux/gpio.h> :-/

We will get rid of them eventually but I cannot refactor
the entire universe at once.

>> -#define EP93XX_GPIO_LINE_EGPIO7              EP93XX_GPIO_LINE_A(7)
>> +/* new generic GPIO API - see Documentation/gpio.txt */
>
> Russell's patch removed this comment.  I don't see any reason to
> put it back.

My bad, fixing it up.

>> -/* GPIO port B.  */
>> -#define EP93XX_GPIO_LINE_B(x)                ((x) + 8)
>> -#define EP93XX_GPIO_LINE_EGPIO8              EP93XX_GPIO_LINE_B(0)
>> -#define EP93XX_GPIO_LINE_EGPIO9              EP93XX_GPIO_LINE_B(1)
>> -#define EP93XX_GPIO_LINE_EGPIO10     EP93XX_GPIO_LINE_B(2)
>> -#define EP93XX_GPIO_LINE_EGPIO11     EP93XX_GPIO_LINE_B(3)
>> -#define EP93XX_GPIO_LINE_EGPIO12     EP93XX_GPIO_LINE_B(4)
>> -#define EP93XX_GPIO_LINE_EGPIO13     EP93XX_GPIO_LINE_B(5)
>> -#define EP93XX_GPIO_LINE_EGPIO14     EP93XX_GPIO_LINE_B(6)
>> -#define EP93XX_GPIO_LINE_EGPIO15     EP93XX_GPIO_LINE_B(7)
>> +#include <asm-generic/gpio.h>
>
> I believe Russell's patch moves this include to arm's <asm/gpio.h>.
> Having it included here is a bit redundant.

Fixing it. My error.

>> +#include "gpio-ep93xx.h"
>
> Why this form?  Isn't <mach/gpio-ep93xx.h> the preferred form?

This is to make the inclusion very local. The only reason it is
included at all is to get EP93XX_GPIO_LINE_MAX_IRQ,
nothing else.

>> -/* maximum value for irq capable line identifiers */
>> -#define EP93XX_GPIO_LINE_MAX_IRQ     EP93XX_GPIO_LINE_F(7)
>> +#define gpio_get_value       __gpio_get_value
>> +#define gpio_set_value       __gpio_set_value
>> +#define gpio_cansleep        __gpio_cansleep

You didn't comment on this but it's yet another bug due to
bad rebasing. Fixing it. Thse should not be reintroduced.

>> diff --git a/arch/arm/mach-ep93xx/simone.c b/arch/arm/mach-ep93xx/simone.c
>> index 8392e95..1a472ff 100644
>> --- a/arch/arm/mach-ep93xx/simone.c
>> +++ b/arch/arm/mach-ep93xx/simone.c
>> @@ -18,12 +18,12 @@
>>  #include <linux/kernel.h>
>>  #include <linux/init.h>
>>  #include <linux/platform_device.h>
>> -#include <linux/gpio.h>
>>  #include <linux/i2c.h>
>>  #include <linux/i2c-gpio.h>
>>
>>  #include <mach/hardware.h>
>>  #include <mach/fb.h>
>> +#include <mach/gpio-ep93xx.h>
>
> Here I can kind of agree on the removal of <linux/gpio.h> and adding <mach/gpio-ep93xx.h>.
>
> This file does not use any of the gpiolib calls.  It just needs to pick up the defines
> for the two gpio pins used for the I2C bus.

Yes that's the idea.

> Still, it seems a bit awkward....

In what way?

> Same comment here. It's technically correct but it's seems awkward.

Define awkward.

I know you can get the same *implicitly* from <linux/gpio.h>
but that is the awkward problem we're trying to get rid of.

Eventually <linux/gpio.h> will *not* bring in *any* platform-
or driver-specific crap. Not today, but as soon as we get
somewhere with the single image concept.

Similarly, platforms with GPIO not using generic GPIO
or gpiolib at all have simply had their headers renamed
<mach/gpio-foo.h>.

Atleast that's my idea, I guess someone may smack my
fingers.

Thanks,
Linus Walleij
