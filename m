Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab0DJQpF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 12:45:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60947 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0DJQpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 12:45:01 -0400
Date: Sat, 10 Apr 2010 18:38:28 +0200
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
Message-ID: <20100410163828.GA25579@a1.tnic>
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
References: <20100409191425.GB10780@a1.tnic>
 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
 <20100409204328.GG28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
 <20100410072714.GA9246@liondog.tnic>
 <20100410112639.GA24708@a1.tnic>
 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, Apr 10, 2010 at 08:24:02AM -0700

> No, I think we're good. I suspect this is a different issue. Do you have 
> lockdep enabled, along with mutex and spinlock debugging etc? That might 
> help pinpoint what triggers this.

I had pretty much all lock debugging options enabled except PROVE_RCU.

> But I think the fact that you are apparently not able to get the list 
> corruption is a good sign. Of course, it might just be harder to trigger, 
> and these things could all be a sign of a different bug, but my gut feel 
> is that we did fix something, and you are just damn good at stressing the 
> new code. Kudos.

Yep, even my mom says I'm good at breaking things :) But seriously,
thanks - means a lot coming from you.

And I got an oops again, this time the #GP from couple of days ago.

<thinking out loud>

I'm starting to think that maybe there could be something wrong with the
machine I'm running it on. Especially since there are only two people
who reported this issue, Steinar and me, so how probable is it that
maybe those two machines have failing RAM module somewhere? Or some
other data corrupting thing? Although I should be getting mchecks...
Hmm...

</thinking out loud>

Im going to run the stress test on 2.6.33.2 to verify whether this is
actually software-related. Just in case. Oh, yes, I almost forgot, the
latest and greatest in the world of oopsies:


[  452.351588] general protection fault: 0000 [#1] PREEMPT SMP 
[  452.352119] last sysfs file: /sys/power/state
[  452.352131] CPU 1 
[  452.352131] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 edac_core serial_core ohci_hcd pcspkr k10temp
[  452.352131] 
[  452.352131] Pid: 2929, comm: hib.sh Not tainted 2.6.34-rc3-00501-gefb57c0 #4 M3A78 PRO/System Product Name
[  452.352131] RIP: 0010:[<ffffffff810c5f00>]  [<ffffffff810c5f00>] page_referenced+0xee/0x1dc
[  452.352131] RSP: 0018:ffff88022adb18b8  EFLAGS: 00010206
[  452.352131] RAX: ffff88022ad5c468 RBX: ffffea0007598558 RCX: 0000000000000000
[  452.352131] RDX: ffff88022adb1cf8 RSI: ffff88022ad5c440 RDI: ffff88022e7d38a0
[  452.352131] RBP: ffff88022adb1938 R08: 0000000000000002 R09: 0000000000000000
[  452.352131] R10: ffff88022be83868 R11: ffffffff00000012 R12: 0000000000000000
[  452.352131] R13: 0032323200323212 R14: ffff88022ad5c428 R15: ffff88022adb1a00
[  452.352131] FS:  00007f056a1e36f0(0000) GS:ffff88000a200000(0000) knlGS:0000000000000000
[  452.352131] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  452.352131] CR2: 000000000250e408 CR3: 000000022983f000 CR4: 00000000000006e0
[  452.352131] DR0: 00000000000000a0 DR1: 0000000000000000 DR2: 0000000000000003
[  452.352131] DR3: 00000000000000b0 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  452.352131] Process hib.sh (pid: 2929, threadinfo ffff88022adb0000, task ffff88022e7d38a0)
[  452.352131] Stack:
[  452.352131]  ffff88022ad5c468 00000000810c5c1f ffff88022adb1918 ffffffff810c5d88
[  452.352131] <0> ffff88022adb18f8 ffffffff00000001 ffffea00075c89c0 ffffea00075984e8
[  452.352131] <0> ffffea00075984e8 000000022adb1cf8 ffffea00075984e8 ffffea0007598580
[  452.352131] Call Trace:
[  452.352131]  [<ffffffff810c5d88>] ? try_to_unmap_anon+0xa2/0xb4
[  452.352131]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  452.352131]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  452.352131]  [<ffffffff810af59c>] ? isolate_pages_global+0xd0/0x1fc
[  452.352131]  [<ffffffff8140f856>] ? _raw_spin_unlock_irq+0x30/0x58
[  452.352131]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  452.352131]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  452.352131]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  452.352131]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  452.352131]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  452.352131]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  452.352131]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  452.352131]  [<ffffffff8140bbd4>] ? printk+0x41/0x45
[  452.352131]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  452.352131]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  452.352131]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  452.352131]  [<ffffffff8118f3cf>] kobj_attr_store+0x17/0x19
[  452.352131]  [<ffffffff8112e288>] sysfs_write_file+0x108/0x144
[  452.352131]  [<ffffffff810db4ff>] vfs_write+0xb2/0x153
[  452.352131]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  452.352131]  [<ffffffff810db663>] sys_write+0x4a/0x71
[  452.352131]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b
[  452.352131] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 11 f2 ff ff 41 01 c4 83 7d cc 00 74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
[  452.352131] RIP  [<ffffffff810c5f00>] page_referenced+0xee/0x1dc
[  452.352131]  RSP <ffff88022adb18b8>
[  452.368192] ---[ end trace a9c84cb81ab9fd41 ]---
[  452.368372] note: hib.sh[2929] exited with preempt_count 2
[  452.368564] BUG: scheduling while atomic: hib.sh/2929/0x10000003
[  452.368742] INFO: lockdep is turned off.
[  452.368915] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod 8250_pnp 8250 edac_core serial_core ohci_hcd pcspkr k10temp
[  452.370749] Pid: 2929, comm: hib.sh Tainted: G      D    2.6.34-rc3-00501-gefb57c0 #4
[  452.371051] Call Trace:
[  452.371239]  [<ffffffff810658df>] ? __debug_show_held_locks+0x1b/0x24
[  452.371425]  [<ffffffff8102dfac>] __schedule_bug+0x72/0x77
[  452.371608]  [<ffffffff8140bfe8>] schedule+0xe3/0x7ff
[  452.371788]  [<ffffffff810bd066>] ? unmap_vmas+0x88e/0x893
[  452.371973]  [<ffffffff81030ecb>] __cond_resched+0x18/0x24
[  452.372168]  [<ffffffff8140c7d1>] _cond_resched+0x2c/0x37
[  452.372348]  [<ffffffff810bcea6>] unmap_vmas+0x6ce/0x893
[  452.372531]  [<ffffffff8140f8b6>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[  452.372721]  [<ffffffff810c1604>] exit_mmap+0xd7/0x182
[  452.372903]  [<ffffffff810368bc>] mmput+0x48/0xb9
[  452.373088]  [<ffffffff8103ad90>] exit_mm+0x110/0x11d
[  452.373284]  [<ffffffff8103c9e6>] do_exit+0x1c5/0x6e5
[  452.373464]  [<ffffffff81039e2f>] ? kmsg_dump+0x13b/0x155
[  452.373645]  [<ffffffff8100616b>] ? oops_end+0x47/0x93
[  452.373826]  [<ffffffff810061b2>] oops_end+0x8e/0x93
[  452.374006]  [<ffffffff810063a3>] die+0x5a/0x63
[  452.374198]  [<ffffffff81003eef>] do_general_protection+0x134/0x13c
[  452.374382]  [<ffffffff8140fdb0>] ? irq_return+0x0/0x2
[  452.374565]  [<ffffffff8140ff8f>] general_protection+0x1f/0x30
[  452.374754]  [<ffffffff810c5f00>] ? page_referenced+0xee/0x1dc
[  452.374940]  [<ffffffff810c5e92>] ? page_referenced+0x80/0x1dc
[  452.375147]  [<ffffffff810c5d88>] ? try_to_unmap_anon+0xa2/0xb4
[  452.375335]  [<ffffffff810b06bc>] shrink_page_list+0x154/0x4c7
[  452.375519]  [<ffffffff81067149>] ? print_lock_contention_bug+0x1b/0xe1
[  452.375703]  [<ffffffff810af59c>] ? isolate_pages_global+0xd0/0x1fc
[  452.375888]  [<ffffffff8140f856>] ? _raw_spin_unlock_irq+0x30/0x58
[  452.376080]  [<ffffffff810b0d8a>] shrink_inactive_list+0x35b/0x60c
[  452.376284]  [<ffffffff810b1347>] shrink_zone+0x30c/0x3d6
[  452.376476]  [<ffffffff810b1f3d>] do_try_to_free_pages+0x191/0x29a
[  452.376664]  [<ffffffff810b20db>] shrink_all_memory+0x95/0xc4
[  452.376852]  [<ffffffff810af4cc>] ? isolate_pages_global+0x0/0x1fc
[  452.377038]  [<ffffffff81079c9c>] ? count_data_pages+0x65/0x79
[  452.377238]  [<ffffffff81079f03>] hibernate_preallocate_memory+0x1aa/0x2cb
[  452.377429]  [<ffffffff8140bbd4>] ? printk+0x41/0x45
[  452.377611]  [<ffffffff8107878f>] hibernation_snapshot+0x36/0x1e1
[  452.377794]  [<ffffffff81078a08>] hibernate+0xce/0x172
[  452.377975]  [<ffffffff81077775>] state_store+0x5c/0xd3
[  452.378170]  [<ffffffff8118f3cf>] kobj_attr_store+0x17/0x19
[  452.378351]  [<ffffffff8112e288>] sysfs_write_file+0x108/0x144
[  452.378533]  [<ffffffff810db4ff>] vfs_write+0xb2/0x153
[  452.378714]  [<ffffffff810663c9>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  452.378898]  [<ffffffff810db663>] sys_write+0x4a/0x71
[  452.379084]  [<ffffffff8100221b>] system_call_fastpath+0x16/0x1b

-- 
Regards/Gruss,
Boris.
