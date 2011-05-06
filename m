Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab1EFDgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 23:36:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:35065 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189Ab1EFDgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 23:36:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,324,1301900400"; 
   d="scan'208";a="638817443"
Message-Id: <20110506031613.807611954@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 11:08:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 16/17] writeback: trace event writeback_single_inode
References: <20110506030821.523093711@intel.com>
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
 fs/fs-writeback.c                |    3 +
 include/trace/events/writeback.h |   56 +++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)

--- linux-next.orig/include/trace/events/writeback.h	2011-05-05 23:30:34.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-05 23:30:37.000000000 +0800
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
@@ -180,6 +193,49 @@ DEFINE_EVENT(writeback_congest_waited_te
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
--- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:30:34.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-05 23:30:37.000000000 +0800
@@ -594,7 +594,8 @@ static long writeback_sb_inodes(struct s
 		wbc.pages_skipped = 0;
 
 		writeback_single_inode(inode, wb, &wbc);
-
+		trace_writeback_single_inode(inode, &wbc,
+					     write_chunk - wbc.nr_to_write);
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
 		if (wbc.pages_skipped) {


