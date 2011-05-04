Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1EDJ2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:28:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:4162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1EDJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="917806825"
Message-Id: <20110504091909.644436893@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 17:17:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 4/6] writeback: trace event writeback_single_inode
References: <20110504091707.910929441@intel.com>
Content-Disposition: inline; filename=writeback-trace-writeback_single_inode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is valuable to know how the dirty inodes are iterated and their IO size.

"writeback_single_inode: bdi 8:0: ino=134246746 state=I_DIRTY_SYNC|I_SYNC age=414 index=0 wrote=0 to_write=1024"

- "state" reflects inode->i_state at the end of writeback_single_inode()
- "index" reflects mapping->writeback_index after the ->writepages() call
- "wrote" is the number of pages written in this writeback_single_inode()
- "to_write" is the remained wbc->nr_to_write

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c                |   12 +++---
 include/trace/events/writeback.h |   56 +++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 5 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-04 16:01:00.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-04 16:26:34.000000000 +0800
@@ -347,7 +347,7 @@ writeback_single_inode(struct inode *ino
 {
 	struct address_space *mapping = inode->i_mapping;
 	long per_file_limit = wbc->per_file_limit;
-	long uninitialized_var(nr_to_write);
+	long nr_to_write = wbc->nr_to_write;
 	unsigned dirty;
 	int ret;
 
@@ -370,7 +370,8 @@ writeback_single_inode(struct inode *ino
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
 			requeue_io(inode, wb);
-			return 0;
+			ret = 0;
+			goto out;
 		}
 
 		/*
@@ -387,10 +388,8 @@ writeback_single_inode(struct inode *ino
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
 
-	if (per_file_limit) {
-		nr_to_write = wbc->nr_to_write;
+	if (per_file_limit)
 		wbc->nr_to_write = per_file_limit;
-	}
 
 	ret = do_writepages(mapping, wbc);
 
@@ -477,6 +476,9 @@ writeback_single_inode(struct inode *ino
 		}
 	}
 	inode_sync_complete(inode);
+out:
+	trace_writeback_single_inode(inode, wbc,
+				     nr_to_write - wbc->nr_to_write);
 	return ret;
 }
 
--- linux-next.orig/include/trace/events/writeback.h	2011-05-04 15:59:23.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-04 16:27:18.000000000 +0800
@@ -8,6 +8,19 @@
 #include <linux/device.h>
 #include <linux/writeback.h>
 
+#define show_inode_state(state)					\
+	__print_flags(state, "|",				\
+		{I_DIRTY_SYNC,		"I_DIRTY_SYNC"},	\
+		{I_DIRTY_DATASYNC,	"I_DIRTY_DATASYNC"},	\
+		{I_DIRTY_PAGES,		"I_DIRTY_PAGES"},	\
+		{I_NEW,			"I_NEW"},		\
+		{I_WILL_FREE,		"I_WILL_FREE"},		\
+		{I_FREEING,		"I_FREEING"},		\
+		{I_CLEAR,		"I_CLEAR"},		\
+		{I_SYNC,		"I_SYNC"},		\
+		{I_REFERENCED,		"I_REFERENCED"}		\
+	)
+
 struct wb_writeback_work;
 
 DECLARE_EVENT_CLASS(writeback_work_class,
@@ -187,6 +200,49 @@ DEFINE_EVENT(writeback_congest_waited_te
 	TP_ARGS(usec_timeout, usec_delayed)
 );
 
+TRACE_EVENT(writeback_single_inode,
+
+	TP_PROTO(struct inode *inode,
+		 struct writeback_control *wbc,
+		 unsigned long wrote
+	),
+
+	TP_ARGS(inode, wbc, wrote),
+
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long, ino)
+		__field(unsigned long, state)
+		__field(unsigned long, age)
+		__field(unsigned long, writeback_index)
+		__field(unsigned long, wrote)
+		__field(long, nr_to_write)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name,
+			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
+		__entry->ino		= inode->i_ino;
+		__entry->state		= inode->i_state;
+		__entry->age		= (jiffies - inode->dirtied_when) *
+								1000 / HZ;
+		__entry->writeback_index = inode->i_mapping->writeback_index;
+		__entry->wrote		= wrote;
+		__entry->nr_to_write	= wbc->nr_to_write;
+	),
+
+	TP_printk("bdi %s: ino=%lu state=%s age=%lu "
+		  "index=%lu wrote=%lu to_write=%ld",
+		  __entry->name,
+		  __entry->ino,
+		  show_inode_state(__entry->state),
+		  __entry->age,
+		  __entry->writeback_index,
+		  __entry->wrote,
+		  __entry->nr_to_write
+	)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */


