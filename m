Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1JQBPV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:15:21 -0400
Received: from lunge.queued.net ([173.255.254.236]:33985 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab1JQBPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:15:20 -0400
Date: Sun, 16 Oct 2011 18:15:16 -0700
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [PATCH v2 1/2] jffs2: implement mount option parsing and
 compression overriding
Message-ID: <20111016181516.489cbbf9@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently jffs2 has compile-time constants (and .config options)
controlling whether or not the various compression/decompression
drivers are built in and enabled.  This is fine for embedded
systems, but it clashes with distribution kernels.  Distro kernels
tend to turn on everything; this causes OpenFirmware to fall
over, as it understands ZLIB-compressed inodes.  Booting a kernel
that has LZO compression enabled, writing to the boot partition,
and then rebooting causes OFW to fail to read the kernel from
the filesystem.  This is because LZO compression has priority
when writing new data to jffs2, if LZO is enabled.

This patch adds mount option parsing, and a single supported
option ("compr=none").  This adds the flexibility of being
able to specify which compressor overrides on a per-superblock
basis.  For now, we can simply disable compression;
additional flexibility coming soon.

v2: kill some printks, and implement show_options as suggested
by Artem Bityutskiy.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 fs/jffs2/compr.c       |    9 +++-
 fs/jffs2/fs.c          |    2 +-
 fs/jffs2/jffs2_fs_sb.h |    6 +++
 fs/jffs2/os-linux.h    |    2 +-
 fs/jffs2/super.c       |   97 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index de42470..97bc74d 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -76,13 +76,18 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 			uint32_t *datalen, uint32_t *cdatalen)
 {
 	int ret = JFFS2_COMPR_NONE;
-	int compr_ret;
+	int mode, compr_ret;
 	struct jffs2_compressor *this, *best=NULL;
 	unsigned char *output_buf = NULL, *tmp_buf;
 	uint32_t orig_slen, orig_dlen;
 	uint32_t best_slen=0, best_dlen=0;
 
-	switch (jffs2_compression_mode) {
+	if (c->mount_opts.override_compr)
+		mode = c->mount_opts.compr;
+	else
+		mode = jffs2_compression_mode;
+
+	switch (mode) {
 	case JFFS2_COMPR_MODE_NONE:
 		break;
 	case JFFS2_COMPR_MODE_PRIORITY:
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index bbcb975..5d54b4e 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -379,7 +379,7 @@ void jffs2_dirty_inode(struct inode *inode, int flags)
 	jffs2_do_setattr(inode, &iattr);
 }
 
-int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
+int jffs2_do_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
diff --git a/fs/jffs2/jffs2_fs_sb.h b/fs/jffs2/jffs2_fs_sb.h
index 0bc6a6c..55a0c1d 100644
--- a/fs/jffs2/jffs2_fs_sb.h
+++ b/fs/jffs2/jffs2_fs_sb.h
@@ -29,6 +29,11 @@
 
 struct jffs2_inodirty;
 
+struct jffs2_mount_opts {
+	bool override_compr;
+	unsigned int compr;
+};
+
 /* A struct for the overall file system control.  Pointers to
    jffs2_sb_info structs are named `c' in the source code.
    Nee jffs_control
@@ -126,6 +131,7 @@ struct jffs2_sb_info {
 #endif
 
 	struct jffs2_summary *summary;		/* Summary information */
+	struct jffs2_mount_opts mount_opts;
 
 #ifdef CONFIG_JFFS2_FS_XATTR
 #define XATTRINDEX_HASHSIZE	(57)
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 6c1755c..ab65ee3 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -176,7 +176,7 @@ void jffs2_dirty_inode(struct inode *inode, int flags);
 struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode,
 			       struct jffs2_raw_inode *ri);
 int jffs2_statfs (struct dentry *, struct kstatfs *);
-int jffs2_remount_fs (struct super_block *, int *, char *);
+int jffs2_do_remount_fs(struct super_block *, int *, char *);
 int jffs2_do_fill_super(struct super_block *sb, void *data, int silent);
 void jffs2_gc_release_inode(struct jffs2_sb_info *c,
 			    struct jffs2_inode_info *f);
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 853b8e3..40f6e63 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -17,11 +17,13 @@
 #include <linux/fs.h>
 #include <linux/err.h>
 #include <linux/mount.h>
+#include <linux/parser.h>
 #include <linux/jffs2.h>
 #include <linux/pagemap.h>
 #include <linux/mtd/super.h>
 #include <linux/ctype.h>
 #include <linux/namei.h>
+#include <linux/seq_file.h>
 #include <linux/exportfs.h>
 #include "compr.h"
 #include "nodelist.h"
@@ -75,6 +77,29 @@ static void jffs2_write_super(struct super_block *sb)
 	unlock_super(sb);
 }
 
