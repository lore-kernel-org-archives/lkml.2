Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab2I0QXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:23:11 -0400
Received: from wp118.webpack.hosteurope.de ([80.237.132.125]:37814 "EHLO
	wp118.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793Ab2I0QXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:23:09 -0400
Date: Thu, 27 Sep 2012 18:22:49 +0200
From: Florian Dazinger <florian@dazinger.net>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        iommu <iommu@lists.linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.6-rc7 boot crash + bisection
Message-ID: <20120927182249.2338546f@brain.lan>
In-Reply-To: <1348697043.28860.235.camel@bling.home>
References: <20120924210348.5f50677b@brain.lan>
	<1348597970.28860.114.camel@bling.home>
	<20120925205420.0a07dea2@brain.lan>
	<1348602226.28860.132.camel@bling.home>
	<20120926132050.GB10549@amd.com>
	<1348670159.28860.183.camel@bling.home>
	<20120926151044.GE10549@amd.com>
	<1348676470.28860.197.camel@bling.home>
	<1348689013.28860.220.camel@bling.home>
	<1348697043.28860.235.camel@bling.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;florian@dazinger.net;1348762989;2c91b882;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 26 Sep 2012 16:04:03 -0600
schrieb Alex Williamson <alex.williamson@redhat.com>:

> On Wed, 2012-09-26 at 13:50 -0600, Alex Williamson wrote:
> > On Wed, 2012-09-26 at 10:21 -0600, Alex Williamson wrote:
> > > On Wed, 2012-09-26 at 17:10 +0200, Roedel, Joerg wrote:
> > > > On Wed, Sep 26, 2012 at 08:35:59AM -0600, Alex Williamson wrote:
> > > > > Hmm, that throws a kink in iommu groups.  So perhaps we need to make an
> > > > > alias interface to iommu groups.  Seems like this could just be an extra
> > > > > parameter to iommu_group_get and iommu_group_add_device (empty in the
> > > > > typical case).  Then we have the problem of what's the type for an
> > > > > alias?  For AMI-Vi, it's a u16, but we need to be more generic than
> > > > > that.  Maybe iommu groups should just treat it as a void* so iommus can
> > > > > use a pointer to some structure or a fixed value like a u16 bus:slot.
> > > > > Thoughts?
> > > > 
> > > > Good question. The iommu-groups are part of the IOMMU-API, with an
> > > > interface to the IOMMU drivers and one to the users of IOMMU-API. So the
> > > > alias handling itself should be a function of the interface to the IOMMU
> > > > driver. In general the interface should not be bus specific.
> > > > 
> > > > So a void pointer seems the only logical choice then. But I would not
> > > > limit its scope to alias handling. How about making it a bus-private
> > > > pointer where IOMMU driver store bus-specific information. That way we
> > > > make sure that there is one struct per bus-type for this pointer, and
> > > > not one structure per IOMMU driver.
> > > 
> > > I thought of another approach that may actually be more 3.6 worthy.
> > > What if we just make the iommu driver handle it?  For instance,
> > > amd_iommu can walk the alias table looking for entries that use the same
> > > alias and get the device via pci_get_bus_and_slot.  If it finds a device
> > > with an iommu group, it attaches the new device to the same group,
> > > hiding anything about aliases from the group layer.  It just groups all
> > > devices within the range.  I think the only complication is making sure
> > > we're safe around device hotplug while we're doing this.  Thanks,
> > 
> > I think this could work.  Instead of searching for other devices, check
> > for or allocate an iommu group on the alias dev_data, any "virtual"
> > aliases use that iommu group.  Florian, could you test this as well?
> 
> Here's a lockdep clean version of it:
> 
> amd_iommu: Handle aliases not backed by devices
> 
[ skipped patch ]

yes, this patch is working for me, too. I also tested your second patch, it was working as well.
thanks, Florian
