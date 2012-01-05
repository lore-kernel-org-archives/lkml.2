Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2AEIOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:14:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54264 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2AEIOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:14:19 -0500
Date: Thu, 5 Jan 2012 08:14:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the vfs tree
Message-ID: <20120105081418.GI23916@ZenIV.linux.org.uk>
References: <20120105173521.9adbe29e16ca0e7361f79c36@canb.auug.org.au>
 <20120105080657.GH23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105080657.GH23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 08:06:57AM +0000, Al Viro wrote:
> On Thu, Jan 05, 2012 at 05:35:21PM +1100, Stephen Rothwell wrote:
> > Hi Al,
> > 
> > After merging the vfs tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > fs/reiserfs/super.c:701:2: warning: initialization from incompatible pointer type [enabled by default]
> > fs/reiserfs/super.c:701:2: warning: (near initialization for 'reiserfs_sops.show_options') [enabled by default]
> > 
> > Caused by commit 2ddeb2a58b11 ("vfs: switch ->show_options() to struct
> > dentry *") interacting with commit f1823b7b87d1 ("reiserfs: Properly
> > display mount options in /proc/mounts") from the ext3.  This needs some
> > merge fix ... (and will probably currently cause crashes :-()
> 
> Grrr...  Same as changes in the first commit, done to the function introduced
> by the second (i.e. replace mnt->mnt_sb with dentry->d_sb).  Incidentally,
> what are reiserfs patches doing in ext3 tree, of all places?

FWIW, an updated variant of Jan's patch would be this (on top of
vfs.git#for-next; I can pull his commit there in such form):

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index d1aca1d..a945cd2 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -13,6 +13,7 @@
 #include <linux/reiserfs_fs_sb.h>
 #include <linux/reiserfs_fs_i.h>
 #include <linux/quotaops.h>
+#include <linux/seq_file.h>
 
 #define PREALLOCATION_SIZE 9
 
@@ -634,6 +635,96 @@ int reiserfs_parse_alloc_options(struct super_block *s, char *options)
 	return 0;
 }
 
+static void print_sep(struct seq_file *seq, int *first)
+{
+	if (!*first)
+		seq_puts(seq, ":");
+	else
+		*first = 0;
+}
+
+void show_alloc_options(struct seq_file *seq, struct super_block *s)
+{
+	int first = 1;
+
+	if (SB_ALLOC_OPTS(s) == ((1 << _ALLOC_skip_busy) |
+		(1 << _ALLOC_dirid_groups) | (1 << _ALLOC_packing_groups)))
+		return;
+
+	seq_puts(seq, ",alloc=");
+
+	if (TEST_OPTION(concentrating_formatted_nodes, s)) {
+		print_sep(seq, &first);
+		if (REISERFS_SB(s)->s_alloc_options.border != 10) {
+			seq_printf(seq, "concentrating_formatted_nodes=%d",
+				100 / REISERFS_SB(s)->s_alloc_options.border);
+		} else
+			seq_puts(seq, "concentrating_formatted_nodes");
+	}
+	if (TEST_OPTION(displacing_large_files, s)) {
+		print_sep(seq, &first);
+		if (REISERFS_SB(s)->s_alloc_options.large_file_size != 16) {
+			seq_printf(seq, "displacing_large_files=%lu",
+			    REISERFS_SB(s)->s_alloc_options.large_file_size);
+		} else
+			seq_puts(seq, "displacing_large_files");
+	}
+	if (TEST_OPTION(displacing_new_packing_localities, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "displacing_new_packing_localities");
+	}
+	if (TEST_OPTION(old_hashed_relocation, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "old_hashed_relocation");
+	}
+	if (TEST_OPTION(new_hashed_relocation, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "new_hashed_relocation");
+	}
+	if (TEST_OPTION(dirid_groups, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "dirid_groups");
+	}
+	if (TEST_OPTION(oid_groups, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "oid_groups");
+	}
+	if (TEST_OPTION(packing_groups, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "packing_groups");
+	}
+	if (TEST_OPTION(hashed_formatted_nodes, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "hashed_formatted_nodes");
+	}
+	if (TEST_OPTION(skip_busy, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "skip_busy");
+	}
+	if (TEST_OPTION(hundredth_slices, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "hundredth_slices");
+	}
+	if (TEST_OPTION(old_way, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "old_way");
+	}
+	if (TEST_OPTION(displace_based_on_dirid, s)) {
+		print_sep(seq, &first);
+		seq_puts(seq, "displace_based_on_dirid");
+	}
+	if (REISERFS_SB(s)->s_alloc_options.preallocmin != 0) {
+		print_sep(seq, &first);
+		seq_printf(seq, "preallocmin=%d",
+				REISERFS_SB(s)->s_alloc_options.preallocmin);
+	}
+	if (REISERFS_SB(s)->s_alloc_options.preallocsize != 17) {
+		print_sep(seq, &first);
+		seq_printf(seq, "preallocsize=%d",
+				REISERFS_SB(s)->s_alloc_options.preallocsize);
+	}
+}
+
 static inline void new_hashed_relocation(reiserfs_blocknr_hint_t * hint)
 {
 	char *hash_in;
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 1abffa4..19c454e 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -28,6 +28,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/crc32.h>
+#include <linux/seq_file.h>
 
 struct file_system_type reiserfs_fs_type;
 
@@ -61,6 +62,7 @@ static int is_any_reiserfs_magic_string(struct reiserfs_super_block *rs)
 
 static int reiserfs_remount(struct super_block *s, int *flags, char *data);
 static int reiserfs_statfs(struct dentry *dentry, struct kstatfs *buf);
+void show_alloc_options(struct seq_file *seq, struct super_block *s);
 
 static int reiserfs_sync_fs(struct super_block *s, int wait)
 {
@@ -596,6 +598,82 @@ out:
 	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
 }
 
+static int reiserfs_show_options(struct seq_file *seq, struct dentry *root)
+{
+	struct super_block *s = root->d_sb;
+	struct reiserfs_journal *journal = SB_JOURNAL(s);
+	long opts = REISERFS_SB(s)->s_mount_opt;
+
+	if (opts & (1 << REISERFS_LARGETAIL))
+		seq_puts(seq, ",tails=on");
+	else if (!(opts & (1 << REISERFS_SMALLTAIL)))
+		seq_puts(seq, ",notail");
+	/* tails=small is default so we don't show it */
+
+	if (!(opts & (1 << REISERFS_BARRIER_FLUSH)))
+		seq_puts(seq, ",barrier=none");
+	/* barrier=flush is default so we don't show it */
+
+	if (opts & (1 << REISERFS_ERROR_CONTINUE))
+		seq_puts(seq, ",errors=continue");
+	else if (opts & (1 << REISERFS_ERROR_PANIC))
+		seq_puts(seq, ",errors=panic");
+	/* errors=ro is default so we don't show it */
+
+	if (opts & (1 << REISERFS_DATA_LOG))
+		seq_puts(seq, ",data=journal");
+	else if (opts & (1 << REISERFS_DATA_WRITEBACK))
+		seq_puts(seq, ",data=writeback");
+	/* data=ordered is default so we don't show it */
+
+	if (opts & (1 << REISERFS_ATTRS))
+		seq_puts(seq, ",attrs");
+
+	if (opts & (1 << REISERFS_XATTRS_USER))
+		seq_puts(seq, ",user_xattr");
+
+	if (opts & (1 << REISERFS_EXPOSE_PRIVROOT))
+		seq_puts(seq, ",expose_privroot");
+
+	if (opts & (1 << REISERFS_POSIXACL))
+		seq_puts(seq, ",acl");
+
+	if (REISERFS_SB(s)->s_jdev)
+		seq_printf(seq, ",jdev=%s", REISERFS_SB(s)->s_jdev);
+
+	if (journal->j_max_commit_age != journal->j_default_max_commit_age)
+		seq_printf(seq, ",commit=%d", journal->j_max_commit_age);
+
+#ifdef CONFIG_QUOTA
+	if (REISERFS_SB(s)->s_qf_names[USRQUOTA])
+		seq_printf(seq, ",usrjquota=%s", REISERFS_SB(s)->s_qf_names[USRQUOTA]);
+	else if (opts & (1 << REISERFS_USRQUOTA))
+		seq_puts(seq, ",usrquota");
+	if (REISERFS_SB(s)->s_qf_names[GRPQUOTA])
+		seq_printf(seq, ",grpjquota=%s", REISERFS_SB(s)->s_qf_names[GRPQUOTA]);
+	else if (opts & (1 << REISERFS_GRPQUOTA))
+		seq_puts(seq, ",grpquota");
+	if (REISERFS_SB(s)->s_jquota_fmt) {
+		if (REISERFS_SB(s)->s_jquota_fmt == QFMT_VFS_OLD)
+			seq_puts(seq, ",jqfmt=vfsold");
+		else if (REISERFS_SB(s)->s_jquota_fmt == QFMT_VFS_V0)
+			seq_puts(seq, ",jqfmt=vfsv0");
+	}
+#endif
+
+	/* Block allocator options */
+	if (opts & (1 << REISERFS_NO_BORDER))
+		seq_puts(seq, ",block-allocator=noborder");
+	if (opts & (1 << REISERFS_NO_UNHASHED_RELOCATION))
+		seq_puts(seq, ",block-allocator=no_unhashed_relocation");
+	if (opts & (1 << REISERFS_HASHED_RELOCATION))
+		seq_puts(seq, ",block-allocator=hashed_relocation");
+	if (opts & (1 << REISERFS_TEST4))
+		seq_puts(seq, ",block-allocator=test4");
+	show_alloc_options(seq, s);
+	return 0;
+}
+
 #ifdef CONFIG_QUOTA
 static ssize_t reiserfs_quota_write(struct super_block *, int, const char *,
 				    size_t, loff_t);
@@ -616,7 +694,7 @@ static const struct super_operations reiserfs_sops = {
 	.unfreeze_fs = reiserfs_unfreeze,
 	.statfs = reiserfs_statfs,
 	.remount_fs = reiserfs_remount,
-	.show_options = generic_show_options,
+	.show_options = reiserfs_show_options,
 #ifdef CONFIG_QUOTA
 	.quota_read = reiserfs_quota_read,
 	.quota_write = reiserfs_quota_write,
@@ -914,9 +992,9 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 		{"jdev",.arg_required = 'j',.values = NULL},
 		{"nolargeio",.arg_required = 'w',.values = NULL},
 		{"commit",.arg_required = 'c',.values = NULL},
-		{"usrquota",.setmask = 1 << REISERFS_QUOTA},
-		{"grpquota",.setmask = 1 << REISERFS_QUOTA},
-		{"noquota",.clrmask = 1 << REISERFS_QUOTA},
+		{"usrquota",.setmask = 1 << REISERFS_USRQUOTA},
+		{"grpquota",.setmask = 1 << REISERFS_GRPQUOTA},
+		{"noquota",.clrmask = 1 << REISERFS_USRQUOTA | 1 << REISERFS_GRPQUOTA},
 		{"errors",.arg_required = 'e',.values = error_actions},
 		{"usrjquota",.arg_required =
 		 'u' | (1 << REISERFS_OPT_ALLOWEMPTY),.values = NULL},
@@ -1030,12 +1108,19 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 					return 0;
 				}
 				strcpy(qf_names[qtype], arg);
-				*mount_options |= 1 << REISERFS_QUOTA;
+				if (qtype == USRQUOTA)
+					*mount_options |= 1 << REISERFS_USRQUOTA;
+				else
+					*mount_options |= 1 << REISERFS_GRPQUOTA;
 			} else {
 				if (qf_names[qtype] !=
 				    REISERFS_SB(s)->s_qf_names[qtype])
 					kfree(qf_names[qtype]);
 				qf_names[qtype] = NULL;
+				if (qtype == USRQUOTA)
+					*mount_options &= ~(1 << REISERFS_USRQUOTA);
+				else
+					*mount_options &= ~(1 << REISERFS_GRPQUOTA);
 			}
 		}
 		if (c == 'f') {
@@ -1074,9 +1159,10 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 				 "journaled quota format not specified.");
 		return 0;
 	}
