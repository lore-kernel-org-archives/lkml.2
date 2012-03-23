Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2CWEM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:12:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40381 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2CWEM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:12:56 -0400
Message-ID: <4F6BF846.6010109@wwwdotorg.org>
Date: Thu, 22 Mar 2012 22:12:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
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
Subject: Re: [PATCH V3 3/6] pinctrl: core device tree mapping table parsing
 support
References: <1332440842-1098-1-git-send-email-swarren@wwwdotorg.org> <1332440842-1098-3-git-send-email-swarren@wwwdotorg.org> <20120323035548.GA23958@shlinux2.ap.freescale.net>
In-Reply-To: <20120323035548.GA23958@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 09:55 PM, Dong Aisheng wrote:
> On Fri, Mar 23, 2012 at 02:27:19AM +0800, Stephen Warren wrote:
>> During pinctrl_get(), if the client device has a device tree node, look
>> for the common pinctrl properties there. If found, parse the referenced
>> device tree nodes, with the help of the pinctrl drivers, and generate
>> mapping table entries from them.
>>
>> During pinctrl_put(), free any results of device tree parsing.
...
>> +int pinctrl_dt_to_map(struct pinctrl *p)
...
>> +		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
>> +		prop = of_find_property(np, propname, &size);
>> +		kfree(propname);
>> +		if (!prop)
>> +			break;
>> +		list = prop->value;
>> +		size /= sizeof(*list);
>> +
>> +		/* Determine whether pinctrl-names property names the state */
>> +		ret = of_property_read_string_index(np, "pinctrl-names",
>> +						    state, &statename);
>> +		/*
>> +		 * If not, statename is just the integer state ID. But rather
>> +		 * than dynamically allocate it and have to free it later,
>> +		 * just point part way into the property name for the string.
>> +		 */
>> +		if (ret < 0) {
>> +			/* strlen("pinctrl-") == 8 */
>> +			if (strlen(prop->name) < 8) {
> You thought this checking is still needed?
> prop->name should be exactly what you search above ("pinctrl-%d"), right?

Oops. I accidentally blew this away when I dropped the change the change
to replace of_find_node_by_phandle() with of_parse_phandle(). I guess
I'll post V4:-(

>> +				dev_err(p->dev, "prop %s inconsistent length\n",
>> +					prop->name);
>> +				ret = -EINVAL;
>> +				goto err;
>> +			}
>> +			statename = prop->name + 8;
>> +		}
>> +
>> +		/* For every referenced pin configuration node in it */
>> +		for (config = 0; config < size; config++) {
>> +			phandle = be32_to_cpup(list++);
>> +
>> +			/* Look up the pin configuration node */
>> +			np_config = of_find_node_by_phandle(phandle);
>> +			if (!np_config) {
>> +				dev_err(p->dev,
>> +					"prop %s index %i invalid phandle\n",
>> +					prop->name, config);
>> +				ret = -EINVAL;
>> +				goto err;
>> +			}
>> +
>> +			/* Parse the node */
>> +			ret = dt_to_map_one_config(p, statename, np_config);
>> +			of_node_put(np_config);
>> +			if (ret < 0)
>> +				goto err;
>> +		}
>> +
>> +		/* No entries in DT? Generate a dummy state table entry */
>> +		if (!size) {
>> +			ret = dt_remember_dummy_state(p, statename);
>
> It seems we're still keeping the intermediate pinctrl_dt_map, although
> not know the result you found,
> but i'm ok we just do it currently.

Sorry, I'm not sure what the issue is here? We need some struct to
remember all the mapping table chunks that are parsed from DT so that
when pinctrl_put() is executed, they can be freed.
