Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab0GAFRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:17:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab0GAFRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:17:39 -0400
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: Tom Lyon <pugs@lyon-about.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, mst@redhat.com,
       avi@redhat.com, gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
In-Reply-To: <201006302130.38987.pugs@lyon-about.com>
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com>
	 <1277957783.10112.15.camel@x201>  <201006302130.38987.pugs@lyon-about.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Jun 2010 23:16:33 -0600
Message-ID: <1277961393.10112.37.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 21:30 -0700, Tom Lyon wrote:
> On Wednesday 30 June 2010 09:16:23 pm Alex Williamson wrote:
> > On Tue, 2010-06-08 at 14:21 -0700, Tom Lyon wrote:
> > > +int vfio_dma_unmap_dm(struct vfio_listener *listener, struct vfio_dma_map *dmp)
> > > +{
> > > +	unsigned long start, npage;
> > > +	struct dma_map_page *mlp;
> > > +	struct list_head *pos, *pos2;
> > > +	int ret;
> > > +
> > > +	start = dmp->vaddr & ~PAGE_SIZE;
> > > +	npage = dmp->size >> PAGE_SHIFT;
> > > +
> > > +	ret = -ENXIO;
> > > +	mutex_lock(&listener->vdev->dgate);
> > > +	list_for_each_safe(pos, pos2, &listener->dm_list) {
> > > +		mlp = list_entry(pos, struct dma_map_page, list);
> > > +		if (dmp->vaddr != mlp->vaddr || mlp->npage != npage)
> > > +			continue;
> > > +		ret = 0;
> > > +		vfio_dma_unmap(listener, mlp);
> > > +		break;
> > > +	}
> > 
> > Hi Tom,
> > 
> > Shouldn't we be matching the mlp based on daddr instead of vaddr?  We
> > can have multiple dma address pointing at the same virtual address, so
> > dma address is the unique element.  I'm also nervous about this dm_list.
> > For qemu device assignment, we're potentially statically mapping many GB
> > of iova space.  It seems like this could get incredibly bloated and
> > slow.  Thanks,
> > 
> > Alex
> 
> In weird circumstances, differing user vaddrs could reolve to the same physical address,
> so the uniqueness of any mapping is the <vaddr,len>.

That sounds like another argument for using daddr to me, no?  There's
only one address space on the PCI bus, daddr.  There's a 1:1 mapping of
daddr to physical page, but an N:1 mapping of vaddr to a physical page.

> Yes, a linear list is slow, but does qemu need a lot of mappings, or just big ones?

I'm not sure yet, the first interface I tried seems to be giving me
handfuls of pages.  We sometimes reprogram the guest physical address
(daddr) to a new virtual address (vaddr), but I don't know what the old
virtual address was, so I can't unmap it.  That's when I ran into the
issue above.  Thanks,

Alex

