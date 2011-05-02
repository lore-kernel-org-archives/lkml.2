Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1EBUwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:52:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14403 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1EBUwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:52:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 May 2011 13:52:09 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Mon, 2 May 2011 13:52:05 -0700
Subject: RE: [PATCH 1/4] drivers: create a pinmux subsystem
Thread-Topic: [PATCH 1/4] drivers: create a pinmux subsystem
Thread-Index: AcwI/Y7VJi2thbgTSMG27Y/Kb2UFngACRUmQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Monday, May 02, 2011 1:16 PM:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This creates a subsystem for handling of pinmux devices. These are
> devices that enable and disable groups of pins on primarily PGA and
> BGA type of chip packages and common in embedded systems.

I would avoid any references to particular package types; I've seen
pinmuxing applied to PLCC and DIP/DIL too, and in general, it's possible
irrespective of package type.

> This is being done to depopulate the arch/arm/* directory of such
> custom drivers and try to abstract the infrastructure they all
> need. See the Documentation/pinmux.txt file that is part of this
> patch for more details.

> diff --git a/Documentation/pinmux.txt b/Documentation/pinmux.txt
>...
> +The mux settings are:
> +
> +- Oriented around enumerated physical pins or pads denoted by unsigned
> +  integers in the range 0..MAX_INT. Every pin on your system (or atleast
> +  every pin that can be muxed) should have a unique number. The numberspace

Does this imply a model where each pin's "special function" can be
controlled independently? I think reading through the document that
isn't the case, but I just wanted to be sure.

In particular, NVIDIA Tegra has a setup where:

* Pinmux configuration for "special functions" is at a "pad-group"
  level, where there may be 1..N pins in a pad-group, and there is a
  single register field that defines the current special function routed
  to/from all pins in that pad-group at once.

* Each pad group can be assigned 1 of N special functions (none might be
  an option in some/all cases too)

* Some special functions may be assignable to multiple pad groups,
  although obviously only 1 pad group per function at a time.

* GPIO selection is at per-pin granularity; individual pins may be used
  as a GPIO irrespective of what SFR is selected for the pad group
  containing the pin.

* There are also other configurations associated with pinmuxing, such
  as drive strength, pull up/down enables, etc.

Also, some of our drivers use "dynamic pinmuxing". For example, our
downstream I2C driver exposes N I2C busses and reprograms the pinmux
at runtime to attach the actual I2C controller to different sets of
pins, essentially multi-plexing the control across N physical busses.

> diff --git a/include/linux/pinmux.h b/include/linux/pinmux.h
> new file mode 100644
> index 0000000..9bdcc33
> --- /dev/null
> +++ b/include/linux/pinmux.h

> +/**
> + * struct pinmux_map - boards/machines shall provide this map for devices
> + * @node: list node - only for internal use

Node isn't in the structure.

> + * @function: a functional name for this mapping so it can be passed down
> + *	to the driver to invoke that function and be referenced by this ID
> + *	in e.g. pinmux_get()
> + * @dev: the device using this specific mapping, may be NULL if you provide
> + *	.dev_name instead (this is more common)
> + * @dev_name: the name of the device using this specific mapping, the name
> + *	must be the same that will return your struct device*
> + */
> +struct pinmux_map {
> +	const char *function;
> +	struct device *dev;
> +	const char *dev_name;
> +};

