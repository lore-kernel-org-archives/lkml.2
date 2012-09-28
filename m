Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab2I1OSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:18:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34161 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab2I1OSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:18:07 -0400
Date: Fri, 28 Sep 2012 10:17:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/16] iommu/amd: Split device table initialization into
 irq and dma part
Message-ID: <20120928141752.GD7483@localhost.localdomain>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-6-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348835046-3262-6-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:23:55PM +0200, Joerg Roedel wrote:
> When the IOMMU is enabled very early (as with irq-remapping)
> some devices are still in BIOS hand. When dma is blocked
> early this can cause lots of IO_PAGE_FAULTs. So delay the
> DMA initialization and do it right before the dma_ops are
> initialized.
> To be secure, block all interrupts by default when irq-remapping is

What are you trying to be secure against?

> enabled in the system. They will be reenabled on demand
> later.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/amd_iommu_init.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 3f0b68f..8e9d71c 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1378,7 +1378,7 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
>   * Init the device table to not allow DMA access for devices and
>   * suppress all page faults
>   */
> -static void init_device_table(void)
> +static void init_device_table_dma(void)
>  {
>  	u32 devid;
>  
> @@ -1388,6 +1388,17 @@ static void init_device_table(void)
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
> @@ -1778,8 +1789,14 @@ static bool detect_ivrs(void)
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
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
