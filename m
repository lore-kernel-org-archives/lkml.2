Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1BVLVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:21:38 -0500
Received: from www.tglx.de ([62.245.132.106]:35015 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab1BVLVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:21:37 -0500
Date: Tue, 22 Feb 2011 12:21:12 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [sodaville] [PATCH TIP v2 03/14] x86/dtb: Add a device tree for CE4100
Message-ID: <20110222112112.GA24641@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-4-git-send-email-bigeasy@linutronix.de> <20110127050027.GB23443@yookeroo> <20110202185841.GA28674@www.tglx.de> <20110216214428.GD22837@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110216214428.GD22837@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-02-16 14:44:28 [-0700]:

>> diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
>> new file mode 100644
>> index 0000000..e888657
>> --- /dev/null
>> +++ b/arch/x86/platform/ce4100/falconfalls.dts
>> @@ -0,0 +1,424 @@
>> +	soc@0 {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		compatible = "intel,ce4100-cp";
>
>You *must* include documentation for each of these new compatible
>values before merging this patch.  At the very least it acts as a
>placeholder and describes exactly what the string describes.

I added something.

>> +		ranges;
>> +
>> +		ioapic1: interrupt-controller@fec00000 {
>> +			#interrupt-cells = <2>;
>> +			compatible = "intel,ioapic-ce4100", "intel,ioapic";
>
>"intel,ioapic" is probably too generic and can be dropped.  Newer
>devices can claim compatibility with "intel,ioapic-ce4100" if they are
>indeed compatible so that device drivers don't need to be modified.
>It is better to anchor compatible values to real implementations that
>try to come up with 'generic' or wildcard strings.  Ditto through the
>rest of the file.
>
>"intel,ce4100-ioapic" (instead of intel,ioapic-ce4100) would follow
>current convention better of specifying the chip first, followed by
>the on-chip device.
>
Done.

>> +			pci@1,0 {
>> +				#address-cells = <3>;
>> +				#interrupt-cells = <1>;
>> +				#size-cells = <2>;
>> +				compatible = "intel,ce4100-pci", "pci";
>> +				device_type = "pci";
>> +				bus-range = <1 1>;
>> +				ranges = <0x2000000 0 0xdffe0000 0x2000000 0 0xdffe0000 0 0x1000>;
>> +
>> +				interrupt-parent = <&ioapic2>;
>> +
>> +				display@2,0 {
>> +					compatible = "pci8086,2e5b.2",
>> +						   "pci8086,2e5b",
>> +						   "pciclass038000",
>> +						   "pciclass0380";
>> +
>> +					reg = <0x11000 0x0 0x0 0x0 0x0>;
>> +					interrupts = <0 1>;
>> +				};
>
>Here's where things get a little sticky for PCI child devices
>(probably should have thought about this earlier, sorry).  Are these
>devices runtime detectable?  ie. does reading the PCI BARs and irq
>configuration registers reflect reality?

Bar yes (no assigned-property here), IRQ no.

This devices are runtime detectable via the PCI bus. However the
interrupt number is no longer correct. The PCI bus reports the legacy
number which is irq 4 (if I remember correctly) for all devices here.
Which is correct for the legacy mode. Those interrupts are routed to the
legacy interrupt controller. Once we activate the IO APIC for interrupt
routing the legacy controller is no longer in use. With the IO APIC
there is a different interrupt routing which is described here by the
interrupt property.
On systems with ACPI this kind of information is read fron there. You
see during boot-up "PCI->APIC IRQ transform: ...".

>In general, if something can be *reliably* detected then it should not
>be listed in the device tree.  However, if there is some horrid gotcha
>that prevents it being detected reliably, then it definitely should
>appear here.

The first edition used the interrupt-map property to describe this
mapping. David Gibson [0] recommended then to create device nodes
because the PCI INTA..D lines were not used.

>I cannot answer this question for you since I don't know the hardware.
>It's a judgement call that you'll need to make on whether or not these
>PCI (or pseudo pci?) devices should be listed in the dt.

Most of the devices can be detected reliably. I2C and SPI need some
additional information. I believe more of this things will pop up once
someone adds the GPIO wires which are not there yet. I know that the
smartcard thingy uses one GPIO for card detect. So I would need to
extend the device property later for that :)

>One of the things that does need to be improved is partial probing of
>PCI busses so that only the messy PCI devices get listed in the device
>tree, and the rest of the devices can get detected in the normal
>manner.

I did not add any "special" compatible properties just the pci ids. So
they should not be probed via DT just PCI unless one adds this to the
driver.

[0] http://lists.ozlabs.org/pipermail/devicetree-discuss/2011-January/004137.html

Sebastian
