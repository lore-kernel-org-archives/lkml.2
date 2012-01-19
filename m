Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab2ASRQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 12:16:53 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:33395
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227Ab2ASRQw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 12:16:52 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz9371I542M1432Nzz1202hzz8275bh8275dhz2dhc1bhc31hc1ah2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Topic: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Thread-Index: AQHM1rbj1rZDtR84OEuq1/Qi58+pfJYT5nig
Date: Thu, 19 Jan 2012 17:16:48 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D038749@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
 <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1326983405-319-3-git-send-email-joerg.roedel@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.176.1.240]
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
> Sent: Thursday, January 19, 2012 8:00 PM
> To: iommu@lists.linux-foundation.org
> Cc: Ohad Ben-Cohen; Tony Lindgren; Hiroshi DOYU; linux-
> kernel@vger.kernel.org; Laurent Pinchart; Wood Scott-B07421; David Brown;
> David Woodhouse
> Subject: [PATCH 2/5] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
> 
> Implement the attribute itself and add the code for the AMD IOMMU driver.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/amd_iommu.c |    4 ++++
>  drivers/iommu/iommu.c     |   19 ++++++++++++++++---
>  include/linux/iommu.h     |   11 ++++++++++-
>  3 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c index
> cce1f03..421c3e6 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -3030,6 +3030,10 @@ static int amd_iommu_domain_init(struct
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
> ef54718..3d0b0bf 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -345,10 +345,23 @@ EXPORT_SYMBOL_GPL(iommu_device_group);
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
> 32d0de1..3f971b3 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -37,16 +37,24 @@ struct iommu_domain;  typedef int
> (*iommu_fault_handler_t)(struct iommu_domain *,
>  				struct device *, unsigned long, int);
> 
> +struct iommu_domain_geometry {
> +	u64 aperture_start;	/* First address that can be mapped    */
> +	u64 aperture_end;	/* Last address that can be mapped     */
> +	bool force_aperture;	/* DMA only allowed in mappable range? */
> +};
> +
>  struct iommu_domain {
>  	struct iommu_ops *ops;
>  	void *priv;
>  	iommu_fault_handler_t handler;
> +	struct iommu_domain_geometry geometry;
>  };
In case of our iommu implementation the iommu_domain_geometry would include additional attributes. Why can't we let the geometry be
Implementation dependent?

-Varun

