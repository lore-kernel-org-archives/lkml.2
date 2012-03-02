Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab2CBAei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:34:38 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:36403 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab2CBAef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:34:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of msb@google.com designates 10.101.136.21 as permitted sender) smtp.mail=msb@google.com
MIME-Version: 1.0
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Alasdair G Kergon <agk@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>,
        Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: verity target
Date: Thu,  1 Mar 2012 16:33:13 -0800
Message-Id: <1330648393-20692-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The verity target provides transparent integrity checking of block devices
using a cryptographic digest.

dm-verity is meant to be setup as part of a verified boot path.  This
may be anything ranging from a boot using tboot or trustedgrub to just
booting from a known-good device (like a USB drive or CD).

dm-verity is part of ChromeOS's verified boot path. It is used to verify
the integrity of the root filesystem on boot. The root filesystem is
mounted on a dm-verity partition which transparently verifies each block
with a bootloader verified hash passed into the kernel at boot.

Changes in V5:
* https://lkml.org/lkml/2012/2/29/421 (Mikulas Patocka)
  * Fixed off-by-one error.
  * Added support for filesystems bigger than 4G (bug fix).
* https://lkml.org/lkml/2012/2/29/426 (Andrew Morton)
  * Fixed checkpatch errors/warning.
  * Made code cpu-hotplug-aware.
  * Remove NULL check before calling kfree.
  * No longer checking __GFP_WAIT allocations.
  * Propogate io->error instead of always EIO.
  * Remove unneeded and undesirable casts of void.
  * Use DMERR_LIMIT on io errors to avoid spamming dmesg.
  * Flush workqueue on rmmod.
Changes in V4:
* Discussion over phone (Alasdair G Kergon)
 * copy _ioctl fix from dm-linear
 * verity_status format fixes to match dm conventions
 * s/dm-bht/verity_tree
 * put everything into dm-verity.c
 * ctr changed to dm conventions
 * use hex2bin
 * use conventional dm names for function
  * s/dm_//
  * for example: verity_ctr versus dm_verity_ctr
 * use per_cpu API
Changes in V3:
* Discussion over irc (Alasdair G Kergon)
  * Implement ioctl hook
Changes in V2:
* https://lkml.org/lkml/2011/11/10/85 (Steffen Klassert)
  * Use shash API instead of older hash API

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Elly Jones <ellyjones@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Cc: Olof Johansson <olofj@chromium.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
---
 Documentation/device-mapper/verity.txt |  149 ++++
 drivers/md/Kconfig                     |   16 +
 drivers/md/Makefile                    |    1 +
 drivers/md/dm-verity.c                 | 1367 ++++++++++++++++++++++++++++++++
 4 files changed, 1533 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/verity.txt
 create mode 100644 drivers/md/dm-verity.c

diff --git a/Documentation/device-mapper/verity.txt b/Documentation/device-mapper/verity.txt
new file mode 100644
index 0000000..b631f12
--- /dev/null
+++ b/Documentation/device-mapper/verity.txt
@@ -0,0 +1,149 @@
+dm-verity
+==========
+
+Device-Mapper's "verity" target provides transparent integrity checking of
+block devices using a cryptographic digest provided by the kernel crypto API.
+This target is read-only.
+
+Parameters:
+    <version> <dev> <hash_dev> <hash_start> <block_size> <alg> <digest> <salt>
+
+<version>
+    This is the version number of the on-disk format. Currently, there is
+    only version 0.
+
+<dev>
+    This is the device that is going to be integrity checked.  It may be
+    a subset of the full device as specified to dmsetup (start sector and count)
+    It may be specified as a path, like /dev/sdaX, or a device number,
+    <major>:<minor>.
+
+<hash_dev>
+    This is the device that that supplies the hash tree data.  It may be
+    specified similarly to the device path and may be the same device.  If the
+    same device is used, the hash offset should be outside of the dm-verity
+    configured device size.
+
+<hash_start>
+    This is the offset, in 512-byte sectors, from the start of hash_dev to
+    the root block of the hash tree.
+
+<block_size>
+    The size of a hash block. Also, the size of a block to be hashed.
+
+<alg>
+    The cryptographic hash algorithm used for this device.  This should
+    be the name of the algorithm, like "sha1".
+
+<digest>
+    The hexadecimal encoding of the cryptographic hash of all of the
+    neighboring nodes at the first level of the tree.  This hash should be
+    trusted as there is no other authenticity beyond this point.
+
+<salt>
+    The hexadecimal encoding of the salt value.
+
+Theory of operation
+===================
+
+dm-verity is meant to be setup as part of a verified boot path.  This
+may be anything ranging from a boot using tboot or trustedgrub to just
+booting from a known-good device (like a USB drive or CD).
+
+When a dm-verity device is configured, it is expected that the caller
+has been authenticated in some way (cryptographic signatures, etc).
+After instantiation, all hashes will be verified on-demand during
+disk access.  If they cannot be verified up to the root node of the
+tree, the root hash, then the I/O will fail.  This should identify
+tampering with any data on the device and the hash data.
+
+Cryptographic hashes are used to assert the integrity of the device on a
+per-block basis.  This allows for a lightweight hash computation on first read
+into the page cache.  Block hashes are stored linearly aligned to the nearest
+block the size of a page.
+
+Hash Tree
+---------
+
+Each node in the tree is a cryptographic hash.  If it is a leaf node, the hash
+is of some block data on disk.  If it is an intermediary node, then the hash is
+of a number of child nodes.
+
+Each entry in the tree is a collection of neighboring nodes that fit in one
+block.  The number is determined based on block_size and the size of the
+selected cryptographic digest algorithm.  The hashes are linearly ordered in
+this entry and any unaligned trailing space is ignored but included when
+calculating the parent node.
+
+The tree looks something like:
+
+alg = sha256, num_blocks = 32768, block_size = 4096
+
+                                 [   root    ]
+                                /    . . .    \
+                     [entry_0]                 [entry_1]
+                    /  . . .  \                 . . .   \
+         [entry_0_0]   . . .  [entry_0_127]    . . . .  [entry_1_127]
+           / ... \             /   . . .  \             /           \
+     blk_0 ... blk_127  blk_16256   blk_16383      blk_32640 . . . blk_32767
+
+On-disk format
+==============
+
+Below is the recommended on-disk format. The verity kernel code does not
+read the on-disk header. It only reads the hash blocks which directly
+follow the header. It is expected that a user-space tool will verify the
+integrity of the verity_header and then call dm_setup with the correct
+parameters. Alternatively, the header can be omitted and the dm_setup
+parameters can be passed via the kernel command-line in a rooted chain
+of trust where the command-line is verified.
+
+The on-disk format is especially useful in cases where the hash blocks
+are on a separate partition. The magic number allows easy identification
+of the partition contents. Alternatively, the hash blocks can be stored
+in the same partition as the data to be verified. In such a configuration
+the filesystem on the partition would be sized a little smaller than
+the full-partition, leaving room for the hash blocks.
+
+struct verity_header {
+       uint64_t magic = 0x7665726974790a00;
+       uint32_t version;
+       uint32_t block_size;
+       char digest[128]; /* in hex-ascii, null-terminated or 128-bytes */
+       char salt[128]; /* in hex-ascii, null-terminated or 128-bytes */
+}
+
+struct verity_header_block {
+	struct verity_header;
+	char unused[block_size - sizeof(struct verity_header) - sizeof(sig)];
+	char sig[128]; /* in hex-ascii, null-terminated or 128-bytes */
+}
+
+Directly following the header are the hash blocks which are stored a depth
+at a time (starting from the root), sorted in order of increasing index.
+
+Usage
+=====
+
+The API provides mechanisms for reading and verifying a tree. When reading, all
+required data for the hash tree should be populated for a block before
+attempting a verify.  This can be done by calling dm_bht_populate().  When all
+data is ready, a call to dm_bht_verify_block() with the expected hash value will
+perform both the direct block hash check and the hashes of the parent and
+neighboring nodes where needed to ensure validity up to the root hash.  Note,
+dm_bht_set_root_hexdigest() should be called before any verification attempts
+occur.
+
+Example
+=======
+
+Setup a device;
+[[
+  dmsetup create vroot --table \
+    "0 204800 verity /dev/sda1 /dev/sda2 alg=sha1 "\
+    "root_hexdigest=9f74809a2ee7607b16fcc70d9399a4de9725a727"
+]]
+
+A command line tool is available to compute the hash tree and return the
+root hash value.
+  http://git.chromium.org/cgi-bin/gitweb.cgi?p=dm-verity.git;a=tree
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index faa4741..b8bb690 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -370,4 +370,20 @@ config DM_FLAKEY
        ---help---
          A target that intermittently fails I/O for debugging purposes.
 
