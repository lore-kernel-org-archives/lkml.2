Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1GBByo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 21:54:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40061 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1GBByn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 21:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinWkJa0zWgV7RVWtt4d3qf9dapFkg@mail.gmail.com>
References: <BANLkTinWkJa0zWgV7RVWtt4d3qf9dapFkg@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 1 Jul 2011 21:54:22 -0400
Message-ID: <BANLkTimF0AsS3=-S=gmbcjBC5JuKr=6Prw@mail.gmail.com>
Subject: Re: [PCI Driver]Physical address being returned as 0 in mmap
To: newton mailinglist <newtonmailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 20:05, newton mailinglist
<newtonmailinglist@gmail.com> wrote:
> I have written a PCI driver for my device. The device is an FPGA which
> is configured with a design that allows it to have direct access to
> memory of a host computer to which the fpga board is connected. My
> device driver is responsible for translating virtual addresses to
> physical addresses and sending these to the FPGA so the DMA unit in
> the FPGA can directly access pages in memory using the physical
> address.
>
> [...snip...]
>
> When the driver gets the above call then I assume the kernel has
> already allocated the required space and its details are in the vma
> parameter. When I try to view the physical address of the virtual
> address in the vma i use :
>
> virt_to_phys(vma->vm_start)

You should not use virt_to_phys().  On most systems it does not work
for all memory, and on some (with an IOMMU) it would need to give a
different result depending on the device.

What you are looking for is the DMA API:

  http://lxr.linux.no/#linux/Documentation/DMA-API-HOWTO.txt
  http://lxr.linux.no/#linux/Documentation/DMA-API.txt

Specifically, you need to specify the DMA address mask of your FPGA
since not all devices can access 100% of the address space, some
are limited to 24/31/32/40-bit address spaces.  See dma_set_mask().

If you don't need fully coherent memory (as described in those docs),
then you can simply allow read() and write() on your device node and
perform DMA mapping of the userspace memory using dma_map_*().

Otherwise you will mmap() the device and use dma_alloc_coherent()
or dma_pool_*(), this is typical for things like TX queues and such.

Then make sure to insert calls to dma_sync_*() when switching
between CPU access to memory and device access to memory,
and ensure that you use appropriate IO memory barriers to order
your register reads and writes.

If you don't follow the DMA API specifications then your driver will
mysteriously fail on many platforms, even x86 if an IOMMU is present,
but particularly on processors like ARM with poor cache coherency.

Cheers,
Kyle Moffett
