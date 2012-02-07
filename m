Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab2BGWzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:55:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2BGWzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:55:10 -0500
Date: Tue, 7 Feb 2012 14:54:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] leds-lm3530: support pwm input mode
Message-Id: <20120207145458.6397d04c.akpm@linux-foundation.org>
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812ED44A8@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812ED44A8@EXMAIL03.scwf.nsc.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012 21:14:21 -0800
"Kim, Milo" <Milo.Kim@ti.com> wrote:

> * add 'struct lm3530_pwm_data' in the platform data
>   The pwm data is the platform specific functions which generate the pwm.
>   The pwm data is only valid when brightness is pwm input mode.
>   Functions should be implemented by the pwm driver.
>   pwm_set_intensity() : set duty of pwm.
>   pwm_get_intensity() : get current the brightness.
> 
> * brightness control by pwm
>   If the control mode is pwm, then brightness is changed by the duty of pwm.
>   So pwm platform function should be called in lm3530_brightness_set().
> 
> * do not update brightness register when pwm input mode
>   In pwm input mode, brightness register is not used.
>   If any value is updated in this register, then the led will be off.
> 
> * when input mode is changed, set duty of pwm to 0 if unnecessary.
> 
> * patch base version : kernel 3.2.4
> 
>
> ...
>
> @@ -327,14 +344,11 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
>  		return -EINVAL;
>  	}
>  
> -	if (mode == LM3530_BL_MODE_MANUAL)
> -		drvdata->mode = LM3530_BL_MODE_MANUAL;
> -	else if (mode == LM3530_BL_MODE_ALS)
> -		drvdata->mode = LM3530_BL_MODE_ALS;
> -	else if (mode == LM3530_BL_MODE_PWM) {
> -		dev_err(dev, "PWM mode not supported\n");
> -		return -EINVAL;
> -	}
> +	drvdata->mode = mode;
> +
> +	/* set pwm to low if unnecessary */
> +	if (mode != LM3530_BL_MODE_PWM && pwm->pwm_set_intensity)
> +		pwm->pwm_set_intensity(0, max_brightness);

lm3530_mode_set() has no local variable "pwm" and has no local variable
"brightness".

I see now that you prepared the patches against 3.2.4, which might
contribute to this problem, but I don't see how the patches could work
in 3.2 either.  Perhaps 3.2.4 is significantly different from 3.2.

Anyway, I think I will drop all the patches again until we can get this
fully sorted out.  Please don't prepare patches against ancient old
kernels like 3.2.4!  They should be prepared and tested against the
latest Linus tree, from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git.  Or
against the latest linux-next from 
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
