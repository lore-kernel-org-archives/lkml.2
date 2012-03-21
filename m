Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063Ab2CUJX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:23:57 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:31242
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964794Ab2CUJXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:23:55 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 21 Mar 2012 17:35:06 +0800
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
Subject: Re: [PATCH V2 6/6] pinctrl: tegra: Add complete device tree support
Message-ID: <20120321093504.GA12118@shlinux2.ap.freescale.net>
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org>
 <1332265479-1260-6-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1332265479-1260-6-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 01:44:39AM +0800, Stephen Warren wrote:
> Implement pinctrl_ops dt_node_to_map() and dt_free_map(). These allow
> complete specification of the desired pinmux configuration using device
> tree.
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> v2: Rebase on of_property_for_each_string() API changes.
> ---
Nice code and a good example to people.

A small suggestion below:
> +static int add_map_configs(struct pinctrl_map **map, unsigned *num_maps,
> +			   const char *group, unsigned long *configs,
> +			   unsigned num_configs)
> +{
> +	unsigned i = *num_maps;
> +	unsigned long *dup_configs;
> +	int ret;
> +
> +	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
> +			      GFP_KERNEL);
> +	if (!dup_configs)
> +		return -ENOMEM;
> +
> +	ret = add_map(map, num_maps);
> +	if (ret < 0)
> +		return ret;
> +
> +	(*map)[i].type = PIN_MAP_TYPE_CONFIGS_GROUP;
It still does not support PIN_MAP_TYPE_CONFIGS_PIN, right?

> +	for_each_child_of_node(np_config, np) {
> +		ret = of_property_read_string(np, "nvidia,function", &function);
> +		if (ret < 0)
> +			function = NULL;
> +
> +		for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
> +			ret = of_property_read_u32(np, cfg_params[i].property,
> +						   &val);
> +			if (!ret) {
> +				config = TEGRA_PINCONF_PACK(
> +						cfg_params[i].param, val);
> +				ret = add_config(&configs, &num_configs,
> +						 config);
> +				if (ret < 0)
> +					goto error;
> +			}
> +		}
> +
> +		of_property_for_each_string(np, "nvidia,pins", prop, group) {
If we calculate out the strings count and allocate corresponding size array, we may not
need to keep krealloc the maps and configs array size for each entry.
And this may be a little higher efficient.

Regards
Dong Aisheng

