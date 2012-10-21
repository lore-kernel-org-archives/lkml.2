Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab2JUU1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 16:27:05 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26885 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab2JUU1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 16:27:04 -0400
Message-ID: <50845A95.1000200@hp.com>
Date: Sun, 21 Oct 2012 13:27:01 -0700
From: Craig Hada <craig.hada@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tom Mingarelli <thomas.mingarelli@hp.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        iommu@lists.linux-foundation.org, Shuah Khan <shuah.khan@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Prevent devices with RMRRs from being placed into
 SI Domain
References: <20121018021735.23962.51639.sendpatchset@RHEL63BL460c>
In-Reply-To: <20121018021735.23962.51639.sendpatchset@RHEL63BL460c>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 2:17 PM, Tom Mingarelli wrote:
> This patch is to prevent devices that have RMRRs associated with them to
> not be placed into the SI Domain during init. We don't put USB devices
> into this category, however. This fixes the issue where the RMRR info
> for devices being placed in and out of the SI Domain gets lost.
>
> Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
> Tested-by: Shuah Khan <shuah.khan@hp.com>
> ----
> PATCH v1: https://lkml.org/lkml/2012/6/15/204
> PATCH v2: https://lkml.org/lkml/2012/9/18/354
>
>
> drivers/iommu/intel-iommu.c |   30 ++++++++++++++++++++++++++++++
>   1 files changed, 30 insertions(+), 0 deletions(-)
>
> diff -up ./drivers/iommu/intel-iommu.c.ORIG ./drivers/iommu/intel-iommu.c
> --- ./drivers/iommu/intel-iommu.c.ORIG	2012-10-16 09:34:23.148089944 -0500
> +++ ./drivers/iommu/intel-iommu.c	2012-10-17 20:41:40.509642356 -0500
> @@ -2320,8 +2320,38 @@ static int domain_add_dev_info(struct dm
>   	return 0;
>   }
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
>   static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
>   {
> +
> +	/*
> +	 * This is where we will refuse any device that has an
> +	 * RMRR associated with it and is not a USB device and
> +	 * NOT allow it to be placed into the SI Domain. We don't
> +	 * need a separate bit for this because it could be ANY device.
> +	 */
> +	if (device_has_rmrr(pdev) &&
> +		(pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
> +			return 0;
> +
>   	if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
>   		return 1;
>   
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> .
>
I applied this patch to my system and booted with IOMMU pass through 
mode enabled. Without the patch my system would panic or wedge. I also 
applied a be2net patch I'm working on and was able to get successful 
netperf runs with IOMMU pass through mode enabled.

-Craig
