Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2BGRRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:17:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2BGRRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:17:20 -0500
Date: Tue, 7 Feb 2012 09:17:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <vivek.goyal2008@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120207171715.GI21292@google.com>
References: <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com>
 <4F303506.9000201@kernel.dk>
 <20120206215451.GD21292@google.com>
 <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com>
 <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
 <20120207164735.GH21292@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207164735.GH21292@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 08:47:35AM -0800, Tejun Heo wrote:
> Yeah, I was about to ask Shaohua to test the version w/o optimization.
> With heavily loaded request_queue, trylock failure could be frequent,
> which I wasn't testing.
> 
> Shaohua, can you please test the version w/o optimization?  Also, can
> you please give a bit more details on the setup?  Are there multiple
> swap devices?  Is it SSD or rotating disk?

Can you please also apply the following patch on top of
block/for-linus and see how it behaves?

Thanks.
---
 block/blk-ioc.c |   54 +++++++++++++++++-------------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

Index: work/block/blk-ioc.c
===================================================================
--- work.orig/block/blk-ioc.c
+++ work/block/blk-ioc.c
@@ -79,52 +79,32 @@ static void ioc_release_fn(struct work_s
 {
 	struct io_context *ioc = container_of(work, struct io_context,
 					      release_work);
-	struct request_queue *last_q = NULL;
+	unsigned long flags;
 
-	spin_lock_irq(&ioc->lock);
+	/*
+	 * Exiting icq may call into put_io_context() through elevator
+	 * which will trigger lockdep warning.  The ioc's are guaranteed to
+	 * be different, use a different locking subclass here.  Using
+	 * irqsave variant as there's no spin_lock_irq_nested().
+	 */
+	spin_lock_irqsave_nested(&ioc->lock, flags, 1);
 
 	while (!hlist_empty(&ioc->icq_list)) {
 		struct io_cq *icq = hlist_entry(ioc->icq_list.first,
 						struct io_cq, ioc_node);
-		struct request_queue *this_q = icq->q;
+		struct request_queue *q = icq->q;
 
-		if (this_q != last_q) {
-			/*
-			 * Need to switch to @this_q.  Once we release
-			 * @ioc->lock, it can go away along with @cic.
-			 * Hold on to it.
-			 */
-			__blk_get_queue(this_q);
-
-			/*
-			 * blk_put_queue() might sleep thanks to kobject
-			 * idiocy.  Always release both locks, put and
-			 * restart.
-			 */
-			if (last_q) {
-				spin_unlock(last_q->queue_lock);
-				spin_unlock_irq(&ioc->lock);
-				blk_put_queue(last_q);
-			} else {
-				spin_unlock_irq(&ioc->lock);
-			}
-
-			last_q = this_q;
-			spin_lock_irq(this_q->queue_lock);
-			spin_lock(&ioc->lock);
-			continue;
+		if (spin_trylock(q->queue_lock)) {
+			ioc_exit_icq(icq);
+			spin_unlock(q->queue_lock);
+		} else {
+			spin_unlock_irqrestore(&ioc->lock, flags);
+			cpu_relax();
+			spin_lock_irqsave_nested(&ioc->lock, flags, 1);
 		}
-		ioc_exit_icq(icq);
-	}
-
-	if (last_q) {
-		spin_unlock(last_q->queue_lock);
-		spin_unlock_irq(&ioc->lock);
-		blk_put_queue(last_q);
-	} else {
-		spin_unlock_irq(&ioc->lock);
 	}
 
+	spin_unlock_irqrestore(&ioc->lock, flags);
 	kmem_cache_free(iocontext_cachep, ioc);
 }
 
