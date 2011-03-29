Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1C2LTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:19:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab1C2LSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:18:53 -0400
Date: Tue, 29 Mar 2011 13:17:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: [sporadic crash] blk: request botched
Message-ID: <20110329111755.GA1760@elte.hu>
References: <4D8E36CC.7080707@fusionio.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D8E36CC.7080707@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


FYI, i'm seeing a new block IO related boot failure. It starts by the kernel spewing:

 [   84.434778] blk: request botched
 [   84.437546] blk: request botched
 [   84.441532] blk: request botched

And after more dying noises, a colorful kernel crash in an apparently rarely 
excercised error handler:

[  270.181309] ata1.00: configured for UDMA/33
[  270.184893] ata1.00: device reported invalid CHS sector 0
[  270.188902] BUG: unable to handle kernel NULL pointer dereference at 0000022c
[  270.192885] IP: [<c119d413>] __blk_recalc_rq_segments+0x53/0x210
[  270.192885] *pde = 00000000 
[  270.192885] Oops: 0000 [#1] SMP 
[  270.192885] last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/net/eth0/address
[  270.192885] Modules linked in:
[  270.192885] 
[  270.192885] Pid: 29, comm: scsi_eh_0 Not tainted 2.6.38-tip-11308-g785c78f-dirty #111495 System manufacturer System Product Name/A8N-E
[  270.192885] EIP: 0060:[<c119d413>] EFLAGS: 00010202 CPU: 1
[  270.192885] EIP is at __blk_recalc_rq_segments+0x53/0x210
[  270.192885] EAX: 000001f4 EBX: f51e6680 ECX: 000001f4 EDX: ffffffff
[  270.192885] ESI: 00000000 EDI: 3d80d000 EBP: f5b47de4 ESP: f5b47da0
[  270.192885]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  270.192885] Process scsi_eh_0 (pid: 29, ti=f5b46000 task=f59cdf00 task.ti=f5b46000)
[  270.192885] Stack:
[  270.192885]  00000001 3d80ffff 0000ffff f702c180 0000e000 01b47db4 00001000 f51d3400
[  270.192885]  000001f4 f5b5c000 f5417b48 00000000 0000e000 00000004 f515d820 0222ec01
[  270.192885]  f515d820 f5b47df0 c119d8e6 f51d3400 f5b47e30 c11969b8 f5b46000 00000000
[  270.192885] Call Trace:
[  270.192885]  [<c119d8e6>] blk_recalc_rq_segments+0x16/0x20
[  270.192885]  [<c11969b8>] blk_update_request+0x358/0x4a0
[  270.192885]  [<c103ea55>] ? irq_exit+0x55/0x60
[  270.192885]  [<c1198ba3>] blk_update_bidi_request+0x13/0x70
[  270.192885]  [<c1199712>] blk_end_bidi_request+0x22/0x60
[  270.192885]  [<c1199767>] blk_end_request+0x17/0x20
[  270.192885]  [<c121c848>] scsi_io_completion+0x98/0x6a0
[  270.192885]  [<c124c184>] ? __ata_eh_qc_complete+0x54/0x70
[  270.192885]  [<c1213d46>] scsi_finish_command+0x96/0x110
[  270.192885]  [<c12194a7>] scsi_eh_flush_done_q+0xd7/0x130
[  270.192885]  [<c1251b1e>] ata_scsi_port_error_handler+0x60e/0x760
[  270.192885]  [<c13a8bbe>] ? _raw_spin_unlock_irqrestore+0xe/0x20
[  270.192885]  [<c1251cdf>] ata_scsi_error+0x6f/0xa0
[  270.192885]  [<c12198c0>] ? scsi_eh_get_sense+0x1f0/0x1f0
[  270.192885]  [<c12199b5>] scsi_error_handler+0xf5/0x5f0
[  270.192885]  [<c1030f50>] ? default_wake_function+0x10/0x20
[  270.192885]  [<c1026e77>] ? __wake_up_common+0x47/0x70
[  270.192885]  [<c102a727>] ? complete+0x47/0x50
[  270.192885]  [<c12198c0>] ? scsi_eh_get_sense+0x1f0/0x1f0
[  270.192885]  [<c105570d>] kthread+0x6d/0x70
[  270.192885]  [<c10556a0>] ? kthread_worker_fn+0x160/0x160
[  270.192885]  [<c13aa246>] kernel_thread_helper+0x6/0x10
[  270.192885] Code: c7 45 f0 00 00 00 00 c7 45 ec 00 00 00 00 c7 45 e8 01 00 00 00 c7 45 e4 00 00 00 00 8d b6 00 00 00 00 8d bf 00 00 00 00 8b 4d dc <8b> 51 38 66 8b 41 1a 8b 71 18 89 c1 81 e1 ff ff 00 00 66 39 c6 
[  270.192885] EIP: [<c119d413>] __blk_recalc_rq_segments+0x53/0x210 SS:ESP 0068:f5b47da0

Full bootlog below, that should give the hardware/driver type as well. Config attached.

NOTE: i booted this kernel for a second time, and the crash was not 
reproducable anymore - so there's nothing to bisect.

I've attached the 'good' bootup below the 'bad' bootup.

The upstream sha1 is:

 89078d572eb9ce8d4c04264b8b0ba86de0d74c8f md: Fix integrity registration error when no devices are capable

( The -tip commit you can see in the log is essencially Linus's kernel with 
  nothing included that should cause such symptoms AFAICS. )

Thanks,

	Ingo

