Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0DWUjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:39:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27790 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0DWUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:39:21 -0400
Date: Fri, 23 Apr 2010 13:39:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bcache: ver 3
Message-Id: <20100423133910.d36e2b22.randy.dunlap@oracle.com>
In-Reply-To: <20100423194107.GA20322@moria>
References: <20100423194107.GA20322@moria>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BD20577.006B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 11:41:07 -0800 Kent Overstreet wrote:

>  block/Kconfig       |    5 +
>  block/Makefile      |    2 +
>  block/bcache.c      | 2337 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  block/blk-core.c    |    7 +-
>  fs/bio.c            |   32 +-
>  include/linux/bio.h |    2 +
>  include/linux/fs.h  |    5 +
>  7 files changed, 2386 insertions(+), 4 deletions(-)
> 
> diff --git a/block/bcache.c b/block/bcache.c
> new file mode 100644
> index 0000000..3bf3fff
> --- /dev/null
> +++ b/block/bcache.c
> @@ -0,0 +1,2337 @@
> +
> +#define label(l, foo)	if (0) { l: foo; }

I'd prefer that macro to go away.

> +
> +/*
> + * key: 8 bit device, 56 bit offset
> + * value: 8 bit generation, 16 bit length, 40 bit offset
> + * All units are in sectors
> + */
> +
> +static inline struct btree_key *node(struct btree_key *d[], int i)
> +{
> +	return d[i / keys_per_page] + (i % keys_per_page);

That builds OK on i386?  or does it need udivdi3() and/or umoddi3()?

> +}

> +static int lookup_dev(struct cache_device *c, struct bio *bio)
> +{
> +	int dev;
> +	for (dev = 0; dev < 256; dev++)

Use a macro for 256.. in lots of places.

> +		if (c->devices[dev] == bio->bi_bdev->bd_cache_identifier)
> +			break;
> +
> +	if (dev == 256)
> +		printk(KERN_DEBUG "bcache: unknown device %i",
> +		       bio->bi_bdev->bd_cache_identifier);
> +
> +	return dev;
> +}


> +static void register_dev(const char *buffer, size_t size)
> +{
> +	int i;
> +	char *path;
> +	unsigned char uuid[16];
> +	struct block_device *bdev;
> +	struct list_head *l;
> +
> +	i = parse_uuid(buffer, &uuid[0]);
> +
> +	if (i < 4) {
> +		printk(KERN_DEBUG "bcache: Bad uuid");
> +		return;
> +	}
> +
> +	path = kmalloc(size + 1 - i, GFP_KERNEL);
> +	if (!path) {
> +		printk(KERN_DEBUG "bcache: kmalloc error");

		                   bcache: cannot allocate memory
"kmalloc error" sounds like kmalloc() had an internal error.

> +		return;
> +	}
> +	strcpy(path, skip_spaces(buffer + i));
> +	bdev = lookup_bdev(strim(path));
> +
> +	if (IS_ERR(bdev)) {
> +		printk(KERN_DEBUG "bcache: Failed to open %s", path);
> +		goto out;
> +	}
> +
> +	for (i = 0; i < 256; i++) {
> +		if (is_zero(&uuids[i*16], 16))
> +			break;
> +
> +		if (!memcmp(&uuids[i*16], uuid, 16)) {
> +			printk(KERN_DEBUG "bcache: %s already registered", path);
> +			bdput(bdev);
> +			goto out;
> +		}
> +	}
> +	memcpy(&uuids[i*16], uuid, 16);
> +	bdev->bd_cache_identifier = i;
> +	/*devices[i] = bdev->bd_disk;*/
> +
> +	list_for_each(l, &cache_devices)
> +		register_dev_on_cache(list_entry(l, struct cache_device, list), i);
> +
> +	bdev->bd_cache_fn = request_hook;
> +	printk(KERN_DEBUG "bcache: Caching %s index %i", path, i);
> +out:
> +	kfree(path);
> +}

Need to document the sysfs interfaces:

> +static ssize_t show_cache(struct kobject *kobj, struct attribute *attr,
> +			  char *buffer)
> +{
> +	struct cache_device *c = container_of(kobj, struct cache_device, kobj);
> +
> +	sysfs_print(bucket_size, "%i\n", c->sb.bucket_size << 9);
> +	sysfs_print(buckets_used, "%lli\n", c->sb.first_free_bucket);
> +	sysfs_print(buckets_free, "%lli\n", c->sb.nbuckets -
> +		    c->sb.first_free_bucket);
> +	sysfs_print(nbuckets,	"%lli\n", c->sb.nbuckets);
> +	sysfs_print(cache_hits, "%lu\n", c->cache_hits);
> +	sysfs_print(tree_depth, "%u\n", c->sb.btree_level);
> +	sysfs_print(min_priority, "%u\n", c->heap[0] ? c->heap[0]->priority : 0);
> +	return 0;
> +}


