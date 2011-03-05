Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1CEBDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:03:07 -0500
Received: from kroah.org ([198.145.64.141]:50477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932462Ab1CEBA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:40 2011
Message-Id: <20110305005640.736605611@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [63/73] block: blk-flush shouldnt call directly into q->request_fn() __blk_run_queue()
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 255bb490c8c27eed484d538efe6ef6a7473bd3f6 upstream.

blk-flush decomposes a flush into sequence of multiple requests.  On
completion of a request, the next one is queued; however, block layer
must not implicitly call into q->request_fn() directly from completion
path.  This makes the queue behave unexpectedly when seen from the
drivers and violates the assumption that q->request_fn() is called
with process context + queue_lock.

This patch makes blk-flush the following two changes to make sure
q->request_fn() is not called directly from request completion path.

- blk_flush_complete_seq_end_io() now asks __blk_run_queue() to always
  use kblockd instead of calling directly into q->request_fn().

- queue_next_fseq() uses ELEVATOR_INSERT_REQUEUE instead of
  ELEVATOR_INSERT_FRONT so that elv_insert() doesn't try to unplug the
  request queue directly.

Reported by Jan in the following threads.

 http://thread.gmane.org/gmane.linux.ide/48778
 http://thread.gmane.org/gmane.linux.ide/48786

stable: applicable to v2.6.37.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jan Beulich <JBeulich@novell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-flush.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -66,10 +66,12 @@ static void blk_flush_complete_seq_end_i
 
 	/*
 	 * Moving a request silently to empty queue_head may stall the
-	 * queue.  Kick the queue in those cases.
+	 * queue.  Kick the queue in those cases.  This function is called
+	 * from request completion path and calling directly into
+	 * request_fn may confuse the driver.  Always use kblockd.
 	 */
 	if (was_empty && next_rq)
-		__blk_run_queue(q, false);
+		__blk_run_queue(q, true);
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -130,7 +132,7 @@ static struct request *queue_next_fseq(s
 		BUG();
 	}
 
-	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
+	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
 	return rq;
 }
 


