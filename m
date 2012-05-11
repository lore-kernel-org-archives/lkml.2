Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2EKLYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:24:40 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:44577
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752350Ab2EKLYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:24:38 -0400
Date: Fri, 11 May 2012 13:24:34 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: add crypto lookup field to tree node cache
Message-ID: <alpine.DEB.2.00.1205111323010.17715@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new field to the TNC's zbranch and allows it to be set when
a node is added or replaced. The field is called 'crypto_lookup' and it refers
to a location in the key storage area---a pointer to a key that is used to
encrypt/decrypt the data node. It can be set to 0 or a negative number when it
is not being used. When a new node is added, this value is passed and set
When a node is replace, the old value is replaced with the new value.

These values will be used in future patchs. Replacing a
crypto_lookup value will also mark the old value as deleted and the new value
as used; adding a new node will mark the value as used. Additionally, deleting
or removing TNC nodes will mark the values as deleted.

TNC's crypto_lookup values are not stored on disk. They will be stored in the
data
node's header. Therefore, if a crypto_lookup value is invalid (but a valid one
is to be expected and needs to be used) then a function will be added that
reads the data node to
obtain the value. Additionally, when a data node is ever read, the
crypto_lookup position that is read will be set in the corresponding zbranch.

The values are not stored on disk to avoid having different on-disk formats of
the the ubifs_branch structure.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/gc.c       |    2 +-
 fs/ubifs/journal.c  |   24 ++++++++++++------------
 fs/ubifs/replay.c   |    2 +-
 fs/ubifs/tnc.c      |   11 +++++++++--
 fs/ubifs/tnc_misc.c |    1 +
 fs/ubifs/ubifs.h    |    7 +++++--
 6 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index ded29f6..528ed58 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -330,7 +330,7 @@ static int move_node(struct ubifs_info *c, struct ubifs_scan_leb *sleb,

 	err = ubifs_tnc_replace(c, &snod->key, sleb->lnum,
 				snod->offs, new_lnum, new_offs,
-				snod->len);
+				snod->len, 0);
 	list_del(&snod->list);
 	kfree(snod);
 	return err;
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 57c4d2f..f3eb13c 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -646,13 +646,13 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
 	 */
 	ino_key_init(c, &ino_key, inode->i_ino);
 	ino_offs = dent_offs + aligned_dlen;
-	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, ilen);
+	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, ilen, 0);
 	if (err)
 		goto out_ro;

 	ino_key_init(c, &ino_key, dir->i_ino);
 	ino_offs += aligned_ilen;
-	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, UBIFS_INO_NODE_SZ);
+	err = ubifs_tnc_add(c, &ino_key, lnum, ino_offs, UBIFS_INO_NODE_SZ, 0);
 	if (err)
 		goto out_ro;

@@ -747,7 +747,7 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
 	ubifs_wbuf_add_ino_nolock(&c->jheads[DATAHD].wbuf, key_inum(c, key));
 	release_head(c, DATAHD);

-	err = ubifs_tnc_add(c, key, lnum, offs, dlen);
+	err = ubifs_tnc_add(c, key, lnum, offs, dlen, 0);
 	if (err)
 		goto out_ro;

@@ -825,7 +825,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
 		union ubifs_key key;

 		ino_key_init(c, &key, inode->i_ino);
-		err = ubifs_tnc_add(c, &key, lnum, offs, len);
+		err = ubifs_tnc_add(c, &key, lnum, offs, len, 0);
 	}
 	if (err)
 		goto out_ro;
