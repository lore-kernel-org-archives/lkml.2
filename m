Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab1K3JY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:24:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:43358 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab1K3JYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:24:22 -0500
Message-ID: <1322645028.21641.71.camel@pasglop>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        chrisw@redhat.com, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com
Date: Wed, 30 Nov 2011 20:23:48 +1100
In-Reply-To: <1322630751.19120.222.camel@bling.home>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 22:25 -0700, Alex Williamson wrote:

> Note that iommu drivers are registered per bus_type, so the unique pair
> is {bus_type, groupid}, which seems sufficient for vfio.
> 
> > Don't forget that to keep sanity, we really want to expose the groups
> > via sysfs (per-group dir with symlinks to the devices).
> > 
> > I'm working with Alexey on providing an in-kernel powerpc specific API
> > to expose the PE stuff to whatever's going to interface to VFIO to
> > create the groups, though we can eventually collapse that. The idea is
> > that on non-PE capable brigdes (old style), I would make a single group
> > per host bridge.
> 
> If your non-PE capable bridges aren't actually providing isolation, they
> should return -ENODEV for the group_device() callback, then vfio will
> ignore them.

Why ignore them ? It's perfectly fine to consider everything below the
host bridge as one group. There is isolation ... at the host bridge
level.

Really groups should be a structure, not a magic number. We want to
iterate them and their content, represent them via an API, etc... and so
magic numbers means that anything under the hood will have to constantly
convert between that and some kind of internal data structure.

I also somewhat dislike the bus_type as the anchor to the grouping
system, but that's not necessarily as bad an issue for us to deal with.

Eventually what will happen on my side is that I will have a powerpc
"generic" (ie. accross platforms) that allow to enumerate groups and
retrieve the dma windows associated with them etc...

That API will use underlying function pointers provided by the PCI host
bridge (for which we do have a data structure, struct pci_controller,
like many other archs except I think x86 :-)

Any host platform that doesn't provide those pointers (ie. all of them
initially) will get a default behaviour which is to group everything
below a host bridge (since host bridges still have independent iommu
windows, at least for us they all do). 

On top of that we can implement a "backend" that provides those pointers
for the p7ioc bridge used on the powernv platform, which will expose
more fine grained groups based on our "partitionable endpoint"
mechanism.

The grouping will have been decided early at boot time based on a mix of
HW resources and bus topology, plus things like whether there is a PCI-X
bridge etc... and will be initially immutable.

Ideally, we need to expose a subset of this API as a "generic" interface
to allow generic code to iterate the groups and their content, and to
construct the appropriate sysfs representation.

> > In addition, Alex, I noticed that you still have the domain stuff there,
> > which is fine I suppose, we could make it a requirement on power that
> > you only put a single group in a domain... but the API is still to put
> > individual devices in a domain, not groups, and that somewhat sucks.
> > 
> > You could "fix" that by having some kind of ->domain_enable() or
> > whatever that's used to "activate" the domain and verifies that it
> > contains entire groups but that looks like a pointless way to complicate
> > both the API and the implementation.
> 
> Right, groups are currently just a way to identify dependent sets, not a
> unit of work.  We can also have group membership change dynamically
> (hotplug slot behind a PCIe-to-PCI bridge), so there are cases where we
> might need to formally attach/detach a group element to a domain at some
> later point.  This really hasn't felt like a stumbling point for vfio,
> at least on x86.  Thanks,

It doesn't matter much as long as we have a way to know that a group is
"complete", ie that all devices of a group have been taken over by vfio
and put into a domain, and block them from being lost. Only then can we
actually "use" the group and start reconfiguring the iommu etc... for
use by the guest.

Note that groups -will- contain briges eventually. We need to take that
into account since bridges -usually- don't have an ordinary driver
attached to them so there may be issues there with tracking whether they
are taken over by vfio...

Cheers,
Ben.


