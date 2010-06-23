Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214Ab0FWFCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 01:02:22 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:16461 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979Ab0FWFCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 01:02:21 -0400
Message-ID: <4C21955D.1020502@bluewatersys.com>
Date: Wed, 23 Jun 2010 17:02:21 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping
 gpios)
References: <191168.5104.qm@web180308.mail.gq1.yahoo.com>
In-Reply-To: <191168.5104.qm@web180308.mail.gq1.yahoo.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 04:37 PM, David Brownell wrote:
> 
> 
> --- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com> wrote:
> 
> 
>> gpiolib
> 
> 
> Again, you're talking about "gpiolib" when
> you seem to mean the GPIO framework itself
> (for which gpiolib is only an implementation
> option)...

Fine, its just semantics. I think everyone knows what I mean when I
refer to gpiolib.

>> framework could be simplified for cansleep gpios.
>>
>> 'Can sleep' for a gpio has two different meanings depending
>> on context
> 
> NO; for the GPIO itself it's only ever had one
> meaning, regardless of context.
> 
> You're trying to conflate the GPIO and one
> of the contexts in which it's used.  That's
> the problem you seem to be struggling with.
> 
> Please stop conflating/confusing
> those two disparate concepts...

I'm not. Some gpios, such as those on io expanders, may sleep in their
implementations of the gpio_(set/get) functions.

Drivers, which use a gpio, may call gpio_(set/get) functions for a given
gpio from a context where it is not safe to sleep. In this case, a gpio
which may sleep (ie one on an i2c io-expander) cannot be used with this
driver. The gpio_request will succeed, but any call to
gpio_(set/get)_value will produce a warning.

>> example, if a driver calls gpio_get_value(gpio) from an
>> interupt handler
>> then the gpio must not be a sleeping gpio.
> 
> In a threaded IRQ handler it's OK to use
> the get_value_cansleep() option..

Ugh, you are really twisting my words. replace 'interrupt handler' with
'non sleep safe context'.

>>
>> This patch introduces a new flag, FLAG_CANSLEEP, internal
>> to gpiolib
> 
> NAK; Superfluous; the gpio_chip already has
> that information recorded.

It has a different meaning, but I think you are still correct here. The
might_sleep_if in gpio_(set/get)_value is only necessary if
chip->cansleep is set.

> 
>> new request function, gpio_request_cansleep, requests a
>> gpio which may
>> only be used from sleep possible contexts
> 
> Also superfluous.

Not so. In my opinion, it is better to have the gpio_request fail
immediately if it is being used incorrectly. For example, say you have
two gpios:

  soc_gpio:    An SoC gpio which does not sleep on set/get
  sleepy_gpio: An i2c io-expander gpio which may sleep on get/set

and some driver code which does this:

  gpio_request(gpio, "some_gpio");
  ...
  // Non-sleep safe context
  gpio_set_value(gpio, 0);

If you pass sleepy_gpio as the gpio to this driver the gpio_request will
succeed, but you will get a warning on the gpio_set_value because its
usage is incorrect.

In my proposed change, the gpio_request would fail because sleepy_gpio
might sleep, and therefore cannot be used by drivers which use gpios in
non sleep safe context. Basically I am moving the cansleep part of the
api from the usage of gpios to the registration time. In my opinion this
is better because it means there is only one set of gpio_(set/get)_value
calls and incorrect usage of sleeping gpios will be caught when the gpio
is registered, not when it is used.

> 
>  The existing
>> gpio_request
>> function requests a gpio, but does not allow it to be used
>> from a
>> context where sleep is not possible.
> 
> Changing semantics of existing calls is a big
> mess, and should be avoided even if it seems
> appropriate.
> 
> Since the request is just reserving a resource
> that's already been identified (and which has
> known characteristics, like whether the GPIO
> value must be accessed only from sleeping
> contexts), this call would also be superfluous.
>
> If you want to ensure the GPIO is a cansleep()
> one, just check that before reserving it.  There
> is no need for new calls to support that model;
> it works today.

Except that drivers do not do this.

> (NAK...)
> 
> 
> 
>> The benefits I see to this approach are:
>>  ...
>>  - The API is simplified by combining gpio_(set/get)_value
>> and
>> gpio_(set/get)_value_cansleep
> 
> 
> You have a strange definition of "simplified"...
> 
> Recognize that you're also proposing to remove
> an API characteristic which much simplifies
> code review:  you can look at calls and see
> that because they're the cansleep() version,
> they are unsafe in IRQ context ...

Hmm, fair point.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
