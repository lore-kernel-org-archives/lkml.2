Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2DRUIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:08:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab2DRUIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:08:13 -0400
Message-ID: <1334779677.3112.190.camel@bling.home>
Subject: Re: [RFC PATCH 1/3] iommu: Introduce iommu_group
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Apr 2012 14:07:57 -0600
In-Reply-To: <20120418095824.GB5387@truffala.fritz.box>
References: <20120402203721.28977.95285.stgit@bling.home>
	 <20120402211440.28977.74440.stgit@bling.home>
	 <20120418095824.GB5387@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 19:58 +1000, David Gibson wrote:
> On Mon, Apr 02, 2012 at 03:14:40PM -0600, Alex Williamson wrote:
> > IOMMUs often do not have visibility of individual devices in the
> > system.  Due to IOMMU design, bus topology, or device quirks, we
> > can often only identify groups of devices.  Examples include
> > Intel VT-d & AMD-Vi which often have function level visibility
> > compared to POWER partitionable endpoints which have bridge level
> > granularity.
> 
> That's a significant oversimplification of the situation on POWER,
> although it doesn't really matter in this context.  On older (i.e. pre
> PCI-E) hardware, PEs have either host bridge (i.e. domain)
> granularity, or in IIUC in some cases p2p bridge granularity, using
> special p2p bridges, since that's the only real way to do iommu
> differentiation without the PCI-E requestor IDs.  This isn't as coarse
> as it seems in practice, because the hardware is usually built with a
> bridge per physical PCI slot.
> 
> On newer PCI-E hardware, the PE granularity is basically a firmware
> decision, and can go down to function level.  I believe pHyp puts the
> granularity at the bridge level.  Our non-virtualized Linux "firmware"
> currently does put it at the function level, but Ben is thinking about
> changing that to bridge level: again, because of the hardware design
> that isn't as coarse as it seems, and at this level we can hardware
> guarantee isolation to a degree that's not possible at the function
> level.

Ok, thanks for the clarification.  This should support either model and
it will be up to the iommu driver to fill the groups with the right
devices.

> >  PCIe-to-PCI bridges also often cloud the IOMMU
> > visibility as it cannot distiguish devices behind the bridge.
> > Devices can also sometimes hurt themselves by initiating DMA using
> > the wrong source ID on a multifunction PCI device.
> > 
> > IOMMU groups are meant to help solve these problems and hopefully
> > become the working unit of the IOMMI API.
> 
> So far, so simple.  No objections here.  I am trying to work out what
> the real difference in approach is in this seriers from either your or
> my earlier isolation group series.  AFAICT it's just that this
> approach is explicitly only about IOMMU identity, ignoring (here) any
> other factors which might affect isolation.  Or am I missing
> something?

Yes, they are very similar and actually also similar to how VFIO manages
groups.  It's easy to start some kind of group structure, the hard part
is in the details and particularly where to stop.  My attempt to figure
out where isolation groups stop went quite poorly, ending up with a
ridiculously complicated mess of hierarchical groups that got worse as I
tried to fill in the gaps.

With iommu groups I try to take a step back and simplify.  I initially
had a goal of describing only the minimum iommu granularity sets, this
is where the dma_dev idea came from.  But the iommu granularity doesn't
really guarantee all that much or allow any ability for the iommu driver
to add additional policies that would be useful for userspace drivers
(ex. multi-function devices and peer-to-peer isolation).  So again I've
had to allow that a group might have multiple visible requestor IDs
within the group.  This time though I'm trying to disallow hierarchies,
which means that even kernel, dma_ops, usage of groups are restricted to
a single, platform defined, level of isolation.  I'm also trying to stay
out of the business of providing a group management interface.  I only
want to describe groups.  Things like stopping driver probes should be
device level problems.  In effect, this level should not be providing
enforcement and ownership, something like VFIO will do that.  So the
differences are subtle, but important.  Thanks,

Alex

