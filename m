Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2CUPs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:48:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53472 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2CUPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:48:27 -0400
Message-ID: <4F69F844.3060102@wwwdotorg.org>
Date: Wed, 21 Mar 2012 09:48:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
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
Subject: Re: [PATCH V2 3/6] pinctrl: core device tree mapping table parsing
 support
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org> <1332265479-1260-3-git-send-email-swarren@wwwdotorg.org> <20120321073116.GE3191@shlinux2.ap.freescale.net>
In-Reply-To: <20120321073116.GE3191@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 01:31 AM, Dong Aisheng wrote:
> On Wed, Mar 21, 2012 at 01:44:36AM +0800, Stephen Warren wrote:
>> During pinctrl_get(), if the client device has a device tree node, look
>> for the common pinctrl properties there. If found, parse the referenced
>> device tree nodes, with the help of the pinctrl drivers, and generate
>> mapping table entries from them.
>>
>> During pinctrl_put(), free any results of device tree parsing.

>> +static void dt_free_map(struct pinctrl_dev *pctldev,
>> +		     struct pinctrl_map *map, unsigned num_maps)
>> +{
>> +	if (pctldev) {
>> +		struct pinctrl_ops *ops = pctldev->desc->pctlops;
>> +		ops->dt_free_map(pctldev, map, num_maps);
>> +	} else {
>
> I remember for hog on functions the pctldev becomes pinctrl devices itself,
> so in which case pctldev can be NULL?

PIN_MAP_TYPE_DUMMY_STATE has no pctldev.

>> +static int dt_to_map_one_config(struct pinctrl *p, const char *statename,
>> +				struct device_node *np_config)
>> +{
>> +	struct device_node *np_pctldev;
>> +	struct pinctrl_dev *pctldev;
>> +	struct pinctrl_ops *ops;
>> +	int ret;
>> +	struct pinctrl_map *map;
>> +	unsigned num_maps;
>> +
>> +	/* Find the pin controller containing np_config */
>> +	np_pctldev = of_node_get(np_config);
>
> It seems the np_config node is already got when call of_find_node_by_phandle.
> So do we still need this line?

Right below that code, we traverse up the tree using
of_get_next_parent(). Internally, this calls of_node_put() on the node
pointer that's passed in. Hence, we need an extra get() to match this.

>> +int pinctrl_dt_to_map(struct pinctrl *p)
>> +{
>> +	struct device_node *np = p->dev->of_node;
>> +	int state, ret;
>> +	char *propname;
>> +	struct property *prop;
>> +	const char *statename;
>> +	const __be32 *list;
>> +	int size, config;
>> +	phandle phandle;
>> +	struct device_node *np_config;
>> +	struct pinctrl_dt_map *dt_map;
>
> Add NULL np checking?

Oops yes. I though I had that somewhere, but evidently not...

>> +	/* We may store pointers to property names within the node */
>> +	of_node_get(np);
>> +
>> +	/* For each defined state ID */
>> +	for (state = 0; ; state++) {
>> +		/* Retrieve the pinctrl-* property */
>> +		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
>> +		prop = of_find_property(np, propname, &size);
...
>> +			/* strlen("pinctrl-") == 8 */
>> +			if (strlen(prop->name) < 8) {
>
> Do we really need this extra checking?
> It seems the prop->name is the "pinctrl-%d" you searched above, so the
> strlen(prop->name) must not < 8, right?

Assuming of_find_property works correctly, I guess that's true. We can
remove that if check.

>> +				dev_err(p->dev, "prop %s inconsistent length\n",
>> +					prop->name);
>> +				ret = -EINVAL;
>> +				goto err;
>> +			}
>> +			statename = prop->name + 8;
>
> From this code, it seems actually we provide user the option by chance to define
> state as pinctrl-syspend which is out of our binding doc.

The user can place a property with name "pinctrl-suspend" into the DT.
However, since we only look for properties named pinctrl-%d, then the
code will never read/use it, just like any other unexpected property.

>> +		}
>> +
>> +		/* For every referenced pin configuration node in it */
>> +		for (config = 0; config < size; config++) {
>> +			phandle = be32_to_cpup(list++);
>> +
>> +			/* Look up the pin configuration node */
>> +			np_config = of_find_node_by_phandle(phandle);
>
> One option is using of_parse_phandle, then we do not need calculate
> the phandle offset by ourselves.
> Like:
> np_config = of_parse_phandle(propname , config);

Yes, that's a good idea. I'll try that.

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
>> +			if (ret < 0)
>> +				goto err;
>> +		}
>> +	}
>> +
>> +	list_for_each_entry(dt_map, &p->dt_maps, node) {
>> +		ret = pinctrl_register_map(dt_map->map, dt_map->num_maps,
>> +					   false, true);
>> +		if (ret < 0)
>> +			goto err;
>> +	}
>
> What's main purpose of differing the map registration and introduce a
> intermediate pinctrl_dt_map(dt_remember_or_free_map)?
> What about directly register maps once it's parsed?

s/differing/deferring/ I assume.

IIRC, this was mainly to simplify error handling; by deferring it, you
don't have to unregister everything when undoing a failed parse.
However, I guess that pinctrl_dt_free_maps() already cleans up
everything anyway, so we couuld just register everything as soon as its
parsed. I'll think a little more about this and switch to doing that if
will work.
