Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0ICKbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:31:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:35560 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab0ICKa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:30:59 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/41] ide: remove unnecessary blk_queue_flushing() test in do_ide_request()
Date: Fri,  3 Sep 2010 12:29:16 +0200
Message-Id: <1283509796-1510-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unplugging from a request function doesn't really help much (it's
already in the request_fn) and soon block layer will be updated to mix
barrier sequence with other commands, so there's no need to treat
queue flushing any differently.

ide was the only user of blk_queue_flushing().  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: David S. Miller <davem@davemloft.net>
---
 drivers/ide/ide-io.c   |   13 -------------
 include/linux/blkdev.h |    1 -
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index a381be8..999dac0 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -441,19 +441,6 @@ void do_ide_request(struct request_queue *q)
 	struct request	*rq = NULL;
 	ide_startstop_t	startstop;
 
-	/*
-	 * drive is doing pre-flush, ordered write, post-flush sequence. even
-	 * though that is 3 requests, it must be seen as a single transaction.
-	 * we must not preempt this drive until that is complete
-	 */
-	if (blk_queue_flushing(q))
-		/*
-		 * small race where queue could get replugged during
-		 * the 3-request flush cycle, just yank the plug since
-		 * we want it to finish asap
-		 */
-		blk_remove_plug(q);
-
 	spin_unlock_irq(q->queue_lock);
 
 	/* HLD do_request() callback might sleep, make sure it's okay */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2c54906..015375c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -521,7 +521,6 @@ enum {
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
-#define blk_queue_flushing(q)	((q)->ordseq)
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
-- 
1.7.1

