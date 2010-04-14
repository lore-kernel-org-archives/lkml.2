Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0DNK53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:57:29 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:39820 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542Ab0DNK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:57:28 -0400
Subject: [PATCH] block: blk-timeout.c  ensure jiffies wrap is handled
 correctly in blk_rq_timed_out_timer
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 11:57:25 +0100
Message-ID: <1271242645.2132.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_rq_timed_out_timer() relied on blk_add_timer() never returning a
timer value of zero, but commit 7838c15b8dd18e78a523513749e5b54bda07b0cb
removed the code that bumped this value when it was zero.
Therefore when jiffies is near wrap we could get unlucky & not set the
timeout value correctly.

This patch uses a flag to indicate that the timeout value was set and so
handles jiffies wrap correctly, and it keeps all the logic in one
function so should be easier to maintain in the future. 

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
patch against 2.6.34-rc4
Compiled & tested on x86_64

regards
Richard


diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 1ba7e0a..4f0c06c 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -109,6 +109,7 @@ void blk_rq_timed_out_timer(unsigned long data)
 	struct request_queue *q = (struct request_queue *) data;
 	unsigned long flags, next = 0;
 	struct request *rq, *tmp;
+	int next_set = 0;
 
 	spin_lock_irqsave(q->queue_lock, flags);
 
@@ -122,16 +123,13 @@ void blk_rq_timed_out_timer(unsigned long data)
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


