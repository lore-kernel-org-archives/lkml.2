Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab0GEI4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:56:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57317 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab0GEI43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:56:29 -0400
Date: Mon, 5 Jul 2010 10:55:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [regression] Crash in wb_clear_pending() (was: Linux 2.6.35-rc4)
Message-ID: <20100705085550.GA26775@elte.hu>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...] And filesystem writeback performance issues, etc. It's all good.

> Christoph Hellwig (11):
>       writeback: fix writeback completion notifications
>       writeback: queue work on stack in writeback_inodes_sb
>       writeback: enforce s_umount locking in writeback_inodes_sb
>       writeback: fix writeback_inodes_wb from writeback_inodes_sb
>       writeback: simplify wakeup_flusher_threads
>       writeback: simplify and split bdi_start_writeback
>       writeback: add missing requeue_io in writeback_inodes_wb
>       writeback: fix pin_sb_for_writeback

Hm, those writeback patches are not looking overly good here - the kernel 
crashes quite a lot during bootup:

BUG: unable to handle kernel paging request at 000000000528aa7e
IP: [<ffffffff8112d514>] wb_clear_pending+0x3b/0x66
PGD 0 
Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/class/net/eth0/broadcast
CPU 1 
Modules linked in:

Pid: 1637, comm: flush-8:0 Not tainted 2.6.35-rc4-tip-01075-g0c1880a-dirty #15306 A8N-E/System Product Name
RIP: 0010:[<ffffffff8112d514>]  [<ffffffff8112d514>] wb_clear_pending+0x3b/0x66
RSP: 0018:ffff88003b899d90  EFLAGS: 00010286
RAX: 000000000528aa7e RBX: ffff880038e3d5f8 RCX: ffff88003b952000
RDX: ffff88003dd8c468 RSI: ffff88003dd8c420 RDI: ffff88003dd8c408
RBP: ffff88003b899da0 R08: ffffffff825bf870 R09: 0000000000000000
R10: ffff88003b899cf0 R11: 0000000000000002 R12: ffff88003dd8c408
R13: 0000000000000000 R14: ffff880038e3d5f8 R15: ffff88003dd8c468
FS:  00007f2d706b36f0(0000) GS:ffff880003200000(0000) knlGS:00000000f77bb6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000528aa7e CR3: 0000000001d1e000 CR4: 00000000000006a0
DR0: ffffffff82ceebbc DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Process flush-8:0 (pid: 1637, threadinfo ffff88003b898000, task ffff88003b952000)
Stack:
 ffff88003dd8c3a8 0000000000000000 ffff88003b899e30 ffffffff8112d5d7
<0> ffffffff8112d5de ffffffff823ae2a0 0000000000000000 ffff88003b899de0
<0> 00000000000009c4 ffff88003b899fd8 000000000000000a 0000000000000000
Call Trace:
 [<ffffffff8112d5d7>] wb_do_writeback+0x98/0x1d7
 [<ffffffff8112d5de>] ? wb_do_writeback+0x9f/0x1d7
 [<ffffffff8112d755>] bdi_writeback_task+0x3f/0xfc
 [<ffffffff810809a7>] ? bit_waitqueue+0x17/0xa9
 [<ffffffff810ee2d0>] ? bdi_start_fn+0x0/0xda
 [<ffffffff810ee346>] bdi_start_fn+0x76/0xda
 [<ffffffff810ee2d0>] ? bdi_start_fn+0x0/0xda
 [<ffffffff810805e9>] kthread+0x7f/0x87
 [<ffffffff8102ac04>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105af79>] ? finish_task_switch+0x70/0xdc
 [<ffffffff818674c5>] ? _raw_spin_unlock_irq+0x4f/0x6c
 [<ffffffff81867994>] ? restore_args+0x0/0x30
 [<ffffffff8108056a>] ? kthread+0x0/0x87
 [<ffffffff8102ac00>] ? kernel_thread_helper+0x0/0x10
Code: ff 4e 28 0f 94 c0 84 c0 74 47 4c 8b 67 10 49 81 c4 10 02 00 00 4c 89 e7 e8 d5 92 73 00 48 8b 43 08 48 8b 13 4c 89 e7 48 89 42 08 <48> 89 10 48 b8 00 02 20 00 00 00 ad de 48 89 43 08 e8 4d a0 73 
RIP  [<ffffffff8112d514>] wb_clear_pending+0x3b/0x66

It appears to be a race of some sorts and is not reproducible consistently: it 
occurs with an about 2-10% likelyhood in my test runs and i've seen about ~5 
similar crashes so far. They appeared after you pulled those writeback 
patches. I had a long and successful testrun of 1000+ kernels with no crashes, 
shortly before those wb patches went upstream.

Given the small linear chance for the crash [i'd have to do a series of 100 
reboots per bisection point to be reasonably sure about goodness/badness] i'd 
rather not try to bisect it - but can try fix patches or can try specific 
reverts as well.

Config and full crashlog attached. (Note, the log is from 
tip-2.6.35-rc4-tip-01075-g0c1880a but the crash clearly came in from upstream, 
the patterns are consistent and nothing remotely related happened in -tip in 
that timeframe.)

Thanks,

	Ingo

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

Linux version 2.6.35-rc4-tip-01075-g0c1880a-dirty (mingo@sirius) (gcc version 4.4.4 20100514 (Red Hat 4.4.4-3) (GCC) ) #15306 SMP PREEMPT Mon Jul 5 11:03:43 CEST 2010
Command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
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
NX (Execute Disable) protection: active
DMI 2.3 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
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
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000f5680] f5680
init_memory_mapping: 0000000000000000-000000003fff0000
 0000000000 - 003fff0000 page 4k
kernel direct mapping tables up to 3fff0000 @ 100000-302000
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000003fff0000
Initmem setup node 0 0000000000000000-000000003fff0000
  NODE_DATA [0000000002e9e180 - 0000000002ecf17f]
 [ffffea0000000000-ffffea0000dfffff] PMD -> [ffff880003800000-ffff8800045fffff] on node 0
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
  DMA zone: 0 pages reserved
  DMA zone: 3927 pages, LIFO batch:0
  DMA32 zone: 3528 pages used for memmap
  DMA32 zone: 254504 pages, LIFO batch:31
SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 Version 17 at 0xFEC00000.
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 476 pages/cpu @ffff880003000000 s1920320 r8192 d21184 u2097152
early_res array is doubled to 64 at [12000 - 127ff]
pcpu-alloc: s1920320 r8192 d21184 u2097152 alloc=1*2097152
pcpu-alloc: [0] 0 [0] 1 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 258431
Policy zone: DMA32
Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
sysrq: sysrq always enabled.
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
Subtract (39 early reservations)
  #1 [0001000000 - 0002e9d9f8]   TEXT DATA BSS
  #2 [0002e9e000 - 0002e9e149]             BRK
  #3 [00000f5690 - 0000100000]   BIOS reserved
  #4 [00000f5680 - 00000f5690]    MP-table mpf
  #5 [000009f800 - 00000f1400]   BIOS reserved
  #6 [00000f152c - 00000f5680]   BIOS reserved
  #7 [00000f1400 - 00000f152c]    MP-table mpc
  #8 [0000010000 - 0000012000]      TRAMPOLINE
  #9 [0000100000 - 0000300000]         PGTABLE
  #10 [0002e9e180 - 0002ecf180]       NODE_DATA
  #11 [0002ecf180 - 0002ed0180]         BOOTMEM
  #12 [0002e9da00 - 0002e9dac0]         BOOTMEM
  #13 [00036d1000 - 00036d2000]         BOOTMEM
  #14 [00036d2000 - 00036d3000]         BOOTMEM
  #15 [0003800000 - 0004600000]        MEMMAP 0
  #16 [0002e9dac0 - 0002e9dfc0]         BOOTMEM
  #17 [0002ed0180 - 0002ee4180]         BOOTMEM
  #18 [0002ee5000 - 0002ee6000]         BOOTMEM
  #19 [0002ee4180 - 0002ee41c3]         BOOTMEM
  #20 [0002ee4200 - 0002ee43f8]         BOOTMEM
  #21 [0002ee4400 - 0002ee449a]         BOOTMEM
  #22 [0002ee44c0 - 0002ee455a]         BOOTMEM
  #23 [0003000000 - 00031dc000]         BOOTMEM
  #24 [0003200000 - 00033dc000]         BOOTMEM
  #25 [0002e9dfc0 - 0002e9dfc8]         BOOTMEM
  #26 [0002ee4580 - 0002ee4588]         BOOTMEM
  #27 [0002ee45c0 - 0002ee45c8]         BOOTMEM
  #28 [0002ee4600 - 0002ee4610]         BOOTMEM
  #29 [0002ee4640 - 0002ee4790]         BOOTMEM
  #30 [0002ee47c0 - 0002ee4840]         BOOTMEM
  #31 [0002ee4840 - 0002ee48c0]         BOOTMEM
  #32 [0002ee48c0 - 0002ee4ac0]         BOOTMEM
  #33 [0002ee4ac0 - 0002ee4cc0]         BOOTMEM
  #34 [0002ee4cc0 - 0002ee4ec0]         BOOTMEM
  #35 [0002ee6000 - 0002ee6200]         BOOTMEM
  #36 [0002ee6200 - 0002ee6400]         BOOTMEM
  #37 [0002ee6400 - 0002eee400]         BOOTMEM
  #38 [0020000000 - 0024000000]         BOOTMEM
Memory: 930640k/1048512k available (8617k kernel code, 452k absent, 117420k reserved, 6187k data, 3996k init)
Hierarchical RCU implementation.
	Hierarchical RCU autobalancing is disabled.
	RCU-based detection of stalled CPUs is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:262400 nr_irqs:512
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [ttyS0] enabled, bootconsole disabled
console [ttyS0] enabled, bootconsole disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6367 kB
 per task-struct memory footprint: 2688 bytes
