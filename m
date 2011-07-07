Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1GGLzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 07:55:46 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:53048 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab1GGLzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 07:55:45 -0400
Date: Thu, 7 Jul 2011 17:25:31 +0530
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        anton@samba.org, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
Message-ID: <20110707115531.GA21737@in.ibm.com>
Reply-To: mahesh@linux.vnet.ibm.com
References: <20110707102107.GA16666@in.ibm.com>
 <1310036375.3282.509.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310036375.3282.509.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-07 12:59:35 Thu, Peter Zijlstra wrote:
> On Thu, 2011-07-07 at 15:52 +0530, Mahesh J Salgaonkar wrote:
> > 
> > 2.6.39 booted fine on the system and a git bisect shows commit cd4ea6ae -
> > "sched: Change NODE sched_domain group creation" as the cause.
> 
> Weird, there's no locking anywhere around there. The typical problems
> with this patch-set were massive explosions due to bad pointers etc..
> But not silent hangs.
> 
> The code its stuck at:
> 
> > [1]:
> > POWER7 performance monitor hardware support registered
> > Brought up 896 CPUs
> > Enabling Asymmetric SMT scheduling
> > BUG: soft lockup - CPU#0 stuck for 22s! [swapper:1]
> > Modules linked in:
> > NIP: c000000000074b90 LR: c00000000008a1c4 CTR: 0000000000000000
> > REGS: c000000fae25f9c0 TRAP: 0901   Not tainted  (3.0.0-rc6)
> > MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000088  XER: 00000004
> > TASK = c000000fae248490[1] 'swapper' THREAD: c000000fae25c000 CPU: 0
> > GPR00: 0000e2a55cbeec50 c000000fae25fc40 c000000000e21f90 c000007b2b34cb00
> > GPR04: 0000000000000100 0000000000000100 c000011adcf23418 0000000000000000
> > GPR08: 0000000000000000 c000008b2b7d4480 c000007b2b35ef80 00000000000024ac
> > GPR12: 0000000044000042 c00000000ebb0000
> > NIP [c000000000074b90] .update_group_power+0x50/0x190
> > LR [c00000000008a1c4] .build_sched_domains+0x434/0x490
> > Call Trace:
> > [c000000fae25fc40] [c000000fae25fce0] 0xc000000fae25fce0 (unreliable)
> > [c000000fae25fce0] [c00000000008a1c4] .build_sched_domains+0x434/0x490
> > [c000000fae25fdd0] [c000000000867370] .sched_init_smp+0xa8/0x224
> > [c000000fae25fee0] [c000000000850274] .kernel_init+0x10c/0x1fc
> > [c000000fae25ff90] [c000000000023884] .kernel_thread+0x54/0x70
> > Instruction dump:
> > f821ff61 ebc2b1a0 7c7f1b78 7c9c2378 e9230008 eba30010 2fa90000 419e0054
> > e9490010 38000000 7d495378 60000000 <8169000c> e9290000 7faa4800 7c005a14
> 
> doesn't contains any locks, its simply looping over all the cpus, and
> with that many I can imagine it takes a while, but getting 'stuck' there
> is unexpected to say the least.
> 
> Surely this isn't the first multi-node P7 to boot a kernel with this
> patch? If my git foo is any good it hit -next on 23rd of May.
> 
> I guess I'm asking is, do smaller P7 machines boot? And if so, is there
> any difference except size?

Yes, the smaller P7 machine that I have with 20 CPUs and 2GB ram boots
fine with 3.0.0-rc.

> 
> How many nodes does the thing have anyway, 28? Hmm, that could mean its
> the first machine with >16 nodes to boot this, which would make it
> trigger the magic ALL_NODES crap.

The P7 machine where kernel fails to boot shows following demsg log w.r.t
node map:
---------------------------
Zone PFN ranges:
  DMA      0x00000000 -> 0x01229000
  Normal   empty
Movable zone start PFN for each node
early_node_map[12] active PFN ranges
    0: 0x00000000 -> 0x000fd000
    4: 0x000fd000 -> 0x002fb000
    5: 0x002fb000 -> 0x004b9000
    6: 0x004b9000 -> 0x006b9000
    8: 0x006b9000 -> 0x007b5000
   12: 0x007b5000 -> 0x008b5000
   16: 0x008b5000 -> 0x009b1000
   20: 0x009b1000 -> 0x00bb1000
   21: 0x00bb1000 -> 0x00db1000
   22: 0x00db1000 -> 0x00fb1000
   23: 0x00fb1000 -> 0x011b1000
   28: 0x011b1000 -> 0x01229000
Could not find start_pfn for node 1
Could not find start_pfn for node 2
Could not find start_pfn for node 3
Could not find start_pfn for node 7
Could not find start_pfn for node 9
Could not find start_pfn for node 10
Could not find start_pfn for node 11
Could not find start_pfn for node 13
Could not find start_pfn for node 14
Could not find start_pfn for node 15
Could not find start_pfn for node 17
Could not find start_pfn for node 18
Could not find start_pfn for node 19
Could not find start_pfn for node 29
Could not find start_pfn for node 30
Could not find start_pfn for node 31
[boot]0015 Setup Done
PERCPU: Embedded 1 pages/cpu @c000000013c00000 s31488 r0 d34048 u65536
Built 28 zonelists in Node order, mobility grouping on.  Total pages:
19026032
Policy zone: DMA
Kernel command line: root=/dev/mapper/vg_nish1-lv_root ro
rd_LVM_LV=vg_nish1/lv_root rd_LVM_LV=VolGroup/lv_swap
rd_LVM_LV=vg_nish1/lv_swap rd_NO_LUKS rd_NO_MD rd_NO_DM LANG=en_US.UTF-8
SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=hvc0i memblock=debug 
PID hash table entries: 4096 (order: -1, 32768 bytes)
freeing bootmem node 0
freeing bootmem node 4
freeing bootmem node 5
freeing bootmem node 6
freeing bootmem node 8
freeing bootmem node 12
freeing bootmem node 16
freeing bootmem node 20
freeing bootmem node 21
freeing bootmem node 22
freeing bootmem node 23
freeing bootmem node 28
Memory: 1213775296k/1218707456k available (13312k kernel code, 4932160k
reserved, 1600k data, 2727k bss, 4928k init)
---------------------------

Thanks,
-Mahesh.

> 
> Let me dig around there.
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

-- 
Mahesh J Salgaonkar
