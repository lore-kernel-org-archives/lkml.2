Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1KNJgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:36:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35654 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1KNJgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:36:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAJuYYwRy-oy6MXxrPs+CZU=C2VcvV=-fVfju5Jfc1jJRp1ousg@mail.gmail.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
	<CAJuYYwRy-oy6MXxrPs+CZU=C2VcvV=-fVfju5Jfc1jJRp1ousg@mail.gmail.com>
Date: Mon, 14 Nov 2011 10:36:07 +0100
Message-ID: <CACRpkdZvnD_UfuYwoexdCHRmON_o_ec8=dnOaDNhBrRz1WjMfw@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add a generic pin config interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 12:26 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> [Me]
>> +ret = pin_config(128, PIN_CONFIG_BIAS_PULL_UP, 100000);
>
> struct pinctrl_dev* is required as the first parameter in this example.

Thanks, fixed it.

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
>> +       PIN_CONFIG_INPUT_SCHMITT_OFF,
>> +       PIN_CONFIG_SLEW_RATE_RISING,
>> +       PIN_CONFIG_SLEW_RATE_FALLING,
>> +       PIN_CONFIG_LOAD_CAPACITANCE,
>> +       PIN_CONFIG_POWER_SOURCE,
>> +       PIN_CONFIG_LOW_POWER_MODE,
>> +       PIN_CONFIG_NORMAL_POWER_MODE,
>> +       PIN_CONFIG_WAKEUP_ENABLE,
>> +       PIN_CONFIG_WAKEUP_DISABLE,
>> +       PIN_CONFIG_END,
>> +};
>
> Samsung parts have a 'drive strength' config option for the pads. The
> drive strength is represented as 1x, 2x, 4x, etc .. depending on the
> SoC. The config param that can be used to represent drive strength in
> this case could be PIN_CONFIG_POWER_SOURCE. Or should there be another
> config param for representing drive strength? Otherwise, the above
> config param options are sufficient for all existing Samsung SoC's.

I strongly suspect that you want to use
PIN_CONFIG_DRIVE_PUSH_PULL with a custom argument
representing the drive strength as "data" passed in the call.

Moste "strong" driving is done by push/pull (the others are just oddities)
and if you want to specify a number representing drive strength, the
data parameter is there to do exactly that. For this drive mode the
parameter does not have defined semantics, so you can interpret it
the way you need in your driver.

That said, 1x, 2x, 4x aren't exactly scientific - what does this really
represent, speaking electronics?

On some forum I found this:
http://www.edaboard.com/thread74140.html

   gate drive strength
   The symbols, 1X, 2X, 3X...etc in an ASIC flow in used for
   convinience. What it means is a gate with 2X drive strength
   will have the same rise/fall time while driving a capacitance
   of 2C farads as that of a gate with X drive strength driving a
   capacitance of C farads. You can look at the schematic and
   see that gates with 2X drive strengths have approximately
   twice the widths on output pull up/pull down trasistors as
   comapred to the same gate with 1X drive strength.
   Similarly definitions for 3X, 4X etc.

   This is to ensure that ratio of width to load capacitance
   remains constant, thus resulting in the same transition
   times. It is desired that the transition times in an ASIC
   chip be within a certain limit (DRV critereon). This will
   be met if the following rule is followed -

   If 1X drive strength is sufficient to drive a load of C farads
   (ie, transition time is satisfactory) then 2X drive is
   satisfactory to drive loads between C farads and 2C farads,
   3X drive is sufficient to drive loads between 2C and 3C
   farads....etc.


In practice is seems: 2x = 2 transistors in driver stage, 4x =
4 transistors in driver stage etc.

Maybe we should simply standardize the semantics of the
data argument to PIN_CONFIG_DRIVE_PUSH_PULL
to mean "x times nominal load capacitance with equal
rise/fall times"?

Alternatively we could use the
PIN_CONFIG_SLEW_RATE_RISING and
PIN_CONFIG_SLEW_RATE_FALLING for this,
however there I defined the semantics to be in
nanoseconds, assuming that electronics that can control
this have more delicate amplifiers, and in this case I
think it is more about limiting the rise/fall time by shunting
in resistances in the circuit.

Yours,
Linus Walleij
