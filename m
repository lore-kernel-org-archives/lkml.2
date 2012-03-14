Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2CNVNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:13:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46057 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab2CNVNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:13:23 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
	<20120306215947.GB27051@google.com>
	<Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
Date: Wed, 14 Mar 2012 16:13:19 -0500
Message-ID: <CABqD9hYUVpC-NQ_WQ5bH8ZxLein+zxHQHDGJzwyRWHokMiPSbg@mail.gmail.com>
Subject: Re: [PATCH] dm: remake of the verity target
From: Will Drewry <wad@chromium.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikulas,

This is a nice rewrite and takes advantage of your dm-bufio layer. I
wish it'd existed (and or we wrote it :) in 2009 when we started this
work!  Some comments below:

On Tue, Mar 13, 2012 at 5:20 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Hi
>
>> Hi Mikulus,
>>
>> This is some nice work. I like that you've been able to abstract a lot
>> of the hash buffer management with dm-bufio. You got rid of the I/O queue.
>> I've been meaning to do that for a while. The prefetch is also nice.
>> We planned to do this but I decided to not do it now in order to get the
>> base functionality in:
>>
>> http://crosbug.com/25441
>>
>> However, there are some things that I don't like. I don't like comments
>> either but you have none. You also removed our documentation. You are
>
> I added some comments. As for documentation, it's OK to use documentation
> from your patch because the on-disk format and the target arguments are
> the same (with an enhancement that my code supports different data and
> metadata bock size and it has variable-length salt).

Sounds good.

>> allocated a complete shash_desc per I/O. We only allocate one per CPU.
>
> The hash of 4k block takes 174000 cycles. So trying to optimize
> memory latency that is about 250 cycles doesn't make much sense.
>
> I actually observed better performance using verity on ramdisk with
> workqueue unbound to specific CPUs. The reason is that the ramdisk bio
> completion routine is always run on the same CPU (that one that submitted
> the request), so with bound workqueue, everything was executing on one
> CPU. With unbound workqueue, I got parallelism.
>
>> We short-circuit the hash at any level. Your implementation can only
>> shirt circuit at the lowest level.
>
> It short-circuits hash at all levels. If the function
> "verity_verify_level" finds out that "aux->hash_verified" is non-zero, it
> doesn't do any hashing, it just copies the hash for the lower level. My
> implementation walks the tree from the top to the bottom, but it doesn't
> do hash verification if the same block has been verified before.
>
> All this tree-walking from the root to the bottom is 50-times faster than
> the actual hashing of the data block (I measured that), so there's not
> much point in trying to optimize it. I did a simple optimization (don't
> walk the tree if the lowest block is already verified) and I don't need to
> do anything complicated given the fact that it can't improve more than by
> 2%.

All we'd done was reverse the walk (we've had it both ways now :),
nothing complicated, but I don't think it's a problem.

>> I'd like to propose that we get the version we sent upstream and then work
>> together on adding some of your enhancements incrementally.
>
> If you add dm-bufio support, you end up deleting majority of the original
> code anyway. That's why I wrote it from scratch and that's why I didn't
> attempt to morph your code.
>
> It's simpler to write the code from scratch and it is also less bug-prone.
>
>> Other than
>> the changes we've made to cleanup for upstreaming, the version I
>> submitted is the code we are using in production.
>>
>> I'm happy to add prefetch now if that is required for merging.
>>
>> What do you think?
>>
>> Regards,
>> Mandeep
>
> This is the version with comments added:
>
> Mikulas
>
> ----
>
> Remake of the google dm-verity patch.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/md/Kconfig     |   17
>  drivers/md/Makefile    |    1
>  drivers/md/dm-verity.c |  851 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 869 insertions(+)
>
> Index: linux-3.3-rc6-fast/drivers/md/Kconfig
> ===================================================================
> --- linux-3.3-rc6-fast.orig/drivers/md/Kconfig  2012-03-13 21:46:03.000000000 +0100
> +++ linux-3.3-rc6-fast/drivers/md/Kconfig       2012-03-13 21:46:05.000000000 +0100
> @@ -404,4 +404,21 @@ config DM_VERITY2
>
>           If unsure, say N.
>
> +config DM_VERITY
> +       tristate "Verity target support"
> +       depends on BLK_DEV_DM
> +       select CRYPTO
> +       select CRYPTO_HASH
> +       select DM_BUFIO
> +       ---help---
> +         This device-mapper target allows you to create a device that
> +         transparently integrity checks the data on it. You'll need to
> +         activate the digests you're going to use in the cryptoapi
> +         configuration.
> +
> +         To compile this code as a module, choose M here: the module will
> +         be called dm-verity.
> +
> +         If unsure, say N.
> +
>  endif # MD
> Index: linux-3.3-rc6-fast/drivers/md/Makefile
> ===================================================================
> --- linux-3.3-rc6-fast.orig/drivers/md/Makefile 2012-03-13 21:46:03.000000000 +0100
> +++ linux-3.3-rc6-fast/drivers/md/Makefile      2012-03-13 21:46:05.000000000 +0100
> @@ -29,6 +29,7 @@ obj-$(CONFIG_MD_FAULTY)               += faulty.o
>  obj-$(CONFIG_BLK_DEV_MD)       += md-mod.o
>  obj-$(CONFIG_BLK_DEV_DM)       += dm-mod.o
>  obj-$(CONFIG_DM_BUFIO)         += dm-bufio.o
> +obj-$(CONFIG_DM_VERITY)                += dm-verity.o
>  obj-$(CONFIG_DM_CRYPT)         += dm-crypt.o
>  obj-$(CONFIG_DM_DELAY)         += dm-delay.o
>  obj-$(CONFIG_DM_FLAKEY)                += dm-flakey.o
> Index: linux-3.3-rc6-fast/drivers/md/dm-verity.c
> ===================================================================
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-3.3-rc6-fast/drivers/md/dm-verity.c   2012-03-13 22:02:05.000000000 +0100
> @@ -0,0 +1,851 @@
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
> + *     <version>       0
> + *     <data device>
> + *     <hash device>
> + *     <hash start>    (typically 0)
> + *     <block size>    (typically 4096)
> + *     <algorithm>
> + *     <digest>
> + *     optional parameters:
> + *             <salt> (should have 32 bytes for compatibility with Google code)
> + *             <hash block size> (by default it is the same as data block size)
> + *
> + * In the file "/sys/module/dm_verity/parameters/prefetch_cluster" you can set
> + * default prefetch value. Data are read in "prefetch_cluster" chunks from the
> + * hash device. Prefetch cluster greatly improves performance when data and hash
> + * are on the same disk on different partitions.

