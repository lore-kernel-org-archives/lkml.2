Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1ASQ6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:58:13 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44122 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752437Ab1ASQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:58:11 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1/NaFtFNHPN/FEMhb9Ld9pBxnKcLOymUASOx9N5E0
	wf5aeUsY8OSvNA
Date: Wed, 19 Jan 2011 17:55:00 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 14/14] fsnotify: remove dead code
Message-ID: <20110119165500.GE20335@lsanfilippo.unix.rd.tt.avira.com>
Reply-To: 1295455337-20219-1-git-send-email-LinoSanfilippo@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The "fsnotify_mark" thread is not needed any more, so the code related to this
thread is removed.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 fs/notify/mark.c                 |   44 --------------------------------------
 include/linux/fsnotify_backend.h |    2 -
 2 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index 5a267a9..e8f6177 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -85,7 +85,6 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -99,9 +98,6 @@
 #include "fsnotify.h"
 
 struct srcu_struct fsnotify_mark_srcu;
-static DEFINE_SPINLOCK(destroy_lock);
-static LIST_HEAD(destroy_list);
-static DECLARE_WAIT_QUEUE_HEAD(destroy_waitq);
 
 /*
  * Any time a mark is getting freed we end up here.
@@ -244,43 +240,3 @@ void fsnotify_init_mark(struct fsnotify_mark *mark,
 	mark->free_mark = free_mark;
 }
 
-static int fsnotify_mark_destroy(void *ignored)
-{
-	struct fsnotify_mark *mark, *next;
-	LIST_HEAD(private_destroy_list);
-
-	for (;;) {
-		spin_lock(&destroy_lock);
-		/* exchange the list head */
-		list_replace_init(&destroy_list, &private_destroy_list);
-		spin_unlock(&destroy_lock);
-
-		synchronize_srcu(&fsnotify_mark_srcu);
-
-		/*
-		 * at this point we cannot be found via the i_list or g_list so
-		 * drop that reference.
-		 */
-		list_for_each_entry_safe(mark, next, &private_destroy_list, destroy_list) {
-			list_del_init(&mark->destroy_list);
-			fsnotify_put_mark(mark);
-		}
-
-		wait_event_interruptible(destroy_waitq, !list_empty(&destroy_list));
-	}
-
-	return 0;
-}
-
-static int __init fsnotify_mark_init(void)
-{
-	struct task_struct *thread;
-
-	thread = kthread_run(fsnotify_mark_destroy, NULL,
-			     "fsnotify_mark");
-	if (IS_ERR(thread))
-		panic("unable to start fsnotify mark destruction thread.");
-
-	return 0;
-}
-device_initcall(fsnotify_mark_init);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 5a7c2f6..ce4d610 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -286,7 +286,6 @@ struct fsnotify_mark {
 		struct fsnotify_inode_mark i;
 		struct fsnotify_vfsmount_mark m;
 	};
-	struct list_head free_g_list;	/* tmp list used when freeing this mark */
 	__u32 ignored_mask;		/* events types to ignore */
 #define FSNOTIFY_MARK_FLAG_INODE		0x01
 #define FSNOTIFY_MARK_FLAG_VFSMOUNT		0x02
@@ -294,7 +293,6 @@ struct fsnotify_mark {
 #define FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY	0x08
 #define FSNOTIFY_MARK_FLAG_ALIVE		0x10
 	unsigned int flags;		/* vfsmount or inode mark? */
-	struct list_head destroy_list;
 	void (*free_mark)(struct fsnotify_mark *mark); /* called on final put+free */
 };
 
-- 
1.5.6.5