[    0.000000] Linux version 2.6.38-tip-11308-g785c78f-dirty (mingo@sirius) (gcc version 4.6.0 20110304 (Red Hat 4.6.0-0.12) (GCC) ) #111495 SMP Tue Mar 29 13:22:16 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.3 present.
[    0.000000] DMI: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f5680] f5680
[    0.000000]   mpc: f1400-f152c
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009e000] 9e000 size 4096
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 1bfb000-1c00000
[    0.000000] 135MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 272 pages used for memmap
[    0.000000]   HighMem zone: 34530 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f1400-f152c
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is PCI   
[    0.000000] Bus #2 is PCI   
[    0.000000] Bus #3 is PCI   
[    0.000000] Bus #4 is PCI   
[    0.000000] Bus #5 is PCI   
[    0.000000] Bus #6 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 28, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 10, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 3, trig 3, bus 05, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 3, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 00
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 1, trig 1, bus 06, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @f6800000 s23120 r0 d21936 u2097152
[    0.000000] pcpu-alloc: s23120 r0 d21936 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1 3
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0003fff0)
[    0.000000] Memory: 1031940k/1048512k available (3755k kernel code, 16120k reserved, 1437k data, 408k init, 139208k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd37000 - 0xfffff000   (2848 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1513000 - 0xc1579000   ( 408 kB)
[    0.000000]       .data : 0xc13aad6d - 0xc15123f0   (1437 kB)
[    0.000000]       .text : 0xc1000000 - 0xc13aad6d   (3755 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Hierarchical RCU autobalancing is disabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] CPU 0 irqstacks, hard=f640e000 soft=f6420000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] allocated 4194304 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.289 MHz processor.
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[    0.020001] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.57 BogoMIPS (lpj=8041156)
[    0.024004] pid_max: default: 32768 minimum: 301
[    0.028119] Security Framework initialized
[    0.032027] TOMOYO Linux initialized
[    0.036063] Mount-cache hash table entries: 512
[    0.040413] Initializing cgroup subsys debug
[    0.044005] Initializing cgroup subsys ns
[    0.048006] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.052005] Initializing cgroup subsys cpuacct
[    0.056037] Initializing cgroup subsys memory
[    0.060022] Initializing cgroup subsys devices
[    0.064035] CPU: Physical Processor ID: 0
[    0.068005] CPU: Processor Core ID: 0
[    0.072848] ftrace: allocating 14875 entries in 30 pages
[    0.080078] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.084009] enabled ExtINT on CPU#0
[    0.088052] ExtINT not setup in hardware but reported by MP table
[    0.092088] ENABLING IO-APIC IRQs
[    0.096007] init IO_APIC IRQs
[    0.100008]  apic 2 pin 0 not connected
[    0.104013] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.108014] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.112013] IOAPIC[0]: Set routing entry (2-3 -> 0x29 -> IRQ 27 Mode:1 Active:1)
[    0.116006] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-5 -> 0x41 -> IRQ 29 Mode:1 Active:1)
[    0.116006] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:1)
[    0.116006] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.116006] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.116006]  apic 2 pin 16 not connected
[    0.116006]  apic 2 pin 17 not connected
[    0.116006]  apic 2 pin 18 not connected
[    0.116006]  apic 2 pin 19 not connected
[    0.116006]  apic 2 pin 20 not connected
[    0.116006]  apic 2 pin 21 not connected
[    0.116006]  apic 2 pin 22 not connected
[    0.116006]  apic 2 pin 23 not connected
[    0.116006] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.116006] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.116006] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.116006] ..... (found apic 0 pin 0) ...
[    0.156302] ....... works.
[    0.159004] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.165238] Using local APIC timer interrupts.
[    0.165239] calibrating APIC timer ...
[    0.172010] ... lapic delta = 1256509
[    0.172010] ..... delta 1256509
[    0.172010] ..... mult: 53963277
[    0.172010] ..... calibration result: 804165
[    0.172010] ..... CPU clock speed is 2010.1661 MHz.
[    0.172010] ..... host bus clock speed is 201.0165 MHz.
[    0.172010] ... verify APIC timer
[    0.283699] ... jiffies delta = 25
[    0.284018] ... jiffies result ok
[    0.288040] calling  trace_init_flags_sys_exit+0x0/0x11 @ 1
[    0.292021] initcall trace_init_flags_sys_exit+0x0/0x11 returned 0 after 0 usecs
[    0.296021] calling  trace_init_flags_sys_enter+0x0/0x11 @ 1
[    0.300021] initcall trace_init_flags_sys_enter+0x0/0x11 returned 0 after 0 usecs
[    0.304020] calling  init_hw_perf_events+0x0/0xe18 @ 1
[    0.308019] Performance Events: AMD PMU driver.
[    0.313511] ... version:                0
[    0.316020] ... bit width:              48
[    0.320020] ... generic registers:      4
[    0.324020] ... value mask:             0000ffffffffffff
[    0.328021] ... max period:             00007fffffffffff
[    0.332021] ... fixed-purpose events:   0
[    0.336021] ... event mask:             000000000000000f
[    0.340052] initcall init_hw_perf_events+0x0/0xe18 returned 0 after 31251 usecs
[    0.344024] calling  migration_init+0x0/0x59 @ 1
[    0.348025] initcall migration_init+0x0/0x59 returned 0 after 0 usecs
[    0.352024] calling  spawn_ksoftirqd+0x0/0x41 @ 1
[    0.356040] initcall spawn_ksoftirqd+0x0/0x41 returned 0 after 0 usecs
[    0.360025] calling  init_workqueues+0x0/0x2d7 @ 1
[    0.364111] initcall init_workqueues+0x0/0x2d7 returned 0 after 0 usecs
[    0.368025] calling  init_jump_label_module+0x0/0xf @ 1
[    0.372026] initcall init_jump_label_module+0x0/0xf returned 0 after 0 usecs
[    0.376025] calling  init_jump_label+0x0/0xde @ 1
[    0.380185] initcall init_jump_label+0x0/0xde returned 0 after 0 usecs
[    0.384027] calling  init_call_single_data+0x0/0x6e @ 1
[    0.388026] initcall init_call_single_data+0x0/0x6e returned 0 after 0 usecs
[    0.392026] calling  cpu_stop_init+0x0/0x7f @ 1
[    0.396042] initcall cpu_stop_init+0x0/0x7f returned 0 after 0 usecs
[    0.400026] calling  relay_init+0x0/0x11 @ 1
[    0.404027] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.408027] calling  tracer_alloc_buffers+0x0/0x180 @ 1
[    0.412117] initcall tracer_alloc_buffers+0x0/0x180 returned 0 after 0 usecs
[    0.416027] calling  init_trace_printk+0x0/0xf @ 1
[    0.420028] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.424109] CPU 1 irqstacks, hard=f608a000 soft=f608c000
[    0.428028] Booting Node   0, Processors  #1 Ok.
[    0.432822] smpboot cpu 1: start_ip = 9e000
[    0.020001] Initializing CPU#1
[    0.020001] masked ExtINT on CPU#1
[    0.536111] Brought up 2 CPUs
[    0.539073] Total of 2 processors activated (8041.44 BogoMIPS).
[    0.540546] calling  init_mmap_min_addr+0x0/0x11 @ 1
[    0.544037] initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
[    0.548035] calling  net_ns_init+0x0/0xe0 @ 1
[    0.552075] initcall net_ns_init+0x0/0xe0 returned 0 after 0 usecs
[    0.556038] calling  e820_mark_nvs_memory+0x0/0x7 @ 1
[    0.560037] initcall e820_mark_nvs_memory+0x0/0x7 returned 0 after 0 usecs
[    0.564037] calling  pci_reboot_init+0x0/0x11 @ 1
[    0.568039] initcall pci_reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.572037] calling  reboot_init+0x0/0x11 @ 1
[    0.576045] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.580038] calling  init_lapic_sysfs+0x0/0x1b @ 1
[    0.584038] initcall init_lapic_sysfs+0x0/0x1b returned 0 after 0 usecs
[    0.588038] calling  init_smp_flush+0x0/0x31 @ 1
[    0.592039] initcall init_smp_flush+0x0/0x31 returned 0 after 0 usecs
[    0.596039] calling  alloc_frozen_cpus+0x0/0x10 @ 1
[    0.600039] initcall alloc_frozen_cpus+0x0/0x10 returned 0 after 0 usecs
[    0.604040] calling  sysctl_init+0x0/0x29 @ 1
[    0.608085] initcall sysctl_init+0x0/0x29 returned 0 after 0 usecs
[    0.612040] calling  ksysfs_init+0x0/0x74 @ 1
[    0.616045] initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs
[    0.620040] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.624042] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.628040] calling  pm_init+0x0/0x62 @ 1
[    0.632056] initcall pm_init+0x0/0x62 returned 0 after 0 usecs
[    0.636041] calling  pm_disk_init+0x0/0x14 @ 1
[    0.640043] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
[    0.644043] calling  swsusp_header_init+0x0/0x30 @ 1
[    0.648043] initcall swsusp_header_init+0x0/0x30 returned 0 after 0 usecs
[    0.652042] calling  init_zero_pfn+0x0/0x43 @ 1
[    0.656043] initcall init_zero_pfn+0x0/0x43 returned 0 after 0 usecs
[    0.660043] calling  fsnotify_init+0x0/0x22 @ 1
[    0.664055] initcall fsnotify_init+0x0/0x22 returned 0 after 0 usecs
[    0.668043] calling  filelock_init+0x0/0x2f @ 1
[    0.672056] initcall filelock_init+0x0/0x2f returned 0 after 0 usecs
[    0.676044] calling  init_script_binfmt+0x0/0x11 @ 1
[    0.680045] initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.684044] calling  init_elf_binfmt+0x0/0x11 @ 1
[    0.688045] initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.692045] calling  debugfs_init+0x0/0x4a @ 1
[    0.696048] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    0.700045] calling  securityfs_init+0x0/0x41 @ 1
[    0.704047] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    0.708045] calling  random32_init+0x0/0xa1 @ 1
[    0.712046] initcall random32_init+0x0/0xa1 returned 0 after 0 usecs
[    0.716047] calling  early_resume_init+0x0/0x1e0 @ 1
[    0.720063] Time: 22:50:12  Date: 03/29/11
[    0.724047] initcall early_resume_init+0x0/0x1e0 returned 0 after 3906 usecs
[    0.728046] calling  sock_init+0x0/0x7d @ 1
[    0.732118] initcall sock_init+0x0/0x7d returned 0 after 0 usecs
[    0.736047] calling  net_inuse_init+0x0/0x22 @ 1
[    0.740059] initcall net_inuse_init+0x0/0x22 returned 0 after 0 usecs
[    0.744047] calling  netpoll_init+0x0/0x2f @ 1
[    0.748048] initcall netpoll_init+0x0/0x2f returned 0 after 0 usecs
[    0.752048] calling  netlink_proto_init+0x0/0x1a5 @ 1
[    0.756052] NET: Registered protocol family 16
[    0.760057] initcall netlink_proto_init+0x0/0x1a5 returned 0 after 3906 usecs
[    0.764049] calling  bdi_class_init+0x0/0x3c @ 1
[    0.768087] initcall bdi_class_init+0x0/0x3c returned 0 after 0 usecs
[    0.772050] calling  kobject_uevent_init+0x0/0x1e @ 1
[    0.776052] initcall kobject_uevent_init+0x0/0x1e returned 0 after 0 usecs
[    0.780050] calling  gpiolib_sysfs_init+0x0/0x74 @ 1
[    0.784062] initcall gpiolib_sysfs_init+0x0/0x74 returned 0 after 0 usecs
[    0.788050] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.792056] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.796053] calling  pci_driver_init+0x0/0xf @ 1
[    0.800059] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    0.804052] calling  tty_class_init+0x0/0x2b @ 1
[    0.808056] initcall tty_class_init+0x0/0x2b returned 0 after 0 usecs
[    0.812052] calling  vtconsole_class_init+0x0/0xc9 @ 1
[    0.816079] initcall vtconsole_class_init+0x0/0xc9 returned 0 after 0 usecs
[    0.820053] calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1
[    0.824056] initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 after 0 usecs
[    0.828053] calling  amd_postcore_init+0x0/0x13e @ 1
[    0.832056] node 0 link 0: io port [1000, fffff]
[    0.836054] TOM: 0000000040000000 aka 1024M
[    0.840054] node 0 link 0: mmio [e0000000, efffffff]
[    0.844244] node 0 link 0: mmio [feb00000, fec0ffff]
[    0.848245] node 0 link 0: mmio [a0000, bffff]
[    0.852244] node 0 link 0: mmio [40000000, fed3ffff]
[    0.856245] bus: [00, ff] on node 0 link 0
[    0.860055] bus: 00 index 0 [io  0x0000-0xffff]
[    0.864055] bus: 00 index 1 [mem 0x40000000-0xffffffff]
[    0.868055] bus: 00 index 2 [mem 0xfeb00000-0xfec0ffff]
[    0.872055] bus: 00 index 3 [mem 0x000a0000-0x000bffff]
[    0.876056] initcall amd_postcore_init+0x0/0x13e returned 0 after 42971 usecs
[    0.880057] calling  arch_kdebugfs_init+0x0/0x1e @ 1
[    0.884059] initcall arch_kdebugfs_init+0x0/0x1e returned 0 after 0 usecs
[    0.888057] calling  init_pit_clocksource+0x0/0xac @ 1
[    0.892058] initcall init_pit_clocksource+0x0/0xac returned 0 after 0 usecs
[    0.896058] calling  configure_trampolines+0x0/0x1f @ 1
[    0.900058] initcall configure_trampolines+0x0/0x1f returned 0 after 0 usecs
[    0.904057] calling  mtrr_if_init+0x0/0x56 @ 1
[    0.908059] initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs
[    0.912058] calling  dynamic_debug_init+0x0/0xfb @ 1
[    0.916102] initcall dynamic_debug_init+0x0/0xfb returned 0 after 0 usecs
[    0.920059] calling  ab8500_gpio_init+0x0/0xf @ 1
[    0.924068] initcall ab8500_gpio_init+0x0/0xf returned 0 after 0 usecs
[    0.928060] calling  dma_bus_init+0x0/0x32 @ 1
[    0.932065] initcall dma_bus_init+0x0/0x32 returned 0 after 0 usecs
[    0.936060] calling  dma_channel_table_init+0x0/0xe0 @ 1
[    0.940158] initcall dma_channel_table_init+0x0/0xe0 returned 0 after 0 usecs
[    0.944061] calling  dmi_id_init+0x0/0x28d @ 1
[    0.948093] initcall dmi_id_init+0x0/0x28d returned 0 after 0 usecs
[    0.952061] calling  pci_arch_init+0x0/0x55 @ 1
[    0.962043] PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
[    0.964060] PCI: Using configuration type 1 for base access
[    0.968072] initcall pci_arch_init+0x0/0x55 returned 0 after 11719 usecs
[    0.972062] calling  topology_init+0x0/0x36 @ 1
[    0.976073] initcall topology_init+0x0/0x36 returned 0 after 0 usecs
[    0.980062] calling  mtrr_init_finialize+0x0/0x30 @ 1
[    0.984063] initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 usecs
[    0.988064] calling  param_sysfs_init+0x0/0x15b @ 1
[    0.992519] initcall param_sysfs_init+0x0/0x15b returned 0 after 0 usecs
[    0.996064] calling  pm_sysrq_init+0x0/0x20 @ 1
[    1.000065] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    1.004064] calling  default_bdi_init+0x0/0xaa @ 1
[    1.008187] initcall default_bdi_init+0x0/0xaa returned 0 after 0 usecs
[    1.012065] calling  init_bio+0x0/0xe2 @ 1
[    1.016104] bio: create slab <bio-0> at 0
[    1.020069] initcall init_bio+0x0/0xe2 returned 0 after 3906 usecs
[    1.024066] calling  fsnotify_notification_init+0x0/0x9c @ 1
[    1.028068] initcall fsnotify_notification_init+0x0/0x9c returned 0 after 0 usecs
[    1.032066] calling  cryptomgr_init+0x0/0xf @ 1
[    1.036066] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    1.040066] calling  blk_settings_init+0x0/0x1d @ 1
[    1.044067] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    1.048067] calling  blk_ioc_init+0x0/0x2f @ 1
[    1.052068] initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
[    1.056067] calling  blk_softirq_init+0x0/0x54 @ 1
[    1.060068] initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usecs
[    1.064068] calling  blk_iopoll_setup+0x0/0x54 @ 1
[    1.068068] initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usecs
[    1.072068] calling  genhd_device_init+0x0/0x6a @ 1
[    1.076128] initcall genhd_device_init+0x0/0x6a returned 0 after 0 usecs
[    1.080069] calling  gpiolib_debugfs_init+0x0/0x2a @ 1
[    1.084071] initcall gpiolib_debugfs_init+0x0/0x2a returned 0 after 0 usecs
[    1.088070] calling  pci_slot_init+0x0/0x50 @ 1
[    1.092071] initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
[    1.096070] calling  pnp_init+0x0/0xf @ 1
[    1.100078] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    1.104070] calling  misc_init+0x0/0xad @ 1
[    1.108079] initcall misc_init+0x0/0xad returned 0 after 0 usecs
[    1.112071] calling  vga_arb_device_init+0x0/0x82 @ 1
[    1.116088] vgaarb: loaded
[    1.118790] initcall vga_arb_device_init+0x0/0x82 returned 0 after 0 usecs
[    1.120072] calling  ab8500_sysctrl_init+0x0/0xf @ 1
[    1.124078] initcall ab8500_sysctrl_init+0x0/0xf returned 0 after 0 usecs
[    1.128072] calling  init_scsi+0x0/0x90 @ 1
[    1.132189] SCSI subsystem initialized
[    1.136073] initcall init_scsi+0x0/0x90 returned 0 after 3906 usecs
[    1.140073] calling  ata_init+0x0/0x2aa @ 1
[    1.144116] libata version 3.00 loaded.
[    1.148074] initcall ata_init+0x0/0x2aa returned 0 after 3906 usecs
[    1.152074] calling  phy_init+0x0/0x28 @ 1
[    1.156096] initcall phy_init+0x0/0x28 returned 0 after 0 usecs
[    1.160074] calling  usb_init+0x0/0x142 @ 1
[    1.164094] usbcore: registered new interface driver usbfs
[    1.168082] usbcore: registered new interface driver hub
[    1.172095] usbcore: registered new device driver usb
[    1.176076] initcall usb_init+0x0/0x142 returned 0 after 11719 usecs
[    1.180075] calling  serio_init+0x0/0x2e @ 1
[    1.184083] initcall serio_init+0x0/0x2e returned 0 after 0 usecs
[    1.188076] calling  input_init+0x0/0xfd @ 1
[    1.192084] initcall input_init+0x0/0xfd returned 0 after 0 usecs
[    1.196076] calling  leds_init+0x0/0x39 @ 1
[    1.200084] initcall leds_init+0x0/0x39 returned 0 after 0 usecs
[    1.204077] calling  pci_subsys_init+0x0/0x44 @ 1
[    1.208076] PCI: Probing PCI hardware
[    1.212077] PCI: Probing PCI hardware (bus 00)
[    1.216110] pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
[    1.220137] pci 0000:00:01.0: [10de:0050] type 0 class 0x000601
[    1.224096] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.228085] pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
[    1.232083] pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
[    1.236088] pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
[    1.240081] pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
[    1.244088] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.248080] pci 0000:00:01.1: PME# disabled
[    1.252091] pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
[    1.256085] pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
[    1.260100] pci 0000:00:02.0: supports D1 D2
[    1.264080] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.268081] pci 0000:00:02.0: PME# disabled
[    1.272089] pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
[    1.276087] pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
[    1.280105] pci 0000:00:02.1: supports D1 D2
[    1.284081] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.288082] pci 0000:00:02.1: PME# disabled
[    1.292095] pci 0000:00:04.0: [10de:0059] type 0 class 0x000401
[    1.296087] pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
[    1.300085] pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
[    1.304085] pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
[    1.308099] pci 0000:00:04.0: supports D1 D2
[    1.312091] pci 0000:00:06.0: [10de:0053] type 0 class 0x000101
[    1.316098] pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
[    1.320102] pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
[    1.324099] pci 0000:00:0a.0: [10de:0057] type 0 class 0x000680
[    1.328089] pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
[    1.332087] pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
[    1.336103] pci 0000:00:0a.0: supports D1 D2
[    1.340085] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.344085] pci 0000:00:0a.0: PME# disabled
[    1.348094] pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
[    1.352105] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.356086] pci 0000:00:0b.0: PME# disabled
[    1.360096] pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
[    1.364105] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.368087] pci 0000:00:0c.0: PME# disabled
[    1.372097] pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
[    1.376106] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.380087] pci 0000:00:0d.0: PME# disabled
[    1.384097] pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
[    1.388106] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.392088] pci 0000:00:0e.0: PME# disabled
[    1.396103] pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
[    1.400105] pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
[    1.404101] pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
[    1.408101] pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
[    1.412105] PCI: peer root bus 00 res updated from pci conf
[    1.416109] pci 0000:05:07.0: [10ec:8139] type 0 class 0x000200
[    1.420099] pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
[    1.424095] pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
[    1.428123] pci 0000:05:07.0: supports D1 D2
[    1.432090] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    1.436092] pci 0000:05:07.0: PME# disabled
[    1.440112] pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
[    1.444092] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    1.448092] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    1.452093] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.456092] pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
[    1.460092] pci 0000:00:09.0:   bridge window [mem 0x40000000-0xffffffff] (subtractive decode)
[    1.464093] pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
[    1.468093] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.472111] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    1.476095] pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.480094] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.484095] pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.488113] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    1.492095] pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.496095] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.500096] pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.504112] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    1.508096] pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.512096] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.516097] pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.520120] pci 0000:01:00.0: [1002:5b60] type 0 class 0x000300
[    1.524103] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
[    1.528101] pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
[    1.532101] pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
[    1.536114] pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    1.540109] pci 0000:01:00.0: supports D1 D2
[    1.544111] pci 0000:01:00.1: [1002:5b70] type 0 class 0x000380
[    1.548103] pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
[    1.552134] pci 0000:01:00.1: supports D1 D2
[    1.556106] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.560104] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    1.564101] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    1.568100] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    1.572101] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    1.576604] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.580420] pci 0000:00:00.0: default IRQ router [10de:005e]
[    1.584112] PCI: pci_cache_line_size set to 64 bytes
[    1.588110] pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
[    1.592138] Expanded resource reserved due to conflict with PCI Bus #00
[    1.596101] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    1.600101] reserve RAM buffer: 000000003fff0000 - 000000003fffffff 
[    1.604104] initcall pci_subsys_init+0x0/0x44 returned 0 after 386742 usecs
[    1.608102] calling  proto_init+0x0/0xf @ 1
[    1.612104] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    1.616102] calling  net_dev_init+0x0/0x1cf @ 1
[    1.620197] initcall net_dev_init+0x0/0x1cf returned 0 after 0 usecs
[    1.624103] calling  neigh_init+0x0/0x7a @ 1
[    1.628103] initcall neigh_init+0x0/0x7a returned 0 after 0 usecs
[    1.632103] calling  pktsched_init+0x0/0xe4 @ 1
[    1.636106] initcall pktsched_init+0x0/0xe4 returned 0 after 0 usecs
[    1.640104] calling  tc_filter_init+0x0/0x50 @ 1
[    1.644104] initcall tc_filter_init+0x0/0x50 returned 0 after 0 usecs
[    1.648104] calling  tc_action_init+0x0/0x50 @ 1
[    1.652105] initcall tc_action_init+0x0/0x50 returned 0 after 0 usecs
[    1.656105] calling  genl_init+0x0/0x7b @ 1
[    1.660113] initcall genl_init+0x0/0x7b returned 0 after 0 usecs
[    1.664105] calling  sysctl_init+0x0/0x3b @ 1
[    1.668107] initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
[    1.672106] calling  print_ICs+0x0/0x4f5 @ 1
[    1.676105] 
[    1.676106] printing PIC contents
[    1.680107] ... PIC  IMR: fffa
[    1.683155] ... PIC  IRR: 0001
[    1.684105] ... PIC  ISR: 0001
[    1.687157] ... PIC ELCR: 0828
[    1.688107] printing local APIC contents on CPU#0/0:
[    1.692105] ... APIC ID:      00000000 (0)
[    1.692105] ... APIC VERSION: 00040010
[    1.692105] ... APIC TASKPRI: 00000000 (00)
[    1.692105] ... APIC ARBPRI: 000000e0 (e0)
[    1.692105] ... APIC PROCPRI: 00000000
[    1.692105] ... APIC LDR: 01000000
[    1.692105] ... APIC DFR: ffffffff
[    1.692105] ... APIC SPIV: 000001ff
[    1.692105] ... APIC ISR field:
[    1.692105] 0000000000000000000000000000000000000000000000000000000000000000
[    1.692105] ... APIC TMR field:
[    1.692105] 0000000000000000000000000000000000000000000000000000000000000000
[    1.692105] ... APIC IRR field:
[    1.692105] 0000000000000000000000000000000000000000000000000000000000008000
[    1.692105] ... APIC ESR: 00000000
[    1.692105] ... APIC ICR: 000008fd
[    1.692105] ... APIC ICR2: 02000000
[    1.692105] ... APIC LVTT: 000200ef
[    1.692105] ... APIC LVTPC: 00000400
[    1.692105] ... APIC LVT0: 00010700
[    1.692105] ... APIC LVT1: 00000400
[    1.692105] ... APIC LVTERR: 000000fe
[    1.692105] ... APIC TMICT: 0000c454
[    1.692105] ... APIC TMCCT: 0000b1f5
[    1.692105] ... APIC TDCR: 00000003
[    1.692105] 
[    1.692106] number of MP IRQ sources: 17.
[    1.696106] number of IO-APIC #2 registers: 24.
[    1.700106] testing the IO APIC.......................
[    1.704109] 
[    1.708107] IO APIC #2......
[    1.710981] .... register #00: 00000000
[    1.712107] .......    : physical APIC id: 00
[    1.716107] .......    : Delivery Type: 0
[    1.720108] .......    : LTS          : 0
[    1.724108] .... register #01: 00170011
[    1.728108] .......     : max redirection entries: 0017
[    1.732108] .......     : PRQ implemented: 0
[    1.736109] .......     : IO APIC version: 0011
[    1.740109] .... register #02: 00000000
[    1.744109] .......     : arbitration: 00
[    1.748109] .... IRQ redirection table:
[    1.752109]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    1.756112]  00 003 0    0    0   0   0    1    1    30
[    1.763332]  01 003 0    0    0   0   0    1    1    31
[    1.768112]  02 000 1    0    0   0   0    0    0    00
[    1.772113]  03 003 1    1    0   1   0    1    1    29
[    1.776113]  04 003 0    0    0   0   0    1    1    34
[    1.784113]  05 003 1    1    0   1   0    1    1    41
[    1.788114]  06 003 0    0    0   0   0    1    1    36
[    1.792114]  07 003 1    0    0   0   0    1    1    37
[    1.800114]  08 003 0    0    0   0   0    1    1    38
[    1.804115]  09 003 0    0    0   0   0    1    1    39
[    1.808115]  0a 003 0    0    0   0   0    1    1    3A
[    1.815336]  0b 003 1    1    0   1   0    1    1    49
[    1.820117]  0c 003 0    0    0   0   0    1    1    3C
[    1.824116]  0d 003 0    0    0   0   0    1    1    3D
[    1.831337]  0e 003 0    0    0   0   0    1    1    3E
[    1.836117]  0f 003 0    0    0   0   0    1    1    3F
[    1.840117]  10 000 1    0    0   0   0    0    0    00
[    1.844117]  11 000 1    0    0   0   0    0    0    00
[    1.852118]  12 000 1    0    0   0   0    0    0    00
[    1.856118]  13 000 1    0    0   0   0    0    0    00
[    1.860118]  14 000 1    0    0   0   0    0    0    00
[    1.868119]  15 000 1    0    0   0   0    0    0    00
[    1.872119]  16 000 1    0    0   0   0    0    0    00
[    1.876119]  17 000 1    0    0   0   0    0    0    00
[    1.883339] IRQ to pin mappings:
[    1.884119] IRQ0 -> 0:0
[    1.888845] IRQ1 -> 0:1
[    1.892119] IRQ4 -> 0:4
[    1.894594] IRQ6 -> 0:6
[    1.896845] IRQ7 -> 0:7
[    1.899322] IRQ8 -> 0:8
[    1.900845] IRQ9 -> 0:9
[    1.904307] IRQ10 -> 0:10
[    1.906958] IRQ12 -> 0:12
[    1.908932] IRQ13 -> 0:13
[    1.912309] IRQ14 -> 0:14
[    1.914959] IRQ15 -> 0:15
[    1.916932] IRQ27 -> 0:3
[    1.920308] IRQ29 -> 0:5
[    1.922873] IRQ35 -> 0:11
[    1.924933] .................................... done.
[    1.928122] initcall print_ICs+0x0/0x4f5 returned 0 after 246109 usecs
[    1.932122] calling  hpet_late_init+0x0/0xdd @ 1
[    1.936123] initcall hpet_late_init+0x0/0xdd returned -19 after 0 usecs
[    1.940123] calling  init_amd_nbs+0x0/0xb7 @ 1
[    1.944160] initcall init_amd_nbs+0x0/0xb7 returned 0 after 0 usecs
[    1.948124] calling  clocksource_done_booting+0x0/0x4f @ 1
[    1.952125] initcall clocksource_done_booting+0x0/0x4f returned 0 after 0 usecs
[    1.956124] calling  ftrace_init_debugfs+0x0/0x21a @ 1
[    1.960141] initcall ftrace_init_debugfs+0x0/0x21a returned 0 after 0 usecs
[    1.964124] calling  rb_init_debugfs+0x0/0x2f @ 1
[    1.968133] initcall rb_init_debugfs+0x0/0x2f returned 0 after 0 usecs
[    1.972125] calling  tracer_init_debugfs+0x0/0x36e @ 1
[    1.976193] initcall tracer_init_debugfs+0x0/0x36e returned 0 after 0 usecs
[    1.980125] calling  init_trace_printk_function_export+0x0/0x33 @ 1
[    1.984127] initcall init_trace_printk_function_export+0x0/0x33 returned 0 after 0 usecs
[    1.988126] calling  event_trace_init+0x0/0x269 @ 1
[    1.993346] initcall event_trace_init+0x0/0x269 returned 0 after 0 usecs
[    1.996129] calling  init_pipe_fs+0x0/0x3d @ 1
[    2.000163] initcall init_pipe_fs+0x0/0x3d returned 0 after 0 usecs
[    2.004127] calling  eventpoll_init+0x0/0xef @ 1
[    2.008150] initcall eventpoll_init+0x0/0xef returned 0 after 0 usecs
[    2.012127] calling  anon_inode_init+0x0/0x102 @ 1
[    2.016154] initcall anon_inode_init+0x0/0x102 returned 0 after 0 usecs
[    2.020128] calling  tomoyo_initerface_init+0x0/0x122 @ 1
[    2.024168] initcall tomoyo_initerface_init+0x0/0x122 returned 0 after 0 usecs
[    2.028128] calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
[    2.032129] initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 0 usecs
[    2.036129] calling  pnp_system_init+0x0/0xf @ 1
[    2.040150] initcall pnp_system_init+0x0/0xf returned 0 after 0 usecs
[    2.044129] calling  pnpbios_init+0x0/0x34d @ 1
[    2.048130] PnPBIOS: Scanning system for PnP BIOS support...
[    2.052355] PnPBIOS: Found PnP BIOS installation structure at 0xc00fc550
[    2.056132] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc580, dseg 0xf0000
[    2.060164] pnp 00:00: [irq 2]
[    2.064131] pnp 00:00: [io  0x0020-0x0021]
[    2.068130] pnp 00:00: [io  0x00a0-0x00a1]
[    2.072153] pnp 00:00: Plug and Play BIOS device, IDs PNP0000 (active)
[    2.076148] pnp 00:01: [dma 4]
[    2.080131] pnp 00:01: [io  0x0000-0x000f]
[    2.084131] pnp 00:01: [io  0x0081-0x0083]
[    2.088131] pnp 00:01: [io  0x0087]
[    2.092132] pnp 00:01: [io  0x0089-0x008b]
[    2.096132] pnp 00:01: [io  0x008f-0x0091]
[    2.100132] pnp 00:01: [io  0x00c0-0x00df]
[    2.104146] pnp 00:01: Plug and Play BIOS device, IDs PNP0200 (active)
[    2.108141] pnp 00:02: [irq 0]
[    2.112133] pnp 00:02: [io  0x0040-0x0043]
[    2.116146] pnp 00:02: Plug and Play BIOS device, IDs PNP0100 (active)
[    2.120142] pnp 00:03: [irq 8]
[    2.123196] pnp 00:03: [io  0x0070-0x0071]
[    2.124147] pnp 00:03: Plug and Play BIOS device, IDs PNP0b00 (active)
[    2.128145] pnp 00:04: [irq 1]
[    2.132134] pnp 00:04: [io  0x0060]
[    2.136134] pnp 00:04: [io  0x0064]
[    2.140148] pnp 00:04: Plug and Play BIOS device, IDs PNP0303 (active)
[    2.144144] pnp 00:05: [io  0x0061]
[    2.148152] pnp 00:05: Plug and Play BIOS device, IDs PNP0800 (active)
[    2.152145] pnp 00:06: [irq 13]
[    2.156136] pnp 00:06: [io  0x00f0-0x00ff]
[    2.160149] pnp 00:06: Plug and Play BIOS device, IDs PNP0c04 (active)
[    2.164156] pnp 00:07: [mem 0x00000000-0x0009ffff]
[    2.168137] pnp 00:07: [mem 0xfffe0000-0xffffffff]
[    2.172137] pnp 00:07: [mem 0xfec00000-0xfec0ffff]
[    2.176137] pnp 00:07: [mem 0xfee00000-0xfeefffff]
[    2.180137] pnp 00:07: [mem 0xfefffc00-0xfeffffff]
[    2.184138] pnp 00:07: [mem 0x00100000-0x00ffffff]
[    2.188190] system 00:07: [mem 0x00000000-0x0009ffff] could not be reserved
[    2.192139] system 00:07: [mem 0xfffe0000-0xffffffff] has been reserved
[    2.196139] system 00:07: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    2.200139] system 00:07: [mem 0xfee00000-0xfeefffff] has been reserved
[    2.204139] system 00:07: [mem 0xfefffc00-0xfeffffff] has been reserved
[    2.208140] system 00:07: [mem 0x00100000-0x00ffffff] could not be reserved
[    2.212140] system 00:07: Plug and Play BIOS device, IDs PNP0c01 (active)
[    2.216155] pnp 00:08: [mem 0x000f0000-0x000f3fff]
[    2.220140] pnp 00:08: [mem 0x000f4000-0x000f7fff]
[    2.224140] pnp 00:08: [mem 0x000f8000-0x000fbfff]
[    2.228140] pnp 00:08: [mem 0x000fc000-0x000fffff]
[    2.232176] system 00:08: [mem 0x000f0000-0x000f3fff] could not be reserved
[    2.236141] system 00:08: [mem 0x000f4000-0x000f7fff] could not be reserved
[    2.240142] system 00:08: [mem 0x000f8000-0x000fbfff] could not be reserved
[    2.244142] system 00:08: [mem 0x000fc000-0x000fffff] could not be reserved
[    2.248142] system 00:08: Plug and Play BIOS device, IDs PNP0c02 (active)
[    2.252156] pnp 00:09: [io  0x0290-0x029f]
[    2.256142] pnp 00:09: [io  0x04d0-0x04d1]
[    2.260142] pnp 00:09: [io  0x0cf8-0x0cff]
[    2.264160] pnp 00:09: Plug and Play BIOS device, IDs PNP0a03 (active)
[    2.268223] pnp 00:0b: [irq 4]
[    2.272143] pnp 00:0b: [io  0x03f8-0x03ff]
[    2.276169] pnp 00:0b: Plug and Play BIOS device, IDs PNP0501 (active)
[    2.280204] pnp 00:0c: [dma 2]
[    2.284144] pnp 00:0c: [io  0x03f0-0x03f5]
[    2.288144] pnp 00:0c: [io  0x03f7]
[    2.292144] pnp 00:0c: [irq 6]
[    2.295209] pnp 00:0c: Plug and Play BIOS device, IDs PNP0700 (active)
[    2.296251] pnp 00:0e: [dma 3]
[    2.300145] pnp 00:0e: [irq 7]
[    2.304145] pnp 00:0e: [io  0x0378-0x037f]
[    2.308145] pnp 00:0e: [io  0x0778-0x077f]
[    2.312172] pnp 00:0e: Plug and Play BIOS device, IDs PNP0401 (active)
[    2.316225] pnp 00:0f: [irq 10]
[    2.320146] pnp 00:0f: [io  0x0330-0x0333]
[    2.324166] pnp 00:0f: Plug and Play BIOS device, IDs PNPb006 (active)
[    2.328218] pnp 00:10: [io  0x0201]
[    2.332168] pnp 00:10: Plug and Play BIOS device, IDs PNPb02f (active)
[    2.336147] PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
[    2.340148] initcall pnpbios_init+0x0/0x34d returned 0 after 285174 usecs
[    2.344148] calling  chr_dev_init+0x0/0xc3 @ 1
[    2.349517] initcall chr_dev_init+0x0/0xc3 returned 0 after 0 usecs
[    2.352151] calling  firmware_class_init+0x0/0x14 @ 1
[    2.356158] initcall firmware_class_init+0x0/0x14 returned 0 after 0 usecs
[    2.360150] calling  pcibios_assign_resources+0x0/0x69 @ 1
[    2.364183] pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
[    2.368151] pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff])
[    2.372150] pci 0000:00:09.0: PCI bridge to [bus 05-05]
[    2.376150] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    2.380151] pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
[    2.384150] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    2.388151] pci 0000:00:0b.0: PCI bridge to [bus 04-04]
[    2.392150] pci 0000:00:0b.0:   bridge window [io  disabled]
[    2.396151] pci 0000:00:0b.0:   bridge window [mem disabled]
[    2.400151] pci 0000:00:0b.0:   bridge window [mem pref disabled]
[    2.404152] pci 0000:00:0c.0: PCI bridge to [bus 03-03]
[    2.408151] pci 0000:00:0c.0:   bridge window [io  disabled]
[    2.412152] pci 0000:00:0c.0:   bridge window [mem disabled]
[    2.416152] pci 0000:00:0c.0:   bridge window [mem pref disabled]
[    2.420153] pci 0000:00:0d.0: PCI bridge to [bus 02-02]
[    2.424152] pci 0000:00:0d.0:   bridge window [io  disabled]
[    2.428153] pci 0000:00:0d.0:   bridge window [mem disabled]
[    2.432153] pci 0000:00:0d.0:   bridge window [mem pref disabled]
[    2.436156] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
[    2.440154] pci 0000:00:0e.0: PCI bridge to [bus 01-01]
[    2.444154] pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
[    2.448155] pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
[    2.452155] pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.456160] pci 0000:00:09.0: setting latency timer to 64
[    2.460157] pci 0000:00:0b.0: setting latency timer to 64
[    2.464157] pci 0000:00:0c.0: setting latency timer to 64
[    2.468157] pci 0000:00:0d.0: setting latency timer to 64
[    2.472157] pci 0000:00:0e.0: setting latency timer to 64
[    2.476157] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.480156] pci_bus 0000:00: resource 5 [mem 0x40000000-0xffffffff]
[    2.484156] pci_bus 0000:00: resource 6 [mem 0xfeb00000-0xfec0ffff]
[    2.488157] pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
[    2.492157] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    2.496157] pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
[    2.500157] pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
[    2.504158] pci_bus 0000:05: resource 5 [mem 0x40000000-0xffffffff]
[    2.508158] pci_bus 0000:05: resource 6 [mem 0xfeb00000-0xfec0ffff]
[    2.512158] pci_bus 0000:05: resource 7 [mem 0x000a0000-0x000bffff]
[    2.516159] pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
[    2.520159] pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
[    2.524159] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
[    2.528161] initcall pcibios_assign_resources+0x0/0x69 returned 0 after 160166 usecs
[    2.532160] calling  sysctl_core_init+0x0/0x2d @ 1
[    2.536173] initcall sysctl_core_init+0x0/0x2d returned 0 after 0 usecs
[    2.540160] calling  inet_init+0x0/0x1d8 @ 1
[    2.544207] NET: Registered protocol family 2
[    2.548242] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    2.552385] IPv4 FIB: Using LC-trie version 0.409
[    2.556254] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.560861] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    2.564506] TCP: Hash tables configured (established 131072 bind 65536)
[    2.568162] TCP reno registered
[    2.572164] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    2.576174] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    2.580401] initcall inet_init+0x0/0x1d8 returned 0 after 35158 usecs
[    2.584164] calling  af_unix_init+0x0/0x4d @ 1
[    2.588171] NET: Registered protocol family 1
[    2.592168] initcall af_unix_init+0x0/0x4d returned 0 after 3906 usecs
[    2.596165] calling  pci_apply_final_quirks+0x0/0x10d @ 1
[    2.616224] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.620168] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    2.624170] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.628197] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.632168] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    2.636171] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.640202] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.644169] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    2.648171] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.652206] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.656170] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    2.660172] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    2.664179] pci 0000:01:00.0: Boot video device
[    2.668170] PCI: CLS 32 bytes, default 64
[    2.672169] initcall pci_apply_final_quirks+0x0/0x10d returned 0 after 70316 usecs
[    2.676170] calling  default_rootfs+0x0/0x75 @ 1
[    2.680204] initcall default_rootfs+0x0/0x75 returned 0 after 0 usecs
[    2.684170] calling  pci_iommu_init+0x0/0x48 @ 1
[    2.694908] DMA-API: preallocated 32768 debug entries
[    2.696170] DMA-API: debugging enabled by kernel config
[    2.700175] initcall pci_iommu_init+0x0/0x48 returned 0 after 11719 usecs
[    2.704171] calling  i8259A_init_ops+0x0/0x1d @ 1
[    2.708172] initcall i8259A_init_ops+0x0/0x1d returned 0 after 0 usecs
[    2.712171] calling  sbf_init+0x0/0xc2 @ 1
[    2.716172] initcall sbf_init+0x0/0xc2 returned 0 after 0 usecs
[    2.720172] calling  init_tsc_clocksource+0x0/0x58 @ 1
[    2.724179] initcall init_tsc_clocksource+0x0/0x58 returned 0 after 0 usecs
[    2.728173] calling  add_rtc_cmos+0x0/0x7b @ 1
[    2.732175] initcall add_rtc_cmos+0x0/0x7b returned 0 after 0 usecs
[    2.736173] calling  i8237A_init_ops+0x0/0x11 @ 1
[    2.740174] initcall i8237A_init_ops+0x0/0x11 returned 0 after 0 usecs
[    2.744175] calling  cache_sysfs_init+0x0/0x5e @ 1
[    2.748261] initcall cache_sysfs_init+0x0/0x5e returned 0 after 0 usecs
[    2.752175] calling  ioapic_init_ops+0x0/0x54 @ 1
[    2.756174] initcall ioapic_init_ops+0x0/0x54 returned 0 after 0 usecs
[    2.760174] calling  add_pcspkr+0x0/0x43 @ 1
[    2.764202] initcall add_pcspkr+0x0/0x43 returned 0 after 0 usecs
[    2.768175] calling  proc_execdomains_init+0x0/0x27 @ 1
[    2.772181] initcall proc_execdomains_init+0x0/0x27 returned 0 after 0 usecs
[    2.776175] calling  ioresources_init+0x0/0x44 @ 1
[    2.780178] initcall ioresources_init+0x0/0x44 returned 0 after 0 usecs
[    2.784176] calling  uid_cache_init+0x0/0x83 @ 1
[    2.788183] initcall uid_cache_init+0x0/0x83 returned 0 after 0 usecs
[    2.792176] calling  init_posix_timers+0x0/0x18f @ 1
[    2.796179] initcall init_posix_timers+0x0/0x18f returned 0 after 0 usecs
[    2.800177] calling  init_posix_cpu_timers+0x0/0x9b @ 1
[    2.804178] initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 0 usecs
[    2.808177] calling  nsproxy_cache_init+0x0/0x32 @ 1
[    2.812179] initcall nsproxy_cache_init+0x0/0x32 returned 0 after 0 usecs
[    2.816178] calling  timekeeping_init_ops+0x0/0x11 @ 1
[    2.820179] initcall timekeeping_init_ops+0x0/0x11 returned 0 after 0 usecs
[    2.824178] calling  init_clocksource_sysfs+0x0/0x43 @ 1
[    2.828191] initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 0 usecs
[    2.832178] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    2.836180] initcall init_timer_list_procfs+0x0/0x30 returned 0 after 0 usecs
[    2.840178] calling  futex_init+0x0/0x57 @ 1
[    2.844187] initcall futex_init+0x0/0x57 returned 0 after 0 usecs
[    2.848179] calling  proc_dma_init+0x0/0x27 @ 1
[    2.852181] initcall proc_dma_init+0x0/0x27 returned 0 after 0 usecs
[    2.856180] calling  proc_modules_init+0x0/0x27 @ 1
[    2.860185] initcall proc_modules_init+0x0/0x27 returned 0 after 0 usecs
[    2.864180] calling  kallsyms_init+0x0/0x2a @ 1
[    2.868182] initcall kallsyms_init+0x0/0x2a returned 0 after 0 usecs
[    2.872181] calling  snapshot_device_init+0x0/0xf @ 1
[    2.876216] initcall snapshot_device_init+0x0/0xf returned 0 after 0 usecs
[    2.880182] calling  crash_save_vmcoreinfo_init+0x0/0x508 @ 1
[    2.884205] initcall crash_save_vmcoreinfo_init+0x0/0x508 returned 0 after 0 usecs
[    2.888182] calling  crash_notes_memory_init+0x0/0x33 @ 1
[    2.892198] initcall crash_notes_memory_init+0x0/0x33 returned 0 after 0 usecs
[    2.896182] calling  rcutree_trace_init+0x0/0xfc @ 1
[    2.900195] initcall rcutree_trace_init+0x0/0xfc returned 0 after 0 usecs
[    2.904183] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    2.908199] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 0 usecs
[    2.912184] calling  init_tracepoints+0x0/0x20 @ 1
[    2.916185] initcall init_tracepoints+0x0/0x20 returned 0 after 0 usecs
[    2.920184] calling  ftrace_mod_cmd_init+0x0/0xf @ 1
[    2.924185] initcall ftrace_mod_cmd_init+0x0/0xf returned 0 after 0 usecs
[    2.928184] calling  init_events+0x0/0x5d @ 1
[    2.932187] initcall init_events+0x0/0x5d returned 0 after 0 usecs
[    2.936185] calling  init_function_trace+0x0/0x35 @ 1
[    2.940187] initcall init_function_trace+0x0/0x35 returned 0 after 0 usecs
[    2.944185] calling  init_wakeup_tracer+0x0/0x1d @ 1
[    2.948186] initcall init_wakeup_tracer+0x0/0x1d returned 0 after 0 usecs
[    2.952186] calling  init_graph_trace+0x0/0x6c @ 1
[    2.956187] initcall init_graph_trace+0x0/0x6c returned 0 after 0 usecs
[    2.960186] calling  perf_event_sysfs_init+0x0/0x95 @ 1
[    2.964251] initcall perf_event_sysfs_init+0x0/0x95 returned 0 after 0 usecs
[    2.968187] calling  init_per_zone_wmark_min+0x0/0x67 @ 1
[    2.972226] initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 0 usecs
[    2.976187] calling  kswapd_init+0x0/0x1d @ 1
[    2.980285] initcall kswapd_init+0x0/0x1d returned 0 after 0 usecs
[    2.984188] calling  setup_vmstat+0x0/0xcd @ 1
[    2.988196] initcall setup_vmstat+0x0/0xcd returned 0 after 0 usecs
[    2.992188] calling  mm_sysfs_init+0x0/0x22 @ 1
[    2.996192] initcall mm_sysfs_init+0x0/0x22 returned 0 after 0 usecs
[    3.000190] calling  proc_vmalloc_init+0x0/0x2a @ 1
[    3.004191] initcall proc_vmalloc_init+0x0/0x2a returned 0 after 0 usecs
[    3.008190] calling  init_emergency_pool+0x0/0x79 @ 1
[    3.012214] highmem bounce pool size: 64 pages
[    3.016191] initcall init_emergency_pool+0x0/0x79 returned 0 after 3906 usecs
[    3.020190] calling  procswaps_init+0x0/0x27 @ 1
[    3.024192] initcall procswaps_init+0x0/0x27 returned 0 after 0 usecs
[    3.028191] calling  ksm_init+0x0/0x15c @ 1
[    3.032227] initcall ksm_init+0x0/0x15c returned 0 after 0 usecs
[    3.036192] calling  slab_proc_init+0x0/0x2a @ 1
[    3.040194] initcall slab_proc_init+0x0/0x2a returned 0 after 0 usecs
[    3.044192] calling  slab_sysfs_init+0x0/0xef @ 1
[    3.049783] initcall slab_sysfs_init+0x0/0xef returned 0 after 0 usecs
[    3.052193] calling  fcntl_init+0x0/0x2f @ 1
[    3.056200] initcall fcntl_init+0x0/0x2f returned 0 after 0 usecs
[    3.060193] calling  proc_filesystems_init+0x0/0x27 @ 1
[    3.064195] initcall proc_filesystems_init+0x0/0x27 returned 0 after 0 usecs
[    3.068193] calling  fsnotify_mark_init+0x0/0x46 @ 1
[    3.072209] initcall fsnotify_mark_init+0x0/0x46 returned 0 after 0 usecs
[    3.076194] calling  dnotify_init+0x0/0x7c @ 1
[    3.080247] initcall dnotify_init+0x0/0x7c returned 0 after 0 usecs
[    3.084195] calling  inotify_user_setup+0x0/0x78 @ 1
[    3.088205] initcall inotify_user_setup+0x0/0x78 returned 0 after 0 usecs
[    3.092195] calling  fanotify_user_setup+0x0/0x5a @ 1
[    3.096240] initcall fanotify_user_setup+0x0/0x5a returned 0 after 0 usecs
[    3.100197] calling  aio_setup+0x0/0xad @ 1
[    3.104224] initcall aio_setup+0x0/0xad returned 0 after 0 usecs
[    3.108196] calling  proc_locks_init+0x0/0x27 @ 1
[    3.112198] initcall proc_locks_init+0x0/0x27 returned 0 after 0 usecs
[    3.116196] calling  init_mbcache+0x0/0x11 @ 1
[    3.120197] initcall init_mbcache+0x0/0x11 returned 0 after 0 usecs
[    3.124197] calling  proc_cmdline_init+0x0/0x27 @ 1
[    3.128199] initcall proc_cmdline_init+0x0/0x27 returned 0 after 0 usecs
[    3.132197] calling  proc_consoles_init+0x0/0x27 @ 1
[    3.136199] initcall proc_consoles_init+0x0/0x27 returned 0 after 0 usecs
[    3.140198] calling  proc_cpuinfo_init+0x0/0x27 @ 1
[    3.144200] initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 0 usecs
[    3.148198] calling  proc_devices_init+0x0/0x27 @ 1
[    3.152200] initcall proc_devices_init+0x0/0x27 returned 0 after 0 usecs
[    3.156199] calling  proc_interrupts_init+0x0/0x27 @ 1
[    3.160201] initcall proc_interrupts_init+0x0/0x27 returned 0 after 0 usecs
[    3.164199] calling  proc_loadavg_init+0x0/0x27 @ 1
[    3.168201] initcall proc_loadavg_init+0x0/0x27 returned 0 after 0 usecs
[    3.172200] calling  proc_meminfo_init+0x0/0x27 @ 1
[    3.176202] initcall proc_meminfo_init+0x0/0x27 returned 0 after 0 usecs
[    3.180200] calling  proc_stat_init+0x0/0x27 @ 1
[    3.184202] initcall proc_stat_init+0x0/0x27 returned 0 after 0 usecs
[    3.188201] calling  proc_uptime_init+0x0/0x27 @ 1
[    3.192203] initcall proc_uptime_init+0x0/0x27 returned 0 after 0 usecs
[    3.196201] calling  proc_version_init+0x0/0x27 @ 1
[    3.200203] initcall proc_version_init+0x0/0x27 returned 0 after 0 usecs
[    3.204202] calling  proc_softirqs_init+0x0/0x27 @ 1
[    3.208204] initcall proc_softirqs_init+0x0/0x27 returned 0 after 0 usecs
[    3.212202] calling  proc_kcore_init+0x0/0xae @ 1
[    3.216206] initcall proc_kcore_init+0x0/0xae returned 0 after 0 usecs
[    3.220203] calling  proc_kmsg_init+0x0/0x2a @ 1
[    3.224205] initcall proc_kmsg_init+0x0/0x2a returned 0 after 0 usecs
[    3.228203] calling  proc_page_init+0x0/0x4a @ 1
[    3.232206] initcall proc_page_init+0x0/0x4a returned 0 after 0 usecs
[    3.236204] calling  configfs_init+0x0/0xc8 @ 1
[    3.240283] initcall configfs_init+0x0/0xc8 returned 0 after 0 usecs
[    3.244205] calling  init_devpts_fs+0x0/0x3d @ 1
[    3.248236] initcall init_devpts_fs+0x0/0x3d returned 0 after 0 usecs
[    3.252205] calling  init_ext3_fs+0x0/0x6c @ 1
[    3.256283] initcall init_ext3_fs+0x0/0x6c returned 0 after 0 usecs
[    3.260206] calling  journal_init+0x0/0xd3 @ 1
[    3.264329] initcall journal_init+0x0/0xd3 returned 0 after 0 usecs
[    3.268206] calling  init_ramfs_fs+0x0/0xf @ 1
[    3.272208] initcall init_ramfs_fs+0x0/0xf returned 0 after 0 usecs
[    3.276206] calling  init_pstore_fs+0x0/0xf @ 1
[    3.280207] initcall init_pstore_fs+0x0/0xf returned 0 after 0 usecs
[    3.284206] calling  ipc_init+0x0/0x20 @ 1
[    3.288209] msgmni has been set to 1743
[    3.292210] initcall ipc_init+0x0/0x20 returned 0 after 3906 usecs
[    3.296207] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    3.300226] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 0 usecs
[    3.304208] calling  init_mqueue_fs+0x0/0x9f @ 1
[    3.308290] initcall init_mqueue_fs+0x0/0x9f returned 0 after 0 usecs
[    3.312208] calling  key_proc_init+0x0/0x64 @ 1
[    3.316212] initcall key_proc_init+0x0/0x64 returned 0 after 0 usecs
[    3.320209] calling  crypto_wq_init+0x0/0x38 @ 1
[    3.324238] initcall crypto_wq_init+0x0/0x38 returned 0 after 0 usecs
[    3.328210] calling  crypto_algapi_init+0x0/0xc @ 1
[    3.332212] initcall crypto_algapi_init+0x0/0xc returned 0 after 0 usecs
[    3.336210] calling  skcipher_module_init+0x0/0x28 @ 1
[    3.340210] initcall skcipher_module_init+0x0/0x28 returned 0 after 0 usecs
[    3.344210] calling  chainiv_module_init+0x0/0xf @ 1
[    3.348212] initcall chainiv_module_init+0x0/0xf returned 0 after 0 usecs
[    3.352211] calling  eseqiv_module_init+0x0/0xf @ 1
[    3.356212] initcall eseqiv_module_init+0x0/0xf returned 0 after 0 usecs
[    3.360211] calling  hmac_module_init+0x0/0xf @ 1
[    3.364212] initcall hmac_module_init+0x0/0xf returned 0 after 0 usecs
[    3.368212] calling  md5_mod_init+0x0/0xf @ 1
[    3.372279] initcall md5_mod_init+0x0/0xf returned 0 after 0 usecs
[    3.376213] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    3.380257] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 0 usecs
[    3.384218] calling  krng_mod_init+0x0/0xf @ 1
[    3.388229] alg: No test for stdrng (krng)
[    3.392223] initcall krng_mod_init+0x0/0xf returned 0 after 3906 usecs
[    3.396215] calling  proc_genhd_init+0x0/0x44 @ 1
[    3.400217] initcall proc_genhd_init+0x0/0x44 returned 0 after 0 usecs
[    3.404214] calling  bsg_init+0x0/0x117 @ 1
[    3.408266] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    3.412216] initcall bsg_init+0x0/0x117 returned 0 after 3906 usecs
[    3.416215] calling  noop_init+0x0/0x11 @ 1
[    3.420215] io scheduler noop registered (default)
[    3.424215] initcall noop_init+0x0/0x11 returned 0 after 3906 usecs
[    3.428216] calling  percpu_counter_startup+0x0/0x16 @ 1
[    3.432217] initcall percpu_counter_startup+0x0/0x16 returned 0 after 0 usecs
[    3.436216] calling  dynamic_debug_init_debugfs+0x0/0x65 @ 1
[    3.440220] initcall dynamic_debug_init_debugfs+0x0/0x65 returned 0 after 0 usecs
[    3.444217] calling  pci_proc_init+0x0/0x64 @ 1
[    3.448264] initcall pci_proc_init+0x0/0x64 returned 0 after 0 usecs
[    3.452217] calling  pcie_portdrv_init+0x0/0x6f @ 1
[    3.456243] pcieport 0000:00:0b.0: setting latency timer to 64
[    3.460238] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    3.464255] pcieport 0000:00:0c.0: setting latency timer to 64
[    3.468231] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    3.472249] pcieport 0000:00:0d.0: setting latency timer to 64
[    3.476232] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    3.480252] pcieport 0000:00:0e.0: setting latency timer to 64
[    3.484231] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    3.488258] initcall pcie_portdrv_init+0x0/0x6f returned 0 after 31251 usecs
[    3.492220] calling  pnpbios_thread_init+0x0/0x5e @ 1
[    3.500234] initcall pnpbios_thread_init+0x0/0x5e returned 0 after 3906 usecs
[    3.504222] calling  isapnp_init+0x0/0x607 @ 1
[    3.508231] isapnp: Scanning for PnP cards...
[    3.868634] isapnp: No Plug & Play device found
[    3.872244] initcall isapnp_init+0x0/0x607 returned 0 after 355490 usecs
[    3.876244] calling  pty_init+0x0/0x3a0 @ 1
[    3.903314] initcall pty_init+0x0/0x3a0 returned 0 after 19532 usecs
[    3.904247] calling  sysrq_init+0x0/0x7a @ 1
[    3.908257] initcall sysrq_init+0x0/0x7a returned 0 after 0 usecs
[    3.912246] calling  serial8250_init+0x0/0x151 @ 1
[    3.916246] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.924246] async_waiting @ 1
[    3.928246] async_continuing @ 1 after 0 usec
[    4.060370] async_waiting @ 1
[    4.063332] async_continuing @ 1 after 0 usec
�[    4.192417] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.292285] initcall serial8250_init+0x0/0x151 returned 0 after 367210 usecs
[    4.296270] calling  serial8250_pnp_init+0x0/0xf @ 1
[    4.304271] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.332314] initcall serial8250_pnp_init+0x0/0xf returned 0 after 31251 usecs
[    4.336273] calling  serial8250_pci_init+0x0/0x16 @ 1
[    4.340316] initcall serial8250_pci_init+0x0/0x16 returned 0 after 0 usecs
[    4.344274] calling  rand_initialize+0x0/0x30 @ 1
[    4.348303] initcall rand_initialize+0x0/0x30 returned 0 after 0 usecs
[    4.352274] calling  init_tis+0x0/0xa5 @ 1
[    4.356288] initcall init_tis+0x0/0xa5 returned 0 after 0 usecs
[    4.360274] calling  isa_bus_init+0x0/0x33 @ 1
[    4.364295] initcall isa_bus_init+0x0/0x33 returned 0 after 0 usecs
[    4.368276] calling  topology_sysfs_init+0x0/0x5a @ 1
[    4.372284] initcall topology_sysfs_init+0x0/0x5a returned 0 after 0 usecs
[    4.376275] calling  cpqarray_init+0x0/0x259 @ 1
[    4.380274] Compaq SMART2 Driver (v 2.6.0)
[    4.384299] initcall cpqarray_init+0x0/0x259 returned -19 after 3906 usecs
[    4.388276] calling  spi_transport_init+0x0/0x7c @ 1
[    4.392291] initcall spi_transport_init+0x0/0x7c returned 0 after 0 usecs
[    4.396277] calling  ahc_linux_init+0x0/0x5a @ 1
[    4.400301] initcall ahc_linux_init+0x0/0x5a returned 0 after 0 usecs
[    4.404277] calling  init_sd+0x0/0x113 @ 1
[    4.408320] initcall init_sd+0x0/0x113 returned 0 after 0 usecs
[    4.412277] calling  ahci_init+0x0/0x16 @ 1
[    4.416306] initcall ahci_init+0x0/0x16 returned 0 after 0 usecs
[    4.420278] calling  piix_init+0x0/0x24 @ 1
[    4.424295] initcall piix_init+0x0/0x24 returned 0 after 0 usecs
[    4.428278] calling  nv_init+0x0/0x16 @ 1
[    4.432292] initcall nv_init+0x0/0x16 returned 0 after 0 usecs
[    4.436279] calling  amd_init+0x0/0x16 @ 1
[    4.440290] pata_amd 0000:00:06.0: version 0.4.1
[    4.444324] pata_amd 0000:00:06.0: setting latency timer to 64
[    4.448567] scsi0 : pata_amd
[    4.451516] scsi1 : pata_amd
[    4.452316] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    4.456280] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    4.460299] initcall amd_init+0x0/0x16 returned 0 after 19532 usecs
[    4.460301] calling  1_async_port_probe+0x0/0x60 @ 5
[    4.460320] calling  2_async_port_probe+0x0/0x60 @ 31
[    4.460322] async_waiting @ 31
[    4.464281] calling  oldpiix_init+0x0/0x16 @ 1
[    4.468294] initcall oldpiix_init+0x0/0x16 returned 0 after 0 usecs
[    4.472281] calling  via_init+0x0/0x16 @ 1
[    4.476294] initcall via_init+0x0/0x16 returned 0 after 0 usecs
[    4.480282] calling  e1000_init_module+0x0/0x39 @ 1
[    4.484281] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    4.488280] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    4.492298] initcall e1000_init_module+0x0/0x39 returned 0 after 7812 usecs
[    4.496283] calling  vortex_init+0x0/0x9e @ 1
[    4.500296] initcall vortex_init+0x0/0x9e returned 0 after 0 usecs
[    4.504283] calling  e100_init_module+0x0/0x5a @ 1
[    4.508282] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.512282] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.516299] initcall e100_init_module+0x0/0x5a returned 0 after 7812 usecs
[    4.520284] calling  tg3_init+0x0/0x16 @ 1
[    4.524302] initcall tg3_init+0x0/0x16 returned 0 after 0 usecs
[    4.528285] calling  skge_init_module+0x0/0x63 @ 1
[    4.532312] initcall skge_init_module+0x0/0x63 returned 0 after 0 usecs
[    4.536285] calling  net_olddevs_init+0x0/0x84 @ 1
[    4.540290] initcall net_olddevs_init+0x0/0x84 returned 0 after 0 usecs
[    4.544285] calling  init_nic+0x0/0x16 @ 1
[    4.548296] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    4.552309] IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:1)
[    4.556289] forcedeth 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 35
[    4.560287] forcedeth 0000:00:0a.0: setting latency timer to 64
[    4.632775] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[    4.636291] ata1.00: 488397168 sectors, multi 1: LBA48 
[    4.644295] ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[    4.676707] ata1.00: configured for UDMA/100
[    4.680300] async_waiting @ 5
[    4.683263] async_continuing @ 5 after 0 usec
[    4.688427] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[    4.696510] initcall 1_async_port_probe+0x0/0x60 returned 0 after 230483 usecs
[    4.700297] calling  3_sd_probe_async+0x0/0x1c0 @ 5
[    4.704301] async_continuing @ 31 after 238296 usec
[    4.712319] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    4.720337] sd 0:0:0:0: [sda] Write Protect is off
[    4.724297] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.728313] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.816822]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    4.820717] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.824305] initcall 3_sd_probe_async+0x0/0x1c0 returned 0 after 109381 usecs
[    4.872535] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[    4.876310] ata2: nv_mode_filter: 0x1f39f&0x73ff->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[    4.896467] ata2.01: configured for UDMA/33
[    4.900962] async_waiting @ 31
[    4.904308] async_continuing @ 31 after 0 usec
[    4.905096] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[    4.916425] initcall 2_async_port_probe+0x0/0x60 returned 0 after 445340 usecs
[    5.088701] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[    5.092320] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    5.096335] initcall init_nic+0x0/0x16 returned 0 after 535189 usecs
[    5.100321] calling  rtl8139_init_module+0x0/0x16 @ 1
[    5.104329] 8139too: 8139too Fast Ethernet driver 0.9.28
[    5.108339] 8139too 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 35
[    5.112789] 8139too 0000:05:07.0: eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 35
[    5.116336] initcall rtl8139_init_module+0x0/0x16 returned 0 after 11719 usecs
[    5.120322] calling  init_netconsole+0x0/0x1cf @ 1
[    5.124370] console [netcon0] enabled
[    5.128321] netconsole: network logging started
[    5.132323] initcall init_netconsole+0x0/0x1cf returned 0 after 7812 usecs
[    5.136323] calling  ehci_hcd_init+0x0/0xe2 @ 1
[    5.140322] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.144323] ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
[    5.148335] ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
[    5.152324] ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
[    5.156325] ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
[    5.160341] initcall ehci_hcd_init+0x0/0xe2 returned 0 after 19532 usecs
[    5.164325] calling  ohci_hcd_mod_init+0x0/0xb4 @ 1
[    5.168324] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.172324] ohci_hcd: block sizes: ed 64 td 64
[    5.176334] ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
[    5.180325] ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
[    5.184326] ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
[    5.188337] initcall ohci_hcd_mod_init+0x0/0xb4 returned 0 after 19532 usecs
[    5.192326] calling  uhci_hcd_init+0x0/0x100 @ 1
[    5.196325] uhci_hcd: USB Universal Host Controller Interface driver
[    5.200362] initcall uhci_hcd_init+0x0/0x100 returned 0 after 3906 usecs
[    5.204327] calling  i8042_init+0x0/0x3b9 @ 1
[    5.208374] i8042: PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
[    5.212326] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    5.217227] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.220335] initcall i8042_init+0x0/0x3b9 returned 0 after 11719 usecs
[    5.224328] calling  mousedev_init+0x0/0x7f @ 1
[    5.228453] mousedev: PS/2 mouse device common for all mice
[    5.232329] initcall mousedev_init+0x0/0x7f returned 0 after 3906 usecs
[    5.236329] calling  atkbd_init+0x0/0x20 @ 1
[    5.240345] initcall atkbd_init+0x0/0x20 returned 0 after 0 usecs
[    5.244329] calling  flow_cache_init_global+0x0/0x112 @ 1
[    5.248353] initcall flow_cache_init_global+0x0/0x112 returned 0 after 0 usecs
[    5.252330] calling  blackhole_module_init+0x0/0xf @ 1
[    5.256331] initcall blackhole_module_init+0x0/0xf returned 0 after 0 usecs
[    5.260330] calling  sysctl_ipv4_init+0x0/0x71 @ 1
[    5.264528] initcall sysctl_ipv4_init+0x0/0x71 returned 0 after 0 usecs
[    5.268332] calling  ipv4_netfilter_init+0x0/0x20 @ 1
[    5.272332] initcall ipv4_netfilter_init+0x0/0x20 returned 0 after 0 usecs
[    5.276331] calling  packet_init+0x0/0x39 @ 1
[    5.280331] NET: Registered protocol family 17
[    5.284337] initcall packet_init+0x0/0x39 returned 0 after 3906 usecs
[    5.288332] calling  update_mp_table+0x0/0x3f8 @ 1
[    5.292333] initcall update_mp_table+0x0/0x3f8 returned 0 after 0 usecs
[    5.296332] calling  lapic_insert_resource+0x0/0x35 @ 1
[    5.300334] initcall lapic_insert_resource+0x0/0x35 returned 0 after 0 usecs
[    5.304333] calling  print_ipi_mode+0x0/0x2d @ 1
[    5.308332] Using IPI No-Shortcut mode
[    5.312334] initcall print_ipi_mode+0x0/0x2d returned 0 after 3906 usecs
[    5.316334] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[    5.320334] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 0 usecs
[    5.324334] calling  check_early_ioremap_leak+0x0/0x54 @ 1
[    5.328335] initcall check_early_ioremap_leak+0x0/0x54 returned 0 after 0 usecs
[    5.332335] calling  pat_memtype_list_init+0x0/0x37 @ 1
[    5.336338] initcall pat_memtype_list_init+0x0/0x37 returned 0 after 0 usecs
[    5.340335] calling  init_oops_id+0x0/0x50 @ 1
[    5.344340] initcall init_oops_id+0x0/0x50 returned 0 after 0 usecs
[    5.348336] calling  printk_late_init+0x0/0x4d @ 1
[    5.352337] initcall printk_late_init+0x0/0x4d returned 0 after 0 usecs
[    5.356337] calling  pm_qos_power_init+0x0/0xbd @ 1
[    5.360425] initcall pm_qos_power_init+0x0/0xbd returned 0 after 0 usecs
[    5.364337] calling  software_resume+0x0/0x1f0 @ 1
[    5.368336] PM: Hibernation image not present or could not be loaded.
[    5.372339] initcall software_resume+0x0/0x1f0 returned -2 after 3906 usecs
[    5.376337] initcall software_resume+0x0/0x1f0 returned with error code -2 
[    5.380338] calling  taskstats_init+0x0/0x85 @ 1
[    5.384342] registered taskstats version 1
[    5.388338] initcall taskstats_init+0x0/0x85 returned 0 after 3906 usecs
[    5.392338] calling  clear_boot_tracer+0x0/0x2d @ 1
[    5.396339] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    5.400340] calling  max_swapfiles_check+0x0/0x7 @ 1
[    5.404340] initcall max_swapfiles_check+0x0/0x7 returned 0 after 0 usecs
[    5.408339] calling  init_ima+0x0/0x14 @ 1
[    5.412339] IMA: No TPM chip found, activating TPM-bypass!
[    5.416351] initcall init_ima+0x0/0x14 returned 0 after 3906 usecs
[    5.420340] calling  random32_reseed+0x0/0x7d @ 1
[    5.424351] initcall random32_reseed+0x0/0x7d returned 0 after 0 usecs
[    5.428341] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[    5.432343] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 0 usecs
[    5.436341] calling  pci_sysfs_init+0x0/0x44 @ 1
[    5.440476] initcall pci_sysfs_init+0x0/0x44 returned 0 after 0 usecs
[    5.444342] calling  seqgen_init+0x0/0xe @ 1
[    5.448355] initcall seqgen_init+0x0/0xe returned 0 after 0 usecs
[    5.452342] calling  late_resume_init+0x0/0x1f0 @ 1
[    5.456342]   Magic number: 3:284:857
[    5.460346] bdi 8:0: hash matches
[    5.463734] tty ptyv9: hash matches
[    5.464350] tty ptysc: hash matches
[    5.468377] initcall late_resume_init+0x0/0x1f0 returned 0 after 11719 usecs
[    5.472344] calling  hd_init+0x0/0x2d1 @ 1
[    5.476387] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[    5.480361] initcall hd_init+0x0/0x2d1 returned -1 after 3906 usecs
[    5.484344] initcall hd_init+0x0/0x2d1 returned with error code -1 
[    5.488345] calling  scsi_complete_async_scans+0x0/0x110 @ 1
[    5.492345] initcall scsi_complete_async_scans+0x0/0x110 returned 0 after 0 usecs
[    5.496345] calling  memmap_init+0x0/0x30 @ 1
[    5.500363] initcall memmap_init+0x0/0x30 returned 0 after 0 usecs
[    5.504345] calling  tcp_congestion_default+0x0/0xf @ 1
[    5.508347] initcall tcp_congestion_default+0x0/0xf returned 0 after 0 usecs
[    5.512346] calling  ip_auto_config+0x0/0xe20 @ 1
[    5.516350] initcall ip_auto_config+0x0/0xe20 returned 0 after 0 usecs
[    5.520346] calling  initialize_hashrnd+0x0/0x16 @ 1
[    5.524351] initcall initialize_hashrnd+0x0/0x16 returned 0 after 0 usecs
[    5.528497] async_waiting @ 1
[    5.532347] async_continuing @ 1 after 0 usec
[    5.555805] EXT3-fs (sda1): recovery required on readonly filesystem
[    5.556348] EXT3-fs (sda1): write access will be enabled during recovery
[    5.560472] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    5.564377] EXT3-fs: barriers not enabled
[    5.595933] kjournald starting.  Commit interval 5 seconds
[    5.596422] EXT3-fs (sda1): recovery complete
[    5.600731] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    5.604368] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    5.608363] async_waiting @ 1
[    5.612352] async_continuing @ 1 after 0 usec
[    5.616379] Freeing unused kernel memory: 408k freed
[    5.658723] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

