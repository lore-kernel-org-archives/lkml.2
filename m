Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2KSMT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:19:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42443 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab2KSMT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:19:26 -0500
Message-ID: <50AA23C4.1000706@ti.com>
Date: Mon, 19 Nov 2012 13:19:16 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: twl4030: Use only TWL4030_MODULE_LED for LED configuration
References: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com> <CACRpkdayZK2sPXJW=COFi7C=P5=fbi-q7UukWbQ8dheaJ=bjAA@mail.gmail.com> <50A9F335.80107@ti.com> <CACRpkdbvXFtHoOXThUrT4Z+8nO_HJCFq-May+4zaOsNv-886LA@mail.gmail.com>
In-Reply-To: <CACRpkdbvXFtHoOXThUrT4Z+8nO_HJCFq-May+4zaOsNv-886LA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 11/19/2012 11:40 AM, Linus Walleij wrote:
> On Mon, Nov 19, 2012 at 9:52 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> 
>> I was actually tempted to remove the whole LED (PWM) thing from the
>> gpio-twl4030 driver. It was a big surprise to me to see something like this in
>> there.
> 
> It looks wrong. In theory I think this should be ripped out and moved to
> drivers/leds/leds-twl4030.c. But that would only be in case it was *always*
> exclusively used for a LED and as you say:
> 
>> It turns out that on BeagleBoard the USB host enable signal is connected to
>> LEDA (PWMA) of twl4030... It is an enable signal. Seriously. So what we do
>> here is either configure the PWMs as full on, or turn it off.
> 
> Sounds like some hardware engineer has been having fun or was
> just out of GPIOs to use... So this LED PWM is also used as a
> GPIO.

My guess it was out of fun. On BealgeBoard GPIO13 from twl4030 is free
(LEDSYNC/GPIO.13) so it could have been used for this, or GPIO16/17 as well.

> I think this part of the driver should be moved to
> drivers/pwm/pwm-twl4030.c and modeled as a PWM. If some
> platform need to use the PWM as if it was a GPIO then that's just a
> special usecase. (Setting duty cycles to something like
> INT_MAX and just switching polarity to toggle it...)
> 
> If it needs to be used by a LED there needs to be some generic
> LED type just using a standard pwm_request() to get some
> specific PWM, such as leds/leds-pwm.c or so. This way the
> PWM can be used for LEDs if need be or other things...

I have already sent a series to support the PWMs in twl4030/6030:
https://lkml.org/lkml/2012/11/8/219
It adds support for both type of PWMs (the one named as PWM and the ones named
as LED since they are just PWMs).

We already have leds/leds-pwm driver in upstream so we are going to use that
if there is a led connected to one of them:
https://lkml.org/lkml/2012/11/12/222

We can use the backlight-pwm if the LCD backlight has been hooked to one of
the PWM (as it is done on SDP4430).

This is why I was thinking of adding gpio/gpio-pwm driver. With that we can
use the PWM as GPO line.

> Sounds correct, Sascha?
> 
>> Either way this is wrong IMHO to handle the LEDA/B via the gpio-twl4030 driver.
> 
> It's confusing indeed.
> 
> So what we're dealing with is: a LED-specific PWM, being used
> as a PWM with eternal dutycycle and then being used as GPIO.
> 
> Well, we get to deal with it ... :-/

gpio/gpio-pwm driver?

-- 
Péter
