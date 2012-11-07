Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2KGBFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:05:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65064 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2KGBFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:05:33 -0500
Date: Wed, 7 Nov 2012 09:05:27 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block CFQ: avoid moving request to different queue
Message-ID: <20121107010527.GA1501@kernel.org>
References: <20121106113428.GA19182@kernel.org>
 <5098F6E1.6010502@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5098F6E1.6010502@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 12:39:13PM +0100, Jens Axboe wrote:
> On 2012-11-06 12:34, Shaohua Li wrote:
> > request is queued in cfqq->fifo list. Looks it's possible we are
> > moving a request from one cfqq to another in request merge case. In
> > such case, adjusting the fifo list order doesn't make sense and is
> > impossible if we don't iterate the whole fifo list.
> > 
> > My test does hit one case the two cfqq are different, but didn't cause
> > kernel crash, maybe it's because fifo list isn't used frequently.
> > Anyway, from the code logic, this is buggy.
> 
> Good find!! Usually we never merge between cfqq's as our lookup basis is
> the cfqq. And yes, the fifo generally isn't used a lot, it's only a
> fallback measure to prevent inter-cfqq unfairness.
> 
> Applied to for-3.8/core.
> 
> And lets re-enable the recursive merging, please do send a patch for
> that too.
Here it is.


Subject: block: recursive merge requests

In a workload, thread 1 accesses a, a+2, ..., thread 2 accesses a+1, a+3,....
When the requests are flushed to queue, a and a+1 are merged to (a, a+1), a+2
and a+3 too to (a+2, a+3), but (a, a+1) and (a+2, a+3) aren't merged.

If we do recursive merge for such interleave access, some workloads throughput
get improvement. A recent worload I'm checking on is swap, below change
boostes the throughput around 5% ~ 10%.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/elevator.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux/block/elevator.c
===================================================================
--- linux.orig/block/elevator.c	2012-10-15 10:01:52.763544641 +0800
+++ linux/block/elevator.c	2012-11-06 15:16:57.987363075 +0800
@@ -458,6 +458,7 @@ static bool elv_attempt_insert_merge(str
 				     struct request *rq)
 {
 	struct request *__rq;
+	bool ret;
 
 	if (blk_queue_nomerges(q))
 		return false;
@@ -471,14 +472,21 @@ static bool elv_attempt_insert_merge(str
 	if (blk_queue_noxmerges(q))
 		return false;
 
+	ret = false;
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
-	__rq = elv_rqhash_find(q, blk_rq_pos(rq));
-	if (__rq && blk_attempt_req_merge(q, __rq, rq))
-		return true;
+	while (1) {
+		__rq = elv_rqhash_find(q, blk_rq_pos(rq));
+		if (!__rq || !blk_attempt_req_merge(q, __rq, rq))
+			break;
+
+		/* The merged request could be merged with others, try again */
+		ret = true;
+		rq = __rq;
+	}
 
-	return false;
+	return ret;
 }
 
 void elv_merged_request(struct request_queue *q, struct request *rq, int type)
