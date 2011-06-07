Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1FGJWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:22:35 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:39529 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1FGJWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:22:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 1/6] omap: iommu: generic iommu api migration
Date: Tue, 7 Jun 2011 11:22:47 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-gentoo-r3; KDE/4.6.2; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, arnd@arndb.de, davidb@codeaurora.org,
        Joerg.Roedel@amd.com
References: <1307053663-24572-1-git-send-email-ohad@wizery.com> <1307053663-24572-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1307053663-24572-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106071122.47804.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Thanks for the patch.

On Friday 03 June 2011 00:27:38 Ohad Ben-Cohen wrote:
> Migrate OMAP's iommu to the generic iommu api, so users can stay
> generic, and non-omap-specific code can be removed and eventually
> consolidated into a generic framework.
> 
> Tested on both OMAP3 and OMAP4.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

[snip]

> diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
> index 34fc31e..f06e99c 100644
> --- a/arch/arm/plat-omap/iommu.c
> +++ b/arch/arm/plat-omap/iommu.c

[snip]

> +static int omap_iommu_domain_init(struct iommu_domain *domain)
> +{
> +	struct omap_iommu_domain *omap_domain;
> +
> +	omap_domain = kzalloc(sizeof(*omap_domain), GFP_KERNEL);
> +	if (!omap_domain) {
> +		pr_err("kzalloc failed\n");
> +		goto fail_nomem;
> +	}
> +
> +	omap_domain->pgtable = (u32 *)__get_free_pages(GFP_KERNEL,
> +					get_order(IOPGD_TABLE_SIZE));
> +	if (!omap_domain->pgtable) {
> +		pr_err("__get_free_pages failed\n");
> +		goto fail_nomem;
> +	}
> +
> +	BUG_ON(!IS_ALIGNED((long)omap_domain->pgtable, IOPGD_TABLE_SIZE));

Either __get_free_pages() guarantees that the allocated memory will be aligned 
on an IOPGD_TABLE_SIZE boundary, in which case the BUG_ON() is unnecessary, or 
doesn't offer such guarantee, in which case the BUG_ON() will oops randomly. 
In both cases BUG_ON() should probably be avoided.

> +	memset(omap_domain->pgtable, 0, IOPGD_TABLE_SIZE);
> +	clean_dcache_area(omap_domain->pgtable, IOPGD_TABLE_SIZE);
> +	mutex_init(&omap_domain->lock);
> +
> +	domain->priv = omap_domain;
> +
> +	return 0;
> +
> +fail_nomem:
> +	kfree(omap_domain);
> +	return -ENOMEM;
> +}
> +
> +/* assume device was already detached */
> +static void omap_iommu_domain_destroy(struct iommu_domain *domain)
> +{
> +	struct omap_iommu_domain *omap_domain = domain->priv;
> +
> +	domain->priv = NULL;
> +
> +	kfree(omap_domain);

This leaks omap_domain->pgtable.

The free_pages() call in omap_iommu_remove() should be removed, as 
omap_iommu_probe() doesn't allocate the pages table anymore. You can also 
remove the the struct iommu::iopgd field.

> +}


> +
> +static phys_addr_t omap_iommu_iova_to_phys(struct iommu_domain *domain,
> +					  unsigned long da)
> +{
> +	struct omap_iommu_domain *omap_domain = domain->priv;
> +	struct iommu *oiommu = omap_domain->iommu_dev;
> +	struct device *dev = oiommu->dev;
> +	u32 *pgd, *pte;
> +	phys_addr_t ret = 0;
> +
> +	iopgtable_lookup_entry(oiommu, da, &pgd, &pte);
> +
> +	if (pte) {
> +		if (iopte_is_small(*pte))
> +			ret = omap_iommu_translate(*pte, da, IOPTE_MASK);
> +		else if (iopte_is_large(*pte))
> +			ret = omap_iommu_translate(*pte, da, IOLARGE_MASK);
> +		else
> +			dev_err(dev, "bogus pte 0x%x", *pte);
> +	} else {
> +		if (iopgd_is_section(*pgd))
> +			ret = omap_iommu_translate(*pgd, da, IOSECTION_MASK);
> +		else if (iopgd_is_super(*pgd))
> +			ret = omap_iommu_translate(*pgd, da, IOSUPER_MASK);
> +		else
> +			dev_err(dev, "bogus pgd 0x%x", *pgd);
> +	}
> +
> +	return ret;

You return 0 in the bogus pte/pgd cases. Is that intentional ?

> +}

-- 
Regards,

Laurent Pinchart
