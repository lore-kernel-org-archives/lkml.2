Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0K1WyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:54:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:60033 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab0K1WyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:54:21 -0500
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org, Mitch Bradley <wmb@firmworks.com>
In-Reply-To: <20101128160449.GC30784@www.tglx.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
	 <1290808645.32570.158.camel@pasglop>  <20101128160449.GC30784@www.tglx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 09:53:29 +1100
Message-ID: <1290984809.32570.208.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 17:04 +0100, Sebastian Andrzej Siewior wrote:
> * Benjamin Herrenschmidt | 2010-11-27 08:57:25 [+1100]:
> 
> >> + */
> >> +/dts-v1/;
> >> +/ {
> >> +	model = "x86,CE4100";
> >> +	compatible = "x86,CE4100";
> >
> >Use a vendor name rather than "x86" here.
> Okay.
> 
> >> +	#address-cells = <1>;
> >> +	#size-cells = <1>;
> >> +
> >> +	cpus {
> >> +		x86,Atom@0 {
> >
> >"Atom" would benefit from being more precise, like adding the model
> >number. Also you want some properties there defining maybe the mask, the
> >cache characteristics, etc... There's an exising OFW binding for x86, I
> >suppose you could follow it. A "reg" property at least is mandatory
> >here.
> I wasn't aware of the OFW binding for X86. I will follow it once I find
> it.

Interesting, I though I would find it on
http://www.openfirmware.info/Bindings but it's not there...

CC'ing Mitch who might know where to find that.

> >Also how do you plan to expose threading capability ?
> I haven't plan because this CPU has to threading capability. If there
> is, I would follow the powerpc way (unless it is allready documented how
> to do so on x86).

Atoms have SMT don't they ?

The powerpc way somewhat sucks since it uses a property named
"ibm,interrupt-server#" :-) We might want to define something more
generic here but the base idea is sane.

IE. There is a node per core. Each "thread" is identified by a unique
number we call the "interrupt server number". The "reg" property of a
core node is the isn of the first thread on that core. etc..

> >You probably also want some linkage from the processor to the local APIC
> >no ?
> Like now I walk through the device tree and look for one but that sounds
> like a good idea.

The day you have multiple Atom's on a board the "looking for one" won't
work well :-) Better have explicit references whenever you can for that
type of linkage.

> >> +			device_type = "cpu";
> >> +		};
> >> +	};
> >> +
> >> +	atom@0 {
> >> +		#address-cells = <1>;
> >> +		#size-cells = <1>;
> >> +		device_type = "soc";
> >> +		compatible = "simple-bus";
> >> +		ranges;
> >> +
> >> +		/* Local APIC */
> >> +		lapic@fee00000 {
> >> +			compatible = "intel,lapic";
> >> +			reg = <0xfee00000 0x1000>;
> >> +			phys_reg = <0xfee00000>;
> >> +		};
> >> +		/* Primary IO-APIC */
> >> +		ioapic1: pic@fec00000 {
> >> +			#interrupt-cells = <2>;
> >> +			compatible = "intel,ioapic";
> >> +			interrupt-controller;
> >> +			device_type = "interrupt-controller";
> >> +			id = <1>;
> >> +			reg = <0xfec00000 0x1000>;
> >> +			phys_reg = <0xfec00000>;
> >> +		};
> >> +
> >
> >What are those phys-reg properties ?

> The second ioapic behind the PCI bus which uses the reg property for the
> devfn number so I can't use it for the chip address. I can't query the
> PCI information because the PCI bus is not up yet.

For the second ioapic, see below. This one isn't on PCI and should just
have "reg".

> The phys_reg property contains the physical address of the chip. The
> boot uart code in powerpc's tree has a virtual-reg property. So I though
> that this would be nice to keep things simple.

No, virtual-reg is a "hack" which contains a virtual address mapped by
the bootloader in the MMU for use by early boot code before takeover of
the MMU. It's not a physical address.

The physical addresses shall be expressed in the device-tree using the
normal mechanisms so that all the existing code to decode them "just
works".

> >Also APICs have some kind od
> >versionning, they aren't all identical, so your compatible property
> >needs to be more precise at least.
> The APIC has a register where you can read the version of the chip, yes.
> You want me to add this version into the compatible field?

Ideally, you should add something like

 intel,ioapic-atomXXX intel-ioapic-vYY intel-ioapic

IE. From the most specific to the most generic. That way if a "quirk" is
ever needed due to an errata specific to that chip model that isn't
directly covered by the "version", you get to use that too (unless that
version register also contains things like mask number etc... in which
case it's probably enough).

> >> +		hpet@fed00000 {
> >> +			compatible = "intel,hpet";
> >> +			reg = <0xfed00000 0x200>;
> >> +			phys_reg = <0xfed00000>;
> >> +		};
> >> +	};
> >
> >All HPETs are identical ? If not, make your compatible property more
> >precise or if they are generally compatible from a programmer
> >perspective, use two entries from more generic to more specific, for
> >example:
> >
> >	compatible = "intel,hpet","intel,hpet-atom-XXYY"

And of course I'm full of caca above, it shall be from the ost specific
to the most generic, so the other way around:

	compatible = "intel,hpet-atom-XXYY","intel,hpet"
>
> >(or make up a numbering/naming scheme that makes sense for Intel gear)
> All hpets should be equal AFAIK. Some behave different but this was not
> intendend in the first place. This information is not even included in
> the ACPI tables.

Well, you should probably still at least provide the "specific" part in
compatible so that difference can be quirked easily (though of course
Linux probably won't care initially).

> >> +	isa@legacy {
> >
> >So ISA isn't a child of "atom"... that makes "atom" a bit strange as a
> >node, tho not a big deal per se. I suppose it represent the on-die
> >peripherals but then you need at least some linkage between that and
> >the /cpus nodes.
> 
> Yes, it should represent the on-die peripherals. How should that look
> like? The bus the same level as the cpu node and link from the cpu to
> the isa bus?

I would make isa a child of atom

> >> +		device_type = "isa";
> >> +		compatible = "simple-bus";
> >
> >What does "simple-bus" means ?
> I added simple bus in order to get probed. But I now I rember that this
> is also supported per device_type. I get rid of it.

device_type is a nasty bugger, we are trying to get rid of Linux
reliance on it.

Things like "simple-bus" don't rock my boat either, it's adding to the
device-tree "informations" that are specific to the way Linux will
interpret it, which is not how it should be.

In this case I would have said something like "atom,isa-bridge" but
heh...

> >ISA has a well defined binding, you
> >should follow it.
> I do. The reg property the rtc starts with "1" where 1 means it is an
> ioport and not ioremap()able adderess.

Ok.

> >> +		#address-cells = <2>;
> >> +		#size-cells = <1>;
> >> +		ranges = <0 0 0 0x400>;
> >> +
> >> +		rtc@legacy {
> >> +			compatible = "motorola,mc146818";
> >> +			interrupts = <8 3>;
> >> +			interrupt-parent = <&ioapic1>;
> >> +			ctrl_reg = <2>;
> >> +			freq_reg = <0x26>;
> >> +			reg = <1 0x70 2>;
> >> +		};
> >
> >I think the ISA binding mandate the use of the PNP codes in the
> >compatible properties, doesn't it ?
> I'm not aware of it.
> 
> > At least that's the common usage
> >pattern I've seen so far on powerpc.
> That is true.
> 
> >
> >Also, "ctrl_reg" and "freq_reg" follow an existing binding ? If not,
> >then I'd suggest you use "-" instead of "_" which is more common in OFW
> >land and use more descriptive names since "reg" has a meaning of its own
> >and the above is a bit confusing.
> I posted a patch for this at [0]. Powerpc uses the the pnpPNP,b00 node
> for the rtc. This node is handled explictly by chrp and maple. Those two
> don't use the generic driver but their own.
> 
> The remaining (mpc8572, p2020) handle this via add_rtc() in
> arch/powerpc/sysdev/rtc_cmos_setup.c. What they do is, they create a
> platform device for the OF node. What is missing is the initialization
> of the ctrl_reg register and the frequency. This is performed in a PCI
> quirk in quirk_final_uli1575() which is only performed on a few powerpc
> machines (is is_quirk_valid() has a list).
> This looks like dirty hack to me. I need to add every machine to it
> rather then a simple entry into the device tree. If you replace the uli
> with something else, you need another setup of this kind for the rtc.

I definitely agree that it's much better to use a property in the
device-tree and I'n not arguing against it :-) I was merely asking
whether that property name was already defined somewhere and if not,
suggesting a different naming (using dashes rather than underscores)
which is more consistent with traditional usage :-)

(Oh and maybe publish a binding wherever Grant puts these nowadays while
at it so we can all do the same thing from now on)

> >> +		pci@3fc {
> >> +			#address-cells = <3>;
> >> +			#interrupt-cells = <1>;
> >> +			#size-cells = <1>;
> >> +			compatible = "intel,ce4100-pci";
> >> +			device_type = "pci";
> >> +			bus-range = <0 0>;
> >> +
> >> +			/* Secondary IO-APIC */
> >> +			ioapic2: pic@bffff000 {
> >> +				#interrupt-cells = <2>;
> >> +				compatible = "intel,ioapic";
> >> +				interrupt-controller;
> >> +				device_type = "interrupt-controller";
> >> +				id = <2>;
> >> +				reg = <0x100 0x0 0x0 0x0>;
> >> +				phys_reg = <0xbffff000>;
> >> +			};
> >
> >Here you define a PCI bus with a child device that isn't PCI from what I
> >can tell, tho the "reg" property content is confusing, and then there's
> >a unit address that doesn't match "reg" and a "phys_reg" (what the heck
> >is that ?) that matches the unit-address. Care to explain a bit
> >more ? :-) 
> The reg property contains the devfn number, interrupt mask, pin number.

No. The "reg" property contains among other things the devfn, but
certainly not the interrupt mask and pin number. I recommend you look at
the PCI binding for OF, it's actually not very complicated :-)

The "reg" basically contains an entry for the "config space" of the
device which basically represents the devfn only, and an entry for each
BAR which contains the size and various attributes (not the assigned
address tho, this goes into a separate assigned-addresses property).

> That is what I've been seeing in PCI nodes. phys_reg is the physical
> address of the chip since reg is allready taken and PCI is not yet up
> (as I allready explained).

Right but with the appropriate assigned-addresses property, you can
represent that using standard properties (and use existing address
resolution helpers from drivers/of) without inventing a new "phys_reg"
which btw has issues too ("reg" traditionally is a tupple addr/size,
also where is the number of cells used in phys_reg defined ?).

> >I suspect that isn't the right way to represent the secondary
> >APIC
> Well the secondary APIC shows up on this PCI bus. It has devfn, vendor
> and device id and config space. Where should I put it if not here?

Ok, I didn't know that, so if it's a PCI device, do as I wrote above,
give it the proper set of PCI properties :-)

