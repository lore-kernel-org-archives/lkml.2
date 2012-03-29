Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2C2KM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:12:28 -0400
Received: from science.horizon.com ([71.41.210.146]:28983 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754439Ab2C2KMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:12:18 -0400
Date: 29 Mar 2012 06:12:16 -0400
Message-ID: <20120329101216.17321.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jbarnes@virtuousgeek.org, mjg@redhat.com
Subject: 3.3 panic on boot caused by 4949be16822e92a18ea0cc1616319926628092ee
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully there's enough information here to track down the regression.
The processor is a i7-2700k, with 16G of memory.

Sorry for the delay; I noticed this last week, but didn't get around to
transcribing the oops until just now.

[502]$ git bisect bad
4949be16822e92a18ea0cc1616319926628092ee is the first bad commit
commit 4949be16822e92a18ea0cc1616319926628092ee
Author: Matthew Garrett <mjg@redhat.com>
Date:   Tue Mar 6 13:41:49 2012 -0500

    PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled

    Right now we won't touch ASPM state if ASPM is disabled, except in the case
    where we find a device that appears to be too old to reliably support ASPM.
    Right now we'll clear it in that case, which is almost certainly the wrong
    thing to do. The easiest way around this is just to disable the blacklisting
    when ASPM is disabled.

    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

:040000 040000 bdcf76ebf9d6416ca7a97ee24506d0606ec57df4 4257038001fb683696ada88ef29bb0562a21eede M      drivers

The oops message is as follows.  Hand-copied from the crash screen
(is there an easier way? please?), so while I was careful there might
be a typo.

invalid opcode: 0000 [#1] SMP
CPU 0
Modules linked in:

Pid: 1, comm: swapper/0 Not tainted 3.3.0-rc6-00165-g4949be1 #212 Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3K-B3
RIP: 0010:[<ffffffff811b0ce5>]  [<ffffffff811b0ce5>] pcie_aspm_init_link_state+0x1fa/0x649
RSP: 0018:ffff88040d879b40  EFLAGS: 00010246
RAX: ffff88040d14bf18 RBX: ffff88040d156000 RCX: ffff88040d156038 
RDX: ffff88040d156018 RSI: ffff88040d156f00 RDI: ffff88040d1db000 
RBP: ffff88040d957c00 R08: ffff88040d156000 R09: 0000000000013f58 
R10: 0000000000013fa6 R11: 0000000000013f58 R12: 0000000000000000
R13: ffff88040d1d4000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) FS:ffff88041fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000000164b000 CR4: 00000000000406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 1, threadinfo ffff88040d878000, task ffff88040d870000)
Stack:
 ffffffff81675710 ffffffff81450cf4 ffff88040d1db000 ffffffff811a7df9
 0000000000000000 ffff88040d1db000 ffff88040d957c00 ffffffff814333d2
 0000000000000006 88921283813a5381 ffff88040d879bdc ffffffff811a70d6
