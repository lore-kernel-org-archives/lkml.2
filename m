Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2BIPwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:52:17 -0500
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:49478
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752828Ab2BIPwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:52:15 -0500
Date: Thu, 9 Feb 2012 16:24:40 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: linux-mtd@lists.infradead.org
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch] Adding Secure Deletion to UBIFS
Message-ID: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="776899908-974393995-1328723309=:19593"
Content-ID: <alpine.DEB.2.00.1202091610060.26924@eristoteles.iwoars.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--776899908-974393995-1328723309=:19593
Content-Type: TEXT/PLAIN; FORMAT=flowed; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1202091610061.26924@eristoteles.iwoars.net>

This patch provides efficient secure deletion for UBIFS.

The general problem of secure deletion on flash memory is the disparity between 
I/O size and erase block size---the inability to perform in-place updates means 
that simply overwriting data with a new value is insufficient. Moreover, 
forcing the garbage collection of every erase block that contains some deleted 
entry is woefully inefficient and reduces the lifetime of the flash memory.
Multiply overwriting deleted pages with zeros (but not erasing it) technically 
works but it is outside the specification, can cause data errors in other 
pages, and does not work with modern, larger MLC types of memory.

The solution here is to encrypt every data node with a different encryption 
key, and colocate the keys in a small (0.5-1 %) key storage area (KSA). The 
erase blocks of the KSA are frequently purged to remove deleted keys---each 
block of the old KSA is replaced with a new block, where all the used keys 
remain in the same position in the block, but all the unused and deleted keys 
are replaced with fresh, random data. This is done with UBI's atomic update, so 
it is not possible to lose any needed keys during this update, and the actual 
addition wear caused by more frequent erasure is evenly levelled over the 
device.

Each data nodes includes a reference to a key in the KSA. This key is read and 
used to decrypt the data. When a new data node is written, an unused key is 
selected from the KSA and used to encrypt the data node. The reference to the 
key is then included with the node. The keys in the KSA are written before 
actually being used to encrypt data. To securely delete a data node, we simply 
mark the corresponding key position as deleted, and during the next purging 
operation the KSA erase block that contains the key is then updated to a 
version that does not contain the key.

The data of data node is encrypted/decrypted in the compression/decompression 
functions respectively. A key parameter is passed in---if this is NULL, then no 
cryption is performed. If it points to a buffer, then it is interpreted as a 
128bit AES key. Counter mode is used with an IV of 0. Since each data block is 
encrypted with a unique key---each key only encrypts one item only once and 
sequentially---we do not need to worry about storing and generating IVs.

Key state is managed entirely in the TNC. When nodes are added to the TNC, they 
include a reference to a logical position in the key state map (KSA logical 
block number, offset). The TNC adding nodes will mark the key as used, removing 
a node will mark it as deleted, updating a node marks old as deleted and new as 
used. After purging, all deleted keys are replaced with new data and their key 
positions are marked as unused. Additionally, a checkpoint of the key state map 
is commited. When mounting the most recent checkpoint is loaded and then, if 
the journal is non-empty, the uncommited entries are replayed---thus updating 
the TNC and therefore correcting the key state map. The znode now includes the 
position in the KSA.

