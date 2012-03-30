Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2C3ET4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 00:19:56 -0400
Received: from ozlabs.org ([203.10.76.45]:56216 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab2C3ETu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 00:19:50 -0400
Date: Fri, 30 Mar 2012 15:19:46 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Isolation groups
Message-ID: <20120330041946.GA21161@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	aik@ozlabs.ru, dwmw2@infradead.org,
	iommu@lists.linux-foundation.org, benh@kernel.crashing.org,
	qemu-devel@nongnu.org, joerg.roedel@amd.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20120313143340.GT24916@truffala.fritz.box>
 <1331657387.2969.79.camel@bling.home>
 <20120314095808.GX24916@truffala.fritz.box>
 <1331842501.22038.58.camel@ul30vt>
 <20120316034527.GJ24916@truffala.fritz.box>
 <1331926278.13855.57.camel@bling.home>
 <20120317045734.GL24916@truffala.fritz.box>
 <1332364378.13855.236.camel@bling.home>
 <20120327051407.GJ9357@truffala.fritz.box>
 <1332876883.29722.143.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332876883.29722.143.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 01:34:43PM -0600, Alex Williamson wrote:
[snip]
> > > > this case, it gets a bit complex.  When the FooBus isolation provider
> > > > is active, the FooBus devices would be in their own groups, not the
> > > > group of the FooBridge and its sibling.  When the FooBus isolation
> > > > provider is removed, it would have to configure the FooBus IOMMU to a
> > > > passthrough mode, and revert the FooBus devices to the parent's
> > > > group.  Hm.  Complicated.
> > > 
> > > Yep.  I think we're arriving at the same point.  Groups are
> > > hierarchical, but ownership via a manager cannot be nested.  So to
> > > manage a group, we need to walk the entire tree of devices below each
> > > device checking that none of the groups are managed and all the devices
> > > are using the right driver, then walk up from the group to verify no
> > > group of a parent device is managed.  Thanks,
> > 
> > Blargh.  I really, really hope we can come up with a simpler model
> > than that.
> 
> Yep, I'm pretty well at the end of this experiment.  Honestly, I think
> isolation groups are the wrong approach.  We're trying to wrap too many
> concepts together and it's completely unmanageable.  I cannot see adding
> the complexity we're talking about here to the core device model for
> such a niche usage.  I think we're better off going back to the
> iommu_device_group() and building that out into something more complete,
> starting with group based iommu ops and a dma quirk infrastructure.
> >From there we can add some basic facilities to toggle driver autoprobe,
> maybe setup notifications for the group, and hopefully include a way to
> share iommu mappings between groups.  Anything much beyond that we
> should probably leave for something like the vfio driver.  Thanks,

Yes, well, I was hoping for a simpler model that didn't involve simply
sweeping all the issues under a rug.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
