Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0LVPOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:14:41 -0500
Received: from virgo.iok.hu ([212.40.97.103]:52499 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab0LVPOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:14:38 -0500
Date: Wed, 22 Dec 2010 16:14:34 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>, shenghui <crosslonelyover@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in
 kernel/sched_fair.c
Message-ID: <20101222151434.GW10557@genesis.frugalware.org>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
 <1277808215.1868.5.camel@laptop>
 <20101219020313.GJ31750@genesis.frugalware.org>
 <20101222002248.GP10557@genesis.frugalware.org>
 <1293006589.2170.41.camel@laptop>
 <1293007311.11370.172.camel@marge.simson.net>
 <1293008842.2170.70.camel@laptop>
 <20101222133154.GS10557@genesis.frugalware.org>
 <1293026422.2170.136.camel@laptop>
 <1293027112.2170.140.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p6hDAtPN9q+ZnUca"
Content-Disposition: inline
In-Reply-To: <1293027112.2170.140.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p6hDAtPN9q+ZnUca
Content-Type: multipart/mixed; boundary="OwXh6gFRjCd3qPCM"
Content-Disposition: inline


--OwXh6gFRjCd3qPCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 22, 2010 at 03:11:52PM +0100, Peter Zijlstra <peterz@infradead.=
org> wrote:
> > I started it with something like:=20
> >  qemu -kernel foo-build/arch/x86/boot/bzImage -append "root=3D/dev/sda1
> > debug sched_debug ignore_loglevel sysrq_always_enabled console=3DttyS0"
> > -hda systemd.img -serial stdio -m 1G
> >=20
> > Where foo-build/ contains a kernel build using your .config.
> >=20
> > I'll have a poke at it..
>=20
> Hrm,. its not really wanting to start properly..
>=20
> ---
> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> Freeing unused kernel memory: 520k freed
> EXT4-fs (sda1): re-mounted. Opts: (null)
> md: stopping all md devices.
> Restarting system.
> machine restart
> ---
>=20
> Does it _require_ initrd like muck? Or are there some modules that need
> to get built-in in order for the thing to boot?

Nope.

> This is an utter lack of error reporting here, no idea what's wrong.

I tried to do something really similar to your commandline:

qemu -enable-kvm -kernel kernel-build/arch/x86/boot/bzImage -append "root=
=3D/dev/sda1 debug sched_debug ignore_loglevel sysrq_always_enabled console=
=3DttyS0" -hda systemd.img -serial stdio -m 1G -vnc :0

This boots up properly here, I can login using root/root from vnc.

qemu -enable-kvm -kernel kernel-build/arch/x86/boot/bzImage -append "root=
=3D/dev/sda1 debug sched_debug ignore_loglevel sysrq_always_enabled console=
=3DttyS0 init=3D/bin/systemd" -hda systemd.img -serial stdio -m 1G -vnc :0

^ Only init=3D/bin/systemd added, and this results in a panic in most
cases. I'm attaching the stdout of qemu, showing the fail in
put_prev_task_fair.

$ qemu -version
QEMU emulator version 0.13.0, Copyright (c) 2003-2008 Fabrice Bellard

kernel-build is a git build using the config I already sent and after a
'git checkout v2.6.36'. I can try to build master as well, so far what I
saw is that the bug occurs there as well, but less frequently, so maybe
that's a bit harder to debug.

I also want to note that - at least on my machine - if I drop
-enable-kvm the bug is hard to reproduce, maybe that's because that way
it does not trigger a race condition or my machine is just too slow
without kvm and it triggers some timeout, changing the behaviour; I'm
not exactly sure.  (But again, I can reproduce the bug on real hardware,
so I don't think we have a kvm bug here.)

Thanks,

Miklos

--OwXh6gFRjCd3qPCM
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="qemu.log"
Content-Transfer-Encoding: quoted-printable

Initializing cgroup subsys cpuset=0D
Initializing cgroup subsys cpu=0D
Linux version 2.6.36 (vmiklos@helicon) (gcc version 4.5.2 (Frugalware Linux=
) ) #1 SMP PREEMPT Wed Dec 22 15:37:51 CET 2010=0D
BIOS-provided physical RAM map:=0D
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)=0D
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)=0D
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)=0D
 BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)=0D
 BIOS-e820: 000000003fffd000 - 0000000040000000 (reserved)=0D
 BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)=0D
