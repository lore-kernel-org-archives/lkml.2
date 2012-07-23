Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab2GWVHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:07:10 -0400
Received: from forward11.mail.yandex.net ([95.108.130.93]:60143 "EHLO
	forward11.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2GWVHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:07:07 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2012 17:07:07 EDT
From: Anton Pyrogovskyi <asp@penguinishly.org.ua>
To: "mjg@redhat.com" <mjg@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: PROBLEM: Re: [PATCH] pci: Rework ASPM disable code
MIME-Version: 1.0
Message-Id: <2806511343077258@web6f.yandex.ru>
Date: Tue, 24 Jul 2012 00:00:58 +0300
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This patch (aka commit 3c076351c, https://lkml.org/lkml/2011/11/10/467) makes my GPU (NVidia GT 240) become undetectable by the NVidia proprietary driver.
The issue used to surface before, but I resolved it by disabling ASPM altogether (adding «pcie_aspm=off» to the kernel parameter line). This no more works since the commit is in order.
The driver not being loaded causes me some obvious trouble, such as uvesafb and X not being able to start.
This only happens during regular boot — if I thaw from hibernation or load the same kernel atop the currently running instance with kexec everything works fine.
Upon reverting the patch and rebuilding the kernel, everything returns to normal permanently and I can live without kexec again.
Tested on 3.4.4 and 3.5.0-rc7+, everything earlier than 3.3.x works as expected (due to not having its ASPM disable code reworked).

Kernel version: any post-3.3

/proc/cpuinfo:

> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
> stepping        : 6
> cpu MHz         : 1596.000
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> apicid          : 0
> initial apicid  : 0
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts tpr_shadow
> bogomips        : 4799.83
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
> stepping        : 6
> cpu MHz         : 1596.000
> cache size      : 4096 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> apicid          : 1
> initial apicid  : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts tpr_shadow
> bogomips        : 4799.83
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:

Respective dmesg output section:

>    [  486.937753] vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=none,decodes=none:owns=io+mem
>    [  486.937781] NVRM: The NVIDIA GPU 0000:01:00.0 (PCI ID: 10de:0ca3) installed
>    [  486.937782] NVRM: in this system is not supported by the 302.17 NVIDIA Linux
>    [  486.937783] NVRM: graphics driver release.  Please see 'Appendix A -
>    [  486.937784] NVRM: Supported NVIDIA GPU Products' in this release's README,
>    [  486.937786] NVRM: available on the Linux graphics driver download page at
>    [  486.937787] NVRM: www.nvidia.com.
>    [  486.937797] nvidia: probe of 0000:01:00.0 failed with error -1

lspci output:

>   01:00.0 VGA compatible controller: NVIDIA Corporation GT215 [GeForce GT 240] (rev a2) (prog-if 00 [VGA controller])
>           Subsystem: ASUSTeK Computer Inc. Device 8326
>           Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>           Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>           Interrupt: pin A routed to IRQ 16
>           Region 0: [virtual] Memory at a0000000 (32-bit, non-prefetchable) [size=16M]
>           Region 1: Memory at 80000000 (64-bit, prefetchable) [size=256M]
>           Region 3: Memory at 90000000 (64-bit, prefetchable) [size=32M]
>           Region 5: I/O ports at 3000 [size=128]
>           [virtual] Expansion ROM at a1080000 [disabled] [size=512K]
>           Capabilities: [60] Power Management version 3
>                   Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                   Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>           Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
>                   Address: 0000000000000000  Data: 0000
>           Capabilities: [78] Express (v2) Endpoint, MSI 00
>                   DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
>                           ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>                   DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                           RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                           MaxPayload 128 bytes, MaxReadReq 512 bytes
>                   DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                   LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <1us, L1 <4us
>                           ClockPM+ Surprise- LLActRep- BwNot-
>                   LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
>                           ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                   LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                   DevCap2: Completion Timeout: Not Supported, TimeoutDis+
>                   DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
>                   LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
>                            Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>                            Compliance De-emphasis: -6dB
>                   LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, EqualizationPhase1-
>                            EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
>           Capabilities: [b4] Vendor Specific Information: Len=14 <?>
>           Capabilities: [100 v1] Virtual Channel
>                   Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                   Arb:    Fixed- WRR32- WRR64- WRR128-
>                   Ctrl:   ArbSelect=Fixed
>                   Status: InProgress-
>                   VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                           Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                           Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                           Status: NegoPending- InProgress-
>           Capabilities: [128 v1] Power Budgeting <?>
>           Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1 Len=024 <?>

/proc/ioports:

> 0000-001f : dma1
> 0020-0021 : pic1
> 0040-0043 : timer0
> 0050-0053 : timer1
> 0060-0060 : keyboard
> 0064-0064 : keyboard
> 0070-0071 : rtc0
> 0080-008f : dma page reg
> 00a0-00a1 : pic2
> 00c0-00df : dma2
> 00f0-00ff : fpu
> 0170-0177 : 0000:00:1f.1
>   0170-0177 : ata_piix
> 01f0-01f7 : 0000:00:1f.1
>   01f0-01f7 : ata_piix
> 0376-0376 : 0000:00:1f.1
>   0376-0376 : ata_piix
> 03c0-03df : vga+
>   03c0-03df : uvesafb
> 03f6-03f6 : 0000:00:1f.1
>   03f6-03f6 : ata_piix
> 03f8-03ff : serial
> 0400-047f : pnp 00:06
>   0400-0403 : ACPI PM1a_EVT_BLK
>   0404-0405 : ACPI PM1a_CNT_BLK
>   0408-040b : ACPI PM_TMR
>   0410-0415 : ACPI CPU throttle
>   0420-0420 : ACPI PM2_CNT_BLK
>   0428-042f : ACPI GPE0_BLK
> 0500-053f : pnp 00:06
> 0680-06ff : pnp 00:06
> 0779-0780 : pnp 00:01
> 0cf8-0cff : PCI conf1
> 1000-1fff : PCI Bus 0000:05
>   1100-111f : 0000:05:01.0
>     1100-111f : EMU10K1
>   1120-1127 : 0000:05:01.1
> 2000-2fff : PCI Bus 0000:04
>   2000-201f : 0000:04:00.0
> 3000-3fff : PCI Bus 0000:01
>   3000-307f : 0000:01:00.0
> 4000-401f : 0000:00:1f.3
>   4000-401f : i801_smbus
> 4020-403f : 0000:00:1d.3
>   4020-403f : uhci_hcd
> 4040-405f : 0000:00:1d.2
>   4040-405f : uhci_hcd
> 4060-407f : 0000:00:1d.1
>   4060-407f : uhci_hcd
> 4080-409f : 0000:00:1d.0
>   4080-409f : uhci_hcd
> 40a0-40af : 0000:00:1f.2
>   40a0-40af : ata_piix
> 40b0-40bf : 0000:00:1f.1
>   40b0-40bf : ata_piix
> 40c0-40c7 : 0000:00:1f.2
>   40c0-40c7 : ata_piix
> 40c8-40cf : 0000:00:1f.2
>   40c8-40cf : ata_piix
> 40e0-40e3 : 0000:00:1f.2
>   40e0-40e3 : ata_piix
> 40e4-40e7 : 0000:00:1f.2
>   40e4-40e7 : ata_piix
> 5000-5fff : PCI Bus 0000:02
> 6000-6fff : PCI Bus 0000:03

Will appreciate any input and provide additional information if requested.
