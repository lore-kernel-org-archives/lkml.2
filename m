Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1KRWow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:44:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16878 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab1KRWou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:44:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Nov 2011 14:44:49 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Fri, 18 Nov 2011 14:44:48 -0800
Subject: RE: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Topic: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Index: AcymQhdAtp97koDlS2SdEKPXxcb3kgAAE1Iw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74FE6@HQMAIL01.nvidia.com>
References: <4EC572E1.1020209@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com>
 <4EC6C785.5010801@solonet.org.ua> <4EC6D1D5.9060808@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com>
 <4EC6DD8F.9070904@solonet.org.ua>
In-Reply-To: <4EC6DD8F.9070904@solonet.org.ua>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote at Friday, November 18, 2011 3:35 PM:
> On 11/18/2011 11:59 PM, Stephen Warren wrote:
> > Denis Kuzmenko wrote at Friday, November 18, 2011 2:45 PM:
> >> Make s3c24xx LEDS driver use gpiolib. Disable using pull-resistor when not
> >> using S3C24XX_LEDF_TRISTATE and enble it when in opposite case.
> >>
> >> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> >
> >>  	if (pdata->flags & S3C24XX_LEDF_TRISTATE) {
> >> -		s3c2410_gpio_setpin(pdata->gpio, 0);
> >> -		s3c2410_gpio_cfgpin(pdata->gpio, S3C2410_GPIO_INPUT);
> >> +		/*
> >> +		 * pull is needed here to protect pin from being left
> >> +		 * floating
> >> +		 */
> >> +		ret = s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_UP);
> >> +		if (ret)
> >> +			s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_DOWN);
> >
> > Sorry, could you explain why it's appropriate to configure a pull here
> > at all, let alone why it's OK to have a random pull on the line?
> >
> 
> Of course I'll explain.
> Imagine you are working with generic GPIO lines on your board connecting
> and disconnecting LEDs and other stuff. In this case there can be
> situation where GPIO line is configured as TRISTATE LED but have nothing
> connected physically to pin. This configuration is dangerous because
> input pin without _any_ pull-resistor is _much_ more sensitive to
> statical electricity (ESD) so you can *burn* (unsure this is correct
> word) your pin much easily (especially is you are using soldering iron
> as much as I do). Most of GPIO modules I worked with have "input with
> pull-up" as default and most safe initial state (and s3c2440's one is
> not an exception).
> Maybe, I need to write more wide exlanation in comment above?

OK, I see the need for a pull of some kind (although aren't there meant
to be ESD protection diodes for this purpose; relying on what are probably
pretty weak pullup/down resistors doesn't seem like it will provide much
protection at all).

I have a slight feeling this detail should be hidden inside the gpiolib
driver.

Presumably the pull is pretty weak, so that if/when the pin is actively
driven later, the drive completely overrides this pull?

Is this pull strong enough to light the LED? Judging by what
s3c24xx_led_set() does, when the LED is off, the pin is tri-stated, and
when the LED is on, it's driven (high/low depending on the active high/low
flag). When tri-stated, if the pull happens to pull the same direction as
the on state would drive it, won't the LED light? It seems like you need
to pick a suitable pull direction based on flags & S3C24XX_LEDF_ACTLOW,
and if that can't be set, it's an error.

(BTW, when posting a new version, starting a new thread with just the
patch, rather than pasting it into a reply and prefixing it with other
text will make is easiest for people to take the patch and apply it)

-- 
nvpublic

