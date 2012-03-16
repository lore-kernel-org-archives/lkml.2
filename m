Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422974Ab2CPPC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:02:28 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:37797
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1422818Ab2CPPCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:02:19 -0400
Date: Fri, 16 Mar 2012 16:02:15 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Remove notion of key schemes
In-Reply-To: <1331905305.3730.90.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203161601210.2249@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>   <1329152067.22240.214.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>   <alpine.DEB.2.00.1203151545410.26775@eristoteles.iwoars.net> 
 <1331902271.3730.76.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203161405090.2249@eristoteles.iwoars.net> <1331905305.3730.90.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the notion of different  key schemes for ubifs with a single 64
bit key scheme. Reduced the size of UBIFS keys to 8 bytes
globally. Fill in the void left behind with padding for the effected
nodes, so previous version will not be effected.
Changed zero_* functions to operate on the new padding. Replaced key
scheme enum with one entry into a define.

This was tested using integck and writing files on a nandsimmed partition
using both the vanilla version of ubifs and the modified version. Data
was written using both ubifs drivers and successfully read when later
mounting with either driver.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>


diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index ec9f187..7e87f92 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -365,7 +365,7 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)

 	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, file->f_pos);

-	if (file->f_pos > UBIFS_S_KEY_HASH_MASK || file->f_pos == 2)
+	if (file->f_pos > UBIFS_KEY_HASH_MASK || file->f_pos == 2)
 		/*
 		 * The directory was seek'ed to a senseless position or there
 		 * are no more entries.
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 2f438ab..137415e 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -66,6 +66,7 @@
  */
 static inline void zero_ino_node_unused(struct ubifs_ino_node *ino)
 {
+	memset(ino->padding0, 0, 8);
 	memset(ino->padding1, 0, 4);
 	memset(ino->padding2, 0, 26);
 }
@@ -77,6 +78,7 @@ static inline void zero_ino_node_unused(struct ubifs_ino_node *ino)
  */
 static inline void zero_dent_node_unused(struct ubifs_dent_node *dent)
 {
+	memset(dent->padding0, 0, 8);
 	dent->padding1 = 0;
 	memset(dent->padding2, 0, 4);
 }
@@ -87,7 +89,8 @@ static inline void zero_dent_node_unused(struct ubifs_dent_node *dent)
  */
 static inline void zero_data_node_unused(struct ubifs_data_node *data)
 {
-	memset(data->padding, 0, 2);
+	data->padding0 = 0;
+	memset(data->padding1, 0, 2);
 }

 /**
diff --git a/fs/ubifs/key.h b/fs/ubifs/key.h
index 92a8491..f67f24a 100644
--- a/fs/ubifs/key.h
+++ b/fs/ubifs/key.h
@@ -22,16 +22,13 @@

 /*
  * This header contains various key-related definitions and helper function.
- * UBIFS allows several key schemes, so we access key fields only via these
- * helpers. At the moment only one key scheme is supported.
+ * All access to key fields must be done only via the helper functions
+ * defined in this file.
  *
- * Simple key scheme
- * ~~~~~~~~~~~~~~~~~
- *
- * Keys are 64-bits long. First 32-bits are inode number (parent inode number
- * in case of direntry key). Next 3 bits are node type. The last 29 bits are
- * 4KiB offset in case of inode node, and direntry hash in case of a direntry
- * node. We use "r5" hash borrowed from reiserfs.
+ * Keys are 64-bits long. The first 32-bits are inode number (parent inode
+ * number in case of direntry key). The next 3 bits are node type. The next
+ * 29 bits are 4KiB offset in case of inode node, and direntry hash in case
+ * of a direntry node. We use "r5" hash borrowed from reiserfs.
  */

 #ifndef __UBIFS_KEY_H__
