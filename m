Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab0EJXiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:38:11 -0400
Received: from kroah.org ([198.145.64.141]:33075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401Ab0EJWwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:12 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:21 2010
Message-Id: <20100510223321.258816132@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [045/117] block: ensure jiffies wrap is handled correctly in blk_rq_timed_out_timer
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Kennedy <richard@rsk.demon.co.uk>

commit a534dbe96e9929c7245924d8252d89048c23d569 upstream.

blk_rq_timed_out_timer() relied on blk_add_timer() never returning a
timer value of zero, but commit 7838c15b8dd18e78a523513749e5b54bda07b0cb
removed the code that bumped this value when it was zero.
Therefore when jiffies is near wrap we could get unlucky & not set the
timeout value correctly.

This patch uses a flag to indicate that the timeout value was set and so
handles jiffies wrap correctly, and it keeps all the logic in one
function so should be easier to maintain in the future.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-timeout.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -109,6 +109,7 @@ void blk_rq_timed_out_timer(unsigned lon
 	struct request_queue *q = (struct request_queue *) data;
 	unsigned long flags, next = 0;
 	struct request *rq, *tmp;
+	int next_set = 0;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
@@ -122,16 +123,13 @@ void blk_rq_timed_out_timer(unsigned lon
 			if (blk_mark_rq_complete(rq))
 				continue;
 			blk_rq_timed_out(rq);
-		} else if (!next || time_after(next, rq->deadline))
+		} else if (!next_set || time_after(next, rq->deadline)) {
 			next = rq->deadline;
+			next_set = 1;
+		}
 	}
 
-	/*
-	 * next can never be 0 here with the list non-empty, since we always
-	 * bump ->deadline to 1 so we can detect if the timer was ever added
-	 * or not. See comment in blk_add_timer()
-	 */
-	if (next)
+	if (next_set)
 		mod_timer(&q->timeout, round_jiffies_up(next));
 
 	spin_unlock_irqrestore(q->queue_lock, flags);


