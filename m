Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab0FQVsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:48:06 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:63031 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757658Ab0FQVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:48:04 -0400
Message-ID: <4C1A980F.8080908@bluewatersys.com>
Date: Fri, 18 Jun 2010 09:47:59 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       ext-jani.1.nikula@nokia.com
Subject: gpiolib and sleeping gpios
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently implementors of gpiolib must provide implementations for
gpio_get_value, gpio_set_value and gpio_cansleep. Most of the
implementations just #define these to the double underscore prefixed
versions in drivers/gpio/gpiolib.c. A few implementations have a simple
wrapper function which provides a fast path for the SoC gpios, and calls
gpiolib for the any additional gpios, such as those added by an io expander.

Although gpio_chips know whether or not they may sleep, gpios which can
sleep need to call gpio_[set/get]_value_cansleep. The only difference
between __gpio_(set/get)_value and gpio_(set/get)_value_cansleep is that
the cansleep versions calls might_sleep_if. Most drivers call
gpio_(get/set)_value, rather than the cansleep variants. I haven't done
a full audit of all of the drivers (which is a reasonably involved
task), but I would hazard a guess that some of these could be replaced
by the cansleep versions.

Would it not be simpler to combine the calls and have something like this:

void __gpio_get_value(unsigned gpio, int value)
{
	struct gpio_chip *chip;

	chip = gpio_to_chip(gpio);
	might_sleep_if(extra_checks && chip->can_sleep);
	chip->set(chip, gpio - chip->base, value);
}

Then all drivers can just call gpio_(set/get)_value and any attempts to
use sleeping gpios from an non-sleeping context will be caught by the
might_sleep_if check. Is there something I am missing about this?

I can prepare a patch which combines the non-sleeping and sleeping
variants, but I wanted to check that I'm not missing something
fundamental first.

Thanks,
~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