debug: ignoring loglevel setting.=0D
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!=
=0D
DMI 2.4 present.=0D
e820 update range: 0000000000000000 - 0000000000001000 (usable) =3D=3D> (re=
served)=0D
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)=0D
last_pfn =3D 0x3fffd max_arch_pfn =3D 0x100000=0D
e820 update range: 0000000000002000 - 0000000000010000 (usable) =3D=3D> (re=
served)=0D
Scanning 1 areas for low memory corruption=0D
modified physical RAM map:=0D
 modified: 0000000000000000 - 0000000000001000 (reserved)=0D
 modified: 0000000000001000 - 0000000000002000 (usable)=0D
 modified: 0000000000002000 - 0000000000010000 (reserved)=0D
 modified: 0000000000010000 - 000000000009f400 (usable)=0D
 modified: 000000000009f400 - 00000000000a0000 (reserved)=0D
 modified: 00000000000f0000 - 0000000000100000 (reserved)=0D
 modified: 0000000000100000 - 000000003fffd000 (usable)=0D
 modified: 000000003fffd000 - 0000000040000000 (reserved)=0D
 modified: 00000000fffbc000 - 0000000100000000 (reserved)=0D
initial memory mapped : 0 - 01c00000=0D
found SMP MP-table at [c00fdc00] fdc00=0D
init_memory_mapping: 0000000000000000-00000000377fe000=0D
 0000000000 - 0000400000 page 4k=0D
 0000400000 - 0037400000 page 2M=0D
 0037400000 - 00377fe000 page 4k=0D
kernel direct mapping tables up to 377fe000 @ 15000-1a000=0D
ACPI: RSDP 000fdbb0 00014 (v00 BOCHS )=0D
ACPI: RSDT 3fffde30 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)=0D
ACPI: FACP 3ffffe70 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)=0D
ACPI: DSDT 3fffdfd0 01E22 (v01   BXPC   BXDSDT 00000001 INTL 20090123)=0D
ACPI: FACS 3ffffe00 00040=0D
ACPI: SSDT 3fffdf90 00037 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)=0D
ACPI: APIC 3fffdeb0 00072 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)=0D
ACPI: HPET 3fffde70 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)=0D
ACPI: Local APIC address 0xfee00000=0D
135MB HIGHMEM available.=0D
887MB LOWMEM available.=0D
  mapped low ram: 0 - 377fe000=0D
  low ram: 0 - 377fe000=0D
kvm-clock: Using msrs 12 and 11=0D
kvm-clock: cpu 0, msr 0:17b2b91, boot clock=0D
Zone PFN ranges:=0D
  DMA      0x00000001 -> 0x00001000=0D
  Normal   0x00001000 -> 0x000377fe=0D
  HighMem  0x000377fe -> 0x0003fffd=0D
Movable zone start PFN for each node=0D
early_node_map[3] active PFN ranges=0D
    0: 0x00000001 -> 0x00000002=0D
    0: 0x00000010 -> 0x0000009f=0D
    0: 0x00000100 -> 0x0003fffd=0D
On node 0 totalpages: 262029=0D
free_area_init_node: node 0, pgdat c1725620, node_mem_map c1848020=0D
  DMA zone: 32 pages used for memmap=0D
  DMA zone: 0 pages reserved=0D
  DMA zone: 3952 pages, LIFO batch:0=0D
  Normal zone: 1744 pages used for memmap=0D
  Normal zone: 221486 pages, LIFO batch:31=0D
  HighMem zone: 272 pages used for memmap=0D
  HighMem zone: 34543 pages, LIFO batch:7=0D
