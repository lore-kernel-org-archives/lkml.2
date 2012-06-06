Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab2FFS7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:59:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41018 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab2FFS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:59:08 -0400
MIME-Version: 1.0
Date: Wed, 6 Jun 2012 11:59:06 -0700
Message-ID: <CAFR8ueerYD20q7fmfUrR=wFfsBA7mwXR8DEyShfp1u6DmHvGsQ@mail.gmail.com>
Subject: Q: blk_execute_rq_nowait() doesn't call completion in case of dead queue
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, tj@kernel.org,
        James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, Tejun et al,
blk_execute_rq() calls blk_execute_rq_nowait() with blk_end_sync_rq()
as the completion (done) routine. And then waits for the completion().


	rq->end_io_data = &wait;
	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
        ...
        ...
        wait_for_completion(&wait)

But in blk_execute_rq_nowait() if the queue is dead, completion
routine is not called. Shouldn't we have to call the above completion
(done()) to wake up the wait_for_completion()?


        if (unlikely(blk_queue_dead(q))) {
		spin_unlock_irq(q->queue_lock);
		rq->errors = -ENXIO;
		if (rq->end_io)
			rq->end_io(rq, rq->errors);
		return;
       }

Thanks.

Regards,
Muthu
