Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1GCCMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 22:12:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60582 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab1GCCMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 22:12:23 -0400
MIME-Version: 1.0
In-Reply-To: <CABBBjTJkisyWsRBn28Lj5vCne5qbKP0qSVvM0ytXF_Y8O29_3A@mail.gmail.com>
References: <BANLkTinWkJa0zWgV7RVWtt4d3qf9dapFkg@mail.gmail.com>
 <BANLkTimF0AsS3=-S=gmbcjBC5JuKr=6Prw@mail.gmail.com> <BANLkTimp2cafUrALLdqeSBWeMsA+ybiUpQ@mail.gmail.com>
 <BANLkTikO+cUbCFPAuNSE01xSmOzhwWP0mQ@mail.gmail.com> <BANLkTimAHc6+ZPd7gUpr0-eHGpyLSwJFEA@mail.gmail.com>
 <CABBBjTJkisyWsRBn28Lj5vCne5qbKP0qSVvM0ytXF_Y8O29_3A@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 2 Jul 2011 22:12:00 -0400
Message-ID: <CAGZ=bqJqYBmbOHZ+LcG2_yiwZbgLwxNeWp+CYcvsEhdpaz-Gow@mail.gmail.com>
Subject: Re: [PCI Driver]Physical address being returned as 0 in mmap
To: newton mailinglist <newtonmailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I think I understand better, further comments below.

As I asked before... please don't top-post, it is considered rude on LKML.

You should reply in-line with the other person's comments, and remove
anything not immediately relevant to the reply.

> Once the fpga receives this address it sends an interrupt to the OS to
> translate the address to a physical address which the fpga can then
> send to the dma unit. This virtual to physical address translation is
> done in the driver. So this address translation interrupt is different
> from an execution completion interrupt and there is code in place in
> the interrupt handler to distinguish these 2 types of interrupts
> properly.  The actual address translation happens in
> translate_address() defined in the device driver file. The address
> translation involves pinning the requested user page to the memory
> using get_user_pages() and then getting the physical address using
> pci_map_page(). This works because the calling process is asleep when
> this happens.

I think that there are some hardware issues here that you might not have
hit in your specific environment yet but are likely to be a problem.

First of all, you need to make sure you have all of the cache and DMA
flushes correct.  *ALL* memory that the FPGA might access while running
the user code must be cache flushed and appropriately dma_sync_*()ed.
Otherwise your FPGA will read old data.

This means in particular that you can't really read arbitrary data from the
program memory, you need to enumerate everything that the hardware
needs in advance from the kernel, or be able to flush it on demand, which
is somewhat of a performance killer.

Furthermore, many modern x86_64 systems have an "IO-MMU" which
controls access to memory individually for each device.  It essentially
provides individual page-tables for each physical device in the system
similar to the way the kernel provides virtual addressing for user programs.
If a piece of memory is not mapped in the IO-MMU then it can not be
accessed by the device at all, and even if it is mapped you need to
know the mapping address for that memory from *that* device.

Again, this boils down to the fact that you need to know in advance
(for performance reasons) exactly which user memory you want to use.


> Note that even while executing a C function which is accessing a large
> amount of data from memory, the FPGA only gets the virtual address of
> the array(in the exchange registers) and it requests a translation to
> the physical address, which is sent to the dma unit. So I decided to
> use the same process for sending the configuration data as well.

So basically what this means is that for each userspace address range
that the FPGA requests a translation for, you need to get_user_pages(),
and then dma_map_page() each page of that, and then dma_sync_*()
those pages for bidirectional access.  Unfortunately none of that can be
done from an interrupt handler (if I recall correctly) and none of it will
be fast.

Make sure you're following the locking requirements described in the
get_user_pages() documentation.


> So to improve the system what I did was not put the process to sleep
> but to let it continue. Thus i want to  continue receiving address
> translation interrupts from the fpga and then send physical addresses
> to it while the C program runs.

This is going to be a particularly bad problem.

When you are writing multi-threaded userspace programs, you MUST
ensure that you use appropriate locking operations and memory barriers,
and then your hardware will enforce cache-coherency between CPUs.

But you are effectively creating a multi-processor system *without*
full cache-coherency between your FPGA and the system CPU.  You
will need to be extremely careful to perform the cache flushes and the
DMA sync operations on the CPU in order to guarantee correctness.

And I can almost guarantee it won't be very fast.


As for the rest of it, it looks fine to me but I haven't really ever tried
to do anything that complicated.  It's already complicated enough
for me when programming a simple network controller with TX/RX
queues and such.

Good luck!

Cheers,
Kyle Moffett