Using APIC driver default=0D
ACPI: PM-Timer IO Port: 0xb008=0D
ACPI: Local APIC address 0xfee00000=0D
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)=0D
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])=0D
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)=0D
ACPI: IRQ0 used by override.=0D
ACPI: IRQ2 used by override.=0D
ACPI: IRQ5 used by override.=0D
ACPI: IRQ9 used by override.=0D
ACPI: IRQ10 used by override.=0D
ACPI: IRQ11 used by override.=0D
Using ACPI (MADT) for SMP configuration information=0D
ACPI: HPET id: 0x8086a201 base: 0xfed00000=0D
SMP: Allowing 1 CPUs, 0 hotplug CPUs=0D
nr_irqs_gsi: 40=0D
PM: Registered nosave memory: 0000000000002000 - 0000000000010000=0D
early_res array is doubled to 64 at [16000 - 167ff]=0D
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000=0D
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000=0D
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000=0D
Allocating PCI resources starting at 40000000 (gap: 40000000:bffbc000)=0D
Booting paravirtualized kernel on KVM=0D
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1=0D
PERCPU: Embedded 14 pages/cpu @c2400000 s33296 r0 d24048 u4194304=0D
pcpu-alloc: s33296 r0 d24048 u4194304 alloc=3D1*4194304=0D
pcpu-alloc: [0] 0 =0D
kvm-clock: cpu 0, msr 0:2407b91, primary cpu clock=0D
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259981=
=0D
Kernel command line: root=3D/dev/sda1 debug sched_debug ignore_loglevel sys=
rq_always_enabled console=3DttyS0 init=3D/bin/systemd=0D
PID hash table entries: 4096 (order: 2, 16384 bytes)=0D
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)=0D
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)=0D
Enabling fast FPU save and restore... done.=0D
Enabling unmasked SIMD FPU exception support... done.=0D
Initializing CPU#0=0D
allocated 5242800 bytes of page_cgroup=0D
please try 'cgroup_disable=3Dmemory' option if you don't want memory cgroup=
s=0D
Subtract (43 early reservations)=0D
  #1 [0000001000 - 0000002000]   EX TRAMPOLINE=0D
  #2 [0001000000 - 000183e7c4]   TEXT DATA BSS=0D
  #3 [000183f000 - 0001846049]             BRK=0D
  #4 [000009f400 - 00000fdc00]   BIOS reserved=0D
  #5 [00000fdc00 - 00000fdc10]    MP-table mpf=0D
  #6 [00000fdcf0 - 0000100000]   BIOS reserved=0D
  #7 [00000fdc10 - 00000fdcf0]    MP-table mpc=0D
  #8 [0000010000 - 0000011000]      TRAMPOLINE=0D
  #9 [0000011000 - 0000015000]     ACPI WAKEUP=0D
  #10 [0000015000 - 0000016000]         PGTABLE=0D
  #11 [0001847000 - 0001848000]         BOOTMEM=0D
  #12 [0001848000 - 0002048000]         BOOTMEM=0D
  #13 [000183e7d0 - 000183e7d4]         BOOTMEM=0D
  #14 [000183e7e0 - 000183e8a0]         BOOTMEM=0D
  #15 [000183e8a0 - 000183e8f4]         BOOTMEM=0D
  #16 [0002048000 - 000204b000]         BOOTMEM=0D
  #17 [000183e900 - 000183e910]         BOOTMEM=0D
  #18 [0001846050 - 0001846c50]         BOOTMEM=0D
  #19 [000183e910 - 000183e935]         BOOTMEM=0D
  #20 [000183e940 - 000183e967]         BOOTMEM=0D
  #21 [000183e970 - 000183ea6c]         BOOTMEM=0D
  #22 [000183ea70 - 000183eab0]         BOOTMEM=0D
  #23 [000183eab0 - 000183eaf0]         BOOTMEM=0D
  #24 [000183eaf0 - 000183eb30]         BOOTMEM=0D
  #25 [000183eb30 - 000183eb70]         BOOTMEM=0D
  #26 [000183eb70 - 000183ebb0]         BOOTMEM=0D
  #27 [000183ebb0 - 000183ebf0]         BOOTMEM=0D
  #28 [000183ebf0 - 000183ec00]         BOOTMEM=0D
  #29 [000183ec00 - 000183ec10]         BOOTMEM=0D
  #30 [000183ec10 - 000183ec76]         BOOTMEM=0D
  #31 [000183ec80 - 000183ece6]         BOOTMEM=0D
  #32 [0002400000 - 000240e000]         BOOTMEM=0D
  #33 [000183ecf0 - 000183ecf4]         BOOTMEM=0D
  #34 [000183ed00 - 000183ed04]         BOOTMEM=0D
  #35 [000183ed10 - 000183ed14]         BOOTMEM=0D
  #36 [000183ed20 - 000183ed24]         BOOTMEM=0D
  #37 [000183ed30 - 000183ede0]         BOOTMEM=0D
  #38 [000183ede0 - 000183ee88]         BOOTMEM=0D
  #39 [000204b000 - 000204f000]         BOOTMEM=0D
  #40 [000204f000 - 00020cf000]         BOOTMEM=0D
  #41 [00020cf000 - 000210f000]         BOOTMEM=0D
  #42 [000240e000 - 000290dfb0]         BOOTMEM=0D
