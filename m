Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1GLO0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 10:26:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38701 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab1GLO0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 10:26:46 -0400
MIME-Version: 1.0
Date: Tue, 12 Jul 2011 16:26:45 +0200
Message-ID: <CABBBjTJYQMU=sYDuGqqNdVK3mcAYDO2G10-8YOCd3BQMJpvYtg@mail.gmail.com>
Subject: How to pin the user pages of a running process in memory
From: newton mailinglist <newtonmailinglist@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: v.venkatasubramanian@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an FPGA device that is capable of DMA and I have written a PCI
driver to manage it.

The device needs to access large arrays in memory which have been
declared through a C program.
The program declares the array using :
long *A;
posix_memalign(&A, 64, sizeof(long)*count);

which gives me contiguous and page aligned arrays in virtual space only.
Then I signal the FPGA to start accessing the data using an IOCTL
call. However the program continues to run as I dont wait in the IOCTL
call.

The FPGA sends interrupts to the PCI device driver with the user space
virtual address whenever it needs a user page. So I do know the user
space virtual address in the interrupt handler(the user space array
addresses are written to the FPGA beforehand to enable this)

To simplify the situation, the array data is no longer changed or
modified by the program anymore once the FPGA begins accessing it.

So what I want to do is pin these pages to memory, get their
consequent physical address and give it to the FPGA for accessing the
pages in physical memory.
However get_user_pages() fails to pin the pages, perhaps because the
process to which the pages belong is running.

The following is the function which does the pinning of user pages and
translation to physical addresses :

int translate_address(unsigned long int virt_addr, struct htex_dev_t *htex_dev)
{
	int result;
	unsigned long int translated;
	unsigned long int index = 0;
	unsigned long int tag = 0;
	struct page *page;
	
	index = virt_to_index(virt_addr);
	tag = virt_to_tag(virt_addr);
	
	//check if index already has a valid entry and if so
	//release this entry before replacing it
	if(htex_dev->entries[index].page)
		release_page(htex_dev, index);
	
	result = get_user_pages(htex_dev->tsk, htex_dev->tsk->mm, virt_addr,
1, 1, 0, &page, NULL);
	if (result <= 0)
	{
		ERROR_MSG("unable to get page\n"); iob , lb 01.620
		return 0;
	}
	//get bus address of page
	translated = pci_map_page(htex_dev->dev, page, 0, PAGE_SIZE,
DMA_BIDIRECTIONAL);
	
	update_htx_tlb(index, tag, translated, htex_dev);
	DEBUG_MSG("translate_address: index:%lx , tag:%lx, virtual: %lx ->
translated : %lx\n", index, tag, virt_addr, translated);
	
        //update entry in array
	htex_dev->entries[index].page = page;
	htex_dev->entries[index].hw_addr = translated;	

	return 1;
}

I know that this can be solved by allocating a DMA buffer using the
DMA API and copying the user data to this buffer using
copy_from_user(), then sending the address of the buffer to the fpga.

But the issue is I do not know the size of the array when the FPGA
requests data. So I cannot use the above method as the I do not know
how much buffer space to allocate.
I also thought I could copy_from_user() the requested page data into a
DMA buffer of PAGESIZE length and then tell the FPGA to read from the
DMA buffer always.

This allows me to allocate the DMA buffer beforehand, and only the
buffer contents change based on the requested page. But
copy_from_user() or memcpy() being called every time a page is
requested is an overhead and causes loss of speed gained by using the
FPGA as the FPGA has to wait each time for the address translation to
complete in software.

So I was wondering if user pages can be pinned while the owning
process is running in some way, and why get_user_pages() would fails
to so .

Thanks,
Abhi
