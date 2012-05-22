Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab2EVWjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:39:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63094 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab2EVWjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:39:37 -0400
Date: Tue, 22 May 2012 15:39:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 12/16] bcache: Bset code (lookups within a btree
 node)
Message-ID: <20120522223932.GK14339@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <5b5998d7d09ec36377acdb5d15665d1e4e818521.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b5998d7d09ec36377acdb5d15665d1e4e818521.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Wed, May 09, 2012 at 11:11:00PM -0400, Kent Overstreet wrote:
> +void bkey_copy_single_ptr(struct bkey *dest, const struct bkey *src, unsigned i)
> +{
> +	BUG_ON(i > KEY_PTRS(src));
> +
> +	/* Only copy the header, key, and one pointer. */
> +	memcpy(dest, src, 2 * sizeof(uint64_t));

I hope this could be better somehow.

> +	dest->ptr[0] = src->ptr[i];
> +	SET_KEY_PTRS(dest, 1);
> +	/* We didn't copy the checksum so clear that bit. */
> +	SET_KEY_CSUM(dest, 0);
> +}
> +/* I have no idea why this code works... and I'm the one who wrote it
> + *
> + * However, I do know what it does:
> + * Given a binary tree constructed in an array (i.e. how you normally implement
> + * a heap), it converts a node in the tree - referenced by array index - to the
> + * index it would have if you did an inorder traversal.
> + *
> + * The binary tree starts at array index 1, not 0
> + * extra is a function of size:
> + *   extra = (size - rounddown_pow_of_two(size - 1)) << 1;
> + */

