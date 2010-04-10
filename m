Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0DJNkG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 09:40:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47269 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0DJNkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 09:40:01 -0400
Date: Sat, 10 Apr 2010 13:26:39 +0200
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
Message-ID: <20100410112639.GA24708@a1.tnic>
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
References: <20100409174041.GA10780@a1.tnic>
 <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org>
 <20100409191425.GB10780@a1.tnic>
 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
 <20100409204328.GG28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
 <20100410072714.GA9246@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100410072714.GA9246@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Sat, Apr 10, 2010 at 09:27:14AM +0200

> Now why would you go and jinx it like that... :)
> 
> Hibernation runs back-to-back:
> 
> 1. light system load after boot... ok
> 2. 3 kvm guests, 3Gb mem free of 8Gb total acc. to /proc/meminfo... ok			[ this was the fireproof way to trigger the bug, btw]
> 3. kvm guests down, firefox loading a 4Mb html page... ok
> 4. start ubuntu guest, firefox keeps loading the 4Mb html page after previous resume... ok
> 5. ubuntu guest booting done, firefox done, play video... ok
> 6. video broken after resume due to:
> 
> [AO_ALSA] Pcm in suspend mode, trying to resume. 212%  2%  1.7% 1 0 
> [AO_ALSA] alsa-lib: pcm_hw.c:709:(snd_pcm_hw_resume) SNDRV_PCM_IOCTL_RESUME failed: Function not implemented
> 
> i.e., unrelated... still ok
> 
> 7. ubuntu guest downloading a 100Mb file causing allocation of a bunch of anon memory in the host... ok
> 8. all guests off, firefox off, back to light load... ok
> 
> No oopsies or problems in dmesg except the old lockdep sysfs warning.
> 
> I will keep running that kernel in the next couple of days and keep you
> informed in case this is the fix we're gonna use.

Yep, you jinxed it :)

This time we got stuck on the anon_vma->lock (yep, we've seen that
oopsie before). So, it might be that we _really_ are staring at the
wrong code... Back to square one.


