Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1C1WQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:16:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab1C1WQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:16:01 -0400
Date: Mon, 28 Mar 2011 18:15:47 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE (was: Re: elevator
 private data for REQ_FLUSH)
Message-ID: <20110328221547.GA1118@redhat.com>
References: <20110325151530.GA4414@swordfish.minsk.epam.com>
 <20110325152228.GA1707@gentoo.trippels.de>
 <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
 <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328082321.GC16530@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28 2011 at  4:23am -0400,
Tejun Heo <tj@kernel.org> wrote:

> On Sat, Mar 26, 2011 at 12:21:56AM -0400, Mike Snitzer wrote:
> > Should blk_kick_flush() process the flush request without calling
> > elv_insert() -- like is done with open coded list_add() in
> > blk_insert_flush()?
> > 
> > Or should blk_insert_flush() use elv_insert() with
> > ELEVATOR_INSERT_REQUEUE too? 
> 
> Hmmm... I would prefer the latter.  Given that INSERT_REQUEUE and
> FRONT are no longer different, it would probably be better to use
> FRONT tho.  The only reason REQUEUE is used there is to avoid kicking
> the queue from elv_insert(), which is gone now.

OK, I came up with the following patch.

Jens, this is just a natural cleanup given the code that resulted from
the flush-merge and onstack plugging changes coming together.


From: Mike Snitzer <snitzer@redhat.com>
Subject: block: eliminate ELEVATOR_INSERT_REQUEUE

elv_insert() no longer has a need to differentiate between
ELEVATOR_INSERT_REQUEUE and ELEVATOR_INSERT_FRONT.  The onstack plugging
changes eliminated the need to avoid unplugging the queue (via
ELEVATOR_INSERT_REQUEUE).

Also, in blk_insert_flush(), use elv_insert() with ELEVATOR_INSERT_FRONT
rather than open-coding the equivalent.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-flush.c        |    4 ++--
 block/elevator.c         |    3 +--
 include/linux/elevator.h |    5 ++---
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 93d5fd8..2c43044 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -261,7 +261,7 @@ static bool blk_kick_flush(struct request_queue *q)
 	q->flush_rq.end_io = flush_end_io;
 
 	q->flush_pending_idx ^= 1;
-	elv_insert(q, &q->flush_rq, ELEVATOR_INSERT_REQUEUE);
+	elv_insert(q, &q->flush_rq, ELEVATOR_INSERT_FRONT);
 	return true;
 }
 
@@ -312,7 +312,7 @@ void blk_insert_flush(struct request *rq)
 	 */
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
-		list_add(&rq->queuelist, &q->queue_head);
+		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 		return;
 	}
 
diff --git a/block/elevator.c b/block/elevator.c
index c387d31..df7c4ba 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -610,7 +610,7 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
-	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
+	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
 
 void elv_drain_elevator(struct request_queue *q)
@@ -662,7 +662,6 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 	rq->q = q;
 
 	switch (where) {
-	case ELEVATOR_INSERT_REQUEUE:
 	case ELEVATOR_INSERT_FRONT:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
 		list_add(&rq->queuelist, &q->queue_head);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index d93efcc445..0b4a354 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -164,9 +164,8 @@ extern struct request *elv_rb_find(struct rb_root *, sector_t);
 #define ELEVATOR_INSERT_FRONT	1
 #define ELEVATOR_INSERT_BACK	2
 #define ELEVATOR_INSERT_SORT	3
-#define ELEVATOR_INSERT_REQUEUE	4
-#define ELEVATOR_INSERT_FLUSH	5
-#define ELEVATOR_INSERT_SORT_MERGE	6
+#define ELEVATOR_INSERT_FLUSH	4
+#define ELEVATOR_INSERT_SORT_MERGE	5
 
 /*
  * return values from elevator_may_queue_fn

