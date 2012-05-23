Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab2EWEVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:21:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52597 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2EWEVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:21:14 -0400
Date: Wed, 23 May 2012 00:21:14 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 12/16] bcache: Bset code (lookups within a btree
 node)
Message-ID: <20120523042114.GC607@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <5b5998d7d09ec36377acdb5d15665d1e4e818521.1336619038.git.koverstreet@google.com>
 <20120522223932.GK14339@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522223932.GK14339@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 03:39:32PM -0700, Tejun Heo wrote:
> Hello, again.
> 
> On Wed, May 09, 2012 at 11:11:00PM -0400, Kent Overstreet wrote:
> > +void bkey_copy_single_ptr(struct bkey *dest, const struct bkey *src, unsigned i)
> > +{
> > +	BUG_ON(i > KEY_PTRS(src));
> > +
> > +	/* Only copy the header, key, and one pointer. */
> > +	memcpy(dest, src, 2 * sizeof(uint64_t));
> 
> I hope this could be better somehow.

I don't know a great way of writing it, but I suppose sizeof(struct
bkey) + sizeof(uint64_t) would be an improvement.

> 
> > +	dest->ptr[0] = src->ptr[i];
> > +	SET_KEY_PTRS(dest, 1);
> > +	/* We didn't copy the checksum so clear that bit. */
> > +	SET_KEY_CSUM(dest, 0);
> > +}
> > +/* I have no idea why this code works... and I'm the one who wrote it
> > + *
> > + * However, I do know what it does:
> > + * Given a binary tree constructed in an array (i.e. how you normally implement
> > + * a heap), it converts a node in the tree - referenced by array index - to the
> > + * index it would have if you did an inorder traversal.
> > + *
> > + * The binary tree starts at array index 1, not 0
> > + * extra is a function of size:
> > + *   extra = (size - rounddown_pow_of_two(size - 1)) << 1;
> > + */
> 
> It's kinda problematic if you can't understand or explain it.  I'm
> scared.  :(

Hehe. I spent several days staring at pictures of binary trees, then
staring at integers in binary from my code doing inorder travels until
eventually I saw the pattern. Never figured out the math behind it.

But I did test every j for every binary tree up to size somewhere around
6 million. I suppose I'll mention that in the comment.

> 
> > +static unsigned __to_inorder(unsigned j, unsigned size, unsigned extra)
> > +{
> > +	unsigned b = fls(j);
> > +	unsigned shift = fls(size - 1) - b;
> > +
> > +	j  ^= 1U << (b - 1);
> > +	j <<= 1;
> > +	j  |= 1;
> > +	j <<= shift;
> > +
> > +	if (j > extra)
> > +		j -= (j - extra) >> 1;
> > +
> > +	return j;
> > +}
> ...
> > +static void bset_alloc_tree(struct btree *b, struct bset_tree *t)
> > +{
> > +	if (t != b->sets) {
> > +		unsigned j = roundup(t[-1].size,
> > +				     64 / sizeof(struct bkey_float));
> > +
> > +		t->tree = t[-1].tree + j;
> > +		t->prev = t[-1].prev + j;
> > +	}
> > +
> > +	while (t < b->sets + MAX_BSETS)
> > +		t++->size = 0;
> > +}
> 
> I don't know.  This is cryptic and I feel dirty and stupid.

Now you know how I feel :) It really irritates me that I never did
figure out the math.

> 
> > +static void bset_build_unwritten_tree(struct btree *b)
> > +{
> > +	struct bset_tree *t = b->sets + b->nsets;
> 
> Why not &b->sets[b->nsets]?

Yeah, that'd be more consistent.

> 
> > +
> > +	bset_alloc_tree(b, t);
> > +
> > +	if (t->tree != b->sets->tree + bset_tree_space(b)) {
> 
> And why are we switching between sets[N].XXX and sets->XXX?  Do they
> signify something?  The usages don't seem to be consistent tho.

I tried to generally use the sets-> notation when I'm referring to the
allocated memory - that's what's going on here.

> 
> > +		t->prev[0] = bkey_to_cacheline_offset(t->data->start);
> > +		t->size = 1;
> > +	}
> > +}
> ...
> > +void bset_init_next(struct btree *b)
> > +{
> > +	struct bset *i = write_block(b);
> > +
> > +	if (i != b->sets[0].data) {
> > +		b->sets[++b->nsets].data = i;
> > +		i->seq = b->sets[0].data->seq;
> > +	} else
> > +		get_random_bytes(&i->seq, sizeof(uint64_t));
> > +
> > +	i->magic	= bset_magic(b->c);
> > +	i->version	= 0;
> > +	i->keys		= 0;
> > +
> > +	bset_build_unwritten_tree(b);
> > +}
> > +
> > +struct bset_search_iter {
> > +	struct bkey *l, *r;
> > +};
> > +
> > +__attribute__((optimize(3)))
> 
> So, this sets different optimization level per function.  Is this
> really necessary?  If so, you need to make compiler independent in
> include/linux/compiler*.h.

The bset_search_*() functions are definitely hot enough to justify it,
but I can't remember if I ever checked whether that attribute made a
difference.

