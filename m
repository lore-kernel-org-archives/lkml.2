Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1A0JMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 04:12:17 -0500
Received: from www.tglx.de ([62.245.132.106]:54568 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1A0JMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:12:13 -0500
Date: Thu, 27 Jan 2011 14:41:47 +0530
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: David Gibson <david@gibson.dropbear.id.au>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH TIP 03/14] x86/dtb: Add a device tree for CE4100
Message-ID: <20110127091147.GA9770@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-4-git-send-email-bigeasy@linutronix.de> <20110127050027.GB23443@yookeroo>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110127050027.GB23443@yookeroo>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Gibson | 2011-01-27 15:00:27 [+1000]:

>> +	soc@0 {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		compatible = "intel,ce4100-immr";
>> +		ranges;
>
>IMMR is probably not the name you want.  I'm guessing you're taking
>this by anology with the IMMR thingies in Freescale chips.  However in
>that case the name is coming from the IMMR register which can
>physically relocate the batch of IOs represented by the node.  You
>should probably name it something appropriate to your chip instead.

I though IMMR stands for "internel memory mapped regisgters". The spec
does not say anything about a name. In fact there are just devices
popping up. Some of them are part of a group but lapic or the primary
ioapic are just there.
Let me look, maybe I find something more appropriate. Would -soc be
better?

>
>> +		ioapic1: pic@fec00000 {
>
>The name should be "interrupt-controller" rather than pic.
okay.

>> +
>> +			isa@0 {
>> +				#address-cells = <2>;
>> +				#size-cells = <1>;
>> +				compatible = "isa";
>> +				ranges = <1 0 0 0 0 0x100>;
>> +
>> +				rtc@70 {
>> +					compatible = "intel,ce4100-rtc", "motorola,mc146818";
>> +					interrupts = <8 3>;
>> +					interrupt-parent = <&ioapic1>;
>> +					ctrl-reg = <2>;
>> +					freq-reg = <0x26>;
>> +					reg = <1 0x70 2>;
>> +				};
>
>Is the rtc really wired directly to the ioapic without going through
>the cascaded i8259 which usually inhabits isa busses?
I don't see it anywhere in the spec describing like that but that is the
way it behaves. In the non-apic mode it goes through the cascaded i8259.
Once we are in apic mode, the i8259 is switched off and the rtc's
interrupt apears on ioapic. If the entry for pin 8 on ioapic is not
configured, then the interrupt does not appear.
The spec says that the rtc is part of the legacy cluster which contains
all the "legacy" devices like i8259 or rtc. The uart for instance is not
part of it. This legacy cluster is behind PCI, behind the isa bridge.
And I belive this device is also in-core.

>> +			};
>> +
>> +			/* Secondary IO-APIC */
>> +			ioapic2: pic@bffff000 {
>> +				#interrupt-cells = <2>;
>> +				compatible = "intel,ioapic-ce4100", "intel,ioapic";
>> +				interrupt-controller;
>> +				reg = <0x100 0x0 0x0 0x0 0x0>;
>> +				assigned-addresses = <0x02000000 0x0 0xbffff000 0x0 0x1000>;
>
>If this is a cascaded interrupt controller, then it should have an
>interrupts and interrupt-parent property to point at the correct
>cascade interrupt on the master ioapic.
No, it is not cascaded. It is the second ioapic (interrupt controller).
This ioapic communicates via the apic bus with the lapic in order to
generate an interrupt. The primary ioapic is not involved.

>
>> +			};
>> +
>> +			pci@av {
>> +				#address-cells = <3>;
>> +				#interrupt-cells = <1>;
>> +				#size-cells = <2>;
>> +				compatible = "intel,ce4100-pci";
>> +				device_type = "pci";
>> +				bus-range = <1 1>;
>> +				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
>> +
>> +				interrupt-map-mask = <0xffffff 0x0 0x0 0x0>;
>> +				interrupt-map = <
>> +					/* GFX: 0x2E5B */
>> +					0x11000 0x0 0x0 0x0 &ioapic2 0 0x1
>> +					/* ***** FIXME ****** Compositing Engine: 0x2E72 */
>> +					/* 0x11100 0x0 0x0 0x1 &ioapic2 0 0x1 */
>> +					/* MFD: 0x2E5C */
>> +					0x11800 0x0 0x0 0x0 &ioapic2 2 0x1
>> +					/* TS Prefilter: 0x2E5D */
>> +					0x12000 0x0 0x0 0x0 &ioapic2 4 0x1
>> +					/* TS Demux: 0x2E5E */
>> +					0x12100 0x0 0x0 0x0 &ioapic2 5 0x1
>> +					/* ***** FIXME ***** Audio DSP: 0x2E5F */
>> +					/* 0x13000 0x0 0x0 0x1 &ioapic2 0 0x1 */
>> +					/* Audio Interfaces: 0x2E60 */
>> +					0x13200 0x0 0x0 0x0 &ioapic2 8 0x1
>> +					/* VDC: 0x2E61 */
>> +					0x14000 0x0 0x0 0x0 &ioapic2 9 0x1
>> +					/* DPE: 0x2E62 */
>> +					0x14100 0x0 0x0 0x0 &ioapic2 10 0x1
>> +					/* HDMI Tx: 0x2E63 */
>> +					0x14200 0x0 0x0 0x0 &ioapic2 11 0x1
>> +					/* SEC: 0x2E64 */
>> +					0x14800 0x0 0x0 0x0 &ioapic2 12 0x1
>> +					/* EXP: 0x2E65 */
>> +					0x15000 0x0 0x0 0x0 &ioapic2 13 0x1
>> +					/* UART0/1: 0x2E66 */
>> +					0x15800 0x0 0x0 0x0 &ioapic2 14 0x1
>> +					/* GPIO: 0x2E67 */
>> +					0x15900 0x0 0x0 0x0 &ioapic2 15 0x1
>> +					/* I2C0/1/2: 0x2E68 */
>> +					0x15a00 0x0 0x0 0x0 &ioapic2 16 0x1
>> +					/* Smart Card 0/1: 0x2E69 */
>> +					0x15b00 0x0 0x0 0x0 &ioapic2 15 0x1
>> +					/* SPI: 0x2E6A */
>> +					0x15c00 0x0 0x0 0x0 &ioapic2 15 0x1
>> +					/* MSPOD: 0x2E6B */
>> +					0x15d00 0x0 0x0 0x0 &ioapic2 19 0x1
>> +					/* IR: 0x2E6C */
>> +					0x15e00 0x0 0x0 0x0 &ioapic2 16 0x1
>> +					/* **** FIXME ***** DFX: 0x2E6D */
>> +					/* 0x15f00 0x0 0x0 0x1 &ioapic2 0x0 0x1 */
>> +					/* Gig Ethernet: 0x2E6E */
>> +					0x16000 0x0 0x0 0x0 &ioapic2 21 0x1
>> +					/* IEEE1588 and Clock Recovery Unit: 0x2E6F */
>> +					0x16100 0x0 0x0 0x0 &ioapic2 3 0x1
>> +					/* USB0: 0x2E70 */
>> +					0x16800 0x0 0x0 0x0 &ioapic2 22 0x3
>> +					/* USB1: 0x2E70 */
>> +					0x16900 0x0 0x0 0x0 &ioapic2 22 0x3
>> +					/* SATA: 0x2E71 */
>> +					0x17000 0x0 0x0 0x0 &ioapic2 23 0x3
>
>Are all these interrupt map entries representing on-board PCI devices
>that have their interrupts wired direct to the APIC, instead of via
>the PCI INTA..D lines?  
To some degree yes. There are three modes in which the system can
operate. The legacy mode where all devices end up sharing one interrupt
line, the multi mode which uses the interrupt pin (INTA..D) are used and
the inetrrupt is also routed to the legacy pic. In APIC mode (which is
used) each device is routed directly to the ioapic.
However, all of these devices are in-core, there is no external PCI bus
where you can plug in cards. This internal PCI bus looks more or less
like an emulated PCI bus.

>If so, it might be better to create device
>nodes for those devices with interrupts and interrupt-parent
>properties giving their interrupt routing, leaving the PCI bus's
>interrupt-map to describe only the routing for slotted PCI devices
>with their INTA..D wired with the rest of the PCI lines.
The INTA..D information is not part of the address and I hoped to get
away with this. There are no slotted pci devies.
So if I come up with nodes for the devices then I would need the reg
property and a compatible property.

>
>> +					>;
>> +
>> +				i2c-controller@15a00,0,0 {
>
>Uh.. that unit address does not look right.  The encoding of PCI
>3-cell addresses into a unit address string is not simply comma
>separated cells.  I forget the details, so you'll need to check the OF
>PCI binding.

Grant wrote [0]:
|You'll also note that I added ',0,0' to the end of the address.
|That's because the node address reflects the parent bus address format
|which uses 3 cells in this case.

I try to look that part up in the pci binding.

[0]
http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg02806.html

Sebastian
