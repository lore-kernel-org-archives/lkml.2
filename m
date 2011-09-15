Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934425Ab1IOSq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:46:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934209Ab1IOSqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:46:25 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: dm-devel@redhat.com
Cc: Mandeep Singh Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>,
        Elly Jones <ellyjones@chromium.org>,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] dm: verity target
Date: Thu, 15 Sep 2011 11:45:59 -0700
Message-Id: <1316112359-6085-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
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

Signed-off-by: Will Drewry <wad@chromium.org>
Signed-off-by: Elly Jones <ellyjones@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Cc: Olof Johansson <olofj@chromium.org>
Cc: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
---
 Documentation/device-mapper/dm-bht.txt    |   59 ++
 Documentation/device-mapper/dm-verity.txt |   76 +++
 drivers/md/Kconfig                        |   30 +
 drivers/md/Makefile                       |    2 +
 drivers/md/dm-bht.c                       |  541 +++++++++++++++
 drivers/md/dm-verity.c                    | 1043 +++++++++++++++++++++++++++++
 drivers/md/dm-verity.h                    |   45 ++
 include/linux/dm-bht.h                    |  166 +++++
 8 files changed, 1962 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-bht.txt
 create mode 100644 Documentation/device-mapper/dm-verity.txt
 create mode 100644 drivers/md/dm-bht.c
 create mode 100644 drivers/md/dm-verity.c
 create mode 100644 drivers/md/dm-verity.h
 create mode 100644 include/linux/dm-bht.h

