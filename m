Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1ASQzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:55:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:42698 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752039Ab1ASQzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:55:36 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+snEkUnTGsMB6nTX1LPwa679uVURBEPUU63Qbq+P
	7Q273cq1CunKaK
Date: Wed, 19 Jan 2011 17:52:25 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 12/14] fsnotify: use a mutex instead of a spinlock to
	protect a groups mark_list
Message-ID: <20110119165225.GC20335@lsanfilippo.unix.rd.tt.avira.com>
Reply-To: 1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use a mutex instead of a spinlock to protect a groups mark_list, so that its
possible to sleep (i.e for allocations) while the list is protected.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/group.c                |    2 +-
 fs/notify/mark.c                 |    6 +++---
 include/linux/fsnotify_backend.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index a407bac..d24ab1e 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -87,7 +87,7 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 	init_waitqueue_head(&group->notification_waitq);
 	group->max_events = UINT_MAX;
 
-	spin_lock_init(&group->mark_lock);
+	mutex_init(&group->mark_mutex);
 	INIT_LIST_HEAD(&group->marks_list);
 
 	group->ops = ops;
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 2827867..5a267a9 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -176,7 +176,7 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 /*
  * Remove an attached mark from its group.
  * If the mark is still linked to an fs object it will be unlinked, too.
- * Requires groups mark_lock to be held.
+ * Requires groups mark_mutex to be held.
  */
 void fsnotify_remove_mark_locked(struct fsnotify_mark *mark)
 {
@@ -205,12 +205,12 @@ void fsnotify_clear_marks_by_group_flags(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *lmark, *mark;
 
-	spin_lock(&group->mark_lock);
+	mutex_lock(&group->mark_mutex);
 	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
 		if (mark->flags & flags)
 			fsnotify_remove_mark_locked(mark);
 	}
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 }
 
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 4c7f997..3d270c2 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -142,7 +142,7 @@ struct fsnotify_group {
 	unsigned int priority;
 
 	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
-	spinlock_t mark_lock;		/* protect marks_list */
+	struct mutex mark_mutex;	/* protect marks_list */
 	atomic_t num_marks;		/* 1 for each mark and 1 for not being
 					 * past the point of no return when freeing
 					 * a group */
-- 
1.5.6.5

