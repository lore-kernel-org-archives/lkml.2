Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839Ab0CPFYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:24:08 -0400
Received: from complete.lackof.org ([198.49.126.79]:34151 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659Ab0CPFYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:24:06 -0400
Date: Mon, 15 Mar 2010 23:24:03 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: PCI express switch handling ..
Message-ID: <20100316052403.GB31551@lackof.org>
References: <1a297b361003141218g783d1880p98b15749d01bd813@mail.gmail.com> <20100315053209.GC28926@lackof.org> <1a297b361003142315y23619cc9v94184161a2380f9f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a297b361003142315y23619cc9v94184161a2380f9f@mail.gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 10:15:55AM +0400, Manu Abraham wrote:
> > Can you post "lspci -vt" and "lspci -v" output?
> > It will tell us alot more about the heirarchy and address space routing.
> 
> 
> Sure, I have added both to this mail.

Thanks!

> >> I am wondering if i need to access or address the switch specifically
> >> to forward data specifically to one of the bridges behind the switch.
> >
> > No. MMIO routing is handling by MMIO "window" register in the bridge.
> 
> 
> 
> 
> To clarify, do you mean the window register in the
> 
> PCI bridge (PEX 8604)
> or
> Multimedia controller (7231)

PCI Bridge.
The BAR range shown by the Multimedia controller isn't really a "window"
in the same sense since it's only used to route MMIO traffic down stream. 
Bridge windows typically imply negative decoding for upstream MMIO
transactions.

> Since both show memory regions.
> 
> 06:00.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
>         Flags: bus master, fast devsel, latency 0
>         Memory at fb3e0000 (32-bit, non-prefetchable) [size=128K]
>         Bus: primary=06, secondary=07, subordinate=0a, sec-latency=0
>         Memory behind bridge: fa000000-faffffff

"Memory behind Bridge" is the "window" register I'm talking about (16MB).

"Memory at" isn't routed anywhere else - ie Bridge itself will respond
to 0xfb3e0000 range (128K size).
 
> 09:00.0 Multimedia controller: Philips Semiconductors Device 7231 (rev aa)
>         Subsystem: Modular Technology Holdings Ltd Device 3595
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at fac00000 (64-bit, non-prefetchable) [size=4M]
>         Memory at fa800000 (64-bit, non-prefetchable) [size=4M]
> 
> 0a:00.0 Multimedia controller: Philips Semiconductors Device 7231 (rev aa)
>         Subsystem: Modular Technology Holdings Ltd Device 3585
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at fa400000 (64-bit, non-prefetchable) [size=4M]
>         Memory at fa000000 (64-bit, non-prefetchable) [size=4M]
> 
> If it is the memory region on the PEX8604, it implies that I do have
> to handle that memory region in the driver for the card as well ?

Each Multimedia device above has two 4MB ranges that effectively uses
*all* of the MMIO space routed "down stream" by the parent bridge.

The multimedia device driver has to (a) "claim" and (b) enable the
decoding of those 4MB ranges using linux kernel interfaces described
by Documentation/PCI/pci.txt .

> The rationale for that thought was the vague feeling, that the PCIe
> switch would be somehow supported in the kernel, ie the pcieport
> driver in use by the hardware also made me feel more to think that
> way.

For "normal" use (your use), the kernel already knows how to configure
the PCI-E bridge windows and assign bus numbers already since the PLX
devices comply with PCI Local Bus Spec for Configuration Header type 0.
Generally, BIOS is doing that already and the kernel tries to play
along nicely if the BIOS isn't obviously buggy in it's PCI config handling.

The PLX chips have some special modes that would require additional
kernel support to use. I've "encouraged" the PLX folks to submit drivers
to kernel.org to support those modes but my guess is they don't have a
business case to do so. Or I've completely missed it. Anyone who wants
to know more will have to talk directly with PLX.


> > While it's called a "switch" because it can route MMIO transactions
> > from one downstream PCI-e link to any other.
> >
> >> At present I can access one of the Multimedia controllers (09:00.0) ,
> >> but it seems I can't access the other one and hence my question as to
> >> determine whether it is something else.
> >
> > "lspci -vt" will show what is visible in PCI Config space.
> 
> manu@manu-04:~$ lspci -vt
> -[0000:00]-+-00.0  Intel Corporation X58 I/O Hub to ESI Port
>            +-01.0-[0000:01]----00.0  Device 1b4b:91a3
>            +-02.0-[0000:02]----00.0  NEC Corporation Device 0194
>            +-03.0-[0000:03]----00.0  nVidia Corporation G96 [GeForce 9500 GT]
>            +-05.0-[0000:04]----00.0  Philips Semiconductors Device 7160
>            +-07.0-[0000:05]----00.0  Philips Semiconductors Pinnacle PCTV 7010iX
>            +-09.0-[0000:06-0a]----00.0-[0000:07-0a]--+-01.0-[0000:08]--
>            |
> +-04.0-[0000:09]----00.0  Philips Semiconductors Device 7231
>            |
> \-05.0-[0000:0a]----00.0  Philips Semiconductors Device 7231

Urgh.  The point of "-vt" is to have indentation and your mailer "fixed it".
Don't need to resend since I can explain (I think).

00:09.0 is Intel Host Bridge.
   06:00.0 is PLX upstream port
   07:01.0 is PLX downstream port
        08:   no connection
        09:00.0 Multimedia device #1
        0a:00.0 Multimedia device #2

...
> > "lspci -v" will tell us how the bridge is configured.
> 
> manu@manu-04:~$ sudo lspci -v
...
> 00:09.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 9 (rev 13)
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=06, subordinate=0a, sec-latency=0
>         Memory behind bridge: fa000000-fb3fffff

That's routing total 20MB of MMIO address space.

>         Capabilities: [40] Subsystem: Giga-byte Technology Device 5001
>         Capabilities: [60] Message Signalled Interrupts: Mask+ 64bit-
> Queue=0/1 Enable+
>         Capabilities: [90] Express Root Port (Slot+), MSI 00
>         Capabilities: [e0] Power Management version 3
>         Capabilities: [100] Advanced Error Reporting <?>
>         Capabilities: [150] Access Controls <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 00:10.0 PIC: Intel Corporation 5520/5500/X58 Physical and Link Layer
> Registers Port 0 (rev 13)
>         Flags: fast devsel
>         Capabilities: [50] Vendor Specific Information <?>
> 
> 00:10.1 PIC: Intel Corporation 5520/5500/X58 Routing and Protocol
> Layer Registers Port 0 (rev 13)
>         Flags: fast devsel
> 
> 00:11.0 PIC: Intel Corporation 5520/5500 Physical and Link Layer
> Registers Port 1 (rev 13)
>         Flags: fast devsel
>         Capabilities: [50] #00 [0000]
> 
> 00:11.1 PIC: Intel Corporation 5520/5500 Routing & Protocol Layer
> Register Port 1 (rev 13)
>         Flags: fast devsel
> 
> 00:13.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC
> Interrupt Controller (rev 13) (prog-if 20)
>         Flags: bus master, fast devsel, latency 0
>         Memory at fbfff000 (32-bit, non-prefetchable) [size=4K]
>         Capabilities: [6c] Power Management version 3
> 
> 00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
> Registers (rev 13)
>         Flags: fast devsel
>         Capabilities: [40] Express Root Complex Integrated Endpoint,
> MSI 00
> 
> 00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
> Pad Registers (rev 13)
>         Flags: fast devsel
>         Capabilities: [40] Express Root Complex Integrated Endpoint,
> MSI 00
> 
> 00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
> and RAS Registers (rev 13)
>         Flags: fast devsel
>         Capabilities: [40] Express Root Complex Integrated Endpoint,
> MSI 00
> 
> 00:15.0 PIC: Intel Corporation 5520/5500/X58 Trusted Execution
> Technology Registers (rev 13) (prog-if 20)
>         Flags: fast devsel
> 
> 00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #4
>         Subsystem: Giga-byte Technology Device 5004
>         Flags: bus master, medium devsel, latency 0, IRQ 16
>         I/O ports at ff00 [size=32]
>         Capabilities: [50] PCIe advanced features <?>
>         Kernel driver in use: uhci_hcd
> 
> 00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #5
>         Subsystem: Giga-byte Technology Device 5004
>         Flags: bus master, medium devsel, latency 0, IRQ 21
>         I/O ports at fe00 [size=32]
>         Capabilities: [50] PCIe advanced features <?>
>         Kernel driver in use: uhci_hcd
> 
> 00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #6
>         Subsystem: Giga-byte Technology Device 5004
>         Flags: bus master, medium devsel, latency 0, IRQ 18
>         I/O ports at fd00 [size=32]
>         Capabilities: [50] PCIe advanced features <?>
>         Kernel driver in use: uhci_hcd
> 
> 00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
> EHCI Controller #2 (prog-if 20)
>         Subsystem: Giga-byte Technology Device 5006
>         Flags: bus master, medium devsel, latency 0, IRQ 18
>         Memory at fbffe000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Capabilities: [98] PCIe advanced features <?>
>         Kernel driver in use: ehci_hcd
> 
> 00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
> Audio Controller
>         Subsystem: Giga-byte Technology Device a102
>         Flags: bus master, fast devsel, latency 0, IRQ 22
>         Memory at fbff4000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>         Capabilities: [70] Express Root Complex Integrated Endpoint,
> MSI 00
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [130] Root Complex Link <?>
>         Kernel driver in use: HDA Intel
>         Kernel modules: snd-hda-intel
> 
> 00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 1
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
>         Capabilities: [40] Express Root Port (Slot+), MSI 00
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable+
>         Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
>         Capabilities: [a0] Power Management version 2
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [180] Root Complex Link <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 2
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
>         I/O behind bridge: 0000b000-0000bfff
>         Memory behind bridge: fbd00000-fbdfffff
>         Capabilities: [40] Express Root Port (Slot+), MSI 00
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable+
>         Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
>         Capabilities: [a0] Power Management version 2
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [180] Root Complex Link <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 5
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
>         I/O behind bridge: 0000a000-0000afff
>         Memory behind bridge: fbc00000-fbcfffff
>         Prefetchable memory behind bridge: 00000000fbb00000-00000000fbbfffff
>         Capabilities: [40] Express Root Port (Slot+), MSI 00
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable+
>         Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
>         Capabilities: [a0] Power Management version 2
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [180] Root Complex Link <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 6
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=0e, subordinate=0e, sec-latency=0
>         I/O behind bridge: 0000e000-0000efff
>         Memory behind bridge: fba00000-fbafffff
>         Prefetchable memory behind bridge: 00000000fb900000-00000000fb9fffff
>         Capabilities: [40] Express Root Port (Slot+), MSI 00
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable+
>         Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
>         Capabilities: [a0] Power Management version 2
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [180] Root Complex Link <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #1
>         Subsystem: Giga-byte Technology Device 5004
>         Flags: bus master, medium devsel, latency 0, IRQ 23
>         I/O ports at fc00 [size=32]
>         Capabilities: [50] PCIe advanced features <?>
>         Kernel driver in use: uhci_hcd
> 
> 00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #2
>         Subsystem: Giga-byte Technology Device 5004
>         Flags: bus master, medium devsel, latency 0, IRQ 19
>         I/O ports at fb00 [size=32]
>         Capabilities: [50] PCIe advanced features <?>
>         Kernel driver in use: uhci_hcd
> 
> 00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #3
>         Subsystem: Giga-byte Technology Device 5004
>         Flags: bus master, medium devsel, latency 0, IRQ 18
>         I/O ports at fa00 [size=32]
>         Capabilities: [50] PCIe advanced features <?>
>         Kernel driver in use: uhci_hcd
> 
> 00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
> EHCI Controller #1 (prog-if 20)
>         Subsystem: Giga-byte Technology Device 5006
>         Flags: bus master, medium devsel, latency 0, IRQ 23
>         Memory at fbffd000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Capabilities: [98] PCIe advanced features <?>
>         Kernel driver in use: ehci_hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 01)
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=0f, subordinate=0f, sec-latency=32
>         Memory behind bridge: fb700000-fb7fffff
>         Prefetchable memory behind bridge: 00000000fb600000-00000000fb6fffff
>         Capabilities: [50] Subsystem: Giga-byte Technology Device 5000
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
>         Subsystem: Giga-byte Technology Device 5001
>         Flags: bus master, medium devsel, latency 0
>         Capabilities: [e0] Vendor Specific Information <?>
>         Kernel modules: iTCO_wdt
> 
> 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
> AHCI Controller (prog-if 01)
>         Subsystem: Giga-byte Technology Device b005
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 38
>         I/O ports at f900 [size=8]
>         I/O ports at f800 [size=4]
>         I/O ports at f700 [size=8]
>         I/O ports at f600 [size=4]
>         I/O ports at f500 [size=32]
>         Memory at fbffc000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/4 Enable+
>         Capabilities: [70] Power Management version 3
>         Capabilities: [a8] SATA HBA <?>
>         Capabilities: [b0] PCIe advanced features <?>
>         Kernel driver in use: ahci
> 
> 00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
>         Subsystem: Giga-byte Technology Device 5001
>         Flags: medium devsel, IRQ 7
>         Memory at fbffb000 (64-bit, non-prefetchable) [size=256]
>         I/O ports at 0500 [size=32]
>         Kernel modules: i2c-i801
> 
> 01:00.0 IDE interface: Device 1b4b:91a3 (rev 11) (prog-if 85 [Master SecO PriO])
>         Subsystem: Giga-byte Technology Device b000
>         Flags: bus master, fast devsel, latency 0, IRQ 11
>         I/O ports at cf00 [size=8]
>         I/O ports at ce00 [size=4]
>         I/O ports at cd00 [size=8]
>         I/O ports at cc00 [size=4]
>         I/O ports at cb00 [size=16]
>         Memory at fb5ff000 (32-bit, non-prefetchable) [size=2K]
>         [virtual] Expansion ROM at f4000000 [disabled] [size=64K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
> Queue=0/0 Enable-
>         Capabilities: [70] Express Legacy Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting <?>
> 
> 02:00.0 USB Controller: NEC Corporation Device 0194 (rev 03) (prog-if 30)
>         Subsystem: Giga-byte Technology Device 5007
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at fb4fe000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [50] Power Management version 3
>         Capabilities: [70] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/3 Enable-
>         Capabilities: [90] MSI-X: Enable- Mask- TabSize=8
>         Capabilities: [a0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting <?>
>         Capabilities: [140] Device Serial Number
> ff-ff-ff-ff-ff-ff-ff-ff
>         Capabilities: [150] #18
>         Kernel driver in use: xhci_hcd
>         Kernel modules: xhci
> 
> 03:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce
> 9500 GT] (rev a1)
>         Subsystem: XFX Pine Group Inc. Device 400a
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
>         Memory at e0000000 (64-bit, prefetchable) [size=256M]
>         Memory at f6000000 (64-bit, non-prefetchable) [size=32M]
>         I/O ports at df00 [size=128]
>         [virtual] Expansion ROM at f9000000 [disabled] [size=512K]
>         Capabilities: [60] Power Management version 3
>         Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>         Capabilities: [78] Express Endpoint, MSI 00
>         Capabilities: [b4] Vendor Specific Information <?>
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [128] Power Budgeting <?>
>         Capabilities: [600] Vendor Specific Information <?>
>         Kernel driver in use: nvidia
>         Kernel modules: nvidia, nvidiafb
> 
> 04:00.0 Multimedia controller: Philips Semiconductors Device 7160 (rev 01)
>         Subsystem: Philips Semiconductors Device 0000
>         Flags: bus master, fast devsel, latency 0, IRQ 11
>         Memory at fbe00000 (64-bit, non-prefetchable) [size=1M]
>         Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/5 Enable-
>         Capabilities: [50] Express Endpoint, MSI 00
>         Capabilities: [74] Power Management version 2
>         Capabilities: [80] Vendor Specific Information <?>
>         Capabilities: [100] Vendor Specific Information <?>
> 
> 05:00.0 Multimedia controller: Philips Semiconductors Pinnacle PCTV 7010iX
>         Subsystem: Pinnacle Systems Inc. Device 0101
>         Flags: bus master, fast devsel, latency 0, IRQ 11
>         Memory at fb800000 (64-bit, non-prefetchable) [size=1M]
>         Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/5 Enable-
>         Capabilities: [50] Express Endpoint, MSI 00
>         Capabilities: [74] Power Management version 2
>         Capabilities: [80] Vendor Specific Information <?>
>         Capabilities: [100] Vendor Specific Information <?>

The above two Multimedia devices are NOT below the PLX bridge.

> 06:00.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
>         Flags: bus master, fast devsel, latency 0
>         Memory at fb3e0000 (32-bit, non-prefetchable) [size=128K]
>         Bus: primary=06, secondary=07, subordinate=0a, sec-latency=0
>         Memory behind bridge: fa000000-faffffff

PLX "upstream" Bridge port.
0xfa000000-0xfaffffff is 16 of 20MB routed to downstream devices.

The 0xfb3e0000 range is part of the 4MB assigned to bus 06

>         Capabilities: [40] Power Management version 3
>         Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+
> Queue=0/2 Enable+
>         Capabilities: [68] Express Upstream Port, MSI 00
>         Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8604
>         Capabilities: [100] Device Serial Number
> 00-0e-df-b5-10-01-86-ba
>         Capabilities: [fb4] Advanced Error Reporting <?>
>         Capabilities: [138] Power Budgeting <?>
>         Capabilities: [148] Virtual Channel <?>
>         Capabilities: [448] Vendor Specific Information <?>
>         Capabilities: [950] Vendor Specific Information <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 07:01.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=07, secondary=08, subordinate=08, sec-latency=0

Downstream PLX port #1.
Note there is no "local" MMIO address associated.

>         Capabilities: [40] Power Management version 3
>         Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+
> Queue=0/2 Enable+
>         Capabilities: [68] Express Downstream Port (Slot+), MSI 00
>         Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8604
>         Capabilities: [100] Device Serial Number
> 00-0e-df-b5-10-01-86-ba
>         Capabilities: [fb4] Advanced Error Reporting <?>
>         Capabilities: [148] Virtual Channel <?>
>         Capabilities: [520] Access Controls <?>
>         Capabilities: [950] Vendor Specific Information <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 07:04.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=07, secondary=09, subordinate=09, sec-latency=0
>         Memory behind bridge: fa800000-faffffff

Downstream PLX port #2.
One 8MB range is routed to downstream "09:00.0 Multimedia controller".

>         Capabilities: [40] Power Management version 3
>         Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+
> Queue=0/2 Enable+
>         Capabilities: [68] Express Downstream Port (Slot+), MSI 00
>         Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8604
>         Capabilities: [100] Device Serial Number
> 00-0e-df-b5-10-01-86-ba
>         Capabilities: [fb4] Advanced Error Reporting <?>
>         Capabilities: [148] Virtual Channel <?>
>         Capabilities: [520] Access Controls <?>
>         Capabilities: [950] Vendor Specific Information <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 07:05.0 PCI bridge: PLX Technology, Inc. Device 8604 (rev ba)
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=07, secondary=0a, subordinate=0a, sec-latency=0
>         Memory behind bridge: fa000000-fa7fffff

Downstream PLX port #3.
One 8MB range is routed to downstream "0a:00.0 Multimedia controller".

>         Capabilities: [40] Power Management version 3
>         Capabilities: [48] Message Signalled Interrupts: Mask+ 64bit+
> Queue=0/2 Enable+
>         Capabilities: [68] Express Downstream Port (Slot+), MSI 00
>         Capabilities: [a4] Subsystem: PLX Technology, Inc. Device 8604
>         Capabilities: [100] Device Serial Number
> 00-0e-df-b5-10-01-86-ba
>         Capabilities: [fb4] Advanced Error Reporting <?>
>         Capabilities: [148] Virtual Channel <?>
>         Capabilities: [520] Access Controls <?>
>         Capabilities: [950] Vendor Specific Information <?>
>         Kernel driver in use: pcieport-driver
>         Kernel modules: shpchp
> 
> 09:00.0 Multimedia controller: Philips Semiconductors Device 7231 (rev aa)
>         Subsystem: Modular Technology Holdings Ltd Device 3595
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at fac00000 (64-bit, non-prefetchable) [size=4M]
>         Memory at fa800000 (64-bit, non-prefetchable) [size=4M]
>         Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/4 Enable-
>         Capabilities: [50] Express Endpoint, MSI 00
>         Capabilities: [74] Power Management version 3
>         Capabilities: [7c] Vendor Specific Information <?>
>         Capabilities: [100] Vendor Specific Information <?>
>         Kernel driver in use: SAA7231 Drv
> 
> 0a:00.0 Multimedia controller: Philips Semiconductors Device 7231 (rev aa)
>         Subsystem: Modular Technology Holdings Ltd Device 3585
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at fa400000 (64-bit, non-prefetchable) [size=4M]
>         Memory at fa000000 (64-bit, non-prefetchable) [size=4M]
>         Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/4 Enable-
>         Capabilities: [50] Express Endpoint, MSI 00
>         Capabilities: [74] Power Management version 3
>         Capabilities: [7c] Vendor Specific Information <?>
>         Capabilities: [100] Vendor Specific Information <?>
>         Kernel driver in use: SAA7231 Drv

So it looks like SAA7231 Driver is already claiming this device.
That's the driver that needs to use APIs described in pci.txt.

So the PCI MMIO configuration/routing all looks kosher to me.

hth,
grant

> 
> 0c:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 AHCI
> Controller (rev 02) (prog-if 01)
>         Subsystem: Giga-byte Technology Device b000
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at fbdfe000 (32-bit, non-prefetchable) [size=8K]
>         Capabilities: [68] Power Management version 2
>         Capabilities: [50] Express Legacy Endpoint, MSI 01
>         Kernel driver in use: ahci
> 
> 0c:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 AHCI
> Controller (rev 02) (prog-if 85 [Master SecO PriO])
>         Subsystem: Giga-byte Technology Device b000
>         Flags: bus master, fast devsel, latency 0, IRQ 18
>         I/O ports at bf00 [size=8]
>         I/O ports at be00 [size=4]
>         I/O ports at bd00 [size=8]
>         I/O ports at bc00 [size=4]
>         I/O ports at bb00 [size=16]
>         Capabilities: [68] Power Management version 2
>         Kernel driver in use: pata_jmicron
> 
> 0d:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
>         Subsystem: Giga-byte Technology Device e000
>         Flags: bus master, fast devsel, latency 0, IRQ 39
>         I/O ports at ae00 [size=256]
>         Memory at fbbff000 (64-bit, prefetchable) [size=4K]
>         Memory at fbbf8000 (64-bit, prefetchable) [size=16K]
>         [virtual] Expansion ROM at fbb00000 [disabled] [size=128K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable+
>         Capabilities: [70] Express Endpoint, MSI 01
>         Capabilities: [ac] MSI-X: Enable- Mask- TabSize=4
>         Capabilities: [cc] Vital Product Data <?>
>         Capabilities: [100] Advanced Error Reporting <?>
>         Capabilities: [140] Virtual Channel <?>
>         Capabilities: [160] Device Serial Number 00-e0-4c-68-00-00-00-04
>         Kernel driver in use: r8169
>         Kernel modules: r8169
> 
> 0e:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
>         Subsystem: Giga-byte Technology Device e000
>         Flags: bus master, fast devsel, latency 0, IRQ 40
>         I/O ports at ee00 [size=256]
>         Memory at fb9ff000 (64-bit, prefetchable) [size=4K]
>         Memory at fb9f8000 (64-bit, prefetchable) [size=16K]
>         [virtual] Expansion ROM at fb900000 [disabled] [size=128K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable+
>         Capabilities: [70] Express Endpoint, MSI 01
>         Capabilities: [ac] MSI-X: Enable- Mask- TabSize=4
>         Capabilities: [cc] Vital Product Data <?>
>         Capabilities: [100] Advanced Error Reporting <?>
>         Capabilities: [140] Virtual Channel <?>
>         Capabilities: [160] Device Serial Number 00-e0-4c-68-00-00-00-04
>         Kernel driver in use: r8169
>         Kernel modules: r8169
> 
> 0f:00.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
> PCI Bridge Controller [Ver 1.0] (rev 01)
>         Subsystem: Twinhan Technology Co. Ltd Device 0031
>         Flags: bus master, medium devsel, latency 32
>         Memory at fb6ff000 (32-bit, prefetchable) [size=4K]
> 
> 0f:06.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23
> IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10)
>         Subsystem: Giga-byte Technology Device 1000
>         Flags: bus master, medium devsel, latency 32, IRQ 18
>         Memory at fb7ff000 (32-bit, non-prefetchable) [size=2K]
>         Memory at fb7f8000 (32-bit, non-prefetchable) [size=16K]
>         Capabilities: [44] Power Management version 2
>         Kernel driver in use: ohci1394
>         Kernel modules: firewire-ohci, ohci1394
> 
> 
> Thanks,
> Manu