Initializing HighMem for node 0 (000377fe:0003fffd)=0D
Memory: 1025444k/1048564k available (5423k kernel code, 22672k reserved, 19=
60k data, 504k init, 139260k highmem)=0D
virtual kernel memory layout:=0D
    fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)=0D
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)=0D
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)=0D
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)=0D
      .init : 0xc1736000 - 0xc17b4000   ( 504 kB)=0D
      .data : 0xc154bd93 - 0xc1735dcc   (1960 kB)=0D
      .text : 0xc1000000 - 0xc154bd93   (5423 kB)=0D
Checking if this processor honours the WP bit even in supervisor mode...Ok.=
=0D
SLUB: Genslabs=3D13, HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1=0D
Hierarchical RCU implementation.=0D
	RCU-based detection of stalled CPUs is disabled.=0D
	Verbose stalled-CPUs detection is disabled.=0D
NR_IRQS:2304 nr_irqs:256=0D
Console: colour VGA+ 80x25=0D
console [ttyS0] enabled=0D
hpet clockevent registered=0D
Detected 2665.754 MHz processor.=0D
Calibrating delay loop (skipped) preset value.. 5331.50 BogoMIPS (lpj=3D266=
5754)=0D
pid_max: default: 32768 minimum: 301=0D
Security Framework initialized=0D
AppArmor: AppArmor disabled by boot time parameter=0D
Mount-cache hash table entries: 512=0D
Initializing cgroup subsys ns=0D
Initializing cgroup subsys cpuacct=0D
Initializing cgroup subsys memory=0D
Initializing cgroup subsys devices=0D
Initializing cgroup subsys freezer=0D
Performance Events: p6 PMU driver.=0D
=2E.. version:                0=0D
=2E.. bit width:              32=0D
=2E.. generic registers:      2=0D
=2E.. value mask:             00000000ffffffff=0D
=2E.. max period:             000000007fffffff=0D
=2E.. fixed-purpose events:   0=0D
=2E.. event mask:             0000000000000003=0D
SMP alternatives: switching to UP code=0D
Freeing SMP alternatives: 24k freed=0D
ACPI: Core revision 20100702=0D
Enabling APIC mode:  Flat.  Using 1 I/O APICs=0D
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1=0D
CPU0: Intel QEMU Virtual CPU version 0.13.0 stepping 03=0D
Brought up 1 CPUs=0D
Total of 1 processors activated (5331.50 BogoMIPS).=0D
devtmpfs: initialized=0D
xor: automatically using best checksumming function: pIII_sse=0D
   pIII_sse  :  7564.000 MB/sec=0D
