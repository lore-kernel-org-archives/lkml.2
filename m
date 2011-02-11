Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1BKPaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:30:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55519 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab1BKPaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:30:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MeFhDb0tLouxLwD9JWAoV1FcDsJBxROVsmhfsJXT9oi7oQUCzFtnlGFWqDuvx7COVu
         g3eFlgL18+e7Vp9Wlcff5QH9sIIWBf5BUzhq7EAUEmzkKEXagKVUXVpUAHFPP8mEOacN
         +Fhd50X2KU9Xb6fUYQn1IrHehxkmthNXOPmrc=
Date: Fri, 11 Feb 2011 17:30:05 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: fix queue_lock NULL pointer derefence in
 blk_throtl_exit (v4)
Message-ID: <20110211153005.GA4398@swordfish.minsk.epam.com>
References: <20110211125941.GA4271@swordfish.minsk.epam.com>
 <4D55525C.3080705@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D55525C.3080705@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block: fix queue_lock NULL pointer derefence in blk_throtl_exit

BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
 IP: [<ffffffff812479d4>] do_raw_spin_lock+0x14/0x122
 Process modprobe (pid: 6189, threadinfo ffff88009a898000, task
 ffff880154a88000)                                                        
 Call Trace:                                         
  [<ffffffff81486788>] _raw_spin_lock_irq+0x4a/0x51                         
  [<ffffffff8123404b>] ? blk_throtl_exit+0x3b/0xa0
  [<ffffffff8105b120>] ? cancel_delayed_work_sync+0xd/0xf
  [<ffffffff8123404b>] blk_throtl_exit+0x3b/0xa0   
  [<ffffffff81229bc8>] blk_release_queue+0x21/0x65
  [<ffffffff8123bb06>] kobject_release+0x51/0x66         
  [<ffffffff8123bab5>] ? kobject_release+0x0/0x66
  [<ffffffff8123ce1e>] kref_put+0x43/0x4d         
  [<ffffffff8123ba27>] kobject_put+0x47/0x4b    
  [<ffffffff8122717c>] blk_cleanup_queue+0x56/0x5b
  [<ffffffffa01c3824>] loop_exit+0x68/0x844 [loop]
  [<ffffffff8107cccc>] sys_delete_module+0x1e8/0x25b
  [<ffffffff814864c9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81002112>] system_call_fastpath+0x16/0x1b

because of an attempt to acquire NULL queue_lock.   
Added the same lines as in blk_queue_make_request: 
'fall back to embedded per-queue lock' - when call blk_release_queue on
allocated but never initialized queue.

v4:
Incremental patch to move fall back to embedded per-queue lock from loop_free
to blk_release_queue, because v1 patch was accidentally applied.

v3: According to comment by Vivek Goyal, queue_lock NULL check and fix moved
out from loop driver code to blk_release_queue.


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 block/blk-sysfs.c    |    6 ++++++
 drivers/block/loop.c |    3 ---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 41fb691..2b426ac 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -471,6 +471,12 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_sync_queue(q);
 
+	/* It's possible that blk_release_queue will be called on allocated
+	 * but never initialized queue. Fall back to our embedded per-queue 
+	 * locks in this case. */
+	if (!q->queue_lock)
+		q->queue_lock = &q->__queue_lock;
+
 	blk_throtl_exit(q);
 
 	if (rl->rq_pool)
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 49e6a54..44e18c0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1641,9 +1641,6 @@ out:
 
 static void loop_free(struct loop_device *lo)
 {
-	if (!lo->lo_queue->queue_lock)
-		lo->lo_queue->queue_lock = &lo->lo_queue->__queue_lock;
-
 	blk_cleanup_queue(lo->lo_queue);
 	put_disk(lo->lo_disk);
 	list_del(&lo->lo_list);

