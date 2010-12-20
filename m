Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab0LTRUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:20:12 -0500
Received: from mail.openrapids.net ([64.15.138.104]:49529 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754374Ab0LTRUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:20:10 -0500
Date: Mon, 20 Dec 2010 12:20:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCH] trace event block: conversion to tp_assign/tp_memcpy
Message-ID: <20101220172003.GA14360@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:05:22 up 26 days, 22:08,  5 users,  load average: 0.08, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that there are calls from TP_fast_assign to functions sitting in
blktrace.c, move all pretty-printing out of TP_fast_assign fast path, into
TP_printk, by using __print_flags().

Warning: the TP_printk ascii output does not change, but the raw binary output
is modified. Comments/feedback are welcome. Are there userspace tools that
depend on a fixed binary layout for the block events ?

This patch is submitted as RFC and depends on a yet unposted version of the
tp_assign/tp_memcpy patch that introduces "tp_memcpy_dyn", which allows to
memcpy dynamic arrays. I'm posting this RFC now mainly to get feedback on tool
dependency on a fixed trace binary layout for block layer events.

Feedback is welcome,

Thanks,

Mathieu

---
 include/linux/blktrace_api.h |   13 --
 include/trace/events/block.h |  225 +++++++++++++++++++++++++++----------------
 kernel/trace/blktrace.c      |   61 +----------
 3 files changed, 156 insertions(+), 143 deletions(-)

Index: linux-2.6-lttng/include/trace/events/block.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/block.h
+++ linux-2.6-lttng/include/trace/events/block.h
@@ -7,6 +7,60 @@
 #include <linux/blktrace_api.h>
 #include <linux/blkdev.h>
 #include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#ifndef _TRACE_BLOCK_DEF_
