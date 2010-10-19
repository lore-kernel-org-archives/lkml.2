Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab0JSEDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:03:04 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28449 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab0JSD4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaCeIJRBIpKhQA
Message-Id: <20101019034655.980476949@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:21 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 05/35] fs: icache lock s_inodes list
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode_lock-scale.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect sb->s_inodes with a new lock, sb_inode_list_lock.

***
This is the first patch in the inode lock scaling series, and as such
I will provide an overview of the structure of the patchset and its goals.

Firstly, the overall locking design is to move from a global lock for the
inode cache to a per-inode lock to protect the icache state of an inode;
and other fine grained locks to protect access to various icache data
structures.

The per-inode lock used is i_lock, but it isn't tied to other users of i_lock
so if there is a problem with this usage of the lock in future, another
lock can easily be added to the inode for icache locking.

The per-inode lock to lock the icache state of a given inode works nicely to
naturally replace the inode_lock without significantly changing the rest of the
code. Most of the icache operation is interested in operating on a particular
inode at a time (after finding it from a particular data structure or
reference), and so, in these places, where we once took the inode_lock to lock
icache state, we may now replace it with i_lock without new concurrencies
introduced in the icache.

Secondly, the inode scaling patchset is broken into 3 parts.
1: adds global locks to take over protections of various data structures from
   the inode_lock, and protects per-inode state with i_lock.
2: removes the global inode_lock.
3: various strategies to improve scalability of the newly added locks, and
   streamline locking.

This approach has several benefits. Firstly, the steps to add locking and
take over inode_lock are very conservative and as simple as realistically
possible to review and audit for correctness. Secondly, removing inode_lock
before more complex code and locking transforms allows for much better
bisectability for bugs and performance regressions than if we lift the
inode_lock as a final step after the more complex transformations are done.
Lastly, small, reviewable and often independent changes to improve locking
can be reviewed, reverted, bisected and tested after inode_lock is gone.

There is also a disadvantage in that the conservative and clunky locking
built up in the first step is not performant, often looks ugly, and
contains more nesting and lock ordering problems than necessary. However
these steps are very much intended only to be intermediate and obvious
small steps along the way.

The choice to nest icache structure locks inside i_lock was made because
that ended up working the best for paths such as inode insertion or removal
from data structures, when several locks would otherwise need to be held at
once. The icache structure locks are all private to icache, so it is possible
to reduce the width of i_lock or change the nesting rules in small obvious
steps, if any real problems are found with this nesting scheme. 

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/drop_caches.c          |    4 ++++
 fs/fs-writeback.c         |    4 ++++
 fs/inode.c                |   19 +++++++++++++++++++
 fs/notify/inode_mark.c    |    2 ++
 fs/quota/dquot.c          |    6 ++++++
 include/linux/writeback.h |    1 +
 6 files changed, 36 insertions(+)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/drop_caches.c	2010-10-19 14:19:38.000000000 +1100
@@ -17,18 +17,22 @@
 	struct inode *inode, *toput_inode = NULL;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
 		if (inode->i_mapping->nrpages == 0)
 			continue;
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
 		iput(toput_inode);
 		toput_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(toput_inode);
 }
Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:17:27.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:38.000000000 +1100
@@ -1029,6 +1029,7 @@
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 
 	/*
 	 * Data integrity sync. Must wait for all pages under writeback,
@@ -1046,6 +1047,7 @@
 		if (mapping->nrpages == 0)
 			continue;
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 		/*
 		 * We hold a reference to 'inode' so it couldn't have
@@ -1063,7 +1065,9 @@
 		cond_resched();
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 }
Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2010-10-19 14:18:58.000000000 +1100
+++ linux-2.6/fs/inode.c	2010-10-19 14:19:38.000000000 +1100
@@ -26,6 +26,15 @@
 #include <linux/posix_acl.h>
 
 /*
+ * Usage:
+ * sb_inode_list_lock protects:
+ *   s_inodes, i_sb_list
+ *
+ * Ordering:
+ * inode_lock
+ *   sb_inode_list_lock
+ */
+/*
  * This is needed for the following functions:
  *  - inode_has_buffers
  *  - invalidate_inode_buffers
@@ -83,6 +92,7 @@
  * the i_state of an inode while it is in use..
  */
 DEFINE_SPINLOCK(inode_lock);
