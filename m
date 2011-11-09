Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1KIJcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:32:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41916 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1KIJcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:32:00 -0500
Date: Wed, 9 Nov 2011 10:31:47 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] dt/arm: versatile add clock parsing
Message-ID: <20111109093147.GZ16886@pengutronix.de>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-9-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320801583-12774-9-git-send-email-grant.likely@secretlab.ca>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:15:20 up 20 days, 15:50, 23 users,  load average: 3.00, 3.02,
 3.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:19:43PM -0700, Grant Likely wrote:
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/boot/dts/versatile-ab.dts     |   37 ++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/versatile-pb.dts     |    2 +
>  arch/arm/mach-versatile/core.c         |   37 +------------------------------
>  arch/arm/mach-versatile/versatile_dt.c |   33 ++++++++++++++++++++++++++++
>  4 files changed, 74 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
> index 0b32925..cb8a49e 100644
> --- a/arch/arm/boot/dts/versatile-ab.dts
> +++ b/arch/arm/boot/dts/versatile-ab.dts
> @@ -19,6 +19,35 @@
>  		reg = <0x0 0x08000000>;
>  	};
>  
> +	clocks {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		ref24_clk: clock0 {
> +			compatible = "fixed-clock";
> +			#clock-cells = <1>;
> +			clock-frequency = <24000000>;
> +			clock-output-names = "ref";
> +		};
> +
> +		sp804_clk: clock1 {
> +			compatible = "fixed-clock";
> +			#clock-cells = <1>;
> +			clock-frequency = <1000000>;
> +			clock-output-names = "ref";
> +		};
> +
> +		osc4_clk: clock3 {
> +			compatible = "ics,icst307";
> +			#clock-cells = <1>;
> +			ref = <24000>;
> +			vco-max = <200000>;
> +			vd-range = <12 519>;
> +			rd-range = <3 129>;
> +			clock-output-names = "osc4";
> +		};

The registers needed to access osc4 are missing here. This probably
means that osc4 cannot be specified in the clocks node but has to
be sorted into the bus structure of the SoC.

> +
>  static void __init versatile_dt_init(void)
>  {
> +	struct device_node *node;
> +	struct clk *clk;
> +	int rc;
> +
> +	for_each_compatible_node(node, NULL, "fixed-clock") {
> +		u32 rate;
> +		if (of_property_read_u32(node, "clock-frequency", &rate))
> +			continue;
> +
> +		clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +		if (!clk)
> +			panic("out of memory\n");
> +		clk->rate = rate;
> +
> +		rc = of_clk_add_provider(node, versatile_dt_clk_get, clk);
> +		if (rc) {
> +			kfree(clk);
> +			pr_err("error adding fixed clk %s\n", node->name);
> +		}
> +	}
> +

Well this is obviously just a quick hack to get something working. I
just want to add the note here that Mikes current patches require to
register the clock tree top-down. This may be hard to archieve as the
clocks are somewhere in the devicetree (sorted by bus topology and not
by clock topology). So we either need more thinking in the clock
framework to overcome the top-down registration or more thinking here
in the registration of the clocks.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