INIT: version 2.86 booting
		Welcome to Fedora Core
		Press 'I' to enter interactive startup.
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

Setting clock  (utc): Wed Mar 30 00:50:21 CEST 2011 [  OK  ]
Loading default keymap (us): [  OK  ]
Setting hostname mercury:  [  OK  ]
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

raidautorun: failed to open /dev/md0: No such device or address
/proc/misc: No entry for device-mapper found
Is device-mapper driver missing from kernel?
device-mapper: version ioctl failed: Inappropriate ioctl for device
/proc/misc: No entry for device-mapper found
Is device-mapper driver missing from kernel?
device-mapper: version ioctl failed: Inappropriate ioctl for device
Command failed
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

Setting up Logical Volume Management: modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ramdisk: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/hda: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/md0: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/hda1: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/md1: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram2: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/hda2: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram3: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram4: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram5: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram6: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram7: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram8: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram9: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram10: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram11: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram12: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram13: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram14: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/ram15: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/hdb: open failed: No such device or address
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

  /dev/hdb2: open failed: No such device or address
  No volume groups found
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda1 
/: clean, 514801/7685440 files, 5452963/7679062 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/sda5 
/home: recovering journal
/home: clean, 143806/6111232 files, 1767771/12209392 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  [    9.755209] EXT3-fs (sda1): using internal journal
[  OK  ]
Mounting local filesystems:  mount: wrong fs [    9.813640] EXT3-fs: barriers not enabled
type, bad option[    9.816757] kjournald starting.  Commit interval 5 seconds
, bad superblock[    9.820895] EXT3-fs (sda5): using internal journal
 on /dev/shm,
 [    9.824617] EXT3-fs (sda5): mounted filesystem with ordered data mode
      missing codepage or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

[FAILED]
Enabling local filesystem quotas:  quotaon: Warning: No quota format detected in the kernel.
[  OK  ]
Enabling /etc/fstab swaps:  modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

swapon: /dev/hda2: No such device or address
[FAILED]
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

INIT: Entering runlevel: 3
Entering non-interactive startup
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [  OK  ]
Starting sshd: modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  OK  ]modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory


/etc/rc3.d/S99local: line 9: /proc/sys/kernel/exec-shield: No such file or directory
FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory
[   13.542925] Adding 3911820k swap on /dev/sda2.  Priority:-1 extents:1 across:3911820k 
Starting Distributed Compiler daemon (distccd): modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

distccd[738] (dcc_setup_real_log) ERROR: failed to open /var/log/distccd.log: Permission denied
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  OK  ]
/etc/rc3.d/S99local: line 32: /sys/kernel/uids/0/cpu_share: No such file or directory
/etc/rc3.d/S99local: line 34: /sys/kernel/uids//cpu_share: No such file or directory
NOT testing CPU hotplug
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory


 Performance counter stats for 'true':

     <not counted> cache-misses            
           232,739 cache-references         #    416.734 M/sec
             8,042 branch-misses            #      9.103 %    
            88,348 branches                 #    158.193 M/sec
           514,894 instructions             #      0.000 IPC  
     <not counted> cycles                  
               121 page-faults              #      0.217 M/sec
                 0 CPU-migrations           #      0.000 M/sec
                 0 context-switches         #      0.000 M/sec
          0.558483 task-clock-msecs         #      0.017 CPUs 

        0.032002000  seconds time elapsed

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory


Fedora Core release 6 (Zod)
Kernel 2.6.38-tip-11308-g785c78f-dirty on an i686

mercury login: modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[   84.067756] EXT3-fs: barriers not enabled
[   84.090333] kjournald starting.  Commit interval 5 seconds
[   84.090574] EXT3-fs (sda6): using internal journal
[   84.090578] EXT3-fs (sda6): recovery complete
[   84.090849] EXT3-fs (sda6): mounted filesystem with ordered data mode
[   84.434778] blk: request botched
[   84.437546] blk: request botched
[   84.441532] blk: request botched
[   84.445016] blk: request botched
[   84.445538] blk: request botched
[   84.449542] blk: request botched
[   84.453566] blk: request botched
[   84.457930] blk: request botched
[   84.461503] blk: request botched
[   84.465511] blk: request botched
[   84.469628] blk: request botched
[   84.473508] blk: request botched
[   84.477061] blk: request botched
[   84.477502] blk: request botched
[   84.481511] blk: request botched
[   84.485627] blk: request botched
[   84.489486] blk: request botched
[   84.493610] blk: request botched
[   84.497506] blk: request botched
[   84.501533] blk: request botched
[   84.504958] blk: request botched
[   84.505509] blk: request botched
[   84.509626] blk: request botched
[   84.513486] blk: request botched
[   84.517607] blk: request botched
[   84.521506] blk: request botched
[   84.525510] blk: request botched
[   84.529517] blk: request botched
[   84.532943] blk: request botched
[   84.533611] blk: request botched
[   84.537507] blk: request botched
[   84.541487] blk: request botched
[   84.545601] blk: request botched
[   84.549485] blk: request botched
[   84.553604] blk: request botched
[   84.557328] blk: request botched
[   84.560864] blk: request botched
[   84.561484] blk: request botched
[   84.565484] blk: request botched
[   84.569606] blk: request botched
[   84.573491] blk: request botched
[   84.577599] blk: request botched
[   84.581489] blk: request botched
[   84.584912] blk: request botched
[   84.585602] blk: request botched
[   84.589489] blk: request botched
[   84.593601] blk: request botched
[   84.597486] blk: request botched
[   84.601486] blk: request botched
[   84.605608] blk: request botched
[   84.609437] blk: request botched
[   84.612974] blk: request botched
[   84.613498] blk: request botched
[   84.617643] blk: request botched
[   84.621483] blk: request botched
[   84.625486] blk: request botched
[   84.629605] blk: request botched
[   84.633491] blk: request botched
[   84.637355] blk: request botched
[   84.640786] blk: request botched
[   84.641491] blk: request botched
[   84.645602] blk: request botched
[   84.649487] blk: request botched
[   84.653589] blk: request botched
[   84.657481] blk: request botched
[   84.661490] blk: request botched
[   84.665031] blk: request botched
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  114.811190] ata1: lost interrupt (Status 0x58)
[  114.815187] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  114.819179] ata1.00: failed command: WRITE DMA EXT
[  114.827182] ata1.00: cmd 35/00:00:56:b4:10/00:04:0c:00:00/e0 tag 0 dma 524288 out
[  114.827184]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  114.839178] ata1.00: status: { DRDY }
[  114.843195] ata1: soft resetting link
[  115.019694] ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[  115.051600] ata1.00: configured for UDMA/100
[  115.055196] ata1.00: device reported invalid CHS sector 0
[  115.059196] ata1: EH complete
ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  145.897133] ata1: lost interrupt (Status 0x58)
[  145.901130] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  145.905121] ata1.00: failed command: WRITE DMA EXT
[  145.913125] ata1.00: cmd 35/00:00:56:b4:10/00:04:0c:00:00/e0 tag 0 dma 524288 out
[  145.913126]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  145.925121] ata1.00: status: { DRDY }
[  145.929138] ata1: soft resetting link
[  146.105626] ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[  146.137554] ata1.00: configured for UDMA/100
[  146.141139] ata1.00: device reported invalid CHS sector 0
[  146.145141] ata1: EH complete
ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  176.875067] ata1: lost interrupt (Status 0x58)
[  176.879065] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  176.883057] ata1.00: failed command: WRITE DMA EXT
[  176.891061] ata1.00: cmd 35/00:00:56:b4:10/00:04:0c:00:00/e0 tag 0 dma 524288 out
[  176.891062]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  176.903057] ata1.00: status: { DRDY }
[  176.907074] ata1: soft resetting link
[  177.083561] ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[  177.115489] ata1.00: configured for UDMA/100
[  177.119075] ata1.00: device reported invalid CHS sector 0
[  177.123077] ata1: EH complete
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  207.853003] ata1: lost interrupt (Status 0x58)
[  207.857000] ata1.00: limiting speed to UDMA/66:PIO4
[  207.860994] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  207.868994] ata1.00: failed command: WRITE DMA EXT
[  207.872997] ata1.00: cmd 35/00:00:56:b4:10/00:04:0c:00:00/e0 tag 0 dma 524288 out
[  207.872998]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  207.888993] ata1.00: status: { DRDY }
[  207.892662] ata1: soft resetting link
[  208.065497] ata1: nv_mode_filter: 0x1f39f&0x3f3ff->0x1f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[  208.097424] ata1.00: configured for UDMA/66
[  208.101011] ata1.00: device reported invalid CHS sector 0
[  208.105013] ata1: EH complete
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  238.830939] ata1: lost interrupt (Status 0x58)
[  238.834937] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  238.838929] ata1.00: failed command: WRITE DMA EXT
[  238.846933] ata1.00: cmd 35/00:00:56:b4:10/00:04:0c:00:00/e0 tag 0 dma 524288 out
[  238.846934]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  238.858929] ata1.00: status: { DRDY }
[  238.862946] ata1: soft resetting link
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  239.039443] ata1: nv_mode_filter: 0x1f39f&0x3f3ff->0x1f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[  239.071367] ata1.00: configured for UDMA/66
[  239.074947] ata1.00: device reported invalid CHS sector 0
[  239.078951] ata1: EH complete
ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  269.936882] ata1: lost interrupt (Status 0x58)
[  269.940880] ata1.00: limiting speed to UDMA/33:PIO4
[  269.944873] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  269.952874] ata1.00: failed command: WRITE DMA EXT
[  269.956877] ata1.00: cmd 35/00:00:56:b4:10/00:04:0c:00:00/e0 tag 0 dma 524288 out
[  269.956878]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  269.972873] ata1.00: status: { DRDY }
[  269.976543] ata1: soft resetting link
modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.38-tip-11308-g785c78f-dirty/modules.dep: No such file or directory

[  270.149384] ata1: nv_mode_filter: 0x739f&0x3f3ff->0x739f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
	[  270.181309] ata1.00: configured for UDMA/33
