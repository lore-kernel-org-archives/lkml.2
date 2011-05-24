Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1EXFWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:22:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:21837 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1EXFV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:21:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="354112"
Message-Id: <20110524051900.090199036@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 13:14:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/18] writeback: trace event writeback_single_inode
References: <20110524051411.924582719@intel.com>
Content-Disposition: inline; filename=writeback-trace-writeback_single_inode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is valuable to know how the dirty inodes are iterated and their IO size.

"writeback_single_inode: bdi 8:0: ino=134246746 state=I_DIRTY_SYNC|I_SYNC age=414 index=0 to_write=1024 wrote=0"

- "state" reflects inode->i_state at the end of writeback_single_inode()
- "index" reflects mapping->writeback_index after the ->writepages() call
- "to_write" is the wbc->nr_to_write at entrance of writeback_single_inode()
- "wrote" is the number of pages actually written

v2: add trace event writeback_single_inode_requeue as proposed by Dave.

CC: Dave Chinner <david@fromorbit.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c                |    4 +
 include/trace/events/writeback.h |   70 +++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

--- linux-next.orig/include/trace/events/writeback.h	2011-05-24 11:17:25.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-24 11:17:26.000000000 +0800
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
@@ -184,6 +197,63 @@ DEFINE_EVENT(writeback_congest_waited_te
 	TP_ARGS(usec_timeout, usec_delayed)
 );
 
+DECLARE_EVENT_CLASS(writeback_single_inode_template,
+
+	TP_PROTO(struct inode *inode,
+		 struct writeback_control *wbc,
+		 unsigned long nr_to_write
+	),
+
+	TP_ARGS(inode, wbc, nr_to_write),
+
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long, ino)
+		__field(unsigned long, state)
+		__field(unsigned long, age)
+		__field(unsigned long, writeback_index)
+		__field(long, nr_to_write)
+		__field(unsigned long, wrote)
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
+		__entry->nr_to_write	= nr_to_write;
+		__entry->wrote		= nr_to_write - wbc->nr_to_write;
+	),
+
+	TP_printk("bdi %s: ino=%lu state=%s age=%lu "
+		  "index=%lu to_write=%ld wrote=%lu",
+		  __entry->name,
+		  __entry->ino,
+		  show_inode_state(__entry->state),
+		  __entry->age,
+		  __entry->writeback_index,
+		  __entry->nr_to_write,
+		  __entry->wrote
+	)
+);
+
+DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode_requeue,
+	TP_PROTO(struct inode *inode,
+		 struct writeback_control *wbc,
+		 unsigned long nr_to_write),
+	TP_ARGS(inode, wbc, nr_to_write)
+);
+
+DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode,
+	TP_PROTO(struct inode *inode,
+		 struct writeback_control *wbc,
+		 unsigned long nr_to_write),
+	TP_ARGS(inode, wbc, nr_to_write)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
--- linux-next.orig/fs/fs-writeback.c	2011-05-24 11:17:25.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-24 11:17:26.000000000 +0800
@@ -346,6 +346,7 @@ writeback_single_inode(struct inode *ino
 		       struct writeback_control *wbc)
 {
 	struct address_space *mapping = inode->i_mapping;
+	long nr_to_write = wbc->nr_to_write;
 	unsigned dirty;
 	int ret;
 
@@ -368,6 +369,8 @@ writeback_single_inode(struct inode *ino
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
 			requeue_io(inode, wb);
+			trace_writeback_single_inode_requeue(inode, wbc,
+							     nr_to_write);
 			return 0;
 		}
 
@@ -467,6 +470,7 @@ writeback_single_inode(struct inode *ino
 		}
 	}
 	inode_sync_complete(inode);
+	trace_writeback_single_inode(inode, wbc, nr_to_write);
 	return ret;
 }
 


