Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab2CFWAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:00:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57856 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758983Ab2CFWAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:00:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of msb@google.com designates 10.50.149.129 as permitted sender) smtp.mail=msb@google.com; dkim=pass header.i=msb@google.com
Date: Tue, 6 Mar 2012 13:59:47 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] dm: remake of the verity target
Message-ID: <20120306215947.GB27051@google.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka (mpatocka@redhat.com) wrote:
> Hi
> 
> Here I'm posting remake of the dm-verity target originall developed by 
> Mandeep Singh Baines. It has a compatible target line syntax, so it can be 
> used as a drop-in replacement.
> 
> The major difference is that this driver uses dm-bufio to manage cache of 
> hash blocks in memory. We talked with Alasdair about using dm-bufio for 
> caching and I concluded that it is simpler to rewrite the code rather than 
> transform the original Google code with patches.
> 
> Because of dm-bufio, memory consumption is not dependent on device size 
> (if the system starts running out of memory, dm-bufio discards cached 
> blocks loaded in memory).
> 
> This implementation is smaller, because (unlike the original 
> implementation), it doesn't create persistent in-memory structures.
> 
> This implementation is faster than the original. It uses clustered 
> prefetch to prefetch several hash blocks at once, greatly improving 
> performance if the data partition and hash partition are located on the 
> same disk (the prefetch cluster can be set with prefetch_cluster module 
> parameter).
> 
> Mikulas
> 

Hi Mikulus,

This is some nice work. I like that you've been able to abstract a lot
of the hash buffer management with dm-bufio. You got rid of the I/O queue.
I've been meaning to do that for a while. The prefetch is also nice.
We planned to do this but I decided to not do it now in order to get the
base functionality in:

http://crosbug.com/25441

However, there are some things that I don't like. I don't like comments
either but you have none. You also removed our documentation. You are
allocated a complete shash_desc per I/O. We only allocate one per CPU.
We short-circuit the hash at any level. Your implementation can only
shirt circuit at the lowest level.

I'd like to propose that we get the version we sent upstream and then work
together on adding some of your enhancements incrementally. Other than
the changes we've made to cleanup for upstreaming, the version I
submitted is the code we are using in production.

I'm happy to add prefetch now if that is required for merging.

What do you think?

Regards,
Mandeep

