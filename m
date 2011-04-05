Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1DEGmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:42:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:60645 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1DEGmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:42:43 -0400
Subject: Re: [RFC/PATCH] of: Match PCI devices to OF nodes generically
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arch@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <20110405023230.GA26817@ponder.secretlab.ca>
References: <1301882694.2549.53.camel@pasglop>
	 <1301887630.2549.71.camel@pasglop> <1301902664.2549.76.camel@pasglop>
	 <20110405023230.GA26817@ponder.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 16:42:28 +1000
Message-ID: <1301985748.2549.139.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > The benefit is that all archs now get the matching for free. There's one
> > hook the arch might want to provide to match a PHB bus to its device
> > node. A default weak implementation is provided that looks for the
> > parent device device node, but it's not entirely reliable on powerpc for
> > various reasons so powerpc provides its own.
> 
> Awesome.  I'm looking at doing pretty much exactly the same thing for
> USB and platform_devices on SoCs.  I'm glad to see this for pci.

Yeah, I figured it would come in handy :-)

I looked a bit at USB and the main issue is that it's unclear in the
binding whether the root hub is exposed in the device-tree as a hub or
not. The tendency from what I can see of Apple and Sun produced trees is
that it's -not- there.

> > diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
> > index 5e156e0..6912c45 100644
> > --- a/arch/powerpc/include/asm/pci-bridge.h
> > +++ b/arch/powerpc/include/asm/pci-bridge.h
> > @@ -169,18 +169,22 @@ static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
> >  	return bus->sysdata;
> >  }
> >  
> > -#ifndef CONFIG_PPC64
> > +static inline struct device_node *pci_device_to_OF_node(struct pci_dev *dev)
> > +{
> > +	return dev->dev.of_node;
> > +}
> >  
> >  static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
> >  {
> > -	struct pci_controller *host;
> > -
> > -	if (bus->self)
> > -		return pci_device_to_OF_node(bus->self);
> > -	host = pci_bus_to_host(bus);
> > -	return host ? host->dn : NULL;
> > +	return bus->dev.of_node;
> >  }
> 
> Should these two inlines move to include/linux/of_pci.h?  Microblaze
> defines it differently, but I don't think it should be.  Sparc also
> has a different variant in arch/sparc/kernel/pci.c, but not in
> arch/sparc/kernel/pcic.c.  It looks to me like this should be the
> common case unless a specific platform needs otherwise.

I didn't like the function name and though it would be better to
deprecate it and have users peek at the struct device -> of_node
instead, but if you think it's worthwhile I can factor that out.

I haven't looked at microblaze PCI code yet so I might be breaking
it... it looks like an old variant of the ppc32 one :-) They should
never have copied the OF node map stuff for example or the bus
renumbering for that matter :-)

The main thing is to get the node of the PHB. The "default"
weak function looks for the parent struct device you pass to
pci_create_bus() but it's often NULL if you detect your PHBs
very early like we do on most powerpc platforms.

That's why I have my override, and from what I can tell, microblaze
would need to copy it over too (and probably get rid of a lot of crap
they copied from me that they really really don't need :-)

 .../...

> > --- a/drivers/pci/hotplug/rpadlpar_core.c
> > +++ b/drivers/pci/hotplug/rpadlpar_core.c
> > @@ -158,7 +158,7 @@ static void dlpar_pci_add_bus(struct device_node *dn)
> >  	/* Scan below the new bridge */
> >  	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
> >  	    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
> > -		of_scan_pci_bridge(dn, dev);
> > +		of_scan_pci_bridge(dev);
> >  
> >  	/* Map IO space for child bus, which may or may not succeed */
> >  	pcibios_map_io_space(dev->subordinate);
> > diff --git a/drivers/pci/of.c b/drivers/pci/of.c
> > new file mode 100644
> > index 0000000..fff7270
> > --- /dev/null
> > +++ b/drivers/pci/of.c
> 
> Should this be consolidated with drivers/of/of_pci.c?  I don't have
> strong opinions about where the result lives, but I don't think they
> should be split up.

I assume your comment refers to the rest of the code in that file (ie to
the file name above and not to the rpadlpar hunk :-)

This is my rationale for the split:

 - Bits in drivers/of/of_pci.c contain basic routines to parse
PCI device "reg" properties and locate devices in the device-tree
that don't involve the Linux PCI layer. This can be used by the later
(as it is below) but it can also be used by early boot platform code
that might need to locate PCI devices before the linux PCI probe
happens, that sort of thing. It's pretty clear that those functions
don't rely on anything from the linux PCI code

 - Bits in drivers/pci/of.c that contain the glue to actually populate
the pci_dev's and which use the parsers in the previous file. These
functions are strictly hooks that are called by the linux PCI layer to
populate it's nodes (along with the weak overridable one for getting
to the PHB device node).