+static const char *jffs2_compr_name(unsigned int compr)
+{
+	switch (compr) {
+	case JFFS2_COMPR_MODE_NONE:
+		return "none";
+	default:
+		/* should never happen; programmer error */
+		WARN_ON(1);
+		return "";
+	}
+}
+
+static int jffs2_show_options(struct seq_file *s, struct vfsmount *mnt)
+{
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(mnt->mnt_sb);
+	struct jffs2_mount_opts *opts = &c->mount_opts;
+
+	if (opts->override_compr)
+		seq_printf(s, ",compr=%s", jffs2_compr_name(opts->compr));
+
+	return 0;
+}
+
 static int jffs2_sync_fs(struct super_block *sb, int wait)
 {
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
@@ -133,6 +158,71 @@ static const struct export_operations jffs2_export_ops = {
 	.fh_to_parent = jffs2_fh_to_parent,
 };
 
+/*
+ * JFFS2 mount options.
+ *
+ * Opt_override_compr: override default compressor
+ * Opt_err: just end of array marker
+ */
+enum {
+	Opt_override_compr,
+	Opt_err,
+};
+
+static const match_table_t tokens = {
+	{Opt_override_compr, "compr=%s"},
+	{Opt_err, NULL},
+};
+
+static int jffs2_parse_options(struct jffs2_sb_info *c, char *data)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *p, *name;
+
+	if (!data)
+		return 0;
+
+	while ((p = strsep(&data, ","))) {
+		int token;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_override_compr:
+			name = match_strdup(&args[0]);
+
+			if (!name)
+				return -ENOMEM;
+			if (!strcmp(name, "none")) {
+				c->mount_opts.compr = JFFS2_COMPR_MODE_NONE;
+				c->mount_opts.override_compr = true;
+			}
+			kfree(name);
+			break;
+		default:
+			printk(KERN_ERR "JFFS2 Error: unrecognized mount option '%s' or missing value\n",
+					p);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int jffs2_remount_fs(struct super_block *sb, int *flags, char *data)
+{
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
+	int err;
+
+	err = jffs2_parse_options(c, data);
+	if (err)
+		return -EINVAL;
+
+	return jffs2_do_remount_fs(sb, flags, data);
+}
+
 static const struct super_operations jffs2_super_operations =
 {
 	.alloc_inode =	jffs2_alloc_inode,
@@ -143,6 +233,7 @@ static const struct super_operations jffs2_super_operations =
 	.remount_fs =	jffs2_remount_fs,
 	.evict_inode =	jffs2_evict_inode,
 	.dirty_inode =	jffs2_dirty_inode,
+	.show_options =	jffs2_show_options,
 	.sync_fs =	jffs2_sync_fs,
 };
 
@@ -166,6 +257,12 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 	c->os_priv = sb;
 	sb->s_fs_info = c;
 
+	ret = jffs2_parse_options(c, data);
+	if (ret) {
+		kfree(c);
+		return -EINVAL;
+	}
+
 	/* Initialize JFFS2 superblock locks, the further initialization will
 	 * be done later */
 	mutex_init(&c->alloc_sem);
-- 
1.7.2.5

