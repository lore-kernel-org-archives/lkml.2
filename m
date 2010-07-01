Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab0GAEeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 00:34:19 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:9948 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0GAEeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 00:34:17 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,517,1272844800"; 
   d="scan'208";a="552797244"
From: Tom Lyon <pugs@lyon-about.com>
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Date: Wed, 30 Jun 2010 21:30:38 -0700
User-Agent: KMail/1.9.9
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, mst@redhat.com,
       avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <1277957783.10112.15.camel@x201>
In-Reply-To: <1277957783.10112.15.camel@x201>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006302130.38987.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010 09:16:23 pm Alex Williamson wrote:
> On Tue, 2010-06-08 at 14:21 -0700, Tom Lyon wrote:
> > +int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
> > +{
> > +	unsigned long start, npage;
> > +	struct dma_map_page *mlp;
> > +	struct list_head *pos, *pos2;
> > +	int ret;
> > +
> > +	start = dmp->vaddr & ~PAGE_SIZE;
> > +	npage = dmp->size >> PAGE_SHIFT;
> > +
> > +	ret = -ENXIO;
> > +	mutex_lock(&listener->vdev->dgate);
> > +	list_for_each_safe(pos, pos2, &listener->dm_list) {
> > +		mlp = list_entry(pos, struct dma_map_page, list);
> > +		if (dmp->vaddr != mlp->vaddr || mlp->npage != npage)
> > +			continue;
> > +		ret = 0;
> > +		vfio_dma_unmap(listener, mlp);
> > +		break;
> > +	}
> 
> Hi Tom,
> 
> Shouldn't we be matching the mlp based on daddr instead of vaddr?  We
> can have multiple dma address pointing at the same virtual address, so
> dma address is the unique element.  I'm also nervous about this dm_list.
> For qemu device assignment, we're potentially statically mapping many GB
> of iova space.  It seems like this could get incredibly bloated and
> slow.  Thanks,
> 
> Alex

In weird circumstances, differing user vaddrs could reolve to the same physical address,
so the uniqueness of any mapping is the <vaddr,len>.

Yes, a linear list is slow, but does qemu need a lot of mappings, or just big ones?
> 
> 


