Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1CUW2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:28:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:54318 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab1CUW2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:28:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,222,1299484800"; 
   d="txt'?scan'208";a="615873172"
Date: Mon, 21 Mar 2011 15:28:00 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Hot plug issue on 2.6.38
Message-ID: <20110321222705.GA4139@xanatos>
References: <201103052254.48515.rjw@sisk.pl>
 <201103170119.17647.rjw@sisk.pl>
 <AANLkTim39fjrAp4OW_MfpbZkz-YYW5E2NOHuo1j=svmW@mail.gmail.com>
 <201103172222.33336.rjw@sisk.pl>
 <20110317215609.GA5917@xanatos>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <20110317215609.GA5917@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> On Thu, Mar 17, 2011 at 10:22:33PM +0100, Rafael J. Wysocki wrote:
> > On Thursday, March 17, 2011, Yinghai Lu wrote:
> > > her .config does not define PCI_MMCONFIG
> > > 
> > > #
> > > # Bus options (PCI etc.)
> > > #
> > > CONFIG_PCI=y
> > > CONFIG_PCI_DIRECT=y
> > > # CONFIG_PCI_MMCONFIG is not set
> > 
> > Ah, good catch, thanks!
> > 
> > @Sarah: you need to set that for PCI Express to work in general.

I compiled 2.6.38 with CONFIG_PCI_MMCONFIG=y, and I'm no longer getting
"irq nobody cared" messages.  However, PCI express hot plug seems to
just not work for the xHCI PCI device.  Nothing appears in dmesg when I
plug in the Express Card, and the device doesn't appear in lspci.
However, I can get the card to show up if I run

	echo 1 > /sys/bus/pci/rescan

PCI hot-remove doesn't seem to work either.  The xHCI driver notices the
device got removed when the debugging polling loop runs, but the
driver's PCI remove functions are never called.  A rescan of the bus
doesn't help, and the device still shows up in lspci (although all the
registers are read as 0xffff). dmesg and lspci after the device has been
removed is attached.

I've tried turning on all the PCI config options that look relavant; my
.config is attached.  I've turned on PCI debug too.  The only thing that
looks PCI related that I don't have turned on is ACPI_PCI_SLOT.  Do I
need that?

I'm not sure how to debug this hot plug issue further.

Sarah Sharp

--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci-no-hot-remove.txt"

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
	Subsystem: Lenovo Device 20e0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0a <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA controller])
	Subsystem: Lenovo Device 20e4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 46
	Region 0: Memory at f2000000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 41b9
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: i915
	Kernel modules: i915

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
	Subsystem: Lenovo Device 20e4
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f2400000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset MEI Controller (rev 07)
	Subsystem: Lenovo Device 20e6
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f2826800 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

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
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: ata_generic

00:03.3 Serial controller: Intel Corporation Mobile 4 Series Chipset AMT SOL Redirection (rev 07) (prog-if 02 [16550])
	Subsystem: Lenovo Device 20ec
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 11
	Region 0: I/O ports at 1830 [size=8]
	Region 1: Memory at f2624000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
	Subsystem: Lenovo Device 20ee
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at f2600000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f2625000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1840 [size=32]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41b1
	Capabilities: [e0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: e1000e

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1860 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1880 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 22
	Region 4: I/O ports at 18a0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 20f1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at f2826c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
	Subsystem: Lenovo Device 20f2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 47
	Region 0: Memory at f2620000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41c1
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable- ID=0 ArbSelect=Fixed TC/VC=00
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4151
	Capabilities: [90] Subsystem: Lenovo Device 20f3
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=01 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f2500000-f25fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #1, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4159
	Capabilities: [90] Subsystem: Lenovo Device 20f3
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f0000000-f1ffffff
	Prefetchable memory behind bridge: 00000000f2900000-00000000f29fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #3, PowerLimit 6.500W; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq+ LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee0300c  Data: 4161
	Capabilities: [90] Subsystem: Lenovo Device 20f3
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed+ WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
	Capabilities: [180 v1] Root Complex Link
		Desc:	PortNumber=04 ComponentID=02 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=02 AssocRCRB- LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: pcieport
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18c0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 18e0 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Lenovo Device 20f0
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1c00 [size=32]
	Capabilities: [50] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Lenovo Device 20f1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f2827000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) (prog-if 01 [Subtractive decode])
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
	Capabilities: [50] Subsystem: Lenovo Device 20f4

00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
	Subsystem: Lenovo Device 20f5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
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
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
		Address: fee0300c  Data: 4171
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
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
	Subsystem: Intel Corporation WiFi Link 5100 AGN
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at f2500000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000fee0300c  Data: 41a1
	Capabilities: [e0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+ FLReset-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <128ns, L1 <32us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Device Serial Number 00-22-fa-ff-ff-dd-66-a4
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

05:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev ff) (prog-if ff)
	!!! Unknown header type 7f
	Kernel driver in use: xhci_hcd


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"

