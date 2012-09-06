Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2IFOPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:15:19 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34459 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab2IFOPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:15:15 -0400
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH v5 1/4] Runtime Interpreted Power Sequences
Date: Thu, 6 Sep 2012 16:14:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <1346412846-17102-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1346412846-17102-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209061614.54022.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Am Freitag, 31. August 2012, 13:34:03 schrieb Alexandre Courbot:
> Some device drivers (panel backlights especially) need to follow precise
> sequences for powering on and off, involving gpios, regulators, PWMs
> with a precise powering order and delays to respect between each steps.
> These sequences are board-specific, and do not belong to a particular
> driver - therefore they have been performed by board-specific hook
> functions to far.
> 
> With the advent of the device tree and of ARM kernels that are not
> board-tied, we cannot rely on these board-specific hooks anymore but
> need a way to implement these sequences in a portable manner. This patch
> introduces a simple interpreter that can execute such power sequences
> encoded either as platform data or within the device tree.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

I really like this idea, also because I'll have to solve similar problems on 
the way to dt for my tinker-platform.

For your power_seq_run function you write that it simply returns an error code 
on failure and looking through it I also just found the error return 
statement. This would leave a device half turned on.

So I'm wondering, if it shouldn't turn off all the things it turned on until 
the step that produced the error. All your possible step types (execpt the 
delay) are booleans, so it should be possible to simply negate them when 
backtracking through the previous steps.


Heiko