[  270.184893] ata1.00: device reported invalid CHS sector 0
[  270.188902] BUG: unable to handle kernel NULL pointer dereference at 0000022c
[  270.192885] IP: [<c119d413>] __blk_recalc_rq_segments+0x53/0x210
[  270.192885] *pde = 00000000 
[  270.192885] Oops: 0000 [#1] SMP 
[  270.192885] last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/net/eth0/address
[  270.192885] Modules linked in:
[  270.192885] 
[  270.192885] Pid: 29, comm: scsi_eh_0 Not tainted 2.6.38-tip-11308-g785c78f-dirty #111495 System manufacturer System Product Name/A8N-E
[  270.192885] EIP: 0060:[<c119d413>] EFLAGS: 00010202 CPU: 1
[  270.192885] EIP is at __blk_recalc_rq_segments+0x53/0x210
[  270.192885] EAX: 000001f4 EBX: f51e6680 ECX: 000001f4 EDX: ffffffff
[  270.192885] ESI: 00000000 EDI: 3d80d000 EBP: f5b47de4 ESP: f5b47da0
[  270.192885]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  270.192885] Process scsi_eh_0 (pid: 29, ti=f5b46000 task=f59cdf00 task.ti=f5b46000)
[  270.192885] Stack:
[  270.192885]  00000001 3d80ffff 0000ffff f702c180 0000e000 01b47db4 00001000 f51d3400
[  270.192885]  000001f4 f5b5c000 f5417b48 00000000 0000e000 00000004 f515d820 0222ec01
[  270.192885]  f515d820 f5b47df0 c119d8e6 f51d3400 f5b47e30 c11969b8 f5b46000 00000000
[  270.192885] Call Trace:
[  270.192885]  [<c119d8e6>] blk_recalc_rq_segments+0x16/0x20
[  270.192885]  [<c11969b8>] blk_update_request+0x358/0x4a0
[  270.192885]  [<c103ea55>] ? irq_exit+0x55/0x60
[  270.192885]  [<c1198ba3>] blk_update_bidi_request+0x13/0x70
[  270.192885]  [<c1199712>] blk_end_bidi_request+0x22/0x60
[  270.192885]  [<c1199767>] blk_end_request+0x17/0x20
[  270.192885]  [<c121c848>] scsi_io_completion+0x98/0x6a0
[  270.192885]  [<c124c184>] ? __ata_eh_qc_complete+0x54/0x70
[  270.192885]  [<c1213d46>] scsi_finish_command+0x96/0x110
[  270.192885]  [<c12194a7>] scsi_eh_flush_done_q+0xd7/0x130
[  270.192885]  [<c1251b1e>] ata_scsi_port_error_handler+0x60e/0x760
[  270.192885]  [<c13a8bbe>] ? _raw_spin_unlock_irqrestore+0xe/0x20
[  270.192885]  [<c1251cdf>] ata_scsi_error+0x6f/0xa0
[  270.192885]  [<c12198c0>] ? scsi_eh_get_sense+0x1f0/0x1f0
[  270.192885]  [<c12199b5>] scsi_error_handler+0xf5/0x5f0
[  270.192885]  [<c1030f50>] ? default_wake_function+0x10/0x20
[  270.192885]  [<c1026e77>] ? __wake_up_common+0x47/0x70
[  270.192885]  [<c102a727>] ? complete+0x47/0x50
[  270.192885]  [<c12198c0>] ? scsi_eh_get_sense+0x1f0/0x1f0
[  270.192885]  [<c105570d>] kthread+0x6d/0x70
[  270.192885]  [<c10556a0>] ? kthread_worker_fn+0x160/0x160
[  270.192885]  [<c13aa246>] kernel_thread_helper+0x6/0x10
[  270.192885] Code: c7 45 f0 00 00 00 00 c7 45 ec 00 00 00 00 c7 45 e8 01 00 00 00 c7 45 e4 00 00 00 00 8d b6 00 00 00 00 8d bf 00 00 00 00 8b 4d dc <8b> 51 38 66 8b 41 1a 8b 71 18 89 c1 81 e1 ff ff 00 00 66 39 c6 
[  270.192885] EIP: [<c119d413>] __blk_recalc_rq_segments+0x53/0x210 SS:ESP 0068:f5b47da0
[  270.192885] CR2: 000000000000022c
[  270.444906] ---[ end trace 01447d57669c61d1 ]---
[  270.448903] Kernel panic - not syncing: Fatal exception
[  270.452904] Pid: 29, comm: scsi_eh_0 Tainted: G      D     2.6.38-tip-11308-g785c78f-dirty #111495
[  270.460903] Call Trace:
[  270.464905]  [<c13a3a20>] ? printk+0x1d/0x1f
[  270.468905]  [<c13a390e>] panic+0x5c/0x151
[  270.472905]  [<c1005bd3>] oops_end+0xb3/0xc0
[  270.476905]  [<c13a33fa>] no_context+0x135/0x13d
[  270.480906]  [<c13a3543>] __bad_area_nosemaphore+0x141/0x149
[  270.488908]  [<c11ae04e>] ? __delay+0xe/0x10
[  270.492907]  [<c11ae074>] ? __const_udelay+0x24/0x30
[  270.496907]  [<c1021d50>] ? vmalloc_sync_all+0x150/0x150
[  270.500907]  [<c13a3562>] bad_area_nosemaphore+0x17/0x19
[  270.508907]  [<c10220b3>] do_page_fault+0x363/0x400
[  270.512908]  [<c11ae074>] ? __const_udelay+0x24/0x30
[  270.516909]  [<c11f6367>] ? wait_for_xmitr+0x37/0x90
[  270.520909]  [<c105ba17>] ? sched_clock_local+0xe7/0x190
[  270.528909]  [<c105bbf7>] ? sched_clock_cpu+0xc7/0x150
[  270.532909]  [<c1021d50>] ? vmalloc_sync_all+0x150/0x150
[  270.536909]  [<c13a9a57>] error_code+0x67/0x70
[  270.540910]  [<c119d413>] ? __blk_recalc_rq_segments+0x53/0x210
[  270.548910]  [<c119d8e6>] blk_recalc_rq_segments+0x16/0x20
[  270.552911]  [<c11969b8>] blk_update_request+0x358/0x4a0
[  270.560911]  [<c103ea55>] ? irq_exit+0x55/0x60
[  270.564911]  [<c1198ba3>] blk_update_bidi_request+0x13/0x70
[  270.568912]  [<c1199712>] blk_end_bidi_request+0x22/0x60
[  270.572912]  [<c1199767>] blk_end_request+0x17/0x20
[  270.580912]  [<c121c848>] scsi_io_completion+0x98/0x6a0
[  270.584913]  [<c124c184>] ? __ata_eh_qc_complete+0x54/0x70
[  270.588913]  [<c1213d46>] scsi_finish_command+0x96/0x110
[  270.596913]  [<c12194a7>] scsi_eh_flush_done_q+0xd7/0x130
[  270.600913]  [<c1251b1e>] ata_scsi_port_error_handler+0x60e/0x760
[  270.604914]  [<c13a8bbe>] ? _raw_spin_unlock_irqrestore+0xe/0x20
[  270.612914]  [<c1251cdf>] ata_scsi_error+0x6f/0xa0
[  270.616914]  [<c12198c0>] ? scsi_eh_get_sense+0x1f0/0x1f0
[  270.620914]  [<c12199b5>] scsi_error_handler+0xf5/0x5f0
[  270.628915]  [<c1030f50>] ? default_wake_function+0x10/0x20
[  270.632915]  [<c1026e77>] ? __wake_up_common+0x47/0x70
[  270.636915]  [<c102a727>] ? complete+0x47/0x50
[  270.644916]  [<c12198c0>] ? scsi_eh_get_sense+0x1f0/0x1f0
[  270.648916]  [<c105570d>] kthread+0x6d/0x70
[  270.652917]  [<c10556a0>] ? kthread_worker_fn+0x160/0x160
[  270.656917]  [<c13aa246>] kernel_thread_helper+0x6/0x10

