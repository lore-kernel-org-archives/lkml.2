Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2KICYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:24:51 -0500
Received: from ozlabs.org ([203.10.76.45]:44621 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980Ab2KICYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:24:50 -0500
Date: Fri, 9 Nov 2012 13:26:24 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
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
Message-ID: <20121109022624.GI23553@truffula.fritz.box>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 08:40:30PM +0000, Grant Likely wrote:
> Hey folks,
> 
> As promised, here is my early draft to try and capture what device
> tree overlays need to do and how to get there. Comments and
> suggestions greatly appreciated.
> 
> Device Tree Overlay Feature

Hrm.  So, you may yet convince me otherwise, but I'm really getting a
feeling of overengineering from this proposal so far.

> Purpose
> =======
> Sometimes it is not convenient to describe an entire system with a
> single FDT. For example, processor modules that are plugged into one or
> more modules (a la the BeagleBone), or systems with an FPGA peripheral
> that is programmed after the system is booted.
> 
> For these cases it is proposed to implement an overlay feature for the
> so that the initial device tree data can be modified by userspace at
> runtime by loading additional overlay FDTs that amend the original data.
> 
> User Stories
> ============

[snip]

The user stories mostly sound reasonable to me, but I don't know
enough about the hardware in question to know what they'll mean in
terms of what needs to be added to the base device tree.

> Summary points:
> - Create an FDT overlay data format and usage model
>   - SHALL reliable resolve or validate of phandles between base and
>     overlay trees

So, I'm not at all clear on what this proposed phandle validation
would involve.  I'm also not convinced it's as necessary as you
think, more on that below.

[snip - lots of technical stuff]

So, let me take a stab at this from a more bottom-up approach, and see
if we meet in the middle somewhere.  As I discussed in the other
thread with Daniel Mack, I can see two different operationso on the
fdt that might be useful in this context.  I think of them as "graft"
- which takes one fdt and adds it as a new subtree to an existing fdt
- and "overlay" where a new fdt adds or overrides arbitrary properties
in an existing tree.  Overlay is more or less what we do at the source
level in dtc already.

Overlay is obviously more general - you can add, change and possibly
delete any existing node or property.

Graft can only add new nodes and properties, not modify existing ones.
But that restriction comes with some advantages: reversing the
operation is just a matter of deleting the subtree with no extra
tracking info required.  It's simple to see how to have rules or
permissions about where subtrees can be grafted, and if the graft
point is identified by a label or id, rather than full path, it
automatically adapts to at least some changes in the base tree
structure.

I think graft is basically a safer operation, particular if we're
doing this at runtime with userspace passing in these fdt fragments.
In fact I'd go so far as to say if you really need the full overlay
functionality, then you really ought to be working at the bootloader
or early kernel load level to assemble the correct full device tree.
And as Mitch says, an existing programming language (C, OFW Forth or
whatever as you please) will serve you better for this sort of general
manipulation than a limited template system.

I also think graft will handle most of your use cases, although as I
said I don't fully understand the implications of some of them, so I
could be wrong.  So, the actual insertion of the subtree is pretty
trivial to implement.  phandles are the obvious other matter to be
dealt with.  I haven't found the right thread where what you've
envisaged so far is discussed, so here are things I can see:

1) Avoiding phandle collisions between main tree and subtree (or
   between subtrees).

I'm hopeful that this can be resolved just by establishing some
conventions about the ranges of phandles to be used for various
components.  I'd certainly be happy to add a directive to dtc which
enforces allocation of phandles within a specified range.

2) Resolving phandle references within a subtree

If we can handle (1) by convention, we don't need anything here, the
references are fine as is.

(3) Resolving phandle references from the subtree to the main tree.

So, I think this can actually be avoided, at least in cases where what
physical connections are available to the expansion module is well
defined.  The main causes to have external references are interrupts
and gpios.  Interrupts we handle by defining an interrupt specifier
space for the interrupts available on the expansion
socket/connector/bus/whatever.  In the master tree we then have
something like:

...
	expansion-socket@XXXX {
		expansion-id = "SlotA";
		interrupt-map = < /* map expansion irq specs to
				     board interrupt controllers */ >;
		interrupt-map-mask = < ... >;
		ranges = < /* map expansion local addresses to global
		              mmio */ >;
	};

The subtree for the expansion module gets attached as a subnode of
this one.  It doesn't use explicit interrupt-parents but instead just
uses the expansion local irq specifiers, letting the parent be the
default which will bubble up to this socket node where the
interrupt-map will send them to the right places.

I don't recall the gpio bindings off hand, but as I recall we based
them off the irq tree bindings so we ought to be able to do the same
thing for them.

Likewise, if there are several interchangeable expansion sockets that
have some address bits hard wired to distinguish them, we can just use
socket local mmio addresses within the subtree and the ranges property
here will sort that out.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
