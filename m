Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2B2Vax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 16:30:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab2B2Vav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 16:30:51 -0500
Date: Wed, 29 Feb 2012 13:30:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Will Drewry <wad@chromium.org>,
        Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm: verity target
Message-Id: <20120229133049.a21aa72c.akpm@linux-foundation.org>
In-Reply-To: <1330469872-23262-1-git-send-email-msb@chromium.org>
References: <1330469872-23262-1-git-send-email-msb@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 14:57:52 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> The verity target provides transparent integrity checking of block devices
> using a cryptographic digest.
> 
> dm-verity is meant to be setup as part of a verified boot path.  This
> may be anything ranging from a boot using tboot or trustedgrub to just
> booting from a known-good device (like a USB drive or CD).
> 
> dm-verity is part of ChromeOS's verified boot path. It is used to verify
> the integrity of the root filesystem on boot. The root filesystem is
> mounted on a dm-verity partition which transparently verifies each block
> with a bootloader verified hash passed into the kernel at boot.

I brought my towering knowledge of DM drivers to bear upon your patch!

The documentation in this patch is brilliant.  You usefully documented
the data structures!  Never seen that before.

>
> ...
>
> +static int verity_tree_create(struct verity_tree *vt, unsigned int block_count,
> +			      unsigned int block_size, const char *alg_name)
> +{
> +	struct crypto_shash *tfm;
> +	int size, cpu, status = 0;
> +
> +	vt->block_size = block_size;
> +	/* Verify that PAGE_SIZE >= block_size >= SECTOR_SIZE. */
> +	if ((block_size > PAGE_SIZE) ||
> +	    (PAGE_SIZE % block_size) ||
> +	    (to_sector(block_size) == 0))
> +		return -EINVAL;
> +
> +	tfm = crypto_alloc_shash(alg_name, 0, 0);
> +	if (IS_ERR(tfm)) {
> +		DMERR("failed to allocate crypto hash '%s'", alg_name);
> +		return -ENOMEM;
> +	}
> +	size = sizeof(struct shash_desc) + crypto_shash_descsize(tfm);
> +
> +	vt->hash_desc = alloc_percpu(struct shash_desc *);
> +	if (!vt->hash_desc) {
> +		DMERR("Failed to allocate per cpu hash_desc");
> +		status = -ENOMEM;
> +		goto bad_per_cpu;
> +	}
> +
> +	/* Pre-allocate per-cpu crypto contexts to avoid having to
> +	 * kmalloc/kfree a context for every hash operation.
> +	 */
> +	for_each_possible_cpu(cpu) {

Is lame.  Can/should it be made cpu-hotplug-aware, so we use
for_each_online_cpu()?

> +		struct shash_desc *hash_desc = kmalloc(size, GFP_KERNEL);
> +
> +		*per_cpu_ptr(vt->hash_desc, cpu) = hash_desc;
> +		if (!hash_desc) {
> +			DMERR("failed to allocate crypto hash contexts");
> +			status = -ENOMEM;
> +			goto bad_hash_alloc;
> +		}
> +		hash_desc->tfm = tfm;
> +		hash_desc->flags = 0x0;
> +	}
> +	vt->digest_size = crypto_shash_digestsize(tfm);
> +	/* We expect to be able to pack >=2 hashes into a block */
> +	if (block_size / vt->digest_size < 2) {
> +		DMERR("too few hashes fit in a block");
> +		status = -EINVAL;
> +		goto bad_arg;
> +	}
> +
> +	if (vt->digest_size > VERITY_MAX_DIGEST_SIZE) {
> +		DMERR("VERITY_MAX_DIGEST_SIZE too small for digest");
> +		status = -EINVAL;
> +		goto bad_arg;
> +	}
> +
> +	/* Configure the tree */
> +	vt->block_count = block_count;
> +	if (block_count == 0) {
> +		DMERR("block_count must be non-zero");
> +		status = -EINVAL;
> +		goto bad_arg;
> +	}
> +
> +	/* Each verity_tree_entry->nodes is one block.  The node code tracks
> +	 * how many nodes fit into one entry where a node is a single
> +	 * hash (message digest).
> +	 */
> +	vt->node_count_shift = fls(block_size / vt->digest_size) - 1;
> +	/* Round down to the nearest power of two.  This makes indexing
> +	 * into the tree much less painful.
> +	 */
> +	vt->node_count = 1 << vt->node_count_shift;
> +
> +	/* This is unlikely to happen, but with 64k pages, who knows. */
> +	if (vt->node_count > UINT_MAX / vt->digest_size) {
> +		DMERR("node_count * hash_len exceeds UINT_MAX!");
> +		status = -EINVAL;
> +		goto bad_arg;
> +	}
> +
> +	vt->depth = DIV_ROUND_UP(fls(block_count - 1), vt->node_count_shift);
> +
> +	/* Ensure that we can safely shift by this value. */
> +	if (vt->depth * vt->node_count_shift >= sizeof(unsigned int) * 8) {
> +		DMERR("specified depth and node_count_shift is too large");
> +		status = -EINVAL;
> +		goto bad_arg;
> +	}
> +
> +	/* Allocate levels. Each level of the tree may have an arbitrary number
> +	 * of verity_tree_entry structs.  Each entry contains node_count nodes.
> +	 * Each node in the tree is a cryptographic digest of either node_count
> +	 * nodes on the subsequent level or of a specific block on disk.
> +	 */
> +	vt->levels = (struct verity_tree_level *)
> +			kcalloc(vt->depth,
> +				sizeof(struct verity_tree_level), GFP_KERNEL);
> +	if (!vt->levels) {
> +		DMERR("failed to allocate tree levels");
> +		status = -ENOMEM;
> +		goto bad_level_alloc;
> +	}
> +
> +	vt->read_cb = NULL;
> +
> +	status = verity_tree_initialize_entries(vt);
> +	if (status)
> +		goto bad_entries_alloc;
> +
> +	/* We compute depth such that there is only be 1 block at level 0. */
> +	BUG_ON(vt->levels[0].count != 1);
> +
> +	return 0;
> +
> +bad_entries_alloc:
> +	while (vt->depth-- > 0)
> +		kfree(vt->levels[vt->depth].entries);
> +	kfree(vt->levels);
> +bad_level_alloc:
> +bad_arg:
> +bad_hash_alloc:
> +	for_each_possible_cpu(cpu)
> +		if (*per_cpu_ptr(vt->hash_desc, cpu))

This test assumes that alloc_percpu() zeroed out the target memory. 
Not true, is it?

> +			kfree(*per_cpu_ptr(vt->hash_desc, cpu));

Also, kfree(NULL) is OK, so the test was unneeded.  But it will crash
the kernel either way ;)

