Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab2I1OJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:09:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49508 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714Ab2I1OJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:09:33 -0400
Date: Fri, 28 Sep 2012 10:08:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] iommu/amd: Keep track of HPET and IOAPIC device ids
Message-ID: <20120928140833.GB7483@localhost.localdomain>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
 <1348835046-3262-2-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348835046-3262-2-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 02:23:51PM +0200, Joerg Roedel wrote:
> The IVRS ACPI table provides information about the IOAPICs
> and the HPETs available in the system and which PCI device
> ID they use in transactions. Save that information for later
> usage in interrupt remapping.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/amd_iommu.c       |    3 ++
>  drivers/iommu/amd_iommu_init.c  |   65 +++++++++++++++++++++++++++++++++++++--
>  drivers/iommu/amd_iommu_types.h |   34 ++++++++++++++++++++
>  3 files changed, 100 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index b64502d..6f51483 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -72,6 +72,9 @@ static DEFINE_SPINLOCK(iommu_pd_list_lock);
>  static LIST_HEAD(dev_data_list);
>  static DEFINE_SPINLOCK(dev_data_list_lock);
>  
> +LIST_HEAD(ioapic_map);
> +LIST_HEAD(hpet_map);
> +
>  /*
>   * Domain for untranslated devices - only allocated
>   * if iommu=pt passed on kernel cmd line.
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 18a89b7..a9f3948 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -55,6 +55,7 @@
>  #define IVHD_DEV_ALIAS_RANGE            0x43
>  #define IVHD_DEV_EXT_SELECT             0x46
>  #define IVHD_DEV_EXT_SELECT_RANGE       0x47
> +#define IVHD_DEV_SPECIAL		0x48
>  
>  #define IVHD_FLAG_HT_TUN_EN_MASK        0x01
>  #define IVHD_FLAG_PASSPW_EN_MASK        0x02
> @@ -690,6 +691,31 @@ static void __init set_dev_entry_from_acpi(struct amd_iommu *iommu,
>  	set_iommu_for_device(iommu, devid);
>  }
>  
> +static int add_special_device(u8 type, u8 id, u16 devid)
> +{
> +	struct devid_map *entry;
> +	struct list_head *list;
> +
> +	if (type != 1 && type != 2)
> +		return -EINVAL;

Should this be perhaps an enum? or #define?

> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	entry->id    = id;
> +	entry->devid = devid;
> +
> +	if (type == 1)
> +		list = &ioapic_map;
> +	else
> +		list = &hpet_map;
> +
> +	list_add_tail(&entry->list, list);
> +
> +	return 0;
> +}
> +

Reviwed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
