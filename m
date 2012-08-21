Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2HUBEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:04:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:58090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab2HUBEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:04:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,799,1336374000"; 
   d="scan'208";a="206988904"
Date: Tue, 21 Aug 2012 09:04:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org
Subject: BUG: NULL pointer dereference in shmem_evict_inode()
Message-ID: <20120821010403.GA12018@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

The below oops happens in v3.5..v3.6-rc2 and it's bisected down to commit
2a8c0883c ("time: Move xtime_nsec adjustment underflow handling timekeeping_adjust").

However linux-next is working fine. Do you have any fixes not yet sent to Linus?

[ 2221.089504] VFS: Busy inodes after unmount of tmpfs. Self-destruct in 5 seconds.  Have a nice day...
[ 2221.091656] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[ 2221.093256] IP: [<810d2a2c>] shmem_free_inode+0x10/0x45
[ 2221.093927] *pde = 00000000 
[ 2221.093927] Oops: 0000 [#1] DEBUG_PAGEALLOC
[ 2221.093927] Modules linked in:
[ 2221.093927] Pid: 1397, comm: udevd Not tainted 3.6.0-rc1 #24 Bochs Bochs
[ 2221.093927] EIP: 0060:[<810d2a2c>] EFLAGS: 00010246 CPU: 0
[ 2221.093927] EIP is at shmem_free_inode+0x10/0x45
[ 2221.093927] EAX: 8602e000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[ 2221.093927] ESI: 8ab91444 EDI: 8ab9143c EBP: 8ab61e58 ESP: 8ab61e50
[ 2221.093927]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 2221.093927] CR0: 8005003b CR2: 0000000c CR3: 0ab79000 CR4: 000006d0
[ 2221.093927] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 2221.093927] DR6: ffff0ff0 DR7: 00000400
[ 2221.093927] Process udevd (pid: 1397, ti=8ab60000 task=8abf0000 task.ti=8ab60000)
[ 2221.093927] Stack:
[ 2221.093927]  00000000 8ab91444 8ab61e70 810d5265 8ab9143c 8ab91444 8ab9153c 812eb998
[ 2221.093927]  8ab61e84 8111e85e 8ab91444 00000000 8602e000 8ab61e9c 8111ebf9 812eb998
[ 2221.093927]  8603a0e0 86140000 8ab91444 8ab61eb8 81138a6c 861400a4 8603a0f4 8603a0e0
[ 2221.093927] Call Trace:
[ 2221.093927]  [<810d5265>] shmem_evict_inode+0x158/0x167
[ 2221.093927]  [<8111e85e>] evict+0x125/0x239
[ 2221.093927]  [<8111ebf9>] iput+0x287/0x2e0
[ 2221.093927]  [<81138a6c>] fsnotify_destroy_mark+0x16f/0x1af
[ 2221.093927]  [<81138e33>] fsnotify_clear_marks_by_group_flags+0xba/0xd8
[ 2221.093927]  [<81138e61>] fsnotify_clear_marks_by_group+0x10/0x12
[ 2221.093927]  [<8113a009>] inotify_release+0x16/0x22
[ 2221.093927]  [<81100248>] __fput+0x1a1/0x450
[ 2221.093927]  [<81100504>] ____fput+0xd/0xf
[ 2221.093927]  [<8105a7f5>] task_work_run+0x74/0x83
[ 2221.093927]  [<8103d025>] do_exit+0x374/0xb44
[ 2221.093927]  [<81189255>] ? do_raw_spin_unlock+0xd1/0x108
[ 2221.093927]  [<8103db0f>] do_group_exit+0xfd/0xfd
[ 2221.093927]  [<8103db27>] sys_exit_group+0x18/0x18
[ 2221.093927]  [<812cb523>] sysenter_do_call+0x12/0x3c
[ 2221.093927] Code: 1f 00 b8 e4 ff ff ff eb 0d 4a 89 f0 89 53 10 e8 51 82 1f 00 31 c0 5b 5e 5f 5d c3 55 89 e5 56 53 e8 66 90 1f 00 8b 98 c4 03 00 00 <83> 7b 0c 00 0f 95 c0 0f b6 d0 8b 0c 95 a4 38 67 81 41 84 c0 89
[ 2221.093927] EIP: [<810d2a2c>] shmem_free_inode+0x10/0x45 SS:ESP 0068:8ab61e50
[ 2221.093927] CR2: 000000000000000c

Thanks,
Fengguang

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-bens-3070-2012-08-19-15-19-48-3.6.0-rc1-24"

