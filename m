Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab2ACPWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:22:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab2ACPWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:22:11 -0500
Message-ID: <1325604092.3124.17.camel@bling.home>
Subject: Re: [Qemu-devel] [PATCH 1/5] vfio: Introduce documentation for VFIO
 driver
From: Alex Williamson <alex.williamson@redhat.com>
To: Ronen Hod <rhod@redhat.com>
Cc: chrisw@sous-sol.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, agraf@suse.de, benve@cisco.com,
        aafabbri@cisco.com, B08248@freescale.com, B07421@freescale.com,
        avi@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Jan 2012 08:21:32 -0700
In-Reply-To: <4EFB4EFD.4080706@redhat.com>
References: <20111221213019.27028.26890.stgit@bling.home>
	 <20111221214212.27028.78947.stgit@bling.home> <4EFB4EFD.4080706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-28 at 19:16 +0200, Ronen Hod wrote:
> On 12/21/2011 11:42 PM, Alex Williamson wrote:
> > +The final aspect of VFIO is the notion of merging groups.  In both the
> > +assignment of devices to virtual machines and the pure userspace
> > +driver model, it's expect that a single user instance is likely to
> > +have multiple groups in use simultaneously.  If these groups are all
> > +using the same set of IOMMU mappings, the overhead of userspace
> > +setting up and tearing down the mappings, as well as the internal
> > +IOMMU driver overhead of managing those mappings can be non-trivial.
> > +Some IOMMU implementations are able to easily reduce this overhead by
> > +simply using the same set of page tables across multiple groups.
> > +VFIO allows users to take advantage of this option by merging groups
> > +together, effectively creating a super group (IOMMU groups only define
> > +the minimum granularity).
> > +
> > +A user can attempt to merge groups together by calling the merge ioctl
> > +on one group (the "merger") and passing a file descriptor for the
> > +group to be merged in (the "mergee").  Note that existing DMA mappings
> > +cannot be atomically merged between groups, it's therefore a
> > +requirement that the mergee group is not in use.  This is enforced by
> > +not allowing open device or iommu file descriptors on the mergee group
> > +at the time of merging.  The merger group can be actively in use at
> > +the time of merging.  Likewise, to unmerge a group, none of the device
> > +file descriptors for the group being removed can be in use.  The
> > +remaining merged group can be actively in use.
> > +
> 
> Can you elaborate on the scenario that led a user to merge groups?

Anytime a user is managing multiple groups with the same set of iommu
mappings, they probably wants to try to merge the groups so they only
have to program the iommu once, instead of once per group.  This works
well in the qemu/x86 device assignment model where we map full guest
memory into the iommu to allow transparent device assignment, ie. the
guest doesn't need to be enlightened or forced to use a specific DMA
mechanism.  If instead we exposed an emulated or paravirtualized iommu
and expected the guest to make use of it to limit the number of pinned
guest pages, it might make sense to expose that per group, especially if
the I/O virtual address window is small or lives at different offsets,
so merging wouldn't make sense then.  I'll add something to this effect
in the documentation.

> Does it make sense to try to "automatically" merge a (new) group with 
> all the existing groups sometime prior to its first device open?

I don't think so.  As above, it would assume a usage model.

> As always, it is a pleasure to read your documentation.

Thanks!

Alex


