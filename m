Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab0K2Tgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:36:39 -0500
Received: from www.tglx.de ([62.245.132.106]:50040 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0K2Tgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:36:38 -0500
Message-ID: <4CF400B1.6060100@linutronix.de>
Date: Mon, 29 Nov 2010 20:36:17 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Mitch Bradley <wmb@firmworks.com>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH 03/11] x86/dtb: Add a device tree for CE4100
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	<1290706801-7323-4-git-send-email-bigeasy@linutronix.de>	<1290808645.32570.158.camel@pasglop>	<20101128160449.GC30784@www.tglx.de> <1290984809.32570.208.camel@pasglop>
In-Reply-To: <1290984809.32570.208.camel@pasglop>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:

>>> Also how do you plan to expose threading capability ?
>> I haven't plan because this CPU has to threading capability. If there
>> is, I would follow the powerpc way (unless it is allready documented how
>> to do so on x86).
> 
> Atoms have SMT don't they ?

It is available on some Atom CPUs. This one does not support it. It has
just one CPU with one thread.

>>> You probably also want some linkage from the processor to the local APIC
>>> no ?
>> Like now I walk through the device tree and look for one but that sounds
>> like a good idea.
> 
> The day you have multiple Atom's on a board the "looking for one" won't
> work well :-) Better have explicit references whenever you can for that
> type of linkage.

This also works with the flat tree, right?

>>> Also APICs have some kind od
>>> versionning, they aren't all identical, so your compatible property
>>> needs to be more precise at least.
>> The APIC has a register where you can read the version of the chip, yes.
>> You want me to add this version into the compatible field?
> 
> Ideally, you should add something like
> 
>  intel,ioapic-atomXXX intel-ioapic-vYY intel-ioapic
> 
> IE. From the most specific to the most generic. That way if a "quirk" is
> ever needed due to an errata specific to that chip model that isn't
> directly covered by the "version", you get to use that too (unless that
> version register also contains things like mask number etc... in which
> case it's probably enough).

Okay, so we want this for a quirk at a later point in time. Now I
understand.

  >>>> +	isa@legacy {
>>> So ISA isn't a child of "atom"... that makes "atom" a bit strange as a
>>> node, tho not a big deal per se. I suppose it represent the on-die
>>> peripherals but then you need at least some linkage between that and
>>> the /cpus nodes.
>> Yes, it should represent the on-die peripherals. How should that look
>> like? The bus the same level as the cpu node and link from the cpu to
>> the isa bus?
> 
> I would make isa a child of atom
Okay.

>>>> +		device_type = "isa";
>>>> +		compatible = "simple-bus";
>>> What does "simple-bus" means ?
>> I added simple bus in order to get probed. But I now I rember that this
>> is also supported per device_type. I get rid of it.
> 
> device_type is a nasty bugger, we are trying to get rid of Linux
> reliance on it.
> 
> Things like "simple-bus" don't rock my boat either, it's adding to the
> device-tree "informations" that are specific to the way Linux will
> interpret it, which is not how it should be.
> 
> In this case I would have said something like "atom,isa-bridge" but
> heh...

Would "isa-bridge" be acceptable? So I don't have to add a new bus to the 
probe list for every new SoC.

>>>> +		rtc@legacy {
>>>> +			compatible = "motorola,mc146818";
>>>> +			interrupts = <8 3>;
>>>> +			interrupt-parent = <&ioapic1>;
>>>> +			ctrl_reg = <2>;
>>>> +			freq_reg = <0x26>;
>>>> +			reg = <1 0x70 2>;
>>>> +		};

>>> Also, "ctrl_reg" and "freq_reg" follow an existing binding ? If not,
>>> then I'd suggest you use "-" instead of "_" which is more common in OFW
>>> land and use more descriptive names since "reg" has a meaning of its own
>>> and the above is a bit confusing.

> I definitely agree that it's much better to use a property in the
> device-tree and I'n not arguing against it :-) I was merely asking
> whether that property name was already defined somewhere and if not,
> suggesting a different naming (using dashes rather than underscores)
> which is more consistent with traditional usage :-)

Okay, so I replace _ with - in ctrl_reg and freq_reg if this is your only
concern.

> (Oh and maybe publish a binding wherever Grant puts these nowadays while
> at it so we can all do the same thing from now on)
Good.

>>>> +		pci@3fc {
>>>> +			/* Secondary IO-APIC */
>>>> +			ioapic2: pic@bffff000 {
>>>> +				compatible = "intel,ioapic";
>>>> +				reg = <0x100 0x0 0x0 0x0>;
>>>> +				phys_reg = <0xbffff000>;
>>>> +			};

>> The reg property contains the devfn number, interrupt mask, pin number.
> 
> No. The "reg" property contains among other things the devfn, but
> certainly not the interrupt mask and pin number. I recommend you look at
> the PCI binding for OF, it's actually not very complicated :-)
> 
> The "reg" basically contains an entry for the "config space" of the
> device which basically represents the devfn only, and an entry for each
> BAR which contains the size and various attributes (not the assigned
> address tho, this goes into a separate assigned-addresses property).
> 
>> That is what I've been seeing in PCI nodes. phys_reg is the physical
>> address of the chip since reg is allready taken and PCI is not yet up
>> (as I allready explained).
> 
> Right but with the appropriate assigned-addresses property, you can
> represent that using standard properties (and use existing address
> resolution helpers from drivers/of) without inventing a new "phys_reg"
> which btw has issues too ("reg" traditionally is a tupple addr/size,
> also where is the number of cells used in phys_reg defined ?).
phys_reg does not have it. And probably won't since we eliminated it.

>>>> +				i2c@15a00 {
>>>> +					#address-cells = <1>;
>>>> +					#size-cells = <0>;
>>>> +					reg = <0x15a00 0x0 0x0 0x0>;
>>> OFW PCI binding, which we follow, mandates an "assigned-addresses"
>>> property, tho I suppose that if you haven't assigned anything yet (and
>>> will let Linux do so) the above is kosher. Your "reg" is a bit odd but I
>>> don't have time to dbl check vs. the binding right now.
>> reg is devfn. I just looked up "assigned-addresses" in the PCI BUS Spec
>> and it looks like what I could use instead of phys-reg property. So if
>> this is the case then I need to to distinguish between the first on
>> secondary ioapic and go either for the reg property or
>> assigned-addresses.
> 
> You don't really need to. There's code that will do that for you :-)
> 
> Stuff in drivers/of/address.c shall be able to parse the addresses by
> index (tho I suppose you might still want to do a special case for PCI
> since the natural way to get to a PCI based address is via a BAR number
> while other stuff just takes an address index).
> 
> You shouldn't ever have to look directly at "reg" or
> "assigned-addresses" yourself.

Yes. of_address_to_resource() will do the right thing in this case. It can
only be used after unflatten_device_tree() and I need this earlier.
Now using unflatten_device_tree() earlier isn't that easy, or is it.
I defered the ioapic init a little, so it is now called from
x86_init.mpparse.get_smp_config() so I have alloc_bootmem() working.
So unflatten_device_tree() seems to work here. The ugly part comes now:
early_init_dt_alloc_memory_arch() expects u64 which works with
phys_to_virt() and the other way around. This isn't really the case with
what __alloc_bootmem(). This looks like phys_map to me. Since the dtb code
simply uses phys_to_virt() it doesn't really matter. So it works and I 
probably can use of_address_to_resource().

> Cheers,
> Ben.

Sebastian
