Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0F2I3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:29:22 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57374 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab0F2I3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GvNSujYm5JILtd2oxAVTyHY3sgRfZnOiJKRpPkvjDhJG1dO82V30F9bKo1iomsoUeu
         gqsC6h79Wqqd7PUZvPYhoZfS/t0MVQmgSj2lDR1Oj9Cgn8pUqIZjTpIaA7xxKc1YgMoa
         DwcIivfR2fjcqJ/pFBW8OqMLUYrbCXy2h78C0=
MIME-Version: 1.0
In-Reply-To: <4C1E88AE.5070808@bluewatersys.com>
References: <386783.17931.qm@web180310.mail.gq1.yahoo.com> 
	<4C1E88AE.5070808@bluewatersys.com>
From: CoffBeta <coffbeta@gmail.com>
Date: Tue, 29 Jun 2010 16:29:04 +0800
Message-ID: <AANLkTinunR-mrXFh8uLV5YfeArC-_A1NJWz708n7r4pU@mail.gmail.com>
Subject: Re: gpiolib and sleeping gpios
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com,
       =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 non-sleeping

On Mon, Jun 21, 2010 at 05:31, Ryan Mallon <ryan@bluewatersys.com> wrote:
> On 06/19/2010 06:21 PM, David Brownell wrote:
>>
>>>
>>> The runtime warnings will only show instances where the
>>> non-sleeping
>>> versions where called instead of the sleeping versions.
>>
>> ... *AND* the GPIO requires the cansleep() version...
>>
>> Right; such calls are errors.  We issue
>> warnings since fault returns are inapplicable.
>
> A driver which only uses the non-sleeping versions, but _could_ use the
> cansleep variants (ie all calls to gpio_(set/get)_value are made from
> contexts where it is possible to sleep) is not so easy to spot. Passing
> a sleeping to gpio to such a driver will result in spurious warnings.
>
>>> There is no
>>> warning to say that we are calling the spinlock safe
>>> version, where it is possible to sleep.
>>
>> The call context isn't what controls whether
>> gpio_get_value() or gpio_get_value_cansleep()
>> is appropriate ... it's the GPIO itself, and
>> how its implementation works.
>
> No, a driver should not know anything about a gpio which is passed to
> it. If a driver is able to call the cansleep variants, then it should,
> and it will allow any gpio, sleeping or non-sleeping, to be used with
> that driver.
>
> If a driver uses a gpio in such a way that it cannot sleep, ie the
> gpio_(get/set)_value calls are made from spinlock context, then only
> gpios which do not sleep may be used with that driver.
>
> Thats why I think specifying whether the gpio is able to sleep when it
> is requested is a good idea. A driver which cannot use a sleeping gpio
>
>
>> "possible to sleep" is a GPIO attribute,
>> exposed by a predicate.  If spinlock-safe
>> calls are used on GPIOs with that attribute,
>>  a warning *IS* issued.
>
> Possible to sleep is also an attribute of how a driver _uses_ a gpio.
>
>>>
>>> The point I was trying to make is that there are lots of
>>> drivers which
>>> will not work with gpios on sleeping io expanders because
>>> they call the
>>> spinlock safe gpio calls.
>>
>> And they will trigger runtime warnings, and
>> thus eventually get fixed.  The way to do that
>> is to check if the GPIO needs the cansleep()
>> call
>
> Hmm, maybe this then for drivers which cannot accept sleeping gpios:
>
>  if (gpio_cansleep(some_gpio)) {
>          dev_err(&dev, "This driver only supports non-sleeping gpios");
>          return -EINVAL;
>  }
>
>  err = gpio_request(some_gpio, "some_gpio");
>
> I think ideally, gpio_request should specify this via a flags argument, ie:
>
>  #define GPIOF_NO_SLEEP        0x0
>  #define GPIOF_CANSLEEP        0x1
>
>  err = gpio_request(some_gpio, "some_gpio", GPIOF_NO_SLEEP);
>
> ~Ryan
>
> --
> Bluewater Systems Ltd - ARM Technology Solution Centre
>
> Ryan Mallon                     5 Amuri Park, 404 Barbadoes St
> ryan@bluewatersys.com           PO Box 13 889, Christchurch 8013
> http://www.bluewatersys.com     New Zealand
> Phone: +64 3 3779127            Freecall: Australia 1800 148 751
> Fax:   +64 3 3779135                      USA 1800 261 2934
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
