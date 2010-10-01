Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0JARsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:48:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46893 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0JARsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:48:07 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 2/2] overlayfs: add statfs support
Date: Fri,  1 Oct 2010 18:48:02 +0100
Message-Id: <1285955282-10240-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285955282-10240-1-git-send-email-apw@canonical.com>
References: <1285955282-10240-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for statfs to the overlayfs filesystem.  As the upper layer
is the target of all write operations assume that the space in that
filesystem is the space in the overlayfs.  There will be some inaccuracy as
overwriting a file will copy it up and consume space we were not expecting,
but it is better than nothing.

Use the upper layer dentry and mount from the overlayfs root inode,
passing the statfs call to that filesystem.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/overlayfs.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index 61139fa..2bef9c1 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -1943,9 +1943,29 @@ static int ovl_remount_fs(struct super_block *sb, int *flagsp, char *data)
 		return mnt_want_write(ufs->upper_mnt);
 }
 
+/**
+ * ovl_statfs
+ * @sb: The overlayfs super block
+ * @buf: The struct kstatfs to fill in with stats
+ *
+ * Get the filesystem statistics.  As writes always target the upper layer
+ * filesystem pass the statfs to the same filesystem.
+ */
+static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct dentry *root_dentry = dentry->d_sb->s_root;
+	struct path path;
+	ovl_path_upper(root_dentry, &path);
+
+	if (!path.dentry->d_sb->s_op->statfs)
+		return -ENOSYS;
+	return path.dentry->d_sb->s_op->statfs(path.dentry, buf);
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.remount_fs	= ovl_remount_fs,
+	.statfs		= ovl_statfs,
 };
 
 struct ovl_config {
-- 
1.7.0.4

