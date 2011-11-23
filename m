Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1KWShi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:37:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab1KWShh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:37:37 -0500
Message-ID: <1322073444.484.140.camel@bling.home>
Subject: Re: [PATCH] iommu: Include MSI susceptibility to DMA in creating
 iommu groups
From: Alex Williamson <alex.williamson@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Wed, 23 Nov 2011 11:37:24 -0700
In-Reply-To: <20111121233505.GG3344@sequoia.sous-sol.org>
References: <20111117170800.3125.84150.stgit@bling.home>
	 <20111118104651.GJ5627@amd.com> <1321628190.26410.63.camel@bling.home>
	 <20111118152710.GA5098@amd.com> <1321633956.26410.126.camel@bling.home>
	 <20111120120043.GB20535@8bytes.org>
	 <20111121233505.GG3344@sequoia.sous-sol.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 15:35 -0800, Chris Wright wrote:
> * Joerg Roedel (joro@8bytes.org) wrote:
> > >From device standpoint a MSI transaction is always a DMA memory write
> > to a given address range. The IOMMU-API should export a feature flag
> > whether it supports filtering on those transaction or not. We have that
> > today with the IOMMU_CAP_INTR_REMAP. I agree that the interface to get
> > this information is ugly because a domain is needed. But the interface
> > can be fixed. While doing this I suggest to rename that feature
> > IOMMU_CAP_INTR_ISOLATION or something like that.
> > VFIO can then check for this flag on module-load and refuse to load if
> > it is not available.
> 
> I can see that the native grouping (the typical pci bridge type) is
> really more a property of the topology.
> 
> The isolation properties of a group (arguably the whole point of the
> group) is subtly different.

Yes, there is a subtle difference there, maybe that's what we're
tripping over.  I see the group as an assertion by the iommu driver that
it can distinguish and isolate the set of devices within that group from
other groups and shared resources.  For instance, numerous systems
include hardware iommus that provide only translation and not isolation
(DMA is translated through the IOVA window or allowed direct to memory).
That doesn't mean they should implement a device_group callback that
statically returns a single groupid, that means they should not
implement device_group.  I'm afraid the meaning of a group will be lost
if we allow iommus to define groups, but then add flags saying "oh, but
we don't isolate ________".  I much prefer we enable a user to opt-in at
the iommu driver level than weaken the definition of a group.  Thanks,

Alex

