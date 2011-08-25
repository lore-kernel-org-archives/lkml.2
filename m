Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1HYBiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 21:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1HYBiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 21:38:01 -0400
Date: Wed, 24 Aug 2011 21:37:47 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC] lockdep: Add helper function for dir vs file i_mutex annotation
Message-ID: <20110825013746.GM2270@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below is an attempt to take Linus' option (c) from this thread:
https://lkml.org/lkml/2011/4/15/272

and make it work.  Given that the helper function calls
lockdep_match_key and that isn't defined unless CONFIG_DEBUG_LOCK_ALLOC
is set, I opted to make the caller require #ifdefing it still.  If that's
too ugly, I could define it in both cases but then we'd have an exported
symbol that did nothing when the config option is disabled.

I'm looking at this because of
https://bugzilla.redhat.com/show_bug.cgi?id=730998 but it also seems
like an issue that just keeps hanging around.

Comments/flames appreciated.

josh

From: Josh Boyer <jwboyer@redhat.com>
Date: Wed, 24 Aug 2011 21:07:56 -0400
Subject: [PATCH] lockdep: Add helper function for dir vs file i_mutex
 annotation

Purely in-memory filesystems do not use the inode hash as the dcache tells
us if an entry already exists.  As a result, they do not call
unlock_new_inode.  If CONFIG_DEBUG_LOCK_ALLOC is set, this can lead to
false positives from lockdep like below:

| find/645 is trying to acquire lock:
|  (&mm->mmap_sem){++++++}, at: [<ffffffff81109514>] might_fault+0x5c/0xac
|
| but task is already holding lock:
|  (&sb->s_type->i_mutex_key#15){+.+.+.}, at: [<ffffffff81149f34>]
| vfs_readdir+0x5b/0xb4
|
| which lock already depends on the new lock.
|
| the existing dependency chain (in reverse order) is:
|
| -> #1 (&sb->s_type->i_mutex_key#15){+.+.+.}:
|       [<ffffffff8108ac26>] lock_acquire+0xbf/0x103
|       [<ffffffff814db822>] __mutex_lock_common+0x4c/0x361
|       [<ffffffff814dbc46>] mutex_lock_nested+0x40/0x45
|       [<ffffffff811daa87>] hugetlbfs_file_mmap+0x82/0x110
|       [<ffffffff81111557>] mmap_region+0x258/0x432
|       [<ffffffff811119dd>] do_mmap_pgoff+0x2ac/0x306
|       [<ffffffff81111b4f>] sys_mmap_pgoff+0x118/0x16a
|       [<ffffffff8100c858>] sys_mmap+0x22/0x24
|       [<ffffffff814e3ec2>] system_call_fastpath+0x16/0x1b
|
| -> #0 (&mm->mmap_sem){++++++}:
|       [<ffffffff8108a4bc>] __lock_acquire+0xa1a/0xcf7
|       [<ffffffff8108ac26>] lock_acquire+0xbf/0x103
|       [<ffffffff81109541>] might_fault+0x89/0xac
|       [<ffffffff81149cff>] filldir+0x6f/0xc7
|       [<ffffffff811586ea>] dcache_readdir+0x67/0x205
|       [<ffffffff81149f54>] vfs_readdir+0x7b/0xb4
|       [<ffffffff8114a073>] sys_getdents+0x7e/0xd1
|       [<ffffffff814e3ec2>] system_call_fastpath+0x16/0x1b

This moves the directory vs file lockdep annotation into a helper function
that can be called by in-memory filesystems and has hugetlbfs call it.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 fs/hugetlbfs/inode.c |    3 +++
 fs/inode.c           |   26 +++++++++++++++++---------
 include/linux/fs.h   |    3 +++
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 87b6e04..ab956c8 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -491,6 +491,9 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb, uid_t uid,
 			inode->i_op = &page_symlink_inode_operations;
 			break;
 		}
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+		lockdep_annotate_inode_mutex_key(inode);
+#endif
 	}
 	return inode;
 }
diff --git a/fs/inode.c b/fs/inode.c
index 73920d5..ec1c612 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -848,16 +848,9 @@ struct inode *new_inode(struct super_block *sb)
 }
 EXPORT_SYMBOL(new_inode);
 
-/**
- * unlock_new_inode - clear the I_NEW state and wake up any waiters
- * @inode:	new inode to unlock
- *
- * Called when the inode is fully initialised to clear the new state of the
- * inode and wake up anyone waiting for the inode to finish initialisation.
- */
-void unlock_new_inode(struct inode *inode)
-{
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+void lockdep_annotate_inode_mutex_key(struct inode *inode)
+{
 	if (S_ISDIR(inode->i_mode)) {
 		struct file_system_type *type = inode->i_sb->s_type;
 
@@ -873,6 +866,21 @@ void unlock_new_inode(struct inode *inode)
 					  &type->i_mutex_dir_key);
 		}
 	}
+}
+EXPORT_SYMBOL(lockdep_annotate_inode_mutex_key);
+#endif
+
+/**
+ * unlock_new_inode - clear the I_NEW state and wake up any waiters
+ * @inode:	new inode to unlock
+ *
+ * Called when the inode is fully initialised to clear the new state of the
+ * inode and wake up anyone waiting for the inode to finish initialisation.
+ */
+void unlock_new_inode(struct inode *inode)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_annotate_inode_mutex_key(inode);
 #endif
 	spin_lock(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_NEW));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 178cdb4..a29f9af 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2318,6 +2318,9 @@ extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*te
 extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern void lockdep_annotate_inode_mutex_key(struct inode *inode);
+#endif
 extern void unlock_new_inode(struct inode *);
 extern unsigned int get_next_ino(void);
 
-- 
1.7.6

