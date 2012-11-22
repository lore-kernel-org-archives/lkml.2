Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab2KVV0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:26:00 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33424 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab2KVVZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:25:57 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: use platform_device_add
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121121183403.GA7657@kroah.com>
References: <1353521759-28263-1-git-send-email-grant.likely@secretlab.ca> <20121121183403.GA7657@kroah.com>
Date: Thu, 22 Nov 2012 21:19:09 +0000
Message-Id: <20121122211909.9B1E03E129E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 10:34:03 -0800, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Nov 21, 2012 at 06:15:59PM +0000, Grant Likely wrote:
> > This allows platform_device_add a chance to call insert_resource on all
> > of the resources from OF. At a minimum this fills in proc/iomem and
> > presumably makes resource tracking and conflict detection work better.
> > However, it has the side effect of moving all OF generated platform
> > devices from /sys/devices to /sys/devices/platform/. It /shouldn't/
> > break userspace because userspace is not supposed to depend on the full
> > path (because userspace always does what it is supposed to, right?).
> > 
> > It also has a backup call to of_device_add() when running on PowerPC to
> > catch any devices that have overlapping regions. It will complain about
> > them, but it will not fail to register the device.
> > 
> > Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > 
> > Greg, do you mind taking a look at this? The reason the OF code hasn't been
> > calling platform_device_add() directly to this point is:
> > a) there are some trees with resource overlays
> > b) I want the devices in /sys/devices not /sys/devices/platform.
> 
> Putting the devices all in the "flat" location of /sys/devices/ is a bit
> worrisome to me.  What's wrong with platform/ ?  That is what they are,
> right?  Why change this?

Hahaha. *You* encouraged me to write the patch to remove
/sys/devices/platform/ when I was waffling over whether or not it was a
good idea. Granted, that was well over a year ago, but it takes me a
while to get around to some of the things on my todo list. :-)

It's not so much that there is anything wrong with platform/ other than
it is nonsensical. For example, a core system bus is often represented by an
platform device of it's own with a bunch of peripherals as children of
that. For example a PCI host controller. It doesn't make much sense to me for
some core devices to be at /sys/devices and others to be gathered
together under /sys/devices/platform.

However, all that mildly feels 'wrong' to me but isn't that big deal. A
bigger problem with b) (which I didn't describe well) is that existing
PowerPC support roots the platform devices hierarchy at /sys/devices, not
/sys/devices/platform and I'm nervous that changing it will break
things. If I commit the change that makes the move, and somebody
complains that I broke their userspace, then I need to have an exception
for those system or revert the patch entirely.

Regardless, I'm no longer happy with DT and non-DT platform device
registration having separate code paths. I would /like/ for
sys/device/platform to disappear, but that is merely a side issue.
The real issue is whether or not existing PowerPC userspace breaks. If
it does, there needs to be an exception to keep things under
/sys/devices.

> > I could easily add exceptions to platform_device_add() for both those cases, but
> > I don't like adding DT exceptions to the common code. However, I still need to
> > support the platforms that unfortunately have overlapping resources. This patch
> > does that by still calling the old path if platform_device_add() fails, but it
> > isn't nice either because of_device_add() has to duplicate
> > platform_device_add(). Blech. Plus the exception only applies for PowerPC.
> > 
> > So, how do you feel about having a 'relaxed' mode for platform_device_add()
> > which means it won't fail if resources overlap and maybe won't do the silly
> > platform_bus parent thing. Thoughts?
> 
> I have no objection for the resource issue, if you assure me it will not
> be abused :)

I can make that assurance. It will be powerpc-only also.

g.
