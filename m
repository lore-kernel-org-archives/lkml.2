Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab1ESP4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:56:15 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.104]:58776 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1ESP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:56:14 -0400
Message-ID: <4DD53E2B.2090002@ladisch.de>
Date: Thu, 19 May 2011 17:58:35 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Leon Woestenberg <leon.woestenberg@gmail.com>
CC: linux-pci@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmap() implementation for pci_alloc_consistent() memory?
References: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com> <20110519145921.GE9854@dumpdata.com>
In-Reply-To: <20110519145921.GE9854@dumpdata.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
> On Thu, May 19, 2011 at 12:14:40AM +0200, Leon Woestenberg wrote:
> > I cannot get my driver's mmap() to work. I allocate 64 KiB ringbuffer
> > using pci_alloc_consistent(), then implement mmap() to allow programs
> > to map that memory into their user space.
> > ...
> > int ringbuffer_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > {
> >         /* the buffer allocated with pci_alloc_consistent() */
> > 	void *vaddr = ringbuffer_virt;
> > 	int ret;
> > 
> > 	/* find the struct page that describes vaddr, the buffer
> > 	 * allocated with pci_alloc_consistent() */
> > 	struct page *page = virt_to_page(lro_char->engine->ringbuffer_virt);
> > 	vmf->page = page;
> > 
> >         /*** I have verified that vaddr, page, and the pfn correspond with vaddr = pci_alloc_consistent() ***/
> > 	ret = vm_insert_pfn(vma, address, page_to_pfn(page));
> 
> address is the vmf->virtual_address?
> 
> And is the page_to_pfn(page) value correct? As in:
> 
>   int pfn = page_to_pfn(page);
> 
>   WARN(pfn << PAGE_SIZE != vaddr,"Something fishy.");
> 
> Hm, I think I might have misled you now that I look at that WARN.
> 
> The pfn to be supplied has to be physical page frame number. Which in
> this case should be your bus addr shifted by PAGE_SIZE. Duh! Try that
> value.

There are wildly different implementations of pci_alloc_consistent
(actually dma_alloc_coherent) that can return somewhat different
virtual and/or physical addresses.

> I think a better example might be the 'hpet_mmap' code

Which is x86 and ia64 only.

> > static int ringbuffer_mmap(struct file *file, struct vm_area_struct *vma)
> > {
> > 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

So is this an architecture without coherent caches?
Or would you want to use pgprot_dmacoherent, if available?


I recently looked into this problem, and ended up with the code below.
I then decided that streaming DMA mappings might be a better idea.


Regards,
Clemens


/* returns the struct page from the result of dma_alloc_coherent() */
struct page *dma_coherent_page(struct device *device,
                               void *address, dma_addr_t bus)
{
#if defined(CONFIG_ALPHA) || \
    defined(CONFIG_CRIS) || \
    defined(CONFIG_IA64) || \
    defined(CONFIG_MIPS) || \
    (defined(CONFIG_PPC) && !defined(CONFIG_NOT_COHERENT_CACHE)) || \
    defined(CONFIG_SPARC64) || \
    defined(CONFIG_TILE) || \
    defined(CONFIG_UNICORE32) || \
    defined(CONFIG_X86)
#ifdef CONFIG_MIPS
	if (!plat_device_is_coherent(device))
		address = CAC_ADDR(address);
#endif
	return virt_to_page(address);
#elif defined(CONFIG_ARM)
	return pfn_to_page(dma_to_pfn(device, bus));
#elif defined(CONFIG_FRV) || \
      defined(CONFIG_MN10300)
#ifdef CONFIG_MN10300
	if (WARN(!IS_ALIGNED(bus, PAGE_SIZE)), "PCI SRAM allocator is broken\n")
		return NULL;
#endif
	return virt_to_page(bus_to_virt(bus));
#elif defined(CONFIG_M68K) || \
      defined(CONFIG_SPARC32)
	return virt_to_page(phys_to_virt(bus));
#elif defined(CONFIG_PARISC)
	return virt_to_page(__va(bus));
#elif defined(CONFIG_SUPERH)
	return pfn_to_page(bus >> PAGE_SHIFT);
#elif defined(CONFIG_MICROBLAZE) || \
      (defined(CONFIG_PPC) && defined(CONFIG_NOT_COHERENT_CACHE))
	unsigned long vaddr = (unsigned long)address;
	pgd_t *pgd = pgd_offset_k(vaddr);
	pud_t *pud = pud_offset(pgd, vaddr);
	pmd_t *pmd = pmd_offset(pud, vaddr);
	pte_t *pte = pte_offset_kernel(pmd, vaddr);
	if (!pte_none(*pte) && pte_present(*pte)) {
		unsigned long pfn = pte_pfn(*pte);
		if (pfn_valid(pfn))
			return pfn_to_page(pfn);
	}
	return NULL;
#elif defined(CONFIG_XTENSA)
#error non-cacheable remapping not implemented
#else
#error unknown architecture
#endif
}