+#define _TRACE_BLOCK_DEF_
+
+static inline int blk_cmd_buf_len(struct request *rq)
+{
+	return (rq->cmd_type == REQ_TYPE_BLOCK_PC) ? rq->cmd_len : 0;
+}
+
+const char *blk_dump_cmd(struct trace_seq *p, unsigned char *cmd, int len);
+#define __blk_dump_cmd(cmd, len)	blk_dump_cmd(p, cmd, len)
+
+enum {
+	RWBS_FLAG_WRITE		= (1 << 0),
+	RWBS_FLAG_DISCARD	= (1 << 1),
+	RWBS_FLAG_READ		= (1 << 2),
+	RWBS_FLAG_RAHEAD	= (1 << 3),
+	RWBS_FLAG_HARDBARRIER	= (1 << 4),
+	RWBS_FLAG_SYNC		= (1 << 5),
+	RWBS_FLAG_META		= (1 << 6),
+	RWBS_FLAG_SECURE	= (1 << 7),
+};
+
+#endif /* _TRACE_BLOCK_DEF_ */
+
+#define __print_rwbs_flags(rwbs)		\
+	__print_flags(rwbs, "",			\
+		{ RWBS_FLAG_WRITE, "W" },	\
+		{ RWBS_FLAG_DISCARD, "D" },	\
+		{ RWBS_FLAG_READ, "R" },	\
+		{ RWBS_FLAG_RAHEAD, "A" },	\
+		{ RWBS_FLAG_HARDBARRIER, "B" },	\
+		{ RWBS_FLAG_SYNC, "S" },	\
+		{ RWBS_FLAG_META, "M" },	\
+		{ RWBS_FLAG_SECURE, "E" })
+
+#define blk_fill_rwbs_rq(rwbs, rq)					      \
+		tp_assign(rwbs, ((rq)->cmd_flags & WRITE ? RWBS_FLAG_WRITE :  \
+			((rq)->cmd_flags & REQ_DISCARD ? RWBS_FLAG_DISCARD :  \
+				( blk_rq_bytes(rq) ? RWBS_FLAG_READ :	      \
+				(0))))					      \
+			| ((rq)->cmd_flags & REQ_SECURE ? RWBS_FLAG_SECURE : 0))
+
+#define blk_fill_rwbs(rwbs, rw, bytes)					      \
+		tp_assign(rwbs, ((rw) & WRITE ? RWBS_FLAG_WRITE :	      \
+			( (rw) & REQ_DISCARD ? RWBS_FLAG_DISCARD :	      \
+			( (bytes) ? RWBS_FLAG_READ :			      \
+			( 0 ))))					      \
+			| ((rw) & REQ_RAHEAD ? RWBS_FLAG_RAHEAD : 0)	      \
+			| ((rw) & REQ_HARDBARRIER ? RWBS_FLAG_HARDBARRIER : 0)\
+			| ((rw) & REQ_SYNC ? RWBS_FLAG_SYNC : 0)	      \
+			| ((rw) & REQ_META ? RWBS_FLAG_META : 0)	      \
+			| ((rw) & REQ_SECURE ? RWBS_FLAG_SECURE : 0))
 
 DECLARE_EVENT_CLASS(block_rq_with_error,
 
@@ -19,25 +73,26 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  int,		errors			)
-		__array(  char,		rwbs,	6		)
+		__field(  unsigned int,	rwbs			)
 		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
 	),
 
 	TP_fast_assign(
-		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
-		__entry->sector    = (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
-					0 : blk_rq_pos(rq);
-		__entry->nr_sector = (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
-					0 : blk_rq_sectors(rq);
-		__entry->errors    = rq->errors;
-
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
-		blk_dump_cmd(__get_str(cmd), rq);
+		tp_assign(dev, rq->rq_disk ? disk_devt(rq->rq_disk) : 0)
+		tp_assign(sector, (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+					0 : blk_rq_pos(rq))
+		tp_assign(nr_sector, (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+					0 : blk_rq_sectors(rq))
+		tp_assign(errors, rq->errors)
+		blk_fill_rwbs_rq(rwbs, rq)
+		tp_memcpy_dyn(cmd, rq->cmd, blk_cmd_buf_len(rq))
 	),
 
 	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __get_str(cmd),
+		  __print_rwbs_flags(__entry->rwbs),
+		  __blk_dump_cmd(__get_dynamic_array(cmd),
+				 __get_dynamic_array_len(cmd)),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->errors)
 );
@@ -104,28 +159,30 @@ DECLARE_EVENT_CLASS(block_rq,
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  unsigned int,	bytes			)
-		__array(  char,		rwbs,	6		)
+		__field(  unsigned int,	rwbs			)
 		__array(  char,         comm,   TASK_COMM_LEN   )
 		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
 	),
 
 	TP_fast_assign(
-		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
-		__entry->sector    = (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
-					0 : blk_rq_pos(rq);
-		__entry->nr_sector = (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
-					0 : blk_rq_sectors(rq);
-		__entry->bytes     = (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
-					blk_rq_bytes(rq) : 0;
-
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
-		blk_dump_cmd(__get_str(cmd), rq);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		tp_assign(dev, rq->rq_disk ? disk_devt(rq->rq_disk) : 0)
+		tp_assign(sector, (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+					0 : blk_rq_pos(rq))
+		tp_assign(nr_sector, (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+					0 : blk_rq_sectors(rq))
+		tp_assign(bytes, (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
+					blk_rq_bytes(rq) : 0)
+		blk_fill_rwbs_rq(rwbs, rq)
+		tp_memcpy_dyn(cmd, rq->cmd, blk_cmd_buf_len(rq))
+		tp_memcpy(comm, current->comm, TASK_COMM_LEN)
 	),
 
 	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->rwbs, __entry->bytes, __get_str(cmd),
+		  __print_rwbs_flags(__entry->rwbs),
+		  __entry->bytes,
+		  __blk_dump_cmd(__get_dynamic_array(cmd),
+				 __get_dynamic_array_len(cmd)),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->comm)
 );
@@ -183,21 +240,22 @@ TRACE_EVENT(block_bio_bounce,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__field( unsigned int,	rwbs			)
 		__array( char,		comm,	TASK_COMM_LEN	)
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev ?
-					  bio->bi_bdev->bd_dev : 0;
-		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		tp_assign(dev, bio->bi_bdev ?
+					  bio->bi_bdev->bd_dev : 0)
+		tp_assign(sector, bio->bi_sector)
+		tp_assign(nr_sector, bio->bi_size >> 9)
+		blk_fill_rwbs(rwbs, bio->bi_rw, bio->bi_size)
+		tp_memcpy(comm, current->comm, TASK_COMM_LEN)
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_rwbs_flags(__entry->rwbs),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->comm)
 );
@@ -221,18 +279,19 @@ TRACE_EVENT(block_bio_complete,
 		__field( sector_t,	sector		)
 		__field( unsigned,	nr_sector	)
 		__field( int,		error		)
-		__array( char,		rwbs,	6	)
+		__field( unsigned int,	rwbs		)
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		tp_assign(dev, bio->bi_bdev->bd_dev)
+		tp_assign(sector, bio->bi_sector)
+		tp_assign(nr_sector, bio->bi_size >> 9)
+		blk_fill_rwbs(rwbs, bio->bi_rw, bio->bi_size)
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%d]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_rwbs_flags(__entry->rwbs),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->error)
 );
@@ -247,20 +306,21 @@ DECLARE_EVENT_CLASS(block_bio,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__field( unsigned int,	rwbs			)
 		__array( char,		comm,	TASK_COMM_LEN	)
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		tp_assign(dev, bio->bi_bdev->bd_dev)
+		tp_assign(sector, bio->bi_sector)
+		tp_assign(nr_sector, bio->bi_size >> 9)
+		blk_fill_rwbs(rwbs, bio->bi_rw, bio->bi_size)
+		tp_memcpy(comm, current->comm, TASK_COMM_LEN)
 	),
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_rwbs_flags(__entry->rwbs),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->comm)
 );
