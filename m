Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab2LNV6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:58:18 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:38398 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab2LNV6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:58:17 -0500
Date: Fri, 14 Dec 2012 14:58:14 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: Support a PCI device that is compatible with
 'simple-bus'
Message-ID: <20121214215814.GA14149@obsidianresearch.com>
References: <20121210215119.GA32011@obsidianresearch.com>
 <20121214202629.BD40C3E0BDD@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214202629.BD40C3E0BDD@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 08:26:29PM +0000, Grant Likely wrote:

> > > If the soc_devices are getting triggered on that and they shouldn't be,
> > > then we need a mechanism in the soc_bridge node to kick out of that
> > > behavoir for its children.
> > 
> > Is this what you were thinking?
> 
> Not really. I see what you're trying to do, but doing it this way forces
> all children of PCI nodes to use the PCI addressing space. Others have
> had simple children of PCI devices and didn't use the PCI address layout
> at all. Those users would break with this approach.

Yes, that's right.

If you drop 'device_type=pci' from the PCI device (keep it on the host
bridge), then you can setup a ranges down to a smaller width and
things seem to work OK. That must be what other users are doing.

However, you can't stay at address-cells=3 for the children. That
doesn't work.

So, if you have separate PCI regions, like MMIO and prefetch it looks
like this works OK:

 pci_device@0 {
   ranges =
        // MMIO region, BAR 0
       <0x20000000 0x00000000  0x02000000 0x00000000 0x00000000  0x0 0x8000000
        // Prefetch region, BAR 1
        0x40000000 0x00000000  0x42000000 0x00000000 0x00000000  0x0 0x8000000>;

   #size-cells = <1>;
   #address-cells = <2>;
   sub {
     // MMIO region at BAR 0 offset 0x2000
     reg = <0x20000000 0x00002000 0x1000>;
   }
   sub2 {
     // Prefetch region at BAR 1 offset 0x4000
     reg = <0x40000000 0x00004000 0x1000>;
   }
 }

Which is weird, but OK..

This is good enough for my application.. fixing up address-cells=3 to
work generally seems pretty complicated at first blush?

> However, if you want to pass a unity mapping from the PCI device to the
> a child of it, it should be sufficient to use an empty 'ranges;'
> property in the PCI device node instead of listing out the ranges that
> you want to translate.

It isn't a unity mapping - the children see address 0 as being the
start of a BAR. The DTS has three levels of translation:

- platform device child - 0 is the start of a BAR in the pci device
- pci device - 0 is the start of the host bridge memory window for the
  BAR's type
- pci controller - 0 is the start of physical memory

Thanks,
Jason
