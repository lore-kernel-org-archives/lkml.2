Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2BWO7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:59:55 -0500
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:44849
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753974Ab2BWO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:59:54 -0500
Date: Thu, 23 Feb 2012 15:59:51 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Adding Secure Deletion to UBIFS
In-Reply-To: <1329152067.22240.214.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net> <1329152067.22240.214.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Could you make a separate patch which adds new on-flash format and make
> sure that new ubifs binaries can mount the old formats and work with
> them. And that old ubifs binaries gracefully reject the new format.
>

This patch provides a new version of two on-flash data structures for 
UBIFS:
ubifs_branch and ubifs_data_node have been grown by 8 bytes to include a 
64-bit reference
to a key position, which is needed by a proposed ubifs secure deletion 
addition. This patch is generated
against linux-3.2.1.

Because both data structures use C99 flexible arrays, it is not possible 
to add the new field as
the last member of the structure. Thus, it was added one before last, the 
last was renamed, and in a
handful of places where it was used, a macro accessor is used to get the 
version-correct position.

The new/modified macros are the following:
FMT_VERSION_DATA_NODE_HAS_CRYPTO_LOOKUP(c)
FMT_VERSION_BRANCH_HAS_CRYPTO_LOOKUP(c)
These take the ubifs_context and return true if the version defined in 
fmt_version has a crypto_lookup field.

FMT_VERSION_BRANCH_POS_KEY(c, br)
FMT_VERSION_DATA_NODE_POS_DATA(c, dn)
These take the ubifs_context and the data_node / branch and return the 
address of the key / data field
that is correct for the version defined in fmt_version. key and data are 
renamed to __key / __data to
prevent any accidental version incapible usage.

UBIFS_DATA_NODE_SZ(c)
UBIFS_BRANCH_SZ(c)
These now take the ubifs_context and return the data structure's size 
according to the format version.

In create_default_filesystem, the fmt_version is set earlier so these 
macros behave correctly.


This was tested as follows:
1) A vanilla and modified module were both created. An empty drive was 
mounted under the vanilla
module to create a version 4 drive. Data was written to it
and integck was run (always a hundred times followed by powercut tests).
2) The module was switched to modified and it was mounted again. The data 
was read correctly and the
integck was run.
3) New data was written and it was mounted again under the vanilla 
modules. Both data was read again
and integck was run.
4) Finally, it was remounted under version 5 and the data correctly read 
and integck was run.

Additionally, an empty drive was mounted under the modified modules to 
create a version 5 drive.
1) Data was written to it and integck was run.
2) It was attempted to be mounted under the vanilla driver, but it did not 
succeed. Dmesg reports
version mismatch as the reason. A mounting attempted as read-only 
continued, but it failed when trying to read
the superblock.
3) It was remounted under the modified module where the data was correctly 
read back.