There's a clear distinction here I believe and I think it's worth
keeping. I don't like having drivers/pci/probe.c call into
drivers/of/of_pci.c directly basically. The glue layer that way is more
obvious.

  .../...

> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 44cbbba..347349b 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -89,6 +89,7 @@ static void release_pcibus_dev(struct device *dev)
> >  	if (pci_bus->bridge)
> >  		put_device(pci_bus->bridge);
> >  	pci_bus_remove_resources(pci_bus);
> > +	pci_release_bus_of_node(pci_bus);
> >  	kfree(pci_bus);
> >  }
> >  
> > @@ -624,7 +625,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
> >  
> >  	child->self = bridge;
> >  	child->bridge = get_device(&bridge->dev);
> > -
> > +	pci_set_bus_of_node(child);	
> 
> If I'm reading this correctly, the only time an of_node can be
> associated with a pci_bus is here and pci_alloc_bus.  In both cases
> that makes it safe for release_pcibus_dev() to remove it.  Am I
> correct?

Well, there is also pci_create_bus() but yes, basically. Also
of_node_put() is safe vs. NULL afaik.

> oh, and trailing whitespace.  :-)

Yeah, those will kill me eventually :-)

  .../...

> > @@ -1193,6 +1196,8 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
> >  	dev->vendor = l & 0xffff;
> >  	dev->device = (l >> 16) & 0xffff;
> >  
> > +	pci_set_of_node(dev);
> > +
> >  	if (pci_setup_device(dev)) {
> >  		kfree(dev);
> >  		return NULL;
> > @@ -1445,6 +1450,7 @@ struct pci_bus * pci_create_bus(struct device *parent,
> >  		goto dev_reg_err;
> >  	b->bridge = get_device(dev);
> >  	device_enable_async_suspend(b->bridge);
> > +	pci_set_bus_of_node(b);
> 
> Similarly here; so device node linkage to pci devices will always use
> the same mechanism except for in of_create_pci_dev() for sparc, right?

And of_create_pci_dev() for powerpc :-)

But yes, basically. If you have a platform that "generates" struct
pci_dev without calling pci_scan_device() then it's your responsibility
to populate it.

But again, put() should be NULL safe so the ->release callback souldn't
have a problem if the node isn't populated.

> linux/of.h is safe to include when CONFIG_OF is not selected; it can
> live at the top of the file with the rest of the includes.
> 
> > +extern void pci_set_of_node(struct pci_dev *dev);
> > +extern void pci_release_of_node(struct pci_dev *dev);
> > +extern void pci_set_bus_of_node(struct pci_bus *bus);
> > +extern void pci_release_bus_of_node(struct pci_bus *bus);
> 
> Looks to me like these functions still get called when
> !defined(CONFIG_OF).

Yes, I just forgot to "update" the empty inlines (you can see them
below but they have different/obsolete names :-)

I'll fix all of that up.

Thanks for the review !

Cheers,
Ben.

> > +
> > +/* Arch may override this (weak) */
> > +extern struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus);
> > +
> > +
> > +#else /* CONFIG_OF */
> > +static void pci_locate_of_node(struct pci_dev *dev) { }
> > +static void pci_release_of_node(struct pci_dev *dev) { }
> > +#endif  /* CONFIG_OF */
> > +
> >  #endif /* __KERNEL__ */
> >  #endif /* LINUX_PCI_H */
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


