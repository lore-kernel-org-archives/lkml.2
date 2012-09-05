Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072Ab2IERTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:19:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52139 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013Ab2IERTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:19:51 -0400
Message-ID: <504789B1.50205@wwwdotorg.org>
Date: Wed, 05 Sep 2012 11:19:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
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
Subject: Re: [PATCH v5 1/4] Runtime Interpreted Power Sequences
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <1346412846-17102-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1346412846-17102-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 05:34 AM, Alexandre Courbot wrote:
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

> +++ b/Documentation/devicetree/bindings/power_seq/power_seq.txt

> +Runtime Interpreted Power Sequences
> +===================================
> +
> +Power sequences are sequential descriptions of actions to be performed on
> +power-related resources. Having these descriptions in a precise data format
> +allows us to take much of the board-specific power control code out of the
> +kernel and place it into the device tree instead, making kernels less
> +board-dependant.
> +

> +In the device tree, power sequences are grouped into a set. The set is always
> +declared as the "power-sequences" sub-node of the device node. Power sequences
> +may reference resources declared by that device.

I had to read that a few times to realize this was talking about a
device with multiple power sequences, and not talking about the steps in
a sequence. I think if you add the following sentence at the start of
that paragraph, it will be clearer:

A device may support multiple power sequences, for different events such
as powering on and off.

Also, perhaps add "these" at the first comma, so the above would read:

In the device tree, these power sequences are...

> +Power Sequences Structure
> +-------------------------
> +Every device that makes use of power sequences must have a "power-sequences"
> +sub-node. Power sequences are sub-nodes of this set node, and their node name
> +indicates the id of the sequence.
> +
> +Every power sequence in turn contains its steps as sub-nodes of itself. Step

The last word on that line should be "Steps".

> +must be named sequentially, with the first step named step0, the second step1,
> +etc. Failure to follow this rule will result in a parsing error.
> +
> +Power Sequences Steps
> +---------------------
> +Step of a sequence describes an action to be performed on a resource. They

s/Step/Steps/, s/describes/describe/.

> +always include a "type" property which indicates what kind of resource this
> +step works on. Depending on the resource type, additional properties are defined
> +to control the action to be performed.
> +
> +"delay" type required properties:
> +  - delay_us: delay to wait in microseconds

DT property name should use "-" not "_" to separate words, so "delay-us".

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

For those two, would "name" be a better property name than "id"?

I wonder if we should have "regulator-enable" and "regulator-disable"
step types, rather than a "regulator" step type, with an "enable" or
"disable" property within it. I don't feel strongly though; this is
probably fine.

> +"gpio" type required properties:
> +  - number: phandle of the GPIO to use.

Naming the property "gpio" would seem more consistent with our GPIO
properties.

> +  - enable / disable: one of these two empty properties must be present to
> +                      enable or disable the resource

You can't really enable or disable a GPIO (well, perhaps you can, but
I'd consider that to affect tri-state rather than value); it's more that
you're setting the output value to 0 or 1. I think a "value" or
"set-value" property with value <0> or <1> would be better.

...
> +After the resources declaration, two sequences follow for powering the backlight
> +on and off. Their names are specified by the pwm-backlight driver.

Not the driver, but the binding for the device.

Overall, the general structure of the bindings looks reasonable to me.

> +++ b/Documentation/power/power_seq.txt

...
> +Platform Data Format
> +--------------------
> +All relevant data structures for declaring power sequences are located in
> +include/linux/power_seq.h.
> +
> +The platform data for a given device is an instance of platform_power_seq_set
> +which points to instances of platform_power_seq. Every platform_power_seq is a
> +single power sequence, and is itself composed of a variable length array of
> +steps.

I don't think you can mandate that the entire platform data structure
for a device is a platform_power_seq_set. Instead, I think you should
say that "The platform data for a device may contain an instance of
platform_power_seq_set...".

...
> +A power sequence can be executed by power_seq_run:
> +
> +  int power_seq_run(struct power_seq *seq);
> +
> +It returns 0 if the sequence has successfully been run, or an error code if a
> +problem occured.

s/occured/occurred/

> +Sometimes, you may want to browse the list of resources allocated by a sequence,
> +to for instance ensure that a resource of a given type is present. The
> +power_seq_set_resources() function returns a list head that can be used with
> +the power_seq_for_each_resource() macro to browse all the resources of a set:
> +
> +  struct list_head *power_seq_set_resources(struct power_seq_set *seqs);
> +  power_seq_for_each_resource(pos, seqs)
> +
> +Here "pos" will be of type struct power_seq_resource. This structure contains a
> +"pdata" pointer that can be used to explore the platform data of this resource,
> +as well as the resolved resource, if applicable.

I'm not sure what "pdata" is supposed to point at; platform data applies
to the original "struct device", not one of the resources used by the
power sequences.

> +Finally, users of the device tree can build the platform data corresponding to
> +the tree node using this function:
> +
> +  struct platform_power_seq_set *devm_of_parse_power_seq_set(struct device *dev);

Hmmm. It'd be nice not to need separate functions for the non-DT and DT
cases. That would require that devm_power_seq_set_build() be able to
find the power sequence definitions somewhere other than platform data
in the non-DT case - that's exactly why the regulator and pinctrl
subsystems represent the device<->data mapping table separately from the
device's platform data.

> +++ b/drivers/power/power_seq/Kconfig

> +config POWER_SEQ
> +	bool

Some kind of help text might be useful?

I didn't review any of the .c files.

> +++ b/include/linux/power_seq.h

> +/**
> + * struct platform_power_seq_step - platform data for power sequences steps
> + * @type:	The type of this step. This decides which member of the union is
> + *		valid for this step.
> + * @delay:	Used if type == POWER_SEQ_DELAY
> + * @regulator:	Used if type == POWER_SEQ_REGULATOR
> + * @pwm:	Used if type == POWER_SEQ_PWN
> + * @gpio:	Used if type == POWER_SEQ_GPIO

In those last 4 line, I think s/type/@type/ since you're referencing
another parameter?

> +struct power_seq_resource {
> +	/* relevant for resolving the resource and knowing its type */
> +	struct platform_power_seq_step *pdata;

Aha. So this isn't really platform data for the resource, but actually a
step definition that referenced it. I think it'd be better to rename
this field "step", and amend the documentation above not to refer to
"pdata" but explicitly talk about a step definition; the step may have
been defined in pdata, but isn't in the DT case.

Alternatively, why not just copy the step type enum here, rather than
referencing the step definition?

