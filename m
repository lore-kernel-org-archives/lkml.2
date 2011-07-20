Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1GTD6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 23:58:18 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64202 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1GTD6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 23:58:17 -0400
X-Nat-Received: from [202.181.97.72]:51012 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1311134296.31901
Message-Id: <201107200358.p6K3wF1W010444@www262.sakura.ne.jp>
Subject: [linux-next-20110718] Warning at fault_in_kernel_space()?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Jul 2011 12:58:15 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 20072011 #5646396, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below warning.

[    9.249851] Trying to unpack rootfs image as initramfs...
[    9.253716] rootfs image is not initramfs (junk in compressed archive); looks like an initrd
[    9.263123] debug: unmapping init memory f76f0000..f77fe000
[    9.297491] DMA-API: preallocated 32768 debug entries
[    9.301350] DMA-API: debugging enabled by kernel config
[    9.303451] Simple Boot Flag at 0x36 set to 0x1
[    9.315671] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[    9.318552] apm: disabled - APM is not SMP safe.
[    9.324504] microcode: CPU0 sig=0x206a7, pf=0x1, revision=0x15
[    9.326908] microcode: CPU1 sig=0x206a7, pf=0x1, revision=0x15
[    9.329860] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    9.338820] ------------[ cut here ]------------
[    9.340774] WARNING: at kernel/lockdep.c:2529 trace_hardirqs_on_caller+0x7a/0x80()
[    9.343709] Hardware name: VMware Virtual Platform
[    9.348240] Modules linked in:
[    9.349631] Pid: 1, comm: swapper Not tainted 3.0.0-rc7-next-20110718 #1
[    9.352198] Call Trace:
[    9.353197]  [<c107055a>] ? trace_hardirqs_on_caller+0x7a/0x80
[    9.355606]  [<c103f35c>] warn_slowpath_common+0x7c/0xa0
[    9.360224]  [<c107055a>] ? trace_hardirqs_on_caller+0x7a/0x80
[    9.362693]  [<c1025ed0>] ? fault_in_kernel_space+0x10/0x10
[    9.364807]  [<c103f41d>] warn_slowpath_null+0x1d/0x40
[    9.366834]  [<c107055a>] trace_hardirqs_on_caller+0x7a/0x80
[    9.372212]  [<c11baef4>] trace_hardirqs_on_thunk+0xc/0x10
[    9.374467]  [<c107609b>] ? cmpxchg_futex_value_locked+0x3b/0x70
[    9.376771]  [<c1396c74>] ? restore_all+0xf/0xf
[    9.378592]  [<c111007b>] ? load_elf_binary+0x3db/0x920
[    9.380436]  [<c11100d8>] ? load_elf_binary+0x438/0x920
[    9.382495]  [<c1025ed0>] ? fault_in_kernel_space+0x10/0x10
[    9.384710]  [<c1397dcf>] ? iret_exc+0x3ff/0xa7d
[    9.386559]  [<c15a24b0>] ? lockdep_proc_init+0x90/0x90
[    9.388302]  [<c15a24cb>] ? futex_init+0x1b/0x90
[    9.393397]  [<c15a249e>] ? lockdep_proc_init+0x7e/0x90
[    9.395459]  [<c15a24b0>] ? lockdep_proc_init+0x90/0x90
[    9.397379]  [<c1001282>] ? do_one_initcall+0x102/0x110
[    9.399473]  [<c158c930>] ? do_pre_smp_initcalls+0x30/0x30
[    9.404218]  [<c158c8be>] ? do_initcalls+0x1e/0x30
[    9.406081]  [<c158c8f1>] ? do_basic_setup+0x21/0x30
[    9.408052]  [<c158c985>] ? kernel_init+0x55/0xe0
[    9.409784]  [<c139793a>] ? kernel_thread_helper+0x6/0xd
[    9.411937] ---[ end trace 93d72a36b9146f22 ]---
[    9.416336] Initializing RT-Tester: OK
[    9.418005] audit: initializing netlink socket (disabled)
[    9.420055] type=2000 audit(1311163396.724:1): initialized
[    9.425632] highmem bounce pool size: 64 pages
[    9.428123] VFS: Disk quotas dquot_6.5.2
[    9.429898] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)


If I change kernel/lockdep.c:2529 from

	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))

