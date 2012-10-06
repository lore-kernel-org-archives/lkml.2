Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2JFNQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 09:16:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:52642 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab2JFNQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 09:16:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,543,1344236400"; 
   d="scan'208";a="230717363"
Date: Sat, 6 Oct 2012 21:16:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: cgroup.h:566 suspicious rcu_dereference_check() usage!
Message-ID: <20121006131607.GA12798@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Aristeu,

I got the below warning in linus/master and linux-next, and it's
bisected down to:

commit ad676077a2ae4af4bb6627486ce19ccce04f1efe
Author: Aristeu Rozanski <aris@redhat.com>
Date:   Thu Oct 4 17:15:17 2012 -0700

    device_cgroup: convert device_cgroup internally to policy + exceptions


[    0.721405] 
[    0.721765] ===============================
[    0.722637] [ INFO: suspicious RCU usage. ]
[    0.723480] 3.6.0-03071-g283dbd8 #2 Not tainted
[    0.724562] -------------------------------
[    0.725481] /c/kernel-tests/src/tip/include/linux/cgroup.h:566 suspicious rcu_dereference_check() usage!
[    0.727399] 
[    0.727399] other info that might help us debug this:
[    0.727399] 
[    0.729131] 
[    0.729131] rcu_scheduler_active = 1, debug_locks = 1
[    0.730473] 2 locks held by swapper/0/1:
[    0.731337]  #0:  (sb_writers){.+.+.+}, at: [<ffffffff8112b5a3>] sb_start_write+0x1a/0x23
[    0.733062]  #1:  (&sb->s_type->i_mutex_key#2/1){+.+.+.}, at: [<ffffffff81118c0e>] kern_path_create+0xa1/0x1be
[    0.735330] 
[    0.735330] stack backtrace:
[    0.736199] Pid: 1, comm: swapper/0 Not tainted 3.6.0-03071-g283dbd8 #2
[    0.737618] Call Trace:
[    0.738187]  [<ffffffff81084896>] lockdep_rcu_suspicious+0x15a/0x16a
[    0.739489]  [<ffffffff8115c43f>] task_devcgroup+0xb9/0xcf
[    0.740645]  [<ffffffff8115cad5>] devcgroup_inode_mknod+0x21/0x8c
[    0.741926]  [<ffffffff81115a73>] vfs_mknod+0x98/0xf4
[    0.742635]  [<ffffffff81118d96>] ? user_path_create+0x6b/0x7d
[    0.743460]  [<ffffffff81119856>] sys_mknodat+0x17d/0x1db
[    0.744199]  [<ffffffff811198d3>] sys_mknod+0x1f/0x28
[    0.744931]  [<ffffffff815ebca8>] do_name+0x31a/0x37f
[    0.745603]  [<ffffffff815eac7e>] write_buffer+0x29/0x49
[    0.746312]  [<ffffffff815eb5e1>] unpack_to_rootfs+0x111/0x331
[    0.747091]  [<ffffffff815eb801>] ? unpack_to_rootfs+0x331/0x331
[    0.747938]  [<ffffffff815eb820>] populate_rootfs+0x1f/0x18d
[    0.748729]  [<ffffffff8100026c>] do_one_initcall+0xb6/0x1d2
[    0.749514]  [<ffffffff815ea2c6>] kernel_init+0x1de/0x2cf
[    0.750566]  [<ffffffff815e964e>] ? loglevel+0x46/0x46
[    0.751607]  [<ffffffff81298704>] kernel_thread_helper+0x4/0x10
[    0.752921]  [<ffffffff81296d74>] ? retint_restore_args+0x13/0x13
[    0.753838]  [<ffffffff815ea0e8>] ? start_kernel+0x651/0x651
[    0.754657]  [<ffffffff81298700>] ? gs_change+0x13/0x13
[    0.755558] Unpacking initramfs...
[    2.348617] Freeing initrd memory: 23656k freed

