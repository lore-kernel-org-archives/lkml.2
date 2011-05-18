Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1ERFrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:47:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41067 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1ERFrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IqVZZT8xP9zielT87MlwyT0/J6ASJqP9P6voENUZmjneCYqP1pEEECWHyokJFsvYGc
         BYRRMa1dGYOYeENqQEklKg9aijxIHkRsrsheEOWJuaD6FfsgQ6XYrSeB1T57ijV3AV2O
         FrGPPmKDAYUKL+lHlr34wn+cpkvkusDUargC4=
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04986AAB5F@HQMAIL01.nvidia.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
	<74CDBE0F657A3D45AFBB94109FB122FF04986AA6A2@HQMAIL01.nvidia.com>
	<BANLkTi=wTB6R8vjHVAWM3T0e5HjOq77tdA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04986AAB5F@HQMAIL01.nvidia.com>
Date: Wed, 18 May 2011 07:47:17 +0200
X-Google-Sender-Auth: FU3lZWIaZxXDhazVbs3KH2PvrZM
Message-ID: <BANLkTi=0OTUsCvj2fJTKnGiCjqVx=bOHrA@mail.gmail.com>
Subject: Re: [PATCH] drivers: create a pinmux subsystem v2
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/17 Stephen Warren <swarren@nvidia.com>:

> Just to make sure, let me augment your simple driver example from
> Documentation/pinmux.txt in your patch for a hypothetical machine that
> has a bus that can be 2, 4, or 8-bits in size:
>
> static unsigned int spi0_0_pins[] = { 0, 8, 16, 24 };
> static unsigned int i2c0_pins[] = { 24, 25 };
> static unsigned int spi0_1_pins[] = { 38, 46, 54, 62 };
> static unsigned int bus0_1_0_pins[] = { 1, 2, };
> static unsigned int bus0_3_2_pins[] = { 3, 4, };
> static unsigned int bus0_7_4_pins[] = { 5, 6, 7, 9 };
>
> static struct foo_pmx_func myfuncs[] = {
>        {
>                .name = "spi0-0",
>                .pins = spi0_0_pins,
>                .num_pins = ARRAY_SIZE(spi0_1_pins),
>        },
>        {
>                .name = "i2c0",
>                .pins = i2c0_pins,
>                .num_pins = ARRAY_SIZE(i2c0_pins),
>        },
>        {
>                .name = "spi0-1",
>                .pins = spi0_1_pins,
>                .num_pins = ARRAY_SIZE(spi0_1_pins),
>        },
>        {
>                .name = "bus0-1:0",
>                .pins = bus0_1_0_pins,
>                .num_pins = ARRAY_SIZE(bus0_1_0_pins),
>        },
>        {
>                .name = "bus0-3:2",
>                .pins = bus0_3_2_pins,
>                .num_pins = ARRAY_SIZE(bus0_3_2_pins),
>        },
>        {
>                .name = "bus0-7:4",
>                .pins = bus0_7_4_pins,
>                .num_pins = ARRAY_SIZE(bus0_7_4_pins),
>        },
> };
>
> Now, some driver wishing to use those functions could pinmux_get() on:
>
> * Just "bus0-1:0"
> * Both "bus0-1:0" and "bus0-3:2"
> * All of "bus0-1:0" and "bus0-3:2" and "bus0-7:4"
>
> That all makes sense to me.

OK! :-)

> It'd be great if Documentation/pinmux.txt could spell out the "variable
> sized bus" scenario above in a little more detail; it looks like at
> least 2 or 3 people had similar questions regarding the explosion of
> function definitions based on cross-products of configurations, all
> I assume driven by the assumption there was a 1:1 mapping between device
> and pinmux function, rather than 1:n.

Yes I'll try to write up something about it! No problem.

