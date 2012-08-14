Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2HNOGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:06:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62509 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2HNOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:06:27 -0400
Message-Id: <20120814140620.285660958@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Aug 2012 18:03:48 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 6/8] fs, exportfs: Add export_encode_inode_fh helper
References: <20120814140342.354405844@openvz.org>
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
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
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
  * @inode:   the object to encode
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

