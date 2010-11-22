Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0KVAcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:32:22 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47735 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab0KVAcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=CNUAvT70BKsLHWqE24GIrnMETP4Gel+DXsF7iYpwYIQ+CObuQZau9tc8psip4ZGiom
         6+ml8hSCPK2oGweqgY8x20w/mVvWGsQ5gr9+2LyD9c2LTCePuFx6LQKVKE+BKyaYAsdy
         WT3ToSX1MaxIFg3SsxTLzqG8I9uGXTG2rD2mU=
Subject: [PATCH 3/4] fsnotify: Handle the file change ranges
To: Eric Paris <eparis@redhat.com>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        agruen@linbit.com, linux-kernel@vger.kernel.org, stefan@buettcher.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Date: Mon, 22 Nov 2010 00:33:49 +0000
Message-ID: <20101122003334.13674.14424.stgit@zaytsev.su>
In-Reply-To: <20101122002747.13674.69384.stgit@zaytsev.su>
References: <20101122002747.13674.69384.stgit@zaytsev.su>
User-Agent: StGit/0.15-97-g9680
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 fs/notify/fsnotify.c             |   24 ++++++++++++++----------
 fs/notify/inode_mark.c           |    2 +-
 fs/notify/inotify/inotify_user.c |    2 +-
 fs/notify/notification.c         |   18 ++++++++++++++++--
 include/linux/fsnotify_backend.h |   31 ++++++++++++++++++++++++++-----
 5 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 20dc218..7cabc1d 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -84,7 +84,8 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 }
 
 /* Notify this dentry's parent about a child's events. */
-int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
+int __fsnotify_parent(struct path *path, struct dentry *dentry,
+		__u32 mask, struct fsnotify_range *range)
 {
 	struct dentry *parent;
 	struct inode *p_inode;
@@ -108,10 +109,10 @@ int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 
 		if (path)
 			ret = fsnotify(p_inode, mask, path, FSNOTIFY_EVENT_PATH,
-				       dentry->d_name.name, 0);
+				       dentry->d_name.name, 0, range);
 		else
 			ret = fsnotify(p_inode, mask, dentry->d_inode, FSNOTIFY_EVENT_INODE,
-				       dentry->d_name.name, 0);
+				       dentry->d_name.name, 0, range);
 	}
 
 	dput(parent);
@@ -126,6 +127,7 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 			 __u32 mask, void *data,
 			 int data_is, u32 cookie,
 			 const unsigned char *file_name,
+			 struct fsnotify_range *range,
 			 struct fsnotify_event **event)
 {
 	struct fsnotify_group *group = NULL;
@@ -167,10 +169,11 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 
 	pr_debug("%s: group=%p to_tell=%p mnt=%p mask=%x inode_mark=%p"
 		 " inode_test_mask=%x vfsmount_mark=%p vfsmount_test_mask=%x"
-		 " data=%p data_is=%d cookie=%d event=%p\n",
+		 " data=%p data_is=%d cookie=%d range = {%lld, %lld}, event=%p\n",
 		 __func__, group, to_tell, mnt, mask, inode_mark,
 		 inode_test_mask, vfsmount_mark, vfsmount_test_mask, data,
-		 data_is, cookie, *event);
+		 data_is, cookie, range ? range->start : -1,
+		 range ? range->end : -1, *event);
 
 	if (!inode_test_mask && !vfsmount_test_mask)
 		return 0;
@@ -183,7 +186,7 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 	if (!*event) {
 		*event = fsnotify_create_event(to_tell, mask, data,
 						data_is, file_name,
-						cookie, GFP_KERNEL);
+						cookie, range, GFP_KERNEL);
 		if (!*event)
 			return -ENOMEM;
 	}
@@ -197,7 +200,8 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
  * notification event in whatever means they feel necessary.
  */
 int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
-	     const unsigned char *file_name, u32 cookie)
+	     const unsigned char *file_name, u32 cookie,
+	     struct fsnotify_range *range)
 {
 	struct hlist_node *inode_node = NULL, *vfsmount_node = NULL;
 	struct fsnotify_mark *inode_mark = NULL, *vfsmount_mark = NULL;
@@ -256,17 +260,17 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 		if (inode_group > vfsmount_group) {
 			/* handle inode */
 			ret = send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
-					    data_is, cookie, file_name, &event);
+					    data_is, cookie, file_name, range, &event);
 			/* we didn't use the vfsmount_mark */
 			vfsmount_group = NULL;
 		} else if (vfsmount_group > inode_group) {
 			ret = send_to_group(to_tell, mnt, NULL, vfsmount_mark, mask, data,
-					    data_is, cookie, file_name, &event);
+					    data_is, cookie, file_name, range, &event);
 			inode_group = NULL;
 		} else {
 			ret = send_to_group(to_tell, mnt, inode_mark, vfsmount_mark,
 					    mask, data, data_is, cookie, file_name,
-					    &event);
+					    range, &event);
 		}
 
 		if (ret && (mask & ALL_FSNOTIFY_PERM_EVENTS))
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 4c29fcf..cd39df7 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -295,7 +295,7 @@ void fsnotify_unmount_inodes(struct list_head *list)
 			iput(need_iput_tmp);
 
 		/* for each watch, send FS_UNMOUNT and then remove it */
