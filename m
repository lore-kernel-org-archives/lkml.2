Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0HZSfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:35:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58046 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab0HZSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:35:40 -0400
Message-Id: <20100826183503.586646860@szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Thu, 26 Aug 2010 20:33:43 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org
Subject: [PATCH 3/5] vfs: add flag to allow rename to same inode
Content-Disposition: inline; filename=vfs-fs_rename_self_allow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Hybrid union filesystem uses dummy inodes for non-directories.  Allow
rename to work in this case despite the inode being the same.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c         |    4 +++-
 include/linux/fs.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-08-25 14:19:34.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-08-25 14:19:53.000000000 +0200
@@ -179,6 +179,7 @@ struct inodes_stat_t {
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
 					 */
+#define FS_RENAME_SELF_ALLOW	65536	/* Allow rename to same inode */
 
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-08-25 10:19:53.000000000 +0200
+++ linux-2.6/fs/namei.c	2010-08-25 14:22:56.000000000 +0200
@@ -2620,8 +2620,10 @@ int vfs_rename(struct inode *old_dir, st
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
 	const unsigned char *old_name;
 
-	if (old_dentry->d_inode == new_dentry->d_inode)
+	if (old_dentry->d_inode == new_dentry->d_inode &&
+	    !(old_dir->i_sb->s_type->fs_flags & FS_RENAME_SELF_ALLOW)) {
  		return 0;
+	}
  
 	error = may_delete(old_dir, old_dentry, is_dir);
 	if (error)

-- 
