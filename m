Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab2HUNkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:40:16 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40877 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976Ab2HUNkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:40:09 -0400
Date: Tue, 21 Aug 2012 17:40:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120821134004.GF7670@moon>
References: <20120820190606.GE27443@moon>
 <20120820193204.GD5779@fieldses.org>
 <50335261.5090504@parallels.com>
 <87wr0sle4v.fsf@skywalker.in.ibm.com>
 <503367CB.9080609@parallels.com>
 <20120821105424.GA7670@moon>
 <50336C51.60501@parallels.com>
 <20120821121155.GC9483@fieldses.org>
 <50337D87.90607@parallels.com>
 <20120821122908.GE9483@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821122908.GE9483@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 08:29:08AM -0400, J. Bruce Fields wrote:
> > Initial problem -- we don't know what is being watched by an inotify fd.
> > 
> > Having a dentry somewhere was the 1st attempt to solve this -- keep a path
> > in inotify and show it when required. It doesn't work since holding a ref on
> > path changes the behavior of watched inode (we cannot rename/unlink/remount
> > it the same way as we could before patching the kernel).
> 
> OK.  So if you don't mind the fact that there are filesystems with
> inotify support but not filehandle support, then I think generating a
> filehandle early as you describe would work.  I guess it's a little more
> memory per watched inode.

So, I thought about something like below, any comments?
---
 fs/notify/inotify/inotify.h      |    8 +++++++
 fs/notify/inotify/inotify_user.c |   41 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 5 deletions(-)

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
@@ -566,6 +566,32 @@ static void inotify_free_mark(struct fsn
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
@@ -621,10 +647,11 @@ static int inotify_update_existing_watch
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
@@ -647,6 +674,10 @@ static int inotify_new_watch(struct fsno
 	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
 		goto out_err;
 
+	ret = inotify_encode_wd_fhandle(tmp_i_mark, dentry);
+	if (ret)
+		goto out_err;
+
 	ret = inotify_add_to_idr(idr, idr_lock, &group->inotify_data.last_wd,
 				 tmp_i_mark);
 	if (ret)
@@ -673,16 +704,16 @@ out_err:
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
@@ -785,7 +816,7 @@ SYSCALL_DEFINE3(inotify_add_watch, int,
 	group = filp->private_data;
 
 	/* create/update an inode mark */
-	ret = inotify_update_watch(group, inode, mask);
+	ret = inotify_update_watch(group, path.dentry, mask);
 	path_put(&path);
 fput_and_out:
 	fput_light(filp, fput_needed);
