Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2LSNzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:55:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:31516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2LSNzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:55:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,317,1355126400"; 
   d="scan'208";a="264434138"
Date: Wed, 19 Dec 2012 21:55:09 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [blkcg-cfq-hierarchy] divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
Message-ID: <20121219135509.GA2223@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tejun,

When testing

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git blkcg-cfq-hierarchy
head:   945010db297e9dbe05453af789490f21b99ea8a0 [18/18] cfq-iosched: add hierarchical cfq_group statistics

I got the following divide error, and it's bisected down to

edc3f94f6425e014b6628c1dc5390209bdd9431c is the first bad commit
commit edc3f94f6425e014b6628c1dc5390209bdd9431c
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Dec 14 14:36:07 2012 -0800

    cfq-iosched: implement hierarchy-ready cfq_group charge scaling


[   67.512488] modprobe (1197) used greatest stack depth: 3072 bytes left
[   76.529600] S01glibc.sh (1202) used greatest stack depth: 2880 bytes left
[  161.176483] divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
[  161.176483] Modules linked in:
[  161.176483] CPU 0 
[  161.176483] Pid: 1369, comm: blkid Not tainted 3.7.0-03735-g945010d #4177 Bochs Bochs
[  161.176483] RIP: 0010:[<ffffffff812f7ec9>]  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  161.176483] RSP: 0018:ffff8800194e99d8  EFLAGS: 00000046
[  161.176483] RAX: 0000000000000000 RBX: ffff88001b9e9fb0 RCX: 0000000000000000
[  161.176483] RDX: 0000000000000000 RSI: ffff88001b6bba20 RDI: ffff88001b9e9fb0
[  161.176483] RBP: ffff8800194e99e8 R08: 0000000000000001 R09: 0000000000000000
[  161.176483] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001b9e9fb0
[  161.176483] R13: ffff88001b6bba20 R14: 00000000ffff7859 R15: ffff88001b9ea088
[  161.176483] FS:  00007f18d51c9740(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
[  161.176483] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  161.176483] CR2: 00007f6c8e8f46c0 CR3: 0000000019f5d000 CR4: 00000000000006f0
[  161.176483] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  161.176483] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  161.176483] Process blkid (pid: 1369, threadinfo ffff8800194e8000, task ffff8800194e0000)
[  161.176483] Stack:
[  161.176483]  0000000000000000 ffff88001b6bba18 ffff8800194e9a48 ffffffff812f8891
[  161.176483]  ffff8800194e9a28 ffffffff00000001 ffffffff00000001 00000019004e06a0
[  161.176483]  0000000200000000 ffff88001cedf5e0 ffff88001b6bba18 ffff88001bb2c540
[  161.176483] Call Trace:
[  161.176483]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  161.176483]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  161.176483]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  161.176483]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  161.176483]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  161.176483]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  161.176483]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  161.176483]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  161.176483]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  161.176483]  [<ffffffff817ef7b3>] ? retint_restore_args+0x13/0x13
[  161.176483]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  161.176483]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  161.176483]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  161.176483]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  161.176483]  [<ffffffff81085b60>] ? save_trace+0x3d/0xaf
[  161.176483]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  161.176483]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  161.176483]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  161.176483]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  161.176483]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  161.176483] Code: 08 00 00 00 00 48 89 fe 48 c7 43 10 00 00 00 00 48 89 df 48 89 1a e8 1e 95 00 00 8b 43 38 8b 4b 24 31 d2 ff 43 20 01 c1 c1 e0 0c <f7> f1 89 4b 24 b9 01 00 00 00 85 c0 0f 45 c8 89 4b 28 41 59 5b 
[  161.176483] RIP  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  161.176483]  RSP <ffff8800194e99d8>

