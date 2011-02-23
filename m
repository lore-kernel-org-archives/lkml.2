Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1BWSvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:51:39 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:62782 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1BWSvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:51:38 -0500
Date: Wed, 23 Feb 2011 11:51:34 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/10] MIPS: Octeon: Initialize and fixup device
 tree.
Message-ID: <20110223185134.GN14597@angua.secretlab.ca>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
 <1298408274-20856-7-git-send-email-ddaney@caviumnetworks.com>
 <20110223174120.GG14597@angua.secretlab.ca>
 <4D6554A0.5010407@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6554A0.5010407@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 10:40:32AM -0800, David Daney wrote:
> On 02/23/2011 09:41 AM, Grant Likely wrote:
> >On Tue, Feb 22, 2011 at 12:57:50PM -0800, David Daney wrote:
> >>Signed-off-by: David Daney<ddaney@caviumnetworks.com>
> >>---
> >>  arch/mips/Kconfig                         |    2 +
> >>  arch/mips/cavium-octeon/octeon-platform.c |  280 +++++++++++++++++++++++++++++
> >>  arch/mips/cavium-octeon/setup.c           |   17 ++
> >>  3 files changed, 299 insertions(+), 0 deletions(-)
> >
> >I've got an odd feeling of foreboding about this patch.  It makes me
> >nervous, but I can't articulate why yet.  Gut-wise I'd rather see the
> >device tree pruned/fixed up before it gets unflattened,
> 
> I chose to work on the unflattened form because there were already
> functions to do it.  I didn't see anything that would make
> manipulating the flattened form easy.
> 
> I agree that working on the unflattened form would be best.  At a
> minium the /proc/device-tree structure would better reflect reality.
> 
> What do you think about adding some helper functions to
> drivers/of/fdt.c for the manipulation of the flattened form?

It would probably be easier/safer to link libfdt into the kernel
proper.  It's already used in the powerpc bootwrapper, and there has
been talk about replacing some of fdt.c with libfdt.  See
scripts/dtc/libfdt

> 
> >or for the
> >kernel to have a separate .dtb linked in for each legacy platform.
> 
> I think there are too many variants to make this viable.

Out of curiosity, how many variants?

btw, did you know about the dtc '/include/' functionality?  It is
possible to set up .dts include files that represent a SoC and can be
modified by the .dts files that include them.  See
arch/powerpc/boot/dts/*5200*.dts

> 
> > I
> >need to think about this some more....
> >
> >I've made some comments below anyway.
> 
> And I will respond.  Although if I end up modifying the flattened
> form, it will all change.
> 
> >
> [...]
> >>+
> >>+static int __init set_phy_addr_prop(struct device_node *n, int phy)
> >>+{
> >>+	u32 *vp;
> >>+	struct property *old_p;
> >>+	struct property *p = kzalloc(sizeof(struct device_node) + sizeof(u32), GFP_KERNEL);
> >>+	if (!p)
> >>+		return -ENOMEM;
> >>+	/* The value will immediatly follow the node in memory. */
> >>+	vp = (u32 *)(&p[1]);
> >
> >This is unsafe (I was on the losing end of an argument when I tried to
> >do exactly the same thing).  If you want to allocate 2 things with one
> >appended to the other, then you need to define a structure
> >with the two element in it and allocate the size of that structure.
> 
> Weird.  alloc_netdev() does this, so it is not unheard of.

Not unheard of, but still bad practise.

> >>+	old_p = of_find_property(n, "reg", NULL);
> >>+	if (old_p)
> >>+		prom_remove_property(n, old_p);
> >>+	return prom_add_property(n, p);
> >
> >Would it not be more efficient to change the value in the existing reg
> >property instead of doing this allocation song-and-dance?
> >
> 
> I think I did it this way to try to get /proc/device-tree to reflect
> the new value.

Sounds like a bug in /proc/device-tree.  :-)  /proc/device-tree should
be pointing directly at the device tree property itself.  I'd be
surprised if modifying the data of 'reg' didn't show up there.

> >>+}
> >>+arch_initcall(octeon_fix_device_tree);
> >
> >Calling this from an initcall really makes me nervous.  I'm worried
> >about ordering issues.  Why can this code not be part of the prune
> >routine above?
> >
> 
> Again, done to try to make /proc/device-tree reflect reality.

yeah, /proc/device-tree should not be driving design decisions.  Let's
try to fix it instead.

g.

