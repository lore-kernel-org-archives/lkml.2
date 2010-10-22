Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab0JVSEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:04:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30146 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0JVSEC (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 22 Oct 2010 14:04:02 -0400
Date: Fri, 22 Oct 2010 14:02:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
Message-ID: <20101022180231.GA26365@dumpdata.com>
References: <4CC0C14E.5080205@goop.org>
 <4CC0C318.90401@zytor.com>
 <4CC0CA07.3000306@goop.org>
 <4CC0DEB8.1060309@zytor.com>
 <20101022150826.GA23325@dumpdata.com>
 <4CC1BF58.9020001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC1BF58.9020001@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 09:44:08AM -0700, H. Peter Anvin wrote:
> On 10/22/2010 08:08 AM, Konrad Rzeszutek Wilk wrote:
> >>
> >> Okay, could you clarify this part a bit?  Why does the kernel need to
> >> know the difference between "pseudo-physical" and "machine addresses" at
> >> all?  If they overlap, there is a problem, and if they don't overlap, it
> >> will be a 1:1 mapping anyway...
> > 
> > The flag (_PAGE_IOMAP) is used when we set the PTE so that the MFN value is
> > used instead of the PFN. We need that b/c when a driver does page_to_pfn()
> > it ends up using the PFN as bus address to write out registers data.
> > 
> > Without this patch, the page->virt->PFN value is used and the PFN != to real MFN
> > so we end up writing in a memory address that the PCI device has no idea about.
> > By setting the PTE with the MFN, the virt->PFN gets the real MFN value.
> > 
> > The drivers I am talking about are mostly, if not all, located in drivers/gpu
> > and it looks that we are missing two more patches to utilize the patch
> > that Jeremy posted.
> > 
> > Please note that I am _not_ suggesting that the two patches
> > below should go out - I still need to post them on drm mailing list.
> > 
> 
> I'm still seriously confused.  If I understand this correctly, we're
> talking about DMA addresses here (as opposed to PIO addresses, i.e.
> BARs), right?

Correct. The BARs are ok since they go through the ioremap.
> 
> It's the bimodality that really bothers me.  I understand of course that
> Xen imposes yet another address remapping layer, but I'm having a hard
> time understanding any conditions under with we would need that layer to
> go away, as long as DMA addresses are translated via the DMA APIs -- and
> if they aren't, then iommus will break, too.

That is it. They aren't using the DMA or PCI API completly(*).  Try doing
'iommu=soft swiotlb=force' with your radeon card under baremetal
(I used an ATI ES1000).  I think it will grind to halt during the writeback test.

(*): This was with 2.6.34, I haven't touched 2.6.36 and there was an drm/iomem rewrite
so it might be that this now working. The incomplete part of the graphics
drivers was that it would not do pci_dma_sync_*, so when the MFN was programmed in the
GTT/GART (check out radeon_gart_bind, the call to pci_map_page gets the bus address, also
known as MFN). So the GPU would now have a virt->MFN mapping. However, on the CPU side
when the driver writes a texture to virtual address, the mapping is virt->PFN.

So when we kick the GPU to do its magic, the VM on the graphics card would translate
the virtual address to the MFN, which did not have the data that was written by the
kernel to the PFN. In other words *PFN != *MFN, while we need *PFN == *MFN.
There are two ways of making this work:
 1). PFN == MFN (this is what Jeremy's patch ends up doing) and under
     baremetal it won't affect as baremetal doesn't care what the VM_IO flag
     stands for.
 2). Add a whole bunch of pci_dma_sync in the appropiate sections in the 
     graphic drivers.

I am not qualified to do 2) - that code scares me. Also 1) is the easier :-)

I am actually not sure how it works with AMD-Vi or Intel VT-d. I do remember
something about letting certain devices bypass the VT-d, and I think I saw
the nouveau making the DMAR throw a fit.

> As such, I don't grok this page flag and what it does, and why it's
> needed.  I'm not saying it's *wrong*, I'm saying the design is opaque to

I hope my explanation cleared the confusion.

> me and I'm not sure it is the right solution.
