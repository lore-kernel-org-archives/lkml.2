Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1LNKYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:24:35 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:42973 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793Ab1LNKYe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:24:34 -0500
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Kuzmenko <linux@solonet.org.ua>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Date: Wed, 14 Dec 2011 11:23:58 +0100
Subject: RE: [PATCH] leds: driver for ab5500 high voltage leds
Thread-Topic: [PATCH] leds: driver for ab5500 high voltage leds
Thread-Index: Acy1R2OozIiOiFr/T1WpBYTkEBsjrwFAt5cw
Message-ID: <2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
 <4EDAA785.40503@solonet.org.ua>
 <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
 <4EDFAA0A.7040607@solonet.org.ua>
 <20111207160002.8b52df42.akpm@linux-foundation.org>
 <20111208011904.GD5748@opensource.wolfsonmicro.com>
In-Reply-To: <20111208011904.GD5748@opensource.wolfsonmicro.com>
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

Sorry for replying late, I was on vacation.
To minimize fragmentaion in different mails, I am replying all in this mail.

HVLED controller supports up to 20V on each input. In terms of VBAT = max 4.5V,
20V is considered as high voltage. The voltage must be provided by external
source, e.g. a boost converter. These converters can be dynamically controlled
but generally these are configured to provide fixed output voltage and done
during system design.

Given a constant external voltage LED(s) in series, max current is fixed based
on platform. In U5500 platform it is done as -
        ...
        max_current = 10, /* wrong value may damage h/w */
        ...

The max current flowing through pin will be limited in HVLED controller by:
        MIN(voltage source current drive capability; Set max current)

The actual amount of current flowing hence brightness variation can then be
altered using PWM, which is also the case in present driver.

Hence the idea of current control sysfs interface is provided to further
decrease the max current through the LED(s) if required for saving power
(but can never exceed the max current set by the platform).
After fixing the current, "brightness" interface can be used to control
brightness which internally cofigures the PWM register.

Hope adding this information in documentation will help avoiding confusion
for the users.

Regards,
Shreshtha

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Thursday, December 08, 2011 6:49 AM
To: Andrew Morton
Cc: Denis Kuzmenko; Linus Walleij; Linus WALLEIJ; Richard Purdie; linux-kernel@vger.kernel.org; Samuel Ortiz; Shreshtha Kumar SAHU
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds

On Wed, Dec 07, 2011 at 04:00:02PM -0800, Andrew Morton wrote:
> Denis Kuzmenko <linux@solonet.org.ua> wrote:

Hrm, for some reason lots of the mails here didn't reach my inbox...
anyway.

> > > My naive understanding is that you set the current limit and then
> > > the HV transformer (I guess this is a buck converter of some kind)

Boost convertor.  A buck is always step down I beleive.

> > > will raise the voltage level until it either (A) cannot raise it any more
> > > at c:a 20V or (b) the current limit is reached.

> > > I suspect this is because for LEDs of this type you get a
> > > specified current but the voltage just has to be "high enough"
> > > to break through some diode barrier threshold or so. After
> > > that intensity is controlled by limiting the current.

> > > Does this suffice as explanation...?

OK, that's exactly the sort of hardware I thought you were driving.
There's several drivers for this type of LED in the kernel already.

> I won't do anything with this patch yet - I'm waiting to see if Mark
> stops being surprised ;)

I'm still surprised I'm afraid.  The voltage is generally fixed by the
platform (approximately anyway) to be whatever is needed to get the LEDs
to start doing something and the current is varied to control the
brightness with an upper limit configured based on what the LEDs can
carry and what is sane for the physical design (blinding users tends not
to be popular).  The funciton of the current regulator in the system is
to constrain the brightness of the LED so that it doesn't just go to
maximum brightness without burning power on a resistive load.

This means that usually the current control does map fairly directly
onto the LED API brightness, normally with a scaling as the eye
percieves things on a log scale but we expect brightness to be linear.
This scaling may be pre-done by the choice of current limits in the
current regulator.
