Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0GCIra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:47:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:47318 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab0GCIqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:50 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp,
       James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 3/9] scsi: stop using q->prepare_flush_fn
Date: Sat,  3 Jul 2010 17:45:34 +0900
Message-Id: <1278146740-8731-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi-ml builds flush requests via q->prepare_flush_fn(), however,
builds discard requests via q->prep_rq_fn.

Using two different mechnisms for the similar requests (building
commands in SCSI ULD) doesn't make sense.

Handing both via q->prep_rq_fn makes the code design simpler.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/sd.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aa6b48b..e8c295e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -471,6 +471,18 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	return ret;
 }
 
+static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
+{
+	/* for now, we use REQ_TYPE_BLOCK_PC. */
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->timeout = SD_TIMEOUT;
+	rq->retries = SD_MAX_RETRIES;
+	rq->cmd[0] = SYNCHRONIZE_CACHE;
+	rq->cmd_len = 10;
+
+	return scsi_setup_blk_pc_cmnd(sdp, rq);
+}
+
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
 	if (rq->cmd_flags & REQ_DISCARD)
@@ -504,6 +516,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	if (rq->cmd_flags & REQ_DISCARD) {
 		ret = scsi_setup_discard_cmnd(sdp, rq);
 		goto out;
+	} else if (rq->cmd_flags & REQ_FLUSH) {
+		ret = scsi_setup_flush_cmnd(sdp, rq);
+		goto out;
 	} else if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 		goto out;
@@ -1053,15 +1068,6 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 	return 0;
 }
 
-static void sd_prepare_flush(struct request_queue *q, struct request *rq)
-{
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->timeout = SD_TIMEOUT;
-	rq->retries = SD_MAX_RETRIES;
-	rq->cmd[0] = SYNCHRONIZE_CACHE;
-	rq->cmd_len = 10;
-}
-
 static void sd_rescan(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
@@ -2129,7 +2135,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	else
 		ordered = QUEUE_ORDERED_DRAIN;
 
-	blk_queue_ordered(sdkp->disk->queue, ordered, sd_prepare_flush);
+	blk_queue_ordered(sdkp->disk->queue, ordered, NULL);
 
 	set_capacity(disk, sdkp->capacity);
 	kfree(buffer);
-- 
1.6.5