> +/*
> + * The pin number is a global pin number space, nominally the arch shall define
> + * the number of pins in *total* across all chips in the arch/system.
> + *
> + * Example: if your arch has two chips with 64 pins each, you have
> + * 8*3 = 24 MACH_NR_PINS.

2*64 = 128 MACH_NR_PINS ?

> +struct pinmux_dev;
> +
> +/**
> + * struct pinmux_ops - pinmux operations, to be implemented by drivers
> + * @request: called by the core to see if a certain pin can be muxed in
> + *	and made available in a certain mux setting The driver is allowed
> + *	to answer "no" by returning a negative error code
> + * @list_functions: list the number of selectable named functions available
> + *	in this pinmux driver, the core will begin on 0 and call this
> + *	repeatedly as long as it returns >= 0 to enumerate mux settings
> + * @get_function_name: return the function name of the muxing selector,
> + *	called by the core to figure out which mux setting it shall map a
> + *	certain device to
> + * @get_function_pins: return an array of pins corresponding to a certain
> + *	function selector in @pins, and the size of the array in @num_pins
> + * @enable: enable a certain muxing enumerator. The driver does not need to
> + *	figure out whether enabling this function conflicts some other use
> + *	of the pins, such collisions are handled by the pinmux subsystem
> + * @disable: disable a certain muxing enumerator
> + * @gpio_request_enable: requests and enables GPIO on a certain pin.
> + *	Implement this only if you can mux every pin individually as GPIO. If
> + *	your gpio assignments are grouped, so you cannot control the GPIO
> + *	muxing of every indvidual pin.
> + * @dbg_show: optional debugfs display hook that will provide per-device
> + *	info for a certain pin in debugfs
> + */
> +struct pinmux_ops {
> +	int (*request) (struct pinmux_dev *pmxdev, unsigned offset);

s/offset/pin/? I assume that's what it means. Same for gpio_request_enable
below too.

> +	int (*free) (struct pinmux_dev *pmxdev, unsigned offset);
> +	int (*list_functions) (struct pinmux_dev *pmxdev, unsigned selector);
> +	const char *(*get_function_name) (struct pinmux_dev *pmxdev,
> +					unsigned selector);
> +	int (*get_function_pins) (struct pinmux_dev *pmxdev, unsigned selector,
> +			unsigned ** const pins, unsigned * const num_pins);
> +	int (*enable) (struct pinmux_dev *pmxdev, unsigned selector);
> +	void (*disable) (struct pinmux_dev *pmxdev, unsigned selector);
> +	int (*gpio_request_enable) (struct pinmux_dev *pmxdev, unsigned offset);
> +	void (*dbg_show) (struct pinmux_dev *pmxdev, struct seq_file *s,
> +			  unsigned offset);
> +};
> +
> +/**
> + * struct pinmux_desc - pinmux descriptor, register this to pinmux subsystem
> + * @name: name for the pinmux
> + * @ops: pinmux operation table
> + * @owner: module providing the pinmux, used for refcounting
> + * @base: the number of the first pin handled by this pinmux, in the global
> + *	pin space, subtracted from a given pin to get the offset into the range
> + *	of a certain pinmux
> + * @no_pin_settings: the number of pins handled by this pinmux - note that

That's npins below.

> + *	this is the number of possible pin settings, if your driver handles
> + *	8 pins that each can be muxed in 3 different ways, you reserve 24
> + *	pins in the global pin space and set this to 24
> + */
> +struct pinmux_desc {
> +	const char *name;
> +	struct pinmux_ops *ops;
> +	struct module *owner;
> +	int base;
> +	int npins;
> +};

> +/* External interface to pinmux */
> +extern int pinmux_request_gpio(int pin, unsigned gpio);
> +extern void pinmux_free_gpio(int pin);

Is there (or should there be) any automatic interaction with gpiolib?

> +extern int pinmux_register_mappings(struct pinmux_map const *map,
> +				    unsigned num_maps);
> +extern struct pinmux *pinmux_get(struct device *dev, const char *func);

I feel slightly uneasy tying the pinmux API to devices rather than
Letting it be more free-form. I've seen this pattern for clocks too,
but IIRC there is an override there allowing specification of a NULL
device in order to look up a clock by raw clock name instead of
device + sub-clock-name right?

Still, I'm a relative neophyte regarding internal Linux kernel APIs,
so my opinion here may not be particularly relevant.

-- 
nvpublic

