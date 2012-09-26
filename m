Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab2IZOwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab2IZOwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:52:08 -0400
Message-ID: <1348671121.28860.186.camel@bling.home>
Subject: Re: 3.6-rc7 boot crash + bisection
From: Alex Williamson <alex.williamson@redhat.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Florian Dazinger <florian@dazinger.net>, linux-kernel@vger.kernel.org,
        iommu <iommu@lists.linux-foundation.org>
Date: Wed, 26 Sep 2012 08:52:01 -0600
In-Reply-To: <20120926144345.GC10549@amd.com>
References: <20120924210348.5f50677b@brain.lan>
	 <1348597970.28860.114.camel@bling.home> <20120925205420.0a07dea2@brain.lan>
	 <1348602226.28860.132.camel@bling.home> <20120926010154.49cc2588@brain.lan>
	 <20120926144345.GC10549@amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 16:43 +0200, Roedel, Joerg wrote:
> Florian,
> 
> On Wed, Sep 26, 2012 at 01:01:54AM +0200, Florian Dazinger wrote:
> > you're right, either "amd_iommu=off" or removing the audio card makes
> > the failure disappear. I will test the new BIOS rev. tomorrow.
> 
> Can you please test this diff and report if it fixes the problem for
> you?
> 
> Thanks.
> 
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index b64502d..e89daf1 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -266,7 +266,7 @@ static void swap_pci_ref(struct pci_dev **from, struct pci_dev *to)
>  
>  static int iommu_init_device(struct device *dev)
>  {
> -	struct pci_dev *dma_pdev, *pdev = to_pci_dev(dev);
> +	struct pci_dev *dma_pdev = NULL, *pdev = to_pci_dev(dev);
>  	struct iommu_dev_data *dev_data;
>  	struct iommu_group *group;
>  	u16 alias;
> @@ -293,7 +293,9 @@ static int iommu_init_device(struct device *dev)
>  		dev_data->alias_data = alias_data;
>  
>  		dma_pdev = pci_get_bus_and_slot(alias >> 8, alias & 0xff);
> -	} else
> +	}
> +
> +	if (dma_pdev == NULL)
>  		dma_pdev = pci_dev_get(pdev);
>  
>  	/* Account for quirked devices */
> 

Assuming this works, it may be ok as a 3.7 fix, but if there was
actually more than one device behind the alias we'd expose them as
separate iommu groups.  I don't think that's what we want.  Maybe it
should at least get a pr_warn.  Thanks,

Alex

