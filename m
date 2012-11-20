Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab2KTVyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:54:43 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53266 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2KTVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:54:41 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
To: Alexandre Courbot <acourbot@nvidia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
In-Reply-To: <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
Date: Tue, 20 Nov 2012 21:54:29 +0000
Message-Id: <20121120215429.B621F3E1821@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012 19:55:45 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Some device drivers (e.g. panel or backlights) need to follow precise
> sequences for powering on and off, involving GPIOs, regulators, PWMs
> and other power-related resources, with a defined powering order and
> delays to respect between steps. These sequences are device-specific,
> and do not belong to a particular driver - therefore they have been
> performed by board-specific hook functions so far.

I must be honest, this series really makes me nervous...

> With the advent of the device tree and of ARM kernels that are not
> board-tied, we cannot rely on these board-specific hooks anymore but

This isn't strictly true. It is still perfectly fine to have board
specific code when necessary. However, there is strong encouragement to
enable that code in device drivers as much as possible and new board
files need to have very strong justification.

> need a way to implement these sequences in a portable manner. This patch
> introduces a simple interpreter that can execute such power sequences
> encoded either as platform data or within the device tree. It also
> introduces first support for regulator, GPIO and PWM resources.

This is where I start getting nervous. Up to now I've strongly resisted
adding any kind of interpreted code to the device tree. The model is to
identify hardware, but require the driver to know how to control it. (as
compared to ACPI which is entirely designed around executable
bytecode).

While the power sequences described here certainly cannot be confused
with a Turing complete bytecode, it is a step in that direction. Plus,
there will always be that new use case that needs just a "little new
feature" to make this work for that too. Without thinking about how to
handle that ahead of time is just asking for something to turn into a
maintenance nightmare. It's just as important to specify what the limits
of this approach are and when to punt to real driver code to handle a
device.

> +Power Sequences Steps
> +---------------------
> +Steps of a sequence describe an action to be performed on a resource. They
> +always include a "type" property which indicates what kind of resource this
> +step works on. Depending on the resource type, additional properties are defined
> +to control the action to be performed.
> +
> +"delay" type required properties:
> +  - delay: delay to wait (in microseconds)
> +
> +"regulator" type required properties:
> +  - id: name of the regulator to use.
> +  - enable / disable: one of these two empty properties must be present to
> +                      enable or disable the resource
> +
> +"pwm" type required properties:
> +  - id: name of the PWM to use.
> +  - enable / disable: one of these two empty properties must be present to
> +                      enable or disable the resource
> +
> +"gpio" type required properties:
> +  - gpio: phandle of the GPIO to use.
> +  - value: value this GPIO should take. Must be 0 or 1.
> +
> +Example
> +-------
> +Here are example sequences declared within a backlight device that use all the
> +supported resources types:
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
> +					delay = <10000>;
> +				};
> +				step2 {
> +					type = "pwm";
> +					id = "backlight";
> +					enable;
> +				};
> +				step3 {
> +					type = "gpio";
> +					gpio = <&gpio 28 0>;
> +					value = <1>;
> +				};
> +			};
> +
> +			power-off {
> +				step0 {
> +					type = "gpio";
> +					gpio = <&gpio 28 0>;
> +					value = <0>;
> +				};
> +				step1 {
> +					type = "pwm";
> +					id = "backlight";
> +					disable;
> +				};
> +				step2 {
> +					type = "delay";
> +					delay = <10000>;
> +				};
> +				step3 {
> +					type = "regulator";
> +					id = "power";
> +					disable;
> +				};
> +			};
> +		};
> +	};

I think this will get very verbose in a hurry. Already this simple
example is 45 lines long. Using the device tree structure to encode the
language doesn't look like a very good fit. Not to mention that the
order of operations is entirely based on the node name. Want to insert
an operation between step0 and step1? Need to rename step1, step2, and
step3 to do so.

This implementation also isn't very consistent. The gpio is referenced
with a phandle in step3/step0, but the regulator and pwm are referenced
by id.

As an alternative, what about something like the following?

	backlight {
		compatible = "pwm-backlight";
		...

		/* resources used by the power sequences */
		pwms = <&pwm 2 5000000>;
		pwm-names = "backlight";
		regulators = <&backlight_reg>;
		gpios = <&gpio 28 0>;

		power-on-sequence = "r0e;d10000m;p0e;g0s";
		power-off-sequence = "g0c;p0d;d10000m;r0d";
	};

I'm thinking about the scripts as trivial-to-parse ascii strings that
have a very simple set of commands. The commands use resources already
defined in the node. ie. 'g0' refers to the first entry in the gpios
property. 'r0' for the regulator, 'p0' for the pwms, 'd' means delay. By
no means take this as the format to use, it is just an example off the
top of my head, but it is already way easier to work with than putting
each command into a node.

The trick is still to define a syntax that doesn't fall apart when it
needs to be extended. I would also like to get opinions on whether or
not conditionals or loops should be supported (ie. loop waiting for a
status to change). If they should then we need to be a lot more careful
about the design (and due to my aforementioned nervousness, somebody may
need to get me therapy).

(Mitch, I'll let you make the argument for using Forth here. To be
honest, I'm not keen on defining any kind of new language, however
simple, but neither am I keen to pull in Forth).

> +Platform Data Format
> +--------------------
> +All relevant data structures for declaring power sequences are located in
> +include/linux/power_seq.h.

Hmm... If sequences are switched to a string instead, then platform_data
should also use it. The power sequence data structures can be created at
runtime by parsing the string.

g.
