Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2KHHei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:34:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42810 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2KHHeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:34:36 -0500
Message-ID: <509B6087.2040004@ti.com>
Date: Thu, 8 Nov 2012 08:34:31 +0100
From: =?UTF-8?B?UMOpdGVyIFVqZmFsdXNp?= <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/3] pwm: New driver to support PWM driven LEDs on TWL4030/6030
 series of PMICs
References: <1352299488-11351-1-git-send-email-peter.ujfalusi@ti.com> <1352299488-11351-4-git-send-email-peter.ujfalusi@ti.com> <CANOLnONc29=cDZE=UXubs7DYOUWbgLJspPPVT2Hfq9E3zXkgVQ@mail.gmail.com>
In-Reply-To: <CANOLnONc29=cDZE=UXubs7DYOUWbgLJspPPVT2Hfq9E3zXkgVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 07:12 PM, Grazvydas Ignotas wrote:
>> +static int twl4030_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
>> +                             int duty_ns, int period_ns)
>> +{
>> +       int duty_cycle = (duty_ns * TWL4030_LED_MAX) / period_ns;
>> +       u8 on_time;
>> +       u8 pwm_config[2];
>> +       int base, ret;
>> +
>> +       if (duty_cycle >= TWL4030_LED_MAX)
>> +               on_time = TWL4030_LED_MAX;
>> +       else if (!duty_cycle)
>> +               on_time = TWL4030_LED_MAX - 1;
>> +       else
>> +               on_time = TWL4030_LED_MAX - duty_cycle;
>> +
>> +       base = pwm->hwpwm * 2 + TWL4030_PWMA_REG;
>> +
>> +       pwm_config[0] = on_time;
>> +       pwm_config[1] = TWL4030_LED_MAX;
>> +
>> +       ret = twl_i2c_write(TWL4030_MODULE_LED, pwm_config, base, 2);
> 
> Shouldn't this use TWL4030_MODULE_PWMA and TWL4030_MODULE_PWMB as
> first argument? I can guess it works your way too, but
> TWL4030_MODULE_PWMx would match the TRM better.

I don't have strong opinion regarding to this. You mean changing from:

base = pwm->hwpwm * 2 + TWL4030_PWMA_REG;
ret = twl_i2c_write(TWL4030_MODULE_LED, pwm_config, base, 2);

to:

if (pwm->hwpwm)
	module = TWL4030_MODULE_PWMB;
else
	module = TWL4030_MODULE_PWMA;
ret = twl_i2c_write(module, pwm_config, 0, 2);

But I want to note that I'm currently trying to clean up the mess around
twl-core. In my view we have quite a bit of redundancy in there. The PWM A/B
is for driving the LED A/B outputs. We should have only these modules for
PWM/LED in twl-core:
TWL_MODULE_PWM - offset for PWM0ON register in twl4030 and PWM1ON for twl6030
TWL_MODULE_LED - offset for LEDEN register in twl4030 and LED_PWM_CTRL1
		 for twl6030

>From here the driver can figure out what to do IMHO.

There's no need to have separate TWL 'modules' for:
TWL4030_BASEADD_PWM0
TWL4030_BASEADD_PWM1
TWL4030_BASEADD_PWMA
TWL4030_BASEADD_PWMB

-- 
Péter
