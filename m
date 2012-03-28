Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2C1R5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 13:57:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52859 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab2C1R5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 13:57:20 -0400
From: Pavel Shilovsky <piastry@etersoft.ru>
To: linux-cifs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] CIFS: Fix VFS lock usage for oplocked files
Date: Wed, 28 Mar 2012 21:56:19 +0400
Message-Id: <1332957379-5922-1-git-send-email-piastry@etersoft.ru>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can deadlock if we have a write oplock and two processes
use the same file handle. In this case the first process can't
unlock its lock if the second process blocked on the lock in the
same time.

Fix it by using posix_lock_file rather than posix_lock_file_wait
under cinode->lock_mutex. If we request a blocking lock and
posix_lock_file indicates that there is another lock that prevents
us, wait untill that lock is released and restart our call.

Cc: stable@kernel.org
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
---
 fs/cifs/file.c     |   10 +++++++++-
 fs/locks.c         |    3 ++-
 include/linux/fs.h |    5 +++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 460d87b..fae765d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -835,13 +835,21 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
 	if ((flock->fl_flags & FL_POSIX) == 0)
 		return rc;
 
+try_again:
 	mutex_lock(&cinode->lock_mutex);
 	if (!cinode->can_cache_brlcks) {
 		mutex_unlock(&cinode->lock_mutex);
 		return rc;
 	}
-	rc = posix_lock_file_wait(file, flock);
+
+	rc = posix_lock_file(file, flock, NULL);
 	mutex_unlock(&cinode->lock_mutex);
+	if (rc == FILE_LOCK_DEFERRED) {
+		rc = wait_event_interruptible(flock->fl_wait, !flock->fl_next);
+		if (!rc)
+			goto try_again;
+		locks_delete_block(flock);
+	}
 	return rc;
 }
 
diff --git a/fs/locks.c b/fs/locks.c
index 637694b..0d68f1f 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -510,12 +510,13 @@ static void __locks_delete_block(struct file_lock *waiter)
 
 /*
  */
-static void locks_delete_block(struct file_lock *waiter)
+void locks_delete_block(struct file_lock *waiter)
 {
 	lock_flocks();
 	__locks_delete_block(waiter);
 	unlock_flocks();
 }
+EXPORT_SYMBOL(locks_delete_block);
 
 /* Insert waiter into blocker's block list.
  * We use a circular list so that processes can be easily woken up in
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fa63f1b..d8fd8df 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1211,6 +1211,7 @@ extern int vfs_setlease(struct file *, long, struct file_lock **);
 extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
+extern void locks_delete_block(struct file_lock *waiter);
 extern void lock_flocks(void);
 extern void unlock_flocks(void);
 #else /* !CONFIG_FILE_LOCKING */
@@ -1355,6 +1356,10 @@ static inline int lock_may_write(struct inode *inode, loff_t start,
 	return 1;
 }
 
+static inline void locks_delete_block(struct file_lock *waiter)
+{
+}
+
 static inline void lock_flocks(void)
 {
 }
-- 
1.7.1