ODEBUG: 8 of 8 active objects replaced
ODEBUG: selftest passed
Fast TSC calibration using PIT
Detected 2010.594 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4021.18 BogoMIPS (lpj=8042376)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
debug: unmapping init memory ffffffff8225e000..ffffffff82265000
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 29917 entries in 118 pages
Setting APIC routing to flat
ExtINT not setup in hardware but reported by MP table
  alloc irq_desc for 27 on node 0
  alloc kstat_irqs on node 0
  alloc irq_desc for 29 on node 0
  alloc kstat_irqs on node 0
  alloc irq_desc for 35 on node 0
  alloc kstat_irqs on node 0
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
calling  register_trigger_all_cpu_backtrace+0x0/0x14 @ 1
initcall register_trigger_all_cpu_backtrace+0x0/0x14 returned 0 after 0 usecs
calling  migration_init+0x0/0x6d @ 1
initcall migration_init+0x0/0x6d returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x52 @ 1
initcall spawn_ksoftirqd+0x0/0x52 returned 0 after 3906 usecs
calling  init_call_single_data+0x0/0xac @ 1
initcall init_call_single_data+0x0/0xac returned 0 after 0 usecs
calling  cpu_stop_init+0x0/0xca @ 1
initcall cpu_stop_init+0x0/0xca returned 0 after 0 usecs
calling  spawn_watchdog_task+0x0/0x7f @ 1
NMI watchdog enabled, takes one hw-pmu counter.
initcall spawn_watchdog_task+0x0/0x7f returned 0 after 7812 usecs
calling  relay_init+0x0/0x8 @ 1
initcall relay_init+0x0/0x8 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x26c @ 1
Testing tracer nop: PASSED
initcall tracer_alloc_buffers+0x0/0x26c returned 0 after 3906 usecs
calling  init_trace_printk+0x0/0x12 @ 1
initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
calling  trace_workqueue_early_init+0x0/0x145 @ 1
initcall trace_workqueue_early_init+0x0/0x145 returned 0 after 0 usecs
lockdep: fixing up alternatives.
Booting Node   0, Processors  #1 Ok.
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 2 CPUs
Total of 2 processors activated (8042.05 BogoMIPS).
calling  init_mmap_min_addr+0x0/0x16 @ 1
initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
calling  net_ns_init+0x0/0xfb @ 1
initcall net_ns_init+0x0/0xfb returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x28 @ 1
initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x14 @ 1
initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x3e @ 1
initcall init_smp_flush+0x0/0x3e returned 0 after 0 usecs
calling  sysctl_init+0x0/0x32 @ 1
initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x94 @ 1
initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
calling  async_init+0x0/0x60 @ 1
initcall async_init+0x0/0x60 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x12 @ 1
initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
calling  init_hw_breakpoint+0x0/0xe4 @ 1
initcall init_hw_breakpoint+0x0/0xe4 returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x35 @ 1
initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2e @ 1
initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x14 @ 1
initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x14 @ 1
initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x14 @ 1
initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x5c @ 1
initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
calling  securityfs_init+0x0/0x53 @ 1
initcall securityfs_init+0x0/0x53 returned 0 after 0 usecs
calling  random32_init+0x0/0xda @ 1
initcall random32_init+0x0/0xda returned 0 after 0 usecs
calling  test_atomic64+0x0/0x450 @ 1
atomic64 test passed for x86-64 platform with CX8 and with SSE
initcall test_atomic64+0x0/0x450 returned 0 after 3906 usecs
calling  sfi_sysfs_init+0x0/0xd4 @ 1
initcall sfi_sysfs_init+0x0/0xd4 returned 0 after 0 usecs
calling  regulator_init+0x0/0x3d @ 1
regulator: core version 0.5
regulator: dummy: 
initcall regulator_init+0x0/0x3d returned 0 after 3906 usecs
calling  cpufreq_core_init+0x0/0xa5 @ 1
initcall cpufreq_core_init+0x0/0xa5 returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x40 @ 1
initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
calling  sock_init+0x0/0x5e @ 1
initcall sock_init+0x0/0x5e returned 0 after 0 usecs
calling  net_inuse_init+0x0/0x26 @ 1
initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x41 @ 1
initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x148 @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x148 returned 0 after 3906 usecs
calling  bdi_class_init+0x0/0x4d @ 1
initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x21 @ 1
initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
calling  gpiolib_sysfs_init+0x0/0xa2 @ 1
initcall gpiolib_sysfs_init+0x0/0xa2 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x19 @ 1
initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0x12 @ 1
initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x5d @ 1
initcall backlight_class_init+0x0/0x5d returned 0 after 0 usecs
calling  tty_class_init+0x0/0x38 @ 1
initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xc2 @ 1
initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
calling  register_node_type+0x0/0x12 @ 1
initcall register_node_type+0x0/0x12 returned 0 after 0 usecs
calling  spi_init+0x0/0x84 @ 1
initcall spi_init+0x0/0x84 returned 0 after 0 usecs
calling  i2c_init+0x0/0x6a @ 1
i2c-core: driver [dummy] registered
initcall i2c_init+0x0/0x6a returned 0 after 3906 usecs
calling  amd_postcore_init+0x0/0x79 @ 1
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
initcall amd_postcore_init+0x0/0x79 returned 0 after 39062 usecs
calling  arch_kdebugfs_init+0x0/0x24 @ 1
initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x61 @ 1
initcall mtrr_if_init+0x0/0x61 returned 0 after 0 usecs
calling  dmi_id_init+0x0/0x2f2 @ 1
initcall dmi_id_init+0x0/0x2f2 returned 0 after 0 usecs
calling  pci_arch_init+0x0/0x5b @ 1
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x5b returned 0 after 3906 usecs
calling  topology_init+0x0/0xbd @ 1
initcall topology_init+0x0/0xbd returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x3d @ 1
initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x1df @ 1
initcall param_sysfs_init+0x0/0x1df returned 0 after 7812 usecs
calling  init_slow_work+0x0/0x70 @ 1
initcall init_slow_work+0x0/0x70 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xc5 @ 1
initcall default_bdi_init+0x0/0xc5 returned 0 after 0 usecs
calling  init_bio+0x0/0xd5 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xd5 returned 0 after 3906 usecs
calling  cryptomgr_init+0x0/0x12 @ 1
initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x2a @ 1
initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2a @ 1
initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x64 @ 1
initcall blk_softirq_init+0x0/0x64 returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x64 @ 1
initcall blk_iopoll_setup+0x0/0x64 returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x66 @ 1
initcall genhd_device_init+0x0/0x66 returned 0 after 0 usecs
calling  blk_dev_integrity_init+0x0/0x2a @ 1
initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
calling  gpiolib_debugfs_init+0x0/0x24 @ 1
initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
calling  mc33880_init+0x0/0x12 @ 1
initcall mc33880_init+0x0/0x12 returned 0 after 0 usecs
calling  gpio_twl4030_init+0x0/0x12 @ 1
initcall gpio_twl4030_init+0x0/0x12 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x4b @ 1
initcall pci_slot_init+0x0/0x4b returned 0 after 0 usecs
calling  fbmem_init+0x0/0x98 @ 1
initcall fbmem_init+0x0/0x98 returned 0 after 0 usecs
calling  max8649_init+0x0/0x14 @ 1
i2c-core: driver [max8649] registered
initcall max8649_init+0x0/0x14 returned 0 after 3906 usecs
calling  max8660_init+0x0/0x14 @ 1
i2c-core: driver [max8660] registered
initcall max8660_init+0x0/0x14 returned 0 after 3906 usecs
calling  wm8994_ldo_init+0x0/0x31 @ 1
initcall wm8994_ldo_init+0x0/0x31 returned 0 after 0 usecs
calling  misc_init+0x0/0xb7 @ 1
initcall misc_init+0x0/0xb7 returned 0 after 0 usecs
calling  cn_init+0x0/0xa3 @ 1
initcall cn_init+0x0/0xa3 returned 0 after 0 usecs
calling  tifm_init+0x0/0x85 @ 1
initcall tifm_init+0x0/0x85 returned 0 after 0 usecs
calling  pm860x_i2c_init+0x0/0x33 @ 1
i2c-core: driver [88PM860x] registered
initcall pm860x_i2c_init+0x0/0x33 returned 0 after 3906 usecs
calling  twl_init+0x0/0x14 @ 1
i2c-core: driver [twl] registered
initcall twl_init+0x0/0x14 returned 0 after 3906 usecs
calling  da903x_init+0x0/0x14 @ 1
i2c-core: driver [da903x] registered
initcall da903x_init+0x0/0x14 returned 0 after 0 usecs
calling  ab8500_spi_init+0x0/0x12 @ 1
initcall ab8500_spi_init+0x0/0x12 returned 0 after 0 usecs
calling  init_scsi+0x0/0x91 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x91 returned 0 after 0 usecs
calling  ata_init+0x0/0x35c @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x35c returned 0 after 3906 usecs
calling  phy_init+0x0/0x2e @ 1
initcall phy_init+0x0/0x2e returned 0 after 0 usecs
calling  nop_usb_xceiv_init+0x0/0x12 @ 1
initcall nop_usb_xceiv_init+0x0/0x12 returned 0 after 0 usecs
calling  usb_init+0x0/0x15f @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x15f returned 0 after 11718 usecs
calling  serio_init+0x0/0x86 @ 1
initcall serio_init+0x0/0x86 returned 0 after 0 usecs
calling  input_init+0x0/0x13d @ 1
initcall input_init+0x0/0x13d returned 0 after 0 usecs
calling  i2c_gpio_init+0x0/0x31 @ 1
initcall i2c_gpio_init+0x0/0x31 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x44 @ 1
initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
calling  mmc_init+0x0/0x76 @ 1
initcall mmc_init+0x0/0x76 returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0x4d @ 1
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci_bus 0000:00: scanning bus
pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
pci_bus 0000:00: fixups for bus
PCI: peer root bus 00 res updated from pci conf
pci 0000:00:09.0: scanning [bus 05-05] behind bridge, pass 0
pci_bus 0000:05: scanning bus
pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
pci 0000:05:07.0: supports D1 D2
pci 0000:05:07.0: PME# supported from D1 D2 D3hot
pci 0000:05:07.0: PME# disabled
pci_bus 0000:05: fixups for bus
pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x40000000-0xfcffffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci_bus 0000:05: bus scan returning with max=05
pci 0000:00:0b.0: scanning [bus 04-04] behind bridge, pass 0
pci_bus 0000:04: scanning bus
pci_bus 0000:04: fixups for bus
pci 0000:00:0b.0: PCI bridge to [bus 04-04]
pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:04: bus scan returning with max=04
pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
pci_bus 0000:03: scanning bus
pci_bus 0000:03: fixups for bus
pci 0000:00:0c.0: PCI bridge to [bus 03-03]
pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:03: bus scan returning with max=03
pci 0000:00:0d.0: scanning [bus 02-02] behind bridge, pass 0
pci_bus 0000:02: scanning bus
pci_bus 0000:02: fixups for bus
pci 0000:00:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
Clocksource tsc unstable (delta = 105800482 ns)
pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:02: bus scan returning with max=02
pci 0000:00:0e.0: scanning [bus 01-01] behind bridge, pass 0
pci_bus 0000:01: scanning bus
pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci_bus 0000:01: fixups for bus
pci 0000:00:0e.0: PCI bridge to [bus 01-01]
pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci_bus 0000:01: bus scan returning with max=01
pci 0000:00:09.0: scanning [bus 05-05] behind bridge, pass 1
pci 0000:00:0b.0: scanning [bus 04-04] behind bridge, pass 1
pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
pci 0000:00:0d.0: scanning [bus 02-02] behind bridge, pass 1
pci 0000:00:0e.0: scanning [bus 01-01] behind bridge, pass 1
pci_bus 0000:00: bus scan returning with max=05
pci 0000:00:00.0: default IRQ router [10de:005e]
pci 0000:00:01.1: ignoring bogus IRQ 255
pci 0000:00:02.0: ignoring bogus IRQ 255
pci 0000:00:02.1: ignoring bogus IRQ 255
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:01.1: BAR 0: reserving [io  0xdc00-0xdc1f flags 0x40101] (d=0, p=0)
pci 0000:00:01.1: BAR 4: reserving [io  0x4c00-0x4c3f flags 0x40101] (d=0, p=0)
pci 0000:00:01.1: BAR 5: reserving [io  0x4c40-0x4c7f flags 0x40101] (d=0, p=0)
pci 0000:00:02.0: BAR 0: reserving [mem 0xda102000-0xda102fff flags 0x40200] (d=0, p=0)
pci 0000:00:02.1: BAR 0: reserving [mem 0xfeb00000-0xfeb000ff flags 0x40200] (d=0, p=0)
pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
pci 0000:00:04.0: BAR 0: reserving [io  0xd400-0xd4ff flags 0x40101] (d=0, p=0)
pci 0000:00:04.0: BAR 1: reserving [io  0xd800-0xd8ff flags 0x40101] (d=0, p=0)
pci 0000:00:04.0: BAR 2: reserving [mem 0xda101000-0xda101fff flags 0x40200] (d=0, p=0)
pci 0000:00:06.0: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
pci 0000:00:06.0: BAR 4: reserving [io  0xf000-0xf00f flags 0x40101] (d=0, p=0)
pci 0000:00:0a.0: BAR 0: reserving [mem 0xda100000-0xda100fff flags 0x40200] (d=0, p=0)
pci 0000:00:0a.0: BAR 1: reserving [io  0xd000-0xd007 flags 0x40101] (d=0, p=0)
pci 0000:05:07.0: BAR 0: reserving [io  0xc000-0xc0ff flags 0x40101] (d=0, p=0)
pci 0000:05:07.0: BAR 1: reserving [mem 0xda000000-0xda0000ff flags 0x40200] (d=0, p=0)
pci 0000:01:00.0: BAR 0: reserving [mem 0xd0000000-0xd7ffffff flags 0x42208] (d=0, p=0)
pci 0000:01:00.0: BAR 1: reserving [io  0xb000-0xb0ff flags 0x40101] (d=0, p=0)
pci 0000:01:00.0: BAR 2: reserving [mem 0xd9000000-0xd900ffff flags 0x40200] (d=0, p=0)
pci 0000:01:00.1: BAR 0: reserving [mem 0xd9010000-0xd901ffff flags 0x40200] (d=1, p=1)
Expanded resource reserved due to conflict with PCI Bus #00
reserve RAM buffer: 000000000009f800 - 000000000009ffff 
reserve RAM buffer: 000000003fff0000 - 000000003fffffff initcall pci_subsys_init+0x0/0x4d returned 0 after 550781 usecs
calling  proto_init+0x0/0x12 @ 1
initcall proto_init+0x0/0x12 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x218 @ 1
initcall net_dev_init+0x0/0x218 returned 0 after 0 usecs
calling  neigh_init+0x0/0x71 @ 1
initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xa6 @ 1
initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xec @ 1
initcall pktsched_init+0x0/0xec returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x4c @ 1
initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
calling  genl_init+0x0/0x8f @ 1
initcall genl_init+0x0/0x8f returned 0 after 0 usecs
calling  irda_init+0x0/0xae @ 1
irda_init()
NET: Registered protocol family 23
initcall irda_init+0x0/0xae returned 0 after 3906 usecs
calling  sysctl_init+0x0/0x48 @ 1
initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
calling  print_ICs+0x0/0x54c @ 1
initcall print_ICs+0x0/0x54c returned 0 after 0 usecs
calling  hpet_late_init+0x0/0xd3 @ 1
initcall hpet_late_init+0x0/0xd3 returned -19 after 0 usecs
calling  init_k8_nbs+0x0/0x28 @ 1
initcall init_k8_nbs+0x0/0x28 returned 0 after 0 usecs
calling  clocksource_done_booting+0x0/0x5e @ 1
initcall clocksource_done_booting+0x0/0x5e returned 0 after 0 usecs
calling  ftrace_init_debugfs+0x0/0x1f9 @ 1
initcall ftrace_init_debugfs+0x0/0x1f9 returned 0 after 0 usecs
calling  rb_init_debugfs+0x0/0x2f @ 1
initcall rb_init_debugfs+0x0/0x2f returned 0 after 0 usecs
calling  tracer_init_debugfs+0x0/0x398 @ 1
initcall tracer_init_debugfs+0x0/0x398 returned 0 after 0 usecs
calling  init_trace_printk_function_export+0x0/0x2f @ 1
initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 0 usecs
calling  stat_workqueue_init+0x0/0x2b @ 1
initcall stat_workqueue_init+0x0/0x2b returned 0 after 0 usecs
calling  event_trace_init+0x0/0x2c0 @ 1
initcall event_trace_init+0x0/0x2c0 returned 0 after 46875 usecs
calling  init_pipe_fs+0x0/0x4c @ 1
initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
calling  eventpoll_init+0x0/0xda @ 1
initcall eventpoll_init+0x0/0xda returned 0 after 0 usecs
calling  anon_inode_init+0x0/0x135 @ 1
initcall anon_inode_init+0x0/0x135 returned 0 after 3906 usecs
calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
calling  chr_dev_init+0x0/0xd1 @ 1
initcall chr_dev_init+0x0/0xd1 returned 0 after 0 usecs
calling  firmware_class_init+0x0/0x19 @ 1
initcall firmware_class_init+0x0/0x19 returned 0 after 0 usecs
calling  ieee1394_init+0x0/0x260 @ 1
initcall ieee1394_init+0x0/0x260 returned 0 after 0 usecs
calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0x67 @ 1
initcall cpufreq_gov_dbs_init+0x0/0x67 returned 0 after 0 usecs
calling  ssb_modinit+0x0/0x49 @ 1
initcall ssb_modinit+0x0/0x49 returned 0 after 0 usecs
calling  pcibios_assign_resources+0x0/0x74 @ 1
pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff]
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
initcall pcibios_assign_resources+0x0/0x74 returned 0 after 160156 usecs
calling  sysctl_core_init+0x0/0x38 @ 1
initcall sysctl_core_init+0x0/0x38 returned 0 after 0 usecs
calling  inet_init+0x0/0x23c @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 4, 81920 bytes)
UDP-Lite hash table entries: 512 (order: 4, 81920 bytes)
initcall inet_init+0x0/0x23c returned 0 after 46875 usecs
calling  af_unix_init+0x0/0x55 @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 3906 usecs
calling  init_sunrpc+0x0/0x5d @ 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
initcall init_sunrpc+0x0/0x5d returned 0 after 11718 usecs
calling  default_rootfs+0x0/0x6b @ 1
initcall default_rootfs+0x0/0x6b returned 0 after 0 usecs
calling  pci_iommu_init+0x0/0x47 @ 1
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
initcall pci_iommu_init+0x0/0x47 returned 0 after 66406 usecs
calling  irqfd_module_init+0x0/0x35 @ 1
initcall irqfd_module_init+0x0/0x35 returned 0 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x22 @ 1
initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 0 usecs
calling  vsyscall_init+0x0/0x60 @ 1
initcall vsyscall_init+0x0/0x60 returned 0 after 0 usecs
calling  sbf_init+0x0/0xe9 @ 1
initcall sbf_init+0x0/0xe9 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x22 @ 1
initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 0 usecs
calling  add_rtc_cmos+0x0/0x4d @ 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
initcall add_rtc_cmos+0x0/0x4d returned 0 after 3906 usecs
calling  cache_sysfs_init+0x0/0x35a @ 1
initcall cache_sysfs_init+0x0/0x35a returned 0 after 0 usecs
calling  ioapic_init_sysfs+0x0/0xb6 @ 1
initcall ioapic_init_sysfs+0x0/0xb6 returned 0 after 0 usecs
calling  add_pcspkr+0x0/0x28 @ 1
initcall add_pcspkr+0x0/0x28 returned 0 after 0 usecs
calling  start_pageattr_test+0x0/0x47 @ 1
initcall start_pageattr_test+0x0/0x47 returned 0 after 0 usecs
calling  init_vdso_vars+0x0/0x20a @ 1
initcall init_vdso_vars+0x0/0x20a returned 0 after 0 usecs
calling  ia32_binfmt_init+0x0/0x14 @ 1
initcall ia32_binfmt_init+0x0/0x14 returned 0 after 0 usecs
calling  sysenter_setup+0x0/0x2cb @ 1
initcall sysenter_setup+0x0/0x2cb returned 0 after 0 usecs
calling  init_aout_binfmt+0x0/0x14 @ 1
initcall init_aout_binfmt+0x0/0x14 returned 0 after 0 usecs
calling  init_sched_debug_procfs+0x0/0x2c @ 1
initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 0 usecs
calling  proc_schedstat_init+0x0/0x22 @ 1
initcall proc_schedstat_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_execdomains_init+0x0/0x22 @ 1
initcall proc_execdomains_init+0x0/0x22 returned 0 after 0 usecs
calling  ioresources_init+0x0/0x3c @ 1
initcall ioresources_init+0x0/0x3c returned 0 after 0 usecs
calling  uid_cache_init+0x0/0x8c @ 1
initcall uid_cache_init+0x0/0x8c returned 0 after 0 usecs
calling  init_posix_timers+0x0/0x17a @ 1
initcall init_posix_timers+0x0/0x17a returned 0 after 0 usecs
calling  init_posix_cpu_timers+0x0/0xe5 @ 1
initcall init_posix_cpu_timers+0x0/0xe5 returned 0 after 0 usecs
calling  nsproxy_cache_init+0x0/0x2d @ 1
initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
calling  create_proc_profile+0x0/0x289 @ 1
initcall create_proc_profile+0x0/0x289 returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x22 @ 1
initcall timekeeping_init_device+0x0/0x22 returned 0 after 0 usecs
calling  init_clocksource_sysfs+0x0/0x50 @ 1
initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 0 usecs
calling  init_timer_list_procfs+0x0/0x2c @ 1
initcall init_timer_list_procfs+0x0/0x2c returned 0 after 0 usecs
calling  lockdep_proc_init+0x0/0x7c @ 1
initcall lockdep_proc_init+0x0/0x7c returned 0 after 0 usecs
calling  futex_init+0x0/0x80 @ 1
initcall futex_init+0x0/0x80 returned 0 after 0 usecs
calling  init_rttest+0x0/0x155 @ 1
Initializing RT-Tester: OK
initcall init_rttest+0x0/0x155 returned 0 after 0 usecs
calling  proc_dma_init+0x0/0x22 @ 1
initcall proc_dma_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_modules_init+0x0/0x22 @ 1
initcall proc_modules_init+0x0/0x22 returned 0 after 0 usecs
calling  kallsyms_init+0x0/0x25 @ 1
initcall kallsyms_init+0x0/0x25 returned 0 after 0 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x46d @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x46d returned 0 after 0 usecs
calling  crash_notes_memory_init+0x0/0x37 @ 1
initcall crash_notes_memory_init+0x0/0x37 returned 0 after 0 usecs
calling  backtrace_regression_test+0x0/0x105 @ 1
====[ backtrace testing ]===========
Testing a backtrace from process context.
The following trace is a kernel self test and not a bug!
Pid: 1, comm: swapper Not tainted 2.6.35-rc4-tip-01075-g0c1880a-dirty #15306
Call Trace:
 [<ffffffff810a0327>] ? backtrace_regression_test+0x0/0x105
 [<ffffffff810a0364>] backtrace_regression_test+0x3d/0x105
 [<ffffffff81863387>] ? printk+0x68/0x6a
 [<ffffffff81089108>] ? ktime_get+0x65/0xbe
 [<ffffffff810a0327>] ? backtrace_regression_test+0x0/0x105
 [<ffffffff810001f2>] do_one_initcall+0x57/0x15d
 [<ffffffff8204c6ec>] kernel_init+0x15a/0x1e4
 [<ffffffff8102ac04>] kernel_thread_helper+0x4/0x10
 [<ffffffff81867994>] ? restore_args+0x0/0x30
 [<ffffffff8204c592>] ? kernel_init+0x0/0x1e4
 [<ffffffff8102ac00>] ? kernel_thread_helper+0x0/0x10
Testing a backtrace from irq context.
The following trace is a kernel self test and not a bug!
Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.35-rc4-tip-01075-g0c1880a-dirty #15306
Call Trace:
 <IRQ>  [<ffffffff8108f527>] ? trace_hardirqs_on_caller+0x105/0x143
 [<ffffffff810a0319>] backtrace_test_irq_callback+0xe/0x1c
 [<ffffffff8106b921>] tasklet_action+0xd4/0x164
 [<ffffffff8106c4cd>] __do_softirq+0x14c/0x263
 [<ffffffff8102acfc>] call_softirq+0x1c/0x28
 <EOI>  [<ffffffff8102c76f>] ? do_softirq+0x6b/0xdf
 [<ffffffff8106b54a>] run_ksoftirqd+0x9c/0x19d
 [<ffffffff8106b4ae>] ? run_ksoftirqd+0x0/0x19d
 [<ffffffff810805e9>] kthread+0x7f/0x87
 [<ffffffff8102ac04>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105af79>] ? finish_task_switch+0x70/0xdc
 [<ffffffff818674c5>] ? _raw_spin_unlock_irq+0x4f/0x6c
 [<ffffffff81867994>] ? restore_args+0x0/0x30
 [<ffffffff8108056a>] ? kthread+0x0/0x87
 [<ffffffff8102ac00>] ? kernel_thread_helper+0x0/0x10
Testing a saved backtrace.
The following trace is a kernel self test and not a bug!
 [<ffffffff81036260>] save_stack_trace+0x2f/0x4c
 [<ffffffff810a0409>] backtrace_regression_test+0xe2/0x105
 [<ffffffff810001f2>] do_one_initcall+0x57/0x15d
 [<ffffffff8204c6ec>] kernel_init+0x15a/0x1e4
 [<ffffffff8102ac04>] kernel_thread_helper+0x4/0x10
 [<ffffffffffffffff>] 0xffffffffffffffff
