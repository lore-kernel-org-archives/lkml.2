Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab0DIAnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:43:35 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:40234 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab0DIAnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:43:33 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201004090043.o390hSjL014351@turbo.physics.adelaide.edu.au>
Subject: 2.6.33: libata issues with VIA SATA/PATA controller
To: linux-kernel@vger.kernel.org
Date: Fri, 9 Apr 2010 10:13:28 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have a machine equipped with the following SATA/PATA controllers:

 * 00:0f.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/
   VT823x/A/C PIPC Bus Master IDE (rev 06)

 * 00:0f.0 RAID bus controller: VIA Technologies, Inc. VIA VT6420 SATA RAID
   Controller (rev 80)

Two hard drives are attached to the SATA controller (messages from 2.6.24.2):

  scsi 0:0:0:0: Direct-Access     ATA      WDC WD2502ABYS-0 02.0 PQ: 0 ANSI: 5
  scsi 1:0:0:0: Direct-Access     ATA      WDC WD2502ABYS-0 02.0 PQ: 0 ANSI: 5

Both drives are jumpered to force 1.5 Gbps SATA speed.  This is needed
because these WD drives won't automatically fall back to 1.5 Gbps if 3.0
Gbps isn't requested, and the VIA controller in use is only capable of
1.5 Gbps.

The PATA interface has a tape drive attached as primary master and a CD
writer attached as secondary master.  Under 2.6.24.2 these show up as

  hda: SONY SDX-260V, ATAPI TAPE drive
  hdc: ATAPI 40X CD-ROM CD-R/RW drive, 2048kB Cache

The problem I have is that I am unable to boot 2.6.33 (or 2.6.33.2).  The
interfaces are probed but it seems the system has trouble communicating
reliably over the SATA links.  Sometimes both drives are identified
correctly, only to encounter I/O errors when the partition table is read. 
Other times failures occur during the drive detection phase.  The problem
persists even when both PATA devices have been unplugged, so the PATA
devices themselves are not the cause.  In all cases the end result is the
same: the rootfs can't be found, the kernel panics.

