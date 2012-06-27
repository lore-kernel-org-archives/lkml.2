Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2F0BvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:51:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46543 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2F0BvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:51:17 -0400
From: Filipe Brandenburger <filbranden@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@gmail.com>
Subject: [PATCH v2 1/1] locks: prevent side-effects of locks_release_private before file_lock is initialized
Date: Tue, 26 Jun 2012 21:50:48 -0400
Message-Id: <1340761848-1352-1-git-send-email-filbranden@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
References: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling fcntl(F_SETLEASE) for a second time on the same file descriptor,
do_fcntl_add_lease will allocate and initialize a new file_lock to pass to
__vfs_setlease. If that function decides to reuse the existing file_lock, it
will free the newly allocated one to prevent leaking memory.

However, the newly allocate file_lock was initialized with a valid file
descriptor pointer and fl_lmops that contains a lm_release_private function,
so calling locks_free_lock will trigger a call to lease_release_private_callback
which will clear the fcntl(F_SETOWN) and fcntl(F_SETSIG) settings for the file
descriptor even though the lease is not really being cleared at that point (as
only the temporary file_lock is being freed.)

This patch will fix this bug by calling kmem_cache_free directly instead of
locks_free_lock if the file_lock will not be used. This will end up avoiding
the call to lease_release_private_callback.

This bug was tracked in kernel.org Bugzilla database:
https://bugzilla.kernel.org/show_bug.cgi?id=43336

Signed-off-by: Filipe Brandenburger <filbranden@gmail.com>
---
 fs/locks.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 814c51d..2a751d8 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -473,7 +473,10 @@ static struct file_lock *lease_alloc(struct file *filp, int type)
 
 	error = lease_init(filp, type, fl);
 	if (error) {
-		locks_free_lock(fl);
+		/* Free the lock by hand instead of calling locks_free_lock
+		 * to prevent the call back to lease_release_private_callback
+		 */
+		kmem_cache_free(filelock_cache, fl);
 		return ERR_PTR(error);
 	}
 	return fl;
@@ -1538,19 +1541,28 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
 
 	new = fasync_alloc();
 	if (!new) {
-		locks_free_lock(fl);
+		/* Free the lock by hand instead of calling locks_free_lock
+		 * to prevent the call back to lease_release_private_callback
+		 */
+		kmem_cache_free(filelock_cache, fl);
 		return -ENOMEM;
 	}
 	ret = fl;
 	lock_flocks();
 	error = __vfs_setlease(filp, arg, &ret);
+	if (error || ret != fl)
+		/*
+		 * Free the lock by hand instead of calling locks_free_lock
+		 * to prevent the call back to lease_release_private_callback
+		 * which will unset F_SETOWN and F_SETSIG for the file
+		 * descriptor but that is not wanted as the lease was not
+		 * really in use.
+		 */
+		kmem_cache_free(filelock_cache, fl);
 	if (error) {
 		unlock_flocks();
-		locks_free_lock(fl);
 		goto out_free_fasync;
 	}
-	if (ret != fl)
-		locks_free_lock(fl);
 
 	/*
 	 * fasync_insert_entry() returns the old entry if any.
-- 
1.7.7.6

