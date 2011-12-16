Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab1LPFLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 00:11:14 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:45854 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749Ab1LPFLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 00:11:13 -0500
Date: Fri, 16 Dec 2011 10:40:31 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-ID: <20111216051031.GA13690@bnru05.bnr.st.com>
References: <4EDAA785.40503@solonet.org.ua>
 <CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
 <4EDFAA0A.7040607@solonet.org.ua>
 <20111207160002.8b52df42.akpm@linux-foundation.org>
 <20111208011904.GD5748@opensource.wolfsonmicro.com>
 <2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
 <20111214113714.GJ3072@opensource.wolfsonmicro.com>
 <20111214140155.GB3999@bnru02.bnr.st.com>
 <CACRpkdaE16-bbvsfzAK2DAmZRqswPvubzt_5ScLpQhDvcDc3uw@mail.gmail.com>
 <20111215071113.GD24248@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111215071113.GD24248@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 08:11:14 +0100, Mark Brown wrote:
> On Wed, Dec 14, 2011 at 07:34:50PM +0100, Linus Walleij wrote:
> 
> > The problem is I think this table is dependent on the LED fitted
> > and needs to be supplied as platform data from the board,
> > which knows which LED is on that board.
> 
> To a good approximation the restriction from the LED comes from the
> maximum current it can sustain so it's usually a fairly simple input.

As I understnad, please corrent me if I am worng, it is decided during
platform design and setting the max current for each LED in a platform
fulfills the above requirement which is already taken care in driver.

Based on suggestion by Mark, to control both PWM and Sink current to
vary brightness, here is the outcome:

How it was:
Max sink current was set for each LED (range 2.5mA to 40mA), and PWM
was varied to get the desired brightness (PWM in range 0 to 1023).
Current increase on each PWM increase was constant i.e. max_curr/1023.

How it is now:
Max sink current is known, but sink current value is set along with
PWM to control the brightness. So now with each request to increase
brightness, sink current is determined based on:
	requested_brt / (LED_FULL/SINKCURR_MAX)
In this case requested_brt vary from 0 to 255 and SINKCURR_MAX is 15.

Now sink_current is changing, hence current increase on each PWM increase
will vary based on:
As current increase on each PWM increase is based on (sink_current / PWM_MAX)
where PWM_MAX is 1023. But now sink_currnet is changing so current increase
on each PWM increase will also change.

So the idea in implementation is to change the sink_current and calculate
the PWM value based on currently set sink current, so that the current
change on each PWM rise remains same.

Implementation is greatly simplified by following lookup table:

#define AB5500_LED_SINKCURR_MAX                0x0F
#define AB5500_LED_SINKCURR_STEPS(_max_curr)   (LED_FULL/(_max_curr))

/*
 * This table provides the multiplier to get linear  variation of current
 * and hence led brightness. In actual these are PWM steps multiplier to
 * get PWM value such that the current vary linearly (as sink current
 * along with PWM is configured) and hence the led brightness.
 *
 * rows are max_current set for the led instance
 * cols are current step of 16 step current stair
 *
 */
static u8 led_lin_table[AB5500_LED_SINKCURR_MAX+2]
                       [AB5500_LED_SINKCURR_MAX+2] = {
       {4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
       {8, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
       {12, 6, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
       {16, 8, 5, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
       {20, 10, 7, 5, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
       {24, 12, 8, 6, 5, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
       {28, 14, 9, 7, 6, 5, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0,},
       {32, 16, 11, 8, 6, 5, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0,},
       {36, 18, 12, 9, 7, 6, 5, 4, 4, 0, 0, 0, 0, 0, 0, 0,},
       {40, 20, 13, 10, 8, 7, 6, 5, 4, 4, 0, 0, 0, 0, 0, 0,},
       {44, 22, 15, 11, 9, 7, 6, 5, 5, 4, 4, 0, 0, 0, 0, 0,},
       {48, 24, 16, 12, 10, 8, 7, 6, 5, 5, 4, 4, 0, 0, 0, 0,},
       {52, 26, 17, 13, 10, 9, 7, 6, 6, 5, 5, 4, 4, 0, 0, 0,},
       {56, 28, 19, 14, 11, 9, 8, 7, 6, 5, 5, 5, 4, 4, 0, 0,},
       {60, 30, 20, 15, 12, 10, 8, 7, 7, 6, 5, 5, 5, 4, 4, 0,},
       {64, 32, 21, 16, 13, 11, 9, 8, 7, 6, 6, 5, 5, 4, 4, 4,},
};

And the formula used when brightness change is requested from user:

u8 curr_max = led->max_current, curr_val;
u16 pwm_val;

curr_val = (led->brt_val / (AB5500_LED_SINKCURR_STEPS(curr_max)));
pwm_val = led->brt_val * led_lin_table[curr_max][curr_val];

Please provide feedback on this, if it fulfills the requirement.

Regards,
Shreshtha
