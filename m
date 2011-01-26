Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1AZSmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:42:47 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35173 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1AZSmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:42:46 -0500
Date: Wed, 26 Jan 2011 12:40:57 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] zram/xvmalloc: free bit block insertion
 optimization
Message-ID: <20110126184057.GC17383@linux.vnet.ibm.com>
Mail-Followup-To: Pekka Enberg <penberg@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110126172148.GB8446@linux.vnet.ibm.com>
 <20110126172508.GF8446@linux.vnet.ibm.com>
 <AANLkTi=eM-e9KU0PedOcXqR8TEVeAuP8Vnna-pxO4pRU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTi=eM-e9KU0PedOcXqR8TEVeAuP8Vnna-pxO4pRU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg (penberg@kernel.org) wrote:
> On Wed, Jan 26, 2011 at 7:25 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> > There is no need to set the bits in the first- and second-level indices
> > to indicate a free page when we know that a free page existed at this
> > level.
> >
> > Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> 
> Why is it not necessary? I don't know that part of the code well
> enough to tell if this patch is safe or not.

This change is in a conditional block which is entered only when there is
an existing data block on the freelist where the insert has taken place.

The new block is pushed onto the freelist stack and this conditional block
is updating links in the prior stack head to point to the new stack head.
After this conditional block the first-/second-level indices are updated
to indicate that there is a free block at this location.

This patch adds an immediate return from the conditional block to avoid
setting bits again to indicate a free block on this freelist. They would
already be set because there was an existing free block on this freelist.

> > ---
> >  drivers/staging/zram/xvmalloc.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
> > index a507f95..b3622f1 100644
> > --- a/drivers/staging/zram/xvmalloc.c
> > +++ b/drivers/staging/zram/xvmalloc.c
> > @@ -205,6 +205,8 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
> >                nextblock->link.prev_page = page;
> >                nextblock->link.prev_offset = offset;
> >                put_ptr_atomic(nextblock, KM_USER1);
> > +               /* If there was a next page then the free bits are set. */
> > +               return;
> >        }
> >
> >        __set_bit(slindex % BITS_PER_LONG, &pool->slbitmap[flindex]);
