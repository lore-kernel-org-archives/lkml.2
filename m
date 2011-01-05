Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1AETe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:34:28 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40590 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751798Ab1AETe1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:34:27 -0500
Date: Wed, 5 Jan 2011 14:34:25 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <jens.axboe@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Alan.Brunelle@hp.com
Subject: Re: [RFC patch 1/5] trace event block fix unassigned field
Message-ID: <20110105193425.GA9510@Krystal>
References: <20110104231629.996422888@efficios.com> <20110104232419.097998611@efficios.com> <x498vyzqten.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <x498vyzqten.fsf@segfault.boston.devel.redhat.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:32:14 up 43 days, 35 min,  5 users,  load average: 0.04, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Moyer (jmoyer@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> 
> > The "error" field in block_bio_complete is not assigned, leaving the memory area
> > uninitialized (keeping garbage data). Initialize it to 0.
> >
> > We should eventually remove this field when we find out if blktrace can live
> > without it.
> 
> Well, I'm fairly sure blkparse has the ability to print this field out,
> so we should probably just fill it in properly.  Something like the
> following untested patch should do.

I updated your patch slightly (documentation and build fix). It should be fine
now. Thanks!

Mathieu


trace event block fix unassigned field

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
CC: Jens Axboe <jens.axboe@oracle.com>
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
