Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2KIVnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:43:01 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42968 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2KIVm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:42:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121109022624.GI23553@truffula.fritz.box>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <20121109022624.GI23553@truffula.fritz.box>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 21:42:37 +0000
X-Google-Sender-Auth: 5Lyv4kDjS_yt3QfCpwXDnxAZygc
Message-ID: <CACxGe6vQ50aS0Fe7QvTHKfV=EDpsZoLC7SOxXLGc0pkMvyk5DQ@mail.gmail.com>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
To: David Gibson <david@gibson.dropbear.id.au>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 2:26 AM, David Gibson
<david@gibson.dropbear.id.au> wrote:
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
>         expansion-socket@XXXX {
>                 expansion-id = "SlotA";
>                 interrupt-map = < /* map expansion irq specs to
>                                      board interrupt controllers */ >;
>                 interrupt-map-mask = < ... >;
>                 ranges = < /* map expansion local addresses to global
>                               mmio */ >;
>         };
>
> The subtree for the expansion module gets attached as a subnode of
> this one.  It doesn't use explicit interrupt-parents but instead just
> uses the expansion local irq specifiers, letting the parent be the
> default which will bubble up to this socket node where the
> interrupt-map will send them to the right places.
>
> I don't recall the gpio bindings off hand, but as I recall we based
> them off the irq tree bindings so we ought to be able to do the same
> thing for them.
>
> Likewise, if there are several interchangeable expansion sockets that
> have some address bits hard wired to distinguish them, we can just use
> socket local mmio addresses within the subtree and the ranges property
> here will sort that out.

If I'm reading correctly, the suggestion is that everything be grafted
below a single node and all connections route through that node using
mapping. Correct?

For interrupts that works today
For gpios, it isn't currently supported, but we could do it.
For SPI it would mean that the new spi devices would not appear below
the actual spi bus they are attached to
For I2C, MDIO, and one wire, same problem.
For memory mapped devices, the expansion node would need to a ranges
for all the windows that map through it, and it assumes only one
memory mapped bus (or at least it prefers only one memory mapped bus.
If there were more than one then the expansion node placement wouldn't
have a natural place to sit)

The problem is that this is not like a PCI bus where there is only one
kind of interface. It is a whole bunch of interfaces that happen to be
grouped together loosely (as an expansion connector in the beaglebone
case, but expansion isn't the only problem that I'm hearing about).

So, with a group of i2c, spi, memory mapped and other devices than are
all plugged in together, how does that look? They really should not
sit on the same level. An spi device cannot be a peer of an i2c device
for instance, the address mapping is entirely different. The kernel
really wants i2c devices to be a child of the actual i2c bus which may
already have an i2c device or too on the main board. Does the
expansion node need to have some kind of redirect node for each of the
busses where the children of it need to create devices as children of
the master bus?

To me that seems to get really complex in a hurry. More complex than
the overlay approach.

g.
