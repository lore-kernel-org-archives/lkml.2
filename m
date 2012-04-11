Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab2DKQc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:32:59 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:25317
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760638Ab2DKQc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:32:57 -0400
X-SpamScore: -24
X-BigFish: VPS-24(z6c9Mz1432N98dKzz1202hzz15d4R8275bh8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2BPYQ-01-2AQ-02
X-M-MSG: 
Date: Wed, 11 Apr 2012 18:29:39 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 3.2-stable] iommu/amd: Make sure IOMMU interrupts are
 re-enabled on resume
Message-ID: <20120411162938.GJ2428@amd.com>
References: <1334161546-11110-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334161546-11110-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:25:46PM +0200, Joerg Roedel wrote:
> commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream
> 
> Unfortunatly the interrupts for the event log and the
> peripheral page-faults are only enabled at boot but not
> re-enabled at resume. Fix that for 3.2.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Argh, please ignore this one, this patch does a little bit too much.

> ---
>  drivers/iommu/amd_iommu_init.c |   27 ++++++++++++++++++++-------
>  1 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 5c74179..c90a709 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1033,8 +1033,9 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
>  {
>  	int r;
>  
> -	if (pci_enable_msi(iommu->dev))
> -		return 1;
> +	r = pci_enable_msi(iommu->dev);
> +	if (r)
> +		return r;
>  
>  	r = request_threaded_irq(iommu->dev->irq,
>  				 amd_iommu_int_handler,
> @@ -1044,24 +1045,36 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
>  
>  	if (r) {
>  		pci_disable_msi(iommu->dev);
> -		return 1;
> +		return r;
>  	}
>  
>  	iommu->int_enabled = true;
> -	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
>  
>  	return 0;
>  }
>  
>  static int iommu_init_msi(struct amd_iommu *iommu)
>  {
> +	int ret;
> +
>  	if (iommu->int_enabled)
> -		return 0;
> +		goto enable_faults;
>  
>  	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
> -		return iommu_setup_msi(iommu);
> +		ret = iommu_setup_msi(iommu);
> +	else
> +		ret = -ENODEV;
>  
> -	return 1;
> +	if (ret)
> +		return ret;
> +
> +enable_faults:
> +	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
> +
> +	if (iommu->ppr_log != NULL)
> +		iommu_feature_enable(iommu, CONTROL_PPFINT_EN);
> +
> +	return 0;
>  }
>  
>  /****************************************************************************
> -- 
> 1.7.5.4

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

