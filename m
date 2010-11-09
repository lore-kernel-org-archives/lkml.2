Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0KIQzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:55:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52239 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753824Ab0KIQzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:55:47 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/vObQN5BDvReZWGfPyMxSY2as5WcH+bBe2+MPG8n
	+fmuROB+yGXl8N
From: Alexey Fisher <bug-track@fisher-privat.net>
To: <linux-kernel@vger.kernel.org>
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH 2/2] Unify rest of FAT messages.
Date: Tue,  9 Nov 2010 17:55:18 +0100
Message-Id: <1289321718-6373-3-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is how it looks like after patch.

[50334.635174] FAT-fs (loop0): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[50334.635178]
[50334.635606] FAT-fs (loop0): Invalid FSINFO signature: 0x00000000, 0x00000000 (sector = 1)
[50334.635666] FAT-fs (loop0): Mounted. Opts: iocharset=utf8
[50342.129047] FAT-fs (loop0): error, invalid access to FAT (entry 0x9e90a346)
[50342.129306] FAT-fs (loop0): error, invalid access to FAT (entry 0xa35ced48)

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
---
 fs/fat/dir.c    |    9 ++++---
 fs/fat/fat.h    |    2 +
 fs/fat/fatent.c |    4 +-
 fs/fat/inode.c  |   68 +++++++++++++++++++++++++++---------------------------
 fs/fat/misc.c   |   14 +++++------
 5 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index ee42b9e..4d1d9e3 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -98,7 +98,7 @@ next:
 
 	*bh = sb_bread(sb, phys);
 	if (*bh == NULL) {
-		printk(KERN_ERR "FAT: Directory bread(block %llu) failed\n",
+		fat_msg(sb, KERN_ERR, "Directory bread(block %llu) failed",
 		       (llu)phys);
 		/* skip this block */
 		*pos = (iblock + 1) << sb->s_blocksize_bits;
@@ -979,6 +979,7 @@ static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
 
 int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 {
+	struct super_block *sb = dir->i_sb;
 	struct msdos_dir_entry *de;
 	struct buffer_head *bh;
 	int err = 0, nr_slots;
@@ -1013,8 +1014,8 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 		 */
 		err = __fat_remove_entries(dir, sinfo->slot_off, nr_slots);
 		if (err) {
-			printk(KERN_WARNING
-			       "FAT: Couldn't remove the long name slots\n");
+			fat_msg(sb, KERN_WARNING,
+			       "Couldn't remove the long name slots");
 		}
 	}
 
@@ -1265,7 +1266,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 		if (sbi->fat_bits != 32)
 			goto error;
 	} else if (MSDOS_I(dir)->i_start == 0) {
-		printk(KERN_ERR "FAT: Corrupted directory (i_pos %lld)\n",
+		fat_msg(sb, KERN_ERR, "Corrupted directory (i_pos %lld)",
 		       MSDOS_I(dir)->i_pos);
 		err = -EIO;
 		goto error;
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index d75a77f..e945916 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -345,4 +345,6 @@ void fat_cache_destroy(void);
 /* helper for printk */
 typedef unsigned long long	llu;
 
+void fat_msg(struct super_block *sb, const char *prefix, const char *fmt, ...);
+
 #endif /* !_FAT_H */
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index b47d2c9..2e81ac0 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -95,7 +95,7 @@ static int fat12_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 err_brelse:
 	brelse(bhs[0]);
 err:
-	printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n", (llu)blocknr);
+	fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)", (llu)blocknr);
 	return -EIO;
 }
 
@@ -108,7 +108,7 @@ static int fat_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 	fatent->fat_inode = MSDOS_SB(sb)->fat_inode;
 	fatent->bhs[0] = sb_bread(sb, blocknr);
 	if (!fatent->bhs[0]) {
-		printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n",
+		fat_msg(sb, KERN_ERR, "FAT read failed (blocknr %llu)",
 		       (llu)blocknr);
 		return -EIO;
 	}
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 4699173..6e08a48 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -629,8 +629,8 @@ retry:
 
 	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
 	if (!bh) {
-		printk(KERN_ERR "FAT: unable to read inode block "
-		       "for updating (i_pos %lld)\n", i_pos);
+		fat_msg(sb, KERN_ERR, "unable to read inode block "
+		       "for updating (i_pos %lld)", i_pos);
 		return -EIO;
 	}
 	spin_lock(&sbi->inode_hash_lock);
@@ -990,8 +990,8 @@ static const match_table_t vfat_tokens = {
 	{Opt_err, NULL}
 };
 
-static int parse_options(char *options, int is_vfat, int silent, int *debug,
-			 struct fat_mount_options *opts)
+static int parse_options(struct super_block *sb, char *options, int is_vfat,
+			 int silent, int *debug, struct fat_mount_options *opts)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -1182,15 +1182,15 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 
 		/* obsolete mount options */
 		case Opt_obsolate:
-			printk(KERN_INFO "FAT: \"%s\" option is obsolete, "
-			       "not supported now\n", p);
+			fat_msg(sb, KERN_INFO, "\"%s\" option is obsolete, "
+			       "not supported now", p);
 			break;
 		/* unknown option */
 		default:
 			if (!silent) {
-				printk(KERN_ERR
-				       "FAT: Unrecognized mount option \"%s\" "
-				       "or missing value\n", p);
+				fat_msg(sb, KERN_ERR,
+				       "Unrecognized mount option \"%s\" "
+				       "or missing value", p);
 			}
 			return -EINVAL;
 		}
