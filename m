Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab0G1FUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 01:20:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:39371 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0G1FUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 01:20:06 -0400
Subject: Re: [PATCH 28/31] memblock: Export MEMBLOCK_ERROR again
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1280294128.1970.237.camel@pasglop>
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
	 <1279822864-17154-29-git-send-email-yinghai@kernel.org>
	 <1280294128.1970.237.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 15:19:36 +1000
Message-ID: <1280294376.1970.239.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 15:15 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2010-07-22 at 11:21 -0700, Yinghai Lu wrote:
> > will used by x86 memblock_x86_find_in_range_node and nobootmem replacement
> > 
> > -v2: use 0 instead -1ULL, Suggested by Linus, so we don't need cast them later to unsigned long
> 
> The patch in its current form is a NAK.
> 
> You can't just do those two things in one commit.
> 
> If we're going to switch LMB errors to always be 0, we need to ensure we
> cannot realistically hand out 0 as a result of lmb_alloc().
> 
> I'll cook up a patch to do that.

Screw it, I don't like it but I'll just split your patch in two for now
and keep 0. It's a bit fishy but memblock does mostly top-down
allocations and so shouldn't hit 0, and in practice the region at 0 is,
I beleive, reserved, but we need to be extra careful and might need to
revisit that a bit.

That's an area where I don't completely agree with Linus, ie, 0 is a
perfectly valid physical address for memblock to return :-)

Cheers,
Ben.

> Ben.
> 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > ---
> >  include/linux/memblock.h |    1 +
> >  mm/memblock.c            |    2 --
> >  2 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > index 70bc467..89749c4 100644
> > --- a/include/linux/memblock.h
> > +++ b/include/linux/memblock.h
> > @@ -19,6 +19,7 @@
> >  #include <asm/memblock.h>
> >  
> >  #define INIT_MEMBLOCK_REGIONS 128
> > +#define MEMBLOCK_ERROR		0
> >  
> >  struct memblock_region {
> >  	phys_addr_t base;
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 796ef8c..3d0a754 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -27,8 +27,6 @@ int memblock_can_resize;
> >  static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS + 1];
> >  struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS + 1];
> >  
> > -#define MEMBLOCK_ERROR	(~(phys_addr_t)0)
> > -
> >  /* inline so we don't get a warning when pr_debug is compiled out */
> >  static inline const char *memblock_type_name(struct memblock_type *type)
> >  {
> 