[18969.797126] BUG: soft lockup - CPU#1 stuck for 61s! [hib.sh:5605]
[18969.797126] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 ohci_hcd pcspkr serial_core k10temp edac_core
[18969.798029] irq event stamp: 0
[18969.798029] hardirqs last  enabled at (0): [<(null)>] (null)
[18969.798029] hardirqs last disabled at (0): [<ffffffff8103657c>] copy_process+0x3c1/0x10cc
[18969.798029] softirqs last  enabled at (0): [<ffffffff8103657c>] copy_process+0x3c1/0x10cc
[18969.798029] softirqs last disabled at (0): [<(null)>] (null)
[18969.798029] CPU 1 
[18969.798029] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 ohci_hcd pcspkr serial_core k10temp edac_core
[18969.798029] 
[18969.798029] Pid: 5605, comm: hib.sh Not tainted 2.6.34-rc3-00501-gefb57c0 #1 M3A78 PRO/System Product Name
[18969.798029] RIP: 0010:[<ffffffff8118b7f4>]  [<ffffffff8118b7f4>] delay_tsc+0x33/0xca
[18969.798029] RSP: 0018:ffff8801aebdf7b8  EFLAGS: 00000206
[18969.798029] RAX: 00000000fc6fc9e8 RBX: ffff8801aebdf7e8 RCX: 0000000000001200
[18969.798029] RDX: 0000000000002806 RSI: ffff8801aebdf848 RDI: 0000000000000001
[18969.798029] RBP: ffffffff81002b4e R08: 0000000000000001 R09: 0000000000000000
[18969.798029] R10: ffff8801aebdf8a8 R11: 0000000000000001 R12: 0000000000000014
[18969.798029] R13: ffff88000a200000 R14: ffff8801aebde000 R15: ffff8801aebdffd8
[18969.798029] FS:  00007f2c86c656f0(0000) GS:ffff88000a200000(0000) knlGS:0000000000000000
[18969.798029] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[18969.798029] CR2: 00007fd515101870 CR3: 000000022bd9a000 CR4: 00000000000006e0
[18969.798029] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[18969.798029] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[18969.798029] Process hib.sh (pid: 5605, threadinfo ffff8801aebde000, task ffff88022e194b80)
[18969.798029] Stack:
[18969.798029]  0000000000000001 ffff88022d2db720 ffff88022e194b80 00000000b3477260
[18969.798029] <0> ffff88022e194f28 000000002a5200c6 ffff8801aebdf7f8 ffffffff8118b7bf
[18969.798029] <0> ffff8801aebdf848 ffffffff8119a296 ffff88022d2db738 0000000000000001
[18969.798029] Call Trace:
[18969.798029]  [<ffffffff8118b7bf>] ? __delay+0xf/0x11
[18969.798029]  [<ffffffff8119a296>] ? do_raw_spin_lock+0xd2/0x13c
[18969.798029]  [<ffffffff813f843b>] ? _raw_spin_lock+0x60/0x73
[18969.798029]  [<ffffffff810c0ae3>] ? page_lock_anon_vma+0x63/0xac
[18969.798029]  [<ffffffff810c0ae3>] ? page_lock_anon_vma+0x63/0xac
[18969.798029]  [<ffffffff810c0a80>] ? page_lock_anon_vma+0x0/0xac
[18969.798029]  [<ffffffff810c0cc9>] ? page_referenced+0x80/0x1dc
[18969.798029]  [<ffffffff810c60a0>] ? swapcache_free+0x37/0x3c
[18969.798029]  [<ffffffff810ab7e6>] ? shrink_page_list+0x14a/0x477
[18969.798029]  [<ffffffff810abe6a>] ? shrink_inactive_list+0x357/0x5e5
[18969.798029]  [<ffffffff810ab68a>] ? shrink_active_list+0x232/0x244
[18969.798029]  [<ffffffff810ac404>] ? shrink_zone+0x30c/0x3d6
[18969.798029]  [<ffffffff810acfdf>] ? do_try_to_free_pages+0x176/0x27f
[18969.798029]  [<ffffffff810ad17d>] ? shrink_all_memory+0x95/0xc4
[18969.798029]  [<ffffffff810aa680>] ? isolate_pages_global+0x0/0x1f0
[18969.798029]  [<ffffffff81076e80>] ? count_data_pages+0x65/0x79
[18969.798029]  [<ffffffff810770e7>] ? hibernate_preallocate_memory+0x1aa/0x2cb
[18969.798029]  [<ffffffff813f5445>] ? printk+0x41/0x44
[18969.798029]  [<ffffffff81075a87>] ? hibernation_snapshot+0x36/0x1e1
[18969.798029]  [<ffffffff81075d00>] ? hibernate+0xce/0x172
[18969.798029]  [<ffffffff81074a6d>] ? state_store+0x5c/0xd3
[18969.798029]  [<ffffffff8118504b>] ? kobj_attr_store+0x17/0x19
[18969.798029]  [<ffffffff81125e8b>] ? sysfs_write_file+0x108/0x144
[18969.798029]  [<ffffffff810d5807>] ? vfs_write+0xb2/0x153
[18969.798029]  [<ffffffff81063c0d>] ? trace_hardirqs_on_caller+0x1f/0x14b
[18969.798029]  [<ffffffff810d596b>] ? sys_write+0x4a/0x71
[18969.798029]  [<ffffffff810021db>] ? system_call_fastpath+0x16/0x1b
[18969.798029] Code: 41 55 41 54 53 48 83 ec 08 0f 1f 44 00 00 49 89 fc bf 01 00 00 00 e8 88 1d ea ff e8 db f4 00 00 41 89 c5 0f ae f0 66 66 90 0f 31 <89> c3 65 4c 8b 34 25 48 b5 00 00 0f ae f0 66 66 90 0f 31 41 89 
[18969.798029] Call Trace:
[18969.798029]  [<ffffffff8118b7bf>] ? __delay+0xf/0x11
[18969.798029]  [<ffffffff8119a296>] ? do_raw_spin_lock+0xd2/0x13c
[18969.798029]  [<ffffffff813f843b>] ? _raw_spin_lock+0x60/0x73
[18969.798029]  [<ffffffff810c0ae3>] ? page_lock_anon_vma+0x63/0xac
[18969.798029]  [<ffffffff810c0ae3>] ? page_lock_anon_vma+0x63/0xac
[18969.798029]  [<ffffffff810c0a80>] ? page_lock_anon_vma+0x0/0xac
[18969.798029]  [<ffffffff810c0cc9>] ? page_referenced+0x80/0x1dc
[18969.798029]  [<ffffffff810c60a0>] ? swapcache_free+0x37/0x3c
[18969.798029]  [<ffffffff810ab7e6>] ? shrink_page_list+0x14a/0x477
[18969.798029]  [<ffffffff810abe6a>] ? shrink_inactive_list+0x357/0x5e5
[18969.798029]  [<ffffffff810ab68a>] ? shrink_active_list+0x232/0x244
[18969.798029]  [<ffffffff810ac404>] ? shrink_zone+0x30c/0x3d6
[18969.798029]  [<ffffffff810acfdf>] ? do_try_to_free_pages+0x176/0x27f
[18969.798029]  [<ffffffff810ad17d>] ? shrink_all_memory+0x95/0xc4
[18969.798029]  [<ffffffff810aa680>] ? isolate_pages_global+0x0/0x1f0
[18969.798029]  [<ffffffff81076e80>] ? count_data_pages+0x65/0x79
[18969.798029]  [<ffffffff810770e7>] ? hibernate_preallocate_memory+0x1aa/0x2cb
[18969.798029]  [<ffffffff813f5445>] ? printk+0x41/0x44
[18969.798029]  [<ffffffff81075a87>] ? hibernation_snapshot+0x36/0x1e1
[18969.798029]  [<ffffffff81075d00>] ? hibernate+0xce/0x172
[18969.798029]  [<ffffffff81074a6d>] ? state_store+0x5c/0xd3
[18969.798029]  [<ffffffff8118504b>] ? kobj_attr_store+0x17/0x19
[18969.798029]  [<ffffffff81125e8b>] ? sysfs_write_file+0x108/0x144
[18969.798029]  [<ffffffff810d5807>] ? vfs_write+0xb2/0x153
[18969.798029]  [<ffffffff81063c0d>] ? trace_hardirqs_on_caller+0x1f/0x14b
[18969.798029]  [<ffffffff810d596b>] ? sys_write+0x4a/0x71
[18969.798029]  [<ffffffff810021db>] ? system_call_fastpath+0x16/0x1b
[19005.426655] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[19005.663484] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[19007.018563] SysRq : Emergency Sync
[19007.018969] Emergency Sync complete
[19007.582218] SysRq : Emergency Remount R/O
[19008.251934] SysRq : Power Off
[19010.076146] SysRq : Resetting


-- 
Regards/Gruss,
Boris.
