Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2GMH7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 03:59:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:18964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab2GMH7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 03:59:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="165339321"
Date: Fri, 13 Jul 2012 15:59:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: show_uevent() and general protection fault
Message-ID: <20120713075907.GA18900@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I can reproduce this all the way back to 3.0 kernel.

show_uevent():
        /* copy keys to file */
        for (i = 0; i < env->envp_idx; i++)
                count += sprintf(&buf[count], "%s\n", env->envp[i]);

[   26.602710] warning: process `trinity-child0' used the deprecated sysctl system call with 
[   32.747503] general protection fault: 0000 [#1] DEBUG_PAGEALLOC
[   32.748700] CPU 0 
[   32.748700] Pid: 84, comm: trinity-child0 Not tainted 3.5.0-rc5+ #51 Bochs Bochs
[   32.748700] RIP: 0010:[<ffffffff8115a5bd>]  [<ffffffff8115a5bd>] strnlen+0xd/0x40
[   32.748700] RSP: 0018:ffff880005f87d08  EFLAGS: 00010286
[   32.748700] RAX: ffffffff81404ed8 RBX: ffff880005fa70e0 RCX: fffffffffffffffe
[   32.748700] RDX: 3a69706361000000 RSI: ffffffffffffffff RDI: 3a69706361000000
[   32.748700] RBP: ffff880005f87d08 R08: 000000000000ffff R09: 000000000000ffff
[   32.748700] R10: ffff880006e8b000 R11: ffff88000005ebc0 R12: 3a69706361000000
[   32.748700] R13: ffff880085fa70df R14: 000000000000ffff R15: 0000000000000000
[   32.748700] FS:  00007f177a9d2700(0000) GS:ffffffff81457000(0000) knlGS:0000000000000000
[   32.748700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.748700] CR2: 0000000002f1b000 CR3: 0000000005f84000 CR4: 00000000000006b0
[   32.748700] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   32.748700] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   32.748700] Process trinity-child0 (pid: 84, threadinfo ffff880005f86000, task ffff880006f6c440)
[   32.748700] Stack:
[   32.748700]  ffff880005f87d48 ffffffff8115ba8e ffff880006e8b103 ffff880005fa70e0
[   32.748700]  ffff880085fa70df ffff880005f87de0 ffffffff813eb7c4 ffffffff813eb7c4
[   32.748700]  ffff880005f87dc8 ffffffff8115c569 ffff880005f87e08 ffffffff810730eb
[   32.748700] Call Trace:
[   32.748700]  [<ffffffff8115ba8e>] string.isra.4+0x3e/0xd0
[   32.748700]  [<ffffffff8115c569>] vsnprintf+0x219/0x600
[   32.748700]  [<ffffffff810730eb>] ? __lock_acquire.isra.31+0x3eb/0xb30
[   32.748700]  [<ffffffff8115cd30>] sprintf+0x40/0x50
[   32.748700]  [<ffffffff811f0dbe>] show_uevent+0xee/0x120
[   32.748700]  [<ffffffff811118fe>] ? sysfs_read_file+0x3e/0x1a0
[   32.748700]  [<ffffffff811f0c8b>] dev_attr_show+0x1b/0x60
[   32.748700]  [<ffffffff81111946>] ? sysfs_read_file+0x86/0x1a0
[   32.748700]  [<ffffffff8109d7e8>] ? __get_free_pages+0x18/0x80
[   32.748700]  [<ffffffff81111972>] sysfs_read_file+0xb2/0x1a0
[   32.748700]  [<ffffffff810cd14f>] vfs_read+0x9f/0x160
[   32.748700]  [<ffffffff810cd4c8>] sys_read+0x48/0x90
[   32.748700]  [<ffffffff812b6637>] system_call_fastpath+0x16/0x1b
[   32.748700] Code: c0 01 80 38 00 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 f6 48 8d 4e ff 48 89 e5 74 2a <80> 3f 00 74 25 48 89 f8 31 d2 eb 10 0f 1f 80 00 00 00 00 48 83 
[   32.748700] RIP  [<ffffffff8115a5bd>] strnlen+0xd/0x40
[   32.748700]  RSP <ffff880005f87d08>

Thanks,
Fengguang

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm-xgwo-6655-2012-07-13-05-27-24

[    0.000000] Linux version 3.5.0-rc5+ (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #51 Fri Jul 13 05:25:48 CST 2012
[    0.000000] Command line: trinity=10m tree=nf-next:mmap-netlink auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-13-05-26-10-net-nf-next.mmap-netlink-c7e7243-95db415-x86_64-randconfig-net1-1-xgwo BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-net1/95db41584737bfbbf0c0695099b7f40276483da8/vmlinuz-3.5.0-rc5+
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
[    0.000000]  [mem 0x00000000-0x0fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128784(98%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: cpu 0, msr 0:145ea81, boot clock
[    0.000000] Zone ranges:
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 6 pages reserved
[    0.000000]   DMA32 zone: 64390 pages, LIFO batch:15
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64390
[    0.000000] Kernel command line: trinity=10m tree=nf-next:mmap-netlink auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-07-13-05-26-10-net-nf-next.mmap-netlink-c7e7243-95db415-x86_64-randconfig-net1-1-xgwo BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-net1/95db41584737bfbbf0c0695099b7f40276483da8/vmlinuz-3.5.0-rc5+
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 209680k/262132k available (2789k kernel code, 452k absent, 52000k reserved, 3832k data, 520k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:48 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.000000]             mixed read-write-lock:             |failed|             |failed|
[    0.000000]             mixed write-read-lock:             |failed|             |failed|
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.000000] --------------------------------------------------------
[    0.000000] 133 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] Detected 2666.698 MHz processor.
[    0.004000] Calibrating delay loop (skipped) preset value.. 5333.39 BogoMIPS (lpj=10666792)
[    0.004023] pid_max: default: 32768 minimum: 301
[    0.005499] Security Framework initialized
[    0.006626] Yama: becoming mindful.
[    0.008086] Mount-cache hash table entries: 256
[    0.009920] mce: CPU supports 10 MCE banks
[    0.011089] MCE: unknown CPU type - not enabling MCE support.
[    0.012012] CPU: GenuineIntel Common KVM processor stepping 01
[    0.020645] ACPI: Core revision 20120320
[    0.023794] Performance Events: 
[    0.024351] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.026309] Getting VERSION: 50014
[    0.028018] Getting VERSION: 50014
[    0.029023] Getting ID: 0
[    0.029758] Getting ID: ff000000
[    0.030654] Getting LVT0: 8700
[    0.032022] Getting LVT1: 8400
[    0.033000] enabled ExtINT on CPU#0
[    0.037619] ENABLING IO-APIC IRQs
[    0.038546] init IO_APIC IRQs
[    0.039372]  apic 2 pin 0 not connected
[    0.040044] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.042201] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.044037] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.046206] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.048046] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.052033] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.054177] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.056033] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.060033] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.062206] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.064047] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.068035] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.070246] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.072035] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.076040] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.080034]  apic 2 pin 16 not connected
[    0.081105]  apic 2 pin 17 not connected
[    0.082169]  apic 2 pin 18 not connected
[    0.084008]  apic 2 pin 19 not connected
[    0.085083]  apic 2 pin 20 not connected
[    0.086281]  apic 2 pin 21 not connected
[    0.087351]  apic 2 pin 22 not connected
[    0.088010]  apic 2 pin 23 not connected
[    0.089292] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.092014] Using local APIC timer interrupts.
[    0.092014] calibrating APIC timer ...
[    0.100005] ... lapic delta = 7596793
[    0.100005] ..... delta 7596793
[    0.100005] ..... mult: 326259383
[    0.100005] ..... calibration result: 4861947
[    0.100005] ..... CPU clock speed is 3241.1644 MHz.
[    0.100005] ..... host bus clock speed is 1215.1947 MHz.
[    0.100005] ... verify APIC timer
[    0.213825] ... jiffies delta = 26
[    0.215413] ... jiffies result ok
[    0.216429] device: 'platform': device_add
[    0.218288] bus: 'platform': registered
[    0.220013] bus: 'cpu': registered
[    0.220018] device: 'cpu': device_add
[    0.222249] bus: 'virtio': registered
[    0.224036] device class 'regulator': registering
[    0.228147] Registering platform device 'reg-dummy'. Parent at platform
[    0.231117] device: 'reg-dummy': device_add
[    0.232030] bus: 'platform': add device reg-dummy
[    0.234203] bus: 'platform': add driver reg-dummy
[    0.236022] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.240024] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.244068] device: 'regulator.0': device_add
[    0.248124] dummy: 
[    0.249144] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.256040] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.259889] NET: Registered protocol family 16
[    0.260167] device class 'bdi': registering
[    0.262101] device class 'pci_bus': registering
[    0.264079] bus: 'pci': registered
[    0.268029] device: 'rapidio': device_add
[    0.272038] bus: 'rapidio': registered
[    0.273881] device class 'backlight': registering
[    0.276066] device class 'tty': registering
[    0.278123] bus: 'spi': registered
[    0.279670] device class 'spi_master': registering
[    0.280092] bus: 'hsi': registered
[    0.284282] ACPI: bus type pci registered
[    0.288030] device class 'dma': registering
[    0.289993] device class 'dmi': registering
[    0.292017] device: 'id': device_add
[    0.292164] PCI: Using configuration type 1 for base access
[    0.294891] device: 'cpu0': device_add
[    0.300037] bus: 'cpu': add device cpu0
[    0.303038] device: 'default': device_add
[    0.304317] ACPI: Added _OSI(Module Device)
[    0.306320] ACPI: Added _OSI(Processor Device)
[    0.308025] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.310277] ACPI: Added _OSI(Processor Aggregator Device)
[    0.318539] ACPI: EC: Look up EC in DSDT
[    0.324945] ACPI: Interpreter enabled
[    0.326633] ACPI: (supports S0 S5)
[    0.328433] ACPI: Using IOAPIC for interrupt routing
[    0.332052] bus: 'acpi': registered
[    0.333629] bus: 'acpi': add driver power
[    0.336082] device: 'LNXSYSTM:00': device_add
[    0.338057] bus: 'acpi': add device LNXSYSTM:00
[    0.340178] device: 'LNXCPU:00': device_add
[    0.342075] bus: 'acpi': add device LNXCPU:00
[    0.348080] device: 'LNXCPU:01': device_add
[    0.350056] bus: 'acpi': add device LNXCPU:01
[    0.352021] device: 'device:00': device_add
[    0.352033] bus: 'acpi': add device device:00
[    0.354123] device: 'PNP0A03:00': device_add
[    0.356032] bus: 'acpi': add device PNP0A03:00
[    0.360188] device: 'device:01': device_add
[    0.362197] bus: 'acpi': add device device:01
[    0.364114] device: 'device:02': device_add
[    0.366131] bus: 'acpi': add device device:02
[    0.368102] device: 'device:03': device_add
[    0.370104] bus: 'acpi': add device device:03
[    0.372102] device: 'device:04': device_add
[    0.376042] bus: 'acpi': add device device:04
[    0.380096] device: 'device:05': device_add
[    0.381966] bus: 'acpi': add device device:05
[    0.384023] device: 'device:06': device_add
[    0.384032] bus: 'acpi': add device device:06
[    0.386211] device: 'device:07': device_add
[    0.388034] bus: 'acpi': add device device:07
[    0.392171] device: 'device:08': device_add
[    0.394213] bus: 'acpi': add device device:08
[    0.396157] device: 'device:09': device_add
[    0.398175] bus: 'acpi': add device device:09
[    0.400152] device: 'device:0a': device_add
[    0.404046] bus: 'acpi': add device device:0a
[    0.408117] device: 'device:0b': device_add
[    0.410151] bus: 'acpi': add device device:0b
[    0.412025] device: 'device:0c': device_add
[    0.412036] bus: 'acpi': add device device:0c
[    0.414080] device: 'device:0d': device_add
[    0.420097] bus: 'acpi': add device device:0d
[    0.422290] device: 'device:0e': device_add
[    0.424039] bus: 'acpi': add device device:0e
[    0.426187] device: 'device:0f': device_add
[    0.428039] bus: 'acpi': add device device:0f
[    0.430120] device: 'device:10': device_add
[    0.432037] bus: 'acpi': add device device:10
[    0.434074] device: 'device:11': device_add
[    0.436100] bus: 'acpi': add device device:11
[    0.440122] device: 'device:12': device_add
[    0.442144] bus: 'acpi': add device device:12
[    0.444175] device: 'device:13': device_add
[    0.446129] bus: 'acpi': add device device:13
[    0.448108] device: 'device:14': device_add
[    0.450051] bus: 'acpi': add device device:14
[    0.456125] device: 'device:15': device_add
[    0.458093] bus: 'acpi': add device device:15
[    0.460028] device: 'device:16': device_add
[    0.460039] bus: 'acpi': add device device:16
[    0.462123] device: 'device:17': device_add
[    0.464040] bus: 'acpi': add device device:17
[    0.466213] device: 'device:18': device_add
[    0.472046] bus: 'acpi': add device device:18
[    0.474150] device: 'device:19': device_add
[    0.476037] bus: 'acpi': add device device:19
[    0.478142] device: 'device:1a': device_add
[    0.480029] bus: 'acpi': add device device:1a
[    0.480183] device: 'device:1b': device_add
[    0.482154] bus: 'acpi': add device device:1b
[    0.488139] device: 'device:1c': device_add
[    0.490044] bus: 'acpi': add device device:1c
[    0.492107] device: 'device:1d': device_add
[    0.494018] bus: 'acpi': add device device:1d
[    0.496030] device: 'device:1e': device_add
[    0.496043] bus: 'acpi': add device device:1e
[    0.498203] device: 'device:1f': device_add
[    0.500051] bus: 'acpi': add device device:1f
[    0.502266] device: 'device:20': device_add
[    0.504045] bus: 'acpi': add device device:20
[    0.506059] device: 'device:21': device_add
[    0.508041] bus: 'acpi': add device device:21
[    0.510171] device: 'PNP0B00:00': device_add
[    0.512031] bus: 'acpi': add device PNP0B00:00
[    0.512125] device: 'PNP0303:00': device_add
[    0.516049] bus: 'acpi': add device PNP0303:00
[    0.520149] device: 'PNP0F13:00': device_add
[    0.522072] bus: 'acpi': add device PNP0F13:00
[    0.524141] device: 'PNP0700:00': device_add
[    0.526078] bus: 'acpi': add device PNP0700:00
[    0.528960] device: 'PNP0400:00': device_add
[    0.532055] bus: 'acpi': add device PNP0400:00
[    0.536237] device: 'PNP0501:00': device_add
[    0.538158] bus: 'acpi': add device PNP0501:00
[    0.540222] device: 'device:22': device_add
[    0.542132] bus: 'acpi': add device device:22
[    0.544033] device: 'PNP0103:00': device_add
[    0.548052] bus: 'acpi': add device PNP0103:00
[    0.550495] device: 'PNP0C0F:00': device_add
[    0.552048] bus: 'acpi': add device PNP0C0F:00
[    0.554223] device: 'PNP0C0F:01': device_add
[    0.556044] bus: 'acpi': add device PNP0C0F:01
[    0.558206] device: 'PNP0C0F:02': device_add
[    0.560056] bus: 'acpi': add device PNP0C0F:02
[    0.562354] device: 'PNP0C0F:03': device_add
[    0.564099] bus: 'acpi': add device PNP0C0F:03
[    0.566297] device: 'device:23': device_add
[    0.568034] bus: 'acpi': add device device:23
[    0.568082] device: 'LNXPWRBN:00': device_add
[    0.572048] bus: 'acpi': add device LNXPWRBN:00
[    0.576402] bus: 'acpi': add driver ec
[    0.578351] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.584045] bus: 'acpi': add driver pci_root
[    0.586101] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    0.588040] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    0.592087] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.600095] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.603514] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.604044] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.608043] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.616046] PCI: root bus 00: using default resources
[    0.618432] device: 'pci0000:00': device_add
[    0.620141] device: '0000:00': device_add
[    0.622122] PCI host bridge to bus 0000:00
[    0.623978] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.624043] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.632049] pci_bus 0000:00: scanning bus
[    0.634966] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.636098] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0xa
[    0.640708] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.644995] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.648622] pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
[    0.652504] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.656173] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x145
[    0.658984] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.660063] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.663478] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x10
[    0.668275] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.681842] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
[    0.687717] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
[    0.708178] pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]
[    0.711575] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.716053] pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]
[    0.720050] pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]
[    0.729440] pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf2047fff pref]
[    0.732146] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.735206] pci 0000:00:04.0: reg 10: [io  0xc080-0xc0bf]
[    0.736190] pci 0000:00:04.0: reg 14: [mem 0xf2048000-0xf2048fff]
[    0.740154] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.744383] pci 0000:00:05.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.748180] pci 0000:00:05.0: reg 14: [mem 0xf2049000-0xf2049fff]
[    0.753149] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.756046] pci 0000:00:06.0: reg 10: [io  0xc100-0xc13f]
[    0.756188] pci 0000:00:06.0: reg 14: [mem 0xf204a000-0xf204afff]
[    0.761289] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.764301] pci 0000:00:07.0: reg 10: [io  0xc140-0xc17f]
[    0.766997] pci 0000:00:07.0: reg 14: [mem 0xf204b000-0xf204bfff]
[    0.769125] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.772416] pci 0000:00:08.0: reg 10: [io  0xc180-0xc1bf]
[    0.776223] pci 0000:00:08.0: reg 14: [mem 0xf204c000-0xf204cfff]
[    0.781135] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.784293] pci 0000:00:09.0: reg 10: [io  0xc1c0-0xc1ff]
[    0.786839] pci 0000:00:09.0: reg 14: [mem 0xf204d000-0xf204dfff]
[    0.789065] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.796242] pci 0000:00:0a.0: reg 10: [mem 0xf204e000-0xf204e00f]
[    0.801392] pci_bus 0000:00: fixups for bus
[    0.803288] pci_bus 0000:00: bus scan returning with max=00
[    0.804057] pci_bus 0000:00: on NUMA node 0
[    0.806036] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.813365]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.816072] device: '0000:00:00.0': device_add
[    0.819017] bus: 'pci': add device 0000:00:00.0
[    0.820219] device: '0000:00:01.0': device_add
[    0.824306] bus: 'pci': add device 0000:00:01.0
[    0.828099] device: '0000:00:01.1': device_add
[    0.832544] bus: 'pci': add device 0000:00:01.1
[    0.834763] device: '0000:00:01.3': device_add
[    0.836650] bus: 'pci': add device 0000:00:01.3
[    0.840155] device: '0000:00:02.0': device_add
[    0.844709] bus: 'pci': add device 0000:00:02.0
[    0.846822] device: '0000:00:03.0': device_add
[    0.848778] bus: 'pci': add device 0000:00:03.0
[    0.851080] device: '0000:00:04.0': device_add
[    0.852770] bus: 'pci': add device 0000:00:04.0
[    0.856143] device: '0000:00:05.0': device_add
[    0.860794] bus: 'pci': add device 0000:00:05.0
[    0.862863] device: '0000:00:06.0': device_add
[    0.864840] bus: 'pci': add device 0000:00:06.0
[    0.867023] device: '0000:00:07.0': device_add
[    0.872857] bus: 'pci': add device 0000:00:07.0
[    0.874979] device: '0000:00:08.0': device_add
[    0.876786] bus: 'pci': add device 0000:00:08.0
[    0.880144] device: '0000:00:09.0': device_add
[    0.882874] bus: 'pci': add device 0000:00:09.0
[    0.888078] device: '0000:00:0a.0': device_add
[    0.890971] bus: 'pci': add device 0000:00:0a.0
[    0.892170] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    0.895371] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    0.896147] bus: 'acpi': add driver pci_link
[    0.904104] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    0.907979] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    0.908229] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.912841] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    0.916055] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    0.920068] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    0.924062] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    0.932237] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.935091] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    0.936064] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    0.940066] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    0.943934] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    0.944165] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.948850] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    0.952065] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    0.955548] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    0.960067] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    0.964173] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.968403] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    0.972072] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    0.976109] bus: 'pnp': registered
[    0.977778] bus: 'platform': add driver da9052-regulator
[    0.980074] bus: 'platform': add driver wm831x-buckv
[    0.982426] bus: 'platform': add driver wm831x-buckp
[    0.984094] bus: 'platform': add driver wm831x-boostp
[    0.986427] bus: 'platform': add driver wm831x-epe
[    0.988077] bus: 'platform': add driver wm831x-isink
[    0.990430] bus: 'platform': add driver wm831x-ldo
[    0.992071] bus: 'platform': add driver wm831x-aldo
[    0.994417] bus: 'platform': add driver wm831x-alive-ldo
[    0.996172] device class 'misc': registering
[    1.000148] bus: 'spi': add driver wm831x
[    1.004077] bus: 'spi': add driver ezx-pcap
[    1.005980] bus: 'spi': add driver da9052
[    1.007955] bus: 'serio': registered
[    1.008145] bus: 'gameport': registered
[    1.009939] device class 'input': registering
[    1.012104] device class 'rtc': registering
[    1.016078] device class 'power_supply': registering
[    1.018480] device class 'hwmon': registering
[    1.020081] device class 'watchdog': registering
[    1.022221] device class 'leds': registering
[    1.024082] PCI: Using ACPI for IRQ routing
[    1.028087] PCI: pci_cache_line_size set to 64 bytes
[    1.032143] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    1.035905] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    1.036071] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    1.044075] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    1.048073] pci 0000:00:01.1: BAR 4: reserving [io  0xc000-0xc00f flags 0x40101] (d=0, p=0)
[    1.052122] pci 0000:00:02.0: BAR 0: reserving [mem 0xf0000000-0xf1ffffff flags 0x42208] (d=0, p=0)
[    1.056065] pci 0000:00:02.0: BAR 1: reserving [mem 0xf2000000-0xf2000fff flags 0x40200] (d=0, p=0)
[    1.060104] pci 0000:00:03.0: BAR 0: reserving [mem 0xf2020000-0xf203ffff flags 0x40200] (d=0, p=0)
[    1.064072] pci 0000:00:03.0: BAR 1: reserving [io  0xc040-0xc07f flags 0x40101] (d=0, p=0)
[    1.072114] pci 0000:00:04.0: BAR 0: reserving [io  0xc080-0xc0bf flags 0x40101] (d=0, p=0)
[    1.076075] pci 0000:00:04.0: BAR 1: reserving [mem 0xf2048000-0xf2048fff flags 0x40200] (d=0, p=0)
[    1.084113] pci 0000:00:05.0: BAR 0: reserving [io  0xc0c0-0xc0ff flags 0x40101] (d=0, p=0)
[    1.092084] pci 0000:00:05.0: BAR 1: reserving [mem 0xf2049000-0xf2049fff flags 0x40200] (d=0, p=0)
[    1.100113] pci 0000:00:06.0: BAR 0: reserving [io  0xc100-0xc13f flags 0x40101] (d=0, p=0)
[    1.103920] pci 0000:00:06.0: BAR 1: reserving [mem 0xf204a000-0xf204afff flags 0x40200] (d=0, p=0)
[    1.104104] pci 0000:00:07.0: BAR 0: reserving [io  0xc140-0xc17f flags 0x40101] (d=0, p=0)
[    1.108077] pci 0000:00:07.0: BAR 1: reserving [mem 0xf204b000-0xf204bfff flags 0x40200] (d=0, p=0)
[    1.112113] pci 0000:00:08.0: BAR 0: reserving [io  0xc180-0xc1bf flags 0x40101] (d=0, p=0)
[    1.116075] pci 0000:00:08.0: BAR 1: reserving [mem 0xf204c000-0xf204cfff flags 0x40200] (d=0, p=0)
[    1.120099] pci 0000:00:09.0: BAR 0: reserving [io  0xc1c0-0xc1ff flags 0x40101] (d=0, p=0)
[    1.124075] pci 0000:00:09.0: BAR 1: reserving [mem 0xf204d000-0xf204dfff flags 0x40200] (d=0, p=0)
[    1.132109] pci 0000:00:0a.0: BAR 0: reserving [mem 0xf204e000-0xf204e00f flags 0x40200] (d=0, p=0)
[    1.136360] e820: reserve RAM buffer [mem 0x0009f400-0x0009ffff]
[    1.140095] e820: reserve RAM buffer [mem 0x0fffd000-0x0fffffff]
[    1.144095] device class 'net': registering
[    1.146106] device: 'lo': device_add
[    1.148071] Switching to clocksource kvm-clock
[    1.148379] FS-Cache: Loaded
[    1.149869] bus: 'pnp': add driver system
[    1.157418] pnp: PnP ACPI init
[    1.158844] device: 'pnp0': device_add
[    1.160603] ACPI: bus type pnp registered
[    1.162604] pnp 00:00: [bus 00-ff]
[    1.164162] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.166164] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.168281] pnp 00:00: [io  0x0d00-0xffff window]
[    1.176196] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.178759] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    1.182012] device: '00:00': device_add
[    1.183924] bus: 'pnp': add device 00:00
[    1.190812] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.194190] pnp 00:01: [io  0x0070-0x0071]
[    1.196054] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    1.199958] pnp 00:01: [irq 8]
[    1.201522] pnp 00:01: [io  0x0072-0x0077]
[    1.208721] device: '00:01': device_add
[    1.211074] bus: 'pnp': add device 00:01
[    1.213072] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.216071] pnp 00:02: [io  0x0060]
[    1.217828] pnp 00:02: [io  0x0064]
[    1.219430] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    1.228350] pnp 00:02: [irq 1]
[    1.229923] device: '00:02': device_add
[    1.231752] bus: 'pnp': add device 00:02
[    1.233754] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.236863] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    1.245847] pnp 00:03: [irq 12]
[    1.247291] device: '00:03': device_add
[    1.249278] bus: 'pnp': add device 00:03
[    1.251142] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.254329] pnp 00:04: [io  0x03f2-0x03f5]
[    1.256173] pnp 00:04: [io  0x03f7]
[    1.263176] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    1.266890] pnp 00:04: [irq 6]
[    1.268303] pnp 00:04: [dma 2]
[    1.269809] device: '00:04': device_add
[    1.271664] bus: 'pnp': add device 00:04
[    1.273626] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.281826] pnp 00:05: [io  0x0378-0x037f]
[    1.283684] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    1.287443] pnp 00:05: [irq 7]
[    1.288998] device: '00:05': device_add
[    1.290852] bus: 'pnp': add device 00:05
[    1.292754] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.305450] pnp 00:06: [io  0x03f8-0x03ff]
[    1.307333] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    1.320570] pnp 00:06: [irq 4]
[    1.322140] device: '00:06': device_add
[    1.324151] bus: 'pnp': add device 00:06
[    1.326083] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.329253] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    1.331396] device: '00:07': device_add
[    1.333358] bus: 'pnp': add device 00:07
[    1.340893] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.344075] pnp: PnP ACPI: found 8 devices
[    1.346092] ACPI: ACPI bus type pnp unregistered
[    1.348170] bus: 'pci': add driver Intel MID DMA
[    1.350473] device class 'mem': registering
[    1.352385] device: 'mem': device_add
[    1.359564] device: 'kmem': device_add
[    1.361493] device: 'null': device_add
[    1.363190] device: 'port': device_add
[    1.365072] device: 'zero': device_add
[    1.366770] device: 'full': device_add
[    1.368528] device: 'random': device_add
[    1.370464] device: 'urandom': device_add
[    1.372278] device: 'kmsg': device_add
[    1.378928] device: 'oldmem': device_add
[    1.380849] device: 'tty': device_add
[    1.382586] device: 'console': device_add
[    1.384536] device class 'firmware': registering
[    1.386839] device class 'thermal': registering
[    1.389082] bus: 'ssb': registered
[    1.390738] bus: 'bcma': registered
[    1.397753] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    1.400248] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    1.403392] NET: Registered protocol family 1
[    1.405554] pci 0000:00:00.0: calling quirk_natoma+0x0/0x2b
[    1.408018] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.410844] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
[    1.419230] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.422010] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x2e
[    1.424856] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.430968] pci 0000:00:02.0: calling pci_fixup_video+0x0/0x9b
[    1.437674] pci 0000:00:02.0: Boot video device
[    1.439738] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x165
[    1.442876] PCI: CLS 0 bytes, default 64
[    1.445116] Unpacking initramfs...
[    4.283257] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    4.459457] DMA-API: preallocated 32768 debug entries
[    4.464323] DMA-API: debugging enabled by kernel config
[    4.472327] microcode: no support for this CPU vendor
[    4.482641] cryptomgr_test (13) used greatest stack depth: 6168 bytes left
[    4.495270] cryptomgr_test (15) used greatest stack depth: 5880 bytes left
[    4.509850] bus: 'clocksource': registered
[    4.518346] device: 'clocksource': device_add
[    4.520170] device: 'clocksource0': device_add
[    4.526306] bus: 'clocksource': add device clocksource0
[    4.531423] bus: 'platform': add driver alarmtimer
[    4.535700] Registering platform device 'alarmtimer'. Parent at platform
[    4.538290] device: 'alarmtimer': device_add
[    4.539867] bus: 'platform': add device alarmtimer
[    4.547655] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    4.550943] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    4.559597] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    4.562265] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    4.572310] bus: 'event_source': registered
[    4.580342] device: 'breakpoint': device_add
[    4.582390] bus: 'event_source': add device breakpoint
[    4.587177] device: 'software': device_add
[    4.589055] bus: 'event_source': add device software
[    4.606019] VFS: Disk quotas dquot_6.5.2
[    4.608000] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.611138] msgmni has been set to 409
[    4.619834] cryptomgr_test (29) used greatest stack depth: 5656 bytes left
[    4.635365] alg: No test for fcrypt (fcrypt-generic)
[    4.659422] alg: No test for stdrng (krng)
[    4.676349] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    4.680070] list_sort_test: start testing list_sort()
[    4.689100] bus: 'acpi': add driver button
[    4.691013] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    4.694892] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    4.698526] device: 'input0': device_add
[    4.707506] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    4.711030] ACPI: Power Button [PWRF]
[    4.712845] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    4.715938] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    4.725710] bus: 'acpi': add driver smbus_hc
[    4.727689] bus: 'acpi': add driver sbs
[    4.729660] bus: 'virtio': add driver virtio_balloon
[    4.731893] bus: 'platform': add driver reg-virt-consumer
[    4.734493] bus: 'platform': add driver reg-userspace-consumer
[    4.744356] bus: 'spi': add driver tps6524x
[    4.746452] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.749456] Registering platform device 'serial8250'. Parent at platform
[    4.752473] device: 'serial8250': device_add
[    4.754564] bus: 'platform': add device serial8250
[    4.806402] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.809389] device: 'ttyS0': device_add
[    4.811220] device: 'ttyS1': device_add
[    4.819828] device: 'ttyS2': device_add
[    4.821787] device: 'ttyS3': device_add
[    4.823608] bus: 'platform': add driver serial8250
[    4.825942] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    4.830103] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    4.839736] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    4.843031] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    4.846751] bus: 'pci': add driver serial
[    4.848676] enter max3107 init
[    4.856689] bus: 'spi': add driver max3107
[    4.858879] bus: 'pci': add driver HSU serial
[    4.861137] device: 'ttyprintk': device_add
[    4.863036] device class 'virtio-ports': registering
[    4.865432] bus: 'virtio': add driver virtio_console
[    4.873636] device class 'printer': registering
[    4.875723] lp: driver loaded but no devices found
[    4.878074] smapi::smapi_init, ERROR invalid usSmapiID
[    4.880377] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    4.884701] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    4.894433] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.897376] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    4.901510] Hangcheck: Using getrawmonotonic().
[    4.909953] bus: 'pnp': add driver tpm_tis
[    4.911964] bus: 'pci': add driver pciPTI
[    4.913943] bus: 'pci': add driver IOC4
[    4.915718] device class 'enclosure': registering
[    4.918025] bus: 'platform': add driver cs5535-mfgpt
[    4.920266] device class 'iLO': registering
[    4.922334] bus: 'pci': add driver hpilo
[    4.924127] bus: 'spi': add driver dac7512
[    4.926147] bus: 'spi': add driver 93xx46
[    4.927936] bus: 'platform': add driver sm501
[    4.930051] bus: 'pci': add driver sm501
[    4.932001] bus: 'pci': add driver lpc_sch
[    4.934021] bus: 'pci': add driver lpc_ich
[    4.935898] bus: 'pci': add driver RDC321x Southbridge
[    4.938374] bus: 'pci': add driver janz-cmodio
[    4.940535] bus: 'pci': add driver cs5535-mfd
[    4.942659] bus: 'spi': add driver tle62x0
[    4.944507] bus: 'platform': add driver pch-spi
[    4.946739] bus: 'pci': add driver pch_spi
[    4.948686] bus: 'hsi': add driver hsi_char
[    4.950630] HSI/SSI char device loaded
[    4.952313] I2O subsystem v1.325
[    4.953911] i2o: max drivers = 8
[    4.955392] bus: 'i2o': registered
[    4.957226] bus: 'i2o': add driver exec-osm
[    4.959129] bus: 'pci': add driver PCI_I2O
[    4.961144] I2O Configuration OSM v1.323
[    4.963017] bus: 'i2o': add driver config-osm
[    4.965127] I2O Bus Adapter OSM v1.317
[    4.966809] bus: 'i2o': add driver bus-osm
[    4.968732] I2O ProcFS OSM v1.316
[    4.970295] bus: 'i2o': add driver proc-osm
[    4.972210] bus: 'i2o': remove driver proc-osm
[    4.974364] driver: 'proc-osm': driver_release
[    4.976405] bus: 'pci': add driver nosy
[    4.978275] device class 'uio': registering
[    4.980159] bus: 'pci': add driver hilscher
[    4.982211] bus: 'platform': add driver uio_pdrv_genirq
[    4.984690] bus: 'pci': add driver aectc
[    4.992999] bus: 'pci': add driver sercos3
[    4.994886] bus: 'pnp': add driver i8042 kbd
[    4.996981] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[    5.000783] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[    5.007946] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    5.011035] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[    5.018493] bus: 'pnp': add driver i8042 aux
[    5.020445] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[    5.024208] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[    5.027692] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    5.030782] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[    5.034076] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    5.037829] Registering platform device 'i8042'. Parent at platform
[    5.040701] device: 'i8042': device_add
[    5.042496] bus: 'platform': add device i8042
[    5.044490] bus: 'platform': add driver i8042
[    5.046628] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    5.050397] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    5.055574] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.057942] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.060328] driver: 'i8042': driver_bound: bound to device 'i8042'
[    5.063271] device: 'serio0': device_add
[    5.065194] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    5.068402] parkbd: no such parport
[    5.071841] bus: 'platform': add driver altera_ps2
[    5.074218] bus: 'serio': add device serio0
[    5.081387] bus: 'pci': add driver Emu10k1_gameport
[    5.083615] bus: 'pci': add driver FM801_gameport
[    5.085900] bus: 'pnp': add driver ns558
[    5.271200] device: 'serio1': device_add
[    5.276727] bus: 'serio': add device serio1
[    5.278761] device: 'event0': device_add
[    5.286365] bus: 'serio': add driver atkbd
[    5.288294] bus: 'serio': add driver lkkbd
[    5.290300] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    5.293979] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    5.297385] bus: 'serio': add driver newtonkbd
[    5.306685] device: 'input1': device_add
[    5.308582] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    5.312539] device: 'event1': device_add
[    5.314494] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    5.323256] bus: 'platform': add driver omap4-keypad
[    5.325667] bus: 'platform': add driver opencores-kbd
[    5.327937] bus: 'serio': add driver stowaway
[    5.330130] bus: 'serio': add driver xtkbd
[    5.331969] bus: 'serio': add driver sermouse
[    5.340466] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    5.343710] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    5.347413] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    5.356885] bus: 'serio': add driver vsxxxaa
[    5.358910] bus: 'gameport': add driver adi
[    5.360992] bus: 'gameport': add driver cobra
[    5.362962] bus: 'gameport': add driver grip_mp
[    5.365151] bus: 'gameport': add driver guillemot
[    5.367314] bus: 'gameport': add driver interact
[    5.370019] atkbd: probe of serio1 rejects match -19
[    5.372356] bus: 'gameport': add driver joydump
[    5.374556] bus: 'serio': add driver magellan
[    5.376576] bus: 'gameport': add driver sidewinder
[    5.378861] bus: 'serio': add driver spaceorb
[    5.381100] bus: 'serio': add driver stinger
[    5.383043] bus: 'gameport': add driver tmdc
[    5.385113] bus: 'serio': add driver twidjoy
[    5.387072] bus: 'serio': add driver warrior
[    5.389165] bus: 'serio': add driver zhenhua
[    5.391096] bus: 'spi': add driver ad7879
[    5.393059] bus: 'serio': add driver hampshire
[    5.395074] bus: 'serio': add driver gunze
[    5.397088] bus: 'serio': add driver elo
[    5.398889] bus: 'serio': add driver touchit213
[    5.401246] bus: 'serio': add driver tsc40
[    5.403086] bus: 'spi': add driver tsc2005
[    5.405072] bus: 'platform': add driver rtc-bq4802
[    5.407236] bus: 'pnp': add driver rtc_cmos
[    5.409267] bus: 'pnp': driver_probe_device: matched device 00:01 with driver rtc_cmos
[    5.413058] bus: 'pnp': really_probe: probing driver rtc_cmos with device 00:01
[    5.416963] rtc (null): alarm rollover: day
[    5.418998] device: 'rtc0': device_add
[    5.420862] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    5.423852] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    5.426963] driver: '00:01': driver_bound: bound to device 'rtc_cmos'
[    5.430033] bus: 'pnp': really_probe: bound device 00:01 to driver rtc_cmos
[    5.433386] bus: 'platform': add driver rtc-ds1286
[    5.435550] bus: 'spi': add driver rtc-ds1390
[    5.437659] bus: 'platform': add driver ds1511
[    5.439666] bus: 'platform': add driver rtc-ds1553
[    5.442088] bus: 'spi': add driver ds3234
[    5.443889] bus: 'spi': add driver rtc-m41t93
[    5.445985] bus: 'platform': add driver rtc-m48t35
[    5.448151] bus: 'platform': add driver rtc-m48t59
[    5.450516] bus: 'spi': add driver rtc-pcf2123
[    5.452521] bus: 'platform': add driver rtc-rp5c01
[    5.454808] bus: 'platform': remove driver rtc-rp5c01
[    5.457387] driver: 'rtc-rp5c01': driver_release
[    5.459592] bus: 'spi': add driver rtc-rs5c348
[    5.461861] bus: 'platform': add driver rtc-test
[    5.464071] Registering platform device 'rtc-test.0'. Parent at platform
[    5.467255] device: 'rtc-test.0': device_add
[    5.469337] bus: 'platform': add device rtc-test.0
[    5.471630] bus: 'platform': driver_probe_device: matched device rtc-test.0 with driver rtc-test
[    5.475694] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.0
[    5.479486] device: 'rtc1': device_add
[    5.481404] Refined TSC clocksource calibration: 2666.760 MHz.
[    5.484037] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    5.486950] driver: 'rtc-test.0': driver_bound: bound to device 'rtc-test'
[    5.490311] bus: 'platform': really_probe: bound device rtc-test.0 to driver rtc-test
[    5.493953] Registering platform device 'rtc-test.1'. Parent at platform
[    5.497052] device: 'rtc-test.1': device_add
[    5.498981] bus: 'platform': add device rtc-test.1
[    5.501486] bus: 'platform': driver_probe_device: matched device rtc-test.1 with driver rtc-test
[    5.505588] bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.1
[    5.509351] device: 'rtc2': device_add
[    5.511168] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    5.514098] driver: 'rtc-test.1': driver_bound: bound to device 'rtc-test'
[    5.517332] bus: 'platform': really_probe: bound device rtc-test.1 to driver rtc-test
[    5.527282] Driver for 1-wire Dallas network protocol.
[    5.529809] bus: 'w1': registered
[    5.531690] bus: 'w1': add driver w1_master_driver
[    5.534102] bus: 'w1': add driver w1_slave_driver
[    5.536237] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.542402] bus: 'platform': add driver ds1wm
[    5.544520] bus: 'platform': add driver pda-power
[    5.547761] device: 'test_ac': device_add
[    5.549835] power_supply test_ac: power_supply_changed
[    5.552288] device: 'test_battery': device_add
[    5.554450] power_supply test_ac: power_supply_changed_work
[    5.557066] power_supply test_ac: power_supply_update_gen_leds 1
[    5.559871] power_supply test_battery: power_supply_changed
[    5.562670] bus: 'platform': add driver ds2781-battery
[    5.565120] bus: 'platform': add driver max8903-charger
[    5.567780] bus: 'spi': add driver lm70
[    5.569671] power_supply test_battery: power_supply_changed_work
[    5.572448] power_supply test_battery: power_supply_update_bat_leds 2
[    5.575518] bus: 'spi': add driver max1111
[    5.577620] bus: 'pci': add driver via686a
[    5.579486] bus: 'platform': add driver wm831x-hwmon
[    5.587160] bus: 'pci': add driver pcwd_pci
[    5.589240] bus: 'pci': add driver wdt_pci
[    5.591093] acquirewdt: WDT driver for Acquire single board computer initialising
[    5.594601] bus: 'platform': add driver acquirewdt
[    5.596875] Registering platform device 'acquirewdt'. Parent at platform
[    5.604299] device: 'acquirewdt': device_add
[    5.606407] bus: 'platform': add device acquirewdt
[    5.608282] bus: 'platform': driver_probe_device: matched device acquirewdt with driver acquirewdt
[    5.612984] bus: 'platform': really_probe: probing driver acquirewdt with device acquirewdt
[    5.622314] acquirewdt: I/O address 0x0043 already in use
[    5.624794] acquirewdt: probe of acquirewdt failed with error -5
[    5.627554] advantechwdt: WDT driver for Advantech single board computer initialising
[    5.631210] bus: 'platform': add driver advantechwdt
[    5.639230] Registering platform device 'advantechwdt'. Parent at platform
[    5.642556] device: 'advantechwdt': device_add
[    5.644589] bus: 'platform': add device advantechwdt
[    5.646972] bus: 'platform': driver_probe_device: matched device advantechwdt with driver advantechwdt
[    5.657296] bus: 'platform': really_probe: probing driver advantechwdt with device advantechwdt
[    5.661435] device: 'watchdog': device_add
[    5.663330] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[    5.666256] driver: 'advantechwdt': driver_bound: bound to device 'advantechwdt'
[    5.674984] bus: 'platform': really_probe: bound device advantechwdt to driver advantechwdt
[    5.678881] sp5100_tco: SP5100 TCO WatchDog Timer Driver v0.01
[    5.681650] bus: 'platform': add driver SP5100 TCO timer
[    5.684114] Registering platform device 'SP5100 TCO timer'. Parent at platform
[    5.694269] device: 'SP5100 TCO timer': device_add
[    5.696463] bus: 'platform': add device SP5100 TCO timer
[    5.699043] bus: 'platform': driver_probe_device: matched device SP5100 TCO timer with driver SP5100 TCO timer
[    5.703624] bus: 'platform': really_probe: probing driver SP5100 TCO timer with device SP5100 TCO timer
[    5.713520] SP5100 TCO timer: probe of SP5100 TCO timer rejects match -19
[    5.716551] bus: 'platform': add driver geodewdt
[    5.718832] Registering platform device 'geodewdt'. Parent at platform
[    5.725928] device: 'geodewdt': device_add
[    5.727786] bus: 'platform': add device geodewdt
[    5.730063] bus: 'platform': driver_probe_device: matched device geodewdt with driver geodewdt
[    5.740408] bus: 'platform': really_probe: probing driver geodewdt with device geodewdt
[    5.744109] geodewdt: No timers were available
[    5.746292] geodewdt: probe of geodewdt rejects match -19
[    5.748854] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.758649] eurotechwdt: can't misc_register on minor=130
[    5.761251] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
[    5.764870] wafer5823wdt: I/O address 0x0443 already in use
[    5.767438] bus: 'pci': add driver i6300ESB timer
[    5.769710] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver i6300ESB timer
[    5.779347] bus: 'pci': really_probe: probing driver i6300ESB timer with device 0000:00:0a.0
[    5.783289] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    5.786319] i6300esb: cannot register miscdev on minor=130 (err=-16)
[    5.796310] i6300ESB timer: probe of 0000:00:0a.0 failed with error -16
[    5.799415] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
[    5.802066] bus: 'platform': add driver iTCO_wdt
[    5.804158] iTCO_vendor_support: vendor-support=0
[    5.806536] sbc60xxwdt: I/O address 0x0443 already in use
[    5.814819] sbc8360: failed to register misc device
[    5.817279] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 initialising...
[    5.821991] smsc37b787_wdt: Unable to register miscdev on minor 130
[    5.831376] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    5.834338] w83697hf_wdt: watchdog not found at address 0x2e
[    5.837149] w83697hf_wdt: No W83697HF/HG could be found
[    5.839495] w83977f_wdt: driver v1.00
[    5.841319] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[    5.850237] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    5.853092] machzwd: no ZF-Logic found
[    5.854809] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
[    5.857927] bus: 'platform': add driver da9052-watchdog
[    5.860322] bus: 'platform': add driver wm831x-watchdog
[    5.869370] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[    5.873147] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[    5.876795] device: 'watchdog1': device_add
[    5.885144] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=1)
[    5.890194] bus: 'platform': add driver leds-ot200
[    5.892438] bus: 'platform': add driver da9052-leds
[    5.894797] bus: 'platform': add driver wm831x-status
[    5.897260] bus: 'spi': add driver dac124s085
[    5.906284] EFI Variables Facility v0.08 2004-May-17
[    5.908553] cs5535-clockevt: Could not allocate MFPGT timer
[    5.911215] bus: 'acpi': add driver cmpc_keys
[    5.913427] bus: 'acpi': add driver cmpc
[    5.915228] bus: 'acpi': add driver cmpc_tablet
[    5.923088] bus: 'acpi': add driver cmpc_accel
[    5.925271] hdaps: supported laptop not found!
[    5.927269] hdaps: driver init failed (ret=-19)!
[    5.929503] fujitsu_tablet: Unknown (using defaults)
[    5.931754] bus: 'acpi': add driver fujitsu-tablet
[    5.940546] bus: 'pci': add driver intel ips
[    5.942657] device class 'extcon': registering
[    5.944426] bus: 'vme': registered
[    5.946437] oprofile: using timer interrupt.
[    5.948547] 
[    5.948547] printing PIC contents
[    5.950859] ... PIC  IMR: ffff
[    5.952382] ... PIC  IRR: 1113
[    5.959773] ... PIC  ISR: 0000
[    5.961317] ... PIC ELCR: 0c00
[    5.962736] printing local APIC contents on CPU#0/0:
[    5.965082] ... APIC ID:      00000000 (0)
[    5.965299] ... APIC VERSION: 00050014
[    5.965299] ... APIC TASKPRI: 00000000 (00)
[    5.965299] ... APIC PROCPRI: 00000000
[    5.965299] ... APIC LDR: 01000000
[    5.965299] ... APIC DFR: ffffffff
[    5.965299] ... APIC SPIV: 000001ff
[    5.965299] ... APIC ISR field:
[    5.965299] 0000000000000000000000000000000000000000000000000000000000000000
[    5.965299] ... APIC TMR field:
[    5.965299] 0000000000000000000000000000000000000000000000000000000000000000
[    5.965299] ... APIC IRR field:
[    5.965299] 0000000000000000000000000000000000000000000000000000000000008000
[    5.965299] ... APIC ESR: 00000000
[    5.965299] ... APIC ICR: 00000831
[    5.965299] ... APIC ICR2: 01000000
[    5.965299] ... APIC LVTT: 000000ef
[    5.965299] ... APIC LVTPC: 00010000
[    5.965299] ... APIC LVT0: 00010700
[    5.965299] ... APIC LVT1: 00000400
[    5.965299] ... APIC LVTERR: 000000fe
[    5.965299] ... APIC TMICT: 000320c3
[    5.965299] ... APIC TMCCT: 00000000
[    5.965299] ... APIC TDCR: 00000003
[    5.965299] 
[    6.033866] number of MP IRQ sources: 15.
[    6.035675] number of IO-APIC #2 registers: 24.
[    6.044232] testing the IO APIC.......................
[    6.046699] 
[    6.047408] IO APIC #2......
[    6.048220] .... register #00: 00000000
[    6.050587] .......    : physical APIC id: 00
[    6.052575] .......    : Delivery Type: 0
[    6.060448] .......    : LTS          : 0
[    6.062374] .... register #01: 00170011
[    6.064083] .......     : max redirection entries: 17
[    6.066567] .......     : PRQ implemented: 0
[    6.068512] .......     : IO APIC version: 11
[    6.070593] .... register #02: 00000000
[    6.076757] .......     : arbitration: 00
[    6.078618] .... IRQ redirection table:
[    6.080351]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    6.086481]  00 00  1    0    0   0   0    0    0    00
[    6.089063]  01 01  0    0    0   0   0    1    1    31
[    6.091505]  02 01  0    0    0   0   0    1    1    30
[    6.100392]  03 01  0    0    0   0   0    1    1    33
[    6.102906]  04 01  1    0    0   0   0    1    1    34
[    6.105461]  05 01  1    1    0   0   0    1    1    35
[    6.113017]  06 01  0    0    0   0   0    1    1    36
[    6.115446]  07 01  0    0    0   0   0    1    1    37
[    6.118035]  08 01  0    0    0   0   0    1    1    38
[    6.120487]  09 01  0    1    0   0   0    1    1    39
[    6.123049]  0a 01  1    1    0   0   0    1    1    3A
[    6.131581]  0b 01  1    1    0   0   0    1    1    3B
[    6.134136]  0c 01  0    0    0   0   0    1    1    3C
[    6.136525]  0d 01  0    0    0   0   0    1    1    3D
[    6.139277]  0e 01  0    0    0   0   0    1    1    3E
[    6.141847]  0f 01  0    0    0   0   0    1    1    3F
[    6.151082]  10 00  1    0    0   0   0    0    0    00
[    6.153673]  11 00  1    0    0   0   0    0    0    00
[    6.156069]  12 00  1    0    0   0   0    0    0    00
[    6.158638]  13 00  1    0    0   0   0    0    0    00
[    6.167532]  14 00  1    0    0   0   0    0    0    00
[    6.170083]  15 00  1    0    0   0   0    0    0    00
[    6.172475]  16 00  1    0    0   0   0    0    0    00
[    6.175103]  17 00  1    0    0   0   0    0    0    00
[    6.181777] IRQ to pin mappings:
[    6.183240] IRQ0 -> 0:2
[    6.184202] IRQ1 -> 0:1
[    6.185837] IRQ3 -> 0:3
[    6.187070] IRQ4 -> 0:4
[    6.188309] IRQ5 -> 0:5
[    6.189685] IRQ6 -> 0:6
[    6.190921] IRQ7 -> 0:7
[    6.197948] IRQ8 -> 0:8
[    6.199174] IRQ9 -> 0:9
[    6.200383] IRQ10 -> 0:10
[    6.201829] IRQ11 -> 0:11
[    6.203128] IRQ12 -> 0:12
[    6.204442] IRQ13 -> 0:13
[    6.205899] IRQ14 -> 0:14
[    6.207212] IRQ15 -> 0:15
[    6.208515] .................................... done.
[    6.215699] device: 'cpu_dma_latency': device_add
[    6.218357] device: 'network_latency': device_add
[    6.220518] device: 'network_throughput': device_add
[    6.226664] IMA: No TPM chip found, activating TPM-bypass!
[    6.230774] bus: 'platform': add driver charger-manager
[    6.240048] bus: 'platform': add driver ie6xx_wdt
[    6.242341] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.245236] EDD information not available.
[    6.248114] debug: unmapping init [mem 0xffffffff81679000-0xffffffff816fafff]
[    6.325593] hostname (61) used greatest stack depth: 5360 bytes left
[    6.378836] sh (63) used greatest stack depth: 5312 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
[    6.621586] cut (73) used greatest stack depth: 5216 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   26.602710] warning: process `trinity-child0' used the deprecated sysctl system call with 
[   32.747503] general protection fault: 0000 [#1] DEBUG_PAGEALLOC
[   32.748700] CPU 0 
[   32.748700] Pid: 84, comm: trinity-child0 Not tainted 3.5.0-rc5+ #51 Bochs Bochs
[   32.748700] RIP: 0010:[<ffffffff8115a5bd>]  [<ffffffff8115a5bd>] strnlen+0xd/0x40
[   32.748700] RSP: 0018:ffff880005f87d08  EFLAGS: 00010286
[   32.748700] RAX: ffffffff81404ed8 RBX: ffff880005fa70e0 RCX: fffffffffffffffe
[   32.748700] RDX: 3a69706361000000 RSI: ffffffffffffffff RDI: 3a69706361000000
[   32.748700] RBP: ffff880005f87d08 R08: 000000000000ffff R09: 000000000000ffff
[   32.748700] R10: ffff880006e8b000 R11: ffff88000005ebc0 R12: 3a69706361000000
[   32.748700] R13: ffff880085fa70df R14: 000000000000ffff R15: 0000000000000000
[   32.748700] FS:  00007f177a9d2700(0000) GS:ffffffff81457000(0000) knlGS:0000000000000000
[   32.748700] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.748700] CR2: 0000000002f1b000 CR3: 0000000005f84000 CR4: 00000000000006b0
[   32.748700] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   32.748700] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   32.748700] Process trinity-child0 (pid: 84, threadinfo ffff880005f86000, task ffff880006f6c440)
[   32.748700] Stack:
[   32.748700]  ffff880005f87d48 ffffffff8115ba8e ffff880006e8b103 ffff880005fa70e0
[   32.748700]  ffff880085fa70df ffff880005f87de0 ffffffff813eb7c4 ffffffff813eb7c4
[   32.748700]  ffff880005f87dc8 ffffffff8115c569 ffff880005f87e08 ffffffff810730eb
[   32.748700] Call Trace:
[   32.748700]  [<ffffffff8115ba8e>] string.isra.4+0x3e/0xd0
[   32.748700]  [<ffffffff8115c569>] vsnprintf+0x219/0x600
[   32.748700]  [<ffffffff810730eb>] ? __lock_acquire.isra.31+0x3eb/0xb30
[   32.748700]  [<ffffffff8115cd30>] sprintf+0x40/0x50
[   32.748700]  [<ffffffff811f0dbe>] show_uevent+0xee/0x120
[   32.748700]  [<ffffffff811118fe>] ? sysfs_read_file+0x3e/0x1a0
[   32.748700]  [<ffffffff811f0c8b>] dev_attr_show+0x1b/0x60
[   32.748700]  [<ffffffff81111946>] ? sysfs_read_file+0x86/0x1a0
[   32.748700]  [<ffffffff8109d7e8>] ? __get_free_pages+0x18/0x80
[   32.748700]  [<ffffffff81111972>] sysfs_read_file+0xb2/0x1a0
[   32.748700]  [<ffffffff810cd14f>] vfs_read+0x9f/0x160
[   32.748700]  [<ffffffff810cd4c8>] sys_read+0x48/0x90
[   32.748700]  [<ffffffff812b6637>] system_call_fastpath+0x16/0x1b
[   32.748700] Code: c0 01 80 38 00 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 85 f6 48 8d 4e ff 48 89 e5 74 2a <80> 3f 00 74 25 48 89 f8 31 d2 eb 10 0f 1f 80 00 00 00 00 48 83 
[   32.748700] RIP  [<ffffffff8115a5bd>] strnlen+0xd/0x40
[   32.748700]  RSP <ffff880005f87d08>
[   32.896521] ---[ end trace 82a6bfb67a79ffb5 ]---
[   32.904508] trinity-child0 (84) used greatest stack depth: 5128 bytes left
[   34.569794] CPA self-test:
[   34.571888]  4k 65533 large 0 gb 0 x 65528[ffff880000000000-ffff88000fffc000] miss 0
[   34.613936]  4k 65533 large 0 gb 0 x 65528[ffff880000000000-ffff88000fffc000] miss 0
[   34.664534]  4k 65533 large 0 gb 0 x 65528[ffff880000000000-ffff88000fffc000] miss 0
[   34.674378] ok.

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.0-rc5+"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.0-rc5 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
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
# CONFIG_GENERIC_ISA_DMA is not set
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_ARCH_MAY_HAVE_PC_FDC is not set
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
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
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
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
CONFIG_SYSVIPC=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_FHANDLE=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_HOTPLUG is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
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
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_MCE_INJECT is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
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
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
# CONFIG_X86_PM_TIMER is not set
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

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
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
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
CONFIG_BQL=y

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
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
CONFIG_HP_ILO=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#

#
# Altera FPGA firmware download module
#
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
# CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_OMAP4=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_PCAP is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX3107=y
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_TLE62X0=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

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
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS1WM=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_MANAGER=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
CONFIG_SP5100_TCO=y
CONFIG_GEODE_WDT=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
CONFIG_EUROTECH_WDT=y
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=y
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_ABX500_CORE=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_CS5535=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_WM831X=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_RC_CORE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
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
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PCAP is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_BALLOON=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
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
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_STATS=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_IOMMU_DEBUG=y
CONFIG_IOMMU_STRESS=y
CONFIG_IOMMU_LEAK=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--xHFwDpU9dbj6ez1V--
