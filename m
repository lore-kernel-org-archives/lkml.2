Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2GFNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:09:56 -0400
Received: from [216.32.181.186] ([216.32.181.186]:28177 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab2GFNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:09:55 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz98dI1432Izz1202hzz15d4R8275bhz2dh668h839h944hd25he5bhf0ah)
X-WSS-ID: 0M6QPUG-01-HHW-02
X-M-MSG: 
Date: Fri, 6 Jul 2012 15:08:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/28] iommu/amd: Split device table initialization into
 irq and dma part
Message-ID: <20120706130838.GD2639@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
 <1341491808-23083-18-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1341491808-23083-18-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 02:36:37PM +0200, Joerg Roedel wrote:
> When the IOMMU is enabled very early (as with irq-remapping)
> some devices are still in BIOS hand. When dma is blocked
> early this can cause lots of IO_PAGE_FAULTs. So delay the
> DMA initialization and do it right before the dma_ops are
> initialized.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Okay, I merged this patch with the previous one after another review.
This patch basically undoes and refactors what the previous patch did.
So it makes sense to do it all in one patch.

> ---
>  drivers/iommu/amd_iommu_init.c |   22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index e663f1d..453f80a 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1383,19 +1383,27 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
>   * Init the device table to not allow DMA access for devices and
>   * suppress all page faults
>   */
> -static void init_device_table(void)
> +static void init_device_table_dma(void)
>  {
>  	u32 devid;
>  
>  	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
>  		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
>  		set_dev_entry_bit(devid, DEV_ENTRY_TRANSLATION);
> -
> -		if (amd_iommu_irq_remap)
> -			set_dev_entry_bit(devid, DEV_ENTRY_IRQ_TBL_EN);
>  	}
>  }
>  
> +static void init_device_table(void)
> +{
> +	u32 devid;
> +
> +	if (!amd_iommu_irq_remap)
> +		return;
> +
> +	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid)
> +		set_dev_entry_bit(devid, DEV_ENTRY_IRQ_TBL_EN);
> +}
> +
>  static void iommu_init_flags(struct amd_iommu *iommu)
>  {
>  	iommu->acpi_flags & IVHD_FLAG_HT_TUN_EN_MASK ?
> @@ -1783,8 +1791,14 @@ static bool detect_ivrs(void)
>  
>  static int amd_iommu_init_dma(void)
>  {
> +	struct amd_iommu *iommu;
>  	int ret;
>  
> +	init_device_table_dma();
> +
> +	for_each_iommu(iommu)
> +		iommu_flush_all_caches(iommu);
> +
>  	if (iommu_pass_through)
>  		ret = amd_iommu_init_passthrough();
>  	else
> -- 
> 1.7.9.5

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