====[ end of backtrace testing ]====
initcall backtrace_regression_test+0x0/0x105 returned 0 after 160156 usecs
calling  pid_namespaces_init+0x0/0x2d @ 1
initcall pid_namespaces_init+0x0/0x2d returned 0 after 0 usecs
calling  utsname_sysctl_init+0x0/0x14 @ 1
initcall utsname_sysctl_init+0x0/0x14 returned 0 after 0 usecs
calling  init_tracepoints+0x0/0x17 @ 1
initcall init_tracepoints+0x0/0x17 returned 0 after 0 usecs
calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 0 usecs
calling  init_events+0x0/0x61 @ 1
initcall init_events+0x0/0x61 returned 0 after 0 usecs
calling  init_sched_switch_trace+0x0/0x12 @ 1
Testing tracer sched_switch: PASSED
initcall init_sched_switch_trace+0x0/0x12 returned 0 after 140625 usecs
calling  init_function_trace+0x0/0x3e @ 1
Testing tracer function: PASSED
Testing dynamic ftrace: PASSED
initcall init_function_trace+0x0/0x3e returned 0 after 398437 usecs
calling  init_irqsoff_tracer+0x0/0x14 @ 1
Testing tracer preemptoff: PASSED
initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 54687 usecs
calling  init_wakeup_tracer+0x0/0x22 @ 1
Testing tracer wakeup: 
ftrace-test used greatest stack depth: 6376 bytes left
PASSED
Testing tracer wakeup_rt: PASSED
initcall init_wakeup_tracer+0x0/0x22 returned 0 after 730468 usecs
calling  init_mmio_trace+0x0/0x12 @ 1
initcall init_mmio_trace+0x0/0x12 returned 0 after 0 usecs
calling  init_graph_trace+0x0/0x65 @ 1
Testing tracer function_graph: PASSED
initcall init_graph_trace+0x0/0x65 returned 0 after 148437 usecs
calling  init_blk_tracer+0x0/0x55 @ 1
initcall init_blk_tracer+0x0/0x55 returned 0 after 0 usecs
calling  init_ksym_trace+0x0/0x5b @ 1
Testing tracer ksym_tracer: PASSED
initcall init_ksym_trace+0x0/0x5b returned 0 after 66406 usecs
calling  perf_event_sysfs_init+0x0/0x19 @ 1
initcall perf_event_sysfs_init+0x0/0x19 returned 0 after 0 usecs
calling  init_per_zone_wmark_min+0x0/0x67 @ 1
initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 0 usecs
calling  kswapd_init+0x0/0x70 @ 1
initcall kswapd_init+0x0/0x70 returned 0 after 0 usecs
calling  extfrag_debug_init+0x0/0x72 @ 1
initcall extfrag_debug_init+0x0/0x72 returned 0 after 0 usecs
calling  setup_vmstat+0x0/0xc7 @ 1
initcall setup_vmstat+0x0/0xc7 returned 0 after 0 usecs
calling  mm_sysfs_init+0x0/0x29 @ 1
initcall mm_sysfs_init+0x0/0x29 returned 0 after 0 usecs
calling  proc_vmalloc_init+0x0/0x25 @ 1
initcall proc_vmalloc_init+0x0/0x25 returned 0 after 0 usecs
calling  hugetlb_init+0x0/0x46c @ 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x46c returned 0 after 3906 usecs
calling  ksm_init+0x0/0x18c @ 1
initcall ksm_init+0x0/0x18c returned 0 after 0 usecs
calling  fasync_init+0x0/0x2a @ 1
initcall fasync_init+0x0/0x2a returned 0 after 0 usecs
calling  proc_filesystems_init+0x0/0x22 @ 1
initcall proc_filesystems_init+0x0/0x22 returned 0 after 0 usecs
calling  inotify_setup+0x0/0x12 @ 1
initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
calling  proc_locks_init+0x0/0x22 @ 1
initcall proc_locks_init+0x0/0x22 returned 0 after 0 usecs
calling  init_sys32_ioctl+0x0/0x28 @ 1
initcall init_sys32_ioctl+0x0/0x28 returned 0 after 0 usecs
calling  init_mbcache+0x0/0x14 @ 1
initcall init_mbcache+0x0/0x14 returned 0 after 0 usecs
calling  dquot_init+0x0/0x11b @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
initcall dquot_init+0x0/0x11b returned 0 after 3906 usecs
calling  init_v1_quota_format+0x0/0x12 @ 1
initcall init_v1_quota_format+0x0/0x12 returned 0 after 0 usecs
calling  quota_init+0x0/0x26 @ 1
initcall quota_init+0x0/0x26 returned 0 after 0 usecs
calling  proc_cmdline_init+0x0/0x22 @ 1
initcall proc_cmdline_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_cpuinfo_init+0x0/0x22 @ 1
initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_devices_init+0x0/0x22 @ 1
initcall proc_devices_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_interrupts_init+0x0/0x22 @ 1
initcall proc_interrupts_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_loadavg_init+0x0/0x22 @ 1
initcall proc_loadavg_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_meminfo_init+0x0/0x22 @ 1
initcall proc_meminfo_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_stat_init+0x0/0x22 @ 1
initcall proc_stat_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_uptime_init+0x0/0x22 @ 1
initcall proc_uptime_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_version_init+0x0/0x22 @ 1
initcall proc_version_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_softirqs_init+0x0/0x22 @ 1
initcall proc_softirqs_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_kcore_init+0x0/0xa9 @ 1
initcall proc_kcore_init+0x0/0xa9 returned 0 after 0 usecs
calling  proc_kmsg_init+0x0/0x25 @ 1
initcall proc_kmsg_init+0x0/0x25 returned 0 after 0 usecs
calling  proc_page_init+0x0/0x42 @ 1
initcall proc_page_init+0x0/0x42 returned 0 after 0 usecs
calling  init_devpts_fs+0x0/0x4c @ 1
initcall init_devpts_fs+0x0/0x4c returned 0 after 0 usecs
calling  init_reiserfs_fs+0x0/0x6b @ 1
initcall init_reiserfs_fs+0x0/0x6b returned 0 after 0 usecs
calling  init_ext3_fs+0x0/0x71 @ 1
initcall init_ext3_fs+0x0/0x71 returned 0 after 0 usecs
calling  init_ext2_fs+0x0/0x71 @ 1
initcall init_ext2_fs+0x0/0x71 returned 0 after 0 usecs
calling  init_ext4_fs+0x0/0xe9 @ 1
initcall init_ext4_fs+0x0/0xe9 returned 0 after 0 usecs
calling  journal_init+0x0/0xd8 @ 1
initcall journal_init+0x0/0xd8 returned 0 after 3906 usecs
calling  journal_init+0x0/0xae @ 1
initcall journal_init+0x0/0xae returned 0 after 0 usecs
calling  init_ramfs_fs+0x0/0x12 @ 1
initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
calling  init_hugetlbfs_fs+0x0/0x98 @ 1
initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 0 usecs
calling  init_coda+0x0/0x153 @ 1
initcall init_coda+0x0/0x153 returned 0 after 0 usecs
calling  init_fat_fs+0x0/0x4f @ 1
initcall init_fat_fs+0x0/0x4f returned 0 after 0 usecs
calling  init_msdos_fs+0x0/0x12 @ 1
initcall init_msdos_fs+0x0/0x12 returned 0 after 0 usecs
calling  vxfs_init+0x0/0x5b @ 1
initcall vxfs_init+0x0/0x5b returned 0 after 0 usecs
calling  init_nfs_fs+0x0/0x14c @ 1
initcall init_nfs_fs+0x0/0x14c returned 0 after 0 usecs
calling  init_nlm+0x0/0x22 @ 1
initcall init_nlm+0x0/0x22 returned 0 after 0 usecs
calling  init_nls_cp850+0x0/0x12 @ 1
initcall init_nls_cp850+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp855+0x0/0x12 @ 1
initcall init_nls_cp855+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp860+0x0/0x12 @ 1
initcall init_nls_cp860+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp864+0x0/0x12 @ 1
initcall init_nls_cp864+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp865+0x0/0x12 @ 1
initcall init_nls_cp865+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp869+0x0/0x12 @ 1
initcall init_nls_cp869+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp936+0x0/0x12 @ 1
initcall init_nls_cp936+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_cp950+0x0/0x12 @ 1
initcall init_nls_cp950+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_2+0x0/0x12 @ 1
initcall init_nls_iso8859_2+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_7+0x0/0x12 @ 1
initcall init_nls_iso8859_7+0x0/0x12 returned 0 after 0 usecs
calling  init_nls_iso8859_13+0x0/0x12 @ 1
initcall init_nls_iso8859_13+0x0/0x12 returned 0 after 0 usecs
calling  init_cifs+0x0/0x452 @ 1
Slow work thread pool: Starting up
Slow work thread pool: Ready
initcall init_cifs+0x0/0x452 returned 0 after 7812 usecs
calling  logfs_init+0x0/0x69 @ 1
initcall logfs_init+0x0/0x69 returned 0 after 0 usecs
calling  init_affs_fs+0x0/0x63 @ 1
initcall init_affs_fs+0x0/0x63 returned 0 after 0 usecs
calling  fuse_init+0x0/0x141 @ 1
fuse init (API version 7.14)
initcall fuse_init+0x0/0x141 returned 0 after 0 usecs
calling  cuse_init+0x0/0xac @ 1
initcall cuse_init+0x0/0xac returned 0 after 0 usecs
calling  init_udf_fs+0x0/0x63 @ 1
initcall init_udf_fs+0x0/0x63 returned 0 after 0 usecs
calling  init_jfs_fs+0x0/0x1d0 @ 1
JFS: nTxBlock = 7270, nTxLock = 58165
initcall init_jfs_fs+0x0/0x1d0 returned 0 after 11718 usecs
calling  init_xfs_fs+0x0/0xb3 @ 1
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
initcall init_xfs_fs+0x0/0xb3 returned 0 after 27343 usecs
calling  ipc_init+0x0/0x23 @ 1
msgmni has been set to 1817
initcall ipc_init+0x0/0x23 returned 0 after 0 usecs
calling  ipc_sysctl_init+0x0/0x14 @ 1
initcall ipc_sysctl_init+0x0/0x14 returned 0 after 0 usecs
calling  init_mqueue_fs+0x0/0xc8 @ 1
initcall init_mqueue_fs+0x0/0xc8 returned 0 after 0 usecs
calling  key_proc_init+0x0/0x33 @ 1
initcall key_proc_init+0x0/0x33 returned 0 after 0 usecs
calling  crypto_wq_init+0x0/0x32 @ 1
initcall crypto_wq_init+0x0/0x32 returned 0 after 7812 usecs
calling  crypto_algapi_init+0x0/0xd @ 1
initcall crypto_algapi_init+0x0/0xd returned 0 after 0 usecs
calling  skcipher_module_init+0x0/0x36 @ 1
initcall skcipher_module_init+0x0/0x36 returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0x12 @ 1
initcall chainiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  eseqiv_module_init+0x0/0x12 @ 1
initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  seqiv_module_init+0x0/0x12 @ 1
initcall seqiv_module_init+0x0/0x12 returned 0 after 0 usecs
calling  hmac_module_init+0x0/0x12 @ 1
initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_null_mod_init+0x0/0x7d @ 1
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
initcall crypto_null_mod_init+0x0/0x7d returned 0 after 15625 usecs
calling  md4_mod_init+0x0/0x12 @ 1
initcall md4_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  md5_mod_init+0x0/0x12 @ 1
cryptomgr_test used greatest stack depth: 5752 bytes left
initcall md5_mod_init+0x0/0x12 returned 0 after 3906 usecs
calling  sha1_generic_mod_init+0x0/0x12 @ 1
initcall sha1_generic_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_ecb_module_init+0x0/0x12 @ 1
initcall crypto_ecb_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_cbc_module_init+0x0/0x12 @ 1
initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 0 usecs
calling  crypto_ctr_module_init+0x0/0x3e @ 1
initcall crypto_ctr_module_init+0x0/0x3e returned 0 after 0 usecs
calling  crypto_ccm_module_init+0x0/0x60 @ 1
initcall crypto_ccm_module_init+0x0/0x60 returned 0 after 0 usecs
calling  cryptd_init+0x0/0xf6 @ 1
initcall cryptd_init+0x0/0xf6 returned 0 after 0 usecs
calling  des_generic_mod_init+0x0/0x3f @ 1
initcall des_generic_mod_init+0x0/0x3f returned 0 after 0 usecs
calling  twofish_mod_init+0x0/0x12 @ 1
initcall twofish_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  aes_init+0x0/0x12 @ 1
initcall aes_init+0x0/0x12 returned 0 after 0 usecs
calling  camellia_init+0x0/0x12 @ 1
initcall camellia_init+0x0/0x12 returned 0 after 0 usecs
calling  cast5_mod_init+0x0/0x12 @ 1
initcall cast5_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  arc4_init+0x0/0x12 @ 1
initcall arc4_init+0x0/0x12 returned 0 after 0 usecs
calling  seed_init+0x0/0x12 @ 1
initcall seed_init+0x0/0x12 returned 0 after 3906 usecs
calling  salsa20_generic_mod_init+0x0/0x12 @ 1
initcall salsa20_generic_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  deflate_mod_init+0x0/0x12 @ 1
initcall deflate_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  zlib_mod_init+0x0/0x12 @ 1
initcall zlib_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  crc32c_mod_init+0x0/0x12 @ 1
cryptomgr_test used greatest stack depth: 5456 bytes left
initcall crc32c_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  krng_mod_init+0x0/0x12 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x12 returned 0 after 0 usecs
calling  prng_mod_init+0x0/0x22 @ 1
alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
initcall prng_mod_init+0x0/0x22 returned 0 after 19531 usecs
calling  proc_genhd_init+0x0/0x3c @ 1
initcall proc_genhd_init+0x0/0x3c returned 0 after 0 usecs
calling  bsg_init+0x0/0x12e @ 1
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall bsg_init+0x0/0x12e returned 0 after 3906 usecs
calling  noop_init+0x0/0x14 @ 1
io scheduler noop registered (default)
initcall noop_init+0x0/0x14 returned 0 after 3906 usecs
calling  deadline_init+0x0/0x14 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 0 usecs
calling  cfq_init+0x0/0x94 @ 1
io scheduler cfq registered
initcall cfq_init+0x0/0x94 returned 0 after 3906 usecs
calling  btree_module_init+0x0/0x2a @ 1
initcall btree_module_init+0x0/0x2a returned 0 after 0 usecs
calling  debug_objects_init_debugfs+0x0/0x64 @ 1
initcall debug_objects_init_debugfs+0x0/0x64 returned 0 after 0 usecs
calling  libcrc32c_mod_init+0x0/0x2c @ 1
initcall libcrc32c_mod_init+0x0/0x2c returned 0 after 0 usecs
calling  percpu_counter_startup+0x0/0x2d @ 1
initcall percpu_counter_startup+0x0/0x2d returned 0 after 0 usecs
calling  dynamic_debug_init+0x0/0x12c @ 1
initcall dynamic_debug_init+0x0/0x12c returned 0 after 0 usecs
calling  lnw_gpio_init+0x0/0x1b @ 1
initcall lnw_gpio_init+0x0/0x1b returned 0 after 0 usecs
calling  timbgpio_init+0x0/0x12 @ 1
initcall timbgpio_init+0x0/0x12 returned 0 after 0 usecs
calling  cs5535_gpio_init+0x0/0x227 @ 1
initcall cs5535_gpio_init+0x0/0x227 returned -19 after 0 usecs
calling  it8761e_gpio_init+0x0/0x1a3 @ 1
initcall it8761e_gpio_init+0x0/0x1a3 returned -19 after 0 usecs
calling  ttl_init+0x0/0x12 @ 1
initcall ttl_init+0x0/0x12 returned 0 after 0 usecs
calling  pci_proc_init+0x0/0x6a @ 1
initcall pci_proc_init+0x0/0x6a returned 0 after 0 usecs
calling  pcie_portdrv_init+0x0/0x58 @ 1
pcieport 0000:00:0b.0: setting latency timer to 64
  alloc irq_desc for 40 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
pcieport 0000:00:0c.0: setting latency timer to 64
  alloc irq_desc for 41 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
pcieport 0000:00:0d.0: setting latency timer to 64
  alloc irq_desc for 42 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
pcieport 0000:00:0e.0: setting latency timer to 64
  alloc irq_desc for 43 on node 0
  alloc kstat_irqs on node 0
pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
initcall pcie_portdrv_init+0x0/0x58 returned 0 after 46875 usecs
calling  genericbl_init+0x0/0x12 @ 1
initcall genericbl_init+0x0/0x12 returned 0 after 0 usecs
calling  kb3886_init+0x0/0x3a @ 1
initcall kb3886_init+0x0/0x3a returned -19 after 0 usecs
calling  adp5520_bl_init+0x0/0x12 @ 1
initcall adp5520_bl_init+0x0/0x12 returned 0 after 0 usecs
calling  cyber2000fb_init+0x0/0xd0 @ 1
initcall cyber2000fb_init+0x0/0xd0 returned 0 after 0 usecs
calling  pm3fb_init+0x0/0x10d @ 1
initcall pm3fb_init+0x0/0x10d returned 0 after 0 usecs
calling  matroxfb_init+0x0/0x9a2 @ 1
initcall matroxfb_init+0x0/0x9a2 returned 0 after 0 usecs
calling  i2c_matroxfb_init+0x0/0x2b @ 1
initcall i2c_matroxfb_init+0x0/0x2b returned 0 after 0 usecs
calling  nvidiafb_init+0x0/0x2be @ 1
initcall nvidiafb_init+0x0/0x2be returned 0 after 0 usecs
calling  kyrofb_init+0x0/0xf4 @ 1
initcall kyrofb_init+0x0/0xf4 returned 0 after 0 usecs
calling  tdfxfb_init+0x0/0x12d @ 1
initcall tdfxfb_init+0x0/0x12d returned 0 after 0 usecs
calling  vmlfb_init+0x0/0x96 @ 1
vmlfb: initializing
initcall vmlfb_init+0x0/0x96 returned 0 after 3906 usecs
calling  cr_pll_init+0x0/0xe7 @ 1
Could not find Carillo Ranch MCH device.
initcall cr_pll_init+0x0/0xe7 returned -19 after 3906 usecs
calling  tmiofb_init+0x0/0x69 @ 1
initcall tmiofb_init+0x0/0x69 returned 0 after 0 usecs
calling  metronomefb_init+0x0/0x12 @ 1
initcall metronomefb_init+0x0/0x12 returned 0 after 0 usecs
calling  uvesafb_init+0x0/0x3da @ 1
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
initcall uvesafb_init+0x0/0x3da returned 0 after 19531 usecs
calling  regulator_userspace_consumer_init+0x0/0x12 @ 1
initcall regulator_userspace_consumer_init+0x0/0x12 returned 0 after 0 usecs
calling  bq24022_init+0x0/0x19 @ 1
initcall bq24022_init+0x0/0x19 returned -19 after 0 usecs
calling  rand_initialize+0x0/0x31 @ 1
initcall rand_initialize+0x0/0x31 returned 0 after 0 usecs
calling  tty_init+0x0/0xf5 @ 1
initcall tty_init+0x0/0xf5 returned 0 after 7812 usecs
calling  pty_init+0x0/0x50d @ 1
initcall pty_init+0x0/0x50d returned 0 after 46875 usecs
calling  sysrq_init+0x0/0x78 @ 1
initcall sysrq_init+0x0/0x78 returned 0 after 0 usecs
calling  istallion_module_init+0x0/0x50b @ 1
Stallion Intelligent Multiport Serial Driver: version 5.6.0
initcall istallion_module_init+0x0/0x50b returned 0 after 3906 usecs
calling  moxa_init+0x0/0x266 @ 1
MOXA Intellio family driver version 6.0k
initcall moxa_init+0x0/0x266 returned 0 after 27343 usecs
calling  riscom8_init_module+0x0/0x42f @ 1
rc: SDL RISCom/8 card driver v1.1, (c) D.Gorodchanin 1994-1996.
rc0: RISCom/8 Board at 0x220 not found.
rc1: RISCom/8 Board at 0x240 not found.
rc2: RISCom/8 Board at 0x250 not found.
rc3: RISCom/8 Board at 0x260 not found.
rc: No RISCom/8 boards detected.
initcall riscom8_init_module+0x0/0x42f returned -5 after 50781 usecs
initcall riscom8_init_module+0x0/0x42f returned with error code -5 
calling  slgt_init+0x0/0x1ba @ 1
SyncLink GT
SyncLink GT, tty major#253
SyncLink GT no devices found
initcall slgt_init+0x0/0x1ba returned 0 after 7812 usecs
calling  n_hdlc_init+0x0/0x94 @ 1
HDLC line discipline maxframe=4096
N_HDLC line discipline registered.
initcall n_hdlc_init+0x0/0x94 returned 0 after 7812 usecs
calling  gsm_init+0x0/0x158 @ 1
gsm_init: loaded as 252,0.
initcall gsm_init+0x0/0x158 returned 0 after 0 usecs
calling  applicom_init+0x0/0x4c8 @ 1
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
initcall applicom_init+0x0/0x4c8 returned -6 after 7812 usecs
initcall applicom_init+0x0/0x4c8 returned with error code -6 
calling  rtc_generic_init+0x0/0x65 @ 1
Generic RTC Driver v1.07
initcall rtc_generic_init+0x0/0x65 returned 0 after 3906 usecs
calling  mwave_init+0x0/0x1dd @ 1
smapi::smapi_init, ERROR invalid usSmapiID
mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
mwave: mwavedd::mwave_init: Error: Failed to initialize board data
mwave: mwavedd::mwave_init: Error: Failed to initialize
initcall mwave_init+0x0/0x1dd returned -5 after 15625 usecs
initcall mwave_init+0x0/0x1dd returned with error code -5 
calling  ipmi_init_msghandler_mod+0x0/0xd @ 1
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xd returned 0 after 0 usecs
calling  init_ipmi_devintf+0x0/0x108 @ 1
ipmi device interface
initcall init_ipmi_devintf+0x0/0x108 returned 0 after 0 usecs
calling  init_tis+0x0/0x872 @ 1
tpm_tis tpm_tis: 1.2 TPM (device-id 0xFFFF, rev-id 255)
tpm_tis tpm_tis: Unable to request irq: 255 for use
tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
initcall init_tis+0x0/0x872 returned 0 after 19531 usecs
calling  ramoops_init+0x0/0x114 @ 1
ramoops: invalid size specificationinitcall ramoops_init+0x0/0x114 returned -22 after 3906 usecs
initcall ramoops_init+0x0/0x114 returned with error code -22 
calling  serial8250_init+0x0/0x183 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_init+0x0/0x183 returned 0 after 11718 usecs
calling  max3100_init+0x0/0x12 @ 1
initcall max3100_init+0x0/0x12 returned 0 after 0 usecs
calling  jsm_init_module+0x0/0x45 @ 1
initcall jsm_init_module+0x0/0x45 returned 0 after 0 usecs
calling  init_kgdboc+0x0/0x16 @ 1
initcall init_kgdboc+0x0/0x16 returned 0 after 0 usecs
calling  altera_jtaguart_init+0x0/0x3c @ 1
initcall altera_jtaguart_init+0x0/0x3c returned 0 after 0 usecs
calling  altera_uart_init+0x0/0x3c @ 1
initcall altera_uart_init+0x0/0x3c returned -12 after 0 usecs
initcall altera_uart_init+0x0/0x3c returned with error code -12 
calling  topology_sysfs_init+0x0/0x5b @ 1
initcall topology_sysfs_init+0x0/0x5b returned 0 after 0 usecs
calling  cpqarray_init+0x0/0x28f @ 1
Compaq SMART2 Driver (v 2.6.0)
initcall cpqarray_init+0x0/0x28f returned -19 after 0 usecs
calling  cciss_init+0x0/0x9e @ 1
HP CISS Driver (v 3.6.20)
initcall cciss_init+0x0/0x9e returned 0 after 3906 usecs
calling  carm_init+0x0/0x1b @ 1
initcall carm_init+0x0/0x1b returned 0 after 0 usecs
calling  ics932s401_init+0x0/0x14 @ 1
i2c-core: driver [ics932s401] registered
initcall ics932s401_init+0x0/0x14 returned 0 after 3906 usecs
calling  phantom_init+0x0/0x10b @ 1
Phantom Linux Driver, version n0.9.8, init OK
initcall phantom_init+0x0/0x10b returned 0 after 3906 usecs
calling  ioc4_init+0x0/0x1b @ 1
initcall ioc4_init+0x0/0x1b returned 0 after 0 usecs
calling  enclosure_init+0x0/0x19 @ 1
initcall enclosure_init+0x0/0x19 returned 0 after 0 usecs
calling  init_kgdbts+0x0/0x16 @ 1
initcall init_kgdbts+0x0/0x16 returned 0 after 0 usecs
calling  isl29003_init+0x0/0x14 @ 1
i2c-core: driver [isl29003] registered
initcall isl29003_init+0x0/0x14 returned 0 after 0 usecs
calling  at25_init+0x0/0x12 @ 1
initcall at25_init+0x0/0x12 returned 0 after 0 usecs
calling  eeprom_init+0x0/0x14 @ 1
i2c-core: driver [eeprom] registered
initcall eeprom_init+0x0/0x14 returned 0 after 3906 usecs
calling  cb710_init_module+0x0/0x1b @ 1
initcall cb710_init_module+0x0/0x1b returned 0 after 3906 usecs
calling  vmballoon_init+0x0/0x1be @ 1
initcall vmballoon_init+0x0/0x1be returned -19 after 0 usecs
calling  htcpld_core_init+0x0/0x2b @ 1
i2c-core: driver [htcpld-chip] registered
initcall htcpld_core_init+0x0/0x2b returned -19 after 3906 usecs
calling  wm8994_i2c_init+0x0/0x33 @ 1
i2c-core: driver [wm8994] registered
initcall wm8994_i2c_init+0x0/0x33 returned 0 after 3906 usecs
calling  adp5520_init+0x0/0x14 @ 1
i2c-core: driver [adp5520] registered
initcall adp5520_init+0x0/0x14 returned 0 after 3906 usecs
calling  cmodio_init+0x0/0x1b @ 1
initcall cmodio_init+0x0/0x1b returned 0 after 0 usecs
calling  spi_transport_init+0x0/0x79 @ 1
initcall spi_transport_init+0x0/0x79 returned 0 after 0 usecs
calling  fc_transport_init+0x0/0x8a @ 1
initcall fc_transport_init+0x0/0x8a returned 0 after 0 usecs
calling  sas_transport_init+0x0/0xcc @ 1
initcall sas_transport_init+0x0/0xcc returned 0 after 0 usecs
calling  sas_class_init+0x0/0x31 @ 1
initcall sas_class_init+0x0/0x31 returned 0 after 0 usecs
calling  libfc_init+0x0/0x3b @ 1
initcall libfc_init+0x0/0x3b returned 0 after 0 usecs
calling  fnic_init_module+0x0/0x1e9 @ 1
fnic: Cisco FCoE HBA Driver, ver 1.4.0.145
initcall fnic_init_module+0x0/0x1e9 returned 0 after 3906 usecs
calling  adpt_init+0x0/0xf96 @ 1
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
initcall adpt_init+0x0/0xf96 returned -19 after 7812 usecs
calling  ahc_linux_init+0x0/0x65 @ 1
initcall ahc_linux_init+0x0/0x65 returned 0 after 0 usecs
calling  init_this_scsi_driver+0x0/0xe7 @ 1
initcall init_this_scsi_driver+0x0/0xe7 returned -19 after 0 usecs
calling  aic94xx_init+0x0/0x13a @ 1
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
initcall aic94xx_init+0x0/0x13a returned 0 after 3906 usecs
calling  init_this_scsi_driver+0x0/0xe5 @ 1
scsi: <fdomain> Detection failed (no card)
initcall init_this_scsi_driver+0x0/0xe5 returned -19 after 3906 usecs
calling  bfad_init+0x0/0x9e @ 1
Brocade BFA FC/FCOE SCSI driver - version: 2.1.2.1
initcall bfad_init+0x0/0x9e returned 0 after 3906 usecs
calling  dc390_module_init+0x0/0x99 @ 1
DC390: clustering now enabled by default. If you get problems load
       with "disable_clustering=1" and report to maintainers
