Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0JUNXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:23:18 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7306 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758038Ab0JUNWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:22:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoAGAGfav0x5LdoFgWdsb2JhbACUZ4xxFgEBFiIiwC+FSgSKTQ
Message-Id: <20101021131016.314572010@kernel.dk>
User-Agent: quilt/0.48-1
Date: Fri, 22 Oct 2010 00:08:33 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk
Subject: [patch 04/14] fs: icache unmount code cleanup
References: <20101021130829.442910807@kernel.dk>
Content-Disposition: inline; filename=fs-inode-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slight cleanup to unmount code in prep for lock splitting. Push inode_lock
into fsnotify_unmount_inodes, and remove it from invalidate_list according
to the code that indicates it is not required.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c                       |   25 ++++++++++++-------------
 fs/notify/inode_mark.c           |    5 ++++-
 include/linux/fsnotify_backend.h |    2 +-
 3 files changed, 17 insertions(+), 15 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-21 23:50:45.000000000 +1100
@@ -403,24 +403,22 @@ static void dispose_list(struct list_hea
 /*
  * Invalidate all inodes for a device.
  */
-static int invalidate_list(struct list_head *head, struct list_head *dispose)
+static int invalidate_list(struct super_block *sb, struct list_head *dispose)
 {
+	struct list_head *head = &sb->s_inodes;
 	struct list_head *next;
 	int busy = 0, count = 0;
 
+	/*
+	 * We don't need any list locks here because the per-sb list of inodes
+	 * must not change during umount anymore. There are no external
+	 * references, and iprune_sem keeps shrink_icache_memory() away.
+	 */
 	next = head->next;
 	for (;;) {
 		struct list_head *tmp = next;
 		struct inode *inode;
 
-		/*
-		 * We can reschedule here without worrying about the list's
-		 * consistency because the per-sb list of inodes must not
-		 * change during umount anymore, and because iprune_sem keeps
-		 * shrink_icache_memory() away.
-		 */
-		cond_resched_lock(&inode_lock);
-
 		next = next->next;
 		if (tmp == head)
 			break;
@@ -443,7 +441,10 @@ static int invalidate_list(struct list_h
 		busy = 1;
 	}
 	/* only unused inodes may be cached with i_count zero */
+	spin_lock(&inode_lock);
 	inodes_stat.nr_unused -= count;
+	spin_unlock(&inode_lock);
+
 	return busy;
 }
 
@@ -461,10 +462,8 @@ int invalidate_inodes(struct super_block
 	LIST_HEAD(throw_away);
 
 	down_write(&iprune_sem);
-	spin_lock(&inode_lock);
-	fsnotify_unmount_inodes(&sb->s_inodes);
-	busy = invalidate_list(&sb->s_inodes, &throw_away);
-	spin_unlock(&inode_lock);
+	fsnotify_unmount_inodes(sb);
+	busy = invalidate_list(sb, &throw_away);
 
 	dispose_list(&throw_away);
 	up_write(&iprune_sem);
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-21 23:50:27.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-21 23:50:45.000000000 +1100
@@ -236,10 +236,12 @@ int fsnotify_add_inode_mark(struct fsnot
  * of inodes, and with iprune_mutex held, keeping shrink_icache_memory() at bay.
  * We temporarily drop inode_lock, however, and CAN block.
  */
-void fsnotify_unmount_inodes(struct list_head *list)
+void fsnotify_unmount_inodes(struct super_block *sb)
 {
+	struct list_head *list = &sb->s_inodes;
 	struct inode *inode, *next_i, *need_iput = NULL;
 
+	spin_lock(&inode_lock);
 	list_for_each_entry_safe(inode, next_i, list, i_sb_list) {
 		struct inode *need_iput_tmp;
 
@@ -306,4 +308,5 @@ void fsnotify_unmount_inodes(struct list
 
 		spin_lock(&inode_lock);
 	}
+	spin_unlock(&inode_lock);
 }
Index: linux-2.6/include/linux/fsnotify_backend.h
===================================================================
--- linux-2.6.orig/include/linux/fsnotify_backend.h	2010-10-21 23:49:53.000000000 +1100
+++ linux-2.6/include/linux/fsnotify_backend.h	2010-10-21 23:50:27.000000000 +1100
@@ -402,7 +402,7 @@ extern void fsnotify_clear_marks_by_grou
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_get_mark(struct fsnotify_mark *mark);
 extern void fsnotify_put_mark(struct fsnotify_mark *mark);
-extern void fsnotify_unmount_inodes(struct list_head *list);
+extern void fsnotify_unmount_inodes(struct super_block *sb);
 
 /* put here because inotify does some weird stuff when destroying watches */
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,