Thanks,
Fengguang

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-kbuild-36371-2012-10-06-16-06-05-3.6.0-03071-g283dbd8-2"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-03071-g283dbd8 (kbuild@snb) (gcc version 4.7.1 (Debian 4.7.1-6) ) #2 SMP PREEMPT Sat Oct 6 16:05:59 CST 2012
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=nfs/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-10-06-16-06-42-nfs:master:5f3d2f2-283dbd8-x86_64-randconfig-s057-2-kbuild BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s057/283dbd8/vmlinuz-3.6.0-03071-g283dbd8
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127884(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:15e7f41, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00010000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000]   DMA32 zone: 896 pages used for memmap
[    0.000000]   DMA32 zone: 6 pages reserved
[    0.000000]   DMA32 zone: 64507 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000de00000 s72768 r8192 d21440 u1048576
[    0.000000] pcpu-alloc: s72768 r8192 d21440 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] kvm-clock: cpu 0, msr 0:de10f41, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de0cf40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64507
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=nfs/master log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-10-06-16-06-42-nfs:master:5f3d2f2-283dbd8-x86_64-randconfig-s057-2-kbuild BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s057/283dbd8/vmlinuz-3.6.0-03071-g283dbd8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 208716k/262136k available (2659k kernel code, 500k absent, 52920k reserved, 3308k data, 488k init)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.352 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.006666] Calibrating delay loop (skipped) preset value.. 5388.15 BogoMIPS (lpj=8977840)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006789] Mount-cache hash table entries: 256
[    0.009125] Initializing cgroup subsys devices
[    0.010026] Initializing cgroup subsys perf_event
[    0.011229] mce: CPU supports 10 MCE banks
[    0.012090] mce: unknown CPU type - not enabling MCE support
[    0.013359] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013359] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013359] tlb_flushall_shift: -1
[    0.016866] Freeing SMP alternatives: 4k freed
[    0.020186] ACPI: Core revision 20120711
[    0.028519] Getting VERSION: 50014
[    0.029245] Getting VERSION: 50014
[    0.029860] Getting ID: 0
[    0.030029] Getting ID: ff000000
[    0.030726] Getting LVT0: 8700
[    0.031352] Getting LVT1: 8400
[    0.033429] enabled ExtINT on CPU#0
[    0.035382] ENABLING IO-APIC IRQs
[    0.036104] init IO_APIC IRQs
[    0.036688]  apic 2 pin 0 not connected
[    0.037480] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.039201] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.040062] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.041629] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.043392] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.044960] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.046727] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.048301] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.050064] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.053385] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.054996] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.056726] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.058432] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.060064] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.061652] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.063380]  apic 2 pin 16 not connected
[    0.064172]  apic 2 pin 17 not connected
[    0.064927]  apic 2 pin 18 not connected
[    0.066680]  apic 2 pin 19 not connected
[    0.067420]  apic 2 pin 20 not connected
[    0.068120]  apic 2 pin 21 not connected
[    0.068839]  apic 2 pin 22 not connected
[    0.069583]  apic 2 pin 23 not connected
[    0.070191] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.073345] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.075800] Using local APIC timer interrupts.
[    0.075800] calibrating APIC timer ...
[    0.079995] ... lapic delta = 6142657
[    0.079995] ... PM-Timer delta = 351838
[    0.079995] APIC calibration not consistent with PM-Timer: 98ms instead of 100ms
[    0.079995] APIC delta adjusted to PM-Timer: 6249434 (6142657)
[    0.079995] TSC delta adjusted to PM-Timer: 269354749 (264752556)
[    0.079995] ..... delta 6249434
[    0.079995] ..... mult: 268428648
[    0.079995] ..... calibration result: 3333031
[    0.079995] ..... CPU clock speed is 2693.2722 MHz.
[    0.079995] ..... host bus clock speed is 1000.0031 MHz.
[    0.080138] Performance Events: [    0.100805] NMI watchdog: disabled (cpu0): hardware events not enabled