-	/* This checking is not precise wrt the quota type but for our purposes it is sufficient */
-	if (!(*mount_options & (1 << REISERFS_QUOTA))
-	    && sb_any_quota_loaded(s)) {
+	if ((!(*mount_options & (1 << REISERFS_USRQUOTA)) &&
+	       sb_has_quota_loaded(s, USRQUOTA)) ||
+	    (!(*mount_options & (1 << REISERFS_GRPQUOTA)) &&
+	       sb_has_quota_loaded(s, GRPQUOTA))) {
 		reiserfs_warning(s, "super-6516", "quota options must "
 				 "be present when quota is turned on.");
 		return 0;
@@ -1224,7 +1310,8 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	safe_mask |= 1 << REISERFS_ERROR_RO;
 	safe_mask |= 1 << REISERFS_ERROR_CONTINUE;
 	safe_mask |= 1 << REISERFS_ERROR_PANIC;
-	safe_mask |= 1 << REISERFS_QUOTA;
+	safe_mask |= 1 << REISERFS_USRQUOTA;
+	safe_mask |= 1 << REISERFS_GRPQUOTA;
 
 	/* Update the bitmask, taking care to keep
 	 * the bits we're not allowed to change here */
@@ -1671,6 +1758,14 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	     &commit_max_age, qf_names, &qfmt) == 0) {
 		goto error;
 	}
