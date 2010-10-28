Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575Ab0J1Vci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933834Ab0J1VcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:32:13 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 06/20] fsnotify: call fsnotify_parent in perm events
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:32:09 -0400
Message-ID: <20101028213209.24810.39879.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify perm events do not call fsnotify parent.  That means you cannot
register a perm event on a directory and enforce permissions on all inodes in
that directory.  This patch fixes that situation.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c             |   15 +++++++++------
 include/linux/fsnotify.h         |    9 +++++++--
 include/linux/fsnotify_backend.h |    8 +++++---
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 57ecadd..20dc218 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -84,16 +84,17 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 }
 
 /* Notify this dentry's parent about a child's events. */
-void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
+int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 {
 	struct dentry *parent;
 	struct inode *p_inode;
+	int ret = 0;
 
 	if (!dentry)
 		dentry = path->dentry;
 
 	if (!(dentry->d_flags & DCACHE_FSNOTIFY_PARENT_WATCHED))
-		return;
+		return 0;
 
 	parent = dget_parent(dentry);
 	p_inode = parent->d_inode;
@@ -106,14 +107,16 @@ void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 		mask |= FS_EVENT_ON_CHILD;
 
 		if (path)
-			fsnotify(p_inode, mask, path, FSNOTIFY_EVENT_PATH,
-				 dentry->d_name.name, 0);
+			ret = fsnotify(p_inode, mask, path, FSNOTIFY_EVENT_PATH,
+				       dentry->d_name.name, 0);
 		else
-			fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
-				 dentry->d_name.name, 0);
+			ret = fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
+				       dentry->d_name.name, 0);
 	}
 
 	dput(parent);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(__fsnotify_parent);
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 59d0df4..5059faa 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -26,12 +26,12 @@ static inline void fsnotify_d_instantiate(struct dentry *dentry,
 }
 
 /* Notify this dentry's parent about a child's events. */
-static inline void fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
+static inline int fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 {
 	if (!dentry)
 		dentry = path->dentry;
 
-	__fsnotify_parent(path, dentry, mask);
+	return __fsnotify_parent(path, dentry, mask);
 }
 
 /* simple call site for access decisions */
@@ -40,6 +40,7 @@ static inline int fsnotify_perm(struct file *file, int mask)
 	struct path *path = &file->f_path;
 	struct inode *inode = path->dentry->d_inode;
 	__u32 fsnotify_mask = 0;
+	int ret;
 
 	if (file->f_mode & FMODE_NONOTIFY)
 		return 0;
@@ -52,6 +53,10 @@ static inline int fsnotify_perm(struct file *file, int mask)
 	else
 		BUG();
 
+	ret = fsnotify_parent(path, NULL, fsnotify_mask);
+	if (ret)
+		return ret;
+
 	return fsnotify(inode, fsnotify_mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 0268921..b37f3a7 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -304,7 +304,7 @@ struct fsnotify_mark {
 /* main fsnotify call to send events */
 extern int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 		    const unsigned char *name, u32 cookie);
-extern void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask);
+extern int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask);
 extern void __fsnotify_inode_delete(struct inode *inode);
 extern void __fsnotify_vfsmount_delete(struct vfsmount *mnt);
 extern u32 fsnotify_get_cookie(void);
@@ -433,8 +433,10 @@ static inline int fsnotify(struct inode *to_tell, __u32 mask, void *data, int da
 	return 0;
 }
 
-static inline void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
-{}
+static inline int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
+{
+	return 0;
+}
 
 static inline void __fsnotify_inode_delete(struct inode *inode)
 {}

