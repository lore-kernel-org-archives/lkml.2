Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab2AST6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:58:37 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:54086
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932487Ab2AST6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:58:30 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0JJwEqk001909
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
In-Reply-To: <gi1uqvwpt2.fsf@mx10.gouders.net> (Dirk Gouders's message of
	"Thu, 19 Jan 2012 18:43:53 +0100")
References: <gi39bcyff8.fsf@mx10.gouders.net> <20120119110121.GC9268@arm.com>
	<gi1uqvsx8n.fsf@karga.hank.lab> <20120119140058.GA19036@arm.com>
	<gik44nrc52.fsf@karga.hank.lab> <20120119153732.GB20558@arm.com>
	<gi1uqvwpt2.fsf@mx10.gouders.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 19 Jan 2012 20:58:09 +0100
Message-ID: <gimx9jv50u.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 19 Jan 2012 20:58:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:

> Catalin Marinas <catalin.marinas@arm.com> writes:
>
>> On Thu, Jan 19, 2012 at 02:38:01PM +0000, Dirk Gouders wrote:
>>> Catalin Marinas <catalin.marinas@arm.com> writes:
>>> > On Thu, Jan 19, 2012 at 12:16:56PM +0000, Dirk Gouders wrote:
>>> >> Catalin Marinas <catalin.marinas@arm.com> writes:
>>> >> > On Wed, Jan 18, 2012 at 07:32:59PM +0000, Dirk Gouders wrote:
>>> >> >> Freeing unused kernel memory: 608k freed
>>> >> >> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>>> >> >> BUG: unable to handle kernel paging request at ffffffff818b232b
>>> >> >> IP: [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>>> > ...
>>> >> >> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>>> >> >> RIP  [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>>> >> >
>>> >> > I don't really see how kmemleak could cause such error (or any of the
>>> >> > recent changes I have made). It looks like some of the code in the
>>> >> > .init.text section is not executable.
>>> >
>>> > Ah, the interesting part - 0xcc is the poison value for freed initmem.
>>> > And from the kernel logs you posted Linux frees the initmem and later
>>> > calls kmemleak_late_init() which should have been in the .init.text
>>> > section.
>>> >
>>> > The kmemleak_late_init() function is defined as:
>>> >
>>> > static int __init kmemleak_late_init(void)
>>> > {
>>> > ...
>>> > }
>>> > late_initcall(kmemleak_late_init);
>>> >
>>> > and it must *not* be called after the initmem has been freed. Was there
>>> > any change in the x86 or generic code with regards to the freeing of the
>>> > init memory?
>>> 
>>> I tried to re-bisect this problem by marking commit
>>> 029aeff5db879afd7760f11214b6fea45f76b58e
>>> "kmemleak: Add support for memory hotplug" (that I previously considered
>>> good, because it produces a different output) bad.  The attached output
>>> shows that kmemleak_late_init is also involved but bisect did not bring
>>> me a step further:
>>> 
>>> $ git bisect good f1c84dae0e
>>> Bisecting: a merge base must be tested
>>> [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
>>
>> If you bisect to one of the kmemleak commits, they are based on 3.2-rc4
>> so you miss any commits that may have been merged during the merge
>> window.
>
> Hmm, I thought that the above was an error message but when I ignored it
> and just continued bisecting (whith a huge set of commits), it ended in:
>
> b66930052abf2e41b8a978ae265303917cbe6fa0 is the first bad commit
> commit b66930052abf2e41b8a978ae265303917cbe6fa0
> Author: Catalin Marinas <catalin.marinas@arm.com>
> Date:   Wed Sep 28 17:22:56 2011 +0100
>
>     kmemleak: When the early log buffer is exceeded, report the actual number
>     
>     Just telling that the early log buffer has been exceeded doesn't mean
>     much. This patch moves the error printing to the kmemleak_init()
>     function and displays the actual calls to the kmemleak API during early
>     logging.
>     
>     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>
> :040000 040000 6b16996be5be3f428eceb5ca8a153ac72f1848b3 246cccb0645241d4a1e1c392aaea3e2ea3e34da5 M      mm
>
>>> ------------------------------------------------------------------------
>>> Freeing unused kernel memory: 676k freed
>>> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>>> BUG: unable to handle kernel paging request at ffffffff81892482
>>> IP: [<ffffffff81892482>] kmemleak_late_init+0x8a/0x8a
>>> PGD 17cd067 PUD 17d1063 PMD 3c5c8063 PTE 8000000001892163
>>> Oops: 0011 [#1] SMP 
>>
>> Similar behaviour, the init memory is freed before the initcalls, so
>> doesn't look like a kmemleak problem.
>>
>> Could you pass initcall_debug on the kernel command line and see how may
>> commits are called before and after the free_initmem() call?
>>
>> You could also try to revert (git revert) the kmemleak commits from the
>> latest git tree, without bisecting.
>
> OK, I added initcall_debug to a bad kernel I saved while bisecting and
> attach the console output of the serial console - the output on the
> graphical console was more complete.
>
> Further, I tested Linus' current master with b66930052abf2 reverted 
>
> ------------------------------------------------------------------------
> commit 27e8880932050e77d2822a19fb9f39230f6363e9
> Author: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Date:   Thu Jan 19 18:31:40 2012 +0100
>
>     Revert "kmemleak: When the early log buffer is exceeded, report the actual number"
>     
>     This reverts commit b66930052abf2e41b8a978ae265303917cbe6fa0.
>
> commit ccb19d263fd1c9e34948e2158c53eacbff369344
> Merge: 6a48897 c3b5003
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Jan 17 22:26:41 2012 -0800
> ------------------------------------------------------------------------
>
> and that kernel works here.

Hi Catlin,

I did some more testing and it turns out that I have to revert a single
line of commit b66930052abf2 to make the kernel boot:

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c833add..d8bbb68 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1710,6 +1710,7 @@ static void kmemleak_disable(void)
                return;
 
        /* stop any memory operation tracing */
+       atomic_set(&kmemleak_early_log, 0);
        atomic_set(&kmemleak_enabled, 0);
 
        /* check whether it is too early for a kernel thread */

I started that kernel with initcall_debug and attach the dmesg output.

Dirk

------------------------------------------------------------------------
Linux version 3.2.0-09104-gccb19d2-dirty (root@mx10) (gcc version 4.5.3 (Gentoo 4.5.3-r2 p1.0, pie-0.4.7) ) #22 SMP Thu Jan 19 20:48:50 CET 2012
Command line: root=/dev/vda1 console=ttyS0,115200 console=tty0 initcall_debug
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
 BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)
 BIOS-e820: 000000003fffd000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Bochs Bochs, BIOS Bochs 01/01/2007
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x3fffd max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00E0000000 mask FFE0000000 uncachable
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
found SMP MP-table at [ffff8800000fd5f0] fd5f0
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000096000] 96000 size 20480
init_memory_mapping: 0000000000000000-000000003fffd000
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003fffd000 page 4k
kernel direct mapping tables up to 3fffd000 @ 1fffd000-20000000
ACPI: RSDP 00000000000fd460 00014 (v00 BOCHS )
ACPI: RSDT 000000003fffd740 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 000000003fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 000000003fffd9b0 02589 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
ACPI: FACS 000000003fffff40 00040
ACPI: SSDT 000000003fffd8b0 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 000000003fffd7c0 0007A (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: HPET 000000003fffd780 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000003fffd000
Initmem setup node 0 0000000000000000-000000003fffd000
  NODE_DATA [000000003fff8000 - 000000003fffcfff]
 [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003e600000-ffff88003f5fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x0000009b
    0: 0x00000100 -> 0x0003fffd
On node 0 totalpages: 262024
  DMA zone: 64 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3910 pages, LIFO batch:0
  DMA32 zone: 4032 pages used for memmap
  DMA32 zone: 254013 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xb008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ5 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ10 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009b000 - 000000000009c000
PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 40000000 (gap: 40000000:beffc000)
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff88003fc00000 s77312 r8192 d20992 u1048576
pcpu-alloc: s77312 r8192 d20992 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257923
Policy zone: DMA32
Kernel command line: root=/dev/vda1 console=ttyS0,115200 console=tty0 initcall_debug
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 1021000k/1048564k available (5533k kernel code, 468k absent, 27096k reserved, 3252k data, 604k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:512 16
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
kmemleak: Kernel memory leak detector disabled
hpet clockevent registered
Fast TSC calibration failed
TSC: PIT calibration matches HPET. 2 loops
Detected 2665.818 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5331.63 BogoMIPS (lpj=10663272)
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
mce: CPU supports 10 MCE banks
ACPI: Core revision 20110623
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version 0.15.1 stepping 03
APIC calibration not consistent with PM-Timer: 103ms instead of 100ms
APIC delta adjusted to PM-Timer: 6250338 (6495757)
calling  trace_init_flags_sys_exit+0x0/0xd @ 1
initcall trace_init_flags_sys_exit+0x0/0xd returned 0 after 0 usecs
calling  trace_init_flags_sys_enter+0x0/0xd @ 1
initcall trace_init_flags_sys_enter+0x0/0xd returned 0 after 0 usecs
calling  init_hw_perf_events+0x0/0x30d @ 1
Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
initcall init_hw_perf_events+0x0/0x30d returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x4a @ 1
initcall spawn_ksoftirqd+0x0/0x4a returned 0 after 0 usecs
calling  init_workqueues+0x0/0x2f8 @ 1
initcall init_workqueues+0x0/0x2f8 returned 0 after 0 usecs
calling  migration_init+0x0/0x65 @ 1
initcall migration_init+0x0/0x65 returned 0 after 0 usecs
calling  cpu_stop_init+0x0/0xa3 @ 1
initcall cpu_stop_init+0x0/0xa3 returned 0 after 0 usecs
calling  rcu_scheduler_really_started+0x0/0xd @ 1
initcall rcu_scheduler_really_started+0x0/0xd returned 0 after 0 usecs
calling  relay_init+0x0/0x17 @ 1
initcall relay_init+0x0/0x17 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x16a @ 1
initcall tracer_alloc_buffers+0x0/0x16a returned 0 after 0 usecs
calling  init_trace_printk+0x0/0x14 @ 1
initcall init_trace_printk+0x0/0x14 returned 0 after 0 usecs
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 96000
Brought up 2 CPUs
Total of 2 processors activated (10663.68 BogoMIPS).
calling  ipc_ns_init+0x0/0x4b @ 1
initcall ipc_ns_init+0x0/0x4b returned 0 after 0 usecs
calling  init_mmap_min_addr+0x0/0x11 @ 1
initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x1e @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x1e returned 0 after 0 usecs
calling  net_ns_init+0x0/0x161 @ 1
initcall net_ns_init+0x0/0x161 returned 0 after 0 usecs
calling  e820_mark_nvs_memory+0x0/0x36 @ 1
initcall e820_mark_nvs_memory+0x0/0x36 returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x33 @ 1
initcall cpufreq_tsc+0x0/0x33 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x17 @ 1
initcall pci_reboot_init+0x0/0x17 returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x23 @ 1
initcall init_lapic_sysfs+0x0/0x23 returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x35 @ 1
initcall init_smp_flush+0x0/0x35 returned 0 after 0 usecs
calling  cpu_hotplug_pm_sync_init+0x0/0x17 @ 1
initcall cpu_hotplug_pm_sync_init+0x0/0x17 returned 0 after 0 usecs
calling  alloc_frozen_cpus+0x0/0x3 @ 1
initcall alloc_frozen_cpus+0x0/0x3 returned 0 after 0 usecs
calling  sysctl_init+0x0/0x35 @ 1
initcall sysctl_init+0x0/0x35 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x8a @ 1
initcall ksysfs_init+0x0/0x8a returned 0 after 0 usecs
calling  pm_init+0x0/0x6b @ 1
initcall pm_init+0x0/0x6b returned 0 after 0 usecs
calling  pm_disk_init+0x0/0x1b @ 1
initcall pm_disk_init+0x0/0x1b returned 0 after 0 usecs
calling  swsusp_header_init+0x0/0x2f @ 1
initcall swsusp_header_init+0x0/0x2f returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x14 @ 1
initcall init_jiffies_clocksource+0x0/0x14 returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x22 @ 1
initcall init_zero_pfn+0x0/0x22 returned 0 after 0 usecs
calling  fsnotify_init+0x0/0x29 @ 1
initcall fsnotify_init+0x0/0x29 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2d @ 1
initcall filelock_init+0x0/0x2d returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x16 @ 1
initcall init_script_binfmt+0x0/0x16 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x16 @ 1
initcall init_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
calling  init_compat_elf_binfmt+0x0/0x16 @ 1
initcall init_compat_elf_binfmt+0x0/0x16 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x5d @ 1
initcall debugfs_init+0x0/0x5d returned 0 after 0 usecs
calling  random32_init+0x0/0xcb @ 1
initcall random32_init+0x0/0xcb returned 0 after 0 usecs
calling  virtio_init+0x0/0x30 @ 1
initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
calling  early_resume_init+0x0/0x16 @ 1
RTC time: 19:51:00, date: 01/19/12
initcall early_resume_init+0x0/0x16 returned 0 after 0 usecs
calling  cpufreq_core_init+0x0/0xb2 @ 1
initcall cpufreq_core_init+0x0/0xb2 returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x36 @ 1
initcall cpuidle_init+0x0/0x36 returned 0 after 0 usecs
calling  sock_init+0x0/0x79 @ 1
initcall sock_init+0x0/0x79 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x1a6 @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x1a6 returned 0 after 0 usecs
calling  bdi_class_init+0x0/0x4c @ 1
initcall bdi_class_init+0x0/0x4c returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x23 @ 1
initcall kobject_uevent_init+0x0/0x23 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x1b @ 1
initcall pcibus_class_init+0x0/0x1b returned 0 after 3906 usecs
calling  pci_driver_init+0x0/0x1b @ 1
initcall pci_driver_init+0x0/0x1b returned 0 after 0 usecs
calling  tty_class_init+0x0/0x37 @ 1
initcall tty_class_init+0x0/0x37 returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xea @ 1
initcall vtconsole_class_init+0x0/0xea returned 0 after 0 usecs
calling  wakeup_sources_debugfs_init+0x0/0x2e @ 1
initcall wakeup_sources_debugfs_init+0x0/0x2e returned 0 after 0 usecs
calling  register_node_type+0x0/0x1b @ 1
initcall register_node_type+0x0/0x1b returned 0 after 0 usecs
calling  i2c_init+0x0/0x79 @ 1
initcall i2c_init+0x0/0x79 returned 0 after 3906 usecs
calling  amd_postcore_init+0x0/0x1e @ 1
initcall amd_postcore_init+0x0/0x1e returned 0 after 0 usecs
calling  arch_kdebugfs_init+0x0/0x27 @ 1
initcall arch_kdebugfs_init+0x0/0x27 returned 0 after 0 usecs
calling  configure_trampolines+0x0/0x2c @ 1
initcall configure_trampolines+0x0/0x2c returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x67 @ 1
initcall mtrr_if_init+0x0/0x67 returned 0 after 0 usecs
calling  ffh_cstate_init+0x0/0x2d @ 1
initcall ffh_cstate_init+0x0/0x2d returned 0 after 0 usecs
calling  acpi_pci_init+0x0/0x5f @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x5f returned 0 after 0 usecs
calling  dmi_id_init+0x0/0xcd @ 1
initcall dmi_id_init+0x0/0xcd returned 0 after 0 usecs
calling  pci_arch_init+0x0/0x5f @ 1
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x5f returned 0 after 0 usecs
calling  topology_init+0x0/0x8d @ 1
initcall topology_init+0x0/0x8d returned 0 after 3906 usecs
calling  mtrr_init_finialize+0x0/0x39 @ 1
initcall mtrr_init_finialize+0x0/0x39 returned 0 after 0 usecs
calling  init_vdso+0x0/0x84 @ 1
initcall init_vdso+0x0/0x84 returned 0 after 0 usecs
calling  sysenter_setup+0x0/0xa4 @ 1
initcall sysenter_setup+0x0/0xa4 returned 0 after 0 usecs
calling  param_sysfs_init+0x0/0x121 @ 1
initcall param_sysfs_init+0x0/0x121 returned 0 after 50784 usecs
calling  pm_sysrq_init+0x0/0x1c @ 1
initcall pm_sysrq_init+0x0/0x1c returned 0 after 0 usecs
calling  default_bdi_init+0x0/0x9d @ 1
initcall default_bdi_init+0x0/0x9d returned 0 after 0 usecs
calling  init_bio+0x0/0xe5 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xe5 returned 0 after 3906 usecs
calling  fsnotify_notification_init+0x0/0x8a @ 1
initcall fsnotify_notification_init+0x0/0x8a returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0x14 @ 1
initcall cryptomgr_init+0x0/0x14 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x25 @ 1
initcall blk_settings_init+0x0/0x25 returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2d @ 1
initcall blk_ioc_init+0x0/0x2d returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x6f @ 1
initcall blk_softirq_init+0x0/0x6f returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x6f @ 1
initcall blk_iopoll_setup+0x0/0x6f returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x71 @ 1
initcall genhd_device_init+0x0/0x71 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x49 @ 1
initcall pci_slot_init+0x0/0x49 returned 0 after 0 usecs
calling  acpi_init+0x0/0xb1 @ 1
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
initcall acpi_init+0x0/0xb1 returned 0 after 156259 usecs
calling  dock_init+0x0/0xa4 @ 1
ACPI: No dock devices found.
initcall dock_init+0x0/0xa4 returned 0 after 7812 usecs
calling  acpi_pci_root_init+0x0/0x2b @ 1
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
PCI: root bus 00: using default resources
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
pci 0000:00:00.0: [8086:1237] type 0 class 0x000600
pci 0000:00:01.0: [8086:7000] type 0 class 0x000601
pci 0000:00:01.1: [8086:7010] type 0 class 0x000101
pci 0000:00:01.1: reg 20: [io  0xc0e0-0xc0ef]
pci 0000:00:01.2: [8086:7020] type 0 class 0x000c03
pci 0000:00:01.2: reg 20: [io  0xc080-0xc09f]
pci 0000:00:01.3: [8086:7113] type 0 class 0x000680
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
pci 0000:00:02.0: [1013:00b8] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
pci 0000:00:02.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
pci 0000:00:03.0: [1af4:1000] type 0 class 0x000200
pci 0000:00:03.0: reg 10: [io  0xc0a0-0xc0bf]
pci 0000:00:03.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
pci 0000:00:03.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
pci 0000:00:04.0: [8086:2668] type 0 class 0x000403
pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
pci 0000:00:05.0: [1af4:1002] type 0 class 0x000500
pci 0000:00:05.0: reg 10: [io  0xc0c0-0xc0df]
pci 0000:00:06.0: [1af4:1001] type 0 class 0x000100
pci 0000:00:06.0: reg 10: [io  0xc000-0xc03f]
pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
pci 0000:00:07.0: [1af4:1001] type 0 class 0x000100
pci 0000:00:07.0: reg 10: [io  0xc040-0xc07f]
pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x1e)
initcall acpi_pci_root_init+0x0/0x2b returned 0 after 312519 usecs
calling  acpi_pci_link_init+0x0/0x41 @ 1
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
initcall acpi_pci_link_init+0x0/0x41 returned 0 after 15625 usecs
calling  pnp_init+0x0/0x1b @ 1
initcall pnp_init+0x0/0x1b returned 0 after 0 usecs
calling  misc_init+0x0/0xad @ 1
initcall misc_init+0x0/0xad returned 0 after 3906 usecs
calling  vga_arb_device_init+0x0/0xd4 @ 1
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
initcall vga_arb_device_init+0x0/0xd4 returned 0 after 3906 usecs
calling  cn_init+0x0/0xa1 @ 1
initcall cn_init+0x0/0xa1 returned 0 after 0 usecs
calling  init_scsi+0x0/0x77 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x77 returned 0 after 3906 usecs
calling  ata_init+0x0/0x53 @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x53 returned 0 after 0 usecs
calling  usb_init+0x0/0x170 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x170 returned 0 after 3906 usecs
calling  serio_init+0x0/0x2e @ 1
initcall serio_init+0x0/0x2e returned 0 after 0 usecs
calling  input_init+0x0/0x102 @ 1
initcall input_init+0x0/0x102 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x43 @ 1
initcall power_supply_class_init+0x0/0x43 returned 0 after 0 usecs
calling  hwmon_init+0x0/0x4a @ 1
initcall hwmon_init+0x0/0x4a returned 0 after 0 usecs
calling  md_init+0x0/0x13d @ 1
initcall md_init+0x0/0x13d returned 0 after 0 usecs
calling  leds_init+0x0/0x47 @ 1
initcall leds_init+0x0/0x47 returned 0 after 0 usecs
calling  init_soundcore+0x0/0x85 @ 1
initcall init_soundcore+0x0/0x85 returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0x43 @ 1
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009bc00 - 000000000009ffff 
reserve RAM buffer: 000000003fffd000 - 000000003fffffff 
initcall pci_subsys_init+0x0/0x43 returned 0 after 3906 usecs
calling  proto_init+0x0/0x14 @ 1
initcall proto_init+0x0/0x14 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x1d9 @ 1
initcall net_dev_init+0x0/0x1d9 returned 0 after 0 usecs
calling  neigh_init+0x0/0x83 @ 1
initcall neigh_init+0x0/0x83 returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xa5 @ 1
initcall fib_rules_init+0x0/0xa5 returned 0 after 0 usecs
calling  genl_init+0x0/0x96 @ 1
initcall genl_init+0x0/0x96 returned 0 after 0 usecs
calling  bt_init+0x0/0xa9 @ 1
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
initcall bt_init+0x0/0xa9 returned 0 after 7812 usecs
calling  sysctl_init+0x0/0x49 @ 1
initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
calling  hpet_late_init+0x0/0xf5 @ 1
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 100.000000 MHz counter
initcall hpet_late_init+0x0/0xf5 returned 0 after 7812 usecs
calling  init_amd_nbs+0x0/0x35 @ 1
initcall init_amd_nbs+0x0/0x35 returned 0 after 0 usecs
calling  clocksource_done_booting+0x0/0x5d @ 1
Switching to clocksource hpet
initcall clocksource_done_booting+0x0/0x5d returned 0 after 7828 usecs
calling  rb_init_debugfs+0x0/0x32 @ 1
initcall rb_init_debugfs+0x0/0x32 returned 0 after 68 usecs
calling  tracer_init_debugfs+0x0/0x381 @ 1
initcall tracer_init_debugfs+0x0/0x381 returned 0 after 731 usecs
calling  init_trace_printk_function_export+0x0/0x32 @ 1
initcall init_trace_printk_function_export+0x0/0x32 returned 0 after 19 usecs
calling  event_trace_init+0x0/0x1b7 @ 1
initcall event_trace_init+0x0/0x1b7 returned 0 after 52422 usecs
calling  init_kprobe_trace+0x0/0x91 @ 1
initcall init_kprobe_trace+0x0/0x91 returned 0 after 36 usecs
calling  init_pipe_fs+0x0/0x42 @ 1
initcall init_pipe_fs+0x0/0x42 returned 0 after 96 usecs
calling  eventpoll_init+0x0/0xd7 @ 1
initcall eventpoll_init+0x0/0xd7 returned 0 after 48 usecs
calling  anon_inode_init+0x0/0x10b @ 1
initcall anon_inode_init+0x0/0x10b returned 0 after 53 usecs
calling  fscache_init+0x0/0x1e4 @ 1
FS-Cache: Loaded
initcall fscache_init+0x0/0x1e4 returned 0 after 857 usecs
calling  cachefiles_init+0x0/0x83 @ 1
CacheFiles: Loaded
initcall cachefiles_init+0x0/0x83 returned 0 after 1212 usecs
calling  blk_scsi_ioctl_init+0x0/0x8 @ 1
initcall blk_scsi_ioctl_init+0x0/0x8 returned 0 after 6 usecs
calling  acpi_event_init+0x0/0x80 @ 1
initcall acpi_event_init+0x0/0x80 returned 0 after 56 usecs
calling  pnp_system_init+0x0/0x14 @ 1
initcall pnp_system_init+0x0/0x14 returned 0 after 255 usecs
calling  pnpacpi_init+0x0/0x8f @ 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0xe0000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: [io  0x0070-0x0071]
pnp 00:01: [irq 8]
pnp 00:01: [io  0x0072-0x0077]
pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:02: [io  0x0060]
pnp 00:02: [io  0x0064]
pnp 00:02: [irq 1]
pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:03: [irq 12]
pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:04: [io  0x03f2-0x03f5]
pnp 00:04: [io  0x03f7]
pnp 00:04: [irq 6]
pnp 00:04: [dma 2]
pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:05: [io  0x03f8-0x03ff]
pnp 00:05: [irq 4]
pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:06: [mem 0xfed00000-0xfed003ff]
pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 7 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x8f returned 0 after 25367 usecs
calling  chr_dev_init+0x0/0xc8 @ 1
initcall chr_dev_init+0x0/0xc8 returned 0 after 48000 usecs
calling  firmware_class_init+0x0/0x1b @ 1
initcall firmware_class_init+0x0/0x1b returned 0 after 284 usecs
calling  thermal_init+0x0/0x6b @ 1
initcall thermal_init+0x0/0x6b returned 0 after 310 usecs
calling  cpufreq_gov_performance_init+0x0/0x14 @ 1
initcall cpufreq_gov_performance_init+0x0/0x14 returned 0 after 16 usecs
calling  init_acpi_pm_clocksource+0x0/0xdb @ 1
initcall init_acpi_pm_clocksource+0x0/0xdb returned 0 after 4589 usecs
calling  pcibios_assign_resources+0x0/0x6a @ 1
PCI: max bus depth: 0 pci_try_num: 1
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
initcall pcibios_assign_resources+0x0/0x6a returned 0 after 123 usecs
calling  sysctl_core_init+0x0/0x3a @ 1
initcall sysctl_core_init+0x0/0x3a returned 0 after 37 usecs
calling  inet_init+0x0/0x27a @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
initcall inet_init+0x0/0x27a returned 0 after 15286 usecs
calling  af_unix_init+0x0/0x4b @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x4b returned 0 after 994 usecs
calling  init_sunrpc+0x0/0x69 @ 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
initcall init_sunrpc+0x0/0x69 returned 0 after 5065 usecs
calling  pci_apply_final_quirks+0x0/0xfe @ 1
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
PCI: CLS 0 bytes, default 64
initcall pci_apply_final_quirks+0x0/0xfe returned 0 after 3649 usecs
calling  populate_rootfs+0x0/0xc8 @ 1
initcall populate_rootfs+0x0/0xc8 returned 0 after 327 usecs
calling  pci_iommu_init+0x0/0x37 @ 1
initcall pci_iommu_init+0x0/0x37 returned 0 after 12 usecs
calling  irqfd_module_init+0x0/0x36 @ 1
initcall irqfd_module_init+0x0/0x36 returned 0 after 137 usecs
calling  svm_init+0x0/0x20 @ 1
has_svm: not amd
kvm: no hardware support
initcall svm_init+0x0/0x20 returned -95 after 1497 usecs
initcall svm_init+0x0/0x20 returned with error code -95 
calling  i8259A_init_ops+0x0/0x24 @ 1
initcall i8259A_init_ops+0x0/0x24 returned 0 after 6 usecs
calling  vsyscall_init+0x0/0x2a @ 1
initcall vsyscall_init+0x0/0x2a returned 0 after 41 usecs
calling  sbf_init+0x0/0xea @ 1
initcall sbf_init+0x0/0xea returned 0 after 5 usecs
calling  init_tsc_clocksource+0x0/0x62 @ 1
initcall init_tsc_clocksource+0x0/0x62 returned 0 after 7 usecs
calling  add_rtc_cmos+0x0/0x98 @ 1
initcall add_rtc_cmos+0x0/0x98 returned 0 after 11 usecs
calling  i8237A_init_ops+0x0/0x17 @ 1
initcall i8237A_init_ops+0x0/0x17 returned 0 after 19 usecs
calling  cache_sysfs_init+0x0/0x62 @ 1
initcall cache_sysfs_init+0x0/0x62 returned 0 after 391 usecs
calling  mcheck_init_device+0x0/0xf0 @ 1
initcall mcheck_init_device+0x0/0xf0 returned 0 after 4270 usecs
calling  threshold_init_device+0x0/0x4d @ 1
initcall threshold_init_device+0x0/0x4d returned 0 after 10 usecs
calling  thermal_throttle_init_device+0x0/0x8c @ 1
initcall thermal_throttle_init_device+0x0/0x8c returned 0 after 5 usecs
calling  amd_ibs_init+0x0/0x1c6 @ 1
initcall amd_ibs_init+0x0/0x1c6 returned -19 after 10 usecs
calling  msr_init+0x0/0x114 @ 1
initcall msr_init+0x0/0x114 returned 0 after 830 usecs
calling  cpuid_init+0x0/0x114 @ 1
initcall cpuid_init+0x0/0x114 returned 0 after 806 usecs
calling  ioapic_init_ops+0x0/0x17 @ 1
initcall ioapic_init_ops+0x0/0x17 returned 0 after 6 usecs
calling  add_pcspkr+0x0/0x65 @ 1
initcall add_pcspkr+0x0/0x65 returned 0 after 278 usecs
calling  audit_classes_init+0x0/0xb2 @ 1
initcall audit_classes_init+0x0/0xb2 returned 0 after 45 usecs
calling  ia32_binfmt_init+0x0/0x17 @ 1
initcall ia32_binfmt_init+0x0/0x17 returned 0 after 18 usecs
calling  init_aout_binfmt+0x0/0x16 @ 1
initcall init_aout_binfmt+0x0/0x16 returned 0 after 6 usecs
calling  proc_execdomains_init+0x0/0x25 @ 1
initcall proc_execdomains_init+0x0/0x25 returned 0 after 35 usecs
calling  ioresources_init+0x0/0x3f @ 1
initcall ioresources_init+0x0/0x3f returned 0 after 25 usecs
calling  uid_cache_init+0x0/0x8b @ 1
initcall uid_cache_init+0x0/0x8b returned 0 after 31 usecs
calling  init_posix_timers+0x0/0x1cd @ 1
initcall init_posix_timers+0x0/0x1cd returned 0 after 26 usecs
calling  init_posix_cpu_timers+0x0/0xc8 @ 1
initcall init_posix_cpu_timers+0x0/0xc8 returned 0 after 5 usecs
calling  snapshot_device_init+0x0/0x14 @ 1
initcall snapshot_device_init+0x0/0x14 returned 0 after 281 usecs
calling  create_proc_profile+0x0/0x61 @ 1
initcall create_proc_profile+0x0/0x61 returned 0 after 5 usecs
calling  timekeeping_init_ops+0x0/0x17 @ 1
initcall timekeeping_init_ops+0x0/0x17 returned 0 after 5 usecs
calling  init_clocksource_sysfs+0x0/0x59 @ 1
initcall init_clocksource_sysfs+0x0/0x59 returned 0 after 810 usecs
calling  init_timer_list_procfs+0x0/0x2f @ 1
initcall init_timer_list_procfs+0x0/0x2f returned 0 after 21 usecs
calling  alarmtimer_init+0x0/0x197 @ 1
initcall alarmtimer_init+0x0/0x197 returned 0 after 1240 usecs
calling  init_tstats_procfs+0x0/0x2f @ 1
initcall init_tstats_procfs+0x0/0x2f returned 0 after 28 usecs
calling  futex_init+0x0/0x5f @ 1
initcall futex_init+0x0/0x5f returned 0 after 46 usecs
calling  proc_dma_init+0x0/0x25 @ 1
initcall proc_dma_init+0x0/0x25 returned 0 after 17 usecs
calling  proc_modules_init+0x0/0x25 @ 1
initcall proc_modules_init+0x0/0x25 returned 0 after 16 usecs
calling  kallsyms_init+0x0/0x28 @ 1
initcall kallsyms_init+0x0/0x28 returned 0 after 16 usecs
calling  ikconfig_init+0x0/0x3d @ 1
initcall ikconfig_init+0x0/0x3d returned 0 after 16 usecs
calling  audit_init+0x0/0x143 @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1327002660.000:1): initialized
initcall audit_init+0x0/0x143 returned 0 after 2550 usecs
calling  audit_watch_init+0x0/0x3d @ 1
initcall audit_watch_init+0x0/0x3d returned 0 after 16 usecs
calling  audit_tree_init+0x0/0x5b @ 1
initcall audit_tree_init+0x0/0x5b returned 0 after 46 usecs
calling  init_kprobes+0x0/0x170 @ 1
initcall init_kprobes+0x0/0x170 returned 0 after 42385 usecs
calling  hung_task_init+0x0/0x4c @ 1
initcall hung_task_init+0x0/0x4c returned 0 after 229 usecs
calling  irq_pm_init_ops+0x0/0x17 @ 1
initcall irq_pm_init_ops+0x0/0x17 returned 0 after 8 usecs
calling  utsname_sysctl_init+0x0/0x17 @ 1
initcall utsname_sysctl_init+0x0/0x17 returned 0 after 32 usecs
calling  init_tracepoints+0x0/0x14 @ 1
initcall init_tracepoints+0x0/0x14 returned 0 after 7 usecs
calling  init_events+0x0/0x60 @ 1
initcall init_events+0x0/0x60 returned 0 after 11 usecs
calling  perf_event_sysfs_init+0x0/0x99 @ 1
initcall perf_event_sysfs_init+0x0/0x99 returned 0 after 1582 usecs
calling  init_per_zone_wmark_min+0x0/0x7e @ 1
initcall init_per_zone_wmark_min+0x0/0x7e returned 0 after 1643 usecs
calling  kswapd_init+0x0/0x6f @ 1
initcall kswapd_init+0x0/0x6f returned 0 after 223 usecs
calling  setup_vmstat+0x0/0xbe @ 1
initcall setup_vmstat+0x0/0xbe returned 0 after 67 usecs
calling  mm_sysfs_init+0x0/0x2c @ 1
initcall mm_sysfs_init+0x0/0x2c returned 0 after 29 usecs
calling  proc_vmalloc_init+0x0/0x28 @ 1
initcall proc_vmalloc_init+0x0/0x28 returned 0 after 22 usecs
calling  procswaps_init+0x0/0x25 @ 1
initcall procswaps_init+0x0/0x25 returned 0 after 21 usecs
calling  hugetlb_init+0x0/0x25c @ 1
HugeTLB registered 2 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x25c returned 0 after 1970 usecs
calling  slab_proc_init+0x0/0x28 @ 1
initcall slab_proc_init+0x0/0x28 returned 0 after 22 usecs
calling  slab_sysfs_init+0x0/0xfa @ 1
initcall slab_sysfs_init+0x0/0xfa returned 0 after 50377 usecs
calling  fcntl_init+0x0/0x2d @ 1
initcall fcntl_init+0x0/0x2d returned 0 after 405 usecs
calling  proc_filesystems_init+0x0/0x25 @ 1
initcall proc_filesystems_init+0x0/0x25 returned 0 after 24 usecs
calling  dio_init+0x0/0x30 @ 1
initcall dio_init+0x0/0x30 returned 0 after 370 usecs
calling  fsnotify_mark_init+0x0/0x43 @ 1
initcall fsnotify_mark_init+0x0/0x43 returned 0 after 138 usecs
calling  dnotify_init+0x0/0x7e @ 1
initcall dnotify_init+0x0/0x7e returned 0 after 727 usecs
calling  inotify_user_setup+0x0/0x73 @ 1
initcall inotify_user_setup+0x0/0x73 returned 0 after 726 usecs
calling  aio_setup+0x0/0x7d @ 1
initcall aio_setup+0x0/0x7d returned 0 after 1533 usecs
calling  proc_locks_init+0x0/0x25 @ 1
initcall proc_locks_init+0x0/0x25 returned 0 after 19 usecs
calling  init_sys32_ioctl+0x0/0x2b @ 1
initcall init_sys32_ioctl+0x0/0x2b returned 0 after 61 usecs
calling  init_mbcache+0x0/0x17 @ 1
initcall init_mbcache+0x0/0x17 returned 0 after 6 usecs
calling  proc_cmdline_init+0x0/0x25 @ 1
initcall proc_cmdline_init+0x0/0x25 returned 0 after 24 usecs
calling  proc_consoles_init+0x0/0x25 @ 1
initcall proc_consoles_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_cpuinfo_init+0x0/0x25 @ 1
initcall proc_cpuinfo_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_devices_init+0x0/0x25 @ 1
initcall proc_devices_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_interrupts_init+0x0/0x25 @ 1
initcall proc_interrupts_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_loadavg_init+0x0/0x25 @ 1
initcall proc_loadavg_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_meminfo_init+0x0/0x25 @ 1
initcall proc_meminfo_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_stat_init+0x0/0x25 @ 1
initcall proc_stat_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_uptime_init+0x0/0x25 @ 1
initcall proc_uptime_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_version_init+0x0/0x25 @ 1
initcall proc_version_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_softirqs_init+0x0/0x25 @ 1
initcall proc_softirqs_init+0x0/0x25 returned 0 after 16 usecs
calling  proc_kcore_init+0x0/0xac @ 1
initcall proc_kcore_init+0x0/0xac returned 0 after 30 usecs
calling  proc_kmsg_init+0x0/0x28 @ 1
initcall proc_kmsg_init+0x0/0x28 returned 0 after 16 usecs
calling  proc_page_init+0x0/0x45 @ 1
initcall proc_page_init+0x0/0x45 returned 0 after 24 usecs
calling  init_devpts_fs+0x0/0x42 @ 1
initcall init_devpts_fs+0x0/0x42 returned 0 after 79 usecs
calling  init_ext3_fs+0x0/0x72 @ 1
initcall init_ext3_fs+0x0/0x72 returned 0 after 708 usecs
calling  init_ext2_fs+0x0/0x72 @ 1
initcall init_ext2_fs+0x0/0x72 returned 0 after 1470 usecs
calling  ext4_init_fs+0x0/0x20d @ 1
initcall ext4_init_fs+0x0/0x20d returned 0 after 3306 usecs
calling  journal_init+0x0/0x8d @ 1
initcall journal_init+0x0/0x8d returned 0 after 1988 usecs
calling  journal_init+0x0/0x2c @ 1
initcall journal_init+0x0/0x2c returned 0 after 2668 usecs
calling  init_ramfs_fs+0x0/0x14 @ 1
initcall init_ramfs_fs+0x0/0x14 returned 0 after 12 usecs
calling  init_hugetlbfs_fs+0x0/0x8e @ 1
initcall init_hugetlbfs_fs+0x0/0x8e returned 0 after 634 usecs
calling  init_fat_fs+0x0/0x45 @ 1
initcall init_fat_fs+0x0/0x45 returned 0 after 1029 usecs
calling  init_vfat_fs+0x0/0x14 @ 1
initcall init_vfat_fs+0x0/0x14 returned 0 after 9 usecs
calling  init_msdos_fs+0x0/0x14 @ 1
initcall init_msdos_fs+0x0/0x14 returned 0 after 8 usecs
calling  init_iso9660_fs+0x0/0x5d @ 1
initcall init_iso9660_fs+0x0/0x5d returned 0 after 505 usecs
calling  init_nfs_fs+0x0/0x11c @ 1
FS-Cache: Netfs 'nfs' registered for caching
initcall init_nfs_fs+0x0/0x11c returned 0 after 5606 usecs
calling  nfs4filelayout_init+0x0/0x29 @ 1
nfs4filelayout_init: NFSv4 File Layout Driver Registering...
initcall nfs4filelayout_init+0x0/0x29 returned 0 after 1741 usecs
calling  init_nfsd+0x0/0xb1 @ 1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall init_nfsd+0x0/0xb1 returned 0 after 5328 usecs
calling  init_nlm+0x0/0x25 @ 1
initcall init_nlm+0x0/0x25 returned 0 after 28 usecs
calling  init_nls_cp437+0x0/0x14 @ 1
initcall init_nls_cp437+0x0/0x14 returned 0 after 17 usecs
calling  init_nls_ascii+0x0/0x14 @ 1
initcall init_nls_ascii+0x0/0x14 returned 0 after 7 usecs
calling  init_nls_iso8859_1+0x0/0x14 @ 1
initcall init_nls_iso8859_1+0x0/0x14 returned 0 after 7 usecs
calling  init_nls_iso8859_15+0x0/0x14 @ 1
initcall init_nls_iso8859_15+0x0/0x14 returned 0 after 7 usecs
calling  init_nls_utf8+0x0/0x2b @ 1
initcall init_nls_utf8+0x0/0x2b returned 0 after 14 usecs
calling  init_autofs4_fs+0x0/0x1c @ 1
initcall init_autofs4_fs+0x0/0x1c returned 0 after 510 usecs
calling  init_xfs_fs+0x0/0x9f @ 1
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
SGI XFS Quota Management subsystem
initcall init_xfs_fs+0x0/0x9f returned 0 after 11831 usecs
calling  ipc_init+0x0/0x26 @ 1
msgmni has been set to 1994
initcall ipc_init+0x0/0x26 returned 0 after 918 usecs
calling  ipc_sysctl_init+0x0/0x17 @ 1
initcall ipc_sysctl_init+0x0/0x17 returned 0 after 24 usecs
calling  init_mqueue_fs+0x0/0x97 @ 1
initcall init_mqueue_fs+0x0/0x97 returned 0 after 473 usecs
calling  key_proc_init+0x0/0x36 @ 1
initcall key_proc_init+0x0/0x36 returned 0 after 17 usecs
calling  crypto_wq_init+0x0/0x36 @ 1
initcall crypto_wq_init+0x0/0x36 returned 0 after 163 usecs
calling  crypto_algapi_init+0x0/0x10 @ 1
initcall crypto_algapi_init+0x0/0x10 returned 0 after 17 usecs
calling  skcipher_module_init+0x0/0x2d @ 1
initcall skcipher_module_init+0x0/0x2d returned 0 after 5 usecs
calling  chainiv_module_init+0x0/0x14 @ 1
initcall chainiv_module_init+0x0/0x14 returned 0 after 14 usecs
calling  eseqiv_module_init+0x0/0x14 @ 1
initcall eseqiv_module_init+0x0/0x14 returned 0 after 5 usecs
calling  hmac_module_init+0x0/0x14 @ 1
initcall hmac_module_init+0x0/0x14 returned 0 after 5 usecs
calling  md5_mod_init+0x0/0x14 @ 1
initcall md5_mod_init+0x0/0x14 returned 0 after 240 usecs
calling  sha1_generic_mod_init+0x0/0x14 @ 1
initcall sha1_generic_mod_init+0x0/0x14 returned 0 after 236 usecs
calling  crypto_ecb_module_init+0x0/0x14 @ 1
initcall crypto_ecb_module_init+0x0/0x14 returned 0 after 5 usecs
calling  crypto_cbc_module_init+0x0/0x14 @ 1
initcall crypto_cbc_module_init+0x0/0x14 returned 0 after 5 usecs
calling  des_generic_mod_init+0x0/0x35 @ 1
initcall des_generic_mod_init+0x0/0x35 returned 0 after 478 usecs
calling  aes_init+0x0/0x14 @ 1
initcall aes_init+0x0/0x14 returned 0 after 238 usecs
calling  deflate_mod_init+0x0/0x14 @ 1
initcall deflate_mod_init+0x0/0x14 returned 0 after 266 usecs
calling  zlib_mod_init+0x0/0x14 @ 1
initcall zlib_mod_init+0x0/0x14 returned 0 after 993 usecs
calling  crc32c_mod_init+0x0/0x14 @ 1
initcall crc32c_mod_init+0x0/0x14 returned 0 after 244 usecs
calling  crypto_authenc_module_init+0x0/0x14 @ 1
initcall crypto_authenc_module_init+0x0/0x14 returned 0 after 6 usecs
calling  crypto_authenc_esn_module_init+0x0/0x14 @ 1
initcall crypto_authenc_esn_module_init+0x0/0x14 returned 0 after 5 usecs
calling  krng_mod_init+0x0/0x14 @ 1
initcall krng_mod_init+0x0/0x14 returned 0 after 240 usecs
calling  proc_genhd_init+0x0/0x3f @ 1
initcall proc_genhd_init+0x0/0x3f returned 0 after 27 usecs
calling  noop_init+0x0/0x14 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x14 returned 0 after 875 usecs
calling  deadline_init+0x0/0x14 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x14 returned 0 after 919 usecs
calling  cfq_init+0x0/0x8c @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0x8c returned 0 after 1816 usecs
calling  percpu_counter_startup+0x0/0x1c @ 1
initcall percpu_counter_startup+0x0/0x1c returned 0 after 8 usecs
calling  pci_proc_init+0x0/0x60 @ 1
initcall pci_proc_init+0x0/0x60 returned 0 after 202 usecs
calling  pcie_portdrv_init+0x0/0x6d @ 1
initcall pcie_portdrv_init+0x0/0x6d returned 0 after 582 usecs
calling  aer_service_init+0x0/0x27 @ 1
initcall aer_service_init+0x0/0x27 returned 0 after 256 usecs
calling  pcie_pme_service_init+0x0/0x14 @ 1
initcall pcie_pme_service_init+0x0/0x14 returned 0 after 262 usecs
calling  ioapic_init+0x0/0x1d @ 1
initcall ioapic_init+0x0/0x1d returned 0 after 279 usecs
calling  acpi_reserve_resources+0x0/0xee @ 1
initcall acpi_reserve_resources+0x0/0xee returned 0 after 19 usecs
calling  irqrouter_init_ops+0x0/0x29 @ 1
initcall irqrouter_init_ops+0x0/0x29 returned 0 after 5 usecs
calling  acpi_ac_init+0x0/0x47 @ 1
initcall acpi_ac_init+0x0/0x47 returned 0 after 305 usecs
calling  acpi_button_init+0x0/0x14 @ 1
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
initcall acpi_button_init+0x0/0x14 returned 0 after 3277 usecs
calling  acpi_fan_init+0x0/0x1b @ 1
initcall acpi_fan_init+0x0/0x1b returned 0 after 339 usecs
calling  acpi_processor_init+0x0/0x82 @ 1
initcall acpi_processor_init+0x0/0x82 returned 0 after 7946 usecs
calling  acpi_container_init+0x0/0x4b @ 1
initcall acpi_container_init+0x0/0x4b returned 0 after 26972 usecs
calling  acpi_thermal_init+0x0/0x45 @ 1
initcall acpi_thermal_init+0x0/0x45 returned 0 after 445 usecs
calling  acpi_battery_init+0x0/0x19 @ 1
initcall acpi_battery_init+0x0/0x19 returned 0 after 16 usecs
calling  virtio_pci_init+0x0/0x1d @ 1
calling  1_acpi_battery_init_async+0x0/0x43 @ 5
initcall 1_acpi_battery_init_async+0x0/0x43 returned 0 after 1009 usecs
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
virtio-pci 0000:00:03.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
virtio-pci 0000:00:05.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
virtio-pci 0000:00:06.0: setting latency timer to 64
virtio-pci 0000:00:07.0: setting latency timer to 64
initcall virtio_pci_init+0x0/0x1d returned 0 after 25131 usecs
calling  init+0x0/0x14 @ 1
initcall init+0x0/0x14 returned 0 after 902 usecs
calling  pty_init+0x0/0x15 @ 1
initcall pty_init+0x0/0x15 returned 0 after 274426 usecs
calling  sysrq_init+0x0/0x6b @ 1
initcall sysrq_init+0x0/0x6b returned 0 after 34 usecs
calling  serial8250_init+0x0/0x18f @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_init+0x0/0x18f returned 0 after 152634 usecs
calling  serial8250_pnp_init+0x0/0x14 @ 1
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_pnp_init+0x0/0x14 returned 0 after 55644 usecs
calling  serial8250_pci_init+0x0/0x1d @ 1
initcall serial8250_pci_init+0x0/0x1d returned 0 after 543 usecs
calling  rand_initialize+0x0/0x2f @ 1
initcall rand_initialize+0x0/0x2f returned 0 after 41 usecs
calling  raw_init+0x0/0x13a @ 1
initcall raw_init+0x0/0x13a returned 0 after 1101 usecs
calling  rtc_init+0x0/0xa9 @ 1
Real Time Clock Driver v1.12b
initcall rtc_init+0x0/0xa9 returned 0 after 1893 usecs
calling  hpet_init+0x0/0x60 @ 1
initcall hpet_init+0x0/0x60 returned 0 after 1225 usecs
calling  mod_init+0x0/0x1d9 @ 1
initcall mod_init+0x0/0x1d9 returned -19 after 232 usecs
calling  mod_init+0x0/0x128 @ 1
initcall mod_init+0x0/0x128 returned -19 after 87 usecs
calling  mod_init+0x0/0x49 @ 1
initcall mod_init+0x0/0x49 returned -19 after 7 usecs
calling  agp_init+0x0/0x29 @ 1
Linux agpgart interface v0.103
initcall agp_init+0x0/0x29 returned 0 after 1188 usecs
calling  agp_amd64_mod_init+0x0/0x27 @ 1
initcall agp_amd64_mod_init+0x0/0x27 returned -19 after 975 usecs
calling  agp_intel_init+0x0/0x30 @ 1
initcall agp_intel_init+0x0/0x30 returned 0 after 416 usecs
calling  cn_proc_init+0x0/0x33 @ 1
initcall cn_proc_init+0x0/0x33 returned 0 after 14 usecs
calling  topology_sysfs_init+0x0/0x4e @ 1
initcall topology_sysfs_init+0x0/0x4e returned 0 after 180 usecs
calling  floppy_init+0x0/0x5af @ 1
FDC 0 is a S82078B
initcall floppy_init+0x0/0x5af returned 0 after 16967 usecs
calling  brd_init+0x0/0x1b7 @ 1
brd: module loaded
initcall brd_init+0x0/0x1b7 returned 0 after 32096 usecs
calling  loop_init+0x0/0x12d @ 1
loop: module loaded
initcall loop_init+0x0/0x12d returned 0 after 18807 usecs
calling  init+0x0/0x77 @ 1
virtio-pci 0000:00:06.0: irq 40 for MSI/MSI-X
virtio-pci 0000:00:06.0: irq 41 for MSI/MSI-X
 vda: vda1
virtio-pci 0000:00:07.0: irq 42 for MSI/MSI-X
virtio-pci 0000:00:07.0: irq 43 for MSI/MSI-X
Refined TSC clocksource calibration: 2665.986 MHz.
Switching to clocksource tsc
 vdb: unknown partition table
initcall init+0x0/0x77 returned 0 after 240719 usecs
calling  ide_init+0x0/0x79 @ 1
Uniform Multi-Platform E-IDE driver
initcall ide_init+0x0/0x79 returned 0 after 11945 usecs
calling  via_ide_init+0x0/0x1d @ 1
initcall via_ide_init+0x0/0x1d returned 0 after 0 usecs
calling  ide_scan_pcibus+0x0/0xe1 @ 1
initcall ide_scan_pcibus+0x0/0xe1 returned 0 after 401 usecs
calling  ide_gd_init+0x0/0x22 @ 1
ide-gd driver 1.18
initcall ide_gd_init+0x0/0x22 returned 0 after 1279 usecs
calling  ide_cdrom_init+0x0/0x22 @ 1
ide-cd driver 5.00
initcall ide_cdrom_init+0x0/0x22 returned 0 after 1294 usecs
calling  scsi_tgt_init+0x0/0x7a @ 1
initcall scsi_tgt_init+0x0/0x7a returned 0 after 1385 usecs
calling  spi_transport_init+0x0/0x70 @ 1
initcall spi_transport_init+0x0/0x70 returned 0 after 549 usecs
calling  fc_transport_init+0x0/0x8f @ 1
initcall fc_transport_init+0x0/0x8f returned 0 after 2919 usecs
calling  ahd_linux_init+0x0/0x7f @ 1
initcall ahd_linux_init+0x0/0x7f returned 0 after 304 usecs
calling  init_sd+0x0/0x10c @ 1
initcall init_sd+0x0/0x10c returned 0 after 863 usecs
calling  init_sr+0x0/0x47 @ 1
initcall init_sr+0x0/0x47 returned 0 after 250 usecs
calling  init_sg+0x0/0xca @ 1
initcall init_sg+0x0/0xca returned 0 after 225 usecs
calling  ahci_init+0x0/0x1d @ 1
initcall ahci_init+0x0/0x1d returned 0 after 276 usecs
calling  svia_init+0x0/0x1d @ 1
initcall svia_init+0x0/0x1d returned 0 after 273 usecs
calling  via_init+0x0/0x1d @ 1
initcall via_init+0x0/0x1d returned 0 after 348 usecs
calling  ata_generic_init+0x0/0x1d @ 1
initcall ata_generic_init+0x0/0x1d returned 0 after 406 usecs
calling  legacy_init+0x0/0x1f6 @ 1
initcall legacy_init+0x0/0x1f6 returned -19 after 60 usecs
calling  net_olddevs_init+0x0/0x99 @ 1
initcall net_olddevs_init+0x0/0x99 returned 0 after 10 usecs
calling  tun_init+0x0/0x89 @ 1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
initcall tun_init+0x0/0x89 returned 0 after 2480 usecs
calling  cdrom_init+0x0/0x10 @ 1
initcall cdrom_init+0x0/0x10 returned 0 after 30 usecs
calling  mon_init+0x0/0xf8 @ 1
initcall mon_init+0x0/0xf8 returned 0 after 560 usecs
calling  ehci_hcd_init+0x0/0x7b @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
initcall ehci_hcd_init+0x0/0x7b returned 0 after 1540 usecs
calling  ohci_hcd_mod_init+0x0/0x57 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
initcall ohci_hcd_mod_init+0x0/0x57 returned 0 after 1479 usecs
calling  uhci_hcd_init+0x0/0xbc @ 1
uhci_hcd: USB Universal Host Controller Interface driver
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:01.2: setting latency timer to 64
uhci_hcd 0000:00:01.2: UHCI Host Controller
uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c080
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
initcall uhci_hcd_init+0x0/0xbc returned 0 after 32463 usecs
calling  usb_stor_init+0x0/0x3c @ 1
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall usb_stor_init+0x0/0x3c returned 0 after 4962 usecs
calling  usb_serial_init+0x0/0x1e2 @ 1
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
initcall usb_serial_init+0x0/0x1e2 returned 0 after 11462 usecs
calling  i8042_init+0x0/0x106 @ 1
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x106 returned 0 after 7776 usecs
calling  mousedev_init+0x0/0x83 @ 1
mousedev: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x83 returned 0 after 2323 usecs
calling  evdev_init+0x0/0x14 @ 1
initcall evdev_init+0x0/0x14 returned 0 after 404 usecs
calling  atkbd_init+0x0/0x29 @ 1
initcall atkbd_init+0x0/0x29 returned 0 after 349 usecs
calling  psmouse_init+0x0/0x7c @ 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
initcall psmouse_init+0x0/0x7c returned 0 after 3165 usecs
calling  i2c_dev_init+0x0/0xc0 @ 1
i2c /dev entries driver
initcall i2c_dev_init+0x0/0xc0 returned 0 after 3458 usecs
calling  amd756_init+0x0/0x1d @ 1
initcall amd756_init+0x0/0x1d returned 0 after 321 usecs
calling  amd756_s4882_init+0x0/0x2bb @ 1
initcall amd756_s4882_init+0x0/0x2bb returned -19 after 0 usecs
calling  nforce2_init+0x0/0x1d @ 1
initcall nforce2_init+0x0/0x1d returned 0 after 307 usecs
calling  nforce2_s4985_init+0x0/0x2c4 @ 1
initcall nforce2_s4985_init+0x0/0x2c4 returned -19 after 0 usecs
calling  raid_init+0x0/0x14 @ 1
md: raid1 personality registered for level 1
initcall raid_init+0x0/0x14 returned 0 after 1068 usecs
calling  dm_init+0x0/0x42 @ 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@redhat.com
initcall dm_init+0x0/0x42 returned 0 after 8546 usecs
calling  dm_crypt_init+0x0/0x5f @ 1
initcall dm_crypt_init+0x0/0x5f returned 0 after 323 usecs
calling  dm_delay_init+0x0/0xb6 @ 1
initcall dm_delay_init+0x0/0xb6 returned 0 after 395 usecs
calling  dm_multipath_init+0x0/0x121 @ 1
device-mapper: multipath: version 1.3.0 loaded
initcall dm_multipath_init+0x0/0x121 returned 0 after 1553 usecs
calling  dm_rr_init+0x0/0x35 @ 1
device-mapper: multipath round-robin: version 1.0.0 loaded
initcall dm_rr_init+0x0/0x35 returned 0 after 1519 usecs
calling  dm_ql_init+0x0/0x35 @ 1
device-mapper: multipath queue-length: version 0.1.0 loaded
initcall dm_ql_init+0x0/0x35 returned 0 after 1252 usecs
calling  dm_st_init+0x0/0x35 @ 1
device-mapper: multipath service-time: version 0.2.0 loaded
initcall dm_st_init+0x0/0x35 returned 0 after 1243 usecs
calling  dm_snapshot_init+0x0/0x20b @ 1
initcall dm_snapshot_init+0x0/0x20b returned 0 after 1098 usecs
calling  dm_mirror_init+0x0/0x6f @ 1
initcall dm_mirror_init+0x0/0x6f returned 0 after 337 usecs
calling  dm_dirty_log_init+0x0/0x4f @ 1
initcall dm_dirty_log_init+0x0/0x4f returned 0 after 5 usecs
calling  userspace_dirty_log_init+0x0/0x9a @ 1
device-mapper: dm-log-userspace: version 1.1.0 loaded
initcall userspace_dirty_log_init+0x0/0x9a returned 0 after 1537 usecs
calling  dm_zero_init+0x0/0x27 @ 1
initcall dm_zero_init+0x0/0x27 returned 0 after 0 usecs
calling  kcapi_init+0x0/0x63 @ 1
initcall kcapi_init+0x0/0x63 returned 0 after 170 usecs
calling  mISDNInit+0x0/0xd0 @ 1
Modular ISDN core version 1.1.21
NET: Registered protocol family 34
initcall mISDNInit+0x0/0xd0 returned 0 after 2561 usecs
calling  cpufreq_stats_init+0x0/0x90 @ 1
initcall cpufreq_stats_init+0x0/0x90 returned 0 after 5 usecs
calling  cpufreq_gov_userspace_init+0x0/0x14 @ 1
initcall cpufreq_gov_userspace_init+0x0/0x14 returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0x5a @ 1
initcall cpufreq_gov_dbs_init+0x0/0x5a returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0x14 @ 1
initcall cpufreq_gov_dbs_init+0x0/0x14 returned 0 after 0 usecs
calling  init_ladder+0x0/0x14 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x14 returned 0 after 949 usecs
calling  init_menu+0x0/0x14 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x14 returned 0 after 917 usecs
calling  oprofile_init+0x0/0x73 @ 1
oprofile: using NMI interrupt.
initcall oprofile_init+0x0/0x73 returned 0 after 979 usecs
calling  sock_diag_init+0x0/0x39 @ 1
initcall sock_diag_init+0x0/0x39 returned 0 after 17 usecs
calling  flow_cache_init_global+0x0/0x2f @ 1
initcall flow_cache_init_global+0x0/0x2f returned 0 after 400 usecs
calling  nf_conntrack_standalone_init+0x0/0x14 @ 1
nf_conntrack version 0.5.0 (7976 buckets, 31904 max)
initcall nf_conntrack_standalone_init+0x0/0x14 returned 0 after 2115 usecs
calling  nf_conntrack_ftp_init+0x0/0x1a1 @ 1
initcall nf_conntrack_ftp_init+0x0/0x1a1 returned 0 after 1 usecs
calling  nf_conntrack_h323_init+0x0/0xc8 @ 1
initcall nf_conntrack_h323_init+0x0/0xc8 returned 0 after 7 usecs
calling  nf_conntrack_sip_init+0x0/0x1c5 @ 1
initcall nf_conntrack_sip_init+0x0/0x1c5 returned 0 after 0 usecs
calling  xt_init+0x0/0x11d @ 1
initcall xt_init+0x0/0x11d returned 0 after 4 usecs
calling  tcpudp_mt_init+0x0/0x19 @ 1
initcall tcpudp_mt_init+0x0/0x19 returned 0 after 5 usecs
calling  hl_mt_init+0x0/0x19 @ 1
initcall hl_mt_init+0x0/0x19 returned 0 after 0 usecs
calling  sysctl_ipv4_init+0x0/0x7d @ 1
initcall sysctl_ipv4_init+0x0/0x7d returned 0 after 149 usecs
calling  tunnel4_init+0x0/0x69 @ 1
initcall tunnel4_init+0x0/0x69 returned 0 after 0 usecs
calling  ipv4_netfilter_init+0x0/0x14 @ 1
initcall ipv4_netfilter_init+0x0/0x14 returned 0 after 4 usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x141 @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x141 returned 0 after 190 usecs
calling  nf_nat_init+0x0/0x107 @ 1
initcall nf_nat_init+0x0/0x107 returned 0 after 66 usecs
calling  nf_defrag_init+0x0/0x19 @ 1
initcall nf_defrag_init+0x0/0x19 returned 0 after 0 usecs
calling  nf_nat_ftp_init+0x0/0x1a @ 1
initcall nf_nat_ftp_init+0x0/0x1a returned 0 after 0 usecs
calling  init+0x0/0xd2 @ 1
initcall init+0x0/0xd2 returned 0 after 0 usecs
calling  nf_nat_sip_init+0x0/0xa4 @ 1
initcall nf_nat_sip_init+0x0/0xa4 returned 0 after 0 usecs
calling  ip_tables_init+0x0/0xaf @ 1
ip_tables: (C) 2000-2006 Netfilter Core Team
initcall ip_tables_init+0x0/0xaf returned 0 after 1474 usecs
calling  iptable_filter_init+0x0/0x47 @ 1
initcall iptable_filter_init+0x0/0x47 returned 0 after 55 usecs
calling  iptable_mangle_init+0x0/0x47 @ 1
initcall iptable_mangle_init+0x0/0x47 returned 0 after 36 usecs
calling  nf_nat_standalone_init+0x0/0x76 @ 1
initcall nf_nat_standalone_init+0x0/0x76 returned 0 after 32 usecs
calling  log_tg_init+0x0/0x2c @ 1
initcall log_tg_init+0x0/0x2c returned 0 after 0 usecs
calling  masquerade_tg_init+0x0/0x2f @ 1
initcall masquerade_tg_init+0x0/0x2f returned 0 after 2 usecs
calling  reject_tg_init+0x0/0x14 @ 1
initcall reject_tg_init+0x0/0x14 returned 0 after 0 usecs
calling  inet_diag_init+0x0/0x80 @ 1
initcall inet_diag_init+0x0/0x80 returned 0 after 3 usecs
calling  tcp_diag_init+0x0/0x14 @ 1
initcall tcp_diag_init+0x0/0x14 returned 0 after 0 usecs
calling  cubictcp_register+0x0/0x6e @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x6e returned 0 after 756 usecs
calling  inet6_init+0x0/0x2a7 @ 1
NET: Registered protocol family 10
initcall inet6_init+0x0/0x2a7 returned 0 after 18661 usecs
calling  ah6_init+0x0/0x69 @ 1
initcall ah6_init+0x0/0x69 returned 0 after 6 usecs
calling  esp6_init+0x0/0x69 @ 1
initcall esp6_init+0x0/0x69 returned 0 after 0 usecs
calling  ipcomp6_init+0x0/0x69 @ 1
initcall ipcomp6_init+0x0/0x69 returned 0 after 0 usecs
calling  xfrm6_tunnel_init+0x0/0xca @ 1
initcall xfrm6_tunnel_init+0x0/0xca returned 0 after 487 usecs
calling  tunnel6_init+0x0/0x69 @ 1
initcall tunnel6_init+0x0/0x69 returned 0 after 0 usecs
calling  xfrm6_transport_init+0x0/0x19 @ 1
initcall xfrm6_transport_init+0x0/0x19 returned 0 after 0 usecs
calling  xfrm6_mode_tunnel_init+0x0/0x19 @ 1
initcall xfrm6_mode_tunnel_init+0x0/0x19 returned 0 after 0 usecs
calling  xfrm6_ro_init+0x0/0x19 @ 1
initcall xfrm6_ro_init+0x0/0x19 returned 0 after 0 usecs
calling  xfrm6_beet_init+0x0/0x19 @ 1
initcall xfrm6_beet_init+0x0/0x19 returned 0 after 0 usecs
calling  mip6_init+0x0/0xbd @ 1
Mobile IPv6
initcall mip6_init+0x0/0xbd returned 0 after 913 usecs
calling  ip6_tables_init+0x0/0xaf @ 1
ip6_tables: (C) 2000-2006 Netfilter Core Team
initcall ip6_tables_init+0x0/0xaf returned 0 after 1606 usecs
calling  ip6table_filter_init+0x0/0x47 @ 1
initcall ip6table_filter_init+0x0/0x47 returned 0 after 68 usecs
calling  ip6table_mangle_init+0x0/0x47 @ 1
initcall ip6table_mangle_init+0x0/0x47 returned 0 after 93 usecs
calling  ip6_queue_init+0x0/0x130 @ 1
initcall ip6_queue_init+0x0/0x130 returned 0 after 86 usecs
calling  ip6table_raw_init+0x0/0x47 @ 1
initcall ip6table_raw_init+0x0/0x47 returned 0 after 53 usecs
calling  nf_conntrack_l3proto_ipv6_init+0x0/0xf2 @ 1
initcall nf_conntrack_l3proto_ipv6_init+0x0/0xf2 returned 0 after 19 usecs
calling  nf_defrag_init+0x0/0x4a @ 1
initcall nf_defrag_init+0x0/0x4a returned 0 after 52 usecs
calling  ah_mt6_init+0x0/0x14 @ 1
initcall ah_mt6_init+0x0/0x14 returned 0 after 0 usecs
calling  eui64_mt6_init+0x0/0x14 @ 1
initcall eui64_mt6_init+0x0/0x14 returned 0 after 0 usecs
calling  frag_mt6_init+0x0/0x14 @ 1
initcall frag_mt6_init+0x0/0x14 returned 0 after 0 usecs
calling  ipv6header_mt6_init+0x0/0x14 @ 1
initcall ipv6header_mt6_init+0x0/0x14 returned 0 after 0 usecs
calling  mh_mt6_init+0x0/0x14 @ 1
initcall mh_mt6_init+0x0/0x14 returned 0 after 0 usecs
calling  hbh_mt6_init+0x0/0x19 @ 1
initcall hbh_mt6_init+0x0/0x19 returned 0 after 0 usecs
calling  rt_mt6_init+0x0/0x14 @ 1
initcall rt_mt6_init+0x0/0x14 returned 0 after 0 usecs
calling  log_tg6_init+0x0/0x2c @ 1
initcall log_tg6_init+0x0/0x2c returned 0 after 0 usecs
calling  reject_tg6_init+0x0/0x14 @ 1
initcall reject_tg6_init+0x0/0x14 returned 0 after 0 usecs
calling  sit_init+0x0/0x56 @ 1
IPv6 over IPv4 tunneling driver
initcall sit_init+0x0/0x56 returned 0 after 11591 usecs
calling  packet_init+0x0/0x3d @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x3d returned 0 after 962 usecs
calling  init_rpcsec_gss+0x0/0x43 @ 1
initcall init_rpcsec_gss+0x0/0x43 returned 0 after 75 usecs
calling  init_dns_resolver+0x0/0x103 @ 1
Registering the dns_resolver key type
initcall init_dns_resolver+0x0/0x103 returned 0 after 968 usecs
calling  mcheck_debugfs_init+0x0/0x3e @ 1
initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 25 usecs
calling  severities_debugfs_init+0x0/0x3e @ 1
initcall severities_debugfs_init+0x0/0x3e returned 0 after 7 usecs
calling  hpet_insert_resource+0x0/0x2a @ 1
initcall hpet_insert_resource+0x0/0x2a returned 0 after 2 usecs
calling  update_mp_table+0x0/0x1c0 @ 1
initcall update_mp_table+0x0/0x1c0 returned 0 after 7 usecs
calling  lapic_insert_resource+0x0/0x42 @ 1
initcall lapic_insert_resource+0x0/0x42 returned 0 after 0 usecs
calling  io_apic_bug_finalize+0x0/0x16 @ 1
initcall io_apic_bug_finalize+0x0/0x16 returned 0 after 0 usecs
calling  print_ICs+0x0/0x162 @ 1
initcall print_ICs+0x0/0x162 returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x53 @ 1
initcall check_early_ioremap_leak+0x0/0x53 returned 0 after 1 usecs
calling  pat_memtype_list_init+0x0/0x35 @ 1
initcall pat_memtype_list_init+0x0/0x35 returned 0 after 0 usecs
calling  init_oops_id+0x0/0x34 @ 1
initcall init_oops_id+0x0/0x34 returned 0 after 1 usecs
calling  printk_late_init+0x0/0x4f @ 1
initcall printk_late_init+0x0/0x4f returned 0 after 3 usecs
calling  pm_debugfs_init+0x0/0x27 @ 1
initcall pm_debugfs_init+0x0/0x27 returned 0 after 8 usecs
calling  pm_qos_power_init+0x0/0xc0 @ 1
initcall pm_qos_power_init+0x0/0xc0 returned 0 after 1441 usecs
calling  software_resume+0x0/0x25c @ 1
PM: Hibernation image not present or could not be loaded.
initcall software_resume+0x0/0x25c returned -2 after 7 usecs
initcall software_resume+0x0/0x25c returned with error code -2 
calling  debugfs_kprobe_init+0x0/0x92 @ 1
initcall debugfs_kprobe_init+0x0/0x92 returned 0 after 35 usecs
calling  taskstats_init+0x0/0x93 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0x93 returned 0 after 943 usecs
calling  clear_boot_tracer+0x0/0x30 @ 1
initcall clear_boot_tracer+0x0/0x30 returned 0 after 8 usecs
calling  max_swapfiles_check+0x0/0x3 @ 1
initcall max_swapfiles_check+0x0/0x3 returned 0 after 0 usecs
calling  kmemleak_late_init+0x0/0x8a @ 1
initcall kmemleak_late_init+0x0/0x8a returned -12 after 4 usecs
initcall kmemleak_late_init+0x0/0x8a returned with error code -12 
calling  random32_reseed+0x0/0xa6 @ 1
initcall random32_reseed+0x0/0xa6 returned 0 after 6 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x1b @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x1b returned 0 after 17 usecs
calling  pci_sysfs_init+0x0/0x4e @ 1
initcall pci_sysfs_init+0x0/0x4e returned 0 after 1122 usecs
calling  random_int_secret_init+0x0/0x1c @ 1
initcall random_int_secret_init+0x0/0x1c returned 0 after 6 usecs
calling  late_resume_init+0x0/0xe3 @ 1
  Magic number: 12:750:900
tty ptyvd: hash matches
acpi PNP0501:00: hash matches
initcall late_resume_init+0x0/0xe3 returned 0 after 3042 usecs
calling  scsi_complete_async_scans+0x0/0x124 @ 1
initcall scsi_complete_async_scans+0x0/0x124 returned 0 after 0 usecs
calling  powernowk8_init+0x0/0x1bc @ 1
initcall powernowk8_init+0x0/0x1bc returned -19 after 38 usecs
calling  acpi_cpufreq_init+0x0/0x9f @ 1
initcall acpi_cpufreq_init+0x0/0x9f returned -19 after 91 usecs
calling  memmap_init+0x0/0x2a @ 1
initcall memmap_init+0x0/0x2a returned 0 after 205 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x54 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x54 returned 1 after 0 usecs
initcall pci_mmcfg_late_insert_resources+0x0/0x54 returned with error code 1 
calling  net_secret_init+0x0/0x1c @ 1
initcall net_secret_init+0x0/0x1c returned 0 after 6 usecs
calling  tcp_congestion_default+0x0/0x14 @ 1
initcall tcp_congestion_default+0x0/0x14 returned 0 after 0 usecs
calling  ip_auto_config+0x0/0x2b2 @ 1
initcall ip_auto_config+0x0/0x2b2 returned 0 after 21 usecs
calling  initialize_hashrnd+0x0/0x1c @ 1
initcall initialize_hashrnd+0x0/0x1c returned 0 after 1 usecs
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
async_waiting @ 1
async_continuing @ 1 after 0 usec
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
async_waiting @ 1
async_continuing @ 1 after 0 usec
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs (vda1): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 253:1.
async_waiting @ 1
async_continuing @ 1 after 0 usec
Freeing unused kernel memory: 604k freed
udevd[1448]: starting version 171
calling  snd_mem_init+0x0/0x2f [snd_page_alloc] @ 1477
initcall snd_mem_init+0x0/0x2f [snd_page_alloc] returned 0 after 19 usecs
calling  alsa_sound_init+0x0/0x8a [snd] @ 1477
initcall alsa_sound_init+0x0/0x8a [snd] returned 0 after 145 usecs
calling  alsa_timer_init+0x0/0xb9 [snd_timer] @ 1477
initcall alsa_timer_init+0x0/0xb9 [snd_timer] returned 0 after 655 usecs
calling  alsa_pcm_init+0x0/0x67 [snd_pcm] @ 1477
initcall alsa_pcm_init+0x0/0x67 [snd_pcm] returned 0 after 22 usecs
calling  alsa_card_azx_init+0x0/0x22 [snd_hda_intel] @ 1477
snd_hda_intel 0000:00:04.0: irq 44 for MSI/MSI-X
snd_hda_intel 0000:00:04.0: setting latency timer to 64
initcall alsa_card_azx_init+0x0/0x22 [snd_hda_intel] returned 0 after 85462 usecs
EXT3-fs (vda1): using internal journal
Adding 2097148k swap on /dev/vdb.  Priority:-1 extents:1 across:2097148k 
