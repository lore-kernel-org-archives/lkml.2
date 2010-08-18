Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0HRQaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:30:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab0HRQaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:30:13 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/5] fsnotify: fix ignored mask handling between inode and
	vfsmount marks
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Aug 2010 12:30:11 -0400
Message-ID: <20100818163011.1080.19976.stgit@paris.rdu.redhat.com>
In-Reply-To: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
References: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interesting 2 list lockstep walking didn't quite work out if the inode
marks only had ignores and the vfsmount list requested events.  The code to
shortcut list traversal would not run the inode list since it didn't have real
event requests.  This code forces inode list traversal when a vfsmount mark
matches the event type.  Maybe we could add an i_fsnotify_ignored_mask field
to struct inode to get the shortcut back, but it doesn't seem worth it to grow
struct inode again.

I bet with the recent changes to lock the way we do now it would actually not
be a major perf hit to just drop i_fsnotify_mark_mask altogether.  But that is
for another day.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 59dc7a0..6f2777c 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -149,8 +149,8 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 			 struct fsnotify_event **event)
 {
 	struct fsnotify_group *group = NULL;
-	__u32 inode_test_mask = (mask & ~FS_EVENT_ON_CHILD);
-	__u32 vfsmount_test_mask = (mask & ~FS_EVENT_ON_CHILD);
+	__u32 inode_test_mask = 0;
+	__u32 vfsmount_test_mask = 0;
 
 	if (unlikely(!inode_mark && !vfsmount_mark)) {
 		BUG();
@@ -170,12 +170,14 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 	/* does the inode mark tell us to do something? */
 	if (inode_mark) {
 		group = inode_mark->group;
+		inode_test_mask = (mask & ~FS_EVENT_ON_CHILD);
 		inode_test_mask &= inode_mark->mask;
 		inode_test_mask &= ~inode_mark->ignored_mask;
 	}
 
 	/* does the vfsmount_mark tell us to do something? */
 	if (vfsmount_mark) {
+		vfsmount_test_mask = (mask & ~FS_EVENT_ON_CHILD);
 		group = vfsmount_mark->group;
 		vfsmount_test_mask &= vfsmount_mark->mask;
 		vfsmount_test_mask &= ~vfsmount_mark->ignored_mask;
@@ -183,9 +185,12 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 			vfsmount_test_mask &= ~inode_mark->ignored_mask;
 	}
 
-	pr_debug("%s: group=%p to_tell=%p mnt=%p mark=%p mask=%x data=%p"
-		 " data_is=%d cookie=%d event=%p\n", __func__, group, to_tell,
-		 mnt, inode_mark, mask, data, data_is, cookie, *event);
+	pr_debug("%s: group=%p to_tell=%p mnt=%p mask=%x inode_mark=%p"
+		 " inode_test_mask=%x vfsmount_mark=%p vfsmount_test_mask=%x"
+		 " data=%p data_is=%d cookie=%d event=%p\n",
+		 __func__, group, to_tell, mnt, mask, inode_mark,
+		 inode_test_mask, vfsmount_mark, vfsmount_test_mask, data,
+		 data_is, cookie, *event);
 
 	if (!inode_test_mask && !vfsmount_test_mask)
 		return 0;
@@ -214,7 +219,7 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 	     const unsigned char *file_name, u32 cookie)
 {
-	struct hlist_node *inode_node, *vfsmount_node;
+	struct hlist_node *inode_node = NULL, *vfsmount_node = NULL;
 	struct fsnotify_mark *inode_mark = NULL, *vfsmount_mark = NULL;
 	struct fsnotify_group *inode_group, *vfsmount_group;
 	struct fsnotify_event *event = NULL;
@@ -245,19 +250,13 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 	    (test_mask & to_tell->i_fsnotify_mask))
 		inode_node = srcu_dereference(to_tell->i_fsnotify_marks.first,
 					      &fsnotify_mark_srcu);
-	else
-		inode_node = NULL;
 
-	if (mnt) {
-		if ((mask & FS_MODIFY) ||
-		    (test_mask & mnt->mnt_fsnotify_mask))
-			vfsmount_node = srcu_dereference(mnt->mnt_fsnotify_marks.first,
-							 &fsnotify_mark_srcu);
-		else
-			vfsmount_node = NULL;
-	} else {
-		mnt = NULL;
-		vfsmount_node = NULL;
+	if (mnt && ((mask & FS_MODIFY) ||
+		    (test_mask & mnt->mnt_fsnotify_mask))) {
+		vfsmount_node = srcu_dereference(mnt->mnt_fsnotify_marks.first,
+						 &fsnotify_mark_srcu);
+		inode_node = srcu_dereference(to_tell->i_fsnotify_marks.first,
+					      &fsnotify_mark_srcu);
 	}
 
 	while (inode_node || vfsmount_node) {