initcall dc390_module_init+0x0/0x99 returned 0 after 7812 usecs
calling  megasas_init+0x0/0x1a7 @ 1
megasas: 00.00.04.17.1-rc1 Thu. Oct. 29, 11:41:51 PST 2009
initcall megasas_init+0x0/0x1a7 returned 0 after 3906 usecs
calling  atp870u_init+0x0/0x1b @ 1
initcall atp870u_init+0x0/0x1b returned 0 after 0 usecs
calling  gdth_init+0x0/0xff @ 1
GDT-HA: Storage RAID Controller Driver. Version: 3.05
initcall gdth_init+0x0/0xff returned 0 after 3906 usecs
calling  initio_init_driver+0x0/0x1b @ 1
initcall initio_init_driver+0x0/0x1b returned 0 after 0 usecs
calling  tw_init+0x0/0x30 @ 1
3ware Storage Controller device driver for Linux v1.26.02.003.
initcall tw_init+0x0/0x30 returned 0 after 3906 usecs
calling  hptiop_module_init+0x0/0x37 @ 1
RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
initcall hptiop_module_init+0x0/0x37 returned 0 after 3906 usecs
calling  init_osst+0x0/0x14a @ 1
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
initcall init_osst+0x0/0x14a returned 0 after 3906 usecs
calling  init_sd+0x0/0x161 @ 1
initcall init_sd+0x0/0x161 returned 0 after 0 usecs
calling  ahci_init+0x0/0x1b @ 1
initcall ahci_init+0x0/0x1b returned 0 after 0 usecs
calling  adma_ata_init+0x0/0x1b @ 1
initcall adma_ata_init+0x0/0x1b returned 0 after 3906 usecs
calling  piix_init+0x0/0x29 @ 1
initcall piix_init+0x0/0x29 returned 0 after 0 usecs
calling  nv_init+0x0/0x1b @ 1
initcall nv_init+0x0/0x1b returned 0 after 0 usecs
calling  amd_init+0x0/0x1b @ 1
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: setting latency timer to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
initcall amd_init+0x0/0x1b returned 0 after 19531 usecs
calling  1_async_port_probe+0x0/0xb2 @ 98
calling  2_async_port_probe+0x0/0xb2 @ 97
async_waiting @ 97
calling  atp867x_init+0x0/0x1b @ 1
initcall atp867x_init+0x0/0x1b returned 0 after 0 usecs
calling  cmd64x_init+0x0/0x1b @ 1
initcall cmd64x_init+0x0/0x1b returned 0 after 0 usecs
calling  cy82c693_init+0x0/0x1b @ 1
initcall cy82c693_init+0x0/0x1b returned 0 after 0 usecs
calling  efar_init+0x0/0x1b @ 1
initcall efar_init+0x0/0x1b returned 0 after 0 usecs
calling  hpt3x3_init+0x0/0x1b @ 1
initcall hpt3x3_init+0x0/0x1b returned 0 after 0 usecs
calling  it821x_init+0x0/0x1b @ 1
initcall it821x_init+0x0/0x1b returned 0 after 0 usecs
calling  jmicron_init+0x0/0x1b @ 1
initcall jmicron_init+0x0/0x1b returned 0 after 0 usecs
calling  ns87415_init+0x0/0x1b @ 1
initcall ns87415_init+0x0/0x1b returned 0 after 0 usecs
calling  oldpiix_init+0x0/0x1b @ 1
initcall oldpiix_init+0x0/0x1b returned 0 after 0 usecs
calling  rdc_init+0x0/0x1b @ 1
initcall rdc_init+0x0/0x1b returned 0 after 0 usecs
calling  sc1200_init+0x0/0x1b @ 1
initcall sc1200_init+0x0/0x1b returned 0 after 0 usecs
calling  sch_init+0x0/0x1b @ 1
initcall sch_init+0x0/0x1b returned 0 after 0 usecs
calling  serverworks_init+0x0/0x1b @ 1
initcall serverworks_init+0x0/0x1b returned 0 after 0 usecs
calling  via_init+0x0/0x1b @ 1
initcall via_init+0x0/0x1b returned 0 after 0 usecs
calling  cmd640_init+0x0/0x1b @ 1
initcall cmd640_init+0x0/0x1b returned 0 after 0 usecs
calling  ns87410_init+0x0/0x1b @ 1
initcall ns87410_init+0x0/0x1b returned 0 after 0 usecs
calling  opti_init+0x0/0x1b @ 1
initcall opti_init+0x0/0x1b returned 0 after 0 usecs
calling  pata_platform_init+0x0/0x12 @ 1
initcall pata_platform_init+0x0/0x12 returned 0 after 0 usecs
calling  legacy_init+0x0/0x9e4 @ 1
initcall legacy_init+0x0/0x9e4 returned -19 after 0 usecs
calling  spidev_init+0x0/0xab @ 1
initcall spidev_init+0x0/0xab returned 0 after 0 usecs
calling  marvell_init+0x0/0x5b @ 1
initcall marvell_init+0x0/0x5b returned 0 after 0 usecs
calling  cicada_init+0x0/0x3c @ 1
initcall cicada_init+0x0/0x3c returned 0 after 0 usecs
calling  lxt_init+0x0/0x5e @ 1
initcall lxt_init+0x0/0x5e returned 0 after 0 usecs
calling  smsc_init+0x0/0xa6 @ 1
initcall smsc_init+0x0/0xa6 returned 0 after 0 usecs
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
calling  vsc82xx_init+0x0/0x3c @ 1
initcall vsc82xx_init+0x0/0x3c returned 0 after 0 usecs
calling  et1011c_init+0x0/0x12 @ 1
initcall et1011c_init+0x0/0x12 returned 0 after 0 usecs
calling  fixed_mdio_bus_init+0x0/0xf7 @ 1
Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0xf7 returned 0 after 0 usecs
calling  mdio_gpio_init+0x0/0x12 @ 1
initcall mdio_gpio_init+0x0/0x12 returned 0 after 0 usecs
calling  ste10Xp_init+0x0/0x22 @ 1
initcall ste10Xp_init+0x0/0x22 returned 0 after 0 usecs
ata1.00: configured for UDMA/100
async_waiting @ 98
async_continuing @ 98 after 0 usec
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
initcall 1_async_port_probe+0x0/0xb2 returned 0 after 195312 usecs
calling  3_sd_probe_async+0x0/0x207 @ 98
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
calling  ksphy_init+0x0/0x5e @ 1
initcall ksphy_init+0x0/0x5e returned 0 after 0 usecs
async_continuing @ 97 after 203125 usec
calling  e1000_init_module+0x0/0x87 @ 1
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
initcall e1000_init_module+0x0/0x87 returned 0 after 11718 usecs
calling  e1000_init_module+0x0/0x3e @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
initcall e1000_init_module+0x0/0x3e returned 0 after 7812 usecs
calling  t1_init_module+0x0/0x1b @ 1
initcall t1_init_module+0x0/0x1b returned 0 after 0 usecs
calling  atl1c_init_module+0x0/0x1b @ 1
initcall atl1c_init_module+0x0/0x1b returned 0 after 0 usecs
calling  bdx_module_init+0x0/0x7a @ 1
tehuti: Tehuti Networks(R) Network Driver, 7.29.3
tehuti: Options: hw_csum 
initcall bdx_module_init+0x0/0x7a returned 0 after 7812 usecs
calling  vmxnet3_init_module+0x0/0x37 @ 1
VMware vmxnet3 virtual NIC driver - version 1.0.5.0-k-NAPI
initcall vmxnet3_init_module+0x0/0x37 returned 0 after 3906 usecs
calling  happy_meal_probe+0x0/0x1b @ 1
initcall happy_meal_probe+0x0/0x1b returned 0 after 0 usecs
calling  cas_init+0x0/0x3d @ 1
initcall cas_init+0x0/0x3d returned 0 after 0 usecs
calling  vortex_init+0x0/0xac @ 1
initcall vortex_init+0x0/0xac returned 0 after 0 usecs
calling  typhoon_init+0x0/0x1b @ 1
initcall typhoon_init+0x0/0x1b returned 0 after 0 usecs
calling  e100_init_module+0x0/0x5d @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x5d returned 0 after 7812 usecs
calling  r6040_init+0x0/0x1b @ 1
initcall r6040_init+0x0/0x1b returned 0 after 0 usecs
calling  acenic_init+0x0/0x1b @ 1
initcall acenic_init+0x0/0x1b returned 0 after 0 usecs
calling  ns83820_init+0x0/0x29 @ 1
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
initcall ns83820_init+0x0/0x29 returned 0 after 3906 usecs
calling  fealnx_init+0x0/0x1b @ 1
initcall fealnx_init+0x0/0x1b returned 0 after 0 usecs
calling  tg3_init+0x0/0x1b @ 1
initcall tg3_init+0x0/0x1b returned 0 after 0 usecs
calling  bnx2_init+0x0/0x1b @ 1
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
initcall bnx2_init+0x0/0x1b returned 0 after 0 usecs
calling  bnx2x_init+0x0/0x97 @ 1
Broadcom NetXtreme II 5771x 10Gigabit Ethernet Driver bnx2x 1.52.53-1 (2010/18/04)
initcall bnx2x_init+0x0/0x97 returned 0 after 11718 usecs
calling  skge_init_module+0x0/0x59 @ 1
initcall skge_init_module+0x0/0x59 returned 0 after 0 usecs
calling  sky2_init_module+0x0/0x57 @ 1
sky2: driver version 1.28
initcall sky2_init_module+0x0/0x57 returned 0 after 0 usecs
calling  ks8851_init+0x0/0x12 @ 1
initcall ks8851_init+0x0/0x12 returned 0 after 0 usecs
calling  ksz884x_init_module+0x0/0x1b @ 1
initcall ksz884x_init_module+0x0/0x1b returned 0 after 0 usecs
calling  rhine_init+0x0/0x63 @ 1
initcall rhine_init+0x0/0x63 returned 0 after 0 usecs
calling  velocity_init_module+0x0/0x1b @ 1
initcall velocity_init_module+0x0/0x1b returned 0 after 0 usecs
calling  hamachi_init+0x0/0x1b @ 1
initcall hamachi_init+0x0/0x1b returned 0 after 0 usecs
calling  net_olddevs_init+0x0/0xae @ 1
initcall net_olddevs_init+0x0/0xae returned 0 after 0 usecs
calling  hp100_module_init+0x0/0x1b @ 1
initcall hp100_module_init+0x0/0x1b returned 0 after 0 usecs
calling  b44_init+0x0/0x60 @ 1
initcall b44_init+0x0/0x60 returned 0 after 0 usecs
calling  init_nic+0x0/0x1b @ 1
 sda:
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
forcedeth 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 35
forcedeth 0000:00:0a.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
 sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
