Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab0DGHWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:22:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50019 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab0DGHWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:22:15 -0400
Date: Wed, 7 Apr 2010 09:22:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-ID: <20100407072211.GA11220@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Rik van Riel <riel@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
 <20100406194238.GB20357@a1.tnic>
 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
 <20100406205123.GC20357@a1.tnic>
 <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
 <4BBBC240.3090302@redhat.com>
 <alpine.LFD.2.00.1004061707250.3487@i5.linux-foundation.org>
 <4BBBDD64.9030800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4BBBDD64.9030800@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>
Date: Tue, Apr 06, 2010 at 09:18:28PM -0400

Hi Rik,

I think your patch needs a bit more baking, see below :)

> >I suspect Borislav is sleeping. But at least we have a patch for him to
> >test when he wakes up ;)
> 
> I am looking forward to the test results.

This happens when starting X, I haven't even started hibernating.

  [By the way, further testing will have to wait till tonight since I
   have a job, you know :) ]

Also, mm/rmap.c:745 is

	BUG_ON(!anon_vma);

in __page_set_anon_rmap().

---
[   43.142371] ------------[ cut here ]------------
[   43.142411] kernel BUG at mm/rmap.c:745!
[   43.142436] invalid opcode: 0000 [#1] PREEMPT SMP 
[   43.142514] last sysfs file: /sys/devices/virtual/vtconsole/vtcon0/uevent
[   43.142537] CPU 0 
[   43.142559] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 edac_core serial_core k10temp ohci_hcd pcspkr
[   43.142997] 
[   43.143012] Pid: 1940, comm: console-kit-dae Not tainted 2.6.34-rc3-00289-gae1ed76 #5 M3A78 PRO/System Product Name
[   43.143012] RIP: 0010:[<ffffffff810c08e7>]  [<ffffffff810c08e7>] page_add_new_anon_rmap+0x3b/0x89
[   43.143012] RSP: 0000:ffff88022c019da8  EFLAGS: 00010246
[   43.143012] RAX: 0000000000000000 RBX: ffffea000774ff78 RCX: 000000002ce900f4
[   43.143012] RDX: ffff88000a1d5dc8 RSI: 0000000000000007 RDI: ffffffff816e8740
[   43.143012] RBP: ffff88022c019dc8 R08: 00007f29e3cfd928 R09: 000000000062c318
[   43.143012] R10: 0000000000000000 R11: 0000000000000002 R12: ffff88022bbad960
[   43.143012] R13: 00007f29e3cfd928 R14: 00007f29e3cfd928 R15: 80000002216d9067
[   43.143012] FS:  00007f29e3d0f790(0000) GS:ffff88000a000000(0000) knlGS:0000000000000000
[   43.143012] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.143012] CR2: 00007f29e3cfd928 CR3: 000000022dfd3000 CR4: 00000000000006f0
[   43.143012] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   43.143012] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   43.143012] Process console-kit-dae (pid: 1940, threadinfo ffff88022c018000, task ffff88022ce90000)
[   43.143012] Stack:
[   43.143012]  ffffffff810b8802 ffff88022bbad960 ffff88022ea3c600 ffff88022bb6d7e8
[   43.143012] <0> ffff88022c019e48 ffffffff810b8823 ffff88022ea3c6b8 0000000000000246
[   43.143012] <0> ffffea000774ff78 0000000000000001 00000001e3cfd928 ffff88022fdb58f0
[   43.143012] Call Trace:
[   43.143012]  [<ffffffff810b8802>] ? handle_mm_fault+0x2af/0x64e
[   43.143012]  [<ffffffff810b8823>] handle_mm_fault+0x2d0/0x64e
[   43.143012]  [<ffffffff8101f392>] do_page_fault+0x30b/0x32d
[   43.143012]  [<ffffffff810615ce>] ? put_lock_stats+0xe/0x27
[   43.143012]  [<ffffffff81062a55>] ? lock_release_holdtime+0x104/0x109
[   43.143012]  [<ffffffff813f93e3>] ? error_sti+0x5/0x6
[   43.143012]  [<ffffffff813f7de2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   43.143012]  [<ffffffff813f91ff>] page_fault+0x1f/0x30
[   43.143012] Code: 00 00 48 89 fb 49 89 f4 49 89 d5 f0 80 4f 02 10 be 07 00 00 00 c7 47 0c 00 00 00 00 e8 c5 30 ff ff 49 8b 44 24 78 48 85 c0 75 04 <0f> 0b eb fe 48 ff c0 4c 89 e6 48 89 df 48 89 43 18 4d 2b 6c 24 
[   43.143012] RIP  [<ffffffff810c08e7>] page_add_new_anon_rmap+0x3b/0x89
[   43.143012]  RSP <ffff88022c019da8>
[   43.145276] ---[ end trace d6305f6e826dbd53 ]---
[   43.145314] note: console-kit-dae[1940] exited with preempt_count 1
[   73.644201] ------------[ cut here ]------------
[   73.644218] kernel BUG at mm/rmap.c:745!
[   73.644226] invalid opcode: 0000 [#2] PREEMPT SMP 
[   73.644266] last sysfs file: /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
[   73.644278] CPU 0 
[   73.644287] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 edac_core serial_core k10temp ohci_hcd pcspkr
[   73.644509] 
[   73.644520] Pid: 2018, comm: iceowl-bin Tainted: G      D    2.6.34-rc3-00289-gae1ed76 #5 M3A78 PRO/System Product Name
[   73.644534] RIP: 0010:[<ffffffff810c08e7>]  [<ffffffff810c08e7>] page_add_new_anon_rmap+0x3b/0x89
[   73.644553] RSP: 0000:ffff88022cd37da8  EFLAGS: 00010246
[   73.644562] RAX: 0000000000000000 RBX: ffffea000764dfa8 RCX: 0000000000000002
[   73.644572] RDX: ffff88000a1d5dc8 RSI: 0000000000000007 RDI: ffffffff816e8740
[   73.644589] RBP: ffff88022cd37dc8 R08: 00007f2ce0aab928 R09: 0000000000000000
[   73.644603] R10: 0000000000000000 R11: 000000000011da32 R12: ffff88022d5894b0
[   73.644615] R13: 00007f2ce0aab928 R14: 00007f2ce0aab928 R15: 800000021cd23067
[   73.644628] FS:  00007f2cee88b7b0(0000) GS:ffff88000a000000(0000) knlGS:0000000000000000
[   73.644639] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.644652] CR2: 00007f2ce0aab928 CR3: 000000022b1b5000 CR4: 00000000000006f0
[   73.644664] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   73.644675] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   73.644690] Process iceowl-bin (pid: 2018, threadinfo ffff88022cd36000, task ffff88022a74a5c0)
[   73.644701] Stack:
[   73.644708]  ffffffff810b8802 ffff88022d5894b0 ffff88022ce41e00 ffff88022d4b0558
[   73.644745] <0> ffff88022cd37e48 ffffffff810b8823 ffff88022ce41eb8 0000000000000246
[   73.644801] <0> ffffea000764dfa8 0000000000000001 00000001e0aab928 ffff88022c0a4828
[   73.644862] Call Trace:
[   73.644874]  [<ffffffff810b8802>] ? handle_mm_fault+0x2af/0x64e
[   73.644885]  [<ffffffff810b8823>] handle_mm_fault+0x2d0/0x64e
[   73.644895]  [<ffffffff8101f392>] do_page_fault+0x30b/0x32d
[   73.644909]  [<ffffffff810be3c2>] ? do_mmap_pgoff+0x290/0x2f3
[   73.644921]  [<ffffffff813f93e3>] ? error_sti+0x5/0x6
[   73.644932]  [<ffffffff81062b97>] ? trace_hardirqs_off_caller+0x1f/0xa9
[   73.644943]  [<ffffffff813f7de2>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   73.644952]  [<ffffffff813f91ff>] page_fault+0x1f/0x30
[   73.644963] Code: 00 00 48 89 fb 49 89 f4 49 89 d5 f0 80 4f 02 10 be 07 00 00 00 c7 47 0c 00 00 00 00 e8 c5 30 ff ff 49 8b 44 24 78 48 85 c0 75 04 <0f> 0b eb fe 48 ff c0 4c 89 e6 48 89 df 48 89 43 18 4d 2b 6c 24 
[   73.645001] RIP  [<ffffffff810c08e7>] page_add_new_anon_rmap+0x3b/0x89
[   73.645001]  RSP <ffff88022cd37da8>
[   73.645610] ---[ end trace d6305f6e826dbd54 ]---
[   73.645621] note: iceowl-bin[2018] exited with preempt_count 1
[   77.562222] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[   78.014120] SysRq : Emergency Sync
[   78.016864] Emergency Sync complete
[   78.585045] SysRq : Emergency Remount R/O
[   78.663367] Emergency Remount complete
[   79.098126] SysRq : Resetting

-- 
Regards/Gruss,
Boris.