@@ -319,21 +379,21 @@ DECLARE_EVENT_CLASS(block_get_rq,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
-		__array( char,		rwbs,	6		)
+		__field( unsigned int,	rwbs			)
 		__array( char,		comm,	TASK_COMM_LEN	)
         ),
 
 	TP_fast_assign(
-		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
-		__entry->sector		= bio ? bio->bi_sector : 0;
-		__entry->nr_sector	= bio ? bio->bi_size >> 9 : 0;
-		blk_fill_rwbs(__entry->rwbs,
-			      bio ? bio->bi_rw : 0, __entry->nr_sector);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		tp_assign(dev, bio ? bio->bi_bdev->bd_dev : 0)
+		tp_assign(sector, bio ? bio->bi_sector : 0)
+		tp_assign(nr_sector, bio ? bio->bi_size >> 9 : 0)
+		blk_fill_rwbs(rwbs, bio ? bio->bi_rw : 0, __entry->nr_sector)
+		tp_memcpy(comm, current->comm, TASK_COMM_LEN)
         ),
 
 	TP_printk("%d,%d %s %llu + %u [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_rwbs_flags(__entry->rwbs),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector, __entry->comm)
 );
@@ -391,7 +451,7 @@ TRACE_EVENT(block_plug,
 	),
 
 	TP_fast_assign(
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		tp_memcpy(comm, current->comm, TASK_COMM_LEN)
 	),
 
 	TP_printk("[%s]", __entry->comm)
@@ -409,8 +469,8 @@ DECLARE_EVENT_CLASS(block_unplug,
 	),
 
 	TP_fast_assign(
-		__entry->nr_rq	= q->rq.count[READ] + q->rq.count[WRITE];
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		tp_assign(nr_rq, q->rq.count[READ] + q->rq.count[WRITE])
+		tp_memcpy(comm, current->comm, TASK_COMM_LEN)
 	),
 
 	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
@@ -466,20 +526,21 @@ TRACE_EVENT(block_split,
 		__field( dev_t,		dev				)
 		__field( sector_t,	sector				)
 		__field( sector_t,	new_sector			)
-		__array( char,		rwbs,		6		)
+		__field( unsigned int,	rwbs		)
 		__array( char,		comm,		TASK_COMM_LEN	)
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
-		__entry->new_sector	= new_sector;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
-		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
+		tp_assign(dev, bio->bi_bdev->bd_dev)
+		tp_assign(sector, bio->bi_sector)
+		tp_assign(new_sector, new_sector)
+		blk_fill_rwbs(rwbs, bio->bi_rw, bio->bi_size)
+		tp_memcpy(comm, current->comm, TASK_COMM_LEN)
 	),
 
 	TP_printk("%d,%d %s %llu / %llu [%s]",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_rwbs_flags(__entry->rwbs),
 		  (unsigned long long)__entry->sector,
 		  (unsigned long long)__entry->new_sector,
 		  __entry->comm)
@@ -508,20 +569,21 @@ TRACE_EVENT(block_remap,
 		__field( unsigned int,	nr_sector	)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
-		__array( char,		rwbs,	6	)
+		__field( unsigned int,	rwbs		)
 	),
 
 	TP_fast_assign(
-		__entry->dev		= bio->bi_bdev->bd_dev;
-		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
-		__entry->old_dev	= dev;
-		__entry->old_sector	= from;
-		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
+		tp_assign(dev, bio->bi_bdev->bd_dev)
+		tp_assign(sector, bio->bi_sector)
+		tp_assign(nr_sector, bio->bi_size >> 9)
+		tp_assign(old_dev, dev)
+		tp_assign(old_sector, from)
+		blk_fill_rwbs(rwbs, bio->bi_rw, bio->bi_size)
 	),
 
 	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_rwbs_flags(__entry->rwbs),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
@@ -552,26 +614,31 @@ TRACE_EVENT(block_rq_remap,
 		__field( unsigned int,	nr_sector	)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
-		__array( char,		rwbs,	6	)
+		__field( unsigned int,	rwbs		)
 	),
 
 	TP_fast_assign(
-		__entry->dev		= disk_devt(rq->rq_disk);
-		__entry->sector		= blk_rq_pos(rq);
-		__entry->nr_sector	= blk_rq_sectors(rq);
-		__entry->old_dev	= dev;
-		__entry->old_sector	= from;
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		tp_assign(dev, disk_devt(rq->rq_disk))
+		tp_assign(sector, blk_rq_pos(rq))
+		tp_assign(nr_sector, blk_rq_sectors(rq))
+		tp_assign(old_dev, dev)
+		tp_assign(old_sector, from)
+		blk_fill_rwbs_rq(rwbs, rq)
 	),
 
 	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_rwbs_flags(__entry->rwbs),
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
 		  (unsigned long long)__entry->old_sector)
 );
 
