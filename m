Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2EOJBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:01:50 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:55158
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S932120Ab2EOJBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:01:48 -0400
Date: Tue, 15 May 2012 11:01:47 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: read crypto_lookup from datanodes to znodes
Message-ID: <alpine.DEB.2.00.1205151101100.17750@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crypto_lookup values are now oppertunistically read from the data node header whenever a data
node is read from flash and cached in the TNC. The value will be zero until it
is read from flash. (If it is needed before it happens to be loaded, i.e., to
delete a node, then it will be forced read.)

It was tested by setting cryptolookup values for new datanodes by their lnum
and offset on flash. This was later asserted in the TNC that they were either
zero, or always equal. On mounting, the TNC crypto lookup values were
confirmed to be zero and later, after reading the corresponding files,
confirmed they were loaded and corresponded to the location on flash.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/gc.c          |    8 +++++++-
 fs/ubifs/journal.c     |    9 ++++++---
 fs/ubifs/tnc.c         |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/ubifs/ubifs-media.h |    3 ++-
 4 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index f146447..16df2f4 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -322,15 +322,21 @@ static int move_node(struct ubifs_info *c, struct ubifs_scan_leb *sleb,
 		     struct ubifs_scan_node *snod, struct ubifs_wbuf *wbuf)
 {
 	int err, new_lnum = wbuf->lnum, new_offs = wbuf->offs + wbuf->used;
+	long long crypto_lookup = 0;

 	cond_resched();
 	err = ubifs_wbuf_write_nolock(wbuf, snod->node, snod->len);
 	if (err)
 		return err;

+	if (key_type(c, &snod->key) == UBIFS_DATA_KEY) {
+		struct ubifs_data_node *dn =
+			(struct ubifs_data_node *) snod->node;
+		crypto_lookup = le64_to_cpu(dn->crypto_lookup);
+	}
 	err = ubifs_tnc_replace(c, &snod->key, sleb->lnum,
 				snod->offs, new_lnum, new_offs,
-				snod->len, 0);
+				snod->len, crypto_lookup);
 	list_del(&snod->list);
 	kfree(snod);
 	return err;
diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 2072b9a..3f7aa05 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -89,7 +89,6 @@ static inline void zero_dent_node_unused(struct ubifs_dent_node *dent)
  */
 static inline void zero_data_node_unused(struct ubifs_data_node *data)
 {
-	data->padding0 = 0;
 	memset(data->padding1, 0, 2);
 }

@@ -735,6 +734,7 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,

 	dlen = UBIFS_DATA_NODE_SZ + out_len;
 	data->compr_type = cpu_to_le16(compr_type);
+	data->crypto_lookup = cpu_to_le64(0);

 	/* Make reservation before allocating sequence numbers */
 	err = make_reservation(c, DATAHD, dlen);
@@ -742,12 +742,14 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
 		goto out_free;

 	err = write_node(c, DATAHD, data, dlen, &lnum, &offs);
+
 	if (err)
 		goto out_release;
 	ubifs_wbuf_add_ino_nolock(&c->jheads[DATAHD].wbuf, key_inum(c, key));
 	release_head(c, DATAHD);

-	err = ubifs_tnc_add(c, key, lnum, offs, dlen, 0);
+	err = ubifs_tnc_add(c, key, lnum, offs, dlen,
+			    le64_to_cpu(data->crypto_lookup));
 	if (err)
 		goto out_ro;

@@ -1226,7 +1228,8 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const struct inode *inode,

 	if (dlen) {
 		sz = offs + UBIFS_INO_NODE_SZ + UBIFS_TRUN_NODE_SZ;
-		err = ubifs_tnc_add(c, &key, lnum, sz, dlen, 0);
+		err = ubifs_tnc_add(c, &key, lnum, sz, dlen,
+				    le64_to_cpu(dn->crypto_lookup));
 		if (err)
 			goto out_ro;
 	}
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index b222a72..ac0d03c 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -1431,6 +1431,35 @@ static int maybe_leb_gced(struct ubifs_info *c, int lnum, int gc_seq1)
 }

 /**
+ * tnc_set_crypto_lookup - set the crypto_lookup field in a zbranch.
+ * @c: UBIFS file-system description object
+ * @zbr: the crypto_lookup field is set in this zbranch
+ * @node: a pointer to a node containing the zbranch.
+ *
+ * Crypto_lookup values are stored on flash memory inside the data node.
+ * When the system is running, they should be oppertunistically stored in
+ * memory inside the zbranch. This function is called whenever a node
+ * is read from flash memory. If @node is a data node (therefore containing a
+ * @crypto_lookup field), then:
+ * if @zbr has an unset @crypto_lookup, set it to the value from @node
+ * if @zbr has already a @crypto_lookup, assert they are the same.
+ */
+static void tnc_set_crypto_lookup(struct ubifs_info *c,
+				  struct ubifs_zbranch *zbr, void *node)
+{
+	if (key_type(c, &(zbr->key)) == UBIFS_DATA_KEY) {
+		struct ubifs_data_node *dn =
+			(struct ubifs_data_node *) node;
+		if (zbr->crypto_lookup != 0) {
+			ubifs_assert(zbr->crypto_lookup ==
+				     le64_to_cpu(dn->crypto_lookup));
+		} else {
+			zbr->crypto_lookup = le64_to_cpu(dn->crypto_lookup);
+		}
+	}
+}
+
+/**
  * ubifs_tnc_locate - look up a file-system node and return it and its location.
  * @c: UBIFS file-system description object
  * @key: node key to lookup
@@ -1485,6 +1514,11 @@ again:
 	if (ubifs_get_wbuf(c, zbr.lnum)) {
 		/* We do not GC journal heads */
 		err = ubifs_tnc_read_node(c, &zbr, node);
+		if (!err) {
+			mutex_lock(&c->tnc_mutex);
+			tnc_set_crypto_lookup(c, &(znode->zbranch[n]), node);
+			mutex_unlock(&c->tnc_mutex);
+		}
 		return err;
 	}

@@ -1497,9 +1531,15 @@ again:
 		safely = 1;
 		goto again;
 	}
+
+	mutex_lock(&c->tnc_mutex);
+	tnc_set_crypto_lookup(c, &(znode->zbranch[n]), node);
+	mutex_unlock(&c->tnc_mutex);
 	return 0;

 out:
+	if (!err)
+		tnc_set_crypto_lookup(c, zt, node);
 	mutex_unlock(&c->tnc_mutex);
 	return err;
 }
diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index 9ecbd37..e03adcf 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -539,6 +539,7 @@ struct ubifs_dent_node {
  * struct ubifs_data_node - data node.
  * @ch: common header
  * @key: node key
+ * @crypto_lookup: the node's cryptographic key's position in the KSA
  * @size: uncompressed data size in bytes
  * @compr_type: compression type (%UBIFS_COMPR_NONE, %UBIFS_COMPR_LZO, etc)
  * @padding: reserved for future, zeroes
@@ -550,7 +551,7 @@ struct ubifs_dent_node {
 struct ubifs_data_node {
 	struct ubifs_ch ch;
 	__u8 key[UBIFS_KEY_LEN];
-	__le64 padding0; /* Watch 'zero_data_node_unused()' if changing! */
+	__le64 crypto_lookup;
 	__le32 size;
 	__le16 compr_type;
 	__u8 padding1[2]; /* Watch 'zero_data_node_unused()' if changing! */
-- 
1.7.5.4

