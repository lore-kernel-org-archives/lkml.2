Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab1GBAFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 20:05:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53936 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1GBAFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 20:05:42 -0400
MIME-Version: 1.0
Date: Sat, 2 Jul 2011 02:05:41 +0200
Message-ID: <BANLkTinWkJa0zWgV7RVWtt4d3qf9dapFkg@mail.gmail.com>
Subject: [PCI Driver]Physical address being returned as 0 in mmap
From: newton mailinglist <newtonmailinglist@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have written a PCI driver for my device. The device is an FPGA which
is configured with a design that allows it to have direct access to
memory of a host computer to which the fpga board is connected. My
device driver is responsible for translating virtual addresses to
physical addresses and sending these to the FPGA so the DMA unit in
the FPGA can directly access pages in memory using the physical
address.

I want to send about 1 MB of data to the FPGA. I currently 1st mmap
the required data file in my c program as follows :

//Open the bitstream file
	int fd = open(filename, O_RDWR);
	if (fd < 0){
		perror("molen_set : Filename Open");
		return;
	}
	
	//Get bitstream file size
	fstat(fd, &buf);
	length = buf.st_size;
	if(length == 0){
		fprintf(stderr, "\nmolen_set : Empty input file\n");
		return;
	}
	
	//Map bitstream file to memory to read it in via page faults(faster
than explicit file I/O)
	bs_map = mmap(NULL, length, PROT_WRITE | PROT_READ, MAP_PRIVATE, fd, 0);

This allows the file to be read in via page faults.
Then I get a suitable area from the kernel using another mmap which is
called on the PCI device :

//Get user space address of empty kernel memory of length bytes
arg = mmap(NULL, length, PROT_WRITE | PROT_READ, MAP_PRIVATE, htex_handle, 0);

Then I copy the data using memcpy and signal the PCI device to start
reading the data using a IOCTL

The problem I have is in the mmap implementation in the PCI driver :

static int htex_mmap(struct file * file, struct vm_area_struct * vma)
{
   vma->vm_flags |= VM_RESERVED;

   if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
		vma->vm_end - vma->vm_start,
		vma->vm_page_prot))
		return -EAGAIN;
	
   vma->vm_ops = &htex_vm_ops;
   htex_vma_open(vma);
	
   return 0;
}

When the driver gets the above call then I assume the kernel has
already allocated the required space and its details are in the vma
parameter. When I try to view the physical address of the virtual
address in the vma i use :

virt_to_phys(vma->vm_start)

But this gives me back the original address. A call like :
 DEBUG_MSG("htex_mmap called start:%lx, end:%lx, size:%lx, pfn:%lx, pa:%lx\n",
		vma->vm_start, vma->vm_end, vma->vm_end - vma->vm_start,
	   vma->vm_pgoff, virt_to_phys(vma->vm_start));

gives me

start:7f14b5afc000, end:7f14b5c0d000, size:111000, pfn:0, pa:f714b5afc000

I am able to get the page associated with vm_pgoff using :

struct page *pg = pfn_to_page(vma->vm_pgoff);
DEBUG_MSG("htex_mmap page: page address : %lx\n", page_address(pg));

which gives me something like :
 page address :: ffff880000000000

But this does not appear to be the correct physical address.

So how can I get the physical address of the space that the kernel
just allocated in response to the user's mmap() call on the device ?

I need the correct  physical address later to send to the FPGA as well.

Thanks
Abhi
