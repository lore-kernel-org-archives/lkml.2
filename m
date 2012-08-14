Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2HNRVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:21:45 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52305 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab2HNRVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:21:40 -0400
Date: Tue, 14 Aug 2012 20:26:50 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Aaron Lu <ziqian.lu@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Holger Macht <holger@homac.de>, Lin Ming <minggr@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: bisected regression: v3.6-rc1: resume from s2ram does not
 restore ata_piix (v3.5 worked)
Message-ID: <20120814202650.01b056ce@sf>
In-Reply-To: <20120814144804.GA23416@localhost.localdomain>
References: <CA2E3DE2DD06CA4FA11644750E4E292F102ACD65@SHSMSX102.ccr.corp.intel.com>
	<20120814080952.GA4981@localhost.localdomain>
	<20120814114420.2e844ea1@sf>
	<20120814144804.GA23416@localhost.localdomain>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.=k25nnQ8GvzNr/J6GNKydz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.=k25nnQ8GvzNr/J6GNKydz
Content-Type: multipart/mixed; boundary="MP_/ZKHVzYwN=ZwGqff+kpxsXBO"

--MP_/ZKHVzYwN=ZwGqff+kpxsXBO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 14 Aug 2012 22:48:08 +0800
Aaron Lu <aaron.lwe@gmail.com> wrote:

> On Tue, Aug 14, 2012 at 11:44:20AM +0300, Sergei Trofimovich wrote:
> > > The only problem I can see is the offending commit didn't do a gtm for
> > > IDE channel during init. It was used to be done in
> > > ata_acpi_associate_ide_port.
> > >=20
> > > So can you please test if the following code fix your problem? Thanks.
> >=20
> > Unfortunately, nothing changed. The same hangup after resume.
> > Did the bisected patch change the way kernel relies on ACPI
> > information? I have some complains in dmesg output about it
> > (attached whole dmesg) like that:
> >=20
> > ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000004) is bey=
ond end of object (20120711/exoparg2-418)
> > ACPI Error: Method parse/execution failed [\_SB_.C003.C09A._DOD] (Node =
ffff88007b82c988), AE_AML_PACKAGE_LIMIT (20120711/psparse-536)
> > ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD (20120711/video-1=
149)
>=20
>=20
> And here is another try:

This one did the trick! Survived suspend/resume cycle.
Whole dmesg is attached.

> > ata1: ACPI get timing mode failed (AE 0x1001)
> Do you see this error message when using a working kernel?

Now with patched kernel I see

    ata1: ACPI set timing mode failed (status=3D0x300b)

after resume. No 'get timing' errors. Attached dmesg
with suspend/resume log.

I can boot to older unpatched kernels right before and after
offending commit and send you dmesg diff if you still need/like
to look at it.

Thanks for the fix!

>=20
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 902b5a4..fd9ecf7 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -60,17 +60,7 @@ acpi_handle ata_ap_acpi_handle(struct ata_port *ap)
>  	if (ap->flags & ATA_FLAG_ACPI_SATA)
>  		return NULL;
> =20
> -	/*
> -	 * If acpi bind operation has already happened, we can get the handle
> -	 * for the port by checking the corresponding scsi_host device's
> -	 * firmware node, otherwise we will need to find out the handle from
> -	 * its parent's acpi node.
> -	 */
> -	if (ap->scsi_host)
> -		return DEVICE_ACPI_HANDLE(&ap->scsi_host->shost_gendev);
> -	else
> -		return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev),
> -				ap->port_no);
> +	return acpi_get_child(DEVICE_ACPI_HANDLE(ap->host->dev), ap->port_no);
>  }
>  EXPORT_SYMBOL(ata_ap_acpi_handle);
> =20
> @@ -1101,6 +1091,9 @@ static int ata_acpi_bind_host(struct ata_port *ap, =
acpi_handle *handle)
>  	if (!*handle)
>  		return -ENODEV;
> =20
> +	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) =3D=3D 0)
> +		ap->pflags |=3D ATA_PFLAG_INIT_GTM_VALID;
> +
>  	return 0;
>  }
>=20
> Thanks,
> Aaron


--=20

  Sergei

--MP_/ZKHVzYwN=ZwGqff+kpxsXBO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=dmesg.txt

Initializing cgroup subsys cpu
Linux version 3.6.0-rc1-00312-g3bf671a-dirty (slyfox@sf) (gcc version 4.7.1=
 (Gentoo 4.7.1 p1.0, pie-0.5.3) ) #259 SMP PREEMPT Tue Aug 14 20:03:30 FET =
