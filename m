Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab2ESIah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 04:30:37 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:57052
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754571Ab2ESIad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 04:30:33 -0400
Date: Sat, 19 May 2012 10:30:29 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] UBIFS: read crypto_lookup from datanodes to znodes
In-Reply-To: <alpine.DEB.2.00.1205161451250.27131@eristoteles.iwoars.net>
Message-ID: <alpine.DEB.2.00.1205191027340.18672@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205151101100.17750@eristoteles.iwoars.net> <1337087022.2528.204.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1205161451250.27131@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Crypto_lookup values are now read from the data node header whenever a
data node is read from flash and cached in the TNC. The value will be zero
until it is read from flash. (If it is needed before it happens to be
loaded, i.e., to delete a node, then it will be forced read.)

It was tested by setting cryptolookup values for new datanodes by their
lnum and offset on flash. This was later asserted in the TNC that they
were either zero, or always equal. On mounting, the TNC crypto lookup
values were confirmed to be zero and later, after reading the
corresponding files, confirmed they were loaded and corresponded to the
location on flash.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/gc.c          |    8 +++++++-
 fs/ubifs/journal.c     |    8 +++++---
 fs/ubifs/tnc.c         |   21 ++++++++++++++++++---
 fs/ubifs/tnc_misc.c    |    9 +++++++++
 fs/ubifs/ubifs-media.h |    3 ++-
 5 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index f146447..4a21358 100644
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
+		struct ubifs_data_node *dn = snod->node;
+
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
index 2072b9a..5f39f75 100644
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
@@ -747,7 +747,8 @@ int ubifs_jnl_write_data(struct ubifs_info *c, const struct inode *inode,
 	ubifs_wbuf_add_ino_nolock(&c->jheads[DATAHD].wbuf, key_inum(c, key));
 	release_head(c, DATAHD);

-	err = ubifs_tnc_add(c, key, lnum, offs, dlen, 0);
+	err = ubifs_tnc_add(c, key, lnum, offs, dlen,
+			    le64_to_cpu(data->crypto_lookup));
 	if (err)
 		goto out_ro;

@@ -1226,7 +1227,8 @@ int ubifs_jnl_truncate(struct ubifs_info *c, const struct inode *inode,

 	if (dlen) {
 		sz = offs + UBIFS_INO_NODE_SZ + UBIFS_TRUN_NODE_SZ;
-		err = ubifs_tnc_add(c, &key, lnum, sz, dlen, 0);
+		err = ubifs_tnc_add(c, &key, lnum, sz, dlen,
+				    le64_to_cpu(dn->crypto_lookup));
 		if (err)
 			goto out_ro;
 	}
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index b222a72..08185c1 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -499,6 +499,8 @@ static int try_read_node(const struct ubifs_info *c, void *buf, int type,
  *
  * This function tries to read a node and returns %1 if the node is read, %0
  * if the node is not present, and a negative error code in the case of error.
+ * It sets @zbr's @crypto_lookup field to the value in the read node if it is
+ * a data node.
  */
 static int fallible_read_node(struct ubifs_info *c, const union ubifs_key *key,
 			      struct ubifs_zbranch *zbr, void *node)
@@ -511,12 +513,25 @@ static int fallible_read_node(struct ubifs_info *c, const union ubifs_key *key,
 			    zbr->offs);
 	if (ret == 1) {
 		union ubifs_key node_key;
-		struct ubifs_dent_node *dent = node;
+		struct ubifs_data_node *dn = node;

-		/* All nodes have key in the same place */
-		key_read(c, &dent->key, &node_key);
+		/* All node types have key in the same place */
+		key_read(c, &dn->key, &node_key);
 		if (keys_cmp(c, key, &node_key) != 0)
 			ret = 0;
+		/* If it is actually a data node, read the crypto_lookup */
+		if (key_type(c, key) == UBIFS_DATA_KEY) {
+			long long crypto_lookup;
+
+			crypto_lookup = le64_to_cpu(dn->crypto_lookup);
+			if (zbr->crypto_lookup != 0)
+				ubifs_assert(zbr->crypto_lookup ==
+					     crypto_lookup);
+			else
+				zbr->crypto_lookup =
+					crypto_lookup;
+		}
+
 	}
 	if (ret == 0 && c->replaying)
 		dbg_mntk(key, "dangling branch LEB %d:%d len %d, key ",
diff --git a/fs/ubifs/tnc_misc.c b/fs/ubifs/tnc_misc.c
index 38fdfd0..44c3699 100644
--- a/fs/ubifs/tnc_misc.c
+++ b/fs/ubifs/tnc_misc.c
@@ -490,6 +490,15 @@ int ubifs_tnc_read_node(struct ubifs_info *c, struct ubifs_zbranch *zbr,
 		dbg_dump_node(c, node);
 		return -EINVAL;
 	}
+	if (key_type(c, &(zbr->key)) == UBIFS_DATA_KEY) {
+		struct ubifs_data_node *dn = node;
+		long long crypto_lookup = le64_to_cpu(dn->crypto_lookup);
+
+		if (zbr->crypto_lookup != 0)
+			ubifs_assert(zbr->crypto_lookup == crypto_lookup);
+		else
+			zbr->crypto_lookup = crypto_lookup;
+	}

 	return 0;
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


