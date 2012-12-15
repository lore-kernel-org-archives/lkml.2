Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945914Ab2LOAyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:54:52 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:48670 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab2LOAyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:54:50 -0500
Date: Sat, 15 Dec 2012 00:54:48 +0000
From: Eric Wong <normalperson@yhbt.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fadvise: perform WILLNEED readahead in a workqueue
Message-ID: <20121215005448.GA7698@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applications streaming large files may want to reduce disk spinups and
I/O latency by performing large amounts of readahead up front.
Applications also tend to read files soon after opening them, so waiting
on a slow fadvise may cause unpleasant latency when the application
starts reading the file.

As a userspace hacker, I'm sometimes tempted to create a background
thread in my app to run readahead().  However, I believe doing this
in the kernel will make life easier for other userspace hackers.

Since fadvise makes no guarantees about when (or even if) readahead
is performed, this change should not hurt existing applications.

"strace -T" timing on an uncached, one gigabyte file:

 Before: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <2.484832>
  After: fadvise64(3, 0, 0, POSIX_FADV_WILLNEED) = 0 <0.000061>

Signed-off-by: Eric Wong <normalperson@yhbt.net>
---
 N.B.: I'm not sure if I'm misusing any kernel APIs here.  I managed to
 compile, boot, and run fadvise in a loop without anything blowing up.
 I've verified readahead gets performed via mincore().

 If the workqueue approach is acceptable, I'll proceed with
 changing MADV_WILLNEED, too.

 include/linux/mm.h |    3 +++
 mm/fadvise.c       |   10 ++++-----
 mm/readahead.c     |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bcaab4e..17ab7d3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1473,6 +1473,9 @@ void task_dirty_inc(struct task_struct *tsk);
 #define VM_MAX_READAHEAD	128	/* kbytes */
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
 
+void wq_page_cache_readahead(struct address_space *mapping, struct file *filp,
+			pgoff_t offset, unsigned long nr_to_read);
+
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
 
diff --git a/mm/fadvise.c b/mm/fadvise.c
index a47f0f5..cf3bd4c 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -102,12 +102,10 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		if (!nrpages)
 			nrpages = ~0UL;
 
-		/*
-		 * Ignore return value because fadvise() shall return
-		 * success even if filesystem can't retrieve a hint,
-		 */
-		force_page_cache_readahead(mapping, f.file, start_index,
-					   nrpages);
+		get_file(f.file); /* fput() is called by workqueue */
+
+		/* queue up the request, don't care if it fails */
+		wq_page_cache_readahead(mapping, f.file, start_index, nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
 		break;
diff --git a/mm/readahead.c b/mm/readahead.c
index 7963f23..56a80a9 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -19,6 +19,27 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/file.h>
+#include <linux/workqueue.h>
+
+static struct workqueue_struct *readahead_wq __read_mostly;
+
+struct wq_ra_req {
+	struct work_struct work;
+	struct address_space *mapping;
+	struct file *file;
+	pgoff_t offset;
+	unsigned long nr_to_read;
+};
+
+static int __init init_readahead_wq(void)
+{
+	readahead_wq = alloc_workqueue("readahead", WQ_UNBOUND,
+					WQ_UNBOUND_MAX_ACTIVE);
+	BUG_ON(!readahead_wq);
+	return 0;
+}
+
+early_initcall(init_readahead_wq);
 
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
@@ -204,6 +225,47 @@ out:
 	return ret;
 }
 
+static void wq_ra_req_fn(struct work_struct *work)
+{
+	struct wq_ra_req *req = container_of(work, struct wq_ra_req, work);
+
+	/* ignore errors, caller wanted fire-and-forget operation */
+	force_page_cache_readahead(req->mapping, req->file,
+				req->offset, req->nr_to_read);
+
+	fput(req->file);
+	kfree(req);
+}
+
+/*
+ * Fire-and-forget readahead using a workqueue, this allocates pages
+ * inside a workqueue and returns as soon as possible.
+ */
+void wq_page_cache_readahead(struct address_space *mapping, struct file *filp,
+		pgoff_t offset, unsigned long nr_to_read)
+{
+	struct wq_ra_req *req;
+
+	req = kzalloc(sizeof(*req), GFP_ATOMIC);
+
+	/*
+	 * we are fire-and-forget, not having enough memory means readahead
+	 * is not worth doing anyways
+	 */
+	if (!req) {
+		fput(filp);
+		return;
+	}
+
+	INIT_WORK(&req->work, wq_ra_req_fn);
+	req->mapping = mapping;
+	req->file = filp;
+	req->offset = offset;
+	req->nr_to_read = nr_to_read;
+
+	queue_work(readahead_wq, &req->work);
+}
+
 /*
  * Chunk the readahead into 2 megabyte units, so that we don't pin too much
  * memory at once.
-- 
Eric Wong