Thanks,
Fengguang

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-8292-2012-12-15-07-37-54-3.7.0-03735-g945010d-4177"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.0-03735-g945010d (kbuild@bee) (gcc version 4.7.2 (Debian 4.7.2-4) ) #4177 SMP Sat Dec 15 06:48:56 CST 2012
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=cgroup/blkcg-cfq-hierarchy log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-12-15-06-49-19-cgroup:blkcg-cfq-hierarchy:945010d-945010d-x86_64-lkp-8-ant noapic nolapic nohz=off BOOT_IMAGE=kernel-tests/kernels/x86_64-lkp/945010d/vmlinuz-3.7.0-03735-g945010d
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000001fffe000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x1fffdfff]
[    0.000000]  [mem 0x00000000-0x1fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x1fffdfff @ [mem 0x1fefc000-0x1fffdfff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127976(97%)
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000001fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000001fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000001fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000001fffff40 00040
[    0.000000] ACPI: SSDT 000000001ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000001ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000001ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000001ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff88001e600000-ffff88001edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffdfff]
[    0.000000] On node 0 totalpages: 130945
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3901 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1984 pages used for memmap
[    0.000000]   DMA32 zone: 124990 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x20000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88001f200000 s1916992 r8192 d24512 u2097152
[    0.000000] pcpu-alloc: s1916992 r8192 d24512 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128891
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=cgroup/blkcg-cfq-hierarchy log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal ip=::::kvm::dhcp nfsroot=10.239.97.14:/nfsroot/wfg,tcp,v3,nocto,actimeo=600,nolock,rsize=524288,wsize=524288 rw link=vmlinuz-2012-12-15-06-49-19-cgroup:blkcg-cfq-hierarchy:945010d-945010d-x86_64-lkp-8-ant noapic nolapic nohz=off BOOT_IMAGE=kernel-tests/kernels/x86_64-lkp/945010d/vmlinuz-3.7.0-03735-g945010d
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 474568k/524280k available (8170k kernel code, 500k absent, 49212k reserved, 5174k data, 2764k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
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
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3192.040 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.031263] Calibrating delay loop (skipped), value calculated using timer frequency.. 6384.08 BogoMIPS (lpj=12768160)
[    0.033047] pid_max: default: 32768 minimum: 301
[    0.074711] Mount-cache hash table entries: 256
[    0.210351] mce: CPU supports 10 MCE banks
[    0.214219] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.214219] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.214219] tlb_flushall_shift: -1
[    0.218350] debug: unmapping init [mem 0xffffffff81fbd000-0xffffffff81fc4fff]
[    0.270238] ACPI: Core revision 20121018
[    1.593967] ACPI: setting ELCR to 0200 (from 0c00)
[    1.597744] ftrace: allocating 32308 entries in 127 pages
[    1.821138] smpboot: SMP disabled
[    1.822991] Performance Events: 
[    1.823790] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    1.824172] no hardware sampling interrupt available.
[    1.825067] Broken PMU hardware detected, using software events only.
[    1.825928] Failed to access perfctr msr (MSR c0010004 is 0)
[    1.899000] Brought up 1 CPUs
[    1.900199] ----------------
[    1.900667] | NMI testsuite:
[    1.901121] --------------------
[    1.901635]   remote IPI:  ok  |
[    1.902444]    local IPI:  ok  |
[    3.566931] --------------------
[    3.567450] Good, all   2 testcases passed! |
[    3.568177] ---------------------------------
[    3.568976] smpboot: Total of 1 processors activated (6384.08 BogoMIPS)
[    3.577119] CPU0 attaching NULL sched-domain.
[    3.796641] xor: automatically using best checksumming function:
[    3.840743]    generic_sse:   402.000 MB/sec
[    3.844213] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    3.880289] kworker/u:0 (14) used greatest stack depth: 5456 bytes left
[    3.912654] NET: Registered protocol family 16
[    4.060238] ACPI: bus type pci registered
[    4.104587] PCI: Using configuration type 1 for base access
[    6.523369] kworker/u:0 (206) used greatest stack depth: 5056 bytes left
[    8.982568] bio: create slab <bio-0> at 0
[    9.080540] raid6: sse2x1     165 MB/s
[    9.148298] raid6: sse2x2     157 MB/s
[    9.216402] raid6: sse2x4     170 MB/s
[    9.217033] raid6: using algorithm sse2x4 (170 MB/s)
[    9.217880] raid6: using intx1 recovery algorithm
[    9.238177] ACPI: Added _OSI(Module Device)
[    9.239140] ACPI: Added _OSI(Processor Device)
[    9.240448] ACPI: Added _OSI(3.0 _SCP Extensions)
[    9.241397] ACPI: Added _OSI(Processor Aggregator Device)
[    9.349939] ACPI: EC: Look up EC in DSDT
[   11.249282] ACPI: Interpreter enabled
[   11.250103] ACPI: (supports S0 S3 S4 S5)
[   11.265099] ACPI: Using PIC for interrupt routing
[   15.155093] ACPI: No dock devices found.
[   15.156367] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[   15.167114] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   15.168833] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   15.706076] pci_root PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[   15.707423] pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[   15.715364] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[   15.716235] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[   15.717978] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[   15.720191] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[   15.722099] PCI: root bus 00: using default resources
[   15.724401] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[   15.757363] PCI host bridge to bus 0000:00
[   15.758946] pci_bus 0000:00: root bus resource [bus 00-ff]
[   15.760503] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[   15.761554] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[   15.765566] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   15.773511] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   15.777927] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   15.784886] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[   15.790271] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   15.794226] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[   15.795364] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[   15.797760] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   15.801139] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[   15.804216] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[   15.813784] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[   15.816589] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   15.819134] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[   15.821771] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[   15.831245] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[   15.833700] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[   15.837056] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[   15.840213] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[   15.852275] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   15.854930] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[   15.857750] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[   15.869637] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   15.872229] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[   15.874601] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[   15.886911] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   15.889983] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[   15.892907] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[   15.904706] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   15.908215] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[   15.910589] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[   15.922945] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   15.925980] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[   15.928910] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[   15.940587] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[   15.942477] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[   15.952354] pci_bus 0000:00: on NUMA node 0
[   15.958122] ACPI: Invalid Power Resource to register!
[   15.962287] ACPI: Invalid Power Resource to register!
[   15.966304] ACPI: Invalid Power Resource to register!
[   15.970254] ACPI: Invalid Power Resource to register!
[   15.974063] ACPI: Invalid Power Resource to register!
[   15.978061] ACPI: Invalid Power Resource to register!
[   15.982068] ACPI: Invalid Power Resource to register!
[   15.986004] ACPI: Invalid Power Resource to register!
[   15.990118] ACPI: Invalid Power Resource to register!
[   15.995083] ACPI: Invalid Power Resource to register!
[   15.999023] ACPI: Invalid Power Resource to register!
[   16.002963] ACPI: Invalid Power Resource to register!
[   16.007145] ACPI: Invalid Power Resource to register!
[   16.055552] ACPI _OSC control for PCIe not granted, disabling ASPM
[   24.137807] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   24.181206] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   24.223403] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   24.266197] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   24.306101] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[   24.381725] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[   24.383301] vgaarb: loaded
[   24.384306] vgaarb: bridge control possible 0000:00:02.0
[   24.470130] SCSI subsystem initialized
[   24.471143] ACPI: bus type scsi registered
[   24.514477] libata version 3.00 loaded.
[   24.567091] ACPI: bus type usb registered
[   24.598854] usbcore: registered new interface driver usbfs
[   24.613652] usbcore: registered new interface driver hub
[   24.633182] usbcore: registered new device driver usb
[   24.685495] pps_core: LinuxPPS API ver. 1 registered
[   24.686260] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[   24.698955] PTP clock support registered
[   24.739304] PCI: Using ACPI for IRQ routing
[   24.742674] PCI: pci_cache_line_size set to 64 bytes
[   24.747359] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[   24.748892] e820: reserve RAM buffer [mem 0x1fffe000-0x1fffffff]
[   24.851334] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[   24.852879] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   24.853978] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   24.872462] Switching to clocksource hpet
[   29.677395] pnp: PnP ACPI init
[   29.682983] ACPI: bus type pnp registered
[   29.717123] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   29.754887] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   29.791812] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   29.813012] pnp 00:03: [dma 2]
[   29.830639] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   29.883174] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   29.936712] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   30.055458] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   30.144567] pnp: PnP ACPI: found 7 devices
[   30.145413] ACPI: ACPI bus type pnp unregistered
[   31.492014] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[   31.493634] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[   31.503619] NET: Registered protocol family 2
[   31.550342] TCP established hash table entries: 4096 (order: 4, 65536 bytes)
[   31.555637] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[   31.567923] TCP: Hash tables configured (established 4096 bind 4096)
[   31.572657] TCP: reno registered
[   31.573871] UDP hash table entries: 256 (order: 3, 49152 bytes)
[   31.577093] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[   31.599898] NET: Registered protocol family 1
[   31.631865] RPC: Registered named UNIX socket transport module.
[   31.633477] RPC: Registered udp transport module.
[   31.634233] RPC: Registered tcp transport module.
[   31.635036] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   31.636726] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   31.637845] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   31.639312] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   31.641160] pci 0000:00:02.0: Boot video device
[   31.642914] PCI: CLS 0 bytes, default 64
[   36.807121] DMA-API: preallocated 32768 debug entries
[   36.808714] DMA-API: debugging enabled by kernel config
[   37.121044] Initializing RT-Tester: OK
[   37.622979] Kprobe smoke test started
[   38.691760] Kprobe smoke test passed successfully
[   38.787611] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   40.915644] VFS: Disk quotas dquot_6.5.2
[   40.941314] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   42.547965] NFS: Registering the id_resolver key type
[   42.558769] Key type id_resolver registered
[   42.560976] Key type id_legacy registered
[   42.563544] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   42.958265] ROMFS MTD (C) 2007 Red Hat, Inc.
[   42.994910] fuse init (API version 7.20)
[   43.074085] msgmni has been set to 926
[   43.257977] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[   43.259890] io scheduler noop registered
[   43.261334] io scheduler deadline registered
[   43.314853] io scheduler cfq registered (default)
[   43.350853] list_sort_test: start testing list_sort()
[   43.634896] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   43.699751] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   43.702395] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   43.780763] acpiphp: Slot [3] registered
[   43.802816] acpiphp: Slot [4] registered
[   43.826261] acpiphp: Slot [5] registered
[   43.850959] acpiphp: Slot [6] registered
[   43.874630] acpiphp: Slot [7] registered
[   43.898808] acpiphp: Slot [8] registered
[   43.927591] acpiphp: Slot [9] registered
[   43.959806] acpiphp: Slot [10] registered
[   43.994425] acpiphp: Slot [11] registered
[   44.014716] acpiphp: Slot [12] registered
[   44.037855] acpiphp: Slot [13] registered
[   44.063717] acpiphp: Slot [14] registered
[   44.087045] acpiphp: Slot [15] registered
[   44.109007] acpiphp: Slot [16] registered
[   44.135620] acpiphp: Slot [17] registered
[   44.161224] acpiphp: Slot [18] registered
[   44.187311] acpiphp: Slot [19] registered
[   44.213555] acpiphp: Slot [20] registered
[   44.236904] acpiphp: Slot [21] registered
[   44.262537] acpiphp: Slot [22] registered
[   44.285738] acpiphp: Slot [23] registered
[   44.310961] acpiphp: Slot [24] registered
[   44.334656] acpiphp: Slot [25] registered
[   44.358538] acpiphp: Slot [26] registered
[   44.382777] acpiphp: Slot [27] registered
[   44.406681] acpiphp: Slot [28] registered
[   44.430778] acpiphp: Slot [29] registered
[   44.454751] acpiphp: Slot [30] registered
[   44.478572] acpiphp: Slot [31] registered
[   44.686784] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[   44.691002] ACPI: Power Button [PWRF]
[   44.978734] ACPI: NR_CPUS/possible_cpus limit of 2 reached.  Processor 2/0x1 ignored.
[   44.981075] Unable to map lapic to logical cpu number
[   46.927614] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   46.929375] PCI: setting IRQ 11 as level-triggered
[   46.931667] virtio-pci 0000:00:04.0: setting latency timer to 64
[   47.035522] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   47.036933] PCI: setting IRQ 10 as level-triggered
[   47.038167] virtio-pci 0000:00:05.0: setting latency timer to 64
[   47.130002] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   47.131520] virtio-pci 0000:00:06.0: setting latency timer to 64
[   47.219052] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   47.220994] virtio-pci 0000:00:07.0: setting latency timer to 64
[   47.244912] virtio-pci 0000:00:08.0: setting latency timer to 64
[   47.270506] virtio-pci 0000:00:09.0: setting latency timer to 64
[   47.343606] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   47.381871] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   47.642510] Non-volatile memory driver v1.3
[   47.669513] Linux agpgart interface v0.103
[   47.769701] [drm] Initialized drm 1.1.0 20060810
[   48.625624] brd: module loaded
[   49.087631] loop: module loaded
[   49.209665]  vda: unknown partition table
[   49.317134]  vdb: unknown partition table
[   49.423706]  vdc: unknown partition table
[   49.523980]  vdd: unknown partition table
[   49.626363]  vde: unknown partition table
[   49.728699]  vdf: unknown partition table
[   49.781884] lkdtm: No crash points registered, enable through debugfs
[   49.796035] Uniform Multi-Platform E-IDE driver
[   49.835167] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[   49.844697] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[   49.846875] pci 0000:00:01.1: setting latency timer to 64
[   49.847880]     ide0: BM-DMA at 0xc1c0-0xc1c7
[   49.851197]     ide1: BM-DMA at 0xc1c8-0xc1cf
[   49.853341] Probing IDE interface ide0...
[   50.467823] Probing IDE interface ide1...
[   51.205653] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[   51.902992] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[   51.907338] hdc: MWDMA2 mode selected
[   51.912892] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   51.915839] ide1 at 0x170-0x177,0x376 on irq 15
[   52.298813] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[   52.315529] ide-gd driver 1.18
[   52.330269] ide-cd driver 5.00
[   52.361197] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[   52.362721] cdrom: Uniform CD-ROM driver Revision: 3.20
[   52.603760] Loading iSCSI transport class v2.0-870.
[   52.990337] Adaptec aacraid driver 1.2-0[29801]-ms
[   53.026686] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   53.141638] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.04.00.08-k.
[   53.175978] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[   53.199740] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[   53.216155] megasas: 06.504.01.00-rc1 Mon. Oct. 1 17:00:00 PDT 2012
[   53.251087] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   53.267465] RocketRAID 3xxx/4xxx Controller driver v1.8
[   53.523712] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[   53.558465] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   53.559350] Copyright (c) 2007 Atheros Corporation.
[   53.646761] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   53.666253] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   53.666253]   http://www.scyld.com/network/drivers.html
[   53.719089] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[   53.754365] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   53.755310] e100: Copyright(c) 1999-2006 Intel Corporation
[   53.775353] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[   53.777021] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   53.781754] e1000 0000:00:03.0: setting latency timer to 64
[   54.191709] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[   54.194329] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[   54.210663] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[   54.211523] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   54.225354] igb: Intel(R) Gigabit Ethernet Network Driver - version 4.1.2-k
[   54.226327] igb: Copyright (c) 2007-2012 Intel Corporation.
[   54.242106] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[   54.243102] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   54.279812] sky2: driver version 1.30
[   54.435859] usbcore: registered new interface driver catc
[   54.451045] usbcore: registered new interface driver kaweth
[   54.451997] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   54.467632] usbcore: registered new interface driver pegasus
[   54.484164] usbcore: registered new interface driver rtl8150
[   54.502708] usbcore: registered new interface driver asix
[   54.523180] usbcore: registered new interface driver cdc_ether
[   54.539920] usbcore: registered new interface driver cdc_eem
[   54.555582] usbcore: registered new interface driver dm9601
[   54.571470] usbcore: registered new interface driver smsc75xx
[   54.589981] usbcore: registered new interface driver smsc95xx
[   54.604038] usbcore: registered new interface driver gl620a
[   54.622596] usbcore: registered new interface driver net1080
[   54.640832] usbcore: registered new interface driver plusb
[   54.655761] usbcore: registered new interface driver rndis_host
[   54.669464] usbcore: registered new interface driver cdc_subset
[   54.683836] usbcore: registered new interface driver zaurus
[   54.701372] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[   54.718973] usbcore: registered new interface driver int51x1
[   54.736700] usbcore: registered new interface driver ipheth
[   54.753832] usbcore: registered new interface driver sierra_net
[   54.771334] usbcore: registered new interface driver cdc_ncm
[   54.772888] Fusion MPT base driver 3.04.20
[   54.773518] Copyright (c) 1999-2008 LSI Corporation
[   54.776862] Fusion MPT SPI Host driver 3.04.20
[   54.795888] Fusion MPT FC Host driver 3.04.20
[   54.814606] Fusion MPT SAS Host driver 3.04.20
[   54.831421] Fusion MPT misc device (ioctl) driver 3.04.20
[   54.853907] mptctl: Registered with Fusion MPT base driver
[   54.854811] mptctl: /dev/mptctl @ (major,minor=10,220)
[   54.914772] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   54.915861] ehci-pci: EHCI PCI platform driver
[   54.932014] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   54.947147] uhci_hcd: USB Universal Host Controller Interface driver
[   54.986653] Initializing USB Mass Storage driver...
[   55.003258] usbcore: registered new interface driver usb-storage
[   55.004825] USB Mass Storage support registered.
[   55.023456] usbcore: registered new interface driver ums-alauda
[   55.041038] usbcore: registered new interface driver ums-datafab
[   55.053952] usbcore: registered new interface driver ums-freecom
[   55.071654] usbcore: registered new interface driver ums-isd200
[   55.087811] usbcore: registered new interface driver ums-jumpshot
[   55.103154] usbcore: registered new interface driver ums-sddr09
[   55.118933] usbcore: registered new interface driver ums-sddr55
[   55.135405] usbcore: registered new interface driver ums-usbat
[   55.151148] usbcore: registered new interface driver usbtest
[   55.187054] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   55.225453] serio: i8042 KBD port at 0x60,0x64 irq 1
[   55.229019] serio: i8042 AUX port at 0x60,0x64 irq 12
[   55.294779] mousedev: PS/2 mouse device common for all mice
[   55.405855] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[   55.599363] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   55.642731] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   55.647626] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   55.673565] i6300esb: initialized (0xffffc9000002e000). heartbeat=30 sec (nowayout=0)
[   55.685398] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   55.699192] iTCO_vendor_support: vendor-support=0
[   55.703536] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[   55.705315] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[   55.731203] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   55.736757] md: linear personality registered for level -1
[   55.737683] md: raid0 personality registered for level 0
[   55.738459] md: raid1 personality registered for level 1
[   55.739261] md: raid10 personality registered for level 10
[   55.740740] md: raid6 personality registered for level 6
[   55.741527] md: raid5 personality registered for level 5
[   55.742328] md: raid4 personality registered for level 4
[   55.743142] md: multipath personality registered for level -4
[   55.744137] md: faulty personality registered for level -5
[   55.918870] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[   55.943160] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   56.033190] device-mapper: multipath: version 1.5.0 loaded
[   56.034954] device-mapper: multipath round-robin: version 1.0.0 loaded
[   56.147150] EDAC MC: Ver: 3.0.0
[   56.222373] cpuidle: using governor ladder
[   56.223741] cpuidle: using governor menu
[   56.313709] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   56.758310] usbcore: registered new interface driver usbhid
[   56.759232] usbhid: USB HID core driver
[   56.763778] oprofile: using timer interrupt.
[   56.791181] TCP: bic registered
[   56.791822] Initializing XFRM netlink socket
[   56.919633] NET: Registered protocol family 10
[   57.011760] sit: IPv6 over IPv4 tunneling driver
[   57.101670] NET: Registered protocol family 17
[   57.110823] 8021q: 802.1Q VLAN Support v1.8
[   57.163688] sctp: Hash tables configured (established 1638 bind 1638)
[   57.221777] Key type dns_resolver registered
[   57.287882] 
[   57.287882] printing PIC contents
[   57.289400] ... PIC  IMR: 21f8
[   57.290506] ... PIC  IRR: 0010
[   57.291012] ... PIC  ISR: 0000
[   57.291546] ... PIC ELCR: 0e00
[   57.354836] PM: Hibernation image not present or could not be loaded.
[   57.359442] registered taskstats version 1
[   57.418731] rtc-test rtc-test.0: setting system clock to 2012-12-14 23:36:02 UTC (1355528162)
[   57.428802] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   57.702661] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   57.703639] 8021q: adding VLAN 0 to HW filter on device eth0
[   59.714328] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   59.722070] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   59.738600] Sending DHCP requests ., OK
[   59.779299] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0.2.15
[   59.827769] IP-Config: Complete:
[   59.829367]      device=eth0, hwaddr=52:54:00:12:34:56, ipaddr=10.0.2.15, mask=255.255.255.0, gw=10.0.2.2
[   59.830946]      host=kvm, domain=, nis-domain=(none)
[   59.831760]      bootserver=10.0.2.2, rootserver=10.239.97.14, rootpath=
[   59.833421]      nameserver0=10.0.2.3[   59.860893] md: Waiting for all devices to be available before autodetect
[   59.862050] md: If you don't use raid, use raid=noautodetect
[   59.951923] md: Autodetecting RAID arrays.
[   59.953222] md: Scanned 0 and added 0 devices.
[   59.953868] md: autorun ...
[   59.954327] md: ... autorun DONE.
[   60.389205] VFS: Mounted root (nfs filesystem) on device 0:12.
[   60.394063] debug: unmapping init [mem 0xffffffff81d0a000-0xffffffff81fbcfff]
[   67.512488] modprobe (1197) used greatest stack depth: 3072 bytes left
[   76.529600] S01glibc.sh (1202) used greatest stack depth: 2880 bytes left
[  161.176483] divide error: 0000 [#1] SMP DEBUG_PAGEALLOC
[  161.176483] Modules linked in:
[  161.176483] CPU 0 
[  161.176483] Pid: 1369, comm: blkid Not tainted 3.7.0-03735-g945010d #4177 Bochs Bochs
[  161.176483] RIP: 0010:[<ffffffff812f7ec9>]  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  161.176483] RSP: 0018:ffff8800194e99d8  EFLAGS: 00000046
[  161.176483] RAX: 0000000000000000 RBX: ffff88001b9e9fb0 RCX: 0000000000000000
[  161.176483] RDX: 0000000000000000 RSI: ffff88001b6bba20 RDI: ffff88001b9e9fb0
[  161.176483] RBP: ffff8800194e99e8 R08: 0000000000000001 R09: 0000000000000000
[  161.176483] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001b9e9fb0
[  161.176483] R13: ffff88001b6bba20 R14: 00000000ffff7859 R15: ffff88001b9ea088
[  161.176483] FS:  00007f18d51c9740(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
[  161.176483] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  161.176483] CR2: 00007f6c8e8f46c0 CR3: 0000000019f5d000 CR4: 00000000000006f0
[  161.176483] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  161.176483] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  161.176483] Process blkid (pid: 1369, threadinfo ffff8800194e8000, task ffff8800194e0000)
[  161.176483] Stack:
[  161.176483]  0000000000000000 ffff88001b6bba18 ffff8800194e9a48 ffffffff812f8891
[  161.176483]  ffff8800194e9a28 ffffffff00000001 ffffffff00000001 00000019004e06a0
[  161.176483]  0000000200000000 ffff88001cedf5e0 ffff88001b6bba18 ffff88001bb2c540
[  161.176483] Call Trace:
[  161.176483]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  161.176483]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  161.176483]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  161.176483]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  161.176483]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  161.176483]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  161.176483]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  161.176483]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  161.176483]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  161.176483]  [<ffffffff817ef7b3>] ? retint_restore_args+0x13/0x13
[  161.176483]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  161.176483]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  161.176483]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  161.176483]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  161.176483]  [<ffffffff81085b60>] ? save_trace+0x3d/0xaf
[  161.176483]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  161.176483]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  161.176483]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  161.176483]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  161.176483]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  161.176483] Code: 08 00 00 00 00 48 89 fe 48 c7 43 10 00 00 00 00 48 89 df 48 89 1a e8 1e 95 00 00 8b 43 38 8b 4b 24 31 d2 ff 43 20 01 c1 c1 e0 0c <f7> f1 89 4b 24 b9 01 00 00 00 85 c0 0f 45 c8 89 4b 28 41 59 5b 
[  161.176483] RIP  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  161.176483]  RSP <ffff8800194e99d8>
[  161.176483] ---[ end trace 597483f2065d40cf ]---
[  161.176483] BUG: sleeping function called from invalid context at /c/kernel-tests/src/stable/kernel/rwsem.c:20
[  161.176483] in_atomic(): 1, irqs_disabled(): 1, pid: 1369, name: blkid
[  161.176483] INFO: lockdep is turned off.
[  161.176483] irq event stamp: 6118
[  161.176483] hardirqs last  enabled at (6117): [<ffffffff817ef2a0>] _raw_spin_unlock_irq+0x2e/0x48
[  161.176483] hardirqs last disabled at (6118): [<ffffffff812e8870>] blk_flush_plug_list+0xff/0x1e2
[  161.176483] softirqs last  enabled at (6112): [<ffffffff8103cf6f>] __do_softirq+0x1ca/0x231
[  161.176483] softirqs last disabled at (6107): [<ffffffff817f7cfc>] call_softirq+0x1c/0x30
[  161.176483] Pid: 1369, comm: blkid Tainted: G      D      3.7.0-03735-g945010d #4177
[  161.176483] Call Trace:
[  161.176483]  [<ffffffff8108873d>] ? print_irqtrace_events+0xce/0xd2
[  161.176483]  [<ffffffff810632f3>] __might_sleep+0x107/0x10b
[  161.176483]  [<ffffffff817eccb9>] down_read+0x2a/0x91
[  161.176483]  [<ffffffff810481b5>] exit_signals+0x26/0x129
[  161.176483]  [<ffffffff8103a5d5>] do_exit+0x119/0x8f6
[  161.176483]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  161.176483]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  161.176483]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  161.176483]  [<ffffffff8100532f>] die+0x5a/0x63
[  161.176483]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  161.176483]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  161.176483]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  161.176483]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  161.176483]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  161.176483]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  161.176483]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  161.176483]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  161.176483]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  161.176483]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  161.176483]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  161.176483]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  161.176483]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  161.176483]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  161.176483]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  161.176483]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  161.176483]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  161.176483]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  161.176483]  [<ffffffff817ef7b3>] ? retint_restore_args+0x13/0x13
[  161.176483]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  161.176483]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  161.176483]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  161.176483]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  161.176483]  [<ffffffff81085b60>] ? save_trace+0x3d/0xaf
[  161.176483]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  161.176483]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  161.176483]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  161.176483]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  161.176483]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  161.176483] note: blkid[1369] exited with preempt_count 1
[  161.283858] BUG: scheduling while atomic: blkid/1369/0x10000002
[  161.285148] INFO: lockdep is turned off.
[  161.285757] Modules linked in:
[  161.286416] Pid: 1369, comm: blkid Tainted: G      D      3.7.0-03735-g945010d #4177
[  161.287496] Call Trace:
[  161.287993]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  161.289184]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  161.290018]  [<ffffffff813041c1>] ? number.isra.1+0x128/0x238
[  161.290842]  [<ffffffff8108560a>] ? zap_class+0x6/0x8f
[  161.291652]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  161.292889]  [<ffffffff810fa0ad>] ? unmap_page_range+0x29b/0x6af
[  161.293818]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  161.294681]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  161.295525]  [<ffffffff810fa392>] unmap_page_range+0x580/0x6af
[  161.296732]  [<ffffffff810fa589>] unmap_single_vma+0xc8/0xd3
[  161.297618]  [<ffffffff810e4461>] ? __pagevec_lru_add+0x1e/0x20
[  161.298528]  [<ffffffff810fac02>] unmap_vmas+0x32/0x49
[  161.299347]  [<ffffffff81100cd9>] exit_mmap+0x94/0x122
[  161.300481]  [<ffffffff810334b5>] mmput+0x5e/0xbe
[  161.301256]  [<ffffffff8103a7b0>] do_exit+0x2f4/0x8f6
[  161.302040]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  161.302817]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  161.303661]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  161.304778]  [<ffffffff8100532f>] die+0x5a/0x63
[  161.305550]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  161.306354]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  161.307204]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  161.309297]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  161.310303]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  161.311268]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  161.312447]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  161.313312]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  161.314306]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  161.315292]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  161.316534]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  161.317415]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  161.318314]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  161.319081]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  161.319961]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  161.321223]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  161.322111]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  161.323082]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  161.324383]  [<ffffffff817ef7b3>] ? retint_restore_args+0x13/0x13
[  161.325342]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  161.326226]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  161.327206]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  161.328490]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  161.329450]  [<ffffffff81085b60>] ? save_trace+0x3d/0xaf
[  161.330294]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  161.331142]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  161.331974]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  161.333127]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  161.333907]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  162.321090] divide error: 0000 [#2] SMP DEBUG_PAGEALLOC
[  162.322317] Modules linked in:
[  162.322840] CPU 0 
[  162.323262] Pid: 1377, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177 Bochs Bochs
[  162.324375] RIP: 0010:[<ffffffff812f7ec9>]  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  162.324375] RSP: 0018:ffff8800194dd9d8  EFLAGS: 00000046
[  162.324375] RAX: 0000000000000000 RBX: ffff88001b4b74d0 RCX: 0000000000000000
[  162.324375] RDX: 0000000000000000 RSI: ffff88001b4b4550 RDI: ffff88001b4b74d0
[  162.324375] RBP: ffff8800194dd9e8 R08: 0000000000000001 R09: 0000000000000000
[  162.324375] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001b4b74d0
[  162.324375] R13: ffff88001b4b4550 R14: 00000000ffff7978 R15: ffff88001b4b75a8
[  162.324375] FS:  00007f49f85e0740(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
[  162.324375] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  162.324375] CR2: 00007f49f81d1290 CR3: 0000000019f56000 CR4: 00000000000006f0
[  162.324375] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  162.324375] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  162.324375] Process blkid (pid: 1377, threadinfo ffff8800194dc000, task ffff8800195e2370)
[  162.324375] Stack:
[  162.324375]  0000000000000000 ffff88001b4b4548 ffff8800194dda48 ffffffff812f8891
[  162.324375]  ffff8800194dda28 ffffffff00000001 ffffffff00000001 0000001900000000
[  162.324375]  0000000200000000 ffff88001cede8c0 ffff88001b4b4548 ffff88001bb2c7e0
[  162.324375] Call Trace:
[  162.324375]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  162.324375]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  162.324375]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  162.324375]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  162.324375]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  162.324375]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  162.324375]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  162.324375]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  162.324375]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  162.324375]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  162.324375]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  162.324375]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  162.324375]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  162.324375]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  162.324375]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  162.324375]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  162.324375]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  162.324375] Code: 08 00 00 00 00 48 89 fe 48 c7 43 10 00 00 00 00 48 89 df 48 89 1a e8 1e 95 00 00 8b 43 38 8b 4b 24 31 d2 ff 43 20 01 c1 c1 e0 0c <f7> f1 89 4b 24 b9 01 00 00 00 85 c0 0f 45 c8 89 4b 28 41 59 5b 
[  162.324375] RIP  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  162.324375]  RSP <ffff8800194dd9d8>
[  162.324375] ---[ end trace 597483f2065d40d0 ]---
[  162.324375] BUG: sleeping function called from invalid context at /c/kernel-tests/src/stable/kernel/rwsem.c:20
[  162.324375] in_atomic(): 1, irqs_disabled(): 1, pid: 1377, name: blkid
[  162.324375] INFO: lockdep is turned off.
[  162.324375] irq event stamp: 3048
[  162.324375] hardirqs last  enabled at (3047): [<ffffffff817ef7fd>] retint_careful+0xb/0x3c
[  162.324375] hardirqs last disabled at (3048): [<ffffffff817ee9bf>] _raw_spin_lock_irq+0x1f/0x86
[  162.324375] softirqs last  enabled at (3044): [<ffffffff8103cf6f>] __do_softirq+0x1ca/0x231
[  162.324375] softirqs last disabled at (3027): [<ffffffff817f7cfc>] call_softirq+0x1c/0x30
[  162.324375] Pid: 1377, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  162.324375] Call Trace:
[  162.324375]  [<ffffffff8108873d>] ? print_irqtrace_events+0xce/0xd2
[  162.324375]  [<ffffffff810632f3>] __might_sleep+0x107/0x10b
[  162.324375]  [<ffffffff817eccb9>] down_read+0x2a/0x91
[  162.324375]  [<ffffffff810481b5>] exit_signals+0x26/0x129
[  162.324375]  [<ffffffff8103a5d5>] do_exit+0x119/0x8f6
[  162.324375]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  162.324375]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  162.324375]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  162.324375]  [<ffffffff8100532f>] die+0x5a/0x63
[  162.324375]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  162.324375]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  162.324375]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  162.324375]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  162.324375]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  162.324375]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  162.324375]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  162.324375]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  162.324375]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  162.324375]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  162.324375]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  162.324375]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  162.324375]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  162.324375]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  162.324375]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  162.324375]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  162.324375]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  162.324375]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  162.324375]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  162.324375]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  162.324375]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  162.324375]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  162.324375]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  162.324375]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  162.324375]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  162.324375]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  162.324375] note: blkid[1377] exited with preempt_count 1
[  162.410204] BUG: scheduling while atomic: blkid/1377/0x10000002
[  162.411090] INFO: lockdep is turned off.
[  162.411663] Modules linked in:
[  162.412602] Pid: 1377, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  162.413690] Call Trace:
[  162.414208]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  162.415064]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  162.415838]  [<ffffffff813041c1>] ? number.isra.1+0x128/0x238
[  162.417116]  [<ffffffff8108560a>] ? zap_class+0x6/0x8f
[  162.417907]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  162.418799]  [<ffffffff810fa0ad>] ? unmap_page_range+0x29b/0x6af
[  162.419719]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  162.420910]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  162.421762]  [<ffffffff810fa392>] unmap_page_range+0x580/0x6af
[  162.422667]  [<ffffffff810fa589>] unmap_single_vma+0xc8/0xd3
[  162.423549]  [<ffffffff810e4461>] ? __pagevec_lru_add+0x1e/0x20
[  162.424768]  [<ffffffff810fac02>] unmap_vmas+0x32/0x49
[  162.425600]  [<ffffffff81100cd9>] exit_mmap+0x94/0x122
[  162.426433]  [<ffffffff810334b5>] mmput+0x5e/0xbe
[  162.427190]  [<ffffffff8103a7b0>] do_exit+0x2f4/0x8f6
[  162.427982]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  162.429137]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  162.429961]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  162.430729]  [<ffffffff8100532f>] die+0x5a/0x63
[  162.431513]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  162.432630]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  162.433518]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  162.434513]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  162.435498]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  162.436790]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  162.437670]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  162.438517]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  162.439509]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  162.440817]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  162.441769]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  162.442628]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  162.443582]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  162.444678]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  162.445608]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  162.446563]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  162.447434]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  162.448721]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  162.449737]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  162.450699]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  162.451663]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  162.452983]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  162.453863]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  162.454717]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  162.455524]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  162.457316]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  162.889918] divide error: 0000 [#3] SMP DEBUG_PAGEALLOC
[  162.891080] Modules linked in:
[  162.891616] CPU 0 
[  162.891988] Pid: 1376, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177 Bochs Bochs
[  162.892456] RIP: 0010:[<ffffffff812f7ec9>]  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  162.892456] RSP: 0018:ffff8800194ff9d8  EFLAGS: 00000046
[  162.892456] RAX: 0000000000000000 RBX: ffff88001b4b7a18 RCX: 0000000000000000
[  162.892456] RDX: 0000000000000000 RSI: ffff88001b4b4008 RDI: ffff88001b4b7a18
[  162.892456] RBP: ffff8800194ff9e8 R08: 0000000000000001 R09: 0000000000000000
[  162.892456] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001b4b7a18
[  162.892456] R13: ffff88001b4b4008 R14: 00000000ffff7a06 R15: ffff88001b4b7af0
[  162.892456] FS:  00007fb1af517740(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
[  162.892456] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  162.892456] CR2: 00007fb1af108290 CR3: 0000000019435000 CR4: 00000000000006f0
[  162.892456] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  162.892456] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  162.892456] Process blkid (pid: 1376, threadinfo ffff8800194fe000, task ffff8800195e46e0)
[  162.892456] Stack:
[  162.892456]  0000000000000000 ffff88001b4b4000 ffff8800194ffa48 ffffffff812f8891
[  162.892456]  ffff8800194ffa28 ffffffff00000001 ffffffff00000001 0000001900000000
[  162.892456]  0000000200000000 ffff88001cedf3b0 ffff88001b4b4000 ffff88001bb2d7a0
[  162.892456] Call Trace:
[  162.892456]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  162.892456]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  162.892456]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  162.892456]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  162.892456]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  162.892456]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  162.892456]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  162.892456]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  162.892456]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  162.892456]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  162.892456]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  162.892456]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  162.892456]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  162.892456]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  162.892456]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  162.892456]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  162.892456]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  162.892456] Code: 08 00 00 00 00 48 89 fe 48 c7 43 10 00 00 00 00 48 89 df 48 89 1a e8 1e 95 00 00 8b 43 38 8b 4b 24 31 d2 ff 43 20 01 c1 c1 e0 0c <f7> f1 89 4b 24 b9 01 00 00 00 85 c0 0f 45 c8 89 4b 28 41 59 5b 
[  162.892456] RIP  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  162.892456]  RSP <ffff8800194ff9d8>
[  162.892456] ---[ end trace 597483f2065d40d1 ]---
[  162.892456] note: blkid[1376] exited with preempt_count 1
[  162.937755] BUG: scheduling while atomic: blkid/1376/0x10000002
[  162.938632] INFO: lockdep is turned off.
[  162.939237] Modules linked in:
[  162.939839] Pid: 1376, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  162.941339] Call Trace:
[  162.941816]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  162.942680]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  162.943510]  [<ffffffff813041c1>] ? number.isra.1+0x128/0x238
[  162.944737]  [<ffffffff810fa0ad>] ? unmap_page_range+0x29b/0x6af
[  162.945681]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  162.946542]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  162.947395]  [<ffffffff810fa392>] unmap_page_range+0x580/0x6af
[  162.948630]  [<ffffffff810fa589>] unmap_single_vma+0xc8/0xd3
[  162.949528]  [<ffffffff810e4461>] ? __pagevec_lru_add+0x1e/0x20
[  162.950439]  [<ffffffff810fac02>] unmap_vmas+0x32/0x49
[  162.951247]  [<ffffffff81100cd9>] exit_mmap+0x94/0x122
[  162.952411]  [<ffffffff810334b5>] mmput+0x5e/0xbe
[  162.953189]  [<ffffffff8103a7b0>] do_exit+0x2f4/0x8f6
[  162.953983]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  162.954782]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  162.955624]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  162.956760]  [<ffffffff8100532f>] die+0x5a/0x63
[  162.957531]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  162.958341]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  162.959197]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  162.960534]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  162.961544]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  162.962521]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  162.963382]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  162.964551]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  162.965563]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  162.966559]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  162.967496]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  162.968681]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  162.969605]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  162.970394]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  162.971301]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  162.972559]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  162.973453]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  162.974435]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  162.975441]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  162.976746]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  162.977724]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  162.978682]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  162.979542]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  162.980724]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  162.981641]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  162.982457]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  163.330522] divide error: 0000 [#4] SMP DEBUG_PAGEALLOC
[  163.331608] Modules linked in:
[  163.332253] CPU 0 
[  163.332377] Pid: 1378, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177 Bochs Bochs
[  163.332377] RIP: 0010:[<ffffffff812f7ec9>]  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  163.332377] RSP: 0018:ffff880019f859d8  EFLAGS: 00000046
[  163.332377] RAX: 0000000000000000 RBX: ffff88001b4b6f88 RCX: 0000000000000000
[  163.332377] RDX: 0000000000000000 RSI: ffff88001b4b4a98 RDI: ffff88001b4b6f88
[  163.332377] RBP: ffff880019f859e8 R08: 0000000000000001 R09: 0000000000000000
[  163.332377] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001b4b6f88
[  163.332377] R13: ffff88001b4b4a98 R14: 00000000ffff7a74 R15: ffff88001b4b7060
[  163.332377] FS:  00007f12c544d740(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
[  163.332377] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  163.332377] CR2: 00007f12c503e290 CR3: 0000000019ff7000 CR4: 00000000000006f0
[  163.332377] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  163.332377] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  163.332377] Process blkid (pid: 1378, threadinfo ffff880019f84000, task ffff880019f7a370)
[  163.332377] Stack:
[  163.332377]  0000000000000000 ffff88001b4b4a90 ffff880019f85a48 ffffffff812f8891
[  163.332377]  ffff880019f85a28 ffffffff00000001 ffffffff00000001 0000001900000000
[  163.332377]  0000000200000000 ffff88001cedeaf0 ffff88001b4b4a90 ffff88001bb2ca80
[  163.332377] Call Trace:
[  163.332377]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  163.332377]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  163.332377]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  163.332377]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  163.332377]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  163.332377]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  163.332377]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  163.332377]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  163.332377]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  163.332377]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  163.332377]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  163.332377]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  163.332377]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  163.332377]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  163.332377]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  163.332377]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  163.332377]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  163.332377] Code: 08 00 00 00 00 48 89 fe 48 c7 43 10 00 00 00 00 48 89 df 48 89 1a e8 1e 95 00 00 8b 43 38 8b 4b 24 31 d2 ff 43 20 01 c1 c1 e0 0c <f7> f1 89 4b 24 b9 01 00 00 00 85 c0 0f 45 c8 89 4b 28 41 59 5b 
[  163.332377] RIP  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  163.332377]  RSP <ffff880019f859d8>
[  163.332377] ---[ end trace 597483f2065d40d2 ]---
[  163.332377] BUG: sleeping function called from invalid context at /c/kernel-tests/src/stable/kernel/rwsem.c:20
[  163.332377] in_atomic(): 1, irqs_disabled(): 1, pid: 1378, name: blkid
[  163.332377] INFO: lockdep is turned off.
[  163.332377] irq event stamp: 2026
[  163.332377] hardirqs last  enabled at (2025): [<ffffffff817ef254>] _raw_spin_unlock_irqrestore+0x47/0x65
[  163.332377] hardirqs last disabled at (2026): [<ffffffff817ee9bf>] _raw_spin_lock_irq+0x1f/0x86
[  163.332377] softirqs last  enabled at (1942): [<ffffffff8103cf6f>] __do_softirq+0x1ca/0x231
[  163.332377] softirqs last disabled at (1923): [<ffffffff817f7cfc>] call_softirq+0x1c/0x30
[  163.332377] Pid: 1378, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  163.332377] Call Trace:
[  163.332377]  [<ffffffff8108873d>] ? print_irqtrace_events+0xce/0xd2
[  163.332377]  [<ffffffff810632f3>] __might_sleep+0x107/0x10b
[  163.332377]  [<ffffffff817eccb9>] down_read+0x2a/0x91
[  163.332377]  [<ffffffff810481b5>] exit_signals+0x26/0x129
[  163.332377]  [<ffffffff8103a5d5>] do_exit+0x119/0x8f6
[  163.332377]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  163.332377]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  163.332377]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  163.332377]  [<ffffffff8100532f>] die+0x5a/0x63
[  163.332377]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  163.332377]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  163.332377]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.332377]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  163.332377]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  163.332377]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  163.332377]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  163.332377]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.332377]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  163.332377]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  163.332377]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  163.332377]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  163.332377]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  163.332377]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  163.332377]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  163.332377]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  163.332377]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  163.332377]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  163.332377]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  163.332377]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  163.332377]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  163.332377]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  163.332377]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  163.332377]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  163.332377]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  163.332377]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  163.332377] note: blkid[1378] exited with preempt_count 1
[  163.416562] BUG: scheduling while atomic: blkid/1378/0x10000002
[  163.417367] INFO: lockdep is turned off.
[  163.417917] Modules linked in:
[  163.418464] Pid: 1378, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  163.419478] Call Trace:
[  163.419953]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  163.421375]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  163.422222]  [<ffffffff813041c1>] ? number.isra.1+0x128/0x238
[  163.423096]  [<ffffffff8108560a>] ? zap_class+0x6/0x8f
[  163.423886]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  163.425196]  [<ffffffff810fa0ad>] ? unmap_page_range+0x29b/0x6af
[  163.426127]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  163.426944]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  163.427800]  [<ffffffff810fa392>] unmap_page_range+0x580/0x6af
[  163.429050]  [<ffffffff810fa589>] unmap_single_vma+0xc8/0xd3
[  163.429934]  [<ffffffff810e4461>] ? __pagevec_lru_add+0x1e/0x20
[  163.430856]  [<ffffffff810fac02>] unmap_vmas+0x32/0x49
[  163.431708]  [<ffffffff81100cd9>] exit_mmap+0x94/0x122
[  163.432872]  [<ffffffff810334b5>] mmput+0x5e/0xbe
[  163.433662]  [<ffffffff8103a7b0>] do_exit+0x2f4/0x8f6
[  163.434475]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  163.435330]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  163.436505]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  163.437388]  [<ffffffff8100532f>] die+0x5a/0x63
[  163.438105]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  163.438871]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  163.439741]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.441105]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  163.442105]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  163.443063]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  163.443898]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  163.445126]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.446164]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  163.447186]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  163.448435]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  163.449329]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  163.450211]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  163.450941]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  163.451843]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  163.453155]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  163.454037]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  163.455150]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  163.456479]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  163.457483]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  163.458450]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  163.459407]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  163.460589]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  163.461463]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  163.462359]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  163.463142]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  163.557805] BUG: scheduling while atomic: blkid/1378/0x10000002
[  163.558801] INFO: lockdep is turned off.
[  163.559437] Modules linked in:
[  163.560026] Pid: 1378, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  163.561549] Call Trace:
[  163.562058]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  163.562914]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  163.563757]  [<ffffffff8108a327>] ? trace_hardirqs_on+0xd/0xf
[  163.564987]  [<ffffffff817e1dac>] ? __slab_free+0x350/0x3b7
[  163.565885]  [<ffffffff811342e8>] ? put_files_struct+0x27/0x172
[  163.566795]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  163.567655]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  163.568922]  [<ffffffff8113439b>] put_files_struct+0xda/0x172
[  163.569868]  [<ffffffff811342e8>] ? put_files_struct+0x27/0x172
[  163.570771]  [<ffffffff811344ce>] exit_files+0x49/0x52
[  163.571590]  [<ffffffff8103a80a>] do_exit+0x34e/0x8f6
[  163.572773]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  163.573636]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  163.574478]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  163.575325]  [<ffffffff8100532f>] die+0x5a/0x63
[  163.576014]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  163.577179]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  163.578009]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.579004]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  163.579981]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  163.581341]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  163.582194]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  163.583044]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.584198]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  163.585595]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  163.586535]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  163.587437]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  163.588660]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  163.589483]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  163.590423]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  163.591351]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  163.592530]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  163.593531]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  163.594538]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  163.595514]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  163.596799]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  163.597782]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  163.598721]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  163.599572]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  163.600698]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  163.601543]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  163.692977] divide error: 0000 [#5] SMP DEBUG_PAGEALLOC
[  163.694131] Modules linked in:
[  163.694686] CPU 0 
[  163.695014] Pid: 1380, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177 Bochs Bochs
[  163.696385] RIP: 0010:[<ffffffff812f7ec9>]  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  163.696385] RSP: 0018:ffff8800195339d8  EFLAGS: 00000046
[  163.696385] RAX: 0000000000000000 RBX: ffff88001b4b6a40 RCX: 0000000000000000
[  163.696385] RDX: 0000000000000000 RSI: ffff88001b4b4fe0 RDI: ffff88001b4b6a40
[  163.696385] RBP: ffff8800195339e8 R08: 0000000000000001 R09: 0000000000000000
[  163.696385] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001b4b6a40
[  163.696385] R13: ffff88001b4b4fe0 R14: 00000000ffff7acf R15: ffff88001b4b6b18
[  163.696385] FS:  00007fd416ffd740(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
[  163.696385] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  163.696385] CR2: 00007fd416bee290 CR3: 000000001953e000 CR4: 00000000000006f0
[  163.696385] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  163.696385] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  163.696385] Process blkid (pid: 1380, threadinfo ffff880019532000, task ffff880019f7c6e0)
[  163.696385] Stack:
[  163.696385]  0000000000000000 ffff88001b4b4fd8 ffff880019533a48 ffffffff812f8891
[  163.696385]  ffff880019533a28 ffffffff00000001 ffffffff00000001 0000001900000000
[  163.696385]  0000000200000000 ffff88001cedf180 ffff88001b4b4fd8 ffff88001bb2d500
[  163.696385] Call Trace:
[  163.696385]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  163.696385]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  163.696385]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  163.696385]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  163.696385]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  163.696385]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  163.696385]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  163.696385]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  163.696385]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  163.696385]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  163.696385]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  163.696385]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  163.696385]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  163.696385]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  163.696385]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  163.696385]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  163.696385]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  163.696385] Code: 08 00 00 00 00 48 89 fe 48 c7 43 10 00 00 00 00 48 89 df 48 89 1a e8 1e 95 00 00 8b 43 38 8b 4b 24 31 d2 ff 43 20 01 c1 c1 e0 0c <f7> f1 89 4b 24 b9 01 00 00 00 85 c0 0f 45 c8 89 4b 28 41 59 5b 
[  163.696385] RIP  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  163.696385]  RSP <ffff8800195339d8>
[  163.696385] ---[ end trace 597483f2065d40d3 ]---
[  163.696385] note: blkid[1380] exited with preempt_count 1
[  163.741137] BUG: scheduling while atomic: blkid/1380/0x10000002
[  163.741972] INFO: lockdep is turned off.
[  163.743236] Modules linked in:
[  163.743802] Pid: 1380, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  163.745298] Call Trace:
[  163.745779]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  163.746649]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  163.747487]  [<ffffffff813041c1>] ? number.isra.1+0x128/0x238
[  163.748694]  [<ffffffff810fa0ad>] ? unmap_page_range+0x29b/0x6af
[  163.749645]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  163.750512]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  163.751363]  [<ffffffff810fa392>] unmap_page_range+0x580/0x6af
[  163.752575]  [<ffffffff810fa589>] unmap_single_vma+0xc8/0xd3
[  163.753482]  [<ffffffff810e4461>] ? __pagevec_lru_add+0x1e/0x20
[  163.754393]  [<ffffffff810fac02>] unmap_vmas+0x32/0x49
[  163.755201]  [<ffffffff81100cd9>] exit_mmap+0x94/0x122
[  163.755973]  [<ffffffff810334b5>] mmput+0x5e/0xbe
[  163.757050]  [<ffffffff8103a7b0>] do_exit+0x2f4/0x8f6
[  163.757871]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  163.758712]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  163.759551]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  163.760649]  [<ffffffff8100532f>] die+0x5a/0x63
[  163.761483]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  163.762291]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  163.763131]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.764502]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  163.765512]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  163.766493]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  163.767355]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  163.768496]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.769538]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  163.770532]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  163.771471]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  163.772634]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  163.773557]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  163.774343]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  163.775232]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  163.776466]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  163.777364]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  163.778343]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  163.779353]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  163.780630]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  163.781621]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  163.782576]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  163.783447]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  163.784598]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  163.785430]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  163.786214]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  163.873219] divide error: 0000 [#6] SMP DEBUG_PAGEALLOC
[  163.874346] Modules linked in:
[  163.874865] CPU 0 
[  163.875250] Pid: 1379, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177 Bochs Bochs
[  163.876547] RIP: 0010:[<ffffffff812f7ec9>]  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  163.876547] RSP: 0018:ffff8800194d79d8  EFLAGS: 00000046
[  163.876547] RAX: 0000000000000000 RBX: ffff88001b4b64f8 RCX: 0000000000000000
[  163.876547] RDX: 0000000000000000 RSI: ffff88001b4b5528 RDI: ffff88001b4b64f8
[  163.876547] RBP: ffff8800194d79e8 R08: 0000000000000001 R09: 0000000000000000
[  163.876547] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88001b4b64f8
[  163.876547] R13: ffff88001b4b5528 R14: 00000000ffff7afc R15: ffff88001b4b65d0
[  163.876547] FS:  00007fab9e93d740(0000) GS:ffff88001f200000(0000) knlGS:0000000000000000
[  163.876547] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  163.876547] CR2: 00007fab9e52e290 CR3: 000000001948a000 CR4: 00000000000006f0
[  163.876547] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  163.876547] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  163.876547] Process blkid (pid: 1379, threadinfo ffff8800194d6000, task ffff880019f78000)
[  163.876547] Stack:
[  163.876547]  0000000000000000 ffff88001b4b5520 ffff8800194d7a48 ffffffff812f8891
[  163.876547]  ffff8800194d7a28 ffffffff00000001 ffffffff00000001 0000001900000000
[  163.876547]  0000000200000000 ffff88001ceded20 ffff88001b4b5520 ffff88001bb2cd20
[  163.876547] Call Trace:
[  163.876547]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  163.876547]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  163.876547]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  163.876547]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  163.876547]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  163.876547]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  163.876547]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  163.876547]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  163.876547]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  163.876547]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  163.876547]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  163.876547]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  163.876547]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  163.876547]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  163.876547]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  163.876547]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  163.876547]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  163.876547] Code: 08 00 00 00 00 48 89 fe 48 c7 43 10 00 00 00 00 48 89 df 48 89 1a e8 1e 95 00 00 8b 43 38 8b 4b 24 31 d2 ff 43 20 01 c1 c1 e0 0c <f7> f1 89 4b 24 b9 01 00 00 00 85 c0 0f 45 c8 89 4b 28 41 59 5b 
[  163.876547] RIP  [<ffffffff812f7ec9>] cfq_group_service_tree_add+0xae/0xc5
[  163.876547]  RSP <ffff8800194d79d8>
[  163.876547] ---[ end trace 597483f2065d40d4 ]---
[  163.876547] note: blkid[1379] exited with preempt_count 1
[  163.921361] BUG: scheduling while atomic: blkid/1379/0x10000002
[  163.922231] INFO: lockdep is turned off.
[  163.922809] Modules linked in:
[  163.923429] Pid: 1379, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  163.924831] Call Trace:
[  163.925386]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  163.926236]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  163.927021]  [<ffffffff813041c1>] ? number.isra.1+0x128/0x238
[  163.927904]  [<ffffffff810fa0ad>] ? unmap_page_range+0x29b/0x6af
[  163.929221]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  163.930065]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  163.930907]  [<ffffffff810fa392>] unmap_page_range+0x580/0x6af
[  163.931821]  [<ffffffff810fa589>] unmap_single_vma+0xc8/0xd3
[  163.933028]  [<ffffffff810e4461>] ? __pagevec_lru_add+0x1e/0x20
[  163.933950]  [<ffffffff810fac02>] unmap_vmas+0x32/0x49
[  163.934823]  [<ffffffff81100cd9>] exit_mmap+0x94/0x122
[  163.935656]  [<ffffffff810334b5>] mmput+0x5e/0xbe
[  163.936742]  [<ffffffff8103a7b0>] do_exit+0x2f4/0x8f6
[  163.937578]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  163.938422]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  163.939249]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  163.939995]  [<ffffffff8100532f>] die+0x5a/0x63
[  163.941208]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  163.942001]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  163.942875]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.943882]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  163.945257]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  163.946254]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  163.947101]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  163.947917]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  163.949317]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  163.950339]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  163.951266]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  163.952428]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  163.953359]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  163.954125]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  163.954981]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  163.955916]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  163.957200]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  163.958199]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  163.959213]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  163.960521]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  163.961514]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  163.962484]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  163.963389]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  163.964558]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  163.965398]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  163.966199]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  165.211434] BUG: sleeping function called from invalid context at /c/kernel-tests/src/stable/mm/memory.c:1255
[  165.218652] in_atomic(): 1, irqs_disabled(): 0, pid: 1369, name: blkid
[  165.219710] INFO: lockdep is turned off.
[  165.220956] Pid: 1369, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  165.222107] Call Trace:
[  165.222638]  [<ffffffff810632f3>] __might_sleep+0x107/0x10b
[  165.223541]  [<ffffffff810fa389>] unmap_page_range+0x577/0x6af
[  165.224844]  [<ffffffff810fa589>] unmap_single_vma+0xc8/0xd3
[  165.225770]  [<ffffffff810e4461>] ? __pagevec_lru_add+0x1e/0x20
[  165.226704]  [<ffffffff810fac02>] unmap_vmas+0x32/0x49
[  165.227560]  [<ffffffff81100cd9>] exit_mmap+0x94/0x122
[  165.228837]  [<ffffffff810334b5>] mmput+0x5e/0xbe
[  165.229652]  [<ffffffff8103a7b0>] do_exit+0x2f4/0x8f6
[  165.230499]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  165.231369]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  165.232618]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  165.233469]  [<ffffffff8100532f>] die+0x5a/0x63
[  165.234239]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  165.235069]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  165.235932]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  165.237428]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  165.238477]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  165.239488]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  165.240761]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  165.241653]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  165.242677]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  165.243722]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  165.245153]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  165.246063]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  165.247616]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  165.248838]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  165.249807]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  165.250766]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  165.251660]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  165.253118]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  165.254180]  [<ffffffff817ef7b3>] ? retint_restore_args+0x13/0x13
[  165.255164]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  165.256480]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  165.257519]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  165.258527]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  165.259505]  [<ffffffff81085b60>] ? save_trace+0x3d/0xaf
[  165.260794]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  165.261723]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  165.262603]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  165.263430]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  165.264647]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  165.265610] BUG: scheduling while atomic: blkid/1369/0x10000002
[  165.266485] INFO: lockdep is turned off.
[  165.267124] Modules linked in:
[  165.267722] Pid: 1369, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  165.269334] Call Trace:
[  165.269858]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  165.270756]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  165.271619]  [<ffffffff81005297>] ? show_trace_log_lvl+0x54/0x5d
[  165.272966]  [<ffffffff810052b5>] ? show_trace+0x15/0x17
[  165.273824]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  165.274714]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  165.275599]  [<ffffffff810fa392>] unmap_page_range+0x580/0x6af
[  165.276971]  [<ffffffff810fa589>] unmap_single_vma+0xc8/0xd3
[  165.277863]  [<ffffffff810e4461>] ? __pagevec_lru_add+0x1e/0x20
[  165.278806]  [<ffffffff810fac02>] unmap_vmas+0x32/0x49
[  165.279653]  [<ffffffff81100cd9>] exit_mmap+0x94/0x122
[  165.280924]  [<ffffffff810334b5>] mmput+0x5e/0xbe
[  165.281726]  [<ffffffff8103a7b0>] do_exit+0x2f4/0x8f6
[  165.282560]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  165.283420]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  165.284683]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  165.285537]  [<ffffffff8100532f>] die+0x5a/0x63
[  165.286314]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  165.287145]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  165.288139]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  165.289511]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  165.290558]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  165.291575]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  165.292852]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  165.293790]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  165.294811]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  165.295838]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  165.297266]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  165.298184]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  165.299116]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  165.299874]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  165.301261]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  165.302251]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  165.303146]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  165.304546]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  165.305599]  [<ffffffff817ef7b3>] ? retint_restore_args+0x13/0x13
[  165.306566]  [<ffffffff81085789>] ? trace_hardirqs_off+0xd/0xf
[  165.307498]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  165.308947]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  165.309972]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  165.310935]  [<ffffffff81085b60>] ? save_trace+0x3d/0xaf
[  165.311782]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  165.313161]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  165.314067]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  165.314852]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  165.315690]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  165.510062] BUG: scheduling while atomic: blkid/1380/0x10000002
[  165.511070] INFO: lockdep is turned off.
[  165.511674] Modules linked in:
[  165.512684] Pid: 1380, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  165.513772] Call Trace:
[  165.514321]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  165.515166]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  165.515952]  [<ffffffff8108a327>] ? trace_hardirqs_on+0xd/0xf
[  165.517222]  [<ffffffff817e1dac>] ? __slab_free+0x350/0x3b7
[  165.518084]  [<ffffffff811342e8>] ? put_files_struct+0x27/0x172
[  165.518952]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  165.519803]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  165.520976]  [<ffffffff8113439b>] put_files_struct+0xda/0x172
[  165.521875]  [<ffffffff811342e8>] ? put_files_struct+0x27/0x172
[  165.522779]  [<ffffffff811344ce>] exit_files+0x49/0x52
[  165.523595]  [<ffffffff8103a80a>] do_exit+0x34e/0x8f6
[  165.524718]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  165.525568]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  165.526408]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  165.527186]  [<ffffffff8100532f>] die+0x5a/0x63
[  165.527883]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  165.529034]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  165.529909]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  165.530900]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  165.531879]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  165.533240]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  165.534086]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  165.534888]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  165.535876]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  165.537243]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  165.538177]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  165.538978]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  165.539879]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  165.540989]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  165.541915]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  165.542822]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  165.543687]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  165.544987]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  165.546011]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  165.546983]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  165.547987]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  165.549319]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  165.550195]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  165.550987]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  165.551786]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  165.552908]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b
[  165.852794] BUG: scheduling while atomic: blkid/1378/0x10000002
[  165.853798] INFO: lockdep is turned off.
[  165.854428] Modules linked in:
[  165.854995] Pid: 1378, comm: blkid Tainted: G      D W    3.7.0-03735-g945010d #4177
[  165.856441] Call Trace:
[  165.856947]  [<ffffffff817de886>] __schedule_bug+0x68/0x76
[  165.857819]  [<ffffffff817ed376>] __schedule+0xb0/0x881
[  165.858657]  [<ffffffff8105f03e>] ? lg_local_unlock+0x20/0x42
[  165.859547]  [<ffffffff81135f77>] ? mntput_no_expire+0x3f/0x11b
[  165.860755]  [<ffffffff81136080>] ? mntput+0x2d/0x2f
[  165.861580]  [<ffffffff81064821>] __cond_resched+0x27/0x32
[  165.862439]  [<ffffffff817edbc0>] _cond_resched+0x2e/0x35
[  165.863270]  [<ffffffff810519d6>] task_work_run+0x96/0xac
[  165.864420]  [<ffffffff8103a817>] do_exit+0x35b/0x8f6
[  165.865230]  [<ffffffff81038919>] ? kmsg_dump+0xef/0x107
[  165.866009]  [<ffffffff8103884f>] ? kmsg_dump+0x25/0x107
[  165.866846]  [<ffffffff817f0554>] oops_end+0xaf/0xb8
[  165.867638]  [<ffffffff8100532f>] die+0x5a/0x63
[  165.868682]  [<ffffffff817efef5>] do_trap+0x6e/0x13a
[  165.869505]  [<ffffffff81002a6b>] do_divide_error+0x9b/0xa4
[  165.870368]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  165.871357]  [<ffffffff810856fb>] ? trace_hardirqs_off_caller+0x1f/0xa0
[  165.872629]  [<ffffffff813072ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  165.873622]  [<ffffffff817ef7e3>] ? restore_args+0x30/0x30
[  165.874481]  [<ffffffff817f7a5e>] divide_error+0x1e/0x30
[  165.875326]  [<ffffffff812f7ec9>] ? cfq_group_service_tree_add+0xae/0xc5
[  165.876613]  [<ffffffff812f7eb9>] ? cfq_group_service_tree_add+0x9e/0xc5
[  165.877619]  [<ffffffff812f8891>] cfq_service_tree_add+0x25d/0x26c
[  165.878555]  [<ffffffff812fab55>] cfq_add_rq_rb+0xdc/0x12b
[  165.879411]  [<ffffffff812fac72>] cfq_insert_request+0xce/0x50f
[  165.880597]  [<ffffffff81149fad>] ? I_BDEV+0xd/0xd
[  165.881399]  [<ffffffff812e1f64>] __elv_add_request+0x193/0x204
[  165.882305]  [<ffffffff812e88f8>] blk_flush_plug_list+0x187/0x1e2
[  165.883214]  [<ffffffff812e8968>] blk_finish_plug+0x15/0x36
[  165.884140]  [<ffffffff810e3312>] __do_page_cache_readahead+0x22d/0x24f
[  165.885362]  [<ffffffff810e3189>] ? __do_page_cache_readahead+0xa4/0x24f
[  165.886377]  [<ffffffff810e3514>] force_page_cache_readahead+0x6a/0x97
[  165.887347]  [<ffffffff810e38cc>] page_cache_sync_readahead+0x2e/0x42
[  165.888592]  [<ffffffff810db3b4>] generic_file_aio_read+0x276/0x650
[  165.889559]  [<ffffffff8114a158>] blkdev_aio_read+0x5f/0x66
[  165.890422]  [<ffffffff8111c68c>] do_sync_read+0x96/0xd6
[  165.891254]  [<ffffffff8111cc74>] vfs_read+0xa3/0x12f
[  165.892012]  [<ffffffff8111cd4c>] sys_read+0x4c/0x80
[  165.893139]  [<ffffffff817f6999>] system_call_fastpath+0x16/0x1b

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.7.0-03735-g945010d"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.7.0 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_GENERIC_KERNEL_THREAD=y
CONFIG_GENERIC_KERNEL_EXECVE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_OMAP_OCP2SCP is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_HPT366=y
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
CONFIG_BLK_DEV_IT821X=y
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_ZNET is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_SEEQ8005 is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_FAIR_SHARE is not set
CONFIG_STEP_WISE=y
# CONFIG_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
CONFIG_LPC_ICH=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set

#
# USB Physical Layer drivers
#
# CONFIG_OMAP_USB2 is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD64 is not set
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
# CONFIG_NFS_V4_1 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_VHOST_NET is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--7AUc2qLy4jB3hD7Z--
