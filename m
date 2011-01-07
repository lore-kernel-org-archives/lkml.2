Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1AGPPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:15:52 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49076 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab1AGPPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:15:51 -0500
Message-ID: <4D272EBA.5000703@kernel.dk>
Date: Fri, 07 Jan 2011 16:18:18 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blktrace: add missing probe argument to block_bio_complete
References: <20110107015453.GB5109@Krystal> <x498vyw7qe7.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x498vyw7qe7.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-07 15:13, Jeff Moyer wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> 
>> blktrace.c block bio complete callback needs to gain a new argument to reflect
>> the newly added "error" tracepoint argument. This is needed to match the new
>> block_bio_complete TRACE_EVENT as of
>> commit de983a7bfcb7c020901ca6e2314cf55a4207ab5a.
>>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> CC: Jeff Moyer <jmoyer@redhat.com>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> CC: Frederic Weisbecker <fweisbec@gmail.com>
>> CC: Ingo Molnar <mingo@elte.hu>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Jens Axboe <axboe@kernel.dk>
>> CC: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  kernel/trace/blktrace.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6-lttng/kernel/trace/blktrace.c
>> ===================================================================
>> --- linux-2.6-lttng.orig/kernel/trace/blktrace.c
>> +++ linux-2.6-lttng/kernel/trace/blktrace.c
>> @@ -785,7 +785,8 @@ static void blk_add_trace_bio_bounce(voi
>>  }
>>  
>>  static void blk_add_trace_bio_complete(void *ignore,
>> -				       struct request_queue *q, struct bio *bio)
>> +				       struct request_queue *q, struct bio *bio,
>> +				       int error)
>>  {
>>  	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE);
>>  }
> 
> OK, I clearly didn't look closely enough last time.  There's no sense
> passing this information down if it isn't used (as you said initially).
> blk_add_trace_bio sets the error based on whether or not the
> BIO_UPTODATE bit is set.  So, I think we should instead revert the patch
> I sent you (Mathieu), and then completely get rid of the error field in
> the TP macros.
> 
> Does that make sense to everyone else?

We usually use BIO_UPTODATE if we have no other information available.
So if we have, then we should use it.

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index fab31af..153562d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -758,54 +758,58 @@ static void blk_add_trace_rq_complete(void *ignore,
  * @q:		queue the io is for
  * @bio:	the source bio
  * @what:	the action
+ * @error:	error, if any
  *
  * Description:
  *     Records an action against a bio. Will log the bio offset + size.
  *
  **/
 static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
-				     u32 what)
+			      u32 what, int error)
 {
 	struct blk_trace *bt = q->blk_trace;
 
 	if (likely(!bt))
 		return;
 
+	if (!error && !bio_flagged(bio, BIO_UPTODATE))
+		error = EIO;
+
 	__blk_add_trace(bt, bio->bi_sector, bio->bi_size, bio->bi_rw, what,
-			!bio_flagged(bio, BIO_UPTODATE), 0, NULL);
+			error, 0, NULL);
 }
 
 static void blk_add_trace_bio_bounce(void *ignore,
 				     struct request_queue *q, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE);
+	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE, 0);
 }
 
 static void blk_add_trace_bio_complete(void *ignore,
 				       struct request_queue *q, struct bio *bio,
 				       int error)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE);
+	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE, error);
 }
 
 static void blk_add_trace_bio_backmerge(void *ignore,
 					struct request_queue *q,
 					struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE);
+	blk_add_trace_bio(q, bio, BLK_TA_BACKMERGE, 0);
 }
 
 static void blk_add_trace_bio_frontmerge(void *ignore,
 					 struct request_queue *q,
 					 struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE);
+	blk_add_trace_bio(q, bio, BLK_TA_FRONTMERGE, 0);
 }
 
 static void blk_add_trace_bio_queue(void *ignore,
 				    struct request_queue *q, struct bio *bio)
 {
-	blk_add_trace_bio(q, bio, BLK_TA_QUEUE);
+	blk_add_trace_bio(q, bio, BLK_TA_QUEUE, 0);
 }
 
 static void blk_add_trace_getrq(void *ignore,
@@ -813,7 +817,7 @@ static void blk_add_trace_getrq(void *ignore,
 				struct bio *bio, int rw)
 {
 	if (bio)
-		blk_add_trace_bio(q, bio, BLK_TA_GETRQ);
+		blk_add_trace_bio(q, bio, BLK_TA_GETRQ, 0);
 	else {
 		struct blk_trace *bt = q->blk_trace;
 
@@ -828,7 +832,7 @@ static void blk_add_trace_sleeprq(void *ignore,
 				  struct bio *bio, int rw)
 {
 	if (bio)
-		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ);
+		blk_add_trace_bio(q, bio, BLK_TA_SLEEPRQ, 0);
 	else {
 		struct blk_trace *bt = q->blk_trace;
 

-- 
Jens Axboe