ata2: nv_mode_filter: 0x1f39f&0x73ff->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
sd 0:0:0:0: [sda] Attached SCSI disk
initcall 3_sd_probe_async+0x0/0x207 returned 0 after 316406 usecs
ata2.01: configured for UDMA/33
async_waiting @ 97
async_continuing @ 97 after 0 usec
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
initcall 2_async_port_probe+0x0/0xb2 returned 0 after 570312 usecs
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
initcall init_nic+0x0/0x1b returned 0 after 519531 usecs
calling  ql3xxx_init_module+0x0/0x1b @ 1
initcall ql3xxx_init_module+0x0/0x1b returned 0 after 0 usecs
calling  qlcnic_init_module+0x0/0x48 @ 1
QLogic Converged Ethernet Driver v5.0.2
initcall qlcnic_init_module+0x0/0x48 returned 0 after 3906 usecs
calling  ppp_init+0x0/0xe1 @ 1
PPP generic driver version 2.4.2
initcall ppp_init+0x0/0xe1 returned 0 after 0 usecs
calling  deflate_init+0x0/0x3b @ 1
PPP Deflate Compression module registered
initcall deflate_init+0x0/0x3b returned 0 after 3906 usecs
calling  dummy_init_module+0x0/0xb7 @ 1
initcall dummy_init_module+0x0/0xb7 returned 0 after 3906 usecs
calling  macvlan_init_module+0x0/0x53 @ 1
initcall macvlan_init_module+0x0/0x53 returned 0 after 0 usecs
calling  rtl8139_init_module+0x0/0x1b @ 1
8139too: 8139too Fast Ethernet driver 0.9.28
8139too 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 35
8139too 0000:05:07.0: eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 35
initcall rtl8139_init_module+0x0/0x1b returned 0 after 11718 usecs
calling  rtl8169_init_module+0x0/0x1b @ 1
initcall rtl8169_init_module+0x0/0x1b returned 0 after 0 usecs
calling  hdlc_module_init+0x0/0x41 @ 1
HDLC support module revision 1.22
initcall hdlc_module_init+0x0/0x41 returned 0 after 3906 usecs
calling  mod_init+0x0/0x14 @ 1
initcall mod_init+0x0/0x14 returned 0 after 0 usecs
calling  mod_init+0x0/0x14 @ 1
initcall mod_init+0x0/0x14 returned 0 after 0 usecs
calling  init_lmc+0x0/0x1b @ 1
initcall init_lmc+0x0/0x1b returned 0 after 0 usecs
calling  catc_init+0x0/0x39 @ 1
usbcore: registered new interface driver catc
catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
initcall catc_init+0x0/0x39 returned 0 after 7812 usecs
calling  kaweth_init+0x0/0x1b @ 1
usbcore: registered new interface driver kaweth
initcall kaweth_init+0x0/0x1b returned 0 after 3906 usecs
calling  tulip_init+0x0/0x33 @ 1
initcall tulip_init+0x0/0x33 returned 0 after 0 usecs
calling  usb_irda_init+0x0/0x3a @ 1
usbcore: registered new interface driver irda-usb
USB IrDA support registered
initcall usb_irda_init+0x0/0x3a returned 0 after 7812 usecs
calling  nsc_ircc_init+0x0/0x21a @ 1
initcall nsc_ircc_init+0x0/0x21a returned -19 after 0 usecs
calling  w83977af_init+0x0/0x615 @ 1
w83977af_init()
w83977af_open()
w83977af_probe()
w83977af_probe(), Wrong chip version
w83977af_probe()
w83977af_probe(), Wrong chip versioninitcall w83977af_init+0x0/0x615 returned -19 after 11718 usecs
calling  vlsi_mod_init+0x0/0x133 @ 1
initcall vlsi_mod_init+0x0/0x133 returned 0 after 3906 usecs
calling  init_netconsole+0x0/0x1be @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1be returned 0 after 3906 usecs
calling  fusion_init+0x0/0x13b @ 1
Fusion MPT base driver 3.04.15
Copyright (c) 1999-2008 LSI Corporation
initcall fusion_init+0x0/0x13b returned 0 after 7812 usecs
calling  mptspi_init+0x0/0xe0 @ 1
Fusion MPT SPI Host driver 3.04.15
initcall mptspi_init+0x0/0xe0 returned 0 after 3906 usecs
calling  mptfc_init+0x0/0xf3 @ 1
Fusion MPT FC Host driver 3.04.15
initcall mptfc_init+0x0/0xf3 returned 0 after 3906 usecs
calling  mptsas_init+0x0/0x10e @ 1
Fusion MPT SAS Host driver 3.04.15
initcall mptsas_init+0x0/0x10e returned 0 after 3906 usecs
calling  mpt_lan_init+0x0/0x7f @ 1
Fusion MPT LAN driver 3.04.15
initcall mpt_lan_init+0x0/0x7f returned 0 after 0 usecs
calling  pcilynx_init+0x0/0x3c @ 1
initcall pcilynx_init+0x0/0x3c returned 0 after 0 usecs
calling  gpio_vbus_init+0x0/0x19 @ 1
initcall gpio_vbus_init+0x0/0x19 returned -19 after 0 usecs
calling  mon_init+0x0/0x116 @ 1
initcall mon_init+0x0/0x116 returned 0 after 0 usecs
calling  ehci_hcd_init+0x0/0xe7 @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
work_for_cpu used greatest stack depth: 5264 bytes left
ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
initcall ehci_hcd_init+0x0/0xe7 returned 0 after 23437 usecs
calling  isp116x_init+0x0/0x3e @ 1
116x: driver isp116x-hcd, 03 Nov 2005
initcall isp116x_init+0x0/0x3e returned 0 after 3906 usecs
calling  isp1362_init+0x0/0x3e @ 1
driver isp1362-hcd, 2005-04-04
initcall isp1362_init+0x0/0x3e returned 0 after 3906 usecs
calling  ohci_hcd_mod_init+0x0/0xda @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
initcall ohci_hcd_mod_init+0x0/0xda returned 0 after 19531 usecs
calling  uhci_hcd_init+0x0/0x101 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
initcall uhci_hcd_init+0x0/0x101 returned 0 after 7812 usecs
calling  sl811h_init+0x0/0x3e @ 1
sl811: driver sl811-hcd, 19 May 2005
initcall sl811h_init+0x0/0x3e returned 0 after 0 usecs
calling  u132_hcd_init+0x0/0xaf @ 1
driver u132_hcd built at 11:03:24 on Jul  5 2010
initcall u132_hcd_init+0x0/0xaf returned 0 after 3906 usecs
calling  isp1760_init+0x0/0x50 @ 1
initcall isp1760_init+0x0/0x50 returned 0 after 0 usecs
calling  usblp_init+0x0/0x1b @ 1
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x1b returned 0 after 3906 usecs
calling  usb_mdc800_init+0x0/0x28b @ 1
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
initcall usb_mdc800_init+0x0/0x28b returned 0 after 11718 usecs
calling  adu_init+0x0/0xa4 @ 1
drivers/usb/misc/adutux.c:  adu_init : enter
usbcore: registered new interface driver adutux
adutux adutux (see www.ontrak.net) v0.0.13
adutux is an experimental driver. Use at your own risk
drivers/usb/misc/adutux.c:  adu_init : leave, return value 0
initcall adu_init+0x0/0xa4 returned 0 after 19531 usecs
calling  appledisplay_init+0x0/0x59 @ 1
usbcore: registered new interface driver appledisplay
initcall appledisplay_init+0x0/0x59 returned 0 after 3906 usecs
calling  ftdi_elan_init+0x0/0x16e @ 1
driver ftdi-elan built at 11:03:17 on Jul  5 2010
usbcore: registered new interface driver ftdi-elan
initcall ftdi_elan_init+0x0/0x16e returned 0 after 7812 usecs
calling  isight_firmware_init+0x0/0x1b @ 1
usbcore: registered new interface driver isight_firmware
initcall isight_firmware_init+0x0/0x1b returned 0 after 3906 usecs
calling  ld_usb_init+0x0/0x41 @ 1
usbcore: registered new interface driver ldusb
initcall ld_usb_init+0x0/0x41 returned 0 after 3906 usecs
calling  usbtest_init+0x0/0x3f @ 1
usbcore: registered new interface driver usbtest
initcall usbtest_init+0x0/0x3f returned 0 after 7812 usecs
calling  kgdbdbgp_start_thread+0x0/0x4c @ 1
initcall kgdbdbgp_start_thread+0x0/0x4c returned 0 after 0 usecs
calling  i8042_init+0x0/0xd9 @ 1
async/1 used greatest stack depth: 4464 bytes left
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0xd9 returned 0 after 523437 usecs
calling  serio_raw_init+0x0/0x1b @ 1
initcall serio_raw_init+0x0/0x1b returned 0 after 0 usecs
calling  altera_ps2_init+0x0/0x12 @ 1
initcall altera_ps2_init+0x0/0x12 returned 0 after 0 usecs
calling  mousedev_init+0x0/0x62 @ 1
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x62 returned 0 after 3906 usecs
calling  adp5520_keys_init+0x0/0x12 @ 1
initcall adp5520_keys_init+0x0/0x12 returned 0 after 0 usecs
calling  atkbd_init+0x0/0x27 @ 1
initcall atkbd_init+0x0/0x27 returned 0 after 0 usecs
calling  matrix_keypad_init+0x0/0x12 @ 1
initcall matrix_keypad_init+0x0/0x12 returned 0 after 0 usecs
calling  max7359_init+0x0/0x14 @ 1
i2c-core: driver [max7359] registered
initcall max7359_init+0x0/0x14 returned 0 after 3906 usecs
calling  opencores_kbd_init+0x0/0x12 @ 1
initcall opencores_kbd_init+0x0/0x12 returned 0 after 0 usecs
calling  xtkbd_init+0x0/0x1b @ 1
initcall xtkbd_init+0x0/0x1b returned 0 after 0 usecs
calling  atp_init+0x0/0x1b @ 1
usbcore: registered new interface driver appletouch
initcall atp_init+0x0/0x1b returned 0 after 3906 usecs
calling  bcm5974_init+0x0/0x1b @ 1
usbcore: registered new interface driver bcm5974
initcall bcm5974_init+0x0/0x1b returned 0 after 3906 usecs
calling  gpio_mouse_init+0x0/0x12 @ 1
initcall gpio_mouse_init+0x0/0x12 returned 0 after 0 usecs
calling  sermouse_init+0x0/0x1b @ 1
initcall sermouse_init+0x0/0x1b returned 0 after 0 usecs
calling  usb_acecad_init+0x0/0x38 @ 1
usbcore: registered new interface driver usb_acecad
acecad: v3.2:USB Acecad Flair tablet driver
initcall usb_acecad_init+0x0/0x38 returned 0 after 7812 usecs
calling  gtco_init+0x0/0x51 @ 1
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006initcall gtco_init+0x0/0x51 returned 0 after 3906 usecs
calling  pm860x_touch_init+0x0/0x12 @ 1
initcall pm860x_touch_init+0x0/0x12 returned 0 after 0 usecs
calling  ad7879_init+0x0/0x12 @ 1
initcall ad7879_init+0x0/0x12 returned 0 after 0 usecs
calling  eeti_ts_init+0x0/0x14 @ 1
i2c-core: driver [eeti_ts] registered
initcall eeti_ts_init+0x0/0x14 returned 0 after 0 usecs
calling  pm_init+0x0/0x1b @ 1
initcall pm_init+0x0/0x1b returned 0 after 0 usecs
calling  da9034_touch_init+0x0/0x12 @ 1
initcall da9034_touch_init+0x0/0x12 returned 0 after 0 usecs
calling  i2c_smbus_init+0x0/0x14 @ 1
i2c-core: driver [smbus_alert] registered
initcall i2c_smbus_init+0x0/0x14 returned 0 after 3906 usecs
calling  i2c_ali1535_init+0x0/0x1b @ 1
initcall i2c_ali1535_init+0x0/0x1b returned 0 after 0 usecs
calling  ali1563_init+0x0/0x1b @ 1
initcall ali1563_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_sis5595_init+0x0/0x1b @ 1
initcall i2c_sis5595_init+0x0/0x1b returned 0 after 0 usecs
calling  i2c_parport_init+0x0/0x163 @ 1
i2c-parport-light: adapter type unspecified
initcall i2c_parport_init+0x0/0x163 returned -19 after 3906 usecs
calling  usb_i2c_tiny_usb_init+0x0/0x1b @ 1
usbcore: registered new interface driver i2c-tiny-usb
initcall usb_i2c_tiny_usb_init+0x0/0x1b returned 0 after 3906 usecs
calling  usb_pcwd_init+0x0/0x4b @ 1
usbcore: registered new interface driver pcwd_usb
pcwd_usb: Berkshire USB-PC Watchdog driver v1.02
initcall usb_pcwd_init+0x0/0x4b returned 0 after 7812 usecs
calling  advwdt_init+0x0/0x5f @ 1
WDT driver for Advantech single board computer initialising.
advantechwdt: initialized. timeout=60 sec (nowayout=1)
initcall advwdt_init+0x0/0x5f returned 0 after 7812 usecs
calling  ibwdt_init+0x0/0x5f @ 1
ib700wdt: WDT driver for IB700 single board computer initialising.
ib700wdt: START method I/O 443 is not available.
ib700wdt: probe of ib700wdt failed with error -5
initcall ibwdt_init+0x0/0x5f returned 0 after 15625 usecs
calling  ibmasr_init+0x0/0x263 @ 1
initcall ibmasr_init+0x0/0x263 returned -19 after 0 usecs
calling  watchdog_init+0x0/0x1b @ 1
initcall watchdog_init+0x0/0x1b returned 0 after 0 usecs
calling  it8712f_wdt_init+0x0/0x1f1 @ 1
it8712f_wdt: Found IT8712F chip revision 7 - using DogFood address 0x201
it8712f_wdt: disabling watchdog timer
it8712f_wdt: cannot register miscdev on minor=130 (err=-16)
initcall it8712f_wdt_init+0x0/0x1f1 returned -16 after 15625 usecs
initcall it8712f_wdt_init+0x0/0x1f1 returned with error code -16 
calling  sc1200wdt_init+0x0/0x117 @ 1
sc1200wdt: build 20020303
sc1200wdt: io parameter must be specified
initcall sc1200wdt_init+0x0/0x117 returned -22 after 3906 usecs
initcall sc1200wdt_init+0x0/0x117 returned with error code -22 
calling  wdt_init+0x0/0x1eb @ 1
WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
w83627hf/thf/hg WDT: cannot register miscdev on minor=130 (err=-16)
initcall wdt_init+0x0/0x1eb returned -16 after 19531 usecs
initcall wdt_init+0x0/0x1eb returned with error code -16 
calling  w83977f_wdt_init+0x0/0x147 @ 1
W83977F WDT: W83977F WDT driver, v1.00
W83977F WDT: cannot register miscdev on minor=130 (err=-16)
initcall w83977f_wdt_init+0x0/0x147 returned -16 after 11718 usecs
initcall w83977f_wdt_init+0x0/0x147 returned with error code -16 
calling  zf_init+0x0/0x164 @ 1
machzwd: MachZ ZF-Logic Watchdog driver initializing.
machzwd: no ZF-Logic found
initcall zf_init+0x0/0x164 returned -19 after 7812 usecs
calling  dm_init+0x0/0x46 @ 1
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
initcall dm_init+0x0/0x46 returned 0 after 7812 usecs
calling  dm_crypt_init+0x0/0x69 @ 1
initcall dm_crypt_init+0x0/0x69 returned 0 after 0 usecs
calling  dm_mirror_init+0x0/0x79 @ 1
initcall dm_mirror_init+0x0/0x79 returned 0 after 0 usecs
calling  dm_dirty_log_init+0x0/0x59 @ 1
initcall dm_dirty_log_init+0x0/0x59 returned 0 after 0 usecs
calling  gigaset_init_module+0x0/0x2e @ 1
gigaset: Driver for Gigaset 307x
gigaset: no ISDN subsystem interface
initcall gigaset_init_module+0x0/0x2e returned 0 after 7812 usecs
calling  usb_gigaset_init+0x0/0x97 @ 1
usbcore: registered new interface driver usb_gigaset
usb_gigaset: USB Driver for Gigaset 307x using M105
initcall usb_gigaset_init+0x0/0x97 returned 0 after 11718 usecs
input: AT Translated Set 2 keyboard as /class/input/input0
calling  bas_gigaset_init+0x0/0x97 @ 1
usbcore: registered new interface driver bas_gigaset
bas_gigaset: USB Driver for Gigaset 307x
initcall bas_gigaset_init+0x0/0x97 returned 0 after 7812 usecs
calling  ser_gigaset_init+0x0/0xb2 @ 1
initcall ser_gigaset_init+0x0/0xb2 returned 0 after 0 usecs
calling  cpufreq_gov_powersave_init+0x0/0x12 @ 1
initcall cpufreq_gov_powersave_init+0x0/0x12 returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0xa9 @ 1
initcall cpufreq_gov_dbs_init+0x0/0xa9 returned 0 after 7812 usecs
calling  init_ladder+0x0/0x12 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x12 returned 0 after 0 usecs
calling  mmc_blk_init+0x0/0x46 @ 1
initcall mmc_blk_init+0x0/0x46 returned 0 after 3906 usecs
calling  mmc_test_init+0x0/0x12 @ 1
initcall mmc_test_init+0x0/0x12 returned 0 after 0 usecs
calling  sdio_uart_init+0x0/0xf1 @ 1
initcall sdio_uart_init+0x0/0xf1 returned 0 after 0 usecs
calling  tifm_sd_init+0x0/0x12 @ 1
initcall tifm_sd_init+0x0/0x12 returned 0 after 0 usecs
calling  cb710_mmc_init_module+0x0/0x12 @ 1
initcall cb710_mmc_init_module+0x0/0x12 returned 0 after 0 usecs
calling  dcdrbu_init+0x0/0x14a @ 1
initcall dcdrbu_init+0x0/0x14a returned 0 after 0 usecs
calling  vhost_net_init+0x0/0x33 @ 1
initcall vhost_net_init+0x0/0x33 returned 0 after 0 usecs
calling  flow_cache_init_global+0x0/0x16f @ 1
initcall flow_cache_init_global+0x0/0x16f returned 0 after 0 usecs
calling  pg_init+0x0/0x2e3 @ 1
pktgen 2.73: Packet Generator for packet performance testing.
initcall pg_init+0x0/0x2e3 returned 0 after 7812 usecs
calling  llc_init+0x0/0x20 @ 1
initcall llc_init+0x0/0x20 returned 0 after 0 usecs
calling  snap_init+0x0/0x39 @ 1
initcall snap_init+0x0/0x39 returned 0 after 0 usecs
calling  blackhole_module_init+0x0/0x12 @ 1
initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
calling  hfsc_init+0x0/0x12 @ 1
initcall hfsc_init+0x0/0x12 returned 0 after 0 usecs
calling  dsmark_module_init+0x0/0x12 @ 1
initcall dsmark_module_init+0x0/0x12 returned 0 after 0 usecs
calling  sfq_module_init+0x0/0x12 @ 1
initcall sfq_module_init+0x0/0x12 returned 0 after 0 usecs
calling  prio_module_init+0x0/0x12 @ 1
initcall prio_module_init+0x0/0x12 returned 0 after 0 usecs
calling  netem_module_init+0x0/0x20 @ 1
netem: version 1.2
initcall netem_module_init+0x0/0x20 returned 0 after 3906 usecs
calling  init_u32+0x0/0x20 @ 1
u32 classifier
initcall init_u32+0x0/0x20 returned 0 after 0 usecs
calling  init_fw+0x0/0x12 @ 1
initcall init_fw+0x0/0x12 returned 0 after 0 usecs
calling  init_basic+0x0/0x12 @ 1
initcall init_basic+0x0/0x12 returned 0 after 0 usecs
calling  cls_flow_init+0x0/0x12 @ 1
initcall cls_flow_init+0x0/0x12 returned 0 after 0 usecs
calling  xt_init+0x0/0x159 @ 1
initcall xt_init+0x0/0x159 returned 0 after 0 usecs
calling  tcpudp_mt_init+0x0/0x17 @ 1
initcall tcpudp_mt_init+0x0/0x17 returned 0 after 0 usecs
calling  secmark_tg_init+0x0/0x12 @ 1
initcall secmark_tg_init+0x0/0x12 returned 0 after 0 usecs
calling  tcpmss_tg_init+0x0/0x17 @ 1
initcall tcpmss_tg_init+0x0/0x17 returned 0 after 0 usecs
calling  policy_mt_init+0x0/0x17 @ 1
initcall policy_mt_init+0x0/0x17 returned 0 after 0 usecs
calling  sysctl_ipv4_init+0x0/0x8b @ 1
initcall sysctl_ipv4_init+0x0/0x8b returned 0 after 0 usecs
calling  ipip_init+0x0/0x60 @ 1
IPv4 over IPv4 tunneling driver
initcall ipip_init+0x0/0x60 returned 0 after 3906 usecs
calling  init_syncookies+0x0/0x19 @ 1
initcall init_syncookies+0x0/0x19 returned 0 after 0 usecs
calling  ah4_init+0x0/0x66 @ 1
initcall ah4_init+0x0/0x66 returned 0 after 0 usecs
calling  xfrm4_beet_init+0x0/0x17 @ 1
initcall xfrm4_beet_init+0x0/0x17 returned 0 after 0 usecs
calling  tunnel4_init+0x0/0x66 @ 1
initcall tunnel4_init+0x0/0x66 returned 0 after 0 usecs
calling  ipv4_netfilter_init+0x0/0x17 @ 1
initcall ipv4_netfilter_init+0x0/0x17 returned 0 after 0 usecs
calling  ip_tables_init+0x0/0xaa @ 1
ip_tables: (C) 2000-2006 Netfilter Core Team
initcall ip_tables_init+0x0/0xaa returned 0 after 3906 usecs
calling  bictcp_register+0x0/0x12 @ 1
TCP bic registered
initcall bictcp_register+0x0/0x12 returned 0 after 0 usecs
calling  htcp_register+0x0/0x12 @ 1
TCP htcp registered
initcall htcp_register+0x0/0x12 returned 0 after 0 usecs
calling  tcp_veno_register+0x0/0x14 @ 1
TCP veno registered
initcall tcp_veno_register+0x0/0x14 returned 0 after 3906 usecs
calling  tcp_scalable_register+0x0/0x12 @ 1
TCP scalable registered
initcall tcp_scalable_register+0x0/0x12 returned 0 after 3906 usecs
calling  inet6_init+0x0/0x2ba @ 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
initcall inet6_init+0x0/0x2ba returned 0 after 19531 usecs
calling  xfrm6_ro_init+0x0/0x17 @ 1
initcall xfrm6_ro_init+0x0/0x17 returned 0 after 0 usecs
calling  xfrm6_beet_init+0x0/0x17 @ 1
initcall xfrm6_beet_init+0x0/0x17 returned 0 after 0 usecs
calling  mip6_init+0x0/0xba @ 1
Mobile IPv6
initcall mip6_init+0x0/0xba returned 0 after 3906 usecs
calling  sit_init+0x0/0x60 @ 1
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
initcall sit_init+0x0/0x60 returned 0 after 7812 usecs
calling  packet_init+0x0/0x47 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x47 returned 0 after 3906 usecs
calling  ipsec_pfkey_init+0x0/0x82 @ 1
NET: Registered protocol family 15
initcall ipsec_pfkey_init+0x0/0x82 returned 0 after 3906 usecs
calling  irlan_init+0x0/0x2f9 @ 1
initcall irlan_init+0x0/0x2f9 returned 0 after 3906 usecs
calling  irnet_init+0x0/0x1b @ 1
initcall irnet_init+0x0/0x1b returned 0 after 3906 usecs
calling  ircomm_init+0x0/0x9a @ 1
IrCOMM protocol (Dag Brattli)
initcall ircomm_init+0x0/0x9a returned 0 after 0 usecs
calling  ircomm_tty_init+0x0/0x130 @ 1
initcall ircomm_tty_init+0x0/0x130 returned 0 after 7812 usecs
calling  init_rpcsec_gss+0x0/0x4d @ 1
initcall init_rpcsec_gss+0x0/0x4d returned 0 after 0 usecs
calling  init_kerberos_module+0x0/0x2f @ 1
initcall init_kerberos_module+0x0/0x2f returned 0 after 0 usecs
calling  init_spkm3_module+0x0/0x2f @ 1
initcall init_spkm3_module+0x0/0x2f returned 0 after 0 usecs
calling  decnet_init+0x0/0x90 @ 1
NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
DECnet: Routing cache hash table of 512 buckets, 36Kbytes
NET: Registered protocol family 12
initcall decnet_init+0x0/0x90 returned 0 after 15625 usecs
calling  phonet_init+0x0/0x7d @ 1
NET: Registered protocol family 35
initcall phonet_init+0x0/0x7d returned 0 after 3906 usecs
calling  pep_register+0x0/0x17 @ 1
initcall pep_register+0x0/0x17 returned 0 after 0 usecs
calling  vlan_proto_init+0x0/0xba @ 1
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
initcall vlan_proto_init+0x0/0xba returned 0 after 11718 usecs
calling  dccp_init+0x0/0x369 @ 1
CCID: Activated CCID 2 (TCP-like)
CCID: Activated CCID 3 (TCP-Friendly Rate Control)
initcall dccp_init+0x0/0x369 returned 0 after 11718 usecs
calling  dccp_v4_init+0x0/0x86 @ 1
initcall dccp_v4_init+0x0/0x86 returned 0 after 0 usecs
calling  dccp_v6_init+0x0/0x86 @ 1
initcall dccp_v6_init+0x0/0x86 returned 0 after 0 usecs
calling  sctp_init+0x0/0x819 @ 1
SCTP: Hash tables configured (established 14563 bind 14563)
sctp_init_sock(sk: ffff88003de95000)
initcall sctp_init+0x0/0x819 returned 0 after 23437 usecs
calling  lib80211_init+0x0/0x20 @ 1
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
initcall lib80211_init+0x0/0x20 returned 0 after 7812 usecs
calling  tipc_init+0x0/0xb6 @ 1
TIPC: Activated (version 2.0.0 compiled Jul  5 2010 11:03:11)
NET: Registered protocol family 30
TIPC: Started in single node mode
initcall tipc_init+0x0/0xb6 returned 0 after 11718 usecs
calling  dcbnl_init+0x0/0x32 @ 1
initcall dcbnl_init+0x0/0x32 returned 0 after 0 usecs
calling  wimax_subsys_init+0x0/0x34f @ 1
initcall wimax_subsys_init+0x0/0x34f returned 0 after 0 usecs
calling  update_mp_table+0x0/0x5fa @ 1
initcall update_mp_table+0x0/0x5fa returned 0 after 0 usecs
calling  lapic_insert_resource+0x0/0x3f @ 1
initcall lapic_insert_resource+0x0/0x3f returned 0 after 0 usecs
calling  io_apic_bug_finalize+0x0/0x1b @ 1
initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x65 @ 1
initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
calling  pat_memtype_list_init+0x0/0x32 @ 1
initcall pat_memtype_list_init+0x0/0x32 returned 0 after 0 usecs
calling  sched_init_debug+0x0/0x24 @ 1
initcall sched_init_debug+0x0/0x24 returned 0 after 0 usecs
calling  init_oops_id+0x0/0x36 @ 1
initcall init_oops_id+0x0/0x36 returned 0 after 0 usecs
calling  disable_boot_consoles+0x0/0x5c @ 1
initcall disable_boot_consoles+0x0/0x5c returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0xca @ 1
initcall pm_qos_power_init+0x0/0xca returned 0 after 0 usecs
calling  taskstats_init+0x0/0x95 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0x95 returned 0 after 0 usecs
calling  clear_boot_tracer+0x0/0x2d @ 1
initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
calling  event_trace_self_tests_init+0x0/0x41 @ 1
Running tests on trace events:
Testing event kfree_skb: OK
Testing event skb_copy_datagram_iovec: OK
Testing event scsi_dispatch_cmd_start: OK
Testing event scsi_dispatch_cmd_error: OK
Testing event scsi_dispatch_cmd_done: OK
Testing event scsi_dispatch_cmd_timeout: OK
Testing event scsi_eh_wakeup: OK
Testing event lock_kernel: OK
Testing event unlock_kernel: OK
Testing event block_rq_abort: OK
Testing event block_rq_requeue: OK
Testing event block_rq_complete: OK
Testing event block_rq_insert: OK
Testing event block_rq_issue: OK
Testing event block_bio_bounce: OK
Testing event block_bio_complete: OK
Testing event block_bio_backmerge: OK
Testing event block_bio_frontmerge: OK
Testing event block_bio_queue: OK
Testing event block_getrq: OK
Testing event block_sleeprq: OK
Testing event block_plug: OK
Testing event block_unplug_timer: OK
Testing event block_unplug_io: OK
Testing event block_split: OK
Testing event block_remap: OK
Testing event block_rq_remap: OK
Testing event xfs_attr_list_sf: OK
Testing event xfs_attr_list_sf_all: OK
Testing event xfs_attr_list_leaf: OK
Testing event xfs_attr_list_leaf_end: OK
Testing event xfs_attr_list_full: OK
Testing event xfs_attr_list_add: OK
Testing event xfs_attr_list_wrong_blk: OK
Testing event xfs_attr_list_notfound: OK
Testing event xfs_perag_get: OK
Testing event xfs_perag_put: OK
Testing event xfs_attr_list_node_descend: OK
Testing event xfs_iext_insert: OK
Testing event xfs_iext_remove: OK
Testing event xfs_bmap_pre_update: OK
Testing event xfs_bmap_post_update: OK
Testing event xfs_extlist: OK
Testing event xfs_buf_init: OK
Testing event xfs_buf_free: OK
Testing event xfs_buf_hold: OK
Testing event xfs_buf_rele: OK
Testing event xfs_buf_pin: OK
Testing event xfs_buf_unpin: OK
Testing event xfs_buf_iodone: OK
Testing event xfs_buf_iorequest: OK
Testing event xfs_buf_bawrite: OK
Testing event xfs_buf_bdwrite: OK
Testing event xfs_buf_lock: OK
Testing event xfs_buf_lock_done: OK
Testing event xfs_buf_cond_lock: OK
Testing event xfs_buf_unlock: OK
Testing event xfs_buf_ordered_retry: OK
Testing event xfs_buf_iowait: OK
Testing event xfs_buf_iowait_done: OK
Testing event xfs_buf_delwri_queue: OK
Testing event xfs_buf_delwri_dequeue: OK
Testing event xfs_buf_delwri_split: OK
Testing event xfs_buf_get_noaddr: OK
Testing event xfs_bdstrat_shut: OK
Testing event xfs_buf_item_relse: OK
Testing event xfs_buf_item_iodone: OK
Testing event xfs_buf_item_iodone_async: OK
Testing event xfs_buf_error_relse: OK
Testing event xfs_trans_read_buf_io: OK
Testing event xfs_trans_read_buf_shut: OK
Testing event xfs_btree_corrupt: OK
Testing event xfs_da_btree_corrupt: OK
Testing event xfs_reset_dqcounts: OK
Testing event xfs_inode_item_push: OK
Testing event xfs_buf_find: OK
Testing event xfs_buf_get: OK
Testing event xfs_buf_read: OK
Testing event xfs_buf_ioerror: OK
Testing event xfs_buf_item_size: OK
Testing event xfs_buf_item_size_stale: OK
Testing event xfs_buf_item_format: OK
Testing event xfs_buf_item_format_stale: OK
Testing event xfs_buf_item_pin: OK
Testing event xfs_buf_item_unpin: OK
Testing event xfs_buf_item_unpin_stale: OK
Testing event xfs_buf_item_trylock: OK
Testing event xfs_buf_item_unlock: OK
Testing event xfs_buf_item_unlock_stale: OK
Testing event xfs_buf_item_committed: OK
Testing event xfs_buf_item_push: OK
Testing event xfs_buf_item_pushbuf: OK
Testing event xfs_trans_get_buf: OK
Testing event xfs_trans_get_buf_recur: OK
Testing event xfs_trans_getsb: OK
Testing event xfs_trans_getsb_recur: OK
Testing event xfs_trans_read_buf: OK
Testing event xfs_trans_read_buf_recur: OK
Testing event xfs_trans_log_buf: OK
Testing event xfs_trans_brelse: OK
Testing event xfs_trans_bjoin: OK
Testing event xfs_trans_bhold: OK
Testing event xfs_trans_bhold_release: OK
Testing event xfs_trans_binval: OK
Testing event xfs_ilock: OK
Testing event xfs_ilock_nowait: OK
Testing event xfs_ilock_demote: OK
Testing event xfs_iunlock: OK
Testing event xfs_iget_skip: OK
Testing event xfs_iget_reclaim: OK
Testing event xfs_iget_found: OK
Testing event xfs_iget_alloc: OK
Testing event xfs_ihold: OK
Testing event xfs_irele: OK
Testing event xfs_inode_pin: OK
Testing event xfs_inode_unpin: OK
Testing event xfs_inode_unpin_nowait: OK
Testing event xfs_inode: OK
Testing event xfs_dqadjust: OK
Testing event xfs_dqreclaim_want: OK
Testing event xfs_dqreclaim_dirty: OK
Testing event xfs_dqreclaim_unlink: OK
Testing event xfs_dqattach_found: OK
Testing event xfs_dqattach_get: OK
Testing event xfs_dqinit: OK
Testing event xfs_dqreuse: OK
Testing event xfs_dqalloc: OK
Testing event xfs_dqtobp_read: OK
Testing event xfs_dqread: OK
Testing event xfs_dqread_fail: OK
Testing event xfs_dqlookup_found: OK
Testing event xfs_dqlookup_want: OK
Testing event xfs_dqlookup_freelist: OK
Testing event xfs_dqlookup_done: OK
Testing event xfs_dqget_hit: OK
Testing event xfs_dqget_miss: OK
Testing event xfs_dqput: OK
Testing event xfs_dqput_wait: OK
Testing event xfs_dqput_free: OK
Testing event xfs_dqrele: OK
Testing event xfs_dqflush: OK
Testing event xfs_dqflush_force: OK
Testing event xfs_dqflush_done: OK
Testing event xfs_dquot_dqalloc: OK
Testing event xfs_dquot_dqdetach: OK
Testing event xfs_log_done_nonperm: OK
Testing event xfs_log_done_perm: OK
Testing event xfs_log_reserve: OK
Testing event xfs_log_umount_write: OK
Testing event xfs_log_grant_enter: OK
Testing event xfs_log_grant_exit: OK
Testing event xfs_log_grant_error: OK
Testing event xfs_log_grant_sleep1: OK
Testing event xfs_log_grant_wake1: OK
Testing event xfs_log_grant_sleep2: OK
Testing event xfs_log_grant_wake2: OK
Testing event xfs_log_regrant_write_enter: OK
Testing event xfs_log_regrant_write_exit: OK
Testing event xfs_log_regrant_write_error: OK
Testing event xfs_log_regrant_write_sleep1: OK
Testing event xfs_log_regrant_write_wake1: OK
Testing event xfs_log_regrant_write_sleep2: OK
Testing event xfs_log_regrant_write_wake2: OK
Testing event xfs_log_regrant_reserve_enter: OK
Testing event xfs_log_regrant_reserve_exit: OK
Testing event xfs_log_regrant_reserve_sub: OK
Testing event xfs_log_ungrant_enter: OK
Testing event xfs_log_ungrant_exit: OK
Testing event xfs_log_ungrant_sub: OK
Testing event xfs_file_read: OK
Testing event xfs_file_buffered_write: OK
Testing event xfs_file_direct_write: OK
Testing event xfs_file_splice_read: OK
Testing event xfs_file_splice_write: OK
Testing event xfs_writepage: OK
Testing event xfs_releasepage: OK
Testing event xfs_invalidatepage: OK
Testing event xfs_iomap_enter: OK
Testing event xfs_iomap_found: OK
Testing event xfs_iomap_alloc: OK
Testing event xfs_delalloc_enospc: OK
Testing event xfs_unwritten_convert: OK
Testing event xfs_itruncate_start: OK
Testing event xfs_itruncate_finish_start: OK
Testing event xfs_itruncate_finish_end: OK
Testing event xfs_pagecache_inval: OK
Testing event xfs_bunmap: OK
Testing event xfs_alloc_busy: OK
Testing event xfs_alloc_unbusy: OK
Testing event xfs_alloc_busysearch: OK
Testing event xfs_trans_commit_lsn: OK
Testing event xfs_agf: OK
Testing event xfs_free_extent: OK
Testing event xfs_alloc_exact_done: OK
Testing event xfs_alloc_exact_error: OK
Testing event xfs_alloc_near_nominleft: OK
Testing event xfs_alloc_near_first: OK
Testing event xfs_alloc_near_greater: OK
Testing event xfs_alloc_near_lesser: OK
Testing event xfs_alloc_near_error: OK
Testing event xfs_alloc_size_neither: OK
Testing event xfs_alloc_size_noentry: OK
Testing event xfs_alloc_size_nominleft: OK
Testing event xfs_alloc_size_done: OK
Testing event xfs_alloc_size_error: OK
Testing event xfs_alloc_small_freelist: OK
Testing event xfs_alloc_small_notenough: OK
Testing event xfs_alloc_small_done: OK
Testing event xfs_alloc_small_error: OK
Testing event xfs_alloc_vextent_badargs: OK
Testing event xfs_alloc_vextent_nofix: OK
Testing event xfs_alloc_vextent_noagbp: OK
Testing event xfs_alloc_vextent_loopfailed: OK
Testing event xfs_alloc_vextent_allfailed: OK
Testing event xfs_dir2_sf_addname: OK
Testing event xfs_dir2_sf_create: OK
Testing event xfs_dir2_sf_lookup: OK
Testing event xfs_dir2_sf_replace: OK
Testing event xfs_dir2_sf_removename: OK
Testing event xfs_dir2_sf_toino4: OK
Testing event xfs_dir2_sf_toino8: OK
Testing event xfs_dir2_sf_to_block: OK
Testing event xfs_dir2_block_addname: OK
Testing event xfs_dir2_block_lookup: OK
Testing event xfs_dir2_block_replace: OK
Testing event xfs_dir2_block_removename: OK
Testing event xfs_dir2_block_to_sf: OK
Testing event xfs_dir2_block_to_leaf: OK
Testing event xfs_dir2_leaf_addname: OK
Testing event xfs_dir2_leaf_lookup: OK
Testing event xfs_dir2_leaf_replace: OK
Testing event xfs_dir2_leaf_removename: OK
Testing event xfs_dir2_leaf_to_block: OK
Testing event xfs_dir2_leaf_to_node: OK
Testing event xfs_dir2_node_addname: OK
Testing event xfs_dir2_node_lookup: OK
Testing event xfs_dir2_node_replace: OK
Testing event xfs_dir2_node_removename: OK
Testing event xfs_dir2_node_to_leaf: OK
Testing event xfs_dir2_leafn_add: OK
Testing event xfs_dir2_leafn_remove: OK
Testing event xfs_dir2_grow_inode: OK
Testing event xfs_dir2_shrink_inode: OK
Testing event xfs_dir2_leafn_moveents: OK
Testing event xfs_swap_extent_before: OK
Testing event xfs_swap_extent_after: OK
Testing event xfs_log_recover_item_add: OK
Testing event xfs_log_recover_item_add_cont: OK
Testing event xfs_log_recover_item_reorder_head: OK
Testing event xfs_log_recover_item_reorder_tail: OK
Testing event xfs_log_recover_item_recover: OK
Testing event xfs_log_recover_buf_not_cancel: OK
Testing event xfs_log_recover_buf_cancel: OK
Testing event xfs_log_recover_buf_cancel_add: OK
Testing event xfs_log_recover_buf_cancel_ref_inc: OK
Testing event xfs_log_recover_buf_recover: OK
Testing event xfs_log_recover_buf_inode_buf: OK
Testing event xfs_log_recover_buf_reg_buf: OK
Testing event xfs_log_recover_buf_dquot_buf: OK
Testing event xfs_log_recover_inode_recover: OK
Testing event xfs_log_recover_inode_cancel: OK
Testing event xfs_log_recover_inode_skip: OK
Testing event jbd2_checkpoint: OK
Testing event jbd2_start_commit: OK
Testing event jbd2_commit_locking: OK
Testing event jbd2_commit_flushing: OK
Testing event jbd2_commit_logging: OK
Testing event jbd2_end_commit: OK
Testing event jbd2_submit_inode_data: OK
Testing event jbd2_run_stats: OK
Testing event jbd2_checkpoint_stats: OK
Testing event jbd2_cleanup_journal_tail: OK
Testing event ext4_free_inode: OK
Testing event ext4_request_inode: OK
Testing event ext4_allocate_inode: OK
Testing event ext4_write_begin: OK
Testing event ext4_da_write_begin: OK
Testing event ext4_ordered_write_end: OK
Testing event ext4_writeback_write_end: OK
Testing event ext4_journalled_write_end: OK
Testing event ext4_da_write_end: OK
Testing event ext4_writepage: OK
Testing event ext4_da_writepages: OK
Testing event ext4_da_write_pages: OK
Testing event ext4_da_writepages_result: OK
Testing event ext4_discard_blocks: OK
Testing event ext4_mb_new_inode_pa: OK
Testing event ext4_mb_new_group_pa: OK
Testing event ext4_mb_release_inode_pa: OK
Testing event ext4_mb_release_group_pa: OK
Testing event ext4_discard_preallocations: OK
Testing event ext4_mb_discard_preallocations: OK
Testing event ext4_request_blocks: OK
Testing event ext4_allocate_blocks: OK
Testing event ext4_free_blocks: OK
Testing event ext4_sync_file: OK
Testing event ext4_sync_fs: OK
Testing event ext4_alloc_da_blocks: OK
Testing event ext4_mballoc_alloc: OK
Testing event ext4_mballoc_prealloc: OK
Testing event ext4_mballoc_discard: OK
Testing event ext4_mballoc_free: OK
Testing event ext4_forget: OK
Testing event ext4_da_update_reserve_space: OK
Testing event ext4_da_reserve_space: OK
Testing event ext4_da_release_space: OK
Testing event ext4_mb_bitmap_load: OK
Testing event ext4_mb_buddy_bitmap_load: OK
Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: OK
Testing event kfree: OK
Testing event kmem_cache_free: OK
Testing event mm_page_free_direct: OK
Testing event mm_pagevec_free: OK
Testing event mm_page_alloc: OK
Testing event mm_page_alloc_zone_locked: OK
Testing event mm_page_pcpu_drain: OK
Testing event mm_page_alloc_extfrag: OK
Testing event power_start: OK
Testing event power_frequency: OK
Testing event power_end: OK
Testing event module_load: OK
Testing event module_free: OK
Testing event module_request: OK
Testing event lock_acquire: OK
Testing event lock_release: OK
Testing event lock_contended: OK
Testing event lock_acquired: OK
Testing event workqueue_insertion: OK
Testing event workqueue_execution: OK
Testing event workqueue_creation: OK
Testing event workqueue_destruction: OK
Testing event signal_generate: OK
Testing event signal_deliver: OK
Testing event signal_overflow_fail: OK
Testing event signal_lose_info: OK
Testing event timer_init: OK
Testing event timer_start: OK
Testing event timer_expire_entry: OK
Testing event timer_expire_exit: OK
Testing event timer_cancel: OK
Testing event hrtimer_init: OK
Testing event hrtimer_start: OK
Testing event hrtimer_expire_entry: OK
Testing event hrtimer_expire_exit: OK
Testing event hrtimer_cancel: OK
Testing event itimer_state: OK
Testing event itimer_expire: OK
Testing event irq_handler_entry: OK
Testing event irq_handler_exit: OK
Testing event softirq_entry: OK
Testing event softirq_exit: OK
Testing event sched_kthread_stop: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_wakeup: OK
Testing event sched_wakeup_new: OK
Testing event sched_switch: OK
Testing event sched_migrate_task: OK
Testing event sched_process_free: OK
Testing event sched_process_exit: OK
Testing event sched_wait_task: OK
Testing event sched_process_wait: OK
Testing event sched_process_fork: OK
Testing event sched_stat_wait: OK
Testing event sched_stat_sleep: OK
Testing event sched_stat_iowait: OK
Testing event sched_stat_runtime: OK
Testing event sys_enter: OK
Testing event sys_exit: OK
Testing event kvm_mmu_pagetable_walk: OK
Testing event kvm_mmu_paging_element: OK
Testing event kvm_mmu_set_accessed_bit: OK
Testing event kvm_mmu_set_dirty_bit: OK
Testing event kvm_mmu_walker_error: OK
Testing event kvm_mmu_get_page: OK
Testing event kvm_mmu_sync_page: OK
Testing event kvm_mmu_unsync_page: OK
Testing event kvm_mmu_zap_page: OK
Testing event kvm_entry: OK
Testing event kvm_hypercall: OK
Testing event kvm_hv_hypercall: OK
Testing event kvm_pio: OK
Testing event kvm_cpuid: OK
Testing event kvm_apic: OK
Testing event kvm_exit: OK
Testing event kvm_inj_virq: OK
Testing event kvm_inj_exception: OK
Testing event kvm_page_fault: OK
Testing event kvm_msr: OK
Testing event kvm_cr: OK
Testing event kvm_pic_set_irq: OK
Testing event kvm_apic_ipi: OK
Testing event kvm_apic_accept_irq: OK
Testing event kvm_nested_vmrun: OK
Testing event kvm_nested_intercepts: OK
Testing event kvm_nested_vmexit: OK
Testing event kvm_nested_vmexit_inject: OK
Testing event kvm_nested_intr_vmexit: OK
Testing event kvm_invlpga: OK
Testing event kvm_skinit: OK
Testing event kvm_emulate_insn: OK
Testing event kvm_set_irq: OK
Testing event kvm_ioapic_set_irq: OK
Testing event kvm_msi_set_irq: OK
Testing event kvm_ack_irq: OK
Testing event kvm_mmio: OK
Testing event kvm_fpu: OK
Testing event kvm_age_page: OK
Running tests on trace event systems:
Testing event system skb: OK
Testing event system scsi: OK
Testing event system bkl: OK
Testing event system block: OK
Testing event system xfs: OK
Testing event system jbd2: OK
Testing event system ext4: OK
Testing event system kmem: OK
Testing event system power: OK
Testing event system module: OK
Testing event system lock: OK
Testing event system workqueue: OK
Testing event system signal: OK
Testing event system timer: OK
Testing event system irq: OK
Testing event system sched: OK
Testing event system raw_syscalls: OK
Testing event system kvmmmu: OK
Testing event system kvm: OK
Running tests on all trace events:
Testing all events: OK
Running tests again, along with the function tracer
Running tests on trace events:
Testing event kfree_skb: OK
Testing event skb_copy_datagram_iovec: OK
Testing event scsi_dispatch_cmd_start: OK
Testing event scsi_dispatch_cmd_error: OK
Testing event scsi_dispatch_cmd_done: OK
Testing event scsi_dispatch_cmd_timeout: OK
Testing event scsi_eh_wakeup: OK
Testing event lock_kernel: OK
Testing event unlock_kernel: OK
Testing event block_rq_abort: OK
Testing event block_rq_requeue: OK
Testing event block_rq_complete: OK
Testing event block_rq_insert: OK
Testing event block_rq_issue: OK
Testing event block_bio_bounce: OK
Testing event block_bio_complete: OK
Testing event block_bio_backmerge: OK
Testing event block_bio_frontmerge: OK
Testing event block_bio_queue: OK
Testing event block_getrq: OK
Testing event block_sleeprq: OK
Testing event block_plug: OK
Testing event block_unplug_timer: OK
Testing event block_unplug_io: OK
Testing event block_split: OK
Testing event block_remap: OK
Testing event block_rq_remap: OK
Testing event xfs_attr_list_sf: OK
Testing event xfs_attr_list_sf_all: OK
Testing event xfs_attr_list_leaf: OK
Testing event xfs_attr_list_leaf_end: OK
Testing event xfs_attr_list_full: OK
Testing event xfs_attr_list_add: OK
Testing event xfs_attr_list_wrong_blk: OK
Testing event xfs_attr_list_notfound: OK
Testing event xfs_perag_get: OK
Testing event xfs_perag_put: OK
Testing event xfs_attr_list_node_descend: OK
Testing event xfs_iext_insert: OK
Testing event xfs_iext_remove: OK
Testing event xfs_bmap_pre_update: OK
Testing event xfs_bmap_post_update: OK
Testing event xfs_extlist: OK
Testing event xfs_buf_init: OK
Testing event xfs_buf_free: OK
Testing event xfs_buf_hold: OK
Testing event xfs_buf_rele: OK
Testing event xfs_buf_pin: OK
Testing event xfs_buf_unpin: OK
Testing event xfs_buf_iodone: OK
Testing event xfs_buf_iorequest: OK
Testing event xfs_buf_bawrite: OK
Testing event xfs_buf_bdwrite: OK
Testing event xfs_buf_lock: OK
Testing event xfs_buf_lock_done: OK
Testing event xfs_buf_cond_lock: OK
Testing event xfs_buf_unlock: OK
Testing event xfs_buf_ordered_retry: OK
Testing event xfs_buf_iowait: OK
Testing event xfs_buf_iowait_done: OK
Testing event xfs_buf_delwri_queue: OK
Testing event xfs_buf_delwri_dequeue: OK
Testing event xfs_buf_delwri_split: OK
Testing event xfs_buf_get_noaddr: OK
Testing event xfs_bdstrat_shut: OK
Testing event xfs_buf_item_relse: OK
Testing event xfs_buf_item_iodone: OK
Testing event xfs_buf_item_iodone_async: OK
Testing event xfs_buf_error_relse: OK
Testing event xfs_trans_read_buf_io: OK
Testing event xfs_trans_read_buf_shut: OK
Testing event xfs_btree_corrupt: OK
Testing event xfs_da_btree_corrupt: OK
Testing event xfs_reset_dqcounts: OK
Testing event xfs_inode_item_push: OK
Testing event xfs_buf_find: OK
Testing event xfs_buf_get: OK
Testing event xfs_buf_read: OK
Testing event xfs_buf_ioerror: OK
Testing event xfs_buf_item_size: OK
Testing event xfs_buf_item_size_stale: OK
Testing event xfs_buf_item_format: OK
Testing event xfs_buf_item_format_stale: OK
Testing event xfs_buf_item_pin: OK
Testing event xfs_buf_item_unpin: OK
Testing event xfs_buf_item_unpin_stale: OK
Testing event xfs_buf_item_trylock: OK
Testing event xfs_buf_item_unlock: OK
Testing event xfs_buf_item_unlock_stale: OK
Testing event xfs_buf_item_committed: OK
Testing event xfs_buf_item_push: OK
Testing event xfs_buf_item_pushbuf: OK
Testing event xfs_trans_get_buf: OK
Testing event xfs_trans_get_buf_recur: OK
Testing event xfs_trans_getsb: OK
Testing event xfs_trans_getsb_recur: OK
Testing event xfs_trans_read_buf: OK
Testing event xfs_trans_read_buf_recur: OK
Testing event xfs_trans_log_buf: OK
Testing event xfs_trans_brelse: OK
Testing event xfs_trans_bjoin: OK
Testing event xfs_trans_bhold: OK
Testing event xfs_trans_bhold_release: OK
Testing event xfs_trans_binval: OK
Testing event xfs_ilock: OK
Testing event xfs_ilock_nowait: OK
Testing event xfs_ilock_demote: OK
Testing event xfs_iunlock: OK
Testing event xfs_iget_skip: OK
Testing event xfs_iget_reclaim: OK
Testing event xfs_iget_found: OK
Testing event xfs_iget_alloc: OK
Testing event xfs_ihold: OK
Testing event xfs_irele: OK
Testing event xfs_inode_pin: OK
Testing event xfs_inode_unpin: OK
Testing event xfs_inode_unpin_nowait: OK
Testing event xfs_inode: OK
Testing event xfs_dqadjust: OK
Testing event xfs_dqreclaim_want: OK
Testing event xfs_dqreclaim_dirty: OK
Testing event xfs_dqreclaim_unlink: OK
Testing event xfs_dqattach_found: OK
Testing event xfs_dqattach_get: OK
Testing event xfs_dqinit: OK
Testing event xfs_dqreuse: OK
Testing event xfs_dqalloc: OK
Testing event xfs_dqtobp_read: OK
Testing event xfs_dqread: OK
Testing event xfs_dqread_fail: OK
Testing event xfs_dqlookup_found: OK
Testing event xfs_dqlookup_want: OK
Testing event xfs_dqlookup_freelist: OK
Testing event xfs_dqlookup_done: OK
Testing event xfs_dqget_hit: OK
Testing event xfs_dqget_miss: OK
Testing event xfs_dqput: OK
Testing event xfs_dqput_wait: OK
Testing event xfs_dqput_free: OK
Testing event xfs_dqrele: OK
Testing event xfs_dqflush: OK
Testing event xfs_dqflush_force: OK
Testing event xfs_dqflush_done: OK
Testing event xfs_dquot_dqalloc: OK
Testing event xfs_dquot_dqdetach: OK
Testing event xfs_log_done_nonperm: OK
Testing event xfs_log_done_perm: OK
Testing event xfs_log_reserve: OK
Testing event xfs_log_umount_write: OK
Testing event xfs_log_grant_enter: OK
Testing event xfs_log_grant_exit: OK
Testing event xfs_log_grant_error: OK
Testing event xfs_log_grant_sleep1: OK
Testing event xfs_log_grant_wake1: OK
Testing event xfs_log_grant_sleep2: OK
Testing event xfs_log_grant_wake2: OK
Testing event xfs_log_regrant_write_enter: OK
Testing event xfs_log_regrant_write_exit: OK
Testing event xfs_log_regrant_write_error: OK
Testing event xfs_log_regrant_write_sleep1: OK
Testing event xfs_log_regrant_write_wake1: OK
Testing event xfs_log_regrant_write_sleep2: OK
Testing event xfs_log_regrant_write_wake2: OK
Testing event xfs_log_regrant_reserve_enter: OK
Testing event xfs_log_regrant_reserve_exit: OK
Testing event xfs_log_regrant_reserve_sub: OK
Testing event xfs_log_ungrant_enter: OK
Testing event xfs_log_ungrant_exit: OK
Testing event xfs_log_ungrant_sub: OK
Testing event xfs_file_read: OK
Testing event xfs_file_buffered_write: OK
Testing event xfs_file_direct_write: OK
Testing event xfs_file_splice_read: OK
Testing event xfs_file_splice_write: OK
Testing event xfs_writepage: OK
Testing event xfs_releasepage: OK
Testing event xfs_invalidatepage: OK
Testing event xfs_iomap_enter: OK
Testing event xfs_iomap_found: OK
Testing event xfs_iomap_alloc: OK
Testing event xfs_delalloc_enospc: OK
Testing event xfs_unwritten_convert: OK
Testing event xfs_itruncate_start: OK
Testing event xfs_itruncate_finish_start: OK
Testing event xfs_itruncate_finish_end: OK
Testing event xfs_pagecache_inval: OK
Testing event xfs_bunmap: OK
Testing event xfs_alloc_busy: OK
Testing event xfs_alloc_unbusy: OK
Testing event xfs_alloc_busysearch: OK
Testing event xfs_trans_commit_lsn: OK
Testing event xfs_agf: OK
Testing event xfs_free_extent: OK
Testing event xfs_alloc_exact_done: OK
Testing event xfs_alloc_exact_error: OK
Testing event xfs_alloc_near_nominleft: OK
Testing event xfs_alloc_near_first: OK
Testing event xfs_alloc_near_greater: OK
Testing event xfs_alloc_near_lesser: OK
Testing event xfs_alloc_near_error: OK
Testing event xfs_alloc_size_neither: OK
Testing event xfs_alloc_size_noentry: OK
Testing event xfs_alloc_size_nominleft: OK
Testing event xfs_alloc_size_done: OK
Testing event xfs_alloc_size_error: OK
Testing event xfs_alloc_small_freelist: OK
Testing event xfs_alloc_small_notenough: OK
Testing event xfs_alloc_small_done: OK
Testing event xfs_alloc_small_error: OK
Testing event xfs_alloc_vextent_badargs: OK
Testing event xfs_alloc_vextent_nofix: OK
Testing event xfs_alloc_vextent_noagbp: OK
Testing event xfs_alloc_vextent_loopfailed: OK
Testing event xfs_alloc_vextent_allfailed: OK
Testing event xfs_dir2_sf_addname: OK
Testing event xfs_dir2_sf_create: OK
Testing event xfs_dir2_sf_lookup: OK
Testing event xfs_dir2_sf_replace: OK
Testing event xfs_dir2_sf_removename: OK
Testing event xfs_dir2_sf_toino4: OK
Testing event xfs_dir2_sf_toino8: OK
Testing event xfs_dir2_sf_to_block: OK
Testing event xfs_dir2_block_addname: OK
Testing event xfs_dir2_block_lookup: OK
Testing event xfs_dir2_block_replace: OK
Testing event xfs_dir2_block_removename: OK
Testing event xfs_dir2_block_to_sf: OK
Testing event xfs_dir2_block_to_leaf: OK
Testing event xfs_dir2_leaf_addname: OK
Testing event xfs_dir2_leaf_lookup: OK
Testing event xfs_dir2_leaf_replace: OK
Testing event xfs_dir2_leaf_removename: OK
Testing event xfs_dir2_leaf_to_block: OK
Testing event xfs_dir2_leaf_to_node: OK
Testing event xfs_dir2_node_addname: OK
Testing event xfs_dir2_node_lookup: OK
Testing event xfs_dir2_node_replace: OK
Testing event xfs_dir2_node_removename: OK
Testing event xfs_dir2_node_to_leaf: OK
Testing event xfs_dir2_leafn_add: OK
Testing event xfs_dir2_leafn_remove: OK
Testing event xfs_dir2_grow_inode: OK
Testing event xfs_dir2_shrink_inode: OK
Testing event xfs_dir2_leafn_moveents: OK
Testing event xfs_swap_extent_before: OK
Testing event xfs_swap_extent_after: OK
Testing event xfs_log_recover_item_add: OK
Testing event xfs_log_recover_item_add_cont: OK
Testing event xfs_log_recover_item_reorder_head: OK
Testing event xfs_log_recover_item_reorder_tail: OK
Testing event xfs_log_recover_item_recover: OK
Testing event xfs_log_recover_buf_not_cancel: OK
Testing event xfs_log_recover_buf_cancel: OK
Testing event xfs_log_recover_buf_cancel_add: OK
Testing event xfs_log_recover_buf_cancel_ref_inc: OK
Testing event xfs_log_recover_buf_recover: OK
Testing event xfs_log_recover_buf_inode_buf: OK
Testing event xfs_log_recover_buf_reg_buf: OK
Testing event xfs_log_recover_buf_dquot_buf: OK
Testing event xfs_log_recover_inode_recover: OK
Testing event xfs_log_recover_inode_cancel: OK
Testing event xfs_log_recover_inode_skip: OK
Testing event jbd2_checkpoint: OK
Testing event jbd2_start_commit: OK
Testing event jbd2_commit_locking: OK
Testing event jbd2_commit_flushing: OK
Testing event jbd2_commit_logging: OK
Testing event jbd2_end_commit: OK
Testing event jbd2_submit_inode_data: OK
Testing event jbd2_run_stats: OK
Testing event jbd2_checkpoint_stats: OK
Testing event jbd2_cleanup_journal_tail: OK
Testing event ext4_free_inode: OK
Testing event ext4_request_inode: OK
Testing event ext4_allocate_inode: OK
Testing event ext4_write_begin: OK
Testing event ext4_da_write_begin: OK
Testing event ext4_ordered_write_end: OK
Testing event ext4_writeback_write_end: OK
Testing event ext4_journalled_write_end: OK
Testing event ext4_da_write_end: OK
Testing event ext4_writepage: OK
Testing event ext4_da_writepages: OK
Testing event ext4_da_write_pages: OK
Testing event ext4_da_writepages_result: OK
Testing event ext4_discard_blocks: OK
Testing event ext4_mb_new_inode_pa: OK
Testing event ext4_mb_new_group_pa: OK
Testing event ext4_mb_release_inode_pa: OK
Testing event ext4_mb_release_group_pa: OK
Testing event ext4_discard_preallocations: OK
Testing event ext4_mb_discard_preallocations: OK
Testing event ext4_request_blocks: OK
Testing event ext4_allocate_blocks: OK
Testing event ext4_free_blocks: OK
Testing event ext4_sync_file: OK
Testing event ext4_sync_fs: OK
Testing event ext4_alloc_da_blocks: OK
Testing event ext4_mballoc_alloc: OK
Testing event ext4_mballoc_prealloc: OK
Testing event ext4_mballoc_discard: OK
Testing event ext4_mballoc_free: OK
Testing event ext4_forget: OK
Testing event ext4_da_update_reserve_space: OK
Testing event ext4_da_reserve_space: OK
Testing event ext4_da_release_space: OK
Testing event ext4_mb_bitmap_load: OK
Testing event ext4_mb_buddy_bitmap_load: OK
Testing event kmalloc: OK
Testing event kmem_cache_alloc: OK
Testing event kmalloc_node: OK
Testing event kmem_cache_alloc_node: OK
Testing event kfree: OK
Testing event kmem_cache_free: OK
Testing event mm_page_free_direct: OK
Testing event mm_pagevec_free: OK
Testing event mm_page_alloc: OK
Testing event mm_page_alloc_zone_locked: OK
Testing event mm_page_pcpu_drain: OK
Testing event mm_page_alloc_extfrag: OK
Testing event power_start: OK
Testing event power_frequency: OK
Testing event power_end: OK
Testing event module_load: OK
Testing event module_free: OK
Testing event module_request: OK
Testing event lock_acquire: OK
Testing event lock_release: OK
Testing event lock_contended: OK
Testing event lock_acquired: OK
Testing event workqueue_insertion: OK
Testing event workqueue_execution: OK
Testing event workqueue_creation: OK
Testing event workqueue_destruction: OK
Testing event signal_generate: OK
Testing event signal_deliver: OK
Testing event signal_overflow_fail: OK
Testing event signal_lose_info: OK
Testing event timer_init: OK
Testing event timer_start: OK
Testing event timer_expire_entry: OK
Testing event timer_expire_exit: OK
Testing event timer_cancel: OK
Testing event hrtimer_init: OK
Testing event hrtimer_start: OK
Testing event hrtimer_expire_entry: OK
Testing event hrtimer_expire_exit: OK
Testing event hrtimer_cancel: OK
Testing event itimer_state: OK
Testing event itimer_expire: OK
Testing event irq_handler_entry: OK
Testing event irq_handler_exit: OK
Testing event softirq_entry: OK
Testing event softirq_exit: OK
Testing event sched_kthread_stop: OK
Testing event sched_kthread_stop_ret: OK
Testing event sched_wakeup: OK
Testing event sched_wakeup_new: OK
Testing event sched_switch: OK
Testing event sched_migrate_task: OK
Testing event sched_process_free: OK
Testing event sched_process_exit: OK
Testing event sched_wait_task: OK
Testing event sched_process_wait: OK
Testing event sched_process_fork: OK
Testing event sched_stat_wait: OK
Testing event sched_stat_sleep: OK
Testing event sched_stat_iowait: OK
Testing event sched_stat_runtime: OK
Testing event sys_enter: OK
Testing event sys_exit: OK
Testing event kvm_mmu_pagetable_walk: OK
Testing event kvm_mmu_paging_element: OK
Testing event kvm_mmu_set_accessed_bit: OK
Testing event kvm_mmu_set_dirty_bit: OK
Testing event kvm_mmu_walker_error: OK
Testing event kvm_mmu_get_page: OK
Testing event kvm_mmu_sync_page: OK
Testing event kvm_mmu_unsync_page: OK
Testing event kvm_mmu_zap_page: OK
Testing event kvm_entry: OK
Testing event kvm_hypercall: OK
Testing event kvm_hv_hypercall: OK
Testing event kvm_pio: OK
Testing event kvm_cpuid: OK
Testing event kvm_apic: OK
Testing event kvm_exit: OK
Testing event kvm_inj_virq: OK
Testing event kvm_inj_exception: OK
Testing event kvm_page_fault: OK
Testing event kvm_msr: OK
Testing event kvm_cr: OK
Testing event kvm_pic_set_irq: OK
Testing event kvm_apic_ipi: OK
Testing event kvm_apic_accept_irq: OK
Testing event kvm_nested_vmrun: OK
Testing event kvm_nested_intercepts: OK
Testing event kvm_nested_vmexit: OK
Testing event kvm_nested_vmexit_inject: OK
Testing event kvm_nested_intr_vmexit: OK
Testing event kvm_invlpga: OK
Testing event kvm_skinit: OK
Testing event kvm_emulate_insn: OK
Testing event kvm_set_irq: OK
Testing event kvm_ioapic_set_irq: OK
Testing event kvm_msi_set_irq: OK
Testing event kvm_ack_irq: OK
Testing event kvm_mmio: OK
Testing event kvm_fpu: OK
Testing event kvm_age_page: OK
Running tests on trace event systems:
Testing event system skb: OK
Testing event system scsi: OK
Testing event system bkl: OK
Testing event system block: OK
Testing event system xfs: OK
Testing event system jbd2: OK
Testing event system ext4: OK
Testing event system kmem: OK
Testing event system power: OK
Testing event system module: OK
Testing event system lock: OK
Testing event system workqueue: OK
Testing event system signal: OK
Testing event system timer: OK
Testing event system irq: OK
Testing event system sched: OK
Testing event system raw_syscalls: OK
Testing event system kvmmmu: OK
Testing event system kvm: OK
Running tests on all trace events:
Testing all events: OK
initcall event_trace_self_tests_init+0x0/0x41 returned 0 after 16417968 usecs
calling  init_ima+0x0/0x15 @ 1
tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
IMA: No TPM chip found, activating TPM-bypass!
initcall init_ima+0x0/0x15 returned 0 after 7812 usecs
calling  fail_make_request_debugfs+0x0/0xb @ 1
initcall fail_make_request_debugfs+0x0/0xb returned -19 after 0 usecs
calling  fail_io_timeout_debugfs+0x0/0xb @ 1
initcall fail_io_timeout_debugfs+0x0/0xb returned -19 after 0 usecs
calling  random32_reseed+0x0/0xb5 @ 1
initcall random32_reseed+0x0/0xb5 returned 0 after 0 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 0 usecs
calling  pci_sysfs_init+0x0/0x51 @ 1
initcall pci_sysfs_init+0x0/0x51 returned 0 after 3906 usecs
calling  regulator_init_complete+0x0/0x140 @ 1
initcall regulator_init_complete+0x0/0x140 returned 0 after 0 usecs
calling  seqgen_init+0x0/0xf @ 1
initcall seqgen_init+0x0/0xf returned 0 after 0 usecs
calling  hd_init+0x0/0x302 @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x302 returned -1 after 3906 usecs
initcall hd_init+0x0/0x302 returned with error code -1 
calling  scsi_complete_async_scans+0x0/0xfd @ 1
initcall scsi_complete_async_scans+0x0/0xfd returned 0 after 0 usecs
calling  tcp_congestion_default+0x0/0x12 @ 1
initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
calling  initialize_hashrnd+0x0/0x19 @ 1
initcall initialize_hashrnd+0x0/0x19 returned 0 after 0 usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
EXT3-fs (sda6): recovery required on readonly filesystem
EXT3-fs (sda6): write access will be enabled during recovery
EXT3-fs: barriers not enabled
EXT3-fs (sda6): recovery complete
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda6): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
async_waiting @ 1
async_continuing @ 1 after 0 usec
debug: unmapping init memory ffffffff81e77000..ffffffff8225e000
modprobe: FATAL:modprobe used greatest stack depth: 2952 bytes left
 Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