Linux version 2.6.38-tip-11308-g785c78f-dirty (mingo@sirius) (gcc version 4.6.0 20110304 (Red Hat 4.6.0-0.12) (GCC) ) #111496 SMP PREEMPT Tue Mar 29 13:23:53 CEST 2011
Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=1 panic=1 3 no_hz=off hpet=disable idle=poll highmem=512m nopat pci=nomsi
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
bootconsole [earlyser0] enabled
debug: ignoring loglevel setting.
using polling idle threads.
PAT support disabled.
NX (Execute Disable) protection: active
DMI 2.3 present.
DMI: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FFC0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
found SMP MP-table at [ffff8800000f5680] f5680
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-000000003fff0000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003fff0000 page 4k
kernel direct mapping tables up to 3fff0000 @ 3ffed000-3fff0000
ACPI: RSDP 00000000000f76f0 00014 (v00 Nvidia)
ACPI: RSDT 000000003fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: FACP 000000003fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: DSDT 000000003fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
ACPI: FACS 000000003fff0000 00040
ACPI: SRAT 000000003fff9500 000A0 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: MCFG 000000003fff9600 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: APIC 000000003fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000003fff0000
NUMA: Using 63 for the hash shift.
Initmem setup node 0 0000000000000000-000000003fff0000
  NODE_DATA [000000003ffde000 - 000000003ffecfff]
 [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff88003e600000-ffff88003f3fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
On node 0 totalpages: 262015
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3922 pages, LIFO batch:0
  DMA32 zone: 3528 pages used for memmap
  DMA32 zone: 254504 pages, LIFO batch:31
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88003fc00000 s79504 r0 d22896 u1048576
pcpu-alloc: s79504 r0 d22896 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 258426
Policy zone: DMA32
Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=1 panic=1 3 no_hz=off hpet=disable idle=poll highmem=512m nopat pci=nomsi
sysrq: sysrq always enabled.
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Memory: 1017344k/1048512k available (8430k kernel code, 452k absent, 30716k reserved, 5133k data, 548k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptable hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:4352 nr_irqs:56 16
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [ttyS0] enabled, bootconsole disabled
Fast TSC calibration using PIT
Detected 2010.420 MHz processor.
Marking TSC unstable due to TSCs unsynchronized
Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.84 BogoMIPS (lpj=20104200)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20110316
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
calling  init_hw_perf_events+0x0/0xd86 @ 1
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
initcall init_hw_perf_events+0x0/0xd86 returned 0 after 29296 usecs
calling  migration_init+0x0/0x6c @ 1
initcall migration_init+0x0/0x6c returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x4a @ 1
initcall spawn_ksoftirqd+0x0/0x4a returned 0 after 19531 usecs
calling  init_workqueues+0x0/0x260 @ 1
initcall init_workqueues+0x0/0x260 returned 0 after 0 usecs
calling  init_call_single_data+0x0/0x7f @ 1
initcall init_call_single_data+0x0/0x7f returned 0 after 0 usecs
calling  cpu_stop_init+0x0/0x9c @ 1
initcall cpu_stop_init+0x0/0x9c returned 0 after 19531 usecs
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 9a000
Brought up 2 CPUs
Total of 2 processors activated (8041.52 BogoMIPS).
devtmpfs: initialized
calling  init_mmap_min_addr+0x0/0x11 @ 1
initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
calling  net_ns_init+0x0/0xeb @ 1
initcall net_ns_init+0x0/0xeb returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x2e @ 1
initcall cpufreq_tsc+0x0/0x2e returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x11 @ 1
initcall pci_reboot_init+0x0/0x11 returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x1d @ 1
initcall init_lapic_sysfs+0x0/0x1d returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x66 @ 1
initcall init_smp_flush+0x0/0x66 returned 0 after 0 usecs
calling  alloc_frozen_cpus+0x0/0x3 @ 1
initcall alloc_frozen_cpus+0x0/0x3 returned 0 after 0 usecs
calling  sysctl_init+0x0/0x2f @ 1
initcall sysctl_init+0x0/0x2f returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x8a @ 1
initcall ksysfs_init+0x0/0x8a returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0xc @ 1
initcall init_jiffies_clocksource+0x0/0xc returned 0 after 0 usecs
calling  pm_init+0x0/0x32 @ 1
initcall pm_init+0x0/0x32 returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x32 @ 1
initcall init_zero_pfn+0x0/0x32 returned 0 after 0 usecs
calling  fsnotify_init+0x0/0x23 @ 1
initcall fsnotify_init+0x0/0x23 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2c @ 1
initcall filelock_init+0x0/0x2c returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0xe @ 1
initcall init_script_binfmt+0x0/0xe returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0xe @ 1
initcall init_elf_binfmt+0x0/0xe returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0xe @ 1
initcall init_compat_elf_binfmt+0x0/0xe returned 0 after 0 usecs
calling  debugfs_init+0x0/0x50 @ 1
initcall debugfs_init+0x0/0x50 returned 0 after 0 usecs
calling  securityfs_init+0x0/0x47 @ 1
initcall securityfs_init+0x0/0x47 returned 0 after 0 usecs
calling  random32_init+0x0/0xcb @ 1
initcall random32_init+0x0/0xcb returned 0 after 0 usecs
calling  test_atomic64+0x0/0x404 @ 1
atomic64 test passed for x86-64 platform with CX8 and with SSE
initcall test_atomic64+0x0/0x404 returned 0 after 9765 usecs
calling  regulator_init+0x0/0x61 @ 1
print_constraints: dummy: 
initcall regulator_init+0x0/0x61 returned 0 after 0 usecs
calling  cpufreq_core_init+0x0/0x97 @ 1
initcall cpufreq_core_init+0x0/0x97 returned 0 after 0 usecs
calling  sock_init+0x0/0x7e @ 1
initcall sock_init+0x0/0x7e returned 0 after 0 usecs
calling  net_inuse_init+0x0/0x24 @ 1
initcall net_inuse_init+0x0/0x24 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x2c @ 1
initcall netpoll_init+0x0/0x2c returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x19d @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x19d returned 0 after 0 usecs
calling  bdi_class_init+0x0/0x47 @ 1
initcall bdi_class_init+0x0/0x47 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x1d @ 1
initcall kobject_uevent_init+0x0/0x1d returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x13 @ 1
initcall pcibus_class_init+0x0/0x13 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0xc @ 1
initcall pci_driver_init+0x0/0xc returned 0 after 0 usecs
calling  rio_bus_init+0x0/0x2c @ 1
initcall rio_bus_init+0x0/0x2c returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x5c @ 1
initcall backlight_class_init+0x0/0x5c returned 0 after 0 usecs
calling  tty_class_init+0x0/0x31 @ 1
initcall tty_class_init+0x0/0x31 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xd7 @ 1
initcall vtconsole_class_init+0x0/0xd7 returned 0 after 0 usecs
calling  wakeup_sources_debugfs_init+0x0/0x28 @ 1
initcall wakeup_sources_debugfs_init+0x0/0x28 returned 0 after 0 usecs
calling  register_node_type+0x0/0x23 @ 1
initcall register_node_type+0x0/0x23 returned 0 after 0 usecs
calling  i2c_init+0x0/0x72 @ 1
initcall i2c_init+0x0/0x72 returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x146 @ 1
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [feb00000, fec0ffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fed3ffff]
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0x40000000-0xfcffffffff]
bus: 00 index 2 [mem 0xfeb00000-0xfec0ffff]
bus: 00 index 3 [mem 0x000a0000-0x000bffff]
initcall amd_postcore_init+0x0/0x146 returned 0 after 39062 usecs
calling  arch_kdebugfs_init+0x0/0x21 @ 1
initcall arch_kdebugfs_init+0x0/0x21 returned 0 after 0 usecs
calling  configure_trampolines+0x0/0x23 @ 1
initcall configure_trampolines+0x0/0x23 returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x61 @ 1
initcall mtrr_if_init+0x0/0x61 returned 0 after 0 usecs
calling  dynamic_debug_init+0x0/0x11d @ 1
initcall dynamic_debug_init+0x0/0x11d returned 0 after 0 usecs
calling  acpi_pci_init+0x0/0x59 @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x59 returned 0 after 9765 usecs
calling  dma_bus_init+0x0/0x3b @ 1
initcall dma_bus_init+0x0/0x3b returned 0 after 0 usecs
calling  dma_channel_table_init+0x0/0xcb @ 1
initcall dma_channel_table_init+0x0/0xcb returned 0 after 0 usecs
calling  pci_arch_init+0x0/0x5f @ 1
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x5f returned 0 after 29296 usecs
calling  topology_init+0x0/0x87 @ 1
initcall topology_init+0x0/0x87 returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x34 @ 1
initcall mtrr_init_finialize+0x0/0x34 returned 0 after 0 usecs
calling  init_vdso_vars+0x0/0x203 @ 1
initcall init_vdso_vars+0x0/0x203 returned 0 after 0 usecs
calling  sysenter_setup+0x0/0x2bd @ 1
initcall sysenter_setup+0x0/0x2bd returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x28f @ 1
initcall param_sysfs_init+0x0/0x28f returned 0 after 0 usecs
calling  pm_sysrq_init+0x0/0x16 @ 1
initcall pm_sysrq_init+0x0/0x16 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0x9d @ 1
initcall default_bdi_init+0x0/0x9d returned 0 after 0 usecs
calling  init_bio+0x0/0xd3 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xd3 returned 0 after 0 usecs
calling  fsnotify_notification_init+0x0/0x8a @ 1
initcall fsnotify_notification_init+0x0/0x8a returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0xc @ 1
initcall cryptomgr_init+0x0/0xc returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x25 @ 1
initcall blk_settings_init+0x0/0x25 returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x27 @ 1
initcall blk_ioc_init+0x0/0x27 returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x6a @ 1
initcall blk_softirq_init+0x0/0x6a returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x68 @ 1
initcall blk_iopoll_setup+0x0/0x68 returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x7b @ 1
initcall genhd_device_init+0x0/0x7b returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x42 @ 1
initcall pci_slot_init+0x0/0x42 returned 0 after 0 usecs
calling  acpi_init+0x0/0x1c6 @ 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
initcall acpi_init+0x0/0x1c6 returned 0 after 29296 usecs
calling  acpi_pci_root_init+0x0/0x27 @ 1
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
pci 0000:00:01.0: [10de:0050] type 0 class 0x000601
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: [10de:0059] type 0 class 0x000401
pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:06.0: [10de:0053] type 0 class 0x000101
pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
pci 0000:00:0a.0: [10de:0057] type 0 class 0x000680
pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
PCI: peer root bus 00 res updated from pci conf
pci 0000:05:07.0: [10ec:8139] type 0 class 0x000200
pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
pci 0000:05:07.0: supports D1 D2
pci 0000:05:07.0: PME# supported from D1 D2 D3hot
pci 0000:05:07.0: PME# disabled
pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x40000000-0xfcffffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:0b.0: PCI bridge to [bus 04-04]
pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0c.0: PCI bridge to [bus 03-03]
pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:01:00.0: [1002:5b60] type 0 class 0x000300
pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: [1002:5b70] type 0 class 0x000380
pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0e.0: PCI bridge to [bus 01-01]
pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
initcall acpi_pci_root_init+0x0/0x27 returned 0 after 546875 usecs
calling  acpi_pci_link_init+0x0/0x3b @ 1
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
initcall acpi_pci_link_init+0x0/0x3b returned 0 after 195312 usecs
calling  pnp_init+0x0/0xc @ 1
initcall pnp_init+0x0/0xc returned 0 after 0 usecs
calling  regulator_fixed_voltage_init+0x0/0xc @ 1
initcall regulator_fixed_voltage_init+0x0/0xc returned 0 after 0 usecs
calling  ad5398_init+0x0/0xe @ 1
initcall ad5398_init+0x0/0xe returned 0 after 0 usecs
calling  max8649_init+0x0/0xe @ 1
initcall max8649_init+0x0/0xe returned 0 after 0 usecs
calling  max8660_init+0x0/0xe @ 1
initcall max8660_init+0x0/0xe returned 0 after 0 usecs
calling  max8998_pmic_init+0x0/0xc @ 1
initcall max8998_pmic_init+0x0/0xc returned 0 after 0 usecs
calling  wm8350_regulator_init+0x0/0xc @ 1
initcall wm8350_regulator_init+0x0/0xc returned 0 after 0 usecs
calling  tps_65023_init+0x0/0xe @ 1
initcall tps_65023_init+0x0/0xe returned 0 after 0 usecs
calling  tps6507x_pmic_init+0x0/0xc @ 1
initcall tps6507x_pmic_init+0x0/0xc returned 0 after 0 usecs
calling  misc_init+0x0/0xad @ 1
initcall misc_init+0x0/0xad returned 0 after 0 usecs
calling  vga_arb_device_init+0x0/0x8b @ 1
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
initcall vga_arb_device_init+0x0/0x8b returned 0 after 9765 usecs
calling  tc3589x_init+0x0/0xe @ 1
initcall tc3589x_init+0x0/0xe returned 0 after 0 usecs
calling  wm8400_module_init+0x0/0x29 @ 1
initcall wm8400_module_init+0x0/0x29 returned 0 after 0 usecs
calling  wm8350_i2c_init+0x0/0xe @ 1
initcall wm8350_i2c_init+0x0/0xe returned 0 after 0 usecs
calling  tps6105x_init+0x0/0xe @ 1
initcall tps6105x_init+0x0/0xe returned 0 after 0 usecs
calling  max8998_i2c_init+0x0/0xe @ 1
initcall max8998_i2c_init+0x0/0xe returned 0 after 0 usecs
calling  init_scsi+0x0/0x77 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x77 returned 0 after 0 usecs
calling  ata_init+0x0/0x30d @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x30d returned 0 after 0 usecs
calling  phy_init+0x0/0x2f @ 1
initcall phy_init+0x0/0x2f returned 0 after 0 usecs
calling  init_pcmcia_cs+0x0/0x33 @ 1
initcall init_pcmcia_cs+0x0/0x33 returned 0 after 0 usecs
calling  nop_usb_xceiv_init+0x0/0xc @ 1
initcall nop_usb_xceiv_init+0x0/0xc returned 0 after 0 usecs
calling  usb_init+0x0/0x155 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x155 returned 0 after 9765 usecs
calling  serio_init+0x0/0x27 @ 1
initcall serio_init+0x0/0x27 returned 0 after 0 usecs
calling  gameport_init+0x0/0x27 @ 1
initcall gameport_init+0x0/0x27 returned 0 after 0 usecs
calling  input_init+0x0/0x102 @ 1
initcall input_init+0x0/0x102 returned 0 after 0 usecs
calling  tca6416_keypad_init+0x0/0xe @ 1
initcall tca6416_keypad_init+0x0/0xe returned 0 after 0 usecs
calling  pps_init+0x0/0xa7 @ 1
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
initcall pps_init+0x0/0xa7 returned 0 after 9765 usecs
calling  power_supply_class_init+0x0/0x3d @ 1
initcall power_supply_class_init+0x0/0x3d returned 0 after 0 usecs
calling  acpi_wmi_init+0x0/0x68 @ 1
wmi: Mapper loaded
initcall acpi_wmi_init+0x0/0x68 returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0x43 @ 1
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
Expanded resource reserved due to conflict with PCI Bus #00
reserve RAM buffer: 000000000009f800 - 000000000009ffff 
reserve RAM buffer: 000000003fff0000 - 000000003fffffff 
initcall pci_subsys_init+0x0/0x43 returned 0 after 29296 usecs
calling  proto_init+0x0/0xc @ 1
initcall proto_init+0x0/0xc returned 0 after 0 usecs
calling  net_dev_init+0x0/0x1c6 @ 1
initcall net_dev_init+0x0/0x1c6 returned 0 after 0 usecs
calling  neigh_init+0x0/0x70 @ 1
initcall neigh_init+0x0/0x70 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xe2 @ 1
initcall pktsched_init+0x0/0xe2 returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x49 @ 1
initcall tc_filter_init+0x0/0x49 returned 0 after 0 usecs
calling  tc_action_init+0x0/0x49 @ 1
initcall tc_action_init+0x0/0x49 returned 0 after 0 usecs
calling  genl_init+0x0/0x8f @ 1
initcall genl_init+0x0/0x8f returned 0 after 0 usecs
calling  cipso_v4_init+0x0/0x5b @ 1
initcall cipso_v4_init+0x0/0x5b returned 0 after 0 usecs
calling  wanrouter_init+0x0/0x4b @ 1
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall wanrouter_init+0x0/0x4b returned 0 after 0 usecs
calling  atm_init+0x0/0xc6 @ 1
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall atm_init+0x0/0xc6 returned 0 after 9765 usecs
calling  netlbl_init+0x0/0x7e @ 1
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x7e returned 0 after 19531 usecs
calling  wpan_phy_class_init+0x0/0x3d @ 1
initcall wpan_phy_class_init+0x0/0x3d returned 0 after 0 usecs
calling  sysctl_init+0x0/0x49 @ 1
initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
calling  print_ICs+0x0/0x4f4 @ 1
initcall print_ICs+0x0/0x4f4 returned 0 after 0 usecs
calling  hpet_late_init+0x0/0xc3 @ 1
initcall hpet_late_init+0x0/0xc3 returned -19 after 0 usecs
calling  init_amd_nbs+0x0/0x98 @ 1
initcall init_amd_nbs+0x0/0x98 returned 0 after 0 usecs
calling  clocksource_done_booting+0x0/0x58 @ 1
initcall clocksource_done_booting+0x0/0x58 returned 0 after 0 usecs
calling  init_pipe_fs+0x0/0x42 @ 1
initcall init_pipe_fs+0x0/0x42 returned 0 after 0 usecs
calling  eventpoll_init+0x0/0xda @ 1
initcall eventpoll_init+0x0/0xda returned 0 after 0 usecs
calling  anon_inode_init+0x0/0x124 @ 1
initcall anon_inode_init+0x0/0x124 returned 0 after 0 usecs
calling  blk_scsi_ioctl_init+0x0/0x284 @ 1
initcall blk_scsi_ioctl_init+0x0/0x284 returned 0 after 0 usecs
calling  acpi_event_init+0x0/0x4f @ 1
initcall acpi_event_init+0x0/0x4f returned 0 after 0 usecs
calling  pnp_system_init+0x0/0xc @ 1
initcall pnp_system_init+0x0/0xc returned 0 after 0 usecs
calling  pnpacpi_init+0x0/0x89 @ 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000dffff window]
pnp 00:00: [mem 0x40000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x4000-0x407f]
pnp 00:01: [io  0x4080-0x40ff]
pnp 00:01: [io  0x4400-0x447f]
pnp 00:01: [io  0x4480-0x44ff]
pnp 00:01: [io  0x4800-0x487f]
pnp 00:01: [io  0x4880-0x48ff]
system 00:01: [io  0x4000-0x407f] has been reserved
system 00:01: [io  0x4080-0x40ff] has been reserved
system 00:01: [io  0x4400-0x447f] has been reserved
system 00:01: [io  0x4480-0x44ff] has been reserved
system 00:01: [io  0x4800-0x487f] has been reserved
system 00:01: [io  0x4880-0x48ff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0022-0x003f]
pnp 00:02: [io  0x0044-0x005f]
pnp 00:02: [io  0x0062-0x0063]
pnp 00:02: [io  0x0065-0x006f]
pnp 00:02: [io  0x0074-0x007f]
pnp 00:02: [io  0x0091-0x0093]
pnp 00:02: [io  0x00a2-0x00bf]
pnp 00:02: [io  0x00e0-0x00ef]
pnp 00:02: [io  0x04d0-0x04d1]
pnp 00:02: [io  0x0800-0x0805]
pnp 00:02: [io  0x0290-0x0297]
system 00:02: [io  0x04d0-0x04d1] has been reserved
system 00:02: [io  0x0800-0x0805] has been reserved
system 00:02: [io  0x0290-0x0297] has been reserved
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [dma 4]
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0080-0x0090]
pnp 00:03: [io  0x0094-0x009f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x0070-0x0073]
pnp 00:04: [irq 8]
pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x00f0-0x00ff]
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x03f0-0x03f5]
pnp 00:07: [io  0x03f7]
pnp 00:07: [irq 6]
pnp 00:07: [dma 2]
pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:08: [io  0x03f8-0x03ff]
pnp 00:08: [irq 4]
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:09: [io  0x0378-0x037f]
pnp 00:09: [io  0x0778-0x077b]
pnp 00:09: [irq 7]
pnp 00:09: [dma 3]
pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
pnp 00:0a: [io  0x0060]
pnp 00:0a: [io  0x0064]
pnp 00:0a: [irq 1]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:0b: [io  0x0330-0x0331]
pnp 00:0b: [irq 10]
pnp 00:0b: Plug and Play ACPI device, IDs PNPb006 (active)
pnp 00:0c: [io  0x0201]
pnp 00:0c: Plug and Play ACPI device, IDs PNPb02f (active)
pnp 00:0d: [mem 0xe0000000-0xefffffff]
system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0e: [mem 0x000f0000-0x000f3fff]
pnp 00:0e: [mem 0x000f4000-0x000f7fff]
pnp 00:0e: [mem 0x000f8000-0x000fbfff]
pnp 00:0e: [mem 0x000fc000-0x000fffff]
pnp 00:0e: [mem 0x3fff0000-0x3fffffff]
pnp 00:0e: [mem 0xffff0000-0xffffffff]
pnp 00:0e: [mem 0x00000000-0x0009ffff]
pnp 00:0e: [mem 0x00100000-0x3ffeffff]
pnp 00:0e: [mem 0xfec00000-0xfec00fff]
pnp 00:0e: [mem 0xfee00000-0xfeefffff]
pnp 00:0e: [mem 0xfefff000-0xfeffffff]
pnp 00:0e: [mem 0xfff80000-0xfff80fff]
pnp 00:0e: [mem 0xfff90000-0xfffbffff]
pnp 00:0e: [mem 0xfffed000-0xfffeffff]
system 00:0e: [mem 0x000f0000-0x000f3fff] could not be reserved
system 00:0e: [mem 0x000f4000-0x000f7fff] could not be reserved
system 00:0e: [mem 0x000f8000-0x000fbfff] could not be reserved
system 00:0e: [mem 0x000fc000-0x000fffff] could not be reserved
system 00:0e: [mem 0x3fff0000-0x3fffffff] could not be reserved
system 00:0e: [mem 0xffff0000-0xffffffff] has been reserved
system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0e: [mem 0x00100000-0x3ffeffff] could not be reserved
system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0e: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:0e: [mem 0xfefff000-0xfeffffff] has been reserved
system 00:0e: [mem 0xfff80000-0xfff80fff] has been reserved
system 00:0e: [mem 0xfff90000-0xfffbffff] has been reserved
system 00:0e: [mem 0xfffed000-0xfffeffff] has been reserved
system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x89 returned 0 after 400390 usecs
calling  chr_dev_init+0x0/0xbd @ 1
initcall chr_dev_init+0x0/0xbd returned 0 after 0 usecs
calling  firmware_class_init+0x0/0x13 @ 1
initcall firmware_class_init+0x0/0x13 returned 0 after 0 usecs
calling  init_pcmcia_bus+0x0/0x5b @ 1
initcall init_pcmcia_bus+0x0/0x5b returned 0 after 0 usecs
calling  cpufreq_gov_performance_init+0x0/0xc @ 1
initcall cpufreq_gov_performance_init+0x0/0xc returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0xc @ 1
initcall cpufreq_gov_dbs_init+0x0/0xc returned 0 after 0 usecs
calling  init_acpi_pm_clocksource+0x0/0xd6 @ 1
Switching to clocksource acpi_pm
initcall init_acpi_pm_clocksource+0x0/0xd6 returned 0 after 9770 usecs
calling  ssb_modinit+0x0/0x4b @ 1
initcall ssb_modinit+0x0/0x4b returned 0 after 11 usecs
calling  pcibios_assign_resources+0x0/0x6a @ 1
pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff])
pci 0000:00:09.0: PCI bridge to [bus 05-05]
pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 04-04]
pci 0000:00:0b.0:   bridge window [io  disabled]
pci 0000:00:0b.0:   bridge window [mem disabled]
pci 0000:00:0b.0:   bridge window [mem pref disabled]
pci 0000:00:0c.0: PCI bridge to [bus 03-03]
pci 0000:00:0c.0:   bridge window [io  disabled]
pci 0000:00:0c.0:   bridge window [mem disabled]
pci 0000:00:0c.0:   bridge window [mem pref disabled]
pci 0000:00:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:0d.0:   bridge window [io  disabled]
pci 0000:00:0d.0:   bridge window [mem disabled]
pci 0000:00:0d.0:   bridge window [mem pref disabled]
pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
pci 0000:00:0e.0: PCI bridge to [bus 01-01]
pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x40000000-0xfcffffffff]
pci_bus 0000:00: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
pci_bus 0000:05: resource 5 [mem 0x40000000-0xfcffffffff]
pci_bus 0000:05: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:05: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
initcall pcibios_assign_resources+0x0/0x6a returned 0 after 190843 usecs
calling  sysctl_core_init+0x0/0x34 @ 1
initcall sysctl_core_init+0x0/0x34 returned 0 after 17 usecs
calling  inet_init+0x0/0x239 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
IPv4 FIB: Using LC-trie version 0.409
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
initcall inet_init+0x0/0x239 returned 0 after 42368 usecs
calling  af_unix_init+0x0/0x4b @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x4b returned 0 after 2993 usecs
calling  pci_apply_final_quirks+0x0/0xec @ 1
pci 0000:00:0b.0: Linking AER extended capability
pci 0000:00:0c.0: Linking AER extended capability
pci 0000:00:0d.0: Linking AER extended capability
pci 0000:00:0e.0: Linking AER extended capability
pci 0000:01:00.0: Boot video device
PCI: CLS 32 bytes, default 64
initcall pci_apply_final_quirks+0x0/0xec returned 0 after 36696 usecs
calling  populate_rootfs+0x0/0xc8 @ 1
initcall populate_rootfs+0x0/0xc8 returned 0 after 63 usecs
calling  pci_iommu_init+0x0/0x4d @ 1
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
initcall pci_iommu_init+0x0/0x4d returned 0 after 12883 usecs
calling  i8259A_init_ops+0x0/0x1e @ 1
initcall i8259A_init_ops+0x0/0x1e returned 0 after 1 usecs
calling  vsyscall_init+0x0/0x65 @ 1
initcall vsyscall_init+0x0/0x65 returned 0 after 18 usecs
calling  sbf_init+0x0/0xe2 @ 1
initcall sbf_init+0x0/0xe2 returned 0 after 1 usecs
calling  init_tsc_clocksource+0x0/0x5c @ 1
initcall init_tsc_clocksource+0x0/0x5c returned 0 after 21 usecs
calling  add_rtc_cmos+0x0/0x92 @ 1
initcall add_rtc_cmos+0x0/0x92 returned 0 after 4 usecs
calling  i8237A_init_ops+0x0/0x11 @ 1
initcall i8237A_init_ops+0x0/0x11 returned 0 after 1 usecs
calling  cache_sysfs_init+0x0/0x5c @ 1
initcall cache_sysfs_init+0x0/0x5c returned 0 after 103 usecs
calling  ioapic_init_ops+0x0/0x4a @ 1
initcall ioapic_init_ops+0x0/0x4a returned 0 after 2 usecs
calling  add_pcspkr+0x0/0x37 @ 1
initcall add_pcspkr+0x0/0x37 returned 0 after 26 usecs
calling  start_periodic_check_for_corruption+0x0/0x3d @ 1
initcall start_periodic_check_for_corruption+0x0/0x3d returned 0 after 1 usecs
calling  crypto_fpu_module_init+0x0/0xc @ 1
initcall crypto_fpu_module_init+0x0/0xc returned 0 after 2 usecs
calling  aes_init+0x0/0xc @ 1
initcall aes_init+0x0/0xc returned 0 after 37 usecs
calling  init+0x0/0xc @ 1
initcall init+0x0/0xc returned 0 after 50 usecs
calling  aesni_init+0x0/0x181 @ 1
Intel AES-NI instructions are not detected.
initcall aesni_init+0x0/0x181 returned -19 after 3825 usecs
calling  ghash_pclmulqdqni_mod_init+0x0/0x55 @ 1
Intel PCLMULQDQ-NI instructions are not detected.
initcall ghash_pclmulqdqni_mod_init+0x0/0x55 returned -19 after 4340 usecs
calling  ia32_binfmt_init+0x0/0x11 @ 1
initcall ia32_binfmt_init+0x0/0x11 returned 0 after 4 usecs
calling  proc_execdomains_init+0x0/0x1f @ 1
initcall proc_execdomains_init+0x0/0x1f returned 0 after 7 usecs
calling  ioresources_init+0x0/0x39 @ 1
initcall ioresources_init+0x0/0x39 returned 0 after 6 usecs
calling  uid_cache_init+0x0/0x89 @ 1
initcall uid_cache_init+0x0/0x89 returned 0 after 9 usecs
calling  init_posix_timers+0x0/0x1e0 @ 1
initcall init_posix_timers+0x0/0x1e0 returned 0 after 26 usecs
calling  init_posix_cpu_timers+0x0/0xc5 @ 1
initcall init_posix_cpu_timers+0x0/0xc5 returned 0 after 1 usecs
calling  nsproxy_cache_init+0x0/0x2a @ 1
initcall nsproxy_cache_init+0x0/0x2a returned 0 after 1 usecs
calling  timekeeping_init_ops+0x0/0x11 @ 1
initcall timekeeping_init_ops+0x0/0x11 returned 0 after 1 usecs
calling  init_clocksource_sysfs+0x0/0x4e @ 1
initcall init_clocksource_sysfs+0x0/0x4e returned 0 after 19 usecs
calling  init_timer_list_procfs+0x0/0x29 @ 1
initcall init_timer_list_procfs+0x0/0x29 returned 0 after 2 usecs
calling  futex_init+0x0/0x5f @ 1
initcall futex_init+0x0/0x5f returned 0 after 8 usecs
calling  proc_dma_init+0x0/0x1f @ 1
initcall proc_dma_init+0x0/0x1f returned 0 after 2 usecs
calling  kallsyms_init+0x0/0x22 @ 1
initcall kallsyms_init+0x0/0x22 returned 0 after 2 usecs
calling  pid_namespaces_init+0x0/0x2a @ 1
initcall pid_namespaces_init+0x0/0x2a returned 0 after 6 usecs
calling  utsname_sysctl_init+0x0/0x11 @ 1
initcall utsname_sysctl_init+0x0/0x11 returned 0 after 12 usecs
calling  perf_event_sysfs_init+0x0/0x93 @ 1
initcall perf_event_sysfs_init+0x0/0x93 returned 0 after 57 usecs
calling  init_per_zone_wmark_min+0x0/0x68 @ 1
initcall init_per_zone_wmark_min+0x0/0x68 returned 0 after 36 usecs
calling  kswapd_init+0x0/0x69 @ 1
initcall kswapd_init+0x0/0x69 returned 0 after 31 usecs
calling  extfrag_debug_init+0x0/0x70 @ 1
initcall extfrag_debug_init+0x0/0x70 returned 0 after 14 usecs
calling  setup_vmstat+0x0/0xbd @ 1
initcall setup_vmstat+0x0/0xbd returned 0 after 15 usecs
calling  mm_sysfs_init+0x0/0x26 @ 1
initcall mm_sysfs_init+0x0/0x26 returned 0 after 4 usecs
calling  proc_vmalloc_init+0x0/0x22 @ 1
initcall proc_vmalloc_init+0x0/0x22 returned 0 after 3 usecs
calling  procswaps_init+0x0/0x20 @ 1
initcall procswaps_init+0x0/0x20 returned 0 after 3 usecs
calling  slab_proc_init+0x0/0x22 @ 1
initcall slab_proc_init+0x0/0x22 returned 0 after 3 usecs
calling  slab_sysfs_init+0x0/0x104 @ 1
initcall slab_sysfs_init+0x0/0x104 returned 0 after 2666 usecs
calling  hugepage_init+0x0/0x129 @ 1
initcall hugepage_init+0x0/0x129 returned 0 after 108 usecs
calling  fcntl_init+0x0/0x27 @ 1
initcall fcntl_init+0x0/0x27 returned 0 after 23 usecs
calling  proc_filesystems_init+0x0/0x1f @ 1
initcall proc_filesystems_init+0x0/0x1f returned 0 after 5 usecs
calling  fsnotify_mark_init+0x0/0x3d @ 1
initcall fsnotify_mark_init+0x0/0x3d returned 0 after 25 usecs
calling  fanotify_user_setup+0x0/0x4f @ 1
initcall fanotify_user_setup+0x0/0x4f returned 0 after 12 usecs
calling  aio_setup+0x0/0x99 @ 1
initcall aio_setup+0x0/0x99 returned 0 after 64 usecs
calling  proc_locks_init+0x0/0x1f @ 1
initcall proc_locks_init+0x0/0x1f returned 0 after 4 usecs
calling  init_sys32_ioctl+0x0/0x25 @ 1
initcall init_sys32_ioctl+0x0/0x25 returned 0 after 74 usecs
calling  init_mbcache+0x0/0x11 @ 1
initcall init_mbcache+0x0/0x11 returned 0 after 1 usecs
calling  dquot_init+0x0/0x10e @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0x10e returned 0 after 7661 usecs
calling  init_v1_quota_format+0x0/0xc @ 1
initcall init_v1_quota_format+0x0/0xc returned 0 after 1 usecs
calling  quota_init+0x0/0x23 @ 1
initcall quota_init+0x0/0x23 returned 0 after 7 usecs
calling  proc_cmdline_init+0x0/0x1f @ 1
initcall proc_cmdline_init+0x0/0x1f returned 0 after 3 usecs
calling  proc_consoles_init+0x0/0x1f @ 1
initcall proc_consoles_init+0x0/0x1f returned 0 after 2 usecs
calling  proc_cpuinfo_init+0x0/0x1f @ 1
initcall proc_cpuinfo_init+0x0/0x1f returned 0 after 2 usecs
calling  proc_devices_init+0x0/0x1f @ 1
initcall proc_devices_init+0x0/0x1f returned 0 after 2 usecs
calling  proc_interrupts_init+0x0/0x1f @ 1
initcall proc_interrupts_init+0x0/0x1f returned 0 after 2 usecs
calling  proc_loadavg_init+0x0/0x1f @ 1
initcall proc_loadavg_init+0x0/0x1f returned 0 after 2 usecs
calling  proc_meminfo_init+0x0/0x1f @ 1
initcall proc_meminfo_init+0x0/0x1f returned 0 after 2 usecs
calling  proc_stat_init+0x0/0x21 @ 1
initcall proc_stat_init+0x0/0x21 returned 0 after 3 usecs
calling  proc_uptime_init+0x0/0x1f @ 1
initcall proc_uptime_init+0x0/0x1f returned 0 after 2 usecs
calling  proc_version_init+0x0/0x1f @ 1
initcall proc_version_init+0x0/0x1f returned 0 after 2 usecs
calling  proc_softirqs_init+0x0/0x1f @ 1
initcall proc_softirqs_init+0x0/0x1f returned 0 after 2 usecs
calling  vmcore_init+0x0/0x4bd @ 1
initcall vmcore_init+0x0/0x4bd returned 0 after 1 usecs
calling  proc_kmsg_init+0x0/0x23 @ 1
initcall proc_kmsg_init+0x0/0x23 returned 0 after 3 usecs
calling  proc_page_init+0x0/0x3f @ 1
initcall proc_page_init+0x0/0x3f returned 0 after 6 usecs
calling  configfs_init+0x0/0xa9 @ 1
initcall configfs_init+0x0/0xa9 returned 0 after 59 usecs
calling  init_devpts_fs+0x0/0x42 @ 1
initcall init_devpts_fs+0x0/0x42 returned 0 after 18 usecs
calling  init_dlm+0x0/0x7e @ 1
DLM (built Mar 29 2011 13:23:27) installed
initcall init_dlm+0x0/0x7e returned 0 after 3902 usecs
calling  init_reiserfs_fs+0x0/0x57 @ 1
initcall init_reiserfs_fs+0x0/0x57 returned 0 after 48 usecs
calling  init_ext3_fs+0x0/0x79 @ 1
initcall init_ext3_fs+0x0/0x79 returned 0 after 96 usecs
calling  init_ext2_fs+0x0/0x57 @ 1
initcall init_ext2_fs+0x0/0x57 returned 0 after 47 usecs
calling  ext4_init_fs+0x0/0x1ee @ 1
initcall ext4_init_fs+0x0/0x1ee returned 0 after 272 usecs
calling  journal_init+0x0/0x8d @ 1
initcall journal_init+0x0/0x8d returned 0 after 150 usecs
calling  journal_init+0x0/0x13d @ 1
initcall journal_init+0x0/0x13d returned 0 after 32 usecs
calling  init_squashfs_fs+0x0/0x63 @ 1
squashfs: version 4.0 (2009/01/31) Phillip Lougher
initcall init_squashfs_fs+0x0/0x63 returned 0 after 4503 usecs
calling  init_ramfs_fs+0x0/0xc @ 1
initcall init_ramfs_fs+0x0/0xc returned 0 after 2 usecs
calling  init_fat_fs+0x0/0x45 @ 1
initcall init_fat_fs+0x0/0x45 returned 0 after 93 usecs
calling  init_vfat_fs+0x0/0xc @ 1
initcall init_vfat_fs+0x0/0xc returned 0 after 2 usecs
calling  init_msdos_fs+0x0/0xc @ 1
initcall init_msdos_fs+0x0/0xc returned 0 after 1 usecs
calling  init_bfs_fs+0x0/0x57 @ 1
initcall init_bfs_fs+0x0/0x57 returned 0 after 47 usecs
calling  init_hfsplus_fs+0x0/0x53 @ 1
initcall init_hfsplus_fs+0x0/0x53 returned 0 after 46 usecs
calling  vxfs_init+0x0/0x4f @ 1
initcall vxfs_init+0x0/0x4f returned 0 after 51 usecs
calling  init_nls_cp737+0x0/0xc @ 1
initcall init_nls_cp737+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp775+0x0/0xc @ 1
initcall init_nls_cp775+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp850+0x0/0xc @ 1
initcall init_nls_cp850+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp852+0x0/0xc @ 1
initcall init_nls_cp852+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp860+0x0/0xc @ 1
initcall init_nls_cp860+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp864+0x0/0xc @ 1
initcall init_nls_cp864+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp865+0x0/0xc @ 1
initcall init_nls_cp865+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp869+0x0/0xc @ 1
initcall init_nls_cp869+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp949+0x0/0xc @ 1
initcall init_nls_cp949+0x0/0xc returned 0 after 1 usecs
calling  init_nls_cp950+0x0/0xc @ 1
initcall init_nls_cp950+0x0/0xc returned 0 after 1 usecs
calling  init_nls_iso8859_2+0x0/0xc @ 1
initcall init_nls_iso8859_2+0x0/0xc returned 0 after 1 usecs
calling  init_nls_iso8859_4+0x0/0xc @ 1
initcall init_nls_iso8859_4+0x0/0xc returned 0 after 1 usecs
calling  init_nls_iso8859_9+0x0/0xc @ 1
initcall init_nls_iso8859_9+0x0/0xc returned 0 after 1 usecs
calling  init_nls_iso8859_13+0x0/0xc @ 1
initcall init_nls_iso8859_13+0x0/0xc returned 0 after 1 usecs
calling  init_nls_iso8859_14+0x0/0xc @ 1
initcall init_nls_iso8859_14+0x0/0xc returned 0 after 1 usecs
calling  init_nls_koi8_r+0x0/0xc @ 1
initcall init_nls_koi8_r+0x0/0xc returned 0 after 1 usecs
calling  init_nls_utf8+0x0/0x1f @ 1
initcall init_nls_utf8+0x0/0x1f returned 0 after 1 usecs
calling  init_sysv_fs+0x0/0x45 @ 1
initcall init_sysv_fs+0x0/0x45 returned 0 after 48 usecs
calling  init_ufs_fs+0x0/0x57 @ 1
initcall init_ufs_fs+0x0/0x57 returned 0 after 46 usecs
calling  init_efs_fs+0x0/0x65 @ 1
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
initcall init_efs_fs+0x0/0x65 returned 0 after 3626 usecs
calling  logfs_init+0x0/0x58 @ 1
initcall logfs_init+0x0/0x58 returned 0 after 73 usecs
calling  init_udf_fs+0x0/0x57 @ 1
initcall init_udf_fs+0x0/0x57 returned 0 after 46 usecs
calling  init_jfs_fs+0x0/0x1bc @ 1
JFS: nTxBlock = 7948, nTxLock = 63584
initcall init_jfs_fs+0x0/0x1bc returned 0 after 6943 usecs
calling  init_xfs_fs+0x0/0xb9 @ 1
SGI XFS with security attributes, large block/inode numbers, debug enabled
initcall init_xfs_fs+0x0/0xb9 returned 0 after 7192 usecs
calling  init_befs_fs+0x0/0x80 @ 1
BeFS version: 0.9.3
initcall init_befs_fs+0x0/0x80 returned 0 after 1860 usecs
calling  ocfs2_init+0x0/0x3e0 @ 1
OCFS2 1.5.0
initcall ocfs2_init+0x0/0x3e0 returned 0 after 1270 usecs
calling  ocfs2_stack_glue_init+0x0/0x8b @ 1
initcall ocfs2_stack_glue_init+0x0/0x8b returned 0 after 14 usecs
calling  o2cb_stack_init+0x0/0xc @ 1
ocfs2: Registered cluster interface o2cb
initcall o2cb_stack_init+0x0/0xc returned 0 after 3578 usecs
calling  init_dlmfs_fs+0x0/0xda @ 1
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
initcall init_dlmfs_fs+0x0/0xda returned 0 after 5120 usecs
calling  init_o2nm+0x0/0x9f @ 1
OCFS2 Node Manager 1.5.0
initcall init_o2nm+0x0/0x9f returned 0 after 2335 usecs
calling  dlm_init+0x0/0x384 @ 1
OCFS2 DLM 1.5.0
initcall dlm_init+0x0/0x384 returned 0 after 1491 usecs
calling  init_pstore_fs+0x0/0xc @ 1
initcall init_pstore_fs+0x0/0xc returned 0 after 3 usecs
calling  ipc_init+0x0/0x2c @ 1
msgmni has been set to 1987
initcall ipc_init+0x0/0x2c returned 0 after 2483 usecs
calling  ipc_sysctl_init+0x0/0x11 @ 1
initcall ipc_sysctl_init+0x0/0x11 returned 0 after 27 usecs
calling  init_mqueue_fs+0x0/0xaa @ 1
initcall init_mqueue_fs+0x0/0xaa returned 0 after 89 usecs
calling  crypto_wq_init+0x0/0x2e @ 1
initcall crypto_wq_init+0x0/0x2e returned 0 after 27 usecs
calling  crypto_algapi_init+0x0/0xa @ 1
initcall crypto_algapi_init+0x0/0xa returned 0 after 7 usecs
calling  skcipher_module_init+0x0/0x34 @ 1
initcall skcipher_module_init+0x0/0x34 returned 0 after 1 usecs
calling  chainiv_module_init+0x0/0xc @ 1
initcall chainiv_module_init+0x0/0xc returned 0 after 1 usecs
calling  eseqiv_module_init+0x0/0xc @ 1
initcall eseqiv_module_init+0x0/0xc returned 0 after 1 usecs
calling  seqiv_module_init+0x0/0xc @ 1
initcall seqiv_module_init+0x0/0xc returned 0 after 1 usecs
calling  hmac_module_init+0x0/0xc @ 1
initcall hmac_module_init+0x0/0xc returned 0 after 1 usecs
calling  vmac_module_init+0x0/0xc @ 1
initcall vmac_module_init+0x0/0xc returned 0 after 1 usecs
calling  crypto_xcbc_module_init+0x0/0xc @ 1
initcall crypto_xcbc_module_init+0x0/0xc returned 0 after 1 usecs
calling  crypto_null_mod_init+0x0/0x71 @ 1
initcall crypto_null_mod_init+0x0/0x71 returned 0 after 110 usecs
calling  md4_mod_init+0x0/0xc @ 1
initcall md4_mod_init+0x0/0xc returned 0 after 30 usecs
calling  md5_mod_init+0x0/0xc @ 1
initcall md5_mod_init+0x0/0xc returned 0 after 31 usecs
calling  rmd128_mod_init+0x0/0xc @ 1
initcall rmd128_mod_init+0x0/0xc returned 0 after 31 usecs
calling  rmd256_mod_init+0x0/0xc @ 1
initcall rmd256_mod_init+0x0/0xc returned 0 after 31 usecs
calling  sha1_generic_mod_init+0x0/0xc @ 1
initcall sha1_generic_mod_init+0x0/0xc returned 0 after 31 usecs
calling  sha256_generic_mod_init+0x0/0x35 @ 1
initcall sha256_generic_mod_init+0x0/0x35 returned 0 after 54 usecs
calling  sha512_generic_mod_init+0x0/0x35 @ 1
initcall sha512_generic_mod_init+0x0/0x35 returned 0 after 57 usecs
calling  tgr192_mod_init+0x0/0x5a @ 1
initcall tgr192_mod_init+0x0/0x5a returned 0 after 80 usecs
calling  crypto_cbc_module_init+0x0/0xc @ 1
initcall crypto_cbc_module_init+0x0/0xc returned 0 after 2 usecs
calling  crypto_pcbc_module_init+0x0/0xc @ 1
initcall crypto_pcbc_module_init+0x0/0xc returned 0 after 1 usecs
calling  crypto_cts_module_init+0x0/0xc @ 1
initcall crypto_cts_module_init+0x0/0xc returned 0 after 1 usecs
calling  cryptd_init+0x0/0xac @ 1
initcall cryptd_init+0x0/0xac returned 0 after 4 usecs
calling  des_generic_mod_init+0x0/0x35 @ 1
initcall des_generic_mod_init+0x0/0x35 returned 0 after 55 usecs
calling  blowfish_mod_init+0x0/0xc @ 1
initcall blowfish_mod_init+0x0/0xc returned 0 after 28 usecs
calling  aes_init+0x0/0xc @ 1
initcall aes_init+0x0/0xc returned 0 after 30 usecs
calling  camellia_init+0x0/0xc @ 1
initcall camellia_init+0x0/0xc returned 0 after 28 usecs
calling  cast6_mod_init+0x0/0xc @ 1
initcall cast6_mod_init+0x0/0xc returned 0 after 30 usecs
calling  arc4_init+0x0/0xc @ 1
initcall arc4_init+0x0/0xc returned 0 after 29 usecs
calling  tea_mod_init+0x0/0x5a @ 1
initcall tea_mod_init+0x0/0x5a returned 0 after 84 usecs
calling  anubis_mod_init+0x0/0xc @ 1
initcall anubis_mod_init+0x0/0xc returned 0 after 30 usecs
calling  deflate_mod_init+0x0/0xc @ 1
initcall deflate_mod_init+0x0/0xc returned 0 after 30 usecs
calling  zlib_mod_init+0x0/0xc @ 1
initcall zlib_mod_init+0x0/0xc returned 0 after 29 usecs
calling  michael_mic_init+0x0/0xc @ 1
initcall michael_mic_init+0x0/0xc returned 0 after 29 usecs
calling  crc32c_mod_init+0x0/0xc @ 1
initcall crc32c_mod_init+0x0/0xc returned 0 after 30 usecs
calling  crypto_authenc_module_init+0x0/0xc @ 1
initcall crypto_authenc_module_init+0x0/0xc returned 0 after 1 usecs
calling  crypto_authenc_esn_module_init+0x0/0xc @ 1
initcall crypto_authenc_esn_module_init+0x0/0xc returned 0 after 1 usecs
calling  lzo_mod_init+0x0/0xc @ 1
initcall lzo_mod_init+0x0/0xc returned 0 after 29 usecs
calling  krng_mod_init+0x0/0xc @ 1
initcall krng_mod_init+0x0/0xc returned 0 after 29 usecs
calling  prng_mod_init+0x0/0xc @ 1
initcall prng_mod_init+0x0/0xc returned 0 after 31 usecs
calling  af_alg_init+0x0/0x3f @ 1
NET: Registered protocol family 38
initcall af_alg_init+0x0/0x3f returned 0 after 3063 usecs
calling  algif_skcipher_init+0x0/0xc @ 1
initcall algif_skcipher_init+0x0/0xc returned 0 after 1 usecs
calling  proc_genhd_init+0x0/0x3a @ 1
initcall proc_genhd_init+0x0/0x3a returned 0 after 5 usecs
calling  bsg_init+0x0/0x12b @ 1
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
initcall bsg_init+0x0/0x12b returned 0 after 6025 usecs
calling  noop_init+0x0/0x11 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x11 returned 0 after 2565 usecs
calling  cfq_init+0x0/0x9d @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x9d returned 0 after 3392 usecs
calling  btree_module_init+0x0/0x27 @ 1
initcall btree_module_init+0x0/0x27 returned 0 after 9 usecs
calling  libcrc32c_mod_init+0x0/0x27 @ 1
initcall libcrc32c_mod_init+0x0/0x27 returned 0 after 3 usecs
calling  percpu_counter_startup+0x0/0x16 @ 1
initcall percpu_counter_startup+0x0/0x16 returned 0 after 3 usecs
calling  dynamic_debug_init_debugfs+0x0/0x5f @ 1
initcall dynamic_debug_init_debugfs+0x0/0x5f returned 0 after 7 usecs
calling  pci_proc_init+0x0/0x60 @ 1
initcall pci_proc_init+0x0/0x60 returned 0 after 54 usecs
calling  pcie_portdrv_init+0x0/0x6d @ 1
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0c.0: setting latency timer to 64
pcieport 0000:00:0d.0: setting latency timer to 64
pcieport 0000:00:0e.0: setting latency timer to 64
initcall pcie_portdrv_init+0x0/0x6d returned 0 after 17999 usecs
calling  aer_service_init+0x0/0x6 @ 1
initcall aer_service_init+0x0/0x6 returned -6 after 1 usecs
initcall aer_service_init+0x0/0x6 returned with error code -6 
calling  aer_inject_init+0x0/0xc @ 1
initcall aer_inject_init+0x0/0xc returned 0 after 47 usecs
calling  ioapic_init+0x0/0x15 @ 1
initcall ioapic_init+0x0/0x15 returned 0 after 16 usecs
calling  display_class_init+0x0/0x7b @ 1
initcall display_class_init+0x0/0x7b returned 0 after 16 usecs
calling  i7300_idle_init+0x0/0x5cf @ 1
initcall i7300_idle_init+0x0/0x5cf returned -19 after 19 usecs
calling  acpi_reserve_resources+0x0/0xe8 @ 1
initcall acpi_reserve_resources+0x0/0xe8 returned 0 after 6 usecs
calling  irqrouter_init_ops+0x0/0x25 @ 1
initcall irqrouter_init_ops+0x0/0x25 returned 0 after 1 usecs
calling  acpi_ac_init+0x0/0x47 @ 1
initcall acpi_ac_init+0x0/0x47 returned 0 after 60 usecs
calling  acpi_button_init+0x0/0xc @ 1
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
initcall acpi_button_init+0x0/0xc returned 0 after 17423 usecs
calling  acpi_container_init+0x0/0x4b @ 1
initcall acpi_container_init+0x0/0x4b returned 0 after 4854 usecs
calling  acpi_hed_init+0x0/0x23 @ 1
initcall acpi_hed_init+0x0/0x23 returned 0 after 22 usecs
calling  acpi_ec_sys_init+0x0/0x19 @ 1
initcall acpi_ec_sys_init+0x0/0x19 returned -19 after 1 usecs
calling  acpi_ipmi_init+0x0/0x37 @ 1
initcall acpi_ipmi_init+0x0/0x37 returned 0 after 2 usecs
calling  bq24022_init+0x0/0x13 @ 1
initcall bq24022_init+0x0/0x13 returned -19 after 21 usecs
calling  pty_init+0x0/0x428 @ 1
initcall pty_init+0x0/0x428 returned 0 after 20703 usecs
calling  sysrq_init+0x0/0x43 @ 1
initcall sysrq_init+0x0/0x43 returned 0 after 16 usecs
calling  r3964_init+0x0/0x3a @ 1
r3964: Philips r3964 Driver $Revision: 1.10 $
initcall r3964_init+0x0/0x3a returned 0 after 3995 usecs
calling  serial8250_init+0x0/0x188 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_init+0x0/0x188 returned 0 after 296539 usecs
calling  serial8250_pnp_init+0x0/0xc @ 1
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_pnp_init+0x0/0xc returned 0 after 98293 usecs
calling  serial8250_pci_init+0x0/0x15 @ 1
initcall serial8250_pci_init+0x0/0x15 returned 0 after 54 usecs
calling  init_serial_cs+0x0/0xc @ 1
initcall init_serial_cs+0x0/0xc returned 0 after 34 usecs
calling  jsm_init_module+0x0/0x46 @ 1
initcall jsm_init_module+0x0/0x46 returned 0 after 33 usecs
calling  moxa_init+0x0/0x22e @ 1
MOXA Intellio family driver version 6.0k
initcall moxa_init+0x0/0x22e returned 0 after 13264 usecs
calling  mxser_module_init+0x0/0x607 @ 1
MOXA Smartio/Industio family driver version 2.0.5
initcall mxser_module_init+0x0/0x607 returned 0 after 4366 usecs
calling  nozomi_init+0x0/0x11f @ 1
Initializing Nozomi driver 2.1d (build date: Mar 29 2011 13:23:42)
initcall nozomi_init+0x0/0x11f returned 0 after 5787 usecs
calling  slgt_init+0x0/0x1b7 @ 1
SyncLink GT
SyncLink GT, tty major#250
SyncLink GT no devices found
initcall slgt_init+0x0/0x1b7 returned 0 after 6093 usecs
calling  synclinkmp_init+0x0/0x17d @ 1
SyncLink MultiPort driver $Revision: 4.38 $
SyncLink MultiPort driver $Revision: 4.38 $, tty major#249
initcall synclinkmp_init+0x0/0x17d returned 0 after 20844 usecs
calling  rand_initialize+0x0/0x2b @ 1
initcall rand_initialize+0x0/0x2b returned 0 after 25 usecs
calling  raw_init+0x0/0xdb @ 1
initcall raw_init+0x0/0xdb returned 0 after 73 usecs
calling  applicom_init+0x0/0x4c1 @ 1
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
initcall applicom_init+0x0/0x4c1 returned -6 after 13788 usecs
initcall applicom_init+0x0/0x4c1 returned with error code -6 
calling  rtc_init+0x0/0xb7 @ 1
Real Time Clock Driver v1.12b
initcall rtc_init+0x0/0xb7 returned 0 after 2717 usecs
calling  hpet_init+0x0/0x60 @ 1
initcall hpet_init+0x0/0x60 returned 0 after 89 usecs
calling  nvram_init+0x0/0x78 @ 1
Non-volatile memory driver v1.3
initcall nvram_init+0x0/0x78 returned 0 after 2859 usecs
calling  mod_init+0x0/0xb3 @ 1
initcall mod_init+0x0/0xb3 returned -19 after 20 usecs
calling  mod_init+0x0/0x49 @ 1
initcall mod_init+0x0/0x49 returned -19 after 1 usecs
calling  tlclk_init+0x0/0x1e2 @ 1
telclk_interrup = 0xf non-mcpbl0010 hw.
initcall tlclk_init+0x0/0x1e2 returned -6 after 3506 usecs
initcall tlclk_init+0x0/0x1e2 returned with error code -6 
calling  mwave_init+0x0/0x1de @ 1
smapi::smapi_init, ERROR invalid usSmapiID
mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
mwave: mwavedd::mwave_init: Error: Failed to initialize board data
mwave: mwavedd::mwave_init: Error: Failed to initialize
initcall mwave_init+0x0/0x1de returned -5 after 22184 usecs
initcall mwave_init+0x0/0x1de returned with error code -5 
calling  cmm_init+0x0/0xba @ 1
initcall cmm_init+0x0/0xba returned 0 after 22 usecs
calling  ipmi_init_msghandler_mod+0x0/0xb @ 1
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xb returned 0 after 3000 usecs
calling  init_ipmi_devintf+0x0/0xfe @ 1
ipmi device interface
initcall init_ipmi_devintf+0x0/0xfe returned 0 after 1973 usecs
calling  init_ipmi_si+0x0/0x946 @ 1
IPMI System Interface driver.
ipmi_si: Adding default-specified kcs state machine
ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
ipmi_si: Interface detection failed
ipmi_si: Adding default-specified smic state machine
ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
ipmi_si: Interface detection failed
ipmi_si: Adding default-specified bt state machine
ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
ipmi_si: Interface detection failed
ipmi_si: Unable to find any System Interface(s)
initcall init_ipmi_si+0x0/0x946 returned -19 after 126131 usecs
calling  ipmi_wdog_init+0x0/0x123 @ 1
IPMI Watchdog: driver initialized
initcall ipmi_wdog_init+0x0/0x123 returned 0 after 2987 usecs
calling  init_tis+0x0/0x9b @ 1
initcall init_tis+0x0/0x9b returned 0 after 20 usecs
calling  init_nsc+0x0/0x4e5 @ 1
initcall init_nsc+0x0/0x4e5 returned -19 after 12 usecs
calling  init_atmel+0x0/0x189 @ 1
initcall init_atmel+0x0/0x189 returned -19 after 20 usecs
calling  init_inf+0x0/0xc @ 1
initcall init_inf+0x0/0xc returned 0 after 13 usecs
calling  ramoops_init+0x0/0x13 @ 1
initcall ramoops_init+0x0/0x13 returned -19 after 15 usecs
calling  topology_sysfs_init+0x0/0x5a @ 1
initcall topology_sysfs_init+0x0/0x5a returned 0 after 15 usecs
calling  brd_init+0x0/0x18d @ 1
brd: module loaded
initcall brd_init+0x0/0x18d returned 0 after 2766 usecs
calling  loop_init+0x0/0x197 @ 1
loop: module loaded
initcall loop_init+0x0/0x197 returned 0 after 2319 usecs
calling  cpqarray_init+0x0/0x251 @ 1
Compaq SMART2 Driver (v 2.6.0)
initcall cpqarray_init+0x0/0x251 returned -19 after 2752 usecs
calling  cciss_init+0x0/0x95 @ 1
HP CISS Driver (v 3.6.26)
initcall cciss_init+0x0/0x95 returned 0 after 2360 usecs
calling  init_cryptoloop+0x0/0x25 @ 1
initcall init_cryptoloop+0x0/0x25 returned 0 after 1 usecs
calling  carm_init+0x0/0x15 @ 1
initcall carm_init+0x0/0x15 returned 0 after 13 usecs
calling  ibmasm_init+0x0/0x5a @ 1
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
initcall ibmasm_init+0x0/0x5a returned 0 after 5205 usecs
calling  ad_dpot_i2c_init+0x0/0xe @ 1
initcall ad_dpot_i2c_init+0x0/0xe returned 0 after 12 usecs
calling  bmp085_init+0x0/0xe @ 1
initcall bmp085_init+0x0/0xe returned 0 after 9 usecs
calling  ics932s401_init+0x0/0xe @ 1
initcall ics932s401_init+0x0/0xe returned 0 after 9 usecs
calling  lkdtm_module_init+0x0/0x1a0 @ 1
lkdtm: No crash points registered, enable through debugfs
initcall lkdtm_module_init+0x0/0x1a0 returned 0 after 5020 usecs
calling  phantom_init+0x0/0x109 @ 1
Phantom Linux Driver, version n0.9.8, init OK
initcall phantom_init+0x0/0x109 returned 0 after 4028 usecs
calling  bh1780_init+0x0/0xe @ 1
initcall bh1780_init+0x0/0xe returned 0 after 9 usecs
calling  bh1770_init+0x0/0xe @ 1
initcall bh1770_init+0x0/0xe returned 0 after 9 usecs
calling  ioc4_init+0x0/0x15 @ 1
initcall ioc4_init+0x0/0x15 returned 0 after 13 usecs
calling  isl29003_init+0x0/0xe @ 1
i2c-core: driver [isl29003] using legacy suspend method
i2c-core: driver [isl29003] using legacy resume method
initcall isl29003_init+0x0/0xe returned 0 after 9616 usecs
calling  sensor_isl29020_init+0x0/0xe @ 1
initcall sensor_isl29020_init+0x0/0xe returned 0 after 9 usecs
calling  ds1682_init+0x0/0xe @ 1
initcall ds1682_init+0x0/0xe returned 0 after 9 usecs
calling  c2port_init+0x0/0x4f @ 1
Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
initcall c2port_init+0x0/0x4f returned 0 after 5788 usecs
calling  sensor_hmc6352_init+0x0/0xe @ 1
initcall sensor_hmc6352_init+0x0/0xe returned 0 after 12 usecs
calling  eeprom_init+0x0/0xe @ 1
initcall eeprom_init+0x0/0xe returned 0 after 9 usecs
calling  max6875_init+0x0/0xe @ 1
initcall max6875_init+0x0/0xe returned 0 after 9 usecs
calling  cb710_init_module+0x0/0x15 @ 1
initcall cb710_init_module+0x0/0x15 returned 0 after 13 usecs
calling  pch_phub_pci_init+0x0/0x15 @ 1
initcall pch_phub_pci_init+0x0/0x15 returned 0 after 13 usecs
calling  lis3lv02d_init+0x0/0xe @ 1
initcall lis3lv02d_init+0x0/0xe returned 0 after 10 usecs
calling  lpc_sch_init+0x0/0x15 @ 1
initcall lpc_sch_init+0x0/0x15 returned 0 after 13 usecs
calling  rdc321x_sb_init+0x0/0x15 @ 1
initcall rdc321x_sb_init+0x0/0x15 returned 0 after 15 usecs
calling  cmodio_init+0x0/0x15 @ 1
initcall cmodio_init+0x0/0x15 returned 0 after 13 usecs
calling  pn544_init+0x0/0x4c @ 1
initcall pn544_init+0x0/0x4c returned 0 after 9 usecs
calling  spi_transport_init+0x0/0x75 @ 1
initcall spi_transport_init+0x0/0x75 returned 0 after 20 usecs
calling  fc_transport_init+0x0/0x8f @ 1
initcall fc_transport_init+0x0/0x8f returned 0 after 27 usecs
calling  iscsi_transport_init+0x0/0x141 @ 1
Loading iSCSI transport class v2.0-870.
initcall iscsi_transport_init+0x0/0x141 returned 0 after 3565 usecs
calling  sas_transport_init+0x0/0xd5 @ 1
initcall sas_transport_init+0x0/0xd5 returned 0 after 51 usecs
calling  sas_class_init+0x0/0x2e @ 1
initcall sas_class_init+0x0/0x2e returned 0 after 35 usecs
calling  ahc_linux_init+0x0/0x62 @ 1
initcall ahc_linux_init+0x0/0x62 returned 0 after 36 usecs
calling  init_sd+0x0/0x126 @ 1
initcall init_sd+0x0/0x126 returned 0 after 34 usecs
calling  init_sg+0x0/0xca @ 1
initcall init_sg+0x0/0xca returned 0 after 12 usecs
calling  ahci_init+0x0/0x15 @ 1
initcall ahci_init+0x0/0x15 returned 0 after 36 usecs
calling  acard_ahci_init+0x0/0x15 @ 1
initcall acard_ahci_init+0x0/0x15 returned 0 after 13 usecs
calling  ahci_init+0x0/0x13 @ 1
initcall ahci_init+0x0/0x13 returned -19 after 18 usecs
calling  inic_init+0x0/0x15 @ 1
initcall inic_init+0x0/0x15 returned 0 after 13 usecs
calling  qs_ata_init+0x0/0x15 @ 1
initcall qs_ata_init+0x0/0x15 returned 0 after 17 usecs
calling  piix_init+0x0/0x26 @ 1
initcall piix_init+0x0/0x26 returned 0 after 23 usecs
calling  mv_init+0x0/0x46 @ 1
initcall mv_init+0x0/0x46 returned 0 after 24 usecs
calling  nv_init+0x0/0x15 @ 1
initcall nv_init+0x0/0x15 returned 0 after 16 usecs
calling  pdc_ata_init+0x0/0x15 @ 1
initcall pdc_ata_init+0x0/0x15 returned 0 after 16 usecs
calling  sil_init+0x0/0x15 @ 1
initcall sil_init+0x0/0x15 returned 0 after 14 usecs
calling  vsc_sata_init+0x0/0x15 @ 1
initcall vsc_sata_init+0x0/0x15 returned 0 after 14 usecs
calling  amd_init+0x0/0x15 @ 1
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: setting latency timer to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
initcall amd_init+0x0/0x15 returned 0 after 23531 usecs
calling  1_async_port_probe+0x0/0x46 @ 5
calling  2_async_port_probe+0x0/0x46 @ 79
async_waiting @ 79
calling  artop_init+0x0/0x15 @ 1
initcall artop_init+0x0/0x15 returned 0 after 20 usecs
calling  cmd64x_init+0x0/0x15 @ 1
initcall cmd64x_init+0x0/0x15 returned 0 after 14 usecs
calling  hpt36x_init+0x0/0x15 @ 1
initcall hpt36x_init+0x0/0x15 returned 0 after 18 usecs
calling  hpt3x2n_init+0x0/0x15 @ 1
initcall hpt3x2n_init+0x0/0x15 returned 0 after 15 usecs
calling  hpt3x3_init+0x0/0x15 @ 1
initcall hpt3x3_init+0x0/0x15 returned 0 after 13 usecs
calling  it821x_init+0x0/0x15 @ 1
initcall it821x_init+0x0/0x15 returned 0 after 14 usecs
calling  jmicron_init+0x0/0x15 @ 1
initcall jmicron_init+0x0/0x15 returned 0 after 14 usecs
calling  ninja32_init+0x0/0x15 @ 1
initcall ninja32_init+0x0/0x15 returned 0 after 15 usecs
calling  ns87415_init+0x0/0x15 @ 1
initcall ns87415_init+0x0/0x15 returned 0 after 14 usecs
calling  oldpiix_init+0x0/0x15 @ 1
initcall oldpiix_init+0x0/0x15 returned 0 after 14 usecs
calling  optidma_init+0x0/0x15 @ 1
initcall optidma_init+0x0/0x15 returned 0 after 17 usecs
calling  pdc202xx_init+0x0/0x15 @ 1
initcall pdc202xx_init+0x0/0x15 returned 0 after 15 usecs
calling  rdc_init+0x0/0x15 @ 1
initcall rdc_init+0x0/0x15 returned 0 after 14 usecs
calling  sch_init+0x0/0x15 @ 1
initcall sch_init+0x0/0x15 returned 0 after 14 usecs
calling  sil680_init+0x0/0x15 @ 1
initcall sil680_init+0x0/0x15 returned 0 after 14 usecs
calling  ata_tosh_init+0x0/0x15 @ 1
initcall ata_tosh_init+0x0/0x15 returned 0 after 17 usecs
calling  via_init+0x0/0x15 @ 1
initcall via_init+0x0/0x15 returned 0 after 16 usecs
calling  cmd640_init+0x0/0x15 @ 1
initcall cmd640_init+0x0/0x15 returned 0 after 14 usecs
calling  ns87410_init+0x0/0x15 @ 1
initcall ns87410_init+0x0/0x15 returned 0 after 15 usecs
calling  pcmcia_init+0x0/0xc @ 1
initcall pcmcia_init+0x0/0xc returned 0 after 26 usecs
calling  pacpi_init+0x0/0x15 @ 1
initcall pacpi_init+0x0/0x15 returned 0 after 16 usecs
calling  legacy_init+0x0/0x8da @ 1
initcall legacy_init+0x0/0x8da returned -19 after 20 usecs
calling  davicom_init+0x0/0x61 @ 1
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
initcall davicom_init+0x0/0x61 returned 0 after 25 usecs
calling  cicada_init+0x0/0x3d @ 1
initcall cicada_init+0x0/0x3d returned 0 after 16 usecs
calling  lxt_init+0x0/0x61 @ 1
initcall lxt_init+0x0/0x61 returned 0 after 23 usecs
calling  qs6612_init+0x0/0xc @ 1
initcall qs6612_init+0x0/0xc returned 0 after 9 usecs
calling  vsc82xx_init+0x0/0x3d @ 1
initcall vsc82xx_init+0x0/0x3d returned 0 after 20 usecs
calling  bcm63xx_phy_init+0x0/0x3d @ 1
ata1.00: configured for UDMA/100
async_waiting @ 5
async_continuing @ 5 after 2 usec
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
initcall 1_async_port_probe+0x0/0x46 returned 0 after 245665 usecs
calling  3_sd_probe_async+0x0/0x1a3 @ 5
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
async_continuing @ 79 after 246038 usec
initcall bcm63xx_phy_init+0x0/0x3d returned 0 after 18 usecs
calling  icplus_init+0x0/0x25 @ 1
initcall icplus_init+0x0/0x25 returned 0 after 17 usecs
calling  ns_init+0x0/0xc @ 1
initcall ns_init+0x0/0xc returned 0 after 11 usecs
calling  ste10Xp_init+0x0/0x22 @ 1
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
initcall ste10Xp_init+0x0/0x22 returned 0 after 17 usecs
calling  e1000_init_module+0x0/0x7d @ 1
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
sd 0:0:0:0: [sda] Attached SCSI disk
initcall 3_sd_probe_async+0x0/0x1a3 returned 0 after 88488 usecs
e1000: Copyright (c) 1999-2006 Intel Corporation.
initcall e1000_init_module+0x0/0x7d returned 0 after 18808 usecs
calling  e1000_init_module+0x0/0x3a @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
initcall e1000_init_module+0x0/0x3a returned 0 after 9108 usecs
calling  ixgb_init_module+0x0/0x48 @ 1
ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
ixgb: Copyright (c) 1999-2008 Intel Corporation.
initcall ixgb_init_module+0x0/0x48 returned 0 after 9957 usecs
calling  cxgb4vf_module_init+0x0/0x9e @ 1
initcall cxgb4vf_module_init+0x0/0x9e returned 0 after 33 usecs
calling  enic_init_module+0x0/0x33 @ 1
enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.12
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x739f->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x701f (600:60:0x1c)
initcall enic_init_module+0x0/0x33 returned 0 after 17251 usecs
calling  jme_init_module+0x0/0x2c @ 1
jme: JMicron JMC2XX ethernet driver version 1.0.8
initcall jme_init_module+0x0/0x2c returned 0 after 4345 usecs
calling  be_init_module+0x0/0x68 @ 1
initcall be_init_module+0x0/0x68 returned 0 after 14 usecs
ata2.01: configured for UDMA/33
calling  vmxnet3_init_module+0x0/0x33 @ 1
VMware vmxnet3 virtual NIC driver - version 1.0.25.0-k-NAPI
initcall vmxnet3_init_module+0x0/0x33 returned 0 after 5200 usecs
async_waiting @ 79
async_continuing @ 79 after 2 usec
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
scsi 1:0:1:0: Attached scsi generic sg1 type 5
initcall 2_async_port_probe+0x0/0x46 returned 0 after 469820 usecs
calling  bnad_module_init+0x0/0x54 @ 1
Brocade 10G Ethernet driver
initcall bnad_module_init+0x0/0x54 returned 0 after 2485 usecs
calling  happy_meal_probe+0x0/0x15 @ 1
initcall happy_meal_probe+0x0/0x15 returned 0 after 14 usecs
calling  gem_init+0x0/0x15 @ 1
initcall gem_init+0x0/0x15 returned 0 after 15 usecs
calling  vortex_init+0x0/0xa5 @ 1
initcall vortex_init+0x0/0xa5 returned 0 after 21 usecs
calling  e100_init_module+0x0/0x59 @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x59 returned 0 after 8777 usecs
calling  tlan_probe+0x0/0xda @ 1
tlan: ThunderLAN driver v1.17
tlan: 0 devices installed, PCI: 0  EISA: 0
initcall tlan_probe+0x0/0xda returned -19 after 6417 usecs
calling  epic_init+0x0/0x15 @ 1
initcall epic_init+0x0/0x15 returned 0 after 15 usecs
calling  sis190_init_module+0x0/0x15 @ 1
initcall sis190_init_module+0x0/0x15 returned 0 after 15 usecs
calling  sis900_init_module+0x0/0x15 @ 1
initcall sis900_init_module+0x0/0x15 returned 0 after 15 usecs
calling  yellowfin_init+0x0/0x15 @ 1
initcall yellowfin_init+0x0/0x15 returned 0 after 15 usecs
calling  acenic_init+0x0/0x15 @ 1
initcall acenic_init+0x0/0x15 returned 0 after 15 usecs
calling  natsemi_init_mod+0x0/0x15 @ 1
initcall natsemi_init_mod+0x0/0x15 returned 0 after 17 usecs
calling  fealnx_init+0x0/0x15 @ 1
initcall fealnx_init+0x0/0x15 returned 0 after 15 usecs
calling  tg3_init+0x0/0x15 @ 1
initcall tg3_init+0x0/0x15 returned 0 after 26 usecs
calling  bnx2_init+0x0/0x15 @ 1
initcall bnx2_init+0x0/0x15 returned 0 after 16 usecs
calling  cnic_init+0x0/0x70 @ 1
cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.13 (Jan 31, 2011)
initcall cnic_init+0x0/0x70 returned 0 after 5900 usecs
calling  skge_init_module+0x0/0x6f @ 1
initcall skge_init_module+0x0/0x6f returned 0 after 44 usecs
calling  ks8842_init+0x0/0xc @ 1
initcall ks8842_init+0x0/0xc returned 0 after 13 usecs
calling  ks8851_init+0x0/0xc @ 1
initcall ks8851_init+0x0/0xc returned 0 after 9 usecs
calling  velocity_init_module+0x0/0x38 @ 1
initcall velocity_init_module+0x0/0x38 returned 0 after 16 usecs
calling  starfire_init+0x0/0x15 @ 1
initcall starfire_init+0x0/0x15 returned 0 after 15 usecs
calling  stmmac_init_module+0x0/0x36 @ 1
initcall stmmac_init_module+0x0/0x36 returned 0 after 21 usecs
calling  sundance_init+0x0/0x15 @ 1
initcall sundance_init+0x0/0x15 returned 0 after 16 usecs
calling  hamachi_init+0x0/0x15 @ 1
initcall hamachi_init+0x0/0x15 returned 0 after 15 usecs
calling  net_olddevs_init+0x0/0xa3 @ 1
initcall net_olddevs_init+0x0/0xa3 returned 0 after 86 usecs
calling  b44_init+0x0/0x49 @ 1
initcall b44_init+0x0/0x49 returned 0 after 25 usecs
calling  init_nic+0x0/0x15 @ 1
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
forcedeth 0000:00:0a.0: setting latency timer to 64
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
initcall init_nic+0x0/0x15 returned 0 after 552003 usecs
calling  ql3xxx_init_module+0x0/0x15 @ 1
initcall ql3xxx_init_module+0x0/0x15 returned 0 after 15 usecs
calling  qlcnic_init_module+0x0/0xab @ 1
QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.0.15
initcall qlcnic_init_module+0x0/0xab returned 0 after 5410 usecs
calling  qlge_init_module+0x0/0x15 @ 1
initcall qlge_init_module+0x0/0x15 returned 0 after 15 usecs
calling  slip_init+0x0/0xa8 @ 1
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
SLIP linefill/keepalive option.
initcall slip_init+0x0/0xa8 returned 0 after 10962 usecs
calling  dummy_init_module+0x0/0xbc @ 1
initcall dummy_init_module+0x0/0xbc returned 0 after 363 usecs
calling  macvlan_init_module+0x0/0x33 @ 1
initcall macvlan_init_module+0x0/0x33 returned 0 after 2 usecs
calling  macvtap_init+0x0/0xcd @ 1
initcall macvtap_init+0x0/0xcd returned 0 after 16 usecs
calling  cp_init+0x0/0x15 @ 1
8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
8139cp 0000:05:07.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
initcall cp_init+0x0/0x15 returned 0 after 13569 usecs
calling  rtl8139_init_module+0x0/0x15 @ 1
8139too: 8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
8139too 0000:05:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
8139too 0000:05:07.0: eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 17
initcall rtl8139_init_module+0x0/0x15 returned 0 after 22920 usecs
calling  rtl8169_init_module+0x0/0x15 @ 1
initcall rtl8169_init_module+0x0/0x15 returned 0 after 18 usecs
calling  myri10ge_init_module+0x0/0x62 @ 1
myri10ge: Version 1.5.2-1.459
initcall myri10ge_init_module+0x0/0x62 returned 0 after 2653 usecs
calling  mlx4_init+0x0/0x9b @ 1
initcall mlx4_init+0x0/0x9b returned 0 after 48 usecs
calling  ethoc_init+0x0/0xc @ 1
initcall ethoc_init+0x0/0xc returned 0 after 13 usecs
calling  dnet_init+0x0/0xc @ 1
initcall dnet_init+0x0/0xc returned 0 after 13 usecs
calling  olympic_pci_init+0x0/0x15 @ 1
initcall olympic_pci_init+0x0/0x15 returned 0 after 31 usecs
calling  xl_pci_init+0x0/0x15 @ 1
initcall xl_pci_init+0x0/0x15 returned 0 after 15 usecs
calling  init_tc574+0x0/0xc @ 1
initcall init_tc574+0x0/0xc returned 0 after 11 usecs
calling  init_fmvj18x_cs+0x0/0xc @ 1
initcall init_fmvj18x_cs+0x0/0xc returned 0 after 16 usecs
calling  init_nmclan_cs+0x0/0xc @ 1
initcall init_nmclan_cs+0x0/0xc returned 0 after 12 usecs
calling  init_smc91c92_cs+0x0/0xc @ 1
initcall init_smc91c92_cs+0x0/0xc returned 0 after 14 usecs
calling  init_xirc2ps_cs+0x0/0xc @ 1
initcall init_xirc2ps_cs+0x0/0xc returned 0 after 12 usecs
calling  init_axnet_cs+0x0/0xc @ 1
initcall init_axnet_cs+0x0/0xc returned 0 after 13 usecs
calling  init_ibmtr_cs+0x0/0xc @ 1
initcall init_ibmtr_cs+0x0/0xc returned 0 after 10 usecs
calling  catc_init+0x0/0x2e @ 1
usbcore: registered new interface driver catc
catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
initcall catc_init+0x0/0x2e returned 0 after 8520 usecs
calling  kaweth_init+0x0/0x15 @ 1
usbcore: registered new interface driver kaweth
initcall kaweth_init+0x0/0x15 returned 0 after 4172 usecs
calling  pegasus_init+0x0/0x166 @ 1
pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
initcall pegasus_init+0x0/0x166 returned 0 after 10291 usecs
calling  asix_init+0x0/0x15 @ 1
usbcore: registered new interface driver asix
initcall asix_init+0x0/0x15 returned 0 after 4004 usecs
calling  cdc_init+0x0/0x15 @ 1
usbcore: registered new interface driver cdc_ether
initcall cdc_init+0x0/0x15 returned 0 after 4425 usecs
calling  eem_init+0x0/0x15 @ 1
usbcore: registered new interface driver cdc_eem
initcall eem_init+0x0/0x15 returned 0 after 4264 usecs
calling  dm9601_init+0x0/0x15 @ 1
usbcore: registered new interface driver dm9601
initcall dm9601_init+0x0/0x15 returned 0 after 4178 usecs
calling  smsc95xx_init+0x0/0x15 @ 1
usbcore: registered new interface driver smsc95xx
initcall smsc95xx_init+0x0/0x15 returned 0 after 4342 usecs
calling  usbnet_init+0x0/0x15 @ 1
usbcore: registered new interface driver gl620a
initcall usbnet_init+0x0/0x15 returned 0 after 4182 usecs
calling  net1080_init+0x0/0x15 @ 1
usbcore: registered new interface driver net1080
initcall net1080_init+0x0/0x15 returned 0 after 4264 usecs
calling  plusb_init+0x0/0x15 @ 1
usbcore: registered new interface driver plusb
initcall plusb_init+0x0/0x15 returned 0 after 4094 usecs
calling  rndis_init+0x0/0x15 @ 1
usbcore: registered new interface driver rndis_host
initcall rndis_init+0x0/0x15 returned 0 after 4512 usecs
calling  usbnet_init+0x0/0x28 @ 1
initcall usbnet_init+0x0/0x28 returned 0 after 5 usecs
calling  int51x1_init+0x0/0x15 @ 1
usbcore: registered new interface driver int51x1
initcall int51x1_init+0x0/0x15 returned 0 after 4258 usecs
calling  sierra_net_init+0x0/0x15 @ 1
usbcore: registered new interface driver sierra_net
initcall sierra_net_init+0x0/0x15 returned 0 after 4518 usecs
calling  w840_init+0x0/0x25 @ 1
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
initcall w840_init+0x0/0x25 returned 0 after 10637 usecs
calling  de_init+0x0/0x15 @ 1
initcall de_init+0x0/0x15 returned 0 after 15 usecs
calling  tulip_init+0x0/0x2d @ 1
initcall tulip_init+0x0/0x2d returned 0 after 21 usecs
calling  de4x5_module_init+0x0/0x15 @ 1
initcall de4x5_module_init+0x0/0x15 returned 0 after 18 usecs
calling  uli526x_init_module+0x0/0x9a @ 1
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
initcall uli526x_init_module+0x0/0x9a returned 0 after 5448 usecs
calling  init_netconsole+0x0/0x1e3 @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1e3 returned 0 after 5467 usecs
calling  niu_init+0x0/0x37 @ 1
initcall niu_init+0x0/0x37 returned 0 after 15 usecs
calling  efx_init_module+0x0/0x8c @ 1
Solarflare NET driver v3.1
initcall efx_init_module+0x0/0x8c returned 0 after 2439 usecs
calling  caif_ser_init+0x0/0x46 @ 1
initcall caif_ser_init+0x0/0x46 returned 0 after 4 usecs
calling  cfspi_init_module+0x0/0x161 @ 1
initcall cfspi_init_module+0x0/0x161 returned 0 after 16 usecs
calling  nosy_init+0x0/0x15 @ 1
initcall nosy_init+0x0/0x15 returned 0 after 15 usecs
calling  uio_init+0x0/0xe6 @ 1
initcall uio_init+0x0/0xe6 returned 0 after 16 usecs
calling  uio_pdrv_genirq_init+0x0/0xc @ 1
initcall uio_pdrv_genirq_init+0x0/0xc returned 0 after 10 usecs
calling  aectc_init+0x0/0x15 @ 1
initcall aectc_init+0x0/0x15 returned 0 after 15 usecs
calling  aoe_init+0x0/0xa2 @ 1
aoe: AoE v47 initialised.
initcall aoe_init+0x0/0xa2 returned 0 after 2608 usecs
calling  uwb_subsys_init+0x0/0x47 @ 1
initcall uwb_subsys_init+0x0/0x47 returned 0 after 14 usecs
calling  umc_bus_init+0x0/0xc @ 1
initcall umc_bus_init+0x0/0xc returned 0 after 13 usecs
calling  whci_init+0x0/0x15 @ 1
initcall whci_init+0x0/0x15 returned 0 after 21 usecs
calling  whcrc_driver_init+0x0/0x15 @ 1
initcall whcrc_driver_init+0x0/0x15 returned 0 after 15 usecs
calling  hwarc_driver_init+0x0/0x15 @ 1
usbcore: registered new interface driver hwa-rc
initcall hwarc_driver_init+0x0/0x15 returned 0 after 4180 usecs
calling  ehci_hcd_init+0x0/0xe1 @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
ehci_hcd 0000:00:02.1: park 0
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
ehci_hcd 0000:00:02.1: cache line size of 32 is not supported
ehci_hcd 0000:00:02.1: supports USB remote wakeup
ehci_hcd 0000:00:02.1: irq 22, io mem 0x40000000
ehci_hcd 0000:00:02.1: reset command 0080b02  park=3 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:02.1: init command 0010005 (park)=0 ithresh=1 period=512 RUN
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: udev 1, busnum 1, minor = 0
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.38-tip-11308-g785c78f-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
initcall ehci_hcd_init+0x0/0xe1 returned 0 after 219699 usecs
calling  oxu_module_init+0x0/0xc @ 1
initcall oxu_module_init+0x0/0xc returned 0 after 12 usecs
calling  isp1362_init+0x0/0x3a @ 1
driver isp1362-hcd, 2005-04-04
initcall isp1362_init+0x0/0x3a returned 0 after 2733 usecs
calling  ohci_hcd_mod_init+0x0/0xd1 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: enabled nVidia shutdown quirk
ohci_hcd 0000:00:02.0: created debug files
ohci_hcd 0000:00:02.0: supports USB remote wakeup
hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
ohci_hcd 0000:00:02.0: irq 21, io mem 0xda102000
ohci_hcd 0000:00:02.0: OHCI controller state
ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
ohci_hcd 0000:00:02.0: hcca frame #0020
ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
usb usb2: default language 0x0409
usb usb2: udev 1, busnum 2, minor = 128
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.38-tip-11308-g785c78f-dirty ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:02.1: HS companion for 0000:00:02.0
initcall ohci_hcd_mod_init+0x0/0xd1 returned 0 after 311948 usecs
calling  uhci_hcd_init+0x0/0x104 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
initcall uhci_hcd_init+0x0/0x104 returned 0 after 4961 usecs
calling  hwahc_driver_init+0x0/0x15 @ 1
usbcore: registered new interface driver hwa-hc
initcall hwahc_driver_init+0x0/0x15 returned 0 after 4180 usecs
calling  wusbcore_init+0x0/0x6e @ 1
initcall wusbcore_init+0x0/0x6e returned 0 after 31 usecs
calling  acm_init+0x0/0xf2 @ 1
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
initcall acm_init+0x0/0xf2 returned 0 after 11332 usecs
calling  usblp_init+0x0/0x15 @ 1
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x15 returned 0 after 4096 usecs
calling  wdm_init+0x0/0x15 @ 1
usbcore: registered new interface driver cdc_wdm
initcall wdm_init+0x0/0x15 returned 0 after 4273 usecs
calling  usb_stor_init+0x0/0x46 @ 1
Initializing USB Mass Storage driver...
hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall usb_stor_init+0x0/0x46 returned 0 after 3535 usecs
calling  usb_usual_init+0x0/0x3e @ 1
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x3e returned 0 after 19 usecs
calling  cypress_init+0x0/0x15 @ 1
usbcore: registered new interface driver ums-cypress
initcall cypress_init+0x0/0x15 returned 0 after 16 usecs
calling  datafab_init+0x0/0x15 @ 1
usbcore: registered new interface driver ums-datafab
initcall datafab_init+0x0/0x15 returned 0 after 13 usecs
calling  ene_ub6250_init+0x0/0x15 @ 1
usbcore: registered new interface driver ums_eneub6250
initcall ene_ub6250_init+0x0/0x15 returned 0 after 13 usecs
calling  freecom_init+0x0/0x15 @ 1
usbcore: registered new interface driver ums-freecom
initcall freecom_init+0x0/0x15 returned 0 after 13 usecs
calling  isd200_init+0x0/0x15 @ 1
usbcore: registered new interface driver ums-isd200
initcall isd200_init+0x0/0x15 returned 0 after 15 usecs
calling  onetouch_init+0x0/0x15 @ 1
usbcore: registered new interface driver ums-onetouch
initcall onetouch_init+0x0/0x15 returned 0 after 13 usecs
calling  sddr09_init+0x0/0x15 @ 1
usbcore: registered new interface driver ums-sddr09
initcall sddr09_init+0x0/0x15 returned 0 after 15 usecs
calling  usbat_init+0x0/0x15 @ 1
usbcore: registered new interface driver ums-usbat
initcall usbat_init+0x0/0x15 returned 0 after 13 usecs
calling  usb_mdc800_init+0x0/0x287 @ 1
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
initcall usb_mdc800_init+0x0/0x287 returned 0 after 15 usecs
calling  microtek_drv_init+0x0/0x15 @ 1
usbcore: registered new interface driver microtekX6
initcall microtek_drv_init+0x0/0x15 returned 0 after 12 usecs
calling  usb_serial_init+0x0/0x1da @ 1
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
initcall usb_serial_init+0x0/0x1da returned 0 after 60 usecs
calling  aircable_init+0x0/0x46 @ 1
USB Serial support registered for aircable
usbcore: registered new interface driver aircable
initcall aircable_init+0x0/0x46 returned 0 after 21 usecs
calling  belkin_sa_init+0x0/0x4e @ 1
USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
usbcore: registered new interface driver belkin
belkin_sa: v1.3:USB Belkin Serial converter driver
initcall belkin_sa_init+0x0/0x4e returned 0 after 23 usecs
calling  ch341_init+0x0/0x46 @ 1
USB Serial support registered for ch341-uart
usbcore: registered new interface driver ch341
initcall ch341_init+0x0/0x46 returned 0 after 21 usecs
calling  cp210x_init+0x0/0x4e @ 1
USB Serial support registered for cp210x
usbcore: registered new interface driver cp210x
cp210x: v0.09:Silicon Labs CP210x RS232 serial adaptor driver
initcall cp210x_init+0x0/0x4e returned 0 after 24 usecs
calling  cyberjack_init+0x0/0x5c @ 1
USB Serial support registered for Reiner SCT Cyberjack USB card reader
usbcore: registered new interface driver cyberjack
cyberjack: v1.01 Matthias Bruestle
cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
initcall cyberjack_init+0x0/0x5c returned 0 after 26 usecs
calling  digi_init+0x0/0x6c @ 1
USB Serial support registered for Digi 2 port USB adapter
USB Serial support registered for Digi 4 port USB adapter
usbcore: registered new interface driver digi_acceleport
digi_acceleport: v1.80.1.2:Digi AccelePort USB-2/USB-4 Serial Converter driver
initcall digi_init+0x0/0x6c returned 0 after 34 usecs
calling  edgeport_init+0x0/0xb6 @ 1
USB Serial support registered for Edgeport 2 port adapter
USB Serial support registered for Edgeport 4 port adapter
USB Serial support registered for Edgeport 8 port adapter
USB Serial support registered for EPiC device
usbcore: registered new interface driver io_edgeport
io_edgeport: v2.7:Edgeport USB Serial Driver
initcall edgeport_init+0x0/0xb6 returned 0 after 51 usecs
calling  ftdi_init+0x0/0xc7 @ 1
USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.6.0:USB FTDI Serial Converters Driver
initcall ftdi_init+0x0/0xc7 returned 0 after 39 usecs
calling  funsoft_init+0x0/0x46 @ 1
USB Serial support registered for funsoft
usbcore: registered new interface driver funsoft
initcall funsoft_init+0x0/0x46 returned 0 after 21 usecs
calling  hp49gp_init+0x0/0x4e @ 1
USB Serial support registered for hp4X
usbcore: registered new interface driver hp4X
hp4x: v1.00:HP4x (48/49) Generic Serial driver
initcall hp49gp_init+0x0/0x4e returned 0 after 22 usecs
calling  usb_ipw_init+0x0/0x4e @ 1
USB Serial support registered for IPWireless converter
usbcore: registered new interface driver ipwtty
ipw: v0.4:IPWireless tty driver
initcall usb_ipw_init+0x0/0x4e returned 0 after 22 usecs
calling  iuu_init+0x0/0x4e @ 1
USB Serial support registered for iuu_phoenix
usbcore: registered new interface driver iuu_phoenix
iuu_phoenix: v0.12:Infinity USB Unlimited Phoenix driver
initcall iuu_init+0x0/0x4e returned 0 after 23 usecs
calling  klsi_105_init+0x0/0x4e @ 1
USB Serial support registered for KL5KUSB105D / PalmConnect
usbcore: registered new interface driver kl5kusb105d
kl5kusb105: v0.4:KLSI KL5KUSB105 chipset USB->Serial Converter driver
initcall klsi_105_init+0x0/0x4e returned 0 after 25 usecs
calling  kobil_init+0x0/0x4e @ 1
USB Serial support registered for KOBIL USB smart card terminal
usbcore: registered new interface driver kobil
kobil_sct: 21/05/2004:KOBIL USB Smart Card Terminal Driver (experimental)
initcall kobil_init+0x0/0x4e returned 0 after 25 usecs
calling  mct_u232_init+0x0/0x4e @ 1
USB Serial support registered for MCT U232
usbcore: registered new interface driver mct_u232
mct_u232: z2.1:Magic Control Technology USB-RS232 converter driver
initcall mct_u232_init+0x0/0x4e returned 0 after 23 usecs
calling  navman_init+0x0/0x46 @ 1
USB Serial support registered for navman
usbcore: registered new interface driver navman
initcall navman_init+0x0/0x46 returned 0 after 21 usecs
calling  qcaux_init+0x0/0x46 @ 1
USB Serial support registered for qcaux
usbcore: registered new interface driver qcaux
initcall qcaux_init+0x0/0x46 returned 0 after 21 usecs
calling  samba_init+0x0/0x4e @ 1
USB Serial support registered for sam-ba
usbcore: registered new interface driver sam-ba
sam_ba: v1.0: Atmel SAM Boot Assistant (SAM-BA) driver
initcall samba_init+0x0/0x4e returned 0 after 25 usecs
calling  spcp8x5_init+0x0/0x4e @ 1
USB Serial support registered for SPCP8x5
usbcore: registered new interface driver spcp8x5
spcp8x5: v0.10:SPCP8x5 USB to serial adaptor driver
initcall spcp8x5_init+0x0/0x4e returned 0 after 23 usecs
calling  ssu100_init+0x0/0x73 @ 1
USB Serial support registered for Quatech SSU-100 USB to Serial Driver
usbcore: registered new interface driver ssu100
ssu100: v0.1:Quatech SSU-100 USB to Serial Driver
initcall ssu100_init+0x0/0x73 returned 0 after 23 usecs
calling  visor_init+0x0/0x1c5 @ 1
USB Serial support registered for Handspring Visor / Palm OS
USB Serial support registered for Sony Clie 3.5
USB Serial support registered for Sony Clie 5.0
usbcore: registered new interface driver visor
visor: USB HandSpring Visor / Palm OS driver
initcall visor_init+0x0/0x1c5 returned 0 after 42 usecs
calling  zio_init+0x0/0x46 @ 1
USB Serial support registered for zio
usbcore: registered new interface driver zio
initcall zio_init+0x0/0x46 returned 0 after 24 usecs
calling  emi26_init+0x0/0x15 @ 1
usbcore: registered new interface driver emi26 - firmware loader
initcall emi26_init+0x0/0x15 returned 0 after 13 usecs
calling  emi62_init+0x0/0x2e @ 1
usbcore: registered new interface driver emi62 - firmware loader
initcall emi62_init+0x0/0x2e returned 0 after 13 usecs
calling  ftdi_elan_init+0x0/0x158 @ 1
driver ftdi-elan built at 13:23:41 on Mar 29 2011
usbcore: registered new interface driver ftdi-elan
initcall ftdi_elan_init+0x0/0x158 returned 0 after 76 usecs
calling  iowarrior_init+0x0/0x15 @ 1
usbcore: registered new interface driver iowarrior
initcall iowarrior_init+0x0/0x15 returned 0 after 13 usecs
calling  usb_lcd_init+0x0/0x30 @ 1
usbcore: registered new interface driver usblcd
initcall usb_lcd_init+0x0/0x30 returned 0 after 13 usecs
calling  usb_led_init+0x0/0x30 @ 1
usbcore: registered new interface driver usbled
initcall usb_led_init+0x0/0x30 returned 0 after 13 usecs
calling  lego_usb_tower_init+0x0/0x96 @ 1
drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
usbcore: registered new interface driver legousbtower
legousbtower: v0.96:LEGO USB Tower Driver
drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
initcall lego_usb_tower_init+0x0/0x96 returned 0 after 17 usecs
calling  usb_rio_init+0x0/0x2e @ 1
usbcore: registered new interface driver rio500
rio500: v1.1:USB Rio 500 driver
initcall usb_rio_init+0x0/0x2e returned 0 after 13 usecs
calling  tv_init+0x0/0x40 @ 1
usbcore: registered new interface driver trancevibrator
trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
initcall tv_init+0x0/0x40 returned 0 after 17 usecs
calling  usb_yurex_init+0x0/0x30 @ 1
usbcore: registered new interface driver yurex
initcall usb_yurex_init+0x0/0x30 returned 0 after 13 usecs
calling  fusb300_udc_init+0x0/0x13 @ 1
initcall fusb300_udc_init+0x0/0x13 returned -19 after 23 usecs
calling  webcam_init+0x0/0x13 @ 1
initcall webcam_init+0x0/0x13 returned -19 after 2 usecs
calling  i8042_init+0x0/0x3b7 @ 1
i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
initcall i8042_init+0x0/0x3b7 returned 0 after 823 usecs
calling  serport_init+0x0/0x2a @ 1
initcall serport_init+0x0/0x2a returned 0 after 2 usecs
calling  pcips2_init+0x0/0x15 @ 1
initcall pcips2_init+0x0/0x15 returned 0 after 42 usecs
calling  altera_ps2_init+0x0/0xc @ 1
initcall altera_ps2_init+0x0/0xc returned 0 after 10 usecs
calling  emu_init+0x0/0x15 @ 1
initcall emu_init+0x0/0x15 returned 0 after 17 usecs
calling  fm801_gp_init+0x0/0x15 @ 1
initcall fm801_gp_init+0x0/0x15 returned 0 after 17 usecs
calling  l4_init+0x0/0x29d @ 1
initcall l4_init+0x0/0x29d returned -19 after 15 usecs
calling  mousedev_init+0x0/0x83 @ 1
mousedev: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x83 returned 0 after 183 usecs
calling  evdev_init+0x0/0xc @ 1
initcall evdev_init+0x0/0xc returned 0 after 94 usecs
calling  evbug_init+0x0/0xc @ 1
evbug: Connected device: input0 (Power Button at PNP0C0C/button/input0)
evbug: Connected device: input1 (Power Button at LNXPWRBN/button/input0)
initcall evbug_init+0x0/0xc returned 0 after 7 usecs
calling  adp5588_init+0x0/0xe @ 1
initcall adp5588_init+0x0/0xe returned 0 after 15 usecs
calling  atkbd_init+0x0/0x23 @ 1
initcall atkbd_init+0x0/0x23 returned 0 after 15 usecs
calling  mcs_touchkey_init+0x0/0xe @ 1
initcall mcs_touchkey_init+0x0/0xe returned 0 after 9 usecs
calling  nkbd_init+0x0/0x15 @ 1
initcall nkbd_init+0x0/0x15 returned 0 after 12 usecs
calling  opencores_kbd_init+0x0/0xc @ 1
initcall opencores_kbd_init+0x0/0xc returned 0 after 11 usecs
calling  adi_init+0x0/0x15 @ 1
initcall adi_init+0x0/0x15 returned 0 after 11 usecs
calling  as5011_init+0x0/0xe @ 1
initcall as5011_init+0x0/0xe returned 0 after 9 usecs
calling  gf2k_init+0x0/0x15 @ 1
initcall gf2k_init+0x0/0x15 returned 0 after 9 usecs
calling  grip_init+0x0/0x15 @ 1
initcall grip_init+0x0/0x15 returned 0 after 9 usecs
calling  grip_init+0x0/0x15 @ 1
initcall grip_init+0x0/0x15 returned 0 after 9 usecs
calling  twidjoy_init+0x0/0x15 @ 1
initcall twidjoy_init+0x0/0x15 returned 0 after 9 usecs
calling  zhenhua_init+0x0/0x15 @ 1
initcall zhenhua_init+0x0/0x15 returned 0 after 9 usecs
calling  aiptek_init+0x0/0x3c @ 1
usbcore: registered new interface driver aiptek
aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
initcall aiptek_init+0x0/0x3c returned 0 after 21 usecs
calling  hanwang_init+0x0/0x15 @ 1
usbcore: registered new interface driver hanwang
initcall hanwang_init+0x0/0x15 returned 0 after 15 usecs
calling  mxt_init+0x0/0xe @ 1
initcall mxt_init+0x0/0xe returned 0 after 10 usecs
calling  gunze_init+0x0/0x15 @ 1
initcall gunze_init+0x0/0x15 returned 0 after 9 usecs
calling  eeti_ts_init+0x0/0xe @ 1
initcall eeti_ts_init+0x0/0xe returned 0 after 9 usecs
calling  inexio_init+0x0/0x15 @ 1
initcall inexio_init+0x0/0x15 returned 0 after 9 usecs
calling  mcs5000_ts_init+0x0/0xe @ 1
initcall mcs5000_ts_init+0x0/0xe returned 0 after 11 usecs
calling  mk712_init+0x0/0x1b9 @ 1
mk712: device not present
initcall mk712_init+0x0/0x1b9 returned -19 after 5 usecs
calling  tr_init+0x0/0x15 @ 1
initcall tr_init+0x0/0x15 returned 0 after 9 usecs
calling  tsc2007_init+0x0/0xe @ 1
initcall tsc2007_init+0x0/0xe returned 0 after 9 usecs
calling  tps6507x_ts_init+0x0/0xc @ 1
initcall tps6507x_ts_init+0x0/0xc returned 0 after 10 usecs
calling  i2o_iop_init+0x0/0x4c @ 1
I2O subsystem v1.325
i2o: max drivers = 8
initcall i2o_iop_init+0x0/0x4c returned 0 after 147 usecs
calling  i2o_config_init+0x0/0x93 @ 1
I2O Configuration OSM v1.323
initcall i2o_config_init+0x0/0x93 returned 0 after 69 usecs
calling  i2o_bus_init+0x0/0x3a @ 1
I2O Bus Adapter OSM v1.317
initcall i2o_bus_init+0x0/0x3a returned 0 after 13 usecs
calling  i2o_block_init+0x0/0x116 @ 1
I2O Block Device OSM v1.325
initcall i2o_block_init+0x0/0x116 returned 0 after 134 usecs
calling  i2o_proc_init+0x0/0x181 @ 1
I2O ProcFS OSM v1.316
initcall i2o_proc_init+0x0/0x181 returned 0 after 19 usecs
calling  i2c_ali1535_init+0x0/0x15 @ 1
initcall i2c_ali1535_init+0x0/0x15 returned 0 after 22 usecs
calling  ali1563_init+0x0/0x15 @ 1
initcall ali1563_init+0x0/0x15 returned 0 after 19 usecs
calling  i2c_ali15x3_init+0x0/0x15 @ 1
initcall i2c_ali15x3_init+0x0/0x15 returned 0 after 15 usecs
calling  i2c_sch_init+0x0/0xc @ 1
initcall i2c_sch_init+0x0/0xc returned 0 after 13 usecs
calling  nforce2_init+0x0/0x15 @ 1
ohci_hcd 0000:00:02.0: auto-stop root hub
i2c i2c-0: Transaction failed (0x10)!
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
evbug: Connected device: input2 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
i2c i2c-0: Transaction failed (0x10)!
i2c i2c-0: Transaction failed (0x10)!
i2c i2c-0: Transaction failed (0x10)!
i2c i2c-0: Transaction failed (0x10)!
i2c i2c-0: Transaction failed (0x10)!
i2c i2c-0: Transaction failed (0x10)!
i2c i2c-0: nForce2 SMBus adapter at 0x4c00
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: Transaction failed (0x10)!
i2c i2c-1: nForce2 SMBus adapter at 0x4c40
initcall nforce2_init+0x0/0x15 returned 0 after 1582182 usecs
calling  i2c_piix4_init+0x0/0x15 @ 1
initcall i2c_piix4_init+0x0/0x15 returned 0 after 21 usecs
calling  i2c_sis5595_init+0x0/0x15 @ 1
initcall i2c_sis5595_init+0x0/0x15 returned 0 after 16 usecs
calling  i2c_vt586b_init+0x0/0x15 @ 1
initcall i2c_vt586b_init+0x0/0x15 returned 0 after 15 usecs
calling  i2c_vt596_init+0x0/0x15 @ 1
initcall i2c_vt596_init+0x0/0x15 returned 0 after 17 usecs
calling  intel_mid_i2c_init+0x0/0x15 @ 1
initcall intel_mid_i2c_init+0x0/0x15 returned 0 after 17 usecs
calling  i2c_adap_simtec_init+0x0/0xc @ 1
initcall i2c_adap_simtec_init+0x0/0xc returned 0 after 13 usecs
calling  xiic_i2c_init+0x0/0xc @ 1
initcall xiic_i2c_init+0x0/0xc returned 0 after 9 usecs
calling  diolan_u2c_init+0x0/0x15 @ 1
usbcore: registered new interface driver i2c-diolan-u2c
initcall diolan_u2c_init+0x0/0x15 returned 0 after 4875 usecs
calling  taos_init+0x0/0x15 @ 1
initcall taos_init+0x0/0x15 returned 0 after 22 usecs
calling  usb_i2c_tiny_usb_init+0x0/0x15 @ 1
usbcore: registered new interface driver i2c-tiny-usb
initcall usb_i2c_tiny_usb_init+0x0/0x15 returned 0 after 4697 usecs
calling  pca9541_init+0x0/0xe @ 1
initcall pca9541_init+0x0/0xe returned 0 after 17 usecs
calling  saa7146_vv_init_module+0x0/0x3 @ 1
initcall saa7146_vv_init_module+0x0/0x3 returned 0 after 1 usecs
calling  videodev_init+0x0/0x7f @ 1
Linux video capture interface: v2.00
initcall videodev_init+0x0/0x7f returned 0 after 3242 usecs
calling  init_tuner+0x0/0xe @ 1
i2c-core: driver [tuner] using legacy suspend method
i2c-core: driver [tuner] using legacy resume method
initcall init_tuner+0x0/0xe returned 0 after 9107 usecs
calling  init_tda9840+0x0/0xe @ 1
initcall init_tda9840+0x0/0xe returned 0 after 11 usecs
calling  init_tea6415c+0x0/0xe @ 1
initcall init_tea6415c+0x0/0xe returned 0 after 12 usecs
calling  init_tea6420+0x0/0xe @ 1
initcall init_tea6420+0x0/0xe returned 0 after 11 usecs
calling  init_saa711x+0x0/0xe @ 1
initcall init_saa711x+0x0/0xe returned 0 after 10 usecs
calling  init_adv7170+0x0/0xe @ 1
initcall init_adv7170+0x0/0xe returned 0 after 11 usecs
calling  init_adv7175+0x0/0xe @ 1
initcall init_adv7175+0x0/0xe returned 0 after 11 usecs
calling  adv7180_init+0x0/0xe @ 1
initcall adv7180_init+0x0/0xe returned 0 after 10 usecs
calling  init_vpx3220+0x0/0xe @ 1
initcall init_vpx3220+0x0/0xe returned 0 after 11 usecs
calling  init_bt819+0x0/0xe @ 1
initcall init_bt819+0x0/0xe returned 0 after 13 usecs
calling  init_bt856+0x0/0xe @ 1
initcall init_bt856+0x0/0xe returned 0 after 11 usecs
calling  init_bt866+0x0/0xe @ 1
initcall init_bt866+0x0/0xe returned 0 after 11 usecs
calling  init_ks0127+0x0/0xe @ 1
initcall init_ks0127+0x0/0xe returned 0 after 10 usecs
calling  sr030pc30_init+0x0/0xe @ 1
initcall sr030pc30_init+0x0/0xe returned 0 after 11 usecs
calling  noon010_init+0x0/0xe @ 1
initcall noon010_init+0x0/0xe returned 0 after 11 usecs
calling  zoran_init+0x0/0x161 @ 1
Zoran MJPEG board driver version 0.10.0
initcall zoran_init+0x0/0x161 returned 0 after 3503 usecs
calling  videocodec_init+0x0/0x56 @ 1
Linux video codec intermediate layer: v0.2
initcall videocodec_init+0x0/0x56 returned 0 after 3749 usecs
calling  zr36050_init_module+0x0/0x16 @ 1
initcall zr36050_init_module+0x0/0x16 returned 0 after 1 usecs
calling  zr36016_init_module+0x0/0x16 @ 1
initcall zr36016_init_module+0x0/0x16 returned 0 after 1 usecs
calling  zr36060_init_module+0x0/0x16 @ 1
initcall zr36060_init_module+0x0/0x16 returned 0 after 1 usecs
calling  cpia2_init+0x0/0x168 @ 1
cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.0
usbcore: registered new interface driver cpia2
initcall cpia2_init+0x0/0x168 returned 0 after 8939 usecs
calling  mxb_init_module+0x0/0x4f @ 1
saa7146: register extension 'Multimedia eXtension Board'.
initcall mxb_init_module+0x0/0x4f returned 0 after 5026 usecs
calling  timblogiw_init+0x0/0xc @ 1
initcall timblogiw_init+0x0/0xc returned 0 after 10 usecs
calling  sn9c102_module_init+0x0/0x84 @ 1
sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers v1:1.47pre49
usbcore: registered new interface driver sn9c102
initcall sn9c102_module_init+0x0/0x84 returned 0 after 10121 usecs
calling  gspca_init+0x0/0x1f @ 1
gspca: v2.12.0 registered
initcall gspca_init+0x0/0x1f returned 0 after 2301 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver benq
initcall sd_mod_init+0x0/0x15 returned 0 after 4012 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver etoms
initcall sd_mod_init+0x0/0x15 returned 0 after 4105 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver jeilinj
initcall sd_mod_init+0x0/0x15 returned 0 after 4275 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver konica
initcall sd_mod_init+0x0/0x15 returned 0 after 4181 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver pac207
initcall sd_mod_init+0x0/0x15 returned 0 after 4180 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver pac7302
initcall sd_mod_init+0x0/0x15 returned 0 after 4275 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver pac7311
initcall sd_mod_init+0x0/0x15 returned 0 after 4273 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver sn9c20x
initcall sd_mod_init+0x0/0x15 returned 0 after 4266 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver sonixb
initcall sd_mod_init+0x0/0x15 returned 0 after 4179 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver sonixj
initcall sd_mod_init+0x0/0x15 returned 0 after 4191 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver spca501
initcall sd_mod_init+0x0/0x15 returned 0 after 4276 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver spca505
initcall sd_mod_init+0x0/0x15 returned 0 after 4266 usecs
calling  sd_mod_init+0x0/0x39 @ 1
usbcore: registered new interface driver spca506
spca506: registered
initcall sd_mod_init+0x0/0x39 returned 0 after 6069 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver spca508
initcall sd_mod_init+0x0/0x15 returned 0 after 4275 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver sq905c
initcall sd_mod_init+0x0/0x15 returned 0 after 4180 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver sunplus
initcall sd_mod_init+0x0/0x15 returned 0 after 4265 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver stk014
initcall sd_mod_init+0x0/0x15 returned 0 after 4191 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver stv0680
initcall sd_mod_init+0x0/0x15 returned 0 after 4272 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver tv8532
initcall sd_mod_init+0x0/0x15 returned 0 after 4182 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver xirlink-cit
initcall sd_mod_init+0x0/0x15 returned 0 after 4605 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver zc3xx
initcall sd_mod_init+0x0/0x15 returned 0 after 4108 usecs
calling  mod_m5602_init+0x0/0x15 @ 1
usbcore: registered new interface driver ALi m5602
initcall mod_m5602_init+0x0/0x15 returned 0 after 4445 usecs
calling  sd_mod_init+0x0/0x15 @ 1
usbcore: registered new interface driver STV06xx
initcall sd_mod_init+0x0/0x15 returned 0 after 4263 usecs
calling  sd_mod_init+0x0/0x39 @ 1
gspca_gl860: driver startup - version 0.9d10
usbcore: registered new interface driver gspca_gl860
initcall sd_mod_init+0x0/0x39 returned 0 after 8524 usecs
calling  usb_s2255_init+0x0/0x4e @ 1
usbcore: registered new interface driver s2255
initcall usb_s2255_init+0x0/0x4e returned 0 after 4095 usecs
calling  pps_ktimer_init+0x0/0x8e @ 1
pps_core: source ktimer got cdev (254:0)
pps pps0: new PPS source ktimer
pps pps0: ktimer PPS source registered
initcall pps_ktimer_init+0x0/0x8e returned 0 after 9902 usecs
calling  pps_tty_init+0x0/0x9a @ 1
pps_ldisc: PPS line discipline registered
initcall pps_tty_init+0x0/0x9a returned 0 after 3655 usecs
calling  w1_init+0x0/0x9a @ 1
Driver for 1-wire Dallas network protocol.
initcall w1_init+0x0/0x9a returned 0 after 3777 usecs
calling  matrox_w1_init+0x0/0x15 @ 1
initcall matrox_w1_init+0x0/0x15 returned 0 after 20 usecs
calling  ds_init+0x0/0x30 @ 1
usbcore: registered new interface driver DS9490R
initcall ds_init+0x0/0x30 returned 0 after 4273 usecs
calling  w1_therm_init+0x0/0x28 @ 1
initcall w1_therm_init+0x0/0x28 returned 0 after 2 usecs
calling  w1_f2d_init+0x0/0xc @ 1
initcall w1_f2d_init+0x0/0xc returned 0 after 1 usecs
calling  w1_ds2760_init+0x0/0x28 @ 1
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
initcall w1_ds2760_init+0x0/0x28 returned 0 after 7303 usecs
calling  w1_bq27000_init+0x0/0x1c @ 1
initcall w1_bq27000_init+0x0/0x1c returned 0 after 1 usecs
calling  pda_power_init+0x0/0xc @ 1
initcall pda_power_init+0x0/0xc returned 0 after 12 usecs
calling  ds278x_init+0x0/0xe @ 1
initcall ds278x_init+0x0/0xe returned 0 after 15 usecs
calling  max17042_init+0x0/0xe @ 1
initcall max17042_init+0x0/0xe returned 0 after 12 usecs
calling  telephony_init+0x0/0x50 @ 1
Linux telephony interface: v1.00
initcall telephony_init+0x0/0x50 returned 0 after 2897 usecs
calling  isdn_init+0x0/0x2d9 @ 1
ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/none/none/1.1.2.2
initcall isdn_init+0x0/0x2d9 returned 0 after 5559 usecs
calling  cpufreq_gov_powersave_init+0x0/0xc @ 1
initcall cpufreq_gov_powersave_init+0x0/0xc returned 0 after 2 usecs
calling  cpufreq_gov_userspace_init+0x0/0xc @ 1
initcall cpufreq_gov_userspace_init+0x0/0xc returned 0 after 1 usecs
calling  td_init+0x0/0xc @ 1
initcall td_init+0x0/0xc returned 0 after 15 usecs
calling  ib_core_init+0x0/0x6c @ 1
initcall ib_core_init+0x0/0x6c returned 0 after 19 usecs
calling  ib_mad_init_module+0x0/0xcc @ 1
initcall ib_mad_init_module+0x0/0xcc returned 0 after 81 usecs
calling  ib_sa_init+0x0/0x5d @ 1
initcall ib_sa_init+0x0/0x5d returned 0 after 38 usecs
calling  ib_cm_init+0x0/0xfa @ 1
initcall ib_cm_init+0x0/0xfa returned 0 after 71 usecs
calling  iw_cm_init+0x0/0x2e @ 1
initcall iw_cm_init+0x0/0x2e returned 0 after 24 usecs
calling  addr_init+0x0/0x3f @ 1
initcall addr_init+0x0/0x3f returned 0 after 24 usecs
calling  cma_init+0x0/0x97 @ 1
initcall cma_init+0x0/0x97 returned 0 after 28 usecs
calling  ib_uverbs_init+0x0/0xc1 @ 1
initcall ib_uverbs_init+0x0/0xc1 returned 0 after 12 usecs
calling  ib_ucm_init+0x0/0x9c @ 1
initcall ib_ucm_init+0x0/0x9c returned 0 after 2 usecs
calling  ucma_init+0x0/0x8f @ 1
initcall ucma_init+0x0/0x8f returned 0 after 82 usecs
calling  mlx4_ib_init+0x0/0x4f @ 1
initcall mlx4_ib_init+0x0/0x4f returned 0 after 27 usecs
calling  ipoib_init_module+0x0/0x103 @ 1
initcall ipoib_init_module+0x0/0x103 returned 0 after 32 usecs
calling  iser_init+0x0/0x11d @ 1
iscsi: registered transport (iser)
initcall iser_init+0x0/0x11d returned 0 after 3115 usecs
calling  dcdrbu_init+0x0/0x151 @ 1
initcall dcdrbu_init+0x0/0x151 returned 0 after 28 usecs
calling  hid_init+0x0/0x5c @ 1
initcall hid_init+0x0/0x5c returned 0 after 36 usecs
calling  usb_mouse_init+0x0/0x2e @ 1
usbcore: registered new interface driver usbmouse
usbmouse: v1.6:USB HID Boot Protocol mouse driver
initcall usb_mouse_init+0x0/0x2e returned 0 after 8710 usecs
calling  cmpc_init+0x0/0x88 @ 1
initcall cmpc_init+0x0/0x88 returned 0 after 99 usecs
calling  dell_wmi_init+0x0/0x1b1 @ 1
dell-wmi: No known WMI GUID found
initcall dell_wmi_init+0x0/0x1b1 returned -19 after 2987 usecs
calling  dell_wmi_aio_init+0x0/0xfe @ 1
dell_wmi_aio: No known WMI GUID found
initcall dell_wmi_aio_init+0x0/0xfe returned -6 after 3324 usecs
initcall dell_wmi_aio_init+0x0/0xfe returned with error code -6 
calling  hdaps_init+0x0/0x1f9 @ 1
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
initcall hdaps_init+0x0/0x1f9 returned -19 after 6322 usecs
calling  fujitsu_init+0x0/0x25b @ 1
fujitsu-laptop: driver 0.6.0 successfully loaded.
initcall fujitsu_init+0x0/0x25b returned 0 after 4427 usecs
calling  acpi_pcc_init+0x0/0x23 @ 1
initcall acpi_pcc_init+0x0/0x23 returned 0 after 24 usecs
calling  msi_wmi_init+0x0/0x179 @ 1
This machine doesn't have MSI-hotkeys through WMI
initcall msi_wmi_init+0x0/0x179 returned -19 after 4332 usecs
calling  asus_acpi_init+0x0/0xf1 @ 1
initcall asus_acpi_init+0x0/0xf1 returned -19 after 33 usecs
calling  ips_init+0x0/0x15 @ 1
initcall ips_init+0x0/0x15 returned 0 after 34 usecs
calling  xo15_ebook_init+0x0/0xc @ 1
initcall xo15_ebook_init+0x0/0xc returned 0 after 23 usecs
calling  flow_cache_init_global+0x0/0x120 @ 1
initcall flow_cache_init_global+0x0/0x120 returned 0 after 32 usecs
calling  pg_init+0x0/0x316 @ 1
pktgen: Packet Generator for packet performance testing. Version: 2.74
initcall pg_init+0x0/0x316 returned 0 after 6183 usecs
calling  llc_init+0x0/0x1d @ 1
initcall llc_init+0x0/0x1d returned 0 after 2 usecs
calling  llc2_init+0x0/0xc2 @ 1
NET: Registered protocol family 26
initcall llc2_init+0x0/0xc2 returned 0 after 3098 usecs
calling  snap_init+0x0/0x36 @ 1
initcall snap_init+0x0/0x36 returned 0 after 3 usecs
calling  rif_init+0x0/0x81 @ 1
initcall rif_init+0x0/0x81 returned 0 after 10 usecs
calling  blackhole_module_init+0x0/0xc @ 1
initcall blackhole_module_init+0x0/0xc returned 0 after 2 usecs
calling  police_init_module+0x0/0xc @ 1
initcall police_init_module+0x0/0xc returned 0 after 1 usecs
calling  mirred_init_module+0x0/0x2f @ 1
Mirror/redirect action on
initcall mirred_init_module+0x0/0x2f returned 0 after 2309 usecs
calling  nat_init_module+0x0/0xc @ 1
initcall nat_init_module+0x0/0xc returned 0 after 1 usecs
calling  pedit_init_module+0x0/0xc @ 1
initcall pedit_init_module+0x0/0xc returned 0 after 1 usecs
calling  simp_init_module+0x0/0x25 @ 1
Simple TC action Loaded
initcall simp_init_module+0x0/0x25 returned 0 after 2132 usecs
calling  cbq_module_init+0x0/0xc @ 1
initcall cbq_module_init+0x0/0xc returned 0 after 1 usecs
calling  htb_module_init+0x0/0xc @ 1
initcall htb_module_init+0x0/0xc returned 0 after 1 usecs
calling  gred_module_init+0x0/0xc @ 1
initcall gred_module_init+0x0/0xc returned 0 after 1 usecs
calling  dsmark_module_init+0x0/0xc @ 1
initcall dsmark_module_init+0x0/0xc returned 0 after 1 usecs
calling  sfb_module_init+0x0/0xc @ 1
initcall sfb_module_init+0x0/0xc returned 0 after 1 usecs
calling  sfq_module_init+0x0/0xc @ 1
initcall sfq_module_init+0x0/0xc returned 0 after 1 usecs
calling  atm_init+0x0/0xc @ 1
initcall atm_init+0x0/0xc returned 0 after 1 usecs
calling  choke_module_init+0x0/0xc @ 1
initcall choke_module_init+0x0/0xc returned 0 after 1 usecs
calling  init_fw+0x0/0xc @ 1
initcall init_fw+0x0/0xc returned 0 after 1 usecs
calling  init_tcindex+0x0/0xc @ 1
initcall init_tcindex+0x0/0xc returned 0 after 1 usecs
calling  init_rsvp+0x0/0xc @ 1
initcall init_rsvp+0x0/0xc returned 0 after 1 usecs
calling  init_basic+0x0/0xc @ 1
initcall init_basic+0x0/0xc returned 0 after 1 usecs
calling  cls_flow_init+0x0/0xc @ 1
initcall cls_flow_init+0x0/0xc returned 0 after 1 usecs
calling  nf_conntrack_standalone_init+0x0/0xc @ 1
nf_conntrack version 0.5.0 (7948 buckets, 31792 max)
initcall nf_conntrack_standalone_init+0x0/0xc returned 0 after 4786 usecs
calling  nf_conntrack_proto_dccp_init+0x0/0x65 @ 1
initcall nf_conntrack_proto_dccp_init+0x0/0x65 returned 0 after 54 usecs
calling  nf_ct_proto_gre_init+0x0/0x3d @ 1
initcall nf_ct_proto_gre_init+0x0/0x3d returned 0 after 2 usecs
calling  nf_conntrack_h323_init+0x0/0xe5 @ 1
initcall nf_conntrack_h323_init+0x0/0xe5 returned 0 after 3 usecs
calling  nf_conntrack_irc_init+0x0/0x16e @ 1
initcall nf_conntrack_irc_init+0x0/0x16e returned 0 after 3 usecs
calling  nf_conntrack_netbios_ns_init+0x0/0x18 @ 1
initcall nf_conntrack_netbios_ns_init+0x0/0x18 returned 0 after 1 usecs
calling  nf_conntrack_snmp_init+0x0/0x18 @ 1
initcall nf_conntrack_snmp_init+0x0/0x18 returned 0 after 1 usecs
calling  nf_conntrack_pptp_init+0x0/0x3d @ 1
initcall nf_conntrack_pptp_init+0x0/0x3d returned 0 after 1 usecs
calling  nf_conntrack_sip_init+0x0/0x1ee @ 1
initcall nf_conntrack_sip_init+0x0/0x1ee returned 0 after 2 usecs
calling  nf_conntrack_tftp_init+0x0/0x169 @ 1
initcall nf_conntrack_tftp_init+0x0/0x169 returned 0 after 2 usecs
calling  sysctl_ipv4_init+0x0/0x7d @ 1
initcall sysctl_ipv4_init+0x0/0x7d returned 0 after 380 usecs
calling  ah4_init+0x0/0x65 @ 1
initcall ah4_init+0x0/0x65 returned 0 after 2 usecs
calling  esp4_init+0x0/0x65 @ 1
initcall esp4_init+0x0/0x65 returned 0 after 1 usecs
calling  ipcomp4_init+0x0/0x65 @ 1
initcall ipcomp4_init+0x0/0x65 returned 0 after 1 usecs
calling  ipip_init+0x0/0x65 @ 1
initcall ipip_init+0x0/0x65 returned 0 after 2 usecs
calling  xfrm4_beet_init+0x0/0x11 @ 1
initcall xfrm4_beet_init+0x0/0x11 returned 0 after 1 usecs
calling  tunnel4_init+0x0/0x2f @ 1
initcall tunnel4_init+0x0/0x2f returned 0 after 1 usecs
calling  xfrm4_transport_init+0x0/0x11 @ 1
initcall xfrm4_transport_init+0x0/0x11 returned 0 after 1 usecs
calling  xfrm4_mode_tunnel_init+0x0/0x11 @ 1
initcall xfrm4_mode_tunnel_init+0x0/0x11 returned 0 after 1 usecs
calling  ipv4_netfilter_init+0x0/0xc @ 1
initcall ipv4_netfilter_init+0x0/0xc returned 0 after 2 usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x141 @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x141 returned 0 after 249 usecs
calling  nf_defrag_init+0x0/0x11 @ 1
initcall nf_defrag_init+0x0/0x11 returned 0 after 1 usecs
calling  ip_queue_init+0x0/0x130 @ 1
initcall ip_queue_init+0x0/0x130 returned 0 after 19 usecs
calling  inet_diag_init+0x0/0x6d @ 1
initcall inet_diag_init+0x0/0x6d returned 0 after 3 usecs
calling  tcp_diag_init+0x0/0xc @ 1
initcall tcp_diag_init+0x0/0xc returned 0 after 1 usecs
calling  cubictcp_register+0x0/0x64 @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x64 returned 0 after 1879 usecs
calling  xfrm_user_init+0x0/0x4b @ 1
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x4b returned 0 after 2899 usecs
calling  packet_init+0x0/0x3d @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x3d returned 0 after 3068 usecs
calling  br_init+0x0/0xab @ 1
Bridge firewalling registered
initcall br_init+0x0/0xab returned 0 after 2693 usecs
calling  ipx_init+0x0/0xf0 @ 1
NET: Registered protocol family 4
initcall ipx_init+0x0/0xf0 returned 0 after 23897 usecs
calling  x25_init+0x0/0x89 @ 1
NET: Registered protocol family 9
X.25 for Linux Version 0.2
initcall x25_init+0x0/0x89 returned 0 after 5408 usecs
calling  atm_clip_init+0x0/0xac @ 1
initcall atm_clip_init+0x0/0xac returned 0 after 21 usecs
calling  br2684_init+0x0/0x48 @ 1
initcall br2684_init+0x0/0x48 returned 0 after 2 usecs
calling  l2tp_init+0x0/0x2c @ 1
L2TP core driver, V2.0
initcall l2tp_init+0x0/0x2c returned 0 after 2056 usecs
pps pps0: PPS event at 1301443290.500016191
pps pps0: capture assert seq #1
calling  l2tp_nl_init+0x0/0x28 @ 1
L2TP netlink interface
initcall l2tp_nl_init+0x0/0x28 returned 0 after 2056 usecs
calling  sctp_init+0x0/0x72f @ 1
sctp: Hash tables configured (established 65536 bind 65536)
sctp: sctp_init_sock(sk: ffff88003cc30000)
initcall sctp_init+0x0/0x72f returned 0 after 10423 usecs
calling  rds_init+0x0/0xac @ 1
NET: Registered protocol family 21
initcall rds_init+0x0/0xac returned 0 after 3268 usecs
calling  caif_device_init+0x0/0x73 @ 1
initcall caif_device_init+0x0/0x73 returned 0 after 11 usecs
calling  caif_sktinit_module+0x0/0x164 @ 1
NET: Registered protocol family 37
initcall caif_sktinit_module+0x0/0x164 returned 0 after 3097 usecs
calling  dcbnl_init+0x0/0x44 @ 1
initcall dcbnl_init+0x0/0x44 returned 0 after 1 usecs
calling  af_ieee802154_init+0x0/0x7d @ 1
NET: Registered protocol family 36
initcall af_ieee802154_init+0x0/0x7d returned 0 after 3089 usecs
calling  rio_init_mports+0x0/0x58 @ 1
initcall rio_init_mports+0x0/0x58 returned 0 after 2 usecs
calling  hpet_insert_resource+0x0/0x1e @ 1
initcall hpet_insert_resource+0x0/0x1e returned 1 after 1 usecs
initcall hpet_insert_resource+0x0/0x1e returned with error code 1 
calling  update_mp_table+0x0/0x405 @ 1
initcall update_mp_table+0x0/0x405 returned 0 after 1 usecs
calling  lapic_insert_resource+0x0/0x3e @ 1
initcall lapic_insert_resource+0x0/0x3e returned 0 after 3 usecs
calling  io_apic_bug_finalize+0x0/0x16 @ 1
initcall io_apic_bug_finalize+0x0/0x16 returned 0 after 1 usecs
calling  check_early_ioremap_leak+0x0/0x4d @ 1
initcall check_early_ioremap_leak+0x0/0x4d returned 0 after 1 usecs
calling  pat_memtype_list_init+0x0/0x31 @ 1
initcall pat_memtype_list_init+0x0/0x31 returned 0 after 1 usecs
calling  init_oops_id+0x0/0x2e @ 1
initcall init_oops_id+0x0/0x2e returned 0 after 4 usecs
calling  printk_late_init+0x0/0x46 @ 1
initcall printk_late_init+0x0/0x46 returned 0 after 3 usecs
calling  pm_qos_power_init+0x0/0xc0 @ 1
initcall pm_qos_power_init+0x0/0xc0 returned 0 after 230 usecs
calling  taskstats_init+0x0/0x8e @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0x8e returned 0 after 2732 usecs
calling  max_swapfiles_check+0x0/0x3 @ 1
initcall max_swapfiles_check+0x0/0x3 returned 0 after 1 usecs
calling  set_recommended_min_free_kbytes+0x0/0x78 @ 1
initcall set_recommended_min_free_kbytes+0x0/0x78 returned 0 after 34 usecs
calling  init_ima+0x0/0x12 @ 1
IMA: No TPM chip found, activating TPM-bypass!
initcall init_ima+0x0/0x12 returned 0 after 4121 usecs
calling  random32_reseed+0x0/0xa2 @ 1
initcall random32_reseed+0x0/0xa2 returned 0 after 10 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x13 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x13 returned 0 after 3 usecs
calling  pci_sysfs_init+0x0/0x4e @ 1
initcall pci_sysfs_init+0x0/0x4e returned 0 after 253 usecs
calling  regulator_init_complete+0x0/0x125 @ 1
initcall regulator_init_complete+0x0/0x125 returned 0 after 2 usecs
calling  seqgen_init+0x0/0xc @ 1
initcall seqgen_init+0x0/0xc returned 0 after 13 usecs
calling  wl1273_core_init+0x0/0x27 @ 1
initcall wl1273_core_init+0x0/0x27 returned 0 after 23 usecs
calling  scsi_complete_async_scans+0x0/0x12a @ 1
initcall scsi_complete_async_scans+0x0/0x12a returned 0 after 1 usecs
calling  edd_init+0x0/0x269 @ 1
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
initcall edd_init+0x0/0x269 returned 0 after 4618 usecs
calling  memmap_init+0x0/0x31 @ 1
initcall memmap_init+0x0/0x31 returned 0 after 21 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x5a @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x5a returned 0 after 2 usecs
calling  tcp_congestion_default+0x0/0xc @ 1
initcall tcp_congestion_default+0x0/0xc returned 0 after 2 usecs
calling  ip_auto_config+0x0/0xcb3 @ 1
initcall ip_auto_config+0x0/0xcb3 returned 0 after 10 usecs
calling  initialize_hashrnd+0x0/0x16 @ 1
initcall initialize_hashrnd+0x0/0x16 returned 0 after 4 usecs
async_waiting @ 1
async_continuing @ 1 after 1 usec
EXT3-fs (sda6): recovery required on readonly filesystem
EXT3-fs (sda6): write access will be enabled during recovery
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda6): recovery complete
EXT3-fs (sda6): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
async_waiting @ 1
async_continuing @ 1 after 1 usec
Freeing unused kernel memory: 548k freed
pps pps0: PPS event at 1301443291.500017867
pps pps0: capture assert seq #2
pps pps0: PPS event at 1301443292.500018984
pps pps0: capture assert seq #3
udevd (168): /proc/168/oom_adj is deprecated, please use /proc/168/oom_score_adj instead.
pps pps0: PPS event at 1301436094.565830700
pps pps0: capture assert seq #4
pps pps0: PPS event at 1301436095.565818687

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.38 Kernel Configuration
# Tue Mar 29 14:34:57 2011
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
# CONFIG_KTIME_SCALAR is not set
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
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
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