Call Trace:
 [<ffffffff81450cf4>] ? down_write+0x9/0x27
 [<ffffffff811a7df9>] ? pci_device_add+0xc4/0xe9
 [<ffffffff814333d2>] ? pci_scan_single_device+0x13f/0x141
 [<ffffffff811a70d6>] ? next_trad_fn+0x7/0x7
 [<ffffffff811a7ee1>] ? pci_scan_slot+0xc3/0xf4
 [<ffffffff81434df8>] ? pci_scan_child_bus+0x24/0xa2
 [<ffffffff81434fd9>] ? pci_scan_bridge+0x163/0x45e
 [<ffffffff814332d6>] ? pci_scan_single_device+0x43/0x141
 [<ffffffff811a70cf>] ? agp_speed+0x39/0x39
 [<ffffffff81434e59>] ? pci_scan_child_bus+0x85/0xa2
 [<ffffffff8143f605>] ? pci_acpi_scan_root+0x24f/0x2ca
 [<ffffffff81439856>] ? acpi_pci_root_add+0x1ce/0x436
 [<ffffffff811ce1d6>] ? acpi_device_probe+0x42/0x10d
 [<ffffffff812d9b4d>] ? driver_probe_device+0xa8/0x138
 [<ffffffff812d9c2c>] ? __driver_attach+0x4f/0x6f
 [<ffffffff812d9bdd>] ? driver_probe_device+0x138/0x138
 [<ffffffff812d877f>] ? bus_for_each_dev+0x4a/0x75
 [<ffffffff812d94e4>] ? bus_add_driver+0xa5/0x1f5
 [<ffffffff816e1483>] ? find_dock+0x19/0x19
 [<ffffffff812da040>] ? driver_register+0x8d/0xf5
 [<ffffffff816e1483>] ? find_dock+0x19/0x19
 [<ffffffff816e14a1>] ? acpi_pci_root_init+0x1e/0x27
 [<ffffffff81000205>] ? do_one_initcall+0x75/0x124
 [<ffffffff816c79bd>] ? start_kernel+0x2bb/0x2bb
 [<ffffffff81453810>] ? gs_change+0xb/0xb
Code: 81 48 89 9d 80 00 00 00 4c 8b 2b 49 8b 6d 18 74 0d 80 4b 48 38 80 4b 49 70 e9 6f 03 00 00 48 8b 7d 28 40 8a 77 4a 40 84 f6 75 02 <0f> 0b 48 8d 54 24 4e 40 0f b6 f6 45 31 ff 83 c6 12 e8 14 f8 ff
RIP  [<ffffffff811b0ce5>] pcie_aspm_init_linki_state+0x1fa/0x649
 RSP: <ffff88040d879b40>
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!


Following is lscpi -vvnn, dmidecode, and grep ^C .config

00:00.0 Host bridge [0600]: Intel Corporation 2nd Generation Core Processor Family DRAM Controller [8086:0100] (rev 09)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller [0300]: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller [8086:0122] (rev 09) (prog-if 00 [VGA controller])
	Subsystem: Giga-byte Technology Device [1458:d000]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 40
	Region 0: Memory at fb800000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at ff00 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915

00:16.0 Communication controller [0780]: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 [8086:1c3a] (rev 04)
	Subsystem: Giga-byte Technology Device [1458:1c3a]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at fbfff000 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>

