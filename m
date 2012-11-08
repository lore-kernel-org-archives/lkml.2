Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2KHM3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:29:54 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44735 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab2KHM3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:29:53 -0500
MIME-Version: 1.0
In-Reply-To: <509B6087.2040004@ti.com>
References: <1352299488-11351-1-git-send-email-peter.ujfalusi@ti.com>
	<1352299488-11351-4-git-send-email-peter.ujfalusi@ti.com>
	<CANOLnONc29=cDZE=UXubs7DYOUWbgLJspPPVT2Hfq9E3zXkgVQ@mail.gmail.com>
	<509B6087.2040004@ti.com>
Date: Thu, 8 Nov 2012 14:29:52 +0200
Message-ID: <CANOLnONQf6HH4GbVo2M9RbMytS4GfihypU5grOvDRs8LyP+M6Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] pwm: New driver to support PWM driven LEDs on
 TWL4030/6030 series of PMICs
From: Grazvydas Ignotas <notasas@gmail.com>
To: =?ISO-8859-1?Q?P=E9ter_Ujfalusi?= <peter.ujfalusi@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Tero Kristo <t-kristo@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 9:34 AM, Péter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 11/07/2012 07:12 PM, Grazvydas Ignotas wrote:
>>> +static int twl4030_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
>>> +                             int duty_ns, int period_ns)
>>> +{
>>> +       int duty_cycle = (duty_ns * TWL4030_LED_MAX) / period_ns;
>>> +       u8 on_time;
>>> +       u8 pwm_config[2];
>>> +       int base, ret;
>>> +
>>> +       if (duty_cycle >= TWL4030_LED_MAX)
>>> +               on_time = TWL4030_LED_MAX;
>>> +       else if (!duty_cycle)
>>> +               on_time = TWL4030_LED_MAX - 1;
>>> +       else
>>> +               on_time = TWL4030_LED_MAX - duty_cycle;
>>> +
>>> +       base = pwm->hwpwm * 2 + TWL4030_PWMA_REG;
>>> +
>>> +       pwm_config[0] = on_time;
>>> +       pwm_config[1] = TWL4030_LED_MAX;
>>> +
>>> +       ret = twl_i2c_write(TWL4030_MODULE_LED, pwm_config, base, 2);
>>
>> Shouldn't this use TWL4030_MODULE_PWMA and TWL4030_MODULE_PWMB as
>> first argument? I can guess it works your way too, but
>> TWL4030_MODULE_PWMx would match the TRM better.
>
> I don't have strong opinion regarding to this. You mean changing from:
>
> base = pwm->hwpwm * 2 + TWL4030_PWMA_REG;
> ret = twl_i2c_write(TWL4030_MODULE_LED, pwm_config, base, 2);
>
> to:
>
> if (pwm->hwpwm)
>         module = TWL4030_MODULE_PWMB;
> else
>         module = TWL4030_MODULE_PWMA;
> ret = twl_i2c_write(module, pwm_config, 0, 2);
>
> But I want to note that I'm currently trying to clean up the mess around
> twl-core. In my view we have quite a bit of redundancy in there. The PWM A/B
> is for driving the LED A/B outputs. We should have only these modules for
> PWM/LED in twl-core:
> TWL_MODULE_PWM - offset for PWM0ON register in twl4030 and PWM1ON for twl6030
> TWL_MODULE_LED - offset for LEDEN register in twl4030 and LED_PWM_CTRL1
>                  for twl6030
>
> From here the driver can figure out what to do IMHO.
>
> There's no need to have separate TWL 'modules' for:
> TWL4030_BASEADD_PWM0
> TWL4030_BASEADD_PWM1
> TWL4030_BASEADD_PWMA
> TWL4030_BASEADD_PWMB

Well all these seem to come from TRM, no hard feelings here too but if
you are going to remove them, probably worth adding a comment.

-- 
Gražvydas
