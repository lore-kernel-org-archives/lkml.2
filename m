Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1EJWq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:46:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46310 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1EJWq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H1hfTFIf+AezTo0GoauKd73FCPnJgd2RAofaCTGcfgnjtzNHPlFWua8+qEXN0ECxIN
         p/tkdphSt3/byWBR/Dn07ZpeTuBr+f6GMXhcHkCn73GMhuomowKqT27xxPkUZQrailUE
         eIMRPpds232+0Oq8tn3FjCsWVjJuKoTUgTb18=
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
Date: Wed, 11 May 2011 00:46:26 +0200
X-Google-Sender-Auth: nXmOH_yxojRHAayh8SQmloOZrus
Message-ID: <BANLkTinZh4f2o9qjTPppO5x6YfH3rhU3jg@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/2 Stephen Warren <swarren@nvidia.com>:
> Linus Walleij wrote at Monday, May 02, 2011 1:16 PM:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This creates a subsystem for handling of pinmux devices. These are
>> devices that enable and disable groups of pins on primarily PGA and
>> BGA type of chip packages and common in embedded systems.
>
> I would avoid any references to particular package types; I've seen
> pinmuxing applied to PLCC and DIP/DIL too, and in general, it's possible
> irrespective of package type.

Sure dropping parts of that. I'll try to reify the package concept a bit.
However since I have this nice chessboard example I have to say
what I'm talking about, the topology of this 2D PGA field is pretty fun.

>> +The mux settings are:
>> +
>> +- Oriented around enumerated physical pins or pads denoted by unsigned
>> +  integers in the range 0..MAX_INT. Every pin on your system (or atleast
>> +  every pin that can be muxed) should have a unique number. The numberspace
>
> Does this imply a model where each pin's "special function" can be
> controlled independently?

No not at all. This is defining the terms.

> In particular, NVIDIA Tegra has a setup where:
>
> * Pinmux configuration for "special functions" is at a "pad-group"
>  level, where there may be 1..N pins in a pad-group, and there is a
>  single register field that defines the current special function routed
>  to/from all pins in that pad-group at once.

Perfect fit with this pinmux API.

> * Each pad group can be assigned 1 of N special functions (none might be
>  an option in some/all cases too)

Perfect fit with this pinmux API.

> * Some special functions may be assignable to multiple pad groups,
>  although obviously only 1 pad group per function at a time.

Perfect fit with this pinmux API.

> * GPIO selection is at per-pin granularity; individual pins may be used
>  as a GPIO irrespective of what SFR is selected for the pad group
>  containing the pin.

Perfect fit with this pinmux API. The Nomadik pinmux is basically the
same.

Note that the pinmux API makes sure you haven't used a single pin for
GPIO at the same time as you're using a group containing the same pin.

> * There are also other configurations associated with pinmuxing, such
>  as drive strength, pull up/down enables, etc.

I am currently contemplating whether to include a control function for
this stuff in the pinmux API. I probably will, and then make sure the
enumerators match those I have just defined for GPIO (since there may
be systems with such settings for just GPIO pins (which cannot be
muxed) and vice versa for muxable pins that cannot be used for GPIO
but still driven low if unused for example.

> Also, some of our drivers use "dynamic pinmuxing". For example, our
> downstream I2C driver exposes N I2C busses and reprograms the pinmux
> at runtime to attach the actual I2C controller to different sets of
> pins, essentially multi-plexing the control across N physical busses.

Just pinmux_get()/pinmux_put()/pinmux_get()/pinmux_put() to switch
these functions in/out at runtime. (Described in reply to Russell
in patch 0.)

>> +/**
>> + * struct pinmux_map - boards/machines shall provide this map for devices
>> + * @node: list node - only for internal use
>
> Node isn't in the structure.

Thanks, leftover, removed it.

>> +/*
>> + * The pin number is a global pin number space, nominally the arch shall define
>> + * the number of pins in *total* across all chips in the arch/system.
>> + *
>> + * Example: if your arch has two chips with 64 pins each, you have
>> + * 8*3 = 24 MACH_NR_PINS.
>
> 2*64 = 128 MACH_NR_PINS ?

Yeah :-P thanks.

>> +struct pinmux_ops {
>> +     int (*request) (struct pinmux_dev *pmxdev, unsigned offset);
>
> s/offset/pin/? I assume that's what it means. Same for gpio_request_enable
> below too.

No not at all. Like in the case with the gpiolib, we may have several muxes
on the system (e.g. in the U8500 we have alternate functions not only
on the SoC package but also on the AB8500 mixsig circuit). The offset
refers to the pin inside the pin range handled by that specific driver.

If you have only *one* pinmux driver on your system it will be the same
thing, but not in the general case.

>> +/**
>> + * struct pinmux_desc - pinmux descriptor, register this to pinmux subsystem
>> + * @name: name for the pinmux
>> + * @ops: pinmux operation table
>> + * @owner: module providing the pinmux, used for refcounting
>> + * @base: the number of the first pin handled by this pinmux, in the global
>> + *   pin space, subtracted from a given pin to get the offset into the range
>> + *   of a certain pinmux
>> + * @no_pin_settings: the number of pins handled by this pinmux - note that
>
> That's npins below.

Good catch, thanks!

>> +/* External interface to pinmux */
>> +extern int pinmux_request_gpio(int pin, unsigned gpio);
>> +extern void pinmux_free_gpio(int pin);
>
> Is there (or should there be) any automatic interaction with gpiolib?

My idea is that if a certain gpiolib driver may need to request a pin that
is muxed, it will translate the GPIO pin number into a pinmux pin and
call pinmux_request_gpio() on that pin. So in my head only gpiolib driver
under drivers/gpio() would nominally be calling this to reserve pins.

Since not all GPIOs are muxable, it'll need to be on a per-driver basis.

>> +extern int pinmux_register_mappings(struct pinmux_map const *map,
>> +                                 unsigned num_maps);
>> +extern struct pinmux *pinmux_get(struct device *dev, const char *func);
>
> I feel slightly uneasy tying the pinmux API to devices rather than
> Letting it be more free-form. I've seen this pattern for clocks too,
> but IIRC there is an override there allowing specification of a NULL
> device in order to look up a clock by raw clock name instead of
> device + sub-clock-name right?

Yes and that is possible with pinmux_get() too, you can specify
a function not tied to a particular device.

> Still, I'm a relative neophyte regarding internal Linux kernel APIs,
> so my opinion here may not be particularly relevant.

It's relevant.

Thanks a lot Stephen! Once/if you like the API, please ACK it.
Linus Walleij
