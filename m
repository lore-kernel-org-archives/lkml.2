Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2KZOkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:40:17 -0500
Received: from mga05.intel.com ([192.55.52.89]:50877 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754814Ab2KZOkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:40:05 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org
Subject: [PATCHv2 1/1] dm-integrity: integrity protection device-mapper target
Date: Mon, 26 Nov 2012 16:39:52 +0200
Message-Id: <57b73d4add302ff6ae79d81f817c09407aaf111c.1353940203.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1353940203.git.dmitry.kasatkin@intel.com>
References: <cover.1353940203.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1353940203.git.dmitry.kasatkin@intel.com>
References: <cover.1353940203.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device-mapper "integrity" target provides transparent cryptographic integrity
protection of the underlying read-write block device using hash-based message
authentication codes (HMACs). HMACs can be stored on the same or different
block device.

dm-integrity uses an encrypted key type, stored on the kernel keyring, to
obtain a secret key for use in cryptographic operations. Encrypted keys are
never exposed in plain text to user space. The encrypted keys are encrypted
using master key, which can either be a user defined or trusted key type.
The secret key, which is usually device specific, binds integrity data to the
device. As a result data blocks and corresponding HMACs cannot simply be
copied over from other file systems.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 Documentation/device-mapper/dm-integrity.txt |  137 ++++
 drivers/md/Kconfig                           |   13 +
 drivers/md/Makefile                          |    1 +
 drivers/md/dm-integrity.c                    | 1050 ++++++++++++++++++++++++++
 4 files changed, 1201 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-integrity.txt
 create mode 100644 drivers/md/dm-integrity.c

diff --git a/Documentation/device-mapper/dm-integrity.txt b/Documentation/device-mapper/dm-integrity.txt
new file mode 100644
index 0000000..394242f
--- /dev/null
+++ b/Documentation/device-mapper/dm-integrity.txt
@@ -0,0 +1,137 @@
+dm-integrity
+===============
+
+Device-mapper "integrity" target provides transparent cryptographic integrity
+protection of the underlying read-write block device using hash-based message
+authentication codes (HMACs). HMACs can be stored on the same or different
+block device.
+
+dm-integrity uses an encrypted key type, stored on the kernel keyring, to
+obtain a secret key for use in cryptographic operations. Encrypted keys are
+never exposed in plain text to user space. The encrypted keys are encrypted
+using master key, which can either be a user defined or trusted key type.
+The secret key, which is usually device specific, binds integrity data to the
+device. As a result data blocks and corresponding HMACs cannot simply be
+copied over from other file systems.
+
+Parameters:
+<dev> <bs> <start> <hdev> <hbs> <hstart> <hash_algo> <hmac_algo> <key_desc> \
+[<opt_params>]
+
+<dev>
+    This is the device that is going to be used to store the data.
+    You can specify it as a path like /dev/xxx or a device <major>:<minor>
+    number.
+
+<bs>
+    Device block size.
+    
+<start>
+    Starting sector within the device where data begins.
+
+<hdev>
+    This is the device that is going to be used to store integrity data.
+    You can specify it as a path like /dev/xxx or a device <major>:<minor>
+    number.
+
+<hbs>
+    HMAC device block size.
+    
+<hstart>
+    Starting sector within the device where integrity data begins.
+
+<hash_algo>
+    Hash algorithm (sha1, sha256, etc).
+    
+<hmac_algo>
+    HMAC algorithm, e.g. hmac(sha1), hmac(sha256), etc.
+    
+<key_desc> 
+    Description is a name of a key in the kernel keyring.
+
+<opt_params>
+    fix=1|0 - enable fix mode
+		In fix mode, incorrect hmacs are replaced with correct ones.
+    		It is used for device initialization and debugging.
+
+    stats=1|0 - turns on collecting additional statistical information.
+		It is used to find out resource usage to tune memory pool
+		and queue sizes for particular use case.
+    
+    verbose=1|0 - prints block number, collected hmac and stored hmac.
+		It is used for addition debug output.
+    
+
+Determine the size of integrity/hmac device
+===============
+
+Every block device has corresponding hmac.
+While NIST does recommend to use sha256 hash algorithm instead of SHA1,
+this does not apply to hmac(sha1), because of keying. It is safe to use
+hmac(sha1), because it takes much less space and it is faster to calculate.
+hmac(sha1) size is 20 bytes. So every 4k block on the integrity device can
+store 204 hmacs. In order to get the required size of the integrity device,
+it is necessary to divide data device size by 204. See examples bellow how
+to do it from script.
+
+Example scripts
+===============
+
+1. Setting up integrity target using data and hmac store on the same block device.
+
+[[
+#!/bin/sh
+
+bdev=$1
+
+# block device size
+dsize=`blockdev --getsize $bdev`
+# block size
+bs=4096
+# sector to block shift
+sbs=3
+# integrity record size (hmac size)
+hmac=20
+# hmacs per block
+hpb=$((bs/hmac))
+# target device size
+size=$((((dsize>>sbs)*hpb/(hpb+1))<<sbs))
+
+# load the key - in this example we just use test key
+keyctl add user kmk "testing123" @u
+keyctl add encrypted dm-int-key "load `cat /etc/keys/dm-int-key`" @u
+
+# creating the target
+table="0 $size integrity $bdev 4096 0 $bdev 4096 $size sha1 hmac(sha1) dm-int-key"
+dmsetup create dm-int --table "$table"
+
+# mounting
+mount /dev/mapper/dm-int /mnt
+
+]]
+
+2. Setting up integrity target using data and hmac store on different block devices.
+
+[[
+#!/bin/sh
+
+bdev=$1
+hdev=$2
+
+# get size of the block device
+dsize=`blockdev --getsz $bdev`
+# round down the size to 4k blocks
+dsize=$((dsize & ~7))
+
+# load the key - in this example we just use test key
+keyctl add user kmk "testing123" @u
+keyctl add encrypted dm-int-key "load `cat /etc/keys/dm-int-key`" @u
+
+# creating the target
+table="0 $dsize integrity $bdev 4096 0 $hdev 4096 0 sha1 hmac(sha1) dm-int-key"
+dmsetup create dm-int --table "$table"
+
+# mounting
+mount /dev/mapper/dm-int /mnt
+
+]]
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 91a02ee..42249c1 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -388,6 +388,19 @@ config DM_VERITY
 	  To compile this code as a module, choose M here: the module will
 	  be called dm-verity.
 
+config DM_INTEGRITY
+	tristate "Integrity target support"
+	depends on BLK_DEV_DM
+	select CRYPTO
+	select CRYPTO_HMAC
+	select DM_BUFIO
+	select KEYS
+	---help---
+	  If you say Y here, then your ...
+
+	  To compile this as a module, choose M here: the module
+	  will be called dm-integrity.
+
 	  If unsure, say N.
 
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 94dce8b..49b212f 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_DM_PERSISTENT_DATA)	+= persistent-data/
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_INTEGRITY)	+= dm-integrity.o
 obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm-thin-pool.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