> +static void register_cache(const char *buffer, size_t size)
> +{
> +	char *err = NULL, *path, b[BDEVNAME_SIZE];
> +	int i;
> +	struct cache_device *c;
> +	struct search_context s, *sp = &s;
> +
> +	static struct attribute *files[] = {
> +		&sysfs_unregister,
> +		&sysfs_bucket_size,
> +		&sysfs_buckets_used,
> +		&sysfs_buckets_free,
> +		&sysfs_nbuckets,
> +		&sysfs_cache_hits,
> +		&sysfs_tree_depth,
> +		&sysfs_min_priority,
> +		NULL
> +	};
> +	static const struct sysfs_ops ops = {
> +		.show = show_cache,
> +		.store = store_cache
> +	};
> +	static struct kobj_type cache_obj = {
> +		.release = unregister_cache,
> +		.sysfs_ops = &ops,
> +		.default_attrs = files
> +	};
> +
> +	if (!try_module_get(THIS_MODULE))
> +		return;
> +
> +	path = kmalloc(size + 1, GFP_KERNEL);
> +	strcpy(path, skip_spaces(buffer));
> +
> +	err = "Insufficient memory";
> +	if (!(c = kzalloc(sizeof(*c), GFP_KERNEL)))
> +		goto err;
> +
> +	err = "Failed to open cache device";
> +	c->bdev = open_bdev_exclusive(strim(path), FMODE_READ|FMODE_WRITE, c);
> +	if (IS_ERR(c->bdev)) {
> +		if (c->bdev == ERR_PTR(EBUSY))
> +			err = "Device busy";
> +		goto err;
> +	}
> +
> +	set_blocksize(c->bdev, 4096);
> +
> +	err = "IO error";
> +	if (!(c->sb_bh = __bread(c->bdev, 1, PAGE_SIZE)))
> +		goto err;
> +
> +	if (!(c->uuids = __bread(c->bdev, 2, PAGE_SIZE)))
> +		goto err;
> +
> +	if ((err = read_super(c)))
> +		goto err;
> +
> +	c->free_size = 1;
> +	while (c->free_size << 7 < c->sb.nbuckets)
> +		c->free_size <<= 1;
> +
> +	err = "vmalloc error";

		"cannot vmalloc memory";

> +	c->heap		= vmalloc(c->sb.nbuckets * sizeof(struct bucket *));
> +	c->buckets	= vmalloc(c->sb.nbuckets * sizeof(struct bucket));
> +	c->freelist	= vmalloc(c->free_size-- * sizeof(long));
> +	if (!c->heap || !c->buckets || !c->freelist)
> +		goto err;
> +
> +	memset(c->heap,	   0, c->sb.nbuckets * sizeof(struct bucket *));
> +	memset(c->buckets, 0, c->sb.nbuckets * sizeof(struct bucket));
> +
> +	spin_lock_init(&c->bucket_lock);
> +	spin_lock_init(&c->alloc_lock);
> +	init_rwsem(&c->gc_lock);
> +
> +	INIT_LIST_HEAD(&c->lru);
> +	c->btree_buckets_cached = 10;
> +
> +	load_priorities(c);
> +
> +	memset(&s, 0, sizeof(s));
> +	c->root = get_bucket(c, c->sb.btree_root, c->sb.btree_level, false, &sp);
> +	c->buckets[sector_to_bucket(c->root->offset)].priority = ~0;
> +
> +	list_del(&c->root->lru);
> +	rw_unlock(false, &c->root->lock);
> +
> +	/*for (i = 0; i < 256 && devices[i]; i++)
> +		register_dev_on_cache(c, i);*/
> +
> +	for (i = 0; i < 256; i++)
> +		c->devices[i] = ~0;
> +
> +	for (i = 0; i < 256 && !is_zero(&uuids[i*16], 16); i++)
> +		register_dev_on_cache(c, i);
> +
> +	err = "kobject create error";
> +	bdevname(c->bdev, b);
> +	if (!kobject_get(bcache_kobj))
> +		goto err;
> +
> +	if (kobject_init_and_add(&c->kobj, &cache_obj,
> +				 bcache_kobj,
> +				 "%s", b))
> +		goto err;
> +
> +	list_add(&c->list, &cache_devices);
> +
> +	printk(KERN_DEBUG "bcache: Loaded cache device %s, pages_per_btree %i, keys_per_page %li",
> +	       path, pages_per_btree, keys_per_page);
> +	kfree(path);
> +	return;
> +err:
> +	if (c) {
> +		if (c->sb_bh)
> +			put_bh(c->sb_bh);
> +		if (c->uuids)
> +			put_bh(c->uuids);
> +		if (c->kobj.state_initialized)
> +			kobject_put(&c->kobj);
> +		if (c->freelist)
> +			vfree(c->freelist);
> +		if (c->buckets)
> +			vfree(c->buckets);
> +		if (c->heap)
> +			vfree(c->heap);
> +		if (!IS_ERR_OR_NULL(c->bdev))
> +			close_bdev_exclusive(c->bdev, FMODE_READ|FMODE_WRITE);
> +		kzfree(c);
> +	}
> +	printk(KERN_DEBUG "bcache: error opening %s: %s", path, err);
> +	kfree(path);
> +	return;
> +}


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
