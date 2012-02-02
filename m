Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2BBRp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:45:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2BBRpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:45:53 -0500
Date: Thu, 2 Feb 2012 12:45:45 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump, ioapic: Fix kdump race with migrating irq
Message-ID: <20120202174545.GR5650@redhat.com>
References: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
 <m1ipjr4jaa.fsf@fess.ebiederm.org>
 <20120131222751.GE5650@redhat.com>
 <m1vcnr33c8.fsf@fess.ebiederm.org>
 <20120201230414.GL5650@redhat.com>
 <m1ehuevx12.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ehuevx12.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 05:34:01PM -0800, Eric W. Biederman wrote:
> > I attached the output of the Pentium4 when kdumping.  Not sure what to
> > really look for to verify the PIC is being skipped.  Perhaps you know?
> 
> The important part is the kexec on panic works without shutting down
> the ioapic.  There should be no corner case issues it should either
> work it should fail.
> 
> The problem used to be that we always would initialize the PIT interrupt
> in the 8259 interrupt controller before we would initialize the ioapics
> and that would kill the boot.

So I dug up an old athlon (family 0x6, model 0x2) which didn't have an
ioapic and kdump seem to work fine.

I'll repost the patch with just the one line removed and come up with some
sort of explaination for it.

Thanks,
Don

----
here is the boot log for that kdump kernel in case it is of interest..

