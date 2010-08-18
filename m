Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab0HRQ37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0HRQ35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:29:57 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/5] fanotify: do not dereference inode_mark when it is unset
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Aug 2010 12:29:54 -0400
Message-ID: <20100818162954.1080.48055.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fanotify code is supposed to get the group from the mark.  It accidentally
only used the inode_mark.  If the vfsmount_mark was set but not the inode_mark
it would deref the NULL inode_mark.  Get the group from the correct place.

Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 3970392..f3e3b35 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -148,13 +148,14 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 			 const unsigned char *file_name,
 			 struct fsnotify_event **event)
 {
-	struct fsnotify_group *group = inode_mark->group;
+	struct fsnotify_group *group = NULL;
 	__u32 inode_test_mask = (mask & ~FS_EVENT_ON_CHILD);
 	__u32 vfsmount_test_mask = (mask & ~FS_EVENT_ON_CHILD);
 
-	pr_debug("%s: group=%p to_tell=%p mnt=%p mark=%p mask=%x data=%p"
-		 " data_is=%d cookie=%d event=%p\n", __func__, group, to_tell,
-		 mnt, inode_mark, mask, data, data_is, cookie, *event);
+	if (unlikely(!inode_mark && !vfsmount_mark)) {
+		BUG();
+		return 0;
+	}
 
 	/* clear ignored on inode modification */
 	if (mask & FS_MODIFY) {
@@ -168,18 +169,24 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 
 	/* does the inode mark tell us to do something? */
 	if (inode_mark) {
+		group = inode_mark->group;
 		inode_test_mask &= inode_mark->mask;
 		inode_test_mask &= ~inode_mark->ignored_mask;
 	}
 
 	/* does the vfsmount_mark tell us to do something? */
 	if (vfsmount_mark) {
+		group = vfsmount_mark->group;
 		vfsmount_test_mask &= vfsmount_mark->mask;
 		vfsmount_test_mask &= ~vfsmount_mark->ignored_mask;
 		if (inode_mark)
 			vfsmount_test_mask &= ~inode_mark->ignored_mask;
 	}
 
+	pr_debug("%s: group=%p to_tell=%p mnt=%p mark=%p mask=%x data=%p"
+		 " data_is=%d cookie=%d event=%p\n", __func__, group, to_tell,
+		 mnt, inode_mark, mask, data, data_is, cookie, *event);
+
 	if (!inode_test_mask && !vfsmount_test_mask)
 		return 0;
 