+DEFINE_SPINLOCK(sb_inode_list_lock);
 
 /*
  * iprune_sem provides exclusion between the kswapd or try_to_free_pages
@@ -339,7 +349,9 @@
 
 		spin_lock(&inode_lock);
 		hlist_del_init(&inode->i_hash);
+		spin_lock(&sb_inode_list_lock);
 		list_del_init(&inode->i_sb_list);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		wake_up_inode(inode);
@@ -371,6 +383,7 @@
 		 * shrink_icache_memory() away.
 		 */
 		cond_resched_lock(&inode_lock);
+		cond_resched_lock(&sb_inode_list_lock);
 
 		next = next->next;
 		if (tmp == head)
@@ -408,8 +421,10 @@
 
 	down_write(&iprune_sem);
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	fsnotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 
 	dispose_list(&throw_away);
@@ -606,7 +621,9 @@
 {
 	inodes_stat.nr_inodes++;
 	list_add(&inode->i_list, &inode_in_use);
+	spin_lock(&sb_inode_list_lock);
 	list_add(&inode->i_sb_list, &sb->s_inodes);
+	spin_unlock(&sb_inode_list_lock);
 	if (head)
 		hlist_add_head(&inode->i_hash, head);
 }
@@ -1240,7 +1257,9 @@
 		hlist_del_init(&inode->i_hash);
 	}
 	list_del_init(&inode->i_list);
+	spin_lock(&sb_inode_list_lock);
 	list_del_init(&inode->i_sb_list);
+	spin_unlock(&sb_inode_list_lock);
 	WARN_ON(inode->i_state & I_NEW);
 	inode->i_state |= I_FREEING;
 	inodes_stat.nr_inodes--;
Index: linux-2.6/fs/quota/dquot.c
===================================================================
--- linux-2.6.orig/fs/quota/dquot.c	2010-10-19 14:17:27.000000000 +1100
+++ linux-2.6/fs/quota/dquot.c	2010-10-19 14:19:38.000000000 +1100
@@ -897,6 +897,7 @@
 #endif
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
 			continue;
@@ -910,6 +911,7 @@
 			continue;
 
 		__iget(inode);
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		iput(old_inode);
@@ -921,7 +923,9 @@
 		 * keep the reference and iput it later. */
 		old_inode = inode;
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 	iput(old_inode);
 
@@ -1004,6 +1008,7 @@
 	int reserved = 0;
 
 	spin_lock(&inode_lock);
+	spin_lock(&sb_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
 		/*
 		 *  We have to scan also I_NEW inodes because they can already
@@ -1017,6 +1022,7 @@
 			remove_inode_dquot_ref(inode, type, tofree_head);
 		}
 	}
+	spin_unlock(&sb_inode_list_lock);
 	spin_unlock(&inode_lock);
 #ifdef CONFIG_QUOTA_DEBUG
 	if (reserved) {
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h	2010-10-19 14:17:27.000000000 +1100
+++ linux-2.6/include/linux/writeback.h	2010-10-19 14:19:34.000000000 +1100
@@ -10,6 +10,7 @@
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
+extern spinlock_t sb_inode_list_lock;
 extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
Index: linux-2.6/fs/notify/inode_mark.c
===================================================================
--- linux-2.6.orig/fs/notify/inode_mark.c	2010-10-19 14:17:27.000000000 +1100
+++ linux-2.6/fs/notify/inode_mark.c	2010-10-19 14:19:38.000000000 +1100
@@ -283,6 +283,7 @@
 		 * will be added since the umount has begun.  Finally,
 		 * iprune_mutex keeps shrink_icache_memory() away.
 		 */
+		spin_unlock(&sb_inode_list_lock);
 		spin_unlock(&inode_lock);
 
 		if (need_iput_tmp)
@@ -296,5 +297,6 @@
 		iput(inode);
 
 		spin_lock(&inode_lock);
+		spin_lock(&sb_inode_list_lock);
 	}
 }


