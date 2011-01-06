Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1AFSne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:43:34 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48742 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753105Ab1AFSnd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:43:33 -0500
Date: Thu, 6 Jan 2011 13:43:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jeff Moyer <jmoyer@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizf@cn.fujitsu.com>, Alan.Brunelle@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] trace event block fix unassigned field
Message-ID: <20110106184331.GA2449@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 13:40:21 up 43 days, 23:43,  5 users,  load average: 0.10, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "error" field in block_bio_complete is not assigned, leaving the memory area
uninitialized (keeping garbage data). Pass an additional tracepoint argument to
this event to initialize this field.

From: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Jens Axboe <axboe@kernel.dk>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Alan.Brunelle@hp.com
---
 drivers/md/dm.c              |    2 +-
 include/trace/events/block.h |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/trace/events/block.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/block.h
+++ linux-2.6-lttng/include/trace/events/block.h
@@ -206,15 +206,16 @@ TRACE_EVENT(block_bio_bounce,
  * block_bio_complete - completed all work on the block operation
  * @q: queue holding the block operation
  * @bio: block operation completed
+ * @error: io error value
  *
  * This tracepoint indicates there is no further work to do on this
  * block IO operation @bio.
  */
 TRACE_EVENT(block_bio_complete,
 
-	TP_PROTO(struct request_queue *q, struct bio *bio),
+	TP_PROTO(struct request_queue *q, struct bio *bio, int error),
 
-	TP_ARGS(q, bio),
+	TP_ARGS(q, bio, error),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
@@ -228,6 +229,7 @@ TRACE_EVENT(block_bio_complete,
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
 		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->error		= error;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 	),
 
Index: linux-2.6-lttng/drivers/md/dm.c
===================================================================
--- linux-2.6-lttng.orig/drivers/md/dm.c
+++ linux-2.6-lttng/drivers/md/dm.c
@@ -659,7 +659,7 @@ static void dec_pending(struct dm_io *io
 			free_io(md, io);
 
 			if (io_error != DM_ENDIO_REQUEUE) {
-				trace_block_bio_complete(md->queue, bio);
+				trace_block_bio_complete(md->queue, bio, io_error);
 
 				bio_endio(bio, io_error);
 			}

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