[    0.000000] Linux version 3.6.0-rc1 (kbuild@bee) (gcc version 4.7.1 (Debian 4.7.1-6) ) #24 Sun Aug 19 15:17:47 CST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [800fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [8008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x023bd000-0x023fffff]
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 1000000, base 00000000, limit 00000000)
[    0.000000] cma: CMA: reserved 16 MiB at 0d000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128920(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:14b3701, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat 81620008, node_mem_map 8e4bf280
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64769 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 14b3680
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64769
[    0.000000] Kernel command line: trinity=2m hung_task_panic=1 branch=ext4/origin log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2012-08-19-15-18-42-ext4:origin:89a4e48-89a4e48-i386-randconfig-b845-4-bens BOOT_IMAGE=kernel-tests/kernels/i386-randconfig-b845/89a4e48/vmlinuz-3.6.0-rc1
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 195804k/262136k available (2864k kernel code, 65832k reserved, 4308k data, 428k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8d000 - 0xfffff000   ( 456 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff7fe000   (1776 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x81702000 - 0x8176d000   ( 428 kB)
[    0.000000]       .data : 0x812cc24b - 0x81701340   (4308 kB)
[    0.000000]       .text : 0x81000000 - 0x812cc24b   (2864 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=8e006000 soft=8e008000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 6 of 6 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.696 MHz processor
[    0.010000] Calibrating delay loop (skipped) preset value.. 5333.39 BogoMIPS (lpj=26666960)
[    0.010000] pid_max: default: 4096 minimum: 301
[    0.010000] Security Framework initialized
[    0.010000] Yama: becoming mindful.
[    0.010000] Mount-cache hash table entries: 512
[    0.010000] mce: CPU supports 10 MCE banks
[    0.010000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010000] tlb_flushall_shift is 0x6
[    0.010019] CPU: Intel Common KVM processor stepping 01
[    0.014345] ACPI: Core revision 20120711
[    0.020715] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.023473] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.024392] Getting VERSION: 50014
[    0.024980] Getting VERSION: 50014
[    0.025563] Getting ID: 0
[    0.026015] Getting ID: f000000
[    0.026555] Getting LVT0: 8700
[    0.027073] Getting LVT1: 8400
[    0.027785] enabled ExtINT on CPU#0
[    0.029777] ENABLING IO-APIC IRQs
[    0.030017] init IO_APIC IRQs
[    0.030529]  apic 2 pin 0 not connected
[    0.031212] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.032552] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.033888] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.035235] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.036566] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.037904] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.039242] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.040033] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.041352] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.042675] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.044026] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.045376] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.046730] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.048082] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.050032] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.051381]  apic 2 pin 16 not connected
[    0.052030]  apic 2 pin 17 not connected
[    0.052695]  apic 2 pin 18 not connected
[    0.053352]  apic 2 pin 19 not connected
[    0.054003]  apic 2 pin 20 not connected
[    0.054659]  apic 2 pin 21 not connected
[    0.055316]  apic 2 pin 22 not connected
[    0.055966]  apic 2 pin 23 not connected
[    0.056781] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057923] Using local APIC timer interrupts.
[    0.057923] calibrating APIC timer ...
[    0.060000] ... lapic delta = 6249806
[    0.060000] ... PM-Timer delta = 357942
[    0.060000] ... PM-Timer result ok
[    0.060000] ..... delta 6249806
[    0.060000] ..... mult: 268427123
[    0.060000] ..... calibration result: 9999689
[    0.060000] ..... CPU clock speed is 2666.5793 MHz.
[    0.060000] ..... host bus clock speed is 999.9689 MHz.
[    0.060000] device: 'platform': device_add
[    0.060000] PM: Adding info for No Bus:platform
[    0.060000] bus: 'platform': registered
[    0.060000] bus: 'cpu': registered
[    0.060000] device: 'cpu': device_add
[    0.060000] PM: Adding info for No Bus:cpu
[    0.060000] device class 'regulator': registering
[    0.060000] Registering platform device 'reg-dummy'. Parent at platform
[    0.060000] device: 'reg-dummy': device_add
[    0.060000] bus: 'platform': add device reg-dummy
[    0.060056] PM: Adding info for platform:reg-dummy
[    0.060980] bus: 'platform': add driver reg-dummy
[    0.061997] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.063431] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.065208] device: 'regulator.0': device_add
[    0.066224] PM: Adding info for No Bus:regulator.0
[    0.067324] dummy: 
[    0.067888] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.069370] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.070043] cma: cma_init_reserved_areas()
[    0.070928] cma: cma_create_area(base 0000d000, count 1000)
[    0.075513] cma: cma_create_area: returned 8e000540
[    0.076703] NET: Registered protocol family 16
[    0.077851] device class 'bdi': registering
[    0.080015] device class 'pci_bus': registering
[    0.081043] bus: 'pci': registered
[    0.081779] device class 'tty': registering
[    0.082794] bus: 'spi': registered
[    0.083547] device class 'spi_master': registering
[    0.084801] ACPI: bus type pci registered
[    0.085863] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.087254] PCI: Using configuration type 1 for base access
[    0.088546] device: 'cpu0': device_add
[    0.089358] bus: 'cpu': add device cpu0
[    0.090027] PM: Adding info for cpu:cpu0
[    0.092310] device: 'default': device_add
[    0.093215] PM: Adding info for No Bus:default
[    0.094358] bus: 'platform': add driver stmpe-gpio
[    0.095408] ACPI: Added _OSI(Module Device)
[    0.096224] ACPI: Added _OSI(Processor Device)
[    0.097098] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.098101] ACPI: Added _OSI(Processor Aggregator Device)
[    0.103091] ACPI: EC: Look up EC in DSDT
[    0.114848] ACPI: Interpreter enabled
[    0.115520] ACPI: (supports S0 S3 S5)
[    0.116372] ACPI: Using IOAPIC for interrupt routing
[    0.117367] bus: 'acpi': registered
[    0.117960] bus: 'acpi': add driver power
[    0.118695] device: 'LNXSYSTM:00': device_add
[    0.119435] bus: 'acpi': add device LNXSYSTM:00
[    0.120026] PM: Adding info for acpi:LNXSYSTM:00
[    0.121097] device: 'device:00': device_add
[    0.121892] bus: 'acpi': add device device:00
[    0.122675] PM: Adding info for acpi:device:00
[    0.123765] device: 'PNP0A03:00': device_add
[    0.124726] bus: 'acpi': add device PNP0A03:00
[    0.125700] PM: Adding info for acpi:PNP0A03:00
[    0.127851] device: 'device:01': device_add
[    0.128758] bus: 'acpi': add device device:01
[    0.129738] PM: Adding info for acpi:device:01
[    0.130157] device: 'device:02': device_add
[    0.131089] bus: 'acpi': add device device:02
[    0.132103] PM: Adding info for acpi:device:02
[    0.133219] device: 'PNP0B00:00': device_add
[    0.134154] bus: 'acpi': add device PNP0B00:00
[    0.135150] PM: Adding info for acpi:PNP0B00:00
[    0.136353] device: 'PNP0303:00': device_add
[    0.137264] bus: 'acpi': add device PNP0303:00
[    0.138023] PM: Adding info for acpi:PNP0303:00
[    0.139032] device: 'PNP0F13:00': device_add
[    0.140013] bus: 'acpi': add device PNP0F13:00
[    0.140777] PM: Adding info for acpi:PNP0F13:00
[    0.141770] device: 'PNP0700:00': device_add
[    0.142632] bus: 'acpi': add device PNP0700:00
[    0.143400] PM: Adding info for acpi:PNP0700:00
[    0.144569] device: 'PNP0400:00': device_add
[    0.145485] bus: 'acpi': add device PNP0400:00
[    0.146293] PM: Adding info for acpi:PNP0400:00
[    0.147383] device: 'PNP0501:00': device_add
[    0.148108] bus: 'acpi': add device PNP0501:00
[    0.148866] PM: Adding info for acpi:PNP0501:00
[    0.150255] device: 'device:03': device_add
[    0.150965] bus: 'acpi': add device device:03
[    0.151714] PM: Adding info for acpi:device:03
[    0.152669] device: 'device:04': device_add
[    0.153372] bus: 'acpi': add device device:04
[    0.154123] PM: Adding info for acpi:device:04
[    0.155164] device: 'device:05': device_add
[    0.156066] bus: 'acpi': add device device:05
[    0.157084] PM: Adding info for acpi:device:05
[    0.158202] device: 'device:06': device_add
[    0.159131] bus: 'acpi': add device device:06
[    0.160026] PM: Adding info for acpi:device:06
[    0.161196] device: 'device:07': device_add
[    0.162087] bus: 'acpi': add device device:07
[    0.163066] PM: Adding info for acpi:device:07
[    0.164179] device: 'device:08': device_add
[    0.165107] bus: 'acpi': add device device:08
[    0.166080] PM: Adding info for acpi:device:08
[    0.167192] device: 'device:09': device_add
[    0.168098] bus: 'acpi': add device device:09
[    0.169091] PM: Adding info for acpi:device:09
[    0.170171] device: 'device:0a': device_add
[    0.170982] bus: 'acpi': add device device:0a
[    0.171732] PM: Adding info for acpi:device:0a
[    0.172639] device: 'device:0b': device_add
[    0.173346] bus: 'acpi': add device device:0b
[    0.174087] PM: Adding info for acpi:device:0b
[    0.174988] device: 'device:0c': device_add
[    0.175851] bus: 'acpi': add device device:0c
[    0.176831] PM: Adding info for acpi:device:0c
[    0.177969] device: 'device:0d': device_add
[    0.178914] bus: 'acpi': add device device:0d
[    0.180027] PM: Adding info for acpi:device:0d
[    0.181141] device: 'device:0e': device_add
[    0.182033] bus: 'acpi': add device device:0e
[    0.183007] PM: Adding info for acpi:device:0e
[    0.184181] device: 'device:0f': device_add
[    0.185117] bus: 'acpi': add device device:0f
[    0.186103] PM: Adding info for acpi:device:0f
[    0.187245] device: 'device:10': device_add
[    0.188174] bus: 'acpi': add device device:10
[    0.189146] PM: Adding info for acpi:device:10
[    0.190265] device: 'device:11': device_add
[    0.191193] bus: 'acpi': add device device:11
[    0.192140] PM: Adding info for acpi:device:11
[    0.193281] device: 'device:12': device_add
[    0.194176] bus: 'acpi': add device device:12
[    0.195156] PM: Adding info for acpi:device:12
[    0.196298] device: 'device:13': device_add
[    0.197194] bus: 'acpi': add device device:13
[    0.198164] PM: Adding info for acpi:device:13
[    0.199281] device: 'device:14': device_add
[    0.200013] bus: 'acpi': add device device:14
[    0.201001] PM: Adding info for acpi:device:14
[    0.202117] device: 'device:15': device_add
[    0.203020] bus: 'acpi': add device device:15
[    0.204000] PM: Adding info for acpi:device:15
[    0.205143] device: 'device:16': device_add
[    0.206044] bus: 'acpi': add device device:16
[    0.207017] PM: Adding info for acpi:device:16
[    0.208218] device: 'device:17': device_add
[    0.209153] bus: 'acpi': add device device:17
[    0.210026] PM: Adding info for acpi:device:17
[    0.211133] device: 'device:18': device_add
[    0.212001] bus: 'acpi': add device device:18
[    0.213017] PM: Adding info for acpi:device:18
[    0.214140] device: 'device:19': device_add
[    0.215071] bus: 'acpi': add device device:19
[    0.216047] PM: Adding info for acpi:device:19
[    0.217182] device: 'device:1a': device_add
[    0.218086] bus: 'acpi': add device device:1a
[    0.219059] PM: Adding info for acpi:device:1a
[    0.220168] device: 'device:1b': device_add
[    0.221068] bus: 'acpi': add device device:1b
[    0.221865] PM: Adding info for acpi:device:1b
[    0.222973] device: 'device:1c': device_add
[    0.223747] bus: 'acpi': add device device:1c
[    0.224540] PM: Adding info for acpi:device:1c
[    0.225532] device: 'device:1d': device_add
[    0.226324] bus: 'acpi': add device device:1d
[    0.227288] PM: Adding info for acpi:device:1d
[    0.228239] device: 'device:1e': device_add
[    0.229144] bus: 'acpi': add device device:1e
[    0.230026] PM: Adding info for acpi:device:1e
[    0.231029] device: 'device:1f': device_add
[    0.231789] bus: 'acpi': add device device:1f
[    0.232624] PM: Adding info for acpi:device:1f
[    0.233717] device: 'device:20': device_add
[    0.234632] bus: 'acpi': add device device:20
[    0.235633] PM: Adding info for acpi:device:20
[    0.236668] device: 'device:21': device_add
[    0.237375] bus: 'acpi': add device device:21
[    0.238219] PM: Adding info for acpi:device:21
[    0.240168] device: 'device:22': device_add
[    0.241074] bus: 'acpi': add device device:22
[    0.242031] PM: Adding info for acpi:device:22
[    0.243359] device: 'PNP0103:00': device_add
[    0.244315] bus: 'acpi': add device PNP0103:00
[    0.245286] PM: Adding info for acpi:PNP0103:00
[    0.246660] device: 'PNP0C0F:00': device_add
[    0.247577] bus: 'acpi': add device PNP0C0F:00
[    0.248431] PM: Adding info for acpi:PNP0C0F:00
[    0.249520] device: 'PNP0C0F:01': device_add
[    0.250013] bus: 'acpi': add device PNP0C0F:01
[    0.250984] PM: Adding info for acpi:PNP0C0F:01
[    0.252253] device: 'PNP0C0F:02': device_add
[    0.253168] bus: 'acpi': add device PNP0C0F:02
[    0.254021] PM: Adding info for acpi:PNP0C0F:02
[    0.255358] device: 'PNP0C0F:03': device_add
[    0.256122] bus: 'acpi': add device PNP0C0F:03
[    0.257119] PM: Adding info for acpi:PNP0C0F:03
[    0.258432] device: 'PNP0C0F:04': device_add
[    0.259351] bus: 'acpi': add device PNP0C0F:04
[    0.260027] PM: Adding info for acpi:PNP0C0F:04
[    0.261011] device: 'LNXCPU:00': device_add
[    0.261726] bus: 'acpi': add device LNXCPU:00
[    0.262613] PM: Adding info for acpi:LNXCPU:00
[    0.263557] device: 'LNXCPU:01': device_add
[    0.264345] bus: 'acpi': add device LNXCPU:01
[    0.265298] PM: Adding info for acpi:LNXCPU:01
[    0.266280] device: 'device:23': device_add
[    0.267015] bus: 'acpi': add device device:23
[    0.267784] PM: Adding info for acpi:device:23
[    0.268742] device: 'LNXPWRBN:00': device_add
[    0.270013] bus: 'acpi': add device LNXPWRBN:00
[    0.270858] PM: Adding info for acpi:LNXPWRBN:00
[    0.272190] bus: 'acpi': add driver ec
[    0.272990] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.274850] bus: 'acpi': add driver pci_root
[    0.275594] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
[    0.277295] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
[    0.278908] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.280051] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.281409] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.282945] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.284681] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.286141] PCI: root bus 00: using default resources
[    0.286993] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.288934] device: 'pci0000:00': device_add
[    0.290088] PM: Adding info for No Bus:pci0000:00
[    0.290892] device: '0000:00': device_add
[    0.291602] PM: Adding info for No Bus:0000:00
[    0.292369] PCI host bridge to bus 0000:00
[    0.293061] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    0.294551] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.295715] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.297028] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.298544] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.300189] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.302178] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.305246] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.307361] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.309289] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.310023] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.311526] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.314946] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.317201] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.323745] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.325702] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.327107] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.328802] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.333412] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.335109] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.336735] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.338602] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.344089] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.345827] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.347663] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.353085] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.354763] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.356625] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.362078] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.363796] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.365624] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.371133] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.372828] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.374663] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.380076] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.381614] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.383240] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.388489] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.389950] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.392837] pci_bus 0000:00: on NUMA node 0
[    0.393822] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.397974]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.400024] device: '0000:00:00.0': device_add
[    0.403189] bus: 'pci': add device 0000:00:00.0
[    0.404513] PM: Adding info for pci:0000:00:00.0
[    0.405600] device: '0000:00:01.0': device_add
[    0.408724] bus: 'pci': add device 0000:00:01.0
[    0.410068] PM: Adding info for pci:0000:00:01.0
[    0.411071] device: '0000:00:01.1': device_add
[    0.414129] bus: 'pci': add device 0000:00:01.1
[    0.415242] PM: Adding info for pci:0000:00:01.1
[    0.416272] device: '0000:00:01.3': device_add
[    0.419378] bus: 'pci': add device 0000:00:01.3
[    0.420066] PM: Adding info for pci:0000:00:01.3
[    0.420884] device: '0000:00:02.0': device_add
[    0.423829] bus: 'pci': add device 0000:00:02.0
[    0.424728] PM: Adding info for pci:0000:00:02.0
[    0.425706] device: '0000:00:03.0': device_add
[    0.428812] bus: 'pci': add device 0000:00:03.0
[    0.430118] PM: Adding info for pci:0000:00:03.0
[    0.431124] device: '0000:00:04.0': device_add
[    0.434189] bus: 'pci': add device 0000:00:04.0
[    0.435067] PM: Adding info for pci:0000:00:04.0
[    0.436071] device: '0000:00:05.0': device_add
[    0.439176] bus: 'pci': add device 0000:00:05.0
[    0.440113] PM: Adding info for pci:0000:00:05.0
[    0.440930] device: '0000:00:06.0': device_add
[    0.443867] bus: 'pci': add device 0000:00:06.0
[    0.444927] PM: Adding info for pci:0000:00:06.0
[    0.445935] device: '0000:00:07.0': device_add
[    0.448913] bus: 'pci': add device 0000:00:07.0
[    0.450067] PM: Adding info for pci:0000:00:07.0
[    0.451093] device: '0000:00:08.0': device_add
[    0.454223] bus: 'pci': add device 0000:00:08.0
[    0.455333] PM: Adding info for pci:0000:00:08.0
[    0.456366] device: '0000:00:09.0': device_add
[    0.460305] bus: 'pci': add device 0000:00:09.0
[    0.461386] PM: Adding info for pci:0000:00:09.0
[    0.462393] device: '0000:00:0a.0': device_add
[    0.465528] bus: 'pci': add device 0000:00:0a.0
[    0.466558] PM: Adding info for pci:0000:00:0a.0
[    0.467585] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
[    0.469042] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
[    0.470099] bus: 'acpi': add driver pci_link
[    0.471049] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    0.472795] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    0.474698] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.476146] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    0.477347] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    0.478658] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    0.480007] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    0.481534] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.482839] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    0.483976] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    0.485214] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    0.486675] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    0.488172] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.490311] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    0.491768] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    0.493097] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    0.494473] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    0.496209] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.497539] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    0.498669] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    0.500010] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    0.501785] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    0.503245] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.504520] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    0.505723] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    0.507074] bus: 'pnp': registered
[    0.507674] device class 'misc': registering
[    0.508490] device: 'vga_arbiter': device_add
[    0.509330] PM: Adding info for No Bus:vga_arbiter
[    0.510082] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.511770] vgaarb: loaded
[    0.512344] vgaarb: bridge control possible 0000:00:02.0
[    0.513483] bus: 'spi': add driver wm831x
[    0.514362] bus: 'spi': add driver tps65912
[    0.515297] bus: 'serio': registered
[    0.515961] device class 'input': registering
[    0.516728] device class 'rtc': registering
[    0.517438] device class 'power_supply': registering
[    0.518313] device class 'watchdog': registering
[    0.519391] PCI: Using ACPI for IRQ routing
[    0.520013] PCI: pci_cache_line_size set to 64 bytes
[    0.521569] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.522857] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.523998] device class 'net': registering
[    0.524805] device: 'lo': device_add
[    0.525587] PM: Adding info for No Bus:lo
[    0.526736] Switching to clocksource kvm-clock
[    0.528334] Warning: could not register all branches stats
[    0.529517] Warning: could not register annotated branches stats
[    0.594638] bus: 'pnp': add driver system
[    0.595425] pnp: PnP ACPI init
[    0.596063] device: 'pnp0': device_add
[    0.596728] PM: Adding info for No Bus:pnp0
[    0.597557] ACPI: bus type pnp registered
[    0.598466] pnp 00:00: [bus 00-ff]
[    0.599294] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.600122] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.600907] pnp 00:00: [io  0x0d00-0xffff window]
[    0.601714] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.602834] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.603744] device: '00:00': device_add
[    0.604529] bus: 'pnp': add device 00:00
[    0.605216] PM: Adding info for pnp:00:00
[    0.605919] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.607112] pnp 00:01: [io  0x0070-0x0071]
[    0.607819] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.609372] pnp 00:01: [irq 8]
[    0.610049] pnp 00:01: [io  0x0072-0x0077]
[    0.610955] device: '00:01': device_add
[    0.611907] bus: 'pnp': add device 00:01
[    0.612796] PM: Adding info for pnp:00:01
[    0.613688] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.615195] pnp 00:02: [io  0x0060]
[    0.615971] pnp 00:02: [io  0x0064]
[    0.616745] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.618488] pnp 00:02: [irq 1]
[    0.619157] device: '00:02': device_add
[    0.620042] bus: 'pnp': add device 00:02
[    0.620923] PM: Adding info for pnp:00:02
[    0.621865] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.623198] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.624891] pnp 00:03: [irq 12]
[    0.625423] device: '00:03': device_add
[    0.626100] bus: 'pnp': add device 00:03
[    0.626868] PM: Adding info for pnp:00:03
[    0.627758] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.629229] pnp 00:04: [io  0x03f2-0x03f5]
[    0.630007] pnp 00:04: [io  0x03f7]
[    0.630651] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.632185] pnp 00:04: [irq 6]
[    0.632856] pnp 00:04: [dma 2]
[    0.633533] device: '00:04': device_add
[    0.634407] bus: 'pnp': add device 00:04
[    0.635190] PM: Adding info for pnp:00:04
[    0.636014] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.637455] pnp 00:05: [io  0x0378-0x037f]
[    0.638140] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.639472] pnp 00:05: [irq 7]
[    0.639992] device: '00:05': device_add
[    0.640735] bus: 'pnp': add device 00:05
[    0.641435] PM: Adding info for pnp:00:05
[    0.642137] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.643462] pnp 00:06: [io  0x03f8-0x03ff]
[    0.644228] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.645708] pnp 00:06: [irq 4]
[    0.646388] device: '00:06': device_add
[    0.647233] bus: 'pnp': add device 00:06
[    0.648129] PM: Adding info for pnp:00:06
[    0.649024] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.651095] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.652168] device: '00:07': device_add
[    0.653127] bus: 'pnp': add device 00:07
[    0.654069] PM: Adding info for pnp:00:07
[    0.654954] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.656845] pnp: PnP ACPI: found 8 devices
[    0.657549] ACPI: ACPI bus type pnp unregistered
[    0.658322] device class 'mem': registering
[    0.659038] device: 'mem': device_add
[    0.659749] PM: Adding info for No Bus:mem
[    0.660469] device: 'null': device_add
[    0.661208] PM: Adding info for No Bus:null
[    0.661945] device: 'port': device_add
[    0.662707] PM: Adding info for No Bus:port
[    0.663678] device: 'zero': device_add
[    0.664485] PM: Adding info for No Bus:zero
[    0.665267] device: 'full': device_add
[    0.666095] PM: Adding info for No Bus:full
[    0.667044] device: 'random': device_add
[    0.667953] PM: Adding info for No Bus:random
[    0.668907] device: 'urandom': device_add
[    0.669866] PM: Adding info for No Bus:urandom
[    0.670843] device: 'kmsg': device_add
[    0.671719] PM: Adding info for No Bus:kmsg
[    0.672449] device: 'oldmem': device_add
[    0.673137] PM: Adding info for No Bus:oldmem
[    0.673885] device: 'tty': device_add
[    0.674571] PM: Adding info for No Bus:tty
[    0.675330] device: 'console': device_add
[    0.676096] PM: Adding info for No Bus:console
[    0.676864] device class 'thermal': registering
[    0.712550] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.713578] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.714940] NET: Registered protocol family 1
[    0.715917] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.717174] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.718448] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.719814] pci 0000:00:02.0: Boot video device
[    0.720954] PCI: CLS 0 bytes, default 64
[    0.721980] Unpacking initramfs...
[    3.863369] debug: unmapping init [mem 0x8e73f000-0x8ffeffff]
[    3.924834] DMA-API: preallocated 32768 debug entries
[    3.925926] DMA-API: debugging enabled by kernel config
[    3.927547] bus: 'clocksource': registered
[    3.928469] device: 'clocksource': device_add
[    3.929457] PM: Adding info for No Bus:clocksource
[    3.930328] device: 'clocksource0': device_add
[    3.931155] bus: 'clocksource': add device clocksource0
[    3.932309] PM: Adding info for clocksource:clocksource0
[    3.933514] bus: 'platform': add driver alarmtimer
[    3.934563] Registering platform device 'alarmtimer'. Parent at platform
[    3.935932] device: 'alarmtimer': device_add
[    3.936656] bus: 'platform': add device alarmtimer
[    3.937486] PM: Adding info for platform:alarmtimer
[    3.938307] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    3.939956] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    3.941327] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    3.942738] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    3.944687] bus: 'event_source': registered
[    3.945729] device: 'breakpoint': device_add
[    3.946682] bus: 'event_source': add device breakpoint
[    3.947950] PM: Adding info for event_source:breakpoint
[    3.949118] device: 'tracepoint': device_add
[    3.950054] bus: 'event_source': add device tracepoint
[    3.951185] PM: Adding info for event_source:tracepoint
[    3.952354] device: 'software': device_add
[    3.953249] bus: 'event_source': add device software
[    3.954312] PM: Adding info for event_source:software
[    3.962135] VFS: Disk quotas dquot_6.5.2
[    3.963264] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.965182] cryptomgr_test (16) used greatest stack depth: 7476 bytes left
[    3.967696] bus: 'acpi': add driver ac
[    3.968593] bus: 'acpi': add driver button
[    3.969357] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    3.971055] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    3.972817] device: 'input0': device_add
[    3.973870] PM: Adding info for No Bus:input0
[    3.974646] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.976064] ACPI: Power Button [PWRF]
[    3.976736] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    3.978005] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    3.979415] bus: 'acpi': add driver fan
[    3.980420] bus: 'acpi': add driver processor
[    3.981264] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
[    3.982909] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
[    3.984691] device: 'cooling_device0': device_add
[    3.985630] PM: Adding info for No Bus:cooling_device0
[    3.986564] driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
[    3.987987] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
[    3.989399] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 with driver processor
[    3.990878] bus: 'acpi': really_probe: probing driver processor with device LNXCPU:01
[    3.992753] driver: 'LNXCPU:01': driver_bound: bound to device 'processor'
[    3.994125] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver processor
[    3.995666] bus: 'acpi': add driver thermal
[    3.996826] device: 'ptyp0': device_add
[    3.997523] PM: Adding info for No Bus:ptyp0
[    3.998256] device: 'ptyp1': device_add
[    3.998938] PM: Adding info for No Bus:ptyp1
[    3.999670] device: 'ptyp2': device_add
[    4.000594] PM: Adding info for No Bus:ptyp2
[    4.001348] device: 'ptyp3': device_add
[    4.002052] bus: 'acpi': add driver battery
[    4.002995] PM: Adding info for No Bus:ptyp3
[    4.004041] device: 'ptyp4': device_add
[    4.004911] PM: Adding info for No Bus:ptyp4
[    4.005863] device: 'ptyp5': device_add
[    4.006734] PM: Adding info for No Bus:ptyp5
[    4.007709] device: 'ptyp6': device_add
[    4.008685] PM: Adding info for No Bus:ptyp6
[    4.009626] device: 'ptyp7': device_add
[    4.010325] PM: Adding info for No Bus:ptyp7
[    4.011061] device: 'ptyp8': device_add
[    4.011761] PM: Adding info for No Bus:ptyp8
[    4.012511] device: 'ptyp9': device_add
[    4.013491] PM: Adding info for No Bus:ptyp9
[    4.014301] device: 'ptypa': device_add
[    4.014983] PM: Adding info for No Bus:ptypa
[    4.015712] device: 'ptypb': device_add
[    4.016528] PM: Adding info for No Bus:ptypb
[    4.017430] device: 'ptypc': device_add
[    4.018295] PM: Adding info for No Bus:ptypc
[    4.019132] device: 'ptypd': device_add
[    4.019922] PM: Adding info for No Bus:ptypd
[    4.020657] device: 'ptype': device_add
[    4.021336] PM: Adding info for No Bus:ptype
[    4.022088] device: 'ptypf': device_add
[    4.022852] PM: Adding info for No Bus:ptypf
[    4.023586] device: 'ptyq0': device_add
[    4.024260] PM: Adding info for No Bus:ptyq0
[    4.025075] device: 'ptyq1': device_add
[    4.025977] PM: Adding info for No Bus:ptyq1
[    4.026957] device: 'ptyq2': device_add
[    4.027826] PM: Adding info for No Bus:ptyq2
[    4.028769] device: 'ptyq3': device_add
[    4.029458] PM: Adding info for No Bus:ptyq3
[    4.030512] device: 'ptyq4': device_add
[    4.031244] PM: Adding info for No Bus:ptyq4
[    4.032174] device: 'ptyq5': device_add
[    4.033165] PM: Adding info for No Bus:ptyq5
[    4.034131] device: 'ptyq6': device_add
[    4.035009] PM: Adding info for No Bus:ptyq6
[    4.035956] device: 'ptyq7': device_add
[    4.036820] PM: Adding info for No Bus:ptyq7
[    4.037748] device: 'ptyq8': device_add
[    4.038434] PM: Adding info for No Bus:ptyq8
[    4.039359] device: 'ptyq9': device_add
[    4.040342] PM: Adding info for No Bus:ptyq9
[    4.041279] device: 'ptyqa': device_add
[    4.042070] PM: Adding info for No Bus:ptyqa
[    4.042812] device: 'ptyqb': device_add
[    4.043641] PM: Adding info for No Bus:ptyqb
[    4.044516] device: 'ptyqc': device_add
[    4.045197] PM: Adding info for No Bus:ptyqc
[    4.046094] device: 'ptyqd': device_add
[    4.047046] PM: Adding info for No Bus:ptyqd
[    4.047782] device: 'ptyqe': device_add
[    4.048465] PM: Adding info for No Bus:ptyqe
[    4.049190] device: 'ptyqf': device_add
[    4.049882] PM: Adding info for No Bus:ptyqf
[    4.050613] device: 'ptyr0': device_add
[    4.051408] PM: Adding info for No Bus:ptyr0
[    4.052237] device: 'ptyr1': device_add
[    4.053019] PM: Adding info for No Bus:ptyr1
[    4.053748] device: 'ptyr2': device_add
[    4.054463] PM: Adding info for No Bus:ptyr2
[    4.055535] device: 'ptyr3': device_add
[    4.056420] PM: Adding info for No Bus:ptyr3
[    4.057455] device: 'ptyr4': device_add
[    4.058437] PM: Adding info for No Bus:ptyr4
[    4.059371] device: 'ptyr5': device_add
[    4.060243] PM: Adding info for No Bus:ptyr5
[    4.061179] device: 'ptyr6': device_add
[    4.062045] PM: Adding info for No Bus:ptyr6
[    4.062781] device: 'ptyr7': device_add
[    4.063605] PM: Adding info for No Bus:ptyr7
[    4.064355] device: 'ptyr8': device_add
[    4.065150] PM: Adding info for No Bus:ptyr8
[    4.066049] device: 'ptyr9': device_add
[    4.066894] PM: Adding info for No Bus:ptyr9
[    4.067844] device: 'ptyra': device_add
[    4.068717] PM: Adding info for No Bus:ptyra
[    4.069453] device: 'ptyrb': device_add
[    4.070131] PM: Adding info for No Bus:ptyrb
[    4.070989] device: 'ptyrc': device_add
[    4.071815] PM: Adding info for No Bus:ptyrc
[    4.072552] device: 'ptyrd': device_add
[    4.073232] PM: Adding info for No Bus:ptyrd
[    4.073964] device: 'ptyre': device_add
[    4.074647] PM: Adding info for No Bus:ptyre
[    4.075509] device: 'ptyrf': device_add
[    4.076371] PM: Adding info for No Bus:ptyrf
[    4.077264] device: 'ptys0': device_add
[    4.078249] PM: Adding info for No Bus:ptys0
[    4.079096] device: 'ptys1': device_add
[    4.079779] PM: Adding info for No Bus:ptys1
[    4.080510] device: 'ptys2': device_add
[    4.081189] PM: Adding info for No Bus:ptys2
[    4.081944] device: 'ptys3': device_add
[    4.082626] PM: Adding info for No Bus:ptys3
[    4.083478] device: 'ptys4': device_add
[    4.084274] PM: Adding info for No Bus:ptys4
[    4.085008] device: 'ptys5': device_add
[    4.085781] PM: Adding info for No Bus:ptys5
[    4.086724] device: 'ptys6': device_add
[    4.087555] PM: Adding info for No Bus:ptys6
[    4.088323] device: 'ptys7': device_add
[    4.089124] PM: Adding info for No Bus:ptys7
[    4.089876] device: 'ptys8': device_add
[    4.090706] PM: Adding info for No Bus:ptys8
[    4.091445] device: 'ptys9': device_add
[    4.092143] PM: Adding info for No Bus:ptys9
[    4.092989] device: 'ptysa': device_add
[    4.093682] PM: Adding info for No Bus:ptysa
[    4.094438] device: 'ptysb': device_add
[    4.095226] PM: Adding info for No Bus:ptysb
[    4.096249] device: 'ptysc': device_add
[    4.097054] PM: Adding info for No Bus:ptysc
[    4.097786] device: 'ptysd': device_add
[    4.098474] PM: Adding info for No Bus:ptysd
[    4.099297] device: 'ptyse': device_add
[    4.100060] PM: Adding info for No Bus:ptyse
[    4.100790] device: 'ptysf': device_add
[    4.101612] PM: Adding info for No Bus:ptysf
[    4.102337] device: 'ptyt0': device_add
[    4.103085] PM: Adding info for No Bus:ptyt0
[    4.104002] device: 'ptyt1': device_add
[    4.104859] PM: Adding info for No Bus:ptyt1
[    4.105650] device: 'ptyt2': device_add
[    4.106515] PM: Adding info for No Bus:ptyt2
[    4.107296] device: 'ptyt3': device_add
[    4.108099] PM: Adding info for No Bus:ptyt3
[    4.108954] device: 'ptyt4': device_add
[    4.109672] PM: Adding info for No Bus:ptyt4
[    4.110540] device: 'ptyt5': device_add
[    4.111263] PM: Adding info for No Bus:ptyt5
[    4.112016] device: 'ptyt6': device_add
[    4.112697] PM: Adding info for No Bus:ptyt6
[    4.113619] device: 'ptyt7': device_add
[    4.114475] PM: Adding info for No Bus:ptyt7
[    4.115200] device: 'ptyt8': device_add
[    4.116017] PM: Adding info for No Bus:ptyt8
[    4.116923] device: 'ptyt9': device_add
[    4.117610] PM: Adding info for No Bus:ptyt9
[    4.118332] device: 'ptyta': device_add
[    4.119065] PM: Adding info for No Bus:ptyta
[    4.119922] device: 'ptytb': device_add
[    4.120729] PM: Adding info for No Bus:ptytb
[    4.121608] device: 'ptytc': device_add
[    4.122294] PM: Adding info for No Bus:ptytc
[    4.123099] device: 'ptytd': device_add
[    4.123931] PM: Adding info for No Bus:ptytd
[    4.124663] device: 'ptyte': device_add
[    4.125473] PM: Adding info for No Bus:ptyte
[    4.126432] device: 'ptytf': device_add
[    4.127263] PM: Adding info for No Bus:ptytf
[    4.128197] device: 'ptyu0': device_add
[    4.129063] PM: Adding info for No Bus:ptyu0
[    4.129950] device: 'ptyu1': device_add
[    4.130632] PM: Adding info for No Bus:ptyu1
[    4.131490] device: 'ptyu2': device_add
[    4.132356] PM: Adding info for No Bus:ptyu2
[    4.133090] device: 'ptyu3': device_add
[    4.133777] PM: Adding info for No Bus:ptyu3
[    4.134632] device: 'ptyu4': device_add
[    4.135316] PM: Adding info for No Bus:ptyu4
[    4.136263] device: 'ptyu5': device_add
[    4.137090] PM: Adding info for No Bus:ptyu5
[    4.138045] device: 'ptyu6': device_add
[    4.139028] PM: Adding info for No Bus:ptyu6
[    4.139969] device: 'ptyu7': device_add
[    4.140851] PM: Adding info for No Bus:ptyu7
[    4.141809] device: 'ptyu8': device_add
[    4.142679] PM: Adding info for No Bus:ptyu8
[    4.143747] device: 'ptyu9': device_add
[    4.144609] PM: Adding info for No Bus:ptyu9
[    4.145559] device: 'ptyua': device_add
[    4.146545] PM: Adding info for No Bus:ptyua
[    4.147445] device: 'ptyub': device_add
[    4.148317] PM: Adding info for No Bus:ptyub
[    4.149394] device: 'ptyuc': device_add
[    4.150261] PM: Adding info for No Bus:ptyuc
[    4.151197] device: 'ptyud': device_add
[    4.152096] PM: Adding info for No Bus:ptyud
[    4.153044] device: 'ptyue': device_add
[    4.154030] PM: Adding info for No Bus:ptyue
[    4.154968] device: 'ptyuf': device_add
[    4.155851] PM: Adding info for No Bus:ptyuf
[    4.156788] device: 'ptyv0': device_add
[    4.157632] PM: Adding info for No Bus:ptyv0
[    4.158567] device: 'ptyv1': device_add
[    4.159282] PM: Adding info for No Bus:ptyv1
[    4.160014] device: 'ptyv2': device_add
[    4.160822] PM: Adding info for No Bus:ptyv2
[    4.161577] device: 'ptyv3': device_add
[    4.162252] PM: Adding info for No Bus:ptyv3
[    4.163106] device: 'ptyv4': device_add
[    4.163795] PM: Adding info for No Bus:ptyv4
[    4.164527] device: 'ptyv5': device_add
[    4.165323] PM: Adding info for No Bus:ptyv5
[    4.166255] device: 'ptyv6': device_add
[    4.167055] PM: Adding info for No Bus:ptyv6
[    4.167787] device: 'ptyv7': device_add
[    4.168613] PM: Adding info for No Bus:ptyv7
[    4.169365] device: 'ptyv8': device_add
[    4.170048] PM: Adding info for No Bus:ptyv8
[    4.170779] device: 'ptyv9': device_add
[    4.171603] PM: Adding info for No Bus:ptyv9
[    4.172329] device: 'ptyva': device_add
[    4.173070] PM: Adding info for No Bus:ptyva
[    4.173958] device: 'ptyvb': device_add
[    4.174645] PM: Adding info for No Bus:ptyvb
[    4.175505] device: 'ptyvc': device_add
[    4.176368] PM: Adding info for No Bus:ptyvc
[    4.177185] device: 'ptyvd': device_add
[    4.177988] PM: Adding info for No Bus:ptyvd
[    4.178727] device: 'ptyve': device_add
[    4.179557] PM: Adding info for No Bus:ptyve
[    4.180322] device: 'ptyvf': device_add
[    4.181005] PM: Adding info for No Bus:ptyvf
[    4.181758] device: 'ptyw0': device_add
[    4.182438] PM: Adding info for No Bus:ptyw0
[    4.183278] device: 'ptyw1': device_add
[    4.184190] PM: Adding info for No Bus:ptyw1
[    4.184928] device: 'ptyw2': device_add
[    4.185682] PM: Adding info for No Bus:ptyw2
[    4.186631] device: 'ptyw3': device_add
[    4.187458] PM: Adding info for No Bus:ptyw3
[    4.188543] device: 'ptyw4': device_add
[    4.189416] PM: Adding info for No Bus:ptyw4
[    4.190346] device: 'ptyw5': device_add
[    4.191352] PM: Adding info for No Bus:ptyw5
[    4.192319] device: 'ptyw6': device_add
[    4.193182] PM: Adding info for No Bus:ptyw6
[    4.194042] device: 'ptyw7': device_add
[    4.194730] PM: Adding info for No Bus:ptyw7
[    4.195460] device: 'ptyw8': device_add
[    4.196209] PM: Adding info for No Bus:ptyw8
[    4.197195] device: 'ptyw9': device_add
[    4.198127] PM: Adding info for No Bus:ptyw9
[    4.198860] device: 'ptywa': device_add
[    4.199542] PM: Adding info for No Bus:ptywa
[    4.200267] device: 'ptywb': device_add
[    4.201122] PM: Adding info for No Bus:ptywb
[    4.202223] device: 'ptywc': device_add
[    4.203212] PM: Adding info for No Bus:ptywc
[    4.204189] device: 'ptywd': device_add
[    4.205059] PM: Adding info for No Bus:ptywd
[    4.206008] device: 'ptywe': device_add
[    4.206863] PM: Adding info for No Bus:ptywe
[    4.207813] device: 'ptywf': device_add
[    4.208690] PM: Adding info for No Bus:ptywf
[    4.209624] device: 'ptyx0': device_add
[    4.210624] PM: Adding info for No Bus:ptyx0
[    4.211598] device: 'ptyx1': device_add
[    4.212468] PM: Adding info for No Bus:ptyx1
[    4.213401] device: 'ptyx2': device_add
[    4.214284] PM: Adding info for No Bus:ptyx2
[    4.215218] device: 'ptyx3': device_add
[    4.216103] PM: Adding info for No Bus:ptyx3
[    4.217131] device: 'ptyx4': device_add
[    4.218083] PM: Adding info for No Bus:ptyx4
[    4.218822] device: 'ptyx5': device_add
[    4.219509] PM: Adding info for No Bus:ptyx5
[    4.220336] device: 'ptyx6': device_add
[    4.221199] PM: Adding info for No Bus:ptyx6
[    4.222168] device: 'ptyx7': device_add
[    4.223049] PM: Adding info for No Bus:ptyx7
[    4.223965] device: 'ptyx8': device_add
[    4.224951] PM: Adding info for No Bus:ptyx8
[    4.225896] device: 'ptyx9': device_add
[    4.226901] PM: Adding info for No Bus:ptyx9
[    4.227844] device: 'ptyxa': device_add
[    4.228721] PM: Adding info for No Bus:ptyxa
[    4.229659] device: 'ptyxb': device_add
[    4.230353] PM: Adding info for No Bus:ptyxb
[    4.231276] device: 'ptyxc': device_add
[    4.232189] PM: Adding info for No Bus:ptyxc
[    4.233016] device: 'ptyxd': device_add
[    4.233702] PM: Adding info for No Bus:ptyxd
[    4.234432] device: 'ptyxe': device_add
[    4.235107] PM: Adding info for No Bus:ptyxe
[    4.235840] device: 'ptyxf': device_add
[    4.236522] PM: Adding info for No Bus:ptyxf
[    4.237249] device: 'ptyy0': device_add
[    4.238057] PM: Adding info for No Bus:ptyy0
[    4.238790] device: 'ptyy1': device_add
[    4.239665] PM: Adding info for No Bus:ptyy1
[    4.240412] device: 'ptyy2': device_add
[    4.241153] PM: Adding info for No Bus:ptyy2
[    4.242014] device: 'ptyy3': device_add
[    4.242909] PM: Adding info for No Bus:ptyy3
[    4.243772] device: 'ptyy4': device_add
[    4.244464] PM: Adding info for No Bus:ptyy4
[    4.245188] device: 'ptyy5': device_add
[    4.245871] PM: Adding info for No Bus:ptyy5
[    4.246603] device: 'ptyy6': device_add
[    4.247301] PM: Adding info for No Bus:ptyy6
[    4.248034] device: 'ptyy7': device_add
[    4.248866] PM: Adding info for No Bus:ptyy7
[    4.249932] device: 'ptyy8': device_add
[    4.250808] PM: Adding info for No Bus:ptyy8
[    4.251559] device: 'ptyy9': device_add
[    4.252340] PM: Adding info for No Bus:ptyy9
[    4.253145] device: 'ptyya': device_add
[    4.253941] PM: Adding info for No Bus:ptyya
[    4.254874] device: 'ptyyb': device_add
[    4.255868] PM: Adding info for No Bus:ptyyb
[    4.256935] device: 'ptyyc': device_add
[    4.257809] PM: Adding info for No Bus:ptyyc
[    4.258756] device: 'ptyyd': device_add
[    4.259625] PM: Adding info for No Bus:ptyyd
[    4.260373] device: 'ptyye': device_add
[    4.261115] PM: Adding info for No Bus:ptyye
[    4.261986] device: 'ptyyf': device_add
[    4.262793] PM: Adding info for No Bus:ptyyf
[    4.263574] device: 'ptyz0': device_add
[    4.264293] PM: Adding info for No Bus:ptyz0
[    4.265023] device: 'ptyz1': device_add
[    4.265706] PM: Adding info for No Bus:ptyz1
[    4.266437] device: 'ptyz2': device_add
[    4.267118] PM: Adding info for No Bus:ptyz2
[    4.267850] device: 'ptyz3': device_add
[    4.268663] PM: Adding info for No Bus:ptyz3
[    4.269525] device: 'ptyz4': device_add
[    4.270328] PM: Adding info for No Bus:ptyz4
[    4.271157] device: 'ptyz5': device_add
[    4.271877] PM: Adding info for No Bus:ptyz5
[    4.272779] device: 'ptyz6': device_add
[    4.273652] PM: Adding info for No Bus:ptyz6
[    4.274563] device: 'ptyz7': device_add
[    4.275547] PM: Adding info for No Bus:ptyz7
[    4.276317] device: 'ptyz8': device_add
[    4.277006] PM: Adding info for No Bus:ptyz8
[    4.277737] device: 'ptyz9': device_add
[    4.278421] PM: Adding info for No Bus:ptyz9
[    4.279150] device: 'ptyza': device_add
[    4.279959] PM: Adding info for No Bus:ptyza
[    4.280696] device: 'ptyzb': device_add
[    4.281513] PM: Adding info for No Bus:ptyzb
[    4.282451] device: 'ptyzc': device_add
[    4.283317] PM: Adding info for No Bus:ptyzc
[    4.284233] device: 'ptyzd': device_add
[    4.285100] PM: Adding info for No Bus:ptyzd
[    4.286034] device: 'ptyze': device_add
[    4.287007] PM: Adding info for No Bus:ptyze
[    4.287742] device: 'ptyzf': device_add
[    4.288428] PM: Adding info for No Bus:ptyzf
[    4.289156] device: 'ptya0': device_add
[    4.289924] PM: Adding info for No Bus:ptya0
[    4.290656] device: 'ptya1': device_add
[    4.291468] PM: Adding info for No Bus:ptya1
[    4.292266] device: 'ptya2': device_add
[    4.293162] PM: Adding info for No Bus:ptya2
[    4.293978] device: 'ptya3': device_add
[    4.294738] PM: Adding info for No Bus:ptya3
[    4.295622] device: 'ptya4': device_add
[    4.296514] PM: Adding info for No Bus:ptya4
[    4.297497] device: 'ptya5': device_add
[    4.298375] PM: Adding info for No Bus:ptya5
[    4.299324] device: 'ptya6': device_add
[    4.300340] PM: Adding info for No Bus:ptya6
[    4.301298] device: 'ptya7': device_add
[    4.302191] PM: Adding info for No Bus:ptya7
[    4.303260] device: 'ptya8': device_add
[    4.304157] PM: Adding info for No Bus:ptya8
[    4.305094] device: 'ptya9': device_add
[    4.305929] PM: Adding info for No Bus:ptya9
[    4.306664] device: 'ptyaa': device_add
[    4.307481] PM: Adding info for No Bus:ptyaa
[    4.308305] device: 'ptyab': device_add
[    4.309163] PM: Adding info for No Bus:ptyab
[    4.310242] device: 'ptyac': device_add
[    4.311112] PM: Adding info for No Bus:ptyac
[    4.312011] device: 'ptyad': device_add
[    4.312692] PM: Adding info for No Bus:ptyad
[    4.313430] device: 'ptyae': device_add
[    4.314304] PM: Adding info for No Bus:ptyae
[    4.315038] device: 'ptyaf': device_add
[    4.315724] PM: Adding info for No Bus:ptyaf
[    4.316459] device: 'ptyb0': device_add
[    4.317141] PM: Adding info for No Bus:ptyb0
[    4.318005] device: 'ptyb1': device_add
[    4.318985] PM: Adding info for No Bus:ptyb1
[    4.319833] device: 'ptyb2': device_add
[    4.320710] PM: Adding info for No Bus:ptyb2
[    4.321671] device: 'ptyb3': device_add
[    4.322536] PM: Adding info for No Bus:ptyb3
[    4.323442] device: 'ptyb4': device_add
[    4.324194] PM: Adding info for No Bus:ptyb4
[    4.325093] device: 'ptyb5': device_add
[    4.326101] PM: Adding info for No Bus:ptyb5
[    4.327091] device: 'ptyb6': device_add
[    4.327976] PM: Adding info for No Bus:ptyb6
[    4.328912] device: 'ptyb7': device_add
[    4.329786] PM: Adding info for No Bus:ptyb7
[    4.330519] device: 'ptyb8': device_add
[    4.331195] PM: Adding info for No Bus:ptyb8
[    4.331979] device: 'ptyb9': device_add
[    4.332929] PM: Adding info for No Bus:ptyb9
[    4.333665] device: 'ptyba': device_add
[    4.334346] PM: Adding info for No Bus:ptyba
[    4.335076] device: 'ptybb': device_add
[    4.335760] PM: Adding info for No Bus:ptybb
[    4.336624] device: 'ptybc': device_add
[    4.337455] PM: Adding info for No Bus:ptybc
[    4.338396] device: 'ptybd': device_add
[    4.339398] PM: Adding info for No Bus:ptybd
[    4.340334] device: 'ptybe': device_add
[    4.341200] PM: Adding info for No Bus:ptybe
[    4.342077] device: 'ptybf': device_add
[    4.342861] PM: Adding info for No Bus:ptybf
[    4.343595] device: 'ptyc0': device_add
[    4.344373] PM: Adding info for No Bus:ptyc0
[    4.345183] device: 'ptyc1': device_add
[    4.346118] PM: Adding info for No Bus:ptyc1
[    4.347022] device: 'ptyc2': device_add
[    4.347873] PM: Adding info for No Bus:ptyc2
[    4.348605] device: 'ptyc3': device_add
[    4.349280] PM: Adding info for No Bus:ptyc3
[    4.350318] device: 'ptyc4': device_add
[    4.351190] PM: Adding info for No Bus:ptyc4
[    4.352148] device: 'ptyc5': device_add
[    4.353092] PM: Adding info for No Bus:ptyc5
[    4.353923] device: 'ptyc6': device_add
[    4.354660] PM: Adding info for No Bus:ptyc6
[    4.355414] device: 'ptyc7': device_add
[    4.356271] PM: Adding info for No Bus:ptyc7
[    4.357245] device: 'ptyc8': device_add
[    4.358089] PM: Adding info for No Bus:ptyc8
[    4.358946] device: 'ptyc9': device_add
[    4.359631] PM: Adding info for No Bus:ptyc9
[    4.360357] device: 'ptyca': device_add
[    4.361036] PM: Adding info for No Bus:ptyca
[    4.361789] device: 'ptycb': device_add
[    4.362484] PM: Adding info for No Bus:ptycb
[    4.363421] device: 'ptycc': device_add
[    4.364448] PM: Adding info for No Bus:ptycc
[    4.365378] device: 'ptycd': device_add
[    4.366247] PM: Adding info for No Bus:ptycd
[    4.367144] device: 'ptyce': device_add
[    4.367963] PM: Adding info for No Bus:ptyce
[    4.368697] device: 'ptycf': device_add
[    4.369516] PM: Adding info for No Bus:ptycf
[    4.370282] device: 'ptyd0': device_add
[    4.371091] PM: Adding info for No Bus:ptyd0
[    4.371977] device: 'ptyd1': device_add
[    4.372849] PM: Adding info for No Bus:ptyd1
[    4.373784] device: 'ptyd2': device_add
[    4.374637] PM: Adding info for No Bus:ptyd2
[    4.375571] device: 'ptyd3': device_add
[    4.376286] PM: Adding info for No Bus:ptyd3
[    4.377152] device: 'ptyd4': device_add
[    4.377980] PM: Adding info for No Bus:ptyd4
[    4.378857] device: 'ptyd5': device_add
[    4.379540] PM: Adding info for No Bus:ptyd5
[    4.380265] device: 'ptyd6': device_add
[    4.380948] PM: Adding info for No Bus:ptyd6
[    4.381786] device: 'ptyd7': device_add
[    4.382659] PM: Adding info for No Bus:ptyd7
[    4.383406] device: 'ptyd8': device_add
[    4.384213] PM: Adding info for No Bus:ptyd8
[    4.384945] device: 'ptyd9': device_add
[    4.385651] PM: Adding info for No Bus:ptyd9
[    4.386373] device: 'ptyda': device_add
[    4.387220] PM: Adding info for No Bus:ptyda
[    4.388071] device: 'ptydb': device_add
[    4.388752] PM: Adding info for No Bus:ptydb
[    4.389777] device: 'ptydc': device_add
[    4.390733] PM: Adding info for No Bus:ptydc
[    4.391502] device: 'ptydd': device_add
[    4.392391] PM: Adding info for No Bus:ptydd
[    4.393199] device: 'ptyde': device_add
[    4.393880] PM: Adding info for No Bus:ptyde
[    4.394610] device: 'ptydf': device_add
[    4.395548] PM: Adding info for No Bus:ptydf
[    4.396280] device: 'ptye0': device_add
[    4.397075] PM: Adding info for No Bus:ptye0
[    4.397966] device: 'ptye1': device_add
[    4.398717] PM: Adding info for No Bus:ptye1
[    4.399468] device: 'ptye2': device_add
[    4.400324] PM: Adding info for No Bus:ptye2
[    4.401156] device: 'ptye3': device_add
[    4.402112] PM: Adding info for No Bus:ptye3
[    4.403123] device: 'ptye4': device_add
[    4.403812] PM: Adding info for No Bus:ptye4
[    4.404546] device: 'ptye5': device_add
[    4.405303] PM: Adding info for No Bus:ptye5
[    4.406117] device: 'ptye6': device_add
[    4.406882] PM: Adding info for No Bus:ptye6
[    4.407939] device: 'ptye7': device_add
[    4.408812] PM: Adding info for No Bus:ptye7
[    4.409767] device: 'ptye8': device_add
[    4.410453] PM: Adding info for No Bus:ptye8
[    4.411177] device: 'ptye9': device_add
[    4.412035] PM: Adding info for No Bus:ptye9
[    4.412987] device: 'ptyea': device_add
[    4.413868] PM: Adding info for No Bus:ptyea
[    4.414819] device: 'ptyeb': device_add
[    4.415825] PM: Adding info for No Bus:ptyeb
[    4.416931] device: 'ptyec': device_add
[    4.417806] PM: Adding info for No Bus:ptyec
[    4.418754] device: 'ptyed': device_add
[    4.419625] PM: Adding info for No Bus:ptyed
[    4.420375] device: 'ptyee': device_add
[    4.421115] PM: Adding info for No Bus:ptyee
[    4.421985] device: 'ptyef': device_add
[    4.422868] PM: Adding info for No Bus:ptyef
[    4.423815] device: 'ttyp0': device_add
[    4.424502] PM: Adding info for No Bus:ttyp0
[    4.425229] device: 'ttyp1': device_add
[    4.425913] PM: Adding info for No Bus:ttyp1
[    4.426728] device: 'ttyp2': device_add
[    4.427639] PM: Adding info for No Bus:ttyp2
[    4.428599] device: 'ttyp3': device_add
[    4.429605] PM: Adding info for No Bus:ttyp3
[    4.430697] device: 'ttyp4': device_add
[    4.431603] PM: Adding info for No Bus:ttyp4
[    4.432550] device: 'ttyp5': device_add
[    4.433433] PM: Adding info for No Bus:ttyp5
[    4.434394] device: 'ttyp6': device_add
[    4.435391] PM: Adding info for No Bus:ttyp6
[    4.436324] device: 'ttyp7': device_add
[    4.437236] PM: Adding info for No Bus:ttyp7
[    4.438191] device: 'ttyp8': device_add
[    4.439057] PM: Adding info for No Bus:ttyp8
[    4.440005] device: 'ttyp9': device_add
[    4.440884] PM: Adding info for No Bus:ttyp9
[    4.441846] device: 'ttypa': device_add
[    4.442851] PM: Adding info for No Bus:ttypa
[    4.443794] device: 'ttypb': device_add
[    4.444685] PM: Adding info for No Bus:ttypb
[    4.445752] device: 'ttypc': device_add
[    4.446631] PM: Adding info for No Bus:ttypc
[    4.447526] device: 'ttypd': device_add
[    4.448396] PM: Adding info for No Bus:ttypd
[    4.449327] device: 'ttype': device_add
[    4.450234] PM: Adding info for No Bus:ttype
[    4.451129] device: 'ttypf': device_add
[    4.451975] PM: Adding info for No Bus:ttypf
[    4.452711] device: 'ttyq0': device_add
[    4.453402] PM: Adding info for No Bus:ttyq0
[    4.454323] device: 'ttyq1': device_add
[    4.455219] PM: Adding info for No Bus:ttyq1
[    4.456173] device: 'ttyq2': device_add
[    4.457132] PM: Adding info for No Bus:ttyq2
[    4.458074] device: 'ttyq3': device_add
[    4.458958] PM: Adding info for No Bus:ttyq3
[    4.460034] device: 'ttyq4': device_add
[    4.460886] PM: Adding info for No Bus:ttyq4
[    4.461634] device: 'ttyq5': device_add
[    4.462426] PM: Adding info for No Bus:ttyq5
[    4.463212] device: 'ttyq6': device_add
[    4.464176] PM: Adding info for No Bus:ttyq6
[    4.465248] device: 'ttyq7': device_add
[    4.466119] PM: Adding info for No Bus:ttyq7
[    4.466999] device: 'ttyq8': device_add
[    4.467739] PM: Adding info for No Bus:ttyq8
[    4.468697] device: 'ttyq9': device_add
[    4.469573] PM: Adding info for No Bus:ttyq9
[    4.470519] device: 'ttyqa': device_add
[    4.471387] PM: Adding info for No Bus:ttyqa
[    4.472140] device: 'ttyqb': device_add
[    4.472936] PM: Adding info for No Bus:ttyqb
[    4.473989] device: 'ttyqc': device_add
[    4.474753] PM: Adding info for No Bus:ttyqc
[    4.475706] device: 'ttyqd': device_add
[    4.476709] PM: Adding info for No Bus:ttyqd
[    4.477606] device: 'ttyqe': device_add
[    4.478317] PM: Adding info for No Bus:ttyqe
[    4.479049] device: 'ttyqf': device_add
[    4.479732] PM: Adding info for No Bus:ttyqf
[    4.480615] device: 'ttyr0': device_add
[    4.481315] PM: Adding info for No Bus:ttyr0
[    4.482149] device: 'ttyr1': device_add
[    4.482962] PM: Adding info for No Bus:ttyr1
[    4.483794] device: 'ttyr2': device_add
[    4.484685] PM: Adding info for No Bus:ttyr2
[    4.485618] device: 'ttyr3': device_add
[    4.486484] PM: Adding info for No Bus:ttyr3
[    4.487420] device: 'ttyr4': device_add
[    4.488168] PM: Adding info for No Bus:ttyr4
[    4.489006] device: 'ttyr5': device_add
[    4.489818] PM: Adding info for No Bus:ttyr5
[    4.490596] device: 'ttyr6': device_add
[    4.491464] PM: Adding info for No Bus:ttyr6
[    4.492422] device: 'ttyr7': device_add
[    4.493175] PM: Adding info for No Bus:ttyr7
[    4.494006] device: 'ttyr8': device_add
[    4.494692] PM: Adding info for No Bus:ttyr8
[    4.495430] device: 'ttyr9': device_add
[    4.496444] PM: Adding info for No Bus:ttyr9
[    4.497424] device: 'ttyra': device_add
[    4.498303] PM: Adding info for No Bus:ttyra
[    4.499244] device: 'ttyrb': device_add
[    4.500108] PM: Adding info for No Bus:ttyrb
[    4.501181] device: 'ttyrc': device_add
[    4.502074] PM: Adding info for No Bus:ttyrc
[    4.502960] device: 'ttyrd': device_add
[    4.503841] PM: Adding info for No Bus:ttyrd
[    4.504766] device: 'ttyre': device_add
[    4.505459] PM: Adding info for No Bus:ttyre
[    4.506251] device: 'ttyrf': device_add
[    4.507042] PM: Adding info for No Bus:ttyrf
[    4.507983] device: 'ttys0': device_add
[    4.508842] PM: Adding info for No Bus:ttys0
[    4.509638] device: 'ttys1': device_add
[    4.510640] PM: Adding info for No Bus:ttys1
[    4.511402] device: 'ttys2': device_add
[    4.512170] PM: Adding info for No Bus:ttys2
[    4.513014] device: 'ttys3': device_add
[    4.513698] PM: Adding info for No Bus:ttys3
[    4.514573] device: 'ttys4': device_add
[    4.515576] PM: Adding info for No Bus:ttys4
[    4.516511] device: 'ttys5': device_add
[    4.517248] PM: Adding info for No Bus:ttys5
[    4.517984] device: 'ttys6': device_add
[    4.518668] PM: Adding info for No Bus:ttys6
[    4.519540] device: 'ttys7': device_add
[    4.520416] PM: Adding info for No Bus:ttys7
[    4.521346] device: 'ttys8': device_add
[    4.522277] PM: Adding info for No Bus:ttys8
[    4.523011] device: 'ttys9': device_add
[    4.523776] PM: Adding info for No Bus:ttys9
[    4.524696] device: 'ttysa': device_add
[    4.525390] PM: Adding info for No Bus:ttysa
[    4.526200] device: 'ttysb': device_add
[    4.526977] PM: Adding info for No Bus:ttysb
[    4.527932] device: 'ttysc': device_add
[    4.528840] PM: Adding info for No Bus:ttysc
[    4.529786] device: 'ttysd': device_add
[    4.530503] PM: Adding info for No Bus:ttysd
[    4.531437] device: 'ttyse': device_add
[    4.532204] PM: Adding info for No Bus:ttyse
[    4.532939] device: 'ttysf': device_add
[    4.533619] PM: Adding info for No Bus:ttysf
[    4.534348] device: 'ttyt0': device_add
[    4.535218] PM: Adding info for No Bus:ttyt0
[    4.536057] device: 'ttyt1': device_add
[    4.536743] PM: Adding info for No Bus:ttyt1
[    4.537482] device: 'ttyt2': device_add
[    4.538160] PM: Adding info for No Bus:ttyt2
[    4.538921] device: 'ttyt3': device_add
[    4.539713] PM: Adding info for No Bus:ttyt3
[    4.540605] device: 'ttyt4': device_add
[    4.541473] PM: Adding info for No Bus:ttyt4
[    4.542453] device: 'ttyt5': device_add
[    4.543305] PM: Adding info for No Bus:ttyt5
[    4.544170] device: 'ttyt6': device_add
[    4.544969] PM: Adding info for No Bus:ttyt6
[    4.545879] device: 'ttyt7': device_add
[    4.546563] PM: Adding info for No Bus:ttyt7
[    4.547297] device: 'ttyt8': device_add
[    4.548202] PM: Adding info for No Bus:ttyt8
[    4.548937] device: 'ttyt9': device_add
[    4.549678] PM: Adding info for No Bus:ttyt9
[    4.550631] device: 'ttyta': device_add
[    4.551494] PM: Adding info for No Bus:ttyta
[    4.552297] device: 'ttytb': device_add
[    4.553290] PM: Adding info for No Bus:ttytb
[    4.554410] device: 'ttytc': device_add
[    4.555276] PM: Adding info for No Bus:ttytc
[    4.556117] device: 'ttytd': device_add
[    4.556889] PM: Adding info for No Bus:ttytd
[    4.557822] device: 'ttyte': device_add
[    4.558505] PM: Adding info for No Bus:ttyte
[    4.559332] device: 'ttytf': device_add
[    4.560227] PM: Adding info for No Bus:ttytf
[    4.560964] device: 'ttyu0': device_add
[    4.561670] PM: Adding info for No Bus:ttyu0
[    4.562404] device: 'ttyu1': device_add
[    4.563078] PM: Adding info for No Bus:ttyu1
[    4.563960] device: 'ttyu2': device_add
[    4.564848] PM: Adding info for No Bus:ttyu2
[    4.565786] device: 'ttyu3': device_add
[    4.566790] PM: Adding info for No Bus:ttyu3
[    4.567916] device: 'ttyu4': device_add
[    4.568793] PM: Adding info for No Bus:ttyu4
[    4.569739] device: 'ttyu5': device_add
[    4.570618] PM: Adding info for No Bus:ttyu5
[    4.571702] device: 'ttyu6': device_add
[    4.572713] PM: Adding info for No Bus:ttyu6
[    4.573670] device: 'ttyu7': device_add
[    4.574646] PM: Adding info for No Bus:ttyu7
[    4.575587] device: 'ttyu8': device_add
[    4.576465] PM: Adding info for No Bus:ttyu8
[    4.577444] device: 'ttyu9': device_add
[    4.578318] PM: Adding info for No Bus:ttyu9
[    4.579259] device: 'ttyua': device_add
[    4.580141] PM: Adding info for No Bus:ttyua
[    4.581081] device: 'ttyub': device_add
[    4.582106] PM: Adding info for No Bus:ttyub
[    4.583205] device: 'ttyuc': device_add
[    4.584062] PM: Adding info for No Bus:ttyuc
[    4.585014] device: 'ttyud': device_add
[    4.585884] PM: Adding info for No Bus:ttyud
[    4.586840] device: 'ttyue': device_add
[    4.587726] PM: Adding info for No Bus:ttyue
[    4.588691] device: 'ttyuf': device_add
[    4.589771] PM: Adding info for No Bus:ttyuf
[    4.590716] device: 'ttyv0': device_add
[    4.591617] PM: Adding info for No Bus:ttyv0
[    4.592554] device: 'ttyv1': device_add
[    4.593274] PM: Adding info for No Bus:ttyv1
[    4.594064] device: 'ttyv2': device_add
[    4.594989] PM: Adding info for No Bus:ttyv2
[    4.595724] device: 'ttyv3': device_add
[    4.596414] PM: Adding info for No Bus:ttyv3
[    4.597281] device: 'ttyv4': device_add
[    4.597974] PM: Adding info for No Bus:ttyv4
[    4.598705] device: 'ttyv5': device_add
[    4.599593] PM: Adding info for No Bus:ttyv5
[    4.600526] device: 'ttyv6': device_add
[    4.601548] PM: Adding info for No Bus:ttyv6
[    4.602322] device: 'ttyv7': device_add
[    4.603051] PM: Adding info for No Bus:ttyv7
[    4.603911] device: 'ttyv8': device_add
[    4.604594] PM: Adding info for No Bus:ttyv8
[    4.605320] device: 'ttyv9': device_add
[    4.606001] PM: Adding info for No Bus:ttyv9
[    4.606733] device: 'ttyva': device_add
[    4.607579] PM: Adding info for No Bus:ttyva
[    4.608320] device: 'ttyvb': device_add
[    4.609243] PM: Adding info for No Bus:ttyvb
[    4.610335] device: 'ttyvc': device_add
[    4.611206] PM: Adding info for No Bus:ttyvc
[    4.612173] device: 'ttyvd': device_add
[    4.613044] PM: Adding info for No Bus:ttyvd
[    4.613965] device: 'ttyve': device_add
[    4.614940] PM: Adding info for No Bus:ttyve
[    4.615843] device: 'ttyvf': device_add
[    4.616684] PM: Adding info for No Bus:ttyvf
[    4.617586] device: 'ttyw0': device_add
[    4.618457] PM: Adding info for No Bus:ttyw0
[    4.619396] device: 'ttyw1': device_add
[    4.620257] PM: Adding info for No Bus:ttyw1
[    4.621192] device: 'ttyw2': device_add
[    4.622221] PM: Adding info for No Bus:ttyw2
[    4.623180] device: 'ttyw3': device_add
[    4.624082] PM: Adding info for No Bus:ttyw3
[    4.625160] device: 'ttyw4': device_add
[    4.625983] PM: Adding info for No Bus:ttyw4
[    4.626820] device: 'ttyw5': device_add
[    4.627712] PM: Adding info for No Bus:ttyw5
[    4.628804] device: 'ttyw6': device_add
[    4.629820] PM: Adding info for No Bus:ttyw6
[    4.630770] device: 'ttyw7': device_add
[    4.631662] PM: Adding info for No Bus:ttyw7
[    4.632412] device: 'ttyw8': device_add
[    4.633091] PM: Adding info for No Bus:ttyw8
[    4.633827] device: 'ttyw9': device_add
[    4.634646] PM: Adding info for No Bus:ttyw9
[    4.635516] device: 'ttywa': device_add
[    4.636238] PM: Adding info for No Bus:ttywa
[    4.636978] device: 'ttywb': device_add
[    4.637741] PM: Adding info for No Bus:ttywb
[    4.638834] device: 'ttywc': device_add
[    4.639717] PM: Adding info for No Bus:ttywc
[    4.640670] device: 'ttywd': device_add
[    4.641678] PM: Adding info for No Bus:ttywd
[    4.642629] device: 'ttywe': device_add
[    4.643513] PM: Adding info for No Bus:ttywe
[    4.644480] device: 'ttywf': device_add
[    4.645353] PM: Adding info for No Bus:ttywf
[    4.646296] device: 'ttyx0': device_add
[    4.647201] PM: Adding info for No Bus:ttyx0
[    4.648157] device: 'ttyx1': device_add
[    4.649166] PM: Adding info for No Bus:ttyx1
[    4.650121] device: 'ttyx2': device_add
[    4.650994] PM: Adding info for No Bus:ttyx2
[    4.651970] device: 'ttyx3': device_add
[    4.652851] PM: Adding info for No Bus:ttyx3
[    4.653934] device: 'ttyx4': device_add
[    4.654815] PM: Adding info for No Bus:ttyx4
[    4.655759] device: 'ttyx5': device_add
[    4.656773] PM: Adding info for No Bus:ttyx5
[    4.657750] device: 'ttyx6': device_add
[    4.658638] PM: Adding info for No Bus:ttyx6
[    4.659593] device: 'ttyx7': device_add
[    4.660473] PM: Adding info for No Bus:ttyx7
[    4.661405] device: 'ttyx8': device_add
[    4.662176] PM: Adding info for No Bus:ttyx8
[    4.662932] device: 'ttyx9': device_add
[    4.663894] PM: Adding info for No Bus:ttyx9
[    4.664763] device: 'ttyxa': device_add
[    4.665585] PM: Adding info for No Bus:ttyxa
[    4.666343] device: 'ttyxb': device_add
[    4.667027] PM: Adding info for No Bus:ttyxb
[    4.667898] device: 'ttyxc': device_add
[    4.668776] PM: Adding info for No Bus:ttyxc
[    4.669716] device: 'ttyxd': device_add
[    4.670548] PM: Adding info for No Bus:ttyxd
[    4.671521] device: 'ttyxe': device_add
[    4.672400] PM: Adding info for No Bus:ttyxe
[    4.673332] device: 'ttyxf': device_add
[    4.674126] PM: Adding info for No Bus:ttyxf
[    4.674876] device: 'ttyy0': device_add
[    4.675834] PM: Adding info for No Bus:ttyy0
[    4.676725] device: 'ttyy1': device_add
[    4.677421] PM: Adding info for No Bus:ttyy1
[    4.678226] device: 'ttyy2': device_add
[    4.679041] PM: Adding info for No Bus:ttyy2
[    4.679933] device: 'ttyy3': device_add
[    4.680679] PM: Adding info for No Bus:ttyy3
[    4.681793] device: 'ttyy4': device_add
[    4.682811] PM: Adding info for No Bus:ttyy4
[    4.683897] device: 'ttyy5': device_add
[    4.684587] PM: Adding info for No Bus:ttyy5
[    4.685311] device: 'ttyy6': device_add
[    4.685991] PM: Adding info for No Bus:ttyy6
[    4.686720] device: 'ttyy7': device_add
[    4.687408] PM: Adding info for No Bus:ttyy7
[    4.688355] device: 'ttyy8': device_add
[    4.689361] PM: Adding info for No Bus:ttyy8
[    4.690187] device: 'ttyy9': device_add
[    4.690872] PM: Adding info for No Bus:ttyy9
[    4.691683] device: 'ttyya': device_add
[    4.692546] PM: Adding info for No Bus:ttyya
[    4.693479] device: 'ttyyb': device_add
[    4.694215] PM: Adding info for No Bus:ttyyb
[    4.695088] device: 'ttyyc': device_add
[    4.695918] PM: Adding info for No Bus:ttyyc
[    4.696656] device: 'ttyyd': device_add
[    4.697333] PM: Adding info for No Bus:ttyyd
[    4.698282] device: 'ttyye': device_add
[    4.699144] PM: Adding info for No Bus:ttyye
[    4.700100] device: 'ttyyf': device_add
[    4.700971] PM: Adding info for No Bus:ttyyf
[    4.701935] device: 'ttyz0': device_add
[    4.702956] PM: Adding info for No Bus:ttyz0
[    4.703901] device: 'ttyz1': device_add
[    4.704760] PM: Adding info for No Bus:ttyz1
[    4.705710] device: 'ttyz2': device_add
[    4.706575] PM: Adding info for No Bus:ttyz2
[    4.707555] device: 'ttyz3': device_add
[    4.708432] PM: Adding info for No Bus:ttyz3
[    4.709513] device: 'ttyz4': device_add
[    4.710543] PM: Adding info for No Bus:ttyz4
[    4.711481] device: 'ttyz5': device_add
[    4.712375] PM: Adding info for No Bus:ttyz5
[    4.713312] device: 'ttyz6': device_add
[    4.714095] PM: Adding info for No Bus:ttyz6
[    4.714825] device: 'ttyz7': device_add
[    4.715665] PM: Adding info for No Bus:ttyz7
[    4.716602] device: 'ttyz8': device_add
[    4.717319] PM: Adding info for No Bus:ttyz8
[    4.718116] device: 'ttyz9': device_add
[    4.718915] PM: Adding info for No Bus:ttyz9
[    4.719644] device: 'ttyza': device_add
[    4.720320] PM: Adding info for No Bus:ttyza
[    4.721057] device: 'ttyzb': device_add
[    4.722003] PM: Adding info for No Bus:ttyzb
[    4.723093] device: 'ttyzc': device_add
[    4.723929] PM: Adding info for No Bus:ttyzc
[    4.724662] device: 'ttyzd': device_add
[    4.725341] PM: Adding info for No Bus:ttyzd
[    4.726071] device: 'ttyze': device_add
[    4.726832] PM: Adding info for No Bus:ttyze
[    4.727756] device: 'ttyzf': device_add
[    4.728770] PM: Adding info for No Bus:ttyzf
[    4.729721] device: 'ttya0': device_add
[    4.730592] PM: Adding info for No Bus:ttya0
[    4.731350] device: 'ttya1': device_add
[    4.732146] PM: Adding info for No Bus:ttya1
[    4.732880] device: 'ttya2': device_add
[    4.733562] PM: Adding info for No Bus:ttya2
[    4.734286] device: 'ttya3': device_add
[    4.735113] PM: Adding info for No Bus:ttya3
[    4.736081] device: 'ttya4': device_add
[    4.736768] PM: Adding info for No Bus:ttya4
[    4.737671] device: 'ttya5': device_add
[    4.738543] PM: Adding info for No Bus:ttya5
[    4.739484] device: 'ttya6': device_add
[    4.740343] PM: Adding info for No Bus:ttya6
[    4.741172] device: 'ttya7': device_add
[    4.742108] PM: Adding info for No Bus:ttya7
[    4.742861] device: 'ttya8': device_add
[    4.743684] PM: Adding info for No Bus:ttya8
[    4.744427] device: 'ttya9': device_add
[    4.745174] PM: Adding info for No Bus:ttya9
[    4.746069] device: 'ttyaa': device_add
[    4.746910] PM: Adding info for No Bus:ttyaa
[    4.747833] device: 'ttyab': device_add
[    4.748683] PM: Adding info for No Bus:ttyab
[    4.749765] device: 'ttyac': device_add
[    4.750795] PM: Adding info for No Bus:ttyac
[    4.751765] device: 'ttyad': device_add
[    4.752637] PM: Adding info for No Bus:ttyad
[    4.753582] device: 'ttyae': device_add
[    4.754571] PM: Adding info for No Bus:ttyae
[    4.755343] device: 'ttyaf': device_add
[    4.756120] PM: Adding info for No Bus:ttyaf
[    4.756857] device: 'ttyb0': device_add
[    4.757545] PM: Adding info for No Bus:ttyb0
[    4.758394] device: 'ttyb1': device_add
[    4.759137] PM: Adding info for No Bus:ttyb1
[    4.759998] device: 'ttyb2': device_add
[    4.760996] PM: Adding info for No Bus:ttyb2
[    4.761842] device: 'ttyb3': device_add
[    4.762718] PM: Adding info for No Bus:ttyb3
[    4.763602] device: 'ttyb4': device_add
[    4.764282] PM: Adding info for No Bus:ttyb4
[    4.765106] device: 'ttyb5': device_add
[    4.765885] PM: Adding info for No Bus:ttyb5
[    4.766616] device: 'ttyb6': device_add
[    4.767441] PM: Adding info for No Bus:ttyb6
[    4.768402] device: 'ttyb7': device_add
[    4.769285] PM: Adding info for No Bus:ttyb7
[    4.770223] device: 'ttyb8': device_add
[    4.771023] PM: Adding info for No Bus:ttyb8
[    4.771773] device: 'ttyb9': device_add
[    4.772455] PM: Adding info for No Bus:ttyb9
[    4.773181] device: 'ttyba': device_add
[    4.774115] PM: Adding info for No Bus:ttyba
[    4.775055] device: 'ttybb': device_add
[    4.775900] PM: Adding info for No Bus:ttybb
[    4.776776] device: 'ttybc': device_add
[    4.777479] PM: Adding info for No Bus:ttybc
[    4.778268] device: 'ttybd': device_add
[    4.779112] PM: Adding info for No Bus:ttybd
[    4.779994] device: 'ttybe': device_add
[    4.780823] PM: Adding info for No Bus:ttybe
[    4.781623] device: 'ttybf': device_add
[    4.782330] PM: Adding info for No Bus:ttybf
[    4.783062] device: 'ttyc0': device_add
[    4.783745] PM: Adding info for No Bus:ttyc0
[    4.784476] device: 'ttyc1': device_add
[    4.785153] PM: Adding info for No Bus:ttyc1
[    4.786022] device: 'ttyc2': device_add
[    4.787022] PM: Adding info for No Bus:ttyc2
[    4.787858] device: 'ttyc3': device_add
[    4.788734] PM: Adding info for No Bus:ttyc3
[    4.789645] device: 'ttyc4': device_add
[    4.790532] PM: Adding info for No Bus:ttyc4
[    4.791654] device: 'ttyc5': device_add
[    4.792690] PM: Adding info for No Bus:ttyc5
[    4.793633] device: 'ttyc6': device_add
[    4.794480] PM: Adding info for No Bus:ttyc6
[    4.795268] device: 'ttyc7': device_add
[    4.795984] PM: Adding info for No Bus:ttyc7
[    4.796859] device: 'ttyc8': device_add
[    4.797733] PM: Adding info for No Bus:ttyc8
[    4.798471] device: 'ttyc9': device_add
[    4.799296] PM: Adding info for No Bus:ttyc9
[    4.800031] device: 'ttyca': device_add
[    4.800718] PM: Adding info for No Bus:ttyca
[    4.801482] device: 'ttycb': device_add
[    4.802367] PM: Adding info for No Bus:ttycb
[    4.803330] device: 'ttycc': device_add
[    4.804022] PM: Adding info for No Bus:ttycc
[    4.804747] device: 'ttycd': device_add
[    4.805582] PM: Adding info for No Bus:ttycd
[    4.806350] device: 'ttyce': device_add
[    4.807040] PM: Adding info for No Bus:ttyce
[    4.807772] device: 'ttycf': device_add
[    4.808453] PM: Adding info for No Bus:ttycf
[    4.809181] device: 'ttyd0': device_add
[    4.809986] PM: Adding info for No Bus:ttyd0
[    4.810894] device: 'ttyd1': device_add
[    4.811824] PM: Adding info for No Bus:ttyd1
[    4.812774] device: 'ttyd2': device_add
[    4.813663] PM: Adding info for No Bus:ttyd2
[    4.814412] device: 'ttyd3': device_add
[    4.815090] PM: Adding info for No Bus:ttyd3
[    4.815865] device: 'ttyd4': device_add
[    4.816692] PM: Adding info for No Bus:ttyd4
[    4.817450] device: 'ttyd5': device_add
[    4.818270] PM: Adding info for No Bus:ttyd5
[    4.819007] device: 'ttyd6': device_add
[    4.819692] PM: Adding info for No Bus:ttyd6
[    4.820614] device: 'ttyd7': device_add
[    4.821478] PM: Adding info for No Bus:ttyd7
[    4.822285] device: 'ttyd8': device_add
[    4.823060] PM: Adding info for No Bus:ttyd8
[    4.823789] device: 'ttyd9': device_add
[    4.824615] PM: Adding info for No Bus:ttyd9
[    4.825476] device: 'ttyda': device_add
[    4.826203] PM: Adding info for No Bus:ttyda
[    4.826938] device: 'ttydb': device_add
[    4.827622] PM: Adding info for No Bus:ttydb
[    4.828374] device: 'ttydc': device_add
[    4.829157] PM: Adding info for No Bus:ttydc
[    4.830094] device: 'ttydd': device_add
[    4.830923] PM: Adding info for No Bus:ttydd
[    4.831673] device: 'ttyde': device_add
[    4.832348] PM: Adding info for No Bus:ttyde
[    4.833299] device: 'ttydf': device_add
[    4.834144] PM: Adding info for No Bus:ttydf
[    4.835078] device: 'ttye0': device_add
[    4.835981] PM: Adding info for No Bus:ttye0
[    4.836971] device: 'ttye1': device_add
[    4.837837] PM: Adding info for No Bus:ttye1
[    4.838792] device: 'ttye2': device_add
[    4.839667] PM: Adding info for No Bus:ttye2
[    4.840603] device: 'ttye3': device_add
[    4.841479] PM: Adding info for No Bus:ttye3
[    4.842505] device: 'ttye4': device_add
[    4.843395] PM: Adding info for No Bus:ttye4
[    4.844230] device: 'ttye5': device_add
[    4.844912] PM: Adding info for No Bus:ttye5
[    4.845643] device: 'ttye6': device_add
[    4.846320] PM: Adding info for No Bus:ttye6
[    4.847057] device: 'ttye7': device_add
[    4.847738] PM: Adding info for No Bus:ttye7
[    4.848471] device: 'ttye8': device_add
[    4.849171] PM: Adding info for No Bus:ttye8
[    4.849938] device: 'ttye9': device_add
[    4.850803] PM: Adding info for No Bus:ttye9
[    4.851766] device: 'ttyea': device_add
[    4.852635] PM: Adding info for No Bus:ttyea
[    4.853566] device: 'ttyeb': device_add
[    4.854281] PM: Adding info for No Bus:ttyeb
[    4.855229] device: 'ttyec': device_add
[    4.856121] PM: Adding info for No Bus:ttyec
[    4.857004] device: 'ttyed': device_add
[    4.857684] PM: Adding info for No Bus:ttyed
[    4.858414] device: 'ttyee': device_add
[    4.859148] PM: Adding info for No Bus:ttyee
[    4.859985] device: 'ttyef': device_add
[    4.860668] PM: Adding info for No Bus:ttyef
[    4.861414] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.862509] Registering platform device 'serial8250'. Parent at platform
[    4.863835] device: 'serial8250': device_add
[    4.864639] bus: 'platform': add device serial8250
[    4.865486] PM: Adding info for platform:serial8250
[    4.889684] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.890802] device: 'ttyS0': device_add
[    4.891701] PM: Adding info for No Bus:ttyS0
[    4.892510] device: 'ttyS1': device_add
[    4.893187] PM: Adding info for No Bus:ttyS1
[    4.894131] device: 'ttyS2': device_add
[    4.894938] PM: Adding info for No Bus:ttyS2
[    4.895927] device: 'ttyS3': device_add
[    4.896756] PM: Adding info for No Bus:ttyS3
[    4.897560] bus: 'platform': add driver serial8250
[    4.898551] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    4.900340] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    4.902044] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    4.903464] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    4.905034] bus: 'pnp': add driver serial
[    4.905885] bus: 'pnp': driver_probe_device: matched device 00:06 with driver serial
[    4.907354] bus: 'pnp': really_probe: probing driver serial with device 00:06
[    4.909159] device: 'ttyS0': device_unregister
[    4.910109] PM: Removing info for No Bus:ttyS0
[    4.911431] device: 'ttyS0': device_create_release
[    4.935435] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.936725] tsc: Refined TSC clocksource calibration: 2666.664 MHz
[    4.938298] device: 'ttyS0': device_add
[    4.939215] PM: Adding info for No Bus:ttyS0
[    4.940216] driver: '00:06': driver_bound: bound to device 'serial'
[    4.941619] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    4.943174] bus: 'pci': add driver serial
[    4.944159] device: 'ttyprintk': device_add
[    4.945006] PM: Adding info for No Bus:ttyprintk
[    4.945983] bus: 'pnp': add driver tpm_tis
[    4.947103] bus: 'isa': registered
[    4.947843] device: 'isa': device_add
[    4.948629] PM: Adding info for No Bus:isa
[    4.949508] bus: 'pnp': add driver i8042 kbd
[    4.950412] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 kbd
[    4.952092] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:02
[    4.953621] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    4.954978] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 kbd
[    4.956459] bus: 'pnp': add driver i8042 aux
[    4.957286] bus: 'pnp': driver_probe_device: matched device 00:03 with driver i8042 aux
[    4.959014] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:03
[    4.960633] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    4.962123] bus: 'pnp': really_probe: bound device 00:03 to driver i8042 aux
[    4.963699] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    4.965482] Registering platform device 'i8042'. Parent at platform
[    4.966883] device: 'i8042': device_add
[    4.967563] bus: 'platform': add device i8042
[    4.968568] PM: Adding info for platform:i8042
[    4.969587] bus: 'platform': add driver i8042
[    4.970581] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    4.972388] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    4.975024] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.976150] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.977217] device: 'serio0': device_add
[    4.978085] bus: 'serio': add device serio0
[    4.979072] PM: Adding info for serio:serio0
[    4.980080] driver: 'i8042': driver_bound: bound to device 'i8042'
[    4.981446] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    4.983092] device: 'mice': device_add
[    4.983983] PM: Adding info for No Bus:mice
[    4.984950] device: 'psaux': device_add
[    4.985856] PM: Adding info for No Bus:psaux
[    4.986795] mousedev: PS/2 mouse device common for all mice
[    4.988034] bus: 'serio': add driver atkbd
[    4.989120] device: 'serio1': device_add
[    4.990038] bus: 'serio': add device serio1
[    4.991018] PM: Adding info for serio:serio1
[    4.992014] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    4.993748] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    4.995691] atkbd: probe of serio1 rejects match -19
[    4.996842] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    4.998294] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    5.000379] device: 'input1': device_add
[    5.001388] PM: Adding info for No Bus:input1
[    5.002409] bus: 'serio': add driver psmouse
[    5.003426] cpuidle: using governor ladder
[    5.004286] bus: 'hid': registered
[    5.005051] bus: 'hid': add driver hid-generic
[    5.006072] bus: 'platform': add driver olpc-ec
[    5.007112] bus: 'machinecheck': registered
[    5.008090] device: 'machinecheck': device_add
[    5.009143] PM: Adding info for No Bus:machinecheck
[    5.010245] device: 'machinecheck0': device_add
[    5.011265] bus: 'machinecheck': add device machinecheck0
[    5.012524] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    5.014411] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    5.015795] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    5.017240] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    5.018795] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    5.020686] atkbd: probe of serio1 rejects match -19
[    5.021880] PM: Adding info for machinecheck:machinecheck0
[    5.023149] device: 'mcelog': device_add
[    5.024078] PM: Adding info for No Bus:mcelog
[    5.025346] 
[    5.025346] printing PIC contents
[    5.026423] ... PIC  IMR: ffff
[    5.027071] ... PIC  IRR: 1013
[    5.027603] ... PIC  ISR: 0000
[    5.028251] ... PIC ELCR: 0c00
[    5.028967] printing local APIC contents on CPU#0/0:
[    5.030076] ... APIC ID:      00000000 (0)
[    5.031007] ... APIC VERSION: 00050014
[    5.031840] ... APIC TASKPRI: 00000000 (00)
[    5.031840] ... APIC PROCPRI: 00000000
[    5.031840] ... APIC LDR: 01000000
[    5.031840] ... APIC DFR: ffffffff
[    5.031840] ... APIC SPIV: 000001ff
[    5.031840] ... APIC ISR field:
[    5.031840] 0000000000000000000000000000000000000000000000000000000000000000
[    5.031840] ... APIC TMR field:
[    5.031840] 0000000000000000000000000000000000000000000000000000000000000000
[    5.031840] ... APIC IRR field:
[    5.031840] 0000000000000000000000000000000000000000000000000000000000008000
[    5.031840] ... APIC ESR: 00000000
[    5.031840] ... APIC ICR: 00000831
[    5.031840] ... APIC ICR2: 01000000
[    5.031840] ... APIC LVTT: 000200ef
[    5.031840] ... APIC LVTPC: 00010000
[    5.031840] ... APIC LVT0: 00010700
[    5.031840] ... APIC LVT1: 00000400
[    5.031840] ... APIC LVTERR: 000000fe
[    5.031840] ... APIC TMICT: 00098954
[    5.031840] ... APIC TMCCT: 0000f0f7
[    5.031840] ... APIC TDCR: 00000003
[    5.031840] 
[    5.052468] number of MP IRQ sources: 15.
[    5.053326] number of IO-APIC #2 registers: 24.
[    5.054216] testing the IO APIC.......................
[    5.055271] IO APIC #2......
[    5.055899] .... register #00: 00000000
[    5.056730] .......    : physical APIC id: 00
[    5.057635] .......    : Delivery Type: 0
[    5.058482] .......    : LTS          : 0
[    5.059334] .... register #01: 00170011
[    5.060120] .......     : max redirection entries: 17
[    5.061099] .......     : PRQ implemented: 0
[    5.061945] .......     : IO APIC version: 11
[    5.062866] .... register #02: 00000000
[    5.063506] .......     : arbitration: 00
[    5.064168] .... IRQ redirection table:
[    5.064810]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    5.065731]  00 00  1    0    0   0   0    0    0    00
[    5.066639]  01 01  0    0    0   0   0    1    1    31
[    5.067546]  02 01  0    0    0   0   0    1    1    30
[    5.068451]  03 01  0    0    0   0   0    1    1    33
[    5.069518]  04 01  1    0    0   0   0    1    1    34
[    5.070677]  05 01  1    1    0   0   0    1    1    35
[    5.071693]  06 01  0    0    0   0   0    1    1    36
[    5.072655]  07 01  0    0    0   0   0    1    1    37
[    5.073586]  08 01  0    0    0   0   0    1    1    38
[    5.074497]  09 01  0    1    0   0   0    1    1    39
[    5.075469]  0a 01  1    1    0   0   0    1    1    3A
[    5.076369]  0b 01  1    1    0   0   0    1    1    3B
[    5.077278]  0c 01  0    0    0   0   0    1    1    3C
[    5.078187]  0d 01  0    0    0   0   0    1    1    3D
[    5.079178]  0e 01  0    0    0   0   0    1    1    3E
[    5.080260]  0f 01  0    0    0   0   0    1    1    3F
[    5.081288]  10 00  1    0    0   0   0    0    0    00
[    5.082298]  11 00  1    0    0   0   0    0    0    00
[    5.083284]  12 00  1    0    0   0   0    0    0    00
[    5.084184]  13 00  1    0    0   0   0    0    0    00
[    5.085265]  14 00  1    0    0   0   0    0    0    00
[    5.086423]  15 00  1    0    0   0   0    0    0    00
[    5.087563]  16 00  1    0    0   0   0    0    0    00
[    5.088527]  17 00  1    0    0   0   0    0    0    00
[    5.089464] IRQ to pin mappings:
[    5.090003] IRQ0 -> 0:2
[    5.090473] IRQ1 -> 0:1
[    5.090937] IRQ3 -> 0:3
[    5.091401] IRQ4 -> 0:4
[    5.092013] IRQ5 -> 0:5
[    5.092617] IRQ6 -> 0:6
[    5.093121] IRQ7 -> 0:7
[    5.093632] IRQ8 -> 0:8
[    5.094201] IRQ9 -> 0:9
[    5.094802] IRQ10 -> 0:10
[    5.095433] IRQ11 -> 0:11
[    5.096057] IRQ12 -> 0:12
[    5.096684] IRQ13 -> 0:13
[    5.097200] IRQ14 -> 0:14
[    5.097698] IRQ15 -> 0:15
[    5.098188] .................................... done.
[    5.099158] Using IPI Shortcut mode
[    5.099890] bus: 'serio': driver_probe_device: matched device serio1 with driver psmouse
[    5.101294] bus: 'serio': really_probe: probing driver psmouse with device serio1
[    5.107417] device: 'cpu_dma_latency': device_add
[    5.108330] PM: Adding info for No Bus:cpu_dma_latency
[    5.109210] device: 'network_latency': device_add
[    5.110112] PM: Adding info for No Bus:network_latency
[    5.111065] device: 'network_throughput': device_add
[    5.112098] PM: Adding info for No Bus:network_throughput
[    5.113278] IMA: No TPM chip found, activating TPM-bypass!
[    5.115603] ### of_selftest(): No testcase data in device tree; not running tests
[    5.118343] debug: unmapping init [mem 0x81702000-0x8176cfff]
[    5.119849] Write protecting the kernel text: 2868k
[    5.120912] Write protecting the kernel read-only data: 1876k
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