It's kinda problematic if you can't understand or explain it.  I'm
scared.  :(

> +static unsigned __to_inorder(unsigned j, unsigned size, unsigned extra)
> +{
> +	unsigned b = fls(j);
> +	unsigned shift = fls(size - 1) - b;
> +
> +	j  ^= 1U << (b - 1);
> +	j <<= 1;
> +	j  |= 1;
> +	j <<= shift;
> +
> +	if (j > extra)
> +		j -= (j - extra) >> 1;
> +
> +	return j;
> +}
...
> +static void bset_alloc_tree(struct btree *b, struct bset_tree *t)
> +{
> +	if (t != b->sets) {
> +		unsigned j = roundup(t[-1].size,
> +				     64 / sizeof(struct bkey_float));
> +
> +		t->tree = t[-1].tree + j;
> +		t->prev = t[-1].prev + j;
> +	}
> +
> +	while (t < b->sets + MAX_BSETS)
> +		t++->size = 0;
> +}

I don't know.  This is cryptic and I feel dirty and stupid.

> +static void bset_build_unwritten_tree(struct btree *b)
> +{
> +	struct bset_tree *t = b->sets + b->nsets;

Why not &b->sets[b->nsets]?

> +
> +	bset_alloc_tree(b, t);
> +
> +	if (t->tree != b->sets->tree + bset_tree_space(b)) {

And why are we switching between sets[N].XXX and sets->XXX?  Do they
signify something?  The usages don't seem to be consistent tho.

> +		t->prev[0] = bkey_to_cacheline_offset(t->data->start);
> +		t->size = 1;
> +	}
> +}
...
> +void bset_init_next(struct btree *b)
> +{
> +	struct bset *i = write_block(b);
> +
> +	if (i != b->sets[0].data) {
> +		b->sets[++b->nsets].data = i;
> +		i->seq = b->sets[0].data->seq;
> +	} else
> +		get_random_bytes(&i->seq, sizeof(uint64_t));
> +
> +	i->magic	= bset_magic(b->c);
> +	i->version	= 0;
> +	i->keys		= 0;
> +
> +	bset_build_unwritten_tree(b);
> +}
> +
> +struct bset_search_iter {
> +	struct bkey *l, *r;
> +};
> +
> +__attribute__((optimize(3)))

So, this sets different optimization level per function.  Is this
really necessary?  If so, you need to make compiler independent in
include/linux/compiler*.h.

> +static void __btree_sort(struct btree *b, struct btree_iter *iter,
> +			 unsigned start, unsigned order, bool fixup)
> +{
> +	uint64_t start_time;
> +	bool remove_stale = !b->written;
> +	struct bset *out = (void *) __get_free_pages(__GFP_NOWARN|GFP_NOIO,
> +						     order);
> +	if (!out) {
> +		mutex_lock(&b->c->sort_lock);
> +		out = b->c->sort;
> +		order = ilog2(bucket_pages(b->c));
> +	}

So, this is implementing simplistic mempool, right?  If so, why not
just use mempool?

> +	start_time = local_clock();
> +
> +	btree_mergesort(b, out, iter, fixup, remove_stale);
> +	b->nsets = start;
> +
> +	if (!fixup && !start && b->written)
> +		btree_verify(b, out);
> +
> +	if (!start && order == b->page_order) {
> +		out->magic	= bset_magic(b->c);
> +		out->seq	= b->sets[0].data->seq;
> +		out->version	= b->sets[0].data->version;
> +		swap(out, b->sets[0].data);
> +
> +		if (b->c->sort == b->sets[0].data)
> +			b->c->sort = out;
> +	} else {
> +		b->sets[start].data->keys = out->keys;
> +		memcpy(b->sets[start].data->start, out->start,
> +		       (void *) end(out) - (void *) out->start);
> +	}
> +
> +	if (out == b->c->sort)

And is this test correct given the above swap(out, b->sets[0].data)?

> +		mutex_unlock(&b->c->sort_lock);
> +	else
> +		free_pages((unsigned long) out, order);
> +
> +	if (b->written)
> +		bset_build_written_tree(b);
> +
> +	if (!start) {
> +		spin_lock(&b->c->sort_time_lock);
> +		time_stats_update(&b->c->sort_time, start_time);
> +		spin_unlock(&b->c->sort_time_lock);
> +	}
> +}
...
> +#define BKEY_MID_BITS		3
> +#define BKEY_MID_MAX		(~(~0 << (BKEY_MID_BITS - 1)))
> +#define BKEY_MID_MIN		(-1 - BKEY_MID_MAX)
> +
> +#define BKEY_EXPONENT_BITS	7
> +#define BKEY_MANTISSA_BITS	22
> +#define BKEY_MANTISSA_MASK	((1 << BKEY_MANTISSA_BITS) - 1)
> +
> +struct bkey_float {
> +	unsigned	exponent:BKEY_EXPONENT_BITS;
> +	unsigned	m:BKEY_MID_BITS;
> +	unsigned	mantissa:BKEY_MANTISSA_BITS;
> +} __packed;

I *suppose* bkey_float is used to somehow compactly represent key
values for compacter search tree.  Wouldn't things like this need
boatload of explanation?

> +#define BSET_CACHELINE		128
> +#define BSET_CACHELINE_BITS	ilog2(BSET_CACHELINE)

Hmm... what if CACHELINE isn't 128 bytes?  What are the effects?
Wouldn't it be better to name it something else (I don't know,
BSET_UNIT_BYTES or whatever) and then explain that it's defined to be
close to popular cacheline size and the effects of it not coinciding
with actual cacheline size?  Another nit, it's more customary to
define BITS or SHIFT first and then define size as << SHIFT.

> +#define bset_tree_space(b)	(btree_data_space(b) >> BSET_CACHELINE_BITS)
> +
> +#define bset_tree_bytes(b)	(bset_tree_space(b) * sizeof(struct bkey_float))
> +#define bset_prev_bytes(b)	(bset_tree_bytes(b) >> 2)

Ummm.... cryptic.  What does that >> 2 mean?  Why not
bset_tree_space(b) * sizeof(whatever prev type is)?

> +void bset_init_next(struct btree *);
> +
> +void bset_fix_invalidated_key(struct btree *, struct bkey *);
> +void bset_fix_lookup_table(struct btree *, struct bkey *);
> +
> +struct bkey *__bset_search(struct btree *, struct bset_tree *,
> +			   const struct bkey *);
> +#define bset_search(b, t, search)				\
> +	((search) ? __bset_search(b, t, search) : (t)->data->start)

Why oh why is this a macro?  And can we please have descriptive
variable names in prototypes?  btree_sort_into(btree *, btree *) - how
is one supposed to know from which into which?

> +bool bkey_try_merge(struct btree *, struct bkey *, struct bkey *);
> +void btree_sort_lazy(struct btree *);
> +void btree_sort_into(struct btree *, struct btree *);
> +void btree_sort_and_fix_extents(struct btree *, struct btree_iter *);
> +void btree_sort_partial(struct btree *, unsigned);
> +#define btree_sort(b)	btree_sort_partial(b, 0)
> +
> +int bset_print_stats(struct cache_set *, char *);

Thanks.

-- 
tejun
