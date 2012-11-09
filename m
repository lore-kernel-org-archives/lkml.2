Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2KIW5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:57:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52939 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2KIW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:57:43 -0500
Message-ID: <509D8A62.1080102@wwwdotorg.org>
Date: Fri, 09 Nov 2012 15:57:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <20121109022624.GI23553@truffula.fritz.box>
In-Reply-To: <20121109022624.GI23553@truffula.fritz.box>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 07:26 PM, David Gibson wrote:
...
> I also think graft will handle most of your use cases, although as I
> said I don't fully understand the implications of some of them, so I
> could be wrong.  So, the actual insertion of the subtree is pretty
> trivial to implement.  phandles are the obvious other matter to be
> dealt with.  I haven't found the right thread where what you've
> envisaged so far is discussed, so here are things I can see:
> 
> 1) Avoiding phandle collisions between main tree and subtree (or
>    between subtrees).
> 
> I'm hopeful that this can be resolved just by establishing some
> conventions about the ranges of phandles to be used for various
> components.  I'd certainly be happy to add a directive to dtc which
> enforces allocation of phandles within a specified range.

One case I wonder about is:

Base board A that's split into two .dts files e.g. due to there being
two versions of the base board which are 90% identical, yet there being
a few differences between them.

Base board B that's just a single .dts file.

We might allocate phandle range 0..999 for the base board.

Child board X plugs into either, so the two base boards need to "export"
the same set of phandle IDs to the child board to allow it to reference
them.

If base board A version 2 comes along after the phandle IDs that the
child board uses are defined, then how do we handle assigning a specific
phandle ID range to each of base board A's two version-specific
overlays, when the version-specific changes might affect arbitrary
phandle IDs within the range, and require some to be moved into the base
board version-specific overlays and some to stay in the common base
board .dts?

> 2) Resolving phandle references within a subtree
> 
> If we can handle (1) by convention, we don't need anything here, the
> references are fine as is.
> 
> (3) Resolving phandle references from the subtree to the main tree.
> 
> So, I think this can actually be avoided, at least in cases where what
> physical connections are available to the expansion module is well
> defined.  The main causes to have external references are interrupts
> and gpios.  Interrupts we handle by defining an interrupt specifier
> space for the interrupts available on the expansion
> socket/connector/bus/whatever.  In the master tree we then have
> something like:
> 
> ...
> 	expansion-socket@XXXX {
> 		expansion-id = "SlotA";
> 		interrupt-map = < /* map expansion irq specs to
> 				     board interrupt controllers */ >;
> 		interrupt-map-mask = < ... >;
> 		ranges = < /* map expansion local addresses to global
> 		              mmio */ >;
> 	};

We would end up needing an interrupt-map or ranges type of property for
basically any resource type.

For example, what about an I2C bus that's routed to the daughter board,
and the daughter board contains an I2C bus mux, whose control path isn't
through I2C but rather GPIOs? In this case, the I2C bus mux isn't a
child of the I2C bus, but a separate entity that indicates its parent
I2C bus using a phandle. I presume a similar argument applies to almost
any kind of resource. This is probably do-able, but certainly something
to consider with the socket approach. I do like the socket approach though.
