Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab1FSSJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 14:09:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34601 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1FSSJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 14:09:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=q8/B8LrEJIZWERGxUceN1NfL8JxOfTcMYFFJEY47h7oKAuJ+kx9f90KZf4vY7bROS8
         u9hBsF9ok+fOhvnFEDjagHv2xpb7gzTXCsJBEARNkudBD46v9OP6LVFewdnysHhT6WR8
         zfBGJi3WOKzNwV4GSUQ4zUV72RTnh0PamGd1g=
MIME-Version: 1.0
Date: Sun, 19 Jun 2011 20:09:08 +0200
Message-ID: <BANLkTimU=FL-QG9KcGbYOegfizf5HNH+ZQ@mail.gmail.com>
Subject: [PCI Driver Help] Locking Pages of a running process
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
the FPGA can directly access pages in memory.

I have a C program which uses the driver to open this PCI device and
then sends a command to the device, so it can begin accessing
memory(for some calculations done in the fpga). This is done via
IOCTL. The FPGA sends an interrupt when its done. However my program
does not wait for the FPGA but instead resumes execution immmediately
after the IOCTL call returns. If the FPGA has a virtual address which
it needs to translate, it interrupts my PCI driver and I want to
translate this address in the interrupt handler and write back the
translated address to the device using memory mapped I/O.

The issue is that when my driver gets the virtual address, it attempts
to lock the user space pages first(those of the running C program) in
memory using get_user_pages() and then translates the address using
pci_map_page(). Pinning the pages in memory is needed as the fpga will
access them later using DMA. Here is the code I use   :

//get page
result = get_user_pages(htex_dev->tsk, htex_dev->tsk->mm, virt_addr,
1, 1, 0, &page, NULL);
if (result <= 0)
{
	ERROR_MSG("unable to get page\n");
	return 0;
}
//get bus address of page
translated = pci_map_page(htex_dev->dev, page, 0, PAGE_SIZE, DMA_BIDIRECTIONAL);

update_htx_tlb(index, tag, translated, htex_dev);

However the call fails with -14 (bad address) everytime. It appears
that perhaps the running C program's process pages cannot be accessed
by the ISR to lock them in memory.

Yet I need to allow the program to run while the driver services
interrupts in the background. This is for performance reasons as
halting the program would waste time.

If I do put the program to sleep when it makes the IOCTL call using
wait_event_interruptible() :

static int htex_ioctl(struct inode *inode, struct file *filp, unsigned
int cmd, unsigned long arg)
{
	struct htex_dev_t *htex_dev = filp->private_data;
	int result;	
	....
	switch (cmd)
	{
		case HTEX_IOSET:
		//reset the tlb and ccu
		iowrite32(HTEX_RESET_C, htex_dev->bar2->bar);
		*(((u64 *)htex_dev->bar2->bar) + 1) = arg;	
		u32 temp;
		temp = ioread32(htex_dev->bar2->bar+16);
		iowrite32(HTEX_SET_C, htex_dev->bar2->bar);	
		result = wait_event_interruptible(wait_queue, htex_dev->done != 0);
// <------------------
		....
}

then it does work, but this is probably due to the fact that the
process is sleeping and its pages can be locked in memory.

So how should I be doing the address translation with the user space
process running?

Thanks,
Abh
