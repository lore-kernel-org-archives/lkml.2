Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2CWDoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:44:46 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:21666
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327Ab2CWDon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:44:43 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 23 Mar 2012 11:55:49 +0800
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
Subject: Re: [PATCH V3 3/6] pinctrl: core device tree mapping table parsing
 support
Message-ID: <20120323035548.GA23958@shlinux2.ap.freescale.net>
References: <1332440842-1098-1-git-send-email-swarren@wwwdotorg.org>
 <1332440842-1098-3-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1332440842-1098-3-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 02:27:19AM +0800, Stephen Warren wrote:
> During pinctrl_get(), if the client device has a device tree node, look
> for the common pinctrl properties there. If found, parse the referenced
> device tree nodes, with the help of the pinctrl drivers, and generate
> mapping table entries from them.
> 
> During pinctrl_put(), free any results of device tree parsing.
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> v3: Add explit check for devies without dev->of_node. Add comments re:
>     lack of pctldev for PIN_MAP_TYPE_DUMMY_STATE.
> v2: Place most code into new file devicetree.c
> 
> pinctrl core dt fixup
> ---
.......
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
> +	/* CONFIG_OF enabled, p->dev not instantiated from DT */
> +	if (!np)
> +		return 0;
> +
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
You thought this checking is still needed?
prop->name should be exactly what you search above ("pinctrl-%d"), right?

> +				dev_err(p->dev, "prop %s inconsistent length\n",
> +					prop->name);
> +				ret = -EINVAL;
> +				goto err;
> +			}
> +			statename = prop->name + 8;
> +		}
> +
> +		/* For every referenced pin configuration node in it */
> +		for (config = 0; config < size; config++) {
> +			phandle = be32_to_cpup(list++);
> +
> +			/* Look up the pin configuration node */
> +			np_config = of_find_node_by_phandle(phandle);
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
It seems we're still keeping the intermediate pinctrl_dt_map, although
not know the result you found,
but i'm ok we just do it currently.

Regards
Dong Aisheng