... on different partitions on devices with poor random access behavior.

> + */
> +
> +#include <linux/module.h>
> +#include <linux/device-mapper.h>
> +#include <crypto/hash.h>
> +#include "dm-bufio.h"
> +
> +#define DM_MSG_PREFIX                  "verity"
> +
> +#define DM_VERITY_IO_VEC_INLINE                16
> +#define DM_VERITY_MEMPOOL_SIZE         4
> +#define DM_VERITY_DEFAULT_PREFETCH_SIZE        262144
> +
> +#define DM_VERITY_MAX_LEVELS           63
> +
> +static unsigned prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
> +
> +module_param_named(prefetch_cluster, prefetch_cluster, uint, S_IRUGO | S_IWUSR);
> +
> +struct dm_verity {
> +       struct dm_dev *data_dev;
> +       struct dm_dev *hash_dev;
> +       struct dm_target *ti;
> +       struct dm_bufio_client *bufio;
> +       char *alg_name;
> +       struct crypto_shash *tfm;
> +       u8 *root_digest;        /* digest of the root block */
> +       u8 *salt;               /* salt, its size is salt_size */
> +       unsigned salt_size;
> +       sector_t data_start;    /* data offset in 512-byte sectors */
> +       sector_t hash_start;    /* hash start in blocks */
> +       sector_t data_blocks;   /* the number of data blocks */
> +       sector_t hash_blocks;   /* the number of hash blocks */
> +       unsigned char data_dev_block_bits;      /* log2(data blocksize) */
> +       unsigned char hash_dev_block_bits;      /* log2(hash blocksize) */
> +       unsigned char hash_per_block_bits;      /* log2(hashes in hash block) */
> +       unsigned char levels;   /* the number of tree levels */
> +       unsigned digest_size;   /* digest size for the current hash algorithm */
> +       unsigned shash_descsize;/* the size of temporary space for crypto */
> +
> +       mempool_t *io_mempool;  /* mempool of struct dm_verity_io */
> +       mempool_t *vec_mempool; /* mempool of bio vector */
> +
> +       struct workqueue_struct *verify_wq;
> +
> +       /* starting blocks for each tree level. 0 is the lowest level. */
> +       sector_t hash_level_block[DM_VERITY_MAX_LEVELS];
> +};
> +
> +struct dm_verity_io {
> +       struct dm_verity *v;
> +       struct bio *bio;
> +
> +       /* original values of bio->bi_end_io and bio->bi_private */
> +       bio_end_io_t *orig_bi_end_io;
> +       void *orig_bi_private;
> +
> +       sector_t block;
> +       unsigned n_blocks;
> +
> +       /* saved bio vector */
> +       struct bio_vec *io_vec;
> +       unsigned io_vec_size;
> +
> +       struct work_struct work;
> +
> +       /* a space for short vectors; longer vectors are allocated separately */
> +       struct bio_vec io_vec_inline[DM_VERITY_IO_VEC_INLINE];
> +
> +       /* variable-size fields, accessible with functions
> +               io_hash_desc, io_real_digest, io_want_digest */
> +       /* u8 hash_desc[crypto_shash_descsize(v->tfm)]; */
> +       /* u8 real_digest[v->digest_size]; */
> +       /* u8 want_digest[v->digest_size]; */
> +};
> +
> +static struct shash_desc *io_hash_desc(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +       return (struct shash_desc *)(io + 1);
> +}
> +
> +static u8 *io_real_digest(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +       return (u8 *)(io + 1) + v->shash_descsize;
> +}
> +
> +static u8 *io_want_digest(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +       return (u8 *)(io + 1) + v->shash_descsize + v->digest_size;
> +}
> +
> +/*
> + * Auxiliary structure appended to each dm-bufio buffer. If the value
> + * hash_verified is nonzero, hash of the block has been verified.
> + *
> + * There is no lock around this value, a race condition can at worst cause
> + * that multiple processes verify the hash of the same buffer simultaneously.
> + * This condition is harmless, so we don't need locking.
> + */

