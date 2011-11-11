Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1KKLp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:45:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44886 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab1KKLpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:45:25 -0500
Date: Fri, 11 Nov 2011 11:45:21 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 04/10] arm/tegra: prepare early init for multiple
 tegra variants
Message-ID: <20111111114521.GB5114@totoro>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
 <1321010541-31337-5-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321010541-31337-5-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Nov 11, 2011 at 01:22:10PM +0200, Peter De Schrijver wrote:
> This patch splits the early init code in a common and a tegra20 specific part.
> L2 cache initialization is generalized and discovers the cache associativity
> at runtime. Also use arm_pm_restart instead of arm_arch_reset and reset the
> the system using the PMC reset feature rather then the CAR system reset.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  arch/arm/mach-tegra/board-dt.c        |   21 ++++++++++++++
>  arch/arm/mach-tegra/board-harmony.c   |    2 +-
>  arch/arm/mach-tegra/board-paz00.c     |    2 +-
>  arch/arm/mach-tegra/board-seaboard.c  |    6 ++--
>  arch/arm/mach-tegra/board-trimslice.c |    2 +-
>  arch/arm/mach-tegra/board.h           |    6 ++--
>  arch/arm/mach-tegra/clock.c           |    5 ---
>  arch/arm/mach-tegra/common.c          |   47 ++++++++++++++++++++++----------
>  8 files changed, 62 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
> index d368f8d..15ee974 100644
> --- a/arch/arm/mach-tegra/board-dt.c
> +++ b/arch/arm/mach-tegra/board-dt.c
> @@ -118,6 +118,27 @@ static void __init tegra_dt_init(void)
>  	of_platform_populate(NULL, tegra_dt_match_table, tegra20_auxdata_lookup, NULL);
>  }
>  
> +static struct {
> +	const char *machine;
> +	void (*init)(void);
> +} early_init[] __initdata = {
> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> +	{ "nvidia,tegra20", tegra20_init_early },
> +#endif
> +};
> +
> +static void __init tegra_init_early(void)
> +{
> +
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(early_init); i++)
> +		if (of_machine_is_compatible(early_init[i].machine))
> +			return early_init[i].init();
> +
> +	pr_warn("Unknown platform detected\n");
> +}

Wouldn't it be better just to have separate machine descs for tegra20 
and tegra30 and have a different .init_early for each?  I'm not sure 
that this extra indirection buys us much, especially if we had to repeat 
it for any of the other entries.

Jamie