@@ -1199,7 +1199,7 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 out:
 	/* UTF-8 doesn't provide FAT semantics */
 	if (!strcmp(opts->iocharset, "utf8")) {
-		printk(KERN_ERR "FAT: utf8 is not a recommended IO charset"
+		fat_msg(sb, KERN_ERR, "utf8 is not a recommended IO charset"
 		       " for FAT filesystems, filesystem will be "
 		       "case sensitive!\n");
 	}
@@ -1286,7 +1286,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	ratelimit_state_init(&sbi->ratelimit, DEFAULT_RATELIMIT_INTERVAL,
 			     DEFAULT_RATELIMIT_BURST);
 
-	error = parse_options(data, isvfat, silent, &debug, &sbi->options);
+	error = parse_options(sb, data, isvfat, silent, &debug, &sbi->options);
 	if (error)
 		goto out_fail;
 
@@ -1294,20 +1294,21 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sb_min_blocksize(sb, 512);
 	bh = sb_bread(sb, 0);
 	if (bh == NULL) {
-		printk(KERN_ERR "FAT: unable to read boot sector\n");
+		fat_msg(sb, KERN_ERR, "unable to read boot sector");
 		goto out_fail;
 	}
 
 	b = (struct fat_boot_sector *) bh->b_data;
 	if (!b->reserved) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus number of reserved sectors\n");
+			fat_msg(sb,
+				KERN_ERR, "bogus number of reserved sectors");
 		brelse(bh);
 		goto out_invalid;
 	}
 	if (!b->fats) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus number of FAT structure\n");
