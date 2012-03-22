Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2CVRWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:22:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50576 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2CVRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:22:30 -0400
Message-ID: <4F6B5FD1.4040702@wwwdotorg.org>
Date: Thu, 22 Mar 2012 11:22:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "sjg@chromium.org" <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 6/6] pinctrl: tegra: Add complete device tree support
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org> <1332265479-1260-6-git-send-email-swarren@wwwdotorg.org> <20120321093504.GA12118@shlinux2.ap.freescale.net> <4F69FCBF.3050708@wwwdotorg.org> <20120322040730.GC840@shlinux2.ap.freescale.net>
In-Reply-To: <20120322040730.GC840@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 10:07 PM, Dong Aisheng wrote:
> On Thu, Mar 22, 2012 at 12:07:27AM +0800, Stephen Warren wrote:
>> On 03/21/2012 03:35 AM, Dong Aisheng wrote:
>>> On Wed, Mar 21, 2012 at 01:44:39AM +0800, Stephen Warren wrote:
>>>> Implement pinctrl_ops dt_node_to_map() and dt_free_map(). These allow
>>>> complete specification of the desired pinmux configuration using device
>>>> tree.
...
>>>> +	for_each_child_of_node(np_config, np) {
>>>> +		ret = of_property_read_string(np, "nvidia,function", &function);
>>>> +		if (ret < 0)
>>>> +			function = NULL;
>>>> +
>>>> +		for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
>>>> +			ret = of_property_read_u32(np, cfg_params[i].property,
>>>> +						   &val);
>>>> +			if (!ret) {
>>>> +				config = TEGRA_PINCONF_PACK(
>>>> +						cfg_params[i].param, val);
>>>> +				ret = add_config(&configs, &num_configs,
>>>> +						 config);
>>>> +				if (ret < 0)
>>>> +					goto error;
>>>> +			}
>>>> +		}
>>>> +
>>>> +		of_property_for_each_string(np, "nvidia,pins", prop, group) {
>>>
>>> If we calculate out the strings count and allocate corresponding size array, we may not
>>> need to keep krealloc the maps and configs array size for each entry.
>>> And this may be a little higher efficient.
>>
>> That's true. However, it'd require the code to loop once to determine
>> how many properties are present and how many entries there are in the
>> pin list. Then, loop again to actually construct the mapping table
>> array. This is all added complexity that doesn't affect correctness. I'd
>> rather get the simple code going first, and then refine it later if
>> there turns out to be a performance issue.
>>
> Can we use of_property_count_strings?

It'd be possible to avoid some of the reallocs this way. We could
realloc once per node rather than once per (node, pin). It does make the
code a bit more complex though, since you have to reserve space up-front
during the one realloc and so have to store separate num_maps and
num_maps_allocated. I'll see how bad it gets, and maybe include it in v3
if it isn't horrible.
