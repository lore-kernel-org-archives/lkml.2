Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab0HDGHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:07:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61908 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab0HDGHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:07:54 -0400
MIME-Version: 1.0
Date: Wed, 4 Aug 2010 16:07:52 +1000
Message-ID: <AANLkTimK4NhXasetA4ZeeCeGSGySRNm8n=UgT+1oY_2g@mail.gmail.com>
Subject: Using Bootmem for large DMA buffers in the presence of the slab 
	allocator
From: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
To: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@cs.helsinki.fi, mpm@selenic.com,
        Michal Simek <michal.simek@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@petalogix.com>,
        John Williams <john.williams@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

I am currently developing Kernel code to allocate and reserve a large
(64MB) contiguous buffer for DMA. My approach is to use the the boot
time allocator (alloc_bootmem_low_pages()), with my module statically
linked into the kernel. I initially tried to call this function from
my kernel modules init() function, however on boot this would generate
a warning, indicating that the slab allocator was already available:

from mm/bootmem.c, in the alloc_arch_preferred_bootmem() function -
lines 541-542:

	if (WARN_ON_ONCE(slab_is_available()))
		return kzalloc(size, GFP_NOWAIT);


Because the buffer was too large for kmalloc, the kmalloc call would
fail. I traced the alloc_bootmem_low_pages() call further and
discovered that since the kmalloc call was failing, it was falling
back to alloc_bootmem_core(). So does this mean that the bootmem
allocator is trying to allocate memory while the slab allocator is up
and running? And is this supposed to work?

The reason i ask, is that when testing the system under high memory
usage conditions, I would get a "Bad page state" BUG() for my
allocated pages (see below). I have matched the pfns and confirmed
that they correspond to the pages allocated by the
alloc_bootmem_low_pages(). My theory is that the slab allocators list
of free pages does not get updated by the bootmem allocator, so the
slab allocator is seeing my DMA buffer as un-allocated. Does this
sound correct?

The only resolution i am seeing to this problem is to call the bootmem
allocator before the slab allocator is up and running, but as far as i
can tell, this requires editing one of the kernel start routines, or
the kernel_start() function itself. I have done this and it now works
without the bug, but is there a cleaner solution?

I am running linux 2.6.31 on the Microblaze architecture.

Thanks in Advance
Peter Crosthwaite
PetaLogix

BUG: Bad page state in process mst  pfn:4bc01
page:c09a0020 flags:(null) count:1 mapcount:0 mapping:(null) index:0

Stack:
  c0044150 c023f330 c6e5dd5c 00005f65 00004000 00004001 c6e5dd78 c0045024
  c01e0c0c c09a0020 00000000 00000001 00000000 00000000 00000000 c024b5a8
  c004525c 00000001 000004b8 c6e22000 00000001 000200da c010c188 c024b594
Call Trace:

[<c0044150>] bad_page+0x12c/0x160
[<c0045024>] get_page_from_freelist+0x318/0x43c
[<c004525c>] __alloc_pages_nodemask+0x114/0x594
[<c010c188>] ulite_transmit+0x78/0xf0
[<c0051dac>] handle_mm_fault+0x19c/0x48c
[<c0059fdc>] page_add_new_anon_rmap+0x68/0x94
[<c0009914>] do_page_fault+0x264/0x480
[<c01020b0>] tty_ldisc_deref+0x8/0x1c
[<c00fb210>] tty_write_unlock+0x14/0x44
[<c00081c8>] page_fault_instr_trap+0x1f8/0x200
[<c000ba00>] set_next_entity+0x28/0x70
[<c0062f78>] vfs_write+0xa4/0x150
[<c000bb3c>] __enqueue_entity+0xb0/0xd4
[<c0062ff0>] vfs_write+0x11c/0x150
[<c0016d78>] do_softirq+0x34/0x54
[<c000bd7c>] pick_next_task_fair+0x98/0xd4
[<c000bd88>] pick_next_task_fair+0xa4/0xd4
[<c000dd18>] put_prev_task_fair+0x48/0x70
[<c01d25cc>] schedule+0x1b4/0x414
[<c01d27e4>] schedule+0x3cc/0x414
[<c01d25a0>] schedule+0x188/0x414
[<c01d248c>] schedule+0x74/0x414
[<c01d2654>] schedule+0x23c/0x414
[<c0007738>] ret_from_trap+0x48/0x1d4
[<c0008550>] irq_call+0x0/0x8
