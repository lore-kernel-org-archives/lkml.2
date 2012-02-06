Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2BFMK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:10:27 -0500
Received: from bar.sig21.net ([80.81.252.164]:38137 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab2BFMKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:10:24 -0500
Date: Mon, 6 Feb 2012 13:10:18 +0100
From: Johannes Stezenbach <js@sig21.net>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-3.2.2: BUG dentry: Poison overwritten after resume-from-disk
Message-ID: <20120206121018.GA3557@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my PC was suspended-to.disk over the weekend and crashed
about one minute after resume.  Luckily the BUG made
it into the log file before the box hung up hard.

I had a kvm running over suspend-resume in case it matters.

Feb  6 10:37:33 zzz kernel: [37877.172559] =============================================================================
Feb  6 10:37:33 zzz kernel: [37877.172564] BUG dentry: Poison overwritten
Feb  6 10:37:33 zzz kernel: [37877.172566] -----------------------------------------------------------------------------
Feb  6 10:37:33 zzz kernel: [37877.172567] 
Feb  6 10:37:33 zzz kernel: [37877.172569] INFO: 0xffff8801252e4a00-0xffff8801252e4a1f. First byte 0x0 instead of 0x6b
Feb  6 10:37:33 zzz kernel: [37877.172576] INFO: Allocated in __d_alloc+0x27/0x16a age=979868 cpu=1 pid=14697
Feb  6 10:37:33 zzz kernel: [37877.172580] 	__slab_alloc.isra.52.constprop.59+0x2e0/0x349
Feb  6 10:37:33 zzz kernel: [37877.172583] 	kmem_cache_alloc+0x6e/0x133
Feb  6 10:37:33 zzz kernel: [37877.172586] 	__d_alloc+0x27/0x16a
Feb  6 10:37:33 zzz kernel: [37877.172588] 	d_alloc+0x1e/0x69
Feb  6 10:37:33 zzz kernel: [37877.172591] 	d_alloc_and_lookup+0x2c/0x6c
Feb  6 10:37:33 zzz kernel: [37877.172593] 	__lookup_hash.part.36+0xa2/0xb4
Feb  6 10:37:33 zzz kernel: [37877.172596] 	lookup_hash+0x39/0x3e
Feb  6 10:37:33 zzz kernel: [37877.172598] 	do_last.isra.42+0x2a2/0x680
Feb  6 10:37:33 zzz kernel: [37877.172600] 	path_openat+0xd3/0x35d
Feb  6 10:37:33 zzz kernel: [37877.172602] 	do_filp_open+0x38/0x86
Feb  6 10:37:33 zzz kernel: [37877.172604] 	do_sys_open+0x104/0x19d
Feb  6 10:37:33 zzz kernel: [37877.172608] 	compat_sys_open+0x1a/0x1c
Feb  6 10:37:33 zzz kernel: [37877.172610] 	sysenter_dispatch+0x7/0x37
Feb  6 10:37:33 zzz kernel: [37877.172614] INFO: Freed in __d_free+0x56/0x5b age=28547 cpu=2 pid=12133
Feb  6 10:37:33 zzz kernel: [37877.172618] 	__slab_free+0x31/0x348
Feb  6 10:37:33 zzz kernel: [37877.172620] 	kmem_cache_free+0xe1/0x151
Feb  6 10:37:33 zzz kernel: [37877.172622] 	__d_free+0x56/0x5b
Feb  6 10:37:33 zzz kernel: [37877.172626] 	rcu_do_batch.isra.18+0xe0/0x20e
Feb  6 10:37:33 zzz kernel: [37877.172629] 	rcu_cpu_kthread+0x3af/0x543
Feb  6 10:37:33 zzz kernel: [37877.172632] 	kthread+0x93/0x9b
Feb  6 10:37:33 zzz kernel: [37877.172634] 	kernel_thread_helper+0x4/0x10
Feb  6 10:37:33 zzz kernel: [37877.172637] INFO: Slab 0xffffea000494b900 objects=27 used=27 fp=0x          (null) flags=0x8000000000004080
Feb  6 10:37:33 zzz kernel: [37877.172640] INFO: Object 0xffff8801252e4940 @offset=2368 fp=0xffff8801252e4b90
Feb  6 10:37:33 zzz kernel: [37877.172641] 
Feb  6 10:37:33 zzz kernel: [37877.172643] Bytes b4 ffff8801252e4930: ce ab ab 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
Feb  6 10:37:33 zzz kernel: [37877.172646] Object ffff8801252e4940: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172649] Object ffff8801252e4950: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172652] Object ffff8801252e4960: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172654] Object ffff8801252e4970: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172657] Object ffff8801252e4980: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172660] Object ffff8801252e4990: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172663] Object ffff8801252e49a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172665] Object ffff8801252e49b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172668] Object ffff8801252e49c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172670] Object ffff8801252e49d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172673] Object ffff8801252e49e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172675] Object ffff8801252e49f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172678] Object ffff8801252e4a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb  6 10:37:33 zzz kernel: [37877.172681] Object ffff8801252e4a10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Feb  6 10:37:33 zzz kernel: [37877.172683] Object ffff8801252e4a20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172686] Object ffff8801252e4a30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Feb  6 10:37:33 zzz kernel: [37877.172689] Object ffff8801252e4a40: 6b 6b 6b 6b 6b 6b 6b a5                          kkkkkkk.
Feb  6 10:37:33 zzz kernel: [37877.172691] Redzone ffff8801252e4a48: bb bb bb bb bb bb bb bb                          ........
Feb  6 10:37:33 zzz kernel: [37877.172694] Padding ffff8801252e4b88: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
Feb  6 10:37:33 zzz kernel: [37877.172698] Pid: 16164, comm: offlineimap Not tainted 3.2.2 #2
Feb  6 10:37:33 zzz kernel: [37877.172700] Call Trace:
Feb  6 10:37:33 zzz kernel: [37877.172703]  [<ffffffff810fa437>] ? print_section+0x3d/0x3f
Feb  6 10:37:33 zzz kernel: [37877.172707]  [<ffffffff810fa9ac>] print_trailer+0x10a/0x113
Feb  6 10:37:33 zzz kernel: [37877.172710]  [<ffffffff810fae02>] check_bytes_and_report+0xb1/0xea
Feb  6 10:37:33 zzz kernel: [37877.172713]  [<ffffffff811193bb>] ? __d_alloc+0x9e/0x16a
Feb  6 10:37:33 zzz kernel: [37877.172717]  [<ffffffff810faeff>] check_object+0xc4/0x1fc
Feb  6 10:37:33 zzz kernel: [37877.172720]  [<ffffffff81119344>] ? __d_alloc+0x27/0x16a
Feb  6 10:37:33 zzz kernel: [37877.172723]  [<ffffffff81119344>] ? __d_alloc+0x27/0x16a
Feb  6 10:37:33 zzz kernel: [37877.172726]  [<ffffffff81119344>] ? __d_alloc+0x27/0x16a
Feb  6 10:37:33 zzz kernel: [37877.172730]  [<ffffffff81559c83>] alloc_debug_processing+0xa7/0x14a
Feb  6 10:37:33 zzz kernel: [37877.172733]  [<ffffffff8155a691>] __slab_alloc.isra.52.constprop.59+0x2e0/0x349
Feb  6 10:37:33 zzz kernel: [37877.172738]  [<ffffffff81008bd8>] ? native_sched_clock+0x35/0x73
Feb  6 10:37:33 zzz kernel: [37877.172741]  [<ffffffff81119344>] ? __d_alloc+0x27/0x16a
Feb  6 10:37:33 zzz kernel: [37877.172745]  [<ffffffff81042de5>] ? sub_preempt_count+0xa1/0xb5
Feb  6 10:37:33 zzz kernel: [37877.172750]  [<ffffffff8107a61a>] ? put_lock_stats.isra.15+0xe/0x29
Feb  6 10:37:33 zzz kernel: [37877.172753]  [<ffffffff81119344>] ? __d_alloc+0x27/0x16a
Feb  6 10:37:33 zzz kernel: [37877.172757]  [<ffffffff810fc76a>] kmem_cache_alloc+0x6e/0x133
Feb  6 10:37:33 zzz kernel: [37877.172760]  [<ffffffff81119344>] __d_alloc+0x27/0x16a
Feb  6 10:37:33 zzz kernel: [37877.172763]  [<ffffffff81119707>] d_alloc+0x1e/0x69
Feb  6 10:37:33 zzz kernel: [37877.172766]  [<ffffffff8110f450>] d_alloc_and_lookup+0x2c/0x6c
Feb  6 10:37:33 zzz kernel: [37877.172770]  [<ffffffff811100c7>] __lookup_hash.part.36+0xa2/0xb4
Feb  6 10:37:33 zzz kernel: [37877.172773]  [<ffffffff811110e3>] lookup_hash+0x39/0x3e
Feb  6 10:37:33 zzz kernel: [37877.172776]  [<ffffffff8111370f>] sys_renameat+0xd5/0x20b
Feb  6 10:37:33 zzz kernel: [37877.172780]  [<ffffffff81138fbb>] ? fsnotify+0x229/0x255
Feb  6 10:37:33 zzz kernel: [37877.172783]  [<ffffffff81138e18>] ? fsnotify+0x86/0x255
Feb  6 10:37:33 zzz kernel: [37877.172788]  [<ffffffff812f1593>] ? put_ldisc+0xd5/0xda
Feb  6 10:37:33 zzz kernel: [37877.172792]  [<ffffffff81113860>] sys_rename+0x1b/0x1f
Feb  6 10:37:33 zzz kernel: [37877.172795]  [<ffffffff81564b40>] sysenter_dispatch+0x7/0x37
Feb  6 10:37:33 zzz kernel: [37877.172798] FIX dentry: Restoring 0xffff8801252e4a00-0xffff8801252e4a1f=0x6b
Feb  6 10:37:33 zzz kernel: [37877.172799] 
Feb  6 10:37:33 zzz kernel: [37877.172801] FIX dentry: Marking all objects used
Feb  6 10:37:37 zzz kernel: [37881.056610] ------------[ cut here ]------------
Feb  6 10:37:37 zzz kernel: [37881.056659] kernel BUG at lib/radix-tree.c:355!
Feb  6 10:37:37 zzz kernel: [37881.056681] invalid opcode: 0000 [#1] PREEMPT SMP 
Feb  6 10:37:37 zzz kernel: [37881.056708] CPU 1 
Feb  6 10:37:37 zzz kernel: [37881.056719] Modules linked in: kvm_intel kvm ehci_hcd xhci_hcd
Feb  6 10:37:37 zzz kernel: [37881.056755] 
Feb  6 10:37:37 zzz kernel: [37881.056764] Pid: 16164, comm: offlineimap Not tainted 3.2.2 #2 System manufacturer System Product Name/P8H67-V
Feb  6 10:37:37 zzz kernel: [37881.056812] RIP: 0010:[<ffffffff8127f0ab>]  [<ffffffff8127f0ab>] radix_tree_insert+0x14f/0x19b
Feb  6 10:37:37 zzz kernel: [37881.056855] RSP: 0018:ffff88011e74fa68  EFLAGS: 00210086
Feb  6 10:37:37 zzz kernel: [37881.056879] RAX: 00000000ffffffff RBX: ffff88007261de68 RCX: 00000000fffffffa
Feb  6 10:37:37 zzz kernel: [37881.056910] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88007261de68
Feb  6 10:37:37 zzz kernel: [37881.056942] RBP: ffff88011e74faa8 R08: 0000000000000002 R09: ffffffff810ca9bd
Feb  6 10:37:37 zzz kernel: [37881.056974] R10: 0000000000000001 R11: ffffffff81df9550 R12: 0000000000000001
Feb  6 10:37:37 zzz kernel: [37881.057004] R13: 0000000000000000 R14: ffffea0004081c80 R15: ffff8801252ec000
Feb  6 10:37:37 zzz kernel: [37881.057036] FS:  0000000000000000(0000) GS:ffff88012ae00000(0063) knlGS:00000000f277ab70
Feb  6 10:37:37 zzz kernel: [37881.057071] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
Feb  6 10:37:37 zzz kernel: [37881.057097] CR2: 00000000f7799000 CR3: 0000000121075000 CR4: 00000000000426e0
Feb  6 10:37:37 zzz kernel: [37881.057128] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb  6 10:37:37 zzz kernel: [37881.057159] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb  6 10:37:37 zzz kernel: [37881.057191] Process offlineimap (pid: 16164, threadinfo ffff88011e74e000, task ffff880116fe23d0)
Feb  6 10:37:37 zzz kernel: [37881.057229] Stack:
Feb  6 10:37:37 zzz kernel: [37881.057239]  ffff88007261de78 0000000000000000 ffff88011e74faa8 ffffea0004081c80
Feb  6 10:37:37 zzz kernel: [37881.057277]  ffff88007261de60 0000000000000001 ffff88007261de78 0000000000000000
Feb  6 10:37:37 zzz kernel: [37881.057316]  ffff88011e74fae8 ffffffff810ca9cd 0000000000000000 ffffea0004081c80
Feb  6 10:37:37 zzz kernel: [37881.057354] Call Trace:
Feb  6 10:37:37 zzz kernel: [37881.057369]  [<ffffffff810ca9cd>] add_to_page_cache_locked+0xa4/0x126
Feb  6 10:37:37 zzz kernel: [37881.057398]  [<ffffffff810caa69>] add_to_page_cache_lru+0x1a/0x3e
Feb  6 10:37:37 zzz kernel: [37881.057426]  [<ffffffff810cad51>] grab_cache_page_write_begin+0x7e/0xc2
Feb  6 10:37:37 zzz kernel: [37881.057457]  [<ffffffff8116abe8>] ext3_write_begin+0xbf/0x237
Feb  6 10:37:37 zzz kernel: [37881.057483]  [<ffffffff810ca71a>] generic_file_buffered_write+0x119/0x2a0
Feb  6 10:37:37 zzz kernel: [37881.057514]  [<ffffffff81051f5f>] ? current_fs_time+0x37/0x3e
Feb  6 10:37:37 zzz kernel: [37881.057541]  [<ffffffff810cb685>] __generic_file_aio_write+0x333/0x363
Feb  6 10:37:37 zzz kernel: [37881.057572]  [<ffffffff81560c4b>] ? mutex_lock_nested+0x346/0x36e
Feb  6 10:37:37 zzz kernel: [37881.057600]  [<ffffffff810cb6ff>] ? generic_file_aio_write+0x4a/0xc1
Feb  6 10:37:37 zzz kernel: [37881.057629]  [<ffffffff810cb71b>] generic_file_aio_write+0x66/0xc1
Feb  6 10:37:37 zzz kernel: [37881.057658]  [<ffffffff8110564e>] do_sync_write+0xc2/0x102
Feb  6 10:37:37 zzz kernel: [37881.057685]  [<ffffffff81008bd8>] ? native_sched_clock+0x35/0x73
Feb  6 10:37:37 zzz kernel: [37881.057713]  [<ffffffff81107454>] ? fget_light+0xe8/0x11d
Feb  6 10:37:37 zzz kernel: [37881.057739]  [<ffffffff81105dfa>] vfs_write+0xb5/0x148
Feb  6 10:37:37 zzz kernel: [37881.057763]  [<ffffffff81106096>] sys_write+0x4d/0x77
Feb  6 10:37:37 zzz kernel: [37881.057787]  [<ffffffff81564b40>] sysenter_dispatch+0x7/0x37
Feb  6 10:37:37 zzz kernel: [37881.057814]  [<ffffffff81284ebe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Feb  6 10:37:37 zzz kernel: [37881.057842] Code: f0 18 45 85 ed 75 9e 48 85 c0 75 57 4d 85 ff 74 2e 41 ff 47 04 48 63 c2 4d 89 74 c7 18 41 0f a3 97 18 02 00 00 19 c0 85 c0 74 02 <0f> 0b 41 0f a3 97 20 02 00 00 19 d2 31 c0 85 d2 74 2b 0f 0b 8b 
Feb  6 10:37:37 zzz kernel: [37881.058014] RIP  [<ffffffff8127f0ab>] radix_tree_insert+0x14f/0x19b
Feb  6 10:37:37 zzz kernel: [37881.058044]  RSP <ffff88011e74fa68>
Feb  6 10:37:37 zzz kernel: [37881.122261] ---[ end trace 64c65a30119c6423 ]---
Feb  6 10:37:37 zzz kernel: [37881.122288] note: offlineimap[16164] exited with preempt_count 2
Feb  6 10:37:37 zzz kernel: [37881.122291] BUG: sleeping function called from invalid context at include/linux/kernel.h:182
Feb  6 10:37:37 zzz kernel: [37881.122293] in_atomic(): 1, irqs_disabled(): 0, pid: 16164, name: offlineimap
Feb  6 10:37:37 zzz kernel: [37881.122295] INFO: lockdep is turned off.
Feb  6 10:37:37 zzz kernel: [37881.122297] Pid: 16164, comm: offlineimap Tainted: G      D      3.2.2 #2
Feb  6 10:37:37 zzz kernel: [37881.122299] Call Trace:
Feb  6 10:37:37 zzz kernel: [37881.122309]  [<ffffffff8103e664>] __might_sleep+0x10e/0x112
Feb  6 10:37:37 zzz kernel: [37881.122314]  [<ffffffff8108188c>] compat_exit_robust_list+0x40/0x17d
Feb  6 10:37:37 zzz kernel: [37881.122324]  [<ffffffff8104ab18>] mm_release+0x4b/0x108
Feb  6 10:37:37 zzz kernel: [37881.122328]  [<ffffffff8105067a>] exit_mm+0x26/0x126
Feb  6 10:37:37 zzz kernel: [37881.122333]  [<ffffffff81090755>] ? acct_collect+0x17c/0x188
Feb  6 10:37:37 zzz kernel: [37881.122341]  [<ffffffff81050989>] do_exit+0x20f/0x6e7
Feb  6 10:37:37 zzz kernel: [37881.122346]  [<ffffffff8104e849>] ? kmsg_dump+0x10e/0x11d
Feb  6 10:37:37 zzz kernel: [37881.122352]  [<ffffffff8104e7c4>] ? kmsg_dump+0x89/0x11d
Feb  6 10:37:37 zzz kernel: [37881.122359]  [<ffffffff81004b9c>] oops_end+0x94/0x99
Feb  6 10:37:37 zzz kernel: [37881.122363]  [<ffffffff81004ce1>] die+0x5a/0x65
Feb  6 10:37:37 zzz kernel: [37881.122372]  [<ffffffff81001ffd>] do_trap+0x121/0x130
Feb  6 10:37:37 zzz kernel: [37881.122378]  [<ffffffff8100223b>] do_invalid_op+0xa1/0xaa
Feb  6 10:37:37 zzz kernel: [37881.122385]  [<ffffffff8127f0ab>] ? radix_tree_insert+0x14f/0x19b
Feb  6 10:37:37 zzz kernel: [37881.122392]  [<ffffffff81284efd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
Feb  6 10:37:37 zzz kernel: [37881.122399]  [<ffffffff810ca9bd>] ? add_to_page_cache_locked+0x94/0x126
Feb  6 10:37:37 zzz kernel: [37881.122404]  [<ffffffff81562ae8>] ? restore_args+0x30/0x30
Feb  6 10:37:37 zzz kernel: [37881.122411]  [<ffffffff815647fb>] invalid_op+0x1b/0x20
Feb  6 10:37:37 zzz kernel: [37881.122417]  [<ffffffff810ca9bd>] ? add_to_page_cache_locked+0x94/0x126
Feb  6 10:37:37 zzz kernel: [37881.122422]  [<ffffffff8127f0ab>] ? radix_tree_insert+0x14f/0x19b
Feb  6 10:37:37 zzz kernel: [37881.122430]  [<ffffffff8127efb1>] ? radix_tree_insert+0x55/0x19b
Feb  6 10:37:37 zzz kernel: [37881.122437]  [<ffffffff810ca9cd>] add_to_page_cache_locked+0xa4/0x126
Feb  6 10:37:37 zzz kernel: [37881.122446]  [<ffffffff810caa69>] add_to_page_cache_lru+0x1a/0x3e
Feb  6 10:37:37 zzz kernel: [37881.122454]  [<ffffffff810cad51>] grab_cache_page_write_begin+0x7e/0xc2
Feb  6 10:37:37 zzz kernel: [37881.122460]  [<ffffffff8116abe8>] ext3_write_begin+0xbf/0x237
Feb  6 10:37:37 zzz kernel: [37881.122469]  [<ffffffff810ca71a>] generic_file_buffered_write+0x119/0x2a0
Feb  6 10:37:37 zzz kernel: [37881.122475]  [<ffffffff81051f5f>] ? current_fs_time+0x37/0x3e
Feb  6 10:37:37 zzz kernel: [37881.122482]  [<ffffffff810cb685>] __generic_file_aio_write+0x333/0x363
Feb  6 10:37:37 zzz kernel: [37881.122488]  [<ffffffff81560c4b>] ? mutex_lock_nested+0x346/0x36e
Feb  6 10:37:37 zzz kernel: [37881.122493]  [<ffffffff810cb6ff>] ? generic_file_aio_write+0x4a/0xc1
Feb  6 10:37:37 zzz kernel: [37881.122501]  [<ffffffff810cb71b>] generic_file_aio_write+0x66/0xc1
Feb  6 10:37:37 zzz kernel: [37881.122509]  [<ffffffff8110564e>] do_sync_write+0xc2/0x102
Feb  6 10:37:37 zzz kernel: [37881.122516]  [<ffffffff81008bd8>] ? native_sched_clock+0x35/0x73
Feb  6 10:37:37 zzz kernel: [37881.122526]  [<ffffffff81107454>] ? fget_light+0xe8/0x11d
Feb  6 10:37:37 zzz kernel: [37881.122532]  [<ffffffff81105dfa>] vfs_write+0xb5/0x148
Feb  6 10:37:37 zzz kernel: [37881.122539]  [<ffffffff81106096>] sys_write+0x4d/0x77
Feb  6 10:37:37 zzz kernel: [37881.122545]  [<ffffffff81564b40>] sysenter_dispatch+0x7/0x37
Feb  6 10:37:37 zzz kernel: [37881.122550]  [<ffffffff81284ebe>] ? trace_hardirqs_on_thunk+0x3a/0x3f


Johannes
