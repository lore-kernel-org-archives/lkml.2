Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1ESO7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 10:59:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22877 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESO7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 10:59:38 -0400
Date: Thu, 19 May 2011 10:59:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmap() implementation for pci_alloc_consistent() memory?
Message-ID: <20110519145921.GE9854@dumpdata.com>
References: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4DD53057.013F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 12:14:40AM +0200, Leon Woestenberg wrote:
> Hello,
> 
> I cannot get my driver's mmap() to work. I allocate 64 KiB ringbuffer
> using pci_alloc_consistent(), then implement mmap() to allow programs
> to map that memory into their user space.
> 
> My driver writes 0xDEADBEEF into the first 32-bit word of the memory
> block. When I dump this word from my mmap.c program, it reads 0. It
> seems a zero-page got mapped rather than the buffer.
> 
> This is the code, Ieft out all error checking but inserted comments to
> show what I have verified.
> 
> int main(void)
> {
>   int fd = open("/device_node", O_RDWR | O_SYNC);
>   uint32_t *addr = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>   uint32_t data = *addr;
>   printf("address 0x%p reads data 0x%08x\n", addr32, (unsigned int)data);
>   munmap(addr, 4096);
>   close(fd);
> }
> 
> 
> void ringbuffer_vma_open(struct vm_area_struct *vma)
> {
> }
> 
> void ringbuffer_vma_close(struct vm_area_struct *vma)
> {
> }
> 
> int ringbuffer_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> {
>         /* the buffer allocated with pci_alloc_consistent() */
> 	void *vaddr = ringbuffer_virt;
> 	int ret;
> 
> 	/* find the struct page that describes vaddr, the buffer
> 	 * allocated with pci_alloc_consistent() */
> 	struct page *page = virt_to_page(lro_char->engine->ringbuffer_virt);
> 	vmf->page = page;
> 
>         /*** I have verified that vaddr, page, and the pfn correspond
> with vaddr = pci_alloc_consistent() ***/
> 	ret = vm_insert_pfn(vma, address, page_to_pfn(page));

address is the vmf->virtual_address?

And is the page_to_pfn(page) value correct? As in:

  int pfn = page_to_pfn(page);

  WARN(pfn << PAGE_SIZE != vaddr,"Something fishy.");

Hm, I think I might have misled you now that I look at that WARN.

The pfn to be supplied has to be physical page frame number. Which in
this case should be your bus addr shifted by PAGE_SIZE. Duh! Try that
value.

I think a better example might be the 'hpet_mmap' code as it is simpler
and it also adds the VM_IO flag.

> 	return ret;
> }
> 
> static const struct vm_operations_struct ringbuffer_vm_ops = {
> 	.fault          = ringbuffer_vma_fault,
> };
> 
> static int ringbuffer_mmap(struct file *file, struct vm_area_struct *vma)
> {
>         <...extract private data...>
> 
> 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> 
> 	vma->vm_flags |= VM_RESERVED | VM_MIXEDMAP;
> 	vma->vm_private_data = file->private_data;
> 	vma->vm_ops = &ringbuffer_vm_ops;
> 	ringbuffer_vma_open(vma);
> 	return 0;
> }
> 
> What did I miss?

I gave you the wrong data :-(
