Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0JUAu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:50:59 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:39412 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756403Ab0JUAux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:53 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 17/21] fs: protect wake_up_inode with inode->i_lock
Date: Thu, 21 Oct 2010 11:49:42 +1100
Message-Id: <1287622186-1935-18-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently we have an optimisation in place in unlock_new_inode() to
avoid taking the inode_lock. This uses memory barriers to ensure
that the the clearing of I_NEW can be seen by all other CPUs. It
also means the wake_up_inode() call relies on a memory barrier to
ensure that processes it is waking see any changes the i_state field
prior to the wakeup being issued.

This serialisation is also necessary to protect the inode against
lookup/freeing races once the inode_lock is removed. The current
lookup and wait code is atomic as it is all performed under the
inode_lock, while the modified code now splits the locks. Hence we
can get the following race:

Thread 1:				Thread 2:
					iput_final
					spin_lock(&inode->i_lock);
hlist_bl_lock()
  Find inode
    spin_lock(&inode->i_lock)
					......
					inode->i_state = I_FREEING;
					spin_unlock(&inode->i_lock);
					remove_inode_hash()
					   hlist_bl_lock()
    ......
    if (I_FREEING)
	hlist_bl_unlock()
					   ......
					   hlist_bl_del_init()
					   hlist_bl_unlock()
					wake_up_inode()

	__wait_on_freeing_inode()
	  put on waitqueue
	  spin_unlock(&inode->i_lock);
	  schedule()

To avoid this race, wake ups need to be serialised against the
waiters, and using inode->i_lock is the natural solution.

The memory barrier optimisation is no longer needed to avoid the
global inode_lock contention as the inode->i_state field is now
protected by inode->i_lock. Hence we can revert the code to a much
simpler form and correctly serialise wake ups against
__wait_on_freeing_inode() by holding the inode->i_lock while we do
the wakeup.

Given the newfound simplicity of wake_up_inode() and the fact that
we need to change i_state in unlock_new_inode() before the wakeup,
just open code the wakeup in the couple of spots it is used and
remove wake_up_inode() entirely.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   41 ++++++++++++++++++-----------------------
 1 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 32bac58..ba514a1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -175,15 +175,6 @@ int proc_nr_inodes(ctl_table *table, int write,
 }
 #endif
 
-static void wake_up_inode(struct inode *inode)
-{
-	/*
-	 * Prevent speculative execution through spin_unlock(&inode->i_lock);
-	 */
-	smp_mb();
-	wake_up_bit(&inode->i_state, __I_NEW);
-}
-
 /**
  * inode_init_always - perform inode structure intialisation
  * @sb: superblock inode belongs to
@@ -540,7 +531,9 @@ static void dispose_list(struct list_head *head)
 		__inode_sb_list_del(inode);
 		spin_unlock(&inode_lock);
 
-		wake_up_inode(inode);
+		spin_lock(&inode->i_lock);
+		wake_up_bit(&inode->i_state, __I_NEW);
+		spin_unlock(&inode->i_lock);
 		destroy_inode(inode);
 	}
 }
@@ -862,6 +855,13 @@ struct inode *new_inode(struct super_block *sb)
 }
 EXPORT_SYMBOL(new_inode);
 
+/**
+ * unlock_new_inode - clear the I_NEW state and wake up any waiters
+ * @inode:	new inode to unlock
+ *
+ * Called when the inode is fully initialised to clear the new state of the
+ * inode and wake up anyone waiting for the inode to finish initialisation.
+ */
 void unlock_new_inode(struct inode *inode)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -881,19 +881,11 @@ void unlock_new_inode(struct inode *inode)
 		}
 	}
 #endif
-	/*
-	 * This is special!  We do not need the spinlock when clearing I_NEW,
-	 * because we're guaranteed that nobody else tries to do anything about
-	 * the state of the inode when it is locked, as we just created it (so
-	 * there can be no old holders that haven't tested I_NEW).
-	 * However we must emit the memory barrier so that other CPUs reliably
-	 * see the clearing of I_NEW after the other inode initialisation has
-	 * completed.
-	 */
-	smp_mb();
+	spin_lock(&inode->i_lock);
 	WARN_ON(!(inode->i_state & I_NEW));
 	inode->i_state &= ~I_NEW;
-	wake_up_inode(inode);
+	wake_up_bit(&inode->i_state, __I_NEW);
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(unlock_new_inode);
 
@@ -1486,8 +1478,10 @@ static void iput_final(struct inode *inode)
 	spin_unlock(&inode_lock);
 	evict(inode);
 	remove_inode_hash(inode);
-	wake_up_inode(inode);
+	spin_lock(&inode->i_lock);
+	wake_up_bit(&inode->i_state, __I_NEW);
 	BUG_ON(inode->i_state != (I_FREEING | I_CLEAR));
+	spin_unlock(&inode->i_lock);
 	destroy_inode(inode);
 }
 
@@ -1690,7 +1684,8 @@ EXPORT_SYMBOL(inode_wait);
  * to recheck inode state.
  *
  * It doesn't matter if I_NEW is not set initially, a call to
- * wake_up_inode() after removing from the hash list will DTRT.
+ * wake_up_bit(&inode->i_state, __I_NEW) with the i_lock held after removing
+ * from the hash list will DTRT.
  *
  * This is called with inode_lock held.
  *
-- 
1.7.1