diff --git a/Documentation/device-mapper/dm-bht.txt b/Documentation/device-mapper/dm-bht.txt
new file mode 100644
index 0000000..21d929f
--- /dev/null
+++ b/Documentation/device-mapper/dm-bht.txt
@@ -0,0 +1,59 @@
+dm-bht
+======
+
+dm-bht provides a block hash tree implementation.  The use of dm-bht allows
+for integrity checking of a given block device without reading the entire
+set of blocks into memory before use.
+
+In particular, dm-bht supplies an interface for creating and verifying a tree
+of cryptographic digests with any algorithm supported by the kernel crypto API.
+
+The `verity' target is the motivating example.
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
+alg= sha256, num_blocks = 32767
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
+The API provides mechanisms for reading and verifying a tree. When reading, all
+required data for the hash tree should be populated for a block before
+attempting a verify.  This can be done by calling dm_bht_populate().  When all
+data is ready, a call to dm_bht_verify_block() with the expected hash value will
+perform both the direct block hash check and the hashes of the parent and
+neighboring nodes where needed to ensure validity up to the root hash.  Note,
+dm_bht_set_root_hexdigest() should be called before any verification attempts
+occur.
diff --git a/Documentation/device-mapper/dm-verity.txt b/Documentation/device-mapper/dm-verity.txt
new file mode 100644
index 0000000..f33b984
--- /dev/null
+++ b/Documentation/device-mapper/dm-verity.txt
@@ -0,0 +1,76 @@
+dm-verity
+==========
+
+Device-Mapper's "verity" target provides transparent integrity checking of
+block devices using a cryptographic digest provided by the kernel crypto API.
+This target is read-only.
+
+Parameters: payload=<device path> hashtree=<hash device path> alg=<alg> \
+            salt=<salt> root_hexagiest=<root hash> \
+            [ hashstart=<hash start> error_behavior=<error behavior> ]
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
+<alg>
+    The cryptographic hash algorithm used for this device.  This should
+    be the name of the algorithm, like "sha1".
+
+<salt>
+    Salt value (in hex).
+
+<root hash>
+    The hexadecimal encoding of the cryptographic hash of all of the
+    neighboring nodes at the first level of the tree.  This hash should be
+    trusted as there is no other authenticity beyond this point.
+
+<hash start>
+    Start address of hashes (default 0).
+
+<error behavior>
+    0 = return -EIO. 1 = panic. 2 = none. 3 = call notifier.
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
+    "0 204800 verity payload=/dev/sda1 hashtree=/dev/sda2 alg=sha1 "\
+    "root_hexdigest=9f74809a2ee7607b16fcc70d9399a4de9725a727"
+]]
+
+A command line tool is available to compute the hash tree and return the
+root hash value.
+  http://git.chromium.org/cgi-bin/gitweb.cgi?p=dm-verity.git;a=tree
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f75a66e..cb5f425 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -334,4 +334,34 @@ config DM_FLAKEY
        ---help---
          A target that intermittently fails I/O for debugging purposes.
 
+config DM_BHT
+        tristate "Block hash tree support"
+        select CRYPTO
+        select CRYPTO_HASH
+        ---help---
+          Include support for device-mapper devices to use a block hash
+          tree for managing data integrity checks in a scalable way.
+
+          Targets that use this functionality should include it
+          automatically.
+
+          If unsure, say N.
+
+config DM_VERITY
+        tristate "Verity target support"
+        depends on BLK_DEV_DM
+        select DM_BHT
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
index 448838b..58eb088 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -36,6 +36,8 @@ obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
+obj-$(CONFIG_DM_BHT)            += dm-bht.o
+obj-$(CONFIG_DM_VERITY)         += dm-verity.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 
diff --git a/drivers/md/dm-bht.c b/drivers/md/dm-bht.c
new file mode 100644
index 0000000..32b8ccf
--- /dev/null
+++ b/drivers/md/dm-bht.c
@@ -0,0 +1,541 @@
+ /*
+ * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *
+ * Device-Mapper block hash tree interface.
+ * See Documentation/device-mapper/dm-bht.txt for details.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitops.h>
+#include <linux/bug.h>
+#include <linux/cpumask.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-bht.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/mm_types.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#define DM_MSG_PREFIX "dm bht"
+
+
+/*
+ * Utilities
+ */
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
+static void dm_bht_bin_to_hex(u8 *binary, u8 *hex, unsigned int binary_len)
+{
+	while (binary_len-- > 0) {
+		sprintf((char *)hex, "%02hhx", (int)*binary);
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
+static void dm_bht_hex_to_bin(u8 *binary, const u8 *hex,
+			      unsigned int binary_len)
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
+
+	dm_bht_bin_to_hex(given, given_hex, bht->digest_size);
+	dm_bht_bin_to_hex(computed, computed_hex, bht->digest_size);
+	DMERR_LIMIT("%s != %s", given_hex, computed_hex);
+}
+
+/**
+ * dm_bht_compute_hash: hashes a page of data
+ */
+static int dm_bht_compute_hash(struct dm_bht *bht, struct page *pg,
+			       unsigned int offset, u8 *digest)
+{
+	struct hash_desc *hash_desc = &bht->hash_desc[smp_processor_id()];
+	struct scatterlist sg;
+
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, pg, bht->block_size, offset);
+	/* Note, this is synchronous. */
+	if (crypto_hash_init(hash_desc)) {
+		DMCRIT("failed to reinitialize crypto hash (proc:%d)",
+			smp_processor_id());
+		return -EINVAL;
+	}
+	if (crypto_hash_update(hash_desc, &sg, bht->block_size)) {
+		DMCRIT("crypto_hash_update failed");
+		return -EINVAL;
+	}
+	sg_set_buf(&sg, bht->salt, sizeof(bht->salt));
+	if (crypto_hash_update(hash_desc, &sg, sizeof(bht->salt))) {
+		DMCRIT("crypto_hash_update failed");
+		return -EINVAL;
+	}
+	if (crypto_hash_final(hash_desc, digest)) {
+		DMCRIT("crypto_hash_final failed");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Implementation functions
+ */
+
+static int dm_bht_initialize_entries(struct dm_bht *bht)
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
+	 * independently from the bht data structures.  Logically, the root is
+	 * depth=-1 and the block layer level is depth=bht->depth
+	 */
+	unsigned int last = bht->block_count;
+	int depth;
+
+	/* check that the largest level->count can't result in an int overflow
+	 * on allocation or sector calculation.
+	 */
+	if (((last >> bht->node_count_shift) + 1) >
+	    UINT_MAX / max((unsigned int)sizeof(struct dm_bht_entry),
+			   (unsigned int)to_sector(bht->block_size))) {
+		DMCRIT("required entries %u is too large", last + 1);
+		return -EINVAL;
+	}
+
+	/* Track the current sector location for each level so we don't have to
+	 * compute it during traversals.
+	 */
+	bht->sectors = 0;
+	for (depth = 0; depth < bht->depth; ++depth) {
+		struct dm_bht_level *level = &bht->levels[depth];
+
+		level->count = dm_bht_index_at_level(bht, depth, last) + 1;
+		level->entries = (struct dm_bht_entry *)
+				 kcalloc(level->count,
+					 sizeof(struct dm_bht_entry),
+					 GFP_KERNEL);
+		if (!level->entries) {
+			DMERR("failed to allocate entries for depth %d", depth);
+			return -ENOMEM;
+		}
+		level->sector = bht->sectors;
+		bht->sectors += level->count * to_sector(bht->block_size);
+	}
+
+	return 0;
+}
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
+ */
+int dm_bht_create(struct dm_bht *bht, unsigned int block_count,
+		  unsigned int block_size, const char *alg_name)
+{
+	int cpu, status;
+
+	bht->block_size = block_size;
+	/* Verify that PAGE_SIZE >= block_size >= SECTOR_SIZE. */
+	if ((block_size > PAGE_SIZE) ||
+	    (PAGE_SIZE % block_size) ||
+	    (to_sector(block_size) == 0))
+		return -EINVAL;
+
+	/* Setup the hash first. Its length determines much of the bht layout */
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
+		bht->hash_desc[cpu].tfm = crypto_alloc_hash(alg_name, 0, 0);
+		if (IS_ERR(bht->hash_desc[cpu].tfm)) {
+			DMERR("failed to allocate crypto hash '%s'", alg_name);
+			status = -ENOMEM;
+			bht->hash_desc[cpu].tfm = NULL;
+			goto bad_arg;
+		}
+	}
+	bht->digest_size = crypto_hash_digestsize(bht->hash_desc[0].tfm);
+	/* We expect to be able to pack >=2 hashes into a block */
+	if (block_size / bht->digest_size < 2) {
+		DMERR("too few hashes fit in a block");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	if (bht->digest_size > DM_BHT_MAX_DIGEST_SIZE) {
+		DMERR("DM_BHT_MAX_DIGEST_SIZE too small for chosen digest");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	/* Configure the tree */
+	bht->block_count = block_count;
+	if (block_count == 0) {
+		DMERR("block_count must be non-zero");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	/* Each dm_bht_entry->nodes is one block.  The node code tracks
+	 * how many nodes fit into one entry where a node is a single
+	 * hash (message digest).
+	 */
+	bht->node_count_shift = fls(block_size / bht->digest_size) - 1;
+	/* Round down to the nearest power of two.  This makes indexing
+	 * into the tree much less painful.
+	 */
+	bht->node_count = 1 << bht->node_count_shift;
+
+	/* This is unlikely to happen, but with 64k pages, who knows. */
+	if (bht->node_count > UINT_MAX / bht->digest_size) {
+		DMERR("node_count * hash_len exceeds UINT_MAX!");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	bht->depth = DIV_ROUND_UP(fls(block_count - 1), bht->node_count_shift);
+
+	/* Ensure that we can safely shift by this value. */
+	if (bht->depth * bht->node_count_shift >= sizeof(unsigned int) * 8) {
+		DMERR("specified depth and node_count_shift is too large");
+		status = -EINVAL;
+		goto bad_arg;
+	}
+
+	/* Allocate levels. Each level of the tree may have an arbitrary number
+	 * of dm_bht_entry structs.  Each entry contains node_count nodes.
+	 * Each node in the tree is a cryptographic digest of either node_count
+	 * nodes on the subsequent level or of a specific block on disk.
+	 */
+	bht->levels = (struct dm_bht_level *)
+			kcalloc(bht->depth,
+				sizeof(struct dm_bht_level), GFP_KERNEL);
+	if (!bht->levels) {
+		DMERR("failed to allocate tree levels");
+		status = -ENOMEM;
+		goto bad_level_alloc;
+	}
+
+	bht->read_cb = NULL;
+
+	status = dm_bht_initialize_entries(bht);
+	if (status)
+		goto bad_entries_alloc;
+
+	/* We compute depth such that there is only be 1 block at level 0. */
+	BUG_ON(bht->levels[0].count != 1);
+
+	return 0;
+
+bad_entries_alloc:
+	while (bht->depth-- > 0)
+		kfree(bht->levels[bht->depth].entries);
+	kfree(bht->levels);
+bad_level_alloc:
+bad_arg:
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu)
+		if (bht->hash_desc[cpu].tfm)
+			crypto_free_hash(bht->hash_desc[cpu].tfm);
+	return status;
+}
+EXPORT_SYMBOL(dm_bht_create);
+
+/**
+ * dm_bht_read_completed
+ * @entry:	pointer to the entry that's been loaded
+ * @status:	I/O status. Non-zero is failure.
+ * MUST always be called after a read_cb completes.
+ */
+void dm_bht_read_completed(struct dm_bht_entry *entry, int status)
+{
+	if (status) {
+		/* TODO(wad) add retry support */
+		DMCRIT("an I/O error occurred while reading entry");
+		atomic_set(&entry->state, DM_BHT_ENTRY_ERROR_IO);
+		/* entry->nodes will be freed later */
+		return;
+	}
+	BUG_ON(atomic_read(&entry->state) != DM_BHT_ENTRY_PENDING);
+	atomic_set(&entry->state, DM_BHT_ENTRY_READY);
+}
+EXPORT_SYMBOL(dm_bht_read_completed);
+
+/**
+ * dm_bht_verify_block - checks that all nodes in the path for @block are valid
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @block:	specific block data is expected from
+ * @pg:		page holding the block data
+ * @offset:	offset into the page
+ *
+ * Returns 0 on success, DM_BHT_ENTRY_ERROR_MISMATCH on error.
+ */
+int dm_bht_verify_block(struct dm_bht *bht, unsigned int block,
+			struct page *pg, unsigned int offset)
+{
+	int state, depth = bht->depth;
+	u8 digest[DM_BHT_MAX_DIGEST_SIZE];
+	struct dm_bht_entry *entry;
+	void *node;
+
+	do {
+		/* Need to check that the hash of the current block is accurate
+		 * in its parent.
+		 */
+		entry = dm_bht_get_entry(bht, depth - 1, block);
+		state = atomic_read(&entry->state);
+		/* This call is only safe if all nodes along the path
+		 * are already populated (i.e. READY) via dm_bht_populate.
+		 */
+		BUG_ON(state < DM_BHT_ENTRY_READY);
+		node = dm_bht_get_node(bht, entry, depth, block);
+
+		if (dm_bht_compute_hash(bht, pg, offset, digest) ||
+		    memcmp(digest, node, bht->digest_size))
+			goto mismatch;
+
+		/* Keep the containing block of hashes to be verified in the
+		 * next pass.
+		 */
+		pg = virt_to_page(entry->nodes);
+		offset = offset_in_page(entry->nodes);
+	} while (--depth > 0 && state != DM_BHT_ENTRY_VERIFIED);
+
+	if (depth == 0 && state != DM_BHT_ENTRY_VERIFIED) {
+		if (dm_bht_compute_hash(bht, pg, offset, digest) ||
+		    memcmp(digest, bht->root_digest, bht->digest_size))
+			goto mismatch;
+		atomic_set(&entry->state, DM_BHT_ENTRY_VERIFIED);
+	}
+
+	/* Mark path to leaf as verified. */
+	for (depth++; depth < bht->depth; depth++) {
+		entry = dm_bht_get_entry(bht, depth, block);
+		/* At this point, entry can only be in VERIFIED or READY state.
+		 * So it is safe to use atomic_set instead of atomic_cmpxchg.
+		 */
+		atomic_set(&entry->state, DM_BHT_ENTRY_VERIFIED);
+	}
+
+	return 0;
+
+mismatch:
+	DMERR_LIMIT("verify_path: failed to verify hash (d=%d,bi=%u)",
+		    depth, block);
+	dm_bht_log_mismatch(bht, node, digest);
+	return DM_BHT_ENTRY_ERROR_MISMATCH;
+}
+EXPORT_SYMBOL(dm_bht_verify_block);
+
+/**
+ * dm_bht_is_populated - check that entries from disk needed to verify a given
+ *                       block are all ready
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @block:	specific block data is expected from
+ *
+ * Callers may wish to call dm_bht_is_populated() when checking an io
+ * for which entries were already pending.
+ */
+bool dm_bht_is_populated(struct dm_bht *bht, unsigned int block)
+{
+	int depth;
+
+	for (depth = bht->depth - 1; depth >= 0; depth--) {
+		struct dm_bht_entry *entry = dm_bht_get_entry(bht, depth,
+							      block);
+		if (atomic_read(&entry->state) < DM_BHT_ENTRY_READY)
+			return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(dm_bht_is_populated);
+
+/**
+ * dm_bht_populate - reads entries from disk needed to verify a given block
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @ctx:        context used for all read_cb calls on this request
+ * @block:	specific block data is expected from
+ *
+ * Returns negative value on error. Returns 0 on success.
+ */
+int dm_bht_populate(struct dm_bht *bht, void *ctx, unsigned int block)
+{
+	int depth, state;
+
+	BUG_ON(block >= bht->block_count);
+
+	for (depth = bht->depth - 1; depth >= 0; --depth) {
+		unsigned int index = dm_bht_index_at_level(bht, depth, block);
+		struct dm_bht_level *level = &bht->levels[depth];
+		struct dm_bht_entry *entry = dm_bht_get_entry(bht, depth,
+							      block);
+		state = atomic_cmpxchg(&entry->state,
+				       DM_BHT_ENTRY_UNALLOCATED,
+				       DM_BHT_ENTRY_PENDING);
+		if (state == DM_BHT_ENTRY_VERIFIED)
+			break;
+		if (state <= DM_BHT_ENTRY_ERROR)
+			goto error_state;
+		if (state != DM_BHT_ENTRY_UNALLOCATED)
+			continue;
+
+		/* Current entry is claimed for allocation and loading */
+		entry->nodes = kmalloc(bht->block_size, GFP_NOIO);
+		if (!entry->nodes)
+			goto nomem;
+
+		bht->read_cb(ctx,
+			     level->sector + to_sector(index * bht->block_size),
+			     entry->nodes, to_sector(bht->block_size), entry);
+	}
+
+	return 0;
+
+error_state:
+	DMCRIT("block %u at depth %d is in an error state", block, depth);
+	return -EPERM;
+
+nomem:
+	DMCRIT("failed to allocate memory for entry->nodes");
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(dm_bht_populate);
+
+/**
+ * dm_bht_destroy - cleans up all memory used by @bht
+ * @bht:	pointer to a dm_bht_create()d bht
+ */
+void dm_bht_destroy(struct dm_bht *bht)
+{
+	int depth, cpu;
+
+	for (depth = 0; depth < bht->depth; depth++) {
+		struct dm_bht_entry *entry = bht->levels[depth].entries;
+		struct dm_bht_entry *entry_end = entry +
+						 bht->levels[depth].count;
+		for (; entry < entry_end; ++entry)
+			kfree(entry->nodes);
+		kfree(bht->levels[depth].entries);
+	}
+	kfree(bht->levels);
+	for (cpu = 0; cpu < nr_cpu_ids; ++cpu)
+		if (bht->hash_desc[cpu].tfm)
+			crypto_free_hash(bht->hash_desc[cpu].tfm);
+}
+EXPORT_SYMBOL(dm_bht_destroy);
+
+/*
+ * Accessors
+ */
+
+/**
+ * dm_bht_set_root_hexdigest - sets an unverified root digest hash from hex
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @hexdigest:	array of u8s containing the new digest in binary
+ * Returns non-zero on error.  hexdigest should be NUL terminated.
+ */
+int dm_bht_set_root_hexdigest(struct dm_bht *bht, const u8 *hexdigest)
+{
+	/* Make sure we have at least the bytes expected */
+	if (strnlen((char *)hexdigest, bht->digest_size * 2) !=
+	    bht->digest_size * 2) {
+		DMERR("root digest length does not match hash algorithm");
+		return -1;
+	}
+	dm_bht_hex_to_bin(bht->root_digest, hexdigest, bht->digest_size);
+	return 0;
+}
+EXPORT_SYMBOL(dm_bht_set_root_hexdigest);
+
+/**
+ * dm_bht_root_hexdigest - returns root digest in hex
+ * @bht:	pointer to a dm_bht_create()d bht
+ * @hexdigest:	u8 array of size @available
+ * @available:	must be bht->digest_size * 2 + 1
+ */
+int dm_bht_root_hexdigest(struct dm_bht *bht, u8 *hexdigest, int available)
+{
+	if (available < 0 ||
+	    ((unsigned int) available) < bht->digest_size * 2 + 1) {
+		DMERR("hexdigest has too few bytes available");
+		return -EINVAL;
+	}
+	dm_bht_bin_to_hex(bht->root_digest, hexdigest, bht->digest_size);
+	return 0;
+}
+EXPORT_SYMBOL(dm_bht_root_hexdigest);
+
+/**
+ * dm_bht_set_salt - sets the salt used, in hex
+ * @bht:      pointer to a dm_bht_create()d bht
+ * @hexsalt:  salt string, as hex; will be zero-padded or truncated to
+ *            DM_BHT_SALT_SIZE * 2 hex digits.
+ */
+void dm_bht_set_salt(struct dm_bht *bht, const char *hexsalt)
+{
+	size_t saltlen = min(strlen(hexsalt) / 2, sizeof(bht->salt));
+
+	memset(bht->salt, 0, sizeof(bht->salt));
+	dm_bht_hex_to_bin(bht->salt, (const u8 *)hexsalt, saltlen);
+}
+EXPORT_SYMBOL(dm_bht_set_salt);
+
+/**
+ * dm_bht_salt - returns the salt used, in hex
+ * @bht:      pointer to a dm_bht_create()d bht
+ * @hexsalt:  buffer to put salt into, of length DM_BHT_SALT_SIZE * 2 + 1.
+ */
+int dm_bht_salt(struct dm_bht *bht, char *hexsalt)
+{
+	dm_bht_bin_to_hex(bht->salt, (u8 *)hexsalt, sizeof(bht->salt));
+	return 0;
+}
+EXPORT_SYMBOL(dm_bht_salt);
+
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
new file mode 100644
index 0000000..a9bd0e8
--- /dev/null
+++ b/drivers/md/dm-verity.c
@@ -0,0 +1,1043 @@
+/*
+ * Originally based on dm-crypt.c,
+ * Copyright (C) 2003 Christophe Saout <christophe@saout.de>
+ * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
+ * Copyright (C) 2006-2008 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *                    All Rights Reserved.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Implements a verifying transparent block device.
+ * See Documentation/device-mapper/dm-verity.txt
+ */
+#include <linux/async.h>
+#include <linux/atomic.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/genhd.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mempool.h>
+#include <linux/mm_types.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-bht.h>
+
+#include "dm-verity.h"
+
+#define DM_MSG_PREFIX "verity"
+
+/* Supports up to 512-bit digests */
+#define VERITY_MAX_DIGEST_SIZE 64
+
+/* TODO(wad) make both of these report the error line/file to a
+ *           verity_bug function.
+ */
+#define VERITY_BUG(msg...) BUG()
+#define VERITY_BUG_ON(cond, msg...) BUG_ON(cond)
+
+/* Helper for printing sector_t */
+#define ULL(x) ((unsigned long long)(x))
+
+#define MIN_IOS 32
+#define MIN_BIOS (MIN_IOS * 2)
+#define VERITY_DEFAULT_BLOCK_SIZE 4096
+
+/* Provide a lightweight means of specifying the global default for
+ * error behavior: eio, reboot, or none
+ * Legacy support for 0 = eio, 1 = reboot/panic, 2 = none, 3 = notify.
+ * This is matched to the enum in dm-verity.h.
+ */
+static const char * const allowed_error_behaviors[] = { "eio", "panic", "none",
+							"notify", NULL };
+static char *error_behavior = "eio";
+module_param(error_behavior, charp, 0644);
+MODULE_PARM_DESC(error_behavior, "Behavior on error "
+				 "(eio, panic, none, notify)");
+
+/* Controls whether verity_get_device will wait forever for a device. */
+static int dev_wait;
+module_param(dev_wait, bool, 0444);
+MODULE_PARM_DESC(dev_wait, "Wait forever for a backing device");
+
+/* per-requested-bio private data */
+enum verity_io_flags {
+	VERITY_IOFLAGS_CLONED = 0x1,	/* original bio has been cloned */
+};
+
+struct dm_verity_io {
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
+struct verity_config {
+	struct dm_dev *dev;
+	sector_t start;
+	sector_t size;
+
+	struct dm_dev *hash_dev;
+	sector_t hash_start;
+
+	struct dm_bht bht;
+
+	/* Pool required for io contexts */
+	mempool_t *io_pool;
+	/* Pool and bios required for making sure that backing device reads are
+	 * in PAGE_SIZE increments.
+	 */
+	struct bio_set *bs;
+
+	char hash_alg[CRYPTO_MAX_ALG_NAME];
+
+	int error_behavior;
+};
+
+static struct kmem_cache *_verity_io_pool;
+static struct workqueue_struct *kveritydq, *kverityd_ioq;
+
+static void kverityd_verify(struct work_struct *work);
+static void kverityd_io(struct work_struct *work);
+static void kverityd_io_bht_populate(struct dm_verity_io *io);
+static void kverityd_io_bht_populate_end(struct bio *, int error);
+
+static BLOCKING_NOTIFIER_HEAD(verity_error_notifier);
+
+/*
+ * Exported interfaces
+ */
+
+int dm_verity_register_error_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&verity_error_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(dm_verity_register_error_notifier);
+
+int dm_verity_unregister_error_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&verity_error_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(dm_verity_unregister_error_notifier);
+
+/*
+ * Allocation and utility functions
+ */
+
+static void kverityd_src_io_read_end(struct bio *clone, int error);
+
+/* Shared destructor for all internal bios */
+static void dm_verity_bio_destructor(struct bio *bio)
+{
+	struct dm_verity_io *io = bio->bi_private;
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
+static struct dm_verity_io *verity_io_alloc(struct dm_target *ti,
+					    struct bio *bio)
+{
+	struct verity_config *vc = ti->private;
+	sector_t sector = bio->bi_sector - ti->begin;
+	struct dm_verity_io *io;
+
+	io = mempool_alloc(vc->io_pool, GFP_NOIO);
+	if (unlikely(!io))
+		return NULL;
+	io->flags = 0;
+	io->target = ti;
+	io->bio = bio;
+	io->error = 0;
+
+	/* Adjust the sector by the virtual starting sector */
+	io->block = to_bytes(sector) / vc->bht.block_size;
+	io->count = bio->bi_size / vc->bht.block_size;
+
+	atomic_set(&io->pending, 0);
+
+	return io;
+}
+
+static struct bio *verity_bio_clone(struct dm_verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	struct bio *bio = io->bio;
+	struct bio *clone = verity_alloc_bioset(vc, GFP_NOIO, bio->bi_max_vecs);
+
+	if (!clone)
+		return NULL;
+
+	__bio_clone(clone, bio);
+	clone->bi_private = io;
+	clone->bi_end_io  = kverityd_src_io_read_end;
+	clone->bi_bdev    = vc->dev->bdev;
+	clone->bi_sector += vc->start - io->target->begin;
+	clone->bi_destructor = dm_verity_bio_destructor;
+
+	return clone;
+}
+
+/* If the request is not successful, this handler takes action.
+ * TODO make this call a registered handler.
+ */
+static void verity_error(struct verity_config *vc, struct dm_verity_io *io,
+			 int error)
+{
+	const char *message;
+	int error_mode = DM_VERITY_ERROR_BEHAVIOR_PANIC;
+	dev_t devt = 0;
+	u64 block = ~0;
+	int transient = 1;
+	struct dm_verity_error_state error_state;
+
+	if (vc) {
+		devt = vc->dev->bdev->bd_dev;
+		error_mode = vc->error_behavior;
+	}
+
+	if (io) {
+		io->error = -EIO;
+		block = io->block;
+	}
+
+	switch (error) {
+	case -ENOMEM:
+		message = "out of memory";
+		break;
+	case -EBUSY:
+		message = "pending data seen during verify";
+		break;
+	case -EFAULT:
+		message = "crypto operation failure";
+		break;
+	case -EACCES:
+		message = "integrity failure";
+		/* Image is bad. */
+		transient = 0;
+		break;
+	case -EPERM:
+		message = "hash tree population failure";
+		/* Should be dm-bht specific errors */
+		transient = 0;
+		break;
+	case -EINVAL:
+		message = "unexpected missing/invalid data";
+		/* The device was configured incorrectly - fallback. */
+		transient = 0;
+		break;
+	default:
+		/* Other errors can be passed through as IO errors */
+		message = "unknown or I/O error";
+		return;
+	}
+
+	DMERR_LIMIT("verification failure occurred: %s", message);
+
+	if (error_mode == DM_VERITY_ERROR_BEHAVIOR_NOTIFY) {
+		error_state.code = error;
+		error_state.transient = transient;
+		error_state.block = block;
+		error_state.message = message;
+		error_state.dev_start = vc->start;
+		error_state.dev_len = vc->size;
+		error_state.dev = vc->dev->bdev;
+		error_state.hash_dev_start = vc->hash_start;
+		error_state.hash_dev_len = vc->bht.sectors;
+		error_state.hash_dev = vc->hash_dev->bdev;
+
+		/* Set default fallthrough behavior. */
+		error_state.behavior = DM_VERITY_ERROR_BEHAVIOR_PANIC;
+		error_mode = DM_VERITY_ERROR_BEHAVIOR_PANIC;
+
+		if (!blocking_notifier_call_chain(
+		    &verity_error_notifier, transient, &error_state)) {
+			error_mode = error_state.behavior;
+		}
+	}
+
+	switch (error_mode) {
+	case DM_VERITY_ERROR_BEHAVIOR_EIO:
+		break;
+	case DM_VERITY_ERROR_BEHAVIOR_NONE:
+		if (error != -EIO && io)
+			io->error = 0;
+		break;
+	default:
+		goto do_panic;
+	}
+	return;
+
+do_panic:
+	panic("dm-verity failure: "
+	      "device:%u:%u error:%d block:%llu message:%s",
+	      MAJOR(devt), MINOR(devt), error, ULL(block), message);
+}
+
+/**
+ * verity_parse_error_behavior - parse a behavior charp to the enum
+ * @behavior:	NUL-terminated char array
+ *
+ * Checks if the behavior is valid either as text or as an index digit
+ * and returns the proper enum value or -1 on error.
+ */
+static int verity_parse_error_behavior(const char *behavior)
+{
+	const char * const *allowed = allowed_error_behaviors;
+	char index = '0';
+
+	for (; *allowed; allowed++, index++)
+		if (!strcmp(*allowed, behavior) || behavior[0] == index)
+			break;
+
+	if (!*allowed)
+		return -1;
+
+	/* Convert to the integer index matching the enum. */
+	return allowed - allowed_error_behaviors;
+}
+
+/*
+ * Reverse flow of requests into the device.
+ *
+ * (Start at the bottom with verity_map and work your way upward).
+ */
+
+static void verity_inc_pending(struct dm_verity_io *io);
+
+static void verity_return_bio_to_caller(struct dm_verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+
+	if (io->error)
+		verity_error(vc, io, io->error);
+
+	bio_endio(io->bio, io->error);
+	mempool_free(io, vc->io_pool);
+}
+
+/* Check for any missing bht hashes. */
+static bool verity_is_bht_populated(struct dm_verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	u64 block;
+
+	for (block = io->block; block < io->block + io->count; ++block)
+		if (!dm_bht_is_populated(&vc->bht, block))
+			return false;
+
+	return true;
+}
+
+/* verity_dec_pending manages the lifetime of all dm_verity_io structs.
+ * Non-bug error handling is centralized through this interface and
+ * all passage from workqueue to workqueue.
+ */
+static void verity_dec_pending(struct dm_verity_io *io)
+{
+	if (!atomic_dec_and_test(&io->pending))
+		goto done;
+
+	if (unlikely(io->error))
+		goto io_error;
+
+	/* I/Os that were pending may now be ready */
+	if (verity_is_bht_populated(io)) {
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
+ * untrusted source device.  The computed hash is then passed to dm-bht
+ * for verification.
+ */
+static int verity_verify(struct verity_config *vc,
+			 struct dm_verity_io *io)
+{
+	unsigned int block_size = vc->bht.block_size;
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
+		VERITY_BUG_ON(offset % block_size);
+		VERITY_BUG_ON(len % block_size);
+
+		while (len) {
+			r = dm_bht_verify_block(&vc->bht, block,
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
+	/* dm_bht functions aren't expected to return errno friendly
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
+	struct dm_verity_io *io = container_of(dwork, struct dm_verity_io,
+					       work);
+	struct verity_config *vc = io->target->private;
+
+	io->error = verity_verify(vc, io);
+
+	/* Free up the bio and tag with the return value */
+	verity_return_bio_to_caller(io);
+}
+
+/* Asynchronously called upon the completion of dm-bht I/O.  The status
+ * of the operation is passed back to dm-bht and the next steps are
+ * decided by verity_dec_pending.
+ */
+static void kverityd_io_bht_populate_end(struct bio *bio, int error)
+{
+	struct dm_bht_entry *entry = (struct dm_bht_entry *) bio->bi_private;
+	struct dm_verity_io *io = (struct dm_verity_io *) entry->io_context;
+
+	/* Tell the tree to atomically update now that we've populated
+	 * the given entry.
+	 */
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
+		DMERR("Failed to read for sector %llu (%u)",
+		      ULL(io->bio->bi_sector), io->bio->bi_size);
+		io->error = error;
+		/* Pass through the error to verity_dec_pending below */
+	}
+	/* When pending = 0, it will transition to reading real data */
+	verity_dec_pending(io);
+}
+
+/* Called by dm-bht (via dm_bht_populate), this function provides
+ * the message digests to dm-bht that are stored on disk.
+ */
+static int kverityd_bht_read_callback(void *ctx, sector_t start, u8 *dst,
+				      sector_t count,
+				      struct dm_bht_entry *entry)
+{
+	struct dm_verity_io *io = ctx;  /* I/O for this batch */
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
+	if (unlikely(!bio)) {
+		DMCRIT("Out of memory at bio_alloc_bioset");
+		dm_bht_read_completed(entry, -ENOMEM);
+		return -ENOMEM;
+	}
+	bio->bi_private = (void *) entry;
+	bio->bi_idx = 0;
+	bio->bi_size = vc->bht.block_size;
+	bio->bi_sector = vc->hash_start + start;
+	bio->bi_bdev = vc->hash_dev->bdev;
+	bio->bi_end_io = kverityd_io_bht_populate_end;
+	bio->bi_rw = REQ_META;
+	/* Only need to free the bio since the page is managed by bht */
+	bio->bi_destructor = dm_verity_bio_destructor;
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
+static void kverityd_io_bht_populate(struct dm_verity_io *io)
+{
+	struct verity_config *vc = io->target->private;
+	u64 block;
+
+	for (block = io->block; block < io->block + io->count; ++block) {
+		int ret = dm_bht_populate(&vc->bht, io, block);
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
+	struct dm_verity_io *io = clone->bi_private;
+
+	if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !error))
+		error = -EIO;
+
+	if (unlikely(error)) {
+		DMERR("Error occurred: %d (%llu, %u)",
+			error, ULL(clone->bi_sector), clone->bi_size);
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
+static void kverityd_src_io_read(struct dm_verity_io *io)
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
+	struct dm_verity_io *io = container_of(dwork, struct dm_verity_io,
+					       work);
+
+	/* Issue requests asynchronously. */
+	verity_inc_pending(io);
+	kverityd_src_io_read(io);
+	kverityd_io_bht_populate(io);
+	verity_dec_pending(io);
+}
+
+/* Paired with verity_dec_pending, the pending value in the io dictate the
+ * lifetime of a request and when it is ready to be processed on the
+ * workqueues.
+ */
+static void verity_inc_pending(struct dm_verity_io *io)
+{
+	atomic_inc(&io->pending);
+}
+
+/* Block-level requests start here. */
+static int verity_map(struct dm_target *ti, struct bio *bio,
+		      union map_info *map_context)
+{
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
+	if (bio_data_dir(bio) == WRITE) {
+		/* If we silently drop writes, then the VFS layer will cache
+		 * the write and persist it in memory. While it doesn't change
+		 * the underlying storage, it still may be contrary to the
+		 * behavior expected by a verified, read-only device.
+		 */
+		DMWARN_LIMIT("write request received. rejecting with -EIO.");
+		verity_error(vc, NULL, -EIO);
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
+static void splitarg(char *arg, char **key, char **val)
+{
+	*key = strsep(&arg, "=");
+	*val = strsep(&arg, "");
+}
+
+/*
+ * Non-block interfaces and device-mapper specific code
+ */
+
+/**
+ * verity_ctr - Construct a verified mapping
+ * @ti:   Target being created
+ * @argc: Number of elements in argv
+ * @argv: Vector of key-value pairs (see below).
+ *
+ * Accepts the following keys:
+ * @payload:        hashed device
+ * @hashtree:       device hashtree is stored on
+ * @hashstart:      start address of hashes (default 0)
+ * @block_size:     size of a hash block
+ * @alg:            hash algorithm
+ * @root_hexdigest: toplevel hash of the tree
+ * @error_behavior: what to do when verification fails [optional]
+ * @salt:           salt, in hex [optional]
+ *
+ * E.g.,
+ * payload=/dev/sda2 hashtree=/dev/sda3 alg=sha256
+ * root_hexdigest=f08aa4a3695290c569eb1b0ac032ae1040150afb527abbeb0a3da33d82fb2c6e
+ *
+ * TODO(wad):
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
+	struct verity_config *vc = NULL;
+	int ret = 0;
+	sector_t blocks;
+	unsigned int block_size = VERITY_DEFAULT_BLOCK_SIZE;
+	const char *payload = NULL;
+	const char *hashtree = NULL;
+	unsigned long hashstart = 0;
+	const char *alg = NULL;
+	const char *root_hexdigest = NULL;
+	const char *dev_error_behavior = error_behavior;
+	const char *hexsalt = "";
+	int i;
+
+	for (i = 0; i < argc; ++i) {
+		char *key, *val;
+		DMWARN("Argument %d: '%s'", i, argv[i]);
+		splitarg(argv[i], &key, &val);
+		if (!key) {
+			DMWARN("Bad argument %d: missing key?", i);
+			break;
+		}
+		if (!val) {
+			DMWARN("Bad argument %d='%s': missing value", i, key);
+			break;
+		}
+
+		if (!strcmp(key, "alg")) {
+			alg = val;
+		} else if (!strcmp(key, "payload")) {
+			payload = val;
+		} else if (!strcmp(key, "hashtree")) {
+			hashtree = val;
+		} else if (!strcmp(key, "root_hexdigest")) {
+			root_hexdigest = val;
+		} else if (!strcmp(key, "hashstart")) {
+			if (strict_strtoul(val, 10, &hashstart)) {
+				ti->error = "Invalid hashstart";
+				return -EINVAL;
+			}
+		} else if (!strcmp(key, "block_size")) {
+			unsigned long tmp;
+			if (strict_strtoul(val, 10, &tmp) ||
+			    (tmp > UINT_MAX)) {
+				ti->error = "Invalid block_size";
+				return -EINVAL;
+			}
+			block_size = (unsigned int)tmp;
+		} else if (!strcmp(key, "error_behavior")) {
+			dev_error_behavior = val;
+		} else if (!strcmp(key, "salt")) {
+			hexsalt = val;
+		} else if (!strcmp(key, "error_behavior")) {
+			dev_error_behavior = val;
+		}
+	}
+
+#define NEEDARG(n) \
+	if (!(n)) { \
+		ti->error = "Missing argument: " #n; \
+		return -EINVAL; \
+	}
+
+	NEEDARG(alg);
+	NEEDARG(payload);
+	NEEDARG(hashtree);
+	NEEDARG(root_hexdigest);
+
+#undef NEEDARG
+
+	/* The device mapper device should be setup read-only */
+	if ((dm_table_get_mode(ti->table) & ~FMODE_READ) != 0) {
+		ti->error = "Must be created readonly.";
+		return -EINVAL;
+	}
+
+	vc = kzalloc(sizeof(*vc), GFP_KERNEL);
+	if (!vc) {
+		/* TODO(wad) if this is called from the setup helper, then we
+		 * catch these errors and do a CrOS specific thing. if not, we
+		 * need to have this call the error handler.
+		 */
+		return -EINVAL;
+	}
+
+	/* Calculate the blocks from the given device size */
+	vc->size = ti->len;
+	blocks = to_bytes(vc->size) / block_size;
+	if (dm_bht_create(&vc->bht, blocks, block_size, alg)) {
+		DMERR("failed to create required bht");
+		goto bad_bht;
+	}
+	if (dm_bht_set_root_hexdigest(&vc->bht, root_hexdigest)) {
+		DMERR("root hexdigest error");
+		goto bad_root_hexdigest;
+	}
+	dm_bht_set_salt(&vc->bht, hexsalt);
+	vc->bht.read_cb = kverityd_bht_read_callback;
+
+	/* payload: device to verify */
+	vc->start = 0;  /* TODO: should this support a starting offset? */
+	/* We only ever grab the device in read-only mode. */
+	ret = dm_get_device(ti, payload,
+			    dm_table_get_mode(ti->table), &vc->dev);
+	if (ret) {
+		DMERR("Failed to acquire device '%s': %d", payload, ret);
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
+	vc->hash_start = (sector_t)hashstart;
+
+	/* hashtree: device with hashes.
+	 * Note, payload == hashtree is okay as long as the size of
+	 *       ti->len passed to device mapper does not include
+	 *       the hashes.
+	 */
+	if (dm_get_device(ti, hashtree,
+			  dm_table_get_mode(ti->table), &vc->hash_dev)) {
+		ti->error = "Hash device lookup failed";
+		goto bad_hash_dev;
+	}
+
+	/* arg4: cryptographic digest algorithm */
+	if (snprintf(vc->hash_alg, CRYPTO_MAX_ALG_NAME, "%s", alg) >=
+	    CRYPTO_MAX_ALG_NAME) {
+		ti->error = "Hash algorithm name is too long";
+		goto bad_hash;
+	}
+
+	/* override with optional device-specific error behavior */
+	vc->error_behavior = verity_parse_error_behavior(dev_error_behavior);
+	if (vc->error_behavior == -1) {
+		ti->error = "Bad error_behavior supplied";
+		goto bad_err_behavior;
+	}
+
+	/* TODO: Maybe issues a request on the io queue for block 0? */
+
+	/* Argument processing is done, setup operational data */
+	/* Pool for dm_verity_io objects */
+	vc->io_pool = mempool_create_slab_pool(MIN_IOS, _verity_io_pool);
+	if (!vc->io_pool) {
+		ti->error = "Cannot allocate verity io mempool";
+		goto bad_slab_pool;
+	}
+
+	/* Allocate the bioset used for request padding */
+	/* TODO(wad) allocate a separate bioset for the first verify maybe */
+	vc->bs = bioset_create(MIN_BIOS, 0);
+	if (!vc->bs) {
+		ti->error = "Cannot allocate verity bioset";
+		goto bad_bs;
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
+		       hashdev, ULL(vc->bht.sectors), ULL(blocks));
+	}
+	return 0;
+
+bad_bs:
+	mempool_destroy(vc->io_pool);
+bad_slab_pool:
+bad_err_behavior:
+bad_hash:
+	dm_put_device(ti, vc->hash_dev);
+bad_hash_dev:
+bad_hash_start:
+	dm_put_device(ti, vc->dev);
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
+
+	bioset_free(vc->bs);
+	mempool_destroy(vc->io_pool);
+	dm_bht_destroy(&vc->bht);
+	dm_put_device(ti, vc->hash_dev);
+	dm_put_device(ti, vc->dev);
+	kfree(vc);
+}
+
+static int verity_status(struct dm_target *ti, status_type_t type,
+			char *result, unsigned int maxlen)
+{
+	struct verity_config *vc = (struct verity_config *) ti->private;
+	unsigned int sz = 0;
+	char hashdev[BDEVNAME_SIZE], vdev[BDEVNAME_SIZE];
+	u8 hexdigest[VERITY_MAX_DIGEST_SIZE * 2 + 1] = { 0 };
+
+	dm_bht_root_hexdigest(&vc->bht, hexdigest, sizeof(hexdigest));
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		break;
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
+	struct verity_config *vc = ti->private;
+	unsigned int block_size = vc->bht.block_size;
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
+	.map    = verity_map,
+	.merge  = verity_merge,
+	.status = verity_status,
+	.iterate_devices = verity_iterate_devices,
+	.io_hints = verity_io_hints,
+};
+
+#define VERITY_WQ_FLAGS (WQ_CPU_INTENSIVE|WQ_HIGHPRI)
+
+static int __init dm_verity_init(void)
+{
+	int r = -ENOMEM;
+
+	_verity_io_pool = KMEM_CACHE(dm_verity_io, 0);
+	if (!_verity_io_pool) {
+		DMERR("failed to allocate pool dm_verity_io");
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
+static void __exit dm_verity_exit(void)
+{
+	destroy_workqueue(kveritydq);
+	destroy_workqueue(kverityd_ioq);
+
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
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
new file mode 100644
index 0000000..e0664c9
--- /dev/null
+++ b/drivers/md/dm-verity.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ *                    All Rights Reserved.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Provide error types for use when creating a custom error handler.
+ * See Documentation/device-mapper/dm-verity.txt
+ */
+#ifndef DM_VERITY_H
+#define DM_VERITY_H
+
+#include <linux/notifier.h>
+
+struct dm_verity_error_state {
+	int code;
+	int transient;  /* Likely to not happen after a reboot */
+	u64 block;
+	const char *message;
+
+	sector_t dev_start;
+	sector_t dev_len;
+	struct block_device *dev;
+
+	sector_t hash_dev_start;
+	sector_t hash_dev_len;
+	struct block_device *hash_dev;
+
+	/* Final behavior after all notifications are completed. */
+	int behavior;
+};
+
+/* This enum must be matched to allowed_error_behaviors in dm-verity.c */
+enum dm_verity_error_behavior {
+	DM_VERITY_ERROR_BEHAVIOR_EIO = 0,
+	DM_VERITY_ERROR_BEHAVIOR_PANIC,
+	DM_VERITY_ERROR_BEHAVIOR_NONE,
+	DM_VERITY_ERROR_BEHAVIOR_NOTIFY
+};
+
+
+int dm_verity_register_error_notifier(struct notifier_block *nb);
+int dm_verity_unregister_error_notifier(struct notifier_block *nb);
+
+#endif  /* DM_VERITY_H */
diff --git a/include/linux/dm-bht.h b/include/linux/dm-bht.h
new file mode 100644
index 0000000..0595911
--- /dev/null
+++ b/include/linux/dm-bht.h
@@ -0,0 +1,166 @@
+/*
+ * Copyright (C) 2011 The Chromium OS Authors <chromium-os-dev@chromium.org>
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
+#include <linux/types.h>
+
+/* To avoid allocating memory for digest tests, we just setup a
+ * max to use for now.
+ */
+#define DM_BHT_MAX_DIGEST_SIZE 128  /* 1k hashes are unlikely for now */
+#define DM_BHT_SALT_SIZE       32   /* 256 bits of salt is a lot */
+
+/* UNALLOCATED, PENDING, READY, and VERIFIED are valid states. All other
+ * values are entry-related return codes.
+ */
+#define DM_BHT_ENTRY_VERIFIED 8  /* 'nodes' has been checked against parent */
+#define DM_BHT_ENTRY_READY 4  /* 'nodes' is loaded and available */
+#define DM_BHT_ENTRY_PENDING 2  /* 'nodes' is being loaded */
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
+ * level, we need to load in the data for on-demand verification.
+ */
+struct dm_bht_entry {
+	atomic_t state; /* see defines */
+	/* Keeping an extra pointer per entry wastes up to ~33k of
+	 * memory if a 1m blocks are used (or 66 on 64-bit arch)
+	 */
+	void *io_context;  /* Reserve a pointer for use during io */
+	/* data should only be non-NULL if fully populated. */
+	void *nodes;  /* The hash data used to verify the children.
+		       * Guaranteed to be page-aligned.
+		       */
+};
+
+/* dm_bht_level
+ * Contains an array of entries which represent a page of hashes where
+ * each hash is a node in the tree at the given tree depth/level.
+ */
+struct dm_bht_level {
+	struct dm_bht_entry *entries;  /* array of entries of tree nodes */
+	unsigned int count;  /* number of entries at this level */
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
+ * TODO(wad): All hash storage memory is pre-allocated and freed once an
+ * entire branch has been verified.
+ */
+struct dm_bht {
+	/* Configured values */
+	int depth;  /* Depth of the tree including the root */
+	unsigned int block_count;  /* Number of blocks hashed */
+	unsigned int block_size;  /* Size of a hash block */
+	char hash_alg[CRYPTO_MAX_ALG_NAME];
+	unsigned char salt[DM_BHT_SALT_SIZE];
+
+	/* Computed values */
+	unsigned int node_count;  /* Data size (in hashes) for each entry */
+	unsigned int node_count_shift;  /* first bit set - 1 */
+	/* There is one per CPU so that verified can be simultaneous. */
+	struct hash_desc hash_desc[NR_CPUS];  /* Container for the hash alg */
+	unsigned int digest_size;
+	sector_t sectors;  /* Number of disk sectors used */
+
+	/* bool verified;  Full tree is verified */
+	u8 root_digest[DM_BHT_MAX_DIGEST_SIZE];
+	struct dm_bht_level *levels;  /* in reverse order */
+	/* Callback for reading from the hash device */
+	dm_bht_callback read_cb;
+};
+
+/* Constructor for struct dm_bht instances. */
+int dm_bht_create(struct dm_bht *bht,
+		  unsigned int block_count,
+		  unsigned int block_size,
+		  const char *alg_name);
+/* Destructor for struct dm_bht instances.  Does not free @bht */
+void dm_bht_destroy(struct dm_bht *bht);
+
+/* Basic accessors for struct dm_bht */
+int dm_bht_set_root_hexdigest(struct dm_bht *bht, const u8 *hexdigest);
+int dm_bht_root_hexdigest(struct dm_bht *bht, u8 *hexdigest, int available);
+void dm_bht_set_salt(struct dm_bht *bht, const char *hexsalt);
+int dm_bht_salt(struct dm_bht *bht, char *hexsalt);
+
+/* Functions for loading in data from disk for verification */
+bool dm_bht_is_populated(struct dm_bht *bht, unsigned int block);
+int dm_bht_populate(struct dm_bht *bht, void *read_cb_ctx,
+		    unsigned int block);
+int dm_bht_verify_block(struct dm_bht *bht, unsigned int block,
+			struct page *pg, unsigned int offset);
+void dm_bht_read_completed(struct dm_bht_entry *entry, int status);
+
+/* Functions for converting indices to nodes. */
+
+static inline unsigned int dm_bht_get_level_shift(struct dm_bht *bht,
+						  int depth)
+{
+	return (bht->depth - depth) * bht->node_count_shift;
+}
+
+/* For the given depth, this is the entry index.  At depth+1 it is the node
+ * index for depth.
+ */
+static inline unsigned int dm_bht_index_at_level(struct dm_bht *bht,
+							int depth,
+							unsigned int leaf)
+{
+	return leaf >> dm_bht_get_level_shift(bht, depth);
+}
+
+static inline struct dm_bht_entry *dm_bht_get_entry(struct dm_bht *bht,
+						    int depth,
+						    unsigned int block)
+{
+	unsigned int index = dm_bht_index_at_level(bht, depth, block);
+	struct dm_bht_level *level = &bht->levels[depth];
+
+	return &level->entries[index];
+}
+
+static inline void *dm_bht_get_node(struct dm_bht *bht,
+				  struct dm_bht_entry *entry,
+				  int depth,
+				  unsigned int block)
+{
+	unsigned int index = dm_bht_index_at_level(bht, depth, block);
+	unsigned int node_index = index % bht->node_count;
+
+	return entry->nodes + (node_index * bht->digest_size);
+}
+#endif  /* __LINUX_DM_BHT_H */
-- 
1.7.3.1

