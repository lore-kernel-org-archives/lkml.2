Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab2DKX4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:56:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826Ab2DKXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:17:19 -0400
Message-Id: <20120411231026.970050886@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <sfrench@us.ibm.com>
Subject: [ 51/78] CIFS: Fix VFS lock usage for oplocked files
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit 66189be74ff5f9f3fd6444315b85be210d07cef2 upstream.

We can deadlock if we have a write oplock and two processes
use the same file handle. In this case the first process can't
unlock its lock if the second process blocked on the lock in the
same time.

Fix it by using posix_lock_file rather than posix_lock_file_wait
under cinode->lock_mutex. If we request a blocking lock and
posix_lock_file indicates that there is another lock that prevents
us, wait untill that lock is released and restart our call.

Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c     |   10 +++++++++-
 fs/locks.c         |    3 ++-
 include/linux/fs.h |    5 +++++
 3 files changed, 16 insertions(+), 2 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -835,13 +835,21 @@ cifs_posix_lock_set(struct file *file, s
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
 
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -510,12 +510,13 @@ static void __locks_delete_block(struct
 
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
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1210,6 +1210,7 @@ extern int vfs_setlease(struct file *, l
 extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
+extern void locks_delete_block(struct file_lock *waiter);
 extern void lock_flocks(void);
 extern void unlock_flocks(void);
 #else /* !CONFIG_FILE_LOCKING */
@@ -1354,6 +1355,10 @@ static inline int lock_may_write(struct
 	return 1;
 }
 
+static inline void locks_delete_block(struct file_lock *waiter)
+{
+}
+
 static inline void lock_flocks(void)
 {
 }


