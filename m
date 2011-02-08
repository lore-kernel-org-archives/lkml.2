Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1BHKRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:17:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43876 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1BHKRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:17:42 -0500
Date: Tue, 8 Feb 2011 11:17:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: lockdep: possible reason: unannotated irqs-off. (was: Re: Linux
 2.6.38-rc4)
Message-ID: <20110208101730.GB7020@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	x86@kernel.org
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Feb 07, 2011 at 04:23:37PM -0800, Linus Torvalds wrote:
> No travel or cyclone-dodging this time, so as promised, the -rc's are
> now back to the usual weekly schedule.
> 
> There's nothing much that stands out here. Some arch updates (arm and
> powerpc), the usual driver updates: dri (radeon/i915), network cards,
> sound, media, scisi, some filesystem updates (cifs, btrfs), and some
> random stuff to round it all out (networking, watchpoints,
> tracepoints, etc).
> 
> Pretty small, all in all. I'd obviously prefer it to be even smaller,
> and I actually dropped a pull request or two, but for being -rc4 this
> is by no means horrible. As long as it keeps shrinking, I'll be happy.

So, I'm getting the warning below early in the boot process. And yes, I
didn't have it on -rc3. 2.6.38-rc4-00001-g1e554e3-dirty means a debug
diff ontop of -rc4 which shouldn't have anything to do with this splat
since all it does is a couple of printk's due to -rc3 not suspending to
disk properly in some cases.

Now, I'm not going to even pretend to understand the code but here's
what I can read out, you tell me whether it makes sense.

spawn_ksoftirqd() is one of the early initcalls that gets called and
it's notifier callback does kthread_bind() and you can follow in the
backtrace below that this thing comes down to del_timer_sync() which
does the lockdep annotation. Now, problem as I see it, is that hardirqs
were disabled when we were called although it doesn't say so in the
irqtrace events dump after the calltrace: "hardirqs last enabled at
(999)" and our irq event stamp is 1000.

There are actually at least three del_timer_sync()'s inflight so the
problem could be there somewhere, I dunno.

So, is it a wrong lockdep annotation or is it a real problem? I've
attached dmesg and config.

Thanks.

[    0.023211] Setting APIC routing to flat
[    0.024378] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.034634] CPU0: AMD Phenom(tm) II X4 940 Processor stepping 02
[    0.034997] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.034997] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.034997] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.034997] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.034997] calling  init_hw_perf_events+0x0/0xbfa @ 1
[    0.034997] Performance Events: AMD PMU driver.
[    0.035003] ... version:                0
[    0.035140] ... bit width:              48
[    0.035278] ... generic registers:      4
[    0.035415] ... value mask:             0000ffffffffffff
[    0.035554] ... max period:             00007fffffffffff
[    0.035692] ... fixed-purpose events:   0
[    0.035829] ... event mask:             000000000000000f
[    0.036035] initcall init_hw_perf_events+0x0/0xbfa returned 0 after 1952 usecs
[    0.036276] calling  migration_init+0x0/0x6d @ 1
[    0.036418] initcall migration_init+0x0/0x6d returned 0 after 0 usecs
[    0.036558] calling  spawn_ksoftirqd+0x0/0x52 @ 1
[    0.036786] System has AMD C1E enabled
[    0.036937] Switch to broadcast mode on CPU0
[    0.037063] ------------[ cut here ]------------
[    0.037210] WARNING: at kernel/lockdep.c:3151 check_flags+0x63/0x179()
[    0.037349] Hardware name: System Product Name
[    0.037487] Modules linked in:
[    0.037658] Pid: 1, comm: swapper Not tainted 2.6.38-rc4-00001-g1e554e3-dirty #11
[    0.037898] Call Trace:
[    0.037997]  [<ffffffff81039906>] ? warn_slowpath_common+0x85/0x9d
[    0.037997]  [<ffffffff81048251>] ? del_timer_sync+0x0/0xa0
[    0.037997]  [<ffffffff81039938>] ? warn_slowpath_null+0x1a/0x1c
[    0.037997]  [<ffffffff81066f1c>] ? check_flags+0x63/0x179
[    0.037997]  [<ffffffff8106c664>] ? lock_acquire+0x4c/0x192
[    0.037997]  [<ffffffff81048273>] ? del_timer_sync+0x22/0xa0
[    0.037997]  [<ffffffff81048292>] ? del_timer_sync+0x41/0xa0
[    0.037997]  [<ffffffff81048251>] ? del_timer_sync+0x0/0xa0
[    0.037997]  [<ffffffff81439969>] ? schedule_timeout+0x35c/0x3bb
[    0.037997]  [<ffffffff81047e9e>] ? process_timeout+0x0/0x10
[    0.037997]  [<ffffffff814399e6>] ? schedule_timeout_uninterruptible+0x1e/0x20
[    0.037997]  [<ffffffff81036c44>] ? wait_task_inactive+0x181/0x1cd
[    0.037997]  [<ffffffff810584bc>] ? kthread_bind+0x1c/0x6d
[    0.037997]  [<ffffffff81436007>] ? cpu_callback+0x87/0x3e8
[    0.037997]  [<ffffffff81931ed1>] ? spawn_ksoftirqd+0x0/0x52
[    0.037997]  [<ffffffff81931ef5>] ? spawn_ksoftirqd+0x24/0x52
[    0.037997]  [<ffffffff810001f2>] ? do_one_initcall+0x57/0x133
[    0.037997]  [<ffffffff8192258a>] ? kernel_init+0x67/0x1c1
[    0.037997]  [<ffffffff81002f94>] ? kernel_thread_helper+0x4/0x10
[    0.037997]  [<ffffffff81032a78>] ? finish_task_switch+0x80/0xec
[    0.037997]  [<ffffffff8143c499>] ? _raw_spin_unlock_irq+0x3b/0x58
[    0.037997]  [<ffffffff8143cb44>] ? restore_args+0x0/0x30
[    0.037997]  [<ffffffff81922523>] ? kernel_init+0x0/0x1c1
[    0.037997]  [<ffffffff81002f90>] ? kernel_thread_helper+0x0/0x10
[    0.037997] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.037997] possible reason: unannotated irqs-off.
[    0.037997] irq event stamp: 1000
[    0.037997] hardirqs last  enabled at (999): [<ffffffff8143c48e>] _raw_spin_unlock_irq+0x30/0x58
[    0.037997] hardirqs last disabled at (998): [<ffffffff8143ba38>] _raw_spin_lock_irq+0x19/0x79
[    0.037997] softirqs last  enabled at (908): [<ffffffff81040864>] __do_softirq+0x2a0/0x2f0
[    0.037997] softirqs last disabled at (1000): [<ffffffff81048273>] del_timer_sync+0x22/0xa0
[    0.038006] initcall spawn_ksoftirqd+0x0/0x52 returned 0 after 1952 usecs
[    0.039000] calling  init_workqueues+0x0/0x34d @ 1
[    0.040114] initcall init_workqueues+0x0/0x34d returned 0 after 976 usecs
[    0.041001] calling  init_call_single_data+0x0/0xaa @ 1
[    0.041143] initcall init_call_single_data+0x0/0xaa returned 0 after 0 usecs


-- 
Regards/Gruss,
    Boris.

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.log"

