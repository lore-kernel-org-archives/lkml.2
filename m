Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2LTMbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:31:16 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:20432 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab2LTMbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:31:10 -0500
Subject: [PATCH 1/5] fuse: add close_wait flag to fuse_conn
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Date: Thu, 20 Dec 2012 16:31:13 +0400
Message-ID: <20121220123054.4101.82521.stgit@maximpc.sw.ru>
In-Reply-To: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The feature will be governed by fc->close_wait. Userspace can enable it in
the same way as auto_inval_data or any other kernel fuse capability.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/fuse_i.h          |    3 +++
 fs/fuse/inode.c           |    5 ++++-
 include/uapi/linux/fuse.h |    7 ++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e24dd74..156ad75 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -487,6 +487,9 @@ struct fuse_conn {
 	/** Use enhanced/automatic page cache invalidation. */
 	unsigned auto_inval_data:1;
 
+	/** Wait for response from daemon on close */
+	unsigned close_wait:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f0eda12..ac685f7 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -859,6 +859,8 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 				fc->dont_mask = 1;
 			if (arg->flags & FUSE_AUTO_INVAL_DATA)
 				fc->auto_inval_data = 1;
+			if (arg->flags & FUSE_CLOSE_WAIT)
+				fc->close_wait = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -885,7 +887,8 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC |
 		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES | FUSE_DONT_MASK |
 		FUSE_SPLICE_WRITE | FUSE_SPLICE_MOVE | FUSE_SPLICE_READ |
-		FUSE_FLOCK_LOCKS | FUSE_IOCTL_DIR | FUSE_AUTO_INVAL_DATA;
+		FUSE_FLOCK_LOCKS | FUSE_IOCTL_DIR | FUSE_AUTO_INVAL_DATA |
+		FUSE_CLOSE_WAIT;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index d8c713e..b99d720 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -60,6 +60,9 @@
  *
  * 7.20
  *  - add FUSE_AUTO_INVAL_DATA
+ *
+ * 7.21
+ *  - add FUSE_CLOSE_WAIT
  */
 
 #ifndef _LINUX_FUSE_H
@@ -91,7 +94,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 20
+#define FUSE_KERNEL_MINOR_VERSION 21
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -179,6 +182,7 @@ struct fuse_file_lock {
  * FUSE_FLOCK_LOCKS: remote locking for BSD style file locks
  * FUSE_HAS_IOCTL_DIR: kernel supports ioctl on directories
  * FUSE_AUTO_INVAL_DATA: automatically invalidate cached pages
+ * FUSE_CLOSE_WAIT: wait for response from daemon on close
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -193,6 +197,7 @@ struct fuse_file_lock {
 #define FUSE_FLOCK_LOCKS	(1 << 10)
 #define FUSE_HAS_IOCTL_DIR	(1 << 11)
 #define FUSE_AUTO_INVAL_DATA	(1 << 12)
+#define FUSE_CLOSE_WAIT		(1 << 14)
 
 /**
  * CUSE INIT request/reply flags

