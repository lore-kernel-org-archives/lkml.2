Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1CYQHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:07:16 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:35755 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab1CYQHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:07:13 -0400
X-ASG-Debug-ID: 1301069232-03d6a555d501dd0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8CBDAB.2010507@fusionio.com>
Date: Fri, 25 Mar 2011 17:07:07 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <chris.mason@oracle.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Two fixups for the block IO merge
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Two fixups for the block IO merge
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301069232
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58939
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

An embarassing bug made the block IO merge a bit less enjoyable for some
people than it should have.

- The oops problem (with CFQ), or potential corruption (with noop) due
  to a bad insertion type for some requests.

- A warning spew on virt_io using blk_stop_queue() inside it's callback.

Please pull these two fixes, so hopefully we can put this behind us.
Thanks a lot to the people involved with fixing the first issue.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (2):
      block: fix bug with inserting flush requests as sort/merge
      block: fix issue with calling blk_stop_queue() from the request_fn handler

 block/blk-core.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 59b5c00..e0a0623 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -271,7 +271,7 @@ EXPORT_SYMBOL(blk_start_queue);
  **/
 void blk_stop_queue(struct request_queue *q)
 {
-	cancel_delayed_work(&q->delay_work);
+	__cancel_delayed_work(&q->delay_work);
 	queue_flag_set(QUEUE_FLAG_STOPPED, q);
 }
 EXPORT_SYMBOL(blk_stop_queue);
@@ -2702,7 +2702,10 @@ static void flush_plug_list(struct blk_plug *plug)
 		/*
 		 * rq is already accounted, so use raw insert
 		 */
-		__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
+		if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA))
+			__elv_add_request(q, rq, ELEVATOR_INSERT_FLUSH);
+		else
+			__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
 	}
 
 	if (q) {

-- 
Jens Axboe

