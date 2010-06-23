Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab0FWF0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 01:26:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57908 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0FWF0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 01:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IFP8/qGQ3M7DbdgIFCBbqIkB84eBUppu/nFh9fb6fh+oBdplk9Fm5Gedp7PpoC7TPL
         waI80JfGoDO5183Uxi8LNweCF5p0qLc/n3+uyTiYUHcN0A64gz2QvQS10kxdc24fV0XR
         NHkqKSFsyLGQ7LOuBbOx/2fljmIZkk1Nv9ogU=
MIME-Version: 1.0
In-Reply-To: <4C21955D.1020502@bluewatersys.com>
References: <191168.5104.qm@web180308.mail.gq1.yahoo.com> <4C21955D.1020502@bluewatersys.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 23 Jun 2010 13:26:31 +0800
Message-ID: <AANLkTikEvq_qcOWaev79UbHFfWp7hnOil_q9x-QZuSlK@mail.gmail.com>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping 
	gpios)
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com,
       =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 1:02 PM, Ryan Mallon <ryan@bluewatersys.com> wrote:
> On 06/23/2010 04:37 PM, David Brownell wrote:
>>
>>
>> --- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com> wrote:
>>
>>
>>> gpiolib
>>
>>
>> Again, you're talking about "gpiolib" when
>> you seem to mean the GPIO framework itself
>> (for which gpiolib is only an implementation
>> option)...
>
> Fine, its just semantics. I think everyone knows what I mean when I
> refer to gpiolib.
>
>>> framework could be simplified for cansleep gpios.
>>>
>>> 'Can sleep' for a gpio has two different meanings depending
>>> on context
>>
>> NO; for the GPIO itself it's only ever had one
>> meaning, regardless of context.
>>
>> You're trying to conflate the GPIO and one
>> of the contexts in which it's used.  That's
>> the problem you seem to be struggling with.
>>
>> Please stop conflating/confusing
>> those two disparate concepts...
>
> I'm not. Some gpios, such as those on io expanders, may sleep in their
> implementations of the gpio_(set/get) functions.
>
> Drivers, which use a gpio, may call gpio_(set/get) functions for a given
> gpio from a context where it is not safe to sleep. In this case, a gpio
> which may sleep (ie one on an i2c io-expander) cannot be used with this
> driver. The gpio_request will succeed, but any call to
> gpio_(set/get)_value will produce a warning.
>
>>> example, if a driver calls gpio_get_value(gpio) from an
>>> interupt handler
>>> then the gpio must not be a sleeping gpio.
>>
>> In a threaded IRQ handler it's OK to use
>> the get_value_cansleep() option..
>
> Ugh, you are really twisting my words. replace 'interrupt handler' with
> 'non sleep safe context'.
>
>>>
>>> This patch introduces a new flag, FLAG_CANSLEEP, internal
>>> to gpiolib
>>
>> NAK; Superfluous; the gpio_chip already has
>> that information recorded.
>
> It has a different meaning, but I think you are still correct here. The
> might_sleep_if in gpio_(set/get)_value is only necessary if
> chip->cansleep is set.
>
>>
>>> new request function, gpio_request_cansleep, requests a
>>> gpio which may
>>> only be used from sleep possible contexts
>>
>> Also superfluous.
>
> Not so. In my opinion, it is better to have the gpio_request fail
> immediately if it is being used incorrectly. For example, say you have
> two gpios:
>
>  soc_gpio:    An SoC gpio which does not sleep on set/get
>  sleepy_gpio: An i2c io-expander gpio which may sleep on get/set
>
> and some driver code which does this:
>
>  gpio_request(gpio, "some_gpio");
>  ...
>  // Non-sleep safe context
>  gpio_set_value(gpio, 0);
>
> If you pass sleepy_gpio as the gpio to this driver the gpio_request will
> succeed, but you will get a warning on the gpio_set_value because its
> usage is incorrect.
>
> In my proposed change, the gpio_request would fail because sleepy_gpio
> might sleep, and therefore cannot be used by drivers which use gpios in
> non sleep safe context. Basically I am moving the cansleep part of the
> api from the usage of gpios to the registration time. In my opinion this
> is better because it means there is only one set of gpio_(set/get)_value
> calls and incorrect usage of sleeping gpios will be caught when the gpio
> is registered, not when it is used.
>
>>
>>  The existing
>>> gpio_request
>>> function requests a gpio, but does not allow it to be used
>>> from a
>>> context where sleep is not possible.
>>
>> Changing semantics of existing calls is a big
>> mess, and should be avoided even if it seems
>> appropriate.
>>
>> Since the request is just reserving a resource
>> that's already been identified (and which has
>> known characteristics, like whether the GPIO
>> value must be accessed only from sleeping
>> contexts), this call would also be superfluous.
>>
>> If you want to ensure the GPIO is a cansleep()
>> one, just check that before reserving it.  There
>> is no need for new calls to support that model;
>> it works today.
>
> Except that drivers do not do this.
>
>> (NAK...)
>>
>>
>>
>>> The benefits I see to this approach are:
>>>  ...
>>>  - The API is simplified by combining gpio_(set/get)_value
>>> and
>>> gpio_(set/get)_value_cansleep
>>
>>
>> You have a strange definition of "simplified"...
>>
>> Recognize that you're also proposing to remove
>> an API characteristic which much simplifies
>> code review:  you can look at calls and see
>> that because they're the cansleep() version,
>> they are unsafe in IRQ context ...
>
> Hmm, fair point.
>

My two cents, if it feels confused to use the _cansleep version, why don't
we just introduce an _atomic() version and use that in atomic situation,
since most usage of gpio API can actually _sleep_. I didn't read all the
scroll back, so if it's wrong, ignore me.