2012
Command line: BOOT_IMAGE=3D/boot/vmlinuz root=3D/dev/sda2 ro video=3DSVIDEO=
-1:d i915.i915_enable_rc6=3D1 init=3D/sbin/bootchartd
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000007e7affff] usable
BIOS-e820: [mem 0x000000007e7b0000-0x000000007e7c53ff] reserved
BIOS-e820: [mem 0x000000007e7c5400-0x000000007e7e7fb7] ACPI NVS
BIOS-e820: [mem 0x000000007e7e7fb8-0x000000007effffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
BIOS-e820: [mem 0x00000000fed20000-0x00000000fed99fff] reserved
BIOS-e820: [mem 0x00000000feda0000-0x00000000fedbffff] reserved
BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffbfffff] reserved
BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Hewlett-Packard HP Compaq 2510p Notebook PC/30C9, BIOS 68MSP Ver. F.0E=
 11/04/2008
e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> reserved
e820: remove [mem 0x000a0000-0x000fffff] usable
No AGP bridge found
e820: last_pfn =3D 0x7e7b0 max_arch_pfn =3D 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F000000 mask FFF000000 uncachable
  2 base 07E800000 mask FFF800000 uncachable
  3 base 0FEDA0000 mask FFFFE0000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped: [mem 0x00000000-0x1fffffff]
Base memory trampoline at [ffff880000099000] 99000 size 24576
init_memory_mapping: [mem 0x00000000-0x7e7affff]
 [mem 0x00000000-0x7e5fffff] page 2M
 [mem 0x7e600000-0x7e7affff] page 4k
