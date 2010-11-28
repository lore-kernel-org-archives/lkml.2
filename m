Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0K1OEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 09:04:54 -0500
Received: from www.tglx.de ([62.245.132.106]:34941 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0K1OEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 09:04:52 -0500
Date: Sun, 28 Nov 2010 15:04:36 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 07/11] x86/dtb: add support for PCI devices backed by dtb nodes
Message-ID: <20101128140436.GB30784@www.tglx.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-8-git-send-email-bigeasy@linutronix.de> <1290897231.32570.168.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1290897231.32570.168.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt | 2010-11-28 09:33:51 [+1100]:

>That's something we need to eventually put into common code, ie matching
>device nodes to PCI devices... In the meantime, your approach will do,
>some nits:
>
>> +static int of_irq_map_pci(struct pci_dev *dev, struct of_irq *oirq)
>> +{
>> +	struct device_node *node;
>> +	__be32 laddr[3];
>> +	__be32 lspec[2];
>> +	int ret;
>> +	u8 pin;
>> +
>> +	node = dev->dev.of_node;
>> +	if (!node) {
>> +		node = dev->bus->dev.of_node;
>> +		if (node) {
>> +			ret = of_irq_map_one(node, 0, oirq);
>> +			if (!ret)
>> +				return ret;
>> +		}
>> +	}
>
>I don't quite get the logic in getting to the bus' interrupts if you
>can't find a device own nodes here...
the of_irq_map_one() is here in case the device has an interrupt node in
the device tree. If not, looks it up in the device tree based on the pin
and the device address.

>> +	ret = pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
>> +	if (ret)
>> +		return ret;
>> +	if (!pin)
>> +		return -EINVAL;
>> +
>> +	laddr[0] = cpu_to_be32((dev->bus->number << 16) | (dev->devfn << 8));
>> +	laddr[1] = 0;
>> +	laddr[2] = 0;
>> +
>> +	lspec[0] = cpu_to_be32(pin);
>> +	lspec[1] = cpu_to_be32(0);
>> +	ret = of_irq_map_raw(node, lspec, 1, laddr, oirq);
>> +	if (ret)
>> +		return ret;
>> +	return 0;
>> +}
>
>Ok so I see what you are trying to do, but I think it's not completely
>correct, besides you miss the swizzling when crossing P2P bridges and
>similar.
It should be correct. I did not understand the P2P bridge so I left it
out.

>I suppose you looked at powerpc's of_irq_map_pci() so I'm not sure why
>you modified it the way you did :-) You should probably either move it
>to a generic place or copy it for now with a comment indicating where it
>comes from so we spot it when we put it into a common code.
Microblaze had its own copy of this code so I though there is something
specific about it. If it is okay with you, I would move it to drivers/of
and share. Then I would have the swizzle part :)

>> +void __cpuinit x86_of_pci_init(void)
>> +{
>> +	struct device_node *np;
>> +
>> +	pcibios_enable_irq = x86_of_pci_irq_enable;
>> +	pcibios_disable_irq = x86_of_pci_irq_disable;
>> +
>> +	for_each_node_by_type(np, "pci") {
>> +		const void *prop;
>> +		struct pci_bus *bus;
>> +		unsigned int bus_min;
>> +		struct device_node *child;
>> +
>> +		prop = of_get_property(np, "bus-range", NULL);
>> +		if (!prop)
>> +			continue;
>> +		bus_min = be32_to_cpup(prop);
>> +
>> +		bus = pci_find_bus(0, bus_min);
>> +		if (!bus) {
>> +			printk(KERN_ERR "Can't find a node for bus %s.\n",
>> +					np->full_name);
>> +			continue;
>> +		}
>> +
>> +		bus->dev.of_node = np;
>> +		for_each_child_of_node(np, child) {
>> +			struct pci_dev *dev;
>> +			u32 devfn;
>> +
>> +			prop = of_get_property(child, "reg", NULL);
>> +			if (!prop)
>> +				continue;
>> +
>> +			devfn = (be32_to_cpup(prop) >> 8) & 0xff;
>> +			dev = pci_get_slot(bus, devfn);
>> +			if (!dev)
>> +				continue;
>> +			dev->dev.of_node = child;
>> +		}
>> +	}
>> +}
>
>That too won't go down bridges, atom never have any ? (no PCIe root
>complex at all ? ever will be ? even then, it should be supported as got
>knows what we'll handle in the future).
The cpu I have here for testing does not have any.

>Eventually we want that matching between PCI devices and OF nodes to be
>in generic code, so that's not a big deal to have an "inferior" version
>temporarily in there I suppose.

Inferior, I see :)

>Also, aren't you missing a pci_dev_put() after pci_get_slot() ?
probably. I will check.

>Cheers,
>Ben.

Sebastian
