Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1CGCkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:40:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48215 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1CGCkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:40:00 -0500
Date: Mon, 7 Mar 2011 13:39:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20110307133957.3b9d814c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

block/blk-flush.c: In function 'flush_end_io':
block/blk-flush.c:217: error: too few arguments to function '__blk_run_queue'
block/blk-flush.c: In function 'flush_data_end_io':
block/blk-flush.c:271: error: too few arguments to function '__blk_run_queue'

Caused by commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae ("block:
reimplement FLUSH/FUA to support merge") interacting with commit
1654e7411a1ad4999fe7890ef51d2a2bbb1fcf76 ("block: add @force_kblockd to
__blk_run_queue()") from Linus' tree.  My merge fix up was obviously not
sufficient.

I added this merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Mar 2011 13:27:04 +1100
Subject: [PATCH] block: update for __blk_run_queue() API update

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 block/blk-flush.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index a867e3f..f9b0228 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -214,7 +214,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 
 	/* after populating an empty queue, kick it to avoid stall */
 	if (queued && was_empty)
-		__blk_run_queue(q);
+		__blk_run_queue(q, false);
 }
 
 /**
@@ -268,7 +268,7 @@ static void flush_data_end_io(struct request *rq, int error)
 
 	/* after populating an empty queue, kick it to avoid stall */
 	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error) && was_empty)
-		__blk_run_queue(q);
+		__blk_run_queue(q, false);
 }
 
 /**
-- 
1.7.4.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