to

        if (WARN_ON(!irqs_disabled()))

, I get similar warnings endlessly (shown below).

[   18.557434] ------------[ cut here ]------------
[   18.574852] WARNING: at kernel/lockdep.c:2529 trace_hardirqs_on_caller+0x7d/0x80()
[   18.580561] Hardware name: VMware Virtual Platform
[   18.598387] Modules linked in:
[   18.600920] Pid: 1123, comm: linuxrc Tainted: G        W   3.0.0-rc7-next-20110718 #2
[   18.620546] Call Trace:
[   18.622540]  [<c107055d>] ? trace_hardirqs_on_caller+0x7d/0x80
[   18.626858]  [<c103f35c>] warn_slowpath_common+0x7c/0xa0
[   18.644860]  [<c107055d>] ? trace_hardirqs_on_caller+0x7d/0x80
[   18.650114]  [<c1396c74>] ? restore_all+0xf/0xf
[   18.667377]  [<c103f41d>] warn_slowpath_null+0x1d/0x40
[   18.676310]  [<c107055d>] trace_hardirqs_on_caller+0x7d/0x80
[   18.681363]  [<c1025ed0>] ? fault_in_kernel_space+0x10/0x10
[   18.686333]  [<c11baef4>] trace_hardirqs_on_thunk+0xc/0x10
[   18.691361]  [<c1396c74>] ? restore_all+0xf/0xf
[   18.695414]  [<c10b007b>] ? kswapd_try_to_sleep+0x8b/0x120
[   18.700092]  [<c1025ed0>] ? fault_in_kernel_space+0x10/0x10
[   18.704788]  [<c11baff2>] ? clear_user+0x42/0x60
[   18.708813]  [<c110f34f>] ? padzero+0x1f/0x30
[   18.727615]  [<c110ffb1>] ? load_elf_binary+0x311/0x920
[   18.731604]  [<c10d85a3>] ? search_binary_handler+0x1f3/0x2e0
[   18.755901]  [<c10d83eb>] ? search_binary_handler+0x3b/0x2e0
[   18.760144]  [<c110fca0>] ? randomize_stack_top+0x50/0x50
[   18.778196]  [<c10d82ce>] ? prepare_binprm+0xce/0xf0
[   18.783561]  [<c110f25b>] ? load_script+0x1eb/0x220
[   18.788909]  [<c107068b>] ? trace_hardirqs_off+0xb/0x10
[   18.792843]  [<c106150b>] ? local_clock+0x3b/0x60
[   18.796438]  [<c106cbb3>] ? lock_release_holdtime+0x73/0xb0
[   18.801386]  [<c10d859b>] ? search_binary_handler+0x1eb/0x2e0
[   18.821502]  [<c1072ba7>] ? __lock_release+0x47/0x70
[   18.825222]  [<c10d859b>] ? search_binary_handler+0x1eb/0x2e0
[   18.829624]  [<c10d85a3>] ? search_binary_handler+0x1f3/0x2e0
[   18.848258]  [<c10d83eb>] ? search_binary_handler+0x3b/0x2e0
[   18.853348]  [<c110f070>] ? lock_may_write+0xb0/0xb0
[   18.871056]  [<c1195ee9>] ? __ccs_search_binary_handler+0x49/0x50
[   18.875714]  [<c10d87f1>] ? do_execve_common+0x161/0x230
[   18.879760]  [<c10d88d4>] ? do_execve+0x14/0x20
[   18.883153]  [<c1009f12>] ? sys_execve+0x42/0x60
[   18.900931]  [<c1397483>] ? ptregs_execve+0x13/0x18
[   18.904909]  [<c1396c41>] ? syscall_call+0x7/0xb
[   18.923179]  [<c107007b>] ? print_irqtrace_events+0xbb/0xf0
[   18.927407]  [<c1006c22>] ? kernel_execve+0x22/0x40
[   18.939865]  [<c158d8e0>] ? no_initrd+0x20/0x20
[   18.968307]  [<c158d91b>] ? do_linuxrc+0x3b/0x50
[   18.971874]  [<c139793a>] ? kernel_thread_helper+0x6/0xd
[   18.975808] ---[ end trace 93d72a36b9146f24 ]---


