Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1LSANA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:13:00 -0500
Received: from ozlabs.org ([203.10.76.45]:44861 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1LSAM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:12:56 -0500
Date: Mon, 19 Dec 2011 11:11:25 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, aik@ozlabs.ru,
        benh@kernel.crashing.org, dwmw2@infradead.org, chrisw@redhat.com,
        agraf@suse.de, scottwood@freescale.com, B08248@freescale.com,
        rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org, joro@8bytes.org
Subject: Re: [RFC] Device isolation infrastructure v2
Message-ID: <20111219001125.GA30390@truffala.fritz.box>
Mail-Followup-To: Joerg Roedel <joerg.roedel@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>, aik@ozlabs.ru,
	benh@kernel.crashing.org, dwmw2@infradead.org, chrisw@redhat.com,
	agraf@suse.de, scottwood@freescale.com, B08248@freescale.com,
	rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
	qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
	joro@8bytes.org
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
 <20111216145353.GA29877@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216145353.GA29877@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 03:53:53PM +0100, Joerg Roedel wrote:
> On Thu, Dec 15, 2011 at 11:05:07AM -0700, Alex Williamson wrote:
> > Starting with it in the core and hand waving some future use that we
> > don't plan to implement right now seems like the wrong direction.
> 
> I agree with Alex. First of all, I havn't seen any real vfio problem
> that can't be solved with the current approach, and it has the great
> advantage of simplicity. It doesn't require a re-implementation of the
> driver-core based on groups.

I'm not re-implementing the driver core in terms of groups, just
adding the concept of groups to the driver core.

> I agree that we need some improvements to
> Alex' code for the dma-api layer to solve the problem with broken devices
> using the wrong requestor-id. But that can be done incrementally with
> the current (current == in the iommu-tree) approach implemented by Alex.
> 
> I also think that all this does not belong into the driver core for two
> reasons:
> 
> 	1) The information for building the device groups is provided
> 	   by the iommu-layer

Yes.. no change there.

> 	2) The group information is provided to vfio by the iommu-api

Um.. huh?  Currently, the iommu-api supplies the info vfio, therefore
it should?  I assume there's a non-circular argument you're trying to
make here, but I can't figure out what it is.

> This makes the iommu-layer the logical point to place the grouping
> code.

Well.. that's not where it is in Alex's code either.  The iommu layer
(to the extent that there is such a "layer") supplies the group info,
but the group management is in vfio, not the iommu layer.  With mine
it is in the driver core because the struct device seemed the logical
place for the group id.

Moving the group management into the iommu code itself probably does
make more sense, although I think that would be a change more of code
location than any actual content change.

> There are some sources outside of the iommu-layer that may influence
> grouping (like pci-quirks), but most of the job is done by the
> iommu-drivers.

Right, so, the other problem is that a well boundaried "iommu-driver'
is something that only exists on x86 at present, and the "iommu api"
is riddled with x86-centric thinking.  Or more accurately, design
based on how the current intel and amd iommus work.  On systems like
POWER, use of the iommu is not optional - it's built into the PCI host
bridge and must be initialized when the bridge is probed, much earlier
than iommu driver initialization on x86.  They have no inbuilt concept
of domains (though we could fake in software in some circumstances).

Now, that is something that needs to be fixed longer term.  I'm just
not sure how to deal with that and sorting out some sort of device
isolation / passthrough system.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
