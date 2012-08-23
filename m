Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab2HWJpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 05:45:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47335 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab2HWJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 05:45:28 -0400
MIME-Version: 1.0
In-Reply-To: <5035445B.6000500@wwwdotorg.org>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1345623750-10645-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<5035445B.6000500@wwwdotorg.org>
Date: Thu, 23 Aug 2012 11:45:27 +0200
Message-ID: <CABJ1b_Tdr80DGqb-FRzwDbF3m7g6fBguk5GtRAfRUYx5Sqy_cA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/12, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/22/2012 02:22 AM, Sebastian Hesselbarth wrote:
>> +++ b/drivers/pinctrl/pinctrl-mvebu.c
>
>> +static int mvebu_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
>
>> +	of_property_for_each_string(np, "marvell,pins", prop, group) {
>> +		struct mvebu_pinctrl_group *grp =
>> +			mvebu_pinctrl_find_group_by_name(pctl, group);
>> +
>> +		if (!grp) {
>> +			dev_err(pctl->dev, "unknown pin %s", group);
>> +			continue;
>> +		}
>> +
>> +		if (!mvebu_pinctrl_find_setting_by_name(pctl, grp, function)) {
>> +			dev_err(pctl->dev, "unsupported function %s on pin %s",
>> +				function, group);
>> +			continue;
>> +		}
>
> The error-checking here isn't strictly necessary; the pinctrl core will
> error-check all the names if/when the map entries are used. So, you
> could probably get away with just assigning the pin/function names
> directly into (*map) and hence remove some code here. Still, it's not a
> big deal either way.

Hi Stephen,

as these error checks are only performed once, I'd like to have them there
as they give hints when someone uses wrong marvell,pins/function names
in DT.

>> +static int __devinit mvebu_pinctrl_dt_parse_function(struct mvebu_pinctrl
>> *pctl,
>
>> +static int __devinit mvebu_pinctrl_dt_parse(struct platform_device
>> *pdev,
>> +					struct mvebu_pinctrl *pctl)
>
> I don't understand what those two functions do, or a good chunk of
> probe(). It seems like they're setting up the ability to get/set pin
> configrations in addition to pin muxing, although if that's so, it seems
> odd that none of the binding documents specify any way of controlling
> pin configuration from device tree. Are you expecting drivers to call
> APIs such as pin_config_set() directly, rather than controlling pin
> config through DT?

probe() receives some structs from the SoC specific driver stubs that
describe, e.g. how many muxable pins are available, which pingroup they
belong to (marvell,pins), what valid register values are and how they are
named (marvell,function). Although, all mvebu SoC share a good part of
pinmux register layout, there are especially for dove some very different
ways to mux pins. As mvebu pinctrl is a true mux-only driver, i.e. no
pin drive strength or pin direction configuration, we decided not to have
single pins controlable but only pingroups even if they comprise only a
single pin.

dt_parse() and dt_parse_function() build up structs that get used later on
in mvebu_pinmux_ops that require indexed functions. I can join them with
dt_node_to_map() but that would require incremental kzalloc for the
corresponding array. Or I could (functionally) leave dt_parse() to allocate
the array and only join dt_parse_function() with dt_node_to_map().

There is an example of how to use pinctrl in marvell.mvebu-pinctrl.txt:
uart1: serial@12100 {
	compatible = "ns16550a";
	reg = <0x12100 0x100>;
	reg-shift = <2>;
	interrupts = <7>;

	pinctrl-0 = <&pmx_uart1_sw>;
};

pinctrl: pinctrl@d0200 {
	compatible = "marvell,dove-pinctrl";
	reg = <0xd0200 0x20>;

	pmx_uart1_sw: pmx-uart1-sw {
		marvell,pins = "mpp_uart1";
		marvell,function = "uart1";
	};
};

In my understanding this will allow uart1 to switch the pingroup "mpp_uart1"
to the function "uart1". The pinctrl core driver is taking care of
translating mpp_uart1
to the corresponding pingroup and mvebu core driver of translating
uart1 into the required
register values to set the requested function. Is it so odd, that we
use names instead
of direct register values in DT? I agree, that maybe picking an example for dove
that is a little bit different in pingroup naming isn't the best
choice but it still gives
you an idea how to use it.

Consider this (virtual) example:
Muxing some SATA functions to pins 24 and 37 would require to set
register values
to 0x3 on pin 24 and 0x6 on pin 37. The proposed driver still allows
us to have a DT
description of

pmx_sata_example: pmx-sata-example {
	marvell,pins = "mpp24", "mpp37";
	marvell,function = "sata";
};

because the SoC specific driver passes function "sata" on pins 24 and
37 with the
corresponding register values. These are fed by the mvebu core driver
that builds
up all required pins, pingroups, and pinmux functions.

Sebastian
