Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0JSEBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:01:48 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933146Ab0JSD4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSoUA
Message-Id: <20101019034657.476923711@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:35 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 19/35] fs: icache remove redundant i_sb_list umount locking
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale-11a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for rcu walking the inode sb lists, remove some
locking from the inode umount path according to comments and
the fact that we already rely on the list not changing at these
points.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/inode.c             |   15 +++++----------
 fs/notify/inode_mark.c |   15 +++------------
 2 files changed, 8 insertions(+), 22 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:25.000000000 +1100
@@ -407,14 +407,6 @@
 		struct list_head *tmp = next;
 		struct inode *inode;
 
-		/*
-		 * We can reschedule here without worrying about the list's
-		 * consistency because the per-sb list of inodes must not
-		 * change during umount anymore, and because iprune_sem keeps
-		 * shrink_icache_memory() away.
-		 */
-		cond_resched_lock(&sb_inode_list_lock);
-
 		next = next->next;
 		if (tmp == head)
 			break;
@@ -458,10 +450,13 @@
 	LIST_HEAD(throw_away);
 
 	down_write(&iprune_sem);
-	spin_lock(&sb_inode_list_lock);
+	/*
+	 * We can walk the per-sb list of inodes here without worrying about
+	 * its consistency, because the list must not change during umount
+	 * anymore, and because iprune_sem keeps shrink_icache_memory() away.
+	 */
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
-	spin_unlock(&sb_inode_list_lock);
 
 	dispose_list(&throw_away);
 	up_write(&iprune_sem);
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-19 14:18:59.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-19 14:19:24.000000000 +1100
@@ -232,8 +232,9 @@
  * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
  * @list: list of inodes being unmounted (sb->s_inodes)
  *
- * Called with iprune_mutex held, keeping shrink_icache_memory() at bay.
- * sb_inode_list_lock to protect the super block's list of inodes.
+ * Called with iprune_mutex held, keeping shrink_icache_memory() at bay,
+ * and with the sb going away, no new inodes will appear or be referenced
+ * from other paths.
  */
 void fsnotify_unmount_inodes(struct list_head *list)
 {
@@ -285,14 +286,6 @@
 			spin_unlock(&next_i->i_lock);
 		}
 
-		/*
-		 * We can safely drop sb_inode_list_lock here because we hold
-		 * references on both inode and next_i.  Also no new inodes
-		 * will be added since the umount has begun.  Finally,
-		 * iprune_mutex keeps shrink_icache_memory() away.
-		 */
-		spin_unlock(&sb_inode_list_lock);
-
 		if (need_iput_tmp)
 			iput(need_iput_tmp);
 
@@ -302,7 +295,5 @@
 		fsnotify_inode_delete(inode);
 
 		iput(inode);
-
-		spin_lock(&sb_inode_list_lock);
 	}
 }


