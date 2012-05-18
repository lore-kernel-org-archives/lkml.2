Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031261Ab2ERXZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:25:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50231 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031249Ab2ERXZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:25:41 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
To: Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, linus.walleij@stericsson.com, linux-sh@vger.kernel.org,
        horms@verge.net.au, olof@lixom.net
In-Reply-To: <20120517004124.GA16069@linux-sh.org>
References: <20120515154333.6659.66479.sendpatchset@w520> <20120516072927.GN7988@linux-sh.org> <CANqRtoSSEb9jwEmvbhBuyHp-9BfUSRabQzqjrrVGTFDP-AHutQ@mail.gmail.com> <201205161209.03985.arnd@arndb.de> <20120517004124.GA16069@linux-sh.org>
Date: Fri, 18 May 2012 17:25:39 -0600
Message-Id: <20120518232539.82DC43E07C8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012 09:41:25 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, May 16, 2012 at 12:09:03PM +0000, Arnd Bergmann wrote:
> > On Wednesday 16 May 2012, Magnus Damm wrote:
> > > > irq_domain_add_legacy() exists for existing static ranges, which there is
> > > > really no reason to be adding in new board/platform support. You don't
> > > > have to worry about virq overlap since irq_create_mapping() already wraps
> > > > on top of irq_alloc_desc_xxx() for lookup.
> > > 
> > > So I intentionally made use of the legacy domain in the non-DT case.
> > > This because I want to let the SoC code set the static IRQ ranges via
> > > platform data.
> > 
> > I think it's generally better to use just one code path for both cases,
> > if you need both DT and non-DT support, which means you would always
> > use irq_domain_add_legacy. Once you have the final patch to convert it
> > to DT, you can remove the legacy domain and just convert it to linear.
> > 
> That's a bit short sighted. There are going to be plenty of cases where
> we can tie in IRQ domains and will make use of it both with and without
> DT, and there is very little cause for forcing manual irq_desc
> allocation/freeing up the chain when the IRQ domain code can handle it
> just fine.
> 
> The one area that I see being problematic with IRQ domains at the moment
> is IORESOURCE_IRQ. In the 'legacy' cases this maps out to the hwirq,
> while in the non-legacy cases it works out to a virq mapping that's
> lazily inserted by of_irq_to_resource_table() in of_device_alloc().

On a related note, I'd like to be rid of the registration-time
of_irq_to_resource_table() setup entirely and replace it with
something like a hook in platform_get_irq() to do a DT lookup when
possible.  Overall I think that will work better with irq controllers
in modules and deferred probe.

> In adding irq domain support for the sh intc subsystem I hacked up some
> prototype code for doing an in-place update of IORESOURCE_IRQ resources
> hanging off platform devices that does the hwirq->virq translation and it
> seems to work fine, albeit hacky, and something I would rather avoid. On
> the other hand, there's no need for that either if we support a 1:1 hwirq
> to virq mapping where possible, which is fairly easy to do by just trying
> to fetch a virq with irq_alloc_desc_at() before falling back on the
> existing virq hinting logic in irq_create_mapping().

That's exactly what the current irq_domain code does.  Search for
'hint' in the irqdomain code.  It just cannot be relied upon in any
way when there is more than once irq_domain depending on which one
maps it first.  Plus I'm planning to remove the 'hint' logic because I
think it just adds complexity that doesn't need to be there.

A big problem is I don't see a good place to hook into when drivers
ask for an irq number to be mapped so that the kernel knows when it
needs to allocate and remap an irq number.  request_irq() is a
possibility, but it doesn't have any knowledge of whether the irq
number it is passed is a 'core static' irq number that should be 1:1
mapped to a specific hwirq, or if it was a dynamically allocated virq
number that has already been mapped.  (or possibly a 1:1 number that
has been mapped by an earlier call).

hmmm...

Okay, how about this:

- get rid of the legacy map (I certainly won't cry to see it go)
- switch all legacy users to linear
- Add a new api to force-associate hwirqs and linux irqs... something like:
	irq_domain_associate(struct irq_domain *d, int irq_base,
			     int hwirq_base, int size)
  - This function will reserve irq numbers (without allocating irq_descs)
    for the given range.
- When mapping, if an irq has been reserved, then allocate only that
  irq_desc; otherwise do the normal irq_alloc_desc().
- In irq_request, if the irq_desc has not yet been allocated and
  mapped, then do so.

This does require a number of changes in the irq_desc layer though
which aren't particularly hard but I haven't wanted to do.

Alternately (or perhaps as a stepping stone) irq_domain_associate()
could actually allocate and map irq_descs for the given range.  It
isn't as memory efficient because unused irq_descs still get mapped,
but it is a whole lot simpler and easier to understand.

So, instead of irq controllers doing:
	if (dt)
		d = irq_domain_add_linear();
	else
		d = irq_domain_add_legacy();

They will do:
	d = irq_domain_add_linear();
	if (irq_base)
		irq_domain_associate(d, irq_base, ...);

Thoughts?

> We can easily or a
> flag in to the revmap type that denotes the 'static' nature of the domain
> to inhibit irq_alloc_desc_from() usage in domains with 1:1 mappings.
> 
> In any event, it looks like irq domains needs some more work for the
> non-DT case before it can really be useful. Creating arbitrary static
> mappings to shoe-horn a driver in to DT + non-DT shape through a legacy
> mapping seems pretty absurd, though.
> 
> I'll do some more hacking on it and see what I come up with, but I'm
> certainly not going to be maintaining my own radix tree on the side and
> wrapping in to a legacy domain for the sh intc case when all of the
> support infrastructure is already extant in the irqdomain code.

indeed!

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