@@ -1048,21 +1048,21 @@ int ubifs_jnl_rename(struct ubifs_info *c, const struct inode *old_dir,
 	offs += aligned_dlen1 + aligned_dlen2;
 	if (new_inode) {
 		ino_key_init(c, &key, new_inode->i_ino);
-		err = ubifs_tnc_add(c, &key, lnum, offs, ilen);
+		err = ubifs_tnc_add(c, &key, lnum, offs, ilen, 0);
 		if (err)
 			goto out_ro;
 		offs += ALIGN(ilen, 8);
 	}

 	ino_key_init(c, &key, old_dir->i_ino);
-	err = ubifs_tnc_add(c, &key, lnum, offs, plen);
+	err = ubifs_tnc_add(c, &key, lnum, offs, plen, 0);
 	if (err)
 		goto out_ro;

 	if (old_dir != new_dir) {
 		offs += ALIGN(plen, 8);
 		ino_key_init(c, &key, new_dir->i_ino);
-		err = ubifs_tnc_add(c, &key, lnum, offs, plen);
+		err = ubifs_tnc_add(c, &key, lnum, offs, plen, 0);
 		if (err)
 			goto out_ro;
 	}
@@ -1226,13 +1226,13 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const struct inode *inode,

 	if (dlen) {
 		sz = offs + UBIFS_INO_NODE_SZ + UBIFS_TRUN_NODE_SZ;
-		err = ubifs_tnc_add(c, &key, lnum, sz, dlen);
+		err = ubifs_tnc_add(c, &key, lnum, sz, dlen, 0);
 		if (err)
 			goto out_ro;
 	}

 	ino_key_init(c, &key, inum);
-	err = ubifs_tnc_add(c, &key, lnum, offs, UBIFS_INO_NODE_SZ);
+	err = ubifs_tnc_add(c, &key, lnum, offs, UBIFS_INO_NODE_SZ, 0);
 	if (err)
 		goto out_ro;

@@ -1367,7 +1367,7 @@ int ubifs_jnl_delete_xattr(struct ubifs_info *c, const struct inode *host,

 	/* And update TNC with the new host inode position */
 	ino_key_init(c, &key1, host->i_ino);
-	err = ubifs_tnc_add(c, &key1, lnum, xent_offs + len - hlen, hlen);
+	err = ubifs_tnc_add(c, &key1, lnum, xent_offs + len - hlen, hlen, 0);
 	if (err)
 		goto out_ro;

@@ -1440,12 +1440,12 @@ int ubifs_jnl_change_xattr(struct ubifs_info *c, const struct inode *inode,
 		goto out_ro;

 	ino_key_init(c, &key, host->i_ino);
-	err = ubifs_tnc_add(c, &key, lnum, offs, len1);
+	err = ubifs_tnc_add(c, &key, lnum, offs, len1, 0);
 	if (err)
 		goto out_ro;

 	ino_key_init(c, &key, inode->i_ino);
-	err = ubifs_tnc_add(c, &key, lnum, offs + aligned_len1, len2);
+	err = ubifs_tnc_add(c, &key, lnum, offs + aligned_len1, len2, 0);
 	if (err)
 		goto out_ro;

diff --git a/fs/ubifs/replay.c b/fs/ubifs/replay.c
index b007637..f029b2d 100644
--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -252,7 +252,7 @@ static int apply_replay_entry(struct ubifs_info *c, struct replay_entry *r)
 			}
 		else
 			err = ubifs_tnc_add(c, &r->key, r->lnum, r->offs,
-					    r->len);
+					    r->len, 0);
 		if (err)
 			return err;

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 16ad84d..b222a72 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -2158,13 +2158,14 @@ do_split:
  * @lnum: LEB number of node
  * @offs: node offset
  * @len: node length
+ * @crypto_lookup: the node's cryptographic key's position in the KSA
  *
  * This function adds a node with key @key to TNC. The node may be new or it may
  * obsolete some existing one. Returns %0 on success or negative error code on
  * failure.
  */
 int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
-		  int offs, int len)
+		  int offs, int len, long long crypto_lookup)
 {
 	int found, n, err = 0;
 	struct ubifs_znode *znode;
@@ -2179,6 +2180,7 @@ int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
 		zbr.lnum = lnum;
 		zbr.offs = offs;
 		zbr.len = len;
+		zbr.crypto_lookup = crypto_lookup;
 		key_copy(c, key, &zbr.key);
 		err = tnc_insert(c, znode, &zbr, n + 1);
 	} else if (found == 1) {
@@ -2189,6 +2191,7 @@ int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
 		zbr->lnum = lnum;
 		zbr->offs = offs;
 		zbr->len = len;
+		zbr->crypto_lookup = crypto_lookup;
 	} else
 		err = found;
 	if (!err)