#
# GCOV-based kernel profiling
#
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
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
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
CONFIG_MPSC=y
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
# CONFIG_X86_64_ACPI_NUMA is not set
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_IPMI=y
# CONFIG_ACPI_NUMA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
# CONFIG_CPU_FREQ_DEBUG is not set
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
# CONFIG_CPU_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
# CONFIG_RAPIDIO_CPS_GEN2 is not set
CONFIG_RAPIDIO_TSI500=y
CONFIG_RAPIDIO_DEBUG=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
CONFIG_NF_CONNTRACK_H323=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_SNMP=y
CONFIG_NF_CONNTRACK_PPTP=y
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NETFILTER_XTABLES is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=y
# CONFIG_IP_NF_IPTABLES is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_RDS=y
# CONFIG_RDS_RDMA is not set
# CONFIG_RDS_TCP is not set
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
# CONFIG_L2TP_IP is not set
# CONFIG_L2TP_ETH is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_INGRESS is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_ARCH_NO_SYSDEV_OPS=y
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_MISC_DEVICES=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_PCH_PHUB=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
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
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARASAN_CF is not set
CONFIG_PATA_ARTOP=y
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
CONFIG_PATA_CMD64X=y
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=y
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
# CONFIG_PATA_HPT3X3_DMA is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87415=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_OPTIDMA=y
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=y
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_SIL680=y
# CONFIG_PATA_SIS is not set
CONFIG_PATA_TOSHIBA=y
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_LEGACY=y
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

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
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM63XX_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_NET_ETHERNET=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_ETHOC=y
CONFIG_DNET=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
# CONFIG_DM9102 is not set
CONFIG_ULI526X=y
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_KSZ884X_PCI is not set
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_E100=y
CONFIG_FEALNX=y
CONFIG_NATSEMI=y
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=y
CONFIG_EPIC100=y
# CONFIG_SMSC9420 is not set
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=y
CONFIG_KS8842=y
CONFIG_KS8851_MLL=y
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
CONFIG_R8169=y
CONFIG_SIS190=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_QLA3XXX=y
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_JME=y
CONFIG_STMMAC_ETH=y
# CONFIG_STMMAC_DA is not set
CONFIG_STMMAC_DUAL_MAC=y
# CONFIG_PCH_GBE is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
CONFIG_CHELSIO_T4VF=y
CONFIG_ENIC=y
# CONFIG_IXGBE is not set
CONFIG_IXGB=y
# CONFIG_S2IO is not set
CONFIG_MYRI10GE=y
CONFIG_NIU=y
# CONFIG_MLX4_EN is not set
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
CONFIG_QLCNIC=y
CONFIG_QLGE=y
CONFIG_BNA=y
CONFIG_SFC=y
CONFIG_BE2NET=y
CONFIG_TR=y
CONFIG_IBMOL=y
CONFIG_3C359=y
CONFIG_TMS380TR=y
# CONFIG_TMSPCI is not set
# CONFIG_ABYSS is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
# CONFIG_USB_NET_CDC_NCM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_FMVJ18X=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_PCMCIA_NMCLAN=y
CONFIG_PCMCIA_SMC91C92=y
CONFIG_PCMCIA_XIRC2PS=y
CONFIG_PCMCIA_AXNET=y
CONFIG_PCMCIA_IBMTR=y
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
# CONFIG_WAN_ROUTER_DRIVERS is not set
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
# CONFIG_ATM_DRIVERS is not set
CONFIG_IEEE802154_DRIVERS=y
# CONFIG_IEEE802154_FAKEHARD is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
# CONFIG_RIONET is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_PPP is not set
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VMXNET3=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_PPP is not set
# CONFIG_ISDN_AUDIO is not set
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_PHONE=y
# CONFIG_PHONE_IXJ is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC2007=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_RAMOOPS=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_INTEL_MID=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y

