Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1FMX2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:28:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9038 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab1FMX2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:28:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 13 Jun 2011 16:28:45 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 13 Jun 2011 16:28:43 -0700
Subject: RE: [PATCH 1/2] drivers: create a pinmux subsystem v3
Thread-Topic: [PATCH 1/2] drivers: create a pinmux subsystem v3
Thread-Index: Acwp6zvCSSMNXNCmQDWSPCp/LGr7TQAKXnrg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04992C02AC@HQMAIL01.nvidia.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Monday, June 13, 2011 10:58 AM:
> This creates a subsystem for handling of pinmux devices. These are
> devices that enable and disable groups of pins on primarily PGA and
> BGA type of chip packages and common in embedded systems.

I'm a little confused by this version. In particular:

* I don't see some changes that I thought we'd agreed upon during earlier
review rounds, such as:

** Removing pinmux_ops members list_functions, get_function_name, 
get_function_pins; it seems odd not to push this into the pinmux core
as data, but instead have the core pull it out of the driver in a
"polling" function.

** Similarly, I'd asked for at least some documentation about how to
handle the "multi-width bus" problem, but I didn't see that.

* I'm confused by the new data model even more than before:

** How can the board/machine name pins? That should be a function of the
chip (i.e. pinmux driver), since that's where the pins are located. A
chip's pins don't have different names on different boards; the names of
the signals on the PCB connected to those pins are defined by the board,
but not the names of the actual pins themselves.

** struct pinmux_map requires that each function name be globally unique,
since one can only specify "function" not "function on a specific chip".
This can't be a requirement; what if there are two instances of the same
chip on the board (think some expansion chip attached to a memory-mapped
bus rather than the primary SoC itself).

** Perhaps primarily due to the lack of consideration in the documentation,
I'm not convinced we have a clearly defined path to solve the "multi-width
bus" issue. This needs to be a feature of the core pinmux API, rather than
something that's deferred to the board/machine files setting up different
function mappings, since it's not possible to solve purely in function
mappins as they're defined today.

Some minor mainly typo, patch-separation, etc. feedback below.

...
> +Pinmux, also known as padmux, ballmux, alternate functions or mission modes
> +is a way for chip vendors producing some kind of electrical packages to use
> +a certain physical bin (ball, pad, finger, etc) for multiple mutually exclusive

s/bin/pin/

...
> +A simple driver for the above example will work by setting bits 0, 1 or 2
> +into some register mamed MUX, so it enumerates its available settings and

s/mamed/named

> +++ b/drivers/pinctrl/Kconfig
...
> +config PINMUX_U300
> +	bool "U300 pinmux driver"
> +	depends on ARCH_U300
> +	help
> +	  Say Y here to enable the U300 pinmux driver
> +
> +endif

Shouldn't that portion be part of the second patch?

> +++ b/drivers/pinctrl/Makefile
...
> +obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o

Same here.

> +++ b/include/linux/pinctrl/machine.h
> +/**
> + * struct pinmux_map - boards/machines shall provide this map for devices
> + * @function: a functional name for this mapping so it can be passed down
> + *	to the driver to invoke that function and be referenced by this ID
> + *	in e.g. pinmux_get()
> + * @dev: the device using this specific mapping, may be NULL if you provide
> + *	.dev_name instead (this is more common)
> + * @dev_name: the name of the device using this specific mapping, the name
> + *	must be the same that will return your struct device*

s/that will return/as in/ ?

> +++ b/include/linux/pinctrl/pinmux.h
> +struct pinmux;
> +
> +#ifdef CONFIG_PINCTRL
> +
> +struct pinmux_dev;

I think "struct pinmux_map" is needed outside that ifdef, or an include of
<pinctrl/machine.h>.

> +/**
> + * struct pinmux_ops - pinmux operations, to be implemented by drivers
> + * @request: called by the core to see if a certain pin can be muxed in
> + *	and made available in a certain mux setting The driver is allowed
> + *	to answer "no" by returning a negative error code

That says "and made available in a certain mux setting", but no mux setting
is passed in. s/a certain/the current/?

Documentation for @free is missing here

> +/**
> + * struct pinmux_desc - pinmux descriptor, register this to pinmux subsystem
> + * @name: name for the pinmux
> + * @ops: pinmux operation table
> + * @owner: module providing the pinmux, used for refcounting
> + * @base: the number of the first pin handled by this pinmux, in the global
> + *	pin space, subtracted from a given pin to get the offset into the range
> + *	of a certain pinmux
> + * @npins: the number of pins handled by this pinmux - note that
> + *	this is the number of possible pin settings, if your driver handles
> + *	8 pins that each can be muxed in 3 different ways, you reserve 24
> + *	pins in the global pin space and set this to 24

That's not correct, right; if you have 8 pins, you just say 8 here?

The multiplier for N functions per pin is through list_functions,
get_function_name, get_function_pins as I understand it.

> +static inline int pinmux_register_mappings(struct pinmux_map const *map,
> +					   unsigned num_maps)
> +{
> +	return 0;
> +}

I think you moved that to <pinmux/machine.h>?

--
nvpublic

