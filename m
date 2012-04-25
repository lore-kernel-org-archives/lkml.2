Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab2DYPWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:22:22 -0400
Received: from fieldses.org ([174.143.236.118]:51428 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab2DYPWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:22:15 -0400
From: bfields@fieldses.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5/5] vfs: change nondirectory i_mutex ordering to fix quota deadlock
Date: Wed, 25 Apr 2012 11:22:09 -0400
Message-Id: <1335367329-929-5-git-send-email-bfields@fieldses.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20120418215238.GA11959@fieldses.org>
References: <20120418215238.GA11959@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

A write can take an i_mutex on a quota file while holding the i_mutex on
the file being written to.

And both rename and fs/ext4/move_extent.c:mext_inode_double_lock() can
also take the i_mutex on two regular files.

Either of those could take locks in opposite order from a quota file
write, and end up deadlocked.

Changing the locking order in the quota-update-while-writing case looks
hard.  So, instead, change the order in the mext_inode_double_lock()
case so that the i_mutex is always taken on a quota file after being
taken on a file that isn't a quota file.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 Documentation/filesystems/directory-locking |   25 +++++++++++++++----------
 fs/inode.c                                  |   13 ++++++++++++-
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/directory-locking b/Documentation/filesystems/directory-locking
index 9e8a629..022d94f 100644
--- a/Documentation/filesystems/directory-locking
+++ b/Documentation/filesystems/directory-locking
@@ -3,8 +3,12 @@ kinds of locks - per-inode (->i_mutex) and per-filesystem
 (->s_vfs_rename_mutex).
 
 	When taking the i_mutex on multiple non-directory objects, we
-always acquire the locks in order by increasing address.  We'll call
-that "inode pointer" order in the following.
+always acquire them in the following order (which we'll call "the usual
+order" in the following):
+
+	* non-IS_NOQUOTA inodes before IS_NOQUOTA inodes
+	* within each category, inodes with smaller addresses before
+	  inodes with larger addresses
 
 	For our purposes all operations fall in 5 classes:
 
@@ -17,7 +21,7 @@ locks victim and calls the method.
 
 4) rename() that is _not_ cross-directory.  Locking rules: caller locks
 the parent and finds source and target.  If source and target both
-exist, they are locked in inode pointer order.  Otherwise lock just
+exist, they are locked in the usual order.  Otherwise lock just
 source.  Then call method.
 
 5) link creation.  Locking rules:
@@ -35,8 +39,8 @@ rules:
 		fail with -ENOTEMPTY
 	* if new parent is equal to or is a descendent of source
 		fail with -ELOOP
-	* If target exists, lock both source and target, in inode
-	  pointer order.  Otherwise lock just source.
+	* If target exists, lock both source and target, in the
+	  usual order.  Otherwise lock just source.
 	* call the method.
 
 
@@ -63,10 +67,10 @@ objects - A < B iff A is an ancestor of B.
     the order until we had acquired all locks).
 
 (3) locks on non-directory objects are acquired only after locks on
-    directory objects, and are acquired in inode pointer order.
+    directory objects, and are acquired in the usual order.
     (Proof: all operations but renames take lock on at most one
     non-directory object, except renames, which take locks on source and
-    target in inode pointer order.)
+    target in the usual order.)
 
 	Now consider the minimal deadlock.  Each process is blocked on
 attempt to acquire some lock and already holds at least one lock.  Let's
@@ -75,9 +79,10 @@ not contended, since any process blocked on it is not holding any locks.
 Thus all processes are blocked on ->i_mutex.
 
 	By (3), any process holding a non-directory lock can only be
-waiting on another non-directory lock with a larger address.  Therefore
-the process holding the "largest" such lock can always make progress, and
-non-directory objects are not included in the set of contended locks.
+waiting on another non-directory that is "larger" in the usual order.
+Therefore the process holding the "largest" such lock can always make
+progress, and non-directory objects are not included in the set of
+contended locks.
 
 	Thus link creation can't be a part of deadlock - it can't be
 blocked on source and it means that it doesn't hold any locks.
diff --git a/fs/inode.c b/fs/inode.c
index 487c924..13d23b6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -961,6 +961,17 @@ void unlock_new_inode(struct inode *inode)
 }
 EXPORT_SYMBOL(unlock_new_inode);
 
+/*
+ * We order !IS_NOQUOTA files before ISNOQUOTA files, and by pointer
+ * within each category.
+ */
+static bool nondir_mutex_ordered(struct inode *inode1, struct inode *inode2)
+{
+	if (IS_NOQUOTA(inode1) == IS_NOQUOTA(inode2))
+		return inode1 < inode2;
+	return IS_NOQUOTA(inode2);
+}
+
 /**
  * lock_two_nondirectories - take two i_mutexes on non-directory objects
  * @inode1: first inode to lock; must be non-NULL
@@ -970,7 +981,7 @@ void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
 {
 	if (inode1 == inode2 || inode2 == NULL)
 		mutex_lock(&inode1->i_mutex);
-	else if (inode1 < inode2) {
+	else if (nondir_mutex_ordered(inode1, inode2)) {
 		mutex_lock(&inode1->i_mutex);
 		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_QUOTA);
 
-- 
1.7.5.4

