Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab1I2UaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:30:21 -0400
Received: from mx2.compro.net ([12.186.155.4]:20567 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab1I2UaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:30:19 -0400
X-IronPort-AV: E=Sophos;i="4.68,463,1312171200"; 
   d="scan'208";a="7091617"
Message-ID: <4E84D55A.5050406@compro.net>
Date: Thu, 29 Sep 2011 16:30:18 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: markh@compro.net
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: Problem with AMD chipsets. Was "Re: problems doing direct dma
 from a pci device to pci-e device"
References: <4E84CA01.2060907@compro.net>
In-Reply-To: <4E84CA01.2060907@compro.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2011 03:41 PM, Mark Hounschell wrote:
> The original thread is a year or so old but I never actually figured out
> what the problem was. It's still an issue I need to try to understand so
> I thought I would try again. As then, I know this is a PCI thing but
> have CC'd LMKL just in case. Sorry for the noise LMKL.
>
> Briefly, we have a couple of PCI cards that talk to each other over the
> pci bus. One is a reflective memory type (rms) card and the other is a
> special I/O (gpiohsd) card. These are both regular PCI cards. The way
> this gpiohsd writes and reads data to and from this rms card mamory and
> also to regular application SHM memory is by way of internal page tables
> in the gpiohsd containing bus addresses of the rms cards memory or
> application SHM memory. We stuff the gpiohsd page tables with bus
> addresses we get from the page_to_phys call. We used to use virt_to_bus.
> The gpiohsd may do a single read or write, or a large DMA read or write.
> Software never directly tells this gpiohsd card to do any xfer, DMA or
> not. I've looked at the kernel DMA Documentation and don't really see
> anything there that will help me with my problem (which I will explain
> below). Here is a blurp of the code in one of our GPL drivers we use for
> getting bus addresses for our rms card memory and/or our application SHM
> memory that we stuff into the gpiohsd page tables. FYI, a device
> connected to this gpiohsd card can, by its self, cause the gpiohsd to
> initiate these data transfers.
>
> /*
> * Get a physical/bus address from our virtual address
> */
> down_read(&current->mm->mmap_sem);
>
> /*
> * Get around the mlock fix/change in get_user_pages that forces
> * the call to fail if the VM_IO bit is set in vma->vm_flags
> *
> * As of 2.6.16 kernels get_user_pages also fails when the
> * new VM_PFNMAP bit in vm->flags is set. It is OK to
> * reset this bit also as long as we return the bit to
> * its original set condition.
> */
>
> VM_flags = 0;
> vma = find_vma(current->mm, (unsigned long)pte_info.virt_addr);
> VM_flags = (vma->vm_flags & (VM_IO | VM_PFNMAP));
> vma->vm_flags &= (~VM_IO & ~VM_PFNMAP);
>
> stat = get_user_pages(current, current->mm,
> (unsigned long)pte_info.virt_addr,
> 1, // one page
> 1, // write access
> 1, // force
> &pages, // page struct
> NULL); //
>
> vma->vm_flags |= VM_flags; // Set vm_flags back to the way we found them
>
> up_read(&current->mm->mmap_sem);
>
> if (stat < 0) {
> ret = -EFAULT;
> goto out;
> } else {
> phys_addr = page_to_phys(pages); // on x86 phys = bus
> page_cache_release(pages);
> }
>
> pci_address = phys_addr;
> pte_info.pcimsa = 0; // We are running 32 bit
> pte_info.pcilsa = pci_address;
> if (PAGE_SIZE < 8192) // MPX page size
> pte_info.pagesize = PAGE_SIZE;
> else
> pte_info.pagesize = 8192;
> if (copy_to_user((lcrs_pte_struct_t *) arg,
> &pte_info, sizeof(lcrs_pte_struct_t))) {
> ret = -EFAULT;
> goto out;
> }
>
>

The above code is only used for the SHM case, Sorry. For the rms case we 
get the bus address directly from the rms cards driver.

> We come into the above code with a virtual address (page aligned) of
> either the rms memory page, via mmap, or our SHM memory page, using the
> standard shm API. This has all worked just fine for years. And it still
> does except for when we are using a more recent MB with an AMD chipset
> and the data to/from the gpiohsd has to cross a pci-e bridge to get to
> the rms memory or to our SHM memory. An example of that configuration
> would be when the rms card is plugged into the MB and the gpiohsd is in
> a regular PCI expansion rack and the expansion rack interface card is a
> pci-e card plugged into a pci-e slot. It appears we are unable to cross
> over pci-e bridges for some reason using the bus addresses obtained
> using the method described above.
>
> We have no problem with this same configuration using a MB with an
> nvidia chipset. I suspect it might have something to do with the the MB
> that usines the AMD chipset having an IOMMU, but I really don't know for
> sure. I've also read something in the AMD chipset docs about some type
> of restrictions on peer to peer transfers but again I really have no
> idea if this is related to why I'm having this problem.
>
> Any pointers from anyone (even an AMD guy) out there would again be
> appreciated.
>
