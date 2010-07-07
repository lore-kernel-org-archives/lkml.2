Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab0GGXzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 19:55:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:42212 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0GGXzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 19:55:11 -0400
Date: Thu, 8 Jul 2010 08:54:59 +0900
To: hch@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] remove q->prepare_flush_fn hook
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100707195209.GA25635@infradead.org>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100707195209.GA25635@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100708085404K.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 08 Jul 2010 08:54:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010 15:52:09 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> One weird thing after this set is that the flush commands don't have any
> cmd_type.  I think it should be set to REQ_TYPE_FS, even if we might be
> resetting it inside the driver for now.

I think even before this patchset, the block layer doesn't set
rq->cmd_type on flush requests (scsi and Ode sets it in
prepare_flush_fn).

I agree that we should set rq->cmd_type. And it should be REQ_TYPE_FS
by definition.

>From a quick look, setting REQ_TYPE_FS in the block layer doesn't
cause problems to the users of flush requests.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] block: set REQ_TYPE_FS on flush requests

the block layer doesn't set rq->cmd_type on flush requests. By
definition, it should be REQ_TYPE_FS (the lower layers build a command
and interpret the result of it, that is, the block layer doesn't know
the details).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/blk-barrier.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index eefbde8..e7fed5e 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -134,6 +134,7 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	}
 
 	blk_rq_init(q, rq);
+	rq->cmd_type = REQ_TYPE_FS;
 	rq->cmd_flags = REQ_HARDBARRIER | REQ_FLUSH;
 	rq->rq_disk = q->bar_rq.rq_disk;
 	rq->end_io = end_io;
-- 
1.6.5

