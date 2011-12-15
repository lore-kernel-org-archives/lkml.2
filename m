Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab1LOPKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:10:07 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:33040 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1LOPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:10:06 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Dec 2011 23:19:51 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Mike Turquette <mturquette@ti.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [RFC v2 5/9] dt/clock: Add handling for fixed clocks and a clock
 node setup iterator
Message-ID: <20111215151950.GC2831@S2100-06.ap.freescale.net>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-5-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323727329-4989-5-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Mon, Dec 12, 2011 at 03:02:05PM -0700, Grant Likely wrote:
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/of/clock.c     |   43 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_clk.h |    4 ++++
>  2 files changed, 47 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/clock.c b/drivers/of/clock.c
> index 6519e96..1c189b4 100644
> --- a/drivers/of/clock.c
> +++ b/drivers/of/clock.c
> @@ -3,6 +3,7 @@
>   */
>  
>  #include <linux/clk.h>
> +#include <linux/clkdev.h>
>  #include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/module.h>
> @@ -163,3 +164,45 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
>  
>  	return clk;
>  }
> +
> +/**
> + * of_clk_init() - Scan and init clock providers from the DT
> + * @matches: array of compatible values and init functions for providers.
> + *
> + * This function scans the device tree for matching clock providers and
> + * calls their initialization functions
> + */
> +void __init of_clk_init(const struct of_device_id *matches)
> +{
> +	struct device_node *np;
> +
> +	for_each_matching_node(np, matches) {
> +		const struct of_device_id *match = of_match_node(matches, np);
> +		of_clk_init_cb_t clk_init_cb = match->data;
> +		clk_init_cb(np);
> +	}
> +}
> +
> +static struct clk *of_fixed_clk_get(struct of_phandle_args *a, void *data)
> +{
> +	return data;
> +}
> +
> +/**
> + * of_fixed_clk_setup() - Setup function for simple fixed rate clock
> + */
> +void __init of_fixed_clk_setup(struct device_node *node)
> +{
> +	struct clk *clk;
> +	u32 rate;
> +
> +	if (of_property_read_u32(node, "clock-frequency", &rate))
> +		return;
> +
> +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +	if (!clk)
> +		return;
> +	clk->rate = rate;
> +
> +	of_clk_add_provider(node, of_fixed_clk_get, clk);
> +}

Just take the fixed clk as example, I have a node below as a blob,
which has 3 fixed clks encoded.

ref_clk: ref {
	compatible = "fixed-clock", "basic-clock";
	#clock-cells = <1>;
	clock-frequency = <24000000 32768 0>;
	clock-output-name = "osc",
			    "ckil",
			    "ckih";
};

If this is valid, the of_fixed_clk_setup() should scan the node for
multiple clks, right?

-- 
Regards,
Shawn

