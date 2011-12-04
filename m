Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1LDPG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 10:06:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32955 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1LDPGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 10:06:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>
	<20111130154445.GA27198@gere.osrc.amd.com>
	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>
	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>
	<4EDB6C10.10102@ladisch.de>
	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>
	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>
	<CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com>
Date: Sun, 4 Dec 2011 16:06:24 +0100
Message-ID: <CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finished patching and testing kernel 3.2.0-rc2.

Also added #define DEBUG and running with cmdline "debug apic=debug"

The AHCI interrupt was successfully moved to IRQ 40. Good patchwork !

Up for only 10 min., IRQ 19 has not been revoked However, I already
lost IRQ 16 after 2 minutes. This kernel doesn't have support for any
audio, so there was only firewire_ohci on this line. However, lspci
for this device shows a firm INTx+. Cleared that by rmmod'ing and
modprobe'ing firewire_ohci again. After 20 min. IRQ 19 was lost again.

Now _I_ am lost. The only thing that IRQ 16 and IRQ 19 have in common
is that there are devices on them that do have an INTx line but do not
use it (MSI instead). However, I ran this kernel with pci=nomsi
(earlier post) and IRQs 16 and 19 went down as well. IRQs 17 and 18
were never revoked.

Yours truly puzzled,

J.



$ uname -r

3.2.0-rc2


$ cat /proc/interrupts

           CPU0       CPU1
  0:         44          2   IO-APIC-edge      timer
  1:          0          0   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0          2   IO-APIC-edge      i8042
 16:         15      99986   IO-APIC-fasteoi   firewire_ohci
 17:          0        110   IO-APIC-fasteoi   ehci_hcd:usb6,
ehci_hcd:usb8, ehci_hcd:usb9
 18:          3         37   IO-APIC-fasteoi   ohci_hcd:usb3,
ohci_hcd:usb4, ohci_hcd:usb5, ohci_hcd:usb7
 19:        156         21   IO-APIC-fasteoi   eth1
 40:      26986       6951   PCI-MSI-edge      ahci
 41:       1268        125   PCI-MSI-edge      eth0
 42:          0          0   PCI-MSI-edge      xhci_hcd
 43:          0          0   PCI-MSI-edge      xhci_hcd
 44:          0          0   PCI-MSI-edge      xhci_hcd
NMI:          0          0   Non-maskable interrupts
LOC:      16629      27721   Local timer interrupts
SPU:          0          0   Spurious interrupts
PMI:          0          0   Performance monitoring interrupts
IWI:          0          0   IRQ work interrupts
RES:       5957       3060   Rescheduling interrupts
CAL:        138        174   Function call interrupts
TLB:        345        234   TLB shootdowns
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:          2          2   Machine check polls
ERR:          1
MIS:          0


$ sudo lspci -vv -s05:02.0

05:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire
II(M)] IEEE 1394 OHCI Controller (rev c0) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. M4A series motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
        Latency: 32 (8000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fea60000 (32-bit, non-prefetchable) [size=2K]
        Region 1: I/O ports at d000 [size=128]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA
PME(D0-,D1-,D2+,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: firewire_ohci
        Kernel modules: firewire-ohci


dmesg log from the patch:

[    0.279002] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.279021] pci 0000:00:11.0: calling quirk_no_ata_d3+0x0/0x1b
[    0.279030] pci 0000:00:11.0: calling quirk_mmio_always_on+0x0/0x17
[    0.279053] pci 0000:00:11.0: reg 10: [io  0xf140-0xf147]
[    0.279072] pci 0000:00:11.0: reg 14: [io  0xf130-0xf133]
[    0.279091] pci 0000:00:11.0: reg 18: [io  0xf120-0xf127]
[    0.279110] pci 0000:00:11.0: reg 1c: [io  0xf110-0xf113]
[    0.279129] pci 0000:00:11.0: reg 20: [io  0xf100-0xf10f]
[    0.279148] pci 0000:00:11.0: reg 24: [mem 0xfeb4f000-0xfeb4f3ff]
[    0.279174] pci 0000:00:11.0: calling sb7x0_ahci_msi_enable+0x0/0x112
[    0.279195] pci 0000:00:11.0: AHCI: enabled MSI
[    0.279204] pci 0000:00:11.0: calling quirk_resource_alignment+0x0/0x16b


dmesg log from lost IRQ 16:

[  104.618738] irq 16: nobody cared (try booting with the "irqpoll" option)
[  104.618750] Pid: 0, comm: kworker/0:0 Not tainted 3.2.0-rc2 #7
[  104.618754] Call Trace:
[  104.618757]  <IRQ>  [<ffffffff810bb9cd>] __report_bad_irq+0x3d/0xe0
[  104.618774]  [<ffffffff810bbe0d>] note_interrupt+0x14d/0x210
[  104.618780]  [<ffffffff810b98a4>] handle_irq_event_percpu+0xc4/0x290
[  104.618786]  [<ffffffff810b9ab8>] handle_irq_event+0x48/0x70
[  104.618792]  [<ffffffff810bc7fa>] handle_fasteoi_irq+0x5a/0xe0
[  104.618799]  [<ffffffff81004012>] handle_irq+0x22/0x40
[  104.618805]  [<ffffffff81506baa>] do_IRQ+0x5a/0xd0
[  104.618812]  [<ffffffff814fe76b>] common_interrupt+0x6b/0x6b
[  104.618815]  <EOI>  [<ffffffff81009906>] ? native_sched_clock+0x26/0x70
[  104.618832]  [<ffffffffa00c50d3>] ?
acpi_idle_enter_simple+0xc5/0x102 [processor]
[  104.618840]  [<ffffffffa00c50ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[  104.618848]  [<ffffffff814223b8>] cpuidle_idle_call+0xb8/0x230
[  104.618855]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[  104.618861]  [<ffffffff814efa56>] start_secondary+0x1ed/0x1f4
[  104.618866] handlers:
[  104.618874] [<ffffffffa00ad280>] irq_handler
[  104.618878] Disabling IRQ #16


dmesg log from firewire_ohci reloading:

[ 1041.257730] firewire_ohci 0000:05:02.0: PCI INT A disabled
[ 1041.257737] firewire_ohci: Removed fw-ohci device.
[ 1062.915595] firewire_ohci 0000:05:02.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[ 1062.915610] firewire_ohci 0000:05:02.0: calling quirk_via_vlink+0x0/0xd0
[ 1062.980387] firewire_ohci: Added fw-ohci device 0000:05:02.0, OHCI
v1.10, 4 IR + 8 IT contexts, quirks 0x11
[ 1063.481956] firewire_core: created device fw0: GUID 001e8c0000509146, S400


dmesg log from lost IRQ 19:

[ 1205.490580] irq 19: nobody cared (try booting with the "irqpoll" option)
[ 1205.490592] Pid: 0, comm: swapper Not tainted 3.2.0-rc2 #7
[ 1205.490596] Call Trace:
[ 1205.490599]  <IRQ>  [<ffffffff810bb9cd>] __report_bad_irq+0x3d/0xe0
[ 1205.490616]  [<ffffffff810bbe0d>] note_interrupt+0x14d/0x210
[ 1205.490623]  [<ffffffff810b98a4>] handle_irq_event_percpu+0xc4/0x290
[ 1205.490629]  [<ffffffff810b9ab8>] handle_irq_event+0x48/0x70
[ 1205.490635]  [<ffffffff810bc7fa>] handle_fasteoi_irq+0x5a/0xe0
[ 1205.490642]  [<ffffffff81004012>] handle_irq+0x22/0x40
[ 1205.490649]  [<ffffffff81506baa>] do_IRQ+0x5a/0xd0
[ 1205.490655]  [<ffffffff814fe76b>] common_interrupt+0x6b/0x6b
[ 1205.490658]  <EOI>  [<ffffffff81009906>] ? native_sched_clock+0x26/0x70
[ 1205.490677]  [<ffffffffa00c50d3>] ?
acpi_idle_enter_simple+0xc5/0x102 [processor]
[ 1205.490684]  [<ffffffffa00c50ce>] ?
acpi_idle_enter_simple+0xc0/0x102 [processor]
[ 1205.490692]  [<ffffffff814223b8>] cpuidle_idle_call+0xb8/0x230
[ 1205.490699]  [<ffffffff81001215>] cpu_idle+0xc5/0x130
[ 1205.490706]  [<ffffffff814e2370>] rest_init+0x94/0xa4
[ 1205.490713]  [<ffffffff81aafba4>] start_kernel+0x3a7/0x3b4
[ 1205.490719]  [<ffffffff81aaf322>] x86_64_start_reservations+0x132/0x136
[ 1205.490725]  [<ffffffff81aaf416>] x86_64_start_kernel+0xf0/0xf7
[ 1205.490729] handlers:
[ 1205.490736] [<ffffffffa01164f0>] e1000_intr
[ 1205.490740] Disabling IRQ #19
