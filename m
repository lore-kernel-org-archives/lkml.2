Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645Ab1CEBIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:08:42 -0500
Received: from kroah.org ([198.145.64.141]:47681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760563Ab1CEBFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 17:03:52 2011
Message-Id: <20110305010352.308656138@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 17:02:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [05/18] fuse: fix hang of single threaded fuseblk filesystem
In-Reply-To: <20110305010410.GA18668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 fs/fuse/file.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h |    6 +++++-
 2 files changed, 50 insertions(+), 8 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -86,18 +86,52 @@ struct fuse_file *fuse_file_get(struct f
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
@@ -219,8 +253,12 @@ void fuse_release_common(struct file *fi
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
@@ -549,7 +587,7 @@ static void fuse_readpages_end(struct fu
 		unlock_page(page);
 	}
 	if (req->ff)
-		fuse_file_put(req->ff);
+		fuse_file_put(req->ff, false);
 }
 
 static void fuse_send_readpages(struct fuse_req *req, struct file *file)
@@ -1129,7 +1167,7 @@ static ssize_t fuse_direct_write(struct
 static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 {
 	__free_page(req->pages[0]);
-	fuse_file_put(req->ff);
+	fuse_file_put(req->ff, false);
 }
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -21,6 +21,7 @@
 #include <linux/rwsem.h>
 #include <linux/rbtree.h>
 #include <linux/poll.h>
+#include <linux/workqueue.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -254,7 +255,10 @@ struct fuse_req {
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