[    0.000000] Linux version 2.6.38-rc4-00001-g1e554e3-dirty (boris@liondog) (gcc version 4.4.5 (Debian 4.4.5-10) ) #11 SMP PREEMPT Tue Feb 8 07:52:51 CET 2011
[    0.000000] Command line: root=/dev/sda1 vga=0 log_bug_len=10M resume=/dev/hda2 no_console_suspend debug initcall_debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffbe000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: M3A78 PRO/System Product Name, BIOS 1203    06/29/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000230000000 aka 8960M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcffb0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cffb0000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cffb0000 page 4k
[    0.000000] kernel direct mapping tables up to cffb0000 @ 1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
[    0.000000]  0100000000 - 0200000000 page 1G
[    0.000000]  0200000000 - 0230000000 page 2M
[    0.000000] kernel direct mapping tables up to 230000000 @ cffae000-cffb0000
[    0.000000] ACPI: RSDP 00000000000fa1e0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cffb0100 00054 (v01 062909 OEMXSDT  20090629 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cffb0290 000F4 (v03 062909 OEMFACP  20090629 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cffb0440 09099 (v01  P0020 P0020000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cffbe000 00040
[    0.000000] ACPI: APIC 00000000cffb0390 0006C (v01 062909 OEMAPIC  20090629 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cffb0400 0003C (v01 062909 OEMMCFG  20090629 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffbe040 00071 (v01 062909 AMI_OEM  20090629 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cffb94e0 00038 (v01 062909 OEMHPET  20090629 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cffb9520 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff8800bc000000-ffff8800c31fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cffb0
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] On node 0 totalpages: 2096959
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833512 pages, LIFO batch:31
[    0.000000]   Normal zone: 17024 pages used for memmap
[    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cffb0000 - 00000000cffbe000
[    0.000000] PM: Registered nosave memory: 00000000cffbe000 - 00000000cffe0000
[    0.000000] PM: Registered nosave memory: 00000000cffe0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000ff700000
[    0.000000] PM: Registered nosave memory: 00000000ff700000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2f700000)
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff8800cee00000 s1909760 r8192 d23552 u2097152
[    0.000000] pcpu-alloc: s1909760 r8192 d23552 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2065593
[    0.000000] Kernel command line: root=/dev/sda1 vga=0 log_bug_len=10M resume=/dev/hda2 no_console_suspend debug initcall_debug
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 8097652k/9175040k available (4351k kernel code, 787204k absent, 290184k reserved, 3128k data, 2344k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:384
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
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
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3007.390 MHz processor.
[    0.002003] Calibrating delay loop (skipped), value calculated using timer frequency.. 6014.78 BogoMIPS (lpj=3007390)
[    0.002282] pid_max: default: 32768 minimum: 301
[    0.002624] Mount-cache hash table entries: 256
[    0.004176] tseg: 0000000000
[    0.004333] CPU: Physical Processor ID: 0
[    0.004471] CPU: Processor Core ID: 0
[    0.004609] mce: CPU supports 6 MCE banks
[    0.004754] using C1E aware idle routine
[    0.004947] ACPI: Core revision 20110112
[    0.022063] ftrace: allocating 17116 entries in 68 pages
[    0.023211] Setting APIC routing to flat
[    0.024378] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.034634] CPU0: AMD Phenom(tm) II X4 940 Processor stepping 02
[    0.034997] calling  trace_init_flags_sys_exit+0x0/0x12 @ 1
[    0.034997] initcall trace_init_flags_sys_exit+0x0/0x12 returned 0 after 0 usecs
[    0.034997] calling  trace_init_flags_sys_enter+0x0/0x12 @ 1
[    0.034997] initcall trace_init_flags_sys_enter+0x0/0x12 returned 0 after 0 usecs
[    0.034997] calling  init_hw_perf_events+0x0/0xbfa @ 1
[    0.034997] Performance Events: AMD PMU driver.
[    0.035003] ... version:                0
[    0.035140] ... bit width:              48
[    0.035278] ... generic registers:      4
[    0.035415] ... value mask:             0000ffffffffffff
[    0.035554] ... max period:             00007fffffffffff
[    0.035692] ... fixed-purpose events:   0
[    0.035829] ... event mask:             000000000000000f
[    0.036035] initcall init_hw_perf_events+0x0/0xbfa returned 0 after 1952 usecs
[    0.036276] calling  migration_init+0x0/0x6d @ 1
[    0.036418] initcall migration_init+0x0/0x6d returned 0 after 0 usecs
[    0.036558] calling  spawn_ksoftirqd+0x0/0x52 @ 1
[    0.036786] System has AMD C1E enabled
[    0.036937] Switch to broadcast mode on CPU0
[    0.037063] ------------[ cut here ]------------
[    0.037210] WARNING: at kernel/lockdep.c:3151 check_flags+0x63/0x179()
[    0.037349] Hardware name: System Product Name
[    0.037487] Modules linked in:
[    0.037658] Pid: 1, comm: swapper Not tainted 2.6.38-rc4-00001-g1e554e3-dirty #11
[    0.037898] Call Trace:
[    0.037997]  [<ffffffff81039906>] ? warn_slowpath_common+0x85/0x9d
[    0.037997]  [<ffffffff81048251>] ? del_timer_sync+0x0/0xa0
[    0.037997]  [<ffffffff81039938>] ? warn_slowpath_null+0x1a/0x1c
[    0.037997]  [<ffffffff81066f1c>] ? check_flags+0x63/0x179
[    0.037997]  [<ffffffff8106c664>] ? lock_acquire+0x4c/0x192
[    0.037997]  [<ffffffff81048273>] ? del_timer_sync+0x22/0xa0
[    0.037997]  [<ffffffff81048292>] ? del_timer_sync+0x41/0xa0
[    0.037997]  [<ffffffff81048251>] ? del_timer_sync+0x0/0xa0
[    0.037997]  [<ffffffff81439969>] ? schedule_timeout+0x35c/0x3bb
[    0.037997]  [<ffffffff81047e9e>] ? process_timeout+0x0/0x10
[    0.037997]  [<ffffffff814399e6>] ? schedule_timeout_uninterruptible+0x1e/0x20
[    0.037997]  [<ffffffff81036c44>] ? wait_task_inactive+0x181/0x1cd
[    0.037997]  [<ffffffff810584bc>] ? kthread_bind+0x1c/0x6d
[    0.037997]  [<ffffffff81436007>] ? cpu_callback+0x87/0x3e8
[    0.037997]  [<ffffffff81931ed1>] ? spawn_ksoftirqd+0x0/0x52
[    0.037997]  [<ffffffff81931ef5>] ? spawn_ksoftirqd+0x24/0x52
[    0.037997]  [<ffffffff810001f2>] ? do_one_initcall+0x57/0x133
[    0.037997]  [<ffffffff8192258a>] ? kernel_init+0x67/0x1c1
[    0.037997]  [<ffffffff81002f94>] ? kernel_thread_helper+0x4/0x10
[    0.037997]  [<ffffffff81032a78>] ? finish_task_switch+0x80/0xec
[    0.037997]  [<ffffffff8143c499>] ? _raw_spin_unlock_irq+0x3b/0x58
[    0.037997]  [<ffffffff8143cb44>] ? restore_args+0x0/0x30
[    0.037997]  [<ffffffff81922523>] ? kernel_init+0x0/0x1c1
[    0.037997]  [<ffffffff81002f90>] ? kernel_thread_helper+0x0/0x10
[    0.037997] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.037997] possible reason: unannotated irqs-off.
[    0.037997] irq event stamp: 1000
[    0.037997] hardirqs last  enabled at (999): [<ffffffff8143c48e>] _raw_spin_unlock_irq+0x30/0x58
[    0.037997] hardirqs last disabled at (998): [<ffffffff8143ba38>] _raw_spin_lock_irq+0x19/0x79
[    0.037997] softirqs last  enabled at (908): [<ffffffff81040864>] __do_softirq+0x2a0/0x2f0
[    0.037997] softirqs last disabled at (1000): [<ffffffff81048273>] del_timer_sync+0x22/0xa0
[    0.038006] initcall spawn_ksoftirqd+0x0/0x52 returned 0 after 1952 usecs
[    0.039000] calling  init_workqueues+0x0/0x34d @ 1
[    0.040114] initcall init_workqueues+0x0/0x34d returned 0 after 976 usecs
[    0.041001] calling  init_call_single_data+0x0/0xaa @ 1
[    0.041143] initcall init_call_single_data+0x0/0xaa returned 0 after 0 usecs
[    0.041284] calling  cpu_stop_init+0x0/0xc5 @ 1
[    0.042028] initcall cpu_stop_init+0x0/0xc5 returned 0 after 976 usecs
[    0.042172] calling  tracer_alloc_buffers+0x0/0x1c8 @ 1
[    0.043040] initcall tracer_alloc_buffers+0x0/0x1c8 returned 0 after 0 usecs
[    0.043180] calling  init_trace_printk+0x0/0x12 @ 1
[    0.043320] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.043460] calling  mce_amd_init+0x0/0x15d @ 1
[    0.043599] MCE: In-kernel MCE decoding enabled.
[    0.043738] initcall mce_amd_init+0x0/0x15d returned 0 after 0 usecs
[    0.046033] lockdep: fixing up alternatives.
[    0.048064] Booting Node   0, Processors  #1
[    0.119998] Switch to broadcast mode on CPU1
[    0.122034] lockdep: fixing up alternatives.
[    0.123035]  #2
[    0.194994] Switch to broadcast mode on CPU2
[    0.197035] lockdep: fixing up alternatives.
[    0.198032]  #3 Ok.
[    0.269987] Switch to broadcast mode on CPU3
[    0.269993] Brought up 4 CPUs
[    0.269995] Total of 4 processors activated (24016.16 BogoMIPS).
[    0.272127] calling  init_mmap_min_addr+0x0/0x16 @ 1
[    0.273971] initcall init_mmap_min_addr+0x0/0x16 returned 0 after 0 usecs
[    0.274113] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.274974] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.275218] calling  net_ns_init+0x0/0x19a @ 1
[    0.275362] initcall net_ns_init+0x0/0x19a returned 0 after 0 usecs
[    0.275503] calling  e820_mark_nvs_memory+0x0/0x40 @ 1
[    0.275662] initcall e820_mark_nvs_memory+0x0/0x40 returned 0 after 0 usecs
[    0.275803] calling  cpufreq_tsc+0x0/0x37 @ 1
[    0.275970] initcall cpufreq_tsc+0x0/0x37 returned 0 after 0 usecs
[    0.276110] calling  pci_reboot_init+0x0/0x14 @ 1
[    0.276251] initcall pci_reboot_init+0x0/0x14 returned 0 after 0 usecs
[    0.276391] calling  init_lapic_sysfs+0x0/0x30 @ 1
[    0.276550] initcall init_lapic_sysfs+0x0/0x30 returned 0 after 0 usecs
[    0.276971] calling  init_smp_flush+0x0/0x4f @ 1
[    0.277112] initcall init_smp_flush+0x0/0x4f returned 0 after 0 usecs
[    0.277253] calling  alloc_frozen_cpus+0x0/0xd @ 1
[    0.277392] initcall alloc_frozen_cpus+0x0/0xd returned 0 after 0 usecs
[    0.277533] calling  sysctl_init+0x0/0x16 @ 1
[    0.277674] initcall sysctl_init+0x0/0x16 returned 0 after 0 usecs
[    0.277814] calling  ksysfs_init+0x0/0x94 @ 1
[    0.277976] initcall ksysfs_init+0x0/0x94 returned 0 after 0 usecs
[    0.278116] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.278257] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.278499] calling  pm_init+0x0/0x39 @ 1
[    0.278646] initcall pm_init+0x0/0x39 returned 0 after 0 usecs
[    0.278786] calling  pm_disk_init+0x0/0x19 @ 1
[    0.278928] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.278970] calling  swsusp_header_init+0x0/0x31 @ 1
[    0.279110] initcall swsusp_header_init+0x0/0x31 returned 0 after 0 usecs
[    0.279251] calling  init_zero_pfn+0x0/0x35 @ 1
[    0.279391] initcall init_zero_pfn+0x0/0x35 returned 0 after 0 usecs
[    0.279531] calling  fsnotify_init+0x0/0x34 @ 1
[    0.279672] initcall fsnotify_init+0x0/0x34 returned 0 after 0 usecs
[    0.279812] calling  filelock_init+0x0/0x2e @ 1
[    0.279980] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.280120] calling  init_script_binfmt+0x0/0x14 @ 1
[    0.280260] initcall init_script_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.280400] calling  init_elf_binfmt+0x0/0x14 @ 1
[    0.280539] initcall init_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.280680] calling  init_compat_elf_binfmt+0x0/0x14 @ 1
[    0.280820] initcall init_compat_elf_binfmt+0x0/0x14 returned 0 after 0 usecs
[    0.280969] calling  debugfs_init+0x0/0x5c @ 1
[    0.281111] initcall debugfs_init+0x0/0x5c returned 0 after 0 usecs
[    0.281251] calling  random32_init+0x0/0xd8 @ 1
[    0.281391] initcall random32_init+0x0/0xd8 returned 0 after 0 usecs
[    0.281531] calling  cpufreq_core_init+0x0/0xa3 @ 1
[    0.281674] initcall cpufreq_core_init+0x0/0xa3 returned 0 after 0 usecs
[    0.281814] calling  cpuidle_init+0x0/0x40 @ 1
[    0.281973] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.282113] calling  sock_init+0x0/0x83 @ 1
[    0.282337] initcall sock_init+0x0/0x83 returned 0 after 0 usecs
[    0.282477] calling  netpoll_init+0x0/0x41 @ 1
[    0.282617] initcall netpoll_init+0x0/0x41 returned 0 after 0 usecs
[    0.282757] calling  netlink_proto_init+0x0/0x1c7 @ 1
[    0.282991] NET: Registered protocol family 16
[    0.283157] initcall netlink_proto_init+0x0/0x1c7 returned 0 after 0 usecs
[    0.283298] calling  bdi_class_init+0x0/0x4d @ 1
[    0.283460] initcall bdi_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.283460] calling  kobject_uevent_init+0x0/0x21 @ 1
[    0.283460] initcall kobject_uevent_init+0x0/0x21 returned 0 after 0 usecs
[    0.283969] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.284135] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.284135] calling  pci_driver_init+0x0/0x12 @ 1
[    0.284276] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.284276] calling  tty_class_init+0x0/0x38 @ 1
[    0.284991] initcall tty_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.285115] calling  vtconsole_class_init+0x0/0xc2 @ 1
[    0.285275] initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
[    0.285275] calling  wakeup_sources_debugfs_init+0x0/0x2b @ 1
[    0.285275] initcall wakeup_sources_debugfs_init+0x0/0x2b returned 0 after 0 usecs
[    0.285968] calling  i2c_init+0x0/0x3e @ 1
[    0.286130] initcall i2c_init+0x0/0x3e returned 0 after 0 usecs
[    0.286130] calling  amd_postcore_init+0x0/0x150 @ 1
[    0.286257] node 0 link 0: io port [1000, ffffff]
[    0.286397] TOM: 00000000d0000000 aka 3328M
[    0.286968] Fam 10h mmconf [e0000000, efffffff]
[    0.287107] node 0 link 0: mmio [a0000, bffff]
[    0.287280] node 0 link 0: mmio [d0000000, dfffffff]
[    0.287453] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.287627] node 0 link 0: mmio [f0000000, ffefffff]
[    0.287799] TOM2: 0000000230000000 aka 8960M
[    0.287799] bus: [00, 07] on node 0 link 0
[    0.287799] bus: 00 index 0 [io  0x0000-0xffff]
[    0.287799] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.287799] bus: 00 index 2 [mem 0xd0000000-0xdfffffff]
[    0.287799] bus: 00 index 3 [mem 0xf0000000-0xffffffff]
[    0.287799] bus: 00 index 4 [mem 0x230000000-0xfcffffffff]
[    0.287808] Extended Config Space enabled on 1 nodes
[    0.287978] initcall amd_postcore_init+0x0/0x150 returned 0 after 2929 usecs
[    0.288120] calling  arch_kdebugfs_init+0x0/0x24 @ 1
[    0.288264] initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.288404] calling  mtrr_if_init+0x0/0x78 @ 1
[    0.288548] initcall mtrr_if_init+0x0/0x78 returned 0 after 0 usecs
[    0.288688] calling  acpi_configure_wakeup_memory+0x0/0x1e @ 1
[    0.288832] initcall acpi_configure_wakeup_memory+0x0/0x1e returned 0 after 0 usecs
[    0.289968] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.290107] initcall ffh_cstate_init+0x0/0x2a returned -1 after 0 usecs
[    0.290247] initcall ffh_cstate_init+0x0/0x2a returned with error code -1 
[    0.290389] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.290527] ACPI: bus type pci registered
[    0.290666] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
[    0.290807] calling  pci_arch_init+0x0/0x69 @ 1
[    0.290991] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.291234] PCI: not using MMCONFIG
[    0.291373] PCI: Using configuration type 1 for base access
[    0.291512] PCI: Using configuration type 1 for extended access
[    0.291655] initcall pci_arch_init+0x0/0x69 returned 0 after 0 usecs
[    0.291796] calling  topology_init+0x0/0x40 @ 1
[    0.292018] initcall topology_init+0x0/0x40 returned 0 after 0 usecs
[    0.292115] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    0.292254] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.292393] mtrr: probably your BIOS does not setup all CPUs.
[    0.292966] mtrr: corrected configuration.
[    0.293106] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 976 usecs
[    0.293246] calling  init_vdso_vars+0x0/0x221 @ 1
[    0.293392] initcall init_vdso_vars+0x0/0x221 returned 0 after 0 usecs
[    0.293533] calling  sysenter_setup+0x0/0x2d8 @ 1
[    0.293674] initcall sysenter_setup+0x0/0x2d8 returned 0 after 0 usecs
[    0.293815] calling  param_sysfs_init+0x0/0x191 @ 1
[    0.308024] initcall param_sysfs_init+0x0/0x191 returned 0 after 14646 usecs
[    0.308116] calling  pm_sysrq_init+0x0/0x1e @ 1
[    0.308968] initcall pm_sysrq_init+0x0/0x1e returned 0 after 0 usecs
[    0.309109] calling  default_bdi_init+0x0/0xb2 @ 1
[    0.309250] initcall default_bdi_init+0x0/0xb2 returned 0 after 0 usecs
[    0.309250] calling  init_bio+0x0/0xef @ 1
[    0.309301] bio: create slab <bio-0> at 0
[    0.309994] initcall init_bio+0x0/0xef returned 0 after 976 usecs
[    0.310134] calling  fsnotify_notification_init+0x0/0x8b @ 1
[    0.310286] initcall fsnotify_notification_init+0x0/0x8b returned 0 after 0 usecs
[    0.310528] calling  cryptomgr_init+0x0/0x12 @ 1
[    0.310668] initcall cryptomgr_init+0x0/0x12 returned 0 after 0 usecs
[    0.310808] calling  blk_settings_init+0x0/0x2a @ 1
[    0.310965] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.311106] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.311250] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.311390] calling  blk_softirq_init+0x0/0x6e @ 1
[    0.311531] initcall blk_softirq_init+0x0/0x6e returned 0 after 0 usecs
[    0.311671] calling  blk_iopoll_setup+0x0/0x6e @ 1
[    0.311811] initcall blk_iopoll_setup+0x0/0x6e returned 0 after 0 usecs
[    0.311964] calling  genhd_device_init+0x0/0x7b @ 1
[    0.312124] initcall genhd_device_init+0x0/0x7b returned 0 after 0 usecs
[    0.312124] calling  pci_slot_init+0x0/0x4b @ 1
[    0.312264] initcall pci_slot_init+0x0/0x4b returned 0 after 0 usecs
[    0.312405] calling  fbmem_init+0x0/0x98 @ 1
[    0.313164] initcall fbmem_init+0x0/0x98 returned 0 after 976 usecs
[    0.313164] calling  acpi_init+0x0/0x10a @ 1
[    0.314916] ACPI: EC: Look up EC in DSDT
[    0.318434] ACPI: Executed 2 blocks of module-level executable AML code
[    0.339705] ACPI: Interpreter enabled
[    0.339846] ACPI: (supports S0 S1 S3 S4 S5)
[    0.340206] ACPI: Using IOAPIC for interrupt routing
[    0.340518] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.342288] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.409973] initcall acpi_init+0x0/0x10a returned 0 after 94712 usecs
[    0.410119] calling  dock_init+0x0/0xa5 @ 1
[    0.410549] ACPI: No dock devices found.
[    0.410693] initcall dock_init+0x0/0xa5 returned 0 after 976 usecs
[    0.411950] calling  acpi_pci_root_init+0x0/0x2d @ 1
[    0.412090] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.412650] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.413439] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.413580] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.413720] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.413949] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.414190] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xdfffffff]
[    0.414430] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.414686] pci 0000:00:00.0: [1022:9600] type 0 class 0x000600
[    0.416983] pci 0000:00:02.0: [1022:9603] type 1 class 0x000604
[    0.417156] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.417300] pci 0000:00:02.0: PME# disabled
[    0.418001] pci 0000:00:11.0: [1002:4390] type 0 class 0x000101
[    0.418163] pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
[    0.418311] pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
[    0.418459] pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
[    0.418606] pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
[    0.418754] pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
[    0.418956] pci 0000:00:11.0: reg 24: [mem 0xfe9ff800-0xfe9ffbff]
[    0.419116] pci 0000:00:11.0: set SATA to AHCI mode
[    0.419301] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.419453] pci 0000:00:12.0: reg 10: [mem 0xfe9fe000-0xfe9fefff]
[    0.419664] pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
[    0.419816] pci 0000:00:12.1: reg 10: [mem 0xfe9fd000-0xfe9fdfff]
[    0.420025] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.420184] pci 0000:00:12.2: reg 10: [mem 0xfe9ff000-0xfe9ff0ff]
[    0.420401] pci 0000:00:12.2: supports D1 D2
[    0.420539] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.420680] pci 0000:00:12.2: PME# disabled
[    0.420843] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.420960] pci 0000:00:13.0: reg 10: [mem 0xfe9fc000-0xfe9fcfff]
[    0.421171] pci 0000:00:13.1: [1002:4398] type 0 class 0x000c03
[    0.421323] pci 0000:00:13.1: reg 10: [mem 0xfe9fb000-0xfe9fbfff]
[    0.421540] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.421698] pci 0000:00:13.2: reg 10: [mem 0xfe9fa800-0xfe9fa8ff]
[    0.422024] pci 0000:00:13.2: supports D1 D2
[    0.422162] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.422303] pci 0000:00:13.2: PME# disabled
[    0.422469] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.422716] pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
[    0.422872] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.422956] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.423103] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.423251] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.423399] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.423593] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.423754] pci 0000:00:14.2: reg 10: [mem 0xfe9f4000-0xfe9f7fff 64bit]
[    0.424010] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.424152] pci 0000:00:14.2: PME# disabled
[    0.424305] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.424528] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.424713] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.424865] pci 0000:00:14.5: reg 10: [mem 0xfe9f9000-0xfe9f9fff]
[    0.425022] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.425185] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.425351] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.425511] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.425674] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.425674] pci 0000:01:00.0: [1002:9598] type 0 class 0x000300
[    0.425674] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.425674] pci 0000:01:00.0: reg 18: [mem 0xfeaf0000-0xfeafffff 64bit]
[    0.425674] pci 0000:01:00.0: reg 20: [io  0xd000-0xd0ff]
[    0.425674] pci 0000:01:00.0: reg 30: [mem 0xfeac0000-0xfeadffff pref]
[    0.425779] pci 0000:01:00.0: supports D1 D2
[    0.425938] pci 0000:01:00.1: [1002:aa20] type 0 class 0x000403
[    0.426959] pci 0000:01:00.1: reg 10: [mem 0xfeaec000-0xfeaeffff 64bit]
[    0.427147] pci 0000:01:00.1: supports D1 D2
[    0.428979] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.429125] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    0.429266] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.429408] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.429703] pci 0000:02:06.0: [10ec:8139] type 0 class 0x000200
[    0.430969] pci 0000:02:06.0: reg 10: [io  0xe800-0xe8ff]
[    0.431120] pci 0000:02:06.0: reg 14: [mem 0xfebffc00-0xfebffcff]
[    0.431316] pci 0000:02:06.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.431484] pci 0000:02:06.0: supports D1 D2
[    0.431621] pci 0000:02:06.0: PME# supported from D1 D2 D3hot
[    0.431764] pci 0000:02:06.0: PME# disabled
[    0.431996] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.432139] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
[    0.432280] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.432423] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.432665] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.432946] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.433187] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.433428] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.433670] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
[    0.433945] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.434196] pci_bus 0000:00: on NUMA node 0
[    0.434341] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.434903] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.436202] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.456025] initcall acpi_pci_root_init+0x0/0x2d returned 0 after 42962 usecs
[    0.456095] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.456358] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.457505] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.458198] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.458198] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.458774] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.459502] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.461200] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 15) *0, disabled.
[    0.461200] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.462004] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 5858 usecs
[    0.462089] calling  pnp_init+0x0/0x12 @ 1
[    0.462966] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    0.463097] calling  misc_init+0x0/0xb7 @ 1
[    0.463262] initcall misc_init+0x0/0xb7 returned 0 after 0 usecs
[    0.463262] calling  vga_arb_device_init+0x0/0x80 @ 1
[    0.463280] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.463280] vgaarb: loaded
[    0.463345] initcall vga_arb_device_init+0x0/0x80 returned 0 after 976 usecs
[    0.463486] calling  init_scsi+0x0/0x7c @ 1
[    0.464977] SCSI subsystem initialized
[    0.465085] initcall init_scsi+0x0/0x7c returned 0 after 976 usecs
[    0.465225] calling  ata_init+0x0/0x30a @ 1
[    0.465389] libata version 3.00 loaded.
[    0.465941] initcall ata_init+0x0/0x30a returned 0 after 976 usecs
[    0.466081] calling  usb_init+0x0/0x173 @ 1
[    0.466253] usbcore: registered new interface driver usbfs
[    0.466253] usbcore: registered new interface driver hub
[    0.466967] usbcore: registered new device driver usb
[    0.467085] initcall usb_init+0x0/0x173 returned 0 after 976 usecs
[    0.467225] calling  serio_init+0x0/0x31 @ 1
[    0.467388] initcall serio_init+0x0/0x31 returned 0 after 0 usecs
[    0.467388] calling  input_init+0x0/0x10d @ 1
[    0.467977] initcall input_init+0x0/0x10d returned 0 after 976 usecs
[    0.468100] calling  rtc_init+0x0/0x71 @ 1
[    0.468258] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    0.468258] calling  power_supply_class_init+0x0/0x44 @ 1
[    0.468258] initcall power_supply_class_init+0x0/0x44 returned 0 after 0 usecs
[    0.468940] calling  hwmon_init+0x0/0xee @ 1
[    0.469104] initcall hwmon_init+0x0/0xee returned 0 after 0 usecs
[    0.469104] calling  init_soundcore+0x0/0x95 @ 1
[    0.469245] initcall init_soundcore+0x0/0x95 returned 0 after 0 usecs
[    0.469245] calling  alsa_sound_init+0x0/0x95 @ 1
[    0.469245] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.469245] initcall alsa_sound_init+0x0/0x95 returned 0 after 976 usecs
[    0.469249] calling  pci_subsys_init+0x0/0x4d @ 1
[    0.469387] PCI: Using ACPI for IRQ routing
[    0.469526] PCI: pci_cache_line_size set to 64 bytes
[    0.469815] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    0.469856] reserve RAM buffer: 00000000cffb0000 - 00000000cfffffff 
[    0.470945] initcall pci_subsys_init+0x0/0x4d returned 0 after 976 usecs
[    0.471219] calling  proto_init+0x0/0x12 @ 1
[    0.471362] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.471502] calling  net_dev_init+0x0/0x222 @ 1
[    0.471972] initcall net_dev_init+0x0/0x222 returned 0 after 976 usecs
[    0.472104] calling  neigh_init+0x0/0x71 @ 1
[    0.472244] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    0.472384] calling  pktsched_init+0x0/0xec @ 1
[    0.472528] initcall pktsched_init+0x0/0xec returned 0 after 0 usecs
[    0.472940] calling  tc_filter_init+0x0/0x4c @ 1
[    0.473079] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    0.473219] calling  tc_action_init+0x0/0x4c @ 1
[    0.473358] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    0.473497] calling  genl_init+0x0/0x84 @ 1
[    0.473664] initcall genl_init+0x0/0x84 returned 0 after 0 usecs
[    0.473803] calling  sysctl_init+0x0/0x48 @ 1
[    0.473941] initcall sysctl_init+0x0/0x48 returned 0 after 0 usecs
[    0.474081] calling  print_ICs+0x0/0x553 @ 1
[    0.474220] initcall print_ICs+0x0/0x553 returned 0 after 0 usecs
[    0.474359] calling  hpet_late_init+0x0/0xd0 @ 1
[    0.474505] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.474813] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.476939] initcall hpet_late_init+0x0/0xd0 returned 0 after 2929 usecs
[    0.477079] calling  init_amd_nbs+0x0/0x3f @ 1
[    0.477305] initcall init_amd_nbs+0x0/0x3f returned 0 after 0 usecs
[    0.477445] calling  clocksource_done_booting+0x0/0x5e @ 1
[    0.477586] Switching to clocksource hpet
[    0.477765] initcall clocksource_done_booting+0x0/0x5e returned 0 after 4 usecs
[    0.477738] Switched to NOHz mode on CPU #3
[    0.477725] Switched to NOHz mode on CPU #0
[    0.477731] Switched to NOHz mode on CPU #1
[    0.480212] Switched to NOHz mode on CPU #2
[    0.480354] calling  ftrace_init_debugfs+0x0/0x20d @ 1
[    0.480553] initcall ftrace_init_debugfs+0x0/0x20d returned 0 after 57 usecs
[    0.480694] calling  rb_init_debugfs+0x0/0x2f @ 1
[    0.480843] initcall rb_init_debugfs+0x0/0x2f returned 0 after 8 usecs
[    0.480983] calling  tracer_init_debugfs+0x0/0x38c @ 1
[    0.481369] initcall tracer_init_debugfs+0x0/0x38c returned 0 after 215 usecs
[    0.481510] calling  init_trace_printk_function_export+0x0/0x2f @ 1
[    0.481656] initcall init_trace_printk_function_export+0x0/0x2f returned 0 after 4 usecs
[    0.481897] calling  event_trace_init+0x0/0x2bd @ 1
[    0.485992] initcall event_trace_init+0x0/0x2bd returned 0 after 3836 usecs
[    0.486161] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.486324] initcall init_pipe_fs+0x0/0x4c returned 0 after 23 usecs
[    0.486465] calling  eventpoll_init+0x0/0xdb @ 1
[    0.486618] initcall eventpoll_init+0x0/0xdb returned 0 after 12 usecs
[    0.486758] calling  anon_inode_init+0x0/0x131 @ 1
[    0.486917] initcall anon_inode_init+0x0/0x131 returned 0 after 19 usecs
[    0.487083] calling  blk_scsi_ioctl_init+0x0/0x289 @ 1
[    0.487224] initcall blk_scsi_ioctl_init+0x0/0x289 returned 0 after 0 usecs
[    0.487364] calling  acpi_event_init+0x0/0x52 @ 1
[    0.487535] initcall acpi_event_init+0x0/0x52 returned 0 after 30 usecs
[    0.487674] calling  pnp_system_init+0x0/0x12 @ 1
[    0.487975] initcall pnp_system_init+0x0/0x12 returned 0 after 155 usecs
[    0.488142] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.488281] pnp: PnP ACPI init
[    0.488438] ACPI: bus type pnp registered
[    0.488852] pnp 00:00: [bus 00-ff]
[    0.488991] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.489155] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.489294] pnp 00:00: [io  0x0d00-0xffff window]
[    0.489433] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.489573] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.489711] pnp 00:00: [mem 0xd0000000-0xdfffffff window]
[    0.489851] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.490212] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.490646] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.490786] pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.491169] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.491422] pnp 00:02: [dma 4]
[    0.491559] pnp 00:02: [io  0x0000-0x000f]
[    0.491697] pnp 00:02: [io  0x0081-0x0083]
[    0.491835] pnp 00:02: [io  0x0087]
[    0.491973] pnp 00:02: [io  0x0089-0x008b]
[    0.492141] pnp 00:02: [io  0x008f]
[    0.492279] pnp 00:02: [io  0x00c0-0x00df]
[    0.492605] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.492767] pnp 00:03: [io  0x0070-0x0071]
[    0.492912] pnp 00:03: [irq 8]
[    0.493247] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.493404] pnp 00:04: [io  0x0061]
[    0.493688] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.493845] pnp 00:05: [io  0x00f0-0x00ff]
[    0.493986] pnp 00:05: [irq 13]
[    0.494300] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.497583] pnp 00:06: [io  0x03f0-0x03f5]
[    0.497722] pnp 00:06: [io  0x03f7]
[    0.497862] pnp 00:06: [irq 6]
[    0.498011] pnp 00:06: [dma 2]
[    0.498383] pnp 00:06: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.498645] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.498980] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.499313] pnp 00:08: [mem 0xfec00000-0xfec00fff]
[    0.499452] pnp 00:08: [mem 0xfee00000-0xfee00fff]
[    0.499854] system 00:08: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.499995] system 00:08: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.500162] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.500567] pnp 00:09: [io  0x0010-0x001f]
[    0.500706] pnp 00:09: [io  0x0022-0x003f]
[    0.500844] pnp 00:09: [io  0x0062-0x0063]
[    0.500982] pnp 00:09: [io  0x0065-0x006f]
[    0.501146] pnp 00:09: [io  0x0072-0x007f]
[    0.501284] pnp 00:09: [io  0x0080]
[    0.501422] pnp 00:09: [io  0x0084-0x0086]
[    0.501560] pnp 00:09: [io  0x0088]
[    0.501697] pnp 00:09: [io  0x008c-0x008e]
[    0.501836] pnp 00:09: [io  0x0090-0x009f]
[    0.501974] pnp 00:09: [io  0x00a2-0x00bf]
[    0.502137] pnp 00:09: [io  0x00b1]
[    0.502274] pnp 00:09: [io  0x00e0-0x00ef]
[    0.502412] pnp 00:09: [io  0x04d0-0x04d1]
[    0.502550] pnp 00:09: [io  0x040b]
[    0.502688] pnp 00:09: [io  0x04d6]
[    0.502825] pnp 00:09: [io  0x0c00-0x0c01]
[    0.502967] pnp 00:09: [io  0x0c14]
[    0.503129] pnp 00:09: [io  0x0c50-0x0c51]
[    0.503267] pnp 00:09: [io  0x0c52]
[    0.503405] pnp 00:09: [io  0x0c6c]
[    0.503543] pnp 00:09: [io  0x0c6f]
[    0.503680] pnp 00:09: [io  0x0cd0-0x0cd1]
[    0.503819] pnp 00:09: [io  0x0cd2-0x0cd3]
[    0.503956] pnp 00:09: [io  0x0cd4-0x0cd5]
[    0.504119] pnp 00:09: [io  0x0cd6-0x0cd7]
[    0.504257] pnp 00:09: [io  0x0cd8-0x0cdf]
[    0.504397] pnp 00:09: [io  0x0800-0x089f]
[    0.504534] pnp 00:09: [io  0x0b00-0x0b3f]
[    0.504673] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.504813] pnp 00:09: [io  0x0900-0x090f]
[    0.504950] pnp 00:09: [io  0x0910-0x091f]
[    0.505114] pnp 00:09: [io  0xfe00-0xfefe]
[    0.505252] pnp 00:09: [mem 0xffb80000-0xffbfffff]
[    0.505391] pnp 00:09: [mem 0xfec10000-0xfec1001f]
[    0.505808] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.505949] system 00:09: [io  0x040b] has been reserved
[    0.506117] system 00:09: [io  0x04d6] has been reserved
[    0.506257] system 00:09: [io  0x0c00-0x0c01] has been reserved
[    0.506397] system 00:09: [io  0x0c14] has been reserved
[    0.506537] system 00:09: [io  0x0c50-0x0c51] has been reserved
[    0.506677] system 00:09: [io  0x0c52] has been reserved
[    0.506817] system 00:09: [io  0x0c6c] has been reserved
[    0.506956] system 00:09: [io  0x0c6f] has been reserved
[    0.507120] system 00:09: [io  0x0cd0-0x0cd1] has been reserved
[    0.507260] system 00:09: [io  0x0cd2-0x0cd3] has been reserved
[    0.507400] system 00:09: [io  0x0cd4-0x0cd5] has been reserved
[    0.507540] system 00:09: [io  0x0cd6-0x0cd7] has been reserved
[    0.507681] system 00:09: [io  0x0cd8-0x0cdf] has been reserved
[    0.507821] system 00:09: [io  0x0800-0x089f] has been reserved
[    0.507960] system 00:09: [io  0x0b00-0x0b3f] has been reserved
[    0.508125] system 00:09: [io  0x0900-0x090f] has been reserved
[    0.508265] system 00:09: [io  0x0910-0x091f] has been reserved
[    0.508409] system 00:09: [io  0xfe00-0xfefe] has been reserved
[    0.508549] system 00:09: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.508690] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.508830] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.509066] pnp 00:0a: [io  0x0060]
[    0.509204] pnp 00:0a: [io  0x0064]
[    0.509345] pnp 00:0a: [irq 1]
[    0.509677] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.512962] pnp 00:0b: [io  0x03f8-0x03ff]
[    0.513130] pnp 00:0b: [irq 4]
[    0.513267] pnp 00:0b: [dma 0 disabled]
[    0.513653] pnp 00:0b: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.514312] pnp 00:0c: [io  0x0000-0xffffffffffffffff disabled]
[    0.514452] pnp 00:0c: [io  0x0e00-0x0e0f]
[    0.514591] pnp 00:0c: [io  0x0e80-0x0e8f]
[    0.514729] pnp 00:0c: [io  0x0f40-0x0f4f]
[    0.514867] pnp 00:0c: [io  0x0a30-0x0a3f]
[    0.515270] system 00:0c: [io  0x0e00-0x0e0f] has been reserved
[    0.515410] system 00:0c: [io  0x0e80-0x0e8f] has been reserved
[    0.515550] system 00:0c: [io  0x0f40-0x0f4f] has been reserved
[    0.515690] system 00:0c: [io  0x0a30-0x0a3f] has been reserved
[    0.515831] system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.516082] pnp 00:0d: [mem 0xe0000000-0xefffffff]
[    0.516458] system 00:0d: [mem 0xe0000000-0xefffffff] has been reserved
[    0.516598] system 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.517156] pnp 00:0e: [mem 0x00000000-0x0009ffff]
[    0.517295] pnp 00:0e: [mem 0x000c0000-0x000cffff]
[    0.517433] pnp 00:0e: [mem 0x000e0000-0x000fffff]
[    0.517572] pnp 00:0e: [mem 0x00100000-0xcfffffff]
[    0.517711] pnp 00:0e: [mem 0xfec00000-0xffffffff]
[    0.518125] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.518267] system 00:0e: [mem 0x000c0000-0x000cffff] has been reserved
[    0.518408] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.518550] system 00:0e: [mem 0x00100000-0xcfffffff] could not be reserved
[    0.518692] system 00:0e: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.518833] system 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.519357] pnp: PnP ACPI: found 15 devices
[    0.519495] ACPI: ACPI bus type pnp unregistered
[    0.519635] initcall pnpacpi_init+0x0/0x8c returned 0 after 30619 usecs
[    0.519775] calling  chr_dev_init+0x0/0xc5 @ 1
[    0.530843] initcall chr_dev_init+0x0/0xc5 returned 0 after 10668 usecs
[    0.530988] calling  firmware_class_init+0x0/0x19 @ 1
[    0.531261] initcall firmware_class_init+0x0/0x19 returned 0 after 103 usecs
[    0.531402] calling  thermal_init+0x0/0x8d @ 1
[    0.531677] initcall thermal_init+0x0/0x8d returned 0 after 130 usecs
[    0.531817] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.531959] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 1 usecs
[    0.532229] calling  init_acpi_pm_clocksource+0x0/0xf0 @ 1
[    0.536898] initcall init_acpi_pm_clocksource+0x0/0xf0 returned 0 after 4424 usecs
[    0.537162] calling  pcibios_assign_resources+0x0/0x74 @ 1
[    0.537371] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.537511] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    0.537652] pci 0000:00:02.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.537792] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.540623] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.540765] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
[    0.540908] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.541072] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.541225] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.541367] pci 0000:00:02.0: setting latency timer to 64
[    0.541512] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.541650] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.541790] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.541929] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.542090] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xdfffffff]
[    0.542233] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.542373] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.542511] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.542651] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.542892] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.543054] pci_bus 0000:02: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.543193] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.543332] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.543471] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.543610] pci_bus 0000:02: resource 7 [mem 0x000d0000-0x000dffff]
[    0.543750] pci_bus 0000:02: resource 8 [mem 0xd0000000-0xdfffffff]
[    0.543889] pci_bus 0000:02: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.544053] initcall pcibios_assign_resources+0x0/0x74 returned 0 after 6592 usecs
[    0.544296] calling  sysctl_core_init+0x0/0x38 @ 1
[    0.544443] initcall sysctl_core_init+0x0/0x38 returned 0 after 6 usecs
[    0.544583] calling  inet_init+0x0/0x233 @ 1
[    0.544771] NET: Registered protocol family 2
[    0.544976] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.545823] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.547329] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[    0.548367] TCP: Hash tables configured (established 262144 bind 32768)
[    0.548508] TCP reno registered
[    0.548662] UDP hash table entries: 4096 (order: 7, 786432 bytes)
[    0.549112] UDP-Lite hash table entries: 4096 (order: 7, 786432 bytes)
[    0.549665] initcall inet_init+0x0/0x233 returned 0 after 4824 usecs
[    0.549807] calling  af_unix_init+0x0/0x55 @ 1
[    0.549956] NET: Registered protocol family 1
[    0.550130] initcall af_unix_init+0x0/0x55 returned 0 after 176 usecs
[    0.550272] calling  pci_apply_final_quirks+0x0/0x106 @ 1
[    0.653869] pci 0000:01:00.0: Boot video device
[    0.654031] PCI: CLS 64 bytes, default 64
[    0.654174] initcall pci_apply_final_quirks+0x0/0x106 returned 0 after 101326 usecs
[    0.654417] calling  default_rootfs+0x0/0x6b @ 1
[    0.654624] initcall default_rootfs+0x0/0x6b returned 0 after 66 usecs
[    0.654764] calling  pci_iommu_init+0x0/0x41 @ 1
[    0.655495] PCI-DMA: Disabling AGP.
[    0.655978] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    0.656147] PCI-DMA: using GART IOMMU.
[    0.656285] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.660593] initcall pci_iommu_init+0x0/0x41 returned 0 after 5549 usecs
[    0.660738] calling  i8259A_init_sysfs+0x0/0x31 @ 1
[    0.661214] initcall i8259A_init_sysfs+0x0/0x31 returned 0 after 324 usecs
[    0.661354] calling  vsyscall_init+0x0/0x6c @ 1
[    0.661517] initcall vsyscall_init+0x0/0x6c returned 0 after 22 usecs
[    0.661658] calling  sbf_init+0x0/0xe9 @ 1
[    0.661799] initcall sbf_init+0x0/0xe9 returned 0 after 0 usecs
[    0.661938] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    0.662342] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 228 usecs
[    0.662483] calling  init_tsc_clocksource+0x0/0x5f @ 1
[    0.662633] initcall init_tsc_clocksource+0x0/0x5f returned 0 after 9 usecs
[    0.662773] calling  add_rtc_cmos+0x0/0x97 @ 1
[    0.662915] initcall add_rtc_cmos+0x0/0x97 returned 0 after 2 usecs
[    0.663085] calling  cache_sysfs_init+0x0/0x69 @ 1
[    0.665551] initcall cache_sysfs_init+0x0/0x69 returned 0 after 2270 usecs
[    0.665692] calling  mcheck_init_device+0x0/0x10e @ 1
[    0.666580] initcall mcheck_init_device+0x0/0x10e returned 0 after 728 usecs
[    0.666721] calling  threshold_init_device+0x0/0x8c @ 1
[    0.667230] initcall threshold_init_device+0x0/0x8c returned 0 after 359 usecs
[    0.667473] calling  ioapic_init_sysfs+0x0/0xb3 @ 1
[    0.667864] initcall ioapic_init_sysfs+0x0/0xb3 returned 0 after 244 usecs
[    0.668012] calling  add_pcspkr+0x0/0x3a @ 1
[    0.668299] initcall add_pcspkr+0x0/0x3a returned 0 after 125 usecs
[    0.668439] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    0.668582] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 2 usecs
[    0.668721] calling  init_aout_binfmt+0x0/0x14 @ 1
[    0.668863] initcall init_aout_binfmt+0x0/0x14 returned 0 after 1 usecs
[    0.669014] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    0.669177] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 7 usecs
[    0.669418] calling  proc_execdomains_init+0x0/0x22 @ 1
[    0.669563] initcall proc_execdomains_init+0x0/0x22 returned 0 after 5 usecs
[    0.669703] calling  ioresources_init+0x0/0x3c @ 1
[    0.669852] initcall ioresources_init+0x0/0x3c returned 0 after 8 usecs
[    0.669992] calling  uid_cache_init+0x0/0x8c @ 1
[    0.670169] initcall uid_cache_init+0x0/0x8c returned 0 after 13 usecs
[    0.670309] calling  init_posix_timers+0x0/0x17a @ 1
[    0.670455] initcall init_posix_timers+0x0/0x17a returned 0 after 6 usecs
[    0.670595] calling  init_posix_cpu_timers+0x0/0xe5 @ 1
[    0.670736] initcall init_posix_cpu_timers+0x0/0xe5 returned 0 after 1 usecs
[    0.670876] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    0.671042] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 6 usecs
[    0.671187] calling  timekeeping_init_device+0x0/0x22 @ 1
[    0.671590] initcall timekeeping_init_device+0x0/0x22 returned 0 after 255 usecs
[    0.671832] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    0.672241] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 261 usecs
[    0.672483] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    0.672628] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 5 usecs
[    0.672768] calling  init_tstats_procfs+0x0/0x2c @ 1
[    0.672912] initcall init_tstats_procfs+0x0/0x2c returned 0 after 5 usecs
[    0.673082] calling  lockdep_proc_init+0x0/0x7c @ 1
[    0.673239] initcall lockdep_proc_init+0x0/0x7c returned 0 after 16 usecs
[    0.673379] calling  futex_init+0x0/0x80 @ 1
[    0.673530] initcall futex_init+0x0/0x80 returned 0 after 11 usecs
[    0.673669] calling  proc_dma_init+0x0/0x22 @ 1
[    0.673814] initcall proc_dma_init+0x0/0x22 returned 0 after 5 usecs
[    0.673954] calling  proc_modules_init+0x0/0x22 @ 1
[    0.674123] initcall proc_modules_init+0x0/0x22 returned 0 after 4 usecs
[    0.674263] calling  kallsyms_init+0x0/0x25 @ 1
[    0.674407] initcall kallsyms_init+0x0/0x25 returned 0 after 4 usecs
[    0.674547] calling  snapshot_device_init+0x0/0x12 @ 1
[    0.674879] initcall snapshot_device_init+0x0/0x12 returned 0 after 185 usecs
[    0.675039] calling  ikconfig_init+0x0/0x3a @ 1
[    0.675190] initcall ikconfig_init+0x0/0x3a returned 0 after 5 usecs
[    0.675329] calling  hung_task_init+0x0/0x53 @ 1
[    0.675561] initcall hung_task_init+0x0/0x53 returned 0 after 89 usecs
[    0.675703] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    0.675845] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 2 usecs
[    0.675986] calling  init_tracepoints+0x0/0x17 @ 1
[    0.676153] initcall init_tracepoints+0x0/0x17 returned 0 after 1 usecs
[    0.676295] calling  ftrace_mod_cmd_init+0x0/0x12 @ 1
[    0.676437] initcall ftrace_mod_cmd_init+0x0/0x12 returned 0 after 1 usecs
[    0.676580] calling  init_events+0x0/0x61 @ 1
[    0.676723] initcall init_events+0x0/0x61 returned 0 after 3 usecs
[    0.676863] calling  init_sched_switch_trace+0x0/0x12 @ 1
[    0.677015] initcall init_sched_switch_trace+0x0/0x12 returned 0 after 1 usecs
[    0.677268] calling  init_function_trace+0x0/0x3e @ 1
[    0.677410] initcall init_function_trace+0x0/0x3e returned 0 after 2 usecs
[    0.677551] calling  init_irqsoff_tracer+0x0/0x2c @ 1
[    0.677693] initcall init_irqsoff_tracer+0x0/0x2c returned 0 after 1 usecs
[    0.677833] calling  init_wakeup_tracer+0x0/0x22 @ 1
[    0.677974] initcall init_wakeup_tracer+0x0/0x22 returned 0 after 1 usecs
[    0.678139] calling  init_graph_trace+0x0/0x65 @ 1
[    0.678281] initcall init_graph_trace+0x0/0x65 returned 0 after 2 usecs
[    0.678421] calling  perf_event_sysfs_init+0x0/0x9b @ 1
[    0.679239] initcall perf_event_sysfs_init+0x0/0x9b returned 0 after 659 usecs
[    0.679480] calling  init_per_zone_wmark_min+0x0/0x67 @ 1
[    0.679974] initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 346 usecs
[    0.680246] calling  kswapd_init+0x0/0x20 @ 1
[    0.680465] initcall kswapd_init+0x0/0x20 returned 0 after 77 usecs
[    0.680606] calling  extfrag_debug_init+0x0/0x72 @ 1
[    0.680764] initcall extfrag_debug_init+0x0/0x72 returned 0 after 17 usecs
[    0.680905] calling  setup_vmstat+0x0/0xc5 @ 1
[    0.681098] initcall setup_vmstat+0x0/0xc5 returned 0 after 24 usecs
[    0.681238] calling  mm_sysfs_init+0x0/0x29 @ 1
[    0.681383] initcall mm_sysfs_init+0x0/0x29 returned 0 after 4 usecs
[    0.681523] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    0.681668] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 4 usecs
[    0.681808] calling  procswaps_init+0x0/0x22 @ 1
[    0.681952] initcall procswaps_init+0x0/0x22 returned 0 after 5 usecs
[    0.682126] calling  hugetlb_init+0x0/0x420 @ 1
[    0.682266] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.682418] initcall hugetlb_init+0x0/0x420 returned 0 after 148 usecs
[    0.682558] calling  slab_proc_init+0x0/0x25 @ 1
[    0.682702] initcall slab_proc_init+0x0/0x25 returned 0 after 5 usecs
[    0.682842] calling  slab_sysfs_init+0x0/0x102 @ 1
[    0.697868] initcall slab_sysfs_init+0x0/0x102 returned 0 after 14533 usecs
[    0.698023] calling  hugepage_init+0x0/0x116 @ 1
[    0.699101] initcall hugepage_init+0x0/0x116 returned 0 after 898 usecs
[    0.699241] calling  fcntl_init+0x0/0x2a @ 1
[    0.699562] initcall fcntl_init+0x0/0x2a returned 0 after 175 usecs
[    0.699702] calling  proc_filesystems_init+0x0/0x22 @ 1
[    0.699850] initcall proc_filesystems_init+0x0/0x22 returned 0 after 7 usecs
[    0.699990] calling  fsnotify_mark_init+0x0/0x3d @ 1
[    0.700582] initcall fsnotify_mark_init+0x0/0x3d returned 0 after 415 usecs
[    0.700723] calling  inotify_user_setup+0x0/0x70 @ 1
[    0.701213] initcall inotify_user_setup+0x0/0x70 returned 0 after 340 usecs
[    0.701353] calling  aio_setup+0x0/0xb0 @ 1
[    0.704467] initcall aio_setup+0x0/0xb0 returned 0 after 371 usecs
[    0.704608] calling  proc_locks_init+0x0/0x22 @ 1
[    0.704753] initcall proc_locks_init+0x0/0x22 returned 0 after 5 usecs
[    0.704894] calling  init_sys32_ioctl+0x0/0x28 @ 1
[    0.705125] initcall init_sys32_ioctl+0x0/0x28 returned 0 after 62 usecs
[    0.705266] calling  init_mbcache+0x0/0x14 @ 1
[    0.705409] initcall init_mbcache+0x0/0x14 returned 0 after 1 usecs
[    0.705549] calling  proc_cmdline_init+0x0/0x22 @ 1
[    0.705695] initcall proc_cmdline_init+0x0/0x22 returned 0 after 5 usecs
[    0.705836] calling  proc_consoles_init+0x0/0x22 @ 1
[    0.705980] initcall proc_consoles_init+0x0/0x22 returned 0 after 5 usecs
[    0.706147] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    0.706291] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 4 usecs
[    0.706431] calling  proc_devices_init+0x0/0x22 @ 1
[    0.706576] initcall proc_devices_init+0x0/0x22 returned 0 after 5 usecs
[    0.706716] calling  proc_interrupts_init+0x0/0x22 @ 1
[    0.706861] initcall proc_interrupts_init+0x0/0x22 returned 0 after 4 usecs
[    0.707010] calling  proc_loadavg_init+0x0/0x22 @ 1
[    0.707168] initcall proc_loadavg_init+0x0/0x22 returned 0 after 5 usecs
[    0.707308] calling  proc_meminfo_init+0x0/0x22 @ 1
[    0.707453] initcall proc_meminfo_init+0x0/0x22 returned 0 after 4 usecs
[    0.707593] calling  proc_stat_init+0x0/0x22 @ 1
[    0.707738] initcall proc_stat_init+0x0/0x22 returned 0 after 4 usecs
[    0.707877] calling  proc_uptime_init+0x0/0x22 @ 1
[    0.708043] initcall proc_uptime_init+0x0/0x22 returned 0 after 6 usecs
[    0.708188] calling  proc_version_init+0x0/0x22 @ 1
[    0.708333] initcall proc_version_init+0x0/0x22 returned 0 after 5 usecs
[    0.708473] calling  proc_softirqs_init+0x0/0x22 @ 1
[    0.708618] initcall proc_softirqs_init+0x0/0x22 returned 0 after 5 usecs
[    0.708758] calling  proc_kcore_init+0x0/0xa9 @ 1
[    0.708908] initcall proc_kcore_init+0x0/0xa9 returned 0 after 10 usecs
[    0.709071] calling  proc_kmsg_init+0x0/0x25 @ 1
[    0.709220] initcall proc_kmsg_init+0x0/0x25 returned 0 after 5 usecs
[    0.709359] calling  proc_page_init+0x0/0x42 @ 1
[    0.709513] initcall proc_page_init+0x0/0x42 returned 0 after 14 usecs
[    0.709653] calling  configfs_init+0x0/0xb3 @ 1
[    0.710000] initcall configfs_init+0x0/0xb3 returned 0 after 200 usecs
[    0.710173] calling  init_devpts_fs+0x0/0x4c @ 1
[    0.710337] initcall init_devpts_fs+0x0/0x4c returned 0 after 23 usecs
[    0.710477] calling  init_ext3_fs+0x0/0x72 @ 1
[    0.710966] initcall init_ext3_fs+0x0/0x72 returned 0 after 338 usecs
[    0.711135] calling  init_ext2_fs+0x0/0x71 @ 1
[    0.711569] initcall init_ext2_fs+0x0/0x71 returned 0 after 286 usecs
[    0.711709] calling  journal_init+0x0/0x99 @ 1
[    0.712433] initcall journal_init+0x0/0x99 returned 0 after 570 usecs
[    0.712574] calling  init_ramfs_fs+0x0/0x12 @ 1
[    0.712715] initcall init_ramfs_fs+0x0/0x12 returned 0 after 1 usecs
[    0.712855] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    0.713229] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 225 usecs
[    0.713369] calling  ipc_init+0x0/0x23 @ 1
[    0.713514] msgmni has been set to 15944
[    0.713663] initcall ipc_init+0x0/0x23 returned 0 after 152 usecs
[    0.713803] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    0.713945] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 3 usecs
[    0.714119] calling  init_mqueue_fs+0x0/0xc8 @ 1
[    0.714460] initcall init_mqueue_fs+0x0/0xc8 returned 0 after 196 usecs
[    0.714600] calling  key_proc_init+0x0/0x33 @ 1
[    0.714746] initcall key_proc_init+0x0/0x33 returned 0 after 5 usecs
[    0.714885] calling  crypto_wq_init+0x0/0x36 @ 1
[    0.715117] initcall crypto_wq_init+0x0/0x36 returned 0 after 70 usecs
[    0.715258] calling  crypto_algapi_init+0x0/0xd @ 1
[    0.715404] initcall crypto_algapi_init+0x0/0xd returned 0 after 5 usecs
[    0.715544] calling  skcipher_module_init+0x0/0x36 @ 1
[    0.715685] initcall skcipher_module_init+0x0/0x36 returned 0 after 0 usecs
[    0.715826] calling  chainiv_module_init+0x0/0x12 @ 1
[    0.715967] initcall chainiv_module_init+0x0/0x12 returned 0 after 1 usecs
[    0.716140] calling  eseqiv_module_init+0x0/0x12 @ 1
[    0.716281] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.716421] calling  hmac_module_init+0x0/0x12 @ 1
[    0.716562] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.716702] calling  md5_mod_init+0x0/0x12 @ 1
[    0.716953] initcall md5_mod_init+0x0/0x12 returned 0 after 106 usecs
[    0.717120] calling  crypto_cbc_module_init+0x0/0x12 @ 1
[    0.717265] initcall crypto_cbc_module_init+0x0/0x12 returned 0 after 1 usecs
[    0.717406] calling  krng_mod_init+0x0/0x12 @ 1
[    0.717649] initcall krng_mod_init+0x0/0x12 returned 0 after 100 usecs
[    0.717790] calling  proc_genhd_init+0x0/0x3c @ 1
[    0.717940] initcall proc_genhd_init+0x0/0x3c returned 0 after 9 usecs
[    0.718108] calling  bsg_init+0x0/0x12e @ 1
[    0.718527] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.718770] initcall bsg_init+0x0/0x12e returned 0 after 510 usecs
[    0.718909] calling  noop_init+0x0/0x14 @ 1
[    0.719078] io scheduler noop registered
[    0.719218] initcall noop_init+0x0/0x14 returned 0 after 136 usecs
[    0.719357] calling  cfq_init+0x0/0x9e @ 1
[    0.719833] io scheduler cfq registered (default)
[    0.719973] initcall cfq_init+0x0/0x9e returned 0 after 464 usecs
[    0.720143] calling  percpu_counter_startup+0x0/0x19 @ 1
[    0.720285] initcall percpu_counter_startup+0x0/0x19 returned 0 after 1 usecs
[    0.720425] calling  pci_proc_init+0x0/0x6a @ 1
[    0.720735] initcall pci_proc_init+0x0/0x6a returned 0 after 166 usecs
[    0.720875] calling  pcie_portdrv_init+0x0/0x7a @ 1
[    0.721211] pcieport 0000:00:02.0: setting latency timer to 64
[    0.721621] initcall pcie_portdrv_init+0x0/0x7a returned 0 after 569 usecs
[    0.721762] calling  ioapic_init+0x0/0x1b @ 1
[    0.722040] initcall ioapic_init+0x0/0x1b returned 0 after 134 usecs
[    0.722180] calling  fb_console_init+0x0/0x11d @ 1
[    0.722456] initcall fb_console_init+0x0/0x11d returned 0 after 130 usecs
[    0.722596] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    0.722742] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 5 usecs
[    0.722883] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    0.723277] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 227 usecs
[    0.723418] calling  acpi_processor_init+0x0/0xcd @ 1
[    0.723557] ACPI: acpi_idle registered with cpuidle
[    0.723748] ACPI: processor limited to max C-state 1
[    0.724780] initcall acpi_processor_init+0x0/0xcd returned 0 after 1192 usecs
[    0.724921] calling  acpi_container_init+0x0/0x4a @ 1
[    0.731073] initcall acpi_container_init+0x0/0x4a returned 0 after 5841 usecs
[    0.731214] calling  acpi_thermal_init+0x0/0x42 @ 1
[    0.731541] initcall acpi_thermal_init+0x0/0x42 returned 0 after 180 usecs
[    0.731681] calling  pty_init+0x0/0x336 @ 1
[    0.731993] initcall pty_init+0x0/0x336 returned 0 after 168 usecs
[    0.732162] calling  sysrq_init+0x0/0x78 @ 1
[    0.732309] initcall sysrq_init+0x0/0x78 returned 0 after 8 usecs
[    0.732450] calling  rand_initialize+0x0/0x31 @ 1
[    0.732603] initcall rand_initialize+0x0/0x31 returned 0 after 12 usecs
[    0.732742] calling  hpet_init+0x0/0x6a @ 1
[    0.733301] initcall hpet_init+0x0/0x6a returned 0 after 406 usecs
[    0.733441] calling  agp_init+0x0/0x26 @ 1
[    0.733579] Linux agpgart interface v0.103
[    0.733718] initcall agp_init+0x0/0x26 returned 0 after 135 usecs
[    0.733858] calling  agp_amd64_mod_init+0x0/0x22 @ 1
[    0.734011] initcall agp_amd64_mod_init+0x0/0x22 returned -19 after 0 usecs
[    0.734170] calling  drm_core_init+0x0/0x132 @ 1
[    0.734456] [drm] Initialized drm 1.1.0 20060810
[    0.734596] initcall drm_core_init+0x0/0x132 returned 0 after 278 usecs
[    0.734735] calling  ttm_init+0x0/0x62 @ 1
[    0.735074] initcall ttm_init+0x0/0x62 returned 0 after 192 usecs
[    0.735213] calling  radeon_init+0x0/0xc1 @ 1
[    0.735352] [drm] radeon defaulting to userspace modesetting.
[    0.737476] pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.737618] pci 0000:01:00.0: setting latency timer to 64
[    0.738116] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.738256] [drm] No driver support for vblank timestamp query.
[    0.738395] [drm] Initialized radeon 1.33.0 20080528 for 0000:01:00.0 on minor 0
[    0.738776] initcall radeon_init+0x0/0xc1 returned 0 after 3344 usecs
[    0.738917] calling  topology_sysfs_init+0x0/0x55 @ 1
[    0.739131] initcall topology_sysfs_init+0x0/0x55 returned 0 after 40 usecs
[    0.739272] calling  loop_init+0x0/0x1a3 @ 1
[    0.742187] loop: module loaded
[    0.742326] initcall loop_init+0x0/0x1a3 returned 0 after 2846 usecs
[    0.742466] calling  init_cryptoloop+0x0/0x2f @ 1
[    0.742607] initcall init_cryptoloop+0x0/0x2f returned 0 after 0 usecs
[    0.742747] calling  ide_init+0x0/0x7c @ 1
[    0.742885] Uniform Multi-Platform E-IDE driver
[    0.743287] initcall ide_init+0x0/0x7c returned 0 after 389 usecs
[    0.743427] calling  atiixp_ide_init+0x0/0x1b @ 1
[    0.743567] initcall atiixp_ide_init+0x0/0x1b returned 0 after 0 usecs
[    0.743707] calling  ide_scan_pcibus+0x0/0xd3 @ 1
[    0.743873] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    0.744049] pci 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.744235] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    0.744378]     ide0: BM-DMA at 0xff00-0xff07
[    0.744525]     ide1: BM-DMA at 0xff08-0xff0f
[    0.744665] Probing IDE interface ide0...
[    1.012369] hda: MAXTOR 4K080H4, ATA DISK drive
[    1.480041] hdb: Optiarc DVD RW AD-7173A, ATAPI CD/DVD-ROM drive
[    1.480527] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.480913] hda: UDMA/100 mode selected
[    1.481368] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.481661] hdb: UDMA/66 mode selected
[    1.481958] Probing IDE interface ide1...
[    1.664833] Refined TSC clocksource calibration: 3007.805 MHz.
[    1.664978] Switching to clocksource tsc
[    2.005194] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.034292] ide1 at 0x170-0x177,0x376 on irq 15
[    2.035210] initcall ide_scan_pcibus+0x0/0xd3 returned 0 after 1261091 usecs
[    2.035352] calling  ide_gd_init+0x0/0x20 @ 1
[    2.035490] ide-gd driver 1.18
[    2.035667] hda: max request size: 128KiB
[    2.036302] hda: 156301488 sectors (80026 MB) w/2000KiB Cache, CHS=65535/16/63
[    2.037166] hda: cache flushes supported
[    2.067400]  hda: hda1 hda2
[    2.069335] initcall ide_gd_init+0x0/0x20 returned 0 after 33047 usecs
[    2.069480] calling  ide_cdrom_init+0x0/0x20 @ 1
[    2.069618] ide-cd driver 5.00
[    2.070397] ide-cd: hdb: ATAPI 48X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
[    2.073400] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.080303] initcall ide_cdrom_init+0x0/0x20 returned 0 after 10429 usecs
[    2.080446] calling  idetape_init+0x0/0xb5 @ 1
[    2.080779] initcall idetape_init+0x0/0xb5 returned 0 after 188 usecs
[    2.080919] calling  init_sd+0x0/0x142 @ 1
[    2.081419] initcall init_sd+0x0/0x142 returned 0 after 343 usecs
[    2.081559] calling  ahci_init+0x0/0x1b @ 1
[    2.081712] ahci 0000:00:11.0: version 3.0
[    2.081868] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.082126] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.082368] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    2.084659] scsi0 : ahci
[    2.085385] scsi1 : ahci
[    2.085825] scsi2 : ahci
[    2.086263] scsi3 : ahci
[    2.086662] ata1: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ff900 irq 22
[    2.086905] ata2: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ff980 irq 22
[    2.087153] ata3: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ffa00 irq 22
[    2.087401] ata4: SATA max UDMA/133 abar m1024@0xfe9ff800 port 0xfe9ffa80 irq 22
[    2.087673] calling  1_async_port_probe+0x0/0xb0 @ 5
[    2.087763] calling  2_async_port_probe+0x0/0xb0 @ 18
[    2.087828] calling  3_async_port_probe+0x0/0xb0 @ 662
[    2.087875] calling  4_async_port_probe+0x0/0xb0 @ 663
[    2.088027] initcall ahci_init+0x0/0x1b returned 0 after 6179 usecs
[    2.088029] calling  net_olddevs_init+0x0/0x9e @ 1
[    2.088034] initcall net_olddevs_init+0x0/0x9e returned 0 after 2 usecs
[    2.088036] calling  rtl8139_init_module+0x0/0x1b @ 1
[    2.088055] 8139too: 8139too Fast Ethernet driver 0.9.28
[    2.088084] 8139too 0000:02:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.089088] 8139too 0000:02:06.0: eth0: RealTek RTL8139 at 0xffffc9000002ac00, 00:0b:2b:01:34:65, IRQ 21
[    2.089190] initcall rtl8139_init_module+0x0/0x1b returned 0 after 1123 usecs
[    2.089192] calling  init_netconsole+0x0/0x234 @ 1
[    2.089940] console [netcon0] enabled
[    2.090098] netconsole: network logging started
[    2.090242] initcall init_netconsole+0x0/0x234 returned 0 after 1022 usecs
[    2.090382] calling  cdrom_init+0x0/0x6a @ 1
[    2.090520] initcall cdrom_init+0x0/0x6a returned 0 after 0 usecs
[    2.090660] calling  ehci_hcd_init+0x0/0x78 @ 1
[    2.090798] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.090965] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.091135] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.091317] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    2.096309] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.096589] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    2.096842] ehci_hcd 0000:00:12.2: debug port 1
[    2.097049] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe9ff000
[    2.103300] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.103537] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.103677] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.103918] usb usb1: Product: EHCI Host Controller
[    2.104064] usb usb1: Manufacturer: Linux 2.6.38-rc4-00001-g1e554e3-dirty ehci_hcd
[    2.104304] usb usb1: SerialNumber: 0000:00:12.2
[    2.104840] hub 1-0:1.0: USB hub found
[    2.104989] hub 1-0:1.0: 6 ports detected
[    2.105324] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.105488] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.105640] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    2.114309] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    2.114587] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    2.114841] ehci_hcd 0000:00:13.2: debug port 1
[    2.115044] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe9fa800
[    2.121299] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.121522] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.121662] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.121903] usb usb2: Product: EHCI Host Controller
[    2.122050] usb usb2: Manufacturer: Linux 2.6.38-rc4-00001-g1e554e3-dirty ehci_hcd
[    2.122291] usb usb2: SerialNumber: 0000:00:13.2
[    2.122838] hub 2-0:1.0: USB hub found
[    2.122984] hub 2-0:1.0: 6 ports detected
[    2.123437] initcall ehci_hcd_init+0x0/0x78 returned 0 after 31870 usecs
[    2.123578] calling  usb_stor_init+0x0/0x46 @ 1
[    2.123716] Initializing USB Mass Storage driver...
[    2.124035] usbcore: registered new interface driver usb-storage
[    2.124174] USB Mass Storage support registered.
[    2.124313] initcall usb_stor_init+0x0/0x46 returned 0 after 582 usecs
[    2.124453] calling  i8042_init+0x0/0x39f @ 1
[    2.132590] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.132734] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.133262] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.133600] initcall i8042_init+0x0/0x39f returned 0 after 8793 usecs
[    2.133741] calling  mousedev_init+0x0/0x8e @ 1
[    2.134149] mousedev: PS/2 mouse device common for all mice
[    2.134290] initcall mousedev_init+0x0/0x8e returned 0 after 399 usecs
[    2.134430] calling  evdev_init+0x0/0x12 @ 1
[    2.134569] initcall evdev_init+0x0/0x12 returned 0 after 0 usecs
[    2.134709] calling  atkbd_init+0x0/0x27 @ 1
[    2.135043] initcall atkbd_init+0x0/0x27 returned 0 after 189 usecs
[    2.135183] calling  cmos_init+0x0/0x6a @ 1
[    2.135346] rtc_cmos 00:03: RTC can wake from S4
[    2.144563] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    2.144735] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    2.144981] initcall cmos_init+0x0/0x6a returned 0 after 9429 usecs
[    2.145147] calling  init_ladder+0x0/0x12 @ 1
[    2.145286] cpuidle: using governor ladder
[    2.145425] initcall init_ladder+0x0/0x12 returned 0 after 135 usecs
[    2.145564] calling  init_menu+0x0/0x12 @ 1
[    2.145702] cpuidle: using governor menu
[    2.145840] initcall init_menu+0x0/0x12 returned 0 after 134 usecs
[    2.145980] calling  hid_init+0x0/0x4d @ 1
[    2.146280] initcall hid_init+0x0/0x4d returned 0 after 151 usecs
[    2.146419] calling  a4_init+0x0/0x1b @ 1
[    2.146656] initcall a4_init+0x0/0x1b returned 0 after 95 usecs
[    2.146795] calling  apple_init+0x0/0x39 @ 1
[    2.147155] initcall apple_init+0x0/0x39 returned 0 after 216 usecs
[    2.147295] calling  belkin_init+0x0/0x1b @ 1
[    2.147530] initcall belkin_init+0x0/0x1b returned 0 after 93 usecs
[    2.147682] calling  ch_init+0x0/0x1b @ 1
[    2.147914] initcall ch_init+0x0/0x1b returned 0 after 91 usecs
[    2.148062] calling  ch_init+0x0/0x1b @ 1
[    2.148300] initcall ch_init+0x0/0x1b returned 0 after 95 usecs
[    2.148439] calling  cp_init+0x0/0x1b @ 1
[    2.148675] initcall cp_init+0x0/0x1b returned 0 after 95 usecs
[    2.148815] calling  ez_init+0x0/0x1b @ 1
[    2.149055] initcall ez_init+0x0/0x1b returned 0 after 99 usecs
[    2.149195] calling  ks_init+0x0/0x1b @ 1
[    2.149426] initcall ks_init+0x0/0x1b returned 0 after 90 usecs
[    2.149565] calling  kye_init+0x0/0x1b @ 1
[    2.149799] initcall kye_init+0x0/0x1b returned 0 after 92 usecs
[    2.149938] calling  lg_init+0x0/0x1b @ 1
[    2.150180] initcall lg_init+0x0/0x1b returned 0 after 93 usecs
[    2.150320] calling  ms_init+0x0/0x1b @ 1
[    2.150550] initcall ms_init+0x0/0x1b returned 0 after 89 usecs
[    2.150702] calling  mr_init+0x0/0x1b @ 1
[    2.150938] initcall mr_init+0x0/0x1b returned 0 after 95 usecs
[    2.151086] calling  hid_init+0x0/0x78 @ 1
[    2.151443] usbcore: registered new interface driver usbhid
[    2.151581] usbhid: USB HID core driver
[    2.151720] initcall hid_init+0x0/0x78 returned 0 after 482 usecs
[    2.151859] calling  alsa_timer_init+0x0/0x17c @ 1
[    2.152177] initcall alsa_timer_init+0x0/0x17c returned 0 after 174 usecs
[    2.152318] calling  alsa_pcm_init+0x0/0x6c @ 1
[    2.152463] initcall alsa_pcm_init+0x0/0x6c returned 0 after 6 usecs
[    2.152604] calling  snd_mem_init+0x0/0x2c @ 1
[    2.152746] initcall snd_mem_init+0x0/0x2c returned 0 after 4 usecs
[    2.152886] calling  patch_realtek_init+0x0/0x12 @ 1
[    2.153032] initcall patch_realtek_init+0x0/0x12 returned 0 after 0 usecs
[    2.153173] calling  patch_cmedia_init+0x0/0x12 @ 1
[    2.153428] initcall patch_cmedia_init+0x0/0x12 returned 0 after 0 usecs
[    2.153578] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.153881] calling  patch_analog_init+0x0/0x12 @ 1
[    2.154042] initcall patch_analog_init+0x0/0x12 returned 0 after 0 usecs
[    2.154183] calling  patch_sigmatel_init+0x0/0x12 @ 1
[    2.154323] initcall patch_sigmatel_init+0x0/0x12 returned 0 after 0 usecs
[    2.154463] calling  patch_si3054_init+0x0/0x12 @ 1
[    2.154603] initcall patch_si3054_init+0x0/0x12 returned 0 after 0 usecs
[    2.154742] calling  patch_cirrus_init+0x0/0x12 @ 1
[    2.154881] initcall patch_cirrus_init+0x0/0x12 returned 0 after 0 usecs
[    2.155028] calling  patch_ca0110_init+0x0/0x12 @ 1
[    2.155167] initcall patch_ca0110_init+0x0/0x12 returned 0 after 0 usecs
[    2.155308] calling  patch_conexant_init+0x0/0x12 @ 1
[    2.155447] initcall patch_conexant_init+0x0/0x12 returned 0 after 0 usecs
[    2.155587] calling  patch_via_init+0x0/0x12 @ 1
[    2.155726] initcall patch_via_init+0x0/0x12 returned 0 after 0 usecs
[    2.155866] calling  patch_hdmi_init+0x0/0x12 @ 1
[    2.156009] initcall patch_hdmi_init+0x0/0x12 returned 0 after 0 usecs
[    2.156152] calling  alsa_card_azx_init+0x0/0x1b @ 1
[    2.156331] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.169144] HDA Intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.171967] HDA Intel 0000:01:00.1: setting latency timer to 64
[    2.177990] initcall alsa_card_azx_init+0x0/0x1b returned 0 after 21185 usecs
[    2.178142] calling  alsa_sound_last_init+0x0/0x6f @ 1
[    2.178281] ALSA device list:
[    2.178418]   #0: HDA ATI SB at 0xfe9f4000 irq 16
[    2.178556]   #1: HDA ATI HDMI at 0xfeaec000 irq 19
[    2.178696] initcall alsa_sound_last_init+0x0/0x6f returned 0 after 405 usecs
[    2.178838] calling  flow_cache_init_global+0x0/0x12b @ 1
[    2.179260] initcall flow_cache_init_global+0x0/0x12b returned 0 after 274 usecs
[    2.179502] calling  blackhole_module_init+0x0/0x12 @ 1
[    2.179643] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
[    2.179784] calling  sysctl_ipv4_init+0x0/0x8b @ 1
[    2.179934] initcall sysctl_ipv4_init+0x0/0x8b returned 0 after 10 usecs
[    2.180082] calling  init_syncookies+0x0/0x19 @ 1
[    2.180241] initcall init_syncookies+0x0/0x19 returned 0 after 19 usecs
[    2.180381] calling  xfrm4_beet_init+0x0/0x17 @ 1
[    2.180521] initcall xfrm4_beet_init+0x0/0x17 returned 0 after 1 usecs
[    2.180663] calling  ipv4_netfilter_init+0x0/0x17 @ 1
[    2.180803] initcall ipv4_netfilter_init+0x0/0x17 returned 0 after 1 usecs
[    2.180944] calling  cubictcp_register+0x0/0x5c @ 1
[    2.181090] TCP cubic registered
[    2.181228] initcall cubictcp_register+0x0/0x5c returned 0 after 135 usecs
[    2.181369] calling  init_dns_resolver+0x0/0x108 @ 1
[    2.181508] Registering the dns_resolver key type
[    2.181658] initcall init_dns_resolver+0x0/0x108 returned 0 after 146 usecs
[    2.181800] calling  mcheck_debugfs_init+0x0/0x3c @ 1
[    2.181952] initcall mcheck_debugfs_init+0x0/0x3c returned 0 after 12 usecs
[    2.182099] calling  severities_debugfs_init+0x0/0x3c @ 1
[    2.182243] initcall severities_debugfs_init+0x0/0x3c returned 0 after 4 usecs
[    2.182485] calling  hpet_insert_resource+0x0/0x23 @ 1
[    2.182626] initcall hpet_insert_resource+0x0/0x23 returned 0 after 1 usecs
[    2.182767] calling  lapic_insert_resource+0x0/0x3f @ 1
[    2.182907] initcall lapic_insert_resource+0x0/0x3f returned 0 after 0 usecs
[    2.183056] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    2.183196] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    2.183336] calling  check_early_ioremap_leak+0x0/0x65 @ 1
[    2.183476] initcall check_early_ioremap_leak+0x0/0x65 returned 0 after 0 usecs
[    2.183718] calling  pat_memtype_list_init+0x0/0x32 @ 1
[    2.183862] initcall pat_memtype_list_init+0x0/0x32 returned 0 after 4 usecs
[    2.184006] calling  sched_init_debug+0x0/0x24 @ 1
[    2.184153] initcall sched_init_debug+0x0/0x24 returned 0 after 4 usecs
[    2.184294] calling  init_oops_id+0x0/0x36 @ 1
[    2.184433] initcall init_oops_id+0x0/0x36 returned 0 after 0 usecs
[    2.184573] calling  printk_late_init+0x0/0x50 @ 1
[    2.184713] initcall printk_late_init+0x0/0x50 returned 0 after 0 usecs
[    2.184854] calling  pm_qos_power_init+0x0/0xca @ 1
[    2.185400] initcall pm_qos_power_init+0x0/0xca returned 0 after 395 usecs
[    2.185542] calling  software_resume+0x0/0x196 @ 1
[    2.186522] initcall software_resume+0x0/0x196 returned -22 after 814 usecs
[    2.186667] initcall software_resume+0x0/0x196 returned with error code -22 
[    2.186810] calling  clear_boot_tracer+0x0/0x2d @ 1
[    2.186949] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    2.187103] calling  max_swapfiles_check+0x0/0x8 @ 1
[    2.187242] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    2.187383] calling  set_recommended_min_free_kbytes+0x0/0x87 @ 1
[    2.187868] initcall set_recommended_min_free_kbytes+0x0/0x87 returned 0 after 337 usecs
[    2.188119] calling  random32_reseed+0x0/0xb3 @ 1
[    2.188272] initcall random32_reseed+0x0/0xb3 returned 0 after 14 usecs
[    2.188413] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    2.188559] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 5 usecs
[    2.188801] calling  pci_sysfs_init+0x0/0x51 @ 1
[    2.189248] initcall pci_sysfs_init+0x0/0x51 returned 0 after 299 usecs
[    2.189390] calling  seqgen_init+0x0/0xf @ 1
[    2.189537] initcall seqgen_init+0x0/0xf returned 0 after 8 usecs
[    2.189678] calling  scsi_complete_async_scans+0x0/0x10d @ 1
[    2.189818] initcall scsi_complete_async_scans+0x0/0x10d returned 0 after 0 usecs
[    2.190066] calling  rtc_hctosys+0x0/0x10d @ 1
[    2.190250] rtc_cmos 00:03: setting system clock to 2011-02-08 09:55:56 UTC (1297158956)
[    2.190493] initcall rtc_hctosys+0x0/0x10d returned 0 after 281 usecs
[    2.190633] calling  memmap_init+0x0/0x3b @ 1
[    2.190831] initcall memmap_init+0x0/0x3b returned 0 after 56 usecs
[    2.190971] calling  pci_mmcfg_late_insert_resources+0x0/0x66 @ 1
[    2.191120] initcall pci_mmcfg_late_insert_resources+0x0/0x66 returned 0 after 1 usecs
[    2.191362] calling  tcp_congestion_default+0x0/0x12 @ 1
[    2.191502] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[    2.191643] calling  initialize_hashrnd+0x0/0x19 @ 1
[    2.191785] initcall initialize_hashrnd+0x0/0x19 returned 0 after 2 usecs
[    2.192026] async_waiting @ 1
[    2.392356] ata3: SATA link down (SStatus 0 SControl 300)
[    2.392536] async_waiting @ 662
[    2.394325] ata1: SATA link down (SStatus 0 SControl 300)
[    2.394805] async_waiting @ 5
[    2.394946] async_continuing @ 5 after 0 usec
[    2.395105] initcall 1_async_port_probe+0x0/0xb0 returned 0 after 298025 usecs
[    2.458403] usb 1-3: new high speed USB device using ehci_hcd and address 3
[    2.547428] ata4: softreset failed (device not ready)
[    2.547573] ata4: applying SB600 PMP SRST workaround and retrying
[    2.547730] ata2: softreset failed (device not ready)
[    2.547870] ata2: applying SB600 PMP SRST workaround and retrying
[    2.573444] usb 1-3: New USB device found, idVendor=0424, idProduct=2504
[    2.573589] usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.575614] hub 1-3:1.0: USB hub found
[    2.576191] hub 1-3:1.0: 2 ports detected
[    2.702272] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.703274] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.704448] ata2.00: ATA-8: WDC WD2500AAJS-62B4A0, 01.03A01, max UDMA/133
[    2.704589] ata2.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.706225] ata2.00: configured for UDMA/133
[    2.706396] async_waiting @ 18
[    2.706538] async_continuing @ 18 after 0 usec
[    2.706963] scsi 1:0:0:0: Direct-Access     ATA      WDC WD2500AAJS-6 01.0 PQ: 0 ANSI: 5
[    2.707761] calling  5_sd_probe_async+0x0/0x1c4 @ 5
[    2.707980] sd 1:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.708143] initcall 2_async_port_probe+0x0/0xb0 returned 0 after 605833 usecs
[    2.708155] async_continuing @ 662 after 308082 usec
[    2.708161] initcall 3_async_port_probe+0x0/0xb0 returned 0 after 605788 usecs
[    2.708799] ata4.00: ATA-7: SAMSUNG HD103UJ, 1AA01113, max UDMA7
[    2.708802] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.709352] sd 1:0:0:0: [sda] Write Protect is off
[    2.709492] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.709668] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.715437] ata4.00: configured for UDMA/133
[    2.715595] async_waiting @ 663
[    2.715737] async_continuing @ 663 after 0 usec
[    2.716089] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
[    2.716905] calling  6_sd_probe_async+0x0/0x1c4 @ 662
[    2.717154] sd 3:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.717246] initcall 4_async_port_probe+0x0/0xb0 returned 0 after 614614 usecs
[    2.717259] async_continuing @ 1 after 512784 usec
[    2.717261] async_waiting @ 1
[    2.718089] sd 3:0:0:0: [sdb] Write Protect is off
[    2.718232] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.718424] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.728715]  sdb: sdb1
[    2.729566] sd 3:0:0:0: [sdb] Attached SCSI disk
[    2.729713] initcall 6_sd_probe_async+0x0/0x1c4 returned 0 after 12359 usecs
[    2.755321]  sda: sda1 sda2
[    2.756437] sd 1:0:0:0: [sda] Attached SCSI disk
[    2.756583] initcall 5_sd_probe_async+0x0/0x1c4 returned 0 after 47534 usecs
[    2.756749] async_continuing @ 1 after 38558 usec
[    2.795375] EXT3-fs: barriers not enabled
[    2.812855] kjournald starting.  Commit interval 5 seconds
[    2.812942] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    2.812976] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    2.813024] async_waiting @ 1
[    2.813026] async_continuing @ 1 after 0 usec
[    2.816055] Freeing unused kernel memory: 2344k freed
[    2.852465] usb 1-3.1: new high speed USB device using ehci_hcd and address 4
[    2.941713] usb 1-3.1: New USB device found, idVendor=05ac, idProduct=1263
[    2.941858] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.942107] usb 1-3.1: Product: iPod
[    2.942245] usb 1-3.1: Manufacturer: Apple Inc.
[    2.942383] usb 1-3.1: SerialNumber: 000A27001D8212A9
[    2.951100] scsi4 : usb-storage 1-3.1:1.0
[    3.953821] scsi 4:0:0:0: Direct-Access     Apple    iPod             1.62 PQ: 0 ANSI: 0
[    3.958924] sd 4:0:0:0: [sdc] Spinning up disk...
[    4.713033] calling  ohci_hcd_mod_init+0x0/0x59 [ohci_hcd] @ 869
[    4.713312] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.713482] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.713664] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    4.713824] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    4.718094] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe9fe000
[    4.773379] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.776063] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.776305] usb usb3: Product: OHCI Host Controller
[    4.776444] usb usb3: Manufacturer: Linux 2.6.38-rc4-00001-g1e554e3-dirty ohci_hcd
[    4.776685] usb usb3: SerialNumber: 0000:00:12.0
[    4.777038] hub 3-0:1.0: USB hub found
[    4.777190] hub 3-0:1.0: 3 ports detected
[    4.777513] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.777707] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    4.777865] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    4.786368] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe9fd000
[    4.842406] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.842551] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.842797] usb usb4: Product: OHCI Host Controller
[    4.842937] usb usb4: Manufacturer: Linux 2.6.38-rc4-00001-g1e554e3-dirty ohci_hcd
[    4.843184] usb usb4: SerialNumber: 0000:00:12.1
[    4.843537] hub 4-0:1.0: USB hub found
[    4.843688] hub 4-0:1.0: 3 ports detected
[    4.844067] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.844237] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    4.844399] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    4.851331] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe9fc000
[    4.906382] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.906527] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.906768] usb usb5: Product: OHCI Host Controller
[    4.906907] usb usb5: Manufacturer: Linux 2.6.38-rc4-00001-g1e554e3-dirty ohci_hcd
[    4.907152] usb usb5: SerialNumber: 0000:00:13.0
[    4.907502] hub 5-0:1.0: USB hub found
[    4.907653] hub 5-0:1.0: 3 ports detected
[    4.907976] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.908152] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    4.908307] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    4.913325] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe9fb000
[    4.968373] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.968578] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.968822] usb usb6: Product: OHCI Host Controller
[    4.968961] usb usb6: Manufacturer: Linux 2.6.38-rc4-00001-g1e554e3-dirty ohci_hcd
[    4.969209] usb usb6: SerialNumber: 0000:00:13.1
[    4.969582] hub 6-0:1.0: USB hub found
[    4.969732] hub 6-0:1.0: 3 ports detected
[    4.970094] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.970263] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    4.970423] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    4.977333] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe9f9000
[    5.032372] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.032517] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.032758] usb usb7: Product: OHCI Host Controller
[    5.032897] usb usb7: Manufacturer: Linux 2.6.38-rc4-00001-g1e554e3-dirty ohci_hcd
[    5.033142] usb usb7: SerialNumber: 0000:00:14.5
[    5.033484] hub 7-0:1.0: USB hub found
[    5.033640] hub 7-0:1.0: 2 ports detected
[    5.033992] initcall ohci_hcd_mod_init+0x0/0x59 [ohci_hcd] returned 0 after 313161 usecs
[    5.090323] usb 3-1: new low speed USB device using ohci_hcd and address 2
[    5.120737] calling  k10temp_init+0x0/0x20 [k10temp] @ 881
[    5.120911] k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring disabled
[    5.121217] initcall k10temp_init+0x0/0x20 [k10temp] returned 0 after 324 usecs
[    5.208308] .ready
[    5.210308] sd 4:0:0:0: [sdc] 3944897 4096-byte logical blocks: (16.1 GB/15.0 GiB)
[    5.212322] sd 4:0:0:0: [sdc] Write Protect is off
[    5.212465] sd 4:0:0:0: [sdc] Mode Sense: 68 00 00 08
[    5.214299] sd 4:0:0:0: [sdc] No Caching mode page present
[    5.214439] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[    5.216568] sd 4:0:0:0: [sdc] 3944897 4096-byte logical blocks: (16.1 GB/15.0 GiB)
[    5.220643] sd 4:0:0:0: [sdc] No Caching mode page present
[    5.220787] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[    5.222420]  sdc: sdc1
[    5.224768] sd 4:0:0:0: [sdc] 3944897 4096-byte logical blocks: (16.1 GB/15.0 GiB)
[    5.226520] sd 4:0:0:0: [sdc] No Caching mode page present
[    5.226662] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[    5.226805] sd 4:0:0:0: [sdc] Attached SCSI removable disk
[    5.229168] usb 3-1: New USB device found, idVendor=046d, idProduct=c018
[    5.229313] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.229456] usb 3-1: Product: USB Optical Mouse
[    5.229596] usb 3-1: Manufacturer: Logitech
[    5.236538] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input1
[    5.236943] generic-usb 0003:046D:C018.0001: input: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:12.0-1/input0
[    5.523367] calling  serial8250_init+0x0/0x183 [8250] @ 857
[    5.523512] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.544301] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.558081] calling  edac_init+0x0/0x6f [edac_core] @ 879
[    5.558224] EDAC MC: Ver: 2.1.0 Feb  8 2011
[    5.558586] initcall edac_init+0x0/0x6f [edac_core] returned 0 after 344 usecs
[    5.573736] calling  amd64_edac_init+0x0/0x1af [amd64_edac_mod] @ 879
[    5.573880] EDAC amd64_edac: v3.3.0
[    5.574062] EDAC amd64: DRAM ECC disabled.
[    5.574205] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    5.574206]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    5.574207]  (Note that use of the override may cause unknown side effects.)
[    5.574915] initcall amd64_edac_init+0x0/0x1af [amd64_edac_mod] returned -19 after 1008 usecs
[    5.608370] initcall serial8250_init+0x0/0x183 [8250] returned 0 after 82863 usecs
[    5.609126] calling  serial8250_pnp_init+0x0/0x12 [8250_pnp] @ 903
[    5.629995] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.637092] initcall serial8250_pnp_init+0x0/0x12 [8250_pnp] returned 0 after 27165 usecs
[    7.613950] Adding 16016800k swap on /dev/sda2.  Priority:-1 extents:1 across:16016800k 
[    7.618429] Adding 15647304k swap on /dev/hda2.  Priority:-2 extents:1 across:15647304k 
[    7.796997] EXT3-fs (sda1): using internal journal
[    8.188938] EXT3-fs: barriers not enabled
[    8.198080] kjournald starting.  Commit interval 5 seconds
[    8.198314] EXT3-fs (sdb1): warning: mounting fs with errors, running e2fsck is recommended
[    8.199167] EXT3-fs (sdb1): using internal journal
[    8.199310] EXT3-fs (sdb1): mounted filesystem with writeback data mode
[    8.255765] calling  init_fat_fs+0x0/0x4f [fat] @ 1250
[    8.256136] initcall init_fat_fs+0x0/0x4f [fat] returned 0 after 215 usecs
[    8.285917] calling  init_vfat_fs+0x0/0x12 [vfat] @ 1250
[    8.286073] initcall init_vfat_fs+0x0/0x12 [vfat] returned 0 after 4 usecs
[    9.201795] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[    9.921802] calling  inet6_init+0x0/0x2a6 [ipv6] @ 1357
[    9.922861] NET: Registered protocol family 10
[    9.923789] initcall inet6_init+0x0/0x2a6 [ipv6] returned 0 after 1787 usecs
[   10.427592] calling  fuse_init+0x0/0x141 [fuse] @ 1449
[   10.427739] fuse init (API version 7.16)
[   10.428261] initcall fuse_init+0x0/0x141 [fuse] returned 0 after 504 usecs
[   10.982988] calling  irqfd_module_init+0x0/0x36 [kvm] @ 1514
[   10.983221] initcall irqfd_module_init+0x0/0x36 [kvm] returned 0 after 65 usecs
[   11.034499] calling  init_misc_binfmt+0x0/0x45 [binfmt_misc] @ 1532
[   11.034653] initcall init_misc_binfmt+0x0/0x45 [binfmt_misc] returned 0 after 5 usecs
[   11.106068] calling  svm_init+0x0/0x23 [kvm_amd] @ 1514
[   11.106663] kvm: Nested Virtualization enabled
[   11.106806] kvm: Nested Paging enabled
[   11.107528] initcall svm_init+0x0/0x23 [kvm_amd] returned 0 after 1281 usecs
[   15.261422] calling  xt_init+0x0/0x16c [x_tables] @ 1785
[   15.261450] initcall xt_init+0x0/0x16c [x_tables] returned 0 after 21 usecs
[   15.295872] calling  ip_tables_init+0x0/0xaa [ip_tables] @ 1785
[   15.295899] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.295904] initcall ip_tables_init+0x0/0xaa [ip_tables] returned 0 after 26 usecs
[   15.297098] calling  cpufreq_stats_init+0x0/0xad [cpufreq_stats] @ 1794
[   15.297108] initcall cpufreq_stats_init+0x0/0xad [cpufreq_stats] returned 0 after 5 usecs
[   15.331572] calling  iptable_filter_init+0x0/0x6f [iptable_filter] @ 1796
[   15.331607] initcall iptable_filter_init+0x0/0x6f [iptable_filter] returned 0 after 29 usecs
[   15.339346] calling  cpufreq_gov_dbs_init+0x0/0x6b [cpufreq_conservative] @ 1799
[   15.339460] initcall cpufreq_gov_dbs_init+0x0/0x6b [cpufreq_conservative] returned 0 after 100 usecs
[   15.375812] calling  ip6_tables_init+0x0/0xaa [ip6_tables] @ 1809
[   15.375841] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   15.375845] initcall ip6_tables_init+0x0/0xaa [ip6_tables] returned 0 after 27 usecs
[   15.386937] calling  cpufreq_gov_userspace_init+0x0/0x12 [cpufreq_userspace] @ 1808
[   15.386944] initcall cpufreq_gov_userspace_init+0x0/0x12 [cpufreq_userspace] returned 0 after 1 usecs
[   15.395814] calling  ip6table_filter_init+0x0/0x6f [ip6table_filter] @ 1811
[   15.395848] initcall ip6table_filter_init+0x0/0x6f [ip6table_filter] returned 0 after 29 usecs
[   15.702456] calling  cpufreq_gov_powersave_init+0x0/0x12 [cpufreq_powersave] @ 1814
[   15.702462] initcall cpufreq_gov_powersave_init+0x0/0x12 [cpufreq_powersave] returned 0 after 1 usecs
[   15.811599] calling  cpufreq_gov_dbs_init+0x0/0xe8 [cpufreq_ondemand] @ 1818
[   15.811734] initcall cpufreq_gov_dbs_init+0x0/0xe8 [cpufreq_ondemand] returned 0 after 121 usecs
[   15.885083] calling  powernowk8_init+0x0/0x18a [powernow_k8] @ 1839
[   15.885123] powernow-k8: Found 1 AMD Phenom(tm) II X4 940 Processor (4 cpu cores) (version 2.20.00)
[   15.885278] powernow-k8:    0 : pstate 0 (3000 MHz)
[   15.885280] powernow-k8:    1 : pstate 1 (2300 MHz)
[   15.885282] powernow-k8:    2 : pstate 2 (1800 MHz)
[   15.885284] powernow-k8:    3 : pstate 3 (800 MHz)
[   15.887557] initcall powernowk8_init+0x0/0x18a [powernow_k8] returned 0 after 2409 usecs
[   20.156269] sshd (1961): /proc/1961/oom_adj is deprecated, please use /proc/1961/oom_score_adj instead.
[   20.597589] eth0: no IPv6 routers present
[   25.814180] [drm] Setting GART location based on new memory map
[   25.814479] [drm] Loading RV635 CP Microcode
[   25.844578] [drm] Resetting GPU
[   25.844636] [drm] writeback test succeeded in 1 usecs
[   25.849949] HDMI hot plug event: Pin=3 Presence_Detect=0 ELD_Valid=0
[ 3281.785334] calling  msr_init+0x0/0x14f [msr] @ 8067
[ 3281.786624] initcall msr_init+0x0/0x14f [msr] returned 0 after 1241 usecs

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.38-rc3 Kernel Configuration
# Sun Feb  6 11:53:45 2011
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
CONFIG_X86_TRAMPOLINE=y
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
CONFIG_LOCK_KERNEL=y
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
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
# CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
# CONFIG_AUTO_IRQ_AFFINITY is not set
# CONFIG_IRQ_PER_CPU is not set
# CONFIG_HARDIRQS_SW_RESEND is not set
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
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
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
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
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
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
CONFIG_PREEMPT_NOTIFIERS=y
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
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
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
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION="/dev/sda2"
# CONFIG_PM_RUNTIME is not set
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_POWER_METER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
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
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_SECMARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_SCTP=m
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
# CONFIG_NETFILTER_XT_CONNMARK is not set

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_CT is not set
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_SCTP=m
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

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
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=y
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
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
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=y
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM63XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
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
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_KSZ884X_PCI is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_SLIP=m
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLHC=m
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
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
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
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
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_N_GSM is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=m
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=m
CONFIG_SERIAL_8250_PNP=m
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=m
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
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
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
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

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
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
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
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
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_PKGTEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
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
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
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
# CONFIG_SENSORS_LIS3_I2C is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_KMS is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
# CONFIG_FB_TILEBLITTING is not set

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
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
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
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_EGALAX is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_STANTUM is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
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
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
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
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

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
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=m
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD64=m
CONFIG_EDAC_AMD64_ERROR_INJECTION=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
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
# CONFIG_RTC_DRV_TEST is not set

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

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
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

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

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
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
# CONFIG_NFS_USE_NEW_IDMAPPER is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-15"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_BKL=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
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
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

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
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set
CONFIG_CRYPTO_FPU=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
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
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
# CONFIG_VHOST_NET is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

--fdj2RfSjLxBAspz7--
