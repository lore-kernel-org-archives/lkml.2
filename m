Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab1EMQDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:03:45 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:54429 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1EMQDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:03:44 -0400
Message-ID: <4DCD563C.8040508@parrot.com>
Date: Fri, 13 May 2011 18:03:08 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RE : [PATCH 0/4] Pinmux subsystem
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>	<20110512074421.GA2429@pengutronix.de>	<BANLkTi=N8VNh3tPxYH8dQ0UtGpN=xSzKng@mail.gmail.com>	<F5C24FC168F95048BB6B9E0B13EB33152BA6F5307A@DIAMANT.xi-lite.lan> <BANLkTinMxzrPS1GsTV1+poNGTxBpUFyBiw@mail.gmail.com>
In-Reply-To: <BANLkTinMxzrPS1GsTV1+poNGTxBpUFyBiw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij a écrit :
> 2011/5/12 Matthieu Castet <matthieu.castet@parrot.com>:
> 
>> Enumerating all possible case will be impossible because of the number of possible cases
>> (and hardware guys can be very creative).
> 
> As mentioned in the document the subsystem is not about discrete
> mathematics, i.e
> we have no intent on enumerating every possible mux setting, only the ones that
> are relevant for your electronics at hand.
> 
>> If spi can be in  { A8, A7, A6, A5 } and
>> { G4, G3, G2, G1 }, Then you can output the spi on :
>> - { A8, A7, A6, A5 }
>> - { A8, A7, A6, G1 }
>> - { A8, A7, G2, A5 }
>> [...]
>> - { G4, G3, G2, A5 }
>> - { G4, G3, G2, G1 }
>> You have 2^4 = 16 cases
> 
> Do you use all of them in practice?
Of course not all, but more than the 2 { A8, A7, A6, A5 } or { G4, G3, G2, G1 }.

Also when we doing the bsp for a processor, it is better to allow flexibility
for future board.

So with your pin mux how to you handle the fact that on spi you can have some
signal not connected ?
For { A8, A7, A6, A5 } spi, some board want all 4 spi wire, other want 3 (CS,
MOSI, CLK) or (MISO, CS, CLK), other want 2.

This is board specific not package specific.

And that's doesn't apply only to spi. That's the same problem for uart (no
rts/cts), sdcard (one data vs 4 data), ...



> 
>> Pin muxing is really board specific  and shouldn't be in a "generic" driver.
> 
> It is rather package (PGA/BGA etc) specific than board specific. The board
> is about what of the packaging options you actually use. As
> mentioned in previous discussions you can pass in the actual configuration
> of the mux settings from platform data, if we have device tree we can let the
> board file dts inherit a package descriptor. All of this outside the
> kernel tree.
> 
> So we define the function groups for the package that will actually be used
> by the devices in the board files that we have.
> 
> And my first assumption is that those really aren't that many, and my second
> assumption is that you would still have to have board-specific code to handle
> every individual pin somewhere under mach-xxxx and this is what we're
> currently trying to get away from.
> 
>> But what you could abstract is a way to select a configuration of a pin,
>> not a group of pin for the board files.
> 
> The groups of pins are used when you're muxing devices, usually these use
> more than one pin. And that is why we connect them to the devices
> themselves with a mapping.
I believe there should be 2 different things :
- something for select pin. Omap stuff is nice : omap3_mux_init,
omap_mux_init_gpio, omap_mux_init_signal, ...
- something for grouping pins, but the board can add new group of pin if it
doesn't exist.


Also what i don't like in your system is the naming :
> +static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
> +static unsigned int i2c0_pins[] = { 24, 25 };
> +static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
What's 0, 8, 16, .... It should be define.

> +static struct foo_pmx_func myfuncs[] = {
> +       {
> +               .name = "spi0-0",
> +               .pins = spi0_0_pins,
> +               .num_pins = ARRAY_SIZE(spi0_1_pins),
> +       },
> +       {
> +               .name = "i2c0",
> +               .pins = i2c0_pins,
> +               .num_pins = ARRAY_SIZE(i2c0_pins),
> +       },
> +       {
> +               .name = "spi0-1",
> +               .pins = spi0_1_pins,
> +               .num_pins = ARRAY_SIZE(spi0_1_pins),
> +       },
> +};
How I am supposed to know what's spi0-0, i2c0, spi0-1 without reading the code ?

> +foo_probe()
> +{
> +       /* Allocate a state holder named "state" etc */
> +       struct pinmux pmx;
> +
> +       pmx = pinmux_get(&device, NULL);
> +       if IS_ERR(pmx)
> +               return PTR_ERR(pmx);
> +       pinmux_enable(pmx);
> +
> +       state->pmx = pmx;
> +}
> +If you want a specific mux setting and not just the first one found for this
> +device you can specify a specific mux setting, for example in the above example
> +the second i2c0 setting: pinmux_get(&device, "spi0-2");

How a driver that is generic for example sdchi, mmci, ... is supposed to know
the pinmux name ?
How this work if the board want a special mux ? I have to modify also the driver ?


Matthieu