+	if (jdev_name && jdev_name[0]) {
+		REISERFS_SB(s)->s_jdev = kstrdup(jdev_name, GFP_KERNEL);
+		if (!REISERFS_SB(s)->s_jdev) {
+			SWARN(silent, s, "", "Cannot allocate memory for "
+				"journal device name");
+			goto error;
+		}
+	}
 #ifdef CONFIG_QUOTA
 	handle_quota_files(s, qf_names, &qfmt);
 #endif
@@ -2053,8 +2148,9 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 	int err;
 	struct inode *inode;
 	struct reiserfs_transaction_handle th;
+	int opt = type == USRQUOTA ? REISERFS_USRQUOTA : REISERFS_GRPQUOTA;
 
-	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
+	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << opt)))
 		return -EINVAL;
 
 	/* Quotafile not on the same filesystem? */
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 26be28f..2213ddc 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1759,13 +1759,14 @@ struct reiserfs_journal_header {
 					      REISERFS_QUOTA_TRANS_BLOCKS(sb)))
 
 #ifdef CONFIG_QUOTA
+#define REISERFS_QUOTA_OPTS ((1 << REISERFS_USRQUOTA) | (1 << REISERFS_GRPQUOTA))
 /* We need to update data and inode (atime) */
-#define REISERFS_QUOTA_TRANS_BLOCKS(s) (REISERFS_SB(s)->s_mount_opt & (1<<REISERFS_QUOTA) ? 2 : 0)
+#define REISERFS_QUOTA_TRANS_BLOCKS(s) (REISERFS_SB(s)->s_mount_opt & REISERFS_QUOTA_OPTS ? 2 : 0)
 /* 1 balancing, 1 bitmap, 1 data per write + stat data update */