If power is lost during a commiting/purging of the key state map, then some KSA 
erase blocks will be updated and others will not be. However, in all possible 
failures, remounting the device guarantees the following three properties 
(which refer to the correctness of the key state map and are critical to the 
security of the system:
- every unused key must not decrypt any data node---either valid or invalid
- every used key must have exactly one data node it can decrypt and this data 
node must be valid according to the index
- every deleted key must not decrypt any data node that is valid according to 
the index.

I have a paper with lots more details and a proper treatment on power failure 
are examined.

Summary of changes to UBIFS

Mounting
mount the file system
  - allocate and initialize the keymap
  - deallocate keymap if an error occurs
  - read the size of the KSA from the master node
unmount the file system
- deallocate the keymap
create default file system
- use storage medium's geometry to compute the
   required KSA size
- store this information in the master node
- call keymap's initialize KSA routine

Commit
- call the keymap's purging routine

Input/Output
write data
- obtain an unused key position from the keymap - store the key's position in 
the data node's header - use the keymap and key position to look up the actual 
key - provide the key to the compress function recompute data after truncation
- obtain the original key, decrypt the data
- obtain a new key, encrypt the data with it after truncating
read data
- use the keymap and data node's key position to look up the actual key - 
provide the key to the decompress function

Tree Node Cache
add/update the TNC
- provide a key position when adding data nodes
- store the key position inside TNC entries
- mark key position as used
- if also updating, mark the old key position as deleted before storing the new 
position
delete/truncate the TNC
- when removing a data node from the TNC, mark the stored key position as 
deleted committing the TNC
- read and write key position to stored tree nodes

Testing was done using integck in mtd-utils for both drive mounted with the 
enhancement and without, where nandsim was used as the test flash device. Power 
cut testing was also performed. Manual testing of mounting and use was 
performed for both secure deletion and without. A suit of unit tests for the 
new keymap component exist but are not included. (What should I do with them?)

Things still to address:
- a consistency check for the three properties on the correctness of the key 
state map, along with the resulting ability to recover from a missing 
checkpoint by recomputing the key state map
- a change to an on-flash data structure renders it incompatible with older 
version, so this needs to be fixed

Joel Reardon

--------------------------------------------------
Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/commit.c linux-3.2.1-ubifsec/fs/ubifs/commit.c
--- linux-3.2.1-vanilla/fs/ubifs/commit.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/commit.c	2012-02-08 16:54:49.097506842 
+0100
@@ -114,7 +114,11 @@ static int do_commit(struct ubifs_info *

  	dbg_cmt("start");
  	ubifs_assert(!c->ro_media && !c->ro_mount);
-
+	if (c->use_ubifsec) {
+		struct timeval tv;
+		do_gettimeofday(&tv);
+		c->next_commit = tv.tv_sec + c->commit_interval;
+	}
  	if (c->ro_error) {
  		err = -EROFS;
  		goto out_up;
@@ -134,6 +138,11 @@ static int do_commit(struct ubifs_info *
  	}

  	c->cmt_no += 1;
+	if (c->use_ubifsec) {
+		err = keymap_purge(c);
+		if (err)
+			goto out_up;
+	}
  	err = ubifs_gc_start_commit(c);
  	if (err)
  		goto out_up;
@@ -304,6 +313,16 @@ int ubifs_bg_thread(void *info)
  		if (try_to_freeze())
  			continue;

+		if (UBIFSEC_COMMIT_INTERVAL(c)) {
+			struct timeval tv;
+			do_gettimeofday(&tv);
+			if (c->next_commit < tv.tv_sec) {
+				c->next_commit = tv.tv_sec + 
c->commit_interval;
+				c->cmt_state = COMMIT_REQUIRED;
+				c->need_bgt = 1;
+			}
+		}
+
  		set_current_state(TASK_INTERRUPTIBLE);
  		/* Check if there is something to do */
  		if (!c->need_bgt) {
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/compress.c linux-3.2.1-ubifsec/fs/ubifs/compress.c
--- linux-3.2.1-vanilla/fs/ubifs/compress.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/compress.c	2012-02-08 16:54:49.097506842 
+0100
@@ -27,9 +27,11 @@
   * decompression.
   */

-#include <linux/crypto.h>
  #include "ubifs.h"

+#include <linux/crypto.h>
+#include <linux/scatterlist.h>
+
  /* Fake description object for the "none" compressor */
  static struct ubifs_compressor none_compr = {
  	.compr_type = UBIFS_COMPR_NONE,
@@ -74,6 +76,40 @@ static struct ubifs_compressor zlib_comp
  /* All UBIFS compressors */
  struct ubifs_compressor *ubifs_compressors[UBIFS_COMPR_TYPES_CNT];

+int ubifs_aes_crypt(u8 *str, int len, u8 *key, int keylen, u8 *iv, int ivlen)
+{
+	struct crypto_blkcipher *tfm;
+	struct blkcipher_desc desc;
+	struct scatterlist sg;
+	int err = 0;
+	tfm = crypto_alloc_blkcipher(UBIFSEC_CRYPTO_ALGORITHM, 0, 0);
+
+	if (IS_ERR(tfm)) {
+		ubifs_err("failed to load transform for aes: %ld",
+			  PTR_ERR(tfm));
+		return err;
+	}
+
+	err = crypto_blkcipher_setkey(tfm, key, keylen);
+	desc.tfm = tfm;
+	desc.flags = 0;
+	if (err) {
+		ubifs_err("setkey() failed  flags=%x",
+			  crypto_blkcipher_get_flags(tfm));
+		return err;
+	}
+	memset(&sg, 0, sizeof(struct scatterlist));
+
+	sg_set_buf(&sg, str, len);
+	desc.info = iv;
+	err = crypto_blkcipher_encrypt(&desc, &sg, &sg, len);
+	crypto_free_blkcipher(tfm);
+	if (err)
+		return err;
+	return 0;
+}
+
+
  /**
   * ubifs_compress - compress data.
   * @in_buf: data to compress
@@ -93,7 +129,7 @@ struct ubifs_compressor *ubifs_compresso
   * buffer and %UBIFS_COMPR_NONE is returned in @compr_type.
   */
  void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int 
*out_len,
-		    int *compr_type)
+		    int *compr_type, u8* key)
  {
  	int err;
  	struct ubifs_compressor *compr = ubifs_compressors[*compr_type];
@@ -115,7 +151,7 @@ void ubifs_compress(const void *in_buf,
  		ubifs_warn("cannot compress %d bytes, compressor %s, "
  			   "error %d, leave data uncompressed",
  			   in_len, compr->name, err);
-		 goto no_compr;
+		goto no_compr;
  	}

  	/*
@@ -124,13 +160,20 @@ void ubifs_compress(const void *in_buf,
  	 */
  	if (in_len - *out_len < UBIFS_MIN_COMPRESS_DIFF)
  		goto no_compr;
-
-	return;
+	goto encrypt;

  no_compr:
  	memcpy(out_buf, in_buf, in_len);
  	*out_len = in_len;
  	*compr_type = UBIFS_COMPR_NONE;
+	goto encrypt;
+encrypt:
+	if (key) {
+		u8 iv[AES_KEYSIZE_128];
+		memset(iv, 0, AES_KEYSIZE_128);
+		ubifs_aes_crypt(out_buf, *out_len, key, AES_KEYSIZE_128,
+				iv, AES_KEYSIZE_128);
+	}
  }

  /**
@@ -145,8 +188,9 @@ no_compr:
   * The length of the uncompressed data is returned in @out_len. This functions
   * returns %0 on success or a negative error code on failure.
   */
-int ubifs_decompress(const void *in_buf, int in_len, void *out_buf,
-		     int *out_len, int compr_type)
+int ubifs_decompress(void *in_buf, int in_len, void *out_buf,
+		     int *out_len, int compr_type, u8* key)
+
  {
  	int err;
  	struct ubifs_compressor *compr;
@@ -163,6 +207,12 @@ int ubifs_decompress(const void *in_buf,
  		return -EINVAL;
  	}

+	if (key) {
+		u8 iv[AES_KEYSIZE_128];
+		memset(iv, 0, AES_KEYSIZE_128);
+		ubifs_aes_crypt(in_buf, in_len, key, AES_KEYSIZE_128,
+				iv, AES_KEYSIZE_128);
+	}
  	if (compr_type == UBIFS_COMPR_NONE) {
  		memcpy(out_buf, in_buf, in_len);
  		*out_len = in_len;
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/file.c linux-3.2.1-ubifsec/fs/ubifs/file.c
--- linux-3.2.1-vanilla/fs/ubifs/file.c	2012-01-12 20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/file.c	2012-02-08 16:54:49.101506843 +0100
@@ -61,6 +61,8 @@ static int read_block(struct inode *inod
  	int err, len, out_len;
  	union ubifs_key key;
  	unsigned int dlen;
+	u8 crypto_key[UBIFSEC_KEYSIZE];
+	u8 *pkey = NULL;

  	data_key_init(c, &key, inode->i_ino, block);
  	err = ubifs_tnc_lookup(c, &key, dn);
@@ -79,8 +81,14 @@ static int read_block(struct inode *inod

  	dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
  	out_len = UBIFS_BLOCK_SIZE;
+	if (c->use_ubifsec) {
+		keymap_read_key(c, le64_to_cpu(dn->crypto_lookup), crypto_key);
+		pkey = crypto_key;
+	}
  	err = ubifs_decompress(&dn->data, dlen, addr, &out_len,
-			       le16_to_cpu(dn->compr_type));
+			       le16_to_cpu(dn->compr_type), pkey);
+	POISON_KEY(crypto_key);
+
  	if (err || len != out_len)
  		goto dump;

@@ -636,6 +644,8 @@ static int populate_page(struct ubifs_in
  			memset(addr, 0, UBIFS_BLOCK_SIZE);
  		} else if (key_block(c, &bu->zbranch[nn].key) == page_block) {
  			struct ubifs_data_node *dn;
+			u8 crypto_key[UBIFSEC_KEYSIZE];
+			u8 *pkey = NULL;

  			dn = bu->buf + (bu->zbranch[nn].offs - offs);

@@ -648,8 +658,17 @@ static int populate_page(struct ubifs_in

  			dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
  			out_len = UBIFS_BLOCK_SIZE;
+			if (c->use_ubifsec) {
+				keymap_read_key(c,
+ le64_to_cpu(dn->crypto_lookup),
+						crypto_key);
+				pkey = crypto_key;
+			}
  			err = ubifs_decompress(&dn->data, dlen, addr, &out_len,
- le16_to_cpu(dn->compr_type));
+ le16_to_cpu(dn->compr_type),
+					       pkey);
+			POISON_KEY(crypto_key);
+
  			if (err || len != out_len)
  				goto out_err;

diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/gc.c linux-3.2.1-ubifsec/fs/ubifs/gc.c
--- linux-3.2.1-vanilla/fs/ubifs/gc.c	2012-01-12 20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/gc.c	2012-02-08 16:54:49.105506843 +0100
@@ -322,15 +322,30 @@ static int move_node(struct ubifs_info *
  		     struct ubifs_scan_node *snod, struct ubifs_wbuf *wbuf)
  {
  	int err, new_lnum = wbuf->lnum, new_offs = wbuf->offs + wbuf->used;
+	u64 crypto_lookup = 0;

  	cond_resched();
+	/* When moving a node, inform the keymap and determine if it wants
+     * to promote the key to a longer-term key storage area.
+     */
+	if (c->use_ubifsec && key_type(c, &snod->key) == UBIFS_DATA_KEY) {
+		struct ubifs_data_node *dn =
+			(struct ubifs_data_node *) snod->node;
+		crypto_lookup = le64_to_cpu(dn->crypto_lookup);
+		if (keymap_gc_should_promote(c, crypto_lookup)) {
+			u64 new_pos;
+			err = keymap_swap_encryption_key(c, dn);
+			new_pos = le64_to_cpu(dn->crypto_lookup);
+			crypto_lookup = new_pos;
+		}
+	}
+
  	err = ubifs_wbuf_write_nolock(wbuf, snod->node, snod->len);
  	if (err)
  		return err;
-
  	err = ubifs_tnc_replace(c, &snod->key, sleb->lnum,
  				snod->offs, new_lnum, new_offs,
-				snod->len);
+				snod->len, crypto_lookup);
  	list_del(&snod->list);
  	kfree(snod);
  	return err;
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/io.c linux-3.2.1-ubifsec/fs/ubifs/io.c
--- linux-3.2.1-vanilla/fs/ubifs/io.c	2012-01-12 20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/io.c	2012-02-08 16:54:49.105506843 +0100
@@ -367,6 +367,19 @@ static unsigned long long next_sqnum(str
  }

  /**
+ * ubifs_set_datanode_crc - writes the crc for a data node to the common
+ * header.
+ * @node: the data node
+ * @len: the length of data
+ */
+void ubifs_set_datanode_crc(void *node)
+{
+	struct ubifs_ch *ch = (struct ubifs_ch *) node;
+	int len = le32_to_cpu(ch->len);
+	ch->crc = cpu_to_le32(crc32(UBIFS_CRC32_INIT, node + 8, len - 8));
+}
+
+/**
   * ubifs_prepare_node - prepare node to be written to flash.
   * @c: UBIFS file-system description object
   * @node: the node to pad
@@ -379,7 +392,6 @@ static unsigned long long next_sqnum(str
   */
  void ubifs_prepare_node(struct ubifs_info *c, void *node, int len, int pad)
  {
-	uint32_t crc;
  	struct ubifs_ch *ch = node;
  	unsigned long long sqnum = next_sqnum(c);

@@ -390,8 +402,7 @@ void ubifs_prepare_node(struct ubifs_inf
  	ch->group_type = UBIFS_NO_NODE_GROUP;
  	ch->sqnum = cpu_to_le64(sqnum);
  	ch->padding[0] = ch->padding[1] = 0;
-	crc = crc32(UBIFS_CRC32_INIT, node + 8, len - 8);
-	ch->crc = cpu_to_le32(crc);
+	ubifs_set_datanode_crc(node);

  	if (pad) {
  		len = ALIGN(len, 8);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/journal.c linux-3.2.1-ubifsec/fs/ubifs/journal.c
--- linux-3.2.1-vanilla/fs/ubifs/journal.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/journal.c	2012-02-08 16:54:49.105506843 
+0100
@@ -696,6 +696,9 @@ int ubifs_jnl_write_data(struct ubifs_in
  	int err, lnum, offs, compr_type, out_len;
  	int dlen = COMPRESSED_DATA_NODE_BUF_SZ, allocated = 1;
  	struct ubifs_inode *ui = ubifs_inode(inode);
+	u8 crypto_key[UBIFSEC_KEYSIZE];
+	u8 *pkey = NULL;
+	u64 pos = 0;

  	dbg_jnl("ino %lu, blk %u, len %d, key %s",
  		(unsigned long)key_inum(c, key), key_block(c, key), len,
@@ -718,6 +721,15 @@ int ubifs_jnl_write_data(struct ubifs_in

  	data->ch.node_type = UBIFS_DATA_NODE;
  	key_write(c, key, &data->key);
+
+	if (c->use_ubifsec) {
+		err = keymap_free_key(c, &pos, crypto_key);
+		data->crypto_lookup = cpu_to_le64(pos);
+		if (err)
+			return -ENOMEM;
+		pkey = crypto_key;
+	}
+
  	data->size = cpu_to_le32(len);
  	zero_data_node_unused(data);

@@ -728,7 +740,8 @@ int ubifs_jnl_write_data(struct ubifs_in
  		compr_type = ui->compr_type;

  	out_len = dlen - UBIFS_DATA_NODE_SZ;
-	ubifs_compress(buf, len, &data->data, &out_len, &compr_type);
+	ubifs_compress(buf, len, &data->data, &out_len, &compr_type, pkey);
+	POISON_KEY(crypto_key);
  	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);

  	dlen = UBIFS_DATA_NODE_SZ + out_len;
@@ -745,7 +758,7 @@ int ubifs_jnl_write_data(struct ubifs_in
  	ubifs_wbuf_add_ino_nolock(&c->jheads[DATAHD].wbuf, key_inum(c, key));
  	release_head(c, DATAHD);

-	err = ubifs_tnc_add(c, key, lnum, offs, dlen);
+	err = ubifs_tnc_add_with_crypto_lookup(c, key, lnum, offs, dlen, pos);
  	if (err)
  		goto out_ro;

@@ -1099,10 +1112,14 @@ out_free:
   * This function is used when an inode is truncated and the last data node of
   * the inode has to be re-compressed and re-written.
   */
-static int recomp_data_node(struct ubifs_data_node *dn, int *new_len)
+static int recomp_data_node(struct ubifs_info *c, struct ubifs_data_node *dn,
+			    int *new_len)
  {
  	void *buf;
+	u64 old_pos;
  	int err, len, compr_type, out_len;
+	u8 crypto_key[UBIFSEC_KEYSIZE];
+	u8 *pkey = NULL;

  	out_len = le32_to_cpu(dn->size);
  	buf = kmalloc(out_len * WORST_COMPR_FACTOR, GFP_NOFS);
@@ -1111,11 +1128,31 @@ static int recomp_data_node(struct ubifs

  	len = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
  	compr_type = le16_to_cpu(dn->compr_type);
-	err = ubifs_decompress(&dn->data, len, buf, &out_len, compr_type);
+	if (c->use_ubifsec) {
+		err = keymap_read_key(c, le64_to_cpu(dn->crypto_lookup),
+				      crypto_key);
+		if (err)
+			goto out;
+		pkey = crypto_key;
+	}
+	err = ubifs_decompress(&dn->data, len, buf, &out_len, compr_type, 
pkey);
+
  	if (err)
  		goto out;
+	if (c->use_ubifsec) {
+		u64 new_pos;
+		old_pos = le64_to_cpu(dn->crypto_lookup);
+
+		err = keymap_free_key(c, &new_pos, crypto_key);
+		dn->crypto_lookup = cpu_to_le64(new_pos);
+		ubifs_assert(pkey == crypto_key);
+		if (err)
+			goto out;
+		keymap_mark_deleted(c, old_pos);
+	}

-	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type);
+	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type, pkey);
+	POISON_KEY(crypto_key);
  	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);
  	dn->compr_type = cpu_to_le16(compr_type);
  	dn->size = cpu_to_le32(*new_len);
@@ -1190,7 +1227,7 @@ int ubifs_jnl_truncate(struct ubifs_info
  				int compr_type = le16_to_cpu(dn->compr_type);

  				if (compr_type != UBIFS_COMPR_NONE) {
-					err = recomp_data_node(dn, &dlen);
+					err = recomp_data_node(c, dn, &dlen);
  					if (err)
  						goto out_free;
  				} else {
@@ -1224,7 +1261,9 @@ int ubifs_jnl_truncate(struct ubifs_info

  	if (dlen) {
  		sz = offs + UBIFS_INO_NODE_SZ + UBIFS_TRUN_NODE_SZ;
-		err = ubifs_tnc_add(c, &key, lnum, sz, dlen);
+		err = ubifs_tnc_add_with_crypto_lookup(
+			c, &key, lnum, sz, dlen,
+			le64_to_cpu(dn->crypto_lookup));
  		if (err)
  			goto out_ro;
  	}
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/keymap.c linux-3.2.1-ubifsec/fs/ubifs/keymap.c
--- linux-3.2.1-vanilla/fs/ubifs/keymap.c	1970-01-01 01:00:00.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/keymap.c	2012-02-08 16:57:56.945515934 
+0100
@@ -0,0 +1,1314 @@
+/*
+ * This file is part of UBIFS.
+ *
+ * Copyright (C) 2006-2008 Nokia Corporation.
+ * Copyright (C) 2006, 2007 University of Szeged, Hungary
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along 
with
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ * Authors: Adrian Hunter
+ *	  Artem Bityutskiy (Битюцкий Артём)
+ *	  Zoltan Sogor
+ */
+
+/*
+ * keymap.c
+ * Author: Joel Reardon
+ *
+ * The keymap implements the key storage, assignment, and deletion for UBIFSec
+ * to ensure secure deletion of data.
+ */
+
+#include "ubifs.h"
+#include <linux/random.h>
+
+#define KEYMAP_STATE_FREE 0
+#define KEYMAP_STATE_USED 1
+#define KEYMAP_STATE_DELETED 2
+#define KEYMAP_STATES_PER_BYTE 4
+#define KEYMAP_STATES_PER_BYTE_SHIFT 2
+#define KEYMAP_CHECKPOINT_MAGIC 0x00602e23
+
+#define RETURN_VAL_IF(v, e) do { if ((e)) return (v); } while (0)
+#define RETURN_ON_ERR(e) do { if ((e)) return (e); } while (0)
+
+/* TODO(reardon): ubifs allows updates to the file system during a commit,
+ * adding such changes to empty journal that becomes the new journal after
+ * commiting; so we must allow ubifsec to assign keys out during a purge.
+ * It can be implemented as follows: when trying to get a key, check if
+ * purge_ongoing is set true. If not, then its the standard path. Otherwise,
+ * Keys are assigned from a block that does not contain deleted data---i.e.,
+ * one whose purging will be skipped and whose keys will otherwise be
+ * marked as non-assignable. During this update, the key state map is not
+ * changed  but instead an entry is  added to a queue of changes made during
+ * purging. After writing the new KSA, the key state map is updated with the
+ * change queue. Purging is then completed and  the key state map is again
+ * correct.
+ */
+
+/* TODO(reardon): add a consistency check / full scan to rebuild checkpoint.
+ * This can have two flavours: to recovery from a missing checkpoint,
+ * simply do a full scan of all the data nodes in the TNC, and then mark their
+ * crypto positions as 'used' and the rest as 'unused'. To perform a
+ * consistency check, then read all data nodes and mark all the valid nodes's
+ * crypto positions as used, the invalid nodes (i.e., not contained in the 
TNC)
+ * as deleted, and all other posistions as unused. Then check for accord with
+ * regards to the checkpointed value and the TNC. This can be internally or as
+ * a standalone tool. However, currently, if a valid checkpoint cannot be
+ * recovered then UBIFSec reports an error and fails to mount.
+ */
+
+/* The crypto key positions are stored in zbraches in the TNC. It may be best
+ * to refactor it so that the data in each node is part of a data structure
+ * that is allocated separately, or has a variable allocation: e.g.:
+ * struct ubifs_zbranch * zbr = make_zbr(c), where make_zbr() uses c's
+ * use_ubifsec to decide whether to allocate a full zbr or a reduced one.
+ * Zbrs themselves may use a substructure of lnum,offs,len,crypto_lookup to
+ * reduce the parameter load of ubifs_tnc_add() and in the same way remove the
+ * need for ubifs_tnc_add_with_crypto_lookup.
+ */
+
+/* Currently, the KSA ranges are fixed into a short-term and long-term area,
+ * with immediate promotion if a node is garbage collected. If this is made
+ * more user-configurable, than the following define will need to be changed,
+ * along with an entire interface to be added to control it during the
+ * formatting of the partition. This is only the max size of a KSA used for
+ * sizing the array.
+ */
+#define KEYMAP_MAX_KSA_RANGES 2
+
+/* The key cache is a way of optimizing read performance by reading an entire
+ * page worth of keys into memory and keeping it locally. This way, if a
+ * key is requested on the same page (i.e., being assigned out sequentally)
+ * then it will be returned without requiring another read of the device.
+ * However, this is a trade-off with security: keeping keys in memory is
+ * always less desirable than having no keys in memory against some kinds of
+ * attacks; if the attacker is only able to read the system's memory at only
+ * one moment in time, then having as few keys as possible available is
+ * obviously a benefit.
+ */
+struct key_cache {
+	u8 *page;	/* the page of data that has been read from flash */
+	int page_num;	/* the page number (rel. to the beginning of the KSA,
+			 * that is stored in page. If page_num is -1 then the
+			 * page is not storing any valid data. */
+};
+
+/* A KSA range is a set of erase blocks that are devoted to storing keys. The
+ * compete set is called the KSA, and a KSA range is a subset of the KSA where
+ * all the keys in the range have a similar expected lifetime. The expected
+ * lifetimes are determined heuristically through generation garbage
+ * collection: each time a data node is garbage collected, it may be promoted
+ * to the next (longer-lived) KSA range.  The number of garbage collections
+ * until promotion is stored in gcs_until_promotion. If this value is 0, then
+ * it is the final KSA range (i.e., longest lived). If it is 1, then it is
+ * automatically promoted. For any other value, a random number is generated
+ * to determine if it should be promoted. (As this is all anyhow heuristical
+ * and to obtain simply fewer KSA erasures for purging, detailed accounting of
+ * garbage collections is both unnessessary and inefficient).
+ *
+ * There are two caches for the KSA. The read cache stores the last page of
+ * keys used to read a key for reading a data node. The write cache stores the
+ * last page of keys used to read a key for writing a new data node. Whether
+ * it is read or write is decided based on whether the key being read is equal
+ * to the cur_pos value. If either cache has the valid page for our read, then
+ * the cached value is used instead of reading it from the flash. Otherwise
+ * the key is read and tehe cahced is updated.
+ */
+struct ksa_range {
+	u32 ksa_first;  /* first LEB in this KSA range, relative to the KSA */
+	u32 ksa_size;   /* last LEB in this KSA range, relative to the KSA */
+	u32 gcs_until_promotion;  /* the number of garbage collections until
+				   * promotion to the next KSA. */
+	u64 cur_pos;  /* A pointer to a key position in this KSA range used for
+		       * key assignment. Finding an unused key begins from this
+		       * value. Its value is most often the last key assigned
+		       * from this KSA. The exception is after purging when
+		       * it is reset to the first key position. */
+	u32 erases;  /* The number of erasures in this KSA. This is only used 
to
+		      * determine the effectiveness of the KSA partitioning. */
+	struct key_cache rd_cache;  /* A reference to the read cache. */
+	struct key_cache wr_cache;  /* A reference to the write cache. */
+};
+
+/* This is the main keymaps data structure for UBIFSec. There is only instance
+ * of the keymap for the UBIFS main context. Its main purpose is to be aware
+ * of which LEBs belong to the KSA, how the KSA is divided into ranges, the
+ * state for each key, and mutexes to ensure thread safety.
+ */
+struct ubifs_keymap {
+	u32 key_size;  /* geometry: size of a key in bytes */
+	u32 keys_per_eb;  /* geometry: number of keys per KSA LEB. */
+	u32 ksa_size;  /* geometry: number of LEBS in the KSA */
+	u32 ksa_first;  /* the first LEB belonging to the KSA */
+	u32 ckpt_leb;  /* the LEB that is used to store keypoints of the KSA. 
*/
+
+	/* a double-array [ksa_size]x[keys_per_eb] that stores the
+	 * state of the key at that position. The state consumes two bits and
+	 * is tightly packed in the bytes. The first index is from 0
+	 * to the number of KSA LEBs - 1, and the second is from 0 to
+	 * the number of keys per (KSA LEB - 1) >> 2.
+	 */
+	u8 **state;
+	u64 free;  /* Number of unused keys in the system. */
+	/* A LEB-sized buffer used during atomic updates to write new
+	 * versions of the KSA and checkpoint. */
+	u8 *kbuf;
+	u64 deleted;  /* Number of deleted keys in the system. */
+	u32 ckpt_sz;  /* The size of an uncompressed checkpoint */
+	u8 *ckpt_buf; /* Buffer used to store the uncompressed checkpoint while
+		       * mounting and commiting. */
+	u32 next_checkpoint_off;  /* Offset in the checkpoint block where the
+				   * next checkpoint will be written. */
+
+	/* This mutex must be locked when update the state of a key. */
+	struct mutex state_mutex;
+	/* This mutex must be locked when using kbuf. */
+	struct mutex kbuf_mutex;
+	/* This mutex must be locked when doing a purge. */
+	struct mutex purge_mutex;
+	/* True if there a purge happening. Must be read under the purge mutex
+	 * lock  */
+	int purge_ongoing;
+
+	u32 erasures;  /* Count of KSA LEB erasures due to purging. */
+	int read_only;  /* Is the file-system mounted read only? */
+	/* References to the KSA range data structure for each KSA range. */
+	struct ksa_range ksa[KEYMAP_MAX_KSA_RANGES];
+	int ksa_ranges; /* The actual number of KSA ranges. */
+};
+
+/* This function sets a key position's state. */
+static inline
+void set_state(struct ubifs_keymap *km, int eb, int offset, int value)
+{
+	static const int minor_mask = (1 << KEYMAP_STATES_PER_BYTE_SHIFT) - 1;
+	int major = offset >> KEYMAP_STATES_PER_BYTE_SHIFT;
+	int shift = 2 * (offset & minor_mask);
+	int mask  = minor_mask << shift;
+	int old = km->state[eb][major];
+	km->state[eb][major] = old - (old & mask) + (value << shift);
+}
+
+/* This function gets a key position's state. */
+static inline
+int get_state(struct ubifs_keymap *km, int eb, int offset)
+{
+	static const int minor_mask = (1 << KEYMAP_STATES_PER_BYTE_SHIFT) - 1;
+	int major = offset >> KEYMAP_STATES_PER_BYTE_SHIFT;
+	int shift = 2 * (offset & minor_mask);
+	return (km->state[eb][major] >> shift) & minor_mask;
+}
+
+/* TODO(reardon): to optimize the common event of reading all states
+ * sequentially (e.g., purge, checkpoint), make a caching reading function.
+ */
+
+/* This function invalidates the current page in the key_cache that is passed.
+ * It also poisons the memory. */
+static void key_cache_invalidate(const struct ubifs_info *c,
+				 struct key_cache *cache)
+{
+	memset(cache->page, 0xff, c->min_io_size);
+	cache->page_num = -1;
+}
+
+/* This function frees the data for a keymap ksa range. It simply poisons the
+ * memory for the read and write caches, then frees them.
+ */
+static void keymap_ksa_free(const struct ubifs_info *c, struct ksa_range *ksa)
+{
+	key_cache_invalidate(c, &(ksa->wr_cache));
+	key_cache_invalidate(c, &(ksa->rd_cache));
+	kfree(ksa->wr_cache.page);
+	kfree(ksa->rd_cache.page);
+}
+
+/* This function invalidates both the read and write cache for the passed KSA
+ * range */
+static void ksa_key_cache_invalidate(const struct ubifs_info *c,
+				     struct ksa_range *ksa)
+{
+	key_cache_invalidate(c, &ksa->rd_cache);
+	key_cache_invalidate(c, &ksa->wr_cache);
+}
+
+static int keymap_eb_to_ksa_range(const struct ubifs_keymap *km, const u32 
eb);
+
+/* This function writes some KSA range information to the kernel log. */
+static void keymap_ksa_trace(struct ubifs_keymap *km, const int ksa_num)
+{
+	struct ksa_range *ksa = km->ksa + ksa_num;
+	int i;
+	int state_cnt[3];
+	memset(state_cnt, 0, 3 * sizeof(int));
+	for (i = 0; i < ksa->ksa_size; ++i) {
+		int j;
+		for (j = 0; j < km->keys_per_eb; ++j)
+			state_cnt[get_state(km, i + ksa->ksa_first, j)]++;
+	}
+	ubifs_msg("(keymap) ksa=%d free=%d used=%d delete=%d erases=%d",
+		  ksa_num, state_cnt[0], state_cnt[1], state_cnt[2],
+		  (int) ksa->erases);
+}
+
+/* This function calls keymap_ksa_trace for each KSA in the keymap. */
+static void keymap_trace(struct ubifs_keymap *km)
+{
+	int i;
+	for (i = 0; i < km->ksa_ranges; ++i)
+		keymap_ksa_trace(km, i);
+}
+
+/* This function converts a 64-bit key position into the 32-bit LEB number
+ * and 32-bit offset in the LEB where the key can be found.
+ */
+static void pos_to_eb_offset(const u64 pos, u32 *eb, u32 *offset)
+{
+	*offset = 0xffffffff & pos;
+	*eb = 0xffffffff & (pos >> 32);
+}
+
+/* This function converts the LEB number and offset for a key into the 64-bit
+ * key position value.
+ */
+static u64 eb_offset_to_pos(u32 eb, u32 offset)
+{
+	return (((u64)eb) << 32) + offset;
+}
+
+/* This function allows external components of UBIFS become aware of the
+ * number of keys per KSA LEB without knowing the internals of the keymap.
+ */
+int keymap_keys_per_eb(struct ubifs_info *c)
+{
+	return c->leb_size / UBIFSEC_KEYSIZE;
+}
+
+/* This function initializes an already-allocated key_cache data structure. */
+static int key_cache_init(struct ubifs_info *c, struct key_cache *cache)
+{
+	cache->page = kmalloc(c->min_io_size, GFP_NOFS);
+	RETURN_VAL_IF(-ENOMEM, !cache->page);
+	cache->page_num = -1;
+	return 0;
+}
+
+/* This function adds a new KSA range to the keymap, which it inializes with
+ * the following parameters:
+ *   pos: the array index for ksa where the new ksa range should be added.
+ *   ebs: the number of LEBS in the range
+ *   promotion: the value to set as gcs_until_promotion.
+ *
+ * The function sets the first KSA LEB for this range as follows:
+ *   0, if pos == 0
+ *   one more than the last KSA LEB for the previous KSA range, if pos > 0.
+ *
+ * If ebs is set to 0, then the size of this range is set to difference
+ * between the total number of KSA LEBs and the range's starting LEB.
+ */
+static int add_ksa_range(struct ubifs_info *c, int pos, u32 ebs, int 
promotion)
+{
+	struct ubifs_keymap *km;
+	int err;
+	km = c->km;
+	if (pos < 0 || pos >= km->ksa_ranges) {
+		ubifs_err("error adding KSA range: pos %d is invalid.", pos);
+		return -EINVAL;
+	}
+	if (pos == 0) {
+		km->ksa[0].ksa_first = 0;
+	} else {
+		km->ksa[pos].ksa_first =
+			km->ksa[pos - 1].ksa_first + km->ksa[pos - 1].ksa_size;
+	}
+	if (ebs < 0 || ebs > km->ksa_size - km->ksa[pos].ksa_first) {
+		ubifs_err("error adding KSA range: cannot allocate %d ebs "
+			  "to pos %d", (int) ebs, pos);
+		return -EINVAL;
+	}
+	if (ebs == 0) {
+		km->ksa[pos].ksa_size = km->ksa_size - km->ksa[pos].ksa_first;
+		ubifs_assert(promotion == 0);
+	} else {
+		km->ksa[pos].ksa_size = ebs;
+	}
+	km->ksa[pos].gcs_until_promotion = promotion;
+	km->ksa[pos].erases = 0;
+	km->ksa[pos].cur_pos = eb_offset_to_pos(km->ksa[pos].ksa_first, 0);
+	err = key_cache_init(c, &km->ksa[pos].rd_cache);
+	err = key_cache_init(c, &km->ksa[pos].wr_cache);
+	RETURN_ON_ERR(err);
+	ubifs_msg("(keymap) added KSA range %d: %d->%d, protomotion at %d",
+		  pos, (int) km->ksa[pos].ksa_first,
+		  (int) km->ksa[pos].ksa_first + (int) km->ksa[pos].ksa_size,
+		  promotion);
+	return 0;
+}
+
+/* This function initializes the KSA range to a default value. We use two KSA
+ * ranges, each half the size of the KSA, and automatically promote any key
+ * whose data node is once garbage collected. This creates a short-term and
+ * long-term storage area. If there are less than 6 LEBs in the KSA, then only
+ * a single KSA range is used.
+ */
+static int keymap_init_ksa_ranges(struct ubifs_info *c)
+{
+	int err = 0;
+	u32 blocks = c->km->ksa_size >> 1;
+	if (c->km->ksa_size < 6) {
+		c->km->ksa_ranges = 1;
+		err = add_ksa_range(c, 0, 0, 0);
+	} else {
+		c->km->ksa_ranges = 2;
+		err = add_ksa_range(c, 0, blocks, 1);
+		err = add_ksa_range(c, 1, 0, 0);
+	}
+	RETURN_ON_ERR(err);
+	return 0;
+}
+
+static void keymap_mark_used_internal(struct ubifs_keymap *c, u64 pos);
+static int keymap_checkpoint_pack(struct ubifs_info *c, u8* buf, int len);
+static int keymap_checkpoint_unpack(struct ubifs_info *c, u8* buf, int len);
+
+/* This function initializes the keymap data structure contained in the
+ * ubifs_info structure FOR A FRESHLY FORMATED PARTITION. This means that it
+ * erases all the KSA blocks, as it assumes it does not contain valid keys.
+ * This should only be called when formatting UBIFS or mounting it when the
+ * flash memory is all 0xFF.  It marks all the keys as deleted, then purges,
+ * which effectively fills the entire KSA with fresh data and sets all the
+ * variables correctly.
+ */
+int keymap_initialize_fresh(struct ubifs_info *c)
+{
+	int i;
+	int j;
+	int err;
+	struct ubifs_keymap *km = c->km;
+	ubifs_assert(c->empty);
+	km->free = 0;
+	km->next_checkpoint_off = 0;
+	mutex_lock(&km->kbuf_mutex);
+	for (i = 0; i < km->ksa_size; ++i) {
+		for (j = 0; j < km->keys_per_eb; ++j) {
+			set_state(km, i, j, KEYMAP_STATE_DELETED);
+			km->deleted++;
+		}
+	}
+	mutex_unlock(&km->kbuf_mutex);
+	RETURN_VAL_IF(0, km->read_only);
+	err = keymap_purge(c);
+	return err;
+}
+
+/* This function writes a checkpoint of the current key state map to the LEB
+ * reserved for key state map checkpoints. It first packs the current state
+ * map to the ckpt_buf, then compresses using UBIFS's existing LZO compressor.
+ * The result is then prefixed with the length of the compressed checkpoint,
+ * and appended with a magic number (i.e., not all 0xFF) to signal that it has
+ * been successfully written. This is all written onto the beginning of kbuf.
+ *
+ * The size of the checkpoint is then page-aligned, and then the first free
+ * page in the checkpoint LEB is checked to see if it will fit. If it fits,
+ * then it is written onto those pages. If it does not fit, then kbuf is
+ * instead written using atomic update to the checkpoint LEB, such that the
+ * successful result is a checkpoint LEB with only one checkpoint, and
+ * otherwise the old LEB remains.
+ */
+
+/* TODO(reardon): currently, the compressed checkpoint cannot exceed a LEB.
+ * The solution is of course to span it over multiple LEBs---but this needs to
+ * be implemented. */
+int keymap_write_checkpoint(struct ubifs_info *c)
+{
+	int err = 0;
+	int compr = UBIFS_COMPR_LZO;
+	int len = c->leb_size - 8;
+	int len_al;
+	struct ubifs_keymap *km = c->km;
+
+	RETURN_VAL_IF(0, !km);
+	RETURN_VAL_IF(-EROFS, km->read_only);
+
+	mutex_lock(&km->kbuf_mutex);
+	memset(km->kbuf, 0xff, c->leb_size);
+	keymap_checkpoint_pack(c, km->ckpt_buf, km->ckpt_sz);
+	ubifs_compress(km->ckpt_buf, km->ckpt_sz, km->kbuf + sizeof(u32),
+		       &len, &compr,  NULL);
+
+	*(u32 *)(km->kbuf) = cpu_to_le32(len);
+	len += sizeof(u32);
+	*(u32 *)(km->kbuf + len) = cpu_to_le32(KEYMAP_CHECKPOINT_MAGIC);
+	len += sizeof(u32);
+	len_al = ALIGN(len,  c->min_io_size);
+
+	if (km->next_checkpoint_off + len_al > c->leb_size) {
+		km->next_checkpoint_off = len_al;
+		km->erasures++;
+		err = ubifs_leb_change(c, km->ckpt_leb, km->kbuf,
+				       len_al, UBI_SHORTTERM);
+	} else {
+		err = ubifs_leb_write(c, km->ckpt_leb, km->kbuf,
+				      km->next_checkpoint_off,
+				      len_al, UBI_SHORTTERM);
+		km->next_checkpoint_off += len_al;
+	}
+
+	mutex_unlock(&km->kbuf_mutex);
+	return err;
+}
+
+/* This function finds the next checkpoint on the checkpoint block and returns
+ * the length and whether it was correctly formatted. Purported checkpoint
+ * lengths MUST be range-checked with regards to the buffer length.
+ */
+static int find_next_checkpoint(char *buf, int buf_len, int offset,
+				int *valid, int *length)
+{
+	int len;
+	int su32 = sizeof(u32);
+	if (offset + su32 >= buf_len)
+		goto failure;
+
+	len = le32_to_cpu(*(u32 *)(buf+offset));
+	if (len >= 0 && len + offset + su32 < buf_len) {
+		*length = len;
+	} else {
+		ubifs_err("checkpoint reported an invalid length (%d)", len);
+		goto failure;
+	}
+
+	*valid = 0;
+	if (KEYMAP_CHECKPOINT_MAGIC ==
+	    le32_to_cpu(*(u32 *)(buf + su32 + len + offset))) {
+		*valid = 1;
+	}
+	return 0;
+
+failure:
+	*valid = 0;
+	*length = 0;
+	return -EINVAL;
+}
+
+/* This function reads the most recent checkpoint from the checkpoint LEB,
+ * decompresses it, and then reads the state of each key into the key state
+ * map. It does this by sequentially readin checkpoints from the checkpoint
+ * block until no more are available. The first four bytes of a checkpoint
+ * stores the length, which is used to jump ahead to the end and verify the
+ * magic number.
+ */
+int keymap_read_checkpoint(struct ubifs_info *c)
+{
+	int err = 0;
+	int offset = 0;
+	int last_valid;
+	int ckpt_len, full_ckpt_len, ckpt_offset;
+	int i;
+	int empty_after = c->leb_size;
+	char *buf;
+	struct ubifs_keymap *km = c->km;
+
+	RETURN_VAL_IF(0, !km);
+	buf = km->kbuf;
+
+	mutex_lock(&km->kbuf_mutex);
+	err = ubi_read(c->ubi, c->km->ckpt_leb, buf, 0, c->leb_size);
+	if (err)
+		goto out;
+	/* Find the length of data on the erase block. */
+	for (i = c->leb_size - 1; i >= 0; --i) {
+		if ((u8)(buf[i]) != 0xff)
+			break;
+		empty_after = i;
+	}
+
+	/* If this is a freshly-formatted UBIFSec partition, then format the
+	 * key storage area.
+	 */
+	if (c->empty) {
+		ubifs_assert(empty_after == 0);
+		goto format_keyspace;
+	}
+
+	/* If this is not freshly formatted yet no checkpoints are written,
+	 * then return an error.
+	 */
+	if (empty_after == 0) {
+		ubifs_err("checkpoint block is empty, but this is not an "\
+			  "empty partition.  Perform a full scan of data "\
+			  "nodes.");
+		err =  -EINVAL;
+		goto out;
+	}
+
+	offset = 0;
+	ckpt_offset = -1;
+	ckpt_len = 0;
+	last_valid = 0;
+	while (offset < empty_after) {
+		int len, valid;
+		err = find_next_checkpoint(buf, c->leb_size, offset,
+					   &valid, &len);
+		if (err)
+			goto out;
+		if (valid) {
+			ckpt_offset = offset + sizeof(u32);
+			ckpt_len = len;
+			last_valid = 1;
+		} else {
+			last_valid = 0;
+		}
+		offset += ALIGN(len + sizeof(u32) * 2, c->min_io_size);
+	}
+	if (ckpt_offset == -1) {
+		ubifs_err("no valid checkpoint found");
+		err = -EINVAL;
+		goto out;
+	}
+	if (!last_valid && !c->need_recovery) {
+		ubifs_err("last checkpoint is invalid but file system "\
+			  "should have been safely unmounted---perform "\
+			  "a full scan.");
+		err = -EINVAL;
+		goto out;
+	}
+
+	km->next_checkpoint_off = offset;
+	full_ckpt_len = km->ckpt_sz;
+	err = ubifs_decompress(km->kbuf + ckpt_offset, ckpt_len, km->ckpt_buf,
+			       &full_ckpt_len, UBIFS_COMPR_LZO, NULL);
+	if (err)
+		goto out;
+	err = keymap_checkpoint_unpack(c, km->ckpt_buf, full_ckpt_len);
+	keymap_trace(c->km);
+out:
+	mutex_unlock(&km->kbuf_mutex);
+	return err;
+
+format_keyspace:
+	/* This is a fresh file system. */
+	mutex_unlock(&km->kbuf_mutex);
+	err = keymap_initialize_fresh(c);
+	return err;
+}
+
+/* This function packs the key state map into an uncompressed checkpoint,
+ * storing it on the buffer buf. The len varaible indicates the size of the
+ * buffer, and all writes to the buffer are checked by assertion against this
+ * length before they are performed.
+ */
+static int keymap_checkpoint_pack(struct ubifs_info *c, u8 *buf, int len)
+{
+	int i;
+	int j;
+	int k = 0;
+	int err = 0;
+	struct ubifs_keymap *km = c->km;
+
+	mutex_lock(&km->state_mutex);
+	for (i = 0; i < km->ksa_size; ++i) {
+		for (j = 0; j < km->keys_per_eb; j += 8) {
+			u8 val = 0;
+			int l = 0;
+			if (k >= len) {
+				err = -EINVAL;
+				goto out;
+			}
+			for (l = 0; l < 8; ++l) {
+				int state = get_state(km, i, j+l);
+				if (state == KEYMAP_STATE_USED)
+					val += (1 << l);
+			}
+			ubifs_assert(k < len);
+			buf[k++] = val;
+		}
+	}
+out:
+	mutex_unlock(&km->state_mutex);
+	return err;
+}
+
+/* This function unpacks a checkpoint (in its uncompressed form, as stored in
+ * buf) and sets the key state map accordingly. It performs the reverse as
+ * keymap_checkpoint_unpack.
+ */
+static int keymap_checkpoint_unpack(struct ubifs_info *c, u8 *buf, int len)
+{
+	int i;
+	int j;
+	int k = 0;
+	int last = -1;
+	int err = 0;
+	struct ubifs_keymap *km = c->km;
+	mutex_lock(&km->state_mutex);
+	for (i = 0; i < km->ksa_size; ++i) {
+		for (j = 0; j < km->keys_per_eb; j += 8) {
+			u8 val;
+			int l;
+			if (k >= len) {
+				err = -EINVAL;
+				goto out;
+			}
+			val = buf[k++];
+			last = val;
+			for (l = 0; l < 8; ++l) {
+				int state;
+				set_state(km, i, j + l, 1 & val);
+				val = val >> 1;
+				state = get_state(km, i, j + l);
+				if (state == KEYMAP_STATE_FREE)
+					km->free++;
+			}
+		}
+	}
+out:
+	mutex_unlock(&km->state_mutex);
+	return err;
+}
+
+/* This function allows external access to the number of free keys in the
+ * keymap.
+ */
+u64 keymap_freekeys(struct ubifs_info *c)
+{
+	RETURN_VAL_IF(0, !c->km);
+	return c->km->free;
+}
+
+/* This function generates a new random key and places it in the to field. The
+ * keymap stores the size of the key used as a field. We assume that
+ * get_random_bytes() will always yield cryptographically-suitable random
+ * data. If that changes, this will need to be updated.
+ */
+static void generate_key(struct ubifs_keymap *km, u8 *to)
+{
+	get_random_bytes(to, km->key_size);
+}
+
+/* This function performs the purging operation on a single key storage area
+ * LEB. All unused and deleted keys on that erase block are replaced with
+ * fresh random data. It reads the entire erase block currently stored on the
+ * storage medium, and then updates its in memory with the new version, which
+ * is then written using atomic update.
+ */
+
+/* TODO(reardon): currently, blocks containing no deleted keys are not
+ * updated. This is okay, but an attacker who is able to see these keys can
+ * then decrypt data that will be written at an unknown future time. It is
+ * useful to mark such erase blocks as potentially exposed, so that the keys
+ * are only assigned from then after repurging. Each KSA range would then
+ * maintain its exposed LEBs, which would be purged if needed. Exposed LEBs
+ * would be empty, so they can be indepently and immediately purged as a
+ * one-off, then used to assign keys.
+ *
+ * This optimization prevents purging many KSA LEBs at each purging when the
+ * storage medium is usually empty, but also limits the utility of this
+ * exposure attack.
+ */
+static int do_purge(struct ubifs_info *c, int eb)
+{
+	int i;
+	u64 old_free = c->km->free;
+	struct ubifs_keymap *km = c->km;
+	int err = 0;
+	ubifs_assert(km);
+	ubifs_assert(!km->read_only);
+	mutex_lock(&km->kbuf_mutex);
+
+	/* Read the entire key leb. */
+	err = ubi_read(c->ubi, eb + km->ksa_first, km->kbuf, 0, c->leb_size);
+
+	if (err) {
+		ubifs_err("(keymap) cannot read LEB %d, error %d",
+			  eb + (int) km->ksa_first, err);
+		goto out;
+	}
+
+	mutex_lock(&km->state_mutex);
+	/* Update unused and deleted keys. */
+	for (i = 0; i < km->keys_per_eb; ++i) {
+		if (get_state(km, eb, i) == KEYMAP_STATE_FREE ||
+				get_state(km, eb, i) == KEYMAP_STATE_DELETED) {
+			/* If the key is deleted, we need to update the
+			 * accounting information.
+			 */
+			if (get_state(km, eb, i) == KEYMAP_STATE_DELETED) {
+				set_state(km, eb, i, KEYMAP_STATE_FREE);
+				km->free++;
+				km->deleted--;
+			}
+			/* Replace the stale key with a fresh key */
+			generate_key(km, km->kbuf + (i * c->km->key_size));
+		}
+	}
+	mutex_unlock(&km->state_mutex);
+
+	if (old_free != km->free) {
+		km->erasures++;
+		km->ksa[keymap_eb_to_ksa_range(km, eb)].erases++;
+		ubifs_leb_change(c, eb + km->ksa_first, c->km->kbuf,
+				 c->leb_size,  UBI_SHORTTERM);
+	}
+
+out:
+	mutex_unlock(&km->kbuf_mutex);
+	return err;
+}
+
+/* This functions performs a purge on the KSA. It proceeds iteratively over
+ * all the LEBs in the KSA, calling do_purge on each one. It also invalides
+ * the caches for each KSA range.
+ */
+int keymap_purge(struct ubifs_info *c)
+{
+	int err;
+	int i;
+	struct ubifs_keymap *km = c->km;
+	RETURN_VAL_IF(0, !km);
+	RETURN_VAL_IF(-EROFS, km->read_only);
+
+	mutex_lock(&km->purge_mutex);
+	if (km->purge_ongoing) {
+		mutex_unlock(&km->purge_mutex);
+		return -EAGAIN;
+	}
+	km->purge_ongoing = 1;
+	mutex_unlock(&km->purge_mutex);
+
+	for (i = 0; i < km->ksa_ranges; ++i) {
+		ksa_key_cache_invalidate(c, km->ksa + i);
+		km->ksa[i].cur_pos = eb_offset_to_pos(km->ksa[i].ksa_first, 0);
+	}
+
+	for (i = 0; i < km->ksa_size; ++i) {
+		err = do_purge(c, i);
+		if (err)
+			goto out;
+	}
+	err = keymap_write_checkpoint(c);
+
+out:
+	mutex_lock(&km->purge_mutex);
+	km->purge_ongoing = 0;
+	mutex_unlock(&km->purge_mutex);
+
+	return err;
+}
+
+/* This function allocates a keymap data structure and initializes its fields.
+ * The ubifs_info context is passed as a parameter and its km field is set to
+ * the keymap that is preprared by this function. If memory cannot be
+ * allocated, it returns -ENOMEM. Otherwise it returns 0.
+ */
+int keymap_init(struct ubifs_info *c, int read_only, int use_ubifsec)
+{
+	struct ubifs_keymap *km;
+	c->km = NULL;
+
+	RETURN_VAL_IF(0, !use_ubifsec);
+
+	km = kmalloc(sizeof(struct ubifs_keymap), GFP_NOFS);
+	RETURN_VAL_IF(-ENOMEM, !km);
+
+	km->ksa_size = 0;
+	km->ksa_first = 0;
+	km->key_size = UBIFSEC_KEYSIZE;
+	km->keys_per_eb = c->leb_size / km->key_size;
+	km->deleted = 0;
+	km->erasures = 0;
+	km->free = 0;
+	km->state = NULL;
+	km->ckpt_buf = NULL;
+	km->purge_ongoing = 0;
+	km->read_only = read_only;
+	km->kbuf = vmalloc(sizeof(u8) * c->leb_size);
+	if (!km->kbuf) {
+		kfree(km);
+		return -ENOMEM;
+	}
+
+	mutex_init(&km->state_mutex);
+	mutex_init(&km->kbuf_mutex);
+	mutex_init(&km->purge_mutex);
+
+	c->km = km;
+	return 0;
+}
+
+/* This function tells the keymap that the ubifs_info context has its range of
+ * LEBs for the keymap reserved: [c->crypto_first, c->crypto_first +
+ * c->crypto_lebs - 1]. Initialization of the keymap is completed in this
+ * function, where the geometry of the keymap is computed and the checkpoint
+ * buffer and key state map data structures are allocated. All keys are given
+ * an initial state of unused, and the function completes by calling
+ * keymap_read_checkpoint to load the current checkpoint to the keystate map.
+ */
+int keymap_assign_lebs(struct ubifs_info *c)
+{
+	struct ubifs_keymap *km;
+	int i;
+	int err;
+
+	km = c->km;
+	RETURN_VAL_IF(0, !km);
+
+	km->ksa_size = c->crypto_lebs - 1;
+	km->ksa_first = c->crypto_first + 1;
+	km->ckpt_leb = c->crypto_first;
+	km->ckpt_sz = ((km->ksa_size * km->keys_per_eb) >> 3);
+	km->ckpt_buf = kmalloc(km->ckpt_sz, GFP_NOFS);
+
+	RETURN_VAL_IF(-ENOMEM, !km->ckpt_buf);
+	/* the state is a double array: first index for each KSA LEB, second
+	 * index for each key on a KSA LEB.
+	 */
+	km->state = kmalloc(sizeof(u8 *) * km->ksa_size, GFP_NOFS);
+	RETURN_VAL_IF(-ENOMEM, !km->state);
+
+	for (i = 0; i < km->ksa_size; ++i) {
+		int len;
+
+		ubifs_assert(km->keys_per_eb % 4 == 0);
+		len = (sizeof(u8) * km->keys_per_eb)
+			>> KEYMAP_STATES_PER_BYTE_SHIFT;
+		km->state[i] = kmalloc(len, GFP_NOFS);
+		RETURN_VAL_IF(-ENOMEM, !(km->state[i]));
+		memset(km->state[i], 0, len);
+		km->free += km->keys_per_eb;
+	}
+	err = keymap_init_ksa_ranges(c);
+	if (err)
+		return err;
+
+	return keymap_read_checkpoint(c);
+}
+
+/* This function frees the memory being used by the keymap.
+ */
+void keymap_free(struct ubifs_info *c)
+{
+	int i;
+	struct ubifs_keymap *km = c->km;
+
+	if (!km)
+		return;
+	mutex_destroy(&km->state_mutex);
+	mutex_destroy(&km->kbuf_mutex);
+	mutex_destroy(&km->purge_mutex);
+	kfree(km->ckpt_buf);
+	for (i = 0; i < km->ksa_ranges; ++i)
+		keymap_ksa_free(c, &(km->ksa[i]));
+	if (km->state) {
+		for (i = 0; i < km->ksa_size; ++i)
+			kfree(km->state[i]);
+		kfree(km->state);
+	}
+	vfree(km->kbuf);
+	kfree(km);
+	c->km = NULL;
+}
+
+/* This function increments the key position refernce for the ksa range
+ * parameter to the next one based on a cyclical ordering with two levels of
+ * granularity: the major is the LEB number, the minor is the key position in
+ * the LEB.
+ */
+static void ksa_range_increment_pos(struct ubifs_keymap *km,
+				    struct ksa_range *ksa)
+{
+	u32 offset;
+	u32 eb;
+
+	ubifs_assert(km);
+	ubifs_assert(ksa);
+
+	pos_to_eb_offset(ksa->cur_pos, &eb, &offset);
+	offset++;
+	if (offset == km->keys_per_eb) {
+		offset = 0;
+		eb++;
+	}
+	if (eb == ksa->ksa_first + ksa->ksa_size)
+		eb = ksa->ksa_first;
+	ksa->cur_pos = eb_offset_to_pos(eb, offset);
+}
+
+/* This function returns true if the key position passed in corresponds to a
+ * unused key. It must be accessed when the key state map is locked.
+ */
+/* TODO(reardon): there's a decent optimizaiton that can be done here:
+ * advancing the KSA position to the next LEB may not be efficient if that
+ * LEB is mostly used, and only has a few unused keys. Here we assume that
+ * either data is deleted soon, or it is deleted later. In this case, its
+ * not efficient to put new data on a KSA block that is otherwise used, as
+ * deleting this new value may trigger an purge on this block only to delete
+ * this one value. More efficient to fill a completely empty block with new
+ * data then such blocks. This may be implemented as a two-pass technique
+ * for advancement, where first, any block with >50% used keys will be
+ * simply ignored. Afterwards, such blocks are indeed considered as space
+ * becomes more constrained.
+ */
+static
+int keymap_is_free(struct ubifs_keymap *km, u64 pos)
+{
+	u32 eb, offset;
+	pos_to_eb_offset(pos, &eb, &offset);
+	return get_state(km, eb, offset) == KEYMAP_STATE_FREE;
+}
+
+/* This function fills pos and key with an unused key in the ksa range as
+ * indicated by the array index ksa_pos. pos must not be null. If key is null,
+ * then the key is not read from the flash storage medium but still assigned.
+ * The key pos is marked as used. If no unused keys are available, then ENOMEM
+ * is returned.
+ */
+int keymap_free_key_in_range(
+	struct ubifs_info *c, int ksa_pos, u64 *pos, u8 *key)
+{
+	struct ubifs_keymap *km = c->km;
+	struct ksa_range *ksa = km->ksa + ksa_pos;
+	int err = 0;
+	u64 start;
+
+	RETURN_VAL_IF(0, !km);
+	RETURN_VAL_IF(-EROFS, km->read_only);
+
+	ubifs_assert(ksa_pos >= 0 && ksa_pos < km->ksa_ranges);
+	ubifs_assert(pos);
+
+	start = ksa->cur_pos;
+
+	if (km->free == 0)
+		RETURN_VAL_IF(-ENOMEM, km->deleted > 0);
+
+	mutex_lock(&km->state_mutex);
+	while (!keymap_is_free(km, ksa->cur_pos)) {
+		ksa_range_increment_pos(km, ksa);
+		if (start == ksa->cur_pos) {
+			err = -ENOMEM;
+			goto out;
+		}
+	}
+	*pos = ksa->cur_pos;
+
+	if (key)
+		keymap_read_key(c, *pos, key);
+
+	keymap_mark_used_internal(km, ksa->cur_pos);
+
+out:
+	mutex_unlock(&km->state_mutex);
+	return err;
+}
+
+/* This function performs the same as keymap_free_key_in_range, except that it
+ * will search for a key in any KSA range greater than or equal to the ksa_pos
+ * array index value. The search begins at the smallest KSA range index, and
+ * returns the first found unused key.
+ */
+int keymap_free_key_in_min_range(
+	struct ubifs_info *c, int ksa_pos, u64 *pos, u8 *key)
+{
+	struct ubifs_keymap *km = c->km;
+	int i;
+	int err;
+
+	RETURN_VAL_IF(0, !km);
+	RETURN_VAL_IF(-EROFS, km->read_only);
+
+	if (km->free == 0)
+		RETURN_VAL_IF(-ENOMEM, km->deleted > 0);
+
+	for (i = ksa_pos; i < km->ksa_ranges; ++i) {
+		err = keymap_free_key_in_range(c, i, pos, key);
+		if (!err)
+			return 0;
+		RETURN_VAL_IF(err, err != -ENOMEM);
+	}
+	return -ENOMEM;
+}
+
+/* This function performs the same as keymap_free_key_in_range, except that it
+ * will search for a key in all the KSA ranges sequentially, starting with the
+ * smallest. The first found unused key is returned.
+ */
+int keymap_free_key(struct ubifs_info *c, u64 *pos, u8 *key)
+{
+	return keymap_free_key_in_min_range(c, 0, pos, key);
+}
+
+int keymap_eb_to_ksa_range(const struct ubifs_keymap *km, const u32 eb)
+{
+	int i;
+	for (i = 1; i < km->ksa_ranges; ++i)
+		if (eb < km->ksa[i].ksa_first)
+			return i - 1;
+	return km->ksa_ranges - 1;
+}
+
+int keymap_pos_to_ksa_range(struct ubifs_keymap *km, u64 pos)
+{
+	u32 eb, offset;
+
+	pos_to_eb_offset(pos, &eb, &offset);
+	return keymap_eb_to_ksa_range(km, eb);
+}
+
+/* This function swaps the encryption key for a data node. The idea for this
+ * is that the data node is being garbage collected, so we can re-encrypt it
+ * at effectiveness no addition cost (safe for the cipher operations). We do
+ * this to 'promote' a datanode to a higher area of the KSA (that is to say,
+ * longer-lived). Each time a datanode survives UBIFS's garbage collection, we
+ * take that as a clue that this data is long-term achieval data. The ultimate
+ * goal is to have all the keys that will never be deleted sitting on the same
+ * KSA LEBs, so that it is never purged.
+ */
+int keymap_swap_encryption_key(struct ubifs_info *c,
+			       struct ubifs_data_node *dn)
+{
+	u8 old_key[UBIFSEC_KEYSIZE];
+	u8 new_key[UBIFSEC_KEYSIZE];
+	char iv[UBIFSEC_KEYSIZE];
+	char *pbuf;
+	u64 old_pos = 0;
+	u64 new_pos = 0;
+	int dlen;
+	int err = 0;
+
+	RETURN_VAL_IF(0, !c->km);
+
+	memset(old_key, 0, UBIFSEC_KEYSIZE);
+	memset(new_key, 0, UBIFSEC_KEYSIZE);
+
+	old_pos = le64_to_cpu(dn->crypto_lookup);
+	err = keymap_read_key(c, old_pos, old_key);
+	RETURN_ON_ERR(err);
+	err = keymap_promote_key(c, old_pos, &new_pos, new_key);
+
+	if (err == -ENOMEM)
+		return err;
+	if (err) {
+		ubifs_err("(keymap) promote key failed: %d", err);
+		return err;
+	}
+	pbuf = kmalloc(4096, GFP_NOFS);
+	RETURN_VAL_IF(-ENOMEM, !pbuf);
+
+	dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
+	memcpy(pbuf, dn->data, dlen);
+
+	memset(iv, 0, UBIFSEC_KEYSIZE);
+	ubifs_aes_crypt(
+		pbuf, dlen, old_key, UBIFSEC_KEYSIZE, iv, UBIFSEC_KEYSIZE);
+	POISON_KEY(old_key);
+
+	memset(iv, 0, UBIFSEC_KEYSIZE);
+	ubifs_aes_crypt(
+		pbuf, dlen, new_key, UBIFSEC_KEYSIZE, iv, UBIFSEC_KEYSIZE);
+	POISON_KEY(new_key);
+
+	memcpy(dn->data, pbuf, dlen);
+	kfree(pbuf);
+	dn->crypto_lookup = cpu_to_le64(new_pos);
+	ubifs_set_datanode_crc(dn);
+
+	return 0;
+}
+
+/* This function promotes a key to a higher (longer-term) KSA block. If no
+ * space is available at a higher block, then it returns -ENOMEM, and no
+ * action should be taken. Otherwise, the caller should decrypt the data with
+ * the old key, encrypt it with the new key, mark the old position
+ * as deleted, and the new position as used.
+ */
+int keymap_promote_key(struct ubifs_info *c, u64 old_pos, u64 *new_pos, u8 
*key)
+{
+	struct ubifs_keymap *km = c->km;
+	int ksa_range;
+	RETURN_VAL_IF(0, !km);
+	ubifs_assert(!km->read_only);
+
+	ksa_range = keymap_pos_to_ksa_range(km, old_pos);
+	ubifs_assert(ksa_range >= 0 && ksa_range < km->ksa_ranges - 1);
+	return keymap_free_key_in_min_range(c, ksa_range + 1, new_pos, key);
+}
+
+/* This function determines if a key position should be promoted to a
+ * higher KSA range. The criteria is the key's current KSA range, and that
+ * KSA range's promotion policy: (expected) number of garbage collections
+ * between promotions. If it is 0, it will not be protomoted. If it is 1, it
+ * will be promoted. Otherwise, it is promoted with probability
+ * 1/2**gcs_until_promotion.
+ */
+int keymap_gc_should_promote(struct ubifs_info *c, u64 pos)
+{
+	int value;
+	int shift;
+	int ksa_range;
+	struct ubifs_keymap *km = c->km;
+
+	RETURN_VAL_IF(0, !km);
+	RETURN_VAL_IF(0, km->read_only);
+
+	ksa_range = keymap_pos_to_ksa_range(km, pos);
+	RETURN_VAL_IF(0, km->ksa[ksa_range].gcs_until_promotion == 0);
+	RETURN_VAL_IF(1, km->ksa[ksa_range].gcs_until_promotion == 1);
+
+	shift = sizeof(int) << 3;
+	get_random_bytes((u8 *) &value, sizeof(int));
+	shift -= km->ksa[ksa_range].gcs_until_promotion;
+	if (shift < 0)
+		shift = 0;
+	if ((value << shift) == 0)
+		return 1;
+
+	return 0;
+}
+
+/* This function sets pos to an unused key position by calling
+ * keymap_free_key with a NULL key.
+ */
+int keymap_free_pos(struct ubifs_info *c, u64 *pos)
+{
+	return keymap_free_key(c, pos, NULL);
+}
+
+/* This function reads a key as defined by the LEB number and offset, and puts
+ * the read key in the buffer buf. It tries to use the appropriate KSA range
+ * cache if it is valid for the position, otherwise it reads it from flash and
+ * updates the corresponding read/write cache. It assumes it is a write
+ * operation if the key being read is the same as the KSA range's current
+ * key assignment position.
+ */
+static int keymap_read_key_cache(struct ubifs_info *c, u32 eb,
+				 u32 offset, u8 *buf)
+{
+	struct ubifs_keymap *km = c->km;
+	struct ksa_range *ksa;
+	struct key_cache *cache;
+	int err;
+	int byte_offset;
+	int page;
+	int page_offset;
+	int page_num;
+
+	RETURN_VAL_IF(0, !km);
+	ksa = &(km->ksa[keymap_eb_to_ksa_range(km, eb)]);
+	cache = NULL;
+	byte_offset = offset * c->km->key_size;
+	page = byte_offset >> c->min_io_shift;
+	page_offset = byte_offset - (page << c->min_io_shift);
+	page_num = page + eb * (c->leb_size >> c->min_io_shift);
+
+	/* Determine if its a write based on cur pos, and set the correct 
cache.
+	 * Unless the other cache is actually on the same page, in which case
+	 * use that instead.
+	 */
+	if (eb_offset_to_pos(eb, offset) == ksa->cur_pos &&
+			keymap_is_free(km, ksa->cur_pos)) {
+		cache = &ksa->wr_cache;
+		if (ksa->rd_cache.page_num == page_num)
+			cache = &ksa->rd_cache;
+	} else {
+		cache = &ksa->rd_cache;
+		if (ksa->wr_cache.page_num == page_num)
+			cache = &ksa->wr_cache;
+	}
+
+	if (cache->page_num != page_num) {
+		err = ubi_read(c->ubi, eb + c->km->ksa_first, cache->page,
+			       page << c->min_io_shift, c->min_io_size);
+		RETURN_ON_ERR(err);
+		cache->page_num = page_num;
+	}
+	memcpy(buf, cache->page + page_offset, c->km->key_size);
+	return 0;
+}
+
+/* This function reads a key and stores the result in buf. It converts the key
+ * position to an LEB number and offset, then calls keymap_read_key_cache.
+ */
+int keymap_read_key(struct ubifs_info *c, u64 pos, u8* buf)
+{
+	u32 eb;
+	u32 offset;
+	RETURN_VAL_IF(0, !c->km);
+	pos_to_eb_offset(pos, &eb, &offset);
+	RETURN_VAL_IF(-EINVAL, eb > c->km->ksa_size ||
+			       offset > c->km->keys_per_eb);
+	return keymap_read_key_cache(c, eb, offset, buf);
+}
+
+/* This function marks a key position as being used in the key state map. It
+ * assumes that the key state map is already locked.
+ */
+static void keymap_mark_used_internal(struct ubifs_keymap *km, u64 pos)
+{
+	u32 eb, offset;
+	pos_to_eb_offset(pos, &eb, &offset);
+	if (offset >= km->keys_per_eb || eb > km->ksa_size) {
+		ubifs_err("(keymap) [%d:%d] out of range to mark used.",
+			  (int) eb, (int) offset);
+		return;
+	}
+	if (get_state(km, eb, offset) == KEYMAP_STATE_FREE)
+		km->free--;
+	set_state(km, eb, offset, KEYMAP_STATE_USED);
+}
+
+/* This function marks a key position as used, and it can be called from
+ * outside keymap.c.  It simply locks the key state map and calls the internal
+ * version.
+ */
+void keymap_mark_used(struct ubifs_info *c, u64 pos)
+{
+	struct ubifs_keymap *km = c->km;
+	if (!km)
+		return;
+	ubifs_assert(!km->read_only);
+	mutex_lock(&km->state_mutex);
+	keymap_mark_used_internal(km, pos);
+	mutex_unlock(&km->state_mutex);
+}
+
+/* This function marks a key position as deleted.
+ */
+void keymap_mark_deleted(struct ubifs_info *c, u64 pos)
+{
+	u32 eb, offset;
+	struct ubifs_keymap *km = c->km;
+	if (!km)
+		return;
+	ubifs_assert(!km->read_only);
+
+	mutex_lock(&km->state_mutex);
+	pos_to_eb_offset(pos, &eb, &offset);
+
+	if (offset >= km->keys_per_eb || eb > km->ksa_size) {
+		ubifs_err("(keymap) [%d:%d] out of range to mark deleted.",
+			  (int) eb, (int) offset);
+		goto unlock;
+	}
+
+	if (get_state(km, eb, offset) != KEYMAP_STATE_DELETED)
+		km->deleted++;
+
+	set_state(km, eb, offset, KEYMAP_STATE_DELETED);
+
+unlock:
+	mutex_unlock(&km->state_mutex);
+}
+
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/Makefile linux-3.2.1-ubifsec/fs/ubifs/Makefile
--- linux-3.2.1-vanilla/fs/ubifs/Makefile	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/Makefile	2012-02-08 16:58:48.913518449 
+0100
@@ -1,6 +1,6 @@
  obj-$(CONFIG_UBIFS_FS) += ubifs.o

-ubifs-y += shrinker.o journal.o file.o dir.o super.o sb.o io.o
+ubifs-y += shrinker.o journal.o file.o dir.o super.o sb.o io.o keymap.o
  ubifs-y += tnc.o master.o scan.o replay.o log.o commit.o gc.o orphan.o
  ubifs-y += budget.o find.o tnc_commit.o compress.o lpt.o lprops.o
  ubifs-y += recovery.o ioctl.o lpt_commit.o tnc_misc.o
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/replay.c linux-3.2.1-ubifsec/fs/ubifs/replay.c
--- linux-3.2.1-vanilla/fs/ubifs/replay.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/replay.c	2012-02-08 16:54:49.145506844 
+0100
@@ -67,6 +67,7 @@ struct replay_entry {
  			loff_t new_size;
  		};
  	};
+	unsigned long long crypto_lookup;
  };

  /**
@@ -249,10 +250,12 @@ static int apply_replay_entry(struct ubi
  			default:
  				err = ubifs_tnc_remove(c, &r->key);
  				break;
-			}
-		else
-			err = ubifs_tnc_add(c, &r->key, r->lnum, r->offs,
-					    r->len);
+		} else {
+			err = ubifs_tnc_add_with_crypto_lookup(
+				c, &r->key, r->lnum, r->offs, r->len,
+				r->crypto_lookup);
+
+		}
  		if (err)
  			return err;

@@ -354,10 +357,11 @@ static void destroy_replay_list(struct u
   * order, the older modifications are applied first. This function returns 
zero
   * in case of success and a negative error code in case of failure.
   */
-static int insert_node(struct ubifs_info *c, int lnum, int offs, int len,
-		       union ubifs_key *key, unsigned long long sqnum,
-		       int deletion, int *used, loff_t old_size,
-		       loff_t new_size)
+static int insert_node(
+	struct ubifs_info *c, int lnum, int offs, int len,
+	union ubifs_key *key, unsigned long long sqnum,
+	int deletion, int *used, loff_t old_size, loff_t new_size,
+	unsigned long long crypto_lookup)
  {
  	struct replay_entry *r;

@@ -372,6 +376,7 @@ static int insert_node(struct ubifs_info

  	if (!deletion)
  		*used += ALIGN(len, 8);
+	r->crypto_lookup = crypto_lookup;
  	r->lnum = lnum;
  	r->offs = offs;
  	r->len = len;
@@ -607,7 +612,7 @@ static int replay_bud(struct ubifs_info
  				deletion = 1;
  			err = insert_node(c, lnum, snod->offs, snod->len,
  					  &snod->key, snod->sqnum, deletion,
-					  &used, 0, new_size);
+					  &used, 0, new_size, 0);
  			break;
  		}
  		case UBIFS_DATA_NODE:
@@ -616,10 +621,11 @@ static int replay_bud(struct ubifs_info
  			loff_t new_size = le32_to_cpu(dn->size) +
  					  key_block(c, &snod->key) *
  					  UBIFS_BLOCK_SIZE;
-
-			err = insert_node(c, lnum, snod->offs, snod->len,
-					  &snod->key, snod->sqnum, deletion,
-					  &used, 0, new_size);
+			err = insert_node(
+				c, lnum, snod->offs, snod->len,
+				&snod->key, snod->sqnum, deletion,
+				&used, 0, new_size,
+				le64_to_cpu(dn->crypto_lookup));
  			break;
  		}
  		case UBIFS_DENT_NODE:
@@ -659,7 +665,7 @@ static int replay_bud(struct ubifs_info
  			trun_key_init(c, &key, le32_to_cpu(trun->inum));
  			err = insert_node(c, lnum, snod->offs, snod->len,
  					  &key, snod->sqnum, 1, &used,
-					  old_size, new_size);
+					  old_size, new_size, 0);
  			break;
  		}
  		default:
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/sb.c linux-3.2.1-ubifsec/fs/ubifs/sb.c
--- linux-3.2.1-vanilla/fs/ubifs/sb.c	2012-01-12 20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/sb.c	2012-02-08 16:54:49.145506844 +0100
@@ -82,6 +82,7 @@ static int create_default_filesystem(str
  	int err, tmp, jnl_lebs, log_lebs, max_buds, main_lebs, main_first;
  	int lpt_lebs, lpt_first, orph_lebs, big_lpt, ino_waste, sup_flags = 0;
  	int min_leb_cnt = UBIFS_MIN_LEB_CNT;
+	int crypto_lebs, crypto_first;
  	long long tmp64, main_bytes;
  	__le64 tmp_le64;

@@ -139,8 +140,22 @@ static int create_default_filesystem(str
  		 */
  		orph_lebs += 1;
  #endif
+	if (c->use_ubifsec) {
+		/* Compute the size of the key space area based on partition
+		 * geometry.
+		 */
+		unsigned long long partition_bytes = c->leb_cnt * c->leb_size;
+		unsigned long long data_nodes =
+			partition_bytes >> UBIFS_BLOCK_SHIFT;
+		do_div(data_nodes, keymap_keys_per_eb(c));
+		crypto_lebs = data_nodes + UBIFSEC_CRYPTO_LEBS_MIN +
+			(data_nodes >> UBIFSEC_CRYPTO_LEBS_SCALE_SHIFT);
+	} else {
+		crypto_lebs = 0;
+	}

-	main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS - log_lebs;
+	main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS -
+		    log_lebs - crypto_lebs;
  	main_lebs -= orph_lebs;

  	lpt_first = UBIFS_LOG_LNUM + log_lebs;
@@ -155,6 +170,7 @@ static int create_default_filesystem(str
  		lpt_first + lpt_lebs - 1);

  	main_first = c->leb_cnt - main_lebs;
+	crypto_first = c->leb_cnt - main_lebs - crypto_lebs;

  	/* Create default superblock */
  	tmp = ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size);
@@ -175,6 +191,7 @@ static int create_default_filesystem(str
  	sup->max_leb_cnt   = cpu_to_le32(c->max_leb_cnt);
  	sup->max_bud_bytes = cpu_to_le64(tmp64);
  	sup->log_lebs      = cpu_to_le32(log_lebs);
+	sup->crypto_lebs   = cpu_to_le32(crypto_lebs);
  	sup->lpt_lebs      = cpu_to_le32(lpt_lebs);
  	sup->orph_lebs     = cpu_to_le32(orph_lebs);
  	sup->jhead_cnt     = cpu_to_le32(DEFAULT_JHEADS_CNT);
@@ -182,6 +199,7 @@ static int create_default_filesystem(str
  	sup->lsave_cnt     = cpu_to_le32(c->lsave_cnt);
  	sup->fmt_version   = cpu_to_le32(UBIFS_FORMAT_VERSION);
  	sup->time_gran     = cpu_to_le32(DEFAULT_TIME_GRAN);
+	sup->use_ubifsec   = cpu_to_le32(c->use_ubifsec);
  	if (c->mount_opts.override_compr)
  		sup->default_compr = cpu_to_le16(c->mount_opts.compr_type);
  	else
@@ -440,7 +458,7 @@ static int validate_sb(struct ubifs_info
  	}

  	if (UBIFS_SB_LEBS + UBIFS_MST_LEBS + c->log_lebs + c->lpt_lebs +
-	    c->orph_lebs + c->main_lebs != c->leb_cnt) {
+	    c->orph_lebs + c->main_lebs + c->crypto_lebs != c->leb_cnt) {
  		err = 12;
  		goto failed;
  	}
@@ -603,6 +621,7 @@ int ubifs_read_superblock(struct ubifs_i
  	c->max_bud_bytes = le64_to_cpu(sup->max_bud_bytes);
  	c->log_lebs      = le32_to_cpu(sup->log_lebs);
  	c->lpt_lebs      = le32_to_cpu(sup->lpt_lebs);
+	c->crypto_lebs   = le32_to_cpu(sup->crypto_lebs);
  	c->orph_lebs     = le32_to_cpu(sup->orph_lebs);
  	c->jhead_cnt     = le32_to_cpu(sup->jhead_cnt) + NONDATA_JHEADS_CNT;
  	c->fanout        = le32_to_cpu(sup->fanout);
@@ -610,6 +629,7 @@ int ubifs_read_superblock(struct ubifs_i
  	c->rp_size       = le64_to_cpu(sup->rp_size);
  	c->rp_uid        = le32_to_cpu(sup->rp_uid);
  	c->rp_gid        = le32_to_cpu(sup->rp_gid);
+	c->use_ubifsec   = le32_to_cpu(sup->use_ubifsec);
  	sup_flags        = le32_to_cpu(sup->flags);
  	if (!c->mount_opts.override_compr)
  		c->default_compr = le16_to_cpu(sup->default_compr);
@@ -643,8 +663,10 @@ int ubifs_read_superblock(struct ubifs_i
  	c->lpt_last = c->lpt_first + c->lpt_lebs - 1;
  	c->orph_first = c->lpt_last + 1;
  	c->orph_last = c->orph_first + c->orph_lebs - 1;
-	c->main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS;
+	c->main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS -
+		       c->crypto_lebs;
  	c->main_lebs -= c->log_lebs + c->lpt_lebs + c->orph_lebs;
+	c->crypto_first = c->leb_cnt - c->main_lebs - c->crypto_lebs;
  	c->main_first = c->leb_cnt - c->main_lebs;

  	err = validate_sb(c, sup);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/super.c linux-3.2.1-ubifsec/fs/ubifs/super.c
--- linux-3.2.1-vanilla/fs/ubifs/super.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/super.c	2012-02-08 16:54:49.149506844 
+0100
@@ -438,7 +438,8 @@ static int ubifs_show_options(struct seq
  		seq_printf(s, ",chk_data_crc");
  	else if (c->mount_opts.chk_data_crc == 1)
  		seq_printf(s, ",no_chk_data_crc");
-
+	if (c->mount_opts.use_ubifsec)
+		seq_printf(s, ",use_ubifsec");
  	if (c->mount_opts.override_compr) {
  		seq_printf(s, ",compr=%s",
  			   ubifs_compr_name(c->mount_opts.compr_type));
@@ -938,6 +939,8 @@ static int check_volume_empty(struct ubi
   * Opt_chk_data_crc: check CRCs when reading data nodes
   * Opt_no_chk_data_crc: do not check CRCs when reading data nodes
   * Opt_override_compr: override default compressor
+ * Opt_commit_interval: seconds between a forced commit
+ * Opt_use_ubifsec: use ubifsec secure deletion feature
   * Opt_err: just end of array marker
   */
  enum {
@@ -948,6 +951,8 @@ enum {
  	Opt_chk_data_crc,
  	Opt_no_chk_data_crc,
  	Opt_override_compr,
+	Opt_commit_interval,
+	Opt_use_ubifsec,
  	Opt_err,
  };

@@ -959,6 +964,8 @@ static const match_table_t tokens = {
  	{Opt_chk_data_crc, "chk_data_crc"},
  	{Opt_no_chk_data_crc, "no_chk_data_crc"},
  	{Opt_override_compr, "compr=%s"},
+	{Opt_commit_interval, "commit_interval=%s"},
+	{Opt_use_ubifsec, "use_ubifsec"},
  	{Opt_err, NULL},
  };

@@ -1036,6 +1043,18 @@ static int ubifs_parse_options(struct ub
  			c->mount_opts.chk_data_crc = 1;
  			c->no_chk_data_crc = 1;
  			break;
+		case Opt_commit_interval:
+		{
+			struct timeval tv;
+			unsigned long seconds;
+			char *name = match_strdup(&args[0]);
+			kstrtoul(name, 10, &seconds);
+			kfree(name);
+			c->commit_interval = seconds;
+			do_gettimeofday(&tv);
+			c->next_commit = tv.tv_sec + c->commit_interval;
+			break;
+		}
  		case Opt_override_compr:
  		{
  			char *name = match_strdup(&args[0]);
@@ -1058,6 +1077,12 @@ static int ubifs_parse_options(struct ub
  			c->default_compr = c->mount_opts.compr_type;
  			break;
  		}
+		case Opt_use_ubifsec:
+		{
+			c->mount_opts.use_ubifsec = 1;
+			c->use_ubifsec = 1;
+			break;
+		}
  		default:
  		{
  			unsigned long flag;
@@ -1236,6 +1261,12 @@ static int mount_ubifs(struct ubifs_info
  	err = ubifs_read_superblock(c);
  	if (err)
  		goto out_free;
+	keymap_init(c, c->ro_media, c->use_ubifsec);
+	if (c->use_ubifsec && !c->km)
+		goto out_free;
+
+	/* After reading super block, give the keymap its geometry. */
+	keymap_assign_lebs(c);

  	/*
  	 * Make sure the compressor which is set as default in the superblock
@@ -1487,6 +1518,7 @@ static int mount_ubifs(struct ubifs_info
  		c->bud_bytes, c->bud_bytes >> 10, c->bud_bytes >> 20);
  	dbg_msg("max. seq. number:    %llu", c->max_sqnum);
  	dbg_msg("commit number:       %llu", c->cmt_no);
+	dbg_msg("use ubifsec:         %d", c->use_ubifsec);

  	return 0;

@@ -1514,6 +1546,7 @@ out_free:
  	kfree(c->bu.buf);
  	vfree(c->ileb_buf);
  	vfree(c->sbuf);
+	keymap_free(c);
  	kfree(c->bottom_up_buf);
  	ubifs_debugging_exit(c);
  	return err;
@@ -1553,6 +1586,7 @@ static void ubifs_umount(struct ubifs_in
  	kfree(c->bu.buf);
  	vfree(c->ileb_buf);
  	vfree(c->sbuf);
+	keymap_free(c);
  	kfree(c->bottom_up_buf);
  	ubifs_debugging_exit(c);
  }
@@ -2010,6 +2044,8 @@ static struct ubifs_info *alloc_ubifs_in

  		c->highest_inum = UBIFS_FIRST_INO;
  		c->lhead_lnum = c->ltail_lnum = UBIFS_LOG_LNUM;
+		c->commit_interval = (unsigned long) -1;
+		c->use_ubifsec = 0;

  		ubi_get_volume_info(ubi, &c->vi);
  		ubi_get_device_info(c->vi.ubi_num, &c->di);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/tnc.c linux-3.2.1-ubifsec/fs/ubifs/tnc.c
--- linux-3.2.1-vanilla/fs/ubifs/tnc.c	2012-01-12 20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/tnc.c	2012-02-08 16:54:49.149506844 +0100
@@ -2154,19 +2154,22 @@ do_split:
  }

  /**
- * ubifs_tnc_add - add a node to TNC.
+ * ubifs_tnc_add_with_crypto_lookup - add a node to TNC.
   * @c: UBIFS file-system description object
   * @key: key to add
   * @lnum: LEB number of node
   * @offs: node offset
   * @len: node length
+ * @crypto_lookup: the node's key position in the KSA
   *
   * This function adds a node with key @key to TNC. The node may be new or it 
may
   * obsolete some existing one. Returns %0 on success or negative error code on
   * failure.
   */
-int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
-		  int offs, int len)
+int ubifs_tnc_add_with_crypto_lookup(struct ubifs_info *c,
+				     const union ubifs_key *key, int lnum,
+				     int offs, int len,
+				     unsigned long long crypto_lookup)
  {
  	int found, n, err = 0;
  	struct ubifs_znode *znode;
@@ -2181,11 +2184,20 @@ int ubifs_tnc_add(struct ubifs_info *c,
  		zbr.lnum = lnum;
  		zbr.offs = offs;
  		zbr.len = len;
+		if (c->use_ubifsec && key_type(c, key) == UBIFS_DATA_KEY) {
+			zbr.crypto_lookup = crypto_lookup;
+			keymap_mark_used(c, zbr.crypto_lookup);
+		}
  		key_copy(c, key, &zbr.key);
  		err = tnc_insert(c, znode, &zbr, n + 1);
  	} else if (found == 1) {
  		struct ubifs_zbranch *zbr = &znode->zbranch[n];

+		if (c->use_ubifsec && key_type(c, key) == UBIFS_DATA_KEY) {
+			keymap_mark_deleted(c, zbr->crypto_lookup);
+			zbr->crypto_lookup = crypto_lookup;
+			keymap_mark_used(c, zbr->crypto_lookup);
+		}
  		lnc_free(zbr);
  		err = ubifs_add_dirt(c, zbr->lnum, zbr->len);
  		zbr->lnum = lnum;
@@ -2200,6 +2212,13 @@ int ubifs_tnc_add(struct ubifs_info *c,
  	return err;
  }

+int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
+		  int offs, int len) {
+	if (c->use_ubifsec && key_type(c, key) == UBIFS_DATA_KEY)
+		ubifs_assert(c->use_ubifsec == 0);
+	return ubifs_tnc_add_with_crypto_lookup(c, key, lnum, offs, len, 0);
+}
+
  /**
   * ubifs_tnc_replace - replace a node in the TNC only if the old node is 
found.
   * @c: UBIFS file-system description object
@@ -2215,7 +2234,8 @@ int ubifs_tnc_add(struct ubifs_info *c,
   * Returns %0 on success or negative error code on failure.
   */
  int ubifs_tnc_replace(struct ubifs_info *c, const union ubifs_key *key,
-		      int old_lnum, int old_offs, int lnum, int offs, int len)
+		      int old_lnum, int old_offs, int lnum, int offs, int len,
+		      u64 crypto_lookup)
  {
  	int found, n, err = 0;
  	struct ubifs_znode *znode;
@@ -2234,6 +2254,15 @@ int ubifs_tnc_replace(struct ubifs_info

  		found = 0;
  		if (zbr->lnum == old_lnum && zbr->offs == old_offs) {
+			if (c->use_ubifsec &&
+			    key_type(c, key) == UBIFS_DATA_KEY) {
+				if (zbr->crypto_lookup != crypto_lookup) {
+					keymap_mark_deleted(
+						c, zbr->crypto_lookup);
+					zbr->crypto_lookup = crypto_lookup;
+					keymap_mark_used(c, 
zbr->crypto_lookup);
+				}
+			}
  			lnc_free(zbr);
  			err = ubifs_add_dirt(c, zbr->lnum, zbr->len);
  			if (err)
@@ -2401,6 +2430,8 @@ static int tnc_delete(struct ubifs_info
  	dbg_tnc("deleting %s", DBGKEY(&znode->zbranch[n].key));

  	zbr = &znode->zbranch[n];
+	if (c->use_ubifsec && key_type(c, &(zbr->key)) == UBIFS_DATA_KEY)
+		keymap_mark_deleted(c, zbr->crypto_lookup);
  	lnc_free(zbr);

  	err = ubifs_add_dirt(c, zbr->lnum, zbr->len);
@@ -2478,6 +2509,7 @@ static int tnc_delete(struct ubifs_info
  			c->zroot.lnum = zbr->lnum;
  			c->zroot.offs = zbr->offs;
  			c->zroot.len = zbr->len;
+			c->zroot.crypto_lookup = zbr->crypto_lookup;
  			c->zroot.znode = znode;
  			ubifs_assert(!ubifs_zn_obsolete(zp));
  			ubifs_assert(ubifs_zn_dirty(zp));
@@ -2647,6 +2679,7 @@ int ubifs_tnc_remove_range(struct ubifs_
  			key = &znode->zbranch[i].key;
  			if (!key_in_range(c, key, from_key, to_key))
  				break;
+			keymap_mark_deleted(c, 
znode->zbranch[i].crypto_lookup);
  			lnc_free(&znode->zbranch[i]);
  			err = ubifs_add_dirt(c, znode->zbranch[i].lnum,
  					     znode->zbranch[i].len);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/tnc_commit.c 
linux-3.2.1-ubifsec/fs/ubifs/tnc_commit.c
--- linux-3.2.1-vanilla/fs/ubifs/tnc_commit.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/tnc_commit.c	2012-02-08 16:54:49.149506844 
+0100
@@ -51,6 +51,8 @@ static int make_idx_node(struct ubifs_in
  		key_write_idx(c, &zbr->key, &br->key);
  		br->lnum = cpu_to_le32(zbr->lnum);
  		br->offs = cpu_to_le32(zbr->offs);
+		if (key_type(c, &zbr->key) == UBIFS_DATA_KEY)
+			br->crypto_lookup = cpu_to_le64(zbr->crypto_lookup);
  		br->len = cpu_to_le32(zbr->len);
  		if (!zbr->lnum || !zbr->len) {
  			ubifs_err("bad ref in znode");
@@ -859,6 +861,10 @@ static int write_index(struct ubifs_info
  			struct ubifs_zbranch *zbr = &znode->zbranch[i];

  			key_write_idx(c, &zbr->key, &br->key);
+			if (key_type(c, &zbr->key) == UBIFS_DATA_KEY) {
+				br->crypto_lookup =
+					cpu_to_le64(zbr->crypto_lookup);
+			}
  			br->lnum = cpu_to_le32(zbr->lnum);
  			br->offs = cpu_to_le32(zbr->offs);
  			br->len = cpu_to_le32(zbr->len);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/tnc_misc.c linux-3.2.1-ubifsec/fs/ubifs/tnc_misc.c
--- linux-3.2.1-vanilla/fs/ubifs/tnc_misc.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/tnc_misc.c	2012-02-08 16:54:49.149506844 
+0100
@@ -309,6 +309,7 @@ static int read_znode(struct ubifs_info
  		zbr->lnum = le32_to_cpu(br->lnum);
  		zbr->offs = le32_to_cpu(br->offs);
  		zbr->len  = le32_to_cpu(br->len);
+		zbr->crypto_lookup = 0;
  		zbr->znode = NULL;

  		/* Validate branch */
@@ -323,10 +324,12 @@ static int read_znode(struct ubifs_info

  		switch (key_type(c, &zbr->key)) {
  		case UBIFS_INO_KEY:
-		case UBIFS_DATA_KEY:
  		case UBIFS_DENT_KEY:
  		case UBIFS_XENT_KEY:
  			break;
+		case UBIFS_DATA_KEY:
+			zbr->crypto_lookup = le64_to_cpu(br->crypto_lookup);
+			break;
  		default:
  			dbg_msg("bad key type at slot %d: %s", i,
  				DBGKEY(&zbr->key));
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/ubifs.h linux-3.2.1-ubifsec/fs/ubifs/ubifs.h
--- linux-3.2.1-vanilla/fs/ubifs/ubifs.h	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/ubifs.h	2012-02-08 16:54:51.969506980 
+0100
@@ -163,6 +163,19 @@
  /* Maximum number of data nodes to bulk-read */
  #define UBIFS_MAX_BULK_READ 32

+/* Size of 128 bits in bytes */
+#define AES_KEYSIZE_128 16
+
+/* Key size in bytes for UBIFSEC */
+#define UBIFSEC_KEYSIZE AES_KEYSIZE_128
+#define UBIFSEC_CRYPTO_ALGORITHM "ctr(aes)"
+#define UBIFSEC_CRYPTO_LEBS_SCALE_SHIFT 4
+#define UBIFSEC_CRYPTO_LEBS_MIN 3
+#define UBIFSEC_COMMIT_INTERVAL(c)					\
+	((c)->use_ubifsec && (c)->commit_interval != -1)
+
+#define POISON_KEY(p) memset(p, 0xff, UBIFSEC_KEYSIZE)
+
  /*
   * Lockdep classes for UBIFS inode @ui_mutex.
   */
@@ -749,6 +762,7 @@ struct ubifs_zbranch {
  	int lnum;
  	int offs;
  	int len;
+	unsigned long long crypto_lookup;
  };

  /**
@@ -930,6 +944,7 @@ struct ubifs_orphan {
   *                  specified in @compr_type)
   * @compr_type: compressor type to override the superblock compressor with
   *              (%UBIFS_COMPR_NONE, etc)
+ * @use_ubifsec: use ubifsec secure deletion feature
   */
  struct ubifs_mount_opts {
  	unsigned int unmount_mode:2;
@@ -937,6 +952,7 @@ struct ubifs_mount_opts {
  	unsigned int chk_data_crc:2;
  	unsigned int override_compr:1;
  	unsigned int compr_type:2;
+	unsigned int use_ubifsec:1;
  };

  /**
@@ -974,6 +990,7 @@ struct ubifs_budg_info {
  };

  struct ubifs_debug_info;
+struct ubifs_keymap;

  /**
   * struct ubifs_info - UBIFS file-system description data structure
@@ -1218,6 +1235,13 @@ struct ubifs_debug_info;
   *                  FS to R/W mode
   * @size_tree: inode size information for recovery
   * @mount_opts: UBIFS-specific mount options
+ * @km: the keymap data structure for ubifsec
+ * @crypto_lebs: the number of LEBS assigned to store keys for the keymap
+ * @crypto_first: the number of the first LEB assigned to store keys
+ * @use_ubifsec: the switch to enable/disable UBIFSec
+ * @commit_interval: the number of seconds between forced commiting to purge
+ *                   the key storage area of deleted keys
+ * @next_commit: the time at which the next commit will occur
   *
   * @dbg: debugging-related information
   */
@@ -1450,6 +1474,13 @@ struct ubifs_info {
  #ifdef CONFIG_UBIFS_FS_DEBUG
  	struct ubifs_debug_info *dbg;
  #endif
+
+	struct ubifs_keymap *km;
+	int crypto_lebs;
+	int crypto_first;
+	unsigned int use_ubifsec;
+	long commit_interval;
+	unsigned long long next_commit;
  };

  extern struct list_head ubifs_infos;
@@ -1489,6 +1520,7 @@ int ubifs_write_node(struct ubifs_info *
  		     int offs, int dtype);
  int ubifs_check_node(const struct ubifs_info *c, const void *buf, int lnum,
  		     int offs, int quiet, int must_chk_crc);
+void ubifs_set_datanode_crc(void *node);
  void ubifs_prepare_node(struct ubifs_info *c, void *buf, int len, int pad);
  void ubifs_prep_grp_node(struct ubifs_info *c, void *node, int len, int last);
  int ubifs_io_init(struct ubifs_info *c);
@@ -1579,8 +1611,12 @@ int ubifs_tnc_locate(struct ubifs_info *
  		     void *node, int *lnum, int *offs);
  int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
  		  int offs, int len);
+int ubifs_tnc_add_with_crypto_lookup(
+	struct ubifs_info *c, const union ubifs_key *key,
+	int lnum, int offs, int len, unsigned long long crypto_lookup);
  int ubifs_tnc_replace(struct ubifs_info *c, const union ubifs_key *key,
-		      int old_lnum, int old_offs, int lnum, int offs, int len);
+		      int old_lnum, int old_offs, int lnum, int offs,
+		      int len, u64 crypto_lookup);
  int ubifs_tnc_add_nm(struct ubifs_info *c, const union ubifs_key *key,
  		     int lnum, int offs, int len, const struct qstr *nm);
  int ubifs_tnc_remove(struct ubifs_info *c, const union ubifs_key *key);
@@ -1775,9 +1811,26 @@ long ubifs_compat_ioctl(struct file *fil
  int __init ubifs_compressors_init(void);
  void ubifs_compressors_exit(void);
  void ubifs_compress(const void *in_buf, int in_len, void *out_buf, int 
*out_len,
-		    int *compr_type);
-int ubifs_decompress(const void *buf, int len, void *out, int *out_len,
-		     int compr_type);
+		    int *compr_type, u8* key);
+int ubifs_decompress(void *buf, int len, void *out, int *out_len,
+		     int compr_type, u8 *key);
+int ubifs_aes_crypt(u8 *str, int len, u8 *key, int keylen, u8 *iv, int ivlen);
+
+/* keymap.c */
+int keymap_purge(struct ubifs_info *c);
+int keymap_init(struct ubifs_info *c, int read_only, int use_ubifsec);
+void keymap_free(struct ubifs_info *c);
+int keymap_free_key(struct ubifs_info *c, u64 *pos, u8 *key);
+int keymap_read_key(struct ubifs_info *c, u64 pos, u8 *buf);
+void keymap_mark_used(struct ubifs_info *c, u64 pos);
+void keymap_mark_deleted(struct ubifs_info *c, u64 pos);
+int keymap_assign_lebs(struct ubifs_info *c);
+int keymap_keys_per_eb(struct ubifs_info *c);
+int keymap_promote_key(struct ubifs_info *c, u64 old_pos, u64 *new_pos,
+		       u8 *key);
+int keymap_gc_should_promote(struct ubifs_info *c, u64 pos);
+int keymap_swap_encryption_key(struct ubifs_info *c,
+			       struct ubifs_data_node *dn);

  #include "debug.h"
  #include "misc.h"
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/ubifs-media.h 
linux-3.2.1-ubifsec/fs/ubifs/ubifs-media.h
--- linux-3.2.1-vanilla/fs/ubifs/ubifs-media.h	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/ubifs-media.h	2012-02-08 16:54:51.969506980 
+0100
@@ -550,9 +550,14 @@ struct ubifs_dent_node {
   * Note, do not forget to amend 'zero_data_node_unused()' function when
   * changing the padding fields.
   */
+/* TODO(reardon): sorry about lifting these 8 unused bytes from @key to
+ * use for @crypto_lookup. Can someone reviewing this give me a more elegant
+ * and maintable way of preserving the size of data in a data node?
+ */
  struct ubifs_data_node {
  	struct ubifs_ch ch;
-	__u8 key[UBIFS_MAX_KEY_LEN];
+	__u8 key[UBIFS_MAX_KEY_LEN/2];
+	__u64 crypto_lookup;
  	__le32 size;
  	__le16 compr_type;
  	__u8 padding[2]; /* Watch 'zero_data_node_unused()' if changing! */
@@ -614,10 +619,12 @@ struct ubifs_pad_node {
   * @rp_uid: reserve pool UID
   * @rp_gid: reserve pool GID
   * @rp_size: size of the reserved pool in bytes
- * @padding2: reserved for future, zeroes
   * @time_gran: time granularity in nanoseconds
   * @uuid: UUID generated when the file system image was created
   * @ro_compat_version: UBIFS R/O compatibility version
+ * @crypto_lebs: number of LEBS being used to store keys
+ * @use_ubifsec: whether the file system should use ubifsec secure deletio
+ * @padding2: reserved for future, zeroes
   */
  struct ubifs_sb_node {
  	struct ubifs_ch ch;
@@ -645,7 +652,9 @@ struct ubifs_sb_node {
  	__le32 time_gran;
  	__u8 uuid[16];
  	__le32 ro_compat_version;
-	__u8 padding2[3968];
+	__le32 crypto_lebs;
+	__u8 use_ubifsec;
+	__u8 padding2[3963];
  } __packed;

  /**
@@ -742,6 +751,7 @@ struct ubifs_branch {
  	__le32 lnum;
  	__le32 offs;
  	__le32 len;
+	__le64 crypto_lookup;
  	__u8 key[];
  } __packed;
--776899908-974393995-1328723309=:19593--