> The one remaining thing I don't understand:
>
> The board provides a mapping from driver name to pinmux selections.
> The example documentation includes:
>
> +static struct pinmux_map pmx_mapping[] = {
> +       {
> +               .function = "spi0-1",
> +               .dev_name = "foo-spi.0",
> +       },
> +       {
> +               .function = "i2c0",
> +               .dev_name = "foo-i2c.0",
> +       },
> +};
>
> I don't think this fits the model of a driver needing to pinmux_get
> e.g. 1, 2, or 3 pinmux functions. Rather, I think the .function field
> should be an array of functions needed by the driver:
>
> +static struct pinmux_map pmx_mapping[] = {
> +       {
> +               .functions = "spi0-1",
> +               .dev_name = "foo-spi.0",
> +       },
> +       {
> +               .function = "i2c0",
> +               .dev_name = "foo-i2c.0",
> +       },
> +       {
> +               .function = {"bus0-7:4", "bus0-3:2", "bus0-1:0"},
> +               .dev_name = "foo-bus.0",
> +       },
> +};
>
> (obviously that syntax is bogus, but you get the idea)
>
> The intent being that the driver could perform single pinmux_get call
> for "foo-bus.0" and then the subsequent pinmux_enable would enable all 3
> entries in that device's .function array.

I think the above usage scenario falls under the category of pinmux
groups that I detailed in the mail reply to Sascha Hauer earlier in the
thread, yes I think it makes sense for some scenarios to have
groups of functions being activated at once, especially on
system boot/suspend/resume/shutdown actually.

I'm thinking that we can model this on top of the existing functions,
so that we add new functions like

pinmux_group_get()
pinmux_group_enable()
pinmux_group_disable()
pinmux_group_put()

that will invoke all the necessary calls to individual functions
and also provide an optional hook down to the driver for
drivers that can mux large groups at once.

However I think this can be a separate patch on top of the
current system, so we can start out with what we have.

> Now, you could argue that there be 3 entries in pmx_mapping[] above, each
> with a different .dev_name, and each mapping to 1 of the 3 required
> functions. However, since pinmux_get takes a struct device and extracts
> the name from there, that wouldn't work.

It works actually, just the same way that a driver can take
several clocks or several regulators.

pinmux_get(dev, "foo");
pinmux_get(dev, "bar");
pinmux_get(dev, "baz");

gets three pinmux functions for a single driver, distinguished
by the function name, no problem.

Using just pinmux_get(dev, NULL) will get the first one and is
used in scenarios where you provide one function only.

> As further justification for this, consider the following scenario,
> which I imagine is pretty common in some incarnation:
>
> Manufacturer creates an SoC. There are two packaging variants of this,
> with just packaging and pinmuxing variations; all the SPI/I2C/foo-bus
> modules are identical. Thus the driver is the same. The pinmux
> differences extend to:
>
> Package A: bus0 is split two ways for bits 7:4 and 3:0
>
> Package B: bus0 is split the three ways from my previous example; 7:4,
> 3:2, 1:0.

I get the problem, however I suspect that what you want to do
in the case where you have different packaging for a SoC is
to control muxing on pad/finger level on the chip die instead of
going to map the physical pins. This is what we do on U300,
and it actually makes things simpler, you control what is muxed
out on the pads and the electronics designer deals with how to
connect pins.

However this will not work if the stuff that is soldered onto the
pads needs to be known by the software. Then we have to
model all the pins instead of only pads...

> In order to isolate the bus0 driver from this pure packaging difference,
> The board's pinmux_map array above would be either:
>
> Package A:
>
> +       {
> +               .function = {"bus0-7:4", "bus0-3:0"},
> +               .dev_name = "foo-bus.0",
> +       },
>
> Package B:
>
> +       {
> +               .function = {"bus0-7:4", "bus0-3:2", "bus0-1:0"},
> +               .dev_name = "foo-bus.0",
> +       },
>
> Does this seem reasonable?

Yes if you cannot resolve it by going to mux pads instead of
pins, the function groups would help out.

> Thanks for patiently answering my long-winded questions:-)

No problem, we need to get this right.

Yours,
Linus Walleij
