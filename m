Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2GJErL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 00:47:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:32317 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2GJErF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 00:47:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175342936"
Date: Tue, 10 Jul 2012 12:47:00 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rcu_dyntick and suspicious RCU usage
Message-ID: <20120710044700.GA9462@localhost>
References: <20120709135637.GA26040@localhost>
 <20120709145724.GA27095@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20120709145724.GA27095@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paul,

Fortunately this bug is bisectable and the first bad commit is:

        commit 9b2e4f1880b789be1f24f9684f7a54b90310b5c0
        Author: Paul E. McKenney <paul.mckenney@linaro.org>
        Date:   Fri Sep 30 12:10:22 2011 -0700

            rcu: Track idleness independent of idle tasks

However, at that commit, the error messages are a bit different:

[    1.665656] WARNING: at /c/wfg/linux/kernel/rcutiny.c:67 rcu_idle_enter_common+0x103/0x1b2()
[    1.668811] WARNING: at /c/wfg/linux/kernel/rcutiny.c:112 rcu_idle_exit_common+0xfa/0x18c()
[    4.758670] WARNING: at /c/wfg/linux/kernel/trace/trace_events.c:1720 event_trace_self_tests_init+0x87/0x11b()

Here is the first back trace:

[    1.660165] Testing tracer function: 
[    1.664825] ------------[ cut here ]------------
[    1.665656] WARNING: at /c/wfg/linux/kernel/rcutiny.c:67 rcu_idle_enter_common+0x103/0x1b2()
[    1.667006] Hardware name: Bochs
[    1.667583] Modules linked in:
[    1.668106] Pid: 0, comm: swapper Not tainted 3.2.0-rc5+ #41
[    1.668811] Call Trace:
[    1.668811]  [<c13edf12>] ? printk+0x2b/0x3b
[    1.668811]  [<c104b892>] warn_slowpath_common+0xfc/0x13b
[    1.668811]  [<c10f3c2c>] ? rcu_idle_enter_common+0x103/0x1b2
[    1.668811]  [<c10f3c2c>] ? rcu_idle_enter_common+0x103/0x1b2
[    1.668811]  [<c104b90f>] warn_slowpath_null+0x3e/0x4e
[    1.668811]  [<c10f3c2c>] rcu_idle_enter_common+0x103/0x1b2
[    1.668811]  [<c10f3ed3>] rcu_irq_exit+0x1f8/0x20f
[    1.668811]  [<c1058ca4>] irq_exit+0x117/0x14d
[    1.668811]  [<c1005c45>] do_IRQ+0xe5/0x106
[    1.668811]  [<c109e6b8>] ? trace_hardirqs_off_caller+0x97/0x167
[    1.668811]  [<c1408a75>] common_interrupt+0x35/0x3c
[    1.668811]  [<c10a00e0>] ? print_shortest_lock_dependencies+0xec/0x292
[    1.668811]  [<c1023e16>] ? native_safe_halt+0x18/0x28
[    1.668811]  [<c100e10f>] default_idle+0xd7/0x1f0
[    1.668811]  [<c1001eb3>] cpu_idle+0x1c4/0x2c8
[    1.668811]  [<c13e9027>] rest_init+0x1db/0x1ef
[    1.668811]  [<c13e8e4c>] ? reciprocal_value+0x64/0x64
[    1.668811]  [<c16cc232>] start_kernel+0x8e5/0x8f9
[    1.668811]  [<c16cb36b>] ? loglevel+0x55/0x55
[    1.668811]  [<c16cb208>] ? reserve_ebda_region+0xb9/0xc9
[    1.668811]  [<c16cb13a>] i386_start_kernel+0x13a/0x14f

