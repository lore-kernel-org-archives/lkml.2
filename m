Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab0DQKnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 06:43:13 -0400
Received: from 8bytes.org ([88.198.83.132]:52917 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab0DQKnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 06:43:11 -0400
Date: Sat, 17 Apr 2010 12:43:09 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@cisco.com>
Cc: mst@redhat.com, hjk@linutronix.de, gregkh@suse.de, chrisw@sous-sol.org,
       avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] drivers/uio/uio.c: DMA mapping, interrupt
	extensions, etc.
Message-ID: <20100417104309.GA23260@8bytes.org>
References: <4bc77d41.njZFTBp9Nkn93l72%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bc77d41.njZFTBp9Nkn93l72%pugs@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 01:55:29PM -0700, Tom Lyon wrote:

> +	down(&idev->gate);
> +	if (idev->listeners == 0) {		/* first open */
> +		if (idev->pmaster && !iommu_found() && !capable(CAP_SYS_RAWIO)) {
> +			up(&idev->gate);
> +			return -EPERM;
> +		}
> +		/* reset to known state if we can */
> +		if (idev->pdev)
> +			(void) pci_reset_function(idev->pdev);
> +	}
> +	idev->listeners++;
> +	up(&idev->gate);

Why do you want to allow multiple opens for a device? Is it not
sufficient to allow only one?


> +	if (idev->domain == NULL) {
> +		if (!list_empty(&listener->dm_list))	/* no mix with anywhere */
> +			return -EINVAL;
> +		if (!iommu_found())
> +			return -EINVAL;
> +		idev->domain = iommu_domain_alloc();
> +		if (idev->domain == NULL)
> +			return -ENXIO;
> +		idev->cachec = iommu_domain_has_cap(idev->domain,
> +					IOMMU_CAP_CACHE_COHERENCY);
> +		ret = iommu_attach_device(idev->domain, idev->dev->parent);
> +		if (ret) {
> +			iommu_domain_free(idev->domain);
> +			idev->domain = NULL;
> +			printk(KERN_ERR "%s: device_attach failed %d\n", __func__, ret);
> +			return ret;
> +		}
> +	}

If userspace calls this path this will make all the addresses mapped
with DMA-API paths unusable by the device. This doesn't look like a sane
userspace interface.

For better and more in-depth review I suggest that you split up this
large patch into a series of smaler which implement specific aspects of
your work.

	Joerg

P.S.: I got these warning when applying your patches ...

Applying: drivers/uio/uio_pci_generic.c: allow access for non-privileged processes
/home/joro/src/linux.trees.git/.git/rebase-apply/patch:86: trailing whitespace.
                        info->mem[j].name = name; 
/home/joro/src/linux.trees.git/.git/rebase-apply/patch:87: trailing whitespace.
                        info->mem[j].addr = pci_resource_start(pdev, i); 
/home/joro/src/linux.trees.git/.git/rebase-apply/patch:89: trailing whitespace.
                        info->mem[j].memtype = UIO_MEM_PHYS; 
warning: 3 lines add whitespace errors.
Applying: drivers/uio/uio.c: DMA mapping, interrupt extensions, etc.
/home/joro/src/linux.trees.git/.git/rebase-apply/patch:315: trailing whitespace.
                ret = iommu_map_range(idev->domain, iova, 
/home/joro/src/linux.trees.git/.git/rebase-apply/patch:325: trailing whitespace.
        } 
/home/joro/src/linux.trees.git/.git/rebase-apply/patch:366: trailing whitespace.
         * adjacent pages, but noone seems to really do that. So we squash 
/home/joro/src/linux.trees.git/.git/rebase-apply/patch:368: trailing whitespace.
         * This works if (a) there is an iommu, or (b) the user allocates 
/home/joro/src/linux.trees.git/.git/rebase-apply/patch:578: trailing whitespace.
                        unsigned int cmd, unsigned long arg) 
warning: squelched 1 whitespace error
warning: 6 lines add whitespace errors.

And there are also some coding-style issues.