xor: using function: pIII_sse (7564.000 MB/sec)=0D
regulator: core version 0.5=0D
NET: Registered protocol family 16=0D
EISA bus registered=0D
ACPI: bus type pci registered=0D
PCI: Using configuration type 1 for base access=0D
bio: create slab <bio-0> at 0=0D
raid6: int32x1    941 MB/s=0D
raid6: int32x2    878 MB/s=0D
raid6: int32x4    757 MB/s=0D
raid6: int32x8    644 MB/s=0D
raid6: mmxx1     3105 MB/s=0D
raid6: mmxx2     3484 MB/s=0D
raid6: sse1x1    1964 MB/s=0D
raid6: sse1x2    2550 MB/s=0D
raid6: sse2x1    3566 MB/s=0D
raid6: sse2x2    4328 MB/s=0D
raid6: using algorithm sse2x2 (4328 MB/s)=0D
ACPI: EC: Look up EC in DSDT=0D
ACPI: Interpreter enabled=0D
ACPI: (supports S0 S3 S4 S5)=0D
ACPI: Using IOAPIC for interrupt routing=0D
ACPI: No dock devices found.=0D
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=3Duse_c=
rs" and report a bug=0D
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])=0D
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)=0D
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)=0D
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignore=
d)=0D
pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignore=
d)=0D
pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]=0D
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI=0D
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB=0D
pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]=0D
pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]=0D
pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]=0D
pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]=0D
pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]=0D
pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf205ffff pref]=0D
pci_bus 0000:00: on NUMA node 0=0D
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]=0D
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)=0D
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)=0D
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)=0D
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)=0D
vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone=0D
vgaarb: loaded=0D
SCSI subsystem initialized=0D
libata version 3.00 loaded.=0D
usbcore: registered new interface driver usbfs=0D
usbcore: registered new interface driver hub=0D
usbcore: registered new device driver usb=0D
PCI: Using ACPI for IRQ routing=0D
PCI: pci_cache_line_size set to 32 bytes=0D
reserve RAM buffer: 0000000000002000 - 000000000000ffff =0D
reserve RAM buffer: 000000000009f400 - 000000000009ffff =0D
reserve RAM buffer: 000000003fffd000 - 000000003fffffff =0D
NetLabel: Initializing=0D
NetLabel:  domain hash size =3D 128=0D
NetLabel:  protocols =3D UNLABELED CIPSOv4=0D
NetLabel:  unlabeled traffic allowed by default=0D
HPET: 3 timers in total, 0 timers will be used for per-cpu timer=0D
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0=0D
hpet0: 3 comparators, 64-bit 100.000000 MHz counter=0D
Switching to clocksource kvm-clock=0D
pnp: PnP ACPI init=0D
ACPI: bus type pnp registered=0D
pnp: PnP ACPI: found 8 devices=0D
ACPI: ACPI bus type pnp unregistered=0D
PnPBIOS: Disabled=0D
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]=0D
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]=0D
NET: Registered protocol family 2=0D
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)=0D
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)=0D
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)=0D
TCP: Hash tables configured (established 131072 bind 65536)=0D
TCP reno registered=0D
UDP hash table entries: 512 (order: 2, 16384 bytes)=0D
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)=0D
NET: Registered protocol family 1=0D
pci 0000:00:00.0: Limiting direct PCI/PCI transfers=0D
pci 0000:00:01.0: PIIX3: Enabling Passive Release=0D
pci 0000:00:01.0: Activating ISA DMA hang workarounds=0D
pci 0000:00:02.0: Boot video device=0D
PCI: CLS 0 bytes, default 32=0D
Scanning for low memory corruption every 60 seconds=0D
audit: initializing netlink socket (disabled)=0D
type=3D2000 audit(1293030098.505:1): initialized=0D
highmem bounce pool size: 64 pages=0D
VFS: Disk quotas dquot_6.5.2=0D
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=0D
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers=
, no debug enabled=0D
SGI XFS Quota Management subsystem=0D
msgmni has been set to 1730=0D
async_tx: api initialized (async)=0D
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)=0D
io scheduler noop registered=0D
io scheduler deadline registered=0D
io scheduler cfq registered (default)=0D
pci_hotplug: PCI Hot Plug PCI Core version: 0.5=0D
isapnp: Scanning for PnP cards...=0D
isapnp: No Plug & Play device found=0D
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled=0D
=FFserial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A=0D
FDC 0 is a S82078B=0D
brd: module loaded=0D
Compaq SMART2 Driver (v 2.6.0)=0D
HP CISS Driver (v 3.6.26)=0D
Uniform Multi-Platform E-IDE driver=0D
ide-gd driver 1.18=0D
ide-cd driver 5.00=0D
stex: Promise SuperTrak EX Driver version: 4.6.0000.4=0D
ata_piix 0000:00:01.1: version 2.13=0D
ata_piix 0000:00:01.1: setting latency timer to 64=0D
scsi0 : ata_piix=0D
scsi1 : ata_piix=0D
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14=0D
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15=0D
Fusion MPT base driver 3.04.17=0D
Copyright (c) 1999-2008 LSI Corporation=0D
Fusion MPT SPI Host driver 3.04.17=0D
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=0D
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver=0D
uhci_hcd: USB Universal Host Controller Interface driver=0D
Initializing USB Mass Storage driver...=0D
usbcore: registered new interface driver usb-storage=0D
USB Mass Storage support registered.=0D
usbcore: registered new interface driver ums-alauda=0D
usbcore: registered new interface driver ums-cypress=0D
usbcore: registered new interface driver ums-datafab=0D
usbcore: registered new interface driver ums-freecom=0D
usbcore: registered new interface driver ums-isd200=0D
usbcore: registered new interface driver ums-jumpshot=0D
usbcore: registered new interface driver ums-karma=0D
usbcore: registered new interface driver ums-onetouch=0D
usbcore: registered new interface driver ums-sddr09=0D
usbcore: registered new interface driver ums-sddr55=0D
usbcore: registered new interface driver ums-usbat=0D
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12=0D
serio: i8042 KBD port at 0x60,0x64 irq 1=0D
serio: i8042 AUX port at 0x60,0x64 irq 12=0D
mice: PS/2 mouse device common for all mice=0D
md: linear personality registered for level -1=0D
md: raid0 personality registered for level 0=0D
md: raid1 personality registered for level 1=0D
md: raid10 personality registered for level 10=0D
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input0=0D
md: raid6 personality registered for level 6=0D
md: raid5 personality registered for level 5=0D
md: raid4 personality registered for level 4=0D
EISA: Probing bus 0 at eisa.0=0D
EISA: Detected 0 cards.=0D
cpuidle: using governor ladder=0D
cpuidle: using governor menu=0D
usbcore: registered new interface driver hiddev=0D
usbcore: registered new interface driver usbhid=0D
usbhid: USB HID core driver=0D
TCP bic registered=0D
Initializing XFRM netlink socket=0D
NET: Registered protocol family 17=0D
Registering the dns_resolver key type=0D
Using IPI No-Shortcut mode=0D
registered taskstats version 1=0D
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)=0D
ata1.01: NODEV after polling detection=0D
ata2.01: NODEV after polling detection=0D
ata2.00: ATAPI: QEMU DVD-ROM, 0.13.0, max UDMA/100=0D
ata1.00: ATA-7: QEMU HARDDISK, 0.13.0, max UDMA/100=0D
ata1.00: 16777216 sectors, multi 16: LBA48 =0D
ata2.00: configured for MWDMA2=0D
ata1.00: configured for MWDMA2=0D
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.13 PQ: 0 ANSI: =
5=0D
sd 0:0:0:0: [sda] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)=0D
sd 0:0:0:0: [sda] Write Protect is off=0D
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00=0D
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't suppo=
rt DPO or FUA=0D
scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     0.13 PQ: 0 ANSI: =
5=0D
 sda: sda1=0D
