Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0EWDSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 23:18:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54331 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab0EWDSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 23:18:20 -0400
From: wad@chromium.org
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com, hughd@google.com,
       Will Drewry <wad@chromium.org>
Subject: [PATCH RFC] device-mapper: verity, an integrity checking target
Date: Sat, 22 May 2010 22:17:25 -0500
Message-Id: <1274584645-5785-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Drewry <wad@chromium.org>

This target transparently passes I/O read requests through to the
configured underlying block device.  Before data is returned, the
cryptographic digest of each block is checked against an original value
stored on a separately configured block device (may be the same device).
Verification of the stored cryptographic digest is handled through the
use of a hash tree.  The root node of that tree is set at mapped drive
configuration time.

The hash tree implementation, dm-bht.c, provides a means to verify only
portions of the block device as needed.  In addition, it is possible to
reuse dm-bht.c and dm-bht.h in userspace (see tools below) for testing
and hash tree verification and creation.  At present, this device-mapper
target only uses the tree verification code (no kernel-time updates).

The behavior on integrity failure is parameter configurable:
- return -EIO for the given bio
- reboot
- ignore (when possible)

It is planned to make the error handler dynamically configured to
support behaviors specific to a given platform.

The userspace verity tools will be available at:
  http://git.chromium.org/cgi-bin/gitweb.cgi?p=dm-verity.git;a=summary
