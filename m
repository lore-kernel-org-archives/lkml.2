Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1GFLa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:30:28 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42518 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1GFLa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:30:26 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] fuse: fix flock
CC: fuse-devel@lists.sourceforge.net,
        Sebastian Pipping <webmaster@hartwork.org>
Date: Wed, 06 Jul 2011 13:30:23 +0200
Message-ID: <8739ij3auo.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Commit a9ff4f87 "fuse: support BSD locking semantics" overlooked a
number of issues with supporing flock locks over existing POSIX
locking infrastructure:

  - it's not backward compatible, passing flock(2) calls to userspace
    unconditionally (if userspace sets FUSE_POSIX_LOCKS)

  - it doesn't cater for the fact that flock locks are automatically
    unlocked on file release

  - it doesn't take into account the fact that flock exclusive locks
    (write locks) don't need an fd opened for write.

The last one invalidates the original premise of the patch that flock
locks can be emulated with POSIX locks.

This patch fixes the first two issues.  The last one needs to be fixed
in userspace if the filesystem assumed that a write lock will happen
only on a file operned for write (as in the case of the current fuse
library).

Reported-by: Sebastian Pipping <webmaster@hartwork.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c       |   11 ++++++++++-
 fs/fuse/fuse_i.h     |    8 +++++++-
 fs/fuse/inode.c      |    8 +++++++-
 include/linux/fuse.h |    9 ++++++++-
 4 files changed, 32 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2011-07-04 17:05:52.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2011-07-04 17:15:36.000000000 +0200
@@ -245,6 +245,12 @@ void fuse_release_common(struct file *fi
 	req = ff->reserved_req;
 	fuse_prepare_release(ff, file->f_flags, opcode);
 
+	if (ff->flock) {
+		struct fuse_release_in *inarg = &req->misc.release.in;
+		inarg->release_flags |= FUSE_RELEASE_FLOCK_UNLOCK;
+		inarg->lock_owner = fuse_lock_owner_id(ff->fc,
+						       (fl_owner_t) file);
+	}
 	/* Hold vfsmount and dentry until release is finished */
 	path_get(&file->f_path);
 	req->misc.release.path = file->f_path;
@@ -1547,11 +1553,14 @@ static int fuse_file_flock(struct file *
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (fc->no_lock) {
+	if (fc->no_flock) {
 		err = flock_lock_file_wait(file, fl);
 	} else {
+		struct fuse_file *ff = file->private_data;
+
 		/* emulate flock with POSIX locks */
 		fl->fl_owner = (fl_owner_t) file;
+		ff->flock = true;
 		err = fuse_setlk(file, fl, 1);
 	}
 
Index: linux-2.6/fs/fuse/fuse_i.h
===================================================================
--- linux-2.6.orig/fs/fuse/fuse_i.h	2011-07-04 17:05:52.000000000 +0200
+++ linux-2.6/fs/fuse/fuse_i.h	2011-07-04 17:06:05.000000000 +0200
@@ -135,6 +135,9 @@ struct fuse_file {
 
 	/** Wait queue head for poll */
 	wait_queue_head_t poll_wait;
+
+	/** Has flock been performed on this file? */
+	bool flock:1;
 };
 
 /** One input argument of a request */
@@ -448,7 +451,7 @@ struct fuse_conn {
 	/** Is removexattr not implemented by fs? */
 	unsigned no_removexattr:1;
 
-	/** Are file locking primitives not implemented by fs? */
+	/** Are posix file locking primitives not implemented by fs? */
 	unsigned no_lock:1;
 
 	/** Is access not implemented by fs? */
@@ -472,6 +475,9 @@ struct fuse_conn {
 	/** Don't apply umask to creation modes */
 	unsigned dont_mask:1;
 
+	/** Are BSD file locking primitives not implemented by fs? */
+	unsigned no_flock:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
Index: linux-2.6/fs/fuse/inode.c
===================================================================
--- linux-2.6.orig/fs/fuse/inode.c	2011-07-04 17:05:52.000000000 +0200
+++ linux-2.6/fs/fuse/inode.c	2011-07-04 17:32:34.000000000 +0200
@@ -809,6 +809,10 @@ static void process_init_reply(struct fu
 				fc->async_read = 1;
 			if (!(arg->flags & FUSE_POSIX_LOCKS))
 				fc->no_lock = 1;
+			if (arg->minor >= 17) {
+				if (!(arg->flags & FUSE_FLOCK_LOCKS))
+				    fc->no_flock = 1;
+			}
 			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
 				fc->atomic_o_trunc = 1;
 			if (arg->minor >= 9) {
@@ -823,6 +827,7 @@ static void process_init_reply(struct fu
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
+			fc->no_flock = 1;
 		}
 
 		fc->bdi.ra_pages = min(fc->bdi.ra_pages, ra_pages);
@@ -843,7 +848,8 @@ static void fuse_send_init(struct fuse_c
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
 	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC |
-		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES | FUSE_DONT_MASK;
+		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES | FUSE_DONT_MASK |
+		FUSE_FLOCK_LOCKS;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
Index: linux-2.6/include/linux/fuse.h
===================================================================
--- linux-2.6.orig/include/linux/fuse.h	2011-07-04 17:05:52.000000000 +0200
+++ linux-2.6/include/linux/fuse.h	2011-07-05 14:09:06.000000000 +0200
@@ -47,6 +47,9 @@
  *  - FUSE_IOCTL_UNRESTRICTED shall now return with array of 'struct
  *    fuse_ioctl_iovec' instead of ambiguous 'struct iovec'
  *  - add FUSE_IOCTL_32BIT flag
+ *
+ * 7.17
+ *  - add FUSE_FLOCK_LOCKS and FUSE_RELEASE_FLOCK_UNLOCK
  */
 
 #ifndef _LINUX_FUSE_H
@@ -78,7 +81,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 16
+#define FUSE_KERNEL_MINOR_VERSION 17
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -153,8 +156,10 @@ struct fuse_file_lock {
 /**
  * INIT request/reply flags
  *
+ * FUSE_POSIX_LOCKS: remote locking for POSIX file locks
  * FUSE_EXPORT_SUPPORT: filesystem handles lookups of "." and ".."
  * FUSE_DONT_MASK: don't apply umask to file mode on create operations
+ * FUSE_FLOCK_LOCKS: remote locking for BSD style file locks
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -163,6 +168,7 @@ struct fuse_file_lock {
 #define FUSE_EXPORT_SUPPORT	(1 << 4)
 #define FUSE_BIG_WRITES		(1 << 5)
 #define FUSE_DONT_MASK		(1 << 6)
+#define FUSE_FLOCK_LOCKS	(1 << 10)
 
 /**
  * CUSE INIT request/reply flags
@@ -175,6 +181,7 @@ struct fuse_file_lock {
  * Release flags
  */
 #define FUSE_RELEASE_FLUSH	(1 << 0)
+#define FUSE_RELEASE_FLOCK_UNLOCK	(1 << 1)
 
 /**
  * Getattr flags