Mount failed for selinuxfs on /selinux:  No such device
INIT: version 2.86 booting
		Welcome to Fedora 
		Press 'I' to enter interactive startup.
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

Setting clock  (localtime): Mon Jul  5 20:03:32 CEST 2010 [  OK  ]
Starting udev: /sbin/start_udev: line 85: cannot redirect standard input from /dev/null: No such file or directory
/sbin/start_udev: line 85: cannot redirect standard input from /dev/null: No such file or directory
eth1: link down
ADDRCONF(NETDEV_UP): eth1: link is not ready
CPA self-test:
 4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
 4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
 4k 262128 large 0 gb 0 x 262128[ffff880000000000-ffff88003ffef000] miss 0
ok.
[  OK  ]
Loading default keymap (us): [  OK  ]
Setting hostname mercury:  [  OK  ]
DM multipath kernel driver not loaded
No devices found
Setting up Logical Volume Management:   No volume groups found
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda6 
/1: Superblock last mount time is in the future.  FIXED.
/1: Superblock last write time is in the future.  FIXED.
/1: clean, 376159/7325696 files, 3612828/7325632 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/sda5 
/home: recovering journal
/home: Superblock last mount time is in the future.  FIXED.
/home: clean, 140759/6111232 files, 2714871/12209392 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  EXT3-fs (sda6): using internal journal
[  OK  ]
Mounting local filesystems:  EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda5): using internal journal
EXT3-fs (sda5): mounted filesystem with writeback data mode
[  OK  ]
Enabling local filesystem quotas:  [  OK  ]
Enabling /etc/fstab swaps:  swapon: /dev/sda2: Function not implemented
[FAILED]
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

