Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2GKLsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:48:09 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:10811
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab2GKLsH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:48:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz9371I542M1432Izz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/7] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Topic: [PATCH 2/7] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Index: AQHNX1Lf1mZ3xwjNGEGZYEQuF0W4P5cj6ygQ
Date: Wed, 11 Jul 2012 11:47:39 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D13AA64@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
 <1342003763-8139-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1342003763-8139-3-git-send-email-joerg.roedel@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Joerg Roedel
> Sent: Wednesday, July 11, 2012 4:19 PM
> To: iommu@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH 2/7] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
> 
> Implement the attribute itself and add the code for the AMD IOMMU driver.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/amd_iommu.c |    4 ++++
>  drivers/iommu/iommu.c     |   19 ++++++++++++++++---
>  include/linux/iommu.h     |    8 ++++++++
>  3 files changed, 28 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c index
> a2e418c..259a6be 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -3069,6 +3069,10 @@ static int amd_iommu_domain_init(struct
> iommu_domain *dom)
> 
>  	dom->priv = domain;
> 
> +	dom->geometry.aperture_start = 0;
> +	dom->geometry.aperture_end   = ~0ULL;
> +	dom->geometry.force_aperture = true;
> +
>  	return 0;
> 
>  out_free:
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c index
> c39972d..ed5e0a5 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -348,10 +348,23 @@ EXPORT_SYMBOL_GPL(iommu_device_group);
>  int iommu_domain_get_attr(struct iommu_domain *domain,
>  			  enum iommu_attr attr, void *data)
>  {
> -	if (!domain->ops->domain_get_attr)
> -		return -EINVAL;
> +	struct iommu_domain_geometry *geometry;
> +	int ret = 0;
> +
> +	switch (attr) {
> +	case DOMAIN_ATTR_GEOMETRY:
> +		geometry  = data;
> +		*geometry = domain->geometry;
> +
> +		break;
> +	default:
> +		if (!domain->ops->domain_get_attr)
> +			return -EINVAL;
> 
> -	return domain->ops->domain_get_attr(domain, attr, data);
> +		ret = domain->ops->domain_get_attr(domain, attr, data);
> +	}
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_domain_get_attr);
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> 0eef096..f7df4aa 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -37,11 +37,18 @@ struct iommu_domain;  typedef int
> (*iommu_fault_handler_t)(struct iommu_domain *,
>  			struct device *, unsigned long, int, void *);
> 
> +struct iommu_domain_geometry {
> +	dma_addr_t aperture_start; /* First address that can be mapped
> */
> +	dma_addr_t aperture_end;   /* Last address that can be mapped
> */
> +	bool force_aperture;       /* DMA only allowed in mappable range?
> */
> +};
> +
>  struct iommu_domain {
>  	struct iommu_ops *ops;
>  	void *priv;
>  	iommu_fault_handler_t handler;
>  	void *handler_token;
> +	struct iommu_domain_geometry geometry;
>  };
> 
Hi Joerg,
I am currently working on upstreaming the Freescale IOMMU driver. As discussed (with Scott Wood)
a while back, this representation of the GEOMETRY attribute doesn't go well with our IOMMU
implementation. Our representation of the geometry would be more complex and is certainly modifiable.
Our IOMMU allows for creating custom DMA mappings by defining a set of DMA sub windows within
a given window. We need a mechanism for specifying the number of DMA subwindows as a part of the 
domain geometry. My suggestion would be to make the GEOMETRY attribute implementation dependent

Regards
Varun


