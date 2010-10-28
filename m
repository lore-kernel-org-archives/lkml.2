Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab0J1VcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:32:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760146Ab0J1Vbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:31:49 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 02/20] fsnotify: implement ordering between notifiers
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de, tvrtko.ursulin@sophos.com
Date: Thu, 28 Oct 2010 17:31:45 -0400
Message-ID: <20101028213145.24810.11059.stgit@paris.rdu.redhat.com>
In-Reply-To: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
References: <20101028213139.24810.34058.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify needs to be able to specify that some groups get events before
others.  They use this idea to make sure that a hierarchical storage
manager gets access to files before programs which actually use them.  This
is purely infrastructure.  Everything will have a priority of 0, but the
infrastructure will exist for it to be non-zero.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inode_mark.c           |    9 +++++++--
 fs/notify/vfsmount_mark.c        |    6 +++++-
 include/linux/fsnotify_backend.h |    8 ++++++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 21ed106..4c29fcf 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -177,7 +177,8 @@ void fsnotify_set_inode_mark_mask_locked(struct fsnotify_mark *mark,
  * Attach an initialized mark to a given inode.
  * These marks may be used for the fsnotify backend to determine which
  * event types should be delivered to which group and for which inodes.  These
- * marks are ordered according to the group's location in memory.
+ * marks are ordered according to priority, highest number first, and then by
+ * the group's location in memory.
  */
 int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 			    struct fsnotify_group *group, struct inode *inode,
@@ -211,7 +212,11 @@ int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 			goto out;
 		}
 
-		if (mark->group < lmark->group)
+		if (mark->group->priority < lmark->group->priority)
+			continue;
+
+		if ((mark->group->priority == lmark->group->priority) &&
+		    (mark->group < lmark->group))
 			continue;
 
 		hlist_add_before_rcu(&mark->i.i_list, &lmark->i.i_list);
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index 56772b5..85eebff 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -169,7 +169,11 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 			goto out;
 		}
 
-		if (mark->group < lmark->group)
+		if (mark->group->priority < lmark->group->priority)
+			continue;
+
+		if ((mark->group->priority == lmark->group->priority) &&
+		    (mark->group < lmark->group))
 			continue;
 
 		hlist_add_before_rcu(&mark->m.m_list, &lmark->m.m_list);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index e40190d..8253295 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -129,6 +129,14 @@ struct fsnotify_group {
 	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
 	unsigned int q_len;			/* events on the queue */
 	unsigned int max_events;		/* maximum events allowed on the list */
+	/*
+	 * Valid fsnotify group priorities.  Events are send in order from highest
+	 * priority to lowest priority.  We default to the lowest priority.
+	 */
+	#define FS_PRIO_0	0 /* normal notifiers, no permissions */
+	#define FS_PRIO_1	1 /* fanotify content based access control */
+	#define FS_PRIO_2	2 /* fanotify pre-content access */
+	unsigned int priority;
 
 	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
 	spinlock_t mark_lock;		/* protect marks_list */

