Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2LMTIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:08:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58255 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2LMTIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:08:49 -0500
Message-ID: <50CA27BC.6060304@wwwdotorg.org>
Date: Thu, 13 Dec 2012 12:08:44 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl/nomadik: Add Device Tree support
References: <1355405825-19400-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1355405825-19400-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 06:37 AM, Linus Walleij wrote:
> This implements pin multiplexing and pin configuration for the
> Nomadik pin controller using the device tree.

> diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt

> +Required properties:
> +- compatible: "stericsson,nmk_pinctrl"

Minor nit: Is it more common to use - rather than _ in compatible values?

> +ST Ericsson's pin configuration nodes act as a container for an abitrary number of

Typo in "arbitrary" above.

> +subnodes. Each of these subnodes represents some desired configuration for a
> +pin, a group, or a list of pins or groups. This configuration can include the
> +mux function to select on those pin(s)/group(s), and various pin configuration
> +parameters, such as inputn output, pull up, pull down...

Typo in "input" above.

> +The name of each subnode is not important; all subnodes should be enumerated
> +and processed purely based on their content.
> +
> +Required subnode-properties:
> +- ste,pins : An array of strings. Each string contains the name of a pin or
> +    group.

The vendor prefix here is ste, but it's stericsson in the compatible
value above. They should be consistent. ste is nice since it's shorter,
but I see stericsson in
Documentation/devicetree/bindings/vendor-prefixes.txt... I wonder if you
could register ste there too?

> +Optional subnode-properties:
> +- ste,function: A string containing the name of the function to mux to the
> +  pin or group.
> +
> +- ste,input:			no parameter, set pin in input with no pull mode.
> +- ste,input_pull_up:		no parameter, set pin in input with pull up mode.
> +- ste,input_pull_down:		no parameter, set pin in input with pull down mode.

DT property names should definitely use - not _ as a delimiter.

> +- ste,sleep_input:		no parameter, set pin in sleep input with no pull mode.
> +- ste,sleep_input_pull_up:	no parameter, set pin in sleep input with pull up mode.
> +- ste,sleep_input_pull_down:	no parameter, set pin in sleep input with pull down mode.

Would ste,sleep-input = <0/1/2> be better? Not really a big deal either way.

> +- ste,sleep_pdis_mode:		integer, 0: pdis disabled, 1: pdis enable.

Should the binding document mention what "pdis" is. It's probably not
necessary so long as "pdis" is something you can search for in the HW
documentation.

> +Valid values for pin and group name are in Drivers/pinctrl/pinctrl-nomadik-db8500.c

Hmm. That's rather tying the DT binding documentation to Linux code, and
DT binding docs should be OS-agnostic. Are the names identical to the HW
documentation? If so, perhaps you could reference that instead of the
Linux driver.

> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c

> +static int nmk_dt_reserve_map(struct pinctrl_map **map, unsigned *reserved_maps,
> +static int nmk_dt_add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
> +static int nmk_dt_add_map_configs(struct pinctrl_map **map,

Those (and hence perhaps code that calls it?) is cut/paste from
pinctrl-tegra.c. Is it worth lifting the functions out into some common
code to share it?

> +static const char * nmk_find_pin_name(struct pinctrl_dev *pctldev, const char *pin_name)

> +	if (sscanf((char *) pin_name, "GPIO%d",&pin_number) == 1)
> +		for(i = 0; i < npct->soc->npins; i++)

There are some white-space issues there:

* Shouldn't be a space after the cast in sscanf() call.
* Should be a space after comma in sscanf() call.
* Should be a space after "for".

> +int nmk_pinctrl_dt_subnode_to_map(struct pinctrl_dev *pctldev,

> +	for (i = 0; i < ARRAY_SIZE(nmk_cfg_params); i++) {
> +		unsigned long cfg = 0;
> +		int val;
> +
> +		ret = of_property_read_u32(np, nmk_cfg_params[i].property, &val);

A lot of those are Booleans not U32s...
