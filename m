Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab2HaO05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:26:57 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:20265
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075Ab2HaO04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:26:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1202hzzz2dh87h2a8h668h839h944hd25hd2bhe96hf0ah107ah1220h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 31 Aug 2012 09:26:29 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <s.hauer@pengutronix.de>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: Re: [PATCH v4 1/7] mfd: add syscon driver based on regmap
Message-ID: <20120831012626.GA7726@r65073-Latitude-D630>
References: <1346237818-9498-1-git-send-email-b29396@freescale.com>
 <1346237818-9498-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346237818-9498-2-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 06:56:52PM +0800, Dong Aisheng wrote:
> +config MFD_SYSCON
> +        bool "System Controller Register R/W Based on Regmap"

If the driver only compiles and works for device tree probe, we should
have the following?

	depends on OF

> +        select REGMAP_MMIO
> +        help
> +	  Select this option to enable accessing system control registers
> +	  via regmap.
> +

<snip>

> +struct regmap *syscon_node_to_regmap(struct device_node *np)
> +{
> +	struct syscon *syscon;
> +	struct device *dev;
> +
> +	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> +				 syscon_match);
> +	of_node_put(np);

This looks a little unnatural to me.  Function syscon_node_to_regmap
becomes an API visible to clients, who might never know that np will
be put inside the API.  I'm saying the client may also call of_node_put
to put the node they get.

I think of_node_put should be moved out from here and put into
syscon_node_to_regmap and syscon_regmap_lookup_by_compatible.

Regards,
Shawn

> +
> +	if (!dev)
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	syscon = dev_get_drvdata(dev);
> +
> +	return syscon->regmap;
> +}
> +EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
> +
> +struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
> +{
> +	struct device_node *syscon_np;
> +
> +	syscon_np = of_find_compatible_node(NULL, NULL, s);
> +	if (!syscon_np)
> +		return ERR_PTR(-ENODEV);
> +
> +	return syscon_node_to_regmap(syscon_np);
> +}
> +EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> +
> +struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
> +					const char *property)
> +{
> +	struct device_node *syscon_np;
> +
> +	syscon_np = of_parse_phandle(np, property, 0);
> +	if (!syscon_np)
> +		return ERR_PTR(-ENODEV);
> +
> +	return syscon_node_to_regmap(syscon_np);
> +}
> +EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);

