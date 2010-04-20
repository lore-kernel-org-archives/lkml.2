Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0DTCnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 22:43:32 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:43544 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753079Ab0DTCmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:42:38 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in write_cache_pages
Date: Tue, 20 Apr 2010 12:41:53 +1000
Message-Id: <1271731314-5893-4-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1271731314-5893-1-git-send-email-david@fromorbit.com>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

If a filesystem writes more than one page in ->writepage, write_cache_pages
fails to notice this and continues to attempt writeback when wbc->nr_to_write
has gone negative - this trace was captured from XFS:


    wbc_writeback_start: towrt=1024
    wbc_writepage: towrt=1024
    wbc_writepage: towrt=0
    wbc_writepage: towrt=-1
    wbc_writepage: towrt=-5
    wbc_writepage: towrt=-21
    wbc_writepage: towrt=-85

This has adverse effects on filesystem writeback behaviour. write_cache_pages()
needs to terminate after a certain number of pages are written, not after a
certain number of calls to ->writepage are made. Make it observe the current
value of wbc->nr_to_write and treat a value of <= 0 as though it is a either a
termination condition or a trigger to reset to MAX_WRITEḆACK_PAGES for data
integrity syncs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c                |    9 ---------
 include/linux/writeback.h        |    9 +++++++++
 include/trace/events/writeback.h |    1 +
 mm/page-writeback.c              |   20 +++++++++++++++++++-
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5214b61..d8271d5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -675,15 +675,6 @@ void writeback_inodes_wbc(struct writeback_control *wbc)
 	writeback_inodes_wb(&bdi->wb, wbc);
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b2d615f..8533a0f 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -14,6 +14,15 @@ extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
+ * The maximum number of pages to writeout in a single bdi flush/kupdate
+ * operation.  We do this so we don't hold I_SYNC against an inode for
+ * enormous amounts of time, which would block a userspace task which has
+ * been forced to throttle against that inode.  Also, the code reevaluates
+ * the dirty each time it has written this many pages.
+ */
+#define MAX_WRITEBACK_PAGES     1024
+
+/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 02f34a5..3bcbd83 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -241,6 +241,7 @@ DEFINE_WBC_EVENT(wbc_writeback_wait);
 DEFINE_WBC_EVENT(wbc_balance_dirty_start);
 DEFINE_WBC_EVENT(wbc_balance_dirty_written);
 DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
+DEFINE_WBC_EVENT(wbc_writepage);
 
 #endif /* _TRACE_WRITEBACK_H */
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index d45f59e..e22af84 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -917,6 +917,7 @@ continue_unlock:
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
+			trace_wbc_writepage(wbc);
 			ret = (*writepage)(page, wbc, data);
 			if (unlikely(ret)) {
 				if (ret == AOP_WRITEPAGE_ACTIVATE) {
@@ -935,7 +936,7 @@ continue_unlock:
 					done = 1;
 					break;
 				}
- 			}
+			}
 
 			if (nr_to_write > 0) {
 				nr_to_write--;
@@ -955,6 +956,23 @@ continue_unlock:
 					break;
 				}
 			}
+
+			/*
+			 * Some filesystems will write multiple pages in
+			 * ->writepage, so wbc->nr_to_write can change much,
+			 * much faster than nr_to_write. Check this as an exit
+			 * condition, or if we are doing a data integrity sync,
+			 * reset the wbc to MAX_WRITEBACK_PAGES so that such
+			 * filesystems can do optimal writeout here.
+			 */
+			if (wbc->nr_to_write <= 0) {
+				if (wbc->sync_mode == WB_SYNC_NONE) {
+					done = 1;
+					nr_to_write = 0;
+					break;
+				}
+				wbc->nr_to_write = MAX_WRITEBACK_PAGES;
+			}
 		}
 		pagevec_release(&pvec);
 		cond_resched();
-- 
1.6.5

