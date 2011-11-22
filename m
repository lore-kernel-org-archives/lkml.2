Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1KVMSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:18:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57540 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1KVMSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:18:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAJuYYwRFGn+Efu80yjszuBof5omN1RvKjz7efh8bwK2t-MUj+A@mail.gmail.com>
References: <1321904871-32278-1-git-send-email-linus.walleij@stericsson.com>
	<CAJuYYwRFGn+Efu80yjszuBof5omN1RvKjz7efh8bwK2t-MUj+A@mail.gmail.com>
Date: Tue, 22 Nov 2011 13:18:46 +0100
Message-ID: <CACRpkdYwfW+wNxxJmFcXsR-u7nZndbGQA4Y-cQDrV-oOQ33b1A@mail.gmail.com>
Subject: Re: [PATCH 1/8 v3] pinctrl: add a generic pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:52 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> On 22 November 2011 01:17, Linus Walleij <linus.walleij@stericsson.com> wrote:

>>(...)
>> @@ -61,6 +67,10 @@ struct pin_desc {
>>  #ifdef CONFIG_PINMUX
>>        const char *mux_function;
>>  #endif
>> +#ifdef CONFIG_PINCONF
>> +       struct mutex config_lock;
>> +       struct pin_config config;
>
> Some platforms (like exynos) can read back the current pin_config from
> the hardware registers. For such platforms, 'config' would consume
> additional space which will not be used. Can 'config' be made a
> pointer and memory for it allocated in 'pinctrl_register_one_pin' only
> if the pin-controller requires it. Maybe, 'struct pinctrl_desc' can
> have a additional member to describe some of its characteristics such
> as ability to read back pin configuration from registers.

Yes. And I also do realize that most controllers at hand does not have
this limitation. I had second thoughts about it yesterday, so I'll
refactor this to assume that we can read back values from the
hardware instead, if a hardware has the mentioned limitation it
can do the caching in the driver instead. I can't quite remember
why I did it this way anyway, stupid me :-(

> EXPORT_SYMBOL(pin_config); here ?
> EXPORT_SYMBOL(pin_config_group); here ?

Yep added them.

>> +enum pin_config_param {
>> +       PIN_CONFIG_BIAS_DISABLE,
>> +       PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
>> +       PIN_CONFIG_BIAS_PULL_UP,
>> +       PIN_CONFIG_BIAS_PULL_DOWN,
>> +       PIN_CONFIG_BIAS_HIGH,
>> +       PIN_CONFIG_BIAS_GROUND,
>> +       PIN_CONFIG_DRIVE_PUSH_PULL,
>> +       PIN_CONFIG_DRIVE_OPEN_DRAIN,
>> +       PIN_CONFIG_DRIVE_OPEN_SOURCE,
>> +       PIN_CONFIG_DRIVE_OFF,
>> +       PIN_CONFIG_INPUT_SCHMITT,
>> +       PIN_CONFIG_INPUT_DEBOUNCE,
>> +       PIN_CONFIG_SLEW_RATE_RISING,
>> +       PIN_CONFIG_SLEW_RATE_FALLING,
>> +       PIN_CONFIG_POWER_SOURCE,
>> +       PIN_CONFIG_LOW_POWER_MODE,
>> +       PIN_CONFIG_WAKEUP,
>> +       PIN_CONFIG_END,
>> +};
>
> For all Samsung SoC's, PIN_CONFIG_BIAS_PULL_UP,
> PIN_CONFIG_BIAS_PULL_DOWN and PIN_CONFIG_DRIVE_PUSH_PULL would be
> sufficient. So the above list of config options is fine for all
> Samsung platforms.

Thanks! That's what I needed to know.

>> +extern int pin_config(struct pinctrl_dev *pctldev, int pin,
>> +                     const struct pin_config_tuple *configs,
>> +                     unsigned num_configs);
>
>
> Is the 'pin' number expected to be local to the pin-controller
> represented by 'pctldev' ?

Yes, the entire subsystem is designed like that.

>  There can be multiple pin-controllers in a
> system, so it would be easier if 'pin' parameter above is a
> system-wide pin number, and the caller of 'pin_config' need not know
> which pin-controller manages 'pin'. Ideally, 'pctldev' should not be
> included in the parameter list.

I did that in the initial pinctrl patch set and Grant NACK:ed it
and requested that the pin controller pin space be local to each
pin controller.

The reason is that the global GPIO pin space is nothing but one
big mess, it's arbitrarily roofed at ARCH_NR_GPIOS and what
is that number in a single zImage for multiple platforms anyway?

Global GPIO 15 in a multi-platform binary would mean totally
different things depending on where it boots and strange numbers
have to be encoded everywhere.

Actually the plan is to kill the global number space from GPIO
too, one day. So the GPIO maintainer would like GPIO to be
like pinctrl not the other way around...

Yours,
Linus Walleij
