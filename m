Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1BQLRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:17:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54951 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1BQLQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d/hEwP8zkPRIDb2Gz0yVws0MNBCCgCUyoXREFEc9fCCpGSNLdjxyfJo/i3OfgqlJsz
         Nj2q+MJLPKd+Qr9hMN4t0XIPvTgc74gbksg3Le/Tv5xluWOaM9EJAgLnZMo1THY5cm3L
         YHwRVw1avegTbVr7wgcZiUfxACCPzMtUFnLfs=
Date: Thu, 17 Feb 2011 12:16:19 +0100
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Beulich <JBeulich@novell.com>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH v2.6.38-rc5 2/2] block: blk-flush shouldn't call directly
 into q->request_fn() __blk_run_queue()
Message-ID: <20110217111619.GR19830@htj.dyndns.org>
References: <20110217111511.GQ19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217111511.GQ19830@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
Jens, this is applicable to v2.6.37 and 38.  The new implementation
for 39 would need similar fix but I couldn't find where the tree is.
Which branch is it?

Thanks.

 block/blk-flush.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: work/block/blk-flush.c
===================================================================
--- work.orig/block/blk-flush.c
+++ work/block/blk-flush.c
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
 
