Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2KTUTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:19:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab2KTUTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:19:34 -0500
Message-ID: <1353442764.2234.90.camel@bling.home>
Subject: Re: [PATCH v4] intel-iommu: Prevent devices with RMRRs from being
 placed into SI Domain
From: Alex Williamson <alex.williamson@redhat.com>
To: Tom Mingarelli <thomas.mingarelli@hp.com>
Cc: Don Dutile <ddutile@redhat.com>, Linda Knippers <linda.knippers@hp.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah.khan@hp.com>, David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>
Date: Tue, 20 Nov 2012 13:19:24 -0700
In-Reply-To: <20120917082234.22091.84161.sendpatchset@RHEL63BL460c>
References: <20120917082234.22091.84161.sendpatchset@RHEL63BL460c>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 19:43 +0000, Tom Mingarelli wrote:
> This patch is to prevent non-USB devices that have RMRRs associated with them from
> being placed into the SI Domain during init. This fixes the issue where the RMRR info
> for devices being placed in and out of the SI Domain gets lost.
> 
> Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
> Tested-by: Shuah Khan <shuah.khan@hp.com>
> ---
> PATCH v1: https://lkml.org/lkml/2012/6/15/204
> PATCH v2: https://lkml.org/lkml/2012/9/18/354
> PATCH v3: https://lkml.org/lkml/2012/10/16/375
> 
>  drivers/iommu/intel-iommu.c |   31 +++++++++++++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)

Looks ok to me.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index d4a4cd4..8c064df 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -2320,8 +2320,39 @@ static int domain_add_dev_info(struct dmar_domain *domain,
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
> +			 * Return TRUE if this RMRR contains the device that
> +			 * is passed in.
> +			 */
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
> +	/*
> +	 * We want to prevent any device associated with an RMRR from
> +	 * getting placed into the SI Domain. This is done because
> +	 * problems exist when devices are moved in and out of domains
> +	 * and their respective RMRR info is lost. We exempt USB devices
> +	 * from this process due to their usage of RMRRs that are known
> +	 * to not be needed after BIOS hand-off to OS.
> +	 */
> +	if (device_has_rmrr(pdev) &&
> +	    (pdev->class >> 8) != PCI_CLASS_SERIAL_USB)
> +		return 0;
> +
>  	if ((iommu_identity_mapping & IDENTMAP_AZALIA) && IS_AZALIA(pdev))
>  		return 1;
>  



