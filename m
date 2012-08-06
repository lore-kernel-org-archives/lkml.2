Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2HFOXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:23:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493Ab2HFOXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:23:21 -0400
Message-ID: <1344262990.3441.13.camel@ul30vt.home>
Subject: Re: [PATCH 0/2] Fix ACS path checking
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org, dsahern@gmail.com
Date: Mon, 06 Aug 2012 08:23:10 -0600
In-Reply-To: <20120806122053.GL1996@amd.com>
References: <20120804180155.6144.83332.stgit@bling.home>
	 <20120806105010.GK1996@amd.com> <20120806122053.GL1996@amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 14:20 +0200, Joerg Roedel wrote:
> On Mon, Aug 06, 2012 at 12:50:10PM +0200, Joerg Roedel wrote:
> > On Sat, Aug 04, 2012 at 12:08:46PM -0600, Alex Williamson wrote:
> > Hmm, tried it here, At least pci_request_acs() still gets called. How do
> > you detect if ACS is really enabled?
> 
> Okay, I found a problem. pci_request_acs needs to be called before PCI
> probing. Does the attached patch help?
> 
> From 87a4363be30d5d015a984a60769f29b0607fc5fb Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Mon, 6 Aug 2012 14:18:42 +0200
> Subject: [PATCH] iommu/amd: Fix pci_request_acs() call-place
> 
> The pci_request_acs() function needs to be called before PCI
> probing to be effective. So move it to another call-place to
> ensure that.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/amd_iommu_init.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)


Yes, that's it.  Before and after:

00:04.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port D) (prog-if 00 [Normal decode])
	Capabilities: [190] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid- TransBlk- ReqRedir- CmpltRedir- UpstreamFwd- EgressCtrl- DirectTrans-

	Capabilities: [190] Access Control Services
		ACSCap:	SrcValid+ TransBlk+ ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans+
		ACSCtl:	SrcValid+ TransBlk- ReqRedir+ CmpltRedir+ UpstreamFwd+ EgressCtrl- DirectTrans-

The former makes iommu grouping put all my VFs in a single group below
this device.  Correct given the ACS state, but not very useful.  Thanks,

Alex

Tested-by: Alex Williamson <alex.williamson@redhat.com>

> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 500e7f1..0a2ea31 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1131,9 +1131,6 @@ static int __init amd_iommu_init_pci(void)
>  			break;
>  	}
>  
> -	/* Make sure ACS will be enabled */
> -	pci_request_acs();
> -
>  	ret = amd_iommu_init_devices();
>  
>  	print_iommu_info();
> @@ -1652,6 +1649,9 @@ static bool detect_ivrs(void)
>  
>  	early_acpi_os_unmap_memory((char __iomem *)ivrs_base, ivrs_size);
>  
> +	/* Make sure ACS will be enabled during PCI probe */
> +	pci_request_acs();
> +
>  	return true;
>  }
>  



