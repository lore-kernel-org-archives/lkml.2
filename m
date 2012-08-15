Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2HOJ1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:27:00 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60188 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab2HOJYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:24:13 -0400
Message-Id: <20120815092409.591460800@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Aug 2012 13:21:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
References: <20120815092116.700948346@openvz.org>
Content-Disposition: inline; filename=seq-fs-exportfs-ino-3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To provide fsnotify object inodes being watched without
binding to alphabetical path we need to encode them with
exportfs help. This patch adds a helper which operates
with plain inodes directly.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
---
 fs/exportfs/expfs.c      |   19 +++++++++++++++++++
 include/linux/exportfs.h |    2 ++
 2 files changed, 21 insertions(+)

Index: linux-2.6.git/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.git.orig/fs/exportfs/expfs.c
+++ linux-2.6.git/fs/exportfs/expfs.c
@@ -302,6 +302,25 @@ out:
 	return error;
 }
 
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
+
 /**
  * export_encode_fh - default export_operations->encode_fh function
  * @inode:   the object to encode
Index: linux-2.6.git/include/linux/exportfs.h
===================================================================
--- linux-2.6.git.orig/include/linux/exportfs.h
+++ linux-2.6.git/include/linux/exportfs.h
@@ -177,6 +177,8 @@ struct export_operations {
 	int (*commit_metadata)(struct inode *inode);
 };
 
+extern int export_encode_inode_fh(struct inode *inode, struct fid *fid, int *max_len);
+
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,
 	int *max_len, int connectable);
 extern struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,

