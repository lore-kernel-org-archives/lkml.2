Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2KMHX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:23:56 -0500
Received: from ozlabs.org ([203.10.76.45]:34878 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2KMHXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:23:53 -0500
Date: Tue, 13 Nov 2012 18:25:17 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
Message-ID: <20121113072517.GE25915@truffula.fritz.box>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <50999145.2070306@wwwdotorg.org>
 <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com>
 <509D9089.7020407@wwwdotorg.org>
 <5B124797-6DFD-4C5E-90D7-665AFD4A7873@antoniou-consulting.com>
 <50A12950.6090808@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A12950.6090808@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 09:52:32AM -0700, Stephen Warren wrote:
> On 11/12/2012 05:10 AM, Pantelis Antoniou wrote:
[snip]
> > Oh yes. In fact if one was to use a single kernel image for beagleboard
> > and beaglebone, for the cape to work for both, it is required for it's
> > dtb to be compatible. 
> 
> Well, as Grant pointed out, it's not actually strictly necessary for the
> .dtb to be compatible; only the .dts /need/ be compatible, and the .dtb
> can be generated at run-time using dtc for example.

So, actually, I think a whole bunch of problems with phandle
resolution disappear if we don't try to define an overlay .dtb format,
or at least treat it only as a very shortlived object.  A more precise
proposal below.  Note that this works more or less equally well with
either the original overlay approach or the graft/graft-bundle
proposal I made elsewhere.

1) We annotate the base tree with some extra label information for
nodes which overlays are likely to want to reference by phandle.  e.g.

	beaglebone_pic: interrupt-controller@XXXXX {
		...
		phandle,symbolic-name = "beaglebone_pic";
	};

We could extend dtc to (optionally?) auto-generate those properties
from its existing label syntax.  Not sure if that's a good idea or
not yet.  In any case, we compile this augmented base tree to .dtb as
normal and boot our kernel with it.

2) The information for the capes/modules/whatever is
distributed/packaged as .dts, never .dtb.  When userspace detects the
new module (or the user explicitly tells it, if it's not probeable) it
picks up the correct dts and runs it through dtc in a special mode.
In this mode dtc takes the existing base tree (from /proc/device-tree,
say) as well as the new dts.  In this mode, dtc allocates phandles for
the new tree fragment so as not to collide with anything from the
supplied base tree (as well as avoiding internal conflicts,
obviously).  It also allows node references to the base tree by using
those label annotations from (1) to match symbolic names to the
phandle values in the base tree.

3) The resulting partial .dtb for the module is highly specific to the
base tree (which if the base tree was generated at runtime by firmware
could even be specific to a particular boot).  But that's ok, because
we just spit it into the kernel, absolute phandle values and all, then
throw it away.  Next time we need the module info, we recompile it
again.

> Of course, relying on .dts compatibility rather than .dtb compatibility
> might negatively impact the complexity of an initrd environment if we
> end up loading overlays from there...

Well, it does mean we'd need dtc in the initrd.  But dtc has no
library dependencies except libc, so that really shouldn't be too
bad.  In return we entirely avoid inventing a new phandle resolution
protocol.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
