Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1HJGeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 02:34:24 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50401 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1HJGeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 02:34:19 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 2/2] blktrace: add FLUSH/FUA support
Date: Wed, 10 Aug 2011 15:32:04 +0900
Message-Id: <1312957924-2316-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1312957924-2316-1-git-send-email-namhyung@gmail.com>
References: <1312957924-2316-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add FLUSH/FUA support to blktrace. As FLUSH precedes WRITE and/or
FUA follows WRITE, use the same 'F' flag for both cases and
distinguish them by their (relative) position. The end results
look like (other flags might be shown also):

 - WRITE:            W
 - WRITE_FLUSH:      FW
 - WRITE_FUA:        WF
 - WRITE_FLUSH_FUA:  FWF

Note that we reuse TC_BARRIER due to lack of bit space of act_mask
so that the older versions of blktrace tools will report flush
requests as barriers from now on.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
v1->v2:
 * replace TC_BARRIER with TC_FLUSH (thanks to Matthew's patch)
 * define and use RWBS_LEN macro (comment by Steven)

 include/linux/blktrace_api.h |    5 +++--
 include/trace/events/block.h |   20 +++++++++++---------
 kernel/trace/blktrace.c      |   21 ++++++++++++++++-----
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 8c7c2de7631a..8e9e4bc6d73b 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -14,7 +14,7 @@
 enum blktrace_cat {
 	BLK_TC_READ	= 1 << 0,	/* reads */
 	BLK_TC_WRITE	= 1 << 1,	/* writes */
-	BLK_TC_BARRIER	= 1 << 2,	/* barrier */
+	BLK_TC_FLUSH	= 1 << 2,	/* flush */
 	BLK_TC_SYNC	= 1 << 3,	/* sync IO */
 	BLK_TC_SYNCIO	= BLK_TC_SYNC,
 	BLK_TC_QUEUE	= 1 << 4,	/* queueing/merging */
@@ -28,8 +28,9 @@ enum blktrace_cat {
 	BLK_TC_META	= 1 << 12,	/* metadata */
 	BLK_TC_DISCARD	= 1 << 13,	/* discard requests */
 	BLK_TC_DRV_DATA	= 1 << 14,	/* binary per-driver data */
+	BLK_TC_FUA	= 1 << 15,	/* fua requests */
 
-	BLK_TC_END	= 1 << 15,	/* only 16-bits, reminder */
+	BLK_TC_END	= 1 << 15,	/* we've run out of bits! */
 };
 
 #define BLK_TC_SHIFT		(16)
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index bf366547da25..05c5e61f0a7c 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -8,6 +8,8 @@
 #include <linux/blkdev.h>
 #include <linux/tracepoint.h>
 
+#define RWBS_LEN	8
+
 DECLARE_EVENT_CLASS(block_rq_with_error,
 
 	TP_PROTO(struct request_queue *q, struct request *rq),
@@ -19,7 +21,7 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  int,		errors			)
-		__array(  char,		rwbs,	6		)
+		__array(  char,		rwbs,	RWBS_LEN	)
 		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
 	),
 
@@ -104,7 +106,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  unsigned int,	bytes			)
-		__array(  char,		rwbs,	6		)
+		__array(  char,		rwbs,	RWBS_LEN	)
 		__array(  char,         comm,   TASK_COMM_LEN   )
 		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
 	),
@@ -183,7 +185,7 @@ TRACE_EVENT(block_bio_bounce,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__array( char,		rwbs,	RWBS_LEN	)
 		__array( char,		comm,	TASK_COMM_LEN	)
 	),
 
@@ -222,7 +224,7 @@ TRACE_EVENT(block_bio_complete,
 		__field( sector_t,	sector		)
 		__field( unsigned,	nr_sector	)
 		__field( int,		error		)
-		__array( char,		rwbs,	6	)
+		__array( char,		rwbs,	RWBS_LEN)
 	),
 
 	TP_fast_assign(
@@ -249,7 +251,7 @@ DECLARE_EVENT_CLASS(block_bio,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__array( char,		rwbs,	RWBS_LEN	)
 		__array( char,		comm,	TASK_COMM_LEN	)
 	),
 
@@ -321,7 +323,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__array( char,		rwbs,	RWBS_LEN	)
 		__array( char,		comm,	TASK_COMM_LEN	)
         ),
 
@@ -456,7 +458,7 @@ TRACE_EVENT(block_split,
 		__field( dev_t,		dev				)
 		__field( sector_t,	sector				)
 		__field( sector_t,	new_sector			)
-		__array( char,		rwbs,		6		)
+		__array( char,		rwbs,		RWBS_LEN	)
 		__array( char,		comm,		TASK_COMM_LEN	)
 	),
 
