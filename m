Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1I1BPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:15:19 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:52758
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1I1BPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:15:17 -0400
Message-ID: <4E82751C.9050908@kernel.dk>
Date: Tue, 27 Sep 2011 19:15:08 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Free queue resources at blk_release_queue()
References: <201109221318.p8MDIXPP020015@pentland.suse.de> <20110928004722.GA27421@kernel.dk> <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
In-Reply-To: <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-27 18:55, Linus Torvalds wrote:
> On Tue, Sep 27, 2011 at 5:47 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Do we have acks from the people who saw this oops, that this really does
>> fix it for them? I ask since this fix is vastly cleaner than the other
>> patch floating around, so I'd much rather pull this one in.
> 
> I don't think I can't test it, since it seems to be some hard-to-hit
> race condition. It certainly doesn't seem to happen all the time -
> today was the first time I've seen it on one of my computers.
> 
> But if you forward the actual patch to me (the one I see on lkml seems
> to be broken and doesn't compile cleanly because it's assiging a
> structure to a pointer), I'll try it out anyway.

Thanks, that would be great. It's inlined below.

diff --git a/block/blk-core.c b/block/blk-core.c
index b2ed78a..d34433a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -348,9 +348,10 @@ void blk_put_queue(struct request_queue *q)
 EXPORT_SYMBOL(blk_put_queue);
 
 /*
- * Note: If a driver supplied the queue lock, it should not zap that lock
- * unexpectedly as some queue cleanup components like elevator_exit() and
- * blk_throtl_exit() need queue lock.
+ * Note: If a driver supplied the queue lock, it is disconnected
+ * by this function. The actual state of the lock doesn't matter
+ * here as the request_queue isn't accessible after this point
+ * (QUEUE_FLAG_DEAD is set) and no other requests will be queued.
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
@@ -367,10 +368,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
-		elevator_exit(q->elevator);
-
-	blk_throtl_exit(q);
+	if (q->queue_lock != &q->__queue_lock)
+		q->queue_lock = &q->__queue_lock;
 
 	blk_put_queue(q);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e681805..60fda88 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -479,6 +479,11 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
+	if (q->elevator)
+		elevator_exit(q->elevator);
+
+	blk_throtl_exit(q);
+
 	if (rl->rq_pool)
 		mempool_destroy(rl->rq_pool);
 

-- 
Jens Axboe

