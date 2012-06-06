Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2FFSwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:52:32 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:35231
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1757120Ab2FFSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:52:30 -0400
Date: Wed, 6 Jun 2012 20:52:28 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] UBIFS: compute KSA size and store in superblock
In-Reply-To: <alpine.DEB.2.00.1206061202370.28118@eristoteles.iwoars.net>
Message-ID: <alpine.DEB.2.00.1206062052140.31834@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205251509220.2989@eristoteles.iwoars.net>  <1337952271.30969.37.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1205301531220.6465@eristoteles.iwoars.net>  <1338391121.2536.94.camel@sauron.fi.intel.com> 
 <alpine.DEB.2.00.1205311211340.15137@eristoteles.iwoars.net>  <1338459575.2536.120.camel@sauron.fi.intel.com> <1338460565.2536.126.camel@sauron.fi.intel.com> <alpine.DEB.2.00.1206061202370.28118@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the super block reserve space for the KSA. It computes the
number of KSA LEBs and adds the ksa_lebs to on-medium superblock. The value is
read off the media. The decision to use a KSA is controlled by use_ubifsec
switch, added as a flag to the superblock, ubifs_info, and is controlled as a mount
option. Validate superblock also checks these values.

This is tested by creating a drive and checking the mount debug output. The
number of LEBS assigned during create_default_filesystem was changed to ensure
that remounting does infact read the old value. When the use_ubifsec option
was not enabled, no LEBs were assigned. Integck was run and the drive was
filled to capacity. The LEBs in the KSA were not used when filled. Invalid
value for ksa_lebs were used and then rejected by validate superblock.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/sb.c          |   54 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/ubifs/super.c       |   15 +++++++++++++
 fs/ubifs/ubifs-media.h |    8 +++++-
 fs/ubifs/ubifs.h       |   23 +++++++++++++++++++-
 4 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index f98d284..c1665ca 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -82,6 +82,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	int err, tmp, jnl_lebs, log_lebs, max_buds, main_lebs, main_first;
 	int lpt_lebs, lpt_first, orph_lebs, big_lpt, ino_waste, sup_flags = 0;
 	int min_leb_cnt = UBIFS_MIN_LEB_CNT;
+	int ksa_lebs = 0, ksa_first;
 	long long tmp64, main_bytes;
 	__le64 tmp_le64;

@@ -103,6 +104,20 @@ static int create_default_filesystem(struct ubifs_info *c)
 	if (jnl_lebs * c->leb_size > DEFAULT_MAX_JNL)
 		jnl_lebs = DEFAULT_MAX_JNL / c->leb_size;

+	if (c->use_ubifsec) {
+		/*
+		 * Compute the size of the key space area based on partition
+		 * geometry. The following calculation is equivalant to:
+		 * LEBS * LEB_SIZE / DATANODE_SIZE / KEYS_PER_KSA_LEB, because
+		 * KEYS_PER_KSA_LEB = LEB_SIZE / KEY_SIZE.
+		 */
+		ksa_lebs = (c->leb_cnt * UBIFS_CRYPTO_KEYSIZE)
+			>> UBIFS_BLOCK_SHIFT;
+		ksa_lebs += ksa_lebs >> UBIFS_KSA_LEBS_SCALE_SHIFT;
+		ksa_lebs += UBIFS_KSA_ADD_LEBS;
+		min_leb_cnt += ksa_lebs;
+	}
+
 	/*
 	 * The log should be large enough to fit reference nodes for all bud
 	 * LEBs. Because buds do not have to start from the beginning of LEBs
@@ -138,7 +153,8 @@ static int create_default_filesystem(struct ubifs_info *c)
 		 */
 		orph_lebs += 1;

-	main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS - log_lebs;
+	main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS
+		    - log_lebs - ksa_lebs;
 	main_lebs -= orph_lebs;

 	lpt_first = UBIFS_LOG_LNUM + log_lebs;
@@ -153,6 +169,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 		lpt_first + lpt_lebs - 1);

 	main_first = c->leb_cnt - main_lebs;
+	ksa_first = c->leb_cnt - main_lebs - ksa_lebs;

 	/* Create default superblock */
 	tmp = ALIGN(UBIFS_SB_NODE_SZ, c->min_io_size);
