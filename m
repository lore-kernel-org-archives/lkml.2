Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0H1TZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 15:25:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35068 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab0H1TZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 15:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=cOgT7BvnnzVos0euux9Rv/nYarJ9Nw6BgZoShJsB8oZOdNFRVBCU1dmRZ7OxnFAy6v
         z/LkFmzEADvWKRrc+of8AILLF8Lng7udO9p/Q2TBTta4EOgLcyqCPxR5jA+0SYOnBUzV
         OkBanJ81uhZ+BFl9ZQTwM0GMUoigcfRPLrlUQ=
From: Csaba Henk <csaba@gluster.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Csaba Henk <csaba@gluster.com>
Subject: [PATCH 2/2] fsnotify: refactor mask filtering in send_to_group()
Date: Sun, 29 Aug 2010 00:55:42 +0530
Message-Id: <1283023542-1251-2-git-send-email-csaba@gluster.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283023542-1251-1-git-send-email-csaba@gluster.com>
References: <1283023542-1251-1-git-send-email-csaba@gluster.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- isolate filtering logic to reduce code duplication
- the case when only one mark is passed was not handled correctly:
  in this case the mask variable for the other mark was not
  filtered, giving therefore a green way, regardless the mask of
  the mark which was actually there to be tested

Signed-off-by: Csaba Henk <csaba@gluster.com>
---
 fs/notify/fsnotify.c |   44 +++++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 6657315..ece4bd6 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -140,6 +140,20 @@ void __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 }
 EXPORT_SYMBOL_GPL(__fsnotify_parent);
 
+static int check_mark_mask(struct fsnotify_mark *mark, __u32 *mask)
+{
+	if (!mark)
+		return 0;
+
+	if ((*mask & FS_MODIFY) &&
+	    !(mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
+		mark->ignored_mask = 0;
+	else
+		*mask &= ~mark->ignored_mask;
+
+	return *mask & mark->mask;
+}
+
 static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 			 struct fsnotify_mark *inode_mark,
 			 struct fsnotify_mark *vfsmount_mark,
@@ -149,8 +163,7 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 			 struct fsnotify_event **event)
 {
 	struct fsnotify_group *group;
-	__u32 inode_test_mask = (mask & ~FS_EVENT_ON_CHILD);
-	__u32 vfsmount_test_mask = (mask & ~FS_EVENT_ON_CHILD);
+	__u32 test_mask = (mask & ~FS_EVENT_ON_CHILD);
 
 	if (inode_mark)
 		group = inode_mark->group;
@@ -164,31 +177,8 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 		 __func__, group, to_tell, mnt, inode_mark, vfsmount_mark, mask,
 		 data, data_is, cookie, *event);
 
-	/* clear ignored on inode modification */
-	if (mask & FS_MODIFY) {
-		if (inode_mark &&
-		    !(inode_mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
-			inode_mark->ignored_mask = 0;
-		if (vfsmount_mark &&
-		    !(vfsmount_mark->flags & FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY))
-			vfsmount_mark->ignored_mask = 0;
-	}
-
-	/* does the inode mark tell us to do something? */
-	if (inode_mark) {
-		inode_test_mask &= inode_mark->mask;
-		inode_test_mask &= ~inode_mark->ignored_mask;
-	}
-
-	/* does the vfsmount_mark tell us to do something? */
-	if (vfsmount_mark) {
-		vfsmount_test_mask &= vfsmount_mark->mask;
-		vfsmount_test_mask &= ~vfsmount_mark->ignored_mask;
-		if (inode_mark)
-			vfsmount_test_mask &= ~inode_mark->ignored_mask;
-	}
-
-	if (!inode_test_mask && !vfsmount_test_mask)
+	if (!(check_mark_mask(inode_mark, &test_mask) ||
+	      check_mark_mask(vfsmount_mark, &test_mask)))
 		return 0;
 
 	if (group->ops->should_send_event(group, to_tell, inode_mark,
-- 
1.7.2.2