[   20.546150] ------------[ cut here ]------------
[   20.561973] WARNING: at kernel/lockdep.c:2529 trace_hardirqs_on_caller+0x7d/0x80()
[   20.566868] Hardware name: VMware Virtual Platform
[   20.570000] Modules linked in:
[   20.584441] Pid: 1125, comm: linuxrc Tainted: G        W   3.0.0-rc7-next-20110718 #2
[   20.589499] Call Trace:
[   20.591227]  [<c107055d>] ? trace_hardirqs_on_caller+0x7d/0x80
[   20.607542]  [<c103f35c>] warn_slowpath_common+0x7c/0xa0
[   20.611024]  [<c107055d>] ? trace_hardirqs_on_caller+0x7d/0x80
[   20.614805]  [<c1396c74>] ? restore_all+0xf/0xf
[   20.630005]  [<c103f41d>] warn_slowpath_null+0x1d/0x40
[   20.633332]  [<c107055d>] trace_hardirqs_on_caller+0x7d/0x80
[   20.651072]  [<c1025ed0>] ? fault_in_kernel_space+0x10/0x10
[   20.654850]  [<c11baef4>] trace_hardirqs_on_thunk+0xc/0x10
[   20.658441]  [<c1396c74>] ? restore_all+0xf/0xf
[   20.673716]  [<c10b00d8>] ? kswapd_try_to_sleep+0xe8/0x120
[   20.677272]  [<c1025ed0>] ? fault_in_kernel_space+0x10/0x10
[   20.680896]  [<c11bac6d>] ? __put_user_4+0x11/0x18
[   20.684077]  [<c10373fb>] ? schedule_tail+0x6b/0xb0
[   20.699723]  [<c1397326>] ? ret_from_fork+0x6/0x1c
[   20.702918] ---[ end trace 93d72a36b9146f2a ]---


[   23.127127] ------------[ cut here ]------------
[   23.130191] WARNING: at kernel/lockdep.c:2529 trace_hardirqs_on_caller+0x7d/0x80()
[   23.149369] Hardware name: VMware Virtual Platform
[   23.152552] Modules linked in:
[   23.154780] Pid: 1, comm: init Tainted: G        W   3.0.0-rc7-next-20110718 #2
[   23.171650] Call Trace:
[   23.173342]  [<c107055d>] ? trace_hardirqs_on_caller+0x7d/0x80
[   23.177146]  [<c103f35c>] warn_slowpath_common+0x7c/0xa0
[   23.193121]  [<c107055d>] ? trace_hardirqs_on_caller+0x7d/0x80
[   23.196948]  [<c1396c74>] ? restore_all+0xf/0xf
[   23.199964]  [<c103f41d>] warn_slowpath_null+0x1d/0x40
[   23.215490]  [<c107055d>] trace_hardirqs_on_caller+0x7d/0x80
[   23.219188]  [<c1025ed0>] ? fault_in_kernel_space+0x10/0x10
[   23.222793]  [<c11baef4>] trace_hardirqs_on_thunk+0xc/0x10
[   23.238699]  [<c1396c74>] ? restore_all+0xf/0xf
[   23.241720]  [<c10a007b>] ? perf_output_copy+0x2b/0x90
[   23.245082]  [<c1025ed0>] ? fault_in_kernel_space+0x10/0x10
[   23.266032]  [<c10a26a8>] ? file_read_actor+0x48/0xe0
[   23.281508]  [<c10a23d5>] ? do_generic_file_read+0x205/0x490
[   23.285140]  [<c10a2a11>] ? generic_file_aio_read+0x241/0x2a0
[   23.288844]  [<c10a2660>] ? do_generic_file_read+0x490/0x490
[   23.304893]  [<c1026068>] ? do_page_fault+0x198/0x400
[   23.308258]  [<c10d1430>] ? do_sync_read+0xa0/0xe0
[   23.311451]  [<c10d12a2>] ? rw_verify_area+0x62/0x110
[   23.327110]  [<c10d1514>] ? vfs_read+0xa4/0x130
[   23.330163]  [<c1396c74>] ? restore_all+0xf/0xf
[   23.333155]  [<c10d17f1>] ? sys_read+0x41/0x70
[   23.350293]  [<c1396c41>] ? syscall_call+0x7/0xb
[   23.353372] ---[ end trace 93d72a36b9146f33 ]---
