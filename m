Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1ASQqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:46:04 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53253 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754604Ab1ASQqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:01 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+/RgdqxxO/FvXa+9Sq9aP8WHDPhNd42f3bX6zMS1
	is5zF1Ckv/X20c
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 01/14] fsnotify: change locking order in fsnotify_add_mark()
Date: Wed, 19 Jan 2011 17:42:04 +0100
Message-Id: <1295455337-20219-2-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of taking
1. mark->lock
2. group->mark_lock
3. inode->lock

we now use another order in fsnotify_add_mark():
1. inode->lock
2. mark->lock

and assume that the callers took the group->mark_lock already.
By taking the mark_lock first, we can protect modification of the groups mark
list without the need of an extra lock like the group->mutex.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/mark.c |   38 +++++---------------------------------
 1 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 28b64eb..a677af0 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -213,20 +213,9 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 
 	/*
 	 * LOCKING ORDER!!!!
-	 * mark->lock
-	 * group->mark_lock
 	 * inode->i_lock
+	 * mark->lock
 	 */
-	spin_lock(&mark->lock);
-	spin_lock(&group->mark_lock);
-
-	mark->flags |= FSNOTIFY_MARK_FLAG_ALIVE;
-	mark->group = group;
-	list_add(&mark->g_list, &group->marks_list);
-	fsnotify_get_mark(mark); /* for i_list and g_list */
-	atomic_inc(&group->num_marks);
-
-	ret = 0;
 	if (inode)
 		ret = fsnotify_add_inode_mark(mark, group, inode, allow_dups);
 	else if (mnt)
@@ -234,34 +223,17 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 	else
 		BUG();
 	if (ret)
-		goto err;
-
-	spin_unlock(&group->mark_lock);
+		return ret;
 
-	/* this will pin the object if appropriate */
-	fsnotify_set_mark_mask_locked(mark, mark->mask);
+	fsnotify_get_mark(mark); /* for i_list and g_list */
 
-	spin_unlock(&mark->lock);
+	list_add(&mark->g_list, &group->marks_list);
+	atomic_inc(&group->num_marks);
 
 	if (inode)
 		__fsnotify_update_child_dentry_flags(inode);
 
 	return 0;
-err:
-	mark->flags &= ~FSNOTIFY_MARK_FLAG_ALIVE;
-	list_del_init(&mark->g_list);
-	mark->group = NULL;
-	atomic_dec(&group->num_marks);
-
-	spin_unlock(&group->mark_lock);
-	spin_unlock(&mark->lock);
-
-	spin_lock(&destroy_lock);
-	list_add(&mark->destroy_list, &destroy_list);
-	spin_unlock(&destroy_lock);
-	wake_up(&destroy_waitq);
-
-	return ret;
 }
 
 /*
-- 
1.5.6.5