[root@athlon3 ~]# SysRq : Trigger a crash
BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<c06873ef>] sysrq_handle_crash+0xf/0x20
*pdpt = 00000000326e6001 *pde = 0000000000000000
Oops: 0002 [#1] SMP
Modules linked in: sunrpc ipv6 ppdev floppy microcode pcspkr serio_raw
3c59x mii via686a i2c_viapro i2c_core sg parport_pc parport ext4 mbcache
jbd2 sr_mod cdrom sd_mod crc_t10dif pata_acpi ata_generic pata_via
dm_mirror dm_region_hash dm_log dm_mod [last unloaded: mperf]

Pid: 4748, comm: bash Not tainted 3.3.0-rc1nmi+ #1 System Manufacturer
System Name/<K7V-RM>
EIP: 0060:[<c06873ef>] EFLAGS: 00010086 CPU: 0
EIP is at sysrq_handle_crash+0xf/0x20
EAX: 00000063 EBX: 00000063 ECX: 00000000 EDX: 00000000
ESI: c0a6b760 EDI: 00000296 EBP: 00000000 ESP: f26dff24
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process bash (pid: 4748, ti=f26de000 task=f26665b0 task.ti=f26de000)
Stack:
 c0687a50 c098f07f c09e0b34 00000007 00000000 f26c8280 c0687ab0 fffffffb
 c0687aec 00000002 b77df000 f56f2920 c057334f f26dff9c 00000002 b77df000
 f26c8280 00000002 b77df000 c05732f0 c05274d0 f26dff9c f26671cc 00000000
Call Trace:
 [<c0687a50>] ? __handle_sysrq+0xf0/0x150
 [<c0687ab0>] ? __handle_sysrq+0x150/0x150
 [<c0687aec>] ? write_sysrq_trigger+0x3c/0x50
 [<c057334f>] ? proc_reg_write+0x5f/0x90
 [<c05732f0>] ? proc_reg_poll+0x80/0x80
 [<c05274d0>] ? vfs_write+0xa0/0x170
 [<c0527671>] ? sys_write+0x41/0x80
 [<c085241f>] ? sysenter_do_call+0x12/0x28
Code: a6 c0 01 0f b6 41 03 19 d2 f7 d2 83 e2 03 83 e0 8f c1 e2 04 09 d0 88
41 03 f3 c3 90 c7 05 10 76 b2 c0 01 00 00 00 f0 83 04 24 00 <c6> 05 00 00
00 00 01 c3 89 f6 8d bc 27 00 00 00 00 8d 50 d0 83
EIP: [<c06873ef>] sysrq_handle_crash+0xf/0x20 SS:ESP 0068:f26dff24
CR2: 0000000000000000
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 3.3.0-rc1nmi+ (dzickus@ihatethathostname.lab.bos.redhat.com)
(gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #1 SMP Wed Feb 1
17:22:40 EST 2012
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000005fffc000 (usable)
 BIOS-e820: 000000005fffc000 - 000000005ffff000 (ACPI data)
 BIOS-e820: 000000005ffff000 - 0000000060000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
last_pfn = 0x5fffc max_arch_pfn = 0x1000000
Notice: NX (Execute Disable) protection missing in CPU!
user-defined physical RAM map:
 user: 0000000000000000 - 0000000000010000 (reserved)
 user: 0000000000010000 - 00000000000a0000 (usable)
 user: 00000000000f0000 - 0000000000100000 (reserved)
 user: 0000000018000000 - 000000001ff6a000 (usable)
 user: 000000001ff6a400 - 000000001ff6f000 (usable)
 user: 000000001ffff000 - 0000000020000000 (usable)
 user: 000000005fffc000 - 0000000060000000 (ACPI data)
 user: 00000000ffff0000 - 0000000100000000 (reserved)
DMI 2.3 present.
last_pfn = 0x20000 max_arch_pfn = 0x1000000
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
init_memory_mapping: 0000000000000000-0000000020000000
RAMDISK: 1fb7e000 - 1ff5f000
crashkernel reservation failed - No suitable area found.
ACPI: RSDP 000f5c30 00014 (v00 ASUS  )
ACPI: RSDT 5fffc000 0002C (v01 ASUS   K7V-RM   30303031 MSFT 31313031)
ACPI: FACP 5fffc080 00074 (v01 ASUS   K7V-RM   30303031 MSFT 31313031)
ACPI: DSDT 5fffc100 0267F (v01   ASUS K7V-RM   00001000 MSFT 0100000B)
ACPI: FACS 5ffff000 00040
ACPI: BOOT 5fffc040 00028 (v01 ASUS   K7V-RM   30303031 MSFT 31313031)
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
ACPI: PM-Timer IO Port: 0xe408
SMP: Allowing 1 CPUs, 0 hotplug CPUs
Local APIC disabled by BIOS -- you can enable it with "lapic"
APIC: disable apic facility
APIC: switched to apic NOOP
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
PM: Registered nosave memory: 0000000000100000 - 0000000018000000
PM: Registered nosave memory: 000000001ff6a000 - 000000001ff6b000
PM: Registered nosave memory: 000000001ff6f000 - 000000001ffff000
Allocating PCI resources starting at 60000000 (gap: 60000000:9fff0000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:1 nr_node_ids:1
PERCPU: Embedded 13 pages/cpu @df400000 s32704 r0 d20544 u2097152
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 31743
Kernel command line: ro root=/dev/mapper/vg_athlon3-lv_root rd_NO_LUKS
LANG=en_US.UTF-8 rd_LVM_LV=vg_athlon3/lv_swap rd_NO_MD KEYTABLE=us
console=ttyS0,115200 rd_LVM_LV=vg_athlon3/lv_root
SYSFONT=latarcyrheb-sun16 rd_NO_DM crashkernel=128M irqpoll nr_cpus=1
reset_devices cgroup_disable=memory  memmap=exactmap memmap=64K$0K
memmap=576K@64K memmap=64K$960K memmap=130472K@393216K memmap=19K@523689K
memmap=4K@524284K memmap=12K#1572848K memmap=4K#1572860K
memmap=64K$4194240K elfcorehdr=523688K
Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance
Disabling memory control group subsystem
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (00000000:00000000)
Memory: 113684k/524288k available (4429k kernel code, 17384k reserved,
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
Console: colour VGA+ 80x25
console [ttyS0] enabled
Fast TSC calibration using PIT
Detected 700.010 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency..
1400.02 BogoMIPS (lpj=700010)
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
mce: CPU supports 4 MCE banks
SMP alternatives: switching to UP code
Freeing SMP alternatives: 20k freed
ACPI: Core revision 20120111
ACPI: setting ELCR to 0200 (from 0600)
weird, boot CPU (#0) not listed by the BIOS.
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
SMP disabled
Performance Events:
no APIC, boot with the "lapic" boot parameter to force-enable it.
no hardware sampling interrupt available.
AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
NMI watchdog disabled (cpu0): not supported (no LAPIC?)
Brought up 1 CPUs
Total of 1 processors activated (1400.02 BogoMIPS).
devtmpfs: initialized
print_constraints: dummy:
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf08c0, last bus=1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use
"pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
<snip>