@@ -47,7 +44,7 @@
  */
 static inline uint32_t key_mask_hash(uint32_t hash)
 {
-	hash &= UBIFS_S_KEY_HASH_MASK;
+	hash &= UBIFS_KEY_HASH_MASK;
 	if (unlikely(hash <= 2))
 		hash += 3;
 	return hash;
@@ -97,7 +94,7 @@ static inline void ino_key_init(const struct ubifs_info *c,
 				union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
-	key->u32[1] = UBIFS_INO_KEY << UBIFS_S_KEY_BLOCK_BITS;
+	key->u32[1] = UBIFS_INO_KEY << UBIFS_KEY_BLOCK_BITS;
 }

 /**
@@ -112,8 +109,7 @@ static inline void ino_key_init_flash(const struct ubifs_info *c, void *k,
 	union ubifs_key *key = k;

 	key->j32[0] = cpu_to_le32(inum);
-	key->j32[1] = cpu_to_le32(UBIFS_INO_KEY << UBIFS_S_KEY_BLOCK_BITS);
-	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+	key->j32[1] = cpu_to_le32(UBIFS_INO_KEY << UBIFS_KEY_BLOCK_BITS);
 }

 /**
@@ -155,9 +151,9 @@ static inline void dent_key_init(const struct ubifs_info *c,
 {
 	uint32_t hash = c->key_hash(nm->name, nm->len);

-	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	ubifs_assert(!(hash & ~UBIFS_KEY_HASH_MASK));
 	key->u32[0] = inum;
-	key->u32[1] = hash | (UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS);
+	key->u32[1] = hash | (UBIFS_DENT_KEY << UBIFS_KEY_HASH_BITS);
 }

 /**
@@ -172,9 +168,9 @@ static inline void dent_key_init_hash(const struct ubifs_info *c,
 				      union ubifs_key *key, ino_t inum,
 				      uint32_t hash)
 {
-	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	ubifs_assert(!(hash & ~UBIFS_KEY_HASH_MASK));
 	key->u32[0] = inum;
-	key->u32[1] = hash | (UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS);
+	key->u32[1] = hash | (UBIFS_DENT_KEY << UBIFS_KEY_HASH_BITS);
 }

 /**
@@ -190,11 +186,10 @@ static inline void dent_key_init_flash(const struct ubifs_info *c, void *k,
 	union ubifs_key *key = k;
 	uint32_t hash = c->key_hash(nm->name, nm->len);

-	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	ubifs_assert(!(hash & ~UBIFS_KEY_HASH_MASK));
 	key->j32[0] = cpu_to_le32(inum);
 	key->j32[1] = cpu_to_le32(hash |
-				  (UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS));
-	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+				  (UBIFS_DENT_KEY << UBIFS_KEY_HASH_BITS));
 }

 /**
@@ -207,7 +202,7 @@ static inline void lowest_dent_key(const struct ubifs_info *c,
 				   union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
-	key->u32[1] = UBIFS_DENT_KEY << UBIFS_S_KEY_HASH_BITS;
+	key->u32[1] = UBIFS_DENT_KEY << UBIFS_KEY_HASH_BITS;
 }

 /**
@@ -223,9 +218,9 @@ static inline void xent_key_init(const struct ubifs_info *c,
 {
 	uint32_t hash = c->key_hash(nm->name, nm->len);

-	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	ubifs_assert(!(hash & ~UBIFS_KEY_HASH_MASK));
 	key->u32[0] = inum;
-	key->u32[1] = hash | (UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS);
+	key->u32[1] = hash | (UBIFS_XENT_KEY << UBIFS_KEY_HASH_BITS);
 }

 /**
@@ -241,11 +236,10 @@ static inline void xent_key_init_flash(const struct ubifs_info *c, void *k,
 	union ubifs_key *key = k;
 	uint32_t hash = c->key_hash(nm->name, nm->len);

-	ubifs_assert(!(hash & ~UBIFS_S_KEY_HASH_MASK));
+	ubifs_assert(!(hash & ~UBIFS_KEY_HASH_MASK));
 	key->j32[0] = cpu_to_le32(inum);
 	key->j32[1] = cpu_to_le32(hash |
-				  (UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS));
-	memset(k + 8, 0, UBIFS_MAX_KEY_LEN - 8);
+				  (UBIFS_XENT_KEY << UBIFS_KEY_HASH_BITS));
 }

 /**
@@ -258,7 +252,7 @@ static inline void lowest_xent_key(const struct ubifs_info *c,
 				   union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
-	key->u32[1] = UBIFS_XENT_KEY << UBIFS_S_KEY_HASH_BITS;
+	key->u32[1] = UBIFS_XENT_KEY << UBIFS_KEY_HASH_BITS;
 }

 /**
@@ -272,9 +266,9 @@ static inline void data_key_init(const struct ubifs_info *c,
 				 union ubifs_key *key, ino_t inum,
 				 unsigned int block)
 {
-	ubifs_assert(!(block & ~UBIFS_S_KEY_BLOCK_MASK));
+	ubifs_assert(!(block & ~UBIFS_KEY_BLOCK_MASK));
 	key->u32[0] = inum;
-	key->u32[1] = block | (UBIFS_DATA_KEY << UBIFS_S_KEY_BLOCK_BITS);
+	key->u32[1] = block | (UBIFS_DATA_KEY << UBIFS_KEY_BLOCK_BITS);
 }

 /**
@@ -286,7 +280,7 @@ static inline void data_key_init(const struct ubifs_info *c,
 static inline void highest_data_key(const struct ubifs_info *c,
 				   union ubifs_key *key, ino_t inum)
 {
-	data_key_init(c, key, inum, UBIFS_S_KEY_BLOCK_MASK);
+	data_key_init(c, key, inum, UBIFS_KEY_BLOCK_MASK);
 }

 /**
@@ -302,7 +296,7 @@ static inline void trun_key_init(const struct ubifs_info *c,
 				 union ubifs_key *key, ino_t inum)
 {
 	key->u32[0] = inum;
-	key->u32[1] = UBIFS_TRUN_KEY << UBIFS_S_KEY_BLOCK_BITS;
+	key->u32[1] = UBIFS_TRUN_KEY << UBIFS_KEY_BLOCK_BITS;
 }

 /**
@@ -327,7 +321,7 @@ static inline void invalid_key_init(const struct ubifs_info *c,
 static inline int key_type(const struct ubifs_info *c,
 			   const union ubifs_key *key)
 {
-	return key->u32[1] >> UBIFS_S_KEY_BLOCK_BITS;
+	return key->u32[1] >> UBIFS_KEY_BLOCK_BITS;
 }

 /**
@@ -339,7 +333,7 @@ static inline int key_type_flash(const struct ubifs_info *c, const void *k)
 {
 	const union ubifs_key *key = k;

-	return le32_to_cpu(key->j32[1]) >> UBIFS_S_KEY_BLOCK_BITS;
+	return le32_to_cpu(key->j32[1]) >> UBIFS_KEY_BLOCK_BITS;
 }

 /**
@@ -374,7 +368,7 @@ static inline ino_t key_inum_flash(const struct ubifs_info *c, const void *k)
 static inline uint32_t key_hash(const struct ubifs_info *c,
 				const union ubifs_key *key)
 {
-	return key->u32[1] & UBIFS_S_KEY_HASH_MASK;
+	return key->u32[1] & UBIFS_KEY_HASH_MASK;
 }

 /**
@@ -386,7 +380,7 @@ static inline uint32_t key_hash_flash(const struct ubifs_info *c, const void *k)
 {
 	const union ubifs_key *key = k;

-	return le32_to_cpu(key->j32[1]) & UBIFS_S_KEY_HASH_MASK;
+	return le32_to_cpu(key->j32[1]) & UBIFS_KEY_HASH_MASK;
 }

 /**
@@ -397,7 +391,7 @@ static inline uint32_t key_hash_flash(const struct ubifs_info *c, const void *k)
 static inline unsigned int key_block(const struct ubifs_info *c,
 				     const union ubifs_key *key)
 {
-	return key->u32[1] & UBIFS_S_KEY_BLOCK_MASK;
+	return key->u32[1] & UBIFS_KEY_BLOCK_MASK;
 }

 /**
@@ -410,7 +404,7 @@ static inline unsigned int key_block_flash(const struct ubifs_info *c,
 {
 	const union ubifs_key *key = k;

-	return le32_to_cpu(key->j32[1]) & UBIFS_S_KEY_BLOCK_MASK;
+	return le32_to_cpu(key->j32[1]) & UBIFS_KEY_BLOCK_MASK;
 }

 /**
@@ -441,7 +435,6 @@ static inline void key_write(const struct ubifs_info *c,

 	t->j32[0] = cpu_to_le32(from->u32[0]);
 	t->j32[1] = cpu_to_le32(from->u32[1]);
-	memset(to + 8, 0, UBIFS_MAX_KEY_LEN - 8);
 }

 /**
@@ -531,18 +524,4 @@ static inline int is_hash_key(const struct ubifs_info *c,
 	return type == UBIFS_DENT_KEY || type == UBIFS_XENT_KEY;
 }

-/**
- * key_max_inode_size - get maximum file size allowed by current key format.
- * @c: UBIFS file-system description object
- */
-static inline unsigned long long key_max_inode_size(const struct ubifs_info *c)
-{
-	switch (c->key_fmt) {
-	case UBIFS_SIMPLE_KEY_FMT:
-		return (1ULL << UBIFS_S_KEY_BLOCK_BITS) * UBIFS_BLOCK_SIZE;
-	default:
-		return 0;
-	}
-}
-
 #endif /* !__UBIFS_KEY_H__ */
diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 771f7fb..3fc9071 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -86,7 +86,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	__le64 tmp_le64;

 	/* Some functions called from here depend on the @c->key_len filed */
-	c->key_len = UBIFS_SK_LEN;
+	c->key_len = UBIFS_KEY_LEN;

 	/*
 	 * First of all, we have to calculate default file-system geometry -
@@ -599,7 +599,7 @@ int ubifs_read_superblock(struct ubifs_info *c)

 	switch (c->key_fmt) {
 	case UBIFS_SIMPLE_KEY_FMT:
-		c->key_len = UBIFS_SK_LEN;
+		c->key_len = UBIFS_KEY_LEN;
 		break;
 	default:
 		ubifs_err("unsupported key format");
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 63765d5..312175d 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2057,7 +2057,7 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_magic = UBIFS_SUPER_MAGIC;
 	sb->s_blocksize = UBIFS_BLOCK_SIZE;
 	sb->s_blocksize_bits = UBIFS_BLOCK_SHIFT;
-	sb->s_maxbytes = c->max_inode_sz = key_max_inode_size(c);
+	sb->s_maxbytes = c->max_inode_sz = UBIFS_KEY_MAX_INODE_SIZE;
 	if (c->max_inode_sz > MAX_LFS_FILESIZE)
 		sb->s_maxbytes = c->max_inode_sz = MAX_LFS_FILESIZE;
 	sb->s_op = &ubifs_super_operations;
diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index e24380c..9ecbd37 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -108,11 +108,11 @@
 /* UBIFS padding byte pattern (must not be first or last byte of node magic) */
 #define UBIFS_PADDING_BYTE 0xCE

-/* Maximum possible key length */
-#define UBIFS_MAX_KEY_LEN 16
+/* UBIFS key length */
+#define UBIFS_KEY_LEN 8

-/* Key length ("simple" format) */
-#define UBIFS_SK_LEN 8
+/* UBIFS key format */
+#define UBIFS_SIMPLE_KEY_FMT 0

 /* Minimum index tree fanout */
 #define UBIFS_MIN_FANOUT 3
@@ -196,22 +196,15 @@ enum {
 };

 /*
- * Supported key formats.
- *
- * UBIFS_SIMPLE_KEY_FMT: simple key format
- */
-enum {
-	UBIFS_SIMPLE_KEY_FMT,
-};
-
-/*
  * The simple key format uses 29 bits for storing UBIFS block number and hash
  * value.
  */
-#define UBIFS_S_KEY_BLOCK_BITS 29
-#define UBIFS_S_KEY_BLOCK_MASK 0x1FFFFFFF
-#define UBIFS_S_KEY_HASH_BITS  UBIFS_S_KEY_BLOCK_BITS
-#define UBIFS_S_KEY_HASH_MASK  UBIFS_S_KEY_BLOCK_MASK
+#define UBIFS_KEY_BLOCK_BITS 29
+#define UBIFS_KEY_BLOCK_MASK 0x1FFFFFFF
+#define UBIFS_KEY_HASH_BITS  UBIFS_KEY_BLOCK_BITS
+#define UBIFS_KEY_HASH_MASK  UBIFS_KEY_BLOCK_MASK
+#define UBIFS_KEY_MAX_INODE_SIZE \
+	((1ULL << UBIFS_KEY_BLOCK_BITS) * UBIFS_BLOCK_SIZE)

 /*
  * Key types.
@@ -456,6 +449,7 @@ union ubifs_dev_desc {
  * struct ubifs_ino_node - inode node.
  * @ch: common header
  * @key: node key
+ * @padding0: reserved for future, zeroes
  * @creat_sqnum: sequence number at time of creation
  * @size: inode size in bytes (amount of uncompressed data)
  * @atime_sec: access time seconds
@@ -489,7 +483,8 @@ union ubifs_dev_desc {
  */
 struct ubifs_ino_node {
 	struct ubifs_ch ch;
-	__u8 key[UBIFS_MAX_KEY_LEN];
+	__u8 key[UBIFS_KEY_LEN];
+	__u8 padding0[8]; /* Watch 'zero_ino_node_unused()' if changing! */
 	__le64 creat_sqnum;
 	__le64 size;
 	__le64 atime_sec;
@@ -517,6 +512,7 @@ struct ubifs_ino_node {
  * struct ubifs_dent_node - directory entry node.
  * @ch: common header
  * @key: node key
+ * @padding0: reserved for future, zeroes
  * @inum: target inode number
  * @padding1: reserved for future, zeroes
  * @type: type of the target inode (%UBIFS_ITYPE_REG, %UBIFS_ITYPE_DIR, etc)
@@ -529,9 +525,10 @@ struct ubifs_ino_node {
  */
 struct ubifs_dent_node {
 	struct ubifs_ch ch;
-	__u8 key[UBIFS_MAX_KEY_LEN];
+	__u8 key[UBIFS_KEY_LEN];
+	__u8 padding0[8]; /* Watch 'zero_dent_node_unused()' if changing! */
 	__le64 inum;
-	__u8 padding1;
+	__u8 padding1; /* Watch 'zero_dent_node_unused()' if changing! */
 	__u8 type;
 	__le16 nlen;
 	__u8 padding2[4]; /* Watch 'zero_dent_node_unused()' if changing! */
@@ -552,10 +549,11 @@ struct ubifs_dent_node {
  */
 struct ubifs_data_node {
 	struct ubifs_ch ch;
-	__u8 key[UBIFS_MAX_KEY_LEN];
+	__u8 key[UBIFS_KEY_LEN];
+	__le64 padding0; /* Watch 'zero_data_node_unused()' if changing! */
 	__le32 size;
 	__le16 compr_type;
-	__u8 padding[2]; /* Watch 'zero_data_node_unused()' if changing! */
+	__u8 padding1[2]; /* Watch 'zero_data_node_unused()' if changing! */
 	__u8 data[];
 } __packed;

diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 93d59ac..7c343e1 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -274,10 +274,10 @@ struct ubifs_old_idx {

 /* The below union makes it easier to deal with keys */
 union ubifs_key {
-	uint8_t u8[UBIFS_SK_LEN];
-	uint32_t u32[UBIFS_SK_LEN/4];
-	uint64_t u64[UBIFS_SK_LEN/8];
-	__le32 j32[UBIFS_SK_LEN/4];
+	uint8_t u8[UBIFS_KEY_LEN];
+	uint32_t u32[UBIFS_KEY_LEN/4];
+	uint64_t u64[UBIFS_KEY_LEN/8];
+	__le32 j32[UBIFS_KEY_LEN/4];
 };

 /**
@@ -1065,8 +1065,8 @@ struct ubifs_debug_info;
  *
  * @key_hash_type: type of the key hash
  * @key_hash: direntry key hash function
- * @key_fmt: key format
- * @key_len: key length
+ * @key_fmt: (obsolete, set to 0) key format
+ * @key_len: key length in bytes
  * @fanout: fanout of the index tree (number of links per indexing node)
  *
  * @min_io_size: minimal input/output unit size