+			fat_msg(sb, KERN_ERR, "bogus number of FAT structure");
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1320,7 +1321,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	media = b->media;
 	if (!fat_valid_media(media)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: invalid media value (0x%02x)\n",
+			fat_msg(sb, KERN_ERR, "invalid media value (0x%02x)",
 			       media);
 		brelse(bh);
 		goto out_invalid;
@@ -1330,7 +1331,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	    || (logical_sector_size < 512)
 	    || (logical_sector_size > 4096)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus logical sector size %u\n",
+			fat_msg(sb, KERN_ERR, "bogus logical sector size %u",
 			       logical_sector_size);
 		brelse(bh);
 		goto out_invalid;
@@ -1338,15 +1339,15 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sbi->sec_per_clus = b->sec_per_clus;
 	if (!is_power_of_2(sbi->sec_per_clus)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus sectors per cluster %u\n",
+			fat_msg(sb, KERN_ERR, "bogus sectors per cluster %u",
 			       sbi->sec_per_clus);
 		brelse(bh);
 		goto out_invalid;
 	}
 
 	if (logical_sector_size < sb->s_blocksize) {
-		printk(KERN_ERR "FAT: logical sector size too small for device"
-		       " (logical sector size = %u)\n", logical_sector_size);
+		fat_msg(sb, KERN_ERR, "logical sector size too small for device"
+		       " (logical sector size = %u)", logical_sector_size);
 		brelse(bh);
 		goto out_fail;
 	}
@@ -1354,14 +1355,14 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, logical_sector_size)) {
-			printk(KERN_ERR "FAT: unable to set blocksize %u\n",
+			fat_msg(sb, KERN_ERR, "unable to set blocksize %u",
 			       logical_sector_size);
 			goto out_fail;
 		}
 		bh = sb_bread(sb, 0);
 		if (bh == NULL) {
-			printk(KERN_ERR "FAT: unable to read boot sector"
-			       " (logical sector size = %lu)\n",
+			fat_msg(sb, KERN_ERR, "unable to read boot sector"
+			       " (logical sector size = %lu)",
 			       sb->s_blocksize);
 			goto out_fail;
 		}
@@ -1397,16 +1398,16 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 
 		fsinfo_bh = sb_bread(sb, sbi->fsinfo_sector);
 		if (fsinfo_bh == NULL) {
-			printk(KERN_ERR "FAT: bread failed, FSINFO block"
-			       " (sector = %lu)\n", sbi->fsinfo_sector);
+			fat_msg(sb, KERN_ERR, "bread failed, FSINFO block"
+			       " (sector = %lu)", sbi->fsinfo_sector);
 			brelse(bh);
 			goto out_fail;
 		}
 
 		fsinfo = (struct fat_boot_fsinfo *)fsinfo_bh->b_data;
 		if (!IS_FSINFO(fsinfo)) {
-			printk(KERN_WARNING "FAT: Invalid FSINFO signature: "
-			       "0x%08x, 0x%08x (sector = %lu)\n",
+			fat_msg(sb, KERN_WARNING, "Invalid FSINFO signature: "
+			       "0x%08x, 0x%08x (sector = %lu)",
 			       le32_to_cpu(fsinfo->signature1),
 			       le32_to_cpu(fsinfo->signature2),
 			       sbi->fsinfo_sector);
@@ -1427,8 +1428,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus directroy-entries per block"
-			       " (%u)\n", sbi->dir_entries);
+			fat_msg(sb, KERN_ERR, "bogus directroy-entries per block"
+			       " (%u)", sbi->dir_entries);
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1450,7 +1451,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: count of clusters too big (%u)\n",
+			fat_msg(sb, KERN_ERR, "count of clusters too big (%u)",
 			       total_clusters);
 		brelse(bh);
 		goto out_invalid;
@@ -1483,7 +1484,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sprintf(buf, "cp%d", sbi->options.codepage);
 	sbi->nls_disk = load_nls(buf);
 	if (!sbi->nls_disk) {
-		printk(KERN_ERR "FAT: codepage %s not found\n", buf);
+		fat_msg(sb, KERN_ERR, "codepage %s not found", buf);
 		goto out_fail;
 	}
 
@@ -1491,7 +1492,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	if (sbi->options.isvfat) {
 		sbi->nls_io = load_nls(sbi->options.iocharset);
 		if (!sbi->nls_io) {
-			printk(KERN_ERR "FAT: IO charset %s not found\n",
+			fat_msg(sb, KERN_ERR, "IO charset %s not found",
 			       sbi->options.iocharset);
 			goto out_fail;
 		}
@@ -1515,7 +1516,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	insert_inode_hash(root_inode);
 	sb->s_root = d_alloc_root(root_inode);
 	if (!sb->s_root) {
-		printk(KERN_ERR "FAT: get root inode failed\n");
+		fat_msg(sb, KERN_ERR, "get root inode failed");
 		goto out_fail;
 	}
 
@@ -1527,8 +1528,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 out_invalid:
 	error = -EINVAL;
 	if (!silent)
-		printk(KERN_INFO "VFS: Can't find a valid FAT filesystem"
-		       " on dev %s.\n", sb->s_id);
+		fat_msg(sb, KERN_INFO, "Can't find a valid FAT filesystem");
 
 out_fail:
 	if (fat_inode)
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 970e682..8e043a1 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -26,9 +26,7 @@ void __fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
 	va_list args;
 
 	if (report) {
-		printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
-
-		printk(KERN_ERR "    ");
+		printk(KERN_ERR "FAT-fs (%s): error, ", s->s_id);
 		va_start(args, fmt);
 		vprintk(fmt, args);
 		va_end(args);
@@ -36,10 +34,10 @@ void __fat_fs_error(struct super_block *s, int report, const char *fmt, ...)
 	}
 
 	if (opts->errors == FAT_ERRORS_PANIC)
-		panic("FAT: fs panic from previous error\n");
+		panic("FAT-fs (%s): fs panic from previous error\n", s->s_id);
 	else if (opts->errors == FAT_ERRORS_RO && !(s->s_flags & MS_RDONLY)) {
 		s->s_flags |= MS_RDONLY;
-		printk(KERN_ERR "FAT: Filesystem has been set read-only\n");
+		fat_msg(s, KERN_ERR, "Filesystem has been set read-only");
 	}
 }
 EXPORT_SYMBOL_GPL(__fat_fs_error);
@@ -57,15 +55,15 @@ int fat_clusters_flush(struct super_block *sb)
 
 	bh = sb_bread(sb, sbi->fsinfo_sector);
 	if (bh == NULL) {
-		printk(KERN_ERR "FAT: bread failed in fat_clusters_flush\n");
+		fat_msg(sb, KERN_ERR, "bread failed in fat_clusters_flush");
 		return -EIO;
 	}
 
 	fsinfo = (struct fat_boot_fsinfo *)bh->b_data;
 	/* Sanity check */
 	if (!IS_FSINFO(fsinfo)) {
-		printk(KERN_ERR "FAT: Invalid FSINFO signature: "
-		       "0x%08x, 0x%08x (sector = %lu)\n",
+		fat_msg(sb, KERN_ERR, "Invalid FSINFO signature: "
+		       "0x%08x, 0x%08x (sector = %lu)",
 		       le32_to_cpu(fsinfo->signature1),
 		       le32_to_cpu(fsinfo->signature2),
 		       sbi->fsinfo_sector);
-- 
1.7.1

