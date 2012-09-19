Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2ISNwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:52:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:36268 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab2ISNwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:52:34 -0400
Subject: Re: [RFC][PATCH 2/3] iommu/fsl: Add iommu domain attributes required by fsl PAMU driver.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1348060632-12997-3-git-send-email-b16395@freescale.com>
Date: Wed, 19 Sep 2012 08:52:27 -0500
Cc: <iommu@lists.linux-foundation.org>, <joerg.roedel@amd.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6B8A3365-C97E-4742-A0DD-D8FD6BA358EB@kernel.crashing.org>
References: <1348060632-12997-1-git-send-email-b16395@freescale.com> <1348060632-12997-3-git-send-email-b16395@freescale.com>
To: "<b16395@freescale.com>" <b16395@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 19, 2012, at 8:17 AM, <b16395@freescale.com> <b16395@freescale.com> wrote:

> From: Varun Sethi <Varun.Sethi@freescale.com>
> 
> Added the following domain attributes required by FSL PAMU driver:
> 1. Subwindows field added to the iommu domain geometry attribute.
> 2. Added new iommu stash attribute, which allows setting of the
>   LIODN specific stash id parameter through IOMMU API.
> 3. Added an attribute for enabling/disabling DMA to a particular
>   memory window.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> include/linux/iommu.h |   30 ++++++++++++++++++++++++++++++
> 1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 7e83370..eaa40c6 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -44,6 +44,28 @@ struct iommu_domain_geometry {
> 	dma_addr_t aperture_start; /* First address that can be mapped    */
> 	dma_addr_t aperture_end;   /* Last address that can be mapped     */
> 	bool force_aperture;       /* DMA only allowed in mappable range? */
> +
> +	/* The subwindows field indicates number of DMA subwindows supported
> +	 * by the geometry. Following is the interpretation of
> +	 * values for this field:
> +	 * 0 : This implies that the supported geometry size is 1 MB
> +         * with each subwindow size being 4KB. Thus number of subwindows
> +	 * being = 1MB/4KB = 256.
> +	 * 1 : Only one DMA window i.e. no subwindows.
> +	 * value other than 0 or 1 would indicate actual number of subwindows.
> +	 */
> +	u32 subwindows;
> +};
> +
> +/* This attribute corresponds to IOMMUs capable of generating
> + * a stash transaction. A stash transaction is typically a
> + * hardware initiated prefetch of data from memory to cache.
> + * This attribute allows configuring stashig specific parameters
> + * in the IOMMU hardware.
> + */
> +struct iommu_stash_attribute {
> +	u32 	cpu;	/* cpu number */
> +	u32 	cache;	/* cache to stash to: L1,L2,L3 */

seems like this should be enum instead of u32 for cache

With enum being something like:

enum iommu_attr_stash_cache {
	IOMMU_ATTR_CACHE_L1,
	IOMMU_ATTR_CACHE_L2,
	IOMMU_ATTR_CACHE_L3,
};

> };
> 
> struct iommu_domain {
> @@ -60,6 +82,14 @@ struct iommu_domain {
> enum iommu_attr {
> 	DOMAIN_ATTR_MAX,
> 	DOMAIN_ATTR_GEOMETRY,
> +	/* Set the IOMMU hardware stashing
> +	 * parameters.
> +	 */
> +	DOMAIN_ATTR_STASH,
> +	/* Explicity enable/disable DMA for a
> +         * particular memory window.
> +         */
> +	DOMAIN_ATTR_ENABLE,
> };
> 
> #ifdef CONFIG_IOMMU_API
> -- 
> 1.7.4.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

