Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2CUHUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:20:08 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:12018
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab2CUHUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:20:05 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 21 Mar 2012 15:31:17 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
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
Message-ID: <20120321073116.GE3191@shlinux2.ap.freescale.net>
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
 <1332265479-1260-3-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1332265479-1260-3-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 01:44:36AM +0800, Stephen Warren wrote:
> During pinctrl_get(), if the client device has a device tree node, look
> for the common pinctrl properties there. If found, parse the referenced
> device tree nodes, with the help of the pinctrl drivers, and generate
> mapping table entries from them.
> 
> During pinctrl_put(), free any results of device tree parsing.
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> v2: Place most code into new file devicetree.c
Much clearer.:)

> + * struct pinctrl_dt_map - mapping table chunk parsed from device tree
> + * @node: list node for struct pinctrl's @dt_maps field
> + * @pctldev: the pin controller that allocated this struct, and will free it
> + * @maps: the mapping table entries
> + */
> +struct pinctrl_dt_map {
> +	struct list_head node;
> +	struct pinctrl_dev *pctldev;
> +	struct pinctrl_map *map;
> +	unsigned num_maps;
> +};
> +
> +static void dt_free_map(struct pinctrl_dev *pctldev,
> +		     struct pinctrl_map *map, unsigned num_maps)
> +{
> +	if (pctldev) {
> +		struct pinctrl_ops *ops = pctldev->desc->pctlops;
> +		ops->dt_free_map(pctldev, map, num_maps);
> +	} else {
I remember for hog on functions the pctldev becomes pinctrl devices itself,
so in which case pctldev can be NULL?

> +static struct pinctrl_dev *find_pinctrl_by_of_node(struct device_node *np)
> +{
> +	struct pinctrl_dev *pctldev;
> +
> +	list_for_each_entry(pctldev, &pinctrldev_list, node)
> +		if (pctldev->dev->of_node == np)
> +			return pctldev;
> +
> +	return NULL;
> +}
> +
> +static int dt_to_map_one_config(struct pinctrl *p, const char *statename,
> +				struct device_node *np_config)
> +{
> +	struct device_node *np_pctldev;
> +	struct pinctrl_dev *pctldev;
> +	struct pinctrl_ops *ops;
> +	int ret;
> +	struct pinctrl_map *map;
> +	unsigned num_maps;
> +
> +	/* Find the pin controller containing np_config */
> +	np_pctldev = of_node_get(np_config);
It seems the np_config node is already got when call of_find_node_by_phandle.
So do we still need this line?

> +int pinctrl_dt_to_map(struct pinctrl *p)
> +{
> +	struct device_node *np = p->dev->of_node;
> +	int state, ret;
> +	char *propname;
> +	struct property *prop;
> +	const char *statename;
> +	const __be32 *list;
> +	int size, config;
> +	phandle phandle;
> +	struct device_node *np_config;
> +	struct pinctrl_dt_map *dt_map;
> +
Add NULL np checking?

> +	/* We may store pointers to property names within the node */
> +	of_node_get(np);
> +
> +	/* For each defined state ID */
> +	for (state = 0; ; state++) {
> +		/* Retrieve the pinctrl-* property */
> +		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
> +		prop = of_find_property(np, propname, &size);
> +		kfree(propname);
> +		if (!prop)
> +			break;
> +		list = prop->value;
> +		size /= sizeof(*list);
> +
> +		/* Determine whether pinctrl-names property names the state */
> +		ret = of_property_read_string_index(np, "pinctrl-names",
> +						    state, &statename);
> +		/*
> +		 * If not, statename is just the integer state ID. But rather
> +		 * than dynamically allocate it and have to free it later,
> +		 * just point part way into the property name for the string.
> +		 */
> +		if (ret < 0) {
> +			/* strlen("pinctrl-") == 8 */
> +			if (strlen(prop->name) < 8) {
Do we really need this extra checking?
It seems the prop->name is the "pinctrl-%d" you searched above, so the
strlen(prop->name) must not < 8, right?

> +				dev_err(p->dev, "prop %s inconsistent length\n",
> +					prop->name);
> +				ret = -EINVAL;
> +				goto err;
> +			}
> +			statename = prop->name + 8;
>From this code, it seems actually we provide user the option by chance to define
state as pinctrl-syspend which is out of our binding doc.

> +		}
> +
> +		/* For every referenced pin configuration node in it */
> +		for (config = 0; config < size; config++) {
> +			phandle = be32_to_cpup(list++);
> +
> +			/* Look up the pin configuration node */
> +			np_config = of_find_node_by_phandle(phandle);
One option is using of_parse_phandle, then we do not need calculate
the phandle offset by ourselves.
Like:
np_config = of_parse_phandle(propname , config);

> +			if (!np_config) {
> +				dev_err(p->dev,
> +					"prop %s index %i invalid phandle\n",
> +					prop->name, config);
> +				ret = -EINVAL;
> +				goto err;
> +			}
> +
> +			/* Parse the node */
> +			ret = dt_to_map_one_config(p, statename, np_config);
> +			of_node_put(np_config);
> +			if (ret < 0)
> +				goto err;
> +		}
> +
> +		/* No entries in DT? Generate a dummy state table entry */
> +		if (!size) {
> +			ret = dt_remember_dummy_state(p, statename);
> +			if (ret < 0)
> +				goto err;
> +		}
> +	}
> +
> +	list_for_each_entry(dt_map, &p->dt_maps, node) {
> +		ret = pinctrl_register_map(dt_map->map, dt_map->num_maps,
> +					   false, true);
> +		if (ret < 0)
> +			goto err;
> +	}
What's main purpose of differing the map registration and introduce a
intermediate pinctrl_dt_map(dt_remember_or_free_map)?
What about directly register maps once it's parsed?

Regards
Dong Aisheng

