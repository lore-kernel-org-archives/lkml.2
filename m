Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab1ASQqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:46:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:49442 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754740Ab1ASQqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:46:23 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18PnUQ+oI4PoQ05jlsIT0zXpfqP8x5ow2+dz5zJJz
	D1mrvxKZz2A84w
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 09/14] fsnotify: add new function fsnotify_remove_mark_locked()
Date: Wed, 19 Jan 2011 17:42:12 +0100
Message-Id: <1295455337-20219-10-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the fucntion fsnotify_remove_mark_locked() which is the counterpart to
fsnotify_add_mark_locked():
The mark is removed from the mark list of its group, unlinked from the
fs object it is linked to, and the number of group marks is decreased.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/mark.c                 |   24 ++++++++++++++++++++++++
 include/linux/fsnotify_backend.h |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 916a291..87d78b9 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -174,6 +174,30 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 }
 
 /*
+ * Remove an attached mark from its group.
+ * If the mark is still linked to an fs object it will be unlinked, too.
+ * Requires groups mark_lock to be held.
+ */
+void fsnotify_remove_mark_locked(struct fsnotify_mark *mark)
+{
+	struct fsnotify_group *group = mark->group;
+
+	BUG_ON(!group);
+
+	list_del_init(&mark->g_list);
+	fsnotify_destroy_mark(mark);
+	/*
+	 * Some groups like to know that marks are being freed.
+	 * This is a callback to the group function to let it
+	 * know that this mark is being freed.
+	 */
+	if (group->ops->freeing_mark)
+		group->ops->freeing_mark(mark, group);
+	fsnotify_put_mark(mark);
+	atomic_dec(&group->num_marks);
+}
+
+/*
  * clear any marks in a group in which mark->flags & flags is true
  */
 void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index f6891f9..4c7f997 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -404,6 +404,8 @@ extern int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 				    struct fsnotify_group *group,
 				    struct inode *inode, struct vfsmount *mnt,
 				    int allow_dups);
+/* remove mark from its group */
+extern void fsnotify_remove_mark_locked(struct fsnotify_mark *mark);
 /* given a mark, flag it to be freed when all references are dropped */
 extern void fsnotify_destroy_mark(struct fsnotify_mark *mark);
 /* run all the marks in a group, and clear all of the vfsmount marks */
-- 
1.5.6.5

