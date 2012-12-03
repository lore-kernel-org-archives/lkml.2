Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2LCO1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:27:18 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53466 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2LCO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:27:17 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: When constructing the bus id consider assigned-addresses as well
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121201004948.GA3185@obsidianresearch.com>
References: <20121121210240.GC15285@obsidianresearch.com> <20121126140316.99FE23E194B@localhost> <20121126182054.GA30177@obsidianresearch.com> <20121129162648.80DBC3E0912@localhost> <20121129193829.GA10145@obsidianresearch.com> <20121130094806.0D6D73E070C@localhost> <20121201004948.GA3185@obsidianresearch.com>
Date: Mon, 03 Dec 2012 14:27:11 +0000
Message-Id: <20121203142711.591853E0A4C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 17:49:48 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Nov 30, 2012 at 09:48:05AM +0000, Grant Likely wrote:
> 
> > > If you attempt to stick a 'reg' in a block nested below a
> > > 'device_type="pci"' the kernel throws lots of error messsages and
> > > generates bad address mappings.
> > 
> > Have you added the appropriate #address-cells and #size-cells to the pci
> > device node to go back to a non-pci addressing mode?
> > assigned-addresses
> 
> Switching away from the 5 dword address format is not ideal
> because then there is no way to specify the resource region (prefetch,
> io, mmio) and mmio would have to be assumed.

You don't need to switch away from using 5 cells if that works best for
you, but I'd be surprised if it was the ideal representation. I would
expect you to use a representation that makes sense for the internal bus
architecture of the device. If if exactly matches the PCI address, then
go ahead with 5 cells, but if it is one or more 32bit busses, then use 1
or 2 for #address-cells and 1 for #size-cells.

> 
> > only makes sense in the pci-device node itself. reg should work for all
> > nodes below that, and if it doesn't then it is a bug that we need to
> > fix.
> 
> Okay.. but how should the DTS be constructed?
> 
pcie_bus { // The PCI-E bus
   device_type = "pci";
   ranges = <5dw ranges>;
   #address-cells = <3>;
   #size-cells = <2>;
   soc_bridge { // The PCI-E device
      device_type = "pci";

      // These are important to set up the address format in the child
      // nodes
      #address-cells = <3>;
      #size-cells = <2>;

      // Translation from PCI bus space to local bus space.
      ranges = <5dw ranges>;

      soc_device { // Internal device
          reg = <5dw regs>
      };
   };
};

> 
> This is what I have now, the soc_bridge PCI-E device is DTS modeled as
> a PCI bridge - it has a ranges with its memory location, and the
> children nodes are relative to those ranges. This would not be typical
> for a non-bridge PCI-E device.

Now, if the children of soc_bridge really are PCI devices (and not just
plain-vanilla memory mapped IP cores like I assume above), then they
shouldn't be registered in the kernel as platform_devices at all. In
that case register them as PCI devices and the existing PCI
infrastructure should do the naming correctly.

> The reason for the 'assigned-address' requirement with the current
> kernel code is the device_type=pci on soc_bridge. This makes
> of_match_bus(parent) for soc_device return the PCI structure, which
> has '.addresses = "assigned-addresses",'

If the soc_devices are getting triggered on that and they shouldn't be,
then we need a mechanism in the soc_bridge node to kick out of that
behavoir for its children.

g.
