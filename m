Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2J2Rka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:40:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36938 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2J2Rk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:40:26 -0400
Message-ID: <508EBF87.5080707@wwwdotorg.org>
Date: Mon, 29 Oct 2012 11:40:23 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Danny Huang <dahuang@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: Add speedo-based process identification
References: <1351495315-3282-1-git-send-email-dahuang@nvidia.com> <1351495315-3282-2-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1351495315-3282-2-git-send-email-dahuang@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 01:21 AM, Danny Huang wrote:
> Detect CPU and core process ID by checking speedo corner tables.
> This can provide a more accurate process ID.

> diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c

> @@ -114,6 +109,8 @@ void tegra_init_fuse(void)
>  
>  	tegra_revision = tegra_get_revision(id);
>  
> +	tegra20_init_speedo_data();

This code executes on both Tegra20 and Tegra30. Calling a
Tegra20-specific function unconditionally isn't correct. This is
important because if someone does "git bisect" across this patch, patch
1 might be applied, but patch 2 not.

I think you need to add the switch statement from patch 2 here rather
than later in patch 2. Also, I think you need to keep the following
chunk of code in the Tegra30 case, and only remove it completely in patch 2

-	reg = tegra_fuse_readl(FUSE_SPARE_BIT);
-	tegra_cpu_process_id = (reg >> 6) & 3;
-
-	reg = tegra_fuse_readl(FUSE_SPARE_BIT);
-	tegra_core_process_id = (reg >> 12) & 3;

> diff --git a/arch/arm/mach-tegra/tegra20_speedo.c b/arch/arm/mach-tegra/tegra20_speedo.c

> +static const u32 cpu_process_speedos[][PROCESS_CORNERS_NUM] = {
> +	{315, 366, 420, UINT_MAX},
> +	{303, 368, 419, UINT_MAX},
> +	{316, 331, 383, UINT_MAX},
> +};
> +
> +static const u32 core_process_speedos[][PROCESS_CORNERS_NUM] = {
> +	{165, 195, 224, UINT_MAX},
> +	{165, 195, 224, UINT_MAX},
> +	{165, 195, 224, UINT_MAX},
> +};
> +
> +void tegra20_init_speedo_data(void)
> +{
> +	u32 reg;
> +	u32 val;
> +	int i;
> +
> +	if (SPEEDO_ID_SELECT_0(tegra_revision))
> +		tegra_soc_speedo_id = 0;
> +	else if (SPEEDO_ID_SELECT_1(tegra_sku_id))
> +		tegra_soc_speedo_id = 1;
> +	else
> +		tegra_soc_speedo_id = 2;
> +
> +	WARN_ON(tegra_soc_speedo_id >= ARRAY_SIZE(cpu_process_speedos));
> +	WARN_ON(tegra_soc_speedo_id >= ARRAY_SIZE(core_process_speedos));

Can this be a BUILD_BUG_ON() instead;

#define SPEEDO_ID_0 0
#define SPEEDO_ID_1 1
#define SPEEDO_ID_2 2
#define SPEEDO_ID_COUNT (SPEEDO_ID_2 + 1)
BUILD_BUG_ON(ARRAY_SIZE(cpu_process_speedos) == SPEEDO_ID_COUNT)
BUILD_BUG_ON(ARRAY_SIZE(core_process_speedos) == SPEEDO_ID_COUNT)

and use those #defines in the assignments to tegra_soc_speedod_id above,
rather than literals?

Or even just the following without the BUILD_BUG_ONs:

> static const u32 core_process_speedos[SPEEDO_ID_COUNT][PROCESS_CORNERS_NUM] = {

> +	val = 0;
> +	for (i = CPU_SPEEDO_MSBIT; i >= CPU_SPEEDO_LSBIT; i--) {
> +		reg = tegra_spare_fuse(i) |
> +			tegra_spare_fuse(i + CPU_SPEEDO_REDUND_OFFS);
> +		val = (val << 1) | (reg & 0x1);

Out of curiosity, why did the prototype of tegra_spare_fuse() change
from returning a bool to an int, if only bit 0 is going to be used?
