Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab0FTVbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:31:33 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:50280 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778Ab0FTVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:31:31 -0400
Message-ID: <4C1E88AE.5070808@bluewatersys.com>
Date: Mon, 21 Jun 2010 09:31:26 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: gpiolib and sleeping gpios
References: <386783.17931.qm@web180310.mail.gq1.yahoo.com>
In-Reply-To: <386783.17931.qm@web180310.mail.gq1.yahoo.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2010 06:21 PM, David Brownell wrote:
> 
>>
>> The runtime warnings will only show instances where the
>> non-sleeping
>> versions where called instead of the sleeping versions.
> 
> ... *AND* the GPIO requires the cansleep() version...
> 
> Right; such calls are errors.  We issue
> warnings since fault returns are inapplicable.

A driver which only uses the non-sleeping versions, but _could_ use the
cansleep variants (ie all calls to gpio_(set/get)_value are made from
contexts where it is possible to sleep) is not so easy to spot. Passing
a sleeping to gpio to such a driver will result in spurious warnings.

>> There is no
>> warning to say that we are calling the spinlock safe
>> version, where it is possible to sleep.
> 
> The call context isn't what controls whether
> gpio_get_value() or gpio_get_value_cansleep()
> is appropriate ... it's the GPIO itself, and
> how its implementation works.

No, a driver should not know anything about a gpio which is passed to
it. If a driver is able to call the cansleep variants, then it should,
and it will allow any gpio, sleeping or non-sleeping, to be used with
that driver.

If a driver uses a gpio in such a way that it cannot sleep, ie the
gpio_(get/set)_value calls are made from spinlock context, then only
gpios which do not sleep may be used with that driver.

Thats why I think specifying whether the gpio is able to sleep when it
is requested is a good idea. A driver which cannot use a sleeping gpio


> "possible to sleep" is a GPIO attribute,
> exposed by a predicate.  If spinlock-safe
> calls are used on GPIOs with that attribute,
>  a warning *IS* issued.

Possible to sleep is also an attribute of how a driver _uses_ a gpio.

>>
>> The point I was trying to make is that there are lots of
>> drivers which
>> will not work with gpios on sleeping io expanders because
>> they call the
>> spinlock safe gpio calls.
> 
> And they will trigger runtime warnings, and
> thus eventually get fixed.  The way to do that
> is to check if the GPIO needs the cansleep()
> call

Hmm, maybe this then for drivers which cannot accept sleeping gpios:

  if (gpio_cansleep(some_gpio)) {
  	  dev_err(&dev, "This driver only supports non-sleeping gpios");
	  return -EINVAL;
  }

  err = gpio_request(some_gpio, "some_gpio");

I think ideally, gpio_request should specify this via a flags argument, ie:

  #define GPIOF_NO_SLEEP	0x0
  #define GPIOF_CANSLEEP	0x1

  err = gpio_request(some_gpio, "some_gpio", GPIOF_NO_SLEEP);

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
