Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572Ab0DHVIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:08:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60215 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758950Ab0DHVIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:08:10 -0400
Date: Thu, 8 Apr 2010 23:00:36 +0200
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
Message-ID: <20100408210035.GA25834@a1.tnic>
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
References: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
 <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic>
 <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, Apr 08, 2010 at 07:11:11AM -0700

> [ The patch below also makes it warn once and return SIGBUS for the case 
>   where there is no anon_vma.  I decided I still want to hear about it if 
>   there might be some path that tries to insert a vma on its own ]

And this happens quite often - I changed the WARN_ONCE to WARN and can't
start kvm, iceowl (mozilla calendar) and the console-kit-daemon craps up
upon boot too:

[   55.814570] ------------[ cut here ]------------
[   55.814623] WARNING: at mm/memory.c:3110 handle_mm_fault+0x43/0x66a()
[   55.814648] Hardware name: System Product Name
[   55.814671] Mapping with no anon_vma
[   55.814693] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 edac_core ohci_hcd serial_core k10temp pcspkr
[   55.815249] Pid: 1936, comm: console-kit-dae Not tainted 2.6.34-rc3-00290-g2156db9-dirty #8
[   55.815290] Call Trace:
[   55.815327]  [<ffffffff81037ea8>] warn_slowpath_common+0x7c/0x94
[   55.815362]  [<ffffffff81037f17>] warn_slowpath_fmt+0x41/0x43
[   55.815391]  [<ffffffff810b856a>] handle_mm_fault+0x43/0x66a
[   55.815420]  [<ffffffff8101f392>] do_page_fault+0x30b/0x32d
[   55.815452]  [<ffffffff810615ce>] ? put_lock_stats+0xe/0x27
[   55.815483]  [<ffffffff81062a55>] ? lock_release_holdtime+0x104/0x109
[   55.815518]  [<ffffffff813f93e3>] ? error_sti+0x5/0x6
[   55.815553]  [<ffffffff813f7dd2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   55.815585]  [<ffffffff813f91ff>] page_fault+0x1f/0x30
[   55.815613] ---[ end trace fa59f67cbfeeca44 ]---
[   60.801651] ------------[ cut here ]------------
[   60.801672] WARNING: at mm/memory.c:3110 handle_mm_fault+0x43/0x66a()
[   60.801681] Hardware name: System Product Name
[   60.801689] Mapping with no anon_vma
[   60.801702] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 edac_core ohci_hcd serial_core k10temp pcspkr
[   60.802156] Pid: 2008, comm: iceowl-bin Tainted: G        W  2.6.34-rc3-00290-g2156db9-dirty #8
[   60.802169] Call Trace:
[   60.802181]  [<ffffffff81037ea8>] warn_slowpath_common+0x7c/0x94
[   60.802191]  [<ffffffff81037f17>] warn_slowpath_fmt+0x41/0x43
[   60.802203]  [<ffffffff810b856a>] handle_mm_fault+0x43/0x66a
[   60.802213]  [<ffffffff8101f392>] do_page_fault+0x30b/0x32d
[   60.802225]  [<ffffffff810615ce>] ? put_lock_stats+0xe/0x27
[   60.802235]  [<ffffffff81062a55>] ? lock_release_holdtime+0x104/0x109
[   60.802268]  [<ffffffff813f93e3>] ? error_sti+0x5/0x6
[   60.802279]  [<ffffffff813f7dd2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   60.802290]  [<ffffffff813f91ff>] page_fault+0x1f/0x30
[   60.802305] ---[ end trace fa59f67cbfeeca45 ]---
[   92.123350] ------------[ cut here ]------------
[   92.123402] WARNING: at kernel/sched.c:3555 add_preempt_count+0x9c/0xcb()
[   92.123428] Hardware name: System Product Name
[   92.123451] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 edac_core ohci_hcd serial_core k10temp pcspkr
[   92.123902] Pid: 2111, comm: kvm Tainted: G        W  2.6.34-rc3-00290-g2156db9-dirty #8
[   92.123940] Call Trace:
[   92.123973]  [<ffffffff81037ea8>] warn_slowpath_common+0x7c/0x94
[   92.124002]  [<ffffffff81037ed4>] warn_slowpath_null+0x14/0x16
[   92.124031]  [<ffffffff8102d5d8>] add_preempt_count+0x9c/0xcb
[   92.124061]  [<ffffffff813f7ee9>] _raw_spin_lock_nest_lock+0x21/0x7a
[   92.124090]  [<ffffffff810bc079>] ? mm_take_all_locks+0xf9/0x150
[   92.124118]  [<ffffffff810bc079>] mm_take_all_locks+0xf9/0x150
[   92.124146]  [<ffffffff810cc48d>] ? do_mmu_notifier_register+0xd3/0x19d
[   92.124174]  [<ffffffff810cc495>] do_mmu_notifier_register+0xdb/0x19d
[   92.124202]  [<ffffffff810cc57c>] mmu_notifier_register+0x13/0x15
[   92.124256]  [<ffffffffa00c67e3>] kvm_dev_ioctl+0x2c8/0x495 [kvm]
[   92.124318]  [<ffffffff810e24ff>] vfs_ioctl+0x32/0xa6
[   92.124357]  [<ffffffff810e2a91>] do_vfs_ioctl+0x495/0x4db
[   92.124390]  [<ffffffff813f93e3>] ? error_sti+0x5/0x6
[   92.124425]  [<ffffffff813f8fad>] ? retint_swapgs+0xe/0x13
[   92.124458]  [<ffffffff810e2b1e>] sys_ioctl+0x47/0x6a
[   92.124498]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
[   92.124527] ---[ end trace fa59f67cbfeeca46 ]---
[   92.213834] ------------[ cut here ]------------
[   92.213888] WARNING: at mm/memory.c:3110 handle_mm_fault+0x43/0x66a()
[   92.213913] Hardware name: System Product Name
[   92.213937] Mapping with no anon_vma
[   92.213959] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 edac_core ohci_hcd serial_core k10temp pcspkr
[   92.214529] Pid: 2111, comm: kvm Tainted: G        W  2.6.34-rc3-00290-g2156db9-dirty #8
[   92.214571] Call Trace:
[   92.214612]  [<ffffffff81037ea8>] warn_slowpath_common+0x7c/0x94
[   92.214647]  [<ffffffff81037f17>] warn_slowpath_fmt+0x41/0x43
[   92.214683]  [<ffffffff810b856a>] handle_mm_fault+0x43/0x66a
[   92.214718]  [<ffffffff8101f392>] do_page_fault+0x30b/0x32d
[   92.214751]  [<ffffffff810be3ab>] ? do_mmap_pgoff+0x290/0x2f3
[   92.214787]  [<ffffffff813f93e3>] ? error_sti+0x5/0x6
[   92.214821]  [<ffffffff81062b97>] ? trace_hardirqs_off_caller+0x1f/0xa9
[   92.214857]  [<ffffffff813f7dd2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   92.214896]  [<ffffffff813f91ff>] page_fault+0x1f/0x30
[   92.214928] ---[ end trace fa59f67cbfeeca47 ]---

-- 
Regards/Gruss,
Boris.
