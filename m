Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2E2BO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 21:14:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab2E2BO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 21:14:58 -0400
From: Asias He <asias@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Asias He <asias@redhat.com>
Subject: [PATCH V2] block: Avoid missed wakeup in request waitqueue
Date: Tue, 29 May 2012 09:15:00 +0800
Message-Id: <1338254100-13336-1-git-send-email-asias@redhat.com>
In-Reply-To: <20120528102614.GC15202@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120528102614.GC15202@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After hot-unplug a stressed disk, I found that rl->wait[] is not empty
while rl->count[] is empty and there are theads still sleeping on
get_request after the queue cleanup. With simple debug code, I found
there are exactly nr_sleep - nr_wakeup of theads in D state. So there
are missed wakeup.

  $ dmesg | grep nr_sleep
  [   52.917115] ---> nr_sleep=1046, nr_wakeup=873, delta=173
  $ vmstat 1
  1 173  0 712640  24292  96172 0 0  0  0  419  757  0  0  0 100  0

To quote Tejun:

  Ah, okay, freed_request() wakes up single waiter with the assumption
  that after the wakeup there will at least be one successful allocation
  which in turn will continue the wakeup chain until the wait list is
  empty - ie. waiter wakeup is dependent on successful request
  allocation happening after each wakeup.  With queue marked dead, any
  woken up waiter fails the allocation path, so the wakeup chaining is
  lost and we're left with hung waiters. What we need is wake_up_all()
  after drain completion.

This patch fixes the missed wakeup by waking up all the theads which
are sleeping on wait queue after queue drain.

Changes in v2: Drop waitqueue_active() optimization

Signed-off-by: Asias He <asias@redhat.com>
---
 block/blk-core.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1f61b74..232fe89 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -359,9 +359,10 @@ EXPORT_SYMBOL(blk_put_queue);
  */
 void blk_drain_queue(struct request_queue *q, bool drain_all)
 {
+	int i;
+
 	while (true) {
 		bool drain = false;
-		int i;
 
 		spin_lock_irq(q->queue_lock);
 
@@ -400,6 +401,16 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 			break;
 		msleep(10);
 	}
+
+	/*
+	 * With queue marked dead, any woken up waiter will fail the
+	 * allocation path, so the wakeup chaining is lost and we're
+	 * left with hung waiters. We need to wake up those waiters.
+	 */
+	spin_lock_irq(q->queue_lock);
+	for (i = 0; i < ARRAY_SIZE(q->rq.wait); i++)
+		wake_up_all(&q->rq.wait[i]);
+	spin_unlock_irq(q->queue_lock);
 }
 
 /**
-- 
1.7.10.2

