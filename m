Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab1LPDaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 22:30:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:33896 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab1LPDaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 22:30:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="86304838"
Date: Fri, 16 Dec 2011 11:20:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] writeback: show writeback reason with __print_symbolic
Message-ID: <20111216032007.GA29463@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the binary trace understandable by trace-cmd.

CC: Dave Chinner <david@fromorbit.com>
CC: Curt Wohlgemuth <curtw@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c                |   11 -----------
 include/trace/events/writeback.h |   15 +++++++++++++--
 2 files changed, 13 insertions(+), 13 deletions(-)

--- linux-next.orig/include/trace/events/writeback.h	2011-12-16 10:22:03.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-12-16 10:24:43.000000000 +0800
@@ -21,6 +21,16 @@
 		{I_REFERENCED,		"I_REFERENCED"}		\
 	)
 
+#define WB_WORK_REASON							\
+		{WB_REASON_BACKGROUND,		"background"},		\
+		{WB_REASON_TRY_TO_FREE_PAGES,	"try_to_free_pages"},	\
+		{WB_REASON_SYNC,		"sync"},		\
+		{WB_REASON_PERIODIC,		"periodic"},		\
+		{WB_REASON_LAPTOP_TIMER,	"laptop_timer"},	\
+		{WB_REASON_FREE_MORE_MEM,	"free_more_memory"},	\
+		{WB_REASON_FS_FREE_SPACE,	"fs_free_space"},	\
+		{WB_REASON_FORKER_THREAD,	"forker_thread"}
+
 struct wb_writeback_work;
 
 DECLARE_EVENT_CLASS(writeback_work_class,
@@ -55,7 +65,7 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		  __entry->for_kupdate,
 		  __entry->range_cyclic,
 		  __entry->for_background,
-		  wb_reason_name[__entry->reason]
+		  __print_symbolic(__entry->reason, WB_WORK_REASON)
 	)
 );
 #define DEFINE_WRITEBACK_WORK_EVENT(name) \
@@ -184,7 +194,8 @@ TRACE_EVENT(writeback_queue_io,
 		__entry->older,	/* older_than_this in jiffies */
 		__entry->age,	/* older_than_this in relative milliseconds */
 		__entry->moved,
-		wb_reason_name[__entry->reason])
+		__print_symbolic(__entry->reason, WB_WORK_REASON)
+	)
 );
 
 TRACE_EVENT(global_dirty_state,
--- linux-next.orig/fs/fs-writeback.c	2011-12-16 10:24:57.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-12-16 10:25:10.000000000 +0800
@@ -47,17 +47,6 @@ struct wb_writeback_work {
 	struct completion *done;	/* set if the caller waits */
 };
 
-const char *wb_reason_name[] = {
-	[WB_REASON_BACKGROUND]		= "background",
-	[WB_REASON_TRY_TO_FREE_PAGES]	= "try_to_free_pages",
-	[WB_REASON_SYNC]		= "sync",
-	[WB_REASON_PERIODIC]		= "periodic",
-	[WB_REASON_LAPTOP_TIMER]	= "laptop_timer",
-	[WB_REASON_FREE_MORE_MEM]	= "free_more_memory",
-	[WB_REASON_FS_FREE_SPACE]	= "fs_free_space",
-	[WB_REASON_FORKER_THREAD]	= "forker_thread"
-};
-
 /*
  * Include the creation of the trace points after defining the
  * wb_writeback_work structure so that the definition remains local to this