Might be worth clarifying that no consumer will ever write a 0 value
to the hash_verified field after dm_bufio_alloc_callback, as that is
the critical constraint.  It's what makes lockless/atomic-less access
acceptable.  As you say, the worst case you over verify or you
over-write.

bufio is nice for this use since it encapsulates the need for the
atomic state transitions we were using in our module to stay
lock-free.

> +struct buffer_aux {
> +       int hash_verified;
> +};
> +
> +/*
> + * Initialize struct buffer_aux for a freshly created buffer.
> + */
> +static void dm_bufio_alloc_callback(struct dm_buffer *buf)
> +{
> +       struct buffer_aux *aux = dm_bufio_get_aux_data(buf);
> +       aux->hash_verified = 0;
> +}
> +
> +/*
> + * Translate input sector number to the sector number on the target device.
> + */
> +static sector_t verity_map_sector(struct dm_verity *v, sector_t bi_sector)
> +{
> +       return v->data_start + dm_target_offset(v->ti, bi_sector);
> +}
> +
> +/*
> + * Return hash position of a specified block at a specified tree level
> + * (0 is the lowest level).
> + * The lowest "hash_per_block_bits"-bits of the result denote hash position
> + * inside a hash block. The remaining bits denode location of the hash block.

s/denode/denote/

> + */
> +static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
> +                                        int level)
> +{
> +       return block >> (level * v->hash_per_block_bits);
> +}
> +
> +static void verity_hash_at_level(struct dm_verity *v, sector_t block, int level,
> +                                sector_t *hash_block, unsigned *offset)
> +{
> +       sector_t position = verity_position_at_level(v, block, level);
> +
> +       *hash_block = v->hash_level_block[level] + (position >> v->hash_per_block_bits);
> +       if (offset)
> +               *offset = v->digest_size * (position & ((1 << v->hash_per_block_bits) - 1));
> +}
> +
> +/*
> + * Verify hash of a metadata block pertaining to the specified data block
> + * ("block" argument) at a specified level ("level" argument).
> + *
> + * On successful return, io_want_digest(v, io) contains the hash value for
> + * a lower tree level or for the data block (if we're at the lowest leve).
> + *
> + * If "skip_unverified" is true, unverified buffer is skipped an 1 is returned.
> + * If "skip_unverified" is false, unverified buffer is hashed and verified
> + * against current value of io_want_digest(v, io).
> + */
> +static int verity_verify_level(struct dm_verity_io *io, sector_t block,
> +                              int level, bool skip_unverified)
> +{
> +       struct dm_verity *v = io->v;
> +       struct dm_buffer *buf;
> +       struct buffer_aux *aux;
> +       u8 *data;
> +       int r;
> +       sector_t hash_block;
> +       unsigned offset;
> +
> +       verity_hash_at_level(v, block, level, &hash_block, &offset);
> +
> +       data = dm_bufio_read(v->bufio, hash_block, &buf);
> +       if (unlikely(IS_ERR(data)))
> +               return PTR_ERR(data);
> +
> +       aux = dm_bufio_get_aux_data(buf);
> +
> +       if (!aux->hash_verified) {
> +               struct shash_desc *desc;
> +               u8 *result;
> +
> +               if (skip_unverified) {
> +                       r = 1;
> +                       goto release_ret_r;
> +               }
> +
> +               desc = io_hash_desc(v, io);
> +               desc->tfm = v->tfm;
> +               desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +               r = crypto_shash_init(desc);
> +               if (r < 0) {
> +                       DMERR("crypto_shash_init failed: %d", r);
> +                       goto release_ret_r;
> +               }
> +
> +               r = crypto_shash_update(desc, data, 1 << v->hash_dev_block_bits);
> +               if (r < 0) {
> +                       DMERR("crypto_shash_update failed: %d", r);
> +                       goto release_ret_r;
> +               }
> +
> +               r = crypto_shash_update(desc, v->salt, v->salt_size);
> +               if (r < 0) {
> +                       DMERR("crypto_shash_update failed: %d", r);
> +                       goto release_ret_r;
> +               }
> +
> +               result = io_real_digest(v, io);
> +               r = crypto_shash_final(desc, result);
> +               if (r < 0) {
> +                       DMERR("crypto_shash_final failed: %d", r);
> +                       goto release_ret_r;
> +               }
> +               if (unlikely(memcmp(result, io_want_digest(v, io), v->digest_size))) {
> +                       DMERR_LIMIT("metadata block %llu is corrupted",
> +                               (unsigned long long)hash_block);
> +                       r = -EIO;
> +                       goto release_ret_r;
> +               } else
> +                       aux->hash_verified = 1;
> +       }
> +
> +       data += offset;
> +
> +       memcpy(io_want_digest(v, io), data, v->digest_size);
> +
> +       dm_bufio_release(buf);
> +       return 0;
> +
> +release_ret_r:
> +       dm_bufio_release(buf);
> +       return r;
> +}
> +
> +/*
> + * Verify one "dm_verity_io" structure.
> + */
> +static int verity_verify_io(struct dm_verity_io *io)
> +{
> +       struct dm_verity *v = io->v;
> +       unsigned b;
> +       int i;
> +       unsigned vector = 0, offset = 0;
> +       for (b = 0; b < io->n_blocks; b++) {
> +               struct shash_desc *desc;
> +               u8 *result;
> +               int r;
> +               unsigned todo;
> +
> +               if (likely(v->levels)) {
> +                       /*
> +                        * First, we try to get the requested hash for
> +                        * the current block. If the hash block itself is
> +                        * verified, zero is returned. If it isn't, this
> +                        * function returns 0 and we fall back to whole
> +                        * chain verification.
> +                        */
> +                       int r = verity_verify_level(io, io->block + b, 0, true);
> +                       if (likely(!r))
> +                               goto test_block_hash;
> +                       if (r < 0)
> +                               return r;
> +               }
> +
> +               memcpy(io_want_digest(v, io), v->root_digest, v->digest_size);
> +
> +               for (i = v->levels - 1; i >= 0; i--) {
> +                       int r = verity_verify_level(io, io->block + b, i, false);
> +                       if (unlikely(r))
> +                               return r;
> +               }
> +
> +test_block_hash:
> +               desc = io_hash_desc(v, io);
> +               desc->tfm = v->tfm;
> +               desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +               r = crypto_shash_init(desc);
> +               if (r < 0) {
> +                       DMERR("crypto_shash_init failed: %d", r);
> +                       return r;
> +               }
> +
> +               todo = 1 << v->data_dev_block_bits;
> +               do {
> +                       struct bio_vec *bv;
> +                       u8 *page;
> +                       unsigned len;
> +
> +                       BUG_ON(vector >= io->io_vec_size);
> +                       bv = &io->io_vec[vector];
> +                       page = kmap_atomic(bv->bv_page, KM_USER0);
> +                       len = bv->bv_len - offset;
> +                       if (likely(len >= todo))
> +                               len = todo;
> +                       r = crypto_shash_update(desc,
> +                                       page + bv->bv_offset + offset, len);
> +                       kunmap_atomic(page, KM_USER0);
> +                       if (r < 0) {
> +                               DMERR("crypto_shash_update failed: %d", r);
> +                               return r;
> +                       }
> +                       offset += len;
> +                       if (likely(offset == bv->bv_len)) {
> +                               offset = 0;
> +                               vector++;
> +                       }
> +                       todo -= len;
> +               } while (todo);
> +
> +               r = crypto_shash_update(desc, v->salt, v->salt_size);
> +               if (r < 0) {
> +                       DMERR("crypto_shash_update failed: %d", r);
> +                       return r;
> +               }
> +
> +               result = io_real_digest(v, io);
> +               r = crypto_shash_final(desc, result);
> +               if (r < 0) {
> +                       DMERR("crypto_shash_final failed: %d", r);
> +                       return r;
> +               }
> +               if (unlikely(memcmp(result, io_want_digest(v, io), v->digest_size))) {
> +                       DMERR_LIMIT("data block %llu is corrupted",
> +                               (unsigned long long)(io->block + b));
> +                       return -EIO;
> +               }
> +       }
> +       BUG_ON(vector != io->io_vec_size);
> +       BUG_ON(offset);
> +       return 0;
> +}
> +
> +/*
> + * End one "io" structure with a given error.
> + */
> +static void verity_finish_io(struct dm_verity_io *io, int error)
> +{
> +       struct bio *bio = io->bio;
> +       struct dm_verity *v = io->v;
> +
> +       bio->bi_end_io = io->orig_bi_end_io;
> +       bio->bi_private = io->orig_bi_private;
> +
> +       if (io->io_vec != io->io_vec_inline)
> +               mempool_free(io->io_vec, v->vec_mempool);
> +       mempool_free(io, v->io_mempool);
> +
> +       bio_endio(bio, error);
> +}
> +
> +static void verity_work(struct work_struct *w)
> +{
> +       struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
> +
> +       verity_finish_io(io, verity_verify_io(io));
> +}
> +
> +static void verity_end_io(struct bio *bio, int error)
> +{
> +       struct dm_verity_io *io = bio->bi_private;
> +       if (error) {
> +               verity_finish_io(io, error);
> +               return;
> +       }
> +
> +       INIT_WORK(&io->work, verity_work);
> +       queue_work(io->v->verify_wq, &io->work);
> +}
> +
> +/*
> + * Prefetch buffers for the specified io.
> + * The root buffer is not prefetched, it is assumed that it will be cached
> + * all the time.
> + */
> +static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
> +{
> +       int i;
> +       for (i = v->levels - 2; i >= 0; i--) {
> +               sector_t hash_block_start;
> +               sector_t hash_block_end;
> +               verity_hash_at_level(v, io->block, i, &hash_block_start, NULL);
> +               verity_hash_at_level(v, io->block + io->n_blocks - 1, i, &hash_block_end, NULL);
> +               if (!i) {
> +                       unsigned cluster = prefetch_cluster;
> +        /* barrier to stop GCC from re-reading prefetch_cluster again */
> +                       barrier();
> +                       cluster >>= v->data_dev_block_bits;

Would:
  unsigned cluster = prefetch_cluster >> v->data_dev_block_bits;
not have similar behavior without a barrier?  (Yeah yeah I could
compile and see, but I was curious if you already had.)

Since the max iterations here is 61 in a worst-case, I don't think
it's a big deal to barrier() each time, just thought I'd ask.

> +                       if (unlikely(!cluster))
> +                               goto no_prefetch_cluster;
> +                       if (unlikely(cluster & (cluster - 1)))
> +                               cluster = 1 << (fls(cluster) - 1);
> +
> +                       hash_block_start &= ~(sector_t)(cluster - 1);
> +                       hash_block_end |= cluster - 1;
> +                       if (unlikely(hash_block_end >= v->hash_blocks))
> +                               hash_block_end = v->hash_blocks - 1;
> +               }
> +no_prefetch_cluster:
> +               dm_bufio_prefetch(v->bufio, hash_block_start,
> +                                       hash_block_end - hash_block_start + 1);
> +       }
> +}
> +
> +/*
> + * Bio map function. It allocates dm_verity_io structure and bio vector and
> + * fills them. Then it issues prefetches and the I/O.
> + */
> +static int verity_map(struct dm_target *ti, struct bio *bio,
> +                     union map_info *map_context)
> +{
> +       struct dm_verity *v = ti->private;
> +       struct dm_verity_io *io;
> +
> +       if (((unsigned)bio->bi_sector | bio_sectors(bio)) &
> +           ((1 << (v->data_dev_block_bits - SECTOR_SHIFT)) - 1)) {
> +               DMERR_LIMIT("unaligned io");
> +               return -EIO;
> +       }
> +
> +       if ((bio->bi_sector + bio_sectors(bio)) >>
> +           (v->data_dev_block_bits - SECTOR_SHIFT) > v->data_blocks) {
> +               DMERR_LIMIT("io out of range");
> +               return -EIO;
> +       }
> +
> +       if (bio_data_dir(bio) == WRITE)
> +               return -EIO;
> +
> +       io = mempool_alloc(v->io_mempool, GFP_NOIO);
> +       io->v = v;
> +       io->bio = bio;
> +       io->orig_bi_end_io = bio->bi_end_io;
> +       io->orig_bi_private = bio->bi_private;
> +       io->block = bio->bi_sector >> (v->data_dev_block_bits - SECTOR_SHIFT);
> +       io->n_blocks = bio->bi_size >> v->data_dev_block_bits;
> +
> +       bio->bi_end_io = verity_end_io;
> +       bio->bi_private = io;
> +       bio->bi_bdev = v->data_dev->bdev;
> +       bio->bi_sector = verity_map_sector(v, bio->bi_sector);
> +
> +       io->io_vec_size = bio->bi_vcnt - bio->bi_idx;
> +       if (io->io_vec_size < DM_VERITY_IO_VEC_INLINE)
> +               io->io_vec = io->io_vec_inline;
> +       else
> +               io->io_vec = mempool_alloc(v->vec_mempool, GFP_NOIO);
> +       memcpy(io->io_vec, bio_iovec(bio),
> +              io->io_vec_size * sizeof(struct bio_vec));
> +
> +       verity_prefetch_io(v, io);
> +
> +       generic_make_request(bio);
> +
> +       return DM_MAPIO_SUBMITTED;
> +}
> +
> +static int verity_status(struct dm_target *ti, status_type_t type,
> +                        char *result, unsigned maxlen)
> +{
> +       struct dm_verity *v = ti->private;
> +       unsigned sz = 0;
> +       unsigned x;
> +
> +       switch (type) {
> +       case STATUSTYPE_INFO:
> +               result[0] = 0;
> +               break;
> +       case STATUSTYPE_TABLE:
> +               DMEMIT("%u %s %s %llu %u %s ",
> +                       0,
> +                       v->data_dev->name,
> +                       v->hash_dev->name,

I understand the new approach is to use major:minor instead of the
device name.  I don't care which, but I believe agk@ requested that.

> +                       (unsigned long long)v->hash_start << (v->hash_dev_block_bits - SECTOR_SHIFT),
> +                       1 << v->data_dev_block_bits,
> +                       v->alg_name
> +                       );
> +               for (x = 0; x < v->digest_size; x++)
> +                       DMEMIT("%02x", v->root_digest[x]);
> +               DMEMIT(" ");
> +               if (!v->salt_size)
> +                       DMEMIT("-");
> +               else
> +                       for (x = 0; x < v->salt_size; x++)
> +                               DMEMIT("%02x", v->salt[x]);
> +               if (v->data_dev_block_bits != v->hash_dev_block_bits)
> +                       DMEMIT(" %u", 1 << v->hash_dev_block_bits);
> +               break;
> +       }
> +       return 0;
> +}
> +
> +static int verity_ioctl(struct dm_target *ti, unsigned cmd,
> +                       unsigned long arg)
> +{
> +       struct dm_verity *v = ti->private;
> +       int r = 0;
> +
> +       if (v->data_start ||
> +           ti->len != i_size_read(v->data_dev->bdev->bd_inode) >> SECTOR_SHIFT)
> +               r = scsi_verify_blk_ioctl(NULL, cmd);
> +

Is it worth supporting ioctl at all given these hoops?  Nothing stops
a privileged user from directly running the ioctl on the underlying
device/devices, it's just very inconvenient :)

> +       return r ? : __blkdev_driver_ioctl(v->data_dev->bdev, v->data_dev->mode,
> +                                    cmd, arg);
> +}
> +
> +static int verity_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> +                       struct bio_vec *biovec, int max_size)
> +{
> +       struct dm_verity *v = ti->private;
> +       struct request_queue *q = bdev_get_queue(v->data_dev->bdev);
> +
> +       if (!q->merge_bvec_fn)
> +               return max_size;
> +
> +       bvm->bi_bdev = v->data_dev->bdev;
> +       bvm->bi_sector = verity_map_sector(v, bvm->bi_sector);
> +
> +       return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> +}
> +
> +static int verity_iterate_devices(struct dm_target *ti,
> +                                 iterate_devices_callout_fn fn, void *data)
> +{
> +       struct dm_verity *v = ti->private;
> +       return fn(ti, v->data_dev, v->data_start, ti->len, data);
> +}
> +
> +static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
> +{
> +       struct dm_verity *v = ti->private;
> +
> +       if (limits->logical_block_size < 1 << v->data_dev_block_bits)
> +               limits->logical_block_size = 1 << v->data_dev_block_bits;
> +       if (limits->physical_block_size < 1 << v->data_dev_block_bits)
> +               limits->physical_block_size = 1 << v->data_dev_block_bits;
> +       blk_limits_io_min(limits, limits->logical_block_size);
> +}
> +
> +static void verity_dtr(struct dm_target *ti);
> +
> +static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
> +{
> +       struct dm_verity *v;
> +       unsigned num;
> +       unsigned long long hs;
> +       int r;
> +       int i;
> +       sector_t hash_position;
> +       char dummy;
> +
> +       v = kzalloc(sizeof(struct dm_verity), GFP_KERNEL);
> +       if (!v) {
> +               ti->error = "Cannot allocate verity structure";
> +               return -ENOMEM;
> +       }
> +       ti->private = v;
> +       v->ti = ti;
> +
> +       if ((dm_table_get_mode(ti->table) & ~FMODE_READ) != 0) {
> +               ti->error = "Device must be readonly";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +
> +       if (argc < 7) {
> +               ti->error = "Not enough arguments";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +
> +       if (sscanf(argv[0], "%d%c", &num, &dummy) != 1 ||
> +           num != 0) {
> +               ti->error = "Invalid version";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +
> +       r = dm_get_device(ti, argv[1], FMODE_READ, &v->data_dev);
> +       if (r) {
> +               ti->error = "Data device lookup failed";
> +               goto bad;
> +       }
> +
> +       r = dm_get_device(ti, argv[2], FMODE_READ, &v->hash_dev);
> +       if (r) {
> +               ti->error = "Data device lookup failed";
> +               goto bad;
> +       }
> +
> +       if (sscanf(argv[3], "%llu%c", &hs, &dummy) != 1 ||
> +           hs != (sector_t)hs) {
> +               ti->error = "Invalid hash start";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +
> +       if (sscanf(argv[4], "%u%c", &num, &dummy) != 1 ||
> +           !num || (num & (num - 1)) ||
> +           num < bdev_logical_block_size(v->data_dev->bdev) ||
> +           num > PAGE_SIZE) {
> +               ti->error = "Invalid data device block size";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +       v->data_dev_block_bits = ffs(num) - 1;
> +       v->hash_dev_block_bits = ffs(num) - 1;
> +
> +       v->alg_name = kstrdup(argv[5], GFP_KERNEL);
> +       if (!v->alg_name) {
> +               ti->error = "Cannot allocate algorithm name";
> +               r = -ENOMEM;
> +               goto bad;
> +       }
> +
> +       v->tfm = crypto_alloc_shash(v->alg_name, 0, 0);
> +       if (IS_ERR(v->tfm)) {
> +               ti->error = "Cannot initialize hash function";
> +               r = PTR_ERR(v->tfm);
> +               v->tfm = NULL;
> +               goto bad;
> +       }
> +       v->digest_size = crypto_shash_digestsize(v->tfm);
> +       if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
> +               ti->error = "Digest size too big";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +       v->shash_descsize =
> +               sizeof(struct shash_desc) + crypto_shash_descsize(v->tfm);
> +
> +       v->root_digest = kmalloc(v->digest_size, GFP_KERNEL);
> +       if (!v->root_digest) {
> +               ti->error = "Cannot allocate root digest";
> +               r = -ENOMEM;
> +               goto bad;
> +       }
> +       if (strlen(argv[6]) != v->digest_size * 2 ||
> +           hex2bin(v->root_digest, argv[6], v->digest_size)) {
> +               ti->error = "Invalid root digest";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +
> +       if (argc > 7 && strcmp(argv[7], "-")) {
> +               v->salt_size = strlen(argv[7]) / 2;
> +               v->salt = kmalloc(v->salt_size, GFP_KERNEL);
> +               if (!v->salt) {
> +                       ti->error = "Cannot allocate salt";
> +                       r = -ENOMEM;
> +                       goto bad;
> +               }
> +               if (strlen(argv[7]) != v->salt_size * 2 ||
> +                   hex2bin(v->salt, argv[7], v->salt_size)) {
> +                       ti->error = "Invalid salt";
> +                       r = -EINVAL;
> +                       goto bad;
> +               }
> +       }
> +
> +       if (argc > 8) {
> +               if (sscanf(argv[8], "%u%c", &num, &dummy) != 1 ||
> +                   !num || (num & (num - 1)) ||
> +                   num < bdev_logical_block_size(v->hash_dev->bdev) ||
> +                   num > INT_MAX) {
> +                       ti->error = "Invalid hash device block size";
> +                       r = -EINVAL;
> +                       goto bad;
> +               }
> +               v->hash_dev_block_bits = ffs(num) - 1;
> +       }
> +
> +       if (hs & ((1 << (v->hash_dev_block_bits - SECTOR_SHIFT)) - 1)) {
> +               ti->error = "Hash start not aligned on block boundary";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +       v->hash_start = hs >> (v->hash_dev_block_bits - SECTOR_SHIFT);
> +
> +       if (ti->len > i_size_read(v->data_dev->bdev->bd_inode) >> SECTOR_SHIFT) {
> +               ti->error = "Data device si too small";

s/si/is

Should this also check ti->start + ti->len to ensure it isn't reading
off the end or do you just rely on the requests failing?

> +               r = -EINVAL;
> +               goto bad;
> +       }
> +
> +       if (ti->len & ((1 << (v->data_dev_block_bits - SECTOR_SHIFT)) - 1)) {
> +               ti->error = "Data device length is not aligned to block size";
> +               r = -EINVAL;
> +               goto bad;
> +       }
> +
> +       v->data_blocks = ti->len >> (v->data_dev_block_bits - SECTOR_SHIFT);
> +
> +       v->hash_per_block_bits =
> +               fls((1 << v->hash_dev_block_bits) / v->digest_size) - 1;
> +
> +       v->levels = 0;
> +       if (v->data_blocks)
> +               while (v->hash_per_block_bits * v->levels < 64 &&
> +                      (unsigned long long)(v->data_blocks - 1) >>
> +                      (v->hash_per_block_bits * v->levels))
> +                       v->levels++;
> +
> +       if (v->levels > DM_VERITY_MAX_LEVELS) {
> +               ti->error = "Too many tree levels";
> +               r = -E2BIG;
> +               goto bad;
> +       }
> +
> +       hash_position = v->hash_start;
> +       for (i = v->levels - 1; i >= 0; i--) {
> +               sector_t s;
> +               v->hash_level_block[i] = hash_position;
> +               s = verity_position_at_level(v, v->data_blocks, i);
> +               s = (s >> v->hash_per_block_bits) +
> +                   !!(s & ((1 << v->hash_per_block_bits) - 1));
> +               if (hash_position + s < hash_position) {
> +                       ti->error = "Hash device offset overflow";
> +                       r = -E2BIG;
> +                       goto bad;
> +               }
> +               hash_position += s;
> +       }
> +       v->hash_blocks = hash_position;
> +
> +       v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
> +               1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
> +               dm_bufio_alloc_callback, NULL);
> +       if (IS_ERR(v->bufio)) {
> +               ti->error = "Cannot initialize dm-bufio";
> +               r = PTR_ERR(v->bufio);
> +               v->bufio = NULL;
> +               goto bad;
> +       }
> +
> +       if (dm_bufio_get_device_size(v->bufio) < v->hash_blocks) {
> +               ti->error = "Hash device is too small";
> +               r = -E2BIG;
> +               goto bad;
> +       }
> +
> +       v->io_mempool = mempool_create_kmalloc_pool(DM_VERITY_MEMPOOL_SIZE,
> +         sizeof(struct dm_verity_io) + v->shash_descsize + v->digest_size * 2);
> +       if (!v->io_mempool) {
> +               ti->error = "Cannot allocate io mempool";
> +               r = -ENOMEM;
> +               goto bad;
> +       }
> +
> +       v->vec_mempool = mempool_create_kmalloc_pool(DM_VERITY_MEMPOOL_SIZE,
> +                                       BIO_MAX_PAGES * sizeof(struct bio_vec));
> +       if (!v->vec_mempool) {
> +               ti->error = "Cannot allocate vector mempool";
> +               r = -ENOMEM;
> +               goto bad;
> +       }
> +
> +       /*v->verify_wq = alloc_workqueue("verityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 1);*/
> +       /* WQ_UNBOUND greatly improves performance when running on ramdisk */
> +       v->verify_wq = alloc_workqueue("verityd", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus());
> +       if (!v->verify_wq) {
> +               ti->error = "Cannot allocate workqueue";
> +               r = -ENOMEM;
> +               goto bad;
> +       }
> +
> +       return 0;
> +
> +bad:
> +       verity_dtr(ti);
> +       return r;
> +}
> +
> +static void verity_dtr(struct dm_target *ti)
> +{
> +       struct dm_verity *v = ti->private;
> +
> +       if (v->verify_wq)
> +               destroy_workqueue(v->verify_wq);
> +       if (v->vec_mempool)
> +               mempool_destroy(v->vec_mempool);
> +       if (v->io_mempool)
> +               mempool_destroy(v->io_mempool);
> +       if (v->bufio)
> +               dm_bufio_client_destroy(v->bufio);
> +       kfree(v->salt);
> +       kfree(v->root_digest);
> +       if (v->tfm)
> +               crypto_free_shash(v->tfm);
> +       kfree(v->alg_name);
> +       if (v->hash_dev)
> +               dm_put_device(ti, v->hash_dev);
> +       if (v->data_dev)
> +               dm_put_device(ti, v->data_dev);
> +       kfree(v);
> +}
> +
> +static struct target_type verity_target = {
> +       .name           = "verity",
> +       .version        = {1, 0, 0},
> +       .module         = THIS_MODULE,
> +       .ctr            = verity_ctr,
> +       .dtr            = verity_dtr,
> +       .map            = verity_map,
> +       .status         = verity_status,
> +       .ioctl          = verity_ioctl,
> +       .merge          = verity_merge,
> +       .iterate_devices = verity_iterate_devices,
> +       .io_hints       = verity_io_hints,
> +};
> +
> +static int __init dm_verity_init(void)
> +{
> +       int r;
> +       r = dm_register_target(&verity_target);
> +       if (r < 0)
> +               DMERR("register failed %d", r);
> +       return r;
> +}
> +
> +static void __exit dm_verity_exit(void)
> +{
> +       dm_unregister_target(&verity_target);
> +}
> +
> +module_init(dm_verity_init);
> +module_exit(dm_verity_exit);
> +
> +MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");

As per linux/module.h, I'd welcome additional authors as per the
lkml/patch lineage:
MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
MODULE_AUTHOR("Will Drewry <wad@chromium.org>");

Regardless, I'll just be happy to see this functionality merge.

> +MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity checking");
> +MODULE_LICENSE("GPL");
> +
> Index: linux-3.3-rc6-fast/drivers/md/dm-bufio.c

This should be in a separate patch I think.

> ===================================================================
> --- linux-3.3-rc6-fast.orig/drivers/md/dm-bufio.c       2012-03-12 22:43:23.000000000 +0100
> +++ linux-3.3-rc6-fast/drivers/md/dm-bufio.c    2012-03-13 15:41:02.000000000 +0100
[snip]
> @@ -882,6 +888,19 @@ static struct dm_buffer *__bufio_new(str
>
>        b = __find(c, block);
>        if (b) {
> +found_buffer:
> +               if (nf == NF_PREFETCH)
> +                       return NULL;
> +               /*
> +                * Note: it is essential that we don't wait for the buffer to be
> +                * read if dm_bufio_get function is used. Both dm_bufio_get and
> +                * dm_bufio_prefetch can be used in the driver request routine.
> +                * If the user called both dm_bufio_prefetch and dm_bufio_get on
> +                * the same buffer, it would deadlock if we waited.
> +                */
> +               if (nf == NF_GET && unlikely(test_bit(B_READING, &b->state)))
> +                       return NULL;
> +
>                b->hold_count++;

Are these hold_counts safe on architectures with weak memory models?
Should they be atomic_ts?   I haven't looked at them in context, but
based on what I see here they make me a bit nervous.

Thanks for jumping in to the fray!  None of my comments are blocking,
so I believe the following is appropriate (if not
s/Signed-off/Reviewed-by/).

Signed-off-by: Will Drewry <wad@chromium.org>

cheers!
will
