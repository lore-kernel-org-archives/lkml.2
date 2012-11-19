Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab2KSKkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:40:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39923 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2KSKkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <50A9F335.80107@ti.com>
References: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com>
	<CACRpkdayZK2sPXJW=COFi7C=P5=fbi-q7UukWbQ8dheaJ=bjAA@mail.gmail.com>
	<50A9F335.80107@ti.com>
Date: Mon, 19 Nov 2012 11:40:30 +0100
Message-ID: <CACRpkdbvXFtHoOXThUrT4Z+8nO_HJCFq-May+4zaOsNv-886LA@mail.gmail.com>
Subject: Re: [PATCH] gpio: twl4030: Use only TWL4030_MODULE_LED for LED configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sascha Hauer <kernel@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 9:52 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> I was actually tempted to remove the whole LED (PWM) thing from the
> gpio-twl4030 driver. It was a big surprise to me to see something like this in
> there.

It looks wrong. In theory I think this should be ripped out and moved to
drivers/leds/leds-twl4030.c. But that would only be in case it was *always*
exclusively used for a LED and as you say:

> It turns out that on BeagleBoard the USB host enable signal is connected to
> LEDA (PWMA) of twl4030... It is an enable signal. Seriously. So what we do
> here is either configure the PWMs as full on, or turn it off.

Sounds like some hardware engineer has been having fun or was
just out of GPIOs to use... So this LED PWM is also used as a
GPIO.

I think this part of the driver should be moved to
drivers/pwm/pwm-twl4030.c and modeled as a PWM. If some
platform need to use the PWM as if it was a GPIO then that's just a
special usecase. (Setting duty cycles to something like
INT_MAX and just switching polarity to toggle it...)

If it needs to be used by a LED there needs to be some generic
LED type just using a standard pwm_request() to get some
specific PWM, such as leds/leds-pwm.c or so. This way the
PWM can be used for LEDs if need be or other things...

Sounds correct, Sascha?

> Either way this is wrong IMHO to handle the LEDA/B via the gpio-twl4030 driver.

It's confusing indeed.

So what we're dealing with is: a LED-specific PWM, being used
as a PWM with eternal dutycycle and then being used as GPIO.

Well, we get to deal with it ... :-/

Yours,
Linus Walleij
