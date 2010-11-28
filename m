Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0K1QF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 11:05:26 -0500
Received: from www.tglx.de ([62.245.132.106]:36714 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab0K1QFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 11:05:08 -0500
Date: Sun, 28 Nov 2010 17:04:49 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
Message-ID: <20101128160449.GC30784@www.tglx.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-4-git-send-email-bigeasy@linutronix.de> <1290808645.32570.158.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1290808645.32570.158.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt | 2010-11-27 08:57:25 [+1100]:

>> + */
>> +/dts-v1/;
>> +/ {
>> +	model = "x86,CE4100";
>> +	compatible = "x86,CE4100";
>
>Use a vendor name rather than "x86" here.
Okay.

>> +	#address-cells = <1>;
>> +	#size-cells = <1>;
>> +
>> +	cpus {
>> +		x86,Atom@0 {
>
>"Atom" would benefit from being more precise, like adding the model
>number. Also you want some properties there defining maybe the mask, the
>cache characteristics, etc... There's an exising OFW binding for x86, I
>suppose you could follow it. A "reg" property at least is mandatory
>here.
I wasn't aware of the OFW binding for X86. I will follow it once I find
it.

>Also how do you plan to expose threading capability ?
I haven't plan because this CPU has to threading capability. If there
is, I would follow the powerpc way (unless it is allready documented how
to do so on x86).

>You probably also want some linkage from the processor to the local APIC
>no ?
Like now I walk through the device tree and look for one but that sounds
like a good idea.

>> +			device_type = "cpu";
>> +		};
>> +	};
>> +
>> +	atom@0 {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		device_type = "soc";
>> +		compatible = "simple-bus";
>> +		ranges;
>> +
>> +		/* Local APIC */
>> +		lapic@fee00000 {
>> +			compatible = "intel,lapic";
>> +			reg = <0xfee00000 0x1000>;
>> +			phys_reg = <0xfee00000>;
>> +		};
>> +		/* Primary IO-APIC */
>> +		ioapic1: pic@fec00000 {
>> +			#interrupt-cells = <2>;
>> +			compatible = "intel,ioapic";
>> +			interrupt-controller;
>> +			device_type = "interrupt-controller";
>> +			id = <1>;
>> +			reg = <0xfec00000 0x1000>;
>> +			phys_reg = <0xfec00000>;
>> +		};
>> +
>
>What are those phys-reg properties ?
The second ioapic behind the PCI bus which uses the reg property for the
devfn number so I can't use it for the chip address. I can't query the
PCI information because the PCI bus is not up yet.
The phys_reg property contains the physical address of the chip. The
boot uart code in powerpc's tree has a virtual-reg property. So I though
that this would be nice to keep things simple.

>Also APICs have some kind od
>versionning, they aren't all identical, so your compatible property
>needs to be more precise at least.
The APIC has a register where you can read the version of the chip, yes.
You want me to add this version into the compatible field?

>> +		hpet@fed00000 {
>> +			compatible = "intel,hpet";
>> +			reg = <0xfed00000 0x200>;
>> +			phys_reg = <0xfed00000>;
>> +		};
>> +	};
>
>All HPETs are identical ? If not, make your compatible property more
>precise or if they are generally compatible from a programmer
>perspective, use two entries from more generic to more specific, for
>example:
>
>	compatible = "intel,hpet","intel,hpet-atom-XXYY"
>
>(or make up a numbering/naming scheme that makes sense for Intel gear)
All hpets should be equal AFAIK. Some behave different but this was not
intendend in the first place. This information is not even included in
the ACPI tables.

>> +	isa@legacy {
>
>So ISA isn't a child of "atom"... that makes "atom" a bit strange as a
>node, tho not a big deal per se. I suppose it represent the on-die
>peripherals but then you need at least some linkage between that and
>the /cpus nodes.

Yes, it should represent the on-die peripherals. How should that look
like? The bus the same level as the cpu node and link from the cpu to
the isa bus?

>> +		device_type = "isa";
>> +		compatible = "simple-bus";
>
>What does "simple-bus" means ?
I added simple bus in order to get probed. But I now I rember that this
is also supported per device_type. I get rid of it.

>ISA has a well defined binding, you
>should follow it.
I do. The reg property the rtc starts with "1" where 1 means it is an
ioport and not ioremap()able adderess.

>> +		#address-cells = <2>;
>> +		#size-cells = <1>;
>> +		ranges = <0 0 0 0x400>;
>> +
>> +		rtc@legacy {
>> +			compatible = "motorola,mc146818";
>> +			interrupts = <8 3>;
>> +			interrupt-parent = <&ioapic1>;
>> +			ctrl_reg = <2>;
>> +			freq_reg = <0x26>;
>> +			reg = <1 0x70 2>;
>> +		};
>
>I think the ISA binding mandate the use of the PNP codes in the
>compatible properties, doesn't it ?
I'm not aware of it.

> At least that's the common usage
>pattern I've seen so far on powerpc.
That is true.

>
>Also, "ctrl_reg" and "freq_reg" follow an existing binding ? If not,
>then I'd suggest you use "-" instead of "_" which is more common in OFW
>land and use more descriptive names since "reg" has a meaning of its own
>and the above is a bit confusing.
I posted a patch for this at [0]. Powerpc uses the the pnpPNP,b00 node
for the rtc. This node is handled explictly by chrp and maple. Those two
don't use the generic driver but their own.

The remaining (mpc8572, p2020) handle this via add_rtc() in
arch/powerpc/sysdev/rtc_cmos_setup.c. What they do is, they create a
platform device for the OF node. What is missing is the initialization
of the ctrl_reg register and the frequency. This is performed in a PCI
quirk in quirk_final_uli1575() which is only performed on a few powerpc
machines (is is_quirk_valid() has a list).
This looks like dirty hack to me. I need to add every machine to it
rather then a simple entry into the device tree. If you replace the uli
with something else, you need another setup of this kind for the rtc.

>> +		pci@3fc {
>> +			#address-cells = <3>;
>> +			#interrupt-cells = <1>;
>> +			#size-cells = <1>;
>> +			compatible = "intel,ce4100-pci";
>> +			device_type = "pci";
>> +			bus-range = <0 0>;
>> +
>> +			/* Secondary IO-APIC */
>> +			ioapic2: pic@bffff000 {
>> +				#interrupt-cells = <2>;
>> +				compatible = "intel,ioapic";
>> +				interrupt-controller;
>> +				device_type = "interrupt-controller";
>> +				id = <2>;
>> +				reg = <0x100 0x0 0x0 0x0>;
>> +				phys_reg = <0xbffff000>;
>> +			};
>
>Here you define a PCI bus with a child device that isn't PCI from what I
>can tell, tho the "reg" property content is confusing, and then there's
>a unit address that doesn't match "reg" and a "phys_reg" (what the heck
>is that ?) that matches the unit-address. Care to explain a bit
>more ? :-) 
The reg property contains the devfn number, interrupt mask, pin number.
That is what I've been seeing in PCI nodes. phys_reg is the physical
address of the chip since reg is allready taken and PCI is not yet up
(as I allready explained).

>I suspect that isn't the right way to represent the secondary
>APIC
Well the secondary APIC shows up on this PCI bus. It has devfn, vendor
and device id and config space. Where should I put it if not here?

>Also same comments about the compatible property.
>
>> +			pci@av {
>> +				#address-cells = <3>;
>> +				#interrupt-cells = <1>;
>> +				#size-cells = <1>;
>> +				compatible = "intel,ce4100-pci";
>> +				device_type = "pci";
>> +				bus-range = <1 1>;
>> +				interrupt-map-mask = <0xffffff 0x0 0x0 0x0>;
>
>I notice that the interrupt number isn't part of your mask, is that
>expected ? If you decide to make it so, remember that INT_A is 1 not 0
>iirc (dbl check maybe ? I think that's how it is :-)
Yes INT_A is 1 :) 0 means no interrupt available. I'm not using the
interrupt pin here and therefore it is not in the mask.
The ref manual contains a static mapping for every device so the
interrupt pin has no meaning. Well this not enirely true: by default the
pic is in legacy mode and all devices are on INT A. You can change this
into a different mode where INT A - D are used. For this to happen you
need to fiddle in some SoC specific registers. If you choose not to
bother with it and use the ioapic instead then the interrupt pin remains
unused. And we don't have real PCI bus where you can plug devices so it
would matter.

>> +				i2c@15a00 {
>> +					#address-cells = <1>;
>> +					#size-cells = <0>;
>> +					reg = <0x15a00 0x0 0x0 0x0>;
>
>OFW PCI binding, which we follow, mandates an "assigned-addresses"
>property, tho I suppose that if you haven't assigned anything yet (and
>will let Linux do so) the above is kosher. Your "reg" is a bit odd but I
>don't have time to dbl check vs. the binding right now.
reg is devfn. I just looked up "assigned-addresses" in the PCI BUS Spec
and it looks like what I could use instead of phys-reg property. So if
this is the case then I need to to distinguish between the first on
secondary ioapic and go either for the reg property or
assigned-addresses.

[0]
http://groups.google.com/group/rtc-linux/browse_thread/thread/cd70c4d4865e2b30

>Cheers,
>Ben.

Sebastian
