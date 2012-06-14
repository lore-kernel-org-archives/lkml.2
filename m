Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2FNJQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:16:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37723 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab2FNJQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:16:49 -0400
Message-ID: <4FD9ABFA.2030806@kernel.dk>
Date: Thu, 14 Jun 2012 11:16:42 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "jirisl >> Jiri Slaby" <jirislaby@gmail.com>,
        Asias He <asias@redhat.com>
Subject: Re: NULL pointer dereference at blk_drain_queue
References: <4FD9A908.90307@suse.cz>
In-Reply-To: <4FD9A908.90307@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 11:04 AM, Jiri Slaby wrote:
> Hi,
> 
> with today's -next I'm (reproducibly) getting this while updating packages:
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff8108cd16>] __wake_up_common+0x26/0x90
> PGD 463f1067 PUD 463f2067 PMD 0
> Oops: 0000 [#1] SMP
> CPU 1
> Modules linked in:
> Pid: 2711, comm: kworker/1:0 Not tainted 3.5.0-rc2-next-20120614_64+
> #1752 Bochs Bochs
> RIP: 0010:[<ffffffff8108cd16>]  [<ffffffff8108cd16>]
> __wake_up_common+0x26/0x90
> RSP: 0018:ffff880047221cb0  EFLAGS: 00010082
> RAX: 0000000000000086 RBX: ffff880046350888 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff880046350888
> RBP: ffff880047221cf0 R08: 0000000000000000 R09: 00000001000c0009
> R10: ffff880047804480 R11: 0000000000000000 R12: ffff880046350890
> R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000003
> FS:  0000000000000000(0000) GS:ffff880049700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000045ced000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kworker/1:0 (pid: 2711, threadinfo ffff880047220000, task
> ffff8800435bc5c0)
> Stack:
>  000000004628da68 0000000000000000 ffff88004970d340 ffff880046350888
>  0000000000000086 0000000000000003 0000000000000000 0000000000000000
>  ffff880047221d30 ffffffff8108d9a3 ffff88004970d340 ffff880046350848
> Call Trace:
>  [<ffffffff8108d9a3>] __wake_up+0x43/0x70
>  [<ffffffff81267f96>] blk_drain_queue+0xf6/0x120
>  [<ffffffff8126803f>] blk_cleanup_queue+0x7f/0xd0
>  [<ffffffff814a9a80>] md_free+0x50/0x70
>  [<ffffffff8127b3c2>] kobject_cleanup+0x82/0x1b0
>  [<ffffffff8127b24b>] kobject_put+0x2b/0x60
>  [<ffffffff814a97ef>] mddev_delayed_delete+0x2f/0x40
>  [<ffffffff8107e1ab>] process_one_work+0x11b/0x3f0
>  [<ffffffff814a97c0>] ? restart_array+0xc0/0xc0
>  [<ffffffff8107f94e>] worker_thread+0x12e/0x340
>  [<ffffffff8107f820>] ? manage_workers.isra.29+0x1f0/0x1f0
>  [<ffffffff81084e1e>] kthread+0x8e/0xa0
>  [<ffffffff8160add4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81084d90>] ? flush_kthread_worker+0x70/0x70
>  [<ffffffff8160add0>] ? gs_change+0xb/0xb
> Code: 80 00 00 00 00 55 48 89 e5 41 57 41 89 f7 41 56 41 89 ce 41 55 41
> 54 4c 8d 67 08 53 48 83 ec 18 89 55 c4 48 8b 57 08 4c 89 45 c8 <4c> 8b
> 2a 48 8d 42 e8 49 83 ed 18 49 39 d4 75 0d eb 40 0f 1f 84

It's a bug in local commit bc85cf83, for stacked devices we have not
initialized the wait queues. So the below should fix it, as would always
initializing all queue structures even for the partial use case.


diff --git a/block/blk-core.c b/block/blk-core.c
index b477fa0..93eb3e4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -415,10 +415,12 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 	 * allocation path, so the wakeup chaining is lost and we're
 	 * left with hung waiters. We need to wake up those waiters.
 	 */
-	spin_lock_irq(q->queue_lock);
-	for (i = 0; i < ARRAY_SIZE(q->rq.wait); i++)
-		wake_up_all(&q->rq.wait[i]);
-	spin_unlock_irq(q->queue_lock);
+	if (q->request_fn) {
+		spin_lock_irq(q->queue_lock);
+		for (i = 0; i < ARRAY_SIZE(q->rq.wait); i++)
+			wake_up_all(&q->rq.wait[i]);
+		spin_unlock_irq(q->queue_lock);
+	}
 }
 
 /**

-- 
Jens Axboe

