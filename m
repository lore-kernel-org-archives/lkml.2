Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1B1Bmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 20:42:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:9877 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1B1Bm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 20:42:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,236,1297065600"; 
   d="txt'?scan'208";a="394821291"
Date: Sun, 27 Feb 2011 17:42:18 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: 2.6.38 regression caused by commit 415e12b
Message-ID: <20110228014218.GA11083@xanatos>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm having an issue with an xHCI (USB 3.0 host controller) Express Card.
This card works fine on 2.6.37, but on 2.6.38-rc5, when I plug in the
card, I get this output in dmesg:

Feb 22 16:32:28 xanatos kernel: [  119.345996] irq 23: nobody cared (try booting with the "irqpoll" option)
Feb 22 16:32:28 xanatos kernel: [  119.346002] Pid: 0, comm: kworker/0:0 Not tainted 2.6.38-rc5+ #745
Feb 22 16:32:28 xanatos kernel: [  119.346005] Call Trace:
Feb 22 16:32:28 xanatos kernel: [  119.346007]  <IRQ>  [<ffffffff8109a1f6>] ? __report_bad_irq+0x26/0xa0
Feb 22 16:32:28 xanatos kernel: [  119.346019]  [<ffffffff8109a3fc>] ? note_interrupt+0x18c/0x1d0
Feb 22 16:32:28 xanatos kernel: [  119.346024]  [<ffffffff8109ad7d>] ? handle_fasteoi_irq+0xcd/0x100
Feb 22 16:32:28 xanatos kernel: [  119.346029]  [<ffffffff8100543d>] ? handle_irq+0x1d/0x30
Feb 22 16:32:28 xanatos kernel: [  119.346032]  [<ffffffff81004bb8>] ? do_IRQ+0x58/0xd0
Feb 22 16:32:28 xanatos kernel: [  119.346037]  [<ffffffff8149f5d3>] ? ret_from_intr+0x0/0xe
Feb 22 16:32:28 xanatos kernel: [  119.346040]  <EOI>  [<ffffffff8126f2d0>] ? acpi_idle_enter_c1+0x7e/0x99
Feb 22 16:32:28 xanatos kernel: [  119.346048]  [<ffffffff8126f2b2>] ? acpi_idle_enter_c1+0x60/0x99
Feb 22 16:32:28 xanatos kernel: [  119.346054]  [<ffffffff8138ac92>] ? cpuidle_idle_call+0x82/0xf0
Feb 22 16:32:28 xanatos kernel: [  119.346059]  [<ffffffff81001906>] ? cpu_idle+0x56/0xb0
Feb 22 16:32:28 xanatos kernel: [  119.346064]  [<ffffffff8149861b>] ? start_secondary+0x1c1/0x1c8
Feb 22 16:32:28 xanatos kernel: [  119.346068]  [<ffffffff81263386>] ? acpi_ns_parse_table+0x2e/0x34
Feb 22 16:32:28 xanatos kernel: [  119.346073]  [<ffffffff81267a8c>] ? acpi_load_tables+0x9c/0x15d
Feb 22 16:32:28 xanatos kernel: [  119.346076] handlers:
Feb 22 16:32:28 xanatos kernel: [  119.346078] [<ffffffffa0123500>] (usb_hcd_irq+0x0/0x70 [usbcore])
Feb 22 16:32:28 xanatos kernel: [  119.346100] Disabling IRQ #23

This happens before the xHCI driver has a chance to start PCI
initialization.

I've been trying to bisect this on a slow laptop, so I haven't had a
chance to test with the latest tree from Linus to see if this is already
fixed.  I'll do that later this evening.

I've bisected the issue down to this commit:

415e12b2379239973feab91850b0dce985c6058a is first bad commit
commit 415e12b2379239973feab91850b0dce985c6058a
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Jan 7 00:55:09 2011 +0100

    PCI/ACPI: Request _OSC control once for each root bridge (v3)
    
    Move the evaluation of acpi_pci_osc_control_set() (to request control of
    PCI Express native features) into acpi_pci_root_add() to avoid calling
    it many times for the same root complex with the same arguments.
    Additionally, check if all of the requisite _OSC support bits are set
    before calling acpi_pci_osc_control_set() for a given root complex.
    
    References: https://bugzilla.kernel.org/show_bug.cgi?id=20232
    Reported-by: Ozan Caglayan <ozan@pardus.org.tr>
    Tested-by: Ozan Caglayan <ozan@pardus.org.tr>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

:040000 040000 531c48ec0c23b72f0ca1b5f33828ea63808e4033 7ffa298e34dd842e1f84f0b1fea6dc5af1f70514 M	drivers
:040000 040000 4e484ec0cab0ebc7c82a029c4860802617b7aaf2 01b429bcaeb7b50af04667664cf25453058e803f M	include

lspci from a kernel where the Express Card works is attached.

Sarah Sharp

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci.txt"

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
	Subsystem: Lenovo Device 20e0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
	Subsystem: Lenovo Device 20e4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at f2000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Capabilities: <access denied>
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
	Subsystem: Lenovo Device 20e4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f2400000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>

00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset MEI Controller (rev 07)
	Subsystem: Lenovo Device 20e6
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f2826800 (64-bit, non-prefetchable) [size=16]
	Capabilities: <access denied>

00:03.2 IDE interface: Intel Corporation Mobile 4 Series Chipset PT IDER Controller (rev 07) (prog-if 85 [Master SecO PriO])
	Subsystem: Lenovo Device 20ea
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: I/O ports at 1828 [size=8]
	Region 1: I/O ports at 180c [size=4]
	Region 2: I/O ports at 1820 [size=8]
	Region 3: I/O ports at 1808 [size=4]
	Region 4: I/O ports at 1810 [size=16]
	Capabilities: <access denied>
	Kernel driver in use: ata_generic

00:03.3 Serial controller: Intel Corporation Mobile 4 Series Chipset AMT SOL Redirection (rev 07) (prog-if 02)
	Subsystem: Lenovo Device 20ec
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 0: I/O ports at 1830 [size=8]
	Region 1: Memory at f2624000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
	Subsystem: Lenovo Device 20ee
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at f2600000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f2625000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1840 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1860 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1880 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 4: I/O ports at 18a0 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20)
	Subsystem: Lenovo Device 20f1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at f2826c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
	Subsystem: Lenovo Device 20f2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 46
	Region 0: Memory at f2620000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: c0000000-c01fffff
	Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: f2500000-f25fffff
	Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f0000000-f1ffffff
	Prefetchable memory behind bridge: 00000000f2900000-00000000f29fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18c0 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 18e0 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1c00 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20)
	Subsystem: Lenovo Device 20f1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f2827000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
	Subsystem: Lenovo Device 20f5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03) (prog-if 01)
	Subsystem: Lenovo Device 20f8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 43
	Region 0: I/O ports at 1c48 [size=8]
	Region 1: I/O ports at 183c [size=4]
	Region 2: I/O ports at 1c40 [size=8]
	Region 3: I/O ports at 1838 [size=4]
	Region 4: I/O ports at 1c20 [size=32]
	Region 5: Memory at f2826000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
	Subsystem: Lenovo Device 20f9
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f2827400 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1c60 [size=32]
	Kernel modules: i2c-i801

03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection
	Subsystem: Intel Corporation Device 1211
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at f2500000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

05:00.0 USB Controller: NEC Corporation Device 0194 (rev 03) (prog-if 30)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f0000000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci-hcd


--qMm9M+Fa2AknHoGS--
