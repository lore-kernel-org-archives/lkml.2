Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0IGDyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 23:54:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59732 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0IGDy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 23:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xbgmozmTNU/8nUJY3++U3JhXUaqFnAJJnQv2/ZeWOGPWvI1yTT2/RKXm9P/P08gTeu
         YLtTbEbIwnwnFPFHLUNbnUhbodPsLcYjw7pjkbb8Oh/g3YrPyX+zn5JAQKEXmbgfsxrD
         VzQgXgAKD/xc5SaDY8+wyxyQ2QtARyIqTn5/o=
MIME-Version: 1.0
In-Reply-To: <4C85A71F.3010402@bluewatersys.com>
References: <280328.53116.qm@web180311.mail.gq1.yahoo.com> <4C85A71F.3010402@bluewatersys.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 7 Sep 2010 11:54:06 +0800
Message-ID: <AANLkTi=B7O9jDB_pzHS6feWTxHQTfDZ-QLx7jOKaA2vN@mail.gmail.com>
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com, bn@niasdigital.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 10:44 AM, Ryan Mallon <ryan@bluewatersys.com> wrote:
> On 09/07/2010 02:23 PM, David Brownell wrote:
>> Still not liking or accepting this proposed
>> change to the GPIO framework.
>>
>> For the AT91 case (where integers 0..N are
>> IRQs, but N..max are GPIOs)
>>
>> A simpler solution is just to use a bit in
>> the integer to indicate IRQ vs GPIO.  Like
>> maybe the sign bit.. which is never set on
>> valid GPIO numbers, but platforms could let
>> be set on IRQs.
>>
> How about this approach instead?
>

This doesn't solve the problem with more complicated settings, e.g.
some GPIOs within are not valid, not just the begining ones.

So the real question here is the semantics of gpio_is_valid(). I'd
personally incline it reads as if a GPIO _number_ is valid generally,
(e.g. like -1 is not a valid GPIO number), instead of that specific
GPIO is valid on that specific platform. The latter can be judged
with gpio_request().

> ----
> On some architectures gpio numbering does not start from zero. Allow for
> correct behaviour of gpio_is_valid on values below the first gpio by
> adding the architecture overrideable ARCH_FIRST_GPIO.
>
> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> ----
>
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index c7376bf..01aab1f 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -22,10 +22,15 @@
>  #define ARCH_NR_GPIOS          256
>  #endif
>
> +#ifndef ARCH_FIRST_GPIO
> +#define ARCH_FIRST_GPIO                0
> +#endif
> +
>  static inline int gpio_is_valid(int number)
>  {
>        /* only some non-negative numbers are valid */
> -       return ((unsigned)number) < ARCH_NR_GPIOS;
> +       return (number >= ARCH_FIRST_GPIO &&
> +               (unsigned)number < ARCH_NR_GPIOS;
>  }
>
>  struct device;
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
