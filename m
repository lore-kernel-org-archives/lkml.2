Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2EUNPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:15:37 -0400
Received: from 8bytes.org ([85.214.48.195]:35384 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2EUNPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:15:36 -0400
Date: Mon, 21 May 2012 15:15:32 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 2/2] iommu: Request IOMMU CSR space
Message-ID: <20120521131532.GL2313@8bytes.org>
References: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
 <20120518231837.31187.29401.stgit@bhelgaas.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518231837.31187.29401.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon May 21 15:15:33 2012
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fba3ff528384622650627
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 05:18:37PM -0600, Bjorn Helgaas wrote:
> Request the IOMMU CSR MMIO region to keep anybody else from claiming it
> while we're using it.
> 
> The bug referenced below is a crash that happened when we assigned an
> address in the IOMMU CSR area to a PCI BAR.  This patch just changes
> the IOMMU driver, which only helps when the driver is present, so a
> BIOS change is also necessary.  But the driver should claim the space
> it uses in any event.
> 
> Reference: https://bugzilla.novell.com/show_bug.cgi?id=760440
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Looks good.

Reviewed-by: Joerg Roedel <joro@8bytes.org>

> ---
>  drivers/iommu/dmar.c        |   41 ++++++++++++++++++++++++++++++++---------
>  include/linux/intel-iommu.h |    2 ++
>  2 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 35c1e17..e4ac23a 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -581,6 +581,7 @@ int __init detect_intel_iommu(void)
>  int alloc_iommu(struct dmar_drhd_unit *drhd)
>  {
>  	struct intel_iommu *iommu;
> +	struct resource *res;
>  	int map_size;
>  	u32 ver;
>  	static int iommu_allocated = 0;
> @@ -599,11 +600,20 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
>  	iommu->seq_id = iommu_allocated++;
>  	sprintf (iommu->name, "dmar%d", iommu->seq_id);
>  
> -	iommu->reg = ioremap(drhd->reg_base_addr, VTD_PAGE_SIZE);
> -	if (!iommu->reg) {
> -		printk(KERN_ERR "IOMMU: can't map the region\n");
> +	iommu->reg_base = drhd->reg_base_addr;
> +	iommu->reg_size = VTD_PAGE_SIZE;
> +	res = request_mem_region(iommu->reg_base, iommu->reg_size, iommu->name);
> +	if (!res) {
> +		printk(KERN_ERR "IOMMU: can't request [mem %#010llx-%#010llx]\n",
> +		       iommu->reg_base, iommu->reg_base + iommu->reg_size - 1);
>  		goto error;
>  	}
> +
> +	iommu->reg = ioremap(iommu->reg_base, iommu->reg_size);
> +	if (!iommu->reg) {
> +		printk(KERN_ERR "IOMMU: can't map %pR\n", res);
> +		goto err_release;
> +	}
>  	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
>  	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
>  
> @@ -637,17 +647,26 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
>  	map_size = VTD_PAGE_ALIGN(map_size);
>  	if (map_size > VTD_PAGE_SIZE) {
>  		iounmap(iommu->reg);
> -		iommu->reg = ioremap(drhd->reg_base_addr, map_size);
> +		release_mem_region(iommu->reg_base, iommu->reg_size);
> +		iommu->reg_size = map_size;
> +		res = request_mem_region(iommu->reg_base, iommu->reg_size,
> +					 iommu->name);
> +		if (!res) {
> +			printk(KERN_ERR "IOMMU: can't request [mem %#010llx-%#010llx]\n",
> +				iommu->reg_base,
> +				iommu->reg_base + iommu->reg_size - 1);
> +			goto error;
> +		}
> +		iommu->reg = ioremap(iommu->reg_base, iommu->reg_size);
>  		if (!iommu->reg) {
> -			printk(KERN_ERR "IOMMU: can't map the region\n");
> +			printk(KERN_ERR "IOMMU: can't map %pR\n", res);
>  			goto error;
>  		}
>  	}
>  
>  	ver = readl(iommu->reg + DMAR_VER_REG);
> -	pr_info("IOMMU %d: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
> -		iommu->seq_id,
> -		(unsigned long long)drhd->reg_base_addr,
> +	pr_info("IOMMU %d: %pR ver %d:%d cap %llx ecap %llx\n",
> +		iommu->seq_id, res,
>  		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
>  		(unsigned long long)iommu->cap,
>  		(unsigned long long)iommu->ecap);
> @@ -659,6 +678,8 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
>  
>   err_unmap:
>  	iounmap(iommu->reg);
> + err_release:
> +	release_mem_region(iommu->reg_base, iommu->reg_size);
>   error:
>  	kfree(iommu);
>  	return -1;
> @@ -671,8 +692,10 @@ void free_iommu(struct intel_iommu *iommu)
>  
>  	free_dmar_iommu(iommu);
>  
> -	if (iommu->reg)
> +	if (iommu->reg) {
>  		iounmap(iommu->reg);
> +		release_mem_region(iommu->reg_base, iommu->reg_size);
> +	}
>  	kfree(iommu);
>  }
>  
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index e6ca56d..911ded0 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -308,6 +308,8 @@ enum {
>  
>  struct intel_iommu {
>  	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
> +	phys_addr_t	reg_base;
> +	resource_size_t reg_size;
>  	u64		cap;
>  	u64		ecap;
>  	u32		gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

