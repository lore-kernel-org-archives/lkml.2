Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0DKSzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 14:55:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36461 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0DKSzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 14:55:16 -0400
Date: Sun, 11 Apr 2010 20:55:08 +0200
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
Message-ID: <20100411185508.GA4450@liondog.tnic>
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
References: <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
 <20100410203628.GB32035@a1.tnic>
 <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org>
 <20100410212555.GA1797@a1.tnic>
 <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org>
 <20100410215115.GA2599@a1.tnic>
 <20100411130801.GA7189@a1.tnic>
 <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, Apr 11, 2010 at 10:16:10AM -0700

> Conversely, if you still see the oops (rather than the watchdog), that 
> means that we actually have pages that are still marked mapped, and that 
> despite that mapped state have a stale page->mapping pointer. I actually 
> find that the more likely case, because otherwise the window is _so_ small 
> that I don't see how you can hit the oops so reliably.

Ok, did test with the all 5 patches applied. It oopsed with the same
trace, see below. Except one kernel/sched.c:3555 warning checking
spinlock count overflowing, nothing else. :(

I tried to see whether the page->mapping pointer is stale, I dunno,
maybe there could be something in the register dump which could tell us
what's happening. This is how I see it, I could very well be wrong and
missing something though:


So, yes, we oops at the same place, however, a bit early we do

	anon_vma = page_lock_anon_vma(page);
	if (!anon_vma)
		return referenced;

which compiles here to

	.loc 1 496 0
	movq	%rbx, %rdi	# page,
	call	page_lock_anon_vma	#
.LVL288:
	.loc 1 497 0
	testq	%rax, %rax	# anon_vma
.LVL289:
	.loc 1 496 0
	movq	%rax, %r14	#, anon_vma

and I checked that on the path before the instruction where we oops we
don't touch %r14 so the value in the register dump below should be that
anon_vma. Which looks like valid kernel pointer. We dereference it later
to get anon_vma->head.next with

	.loc 1 501 0
	movq	64(%r14), %r13	# <variable>.head.next, <variable>.head.next
.LBE1287:
	leaq	64(%r14), %rax	#,
	movq	%rax, -128(%rbp)	#, %sfp
.LBB1288:
	subq	$32, %r13	#, avc

which ends up in %r13 as ffffffffffffffe0.

So, it really looks like at least that list_head in anon_vma is
bollocks, or even the whole anon_vma. So if this is correct, it is
highly likely that the anon_vma is already freed material or not
initialized at all.

Hm...


[  616.317201] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  616.329964] PM: Preallocating image memory... 
[  616.586463] BUG: unable to handle kernel NULL pointer dereference at (null)
[  616.586851] IP: [<ffffffff810c614f>] page_referenced+0xee/0x1dc
[  616.587045] PGD 225dcf067 PUD 22627f067 PMD 0 
[  616.587126] Oops: 0000 [#1] PREEMPT SMP 
[  616.587126] last sysfs file: /sys/power/state
[  616.587126] CPU 1 
[  616.587126] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd edac_core 8250_pnp 8250 serial_core pcspkr k10temp
[  616.587126] 
[  616.587126] Pid: 3453, comm: hib.sh Tainted: G        W  2.6.34-rc3-00505-g1d9bb34 #1 M3A78 PRO/System Product Name
[  616.587126] RIP: 0010:[<ffffffff810c614f>]  [<ffffffff810c614f>] page_referenced+0xee/0x1dc
[  616.587126] RSP: 0018:ffff88022b3258b8  EFLAGS: 00010283
[  616.587126] RAX: ffff880200ba4b88 RBX: ffffea00076b2b30 RCX: ffff88022eacaa58
[  616.587126] RDX: ffffffff810c5e7a RSI: ffff880200ba4b60 RDI: ffff88022fa492e0
[  616.587126] RBP: ffff88022b325938 R08: 0000000000000002 R09: 0000000000000000
[  616.587126] R10: ffff88022eacaa30 R11: 0000000000000001 R12: 0000000000000000
[  616.587126] R13: ffffffffffffffe0 R14: ffff880200ba4b48 R15: ffff88022b325a00
[  616.587126] FS:  00007f0b140306f0(0000) GS:ffff88000a200000(0000) knlGS:0000000000000000
[  616.587126] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  616.587126] CR2: 0000000000000000 CR3: 000000022c44f000 CR4: 00000000000006e0
[  616.587126] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  616.587126] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  616.587126] Process hib.sh (pid: 3453, threadinfo ffff88022b324000, task ffff88022fa492e0)
[  616.587126] Stack:
[  616.587126]  ffff880200ba4b88 00000000810c5e5f ffff88022b325918 ffffffff810c5fd7
[  616.587126] <0> ffff880200000000 ffffffff00000001 ffff88022b325fd8 ffffea00076c1a80
[  616.587126] <0> ffffea00076c1a80 000000022b325cf8 ffffea00076c1a80 ffffea00076b2b58
[  616.587126] Call Trace:
[  616.587126]  [<ffffffff810c5fd7>] ? try_to_unmap_anon+0xa2/0xb4
[  616.587126]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  616.587126]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  616.587126]  [<ffffffff810af59c>] ? isolate_pages_global+0xd0/0x1fc
[  616.587126]  [<ffffffff8140fb06>] ? _raw_spin_unlock_irq+0x30/0x58
[  616.587126]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  616.587126]  [<ffffffff810b0556>] ? shrink_active_list+0x232/0x244
[  616.587126]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  616.587126]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  616.587126]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  616.587126]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  616.587126]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  616.587126]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  616.587126]  [<ffffffff8140be84>] ? printk+0x41/0x45
[  616.587126]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  616.587126]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  616.587126]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  616.587126]  [<ffffffff8118f687>] kobj_attr_store+0x17/0x19
[  616.587126]  [<ffffffff8112e540>] sysfs_write_file+0x108/0x144
[  616.587126]  [<ffffffff810db74f>] vfs_write+0xb2/0x153
[  616.587126]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  616.587126]  [<ffffffff810db8b3>] sys_write+0x4a/0x71
[  616.587126]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  616.587126] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 02 f2 ff ff 41 01 c4 83 7d cc 00 74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
[  616.587126] RIP  [<ffffffff810c614f>] page_referenced+0xee/0x1dc
[  616.587126]  RSP <ffff88022b3258b8>
[  616.587126] CR2: 0000000000000000
[  616.600838] ---[ end trace 0ea0c6b4ead21c8f ]---
[  616.600984] note: hib.sh[3453] exited with preempt_count 2
[  616.601282] BUG: scheduling while atomic: hib.sh/3453/0x10000003
[  616.601431] INFO: lockdep is turned off.
[  616.601584] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd edac_core 8250_pnp 8250 serial_core pcspkr k10temp
[  616.603115] Pid: 3453, comm: hib.sh Tainted: G      D W  2.6.34-rc3-00505-g1d9bb34 #1
[  616.603460] Call Trace:
[  616.603605]  [<ffffffff810658df>] ? __debug_show_held_locks+0x1b/0x24
[  616.603755]  [<ffffffff8102dfac>] __schedule_bug+0x72/0x77
[  616.603903]  [<ffffffff8140c298>] schedule+0xe3/0x7ff
[  616.604051]  [<ffffffff810bd0e4>] ? unmap_vmas+0x90c/0x911
[  616.604230]  [<ffffffff81030ecb>] __cond_resched+0x18/0x24
[  616.604381]  [<ffffffff8140ca81>] _cond_resched+0x2c/0x37
[  616.604529]  [<ffffffff810bcef1>] unmap_vmas+0x719/0x911
[  616.604678]  [<ffffffff810c16c0>] exit_mmap+0x102/0x1e4
[  616.604826]  [<ffffffff810c1627>] ? exit_mmap+0x69/0x1e4
[  616.604975]  [<ffffffff810368bc>] mmput+0x48/0xb9
[  616.605124]  [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  616.605280]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  616.605430]  [<ffffffff81039e2f>] ? kmsg_dump+0x13b/0x155
[  616.605579]  [<ffffffff8100616b>] ? oops_end+0x47/0x93
[  616.605727]  [<ffffffff810061b2>] oops_end+0x8e/0x93
[  616.605875]  [<ffffffff8101f3e5>] no_context+0x1fc/0x20b
[  616.606023]  [<ffffffff8101f580>] __bad_area_nosemaphore+0x18c/0x1af
[  616.606176]  [<ffffffff8101f7bb>] ? do_page_fault+0xa8/0x32d
[  616.606330]  [<ffffffff8101f5b6>] bad_area_nosemaphore+0x13/0x15
[  616.606479]  [<ffffffff8101f886>] do_page_fault+0x173/0x32d
[  616.606628]  [<ffffffff81410463>] ? error_sti+0x5/0x6
[  616.606776]  [<ffffffff81065387>] ? trace_hardirqs_off_caller+0x1f/0xa9
[  616.606926]  [<ffffffff8140edab>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  616.607076]  [<ffffffff8141027f>] page_fault+0x1f/0x30
[  616.607227]  [<ffffffff810c5e7a>] ? page_lock_anon_vma+0x0/0xbb
[  616.607381]  [<ffffffff810c614f>] ? page_referenced+0xee/0x1dc
[  616.607530]  [<ffffffff810c60e1>] ? page_referenced+0x80/0x1dc
[  616.607678]  [<ffffffff810c5fd7>] ? try_to_unmap_anon+0xa2/0xb4
[  616.607827]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  616.607976]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  616.608131]  [<ffffffff810af59c>] ? isolate_pages_global+0xd0/0x1fc
[  616.608284]  [<ffffffff8140fb06>] ? _raw_spin_unlock_irq+0x30/0x58
[  616.608435]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  616.608585]  [<ffffffff810b0556>] ? shrink_active_list+0x232/0x244
[  616.608734]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  616.608883]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  616.609031]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  616.609183]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  616.609337]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  616.609486]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  616.609636]  [<ffffffff8140be84>] ? printk+0x41/0x45
[  616.609784]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  616.609933]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  616.610080]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  616.610233]  [<ffffffff8118f687>] kobj_attr_store+0x17/0x19
[  616.610383]  [<ffffffff8112e540>] sysfs_write_file+0x108/0x144
[  616.610532]  [<ffffffff810db74f>] vfs_write+0xb2/0x153
[  616.610680]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  616.610830]  [<ffffffff810db8b3>] sys_write+0x4a/0x71
[  616.610978]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  682.501863] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[  683.552767] SysRq : Emergency Sync
[  683.553147] Emergency Sync complete
[  684.180708] SysRq : Emergency Remount R/O
[  684.927560] SysRq : Resetting

-- 
Regards/Gruss,
    Boris.
