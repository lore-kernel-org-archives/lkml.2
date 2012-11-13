Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2KMBGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:06:14 -0500
Received: from ozlabs.org ([203.10.76.45]:53981 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab2KMBGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:06:12 -0500
Date: Tue, 13 Nov 2012 12:05:05 +1100
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
Message-ID: <20121113010505.GR4696@truffula.fritz.box>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <20121109022624.GI23553@truffula.fritz.box>
 <CACxGe6vQ50aS0Fe7QvTHKfV=EDpsZoLC7SOxXLGc0pkMvyk5DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6vQ50aS0Fe7QvTHKfV=EDpsZoLC7SOxXLGc0pkMvyk5DQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 09:42:37PM +0000, Grant Likely wrote:
> On Fri, Nov 9, 2012 at 2:26 AM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
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
> >         expansion-socket@XXXX {
> >                 expansion-id = "SlotA";
> >                 interrupt-map = < /* map expansion irq specs to
> >                                      board interrupt controllers */ >;
> >                 interrupt-map-mask = < ... >;
> >                 ranges = < /* map expansion local addresses to global
> >                               mmio */ >;
> >         };
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
> >
> > Likewise, if there are several interchangeable expansion sockets that
> > have some address bits hard wired to distinguish them, we can just use
> > socket local mmio addresses within the subtree and the ranges property
> > here will sort that out.
> 
> If I'm reading correctly, the suggestion is that everything be grafted
> below a single node and all connections route through that node using
> mapping. Correct?
> 
> For interrupts that works today
> For gpios, it isn't currently supported, but we could do it.
> For SPI it would mean that the new spi devices would not appear below
> the actual spi bus they are attached to
> For I2C, MDIO, and one wire, same problem.
> For memory mapped devices, the expansion node would need to a ranges
> for all the windows that map through it, and it assumes only one
> memory mapped bus (or at least it prefers only one memory mapped bus.
> If there were more than one then the expansion node placement wouldn't
> have a natural place to sit)
> 
> The problem is that this is not like a PCI bus where there is only one
> kind of interface. It is a whole bunch of interfaces that happen to be
> grouped together loosely (as an expansion connector in the beaglebone
> case, but expansion isn't the only problem that I'm hearing about).
> 
> So, with a group of i2c, spi, memory mapped and other devices than are
> all plugged in together, how does that look? They really should not
> sit on the same level. An spi device cannot be a peer of an i2c device
> for instance, the address mapping is entirely different. The kernel
> really wants i2c devices to be a child of the actual i2c bus which may
> already have an i2c device or too on the main board. Does the
> expansion node need to have some kind of redirect node for each of the
> busses where the children of it need to create devices as children of
> the master bus?
> 
> To me that seems to get really complex in a hurry. More complex than
> the overlay approach.

Ah, yes, I see.  Yeah, that's a genuine showstopper for my original
proposal.  Ok, let me offer a couple of counter-proposals:

1) bus-ranges

The notion of bus-reg and bus-ranges properties is something I've
toyed with before for other reasons, as a way of augmenting the
"normal" DT tree structure with interrupt-tree like DAG sections.
bus-reg and bus-ranges would act like the normal reg and ranges
properties except that each entry includes a phandle explicitly giving
the parent bus.  In that case a suitable 'bus-ranges' in the socket
node would resurrect my graft proposal.

I'm not particularly sold on this idea, but I mention it because it
has applications other than this one.  In particular it would mean we
could avoid having two different nodes for a device which is mostly
accessed via MMIO but also has a few sideband registers controlled by
i2c (or whatever).

2) graft bundle

The base tree has something like this:

	...
	i2c@XXX {
		...
		cape-socket {
			compatible = "vendor,cape-socket";
			id = "Socket-A";
			piece-id = "i2c";
			ranges = < ... >;
		};
	};
	...
	spi@YYY {
		...
		cape-socket {
			compatible = "vendor,cape-socket";
			id = "Socket-A";
			piece-id = "spi";
			ranges = < ... >;
		};
	};
	...
	cape-socket {
		compatible = "vendor,cape-socket";
		id = "Socket-A";
		piece-id = "misc";
		interrupt-map = < ... >;
		interrupt-map-mask = < ... >;
		gpio-map = < ... >;
		gpio-map-mask = < ... >;
	};

Then instead of grafting a single subtree for the socket, we install a
"bundle" of subtrees, one each for each of the pieces within the
socket.  That bundle could either be an actual set of multiple fdts,
or they could be placed into one fdt with a dummy root node, something like:
	/ {
		plugin-bundle;
		compatible = "vendor,cape-plugin";
		version = ...;
		i2c-piece = {
			piece-id = "i2c";
			...
		};
		misc-piece = {
			piece-id = "misc";
			...
		};
	};
That does have the additional advantage of letting us easily expand
the metadata in the future by adding more properties to the dummy root
node.

It's a bit more complex than the overlay proposal, but I think it's
safer - because the base tree clearly defines where it can be
extended.  Plus it has the big advantage that it's no longer dependent
on the exact node paths in the base tree, the matching for each
component is done by the piece-id or other metadata.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