@@ -163,6 +180,8 @@ static int create_default_filesystem(struct ubifs_info *c)
 	tmp64 = (long long)max_buds * c->leb_size;
 	if (big_lpt)
 		sup_flags |= UBIFS_FLG_BIGLPT;
+	if (c->use_ubifsec)
+		sup_flags |= UBIFS_FLG_UBFSEC;

 	sup->ch.node_type  = UBIFS_SB_NODE;
 	sup->key_hash      = UBIFS_KEY_HASH_R5;
@@ -173,6 +192,7 @@ static int create_default_filesystem(struct ubifs_info *c)
 	sup->max_leb_cnt   = cpu_to_le32(c->max_leb_cnt);
 	sup->max_bud_bytes = cpu_to_le64(tmp64);
 	sup->log_lebs      = cpu_to_le32(log_lebs);
+	sup->ksa_lebs	   = cpu_to_le32(ksa_lebs);
 	sup->lpt_lebs      = cpu_to_le32(lpt_lebs);
 	sup->orph_lebs     = cpu_to_le32(orph_lebs);
 	sup->jhead_cnt     = cpu_to_le32(DEFAULT_JHEADS_CNT);
@@ -351,6 +371,8 @@ static int validate_sb(struct ubifs_info *c, struct ubifs_sb_node *sup)
 {
 	long long max_bytes;
 	int err = 1, min_leb_cnt;
+	int max_ksa_leb_cnt;
+	int min_ksa_leb_cnt;

 	if (!c->key_hash) {
 		err = 2;
@@ -389,6 +411,7 @@ static int validate_sb(struct ubifs_info *c, struct ubifs_sb_node *sup)
 	 */
 	min_leb_cnt = UBIFS_SB_LEBS + UBIFS_MST_LEBS + c->log_lebs;
 	min_leb_cnt += c->lpt_lebs + c->orph_lebs + c->jhead_cnt + 6;
+	min_leb_cnt += c->ksa_lebs;

 	if (c->leb_cnt < min_leb_cnt || c->leb_cnt > c->vi.size) {
 		ubifs_err("bad LEB count: %d in superblock, %d on UBI volume, "
@@ -444,7 +467,7 @@ static int validate_sb(struct ubifs_info *c, struct ubifs_sb_node *sup)
 	}

 	if (UBIFS_SB_LEBS + UBIFS_MST_LEBS + c->log_lebs + c->lpt_lebs +
-	    c->orph_lebs + c->main_lebs != c->leb_cnt) {
+	    c->orph_lebs + c->main_lebs + c->ksa_lebs != c->leb_cnt) {
 		err = 12;
 		goto failed;
 	}
@@ -465,6 +488,25 @@ static int validate_sb(struct ubifs_info *c, struct ubifs_sb_node *sup)
 		goto failed;
 	}

+	min_ksa_leb_cnt = (c->leb_cnt * UBIFS_CRYPTO_KEYSIZE)
+			  >> UBIFS_BLOCK_SHIFT;
+	max_ksa_leb_cnt = min_ksa_leb_cnt << 1;
+	min_ksa_leb_cnt += UBIFS_KSA_ADD_LEBS;
+	max_ksa_leb_cnt += UBIFS_KSA_ADD_LEBS;
+	if (c->use_ubifsec && c->ksa_lebs < min_ksa_leb_cnt) {
+		err = 16;
+		goto failed;
+	}
+
+	if (c->use_ubifsec && c->ksa_lebs > max_ksa_leb_cnt) {
+		err = 17;
+		goto failed;
+	}
+
+	if (!c->use_ubifsec && c->ksa_lebs != 0) {
+		err = 18;
+		goto failed;
+	}
 	return 0;

 failed:
@@ -605,6 +647,7 @@ int ubifs_read_superblock(struct ubifs_info *c)
 	c->max_leb_cnt   = le32_to_cpu(sup->max_leb_cnt);
 	c->max_bud_bytes = le64_to_cpu(sup->max_bud_bytes);
 	c->log_lebs      = le32_to_cpu(sup->log_lebs);
+	c->ksa_lebs	 = le32_to_cpu(sup->ksa_lebs);
 	c->lpt_lebs      = le32_to_cpu(sup->lpt_lebs);
 	c->orph_lebs     = le32_to_cpu(sup->orph_lebs);
 	c->jhead_cnt     = le32_to_cpu(sup->jhead_cnt) + NONDATA_JHEADS_CNT;
@@ -616,11 +659,11 @@ int ubifs_read_superblock(struct ubifs_info *c)
 	sup_flags        = le32_to_cpu(sup->flags);
 	if (!c->mount_opts.override_compr)
 		c->default_compr = le16_to_cpu(sup->default_compr);
-
 	c->vfs_sb->s_time_gran = le32_to_cpu(sup->time_gran);
 	memcpy(&c->uuid, &sup->uuid, 16);
 	c->big_lpt = !!(sup_flags & UBIFS_FLG_BIGLPT);
 	c->space_fixup = !!(sup_flags & UBIFS_FLG_SPACE_FIXUP);
+	c->use_ubifsec = !!(sup_flags & UBIFS_FLG_UBFSEC);

 	/* Automatically increase file system size to the maximum size */
 	c->old_leb_cnt = c->leb_cnt;
@@ -646,8 +689,11 @@ int ubifs_read_superblock(struct ubifs_info *c)
 	c->lpt_last = c->lpt_first + c->lpt_lebs - 1;
 	c->orph_first = c->lpt_last + 1;
 	c->orph_last = c->orph_first + c->orph_lebs - 1;
-	c->main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS;
+	c->main_lebs = c->leb_cnt - UBIFS_SB_LEBS - UBIFS_MST_LEBS
+		       - c->ksa_lebs;
 	c->main_lebs -= c->log_lebs + c->lpt_lebs + c->orph_lebs;
+	c->ksa_first = c->leb_cnt - c->main_lebs - c->ksa_lebs;
+	c->ksa_last = c->ksa_first + c->ksa_lebs - 1;
 	c->main_first = c->leb_cnt - c->main_lebs;

 	err = validate_sb(c, sup);
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index d2fd76f..879ecf5 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -438,6 +438,8 @@ static int ubifs_show_options(struct seq_file *s, struct dentry *root)
 	else if (c->mount_opts.chk_data_crc == 1)
 		seq_printf(s, ",no_chk_data_crc");

+	if (c->mount_opts.use_ubifsec)
+		seq_printf(s, ",use_ubifsec");
 	if (c->mount_opts.override_compr) {
 		seq_printf(s, ",compr=%s",
 			   ubifs_compr_name(c->mount_opts.compr_type));
@@ -934,6 +936,7 @@ static int check_volume_empty(struct ubifs_info *c)
  * Opt_chk_data_crc: check CRCs when reading data nodes
  * Opt_no_chk_data_crc: do not check CRCs when reading data nodes
  * Opt_override_compr: override default compressor
+ * Opt_use_ubifsec: use ubifsec secure deletion feature
  * Opt_err: just end of array marker
  */
 enum {
@@ -944,6 +947,7 @@ enum {
 	Opt_chk_data_crc,
 	Opt_no_chk_data_crc,
 	Opt_override_compr,
+	Opt_use_ubifsec,
 	Opt_err,
 };

@@ -955,6 +959,7 @@ static const match_table_t tokens = {
 	{Opt_chk_data_crc, "chk_data_crc"},
 	{Opt_no_chk_data_crc, "no_chk_data_crc"},
 	{Opt_override_compr, "compr=%s"},
+	{Opt_use_ubifsec, "use_ubifsec"},
 	{Opt_err, NULL},
 };

@@ -1054,6 +1059,12 @@ static int ubifs_parse_options(struct ubifs_info *c, char *options,
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
@@ -1446,6 +1457,9 @@ static int mount_ubifs(struct ubifs_info *c)
 		c->lpt_lebs, c->lpt_first, c->lpt_last);
 	dbg_msg("orphan area LEBs:    %d (%d - %d)",
 		c->orph_lebs, c->orph_first, c->orph_last);
+	if (c->ksa_lebs)
+		dbg_msg("KSA LEBs:            %d (%d - %d)",
+			c->ksa_lebs, c->ksa_first, c->ksa_last);
 	dbg_msg("main area LEBs:      %d (%d - %d)",
 		c->main_lebs, c->main_first, c->leb_cnt - 1);
 	dbg_msg("index LEBs:          %d", c->lst.idx_lebs);
@@ -1483,6 +1497,7 @@ static int mount_ubifs(struct ubifs_info *c)
 		c->bud_bytes, c->bud_bytes >> 10, c->bud_bytes >> 20);
 	dbg_msg("max. seq. number:    %llu", c->max_sqnum);
 	dbg_msg("commit number:       %llu", c->cmt_no);
+	dbg_msg("use ubifsec:         %d", c->use_ubifsec);

 	return 0;

diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index 90f348c..556567b 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -402,10 +402,12 @@ enum {
  *
  * UBIFS_FLG_BIGLPT: if "big" LPT model is used if set
  * UBIFS_FLG_SPACE_FIXUP: first-mount "fixup" of free space within LEBs needed
+ * UBIFS_FLG_UBFSEC: use ubifs secure deletion enhancement
  */
 enum {
 	UBIFS_FLG_BIGLPT = 0x02,
 	UBIFS_FLG_SPACE_FIXUP = 0x04,
+	UBIFS_FLG_UBFSEC = 0x08,
 };

 /**
@@ -618,10 +620,11 @@ struct ubifs_pad_node {
  * @rp_uid: reserve pool UID
  * @rp_gid: reserve pool GID
  * @rp_size: size of the reserved pool in bytes
- * @padding2: reserved for future, zeroes
  * @time_gran: time granularity in nanoseconds
  * @uuid: UUID generated when the file system image was created
  * @ro_compat_version: UBIFS R/O compatibility version
+ * @crypto_lebs: number of LEBS being used to store keys
+ * @padding2: reserved for future, zeroes
  */
 struct ubifs_sb_node {
 	struct ubifs_ch ch;
@@ -649,7 +652,8 @@ struct ubifs_sb_node {
 	__le32 time_gran;
 	__u8 uuid[16];
 	__le32 ro_compat_version;
-	__u8 padding2[3968];
+	__le32 ksa_lebs;
+	__u8 padding2[3964];
 } __packed;

 /**
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index d7f639a..f34ab84 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -164,6 +164,16 @@
 #define UBIFS_CRYPTO_KEYSIZE 16
 /* AES in counter mode is the encryption algorithm */
 #define UBIFS_CRYPTO_ALGORITHM "ctr(aes)"
+/*
+ * Constant number of KSA LEBS to add to computed value, ensuring two plus a
+ * checkpoint LEB.
+ */
+#define UBIFS_KSA_ADD_LEBS 3
+/*
+ * KSA LEBS is 1.125 * the computed min to allow unused keys when the drive is
+ * full. This shift is used to compute 0.125 * LEBS.
+ */
+#define UBIFS_KSA_LEBS_SCALE_SHIFT 3

 /*
  * Lockdep classes for UBIFS inode @ui_mutex.
@@ -934,6 +944,7 @@ struct ubifs_orphan {
  *                  specified in @compr_type)
  * @compr_type: compressor type to override the superblock compressor with
  *              (%UBIFS_COMPR_NONE, etc)
+ * @use_ubifsec: use ubifsec secure deletion feature
  */
 struct ubifs_mount_opts {
 	unsigned int unmount_mode:2;
@@ -941,6 +952,7 @@ struct ubifs_mount_opts {
 	unsigned int chk_data_crc:2;
 	unsigned int override_compr:1;
 	unsigned int compr_type:2;
+	unsigned int use_ubifsec:1;
 };

 /**
@@ -1224,7 +1236,11 @@ struct ubifs_debug_info;
  * @size_tree: inode size information for recovery
  * @mount_opts: UBIFS-specific mount options
  *
- * @keymap: cryptographic key store for secure deletion
+ * @km: cryptographic key store for secure deletion
+ * @ksa_lebs: number of LEBS assigned to the KSA
+ * @ksa_first: number of the first LEB assigned to the KSA
+ * @ksa_last: number of the last LEB assigned to the KSA
+ * @use_ubifsec: switch to enable/disable secure deletion for UBIFS
  * @dbg: debugging-related information
  */
 struct ubifs_info {
@@ -1454,6 +1470,11 @@ struct ubifs_info {
 	struct ubifs_mount_opts mount_opts;

 	struct ubifs_keymap *km;
+	int ksa_lebs;
+	int ksa_first;
+	int ksa_last;
+	int use_ubifsec;
+
 	struct ubifs_debug_info *dbg;
 };

-- 
1.7.5.4


