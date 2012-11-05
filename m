Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab2KEWKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:10:53 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:38310
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933111Ab2KEWKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:10:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Id799hzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
Message-ID: <50983966.4080805@freescale.com>
Date: Mon, 5 Nov 2012 16:10:46 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Firefox/16.0 SeaMonkey/2.13.1
MIME-Version: 1.0
To: Varun Sethi <Varun.Sethi@freescale.com>
CC: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>
Subject: Re: [PATCH 3/4 v4] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
References: <1352114361-25192-1-git-send-email-Varun.Sethi@freescale.com> <1352114361-25192-2-git-send-email-Varun.Sethi@freescale.com> <1352114361-25192-3-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1352114361-25192-3-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Varun Sethi wrote:
> Added the following domain attributes required by FSL PAMU driver:
> 1. Subwindows field added to the iommu domain geometry attribute.
> 2. Added new iommu stash attribute, which allows setting of the
>    LIODN specific stash id parameter through IOMMU API.
> 3. Added an attribute for enabling/disabling DMA to a particular
>    memory window.
> 
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
> changes in v4:
> - Updated comment explaining subwindows(as mentioned by Scott).
> change in v3:
> -renamed the stash attribute targets
>  include/linux/iommu.h |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index f3b99e1..e72f5e5 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -44,6 +44,34 @@ struct iommu_domain_geometry {
>  	dma_addr_t aperture_start; /* First address that can be mapped    */
>  	dma_addr_t aperture_end;   /* Last address that can be mapped     */
>  	bool force_aperture;       /* DMA only allowed in mappable range? */
> +
> +	/**

/** is used by kerneldoc to indicate a kerneldoc-style comment.  Normal
comments should start with just "/*".

> +	 * There could be a single contiguous window tha maps the entire
> +	 * geometry or it could be split in to multiple subwindows.
> +	 * Subwindows allow for supporting physically discontiguous mappings.
> +	 * This attribute indicates number of DMA subwindows supported by
> +	 * the geometry. If there is a single window that maps the entire
> +	 * geometry, attribute must be set to "1". A value of "0" implies
> +	 * that there are 256 subwindows each of size 4K. Value other than
> +	 * "0" or "1" indicates the actual number of subwindows.
> +	 */
> +	u32 subwindows;

Why is this a sized integer?

> +};
> +
> +/* cache stash targets */
> +#define IOMMU_ATTR_CACHE_L1 1
> +#define IOMMU_ATTR_CACHE_L2 2
> +#define IOMMU_ATTR_CACHE_L3 3

This seems kinda silly.  The value of the enum is in the enum name.

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
>  };
>  
>  struct iommu_domain {
> @@ -60,6 +88,14 @@ struct iommu_domain {
>  enum iommu_attr {
>  	DOMAIN_ATTR_MAX,
>  	DOMAIN_ATTR_GEOMETRY,
> +	/* Set the IOMMU hardware stashing
> +	 * parameters.
> +	 */
> +	DOMAIN_ATTR_STASH,
> +	/* Explicity enable/disable DMA for a
> +         * particular memory window.
> +         */
> +	DOMAIN_ATTR_ENABLE,
>  };
>  
>  #ifdef CONFIG_IOMMU_API
> 


-- 
Timur Tabi
Linux kernel developer at Freescale

