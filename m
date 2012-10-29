Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab2J2R4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:56:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40050 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab2J2R4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:56:00 -0400
Message-ID: <508EC32D.5050302@wwwdotorg.org>
Date: Mon, 29 Oct 2012 11:55:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: tegra: T30 speedo-based identification
References: <1351495315-3282-1-git-send-email-dahuang@nvidia.com> <1351495315-3282-3-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1351495315-3282-3-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 01:21 AM, Danny Huang wrote:
> This patch adds speedo-based identification support for T30.

> diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c

> -#define FUSE_SPARE_BIT		0x200
> +
> +#define TEGRA20_FUSE_SPARE_BIT		0x200
> +#define TEGRA30_FUSE_SPARE_BIT		0x244
> +
> +static int tegra_fuse_spare_bit;

Can all the spare bit rework, and also prototype changes for
tegra_fuse_readl() and tegra_spare_fuse() be pulled out into a separate
patch at the start of the series?

> +int tegra_cpu_speedo_id;

Does Tegra20 not have a separate cpu_speedo_id? Should this variable be
added in patch 1 and appropriately initialized for Tegra20? If it's
Tegra30-specific, or Tegra30-and-later, a comment to that effect would
be useful. Is there a way to ensure that Tegra20-specific code doesn't
use that variable if it's not applicable?

> @@ -107,9 +112,18 @@ void tegra_init_fuse(void)
>  	id = readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
>  	tegra_chip_id = (id >> 8) & 0xff;
>  
> -	tegra_revision = tegra_get_revision(id);
> -
> -	tegra20_init_speedo_data();
> +	switch (tegra_chip_id) {
> +	case TEGRA20:
> +		tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
> +		tegra_revision = tegra_get_revision(id);
> +		tegra20_init_speedo_data();
> +		break;
> +	case TEGRA30:
> +		tegra_fuse_spare_bit = TEGRA30_FUSE_SPARE_BIT;
> +		tegra_revision = tegra_get_revision(id);
> +		tegra30_init_speedo_data();
> +		break;
> +	}

I think there, I'd prefer to see:


switch (tegra_chip_id) {
case TEGRA20:
	tegra_fuse_spare_bit = TEGRA20_FUSE_SPARE_BIT;
	break;
case TEGRA30:
	tegra_fuse_spare_bit = TEGRA30_FUSE_SPARE_BIT;
	break;
}

tegra_revision = tegra_get_revision(id);

switch (tegra_chip_id) {
case TEGRA20:
	tegra20_init_speedo_data();
	break;
case TEGRA30:
	tegra30_init_speedo_data();
	break;
}

... to avoid duplicating the tegra_get_revision() call.

If this ends up needing a lot of separate switch statements in sequence,
you can always put the SoC-specific data into a struct, and do:

struct tegra_fuse_soc_data *sd = ...;
sd->set_spare_fuse_bit();
tegra_revision = tegra_get_revision(id);
sd->init_speedo_data();

although I don't think the complexity requires that yet.

> diff --git a/arch/arm/mach-tegra/tegra30_speedo.c b/arch/arm/mach-tegra/tegra30_speedo.c

(similar comments apply here as for the table/array size checking in
patch 1)

> +static int threshold_index;
> +static int package_id;

Do those need to be globals? Can they simply be passed between the
appropriate functions?

> +static void fuse_speedo_calib(u32 *speedo_g, u32 *speedo_lp)

> +	WARN_ON(!speedo_g || !speedo_lp);

That hardly seems worth checking since this function is called from one
specific place later in this file...

> +static void rev_sku_to_speedo_ids(int rev, int sku)
> +{
> +	switch (rev) {
> +	case TEGRA_REVISION_A01:
> +		tegra_cpu_speedo_id = 0;
> +		tegra_soc_speedo_id = 0;
> +		threshold_index = 0;
> +		break;
> +	case TEGRA_REVISION_A02:
> +	case TEGRA_REVISION_A03:
> +		switch (sku) {
> +		case 0x87:
...
> +			default:
> +				pr_err("Tegra3 Rev-A02: Reserved pkg: %d\n",
> +				       package_id);
> +				BUG();
> +				break;
> +			}
> +			break;

Why BUG() there, but not:

> +		default:
> +			pr_err("Tegra3: Unknown SKU %d\n", sku);
> +			tegra_cpu_speedo_id = 0;
> +			tegra_soc_speedo_id = 0;
> +			threshold_index = 0;
> +			break;
> +		}
> +		break;
> +	default:

... but do here:

> +		BUG();
> +		break;
> +	}
> +}

> +void tegra30_init_speedo_data(void)

> +	for (i = 0; i < CPU_PROCESS_CORNERS_NUM; i++) {
> +		if (cpu_speedo_val <
> +		    cpu_process_speedos[threshold_index][i]) {
> +			break;
> +		}
> +	}
> +	tegra_cpu_process_id = i - 1;
> +
> +	if (tegra_cpu_process_id == -1) {
> +		pr_err("****************************************************");
> +		pr_err("****************************************************");
> +		pr_err("* tegra3_speedo: CPU speedo value %3d out of range *",
> +		       cpu_speedo_val);
> +		pr_err("****************************************************");
> +		pr_err("****************************************************");

Just drop the lines of ***, and the * around the text in the middle
pr_err() too.

> +
> +		tegra_cpu_speedo_id = 1;

Shouldn't that fix the out-of-range tegra_cpu_process_id value?

This and the previous comment apply to the following calculation of
tegra_core_process_id too.
