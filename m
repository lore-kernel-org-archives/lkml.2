Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2BHAcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:32:35 -0500
Received: from mail2.nsc.com ([12.238.8.132]:60874 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756811Ab2BHAce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:32:34 -0500
X-WSS-ID: 0LZ1TI5-0A-D9U-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Feb 2012 16:32:14 -0800
Subject: RE: [PATCH v4 3/5] leds-lm3530: support pwm input mode
Thread-Topic: [PATCH v4 3/5] leds-lm3530: support pwm input mode
Thread-Index: Aczl64wipsYf2GpET5Ob/QO3QDjgiwACsHng
Message-ID: <B567DBAB974C0544994013492B949F8E3812ED49C6@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812ED44A8@EXMAIL03.scwf.nsc.com>
 <20120207145458.6397d04c.akpm@linux-foundation.org>
In-Reply-To: <20120207145458.6397d04c.akpm@linux-foundation.org>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 632F1D181LS10220414-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Wednesday, February 08, 2012 7:55 AM
> To: Kim, Milo
> Cc: Linus Walleij; shreshthakumar.sahu@stericsson.com;
> rpurdie@rpsys.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v4 3/5] leds-lm3530: support pwm input mode
> 
> On Mon, 6 Feb 2012 21:14:21 -0800
> "Kim, Milo" <Milo.Kim@ti.com> wrote:
> 
> > * add 'struct lm3530_pwm_data' in the platform data
> >   The pwm data is the platform specific functions which generate the
> pwm.
> >   The pwm data is only valid when brightness is pwm input mode.
> >   Functions should be implemented by the pwm driver.
> >   pwm_set_intensity() : set duty of pwm.
> >   pwm_get_intensity() : get current the brightness.
> >
> > * brightness control by pwm
> >   If the control mode is pwm, then brightness is changed by the duty
> of pwm.
> >   So pwm platform function should be called in
> lm3530_brightness_set().
> >
> > * do not update brightness register when pwm input mode
> >   In pwm input mode, brightness register is not used.
> >   If any value is updated in this register, then the led will be off.
> >
> > * when input mode is changed, set duty of pwm to 0 if unnecessary.
> >
> > * patch base version : kernel 3.2.4
> >
> >
> > ...
> >
> > @@ -327,14 +344,11 @@ static ssize_t lm3530_mode_set(struct device
> *dev, struct device_attribute
> >  		return -EINVAL;
> >  	}
> >
> > -	if (mode == LM3530_BL_MODE_MANUAL)
> > -		drvdata->mode = LM3530_BL_MODE_MANUAL;
> > -	else if (mode == LM3530_BL_MODE_ALS)
> > -		drvdata->mode = LM3530_BL_MODE_ALS;
> > -	else if (mode == LM3530_BL_MODE_PWM) {
> > -		dev_err(dev, "PWM mode not supported\n");
> > -		return -EINVAL;
> > -	}
> > +	drvdata->mode = mode;
> > +
> > +	/* set pwm to low if unnecessary */
> > +	if (mode != LM3530_BL_MODE_PWM && pwm->pwm_set_intensity)
> > +		pwm->pwm_set_intensity(0, max_brightness);
> 
> lm3530_mode_set() has no local variable "pwm" and has no local variable
> "brightness".

Local variable "pwm" was added in this patch.
[PATCH v4 3/5] leds-lm3530: support pwm input mode

@@ -255,6 +265,9 @@ static void lm3530_brightness_set(struct
 	int err;
 	struct lm3530_data *drvdata =
 	    container_of(led_cdev, struct lm3530_data, led_dev);
+	struct lm3530_platform_data *pdata = drvdata->pdata;
+	struct lm3530_pwm_data *pwm = &pdata->pwm_data;
+	u8 max_brightness = led_cdev->max_brightness;

And I can see the same code in your mm tree mail.

> 
> I see now that you prepared the patches against 3.2.4, which might
> contribute to this problem, but I don't see how the patches could work
> in 3.2 either.  Perhaps 3.2.4 is significantly different from 3.2.
> 

For the leds-lm3530 driver, there is no difference between 3.2 and 3.2.4.
I'm curious what happened to the patch. Can I have any message from your working tree ?

Thanks & BR
Milo -

