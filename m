Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2AQDc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 22:32:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:24841 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab2AQDcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 22:32:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96563248"
Date: Tue, 17 Jan 2012 11:32:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Crash in writeback:single_inode tracepoint after card removal
Message-ID: <20120117033253.GA399@localhost>
References: <20120115152806.GA32106@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115152806.GA32106@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 08:58:06PM +0530, Rabin Vincent wrote:
> I'm testing SD card removal, and with tracing enabled I'm seeing a crash
> in the writeback:single_inode event sometimes when a umount is done
> after a card is removed with pending io.  When the problem occurs,
> writeback is begin attempted with the default_backing_dev_info.  The
> block bdi which was handling this device has been unregistered and it's
> bdi->dev is NULL.  However it is still referenced by
> inode->i_mapping->backing_dev_info, and the trace point does the
> following, leading to the oops:
> 
> 	TP_fast_assign(
> 		strncpy(__entry->name,
> 		dev_name(inode->i_mapping->backing_dev_info->dev),
> 		32);
> 
>    umount-33      0.... 10973110us : writeback_inodes_sb <-__sync_filesystem
>    umount-33      0.... 10973248us : writeback_inodes_sb_nr <-__sync_filesystem
>    umount-33      0.... 10973289us : bdi_queue_work <-writeback_inodes_sb_nr
>    umount-33      0...1 10973336us : writeback_queue: bdi default: sb_dev 179:0 nr_pages=2153 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
>  bdi-defa-14      1.... 10974021us : wb_do_writeback <-bdi_forker_thread
>  bdi-defa-14      1...1 10974041us : writeback_exec: bdi default: sb_dev 179:0 nr_pages=2153 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
>  bdi-defa-14      1.... 10974053us : wb_writeback <-wb_do_writeback
>  bdi-defa-14      1...2 10974059us : writeback_start: bdi default: sb_dev 179:0 nr_pages=2153 sync_mode=0 kupdate=0 range_cyclic=0 background=0 reason=sync
>  bdi-defa-14      1...2 10974093us : writeback_queue_io: bdi default: older=4294939114 age=0 enqueue=2 reason=sync
>  bdi-defa-14      1...1 10974101us : writeback_sb_inodes <-wb_writeback
>  bdi-defa-14      1...2 10974166us : writeback_single_inode <-writeback_sb_inodes
> 
>  Unable to handle kernel NULL pointer dereference at virtual address 0000002c
>  pgd = c0004000
>  [0000002c] *pgd=00000000
>  Internal error: Oops: 17 [#1] PREEMPT SMP
>  PC is at ftrace_raw_event_writeback_single_inode_template+0x60/0xe4
>  LR is at ftrace_raw_event_writeback_single_inode_template+0x50/0xe4
> 
> The full trace+log is attached.  My kernel (current linus) has a delay
> inserted in __mark_inode_dirty, to easily trigger the condition:

Rabin, thanks for showing the helpful details! It should be fixable by
the use of inode_to_bdi():

Subject: writeback: fix NULL bdi->dev in trace writeback_single_inode
Date: Tue Jan 17 11:18:56 CST 2012

Reported-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c                |   16 ++++++++--------
 include/trace/events/writeback.h |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

--- linux.orig/fs/fs-writeback.c	2012-01-17 11:05:05.000000000 +0800
+++ linux/fs/fs-writeback.c	2012-01-17 11:18:50.000000000 +0800
@@ -48,14 +48,6 @@ struct wb_writeback_work {
 };
 
 /*
- * Include the creation of the trace points after defining the
- * wb_writeback_work structure so that the definition remains local to this
- * file.
- */
-#define CREATE_TRACE_POINTS
-#include <trace/events/writeback.h>
-
-/*
  * We don't actually have pdflush, but this one is exported though /proc...
  */
 int nr_pdflush_threads;
@@ -87,6 +79,14 @@ static inline struct inode *wb_inode(str
 	return list_entry(head, struct inode, i_wb_list);
 }
 
+/*
+ * Include the creation of the trace points after defining the
+ * wb_writeback_work structure and inline functions so that the definition
+ * remains local to this file.
+ */
+#define CREATE_TRACE_POINTS
+#include <trace/events/writeback.h>
+
 /* Wakeup flusher thread or forker thread to fork it. Requires bdi->wb_lock. */
 static void bdi_wakeup_flusher(struct backing_dev_info *bdi)
 {
--- linux.orig/include/trace/events/writeback.h	2012-01-17 11:04:24.000000000 +0800
+++ linux/include/trace/events/writeback.h	2012-01-17 11:16:34.000000000 +0800
@@ -418,7 +418,7 @@ DECLARE_EVENT_CLASS(writeback_single_ino
 
 	TP_fast_assign(
 		strncpy(__entry->name,
-			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
+			dev_name(inode_to_bdi(inode)->dev), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;
