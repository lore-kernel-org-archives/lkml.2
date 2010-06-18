Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0FRWBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:01:53 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:20153 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560Ab0FRWBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:01:52 -0400
Message-ID: <4C1BECC9.7000805@bluewatersys.com>
Date: Sat, 19 Jun 2010 10:01:45 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       ext-jani.1.nikula@nokia.com
Subject: Re: gpiolib and sleeping gpios
References: <514259.95052.qm@web180315.mail.gq1.yahoo.com>
In-Reply-To: <514259.95052.qm@web180315.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> 
> --- On Thu, 6/17/10, Ryan Mallon <ryan@bluewatersys.com> wrote:
>> Currently implementors of gpiolib must provide
>> implementations for
>> gpio_get_value, gpio_set_value and gpio_cansleep. 
> 
> Not true.  There is ONE implementation of gpiolib.
> 
> I think you mean "implementors of the GPIO calls".
> many of those implementors will use gpiolib, to
> make their lives easier.  They are not, however,
> re-implementing gpiolib itself...

Okay, so I got the semantics wrong. You know what I mean :-).

<snip>

> 
> only the cansleep() versions may be used for
> GPIOs whose operation requires use of sleeping
> calls.  Most SoC GPIOs are safe to access with
> IRQs disabled, spinlocks, held and so on.
> 
> That's why only the non-cansleep() versions
> are documented as being spinlock-safe.
> 
> 
>> the cansleep versions calls might_sleep_if. Most drivers
> 
> 
> That's an implemenation detail, internal to the
> gpiolib code.
> 
> Note that "can" sleep means exactly that...  It
> doesn't mean "must sleep".  A valid way to
> implement a cansleep() variant is to 
> 
> just call the spinlock-safe routine, so that
> it never sleeps.
> 
> THe converse is not true; the spinlock-safe
> routine must never call a cansleep() version.

Right, so it is just an implementation detail. When can easily change
that to gpio_(set/get)_value is only safe to call from spinlock context
if the gpio will not sleep. Having the the might_sleep_if check inside
those calls will give a warning if that condition is not met.

> 
>>  Most drivers call > gpio_(get/set)_value, rather than the cansleep variants. I
>> haven't done
>> a full audit of all of the drivers (which is a reasonably
>> involved
>> task), but I would hazard a guess that some of these could
>> be replaced
>> by the cansleep versions.
> 
> 
> One hopes that the runtime warnings have gotten
> folk to fix bugs where the cansleep() version
> should have been used, but wasn't...

The runtime warnings will only show instances where the non-sleeping
versions where called instead of the sleeping versions. There is no
warning to say that we are calling the spinlock safe version, where it
is possible to sleep.

The point I was trying to make is that there are lots of drivers which
will not work with gpios on sleeping io expanders because they call the
spinlock safe gpio calls. Some of these drivers may be able to use the
sleeping variants. There are two possible ways to fix this:

1) Audit each driver which uses non-sleeping gpio calls and determine
whether they can use the sleeping versions instead.
2) Modify the gpiolib calls as I suggested. Any attempts to use a
sleeping gpio with a driver which cannot support it will result in a
warning.

> 
> Better IMO not to make that change except as
> part
> of a bugfix:  e.g. remove a runtime warning
> that boils down to not using the cansleep()
> version when it should have been used.
>> Would it not be simpler to combine the calls and have
>> something like this:
>>
>> void __gpio_get_value(unsigned gpio, int value)
>> {
>>     struct gpio_chip *chip;
>>
>>     chip = gpio_to_chip(gpio);
>>     might_sleep_if(extra_checks &&
>> chip->can_sleep);
>>     chip->set(chip, gpio - chip->base,
> 
>> value);
> 
> calling chip->set() when  chip->can_sleep
> and the call context can't be preempted,
> would be a bug.  So that code is wrong ...
> it should at least warn about the error
> made by the caller.  If we had error returns from gpio get/set calls 9sigh), it'd be right to
> fail that call.

Not quite sure what you mean here? Many drivers are generic in that they
get passed a gpio to use with the gpiolib calls via some platform/driver
data. Some drivers will be able to use sleeping gpios, but may not be
correctly using the cansleep variants.

I agree about the errors from the gpio_(set/get)_value calls. set isn't
too bad, but returning an error and a value from the get calls is a bit
of a pain.

Possibly a solution is to have an additional argument to gpio_request
which specifies whether the driver this gpio is able to be a sleeping
gpio or not. That way the request can fail immediately if a sleeping
gpio is passed to a driver that calls gpiolibs calls from sleeping context.

~Ryan