@@ -498,7 +500,7 @@ TRACE_EVENT(block_bio_remap,
 		__field( unsigned int,	nr_sector	)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
-		__array( char,		rwbs,	6	)
+		__array( char,		rwbs,	RWBS_LEN)
 	),
 
 	TP_fast_assign(
@@ -542,7 +544,7 @@ TRACE_EVENT(block_rq_remap,
 		__field( unsigned int,	nr_sector	)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
-		__array( char,		rwbs,	6	)
+		__array( char,		rwbs,	RWBS_LEN)
 	),
 
 	TP_fast_assign(
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 6957aa298dfa..7c910a5593a6 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -206,6 +206,8 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	what |= MASK_TC_BIT(rw, RAHEAD);
 	what |= MASK_TC_BIT(rw, META);
 	what |= MASK_TC_BIT(rw, DISCARD);
+	what |= MASK_TC_BIT(rw, FLUSH);
+	what |= MASK_TC_BIT(rw, FUA);
 
 	pid = tsk->pid;
 	if (act_log_check(bt, what, sector, pid))
@@ -1054,6 +1056,9 @@ static void fill_rwbs(char *rwbs, const struct blk_io_trace *t)
 		goto out;
 	}
 
+	if (tc & BLK_TC_FLUSH)
+		rwbs[i++] = 'F';
+
 	if (tc & BLK_TC_DISCARD)
 		rwbs[i++] = 'D';
 	else if (tc & BLK_TC_WRITE)
@@ -1063,10 +1068,10 @@ static void fill_rwbs(char *rwbs, const struct blk_io_trace *t)
 	else
 		rwbs[i++] = 'N';
 
+	if (tc & BLK_TC_FUA)
+		rwbs[i++] = 'F';
 	if (tc & BLK_TC_AHEAD)
 		rwbs[i++] = 'A';
-	if (tc & BLK_TC_BARRIER)
-		rwbs[i++] = 'B';
 	if (tc & BLK_TC_SYNC)
 		rwbs[i++] = 'S';
 	if (tc & BLK_TC_META)
@@ -1132,7 +1137,7 @@ typedef int (blk_log_action_t) (struct trace_iterator *iter, const char *act);
 
 static int blk_log_action_classic(struct trace_iterator *iter, const char *act)
 {
-	char rwbs[6];
+	char rwbs[RWBS_LEN];
 	unsigned long long ts  = iter->ts;
 	unsigned long nsec_rem = do_div(ts, NSEC_PER_SEC);
 	unsigned secs	       = (unsigned long)ts;
@@ -1148,7 +1153,7 @@ static int blk_log_action_classic(struct trace_iterator *iter, const char *act)
 
 static int blk_log_action(struct trace_iterator *iter, const char *act)
 {
-	char rwbs[6];
+	char rwbs[RWBS_LEN];
 	const struct blk_io_trace *t = te_blk_io_trace(iter->ent);
 
 	fill_rwbs(rwbs, t);
@@ -1561,7 +1566,7 @@ static const struct {
 } mask_maps[] = {
 	{ BLK_TC_READ,		"read"		},
 	{ BLK_TC_WRITE,		"write"		},
-	{ BLK_TC_BARRIER,	"barrier"	},
+	{ BLK_TC_FLUSH,		"flush"		},
 	{ BLK_TC_SYNC,		"sync"		},
 	{ BLK_TC_QUEUE,		"queue"		},
 	{ BLK_TC_REQUEUE,	"requeue"	},
@@ -1573,6 +1578,7 @@ static const struct {
 	{ BLK_TC_META,		"meta"		},
 	{ BLK_TC_DISCARD,	"discard"	},
 	{ BLK_TC_DRV_DATA,	"drv_data"	},
+	{ BLK_TC_FUA,		"fua"		},
 };
 
 static int blk_trace_str2mask(const char *str)
@@ -1788,6 +1794,9 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 {
 	int i = 0;
 
+	if (rw & REQ_FLUSH)
+		rwbs[i++] = 'F';
+
 	if (rw & WRITE)
 		rwbs[i++] = 'W';
 	else if (rw & REQ_DISCARD)
@@ -1797,6 +1806,8 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 	else
 		rwbs[i++] = 'N';
 
+	if (rw & REQ_FUA)
+		rwbs[i++] = 'F';
 	if (rw & REQ_RAHEAD)
 		rwbs[i++] = 'A';
 	if (rw & REQ_SYNC)
-- 
1.7.6

