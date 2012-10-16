Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2JPRmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:42:03 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:36155 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2JPRmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:42:01 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: "Khan, Shuah" <shuah.khan@hp.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        "Knippers, Linda" <linda.knippers@hp.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: RE: [PATCH v3] Prevent devices with RMRRs from being placed into SI
 Domain during startup
Thread-Topic: [PATCH v3] Prevent devices with RMRRs from being placed into
 SI Domain during startup
Thread-Index: AQHNq75aB25vtL4BmEKQ4/oTqsR2hZe8L72AgAADazA=
Date: Tue, 16 Oct 2012 17:41:11 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD341233233C1A44@G1W3651.americas.hpqcorp.net>
References: <20121016164905.14478.21080.sendpatchset@RHEL63BL460c.osen.hp.com>
 <1350408491.2785.28.camel@lorien2>
In-Reply-To: <1350408491.2785.28.camel@lorien2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.193.232.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9GHg7bN032346

I imagine there could be other devices that get a "free ride". Any help or suggestions in that area are greatly appreciated.


Tom

-----Original Message-----
From: Khan, Shuah 
Sent: Tuesday, October 16, 2012 12:28 PM
To: Mingarelli, Thomas
Cc: Alex Williamson; David Woodhouse; Don Dutile; Knippers, Linda; iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; shuahkhan@gmail.com
Subject: Re: [PATCH v3] Prevent devices with RMRRs from being placed into SI Domain during startup

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

Forgot to ask in my last response. Is it sufficient to check _USB. Are
we missing any other devices that use RMRR that would qualify?

> +				return 0;
> +	}
> +
>  	if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
>  		return 1;
>  


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
