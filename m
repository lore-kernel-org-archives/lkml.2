Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120Ab2EQAl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:41:56 -0400
Received: from linux-sh.org ([111.68.239.195]:46019 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab2EQAly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:41:54 -0400
Date: Thu, 17 May 2012 09:41:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, linus.walleij@stericsson.com, linux-sh@vger.kernel.org,
        horms@verge.net.au, grant.likely@secretlab.ca, olof@lixom.net
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver V2
Message-ID: <20120517004124.GA16069@linux-sh.org>
References: <20120515154333.6659.66479.sendpatchset@w520>
 <20120516072927.GN7988@linux-sh.org>
 <CANqRtoSSEb9jwEmvbhBuyHp-9BfUSRabQzqjrrVGTFDP-AHutQ@mail.gmail.com>
 <201205161209.03985.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205161209.03985.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:09:03PM +0000, Arnd Bergmann wrote:
> On Wednesday 16 May 2012, Magnus Damm wrote:
> > > irq_domain_add_legacy() exists for existing static ranges, which there is
> > > really no reason to be adding in new board/platform support. You don't
> > > have to worry about virq overlap since irq_create_mapping() already wraps
> > > on top of irq_alloc_desc_xxx() for lookup.
> > 
> > So I intentionally made use of the legacy domain in the non-DT case.
> > This because I want to let the SoC code set the static IRQ ranges via
> > platform data.
> 
> I think it's generally better to use just one code path for both cases,
> if you need both DT and non-DT support, which means you would always
> use irq_domain_add_legacy. Once you have the final patch to convert it
> to DT, you can remove the legacy domain and just convert it to linear.
> 
That's a bit short sighted. There are going to be plenty of cases where
we can tie in IRQ domains and will make use of it both with and without
DT, and there is very little cause for forcing manual irq_desc
allocation/freeing up the chain when the IRQ domain code can handle it
just fine.

The one area that I see being problematic with IRQ domains at the moment
is IORESOURCE_IRQ. In the 'legacy' cases this maps out to the hwirq,
while in the non-legacy cases it works out to a virq mapping that's
lazily inserted by of_irq_to_resource_table() in of_device_alloc().

In adding irq domain support for the sh intc subsystem I hacked up some
prototype code for doing an in-place update of IORESOURCE_IRQ resources
hanging off platform devices that does the hwirq->virq translation and it
seems to work fine, albeit hacky, and something I would rather avoid. On
the other hand, there's no need for that either if we support a 1:1 hwirq
to virq mapping where possible, which is fairly easy to do by just trying
to fetch a virq with irq_alloc_desc_at() before falling back on the
existing virq hinting logic in irq_create_mapping(). We can easily or a
flag in to the revmap type that denotes the 'static' nature of the domain
to inhibit irq_alloc_desc_from() usage in domains with 1:1 mappings.

In any event, it looks like irq domains needs some more work for the
non-DT case before it can really be useful. Creating arbitrary static
mappings to shoe-horn a driver in to DT + non-DT shape through a legacy
mapping seems pretty absurd, though.

I'll do some more hacking on it and see what I come up with, but I'm
certainly not going to be maintaining my own radix tree on the side and
wrapping in to a legacy domain for the sh intc case when all of the
support infrastructure is already extant in the irqdomain code.