[    0.107111] SMP alternatives: lockdep: fixing up alternatives
[    0.108851] smpboot: Booting Node   0, Processors  #1 OK
[    0.006666] kvm-clock: cpu 1, msr 0:df10f41, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.123604] Brought up 2 CPUs
[    0.123515] KVM setup async PF for cpu 1
[    0.123515] kvm-stealtime: cpu 1, msr df0cf40
[    0.125941] ----------------
[    0.126581] | NMI testsuite:
[    0.126670] --------------------
[    0.127559]   remote IPI:  ok  |
[    0.143780]    local IPI:  ok  |
[    0.176699] --------------------
[    0.177651] Good, all   2 testcases passed! |
[    0.178770] ---------------------------------
[    0.179709] smpboot: Total of 2 processors activated (10777.30 BogoMIPS)
[    0.181570] device: 'platform': device_add
[    0.183567] bus: 'platform': registered
[    0.184448] bus: 'cpu': registered
[    0.185187] device: 'cpu': device_add
[    0.187121] device class 'regulator': registering
[    0.188632] Registering platform device 'reg-dummy'. Parent at platform
[    0.190003] device: 'reg-dummy': device_add
[    0.190833] bus: 'platform': add device reg-dummy
[    0.191979] bus: 'platform': add driver reg-dummy
[    0.192955] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.193371] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.195165] device: 'regulator.0': device_add
[    0.197175] regulator-dummy: no parameters
[    0.198181] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.200114] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.202272] NET: Registered protocol family 16
[    0.203539] device class 'bdi': registering
[    0.204570] device class 'pci_bus': registering
[    0.205562] bus: 'pci': registered
[    0.206230] device class 'tty': registering
[    0.207067] ACPI: bus type pci registered
[    0.207834] device class 'dma': registering
[    0.208656] device class 'dmi': registering
[    0.210039] device: 'id': device_add
[    0.211195] PCI: Using configuration type 1 for base access
[    0.212564] device: 'cpu0': device_add
[    0.213352] bus: 'cpu': add device cpu0
[    0.214398] device: 'cpu1': device_add
[    0.215311] bus: 'cpu': add device cpu1
[    0.217992] device: 'default': device_add
[    0.220216] ACPI: Added _OSI(Module Device)
[    0.221319] ACPI: Added _OSI(Processor Device)
[    0.222323] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.223341] ACPI: Added _OSI(Processor Aggregator Device)
[    0.227764] ACPI: EC: Look up EC in DSDT
[    0.240870] ACPI: Interpreter enabled
[    0.241783] ACPI: (supports S0 S5)
[    0.242661] ACPI: Using IOAPIC for interrupt routing
[    0.243419] bus: 'acpi': registered
[    0.244190] bus: 'acpi': add driver power
[    0.245269] device: 'LNXSYSTM:00': device_add
[    0.246742] bus: 'acpi': add device LNXSYSTM:00
[    0.248012] device: 'device:00': device_add
[    0.248883] bus: 'acpi': add device device:00
[    0.250073] device: 'PNP0A03:00': device_add
[    0.251006] bus: 'acpi': add device PNP0A03:00
[    0.253268] device: 'device:01': device_add
[    0.253351] bus: 'acpi': add device device:01
[    0.254423] device: 'device:02': device_add
[    0.255210] bus: 'acpi': add device device:02
[    0.256852] device: 'PNP0B00:00': device_add
[    0.257755] bus: 'acpi': add device PNP0B00:00
[    0.259061] device: 'PNP0303:00': device_add
[    0.260020] bus: 'acpi': add device PNP0303:00
[    0.261294] device: 'PNP0F13:00': device_add
[    0.262281] bus: 'acpi': add device PNP0F13:00
[    0.263685] device: 'PNP0700:00': device_add
[    0.264645] bus: 'acpi': add device PNP0700:00
[    0.266214] device: 'PNP0400:00': device_add
[    0.266687] bus: 'acpi': add device PNP0400:00
[    0.268239] device: 'PNP0501:00': device_add
[    0.270018] bus: 'acpi': add device PNP0501:00
[    0.271521] device: 'device:03': device_add
[    0.272439] bus: 'acpi': add device device:03
[    0.273602] device: 'device:04': device_add
[    0.274476] bus: 'acpi': add device device:04
[    0.275675] device: 'device:05': device_add
[    0.276683] bus: 'acpi': add device device:05
[    0.277887] device: 'device:06': device_add
[    0.278863] bus: 'acpi': add device device:06
[    0.280329] device: 'device:07': device_add
[    0.281335] bus: 'acpi': add device device:07
[    0.282522] device: 'device:08': device_add
[    0.283343] bus: 'acpi': add device device:08
[    0.284591] device: 'device:09': device_add
[    0.285681] bus: 'acpi': add device device:09
[    0.286923] device: 'device:0a': device_add
[    0.287868] bus: 'acpi': add device device:0a
[    0.289165] device: 'device:0b': device_add
[    0.290022] bus: 'acpi': add device device:0b
[    0.291302] device: 'device:0c': device_add
[    0.292275] bus: 'acpi': add device device:0c
[    0.293622] device: 'device:0d': device_add
[    0.294518] bus: 'acpi': add device device:0d
[    0.295748] device: 'device:0e': device_add
[    0.296679] bus: 'acpi': add device device:0e
[    0.297854] device: 'device:0f': device_add
[    0.298741] bus: 'acpi': add device device:0f
[    0.300106] device: 'device:10': device_add
[    0.300937] bus: 'acpi': add device device:10
[    0.301980] device: 'device:11': device_add
[    0.302774] bus: 'acpi': add device device:11
[    0.303567] device: 'device:12': device_add
[    0.304746] bus: 'acpi': add device device:12
[    0.305900] device: 'device:13': device_add
[    0.306685] bus: 'acpi': add device device:13
[    0.307714] device: 'device:14': device_add
[    0.308571] bus: 'acpi': add device device:14
[    0.309637] device: 'device:15': device_add
[    0.310018] bus: 'acpi': add device device:15
[    0.311186] device: 'device:16': device_add
[    0.312139] bus: 'acpi': add device device:16
[    0.313600] device: 'device:17': device_add
[    0.314551] bus: 'acpi': add device device:17
[    0.315854] device: 'device:18': device_add
[    0.316683] bus: 'acpi': add device device:18
[    0.317806] device: 'device:19': device_add
[    0.318617] bus: 'acpi': add device device:19
[    0.320262] device: 'device:1a': device_add
[    0.321064] bus: 'acpi': add device device:1a
[    0.322308] device: 'device:1b': device_add
[    0.323349] bus: 'acpi': add device device:1b
[    0.324576] device: 'device:1c': device_add
[    0.325473] bus: 'acpi': add device device:1c
[    0.326782] device: 'device:1d': device_add
[    0.327580] bus: 'acpi': add device device:1d
[    0.328693] device: 'device:1e': device_add
[    0.329570] bus: 'acpi': add device device:1e
[    0.330252] device: 'device:1f': device_add
[    0.331171] bus: 'acpi': add device device:1f
[    0.332483] device: 'device:20': device_add
[    0.333350] bus: 'acpi': add device device:20
[    0.334541] device: 'device:21': device_add
[    0.335372] bus: 'acpi': add device device:21
[    0.336980] device: 'device:22': device_add
[    0.338428] bus: 'acpi': add device device:22
[    0.340804] device: 'PNP0103:00': device_add
[    0.341787] bus: 'acpi': add device PNP0103:00
[    0.343410] device: 'PNP0C0F:00': device_add
[    0.344346] bus: 'acpi': add device PNP0C0F:00
[    0.345854] device: 'PNP0C0F:01': device_add
[    0.346675] bus: 'acpi': add device PNP0C0F:01
[    0.348044] device: 'PNP0C0F:02': device_add
[    0.348857] bus: 'acpi': add device PNP0C0F:02
[    0.350277] device: 'PNP0C0F:03': device_add
[    0.351069] bus: 'acpi': add device PNP0C0F:03
[    0.353420] device: 'PNP0C0F:04': device_add
[    0.354264] bus: 'acpi': add device PNP0C0F:04
[    0.355539] device: 'LNXCPU:00': device_add
[    0.356486] bus: 'acpi': add device LNXCPU:00
[    0.357105] device: 'LNXCPU:01': device_add
[    0.357987] bus: 'acpi': add device LNXCPU:01
[    0.359181] device: 'device:23': device_add
[    0.360008] bus: 'acpi': add device device:23
[    0.360973] device: 'LNXPWRBN:00': device_add
[    0.361928] bus: 'acpi': add device LNXPWRBN:00
[    0.363754] bus: 'acpi': add driver ec
[    0.364651] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.366660] bus: 'acpi': add driver pci_root
[    0.367584] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    0.369330] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    0.370171] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.371654] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.373331] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.374794] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.376672] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.378319] PCI: root bus 00: using default resources
[    0.380014] device: 'pci0000:00': device_add
[    0.381094] device: '0000:00': device_add
[    0.383338] PCI host bridge to bus 0000:00
[    0.384162] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.385260] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.386491] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.386877] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.390093] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.392531] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.396661] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.399102] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.400672] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.402092] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.403591] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.407399] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.411765] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.419687] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.420314] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.423810] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.426130] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.432076] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.433626] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.436432] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.437788] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.444993] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.447117] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.449248] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.456066] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.457889] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.461045] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.467465] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.469990] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.472276] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.478335] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.480441] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.482433] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.488362] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.490344] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.491854] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.498481] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.500635] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.505447] pci_bus 0000:00: on NUMA node 0
[    0.506649] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.512625]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.513367] device: '0000:00:00.0': device_add
[    0.520568] bus: 'pci': add device 0000:00:00.0
[    0.522207] device: '0000:00:01.0': device_add
[    0.525565] bus: 'pci': add device 0000:00:01.0
[    0.526759] device: '0000:00:01.1': device_add
[    0.530414] bus: 'pci': add device 0000:00:01.1
[    0.531548] device: '0000:00:01.3': device_add
[    0.535251] bus: 'pci': add device 0000:00:01.3
[    0.536683] device: '0000:00:02.0': device_add
[    0.540494] bus: 'pci': add device 0000:00:02.0
[    0.541861] device: '0000:00:03.0': device_add
[    0.545570] bus: 'pci': add device 0000:00:03.0
[    0.546856] device: '0000:00:04.0': device_add
[    0.550746] bus: 'pci': add device 0000:00:04.0
[    0.552022] device: '0000:00:05.0': device_add
[    0.555594] bus: 'pci': add device 0000:00:05.0
[    0.556762] device: '0000:00:06.0': device_add
[    0.560309] bus: 'pci': add device 0000:00:06.0
[    0.561501] device: '0000:00:07.0': device_add
[    0.564921] bus: 'pci': add device 0000:00:07.0
[    0.566272] device: '0000:00:08.0': device_add
[    0.570193] bus: 'pci': add device 0000:00:08.0
[    0.571296] device: '0000:00:09.0': device_add
[    0.575002] bus: 'pci': add device 0000:00:09.0
[    0.576369] device: '0000:00:0a.0': device_add
[    0.580406] bus: 'pci': add device 0000:00:0a.0
[    0.581534] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    0.582804] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    0.583510] bus: 'acpi': add driver pci_link
[    0.584547] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    0.586647] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    0.588902] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.590546] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    0.591912] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    0.593322] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    0.595085] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    0.596973] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.598469] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    0.599987] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    0.601697] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    0.603313] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    0.606648] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.608133] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    0.609523] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    0.609982] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    0.611144] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    0.613642] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.615197] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    0.616583] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    0.616655] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    0.618338] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    0.620249] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.621157] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    0.623313] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    0.624707] bus: 'pnp': registered
[    0.625227] device class 'misc': registering
[    0.625939] device: 'vga_arbiter': device_add
[    0.626908] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.628028] vgaarb: loaded
[    0.628409] vgaarb: bridge control possible 0000:00:02.0
[    0.629638] bus: 'serio': registered
[    0.629982] device class 'input': registering
[    0.630636] device class 'power_supply': registering
[    0.631344] device class 'devfreq': registering
[    0.632043] PCI: Using ACPI for IRQ routing
[    0.632642] PCI: pci_cache_line_size set to 64 bytes
[    0.633661] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.634526] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.635424] device class 'net': registering
[    0.636834] device: 'lo': device_add
[    0.638232] Switching to clocksource kvm-clock
[    0.639574] bus: 'pnp': add driver system
[    0.639574] pnp: PnP ACPI init
[    0.639574] device: 'pnp0': device_add
[    0.639875] ACPI: bus type pnp registered
[    0.640906] pnp 00:00: [bus 00-ff]
[    0.641663] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.642508] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.643524] pnp 00:00: [io  0x0d00-0xffff window]
[    0.644514] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.645400] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.646165] device: '00:00': device_add
[    0.646820] bus: 'pnp': add device 00:00
[    0.647495] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.648479] pnp 00:01: [io  0x0070-0x0071]
[    0.649100] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.650389] pnp 00:01: [irq 8]
[    0.651010] pnp 00:01: [io  0x0072-0x0077]
[    0.651789] device: '00:01': device_add
[    0.652556] bus: 'pnp': add device 00:01
[    0.653525] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.655044] pnp 00:02: [io  0x0060]
[    0.655748] pnp 00:02: [io  0x0064]
[    0.656510] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.658154] pnp 00:02: [irq 1]
[    0.658758] device: '00:02': device_add
[    0.659532] bus: 'pnp': add device 00:02
[    0.660526] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.662048] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.663694] pnp 00:03: [irq 12]
[    0.664379] device: '00:03': device_add
[    0.665217] bus: 'pnp': add device 00:03
[    0.666060] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.667472] pnp 00:04: [io  0x03f2-0x03f5]
[    0.668280] pnp 00:04: [io  0x03f7]
[    0.668951] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.670480] pnp 00:04: [irq 6]
[    0.671100] pnp 00:04: [dma 2]
[    0.671692] device: '00:04': device_add
[    0.672488] bus: 'pnp': add device 00:04
[    0.673325] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.674865] pnp 00:05: [io  0x0378-0x037f]
[    0.675640] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.677109] pnp 00:05: [irq 7]
[    0.677568] device: '00:05': device_add
[    0.678152] bus: 'pnp': add device 00:05
[    0.678799] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.679948] pnp 00:06: [io  0x03f8-0x03ff]
[    0.680963] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.682839] pnp 00:06: [irq 4]
[    0.683563] device: '00:06': device_add
[    0.684511] bus: 'pnp': add device 00:06
[    0.685460] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.687835] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.688642] device: '00:07': device_add
[    0.689291] bus: 'pnp': add device 00:07
[    0.690025] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.692266] pnp: PnP ACPI: found 8 devices
[    0.693184] ACPI: ACPI bus type pnp unregistered
[    0.694128] device class 'mem': registering
[    0.695054] device: 'mem': device_add
[    0.696075] device: 'null': device_add
[    0.697040] device: 'port': device_add
[    0.698010] device: 'zero': device_add
[    0.698852] device: 'full': device_add
[    0.699758] device: 'random': device_add
[    0.700675] device: 'urandom': device_add
[    0.701720] device: 'kmsg': device_add
[    0.702666] device: 'tty': device_add
[    0.703730] device: 'console': device_add
[    0.704795] device class 'thermal': registering
[    0.710836] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.712175] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.713590] NET: Registered protocol family 1
[    0.714622] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.715922] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.717282] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.718691] pci 0000:00:02.0: Boot video device
[    0.719757] PCI: CLS 0 bytes, default 64
[    0.721405] 
[    0.721765] ===============================
[    0.722637] [ INFO: suspicious RCU usage. ]
[    0.723480] 3.6.0-03071-g283dbd8 #2 Not tainted
[    0.724562] -------------------------------
[    0.725481] /c/kernel-tests/src/tip/include/linux/cgroup.h:566 suspicious rcu_dereference_check() usage!
[    0.727399] 
[    0.727399] other info that might help us debug this:
[    0.727399] 
[    0.729131] 
[    0.729131] rcu_scheduler_active = 1, debug_locks = 1
[    0.730473] 2 locks held by swapper/0/1:
[    0.731337]  #0:  (sb_writers){.+.+.+}, at: [<ffffffff8112b5a3>] sb_start_write+0x1a/0x23
[    0.733062]  #1:  (&sb->s_type->i_mutex_key#2/1){+.+.+.}, at: [<ffffffff81118c0e>] kern_path_create+0xa1/0x1be
[    0.735330] 
[    0.735330] stack backtrace:
[    0.736199] Pid: 1, comm: swapper/0 Not tainted 3.6.0-03071-g283dbd8 #2
[    0.737618] Call Trace:
[    0.738187]  [<ffffffff81084896>] lockdep_rcu_suspicious+0x15a/0x16a
[    0.739489]  [<ffffffff8115c43f>] task_devcgroup+0xb9/0xcf
[    0.740645]  [<ffffffff8115cad5>] devcgroup_inode_mknod+0x21/0x8c
[    0.741926]  [<ffffffff81115a73>] vfs_mknod+0x98/0xf4
[    0.742635]  [<ffffffff81118d96>] ? user_path_create+0x6b/0x7d
[    0.743460]  [<ffffffff81119856>] sys_mknodat+0x17d/0x1db
[    0.744199]  [<ffffffff811198d3>] sys_mknod+0x1f/0x28
[    0.744931]  [<ffffffff815ebca8>] do_name+0x31a/0x37f
[    0.745603]  [<ffffffff815eac7e>] write_buffer+0x29/0x49
[    0.746312]  [<ffffffff815eb5e1>] unpack_to_rootfs+0x111/0x331
[    0.747091]  [<ffffffff815eb801>] ? unpack_to_rootfs+0x331/0x331
[    0.747938]  [<ffffffff815eb820>] populate_rootfs+0x1f/0x18d
[    0.748729]  [<ffffffff8100026c>] do_one_initcall+0xb6/0x1d2
[    0.749514]  [<ffffffff815ea2c6>] kernel_init+0x1de/0x2cf
[    0.750566]  [<ffffffff815e964e>] ? loglevel+0x46/0x46
[    0.751607]  [<ffffffff81298704>] kernel_thread_helper+0x4/0x10
[    0.752921]  [<ffffffff81296d74>] ? retint_restore_args+0x13/0x13
[    0.753838]  [<ffffffff815ea0e8>] ? start_kernel+0x651/0x651
[    0.754657]  [<ffffffff81298700>] ? gs_change+0x13/0x13
[    0.755558] Unpacking initramfs...
[    2.348617] Freeing initrd memory: 23656k freed
[    2.360281] Registering platform device 'pcspkr'. Parent at platform
[    2.361740] device: 'pcspkr': device_add
[    2.362546] bus: 'platform': add device pcspkr
[    2.365164] bus: 'clocksource': registered
[    2.366088] device: 'clocksource': device_add
[    2.367016] device: 'clocksource0': device_add
[    2.367976] bus: 'clocksource': add device clocksource0
[    2.369138] bus: 'platform': add driver alarmtimer
[    2.370208] Registering platform device 'alarmtimer'. Parent at platform
[    2.371520] device: 'alarmtimer': device_add
[    2.372362] bus: 'platform': add device alarmtimer
[    2.373371] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    2.375099] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    2.376982] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    2.378507] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    2.381208] bus: 'event_source': registered
[    2.382662] device: 'breakpoint': device_add
[    2.383614] bus: 'event_source': add device breakpoint
[    2.384918] device: 'software': device_add
[    2.385748] bus: 'event_source': add device software
[    2.387912] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.390471] VFS: Disk quotas dquot_6.5.2
[    2.391406] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.393558] bus: 'acpi': add driver ac
[    2.394497] bus: 'acpi': add driver button
[    2.395369] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    2.396975] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    2.398556] device: 'input0': device_add
[    2.400172] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.401726] ACPI: Power Button [PWRF]
[    2.402502] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    2.403755] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    2.405252] bus: 'acpi': add driver fan
[    2.406138] bus: 'acpi': add driver processor
[    2.407075] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    2.408766] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    2.412049] device: 'cooling_device0': device_add
[    2.413871] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    2.415430] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    2.417013] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    2.418993] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[    2.421919] device: 'cooling_device1': device_add
[    2.423531] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[    2.424996] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[    2.426966] bus: 'acpi': add driver thermal
[    2.428564] bus: 'acpi': add driver battery
[    2.430707] device: 'ptmx': device_add
[    2.431659] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.432944] bus: 'pnp': add driver serial
[    2.433822] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[    2.435645] bus: 'pnp': really_probe: probing driver serial with device 00:06
[    2.461838] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.463127] device: 'ttyS0': device_add
[    2.464462] driver: '00:06': driver_bound: bound to device 'serial'
[    2.465865] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    2.468078] Registering platform device 'serial8250'. Parent at platform
[    2.469484] device: 'serial8250': device_add
[    2.470404] bus: 'platform': add device serial8250
[    2.472010] device: 'ttyS1': device_add
[    2.473262] device: 'ttyS2': device_add
[    2.474270] device: 'ttyS3': device_add
[    2.475280] bus: 'platform': add driver serial8250
[    2.476147] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    2.477733] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    2.479285] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    2.480821] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    2.482526] bus: 'pci': add driver serial
[    2.483957] bus: 'pnp': add driver i8042 kbd
[    2.484982] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[    2.486731] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[    2.488491] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    2.489931] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[    2.491584] bus: 'pnp': add driver i8042 aux
[    2.492497] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[    2.493922] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[    2.495305] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    2.496521] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[    2.497948] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.500088] Registering platform device 'i8042'. Parent at platform
[    2.501272] device: 'i8042': device_add
[    2.501991] bus: 'platform': add device i8042
[    2.503150] bus: 'platform': add driver i8042
[    2.503982] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    2.505423] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    2.508079] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.509369] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.510738] device: 'serio0': device_add
[    2.511676] bus: 'serio': add device serio0
[    2.513154] device: 'serio1': device_add
[    2.514012] bus: 'serio': add device serio1
[    2.515195] driver: 'i8042': driver_bound: bound to device 'i8042'
[    2.516282] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    2.517615] bus: 'serio': add driver atkbd
[    2.518585] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    2.520280] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    2.522715] device: 'input1': device_add
[    2.524396] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.526209] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    2.527600] cpuidle: using governor ladder
[    2.529146] 
[    2.529146] printing PIC contents
[    2.530085] ... PIC  IMR: ffff
[    2.530670] ... PIC  IRR: 1013
[    2.531313] ... PIC  ISR: 0000
[    2.531906] ... PIC ELCR: 0c00
[    2.532588] printing local APIC contents on CPU#0/0:
[    2.533571] ... APIC ID:      00000000 (0)
[    2.534113] ... APIC VERSION: 00050014
[    2.534113] ... APIC TASKPRI: 00000000 (00)
[    2.534113] ... APIC PROCPRI: 00000000
[    2.534113] ... APIC LDR: 01000000
[    2.534113] ... APIC DFR: ffffffff
[    2.534113] ... APIC SPIV: 000001ff
[    2.534113] ... APIC ISR field:
[    2.534113] 0000000000000000000000000000000000000000000000000000000000000000
[    2.534113] ... APIC TMR field:
[    2.534113] 0000000000000000000000000000000000000000000000000000000000000000
[    2.534113] ... APIC IRR field:
[    2.534113] 0000000000000000000000000000000000000000000000000000000000008000
[    2.534113] ... APIC ESR: 00000000
[    2.534113] ... APIC ICR: 000008fd
[    2.534113] ... APIC ICR2: 02000000
[    2.534113] ... APIC LVTT: 000200ef
[    2.534113] ... APIC LVTPC: 00010000
[    2.534113] ... APIC LVT0: 00010700
[    2.534113] ... APIC LVT1: 00000400
[    2.534113] ... APIC LVTERR: 000000fe
[    2.534113] ... APIC TMICT: 00032dba
[    2.534113] ... APIC TMCCT: 00022ce0
[    2.534113] ... APIC TDCR: 00000003
[    2.534113] 
[    2.553410] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    2.554708] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    2.556118] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    2.557846] atkbd: probe of serio1 rejects match -19
[    2.558869] number of MP IRQ sources: 15.
[    2.559677] number of IO-APIC #2 registers: 24.
[    2.560639] testing the IO APIC.......................
[    2.561689] IO APIC #2......
[    2.562215] .... register #00: 00000000
[    2.562883] .......    : physical APIC id: 00
[    2.563618] .......    : Delivery Type: 0
[    2.564386] .......    : LTS          : 0
[    2.565265] .... register #01: 00170011
[    2.566025] .......     : max redirection entries: 17
[    2.566947] .......     : PRQ implemented: 0
[    2.567880] .......     : IO APIC version: 11
[    2.568797] .... register #02: 00000000
[    2.569492] .......     : arbitration: 00
[    2.570385] .... IRQ redirection table:
[    2.571204]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    2.572374]  00 00  1    0    0   0   0    0    0    00
[    2.573364]  01 03  0    0    0   0   0    1    1    31
[    2.574369]  02 03  0    0    0   0   0    1    1    30
[    2.575314]  03 03  0    0    0   0   0    1    1    33
[    2.576253]  04 03  1    0    0   0   0    1    1    34
[    2.577249]  05 03  1    1    0   0   0    1    1    35
[    2.578348]  06 03  0    0    0   0   0    1    1    36
[    2.579409]  07 03  0    0    0   0   0    1    1    37
[    2.580538]  08 03  0    0    0   0   0    1    1    38
[    2.581614]  09 03  0    1    0   0   0    1    1    39
[    2.582678]  0a 03  1    1    0   0   0    1    1    3A
[    2.583770]  0b 03  1    1    0   0   0    1    1    3B
[    2.584828]  0c 03  0    0    0   0   0    1    1    3C
[    2.585935]  0d 03  0    0    0   0   0    1    1    3D
[    2.586962]  0e 03  0    0    0   0   0    1    1    3E
[    2.588072]  0f 03  0    0    0   0   0    1    1    3F
[    2.589115]  10 00  1    0    0   0   0    0    0    00
[    2.590226]  11 00  1    0    0   0   0    0    0    00
[    2.591332]  12 00  1    0    0   0   0    0    0    00
[    2.592377]  13 00  1    0    0   0   0    0    0    00
[    2.593572]  14 00  1    0    0   0   0    0    0    00
[    2.594323]  15 00  1    0    0   0   0    0    0    00
[    2.595060]  16 00  1    0    0   0   0    0    0    00
[    2.595777]  17 00  1    0    0   0   0    0    0    00
[    2.596512] IRQ to pin mappings:
[    2.596974] IRQ0 -> 0:2
[    2.597380] IRQ1 -> 0:1
[    2.597746] IRQ3 -> 0:3
[    2.598120] IRQ4 -> 0:4
[    2.598482] IRQ5 -> 0:5
[    2.598860] IRQ6 -> 0:6
[    2.599227] IRQ7 -> 0:7
[    2.599594] IRQ8 -> 0:8
[    2.600084] IRQ9 -> 0:9
[    2.600693] IRQ10 -> 0:10
[    2.601259] IRQ11 -> 0:11
[    2.601826] IRQ12 -> 0:12
[    2.602476] IRQ13 -> 0:13
[    2.603145] IRQ14 -> 0:14
[    2.603702] IRQ15 -> 0:15
[    2.604135] .................................... done.
[    2.604845] device: 'cpu_dma_latency': device_add
[    2.605540] device: 'network_latency': device_add
[    2.606466] device: 'network_throughput': device_add
[    2.613666] Freeing unused kernel memory: 488k freed
modprobe: FATAL: Could not load /lib/modules/3.6.0-03071-g283dbd8/modules.dep: No such file or directory