> +	free_percpu(vt->hash_desc);
> +bad_per_cpu:
> +	crypto_free_shash(tfm);
> +	return status;
> +}
> +
>
> ...
>
> +static struct verity_io *verity_io_alloc(struct dm_target *ti,
> +					    struct bio *bio)
> +{
> +	struct verity_config *vc = ti->private;
> +	sector_t sector = bio->bi_sector - ti->begin;
> +	struct verity_io *io;
> +
> +	io = mempool_alloc(vc->io_pool, GFP_NOIO);
> +	if (unlikely(!io))
> +		return NULL;

Actually, mempool_alloc(..., __GFP_WAIT) cannot fail.  But I wouldn't
trust it either ;)

> +	io->flags = 0;
> +	io->target = ti;
> +	io->bio = bio;
> +	io->error = 0;
> +
> +	/* Adjust the sector by the virtual starting sector */
> +	io->block = to_bytes(sector) / vc->bht.block_size;
> +	io->count = bio->bi_size / vc->bht.block_size;
> +
> +	atomic_set(&io->pending, 0);
> +
> +	return io;
> +}
> +
>
> ...
>
> +static void verity_return_bio_to_caller(struct verity_io *io)
> +{
> +	struct verity_config *vc = io->target->private;
> +
> +	if (io->error)
> +		io->error = -EIO;

That's odd.  Why overwrite a potentially useful errno?

> +	bio_endio(io->bio, io->error);
> +	mempool_free(io, vc->io_pool);
> +}
> +
>
> ...
>
> +static void kverityd_io_bht_populate_end(struct bio *bio, int error)
> +{
> +	struct verity_tree_entry *entry;
> +	struct verity_io *io;
> +
> +	entry = (struct verity_tree_entry *) bio->bi_private;

Unneeded and undesirable cast of void*.

> +	io = (struct verity_io *) entry->io_context;

Ditto.

> +	/* Tell the tree to atomically update now that we've populated
> +	 * the given entry.
> +	 */
> +	verity_tree_read_completed(entry, error);
> +
> +	/* Clean up for reuse when reading data to be checked */
> +	bio->bi_vcnt = 0;
> +	bio->bi_io_vec->bv_offset = 0;
> +	bio->bi_io_vec->bv_len = 0;
> +	bio->bi_io_vec->bv_page = NULL;
> +	/* Restore the private data to I/O so the destructor can be shared. */
> +	bio->bi_private = (void *) io;
> +	bio_put(bio);
> +
> +	/* We bail but assume the tree has been marked bad. */
> +	if (unlikely(error)) {
> +		DMERR("Failed to read for sector %llu (%u)",
> +		      ULL(io->bio->bi_sector), io->bio->bi_size);
> +		io->error = error;
> +		/* Pass through the error to verity_dec_pending below */
> +	}
> +	/* When pending = 0, it will transition to reading real data */
> +	verity_dec_pending(io);
> +}
> +
> +/* Called by verity-tree (via verity_tree_populate), this function provides
> + * the message digests to verity-tree that are stored on disk.
> + */
> +static int kverityd_bht_read_callback(void *ctx, sector_t start, u8 *dst,
> +				      sector_t count,
> +				      struct verity_tree_entry *entry)
> +{
> +	struct verity_io *io = ctx;  /* I/O for this batch */
> +	struct verity_config *vc;
> +	struct bio *bio;
> +
> +	vc = io->target->private;
> +
> +	/* The I/O context is nested inside the entry so that we don't need one
> +	 * io context per page read.
> +	 */
> +	entry->io_context = ctx;
> +
> +	/* We should only get page size requests at present. */
> +	verity_inc_pending(io);
> +	bio = verity_alloc_bioset(vc, GFP_NOIO, 1);
> +	if (unlikely(!bio)) {
> +		DMCRIT("Out of memory at bio_alloc_bioset");
> +		verity_tree_read_completed(entry, -ENOMEM);
> +		return -ENOMEM;
> +	}
> +	bio->bi_private = (void *) entry;

Another unneeded cast.  And it's "undesirable" because the cast defeats
typechecking.  Suppose someone were to change "entry"'s type to "long".

> +	bio->bi_idx = 0;
> +	bio->bi_size = vc->bht.block_size;
> +	bio->bi_sector = vc->hash_start + start;
> +	bio->bi_bdev = vc->hash_dev->bdev;
> +	bio->bi_end_io = kverityd_io_bht_populate_end;
> +	bio->bi_rw = REQ_META;
> +	/* Only need to free the bio since the page is managed by bht */
> +	bio->bi_destructor = verity_bio_destructor;
> +	bio->bi_vcnt = 1;
> +	bio->bi_io_vec->bv_offset = offset_in_page(dst);
> +	bio->bi_io_vec->bv_len = to_bytes(count);
> +	/* dst is guaranteed to be a page_pool allocation */
> +	bio->bi_io_vec->bv_page = virt_to_page(dst);
> +	/* Track that this I/O is in use.  There should be no risk of the io
> +	 * being removed prior since this is called synchronously.
> +	 */
> +	generic_make_request(bio);
> +	return 0;
> +}
> +
>
> ...
>
> +static void kverityd_src_io_read_end(struct bio *clone, int error)
> +{
> +	struct verity_io *io = clone->bi_private;
> +
> +	if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !error))
> +		error = -EIO;
> +
> +	if (unlikely(error)) {
> +		DMERR("Error occurred: %d (%llu, %u)",
> +			error, ULL(clone->bi_sector), clone->bi_size);

Doing a printk() on each I/O error is often a bad idea - if a device
dies it can cause enormous uncontrollable log storms. 
printk_ratelimited(), perhaps?

> +		io->error = error;
> +	}
> +
> +	/* Release the clone which just avoids the block layer from
> +	 * leaving offsets, etc in unexpected states.
> +	 */
> +	bio_put(clone);
> +
> +	verity_dec_pending(io);
> +}
> +
>
> ...
>
> +static int verity_map(struct dm_target *ti, struct bio *bio,
> +		      union map_info *map_context)
> +{
> +	struct verity_io *io;
> +	struct verity_config *vc;
> +	struct request_queue *r_queue;
> +
> +	if (unlikely(!ti)) {
> +		DMERR("dm_target was NULL");
> +		return -EIO;
> +	}
> +
> +	vc = ti->private;
> +	r_queue = bdev_get_queue(vc->dev->bdev);
> +
> +	if (bio_data_dir(bio) == WRITE) {
> +		/* If we silently drop writes, then the VFS layer will cache
> +		 * the write and persist it in memory. While it doesn't change
> +		 * the underlying storage, it still may be contrary to the
> +		 * behavior expected by a verified, read-only device.
> +		 */
> +		DMWARN_LIMIT("write request received. rejecting with -EIO.");
> +		return -EIO;
> +	} else {
> +		/* Queue up the request to be verified */
> +		io = verity_io_alloc(ti, bio);
> +		if (!io) {
> +			DMERR_LIMIT("Failed to allocate and init IO data");
> +			return DM_MAPIO_REQUEUE;
> +		}
> +		INIT_DELAYED_WORK(&io->work, kverityd_io);
> +		queue_delayed_work(kverityd_ioq, &io->work, 0);

hm, I'm seeing delayed works being queued but I'm not seeing anywhere
which explicitly flushes them all out on the shutdown/rmmod paths.  Are
you sure we can't accidentally leave works in flight?

> +	}
> +
> +	return DM_MAPIO_SUBMITTED;
> +}
> +
>
> ...
>
> +static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> +{
> +	struct verity_config *vc = NULL;
> +	const char *dev, *hash_dev, *alg, *digest, *salt;
> +	unsigned long hash_start, block_size, version;
> +	sector_t blocks;
> +	int ret;
> +
> +	if (argc != 8) {
> +		ti->error = "Invalid argument count";
> +		return -EINVAL;
> +	}
> +
> +	if (strict_strtoul(argv[0], 10, &version) ||

There's no point in me telling you things which checkpatch knows about ;)

> +	    (version != 0)) {
> +		ti->error = "Invalid version";
> +		return -EINVAL;
> +	}
>
> ...
>
> +static int verity_ioctl(struct dm_target *ti, unsigned int cmd,
> +			unsigned long arg)
> +{
> +	struct verity_config *vc = (struct verity_config *) ti->private;

Another unneeded/undesirable cast.  Multiple of instances of this one.

> +	struct dm_dev *dev = vc->dev;
> +	int r = 0;
> +
> +	/*
> +	 * Only pass ioctls through if the device sizes match exactly.
> +	 */
> +	if (vc->start ||
> +	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
> +		r = scsi_verify_blk_ioctl(NULL, cmd);
> +
> +	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
> +}
> +
> +static int verity_status(struct dm_target *ti, status_type_t type,
> +			char *result, unsigned int maxlen)
> +{
> +	struct verity_config *vc = (struct verity_config *) ti->private;
> +	unsigned int sz = 0;

unused

> +	char digest[VERITY_MAX_DIGEST_SIZE * 2 + 1] = { 0 };
> +	char salt[VERITY_SALT_SIZE * 2 + 1] = { 0 };
> +
> +	verity_tree_digest(&vc->bht, digest);
> +	verity_tree_salt(&vc->bht, salt);
> +
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +		result[0] = '\0';
> +		break;
> +	case STATUSTYPE_TABLE:
> +		DMEMIT("%s %s %llu %llu %s %s %s",
> +		       vc->dev->name,
> +		       vc->hash_dev->name,
> +		       ULL(vc->hash_start),
> +		       ULL(vc->bht.block_size),
> +		       vc->hash_alg,
> +		       digest,
> +		       salt);
> +		break;
> +	}
> +	return 0;
> +}
> +
>
> ...
>
> +static void verity_io_hints(struct dm_target *ti,
> +			    struct queue_limits *limits)
> +{
> +	struct verity_config *vc = ti->private;

Did it right that time!

> +	unsigned int block_size = vc->bht.block_size;
> +
> +	limits->logical_block_size = block_size;
> +	limits->physical_block_size = block_size;
> +	blk_limits_io_min(limits, block_size);
> +}
> +
>
> ...
>

