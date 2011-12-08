Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1LHJNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:13:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:11591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1LHJNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:13:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83546580"
Date: Thu, 8 Dec 2011 17:03:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Curt Wohlgemuth <curtw@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] writeback: show writeback reason with __print_symbolic
Message-ID: <20111208090338.GA20582@localhost>
References: <20111129130900.628549879@intel.com>
 <20111129131456.797240894@intel.com>
 <20111206153025.GA18974@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206153025.GA18974@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		  "req=%lu+%lu, ra=%lu+%d-%d, async=%d) = %d",
> > +			ra_pattern_names[__entry->pattern],
> 
> Instead of doing a manual array lookup please use __print_symbolic so
> that users of the binary interface (like trace-cmd) also get the
> right output.

FYI, here is the related fix on writeback traces.

---
This makes the traces trace-cmd friendly, at the cost of a bit code duplication.

CC: Curt Wohlgemuth <curtw@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- linux-next.orig/include/trace/events/writeback.h	2011-12-08 16:44:38.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-12-08 16:53:41.000000000 +0800
@@ -21,6 +21,18 @@
 		{I_REFERENCED,		"I_REFERENCED"}		\
 	)
 
+#define show_work_reason(reason)					\
+	__print_symbolic(reason,					\
+		{WB_REASON_BACKGROUND,		"background"},		\
+		{WB_REASON_TRY_TO_FREE_PAGES,	"try_to_free_pages"},	\
+		{WB_REASON_SYNC,		"sync"},		\
+		{WB_REASON_PERIODIC,		"periodic"},		\
+		{WB_REASON_LAPTOP_TIMER,	"laptop_timer"},	\
+		{WB_REASON_FREE_MORE_MEM,	"free_more_memory"},	\
+		{WB_REASON_FS_FREE_SPACE,	"fs_free_space"},	\
+		{WB_REASON_FORKER_THREAD,	"forker_thread"}	\
+	)
+
 struct wb_writeback_work;
 
 DECLARE_EVENT_CLASS(writeback_work_class,
@@ -55,7 +67,7 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		  __entry->for_kupdate,
 		  __entry->range_cyclic,
 		  __entry->for_background,
-		  wb_reason_name[__entry->reason]
+		  show_work_reason(__entry->reason)
 	)
 );
 #define DEFINE_WRITEBACK_WORK_EVENT(name) \
@@ -184,7 +196,8 @@ TRACE_EVENT(writeback_queue_io,
 		__entry->older,	/* older_than_this in jiffies */
 		__entry->age,	/* older_than_this in relative milliseconds */
 		__entry->moved,
-		wb_reason_name[__entry->reason])
+		show_work_reason(__entry->reason)
+	)
 );
 
 TRACE_EVENT(global_dirty_state,