-#define REISERFS_QUOTA_INIT_BLOCKS(s) (REISERFS_SB(s)->s_mount_opt & (1<<REISERFS_QUOTA) ? \
+#define REISERFS_QUOTA_INIT_BLOCKS(s) (REISERFS_SB(s)->s_mount_opt & REISERFS_QUOTA_OPTS ? \
 (DQUOT_INIT_ALLOC*(JOURNAL_PER_BALANCE_CNT+2)+DQUOT_INIT_REWRITE+1) : 0)
 /* same as with INIT */
-#define REISERFS_QUOTA_DEL_BLOCKS(s) (REISERFS_SB(s)->s_mount_opt & (1<<REISERFS_QUOTA) ? \
+#define REISERFS_QUOTA_DEL_BLOCKS(s) (REISERFS_SB(s)->s_mount_opt & REISERFS_QUOTA_OPTS ? \
 (DQUOT_DEL_ALLOC*(JOURNAL_PER_BALANCE_CNT+2)+DQUOT_DEL_REWRITE+1) : 0)
 #else
 #define REISERFS_QUOTA_TRANS_BLOCKS(s) 0
diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index 52c83b6..8c9e85c 100644
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -417,6 +417,7 @@ struct reiserfs_sb_info {
 	char *s_qf_names[MAXQUOTAS];
 	int s_jquota_fmt;
 #endif
+	char *s_jdev;		/* Stored jdev for mount option showing */
 #ifdef CONFIG_REISERFS_CHECK
 
 	struct tree_balance *cur_tb;	/*
@@ -482,7 +483,8 @@ enum reiserfs_mount_options {
 	REISERFS_ERROR_RO,
 	REISERFS_ERROR_CONTINUE,
 
-	REISERFS_QUOTA,		/* Some quota option specified */
+	REISERFS_USRQUOTA,	/* User quota option specified */
+	REISERFS_GRPQUOTA,	/* Group quota option specified */
 
 	REISERFS_TEST1,
 	REISERFS_TEST2,
