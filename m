Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2IZSxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:53:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46249 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202Ab2IZSxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:53:13 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Subject: Re: replacement for /sys/kernel/debug/omap_mux in DT/pinctrl land ?
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <20120926185202.GF4840@atomide.com>
Date: Wed, 26 Sep 2012 20:53:10 +0200
Cc: Matt Porter <mporter@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        List List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <39625BB0-1F8A-4ED1-B50C-5FB846B97934@dominion.thruhere.net>
References: <D7202A6C-5250-4B55-B3B8-FF15BCCA97AC@dominion.thruhere.net> <20120926125658.GA5641@beef> <CACRpkdYqVC4Vou+0Mn1OmQg8vPxDULDcFDD0yV5nassqkE1Zag@mail.gmail.com> <20120926161546.GC5641@beef> <50515DB7-8D0C-4F74-B390-78BC9CD86FC9@dominion.thruhere.net> <20120926185202.GF4840@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1498)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 26 sep. 2012, om 20:52 heeft Tony Lindgren <tony@atomide.com> het volgende geschreven:

> * Koen Kooi <koen@dominion.thruhere.net> [120926 10:23]:
>> 
>> Op 26 sep. 2012, om 18:15 heeft Matt Porter <mporter@ti.com> het volgende geschreven:
>> 
>>> On Wed, Sep 26, 2012 at 03:03:27PM +0200, Linus Walleij wrote:
>>>> On Wed, Sep 26, 2012 at 2:56 PM, Matt Porter <mporter@ti.com> wrote:
>>>>> Adding Linus W. and lkml.
>>>>> On Wed, Sep 26, 2012 at 01:46:45PM +0200, Koen Kooi wrote:
>>>>>> Hi,
>>>>>> 
>>>>>> With a patched 3.6rc7 on my beaglebone I can set the pinmux for pins using pinctrl and that seems to work. On the 3.2 vendor tree there was the omap_mux driver with an awesome debugfs interface:
>>>>>> 
>>>>>> # cat /sys/kernel/debug/omap_mux/lcd_data0
>>>>>> name: lcd_data0.ehrpwm2A (0x44e108a0/0x8a0 = 0x0003), b NA, t NA
>>>>>> mode: OMAP_PIN_OUTPUT | OMAP_MUX_MODE3
>>>>>> signals: lcd_data0 | gpmc_a0 | pr1_mii_mt0_clk | ehrpwm2A | NA | pr1_pru1_pru_r30_0 | pr1_pru1_pru_r31_0 | gpio2_6
>>>>>> 
>>>>>> Notice how it tells me that it's muxed the PWM in 2 ways: signal name (ehrpwm2A) and register content (0x0003). Compare to pinctrl:
>>>>>> 
>>>>>> root@bone-mainline:/sys/kernel/debug/pinctrl/44e10800.pinmux# grep 8a0 *
>>>>>> pinconf-pins:pin 40 (44e108a0):
>>>>>> pingroups:pin 40 (44e108a0)
>>>>>> pinmux-pins:pin 40 (44e108a0): 4a300000.pruss (GPIO UNCLAIMED) function pinmux_pruss_led_pins group pinmux_pruss_led_pins
>>>>>> pins:pin 40 (44e108a0)  pinctrl-single
>>>>>> 
>>>>>> What is that pin muxed to? It is part of the 'pinmux_pruss_led_pins' in the DT, but debugfs remains mute on how pin 40 is muxed.
>>>>> 
>>>>> It does seem like a pretty big gap in the pinctrl/pinmux debugfs
>>>>> interface when viewed from an OMAP perspective. Ideally there would
>>>>> be a pinctrl/pinmux hook to the pinmux driver to provide the detailed
>>>>> h/w specific pin state info.
>>>> 
>>>> So add the hooks you need?
>>> 
>>> Ok. :)
>>> 
>>>> I assume you are using Tony's pinctrl-single driver, so Tony is the one to ask.
>>> 
>>> Yes, so roughly for pinctrl-single I have the following...likely broken
>>> for arbitrary register sizes but a starting point. Tony, any thoughts
>>> about this?
>>> 
>>> Koen: you just need a userspace tool that groks the raw data for human
>>> consumption. The nice thing is that the old omap_mux implementation had
>>> plenty of OMAP-isms in the parser that didn't apply to AM33xx. A
>>> userspace tool can do a better job of parsing on a per-part basis.
>>> 
>>> --- a/drivers/pinctrl/pinctrl-single.c
>>> +++ b/drivers/pinctrl/pinctrl-single.c
>>> @@ -246,7 +246,15 @@ static void pcs_pin_dbg_show(struct pinctrl_dev *pctldev,
>>> 					struct seq_file *s,
>>> 					unsigned offset)
>>> {
>>> -	seq_printf(s, " " DRIVER_NAME);
>>> +	struct pcs_device *pcs;
>>> +	unsigned val;
>>> +
>>> +	pcs = pinctrl_dev_get_drvdata(pctldev);
>>> +
>>> +	val = pcs->read(pcs->base + offset);
>>> +	val &= pcs->fmask;
>>> +
>>> +	seq_printf(s, "%08x %s " , val, DRIVER_NAME);
>>> }
>>> 
>>> static void pcs_dt_free_map(struct pinctrl_dev *pctldev,
>> 
>> Much better already:
>> 
>> root@bone-mainline:/sys/kernel/debug/pinctrl/44e10800.pinmux# grep 8a0 pins
>> pin 40 (44e108a0) 00000027 pinctrl-single 
> 
> Cool :) For the proper patch feel free to add:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 
>> Now I can write a userspace tool do list the current muxes without resorting to devmem2!
> 
> Yeah maybe add support to omapconf for that? I can generate
> the data for balls etc from old omap mux if you let me know the
> format you need.


It's for am335x :)