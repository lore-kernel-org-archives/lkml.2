Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0DITTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:19:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51482 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab0DITTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:19:39 -0400
Date: Fri, 9 Apr 2010 21:14:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100409191425.GB10780@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
	hannes@cmpxchg.org
References: <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
 <20100408210035.GA25834@a1.tnic>
 <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org>
 <20100408234721.GB25834@a1.tnic>
 <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org>
 <20100409013012.GA8153@liondog.tnic>
 <20100409092111.GA998@a1.tnic>
 <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org>
 <20100409174041.GA10780@a1.tnic>
 <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, Apr 09, 2010 at 10:50:23AM -0700

> Continue stress-testing it. I don't think my patch on its own should fix 
> the original problem, but at least we now know why you got those NULL 
> anon_vma's.
> 
> So what I _think_ will happen is that you'll be able to re-create the 
> problem that started this all.  But I'd like to verify that, just because 
> I'm anal and I'd like these things to be tested independently.

Heh, that was easy. Third hibernate cycle is a charm^Wboom :)

> So assuming that the original problem happens again, if you can then apply 
> Rik's patch, but add a
> 
> 	dst->anon_vma = src->anon_vma;
> 
> to just before the success case (the "return 0") in anon_vma_clone(), 
> that would be good.

It looks like this way we mangle the anon_vma chains somehow. From
what I can see and if I'm not mistaken, we save the anon_vmas alright
but end up in what seems like an endless list_for_each_entry()
loop having grabbed anon_vma->lock in page_lock_anon_vma() and we
can't seem to yield it through page_unlock_anon_vma() at the end of
page_referenced_anon() so it has to be that code in between iterating
over each list entry...

I could be completely wrong though...