[    2.634167] modprobe (34) used greatest stack depth: 5328 bytes left
modprobe: FATAL: Could not load /lib/modules/3.6.0-03071-g283dbd8/modules.dep: No such file or directory

/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-03071-g283dbd8"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.6.0 Kernel Configuration
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
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
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
CONFIG_IRQ_DOMAIN_DEBUG=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_USER_QS=y
CONFIG_RCU_USER_QS_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_RCU_USER_QS=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
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
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
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
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
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
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_OMAP_OCP2SCP=m
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=m
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_TCA6416=m
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=m
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_BMA150=m
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_ADXL34X=m
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=m
# CONFIG_TTY_PRINTK is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
CONFIG_GEN_RTC=m
# CONFIG_GEN_RTC_X is not set
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
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
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=m

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_HDQ_MASTER_OMAP=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
# CONFIG_GENERIC_ADC_BATTERY is not set
CONFIG_TEST_POWER=m
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=m
CONFIG_HTC_PASIC3=m
CONFIG_MFD_LM3533=m
CONFIG_TPS6105X=m
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_ABX500_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ARIZONA is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_DVB_CORE=m

#
# Media drivers
#
CONFIG_RC_CORE=m
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
CONFIG_MEDIA_TUNER_TDA18271=m
# CONFIG_MEDIA_TUNER_TDA9887 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
# CONFIG_MEDIA_TUNER_MC44S803 is not set
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_VIDEO_V4L2=m
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_TESTDEV=m
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_CAPTURE_DRIVERS is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_LM3533 is not set
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_ADP8860=m
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=m
# CONFIG_BACKLIGHT_LP855X is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_OMAP_USB2 is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_PCA9633=m
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM3556=m
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_DECODE_MCE is not set
# CONFIG_EDAC_MM_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_TIMB_DMA=m
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set

#
# Virtio drivers
#
# CONFIG_VIRTIO_BALLOON is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_ARIZONA=m
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_KFIFO_BUF is not set
# CONFIG_IIO_TRIGGER is not set

#
# Accelerometers
#

#
# Analog to digital converters
#

#
# Amplifiers
#

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_SENSORS_LM3533=m
# CONFIG_VCNL4000 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5446 is not set
# CONFIG_MCP4725 is not set

#
# Hid Sensor IIO Common
#

#
# Digital gyroscope sensors
#

#
# Light sensors
#

#
# Magnetometer sensors
#
# CONFIG_VME_BUS is not set
CONFIG_PWM=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=m
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=m
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=m

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=m
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=m
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA1_SSSE3=m
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=m
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=m
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set

--Q68bSM7Ycu6FN28Q--
