Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab2EWKm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:42:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37773 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646Ab2EWKki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:40:38 -0400
Message-Id: <20120523104031.152885239@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 23 May 2012 14:25:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, ebiederm@xmission.com,
        tj@kernel.org, skinsbursky@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc v2 6/7] fs, exportfs: Add export_encode_inode_fh helper
References: <20120523102541.382837149@openvz.org>
Content-Disposition: inline; filename=seq-fs-exportfs-ino-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To provide fsnotify object inodes being watched without
binding to alphabetical path we need to encode them with
exportfs help. This patch adds a helper which operates
with plain inodes directly.

This feature is CONFIG_CHECKPOINT_RESTORE only.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/exportfs/expfs.c      |   21 +++++++++++++++++++++
 include/linux/exportfs.h |    4 ++++
 2 files changed, 25 insertions(+)

Index: linux-2.6.git/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.git.orig/fs/exportfs/expfs.c
+++ linux-2.6.git/fs/exportfs/expfs.c
@@ -302,6 +302,27 @@ out:
 	return error;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+int export_encode_inode_fh(struct inode *inode, struct fid *fid, int *max_len)
+{
+	int len = *max_len;
+	int type = FILEID_INO32_GEN;
+
+	if (len < 2) {
+		*max_len = 2;
+		return 255;
+	}
+
+	len = 2;
+	fid->i32.ino = inode->i_ino;
+	fid->i32.gen = inode->i_generation;
+	*max_len = len;
+
+	return type;
+}
+EXPORT_SYMBOL_GPL(export_encode_inode_fh);
+#endif
+
 /**
  * export_encode_fh - default export_operations->encode_fh function
  * @dentry:  the dentry to encode
Index: linux-2.6.git/include/linux/exportfs.h
===================================================================
--- linux-2.6.git.orig/include/linux/exportfs.h
+++ linux-2.6.git/include/linux/exportfs.h
@@ -177,6 +177,10 @@ struct export_operations {
 	int (*commit_metadata)(struct inode *inode);
 };
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+extern int export_encode_inode_fh(struct inode *inode, struct fid *fid, int *max_len);
+#endif
+
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
 	int *max_len, int connectable);
 extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,

