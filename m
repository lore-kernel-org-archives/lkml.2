Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab2DKPpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:45:46 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:33537
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545Ab2DKPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:45:44 -0400
X-SpamScore: -27
X-BigFish: VPS-27(z6c9Mz936eK1432N98dKzz1202hzz15d4R8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2BNS0-01-AN0-02
X-M-MSG: 
Date: Wed, 11 Apr 2012 17:45:22 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ 117/175] iommu/amd: Make sure IOMMU interrupts are re-enabled
 on resume
Message-ID: <20120411154522.GH2428@amd.com>
References: <20120330194849.232840068@linuxfoundation.org>
 <1333423686.443.37.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333423686.443.37.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right, this fix is also required for 3.2 and 3.0.

On Tue, Apr 03, 2012 at 04:28:06AM +0100, Ben Hutchings wrote:
> On Fri, 2012-03-30 at 12:50 -0700, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream.
> > 
> > Unfortunatly the interrupts for the event log and the
> > peripheral page-faults are only enabled at boot but not
> > re-enabled at resume. Fix that.
> [...]
> 
> It looks like this should be applicable to 3.0 and 3.2 as well, but only
> for the event log.  I'm attaching my (untested) backports for
> consideration.

The backport looks good.

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> 
> Ben.
> 
> -- 
> Ben Hutchings
> Reality is just a crutch for people who can't handle science fiction.

> From ed3845ba84e5dbe3593dddf06b6377960f95712d Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Thu, 15 Mar 2012 16:29:47 +0100
> Subject: [PATCH] iommu/amd: Make sure IOMMU interrupts are re-enabled on
>  resume
> 
> commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream.
> 
> Unfortunatly the interrupts for the event log and the
> peripheral page-faults are only enabled at boot but not
> re-enabled at resume. Fix that.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> [bwh: Backport to 3.0:
>  - Drop change to PPR log which was added in 3.3
>  - Source is under arch/x86/kernel]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/x86/kernel/amd_iommu_init.c |   24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> index bfc8453..33df6e8 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -1031,8 +1031,9 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
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
> @@ -1042,24 +1043,33 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
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
> +	return 0;
>  }
>  
>  /****************************************************************************
> -- 
> 1.7.9.5
> 

> From ce1ae4a46ead4899939002d48e23678601ec6969 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Thu, 15 Mar 2012 16:29:47 +0100
> Subject: [PATCH] iommu/amd: Make sure IOMMU interrupts are re-enabled on
>  resume
> 
> commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream.
> 
> Unfortunatly the interrupts for the event log and the
> peripheral page-faults are only enabled at boot but not
> re-enabled at resume. Fix that.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> [bwh: Backport to 3.2: drop change to PPR log which was added in 3.3]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/iommu/amd_iommu_init.c |   24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 5c74179..20d5852 100644
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
> @@ -1044,24 +1045,33 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
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
> +	return 0;
>  }
>  
>  /****************************************************************************
> -- 
> 1.7.9.5
> 




-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

