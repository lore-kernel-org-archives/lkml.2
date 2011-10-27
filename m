Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1J0UG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:06:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7334 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1J0UG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:06:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 27 Oct 2011 13:06:15 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 27 Oct 2011 13:06:13 -0700
Subject: RE: [PATCH 3/6] arm/tegra: prepare early init for multiple tegra
 variants
Thread-Topic: [PATCH 3/6] arm/tegra: prepare early init for multiple tegra
 variants
Thread-Index: AcyTNsLyryXcX00oRkmL38qI1oGXUgBrGlDQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B49B2@HQMAIL01.nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
 <1319561644-6160-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1319561644-6160-4-git-send-email-pdeschrijver@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter De Schrijver wrote at Tuesday, October 25, 2011 10:54 AM:
> This patch splits the early init code in a common and a tegra20 specific part.

> diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c

> +static void __init tegra_init_early(void)
> +{
> +
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(early_init); i++)
> +		if (of_machine_is_compatible(early_init[i].machine))
> +			return early_init[i].init();
> +
> +	printk(KERN_WARNING "Unknown platform detected\n");

pr_warn/WARN/WARN_ON?

> diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c

> @@ -31,8 +31,6 @@
>  #include "clock.h"
>  #include "fuse.h"
> 
> -void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
> -
>  void tegra_assert_system_reset(char mode, const char *cmd)
>  {
>  	void __iomem *reset = IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
> @@ -44,7 +42,9 @@ void tegra_assert_system_reset(char mode, const char *cmd)
>  	writel_relaxed(reg, reset);
>  }
> 
> -static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
> +void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;

I'm not sure why you moved that, but I suppose it's fine.

> +
> +static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
>  	/* name		parent		rate		enabled */
>  	{ "clk_m",	NULL,		0,		true },
>  	{ "pll_p",	"clk_m",	216000000,	true },
> @@ -65,19 +65,25 @@ static void __init tegra_init_cache(void)
>  {
>  #ifdef CONFIG_CACHE_L2X0
>  	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
> +	u32 aux_ctrl;
> 
>  	writel_relaxed(0x331, p + L2X0_TAG_LATENCY_CTRL);
>  	writel_relaxed(0x441, p + L2X0_DATA_LATENCY_CTRL);
> +	writel(2, p + L2X0_PREFETCH_CTRL);
> +
> +	aux_ctrl = readl(p + L2X0_CACHE_TYPE);
> +	aux_ctrl = (aux_ctrl & 0x700) << (17-8);
> +	aux_ctrl |= 0x6C000001;

This is an unrelated change?

> 
>  	l2x0_init(p, 0x6C080001, 0x8200c3fe);
>  #endif
> 
>  }

-- 
nvpublic

