Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977Ab0IGEVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:21:13 -0400
Received: from [69.28.251.93] ([69.28.251.93]:48087 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab0IGEVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:21:09 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2010 00:21:09 EDT
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 6 Sep 2010 21:03:42 -0700
Subject: [PATCH 0/5] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <dediao@cisco.com>, <dvomlehn@cisco.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Message-Id: <ea0143cf318153e615b660cb0210f464@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had some time this weekend to revisit an old problem:

http://www.linux-mips.org/archives/linux-mips/2010-05/msg00009.html


PROBLEM #1:

When testing Dezhong's patch, I found that un-kmapped pages could get
passed into dma_map_sg().  The original patch did not handle this case.
This resulted in serious DMA coherency issues on my system, along the
lines of "/sbin/init segfaults on boot."

I found that this calling sequence, seen during SATA disk I/O, was the
culprit:

[<8002b3d4>] dma_map_sg+0x2ac/0x2b8                                             
[<802cdb70>] ata_qc_issue+0x274/0x37c                                           
[<802d383c>] ata_scsi_translate+0xb0/0x1e8                                      
[<802d7274>] ata_scsi_queuecmd+0xc8/0x2b8                                       
[<802b0630>] scsi_dispatch_cmd+0x118/0x2b8                                      
[<802b6c64>] scsi_request_fn+0x420/0x4d8                                        
[<80239550>] __blk_run_queue+0x84/0x19c                                         
[<802364a0>] elv_insert+0x158/0x2e4                                             
[<8023a398>] __make_request+0x11c/0x4d0                                         
[<80238144>] generic_make_request+0x348/0x4a0                                   
[<80238330>] submit_bio+0x94/0x13c                                              
[<80114024>] mpage_bio_submit+0x30/0x40                                         
[<80115a2c>] mpage_readpages+0x134/0x170                                        
[<800a4fd4>] __do_page_cache_readahead+0x214/0x314                              

__do_page_cache_readahead() allocates a bunch of pages for the I/O
requests, but I do not see them getting mapped to kernel addresses via
kmap() / kmap_atomic().  This explains why (PageHighMem(page) &&
!kmap_high_get(page)) can be true.

I do not think there is anything wrong with this behavior, so it seems
like dma_map_sg() will need to handle it somehow.  Looking at other
architectures:

The PPC approach (__dma_sync_page_highmem()) is to disable IRQs and call
kmap_atomic() to create a temporary mapping for the page.  Disabling
IRQs is necessary because it is possible (but not required) for the
dma_* functions to be invoked from interrupt context; it also disables
preemption.  kmap_atomic() guarantees a unique mapping per CPU.

Interestingly, PPC does not use kmap_high_get() at all.

The ARM approach (kmap_high_l1_vipt()) recognizes that it is not always
desirable to keep IRQs disabled during DMA flushes, so the ARM
maintainers implemented a sort of "reentrant kmap_atomic()" that allows
multiple contexts to share the same pte by saving and restoring whatever
was there prior to the DMA sync.

Due to its use of kmap_high_get(), the ARM approach suffers from problem
#2, below.  It is also more complex and harder to test.  I'm not sure
how to recreate some of the worst corner cases, e.g. hardirq cacheflush
interrupts a softirq cacheflush which interrupted a user cacheflush.

Dezhong's patch was largely based on the ARM scheme, minus the
kmap_high_l1_vipt() logic.  I am sending an update to this patch which
attempts to imitate the PPC approach instead.  There is a considerable
amount of reuse since both strategies require similar modifications to
dma-default.c, in order to get that code to pass around "struct page"
pointers rather than kseg0 addresses.


PROBLEM #2:

Consider this sequence:

mm/highmem.c:kmap_high()
mm/highmem.c:map_new_virtual()
mm/highmem.c:flush_all_zero_pkmaps()
arch/mips/kernel/smp.c:flush_tlb_kernel_range()
kernel/softirq.c:on_each_cpu()
kernel/smp.c:smp_call_function()

The first thing kmap_high() does is lock_kmap(), which disables
interrupts on kmap_high_get() architectures:

#ifdef ARCH_NEEDS_KMAP_HIGH_GET
#define lock_kmap()             spin_lock_irq(&kmap_lock)
...
#else
#define lock_kmap()             spin_lock(&kmap_lock)
#endif

smp_call_function() may not be called with interrupts disabled:

 * You must not call this function with disabled interrupts or from a
 * hardware interrupt handler or from a bottom half handler.

So, on SMP, we get warnings like:

------------[ cut here ]------------                                            
WARNING: at kernel/smp.c:293 smp_call_function_single+0x17c/0x260()             
Modules linked in:
Call Trace:                                                                     
[<800160f0>] dump_stack+0x8/0x34                                                
[<8004a544>] warn_slowpath_common+0x78/0xa4                                     
[<8004a588>] warn_slowpath_null+0x18/0x24                                       
[<800876e4>] smp_call_function_single+0x17c/0x260                               
[<80087ca8>] smp_call_function+0x28/0x38                                        
[<800531b4>] on_each_cpu+0x1c/0x80                                              
[<80026d20>] flush_tlb_kernel_range+0x28/0x34                                   
[<800b95f4>] kmap_high+0x1dc/0x270                                              
[<8002a570>] __kmap+0x60/0x7c                                                   
[<801f15b4>] do_readpage+0x68/0x540                                             
[<801f218c>] ubifs_write_begin+0xbc/0x53c                                       
[<8009a558>] generic_perform_write+0xd4/0x1f0                                   
[<8009a6e4>] generic_file_buffered_write+0x70/0xbc                              
[<8009dd3c>] __generic_file_aio_write+0x2fc/0x600                               
[<8009e0b0>] generic_file_aio_write+0x70/0xf4                                   
[<800da864>] do_sync_write+0xc4/0x13c                                           
[<800db50c>] vfs_write+0xc0/0x168                                               
[<800db6ac>] sys_write+0x4c/0xa4                                                
[<80003d9c>] stack_done+0x20/0x3c                                               
                                                                                
---[ end trace 8abde6adefbcc81f ]---

I did some digging and found that ARM runs into the same problem.  For
processors that cannot "broadcast" TLB operations, SMP + HIGHMEM are
deemed incompatible:

http://www.spinics.net/lists/arm-kernel/msg74563.html

So, I would opt for the PPC approach in order to avoid this conflict.
Disabling SMP will result in a much nastier performance problem than
blocking interrupts during flushes.


PROBLEM #3:

Regarding David's flush_data_cache_page() concern:

http://www.linux-mips.org/archives/linux-mips/2008-03/msg00011.html


There are at least 4 reasons to flush the cache:

1) Boot time (cache contents are undefined at reset)

2) DMA coherence

3) I$/D$ coherence (self-modifying code)

4) Zap cache aliases


My interpretation of the code is that flush_dcache_page() is only called
for #3 and #4:

#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
static inline void flush_dcache_page(struct page *page)
{               
        if (cpu_has_dc_aliases || !cpu_has_ic_fills_f_dc)
                __flush_dcache_page(page);
                
}       


The fact that the L2 / board cache is not flushed in c-r4k.c leads me to
believe that #2 is not an intended use of this function:

static inline void local_r4k_flush_data_cache_page(void * addr)
{
        r4k_blast_dcache_page((unsigned long) addr);
}

Besides, we already have a standard, documented DMA API that should be
used instead.

Since this is not boot time, and HIGHMEM is incompatible with cache
aliases, that leaves #3 as a possible issue.  Is this function ever used
for I$/D$ coherence?

I should note that ARM has special handling in __flush_dcache_page() for
high pages.  IIRC, at one point they tried to support HIGHMEM on systems
with cache aliases, before deciding it was not feasible.  Maybe this
code is just a relic - or maybe it's really needed for something.