sr0: scsi3-mmc drive: 4x/4x xa/form2 tray=0D
cdrom: Uniform CD-ROM driver Revision: 3.20=0D
sd 0:0:0:0: [sda] Attached SCSI disk=0D
sr 1:0:0:0: Attached scsi CD-ROM sr0=0D
md: Waiting for all devices to be available before autodetect=0D
md: If you don't use raid, use raid=3Dnoautodetect=0D
md: Autodetecting RAID arrays.=0D
md: Scanned 0 and added 0 devices.=0D
md: autorun ...=0D
md: ... autorun DONE.=0D
EXT3-fs (sda1): error: couldn't mount because of unsupported optional featu=
res (240)=0D
EXT2-fs (sda1): error: couldn't mount because of unsupported optional featu=
res (244)=0D
EXT4-fs (sda1): INFO: recovery required on readonly filesystem=0D
EXT4-fs (sda1): write access will be enabled during recovery=0D
EXT4-fs (sda1): recovery complete=0D
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)=0D
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.=0D
devtmpfs: mounted=0D
Freeing unused kernel memory: 504k freed=0D
systemd[1]: systemd 15 running in system mode. (+PAM -LIBWRAP -AUDIT -SELIN=
UX +SYSVINIT -LIBCRYPTSETUP; frugalware)=0D
Welcome to =1B[1;36mFrugalware 1.4pre2 (Nexon)=1B[0m!=0D
systemd[1]: /sbin/modprobe failed with error code 1.=0D
systemd[1]: Set hostname to <frugalware>.=0D
systemd[1]: /etc/mtab is not a symlink or not pointing to /proc/self/mounts=
=2E This is not supported anymore. Please make sure to replace this file by=
 a symlink to avoid incorrect or misleading mount(8) output.=0D
Starting LSB: Clean /tmp, /var/run and /var/lock....=0D
Starting Apply Kernel Variables...=0D
Starting Load Kernel Modules...=0D
systemd[1]: Failed to open /dev/autofs: No such file or directory=0D
systemd[1]: Failed to initialize automounter: No such file or directory=0D
systemd[1]: Unit sys-kernel-debug.automount entered failed state.=0D
systemd[1]: Failed to open /dev/autofs: No such file or directory=0D
systemd[1]: Failed to initialize automounter: No such file or directory=0D
systemd[1]: Unit proc-sys-fs-binfmt_misc.automount entered failed state.=0D
systemd[1]: Failed to open /dev/autofs: No such file or directory=0D
systemd[1]: Failed to initialize automounter: No such file or directory=0D
systemd[1]: Unit sys-kernel-security.automount entered failed state.=0D
systemd[1]: Failed to open /dev/autofs: No such file or directory=0D
systemd[1]: Failed to initialize automounter: No such file or directory=0D
systemd[1]: Unit dev-mqueue.automount entered failed state.=0D
Starting Setup Virtual Console...=0D
Starting Apply System Clock UTC Offset...=0D
Starting Remount API VFS...=0D
Starting File System Check on Root Device...=0D
systemd[1]: systemd-modules-load.service: main process exited, code=3Dexite=
d, status=3D1=0D
Starting Load Kernel Modules =1B[1;31mfailed=1B[0m.=0D
systemd[1]: Unit systemd-modules-load.service entered failed state.=0D
Starting systemd Syslog Kernel Log Buffer Bridge...=0D
Starting Logging Daemon...=0D
modprobe[1210]: FATAL: Could not load /lib/modules/2.6.36/modules.dep: No s=
uch file or directory=0D
Starting udev Kernel Device Manager...=0D
systemd-fsck[1216]: /dev/sda1: Superblock last mount time is in the future.=
=0D
systemd-fsck[1216]: (by less than a day, probably due to the hardware clock=
 being incorrectly set)  FIXED.=0D
systemd-fsck[1216]: /dev/sda1: Superblock last write time is in the future.=
=0D
systemd-fsck[1216]: (by less than a day, probably due to the hardware clock=
 being incorrectly set).  FIXED.=0D
systemd-fsck[1216]: /dev/sda1: clean, 45976/524288 files, 265205/2096474 bl=
ocks (check after next mount)=0D
Starting Remount Root FS...=0D
EXT4-fs (sda1): re-mounted. Opts: (null)=0D
Starting Load Random Seed...=0D
Starting Recreate Volatile Files and Directories...=0D
udev[1228]: starting version 165=0D
BUG: unable to handle kernel NULL pointer dereference at 00000008=0D
IP: [<c1296fc0>] rb_insert_color+0x20/0x110=0D
*pde =3D 00000000 =0D
Oops: 0000 [#1] PREEMPT SMP =0D
last sysfs file: /sys/bus/eisa/uevent=0D
Modules linked in:=0D
=0D
Pid: 1239, comm: find Not tainted 2.6.36 #1 /Bochs=0D
EIP: 0060:[<c1296fc0>] EFLAGS: 00010046 CPU: 0=0D
EIP is at rb_insert_color+0x20/0x110=0D
EAX: 00000000 EBX: 00000000 ECX: f68a71e8 EDX: f6874b5c=0D
ESI: f68a71e8 EDI: 00000000 EBP: f6874c68 ESP: f6903ba8=0D
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068=0D
Process find (pid: 1239, ti=3Df6902000 task=3Df71329e0 task.ti=3Df6902000)=
=0D
Stack:=0D
 f6874b5c f6874c60 0cc35d16 00000000 00000000 c10348fc f68a71ec ffee2cc1=0D
<0> ffffffff f6874b40 f6874b5c f7132b8c c2407bc0 f7169400 f71329e0 c1548162=
=0D
<0> f7169400 00000046 00000046 00000000 c1041ec4 c17b2bc0 00000000 f68e6dc0=
=0D
Call Trace:=0D
 [<c10348fc>] ? put_prev_task_fair+0xdc/0x120=0D
 [<c1548162>] ? schedule+0x102/0x8c0=0D
 [<c1041ec4>] ? irq_exit+0x34/0x80=0D
 [<c13b007b>] ? ata_link_init+0x9b/0xb0=0D
 [<c1548a5d>] ? preempt_schedule+0x2d/0x50=0D
 [<c137778a>] ? scsi_dispatch_cmd+0x15a/0x300=0D
 [<c137df8f>] ? scsi_request_fn+0x37f/0x480=0D
 [<c128ff6c>] ? cfq_insert_request+0x35c/0x570=0D
 [<c1282d82>] ? __blk_run_queue+0x52/0x140=0D
 [<c127ddaf>] ? elv_insert+0xbf/0x210=0D
 [<c1283a7a>] ? __make_request+0x10a/0x520=0D
 [<c1115c6c>] ? bio_add_page+0x2c/0x40=0D
 [<c111b2ee>] ? do_mpage_readpage+0x3ae/0x700=0D
 [<c1281c37>] ? generic_make_request+0x217/0x530=0D
 [<c10e9456>] ? mem_cgroup_charge_common+0x46/0x60=0D
 [<c1281fa6>] ? submit_bio+0x56/0xb0=0D
 [<c111b75a>] ? mpage_readpages+0xba/0x100=0D
 [<c111a528>] ? mpage_bio_submit+0x18/0x20=0D
 [<c111b784>] ? mpage_readpages+0xe4/0x100=0D
 [<c1198050>] ? ext4_readpages+0x0/0x20=0D
 [<c10b9849>] ? __do_page_cache_readahead+0x179/0x260=0D
 [<c119bfa0>] ? ext4_get_block+0x0/0x20=0D
 [<c10b9bd6>] ? ra_submit+0x16/0x20=0D
 [<c10b9f15>] ? page_cache_async_readahead+0x65/0xa0=0D
 [<c10b1d02>] ? filemap_fault+0x262/0x3e0=0D
 [<c10c8862>] ? __do_fault+0x42/0x5c0=0D
 [<c10cc1e7>] ? handle_mm_fault+0x1b7/0xc10=0D
 [<c10ce827>] ? remove_vma+0x37/0x50=0D
 [<c10269ee>] ? do_page_fault+0x14e/0x3c0=0D
 [<c10eb97b>] ? filp_close+0x3b/0x70=0D
 [<c10eba0f>] ? sys_close+0x5f/0xb0=0D
 [<c10268a0>] ? do_page_fault+0x0/0x3c0=0D
 [<c154b29a>] ? error_code+0x5a/0x60=0D
 [<c10268a0>] ? do_page_fault+0x0/0x3c0=0D
Code: 83 e2 03 09 ca 89 10 5b 5e 5f c3 55 57 56 53 83 ec 04 89 c5 89 14 24 =
8b 30 66 90 83 e6 fc 74 3b 8b 06 a8 01 75 35 89 c3 83 e3 fc <8b> 7b 08 39 f=
7 74 59 85 ff 74 35 8b 17 f6 c2 01 75 2e 83 ca 01 =0D
EIP: [<c1296fc0>] rb_insert_color+0x20/0x110 SS:ESP 0068:f6903ba8=0D
CR2: 0000000000000008=0D
---[ end trace a7ee9d6edc552fbb ]---=0D
note: find[1239] exited with preempt_count 268435458=0D

--OwXh6gFRjCd3qPCM--

--p6hDAtPN9q+ZnUca
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0SFdoACgkQe81tAgORUJZsIwCgitXwJYTCQOxui+YsX/ySdSQA
FIsAn3HBKK8rVAVPopGI9HveqDcsibPC
=J+q1
-----END PGP SIGNATURE-----

--p6hDAtPN9q+ZnUca--
