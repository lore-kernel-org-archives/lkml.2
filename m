Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0GFCRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:17:39 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:52233 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab0GFCRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:17:38 -0400
Date: Wed, 7 Jul 2010 04:07:34 +0000
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code  out into drivers/of
Message-ID: <20100707040734.05d625af@debxo>
In-Reply-To: <AANLkTilme2uAoXjorUEzam9j_xosR8kl70W8PS71d-Th@mail.gmail.com>
References: <20100628215407.2017bf2f@debian>
	<20100628220037.5744c207@debian>
	<AANLkTilN3_ntG7AWKi-8LM9X_dZJPPlWM6xRM_V_00xU@mail.gmail.com>
	<20100629110324.2756cc02@debian>
	<AANLkTinPsrqxj5oQirEDRvVOuOeWgWSdljsMRbw8wn8V@mail.gmail.com>
	<20100629193618.5a840b8e@dev.queued.net>
	<AANLkTilme2uAoXjorUEzam9j_xosR8kl70W8PS71d-Th@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 15:52:51 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Tue, Jun 29, 2010 at 5:36 PM, Andres Salomon <dilinger@queued.net>
> wrote:
> > On Tue, 29 Jun 2010 15:42:54 -0600
> > Grant Likely <grant.likely@secretlab.ca> wrote:
> >
> >> On Tue, Jun 29, 2010 at 9:03 AM, Andres Salomon
> >> <dilinger@queued.net> wrote:
> > [...]
> >>
> >> >  Sparc and OLPC have very similar
> >> > mechanisms for getting device tree info from OFW, so it makes
> >> > sense to share code between them.
> >>
> >> Other than the flattened tree step; is the powerpc method
> >> dissimilar from the Sparc and OLPC method for talking to OFW?
> >>  (This is not a rhetorical question, I'm want to know if I'm
> >> missing some details). The main difference I know about is that
> >> OFW can still kept alive at runtime for sparc, which powerpc does
> >> not do.  However, keeping OFW callable is a separate issue from
> >> how to extract the device tree.
> >>
> >
> > After having a look at powerpc's flatten_device_tree, I don't see
> > any obvious reason why OLPC couldn't use this
> 
> Okay.
> 
> >(though it still strikes me
> > as weird to go from prom->fdt->dt when the option of prom->dt is
> > available and less complex).
> 
> Which is why I didn't simply NACK it out of hand.  It is a valid
> point.
> 
> I'd probably be happier if both fdt and pdt used a shared set of
> utility functions for allocating and tying together the device_node
> data structures.  Then at least there would be only one instance of
> code to deal with the fiddly data structure interconnections.

The problem with unifying it is that both methods have different
assumptions; the fdt determines the size of the unflattened dt in
advance, and allocates a contiguous block of memory up front (the
memory block being smaller than the pdt memory usage because various
strings are already present in the fdt, so the unflattened tree simply
points at those strings).  The pdt, otoh, allocates more memory as the
tree is discovered (by calling into the prom).

Possible options include:

 - For the pdt, calling into the prom twice for each property/node,
   getting the size of everything during the first tree traversal,
   allocating memory, and then creating the tree during the second
   traversal. This is slow and I don't see much point to it.

 - For the pdt, calling into the prom once for each property/node to
   create a fdt, and then unflattening it.  This is better than the
   previous option, but I don't think the prom->fdt code will be very
   nice.

 - Changing the fdt code to allocate memory more dynamically; rather
   than a first run through the fdt to determine the unflattened tree
   size, simply allocate memory chunks as we run through the tree.
   Memory might still be backed the same way (calling
   early_init_dt_alloc_memory_arch to grab a chunk of memory, and then
   allocating chunks of it via unflatten_dt_alloc), but the difference
   would be that it wouldn't necessarily be contiguous, and in how it's
   done.  For example, early_init_dt_alloc_memory_arch might be called
   initially to allocate a 16k chunk, and once unflatten_dt_alloc runs
   out of memory in that chunk, another 16k chunk might be allocated.
   This would also translate to sparc's prom_early_alloc being used to
   allocate the chunk, and then node/property structs being
   allocated from those chunks.  (The 16k choice
   is completely arbitrary; people more familiar w/ the early memory
   setup of ppc/sparc might have a better suggestion)

That last option is what I think makes the most sense; however, are
there technical reasons (other than how unflatten_device_tree is
written) that the unflattened dt must be in a contiguous memory
region?  The chunk allocation code would be backed by things like
__alloc_bootmem and lmb_alloc, and the dt_alloc code would be new code
that simply tracks the amount remaining in a list of chunks, and
allocates a new chunk if necessary.


> 
> The nice thing about the powerpc version is that the tree can be
> extracted really early in the boot process, before any of the core
> kernel infrastructure or memory management is initialized.
> 
