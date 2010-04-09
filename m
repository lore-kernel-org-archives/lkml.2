Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab0DIVjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:39:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51596 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab0DIVjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:39:40 -0400
Date: Fri, 9 Apr 2010 23:33:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100409213347.GA12709@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <20100408234721.GB25834@a1.tnic>
 <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org>
 <20100409013012.GA8153@liondog.tnic>
 <20100409092111.GA998@a1.tnic>
 <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org>
 <20100409174041.GA10780@a1.tnic>
 <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org>
 <20100409191425.GB10780@a1.tnic>
 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
 <20100409204328.GG28964@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100409204328.GG28964@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, Apr 09, 2010 at 10:43:28PM +0200

Hi Hannes :) ,

> ---
> Subject: mm: properly merge anon_vma_chains when merging vmas
> 
> Merging can happen when two VMAs were split from one root VMA or
> a mergeable VMA was instantiated and reused a nearby VMA's anon_vma.
> 
> In both cases, none of the VMAs can grow any more anon_vmas and forked
> VMAs can no longer get merged due to differing primary anon_vmas for
> their private COW-broken pages.
> 
> In the split case, the anon_vma_chains are equal and we can just drop
> the one of the VMA that is going away.
> 
> In the other case, the VMA that was instantiated later has only one
> anon_vma on its chain: the primary anon_vma of its merge partner (due
> to anon_vma_prepare()).
> 
> If the VMA that came later is going away, its anon_vma_chain is a
> subset of the one that is staying, so it can be dropped like in the
> split case.
> 
> Only if the VMA that came first is going away, its potential parent
> anon_vmas need to be migrated to the VMA that is staying.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
> 
> It compiles and boots but I have not really excercised this code.
> Boris, could you give it a spin?  Thanks!

ok, I got this ontop of mainline (no other patches from this thread)
but unfortunately it breaks at the same spot while under heavy page
reclaiming when trying to hibernate while booting 3 guests.

