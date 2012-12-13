Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2LMQfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:35:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18596 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab2LMQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:35:00 -0500
Date: Thu, 13 Dec 2012 11:34:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Xu, Dongxiao" <dongxiao.xu@intel.com>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/swiotlb: Exchange to contiguous memory for map_sg
 hook
Message-ID: <20121213163426.GD20661@localhost.localdomain>
References: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
 <20121207140852.GC3140@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FEBE741@SHSMSX102.ccr.corp.intel.com>
 <20121211170653.GG9347@localhost.localdomain>
 <40776A41FC278F40B59438AD47D147A90FEBFB64@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40776A41FC278F40B59438AD47D147A90FEBFB64@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 01:03:55AM +0000, Xu, Dongxiao wrote:
> > -----Original Message-----
> > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > Sent: Wednesday, December 12, 2012 1:07 AM
> > To: Xu, Dongxiao
> > Cc: xen-devel@lists.xen.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] xen/swiotlb: Exchange to contiguous memory for map_sg
> > hook
> > 
> > On Tue, Dec 11, 2012 at 06:39:35AM +0000, Xu, Dongxiao wrote:
> > > > -----Original Message-----
> > > > From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> > > > Sent: Friday, December 07, 2012 10:09 PM
> > > > To: Xu, Dongxiao
> > > > Cc: xen-devel@lists.xen.org; linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH] xen/swiotlb: Exchange to contiguous memory for
> > > > map_sg hook
> > > >
> > > > On Thu, Dec 06, 2012 at 09:08:42PM +0800, Dongxiao Xu wrote:
> > > > > While mapping sg buffers, checking to cross page DMA buffer is
> > > > > also needed. If the guest DMA buffer crosses page boundary, Xen
> > > > > should exchange contiguous memory for it.
> > > >
> > > > So this is when we cross those 2MB contingous swatch of buffers.
> > > > Wouldn't we get the same problem with the 'map_page' call? If the
> > > > driver tried to map say a 4MB DMA region?
> > >
> > > Yes, it also needs such check, as I just replied to Jan's mail.
> > >
> > > >
> > > > What if this check was done in the routines that provide the
> > > > software static buffers and there try to provide a nice DMA contingous
> > swatch of pages?
> > >
> > > Yes, this approach also came to our mind, which needs to modify the driver
> > itself.
> > > If so, it requires driver not using such static buffers (e.g., from kmalloc) to do
> > DMA even if the buffer is continuous in native.
> > 
> > I am bit loss here.
> > 
> > Is the issue you found only with drivers that do not use DMA API?
> > Can you perhaps point me to the code that triggered this fix in the first place?
> 
> Yes, we met this issue on a specific SAS device/driver, and it calls into libata-core code, you can refer to function ata_dev_read_id() called from ata_dev_reread_id() in drivers/ata/libata-core.c.
> 
> In the above function, the target buffer is (void *)dev->link->ap->sector_buf, which is 512 bytes static buffer and unfortunately it across the page boundary.

Hm, that looks like a DMA API violation. If you ran the code with
CONFIG_DEBUG_DMA_API did it complain about this? I recall the floppy
driver doing something similar and the Debug DMA API was quite verbose
in pointing this out.

> 
> > > Is this acceptable by kernel/driver upstream?
> > 
> > I am still not completely clear on what you had in mind. The one method I
> > thought about that might help in this is to have Xen-SWIOTLB track which
> > memory ranges were exchanged (so xen_swiotlb_fixup would save the *buf
> > and the size for each call to xen_create_contiguous_region in a list or array).
> > 
> > When xen_swiotlb_map/xen_swiotlb_map_sg_attrs care called they would
> > consult said array/list to see if the region they retrieved crosses said 2MB
> > chunks. If so.. and here I am unsure of what would be the best way to proceed.
> 
> We thought we can solve the issue in several ways:
> 
> 1) Like the previous patch I sent out, we check the DMA region in xen_swiotlb_map_page() and xen_swiotlb_map_sg_attr(), and if DMA region crosses page boundary, we exchange the memory and copy the content. However it has race condition that when copying the memory content (we introduced two memory copies in the patch), some other code may also visit the page, which may encounter incorrect values.
> 2) Mostly the same as item 1), the only difference is that we put the memory content copy inside Xen hypervisor but not in Dom0. This requires we add certain flags to indicating memory moving in the XENMEM_exchange hypercall.
> 3) As you also mentioned, this is not a common case, it is only triggered by some specific devices/drivers. we can fix it in certain driver to avoid DMA into static buffers. Like (void *)dev->link->ap->sector_buf in the above case. But I am not sure whether it is acceptable by kernel/driver upstream.
> 
> Thanks,
> Dongxiao
> 
> 
