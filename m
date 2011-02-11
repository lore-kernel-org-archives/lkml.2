Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab1BKKmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:42:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60911 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751453Ab1BKKkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:40:37 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18UsLgQ6fEUqDBQ9kZjAMMw2CC13jFRVY1/E3M8N4
	3igE/TmIW+e4Fw
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 1/7] fsnotify: take groups mark_lock before mark lock
Date: Fri, 11 Feb 2011 11:36:37 +0100
Message-Id: <1297420603-11715-2-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1297420603-11715-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Race-free addition and removal of a mark to a groups mark list would be easier
if we could lock the mark list of group before we lock the specific mark.
This patch changes the order used to add/remove marks to/from mark lists from

1. mark->lock
2. group->mark_lock
3. inode->i_lock

to

1. group->mark_lock
2. mark->lock
3. inode->i_lock

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/mark.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 28b64eb..1ac0447 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -114,22 +114,21 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 	struct inode *inode = NULL;
 
 	spin_lock(&mark->lock);
-
-	group = mark->group;
-
 	/* something else already called this function on this mark */
 	if (!(mark->flags & FSNOTIFY_MARK_FLAG_ALIVE)) {
 		spin_unlock(&mark->lock);
 		return;
 	}
-
 	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
+	group = mark->group;
+	spin_unlock(&mark->lock);
+
+	spin_lock(&group->mark_lock);
+	spin_lock(&mark->lock);
 
 	/* 1 from caller and 1 for being on i_list/g_list */
 	BUG_ON(atomic_read(&mark->refcnt) < 2);
 
-	spin_lock(&group->mark_lock);
-
 	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE) {
 		inode = mark->i.inode;
 		fsnotify_destroy_inode_mark(mark);
@@ -137,11 +136,11 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 		fsnotify_destroy_vfsmount_mark(mark);
 	else
 		BUG();
+	spin_unlock(&mark->lock);
 
 	list_del_init(&mark->g_list);
 
 	spin_unlock(&group->mark_lock);
-	spin_unlock(&mark->lock);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->destroy_list, &destroy_list);
@@ -217,8 +216,8 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 	 * group->mark_lock
 	 * inode->i_lock
 	 */
-	spin_lock(&mark->lock);
 	spin_lock(&group->mark_lock);
+	spin_lock(&mark->lock);
 
 	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
 	mark->group = group;
@@ -235,13 +234,11 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 		BUG();
 	if (ret)
 		goto err;
-
-	spin_unlock(&group->mark_lock);
-
 	/* this will pin the object if appropriate */
 	fsnotify_set_mark_mask_locked(mark, mark->mask);
 
 	spin_unlock(&mark->lock);
+	spin_unlock(&group->mark_lock);
 
 	if (inode)
 		__fsnotify_update_child_dentry_flags(inode);
@@ -253,8 +250,8 @@ err:
 	mark->group = NULL;
 	atomic_dec(&group->num_marks);
 
-	spin_unlock(&group->mark_lock);
 	spin_unlock(&mark->lock);
+	spin_unlock(&group->mark_lock);
 
 	spin_lock(&destroy_lock);
 	list_add(&mark->destroy_list, &destroy_list);
-- 
1.5.6.5

