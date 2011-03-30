Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258Ab1C3VcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:32:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964995Ab1C3VIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133549"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mszeredi@suse.cz, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [163/275] fuse: fix hang of single threaded fuseblk filesystem
Message-Id: <20110330210645.58B543E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Miklos Szeredi <mszeredi@suse.cz>

commit 5a18ec176c934ca1bc9dc61580a5e0e90a9b5733 upstream.

Single threaded NTFS-3G could get stuck if a delayed RELEASE reply
triggered a DESTROY request via path_put().

Fix this by

 a) making RELEASE requests synchronous, whenever possible, on fuseblk
 filesystems

 b) if not possible (triggered by an asynchronous read/write) then do
 the path_put() in a separate thread with schedule_work().

Reported-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/fuse/file.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h |    6 +++++-
 2 files changed, 50 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/fs/fuse/file.c
===================================================================
--- linux-2.6.35.y.orig/fs/fuse/file.c	2011-03-29 22:50:59.901725684 -0700
+++ linux-2.6.35.y/fs/fuse/file.c	2011-03-29 23:03:01.641258175 -0700
@@ -86,18 +86,52 @@
 	return ff;
 }
 
+static void fuse_release_async(struct work_struct *work)
+{
+	struct fuse_req *req;
+	struct fuse_conn *fc;
+	struct path path;
+
+	req = container_of(work, struct fuse_req, misc.release.work);
+	path = req->misc.release.path;
+	fc = get_fuse_conn(path.dentry->d_inode);
+
+	fuse_put_request(fc, req);
+	path_put(&path);
+}
+
 static void fuse_release_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	path_put(&req->misc.release.path);
+	if (fc->destroy_req) {
+		/*
+		 * If this is a fuseblk mount, then it's possible that
+		 * releasing the path will result in releasing the
+		 * super block and sending the DESTROY request.  If
+		 * the server is single threaded, this would hang.
+		 * For this reason do the path_put() in a separate
+		 * thread.
+		 */
+		atomic_inc(&req->count);
+		INIT_WORK(&req->misc.release.work, fuse_release_async);
+		schedule_work(&req->misc.release.work);
+	} else {
+		path_put(&req->misc.release.path);
+	}
 }
 
-static void fuse_file_put(struct fuse_file *ff)
+static void fuse_file_put(struct fuse_file *ff, bool sync)
 {
 	if (atomic_dec_and_test(&ff->count)) {
 		struct fuse_req *req = ff->reserved_req;
 
-		req->end = fuse_release_end;
-		fuse_request_send_background(ff->fc, req);
+		if (sync) {
+			fuse_request_send(ff->fc, req);
+			path_put(&req->misc.release.path);
+			fuse_put_request(ff->fc, req);
+		} else {
+			req->end = fuse_release_end;
+			fuse_request_send_background(ff->fc, req);
+		}
 		kfree(ff);
 	}
 }
@@ -219,8 +253,12 @@
 	 * Normally this will send the RELEASE request, however if
 	 * some asynchronous READ or WRITE requests are outstanding,
 	 * the sending will be delayed.
+	 *
+	 * Make the release synchronous if this is a fuseblk mount,
+	 * synchronous RELEASE is allowed (and desirable) in this case
+	 * because the server can be trusted not to screw up.
 	 */
-	fuse_file_put(ff);
+	fuse_file_put(ff, ff->fc->destroy_req != NULL);
 }
 
 static int fuse_open(struct inode *inode, struct file *file)
@@ -558,7 +596,7 @@
 		page_cache_release(page);
 	}
 	if (req->ff)
-		fuse_file_put(req->ff);
+		fuse_file_put(req->ff, false);
 }
 
 static void fuse_send_readpages(struct fuse_req *req, struct file *file)
@@ -1137,7 +1175,7 @@
 static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 {
 	__free_page(req->pages[0]);
-	fuse_file_put(req->ff);
+	fuse_file_put(req->ff, false);
 }
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
Index: linux-2.6.35.y/fs/fuse/fuse_i.h
===================================================================
--- linux-2.6.35.y.orig/fs/fuse/fuse_i.h	2011-03-29 22:50:59.901725684 -0700
+++ linux-2.6.35.y/fs/fuse/fuse_i.h	2011-03-29 23:03:01.642258149 -0700
@@ -21,6 +21,7 @@
 #include <linux/rwsem.h>
 #include <linux/rbtree.h>
 #include <linux/poll.h>
+#include <linux/workqueue.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -257,7 +258,10 @@
 	union {
 		struct fuse_forget_in forget_in;
 		struct {
-			struct fuse_release_in in;
+			union {
+				struct fuse_release_in in;
+				struct work_struct work;
+			};
 			struct path path;
 		} release;
 		struct fuse_init_in init_in;
