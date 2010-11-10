Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab0KJP2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:28:14 -0500
Received: from moh2-ve3.go2.pl ([193.17.41.208]:56415 "EHLO moh2-ve3.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216Ab0KJP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:28:13 -0500
Message-ID: <4CDABA03.2050000@o2.pl>
Date: Wed, 10 Nov 2010 16:28:03 +0100
From: Maciej Szmigiero <mhej@o2.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101024 Lightning/1.0b3pre Thunderbird/3.1.5
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Ben Nizette <bn@niasdigital.com>, tglx@linutronix.de
Subject: Re: [GPIO]implement sleeping GPIO chip removal
References: <4CD6F049.10102@o2.pl> <20101110050947.GC4110@angua.secretlab.ca>
In-Reply-To: <20101110050947.GC4110@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-O2-Trust: 2, 60
X-O2-SPF: neutral
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 10.11.2010 06:09, Grant Likely pisze:
> On Sun, Nov 07, 2010 at 07:30:33PM +0100, Maciej Szmigiero wrote:
>> [GPIO]implement sleeping GPIO chip removal
>>
>> Existing GPIO chip removal code is only of "non-blocking" type: if the chip is currently
>> requested it just returns -EBUSY.
>> This is bad for devices which disappear and reappear, like those on hot pluggable buses,
>> because it forces the driver to call gpiochip_remove() in loop until it returns 0.
>>
>> This patch implements a new function which sleeps until device is free instead of
>> returning -EBUSY like gpiochip_remove().
>>
>> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
> 
> This patch makes me uncomfortable, but I'm not entirely sure why.  Is
> there a reason that the process is manipulated directly instead of
> using a completion?  Perhaps I'm bother by the joint use of
> ->dead + ->removing_task that is bothering me.  I need to mull on this
> one some more.
> 
> Also, comments below...
> 

>> @@ -95,6 +95,10 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
>>  	const struct gpio_chip *chip = desc->chip;
>>  	const int gpio = chip->base + offset;
>>  
>> +	/* no new requests if chip is being deregistered */
>> +	if ((chip->dead) && (test_bit(FLAG_REQUESTED, &desc->flags) == 0))
>> +		return -ENODEV;
>> +
> 
> Not holding spin lock.  Race condition.

Every call to gpio_ensure_requested() in gpiolib.c is done while holding gpio_lock and this function is not exported.

>> +int gpiochip_remove_sleeping(struct gpio_chip *chip, int interruptible)
>> +{
>> +	unsigned	id;
>> +	unsigned long	flags;
>> +
>> +	/* prevent new requests */
>> +	chip->dead = 1;
> 
> race, grab spinlock first.

Race with ...?
The only place where chip->dead is changed to zero is later in gpiochip_remove_sleeping() (which cannot be called at the same time for the same
chip more than once anyway) or gpiochip_add() which is new chip registration function.

>> +				busy = 1;
>> +				break;
>> +			}
>> +		}
> 
(..)
> In fact, gpiochip_remove could be called directly here (with some
> spin_lock refactoring) and exit the loop if it doesn't return -EBUSY.
> 
(..)
> Don't open code this.  Generalize the code in gpiochip_remove() instead.

I agree with you on this.

W dniu 10.11.2010 10:49, Thomas Gleixner pisze:
> Maybe because it open codes a sloppy refcounting with a loop and magic
> sleeps instead of converting the code to kobjects and proper
> refcounting ?
> 

The only way to do GPIO chip removal in the current code is to busy-loop.
"Sloppy" (as you called it) waiting is still more CPU-friendly than looping 
in hope that somebody will finally release the chip.
If you would like to implement it as kobject then go ahead and post the code
so it can be used in drivers.

Best regards and thanks for comments,
Maciej Szmigiero
