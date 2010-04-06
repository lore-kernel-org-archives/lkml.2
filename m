Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0DFTmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:42:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56729 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab0DFTmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:42:46 -0400
Date: Tue, 6 Apr 2010 21:42:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-ID: <20100406194238.GB20357@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <4BBB475A.7070002@redhat.com>
 <1270568096.1814.145.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
 <1270571019.1814.163.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
 <1270572327.1711.3.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100406120315.53ad7390.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, Apr 06, 2010 at 12:03:15PM -0700

> On Tue, 6 Apr 2010 11:28:52 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > For example, maybe some list corruption causes us to do that 
> > "anon_vma_chain_link()" _twice_ on the same avc entry. So we do that 
> > "list_add_tail(&avc->same_anon_vma, &anon_vma->head);" on an entry that 
> > already had "same_anon_vma" on one list.
> 
> The lib/list_debug.c stuff might detect such things.  I wonder if
> either Borislav or Steinar had CONFIG_DEBUG_LIST enabled?

No, it is off in my .config. I'll turn it on and retest to see whether
it screams something. In the meantime, I've been testing current git
(v2.6.34-rc3-288-gab195c5), and especially Rik's mem leak fix which
Linus already committed (4946d54cb55e86a156216fcfeed5568514b0830f) and
tried to retrigger the bug by hibernating the machine several times.

Now, this machine has 8G of memory so I thought maybe if starting
several assorted guests on it would put some pressure on anon_vma lists
but no, the machine habernated happily by creating almost a 600Mb
hibernation image and having all three guests loaded.

Then, I said, well, let's have another last test run and started firefox
which went into reloading the last session. And I remember that firefox
still hadn't finished loading all pages when I hibernated and boom, it
oopsed.

So, it definitely is some anon_vma lists concurrency issue ... The good
thing is, I was able to catch the oops in its sheer magnificence over
netconsole this time:


