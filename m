Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab2HWRyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:54:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54993 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2HWRyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:54:17 -0400
Message-ID: <50366E44.4030606@wwwdotorg.org>
Date: Thu, 23 Aug 2012 11:54:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com> <1345623750-10645-2-git-send-email-sebastian.hesselbarth@gmail.com> <5035445B.6000500@wwwdotorg.org> <CABJ1b_Tdr80DGqb-FRzwDbF3m7g6fBguk5GtRAfRUYx5Sqy_cA@mail.gmail.com>
In-Reply-To: <CABJ1b_Tdr80DGqb-FRzwDbF3m7g6fBguk5GtRAfRUYx5Sqy_cA@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 03:45 AM, Sebastian Hesselbarth wrote:
> On 8/22/12, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/22/2012 02:22 AM, Sebastian Hesselbarth wrote:
>>> +++ b/drivers/pinctrl/pinctrl-mvebu.c
>>
>>> +static int mvebu_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
>>
>>> +	of_property_for_each_string(np, "marvell,pins", prop, group) {
>>> +		struct mvebu_pinctrl_group *grp =
>>> +			mvebu_pinctrl_find_group_by_name(pctl, group);
>>> +
>>> +		if (!grp) {
>>> +			dev_err(pctl->dev, "unknown pin %s", group);
>>> +			continue;
>>> +		}
>>> +
>>> +		if (!mvebu_pinctrl_find_setting_by_name(pctl, grp, function)) {
>>> +			dev_err(pctl->dev, "unsupported function %s on pin %s",
>>> +				function, group);
>>> +			continue;
>>> +		}
>>
>> The error-checking here isn't strictly necessary; the pinctrl core will
>> error-check all the names if/when the map entries are used. So, you
>> could probably get away with just assigning the pin/function names
>> directly into (*map) and hence remove some code here. Still, it's not a
>> big deal either way.
> 
> Hi Stephen,
> 
> as these error checks are only performed once, I'd like to have them there
> as they give hints when someone uses wrong marvell,pins/function names
> in DT.
> 
>>> +static int __devinit mvebu_pinctrl_dt_parse_function(struct mvebu_pinctrl
>>> *pctl,
>>
>>> +static int __devinit mvebu_pinctrl_dt_parse(struct platform_device
>>> *pdev,
>>> +					struct mvebu_pinctrl *pctl)
>>
>> I don't understand what those two functions do, or a good chunk of
>> probe(). It seems like they're setting up the ability to get/set pin
>> configrations in addition to pin muxing, although if that's so, it seems
>> odd that none of the binding documents specify any way of controlling
>> pin configuration from device tree. Are you expecting drivers to call
>> APIs such as pin_config_set() directly, rather than controlling pin
>> config through DT?
> 
> probe() receives some structs from the SoC specific driver stubs that
> describe, e.g. how many muxable pins are available, which pingroup they
> belong to (marvell,pins), what valid register values are and how they are
> named (marvell,function). Although, all mvebu SoC share a good part of
> pinmux register layout, there are especially for dove some very different
> ways to mux pins. As mvebu pinctrl is a true mux-only driver, i.e. no
> pin drive strength or pin direction configuration, we decided not to have
> single pins controlable but only pingroups even if they comprise only a
> single pin.
> 
> dt_parse() and dt_parse_function() build up structs that get used later on
> in mvebu_pinmux_ops that require indexed functions. I can join them with
> dt_node_to_map() but that would require incremental kzalloc for the
> corresponding array. Or I could (functionally) leave dt_parse() to allocate
> the array and only join dt_parse_function() with dt_node_to_map().

So everything you said makes sense, in that the core driver is
parameterizable and receives data from a SoC-variant-specific driver
indicating which pins/groups/functions are available. I'm still not sure
though why the translation of the pin/group/function structures passed
to probe into other data structures requires accessing the DT at all;
the set of available pins/groups/functions isn't configured through DT,
and doesn't need to be limited to only those options actually used in
DT, so can't you just process all the data that's passed to probe
without interaction with the DT?

