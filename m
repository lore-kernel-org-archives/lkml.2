Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0DQRHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 13:07:16 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:58071 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab0DQRHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 13:07:12 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJOHyUurRN+J/2dsb2JhbACbeHGhJZlShRAEgzI
X-IronPort-AV: E=Sophos;i="4.52,227,1270425600"; 
   d="scan'208";a="516683199"
From: Tom Lyon <pugs@lyon-about.com>
To: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH V2] drivers/uio/uio.c: DMA mapping, interrupt extensions, etc.
Date: Sat, 17 Apr 2010 10:04:22 -0700
User-Agent: KMail/1.9.9
Cc: mst@redhat.com, hjk@linutronix.de, gregkh@suse.de, chrisw@sous-sol.org,
       avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4bc77d41.njZFTBp9Nkn93l72%pugs@cisco.com> <20100417104309.GA23260@8bytes.org>
In-Reply-To: <20100417104309.GA23260@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004171004.23155.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current uio and uio_pci_generic allow multiple opens; I was just preserving that behavior.

On Saturday 17 April 2010 03:43:09 am Joerg Roedel wrote:
> On Thu, Apr 15, 2010 at 01:55:29PM -0700, Tom Lyon wrote:
> 
> > +	down(&idev->gate);
> > +	if (idev->listeners == 0) {		/* first open */
> > +		if (idev->pmaster && !iommu_found() && !capable(CAP_SYS_RAWIO)) {
> > +			up(&idev->gate);
> > +			return -EPERM;
> > +		}
> > +		/* reset to known state if we can */
> > +		if (idev->pdev)
> > +			(void) pci_reset_function(idev->pdev);
> > +	}
> > +	idev->listeners++;
> > +	up(&idev->gate);
> 
> Why do you want to allow multiple opens for a device? Is it not
> sufficient to allow only one?
> 
> 
> > +	if (idev->domain == NULL) {
> > +		if (!list_empty(&listener->dm_list))	/* no mix with anywhere */
> > +			return -EINVAL;
> > +		if (!iommu_found())
> > +			return -EINVAL;
> > +		idev->domain = iommu_domain_alloc();
> > +		if (idev->domain == NULL)
> > +			return -ENXIO;
> > +		idev->cachec = iommu_domain_has_cap(idev->domain,
> > +					IOMMU_CAP_CACHE_COHERENCY);
> > +		ret = iommu_attach_device(idev->domain, idev->dev->parent);
> > +		if (ret) {
> > +			iommu_domain_free(idev->domain);
> > +			idev->domain = NULL;
> > +			printk(KERN_ERR "%s: device_attach failed %d\n", __func__, ret);
> > +			return ret;
> > +		}
> > +	}
> 
> If userspace calls this path this will make all the addresses mapped
> with DMA-API paths unusable by the device. This doesn't look like a sane
> userspace interface.
> 
> For better and more in-depth review I suggest that you split up this
> large patch into a series of smaler which implement specific aspects of
> your work.
> 
> 	Joerg
> 
> P.S.: I got these warning when applying your patches ...
> 
> Applying: drivers/uio/uio_pci_generic.c: allow access for non-privileged processes
> /home/joro/src/linux.trees.git/.git/rebase-apply/patch:86: trailing whitespace.
>                         info->mem[j].name = name; 
> /home/joro/src/linux.trees.git/.git/rebase-apply/patch:87: trailing whitespace.
>                         info->mem[j].addr = pci_resource_start(pdev, i); 
> /home/joro/src/linux.trees.git/.git/rebase-apply/patch:89: trailing whitespace.
>                         info->mem[j].memtype = UIO_MEM_PHYS; 
> warning: 3 lines add whitespace errors.
> Applying: drivers/uio/uio.c: DMA mapping, interrupt extensions, etc.
> /home/joro/src/linux.trees.git/.git/rebase-apply/patch:315: trailing whitespace.
>                 ret = iommu_map_range(idev->domain, iova, 
> /home/joro/src/linux.trees.git/.git/rebase-apply/patch:325: trailing whitespace.
>         } 
> /home/joro/src/linux.trees.git/.git/rebase-apply/patch:366: trailing whitespace.
>          * adjacent pages, but noone seems to really do that. So we squash 
> /home/joro/src/linux.trees.git/.git/rebase-apply/patch:368: trailing whitespace.
>          * This works if (a) there is an iommu, or (b) the user allocates 
> /home/joro/src/linux.trees.git/.git/rebase-apply/patch:578: trailing whitespace.
>                         unsigned int cmd, unsigned long arg) 
> warning: squelched 1 whitespace error
> warning: 6 lines add whitespace errors.
> 
> And there are also some coding-style issues.
> 


