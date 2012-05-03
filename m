Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2ECRs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:48:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32877 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2ECRs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:48:28 -0400
Message-ID: <4FA2C4E9.2080509@wwwdotorg.org>
Date: Thu, 03 May 2012 11:48:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com> <1336061147-10245-3-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1336061147-10245-3-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 10:05 AM, Hiroshi DOYU wrote:
> Use "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
> ready, instead of directly aceessing AHB registers.

You need to make the Kconfig option for the SMMU either depend on or
select the TEGRA_AHB option. If you don't, then if someone disables the
AHB driver, the SMMU driver may still build, yet fail to link since the
AHB API it calls doesn't exist.

> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c

> @@ -398,10 +388,8 @@ static void smmu_setup_regs(struct smmu_device *smmu)
>  
>  	smmu_flush_regs(smmu, 1);
>  
> -	val = ahb_read(smmu, AHB_XBAR_CTRL);
> -	val |= AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
> -		AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
> -	ahb_write(smmu, val, AHB_XBAR_CTRL);
> +	err = tegra_ahb_enable_smmu(smmu->ahb);
> +	return err;

You can just "return tegra_ahb_..." here.

> @@ -911,14 +899,16 @@ static int tegra_smmu_probe(struct platform_device *pdev)

> +	smmu->ahb = of_parse_phandle(pdev->dev.of_node, "ahb", 0);

Hmm, "ahb" should probably be "nvidia,ahb".

I see that neither this patch nor the next patch include binding
documentation that describe this property. Can you please add documentation.
