Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2EZNLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:11:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52049 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2EZNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:10:58 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 6/6] pinctrl: add pinctrl gpio binding support
To: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, b29396@freescale.com
In-Reply-To: <1337952980-14621-6-git-send-email-b29396@freescale.com>
References: <1337952980-14621-1-git-send-email-b29396@freescale.com> <1337952980-14621-6-git-send-email-b29396@freescale.com>
Date: Fri, 25 May 2012 18:29:49 -0600
Message-Id: <20120526002950.062683E14F7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 21:36:20 +0800, Dong Aisheng <b29396@freescale.com> wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This patch implements a standard common binding for pinctrl gpio ranges.
> Each SoC can add gpio ranges through device tree by adding a gpio-maps property
> under their pinctrl devices node with the format:
> <&gpio $gpio-specifier $pin_offset $count>
> while the gpio phandle and gpio-specifier are the standard approach
> to represent a gpio in device tree.
> Then we can cooperate it with the gpio xlate function to get the gpio number
> from device tree to set up the gpio ranges map.
> 
> Then the pinctrl driver can call pinctrl_dt_add_gpio_ranges(pctldev, node)
> to parse and register the gpio ranges from device tree.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> Personally i'm not very satisfied with current solution due to a few reasons:
> 1) i can not user standard gpio api to get gpio number
> 2) i need to reinvent a new api of_parse_phandles_with_args_ext which i'm not
> sure if it can be accepted by DT maintainer.

Right, as mentioned in my other email, doing it this way completely
breaks the way the phandle-with-args pattern works.  That pattern
depends on the phandle node to have a #-cells property telling it how
many cells to process for the binding.  Adding additional data cells
means the kernel is no longer able to parse multiple entries in the
gpios property.

> If i did not invent that API, i need to rewrite a lot of duplicated code
> with slight differences with the exist functions like of_get_named_gpio_flags
> and of_parse_phandle_with_args for the special pinctrl gpio maps format.
> 
> So i just sent it out first to see people's comment and if any better solution.
> 
> One alternative solution is that that the gpio-maps into two parts:
> pinctrl-gpios = <&gpio_phandle gpio-specifier ..>
> pinctrl-gpio-maps = <pin_id count ..>
> Then we can reuse the standard gpio api altough it's not better than the
> original one.
> 
> Comments are welcome!
> 
> ChangeLog v3->v4:
> * using standard gpio parsing approach to get the gpio number from device
>   tree. The gpio-maps becomes a little slightly different as before:
>   <&gpio $gpio_specifier $pin_offset $npin>.
>   The $gpio_specifier length is controller dependent which is specified by
>   '#gpio-cells' in in gpio controller node.
> 
> ChangeLog v2->v3:
> * standardise the gpio ranges node name to 'gpio-maps'. Each SoC should use this
> node name to define gpio ranges.
> * defer probe if can not get gpiochip from node in case gpio driver is still
> not loaded.
> * some other minor fixes suggested by Stephen Warren.
> 
> ChangeLog v1->v2:
> * introduce standard binding for gpio range.
> ---
>  .../bindings/pinctrl/pinctrl-bindings.txt          |   22 +++++
>  drivers/pinctrl/devicetree.c                       |   95 ++++++++++++++++++++
>  include/linux/pinctrl/pinctrl.h                    |   11 +++
>  3 files changed, 128 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> index c95ea82..e999be5 100644
> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> @@ -126,3 +126,25 @@ device; they may be grandchildren, for example. Whether this is legal, and
>  whether there is any interaction between the child and intermediate parent
>  nodes, is again defined entirely by the binding for the individual pin
>  controller device.
> +
> +=== pinctrl gpio ranges ===
> +Some pins in pinctrl device can also be multiplexed as gpio. With a gpio range
> +map, user can know which pin in the range can be used as gpio.
> +
> +Required properties:
> +gpio-maps: integers array, each entry in the array represents a gpio range
> +with the format: <&gpio $gpio-specifier $pin_offset $count>
> +- gpio: phandle pointing at gpio device node
> +- gpio-specifier: array of #gpio-cells specifying specific gpio, the length is
> +  controller specific. Usually it may be two cells for simple gpio.
> +- pin_offset: integer, the pin offset or pin id
> +- npins: integer, the gpio ranges starting from pin_offset
> +
> +For example:
> +pincontroller {
> +	/* gpio-specifier is two cells */
> +	gpio-maps = <&gpio1 0 0 0 32
> +		     &gpio2 0 0 0 30
> +		     &gpio3 1 0 100 1
> +		     ....>;

Hmmm.... I need more information about this gpio-maps property.  How
is it arranged?  What kind of data is in it.  Can you give some
specific examples of how hardware would be described with a gpio-maps
property?

g.