rc.sysinit used greatest stack depth: 2904 bytes left
INIT: Entering runlevel: 3
Entering non-interactive startup
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  eth0: no IPv6 routers present
[  OK  ]
Starting system message bus: warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
[  OK  ]
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

Starting sshd: [  OK  ]
Starting postgresql service: modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

[FAILED]
NOT testing CPU hotplug ...
cat: /debug/kernel_page_tables: No such file or directory
Shutting down Distributed Compiler daemon (distccd): modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

[FAILED]modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

Starting Distributed Compiler daemon (distccd): modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

[  OK  ]
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory


 Performance counter stats for 'true':

           1.807159  task-clock-msecs         #      0.028 CPUs 
                  0  context-switches         #      0.000 M/sec
                  0  CPU-migrations           #      0.000 M/sec
                135  page-faults              #      0.075 M/sec
            3215232  cycles                   #   1779.164 M/sec
            2237140  instructions             #      0.696 IPC  
             453100  branches                 #    250.725 M/sec
      <not counted>  branch-misses           
      <not counted>  cache-references        
      <not counted>  cache-misses            

        0.064000000  seconds time elapsed

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory


Fedora release 8 (Werewolf)
Kernel 2.6.35-rc4-tip-01075-g0c1880a-dirty on an x86_64

