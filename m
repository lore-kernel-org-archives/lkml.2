Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2KMAav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 19:30:51 -0500
Received: from ozlabs.org ([203.10.76.45]:42858 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab2KMAat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 19:30:49 -0500
Date: Tue, 13 Nov 2012 11:03:41 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
Message-ID: <20121113000341.GO4696@truffula.fritz.box>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <20121109022624.GI23553@truffula.fritz.box>
 <A97699E9-6C57-4A56-BC45-86A57CF2496F@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A97699E9-6C57-4A56-BC45-86A57CF2496F@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 04:40:15PM +0100, Pantelis Antoniou wrote:
> Hi David,

[snip]
> > I think graft is basically a safer operation, particular if we're
> > doing this at runtime with userspace passing in these fdt fragments.
> > In fact I'd go so far as to say if you really need the full overlay
> > functionality, then you really ought to be working at the bootloader
> > or early kernel load level to assemble the correct full device tree.
> > And as Mitch says, an existing programming language (C, OFW Forth or
> > whatever as you please) will serve you better for this sort of general
> > manipulation than a limited template system.
> > 
> > I also think graft will handle most of your use cases, although as I
> > said I don't fully understand the implications of some of them, so I
> > could be wrong.  So, the actual insertion of the subtree is pretty
> > trivial to implement.  phandles are the obvious other matter to be
> > dealt with.  I haven't found the right thread where what you've
> > envisaged so far is discussed, so here are things I can see:
> > 
> 
> An overlay is more generic and can handle more complex cases.
> For our use case, a graft should work - with a few caveats.

Obviously an overlay is more generic.  But the ability to arbitrarily
modify existing tree nodes, without any obvious way to enforce rules
about what can be altered and what can't frankly gives me the
heebie-jeebies.

> Due to the insertion/removal of the DT fragments other node's state
> change from 'disabled' <-> 'okay' and platform devices created or
> removed. This can be handled either via overlays, or via special
> casing it.

Ah, yes, the status transition is a good point.

[snip]
> > 1) Avoiding phandle collisions between main tree and subtree (or
> >   between subtrees).
> > 
> > I'm hopeful that this can be resolved just by establishing some
> > conventions about the ranges of phandles to be used for various
> > components.  I'd certainly be happy to add a directive to dtc which
> > enforces allocation of phandles within a specified range.
> > 
> 
> Really doubtful IMHO. That will impose yet more structure on the DT
> syntax, and it will make it even more difficult for users.

Um.. I really don't see what's so hard about adding an incantation
like:
	/phandle-range/ 1-0xffff;
at the top of your base dts.  Then
	/phandle-range/ 0x10000-0x1ffff;
to the plugin dts.

Especially if we made the most common base range the default.

> We're talking about users that do understand the hardware, but can't
> really grok linux kernel development.
> 
> DT is used a structured h/w definition and seems to work just
> fine for these kind of users.
> 
> > 2) Resolving phandle references within a subtree
> > 
> > If we can handle (1) by convention, we don't need anything here, the
> > references are fine as is.
> > 
> > (3) Resolving phandle references from the subtree to the main tree.
> > 
> > So, I think this can actually be avoided, at least in cases where what
> > physical connections are available to the expansion module is well
> > defined.  The main causes to have external references are interrupts
> > and gpios.  Interrupts we handle by defining an interrupt specifier
> > space for the interrupts available on the expansion
> > socket/connector/bus/whatever.  In the master tree we then have
> > something like:
> > 
> > ...
> > 	expansion-socket@XXXX {
> > 		expansion-id = "SlotA";
> > 		interrupt-map = < /* map expansion irq specs to
> > 				     board interrupt controllers */ >;
> > 		interrupt-map-mask = < ... >;
> > 		ranges = < /* map expansion local addresses to global
> > 		              mmio */ >;
> > 	};
> > 
> > The subtree for the expansion module gets attached as a subnode of
> > this one.  It doesn't use explicit interrupt-parents but instead just
> > uses the expansion local irq specifiers, letting the parent be the
> > default which will bubble up to this socket node where the
> > interrupt-map will send them to the right places.
> > 
> > I don't recall the gpio bindings off hand, but as I recall we based
> > them off the irq tree bindings so we ought to be able to do the same
> > thing for them.
> 
> Please, don't try to do it this way. It is very debatable that we'll 
> identify all the types that will need special handling.
> For example for our cape use, we already have references that do not
> follow this example.
> 
> A generic way to resolve references is what we need.

Hrm... *mutters dubiously*.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