The 2.6.33.2 I have tried to boot today is configured to use libata VIA PATA
support.  The 2.6.24.2 kernel (which mostly works, except for some issues
with ide-tape which might be hardware related) instead uses the old ide
driver for the PATA interface.  I have not yet been able to test whether
disabling the VIA PATA component of libata works around the problem.  The
reason for enabling libata VIA PATA support is due to ongoing issues with
ide-tape in recent kernels (I've tried from 2.6.29 on).  The suggestion was
made to try libata since its tape driver was in better shape.

Unfortunately the machine in question is a production machine and I have
limited opportunities to reboot and test kernels.  I also didn't have a
camera handy to take screen shots this morning during testing.  The
following are messages I noted by hand before they were scrolled away by the
panic.

  ata1: lost interrupt status 0x50
  unhandled error code
  Result: hostbyte=0x00, driverbyte=0x06
  CDB: cdb[0] = 0x28 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x08 0x00
  end request: I/O error, dev sda, sector 0

The same was repeated for ata2 / sdb.

Another group of messages which crops up during drive detection is:

  qc timeout cmd 0x27
  failed to read native max address (error mask 0x4)
  HPA suport seems broken, skipping HPA handling

I would like to try to get to the bottom of what's happening here.  This
problem does not occur in 2.6.24.2 (using the VIA ide PATA driver).  Both
2.6.33 and 2.6.33.2 (with the VIA libata PATA driver) suffer from the
problem.  If there are further tests I can do please let me know and I'll do
my best to schedule them (given that the machine in question is a production
system).  Also ask if you require more information about the machine.

Finally, there's a complete dmsg output I get from 2.6.24.2 at the end of
this email in case it contains additional useful information on the hardware
configuration of this system.  Please CC me any replies to ensure I see them
(I monitor lkml via web gateways, so it's easy to miss followups at times).

Regards
  jonatha

ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12) *15, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x3fffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec000ff could not be reserved
system 00:00: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:02: ioport range 0xe400-0xe47f has been reserved
system 00:02: ioport range 0xe800-0xe81f has been reserved
system 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:02: iomem range 0xffb80000-0xffbfffff has been reserved
system 00:03: ioport range 0x4d0-0x4d1 has been reserved
system 00:0d: ioport range 0x290-0x297 has been reserved
system 00:0d: ioport range 0x370-0x375 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: f4000000-f5efffff
  PREFETCH window: f5f00000-f7ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x3a set to 0x1
Machine check exception polling timer started.
microcode: CPU0 not a capable Intel processor
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
SGI XFS with ACLs, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: VIA PCI bridge detected. Disabling DAC.
Boot video device is 0000:01:00.0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
agpgart: Detected VIA KT400/KT400A/KT600 chipset
agpgart: AGP aperture is 64M @ 0xf8000000
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PCI: Enabling device 0000:00:13.0 (0000 -> 0001)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:13.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
0000:00:13.0: ttyS1 at I/O 0x8000 (irq = 11) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:0f.1
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [LNKE] -> GSI 5 (level, low) -> IRQ 5
PCI: VIA VLink IRQ fixup for 0000:00:0f.1, from 255 to 5
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
    ide0: BM-DMA at 0xa000-0xa007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xa008-0xa00f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
Switched to high resolution mode on CPU 0
hda: SONY SDX-260V, ATAPI TAPE drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: LITE-ON LTR-32123S, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
hdc: ATAPI 40X CD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-tape: hda <-> ht0: SONY SDX-260V rev 0100
ide-tape: hda: overriding capabilities->speed (assuming 650KB/sec)
ide-tape: hda: overriding capabilities->max_speed (assuming 650KB/sec)
ide-tape: decreasing stage size
ide-tape: decreasing stage size
ide-tape: decreasing stage size
ide-tape: hda <-> ht0: 650KBps, 126*32kB buffer, 6336kB pipeline, 100ms tDSC, DMA
st: Version 20070203, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_via 0000:00:0f.0: version 2.3
ACPI: PCI Interrupt Link [LNKF] BIOS reported IRQ 0, using IRQ 9
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 9
PCI: setting IRQ 9 as level-triggered
ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [LNKF] -> GSI 9 (level, low) -> IRQ 9
PCI: VIA VLink IRQ fixup for 0000:00:0f.0, from 5 to 9
sata_via 0000:00:0f.0: routed to hard irq line 9
scsi0 : sata_via
scsi1 : sata_via
ata1: SATA max UDMA/133 cmd 0xd000 ctl 0xb800 bmdma 0xa800 irq 9
ata2: SATA max UDMA/133 cmd 0xb400 ctl 0xb000 bmdma 0xa808 irq 9
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: WDC WD2502ABYS-01B7A0, 02.03B02, max UDMA/133
ata1.00: 490350672 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: WDC WD2502ABYS-01B7A0, 02.03B02, max UDMA/133
ata2.00: 490350672 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD2502ABYS-0 02.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 490350672 512-byte hardware sectors (251060 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 490350672 512-byte hardware sectors (251060 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      WDC WD2502ABYS-0 02.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 490350672 512-byte hardware sectors (251060 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 490350672 512-byte hardware sectors (251060 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 sdb8 >
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg1 type 0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
input: ImPS/2 Generic Wheel Mouse as /class/input/input3
device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Feb 15 2008
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI Shortcut mode
UDF-fs: No VRS found
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 172k freed
Adding 2008084k swap on /dev/sda5.  Priority:-1 extents:1 across:2008084k
8139too Fast Ethernet driver 0.9.28
PCI: Enabling device 0000:00:0d.0 (0004 -> 0007)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
eth0: RealTek RTL8139 at 0xf8870000, 00:02:44:43:56:2d, IRQ 11
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKE] -> GSI 5 (level, low) -> IRQ 5
eth1: VIA Rhine II at 0xf2000000, 00:0e:a6:70:fc:45, IRQ 5.
eth1: MII PHY found at address 1, status 0x786d advertising 01e1 Link 0020.
PCI: Enabling device 0000:00:0c.0 (0094 -> 0097)
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  MMIO=[f3800000-f38007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKE] -> GSI 5 (level, low) -> IRQ 5
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 5, io base 0x00009800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [LNKE] -> GSI 5 (level, low) -> IRQ 5
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 5, io base 0x00009400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [LNKF] -> GSI 9 (level, low) -> IRQ 9
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 9, io base 0x00009000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [LNKF] -> GSI 9 (level, low) -> IRQ 9
PCI: VIA VLink IRQ fixup for 0000:00:10.3, from 0 to 9
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.3: irq 9, io base 0x00008800
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [LNKG] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:10.4: irq 11, io mem 0xf2800000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0030e033e013009a]
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00110600000044f6]
scsi2 : SBP-2 IEEE-1394
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max payload [2048]
scsi 2:0:0:0: Direct-Access-RBC WDC WD50 00AAKB-00H8A0         PQ: 0 ANSI: 4
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 11 00 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 11 00 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 14
XFS mounting filesystem sda6
Ending clean XFS mount for filesystem: sda6
XFS mounting filesystem sda7
Ending clean XFS mount for filesystem: sda7
XFS mounting filesystem sda8
Ending clean XFS mount for filesystem: sda8
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
eth1: link up, 10Mbps, half-duplex, lpa 0x0020
PPP generic driver version 2.4.2
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0030e033e013009a]
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00110600000044f6]
scsi2 : SBP-2 IEEE-1394
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max payload [2048]
scsi 2:0:0:0: Direct-Access-RBC WDC WD50 00AAKB-00H8A0         PQ: 0 ANSI: 4
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 11 00 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
 or FUA
sd 2:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 11 00 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
 or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 14
XFS mounting filesystem sda6
Ending clean XFS mount for filesystem: sda6
XFS mounting filesystem sda7
Ending clean XFS mount for filesystem: sda7
XFS mounting filesystem sda8
Ending clean XFS mount for filesystem: sda8
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
eth1: link up, 10Mbps, half-duplex, lpa 0x0020
PPP generic driver version 2.4.2
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)

