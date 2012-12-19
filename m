Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2LSMzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:55:05 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39440 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2LSMy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:54:56 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Support a PCI device that is compatible with 'simple-bus'
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121214215814.GA14149@obsidianresearch.com>
References: <20121210215119.GA32011@obsidianresearch.com> <20121214202629.BD40C3E0BDD@localhost> <20121214215814.GA14149@obsidianresearch.com>
Date: Wed, 19 Dec 2012 12:54:51 +0000
Message-Id: <20121219125451.3F1FB3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 14:58:14 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> On Fri, Dec 14, 2012 at 08:26:29PM +0000, Grant Likely wrote:
> 
> > > > If the soc_devices are getting triggered on that and they shouldn't be,
> > > > then we need a mechanism in the soc_bridge node to kick out of that
> > > > behavoir for its children.
> > > 
> > > Is this what you were thinking?
> > 
> > Not really. I see what you're trying to do, but doing it this way forces
> > all children of PCI nodes to use the PCI addressing space. Others have
> > had simple children of PCI devices and didn't use the PCI address layout
> > at all. Those users would break with this approach.
> 
> Yes, that's right.
> 
> If you drop 'device_type=pci' from the PCI device (keep it on the host
> bridge), then you can setup a ranges down to a smaller width and
> things seem to work OK. That must be what other users are doing.
> 
> However, you can't stay at address-cells=3 for the children. That
> doesn't work.
> 
> So, if you have separate PCI regions, like MMIO and prefetch it looks
> like this works OK:
> 
>  pci_device@0 {
>    ranges =
>         // MMIO region, BAR 0
>        <0x20000000 0x00000000  0x02000000 0x00000000 0x00000000  0x0 0x8000000
>         // Prefetch region, BAR 1
>         0x40000000 0x00000000  0x42000000 0x00000000 0x00000000  0x0 0x8000000>;
> 
>    #size-cells = <1>;
>    #address-cells = <2>;
>    sub {
>      // MMIO region at BAR 0 offset 0x2000
>      reg = <0x20000000 0x00002000 0x1000>;
>    }
>    sub2 {
>      // Prefetch region at BAR 1 offset 0x4000
>      reg = <0x40000000 0x00004000 0x1000>;
>    }
>  }
> 
> Which is weird, but OK..
> 
> This is good enough for my application.. fixing up address-cells=3 to
> work generally seems pretty complicated at first blush?
> 
> > However, if you want to pass a unity mapping from the PCI device to the
> > a child of it, it should be sufficient to use an empty 'ranges;'
> > property in the PCI device node instead of listing out the ranges that
> > you want to translate.
> 
> It isn't a unity mapping - the children see address 0 as being the
> start of a BAR. The DTS has three levels of translation:
> 
> - platform device child - 0 is the start of a BAR in the pci device
> - pci device - 0 is the start of the host bridge memory window for the
>   BAR's type
> - pci controller - 0 is the start of physical memory

Then it sounds like you really don't want PCI addressing in the
children. It sounds like the children addresses need to be in the form
[bar#] [offset-from-base-of-bar]. In that case, you need the appropriate
ranges entries to translate from each bar to the PCI address space,
which is exactly what other users are doing. Whether your address format
uses 2 cells or 3, it shouldn't matter. The translation mechanism is the
same:

ranges = <[child-address1] [parent-address2] [child-size]>,
	 <[child-address2] [parent-address2] [child-size]>,
	 ...
	 ;

I may still be missing something though. Here is what I've been
assuming:

- The PCI device has N BARs.
- The PCI bus assigns addresses to the BARs (exposed in assigned-addresses)
- Each BAR may use different address region (IO/mem) or have different
  behaviour (prefetch/non-prefetch)
- either:
  a) The PCI device has a separate local bus behind each BAR. Devices and/or
     memory are attached to those busses and must be accessed through the
     relevant BAR.
  --or--
  b) The PCI device has a single local bus which the BARs map onto.
     Internally, the BARs get mapped onto local bus regions and may
     possibly overlap.

Am I correct so far?

In the a) case, it would make sense for the address format for the
device to be 1 cell for the bar# and 1 or 2 cells for the offset off the
base of the bar. One ranges entry is needed for each bar to translate
from a PCI address range to the BAR region.

In the b) case, the address of the child devices should be the exact
address on the local bus. Again one ranges entry is needed for each BAR,
but this time it encodes the full mapping from PCI address to local
address.

In both cases, the type of transfer is encoded by the BAR address and
does not get exposed to the child device. Exposing the PCI flags into
the child bus(es) really isn't a very good idea because they don't make
sense in that context. It may seem expedient, but it will be fragile.

I apologize if I'm being dense here and missing something about why you
need to use PCI addressing on a non-PCI bus segment. Please let me know
if I'm missing something important.

g.

