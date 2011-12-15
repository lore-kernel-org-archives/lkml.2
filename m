Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab1LOSFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:05:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202Ab1LOSFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:05:32 -0500
Message-ID: <1323972307.2437.19.camel@x201.home>
Subject: Re: [RFC] Device isolation infrastructure v2
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, joerg.roedel@amd.com,
        dwmw2@infradead.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com, rusty@rustcorp.com.au,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Dec 2011 11:05:07 -0700
In-Reply-To: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 17:25 +1100, David Gibson wrote:
> Here's the second spin of my preferred approach to handling grouping
> of devices for safe assignment to guests.
> 
> Changes since v1:
>  * Many name changes and file moves for improved consistency
>  * Bugfixes and cleanups
>  * The interface to the next layer up is considerably fleshed out,
>    although it still needs work.
>  * Example initialization of groups for p5ioc2 and p7ioc.
> 
> TODO:
>  * Need sample initialization of groups for intel and/or amd iommus

I think this very well might imposed significant bloat for those
implementations.  On POWER you typically don't have singleton groups,
while it's the norm on x86.  I don't know that either intel or amd iommu
code have existing structures that they can simply tack the group
pointer to.  Again, this is one of the reasons that I think the current
vfio implementation is the right starting point.  We keep groups within
vfio, imposing zero overhead for systems not making use of it and only
require iommu drivers to implement a trivial function to opt-in.  As we
start to make groups more pervasive in the dma layer, independent of
userspace driver exposure, we can offload pieces to the core.  Starting
with it in the core and hand waving some future use that we don't plan
to implement right now seems like the wrong direction.

>  * Use of sysfs attributes to control group permission is probably a
>    mistake.  Although it seems a bit odd, registering a chardev for
>    each group is probably better, because perms can be set from udev
>    rules, just like everything else.

I agree, this is a horrible mistake.  Reinventing file permissions via
sysfs is bound to be broken and doesn't account for selinux permissions.
Again, I know you don't like aspects of the vfio group management, but
it gets this right imho.

>  * Need more details of what the binder structure will need to
>    contain.
>  * Handle complete removal of groups.
>  * Clarify what will need to happen on the hot unplug path.

We're still also removing devices from the driver model, this means
drivers like vfio need to re-implement a lot of the driver core for
driving each individual device in the group, and as you indicate, it's
unclear what happens in the hotplug path and I wonder if things like
suspend/resume will also require non-standard support.  I really prefer
attaching individual bus drivers to devices using the standard
bind/unbind mechanisms.  I have a hard time seeing how this is an
improvement from vfio.  Thanks,

Alex