[  322.171120] PM: Preallocating image memory... 
[  322.477374] BUG: unable to handle kernel NULL pointer dereference at (null)
[  322.477376] IP: [<ffffffff810c0c87>] page_referenced+0xee/0x1dc
[  322.477376] PGD 2014e8067 PUD 221b4e067 PMD 0 
[  322.477376] Oops: 0000 [#1] PREEMPT SMP 
[  322.477376] last sysfs file: /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
[  322.477376] CPU 3 
[  322.477376] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 pcspkr serial_core k10temp ohci_hcd edac_core
[  322.477376] 
[  322.477376] Pid: 2750, comm: hib.sh Tainted: G        W  2.6.34-rc3-00411-ga7247b6 #13 M3A78 PRO/System Product Name
[  322.477376] RIP: 0010:[<ffffffff810c0c87>]  [<ffffffff810c0c87>] page_referenced+0xee/0x1dc
[  322.477376] RSP: 0018:ffff88020936d8b8  EFLAGS: 00010283
[  322.477376] RAX: ffff88022de91af0 RBX: ffffea0006dcb488 RCX: 0000000000000000
[  322.477376] RDX: ffff88020936dcf8 RSI: ffff88022de91ac8 RDI: ffff88022ced0000
[  322.477376] RBP: ffff88020936d938 R08: 0000000000000002 R09: 0000000000000000
[  322.477376] R10: 0000000000000246 R11: 0000000000000003 R12: 0000000000000000
[  322.477376] R13: ffffffffffffffe0 R14: ffff88022de91ab0 R15: ffff88020936da00
[  322.477376] FS:  00007f286493e6f0(0000) GS:ffff88000a600000(0000) knlGS:0000000000000000
[  322.477376] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  322.477376] CR2: 0000000000000000 CR3: 00000001f8354000 CR4: 00000000000006e0
[  322.477376] DR0: 0000000000000090 DR1: 00000000000000a4 DR2: 00000000000000ff
[  322.477376] DR3: 000000000000000f DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  322.477376] Process hib.sh (pid: 2750, threadinfo ffff88020936c000, task ffff88022ced0000)
[  322.477376] Stack:
[  322.477376]  ffff88022de91af0 00000000813f8eec ffffffff8165ce28 000000000000002e
[  322.477376] <0> ffff88020936d8f8 ffffffff810c60bc ffffea0006dcb450 ffffea0006dcb450
[  322.477376] <0> ffff88020936d938 00000002810ab29d 0000000006f316b0 ffffea0006dcb4b0
[  322.477376] Call Trace:
[  322.477376]  [<ffffffff810c60bc>] ? swapcache_free+0x37/0x3c
[  322.477376]  [<ffffffff810ab7c2>] shrink_page_list+0x14a/0x477
[  322.477376]  [<ffffffff810abe46>] shrink_inactive_list+0x357/0x5e5
[  322.477376]  [<ffffffff810ab666>] ? shrink_active_list+0x232/0x244
[  322.477376]  [<ffffffff810ac3e0>] shrink_zone+0x30c/0x3d6
[  322.477376]  [<ffffffff810acfbb>] do_try_to_free_pages+0x176/0x27f
[  322.477376]  [<ffffffff810ad159>] shrink_all_memory+0x95/0xc4
[  322.477376]  [<ffffffff810aa65c>] ? isolate_pages_global+0x0/0x1f0
[  322.477376]  [<ffffffff81076e7c>] ? count_data_pages+0x65/0x79
[  322.477376]  [<ffffffff810770e3>] hibernate_preallocate_memory+0x1aa/0x2cb
[  322.477376]  [<ffffffff813f5325>] ? printk+0x41/0x44
[  322.477376]  [<ffffffff81075a83>] hibernation_snapshot+0x36/0x1e1
[  322.477376]  [<ffffffff81075cfc>] hibernate+0xce/0x172
[  322.477376]  [<ffffffff81074a69>] state_store+0x5c/0xd3
[  322.477376]  [<ffffffff81185043>] kobj_attr_store+0x17/0x19
[  322.477376]  [<ffffffff81125e87>] sysfs_write_file+0x108/0x144
[  322.477376]  [<ffffffff810d580f>] vfs_write+0xb2/0x153
[  322.477376]  [<ffffffff81063c09>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  322.477376]  [<ffffffff810d5973>] sys_write+0x4a/0x71
[  322.477376]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
[  322.477376] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 77 f2 ff ff 41 01 c4 83 7d cc 00 74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
[  322.477376] RIP  [<ffffffff810c0c87>] page_referenced+0xee/0x1dc
[  322.477376]  RSP <ffff88020936d8b8>
[  322.477376] CR2: 0000000000000000
[  322.491359] ---[ end trace 520a5274d8859b71 ]---
[  322.491509] note: hib.sh[2750] exited with preempt_count 2
[  322.491663] BUG: scheduling while atomic: hib.sh/2750/0x10000003
[  322.491810] INFO: lockdep is turned off.
[  322.491956] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 pcspkr serial_core k10temp ohci_hcd edac_core
[  322.493364] Pid: 2750, comm: hib.sh Tainted: G      D W  2.6.34-rc3-00411-ga7247b6 #13
[  322.493622] Call Trace:
[  322.493768]  [<ffffffff8106311f>] ? __debug_show_held_locks+0x1b/0x24
[  322.493919]  [<ffffffff8102d3d0>] __schedule_bug+0x72/0x77
[  322.494070]  [<ffffffff813f572e>] schedule+0xd9/0x730
[  322.494223]  [<ffffffff8103023c>] __cond_resched+0x18/0x24
[  322.494378]  [<ffffffff813f5e52>] _cond_resched+0x2c/0x37
[  322.494527]  [<ffffffff810b7da5>] unmap_vmas+0x6ce/0x893
[  322.494678]  [<ffffffff813f8e86>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[  322.494829]  [<ffffffff810bc457>] exit_mmap+0xd7/0x182
[  322.494978]  [<ffffffff81035969>] mmput+0x48/0xb9
[  322.495131]  [<ffffffff81039c39>] exit_mm+0x110/0x11d
[  322.495280]  [<ffffffff8103b67b>] do_exit+0x1c5/0x691
[  322.495521]  [<ffffffff81038d25>] ? kmsg_dump+0x13b/0x155
[  322.495668]  [<ffffffff810060db>] ? oops_end+0x47/0x93
[  322.495816]  [<ffffffff81006122>] oops_end+0x8e/0x93
[  322.495964]  [<ffffffff8101ed95>] no_context+0x1fc/0x20b
[  322.496118]  [<ffffffff8101ef30>] __bad_area_nosemaphore+0x18c/0x1af
[  322.496267]  [<ffffffff8101f16b>] ? do_page_fault+0xa8/0x32d
[  322.496484]  [<ffffffff8101ef66>] bad_area_nosemaphore+0x13/0x15
[  322.496630]  [<ffffffff8101f236>] do_page_fault+0x173/0x32d
[  322.496780]  [<ffffffff813f96e3>] ? error_sti+0x5/0x6
[  322.496928]  [<ffffffff81062bc7>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  322.497082]  [<ffffffff813f80d2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  322.497232]  [<ffffffff813f94ff>] page_fault+0x1f/0x30
[  322.497392]  [<ffffffff810c0c87>] ? page_referenced+0xee/0x1dc
[  322.497541]  [<ffffffff810c0c19>] ? page_referenced+0x80/0x1dc
[  322.497690]  [<ffffffff810c60bc>] ? swapcache_free+0x37/0x3c
[  322.497839]  [<ffffffff810ab7c2>] shrink_page_list+0x14a/0x477
[  322.497989]  [<ffffffff810abe46>] shrink_inactive_list+0x357/0x5e5
[  322.498141]  [<ffffffff810ab666>] ? shrink_active_list+0x232/0x244
[  322.498291]  [<ffffffff810ac3e0>] shrink_zone+0x30c/0x3d6
[  322.498444]  [<ffffffff810acfbb>] do_try_to_free_pages+0x176/0x27f
[  322.498594]  [<ffffffff810ad159>] shrink_all_memory+0x95/0xc4
[  322.498743]  [<ffffffff810aa65c>] ? isolate_pages_global+0x0/0x1f0
[  322.498892]  [<ffffffff81076e7c>] ? count_data_pages+0x65/0x79
[  322.499046]  [<ffffffff810770e3>] hibernate_preallocate_memory+0x1aa/0x2cb
[  322.499195]  [<ffffffff813f5325>] ? printk+0x41/0x44
[  322.499344]  [<ffffffff81075a83>] hibernation_snapshot+0x36/0x1e1
[  322.499498]  [<ffffffff81075cfc>] hibernate+0xce/0x172
[  322.499647]  [<ffffffff81074a69>] state_store+0x5c/0xd3
[  322.499795]  [<ffffffff81185043>] kobj_attr_store+0x17/0x19
[  322.499944]  [<ffffffff81125e87>] sysfs_write_file+0x108/0x144
[  322.500097]  [<ffffffff810d580f>] vfs_write+0xb2/0x153
[  322.500246]  [<ffffffff81063c09>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  322.500399]  [<ffffffff810d5973>] sys_write+0x4a/0x71
[  322.500547]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b

-- 
Regards/Gruss,
Boris.
