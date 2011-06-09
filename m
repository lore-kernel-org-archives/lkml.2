Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1FIQos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:44:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248Ab1FIQoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:44:44 -0400
Date: Thu, 9 Jun 2011 09:45:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, kamezawa.hiroyu@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, Joe Perches <joe@perches.com>
Subject: Re: [slubllv7 05/17] mm: Rearrange struct page
Message-Id: <20110609094526.1571774c.akpm@linux-foundation.org>
In-Reply-To: <4DF0991E.6060907@cs.helsinki.fi>
References: <20110601172543.437240675@linux.com>
	<20110601172614.725685218@linux.com>
	<4DF0991E.6060907@cs.helsinki.fi>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jun 2011 12:57:50 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On 6/1/11 8:25 PM, Christoph Lameter wrote:
> > We need to be able to use cmpxchg_double on the freelist and object count
> > field in struct page. Rearrange the fields in struct page according to
> > doubleword entities so that the freelist pointer comes before the counters.
> > Do the rearranging with a future in mind where we use more doubleword
> > atomics to avoid locking of updates to flags/mapping or lru pointers.
> >
> > Create another union to allow access to counters in struct page as a
> > single unsigned long value.
> >
> > The doublewords must be properly aligned for cmpxchg_double to work.
> > Sadly this increases the size of page struct by one word on some architectures.
> > But as a resultpage structs are now cacheline aligned on x86_64.

Is it worth this cost?

> > Signed-off-by: Christoph Lameter<cl@linux.com>
> 
> I'd like to queue this SLUB patch series to linux-next through slab.git. 
> Any NAKs or ACKs for this patch?
> 
> >   include/linux/mm_types.h |   89 +++++++++++++++++++++++++++++++----------------
> >   1 file changed, 60 insertions(+), 29 deletions(-)
> >
> > Index: linux-2.6/include/linux/mm_types.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/mm_types.h	2011-05-31 09:46:41.912987862 -0500
> > +++ linux-2.6/include/linux/mm_types.h	2011-05-31 09:46:44.282987846 -0500
> > @@ -30,52 +30,74 @@ struct address_space;
> >    * moment. Note that we have no way to track which tasks are using
> >    * a page, though if it is a pagecache page, rmap structures can tell us
> >    * who is mapping it.
> > + *
> > + * The objects in struct page are organized in double word blocks in
> > + * order to allows us to use atomic double word operations on portions
> > + * of struct page. That is currently only used by slub but the arrangement
> > + * allows the use of atomic double word operations on the flags/mapping
> > + * and lru list pointers also.

I don't really like the word "word" much.  There's always uncertainty
about whether thee and me are talking about the same thing.  And
perhaps one day words will be 64-bit.

So if we mean 32-bit, let's say 32-bit?

> > +/*
> > + * If another subsystem starts using the double word pairing for atomic
> > + * operations on struct page then it must change the #if to ensure
> > + * proper alignment of the page struct.
> > + */
> > +#if defined(CONFIG_SLUB)&&  defined(CONFIG_CMPXCHG_LOCAL)
> > +	__attribute__((__aligned__(2*sizeof(unsigned long))))
> > +#endif

I guess we need a "hey, use __aligned" checkpatch rule.