> >Also same comments about the compatible property.
> >
> >> +			pci@av {
> >> +				#address-cells = <3>;
> >> +				#interrupt-cells = <1>;
> >> +				#size-cells = <1>;
> >> +				compatible = "intel,ce4100-pci";
> >> +				device_type = "pci";
> >> +				bus-range = <1 1>;
> >> +				interrupt-map-mask = <0xffffff 0x0 0x0 0x0>;
> >
> >I notice that the interrupt number isn't part of your mask, is that
> >expected ? If you decide to make it so, remember that INT_A is 1 not 0
> >iirc (dbl check maybe ? I think that's how it is :-)
> Yes INT_A is 1 :) 0 means no interrupt available. I'm not using the
> interrupt pin here and therefore it is not in the mask.
> The ref manual contains a static mapping for every device so the
> interrupt pin has no meaning. 

Ok, fair enough.

> Well this not enirely true: by default the
> pic is in legacy mode and all devices are on INT A. You can change this
> into a different mode where INT A - D are used. For this to happen you
> need to fiddle in some SoC specific registers. If you choose not to
> bother with it and use the ioapic instead then the interrupt pin remains
> unused. And we don't have real PCI bus where you can plug devices so it
> would matter.

That's ok, the DT should represent the way the SoC was configured, I
don't think it's worth bothering trying to cover all possible SoC
configurations and pin mux in one tree :-)
> 
> >> +				i2c@15a00 {
> >> +					#address-cells = <1>;
> >> +					#size-cells = <0>;
> >> +					reg = <0x15a00 0x0 0x0 0x0>;
> >
> >OFW PCI binding, which we follow, mandates an "assigned-addresses"
> >property, tho I suppose that if you haven't assigned anything yet (and
> >will let Linux do so) the above is kosher. Your "reg" is a bit odd but I
> >don't have time to dbl check vs. the binding right now.
> reg is devfn. I just looked up "assigned-addresses" in the PCI BUS Spec
> and it looks like what I could use instead of phys-reg property. So if
> this is the case then I need to to distinguish between the first on
> secondary ioapic and go either for the reg property or
> assigned-addresses.

You don't really need to. There's code that will do that for you :-)

Stuff in drivers/of/address.c shall be able to parse the addresses by
index (tho I suppose you might still want to do a special case for PCI
since the natural way to get to a PCI based address is via a BAR number
while other stuff just takes an address index).

You shouldn't ever have to look directly at "reg" or
"assigned-addresses" yourself.

Cheers,
Ben.

> [0]
> http://groups.google.com/group/rtc-linux/browse_thread/thread/cd70c4d4865e2b30
> 
> >Cheers,
> >Ben.
> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


