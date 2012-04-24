Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2DXG1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:27:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58770 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2DXG1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:27:30 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Girdwood, Liam" <lrg@ti.com>
Date: Mon, 23 Apr 2012 23:27:26 -0700
Subject: RE: [PATCH] leds: lm3530: fix handling of already enabled regulators
Thread-Topic: [PATCH] leds: lm3530: fix handling of already enabled
 regulators
Thread-Index: Ac0hv0WaVInxXFfuSPuGWfr4Ua1IIgAFcC5g
Message-ID: <DD6B9D658496A2488636C8C75B9C0CB601DA3984@EXMAIL04.scwf.nsc.com>
References: <1335107508.6261.3.camel@phoenix>
 <20120423110912.GC8318@opensource.wolfsonmicro.com>
 <CAF+7xWkzy5e0rcpwprEE3VWTikOu2+qtsgfdhTN12-yonDxadA@mail.gmail.com>
In-Reply-To: <CAF+7xWkzy5e0rcpwprEE3VWTikOu2+qtsgfdhTN12-yonDxadA@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > On Sun, Apr 22, 2012 at 11:11:48PM +0800, Axel Lin wrote:
> >
> >>               drvdata->regulator = NULL;
> >>               goto err_regulator_get;
> >>       }
> >> +     drvdata->enable = regulator_is_enabled(drvdata->regulator);
> >>
> >
> > This isn't sufficient for what the driver is doing - it also needs to
> > enable the regulator.  Regulator enables are reference counted (since
> > the regulator can be shared by many device supplies) so if this
> driver
> > doesn't reference the regulator when it's needed then it could get
> > powered off.
> 
> The regulator_enable() is called in lm3530_init_registers().

I think this patch has a mismatched condition between the value of variable and actual status of the regulator.

Let's suppose that the regulator (named "vin") is disabled after the lm3530 driver is probed.

Step 1. The 'vin' regulator is on

Step 2. lm3530 driver is probed
lm3530_probe()
{
	/* drvdata->enabled is true at this moment */
	drvdata->enable = regulator_is_enabled(drvdata->regulator);
	...
}

Step 3. lm3530_init_registers() is called
lm3530_init_registers()
{
	/* skip enabling the regulator because the condition is true */
	if (!drvdata->enable) {
		ret = regulator_enable(drvdata->regulator);
		...
	}
}

Step 4. The regulator is disabled by another driver.
	(It is possible because the regulator reference count is not incremented yet by the lm3530 driver)

Step 5. If the brightness mode is changed from the ALS to manual, lm3530_init_registers() is called again.

lm3530_init_registers()
{
	/* In this case, regulator should be on,
	   but it will skip again because the variable is still true */
	if (!drvdata->enable) {
		ret = regulator_enable(drvdata->regulator);
		...
	}
}

The lm3530_probe() is called once.
But lm3530_init_registers() can be called whenever the brightness mode is changed.
(e.g from ALS to manual or manual to PWM, and so on)
So the status of regulator can be mismatched.

In my opinion, current source code is the simplest way.

	1. The variable 'drvdata->enabled' is initialized as false.
	2. The regulator is enabled and the variable is updated when the driver is probed.
	   (If the regulator is already on, it's ok - keep going ...)
	3. The variable is updated when regulator_enable()/regulator_disable() is called by the lm3530 driver.
	   (If another driver tries to turn off the regulator, it can't be allowed
	    because the reference count was incremented by the lm3530 driver.)

Thanks & BR
Milo -