[ 2995.478125] PM: Preallocating image memory... 
[ 2995.713692] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 2995.714001] IP: [<ffffffff810c194d>] page_referenced+0xee/0x1dc
[ 2995.714001] PGD 22d1b8067 PUD 22dd85067 PMD 0 
[ 2995.714001] Oops: 0000 [#1] PREEMPT SMP 
[ 2995.714001] last sysfs file: /sys/power/state
[ 2995.714001] CPU 0 
[ 2995.714001] Modules linked in: tun powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd pcspkr 8250_pnp 8250 k10temp edac_core serial_core
[ 2995.714001] 
[ 2995.714001] Pid: 7440, comm: hib.sh Not tainted 2.6.34-rc3-00288-gab195c5 #1 M3A78 PRO/System Product Name
[ 2995.714001] RIP: 0010:[<ffffffff810c194d>]  [<ffffffff810c194d>] page_referenced+0xee/0x1dc
[ 2995.714001] RSP: 0018:ffff88022fa038b8  EFLAGS: 00010283
[ 2995.714001] RAX: ffff88022d747098 RBX: ffffea00078efb70 RCX: 0000000000000000
[ 2995.714001] RDX: ffff88022fa03cf8 RSI: ffff88022d747070 RDI: ffff88022fb32520
[ 2995.714001] RBP: ffff88022fa03938 R08: 0000000000000002 R09: 0000000000000000
[ 2995.714001] R10: ffff88022fa038a8 R11: ffff88022d295d10 R12: 0000000000000000
[ 2995.714001] R13: ffffffffffffffe0 R14: ffff88022d747058 R15: ffff88022fa03a00
[ 2995.714001] FS:  00007f4da8b966f0(0000) GS:ffff88000a000000(0000) knlGS:0000000000000000
[ 2995.714001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2995.714001] CR2: 0000000000000000 CR3: 000000022d11e000 CR4: 00000000000006f0
[ 2995.714001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2995.714001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2995.714001] Process hib.sh (pid: 7440, threadinfo ffff88022fa02000, task ffff88022fb32520)
[ 2995.714001] Stack:
[ 2995.714001]  ffff88022d747098 00000000813fd2ac ffffffff8165ee28 0000000000000416
[ 2995.714001] <0> ffff88022fa038f8 ffffffff810c6d40 ffffea00078fae60 ffffea00078fae60
[ 2995.714001] <0> ffff88022fa03938 00000002810abd98 ffffea00078ec530 ffffea00078efb98
[ 2995.714001] Call Trace:
[ 2995.714001]  [<ffffffff810c6d40>] ? swapcache_free+0x37/0x3c
[ 2995.714001]  [<ffffffff810ac31d>] shrink_page_list+0x171/0x4b1
[ 2995.714001]  [<ffffffff813fd1e6>] ? _raw_spin_unlock_irq+0x30/0x58
[ 2995.714001]  [<ffffffff810ac9b9>] shrink_inactive_list+0x35c/0x623
[ 2995.714001]  [<ffffffff810acd94>] ? shrink_zone+0x114/0x3d4
[ 2995.714001]  [<ffffffff81064f29>] ? print_lock_contention_bug+0x1b/0xe1
[ 2995.714001]  [<ffffffff813fc790>] ? _raw_spin_lock_irq+0x19/0x79
[ 2995.714001]  [<ffffffff810acf8a>] shrink_zone+0x30a/0x3d4
[ 2995.714001]  [<ffffffff810ad19e>] ? shrink_slab+0x14a/0x15c
[ 2995.714001]  [<ffffffff810adb65>] do_try_to_free_pages+0x176/0x27f
[ 2995.714001]  [<ffffffff8103de67>] ? irq_exit+0x93/0x95
[ 2995.714001]  [<ffffffff810add03>] shrink_all_memory+0x95/0xc4
[ 2995.714001]  [<ffffffff810ab0f0>] ? isolate_pages_global+0x0/0x217
[ 2995.714001]  [<ffffffff81077503>] ? count_data_pages+0x65/0x79
[ 2995.714001]  [<ffffffff8107776a>] hibernate_preallocate_memory+0x1aa/0x2cb
[ 2995.714001]  [<ffffffff813f95b5>] ? printk+0x41/0x44
[ 2995.714001]  [<ffffffff810760b3>] hibernation_snapshot+0x36/0x1e1
[ 2995.714001]  [<ffffffff8107632c>] hibernate+0xce/0x172
[ 2995.714001]  [<ffffffff81075099>] state_store+0x5c/0xd3
[ 2995.714001]  [<ffffffff8118728f>] kobj_attr_store+0x17/0x19
[ 2995.714001]  [<ffffffff81127b69>] sysfs_write_file+0x108/0x144
[ 2995.714001]  [<ffffffff810d66ff>] vfs_write+0xb2/0x153
[ 2995.714001]  [<ffffffff810641a9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[ 2995.714001]  [<ffffffff810d6863>] sys_write+0x4a/0x71
[ 2995.714001]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
[ 2995.714001] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 4d f2 ff ff 41 01 c4 83 7d cc 00 74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
[ 2995.714001] RIP  [<ffffffff810c194d>] page_referenced+0xee/0x1dc
[ 2995.714001]  RSP <ffff88022fa038b8>
[ 2995.714001] CR2: 0000000000000000
[ 2995.729717] ---[ end trace 92c25d74e4800968 ]---
[ 2995.729862] note: hib.sh[7440] exited with preempt_count 2
[ 2995.730022] BUG: scheduling while atomic: hib.sh/7440/0x10000003
[ 2995.730170] INFO: lockdep is turned off.
[ 2995.730319] Modules linked in: tun powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd pcspkr 8250_pnp 8250 k10temp edac_core serial_core
[ 2995.731749] Pid: 7440, comm: hib.sh Tainted: G      D    2.6.34-rc3-00288-gab195c5 #1
[ 2995.732003] Call Trace:
[ 2995.732158]  [<ffffffff810636bf>] ? __debug_show_held_locks+0x1b/0x24
[ 2995.732305]  [<ffffffff8102d499>] __schedule_bug+0x72/0x77
[ 2995.732454]  [<ffffffff813f9a0a>] schedule+0xd9/0x730
[ 2995.732603]  [<ffffffff81030301>] __cond_resched+0x18/0x24
[ 2995.732751]  [<ffffffff813fa12e>] _cond_resched+0x2c/0x37
[ 2995.732900]  [<ffffffff810b8a21>] unmap_vmas+0x6ce/0x893
[ 2995.733053]  [<ffffffff810bd0f5>] exit_mmap+0xd7/0x182
[ 2995.733206]  [<ffffffff81035b58>] mmput+0x43/0xea
[ 2995.733356]  [<ffffffff81039e99>] exit_mm+0x110/0x11d
[ 2995.733505]  [<ffffffff8103b8ed>] do_exit+0x1c5/0x6a2
[ 2995.733653]  [<ffffffff81038f84>] ? kmsg_dump+0x13b/0x155
[ 2995.733802]  [<ffffffff810060db>] ? oops_end+0x47/0x93
[ 2995.733950]  [<ffffffff81006122>] oops_end+0x8e/0x93
[ 2995.734102]  [<ffffffff8101ed99>] no_context+0x1fc/0x20b
[ 2995.734255]  [<ffffffff8101ef34>] __bad_area_nosemaphore+0x18c/0x1af
[ 2995.734407]  [<ffffffff8101f16f>] ? do_page_fault+0xa8/0x32d
[ 2995.734556]  [<ffffffff8101ef6a>] bad_area_nosemaphore+0x13/0x15
[ 2995.734705]  [<ffffffff8101f23a>] do_page_fault+0x173/0x32d
[ 2995.734854]  [<ffffffff810802f9>] ? __call_rcu+0x11d/0x130
[ 2995.735008]  [<ffffffff813fdaa3>] ? error_sti+0x5/0x6
[ 2995.735161]  [<ffffffff81063167>] ? trace_hardirqs_off_caller+0x1f/0xa9
[ 2995.735313]  [<ffffffff813fc48e>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2995.735463]  [<ffffffff813fd8bf>] page_fault+0x1f/0x30
[ 2995.735612]  [<ffffffff810c194d>] ? page_referenced+0xee/0x1dc
[ 2995.735761]  [<ffffffff810c18df>] ? page_referenced+0x80/0x1dc
[ 2995.735910]  [<ffffffff810c6d40>] ? swapcache_free+0x37/0x3c
[ 2995.736062]  [<ffffffff810ac31d>] shrink_page_list+0x171/0x4b1
[ 2995.736216]  [<ffffffff813fd1e6>] ? _raw_spin_unlock_irq+0x30/0x58
[ 2995.736368]  [<ffffffff810ac9b9>] shrink_inactive_list+0x35c/0x623
[ 2995.736518]  [<ffffffff810acd94>] ? shrink_zone+0x114/0x3d4
[ 2995.736666]  [<ffffffff81064f29>] ? print_lock_contention_bug+0x1b/0xe1
[ 2995.736816]  [<ffffffff813fc790>] ? _raw_spin_lock_irq+0x19/0x79
[ 2995.736965]  [<ffffffff810acf8a>] shrink_zone+0x30a/0x3d4
[ 2995.737117]  [<ffffffff810ad19e>] ? shrink_slab+0x14a/0x15c
[ 2995.737270]  [<ffffffff810adb65>] do_try_to_free_pages+0x176/0x27f
[ 2995.737422]  [<ffffffff8103de67>] ? irq_exit+0x93/0x95
[ 2995.737570]  [<ffffffff810add03>] shrink_all_memory+0x95/0xc4
[ 2995.737719]  [<ffffffff810ab0f0>] ? isolate_pages_global+0x0/0x217
[ 2995.737868]  [<ffffffff81077503>] ? count_data_pages+0x65/0x79
[ 2995.738020]  [<ffffffff8107776a>] hibernate_preallocate_memory+0x1aa/0x2cb
[ 2995.738175]  [<ffffffff813f95b5>] ? printk+0x41/0x44
[ 2995.738326]  [<ffffffff810760b3>] hibernation_snapshot+0x36/0x1e1
[ 2995.738475]  [<ffffffff8107632c>] hibernate+0xce/0x172
[ 2995.738623]  [<ffffffff81075099>] state_store+0x5c/0xd3
[ 2995.738772]  [<ffffffff8118728f>] kobj_attr_store+0x17/0x19
[ 2995.738920]  [<ffffffff81127b69>] sysfs_write_file+0x108/0x144
[ 2995.739073]  [<ffffffff810d66ff>] vfs_write+0xb2/0x153
[ 2995.739226]  [<ffffffff810641a9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[ 2995.739378]  [<ffffffff810d6863>] sys_write+0x4a/0x71
[ 2995.739526]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
[ 2995.739940] BUG: unable to handle kernel paging request at 00007faf064ff1f0
[ 2995.740220] IP: [<ffffffff8119c0d0>] do_raw_spin_trylock+0x4/0x3a
[ 2995.740441] PGD 0 
[ 2995.740646] Oops: 0000 [#2] PREEMPT SMP 
[ 2995.740685] last sysfs file: /sys/power/state
[ 2995.740685] CPU 1 
[ 2995.740685] Modules linked in: tun powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd pcspkr 8250_pnp 8250 k10temp edac_core serial_core
[ 2995.740685] 
[ 2995.740685] Pid: 7440, comm: hib.sh Tainted: G      D    2.6.34-rc3-00288-gab195c5 #1 M3A78 PRO/System Product Name
[ 2995.740685] RIP: 0010:[<ffffffff8119c0d0>]  [<ffffffff8119c0d0>] do_raw_spin_trylock+0x4/0x3a
[ 2995.740685] RSP: 0018:ffff88022fa03438  EFLAGS: 00010292
[ 2995.740685] RAX: ffff88022fb32520 RBX: 00007faf064ff1f0 RCX: 0000000000000000
[ 2995.740685] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007faf064ff1f0
[ 2995.740685] RBP: ffff88022fa03438 R08: 0000000000000002 R09: 0000000000000000
[ 2995.740685] R10: dead000000100100 R11: ffffffff810d26f5 R12: 00007faf064ff208
[ 2995.740685] R13: fffffffffffffff0 R14: ffff88022d747068 R15: 00007f4da81fa000
[ 2995.740685] FS:  00007f4da8b966f0(0000) GS:ffff88000a200000(0000) knlGS:0000000000000000
[ 2995.740685] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2995.740685] CR2: 00007faf064ff1f0 CR3: 0000000001646000 CR4: 00000000000006e0
[ 2995.740685] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2995.740685] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2995.740685] Process hib.sh (pid: 7440, threadinfo ffff88022fa02000, task ffff88022fb32520)
[ 2995.740685] Stack:
[ 2995.740685]  ffff88022fa03468 ffffffff813fc6c3 ffffffff810c1ae3 ffff8801cbfde880
[ 2995.740685] <0> ffff88022fb32510 00007faf064ff1f0 ffff88022fa034a8 ffffffff810c1ae3
[ 2995.740685] <0> ffff88022fa034a8 ffff88022d747000 0000000000000000 0000000000000000
[ 2995.740685] Call Trace:
[ 2995.740685]  [<ffffffff813fc6c3>] _raw_spin_lock+0x48/0x73
[ 2995.740685]  [<ffffffff810c1ae3>] ? unlink_anon_vmas+0x40/0xe1
[ 2995.740685]  [<ffffffff810c1ae3>] unlink_anon_vmas+0x40/0xe1
[ 2995.740685]  [<ffffffff810bb562>] free_pgtables+0x68/0xce
[ 2995.740685]  [<ffffffff810bd11e>] exit_mmap+0x100/0x182
[ 2995.740685]  [<ffffffff81035b58>] mmput+0x43/0xea
[ 2995.740685]  [<ffffffff81039e99>] exit_mm+0x110/0x11d
[ 2995.740685]  [<ffffffff8103b8ed>] do_exit+0x1c5/0x6a2
[ 2995.740685]  [<ffffffff81038f84>] ? kmsg_dump+0x13b/0x155
[ 2995.740685]  [<ffffffff810060db>] ? oops_end+0x47/0x93
[ 2995.740685]  [<ffffffff81006122>] oops_end+0x8e/0x93
[ 2995.740685]  [<ffffffff8101ed99>] no_context+0x1fc/0x20b
[ 2995.740685]  [<ffffffff8101ef34>] __bad_area_nosemaphore+0x18c/0x1af
[ 2995.740685]  [<ffffffff8101f16f>] ? do_page_fault+0xa8/0x32d
[ 2995.740685]  [<ffffffff8101ef6a>] bad_area_nosemaphore+0x13/0x15
[ 2995.740685]  [<ffffffff8101f23a>] do_page_fault+0x173/0x32d
[ 2995.740685]  [<ffffffff810802f9>] ? __call_rcu+0x11d/0x130
[ 2995.740685]  [<ffffffff813fdaa3>] ? error_sti+0x5/0x6
[ 2995.740685]  [<ffffffff81063167>] ? trace_hardirqs_off_caller+0x1f/0xa9
[ 2995.740685]  [<ffffffff813fc48e>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2995.740685]  [<ffffffff813fd8bf>] page_fault+0x1f/0x30
[ 2995.740685]  [<ffffffff810c194d>] ? page_referenced+0xee/0x1dc
[ 2995.740685]  [<ffffffff810c18df>] ? page_referenced+0x80/0x1dc
[ 2995.740685]  [<ffffffff810c6d40>] ? swapcache_free+0x37/0x3c
[ 2995.740685]  [<ffffffff810ac31d>] shrink_page_list+0x171/0x4b1
[ 2995.740685]  [<ffffffff813fd1e6>] ? _raw_spin_unlock_irq+0x30/0x58
[ 2995.740685]  [<ffffffff810ac9b9>] shrink_inactive_list+0x35c/0x623
[ 2995.740685]  [<ffffffff810acd94>] ? shrink_zone+0x114/0x3d4
[ 2995.740685]  [<ffffffff81064f29>] ? print_lock_contention_bug+0x1b/0xe1
[ 2995.740685]  [<ffffffff813fc790>] ? _raw_spin_lock_irq+0x19/0x79
[ 2995.740685]  [<ffffffff810acf8a>] shrink_zone+0x30a/0x3d4
[ 2995.740685]  [<ffffffff810ad19e>] ? shrink_slab+0x14a/0x15c
[ 2995.740685]  [<ffffffff810adb65>] do_try_to_free_pages+0x176/0x27f
[ 2995.740685]  [<ffffffff8103de67>] ? irq_exit+0x93/0x95
[ 2995.740685]  [<ffffffff810add03>] shrink_all_memory+0x95/0xc4
[ 2995.740685]  [<ffffffff810ab0f0>] ? isolate_pages_global+0x0/0x217
[ 2995.740685]  [<ffffffff81077503>] ? count_data_pages+0x65/0x79
[ 2995.740685]  [<ffffffff8107776a>] hibernate_preallocate_memory+0x1aa/0x2cb
[ 2995.740685]  [<ffffffff813f95b5>] ? printk+0x41/0x44
[ 2995.740685]  [<ffffffff810760b3>] hibernation_snapshot+0x36/0x1e1
[ 2995.740685]  [<ffffffff8107632c>] hibernate+0xce/0x172
[ 2995.740685]  [<ffffffff81075099>] state_store+0x5c/0xd3
[ 2995.740685]  [<ffffffff8118728f>] kobj_attr_store+0x17/0x19
[ 2995.740685]  [<ffffffff81127b69>] sysfs_write_file+0x108/0x144
[ 2995.740685]  [<ffffffff810d66ff>] vfs_write+0xb2/0x153
[ 2995.740685]  [<ffffffff810641a9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[ 2995.740685]  [<ffffffff810d6863>] sys_write+0x4a/0x71
[ 2995.740685]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
[ 2995.740685] Code: c7 c7 90 16 67 81 e8 79 f1 25 00 48 c7 c7 90 16 67 81 e8 e1 e7 25 00 48 c7 c7 30 18 67 81 e8 d5 e7 25 00 c9 c3 90 90 55 48 89 e5 <0f> b7 07 38 e0 8d 90 00 01 00 00 75 05 f0 66 0f b1 17 0f 94 c2 
[ 2995.740685] RIP  [<ffffffff8119c0d0>] do_raw_spin_trylock+0x4/0x3a
[ 2995.740685]  RSP <ffff88022fa03438>
[ 2995.740685] CR2: 00007faf064ff1f0
[ 2995.762521] ---[ end trace 92c25d74e4800969 ]---
[ 2995.762686] Fixing recursive fault but reboot is needed!
[ 2995.762855] BUG: scheduling while atomic: hib.sh/7440/0x00000005
[ 2995.763026] INFO: lockdep is turned off.
[ 2995.763203] Modules linked in: tun powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd pcspkr 8250_pnp 8250 k10temp edac_core serial_core
[ 2995.764799] Pid: 7440, comm: hib.sh Tainted: G      D    2.6.34-rc3-00288-gab195c5 #1
[ 2995.765080] Call Trace:
[ 2995.765256]  [<ffffffff810636bf>] ? __debug_show_held_locks+0x1b/0x24
[ 2995.765429]  [<ffffffff8102d499>] __schedule_bug+0x72/0x77
[ 2995.765600]  [<ffffffff813f9a0a>] schedule+0xd9/0x730
[ 2995.765771]  [<ffffffff8103b7f7>] do_exit+0xcf/0x6a2
[ 2995.765941]  [<ffffffff81038f84>] ? kmsg_dump+0x13b/0x155
[ 2995.766115]  [<ffffffff810060db>] ? oops_end+0x47/0x93
[ 2995.766295]  [<ffffffff81006122>] oops_end+0x8e/0x93
[ 2995.766462]  [<ffffffff8101ed99>] no_context+0x1fc/0x20b
[ 2995.766632]  [<ffffffff810641a9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[ 2995.766806]  [<ffffffff8101ef34>] __bad_area_nosemaphore+0x18c/0x1af
[ 2995.766977]  [<ffffffff8101f16f>] ? do_page_fault+0xa8/0x32d
[ 2995.767161]  [<ffffffff8101ef6a>] bad_area_nosemaphore+0x13/0x15
[ 2995.767330]  [<ffffffff8101f23a>] do_page_fault+0x173/0x32d
[ 2995.767501]  [<ffffffff810a9eca>] ? release_pages+0x1ee/0x200
[ 2995.767673]  [<ffffffff813fdaa3>] ? error_sti+0x5/0x6
[ 2995.767842]  [<ffffffff81063167>] ? trace_hardirqs_off_caller+0x1f/0xa9
[ 2995.768017]  [<ffffffff813fc48e>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2995.768202]  [<ffffffff810d26f5>] ? kmem_cache_free+0x56/0x129
[ 2995.768373]  [<ffffffff813fd8bf>] page_fault+0x1f/0x30
[ 2995.768544]  [<ffffffff810d26f5>] ? kmem_cache_free+0x56/0x129
[ 2995.768716]  [<ffffffff8119c0d0>] ? do_raw_spin_trylock+0x4/0x3a
[ 2995.768888]  [<ffffffff813fc6c3>] _raw_spin_lock+0x48/0x73
[ 2995.769064]  [<ffffffff810c1ae3>] ? unlink_anon_vmas+0x40/0xe1
[ 2995.769246]  [<ffffffff810c1ae3>] unlink_anon_vmas+0x40/0xe1
[ 2995.769415]  [<ffffffff810bb562>] free_pgtables+0x68/0xce
[ 2995.769586]  [<ffffffff810bd11e>] exit_mmap+0x100/0x182
[ 2995.769756]  [<ffffffff81035b58>] mmput+0x43/0xea
[ 2995.769925]  [<ffffffff81039e99>] exit_mm+0x110/0x11d
[ 2995.770099]  [<ffffffff8103b8ed>] do_exit+0x1c5/0x6a2
[ 2995.770279]  [<ffffffff81038f84>] ? kmsg_dump+0x13b/0x155
[ 2995.770447]  [<ffffffff810060db>] ? oops_end+0x47/0x93
[ 2995.770616]  [<ffffffff81006122>] oops_end+0x8e/0x93
[ 2995.770785]  [<ffffffff8101ed99>] no_context+0x1fc/0x20b
[ 2995.770955]  [<ffffffff8101ef34>] __bad_area_nosemaphore+0x18c/0x1af
[ 2995.771141]  [<ffffffff8101f16f>] ? do_page_fault+0xa8/0x32d
[ 2995.771311]  [<ffffffff8101ef6a>] bad_area_nosemaphore+0x13/0x15
[ 2995.771482]  [<ffffffff8101f23a>] do_page_fault+0x173/0x32d
[ 2995.771653]  [<ffffffff810802f9>] ? __call_rcu+0x11d/0x130
[ 2995.771824]  [<ffffffff813fdaa3>] ? error_sti+0x5/0x6
[ 2995.771994]  [<ffffffff81063167>] ? trace_hardirqs_off_caller+0x1f/0xa9
[ 2995.772179]  [<ffffffff813fc48e>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2995.772352]  [<ffffffff813fd8bf>] page_fault+0x1f/0x30
[ 2995.772524]  [<ffffffff810c194d>] ? page_referenced+0xee/0x1dc
[ 2995.772696]  [<ffffffff810c18df>] ? page_referenced+0x80/0x1dc
[ 2995.772867]  [<ffffffff810c6d40>] ? swapcache_free+0x37/0x3c
[ 2995.773043]  [<ffffffff810ac31d>] shrink_page_list+0x171/0x4b1
[ 2995.773226]  [<ffffffff813fd1e6>] ? _raw_spin_unlock_irq+0x30/0x58
[ 2995.773398]  [<ffffffff810ac9b9>] shrink_inactive_list+0x35c/0x623
[ 2995.773572]  [<ffffffff810acd94>] ? shrink_zone+0x114/0x3d4
[ 2995.773742]  [<ffffffff81064f29>] ? print_lock_contention_bug+0x1b/0xe1
[ 2995.773916]  [<ffffffff813fc790>] ? _raw_spin_lock_irq+0x19/0x79
[ 2995.774093]  [<ffffffff810acf8a>] shrink_zone+0x30a/0x3d4
[ 2995.774274]  [<ffffffff810ad19e>] ? shrink_slab+0x14a/0x15c
[ 2995.774444]  [<ffffffff810adb65>] do_try_to_free_pages+0x176/0x27f
[ 2995.774617]  [<ffffffff8103de67>] ? irq_exit+0x93/0x95
[ 2995.774786]  [<ffffffff810add03>] shrink_all_memory+0x95/0xc4
[ 2995.774958]  [<ffffffff810ab0f0>] ? isolate_pages_global+0x0/0x217
[ 2995.775144]  [<ffffffff81077503>] ? count_data_pages+0x65/0x79
[ 2995.775314]  [<ffffffff8107776a>] hibernate_preallocate_memory+0x1aa/0x2cb
[ 2995.775487]  [<ffffffff813f95b5>] ? printk+0x41/0x44
[ 2995.775657]  [<ffffffff810760b3>] hibernation_snapshot+0x36/0x1e1
[ 2995.775828]  [<ffffffff8107632c>] hibernate+0xce/0x172
[ 2995.775998]  [<ffffffff81075099>] state_store+0x5c/0xd3
[ 2995.776182]  [<ffffffff8118728f>] kobj_attr_store+0x17/0x19
[ 2995.776350]  [<ffffffff81127b69>] sysfs_write_file+0x108/0x144
[ 2995.776521]  [<ffffffff810d66ff>] vfs_write+0xb2/0x153
[ 2995.776690]  [<ffffffff810641a9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[ 2995.776863]  [<ffffffff810d6863>] sys_write+0x4a/0x71
[ 2995.777038]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b

-- 
Regards/Gruss,
Boris.
