Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2EWFVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:21:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40065 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2EWFU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:20:59 -0400
Date: Tue, 22 May 2012 22:20:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Message-ID: <20120523052054.GB29976@dhcp-172-17-108-109.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
 <20120522221259.GJ14339@google.com>
 <20120523034546.GB607@dhcp-172-18-216-138.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523034546.GB607@dhcp-172-18-216-138.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 22, 2012 at 11:45:49PM -0400, Kent Overstreet wrote:
> > What does the '8' mean?  And why does struct bbio use 3 instead?  Does
> > this have to be a macro?  Can't we have struct bkey_padded (or
> > whatever)?
> 
> Struct bbio uses 3 because it only ever carries around a single pointer
> (i.e. the pointer it's doing io to/from). I'll document that.
> 
> The 8 here is kind of arbitrary, it should be a constant defined
> somewhere - it's just a nice round number so it doesn't overflow, means
> it can fit 6 pointers.
> 
> It's a macro because it's used for embedding them in various structs -
> that way the pad can be in an anonymous union. Doesn't work the way
> you'd want for bkey_paddeds that are declared on the stack - I never
> found a solution I liked.

Hmmm... I would prefer it to be defined explicitly as union.  It's
rather easy to define it incorrectly (ie. using struct bkey) and then
pass it around expecting it to have the pad.

> > > +struct io {
> > > +	/* Used to track sequential IO so it can be skipped */
> > > +	struct hlist_node	hash;
> > > +	struct list_head	lru;
> > > +
> > > +	unsigned long		jiffies;
> > > +	unsigned		sequential;
> > > +	sector_t		last;
> > > +};
> > 
> > I don't think bcache can have struct io. :P
> 
> Is your complaint that there's a struct io somewhere else, or just the
> potential namespace clash in the future? Regardless, I can change it.

The latter.

> > > +struct dirty_io {
> > > +	struct closure		cl;
> > > +	struct cached_dev	*d;
> > > +	struct bio		bio;
> > > +};
> > > +
> > > +struct dirty {
> > > +	struct rb_node		node;
> > > +	BKEY_PADDED(key);
> > > +	struct dirty_io		*io;
> > > +};
> > ...
> > > +struct cache {
> > 
> > Nor these and so on.
> 
> You want me to prefix all my struct names with bcache_? Blech.

It doesn't have to be full bcache.  e.g. words starting with cache can
simply have 'b' in front and others can use things like bc_ or
whatever.

> > So, apart from the the macros, key is 64bit containing the backend
> > device and extent offset and size with the ptr fields somehow point to
> > cache.  Am I understanding it correctly?  If right, I'm *tiny* bit
> > apprehensive about using only 43bits for offset.  While the block 9
> > bits means 52bit addressing, the 9 bit block size is now there mostly
> > to work as buffer between memory bitness growth and storage device
> > size growth so that we have 9 bit buffer as storage device reaches
> > ulong addressing limit.  Probably those days are far out enough.
> 
> You're exactly right. I had similar thoughts about the offset size,
> but... it'll last until we have 8 exabyte cache devices, and I can't

I'm a bit confused.  Cache device or cached device?  Isn't the key
dev:offset:size of the cached device?

> > mca_data_alloc() failure path seems like a resource leak but it isn't
> > because mca_data_alloc() puts it in free list.  Is the extra level of
> > caching necessary?  How is it different from sl?b allocator cache?
> > And either way, comments please.
> 
> This btree in memory cache code is probably the nastiest, subtlest,
> trickiest code in bcache. I have some cleanups in a branch somewhere as
> part of some other work that I need to finish off.
> 
> The btree_cache_freed list isn't for caching - we never free struct
> btrees except on shutdown, to simplify the code. It doesn't cost much
> memory since the memory usage is dominated by the buffers struct btree
> points to, and those are freed when necessary.

Out of curiosity, how does not freeing make the code simpler?  Is it
something synchronization related?

> btree_cache_freeable is a small cache for the buffers struct btree
> points to (the btree node as it exists on disk + the bset tree). We have
> that because high order page allocations can be expensive, and it's
> quite common to delete and allocate btree nodes in quick succession -
> but it should never grow past 2 or 3 nodes.
> 
> I'm adding all this to where the lists are defined, in struct cache_set.

Great.

> > > +	b->flags	= 0;
> > > +	b->level	= level;
> > > +	b->written	= 0;
> > > +	b->nsets	= 0;
> > > +	for (int i = 0; i < MAX_BSETS; i++)
> > > +		b->sets[i].size = 0;
> > > +	for (int i = 1; i < MAX_BSETS; i++)
> > > +		b->sets[i].data = NULL;
> > 
> > Why separate loops?
> 
> Sceond loop starts at 1, because b->sets[0]->data points to the memory
> we have allocated. I suppose that merits a comment.

Ah, okay.

Thanks.

-- 
tejun
