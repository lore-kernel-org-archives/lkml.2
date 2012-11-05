Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2KEX4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:56:16 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:21453 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab2KEX4P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:56:15 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h1155h)
Date: Mon, 5 Nov 2012 17:56:07 -0600
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 3/4 v4] iommu/fsl: Add iommu domain attributes required
 by fsl PAMU driver.
To: Varun Sethi <Varun.Sethi@freescale.com>
CC: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <timur@freescale.com>, Varun Sethi <Varun.Sethi@freescale.com>
In-Reply-To: <1352114361-25192-3-git-send-email-Varun.Sethi@freescale.com>
	(from Varun.Sethi@freescale.com on Mon Nov  5 05:19:20 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1352159767.28279.11@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 05:19:20 AM, Varun Sethi wrote:
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
>  	dma_addr_t aperture_start; /* First address that can be  
> mapped    */
>  	dma_addr_t aperture_end;   /* Last address that can be  
> mapped     */
>  	bool force_aperture;       /* DMA only allowed in mappable  
> range? */
> +
> +	/**
> +	 * There could be a single contiguous window tha maps the entire
> +	 * geometry or it could be split in to multiple subwindows.

...or it could be a normal IOMMU that supports arbitrary paging  
throughout the aperture.

> +	 * Subwindows allow for supporting physically discontiguous  
> mappings.

...in the absence of arbitrary paging.

> +	 * This attribute indicates number of DMA subwindows supported  
> by
> +	 * the geometry.

s/indicates number/indicates the number/

>   If there is a single window that maps the entire
> +	 * geometry, attribute must be set to "1". A value of "0"  
> implies
> +	 * that there are 256 subwindows each of size 4K. Value other  
> than
> +	 * "0" or "1" indicates the actual number of subwindows.

No, a value of "0" indicates that this mechanism is not in use at all,  
and normal paging is used.  PAMU specific things like "256 subwindows"  
must not be a default value in a generic API.

In the case of PAMU, if you specify 0 here, the aperture is limited to  
1 MiB because that is the limit of PAMU's ability to simulate arbitrary  
paging with subwindows, but this is only the limit of one  
implementation.  It's not part of the API.

-Scott