+config DM_VERITY
+        tristate "Verity target support"
+        depends on BLK_DEV_DM
+        select CRYPTO
+        select CRYPTO_HASH
+        ---help---
+          This device-mapper target allows you to create a device that
+          transparently integrity checks the data on it. You'll need to
+          activate the digests you're going to use in the cryptoapi
+          configuration.
+
+          To compile this code as a module, choose M here: the module will
+          be called dm-verity.
+
+          If unsure, say N.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 046860c..70a29af 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_PERSISTENT_DATA)	+= persistent-data/
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
+obj-$(CONFIG_DM_VERITY)         += dm-verity.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm-thin-pool.o
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
new file mode 100644
index 0000000..b72f350
--- /dev/null
+++ b/drivers/md/dm-verity.c
@@ -0,0 +1,1367 @@
+/*
+ * Originally based on dm-crypt.c,
+ * Copyright (C) 2003 Christophe Saout <christophe@saout.de>
+ * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
+ * Copyright (C) 2006-2008 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2012 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *                    All Rights Reserved.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Implements a verifying transparent block device.
+ * See Documentation/device-mapper/verity.txt
+ */
+#include <crypto/hash.h>
+#include <linux/atomic.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/genhd.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mempool.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/device-mapper.h>
+
+
+#define DM_MSG_PREFIX "verity"
+
+
+/* Helper for printing sector_t */
+#define ULL(x) ((unsigned long long)(x))
+
+#define MIN_IOS 32
+#define MIN_BIOS (MIN_IOS * 2)
+
+/* To avoid allocating memory for digest tests, we just setup a
+ * max to use for now.
+ */
+#define VERITY_MAX_DIGEST_SIZE 64   /* Supports up to 512-bit digests */
+#define VERITY_SALT_SIZE       32   /* 256 bits of salt is a lot */
+
+/* UNALLOCATED, PENDING, READY, and VERIFIED are valid states. All other
+ * values are entry-related return codes.
+ */
+#define VERITY_TREE_ENTRY_VERIFIED 8  /* 'nodes' checked against parent */
+#define VERITY_TREE_ENTRY_READY 4  /* 'nodes' is loaded and available */
+#define VERITY_TREE_ENTRY_PENDING 2  /* 'nodes' is being loaded */
+#define VERITY_TREE_ENTRY_UNALLOCATED 0 /* untouched */
+#define VERITY_TREE_ENTRY_ERROR -1 /* entry is unsuitable for use */
+#define VERITY_TREE_ENTRY_ERROR_IO -2 /* I/O error on load */
+
+/* Additional possible return codes */
+#define VERITY_TREE_ENTRY_ERROR_MISMATCH -3 /* Digest mismatch */
+
+
+struct verity_io {
+	struct dm_target *target;
+	struct bio *bio;
+	struct delayed_work work;
+	unsigned int flags;
+
+	int error;
+	atomic_t pending;
+
+	u64 block;  /* aligned block index */
+	u64 count;  /* aligned count in blocks */
+};
+
+/* verity_tree_entry
+ * Contains verity_tree->node_count tree nodes at a given tree depth.
+ * state is used to transactionally assure that data is paged in
+ * from disk.  Unless verity_tree kept running crypto contexts for each
+ * level, we need to load in the data for on-demand verification.
+ */
+struct verity_tree_entry {
+	atomic_t state; /* see defines */
+	/* Keeping an extra pointer per entry wastes up to ~33k of
+	 * memory if a 1m blocks are used (or 66 on 64-bit arch)
+	 */
+	struct verity_io *io_context;  /* Reserve a pointer for use during io */
+	/* data should only be non-NULL if fully populated. */
+	void *nodes;  /* The hash data used to verify the children.
+		       * Guaranteed to be page-aligned.
+		       */
+};
+
+/* verity_tree_level
+ * Contains an array of entries which represent a page of hashes where
+ * each hash is a node in the tree at the given tree depth/level.
+ */
+struct verity_tree_level {
+	struct verity_tree_entry *entries;  /* array of entries of tree nodes */
+	unsigned int count;  /* number of entries at this level */
+	sector_t sector;  /* starting sector for this level */
+};
+
+/* opaque context, start, databuf, sector_count */
+typedef int(*verity_tree_callback)(void *,  /* external context */
+			      sector_t,  /* start sector */
+			      u8 *,  /* destination page */
+			      sector_t,  /* num sectors */
+			      struct verity_tree_entry *);
+/* verity_tree - Device mapper block hash tree
+ * verity_tree provides a fixed interface for comparing data blocks
+ * against a cryptographic hashes stored in a hash tree. It
+ * optimizes the tree structure for storage on disk.
+ *
+ * The tree is built from the bottom up.  A collection of data,
+ * external to the tree, is hashed and these hashes are stored
+ * as the blocks in the tree.  For some number of these hashes,
+ * a parent node is created by hashing them.  These steps are
+ * repeated.
+ */
+struct verity_tree {
+	/* Configured values */
+	int depth;  /* Depth of the tree including the root */
+	unsigned int block_size;  /* Size of a hash block */
+	u64 block_count;  /* Number of blocks hashed */
+	char hash_alg[CRYPTO_MAX_ALG_NAME];
+	u8 salt[VERITY_SALT_SIZE];
+
+	/* Computed values */
+	unsigned int node_count;  /* Data size (in hashes) for each entry */
+	unsigned int node_count_shift;  /* first bit set - 1 */
+	struct crypto_shash *tfm; /* hash for this device */
+	unsigned int hash_desc_size;
+	sector_t sectors;  /* Number of disk sectors used */
+	u8 digest[VERITY_MAX_DIGEST_SIZE];
+	unsigned int digest_size;
+
+	struct verity_tree_level *levels;
+
+	/* Callback for reading from the hash device */
+	verity_tree_callback read_cb;
+};
+
+/* per-requested-bio private data */
+enum verity_io_flags {
+	VERITY_IOFLAGS_CLONED = 0x1,	/* original bio has been cloned */
+};
+
+struct verity_config {
+	struct dm_dev *dev;
+	sector_t start;
+	sector_t size;
+
+	struct dm_dev *hash_dev;
+	sector_t hash_start;
+
+	struct verity_tree vt;
+
+	/* Pool required for io contexts */
+	mempool_t *io_pool;
+	/* Pool and bios required for making sure that backing device reads are
+	 * in PAGE_SIZE increments.
+	 */
+	struct bio_set *bs;
+
+	char hash_alg[CRYPTO_MAX_ALG_NAME];
+};
+
+
+static struct kmem_cache *_verity_io_pool;
+static struct workqueue_struct *kveritydq, *kverityd_ioq;
+
+static DEFINE_PER_CPU(struct shash_desc *, verity_hash_desc);
+static DEFINE_PER_CPU(unsigned int, verity_hash_size);
+
+static void kverityd_verify(struct work_struct *work);
+static void kverityd_io(struct work_struct *work);
+static void kverityd_io_vt_populate(struct verity_io *io);
+static void kverityd_io_vt_populate_end(struct bio *, int error);
+
+
+/*
+ * Utilities
+ */
+
+static void bin2hex(char *dst, const u8 *src, size_t count)
+{
+	while (count-- > 0) {
+		sprintf(dst, "%02hhx", (int)*src);
+		dst += 2;
+		src++;
+	}
+}
+
+/*
+ * Verity Tree
+ */
+
+/* Functions for converting indices to nodes. */
+
+static inline unsigned int verity_tree_get_level_shift(struct verity_tree *vt,
+						  int depth)
+{
+	return (vt->depth - depth) * vt->node_count_shift;
+}
+
+/* For the given depth, this is the entry index.  At depth+1 it is the node
+ * index for depth.
+ */
+static inline u64 verity_tree_index_at_level(struct verity_tree *vt,
+					     int depth, u64 leaf)
+{
+	return leaf >> verity_tree_get_level_shift(vt, depth);
+}
+
+static inline struct verity_tree_entry *verity_tree_get_entry(
+		struct verity_tree *vt,
+		int depth, u64 block)
+{
+	u64 index = verity_tree_index_at_level(vt, depth, block);
+	struct verity_tree_level *level = &vt->levels[depth];
+
+	return &level->entries[index];
+}
+
+static inline void *verity_tree_get_node(struct verity_tree *vt,
+					 struct verity_tree_entry *entry,
+					 int depth, unsigned int block)
+{
+	u64 index = verity_tree_index_at_level(vt, depth, block);
+	unsigned int node_index = (unsigned int)index % vt->node_count;
+
+	return entry->nodes + (node_index * vt->digest_size);
+}
+
+/**
+ * verity_tree_compute_hash: hashes a page of data
+ */
+static int verity_tree_compute_hash(struct verity_tree *vt, struct page *pg,
+				    unsigned int offset, u8 *digest)
+{
+	struct shash_desc **hash_descp = &__get_cpu_var(verity_hash_desc);
+	unsigned int *hash_sizep = &__get_cpu_var(verity_hash_size);
+	struct shash_desc *hash_desc;
+	void *data;
+	int err;
+
+	if (!*hash_descp || *hash_sizep < vt->hash_desc_size) {
+		kfree(*hash_descp);
+		*hash_descp = kmalloc(vt->hash_desc_size, GFP_KERNEL);
+		*hash_sizep = vt->hash_desc_size;
+	}
+	hash_desc = *hash_descp;
+	hash_desc->tfm = vt->tfm;
+	hash_desc->flags = 0x0;
+
+	if (crypto_shash_init(hash_desc)) {
+		DMCRIT("failed to reinitialize crypto hash (proc:%d)",
+			smp_processor_id());
+		return -EINVAL;
+	}
+	data = kmap_atomic(pg);
+	err = crypto_shash_update(hash_desc, data + offset, PAGE_SIZE);
+	kunmap_atomic(data);
+	if (err) {
+		DMCRIT("crypto_hash_update failed");
+		return -EINVAL;
+	}
+	if (crypto_shash_update(hash_desc, vt->salt, sizeof(vt->salt))) {
+		DMCRIT("crypto_hash_update failed");
+		return -EINVAL;
+	}
+	if (crypto_shash_final(hash_desc, digest)) {
+		DMCRIT("crypto_hash_final failed");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int verity_tree_initialize_entries(struct verity_tree *vt)
+{
+	/* last represents the index of the last digest store in the tree.
+	 * By walking the tree with that index, it is possible to compute the
+	 * total number of entries at each level.
+	 *
+	 * Since each entry will contain up to |node_count| nodes of the tree,
+	 * it is possible that the last index may not be at the end of a given
+	 * entry->nodes.  In that case, it is assumed the value is padded.
+	 *
+	 * Note, we treat both the tree root (1 hash) and the tree leaves
+	 * independently from the vt data structures.  Logically, the root is
+	 * depth=-1 and the block layer level is depth=vt->depth
+	 */
+	u64 last = vt->block_count - 1;
+	int depth;
+
+	/* check that the largest level->count can't result in an int overflow
+	 * on allocation or sector calculation.
+	 */
+	if (((last >> vt->node_count_shift) + 1) >
+	    UINT_MAX / max_t(unsigned long,
+			     sizeof(struct verity_tree_entry),
+			     (unsigned long)to_sector(vt->block_size))) {
+		DMCRIT("required entries %llu is too large", vt->block_count);
+		return -EINVAL;
+	}
+
+	/* Track the current sector location for each level so we don't have to
+	 * compute it during traversals.
+	 */
+	vt->sectors = 0;
+	for (depth = 0; depth < vt->depth; ++depth) {
+		struct verity_tree_level *level = &vt->levels[depth];
+
+		level->count = verity_tree_index_at_level(vt, depth, last) + 1;
+		level->entries = kcalloc(level->count,
+					 sizeof(struct verity_tree_entry),
+					 GFP_KERNEL);
+		if (!level->entries) {
+			DMERR("failed to allocate entries for depth %d", depth);
+			return -ENOMEM;
+		}
+		level->sector = vt->sectors;
+		vt->sectors += level->count * to_sector(vt->block_size);
+	}
+
+	return 0;
+}
+
+/**
+ * verity_tree_create - prepares @vt for us
+ * @vt:	          pointer to a verity_tree_create()d vt
+ * @depth:	  tree depth without the root; including block hashes
+ * @block_count:  the number of block hashes / tree leaves
+ * @alg_name:	  crypto hash algorithm name
+ *
+ * Returns 0 on success.
+ *
+ * Callers can offset into devices by storing the data in the io callbacks.
+ */
+static int verity_tree_create(struct verity_tree *vt, u64 block_count,
+			      unsigned int block_size, const char *alg_name)
+{
+	int status = 0;
+
+	vt->block_size = block_size;
+	/* Verify that PAGE_SIZE >= block_size >= SECTOR_SIZE. */
+	if ((block_size > PAGE_SIZE) ||
+	    (PAGE_SIZE % block_size) ||
+	    (to_sector(block_size) == 0))
+		return -EINVAL;
+
+	vt->tfm = crypto_alloc_shash(alg_name, 0, 0);
+	if (IS_ERR(vt->tfm)) {
+		DMERR("failed to allocate crypto hash '%s'", alg_name);
+		return -ENOMEM;
+	}
+	vt->hash_desc_size = sizeof(struct shash_desc) +
+		crypto_shash_descsize(vt->tfm);
+
+	vt->digest_size = crypto_shash_digestsize(vt->tfm);
+	/* We expect to be able to pack >=2 hashes into a block */
+	if (block_size / vt->digest_size < 2) {
+		DMERR("too few hashes fit in a block");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	if (vt->digest_size > VERITY_MAX_DIGEST_SIZE) {
+		DMERR("VERITY_MAX_DIGEST_SIZE too small for digest");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	/* Configure the tree */
+	vt->block_count = block_count;
+	if (block_count == 0) {
+		DMERR("block_count must be non-zero");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	/* Each verity_tree_entry->nodes is one block.  The node code tracks
+	 * how many nodes fit into one entry where a node is a single
+	 * hash (message digest).
+	 */
+	vt->node_count_shift = fls(block_size / vt->digest_size) - 1;
+	/* Round down to the nearest power of two.  This makes indexing
+	 * into the tree much less painful.
+	 */
+	vt->node_count = 1 << vt->node_count_shift;
+
+	/* This is unlikely to happen, but with 64k pages, who knows. */
+	if (vt->node_count > UINT_MAX / vt->digest_size) {
+		DMERR("node_count * hash_len exceeds UINT_MAX!");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	vt->depth = DIV_ROUND_UP(fls64(block_count - 1), vt->node_count_shift);
+
+	/* Ensure that we can safely shift by this value. */
+	if (vt->depth * vt->node_count_shift >= sizeof(unsigned int) * 8) {
+		DMERR("specified depth and node_count_shift is too large");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	/* Allocate levels. Each level of the tree may have an arbitrary number
+	 * of verity_tree_entry structs.  Each entry contains node_count nodes.
+	 * Each node in the tree is a cryptographic digest of either node_count
+	 * nodes on the subsequent level or of a specific block on disk.
+	 */
+	vt->levels = kcalloc(vt->depth,
+			     sizeof(struct verity_tree_level), GFP_KERNEL);
+
+	vt->read_cb = NULL;
+
+	status = verity_tree_initialize_entries(vt);
+	if (status)
+		goto bad_entries_alloc;
+
+	/* We compute depth such that there is only be 1 block at level 0. */
+	BUG_ON(vt->levels[0].count != 1);
+
+	return 0;
+
+bad_entries_alloc:
+	while (vt->depth-- > 0)
+		kfree(vt->levels[vt->depth].entries);
+	kfree(vt->levels);
+bad_arg:
+	crypto_free_shash(vt->tfm);
+	return status;
+}
+
+/**
+ * verity_tree_read_completed
+ * @entry:   pointer to the entry that's been loaded
+ * @status:  I/O status. Non-zero is failure.
+ * MUST always be called after a read_cb completes.
+ */
+static void verity_tree_read_completed(struct verity_tree_entry *entry,
+				       int status)
+{
+	if (status) {
+		DMCRIT("an I/O error occurred while reading entry");
+		atomic_set(&entry->state, VERITY_TREE_ENTRY_ERROR_IO);
+		return;
+	}
+	BUG_ON(atomic_read(&entry->state) != VERITY_TREE_ENTRY_PENDING);
+	atomic_set(&entry->state, VERITY_TREE_ENTRY_READY);
+}
+
+/**
+ * verity_tree_verify_block - checks that all path nodes for @block are valid
+ * @vt:	     pointer to a verity_tree_create()d vt
+ * @block:   specific block data is expected from
+ * @pg:	     page holding the block data
+ * @offset:  offset into the page
+ *
+ * Returns 0 on success, VERITY_TREE_ENTRY_ERROR_MISMATCH on error.
+ */
+static int verity_tree_verify_block(struct verity_tree *vt, unsigned int block,
+				    struct page *pg, unsigned int offset)
+{
+	int state, depth = vt->depth;
+	u8 digest[VERITY_MAX_DIGEST_SIZE];
+	struct verity_tree_entry *entry;
+	void *node;
+
+	do {
+		/* Need to check that the hash of the current block is accurate
+		 * in its parent.
+		 */
+		entry = verity_tree_get_entry(vt, depth - 1, block);
+		state = atomic_read(&entry->state);
+		/* This call is only safe if all nodes along the path
+		 * are already populated (i.e. READY) via verity_tree_populate.
+		 */
+		BUG_ON(state < VERITY_TREE_ENTRY_READY);
+		node = verity_tree_get_node(vt, entry, depth, block);
+
+		if (verity_tree_compute_hash(vt, pg, offset, digest) ||
+		    memcmp(digest, node, vt->digest_size))
+			goto mismatch;
+
+		/* Keep the containing block of hashes to be verified in the
+		 * next pass.
+		 */
+		pg = virt_to_page(entry->nodes);
+		offset = offset_in_page(entry->nodes);
+	} while (--depth > 0 && state != VERITY_TREE_ENTRY_VERIFIED);
+
+	if (depth == 0 && state != VERITY_TREE_ENTRY_VERIFIED) {
+		if (verity_tree_compute_hash(vt, pg, offset, digest) ||
+		    memcmp(digest, vt->digest, vt->digest_size))
+			goto mismatch;
+		atomic_set(&entry->state, VERITY_TREE_ENTRY_VERIFIED);
+	}
+
+	/* Mark path to leaf as verified. */
+	for (depth++; depth < vt->depth; depth++) {
+		entry = verity_tree_get_entry(vt, depth, block);
+		/* At this point, entry can only be in VERIFIED or READY state.
+		 * So it is safe to use atomic_set instead of atomic_cmpxchg.
+		 */
+		atomic_set(&entry->state, VERITY_TREE_ENTRY_VERIFIED);
+	}
+
+	return 0;
+
+mismatch:
+	DMERR_LIMIT("verify_path: failed to verify hash (d=%d,bi=%u)",
+		    depth, block);
+	return VERITY_TREE_ENTRY_ERROR_MISMATCH;
+}
+
+/**
+ * verity_tree_is_populated - check that nodes needed to verify a given
+ *                            block are all ready
+ * @vt:	    pointer to a verity_tree_create()d vt
+ * @block:  specific block data is expected from
+ *
+ * Callers may wish to call verity_tree_is_populated() when checking an io
+ * for which entries were already pending.
+ */
+static bool verity_tree_is_populated(struct verity_tree *vt, unsigned int block)
+{
+	int depth;
+
+	for (depth = vt->depth - 1; depth >= 0; depth--) {
+		struct verity_tree_entry *entry;
+		entry = verity_tree_get_entry(vt, depth, block);
+		if (atomic_read(&entry->state) < VERITY_TREE_ENTRY_READY)
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * verity_tree_populate - reads entries from disk needed to verify a given block
+ * @vt:     pointer to a verity_tree_create()d vt
+ * @ctx:    context used for all read_cb calls on this request
+ * @block:  specific block data is expected from
+ *
+ * Returns negative value on error. Returns 0 on success.
+ */
+static int verity_tree_populate(struct verity_tree *vt, void *ctx,
+				unsigned int block)
+{
+	int depth, state;
+
+	BUG_ON(block >= vt->block_count);
+
+	for (depth = vt->depth - 1; depth >= 0; --depth) {
+		struct verity_tree_level *level;
+		struct verity_tree_entry *entry;
+		u64 index;
+
+		index = verity_tree_index_at_level(vt, depth, block);
+		level = &vt->levels[depth];
+		entry = verity_tree_get_entry(vt, depth, block);
+		state = atomic_cmpxchg(&entry->state,
+				       VERITY_TREE_ENTRY_UNALLOCATED,
+				       VERITY_TREE_ENTRY_PENDING);
+		if (state == VERITY_TREE_ENTRY_VERIFIED)
+			break;
+		if (state <= VERITY_TREE_ENTRY_ERROR)
+			goto error_state;
+		if (state != VERITY_TREE_ENTRY_UNALLOCATED)
+			continue;
+
+		/* Current entry is claimed for allocation and loading */
+		entry->nodes = kmalloc(vt->block_size, GFP_NOIO);
+
+		vt->read_cb(ctx,
+			    level->sector + to_sector(index * vt->block_size),
+			    entry->nodes, to_sector(vt->block_size), entry);
+	}
+
+	return 0;
+
+error_state:
+	DMCRIT("block %u at depth %d is in an error state", block, depth);
+	return -EPERM;
+}
+
+/**
+ * verity_tree_destroy - cleans up all memory used by @vt
+ * @vt:	 pointer to a verity_tree_create()d vt
+ */
+static void verity_tree_destroy(struct verity_tree *vt)
+{
+	int depth;
+
+	for (depth = 0; depth < vt->depth; depth++) {
+		struct verity_tree_entry *entry = vt->levels[depth].entries;
+		struct verity_tree_entry *entry_end = entry +
+			vt->levels[depth].count;
+		for (; entry < entry_end; ++entry)
+			kfree(entry->nodes);
+		kfree(vt->levels[depth].entries);
+	}
+	kfree(vt->levels);
+	crypto_free_shash(vt->tfm);
+}
+
+/*
+ * Verity Tree Accessors
+ */
+
+/**
+ * verity_tree_set_digest - sets an unverified root digest hash from hex
+ * @vt:	     pointer to a verity_tree_create()d vt
+ * @digest:  string containing the digest in hex
+ * Returns non-zero on error.
+ */
+static int verity_tree_set_digest(struct verity_tree *vt, const char *digest)
+{
+	/* Make sure we have at least the bytes expected */
+	if (strnlen(digest, vt->digest_size * 2) != vt->digest_size * 2) {
+		DMERR("root digest length does not match hash algorithm");
+		return -1;
+	}
+	return hex2bin(vt->digest, digest, vt->digest_size);
+}
+
+/**
+ * verity_tree_digest - returns root digest in hex
+ * @vt:	     pointer to a verity_tree_create()d vt
+ * @digest:  buffer to put into, must be of length VERITY_SALT_SIZE * 2 + 1.
+ */
+int verity_tree_digest(struct verity_tree *vt, char *digest)
+{
+	bin2hex(digest, vt->digest, vt->digest_size);
+	return 0;
+}
+
+/**
+ * verity_tree_set_salt - sets the salt
+ * @vt:    pointer to a verity_tree_create()d vt
+ * @salt:  string containing the salt in hex
+ * Returns non-zero on error.
+ */
+int verity_tree_set_salt(struct verity_tree *vt, const char *salt)
+{
+	size_t saltlen = min(strlen(salt) / 2, sizeof(vt->salt));
+	memset(vt->salt, 0, sizeof(vt->salt));
+	return hex2bin(vt->salt, salt, saltlen);
+}
+
+
+/**
+ * verity_tree_salt - returns the salt in hex
+ * @vt:    pointer to a verity_tree_create()d vt
+ * @salt:  buffer to put salt into, of length VERITY_SALT_SIZE * 2 + 1.
+ */
+int verity_tree_salt(struct verity_tree *vt, char *salt)
+{
+	bin2hex(salt, vt->salt, sizeof(vt->salt));
+	return 0;
+}
+
+/*
+ * Allocation and utility functions
+ */
+
+static void kverityd_src_io_read_end(struct bio *clone, int error);
+
+/* Shared destructor for all internal bios */
+static void verity_bio_destructor(struct bio *bio)
+{
+	struct verity_io *io = bio->bi_private;
+	struct verity_config *vc = io->target->private;
+	bio_free(bio, vc->bs);
+}
+
+static struct bio *verity_alloc_bioset(struct verity_config *vc, gfp_t gfp_mask,
+				       int nr_iovecs)
+{
+	return bio_alloc_bioset(gfp_mask, nr_iovecs, vc->bs);
+}
+
+static struct verity_io *verity_io_alloc(struct dm_target *ti,
+					    struct bio *bio)
+{
+	struct verity_config *vc = ti->private;
+	sector_t sector = bio->bi_sector - ti->begin;
+	struct verity_io *io;
+	u64 tmp;
+
+	io = mempool_alloc(vc->io_pool, GFP_NOIO);
+	io->flags = 0;
+	io->target = ti;
+	io->bio = bio;
+	io->error = 0;
+
+	/* Adjust the sector by the virtual starting sector */
+	tmp = (u64)to_bytes(1) * sector;
+	do_div(tmp, vc->vt.block_size);
+	io->block = tmp;
+	io->count = bio->bi_size / vc->vt.block_size;
+
+	atomic_set(&io->pending, 0);
+
+	return io;
+}
+
+static struct bio *verity_bio_clone(struct verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	struct bio *bio = io->bio;
+	struct bio *clone = verity_alloc_bioset(vc, GFP_NOIO, bio->bi_max_vecs);
+
+	__bio_clone(clone, bio);
+	clone->bi_private = io;
+	clone->bi_end_io  = kverityd_src_io_read_end;
+	clone->bi_bdev    = vc->dev->bdev;
+	clone->bi_sector += vc->start - io->target->begin;
+	clone->bi_destructor = verity_bio_destructor;
+
+	return clone;
+}
+
+/*
+ * Reverse flow of requests into the device.
+ *
+ * (Start at the bottom with verity_map and work your way upward).
+ */
+
+static void verity_inc_pending(struct verity_io *io);
+
+static void verity_return_bio_to_caller(struct verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+
+	bio_endio(io->bio, io->error);
+	mempool_free(io, vc->io_pool);
+}
+
+/* Check for any missing vt hashes. */
+static bool verity_is_vt_populated(struct verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	u64 block;
+
+	for (block = io->block; block < io->block + io->count; ++block)
+		if (!verity_tree_is_populated(&vc->vt, block))
+			return false;
+
+	return true;
+}
+
+/* verity_dec_pending manages the lifetime of all verity_io structs.
+ * Non-bug error handling is centralized through this interface and
+ * all passage from workqueue to workqueue.
+ */
+static void verity_dec_pending(struct verity_io *io)
+{
+	if (!atomic_dec_and_test(&io->pending))
+		goto done;
+
+	if (unlikely(io->error))
+		goto io_error;
+
+	/* I/Os that were pending may now be ready */
+	if (verity_is_vt_populated(io)) {
+		INIT_DELAYED_WORK(&io->work, kverityd_verify);
+		queue_delayed_work(kveritydq, &io->work, 0);
+	} else {
+		INIT_DELAYED_WORK(&io->work, kverityd_io);
+		queue_delayed_work(kverityd_ioq, &io->work, HZ/10);
+	}
+
+done:
+	return;
+
+io_error:
+	verity_return_bio_to_caller(io);
+}
+
+/* Walks the data set and computes the hash of the data read from the
+ * untrusted source device.  The computed hash is then passed to verity-tree
+ * for verification.
+ */
+static int verity_verify(struct verity_config *vc,
+			 struct verity_io *io)
+{
+	unsigned int block_size = vc->vt.block_size;
+	struct bio *bio = io->bio;
+	u64 block = io->block;
+	unsigned int idx;
+	int r;
+
+	for (idx = bio->bi_idx; idx < bio->bi_vcnt; idx++) {
+		struct bio_vec *bv = bio_iovec_idx(bio, idx);
+		unsigned int offset = bv->bv_offset;
+		unsigned int len = bv->bv_len;
+
+		BUG_ON(offset % block_size);
+		BUG_ON(len % block_size);
+
+		while (len) {
+			r = verity_tree_verify_block(&vc->vt, block,
+						bv->bv_page, offset);
+			if (r)
+				goto bad_return;
+
+			offset += block_size;
+			len -= block_size;
+			block++;
+			cond_resched();
+		}
+	}
+
+	return 0;
+
+bad_return:
+	/* verity_tree functions aren't expected to return errno friendly
+	 * values.  They are converted here for uniformity.
+	 */
+	if (r > 0) {
+		DMERR("Pending data for block %llu seen at verify", ULL(block));
+		r = -EBUSY;
+	} else {
+		DMERR_LIMIT("Block hash does not match!");
+		r = -EACCES;
+	}
+	return r;
+}
+
+/* Services the verify workqueue */
+static void kverityd_verify(struct work_struct *work)
+{
+	struct delayed_work *dwork = container_of(work, struct delayed_work,
+						  work);
+	struct verity_io *io = container_of(dwork, struct verity_io,
+					    work);
+	struct verity_config *vc = io->target->private;
+
+	io->error = verity_verify(vc, io);
+
+	/* Free up the bio and tag with the return value */
+	verity_return_bio_to_caller(io);
+}
+
+/* Asynchronously called upon the completion of verity-tree I/O. The status
+ * of the operation is passed back to verity-tree and the next steps are
+ * decided by verity_dec_pending.
+ */
+static void kverityd_io_vt_populate_end(struct bio *bio, int error)
+{
+	struct verity_tree_entry *entry = bio->bi_private;
+	struct verity_io *io = entry->io_context;
+
+	/* Tell the tree to atomically update now that we've populated
+	 * the given entry.
+	 */
+	verity_tree_read_completed(entry, error);
+
+	/* Clean up for reuse when reading data to be checked */
+	bio->bi_vcnt = 0;
+	bio->bi_io_vec->bv_offset = 0;
+	bio->bi_io_vec->bv_len = 0;
+	bio->bi_io_vec->bv_page = NULL;
+	/* Restore the private data to I/O so the destructor can be shared. */
+	bio->bi_private = io;
+	bio_put(bio);
+
+	/* We bail but assume the tree has been marked bad. */
+	if (unlikely(error)) {
+		DMERR("Failed to read for sector %llu (%u)",
+		      ULL(io->bio->bi_sector), io->bio->bi_size);
+		io->error = error;
+		/* Pass through the error to verity_dec_pending below */
+	}
+	/* When pending = 0, it will transition to reading real data */
+	verity_dec_pending(io);
+}
+
+/* Called by verity-tree (via verity_tree_populate), this function provides
+ * the message digests to verity-tree that are stored on disk.
+ */
+static int kverityd_vt_read_callback(void *ctx, sector_t start, u8 *dst,
+				      sector_t count,
+				      struct verity_tree_entry *entry)
+{
+	struct verity_io *io = ctx;  /* I/O for this batch */
+	struct verity_config *vc;
+	struct bio *bio;
+
+	vc = io->target->private;
+
+	/* The I/O context is nested inside the entry so that we don't need one
+	 * io context per page read.
+	 */
+	entry->io_context = ctx;
+
+	/* We should only get page size requests at present. */
+	verity_inc_pending(io);
+	bio = verity_alloc_bioset(vc, GFP_NOIO, 1);
+	bio->bi_private = entry;
+	bio->bi_idx = 0;
+	bio->bi_size = vc->vt.block_size;
+	bio->bi_sector = vc->hash_start + start;
+	bio->bi_bdev = vc->hash_dev->bdev;
+	bio->bi_end_io = kverityd_io_vt_populate_end;
+	bio->bi_rw = REQ_META;
+	/* Only need to free the bio since the page is managed by vt */
+	bio->bi_destructor = verity_bio_destructor;
+	bio->bi_vcnt = 1;
+	bio->bi_io_vec->bv_offset = offset_in_page(dst);
+	bio->bi_io_vec->bv_len = to_bytes(count);
+	/* dst is guaranteed to be a page_pool allocation */
+	bio->bi_io_vec->bv_page = virt_to_page(dst);
+	/* Track that this I/O is in use.  There should be no risk of the io
+	 * being removed prior since this is called synchronously.
+	 */
+	generic_make_request(bio);
+	return 0;
+}
+
+/* Submits an io request for each missing block of block hashes.
+ * The last one to return will then enqueue this on the io workqueue.
+ */
+static void kverityd_io_vt_populate(struct verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	u64 block;
+
+	for (block = io->block; block < io->block + io->count; ++block) {
+		int ret = verity_tree_populate(&vc->vt, io, block);
+
+		if (ret < 0) {
+			/* verity_dec_pending will handle the error case. */
+			io->error = ret;
+			break;
+		}
+	}
+}
+
+/* Asynchronously called upon the completion of I/O issued
+ * from kverityd_src_io_read. verity_dec_pending() acts as
+ * the scheduler/flow manager.
+ */
+static void kverityd_src_io_read_end(struct bio *clone, int error)
+{
+	struct verity_io *io = clone->bi_private;
+
+	if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !error))
+		error = -EIO;
+
+	if (unlikely(error)) {
+		DMERR_LIMIT("Error occurred: %d (%llu, %u)",
+			    error, ULL(clone->bi_sector), clone->bi_size);
+		io->error = error;
+	}
+
+	/* Release the clone which just avoids the block layer from
+	 * leaving offsets, etc in unexpected states.
+	 */
+	bio_put(clone);
+
+	verity_dec_pending(io);
+}
+
+/* If not yet underway, an I/O request will be issued to the vc->dev
+ * device for the data needed. It is cloned to avoid unexpected changes
+ * to the original bio struct.
+ */
+static void kverityd_src_io_read(struct verity_io *io)
+{
+	struct bio *clone;
+
+	/* Check if the read is already issued. */
+	if (io->flags & VERITY_IOFLAGS_CLONED)
+		return;
+
+	io->flags |= VERITY_IOFLAGS_CLONED;
+
+	/* Clone the bio. The block layer may modify the bvec array. */
+	clone = verity_bio_clone(io);
+	if (unlikely(!clone)) {
+		io->error = -ENOMEM;
+		return;
+	}
+
+	verity_inc_pending(io);
+
+	generic_make_request(clone);
+}
+
+/* kverityd_io services the I/O workqueue. For each pass through
+ * the I/O workqueue, a call to populate both the origin drive
+ * data and the hash tree data is made.
+ */
+static void kverityd_io(struct work_struct *work)
+{
+	struct delayed_work *dwork = container_of(work, struct delayed_work,
+						  work);
+	struct verity_io *io = container_of(dwork, struct verity_io,
+					    work);
+
+	/* Issue requests asynchronously. */
+	verity_inc_pending(io);
+	kverityd_src_io_read(io);
+	kverityd_io_vt_populate(io);
+	verity_dec_pending(io);
+}
+
+/* Paired with verity_dec_pending, the pending value in the io dictate the
+ * lifetime of a request and when it is ready to be processed on the
+ * workqueues.
+ */
+static void verity_inc_pending(struct verity_io *io)
+{
+	atomic_inc(&io->pending);
+}
+
+/* Block-level requests start here. */
+static int verity_map(struct dm_target *ti, struct bio *bio,
+		      union map_info *map_context)
+{
+	struct verity_io *io;
+	struct verity_config *vc;
+	struct request_queue *r_queue;
+
+	if (unlikely(!ti)) {
+		DMERR("dm_target was NULL");
+		return -EIO;
+	}
+
+	vc = ti->private;
+	r_queue = bdev_get_queue(vc->dev->bdev);
+
+	if (bio_data_dir(bio) == WRITE) {
+		/* If we silently drop writes, then the VFS layer will cache
+		 * the write and persist it in memory. While it doesn't change
+		 * the underlying storage, it still may be contrary to the
+		 * behavior expected by a verified, read-only device.
+		 */
+		DMWARN_LIMIT("write request received. rejecting with -EIO.");
+		return -EIO;
+	} else {
+		/* Queue up the request to be verified */
+		io = verity_io_alloc(ti, bio);
+		if (!io) {
+			DMERR_LIMIT("Failed to allocate and init IO data");
+			return DM_MAPIO_REQUEUE;
+		}
+		INIT_DELAYED_WORK(&io->work, kverityd_io);
+		queue_delayed_work(kverityd_ioq, &io->work, 0);
+	}
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+/*
+ * Non-block interfaces and device-mapper specific code
+ */
+
+/*
+ * Verity target parameters:
+ *
+ * <dev> <hash_dev> <hash_start> <block_size> <alg> <digest> <salt>
+ *
+ * version:        version of the hash tree on-disk format
+ * dev:            device to verify
+ * hash_dev:       device hashtree is stored on
+ * hash_start:     start address of hashes
+ * block_size:     size of a hash block
+ * alg:            hash algorithm
+ * digest:         toplevel hash of the tree
+ * salt:           salt
+ */
+static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct verity_config *vc = NULL;
+	const char *dev, *hash_dev, *alg, *digest, *salt;
+	unsigned long hash_start, block_size, version;
+	sector_t blocks;
+	int ret;
+
+	if (argc != 8) {
+		ti->error = "Invalid argument count";
+		return -EINVAL;
+	}
+
+	if (kstrtoul(argv[0], 10, &version) || (version != 0)) {
+		ti->error = "Invalid version";
+		return -EINVAL;
+	}
+	dev = argv[1];
+	hash_dev = argv[2];
+	if (kstrtoul(argv[3], 10, &hash_start)) {
+		ti->error = "Invalid hash_start";
+		return -EINVAL;
+	}
+	if (kstrtoul(argv[4], 10, &block_size) || (block_size > UINT_MAX)) {
+		ti->error = "Invalid block_size";
+		return -EINVAL;
+	}
+	alg = argv[5];
+	digest = argv[6];
+	salt = argv[7];
+
+	/* The device mapper device should be setup read-only */
+	if ((dm_table_get_mode(ti->table) & ~FMODE_READ) != 0) {
+		ti->error = "Must be created readonly.";
+		return -EINVAL;
+	}
+
+	vc = kzalloc(sizeof(*vc), GFP_KERNEL);
+	if (!vc)
+		return -EINVAL;
+
+	/* Calculate the blocks from the given device size */
+	vc->size = ti->len;
+	blocks = to_bytes(vc->size) / block_size;
+	if (verity_tree_create(&vc->vt, blocks, block_size, alg)) {
+		DMERR("failed to create required vt");
+		goto bad_vt;
+	}
+	if (verity_tree_set_digest(&vc->vt, digest)) {
+		DMERR("digest error");
+		goto bad_digest;
+	}
+	verity_tree_set_salt(&vc->vt, salt);
+	vc->vt.read_cb = kverityd_vt_read_callback;
+
+	vc->start = 0;
+	/* We only ever grab the device in read-only mode. */
+	ret = dm_get_device(ti, dev, dm_table_get_mode(ti->table), &vc->dev);
+	if (ret) {
+		DMERR("Failed to acquire device '%s': %d", dev, ret);
+		ti->error = "Device lookup failed";
+		goto bad_verity_dev;
+	}
+
+	if ((to_bytes(vc->start) % block_size) ||
+	    (to_bytes(vc->size) % block_size)) {
+		ti->error = "Device must be block_size divisble/aligned";
+		goto bad_hash_start;
+	}
+
+	vc->hash_start = (sector_t)hash_start;
+
+	/*
+	 * Note, dev == hash_dev is okay as long as the size of
+	 *       ti->len passed to device mapper does not include
+	 *       the hashes.
+	 */
+	if (dm_get_device(ti, hash_dev,
+			  dm_table_get_mode(ti->table), &vc->hash_dev)) {
+		ti->error = "Hash device lookup failed";
+		goto bad_hash_dev;
+	}
+
+	if (snprintf(vc->hash_alg, CRYPTO_MAX_ALG_NAME, "%s", alg) >=
+	    CRYPTO_MAX_ALG_NAME) {
+		ti->error = "Hash algorithm name is too long";
+		goto bad_hash;
+	}
+
+	vc->io_pool = mempool_create_slab_pool(MIN_IOS, _verity_io_pool);
+	if (!vc->io_pool) {
+		ti->error = "Cannot allocate verity io mempool";
+		goto bad_slab_pool;
+	}
+
+	vc->bs = bioset_create(MIN_BIOS, 0);
+	if (!vc->bs) {
+		ti->error = "Cannot allocate verity bioset";
+		goto bad_bs;
+	}
+
+	ti->private = vc;
+
+	return 0;
+
+bad_bs:
+	mempool_destroy(vc->io_pool);
+bad_slab_pool:
+bad_hash:
+	dm_put_device(ti, vc->hash_dev);
+bad_hash_dev:
+bad_hash_start:
+	dm_put_device(ti, vc->dev);
+bad_vt:
+bad_digest:
+bad_verity_dev:
+	kfree(vc);   /* hash is not secret so no need to zero */
+	return -EINVAL;
+}
+
+static void verity_dtr(struct dm_target *ti)
+{
+	struct verity_config *vc = ti->private;
+
+	bioset_free(vc->bs);
+	mempool_destroy(vc->io_pool);
+	verity_tree_destroy(&vc->vt);
+	dm_put_device(ti, vc->hash_dev);
+	dm_put_device(ti, vc->dev);
+	kfree(vc);
+}
+
+static int verity_ioctl(struct dm_target *ti, unsigned int cmd,
+			unsigned long arg)
+{
+	struct verity_config *vc = ti->private;
+	struct dm_dev *dev = vc->dev;
+	int r = 0;
+
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (vc->start ||
+	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
+	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
+}
+
+static int verity_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned int maxlen)
+{
+	struct verity_config *vc = ti->private;
+	char digest[VERITY_MAX_DIGEST_SIZE * 2 + 1] = { 0 };
+	char salt[VERITY_SALT_SIZE * 2 + 1] = { 0 };
+	unsigned int sz = 0;
+
+	verity_tree_digest(&vc->vt, digest);
+	verity_tree_salt(&vc->vt, salt);
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		result[0] = '\0';
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %s %llu %llu %s %s %s",
+		       vc->dev->name,
+		       vc->hash_dev->name,
+		       ULL(vc->hash_start),
+		       ULL(vc->vt.block_size),
+		       vc->hash_alg,
+		       digest,
+		       salt);
+		break;
+	}
+	return 0;
+}
+
+static int verity_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+		       struct bio_vec *biovec, int max_size)
+{
+	struct verity_config *vc = ti->private;
+	struct request_queue *q = bdev_get_queue(vc->dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = vc->dev->bdev;
+	bvm->bi_sector = vc->start + bvm->bi_sector - ti->begin;
+
+	/* Optionally, this could just return 0 to stick to single pages. */
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
+static int verity_iterate_devices(struct dm_target *ti,
+				 iterate_devices_callout_fn fn, void *data)
+{
+	struct verity_config *vc = ti->private;
+
+	return fn(ti, vc->dev, vc->start, ti->len, data);
+}
+
+static void verity_io_hints(struct dm_target *ti,
+			    struct queue_limits *limits)
+{
+	struct verity_config *vc = ti->private;
+	unsigned int block_size = vc->vt.block_size;
+
+	limits->logical_block_size = block_size;
+	limits->physical_block_size = block_size;
+	blk_limits_io_min(limits, block_size);
+}
+
+static struct target_type verity_target = {
+	.name   = "verity",
+	.version = {0, 1, 0},
+	.module = THIS_MODULE,
+	.ctr    = verity_ctr,
+	.dtr    = verity_dtr,
+	.ioctl  = verity_ioctl,
+	.map    = verity_map,
+	.merge  = verity_merge,
+	.status = verity_status,
+	.iterate_devices = verity_iterate_devices,
+	.io_hints = verity_io_hints,
+};
+
+#define VERITY_WQ_FLAGS (WQ_CPU_INTENSIVE|WQ_HIGHPRI)
+
+static int __init verity_init(void)
+{
+	int r = -ENOMEM;
+
+	_verity_io_pool = KMEM_CACHE(verity_io, 0);
+	if (!_verity_io_pool) {
+		DMERR("failed to allocate pool verity_io");
+		goto bad_io_pool;
+	}
+
+	kverityd_ioq = alloc_workqueue("kverityd_io", VERITY_WQ_FLAGS, 1);
+	if (!kverityd_ioq) {
+		DMERR("failed to create workqueue kverityd_ioq");
+		goto bad_io_queue;
+	}
+
+	kveritydq = alloc_workqueue("kverityd", VERITY_WQ_FLAGS, 1);
+	if (!kveritydq) {
+		DMERR("failed to create workqueue kveritydq");
+		goto bad_verify_queue;
+	}
+
+	r = dm_register_target(&verity_target);
+	if (r < 0) {
+		DMERR("register failed %d", r);
+		goto register_failed;
+	}
+
+	DMINFO("version %u.%u.%u loaded", verity_target.version[0],
+	       verity_target.version[1], verity_target.version[2]);
+
+	return r;
+
+register_failed:
+	destroy_workqueue(kveritydq);
+bad_verify_queue:
+	destroy_workqueue(kverityd_ioq);
+bad_io_queue:
+	kmem_cache_destroy(_verity_io_pool);
+bad_io_pool:
+	return r;
+}
+
+static void __exit verity_exit(void)
+{
+	int cpu;
+
+	flush_workqueue(kverityd_ioq);
+	flush_workqueue(kveritydq);
+
+	for_each_possible_cpu(cpu)
+		kfree(__get_cpu_var(verity_hash_desc));
+
+	destroy_workqueue(kveritydq);
+	destroy_workqueue(kverityd_ioq);
+
+	dm_unregister_target(&verity_target);
+	kmem_cache_destroy(_verity_io_pool);
+}
+
+module_init(verity_init);
+module_exit(verity_exit);
+
+MODULE_AUTHOR("The Chromium OS Authors <chromium-os-dev@chromium.org>");
+MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity checking");
+MODULE_LICENSE("GPL");
-- 
1.7.7.3