kernel direct mapping tables up to 0x7e7affff @ [mem 0x1fc09000-0x1fffffff]
ACPI: RSDP 00000000000f7980 00024 (v02 HP    )
ACPI: XSDT 000000007e7c81c8 0007C (v01 HPQOEM SLIC-MPC 00000001 HP   000000=
01)
ACPI: FACP 000000007e7c8084 000F4 (v04 HP     30C9     00000003 HP   000000=
01)
ACPI: DSDT 000000007e7c8538 13484 (v01 HP       nc2500 00010000 MSFT 030000=
01)
ACPI: FACS 000000007e7e7d80 00040
ACPI: SLIC 000000007e7c8244 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   000000=
01)
ACPI: HPET 000000007e7c83bc 00038 (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: APIC 000000007e7c83f4 00068 (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: MCFG 000000007e7c845c 0003C (v01 HP     30C9     00000001 HP   000000=
01)
ACPI: TCPA 000000007e7c8498 00032 (v02 HP     30C9     00000001 HP   000000=
01)
ACPI: ASF! 000000007e7c84cc 00069 (v16 HP     CHIMAYU  00000001 HP   000000=
00)
ACPI: SSDT 000000007e7db9bc 002BE (v01 HP       HPQPAT 00000001 MSFT 030000=
01)
ACPI: SSDT 000000007e7dc5fe 0025F (v01 HP      Cpu0Tst 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc85d 000A6 (v01 HP      Cpu1Tst 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc903 004D7 (v01 HP        CpuPm 00003000 INTL 200603=
17)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007be00000-ffff88007ddff=
fff] on node 0
Zone ranges:
  DMA      [mem 0x00010000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00010000-0x0009efff]
  node   0: [mem 0x00100000-0x7e7affff]
On node 0 totalpages: 517951
  DMA zone: 64 pages used for memmap
  DMA zone: 6 pages reserved
  DMA zone: 3913 pages, LIFO batch:0
  DMA32 zone: 8031 pages used for memmap
  DMA32 zone: 505937 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
e820: [mem 0x7f000000-0xfebfffff] available for PCI devices
setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 27 pages/cpu @ffff88007e400000 s78528 r8192 d23872 u1048576
pcpu-alloc: s78528 r8192 d23872 u1048576 alloc=3D1*2097152
pcpu-alloc: [0] 0 1=20
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 509850
Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz root=3D/dev/sda2 ro video=
=3DSVIDEO-1:d i915.i915_enable_rc6=3D1 init=3D/sbin/bootchartd
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
__ex_table already sorted, skipping sort
Checking aperture...
No AGP bridge found
Memory: 2023536k/2072256k available (5659k kernel code, 452k absent, 48268k=
 reserved, 5143k data, 500k init)
SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
Preemptible hierarchical RCU implementation.
	RCU dyntick-idle grace-period acceleration is enabled.
NR_IRQS:4352 nr_irqs:512 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
tsc: Fast TSC calibration using PIT
tsc: Detected 1196.960 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. =
2393.92 BogoMIPS (lpj=3D1196960)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
process: using mwait in idle threads
Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
tlb_flushall_shift is 0xffffffff
ACPI: Core revision 20120711
..TIMER: vector=3D0x51 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
smpboot: CPU0: Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
perf_event_intel: PEBS disabled due to CPU errata
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
smpboot: Booting Node   0, Processors  #1 OK
CPU1: Thermal monitoring handled by SMI
Brought up 2 CPUs
smpboot: Total of 2 processors activated (4787.84 BogoMIPS)
devtmpfs: initialized
PM: Registering ACPI NVS region [mem 0x7e7c5400-0x7e7e7fb7] (142264 bytes)
reboot: BIOS series board detected. Selecting HP Compaq Laptop-method for r=
eboots.
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (b=
ase 0xf8000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 000000007e7dbd42 0023D (v01 HP      Cpu0Ist 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 0023D (v01 HP      Cpu0Ist 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dc004 005FA (v01 HP      Cpu0Cst 00003001 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 005FA (v01 HP      Cpu0Cst 00003001 INTL 200603=
17)
ACPI: SSDT 000000007e7dbc7a 000C8 (v01 HP      Cpu1Ist 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 000C8 (v01 HP      Cpu1Ist 00003000 INTL 200603=
17)
ACPI: SSDT 000000007e7dbf7f 00085 (v01 HP      Cpu1Cst 00003000 INTL 200603=
17)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00085 (v01 HP      Cpu1Cst 00003000 INTL 200603=
17)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (b=
ase 0xf8000000)
PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard r=
esources
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
ACPI: EC: GPE =3D 0x16, I/O: command/status =3D 0x66, data =3D 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" a=
nd report a bug
ACPI: PCI Root Bridge [C003] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] =
only partially covers this bridge
PCI host bridge to bus 0000:00
pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x7e800000-0xfedfffff]
pci_bus 0000:00: root bus resource [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000dffff]
pci 0000:00:00.0: [8086:2a00] type 00 class 0x060000
pci 0000:00:02.0: [8086:2a02] type 00 class 0x030000
pci 0000:00:02.0: reg 10: [mem 0xe0400000-0xe04fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x2000-0x2007]
pci 0000:00:02.1: [8086:2a03] type 00 class 0x038000
pci 0000:00:02.1: reg 10: [mem 0xe0500000-0xe05fffff 64bit]
pci 0000:00:03.0: [8086:2a04] type 00 class 0x078000
pci 0000:00:03.0: reg 10: [mem 0xe0600000-0xe060000f 64bit]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.2: [8086:2a06] type 00 class 0x010185
pci 0000:00:03.2: reg 10: [io  0x2008-0x200f]
pci 0000:00:03.2: reg 14: [io  0x2010-0x2013]
pci 0000:00:03.2: reg 18: [io  0x2018-0x201f]
pci 0000:00:03.2: reg 1c: [io  0x2020-0x2023]
pci 0000:00:03.2: reg 20: [io  0x2030-0x203f]
pci 0000:00:03.3: [8086:2a07] type 00 class 0x070002
pci 0000:00:03.3: reg 10: [io  0x2040-0x2047]
pci 0000:00:03.3: reg 14: [mem 0xe0601000-0xe0601fff]
pci 0000:00:19.0: [8086:1049] type 00 class 0x020000
pci 0000:00:19.0: reg 10: [mem 0xe0620000-0xe063ffff]
pci 0000:00:19.0: reg 14: [mem 0xe0640000-0xe0640fff]
pci 0000:00:19.0: reg 18: [io  0x2060-0x207f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: [8086:2834] type 00 class 0x0c0300
pci 0000:00:1a.0: reg 20: [io  0x2080-0x209f]
pci 0000:00:1a.1: [8086:2835] type 00 class 0x0c0300
pci 0000:00:1a.1: reg 20: [io  0x20a0-0x20bf]
pci 0000:00:1a.7: [8086:283a] type 00 class 0x0c0320
pci 0000:00:1a.7: reg 10: [mem 0xe0641000-0xe06413ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: [8086:284b] type 00 class 0x040300
pci 0000:00:1b.0: reg 10: [mem 0xe0644000-0xe0647fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: [8086:283f] type 01 class 0x060400
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: [8086:2841] type 01 class 0x060400
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: [8086:2830] type 00 class 0x0c0300
pci 0000:00:1d.0: reg 20: [io  0x20c0-0x20df]
pci 0000:00:1d.1: [8086:2831] type 00 class 0x0c0300
pci 0000:00:1d.1: reg 20: [io  0x20e0-0x20ff]
pci 0000:00:1d.2: [8086:2832] type 00 class 0x0c0300
pci 0000:00:1d.2: reg 20: [io  0x2100-0x211f]
pci 0000:00:1d.7: [8086:2836] type 00 class 0x0c0320
pci 0000:00:1d.7: reg 10: [mem 0xe0648000-0xe06483ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1e.0: [8086:2448] type 01 class 0x060401
pci 0000:00:1f.0: [8086:2811] type 00 class 0x060100
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1100-0x113f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
pci 0000:00:1f.1: [8086:2850] type 00 class 0x01018a
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x2120-0x212f]
pci_bus 0000:08: busn_res: [bus 08] is inserted under [bus 00-ff]
pci 0000:00:1c.0: PCI bridge to [bus 08]
pci_bus 0000:10: busn_res: [bus 10] is inserted under [bus 00-ff]
pci 0000:10:00.0: [8086:4229] type 00 class 0x028000
pci 0000:10:00.0: reg 10: [mem 0xe0000000-0xe0001fff 64bit]
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PCI bridge to [bus 10]
pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
pci_bus 0000:02: busn_res: [bus 02-03] is inserted under [bus 00-ff]
pci 0000:02:06.0: [1180:0476] type 02 class 0x060700
pci 0000:02:06.0: proprietary Ricoh MMC controller disabled (via cardbus fu=
nction)
pci 0000:02:06.0: MMC cards are now supported by standard SDHCI controller
pci 0000:02:06.0: reg 10: [mem 0xe0100000-0xe0100fff]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.1: [1180:0832] type 00 class 0x0c0010
pci 0000:02:06.1: reg 10: [mem 0xe0101000-0xe01017ff]
pci 0000:02:06.1: supports D1 D2
pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.2: [1180:0822] type 00 class 0x080500
pci 0000:02:06.2: reg 10: [mem 0xe0102000-0xe01020ff]
pci 0000:02:06.2: supports D1 D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:1e.0: PCI bridge to [bus 02-03] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xe0100000-0xe03fffff]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0x7e800000-0xfedfffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive =
decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive =
decode)
pci_bus 0000:03: busn_res: can not insert [bus 03-ff] under [bus 02-03] (co=
nflicts with (null) [bus 02-03])
pci_bus 0000:03: busn_res: [bus 03-ff] end is updated to 06
pci_bus 0000:03: busn_res: can not insert [bus 03-06] under [bus 02-03] (co=
nflicts with (null) [bus 02-03])
pci_bus 0000:03: [bus 03-06] partially hidden behind transparent bridge 000=
0:02 [bus 02-03]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception: AE_NOT_FOUND, Evaluating _PRS (20120711/pci_link-184)
vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=
=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
ACPI: bus type scsi registered
libata version 3.00 loaded.
ACPI: bus type usb registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
wmi: Mapper loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
Expanded resource reserved due to conflict with PCI Bus 0000:00
e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
e820: reserve RAM buffer [mem 0x7e7b0000-0x7fffffff]
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [mem 0x00000000-0x0009ffff]
pnp 00:00: [mem 0x000e0000-0x000fffff]
pnp 00:00: [mem 0x00100000-0x7e7fffff]
system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:00: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:00: [mem 0x00100000-0x7e7fffff] could not be reserved
system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: [bus 00-ff]
pnp 00:01: [io  0x0cf8-0x0cff]
pnp 00:01: [io  0x0000-0x0cf7 window]
pnp 00:01: [io  0x0d00-0xffff window]
pnp 00:01: [mem 0x000a0000-0x000bffff window]
pnp 00:01: [mem 0x7e800000-0xfedfffff window]
pnp 00:01: [mem 0xfee01000-0xffffffff window]
pnp 00:01: [mem 0x000d0000-0x000dffff window]
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: [io  0x00f0-0x00ff]
pnp 00:02: [irq 13]
pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0080-0x008f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x0061]
pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:05: [io  0x0070-0x0071]
pnp 00:05: [io  0x0072-0x0073]
pnp 00:05: [irq 8]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [mem 0xfed00000-0xfed003ff]
pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (=
active)
pnp 00:09: [io  0x0010-0x001f]
pnp 00:09: [io  0x0024-0x003f]
pnp 00:09: [io  0x004e-0x004f]
pnp 00:09: [io  0x0050-0x0053]
pnp 00:09: [io  0x0063]
pnp 00:09: [io  0x0065]
pnp 00:09: [io  0x0067]
pnp 00:09: [io  0x0074-0x0077]
pnp 00:09: [io  0x0090-0x009f]
pnp 00:09: [io  0x00a4-0x00bd]
pnp 00:09: [io  0x0500-0x057f]
pnp 00:09: [io  0x0800-0x080f]
pnp 00:09: [mem 0xffb00000-0xffbfffff]
pnp 00:09: [mem 0xfff00000-0xffffffff]
system 00:09: [io  0x0500-0x057f] has been reserved
system 00:09: [io  0x0800-0x080f] has been reserved
system 00:09: [mem 0xffb00000-0xffbfffff] has been reserved
system 00:09: [mem 0xfff00000-0xffffffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [irq 23]
pnp 00:0a: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp 00:0b: [io  0x04d0-0x04d1]
pnp 00:0b: [io  0x02f8-0x02ff]
pnp 00:0b: [io  0x03f8-0x03ff]
pnp 00:0b: [io  0x1000-0x107f]
pnp 00:0b: [io  0x1100-0x113f]
pnp 00:0b: [io  0x1200-0x121f]
pnp 00:0b: [mem 0xf8000000-0xfbffffff]
pnp 00:0b: [mem 0xfec00000-0xfec000ff]
pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
pnp 00:0b: [mem 0xfed90000-0xfed99fff]
system 00:0b: [io  0x04d0-0x04d1] has been reserved
system 00:0b: [io  0x02f8-0x02ff] has been reserved
system 00:0b: [io  0x03f8-0x03ff] has been reserved
system 00:0b: [io  0x1000-0x107f] has been reserved
system 00:0b: [io  0x1100-0x113f] has been reserved
system 00:0b: [io  0x1200-0x121f] has been reserved
system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
system 00:0b: [mem 0xfec00000-0xfec000ff] could not be reserved
system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:0b: [mem 0xfed90000-0xfed99fff] has been reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: [mem 0x000cee00-0x000cffff]
pnp 00:0c: [mem 0xfeda0000-0xfedbffff]
pnp 00:0c: [mem 0xfee00000-0xfee00fff]
system 00:0c: [mem 0x000cee00-0x000cffff] has been reserved
system 00:0c: [mem 0xfeda0000-0xfedbffff] has been reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:02:06.0: res[7]=3D[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:06.0: res[8]=3D[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:00:1e.0: bridge window [io  0x1000-0x0fff] to [bus 02-03] add_size=
 1000
pci 0000:02:06.0: res[9]=3D[mem 0x04000000-0x03ffffff pref] get_res_add_siz=
e add_size 4000000
pci 0000:00:1e.0: bridge window [mem 0x04000000-0x03ffffff pref] to [bus 02=
-03] add_size 4000000
pci 0000:00:1e.0: res[9]=3D[mem 0x04000000-0x03ffffff pref] get_res_add_siz=
e add_size 4000000
pci 0000:00:1e.0: res[7]=3D[io  0x1000-0x0fff] get_res_add_size add_size 10=
00
pci 0000:00:1e.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
pci 0000:00:1e.0: BAR 7: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.0: PCI bridge to [bus 08]
pci 0000:00:1c.1: PCI bridge to [bus 10]
pci 0000:00:1c.1:   bridge window [mem 0xe0000000-0xe00fffff]
pci 0000:02:06.0: res[9]=3D[mem 0x04000000-0x03ffffff pref] get_res_add_siz=
e add_size 4000000
pci 0000:02:06.0: res[10]=3D[mem 0x04000000-0x03ffffff] get_res_add_size ad=
d_size 4000000
pci 0000:02:06.0: res[7]=3D[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:06.0: res[8]=3D[io  0x0100-0x00ff] get_res_add_size add_size 100
pci 0000:02:06.0: BAR 9: assigned [mem 0x80000000-0x83ffffff pref]
pci 0000:02:06.0: BAR 10: assigned [mem 0x84000000-0x87ffffff]
pci 0000:02:06.0: BAR 7: assigned [io  0x3000-0x30ff]
pci 0000:02:06.0: BAR 8: assigned [io  0x3400-0x34ff]
pci 0000:02:06.0: CardBus bridge to [bus 03-06]
pci 0000:02:06.0:   bridge window [io  0x3000-0x30ff]
pci 0000:02:06.0:   bridge window [io  0x3400-0x34ff]
pci 0000:02:06.0:   bridge window [mem 0x80000000-0x83ffffff pref]
pci 0000:02:06.0:   bridge window [mem 0x84000000-0x87ffffff]
pci 0000:00:1e.0: PCI bridge to [bus 02-03]
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xe0100000-0xe03fffff]
pci 0000:00:1e.0:   bridge window [mem 0x80000000-0x83ffffff pref]
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x7e800000-0xfedfffff]
pci_bus 0000:00: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:00: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:10: resource 1 [mem 0xe0000000-0xe00fffff]
pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:02: resource 1 [mem 0xe0100000-0xe03fffff]
pci_bus 0000:02: resource 2 [mem 0x80000000-0x83ffffff pref]
pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:02: resource 7 [mem 0x7e800000-0xfedfffff]
pci_bus 0000:02: resource 8 [mem 0xfee01000-0xffffffff]
pci_bus 0000:02: resource 9 [mem 0x000d0000-0x000dffff]
pci_bus 0000:03: resource 0 [io  0x3000-0x30ff]
pci_bus 0000:03: resource 1 [io  0x3400-0x34ff]
pci_bus 0000:03: resource 2 [mem 0x80000000-0x83ffffff pref]
pci_bus 0000:03: resource 3 [mem 0x84000000-0x87ffffff]
NET: Registered protocol family 2
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP: reno registered
UDP hash table entries: 1024 (order: 3, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
audit: initializing netlink socket (disabled)
type=3D2000 audit(1344964419.273:1): initialized
Btrfs loaded
msgmni has been set to 3952
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
pci 0000:10:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
progear_bl: ALI M7101 PMU not found.
i2c-core: driver [adp8860_bl] using legacy suspend method
i2c-core: driver [adp8860_bl] using legacy resume method
i2c-core: driver [adp8870_bl] using legacy suspend method
i2c-core: driver [adp8870_bl] using legacy resume method
intel_idle: does not run on family 6 model 15
ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI=
_PROCFS_POWER cleared
ACPI: AC Adapter [C23B] (on-line)
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/inpu=
t0
ACPI: Sleep Button [C2BF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [C155]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: Fan [C3B1] (off)
ACPI: Fan [C3B2] (off)
ACPI: Fan [C3C8] (off)
ACPI: Fan [C3C9] (off)
ACPI: Fan [C3CA] (off)
ACPI: Fan [C3CB] (off)
ACPI: Fan [C3CC] (off)
ACPI: Requesting acpi_cpufreq
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
tsc: Marking TSC unstable due to TSC halts in idle
ACPI: acpi_idle registered with cpuidle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZ6] (25 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZ0] (53 C)
thermal LNXTHERM:02: registered as thermal_zone2
ACPI: Thermal Zone [TZ1] (54 C)
thermal LNXTHERM:03: registered as thermal_zone3
ACPI: Thermal Zone [TZ3] (41 C)
thermal LNXTHERM:04: registered as thermal_zone4
ACPI: Thermal Zone [TZ4] (30 C)
thermal LNXTHERM:05: registered as thermal_zone5
ACPI: Thermal Zone [TZ5] (50 C)
GHES: HEST is not enabled!
ERST DBG: ERST support is disabled.
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 965GM Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 524288K total, 262144K mappa=
ble
agpgart-intel 0000:00:00.0: detected 8192K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 42 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=3Dio+mem,decode=
s=3Dio+mem:owns=3Dio+mem
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG=
_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [C23D] (battery present)
[drm] initialized overlay support
[drm] forcing SVIDEO-1 connector OFF
fbcon: inteldrmfb (fb0) is primary device
Console: switching to colour frame buffer device 160x50
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000004) is beyond =
end of object (20120711/exoparg2-418)
ACPI Error: Method parse/execution failed [\_SB_.C003.C09A._DOD] (Node ffff=
88007b82c988), AE_AML_PACKAGE_LIMIT (20120711/psparse-536)
ACPI Exception: AE_AML_PACKAGE_LIMIT, Evaluating _DOD (20120711/video-1149)
video: probe of LNXVIDEO:00 failed with error 12299
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: quirky BIOS, skipping spindown on poweroff and hiber=
nation
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x2120 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2128 irq 15
ata2: port disabled--ignoring
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0641000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.6.0-rc1-00312-g3bf671a-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0648000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 3.6.0-rc1-00312-g3bf671a-dirty ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002080
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 3.6.0-rc1-00312-g3bf671a-dirty uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x000020a0
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 3.6.0-rc1-00312-g3bf671a-dirty uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000020c0
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 3.6.0-rc1-00312-g3bf671a-dirty uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020e0
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 3.6.0-rc1-00312-g3bf671a-dirty uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002100
usb usb7: New USB device found, idVendor=3D1d6b, idProduct=3D0001
usb usb7: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 3.6.0-rc1-00312-g3bf671a-dirty uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usbcore: registered new interface driver libusual
i8042: PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,=
12
ata1.00: ATA-8: SAMSUNG HM250JI, HS100-08, max UDMA7
i8042: Detected active multiplexing controller, rev 1.1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
i2c /dev entries driver
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
cpuidle: using governor ladder
cpuidle: using governor menu
leds_ss4200: no LED devices found
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
hp_accel: hardware type NC2510 found
lis3lv02d: 12 bits sensor found
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input3
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HM250JI  HS10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/inp=
ut4
Registered led device: hp::hddprotect
hp_accel: driver loaded
TCP: cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
console [netcon0] enabled
netconsole: network logging started
usb 3-1: new full-speed USB device number 2 using uhci_hcd
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input5
usb 3-1: New USB device found, idVendor=3D03f0, idProduct=3D171d
usb 3-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-1: Product: HP Integrated Module
usb 3-1: Manufacturer: Broadcom Corp
usb 5-1: new full-speed USB device number 2 using uhci_hcd
usb 5-1: New USB device found, idVendor=3D067b, idProduct=3D2303
usb 5-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 5-1: Product: USB-Serial Controller
usb 5-1: Manufacturer: Prolific Technology Inc.
psmouse serio4: synaptics: Touchpad model: 1, fw: 6.3, id: 0x1a0b1, caps: 0=
xa04711/0xa00000/0x0, board id: 3655, fw id: 438446
usb 5-2: new full-speed USB device number 3 using uhci_hcd
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/i=
nput6
ACPI: Invalid Power Resource to register!
device label GENTOO_ROOT devid 1 transid 146417 /dev/root
btrfs: disk space caching is enabled
usb 5-2: New USB device found, idVendor=3D08ff, idProduct=3D2580
usb 5-2: New USB device strings: Mfr=3D0, Product=3D1, SerialNumber=3D0
usb 5-2: Product: Fingerprint Sensor
VFS: Mounted root (btrfs filesystem) readonly on device 0:12.
Freeing unused kernel memory: 500k freed
Write protecting the kernel read-only data: 10240k
Freeing unused kernel memory: 472k freed
Freeing unused kernel memory: 1788k freed
bootchart continuing boot
systemd-udevd[5697]: starting version 187
microcode: CPU0 sig=3D0x6fd, pf=3D0x80, revision=3D0xa3
e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
e1000e 0000:00:19.0: setting latency timer to 64
e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic co=
nservative mode
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
microcode: CPU1 sig=3D0x6fd, pf=3D0x80, revision=3D0xa3
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Pe=
ter Oruba
usbcore: registered new interface driver usbserial
usbserial: USB Serial Driver core
e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) 00:1e:68:51:e5:60
e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: FFFFFF-0FF
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30c9]
usbcore: registered new interface driver pl2303
USB Serial support registered for pl2303
pl2303 5-1:1.0: pl2303 converter detected
usb 5-1: pl2303 converter now attached to ttyUSB0
yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cb8, PCI irq 18
yenta_cardbus 0000:02:06.0: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #=
06
cfg80211: Calling CRDA to update world regulatory domain
sdhci-pci 0000:02:06.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:02:06.2] using DMA
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
iwl4965: Intel(R) Wireless WiFi 4965 driver for Linux, in-tree:d
iwl4965: Copyright(c) 2003-2011 Intel Corporation
iwl4965 0000:10:00.0: Detected Intel(R) Wireless WiFi Link 4965AGN, REV=3D0=
x4
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
iwl4965 0000:10:00.0: device EEPROM VER=3D0x36, CALIB=3D0x5
iwl4965 0000:10:00.0: Tunable channels: 13 802.11bg, 19 802.11a channels
iwl4965 0000:10:00.0: irq 45 for MSI/MSI-X
iwl4965 0000:10:00.0: loaded firmware version 228.61.2.24
Registered led device: phy0-led
cfg80211: Ignoring regulatory request Set by core since the driver uses its=
 own custom regulatory domain
ieee80211 phy0: Selected rate control algorithm 'iwl-4965-rs'
Adding 3946504k swap on /dev/sda3.  Priority:-1 extents:1 across:3946504k=20
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
fuse init (API version 7.19)
loop: module loaded
btrfs: disk space caching is enabled
btrfs: resize thread pool 4 -> 2
EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
device label gentoo-16k devid 1 transid 2638 /dev/loop0
btrfs: setting nodatasum
btrfs: use lzo compression
btrfs: disk space caching is enabled
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
wlan0: authenticate with 00:13:49:e1:fa:18
wlan0: send auth to 00:13:49:e1:fa:18 (try 1/3)
wlan0: authenticated
iwl4965 0000:10:00.0: wlan0: disabling HT as WMM/QoS is not supported
wlan0: associate with 00:13:49:e1:fa:18 (try 1/3)
wlan0: RX AssocResp from 00:13:49:e1:fa:18 (capab=3D0x411 status=3D0 aid=3D=
1)
wlan0: associated
btrfs: free space inode generation (0) did not match free space cache gener=
ation (127330)
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D3
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
PM: suspend of devices complete after 589.267 msecs
PM: late suspend of devices complete after 0.392 msecs
ehci_hcd 0000:00:1d.7: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1d.2: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1d.1: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
ehci_hcd 0000:00:1a.7: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1a.1: wake-up capability enabled by ACPI
uhci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
PM: noirq suspend of devices complete after 33.351 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
Extended CMOS year: 2000
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Extended CMOS year: 2000
CPU0: Thermal monitoring handled by SMI
Enabling non-boot CPUs ...
smpboot: Booting Node 0 Processor 1 APIC 0x1
CPU1: Thermal monitoring handled by SMI
CPU1 is up
ACPI: Waking up from system sleep state S3
uhci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
uhci_hcd 0000:00:1a.1: wake-up capability disabled by ACPI
ehci_hcd 0000:00:1a.7: wake-up capability disabled by ACPI
snd_hda_intel 0000:00:1b.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
uhci_hcd 0000:00:1d.1: wake-up capability disabled by ACPI
uhci_hcd 0000:00:1d.2: wake-up capability disabled by ACPI
ehci_hcd 0000:00:1d.7: wake-up capability disabled by ACPI
PM: noirq resume of devices complete after 83.832 msecs
PM: early resume of devices complete after 0.193 msecs
i915 0000:00:02.0: setting latency timer to 64
e1000e 0000:00:19.0: wake-up capability disabled by ACPI
e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
uhci_hcd 0000:00:1a.0: setting latency timer to 64
usb usb3: root hub lost power or was reset
uhci_hcd 0000:00:1a.1: setting latency timer to 64
usb usb4: root hub lost power or was reset
ehci_hcd 0000:00:1a.7: setting latency timer to 64
snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
uhci_hcd 0000:00:1d.0: setting latency timer to 64
usb usb5: root hub lost power or was reset
uhci_hcd 0000:00:1d.1: setting latency timer to 64
usb usb6: root hub lost power or was reset
uhci_hcd 0000:00:1d.2: setting latency timer to 64
usb usb7: root hub lost power or was reset
ehci_hcd 0000:00:1d.7: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
ata_piix 0000:00:1f.1: setting latency timer to 64
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
ACPI Exception: AE_AML_PACKAGE_LIMIT, Index (0x0000000000000005) is beyond =
end of object (20120711/exoparg2-418)
ACPI Error: Method parse/execution failed [\_SB_.C2C3] (Node ffff88007b83e1=
18), AE_AML_PACKAGE_LIMIT (20120711/psparse-536)
ACPI Error: Method parse/execution failed [\_SB_.C003.C0F6.C3F3._STM] (Node=
 ffff88007b893c58), AE_AML_PACKAGE_LIMIT (20120711/psparse-536)
ata1: ACPI set timing mode failed (status=3D0x300b)
ata2: port disabled--ignoring
usb 5-1: reset full-speed USB device number 2 using uhci_hcd
pl2303 5-1:1.0: no reset_resume for driver pl2303?
pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
pl2303 5-1:1.0: device disconnected
usb 5-2: reset full-speed USB device number 3 using uhci_hcd
usb 3-1: reset full-speed USB device number 2 using uhci_hcd
ata1.00: ACPI cmd ef/03:01:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:45:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filte=
red out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 (SET MULTIPLE MODE) succeeded
ata1.00: configured for UDMA/100
sd 0:0:0:0: [sda] Starting disk
PM: resume of devices complete after 3263.187 msecs
pl2303 5-1:1.0: pl2303 converter detected
usb 5-1: pl2303 converter now attached to ttyUSB0
PM: Finishing wakeup.
Restarting tasks ... done.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
sdhci-pci 0000:02:06.2: Will use DMA mode even though HW doesn't fully clai=
m to support it.
btrfs: free space inode generation (0) did not match free space cache gener=
ation (104525)
btrfs: free space inode generation (0) did not match free space cache gener=
ation (48730)
btrfs: free space inode generation (0) did not match free space cache gener=
ation (77602)
btrfs: free space inode generation (0) did not match free space cache gener=
ation (126469)
btrfs: free space inode generation (0) did not match free space cache gener=
ation (121774)
btrfs: free space inode generation (0) did not match free space cache gener=
ation (127445)
btrfs: free space inode generation (0) did not match free space cache gener=
ation (128762)
usb 5-1: USB disconnect, device number 2
pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
pl2303 5-1:1.0: device disconnected
usb 5-1: new low-speed USB device number 4 using uhci_hcd
usb 5-1: New USB device found, idVendor=3D046d, idProduct=3Dc046
usb 5-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 5-1: Product: USB Optical Mouse
usb 5-1: Manufacturer: Logitech
input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb5/=
5-1/5-1:1.0/input/input7
hid-generic 0003:046D:C046.0001: input: USB HID v1.10 Mouse [Logitech USB O=
ptical Mouse] on usb-0000:00:1d.0-1/input0

--MP_/ZKHVzYwN=ZwGqff+kpxsXBO--

--Sig_/.=k25nnQ8GvzNr/J6GNKydz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlAqil8ACgkQcaHudmEf86r0NACeM2uFSSq6m+WooC2M8IpLLwoo
CvkAnRIggeKDtsOt8TnOBA0mpmuWPgKJ
=TUr+
-----END PGP SIGNATURE-----

--Sig_/.=k25nnQ8GvzNr/J6GNKydz--