(Currently in review, http://codereview.chromium.org/1687008/show )

The original specification can be found at:
 http://www.chromium.org/chromium-os/chromiumos-design-docs/verified-boot

This work varies from the existing linux-ima work in a number of
areas:
- checks at the block device layer including all data and metadata
- doesn't consume the LSM module slot
- doesn't use or update TPM PCR values
It does, however, have overlapping goals and functionality.

Paired with the boot-without-initrd patches for dm, it allow for a fast,
verified boot process:
- https://www.redhat.com/archives/dm-devel/2010-May/msg00104.html
- https://www.redhat.com/archives/dm-devel/2010-May/msg00105.html
- https://www.redhat.com/archives/dm-devel/2010-May/msg00106.html

This code and docs are not polished and is likely buggy (rfc!).  Any and
all feedback is appreciated!

[This patch may be broken up into documentation, dm-bht, and dm-verity,
but for purposes of logical cohesiveness and comment, I've kept it
together.]

Signed-off-by: Will Drewry <wad@chromium.org>
---
 Documentation/device-mapper/dm-bht.txt    |   71 ++
 Documentation/device-mapper/dm-verity.txt |   71 ++
 drivers/md/Kconfig                        |   20 +
 drivers/md/Makefile                       |    1 +
 drivers/md/dm-bht.c                       | 1233 ++++++++++++++++++++++++
 drivers/md/dm-verity.c                    | 1495 +++++++++++++++++++++++++++++
 include/linux/dm-bht.h                    |  137 +++
 7 files changed, 3028 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-bht.txt
 create mode 100644 Documentation/device-mapper/dm-verity.txt
 create mode 100644 drivers/md/dm-bht.c
 create mode 100644 drivers/md/dm-verity.c
 create mode 100644 include/linux/dm-bht.h

diff --git a/Documentation/device-mapper/dm-bht.txt b/Documentation/device-mapper/dm-bht.txt
new file mode 100644
index 0000000..3ce814f
--- /dev/null
+++ b/Documentation/device-mapper/dm-bht.txt
@@ -0,0 +1,71 @@
+dm-bht
+======
+
+dm-bht provides a block hash tree implementation.  The use of dm-bht allows
+for integrity checking of a given block device without reading the entire
+set of blocks into memory befor euse.
+
+In particular, dm-bht supplies an interface for creating and verifying a tree
+of cryptographic digests with any algorithm supported by the kernel crypto API.
+
+The code is meant to be usable from user-space for creation and verification as
+well as directly from a Device-Mapper target.  The `verity' target is the
+motivating example.
+
+
+Theory of operation
+===================
+
+dm-bht is logically comprised of multiple nodes organized in a tree-like
+structure.  Each node in the tree is a cryptographic hash.  If it is a leaf
+node, the hash is of some block data on disk.  If it is an intermediary node,
+then the hash is of a number of child nodes.
+
+dm-bht has a given depth starting at 1 (ignoring the root node).  Each level in
+the tree is concretely made up of dm_bht_entry structs.  Each entry in the tree
+is a collection of neighboring nodes that fit in one page-sized block.  The
+number is determined based on PAGE_SIZE and the size of the selected
+cryptographic digest algorithm.  The hashes are linearly ordered in this entry
+and any unaligned trailing space is ignored but included when calculating the
+parent node.
+
+The tree looks something like:
+
+depth = 2, alg= sha256, num_blocks = 32767
+                                 [   root    ]
+                                /    . . .    \
+                     [entry_0]                 [entry_1]
+                    /  . . .  \                 . . .   \
+         [entry_0_0]   . . .  [entry_0_127]    . . . .  [entry_1_127]
+           / ... \             /   . . .  \             /           \
+     blk_0 ... blk_127  blk_16256   blk_16383      blk_32640 . . . blk_32767
+
+root is treated independently from the depth and the blocks are expected to
+be hashed and supplied to the dm-bht.  hash blocks that make up the entry
+contents are expected to be read from disk.
+
+dm-bht does not handle I/O directly but instead expects the consumer to
+supply callbacks.  The read callback will always receive a page-align value
+to pass to the block device layer to read in a hash value.
+
+Usage
+=====
+
+Reading and updating the same tree is not safe.  If a new tree is created, it
+should be dm_bht_destroy()d and a new tree should be instantiated, with
+dm_bht_create(), using the same hash data.
+
+When reading, all required data for the hash tree should be populated for a
+block before attempting a verify.  This can be done by calling
+dm_bht_populate().  When all data is ready, a call to dm_bht_verify_block()
+with the expected hash value will perform both the direct block hash check and
+the hashes of the parent and neighboring nodes where needed to ensure validity
+up to the root hash.  Note, dm_bht_set_root_hexdigest() should be called before
+any verification attempts occur.
+
+When updating the tree, all block hashes should be stored with
+dm_bht_store_block().  Once all hashes are stored, a call to dm_bht_compute()
+will initiate a full tree update by walking all of the blocks of hashes
+starting at the leaf nodes and computing upward to the root node.  On
+completion, dm_bht_sync() may be called to write the tree to disk (or wherever
+the callback writes to).
diff --git a/Documentation/device-mapper/dm-verity.txt b/Documentation/device-mapper/dm-verity.txt
new file mode 100644
index 0000000..09ce9b1
--- /dev/null
+++ b/Documentation/device-mapper/dm-verity.txt
@@ -0,0 +1,71 @@
+dm-verity
+==========
+
+Device-Mapper's "verity" target provides transparent integrity checking of
+block devices using a cryptographic digst provided by the kernel crypto API.
+This target is read-only.
+
+Parameters: <device path> <hash device path> <tree depth> <alg> <parent-hash>
+
+<device path>
+    This is the device that is going to be integrity checked.  It may be
+    a subset of the full device as specified to dmsetup (start sector and count)
+    It may be specified as a path, like /dev/sdaX, or a device number,
+    <major>:<minor>.
+
+<hash device path>
+    This is the device that that supplies the dm-bht hash data.  It may be
+    specified similarly to the device path and may be the same device.  If the
+    same device is used, the hash offset should be outside of the dm-verity
+    configured device size.
+
+<tree depth>
+    The tree depth determines how many levels of hashes are used when building
+    the tree of hashes.  The root of the tree not included and the leaves of
+    the tree are the hashes of the blocks on disk.
+
+<alg>
+    The cryptographic hash algorithm used for this device.  This should
+    be the name of the algorithm, like "sha1".
+
+<root hash>
+    The hexadecimal encoding of the cryptographic hash of all of the
+    neighboring nodes at the first level of the tree.  This hash should be
+    trusted as there is no other authenticity beyond this point.
+
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
+For more information on the hashing process, see dm-bht.txt.
+
+
+Example
+=======
+
+Setup a device;
+[[
+  dmsetup create vroot --table \
+    "0 204800 verity /dev/sda1 /dev/sda2 0 3 sha1 "\
+    "9f74809a2ee7607b16fcc70d9399a4de9725a727"
+]]
+
+A command line tool is available to compute the hash tree and return the
+root hash value.
+  http://git.chromium.org/cgi-bin/gitweb.cgi?p=dm-verity.git;a=tree
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 4a6feac..49d629e 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -243,6 +243,26 @@ config DM_CRYPT
 
 	  If unsure, say N.
 
+config DM_VERITY
+	tristate "Verity target support"
+	depends on BLK_DEV_DM
+	select CRYPTO
+	select CRYPTO_HASH
+	---help---
+	  This device-mapper target allows you to create a device that
+	  transparently integrity checks the data on it. You'll need to
+	  activate the digests you're going to use in the cryptoapi
+	  configuration.
+
+	  Information on how to use dm-verity can be found on
+
+	  <http://dev.chromium.org/chromium-os/chromiumos-design-docs/verified-boot>
+
+	  To compile this code as a module, choose M here: the module will
+	  be called dm-verity.
+
+	  If unsure, say N.
+
 config DM_SNAPSHOT
        tristate "Snapshot target"
        depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index e355e7f..0408134 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MD_FAULTY)		+= faulty.o
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
+obj-$(CONFIG_DM_VERITY)		+= dm-verity.o dm-bht.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
diff --git a/drivers/md/dm-bht.c b/drivers/md/dm-bht.c
new file mode 100644
index 0000000..8e014f5
--- /dev/null
+++ b/drivers/md/dm-bht.c
@@ -0,0 +1,1233 @@
+ /*
+ * Copyright (C) 2010 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *
+ * Device-Mapper block hash tree interface.
+ * See Documentation/device-mapper/dm-bht.txt for details.
+ *
+ * This file is released under the GPL.
+ */
+
+#include <asm/atomic.h>
+#include <asm/bug.h>
+#include <asm/errno.h>
+#include <asm/page.h>
+#include <linux/bitops.h>  /* for fls() */
+#include <linux/cpumask.h>  /* nr_cpu_ids */
+/* #define CONFIG_DM_DEBUG 1 */
+#include <linux/device-mapper.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/dm-bht.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>  /* k*alloc */
+#include <linux/string.h>  /* memset */
+
+#define DM_MSG_PREFIX "dm bht"
+
+/* For sector formatting. */
+#if defined (_LP64) || defined (__LP64__) || __BITS_PER_LONG == 64
+#define __PRIS_PREFIX "z"
+#else
+#define __PRIS_PREFIX "ll"
+#endif
+#define PRIu64 __PRIS_PREFIX "u"
+
+
+/*-----------------------------------------------
+ * Utilities
+ *-----------------------------------------------*/
+
+static u8 from_hex(u8 ch)
+{
+	if ((ch >= '0') && (ch <= '9'))
+		return ch - '0';
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
+	if ((ch >= 'A') && (ch <= 'F'))
+		return ch - 'A' + 10;
+	return -1;
+}
+
+/**
+ * dm_bht_bin_to_hex - converts a binary stream to human-readable hex
+ * @binary:	a byte array of length @binary_len
+ * @hex:	a byte array of length @binary_len * 2 + 1
+ */
+static void dm_bht_bin_to_hex(u8 *binary, u8 *hex, u32 binary_len)
+{
+	while (binary_len-- > 0) {
+		sprintf((char * __restrict__)hex, "%02hhx", (int)*binary);
+		hex += 2;
+		binary++;
+	}
+}
+
+/**
+ * dm_bht_hex_to_bin - converts a hex stream to binary
+ * @binary:	a byte array of length @binary_len
+ * @hex:	a byte array of length @binary_len * 2 + 1
+ */
+static void dm_bht_hex_to_bin(u8 *binary, const u8 *hex, u32 binary_len)
+{
+	while (binary_len-- > 0) {
+		*binary = from_hex(*(hex++));
+		*binary *= 16;
+		*binary += from_hex(*(hex++));
+		binary++;
+	}
+}
+
+static void dm_bht_log_mismatch(struct dm_bht *bht, u8 *given, u8 *computed)
+{
+	u8 given_hex[DM_BHT_MAX_DIGEST_SIZE * 2 + 1];
+	u8 computed_hex[DM_BHT_MAX_DIGEST_SIZE * 2 + 1];
+	dm_bht_bin_to_hex(given, given_hex, bht->digest_size);
+	dm_bht_bin_to_hex(computed, computed_hex, bht->digest_size);
+	DMERR_LIMIT("%s != %s", given_hex, computed_hex);
+}
+
+/*-----------------------------------------------
+ * Implementation functions
+ *-----------------------------------------------*/
+
+static int dm_bht_initialize_entries(struct dm_bht *bht);
+
+static int dm_bht_read_callback_stub(void *ctx, sector_t start, u8 *dst,
+				     sector_t count, struct dm_bht_entry *entry);
+static int dm_bht_write_callback_stub(void *ctx, sector_t start,
+				      u8 *dst, sector_t count,
+				      struct dm_bht_entry *entry);
+
+/**
+ * dm_bht_create - prepares @bht for us
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @depth:	tree depth without the root; including block hashes
+ * @block_count:the number of block hashes / tree leaves
+ * @alg_name:	crypto hash algorithm name
+ *
+ * Returns 0 on success.
+ *
+ * Callers can offset into devices by storing the data in the io callbacks.
+ * TODO(wad) bust up into smaller helpers
+ */
+int dm_bht_create(struct dm_bht *bht, unsigned int depth, u32 block_count,
+		  const char *alg_name)
+{
+	int status = 0;
+	int cpu = 0;
+	BUG_ON(!bht);
+
+	/* Allocate enough crypto contexts to be able to perform verifies
+	 * on all available CPUs */
+	bht->hash_desc = (struct hash_desc *)
+		kcalloc(nr_cpu_ids, sizeof(struct hash_desc), GFP_KERNEL);
+	if (!bht->hash_desc) {
+		DMERR("failed to allocate crypto hash contexts");
+		return -ENOMEM;
+	}
+
+	/* Setup the hash first. Its length determines much of the bht layout */
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
+		bht->hash_desc[cpu].tfm = crypto_alloc_hash(alg_name, 0, 0);
+		if (IS_ERR(bht->hash_desc[cpu].tfm)) {
+			DMERR("failed to allocate crypto hash '%s'", alg_name);
+			status = -ENOMEM;
+			bht->hash_desc[cpu].tfm = NULL;
+			goto bad_hash_alg;
+		}
+	}
+	bht->digest_size = crypto_hash_digestsize(bht->hash_desc[0].tfm);
+	/* We expect to be able to pack >=2 hashes into a page */
+	if (PAGE_SIZE / bht->digest_size < 2) {
+		DMERR("too few hashes fit in a page");
+		status = -EINVAL;
+		goto bad_digest_len;
+	}
+
+	if (bht->digest_size > DM_BHT_MAX_DIGEST_SIZE) {
+		DMERR("DM_BHT_MAX_DIGEST_SIZE too small for chosen digest");
+		status = -EINVAL;
+		goto bad_digest_len;
+	}
+	bht->root_digest = (u8 *)kzalloc(bht->digest_size, GFP_KERNEL);
+	if (!bht->root_digest) {
+		DMERR("failed to allocate memory for root digest");
+		status = -ENOMEM;
+		goto bad_root_digest_alloc;
+	}
+	bht->root_verified = false;
+
+	/* Configure the tree */
+	bht->block_count = block_count;
+	DMDEBUG("Setting block_count %u", block_count);
+	if (block_count == 0) {
+		DMERR("block_count must be non-zero");
+		status = -EINVAL;
+		goto bad_block_count;
+	}
+
+	bht->depth = depth;  /* assignment below */
+	DMDEBUG("Setting depth %u", depth);
+	if (!depth || depth > UINT_MAX / sizeof(struct dm_bht_level)) {
+		DMERR("bht depth is invalid: %u", depth);
+		status = -EINVAL;
+		goto bad_depth;
+	}
+
+	/* Allocate levels. Each level of the tree may have an arbitrary number
+	 * of dm_bht_entry structs.  Each entry contains node_count nodes.
+	 * Each node in the tree is a cryptographic digest of either node_count
+	 * nodes on the subsequent level or of a specific block on disk. */
+	bht->levels = (struct dm_bht_level *)
+		        kcalloc(depth, sizeof(struct dm_bht_level), GFP_KERNEL);
+	if (!bht->levels) {
+		DMERR("failed to allocate tree levels");
+		status = -ENOMEM;
+		goto bad_level_alloc;
+	}
+
+	/* Each dm_bht_entry->nodes is one page.  The node code tracks
+	 * how many nodes fit into one entry where a node is a single
+	 * hash (message digest). */
+	bht->node_count_shift = fls(PAGE_SIZE / bht->digest_size) - 1;
+	/* Round down to the nearest power of two.  This makes indexing
+	 * into the tree much less painful. */
+	bht->node_count = 1 << bht->node_count_shift;
+
+	/* This is unlikely to happen, but with 64k pages, who knows. */
+	if (bht->node_count > UINT_MAX / bht->digest_size) {
+		DMERR("node_count * hash_len exceeds UINT_MAX!");
+		status = -EINVAL;
+		goto bad_node_count;
+	}
+	/* Ensure that we can safely shift by this value. */
+	if (depth * bht->node_count_shift >= sizeof(u32) * 8) {
+		DMERR("specified depth and node_count_shift is too large");
+		status = -EINVAL;
+		goto bad_node_count;
+	}
+
+	/* Setup callback stubs */
+	bht->read_cb = &dm_bht_read_callback_stub;
+	bht->write_cb = &dm_bht_write_callback_stub;
+
+	status = dm_bht_initialize_entries(bht);
+	if (status)
+		goto bad_entries_alloc;
+
+	return 0;
+
+bad_entries_alloc:
+	while (bht->depth-- > 0) {
+		if (bht->levels[bht->depth].entries)
+			kfree(bht->levels[bht->depth].entries);
+	}
+bad_node_count:
+	kfree(bht->levels);
+bad_level_alloc:
+bad_block_count:
+bad_depth:
+	kfree(bht->root_digest);
+bad_root_digest_alloc:
+bad_digest_len:
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu)
+		if (bht->hash_desc[cpu].tfm)
+			crypto_free_hash(bht->hash_desc[cpu].tfm);
+bad_hash_alg:
+	kfree(bht->hash_desc);
+	return status;
+}
+EXPORT_SYMBOL_GPL(dm_bht_create);
+
+static int dm_bht_initialize_entries(struct dm_bht *bht)
+{
+	/* Walk the tree and allocate by considering the last possible
+	 * child assuming that the tree is fully populated.  Any gaps
+	 * MUST be padded on disk.
+	 * Note, we treat both the tree root (1 hash) and the tree leaves
+	 * as external to the level data.  The root is depth=-1 and the block
+	 * layer level is depth=bht->depth */
+	u32 last_index = ALIGN(bht->block_count, bht->node_count) - 1;
+	u32 total_entries = 0;
+	struct dm_bht_level *level = NULL;
+	unsigned int depth = 0;
+
+	/* check that the largest level->count can't result in an int overflow
+	 * on allocation or sector calculation. */
+	if (((last_index >> bht->node_count_shift) + 1) >
+	    UINT_MAX / max((u32)sizeof(struct dm_bht_entry),
+			   (u32)to_sector(PAGE_SIZE))) {
+		DMCRIT("required entries %u is too large",
+		       last_index + 1);
+		return -EINVAL;
+	}
+
+	/* Track the current sector location for each level so we don't have to
+	 * compute it during traversals. */	
+	bht->sectors = 0;
+	do {
+		u32 shift = (bht->depth - depth) * bht->node_count_shift;
+		level = &bht->levels[depth];
+		/* Depth is subtracted so that we can calculate the offset
+		 * treating the root as depth=0 for easier
+		 * debugging/comprehension */
+		level->count = (last_index >> shift) + 1;
+		DMDEBUG("depth: %u entries: %u", depth, level->count);
+		/* TODO(wad) could add entry_node_count and pre-allocate the
+		 * data but and make the entry->data =
+		 * &level->entries[level->count] + entry_index; It's more ideal
+		 * to either allocate so it can be freed indep (via mempool) or
+		 * use a LRU cache and when kicked, bump the entry back to
+		 * UNALLOCATED.  Right now, the state transition doesn't
+		 * support that but it could
+		 */
+		level->entries = (struct dm_bht_entry *) kcalloc(level->count,
+				   sizeof(struct dm_bht_entry), GFP_KERNEL);
+		total_entries += level->count;
+		if (!level->entries) {
+			DMERR("failed to allocate entries for depth %u",
+			      bht->depth);
+			/* let the caller clean up the mess */
+			return -ENOMEM;
+		}
+		level->sector = bht->sectors;
+		/* number of sectors per entry * entries at this level */
+		bht->sectors += level->count * to_sector(PAGE_SIZE);
+		/* not ideal, but since unsigned overflow behavior is defined */
+		if (bht->sectors < level->sector) {
+			DMCRIT("level sector calculation overflowed");
+			return -EINVAL;
+		}
+	} while (++depth < bht->depth);  /* Deepest layer is the block dev */
+
+	/* Go ahead and reserve enough space for everything.  We really don't
+	 * want memory allocation failures.  Once we start freeing verified
+	 * entries, then we can reduce this reservation. */ 
+	bht->entry_pool = mempool_create_page_pool(total_entries, 0);
+	if (!bht->entry_pool) {
+		DMERR("failed to allocate mempool");
+		return -ENOMEM;
+	}
+			
+	return 0;
+}
+
+static int dm_bht_read_callback_stub(void *ctx, sector_t start, u8 *dst,
+				     sector_t count, struct dm_bht_entry *entry)
+{
+	DMCRIT("dm_bht_read_callback_stub called!");
+	dm_bht_read_completed(entry, -EIO);
+	return -EIO;
+}
+
+static int dm_bht_write_callback_stub(void *ctx, sector_t start,
+				      u8 *dst, sector_t count,
+				      struct dm_bht_entry *entry)
+{
+	DMCRIT("dm_bht_write_callback_stub called!");
+	dm_bht_write_completed(entry, -EIO);
+	return -EIO;
+}
+
+/**
+ * dm_bht_read_completed
+ * @entry:	pointer to the entry that's been loaded
+ * @status:	I/O status. Non-zero is failure.
+ * MUST always be called after a read_cb completes.
+ */
+void dm_bht_read_completed(struct dm_bht_entry *entry, int status)
+{
+	int state;
+	BUG_ON(!entry);
+	if (status) {
+		/* TODO(wad) add retry support */
+		DMCRIT("an I/O error occurred while reading entry");
+		atomic_set(&entry->state, DM_BHT_ENTRY_ERROR_IO);
+		/* entry->nodes will be freed later */
+		return;
+	}
+	state = atomic_cmpxchg(&entry->state,
+				   DM_BHT_ENTRY_PENDING,
+				   DM_BHT_ENTRY_READY);
+	if (state != DM_BHT_ENTRY_PENDING) {
+		DMCRIT("state changed on entry out from under io");
+		BUG();
+	}
+}
+EXPORT_SYMBOL_GPL(dm_bht_read_completed);
+
+/**
+ * dm_bht_write_completed
+ * @entry:	pointer to the entry that's been loaded
+ * @status:	I/O status. Non-zero is failure.
+ * Should be called after a write_cb completes. Currently only catches
+ * errors which more writers don't care about.
+ */
+void dm_bht_write_completed(struct dm_bht_entry *entry, int status)
+{
+	BUG_ON(!entry);
+	if (status) {
+		DMCRIT("an I/O error occurred while writing entry");
+		atomic_set(&entry->state, DM_BHT_ENTRY_ERROR_IO);
+		/* entry->nodes will be freed later */
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(dm_bht_write_completed);
+
+
+/* dm_bht_maybe_read_entries
+ * Attempts to atomically acquire each entry, allocated any needed
+ * memory, and issues I/O callbacks to load the hashes from disk.
+ * Returns 0 if all entries are loaded and verified.  On error, the
+ * return value is negative. When positive, it is the state values
+ * ORd.
+ */
+static int dm_bht_maybe_read_entries(struct dm_bht *bht, void *ctx,
+				     unsigned int depth, u32 index,
+				     u32 count)
+{
+	struct dm_bht_level *level;
+	struct dm_bht_entry *entry, *last_entry;
+	sector_t current_sector;
+	int state = 0;
+	int status = 0;
+	struct page *node_page = NULL;
+	/* XXX: replace with DM_BHT_BUG_ON */
+	BUG_ON(!bht);
+	BUG_ON(depth >= bht->depth);
+
+	level = &bht->levels[depth];
+	if (count > level->count - index) {
+		DMERR("dm_bht_maybe_read_entries(%u,%u,%u): "
+		      "index+count exceeds available entries %u",
+			depth, index, count, level->count);
+		return -EINVAL;
+	}
+	/* XXX: hardcoding PAGE_SIZE means that a perfectly valid image
+	 *      on one system may not work on a different kernel.
+	 * TODO(wad) abstract PAGE_SIZE with a bht->entry_size or
+	 *           at least a define and ensure bht->entry_size is
+	 *           sector aligned at least. */
+	current_sector = level->sector + to_sector(index * PAGE_SIZE);
+	for (entry = &level->entries[index], last_entry = entry + count;
+	     entry < last_entry;
+	     ++entry, current_sector += to_sector(PAGE_SIZE)) {
+		/* If the entry's state is UNALLOCATED, then we'll claim it
+		 * for allocation and loading */
+		state = atomic_cmpxchg(&entry->state,
+				       DM_BHT_ENTRY_UNALLOCATED,
+				       DM_BHT_ENTRY_PENDING);
+		DMDEBUG("dm_bht_maybe_read_entries(%u,%u,%u): "
+			"ei=%lu, state=%d",
+			depth, index, count,
+			(unsigned long)(entry - level->entries), state);
+		if (state <= DM_BHT_ENTRY_ERROR) {
+			DMCRIT("entry %u is in an error state", index);
+			return state;
+		}
+
+		if (state == DM_BHT_ENTRY_VERIFIED) {
+			/* Makes 0 == verified. Is that ideal? */
+			continue;
+		}
+
+		if (state != DM_BHT_ENTRY_UNALLOCATED) {
+			/* PENDING, READY, ... */
+			status |= state;
+			continue;
+		}
+		/* Current entry is claimed for allocation and loading */
+		node_page = (struct page *) mempool_alloc(bht->entry_pool,
+							  GFP_NOIO);
+		if (!node_page) {
+			DMCRIT("failed to allocate memory for "
+			       "entry->nodes from pool");
+			return -ENOMEM;
+		}
+		/* dm-bht guarantees page-aligned memory for callbacks. */
+		entry->nodes = page_address(node_page);
+		/* Let the caller know that not all the data is yet available */
+		status |= DM_BHT_ENTRY_REQUESTED;
+		/* Issue the read callback */
+		/* TODO(wad) error check callback here too */
+		bht->read_cb(ctx,   /* external context */
+			     current_sector,  /* starting sector */
+			     entry->nodes,  /* destination */
+			     to_sector(PAGE_SIZE),
+			     entry);  /* io context */
+
+	}
+	/* Should only be 0 if all entries were verified and not just ready */
+	return status;
+}
+
+/* Used for turning verifiers into computers */
+typedef int (*dm_bht_compare_cb)(struct dm_bht *, u8 *, u8 *);
+
+static int dm_bht_compare_hash(struct dm_bht *bht, u8 *known, u8 *computed)
+{
+	return memcmp(known, computed, bht->digest_size);
+}		
+
+static int dm_bht_update_hash(struct dm_bht *bht, u8 *known, u8 *computed)
+{
+	memcpy(known, computed, bht->digest_size);
+	return 0;
+}		
+
+/**
+ * dm_bht_verify_entry - computes the digest of each entry and compares it
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @hashes:	array of expected hash values of each nodes
+ * @entries:	array of entries whose HASH(entry->nodes) is computed
+ * @count:	the number of elements in @entries and @hashes
+ * @compare_cb:	callback which compares the computed hash to the expected hash
+ *
+ * @hashes is usually the entry->nodes value of the parent of the @entries
+ * array supplied.
+ *
+ * In the normal case, HASH(entry->nodes) is compared against
+ * @hashes[entry_index], but compare_cb may be used to populate the values in
+ * @hashes.
+ */
+static int dm_bht_verify_entry(struct dm_bht *bht, u8 *hashes,
+			       struct dm_bht_entry *entries, unsigned int count,
+			       dm_bht_compare_cb compare_cb)
+{
+	struct hash_desc *hash_desc;
+	struct scatterlist sg;  /* feeds digest() */
+	struct dm_bht_entry *entry = entries;
+	int state = 0;
+	u8 *end = NULL;
+	u8 digest[DM_BHT_MAX_DIGEST_SIZE];
+	/* Basic sanity checking */
+	BUG_ON(!bht);
+	BUG_ON(!bht->digest_size);
+	BUG_ON(!hashes);
+	BUG_ON(!entries);
+	if (count > bht->node_count) {
+		DMERR("dm_bht_verify_entry called with count > node_count");
+		return -EINVAL;
+	}
+	/* Grab the hash that is reserved for our cpu wq */
+	hash_desc = &bht->hash_desc[smp_processor_id()];
+	for (end=hashes + (bht->digest_size * count);
+	     hashes < end;
+	     hashes += bht->digest_size, ++entry) {
+		/* Check if target entry is loaded. */
+		state = atomic_read(&entry->state);
+		if (state <= DM_BHT_ENTRY_ERROR) {
+			DMERR("entry marked bad before verify: %u of %u",
+			      (u32)(entry - entries), count);
+			return state;
+		}
+		if (state <= DM_BHT_ENTRY_PENDING) {
+			DMERR("entry not ready for verify: %u of %u: %d",
+			      (u32)(entry - entries), count, state);
+			return 1;
+		}
+		/* Note, we don't check if the entry itself has been verified.
+		 * All that we care about that each hash in the hashes array
+		 * are all correct. */
+		sg_init_table(&sg, 1);
+		sg_set_page(&sg, virt_to_page(entry->nodes), PAGE_SIZE, 0);
+		/* Note, this is synchronous. */
+		if (crypto_hash_init(hash_desc)) {
+			DMCRIT("failed to reinitialize crypto hash (proc:%d)",
+				smp_processor_id());
+			return -EINVAL;
+		}
+		if (crypto_hash_digest(hash_desc, &sg, PAGE_SIZE, digest)) {
+			DMCRIT("crypto_hash_digest failed");
+			return -EINVAL;
+		}
+		if (compare_cb(bht, hashes, digest)) {
+			DMERR("entry failed to validate: %u of %u",
+			      (u32)(entry - entries), count);
+			return DM_BHT_ENTRY_ERROR_MISMATCH;
+		}
+	}
+	return 0;
+}
+
+/* digest length and bht must be checked already */
+static int dm_bht_check_block(struct dm_bht *bht, u32 block_index,
+			      u8 *digest)
+{
+	int depth;
+	u32 index;
+	struct dm_bht_entry *entry;
+	int state;
+
+	/* The leaves contain the block hashes */
+	depth = bht->depth - 1;
+
+	/* Index into the bottom level.  Each entry in this level contains
+	 * nodes whose hashes are the direct hashes of one block of data on
+	 * disk. */
+	index = block_index >> bht->node_count_shift;
+	entry = &bht->levels[depth].entries[index];
+
+	state = atomic_read (&entry->state);
+	if (state <= DM_BHT_ENTRY_ERROR) {
+		DMCRIT("leaf entry for block %u is invalid",
+		       block_index);
+		return state;
+	}
+	if (state <= DM_BHT_ENTRY_PENDING) {
+		DMERR("leaf data not yet loaded for block %u",
+		      block_index);
+		return 1;
+	}
+
+	/* Index into the entry data */
+	index = (block_index % bht->node_count) * bht->digest_size;
+	if (memcmp(&entry->nodes[index], digest, bht->digest_size)) {
+		DMCRIT("digest mismatch for block %u", block_index);
+		dm_bht_log_mismatch(bht, &entry->nodes[index], digest);
+		return DM_BHT_ENTRY_ERROR_MISMATCH;
+	}
+	/* TODO(wad) update bht->block_bitmap here or in the caller */
+	return 0;
+}
+
+/* Walk all entries at level 0 to compute the root digest.
+ * 0 on success */
+static int dm_bht_compute_root(struct dm_bht *bht, u8 *digest)
+{
+	struct dm_bht_entry *entry;
+	u32 count;
+	struct scatterlist sg;  /* feeds digest() */
+	struct hash_desc *hash_desc;
+	BUG_ON(!bht);
+	hash_desc = &bht->hash_desc[smp_processor_id()];
+	entry = bht->levels[0].entries;
+
+        if (crypto_hash_init(hash_desc)) {
+		DMCRIT("failed to reinitialize crypto hash (proc:%d)",
+			smp_processor_id());
+		return -EINVAL;
+	}
+
+	/* Point the scatterlist to the entries, then compute the digest */
+	for (count = 0; count < bht->levels[0].count; ++count, ++entry) {
+		if (atomic_read(&entry->state) <= DM_BHT_ENTRY_PENDING) {
+			DMCRIT("data not ready to compute root: %u",
+			       count);
+			return 1;
+		}
+		sg_init_table(&sg, 1);
+		sg_set_page(&sg, virt_to_page(entry->nodes), PAGE_SIZE, 0);
+		if (crypto_hash_update(hash_desc, &sg, PAGE_SIZE)) {
+			DMCRIT("Failed to update crypto hash");
+			return -EINVAL;
+		}
+	}
+
+	if (crypto_hash_final(hash_desc, digest)) {
+		DMCRIT("Failed to compute final digest");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int dm_bht_verify_root(struct dm_bht *bht,
+			      dm_bht_compare_cb compare_cb)
+{
+	int status = 0;
+	u8 digest[DM_BHT_MAX_DIGEST_SIZE];
+	BUG_ON(!bht);
+	if (bht->root_verified)
+		return 0;
+	if ((status = dm_bht_compute_root(bht, digest))) {
+		DMCRIT("Failed to compute root digest for verification");
+		return status;
+	}
+	DMDEBUG("root computed");
+	if ((status = compare_cb(bht, bht->root_digest, digest))) {
+		DMCRIT("invalid root digest: %d", status);
+		dm_bht_log_mismatch(bht, bht->root_digest, digest);
+		return DM_BHT_ENTRY_ERROR_MISMATCH;
+	}
+	bht->root_verified = true;
+	return 0;
+}
+
+/* dm_bht_verify_levels
+ * Walks levels up to bht->depth - 2 and verifies the intermediary
+ * node hashes */
+static int dm_bht_verify_levels(struct dm_bht *bht, u32 block_index,
+				dm_bht_compare_cb compare_cb)
+{
+	unsigned int depth = 0;
+	u32 entry_index;
+	struct dm_bht_level *level;
+	struct dm_bht_entry *entry;
+	struct dm_bht_entry *parent = NULL;
+	int state;
+	unsigned int verify_count = 0;
+	bool parent_verified = true;
+	unsigned int node_mask = 0;
+	int verified = 0;
+	u8 *hashes = NULL;
+
+	/* The tree is then walked from 0 to bht->depth-2 to verify any
+	 * intermediate nodes in the tree */
+	node_mask = bht->node_count - 1;  /* pre-computed for easy masking */
+	do {
+		level = &bht->levels[depth];
+		entry_index = block_index >>
+			      ((bht->depth - depth) * bht->node_count_shift);
+		DMDEBUG("verify_levels for bi=%u on d=%d ei=%u (max=%u)",
+			block_index, depth, entry_index, level->count);
+		/* XXX: BUG_ON(!level->entries) */
+		entry = &level->entries[entry_index];
+		state = atomic_read(&entry->state);
+
+		if (state <= DM_BHT_ENTRY_ERROR) {
+			DMCRIT("entry(d=%u,idx=%u) is in an error state: %d",
+			       depth, entry_index, state);
+			DMCRIT("verification is not possible");
+			return state;
+		} else if (state <= DM_BHT_ENTRY_PENDING) {
+			DMERR("entry not ready for verify: d=%u,e=%u",
+			      depth, entry_index);
+			return 1;
+		}
+
+		/* If the parent is verified, then there's no work to do
+		 * at this level. */
+		if (parent_verified) {
+			if (state != DM_BHT_ENTRY_VERIFIED) {
+				parent = entry;
+				parent_verified = false;
+			}
+			continue;
+		}
+		/* The parent was not verified, so we need to walk it */
+		entry_index &= (~(node_mask));
+		verify_count = min((u32)bht->node_count,
+				   level->count - entry_index);
+		DMDEBUG("verify_entry for %u [%u]",
+			entry_index, bht->node_count);
+
+		hashes = parent->nodes;
+		verified = dm_bht_verify_entry(bht,
+					       hashes,
+					       level->entries + entry_index,
+					       verify_count,
+					       compare_cb);
+		/* TODO(wad) make a generic dm_bht_error_check() */
+		if (verified != 0) {
+			DMERR("failed to verify (d=%u,base=%u)",
+			      depth, entry_index);
+			return verified;
+		}
+		/* Transition parent to verified. Avoid using _set
+		 * in case we allow any other transitions from ready. */
+		atomic_cmpxchg(&parent->state,
+			       DM_BHT_ENTRY_READY,
+			       DM_BHT_ENTRY_VERIFIED);
+		parent = entry;
+		parent_verified = (state == DM_BHT_ENTRY_VERIFIED);
+	} while (++depth < bht->depth);  /* XXX ?? */
+	return verified;
+}
+
+/**
+ * dm_bht_store_block - sets a given block's hash in the tree
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @block_index:numeric index of the block in the tree
+ * @digest:	array of u8s containing the digest of length @bht->digest_size
+ *
+ * Returns 0 on success, >0 when data is pending, and <0 when a IO or other
+ * error has occurred.
+ *
+ * If the containing entry in the tree is unallocated, it will allocate memory
+ * and mark the entry as ready.  All other block entries will be 0s.  This
+ * function is not safe for simultaneous use when verifying data and should not
+ * be used if the @bht is being accessed by any other functions in any other
+ * threads/processes.
+ */
+int dm_bht_store_block(struct dm_bht *bht, u32 block_index,
+		       u8 *block_data)
+{
+	int depth;
+	u32 index;
+	struct dm_bht_entry *entry;
+	int state;
+	struct scatterlist sg;
+	struct hash_desc *hash_desc;
+	u8 digest[DM_BHT_MAX_DIGEST_SIZE];
+	struct page *node_page = NULL;
+
+	/* The leaves contain the block hashes */
+	depth = bht->depth - 1;
+
+	/* Index into the level */
+	index = block_index >> bht->node_count_shift;
+	entry = &bht->levels[depth].entries[index];
+	DMDEBUG("Storing block %u in d=%d,ei=%u,s=%d",
+		block_index, depth, index, atomic_read(&entry->state));
+
+	state = atomic_cmpxchg(&entry->state,
+			       DM_BHT_ENTRY_UNALLOCATED,
+			       DM_BHT_ENTRY_PENDING);
+	/* !!! Note. It is up to the users of the update interface to
+	 *     ensure the entry data is fully populated prior to use.
+	 *     The number of updated entries is NOT tracked. */
+	if (state == DM_BHT_ENTRY_UNALLOCATED) {
+		node_page = (struct page *) mempool_alloc(bht->entry_pool,
+							  GFP_KERNEL);
+		if (!node_page) {
+			atomic_set(&entry->state, DM_BHT_ENTRY_ERROR);
+			return -ENOMEM;
+		}
+		entry->nodes = page_address(node_page);
+		/* TODO(wad) could expose this to the caller to that they
+		 * can transition from unallocated to ready manually. */
+		atomic_set(&entry->state, DM_BHT_ENTRY_READY);
+	} else if (state <= DM_BHT_ENTRY_ERROR) {
+		DMCRIT("leaf entry for block %u is invalid",
+		      block_index);
+		return state;
+	} else if (state == DM_BHT_ENTRY_PENDING) {
+		DMERR("leaf data is pending for block %u", block_index);
+		return 1;
+	}
+
+	/* Compute the hash for the given page of data */
+	hash_desc = &bht->hash_desc[smp_processor_id()];
+	sg_init_table(&sg, 1);
+	sg_set_buf(&sg, block_data, PAGE_SIZE);
+	if (crypto_hash_init(hash_desc)) {
+		DMCRIT("failed to reinitialize crypto hash (proc:%d)",
+			smp_processor_id());
+		return -EINVAL;
+	}
+	if (crypto_hash_digest(hash_desc, &sg, PAGE_SIZE, digest)) {
+		DMCRIT("crypto_hash_digest failed");
+		return -EINVAL;
+	}
+
+	/* Index into the entry data */
+	index = (block_index % bht->node_count) * bht->digest_size;
+	DMDEBUG("Storing block %u in node offset %u",
+		block_index, index);
+	memcpy(&entry->nodes[index], digest, bht->digest_size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bht_store_block);
+
+/**
+ * dm_bht_zeroread_callback - read callback which always returns 0s
+ * @ctx:	ignored
+ * @start:	ignored
+ * @data:	buffer to write 0s to
+ * @count:	number of sectors worth of data to write
+ * @complete_ctx: opaque context for @completed
+ * @completed: callback to confirm end of data read
+ *
+ * Always returns 0.
+ *
+ * Meant for use by dm_compute() callers.  It allows dm_populate to
+ * be used to pre-fill a tree with zeroed out entry nodes.
+ */
+int dm_bht_zeroread_callback(void *ctx, sector_t start, u8 *dst,
+			     sector_t count, struct dm_bht_entry *entry)
+{
+	memset(dst, 0, to_bytes(count));
+	dm_bht_read_completed(entry, 0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bht_zeroread_callback);
+
+/**
+ * dm_bht_compute - computes and updates all non-block-level hashes in a tree
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @read_cb_ctx:opaque read_cb context for all I/O on this call
+ *
+ * Returns 0 on success, >0 when data is pending, and <0 when a IO or other
+ * error has occurred.
+ *
+ * Walks the tree and computes the hashes at each level from the
+ * hashes below. This can only be called once per tree creation
+ * since it will mark entries verified. Expects dm_bht_populate() to
+ * correctly populate the tree from the read_callback_stub.
+ *
+ * This function should not be used when verifying the same tree and
+ * should not be used with multiple simultaneous operators on @bht.
+ */
+int dm_bht_compute(struct dm_bht *bht, void *read_cb_ctx)
+{
+	u32 block;
+	int updated = 0;
+	BUG_ON(!bht);
+	/* Start in the last entry block aligned so we can sub node_count */
+	block = (bht->block_count - 1) & (~(bht->node_count - 1));
+	/* Call verify levels once per node_count blocks */
+	do {
+		DMDEBUG("Updating levels for block %u", block);
+		updated = dm_bht_populate(bht, read_cb_ctx, block);
+		if (updated < 0) {
+			DMERR("Failed to pre-zero entries");
+			return updated;
+		}
+		updated = dm_bht_verify_levels(bht,
+					       block,
+					       dm_bht_update_hash);
+		if (updated) {
+			DMERR("Failed to update levels for block %u",
+			      block);
+			return updated;
+		}
+		if (bht->node_count >= block) {
+			break;
+		}
+		block -= bht->node_count;
+	} while (block > 0);
+	/* Don't forget the root digest! */
+	DMDEBUG("Calling verify_root with update_hash");
+	updated = dm_bht_verify_root(bht, dm_bht_update_hash);
+	return updated;
+}
+EXPORT_SYMBOL_GPL(dm_bht_compute);
+
+/**
+ * dm_bht_sync - writes the tree in memory to disk
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @write_ctx:	callback context for writes issued
+ *
+ * Since all entry nodes are PAGE_SIZE, the data will be pre-aligned and
+ * padded.
+ */
+int dm_bht_sync(struct dm_bht *bht, void *write_cb_ctx)
+{
+	unsigned int depth = 0;
+	int ret = 0;
+	int state;
+	sector_t sector;
+	struct dm_bht_level *level;
+	struct dm_bht_entry *entry;
+	struct dm_bht_entry *entry_end;
+	
+	BUG_ON(!bht);
+	do {
+		level = &bht->levels[depth];
+		entry = level->entries;
+		entry_end = level->entries + level->count;
+		sector = level->sector;
+		do {
+			state = atomic_read(&entry->state);
+			if (state <= DM_BHT_ENTRY_PENDING) {
+				DMERR("At depth %d, entry %lu is not ready",
+				      depth,
+				      (unsigned long)(entry - level->entries));
+				return state;
+			}
+			ret = bht->write_cb(write_cb_ctx,
+					    sector,
+					    entry->nodes,
+					    to_sector(PAGE_SIZE),
+					    entry);
+			if (ret) {
+				DMCRIT("an error occurred writing entry %lu",
+				      (unsigned long)(entry - level->entries));
+				return ret;
+			}
+			sector += to_sector(PAGE_SIZE);	
+		} while (++entry < entry_end);
+	} while (++depth < bht->depth);
+	
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bht_sync);
+
+/**
+ * dm_bht_populate - reads entries from disk needed to verify a given block
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @read_cb_ctx:context used for all read_cb calls on this request
+ * @block_index:specific block data is expected from
+ *
+ * Callers may wish to call dm_bht_populate(0) immediately after initialization
+ * to start loading in all the level[0] entries.
+ */
+int dm_bht_populate(struct dm_bht *bht, void *read_cb_ctx, u32 block_index)
+{
+	unsigned int depth = 0;
+	struct dm_bht_entry *entry;
+	struct dm_bht_level *level;
+	bool parent_loaded = false;
+	int populated = 0;  /* return value */
+	u32 entry_index = 0;
+	u32 read_index = 0;
+	u32 read_count = 0;
+	int read_status = 0;
+	unsigned int node_mask = 0;
+
+	BUG_ON(!bht);
+	if (block_index >= bht->block_count) {
+		DMERR("Request to populate for invalid block: %u",
+		      block_index);
+		return -EIO;
+	}
+	DMDEBUG("dm_bht_populate(%u)", block_index);
+
+	/* Load in all of level 0 if the root is unverified */
+	if (!bht->root_verified) {
+		DMDEBUG("root unverified. may need to be loaded");
+		/* If positive, it means some are pending. */
+		populated = dm_bht_maybe_read_entries(bht, read_cb_ctx, 0, 0,
+						      bht->levels[0].count);
+		if (populated < 0) {
+			DMCRIT("an error occurred while reading level[0]");
+			/* TODO(wad) define std error codes */
+			return populated;
+		}
+	}
+
+	/* Used to know if all the neighboring entries need to be loaded. */
+	parent_loaded = true;
+	node_mask = bht->node_count - 1;  /* pre-computed for easy masking */
+	do {
+		level = &bht->levels[depth];
+		entry_index = block_index >>
+			      ((bht->depth - depth) * bht->node_count_shift);
+		/* XXX: BUG_ON(!level->entries) */
+		entry = &level->entries[entry_index];
+
+		/* parent_loaded avoids unecessary cmpxchgs over node_count
+		 * entries at each level.  It, however, is not atomic so it
+		 * is possible that the parent and all neighbors have been
+		 * loaded in the intevening period. */
+		if (!parent_loaded) {
+			read_index = entry_index & (~(node_mask));
+			read_count = min((u32)bht->node_count, 
+					 level->count - read_index);
+			DMDEBUG("!parent_loaded: %u (%u&~%u) %u",
+				read_index, entry_index, node_mask, read_count);
+		} else {
+			read_index = entry_index;
+			read_count = 1;
+		}
+		read_status = dm_bht_maybe_read_entries(bht, read_cb_ctx, depth,
+							read_index, read_count);	
+		if (unlikely(read_status < 0)) {
+			DMCRIT("failure occurred reading entries: %u %u-%u",
+			       depth, read_index, read_count);
+			return read_status;
+		}
+		/* Accrue return code flags */
+		populated |= read_status;
+		/* Even if the parent has been loaded, we need to load for it if
+		 * it hasn't been verified to ensure a verify call can succeed
+		 */
+		if (read_status)
+			parent_loaded = false;
+	} while (++depth < bht->depth);
+
+	/* All nodes are ready. The hash for the block_index can be verified */
+	return populated;
+}
+EXPORT_SYMBOL_GPL(dm_bht_populate);
+
+
+/**
+ * dm_bht_verify_block - checks that all nodes in the path for @block are valid
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @block_index:specific block data is expected from
+ * @digest:	computed digest for the given block to be checked
+ * @digest_len:	length of @digest
+ *
+ * Returns 0 on success, 1 on missing data, and a negative error
+ * code on verification failure. All supporting functions called
+ * should return similarly.
+ */
+int dm_bht_verify_block(struct dm_bht *bht, u32 block_index, u8 *digest,
+			unsigned int digest_len)
+{
+	int verified = 0;
+	BUG_ON(!bht);
+	
+	/* TODO(wad) do we really need this? */
+	if (digest_len != bht->digest_size) {
+		DMERR("invalid digest_len passed to verify_block");
+		return -EINVAL;
+	}
+
+	/* Make sure that the root has been verified */
+	if (!bht->root_verified) {
+		verified = dm_bht_verify_root(bht, dm_bht_compare_hash);
+		if (verified) {
+			DMCRIT("Failed to verify root: %d", verified);
+			return verified;
+		}
+	}
+
+	/* Now check that the digest supplied matches the leaf hash */
+	verified = dm_bht_check_block(bht, block_index, digest);
+	if (verified) {
+		DMCRIT("Block check failed for %u: %d", block_index, verified);
+		return verified;
+	}
+
+	/* Now check levels in between */
+	verified = dm_bht_verify_levels(bht,
+					block_index,
+					dm_bht_compare_hash);
+	if (verified) {
+		DMERR("Failed to verify intermediary nodes for block: %u",
+		      block_index);
+	}
+	return verified;
+}
+EXPORT_SYMBOL_GPL(dm_bht_verify_block);
+
+/**
+ * dm_bht_destroy - cleans up all memory used by @bht
+ * @bht:	pointer to a dm_bht_create()d bht
+ *
+ * Returns 0 on success. Does not free @bht itself.
+ */
+int dm_bht_destroy(struct dm_bht *bht)
+{
+	unsigned int depth;
+	int cpu = 0;
+	BUG_ON(!bht);	
+
+	if (bht->root_digest)
+		kfree(bht->root_digest);
+
+	depth = bht->depth;
+	while (depth-- != 0) {
+		struct dm_bht_entry *entry = bht->levels[depth].entries;
+		struct dm_bht_entry *entry_end = entry +
+						 bht->levels[depth].count;
+		int state = 0;
+		do {
+			state = atomic_read(&entry->state);
+			switch (state) {
+			/* At present, no other states free memory,
+			 * but that will change. */
+			case DM_BHT_ENTRY_UNALLOCATED:
+				/* Allocated with improper state */
+				BUG_ON(entry->nodes);
+				continue;
+			default:
+				BUG_ON(!entry->nodes);
+				mempool_free(entry->nodes, bht->entry_pool);
+				break;
+			}
+		} while (++entry < entry_end);
+		kfree(bht->levels[depth].entries);
+		bht->levels[depth].entries = NULL;
+	}
+	mempool_destroy(bht->entry_pool);
+	kfree(bht->levels);
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu)
+		if (bht->hash_desc[cpu].tfm)
+			crypto_free_hash(bht->hash_desc[cpu].tfm);
+	kfree(bht->hash_desc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bht_destroy);
+
+/*-----------------------------------------------
+ * Accessors
+ *-----------------------------------------------*/
+
+/**
+ * dm_bht_sectors - return the sectors required on disk
+ * @bht:	pointer to a dm_bht_create()d bht
+ */
+sector_t dm_bht_sectors(const struct dm_bht *bht)
+{
+	BUG_ON(!bht);
+	return bht->sectors;
+}
+EXPORT_SYMBOL_GPL(dm_bht_sectors);
+
+/**
+ * dm_bht_set_read_cb - set read callback
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @read_cb:	callback function used for all read requests by @bht
+ */
+void dm_bht_set_read_cb(struct dm_bht *bht, dm_bht_callback read_cb)
+{
+	BUG_ON(!bht);
+	bht->read_cb = read_cb;
+}
+EXPORT_SYMBOL_GPL(dm_bht_set_read_cb);
+
+/**
+ * dm_bht_set_write_cb - set write callback
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @write_cb:	callback function used for all write requests by @bht
+ */
+void dm_bht_set_write_cb(struct dm_bht *bht, dm_bht_callback write_cb)
+{
+	BUG_ON(!bht);
+	bht->write_cb = write_cb;
+}
+EXPORT_SYMBOL_GPL(dm_bht_set_write_cb);
+
+/**
+ * dm_bht_set_root_hexdigest - sets an unverified root digest hash from hex
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @hexdigest:	array of u8s containing the new digest in binary
+ * Returns non-zero on error.  hexdigest should be NUL terminated.
+ */
+int dm_bht_set_root_hexdigest(struct dm_bht *bht, const u8 *hexdigest)
+{
+	BUG_ON(!bht || !hexdigest);
+	if (!bht->root_digest) {
+		DMCRIT("No allocation for root digest. Call dm_bht_create");
+		return -1;
+	}
+	/* Make sure we have at least the bytes expected */
+	if (strnlen((char *)hexdigest, bht->digest_size * 2) !=
+	    bht->digest_size * 2) {
+		DMERR("root digest length does not match hash algorithm");
+		return -1;
+	}
+	dm_bht_hex_to_bin(bht->root_digest, hexdigest, bht->digest_size);
+#ifdef CONFIG_DM_DEBUG
+	DMINFO("Set root digest to %s. Parsed as -> ", hexdigest);
+	dm_bht_log_mismatch(bht, bht->root_digest, bht->root_digest);
+#endif
+	bht->root_verified = false;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bht_set_root_hexdigest);
+
+/**
+ * dm_bht_root_hexdigest - returns root digest in hex
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @hexdigest:	u8 array of size @available
+ * @available:	must be bht->digest_size * 2 + 1
+ */
+int dm_bht_root_hexdigest(struct dm_bht *bht, u8 *hexdigest, int available)
+{
+	BUG_ON(!bht);
+	if (available < 0 ||
+	    ((unsigned int) available) < bht->digest_size * 2 + 1) {
+		DMERR("hexdigest has too few bytes available");
+		return -EINVAL;
+	}
+	if (!bht->root_digest) {
+		DMERR("no root digest exists to export");
+		if (available > 0) {
+			*hexdigest = 0;
+		}
+		return -1;
+	}
+	dm_bht_bin_to_hex(bht->root_digest, hexdigest, bht->digest_size);
+	hexdigest[bht->digest_size * 2] = 0;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bht_root_hexdigest);
+
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
new file mode 100644
index 0000000..bf9fb0c
--- /dev/null
+++ b/drivers/md/dm-verity.c
@@ -0,0 +1,1495 @@
+/*
+ * Originally based on dm-crypt.c,
+ * Copyright (C) 2003 Christophe Saout <christophe@saout.de>
+ * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
+ * Copyright (C) 2006-2008 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2010 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *                    All Rights Reserved.
+ *
+ * This file is released under the GPL.
+ *
+ * Implements a verifying transparent block device.
+ * See Documentation/device-mapper/dm-verity.txt
+ */
+#include <linux/backing-dev.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/completion.h>
+#include <linux/crypto.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mempool.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/reboot.h>
+#include <asm/atomic.h>
+#include <linux/scatterlist.h>
+#include <asm/page.h>
+#include <asm/unaligned.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+
+/* #define CONFIG_DM_DEBUG 1 */
+#define CONFIG_DM_VERITY_TRACE 1
+#include <linux/device-mapper.h>
+#include <linux/dm-bht.h>
+
+#define DM_MSG_PREFIX "verity"
+#define MESG_STR(x) x, sizeof(x)
+
+/* Supports up to 512-bit digests */
+#define VERITY_MAX_DIGEST_SIZE 64
+
+/* TODO(wad) make both of these report the error line/file to a
+ * 	     verity_bug function. */
+#define VERITY_BUG(msg...) BUG()
+#define VERITY_BUG_ON(cond, msg...) BUG_ON(cond)
+
+/* Helper for printing sector_t */
+#define ULL(x) ((unsigned long long)(x))
+
+/* Requires the pool to have the given # of pages available. They are only
+ * used for padding non-block aligned requests so each request should need
+ * at most 2 additional pages. This means our maximum queue without suffering
+ * from memory contention could be 32 requests. */
+#define MIN_POOL_PAGES 16
+/* IOS represent min of dm_verity_ios in a pool, but we also use it to
+ * preallocate biosets (MIN_IOS * 2):
+ * 1. We need to clone the entire bioset, including bio_vecs, before passing
+ *    them to the underlying block layer since it may alter the values.
+ * 2. We need to pad out biosets that are not block aligned.
+ * 3. We need to be able to create biosets while loading in hashes.
+ * This will need more tweaking for specific workload expectations. */
+#define MIN_IOS 32
+/* During io_bht_read, we will spawn _many_ bios for a single I/O early on, but
+ * once the tree is populated, we will only need MIN_IOS at most to be able to
+ * pad out the request. We will also need space for the padding biovecs which
+ * is at most 2, less than one page per side. */
+#define MIN_BIOS (MIN_IOS * 2)
+
+/* We use a block size == page_size in sectors */
+#define VERITY_BLOCK_SIZE ((PAGE_SIZE) >> (SECTOR_SHIFT))
+
+/* Support additional tracing of requests */
+#ifdef CONFIG_DM_VERITY_TRACE
+#define VERITY_TRACE(param, fmt, args...) { \
+	if (param) DMINFO(fmt, ## args); \
+}
+static int request_trace = 0;
+module_param(request_trace, bool, 0644);
+MODULE_PARM_DESC(request_trace, "Enable request tracing to DMINFO");
+
+static int alloc_trace = 0;
+module_param(alloc_trace, bool, 0644);
+MODULE_PARM_DESC(alloc_trace, "Enable allocation tracing to DMINFO");
+#else
+#define VERITY_TRACE(...)
+#endif
+
+#define REQTRACE(fmt, args...) VERITY_TRACE(request_trace, "req: " fmt, ## args)
+#define ALLOCTRACE(fmt, args...) \
+	VERITY_TRACE(alloc_trace, "alloc: " fmt, ## args)
+
+/* MIN_BIOS * 2 is a safe upper bound.  An upper bound is desirable, especially
+ * with larger dm-bhts because multiple requests will be issued to bootstrap
+ * initial dm-bht root verification. */
+static int max_bios = MIN_BIOS * 2;
+module_param(max_bios, int, 0644);
+MODULE_PARM_DESC(max_bios, "Max number of allocated BIOs");
+
+/* Provide a lightweight means of controlling the behavior of dm-verity
+ * devices when the module is configured. */
+enum error_behavior_type { DM_VERITY_EIO = 0, DM_VERITY_REBOOT,
+			   DM_VERITY_NOTHING };
+static int error_behavior = DM_VERITY_EIO;
+module_param(error_behavior, int, 0444);
+MODULE_PARM_DESC(error_behavior, "Behavior on error");
+
+/* Used for tracking pending bios as well as for exporting information via
+ * STATUSTYPE_INFO. */
+struct verity_stats {
+	unsigned int pending_bio;
+	unsigned int io_queue;
+	unsigned int verify_queue;
+	unsigned int average_requeues;
+	unsigned int total_requeues;
+	unsigned long long total_requests;
+};
+
+/* Holds the context of a given verify operation. */
+struct verify_context {
+	struct bio *bio;  /* block_size padded bio or aligned original bio */
+	unsigned int offset;  /* into current bio_vec */
+	unsigned int idx;  /* of current bio_vec */
+	unsigned int needed;  /* for next hash */
+	sector_t block;  /*  current block */
+};
+
+/* per-requested-bio private data */
+enum next_queue_type { DM_VERITY_NONE, DM_VERITY_IO, DM_VERITY_VERIFY };
+struct dm_verity_io {
+	struct dm_target *target;
+	struct bio *base_bio;
+	struct delayed_work work;
+	unsigned int next_queue;
+
+	struct verify_context ctx;
+	int error;
+	atomic_t pending;
+
+	sector_t sector;  /* unaligned, converted to target sector */
+	sector_t block;  /* aligned block index */
+	sector_t count;  /* aligned count in blocks */
+
+	/* Tracks the number of bv_pages that were allocated
+	 * from the local pool during request padding. */
+	unsigned int leading_pages;
+	unsigned int trailing_pages;
+};
+
+struct verity_config {
+	struct dm_dev *dev;
+	sector_t start;
+
+	struct dm_dev *hash_dev;
+	sector_t hash_start;
+
+	struct dm_bht bht;
+
+	/* Pool required for io contexts */
+	mempool_t *io_pool;
+	/* Pool and bios required for making sure that backing device reads are
+	 * in PAGE_SIZE increments. */
+	mempool_t *page_pool;
+	struct bio_set *bs;
+
+	/* Single threaded I/O submitter */
+	struct workqueue_struct *io_queue;
+	/* Multithreaded verifier queue */
+	struct workqueue_struct *verify_queue;
+
+	char hash_alg[CRYPTO_MAX_ALG_NAME];
+	struct hash_desc *hash;  /* one per cpu */
+
+	struct verity_stats stats;
+};
+
+static struct kmem_cache *_verity_io_pool;
+ 
+static void kverityd_queue_verify(struct dm_verity_io *io);
+static void kverityd_queue_io(struct dm_verity_io *io, bool delayed);
+static void kverityd_io_bht_populate(struct dm_verity_io *io);
+static void kverityd_io_bht_populate_end(struct bio *, int error);
+
+
+/*-----------------------------------------------
+ * Statistic tracking functions
+ *-----------------------------------------------*/
+
+void verity_stats_pending_bio_inc(struct verity_config *vc)
+{
+	vc->stats.pending_bio++;
+}
+
+void verity_stats_pending_bio_dec(struct verity_config *vc)
+{
+	vc->stats.pending_bio--;
+}
+
+void verity_stats_io_queue_inc(struct verity_config *vc)
+{
+	vc->stats.io_queue++;
+}
+
+void verity_stats_verify_queue_inc(struct verity_config *vc)
+{
+	vc->stats.verify_queue++;
+}
+
+void verity_stats_io_queue_dec(struct verity_config *vc)
+{
+	vc->stats.io_queue--;
+}
+
+void verity_stats_verify_queue_dec(struct verity_config *vc)
+{
+	vc->stats.verify_queue--;
+}
+
+void verity_stats_total_requeues_inc(struct verity_config *vc)
+{
+	if (vc->stats.total_requeues >= INT_MAX - 1) {
+		DMINFO("stats.total_requeues is wrapping");
+		vc->stats.total_requeues = 0;
+	}
+	vc->stats.total_requeues++;
+}
+
+void verity_stats_total_requests_inc(struct verity_config *vc)
+{
+	vc->stats.total_requests++;
+}
+
+void verity_stats_average_requeues(struct verity_config *vc, int requeues)
+{
+	/* TODO(wad) */
+}
+
+/*-----------------------------------------------
+ * Allocation and utility functions
+ *-----------------------------------------------*/
+
+static void verity_align_request(struct verity_config *vc, sector_t *start,
+				 unsigned int *size);
+static void kverityd_src_io_read_end(struct bio *clone, int error);
+
+/* Shared destructor for all internal bios */
+static void dm_verity_bio_destructor(struct bio *bio)
+{
+	struct dm_verity_io *io = bio->bi_private;
+	struct verity_config *vc = io->target->private;
+	verity_stats_pending_bio_dec(io->target->private);
+	bio_free(bio, vc->bs);
+}
+
+/* This function may block if the number of outstanding requests is too high. */
+struct bio *verity_alloc_bioset(struct verity_config *vc, gfp_t gfp_mask,
+			        int nr_iovecs)
+{
+	/* Don't flood the I/O or over allocate from the pools */
+	verity_stats_pending_bio_inc(vc);
+	while(vc->stats.pending_bio > (unsigned int)max_bios) {
+		DMINFO("too many outstanding BIOs (%u). sleeping.",
+		       vc->stats.pending_bio - 1);
+		/* The request may be for dev->bdev, but all additional requests
+		 * come through the hash_dev and are the issue for clean up */
+		msleep_interruptible(10);
+	}
+	return bio_alloc_bioset(gfp_mask, nr_iovecs, vc->bs);
+}
+
+static struct dm_verity_io *verity_io_alloc(struct dm_target *ti,
+					    struct bio *bio, sector_t sector)
+{
+	struct verity_config *vc = ti->private;
+	struct dm_verity_io *io;
+	unsigned int aligned_size = bio->bi_size;
+	sector_t aligned_sector = sector;
+
+	ALLOCTRACE("dm_verity_io for sector %llu", ULL(sector));
+	io = mempool_alloc(vc->io_pool, GFP_NOIO);
+	if (unlikely(!io)) {
+		return NULL;
+	}
+	/* By default, assume io requests will require a hash */
+	io->next_queue = DM_VERITY_IO;
+	io->target = ti;
+	io->base_bio = bio;
+	io->sector = sector;
+	io->error = 0;
+	io->leading_pages = 0;
+	io->trailing_pages = 0;
+	io->ctx.bio = NULL;
+
+	verity_align_request(vc, &aligned_sector, &aligned_size);
+	/* Adjust the sector by the virtual starting sector */
+	io->block = (to_bytes(aligned_sector)) >> PAGE_SHIFT;
+	io->count = aligned_size >> PAGE_SHIFT;
+
+	DMDEBUG("io_alloc for %llu blocks starting at %llu",
+		ULL(io->count), ULL(io->block));
+
+	atomic_set(&io->pending, 0);
+
+	return io;
+}
+
+/* ctx->bio should be prepopulated */
+static int verity_verify_context_init(struct verity_config *vc,
+				      struct verify_context *ctx)
+{
+	if (unlikely(ctx->bio == NULL)) {
+		DMCRIT("padded bio was not supplied to kverityd");
+		return -EINVAL;
+	}
+	ctx->offset = 0;
+	ctx->needed = PAGE_SIZE;
+	ctx->idx = ctx->bio ? ctx->bio->bi_idx : 0;
+	/* The sector has already be translated and adjusted to the
+	 * appropriate start for reading. */
+	ctx->block = to_bytes(ctx->bio->bi_sector) >> PAGE_SHIFT;
+	/* Setup the new hash context too */
+	if (crypto_hash_init(&vc->hash[smp_processor_id()])) {
+		DMCRIT("Failed to initialize the crypto hash");
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static void clone_init(struct dm_verity_io *io, struct bio *clone,
+		       unsigned short vcnt, unsigned int size, sector_t start)
+{
+	struct verity_config *vc = io->target->private;
+
+	clone->bi_private = io;
+	clone->bi_end_io  = kverityd_src_io_read_end;
+	clone->bi_bdev    = vc->dev->bdev;
+	clone->bi_rw      = io->base_bio->bi_rw;
+	clone->bi_destructor = dm_verity_bio_destructor;
+	clone->bi_idx = 0;
+	clone->bi_vcnt = vcnt;
+	clone->bi_size = size;
+	clone->bi_sector = start;
+}
+
+static void verity_align_request(struct verity_config *vc, sector_t *start,
+				 unsigned int *size)
+{
+	sector_t base_sector;
+	VERITY_BUG_ON(!start || !size || !vc, "NULL arguments");
+
+	base_sector = *start;
+	/* Mask off to the starting sector for a block */
+	*start = base_sector & (~(to_sector(PAGE_SIZE) - 1));
+	/* Add any extra bytes from the lead */
+	*size += to_bytes(base_sector - *start);
+	/* Now round up the size to the full block size */
+	*size = PAGE_ALIGN(*size);
+}
+
+/* Populates a bio_vec array starting with the pointer provided allocating
+ * pages from the given page pool until bytes reaches 0.
+ * The next position in the bio_vec array is returned on success. On
+ * failure, a NULL is returned.
+ * It is assumed that the bio_vec array is properly sized. */
+static struct bio_vec *populate_bio_vec(struct bio_vec *bvec,
+					mempool_t *page_pool,
+					unsigned int bytes,
+					unsigned int *pages_added) {
+	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
+	if (!bvec || !page_pool || !pages_added)
+		return NULL;
+
+	while (bytes > 0) {
+		DMDEBUG("bytes == %u", bytes);
+		bvec->bv_offset = 0;
+		bvec->bv_len = min(bytes, (unsigned int)PAGE_SIZE);
+		ALLOCTRACE("page for bio_vec %p", bvec);
+		bvec->bv_page = mempool_alloc(page_pool, gfp_mask);
+		if (unlikely(bvec->bv_page == NULL)) {
+			DMERR("Out of pages in the page_pool!");
+			return NULL;
+		}
+		bytes -= bvec->bv_len;
+		++*pages_added;
+		++bvec;
+	}
+	return bvec;
+}
+
+static int verity_hash_bv(struct verity_config *vc,
+			  struct verify_context *ctx)
+{
+	struct bio_vec *bv = bio_iovec_idx(ctx->bio, ctx->idx);
+	struct scatterlist sg;
+	unsigned int size = bv->bv_len - (bv->bv_offset + ctx->offset);
+
+        /* Catch unexpected undersized bvs */
+	if (bv->bv_len < bv->bv_offset + ctx->offset) {
+		ctx->offset = 0;
+		ctx->idx++;
+		return 0;
+	}
+
+	/* Only update the hash with the amount that's needed for this
+	 * block (as tracked in the ctx->sector). */
+	size = min(size, ctx->needed);
+	DMDEBUG("Updating hash for block %llu vector idx %u: "
+		"size:%u offset:%u+%u len:%u",
+		ULL(ctx->block), ctx->idx, size, bv->bv_offset, ctx->offset,
+		bv->bv_len);
+
+	/* Updates the current digest hash context for the on going block */
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, bv->bv_page, size, bv->bv_offset + ctx->offset);
+
+	/* Use one hash_desc+tfm per cpu so that we can make use of all
+	 * available cores when verifying.  Only one context is handled per
+	 * processor, however. */
+	if (crypto_hash_update(&vc->hash[smp_processor_id()], &sg, size)) {
+		DMCRIT("Failed to update crypto hash");
+		return -EFAULT;
+	}
+	ctx->needed -= size;
+	ctx->offset += size;
+
+	if (ctx->offset + bv->bv_offset >= bv->bv_len) {
+		ctx->offset = 0;
+		/* Bump the bio_segment counter */
+		ctx->idx++;
+	}
+
+	return 0;
+}
+
+static void verity_free_buffer_pages(struct verity_config *vc,
+				     struct dm_verity_io *io, struct bio *clone)
+{
+	unsigned int original_vecs = clone->bi_vcnt;
+	struct bio_vec *bv;
+	VERITY_BUG_ON(!vc || !io || !clone, "NULL arguments");
+
+	/* No work to do. */
+	if (!io->leading_pages && !io->trailing_pages)
+		return;
+
+	/* Determine which pages are ours with one page per vector. */
+	original_vecs -= io->leading_pages + io->trailing_pages;
+
+	/* Handle any leading pages */
+	bv = bio_iovec_idx(clone, 0);
+	while(io->leading_pages--) {
+		if (unlikely(bv->bv_page == NULL)) {
+			VERITY_BUG("missing leading bv_page in padding");
+			bv++;
+			continue;
+		}
+		mempool_free(bv->bv_page, vc->page_pool);
+		bv->bv_page = NULL;
+		bv++;
+	}
+	bv += original_vecs;
+	/* TODO(wad) This is probably off-by-one */
+	while(io->trailing_pages--) {
+		if (unlikely(bv->bv_page == NULL)) {
+			VERITY_BUG("missing leading bv_page in padding");
+			bv++;
+			continue;
+		}
+		mempool_free(bv->bv_page, vc->page_pool);
+		bv->bv_page = NULL;
+		bv++;
+	}
+}
+
+static void kverityd_verify_cleanup(struct dm_verity_io *io, int error)
+{
+	struct verity_config *vc = io->target->private;
+	/* Clean up the pages used for padding, if any. */
+	verity_free_buffer_pages(vc, io, io->ctx.bio);
+
+	/* Release padded bio, if one was used. */
+	if (io->ctx.bio != io->base_bio) {
+		bio_put(io->ctx.bio);
+		io->ctx.bio = NULL;
+	}
+	/* Propagate the verification error. */
+	io->error = error;
+}
+
+/* If the request is not successful, this handler takes action.
+ * TODO make this call a registered handler. */
+static void verity_error(struct verity_config *vc, struct dm_verity_io *io,
+			 int error) {
+	if (io)
+		io->error = -EIO;
+
+	switch (error) {
+	case -EACCES:
+		DMERR_LIMIT("verification failure occurred");
+		if (error_behavior == DM_VERITY_REBOOT) {
+#ifdef CONFIG_KEXEC
+			kernel_kexec();
+#else
+			/* Test this versus emergency_restart(); */
+			kernel_restart("dm-verity");
+#endif
+		} else if (error_behavior == DM_VERITY_NOTHING) {
+			/* IO errors have to be propagated. */
+			if (error != -EIO && io) {
+				io->error = 0;
+			}
+		}
+		return;
+	default:
+		break;
+	}
+}
+
+/*-----------------------------------------------------------------
+ * Reverse flow of requests into the device.
+ *
+ * (Start at the bottom with verity_map and work your way upward).
+ *-----------------------------------------------------------------*/
+
+static void verity_inc_pending(struct dm_verity_io *io);
+
+/* verity_dec_pending manages the lifetime of all dm_verity_io structs.
+ * Non-bug error handling is centralized through this interface and
+ * all passage from workqueue to workqueue. */
+static void verity_dec_pending(struct dm_verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	struct bio *base_bio = io->base_bio;
+	int error = io->error;
+	VERITY_BUG_ON(!io, "NULL argument");
+
+	DMDEBUG("dec pending %p: %d--", io, atomic_read(&io->pending));
+
+	if (!atomic_dec_and_test(&io->pending))
+		goto more_work_to_do;
+
+	if (unlikely(error)) {
+		/* We treat bad I/O as a compromise so that we go
+		 * to recovery mode. VERITY_BUG will just reboot on
+		 * e.g., OOM errors. */
+		verity_error(vc, io, error);
+		/* let the handler change the error. */
+		error = io->error;
+		goto return_to_user;
+	}
+
+	if (io->next_queue == DM_VERITY_IO) {
+		kverityd_queue_io(io, true);
+		DMDEBUG("io %p requeued for io");
+		goto more_work_to_do;
+	} 
+
+	if (io->next_queue == DM_VERITY_VERIFY) {
+		verity_stats_io_queue_dec(vc);
+		verity_stats_verify_queue_inc(vc);
+		kverityd_queue_verify(io);
+		DMDEBUG("io %p enqueued for verify");
+		goto more_work_to_do;
+	}
+
+return_to_user:
+	/* else next_queue == DM_VERITY_NONE */
+	mempool_free(io, vc->io_pool);
+
+	/* Return back to the caller */
+	bio_endio(base_bio, error);
+
+more_work_to_do:
+	return;
+}
+
+/* Walks the, potentially padded, data set and computes the hash of the
+ * data read from the untrusted source device.  The computed hash is
+ * then passed to dm-bht for verification. */
+static int verity_verify(struct verity_config *vc,
+			 struct verify_context *ctx)
+{
+	u8 digest[VERITY_MAX_DIGEST_SIZE];
+	int r;
+	u32 block = 0;
+	unsigned int digest_size = 
+		crypto_hash_digestsize(vc->hash[smp_processor_id()].tfm);
+	
+	while (ctx->idx < ctx->bio->bi_vcnt) {
+		r = verity_hash_bv(vc, ctx);
+		if (r < 0) {
+			goto bad_hash;
+		}
+
+		/* Continue until all the data expected is processed */
+		if (ctx->needed) {
+			/* idx is incremented in hash_bv */
+			continue;
+		}
+		/* Calculate the final block digest to check in the tree */
+		if (crypto_hash_final(&vc->hash[smp_processor_id()], digest)) {
+			DMCRIT("Failed to compute final digest");
+			r = -EFAULT;
+			goto bad_state;
+		}
+		block = (u32)(ctx->block);
+		r = dm_bht_verify_block(&vc->bht, block, digest, digest_size);
+		/* dm_bht functions aren't expected to return errno friendly
+		 * values.  They are converted here for uniformity. */
+		if (r > 0) {
+			DMERR("Pending data for block %llu seen at verify",
+			      ULL(ctx->block));
+			r = -EBUSY;
+			goto bad_state;
+		}
+		if (r < 0) {
+			DMERR_LIMIT("Block hash does not match!");
+			r = -EACCES;
+			goto bad_match;
+		}
+		REQTRACE("Block %llu verified", ULL(ctx->block));
+
+		/* Reset state for the next block */
+		if (crypto_hash_init(&vc->hash[smp_processor_id()])) {
+			DMCRIT("Failed to initialize the crypto hash");
+			r = -ENOMEM;
+			goto no_mem;
+		}
+		ctx->needed = PAGE_SIZE;
+		ctx->block++;
+		/* After completing a block, allow a reschedule.
+		 * TODO(wad) determine if this is truly needed. */
+		cond_resched();
+	}
+
+	return 0;
+
+bad_hash:
+no_mem:
+bad_state:
+bad_match:
+	return r;
+}
+
+/* Services the verify workqueue */
+static void kverityd_verify(struct work_struct *work)
+{
+	struct delayed_work *dwork = container_of(work, struct delayed_work,
+						  work);
+	struct dm_verity_io *io = container_of(dwork, struct dm_verity_io,
+					       work);
+	struct verity_config *vc = io->target->private;
+	int r = 0;
+
+	verity_inc_pending(io);
+
+	/* Default to ctx.bio as the padded bio clone.
+	 * The original bio is never touched until release. */
+	r = verity_verify_context_init(vc, &io->ctx);
+
+	/* Only call verify if context initialization succeeded */
+	if (!r)
+		r = verity_verify(vc, &io->ctx);
+	/* Free up the padded bio and tag with the return value */
+	kverityd_verify_cleanup(io, r);
+	verity_stats_verify_queue_dec(vc);
+
+	verity_dec_pending(io);
+}
+
+/* After all I/O is completed successfully for a request, it is queued on the
+ * verify workqueue to ensure its integrity prior to returning it to the
+ * caller.  There may be multiple workqueue threads - one per logical
+ * processor. */
+static void kverityd_queue_verify(struct dm_verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	/* verify work should never be requeued. */
+	io->next_queue = DM_VERITY_NONE;
+	REQTRACE("Block %llu+ is being queued for verify (io:%p)",
+		 ULL(io->block), io);
+	INIT_DELAYED_WORK(&io->work, kverityd_verify);
+	/* No delay needed. But if we move over jobs with pending io, then
+	 * we could probably delay them here. */
+	queue_delayed_work(vc->verify_queue, &io->work, 0);
+}
+
+/* Asynchronously called upon the completion of dm-bht I/O.  The status
+ * of the operation is passed back to dm-bht and the next steps are
+ * decided by verity_dec_pending. */
+static void kverityd_io_bht_populate_end(struct bio *bio, int error)
+{
+	struct dm_bht_entry *entry = (struct dm_bht_entry *) bio->bi_private;
+	struct dm_verity_io *io = (struct dm_verity_io *) entry->io_context;
+
+	DMDEBUG("kverityd_io_bht_populate_end (io:%p, entry:%p)", io, entry);
+	/* Tell the tree to atomically update now that we've populated
+	 * the given entry. */
+	dm_bht_read_completed(entry, error);
+
+	/* Clean up for reuse when reading data to be checked */
+	bio->bi_vcnt = 0; 
+	bio->bi_io_vec->bv_offset = 0;
+	bio->bi_io_vec->bv_len = 0;
+	bio->bi_io_vec->bv_page = NULL;
+	/* Restore the private data to I/O so the destructor can be shared. */
+	bio->bi_private = (void *) io;
+	bio_put(bio);
+
+	/* We bail but assume the tree has been marked bad. */
+	if (unlikely(error)) {
+		DMERR("Failed to read for block %llu (%u)",
+		      ULL(io->base_bio->bi_sector), io->base_bio->bi_size);
+		io->error = error;
+		/* Pass through the error to verity_dec_pending below */
+	}
+	/* When pending = 0, it will transition to reading real data */
+	verity_dec_pending(io);
+}
+
+/* Called by dm-bht (via dm_bht_populate), this function provides
+ * the message digests to dm-bht that are stored on disk. */
+static int kverityd_bht_read_callback(void *ctx, sector_t start, u8 *dst,
+				      sector_t count, struct dm_bht_entry *entry)
+{
+	struct dm_verity_io *io = ctx;  /* I/O for this batch */
+	struct verity_config *vc;
+	struct bio *bio;
+	VERITY_BUG_ON(!io || !dst || !io->target || !io->target->private);
+	VERITY_BUG_ON(!entry);
+	VERITY_BUG_ON(count != to_sector(PAGE_SIZE));
+
+	vc = io->target->private;
+
+	/* The I/O context is nested inside the entry so that we don't need one
+	 * io context per page read. */
+	entry->io_context = ctx;
+
+	/* We should only get page size requests at present. */
+	verity_inc_pending(io);
+	bio = verity_alloc_bioset(vc, GFP_NOIO, 1);
+	if (unlikely(!io->ctx.bio)) {
+		DMCRIT("Out of memory at bio_alloc_bioset");
+		dm_bht_read_completed(entry, -ENOMEM);
+		return -ENOMEM;
+	}
+	bio->bi_private = (void *) entry;
+	bio->bi_idx = 0;
+	bio->bi_size = PAGE_SIZE;
+	bio->bi_sector = vc->hash_start + start;
+	bio->bi_bdev = vc->hash_dev->bdev;
+	bio->bi_end_io = kverityd_io_bht_populate_end;
+	/* Instead of using NOIDLE, we unplug on intervals */
+	bio->bi_rw = (1 << BIO_RW_META);
+	/* Only need to free the bio since the page is managed by bht */
+	bio->bi_destructor = dm_verity_bio_destructor;
+	bio->bi_vcnt = 1; 
+	bio->bi_io_vec->bv_offset = 0;
+	bio->bi_io_vec->bv_len = to_bytes(count);
+	/* dst is guaranteed to be a page_pool allocation */
+	bio->bi_io_vec->bv_page = virt_to_page(dst);
+	/* Track that this I/O is in use.  There should be no risk of the io
+	 * being removed prior since this is called synchronously */
+	DMDEBUG("Submitting bht io %p (entry:%p)", io, entry);
+	generic_make_request(bio);
+	return 0;
+}
+
+/* Performs the work of loading in any missing bht hashes. */
+static void kverityd_io_bht_populate(struct dm_verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	struct request_queue *r_queue = bdev_get_queue(vc->hash_dev->bdev);
+	int populated = 0;
+	int io_status = 0;
+	sector_t count;
+
+	verity_inc_pending(io);
+	/* Submits an io request for each missing block of block hashes.
+	 * The last one to return will then enqueue this on the
+	 * io workqueue.  */
+	REQTRACE("populating %llu starting at block %llu (io:%p)",
+		 ULL(io->count), ULL(io->block), io);
+	for (count = 0; count < io->count; ++count) {
+		u32 block = (u32)(io->block + count);
+		/* Check for truncation. */
+		VERITY_BUG_ON((sector_t)(block) < io->block);
+		/* populate for each block */
+		DMDEBUG("Calling dm_bht_populate for %u (io:%p)", block, io);
+		populated = dm_bht_populate(&vc->bht, io, block);
+		if (populated < 0) {
+			DMCRIT("dm_bht_populate error for block %u (io:%p): %d",
+			       block, io, populated);
+			/* verity_dec_pending will handle the error case. */
+			io->error = -EPERM;
+			break;
+		}
+		/* Accrue view of all I/O state for the full request */
+		io_status |= populated;
+
+		/* If this io has outstanding requests, unplug the io queue */
+		if (populated & DM_BHT_ENTRY_REQUESTED) {
+			blk_unplug(r_queue);
+		}
+		/* Break the contention.  If cond_resched() isn't appropriate,
+		 * msleep_interruptible(1) may suffice. */
+		cond_resched();
+	}
+	REQTRACE("Block %llu+ initiated %d requests (io: %p)",
+		 ULL(io->block), atomic_read(&io->pending) - 1, io);
+
+	/* TODO(wad) clean up the return values from maybe_read_entries */
+	/* If we return verified explicitly, then later we could do IO_REMAP
+	 * instead of resending to the verify queue */
+	io->next_queue = DM_VERITY_VERIFY;
+	if (io_status == 0 || io_status == DM_BHT_ENTRY_READY) {
+		/* The whole request is ready. Make sure we can transition. */
+		DMDEBUG("io ready to be bumped %p", io);
+	}
+
+	if (io_status & DM_BHT_ENTRY_REQUESTED) {
+		/* If no data is pending another I/O request, this io
+		 * will get bounced on the next queue when the last async call
+		 * returns. */
+		DMDEBUG("io has outstanding requests %p");
+	}
+
+	/* Some I/O is pending outside of this request. */
+	if (io_status & DM_BHT_ENTRY_PENDING) {
+		/* PENDING will cause a BHT requeue as delayed work */
+		/* TODO(wad) add a callback to dm-bht for pending_cb. Then for
+		 * each entry, the io could be delayed heavily until the end
+		 * read cb requeue them. (entries could be added to the
+		 * stored I/O context but races could be a challenge.  */
+		DMDEBUG("io is pending %p");
+		io->next_queue = DM_VERITY_IO;
+	}
+
+	/* If I/O requests were issues on behalf of populate, then the last
+	 * request will result in a requeue.  If all data was pending from
+	 * other requests, this will be requeued now. */
+	verity_dec_pending(io);
+}
+
+/* Asynchronously called upon the completion of I/O issued
+ * from kverityd_src_io_read. verity_dec_pending() acts as
+ * the scheduler/flow manager. */
+static void kverityd_src_io_read_end(struct bio *clone, int error)
+{
+	struct dm_verity_io *io = clone->bi_private;
+	struct verity_config *vc = io->target->private;
+	/* struct verity_config *vc = io->target->private; */
+
+	DMDEBUG("Padded I/O completed");
+	if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !error))
+		error = -EIO;
+
+	if (unlikely(error)) {
+		DMERR("Error occurred: %d (%llu, %u)",
+			error, ULL(clone->bi_sector), clone->bi_size);
+		io->error = error;
+		/* verity_dec_pending will pick up the error, but it won't
+		 * free the leading/trailing pages for us. */
+		verity_free_buffer_pages(vc, io, io->ctx.bio);
+		/* drop the padded bio since we'll never use it now. */
+		bio_put(io->ctx.bio);
+	}
+
+	/* Release the clone which just avoids the block layer from
+	 * leaving offsets, etc in unexpected states. */
+	bio_put(clone);
+
+	verity_dec_pending(io);
+	DMDEBUG("all data has been loaded from the data device");
+}
+
+/* If not yet underway, an I/O request will be issued to the vc->dev
+ * device for the data needed.  It is padded to the minimum block
+ * size, aligned to that size, and cloned to avoid unexpected changes
+ * to the original bio struct. */
+static void kverityd_src_io_read(struct dm_verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	struct bio *base_bio = io->base_bio;
+	sector_t bio_start = vc->start + io->sector;
+	unsigned int leading_bytes = 0;
+	unsigned int trailing_bytes = 0;
+	unsigned int bio_size = base_bio->bi_size;
+	unsigned int vecs_needed = bio_segments(base_bio);
+	struct bio_vec *cur_bvec = NULL;
+	struct bio *clone = NULL;
+
+	VERITY_BUG_ON(!io);
+
+	/* If bio is non-NULL, then the data is already read. Could also check
+	 * BIO_UPTODATE, but it doesn't seem needed. */
+	if (io->ctx.bio) {
+		DMDEBUG("io_read called with existing bio. bailing: %p", io);
+		return;
+	}
+	DMDEBUG("kverity_io_read started");
+
+	verity_inc_pending(io);
+	/* We duplicate the bio here for two reasons:
+	 * 1. The block layer may modify the bvec array
+	 * 2. We may need to pad to BLOCK_SIZE
+	 * First, we have to determine if we need more segments than are
+	 * currently in use. */
+	verity_align_request(vc, &bio_start, &bio_size);
+	/* Number of bytes alignment added to the start */
+	leading_bytes = to_bytes((vc->start + io->sector) - bio_start);
+	/* ... to the end of the original bio. */
+	trailing_bytes = (bio_size - leading_bytes) - base_bio->bi_size;
+
+	/* Additions are page aligned so page sized vectors can be padded in */
+	vecs_needed += PAGE_ALIGN(leading_bytes) >> PAGE_SHIFT;
+	vecs_needed += PAGE_ALIGN(trailing_bytes) >> PAGE_SHIFT; 
+
+	DMDEBUG("allocating bioset for padding (%u)", vecs_needed);
+	/* Allocate the bioset for the duplicate plus padding */
+	if (vecs_needed == bio_segments(base_bio)) {
+		/* No padding is needed so we can just verify using the
+		 * original bio. */
+		DMDEBUG("No padding needed!");
+		io->ctx.bio = base_bio;
+	} else {
+		ALLOCTRACE("bioset for io %p, sector %llu",
+			   io, ULL(bio_start));
+		io->ctx.bio = verity_alloc_bioset(vc, GFP_NOIO, vecs_needed);
+		if (unlikely(io->ctx.bio == NULL)) {
+			DMCRIT("Failed to allocate padded bioset");
+			io->error = -ENOMEM;
+			verity_dec_pending(io);
+			return;
+		}
+
+		DMDEBUG("clone init");
+		clone_init(io, io->ctx.bio, vecs_needed, bio_size, bio_start);
+		/* Now we need to copy over the iovecs, but we need to make
+		 * sure to offset if we realigned the request. */
+		cur_bvec = io->ctx.bio->bi_io_vec;
+
+		DMDEBUG("Populating padded bioset (%u %u)",
+			leading_bytes, trailing_bytes);
+		DMDEBUG("leading_bytes == %u", leading_bytes);
+		cur_bvec = populate_bio_vec(cur_bvec, vc->page_pool,
+					    leading_bytes, &io->leading_pages);
+		if (unlikely(cur_bvec == NULL)) {
+				io->error = -ENOMEM;
+				verity_free_buffer_pages(vc, io, io->ctx.bio);
+				bio_put(io->ctx.bio);
+				verity_dec_pending(io);
+				return;
+		}
+		/* Now we should be aligned to copy the bio_vecs in place */
+		DMDEBUG("copying original bvecs");
+		memcpy(cur_bvec, bio_iovec(base_bio),
+		       sizeof(struct bio_vec) * bio_segments(base_bio));
+		cur_bvec += bio_segments(base_bio);
+		/* Handle trailing vecs */
+		DMDEBUG("trailing_bytes == %u", trailing_bytes);
+		cur_bvec = populate_bio_vec(cur_bvec, vc->page_pool,
+					    trailing_bytes,
+					    &io->trailing_pages);
+		if (unlikely(cur_bvec == NULL)) {
+			io->error = -ENOMEM;
+			verity_free_buffer_pages(vc, io, io->ctx.bio);
+			bio_put(io->ctx.bio);
+			verity_dec_pending(io);
+			return;
+		}
+	}
+
+	/* Now clone the padded request */
+	DMDEBUG("Creating clone of the padded request");
+	ALLOCTRACE("clone for io %p, sector %llu",
+		   io, ULL(bio_start));
+	clone = verity_alloc_bioset(vc, GFP_NOIO, bio_segments(io->ctx.bio));
+	if (unlikely(!clone)) {
+		io->error = -ENOMEM;
+		/* Clean up */
+		verity_free_buffer_pages(vc, io, io->ctx.bio);
+		if (io->ctx.bio != base_bio)
+			bio_put(io->ctx.bio);
+		verity_dec_pending(io);
+		return;
+	}
+
+	clone_init(io, clone, bio_segments(io->ctx.bio), io->ctx.bio->bi_size,
+		   bio_start);
+	DMDEBUG("Populating clone of the padded request");
+	memcpy(clone->bi_io_vec, bio_iovec(io->ctx.bio),
+	       sizeof(struct bio_vec) * clone->bi_vcnt);
+
+	/* Submit to the block device */
+	DMDEBUG("Submitting padded bio (%u became %u)",
+		bio_sectors(base_bio), bio_sectors(clone));
+	/* XXX: check queue_max_hw_sectors(bdev_get_queue(clone->bi_bdev)); */
+	generic_make_request(clone);
+}
+
+/* kverityd_io services the I/O workqueue. For each pass through
+ * the I/O workqueue, a call to populate both the origin drive
+ * data and the hash tree data is made. */
+static void kverityd_io(struct work_struct *work)
+{
+	struct delayed_work *dwork = container_of(work, struct delayed_work,
+						  work);
+	struct dm_verity_io *io = container_of(dwork, struct dm_verity_io,
+					       work);
+	VERITY_BUG_ON(!io->base_bio);
+
+	if (bio_data_dir(io->base_bio) == WRITE) {
+		/* TODO(wad) do something smarter when writes are seen */
+		printk(KERN_WARNING
+		       "Unexpected write bio received in kverityd_io");
+		io->error = -EIO;
+		return;
+	}
+
+	/* Issue requests asynchronously. */
+	verity_inc_pending(io);
+	kverityd_src_io_read(io);  /* never updates next_queue */
+	kverityd_io_bht_populate(io);   /* manage next_queue eligibility */
+	verity_dec_pending(io);
+}
+
+/* All incoming requests are queued on the I/O workqueue at least once to
+ * acquire both the data from the real device (vc->dev) and any data from the
+ * hash tree device (vc->hash_dev) needed to verify the integrity of the data.
+ * There may be multiple I/O workqueues - one per logical processor. */
+static void kverityd_queue_io(struct dm_verity_io *io, bool delayed)
+{
+	struct verity_config *vc = io->target->private;
+	unsigned long delay = 0;  /* jiffies */
+	/* Send all requests through one call to dm_bht_populate on the
+	 * queue to ensure that all blocks are accounted for before
+	 * proceeding on to verification.
+	 */
+	INIT_DELAYED_WORK(&io->work, kverityd_io);
+	/* If this context is dependent on work from another context, we just
+	 * requeue with a delay.  Later we could bounce this work to the verify
+	 * queue and have it wait there. TODO(wad) */
+	if (delayed) {
+		delay = HZ / 10;
+		REQTRACE("block %llu+ is being delayed %lu jiffies (io:%p)",
+			 ULL(io->block), delay, io);
+	}
+	queue_delayed_work(vc->io_queue, &io->work, delay);
+}
+
+/* Paired with verity_dec_pending, the pending value in the io dictate the
+ * lifetime of a request and when it is ready to be processed on the
+ * workqueues. */
+static void verity_inc_pending(struct dm_verity_io *io)
+{
+	atomic_inc(&io->pending);
+}
+
+/* Block-level requests start here. */
+static int verity_map(struct dm_target *ti, struct bio *bio,
+		      union map_info *map_context) {
+	struct dm_verity_io *io;
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
+	/* Barriers are passed through. Since the device is read-only,
+	 * barrier use seems unlikely but being data-free shouldn't be blocked
+	 * here. */
+	if (unlikely(bio_empty_barrier(bio))) {
+		bio->bi_bdev = vc->dev->bdev;
+		return DM_MAPIO_REMAPPED;
+	}
+
+	/* Trace incoming bios */
+	REQTRACE("Got a %s for %llu, %u bytes)",
+		(bio_rw(bio) == WRITE ? "WRITE" :
+		(bio_rw(bio) == READ ? "READ" : "READA")),
+		ULL(bio->bi_sector), bio->bi_size);
+
+	verity_stats_total_requests_inc(vc);
+
+	if (bio_data_dir(bio) == WRITE) {
+		/* If we silently drop writes, then the VFS layer will cache
+		 * the write and persist it in memory. While it doesn't change
+		 * the underlying storage, it still may be contrary to the
+		 * behavior expected by a verified, read-only device. */
+		DMWARN_LIMIT("write request received. rejecting with -EIO.");
+		verity_error(vc, NULL, -EIO);
+		/* bio_endio(bio, -EIO); */
+		return -EIO;
+	} else {
+		/* Queue up the request to be verified */
+		io = verity_io_alloc(ti, bio, bio->bi_sector - ti->begin);
+		if (!io) {
+			DMERR_LIMIT("Failed to allocate and init IO data");
+			return DM_MAPIO_REQUEUE;
+		}
+		verity_stats_io_queue_inc(vc);
+		kverityd_queue_io(io, false);
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
+ * Construct an verified mapping:
+ *  <device_to_verify> <device_with_hash_data>
+ *  <page_aligned_offset_to_hash_data>
+ *  <tree_depth> <hash_alg> <hash-of-bundle-hashes>
+ * E.g.,
+ *   /dev/sda2 /dev/sda3 0 2 sha256
+ *   f08aa4a3695290c569eb1b0ac032ae1040150afb527abbeb0a3da33d82fb2c6e
+ *
+ * TODO(wad):
+ * - Add stats: num_requeues, num_ios, etc with proc ibnterface
+ * - Boot time addition
+ * - Track block verification to free block_hashes if memory use is a concern
+ * Testing needed:
+ * - Regular slub_debug tracing (on checkins)
+ * - Improper block hash padding
+ * - Improper bundle padding
+ * - Improper hash layout
+ * - Missing padding at end of device
+ * - Improperly sized underlying devices
+ * - Out of memory conditions (make sure this isn't too flaky under high load!)
+ * - Incorrect superhash
+ * - Incorrect block hashes
+ * - Incorrect bundle hashes
+ * - Boot-up read speed; sustained read speeds
+ */
+static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct verity_config *vc;
+	int cpu = 0;
+	int ret = 0;
+	int depth;
+	unsigned long long tmpull = 0;
+	sector_t blocks;
+
+	if (argc != 6) {
+		ti->error = "Not enough arguments supplied";
+		return -EINVAL;
+	}
+
+	/* The device mapper device should be setup read-only */
+	if ((dm_table_get_mode(ti->table) & ~FMODE_READ) != 0) {
+		ti->error = "Must be created readonly.";
+		return -EINVAL;
+	}
+
+	ALLOCTRACE("verity_config");
+	vc = kzalloc(sizeof(*vc), GFP_KERNEL);
+	if (!vc) {
+		/* TODO(wad) if this is called from the setup helper, then we
+		 * catch these errors and do a CrOS specific thing. if not, we
+		 * need to have this call the error handler. */
+		return -EINVAL;
+	}
+
+	
+	/* arg3: blocks in a bundle */
+	if (sscanf(argv[3], "%u", &depth) != 1 ||
+	    depth <= 0) {
+		ti->error =
+			"Zero or negative depth supplied";
+		goto bad_depth;
+	}
+	/* dm-bht block size is HARD CODED to PAGE_SIZE right now. */
+	/* Calculate the blocks from the given device size */
+	blocks = to_bytes(ti->len) >> PAGE_SHIFT;
+	if (dm_bht_create(&vc->bht, (unsigned int)depth, blocks, argv[4])) {
+		DMERR("failed to create required bht");
+		goto bad_bht;
+	}
+	if (dm_bht_set_root_hexdigest(&vc->bht, argv[5])) {
+		DMERR("root hexdigest error");
+		goto bad_root_hexdigest;
+	}
+	dm_bht_set_read_cb(&vc->bht, kverityd_bht_read_callback);
+
+	/* arg0: device to verify */
+	vc->start = 0;  /* TODO: should this support a starting offset? */
+	/* We only ever grab the device in read-only mode. */
+	if ((ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+				 &vc->dev))) {
+		DMERR("Failed to acquire device '%s': %d", argv[0], ret);
+		ti->error = "Device lookup failed";
+		goto bad_verity_dev;
+	}
+
+	if (PAGE_ALIGN(vc->start) != vc->start ||
+	    PAGE_ALIGN(to_bytes(ti->len)) != to_bytes(ti->len)) {
+		ti->error = "Device must be PAGE_SIZE divisble/aligned";
+		goto bad_hash_start;
+	}
+
+	/* arg2: offset to hash on the hash device */
+	if (sscanf(argv[2], "%llu", &tmpull) != 1) {
+		ti->error =
+			"Invalid hash_start supplied";
+		goto bad_hash_start;
+	}
+	vc->hash_start = (sector_t)(tmpull);
+
+	/* arg1: device with hashes.
+	 * Note, arg1 == arg0 is okay as long as the size of
+	 *       ti->len passed to device mapper does not include
+	 *       the hashes. */
+	if (dm_get_device(ti, argv[1], dm_table_get_mode(ti->table),
+			  &vc->hash_dev)) {
+		ti->error = "Hash device lookup failed";
+		goto bad_hash_dev;
+	}
+
+	/* We leave the validity on the hash device open until the
+	 * next arg.  Then we go ahead and try to read in all the bundle
+	 * hashes which live after the block hashes.  If it fails, then
+	 * the hash offset was wrong. */
+
+
+	/* arg4: cryptographic digest algorithm */
+	if (snprintf(vc->hash_alg, CRYPTO_MAX_ALG_NAME, "%s", argv[4]) >=
+	    CRYPTO_MAX_ALG_NAME) {
+		ti->error = "Hash algorithm name is too long";
+		goto bad_hash;
+	}
+	/* Allocate enough crypto contexts to be able to perform verifies
+	 * on all available CPUs */
+	ALLOCTRACE("hash_desc array");
+	vc->hash = (struct hash_desc *)
+		      kcalloc(nr_cpu_ids, sizeof(struct hash_desc), GFP_KERNEL);
+	if (!vc->hash) {
+		DMERR("failed to allocate crypto hash contexts");
+		return -ENOMEM;
+	}
+
+	/* Setup the hash first. Its length determines much of the bht layout */
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
+		ALLOCTRACE("hash_tfm (per-cpu)");
+		vc->hash[cpu].tfm = crypto_alloc_hash(vc->hash_alg, 0, 0);
+		if (IS_ERR(vc->hash[cpu].tfm)) {
+			DMERR("failed to allocate crypto hash '%s'",
+			      vc->hash_alg);
+			vc->hash[cpu].tfm = NULL;
+			goto bad_hash_alg;
+		}
+	}
+
+	/* TODO: Maybe issues a request on the io queue for block 0? */
+
+	/* Argument processing is done, setup operational data */
+	/* Pool for dm_verity_io objects */
+	ALLOCTRACE("slab pool for io objects");
+	vc->io_pool = mempool_create_slab_pool(MIN_IOS, _verity_io_pool);
+	if (!vc->io_pool) {
+		ti->error = "Cannot allocate verity io mempool";
+		goto bad_slab_pool;
+	}
+
+	/* Used to allocate pages for padding requests to PAGE_SIZE */
+	ALLOCTRACE("page pool for request padding");
+	vc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
+	if (!vc->page_pool) {
+		ti->error = "Cannot allocate page mempool";
+		goto bad_page_pool;
+	}
+
+	/* Allocate the bioset used for request padding */
+	/* TODO(wad) allocate a separate bioset for the first verify maybe */
+	ALLOCTRACE("bioset for I/O reqs");
+	vc->bs = bioset_create(MIN_BIOS, 0);
+	if (!vc->bs) {
+		ti->error = "Cannot allocate verity bioset";
+		goto bad_bs;
+	}
+
+	/* Only one thread for the workqueue to keep the memory allocation
+	 * sane.  Requests will be submitted asynchronously. blk_unplug() will
+	 * be called at the end of each dm_populate call so that the async
+	 * requests are batched per workqueue job */
+	vc->io_queue = create_workqueue("kverityd_io");
+	if (!vc->io_queue) {
+		ti->error = "Couldn't create kverityd io queue";
+		goto bad_io_queue;
+	}
+
+	vc->verify_queue = create_workqueue("kverityd");
+	if (!vc->verify_queue) {
+		ti->error = "Couldn't create kverityd queue";
+		goto bad_verify_queue;
+	}
+
+	ti->num_flush_requests = 1;
+	ti->private = vc;
+
+	/* TODO(wad) add device and hash device names */
+	{
+		char hashdev[BDEVNAME_SIZE], vdev[BDEVNAME_SIZE];
+		bdevname(vc->hash_dev->bdev, hashdev);
+		bdevname(vc->dev->bdev, vdev);
+		DMINFO("dev:%s hash:%s [sectors:%llu blocks:%llu]", vdev,
+		       hashdev, ULL(dm_bht_sectors(&vc->bht)), ULL(blocks));
+	}
+	return 0;
+
+bad_verify_queue:
+	destroy_workqueue(vc->io_queue);
+bad_io_queue:
+	bioset_free(vc->bs);
+bad_bs:
+	mempool_destroy(vc->page_pool);
+bad_page_pool:
+	mempool_destroy(vc->io_pool);
+bad_slab_pool:
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu)
+		if (vc->hash[cpu].tfm)
+			crypto_free_hash(vc->hash[cpu].tfm);
+bad_hash_alg:
+bad_hash:
+	kfree(vc->hash);
+	dm_put_device(ti, vc->hash_dev);
+bad_hash_dev:
+bad_hash_start:
+	dm_put_device(ti, vc->dev);
+bad_depth:
+bad_bht:
+bad_root_hexdigest:
+bad_verity_dev:
+	kfree(vc);   /* hash is not secret so no need to zero */
+	return -EINVAL;
+}
+
+static void verity_dtr(struct dm_target *ti)
+{
+	struct verity_config *vc = (struct verity_config *) ti->private;
+	int cpu;
+
+	DMDEBUG("Destroying io_queue");
+	destroy_workqueue(vc->io_queue);
+	DMDEBUG("Destroying verify_queue");
+	destroy_workqueue(vc->verify_queue);
+
+	DMDEBUG("Destroying bs");
+	bioset_free(vc->bs);
+	DMDEBUG("Destroying page_pool");
+	mempool_destroy(vc->page_pool);
+	DMDEBUG("Destroying io_pool");
+	mempool_destroy(vc->io_pool);
+	DMDEBUG("Destroying crypto hash");
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu)
+		if (vc->hash[cpu].tfm)
+			crypto_free_hash(vc->hash[cpu].tfm);
+	kfree(vc->hash);
+
+	DMDEBUG("Destroying block hash tree");
+	dm_bht_destroy(&vc->bht);
+
+	DMDEBUG("Putting hash_dev");
+	dm_put_device(ti, vc->hash_dev);
+
+	DMDEBUG("Putting dev");
+	dm_put_device(ti, vc->dev);
+	DMDEBUG("Destroying config");
+	kfree(vc);
+}
+
+static int verity_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned int maxlen) {
+	struct verity_config *vc = (struct verity_config *) ti->private;
+	unsigned int sz = 0;
+	char hashdev[BDEVNAME_SIZE], vdev[BDEVNAME_SIZE];
+        u8 hexdigest[VERITY_MAX_DIGEST_SIZE * 2 + 1] = { 0 };
+
+	dm_bht_root_hexdigest(&vc->bht, hexdigest, sizeof(hexdigest));
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%u %u %u %u %llu",
+		       vc->stats.io_queue,
+		       vc->stats.verify_queue,
+		       vc->stats.average_requeues,
+		       vc->stats.total_requeues,
+		       vc->stats.total_requests);
+		break;
+
+	case STATUSTYPE_TABLE:
+		bdevname(vc->hash_dev->bdev, hashdev);
+		bdevname(vc->dev->bdev, vdev);
+		DMEMIT("/dev/%s /dev/%s %llu %u %s %s",
+			vdev,
+			hashdev,
+			ULL(vc->hash_start),
+			vc->bht.depth,
+			vc->hash_alg,
+			hexdigest);
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
+	/*
+	 * Set this to the vc->dev value:
+	 blk_limits_io_min(limits, chunk_size); */
+	blk_limits_io_opt(limits, PAGE_SIZE);
+}
+
+static struct target_type verity_target = {
+	.name   = "verity",
+	.version = {0, 1, 0},
+	.module = THIS_MODULE,
+	.ctr    = verity_ctr,
+	.dtr    = verity_dtr,
+	.map    = verity_map,
+	.merge  = verity_merge,
+	.status = verity_status,
+	.iterate_devices = verity_iterate_devices,
+	.io_hints = verity_io_hints,
+};
+
+static int __init dm_verity_init(void)
+{
+	int r;
+
+	_verity_io_pool = KMEM_CACHE(dm_verity_io, 0);
+	if (!_verity_io_pool)
+		return -ENOMEM;
+
+	r = dm_register_target(&verity_target);
+	if (r < 0) {
+		DMERR("register failed %d", r);
+		kmem_cache_destroy(_verity_io_pool);
+		/* TODO(wad): add optional recovery bail here. */
+	} else {
+		DMINFO("dm-verity registered");
+		/* TODO(wad): Add root setup to initcalls workqueue here */
+	}
+
+	return r;
+}
+
+static void __exit dm_verity_exit(void)
+{
+	dm_unregister_target(&verity_target);
+	kmem_cache_destroy(_verity_io_pool);
+}
+
+module_init(dm_verity_init);
+module_exit(dm_verity_exit);
+
+MODULE_AUTHOR("The Chromium OS Authors <chromium-os-dev@chromium.org>");
+MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity checking");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/dm-bht.h b/include/linux/dm-bht.h
new file mode 100644
index 0000000..62b093d
--- /dev/null
+++ b/include/linux/dm-bht.h
@@ -0,0 +1,137 @@
+/*
+ * Copyright (C) 2010 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *
+ * Device-Mapper block hash tree interface.
+ * See Documentation/device-mapper/dm-bht.txt for details.
+ *
+ * This file is released under the GPLv2.
+ */
+#ifndef __LINUX_DM_BHT_H
+#define __LINUX_DM_BHT_H
+
+#include <linux/compiler.h>
+#include <linux/crypto.h>
+#include <linux/mempool.h>
+#include <linux/types.h>
+
+/* To avoid allocating memory for digest tests, we just setup a
+ * max to use for now */
+#define DM_BHT_MAX_DIGEST_SIZE 128  /* 1k hashes are unlikely for now */
+
+/* UNALLOCATED, PENDING, READY, and VERIFIED are valid states. All other
+ * values are entry-related return codes. */
+#define DM_BHT_ENTRY_VERIFIED 8  /* All children match their hashes,
+				  * but not recursively. */
+#define DM_BHT_ENTRY_READY 4  /* data is loaded and available */
+#define DM_BHT_ENTRY_PENDING 2  /* data is being loaded */
+#define DM_BHT_ENTRY_REQUESTED 1  /* non-state response indicating entry is
+				   * pending because of the current call */
+#define DM_BHT_ENTRY_UNALLOCATED 0 /* untouched */
+#define DM_BHT_ENTRY_ERROR -1 /* entry is unsuitable for use */
+#define DM_BHT_ENTRY_ERROR_IO -2 /* I/O error on load */
+
+/* Additional possible return codes */
+#define DM_BHT_ENTRY_ERROR_MISMATCH -3 /* Digest mismatch */
+
+/* dm_bht_entry
+ * Contains dm_bht->node_count tree nodes at a given tree depth.
+ * state is used to transactionally assure that data is paged in
+ * from disk.  Unless dm_bht kept running crypto contexts for each
+ * level, we need to load in the data for on-demand verification. */
+struct dm_bht_entry {
+	atomic_t state; /* see defines */
+	/* Keeping an extra pointer per entry wastes up to ~33k of
+	 * memory if a 1m blocks are used (or 66 on 64-bit arch) */
+	void *io_context;  /* Reserve a pointer for use during io */
+	/* data should only be non-NULL if fully populated. */
+	u8 *nodes;  /* The hash data used to verify the children.
+		     * Guaranteed to be page-aligned. */
+        /* unsigned int verified[node_count/sizeof(unsigned)];  bitfield */
+};
+
+/* dm_bht_level
+ * Contains an array of entries which represent a page of hashes where
+ * each hash is a node in the tree at the given tree depth/level. */
+struct dm_bht_level {
+	struct dm_bht_entry *entries;  /* array of entries of tree nodes */
+	u32 count;  /* number of entries at this level */
+	sector_t sector;  /* starting sector for this level */
+};
+
+/* opaque context, start, databuf, sector_count */
+typedef int(*dm_bht_callback)(void *,  /* external context */
+			      sector_t,  /* start sector */
+			      u8 *,  /* destination page */
+			      sector_t,  /* num sectors */
+			      struct dm_bht_entry *);
+/* dm_bht - Device mapper block hash tree
+ * dm_bht provides a fixed interface for comparing data blocks
+ * against a cryptographic hashes stored in a hash tree. It
+ * optimizes the tree structure for storage on disk.
+ * 
+ * The tree is built from the bottom up.  A collection of data,
+ * external to the tree, is hashed and these hashes are stored
+ * as the blocks in the tree.  For some number of these hashes,
+ * a parent node is created by hashing them.  These steps are
+ * repeated.
+ *
+ * All hash storage memory is pre-allocated and freed once an
+ * entire branch has been verified.
+ * TODO(wad) support on-demand LRU of entry and entry nodes.
+ */
+struct dm_bht {
+	/* Configured values */
+	/* ENFORCE: depth must be >= 2. */
+	unsigned int depth;  /* Depth of the tree including the root */
+        u32 block_count;  /* Number of blocks hashed */
+	char hash_alg[CRYPTO_MAX_ALG_NAME];
+
+	/* Computed values */
+	unsigned int node_count;  /* Data size (in hashes) for each entry */
+	unsigned int node_count_shift;  /* first bit set - 1 */
+	/* There is one per CPU so that verified can be simultaneous. */
+	struct hash_desc *hash_desc;  /* Container for the hash alg */
+	unsigned int digest_size;
+	sector_t sectors;  /* Number of disk sectors used */
+
+	/* bool verified;  Full tree is verified */
+	u8 *root_digest;  /* hash_alg(levels[0].entries[*].nodes) */
+	bool root_verified;
+	struct dm_bht_level *levels;  /* in reverse order */
+	mempool_t *entry_pool;
+	/* Callbacks for reading and/or writing to the hash device */
+	dm_bht_callback read_cb;
+	dm_bht_callback write_cb;
+};
+
+/* Constructor for struct dm_bht instances. */
+int dm_bht_create(struct dm_bht *bht, 
+		  unsigned int depth,
+		  u32 block_count,
+		  const char *alg_name);
+/* Destructor for struct dm_bht instances.  Does not free @bht */
+int dm_bht_destroy(struct dm_bht *bht);
+
+/* Basic accessors for struct dm_bht */
+sector_t dm_bht_sectors(const struct dm_bht *bht);
+void dm_bht_set_read_cb(struct dm_bht *bht, dm_bht_callback read_cb);
+void dm_bht_set_write_cb(struct dm_bht *bht, dm_bht_callback write_cb);
+int dm_bht_set_root_hexdigest(struct dm_bht *bht, const u8 *hexdigest);
+int dm_bht_root_hexdigest(struct dm_bht *bht, u8 *hexdigest, int available);
+
+/* Functions for loading in data from disk for verification */
+int dm_bht_populate(struct dm_bht *bht, void *read_cb_ctx, u32 block_index);
+int dm_bht_verify_block(struct dm_bht *bht, u32 block_index, u8 *digest,
+			unsigned int digest_len);
+
+/* Functions for creating struct dm_bhts on disk.  A newly created dm_bht
+ * should not be directly used for verification. (It should be repopulated.)
+ * In addition, these functions aren't meant to be called in parallel. */
+int dm_bht_compute(struct dm_bht *bht, void *read_cb_ctx);
+int dm_bht_sync(struct dm_bht *bht, void *write_cb_ctx);
+int dm_bht_store_block(struct dm_bht *bht, u32 block_index, u8 *block_data);
+int dm_bht_zeroread_callback(void *ctx, sector_t start, u8 *dst, sector_t count,
+			     struct dm_bht_entry *entry);
+void dm_bht_read_completed(struct dm_bht_entry *entry, int status);
+void dm_bht_write_completed(struct dm_bht_entry *entry, int status);
+#endif  /* __LINUX_DM_BHT_H */
-- 
1.7.0.4

