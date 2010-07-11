Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab0GKXvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 19:51:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54042 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0GKXvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 19:51:38 -0400
MIME-Version: 1.0
Date: Mon, 12 Jul 2010 09:51:37 +1000
Message-ID: <AANLkTinjGHMD13gNI1SBJt1WTQu9g7RgC1WgqaNoXdz6@mail.gmail.com>
Subject: UIO: munmap bug for boot time allocated memory
From: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend of earlier email due to first email bouncing]

Hi,

I'm currently experiencing a kernel bug when munmap'ing a UIO memory
region. The uio memory region is a large (up to 48MB) buffer allocated
by a UIO driver at boot time using alloc_bootmem_low_pages(). The idea
is once the large buffer is allocated, devices can DMA directly to the
buffer which is user space accessible. The system is tested as
working, with the DMA device being able to fill the buffer and user
space being able to see the correct data, except that it throws a bug
once user space munmaps the UIO region. The bug is a "bad page state".
I have summarized the kernel space the driver, the user space program
and the bug below. My first question is - is there anything
fundamentally incorrect with this approach / is there a better way?

The kernel version is (2.6.31.11) and architecture is MicroBlaze.

What happens in the kernel space driver:

   -The buffer is allocated at boot time using alloc_bootmem_low_pages()

       unsigned buf_size = 0x00010000; /*size of 64k */
       b_virt = alloc_bootmem_low_pages(PAGE_
ALIGN(buf_size));

   -The address returned is set as the base address for a UIO memory
region and the UIO device is created:

       struct uio_info * usdma_uio_info;
       ... //name version and IRQ are set
       usdma_uio_info->mem[0].addr =b_virt; //This is the address
returned by alloc_bootmem_low_pages()
       usdma_uio_info->mem[0].size = buf_size;
       usdma_uio_info->mem[0].memtype = UIO_MEM_LOGICAL;
       usdma_uio_info->mem[0].internal_addr = b_virt;
       uio_register_device(dev, usdma_uio_info);

What happens in the user space program:

   -The UIO device is opened and mmap'ed (to in_ptr)

       in_fd=open("/dev/uio0",O_RDWR);
       char * in_ptr=mmap(NULL, size, PROT_READ, MAP_SHARED, in_fd, 0);
       if(!in_ptr) {
           perror("mmap:");
           return -1;
       }

   -Write the buffer out to some random file (out_fd)

       for (bytes_written = 0; bytes_written < size;) {
           bytes_written += write(out_fd, in_ptr+bytes_written, size);
       }

   -The UIO memory region is unmap (this is when the error occurs)

       munmap(in_ptr, size);

The bug:

The output from dmesg (after the user space program is run) is below.
This output happens multiple times, i.e. the bug is replicated for all
the mapped pages. Curiously, the bug only happens when the pages are
touched by the user space program, e.g. if the example user space
program given above does not write() the buffer contents out to file,
the bug does not occur (and the munmap completes successfully).

Further investigation revealed that the reason the bad_page function
was being called is that free_hot_cold_pages (mm/page_alloc.c) does
not like pages with either the PG_slab or PG_buddy flags set. The bug
will always show one of these flags being set (PG_slab = 0x00000080 in
the case below), for the page that is being freed. Which flag is set
depends on the size of the buffer - small buffers its PG_slab large
buffers its PG_buddy.

My second question is should the kernel be trying to free these pages
(using free_hot_cold_page) at all?? - Considering my kernel space
driver still has them mapped locally??

BUG: Bad page state in process mmunmap_bug_hun  pfn:4ee0f
page:c09ff1e0 flags:00000084 count:0 mapcount:0 mapping:(null) index:0

Stack:
 c0044150 c023f330 c6e85d9c 00002095 44591000 00002095 c6e85db8 c0044958
 c01e0c10 c09ff1e0 00000084 00000000 00000000 00000000 00000000 c09ff1e0
 c0044b6c 00010000 00000000 c0048f08 c7468cf4 c6e85e60 00000000 c09ff1e0
Call Trace:

[<c0044150>] bad_page+0x12c/0x160
[<c0044958>] free_hot_cold_page+0x94/0x224
[<c0044b6c>] free_hot_page+0x8/0x1c
[<c0048f08>] ____pagevec_lru_add+0x194/0x1cc
[<c004935c>] put_page+0x164/0x178
[<c00fda5c>] process_output+0x40/0x74
[<c00fda6c>] process_output+0x50/0x74
[<c00511e8>] unmap_vmas+0x31c/0x5ac
[<c0051230>] unmap_vmas+0x364/0x5ac
[<c005577c>] unmap_region+0xb0/0x168
[<c0049164>] lru_add_drain+0x34/0x84
[<c005661c>] do_munmap+0x200/0x298
[<c00566f0>] sys_munmap+0x3c/0x74
[<c01d3054>] down_write+0xc/0x20
[<c00635e8>] sys_write+0x54/0xa4
[<c000568c>] sys_mmap2+0x108/0x13c
[<c00076e8>] _user_exception+0x228/0x230
[<c0008550>] irq_call+0x0/0x8

Thanks in Advance,
Peter Crosthwaite
Petalogix