00:1a.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 [8086:1c2d] (rev 05) (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device [1458:5006]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbffe000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device [0403]: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller [8086:1c20] (rev 05)
	Subsystem: Giga-byte Technology Device [1458:a002]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at fbff4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 [8086:1c10] (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: dfb00000-dfcfffff
	Prefetchable memory behind bridge: 00000000dfd00000-00000000dfefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.5 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 [8086:1c1a] (rev b5) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Prefetchable memory behind bridge: 00000000fbe00000-00000000fbefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1c.6 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev b5) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000dfa00000-00000000dfafffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1c.7 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 8 [8086:1c1e] (rev b5) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Memory behind bridge: fbc00000-fbcfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport

00:1d.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 [8086:1c26] (rev 05) (prog-if 20 [EHCI])
	Subsystem: Giga-byte Technology Device [1458:5006]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fbffd000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd

00:1f.0 ISA bridge [0601]: Intel Corporation Z68 Express Chipset Family LPC Controller [8086:1c44] (rev 05)
	Subsystem: Giga-byte Technology Device [1458:5001]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:1f.2 SATA controller [0106]: Intel Corporation 6 Series/C200 Series Chipset Family SATA AHCI Controller [8086:1c02] (rev 05) (prog-if 01 [AHCI 1.0])
	Subsystem: Giga-byte Technology Device [1458:b005]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 41
	Region 0: I/O ports at fe00 [size=8]
	Region 1: I/O ports at fd00 [size=4]
	Region 2: I/O ports at fc00 [size=8]
	Region 3: I/O ports at fb00 [size=4]
	Region 4: I/O ports at fa00 [size=32]
	Region 5: Memory at fbffc000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller [8086:1c22] (rev 05)
	Subsystem: Giga-byte Technology Device [1458:5001]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbffb000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 0500 [size=32]
	Kernel driver in use: i801_smbus

02:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 06)
	Subsystem: Giga-byte Technology GA-EP45-DS5 Motherboard [1458:e000]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 42
	Region 0: I/O ports at ee00 [size=256]
	Region 2: Memory at fbeff000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at fbef8000 (64-bit, prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: r8169

03:00.0 PCI bridge [0604]: Integrated Technology Express, Inc. Device [1283:8892] (rev 30) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Bus: primary=03, secondary=04, subordinate=04, sec-latency=32
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000dfa00000-00000000dfafffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

04:00.0 Mass storage controller [0180]: Promise Technology, Inc. PDC20268 [Ultra100 TX2] [105a:4d68] (rev 01) (prog-if 85)
	Subsystem: Promise Technology, Inc. Ultra100 TX2 [105a:4d68]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (1000ns min, 4500ns max), Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at df00 [size=8]
	Region 1: I/O ports at de00 [size=4]
	Region 2: I/O ports at dd00 [size=8]
	Region 3: I/O ports at dc00 [size=4]
	Region 4: I/O ports at db00 [size=16]
	Region 5: Memory at fbdf8000 (32-bit, non-prefetchable) [size=16K]
	[virtual] Expansion ROM at dfa00000 [disabled] [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: pata_pdc2027x

04:01.0 Ethernet controller [0200]: VIA Technologies, Inc. VT6120/VT6121/VT6122 Gigabit Ethernet Adapter [1106:3119] (rev 11)
	Subsystem: ZyXEL Communication Corporation Device [187e:3302]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at fbdff000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel driver in use: via-velocity

05:00.0 USB controller [0c03]: Etron Technology, Inc. EJ168 USB 3.0 Host Controller [1b6f:7023] (rev 01) (prog-if 30 [XHCI])
	Subsystem: Giga-byte Technology Device [1458:5007]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 4 bytes
	Interrupt: pin A routed to IRQ 43
	Region 0: Memory at fbcf8000 (64-bit, non-prefetchable) [size=32K]
	Capabilities: <access denied>
	Kernel driver in use: xhci_hcd


# dmidecode 2.11
SMBIOS 2.4 present.
39 structures occupying 1207 bytes.
Table at 0x000F0100.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Award Software International, Inc.
	Version: F11
	Release Date: 10/12/2011
	Address: 0xE0000
	Runtime Size: 128 kB
	ROM Size: 4096 kB
	Characteristics:
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		5.25"/360 kB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Gigabyte Technology Co., Ltd.
	Product Name: Z68A-D3H-B3
	Version:  
	Serial Number:  
	UUID: 00000000-0000-0000-0000-50E549C02CFA
	Wake-up Type: Power Switch
	SKU Number:  
	Family:  

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer: Gigabyte Technology Co., Ltd.
	Product Name: Z68A-D3H-B3
	Version:  
	Serial Number:  

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer: Gigabyte Technology Co., Ltd.
	Type: Desktop
	Lock: Not Present
	Version:  
	Serial Number:  
	Asset Tag:  
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown
	OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 35 bytes
Processor Information
	Socket Designation: Socket 1155
	Type: Central Processor
	Family: Other
	Manufacturer: Intel
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2700K CPU
	Voltage: 1.0 V
	External Clock: 100 MHz
	Max Speed: 4000 MHz
	Current Speed: 3900 MHz
	Status: Populated, Enabled
	Upgrade: Socket 478
	L1 Cache Handle: 0x000A
	L2 Cache Handle: 0x000B
	L3 Cache Handle: Not Provided
	Serial Number:  
	Asset Tag:  
	Part Number:  

Handle 0x0005, DMI type 5, 24 bytes
Memory Controller Information
	Error Detecting Method: 8-bit Parity
	Error Correcting Capabilities:
		None
	Supported Interleave: One-way Interleave
	Current Interleave: One-way Interleave
	Maximum Memory Module Size: 1024 MB
	Maximum Total Memory Size: 4096 MB
	Supported Speeds:
		Other
	Supported Memory Types:
		Other
	Memory Module Voltage: 5.0 V
	Associated Memory Slots: 4
		0x0006
		0x0007
		0x0008
		0x0009
	Enabled Error Correcting Capabilities:
		None

Handle 0x0006, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A0
	Bank Connections: 1
	Current Speed: Unknown
	Type: Other
	Installed Size: 4096 MB (Single-bank Connection)
	Enabled Size: 4096 MB (Single-bank Connection)
	Error Status: OK

Handle 0x0007, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A1
	Bank Connections: 2
	Current Speed: Unknown
	Type: Other
	Installed Size: 4096 MB (Single-bank Connection)
	Enabled Size: 4096 MB (Single-bank Connection)
	Error Status: OK

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A2
	Bank Connections: 3
	Current Speed: Unknown
	Type: Other
	Installed Size: 4096 MB (Single-bank Connection)
	Enabled Size: 4096 MB (Single-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: A3
	Bank Connections: 4
	Current Speed: Unknown
	Type: Other
	Installed Size: 4096 MB (Single-bank Connection)
	Enabled Size: 4096 MB (Single-bank Connection)
	Error Status: OK

Handle 0x000A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Internal Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 64 kB
	Maximum Size: 64 kB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: External Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8192 kB
	Maximum Size: 2048 kB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: Unknown
	System Type: Unknown
	Associativity: Unknown

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PRIMARY IDE
	Internal Connector Type: On Board IDE
	External Reference Designator:  
	External Connector Type: None
	Port Type: Other

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SECONDARY IDE
	Internal Connector Type: On Board IDE
	External Reference Designator:  
	External Connector Type: None
	Port Type: Other

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FDD
	Internal Connector Type: On Board Floppy
	External Reference Designator:  
	External Connector Type: None
	Port Type: 8251 FIFO Compatible

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator:  
	External Connector Type: DB-9 male
	Port Type: Serial Port 16450 Compatible

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM2
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator:  
	External Connector Type: DB-9 male
	Port Type: Serial Port 16450 Compatible

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LPT1
	Internal Connector Type: DB-25 female
	External Reference Designator:  
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Keyboard
	Internal Connector Type: Other
	External Reference Designator:  
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Mouse
	Internal Connector Type: PS/2
	External Reference Designator: No Detected
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB
	Internal Connector Type: None
	External Reference Designator:  
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0016, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
		SMBus signal is supported

Handle 0x0017, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
		SMBus signal is supported

Handle 0x0018, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 0
	Characteristics:
		5.0 V is provided
		3.3 V is provided
		PME signal is supported
		SMBus signal is supported

Handle 0x0019, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Long
	Installable Languages: 3
		n|US|iso8859-1
		n|US|iso8859-1
		r|CA|iso8859-1
	Currently Installed Language: n|US|iso8859-1

Handle 0x001A, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 32 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x001B, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x001A
	Error Information Handle: Not Provided
	Total Width: 2304 bits
	Data Width: 2052 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: A0
	Bank Locator: Bank0/1
	Type: Unknown
	Type Detail: None
	Speed: 1600 MHz
	Manufacturer:  
	Serial Number:  
	Asset Tag:  
	Part Number:  

Handle 0x001C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x001A
	Error Information Handle: Not Provided
	Total Width: 2304 bits
	Data Width: 2052 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: A1
	Bank Locator: Bank2/3
	Type: Unknown
	Type Detail: None
	Speed: 1600 MHz
	Manufacturer:  
	Serial Number:  
	Asset Tag:  
	Part Number:  

Handle 0x001D, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x001A
	Error Information Handle: Not Provided
	Total Width: 2304 bits
	Data Width: 2052 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: A2
	Bank Locator: Bank4/5
	Type: Unknown
	Type Detail: None
	Speed: 1600 MHz
	Manufacturer:  
	Serial Number:  
	Asset Tag:  
	Part Number:  

Handle 0x001E, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x001A
	Error Information Handle: Not Provided
	Total Width: 2304 bits
	Data Width: 2052 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: A3
	Bank Locator: Bank6/7
	Type: Unknown
	Type Detail: None
	Speed: 1600 MHz
	Manufacturer:  
	Serial Number:  
	Asset Tag:  
	Part Number:  

Handle 0x001F, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x003FFFFFFFF
	Range Size: 16 GB
	Physical Array Handle: 0x001A
	Partition Width: 1

Handle 0x0020, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x001B
	Memory Array Mapped Address Handle: 0x001F
	Partition Row Position: 1

Handle 0x0021, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x001C
	Memory Array Mapped Address Handle: 0x001F
	Partition Row Position: 1

Handle 0x0022, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00200000000
	Ending Address: 0x002FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x001D
	Memory Array Mapped Address Handle: 0x001F
	Partition Row Position: 1

Handle 0x0023, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00300000000
	Ending Address: 0x003FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x001E
	Memory Array Mapped Address Handle: 0x001F
	Partition Row Position: 1

Handle 0x0024, DMI type 32, 11 bytes
System Boot Information
	Status: No errors detected

Handle 0x0025, DMI type 64, 13 bytes
Unknown Type
	Header and Data:
		40 0D 25 00 FF FF FF FF FF FF FF FF FF
	Strings:
		 

Handle 0x0026, DMI type 127, 4 bytes
End Of Table

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
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
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_HAVE_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_TREE_RCU=y
CONFIG_RCU_FANOUT=64
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_NAMESPACES=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BLOCK_COMPAT=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_INLINE_SPIN_UNLOCK=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y
CONFIG_ZONE_DMA=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_SMP=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_NO_BOOTMEM=y
CONFIG_MCORE2=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
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
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_MSR=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
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
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_SECCOMP=y
CONFIG_HZ_300=y
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION="/dev/sdb2"
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_IA32_EMULATION=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_INET=y
CONFIG_NET_IPIP=y
CONFIG_SYN_COOKIES=y
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
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y
CONFIG_HAVE_BPF_JIT=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_EEPROM_LEGACY=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=m
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_IDEDMA_SFF=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_VIA82CXXX=m
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_SCSI_MOD=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_CHR_DEV_SG=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_ATA_BMDMA=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_PDC_OLD=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_MII=y
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_R8169=y
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_VELOCITY=m
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1920
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1080
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_INPUT_MISC=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_SERIAL_8250=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_CORE=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_I801=y
CONFIG_I2C_SCMI=y
CONFIG_PPS=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_POWER_SUPPLY=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_SSB_POSSIBLE=y
CONFIG_BCMA_POSSIBLE=y
CONFIG_MEDIA_SUPPORT=m
CONFIG_RC_CORE=m
CONFIG_LIRC=m
CONFIG_RC_MAP=m
CONFIG_RC_ATI_REMOTE=m
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=4
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SOUND=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_PCI=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=256
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=5
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_USB_HID=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_MON=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_STORAGE=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_EDAC=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_SBRIDGE=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_DRV_CMOS=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_PM_DEVFREQ=y
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_EXT2_FS=y
CONFIG_EXT3_FS=y
CONFIG_EXT4_FS=y
CONFIG_JBD=y
CONFIG_JBD2=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FUSE_FS=m
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
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
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_DEFLATE=y
CONFIG_HAVE_KVM=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