mercury login: modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

ssh: connect to host d port 22: No route to host
modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.35-rc4-tip-01075-g0c1880a-dirty/modules.dep: No such file or directory

BUG: unable to handle kernel paging request at 000000000528aa7e
IP: [<ffffffff8112d514>] wb_clear_pending+0x3b/0x66
PGD 0 
Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/class/net/eth0/broadcast
CPU 1 
Modules linked in:

Pid: 1637, comm: flush-8:0 Not tainted 2.6.35-rc4-tip-01075-g0c1880a-dirty #15306 A8N-E/System Product Name
RIP: 0010:[<ffffffff8112d514>]  [<ffffffff8112d514>] wb_clear_pending+0x3b/0x66
RSP: 0018:ffff88003b899d90  EFLAGS: 00010286
RAX: 000000000528aa7e RBX: ffff880038e3d5f8 RCX: ffff88003b952000
RDX: ffff88003dd8c468 RSI: ffff88003dd8c420 RDI: ffff88003dd8c408
RBP: ffff88003b899da0 R08: ffffffff825bf870 R09: 0000000000000000
R10: ffff88003b899cf0 R11: 0000000000000002 R12: ffff88003dd8c408
R13: 0000000000000000 R14: ffff880038e3d5f8 R15: ffff88003dd8c468
FS:  00007f2d706b36f0(0000) GS:ffff880003200000(0000) knlGS:00000000f77bb6c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000528aa7e CR3: 0000000001d1e000 CR4: 00000000000006a0
DR0: ffffffff82ceebbc DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Process flush-8:0 (pid: 1637, threadinfo ffff88003b898000, task ffff88003b952000)
Stack:
 ffff88003dd8c3a8 0000000000000000 ffff88003b899e30 ffffffff8112d5d7
<0> ffffffff8112d5de ffffffff823ae2a0 0000000000000000 ffff88003b899de0
<0> 00000000000009c4 ffff88003b899fd8 000000000000000a 0000000000000000
Call Trace:
 [<ffffffff8112d5d7>] wb_do_writeback+0x98/0x1d7
 [<ffffffff8112d5de>] ? wb_do_writeback+0x9f/0x1d7
 [<ffffffff8112d755>] bdi_writeback_task+0x3f/0xfc
 [<ffffffff810809a7>] ? bit_waitqueue+0x17/0xa9
 [<ffffffff810ee2d0>] ? bdi_start_fn+0x0/0xda
 [<ffffffff810ee346>] bdi_start_fn+0x76/0xda
 [<ffffffff810ee2d0>] ? bdi_start_fn+0x0/0xda
 [<ffffffff810805e9>] kthread+0x7f/0x87
 [<ffffffff8102ac04>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105af79>] ? finish_task_switch+0x70/0xdc
 [<ffffffff818674c5>] ? _raw_spin_unlock_irq+0x4f/0x6c
 [<ffffffff81867994>] ? restore_args+0x0/0x30
 [<ffffffff8108056a>] ? kthread+0x0/0x87
 [<ffffffff8102ac00>] ? kernel_thread_helper+0x0/0x10
Code: ff 4e 28 0f 94 c0 84 c0 74 47 4c 8b 67 10 49 81 c4 10 02 00 00 4c 89 e7 e8 d5 92 73 00 48 8b 43 08 48 8b 13 4c 89 e7 48 89 42 08 <48> 89 10 48 b8 00 02 20 00 00 00 ad de 48 89 43 08 e8 4d a0 73 
RIP  [<ffffffff8112d514>] wb_clear_pending+0x3b/0x66
 RSP <ffff88003b899d90>
CR2: 000000000528aa7e
---[ end trace bbca1bda47ec2023 ]---
Kernel panic - not syncing: Fatal exception
Pid: 1637, comm: flush-8:0 Tainted: G      D     2.6.35-rc4-tip-01075-g0c1880a-dirty #15306
Call Trace:
 [<ffffffff8186328c>] panic+0x95/0x128
 [<ffffffff8102dac7>] ? oops_end+0x81/0xd5
 [<ffffffff8102db0b>] oops_end+0xc5/0xd5
 [<ffffffff81049865>] no_context+0x1fc/0x20b
 [<ffffffff81030ef1>] ? native_sched_clock+0x4a/0x76
 [<ffffffff81049a14>] __bad_area_nosemaphore+0x1a0/0x1c3
 [<ffffffff81049c94>] ? do_page_fault+0xed/0x3da
 [<ffffffff81049a4a>] bad_area_nosemaphore+0x13/0x15
 [<ffffffff81049d87>] do_page_fault+0x1e0/0x3da
 [<ffffffff8108e298>] ? lock_release_holdtime+0xfd/0x102
 [<ffffffff818675ac>] ? _raw_spin_unlock+0x35/0x52
 [<ffffffff818665ed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81867bf5>] page_fault+0x25/0x30
 [<ffffffff8112d514>] ? wb_clear_pending+0x3b/0x66
 [<ffffffff8112d5d7>] wb_do_writeback+0x98/0x1d7
 [<ffffffff8112d5de>] ? wb_do_writeback+0x9f/0x1d7
 [<ffffffff8112d755>] bdi_writeback_task+0x3f/0xfc
 [<ffffffff810809a7>] ? bit_waitqueue+0x17/0xa9
 [<ffffffff810ee2d0>] ? bdi_start_fn+0x0/0xda
 [<ffffffff810ee346>] bdi_start_fn+0x76/0xda
 [<ffffffff810ee2d0>] ? bdi_start_fn+0x0/0xda
 [<ffffffff810805e9>] kthread+0x7f/0x87
 [<ffffffff8102ac04>] kernel_thread_helper+0x4/0x10
 [<ffffffff8105af79>] ? finish_task_switch+0x70/0xdc
 [<ffffffff818674c5>] ? _raw_spin_unlock_irq+0x4f/0x6c
 [<ffffffff81867994>] ? restore_args+0x0/0x30
 [<ffffffff8108056a>] ? kthread+0x0/0x87
 [<ffffffff8102ac00>] ? kernel_thread_helper+0x0/0x10

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.35-rc4
# Mon Jul  5 12:45:28 2010
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
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
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_EARLY_RES=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
# CONFIG_KALLSYMS is not set
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
# CONFIG_AIO is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PCI_QUIRKS is not set
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y

#
# GCOV-based kernel profiling
#
CONFIG_SLOW_WORK=y
CONFIG_SLOW_WORK_DEBUG=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
CONFIG_M586=y
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
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
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_HPET_TIMER is not set
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
CONFIG_EFI=y
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_POWER_METER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
CONFIG_X86_LONGHAUL=y
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOOLPC=y
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_DMAR is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
# CONFIG_MCA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_OPENFIRMWARE is not set
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=y
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_HYBLA is not set
CONFIG_DEFAULT_VEGAS=y
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="vegas"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
CONFIG_RDS_DEBUG=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
CONFIG_ECONET_NATIVE=y
# CONFIG_WAN_ROUTER is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_RPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_JANZ_ICAN3=y
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCI=y
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_LIB80211=y
# CONFIG_LIB80211_DEBUG is not set

#
# CFG80211 needs to be enabled for MAC80211
#

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
# CONFIG_CAIF is not set

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
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_XD=y
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
# CONFIG_ISL29003 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_SCSI_CXGB3_ISCSI=y
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_7000FASST=y
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
CONFIG_SCSI_AHA1740=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=y
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_GENERIC_NCR5380 is not set
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_PPA is not set
CONFIG_SCSI_IMM=y
# CONFIG_SCSI_IZIP_EPP16 is not set
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_NCR53C406A=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_PAS16=y
# CONFIG_SCSI_QLOGIC_FAS is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
CONFIG_SCSI_SYM53C416=y
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
CONFIG_SCSI_U14_34F_TAGGED_QUEUE=y
# CONFIG_SCSI_U14_34F_LINKED_COMMANDS is not set
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
CONFIG_SCSI_NSP32=y
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
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
CONFIG_SATA_INIC162X=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
CONFIG_SATA_SVW=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_ATP867X=y
# CONFIG_PATA_CMD64X is not set
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_NETCELL=y
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87415=y
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=y
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_ISAPNP=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_QDI is not set
CONFIG_PATA_RZ1000=y
CONFIG_PATA_WINBOND_VLB=y

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_IEEE1394=y
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=y
CONFIG_IEEE1394_SBP2=y
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=y
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
CONFIG_BONDING=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_NET_SB1000=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
# CONFIG_ARCNET_COM20020 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_RACAL=y
CONFIG_NI52=y
# CONFIG_NI65 is not set
CONFIG_DNET=y
# CONFIG_NET_TULIP is not set
CONFIG_AT1700=y
CONFIG_DEPCA=y
CONFIG_HP100=y
CONFIG_NET_ISA=y
# CONFIG_E2100 is not set
CONFIG_EWRK3=y
CONFIG_EEXPRESS=y
CONFIG_EEXPRESS_PRO=y
CONFIG_HPLAN=y
CONFIG_LP486E=y
CONFIG_ETH16I=y
# CONFIG_NE2000 is not set
# CONFIG_ZNET is not set
CONFIG_SEEQ8005=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
CONFIG_AMD8111_ETH=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_AC3200=y
CONFIG_KSZ884X_PCI=y
CONFIG_APRICOT=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
# CONFIG_CS89x0 is not set
CONFIG_E100=y
CONFIG_LNE390=y
CONFIG_FEALNX=y
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
CONFIG_NE3210=y
# CONFIG_ES3210 is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=y
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=y
# CONFIG_KS8842 is not set
CONFIG_KS8851_MLL=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=y
# CONFIG_NET_POCKET is not set
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
CONFIG_IGB=y
CONFIG_IGB_DCA=y
CONFIG_IGBVF=y
CONFIG_NS83820=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=y
CONFIG_R8169=y
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
CONFIG_ATL1C=y
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
CONFIG_MDIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4_DEPENDS=y
CONFIG_CHELSIO_T4=y
# CONFIG_ENIC is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_DCA=y
# CONFIG_IXGBEVF is not set
CONFIG_IXGB=y
# CONFIG_S2IO is not set
CONFIG_MYRI10GE=y
CONFIG_MYRI10GE_DCA=y
CONFIG_NIU=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
# CONFIG_TEHUTI is not set
CONFIG_BNX2X=y
CONFIG_QLCNIC=y
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
CONFIG_BE2NET=y
CONFIG_TR=y
CONFIG_IBMTR=y
CONFIG_IBMOL=y
CONFIG_IBMLS=y
CONFIG_3C359=y
CONFIG_TMS380TR=y
CONFIG_TMSPCI=y
CONFIG_SKISA=y
CONFIG_PROTEON=y
# CONFIG_ABYSS is not set
# CONFIG_SMCTR is not set
CONFIG_WLAN=y
CONFIG_AIRO=y
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_CDC_PHONET is not set
CONFIG_USB_IPHETH=y
# CONFIG_WAN is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
CONFIG_PLIP=y
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
CONFIG_VMXNET3=y
# CONFIG_ISDN is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_DA9034=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_N_GSM=y
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
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
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_SPI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO expanders:
#
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_SCH=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_TC35892=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_LIS3_I2C=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=y
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
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
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_CODEC is not set
CONFIG_MFD_TC35892=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_AB3550_CORE=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=y
# CONFIG_VGA_ARB is not set
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
# CONFIG_BACKLIGHT_DA903X is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_88PM860X is not set
CONFIG_BACKLIGHT_PCF50633=y

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
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=y
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=y
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PORTMAN2X4=y
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB8_DSP=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=y
# CONFIG_SND_AD1816A is not set
CONFIG_SND_AD1848=y
CONFIG_SND_ALS100=y
# CONFIG_SND_AZT2320 is not set
CONFIG_SND_CMI8330=y
CONFIG_SND_CS4231=y
CONFIG_SND_CS4236=y
# CONFIG_SND_ES1688 is not set
CONFIG_SND_ES18XX=y
# CONFIG_SND_SC6000 is not set
CONFIG_SND_GUSCLASSIC=y
CONFIG_SND_GUSEXTREME=y
# CONFIG_SND_GUSMAX is not set
CONFIG_SND_INTERWAVE=y
CONFIG_SND_INTERWAVE_STB=y
CONFIG_SND_JAZZ16=y
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
CONFIG_SND_OPTI92X_CS4231=y
CONFIG_SND_OPTI93X=y
# CONFIG_SND_MIRO is not set
CONFIG_SND_SB8=y
CONFIG_SND_SB16=y
# CONFIG_SND_SBAWE is not set
CONFIG_SND_SB16_CSP=y
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
CONFIG_SND_WAVEFRONT=y
CONFIG_SND_MSND_PINNACLE=y
# CONFIG_SND_MSND_CLASSIC is not set
# CONFIG_SND_PCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
CONFIG_SND_USB_UA101=y
CONFIG_SND_USB_USX2Y=y
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_3M_PCT=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CANDO=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EGALAX=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_QUANTA=y
CONFIG_HID_ROCCAT=y
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_STANTUM is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_GADGET_MUSB_HDRC is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_PXA25X is not set
CONFIG_USB_GADGET_R8A66597=y
CONFIG_USB_R8A66597=y
# CONFIG_USB_GADGET_PXA27X is not set
# CONFIG_USB_GADGET_S3C_HSOTG is not set
# CONFIG_USB_GADGET_IMX is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_FSL_QE is not set
# CONFIG_USB_GADGET_CI13XXX is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LANGWELL is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
CONFIG_USB_ETH=y
CONFIG_USB_ETH_RNDIS=y
# CONFIG_USB_ETH_EEM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
# CONFIG_UWB_HWA is not set
CONFIG_UWB_WHCI=y
# CONFIG_UWB_WLP is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_GPIO_PLATFORM is not set
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
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
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y
# CONFIG_RTC_DRV_AB3100 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_EEEPC_LAPTOP=y
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_ACPI_ASUS=y
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_TOSHIBA_BT_RFKILL=y
# CONFIG_ACPI_CMPC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_EFI_VARS is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTRS=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_RPCSEC_GSS_SPKM3=y
CONFIG_SMB_FS=y
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CEPH_FS=y
CONFIG_CEPH_FS_PRETTYDEBUG=y
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
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
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
# CONFIG_FRAME_POINTER is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_LKDTM=y
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_SAMPLES=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_4KSTACKS is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_TOMOYO=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
CONFIG_DEFAULT_SECURITY_TOMOYO=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="tomoyo"
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
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
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

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
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_GEODE=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
# CONFIG_VHOST_NET is not set
CONFIG_LGUEST=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
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
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=y

--vkogqOf2sHV7VnPd--
