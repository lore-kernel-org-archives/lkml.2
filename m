Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2ILVgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:36:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59327 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2ILVfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:35:14 -0400
Message-Id: <20120912213507.434915102@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Sep 2012 01:29:09 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 3/7] fs, notify: Add file handle entry into inotify_inode_mark
References: <20120912212906.407242774@openvz.org>
Content-Disposition: inline; filename=fsnotify-add-fhandler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file handle will be used in /proc/pid/fdinfo/fd
output, which in turn will allow to restore a watch
target after checkpoint.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/notify/inotify/inotify.h      |    8 +++++++
 fs/notify/inotify/inotify_user.c |   42 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 5 deletions(-)

Index: linux-2.6.git/fs/notify/inotify/inotify.h
===================================================================
--- linux-2.6.git.orig/fs/notify/inotify/inotify.h
+++ linux-2.6.git/fs/notify/inotify/inotify.h
@@ -1,6 +1,7 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/inotify.h>
 #include <linux/slab.h> /* struct kmem_cache */
+#include <linux/exportfs.h>
 
 extern struct kmem_cache *event_priv_cachep;
 
@@ -9,9 +10,16 @@ struct inotify_event_private_data {
 	int wd;
 };
 
+#if defined(CONFIG_PROC_FS) && defined(CONFIG_EXPORTFS) && defined(CONFIG_CHECKPOINT_RESTORE)
+# define INOTIFY_USE_FHANDLE
+#endif
+
 struct inotify_inode_mark {
 	struct fsnotify_mark fsn_mark;
 	int wd;
+#ifdef INOTIFY_USE_FHANDLE
+	__u8 fhandle[sizeof(struct file_handle) + MAX_HANDLE_SZ];
+#endif
 };
 
 extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
Index: linux-2.6.git/fs/notify/inotify/inotify_user.c
===================================================================
--- linux-2.6.git.orig/fs/notify/inotify/inotify_user.c
+++ linux-2.6.git/fs/notify/inotify/inotify_user.c
@@ -566,6 +566,33 @@ static void inotify_free_mark(struct fsn
 	kmem_cache_free(inotify_inode_mark_cachep, i_mark);
 }
 
+#ifdef INOTIFY_USE_FHANDLE
+static int inotify_encode_wd_fhandle(struct inotify_inode_mark *mark, struct dentry *dentry)
+{
+	struct file_handle *fhandle = (struct file_handle *)mark->fhandle;
+	int size, ret;
+
+	BUILD_BUG_ON(sizeof(mark->fhandle) <= sizeof(struct file_handle));
+
+	fhandle->handle_bytes = sizeof(mark->fhandle) - sizeof(struct file_handle);
+	size = fhandle->handle_bytes >> 2;
+
+	ret = exportfs_encode_fh(dentry, (struct fid *)fhandle->f_handle, &size,  0);
+	if ((ret == 255) || (ret == -ENOSPC))
+		return -EOVERFLOW;
+
+	fhandle->handle_type = ret;
+	fhandle->handle_bytes = size * sizeof(u32);
+
+	return 0;
+}
+# else
+static int inotify_encode_wd_fhandle(struct inotify_inode_mark *mark, struct dentry *dentry)
+{
+	return 0;
+}
+#endif
+
 static int inotify_update_existing_watch(struct fsnotify_group *group,
 					 struct inode *inode,
 					 u32 arg)
@@ -621,10 +648,11 @@ static int inotify_update_existing_watch
 }
 
 static int inotify_new_watch(struct fsnotify_group *group,
-			     struct inode *inode,
+			     struct dentry *dentry,
 			     u32 arg)
 {
 	struct inotify_inode_mark *tmp_i_mark;
+	struct inode *inode = dentry->d_inode;
 	__u32 mask;
 	int ret;
 	struct idr *idr = &group->inotify_data.idr;
@@ -647,6 +675,10 @@ static int inotify_new_watch(struct fsno
 	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
 		goto out_err;
 
+	ret = inotify_encode_wd_fhandle(tmp_i_mark, dentry);
+	if (ret)
+		goto out_err;
+
 	ret = inotify_add_to_idr(idr, idr_lock, &group->inotify_data.last_wd,
 				 tmp_i_mark);
 	if (ret)
@@ -673,16 +705,16 @@ out_err:
 	return ret;
 }
 
-static int inotify_update_watch(struct fsnotify_group *group, struct inode *inode, u32 arg)
+static int inotify_update_watch(struct fsnotify_group *group, struct dentry *dentry, u32 arg)
 {
 	int ret = 0;
 
 retry:
 	/* try to update and existing watch with the new arg */
-	ret = inotify_update_existing_watch(group, inode, arg);
+	ret = inotify_update_existing_watch(group, dentry->d_inode, arg);
 	/* no mark present, try to add a new one */
 	if (ret == -ENOENT)
-		ret = inotify_new_watch(group, inode, arg);
+		ret = inotify_new_watch(group, dentry, arg);
 	/*
 	 * inotify_new_watch could race with another thread which did an
 	 * inotify_new_watch between the update_existing and the add watch
@@ -785,7 +817,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	group = filp->private_data;
 
 	/* create/update an inode mark */
-	ret = inotify_update_watch(group, inode, mask);
+	ret = inotify_update_watch(group, path.dentry, mask);
 	path_put(&path);
 fput_and_out:
 	fput_light(filp, fput_needed);

