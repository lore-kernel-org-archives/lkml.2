Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1ENH5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 03:57:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44104 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1ENH5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 03:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O72SfTaUiye3rkwn7KjotmXI7ScbhtEVNGQ0ziVHOka5GmStttoHCDnYW288MpPxlM
         LvoDhIAJgcS4rh4OVdQK5NIjcGxY3DyawA61pjU7I6Efs6ifDkcIH+/DmFxuVzKk6/mE
         4ZnkAJ1tnvOGYhNUnnCmSwsWSIM55nrtxsZOg=
MIME-Version: 1.0
In-Reply-To: <4DCD563C.8040508@parrot.com>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110512074421.GA2429@pengutronix.de>
	<BANLkTi=N8VNh3tPxYH8dQ0UtGpN=xSzKng@mail.gmail.com>
	<F5C24FC168F95048BB6B9E0B13EB33152BA6F5307A@DIAMANT.xi-lite.lan>
	<BANLkTinMxzrPS1GsTV1+poNGTxBpUFyBiw@mail.gmail.com>
	<4DCD563C.8040508@parrot.com>
Date: Sat, 14 May 2011 09:57:35 +0200
X-Google-Sender-Auth: xusVYcHMHqq37SOoW68JUxgelIA
Message-ID: <BANLkTi=SKJFHPgBzi9WdeiPhkkmgs8JGMQ@mail.gmail.com>
Subject: Re: RE : [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/13 Matthieu CASTET <matthieu.castet@parrot.com>:
> Linus Walleij a écrit :
>> 2011/5/12 Matthieu Castet <matthieu.castet@parrot.com>:
>>> You have 2^4 = 16 cases
>>
>> Do you use all of them in practice?
> Of course not all, but more than the 2 { A8, A7, A6, A5 } or { G4, G3, G2, G1 }.
>
> Also when we doing the bsp for a processor, it is better to allow flexibility
> for future board.

Sorry I'm not following, what is inflexible in this case?

> So with your pin mux how to you handle the fact that on spi you can have some
> signal not connected ?
> For { A8, A7, A6, A5 } spi, some board want all 4 spi wire, other want 3 (CS,
> MOSI, CLK) or (MISO, CS, CLK), other want 2.

It's what I define as different functions from the pinmux:

Say if this is SPI0 that can use either 4, 3 or 2 wires you *can* call these
just "spi0-4wire", "spi0-3wire", "spi0-2wire". The only thing the pinmux
subsystem deals with it groups of pins, this is what is called functions.

It does not assume anything about how these functions are defined and
used, it just makes sure they do not overlap.

So with pinmux you can activate function "spi0-2wire" and then use the
two remaining pins as GPIO, no problem, it won't conflict since the
two free pins aren't part of that function.

> This is board specific not package specific.

It relates to how the stuff is connected to the packages I think, and whether
you call that package or board specific is no big issue. What I can say for
sure is if the package didn't have 4 wires wherof you could use only
two, you couldn't do any of this.

> And that's doesn't apply only to spi. That's the same problem for uart (no
> rts/cts), sdcard (one data vs 4 data), ...

No problem at all. You can define the functions you want.

>> The groups of pins are used when you're muxing devices, usually these use
>> more than one pin. And that is why we connect them to the devices
>> themselves with a mapping.
>
> I believe there should be 2 different things :
> - something for select pin. Omap stuff is nice : omap3_mux_init,
> omap_mux_init_gpio, omap_mux_init_signal, ...
> - something for grouping pins, but the board can add new group of pin if it
> doesn't exist.

Now, the framework does not deal with how the groups of pins, i.e. the
functions, are defined. Currently that is done by the drivers. The only
thing it deals with is handling conflicts among pins, and selecting
such groups.

If you want to create these groups from board data (what I call package
data) or say device tree, that is perfectly fine.

> Also what i don't like in your system is the naming :
>> +static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
>> +static unsigned int i2c0_pins[] = { 24, 25 };
>> +static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
> What's 0, 8, 16, .... It should be define.

Again this is an example of a simple driver, it's entirely up to your
driver to do. There are many similar example in Documentation/*
where we don't use #define to simplify examples.

>> +static struct foo_pmx_func myfuncs[] = {
>> +       {
>> +               .name = "spi0-0",
>> +               .pins = spi0_0_pins,
>> +               .num_pins = ARRAY_SIZE(spi0_1_pins),
>> +       },
>> +       {
>> +               .name = "i2c0",
>> +               .pins = i2c0_pins,
>> +               .num_pins = ARRAY_SIZE(i2c0_pins),
>> +       },
>> +       {
>> +               .name = "spi0-1",
>> +               .pins = spi0_1_pins,
>> +               .num_pins = ARRAY_SIZE(spi0_1_pins),
>> +       },
>> +};
>
> How I am supposed to know what's spi0-0, i2c0, spi0-1 without reading the code ?

Again this is an example. If this data came from the device tree for
example, or from arch/arm/mach-foo/package-db3350.c  in some
struct db3350_pin_platform_data{} that I come up with does not
matter to the framework.

It's no different from how say your MMC driver knows how to handle
which GPIO pin is card detect, you have to tell it what pin it is, likewise
you can tell your pinmux driver what pins to handle.

>> +foo_probe()
>> +{
>> +       /* Allocate a state holder named "state" etc */
>> +       struct pinmux pmx;
>> +
>> +       pmx = pinmux_get(&device, NULL);
>> +       if IS_ERR(pmx)
>> +               return PTR_ERR(pmx);
>> +       pinmux_enable(pmx);
>> +
>> +       state->pmx = pmx;
>> +}
>> +If you want a specific mux setting and not just the first one found for this
>> +device you can specify a specific mux setting, for example in the above example
>> +the second i2c0 setting: pinmux_get(&device, "spi0-2");
>
> How a driver that is generic for example sdchi, mmci, ... is supposed to know
> the pinmux name ?

Since the board define function mappings such as:

PINMUX_MAP("sdi0-my-group", "sdi0.0"),

The driver can reference that one association:

pinmux_get(dev, NULL);

If you have different muxings you can also use an optional function
name. This is no different to how you get clocks with clk_get(dev, NULL)
or regulators.

> How this work if the board want a special mux ? I have to modify also the driver ?

No I don't think so. If you mean specify new functions, you write your driver
so that your platform data/package data/device tree/etc can pass muxes in to
it. Don't lock on to the fact that the example driver does all that inside the
driver, it is an example only.

Imagine the same question for regulators. No different, just that the regulator
framework has some standard structure for how to pass in platform data
and I have not defined that. The clk framework has no such standard (yet)
and is comparable, if you had you clock driver in drivers/clk/foo.c you would
have the same problem.

If what you mean is that you want another muxing device, that is fully
supported in the same manner as we support several gpio_chip:s.

Yours,
Linus Walleij
