Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2KMU2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:28:32 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:45258 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2KMU1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:27:49 -0500
Message-Id: <20121113202739.241400152@openvz.org>
User-Agent: quilt/0.48-1
Date: Wed, 14 Nov 2012 00:20:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Subject: [patch 6/7] fs, notify: Add file handle entry into inotify_inode_mark v2
References: <20121113202023.748833257@openvz.org>
Content-Disposition: inline; filename=fsnotify-add-fhandler-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file handle will be provided as auxiliay information
associated with the file descriptor in /proc/pid/fdinfo/fd
output.

The file handle is needed in a sake of C/R becasue it
provides back to a userspace information sufficient for
opening the target file on restore procedure.

As a minimum size of the file handle storage the 64 bytes
chosen since it's the value the nfs3 is uses at moment.
Still, if there no room left in a buffer carried with the
mark, we yield a warning but don't fail, because the inotify
system doesn't depend on file handle at all and can
continue working without problems.

The reason for this patch is that on restore we need to
reconstruct the path to the watched target and use
inotify_add_watch() syscall then.

This feature is CONFIG_CHECKPOINT_RESTORE only.

v2:
 - shrink the buffer down to 64 bytes
 - declare fhandle as a structure and align it
 - don't fail to add a watch descriptor if buffer
   is too small to carry the fhandle

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
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
CC: David Rientjes <rientjes@google.com>
---
 fs/notify/inotify/inotify.h      |   11 +++++++++
 fs/notify/inotify/inotify_user.c |   46 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 5 deletions(-)

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
 
@@ -9,9 +10,19 @@ struct inotify_event_private_data {
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
+	struct {
+		struct file_handle handle;
+		u8 pad[64];
+	} __aligned(8) fh;
+#endif
 };
 
 extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
Index: linux-2.6.git/fs/notify/inotify/inotify_user.c
===================================================================
--- linux-2.6.git.orig/fs/notify/inotify/inotify_user.c
+++ linux-2.6.git/fs/notify/inotify/inotify_user.c
@@ -566,6 +566,37 @@ static void inotify_free_mark(struct fsn
 	kmem_cache_free(inotify_inode_mark_cachep, i_mark);
 }
 
+#ifdef INOTIFY_USE_FHANDLE
+static int inotify_encode_wd_fhandle(struct inotify_inode_mark *mark, struct dentry *dentry)
+{
+	struct file_handle *fhandle = &mark->fh.handle;
+	int size, ret;
+
+	fhandle->handle_bytes = sizeof(mark->fh.pad);
+	size = fhandle->handle_bytes >> 2;
+
+	ret = exportfs_encode_fh(dentry, (struct fid *)fhandle->f_handle, &size,  0);
+	if ((ret == 255) || (ret == -ENOSPC)) {
+
+		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
+
+		fhandle->handle_type = -1;
+		fhandle->handle_bytes = 0;
+		return 0;
+	}
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
@@ -621,10 +652,11 @@ static int inotify_update_existing_watch
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
@@ -647,6 +679,10 @@ static int inotify_new_watch(struct fsno
 	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
 		goto out_err;
 
+	ret = inotify_encode_wd_fhandle(tmp_i_mark, dentry);
+	if (ret)
+		goto out_err;
+
 	ret = inotify_add_to_idr(idr, idr_lock, &group->inotify_data.last_wd,
 				 tmp_i_mark);
 	if (ret)
@@ -673,16 +709,16 @@ out_err:
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
@@ -785,7 +821,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	group = f.file->private_data;
 
 	/* create/update an inode mark */
-	ret = inotify_update_watch(group, inode, mask);
+	ret = inotify_update_watch(group, path.dentry, mask);
 	path_put(&path);
 fput_and_out:
 	fdput(f);

