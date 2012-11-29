Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2K2Tie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:38:34 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:42130 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab2K2Tid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:38:33 -0500
Date: Thu, 29 Nov 2012 12:38:29 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: When constructing the bus id consider
 assigned-addresses as well
Message-ID: <20121129193829.GA10145@obsidianresearch.com>
References: <20121121210240.GC15285@obsidianresearch.com>
 <20121126140316.99FE23E194B@localhost>
 <20121126182054.GA30177@obsidianresearch.com>
 <20121129162648.80DBC3E0912@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129162648.80DBC3E0912@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 04:26:48PM +0000, Grant Likely wrote:

> Hmmm. okay that makes sense, but something still isn't quite right. So
> of_translate_address should take care of drilling down through the bus
> layers, and when it gets to the PCI node it /should/ use
> of_bus_pci_translate to handle traversing down to the parent node (which
> uses the 'assigned-addresses' for the pci node.

The address translation machinery requires PCI format addresses (ie
address-cells=3) for all nodes below a PCI bus. Part of this
requirement is that 'assigned-addresses' is used for resources, *not*
'reg'.

If you attempt to stick a 'reg' in a block nested below a
'device_type="pci"' the kernel throws lots of error messsages and
generates bad address mappings.

So, we are required to use'assigned-addresses' with the 5 word format
instead of reg. This seems to be a spec requirement for everything
below a PCI bus.

We end up with a DTS where the PCI bus and everything below it must
be described in the 5 word format that looks like this:

	pex@e0000000 { // <-- This is the PCI bus/controller node
		device_type = "pci";
		ranges = <0x02000000 0x00000000 0x00000000  0xe0000000  0x0 0x8000000>;
		soc@0 { // <-- This is the actual PCI device
			ranges = <0x02000000 0x00000000 0x00000000  0x02000000 0x00000000 0x00000000  0x0 0x8000000>;
			gpio3: gpio@8 { // <-- This is a platform device
			        #gpio-cells = <2>;
				compatible = "linux,basic-mmio-gpio";
				gpio-controller;
				reg-names = "dat", "set", "dirin";
				assigned-addresses = <0x02000000 0x0 0x8  0x0 4>,
				                     <0x02000000 0x0 0xc  0x0 4>,
				                     <0x02000000 0x0 0x10  0x0 4>;
			};

Which (when combined with the platform_device_add change) builds up an
iomem like:

e0000000-e7ffffff : PCIe 0 MEM
  e0000000-e000ffff : 0000:00:01.0
    e0000000-e0000fff : /pex@e0000000/soc@0/control@0
      e0000008-e000000b : dat
        e0000008-e000000b : dat
      e000000c-e000000f : set
        e000000c-e000000f : set
      e0000010-e0000013 : dirin
        e0000010-e0000013 : dirin

(I trimmed control@0 node from the dts fragment, see other mails on
 the overlapping regions)

And a sysfs like this:

/sys/devices/pci0000:00/0000:00:01.0/e0000000.control
/sys/devices/pci0000:00/0000:00:01.0/e0000008.gpio

Without the patch the sysfs names will not have the address (gpio.0 or
whatever it is), but all other address calculations work correctly.

> However, in your case, of_device_make_bus_id() isn't using that code
> path and you're getting a generic name instead (with no relation to the
> device address).  Correct?

Right.
 
> If that is the case, then the solution is to figure out why
> of_translate_address() doesn't currently handle your situation and
> fix

of_translate_address works perfectly - resource records are
constructed correctly, for instance. The issue is that
of_device_make_bus_id() doesn't call it:

@@ -105,6 +105,8 @@ void of_device_make_bus_id(struct device *dev)
         * For MMIO, get the physical address
         */
        reg = of_get_property(node, "reg", NULL);
+       if (!reg)
+               reg = of_get_property(node, "assigned-addresses", NULL);
        if (reg) {
                if (of_can_translate_address(node)) {
                        addr = of_translate_address(node, reg);

ie what is happening is that of_device_make_bus_id *only* calls
*_translate_address if 'reg' is a property of the node. The patch
simply extends that to call if 'reg' or 'assigned-addresses' are a
property of the node. of_device_make_bus_id doesn't do anything with
the 'reg' variable other than test it against NULL.

Jason
