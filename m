Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162977Ab1FAIik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:38:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38018 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161825Ab1FAIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A+MBya636N5GF09sLM/MtioLZhPMDu+3629OZn6O9kDoJXG7jglHWYIGbGvPso824q
         SbzR5IwgGVlur0hmG1xXiqPvA5K5yHF35UMHKaSCVErEiASnWp8af+CKXfG8ZYnyGfPw
         mbnoBlSrMt4axWc3KOwHN9w8T+FRRxso7cQ9s=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] blktrace: add FLUSH/FUA support
Date: Wed,  1 Jun 2011 17:38:29 +0900
Message-Id: <1306917509-6819-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
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

Note that BLK_TC_FLUSH should be the last one due to MASC_TC_BIT().
Otherwise it will cause unpleasant result because __REQ_FLUSH (23)
would be greater than ilog2(BLK_TC_FLUSH) + BLK_TC_SHIFT (16) so the
negative value. __REQ_FUA (12) doesn't have this problem.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/blktrace_api.h |    5 +++--
 include/trace/events/block.h |   18 +++++++++---------
 kernel/trace/blktrace.c      |   21 ++++++++++++++++-----
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index b22fb0d3db0f..05a688648bef 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -14,7 +14,7 @@
 enum blktrace_cat {
 	BLK_TC_READ	= 1 << 0,	/* reads */
 	BLK_TC_WRITE	= 1 << 1,	/* writes */
-	BLK_TC_BARRIER	= 1 << 2,	/* barrier */
+	BLK_TC_FUA	= 1 << 2,	/* fua requests */
 	BLK_TC_SYNC	= 1 << 3,	/* sync IO */
 	BLK_TC_SYNCIO	= BLK_TC_SYNC,
 	BLK_TC_QUEUE	= 1 << 4,	/* queueing/merging */
@@ -28,8 +28,9 @@ enum blktrace_cat {
 	BLK_TC_META	= 1 << 12,	/* metadata */
 	BLK_TC_DISCARD	= 1 << 13,	/* discard requests */
 	BLK_TC_DRV_DATA	= 1 << 14,	/* binary per-driver data */
+	BLK_TC_FLUSH	= 1 << 15,	/* flush requests */
 
-	BLK_TC_END	= 1 << 15,	/* only 16-bits, reminder */
+	BLK_TC_END	= 1 << 15,	/* we've run out of bits! */
 };
 
 #define BLK_TC_SHIFT		(16)
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index bf366547da25..f21fea24216d 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -19,7 +19,7 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  int,		errors			)
-		__array(  char,		rwbs,	6		)
+		__array(  char,		rwbs,	8		)
 		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
 	),
 
@@ -104,7 +104,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  unsigned int,	bytes			)
-		__array(  char,		rwbs,	6		)
+		__array(  char,		rwbs,	8		)
 		__array(  char,         comm,   TASK_COMM_LEN   )
 		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
 	),
@@ -183,7 +183,7 @@ TRACE_EVENT(block_bio_bounce,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__array( char,		rwbs,	8		)
 		__array( char,		comm,	TASK_COMM_LEN	)
 	),
 
@@ -222,7 +222,7 @@ TRACE_EVENT(block_bio_complete,
 		__field( sector_t,	sector		)
 		__field( unsigned,	nr_sector	)
 		__field( int,		error		)
-		__array( char,		rwbs,	6	)
+		__array( char,		rwbs,	8	)
 	),
 
 	TP_fast_assign(
@@ -249,7 +249,7 @@ DECLARE_EVENT_CLASS(block_bio,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__array( char,		rwbs,	8		)
 		__array( char,		comm,	TASK_COMM_LEN	)
 	),
 
@@ -321,7 +321,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__array( char,		rwbs,	8		)
 		__array( char,		comm,	TASK_COMM_LEN	)
         ),
 
@@ -456,7 +456,7 @@ TRACE_EVENT(block_split,
 		__field( dev_t,		dev				)
 		__field( sector_t,	sector				)
 		__field( sector_t,	new_sector			)
-		__array( char,		rwbs,		6		)
+		__array( char,		rwbs,		8		)
 		__array( char,		comm,		TASK_COMM_LEN	)
 	),
 
@@ -498,7 +498,7 @@ TRACE_EVENT(block_bio_remap,
 		__field( unsigned int,	nr_sector	)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
-		__array( char,		rwbs,	6	)
+		__array( char,		rwbs,	8	)
 	),
 
 	TP_fast_assign(
@@ -542,7 +542,7 @@ TRACE_EVENT(block_rq_remap,
 		__field( unsigned int,	nr_sector	)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
-		__array( char,		rwbs,	6	)
+		__array( char,		rwbs,	8	)
 	),
 
 	TP_fast_assign(
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 6957aa298dfa..f5deb6f49e76 100644
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
+	char rwbs[8];
 	unsigned long long ts  = iter->ts;
 	unsigned long nsec_rem = do_div(ts, NSEC_PER_SEC);
 	unsigned secs	       = (unsigned long)ts;
@@ -1148,7 +1153,7 @@ static int blk_log_action_classic(struct trace_iterator *iter, const char *act)
 
 static int blk_log_action(struct trace_iterator *iter, const char *act)
 {
-	char rwbs[6];
+	char rwbs[8];
 	const struct blk_io_trace *t = te_blk_io_trace(iter->ent);
 
 	fill_rwbs(rwbs, t);
@@ -1561,7 +1566,7 @@ static const struct {
 } mask_maps[] = {
 	{ BLK_TC_READ,		"read"		},
 	{ BLK_TC_WRITE,		"write"		},
-	{ BLK_TC_BARRIER,	"barrier"	},
+	{ BLK_TC_FUA,		"fua"		},
 	{ BLK_TC_SYNC,		"sync"		},
 	{ BLK_TC_QUEUE,		"queue"		},
 	{ BLK_TC_REQUEUE,	"requeue"	},
@@ -1573,6 +1578,7 @@ static const struct {
 	{ BLK_TC_META,		"meta"		},
 	{ BLK_TC_DISCARD,	"discard"	},
 	{ BLK_TC_DRV_DATA,	"drv_data"	},
+	{ BLK_TC_FLUSH,		"flush"		},
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
1.7.5.2