[    5.160992] modprobe (24) used greatest stack depth: 6564 bytes left
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

[    5.303661] device: 'input2': device_add
[    5.304677] PM: Adding info for No Bus:input2
[    5.305666] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    5.307546] device: 'mouse0': device_add
[    5.308452] PM: Adding info for No Bus:mouse0
[    5.309505] driver: 'serio1': driver_bound: bound to device 'psmouse'
[    5.310905] bus: 'serio': really_probe: bound device serio1 to driver psmouse
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

[ 2204.090146] plymouthd (52) used greatest stack depth: 6324 bytes left
modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

 * Asking all remaining processes to terminate...       

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.6.0-rc1/modules.dep: No such file or directory

 * Killing all remaining processes...       


mount: unknown filesystem type 'devpts'
mountall: mount /dev/pts [1267] terminated with status 32
mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available

udevd[1346]: error creating signalfd

udevd[1360]: error creating signalfd

 * Deactivating swap...       
[ 2220.929173] ip (1388) used greatest stack depth: 6132 bytes left
udevd[1381]: error creating signalfd

udevd[1397]: error creating signalfd

[ 2221.089504] VFS: Busy inodes after unmount of tmpfs. Self-destruct in 5 seconds.  Have a nice day...
[ 2221.091656] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[ 2221.093256] IP: [<810d2a2c>] shmem_free_inode+0x10/0x45
[ 2221.093927] *pde = 00000000 
[ 2221.093927] Oops: 0000 [#1] DEBUG_PAGEALLOC
[ 2221.093927] Modules linked in:
[ 2221.093927] Pid: 1397, comm: udevd Not tainted 3.6.0-rc1 #24 Bochs Bochs
[ 2221.093927] EIP: 0060:[<810d2a2c>] EFLAGS: 00010246 CPU: 0
[ 2221.093927] EIP is at shmem_free_inode+0x10/0x45
[ 2221.093927] EAX: 8602e000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[ 2221.093927] ESI: 8ab91444 EDI: 8ab9143c EBP: 8ab61e58 ESP: 8ab61e50
[ 2221.093927]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 2221.093927] CR0: 8005003b CR2: 0000000c CR3: 0ab79000 CR4: 000006d0
[ 2221.093927] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 2221.093927] DR6: ffff0ff0 DR7: 00000400
[ 2221.093927] Process udevd (pid: 1397, ti=8ab60000 task=8abf0000 task.ti=8ab60000)
[ 2221.093927] Stack:
[ 2221.093927]  00000000 8ab91444 8ab61e70 810d5265 8ab9143c 8ab91444 8ab9153c 812eb998
[ 2221.093927]  8ab61e84 8111e85e 8ab91444 00000000 8602e000 8ab61e9c 8111ebf9 812eb998
[ 2221.093927]  8603a0e0 86140000 8ab91444 8ab61eb8 81138a6c 861400a4 8603a0f4 8603a0e0
[ 2221.093927] Call Trace:
[ 2221.093927]  [<810d5265>] shmem_evict_inode+0x158/0x167
[ 2221.093927]  [<8111e85e>] evict+0x125/0x239
[ 2221.093927]  [<8111ebf9>] iput+0x287/0x2e0
[ 2221.093927]  [<81138a6c>] fsnotify_destroy_mark+0x16f/0x1af
[ 2221.093927]  [<81138e33>] fsnotify_clear_marks_by_group_flags+0xba/0xd8
[ 2221.093927]  [<81138e61>] fsnotify_clear_marks_by_group+0x10/0x12
[ 2221.093927]  [<8113a009>] inotify_release+0x16/0x22
[ 2221.093927]  [<81100248>] __fput+0x1a1/0x450
[ 2221.093927]  [<81100504>] ____fput+0xd/0xf
[ 2221.093927]  [<8105a7f5>] task_work_run+0x74/0x83
[ 2221.093927]  [<8103d025>] do_exit+0x374/0xb44
[ 2221.093927]  [<81189255>] ? do_raw_spin_unlock+0xd1/0x108
[ 2221.093927]  [<8103db0f>] do_group_exit+0xfd/0xfd
[ 2221.093927]  [<8103db27>] sys_exit_group+0x18/0x18
[ 2221.093927]  [<812cb523>] sysenter_do_call+0x12/0x3c
[ 2221.093927] Code: 1f 00 b8 e4 ff ff ff eb 0d 4a 89 f0 89 53 10 e8 51 82 1f 00 31 c0 5b 5e 5f 5d c3 55 89 e5 56 53 e8 66 90 1f 00 8b 98 c4 03 00 00 <83> 7b 0c 00 0f 95 c0 0f b6 d0 8b 0c 95 a4 38 67 81 41 84 c0 89
[ 2221.093927] EIP: [<810d2a2c>] shmem_free_inode+0x10/0x45 SS:ESP 0068:8ab61e50
[ 2221.093927] CR2: 000000000000000c
[ 2221.140550] ---[ end trace c0eba189b08bb3eb ]---
[ 2221.141550] Fixing recursive fault but reboot is needed!
umount: /run/lock: not mounted
 * Will now restart