> 
> > +static void __btree_sort(struct btree *b, struct btree_iter *iter,
> > +			 unsigned start, unsigned order, bool fixup)
> > +{
> > +	uint64_t start_time;
> > +	bool remove_stale = !b->written;
> > +	struct bset *out = (void *) __get_free_pages(__GFP_NOWARN|GFP_NOIO,
> > +						     order);
> > +	if (!out) {
> > +		mutex_lock(&b->c->sort_lock);
> > +		out = b->c->sort;
> > +		order = ilog2(bucket_pages(b->c));
> > +	}
> 
> So, this is implementing simplistic mempool, right?  If so, why not
> just use mempool?

It is (btree_read_done() has another). I'm not sure if this one would
benefit from being switched to a mempool since it tries to allocate only
the size buffer it needs (which may be smaller than what the mempool
has), but the one in btree_read_done() could probably be switched to a
mempool. I'll try it out.

> 
> > +	start_time = local_clock();
> > +
> > +	btree_mergesort(b, out, iter, fixup, remove_stale);
> > +	b->nsets = start;
> > +
> > +	if (!fixup && !start && b->written)
> > +		btree_verify(b, out);
> > +
> > +	if (!start && order == b->page_order) {
> > +		out->magic	= bset_magic(b->c);
> > +		out->seq	= b->sets[0].data->seq;
> > +		out->version	= b->sets[0].data->version;
> > +		swap(out, b->sets[0].data);
> > +
> > +		if (b->c->sort == b->sets[0].data)
> > +			b->c->sort = out;
> > +	} else {
> > +		b->sets[start].data->keys = out->keys;
> > +		memcpy(b->sets[start].data->start, out->start,
> > +		       (void *) end(out) - (void *) out->start);
> > +	}
> > +
> > +	if (out == b->c->sort)
> 
> And is this test correct given the above swap(out, b->sets[0].data)?

Yes. It's difficult to read but I think it's just as bad if the check is
before the swap(). It's avoiding a memcpy() and just swapping buffers
when possible - I added a comment to that effect.

> 
> > +		mutex_unlock(&b->c->sort_lock);
> > +	else
> > +		free_pages((unsigned long) out, order);
> > +
> > +	if (b->written)
> > +		bset_build_written_tree(b);
> > +
> > +	if (!start) {
> > +		spin_lock(&b->c->sort_time_lock);
> > +		time_stats_update(&b->c->sort_time, start_time);
> > +		spin_unlock(&b->c->sort_time_lock);
> > +	}
> > +}
> ...
> > +#define BKEY_MID_BITS		3
> > +#define BKEY_MID_MAX		(~(~0 << (BKEY_MID_BITS - 1)))
> > +#define BKEY_MID_MIN		(-1 - BKEY_MID_MAX)
> > +
> > +#define BKEY_EXPONENT_BITS	7
> > +#define BKEY_MANTISSA_BITS	22
> > +#define BKEY_MANTISSA_MASK	((1 << BKEY_MANTISSA_BITS) - 1)
> > +
> > +struct bkey_float {
> > +	unsigned	exponent:BKEY_EXPONENT_BITS;
> > +	unsigned	m:BKEY_MID_BITS;
> > +	unsigned	mantissa:BKEY_MANTISSA_BITS;
> > +} __packed;
> 
> I *suppose* bkey_float is used to somehow compactly represent key
> values for compacter search tree.  Wouldn't things like this need
> boatload of explanation?

Oh man, I don't even know where to begin. But yeah.

> 
> > +#define BSET_CACHELINE		128
> > +#define BSET_CACHELINE_BITS	ilog2(BSET_CACHELINE)
> 
> Hmm... what if CACHELINE isn't 128 bytes?  What are the effects?
> Wouldn't it be better to name it something else (I don't know,
> BSET_UNIT_BYTES or whatever) and then explain that it's defined to be
> close to popular cacheline size and the effects of it not coinciding
> with actual cacheline size? 

It's poorly named, yeah. Nothing bad happens if it's not the same size
as hardware cachelines (as it's not now) - it used to be 64, but I
realized the lookup code would touch slightly less memory if it was 128.

What it's defining is the number of bytes per bset_float, if you missed
that - when we're done searching the bset_float tree we have this many
bytes left that we do a linear search over.

Since (after level 5, if my math is right) every level of the bset_tree
is on a new cacheline, we're touching one fewer cacheline in the bset
tree in exchange for one more cacheline in the linear search - but the
linear search might stop before it gets to the second cacheline.

> Another nit, it's more customary to
> define BITS or SHIFT first and then define size as << SHIFT.

Yeah, usually I do it that way... I kind of like having the units in
bytes one be the explicitly defined one, but I don't really care either
way.

> 
> > +#define bset_tree_space(b)	(btree_data_space(b) >> BSET_CACHELINE_BITS)
> > +
> > +#define bset_tree_bytes(b)	(bset_tree_space(b) * sizeof(struct bkey_float))
> > +#define bset_prev_bytes(b)	(bset_tree_bytes(b) >> 2)
> 
> Ummm.... cryptic.  What does that >> 2 mean?  Why not
> bset_tree_space(b) * sizeof(whatever prev type is)?

That'd be better (wtf was I thinking when I wrote than?)

> 
> > +void bset_init_next(struct btree *);
> > +
> > +void bset_fix_invalidated_key(struct btree *, struct bkey *);
> > +void bset_fix_lookup_table(struct btree *, struct bkey *);
> > +
> > +struct bkey *__bset_search(struct btree *, struct bset_tree *,
> > +			   const struct bkey *);
> > +#define bset_search(b, t, search)				\
> > +	((search) ? __bset_search(b, t, search) : (t)->data->start)
> 
> Why oh why is this a macro? 

No particular reason. I don't care one way or the other about these one
line wrappers, but I'll switch it to a static inline function if you
prefer.

> And can we please have descriptive
> variable names in prototypes?  btree_sort_into(btree *, btree *) - how
> is one supposed to know from which into which?

Well - my intent isn't for these to be documentation, they're just there
to make the compiler happy... I'd rather refer to the function
definitions. That seems to me to be the norm within the kernel, function
documentation goes with the definition and I've seen dropped variable
names before (but then, that was block layer stuff :)

I'll change it if you want, though.
