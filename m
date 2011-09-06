Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab1IFKmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:42:24 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:18462 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab1IFKmS (ORCPT
	<rfc822;groupwise-SJayaraman@suse.com:0:0>);
	Tue, 6 Sep 2011 06:42:18 -0400
Message-ID: <4E65F8B1.2090505@suse.de>
Date: Tue, 06 Sep 2011 16:10:49 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
Reply-To: sjayaraman@suse.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
CC: Shaohua Li <shaohua.li@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3] block: document blk-plug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thus spake Andrew Morton:

"And I have the usual maintainability whine.  If someone comes up to
vmscan.c and sees it calling blk_start_plug(), how are they supposed to
work out why that call is there?  They go look at the blk_start_plug()
definition and it is undocumented.  I think we can do better than this?"

Adapted from the LWN article - http://lwn.net/Articles/438256/ by Jens
Axboe and from an earlier attempt by Shaohua Li attempted to document
blk-plug.

Changes since -v2:

  * clarify why we need not disable preemption while modifying the plug list.

Changes since -v1:

  * explain how blk_plug helps with potential deadlock avoidance.
  * explain why we need blk-plug.
  * add a note that cb_list is required by md.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 block/blk-core.c       |   14 ++++++++++++++
 include/linux/blkdev.h |   24 +++++++++++++++---------
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..ea360c8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2626,6 +2626,20 @@ EXPORT_SYMBOL(kblockd_schedule_delayed_work);
 
 #define PLUG_MAGIC	0x91827364
 
+/**
+ * blk_start_plug - initialize blk_plug and track it inside the task_struct
+ * @plug:	The &struct blk_plug that needs to be initialized
+ *
+ * Description:
+ *   Tracking blk_plug inside the task_struct will help with auto-flushing the
+ *   pending I/O should the task end up blocking between blk_start_plug() and
+ *   blk_finish_plug(). This is important from a performance perspective, but
+ *   also ensures that we don't deadlock. For instance, if the task is blocking
+ *   for a memory allocation, memory reclaim could end up wanting to free a
+ *   page belonging to that request that is currently residing in our private
+ *   plug. By flushing the pending I/O when the process goes to sleep, we avoid
+ *   this kind of deadlocks.
+ */
 void blk_start_plug(struct blk_plug *plug)
 {
 	struct task_struct *tsk = current;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b15d5..15b205d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -863,17 +863,23 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
 
 /*
- * Note: Code in between changing the blk_plug list/cb_list or element of such
- * lists is preemptable, but such code can't do sleep (or be very careful),
- * otherwise data is corrupted. For details, please check schedule() where
- * blk_schedule_flush_plug() is called.
+ * blk_plug allows to build up a queue of related requests by holding the I/O
+ * fragments for a short period. This allows merging of sequential requests
+ * into single larger request. As the requests are moved from per-task list to
+ * the device's request_queue in a batch, this results in improved
+ * scalability as the lock contention for request_queue lock is reduced.
+ *
+ * It is ok not to disable preemption when adding the request to the plug list
+ * or when attempting merge, because blk_schedule_flush_list() will only flush
+ * the plug list when the task sleeps by itself. For details, please check
+ * schedule() where blk_schedule_flush_plug() is called.
  */
 struct blk_plug {
-	unsigned long magic;
-	struct list_head list;
-	struct list_head cb_list;
-	unsigned int should_sort;
-	unsigned int count;
+	unsigned long magic; /* detect uninitialized use-cases */
+	struct list_head list; /* requests */
+	struct list_head cb_list; /* md requires an unplug callback */
+	unsigned int should_sort; /*list to be sorted before flushing? */
+	unsigned int count; /* request count to avoid list getting too big */
 };
 #define BLK_MAX_REQUEST_COUNT 16
 
