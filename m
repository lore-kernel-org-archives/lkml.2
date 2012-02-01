Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2BAXEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:04:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab2BAXEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:04:21 -0500
Date: Wed, 1 Feb 2012 18:04:14 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump, ioapic: Fix kdump race with migrating irq
Message-ID: <20120201230414.GL5650@redhat.com>
References: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
 <m1ipjr4jaa.fsf@fess.ebiederm.org>
 <20120131222751.GE5650@redhat.com>
 <m1vcnr33c8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vcnr33c8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 02:38:15PM -0800, Eric W. Biederman wrote:
> Don Zickus <dzickus@redhat.com> writes:
> 
> > On Tue, Jan 31, 2012 at 02:08:29PM -0800, Eric W. Biederman wrote:
> >> > The problem is that although kdump tries to shutdown minimal hardware,
> >> > it still needs to disable the IO APIC.  This requires spinlocks which
> >> > may be held by another cpu.  This other cpu is being held infinitely in
> >> > an NMI context by kdump in order to serialize the crashing path.  Instant
> >> > deadlock.
> >> 
> >> Can you test to see if kexec on panic still needs to disable the IO
> >> APIC.  Last I looked we were close if not all of the way there to not
> >> needing to boot the kernel in pic mode?
> >
> > Ok, so you just blindly remove disable_IO_APIC from
> > native_machine_crash_shutdown and re-run some panic tests on various
> > machines?  What about the disable_IO_APIC path in native_machine_shutdown?
> >
> 
> Yes.  Just native_machine_crash_shutdown.
> 
> native_machine_shutdown is the case when all is good and we attempt to
> put the hardware back the way we found it.

Ok.

> 
> Any normal x86 machine that the kernel runs in ioapic mode should be
> enough to get a first approximation.
> 
> > Also, where could I look to see if that work was done?  Is that in the
> > ioapic setup code?
> 
> The primary question is do we call the ioapic setup code without calling
> the pic setup code first.  On some embedded x86 platforms we certainly
> do.  I don't know if that code has been generalized.
> 
> Historically the problem is that we started the pit timer in pic mode
> and used that to calibrate the delay loop.
> 
> So what we are looking to verify is that the linux kernel boot skip
> pic mode entirely.

It seems to boot fine on an Ivy Bridge machine and a single cpu Pentium4.
I will try and athlon3 and a nehalem tomorrow.

Talking to folks here and trying to read the code it seems like the PIT
stuff is delayed until after the IOAPIC is configured using Fast TSC
calibration as a mechanism to work around the PIT??

I attached the output of the Pentium4 when kdumping.  Not sure what to
really look for to verify the PIC is being skipped.  Perhaps you know?

Cheers,
Don

DMI 2.3 present.
last_pfn = 0x20000 max_arch_pfn = 0x1000000
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
found SMP MP-table at [c00fe710] fe710
init_memory_mapping: 0000000000000000-0000000020000000
RAMDISK: 1fab5000 - 1ff5f000
ACPI: RSDP 000fd560 00014 (v00 DELL  )
ACPI: RSDT 000fd574 00034 (v01 DELL    GX240   00000008 ASL  00000061)
ACPI: FACP 000fd5a8 00074 (v01 DELL    GX240   00000008 ASL  00000061)
ACPI: DSDT fffe3c22 02393 (v01   DELL    dt_ex 00001000 MSFT 0100000D)
ACPI: FACS 3ff77000 00040
ACPI: SSDT fffe5fb5 000A7 (v01   DELL    st_ex 00001000 MSFT 0100000D)
ACPI: APIC 000fd61c 0005C (v01 DELL    GX240   00000008 ASL  00000061)
ACPI: BOOT 000fd678 00028 (v01 DELL    GX240   00000008 ASL  00000061)
0MB HIGHMEM available.
512MB LOWMEM available.
  mapped low ram: 0 - 20000000
  low ram: 0 - 20000000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x00020000
  HighMem  empty
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000010 -> 0x000000a0
    0: 0x00018000 -> 0x0001ff6a
    0: 0x0001ff6b -> 0x0001ff6f
    0: 0x0001ffff -> 0x00020000
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
2 Processors exceeds NR_CPUS limit of 1
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 0000000000100000 - 0000000018000000
PM: Registered nosave memory: 000000001ff6a000 - 000000001ff6b000
PM: Registered nosave memory: 000000001ff6f000 - 000000001ffff000
Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 13 pages/cpu @df400000 s32704 r0 d20544 u2097152
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 31743
Kernel command line: ro root=/dev/mapper/vg_dellgx24003-lv_root rd_NO_LUKS
LANG=en_US.UTF-8 rd_NO_MD KEYTABLE=us console=ttyS0,115200
rd_LVM_LV=vg_dellgx24003/lv_root rd_LVM_LV=vg_dellgx24003/lv_swap
SYSFONT=latarcyrheb-sun16 rd_NO_DM irqpoll nr_cpus=1 reset_devices
cgroup_disable=memory  memmap=exactmap memmap=64K$0K memmap=576K@64K
memmap=64K$960K memmap=130472K@393216K memmap=19K@523689K
memmap=4K@524284K memmap=8K#1048028K memmap=540K$1048036K
memmap=64K$4173824K memmap=64K$4175872K memmap=5120K$4189184K
elfcorehdr=523688K
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
Disabling memory control group subsystem
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (00000000:00000000)
Memory: 112876k/524288k available (4429k kernel code, 18192k reserved,
2305k data, 500k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffa96000 - 0xfffff000   (5540 kB)
    pkmap   : 0xff600000 - 0xff800000   (2048 kB)
    vmalloc : 0xe0800000 - 0xff5fe000   ( 493 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
      .init : 0xd8a94000 - 0xd8b11000   ( 500 kB)
      .data : 0xd8853712 - 0xd8a93d80   (2305 kB)
      .text : 0xd8400000 - 0xd8853712   (4429 kB)
Checking if this processor honours the WP bit even in supervisor
mode...Ok.
Hierarchical RCU implementation.
NR_IRQS:2304 nr_irqs:256 16
Spurious LAPIC timer interrupt on cpu 0
do_IRQ: 0.89 No irq handler for vector (irq -1)
Console: colour VGA+ 80x25
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 1694.460 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency..
3388.92 BogoMIPS (lpj=1694460)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
Mount-cache hash table entries: 512
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Initializing cgroup subsys perf_event
CPU0: Hyper-Threading is disabled
mce: CPU supports 4 MCE banks
SMP alternatives: switching to UP code
Freeing SMP alternatives: 20k freed
ACPI: Core revision 20120111
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Pentium(R) 4 CPU 1.70GHz stepping 02
Performance Events: Netburst events, Broken PMU hardware detected, using
software events only.
NMI watchdog disabled (cpu0): hardware events not enabled
Brought up 1 CPUs
Total of 1 processors activated (3388.92 BogoMIPS).
<snip>
