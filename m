Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1JTJRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:17:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39728 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1JTJRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <20111020023140.GC32007@S2100-06.ap.freescale.net>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com> <20111020023140.GC32007@S2100-06.ap.freescale.net>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 20 Oct 2011 17:17:08 +0800
Message-ID: <CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/20 Shawn Guo <shawn.guo@freescale.com>:
>>  #ifdef CONFIG_DEBUG_FS
>>
>>  static int pinctrl_pins_show(struct seq_file *s, void *what)
>> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
>> index 4f8d208..189c047 100644
>> --- a/include/linux/pinctrl/pinctrl.h
>> +++ b/include/linux/pinctrl/pinctrl.h
>> @@ -19,6 +19,87 @@
>>  #include <linux/list.h>
>>  #include <linux/seq_file.h>
>>
>> +/**
>> + * enum pin_config_param - possible pin configuration parameters
>> + * @PIN_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us
>> + * @PIN_CONFIG_BIAS_FLOAT: no specific bias, the pin will float or state
>> + *   is not controlled by software
>> + * @PIN_CONFIG_BIAS_HIGH_IMPEDANCE: the pin will be set to a high impedance
>> + *   mode, also know as "third-state" (tristate) or "high-Z" or "floating".
>> + *   On output pins this effectively disconnects the pin, which is useful
>> + *   if for example some other pin is going to drive the signal connected
>> + *   to it for a while. Pins used for input are usually always high
>> + *   impedance.
>> + * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
>> + *   impedance to VDD), if the controller supports specifying a certain
>> + *   pull-up resistance, this is given as an argument (in Ohms) when
>> + *   setting this parameter
>> + * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
>> + *   impedance to GROUND), if the controller supports specifying a certain
>> + *   pull-down resistance, this is given as an argument (in Ohms) when
>> + *   setting this parameter
>> + * @PIN_CONFIG_BIAS_HIGH: the pin will be wired high, connected to VDD
>> + * @PIN_CONFIG_BIAS_GROUND: the pin will be grounded, connected to GROUND
>> + * @PIN_CONFIG_DRIVE_UNKNOWN: we don't know the drive mode of this pin, for
>> + *   example since it is controlled by hardware or the information is not
>> + *   accessible but we need a meaningful enumerator in e.g. initialization
>> + *   code
>> + * @PIN_CONFIG_DRIVE_PUSH_PULL: the pin will be driven actively high and
>> + *   low, this is the most typical case and is typically achieved with two
>> + *   active transistors on the output. If the pin can support different
>> + *   drive strengths for push/pull, the strength is given on a custom format
>> + *   as argument when setting pins to this mode
>> + * @PIN_CONFIG_DRIVE_OPEN_DRAIN: the pin will be driven with open drain (open
>> + *   collector) which means it is usually wired with other output ports
>> + *   which are then pulled up with an external resistor. If the pin can
>> + *   support different drive strengths for the open drain pin, the strength
>> + *   is given on a custom format as argument when setting pins to this mode
>> + * @PIN_CONFIG_DRIVE_OPEN_SOURCE: the pin will be driven with open drain
>> + *   (open emitter) which is the same as open drain mutatis mutandis but
>> + *   pulled to ground. If the pin can support different drive strengths for
>> + *   the open drain pin, the strength is given on a custom format as
>> + *   argument when setting pins to this mode
>> + * @PIN_CONFIG_DRIVE_OFF: the pin is set to inactive drive mode, off
>> + * @PIN_CONFIG_INPUT_SCHMITT: this will configure an input pin to run in
>> + *   schmitt-trigger mode. If the schmitt-trigger has adjustable hysteresis,
>> + *   the threshold value is given on a custom format as argument when
>> + *   setting pins to this mode
>> + * @PIN_CONFIG_SLEW_RATE_RISING: this will configure the slew rate for rising
>> + *   signals on the pin. The argument gives the rise time in nanoseconds
>> + * @PIN_CONFIG_SLEW_RATE_FALLING: this will configure the slew rate for falling
>> + *   signals on the pin. The argument gives the fall time in nanoseconds
>> + * @PIN_CONFIG_LOAD_CAPACITANCE: some pins have inductive characteristics and
>> + *   will deform waveforms when signals are transmitted on them, by
>> + *   applying a load capacitance, the waveform can be rectified. The
>> + *   argument gives the load capacitance in picofarad (pF)
>> + * @PIN_CONFIG_WAKEUP_ENABLE: this will configure an input pin such that if a
>> + *   signal transition arrives at the pin when the pin controller/system
>> + *   is sleeping, it will wake up the system
>> + * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
>> + *   you need to pass in custom configurations to the pin controller, use
>> + *   PIN_CONFIG_END+1 as the base offset
>> + */
>> +enum pin_config_param {
>> +     PIN_CONFIG_BIAS_UNKNOWN,
>> +     PIN_CONFIG_BIAS_FLOAT,
>> +     PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
>> +     PIN_CONFIG_BIAS_PULL_UP,
>> +     PIN_CONFIG_BIAS_PULL_DOWN,
>> +     PIN_CONFIG_BIAS_HIGH,
>> +     PIN_CONFIG_BIAS_GROUND,
>> +     PIN_CONFIG_DRIVE_UNKNOWN,
>> +     PIN_CONFIG_DRIVE_PUSH_PULL,
>> +     PIN_CONFIG_DRIVE_OPEN_DRAIN,
>> +     PIN_CONFIG_DRIVE_OPEN_SOURCE,
>> +     PIN_CONFIG_DRIVE_OFF,
>> +     PIN_CONFIG_INPUT_SCHMITT,
>> +     PIN_CONFIG_SLEW_RATE_RISING,
>> +     PIN_CONFIG_SLEW_RATE_FALLING,
>> +     PIN_CONFIG_LOAD_CAPACITANCE,
>> +     PIN_CONFIG_WAKEUP_ENABLE,
>> +     PIN_CONFIG_END,
>> +};
>> +
>
> IMO, trying to enumerate all possible pin_config options is just to
> make everyone's life harder.  Firstly, this enumeration is far from
> completion, for imx6 iomuxc example, we have 3 options for pull-up,
> 22, 47 and 100 kOhm, and 7 options for driver-strength, 34, 40, 48,
> 60, 80, 120, and 240 Ohm.  It's just so hard to make this enumeration
> complete.  Secondly, defining this param as enum requires the API
> user to call the function multiple times to configure one pin.  For
> example, if I want to configure pin_foo as slow-slew, open-drain,
> 100 kOhm pull-up and 120 Ohm driver-strength, I will have to call
> pin_config(pctldev, pin_foo, ...) 4 times to achieve that.
>
> I like Stephen's idea about having 'u32 param' and let pinctrl drivers
> to encode/decode this u32 for their pinctrl controller.  It makes
> people's life much easier.

A multifunctional API is actually  a bad and hard-to-use API. i agree
we can make param u32 instead of enum and let specific driver
customizes the param by itself.

But if there are some common params, for example, PULL, OC/OD,
WAKEUP_ENABLE, which almost all platforms need,  why don't we make
them have common definitions like:

#define PIN_CONFIG_PULL                             0
#define PIN_CONFIG_OPEN_DRAIN                1
....
#define PIN_CONFIG_USER                            5 (in case)

if one platform has config not in the up list, then:

#define PIN_CONFIG_TERGA_XXX                PIN_CONFIG_USER
#define PIN_CONFIG_TERGA_YYY                (PIN_CONFIG_USER + 1)

without the common definition from  PIN_CONFIG_PULL to
PIN_CONFIG_USER, many platforms will need to definite them repeatedly.
that is what we hate.

>
> --
> Regards,
> Shawn

-barry
