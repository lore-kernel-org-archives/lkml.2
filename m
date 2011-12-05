Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab1LEQBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:01:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44886 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432Ab1LEQBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:01:03 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174FDB0312@HQMAIL01.nvidia.com>
References: <1322736902-11297-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174FDB0312@HQMAIL01.nvidia.com>
Date: Mon, 5 Dec 2011 17:01:02 +0100
Message-ID: <CACRpkdaGaYdQagOkFxfRpV=oxyxab40X5zzpeCamTCksuHQAaw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v5] pinctrl: introduce generic pin config
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 10:56 PM, Stephen Warren <swarren@nvidia.com> wrote:

>> +void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
>> +                           struct seq_file *s, unsigned pin)
> ...
>> +             config = to_config_packed(conf_items[i].param, 0);
> ...
>> +             /* Print unit if available */
>> +             if (conf_items[i].format && config != 0)
>
> Why the check for "config != 0"; isn't the "param" always left in config
> by pin_config_get, such that it's never 0?

Should be to_config_argumen(config) != 0 so that if you
have say an "unspecified pull-up", that means BIAS_PULL_UP
and argument 0, so we do not print this as (0 Ohm).

Fixed it.

>> +enum pin_config_param {
>> +     PIN_CONFIG_BIAS_DISABLE,
>> +     PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
>> +     PIN_CONFIG_BIAS_PULL_UP,
>> +     PIN_CONFIG_BIAS_PULL_DOWN,
>> +     PIN_CONFIG_BIAS_HIGH,
>> +     PIN_CONFIG_BIAS_GROUND,
>> +     PIN_CONFIG_DRIVE_PUSH_PULL,
>> +     PIN_CONFIG_DRIVE_OPEN_DRAIN,
>> +     PIN_CONFIG_DRIVE_OPEN_SOURCE,
>> +     PIN_CONFIG_DRIVE_OFF,
>> +     PIN_CONFIG_INPUT_SCHMITT,
>> +     PIN_CONFIG_INPUT_DEBOUNCE,
>> +     PIN_CONFIG_SLEW_RATE_RISING,
>> +     PIN_CONFIG_SLEW_RATE_FALLING,
>> +     PIN_CONFIG_POWER_SOURCE,
>> +     PIN_CONFIG_LOW_POWER_MODE,
>> +     PIN_CONFIG_WAKEUP,
>> +     PIN_CONFIG_END,
>> +};
>
> This enum conflates both "parameter" and "value" into a single enum space.

I call these "parameter" and "argument" but I get it.

> The patch introduces to_config_packed() and friends specifically to pack
> both param and value into a single unsigned long, but then defines the
> "param" to encompass "value" as well. That seems inconsistent. Instead,
> shouldn't you have something more like:
>
> enum pin_config_param {
>        PIN_CONFIG_BIAS,
>        PIN_CONFIG_DRIVE,
>        PIN_CONFIG_INPUT_SCHMITT,
>        PIN_CONFIG_INPUT_DEBOUNCE,
>        PIN_CONFIG_SLEW_RATE_RISING,
>        PIN_CONFIG_SLEW_RATE_FALLING,
>        PIN_CONFIG_POWER_SOURCE,
>        PIN_CONFIG_LOW_POWER_MODE,
>        PIN_CONFIG_WAKEUP,
>        PIN_CONFIG_END,
> };
>
> /* Value for PIN_CONFIG_BIAS */
> enum pin_config_bias_value {
>        PIN_CONFIG_BIAS_DISABLE,
>        PIN_CONFIG_BIAS_HIGH_IMPEDANCE,
>        PIN_CONFIG_BIAS_PULL_UP,
>        PIN_CONFIG_BIAS_PULL_DOWN,
>        PIN_CONFIG_BIAS_HIGH,
>        PIN_CONFIG_BIAS_GROUND,
> };

But if I can control the resistance of the pull-up resistor
that brings us to a triplet: {parameter, type, argument}
like this to set the generic pull-up to 100 kOhm:

set_generic_bias(PIN_CONFIG_BIAS, PIN_CONFIG_BIAS_PULL_UP, 100000);

parameter = BIAS
type = PULL_UP
argument = 100 kOhm

I essentially squash { parameter, type } into a single
enum here, then use the argument to supply the
value.

> /* Value for PIN_CONFIG_DRIVE */
> enum pin_config_drive_value {
>        PIN_CONFIG_DRIVE_PUSH_PULL,
>        PIN_CONFIG_DRIVE_OPEN_DRAIN,
>        PIN_CONFIG_DRIVE_OPEN_SOURCE,
>        PIN_CONFIG_DRIVE_OFF,
> };
>
> /*
>  * Value for:
>  * PIN_CONFIG_INPUT_SCHMITT,
>  * PIN_CONFIG_INPUT_DEBOUNCE,


Don't you mean we would then have

pin_config_param {
   PIN_CONFIG_INPUT_MODE,
   ...
}

enum pin_config_input_mode_value {
    PIN_CONFIG_INPUT_MODE_SCHMITT,
    PIN_CONFIG_INPUT_MODE_DEBOUNCE,
};

>  * PIN_CONFIG_LOW_POWER_MODE,
>  * PIN_CONFIG_WAKEUP,
>  * PIN_CONFIG_END,
>  */

etc.

I think it might be sub-dividing it too much, but it certainly
doesn't hurt the implementation much to split it in three,
say 8 bits parameter 8 bits type 16 bits argument if that is
preferable what do others say?

Yours,
Linus Wallej
