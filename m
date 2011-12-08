Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1LHHCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:02:13 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57372 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab1LHHCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:02:09 -0500
Date: Thu, 8 Dec 2011 17:52:16 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com,
        benh@kernel.crashing.org
Subject: Re: RFC: Device isolation infrastructure
Message-ID: <20111208065216.GA9107@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>, joerg.roedel@amd.com,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	aik@au1.ibm.com, linux-kernel@vger.kernel.org, chrisw@redhat.com,
	agraf@suse.de, scottwood@freescale.com, B08248@freescale.com,
	benh@kernel.crashing.org
References: <20111207035816.GC7631@truffala.fritz.box>
 <1323240402.2182.241.camel@bling.home>
 <20111207142201.GA5696@truffala.fritz.box>
 <1323287120.15059.63.camel@bling.home>
 <20111208024357.GB5344@truffala.fritz.box>
 <1323325390.24340.81.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323325390.24340.81.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120720-7014-0000-0000-0000003A9363
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 11:23:10PM -0700, Alex Williamson wrote:
> On Thu, 2011-12-08 at 13:43 +1100, David Gibson wrote:
> > On Wed, Dec 07, 2011 at 12:45:20PM -0700, Alex Williamson wrote:
> > > So the next problem is that while the group is the minimum granularity
> > > for the iommu, it's not necessarily the desired granularity.  iommus
> > > like VT-d have per PCI BDF context entries that can point to shared page
> > > tables.  On such systems we also typically have singleton isolation
> > > groups, so when multiple devices are used by a single user, we have a
> > > lot of duplication in time and space.  VFIO handles this by allowing
> > > groups to be "merged".  When this happens, the merged groups point to
> > > the same iommu context.  I'm not sure what the plan is with isolation
> > > groups, but we need some way to reduce that overhead.
> > 
> > Right.  So, again, I intend that mutiple groups can go into one
> > domain.  Not entirely sure of the interface yet.  One I had in mind
> > was to borrow the vfio1 interface, so you open a /dev/vfio (each open
> > gives a new instance).  Then you do an "addgroup" ioctl which adds a
> > group to the domain.  You can do that multiple times, then start using
> > the domain.
> 
> This also revisits one of the primary problems of vfio1, the dependency
> on a privileged uiommu domain creation interface.  Assigning a user
> ownership of a group should be a privileged operation.  If a privileged
> user needs to open /dev/vfio, add groups, then drop privileges and hand
> the open file descriptor to an unprivileged user, the interface becomes
> much harder to use.  "Hot merging" becomes impossible.

No, I was assuming that "permission to detach" could be handed out to
a user before this step.  uid/gid/mode attributes in sysfs would
suffice, though there might be better ways.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