+#undef __print_rwbs_flags
+#undef blk_fill_rwbs
+#undef blk_fill_rwbs_rq
+
 #endif /* _TRACE_BLOCK_H */
 
 /* This part must be outside protection */
Index: linux-2.6-lttng/include/linux/blktrace_api.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/blktrace_api.h
+++ linux-2.6-lttng/include/linux/blktrace_api.h
@@ -236,18 +236,5 @@ struct compat_blk_user_trace_setup {
 
 #endif
 
-#if defined(CONFIG_EVENT_TRACING) && defined(CONFIG_BLOCK)
-
-static inline int blk_cmd_buf_len(struct request *rq)
-{
-	return (rq->cmd_type == REQ_TYPE_BLOCK_PC) ? rq->cmd_len * 3 : 1;
-}
-
-extern void blk_dump_cmd(char *buf, struct request *rq);
-extern void blk_fill_rwbs(char *rwbs, u32 rw, int bytes);
-extern void blk_fill_rwbs_rq(char *rwbs, struct request *rq);
-
-#endif /* CONFIG_EVENT_TRACING && CONFIG_BLOCK */
-
 #endif /* __KERNEL__ */
 #endif
Index: linux-2.6-lttng/kernel/trace/blktrace.c
===================================================================
--- linux-2.6-lttng.orig/kernel/trace/blktrace.c
+++ linux-2.6-lttng/kernel/trace/blktrace.c
@@ -26,6 +26,7 @@
 #include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/uaccess.h>
+#include <linux/trace_seq.h>
 
 #include <trace/events/block.h>
 
@@ -1773,15 +1774,14 @@ void blk_trace_remove_sysfs(struct devic
 
 #ifdef CONFIG_EVENT_TRACING
 
-void blk_dump_cmd(char *buf, struct request *rq)
+const char *blk_dump_cmd(struct trace_seq *p, unsigned char *cmd, int len)
 {
+	const char *ret = p->buffer + p->len;
 	int i, end;
-	int len = rq->cmd_len;
-	unsigned char *cmd = rq->cmd;
 
-	if (rq->cmd_type != REQ_TYPE_BLOCK_PC) {
-		buf[0] = '\0';
-		return;
+	if (!len) {
+		trace_seq_putc(p, 0);
+		return ret;
 	}
 
 	for (end = len - 1; end >= 0; end--)
@@ -1790,55 +1790,14 @@ void blk_dump_cmd(char *buf, struct requ
 	end++;
 
 	for (i = 0; i < len; i++) {
-		buf += sprintf(buf, "%s%02x", i == 0 ? "" : " ", cmd[i]);
+		trace_seq_printf(p, "%s%02x", i == 0 ? "" : " ", cmd[i]);
 		if (i == end && end != len - 1) {
-			sprintf(buf, " ..");
+			trace_seq_printf(p, " ..");
 			break;
 		}
 	}
-}
-
-void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
-{
-	int i = 0;
-
-	if (rw & WRITE)
-		rwbs[i++] = 'W';
-	else if (rw & REQ_DISCARD)
-		rwbs[i++] = 'D';
-	else if (bytes)
-		rwbs[i++] = 'R';
-	else
-		rwbs[i++] = 'N';
-
-	if (rw & REQ_RAHEAD)
-		rwbs[i++] = 'A';
-	if (rw & REQ_HARDBARRIER)
-		rwbs[i++] = 'B';
-	if (rw & REQ_SYNC)
-		rwbs[i++] = 'S';
-	if (rw & REQ_META)
-		rwbs[i++] = 'M';
-	if (rw & REQ_SECURE)
-		rwbs[i++] = 'E';
-
-	rwbs[i] = '\0';
-}
-
-void blk_fill_rwbs_rq(char *rwbs, struct request *rq)
-{
-	int rw = rq->cmd_flags & 0x03;
-	int bytes;
-
-	if (rq->cmd_flags & REQ_DISCARD)
-		rw |= REQ_DISCARD;
-
-	if (rq->cmd_flags & REQ_SECURE)
-		rw |= REQ_SECURE;
-
-	bytes = blk_rq_bytes(rq);
-
-	blk_fill_rwbs(rwbs, rw, bytes);
+	trace_seq_putc(p, 0);
+	return ret;
 }
 
 #endif /* CONFIG_EVENT_TRACING */

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
