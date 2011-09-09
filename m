Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1IIFbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 01:31:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62300 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab1IIFbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 01:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110908210732.2a85c0f7.akpm@linux-foundation.org>
References: <1314747592-20975-1-git-send-email-david.daney@cavium.com>
	<20110908183544.414f3add.akpm@linux-foundation.org>
	<CA+7tXiiHBsFYwSY5VRY=HQ40+TkBhHm0K5uT_=0-UW2Mx=r6vg@mail.gmail.com>
	<20110908210732.2a85c0f7.akpm@linux-foundation.org>
Date: Thu, 8 Sep 2011 22:30:58 -0700
Message-ID: <CA+7tXih+4A_JDCHcN1VOVeKjapEfY9aYwCG4cBiHX1iWXb_ECw@mail.gmail.com>
Subject: Re: [PATCH] leds/of: leds-gpio.c: Use gpio_get_value_cansleep() when initializing.
From: Trent Piepho <tpiepho@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 9:07 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 8 Sep 2011 20:54:55 -0700 Trent Piepho <xyzzy@speakeasy.org> wrote:
>> On Thu, Sep 8, 2011 at 6:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > gpio_get_value() is an architecture-specific function whereas
>> > gpio_get_value_cansleep() is not.  Hence all architectures will now be
>> > forced to use the same code.  Why is this OK?
>
>> The non-cansleep version is only supposed to be different from
>>  gpio_get_value() (which is virtually the same code) in that it can
>> inline a fast gpio operation.  So calling cansleep vs the non-cansleep
>> shouldn't result in any change that would break anything.  If it did
>> it would be flaw in that architecture's version of gpio_get_value().
>> It should just mean a call that could be inlined won't be.
>>
>> I suppose one could ask if gpio_get_value_cansleep() needs to exist.
>
> Here's the unicore gpio_get_value():
>
> : static inline int gpio_get_value(unsigned gpio)
> : {
> :       if (__builtin_constant_p(gpio) && (gpio <= GPIO_MAX))
> :               return readl(GPIO_GPLR) & GPIO_GPIO(gpio);
> :       else
> :               return __gpio_get_value(gpio);
> : }
>
> And here's gpio_get_value_cansleep()
>
> int gpio_get_value_cansleep(unsigned gpio)
> {
>        struct gpio_chip        *chip;
>        int value;
>
>        might_sleep_if(extra_checks);
>        chip = gpio_to_chip(gpio);
>        value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
>        trace_gpio_value(gpio, 1, value);
>        return value;
> }
>
> They're very different.  Why is it OK to replace one with the other??

What's supposed to happen is chip->get() will be a method that does
"readl(GPIO_GPLR) & GPIO_GPIO(gpio);" or whatever the inlined bit in
gpio_get_value() is.  So calling gpio_get_value_cansleep() should
still get the correct value for the gpio.  It just won't be an inlined
register read anymore.

For instance, all the arch versions that use builtin_constant_p() will
not take the inline path, since the gpio number if obviously not a
constant when gpio_get_value() is called in this leds function.  So
they inline into a call to __gpio_get_value().  Which as you've
pointed out is nearly exactly the same as gpio_get_value_cansleep().
The only change is debugging related, that of the might_sleep_if() to
a WARN_ON().

One could have:
static inline int __gpio_get_value(gpio) { return
_gpio_get_value(gpio, GFP_ATOMIC); }
static inline int gpio_get_value_cansleep(gpio) { return
_gpio_get_value(gpio, GFP_KERNEL); }

Then _gpio_get_value(gpio, context) would be the current code that's
common to both __gpio_get_value() and gpio_get_value_cansleep(),
except it uses context solely to spit a warning if the gpio can't be
done from the requested context or if the context isn't allowable from
whence the call was made.

And then one would ask if all this complexity in the interface is
really the best way to throw warnings about sleeping in atomic
context?  Because if there was a better way to do that, we could just
s/(gpio_get_value)_cansleep/\1/g and not worry about these someone
did/didn't call cansleep() when they should done the opposite patches.

>> > Asides:
>> >
>> > The duplication of code between  gpio_get_value() and
>> > gpio_get_value_cansleep() is daft.
>> >
>> > The comment over gpio_get_value_cansleep() sucks mud rocks.
>
> Preserving this...

Well, inlining code that sits on a waitq doesn't make a lot of sense.
