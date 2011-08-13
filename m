Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab1HMKnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 06:43:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63544 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1HMKnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 06:43:33 -0400
Date: Sat, 13 Aug 2011 11:43:23 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 10/12] arm/tegra: Add device tree support to pinmux
 driver
Message-ID: <20110813104323.GC2643@pulham.picochip.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
 <1313189697-21287-11-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313189697-21287-11-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Aug 12, 2011 at 04:54:55PM -0600, Stephen Warren wrote:
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/mach-tegra/pinmux.c |  115 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 115 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/pinmux.c b/arch/arm/mach-tegra/pinmux.c
> index 05fa1a3..33246c2 100644
> --- a/arch/arm/mach-tegra/pinmux.c
> +++ b/arch/arm/mach-tegra/pinmux.c
> @@ -20,6 +20,7 @@
>  #include <linux/errno.h>
>  #include <linux/spinlock.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  
>  #include <mach/iomap.h>
> @@ -147,6 +148,41 @@ static const char *func_name(enum tegra_mux_func func)
>  	return tegra_mux_names[func];
>  }
>  
> +#ifdef CONFIG_OF
> +static int func_enum(const char *name, enum tegra_mux_func *func_out)
> +{
> +	int func;
> +
> +	if (!strcmp(name, "RSVD1")) {
> +		*func_out = TEGRA_MUX_RSVD1;
> +		return 0;
> +	}
> +	if (!strcmp(name, "RSVD2")) {
> +		*func_out = TEGRA_MUX_RSVD2;
> +		return 0;
> +	}
> +	if (!strcmp(name, "RSVD3")) {
> +		*func_out = TEGRA_MUX_RSVD3;
> +		return 0;
> +	}
> +	if (!strcmp(name, "RSVD4")) {
> +		*func_out = TEGRA_MUX_RSVD4;
> +		return 0;
> +	}
> +	if (!strcmp(name, "NONE")) {
> +		*func_out = TEGRA_MUX_NONE;
> +		return 0;
> +	}
> +
> +	for (func = 0; func < TEGRA_MAX_MUX; func++)
> +		if (!strcmp(name, tegra_mux_names[func])) {
> +			*func_out = func;
> +			return 0;
> +		}
> +
> +	return -EINVAL;
> +}
> +#endif
>  
>  static const char *tri_name(unsigned long val)
>  {
> @@ -666,15 +702,94 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
>  	}
>  }
>  
> +#ifdef CONFIG_OF
> +static void __init tegra_pinmux_probe_dt(struct platform_device *pdev)
> +{
> +	int pg;
> +
> +	for (pg = 0; pg < TEGRA_MAX_PINGROUP; pg++) {
> +		const char *pg_name = pingroup_name(pg);
> +		struct tegra_pingroup_config config;
> +		struct device_node *pg_node;
> +		int ret;
> +		const char *s;
> +
> +		pg_node = of_find_child_node_by_name(pdev->dev.of_node,
> +						     pg_name);
> +		if (pg_node == NULL)
> +			continue;

Rather than iterating over all of the mux names in the pinmux driver and 
searching for a matching DT node, could you not do it the other way 
round?  So do an for_each_child_of_node() on the pinmux node then find 
the matching pingroup keyed by the node name?  This would eliminate 
of_find_child_node_by_name().  You could also catch invalid 
configurations for non-existent pins this way.

Jamie
