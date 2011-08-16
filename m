Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1HPGJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:09:17 -0400
Received: from na3sys010aog107.obsmtp.com ([74.125.245.82]:54904 "HELO
	na3sys010aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751456Ab1HPGJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:09:15 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Aug 2011 02:09:15 EDT
From: Eric Seppanen <eric@purestorage.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Roland Dreier <roland@purestorage.com>,
        Eric Seppanen <eric@purestorage.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Jiang <dave.jiang@intel.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH 1/2] block: Fix queue_flag update when rq_affinity goes from 2 to 1
Date: Mon, 15 Aug 2011 23:02:19 -0700
Message-Id: <1313474539-5540-1-git-send-email-eric@purestorage.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Seppanen <eric@purestorage.com>

Commit 5757a6d76cdf added the QUEUE_FLAG_SAME_FORCE flag, but fails to
clear that flag when the current state is '2' (SAME_COMP + SAME_FORCE)
and the new state is '1' (SAME_COMP).

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Reviewed-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Eric Seppanen <eric@purestorage.com>

---
 block/blk-sysfs.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..e681805 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -258,11 +258,13 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 
 	ret = queue_var_store(&val, page, count);
 	spin_lock_irq(q->queue_lock);
-	if (val) {
+	if (val == 2) {
 		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
-		if (val == 2)
-			queue_flag_set(QUEUE_FLAG_SAME_FORCE, q);
-	} else {
+		queue_flag_set(QUEUE_FLAG_SAME_FORCE, q);
+	} else if (val == 1) {
+		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
+		queue_flag_clear(QUEUE_FLAG_SAME_FORCE, q);
+	} else if (val == 0) {
 		queue_flag_clear(QUEUE_FLAG_SAME_COMP, q);
 		queue_flag_clear(QUEUE_FLAG_SAME_FORCE, q);
 	}
-- 
1.7.4.1