----------

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/commit.c 
linux-3.2.1-ubifsec/fs/ubifs/commit.c
--- linux-3.2.1-vanilla/fs/ubifs/commit.c	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/commit.c	2012-02-23 
15:06:49.107957279 +0100
@@ -650,7 +650,7 @@ int dbg_check_old_index(struct ubifs_inf
  		/* Check key range */
  		key_read(c, ubifs_idx_key(c, idx), &l_key);
  		br = ubifs_idx_branch(c, idx, child_cnt - 1);
-		key_read(c, &br->key, &u_key);
+		key_read(c, FMT_VERSION_BRANCH_POS_KEY(c, br), &u_key);
  		if (keys_cmp(c, &lower_key, &l_key) > 0) {
  			err = 5;
  			goto out_dump;
@@ -699,10 +699,11 @@ int dbg_check_old_index(struct ubifs_inf
  		lnum = le32_to_cpu(br->lnum);
  		offs = le32_to_cpu(br->offs);
  		len = le32_to_cpu(br->len);
-		key_read(c, &br->key, &lower_key);
+		key_read(c, FMT_VERSION_BRANCH_POS_KEY(c, br), 
&lower_key);
  		if (iip + 1 < le16_to_cpu(idx->child_cnt)) {
  			br = ubifs_idx_branch(c, idx, iip + 1);
-			key_read(c, &br->key, &upper_key);
+			key_read(c, FMT_VERSION_BRANCH_POS_KEY(c, br),
+				 &upper_key);
  		} else
  			key_copy(c, &i->upper_key, &upper_key);
  	}
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/debug.c linux-3.2.1-ubifsec/fs/ubifs/debug.c
--- linux-3.2.1-vanilla/fs/ubifs/debug.c	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/debug.c	2012-02-21 
22:27:01.222462655 +0100
@@ -538,7 +538,7 @@ void dbg_dump_node(const struct ubifs_in
  	case UBIFS_DATA_NODE:
  	{
  		const struct ubifs_data_node *dn = node;
-		int dlen = le32_to_cpu(ch->len) - UBIFS_DATA_NODE_SZ;
+		int dlen = le32_to_cpu(ch->len) - UBIFS_DATA_NODE_SZ(c);

  		key_read(c, &dn->key, &key);
  		printk(KERN_DEBUG "\tkey            %s\n", DBGKEY(&key));
@@ -550,7 +550,7 @@ void dbg_dump_node(const struct ubifs_in
  		       dlen);
  		printk(KERN_DEBUG "\tdata:\n");
  		print_hex_dump(KERN_DEBUG, "\t", DUMP_PREFIX_OFFSET, 32, 
1,
-			       (void *)&dn->data, dlen, 0);
+			       FMT_VERSION_DATA_NODE_POS_DATA(c, dn), 
dlen, 0);
  		break;
  	}
  	case UBIFS_TRUN_NODE:
@@ -579,7 +579,7 @@ void dbg_dump_node(const struct ubifs_in
  			const struct ubifs_branch *br;

  			br = ubifs_idx_branch(c, idx, i);
-			key_read(c, &br->key, &key);
+			key_read(c, FMT_VERSION_BRANCH_POS_KEY(c, br), 
&key);
  			printk(KERN_DEBUG "\t%d: LEB %d:%d len %d key 
%s\n",
  			       i, le32_to_cpu(br->lnum), 
le32_to_cpu(br->offs),
  			       le32_to_cpu(br->len), DBGKEY(&key));
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/file.c linux-3.2.1-ubifsec/fs/ubifs/file.c
--- linux-3.2.1-vanilla/fs/ubifs/file.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/file.c	2012-02-23 15:07:01.695957886 
+0100
@@ -77,10 +77,12 @@ static int read_block(struct inode *inod
  	if (len <= 0 || len > UBIFS_BLOCK_SIZE)
  		goto dump;

-	dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
+	dlen = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ(c);
  	out_len = UBIFS_BLOCK_SIZE;
-	err = ubifs_decompress(&dn->data, dlen, addr, &out_len,
-			       le16_to_cpu(dn->compr_type));
+	err = ubifs_decompress(FMT_VERSION_DATA_NODE_POS_DATA(c, dn), 
dlen,
+			       addr, &out_len, 
le16_to_cpu(dn->compr_type));
+	if (FMT_VERSION_DATA_NODE_HAS_CRYPTO_LOOKUP(c))
+		ubifs_assert(le64_to_cpu(dn->crypto_lookup) == 0);
  	if (err || len != out_len)
  		goto dump;

@@ -646,10 +648,13 @@ static int populate_page(struct ubifs_in
  			if (len <= 0 || len > UBIFS_BLOCK_SIZE)
  				goto out_err;

-			dlen = le32_to_cpu(dn->ch.len) - 
UBIFS_DATA_NODE_SZ;
+			dlen = le32_to_cpu(dn->ch.len) - 
UBIFS_DATA_NODE_SZ(c);
  			out_len = UBIFS_BLOCK_SIZE;
-			err = ubifs_decompress(&dn->data, dlen, addr, 
&out_len,
- 
le16_to_cpu(dn->compr_type));
+			err =
+			ubifs_decompress(
+				FMT_VERSION_DATA_NODE_POS_DATA(c, dn),
+				dlen, addr, &out_len,
+				le16_to_cpu(dn->compr_type));
  			if (err || len != out_len)
  				goto out_err;

diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/journal.c 
linux-3.2.1-ubifsec/fs/ubifs/journal.c
--- linux-3.2.1-vanilla/fs/ubifs/journal.c	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/journal.c	2012-02-23 
15:07:31.835959345 +0100
@@ -720,6 +720,8 @@ int ubifs_jnl_write_data(struct ubifs_in
  	key_write(c, key, &data->key);
  	data->size = cpu_to_le32(len);
  	zero_data_node_unused(data);
+	if (FMT_VERSION_DATA_NODE_HAS_CRYPTO_LOOKUP(c))
+		data->crypto_lookup = cpu_to_le64(0);

  	if (!(ui->flags & UBIFS_COMPR_FL))
  		/* Compression is disabled for this inode */
@@ -727,11 +729,12 @@ int ubifs_jnl_write_data(struct ubifs_in
  	else
  		compr_type = ui->compr_type;

-	out_len = dlen - UBIFS_DATA_NODE_SZ;
-	ubifs_compress(buf, len, &data->data, &out_len, &compr_type);
+	out_len = dlen - UBIFS_DATA_NODE_SZ(c);
+	ubifs_compress(buf, len, FMT_VERSION_DATA_NODE_POS_DATA(c, data),
+		       &out_len, &compr_type);
  	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);

-	dlen = UBIFS_DATA_NODE_SZ + out_len;
+	dlen = UBIFS_DATA_NODE_SZ(c) + out_len;
  	data->compr_type = cpu_to_le16(compr_type);

  	/* Make reservation before allocating sequence numbers */
@@ -1093,13 +1096,16 @@ out_free:

  /**
   * recomp_data_node - re-compress a truncated data node.
+ * @c: UBIFS file-system description object
   * @dn: data node to re-compress
   * @new_len: new length
   *
   * This function is used when an inode is truncated and the last data 
node of
   * the inode has to be re-compressed and re-written.
   */
-static int recomp_data_node(struct ubifs_data_node *dn, int *new_len)
+static int recomp_data_node(struct ubifs_info *c,
+			    struct ubifs_data_node *dn,
+			    int *new_len)
  {
  	void *buf;
  	int err, len, compr_type, out_len;
@@ -1109,17 +1115,20 @@ static int recomp_data_node(struct ubifs
  	if (!buf)
  		return -ENOMEM;

-	len = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ;
+	len = le32_to_cpu(dn->ch.len) - UBIFS_DATA_NODE_SZ(c);
  	compr_type = le16_to_cpu(dn->compr_type);
-	err = ubifs_decompress(&dn->data, len, buf, &out_len, compr_type);
+	err = ubifs_decompress(FMT_VERSION_DATA_NODE_POS_DATA(c, dn),
+			       len, buf, &out_len, compr_type);
  	if (err)
  		goto out;

-	ubifs_compress(buf, *new_len, &dn->data, &out_len, &compr_type);
+	ubifs_compress(buf, *new_len, FMT_VERSION_DATA_NODE_POS_DATA(c, 
dn),
+		       &out_len, &compr_type);
+
  	ubifs_assert(out_len <= UBIFS_BLOCK_SIZE);
  	dn->compr_type = cpu_to_le16(compr_type);
  	dn->size = cpu_to_le32(*new_len);
-	*new_len = UBIFS_DATA_NODE_SZ + out_len;
+	*new_len = UBIFS_DATA_NODE_SZ(c) + out_len;
  out:
  	kfree(buf);
  	return err;
@@ -1190,12 +1199,12 @@ int ubifs_jnl_truncate(struct ubifs_info
  				int compr_type = 
le16_to_cpu(dn->compr_type);

  				if (compr_type != UBIFS_COMPR_NONE) {
-					err = recomp_data_node(dn, &dlen);
+					err = recomp_data_node(c, dn, 
&dlen);
  					if (err)
  						goto out_free;
  				} else {
  					dn->size = cpu_to_le32(dlen);
-					dlen += UBIFS_DATA_NODE_SZ;
+					dlen += UBIFS_DATA_NODE_SZ(c);
  				}
  				zero_data_node_unused(dn);
  			}
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/misc.h linux-3.2.1-ubifsec/fs/ubifs/misc.h
--- linux-3.2.1-vanilla/fs/ubifs/misc.h	2012-02-20 19:36:00.670753551 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/misc.h	2012-02-23 15:09:47.899965933 
+0100
@@ -200,7 +200,8 @@ static inline int ubifs_return_leb(struc
   */
  static inline int ubifs_idx_node_sz(const struct ubifs_info *c, int 
child_cnt)
  {
-	return UBIFS_IDX_NODE_SZ + (UBIFS_BRANCH_SZ + c->key_len) * 
child_cnt;
+	return UBIFS_IDX_NODE_SZ
+	       + (UBIFS_BRANCH_SZ(c) + c->key_len) * child_cnt;
  }

  /**
@@ -214,8 +215,9 @@ struct ubifs_branch *ubifs_idx_branch(co
  				      const struct ubifs_idx_node *idx,
  				      int bnum)
  {
-	return (struct ubifs_branch *)((void *)idx->branches +
-				       (UBIFS_BRANCH_SZ + c->key_len) * 
bnum);
+	return (struct ubifs_branch *)
+		((void *)idx->branches + (UBIFS_BRANCH_SZ(c) + c->key_len)
+		* bnum);
  }

  /**
@@ -226,7 +228,8 @@ struct ubifs_branch *ubifs_idx_branch(co
  static inline void *ubifs_idx_key(const struct ubifs_info *c,
  				  const struct ubifs_idx_node *idx)
  {
-	return (void *)((struct ubifs_branch *)idx->branches)->key;
+	return (void *) FMT_VERSION_BRANCH_POS_KEY(
+		c, (struct ubifs_branch *)idx->branches);
  }

  /**
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/sb.c linux-3.2.1-ubifsec/fs/ubifs/sb.c
--- linux-3.2.1-vanilla/fs/ubifs/sb.c	2012-01-12 20:42:45.000000000 
+0100
+++ linux-3.2.1-ubifsec/fs/ubifs/sb.c	2012-02-22 11:39:51.480718000 
+0100
@@ -84,7 +84,7 @@ static int create_default_filesystem(str
  	int min_leb_cnt = UBIFS_MIN_LEB_CNT;
  	long long tmp64, main_bytes;
  	__le64 tmp_le64;
-
+	c->fmt_version = UBIFS_FORMAT_VERSION;
  	/* Some functions called from here depend on the @c->key_len filed 
*/
  	c->key_len = UBIFS_SK_LEN;

@@ -175,6 +175,7 @@ static int create_default_filesystem(str
  	sup->max_leb_cnt   = cpu_to_le32(c->max_leb_cnt);
  	sup->max_bud_bytes = cpu_to_le64(tmp64);
  	sup->log_lebs      = cpu_to_le32(log_lebs);
+	sup->crypto_lebs   = cpu_to_le32(0);
  	sup->lpt_lebs      = cpu_to_le32(lpt_lebs);
  	sup->orph_lebs     = cpu_to_le32(orph_lebs);
  	sup->jhead_cnt     = cpu_to_le32(DEFAULT_JHEADS_CNT);
@@ -182,6 +183,7 @@ static int create_default_filesystem(str
  	sup->lsave_cnt     = cpu_to_le32(c->lsave_cnt);
  	sup->fmt_version   = cpu_to_le32(UBIFS_FORMAT_VERSION);
  	sup->time_gran     = cpu_to_le32(DEFAULT_TIME_GRAN);
+	sup->use_ubifsec   = cpu_to_le32(0);
  	if (c->mount_opts.override_compr)
  		sup->default_compr = 
cpu_to_le16(c->mount_opts.compr_type);
  	else
@@ -279,7 +281,7 @@ static int create_default_filesystem(str
  	idx->child_cnt = cpu_to_le16(1);
  	ino_key_init(c, &key, UBIFS_ROOT_INO);
  	br = ubifs_idx_branch(c, idx, 0);
-	key_write_idx(c, &key, &br->key);
+	key_write_idx(c, &key, FMT_VERSION_BRANCH_POS_KEY(c, br));
  	br->lnum = cpu_to_le32(main_first + DEFAULT_DATA_LEB);
  	br->len  = cpu_to_le32(UBIFS_INO_NODE_SZ);
  	err = ubifs_write_node(c, idx, tmp, main_first + DEFAULT_IDX_LEB, 
0,
@@ -610,6 +612,10 @@ int ubifs_read_superblock(struct ubifs_i
  	c->rp_size       = le64_to_cpu(sup->rp_size);
  	c->rp_uid        = le32_to_cpu(sup->rp_uid);
  	c->rp_gid        = le32_to_cpu(sup->rp_gid);
+	if (c->fmt_version > 4) {
+		ubifs_assert(le32_to_cpu(sup->crypto_lebs) == 0);
+		ubifs_assert(le32_to_cpu(sup->use_ubifsec) == 0);
+	}
  	sup_flags        = le32_to_cpu(sup->flags);
  	if (!c->mount_opts.override_compr)
  		c->default_compr = le16_to_cpu(sup->default_compr);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/super.c linux-3.2.1-ubifsec/fs/ubifs/super.c
--- linux-3.2.1-vanilla/fs/ubifs/super.c	2012-02-20 
19:36:03.478753687 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/super.c	2012-02-21 
22:20:04.478442495 +0100
@@ -585,13 +585,14 @@ static int init_constants_early(struct u
  	c->ranges[UBIFS_DENT_NODE].max_len = UBIFS_MAX_DENT_NODE_SZ;
  	c->ranges[UBIFS_XENT_NODE].min_len = UBIFS_XENT_NODE_SZ;
  	c->ranges[UBIFS_XENT_NODE].max_len = UBIFS_MAX_XENT_NODE_SZ;
-	c->ranges[UBIFS_DATA_NODE].min_len = UBIFS_DATA_NODE_SZ;
+	c->ranges[UBIFS_DATA_NODE].min_len = UBIFS_DATA_NODE_VMIN_SZ;
  	c->ranges[UBIFS_DATA_NODE].max_len = UBIFS_MAX_DATA_NODE_SZ;
  	/*
  	 * Minimum indexing node size is amended later when superblock is
  	 * read and the key length is known.
  	 */
-	c->ranges[UBIFS_IDX_NODE].min_len = UBIFS_IDX_NODE_SZ + 
UBIFS_BRANCH_SZ;
+	c->ranges[UBIFS_IDX_NODE].min_len = UBIFS_IDX_NODE_SZ +
+					    UBIFS_BRANCH_SZ(c);
  	/*
  	 * Maximum indexing node size is amended later when superblock is
  	 * read and the fanout is known.
@@ -1463,7 +1464,7 @@ static int mount_ubifs(struct ubifs_info
  	dbg_msg("max. znode size      %d", c->max_znode_sz);
  	dbg_msg("max. index node size %d", c->max_idx_node_sz);
  	dbg_msg("node sizes:          data %zu, inode %zu, dentry %zu",
-		UBIFS_DATA_NODE_SZ, UBIFS_INO_NODE_SZ, 
UBIFS_DENT_NODE_SZ);
+		UBIFS_DATA_NODE_SZ(c), UBIFS_INO_NODE_SZ, 
UBIFS_DENT_NODE_SZ);
  	dbg_msg("node sizes:          trun %zu, sb %zu, master %zu",
  		UBIFS_TRUN_NODE_SZ, UBIFS_SB_NODE_SZ, UBIFS_MST_NODE_SZ);
  	dbg_msg("node sizes:          ref %zu, cmt. start %zu, orph %zu",
@@ -2213,7 +2214,8 @@ static int __init ubifs_init(void)
  	BUILD_BUG_ON(UBIFS_INO_NODE_SZ  & 7);
  	BUILD_BUG_ON(UBIFS_DENT_NODE_SZ & 7);
  	BUILD_BUG_ON(UBIFS_XENT_NODE_SZ & 7);
-	BUILD_BUG_ON(UBIFS_DATA_NODE_SZ & 7);
+	BUILD_BUG_ON(UBIFS_DATA_NODE_V4_SZ & 7);
+	BUILD_BUG_ON(UBIFS_DATA_NODE_V5_SZ & 7);
  	BUILD_BUG_ON(UBIFS_TRUN_NODE_SZ & 7);
  	BUILD_BUG_ON(UBIFS_SB_NODE_SZ   & 7);
  	BUILD_BUG_ON(UBIFS_MST_NODE_SZ  & 7);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/tnc_commit.c 
linux-3.2.1-ubifsec/fs/ubifs/tnc_commit.c
--- linux-3.2.1-vanilla/fs/ubifs/tnc_commit.c	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/tnc_commit.c	2012-02-23 
15:09:27.295964938 +0100
@@ -48,9 +48,13 @@ static int make_idx_node(struct ubifs_in
  		struct ubifs_branch *br = ubifs_idx_branch(c, idx, i);
  		struct ubifs_zbranch *zbr = &znode->zbranch[i];

-		key_write_idx(c, &zbr->key, &br->key);
+		key_write_idx(c, &zbr->key, FMT_VERSION_BRANCH_POS_KEY(c, 
br));
  		br->lnum = cpu_to_le32(zbr->lnum);
  		br->offs = cpu_to_le32(zbr->offs);
+		if (key_type(c, &zbr->key) == UBIFS_DATA_KEY) {
+			if (FMT_VERSION_BRANCH_HAS_CRYPTO_LOOKUP(c))
+				br->crypto_lookup = cpu_to_le64(0);
+		}
  		br->len = cpu_to_le32(zbr->len);
  		if (!zbr->lnum || !zbr->len) {
  			ubifs_err("bad ref in znode");
@@ -858,7 +862,12 @@ static int write_index(struct ubifs_info
  			struct ubifs_branch *br = ubifs_idx_branch(c, idx, 
i);
  			struct ubifs_zbranch *zbr = &znode->zbranch[i];

-			key_write_idx(c, &zbr->key, &br->key);
+			key_write_idx(c, &zbr->key,
+				      FMT_VERSION_BRANCH_POS_KEY(c, br));
+			if (key_type(c, &zbr->key) == UBIFS_DATA_KEY) {
+				if 
(FMT_VERSION_BRANCH_HAS_CRYPTO_LOOKUP(c))
+					br->crypto_lookup = 
cpu_to_le64(0);
+			}
  			br->lnum = cpu_to_le32(zbr->lnum);
  			br->offs = cpu_to_le32(zbr->offs);
  			br->len = cpu_to_le32(zbr->len);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/tnc_misc.c 
linux-3.2.1-ubifsec/fs/ubifs/tnc_misc.c
--- linux-3.2.1-vanilla/fs/ubifs/tnc_misc.c	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/tnc_misc.c	2012-02-21 
13:13:01.775280827 +0100
@@ -305,7 +305,7 @@ static int read_znode(struct ubifs_info
  		const struct ubifs_branch *br = ubifs_idx_branch(c, idx, 
i);
  		struct ubifs_zbranch *zbr = &znode->zbranch[i];

-		key_read(c, &br->key, &zbr->key);
+		key_read(c, FMT_VERSION_BRANCH_POS_KEY(c, br), &zbr->key);
  		zbr->lnum = le32_to_cpu(br->lnum);
  		zbr->offs = le32_to_cpu(br->offs);
  		zbr->len  = le32_to_cpu(br->len);
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/ubifs.h linux-3.2.1-ubifsec/fs/ubifs/ubifs.h
--- linux-3.2.1-vanilla/fs/ubifs/ubifs.h	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/ubifs.h	2012-02-21 
22:07:55.582407209 +0100
@@ -73,7 +73,7 @@
  #define MIN_INDEX_LEBS 2

  /* Minimum amount of data UBIFS writes to the flash */
-#define MIN_WRITE_SZ (UBIFS_DATA_NODE_SZ + 8)
+#define MIN_WRITE_SZ (UBIFS_DATA_NODE_VMIN_SZ + 8)

  /*
   * Currently we do not support inode number overlapping and re-using, so 
this
@@ -155,7 +155,7 @@
   * How much memory is needed for a buffer where we comress a data node.
   */
  #define COMPRESSED_DATA_NODE_BUF_SZ \
-	(UBIFS_DATA_NODE_SZ + UBIFS_BLOCK_SIZE * WORST_COMPR_FACTOR)
+	(UBIFS_DATA_NODE_VMAX_SZ + UBIFS_BLOCK_SIZE * WORST_COMPR_FACTOR)

  /* Maximum expected tree height for use by bottom_up_buf */
  #define BOTTOM_UP_HEIGHT 64
diff -uprN -X linux-3.2.1-vanilla/Documentation/dontdiff 
linux-3.2.1-vanilla/fs/ubifs/ubifs-media.h 
linux-3.2.1-ubifsec/fs/ubifs/ubifs-media.h
--- linux-3.2.1-vanilla/fs/ubifs/ubifs-media.h	2012-01-12 
20:42:45.000000000 +0100
+++ linux-3.2.1-ubifsec/fs/ubifs/ubifs-media.h	2012-02-23 
15:12:45.971974550 +0100
@@ -44,9 +44,23 @@
   * a new feature.
   *
   * UBIFS went into mainline kernel with format version 4. The older 
formats
- * were development formats.
- */
-#define UBIFS_FORMAT_VERSION 4
+ * were development formats.  Version 5 is then used for secure deletion
+ * enhancement. N.B.: when adding new versions that also have this field,
+ * include the version in the data_struct_has_field defines below.
+ */
+#define UBIFS_FORMAT_VERSION 5
+#define FMT_VERSION_BRANCH_HAS_CRYPTO_LOOKUP(c) ((c)->fmt_version == 5)
+#define FMT_VERSION_DATA_NODE_HAS_CRYPTO_LOOKUP(c) ((c)->fmt_version == 
5)
+#define FMT_VERSION_DATA_NODE_POS_DATA(c, dn)				\
+	(FMT_VERSION_DATA_NODE_HAS_CRYPTO_LOOKUP(c) ?			\
+	((void *) (&((dn)->__data))) :					\
+	((void *) (&((dn)->crypto_lookup))))
+
+#define FMT_VERSION_BRANCH_POS_KEY(c, br)				\
+	(FMT_VERSION_BRANCH_HAS_CRYPTO_LOOKUP(c) ?			\
+	((void *) (&((br)->__key))) :					\
+	((void *) (&((br)->crypto_lookup))))
+

  /*
   * Read-only compatibility version. If the UBIFS format is changed, older 
UBIFS
@@ -274,25 +288,33 @@ enum {
  			   UBIFS_MIN_ORPH_LEBS + UBIFS_MIN_MAIN_LEBS)

  /* Node sizes (N.B. these are guaranteed to be multiples of 8) */
-#define UBIFS_CH_SZ        sizeof(struct ubifs_ch)
-#define UBIFS_INO_NODE_SZ  sizeof(struct ubifs_ino_node)
-#define UBIFS_DATA_NODE_SZ sizeof(struct ubifs_data_node)
-#define UBIFS_DENT_NODE_SZ sizeof(struct ubifs_dent_node)
-#define UBIFS_TRUN_NODE_SZ sizeof(struct ubifs_trun_node)
-#define UBIFS_PAD_NODE_SZ  sizeof(struct ubifs_pad_node)
-#define UBIFS_SB_NODE_SZ   sizeof(struct ubifs_sb_node)
-#define UBIFS_MST_NODE_SZ  sizeof(struct ubifs_mst_node)
-#define UBIFS_REF_NODE_SZ  sizeof(struct ubifs_ref_node)
-#define UBIFS_IDX_NODE_SZ  sizeof(struct ubifs_idx_node)
-#define UBIFS_CS_NODE_SZ   sizeof(struct ubifs_cs_node)
-#define UBIFS_ORPH_NODE_SZ sizeof(struct ubifs_orph_node)
+#define UBIFS_CH_SZ            sizeof(struct ubifs_ch)
+#define UBIFS_INO_NODE_SZ      sizeof(struct ubifs_ino_node)
+#define UBIFS_DATA_NODE_SZ(c)   (sizeof(struct ubifs_data_node) \
+	- (FMT_VERSION_BRANCH_HAS_CRYPTO_LOOKUP(c) ? 0 : sizeof(__u64)))
+/* The min and max data node header size across all version */
+#define UBIFS_DATA_NODE_V4_SZ (sizeof(struct ubifs_data_node) - 
sizeof(__u64))
+#define UBIFS_DATA_NODE_V5_SZ (sizeof(struct ubifs_data_node))
+#define UBIFS_DATA_NODE_VMIN_SZ UBIFS_DATA_NODE_V4_SZ
+#define UBIFS_DATA_NODE_VMAX_SZ UBIFS_DATA_NODE_V5_SZ
+
+#define UBIFS_DENT_NODE_SZ     sizeof(struct ubifs_dent_node)
+#define UBIFS_TRUN_NODE_SZ     sizeof(struct ubifs_trun_node)
+#define UBIFS_PAD_NODE_SZ      sizeof(struct ubifs_pad_node)
+#define UBIFS_SB_NODE_SZ       sizeof(struct ubifs_sb_node)
+#define UBIFS_MST_NODE_SZ      sizeof(struct ubifs_mst_node)
+#define UBIFS_REF_NODE_SZ      sizeof(struct ubifs_ref_node)
+#define UBIFS_IDX_NODE_SZ      sizeof(struct ubifs_idx_node)
+#define UBIFS_CS_NODE_SZ       sizeof(struct ubifs_cs_node)
+#define UBIFS_ORPH_NODE_SZ     sizeof(struct ubifs_orph_node)
  /* Extended attribute entry nodes are identical to directory entry nodes 
*/
  #define UBIFS_XENT_NODE_SZ UBIFS_DENT_NODE_SZ
  /* Only this does not have to be multiple of 8 bytes */
-#define UBIFS_BRANCH_SZ    sizeof(struct ubifs_branch)
+#define UBIFS_BRANCH_SZ(c)    (sizeof(struct ubifs_branch)  \
+	- (FMT_VERSION_BRANCH_HAS_CRYPTO_LOOKUP(c) ? 0 : sizeof(__u64)))

  /* Maximum node sizes (N.B. these are guaranteed to be multiples of 8) */
-#define UBIFS_MAX_DATA_NODE_SZ  (UBIFS_DATA_NODE_SZ + UBIFS_BLOCK_SIZE)
+#define UBIFS_MAX_DATA_NODE_SZ  (UBIFS_DATA_NODE_VMAX_SZ + 
UBIFS_BLOCK_SIZE)
  #define UBIFS_MAX_INO_NODE_SZ   (UBIFS_INO_NODE_SZ + UBIFS_MAX_INO_DATA)
  #define UBIFS_MAX_DENT_NODE_SZ  (UBIFS_DENT_NODE_SZ + UBIFS_MAX_NLEN + 1)
  #define UBIFS_MAX_XENT_NODE_SZ  UBIFS_MAX_DENT_NODE_SZ
@@ -549,6 +571,18 @@ struct ubifs_dent_node {
   *
   * Note, do not forget to amend 'zero_data_node_unused()' function when
   * changing the padding fields.
+ *
+ * This data structure format is version 5, which includes the 
@crypto_lookup
+ * field. Since @data is unbounded, the new field must be before it.
+ * Compatibility macros:
+ * FMT_VERSION_DATA_NODE_POS_DATA: returns a pointer to the appropriate 
place
+ *				   where the key begins for the current
+ *				   mounted version.
+ * FMT_VERSION_DATA_NODE_HAS_CRYPTO_LOOKUP: true if the current mounted
+ *					    version contains the
+ *					    @crypto_lookup field.
+ * UBIFS_DATA_NODE_SZ: now returns the appropriate size for this data 
structure
+ *		       depending on the version.
   */
  struct ubifs_data_node {
  	struct ubifs_ch ch;
@@ -556,7 +590,8 @@ struct ubifs_data_node {
  	__le32 size;
  	__le16 compr_type;
  	__u8 padding[2]; /* Watch 'zero_data_node_unused()' if changing! 
*/
-	__u8 data[];
+	__u64 crypto_lookup;
+	__u8 __data[];
  } __packed;

  /**
@@ -614,10 +649,12 @@ struct ubifs_pad_node {
   * @rp_uid: reserve pool UID
   * @rp_gid: reserve pool GID
   * @rp_size: size of the reserved pool in bytes
- * @padding2: reserved for future, zeroes
   * @time_gran: time granularity in nanoseconds
   * @uuid: UUID generated when the file system image was created
   * @ro_compat_version: UBIFS R/O compatibility version
+ * @crypto_lebs: number of LEBS being used to store keys
+ * @use_ubifsec: whether the file system should use ubifsec secure 
deletion
+ * @padding2: reserved for future, zeroes
   */
  struct ubifs_sb_node {
  	struct ubifs_ch ch;
@@ -645,7 +682,9 @@ struct ubifs_sb_node {
  	__le32 time_gran;
  	__u8 uuid[16];
  	__le32 ro_compat_version;
-	__u8 padding2[3968];
+	__le32 crypto_lebs;
+	__u8 use_ubifsec;
+	__u8 padding2[3963];
  } __packed;

  /**
@@ -736,13 +775,25 @@ struct ubifs_ref_node {
   * @lnum: LEB number of the target node
   * @offs: offset within @lnum
   * @len: target node length
- * @key: key
+ * @__key: key.
+ *
+ * This data structure format is version 5, which includes the 
crypto_lookup
+ * field. Since key is unbounded, the new field must be before it.
+ * Compatibility macros:
+ * FMT_VERSION_BRANCH_POS_KEY: returns a pointer to the appropriate place
+ *			       where the key begins for the current 
mounted
+ *			       version.
+ * FMT_VERSION_BRANCH_HAS_CRYPTO_LOOKUP: true if the current mounted 
version
+ *					 contains the crypto_lookup field.
+ * UBIFS_BRANCH_SZ: now returns the appropriate size for this data 
structure
+ *		    depending on the version.
   */
  struct ubifs_branch {
  	__le32 lnum;
  	__le32 offs;
  	__le32 len;
-	__u8 key[];
+	__le64 crypto_lookup;
+	__u8 __key[];
  } __packed;

  /**
@@ -750,7 +801,7 @@ struct ubifs_branch {
   * @ch: common header
   * @child_cnt: number of child index nodes
   * @level: tree level
- * @branches: LEB number / offset / length / key branches
+ * @branches: LEB number / offset / length / crypto_lookup / key branches
   */
  struct ubifs_idx_node {
  	struct ubifs_ch ch;