em 0x000e4000-0x000e7fff] could not be reserved
[    1.079320] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    1.079397] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    1.079475] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.079553] system 00:00: [mem 0x00100000-0xbfffffff] could not be reserved
[    1.079631] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    1.079709] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    1.079765] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.079968] pnp 00:01: [bus 00-ff]
[    1.079978] pnp 00:01: [io  0x0cf8-0x0cff]
[    1.079988] pnp 00:01: [io  0x0000-0x0cf7 window]
[    1.080014] pnp 00:01: [io  0x0d00-0xffff window]
[    1.080024] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    1.080034] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    1.080044] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    1.080053] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    1.080063] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    1.080072] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    1.080082] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    1.080092] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    1.080101] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    1.080111] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    1.080120] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    1.080129] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    1.080139] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    1.080148] pnp 00:01: [mem 0xc0000000-0xfebfffff window]
[    1.080158] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    1.080456] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.102635] pnp 00:02: [io  0x0010-0x001f]
[    1.102646] pnp 00:02: [io  0x0090-0x009f]
[    1.102655] pnp 00:02: [io  0x0024-0x0025]
[    1.102666] pnp 00:02: [io  0x0028-0x0029]
[    1.102675] pnp 00:02: [io  0x002c-0x002d]
[    1.102684] pnp 00:02: [io  0x0030-0x0031]
[    1.102693] pnp 00:02: [io  0x0034-0x0035]
[    1.102702] pnp 00:02: [io  0x0038-0x0039]
[    1.102712] pnp 00:02: [io  0x003c-0x003d]
[    1.102721] pnp 00:02: [io  0x00a4-0x00a5]
[    1.102730] pnp 00:02: [io  0x00a8-0x00a9]
[    1.102739] pnp 00:02: [io  0x00ac-0x00ad]
[    1.102748] pnp 00:02: [io  0x00b0-0x00b5]
[    1.102757] pnp 00:02: [io  0x00b8-0x00b9]
[    1.102766] pnp 00:02: [io  0x00bc-0x00bd]
[    1.102776] pnp 00:02: [io  0x0050-0x0053]
[    1.102785] pnp 00:02: [io  0x0072-0x0077]
[    1.102794] pnp 00:02: [io  0x002e-0x002f]
[    1.102803] pnp 00:02: [io  0x1000-0x107f]
[    1.102813] pnp 00:02: [io  0x1180-0x11ff]
[    1.102822] pnp 00:02: [io  0x0800-0x080f]
[    1.102831] pnp 00:02: [io  0x15e0-0x15ef]
[    1.102841] pnp 00:02: [io  0x1600-0x167f]
[    1.102850] pnp 00:02: [io  0x1680-0x169f]
[    1.102860] pnp 00:02: [mem 0xe0000000-0xefffffff]
[    1.102869] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    1.102879] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    1.102888] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    1.102897] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    1.102906] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    1.103558] system 00:02: [io  0x1000-0x107f] has been reserved
[    1.103631] system 00:02: [io  0x1180-0x11ff] has been reserved
[    1.103704] system 00:02: [io  0x0800-0x080f] has been reserved
[    1.103776] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    1.103848] system 00:02: [io  0x1600-0x167f] has been reserved
[    1.103920] system 00:02: [io  0x1680-0x169f] has been reserved
[    1.103993] system 00:02: [mem 0xe0000000-0xefffffff] has been reserved
[    1.104082] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.104156] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    1.104229] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.104302] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.104375] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    1.104431] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.105056] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.105345] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.105477] pnp 00:04: [io  0x0000-0x000f]
[    1.105487] pnp 00:04: [io  0x0080-0x008f]
[    1.105496] pnp 00:04: [io  0x00c0-0x00df]
[    1.105506] pnp 00:04: [dma 4]
[    1.105792] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.105920] pnp 00:05: [io  0x0061]
[    1.106208] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.106340] pnp 00:06: [io  0x00f0]
[    1.106358] pnp 00:06: [irq 13]
[    1.106646] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.106778] pnp 00:07: [io  0x0070-0x0071]
[    1.106793] pnp 00:07: [irq 8]
[    1.107080] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.107212] pnp 00:08: [io  0x0060]
[    1.107221] pnp 00:08: [io  0x0064]
[    1.107236] pnp 00:08: [irq 1]
[    1.107526] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.107663] pnp 00:09: [irq 12]
[    1.107959] pnp 00:09: Plug and Play ACPI device, IDs IBM3780 PNP0f13 (active)
[    1.130280] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    1.130567] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c31 (active)
[    1.134564] pnp: PnP ACPI: found 11 devices
[    1.134614] ACPI: ACPI bus type pnp unregistered
[    1.156979] pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
[    1.157037] pci 0000:00:1c.0: BAR 7: assigned [io  0x4000-0x4fff]
[    1.157097] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.157149] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    1.157206] pci 0000:00:1c.0:   bridge window [mem disabled]
[    1.157260] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    1.157319] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.157371] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    1.157427] pci 0000:00:1c.1:   bridge window [mem 0xf2500000-0xf25fffff]
[    1.157483] pci 0000:00:1c.1:   bridge window [mem pref disabled]
[    1.157541] pci 0000:00:1c.3: PCI bridge to [bus 05-0c]
[    1.157593] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    1.157649] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf1ffffff]
[    1.157705] pci 0000:00:1c.3:   bridge window [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.157776] pci 0000:00:1e.0: PCI bridge to [bus 0d-0d]
[    1.157826] pci 0000:00:1e.0:   bridge window [io  disabled]
[    1.157881] pci 0000:00:1e.0:   bridge window [mem disabled]
[    1.157935] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.158014] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.158071] pci 0000:00:1c.0: setting latency timer to 64
[    1.158093] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.158149] pci 0000:00:1c.1: setting latency timer to 64
[    1.158171] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    1.158227] pci 0000:00:1c.3: setting latency timer to 64
[    1.158237] pci 0000:00:1e.0: setting latency timer to 64
[    1.158243] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.158246] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.158249] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.158252] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.158255] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.158258] pci_bus 0000:00: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.158261] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    1.158264] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    1.158267] pci_bus 0000:03: resource 1 [mem 0xf2500000-0xf25fffff]
[    1.158270] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    1.158273] pci_bus 0000:05: resource 1 [mem 0xf0000000-0xf1ffffff]
[    1.158276] pci_bus 0000:05: resource 2 [mem 0xf2900000-0xf29fffff 64bit pref]
[    1.158280] pci_bus 0000:0d: resource 4 [io  0x0000-0x0cf7]
[    1.158283] pci_bus 0000:0d: resource 5 [io  0x0d00-0xffff]
[    1.158285] pci_bus 0000:0d: resource 6 [mem 0x000a0000-0x000bffff]
[    1.158288] pci_bus 0000:0d: resource 7 [mem 0x000d4000-0x000d7fff]
[    1.158291] pci_bus 0000:0d: resource 8 [mem 0x000d8000-0x000dbfff]
[    1.158295] pci_bus 0000:0d: resource 9 [mem 0xc0000000-0xfebfffff]
[    1.158432] NET: Registered protocol family 2
[    1.158736] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.159887] IPv4 FIB: Using LC-trie version 0.409
[    1.160567] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.162230] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
[    1.165589] TCP: Hash tables configured (established 262144 bind 65536)
[    1.165677] TCP reno registered
[    1.165749] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    1.166042] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    1.166762] NET: Registered protocol family 1
[    1.166872] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.166878] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.166883] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.166887] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xb1
[    1.166903] pci 0000:00:02.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.166907] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.166911] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.166914] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xb1
[    1.166918] pci 0000:00:02.0: Boot video device
[    1.166932] pci 0000:00:02.1: calling quirk_e100_interrupt+0x0/0x15e
[    1.166936] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.166940] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.166943] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xb1
[    1.166957] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.166961] pci 0000:00:03.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.166965] pci 0000:00:03.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.166968] pci 0000:00:03.0: calling pci_fixup_video+0x0/0xb1
[    1.166983] pci 0000:00:03.2: calling quirk_e100_interrupt+0x0/0x15e
[    1.166987] pci 0000:00:03.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.166990] pci 0000:00:03.2: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.166994] pci 0000:00:03.2: calling pci_fixup_video+0x0/0xb1
[    1.167008] pci 0000:00:03.3: calling quirk_e100_interrupt+0x0/0x15e
[    1.167012] pci 0000:00:03.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.167015] pci 0000:00:03.3: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167019] pci 0000:00:03.3: calling pci_fixup_video+0x0/0xb1
[    1.167033] pci 0000:00:19.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.167037] pci 0000:00:19.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.167041] pci 0000:00:19.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167044] pci 0000:00:19.0: calling pci_fixup_video+0x0/0xb1
[    1.167059] pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.167063] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.167066] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167075] pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.167078] pci 0000:00:1a.0: Performing full reset
[    1.167093] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xb1
[    1.167108] pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x15e
[    1.167112] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.167115] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167124] pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.167126] pci 0000:00:1a.1: Performing full reset
[    1.167141] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xb1
[    1.167156] pci 0000:00:1a.2: calling quirk_e100_interrupt+0x0/0x15e
[    1.167160] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.167164] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167172] pci 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.167174] pci 0000:00:1a.2: Performing full reset
[    1.167189] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xb1
[    1.167205] pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x15e
[    1.167209] pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x30
[    1.167212] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167286] pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xb1
[    1.167301] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.167305] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.167309] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167312] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xb1
[    1.167327] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.167331] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.167334] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167338] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xb1
[    1.167353] pci 0000:00:1c.1: calling quirk_e100_interrupt+0x0/0x15e
[    1.167356] pci 0000:00:1c.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.167360] pci 0000:00:1c.1: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167364] pci 0000:00:1c.1: calling pci_fixup_video+0x0/0xb1
[    1.167379] pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x15e
[    1.167383] pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.167387] pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167390] pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xb1
[    1.167405] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.167409] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.167412] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167421] pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.167423] pci 0000:00:1d.0: Performing full reset
[    1.167439] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xb1
[    1.167454] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x15e
[    1.167458] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x30
[    1.167461] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167469] pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.167472] pci 0000:00:1d.1: Performing full reset
[    1.167487] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xb1
[    1.167502] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x15e
[    1.167506] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.167509] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167517] pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x00c0
[    1.167520] pci 0000:00:1d.2: Performing full reset
[    1.167534] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xb1
[    1.167549] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x15e
[    1.167553] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x30
[    1.167557] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167609] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xb1
[    1.167624] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.167628] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.167631] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167635] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xb1
[    1.167650] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.167654] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.167657] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167661] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xb1
[    1.167677] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x15e
[    1.167680] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x30
[    1.167684] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167687] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xb1
[    1.167702] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x15e
[    1.167706] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x30
[    1.167710] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167714] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xb1
[    1.167728] pci 0000:03:00.0: calling quirk_e100_interrupt+0x0/0x15e
[    1.167732] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    1.167736] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x4fe
[    1.167739] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xb1
[    1.167754] PCI: CLS 64 bytes, default 64
[    1.168139] Trying to unpack rootfs image as initramfs...
[    2.084484] Freeing initrd memory: 32660k freed
[    2.243062] DMA-API: preallocated 32768 debug entries
[    2.243118] DMA-API: debugging enabled by kernel config
[    2.243175] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.243228] Placing 64MB software IO TLB between ffff8800b96a1000 - ffff8800bd6a1000
[    2.243291] software IO TLB at phys 0xb96a1000 - 0xbd6a1000
[    2.243518] Simple Boot Flag at 0x35 set to 0x1
[    2.245695] audit: initializing netlink socket (disabled)
[    2.245824] type=2000 audit(1300745435.240:1): initialized
[    2.266370] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.291786] fuse init (API version 7.16)
[    2.292719] msgmni has been set to 7696
[    2.294082] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.294153] io scheduler noop registered
[    2.294202] io scheduler deadline registered
[    2.294573] io scheduler cfq registered (default)
[    2.294623] start plist test
[    2.295859] end plist test
[    2.296832] pcieport 0000:00:1c.0: setting latency timer to 64
[    2.296913] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    2.297243] pcieport 0000:00:1c.1: setting latency timer to 64
[    2.297318] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    2.297646] pcieport 0000:00:1c.3: setting latency timer to 64
[    2.297720] pcieport 0000:00:1c.3: irq 42 for MSI/MSI-X
[    2.298358] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.299246] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.300087] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.301231] ACPI: AC Adapter [AC] (on-line)
[    2.302625] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.328023] ACPI: Lid Switch [LID]
[    2.328659] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    2.364027] ACPI: Sleep Button [SLPB]
[    2.364684] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    2.364759] ACPI: Power Button [PWRF]
[    2.364996] ACPI: acpi_idle registered with cpuidle
[    2.484532] Monitor-Mwait will be used to enter C-1 state
[    2.484607] Monitor-Mwait will be used to enter C-2 state
[    2.484681] Monitor-Mwait will be used to enter C-3 state
[    2.484693] Marking TSC unstable due to TSC halts in idle
[    2.581904] thermal LNXTHERM:00: registered as thermal_zone0
[    2.581956] ACPI: Thermal Zone [THM0] (62 C)
[    2.591373] thermal LNXTHERM:01: registered as thermal_zone1
[    2.591425] ACPI: Thermal Zone [THM1] (61 C)
[    2.591947] Linux agpgart interface v0.103
[    2.606033] brd: module loaded
[    2.612769] loop: module loaded
[    2.614276] ahci 0000:00:1f.2: version 3.0
[    2.614371] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.614709] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    2.614879] ahci: SSS flag set, parallel bus scan disabled
[    2.614979] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.615088] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc sxs 
[    2.615240] ahci 0000:00:1f.2: setting latency timer to 64
[    2.623575] scsi0 : ahci
[    2.624788] scsi1 : ahci
[    2.625712] scsi2 : ahci
[    2.626692] scsi3 : ahci
[    2.643806] ata1: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826100 irq 43
[    2.643872] ata2: SATA max UDMA/133 abar m2048@0xf2826000 port 0xf2826180 irq 43
[    2.643935] ata3: DUMMY
[    2.643977] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.644075] ACPI: Battery Slot [BAT0] (battery present)
[    2.644137] ata4: DUMMY
[    2.644656] ata_generic 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.644842] ata_generic 0000:00:03.2: setting latency timer to 64
[    2.649342] scsi4 : ata_generic
[    2.650190] scsi5 : ata_generic
[    2.650937] ata5: PATA max UDMA/100 cmd 0x1828 ctl 0x180c bmdma 0x1810 irq 18
[    2.650990] ata6: PATA max UDMA/100 cmd 0x1820 ctl 0x1808 bmdma 0x1818 irq 18
[    2.651271] e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
[    2.651323] e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
[    2.651451] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.651526] e1000e 0000:00:19.0: setting latency timer to 64
[    2.651798] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    2.964041] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.967396] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1f:16:1d:fb:eb
[    2.967448] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.967453] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.967456] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.967587] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.967672] e1000e 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
[    2.967698] ata1.00: ATA-7: INTEL SSDSA2M160G2GC, 2CV102M3, max UDMA/133
[    2.967701] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.968013] PPP generic driver version 2.4.2
[    2.968821] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.971324] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    2.971328] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    2.971395] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.973087] ata1.00: configured for UDMA/133
[    2.979590] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.979964] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.980787] mousedev: PS/2 mouse device common for all mice
[    2.982067] rtc_cmos 00:07: RTC can wake from S4
[    2.986853] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    2.988829] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M160 2CV1 PQ: 0 ANSI: 5
[    2.990579] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    2.991189] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.991592] sd 0:0:0:0: [sda] Write Protect is off
[    2.991643] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.991924] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.995449]  sda: sda1 sda2
[    2.998277] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.004661] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    3.004780] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.004895] Linux video capture interface: v2.00
[    3.005705] device-mapper: uevent: version 1.0.3
[    3.006319] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.006574] device-mapper: multipath: version 1.2.0 loaded
[    3.006639] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.008026] cpuidle: using governor ladder
[    3.009577] cpuidle: using governor menu
[    3.010542] TCP cubic registered
[    3.011781] NET: Registered protocol family 10
[    3.014294] NET: Registered protocol family 17
[    3.014548] Bluetooth: RFCOMM TTY layer initialized
[    3.014618] Bluetooth: RFCOMM socket layer initialized
[    3.014668] Bluetooth: RFCOMM ver 1.11
[    3.014715] Registering the dns_resolver key type
[    3.015847] registered taskstats version 1
[    3.016054] kmemleak: Kernel memory leak detector initialized
[    3.016079] kmemleak: Automatic memory scanning thread started
[    3.018747] rtc_cmos 00:07: setting system clock to 2011-03-21 22:10:36 UTC (1300745436)
[    3.018814] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.018864] EDD information not available.
[    3.308101] ata2: SATA link down (SStatus 0 SControl 300)
[    3.475879] Freeing unused kernel memory: 568k freed
[    3.476179] Write protecting the kernel read-only data: 8192k
[    3.481095] Freeing unused kernel memory: 1264k freed
[    3.481815] Freeing unused kernel memory: 16k freed
[    3.498191] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.516613] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
[    3.985553] usbcore: registered new interface driver usbfs
[    3.986493] usbcore: registered new interface driver hub
[    3.986743] usbcore: registered new device driver usb
[    3.992129] uhci_hcd: USB Universal Host Controller Interface driver
[    3.992354] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.992423] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    3.992483] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.992569] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.992574] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.992714] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    4.001725] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.001781] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    4.001848] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[    4.004394] uhci_hcd 0000:00:1a.0: detected 2 ports
[    4.004450] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.004453] uhci_hcd 0000:00:1a.0: Performing full reset
[    4.004634] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    4.005113] usb usb1: default language 0x0409
[    4.005247] usb usb1: udev 1, busnum 1, minor = 0
[    4.005250] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.005302] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.005363] usb usb1: Product: UHCI Host Controller
[    4.005412] usb usb1: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.005461] usb usb1: SerialNumber: 0000:00:1a.0
[    4.006208] usb usb1: usb_probe_device
[    4.006212] usb usb1: configuration #1 chosen from 1 choice
[    4.006325] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.006704] hub 1-0:1.0: usb_probe_interface
[    4.006707] hub 1-0:1.0: usb_probe_interface - got id
[    4.006711] hub 1-0:1.0: USB hub found
[    4.006858] hub 1-0:1.0: 2 ports detected
[    4.006925] hub 1-0:1.0: standalone hub
[    4.006927] hub 1-0:1.0: no power switching (usb 1.0)
[    4.006929] hub 1-0:1.0: individual port over-current protection
[    4.006932] hub 1-0:1.0: power on to power good time: 2ms
[    4.007036] hub 1-0:1.0: local power source is good
[    4.007051] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.008605] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    4.008690] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.008695] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.008803] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    4.020159] uhci_hcd 0000:00:1a.1: detected 2 ports
[    4.020219] uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.020222] uhci_hcd 0000:00:1a.1: Performing full reset
[    4.020377] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    4.020715] usb usb2: default language 0x0409
[    4.020852] usb usb2: udev 1, busnum 2, minor = 128
[    4.020855] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    4.020907] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.020968] usb usb2: Product: UHCI Host Controller
[    4.021017] usb usb2: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.021066] usb usb2: SerialNumber: 0000:00:1a.1
[    4.021798] usb usb2: usb_probe_device
[    4.021802] usb usb2: configuration #1 chosen from 1 choice
[    4.021878] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[    4.022237] hub 2-0:1.0: usb_probe_interface
[    4.022240] hub 2-0:1.0: usb_probe_interface - got id
[    4.022245] hub 2-0:1.0: USB hub found
[    4.022392] hub 2-0:1.0: 2 ports detected
[    4.022459] hub 2-0:1.0: standalone hub
[    4.022461] hub 2-0:1.0: no power switching (usb 1.0)
[    4.022463] hub 2-0:1.0: individual port over-current protection
[    4.022466] hub 2-0:1.0: power on to power good time: 2ms
[    4.022548] hub 2-0:1.0: local power source is good
[    4.022563] hub 2-0:1.0: trying to enable port power on non-switchable hub
[    4.023839] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.023906] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    4.023978] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    4.024171] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.024176] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.024275] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
[    4.036113] uhci_hcd 0000:00:1a.2: detected 2 ports
[    4.036167] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.036170] uhci_hcd 0000:00:1a.2: Performing full reset
[    4.036341] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    4.036688] usb usb3: default language 0x0409
[    4.036821] usb usb3: udev 1, busnum 3, minor = 256
[    4.036824] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.036876] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.036937] usb usb3: Product: UHCI Host Controller
[    4.036986] usb usb3: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.037036] usb usb3: SerialNumber: 0000:00:1a.2
[    4.037756] usb usb3: usb_probe_device
[    4.037760] usb usb3: configuration #1 chosen from 1 choice
[    4.037835] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[    4.038238] hub 3-0:1.0: usb_probe_interface
[    4.038241] hub 3-0:1.0: usb_probe_interface - got id
[    4.038246] hub 3-0:1.0: USB hub found
[    4.038395] hub 3-0:1.0: 2 ports detected
[    4.038458] hub 3-0:1.0: standalone hub
[    4.038460] hub 3-0:1.0: no power switching (usb 1.0)
[    4.038463] hub 3-0:1.0: individual port over-current protection
[    4.038466] hub 3-0:1.0: power on to power good time: 2ms
[    4.038561] hub 3-0:1.0: local power source is good
[    4.038578] hub 3-0:1.0: trying to enable port power on non-switchable hub
[    4.039930] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.039998] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    4.040091] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.040174] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.040179] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.040816] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    4.052233] uhci_hcd 0000:00:1d.0: detected 2 ports
[    4.052287] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[    4.052289] uhci_hcd 0000:00:1d.0: Performing full reset
[    4.052445] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    4.052783] usb usb4: default language 0x0409
[    4.052919] usb usb4: udev 1, busnum 4, minor = 384
[    4.052922] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    4.052974] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.053036] usb usb4: Product: UHCI Host Controller
[    4.053084] usb usb4: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.053134] usb usb4: SerialNumber: 0000:00:1d.0
[    4.053857] usb usb4: usb_probe_device
[    4.053861] usb usb4: configuration #1 chosen from 1 choice
[    4.053936] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[    4.054294] hub 4-0:1.0: usb_probe_interface
[    4.054297] hub 4-0:1.0: usb_probe_interface - got id
[    4.054301] hub 4-0:1.0: USB hub found
[    4.054448] hub 4-0:1.0: 2 ports detected
[    4.054515] hub 4-0:1.0: standalone hub
[    4.054517] hub 4-0:1.0: no power switching (usb 1.0)
[    4.054520] hub 4-0:1.0: individual port over-current protection
[    4.054522] hub 4-0:1.0: power on to power good time: 2ms
[    4.054604] hub 4-0:1.0: local power source is good
[    4.054618] hub 4-0:1.0: trying to enable port power on non-switchable hub
[    4.055892] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    4.055975] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.055980] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.056107] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
[    4.076108] uhci_hcd 0000:00:1d.1: detected 2 ports
[    4.076163] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[    4.076166] uhci_hcd 0000:00:1d.1: Performing full reset
[    4.076332] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    4.076666] usb usb5: default language 0x0409
[    4.076799] usb usb5: udev 1, busnum 5, minor = 512
[    4.076802] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.076854] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.076916] usb usb5: Product: UHCI Host Controller
[    4.076964] usb usb5: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.077014] usb usb5: SerialNumber: 0000:00:1d.1
[    4.077738] usb usb5: usb_probe_device
[    4.077741] usb usb5: configuration #1 chosen from 1 choice
[    4.077817] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[    4.078175] hub 5-0:1.0: usb_probe_interface
[    4.078178] hub 5-0:1.0: usb_probe_interface - got id
[    4.078183] hub 5-0:1.0: USB hub found
[    4.078329] hub 5-0:1.0: 2 ports detected
[    4.078396] hub 5-0:1.0: standalone hub
[    4.078398] hub 5-0:1.0: no power switching (usb 1.0)
[    4.078400] hub 5-0:1.0: individual port over-current protection
[    4.078403] hub 5-0:1.0: power on to power good time: 2ms
[    4.078484] hub 5-0:1.0: local power source is good
[    4.078499] hub 5-0:1.0: trying to enable port power on non-switchable hub
[    4.079766] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.079850] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.079854] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.079952] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
[    4.092088] uhci_hcd 0000:00:1d.2: detected 2 ports
[    4.092144] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.092147] uhci_hcd 0000:00:1d.2: Performing full reset
[    4.092201] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    4.092546] usb usb6: default language 0x0409
[    4.092680] usb usb6: udev 1, busnum 6, minor = 640
[    4.092683] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.092735] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.092796] usb usb6: Product: UHCI Host Controller
[    4.092844] usb usb6: Manufacturer: Linux 2.6.38+ uhci_hcd
[    4.092894] usb usb6: SerialNumber: 0000:00:1d.2
[    4.093665] usb usb6: usb_probe_device
[    4.093668] usb usb6: configuration #1 chosen from 1 choice
[    4.093742] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[    4.094104] hub 6-0:1.0: usb_probe_interface
[    4.094108] hub 6-0:1.0: usb_probe_interface - got id
[    4.094112] hub 6-0:1.0: USB hub found
[    4.094258] hub 6-0:1.0: 2 ports detected
[    4.094326] hub 6-0:1.0: standalone hub
[    4.094328] hub 6-0:1.0: no power switching (usb 1.0)
[    4.094330] hub 6-0:1.0: individual port over-current protection
[    4.094333] hub 6-0:1.0: power on to power good time: 2ms
[    4.094414] hub 6-0:1.0: local power source is good
[    4.094429] hub 6-0:1.0: trying to enable port power on non-switchable hub
[    4.095789] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.095861] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    4.095919] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    4.096070] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.096075] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.096174] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
[    4.104125] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.104137] hub 1-0:1.0: port 1: status 0301 change 0001
[    4.112236] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.112242] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.112360] ehci_hcd 0000:00:1a.7: debug port 1
[    4.112412] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.116292] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    4.116295] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[    4.116458] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xf2826c00
[    4.116513] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.120533] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    4.120543] hub 2-0:1.0: port 1: status 0101 change 0001
[    4.120599] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.132091] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.132444] usb usb7: default language 0x0409
[    4.132579] usb usb7: udev 1, busnum 7, minor = 768
[    4.132582] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    4.132634] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.132695] usb usb7: Product: EHCI Host Controller
[    4.132744] usb usb7: Manufacturer: Linux 2.6.38+ ehci_hcd
[    4.132793] usb usb7: SerialNumber: 0000:00:1a.7
[    4.133513] usb usb7: usb_probe_device
[    4.133517] usb usb7: configuration #1 chosen from 1 choice
[    4.133594] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[    4.133961] hub 7-0:1.0: usb_probe_interface
[    4.133964] hub 7-0:1.0: usb_probe_interface - got id
[    4.133968] hub 7-0:1.0: USB hub found
[    4.134116] hub 7-0:1.0: 6 ports detected
[    4.134183] hub 7-0:1.0: standalone hub
[    4.134185] hub 7-0:1.0: no power switching (usb 1.0)
[    4.134188] hub 7-0:1.0: individual port over-current protection
[    4.134190] hub 7-0:1.0: power on to power good time: 20ms
[    4.134271] hub 7-0:1.0: local power source is good
[    4.134286] hub 7-0:1.0: trying to enable port power on non-switchable hub
[    4.135490] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[    4.135503] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.1
[    4.135516] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[    4.135725] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.135792] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    4.135862] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    4.136091] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.136096] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.136113] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.136199] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
[    4.152127] uhci_hcd 0000:00:1d.0: port 1 portsc 0093,00
[    4.152138] hub 4-0:1.0: port 1: status 0101 change 0001
[    4.152200] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[    4.152206] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[    4.152336] ehci_hcd 0000:00:1d.7: debug port 1
[    4.152387] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.156268] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.156271] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[    4.156416] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf2827000
[    4.156469] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[    4.160354] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[    4.172024] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.172400] usb usb8: default language 0x0409
[    4.172552] usb usb8: udev 1, busnum 8, minor = 896
[    4.172556] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    4.172609] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.172672] usb usb8: Product: EHCI Host Controller
[    4.172727] usb usb8: Manufacturer: Linux 2.6.38+ ehci_hcd
[    4.172778] usb usb8: SerialNumber: 0000:00:1d.7
[    4.173569] usb usb8: usb_probe_device
[    4.173573] usb usb8: configuration #1 chosen from 1 choice
[    4.173650] usb usb8: adding 8-0:1.0 (config #1, interface 0)
[    4.174046] hub 8-0:1.0: usb_probe_interface
[    4.174049] hub 8-0:1.0: usb_probe_interface - got id
[    4.174054] hub 8-0:1.0: USB hub found
[    4.174196] hub 8-0:1.0: 6 ports detected
[    4.174260] hub 8-0:1.0: standalone hub
[    4.174262] hub 8-0:1.0: no power switching (usb 1.0)
[    4.174265] hub 8-0:1.0: individual port over-current protection
[    4.174268] hub 8-0:1.0: power on to power good time: 20ms
[    4.174362] hub 8-0:1.0: local power source is good
[    4.174379] hub 8-0:1.0: trying to enable port power on non-switchable hub
[    4.175826] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[    4.175842] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[    4.175857] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[    4.176299] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.180832] Monitor-Mwait will be used to enter C-3 state
[    4.192173] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.208227] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
[    4.208266] uhci_hcd 0000:00:1a.0: port 1 portsc 0082,00
[    4.208311] hub 1-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    4.232128] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 001403 0  ACK POWER sig=k CSC CONNECT
[    4.232142] hub 7-0:1.0: port 1: status 0501 change 0001
[    4.232223] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.232235] hub 7-0:1.0: port 3: status 0501 change 0001
[    4.272185] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    4.272198] hub 8-0:1.0: port 1: status 0501 change 0001
[    4.336165] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    4.336177] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0002
[    4.336205] uhci_hcd 0000:00:1a.1: port 1 portsc 0082,00
[    4.336243] hub 2-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    4.464157] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    4.464168] hub 4-0:1.0: state 7 ports 2 chg 0002 evt 0002
[    4.464195] uhci_hcd 0000:00:1d.0: port 1 portsc 0082,00
[    4.464233] hub 4-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
[    4.592157] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100
[    4.592167] hub 7-0:1.0: state 7 ports 6 chg 000a evt 0000
[    4.592199] hub 7-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.592278] ehci_hcd 0000:00:1a.7: port 1 low speed --> companion
[    4.648084] ehci_hcd 0000:00:1a.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.648206] hub 7-0:1.0: port 3, status 0501, change 0000, 480 Mb/s
[    4.704377] ehci_hcd 0000:00:1a.7: port 3 full speed --> companion
[    4.704382] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.704392] hub 7-0:1.0: port 3 not reset yet, waiting 50ms
[    4.760120] ehci_hcd 0000:00:1a.7: GetStatus port:3 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.760216] hub 8-0:1.0: state 7 ports 6 chg 0002 evt 0000
[    4.760244] hub 8-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    4.816381] ehci_hcd 0000:00:1d.7: port 1 full speed --> companion
[    4.816798] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003801 0  ACK POWER OWNER sig=j CONNECT
[    4.816810] hub 8-0:1.0: port 1 not reset yet, waiting 50ms
[    4.872121] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[    4.872217] hub 7-0:1.0: state 7 ports 6 chg 0000 evt 0008
[    4.872249] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    4.872273] uhci_hcd 0000:00:1a.0: port 1 portsc 01a3,00
[    4.872305] hub 1-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
[    5.000103] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
[    5.112076] usb usb5: suspend_rh (auto-stop)
[    5.112107] usb usb6: suspend_rh (auto-stop)
[    5.112109] usb usb3: suspend_rh (auto-stop)
[    5.112188] usb 1-1: new low speed USB device number 2 using uhci_hcd
[    5.269920] usb 1-1: skipped 1 descriptor after interface
[    5.269934] usb 1-1: skipped 1 descriptor after interface
[    5.274900] usb 1-1: default language 0x0409
[    5.289908] usb 1-1: udev 2, busnum 1, minor = 1
[    5.289911] usb 1-1: New USB device found, idVendor=046d, idProduct=c521
[    5.289964] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.290022] usb 1-1: Product: USB Receiver
[    5.290070] usb 1-1: Manufacturer: Logitech
[    5.290638] usb 1-1: usb_probe_device
[    5.290642] usb 1-1: configuration #1 chosen from 1 choice
[    5.300915] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    5.301444] usb 1-1: adding 1-1:1.1 (config #1, interface 1)
[    5.302732] hub 8-0:1.0: state 7 ports 6 chg 0000 evt 0002
[    5.302775] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.302800] uhci_hcd 0000:00:1a.1: port 1 portsc 0093,00
[    5.302834] hub 2-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.315242] usbhid 1-1:1.0: usb_probe_interface
[    5.315247] usbhid 1-1:1.0: usb_probe_interface - got id
[    5.330941] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.0/input/input5
[    5.332336] generic-usb 0003:046D:C521.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1/input0
[    5.332451] usbhid 1-1:1.1: usb_probe_interface
[    5.332454] usbhid 1-1:1.1: usb_probe_interface - got id
[    5.362620] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1:1.1/input/input6
[    5.362745] uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
[    5.363287] usbhid 1-1:1.1: looking for a minor, starting at 96
[    5.364288] generic-usb 0003:046D:C521.0002: input,hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1a.0-1/input1
[    5.364482] usbcore: registered new interface driver usbhid
[    5.364544] usbhid: USB HID core driver
[    5.436132] hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.548105] usb 2-1: new full speed USB device number 2 using uhci_hcd
[    5.680076] usb 2-1: ep0 maxpacket = 8
[    5.706582] usb 2-1: default language 0x0409
[    5.715595] usb 2-1: udev 2, busnum 2, minor = 129
[    5.715598] usb 2-1: New USB device found, idVendor=08ff, idProduct=2810
[    5.715651] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    5.715709] usb 2-1: Product: Fingerprint Sensor
[    5.716336] usb 2-1: usb_probe_device
[    5.716340] usb 2-1: configuration #1 chosen from 1 choice
[    5.717704] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    5.719158] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0002
[    5.719186] uhci_hcd 0000:00:1d.0: port 1 portsc 0093,00
[    5.719221] hub 4-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
[    5.848114] hub 4-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
[    5.960118] usb 4-1: new full speed USB device number 2 using uhci_hcd
[    6.092064] usb 4-1: ep0 maxpacket = 8
[    6.112655] usb 4-1: default language 0x0409
[    6.135663] usb 4-1: udev 2, busnum 4, minor = 385
[    6.135666] usb 4-1: New USB device found, idVendor=04b3, idProduct=301a
[    6.135719] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.135772] usb 4-1: Product: USB 1.1 2port downstream low power hub
[    6.135823] usb 4-1: Manufacturer: Lite-On Technology
[    6.136450] usb 4-1: usb_probe_device
[    6.136454] usb 4-1: configuration #1 chosen from 1 choice
[    6.140682] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
[    6.142812] hub 4-1:1.0: usb_probe_interface
[    6.142817] hub 4-1:1.0: usb_probe_interface - got id
[    6.142822] hub 4-1:1.0: USB hub found
[    6.143660] hub 4-1:1.0: 3 ports detected
[    6.143724] hub 4-1:1.0: compound device; port removable status: FRR
[    6.143727] hub 4-1:1.0: individual port power switching
[    6.143729] hub 4-1:1.0: individual port over-current protection
[    6.143733] hub 4-1:1.0: power on to power good time: 44ms
[    6.144666] hub 4-1:1.0: hub controller current requirement: 100mA
[    6.144669] hub 4-1:1.0: 100mA bus power budget for each child
[    6.145677] hub 4-1:1.0: enabling power on all ports
[    6.249685] hub 4-1:1.0: port 1: status 0101 change 0001
[    6.352141] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[    6.352175] hub 4-1:1.0: state 7 ports 3 chg 0002 evt 0000
[    6.353667] hub 4-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    6.425664] usb 4-1.1: new full speed USB device number 3 using uhci_hcd
[    6.520065] usb 4-1.1: ep0 maxpacket = 8
[    6.541673] usb 4-1.1: skipped 1 descriptor after interface
[    6.541685] usb 4-1.1: skipped 1 descriptor after interface
[    6.544650] usb 4-1.1: default language 0x0409
[    6.571660] usb 4-1.1: udev 3, busnum 4, minor = 386
[    6.571663] usb 4-1.1: New USB device found, idVendor=04b3, idProduct=301b
[    6.571717] usb 4-1.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[    6.571780] usb 4-1.1: Product: USB Productivity Option Keyboard( has the hub in # 1 )
[    6.571848] usb 4-1.1: Manufacturer: Lite-On Technology
[    6.572489] usb 4-1.1: usb_probe_device
[    6.572492] usb 4-1.1: configuration #1 chosen from 1 choice
[    6.576682] usb 4-1.1: adding 4-1.1:1.0 (config #1, interface 0)
[    6.578812] usbhid 4-1.1:1.0: usb_probe_interface
[    6.578816] usbhid 4-1.1:1.0: usb_probe_interface - got id
[    6.589076] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.1/4-1.1:1.0/input/input7
[    6.589210] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 17 us
[    6.590283] generic-usb 0003:04B3:301B.0003: input,hidraw2: USB HID v1.10 Keyboard [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-1.1/input0
[    6.590642] usb 4-1.1: adding 4-1.1:1.1 (config #1, interface 1)
[    6.592994] usbhid 4-1.1:1.1: usb_probe_interface
[    6.592998] usbhid 4-1.1:1.1: usb_probe_interface - got id
[    6.597901] input: Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 ) as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.1/4-1.1:1.1/input/input8
[    6.598032] uhci_hcd 0000:00:1d.0: reserve dev 3 ep82-INT, period 128, phase 0, 14 us
[    6.599072] generic-usb 0003:04B3:301B.0004: input,hidraw3: USB HID v1.10 Device [Lite-On Technology USB Productivity Option Keyboard( has the hub in # 1 )] on usb-0000:00:1d.0-1.1/input1
[    6.600085] hub 4-1:1.0: 356mA power budget left
[    6.600090] hub 4-1:1.0: state 7 ports 3 chg 0000 evt 0002
[    6.808108] hub 3-0:1.0: hub_suspend
[    6.808149] usb usb3: bus auto-suspend
[    6.808152] usb usb3: suspend_rh
[    6.808173] hub 5-0:1.0: hub_suspend
[    6.808180] usb usb5: bus auto-suspend
[    6.808183] usb usb5: suspend_rh
[    6.808202] hub 6-0:1.0: hub_suspend
[    6.808208] usb usb6: bus auto-suspend
[    6.808211] usb usb6: suspend_rh
[    6.872100] hub 7-0:1.0: hub_suspend
[    6.872109] usb usb7: bus auto-suspend
[    6.872112] ehci_hcd 0000:00:1a.7: suspend root hub
[    7.808068] hub 8-0:1.0: hub_suspend
[    7.808075] usb usb8: bus auto-suspend
[    7.808078] ehci_hcd 0000:00:1d.7: suspend root hub
[    8.768140] EXT3-fs: barriers not enabled
[    8.768679] kjournald starting.  Commit interval 5 seconds
[    8.768841] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   14.094145] Adding 1871568k swap on /dev/sda2.  Priority:-1 extents:1 across:1871568k SS
[   14.137613] EXT3-fs (sda1): using internal journal
[   14.214068] udev[2713]: starting version 163
[   14.579173] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[   14.579681] agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[   14.602808] agpgart-intel 0000:00:00.0: detected 32768K stolen memory
[   14.615369] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[   14.885694] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   14.910867] uhci_hcd 0000:00:1a.0: release dev 2 ep81-INT, period 8, phase 4, 118 us
[   15.226091] cfg80211: Calling CRDA to update world regulatory domain
[   15.307829] sshd (2894): /proc/2894/oom_adj is deprecated, please use /proc/2894/oom_score_adj instead.
[   15.329205] cfg80211: World regulatory domain updated:
[   15.329209] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   15.329213] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.329216] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.329220] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.329223] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.329227] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.344610] [drm] Initialized drm 1.1.0 20060810
[   15.638163] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.638187] i915 0000:00:02.0: power state changed by ACPI to D0
[   15.638197] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.638203] i915 0000:00:02.0: setting latency timer to 64
[   15.726982] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[   15.726985] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[   15.727188] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.727198] iwlagn 0000:03:00.0: setting latency timer to 64
[   15.727275] iwlagn 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
[   15.788840] iwlagn 0000:03:00.0: device EEPROM VER=0x11f, CALIB=0x4
[   15.788844] iwlagn 0000:03:00.0: Device SKU: 0Xb
[   15.788889] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[   15.789015] iwlagn 0000:03:00.0: irq 45 for MSI/MSI-X
[   15.818164] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-5.ucode' failed.
[   15.838686] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.841827] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-4.ucode' failed.
[   15.880324] iwlagn 0000:03:00.0: request for firmware file 'iwlwifi-5000-3.ucode' failed.
[   15.892219] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   15.893116] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.904517] iwlagn 0000:03:00.0: Firmware has old API version. Expected v5, got v2. New firmware can be obtained from http://www.intellinuxwireless.org.
[   15.904595] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[   15.905253] Registered led device: phy0-led
[   15.976989] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[   16.046457] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[   16.046567] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   16.046569] [drm] Driver supports precise vblank timestamp query.
[   16.316710] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   16.920496] fb0: inteldrmfb frame buffer device
[   16.920499] drm: registered panic notifier
[   17.059270] acpi device:02: registered as cooling_device2
[   17.063949] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input9
[   17.064895] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   17.066751] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   17.066895] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   17.067043] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[   17.067228] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   17.220835] Console: switching to colour frame buffer device 180x56
[   18.940962] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   18.941436] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.948313] uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 8, phase 4, 118 us
[   29.456072] eth0: no IPv6 routers present
[   73.120555] pci_bus 0000:00: scanning bus
[   73.120691] pcieport 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 0
[   73.120699] pci_bus 0000:02: scanning bus
[   73.120704] pci_bus 0000:02: bus scan returning with max=02
[   73.120711] pcieport 0000:00:1c.1: scanning [bus 03-03] behind bridge, pass 0
[   73.120718] pci_bus 0000:03: scanning bus
[   73.120722] pci_bus 0000:03: bus scan returning with max=03
[   73.120729] pcieport 0000:00:1c.3: scanning [bus 05-0c] behind bridge, pass 0
[   73.120736] pci_bus 0000:05: scanning bus
[   73.120803] pci 0000:05:00.0: [1033:0194] type 0 class 0x000c03
[   73.120815] pci 0000:05:00.0: calling quirk_mmio_always_on+0x0/0x17
[   73.120857] pci 0000:05:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
[   73.120964] pci 0000:05:00.0: calling quirk_resource_alignment+0x0/0x169
[   73.121046] pci 0000:05:00.0: PME# supported from D0 D3hot
[   73.121056] pci 0000:05:00.0: PME# disabled
[   73.121132] pci_bus 0000:05: bus scan returning with max=05
[   73.121139] pci 0000:00:1e.0: scanning [bus 0d-0d] behind bridge, pass 0
[   73.121146] pci_bus 0000:0d: scanning bus
[   73.121227] pci_bus 0000:0d: bus scan returning with max=0d
[   73.121234] pcieport 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 1
[   73.121245] pcieport 0000:00:1c.1: scanning [bus 03-03] behind bridge, pass 1
[   73.121255] pcieport 0000:00:1c.3: scanning [bus 05-0c] behind bridge, pass 1
[   73.121265] pci 0000:00:1e.0: scanning [bus 0d-0d] behind bridge, pass 1
[   73.121274] pci_bus 0000:00: bus scan returning with max=0d
[   73.121325] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[   73.121346] pci 0000:05:00.0: BAR 0: assigned [mem 0xf0000000-0xf0001fff 64bit]
[   73.121361] pci 0000:05:00.0: BAR 0: set to [mem 0xf0000000-0xf0001fff 64bit] (PCI address [0xf0000000-0xf0001fff])
[   73.128263] xhci_hcd 0000:05:00.0: enabling device (0000 -> 0002)
[   73.128275] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   73.128396] xhci_hcd 0000:05:00.0: enabling bus mastering
[   73.128405] xhci_hcd 0000:05:00.0: setting latency timer to 64
[   73.128410] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   73.128477] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 9
[   73.144359] xhci_hcd 0000:05:00.0: xHCI capability registers at ffffc900043d8000:
[   73.144365] xhci_hcd 0000:05:00.0: CAPLENGTH AND HCIVERSION 0x960020:
[   73.144369] xhci_hcd 0000:05:00.0: CAPLENGTH: 0x20
[   73.144371] xhci_hcd 0000:05:00.0: HCIVERSION: 0x96
[   73.144376] xhci_hcd 0000:05:00.0: HCSPARAMS 1: 0x4000820
[   73.144379] xhci_hcd 0000:05:00.0:   Max device slots: 32
[   73.144381] xhci_hcd 0000:05:00.0:   Max interrupters: 8
[   73.144384] xhci_hcd 0000:05:00.0:   Max ports: 4
[   73.144389] xhci_hcd 0000:05:00.0: HCSPARAMS 2: 0x11
[   73.144391] xhci_hcd 0000:05:00.0:   Isoc scheduling threshold: 1
[   73.144394] xhci_hcd 0000:05:00.0:   Maximum allowed segments in event ring: 1
[   73.144399] xhci_hcd 0000:05:00.0: HCSPARAMS 3 0x0:
[   73.144401] xhci_hcd 0000:05:00.0:   Worst case U1 device exit latency: 0
[   73.144404] xhci_hcd 0000:05:00.0:   Worst case U2 device exit latency: 0
[   73.144409] xhci_hcd 0000:05:00.0: HCC PARAMS 0x14042cb:
[   73.144412] xhci_hcd 0000:05:00.0:   HC generates 64 bit addresses
[   73.144414] xhci_hcd 0000:05:00.0:   FIXME: more HCCPARAMS debugging
[   73.144419] xhci_hcd 0000:05:00.0: RTSOFF 0x600:
[   73.144422] xhci_hcd 0000:05:00.0: xHCI operational registers at ffffc900043d8020:
[   73.144427] xhci_hcd 0000:05:00.0: USBCMD 0x0:
[   73.144429] xhci_hcd 0000:05:00.0:   HC is being stopped
[   73.144432] xhci_hcd 0000:05:00.0:   HC has finished hard reset
[   73.144434] xhci_hcd 0000:05:00.0:   Event Interrupts disabled
[   73.144437] xhci_hcd 0000:05:00.0:   Host System Error Interrupts disabled
[   73.144440] xhci_hcd 0000:05:00.0:   HC has finished light reset
[   73.144445] xhci_hcd 0000:05:00.0: USBSTS 0x1:
[   73.144447] xhci_hcd 0000:05:00.0:   Event ring is empty
[   73.144450] xhci_hcd 0000:05:00.0:   No Host System Error
[   73.144452] xhci_hcd 0000:05:00.0:   HC is halted
[   73.144457] xhci_hcd 0000:05:00.0: ffffc900043d8420 port status reg = 0x2a0
[   73.144463] xhci_hcd 0000:05:00.0: ffffc900043d8424 port power reg = 0x0
[   73.144468] xhci_hcd 0000:05:00.0: ffffc900043d8428 port link reg = 0x0
[   73.144473] xhci_hcd 0000:05:00.0: ffffc900043d842c port reserved reg = 0x0
[   73.144478] xhci_hcd 0000:05:00.0: ffffc900043d8430 port status reg = 0x2a0
[   73.144484] xhci_hcd 0000:05:00.0: ffffc900043d8434 port power reg = 0x0
[   73.144489] xhci_hcd 0000:05:00.0: ffffc900043d8438 port link reg = 0x0
[   73.144494] xhci_hcd 0000:05:00.0: ffffc900043d843c port reserved reg = 0x0
[   73.144499] xhci_hcd 0000:05:00.0: ffffc900043d8440 port status reg = 0x2a0
[   73.144504] xhci_hcd 0000:05:00.0: ffffc900043d8444 port power reg = 0x0
[   73.144509] xhci_hcd 0000:05:00.0: ffffc900043d8448 port link reg = 0x0
[   73.144514] xhci_hcd 0000:05:00.0: ffffc900043d844c port reserved reg = 0x0
[   73.144519] xhci_hcd 0000:05:00.0: ffffc900043d8450 port status reg = 0x2a0
[   73.144524] xhci_hcd 0000:05:00.0: ffffc900043d8454 port power reg = 0x0
[   73.144529] xhci_hcd 0000:05:00.0: ffffc900043d8458 port link reg = 0x0
[   73.144534] xhci_hcd 0000:05:00.0: ffffc900043d845c port reserved reg = 0x0
[   73.144538] xhci_hcd 0000:05:00.0: // Halt the HC
[   73.144544] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8020, 32'h0, 4'hf);
[   73.144550] xhci_hcd 0000:05:00.0: Resetting HCD
[   73.144554] xhci_hcd 0000:05:00.0: // Reset the HC
[   73.144559] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8020, 32'h2, 4'hf);
[   73.144606] xhci_hcd 0000:05:00.0: Wait for controller to be ready for doorbell rings
[   73.144611] xhci_hcd 0000:05:00.0: Reset complete
[   73.144615] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[   73.144618] xhci_hcd 0000:05:00.0: Calling HCD init
[   73.144620] xhci_hcd 0000:05:00.0: xhci_init
[   73.144623] xhci_hcd 0000:05:00.0: xHCI doesn't need link TRB QUIRK
[   73.144628] xhci_hcd 0000:05:00.0: Supported page size register = 0x1
[   73.144631] xhci_hcd 0000:05:00.0: Supported page size of 4K
[   73.144634] xhci_hcd 0000:05:00.0: HCD page size set to 4K
[   73.144639] xhci_hcd 0000:05:00.0: // xHC can handle at most 32 device slots.
[   73.144644] xhci_hcd 0000:05:00.0: // Setting Max device slots reg = 0x20.
[   73.144647] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8058, 32'h20, 4'hf);
[   73.144663] xhci_hcd 0000:05:00.0: // Device context base array address = 0x3780c000 (DMA), ffff88003780c000 (virt)
[   73.144667] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900043d8050, 64'h3780c000, 4'hf);
[   73.144739] xhci_hcd 0000:05:00.0: Allocating ring at ffff880131e53d80
[   73.144754] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff88012a0def60
[   73.144782] xhci_hcd 0000:05:00.0: // Allocating segment at ffff88003780d000 (virtual) 0x3780d000 (DMA)
[   73.144788] xhci_hcd 0000:05:00.0: Linking segment 0x3780d000 to segment 0x3780d000 (DMA)
[   73.144792] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment ffff88012a0def60 (virtual), 0x3780d000 (DMA)
[   73.144795] xhci_hcd 0000:05:00.0: Allocated command ring at ffff880131e53d80
[   73.144798] xhci_hcd 0000:05:00.0: First segment DMA is 0x3780d000
[   73.144805] xhci_hcd 0000:05:00.0: // Setting command ring address to 0x20
[   73.144808] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900043d8038, 64'h3780d001, 4'hf);
[   73.144815] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[   73.144818] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[   73.144823] xhci_hcd 0000:05:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
[   73.144827] xhci_hcd 0000:05:00.0: // xHCI capability registers at ffffc900043d8000:
[   73.144832] xhci_hcd 0000:05:00.0: // @ffffc900043d8000 = 0x960020 (CAPLENGTH AND HCIVERSION)
[   73.144835] xhci_hcd 0000:05:00.0: //   CAPLENGTH: 0x20
[   73.144837] xhci_hcd 0000:05:00.0: // xHCI operational registers at ffffc900043d8020:
[   73.144842] xhci_hcd 0000:05:00.0: // @ffffc900043d8018 = 0x600 RTSOFF
[   73.144845] xhci_hcd 0000:05:00.0: // xHCI runtime registers at ffffc900043d8600:
[   73.144851] xhci_hcd 0000:05:00.0: // @ffffc900043d8014 = 0x800 DBOFF
[   73.144853] xhci_hcd 0000:05:00.0: // Doorbell array at ffffc900043d8800:
[   73.144856] xhci_hcd 0000:05:00.0: xHCI runtime registers at ffffc900043d8600:
[   73.144861] xhci_hcd 0000:05:00.0:   ffffc900043d8600: Microframe index = 0x0
[   73.144876] xhci_hcd 0000:05:00.0: // Allocating event ring
[   73.144892] xhci_hcd 0000:05:00.0: Allocating ring at ffff880131e53c60
[   73.144907] xhci_hcd 0000:05:00.0: Allocating priv segment structure at ffff88012a0de640
[   73.144911] xhci_hcd 0000:05:00.0: // Allocating segment at ffff88003780d400 (virtual) 0x3780d400 (DMA)
[   73.144915] xhci_hcd 0000:05:00.0: Linking segment 0x3780d400 to segment 0x3780d400 (DMA)
[   73.144919] xhci_hcd 0000:05:00.0: TRB math tests passed.
[   73.144932] xhci_hcd 0000:05:00.0: // Allocated event ring segment table at 0x3780e000
[   73.144936] xhci_hcd 0000:05:00.0: Set ERST to 0; private num segs = 1, virt addr = ffff88003780e000, dma addr = 0x3780e000
[   73.144942] xhci_hcd 0000:05:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
[   73.144945] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8628, 32'h1, 4'hf);
[   73.144948] xhci_hcd 0000:05:00.0: // Set ERST entries to point to event ring.
[   73.144951] xhci_hcd 0000:05:00.0: // Set ERST base address for ir_set 0 = 0x3780e000
[   73.144958] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900043d8630, 64'h3780e000, 4'hf);
[   73.144966] xhci_hcd 0000:05:00.0: // Write event ring dequeue pointer, preserving EHB bit
[   73.144969] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900043d8638, 64'h3780d400, 4'hf);
[   73.144972] xhci_hcd 0000:05:00.0: Wrote ERST address to ir_set 0.
[   73.144977] xhci_hcd 0000:05:00.0: Allocating 0 scratchpad buffers
[   73.145001] xhci_hcd 0000:05:00.0: Ext Cap ffffc900043d8510, port offset = 1, count = 2, revision = 0x3
[   73.145008] xhci_hcd 0000:05:00.0: Ext Cap ffffc900043d8520, port offset = 3, count = 2, revision = 0x2
[   73.145012] xhci_hcd 0000:05:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
[   73.145028] xhci_hcd 0000:05:00.0: USB 2.0 port at index 2, addr = ffffc900043d8440
[   73.145031] xhci_hcd 0000:05:00.0: USB 2.0 port at index 3, addr = ffffc900043d8450
[   73.145045] xhci_hcd 0000:05:00.0: USB 3.0 port at index 0, addr = ffffc900043d8420
[   73.145048] xhci_hcd 0000:05:00.0: USB 3.0 port at index 1, addr = ffffc900043d8430
[   73.145051] xhci_hcd 0000:05:00.0: Finished xhci_init
[   73.145053] xhci_hcd 0000:05:00.0: Called HCD init
[   73.145059] xhci_hcd 0000:05:00.0: Got SBRN 48
[   73.145073] xhci_hcd 0000:05:00.0: enabling Mem-Wr-Inval
[   73.145079] xhci_hcd 0000:05:00.0: MWI active
[   73.145081] xhci_hcd 0000:05:00.0: Finished xhci_pci_reinit
[   73.145084] xhci_hcd 0000:05:00.0: supports USB remote wakeup
[   73.145136] xhci_hcd 0000:05:00.0: irq 19, io mem 0xf0000000
[   73.145139] xhci_hcd 0000:05:00.0: xhci_run
[   73.145322] xhci_hcd 0000:05:00.0: irq 48 for MSI/MSI-X
[   73.145328] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[   73.145334] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[   73.145938] xhci_hcd 0000:05:00.0: Setting event ring polling timer
[   73.145942] xhci_hcd 0000:05:00.0: Command ring memory map follows:
[   73.145946] xhci_hcd 0000:05:00.0: @3780d000 00000000 00000000 00000000 00000000
[   73.145950] xhci_hcd 0000:05:00.0: @3780d010 00000000 00000000 00000000 00000000
[   73.145954] xhci_hcd 0000:05:00.0: @3780d020 00000000 00000000 00000000 00000000
[   73.145958] xhci_hcd 0000:05:00.0: @3780d030 00000000 00000000 00000000 00000000
[   73.145961] xhci_hcd 0000:05:00.0: @3780d040 00000000 00000000 00000000 00000000
[   73.145965] xhci_hcd 0000:05:00.0: @3780d050 00000000 00000000 00000000 00000000
[   73.145969] xhci_hcd 0000:05:00.0: @3780d060 00000000 00000000 00000000 00000000
[   73.145973] xhci_hcd 0000:05:00.0: @3780d070 00000000 00000000 00000000 00000000
[   73.145977] xhci_hcd 0000:05:00.0: @3780d080 00000000 00000000 00000000 00000000
[   73.145980] xhci_hcd 0000:05:00.0: @3780d090 00000000 00000000 00000000 00000000
[   73.145984] xhci_hcd 0000:05:00.0: @3780d0a0 00000000 00000000 00000000 00000000
[   73.145988] xhci_hcd 0000:05:00.0: @3780d0b0 00000000 00000000 00000000 00000000
[   73.145992] xhci_hcd 0000:05:00.0: @3780d0c0 00000000 00000000 00000000 00000000
[   73.145996] xhci_hcd 0000:05:00.0: @3780d0d0 00000000 00000000 00000000 00000000
[   73.146000] xhci_hcd 0000:05:00.0: @3780d0e0 00000000 00000000 00000000 00000000
[   73.146003] xhci_hcd 0000:05:00.0: @3780d0f0 00000000 00000000 00000000 00000000
[   73.146007] xhci_hcd 0000:05:00.0: @3780d100 00000000 00000000 00000000 00000000
[   73.146011] xhci_hcd 0000:05:00.0: @3780d110 00000000 00000000 00000000 00000000
[   73.146015] xhci_hcd 0000:05:00.0: @3780d120 00000000 00000000 00000000 00000000
[   73.146019] xhci_hcd 0000:05:00.0: @3780d130 00000000 00000000 00000000 00000000
[   73.146023] xhci_hcd 0000:05:00.0: @3780d140 00000000 00000000 00000000 00000000
[   73.146027] xhci_hcd 0000:05:00.0: @3780d150 00000000 00000000 00000000 00000000
[   73.146030] xhci_hcd 0000:05:00.0: @3780d160 00000000 00000000 00000000 00000000
[   73.146034] xhci_hcd 0000:05:00.0: @3780d170 00000000 00000000 00000000 00000000
[   73.146038] xhci_hcd 0000:05:00.0: @3780d180 00000000 00000000 00000000 00000000
[   73.146042] xhci_hcd 0000:05:00.0: @3780d190 00000000 00000000 00000000 00000000
[   73.146046] xhci_hcd 0000:05:00.0: @3780d1a0 00000000 00000000 00000000 00000000
[   73.146050] xhci_hcd 0000:05:00.0: @3780d1b0 00000000 00000000 00000000 00000000
[   73.146053] xhci_hcd 0000:05:00.0: @3780d1c0 00000000 00000000 00000000 00000000
[   73.146057] xhci_hcd 0000:05:00.0: @3780d1d0 00000000 00000000 00000000 00000000
[   73.146061] xhci_hcd 0000:05:00.0: @3780d1e0 00000000 00000000 00000000 00000000
[   73.146065] xhci_hcd 0000:05:00.0: @3780d1f0 00000000 00000000 00000000 00000000
[   73.146069] xhci_hcd 0000:05:00.0: @3780d200 00000000 00000000 00000000 00000000
[   73.146073] xhci_hcd 0000:05:00.0: @3780d210 00000000 00000000 00000000 00000000
[   73.146077] xhci_hcd 0000:05:00.0: @3780d220 00000000 00000000 00000000 00000000
[   73.146081] xhci_hcd 0000:05:00.0: @3780d230 00000000 00000000 00000000 00000000
[   73.146085] xhci_hcd 0000:05:00.0: @3780d240 00000000 00000000 00000000 00000000
[   73.146088] xhci_hcd 0000:05:00.0: @3780d250 00000000 00000000 00000000 00000000
[   73.146092] xhci_hcd 0000:05:00.0: @3780d260 00000000 00000000 00000000 00000000
[   73.146096] xhci_hcd 0000:05:00.0: @3780d270 00000000 00000000 00000000 00000000
[   73.146100] xhci_hcd 0000:05:00.0: @3780d280 00000000 00000000 00000000 00000000
[   73.146104] xhci_hcd 0000:05:00.0: @3780d290 00000000 00000000 00000000 00000000
[   73.146108] xhci_hcd 0000:05:00.0: @3780d2a0 00000000 00000000 00000000 00000000
[   73.146111] xhci_hcd 0000:05:00.0: @3780d2b0 00000000 00000000 00000000 00000000
[   73.146115] xhci_hcd 0000:05:00.0: @3780d2c0 00000000 00000000 00000000 00000000
[   73.146119] xhci_hcd 0000:05:00.0: @3780d2d0 00000000 00000000 00000000 00000000
[   73.146123] xhci_hcd 0000:05:00.0: @3780d2e0 00000000 00000000 00000000 00000000
[   73.146127] xhci_hcd 0000:05:00.0: @3780d2f0 00000000 00000000 00000000 00000000
[   73.146130] xhci_hcd 0000:05:00.0: @3780d300 00000000 00000000 00000000 00000000
[   73.146134] xhci_hcd 0000:05:00.0: @3780d310 00000000 00000000 00000000 00000000
[   73.146138] xhci_hcd 0000:05:00.0: @3780d320 00000000 00000000 00000000 00000000
[   73.146142] xhci_hcd 0000:05:00.0: @3780d330 00000000 00000000 00000000 00000000
[   73.146146] xhci_hcd 0000:05:00.0: @3780d340 00000000 00000000 00000000 00000000
[   73.146150] xhci_hcd 0000:05:00.0: @3780d350 00000000 00000000 00000000 00000000
[   73.146154] xhci_hcd 0000:05:00.0: @3780d360 00000000 00000000 00000000 00000000
[   73.146157] xhci_hcd 0000:05:00.0: @3780d370 00000000 00000000 00000000 00000000
[   73.146161] xhci_hcd 0000:05:00.0: @3780d380 00000000 00000000 00000000 00000000
[   73.146165] xhci_hcd 0000:05:00.0: @3780d390 00000000 00000000 00000000 00000000
[   73.146169] xhci_hcd 0000:05:00.0: @3780d3a0 00000000 00000000 00000000 00000000
[   73.146173] xhci_hcd 0000:05:00.0: @3780d3b0 00000000 00000000 00000000 00000000
[   73.146176] xhci_hcd 0000:05:00.0: @3780d3c0 00000000 00000000 00000000 00000000
[   73.146180] xhci_hcd 0000:05:00.0: @3780d3d0 00000000 00000000 00000000 00000000
[   73.146184] xhci_hcd 0000:05:00.0: @3780d3e0 00000000 00000000 00000000 00000000
[   73.146188] xhci_hcd 0000:05:00.0: @3780d3f0 3780d000 00000000 00000000 00001802
[   73.146191] xhci_hcd 0000:05:00.0:   Ring has not been updated
[   73.146195] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d000 (virt), 0x3780d000 (dma)
[   73.146198] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[   73.146201] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d000 (virt), 0x3780d000 (dma)
[   73.146204] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   73.146210] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[   73.146213] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[   73.146216] xhci_hcd 0000:05:00.0: ERST memory map follows:
[   73.146219] xhci_hcd 0000:05:00.0: @3780e000 3780d400 00000000 00000040 00000000
[   73.146222] xhci_hcd 0000:05:00.0: Event ring:
[   73.146225] xhci_hcd 0000:05:00.0: @3780d400 00000000 00000000 00000000 00000000
[   73.146229] xhci_hcd 0000:05:00.0: @3780d410 00000000 00000000 00000000 00000000
[   73.146233] xhci_hcd 0000:05:00.0: @3780d420 00000000 00000000 00000000 00000000
[   73.146237] xhci_hcd 0000:05:00.0: @3780d430 00000000 00000000 00000000 00000000
[   73.146241] xhci_hcd 0000:05:00.0: @3780d440 00000000 00000000 00000000 00000000
[   73.146244] xhci_hcd 0000:05:00.0: @3780d450 00000000 00000000 00000000 00000000
[   73.146248] xhci_hcd 0000:05:00.0: @3780d460 00000000 00000000 00000000 00000000
[   73.146252] xhci_hcd 0000:05:00.0: @3780d470 00000000 00000000 00000000 00000000
[   73.146256] xhci_hcd 0000:05:00.0: @3780d480 00000000 00000000 00000000 00000000
[   73.146260] xhci_hcd 0000:05:00.0: @3780d490 00000000 00000000 00000000 00000000
[   73.146263] xhci_hcd 0000:05:00.0: @3780d4a0 00000000 00000000 00000000 00000000
[   73.146267] xhci_hcd 0000:05:00.0: @3780d4b0 00000000 00000000 00000000 00000000
[   73.146271] xhci_hcd 0000:05:00.0: @3780d4c0 00000000 00000000 00000000 00000000
[   73.146275] xhci_hcd 0000:05:00.0: @3780d4d0 00000000 00000000 00000000 00000000
[   73.146279] xhci_hcd 0000:05:00.0: @3780d4e0 00000000 00000000 00000000 00000000
[   73.146283] xhci_hcd 0000:05:00.0: @3780d4f0 00000000 00000000 00000000 00000000
[   73.146286] xhci_hcd 0000:05:00.0: @3780d500 00000000 00000000 00000000 00000000
[   73.146290] xhci_hcd 0000:05:00.0: @3780d510 00000000 00000000 00000000 00000000
[   73.146294] xhci_hcd 0000:05:00.0: @3780d520 00000000 00000000 00000000 00000000
[   73.146298] xhci_hcd 0000:05:00.0: @3780d530 00000000 00000000 00000000 00000000
[   73.146302] xhci_hcd 0000:05:00.0: @3780d540 00000000 00000000 00000000 00000000
[   73.146306] xhci_hcd 0000:05:00.0: @3780d550 00000000 00000000 00000000 00000000
[   73.146309] xhci_hcd 0000:05:00.0: @3780d560 00000000 00000000 00000000 00000000
[   73.146313] xhci_hcd 0000:05:00.0: @3780d570 00000000 00000000 00000000 00000000
[   73.146317] xhci_hcd 0000:05:00.0: @3780d580 00000000 00000000 00000000 00000000
[   73.146321] xhci_hcd 0000:05:00.0: @3780d590 00000000 00000000 00000000 00000000
[   73.146325] xhci_hcd 0000:05:00.0: @3780d5a0 00000000 00000000 00000000 00000000
[   73.146329] xhci_hcd 0000:05:00.0: @3780d5b0 00000000 00000000 00000000 00000000
[   73.146332] xhci_hcd 0000:05:00.0: @3780d5c0 00000000 00000000 00000000 00000000
[   73.146336] xhci_hcd 0000:05:00.0: @3780d5d0 00000000 00000000 00000000 00000000
[   73.146340] xhci_hcd 0000:05:00.0: @3780d5e0 00000000 00000000 00000000 00000000
[   73.146344] xhci_hcd 0000:05:00.0: @3780d5f0 00000000 00000000 00000000 00000000
[   73.146348] xhci_hcd 0000:05:00.0: @3780d600 00000000 00000000 00000000 00000000
[   73.146351] xhci_hcd 0000:05:00.0: @3780d610 00000000 00000000 00000000 00000000
[   73.146355] xhci_hcd 0000:05:00.0: @3780d620 00000000 00000000 00000000 00000000
[   73.146359] xhci_hcd 0000:05:00.0: @3780d630 00000000 00000000 00000000 00000000
[   73.146363] xhci_hcd 0000:05:00.0: @3780d640 00000000 00000000 00000000 00000000
[   73.146366] xhci_hcd 0000:05:00.0: @3780d650 00000000 00000000 00000000 00000000
[   73.146370] xhci_hcd 0000:05:00.0: @3780d660 00000000 00000000 00000000 00000000
[   73.146374] xhci_hcd 0000:05:00.0: @3780d670 00000000 00000000 00000000 00000000
[   73.146378] xhci_hcd 0000:05:00.0: @3780d680 00000000 00000000 00000000 00000000
[   73.146382] xhci_hcd 0000:05:00.0: @3780d690 00000000 00000000 00000000 00000000
[   73.146386] xhci_hcd 0000:05:00.0: @3780d6a0 00000000 00000000 00000000 00000000
[   73.146390] xhci_hcd 0000:05:00.0: @3780d6b0 00000000 00000000 00000000 00000000
[   73.146393] xhci_hcd 0000:05:00.0: @3780d6c0 00000000 00000000 00000000 00000000
[   73.146397] xhci_hcd 0000:05:00.0: @3780d6d0 00000000 00000000 00000000 00000000
[   73.146401] xhci_hcd 0000:05:00.0: @3780d6e0 00000000 00000000 00000000 00000000
[   73.146405] xhci_hcd 0000:05:00.0: @3780d6f0 00000000 00000000 00000000 00000000
[   73.146409] xhci_hcd 0000:05:00.0: @3780d700 00000000 00000000 00000000 00000000
[   73.146412] xhci_hcd 0000:05:00.0: @3780d710 00000000 00000000 00000000 00000000
[   73.146416] xhci_hcd 0000:05:00.0: @3780d720 00000000 00000000 00000000 00000000
[   73.146420] xhci_hcd 0000:05:00.0: @3780d730 00000000 00000000 00000000 00000000
[   73.146424] xhci_hcd 0000:05:00.0: @3780d740 00000000 00000000 00000000 00000000
[   73.146428] xhci_hcd 0000:05:00.0: @3780d750 00000000 00000000 00000000 00000000
[   73.146432] xhci_hcd 0000:05:00.0: @3780d760 00000000 00000000 00000000 00000000
[   73.146435] xhci_hcd 0000:05:00.0: @3780d770 00000000 00000000 00000000 00000000
[   73.146439] xhci_hcd 0000:05:00.0: @3780d780 00000000 00000000 00000000 00000000
[   73.146443] xhci_hcd 0000:05:00.0: @3780d790 00000000 00000000 00000000 00000000
[   73.146447] xhci_hcd 0000:05:00.0: @3780d7a0 00000000 00000000 00000000 00000000
[   73.146451] xhci_hcd 0000:05:00.0: @3780d7b0 00000000 00000000 00000000 00000000
[   73.146454] xhci_hcd 0000:05:00.0: @3780d7c0 00000000 00000000 00000000 00000000
[   73.146458] xhci_hcd 0000:05:00.0: @3780d7d0 00000000 00000000 00000000 00000000
[   73.146462] xhci_hcd 0000:05:00.0: @3780d7e0 00000000 00000000 00000000 00000000
[   73.146466] xhci_hcd 0000:05:00.0: @3780d7f0 00000000 00000000 00000000 00000000
[   73.146469] xhci_hcd 0000:05:00.0:   Ring has not been updated
[   73.146472] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d400 (virt), 0x3780d400 (dma)
[   73.146475] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[   73.146478] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d400 (virt), 0x3780d400 (dma)
[   73.146481] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   73.146488] xhci_hcd 0000:05:00.0: ERST deq = 64'h3780d400
[   73.146490] xhci_hcd 0000:05:00.0: // Set the interrupt modulation register
[   73.146496] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8624, 32'ha0, 4'hf);
[   73.146501] xhci_hcd 0000:05:00.0: // Enable interrupts, cmd = 0x4.
[   73.146504] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8020, 32'h4, 4'hf);
[   73.146509] xhci_hcd 0000:05:00.0: // Enabling event ring interrupter ffffc900043d8620 by writing 0x2 to irq_pending
[   73.146513] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8620, 32'h2, 4'hf);
[   73.146518] xhci_hcd 0000:05:00.0:   ffffc900043d8620: ir_set[0]
[   73.146521] xhci_hcd 0000:05:00.0:   ffffc900043d8620: ir_set.pending = 0x2
[   73.146526] xhci_hcd 0000:05:00.0:   ffffc900043d8624: ir_set.control = 0xa0
[   73.146531] xhci_hcd 0000:05:00.0:   ffffc900043d8628: ir_set.erst_size = 0x1
[   73.146540] xhci_hcd 0000:05:00.0:   ffffc900043d8630: ir_set.erst_base = @3780e000
[   73.146547] xhci_hcd 0000:05:00.0:   ffffc900043d8638: ir_set.erst_dequeue = @3780d400
[   73.146551] xhci_hcd 0000:05:00.0: Endpoint state = 0x1
[   73.146554] xhci_hcd 0000:05:00.0: Command ring enq = 0x3780d010 (DMA)
[   73.146557] xhci_hcd 0000:05:00.0: Finished xhci_run for USB2 roothub
[   73.146838] usb usb9: default language 0x0409
[   73.147060] usb usb9: udev 1, busnum 9, minor = 1024
[   73.147063] usb usb9: New USB device found, idVendor=1d6b, idProduct=0002
[   73.147066] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   73.147069] usb usb9: Product: xHCI Host Controller
[   73.147072] usb usb9: Manufacturer: Linux 2.6.38+ xhci_hcd
[   73.147074] usb usb9: SerialNumber: 0000:05:00.0
[   73.150549] usb usb9: usb_probe_device
[   73.150554] usb usb9: configuration #1 chosen from 1 choice
[   73.150596] xHCI xhci_add_endpoint called for root hub
[   73.150599] xHCI xhci_check_bandwidth called for root hub
[   73.150672] usb usb9: adding 9-0:1.0 (config #1, interface 0)
[   73.151298] hub 9-0:1.0: usb_probe_interface
[   73.151301] hub 9-0:1.0: usb_probe_interface - got id
[   73.151306] hub 9-0:1.0: USB hub found
[   73.151545] hub 9-0:1.0: 2 ports detected
[   73.151570] hub 9-0:1.0: standalone hub
[   73.151573] hub 9-0:1.0: individual port power switching
[   73.151575] hub 9-0:1.0: individual port over-current protection
[   73.151579] hub 9-0:1.0: Single TT
[   73.151582] hub 9-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   73.151584] hub 9-0:1.0: power on to power good time: 20ms
[   73.151732] hub 9-0:1.0: local power source is good
[   73.151758] hub 9-0:1.0: enabling power on all ports
[   73.151817] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8440, 32'h2a0, 4'hf);
[   73.151822] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[   73.151892] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8450, 32'h2a0, 4'hf);
[   73.151898] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[   73.155659] xhci_hcd 0000:05:00.0: xHCI Host Controller
[   73.155714] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 10
[   73.168066] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[   73.168071] xhci_hcd 0000:05:00.0: supports USB remote wakeup
[   73.168076] xhci_hcd 0000:05:00.0: // Turn on HC, cmd = 0x5.
[   73.168080] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8020, 32'h5, 4'hf);
[   73.168095] xhci_hcd 0000:05:00.0: // Ding dong!
[   73.168097] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8800, 32'h0, 4'hf);
[   73.168103] xhci_hcd 0000:05:00.0: Finished xhci_run for USB3 roothub
[   73.168258] xhci_hcd 0000:05:00.0: op reg status = 00000008
[   73.168262] xhci_hcd 0000:05:00.0: Event ring dequeue ptr:
[   73.168266] xhci_hcd 0000:05:00.0: @3780d400 3780d000 00000000 01003021 0000c001
[   73.168269] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8024, 32'h8, 4'hf);
[   73.168273] xhci_hcd 0000:05:00.0: In xhci_handle_event
[   73.168275] xhci_hcd 0000:05:00.0: xhci_handle_event - OS owns TRB
[   73.168279] xhci_hcd 0000:05:00.0: Vendor specific event TRB type = 48
[   73.168283] xhci_hcd 0000:05:00.0: NEC firmware version 30.21
[   73.168286] xhci_hcd 0000:05:00.0: Command ring deq = 0x3780d010 (DMA)
[   73.168289] xhci_hcd 0000:05:00.0: Event ring deq = 0x3780d410 (DMA)
[   73.168292] xhci_hcd 0000:05:00.0: In xhci_handle_event
[   73.168301] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc900043d8638, 64'h3780d418, 4'hf);
[   73.168311] usb usb10: skipped 1 descriptor after endpoint
[   73.168377] usb usb10: default language 0x0409
[   73.168583] usb usb10: udev 1, busnum 10, minor = 1152
[   73.168586] usb usb10: New USB device found, idVendor=1d6b, idProduct=0003
[   73.168589] usb usb10: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   73.168592] usb usb10: Product: xHCI Host Controller
[   73.168595] usb usb10: Manufacturer: Linux 2.6.38+ xhci_hcd
[   73.168597] usb usb10: SerialNumber: 0000:05:00.0
[   73.171723] usb usb10: usb_probe_device
[   73.171727] usb usb10: configuration #1 chosen from 1 choice
[   73.171766] xHCI xhci_add_endpoint called for root hub
[   73.171768] xHCI xhci_check_bandwidth called for root hub
[   73.171842] usb usb10: adding 10-0:1.0 (config #1, interface 0)
[   73.172881] hub 10-0:1.0: usb_probe_interface
[   73.172885] hub 10-0:1.0: usb_probe_interface - got id
[   73.172890] hub 10-0:1.0: USB hub found
[   73.173056] hub 10-0:1.0: 2 ports detected
[   73.173080] hub 10-0:1.0: standalone hub
[   73.173083] hub 10-0:1.0: individual port power switching
[   73.173085] hub 10-0:1.0: individual port over-current protection
[   73.173090] hub 10-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   73.173092] hub 10-0:1.0: power on to power good time: 20ms
[   73.173232] hub 10-0:1.0: local power source is good
[   73.173260] hub 10-0:1.0: enabling power on all ports
[   73.173328] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8420, 32'h2a0, 4'hf);
[   73.173337] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[   73.173412] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8430, 32'h2a0, 4'hf);
[   73.173421] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[   73.248167] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[   73.248171] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   73.248212] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[   73.248215] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   73.248238] hub 9-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   73.272081] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[   73.272085] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   73.272124] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[   73.272127] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   73.272146] hub 10-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   75.808138] hub 9-0:1.0: hub_suspend
[   75.808236] usb usb9: bus auto-suspend
[   75.808240] xhci_hcd 0000:05:00.0: suspend USB 2.0 root hub
[   75.808247] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8450, 32'ha0002a0, 4'hf);
[   75.808255] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8440, 32'ha0002a0, 4'hf);
[   75.808264] hub 10-0:1.0: hub_suspend
[   75.808271] usb usb10: bus auto-suspend
[   75.808273] xhci_hcd 0000:05:00.0: suspend USB 3.0 root hub
[   75.808280] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8430, 32'ha0002a0, 4'hf);
[   75.808289] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc900043d8420, 32'ha0002a0, 4'hf);
[   79.171002] kmemleak: 2 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
[  133.344134] xhci_hcd 0000:05:00.0: Poll event ring: 4294925632
[  133.344141] xhci_hcd 0000:05:00.0: op reg status = 0x0
[  133.344147] xhci_hcd 0000:05:00.0: ir_set 0 pending = 0x2
[  133.344149] xhci_hcd 0000:05:00.0: HC error bitmask = 0x4
[  133.344152] xhci_hcd 0000:05:00.0: Event ring:
[  133.344156] xhci_hcd 0000:05:00.0: @3780d400 3780d000 00000000 01003021 0000c001
[  133.344159] xhci_hcd 0000:05:00.0: @3780d410 00000000 00000000 00000000 00000000
[  133.344163] xhci_hcd 0000:05:00.0: @3780d420 00000000 00000000 00000000 00000000
[  133.344166] xhci_hcd 0000:05:00.0: @3780d430 00000000 00000000 00000000 00000000
[  133.344169] xhci_hcd 0000:05:00.0: @3780d440 00000000 00000000 00000000 00000000
[  133.344172] xhci_hcd 0000:05:00.0: @3780d450 00000000 00000000 00000000 00000000
[  133.344176] xhci_hcd 0000:05:00.0: @3780d460 00000000 00000000 00000000 00000000
[  133.344179] xhci_hcd 0000:05:00.0: @3780d470 00000000 00000000 00000000 00000000
[  133.344182] xhci_hcd 0000:05:00.0: @3780d480 00000000 00000000 00000000 00000000
[  133.344185] xhci_hcd 0000:05:00.0: @3780d490 00000000 00000000 00000000 00000000
[  133.344189] xhci_hcd 0000:05:00.0: @3780d4a0 00000000 00000000 00000000 00000000
[  133.344192] xhci_hcd 0000:05:00.0: @3780d4b0 00000000 00000000 00000000 00000000
[  133.344195] xhci_hcd 0000:05:00.0: @3780d4c0 00000000 00000000 00000000 00000000
[  133.344198] xhci_hcd 0000:05:00.0: @3780d4d0 00000000 00000000 00000000 00000000
[  133.344202] xhci_hcd 0000:05:00.0: @3780d4e0 00000000 00000000 00000000 00000000
[  133.344205] xhci_hcd 0000:05:00.0: @3780d4f0 00000000 00000000 00000000 00000000
[  133.344208] xhci_hcd 0000:05:00.0: @3780d500 00000000 00000000 00000000 00000000
[  133.344211] xhci_hcd 0000:05:00.0: @3780d510 00000000 00000000 00000000 00000000
[  133.344215] xhci_hcd 0000:05:00.0: @3780d520 00000000 00000000 00000000 00000000
[  133.344218] xhci_hcd 0000:05:00.0: @3780d530 00000000 00000000 00000000 00000000
[  133.344227] xhci_hcd 0000:05:00.0: @3780d540 00000000 00000000 00000000 00000000
[  133.344230] xhci_hcd 0000:05:00.0: @3780d550 00000000 00000000 00000000 00000000
[  133.344232] xhci_hcd 0000:05:00.0: @3780d560 00000000 00000000 00000000 00000000
[  133.344235] xhci_hcd 0000:05:00.0: @3780d570 00000000 00000000 00000000 00000000
[  133.344238] xhci_hcd 0000:05:00.0: @3780d580 00000000 00000000 00000000 00000000
[  133.344241] xhci_hcd 0000:05:00.0: @3780d590 00000000 00000000 00000000 00000000
[  133.344244] xhci_hcd 0000:05:00.0: @3780d5a0 00000000 00000000 00000000 00000000
[  133.344247] xhci_hcd 0000:05:00.0: @3780d5b0 00000000 00000000 00000000 00000000
[  133.344250] xhci_hcd 0000:05:00.0: @3780d5c0 00000000 00000000 00000000 00000000
[  133.344253] xhci_hcd 0000:05:00.0: @3780d5d0 00000000 00000000 00000000 00000000
[  133.344255] xhci_hcd 0000:05:00.0: @3780d5e0 00000000 00000000 00000000 00000000
[  133.344258] xhci_hcd 0000:05:00.0: @3780d5f0 00000000 00000000 00000000 00000000
[  133.344261] xhci_hcd 0000:05:00.0: @3780d600 00000000 00000000 00000000 00000000
[  133.344264] xhci_hcd 0000:05:00.0: @3780d610 00000000 00000000 00000000 00000000
[  133.344267] xhci_hcd 0000:05:00.0: @3780d620 00000000 00000000 00000000 00000000
[  133.344270] xhci_hcd 0000:05:00.0: @3780d630 00000000 00000000 00000000 00000000
[  133.344272] xhci_hcd 0000:05:00.0: @3780d640 00000000 00000000 00000000 00000000
[  133.344275] xhci_hcd 0000:05:00.0: @3780d650 00000000 00000000 00000000 00000000
[  133.344278] xhci_hcd 0000:05:00.0: @3780d660 00000000 00000000 00000000 00000000
[  133.344281] xhci_hcd 0000:05:00.0: @3780d670 00000000 00000000 00000000 00000000
[  133.344284] xhci_hcd 0000:05:00.0: @3780d680 00000000 00000000 00000000 00000000
[  133.344287] xhci_hcd 0000:05:00.0: @3780d690 00000000 00000000 00000000 00000000
[  133.344289] xhci_hcd 0000:05:00.0: @3780d6a0 00000000 00000000 00000000 00000000
[  133.344292] xhci_hcd 0000:05:00.0: @3780d6b0 00000000 00000000 00000000 00000000
[  133.344295] xhci_hcd 0000:05:00.0: @3780d6c0 00000000 00000000 00000000 00000000
[  133.344298] xhci_hcd 0000:05:00.0: @3780d6d0 00000000 00000000 00000000 00000000
[  133.344301] xhci_hcd 0000:05:00.0: @3780d6e0 00000000 00000000 00000000 00000000
[  133.344304] xhci_hcd 0000:05:00.0: @3780d6f0 00000000 00000000 00000000 00000000
[  133.344307] xhci_hcd 0000:05:00.0: @3780d700 00000000 00000000 00000000 00000000
[  133.344309] xhci_hcd 0000:05:00.0: @3780d710 00000000 00000000 00000000 00000000
[  133.344312] xhci_hcd 0000:05:00.0: @3780d720 00000000 00000000 00000000 00000000
[  133.344315] xhci_hcd 0000:05:00.0: @3780d730 00000000 00000000 00000000 00000000
[  133.344318] xhci_hcd 0000:05:00.0: @3780d740 00000000 00000000 00000000 00000000
[  133.344321] xhci_hcd 0000:05:00.0: @3780d750 00000000 00000000 00000000 00000000
[  133.344323] xhci_hcd 0000:05:00.0: @3780d760 00000000 00000000 00000000 00000000
[  133.344326] xhci_hcd 0000:05:00.0: @3780d770 00000000 00000000 00000000 00000000
[  133.344329] xhci_hcd 0000:05:00.0: @3780d780 00000000 00000000 00000000 00000000
[  133.344332] xhci_hcd 0000:05:00.0: @3780d790 00000000 00000000 00000000 00000000
[  133.344335] xhci_hcd 0000:05:00.0: @3780d7a0 00000000 00000000 00000000 00000000
[  133.344338] xhci_hcd 0000:05:00.0: @3780d7b0 00000000 00000000 00000000 00000000
[  133.344340] xhci_hcd 0000:05:00.0: @3780d7c0 00000000 00000000 00000000 00000000
[  133.344343] xhci_hcd 0000:05:00.0: @3780d7d0 00000000 00000000 00000000 00000000
[  133.344346] xhci_hcd 0000:05:00.0: @3780d7e0 00000000 00000000 00000000 00000000
[  133.344349] xhci_hcd 0000:05:00.0: @3780d7f0 00000000 00000000 00000000 00000000
[  133.344353] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d410 (virt), 0x3780d410 (dma)
[  133.344355] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  133.344358] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d400 (virt), 0x3780d400 (dma)
[  133.344361] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  133.344369] xhci_hcd 0000:05:00.0: ERST deq = 64'h3780d410
[  133.344372] xhci_hcd 0000:05:00.0: Command ring:
[  133.344375] xhci_hcd 0000:05:00.0: @3780d000 00000000 00000000 00000000 0000c401
[  133.344377] xhci_hcd 0000:05:00.0: @3780d010 00000000 00000000 00000000 00000000
[  133.344381] xhci_hcd 0000:05:00.0: @3780d020 00000000 00000000 00000000 00000000
[  133.344383] xhci_hcd 0000:05:00.0: @3780d030 00000000 00000000 00000000 00000000
[  133.344386] xhci_hcd 0000:05:00.0: @3780d040 00000000 00000000 00000000 00000000
[  133.344389] xhci_hcd 0000:05:00.0: @3780d050 00000000 00000000 00000000 00000000
[  133.344392] xhci_hcd 0000:05:00.0: @3780d060 00000000 00000000 00000000 00000000
[  133.344395] xhci_hcd 0000:05:00.0: @3780d070 00000000 00000000 00000000 00000000
[  133.344398] xhci_hcd 0000:05:00.0: @3780d080 00000000 00000000 00000000 00000000
[  133.344401] xhci_hcd 0000:05:00.0: @3780d090 00000000 00000000 00000000 00000000
[  133.344403] xhci_hcd 0000:05:00.0: @3780d0a0 00000000 00000000 00000000 00000000
[  133.344406] xhci_hcd 0000:05:00.0: @3780d0b0 00000000 00000000 00000000 00000000
[  133.344409] xhci_hcd 0000:05:00.0: @3780d0c0 00000000 00000000 00000000 00000000
[  133.344412] xhci_hcd 0000:05:00.0: @3780d0d0 00000000 00000000 00000000 00000000
[  133.344415] xhci_hcd 0000:05:00.0: @3780d0e0 00000000 00000000 00000000 00000000
[  133.344418] xhci_hcd 0000:05:00.0: @3780d0f0 00000000 00000000 00000000 00000000
[  133.344421] xhci_hcd 0000:05:00.0: @3780d100 00000000 00000000 00000000 00000000
[  133.344423] xhci_hcd 0000:05:00.0: @3780d110 00000000 00000000 00000000 00000000
[  133.344426] xhci_hcd 0000:05:00.0: @3780d120 00000000 00000000 00000000 00000000
[  133.344429] xhci_hcd 0000:05:00.0: @3780d130 00000000 00000000 00000000 00000000
[  133.344432] xhci_hcd 0000:05:00.0: @3780d140 00000000 00000000 00000000 00000000
[  133.344435] xhci_hcd 0000:05:00.0: @3780d150 00000000 00000000 00000000 00000000
[  133.344438] xhci_hcd 0000:05:00.0: @3780d160 00000000 00000000 00000000 00000000
[  133.344441] xhci_hcd 0000:05:00.0: @3780d170 00000000 00000000 00000000 00000000
[  133.344444] xhci_hcd 0000:05:00.0: @3780d180 00000000 00000000 00000000 00000000
[  133.344446] xhci_hcd 0000:05:00.0: @3780d190 00000000 00000000 00000000 00000000
[  133.344449] xhci_hcd 0000:05:00.0: @3780d1a0 00000000 00000000 00000000 00000000
[  133.344452] xhci_hcd 0000:05:00.0: @3780d1b0 00000000 00000000 00000000 00000000
[  133.344455] xhci_hcd 0000:05:00.0: @3780d1c0 00000000 00000000 00000000 00000000
[  133.344458] xhci_hcd 0000:05:00.0: @3780d1d0 00000000 00000000 00000000 00000000
[  133.344461] xhci_hcd 0000:05:00.0: @3780d1e0 00000000 00000000 00000000 00000000
[  133.344464] xhci_hcd 0000:05:00.0: @3780d1f0 00000000 00000000 00000000 00000000
[  133.344466] xhci_hcd 0000:05:00.0: @3780d200 00000000 00000000 00000000 00000000
[  133.344469] xhci_hcd 0000:05:00.0: @3780d210 00000000 00000000 00000000 00000000
[  133.344472] xhci_hcd 0000:05:00.0: @3780d220 00000000 00000000 00000000 00000000
[  133.344475] xhci_hcd 0000:05:00.0: @3780d230 00000000 00000000 00000000 00000000
[  133.344478] xhci_hcd 0000:05:00.0: @3780d240 00000000 00000000 00000000 00000000
[  133.344481] xhci_hcd 0000:05:00.0: @3780d250 00000000 00000000 00000000 00000000
[  133.344484] xhci_hcd 0000:05:00.0: @3780d260 00000000 00000000 00000000 00000000
[  133.344487] xhci_hcd 0000:05:00.0: @3780d270 00000000 00000000 00000000 00000000
[  133.344489] xhci_hcd 0000:05:00.0: @3780d280 00000000 00000000 00000000 00000000
[  133.344492] xhci_hcd 0000:05:00.0: @3780d290 00000000 00000000 00000000 00000000
[  133.344495] xhci_hcd 0000:05:00.0: @3780d2a0 00000000 00000000 00000000 00000000
[  133.344498] xhci_hcd 0000:05:00.0: @3780d2b0 00000000 00000000 00000000 00000000
[  133.344501] xhci_hcd 0000:05:00.0: @3780d2c0 00000000 00000000 00000000 00000000
[  133.344504] xhci_hcd 0000:05:00.0: @3780d2d0 00000000 00000000 00000000 00000000
[  133.344507] xhci_hcd 0000:05:00.0: @3780d2e0 00000000 00000000 00000000 00000000
[  133.344509] xhci_hcd 0000:05:00.0: @3780d2f0 00000000 00000000 00000000 00000000
[  133.344512] xhci_hcd 0000:05:00.0: @3780d300 00000000 00000000 00000000 00000000
[  133.344515] xhci_hcd 0000:05:00.0: @3780d310 00000000 00000000 00000000 00000000
[  133.344518] xhci_hcd 0000:05:00.0: @3780d320 00000000 00000000 00000000 00000000
[  133.344521] xhci_hcd 0000:05:00.0: @3780d330 00000000 00000000 00000000 00000000
[  133.344524] xhci_hcd 0000:05:00.0: @3780d340 00000000 00000000 00000000 00000000
[  133.344527] xhci_hcd 0000:05:00.0: @3780d350 00000000 00000000 00000000 00000000
[  133.344530] xhci_hcd 0000:05:00.0: @3780d360 00000000 00000000 00000000 00000000
[  133.344533] xhci_hcd 0000:05:00.0: @3780d370 00000000 00000000 00000000 00000000
[  133.344535] xhci_hcd 0000:05:00.0: @3780d380 00000000 00000000 00000000 00000000
[  133.344538] xhci_hcd 0000:05:00.0: @3780d390 00000000 00000000 00000000 00000000
[  133.344541] xhci_hcd 0000:05:00.0: @3780d3a0 00000000 00000000 00000000 00000000
[  133.344544] xhci_hcd 0000:05:00.0: @3780d3b0 00000000 00000000 00000000 00000000
[  133.344547] xhci_hcd 0000:05:00.0: @3780d3c0 00000000 00000000 00000000 00000000
[  133.344550] xhci_hcd 0000:05:00.0: @3780d3d0 00000000 00000000 00000000 00000000
[  133.344553] xhci_hcd 0000:05:00.0: @3780d3e0 00000000 00000000 00000000 00000000
[  133.344556] xhci_hcd 0000:05:00.0: @3780d3f0 3780d000 00000000 00000000 00001802
[  133.344558] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d010 (virt), 0x3780d010 (dma)
[  133.344561] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  133.344564] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d010 (virt), 0x3780d010 (dma)
[  133.344566] xhci_hcd 0000:05:00.0: Ring enq updated 1 times
[  133.344574] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000008
[  133.344577] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[  193.504084] xhci_hcd 0000:05:00.0: Poll event ring: 4294940672
[  193.504091] xhci_hcd 0000:05:00.0: op reg status = 0x0
[  193.504098] xhci_hcd 0000:05:00.0: ir_set 0 pending = 0x2
[  193.504100] xhci_hcd 0000:05:00.0: HC error bitmask = 0x0
[  193.504103] xhci_hcd 0000:05:00.0: Event ring:
[  193.504107] xhci_hcd 0000:05:00.0: @3780d400 3780d000 00000000 01003021 0000c001
[  193.504111] xhci_hcd 0000:05:00.0: @3780d410 00000000 00000000 00000000 00000000
[  193.504114] xhci_hcd 0000:05:00.0: @3780d420 00000000 00000000 00000000 00000000
[  193.504117] xhci_hcd 0000:05:00.0: @3780d430 00000000 00000000 00000000 00000000
[  193.504120] xhci_hcd 0000:05:00.0: @3780d440 00000000 00000000 00000000 00000000
[  193.504124] xhci_hcd 0000:05:00.0: @3780d450 00000000 00000000 00000000 00000000
[  193.504127] xhci_hcd 0000:05:00.0: @3780d460 00000000 00000000 00000000 00000000
[  193.504130] xhci_hcd 0000:05:00.0: @3780d470 00000000 00000000 00000000 00000000
[  193.504133] xhci_hcd 0000:05:00.0: @3780d480 00000000 00000000 00000000 00000000
[  193.504136] xhci_hcd 0000:05:00.0: @3780d490 00000000 00000000 00000000 00000000
[  193.504140] xhci_hcd 0000:05:00.0: @3780d4a0 00000000 00000000 00000000 00000000
[  193.504143] xhci_hcd 0000:05:00.0: @3780d4b0 00000000 00000000 00000000 00000000
[  193.504146] xhci_hcd 0000:05:00.0: @3780d4c0 00000000 00000000 00000000 00000000
[  193.504149] xhci_hcd 0000:05:00.0: @3780d4d0 00000000 00000000 00000000 00000000
[  193.504153] xhci_hcd 0000:05:00.0: @3780d4e0 00000000 00000000 00000000 00000000
[  193.504156] xhci_hcd 0000:05:00.0: @3780d4f0 00000000 00000000 00000000 00000000
[  193.504159] xhci_hcd 0000:05:00.0: @3780d500 00000000 00000000 00000000 00000000
[  193.504162] xhci_hcd 0000:05:00.0: @3780d510 00000000 00000000 00000000 00000000
[  193.504166] xhci_hcd 0000:05:00.0: @3780d520 00000000 00000000 00000000 00000000
[  193.504169] xhci_hcd 0000:05:00.0: @3780d530 00000000 00000000 00000000 00000000
[  193.504172] xhci_hcd 0000:05:00.0: @3780d540 00000000 00000000 00000000 00000000
[  193.504175] xhci_hcd 0000:05:00.0: @3780d550 00000000 00000000 00000000 00000000
[  193.504178] xhci_hcd 0000:05:00.0: @3780d560 00000000 00000000 00000000 00000000
[  193.504182] xhci_hcd 0000:05:00.0: @3780d570 00000000 00000000 00000000 00000000
[  193.504185] xhci_hcd 0000:05:00.0: @3780d580 00000000 00000000 00000000 00000000
[  193.504188] xhci_hcd 0000:05:00.0: @3780d590 00000000 00000000 00000000 00000000
[  193.504192] xhci_hcd 0000:05:00.0: @3780d5a0 00000000 00000000 00000000 00000000
[  193.504195] xhci_hcd 0000:05:00.0: @3780d5b0 00000000 00000000 00000000 00000000
[  193.504198] xhci_hcd 0000:05:00.0: @3780d5c0 00000000 00000000 00000000 00000000
[  193.504201] xhci_hcd 0000:05:00.0: @3780d5d0 00000000 00000000 00000000 00000000
[  193.504205] xhci_hcd 0000:05:00.0: @3780d5e0 00000000 00000000 00000000 00000000
[  193.504208] xhci_hcd 0000:05:00.0: @3780d5f0 00000000 00000000 00000000 00000000
[  193.504211] xhci_hcd 0000:05:00.0: @3780d600 00000000 00000000 00000000 00000000
[  193.504214] xhci_hcd 0000:05:00.0: @3780d610 00000000 00000000 00000000 00000000
[  193.504217] xhci_hcd 0000:05:00.0: @3780d620 00000000 00000000 00000000 00000000
[  193.504221] xhci_hcd 0000:05:00.0: @3780d630 00000000 00000000 00000000 00000000
[  193.504224] xhci_hcd 0000:05:00.0: @3780d640 00000000 00000000 00000000 00000000
[  193.504227] xhci_hcd 0000:05:00.0: @3780d650 00000000 00000000 00000000 00000000
[  193.504231] xhci_hcd 0000:05:00.0: @3780d660 00000000 00000000 00000000 00000000
[  193.504234] xhci_hcd 0000:05:00.0: @3780d670 00000000 00000000 00000000 00000000
[  193.504237] xhci_hcd 0000:05:00.0: @3780d680 00000000 00000000 00000000 00000000
[  193.504240] xhci_hcd 0000:05:00.0: @3780d690 00000000 00000000 00000000 00000000
[  193.504243] xhci_hcd 0000:05:00.0: @3780d6a0 00000000 00000000 00000000 00000000
[  193.504247] xhci_hcd 0000:05:00.0: @3780d6b0 00000000 00000000 00000000 00000000
[  193.504250] xhci_hcd 0000:05:00.0: @3780d6c0 00000000 00000000 00000000 00000000
[  193.504253] xhci_hcd 0000:05:00.0: @3780d6d0 00000000 00000000 00000000 00000000
[  193.504257] xhci_hcd 0000:05:00.0: @3780d6e0 00000000 00000000 00000000 00000000
[  193.504260] xhci_hcd 0000:05:00.0: @3780d6f0 00000000 00000000 00000000 00000000
[  193.504263] xhci_hcd 0000:05:00.0: @3780d700 00000000 00000000 00000000 00000000
[  193.504266] xhci_hcd 0000:05:00.0: @3780d710 00000000 00000000 00000000 00000000
[  193.504270] xhci_hcd 0000:05:00.0: @3780d720 00000000 00000000 00000000 00000000
[  193.504273] xhci_hcd 0000:05:00.0: @3780d730 00000000 00000000 00000000 00000000
[  193.504276] xhci_hcd 0000:05:00.0: @3780d740 00000000 00000000 00000000 00000000
[  193.504279] xhci_hcd 0000:05:00.0: @3780d750 00000000 00000000 00000000 00000000
[  193.504282] xhci_hcd 0000:05:00.0: @3780d760 00000000 00000000 00000000 00000000
[  193.504286] xhci_hcd 0000:05:00.0: @3780d770 00000000 00000000 00000000 00000000
[  193.504289] xhci_hcd 0000:05:00.0: @3780d780 00000000 00000000 00000000 00000000
[  193.504292] xhci_hcd 0000:05:00.0: @3780d790 00000000 00000000 00000000 00000000
[  193.504296] xhci_hcd 0000:05:00.0: @3780d7a0 00000000 00000000 00000000 00000000
[  193.504304] xhci_hcd 0000:05:00.0: @3780d7b0 00000000 00000000 00000000 00000000
[  193.504307] xhci_hcd 0000:05:00.0: @3780d7c0 00000000 00000000 00000000 00000000
[  193.504310] xhci_hcd 0000:05:00.0: @3780d7d0 00000000 00000000 00000000 00000000
[  193.504313] xhci_hcd 0000:05:00.0: @3780d7e0 00000000 00000000 00000000 00000000
[  193.504316] xhci_hcd 0000:05:00.0: @3780d7f0 00000000 00000000 00000000 00000000
[  193.504319] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d410 (virt), 0x3780d410 (dma)
[  193.504322] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  193.504325] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d400 (virt), 0x3780d400 (dma)
[  193.504327] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  193.504336] xhci_hcd 0000:05:00.0: ERST deq = 64'h3780d410
[  193.504338] xhci_hcd 0000:05:00.0: Command ring:
[  193.504341] xhci_hcd 0000:05:00.0: @3780d000 00000000 00000000 00000000 0000c401
[  193.504344] xhci_hcd 0000:05:00.0: @3780d010 00000000 00000000 00000000 00000000
[  193.504347] xhci_hcd 0000:05:00.0: @3780d020 00000000 00000000 00000000 00000000
[  193.504350] xhci_hcd 0000:05:00.0: @3780d030 00000000 00000000 00000000 00000000
[  193.504353] xhci_hcd 0000:05:00.0: @3780d040 00000000 00000000 00000000 00000000
[  193.504355] xhci_hcd 0000:05:00.0: @3780d050 00000000 00000000 00000000 00000000
[  193.504358] xhci_hcd 0000:05:00.0: @3780d060 00000000 00000000 00000000 00000000
[  193.504361] xhci_hcd 0000:05:00.0: @3780d070 00000000 00000000 00000000 00000000
[  193.504364] xhci_hcd 0000:05:00.0: @3780d080 00000000 00000000 00000000 00000000
[  193.504367] xhci_hcd 0000:05:00.0: @3780d090 00000000 00000000 00000000 00000000
[  193.504370] xhci_hcd 0000:05:00.0: @3780d0a0 00000000 00000000 00000000 00000000
[  193.504373] xhci_hcd 0000:05:00.0: @3780d0b0 00000000 00000000 00000000 00000000
[  193.504375] xhci_hcd 0000:05:00.0: @3780d0c0 00000000 00000000 00000000 00000000
[  193.504378] xhci_hcd 0000:05:00.0: @3780d0d0 00000000 00000000 00000000 00000000
[  193.504381] xhci_hcd 0000:05:00.0: @3780d0e0 00000000 00000000 00000000 00000000
[  193.504384] xhci_hcd 0000:05:00.0: @3780d0f0 00000000 00000000 00000000 00000000
[  193.504387] xhci_hcd 0000:05:00.0: @3780d100 00000000 00000000 00000000 00000000
[  193.504390] xhci_hcd 0000:05:00.0: @3780d110 00000000 00000000 00000000 00000000
[  193.504393] xhci_hcd 0000:05:00.0: @3780d120 00000000 00000000 00000000 00000000
[  193.504395] xhci_hcd 0000:05:00.0: @3780d130 00000000 00000000 00000000 00000000
[  193.504398] xhci_hcd 0000:05:00.0: @3780d140 00000000 00000000 00000000 00000000
[  193.504401] xhci_hcd 0000:05:00.0: @3780d150 00000000 00000000 00000000 00000000
[  193.504404] xhci_hcd 0000:05:00.0: @3780d160 00000000 00000000 00000000 00000000
[  193.504407] xhci_hcd 0000:05:00.0: @3780d170 00000000 00000000 00000000 00000000
[  193.504410] xhci_hcd 0000:05:00.0: @3780d180 00000000 00000000 00000000 00000000
[  193.504413] xhci_hcd 0000:05:00.0: @3780d190 00000000 00000000 00000000 00000000
[  193.504415] xhci_hcd 0000:05:00.0: @3780d1a0 00000000 00000000 00000000 00000000
[  193.504418] xhci_hcd 0000:05:00.0: @3780d1b0 00000000 00000000 00000000 00000000
[  193.504421] xhci_hcd 0000:05:00.0: @3780d1c0 00000000 00000000 00000000 00000000
[  193.504424] xhci_hcd 0000:05:00.0: @3780d1d0 00000000 00000000 00000000 00000000
[  193.504427] xhci_hcd 0000:05:00.0: @3780d1e0 00000000 00000000 00000000 00000000
[  193.504430] xhci_hcd 0000:05:00.0: @3780d1f0 00000000 00000000 00000000 00000000
[  193.504433] xhci_hcd 0000:05:00.0: @3780d200 00000000 00000000 00000000 00000000
[  193.504435] xhci_hcd 0000:05:00.0: @3780d210 00000000 00000000 00000000 00000000
[  193.504438] xhci_hcd 0000:05:00.0: @3780d220 00000000 00000000 00000000 00000000
[  193.504441] xhci_hcd 0000:05:00.0: @3780d230 00000000 00000000 00000000 00000000
[  193.504444] xhci_hcd 0000:05:00.0: @3780d240 00000000 00000000 00000000 00000000
[  193.504447] xhci_hcd 0000:05:00.0: @3780d250 00000000 00000000 00000000 00000000
[  193.504450] xhci_hcd 0000:05:00.0: @3780d260 00000000 00000000 00000000 00000000
[  193.504453] xhci_hcd 0000:05:00.0: @3780d270 00000000 00000000 00000000 00000000
[  193.504455] xhci_hcd 0000:05:00.0: @3780d280 00000000 00000000 00000000 00000000
[  193.504458] xhci_hcd 0000:05:00.0: @3780d290 00000000 00000000 00000000 00000000
[  193.504461] xhci_hcd 0000:05:00.0: @3780d2a0 00000000 00000000 00000000 00000000
[  193.504464] xhci_hcd 0000:05:00.0: @3780d2b0 00000000 00000000 00000000 00000000
[  193.504467] xhci_hcd 0000:05:00.0: @3780d2c0 00000000 00000000 00000000 00000000
[  193.504470] xhci_hcd 0000:05:00.0: @3780d2d0 00000000 00000000 00000000 00000000
[  193.504472] xhci_hcd 0000:05:00.0: @3780d2e0 00000000 00000000 00000000 00000000
[  193.504475] xhci_hcd 0000:05:00.0: @3780d2f0 00000000 00000000 00000000 00000000
[  193.504478] xhci_hcd 0000:05:00.0: @3780d300 00000000 00000000 00000000 00000000
[  193.504481] xhci_hcd 0000:05:00.0: @3780d310 00000000 00000000 00000000 00000000
[  193.504484] xhci_hcd 0000:05:00.0: @3780d320 00000000 00000000 00000000 00000000
[  193.504487] xhci_hcd 0000:05:00.0: @3780d330 00000000 00000000 00000000 00000000
[  193.504490] xhci_hcd 0000:05:00.0: @3780d340 00000000 00000000 00000000 00000000
[  193.504492] xhci_hcd 0000:05:00.0: @3780d350 00000000 00000000 00000000 00000000
[  193.504495] xhci_hcd 0000:05:00.0: @3780d360 00000000 00000000 00000000 00000000
[  193.504498] xhci_hcd 0000:05:00.0: @3780d370 00000000 00000000 00000000 00000000
[  193.504501] xhci_hcd 0000:05:00.0: @3780d380 00000000 00000000 00000000 00000000
[  193.504504] xhci_hcd 0000:05:00.0: @3780d390 00000000 00000000 00000000 00000000
[  193.504507] xhci_hcd 0000:05:00.0: @3780d3a0 00000000 00000000 00000000 00000000
[  193.504510] xhci_hcd 0000:05:00.0: @3780d3b0 00000000 00000000 00000000 00000000
[  193.504513] xhci_hcd 0000:05:00.0: @3780d3c0 00000000 00000000 00000000 00000000
[  193.504516] xhci_hcd 0000:05:00.0: @3780d3d0 00000000 00000000 00000000 00000000
[  193.504518] xhci_hcd 0000:05:00.0: @3780d3e0 00000000 00000000 00000000 00000000
[  193.504521] xhci_hcd 0000:05:00.0: @3780d3f0 3780d000 00000000 00000000 00001802
[  193.504524] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d010 (virt), 0x3780d010 (dma)
[  193.504527] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  193.504530] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d010 (virt), 0x3780d010 (dma)
[  193.504532] xhci_hcd 0000:05:00.0: Ring enq updated 1 times
[  193.504540] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000008
[  193.504543] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[  253.664099] xhci_hcd 0000:05:00.0: Poll event ring: 4294955712
[  253.664106] xhci_hcd 0000:05:00.0: op reg status = 0x0
[  253.664112] xhci_hcd 0000:05:00.0: ir_set 0 pending = 0x2
[  253.664115] xhci_hcd 0000:05:00.0: HC error bitmask = 0x0
[  253.664118] xhci_hcd 0000:05:00.0: Event ring:
[  253.664122] xhci_hcd 0000:05:00.0: @3780d400 3780d000 00000000 01003021 0000c001
[  253.664125] xhci_hcd 0000:05:00.0: @3780d410 00000000 00000000 00000000 00000000
[  253.664128] xhci_hcd 0000:05:00.0: @3780d420 00000000 00000000 00000000 00000000
[  253.664131] xhci_hcd 0000:05:00.0: @3780d430 00000000 00000000 00000000 00000000
[  253.664135] xhci_hcd 0000:05:00.0: @3780d440 00000000 00000000 00000000 00000000
[  253.664138] xhci_hcd 0000:05:00.0: @3780d450 00000000 00000000 00000000 00000000
[  253.664141] xhci_hcd 0000:05:00.0: @3780d460 00000000 00000000 00000000 00000000
[  253.664144] xhci_hcd 0000:05:00.0: @3780d470 00000000 00000000 00000000 00000000
[  253.664148] xhci_hcd 0000:05:00.0: @3780d480 00000000 00000000 00000000 00000000
[  253.664151] xhci_hcd 0000:05:00.0: @3780d490 00000000 00000000 00000000 00000000
[  253.664154] xhci_hcd 0000:05:00.0: @3780d4a0 00000000 00000000 00000000 00000000
[  253.664157] xhci_hcd 0000:05:00.0: @3780d4b0 00000000 00000000 00000000 00000000
[  253.664160] xhci_hcd 0000:05:00.0: @3780d4c0 00000000 00000000 00000000 00000000
[  253.664164] xhci_hcd 0000:05:00.0: @3780d4d0 00000000 00000000 00000000 00000000
[  253.664167] xhci_hcd 0000:05:00.0: @3780d4e0 00000000 00000000 00000000 00000000
[  253.664170] xhci_hcd 0000:05:00.0: @3780d4f0 00000000 00000000 00000000 00000000
[  253.664174] xhci_hcd 0000:05:00.0: @3780d500 00000000 00000000 00000000 00000000
[  253.664177] xhci_hcd 0000:05:00.0: @3780d510 00000000 00000000 00000000 00000000
[  253.664180] xhci_hcd 0000:05:00.0: @3780d520 00000000 00000000 00000000 00000000
[  253.664183] xhci_hcd 0000:05:00.0: @3780d530 00000000 00000000 00000000 00000000
[  253.664186] xhci_hcd 0000:05:00.0: @3780d540 00000000 00000000 00000000 00000000
[  253.664190] xhci_hcd 0000:05:00.0: @3780d550 00000000 00000000 00000000 00000000
[  253.664193] xhci_hcd 0000:05:00.0: @3780d560 00000000 00000000 00000000 00000000
[  253.664196] xhci_hcd 0000:05:00.0: @3780d570 00000000 00000000 00000000 00000000
[  253.664200] xhci_hcd 0000:05:00.0: @3780d580 00000000 00000000 00000000 00000000
[  253.664203] xhci_hcd 0000:05:00.0: @3780d590 00000000 00000000 00000000 00000000
[  253.664206] xhci_hcd 0000:05:00.0: @3780d5a0 00000000 00000000 00000000 00000000
[  253.664209] xhci_hcd 0000:05:00.0: @3780d5b0 00000000 00000000 00000000 00000000
[  253.664213] xhci_hcd 0000:05:00.0: @3780d5c0 00000000 00000000 00000000 00000000
[  253.664216] xhci_hcd 0000:05:00.0: @3780d5d0 00000000 00000000 00000000 00000000
[  253.664219] xhci_hcd 0000:05:00.0: @3780d5e0 00000000 00000000 00000000 00000000
[  253.664222] xhci_hcd 0000:05:00.0: @3780d5f0 00000000 00000000 00000000 00000000
[  253.664226] xhci_hcd 0000:05:00.0: @3780d600 00000000 00000000 00000000 00000000
[  253.664229] xhci_hcd 0000:05:00.0: @3780d610 00000000 00000000 00000000 00000000
[  253.664232] xhci_hcd 0000:05:00.0: @3780d620 00000000 00000000 00000000 00000000
[  253.664235] xhci_hcd 0000:05:00.0: @3780d630 00000000 00000000 00000000 00000000
[  253.664239] xhci_hcd 0000:05:00.0: @3780d640 00000000 00000000 00000000 00000000
[  253.664242] xhci_hcd 0000:05:00.0: @3780d650 00000000 00000000 00000000 00000000
[  253.664245] xhci_hcd 0000:05:00.0: @3780d660 00000000 00000000 00000000 00000000
[  253.664248] xhci_hcd 0000:05:00.0: @3780d670 00000000 00000000 00000000 00000000
[  253.664252] xhci_hcd 0000:05:00.0: @3780d680 00000000 00000000 00000000 00000000
[  253.664255] xhci_hcd 0000:05:00.0: @3780d690 00000000 00000000 00000000 00000000
[  253.664258] xhci_hcd 0000:05:00.0: @3780d6a0 00000000 00000000 00000000 00000000
[  253.664262] xhci_hcd 0000:05:00.0: @3780d6b0 00000000 00000000 00000000 00000000
[  253.664265] xhci_hcd 0000:05:00.0: @3780d6c0 00000000 00000000 00000000 00000000
[  253.664268] xhci_hcd 0000:05:00.0: @3780d6d0 00000000 00000000 00000000 00000000
[  253.664271] xhci_hcd 0000:05:00.0: @3780d6e0 00000000 00000000 00000000 00000000
[  253.664274] xhci_hcd 0000:05:00.0: @3780d6f0 00000000 00000000 00000000 00000000
[  253.664278] xhci_hcd 0000:05:00.0: @3780d700 00000000 00000000 00000000 00000000
[  253.664281] xhci_hcd 0000:05:00.0: @3780d710 00000000 00000000 00000000 00000000
[  253.664284] xhci_hcd 0000:05:00.0: @3780d720 00000000 00000000 00000000 00000000
[  253.664287] xhci_hcd 0000:05:00.0: @3780d730 00000000 00000000 00000000 00000000
[  253.664290] xhci_hcd 0000:05:00.0: @3780d740 00000000 00000000 00000000 00000000
[  253.664294] xhci_hcd 0000:05:00.0: @3780d750 00000000 00000000 00000000 00000000
[  253.664297] xhci_hcd 0000:05:00.0: @3780d760 00000000 00000000 00000000 00000000
[  253.664300] xhci_hcd 0000:05:00.0: @3780d770 00000000 00000000 00000000 00000000
[  253.664303] xhci_hcd 0000:05:00.0: @3780d780 00000000 00000000 00000000 00000000
[  253.664307] xhci_hcd 0000:05:00.0: @3780d790 00000000 00000000 00000000 00000000
[  253.664310] xhci_hcd 0000:05:00.0: @3780d7a0 00000000 00000000 00000000 00000000
[  253.664313] xhci_hcd 0000:05:00.0: @3780d7b0 00000000 00000000 00000000 00000000
[  253.664322] xhci_hcd 0000:05:00.0: @3780d7c0 00000000 00000000 00000000 00000000
[  253.664325] xhci_hcd 0000:05:00.0: @3780d7d0 00000000 00000000 00000000 00000000
[  253.664327] xhci_hcd 0000:05:00.0: @3780d7e0 00000000 00000000 00000000 00000000
[  253.664330] xhci_hcd 0000:05:00.0: @3780d7f0 00000000 00000000 00000000 00000000
[  253.664334] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d410 (virt), 0x3780d410 (dma)
[  253.664337] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  253.664339] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d400 (virt), 0x3780d400 (dma)
[  253.664342] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  253.664351] xhci_hcd 0000:05:00.0: ERST deq = 64'h3780d410
[  253.664353] xhci_hcd 0000:05:00.0: Command ring:
[  253.664356] xhci_hcd 0000:05:00.0: @3780d000 00000000 00000000 00000000 0000c401
[  253.664359] xhci_hcd 0000:05:00.0: @3780d010 00000000 00000000 00000000 00000000
[  253.664362] xhci_hcd 0000:05:00.0: @3780d020 00000000 00000000 00000000 00000000
[  253.664365] xhci_hcd 0000:05:00.0: @3780d030 00000000 00000000 00000000 00000000
[  253.664368] xhci_hcd 0000:05:00.0: @3780d040 00000000 00000000 00000000 00000000
[  253.664370] xhci_hcd 0000:05:00.0: @3780d050 00000000 00000000 00000000 00000000
[  253.664373] xhci_hcd 0000:05:00.0: @3780d060 00000000 00000000 00000000 00000000
[  253.664376] xhci_hcd 0000:05:00.0: @3780d070 00000000 00000000 00000000 00000000
[  253.664379] xhci_hcd 0000:05:00.0: @3780d080 00000000 00000000 00000000 00000000
[  253.664382] xhci_hcd 0000:05:00.0: @3780d090 00000000 00000000 00000000 00000000
[  253.664385] xhci_hcd 0000:05:00.0: @3780d0a0 00000000 00000000 00000000 00000000
[  253.664387] xhci_hcd 0000:05:00.0: @3780d0b0 00000000 00000000 00000000 00000000
[  253.664390] xhci_hcd 0000:05:00.0: @3780d0c0 00000000 00000000 00000000 00000000
[  253.664393] xhci_hcd 0000:05:00.0: @3780d0d0 00000000 00000000 00000000 00000000
[  253.664396] xhci_hcd 0000:05:00.0: @3780d0e0 00000000 00000000 00000000 00000000
[  253.664399] xhci_hcd 0000:05:00.0: @3780d0f0 00000000 00000000 00000000 00000000
[  253.664402] xhci_hcd 0000:05:00.0: @3780d100 00000000 00000000 00000000 00000000
[  253.664405] xhci_hcd 0000:05:00.0: @3780d110 00000000 00000000 00000000 00000000
[  253.664408] xhci_hcd 0000:05:00.0: @3780d120 00000000 00000000 00000000 00000000
[  253.664410] xhci_hcd 0000:05:00.0: @3780d130 00000000 00000000 00000000 00000000
[  253.664413] xhci_hcd 0000:05:00.0: @3780d140 00000000 00000000 00000000 00000000
[  253.664416] xhci_hcd 0000:05:00.0: @3780d150 00000000 00000000 00000000 00000000
[  253.664419] xhci_hcd 0000:05:00.0: @3780d160 00000000 00000000 00000000 00000000
[  253.664422] xhci_hcd 0000:05:00.0: @3780d170 00000000 00000000 00000000 00000000
[  253.664425] xhci_hcd 0000:05:00.0: @3780d180 00000000 00000000 00000000 00000000
[  253.664428] xhci_hcd 0000:05:00.0: @3780d190 00000000 00000000 00000000 00000000
[  253.664430] xhci_hcd 0000:05:00.0: @3780d1a0 00000000 00000000 00000000 00000000
[  253.664433] xhci_hcd 0000:05:00.0: @3780d1b0 00000000 00000000 00000000 00000000
[  253.664436] xhci_hcd 0000:05:00.0: @3780d1c0 00000000 00000000 00000000 00000000
[  253.664439] xhci_hcd 0000:05:00.0: @3780d1d0 00000000 00000000 00000000 00000000
[  253.664442] xhci_hcd 0000:05:00.0: @3780d1e0 00000000 00000000 00000000 00000000
[  253.664445] xhci_hcd 0000:05:00.0: @3780d1f0 00000000 00000000 00000000 00000000
[  253.664448] xhci_hcd 0000:05:00.0: @3780d200 00000000 00000000 00000000 00000000
[  253.664450] xhci_hcd 0000:05:00.0: @3780d210 00000000 00000000 00000000 00000000
[  253.664453] xhci_hcd 0000:05:00.0: @3780d220 00000000 00000000 00000000 00000000
[  253.664456] xhci_hcd 0000:05:00.0: @3780d230 00000000 00000000 00000000 00000000
[  253.664459] xhci_hcd 0000:05:00.0: @3780d240 00000000 00000000 00000000 00000000
[  253.664462] xhci_hcd 0000:05:00.0: @3780d250 00000000 00000000 00000000 00000000
[  253.664465] xhci_hcd 0000:05:00.0: @3780d260 00000000 00000000 00000000 00000000
[  253.664468] xhci_hcd 0000:05:00.0: @3780d270 00000000 00000000 00000000 00000000
[  253.664471] xhci_hcd 0000:05:00.0: @3780d280 00000000 00000000 00000000 00000000
[  253.664473] xhci_hcd 0000:05:00.0: @3780d290 00000000 00000000 00000000 00000000
[  253.664476] xhci_hcd 0000:05:00.0: @3780d2a0 00000000 00000000 00000000 00000000
[  253.664479] xhci_hcd 0000:05:00.0: @3780d2b0 00000000 00000000 00000000 00000000
[  253.664482] xhci_hcd 0000:05:00.0: @3780d2c0 00000000 00000000 00000000 00000000
[  253.664485] xhci_hcd 0000:05:00.0: @3780d2d0 00000000 00000000 00000000 00000000
[  253.664488] xhci_hcd 0000:05:00.0: @3780d2e0 00000000 00000000 00000000 00000000
[  253.664491] xhci_hcd 0000:05:00.0: @3780d2f0 00000000 00000000 00000000 00000000
[  253.664494] xhci_hcd 0000:05:00.0: @3780d300 00000000 00000000 00000000 00000000
[  253.664496] xhci_hcd 0000:05:00.0: @3780d310 00000000 00000000 00000000 00000000
[  253.664499] xhci_hcd 0000:05:00.0: @3780d320 00000000 00000000 00000000 00000000
[  253.664502] xhci_hcd 0000:05:00.0: @3780d330 00000000 00000000 00000000 00000000
[  253.664505] xhci_hcd 0000:05:00.0: @3780d340 00000000 00000000 00000000 00000000
[  253.664508] xhci_hcd 0000:05:00.0: @3780d350 00000000 00000000 00000000 00000000
[  253.664511] xhci_hcd 0000:05:00.0: @3780d360 00000000 00000000 00000000 00000000
[  253.664513] xhci_hcd 0000:05:00.0: @3780d370 00000000 00000000 00000000 00000000
[  253.664516] xhci_hcd 0000:05:00.0: @3780d380 00000000 00000000 00000000 00000000
[  253.664519] xhci_hcd 0000:05:00.0: @3780d390 00000000 00000000 00000000 00000000
[  253.664522] xhci_hcd 0000:05:00.0: @3780d3a0 00000000 00000000 00000000 00000000
[  253.664525] xhci_hcd 0000:05:00.0: @3780d3b0 00000000 00000000 00000000 00000000
[  253.664528] xhci_hcd 0000:05:00.0: @3780d3c0 00000000 00000000 00000000 00000000
[  253.664531] xhci_hcd 0000:05:00.0: @3780d3d0 00000000 00000000 00000000 00000000
[  253.664534] xhci_hcd 0000:05:00.0: @3780d3e0 00000000 00000000 00000000 00000000
[  253.664537] xhci_hcd 0000:05:00.0: @3780d3f0 3780d000 00000000 00000000 00001802
[  253.664539] xhci_hcd 0000:05:00.0: Ring deq = ffff88003780d010 (virt), 0x3780d010 (dma)
[  253.664542] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  253.664545] xhci_hcd 0000:05:00.0: Ring enq = ffff88003780d010 (virt), 0x3780d010 (dma)
[  253.664547] xhci_hcd 0000:05:00.0: Ring enq updated 1 times
[  253.664555] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000008
[  253.664558] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[  313.824101] xhci_hcd 0000:05:00.0: Poll event ring: 4294970752
[  313.824106] xhci_hcd 0000:05:00.0: op reg status = 0xffffffff
[  313.824109] xhci_hcd 0000:05:00.0: HW died, polling stopped.
[  419.636287] pci_bus 0000:00: scanning bus
[  419.636419] pcieport 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 0
[  419.636426] pci_bus 0000:02: scanning bus
[  419.636431] pci_bus 0000:02: bus scan returning with max=02
[  419.636438] pcieport 0000:00:1c.1: scanning [bus 03-03] behind bridge, pass 0
[  419.636444] pci_bus 0000:03: scanning bus
[  419.636447] pci_bus 0000:03: bus scan returning with max=03
[  419.636453] pcieport 0000:00:1c.3: scanning [bus 05-0c] behind bridge, pass 0
[  419.636460] pci_bus 0000:05: scanning bus
[  419.636463] pci_bus 0000:05: bus scan returning with max=05
[  419.636470] pci 0000:00:1e.0: scanning [bus 0d-0d] behind bridge, pass 0
[  419.636476] pci_bus 0000:0d: scanning bus
[  419.636553] pci_bus 0000:0d: bus scan returning with max=0d
[  419.636560] pcieport 0000:00:1c.0: scanning [bus 02-02] behind bridge, pass 1
[  419.636570] pcieport 0000:00:1c.1: scanning [bus 03-03] behind bridge, pass 1
[  419.636579] pcieport 0000:00:1c.3: scanning [bus 05-0c] behind bridge, pass 1
[  419.636589] pci 0000:00:1e.0: scanning [bus 0d-0d] behind bridge, pass 1
[  419.636596] pci_bus 0000:00: bus scan returning with max=0d
[  419.636644] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment

--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config"

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.38 Kernel Configuration
# Mon Mar 21 14:26:54 2011
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
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
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
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
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
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
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
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
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
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
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
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
# CONFIG_X86_X2APIC is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
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
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=2
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
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
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION="/dev/sda5"
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_POWER_METER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
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
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
# CONFIG_NF_CONNTRACK_ZONES is not set
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_SNMP is not set
CONFIG_NF_CONNTRACK_PPTP=m
# CONFIG_NF_CONNTRACK_SANE is not set
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
# CONFIG_NETFILTER_XT_TARGET_CHECKSUM is not set
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TEE is not set
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
# CONFIG_NETFILTER_XT_MATCH_CPU is not set
CONFIG_NETFILTER_XT_MATCH_DCCP=m
# CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_SET is not set
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
# CONFIG_IP_VS_PROTO_SCTP is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
# CONFIG_IP_VS_PE_SIP is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
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
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
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
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
# CONFIG_BT_ATH3K is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

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
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085 is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=m
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=m
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=8
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
# CONFIG_SCSI_LPFC_DEBUG_FS is not set
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
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
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=y
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
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
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=m
# CONFIG_PHYLIB is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
# CONFIG_RTL8180 is not set
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_COMMON is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLAGN=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_DEBUGFS is not set
# CONFIG_IWL_P2P is not set
# CONFIG_IWLWIFI_LEGACY is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_WL1251 is not set
# CONFIG_WL12XX_MENU is not set
# CONFIG_ZD1211RW is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m

