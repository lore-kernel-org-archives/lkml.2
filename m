Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1LNSew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:34:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53045 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371Ab1LNSev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:34:51 -0500
MIME-Version: 1.0
In-Reply-To: <20111214140155.GB3999@bnru02.bnr.st.com>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
	<4EDAA785.40503@solonet.org.ua>
	<CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
	<4EDFAA0A.7040607@solonet.org.ua>
	<20111207160002.8b52df42.akpm@linux-foundation.org>
	<20111208011904.GD5748@opensource.wolfsonmicro.com>
	<2E48302EED53D048A7BA72B0A307FB511CF4DFD1C0@EXDCVYMBSTM005.EQ1STM.local>
	<20111214113714.GJ3072@opensource.wolfsonmicro.com>
	<20111214140155.GB3999@bnru02.bnr.st.com>
Date: Wed, 14 Dec 2011 19:34:50 +0100
Message-ID: <CACRpkdaE16-bbvsfzAK2DAmZRqswPvubzt_5ScLpQhDvcDc3uw@mail.gmail.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
From: Linus Walleij <linus.walleij@linaro.org>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 3:01 PM, Shreshtha Kumar SAHU
<shreshthakumar.sahu@stericsson.com> wrote:

> I will try to implement this. In AB5500, PWM provides 1024 steps from 0 to
> full current, and current 16 steps from 2.5mA to 40mA. I need to derive a
> way to optmially change both PWM and current to get requested brigtness in
> range of 0-255 (i.e. LED_OFF to LED_FULL).
> Bur I fear that changing both PWM and current may lead to non linear
> variation and equation needs to be derived to get it correct which will
> add complexity to ab5500_led_brightness_set and hence API brightness.
> In addition if platform sets max current to 10mA then brightness_set()
> will have only 4 steps for current variation and in thus an overhead if
> we combined current and PWM control calculation.

Don't fear this, it sounds like fun to me :-D

A simple linearization table with 256 steps 0.255 vs corresponding
16-bit max current and PWM settings could hide all the complexity
we have I guess?

Like

struct hvled_linearization {
    u16 i_max;
    u16 fade_hi;
    u16 fade_lo;
};

#define LIN_TAB_ENTRY(a, b, c) { .i_max = a, .fade_hi = b, fade_lo = c }

struct hvled_linearization lin_table[] = {
    LIN_TAB_ENTRY(0, 0, 0),
    ... insert the hard part here ;-) ...
    LIN_TAB_ENTRY(65535, 65535, 65535),
};

The problem is I think this table is dependent on the LED fitted
and needs to be supplied as platform data from the board,
which knows which LED is on that board.

Methods to generate table is reading the LED data sheet
(if you have it) or using a photometric instrument while locking
yourself in a totally dark room. (This is the fun part...)
http://en.wikipedia.org/wiki/Photometer

Yours,
Linus Walleij
