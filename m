Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0G1KO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:14:27 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:49830 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab0G1KO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:14:26 -0400
Message-ID: <4C5002AD.6070206@cyconix.com>
Date: Wed, 28 Jul 2010 11:13:01 +0100
From: Evan Lavelle <sa212+account@cyconix.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm writing a driver for a PCIe card which has to support DMA.

I can get this to work by using 'pci_alloc_consistent' to get a coherent 
mapping for a DMA buffer (when I pass the returned 'dma_addr_t' to my 
card, it can use it to successfully DMA into the PC).

The problem is that I actually want to use a streaming mapping, for 
direct I/O, with a scatter-gather list, and I can't get this to work. 
'pci_map_sg' returns me a bus address for the user's read buffer, but 
this doesn't appear to be a valid bus address. When the PCIe card DMAs 
to this bus address, the DMA operation appears to complete, but the 
user's read buffer is not modified. Any ideas?

This is the code that works:

dmaCPUAddr = pci_alloc_consistent(
    PCI_Dev_Cfg, dmaBufSize, dmaPCIBusAddr);

This allocates a 64KB kernel buffer. The PCIe card can DMA into this 
buffer, and I can then copy this buffer back to the user. 
'dmaPCIBusAddr' is set to something in the region of 0x32xxxxxx to 
0x34xxxxxx (on x86), so this is presumably a valid bus address into 
kernel memory.

This is a simplified version of the code which doesn't work:

===================================================
// get bus addresses to DMA into user memory
// 'userAddr', for 'npages' pages

down_read(&current->mm->mmap_sem);
ret = get_user_pages(
    current, current->mm, userAddr,
    numPages, 1, 1, pageList, NULL);
up_read(&current->mm->mmap_sem);

if(ret != numPages) {...error}

...'kmalloc' and clear scatterlist 'sgList'

for(i = 0; i < numPages; i++) {
    if(pageList[i] == NULL)
       ... error
    sgList[i].page   = pageList[i];
    sgList[i].offset = 0;
    sgList[i].length = PAGE_SIZE;
}

sgLen = pci_map_sg(
    pPciDev,       // the PCI device
    sgList,        // the place to store the list
    numPages,      // how many initial pages are in it
    direction);    // data flow direction

if(sgLen == 0) { ...error }

{  // DEBUG
    struct scatterlist *sg = sgList;
    for(i = 0; i < sgLen; i++, sg++)
       printk(
          KERN_INFO "busAddr 0x%08x; len %d\n",
          (u32)sg_dma_address(sg), sg_dma_len(sg));
}
===================================================

For one page of user memory, 'sg_dma_address' returns a bus address in 
the region of 0x13xxxxxx (on x86). When the PCIe card tries to DMA to 
this address, the data disappears - I can't see it in my userland test 
program. Any ideas?

Thanks -

Evan

================================================

Extra information:

- modern x86_64 HP multiprocessor server motherboard, running 32-bit 
RHEL 5.1

- 2.6.18-53el5xen, i686/athlon/i386

- 'page_address(pageList[0])' sometimes returns NULL, which I find 
surprising - isn't this meant to be locked down?

- 'kmap(pageList[0])' always returns a valid address, and I can use this 
address to write directly to the user-space buffer from the driver

- 'virt_to_bus', 'virt_to_phys', and '__pa' don't seem to do anything 
useful on this platform; they just give a fixed offset from the user 
virtual address, which is nowhere near the bus address which works