#
# Enable MMC support to see WiMAX SDIO drivers
#
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
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
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=0
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_RAMOOPS=m
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

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
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m

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
CONFIG_PDA_POWER=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_PKGTEMP is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_THMC50=m
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_LIS3_I2C is not set
CONFIG_SENSORS_APPLESMC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
# CONFIG_MFD_SUPPORT is not set
CONFIG_MFD_CORE=m
CONFIG_LPC_SCH=m
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
# CONFIG_RC_CORE is not set
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y

#
# Audio decoders
#
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_WM8775=m

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=m

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#

#
# Video improvement chips
#
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_TIMBERDALE is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
# CONFIG_USB_GSPCA_KONICA is not set
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
# CONFIG_USB_GSPCA_PAC7302 is not set
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
# CONFIG_USB_GSPCA_SPCA1528 is not set
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
# CONFIG_USB_GSPCA_SQ930X is not set
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STV0680 is not set
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_USBVISION=m
CONFIG_USB_ET61X251=m
CONFIG_USB_SN9C102=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
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
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
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
# CONFIG_FB_TMIO is not set
CONFIG_FB_UDL=m
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP8860 is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
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
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
# CONFIG_SND_ALOOP is not set
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
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
CONFIG_SND_HDA_INTEL=m
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
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_CANDO is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWII_FF is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MOSART is not set
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
CONFIG_HID_ROCCAT=m
# CONFIG_HID_ROCCAT_ARVO is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_KOVAPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_HID_STANTUM is not set
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WACOM_POWER_SUPPLY is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=m
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_WHCI_HCD=m
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=m
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SAMBA is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
# CONFIG_USB_SERIAL_SSU100 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_FUSB300 is not set
# CONFIG_USB_GADGET_R8A66597 is not set
# CONFIG_USB_GADGET_PXA_U2O is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_CI13XXX_PCI is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LANGWELL is not set
# CONFIG_USB_GADGET_EG20T is not set
CONFIG_USB_GADGET_DUMMY_HCD=y
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_GADGET_DUALSPEED=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
CONFIG_USB_G_NCM=m
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_FILE_STORAGE is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
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
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USB_DABUSB is not set
CONFIG_USB_SE401=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IP_COMMON=m
CONFIG_USB_IP_VHCI_HCD=m
CONFIG_USB_IP_HOST=m
# CONFIG_USB_IP_DEBUG_ENABLE is not set
CONFIG_W35UND=m
CONFIG_PRISM2_USB=m
# CONFIG_ECHO is not set
# CONFIG_BRCM80211 is not set
# CONFIG_RT2860 is not set
CONFIG_RT2870=m
# CONFIG_COMEDI is not set
CONFIG_ASUS_OLED=m
# CONFIG_R8187SE is not set
CONFIG_RTL8192U=m
# CONFIG_RTL8192E is not set
CONFIG_R8712U=m
# CONFIG_R8712_AP is not set
# CONFIG_RTS_PSTOR is not set
CONFIG_TRANZPORT=m
# CONFIG_POHMELFS is not set
# CONFIG_IDE_PHISON is not set
CONFIG_LINE6_USB=m
# CONFIG_LINE6_USB_DEBUG is not set
# CONFIG_LINE6_USB_DUMP_CTRL is not set
# CONFIG_LINE6_USB_DUMP_MIDI is not set
# CONFIG_LINE6_USB_DUMP_PCM is not set
# CONFIG_LINE6_USB_RAW is not set
# CONFIG_LINE6_USB_IMPULSE_RESPONSE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_USB_SERIAL_QUATECH2=m
CONFIG_USB_SERIAL_QUATECH_USB2=m
# CONFIG_VT6655 is not set
CONFIG_VT6656=m
# CONFIG_HYPERV is not set
# CONFIG_VME_BUS is not set
# CONFIG_DX_SEP is not set
# CONFIG_IIO is not set
# CONFIG_XVMALLOC is not set
# CONFIG_ZRAM is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
CONFIG_EASYCAP=m
CONFIG_EASYCAP_SND=y
# CONFIG_EASYCAP_OSS is not set
# CONFIG_EASYCAP_DEBUG is not set
# CONFIG_SOLO6X10 is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_MACH_NO_WESTBRIDGE=y
CONFIG_USB_ENESTORAGE=m
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_DRM_PSB is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_HWSPINLOCK is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
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
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
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
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
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
# CONFIG_CIFS is not set
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
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_INTEL_TXT is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
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
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_FPU=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
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
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
CONFIG_AVERAGE=y

--v9Ux+11Zm5mwPlX6--