> ---
>  .../devicetree/bindings/power_seq/power_seq.txt    | 117 ++++++
>  Documentation/power/power_seq.txt                  | 225 +++++++++++
>  drivers/power/Kconfig                              |   1 +
>  drivers/power/Makefile                             |   1 +
>  drivers/power/power_seq/Kconfig                    |   2 +
>  drivers/power/power_seq/Makefile                   |   1 +
>  drivers/power/power_seq/power_seq.c                | 446
> +++++++++++++++++++++ drivers/power/power_seq/power_seq_delay.c          |
>  51 +++
>  drivers/power/power_seq/power_seq_gpio.c           |  81 ++++
>  drivers/power/power_seq/power_seq_pwm.c            |  85 ++++
>  drivers/power/power_seq/power_seq_regulator.c      |  86 ++++
>  include/linux/power_seq.h                          | 174 ++++++++
>  12 files changed, 1270 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/power_seq/power_seq.txt create mode
> 100644 Documentation/power/power_seq.txt
>  create mode 100644 drivers/power/power_seq/Kconfig
>  create mode 100644 drivers/power/power_seq/Makefile
>  create mode 100644 drivers/power/power_seq/power_seq.c
>  create mode 100644 drivers/power/power_seq/power_seq_delay.c
>  create mode 100644 drivers/power/power_seq/power_seq_gpio.c
>  create mode 100644 drivers/power/power_seq/power_seq_pwm.c
>  create mode 100644 drivers/power/power_seq/power_seq_regulator.c
>  create mode 100644 include/linux/power_seq.h
> 
> diff --git a/Documentation/devicetree/bindings/power_seq/power_seq.txt
> b/Documentation/devicetree/bindings/power_seq/power_seq.txt new file mode
> 100644
> index 0000000..d3e3f6a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_seq/power_seq.txt
> @@ -0,0 +1,117 @@
> +Runtime Interpreted Power Sequences
> +===================================
> +
> +Power sequences are sequential descriptions of actions to be performed on
> +power-related resources. Having these descriptions in a precise data
> format +allows us to take much of the board-specific power control code
> out of the +kernel and place it into the device tree instead, making
> kernels less +board-dependant.
> +
> +In the device tree, power sequences are grouped into a set. The set is
> always +declared as the "power-sequences" sub-node of the device node.
> Power sequences +may reference resources declared by that device.
> +
> +Power Sequences Structure
> +-------------------------
> +Every device that makes use of power sequences must have a
> "power-sequences" +sub-node. Power sequences are sub-nodes of this set
> node, and their node name +indicates the id of the sequence.
> +
> +Every power sequence in turn contains its steps as sub-nodes of itself.
> Step +must be named sequentially, with the first step named step0, the
> second step1, +etc. Failure to follow this rule will result in a parsing
> error.
> +
> +Power Sequences Steps
> +---------------------
> +Step of a sequence describes an action to be performed on a resource. They
> +always include a "type" property which indicates what kind of resource
> this +step works on. Depending on the resource type, additional properties
> are defined +to control the action to be performed.
> +
> +"delay" type required properties:
> +  - delay_us: delay to wait in microseconds
> +
> +"regulator" type required properties:
> +  - id: name of the regulator to use. Regulator is obtained by
> +        regulator_get(dev, id)
> +  - enable / disable: one of these two empty properties must be present to
> +                      enable or disable the resource
> +
> +"pwm" type required properties:
> +  - id: name of the PWM to use. PWM is obtained by pwm_get(dev, id)
> +  - enable / disable: one of these two empty properties must be present to
> +                      enable or disable the resource
> +
> +"gpio" type required properties:
> +  - number: phandle of the GPIO to use.
> +  - enable / disable: one of these two empty properties must be present to
> +                      enable or disable the resource
> +
> +Example
> +-------
> +Here are example sequences declared within a backlight device that use all
> the +supported resources types:
> +
> +	backlight {
> +		compatible = "pwm-backlight";
> +		...
> +
> +		/* resources used by the power sequences */
> +		pwms = <&pwm 2 5000000>;
> +		pwm-names = "backlight";
> +		power-supply = <&backlight_reg>;
> +
> +		power-sequences {
> +			power-on {
> +				step0 {
> +					type = "regulator";
> +					id = "power";
> +					enable;
> +				};
> +				step1 {
> +					type = "delay";
> +					delay_us = <10000>;
> +				};
> +				step2 {
> +					type = "pwm";
> +					id = "backlight";
> +					enable;
> +				};
> +				step3 {
> +					type = "gpio";
> +					number = <&gpio 28 0>;
> +					enable;
> +				};
> +			};
> +
> +			power-off {
> +				step0 {
> +					type = "gpio";
> +					number = <&gpio 28 0>;
> +					disable;
> +				};
> +				step1 {
> +					type = "pwm";
> +					id = "backlight";
> +					disable;
> +				};
> +				step2 {
> +					type = "delay";
> +					delay_us = <10000>;
> +				};
> +				step3 {
> +					type = "regulator";
> +					id = "power";
> +					disable;
> +				};
> +			};
> +		};
> +	};
> +
> +The first part lists the PWM and regulator resources used by the
> sequences. +These resources will be requested on behalf of the backlight
> device when the +sequences are built and are declared according to their
> own framework in a way +that makes them accessible by name.
> +
> +After the resources declaration, two sequences follow for powering the
> backlight +on and off. Their names are specified by the pwm-backlight
> driver. diff --git a/Documentation/power/power_seq.txt
> b/Documentation/power/power_seq.txt new file mode 100644
> index 0000000..48d1f6b
> --- /dev/null
> +++ b/Documentation/power/power_seq.txt
> @@ -0,0 +1,225 @@
> +Runtime Interpreted Power Sequences
> +===================================
> +
> +Problem
> +-------
> +Very commonly, boards need the help of out-of-driver code to turn some of
> their +devices on and off. For instance, SoC boards very commonly use a
> GPIO +(abstracted to a regulator or not) to control the power supply of a
> backlight, +disabling it when the backlight is not used in order to save
> power. The GPIO +that should be used, however, as well as the exact power
> sequence that may +also involve other resources, is board-dependent and
> thus unknown to the driver. +
> +This was previously addressed by having hooks in the device's platform
> data that +are called whenever the state of the device might reflect a
> power change. This +approach, however, introduces board-dependant code
> into the kernel and is not +compatible with the device tree.
> +
> +The Runtime Interpreted Power Sequences (or power sequences for short) aim
> at +turning this code into platform data or device tree nodes. Power
> sequences are +described using a simple format and run by a lightweight
> interpreter whenever +needed. This allows to remove the callback mechanism
> and makes the kernel less +board-dependant.
> +
> +What are Power Sequences?
> +-------------------------
> +Power sequences are a series of sequential steps during which an action is
> +performed on a resource. The supported resources and actions operations
> are: +- delay (just wait for a given number of microseconds)
> +- GPIO (enable or disable)
> +- regulator (enable or disable)
> +- PWM (enable or disable)
> +
> +When a power sequence is run, each of its steps is executed sequentially
> until +one step fails or the end of the sequence is reached.
> +
> +Power sequences are grouped in "sets" and declared per-device. Every
> sequence +must be attributed a name that can be used to retrieve it from
> its set when it +is needed.
> +
> +Power sequences can be declared as platform data or in the device tree.
> +
> +Platform Data Format
> +--------------------
> +All relevant data structures for declaring power sequences are located in
> +include/linux/power_seq.h.
> +
> +The platform data for a given device is an instance of
> platform_power_seq_set +which points to instances of platform_power_seq.
> Every platform_power_seq is a +single power sequence, and is itself
> composed of a variable length array of +steps.
> +
> +A step is a union of all the step structures. Which one is to be used
> depends on +the type of the step. Step structures are documented in the
> +include/linux/power_seq.h file ; please refer to it for all details, but
> the +following example will probably make it clear how power sequences
> should be +defined. It defines two power sequences named "power_on" and
> "power_off". The +"power_on" sequence enables a regulator called "power"
> (retrieved from the +device using regulator_get()), waits for 10ms, and
> then enabled GPIO 110. +"power_off" does the opposite.
> +
> +static struct platform_power_seq power_on_seq = {
> +	.id = "power_on",
> +	.num_steps = 3,
> +	.steps = {
> +		{
> +			.type = POWER_SEQ_REGULATOR,
> +			.regulator = {
> +				.id = "power",
> +				.enable = true,
> +			},
> +		},
> +		{
> +			.type = POWER_SEQ_DELAY,
> +			.delay = {
> +				.delay_us = 10000,
> +			},
> +		},
> +		{
> +			.type = POWER_SEQ_GPIO,
> +			.gpio = {
> +				.number = 110,
> +				.enable = true,
> +			},
> +		},
> +	},
> +};
> +
> +static struct platform_power_seq power_off_seq = {
> +	.id = "power_off",
> +	.num_steps = 3,
> +	.steps = {
> +		{
> +			.type = POWER_SEQ_GPIO,
> +			.gpio = {
> +				.number = 110,
> +				.enable = false,
> +			},
> +		},
> +		{
> +			.type = POWER_SEQ_DELAY,
> +			.delay = {
> +				.delay_us = 10000,
> +			},
> +		},
> +		{
> +			.type = POWER_SEQ_REGULATOR,
> +			.regulator = {
> +				.id = "power",
> +				.enable = false,
> +			},
> +		},
> +	},
> +};
> +
> +static struct platform_power_seq_set power_sequences = {
> +	.num_seqs = 2,
> +	.seqs = {
> +		&power_on_seq,
> +		&power_off_seq,
> +	},
> +};
> +
> +Device Tree
> +-----------
> +Power sequences can also be encoded as device tree nodes. The following
> +properties and nodes are equivalent to the platform data defined
> previously: +
> +power-supply = <&power_reg>;
> +
> +power-sequences {
> +	power-on {
> +		step0 {
> +			type = "regulator";
> +			id = "power";
> +			enable;
> +		};
> +		step1 {
> +			type = "delay";
> +			delay = <10000>;
> +		};
> +		step2 {
> +			type = "gpio";
> +			number = <&gpio 110 0>;
> +			enable;
> +		};
> +	}
> +	power-off {
> +		step0 {
> +			type = "gpio";
> +			number = <&gpio 110 0>;
> +			disable;
> +		};
> +		step1 {
> +			type = "delay";
> +			delay = <10000>;
> +		};
> +		step2 {
> +			type = "regulator";
> +			id = "power";
> +			disable;
> +		};
> +	}
> +};
> +
> +See Documentation/devicetree/bindings/power_seq/power_seq.txt for the
> complete +syntax of the bindings.
> +
> +Usage by Drivers and Resources Management
> +-----------------------------------------
> +Power sequences make use of resources that must be properly allocated and
> +managed. The devm_power_seq_set_build() function builds a power sequence
> set +from platform data. It also takes care of resolving and allocating
> the resources +referenced by the sequence:
> +
> +  struct power_seq_set *devm_power_seq_set_build(struct device *dev,
> +					   struct platform_power_seq_set *pseq);
> +
> +As its name states, all memory and resources are devm-allocated. The 'dev'
> +argument is the device in the name of which the resources are to be
> allocated. +
> +On success, the function returns a devm allocated resolved sequences set
> for +which all the resources are allocated. In case of failure, an error
> code is +returned.
> +
> +Power sequences can then be retrieved by their name using
> power_seq_lookup: +
> +  struct power_seq *power_seq_lookup(struct power_seq_set *seqs,
> +				     const char *id);
> +
> +A power sequence can be executed by power_seq_run:
> +
> +  int power_seq_run(struct power_seq *seq);
> +
> +It returns 0 if the sequence has successfully been run, or an error code
> if a +problem occured.
> +
> +Sometimes, you may want to browse the list of resources allocated by a
> sequence, +to for instance ensure that a resource of a given type is
> present. The +power_seq_set_resources() function returns a list head that
> can be used with +the power_seq_for_each_resource() macro to browse all
> the resources of a set: +
> +  struct list_head *power_seq_set_resources(struct power_seq_set *seqs);
> +  power_seq_for_each_resource(pos, seqs)
> +
> +Here "pos" will be of type struct power_seq_resource. This structure
> contains a +"pdata" pointer that can be used to explore the platform data
> of this resource, +as well as the resolved resource, if applicable.
> +
> +Finally, users of the device tree can build the platform data
> corresponding to +the tree node using this function:
> +
> +  struct platform_power_seq_set *devm_of_parse_power_seq_set(struct device
> *dev); +
> +As the device tree syntax unambiguously states the name of the node
> containing +the power sequences, it only needs a pointer to the device to
> work. The result +can then be passed to devm_power_seq_set_build() in
> order to get a set of +runnable sequences.
> +
> +devm_of_parse_power_seq_set allocates its memory using devm, but the
> platform +data becomes unneeded after devm_power_seq_set_build() is called
> on it and can +thus be freed. Be aware though that one allocation is
> performed for the set and +for every sequence. The
> devm_power_seq_platform_data_free() function takes care +of freeing the
> memory properly:
> +
> +  void devm_platform_power_seq_set_free(struct platform_power_seq_set
> *pseq); diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index fcc1bb0..5fdfd84 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -312,3 +312,4 @@ config AB8500_BATTERY_THERM_ON_BATCTRL
>  endif # POWER_SUPPLY
> 
>  source "drivers/power/avs/Kconfig"
> +source "drivers/power/power_seq/Kconfig"
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index ee58afb..d3c893b 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -45,3 +45,4 @@ obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
>  obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
>  obj-$(CONFIG_POWER_AVS)		+= avs/
>  obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
> +obj-$(CONFIG_POWER_SEQ)		+= power_seq/
> diff --git a/drivers/power/power_seq/Kconfig
> b/drivers/power/power_seq/Kconfig new file mode 100644
> index 0000000..3bff26e
> --- /dev/null
> +++ b/drivers/power/power_seq/Kconfig
> @@ -0,0 +1,2 @@
> +config POWER_SEQ
> +	bool
> diff --git a/drivers/power/power_seq/Makefile
> b/drivers/power/power_seq/Makefile new file mode 100644
> index 0000000..f77a359
> --- /dev/null
> +++ b/drivers/power/power_seq/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_POWER_SEQ)		+= power_seq.o
> diff --git a/drivers/power/power_seq/power_seq.c
> b/drivers/power/power_seq/power_seq.c new file mode 100644
> index 0000000..e4d482c
> --- /dev/null
> +++ b/drivers/power/power_seq/power_seq.c
> @@ -0,0 +1,446 @@
> +/*
> + * power_seq.c - A simple power sequence interpreter for platform devices
> + *               and device tree.
> + *
> + * Author: Alexandre Courbot <acourbot@nvidia.com>
> + *
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> WITHOUT + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> General Public License for + * more details.
> + *
> + */
> +
> +#include <linux/power_seq.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +
> +#include <linux/of.h>
> +
> +struct power_seq_set {
> +	struct device *dev;
> +	struct list_head resources;
> +	struct list_head sequences;
> +};
> +
> +struct power_seq_step {
> +	/* Copy of the platform data */
> +	struct platform_power_seq_step pdata;
> +	/* Resolved resource */
> +	struct power_seq_resource *resource;
> +};
> +
> +struct power_seq {
> +	/* Set this sequence belongs to */
> +	struct power_seq_set *parent_set;
> +	const char *id;
> +	/* To thread into power_seqs structure */
> +	struct list_head list;
> +	unsigned int num_steps;
> +	struct power_seq_step steps[];
> +};
> +
> +#define power_seq_err(dev, seq, step_nbr, format, ...)			     \
> +	dev_err(dev, "%s[%d]: " format, seq->id, step_nbr, ##__VA_ARGS__);
> +
> +/**
> + * struct power_seq_res_type - operators for power sequences resources
> + * @name:		Name of the resource type. Set to null when a resource
> + *			type support is not compiled in
> + * @need_resource:	Whether a resource needs to be allocated when steps of
> + *			this kind are met. If set to false, res_compare and
> + *			res_alloc need not be set
> + * @of_parse:		Parse a step for this kind of resource from a device
> + *			tree node. The result of parsing must be written into
> + *			step step_nbr of seq
> + * @step_run:		Run a step for this kind of resource
> + * @res_compare:	Return true if the resource used by both steps is the
> + *			same, false otherwise
> + * @res_alloc:		Resolve and allocate the resource passed from seq
> + *			Return error code if the resource cannot be allocated
> + */
> +struct power_seq_res_ops {
> +	const char *name;
> +	bool need_resource;
> +	int (*of_parse)(struct device *dev, struct device_node *node,
> +			struct platform_power_seq *seq, unsigned int step_nbr);
> +	int (*step_run)(struct power_seq_step *step);
> +	bool (*res_compare)(struct platform_power_seq_step *step1,
> +			    struct platform_power_seq_step *step2);
> +	int (*res_alloc)(struct device *dev, struct power_seq_resource *seq);
> +};
> +
> +static const struct power_seq_res_ops
> power_seq_types[POWER_SEQ_NUM_TYPES]; +
> +#ifdef CONFIG_OF
> +static int of_power_seq_parse_enable_properties(struct device *dev,
> +						struct device_node *node,
> +						struct platform_power_seq *seq,
> +						unsigned int step_nbr,
> +						bool *enable)
> +{
> +	if (of_find_property(node, "enable", NULL)) {
> +		*enable = true;
> +	} else if (of_find_property(node, "disable", NULL)) {
> +		*enable = false;
> +	} else {
> +		power_seq_err(dev, seq, step_nbr,
> +			      "missing enable or disable property\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int of_power_seq_parse_step(struct device *dev, struct device_node
> *node, +				   struct platform_power_seq *seq,
> +				   unsigned int step_nbr)
> +{
> +	struct platform_power_seq_step *step = &seq->steps[step_nbr];
> +	const char *type;
> +	int i, err;
> +
> +	err = of_property_read_string(node, "type", &type);
> +	if (err < 0) {
> +		power_seq_err(dev, seq, step_nbr,
> +			      "cannot read type property\n");
> +		return err;
> +	}
> +	for (i = 0; i < POWER_SEQ_NUM_TYPES; i++) {
> +		if (power_seq_types[i].name == NULL)
> +			continue;
> +		if (!strcmp(type, power_seq_types[i].name))
> +			break;
> +	}
> +	if (i >= POWER_SEQ_NUM_TYPES) {
> +		power_seq_err(dev, seq, step_nbr, "unknown type %s\n", type);
> +		return -EINVAL;
> +	}
> +	step->type = i;
> +	err = power_seq_types[step->type].of_parse(dev, node, seq, step_nbr);
> +
> +	return err;
> +}
> +
> +static struct platform_power_seq *of_parse_power_seq(struct device *dev,
> +						     struct device_node *node)
> +{
> +	struct device_node *child = NULL;
> +	struct platform_power_seq *pseq;
> +	int num_steps, sz;
> +	int err;
> +
> +	if (!node)
> +		return ERR_PTR(-EINVAL);
> +
> +	num_steps = of_get_child_count(node);
> +	sz = sizeof(*pseq) + sizeof(pseq->steps[0]) * num_steps;
> +	pseq = devm_kzalloc(dev, sz, GFP_KERNEL);
> +	if (!pseq)
> +		return ERR_PTR(-ENOMEM);
> +	pseq->num_steps = num_steps;
> +	pseq->id = node->name;
> +
> +	for_each_child_of_node(node, child) {
> +		unsigned int pos;
> +
> +		/* Check that the name's format is correct and within bounds */
> +		if (strncmp("step", child->name, 4)) {
> +			err = -EINVAL;
> +			goto parse_error;
> +		}
> +
> +		err = kstrtouint(child->name + 4, 10, &pos);
> +		if (err < 0)
> +			goto parse_error;
> +
> +		if (pos >= num_steps || pseq->steps[pos].type != 0) {
> +			err = -EINVAL;
> +			goto parse_error;
> +		}
> +
> +		err = of_power_seq_parse_step(dev, child, pseq, pos);
> +		if (err)
> +			return ERR_PTR(err);
> +	}
> +
> +	return pseq;
> +
> +parse_error:
> +	dev_err(dev, "%s: invalid power step name %s!\n", pseq->id,
> +		child->name);
> +	return ERR_PTR(err);
> +}
> +
> +/**
> + * of_parse_power_seq_set() - build platform data corresponding to a DT
> node + * @dev:	Device on behalf of which the sequence is to be built
> + *
> + * Sequences must be contained into a subnode named "power-sequences" of
> the + * device root node.
> + *
> + * Memory for the platform sequence is allocated using devm_kzalloc on dev
> and + * can be freed by devm_kfree after power_seq_set_build returned.
> Beware that on + * top of the set itself, platform data for individual
> sequences should also be + * freed.
> + *
> + * Returns the built power sequence set on success, or an error code in
> case of + * failure.
> + */
> +struct platform_power_seq_set *devm_of_parse_power_seq_set(struct device
> *dev) +{
> +	struct platform_power_seq_set *seqs;
> +	struct device_node *root = dev->of_node;
> +	struct device_node *seq;
> +	int num_seqs, sz, i = 0;
> +
> +	if (!root)
> +		return NULL;
> +
> +	root = of_find_node_by_name(root, "power-sequences");
> +	if (!root)
> +		return NULL;
> +
> +	num_seqs = of_get_child_count(root);
> +	sz = sizeof(*seqs) + sizeof(seqs->seqs[0]) * num_seqs;
> +	seqs = devm_kzalloc(dev, sz, GFP_KERNEL);
> +	if (!seqs)
> +		return ERR_PTR(-ENOMEM);
> +	seqs->num_seqs = num_seqs;
> +
> +	for_each_child_of_node(root, seq) {
> +		struct platform_power_seq *pseq;
> +
> +		pseq = of_parse_power_seq(dev, seq);
> +		if (IS_ERR(pseq))
> +			return (void *)pseq;
> +
> +		seqs->seqs[i++] = pseq;
> +	}
> +
> +	return seqs;
> +}
> +EXPORT_SYMBOL_GPL(devm_of_parse_power_seq_set);
> +#endif /* CONFIG_OF */
> +
> +/**
> + * devm_platform_power_seq_set_free() - free data allocated by
> of_parse_power_seq_set + * @pseq:	Platform data to free
> + *
> + * This function can be called *only* on data returned by
> of_parse_power_seq_set + * and *after* devm_power_seq_set_build has been
> called on it.
> + */
> +void devm_platform_power_seq_set_free(struct device *dev,
> +				      struct platform_power_seq_set *pseq)
> +{
> +	int i;
> +
> +	for (i = 0; i < pseq->num_seqs; i++)
> +		devm_kfree(dev, pseq->seqs[i]);
> +
> +	devm_kfree(dev, pseq);
> +}
> +EXPORT_SYMBOL_GPL(devm_platform_power_seq_set_free);
> +
> +static struct power_seq_resource *
> +power_seq_find_resource(struct list_head *ress,
> +			struct platform_power_seq_step *step)
> +{
> +	struct power_seq_resource *res;
> +
> +	list_for_each_entry(res, ress, list) {
> +		struct platform_power_seq_step *pdata = res->pdata;
> +
> +		if (pdata->type != step->type)
> +			continue;
> +
> +		if (power_seq_types[pdata->type].res_compare(pdata, step))
> +			return res;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct power_seq *power_seq_build_one(struct device *dev,
> +					     struct power_seq_set *seqs,
> +					     struct platform_power_seq *pseq)
> +{
> +	struct power_seq *seq;
> +	struct power_seq_resource *res;
> +	int i, err;
> +
> +	seq = devm_kzalloc(dev, sizeof(*seq) + sizeof(seq->steps[0]) *
> +			   pseq->num_steps, GFP_KERNEL);
> +	if (!seq)
> +		return ERR_PTR(-ENOMEM);
> +
> +	INIT_LIST_HEAD(&seq->list);
> +	seq->parent_set = seqs;
> +	seq->num_steps = pseq->num_steps;
> +	seq->id = pseq->id;
> +
> +	for (i = 0; i < seq->num_steps; i++) {
> +		struct platform_power_seq_step *pstep = &pseq->steps[i];
> +		struct power_seq_step *step = &seq->steps[i];
> +
> +		if (pstep->type >= POWER_SEQ_NUM_TYPES ||
> +		    power_seq_types[pstep->type].name == NULL) {
> +			power_seq_err(dev, seq, i,
> +				      "invalid power sequence type %d!",
> +		 		      pstep->type);
> +			return ERR_PTR(-EINVAL);
> +		}
> +
> +		memcpy(&step->pdata, pstep, sizeof(step->pdata));
> +
> +		/* Steps without resource need not to continue */
> +		if (!power_seq_types[pstep->type].need_resource)
> +			continue;
> +
> +		/* create resource node if not referenced already */
> +		res = power_seq_find_resource(&seqs->resources, pstep);
> +		if (!res) {
> +			res = devm_kzalloc(dev, sizeof(*res), GFP_KERNEL);
> +			if (!res)
> +				return ERR_PTR(-ENOMEM);
> +
> +			res->pdata = &step->pdata;
> +
> +			err = power_seq_types[res->pdata->type].res_alloc(dev, res);
> +			if (err < 0) {
> +				power_seq_err(dev, seq, i,
> +					      "error building sequence\n");
> +				return ERR_PTR(err);
> +			}
> +
> +			list_add_tail(&res->list, &seqs->resources);
> +		}
> +		step->resource = res;
> +	}
> +
> +	return seq;
> +}
> +
> +/**
> + * power_seq_set_build() - build a set of runnable sequences from platform
> data + * @dev:	Device that will use the power sequences. All resources
> will be + *		devm-allocated against it
> + * @pseq:	Platform data for the power sequences. It can be freed after
> + *		this function returns
> + *
> + * All memory and resources (regulators, GPIOs, etc.) are allocated using
> devm + * functions.
> + *
> + * Returns the built sequence on success, an error code in case or
> failure. + */
> +struct power_seq_set *devm_power_seq_set_build(struct device *dev,
> +					    struct platform_power_seq_set *pseq)
> +{
> +	struct power_seq_set *seqs;
> +	int i;
> +
> +	seqs = devm_kzalloc(dev, sizeof(*seqs), GFP_KERNEL);
> +
> +	if (!seqs)
> +		return ERR_PTR(-ENOMEM);
> +
> +	INIT_LIST_HEAD(&seqs->resources);
> +	INIT_LIST_HEAD(&seqs->sequences);
> +	for (i = 0; i < pseq->num_seqs; i++) {
> +		struct power_seq *seq;
> +
> +		seq = power_seq_build_one(dev, seqs, pseq->seqs[i]);
> +		if (IS_ERR(seq))
> +			return (void *)seq;
> +
> +		list_add_tail(&seq->list, &seqs->sequences);
> +	}
> +
> +	return seqs;
> +}
> +EXPORT_SYMBOL_GPL(devm_power_seq_set_build);
> +
> +/**
> + * power_seq_lookup - Lookup a power sequence by name from a set
> + * @seqs:	The set to look in
> + * @id:		Name to look after
> + *
> + * Returns a matching power sequence if it exists, NULL if it does not.
> + */
> +struct power_seq *power_seq_lookup(struct power_seq_set *seqs, const char
> *id) +{
> +	struct power_seq *seq;
> +
> +	list_for_each_entry(seq, &seqs->sequences, list) {
> +		if (!strcmp(seq->id, id))
> +			return seq;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(power_seq_lookup);
> +
> +/**
> + * power_seq_set_resources - return a list of all the resources used by a
> set + * @seqs:	Power sequences set we are interested in getting the
> resources + *
> + * The returned list can be parsed using the power_seq_for_each_resource
> macro. + */
> +struct list_head *power_seq_set_resources(struct power_seq_set *seqs)
> +{
> +	return &seqs->resources;
> +}
> +EXPORT_SYMBOL_GPL(power_seq_set_resources);
> +
> +/**
> + * power_seq_run() - run a power sequence
> + * @seq:	The power sequence to run
> + *
> + * Returns 0 on success, error code in case of failure.
> + */
> +int power_seq_run(struct power_seq *seq)
> +{
> +	unsigned int i;
> +	int err;
> +
> +	if (!seq)
> +		return 0;
> +
> +	for (i = 0; i < seq->num_steps; i++) {
> +		unsigned int type = seq->steps[i].pdata.type;
> +
> +		err = power_seq_types[type].step_run(&seq->steps[i]);
> +		if (err) {
> +			power_seq_err(seq->parent_set->dev, seq, i,
> +				"error %d while running power sequence step\n",
> +				err);
> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(power_seq_run);
> +
> +#include "power_seq_delay.c"
> +#include "power_seq_regulator.c"
> +#include "power_seq_pwm.c"
> +#include "power_seq_gpio.c"
> +
> +static const struct power_seq_res_ops power_seq_types[POWER_SEQ_NUM_TYPES]
> = { +	[POWER_SEQ_DELAY] = POWER_SEQ_DELAY_TYPE,
> +	[POWER_SEQ_REGULATOR] = POWER_SEQ_REGULATOR_TYPE,
> +	[POWER_SEQ_PWM] = POWER_SEQ_PWM_TYPE,
> +	[POWER_SEQ_GPIO] = POWER_SEQ_GPIO_TYPE,
> +};
> +
> +MODULE_AUTHOR("Alexandre Courbot <acourbot@nvidia.com>");
> +MODULE_DESCRIPTION("Runtime Interpreted Power Sequences");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/power/power_seq/power_seq_delay.c
> b/drivers/power/power_seq/power_seq_delay.c new file mode 100644
> index 0000000..072bf50
> --- /dev/null
> +++ b/drivers/power/power_seq/power_seq_delay.c
> @@ -0,0 +1,51 @@
> +/*
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> WITHOUT + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> General Public License for + * more details.
> + *
> + */
> +
> +#include <linux/delay.h>
> +
> +#ifdef CONFIG_OF
> +static int of_power_seq_parse_delay(struct device *dev,
> +				    struct device_node *node,
> +				    struct platform_power_seq *seq,
> +				    unsigned int step_nbr)
> +{
> +	struct platform_power_seq_step *step = &seq->steps[step_nbr];
> +	int err;
> +
> +	err = of_property_read_u32(node, "delay_us",
> +				   &step->delay.delay_us);
> +	if (err < 0)
> +		power_seq_err(dev, seq, step_nbr,
> +			      "error reading delay_us property\n");
> +
> +	return err;
> +}
> +#else
> +#define of_power_seq_parse_delay NULL
> +#endif
> +
> +static int power_seq_step_run_delay(struct power_seq_step *step)
> +{
> +	usleep_range(step->pdata.delay.delay_us,
> +		     step->pdata.delay.delay_us + 1000);
> +
> +	return 0;
> +}
> +
> +#define POWER_SEQ_DELAY_TYPE {			\
> +	.name = "delay",			\
> +	.need_resource = false,			\
> +	.of_parse = of_power_seq_parse_delay,	\
> +	.step_run = power_seq_step_run_delay,	\
> +}
> diff --git a/drivers/power/power_seq/power_seq_gpio.c
> b/drivers/power/power_seq/power_seq_gpio.c new file mode 100644
> index 0000000..2e9a49f
> --- /dev/null
> +++ b/drivers/power/power_seq/power_seq_gpio.c
> @@ -0,0 +1,81 @@
> +/*
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> WITHOUT + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> General Public License for + * more details.
> + *
> + */
> +
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +
> +#ifdef CONFIG_OF
> +static int power_seq_of_parse_gpio(struct device *dev,
> +				   struct device_node *node,
> +				   struct platform_power_seq *seq,
> +				   unsigned int step_nbr)
> +{
> +	struct platform_power_seq_step *step = &seq->steps[step_nbr];
> +	int gpio;
> +	int err;
> +
> +	gpio = of_get_named_gpio(node, "number", 0);
> +	if (gpio < 0) {
> +		power_seq_err(dev, seq, step_nbr,
> +			      "error reading number property\n");
> +		return gpio;
> +	}
> +	step->gpio.number = gpio;
> +
> +	err = of_power_seq_parse_enable_properties(dev, node, seq, step_nbr,
> +					     &step->gpio.enable);
> +
> +	return err;
> +}
> +#else
> +#define of_power_seq_parse_gpio NULL
> +#endif
> +
> +static bool power_seq_res_compare_gpio(struct platform_power_seq_step
> *step1, +				       struct platform_power_seq_step *step2)
> +{
> +	return step1->gpio.number == step2->gpio.number;
> +}
> +
> +static int power_seq_res_alloc_gpio(struct device *dev,
> +					struct power_seq_resource *res)
> +{
> +	int err;
> +
> +	err = devm_gpio_request_one(dev, res->pdata->gpio.number,
> +				    GPIOF_OUT_INIT_LOW, dev_name(dev));
> +	if (err) {
> +		dev_err(dev, "cannot get gpio %d\n", res->pdata->gpio.number);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int power_seq_step_run_gpio(struct power_seq_step *step)
> +{
> +	gpio_set_value_cansleep(step->pdata.gpio.number,
> +				step->pdata.gpio.enable);
> +
> +	return 0;
> +}
> +
> +#define POWER_SEQ_GPIO_TYPE {					\
> +	.name = "gpio",					\
> +	.need_resource = true,				\
> +	.of_parse = power_seq_of_parse_gpio,		\
> +	.step_run = power_seq_step_run_gpio,		\
> +	.res_compare = power_seq_res_compare_gpio,	\
> +	.res_alloc = power_seq_res_alloc_gpio,		\
> +}
> diff --git a/drivers/power/power_seq/power_seq_pwm.c
> b/drivers/power/power_seq/power_seq_pwm.c new file mode 100644
> index 0000000..a80514f
> --- /dev/null
> +++ b/drivers/power/power_seq/power_seq_pwm.c
> @@ -0,0 +1,85 @@
> +/*
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> WITHOUT + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> General Public License for + * more details.
> + *
> + */
> +
> +#ifdef CONFIG_PWM
> +
> +#include <linux/pwm.h>
> +
> +#ifdef CONFIG_OF
> +static int power_seq_of_parse_pwm(struct device *dev,
> +				  struct device_node *node,
> +				  struct platform_power_seq *seq,
> +				  unsigned int step_nbr)
> +{
> +	struct platform_power_seq_step *step = &seq->steps[step_nbr];
> +	int err;
> +
> +	err = of_property_read_string(node, "id",
> +				      &step->pwm.id);
> +	if (err) {
> +		power_seq_err(dev, seq, step_nbr,
> +			      "error reading id property\n");
> +		return err;
> +	}
> +
> +	err = of_power_seq_parse_enable_properties(dev, node, seq, step_nbr,
> +						   &step->pwm.enable);
> +	return err;
> +}
> +#else
> +#define of_power_seq_parse_pwm NULL
> +#endif
> +
> +static bool power_seq_res_compare_pwm(struct platform_power_seq_step
> *step1, +				      struct platform_power_seq_step *step2)
> +{
> +	return (!strcmp(step1->pwm.id, step2->pwm.id));
> +}
> +
> +static int power_seq_res_alloc_pwm(struct device *dev,
> +				  struct power_seq_resource *res)
> +{
> +	res->pwm = devm_pwm_get(dev, res->pdata->pwm.id);
> +	if (IS_ERR(res->pwm)) {
> +		dev_err(dev, "cannot get pwm \"%s\"\n", res->pdata->pwm.id);
> +		return PTR_ERR(res->pwm);
> +	}
> +
> +	return 0;
> +}
> +
> +static int power_seq_step_run_pwm(struct power_seq_step *step)
> +{
> +	if (step->pdata.gpio.enable) {
> +		return pwm_enable(step->resource->pwm);
> +	} else {
> +		pwm_disable(step->resource->pwm);
> +		return 0;
> +	}
> +}
> +
> +#define POWER_SEQ_PWM_TYPE {				\
> +	.name = "pwm",					\
> +	.need_resource = true,				\
> +	.of_parse = power_seq_of_parse_pwm,		\
> +	.step_run = power_seq_step_run_pwm,		\
> +	.res_compare = power_seq_res_compare_pwm,	\
> +	.res_alloc = power_seq_res_alloc_pwm,		\
> +}
> +
> +#else
> +
> +#define POWER_SEQ_PWM_TYPE {}
> +
> +#endif
> diff --git a/drivers/power/power_seq/power_seq_regulator.c
> b/drivers/power/power_seq/power_seq_regulator.c new file mode 100644
> index 0000000..915eac1
> --- /dev/null
> +++ b/drivers/power/power_seq/power_seq_regulator.c
> @@ -0,0 +1,86 @@
> +/*
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> WITHOUT + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> General Public License for + * more details.
> + *
> + */
> +
> +#ifdef CONFIG_REGULATOR
> +
> +#include <linux/regulator/consumer.h>
> +
> +/* TODO change "which" */
> +#ifdef CONFIG_OF
> +static int power_seq_of_parse_regulator(struct device *dev,
> +					struct device_node *node,
> +					struct platform_power_seq *seq,
> +					unsigned int step_nbr)
> +{
> +	struct platform_power_seq_step *step = &seq->steps[step_nbr];
> +	int err;
> +
> +	err = of_property_read_string(node, "id",
> +				      &step->regulator.id);
> +	if (err) {
> +		power_seq_err(dev, seq, step_nbr,
> +			      "error reading id property\n");
> +		return err;
> +	}
> +
> +	err = of_power_seq_parse_enable_properties(dev, node, seq, step_nbr,
> +						   &step->regulator.enable);
> +	return err;
> +}
> +#else
> +#define of_power_seq_parse_regulator NULL
> +#endif
> +
> +static bool
> +power_seq_res_compare_regulator(struct platform_power_seq_step *step1,
> +				struct platform_power_seq_step *step2)
> +{
> +	return (!strcmp(step1->regulator.id, step2->regulator.id));
> +}
> +
> +static int power_seq_res_alloc_regulator(struct device *dev,
> +					struct power_seq_resource *res)
> +{
> +	res->regulator = devm_regulator_get(dev, res->pdata->regulator.id);
> +	if (IS_ERR(res->regulator)) {
> +		dev_err(dev, "cannot get regulator \"%s\"\n",
> +			res->pdata->regulator.id);
> +		return PTR_ERR(res->regulator);
> +	}
> +
> +	return 0;
> +}
> +
> +static int power_seq_step_run_regulator(struct power_seq_step *step)
> +{
> +	if (step->pdata.regulator.enable)
> +		return regulator_enable(step->resource->regulator);
> +	else
> +		return regulator_disable(step->resource->regulator);
> +}
> +
> +#define POWER_SEQ_REGULATOR_TYPE {			\
> +	.name = "regulator",				\
> +	.need_resource = true,				\
> +	.of_parse = power_seq_of_parse_regulator,	\
> +	.step_run = power_seq_step_run_regulator,	\
> +	.res_compare = power_seq_res_compare_regulator,	\
> +	.res_alloc = power_seq_res_alloc_regulator,	\
> +}
> +
> +#else
> +
> +#define POWER_SEQ_REGULATOR_TYPE {}
> +
> +#endif
> diff --git a/include/linux/power_seq.h b/include/linux/power_seq.h
> new file mode 100644
> index 0000000..78e8d77
> --- /dev/null
> +++ b/include/linux/power_seq.h
> @@ -0,0 +1,174 @@
> +/*
> + * power_seq.h
> + *
> + * Simple interpreter for defining power sequences as platform data or
> device + * tree properties.
> + *
> + * Power sequences are designed to replace the callbacks typically used in
> + * board-specific files that implement board-specific power sequences of
> devices + * such as backlights. A power sequence is an array of resources
> (which can a + * regulator, a GPIO, a PWM, ...) with an action to perform
> on it (enable or + * disable) and optional pre and post step delays. By
> having them interpreted + * instead of arbitrarily executed, it is
> possible to describe these in the + * device tree and thus remove
> board-specific code from the kernel. + *
> + * Author: Alexandre Courbot <acourbot@nvidia.com>
> + *
> + * Copyright (c) 2012 NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> WITHOUT + * ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> General Public License for + * more details.
> + *
> + */
> +
> +#ifndef __LINUX_POWER_SEQ_H
> +#define __LINUX_POWER_SEQ_H
> +
> +#include <linux/types.h>
> +
> +struct device;
> +struct regulator;
> +struct pwm_device;
> +struct device_node;
> +
> +/**
> + * The different kinds of resources that can be controlled during the
> sequences. + */
> +enum power_seq_res_type {
> +	POWER_SEQ_DELAY,
> +	POWER_SEQ_REGULATOR,
> +	POWER_SEQ_PWM,
> +	POWER_SEQ_GPIO,
> +	POWER_SEQ_NUM_TYPES,
> +};
> +
> +/**
> + * struct platform_power_seq_delay_step - platform data for delay steps
> + * @delay_us:	Amount of time to wait, in microseconds.
> + */
> +struct platform_power_seq_delay_step {
> +	unsigned int delay_us;
> +};
> +
> +/**
> + * struct platform_power_seq_regulator_step - platform data for regulator
> steps + * @id:		Name of the regulator to use. The regulator will be
> obtained + *		using devm_regulator_get(dev, name)
> + * @enable:	Whether to enable or disable the regulator during this step
> + */
> +struct platform_power_seq_regulator_step {
> +	const char *id;
> +	bool enable;
> +};
> +
> +/**
> + * struct platform_power_seq_pwm_step - platform data for PWM steps
> + * @id:		Name of the pwm to use. The PWM will be obtained using
> + *		devm_pwm_get(dev, name)
> + * @enable:	Whether to enable or disable the PWM during this step
> + */
> +struct platform_power_seq_pwm_step {
> +	const char *id;
> +	bool enable;
> +};
> +
> +/**
> + * struct platform_power_seq_gpio_step - platform data for GPIO steps
> + * @number:	Number of the GPIO to use. The GPIO will be obtained using
> + *		devm_gpio_request_one(dev, number)
> + * @enable:	Whether to enable or disable the GPIO during this step
> + */
> +struct platform_power_seq_gpio_step {
> +	int number;
> +	bool enable;
> +};
> +
> +/**
> + * struct platform_power_seq_step - platform data for power sequences
> steps + * @type:	The type of this step. This decides which member of the
> union is + *		valid for this step.
> + * @delay:	Used if type == POWER_SEQ_DELAY
> + * @regulator:	Used if type == POWER_SEQ_REGULATOR
> + * @pwm:	Used if type == POWER_SEQ_PWN
> + * @gpio:	Used if type == POWER_SEQ_GPIO
> + */
> +struct platform_power_seq_step {
> +	enum power_seq_res_type type;
> +	union {
> +		struct platform_power_seq_delay_step delay;
> +		struct platform_power_seq_regulator_step regulator;
> +		struct platform_power_seq_pwm_step pwm;
> +		struct platform_power_seq_gpio_step gpio;
> +	};
> +};
> +
> +/**
> + * struct platform_power_seq - platform data for power sequences
> + * @id:		Name through which this sequence is refered
> + * @num_steps:	Number of steps in that sequence
> + * @steps:	Array of num_steps steps describing the sequence
> + */
> +struct platform_power_seq {
> +	const char *id;
> +	unsigned int num_steps;
> +	struct platform_power_seq_step steps[];
> +};
> +
> +/**
> + * struct platform_power_seq_set - platform data for sets of sequences
> + * @num_seqs:	Number of sequences in this set
> + * @seqs:	Array of pointers to individual sequences
> + */
> +struct platform_power_seq_set {
> +	unsigned int num_seqs;
> +	struct platform_power_seq* seqs[];
> +};
> +
> +/**
> + * struct power_seq_resource - resource used by a power sequence set
> + * @pdata:	Pointer to the platform data used to resolve this resource
> + * @regulator:	Resolved regulator if of type POWER_SEQ_REGULATOR
> + * @pwm:	Resolved PWM if of type POWER_SEQ_PWM
> + * @list:	Used to link resources together
> + */
> +struct power_seq_resource {
> +	/* relevant for resolving the resource and knowing its type */
> +	struct platform_power_seq_step *pdata;
> +	/* resolved resource (if any) */
> +	union {
> +		struct regulator *regulator;
> +		struct pwm_device *pwm;
> +	};
> +	struct list_head list;
> +};
> +#define power_seq_for_each_resource(pos, seqs)				\
> +	list_for_each_entry(pos, power_seq_set_resources(seqs), list)
> +
> +struct power_seq_resource;
> +struct power_seq;
> +struct power_seq_set;
> +
> +#ifdef CONFIG_OF
> +struct platform_power_seq_set *devm_of_parse_power_seq_set(struct device
> *dev); +#else
> +inline struct platform_power_seq_set *of_parse_power_seq_set(struct device
> *dev) +{
> +	return NULL;
> +}
> +#endif
> +void devm_platform_power_seq_set_free(struct device *dev,
> +				      struct platform_power_seq_set *pseq);
> +
> +struct power_seq_set *devm_power_seq_set_build(struct device *dev,
> +					   struct platform_power_seq_set *pseq);
> +struct list_head *power_seq_set_resources(struct power_seq_set *seqs);
> +struct power_seq *power_seq_lookup(struct power_seq_set *seqs, const char
> *id); +int power_seq_run(struct power_seq *seq);
> +
> +#endif

