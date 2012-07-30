Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2G3WqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:46:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56631 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab2G3WqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:46:06 -0400
Message-ID: <50170EA0.1010408@wwwdotorg.org>
Date: Mon, 30 Jul 2012 16:45:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com> <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 06:05 AM, Alexandre Courbot wrote:
> Some device drivers (panel backlights especially) need to follow precise
> sequences for powering on and off, involving gpios, regulators, PWMs
> with a precise powering order and delays to respect between each steps.
> These sequences are board-specific, and do not belong to a particular
> driver - therefore they have been performed by board-specific hook
> functions to far.

> diff --git a/Documentation/power/power_seq.txt b/Documentation/power/power_seq.txt

> +Sequences Format
> +----------------
> +Power sequences are a series of sequential steps during which an action is
> +performed on a resource. The supported resources so far are:
> +- GPIOs
> +- Regulators
> +- PWMs
> +
> +Each step designates a resource and the following parameters:
> +- Whether the step should enable or disable the resource,

At the highest level, i.e. what's being describe here, I wouldn't even
talk about enable/disable, but rather the action to perform on the
resource. The set of legal actions may be specific to the type of
resource in question. Admittedly enable/disable are common though.

> +- Delay to wait before performing the action,
> +- Delay to wait after performing the action.

I don't see a need to have a delay both before and after an action;
except at the start of the sequence, step n's post-delay is at the same
point in the sequence as step n+1's pre-delay. Perhaps make a "delay"
step type?

> +Both new resources and parameters can be introduced, but the goal is of course
> +to keep things as simple and compact as possible.

> +The platform data is a simple array of platform_power_seq_step instances, each

Rather than jumping straight into platform data here, I'd expect an
enumeration of legal resource types, and what actions can be performed
on each, followed by a description of a sequence (very simply, just a
list of actions and their parameters). This could be followed by a
section describing the mapping of the abstract concepts to concrete
platform data representation (and concrete device tree representation).

> +instance describing a step. The type as well as one of id or gpio members
> +(depending on the type) must be specified. The last step must be of type
> +POWER_SEQ_STOP.

I'd certainly suggest having a step count rather than a sentinel value
in the list.

> Regulator and PWM resources are identified by name. GPIO are
> +identified by number.

That's a little implementation-specific. I guess it's entirely true for
a platform data representation, but not when mapping this into device tree.

> +Usage by Drivers and Resources Management
> +-----------------------------------------
> +Power sequences make use of resources that must be properly allocated and
> +managed. The power_seq_build() function takes care of resolving the resources as
> +they are met in the sequence and to allocate them if needed:
> +
> +power_seq *power_seq_build(struct device *dev, power_seq_resources *ress,
> +			   platform_power_seq *pseq);
> +
> +You will need an instance of power_seq_resources to keep track of the resources
> +that are already allocated. On success, the function returns a devm allocated
> +resolved sequence that is ready to be passed to power_seq_run(). In case of
> +failure, and error code is returned.

If the result is devm-allocated, the function probably should be named
devm_power_seq_build().

I wonder if using the same structure/array as input and output would
simplify the API; the platform data would fill in the fields mentioned
above, and power_seq_build() would parse those, then set other fields in
the same structs to the looked-up handle values?

> +Finally, some resources that cannot be allocated through devm need to be freed
> +manually. Therefore, be sure to call power_seq_free_resources() in your device
> +remove function:
> +
> +void power_seq_free_resources(power_seq_resources *ress);

You can make a custom devm free routine for the power_seq_resources
itself, so the overall free'ing of the content can be triggered by devm,
but the free'ing function can then call whatever non-devm APIs it wants
for the non-devm-allocated members.

> +Device tree
> +-----------
> +All the same, power sequences can be encoded as device tree nodes. The following
> +properties and nodes are equivalent to the platform data defined previously:
> +
> +		power-supply = <&mydevice_reg>;
> +		enable-gpio = <&gpio 6 0>;
> +
> +		power-on-sequence {
> +			regulator@0 {

As Thierry mentioned, the step nodes should be named for the type of
object they are (a "step") not the type or name of resource they act
upon ("regulator" or "gpio").

If the nodes have a unit address (i.e. end in "@n"), which they will
have to if all named "step" and there's more than one of them, then they
will need a matching reg property. Equally, the parent node will need
#address-cells and #size-cells too. So, the last couple lines would be:

		power-on-sequence {
			#address-cells = <1>;
			#size-cells = <0>;
			step@0 {
				reg = <0>;

> +				id = "power";

"id" is usually a name or identifier. I think you mean "type" or perhaps
"action" here:

				type = "regulator";
				action = "enable";

or:

				action = "enable-regulator";

I wish we had integer constants in DT so we didn't have to do all this
with strings. Sigh.

> +				enable;
> +				post-delay = <10>;
> +			};
> +			gpio@1 {
> +				id = "enable-gpio";
> +				enable;
> +			};
> +		};
> +
> +Note that first, the phandles of the regulator and gpio used in the sequences
> +are defined as properties. Then the sequence references them through the id
> +property of every step. The name of sub-properties defines the type of the step.
> +Valid names are "regulator", "gpio" and "pwm". Steps must be numbered
> +sequentially.

Oh I see. That's a little confusing. Why not just reference the relevant
resources directly in each step; something more like:

		gpio@1 {
			action = "enable-gpio";
			gpio = <&gpio 1 0>;
		};

I guess that might make parsing/building a little harder, since you'd
have to detect when you'd already done gpio_request() on a given GPIO
and not repeat it or something like that, but to me this makes the DT a
lot easier to comprehend.
