Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2ESUFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 16:05:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47599 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab2ESUFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 16:05:09 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
To: Paul Mundt <lethal@linux-sh.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        linus.walleij@stericsson.com, linux-sh@vger.kernel.org,
        horms@verge.net.au, olof@lixom.net
In-Reply-To: <20120519064606.GA32537@linux-sh.org>
References: <20120515154333.6659.66479.sendpatchset@w520> <20120516072927.GN7988@linux-sh.org> <CANqRtoSSEb9jwEmvbhBuyHp-9BfUSRabQzqjrrVGTFDP-AHutQ@mail.gmail.com> <201205161209.03985.arnd@arndb.de> <20120517004124.GA16069@linux-sh.org> <20120518232539.82DC43E07C8@localhost> <20120519064606.GA32537@linux-sh.org>
Date: Sat, 19 May 2012 14:05:06 -0600
Message-Id: <20120519200506.A3B723E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 15:46:07 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> On Fri, May 18, 2012 at 05:25:39PM -0600, Grant Likely wrote:
> > On Thu, 17 May 2012 09:41:25 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> > > In adding irq domain support for the sh intc subsystem I hacked up some
> > > prototype code for doing an in-place update of IORESOURCE_IRQ resources
> > > hanging off platform devices that does the hwirq->virq translation and it
> > > seems to work fine, albeit hacky, and something I would rather avoid. On
> > > the other hand, there's no need for that either if we support a 1:1 hwirq
> > > to virq mapping where possible, which is fairly easy to do by just trying
> > > to fetch a virq with irq_alloc_desc_at() before falling back on the
> > > existing virq hinting logic in irq_create_mapping().
> > 
> > That's exactly what the current irq_domain code does.  Search for
> > 'hint' in the irqdomain code.  It just cannot be relied upon in any
> > way when there is more than once irq_domain depending on which one
> > maps it first.  Plus I'm planning to remove the 'hint' logic because I
> > think it just adds complexity that doesn't need to be there.
> > 
> There's a subtle functionality difference that the irqdomain code fails
> to account for at present, which is the difference between the old
> dynamic IRQ API (create_irq()/create_irq_nr() -- and no, not the stupid
> signed vs unsigned thing). irq_alloc_desc_at() allocates at a fixed
> position within the bitmap, and only at that position. If we're unable to
> get the mapping we want, it's an error. irq_alloc_desc_from() simply uses
> the hwirq as a hint for where to start looking, and will quite happily
> hand you back whatever it finds. At present we have no way to tell the
> irqdomain code to allocate a specific virq, which is what we're going to
> need for converting static mappings over.
> 
> I do agree that getting rid of the hinting logic is a good idea though.
> On SH we actually do our hinting the opposite, where we first populate
> the IRQ map with all of our static hardware mappings, and then scan from
> the beginning to find holes for when we need dynamic IRQs. This gives us
> a pretty tightly packed IRQ map, which helps with lookup times, radix
> tree utilization, and nr_irqs expansion for sparseirq (which we use
> unconditionally on all sh + sh/r-mobile arm platforms).
> 
> > - get rid of the legacy map (I certainly won't cry to see it go)
> > - switch all legacy users to linear
> 
> While this is a good direction to go, it's also important to keep in mind
> that not all legacy users will have linear maps (though perhaps out of
> the existing users it's one or the other). I've added a couple of API
> calls to help with inserting extant mappings and establishing identity
> mappings that should permit legacy users to adopt whatever mapping model
> works the best for them.

Mostly I'm thinking about simplification of the code.  I think
irq_domain is a little too complex.  I would like to be able to
simplify things my making the legacy map just a linear map that is
pre-populated.  The majority of linear users seem to be in the 32-64
num_irqs range so I'm not concerned about wasting memory by allocating
a map for legacy users (and dropping the legacy mapping code reduced
.text by ~660 bytes in my test compile).  :-)

> 
> Once the semantics have been agreed upon we can begin converting the
> existing users before the _legacy proliferation gets too far along.
> 
> > - Add a new api to force-associate hwirqs and linux irqs... something like:
> > 	irq_domain_associate(struct irq_domain *d, int irq_base,
> > 			     int hwirq_base, int size)
> >   - This function will reserve irq numbers (without allocating irq_descs)
> >     for the given range.
> 
> There's already an irq_reserve_irq{s,}() that can be used to inhibit
> accidental mapping. We use this in the SH INTC case to ensure that all of
> the possible hardware vectors are reserved before we permit dynamic IRQ
> allocation throughout the remaining space (we have a flat vector space
> where both static and dynamic mappings co-exist -- I plan to maintain
> this behaviour in converting to IRQ domains, which should also make it
> easy for DT/non-DT stuff to co-exist in the same vector space).

Yes, I was looking at irq_reserve_irqs() and thinking about how best
to fit it into irq_domain.  I would like to be able to defer
allocation of irq_descs in the legacy or reserved use cases, but I'm
not sure the best way to do it.  Baby steps I guess.  Start with
making it work with reserved irq_descs and worry about lazy allocation
later.

> I've generalized irq_setup_virq() as irq_domain_associate() in order to
> allow direct insertion of existing IRQs while still allowing the domain
> to do whatever it likes with the mapping in its ->map() (ie, revmap
> insertion).
> 
> > - When mapping, if an irq has been reserved, then allocate only that
> >   irq_desc; otherwise do the normal irq_alloc_desc().
> 
> This seems likely to duplicate state. We have no way to determine what
> caused an IRQ to be reserved in the bitmap, or to test for reserved vs
> normally allocated ones. I think we can avoid the need for this by simply
> splitting in to irq_alloc_desc_at() for static and maintaining
> irq_alloc_desc_from() for dynamic.
> 
> > - In irq_request, if the irq_desc has not yet been allocated and
> >   mapped, then do so.
> > 
> > This does require a number of changes in the irq_desc layer though
> > which aren't particularly hard but I haven't wanted to do.
> > 
> > Alternately (or perhaps as a stepping stone) irq_domain_associate()
> > could actually allocate and map irq_descs for the given range.  It
> > isn't as memory efficient because unused irq_descs still get mapped,
> > but it is a whole lot simpler and easier to understand.
> > 
> That's possible as well. I've taken a slightly different approach with my
> patches that leave the irqdesc behaviour alone, but I'm not sure how well
> it will mesh with the DT model.

I've looked at your patches I think it is still pretty similar to what
I'm suggesting above.  Just the API needs to be quibbled over I think

g.


-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
