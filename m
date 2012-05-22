Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab2EVWNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:13:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63407 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab2EVWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:13:07 -0400
Date: Tue, 22 May 2012 15:12:59 -0700
From: Tejun Heo <tejun@google.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Message-ID: <20120522221259.GJ14339@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, May 09, 2012 at 11:10:48PM -0400, Kent Overstreet wrote:
> +#define BKEY_PADDED(key)					\
> +	union { struct bkey key; uint64_t key ## _pad[8]; }

What does the '8' mean?  And why does struct bbio use 3 instead?  Does
this have to be a macro?  Can't we have struct bkey_padded (or
whatever)?

> +struct io {
> +	/* Used to track sequential IO so it can be skipped */
> +	struct hlist_node	hash;
> +	struct list_head	lru;
> +
> +	unsigned long		jiffies;
> +	unsigned		sequential;
> +	sector_t		last;
> +};

I don't think bcache can have struct io. :P

> +struct dirty_io {
> +	struct closure		cl;
> +	struct cached_dev	*d;
> +	struct bio		bio;
> +};
> +
> +struct dirty {
> +	struct rb_node		node;
> +	BKEY_PADDED(key);
> +	struct dirty_io		*io;
> +};
...
> +struct cache {

Nor these and so on.

> +/* Bkey fields: all units are in sectors */
> +
> +#define KEY_FIELD(name, field, offset, size)				\
> +	BITMASK(name, struct bkey, field, offset, size)
> +
> +#define PTR_FIELD(name, offset, size)					\
> +	static inline uint64_t name(const struct bkey *k, unsigned i)	\
> +	{ return (k->ptr[i] >> offset) & ~(((uint64_t) ~0) << size); }	\
> +									\
> +	static inline void SET_##name(struct bkey *k, unsigned i, uint64_t v)\
> +	{								\
> +		k->ptr[i] &= ~(~((uint64_t) ~0 << size) << offset);	\
> +		k->ptr[i] |= v << offset;				\
> +	}
> +
> +KEY_FIELD(KEY_PTRS,	header, 60, 3)
> +KEY_FIELD(HEADER_SIZE,	header, 58, 2)
> +KEY_FIELD(KEY_CSUM,	header, 56, 2)
> +KEY_FIELD(KEY_PINNED,	header, 55, 1)
> +KEY_FIELD(KEY_DIRTY,	header, 36, 1)
> +
> +KEY_FIELD(KEY_SIZE,	header, 20, 16)
> +KEY_FIELD(KEY_DEV,	header, 0,  20)
> +
> +KEY_FIELD(KEY_SECTOR,	key,	16, 47)
> +KEY_FIELD(KEY_SNAPSHOT,	key,	0,  16)
> +
> +PTR_FIELD(PTR_DEV,		51, 12)
> +PTR_FIELD(PTR_OFFSET,		8,  43)
> +PTR_FIELD(PTR_GEN,		0,  8)

So, apart from the the macros, key is 64bit containing the backend
device and extent offset and size with the ptr fields somehow point to
cache.  Am I understanding it correctly?  If right, I'm *tiny* bit
apprehensive about using only 43bits for offset.  While the block 9
bits means 52bit addressing, the 9 bit block size is now there mostly
to work as buffer between memory bitness growth and storage device
size growth so that we have 9 bit buffer as storage device reaches
ulong addressing limit.  Probably those days are far out enough.

> +void btree_read_done(struct closure *cl)
> +{
> +	struct btree *b = container_of(cl, struct btree, io.cl);
> +	struct bset *i = b->sets[0].data;
> +	struct btree_iter *iter = b->c->fill_iter;
> +	const char *err = "bad btree header";
> +	BUG_ON(b->nsets || b->written);
> +
> +	bbio_free(b->bio, b->c);
> +	b->bio = NULL;
> +
> +	mutex_lock(&b->c->fill_lock);
> +	iter->used = 0;
> +
> +	if (btree_node_io_error(b) ||
> +	    !i->seq)
> +		goto err;
> +
> +	for (;
> +	     b->written < btree_blocks(b) && i->seq == b->sets[0].data->seq;
> +	     i = write_block(b)) {
> +		err = "unsupported bset version";
> +		if (i->version > BCACHE_BSET_VERSION)
> +			goto err;
> +
> +		err = "bad btree header";
> +		if (b->written + set_blocks(i, b->c) > btree_blocks(b))
> +			goto err;
> +
> +		err = "bad magic";
> +		if (i->magic != bset_magic(b->c))
> +			goto err;
> +
> +		err = "bad checksum";
> +		switch (i->version) {
> +		case 0:
> +			if (i->csum != csum_set(i))
> +				goto err;
> +			break;
> +		case BCACHE_BSET_VERSION:
> +			if (i->csum != btree_csum_set(b, i))
> +				goto err;
> +			break;
> +		}
> +
> +		err = "empty set";
> +		if (i != b->sets[0].data && !i->keys)
> +			goto err;
> +
> +		btree_iter_push(iter, i->start, end(i));
> +
> +		b->written += set_blocks(i, b->c);
> +	}
> +
> +	err = "corrupted btree";
> +	for (i = write_block(b);
> +	     index(i, b) < btree_blocks(b);
> +	     i = ((void *) i) + block_bytes(b->c))
> +		if (i->seq == b->sets[0].data->seq)
> +			goto err;
> +
> +	btree_sort_and_fix_extents(b, iter);
> +
> +	i = b->sets[0].data;
> +	err = "short btree key";
> +	if (b->sets[0].size &&
> +	    bkey_cmp(&b->key, &b->sets[0].end) < 0)
> +		goto err;
> +
> +	if (b->written < btree_blocks(b))
> +		bset_init_next(b);
> +
> +	if (0) {
> +err:		set_btree_node_io_error(b);
> +		cache_set_error(b->c, "%s at bucket %lu, block %zu, %u keys",
> +				err, PTR_BUCKET_NR(b->c, &b->key, 0),
> +				index(i, b), i->keys);
> +	}

Please don't do that.  Just define out: label, move error specific
path to the end of the function and jump to out at the end of that.

> +
> +	mutex_unlock(&b->c->fill_lock);
> +
> +	spin_lock(&b->c->btree_read_time_lock);
> +	time_stats_update(&b->c->btree_read_time, b->io_start_time);
> +	spin_unlock(&b->c->btree_read_time_lock);
> +
> +	smp_wmb(); /* read_done is our write lock */
> +	set_btree_node_read_done(b);
> +
> +	closure_return(cl);
> +}
> +
> +static void btree_read_resubmit(struct closure *cl)
> +{
> +	struct btree *b = container_of(cl, struct btree, io.cl);
> +
> +	submit_bbio_split(b->bio, b->c, &b->key, 0);
> +	continue_at(&b->io.cl, btree_read_done, system_wq);
> +}

I suppose submit_bbio_split() can't fail here somehow unlike from
btree_read() path?  If so, please add a comment to explain and maybe
WARN_ON_ONCE() on failure.  Subtlety to comment ratio is *way* off.

> +static struct btree *mca_bucket_alloc(struct cache_set *c,
> +				      struct bkey *k, gfp_t gfp)
> +{
> +	struct btree *b = kzalloc(sizeof(struct btree), gfp);
> +	if (!b)
> +		return NULL;
> +
> +	init_rwsem(&b->lock);
> +	INIT_LIST_HEAD(&b->list);
> +	INIT_DELAYED_WORK(&b->work, btree_write_work);
> +	b->c = c;
> +	closure_init_unlocked(&b->io);
> +
> +	mca_data_alloc(b, k, gfp);
> +	return b->sets[0].data ? b : NULL;
> +}

mca_data_alloc() failure path seems like a resource leak but it isn't
because mca_data_alloc() puts it in free list.  Is the extra level of
caching necessary?  How is it different from sl?b allocator cache?
And either way, comments please.

> +static int mca_reap(struct btree *b, struct closure *cl)
> +{
> +	lockdep_assert_held(&b->c->bucket_lock);
> +
> +	if (!down_write_trylock(&b->lock))
> +		return -1;
> +
> +	BUG_ON(btree_node_dirty(b) && !b->sets[0].data);
> +
> +	if (cl && btree_node_dirty(b))
> +		btree_write(b, true, NULL);
> +
> +	if (cl)
> +		closure_wait_event_async(&b->io.wait, cl,
> +			 atomic_read(&b->io.cl.remaining) == -1);
> +
> +	if (btree_node_dirty(b) ||
> +	    atomic_read(&b->io.cl.remaining) != -1 ||
> +	    work_pending(&b->work.work)) {
> +		rw_unlock(true, b);
> +		return -EAGAIN;
> +	}
> +
> +	return 0;
> +}

Mixing -1 and -EAGAIN returns usually isn't a good idea.

> +static struct btree *alloc_bucket(struct cache_set *c, struct bkey *k,
> +				  int level, struct closure *cl)
> +{
> +	struct btree *b, *i;
> +	unsigned page_order = ilog2(KEY_SIZE(k) / PAGE_SECTORS ?: 1);
> +
> +	lockdep_assert_held(&c->bucket_lock);
> +retry:
> +	if (find_bucket(c, k))
> +		return NULL;
> +
> +	/* btree_free() doesn't free memory; it sticks the node on the end of
> +	 * the list. Check if there's any freed nodes there:
> +	 */
> +	list_for_each_entry(b, &c->btree_cache_freeable, list)
> +		if (page_order <= b->page_order &&
> +		    !b->key.ptr[0] &&
> +		    !mca_reap(b, NULL))
> +			goto out;
> +
> +	/* We never free struct btree itself, just the memory that holds the on
> +	 * disk node. Check the freed list before allocating a new one:
> +	 */
> +	list_for_each_entry(b, &c->btree_cache_freed, list)
> +		if (!mca_reap(b, NULL)) {
> +			mca_data_alloc(b, k, __GFP_NOWARN|GFP_NOIO);
> +			if (!b->sets[0].data) {
> +				rw_unlock(true, b);
> +				goto err;
> +			} else
> +				goto out;
> +		}
> +
> +	b = mca_bucket_alloc(c, k, __GFP_NOWARN|GFP_NOIO);
> +	if (!b)
> +		goto err;
> +
> +	BUG_ON(!down_write_trylock(&b->lock));
> +out:
> +	BUG_ON(!closure_is_unlocked(&b->io.cl));
> +
> +	bkey_copy(&b->key, k);
> +	list_move(&b->list, &c->btree_cache);
> +	hlist_del_init_rcu(&b->hash);
> +	hlist_add_head_rcu(&b->hash, hash_bucket(c, k));
> +	lock_set_subclass(&b->lock.dep_map, level + 1, _THIS_IP_);
> +
> +	b->flags	= 0;
> +	b->level	= level;
> +	b->written	= 0;
> +	b->nsets	= 0;
> +	for (int i = 0; i < MAX_BSETS; i++)
> +		b->sets[i].size = 0;
> +	for (int i = 1; i < MAX_BSETS; i++)
> +		b->sets[i].data = NULL;

Why separate loops?

> +
> +	return b;
> +err:
> +	if (current->bio_list)
> +		return ERR_PTR(-EAGAIN);

What does this test do?

Thanks.

-- 
tejun
