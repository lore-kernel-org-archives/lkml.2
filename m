Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0DJVfD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 17:35:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38382 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab0DJVfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 17:35:00 -0400
Date: Sat, 10 Apr 2010 23:25:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
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
Message-ID: <20100410212555.GA1797@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
 <20100410163828.GA25579@a1.tnic>
 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
 <20100410185145.GB28952@a1.tnic>
 <20100410185839.GA32035@a1.tnic>
 <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
 <20100410203628.GB32035@a1.tnic>
 <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, Apr 10, 2010 at 01:40:39PM -0700

> Yes. So the patches I actually think are important are:
> 
>  - the RCU fix is real, although admittedly the race window is probably 
>    too small to ever really hit.
> 
>  - the simplification rule to find_mergeable_anon_vma's is required, 
>    because otherwise our anon_vma_merge() will do the wrong thing (maybe 
>    Johannes' patch would be an alternative, but quite frankly, I think we 
>    want the simpler code, and I don't think we even _want_ to share 
>    anon_vma's that are complex due to forking)
> 
>    I like my "cleanup" version (the bigger one with lots of comments) more 
>    than the two-liner version, but they should be equivalent.
> 
>  - the vma_adjust() fix is the one that I think may actually end up fixing 
>    your problems for good. Knock wood.
> 
> So I think they are all required, but I suspect that the vma_adjust() one 
> is finally the most direct explanation of the problem you've seen.

Damn, nope, still no joy :(. It looked like it was fixed but one of the
test was to hibernate right after the 3 kvm guests were shut down and I
guess the mem freeing pattern kinda hits it where it most hurts.

Anyways, I'm going to bed soon, will test whatever you come up with guys
tomorrow morning when I can think again.

By the way, do we want to create a new thread - the mailchain is off the
screen limits of my netbook :)

Thanks.

p.s. Oopsie:


[  647.288638] PM: Syncing filesystems ... done.
[  647.307459] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  647.320981] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  647.334152] PM: Preallocating image memory... 
[  647.492781] BUG: unable to handle kernel NULL pointer dereference at (null)
[  647.493001] IP: [<ffffffff810c60a0>] page_referenced+0xee/0x1dc
[  647.493001] PGD 22a1d1067 PUD 1cb6a9067 PMD 0 
[  647.493001] Oops: 0000 [#1] PREEMPT SMP 
[  647.493001] last sysfs file: /sys/power/state
[  647.493001] CPU 0 
[  647.493001] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp ohci_hcd 8250 serial_core pcspkr k10temp edac_core
[  647.493001] 
[  647.493001] Pid: 3231, comm: hib.sh Not tainted 2.6.34-rc3-00503-g8b3334b #6 M3A78 PRO/System Product Name
[  647.493001] RIP: 0010:[<ffffffff810c60a0>]  [<ffffffff810c60a0>] page_referenced+0xee/0x1dc
[  647.493001] RSP: 0018:ffff880223b6f8b8  EFLAGS: 00010283
[  647.493001] RAX: ffff88022aa316c8 RBX: ffffea0006882fc0 RCX: 0000000000000000
[  647.493001] RDX: ffff880223b6fcf8 RSI: ffff88022aa316a0 RDI: ffff88022de6de60
[  647.493001] RBP: ffff880223b6f938 R08: 0000000000000002 R09: 0000000000000000
[  647.493001] R10: ffff880228cb03a8 R11: ffffffff00000012 R12: 0000000000000000
[  647.493001] R13: ffffffffffffffe0 R14: ffff88022aa31688 R15: ffff880223b6fa00
[  647.493001] FS:  00007f0eea2086f0(0000) GS:ffff88000a000000(0000) knlGS:0000000000000000
[  647.493001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  647.493001] CR2: 0000000000000000 CR3: 0000000223df5000 CR4: 00000000000006f0
[  647.493001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  647.493001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  647.493001] Process hib.sh (pid: 3231, threadinfo ffff880223b6e000, task ffff88022de6de60)
[  647.493001] Stack:
[  647.493001]  ffff88022aa316c8 00000000810c5dbf ffff880223b6f918 ffffffff810c5f28
[  647.493001] <0> ffff880223b6f8f8 ffffffff00000001 ffffea0006867570 ffffea0006889070
[  647.493001] <0> ffffea0006889070 0000000223b6fcf8 ffffea0006889070 ffffea0006882fe8
[  647.493001] Call Trace:
[  647.493001]  [<ffffffff810c5f28>] ? try_to_unmap_anon+0xa2/0xb4
[  647.493001]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  647.493001]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  647.493001]  [<ffffffff810b1155>] ? shrink_zone+0x11a/0x3d6
[  647.493001]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  647.493001]  [<ffffffff8140f000>] ? _raw_spin_lock_irq+0x19/0x79
[  647.493001]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  647.493001]  [<ffffffff810b155b>] ? shrink_slab+0x14a/0x15c
[  647.493001]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  647.493001]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  647.493001]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  647.493001]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  647.493001]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  647.493001]  [<ffffffff8140bdd4>] ? printk+0x41/0x45
[  647.493001]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  647.493001]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  647.493001]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  647.493001]  [<ffffffff8118f5d7>] kobj_attr_store+0x17/0x19
[  647.493001]  [<ffffffff8112e490>] sysfs_write_file+0x108/0x144
[  647.493001]  [<ffffffff810db69f>] vfs_write+0xb2/0x153
[  647.493001]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  647.493001]  [<ffffffff810db803>] sys_write+0x4a/0x71
[  647.493001]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  647.493001] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 11 f2 ff ff 41 01 c4 83 7d cc 00 74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
[  647.493001] RIP  [<ffffffff810c60a0>] page_referenced+0xee/0x1dc
[  647.493001]  RSP <ffff880223b6f8b8>
[  647.493001] CR2: 0000000000000000
[  647.508991] ---[ end trace 91f57fb5ef398fd2 ]---
[  647.509150] note: hib.sh[3231] exited with preempt_count 2
[  647.509311] BUG: scheduling while atomic: hib.sh/3231/0x10000003
[  647.509462] INFO: lockdep is turned off.
[  647.509610] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp ohci_hcd 8250 serial_core pcspkr k10temp edac_core
[  647.511093] Pid: 3231, comm: hib.sh Tainted: G      D    2.6.34-rc3-00503-g8b3334b #6
[  647.511353] Call Trace:
[  647.511504]  [<ffffffff810658df>] ? __debug_show_held_locks+0x1b/0x24
[  647.511658]  [<ffffffff8102dfac>] __schedule_bug+0x72/0x77
[  647.511811]  [<ffffffff8140c1e8>] schedule+0xe3/0x7ff
[  647.511962]  [<ffffffff810bd0e4>] ? unmap_vmas+0x90c/0x911
[  647.512191]  [<ffffffff81030ecb>] __cond_resched+0x18/0x24
[  647.512337]  [<ffffffff8140c9d1>] _cond_resched+0x2c/0x37
[  647.512550]  [<ffffffff810bcef1>] unmap_vmas+0x719/0x911
[  647.512697]  [<ffffffff810c1781>] exit_mmap+0x102/0x1e4
[  647.512911]  [<ffffffff810c16e8>] ? exit_mmap+0x69/0x1e4
[  647.513082]  [<ffffffff810368bc>] mmput+0x48/0xb9
[  647.513233]  [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  647.513387]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  647.513538]  [<ffffffff81039e2f>] ? kmsg_dump+0x13b/0x155
[  647.513690]  [<ffffffff8100616b>] ? oops_end+0x47/0x93
[  647.513859]  [<ffffffff810061b2>] oops_end+0x8e/0x93
[  647.514009]  [<ffffffff8101f3e5>] no_context+0x1fc/0x20b
[  647.514172]  [<ffffffff8118b72b>] ? cfq_insert_request+0x7a/0x3b1
[  647.514321]  [<ffffffff8101f580>] __bad_area_nosemaphore+0x18c/0x1af
[  647.514473]  [<ffffffff8101f7bb>] ? do_page_fault+0xa8/0x32d
[  647.514625]  [<ffffffff8101f5b6>] bad_area_nosemaphore+0x13/0x15
[  647.514777]  [<ffffffff8101f886>] do_page_fault+0x173/0x32d
[  647.514929]  [<ffffffff814103a3>] ? error_sti+0x5/0x6
[  647.515084]  [<ffffffff81065387>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  647.515242]  [<ffffffff8140ecfb>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  647.515397]  [<ffffffff814101bf>] page_fault+0x1f/0x30
[  647.515549]  [<ffffffff810c60a0>] ? page_referenced+0xee/0x1dc
[  647.515701]  [<ffffffff810c6032>] ? page_referenced+0x80/0x1dc
[  647.515853]  [<ffffffff810c5f28>] ? try_to_unmap_anon+0xa2/0xb4
[  647.516010]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  647.516167]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  647.516323]  [<ffffffff810b1155>] ? shrink_zone+0x11a/0x3d6
[  647.516474]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  647.516627]  [<ffffffff8140f000>] ? _raw_spin_lock_irq+0x19/0x79
[  647.516780]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  647.516931]  [<ffffffff810b155b>] ? shrink_slab+0x14a/0x15c
[  647.517086]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  647.517243]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  647.517398]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  647.517551]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  647.517703]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  647.517856]  [<ffffffff8140bdd4>] ? printk+0x41/0x45
[  647.518011]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  647.518168]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  647.518322]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  647.518473]  [<ffffffff8118f5d7>] kobj_attr_store+0x17/0x19
[  647.518625]  [<ffffffff8112e490>] sysfs_write_file+0x108/0x144
[  647.518777]  [<ffffffff810db69f>] vfs_write+0xb2/0x153
[  647.518928]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  647.519084]  [<ffffffff810db803>] sys_write+0x4a/0x71
[  647.519240]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  699.648857] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[  700.234923] SysRq : Emergency Sync
[  700.235341] Emergency Sync complete
[  700.982072] SysRq : Emergency Remount R/O
[  701.600802] SysRq : Resetting

-- 
Regards/Gruss,
Boris.
