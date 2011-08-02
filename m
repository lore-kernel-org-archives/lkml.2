Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab1HBHF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:05:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49549 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HBHFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110727153414.80f810e7.akpm@linux-foundation.org>
References: <20110713105203.5481.94746.sendpatchset@t400s>
	<20110727153414.80f810e7.akpm@linux-foundation.org>
Date: Tue, 2 Aug 2011 16:05:20 +0900
Message-ID: <CANqRtoRKZf5kzs06JPA1uF+C4=hOu67E-ZeiVpjr9aKaGu6B0A@mail.gmail.com>
Subject: Re: [PATCH] leds: Renesas TPU LED driver V2
From: Magnus Damm <magnus.damm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, rpurdie@rpsys.net,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, Jul 28, 2011 at 7:34 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 13 Jul 2011 19:52:03 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch adds V2 of the LED driver for a single timer channel
>> for the TPU hardware block commonly found in Renesas SoCs.
>>
>> The driver has been written with optimal Power Management in
>> mind, so to save power the LED is driven as a regular GPIO pin
>> in case of maximum brightness and power off which allows the
>> TPU hardware to be idle and which in turn allows the clocks to
>> be stopped and the power domain to be turned off transparently.
>>
>> Any other brightness level requires use of the TPU hardware
>> in PWM mode. TPU hardware device clocks and power are managed
>> through Runtime PM. System suspend and resume is known to be
>> working - during suspend the LED is set to off by the generic
>> LED code.
>>
>> The TPU hardware timer is equipeed with a 16-bit counter together
>> with an up-to-divide-by-64 prescaler which makes the hardware
>> suitable for brightness control. Hardware blink is unsupported.
>>
>> The LED PWM waveform has been verified with a Fluke 123 Scope
>> meter on a sh7372 Mackerel board. Tested with experimental sh7372
>> A3SP power domain patches. Platform device bind/unbind tested ok.
>>
>> V2 has been tested on the DS2 LED of the sh73a0-based AG5EVM.
>>
>>
>> ...
>>
>> +static int r_tpu_enable(struct r_tpu_priv *p, enum led_brightness brightness)
>> +{
>> +     struct led_renesas_tpu_config *cfg = p->pdev->dev.platform_data;
>> +     int prescaler[] = { 1, 4, 16, 64 };
>> +     int k, ret;
>> +     unsigned long rate, tmp;
>> +
>> +     if (p->timer_state == R_TPU_TIMER_ON)
>> +             return 0;
>
> Is timer_state actually needed?  It looks like it's covering up bugs:
> callers enabling an already-enabled device or disabling an
> already-diabled one.

The driver needs to keep track of the state of the GPIO pin and the
TPU timer channel. One reason for this is that without such house
keeping information we don't know what needs to disabled in the
->remove() callback for the platform driver. We cannot assume that the
TPU timer is on in ->remove() because the state of the GPIO and the
TPU will vary depending on brightness value. Another place where the
old state is needed is in the ->brightness_set() callback.

> Also it might be a bit racy.

It seems like I incorrectly assumed that the ->brightness_set()
callback is kept serialized for each LED device. Unless I
misunderstand the LED core it seems like a sysfs brightness write
which invokes led_brightness_store() may call led_set_brightness() in
parallel with led_blink_set() when software blinking is enabled.

I can easily add some locking to the ->brightness_set() callback in
the TPU driver, but perhaps this should be fixed in the LED core
instead? Perhaps the led_set_brightness() and led_blink_set() race
should be fixed somehow, maybe the blink timer should be disabled when
the sysfs brightness write happens?

Thanks for your help!

/ magnus
