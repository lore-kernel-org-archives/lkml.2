Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab2LAAtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:49:55 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:37580 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab2LAAty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:49:54 -0500
Date: Fri, 30 Nov 2012 17:49:48 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: When constructing the bus id consider
 assigned-addresses as well
Message-ID: <20121201004948.GA3185@obsidianresearch.com>
References: <20121121210240.GC15285@obsidianresearch.com>
 <20121126140316.99FE23E194B@localhost>
 <20121126182054.GA30177@obsidianresearch.com>
 <20121129162648.80DBC3E0912@localhost>
 <20121129193829.GA10145@obsidianresearch.com>
 <20121130094806.0D6D73E070C@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130094806.0D6D73E070C@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 09:48:05AM +0000, Grant Likely wrote:

> > If you attempt to stick a 'reg' in a block nested below a
> > 'device_type="pci"' the kernel throws lots of error messsages and
> > generates bad address mappings.
> 
> Have you added the appropriate #address-cells and #size-cells to the pci
> device node to go back to a non-pci addressing mode?
> assigned-addresses

Switching away from the 5 dword address format is not ideal
because then there is no way to specify the resource region (prefetch,
io, mmio) and mmio would have to be assumed.

> only makes sense in the pci-device node itself. reg should work for all
> nodes below that, and if it doesn't then it is a bug that we need to
> fix.

Okay.. but how should the DTS be constructed?

pcie_bus { // The PCI-E bus
   device_type = "pci";
   ranges = <5dw ranges>;
   #address-cells = <3>;
   #size-cells = <2>;
   soc_bridge { // The PCI-E device
      device_type = "pci";
      ranges = <5dw ranges>;

      soc_device { // Internal device
          assigned-address = <5dw regs>
      };
   };
};

This is what I have now, the soc_bridge PCI-E device is DTS modeled as
a PCI bridge - it has a ranges with its memory location, and the
children nodes are relative to those ranges. This would not be typical
for a non-bridge PCI-E device.

The reason for the 'assigned-address' requirement with the current
kernel code is the device_type=pci on soc_bridge. This makes
of_match_bus(parent) for soc_device return the PCI structure, which
has '.addresses = "assigned-addresses",'

So.. how would you like this to look?

Jason
