Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1ERWOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:14:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60417 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1ERWOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sciglwmM/sRGuLiH632Nct8UWaU3tEovjJWAyIiu5RYdswM2jjjmWaC95+mFqFbAIi
         e4q1XJzSYBWc63RMDsWjx8PbLjTcXedrH6QXxvt7B4NrdLK8MIBOief5+GD19EQrg09f
         OSYQf6mebXgLCjh1WFxyici0xRu0gP9+OBxaw=
MIME-Version: 1.0
Date: Thu, 19 May 2011 00:14:40 +0200
Message-ID: <BANLkTi==cinS1bZc_ARRbnYT3YD+FQr8gA@mail.gmail.com>
Subject: mmap() implementation for pci_alloc_consistent() memory?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: linux-pci@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I cannot get my driver's mmap() to work. I allocate 64 KiB ringbuffer
using pci_alloc_consistent(), then implement mmap() to allow programs
to map that memory into their user space.

My driver writes 0xDEADBEEF into the first 32-bit word of the memory
block. When I dump this word from my mmap.c program, it reads 0. It
seems a zero-page got mapped rather than the buffer.

This is the code, Ieft out all error checking but inserted comments to
show what I have verified.

int main(void)
{
  int fd = open("/device_node", O_RDWR | O_SYNC);
  uint32_t *addr = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  uint32_t data = *addr;
  printf("address 0x%p reads data 0x%08x\n", addr32, (unsigned int)data);
  munmap(addr, 4096);
  close(fd);
}


void ringbuffer_vma_open(struct vm_area_struct *vma)
{
}

void ringbuffer_vma_close(struct vm_area_struct *vma)
{
}

int ringbuffer_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
{
        /* the buffer allocated with pci_alloc_consistent() */
	void *vaddr = ringbuffer_virt;
	int ret;

	/* find the struct page that describes vaddr, the buffer
	 * allocated with pci_alloc_consistent() */
	struct page *page = virt_to_page(lro_char->engine->ringbuffer_virt);
	vmf->page = page;

        /*** I have verified that vaddr, page, and the pfn correspond
with vaddr = pci_alloc_consistent() ***/
	ret = vm_insert_pfn(vma, address, page_to_pfn(page));
	return ret;
}

static const struct vm_operations_struct ringbuffer_vm_ops = {
	.fault          = ringbuffer_vma_fault,
};

static int ringbuffer_mmap(struct file *file, struct vm_area_struct *vma)
{
        <...extract private data...>

	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

	vma->vm_flags |= VM_RESERVED | VM_MIXEDMAP;
	vma->vm_private_data = file->private_data;
	vma->vm_ops = &ringbuffer_vm_ops;
	ringbuffer_vma_open(vma);
	return 0;
}

What did I miss?

Regards,
-- 
Leon