@@ -2207,13 +2210,15 @@ int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
  * @lnum: LEB number of node
  * @offs: node offset
  * @len: node length
+ * @crypto_lookup: the node's updated cryptographic key's position in the KSA
  *
  * This function replaces a node with key @key in the TNC only if the old node
  * is found.  This function is called by garbage collection when node are moved.
  * Returns %0 on success or negative error code on failure.
  */
 int ubifs_tnc_replace(struct ubifs_info *c, const union ubifs_key *key,
-		      int old_lnum, int old_offs, int lnum, int offs, int len)
+		      int old_lnum, int old_offs, int lnum, int offs, int len,
+		      long long crypto_lookup)
 {
 	int found, n, err = 0;
 	struct ubifs_znode *znode;
@@ -2239,6 +2244,7 @@ int ubifs_tnc_replace(struct ubifs_info *c, const union ubifs_key *key,
 			zbr->lnum = lnum;
 			zbr->offs = offs;
 			zbr->len = len;
+			zbr->crypto_lookup = crypto_lookup;
 			found = 1;
 		} else if (is_hash_key(c, key)) {
 			found = resolve_collision_directly(c, key, &znode, &n,
@@ -2476,6 +2482,7 @@ static int tnc_delete(struct ubifs_info *c, struct ubifs_znode *znode, int n)
 			c->zroot.lnum = zbr->lnum;
 			c->zroot.offs = zbr->offs;
 			c->zroot.len = zbr->len;
+			c->zroot.crypto_lookup = zbr->crypto_lookup;
 			c->zroot.znode = znode;
 			ubifs_assert(!ubifs_zn_obsolete(zp));
 			ubifs_assert(ubifs_zn_dirty(zp));
diff --git a/fs/ubifs/tnc_misc.c b/fs/ubifs/tnc_misc.c
index dc28fe6..38fdfd0 100644
--- a/fs/ubifs/tnc_misc.c
+++ b/fs/ubifs/tnc_misc.c
@@ -309,6 +309,7 @@ static int read_znode(struct ubifs_info *c, int lnum, int offs, int len,
 		zbr->lnum = le32_to_cpu(br->lnum);
 		zbr->offs = le32_to_cpu(br->offs);
 		zbr->len  = le32_to_cpu(br->len);
+		zbr->crypto_lookup = 0;
 		zbr->znode = NULL;

 		/* Validate branch */
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index ce6d8c2..b777c0c 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -741,6 +741,7 @@ struct ubifs_jhead {
  * @lnum: LEB number of the target node (indexing node or data node)
  * @offs: target node offset within @lnum
  * @len: target node length
+ * @crypto_lookup: the node's cryptographic key's position in the KSA
  */
 struct ubifs_zbranch {
 	union ubifs_key key;
@@ -751,6 +752,7 @@ struct ubifs_zbranch {
 	int lnum;
 	int offs;
 	int len;
+	long long crypto_lookup;
 };

 /**
@@ -1580,9 +1582,10 @@ int ubifs_tnc_lookup_nm(struct ubifs_info *c, const union ubifs_key *key,
 int ubifs_tnc_locate(struct ubifs_info *c, const union ubifs_key *key,
 		     void *node, int *lnum, int *offs);
 int ubifs_tnc_add(struct ubifs_info *c, const union ubifs_key *key, int lnum,
-		  int offs, int len);
+		  int offs, int len, long long crypto_lookup);
 int ubifs_tnc_replace(struct ubifs_info *c, const union ubifs_key *key,
-		      int old_lnum, int old_offs, int lnum, int offs, int len);
+		      int old_lnum, int old_offs, int lnum, int offs, int len,
+		      long long crypto_lookup);
 int ubifs_tnc_add_nm(struct ubifs_info *c, const union ubifs_key *key,
 		     int lnum, int offs, int len, const struct qstr *nm);
 int ubifs_tnc_remove(struct ubifs_info *c, const union ubifs_key *key);
-- 
1.7.5.4