new file mode 100644
index 0000000..3b3a27e
--- /dev/null
+++ b/drivers/md/dm-integrity.c
@@ -0,0 +1,1050 @@
+/*
+ * dm-integrity - device mapper integrity target
+ *
+ * Copyright (C) 2012, Intel Corporation.
+ *
+ * Author: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#define DM_MSG_PREFIX KBUILD_MODNAME
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
+
+#include "dm.h"
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/slab.h>
+#include <linux/device-mapper.h>
+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <crypto/sha.h>
+#include <crypto/hash.h>
+#include <keys/encrypted-type.h>
+#include <linux/wait.h>
+#include <linux/reboot.h>
+
+#include "dm-bufio.h"
+
+#define DM_INT_STATS
+
+#define DM_INT_MIN_IOS		16
+#define DM_INT_BLOCK_SIZE	PAGE_SIZE
+#define DM_INT_MAX_KEY_SIZE	128
+
+/* best parameters for fastest Ubuntu boot */
+#define DM_INT_PREFETCH_COUNT	16
+#define DM_INT_FLUSH_DELAY	(HZ * 3)	/* bufio flush delay */
+
+struct ahash_result {
+	struct completion completion;
+	int err;
+};
+
+struct dm_int_io {
+	struct dm_int *dmi;	/* mapping it belongs to */
+	struct bio *bio;
+	struct work_struct work;
+
+#define DM_INT_BIO_DONE		1
+#define DM_INT_VERIFIED		2
+#define DM_INT_HMAC_DONE	3
+	unsigned long flags;
+
+	atomic_t count;
+	int error;
+
+	sector_t sector;
+
+	bio_end_io_t *bi_end_io;	/* original bio callback */
+	void *bi_private;	/* original bio private data */
+	unsigned int bi_size;
+
+	struct ahash_request req;
+};
+
+/*
+ * integrity mapping configuration
+ */
+struct dm_int {
+	struct dm_target *target;
+	struct dm_dev *dev;
+	char *table_string;
+	loff_t start;
+	struct dm_dev *hdev;
+	loff_t hmac_start;
+	loff_t hmac_count;
+
+	struct mutex mutex;	/* lock the store */
+
+	struct workqueue_struct *io_queue;
+	struct kmem_cache *io_cache;
+	mempool_t *io_pool;
+
+	struct crypto_ahash *ahash;
+	struct crypto_shash *hmac;
+
+	struct list_head list;	/* global list */
+
+	struct dm_bufio_client *bufio;
+
+	unsigned int hmac_size;
+	unsigned int data_block_size;
+	unsigned int data_block_bits;
+	unsigned int hmac_block_size;
+	unsigned int hmac_block_bits;
+	unsigned int hmac_per_block;
+	unsigned int hmac_block_shift;
+	unsigned int delay;	/* hmac sync delay */
+
+#define DM_INT_FLAGS_FIX	0x01	/* fix wrong hmacs */
+#ifdef DM_INT_STATS
+#define DM_INT_FLAGS_STATS	0x02	/* calc stats */
+#else
+/* setting to 0 will eliminate the code due to optimization */
+#define DM_INT_FLAGS_STATS	0x00
+#endif
+#define DM_INT_FLAGS_VERBOSE	0x04	/* show failed blocks */
+	unsigned int flags;
+
+	atomic_t count;		/* total reference count */
+	wait_queue_head_t wait;	/* for close */
+	atomic_t violations;
+
+	/* stats */
+#ifdef DM_INT_STATS
+	atomic_t io_count;
+	int io_count_max;
+	atomic_t data_write_count;
+	atomic_t data_read_count;
+#endif
+};
+
+static DEFINE_MUTEX(mutex);
+static LIST_HEAD(dmi_list);
+static int sync_mode;
+
+static void dm_int_queue_hmac(struct dm_int_io *io);
+
+/*
+ * Get the key from the TPM for the HMAC
+ */
+static int dm_int_init_crypto(struct dm_int *dmi, const char *hash_algo,
+			      const char *hmac_algo, const char *keyname)
+{
+	struct key *key;
+	struct encrypted_key_payload *ekp;
+	int err = -EINVAL;
+
+	dmi->ahash = crypto_alloc_ahash(hash_algo, 0, 0);
+	if (IS_ERR(dmi->ahash)) {
+		err = PTR_ERR(xchg(&dmi->ahash, NULL));
+		DMERR("failed to load %s algorithm: %d\n", hash_algo, err);
+		dmi->target->error = "Cannot allocate hash algorithm";
+		return err;
+	}
+
+	dmi->hmac = crypto_alloc_shash(hmac_algo, 0, 0);
+	if (IS_ERR(dmi->hmac)) {
+		err = PTR_ERR(xchg(&dmi->hmac, NULL));
+		DMERR("failed to load %s algorithm: %d\n", hmac_algo, err);
+		dmi->target->error = "Cannot allocate hash algorithm";
+		return err;
+	}
+
+	key = request_key(&key_type_encrypted, keyname, NULL);
+	if (IS_ERR(key)) {
+		dmi->target->error = "Invalid key name";
+		return -ENOENT;
+	}
+
+	down_read(&key->sem);
+	ekp = key->payload.data;
+	if (ekp->decrypted_datalen <= DM_INT_MAX_KEY_SIZE)
+		err = crypto_shash_setkey(dmi->hmac, ekp->decrypted_data,
+					  ekp->decrypted_datalen);
+
+	/* burn the original key contents */
+	/*memset(ekp->decrypted_data, 0, ekp->decrypted_datalen); */
+	up_read(&key->sem);
+	key_put(key);
+
+	return err;
+}
+
+static void dm_int_io_get(struct dm_int_io *io)
+{
+	struct dm_int *dmi = io->dmi;
+
+	atomic_inc(&io->count);
+	atomic_inc(&dmi->count);
+
+	pr_debug("entered: io: %p, pending %d/%d\n",
+		 io, atomic_read(&io->count), atomic_read(&dmi->count));
+}
+
+static void dm_int_io_put(struct dm_int_io *io)
+{
+	struct dm_int *dmi = io->dmi;
+	struct bio *bio = io->bio;
+	int err = io->error;
+
+	pr_debug("entered: io: %p, pending %d/%d\n",
+		 io, atomic_read(&io->count), atomic_read(&dmi->count));
+
+	atomic_dec(&dmi->count);
+
+	if (!atomic_dec_and_test(&io->count))
+		return;
+
+	/* request has completed */
+	if (!err && test_bit(DM_INT_BIO_DONE, &io->flags) &&
+	    !test_bit(DM_INT_VERIFIED, &io->flags)) {
+		/* io->count will be 1 */
+		pr_debug("queue to verify: %p\n", io);
+		dm_int_queue_hmac(io);
+		return;
+	}
+
+	pr_debug("io done: err: %d, io: %d/%d\n",
+		 err, atomic_read(&io->count), atomic_read(&dmi->count));
+
+	mempool_free(io, dmi->io_pool);
+
+	bio_endio(bio, err);	/* finally completed, end main bio */
+
+	if (dmi->flags & DM_INT_FLAGS_STATS)
+		atomic_dec(&dmi->io_count);
+
+	if (err)
+		DMERR("ERROR: io done: %d\n", err);
+
+	wake_up_all(&dmi->wait);
+}
+
+static void dm_int_prefetch(struct dm_int_io *io)
+{
+	struct dm_int *dmi = io->dmi;
+	loff_t first, last, data;
+	loff_t offset;
+
+	/* block number to read */
+	offset = io->sector << SECTOR_SHIFT;
+	data = offset >> dmi->data_block_bits;
+	if (dmi->hmac_block_shift)
+		first = data >> dmi->hmac_block_shift;
+	else {
+		first = data;
+		sector_div(first, dmi->hmac_per_block);
+	}
+
+	/* offset to the last byte of data */
+	offset += (io->bi_size - 1);
+	data = offset >> dmi->data_block_bits;
+	if (dmi->hmac_block_shift)
+		last = data >> dmi->hmac_block_shift;
+	else  {
+		last = data;
+		sector_div(last, dmi->hmac_per_block);
+	}
+
+	/* prefetch multiple of DM_INT_PREFETCH_COUNT */
+	first = round_down(first, DM_INT_PREFETCH_COUNT);
+	last = round_up(last + 1, DM_INT_PREFETCH_COUNT);
+	/* check the end of the device */
+	if (last > dmi->hmac_count)
+		last = dmi->hmac_count;
+
+	dm_bufio_prefetch(dmi->bufio, dmi->hmac_start + first, last - first);
+}
+
+static int dm_int_verify_hmac(struct dm_int_io *io, loff_t offset,
+			      u8 *collected, int update)
+{
+	struct dm_int *dmi = io->dmi;
+	loff_t block, data = offset >> dmi->data_block_bits;
+	unsigned int index;
+	u8 *digest;
+	int err = 0;
+	struct dm_buffer *buf;
+
+	if (dmi->hmac_block_shift) {
+		block = data >> dmi->hmac_block_shift;
+		index = data & ((1 << dmi->hmac_block_shift) - 1);
+	} else {
+		block = data;
+		index = sector_div(block, dmi->hmac_per_block);
+	}
+
+	pr_debug("hmac: block: %llu, index: %u\n", block, index);
+
+	digest = dm_bufio_read(dmi->bufio, dmi->hmac_start + block, &buf);
+	if (unlikely(IS_ERR(digest)))
+		return PTR_ERR(digest);
+
+	digest += dmi->hmac_size * index;
+
+	if (!update) {
+		err = memcmp(digest, collected, dmi->hmac_size);
+		if (err) {
+			err = -EIO;
+			/* update buffer and store it back */
+			atomic_inc(&dmi->violations);
+			if (dmi->flags & DM_INT_FLAGS_FIX) {
+				err = 0;
+				update = 1;
+			}
+			if (dmi->flags & DM_INT_FLAGS_VERBOSE) {
+				DMERR("ERROR: hmacs does not match\n");
+				DMERR("hmac: block: %llu, index: %u\n",
+				      block, index);
+				print_hex_dump(KERN_CRIT, "collected: ",
+					       0, 32, 1, collected, 20, 0);
+				print_hex_dump(KERN_CRIT, "hmac: ",
+					       0, 32, 1, digest, 20, 0);
+			}
+		}
+	}
+
+	if (update) {
+		memcpy(digest, collected, dmi->hmac_size);
+		dm_bufio_mark_buffer_dirty(buf);
+	}
+
+	dm_bufio_release(buf);
+
+	if (err)
+		DMERR_LIMIT("ERROR: HMACs do not match\n");
+
+	return err;
+}
+
+static void dm_int_ahash_complete(struct crypto_async_request *req, int err)
+{
+	struct ahash_result *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+	res->err = err;
+	complete(&res->completion);
+}
+
+static int dm_int_ahash_wait(int err, struct ahash_result *res)
+{
+	switch (err) {
+	case 0:
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		wait_for_completion(&res->completion);
+		err = res->err;
+		if (!res->err) {
+			INIT_COMPLETION(res->completion);
+			break;
+		}
+		/* fall through */
+	default:
+		DMERR("HMAC calculation failed: err: %d\n", err);
+	}
+
+	return err;
+}
+
+static int dm_int_calc_hmac(struct dm_int_io *io, loff_t offset,
+			    u8 *digest, unsigned int size, u8 *hmac)
+{
+	struct dm_int *dmi = io->dmi;
+	int err;
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(dmi->hmac)];
+	} desc;
+
+	desc.shash.tfm = dmi->hmac;
+	desc.shash.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = crypto_shash_init(&desc.shash);
+	if (!err)
+		err = crypto_shash_update(&desc.shash, digest, size);
+	if (!err)
+		err = crypto_shash_finup(&desc.shash, (u8 *)&offset,
+					  sizeof(offset), hmac);
+	if (err)
+		DMERR("ERROR: calc hmac failed: %d\n", err);
+	return err;
+}
+
+static void dm_int_verify_io(struct dm_int_io *io)
+{
+	struct dm_int *dmi = io->dmi;
+	struct bio *bio = io->bio;
+	struct bio_vec *bv;
+	int i, err = -EIO;
+	struct scatterlist sg[1];
+	u8 hmac[dmi->hmac_size];
+	u8 digest[crypto_ahash_digestsize(dmi->ahash)];
+	loff_t offset = io->sector << SECTOR_SHIFT;
+	unsigned int update = bio_data_dir(bio);
+	struct ahash_request *req = &io->req;
+	struct ahash_result res;
+	ssize_t size = io->bi_size;
+
+	init_completion(&res.completion);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				   CRYPTO_TFM_REQ_MAY_SLEEP,
+				   dm_int_ahash_complete, &res);
+
+	sg_init_table(sg, 1);
+
+	pr_debug("io: %p, sector: %llu, size: %d, vcnt: %d, idx: %d\n",
+		 io, (loff_t)io->sector,
+		 bio->bi_size, bio->bi_vcnt, bio->bi_idx);
+
+	bio_for_each_segment(bv, bio, i) {
+		pr_debug("bv: %d: offset: %llu, bv_offset: %d, bv_len: %d\n",
+			 i, offset, bv->bv_offset, bv->bv_len);
+
+		BUG_ON(bv->bv_offset & (dmi->data_block_size - 1));
+		BUG_ON(bv->bv_len & (dmi->data_block_size - 1));
+
+		sg_set_page(sg, bv->bv_page, bv->bv_len, bv->bv_offset);
+
+		ahash_request_set_crypt(req, sg, digest, bv->bv_len);
+
+		err = crypto_ahash_digest(req);
+		err = dm_int_ahash_wait(err, req->base.data);
+		if (err)
+			break;
+
+		err = dm_int_calc_hmac(io, offset, digest, sizeof(digest),
+				       hmac);
+		if (err)
+			break;
+
+		err = dm_int_verify_hmac(io, offset, hmac, update);
+		if (err)
+			break;
+
+		offset += bv->bv_len;
+		size -= bv->bv_len;
+	}
+
+	if (size)
+		DMERR("ERROR: size is not zero: %zd\n", size);
+
+	io->error = err;
+	set_bit(DM_INT_VERIFIED, &io->flags);
+
+	if (sync_mode)
+		dm_bufio_write_dirty_buffers(dmi->bufio);
+}
+
+static void dm_int_hmac_task(struct work_struct *work)
+{
+	struct dm_int_io *io = container_of(work, struct dm_int_io, work);
+
+	if (test_and_set_bit(DM_INT_HMAC_DONE, &io->flags))
+		dm_int_verify_io(io);
+	else
+		dm_int_prefetch(io);
+
+	dm_int_io_put(io);
+}
+
+static void dm_int_queue_hmac(struct dm_int_io *io)
+{
+	struct dm_int *dmi = io->dmi;
+	int ret;
+
+	/* what if it is queued already? */
+	dm_int_io_get(io);
+	ret = queue_work(dmi->io_queue, &io->work);
+	if (!ret)
+		dm_int_io_put(io);
+	BUG_ON(!ret);
+}
+
+static void dm_int_end_io(struct bio *bio, int err)
+{
+	struct dm_int_io *io = bio->bi_private;
+	struct dm_int *dmi = io->dmi;
+
+	pr_debug("io: %p, pending: %d/%d, sector: %llu, size: %u, "\
+		 "vcnt: %d, idx: %d\n", io,
+		 atomic_read(&io->count), atomic_read(&dmi->count),
+		 (loff_t)bio->bi_sector,
+		 bio->bi_size, bio->bi_vcnt, bio->bi_idx);
+
+	if (unlikely(!bio_flagged(bio, BIO_UPTODATE) && !err))
+		err = -EIO;
+
+	if (err)
+		DMERR("ERROR: bio io failed: %d\n", err);
+
+	if (unlikely(err))
+		io->error = err;
+
+	set_bit(DM_INT_BIO_DONE, &io->flags);
+
+	bio->bi_private = io->bi_private;
+	bio->bi_end_io = io->bi_end_io;
+
+	dm_int_io_put(io);
+}
+
+static void dm_int_start_io(struct dm_int_io *io)
+{
+	struct dm_int *dmi = io->dmi;
+	struct bio *bio = io->bio;
+
+	if (io->error)
+		return;
+
+	io->bi_private = bio->bi_private;
+	io->bi_end_io = bio->bi_end_io;
+
+	/* io->sector starts from 0 */
+	bio->bi_sector = dmi->start + io->sector;
+	bio->bi_bdev = dmi->dev->bdev;
+
+	bio->bi_private = io;
+	bio->bi_end_io = dm_int_end_io;
+
+	dm_int_io_get(io);
+
+	if (dmi->flags & DM_INT_FLAGS_STATS) {
+		if (bio_data_dir(bio) == READ)
+			atomic_inc(&dmi->data_read_count);
+		else
+			atomic_inc(&dmi->data_write_count);
+	}
+
+	generic_make_request(bio);
+}
+
+static struct dm_int_io *dm_int_io_alloc(struct dm_int *dmi,
+					 struct bio *bio, sector_t sector)
+{
+	struct dm_int_io *io;
+
+	/* never fails with GFP_NOIO */
+	io = mempool_alloc(dmi->io_pool, GFP_NOIO);
+	BUG_ON(!io);
+
+	io->dmi = dmi;
+	io->bio = bio;
+	io->bi_size = bio->bi_size;
+	io->sector = sector;
+	io->error = 0;
+	io->flags = 0;
+
+	INIT_WORK(&io->work, dm_int_hmac_task);
+
+	ahash_request_set_tfm(&io->req, dmi->ahash);
+
+	atomic_set(&io->count, 1);
+	atomic_inc(&dmi->count);
+
+	/* stats */
+	if (dmi->flags & DM_INT_FLAGS_STATS) {
+		atomic_inc(&dmi->io_count);
+		if (atomic_read(&dmi->io_count) > dmi->io_count_max)
+			dmi->io_count_max = atomic_read(&dmi->io_count);
+	}
+
+	return io;
+}
+
+static int dm_int_map(struct dm_target *ti, struct bio *bio,
+		      union map_info *map_context)
+{
+	struct dm_int *dmi = ti->private;
+	struct dm_int_io *io;
+
+	/*
+	 * If bio is REQ_FLUSH or REQ_DISCARD, just bypass crypt queues.
+	 * - for REQ_FLUSH device-mapper core ensures that no IO is in-flight
+	 * - for REQ_DISCARD caller must use flush if IO ordering matters
+	 */
+	if (unlikely(bio->bi_rw & (REQ_FLUSH | REQ_DISCARD))) {
+		bio->bi_bdev = dmi->dev->bdev;
+		bio->bi_sector =
+			dmi->start + dm_target_offset(ti, bio->bi_sector);
+		return DM_MAPIO_REMAPPED;
+	}
+
+	/* a check to see if something unhandled might come */
+	if (!bio->bi_size || !bio->bi_vcnt)
+		DMERR("bio without data: size: %d, vcnt: %d\n",
+		      bio->bi_size, bio->bi_vcnt);
+
+	BUG_ON(bio->bi_sector & (to_sector(dmi->data_block_size) - 1));
+	BUG_ON(bio->bi_size & (dmi->data_block_size - 1));
+
+	io = dm_int_io_alloc(dmi, bio, dm_target_offset(ti, bio->bi_sector));
+
+	pr_debug("io: %p, sector: %llu, size: %u, vcnt: %d, idx: %d\n",
+		 io, (loff_t)bio->bi_sector,
+		 bio->bi_size, bio->bi_vcnt, bio->bi_idx);
+
+	dm_int_start_io(io);
+	dm_int_queue_hmac(io);
+
+	dm_int_io_put(io);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static void dm_int_cleanup(struct dm_target *ti)
+{
+	struct dm_int *dmi = (struct dm_int *)ti->private;
+
+	if (dmi->bufio)
+		dm_bufio_client_destroy(dmi->bufio);
+	if (dmi->io_queue)
+		destroy_workqueue(dmi->io_queue);
+	if (dmi->io_pool)
+		mempool_destroy(dmi->io_pool);
+	if (dmi->io_cache)
+		kmem_cache_destroy(dmi->io_cache);
+	if (dmi->ahash)
+		crypto_free_ahash(dmi->ahash);
+	if (dmi->hmac)
+		crypto_free_shash(dmi->hmac);
+	if (dmi->hdev)
+		dm_put_device(ti, dmi->hdev);
+	if (dmi->dev)
+		dm_put_device(ti, dmi->dev);
+	kfree(dmi->table_string);
+	kfree(dmi);
+}
+
+/*
+ * Construct an integrity mapping:
+ * <dev> <bs> <start> <hdev> <hbs> <hstart> <hash_algo> <hmac_algo> <keyname> \
+ * [opt_params]
+ */
+static int dm_int_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct dm_int *dmi;
+	int err, io_size, i, count;
+	unsigned long long tmpll;
+	char table[256], dummy;
+	unsigned tmp;
+	fmode_t mode;
+	loff_t datadevsize, hmacdevsize, maxdatasize, maxhmacsize;
+
+	if (argc < 9) {
+		ti->error = "Invalid argument count";
+		return -EINVAL;
+	}
+
+	dmi = kzalloc(sizeof(*dmi), GFP_KERNEL);
+	if (dmi == NULL) {
+		ti->error = "dm-integrity: Cannot allocate linear context";
+		return -ENOMEM;
+	}
+
+	dmi->target = ti;
+	ti->private = dmi;
+
+	err = -EINVAL;
+
+	mode = dm_table_get_mode(ti->table);
+
+	if (dm_get_device(ti, argv[0], mode, &dmi->dev)) {
+		ti->error = "Device lookup failed";
+		goto err;
+	}
+
+	if (sscanf(argv[1], "%u%c", &tmp, &dummy) != 1 ||
+	   !is_power_of_2(tmp) ||
+	   tmp < bdev_logical_block_size(dmi->dev->bdev) ||
+	   tmp > PAGE_SIZE) {
+		ti->error = "Invalid device block size";
+		goto err;
+	}
+	dmi->data_block_size = tmp;
+	dmi->data_block_bits = ffs(dmi->data_block_size) - 1;
+
+	if (sscanf(argv[2], "%llu%c", &tmpll, &dummy) != 1) {
+		ti->error = "Invalid device start";
+		goto err;
+	}
+	dmi->start = tmpll;
+
+	if (dm_get_device(ti, argv[3], mode, &dmi->hdev)) {
+		ti->error = "HMAC device lookup failed";
+		goto err;
+	}
+
+	if (sscanf(argv[4], "%u%c", &tmp, &dummy) != 1 ||
+	   !is_power_of_2(tmp) ||
+	   tmp < bdev_logical_block_size(dmi->dev->bdev) ||
+	   tmp > PAGE_SIZE) {
+		ti->error = "Invalid device block size";
+		goto err;
+	}
+	dmi->hmac_block_size = tmp;
+	dmi->hmac_block_bits = ffs(dmi->hmac_block_size) - 1;
+
+	if (sscanf(argv[5], "%llu%c", &tmpll, &dummy) != 1) {
+		ti->error = "Invalid hmac device start";
+		goto err;
+	}
+	dmi->hmac_start = tmpll;
+
+	err = dm_int_init_crypto(dmi, argv[6], argv[7], argv[8]);
+	if (err)
+		goto err;
+
+	count = snprintf(table, sizeof(table), "%s %u %llu %s %u %llu %s %s %s",
+			 dmi->dev->name, dmi->data_block_size, dmi->start,
+			 dmi->hdev->name, dmi->hmac_block_size, dmi->hmac_start,
+			 argv[6], argv[7], argv[8]);
+
+	for (i = 9; i < argc; i++) {
+		count += snprintf(table + count, sizeof(table) - count,
+				  " %s", argv[i]);
+	}
+
+	dmi->table_string = kstrdup(table, GFP_KERNEL);
+
+	dmi->hmac_size = crypto_shash_digestsize(dmi->hmac);
+
+	/* how many hmacs do we need for data device */
+	dmi->hmac_count = ti->len >> (dmi->data_block_bits - SECTOR_SHIFT);
+
+	datadevsize = i_size_read(dmi->dev->bdev->bd_inode) >> SECTOR_SHIFT;
+	hmacdevsize = i_size_read(dmi->hdev->bdev->bd_inode) >> SECTOR_SHIFT;
+
+	err = -EINVAL;
+
+	if (dmi->start > datadevsize) {
+		DMERR("start sector is beyond device size: %llu (%llu)\n",
+		      dmi->start, datadevsize);
+		goto err;
+	}
+
+	if (dmi->hmac_start > hmacdevsize) {
+		DMERR("start sector is beyond device size: %llu (%llu)\n",
+		      dmi->hmac_start, hmacdevsize);
+		goto err;
+	}
+
+	if (dmi->dev->bdev == dmi->hdev->bdev) {
+		if (dmi->hmac_start > dmi->start) {
+			maxdatasize = dmi->hmac_start - dmi->start;
+			maxhmacsize = datadevsize - dmi->hmac_start;
+		} else {
+			maxhmacsize = dmi->start - dmi->hmac_start;
+			maxdatasize = datadevsize - dmi->start;
+		}
+	} else {
+		maxdatasize = datadevsize - dmi->start;
+		maxhmacsize = hmacdevsize - dmi->hmac_start;
+	}
+
+	if (ti->len > maxdatasize) {
+		DMERR("target size is too big: %llu (%llu)\n",
+		      (loff_t)ti->len, maxdatasize);
+		goto err;
+	}
+
+	/* hmac start in blocks */
+	dmi->hmac_start >>= (dmi->hmac_block_bits - SECTOR_SHIFT);
+
+	/* optimize for SHA256  which is 32 bytes */
+	if (is_power_of_2(dmi->hmac_size)) {
+		dmi->hmac_block_shift =
+			dmi->hmac_block_bits - (ffs(dmi->hmac_size) - 1);
+		/* how many hmac blocks do we need */
+		dmi->hmac_count >>= dmi->hmac_block_shift;
+	} else {
+		dmi->hmac_per_block = dmi->hmac_block_size / dmi->hmac_size;
+		/* how many hmac blocks do we need */
+		tmpll = sector_div(dmi->hmac_count, dmi->hmac_per_block);
+		if (tmpll)
+			dmi->hmac_count++;
+	}
+
+	/* device may hold as many hmac blocks */
+	maxhmacsize >>= (dmi->hmac_block_bits - SECTOR_SHIFT);
+
+	if (dmi->hmac_count > maxhmacsize) {
+		DMERR("HMAC device is too small: %llu (%llu)\n",
+		      dmi->hmac_count, maxhmacsize);
+		goto err;
+	}
+
+	ti->num_discard_requests = 1;
+
+	for (i = 9; i < argc; i++) {
+		if (!strcmp(argv[i], "fix"))
+			dmi->flags |= DM_INT_FLAGS_FIX;
+		else if (!strcmp(argv[i], "stats"))
+			dmi->flags |= DM_INT_FLAGS_STATS;
+		else if (!strcmp(argv[i], "verbose"))
+			dmi->flags |= DM_INT_FLAGS_VERBOSE;
+		else if (!strcmp(argv[i], "disallow_discards"))
+			ti->num_discard_requests = 0;
+	}
+
+	err = -ENOMEM;
+
+	io_size = sizeof(struct dm_int_io);
+	io_size += crypto_ahash_reqsize(dmi->ahash);
+	dmi->io_cache = kmem_cache_create("dm_int_io_cache", io_size,
+					  __alignof__(struct dm_int_io), 0,
+					  NULL);
+	if (!dmi->io_cache) {
+		ti->error = "Cannot allocate dm_int io cache";
+		goto err;
+	}
+
+	dmi->io_pool = mempool_create_slab_pool(DM_INT_MIN_IOS, dmi->io_cache);
+	if (!dmi->io_pool) {
+		ti->error = "Cannot allocate dm_int io mempool";
+		goto err;
+	}
+
+	dmi->io_queue = alloc_workqueue("dm_int_hmac",
+					  WQ_CPU_INTENSIVE |
+					  WQ_HIGHPRI |
+					  WQ_UNBOUND |
+					  WQ_MEM_RECLAIM,
+					  1);
+	if (!dmi->io_queue) {
+		ti->error = "Couldn't create dm_int hmac queue";
+		goto err;
+	}
+
+	dmi->bufio = dm_bufio_client_create(dmi->hdev->bdev,
+					    dmi->hmac_block_size, 1, 0,
+					    NULL, NULL);
+	if (IS_ERR(dmi->bufio)) {
+		ti->error = "Cannot initialize dm-bufio";
+		err = PTR_ERR(xchg(&dmi->bufio, NULL));
+		goto err;
+	}
+
+	mutex_init(&dmi->mutex);
+	dmi->delay = DM_INT_FLUSH_DELAY;
+	init_waitqueue_head(&dmi->wait);
+
+	ti->num_flush_requests = 1;
+	/* it should depend on read block device... */
+	/*ti->discard_zeroes_data_unsupported = true;*/
+
+	mutex_lock(&mutex);
+	list_add(&dmi->list, &dmi_list);
+	mutex_unlock(&mutex);
+
+	return 0;
+
+err:
+	dm_int_cleanup(ti);
+	return err;
+}
+
+static void dm_int_dtr(struct dm_target *ti)
+{
+	struct dm_int *dmi = (struct dm_int *)ti->private;
+
+	mutex_lock(&mutex);
+	list_del(&dmi->list);
+	mutex_unlock(&mutex);
+
+	dm_int_cleanup(ti);
+}
+
+static void dm_int_sync(struct dm_int *dmi)
+{
+	/* first flush hmac queue, which might schedule idata delayed work */
+	flush_workqueue(dmi->io_queue);
+	/* write all updated hmac blocks */
+	dm_bufio_write_dirty_buffers(dmi->bufio);
+
+	if (atomic_read(&dmi->count))
+		DMWARN("dmi->count: %d\n", atomic_read(&dmi->count));
+	/* wait until all idata bios complete */
+	wait_event(dmi->wait, !atomic_read(&dmi->count));
+}
+
+static int dm_int_ioctl(struct dm_target *ti, unsigned int cmd,
+			unsigned long arg)
+{
+	struct dm_int *dmi = (struct dm_int *)ti->private;
+	struct dm_dev *dev = dmi->dev;
+	int err = 0;
+
+	if (cmd == BLKFLSBUF)
+		dm_int_sync(dmi);
+
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (dmi->start ||
+	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
+		err = scsi_verify_blk_ioctl(NULL, cmd);
+
+	return err ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
+}
+
+static int dm_int_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+			struct bio_vec *biovec, int max_size)
+{
+	struct dm_int *dmi = ti->private;
+	struct request_queue *q = bdev_get_queue(dmi->dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = dmi->dev->bdev;
+	bvm->bi_sector = dmi->start + dm_target_offset(ti, bvm->bi_sector);
+
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
+static int dm_int_iterate_devices(struct dm_target *ti,
+				  iterate_devices_callout_fn fn, void *data)
+{
+	struct dm_int *dmi = ti->private;
+
+	return fn(ti, dmi->dev, dmi->start, ti->len, data);
+}
+
+static void dm_int_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct dm_int *dmi = ti->private;
+
+	limits->logical_block_size = dmi->data_block_size;
+	limits->physical_block_size = dmi->data_block_size;
+	blk_limits_io_min(limits, dmi->data_block_size);
+}
+
+static void dm_int_postsuspend(struct dm_target *ti)
+{
+	struct dm_int *dmi = ti->private;
+
+	dm_int_sync(dmi);
+
+	DMINFO("%s suspended\n", dm_device_name(dm_table_get_md(ti->table)));
+}
+
+static int dm_int_status(struct dm_target *ti, status_type_t type,
+			 unsigned status_flags, char *result, unsigned maxlen)
+{
+	struct dm_int *dmi = (struct dm_int *)ti->private;
+	unsigned int sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+#ifdef DM_INT_STATS
+		DMEMIT("pending: %d, io: %d (%d), "\
+		       "read: %d, write: %d, "\
+		       "violations: %d",
+		       atomic_read(&dmi->count),
+		       atomic_read(&dmi->io_count), dmi->io_count_max,
+		       atomic_read(&dmi->data_read_count),
+		       atomic_read(&dmi->data_write_count),
+		       atomic_read(&dmi->violations));
+#else
+		DMEMIT("pending: %d, violations: %d",
+		       atomic_read(&dmi->count),
+		       atomic_read(&dmi->violations));
+#endif
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s", dmi->table_string);
+		break;
+	}
+	return 0;
+}
+
+static struct target_type dm_int_target = {
+	.name = "integrity",
+	.version = {0, 1, 0},
+	.module = THIS_MODULE,
+	.ctr = dm_int_ctr,
+	.dtr = dm_int_dtr,
+	.map = dm_int_map,
+	.status = dm_int_status,
+	.ioctl = dm_int_ioctl,
+	.postsuspend = dm_int_postsuspend,
+	.merge = dm_int_merge,
+	.iterate_devices = dm_int_iterate_devices,
+	.io_hints = dm_int_io_hints,
+};
+
+static int dm_int_notify_reboot(struct notifier_block *this,
+				unsigned long code, void *x)
+{
+	struct dm_int *dmi;
+
+	if ((code == SYS_DOWN) || (code == SYS_HALT) ||
+						(code == SYS_POWER_OFF)) {
+		sync_mode = 1;
+		mutex_lock(&mutex);
+		if (!list_empty(&dmi_list)) {
+			DMINFO("syncing targets...");
+			list_for_each_entry(dmi, &dmi_list, list)
+				dm_int_sync(dmi);
+			pr_cont(" done.\n");
+		}
+		mutex_unlock(&mutex);
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block dm_int_notifier = {
+	.notifier_call	= dm_int_notify_reboot,
+	.next		= NULL,
+	.priority	= INT_MAX, /* before any real devices */
+};
+
+int __init dm_int_init(void)
+{
+	int err = -ENOMEM;
+
+	err = dm_register_target(&dm_int_target);
+	if (err < 0) {
+		DMERR("register failed %d", err);
+		return err;
+	}
+
+	/* always returns 0 */
+	register_reboot_notifier(&dm_int_notifier);
+
+	return 0;
+}
+
+void dm_int_exit(void)
+{
+	unregister_reboot_notifier(&dm_int_notifier);
+	dm_unregister_target(&dm_int_target);
+}
+
+/* Module hooks */
+module_init(dm_int_init);
+module_exit(dm_int_exit);
+
+MODULE_DESCRIPTION(DM_NAME " integrity target");
+MODULE_AUTHOR("Dmitry Kasatkin");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