#
# PPS generators support
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_TPS6105X=y
# CONFIG_TPS6507X is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_BQ24022=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8400 is not set
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y
# CONFIG_RC_CORE is not set
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DMA_CONTIG=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y

#
# Audio decoders
#
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#
CONFIG_VIDEO_ADV7170=y
CONFIG_VIDEO_ADV7175=y

#
# Video improvement chips
#
CONFIG_VIDEO_CPIA2=y
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
CONFIG_VIDEO_ZORAN_ZR36060=y
# CONFIG_VIDEO_ZORAN_BUZ is not set
# CONFIG_VIDEO_ZORAN_DC10 is not set
CONFIG_VIDEO_ZORAN_LML33=y
CONFIG_VIDEO_ZORAN_LML33R10=y
CONFIG_VIDEO_ZORAN_AVS6EYES=y
# CONFIG_VIDEO_SAA7134 is not set
CONFIG_VIDEO_MXB=y
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
CONFIG_VIDEO_TIMBERDALE=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_VIDEO_SR030PC30=y
CONFIG_VIDEO_NOON010PC30=y
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=y
CONFIG_USB_M5602=y
CONFIG_USB_STV06XX=y
CONFIG_USB_GL860=y
CONFIG_USB_GSPCA_BENQ=y
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_CPIA1 is not set
CONFIG_USB_GSPCA_ETOMS=y
# CONFIG_USB_GSPCA_FINEPIX is not set
CONFIG_USB_GSPCA_JEILINJ=y
CONFIG_USB_GSPCA_KONICA=y
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_MR97310A is not set
# CONFIG_USB_GSPCA_NW80X is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_OV534_9 is not set
CONFIG_USB_GSPCA_PAC207=y
CONFIG_USB_GSPCA_PAC7302=y
CONFIG_USB_GSPCA_PAC7311=y
# CONFIG_USB_GSPCA_SN9C2028 is not set
CONFIG_USB_GSPCA_SN9C20X=y
CONFIG_USB_GSPCA_SONIXB=y
CONFIG_USB_GSPCA_SONIXJ=y
# CONFIG_USB_GSPCA_SPCA500 is not set
CONFIG_USB_GSPCA_SPCA501=y
CONFIG_USB_GSPCA_SPCA505=y
CONFIG_USB_GSPCA_SPCA506=y
CONFIG_USB_GSPCA_SPCA508=y
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_SPCA1528 is not set
# CONFIG_USB_GSPCA_SQ905 is not set
CONFIG_USB_GSPCA_SQ905C=y
# CONFIG_USB_GSPCA_SQ930X is not set
CONFIG_USB_GSPCA_STK014=y
CONFIG_USB_GSPCA_STV0680=y
CONFIG_USB_GSPCA_SUNPLUS=y
# CONFIG_USB_GSPCA_T613 is not set
CONFIG_USB_GSPCA_TV8532=y
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_VICAM is not set
CONFIG_USB_GSPCA_XIRLINK_CIT=y
CONFIG_USB_GSPCA_ZC3XX=y
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_HDPVR is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_ET61X251 is not set
CONFIG_USB_SN9C102=y
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
CONFIG_USB_S2255=y
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# Special HID drivers
#
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=y
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y
# CONFIG_USB_UAS is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QCAUX=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_HP4X=y
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SAMBA=y
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
CONFIG_USB_SERIAL_ZIO=y
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
# CONFIG_USB_ATM is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
CONFIG_USB_GADGET_FUSB300=y
CONFIG_USB_FUSB300=y
# CONFIG_USB_GADGET_R8A66597 is not set
# CONFIG_USB_GADGET_PXA_U2O is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_CI13XXX_PCI is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LANGWELL is not set
# CONFIG_USB_GADGET_EG20T is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_USB_G_WEBCAM=y

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
CONFIG_NFC_DEVICES=y
CONFIG_PN544_NFC=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_QIB is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_MLX4_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
# CONFIG_INFINIBAND_SRP is not set
CONFIG_INFINIBAND_ISER=y
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_TIMB_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_SENSORS_HDAPS=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_ACPI_ASUS=y
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_SIGMA=y

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_LOGFS=y
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_LKDTM=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_SAMPLES=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_OPTIMIZE_INLINING=y

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
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
CONFIG_CRYPTO_CTS=y
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_XTS is not set
CONFIG_CRYPTO_FPU=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
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
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set

--AqsLC8rIMeq19msA--