Thanks,
Fengguang

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm_bisect-waimea-21794-2012-07-10-12-41-32

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.0-rc5+ (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #41 PREEMPT Tue Jul 10 12:38:54 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000000fffd000 (usable)
[    0.000000]  BIOS-e820: 000000000fffd000 - 0000000010000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0xfffd max_arch_pfn = 0x100000
[    0.000000] initial memory mapped : 0 - 02400000
[    0.000000] Base memory trampoline at [c009e000] 9e000 size 4096
[    0.000000] init_memory_mapping: 0000000000000000-000000000fffd000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 000fc00000 page 2M
[    0.000000]  000fc00000 - 000fffd000 page 4k
[    0.000000] kernel direct mapping tables up to fffd000 @ 23fb000-2400000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 129089(98%)
[    0.000000] RAMDISK: 0e73f000 - 0fff0000
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffd000
[    0.000000]   low ram: 0 - 0fffd000
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:15ed781, boot clock
[    0.000000] Zone PFN ranges:
[    0.000000]   Normal   0x00000010 -> 0x0000fffd
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0000fffd
[    0.000000] On node 0 totalpages: 65420
[    0.000000] free_area_init_node: node 0, pgdat c16ac510, node_mem_map cdd3f200
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64908 pages, LIFO batch:15
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 10000000 (gap: 10000000:effbc000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64908
[    0.000000] Kernel command line: rcutorture.rcutorture_runnable=0 bisect-reboot i386-randconfig run_test= auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=x86_64/vmlinuz-bisect
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 211356k/262132k available (4132k kernel code, 50324k reserved, 2818k data, 400k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcf000 - 0xfffff000   ( 192 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fd000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffd000   ( 255 MB)
[    0.000000]       .init : 0xc16cb000 - 0xc172f000   ( 400 kB)
[    0.000000]       .data : 0xc140927b - 0xc16c9a80   (2818 kB)
[    0.000000]       .text : 0xc1000000 - 0xc140927b   (4132 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=cd802000 soft=cd804000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] kmemleak: Early log buffer exceeded, please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] ODEBUG: 8 of 8 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] Detected 3299.986 MHz processor.
[    0.004000] Calibrating delay loop (skipped) preset value.. 6599.97 BogoMIPS (lpj=13199944)
[    0.004000] pid_max: default: 4096 minimum: 301
[    0.004000] Security Framework initialized
[    0.004000] AppArmor: AppArmor initialized
[    0.004097] Mount-cache hash table entries: 512
[    0.007292] Initializing cgroup subsys debug
[    0.008012] Initializing cgroup subsys devices
[    0.008742] Initializing cgroup subsys freezer
[    0.009468] Initializing cgroup subsys perf_event
[    0.010375] mce: CPU supports 10 MCE banks
[    0.011040] MCE: unknown CPU type - not enabling MCE support.
[    0.012022] CPU: GenuineIntel Common KVM processor stepping 01
[    0.014201] Performance Events: 
[    0.016010] Testing tracer nop: PASSED
[    0.017708] EVM: security.capability
[    0.021006] print_constraints: dummy: 
[    0.022243] NET: Registered protocol family 16
[    0.024550] bio: create slab <bio-0> at 0
[    0.026583] Switching to clocksource kvm-clock
[    0.027987] Warning: could not register annotated branches stats
[    0.077102] AppArmor: AppArmor Filesystem Enabled
[    0.078570] NET: Registered protocol family 1
[    0.080076] Unpacking initramfs...
[    1.280061] Freeing initrd memory: 25284k freed
[    1.644464] DMA-API: preallocated 32768 debug entries
[    1.645357] DMA-API: debugging enabled by kernel config
[    1.646469] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.649932] audit: initializing netlink socket (disabled)
[    1.650907] type=2000 audit(1341895287.648:1): initialized
[    1.660165] Testing tracer function: 
[    1.664825] ------------[ cut here ]------------
[    1.665656] WARNING: at /c/wfg/linux/kernel/rcutiny.c:67 rcu_idle_enter_common+0x103/0x1b2()
[    1.667006] Hardware name: Bochs
[    1.667583] Modules linked in:
[    1.668106] Pid: 0, comm: swapper Not tainted 3.2.0-rc5+ #41
[    1.668811] Call Trace:
[    1.668811]  [<c13edf12>] ? printk+0x2b/0x3b
[    1.668811]  [<c104b892>] warn_slowpath_common+0xfc/0x13b
[    1.668811]  [<c10f3c2c>] ? rcu_idle_enter_common+0x103/0x1b2
[    1.668811]  [<c10f3c2c>] ? rcu_idle_enter_common+0x103/0x1b2
[    1.668811]  [<c104b90f>] warn_slowpath_null+0x3e/0x4e
[    1.668811]  [<c10f3c2c>] rcu_idle_enter_common+0x103/0x1b2
[    1.668811]  [<c10f3ed3>] rcu_irq_exit+0x1f8/0x20f
[    1.668811]  [<c1058ca4>] irq_exit+0x117/0x14d
[    1.668811]  [<c1005c45>] do_IRQ+0xe5/0x106
[    1.668811]  [<c109e6b8>] ? trace_hardirqs_off_caller+0x97/0x167
[    1.668811]  [<c1408a75>] common_interrupt+0x35/0x3c
[    1.668811]  [<c10a00e0>] ? print_shortest_lock_dependencies+0xec/0x292
[    1.668811]  [<c1023e16>] ? native_safe_halt+0x18/0x28
[    1.668811]  [<c100e10f>] default_idle+0xd7/0x1f0
[    1.668811]  [<c1001eb3>] cpu_idle+0x1c4/0x2c8
[    1.668811]  [<c13e9027>] rest_init+0x1db/0x1ef
[    1.668811]  [<c13e8e4c>] ? reciprocal_value+0x64/0x64
[    1.668811]  [<c16cc232>] start_kernel+0x8e5/0x8f9
[    1.668811]  [<c16cb36b>] ? loglevel+0x55/0x55
[    1.668811]  [<c16cb208>] ? reserve_ebda_region+0xb9/0xc9
[    1.668811]  [<c16cb13a>] i386_start_kernel+0x13a/0x14f
[    1.668811] ---[ end trace 6d450e935ee1897c ]---
[    1.668811] Dumping ftrace buffer:
[    1.668811]    (ftrace buffer empty)
[    1.668811] ------------[ cut here ]------------
[    1.668811] WARNING: at /c/wfg/linux/kernel/rcutiny.c:112 rcu_idle_exit_common+0xfa/0x18c()
[    1.668811] Hardware name: Bochs
[    1.668811] Modules linked in:
[    1.668811] Pid: 0, comm: swapper Tainted: G        W    3.2.0-rc5+ #41
[    1.668811] Call Trace:
[    1.668811]  [<c13edf12>] ? printk+0x2b/0x3b
[    1.668811]  [<c104b892>] warn_slowpath_common+0xfc/0x13b
[    1.668811]  [<c10f1d27>] ? rcu_idle_exit_common+0xfa/0x18c
[    1.668811]  [<c10f1d27>] ? rcu_idle_exit_common+0xfa/0x18c
[    1.668811]  [<c104b90f>] warn_slowpath_null+0x3e/0x4e
[    1.668811]  [<c10f1d27>] rcu_idle_exit_common+0xfa/0x18c
[    1.668811]  [<c10f39b1>] rcu_irq_enter+0x20f/0x229
[    1.668811]  [<c1058aee>] irq_enter+0x32/0xd1
[    1.668811]  [<c1005b92>] do_IRQ+0x32/0x106
[    1.668811]  [<c109e6b8>] ? trace_hardirqs_off_caller+0x97/0x167
[    1.668811]  [<c1408a75>] common_interrupt+0x35/0x3c
[    1.668811]  [<c10a00e0>] ? print_shortest_lock_dependencies+0xec/0x292
[    1.668811]  [<c1023e16>] ? native_safe_halt+0x18/0x28
[    1.668811]  [<c100e10f>] default_idle+0xd7/0x1f0
[    1.668811]  [<c1001eb3>] cpu_idle+0x1c4/0x2c8
[    1.668811]  [<c13e9027>] rest_init+0x1db/0x1ef
[    1.668811]  [<c13e8e4c>] ? reciprocal_value+0x64/0x64
[    1.668811]  [<c16cc232>] start_kernel+0x8e5/0x8f9
[    1.668811]  [<c16cb36b>] ? loglevel+0x55/0x55
[    1.668811]  [<c16cb208>] ? reserve_ebda_region+0xb9/0xc9
[    1.668811]  [<c16cb13a>] i386_start_kernel+0x13a/0x14f
[    1.668811] ---[ end trace 6d450e935ee1897d ]---
[    1.816979] .. no entries found ..FAILED!
[    1.817714] Testing tracer irqsoff: 
[    1.818324] failed to start irqsoff tracer
[    1.819215] .. no entries found ..FAILED!
[    1.819890] Testing tracer preemptoff: 
[    1.820517] failed to start irqsoff tracer
[    1.821513] .. no entries found ..FAILED!
[    1.822471] Testing tracer preemptirqsoff: 
[    1.823347] failed to start irqsoff tracer
[    1.824473] .. no entries found ..FAILED!
[    1.825208] Testing tracer wakeup: 
[    1.826161] failed to start wakeup tracer
[    2.136962] ftrace-test used greatest stack depth: 7392 bytes left
[    2.138232] .. no entries found ..FAILED!
[    2.140440] Testing tracer branch: .. no entries found ..FAILED!
[    2.248865] msgmni has been set to 462
[    2.251981] cryptomgr_test used greatest stack depth: 7264 bytes left
[    2.253643] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    2.254911] io scheduler noop registered (default)
[    2.255721] start plist test
[    2.264149] end plist test
[    2.369587] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.395072] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.160239] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.162413] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.168063] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    3.170759] Running tests on trace events:
[    3.171475] Testing event kfree_skb: OK
[    3.181367] Testing event consume_skb: OK
[    3.189243] Testing event skb_copy_datagram_iovec: OK
[    3.197135] Testing event net_dev_xmit: OK
[    3.205167] Testing event net_dev_queue: OK
[    3.213134] Testing event netif_receive_skb: OK
[    3.221148] Testing event netif_rx: OK
[    3.229143] Testing event napi_poll: OK
[    3.237140] Testing event sock_rcvqueue_full: OK
[    3.245137] Testing event sock_exceed_buf_limit: OK
[    3.253130] Testing event udp_fail_queue_rcv_skb: OK
[    3.261134] Testing event regmap_reg_write: OK
[    3.269137] Testing event regmap_reg_read: OK
[    3.277160] Testing event regmap_hw_read_start: OK
[    3.285162] Testing event regmap_hw_read_done: OK
[    3.293207] Testing event regmap_hw_write_start: OK
[    3.301152] Testing event regmap_hw_write_done: OK
[    3.309137] Testing event regcache_sync: OK
[    3.317143] Testing event regulator_enable: OK
[    3.325144] Testing event regulator_enable_delay: OK
[    3.333149] Testing event regulator_enable_complete: OK
[    3.341170] Testing event regulator_disable: OK
[    3.349142] Testing event regulator_disable_complete: OK
[    3.357144] Testing event regulator_set_voltage: OK
[    3.365157] Testing event regulator_set_voltage_complete: OK
[    3.373184] Testing event gpio_direction: OK
[    3.381142] Testing event gpio_value: OK
[    3.389364] Testing event block_rq_abort: OK
[    3.397153] Testing event block_rq_requeue: OK
[    3.405169] Testing event block_rq_complete: OK
[    3.413138] Testing event block_rq_insert: OK
[    3.421154] Testing event block_rq_issue: OK
[    3.429142] Testing event block_bio_bounce: OK
[    3.437174] Testing event block_bio_complete: OK
[    3.445145] Testing event block_bio_backmerge: OK
[    3.453170] Testing event block_bio_frontmerge: OK
[    3.461147] Testing event block_bio_queue: OK
[    3.469181] Testing event block_getrq: OK
[    3.477152] Testing event block_sleeprq: OK
[    3.485184] Testing event block_plug: OK
[    3.493178] Testing event block_unplug: OK
[    3.501149] Testing event block_split: OK
[    3.509187] Testing event block_bio_remap: OK
[    3.517219] Testing event block_rq_remap: OK
[    3.525186] Testing event writeback_nothread: OK
[    3.533150] Testing event writeback_queue: OK
[    3.541203] Testing event writeback_exec: OK
[    3.549152] Testing event writeback_start: OK
[    3.557152] Testing event writeback_written: OK
[    3.565203] Testing event writeback_wait: OK
[    3.573148] Testing event writeback_pages_written: OK
[    3.581157] Testing event writeback_nowork: OK
[    3.589200] Testing event writeback_wake_background: OK
[    3.597146] Testing event writeback_wake_thread: OK
[    3.605151] Testing event writeback_wake_forker_thread: OK
[    3.613203] Testing event writeback_bdi_register: OK
[    3.621146] Testing event writeback_bdi_unregister: OK
[    3.629149] Testing event writeback_thread_start: OK
[    3.637202] Testing event writeback_thread_stop: OK
[    3.645151] Testing event wbc_writepage: OK
[    3.653172] Testing event writeback_queue_io: OK
[    3.661207] Testing event global_dirty_state: OK
[    3.669152] Testing event bdi_dirty_ratelimit: OK
[    3.677160] Testing event balance_dirty_pages: OK
[    3.685204] Testing event writeback_congestion_wait: OK
[    3.693153] Testing event writeback_wait_iff_congested: OK
[    3.701162] Testing event writeback_single_inode_requeue: OK
[    3.709209] Testing event writeback_single_inode: OK
[    3.717161] Testing event mm_compaction_isolate_migratepages: OK
[    3.725164] Testing event mm_compaction_isolate_freepages: OK
[    3.733211] Testing event mm_compaction_migratepages: OK
[    3.741213] Testing event kmalloc: OK
[    3.749204] Testing event kmem_cache_alloc: OK
[    3.757207] Testing event kmalloc_node: OK
[    3.765209] Testing event kmem_cache_alloc_node: OK
[    3.773182] Testing event kfree: OK
[    3.781176] Testing event kmem_cache_free: OK
[    3.789212] Testing event mm_page_free_direct: OK
[    3.797210] Testing event mm_pagevec_free: OK
[    3.805212] Testing event mm_page_alloc: OK
[    3.813178] Testing event mm_page_alloc_zone_locked: OK
[    3.821178] Testing event mm_page_pcpu_drain: OK
[    3.829212] Testing event mm_page_alloc_extfrag: OK
[    3.837169] Testing event mm_vmscan_kswapd_sleep: OK
[    3.845182] Testing event mm_vmscan_kswapd_wake: OK
[    3.853212] Testing event mm_vmscan_wakeup_kswapd: OK
[    3.861157] Testing event mm_vmscan_direct_reclaim_begin: OK
[    3.869176] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    3.877158] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    3.885171] Testing event mm_vmscan_direct_reclaim_end: OK
[    3.893215] Testing event mm_vmscan_memcg_reclaim_end: OK
[    3.901154] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    3.909175] Testing event mm_shrink_slab_start: OK
[    3.917170] Testing event mm_shrink_slab_end: OK
[    3.925219] Testing event mm_vmscan_lru_isolate: OK
[    3.933183] Testing event mm_vmscan_memcg_isolate: OK
[    3.941166] Testing event mm_vmscan_writepage: OK
[    3.949167] Testing event mm_vmscan_lru_shrink_inactive: OK
[    3.957223] Testing event replace_swap_token: OK
[    3.965168] Testing event put_swap_token: OK
[    3.973179] Testing event disable_swap_token: OK
[    3.981171] Testing event update_swap_token_priority: OK
[    3.989172] Testing event cpu_idle: OK
[    3.997170] Testing event cpu_frequency: OK
[    4.005175] Testing event machine_suspend: OK
[    4.013169] Testing event clock_enable: OK
[    4.021164] Testing event clock_disable: OK
[    4.029168] Testing event clock_set_rate: OK
[    4.037168] Testing event power_domain_target: OK
[    4.045167] Testing event ftrace_test_filter: OK
[    4.053168] Testing event module_load: OK
[    4.061171] Testing event module_free: OK
[    4.069174] Testing event module_get: OK
[    4.077404] Testing event module_put: OK
[    4.085178] Testing event module_request: OK
[    4.093179] Testing event lock_acquire: 
[    4.093987] test-events used greatest stack depth: 7220 bytes left
[    4.101144] OK
[    4.101500] Testing event lock_release: 
[    4.102316] test-events used greatest stack depth: 7188 bytes left
[    4.109137] OK
[    4.109474] Testing event rcu_utilization: OK
[    4.117174] Testing event rcu_dyntick: OK
[    4.125183] Testing event rcu_callback: OK
[    4.133173] Testing event rcu_kfree_callback: OK
[    4.141176] Testing event rcu_batch_start: OK
[    4.149185] Testing event rcu_invoke_callback: OK
[    4.157187] Testing event rcu_invoke_kfree_callback: OK
[    4.165187] Testing event rcu_batch_end: OK
[    4.173219] Testing event workqueue_queue_work: OK
[    4.181190] Testing event workqueue_activate_work: OK
[    4.189185] Testing event workqueue_execute_start: OK
[    4.197222] Testing event workqueue_execute_end: OK
[    4.205203] Testing event signal_generate: OK
[    4.213217] Testing event signal_deliver: OK
[    4.221214] Testing event signal_overflow_fail: OK
[    4.229216] Testing event signal_lose_info: OK
[    4.237216] Testing event timer_init: OK
[    4.245222] Testing event timer_start: OK
[    4.253223] Testing event timer_expire_entry: OK
[    4.261219] Testing event timer_expire_exit: OK
[    4.269225] Testing event timer_cancel: OK
[    4.277223] Testing event hrtimer_init: OK
[    4.285221] Testing event hrtimer_start: OK
[    4.293225] Testing event hrtimer_expire_entry: OK
[    4.301222] Testing event hrtimer_expire_exit: OK
[    4.309222] Testing event hrtimer_cancel: OK
[    4.317227] Testing event itimer_state: OK
[    4.325228] Testing event itimer_expire: OK
[    4.333209] Testing event irq_handler_entry: OK
[    4.341200] Testing event irq_handler_exit: OK
[    4.349197] Testing event softirq_entry: OK
[    4.357190] Testing event softirq_exit: OK
[    4.365191] Testing event softirq_raise: OK
[    4.373206] Testing event sched_kthread_stop: OK
[    4.381190] Testing event sched_kthread_stop_ret: OK
[    4.389191] Testing event sched_wakeup: OK
[    4.397228] Testing event sched_wakeup_new: OK
[    4.405219] Testing event sched_switch: OK
[    4.413227] Testing event sched_migrate_task: OK
[    4.421290] Testing event sched_process_free: OK
[    4.429198] Testing event sched_process_exit: OK
[    4.437194] Testing event sched_wait_task: OK
[    4.445192] Testing event sched_process_wait: OK
[    4.453196] Testing event sched_process_fork: OK
[    4.461201] Testing event sched_stat_wait: OK
[    4.469239] Testing event sched_stat_sleep: OK
[    4.477232] Testing event sched_stat_iowait: OK
[    4.485221] Testing event sched_stat_runtime: OK
[    4.493249] Testing event sched_pi_setprio: 
[    4.494086] test-events used greatest stack depth: 7108 bytes left
[    4.501135] OK
[    4.501448] Testing event mce_record: OK
[    4.509233] Testing event sys_enter: OK
[    4.517227] Testing event sys_exit: OK
[    4.525242] Running tests on trace event systems:
[    4.526048] Testing event system skb: OK
[    4.533324] Testing event system net: OK
[    4.541327] Testing event system napi: OK
[    4.549310] Testing event system sock: OK
[    4.557308] Testing event system udp: OK
[    4.565215] Testing event system regmap: OK
[    4.573402] Testing event system regulator: OK
[    4.581403] Testing event system gpio: OK
[    4.589254] Testing event system block: OK
[    4.597618] Testing event system writeback: OK
[    4.605786] Testing event system compaction: OK
[    4.613293] Testing event system kmem: OK
[    4.621480] Testing event system vmscan: OK
[    4.629637] Testing event system power: OK
[    4.637382] Testing event system test: OK
[    4.645247] Testing event system module: OK
[    4.653542] Testing event system lock: OK
[    4.661443] Testing event system rcu: OK
[    4.669469] Testing event system workqueue: OK
[    4.677408] Testing event system signal: OK
[    4.685397] Testing event system timer: OK
[    4.693595] Testing event system irq: OK
[    4.701448] Testing event system sched: OK
[    4.709652] Testing event system syscalls: OK
[    4.718444] Testing event system mce: OK
[    4.725302] Testing event system raw_syscalls: OK
[    4.733340] Running tests on all trace events:
[    4.734099] Testing all events: OK
[    4.757857] ------------[ cut here ]------------
[    4.758670] WARNING: at /c/wfg/linux/kernel/trace/trace_events.c:1720 event_trace_self_tests_init+0x87/0x11b()
[    4.760365] Hardware name: Bochs
[    4.760894] Modules linked in:
[    4.761563] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc5+ #41
[    4.762698] Call Trace:
[    4.763133]  [<c13edf12>] ? printk+0x2b/0x3b
[    4.763855]  [<c104b892>] warn_slowpath_common+0xfc/0x13b
[    4.764785]  [<c16e50b6>] ? event_trace_self_tests_init+0x87/0x11b
[    4.765894]  [<c16e50b6>] ? event_trace_self_tests_init+0x87/0x11b
[    4.766945]  [<c16e502f>] ? event_trace_self_tests+0x58a/0x58a
[    4.767942]  [<c104b90f>] warn_slowpath_null+0x3e/0x4e
[    4.768830]  [<c16e50b6>] event_trace_self_tests_init+0x87/0x11b
[    4.769909]  [<c1001145>] do_one_initcall+0xf7/0x272
[    4.770775]  [<c12b0bde>] ? radix_tree_lookup+0x18/0x28
[    4.771683]  [<c10e8601>] ? irq_to_desc+0x22/0x32
[    4.772518]  [<c16cc4e8>] kernel_init+0x2a2/0x3e4
[    4.773373]  [<c16cc246>] ? start_kernel+0x8f9/0x8f9
[    4.774209]  [<c1408a82>] kernel_thread_helper+0x6/0x10
[    4.775107] ---[ end trace 6d450e935ee1897f ]---
[    4.775887] Failed to enable function tracer for event tests
[    4.776871] Testing ftrace filter: OK
[    4.781588] Testing kprobe tracing: OK
modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


[    4.799772] modprobe used greatest stack depth: 6460 bytes left
modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


[    4.819241] modprobe used greatest stack depth: 6280 bytes left
[    4.820558] IMA: No TPM chip found, activating TPM-bypass!
[    4.823134] Freeing unused kernel memory: 400k freed
modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


libudev: udev_monitor_new_from_netlink_fd: error getting socket: Protocol not supported
mountall:mountall.c:3801: Assertion failed in main: udev_monitor = udev_monitor_new_from_netlink (udev, "udev")
modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.2.0-rc5+/modules.dep: No such file or directory


General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[    5.152539] Restarting system.
[    5.152990] machine restart

--8t9RHnE3ZwKMSgU+--