> ---
> 
> Disk: Maxtor Atlas 15k2 146GB, 3.8GB partition
> 
> The following tests were made:
> dd if=/dev/mapper/verity of=/dev/null bs=1M
> fsck.ext2 -fn -C 0 /dev/mapper/verity
> fio --rw=randread --size=200M --bsrange=1k-128k --filename=/dev/mapper/verity --name=job1 --name=job2 --name=job3 --name=job4
> 
> raw partition:
> dd:			42s
> fsck:			11s
> fio:			13s
> 
> original google dm-verity implementation:
> dd (first time):	571s
> dd (next time):		46s
> fsck (first time):	39s
> fsck (next time):	10s
> fio (first time):	26s
> fio (next time):	24s
> 
> my vm-verity implementation:
> dd (first time):	45s
> dd (next time):		43s
> fsck (first time):	11s
> fsck (next time):	11s
> fio (first time):	14s
> fio (next time):	14s
> 
> ---
> 
> Remake of the google dm-verity patch.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/Kconfig     |   17 +
>  drivers/md/Makefile    |    1 
>  drivers/md/dm-bufio.c  |   97 ++++--
>  drivers/md/dm-bufio.h  |    8 
>  drivers/md/dm-verity.c |  785 +++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 887 insertions(+), 21 deletions(-)
> 
> Index: linux-3.3-rc5-fast/drivers/md/Kconfig
> ===================================================================
> --- linux-3.3-rc5-fast.orig/drivers/md/Kconfig	2012-03-03 05:19:33.000000000 +0100
> +++ linux-3.3-rc5-fast/drivers/md/Kconfig	2012-03-03 19:39:30.000000000 +0100
> @@ -388,4 +388,21 @@ config DM_FLAKEY
>         ---help---
>           A target that intermittently fails I/O for debugging purposes.
>  
> +config DM_VERITY
> +	tristate "Verity target support"
> +	depends on BLK_DEV_DM
> +	select CRYPTO
> +	select CRYPTO_HASH
> +	select DM_BUFIO
> +	---help---
> +	  This device-mapper target allows you to create a device that
> +	  transparently integrity checks the data on it. You'll need to
> +	  activate the digests you're going to use in the cryptoapi
> +	  configuration.
> +
> +	  To compile this code as a module, choose M here: the module will
> +	  be called dm-verity.
> +
> +	  If unsure, say N.
> +
>  endif # MD
> Index: linux-3.3-rc5-fast/drivers/md/Makefile
> ===================================================================
> --- linux-3.3-rc5-fast.orig/drivers/md/Makefile	2012-03-03 05:19:33.000000000 +0100
> +++ linux-3.3-rc5-fast/drivers/md/Makefile	2012-03-03 19:39:30.000000000 +0100
> @@ -29,6 +29,7 @@ obj-$(CONFIG_MD_FAULTY)		+= faulty.o
>  obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
>  obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
>  obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
> +obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
>  obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
>  obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>  obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
> Index: linux-3.3-rc5-fast/drivers/md/dm-verity.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-3.3-rc5-fast/drivers/md/dm-verity.c	2012-03-03 05:51:10.000000000 +0100
> @@ -0,0 +1,785 @@
> +/*
> + * Copyright (C) 2012 Red Hat, Inc.
> + *
> + * Author: Mikulas Patocka <mpatocka@redhat.com>
> + *
> + * Based on Chromium dm-verity driver (C) 2011 The Chromium OS Authors
> + *
> + * This file is released under the GPLv2.
> + *
> + * Device mapper target parameters:
> + *	<version>	0
> + *	<data device>
> + *	<hash device>
> + *	<hash start>	(typically 0)
> + *	<block size>	(typically 4096)
> + *	<algorithm>
> + *	<digest>
> + *	optional parameters:
> + *		<salt> (should have 32 bytes for compatibility with Google code)
> + *		<hash block size> (by default it is the same as data block size)
> + *
> + * In the file "/sys/module/dm_verity/parameters/prefetch_cluster" you can set
> + * default prefetch value. Data are read in "prefetch_cluster" chunks from the
> + * hash device. Prefetch cluster greatly improves performance when data and hash
> + * are on the same disk on different partitions.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/device-mapper.h>
> +#include <crypto/hash.h>
> +#include "dm-bufio.h"
> +
> +#define DM_MSG_PREFIX			"verity"
> +
> +#define DM_VERITY_IO_VEC_INLINE		16
> +#define DM_VERITY_MEMPOOL_SIZE		4
> +#define DM_VERITY_PREFETCH_SIZE		262144
> +
> +#define DM_VERITY_MAX_LEVELS		63
> +
> +static unsigned prefetch_cluster = DM_VERITY_PREFETCH_SIZE;
> +
> +module_param_named(prefetch_cluster, prefetch_cluster, uint, S_IRUGO | S_IWUSR);
> +
> +struct dm_verity {
> +	struct dm_dev *data_dev;
> +	struct dm_dev *hash_dev;
> +	struct dm_target *ti;
> +	struct dm_bufio_client *bufio;
> +	char *alg_name;
> +	struct crypto_shash *tfm;
> +	u8 *root_digest;
> +	u8 *salt;
> +	unsigned salt_size;
> +	sector_t data_start;
> +	sector_t hash_start;
> +	sector_t data_blocks;
> +	sector_t hash_blocks;
> +	unsigned char data_dev_block_bits;
> +	unsigned char hash_dev_block_bits;
> +	unsigned char hash_per_block_bits;
> +	unsigned char levels;
> +	unsigned digest_size;
> +	unsigned shash_descsize;
> +
> +	mempool_t *io_mempool;
> +	mempool_t *vec_mempool;
> +
> +	struct workqueue_struct *verify_wq;
> +
> +	sector_t hash_level_block[DM_VERITY_MAX_LEVELS];
> +};
> +
> +struct dm_verity_io {
> +	struct dm_verity *v;
> +	struct bio *bio;
> +	bio_end_io_t *orig_bi_end_io;
> +	void *orig_bi_private;
> +	sector_t block;
> +	unsigned n_blocks;
> +	struct bio_vec *io_vec;
> +	unsigned io_vec_size;
> +	struct work_struct work;
> +	struct bio_vec io_vec_inline[DM_VERITY_IO_VEC_INLINE];
> +	/* u8 hash_desc[crypto_shash_descsize(v->tfm)]; */
> +	/* u8 real_digest[v->digest_size]; */
> +	/* u8 want_digest[v->digest_size]; */
> +};
> +
> +static struct shash_desc *io_hash_desc(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +	return (struct shash_desc *)(io + 1);
> +}
> +
> +static u8 *io_real_digest(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +	return (u8 *)(io + 1) + v->shash_descsize;
> +}
> +
> +static u8 *io_want_digest(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +	return (u8 *)(io + 1) + v->shash_descsize + v->digest_size;
> +}
> +
> +struct buffer_aux {
> +	int hash_verified;
> +};
> +
> +static void dm_bufio_alloc_callback(struct dm_buffer *buf)
> +{
> +	struct buffer_aux *aux = dm_bufio_get_aux_data(buf);
> +	aux->hash_verified = 0;
> +}
> +
> +static sector_t verity_map_sector(struct dm_verity *v, sector_t bi_sector)
> +{
> +	return v->data_start + dm_target_offset(v->ti, bi_sector);
> +}
> +
> +static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
> +					 int level)
> +{
> +	return block >> (level * v->hash_per_block_bits);
> +}
> +
> +static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
> +				 sector_t *hash_block, unsigned *offset)
> +{
> +	sector_t position = verity_position_at_level(v, block, level);
> +
> +	*hash_block = v->hash_level_block[level] + (position >> v->hash_per_block_bits);
> +	if (offset)
> +		*offset = v->digest_size * (position & ((1 << v->hash_per_block_bits) - 1));
> +}
> +
> +static int verity_verify_level(struct dm_verity_io *io, sector_t block,
> +			       int level, int skip_unverified)
> +{
> +	struct dm_verity *v = io->v;
> +	struct dm_buffer *buf;
> +	struct buffer_aux *aux;
> +	u8 *data;
> +	int r;
> +	sector_t hash_block;
> +	unsigned offset;
> +
> +	verity_hash_at_level(v, block, level, &hash_block, &offset);
> +
> +	data = dm_bufio_read(v->bufio, hash_block, &buf);
> +	if (unlikely(IS_ERR(data)))
> +		return PTR_ERR(data);
> +
> +	aux = dm_bufio_get_aux_data(buf);
> +
> +	if (!aux->hash_verified) {
> +		struct shash_desc *desc;
> +		u8 *result;
> +
> +		if (skip_unverified) {
> +			r = 1;
> +			goto release_ret_r;
> +		}
> +
> +		desc = io_hash_desc(v, io);
> +		desc->tfm = v->tfm;
> +		desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +		r = crypto_shash_init(desc);
> +		if (r < 0) {
> +			DMERR("crypto_shash_init failed: %d", r);
> +			goto release_ret_r;
> +		}
> +
> +		r = crypto_shash_update(desc, data, 1 << v->hash_dev_block_bits);
> +		if (r < 0) {
> +			DMERR("crypto_shash_update failed: %d", r);
> +			goto release_ret_r;
> +		}
> +
> +		r = crypto_shash_update(desc, v->salt, v->salt_size);
> +		if (r < 0) {
> +			DMERR("crypto_shash_update failed: %d", r);
> +			goto release_ret_r;
> +		}
> +
> +		result = io_real_digest(v, io);
> +		r = crypto_shash_final(desc, result);
> +		if (r < 0) {
> +			DMERR("crypto_shash_final failed: %d", r);
> +			goto release_ret_r;
> +		}
> +		if (unlikely(memcmp(result, io_want_digest(v, io), v->digest_size))) {
> +			DMERR_LIMIT("metadata block %llu is corrupted",
> +				(unsigned long long)hash_block);
> +			r = -EIO;
> +			goto release_ret_r;
> +		} else
> +			aux->hash_verified = 1;
> +	}
> +
> +	data += offset;
> +
> +	memcpy(io_want_digest(v, io), data, v->digest_size);
> +
> +	dm_bufio_release(buf);
> +	return 0;
> +
> +release_ret_r:
> +	dm_bufio_release(buf);
> +	return r;
> +}
> +
> +static int verity_verify_io(struct dm_verity_io *io)
> +{
> +	struct dm_verity *v = io->v;
> +	unsigned b;
> +	int i;
> +	unsigned vector = 0, offset = 0;
> +	for (b = 0; b < io->n_blocks; b++) {
> +		struct shash_desc *desc;
> +		u8 *result;
> +		int r;
> +		unsigned todo;
> +
> +		if (likely(v->levels)) {
> +			int r = verity_verify_level(io, io->block + b, 0, 1);
> +			if (likely(!r))
> +				goto test_block_hash;
> +			if (r < 0)
> +				return r;
> +		}
> +
> +		memcpy(io_want_digest(v, io), v->root_digest, v->digest_size);
> +
> +		for (i = v->levels - 1; i >= 0; i--) {
> +			int r = verity_verify_level(io, io->block + b, i, 0);
> +			if (unlikely(r))
> +				return r;
> +		}
> +
> +test_block_hash:
> +		desc = io_hash_desc(v, io);
> +		desc->tfm = v->tfm;
> +		desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +		r = crypto_shash_init(desc);
> +		if (r < 0) {
> +			DMERR("crypto_shash_init failed: %d", r);
> +			return r;
> +		}
> +
> +		todo = 1 << v->data_dev_block_bits;
> +		do {
> +			struct bio_vec *bv;
> +			u8 *page;
> +			unsigned len;
> +
> +			BUG_ON(vector >= io->io_vec_size);
> +			bv = &io->io_vec[vector];
> +			page = kmap_atomic(bv->bv_page, KM_USER0);
> +			len = bv->bv_len - offset;
> +			if (likely(len >= todo))
> +				len = todo;
> +			r = crypto_shash_update(desc,
> +					page + bv->bv_offset + offset, len);
> +			kunmap_atomic(page, KM_USER0);
> +			if (r < 0) {
> +				DMERR("crypto_shash_update failed: %d", r);
> +				return r;
> +			}
> +			offset += len;
> +			if (likely(offset == bv->bv_len)) {
> +				offset = 0;
> +				vector++;
> +			}
> +			todo -= len;
> +		} while (todo);
> +
> +		r = crypto_shash_update(desc, v->salt, v->salt_size);
> +		if (r < 0) {
> +			DMERR("crypto_shash_update failed: %d", r);
> +			return r;
> +		}
> +
> +		result = io_real_digest(v, io);
> +		r = crypto_shash_final(desc, result);
> +		if (r < 0) {
> +			DMERR("crypto_shash_final failed: %d", r);
> +			return r;
> +		}
> +		if (unlikely(memcmp(result, io_want_digest(v, io), v->digest_size))) {
> +			DMERR_LIMIT("data block %llu is corrupted",
> +				(unsigned long long)(io->block + b));
> +			return -EIO;
> +		}
> +	}
> +	BUG_ON(vector != io->io_vec_size);
> +	BUG_ON(offset);
> +	return 0;
> +}
> +
> +static void verity_finish_io(struct dm_verity_io *io, int error)
> +{
> +	struct bio *bio = io->bio;
> +	struct dm_verity *v = io->v;
> +
> +	bio->bi_end_io = io->orig_bi_end_io;
> +	bio->bi_private = io->orig_bi_private;
> +
> +	if (io->io_vec != io->io_vec_inline)
> +		mempool_free(io->io_vec, v->vec_mempool);
> +	mempool_free(io, v->io_mempool);
> +
> +	bio_endio(bio, error);
> +}
> +
> +static void verity_work(struct work_struct *w)
> +{
> +	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
> +
> +	verity_finish_io(io, verity_verify_io(io));
> +}
> +
> +static void verity_end_io(struct bio *bio, int error)
> +{
> +	struct dm_verity_io *io = bio->bi_private;
> +	if (error) {
> +		verity_finish_io(io, error);
> +		return;
> +	}
> +
> +	INIT_WORK(&io->work, verity_work);
> +	queue_work(io->v->verify_wq, &io->work);
> +}
> +
> +static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +	int i;
> +	for (i = v->levels - 2; i >= 0; i--) {
> +		sector_t hash_block_start;
> +		sector_t hash_block_end;
> +		verity_hash_at_level(v, io->block, i, &hash_block_start, NULL);
> +		verity_hash_at_level(v, io->block + io->n_blocks - 1, i, &hash_block_end, NULL);
> +		if (!i) {
> +			unsigned cluster = prefetch_cluster;
> +	 /* barrier to stop GCC from re-reading prefetch_cluster again */
> +			barrier();
> +			cluster >>= v->data_dev_block_bits;
> +			if (unlikely(!cluster))
> +				goto no_prefetch_cluster;
> +			if (unlikely(cluster & (cluster - 1)))
> +				cluster = 1 << (fls(cluster) - 1);
> +
> +			hash_block_start &= ~(sector_t)(cluster - 1);
> +			hash_block_end |= cluster - 1;
> +			if (unlikely(hash_block_end >= v->hash_blocks))
> +				hash_block_end = v->hash_blocks - 1;
> +		}
> +no_prefetch_cluster:
> +		dm_bufio_prefetch(v->bufio, hash_block_start,
> +					hash_block_end - hash_block_start + 1);
> +	}
> +}
> +
> +static int verity_map(struct dm_target *ti, struct bio *bio,
> +		      union map_info *map_context)
> +{
> +	struct dm_verity *v = ti->private;
> +	struct dm_verity_io *io;
> +
> +	if (((unsigned)bio->bi_sector | bio_sectors(bio)) &
> +	    ((1 << (v->data_dev_block_bits - SECTOR_SHIFT)) - 1)) {
> +		DMERR_LIMIT("unaligned io");
> +		return -EIO;
> +	}
> +
> +	if ((bio->bi_sector + bio_sectors(bio)) >>
> +	    (v->data_dev_block_bits - SECTOR_SHIFT) > v->data_blocks) {
> +		DMERR_LIMIT("io out of range");
> +		return -EIO;
> +	}
> +
> +	if (bio_data_dir(bio) == WRITE)
> +		return -EIO;
> +
> +	io = mempool_alloc(v->io_mempool, GFP_NOIO);
> +	io->v = v;
> +	io->bio = bio;
> +	io->orig_bi_end_io = bio->bi_end_io;
> +	io->orig_bi_private = bio->bi_private;
> +	io->block = bio->bi_sector >> (v->data_dev_block_bits - SECTOR_SHIFT);
> +	io->n_blocks = bio->bi_size >> v->data_dev_block_bits;
> +
> +	bio->bi_end_io = verity_end_io;
> +	bio->bi_private = io;
> +	bio->bi_bdev = v->data_dev->bdev;
> +	bio->bi_sector = verity_map_sector(v, bio->bi_sector);
> +
> +	io->io_vec_size = bio->bi_vcnt - bio->bi_idx;
> +	if (io->io_vec_size < DM_VERITY_IO_VEC_INLINE)
> +		io->io_vec = io->io_vec_inline;
> +	else
> +		io->io_vec = mempool_alloc(v->vec_mempool, GFP_NOIO);
> +	memcpy(io->io_vec, bio_iovec(bio),
> +	       io->io_vec_size * sizeof(struct bio_vec));
> +
> +	verity_prefetch_io(v, io);
> +
> +	generic_make_request(bio);
> +
> +	return DM_MAPIO_SUBMITTED;
> +}
> +
> +static int verity_status(struct dm_target *ti, status_type_t type,
> +			 char *result, unsigned maxlen)
> +{
> +	struct dm_verity *v = ti->private;
> +	unsigned sz = 0;
> +	unsigned x;
> +
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +		result[0] = 0;
> +		break;
> +	case STATUSTYPE_TABLE:
> +		DMEMIT("%u %s %s %llu %u %s ",
> +			0,
> +			v->data_dev->name,
> +			v->hash_dev->name,
> +			(unsigned long long)v->hash_start << (v->hash_dev_block_bits - SECTOR_SHIFT),
> +			1 << v->data_dev_block_bits,
> +			v->alg_name
> +			);
> +		for (x = 0; x < v->digest_size; x++)
> +			DMEMIT("%02x", v->root_digest[x]);
> +		DMEMIT(" ");
> +		if (!v->salt_size)
> +			DMEMIT("-");
> +		else
> +			for (x = 0; x < v->salt_size; x++)
> +				DMEMIT("%02x", v->salt[x]);
> +		DMEMIT(" %u", 1 << v->hash_dev_block_bits);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int verity_ioctl(struct dm_target *ti, unsigned cmd,
> +			unsigned long arg)
> +{
> +	struct dm_verity *v = ti->private;
> +	int r = 0;
> +
> +	if (v->data_start ||
> +	    ti->len != i_size_read(v->data_dev->bdev->bd_inode) >> SECTOR_SHIFT)
> +		r = scsi_verify_blk_ioctl(NULL, cmd);
> +
> +	return r ? : __blkdev_driver_ioctl(v->data_dev->bdev, v->data_dev->mode,
> +				     cmd, arg);
> +}
> +
> +static int verity_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> +			struct bio_vec *biovec, int max_size)
> +{
> +	struct dm_verity *v = ti->private;
> +	struct request_queue *q = bdev_get_queue(v->data_dev->bdev);
> +
> +	if (!q->merge_bvec_fn)
> +		return max_size;
> +
> +	bvm->bi_bdev = v->data_dev->bdev;
> +	bvm->bi_sector = verity_map_sector(v, bvm->bi_sector);
> +
> +	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> +}
> +
> +static int verity_iterate_devices(struct dm_target *ti,
> +				  iterate_devices_callout_fn fn, void *data)
> +{
> +	struct dm_verity *v = ti->private;
> +	return fn(ti, v->data_dev, v->data_start, ti->len, data);
> +}
> +
> +static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
> +{
> +	struct dm_verity *v = ti->private;
> +
> +	if (limits->logical_block_size < 1 << v->data_dev_block_bits)
> +		limits->logical_block_size = 1 << v->data_dev_block_bits;
> +	if (limits->physical_block_size < 1 << v->data_dev_block_bits)
> +		limits->physical_block_size = 1 << v->data_dev_block_bits;
> +	blk_limits_io_min(limits, limits->logical_block_size);
> +}
> +
> +static void verity_dtr(struct dm_target *ti);
> +
> +static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
> +{
> +	struct dm_verity *v;
> +	unsigned num;
> +	unsigned long long hs;
> +	int r;
> +	int i;
> +	sector_t hash_position;
> +	char dummy;
> +
> +	v = kzalloc(sizeof(struct dm_verity), GFP_KERNEL);
> +	if (!v) {
> +		ti->error = "Cannot allocate verity structure";
> +		return -ENOMEM;
> +	}
> +	ti->private = v;
> +	v->ti = ti;
> +
> +	if ((dm_table_get_mode(ti->table) & ~FMODE_READ) != 0) {
> +		ti->error = "Device must be readonly";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
> +	if (argc < 7) {
> +		ti->error = "Not enough arguments";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
> +	if (sscanf(argv[0], "%d%c", &num, &dummy) != 1 ||
> +	    num != 0) {
> +		ti->error = "Invalid version";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
> +	r = dm_get_device(ti, argv[1], FMODE_READ, &v->data_dev);
> +	if (r) {
> +		ti->error = "Data device lookup failed";
> +		goto bad;
> +	}
> +
> +	r = dm_get_device(ti, argv[2], FMODE_READ, &v->hash_dev);
> +	if (r) {
> +		ti->error = "Data device lookup failed";
> +		goto bad;
> +	}
> +
> +	if (sscanf(argv[3], "%llu%c", &hs, &dummy) != 1 ||
> +	    hs != (sector_t)hs) {
> +		ti->error = "Invalid hash start";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
> +	if (sscanf(argv[4], "%u%c", &num, &dummy) != 1 ||
> +	    !num || (num & (num - 1)) ||
> +	    num < bdev_logical_block_size(v->data_dev->bdev) ||
> +	    num > PAGE_SIZE) {
> +		ti->error = "Invalid data device block size";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +	v->data_dev_block_bits = ffs(num) - 1;
> +	v->hash_dev_block_bits = ffs(num) - 1;
> +
> +	v->alg_name = kstrdup(argv[5], GFP_KERNEL);
> +	if (!v->alg_name) {
> +		ti->error = "Cannot allocate algorithm name";
> +		r = -ENOMEM;
> +		goto bad;
> +	}
> +
> +	v->tfm = crypto_alloc_shash(v->alg_name, 0, 0);
> +	if (IS_ERR(v->tfm)) {
> +		ti->error = "Cannot initialize hash function";
> +		r = PTR_ERR(v->tfm);
> +		v->tfm = NULL;
> +		goto bad;
> +	}
> +	v->digest_size = crypto_shash_digestsize(v->tfm);
> +	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
> +		ti->error = "Digest size too big";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +	v->shash_descsize =
> +		sizeof(struct shash_desc) + crypto_shash_descsize(v->tfm);
> +
> +	v->root_digest = kmalloc(v->digest_size, GFP_KERNEL);
> +	if (!v->root_digest) {
> +		ti->error = "Cannot allocate root digest";
> +		r = -ENOMEM;
> +		goto bad;
> +	}
> +	if (strlen(argv[6]) != v->digest_size * 2 ||
> +	    hex2bin(v->root_digest, argv[6], v->digest_size)) {
> +		ti->error = "Invalid root digest";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
> +	if (argc > 7 && strcmp(argv[7], "-")) {
> +		v->salt_size = strlen(argv[7]) / 2;
> +		v->salt = kmalloc(v->salt_size, GFP_KERNEL);
> +		if (!v->salt) {
> +			ti->error = "Cannot allocate salt";
> +			r = -ENOMEM;
> +			goto bad;
> +		}
> +		if (strlen(argv[7]) != v->salt_size * 2 ||
> +		    hex2bin(v->salt, argv[7], v->salt_size)) {
> +			ti->error = "Invalid salt";
> +			r = -EINVAL;
> +			goto bad;
> +		}
> +	}
> +
> +	if (argc > 8) {
> +		if (sscanf(argv[8], "%u%c", &num, &dummy) != 1 ||
> +		    !num || (num & (num - 1)) ||
> +		    num < bdev_logical_block_size(v->hash_dev->bdev) ||
> +		    num > INT_MAX) {
> +			ti->error = "Invalid hash device block size";
> +			r = -EINVAL;
> +			goto bad;
> +		}
> +		v->hash_dev_block_bits = ffs(num) - 1;
> +	}
> +
> +	if (hs & ((1 << (v->hash_dev_block_bits - SECTOR_SHIFT)) - 1)) {
> +		ti->error = "Hash start not aligned on block boundary";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +	v->hash_start = hs >> (v->hash_dev_block_bits - SECTOR_SHIFT);
> +
> +	if (ti->len > i_size_read(v->data_dev->bdev->bd_inode) >> SECTOR_SHIFT) {
> +		ti->error = "Data device si too small";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
> +	if (ti->len & ((1 << (v->data_dev_block_bits - SECTOR_SHIFT)) - 1)) {
> +		ti->error = "Data device length is not aligned to block size";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
> +	v->data_blocks = ti->len >> (v->data_dev_block_bits - SECTOR_SHIFT);
> +
> +	v->hash_per_block_bits =
> +		fls((1 << v->hash_dev_block_bits) / v->digest_size) - 1;
> +
> +	v->levels = 0;
> +	if (v->data_blocks)
> +		while (v->hash_per_block_bits * v->levels < 64 &&
> +		       (unsigned long long)(v->data_blocks - 1) >>
> +		       (v->hash_per_block_bits * v->levels))
> +			v->levels++;
> +
> +	if (v->levels > DM_VERITY_MAX_LEVELS) {
> +		ti->error = "Too many tree levels";
> +		r = -E2BIG;
> +		goto bad;
> +	}
> +
> +	hash_position = v->hash_start;
> +	for (i = v->levels - 1; i >= 0; i--) {
> +		sector_t s;
> +		v->hash_level_block[i] = hash_position;
> +		s = verity_position_at_level(v, v->data_blocks, i);
> +		s = (s >> v->hash_per_block_bits) +
> +		    !!(s & ((1 << v->hash_per_block_bits) - 1));
> +		if (hash_position + s < hash_position) {
> +			ti->error = "Hash device offset overflow";
> +			r = -E2BIG;
> +			goto bad;
> +		}
> +		hash_position += s;
> +	}
> +	v->hash_blocks = hash_position;
> +
> +	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
> +		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
> +		dm_bufio_alloc_callback, NULL);
> +	if (IS_ERR(v->bufio)) {
> +		ti->error = "Cannot initialize dm-bufio";
> +		r = PTR_ERR(v->bufio);
> +		v->bufio = NULL;
> +		goto bad;
> +	}
> +
> +	if (dm_bufio_get_device_size(v->bufio) < v->hash_blocks) {
> +		ti->error = "Hash device is too small";
> +		r = -E2BIG;
> +		goto bad;
> +	}
> +
> +	v->io_mempool = mempool_create_kmalloc_pool(DM_VERITY_MEMPOOL_SIZE,
> +	  sizeof(struct dm_verity_io) + v->shash_descsize + v->digest_size * 2);
> +	if (!v->io_mempool) {
> +		ti->error = "Cannot allocate io mempool";
> +		r = -ENOMEM;
> +		goto bad;
> +	}
> +
> +	v->vec_mempool = mempool_create_kmalloc_pool(DM_VERITY_MEMPOOL_SIZE,
> +					BIO_MAX_PAGES * sizeof(struct bio_vec));
> +	if (!v->vec_mempool) {
> +		ti->error = "Cannot allocate vector mempool";
> +		r = -ENOMEM;
> +		goto bad;
> +	}
> +
> +	/*v->verify_wq = alloc_workqueue("verityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);*/
> +	/* WQ_UNBOUND greatly improves performance when running on ramdisk */
> +	v->verify_wq = alloc_workqueue("verityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
> +	if (!v->verify_wq) {
> +		ti->error = "Cannot allocate workqueue";
> +		r = -ENOMEM;
> +		goto bad;
> +	}
> +
> +	return 0;
> +
> +bad:
> +	verity_dtr(ti);
> +	return r;
> +}
> +
> +static void verity_dtr(struct dm_target *ti)
> +{
> +	struct dm_verity *v = ti->private;
> +
> +	if (v->verify_wq)
> +		destroy_workqueue(v->verify_wq);
> +	if (v->vec_mempool)
> +		mempool_destroy(v->vec_mempool);
> +	if (v->io_mempool)
> +		mempool_destroy(v->io_mempool);
> +	if (v->bufio)
> +		dm_bufio_client_destroy(v->bufio);
> +	kfree(v->salt);
> +	kfree(v->root_digest);
> +	if (v->tfm)
> +		crypto_free_shash(v->tfm);
> +	kfree(v->alg_name);
> +	if (v->hash_dev)
> +		dm_put_device(ti, v->hash_dev);
> +	if (v->data_dev)
> +		dm_put_device(ti, v->data_dev);
> +	kfree(v);
> +}
> +
> +static struct target_type verity_target = {
> +	.name		= "verity",
> +	.version	= {1, 0, 0},
> +	.module		= THIS_MODULE,
> +	.ctr		= verity_ctr,
> +	.dtr		= verity_dtr,
> +	.map		= verity_map,
> +	.status		= verity_status,
> +	.ioctl		= verity_ioctl,
> +	.merge		= verity_merge,
> +	.iterate_devices = verity_iterate_devices,
> +	.io_hints	= verity_io_hints,
> +};
> +
> +static int __init dm_verity_init(void)
> +{
> +	int r;
> +	r = dm_register_target(&verity_target);
> +	if (r < 0)
> +		DMERR("register failed %d", r);
> +	return r;
> +}
> +
> +static void __exit dm_verity_exit(void)
> +{
> +	dm_unregister_target(&verity_target);
> +}
> +
> +module_init(dm_verity_init);
> +module_exit(dm_verity_exit);
> +
> +MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
> +MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity checking");
> +MODULE_LICENSE("GPL");
> +
> Index: linux-3.3-rc5-fast/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-3.3-rc5-fast.orig/drivers/md/dm-bufio.c	2012-03-03 05:19:33.000000000 +0100
> +++ linux-3.3-rc5-fast/drivers/md/dm-bufio.c	2012-03-03 05:19:35.000000000 +0100
> @@ -579,7 +579,7 @@ static void write_endio(struct bio *bio,
>  	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
>  
>  	b->write_error = error;
> -	if (error) {
> +	if (unlikely(error)) {
>  		struct dm_bufio_client *c = b->c;
>  		(void)cmpxchg(&c->async_write_error, 0, error);
>  	}
> @@ -698,13 +698,20 @@ static void __wait_for_free_buffer(struc
>  	dm_bufio_lock(c);
>  }
>  
> +enum new_flag {
> +	NF_FRESH = 0,
> +	NF_READ = 1,
> +	NF_GET = 2,
> +	NF_PREFETCH = 3
> +};
> +
>  /*
>   * Allocate a new buffer. If the allocation is not possible, wait until
>   * some other thread frees a buffer.
>   *
>   * May drop the lock and regain it.
>   */
> -static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client *c)
> +static struct dm_buffer *__alloc_buffer_wait_no_callback(struct dm_bufio_client *c, enum new_flag nf)
>  {
>  	struct dm_buffer *b;
>  
> @@ -727,6 +734,9 @@ static struct dm_buffer *__alloc_buffer_
>  				return b;
>  		}
>  
> +		if (nf == NF_PREFETCH)
> +			return NULL;
> +
>  		if (!list_empty(&c->reserved_buffers)) {
>  			b = list_entry(c->reserved_buffers.next,
>  				       struct dm_buffer, lru_list);
> @@ -744,9 +754,12 @@ static struct dm_buffer *__alloc_buffer_
>  	}
>  }
>  
> -static struct dm_buffer *__alloc_buffer_wait(struct dm_bufio_client *c)
> +static struct dm_buffer *__alloc_buffer_wait(struct dm_bufio_client *c, enum new_flag nf)
>  {
> -	struct dm_buffer *b = __alloc_buffer_wait_no_callback(c);
> +	struct dm_buffer *b = __alloc_buffer_wait_no_callback(c, nf);
> +
> +	if (!b)
> +		return NULL;
>  
>  	if (c->alloc_callback)
>  		c->alloc_callback(b);
> @@ -866,15 +879,8 @@ static struct dm_buffer *__find(struct d
>   * Getting a buffer
>   *--------------------------------------------------------------*/
>  
> -enum new_flag {
> -	NF_FRESH = 0,
> -	NF_READ = 1,
> -	NF_GET = 2
> -};
> -
>  static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
> -				     enum new_flag nf, struct dm_buffer **bp,
> -				     int *need_submit)
> +				     enum new_flag nf, int *need_submit)
>  {
>  	struct dm_buffer *b, *new_b = NULL;
>  
> @@ -882,6 +888,19 @@ static struct dm_buffer *__bufio_new(str
>  
>  	b = __find(c, block);
>  	if (b) {
> +found_buffer:
> +		if (nf == NF_PREFETCH)
> +			return NULL;
> +		/*
> +		 * Note: it is essential that we don't wait for the buffer to be
> +		 * read if dm_bufio_get function is used. Both dm_bufio_get and
> +		 * dm_bufio_prefetch can be used in the driver request routine.
> +		 * If the user called both dm_bufio_prefetch and dm_bufio_get on
> +		 * the same buffer, it would deadlock if we waited.
> +		 */
> +		if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
> +			return NULL;
> +
>  		b->hold_count++;
>  		__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
>  			     test_bit(B_WRITING, &b->state));
> @@ -891,7 +910,9 @@ static struct dm_buffer *__bufio_new(str
>  	if (nf == NF_GET)
>  		return NULL;
>  
> -	new_b = __alloc_buffer_wait(c);
> +	new_b = __alloc_buffer_wait(c, nf);
> +	if (!new_b)
> +		return NULL;
>  
>  	/*
>  	 * We've had a period where the mutex was unlocked, so need to
> @@ -900,10 +921,7 @@ static struct dm_buffer *__bufio_new(str
>  	b = __find(c, block);
>  	if (b) {
>  		__free_buffer_wake(new_b);
> -		b->hold_count++;
> -		__relink_lru(b, test_bit(B_DIRTY, &b->state) ||
> -			     test_bit(B_WRITING, &b->state));
> -		return b;
> +		goto found_buffer;
>  	}
>  
>  	__check_watermark(c);
> @@ -957,7 +975,7 @@ static void *new_read(struct dm_bufio_cl
>  	struct dm_buffer *b;
>  
>  	dm_bufio_lock(c);
> -	b = __bufio_new(c, block, nf, bp, &need_submit);
> +	b = __bufio_new(c, block, nf, &need_submit);
>  	dm_bufio_unlock(c);
>  
>  	if (!b || IS_ERR(b))
> @@ -997,6 +1015,8 @@ void *dm_bufio_read(struct dm_bufio_clie
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_read);
>  
> +static void dm_bufio_release_unlocked(struct dm_buffer *b);
> +
>  void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
>  		   struct dm_buffer **bp)
>  {
> @@ -1006,13 +1026,35 @@ void *dm_bufio_new(struct dm_bufio_clien
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_new);
>  
> -void dm_bufio_release(struct dm_buffer *b)
> +void dm_bufio_prefetch(struct dm_bufio_client *c,
> +		       sector_t block, unsigned n_blocks)
>  {
> -	struct dm_bufio_client *c = b->c;
> +	struct blk_plug plug;
>  
> +	blk_start_plug(&plug);
>  	dm_bufio_lock(c);
>  
> -	BUG_ON(test_bit(B_READING, &b->state));
> +	for (; n_blocks--; block++) {
> +		int need_submit;
> +		struct dm_buffer *b;
> +		b = __bufio_new(c, block, NF_PREFETCH, &need_submit);
> +		if (unlikely(b != NULL)) {
> +			if (need_submit)
> +				submit_io(b, READ, b->block, read_endio);
> +			dm_bufio_release_unlocked(b);
> +		}
> +
> +	}
> +
> +	dm_bufio_unlock(c);
> +	blk_finish_plug(&plug);
> +}
> +EXPORT_SYMBOL(dm_bufio_prefetch);
> +
> +static void dm_bufio_release_unlocked(struct dm_buffer *b)
> +{
> +	struct dm_bufio_client *c = b->c;
> +
>  	BUG_ON(!b->hold_count);
>  
>  	b->hold_count--;
> @@ -1025,12 +1067,23 @@ void dm_bufio_release(struct dm_buffer *
>  		 * invalid buffer.
>  		 */
>  		if ((b->read_error || b->write_error) &&
> +		    !test_bit(B_READING, &b->state) &&
>  		    !test_bit(B_WRITING, &b->state) &&
>  		    !test_bit(B_DIRTY, &b->state)) {
>  			__unlink_buffer(b);
>  			__free_buffer_wake(b);
>  		}
>  	}
> +}
> +
> +void dm_bufio_release(struct dm_buffer *b)
> +{
> +	struct dm_bufio_client *c = b->c;
> +
> +	dm_bufio_lock(c);
> +
> +	BUG_ON(test_bit(B_READING, &b->state));
> +	dm_bufio_release_unlocked(b);
>  
>  	dm_bufio_unlock(c);
>  }
> @@ -1042,6 +1095,8 @@ void dm_bufio_mark_buffer_dirty(struct d
>  
>  	dm_bufio_lock(c);
>  
> +	BUG_ON(test_bit(B_READING, &b->state));
> +
>  	if (!test_and_set_bit(B_DIRTY, &b->state))
>  		__relink_lru(b, LIST_DIRTY);
>  
> Index: linux-3.3-rc5-fast/drivers/md/dm-bufio.h
> ===================================================================
> --- linux-3.3-rc5-fast.orig/drivers/md/dm-bufio.h	2012-03-03 05:19:33.000000000 +0100
> +++ linux-3.3-rc5-fast/drivers/md/dm-bufio.h	2012-03-03 05:19:35.000000000 +0100
> @@ -63,6 +63,14 @@ void *dm_bufio_new(struct dm_bufio_clien
>  		   struct dm_buffer **bp);
>  
>  /*
> + * Prefetch the specified blocks to the cache.
> + * The function starts to read the blocks and returns without waiting for
> + * I/O to finish.
> + */
> +void dm_bufio_prefetch(struct dm_bufio_client *c,
> +		       sector_t block, unsigned n_blocks);
> +
> +/*
>   * Release a reference obtained with dm_bufio_{read,get,new}. The data
>   * pointer and dm_buffer pointer is no longer valid after this call.
>   */