[  373.683545] PM: Syncing filesystems ... done.
[  373.950289] Freezing user space processes ... (elapsed 0.04 seconds) done.
[  373.998878] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  374.011121] PM: Preallocating image memory... 
[  439.161126] BUG: soft lockup - CPU#1 stuck for 61s! [hib.sh:3617]
[  439.161315] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 serial_core edac_core pcspkr k10temp ohci_hcd
[  439.162302] irq event stamp: 0
[  439.162302] hardirqs last  enabled at (0): [<(null)>] (null)
[  439.162302] hardirqs last disabled at (0): [<ffffffff8103655c>] copy_process+0x3c1/0x10cc
[  439.163297] softirqs last  enabled at (0): [<ffffffff8103655c>] copy_process+0x3c1/0x10cc
[  439.163297] softirqs last disabled at (0): [<(null)>] (null)
[  439.163297] CPU 1 
[  439.163297] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 serial_core edac_core pcspkr k10temp ohci_hcd
[  439.165297] 
[  439.165297] Pid: 3617, comm: hib.sh Tainted: G        W  2.6.34-rc3-00413-g1028f7c-dirty #12 M3A78 PRO/System Product Name
[  439.165297] RIP: 0010:[<ffffffff8118b731>]  [<ffffffff8118b731>] delay_tsc+0x0/0xca
[  439.165297] RSP: 0018:ffff8801f68b77f0  EFLAGS: 00000202
[  439.166300] RAX: 0000000000000000 RBX: ffff8801f68b77f8 RCX: 000000000000f100
[  439.166300] RDX: 0000000000000001 RSI: ffff8801f68b7848 RDI: 0000000000000001
[  439.166300] RBP: ffffffff81002b4e R08: 0000000000000001 R09: 0000000000000000
[  439.166300] R10: ffff88022c9a3ac8 R11: ffffffff00000012 R12: 000000000000f100
[  439.166300] R13: 00000000cc444700 R14: 0000000000000001 R15: 0000000000000000
[  439.166300] FS:  00007f8d00e676f0(0000) GS:ffff88000a200000(0000) knlGS:0000000000000000
[  439.167296] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  439.167296] CR2: 00007fff93e8a9c0 CR3: 00000001f5397000 CR4: 00000000000006e0
[  439.167296] DR0: 00000000000000a0 DR1: 0000000000000000 DR2: 0000000000000003
[  439.167296] DR3: 00000000000000b0 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  439.167296] Process hib.sh (pid: 3617, threadinfo ffff8801f68b6000, task ffff88022a2e8000)
[  439.167296] Stack:
[  439.168297]  ffffffff8118b72f ffff8801f68b7848 ffffffff8119a1ca ffff880214972868
[  439.168297] <0> 0000000000000001 ffff880100000000 ffff880214972850 ffff880214972868
[  439.168297] <0> ffff8801f68b7cf8 ffff8801f68b7b78 ffff8801f68b7a00 ffff8801f68b7878
[  439.169298] Call Trace:
[  439.169298]  [<ffffffff8118b72f>] ? __delay+0xf/0x11
[  439.169298]  [<ffffffff8119a1ca>] ? do_raw_spin_lock+0xd2/0x13c
[  439.169298]  [<ffffffff813f827b>] ? _raw_spin_lock+0x60/0x73
[  439.170299]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  439.170299]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  439.170299]  [<ffffffff810c09d4>] ? page_lock_anon_vma+0x0/0xac
[  439.170299]  [<ffffffff810c0c1d>] ? page_referenced+0x80/0x1dc
[  439.170299]  [<ffffffff810c0b22>] ? try_to_unmap_anon+0xa2/0xb4
[  439.170299]  [<ffffffff810ab7a6>] ? shrink_page_list+0x14a/0x477
[  439.170299]  [<ffffffff813f8d86>] ? _raw_spin_unlock_irq+0x30/0x58
[  439.171296]  [<ffffffff810abe2a>] ? shrink_inactive_list+0x357/0x5e5
[  439.171296]  [<ffffffff810ab64a>] ? shrink_active_list+0x232/0x244
[  439.171296]  [<ffffffff810ac3c4>] ? shrink_zone+0x30c/0x3d6
[  439.171296]  [<ffffffff810acf9f>] ? do_try_to_free_pages+0x176/0x27f
[  439.171296]  [<ffffffff810ad13d>] ? shrink_all_memory+0x95/0xc4
[  439.171296]  [<ffffffff810aa640>] ? isolate_pages_global+0x0/0x1f0
[  439.171296]  [<ffffffff81076e60>] ? count_data_pages+0x65/0x79
[  439.172298]  [<ffffffff810770c7>] ? hibernate_preallocate_memory+0x1aa/0x2cb
[  439.172298]  [<ffffffff813f5285>] ? printk+0x41/0x44
[  439.172298]  [<ffffffff81075a67>] ? hibernation_snapshot+0x36/0x1e1
[  439.172298]  [<ffffffff81075ce0>] ? hibernate+0xce/0x172
[  439.172298]  [<ffffffff81074a4d>] ? state_store+0x5c/0xd3
[  439.172298]  [<ffffffff81184f8f>] ? kobj_attr_store+0x17/0x19
[  439.173296]  [<ffffffff81125dd7>] ? sysfs_write_file+0x108/0x144
[  439.173296]  [<ffffffff810d575f>] ? vfs_write+0xb2/0x153
[  439.173296]  [<ffffffff81063bed>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  439.173296]  [<ffffffff810d58c3>] ? sys_write+0x4a/0x71
[  439.173296]  [<ffffffff810021db>] ? system_call_fastpath+0x16/0x1b
[  439.173296] Code: ff c8 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 c7 05 12 35 4e 00 31 b7 18 81 c9 c3 55 48 89 e5 0f 1f 44 00 00 ff 15 01 35 4e 00 c9 c3 <55> 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 
[  439.176296] Call Trace:
[  439.177297]  [<ffffffff8118b72f>] ? __delay+0xf/0x11
[  439.177297]  [<ffffffff8119a1ca>] ? do_raw_spin_lock+0xd2/0x13c
[  439.177297]  [<ffffffff813f827b>] ? _raw_spin_lock+0x60/0x73
[  439.177297]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  439.177297]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  439.177297]  [<ffffffff810c09d4>] ? page_lock_anon_vma+0x0/0xac
[  439.177297]  [<ffffffff810c0c1d>] ? page_referenced+0x80/0x1dc
[  439.178295]  [<ffffffff810c0b22>] ? try_to_unmap_anon+0xa2/0xb4
[  439.178295]  [<ffffffff810ab7a6>] ? shrink_page_list+0x14a/0x477
[  439.178295]  [<ffffffff813f8d86>] ? _raw_spin_unlock_irq+0x30/0x58
[  439.178295]  [<ffffffff810abe2a>] ? shrink_inactive_list+0x357/0x5e5
[  439.178295]  [<ffffffff810ab64a>] ? shrink_active_list+0x232/0x244
[  439.178295]  [<ffffffff810ac3c4>] ? shrink_zone+0x30c/0x3d6
[  439.178295]  [<ffffffff810acf9f>] ? do_try_to_free_pages+0x176/0x27f
[  439.179299]  [<ffffffff810ad13d>] ? shrink_all_memory+0x95/0xc4
[  439.179299]  [<ffffffff810aa640>] ? isolate_pages_global+0x0/0x1f0
[  439.179299]  [<ffffffff81076e60>] ? count_data_pages+0x65/0x79
[  439.179299]  [<ffffffff810770c7>] ? hibernate_preallocate_memory+0x1aa/0x2cb
[  439.179299]  [<ffffffff813f5285>] ? printk+0x41/0x44
[  439.179299]  [<ffffffff81075a67>] ? hibernation_snapshot+0x36/0x1e1
[  439.180296]  [<ffffffff81075ce0>] ? hibernate+0xce/0x172
[  439.180296]  [<ffffffff81074a4d>] ? state_store+0x5c/0xd3
[  439.180296]  [<ffffffff81184f8f>] ? kobj_attr_store+0x17/0x19
[  439.180296]  [<ffffffff81125dd7>] ? sysfs_write_file+0x108/0x144
[  439.180296]  [<ffffffff810d575f>] ? vfs_write+0xb2/0x153
[  439.180296]  [<ffffffff81063bed>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  439.180296]  [<ffffffff810d58c3>] ? sys_write+0x4a/0x71
[  439.181297]  [<ffffffff810021db>] ? system_call_fastpath+0x16/0x1b
[  504.659125] BUG: soft lockup - CPU#1 stuck for 61s! [hib.sh:3617]
[  504.659126] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 serial_core edac_core pcspkr k10temp ohci_hcd
[  504.660297] irq event stamp: 0
[  504.660297] hardirqs last  enabled at (0): [<(null)>] (null)
[  504.660297] hardirqs last disabled at (0): [<ffffffff8103655c>] copy_process+0x3c1/0x10cc
[  504.661298] softirqs last  enabled at (0): [<ffffffff8103655c>] copy_process+0x3c1/0x10cc
[  504.661298] softirqs last disabled at (0): [<(null)>] (null)
[  504.661298] CPU 1 
[  504.661298] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 serial_core edac_core pcspkr k10temp ohci_hcd
[  504.663297] 
[  504.663297] Pid: 3617, comm: hib.sh Tainted: G        W  2.6.34-rc3-00413-g1028f7c-dirty #12 M3A78 PRO/System Product Name
[  504.663297] RIP: 0010:[<ffffffff8118b775>]  [<ffffffff8118b775>] delay_tsc+0x44/0xca
[  504.663297] RSP: 0018:ffff8801f68b77b8  EFLAGS: 00000206
[  504.663297] RAX: 00000000a4911fed RBX: ffff8801f68b77e8 RCX: 000000000000f100
[  504.664326] RDX: 00000000000000f1 RSI: ffff8801f68b7848 RDI: 0000000000000001
[  504.664326] RBP: ffffffff81002b4e R08: 0000000000000001 R09: 0000000000000000
[  504.664326] R10: ffff88022c9a3ac8 R11: ffffffff00000012 R12: 0000000000000010
[  504.664326] R13: ffff88000a200000 R14: ffff8801f68b6000 R15: ffff8801f68b7fd8
[  504.664326] FS:  00007f8d00e676f0(0000) GS:ffff88000a200000(0000) knlGS:0000000000000000
[  504.664326] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  504.665296] CR2: 00007fff93e8a9c0 CR3: 00000001f5397000 CR4: 00000000000006e0
[  504.665296] DR0: 00000000000000a0 DR1: 0000000000000000 DR2: 0000000000000003
[  504.665296] DR3: 00000000000000b0 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  504.665296] Process hib.sh (pid: 3617, threadinfo ffff8801f68b6000, task ffff88022a2e8000)
[  504.665296] Stack:
[  504.665296]  0000000000000001 ffff880214972850 ffff88022a2e8000 00000000b3450160
[  504.666297] <0> ffff88022a2e83a8 000000005486e668 ffff8801f68b77f8 ffffffff8118b72f
[  504.666297] <0> ffff8801f68b7848 ffffffff8119a1ca ffff880214972868 0000000000000001
[  504.667298] Call Trace:
[  504.667298]  [<ffffffff8118b72f>] ? __delay+0xf/0x11
[  504.667298]  [<ffffffff8119a1ca>] ? do_raw_spin_lock+0xd2/0x13c
[  504.667298]  [<ffffffff813f827b>] ? _raw_spin_lock+0x60/0x73
[  504.667298]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  504.668288]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  504.668298]  [<ffffffff810c09d4>] ? page_lock_anon_vma+0x0/0xac
[  504.668298]  [<ffffffff810c0c1d>] ? page_referenced+0x80/0x1dc
[  504.668298]  [<ffffffff810c0b22>] ? try_to_unmap_anon+0xa2/0xb4
[  504.668298]  [<ffffffff810ab7a6>] ? shrink_page_list+0x14a/0x477
[  504.668298]  [<ffffffff813f8d86>] ? _raw_spin_unlock_irq+0x30/0x58
[  504.668298]  [<ffffffff810abe2a>] ? shrink_inactive_list+0x357/0x5e5
[  504.669296]  [<ffffffff810ab64a>] ? shrink_active_list+0x232/0x244
[  504.669296]  [<ffffffff810ac3c4>] ? shrink_zone+0x30c/0x3d6
[  504.669296]  [<ffffffff810acf9f>] ? do_try_to_free_pages+0x176/0x27f
[  504.669296]  [<ffffffff810ad13d>] ? shrink_all_memory+0x95/0xc4
[  504.669296]  [<ffffffff810aa640>] ? isolate_pages_global+0x0/0x1f0
[  504.669296]  [<ffffffff81076e60>] ? count_data_pages+0x65/0x79
[  504.669296]  [<ffffffff810770c7>] ? hibernate_preallocate_memory+0x1aa/0x2cb
[  504.670302]  [<ffffffff813f5285>] ? printk+0x41/0x44
[  504.670302]  [<ffffffff81075a67>] ? hibernation_snapshot+0x36/0x1e1
[  504.670302]  [<ffffffff81075ce0>] ? hibernate+0xce/0x172
[  504.670302]  [<ffffffff81074a4d>] ? state_store+0x5c/0xd3
[  504.670302]  [<ffffffff81184f8f>] ? kobj_attr_store+0x17/0x19
[  504.670302]  [<ffffffff81125dd7>] ? sysfs_write_file+0x108/0x144
[  504.670302]  [<ffffffff810d575f>] ? vfs_write+0xb2/0x153
[  504.671297]  [<ffffffff81063bed>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  504.671297]  [<ffffffff810d58c3>] ? sys_write+0x4a/0x71
[  504.673315]  [<ffffffff810021db>] ? system_call_fastpath+0x16/0x1b
[  504.674350] Code: bf 01 00 00 00 e8 f8 1d ea ff e8 9f f4 00 00 41 89 c5 0f ae f0 66 66 90 0f 31 89 c3 65 4c 8b 34 25 48 b5 00 00 0f ae f0 66 66 90 <0f> 31 41 89 c7 4c 89 f8 48 29 d8 4c 39 e0 73 49 bf 01 00 00 00 
[  504.677299] Call Trace:
[  504.677299]  [<ffffffff8118b72f>] ? __delay+0xf/0x11
[  504.677299]  [<ffffffff8119a1ca>] ? do_raw_spin_lock+0xd2/0x13c
[  504.677299]  [<ffffffff813f827b>] ? _raw_spin_lock+0x60/0x73
[  504.677299]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  504.678287]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  504.678296]  [<ffffffff810c09d4>] ? page_lock_anon_vma+0x0/0xac
[  504.678296]  [<ffffffff810c0c1d>] ? page_referenced+0x80/0x1dc
[  504.678296]  [<ffffffff810c0b22>] ? try_to_unmap_anon+0xa2/0xb4
[  504.678296]  [<ffffffff810ab7a6>] ? shrink_page_list+0x14a/0x477
[  504.678296]  [<ffffffff813f8d86>] ? _raw_spin_unlock_irq+0x30/0x58
[  504.678296]  [<ffffffff810abe2a>] ? shrink_inactive_list+0x357/0x5e5
[  504.679297]  [<ffffffff810ab64a>] ? shrink_active_list+0x232/0x244
[  504.679297]  [<ffffffff810ac3c4>] ? shrink_zone+0x30c/0x3d6
[  504.679297]  [<ffffffff810acf9f>] ? do_try_to_free_pages+0x176/0x27f
[  504.679297]  [<ffffffff810ad13d>] ? shrink_all_memory+0x95/0xc4
[  504.679297]  [<ffffffff810aa640>] ? isolate_pages_global+0x0/0x1f0
[  504.679297]  [<ffffffff81076e60>] ? count_data_pages+0x65/0x79
[  504.679297]  [<ffffffff810770c7>] ? hibernate_preallocate_memory+0x1aa/0x2cb
[  504.680303]  [<ffffffff813f5285>] ? printk+0x41/0x44
[  504.680303]  [<ffffffff81075a67>] ? hibernation_snapshot+0x36/0x1e1
[  504.680303]  [<ffffffff81075ce0>] ? hibernate+0xce/0x172
[  504.680303]  [<ffffffff81074a4d>] ? state_store+0x5c/0xd3
[  504.680303]  [<ffffffff81184f8f>] ? kobj_attr_store+0x17/0x19
[  504.680303]  [<ffffffff81125dd7>] ? sysfs_write_file+0x108/0x144
[  504.680303]  [<ffffffff810d575f>] ? vfs_write+0xb2/0x153
[  504.681297]  [<ffffffff81063bed>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  504.681297]  [<ffffffff810d58c3>] ? sys_write+0x4a/0x71
[  504.681297]  [<ffffffff810021db>] ? system_call_fastpath+0x16/0x1b
[  570.157125] BUG: soft lockup - CPU#1 stuck for 61s! [hib.sh:3617]
[  570.157126] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 serial_core edac_core pcspkr k10temp ohci_hcd
[  570.158283] irq event stamp: 0
[  570.158283] hardirqs last  enabled at (0): [<(null)>] (null)
[  570.158283] hardirqs last disabled at (0): [<ffffffff8103655c>] copy_process+0x3c1/0x10cc
[  570.159297] softirqs last  enabled at (0): [<ffffffff8103655c>] copy_process+0x3c1/0x10cc
[  570.159297] softirqs last disabled at (0): [<(null)>] (null)
[  570.159297] CPU 1 
[  570.159297] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 serial_core edac_core pcspkr k10temp ohci_hcd
[  570.161297] 
[  570.161297] Pid: 3617, comm: hib.sh Tainted: G        W  2.6.34-rc3-00413-g1028f7c-dirty #12 M3A78 PRO/System Product Name
[  570.161297] RIP: 0010:[<ffffffff8118b777>]  [<ffffffff8118b777>] delay_tsc+0x46/0xca
[  570.161297] RSP: 0018:ffff8801f68b77b8  EFLAGS: 00000206
[  570.161297] RAX: 000000007cdde43c RBX: ffff8801f68b77e8 RCX: 000000000000f100
[  570.162296] RDX: 000000000000011f RSI: ffff8801f68b7848 RDI: 0000000000000001
[  570.162296] RBP: ffffffff81002b4e R08: 0000000000000001 R09: 0000000000000000
[  570.162296] R10: ffff88022c9a3ac8 R11: ffffffff00000012 R12: 0000000000000010
[  570.162296] R13: ffff88000a200000 R14: ffff8801f68b6000 R15: ffff8801f68b7fd8
[  570.162296] FS:  00007f8d00e676f0(0000) GS:ffff88000a200000(0000) knlGS:0000000000000000
[  570.162296] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  570.163296] CR2: 00007fff93e8a9c0 CR3: 00000001f5397000 CR4: 00000000000006e0
[  570.163296] DR0: 00000000000000a0 DR1: 0000000000000000 DR2: 0000000000000003
[  570.163296] DR3: 00000000000000b0 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  570.163296] Process hib.sh (pid: 3617, threadinfo ffff8801f68b6000, task ffff88022a2e8000)
[  570.163296] Stack:
[  570.163296]  0000000000000001 ffff880214972850 ffff88022a2e8000 00000000b3450160
[  570.164335] <0> ffff88022a2e83a8 000000007f0025c7 ffff8801f68b77f8 ffffffff8118b72f
[  570.164335] <0> ffff8801f68b7848 ffffffff8119a1ca ffff880214972868 0000000000000001
[  570.165299] Call Trace:
[  570.165299]  [<ffffffff8118b72f>] ? __delay+0xf/0x11
[  570.165299]  [<ffffffff8119a1ca>] ? do_raw_spin_lock+0xd2/0x13c
[  570.165299]  [<ffffffff813f827b>] ? _raw_spin_lock+0x60/0x73
[  570.165299]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  570.165299]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  570.166297]  [<ffffffff810c09d4>] ? page_lock_anon_vma+0x0/0xac
[  570.166297]  [<ffffffff810c0c1d>] ? page_referenced+0x80/0x1dc
[  570.166297]  [<ffffffff810c0b22>] ? try_to_unmap_anon+0xa2/0xb4
[  570.166297]  [<ffffffff810ab7a6>] ? shrink_page_list+0x14a/0x477
[  570.166297]  [<ffffffff813f8d86>] ? _raw_spin_unlock_irq+0x30/0x58
[  570.166297]  [<ffffffff810abe2a>] ? shrink_inactive_list+0x357/0x5e5
[  570.167296]  [<ffffffff810ab64a>] ? shrink_active_list+0x232/0x244
[  570.167296]  [<ffffffff810ac3c4>] ? shrink_zone+0x30c/0x3d6
[  570.167296]  [<ffffffff810acf9f>] ? do_try_to_free_pages+0x176/0x27f
[  570.167296]  [<ffffffff810ad13d>] ? shrink_all_memory+0x95/0xc4
[  570.167296]  [<ffffffff810aa640>] ? isolate_pages_global+0x0/0x1f0
[  570.167296]  [<ffffffff81076e60>] ? count_data_pages+0x65/0x79
[  570.167296]  [<ffffffff810770c7>] ? hibernate_preallocate_memory+0x1aa/0x2cb
[  570.168286]  [<ffffffff813f5285>] ? printk+0x41/0x44
[  570.168286]  [<ffffffff81075a67>] ? hibernation_snapshot+0x36/0x1e1
[  570.168286]  [<ffffffff81075ce0>] ? hibernate+0xce/0x172
[  570.168286]  [<ffffffff81074a4d>] ? state_store+0x5c/0xd3
[  570.168286]  [<ffffffff81184f8f>] ? kobj_attr_store+0x17/0x19
[  570.168286]  [<ffffffff81125dd7>] ? sysfs_write_file+0x108/0x144
[  570.168286]  [<ffffffff810d575f>] ? vfs_write+0xb2/0x153
[  570.169297]  [<ffffffff81063bed>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  570.169297]  [<ffffffff810d58c3>] ? sys_write+0x4a/0x71
[  570.169297]  [<ffffffff810021db>] ? system_call_fastpath+0x16/0x1b
[  570.169297] Code: 00 00 00 e8 f8 1d ea ff e8 9f f4 00 00 41 89 c5 0f ae f0 66 66 90 0f 31 89 c3 65 4c 8b 34 25 48 b5 00 00 0f ae f0 66 66 90 0f 31 <41> 89 c7 4c 89 f8 48 29 d8 4c 39 e0 73 49 bf 01 00 00 00 e8 07 
[  570.172299] Call Trace:
[  570.172299]  [<ffffffff8118b72f>] ? __delay+0xf/0x11
[  570.172299]  [<ffffffff8119a1ca>] ? do_raw_spin_lock+0xd2/0x13c
[  570.173297]  [<ffffffff813f827b>] ? _raw_spin_lock+0x60/0x73
[  570.173297]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  570.173297]  [<ffffffff810c0a37>] ? page_lock_anon_vma+0x63/0xac
[  570.173297]  [<ffffffff810c09d4>] ? page_lock_anon_vma+0x0/0xac
[  570.173297]  [<ffffffff810c0c1d>] ? page_referenced+0x80/0x1dc
[  570.173297]  [<ffffffff810c0b22>] ? try_to_unmap_anon+0xa2/0xb4
[  570.174329]  [<ffffffff810ab7a6>] ? shrink_page_list+0x14a/0x477
[  570.174329]  [<ffffffff813f8d86>] ? _raw_spin_unlock_irq+0x30/0x58
[  570.174329]  [<ffffffff810abe2a>] ? shrink_inactive_list+0x357/0x5e5
[  570.174329]  [<ffffffff810ab64a>] ? shrink_active_list+0x232/0x244
[  570.174329]  [<ffffffff810ac3c4>] ? shrink_zone+0x30c/0x3d6
[  570.174329]  [<ffffffff810acf9f>] ? do_try_to_free_pages+0x176/0x27f
[  570.174329]  [<ffffffff810ad13d>] ? shrink_all_memory+0x95/0xc4
[  570.175297]  [<ffffffff810aa640>] ? isolate_pages_global+0x0/0x1f0
[  570.175297]  [<ffffffff81076e60>] ? count_data_pages+0x65/0x79
[  570.175297]  [<ffffffff810770c7>] ? hibernate_preallocate_memory+0x1aa/0x2cb
[  570.175297]  [<ffffffff813f5285>] ? printk+0x41/0x44
[  570.175297]  [<ffffffff81075a67>] ? hibernation_snapshot+0x36/0x1e1
[  570.175297]  [<ffffffff81075ce0>] ? hibernate+0xce/0x172
[  570.175297]  [<ffffffff81074a4d>] ? state_store+0x5c/0xd3
[  570.176298]  [<ffffffff81184f8f>] ? kobj_attr_store+0x17/0x19
[  570.176298]  [<ffffffff81125dd7>] ? sysfs_write_file+0x108/0x144
[  570.176298]  [<ffffffff810d575f>] ? vfs_write+0xb2/0x153
[  570.176298]  [<ffffffff81063bed>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  570.176298]  [<ffffffff810d58c3>] ? sys_write+0x4a/0x71
[  570.176298]  [<ffffffff810021db>] ? system_call_fastpath+0x16/0x1b


-- 
Regards/Gruss,
Boris.
