Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2HOPtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:49:43 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50392 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab2HOPr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:26 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz,
        Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 06/13] overlayfs: implement show_options
Date: Wed, 15 Aug 2012 17:48:13 +0200
Message-Id: <1345045700-9062-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@fsl.cs.sunysb.edu>

This is useful because of the stacking nature of overlayfs.  Users like to
find out (via /proc/mounts) which lower/upper directory were used at mount
time.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/super.c |   63 ++++++++++++++++++++++++++++++++++----------------
 1 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 484753b..69a2099 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,17 +17,27 @@
 #include <linux/module.h>
 #include <linux/cred.h>
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Overlay filesystem");
 MODULE_LICENSE("GPL");
 
+struct ovl_config {
+	char *lowerdir;
+	char *upperdir;
+};
+
+/* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	struct vfsmount *lower_mnt;
+	/* pathnames of lower and upper dirs, for show_options */
+	struct ovl_config config;
 };
 
+/* private information held for every overlayfs dentry */
 struct ovl_entry {
 	/*
 	 * Keep "double reference" on upper dentries, so that
@@ -384,6 +394,8 @@ static void ovl_put_super(struct super_block *sb)
 	mntput(ufs->upper_mnt);
 	mntput(ufs->lower_mnt);
 
+	kfree(ufs->config.lowerdir);
+	kfree(ufs->config.upperdir);
 	kfree(ufs);
 }
 
@@ -425,15 +437,27 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return path.dentry->d_sb->s_op->statfs(path.dentry, buf);
 }
 
+/**
+ * ovl_show_options
+ *
+ * Prints the mount options for a given superblock.
+ * Returns zero; does not fail.
+ */
+static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct ovl_fs *ufs = sb->s_fs_info;
+
+	seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
+	seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
+	return 0;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.remount_fs	= ovl_remount_fs,
 	.statfs		= ovl_statfs,
-};
-
-struct ovl_config {
-	char *lowerdir;
-	char *upperdir;
+	.show_options	= ovl_show_options,
 };
 
 enum {
@@ -493,33 +517,32 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	struct dentry *root_dentry;
 	struct ovl_entry *oe;
 	struct ovl_fs *ufs;
-	struct ovl_config config;
 	int err;
 
-	err = ovl_parse_opt((char *) data, &config);
-	if (err)
+	err = -ENOMEM;
+	ufs = kmalloc(sizeof(struct ovl_fs), GFP_KERNEL);
+	if (!ufs)
 		goto out;
 
+	err = ovl_parse_opt((char *) data, &ufs->config);
+	if (err)
+		goto out_free_ufs;
+
 	err = -EINVAL;
-	if (!config.upperdir || !config.lowerdir) {
+	if (!ufs->config.upperdir || !ufs->config.lowerdir) {
 		printk(KERN_ERR "overlayfs: missing upperdir or lowerdir\n");
 		goto out_free_config;
 	}
 
-	err = -ENOMEM;
-	ufs = kmalloc(sizeof(struct ovl_fs), GFP_KERNEL);
-	if (!ufs)
-		goto out_free_config;
-
 	oe = ovl_alloc_entry();
 	if (oe == NULL)
-		goto out_free_ufs;
+		goto out_free_config;
 
-	err = kern_path(config.upperdir, LOOKUP_FOLLOW, &upperpath);
+	err = kern_path(ufs->config.upperdir, LOOKUP_FOLLOW, &upperpath);
 	if (err)
 		goto out_free_oe;
 
-	err = kern_path(config.lowerdir, LOOKUP_FOLLOW, &lowerpath);
+	err = kern_path(ufs->config.lowerdir, LOOKUP_FOLLOW, &lowerpath);
 	if (err)
 		goto out_put_upperpath;
 
@@ -595,11 +618,11 @@ out_put_upperpath:
 	path_put(&upperpath);
 out_free_oe:
 	kfree(oe);
+out_free_config:
+	kfree(ufs->config.lowerdir);
+	kfree(ufs->config.upperdir);
 out_free_ufs:
 	kfree(ufs);
-out_free_config:
-	kfree(config.lowerdir);
-	kfree(config.upperdir);
 out:
 	return err;
 }
-- 
1.7.7