[ 2221.298340] Unregister pv shared memory for cpu 0
[ 2221.299277] psmouse serio1: shutdown
[ 2221.300280] atkbd serio0: shutdown
[ 2221.301097] i8042 i8042: shutdown
[ 2221.302501] pnp 00:07: shutdown
[ 2221.303202] serial 00:06: shutdown
[ 2221.303986] pnp 00:05: shutdown
[ 2221.304682] pnp 00:04: shutdown
[ 2221.305388] i8042 aux 00:03: shutdown
[ 2221.306192] i8042 kbd 00:02: shutdown
[ 2221.306979] pnp 00:01: shutdown
[ 2221.307710] pnp 00:00: shutdown
[ 2221.308413] pci 0000:00:0a.0: shutdown
[ 2221.309242] pci 0000:00:09.0: shutdown
[ 2221.310090] pci 0000:00:08.0: shutdown
[ 2221.310899] pci 0000:00:07.0: shutdown
[ 2221.311712] pci 0000:00:06.0: shutdown
[ 2221.312531] pci 0000:00:05.0: shutdown
[ 2221.313331] pci 0000:00:04.0: shutdown
[ 2221.314150] pci 0000:00:03.0: shutdown
[ 2221.314910] pci 0000:00:02.0: shutdown
[ 2221.315547] pci 0000:00:01.3: shutdown
[ 2221.316178] pci 0000:00:01.1: shutdown
[ 2221.316813] pci 0000:00:01.0: shutdown
[ 2221.317473] pci 0000:00:00.0: shutdown
[ 2221.318231] Restarting system.
[ 2221.318755] reboot: machine restart

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc1"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
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
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_FHANDLE is not set
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
CONFIG_KTIME_SCALAR=y
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
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
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
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
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
CONFIG_HAVE_DMA_CONTIGUOUS=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
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
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=m
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=1
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=m
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=m
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=m
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=m
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
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
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
CONFIG_TCIC=m
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
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
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
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
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
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
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=m
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=m
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

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
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
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
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
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
# CONFIG_MOUSE_PS2_OLPC is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

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
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=m
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=m
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

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
CONFIG_I2C_GPIO=m
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=m
CONFIG_I2C_PCA_ISA=m
CONFIG_I2C_STUB=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=m
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=m
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
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=m
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
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
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=m
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
CONFIG_MIXCOMWD=m
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
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
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_MFD_LM3533=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=m
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_WM831X=m
# CONFIG_MEDIA_SUPPORT is not set

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
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=m
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=m
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
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
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
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
# CONFIG_NEW_LEDS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_S35390A=m
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1390=m
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=m
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
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
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
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
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=m
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--cWoXeonUoKmBZSoM--
