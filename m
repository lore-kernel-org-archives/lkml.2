Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2JPR0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:26:07 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:12066 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2JPR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:26:06 -0400
Message-ID: <1350408360.2785.26.camel@lorien2>
Subject: Re: [PATCH v3] Prevent devices with RMRRs from being placed into SI
 Domain during startup
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Tom Mingarelli <thomas.mingarelli@hp.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Linda Knippers <linda.knippers@hp.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Date: Tue, 16 Oct 2012 11:26:00 -0600
In-Reply-To: <20121016164905.14478.21080.sendpatchset@RHEL63BL460c.osen.hp.com>
References: <20121016164905.14478.21080.sendpatchset@RHEL63BL460c.osen.hp.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 16:50 +0000, Tom Mingarelli wrote:
> This patch is to prevent devices that have RMRRs associated with them 
> from getting placed into the SI Domain during init. We don't put USB devices
> into this category, however. This fixes the issue where the RMRR info
> for devices being placed in and out of the SI Domain gets lost.
> 
> Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
> ----
> PATCH v1: https://lkml.org/lkml/2012/6/15/204
> PATCH v2: https://lkml.org/lkml/2012/9/18/354
> 
> drivers/iommu/intel-iommu.c |   33 +++++++++++++++++++++++++++++++++
> 1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff -up ./drivers/iommu/intel-iommu.c.ORIG ./drivers/iommu/intel-iommu.c
> --- ./drivers/iommu/intel-iommu.c.ORIG	2012-10-16 09:34:23.148089944 -0500
> +++ ./drivers/iommu/intel-iommu.c	2012-10-16 09:56:56.905932861 -0500
> @@ -2320,8 +2320,41 @@ static int domain_add_dev_info(struct dm
>  	return 0;
>  }
>  
> +static bool device_has_rmrr(struct pci_dev *dev)
> +{
> +	struct dmar_rmrr_unit *rmrr;
> +	int i;
> +
> +	for_each_rmrr_units(rmrr) {
> +		for (i = 0; i < rmrr->devices_cnt; i++) {
> +			/*
> +			 * Here we are just concerned with checking each device
> +			 * that has an RMRR associated with it and not allow it
> +			 * to be placed into the SI Domain during startup.
> +			*/
> +			if (rmrr->devices[i] == dev)
> +				return true;
> +		}
> +	}
> +	return false;
> +}
> +

Will you use the same routine to deny device assignment request for
devices with RMRR? Is that going to be another patch?

>  static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
>  {
> +
> +	if (startup) {
> +		/*
> +		 * This is where we will refuse any device that has an
> +		 * RMRR associated with it and is not a USB device and
> +		 * NOT allow it to be placed into the SI Domain. We
> +		 * only do this on startup. We don't need a separate bit
> +		 * for this because it could be ANY device.
> +		*/
> +		if (device_has_rmrr(pdev) &&
> +			(pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
> +				return 0;
> +	}
> +

Is there a reason to not group this with the other pci device checks
below. Don't you need this done whenever iommu_should_identity_map() get
called as opposed just at startup?

>  	if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
>  		return 1;
>  


