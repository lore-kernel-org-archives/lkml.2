Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0KZWAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:00:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:46575 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab0KZWAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:00:12 -0500
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Nov 2010 08:57:25 +1100
Message-ID: <1290808645.32570.158.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> + */
> +/dts-v1/;
> +/ {
> +	model = "x86,CE4100";
> +	compatible = "x86,CE4100";

Use a vendor name rather than "x86" here.

> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +
> +	cpus {
> +		x86,Atom@0 {

"Atom" would benefit from being more precise, like adding the model
number. Also you want some properties there defining maybe the mask, the
cache characteristics, etc... There's an exising OFW binding for x86, I
suppose you could follow it. A "reg" property at least is mandatory
here.

Also how do you plan to expose threading capability ?

You probably also want some linkage from the processor to the local APIC
no ?

> +			device_type = "cpu";
> +		};
> +	};
> +
> +	atom@0 {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		device_type = "soc";
> +		compatible = "simple-bus";
> +		ranges;
> +
> +		/* Local APIC */
> +		lapic@fee00000 {
> +			compatible = "intel,lapic";
> +			reg = <0xfee00000 0x1000>;
> +			phys_reg = <0xfee00000>;
> +		};
> +		/* Primary IO-APIC */
> +		ioapic1: pic@fec00000 {
> +			#interrupt-cells = <2>;
> +			compatible = "intel,ioapic";
> +			interrupt-controller;
> +			device_type = "interrupt-controller";
> +			id = <1>;
> +			reg = <0xfec00000 0x1000>;
> +			phys_reg = <0xfec00000>;
> +		};
> +

What are those phys-reg properties ? Also APICs have some kind od
versionning, they aren't all identical, so your compatible property
needs to be more precise at least.

> +		hpet@fed00000 {
> +			compatible = "intel,hpet";
> +			reg = <0xfed00000 0x200>;
> +			phys_reg = <0xfed00000>;
> +		};
> +	};

All HPETs are identical ? If not, make your compatible property more
precise or if they are generally compatible from a programmer
perspective, use two entries from more generic to more specific, for
example:

	compatible = "intel,hpet","intel,hpet-atom-XXYY"

(or make up a numbering/naming scheme that makes sense for Intel gear)

> +	isa@legacy {

So ISA isn't a child of "atom"... that makes "atom" a bit strange as a
node, tho not a big deal per se. I suppose it represent the on-die
peripherals but then you need at least some linkage between that and
the /cpus nodes.

> +		device_type = "isa";
> +		compatible = "simple-bus";

What does "simple-bus" means ? ISA has a well defined binding, you
should follow it.

> +		#address-cells = <2>;
> +		#size-cells = <1>;
> +		ranges = <0 0 0 0x400>;
> +
> +		rtc@legacy {
> +			compatible = "motorola,mc146818";
> +			interrupts = <8 3>;
> +			interrupt-parent = <&ioapic1>;
> +			ctrl_reg = <2>;
> +			freq_reg = <0x26>;
> +			reg = <1 0x70 2>;
> +		};

I think the ISA binding mandate the use of the PNP codes in the
compatible properties, doesn't it ? At least that's the common usage
pattern I've seen so far on powerpc.

Also, "ctrl_reg" and "freq_reg" follow an existing binding ? If not,
then I'd suggest you use "-" instead of "_" which is more common in OFW
land and use more descriptive names since "reg" has a meaning of its own
and the above is a bit confusing.

> +		pci@3fc {
> +			#address-cells = <3>;
> +			#interrupt-cells = <1>;
> +			#size-cells = <1>;
> +			compatible = "intel,ce4100-pci";
> +			device_type = "pci";
> +			bus-range = <0 0>;
> +
> +			/* Secondary IO-APIC */
> +			ioapic2: pic@bffff000 {
> +				#interrupt-cells = <2>;
> +				compatible = "intel,ioapic";
> +				interrupt-controller;
> +				device_type = "interrupt-controller";
> +				id = <2>;
> +				reg = <0x100 0x0 0x0 0x0>;
> +				phys_reg = <0xbffff000>;
> +			};

Here you define a PCI bus with a child device that isn't PCI from what I
can tell, tho the "reg" property content is confusing, and then there's
a unit address that doesn't match "reg" and a "phys_reg" (what the heck
is that ?) that matches the unit-address. Care to explain a bit
more ? :-) I suspect that isn't the right way to represent the secondary
APIC

Also same comments about the compatible property.

> +			pci@av {
> +				#address-cells = <3>;
> +				#interrupt-cells = <1>;
> +				#size-cells = <1>;
> +				compatible = "intel,ce4100-pci";
> +				device_type = "pci";
> +				bus-range = <1 1>;
> +				interrupt-map-mask = <0xffffff 0x0 0x0 0x0>;

I notice that the interrupt number isn't part of your mask, is that
expected ? If you decide to make it so, remember that INT_A is 1 not 0
iirc (dbl check maybe ? I think that's how it is :-)

> +				interrupt-map = <
> +					/* GFX: 0x2E5B */
> +					0x11000 0x0 0x0 0x0 &ioapic2 0 0x1
> +					/* ***** FIXME ****** Compositing Engine: 0x2E72 */
> +					/* 0x11100 0x0 0x0 0x1 &ioapic2 0 0x1 */
> +					/* MFD: 0x2E5C */
> +					0x11800 0x0 0x0 0x0 &ioapic2 2 0x1
> +					/* TS Prefilter: 0x2E5D */
> +					0x12000 0x0 0x0 0x0 &ioapic2 4 0x1
> +					/* TS Demux: 0x2E5E */
> +					0x12100 0x0 0x0 0x0 &ioapic2 5 0x1
> +					/* ***** FIXME ***** Audio DSP: 0x2E5F */
> +					/* 0x13000 0x0 0x0 0x1 &ioapic2 0 0x1 */
> +					/* Audio Interfaces: 0x2E60 */
> +					0x13200 0x0 0x0 0x0 &ioapic2 8 0x1
> +					/* VDC: 0x2E61 */
> +					0x14000 0x0 0x0 0x0 &ioapic2 9 0x1
> +					/* DPE: 0x2E62 */
> +					0x14100 0x0 0x0 0x0 &ioapic2 10 0x1
> +					/* HDMI Tx: 0x2E63 */
> +					0x14200 0x0 0x0 0x0 &ioapic2 11 0x1
> +					/* SEC: 0x2E64 */
> +					0x14800 0x0 0x0 0x0 &ioapic2 12 0x1
> +					/* EXP: 0x2E65 */
> +					0x15000 0x0 0x0 0x0 &ioapic2 13 0x1
> +					/* UART0/1: 0x2E66 */
> +					0x15800 0x0 0x0 0x0 &ioapic2 14 0x1
> +					/* GPIO: 0x2E67 */
> +					0x15900 0x0 0x0 0x0 &ioapic2 15 0x1
> +					/* I2C0/1/2: 0x2E68 */
> +					0x15a00 0x0 0x0 0x0 &ioapic2 16 0x1
> +					/* Smart Card 0/1: 0x2E69 */
> +					0x15b00 0x0 0x0 0x0 &ioapic2 15 0x1
> +					/* SPI: 0x2E6A */
> +					0x15c00 0x0 0x0 0x0 &ioapic2 15 0x1
> +					/* MSPOD: 0x2E6B */
> +					0x15d00 0x0 0x0 0x0 &ioapic2 19 0x1
> +					/* IR: 0x2E6C */
> +					0x15e00 0x0 0x0 0x0 &ioapic2 16 0x1
> +					/* **** FIXME ***** DFX: 0x2E6D */
> +					/* 0x15f00 0x0 0x0 0x1 &ioapic2 0x0 0x1 */
> +					/* Gig Ethernet: 0x2E6E */
> +					0x16000 0x0 0x0 0x0 &ioapic2 21 0x1
> +					/* IEEE1588 and Clock Recovery Unit: 0x2E6F */
> +					0x16100 0x0 0x0 0x0 &ioapic2 3 0x1
> +					/* USB0: 0x2E70 */
> +					0x16800 0x0 0x0 0x0 &ioapic2 22 0x3
> +					/* USB1: 0x2E70 */
> +					0x16900 0x0 0x0 0x0 &ioapic2 22 0x3
> +					/* SATA: 0x2E71 */
> +					0x17000 0x0 0x0 0x0 &ioapic2 23 0x3
> +					>;
> +
> +				i2c@15a00 {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					reg = <0x15a00 0x0 0x0 0x0>;

OFW PCI binding, which we follow, mandates an "assigned-addresses"
property, tho I suppose that if you haven't assigned anything yet (and
will let Linux do so) the above is kosher. Your "reg" is a bit odd but I
don't have time to dbl check vs. the binding right now.

> +					i2c@0 {
> +						reg = <0>;
> +					};
> +
> +					i2c@1 {
> +						#address-cells = <1>;
> +						#size-cells = <0>;
> +						reg = <1>;
> +
> +						pcf8575@26 {
> +							compatible = "ti,pcf8575";
> +							reg = <0x26>;
> +						};
> +					};
> +
> +					i2c@2 {
> +						#address-cells = <1>;
> +						#size-cells = <0>;
> +						reg = <2>;
> +
> +						pcf8575@26 {
> +							compatible = "ti,pcf8575";
> +							reg = <0x26>;
> +						};
> +					};
> +				};
> +
> +				spi@15c00 {
> +					#address-cells = <1>;
> +					#size-cells = <0>;
> +					reg = <0x15c00 0x0 0x0 0x0>;
> +
> +					pcm1755@0 {
> +						compatible = "ti,pcm1755";
> +						reg = <0>;
> +						spi-max-frequency = <115200>;
> +					};
> +
> +					pcm1609a@1 {
> +						compatible = "ti,pcm1609a";
> +						reg = <1>;
> +						spi-max-frequency = <115200>;
> +					};
> +
> +					at93c46@2 {
> +						compatible = "atmel,at93c46";
> +						reg = <2>;
> +						spi-max-frequency = <115200>;
> +					};
> +				};
> +			};
> +		};
> +	};
> +};

Cheers,
Ben.


