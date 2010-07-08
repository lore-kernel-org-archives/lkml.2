Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab0GHXji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:39:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:35370 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab0GHXjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:39:37 -0400
Date: Thu, 8 Jul 2010 16:39:23 -0700
From: Greg KH <gregkh@suse.de>
To: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Cc: linux-kernel@vger.kernel.org, hjk@linutronix.de,
       Michal Simek <michal.simek@petalogix.com>,
       John Williams <john.williams@petalogix.com>
Subject: Re: UIO: munmap bug for boot time allocated memory
Message-ID: <20100708233923.GB8671@suse.de>
References: <AANLkTikuRjaAUF5KOn1QnVU8VnUiSNPkoKkkBdipXooY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikuRjaAUF5KOn1QnVU8VnUiSNPkoKkkBdipXooY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 04:36:02PM +1000, Peter Crosthwaite wrote:
> Hi,
> 
> I'm currently experiencing a kernel bug when munmap'ing a UIO memory region.
> The uio memory region is a large (up to 48MB) buffer allocated by a UIO
> driver at boot time using alloc_bootmem_low_pages(). The idea is once the
> large buffer is allocated, devices can DMA directly to the buffer which is
> user space accessible. The system is tested as working, with the DMA device
> being able to fill the buffer and user space being able to see the correct
> data, except that it throws a bug once user space munmaps the UIO region.
> The bug is a "bad page state". I have summarized the kernel space the
> driver, the user space program and the bug below. My first question is - is
> there anything fundamentally incorrect with this approach / is there a
> better way?
> 
> The kernel version is (2.6.31.11) and architecture is MicroBlaze.
> 
> What happens in the kernel space driver:
> 
>     -The buffer is allocated at boot time using alloc_bootmem_low_pages()
> 
>         unsigned buf_size = 0x00010000; /*size of 64k */
>         b_virt = alloc_bootmem_low_pages(PAGE_
> ALIGN(buf_size));
> 
>     -The address returned is set as the base address for a UIO memory region
> and the UIO device is created:
> 
>         struct uio_info * usdma_uio_info;
>         ... //name version and IRQ are set
>         usdma_uio_info->mem[0].addr =b_virt; //This is the address returned
> by alloc_bootmem_low_pages()

Yeah, but is this a valid address that userspace has access to?  Or is
this a "virtual" address?  I thought you had to "remap" this memory to
properly access it but I don't know this architecture good enough to be
sure about that.

Have a pointer to your whole kernel driver anywhere?

>         usdma_uio_info->mem[0].size = buf_size;
>         usdma_uio_info->mem[0].memtype = UIO_MEM_LOGICAL;
>         usdma_uio_info->mem[0].internal_addr = b_virt;
>         uio_register_device(dev, usdma_uio_info);
> 
> What happens in the user space program:
> 
>     -The UIO device is opened and mmap'ed (to in_ptr)
> 
>         in_fd=open("/dev/uio0",O_RDWR);
>         char * in_ptr=mmap(NULL, size, PROT_READ, MAP_SHARED, in_fd, 0);
>         if(!in_ptr) {
>             perror("mmap:");
>             return -1;
>         }
> 
>     -Write the buffer out to some random file (out_fd)
> 
>         for (bytes_written = 0; bytes_written < size;) {
>             bytes_written += write(out_fd, in_ptr+bytes_written, size);
>         }

Is this showing the correct data?

>     -The UIO memory region is unmap (this is when the error occurs)
> 
>         munmap(in_ptr, size);
> 
> The bug:
> 
> The output from dmesg (after the user space program is run) is below. This
> output happens multiple times, i.e. the bug is replicated for all the mapped
> pages. Curiously, the bug only happens when the pages are touched by the
> user space program, e.g. if the example user space program given above does
> not write() the buffer contents out to file, the bug does not occur (and the
> munmap completes successfully).
> 
> Further investigation revealed that the reason the bad_page function was
> being called is that free_hot_cold_pages (mm/page_alloc.c) does not like
> pages with either the PG_slab or PG_buddy flags set. The bug will always
> show one of these flags being set (PG_slab = 0x00000080 in the case below),
> for the page that is being freed. Which flag is set depends on the size of
> the buffer - small buffers its PG_slab large buffers its PG_buddy.
> 
> My second question is should the kernel be trying to free these pages (using
> free_hot_cold_page) at all?? - Considering my kernel space driver still has
> them mapped locally??

Good question, who is trying to free them?

wierd.

greg k-h