-		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
+		fsnotify(inode, FS_UNMOUNT, inode, FSNOTIFY_EVENT_INODE, NULL, 0, NULL);
 
 		fsnotify_inode_delete(inode);
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 444c305..a5c2c69 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -524,7 +524,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 
 	ignored_event = fsnotify_create_event(NULL, FS_IN_IGNORED, NULL,
 					      FSNOTIFY_EVENT_NONE, NULL, 0,
-					      GFP_NOFS);
+					      NULL, GFP_NOFS);
 	if (!ignored_event)
 		return;
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index f39260f..20b86a0 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -395,7 +395,8 @@ struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event)
  */
 struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data,
 					     int data_type, const unsigned char *name,
-					     u32 cookie, gfp_t gfp)
+					     u32 cookie, struct fsnotify_range *range,
+					     gfp_t gfp)
 {
 	struct fsnotify_event *event;
 
@@ -422,6 +423,19 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 	event->to_tell = to_tell;
 	event->data_type = data_type;
 
+	/* The range might be allocated on stack. */
+	if (mask & FS_MODIFY) {
+		event->mod_range = *range;
+	} else {
+		event->mod_range.start = -1;
+	}
+
+	if (mask & FS_CLOSE_WRITE) {
+		event->cw_range = *range;
+	} else {
+		event->cw_range.start = -1;
+	}
+
 	switch (data_type) {
 	case FSNOTIFY_EVENT_PATH: {
 		struct path *path = data;
@@ -453,7 +467,7 @@ __init int fsnotify_notification_init(void)
 	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
 
 	q_overflow_event = fsnotify_create_event(NULL, FS_Q_OVERFLOW, NULL,
-						 FSNOTIFY_EVENT_NONE, NULL, 0,
+						 FSNOTIFY_EVENT_NONE, NULL, 0, NULL,
 						 GFP_KERNEL);
 	if (!q_overflow_event)
 		panic("unable to allocate fsnotify q_overflow_event\n");
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 0a68f92..63237c5 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -240,6 +240,9 @@ struct fsnotify_event {
 	size_t name_len;
 	struct pid *tgid;
 
+	struct fsnotify_range mod_range; /* What has been modified last time */
+	struct fsnotify_range cw_range; /* What has been modified since the file was opened */
+
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 	__u32 response;	/* userspace answer to question */
 #endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
@@ -305,8 +308,10 @@ struct fsnotify_mark {
 
 /* main fsnotify call to send events */
 extern int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
-		    const unsigned char *name, u32 cookie);
-extern int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask);
+		    const unsigned char *name, u32 cookie,
+		    struct fsnotify_range *range);
+extern int __fsnotify_parent(struct path *path, struct dentry *dentry,
+		__u32 mask, struct fsnotify_range *range);
 extern void __fsnotify_inode_delete(struct inode *inode);
 extern void __fsnotify_vfsmount_delete(struct vfsmount *mnt);
 extern u32 fsnotify_get_cookie(void);
@@ -420,22 +425,34 @@ extern void fsnotify_unmount_inodes(struct list_head *list);
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 						    void *data, int data_is,
 						    const unsigned char *name,
-						    u32 cookie, gfp_t gfp);
+						    u32 cookie,
+						    struct fsnotify_range *range,
+						    gfp_t gfp);
 
 /* fanotify likes to change events after they are on lists... */
 extern struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event);
 extern int fsnotify_replace_event(struct fsnotify_event_holder *old_holder,
 				  struct fsnotify_event *new_event);
 
+static inline void fsnotify_update_range(struct fsnotify_range *new,
+		struct fsnotify_range *old)
+{
+	/* Cast because an empty range starts at -1. */
+	new->start = min((unsigned long long) old->start, (unsigned long long) new->start);
+	new->end = max(old->end, new->end);
+}
+
 #else
 
 static inline int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
-			   const unsigned char *name, u32 cookie)
+			   const unsigned char *name, u32 cookie,
+			   struct fsnotify_range *range)
 {
 	return 0;
 }
 
-static inline int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
+static inline int __fsnotify_parent(struct path *path, struct dentry *dentry,
+		__u32 mask, struct fsnotify_range *range)
 {
 	return 0;
 }
@@ -460,6 +477,10 @@ static inline u32 fsnotify_get_cookie(void)
 static inline void fsnotify_unmount_inodes(struct list_head *list)
 {}
 
+static inline void fsnotify_update_range(struct fsnotify_range *new,
+		struct fsnotify_range *old)
+{}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */

