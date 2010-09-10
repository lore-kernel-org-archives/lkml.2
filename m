Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0IJIwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:52:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50479 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab0IJIv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=WCukTuHeeW9Wtr/J1DRPMHnvXBrqldXoVmet0X++wtgsmqqdLXdceBKt6zbQLWsVCf
         MI3/j1cC3m3LoVgqv+waTN+ZVgPZfNWpg9FMbLqIeI3PlTlMCjv9xKfuyiEsjg78gfrX
         nEeL2ACqu16VGKXecMSfk8Sr2RU10JFRKJTUY=
Message-ID: <4C89F1AB.3070701@warmcat.com>
Date: Fri, 10 Sep 2010 09:51:55 +0100
From: Andy Green <andy@warmcat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc14 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Generic GPIO on USB / hotpluggable gpiolib device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

I just wrote a small driver that exposes a USB device's IO as generic 
GPIO using a little protocol.  I often needed a simple way to bitbang 
something from my laptop and this is going to be very useful to 
implement it.

It works fine with dynamic GPIO allocation and so on, but I maybe 
realized at the end why nobody did this until now, in gpiolib it says...

/**
  * gpiochip_remove() - unregister a gpio_chip
  * @chip: the chip to unregister
  *
  * A gpio_chip with any GPIOs still requested may not be removed.
  */
int gpiochip_remove(struct gpio_chip *chip)
{
...
	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
		if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
			status = -EBUSY;
			break;
		}
	}
...

In short gpiolib doesn't have the concept that the chip can be 
hot(un)plugged randomly, including at times when something has requested 
the GPIO.

I am quite certain that USB generic GPIO would be something very nice 
for end users, to be able to casually plug in even the cheapest USB 
micro and bitbang as much GPIO as you like from userspace in a 
standardized way (including being able to exploit the existing bitbang 
protocol drivers on the exposed GPIO) would be very handy.  The protocol 
is simple and flexible (1 x IN endpoint and 1 x OUT endpoint, only one 
packet per call, device announces number of GPIO it supports).

What'd be the feeling if I enhanced gpiolib a bit along the lines of:

  - changing the chip set() function to be able to return errors, at the 
moment it's void return from that

  - adding a flag marking a chip as "dead", causing all IO via it to 
fail immediately and it to be auto-removed when the last request goes

Does this seem workable?  What to do about say SPI bitbang protocol 
driver instance that sees its generic gpio calls started failing?

-Andy
