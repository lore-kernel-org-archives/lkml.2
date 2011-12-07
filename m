Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab1LGXmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:42:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:38537 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1LGXmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:42:17 -0500
Message-ID: <1323301293.12793.16.camel@pasglop>
Subject: Re: RFC: Device isolation infrastructure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, aik@au1.ibm.com,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Date: Thu, 08 Dec 2011 10:41:33 +1100
In-Reply-To: <1323287120.15059.63.camel@bling.home>
References: <20111207035816.GC7631@truffala.fritz.box>
	 <1323240402.2182.241.camel@bling.home>
	 <20111207142201.GA5696@truffala.fritz.box>
	 <1323287120.15059.63.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 12:45 -0700, Alex Williamson wrote:

> Ok, let's back up from the patch because I think its clouding the driver
> model with a detached device state that might be detracting from the
> useful bits.
> 
> An isolation group is a generic association of devices into a set based
> on, well... isolation.  Presumably something like an iommu driver does a
> bus_register_notifier() and bus_for_each_dev() and when a new device is
> added we do isolation_group_new() and isolation_group_dev_add() as
> necessary.  When the iommu driver needs to do a dma_ops call for a
> device, it can traverse up to the isolation group and find something
> that points it to the shared iommu context for that group.  While
> dma_ops can share the iommu context among the drivers attached to the
> various devices, iommu_ops wants a single meta-driver for the group
> because it's predominantly designed for use when devices are exposed
> directly to the user.  We trust native kernel drivers to share context
> between each other, we do not trust user level drivers to share context
> with anyone but themselves.  Ok so far?
> 
> The first question we run into is what does the iommu driver do if it
> does not provide isolation?  If it's a translation-only iommu, maybe it
> has a single context and can manage to maintain it internally and should
> opt-out of isolation groups.  But we also have things like MSI isolation
> where we have multiple contexts and the isolation strength is sufficient
> for dma_ops, but not iommu_ops.  I don't know if we want to make that
> determination via a strength bitmask at the group level or simply a bool
> that the iommu driver sets when it registers a group.

 .../...

I think we are trying to solve too many problems at once.

I don't believe we should have the normal dma ops path in the kernel be
rewritten on top of some new iommu isolation layer or anything like that
at this stage.

Proceed step by step or we'll never be finished. What that means imho
is:

 - Existing dma/iommu arch layers mostly remain as-is. It has its own
internal representation of devices, domains and possibly grouping
information, and things like the buggy RICOH devices are handled there
(via a flag set in a generic header quirk)

 - Isolation groups are a new high-level thing that is not used by the
iommu/dma code for normal in-kernel operations at this stage. The
platform iommu/dma code creates the isolation group objects and
populates them, it doesn't initially -use- them.

 - We can then use that for the needs of exposing the groups to user
space, perform driver level isolation, and provide the grouping
information to vfio.

 - In the -long- run, individual iommu/dma layers might be modified to
instead use the isolation layer as their own building block if that
makes sense, this can be looked at on a case by case basis but is not a
pre-req.

That leaves us with what I think is the main disagreement between David
and Alex approaches which is whether devices in a group are "detached"
completely (in some kind of limbo) while they are used by vfio or
something else vs. assigned to a different driver (vfio).

After much thinking, I believe that the driver ownership model is the
right one. However, we could still use the work David did here. IE. I
_do_ think that exposing groups as the individual unit of ownership to
user space is the right thing to do.

That means that instead of that current detached flag alone, what we
could do instead is have an in-kernel mechanism to request isolation
which works by having the isolation group kernel code perform:

 - Rename the detached flag to "exclusive". This flag prevents automatic
& user driven attachment of a driver by the generic code. Set that flag
on all devices in the group (need a hook for hotplug).

 - Detach existing drivers.

 - Once everything is detached, attach the requested client driver (vfio
being the one we initially provide, maybe uio could use that framework
as well). This can be done using an explicit in-kernel attach API that
can be used even when the exclusive flag is set.

 - Win

 - When releasing the group, we detach the client driver, clear the
exclusive flag and trigger a re-probe (automatic matching of kernel
drivers).

Cheers,
Ben.


