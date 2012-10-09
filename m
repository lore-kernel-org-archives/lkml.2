Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2JITdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 15:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab2JITdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 15:33:37 -0400
Message-ID: <1349811210.2759.300.camel@ul30vt.home>
Subject: Re: [RFC PATCH 0/5] amd_iommu: Refactor IOMMU group and support
 virtual aliases
From: Alex Williamson <alex.williamson@redhat.com>
To: Florian Dazinger <florian@dazinger.net>
Cc: Joerg.Roedel@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Oct 2012 13:33:30 -0600
In-Reply-To: <20121009205758.45c9fcc0@brain.lan>
References: <20121009044057.16302.44577.stgit@bling.home>
	 <20121009202738.7e047e64@brain.lan> <1349807739.2759.292.camel@ul30vt.home>
	 <20121009205758.45c9fcc0@brain.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 20:57 +0200, Florian Dazinger wrote:
> Am Tue, 09 Oct 2012 12:35:39 -0600
> schrieb Alex Williamson <alex.williamson@redhat.com>:
> 
> > On Tue, 2012-10-09 at 20:27 +0200, Florian Dazinger wrote:
> > > Am Mon, 08 Oct 2012 22:49:28 -0600
> > > schrieb Alex Williamson <alex.williamson@redhat.com>:
> > > 
> > > > This series is meant to refactor IOMMU group support in amd_iommu
> > > > to properly support virtual aliases.  If multiple devices alias to
> > > > the same virtual alias, they should be grouped together.  This code
> > > > also verifies whether the alias should be the root of the group vs
> > > > devices above the alias.
> > > > 
> > > > This seems to do the right thing on my system, but that's not saying
> > > > a lot since it doesn't do anything interesting with aliases.  I'd
> > > > appreciate if Joerg and Florian could test this on their systems.
> > > > Thanks,
> > > > 
> > > > Alex
> > > > 
> > > > ---
> > > > 
> > > > Alex Williamson (5):
> > > >       amd_iommu: Properly account for virtual aliases in IOMMU groups
> > > >       amd_iommu: Split IOMMU group allocation and attach
> > > >       amd_iommu: Split upstream bus device lookup
> > > >       amd_iommu: Split IOMMU Group topology walk
> > > >       amd_iommu: Split IOMMU group initialization
> > > > 
> > > > 
> > > >  drivers/iommu/amd_iommu.c       |  184 ++++++++++++++++++++++++++++++---------
> > > >  drivers/iommu/amd_iommu_types.h |    1 
> > > >  2 files changed, 142 insertions(+), 43 deletions(-)
> > > > 
> > > 
> > > patch #5 does not apply cleanly on top of 3.6, I had to edit
> > > amd_iommu_types.h manually (easy enough), apart from that, it is
> > > working fine!
> > 
> > Thanks Florian.  Would you mind also reporting
> > 'find /sys/kernel/iommu_groups' for both stock 3.6 and with this series
> > applied?  I think we want to find that devices 07:00.0 and 08:04.0 are
> > grouped together and I'd like to verify whether that actually works.
> > Thanks,
> > 
> > Alex
> 
> shure... there does not seem to be much difference?
> 
> with stock 3.6:
> /sys/kernel/iommu_groups/19                                                                                                                                                                                                                
> /sys/kernel/iommu_groups/19/devices                                                                                                                                                                                                        
> /sys/kernel/iommu_groups/19/devices/0000:07:00.0                                                                                                                                                                                           
> /sys/kernel/iommu_groups/20                                                                                                                                                                                                                
> /sys/kernel/iommu_groups/20/devices                                                                                                                                                                                                        
> /sys/kernel/iommu_groups/20/devices/0000:08:04.0 
> 
> 
> 3.6 + your patch-series:
> 3.6 with your patch-series:
> /sys/kernel/iommu_groups/19
> /sys/kernel/iommu_groups/19/devices
> /sys/kernel/iommu_groups/19/devices/0000:07:00.0
> /sys/kernel/iommu_groups/20
> /sys/kernel/iommu_groups/20/devices
> /sys/kernel/iommu_groups/20/devices/0000:08:04.0

Ok, I was thinking we'd see these last two devices together, but on
second thought this is exactly what the alias is telling us, ie. it can
distinguish a DMA from a device on bus 08 from a DMA from 07:00.0
itself, but it cannot distinguish between devices on bus 08 (hopefully
that's actually true).  If you somehow had a device 08:05.0 you would
see a new group 21 with just that device on stock 3.6 whereas with the
patches you should see 08:05.0 added to group 20.  If we plugged this
same card into an Intel VT-d system, the grouping would be done as I was
thinking with both 07:00.0 and 08:04.0 being in group 19.  Thanks again
for your testing,

Alex

