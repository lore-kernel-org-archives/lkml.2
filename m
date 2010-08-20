Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0HTJHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:07:04 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:42781 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751897Ab0HTJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:07:00 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Wv.kD3wVM1ldy_wtOE_heblJ2..npSQqIKd8JsRjVyPazzV
 ZuGNUDv80AXB4IjwrIKHKWgT8jyJLjyVRLWYlB843sJTRWIelbYpMyLg8Ee1
 1u2zORNlsnzG0yKfD8XLO8R_0I8D2jMRwKyytOPPZ22fyg49yXU7cqRfVPce
 2wDfPh.i4l5u8p7.EcztN5wRwb5KckkIo37q1qFgsqsrwrzSBcFbPRfqETri
 dWuutqWyELNd7kk49uiKVgckw7GBECBw7.q6CEfbFeDTEdwLAS3_Z97_mkXY
 E3s4PNGGQ_7II4tKTZvAl4iYwvPx4qB3n1xLnzV4ajWM7KMDEUS.dT24ZwKh
 x8puoWKopZL993HoOEA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@suse.de>,
        Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/2] tcm/iblock: Convert iblock_map_task_SG() to use for_each_sg()
Date: Fri, 20 Aug 2010 02:06:57 -0700
Message-Id: <1282295217-8880-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts iblock_map_task_SG() to use the include/linux/scatterlist.h
SGL walking macro for_each_sg() when accessing the contigious array of
struct scatterlist in struct se_task->task_sg[].   As we are currently
assured that TCM will always be using a contigious array allocated by
transport_calc_sg_num(), so it is still safe to walk struct se_task->task_sg[]
directly up to task->task_sg_num.

This patch does the minor cleanups to use for_each_sg() to follow mainline
convention for SGL walking (potentially) linked contigious scatterlist array
allocations coming from TCM into IBLOCK in the future..

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d10930e..7945ca8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -798,7 +798,7 @@ static int iblock_map_task_SG(struct se_task *task)
 	struct iblock_dev *ib_dev = (struct iblock_dev *) task->se_dev->dev_ptr;
 	struct iblock_req *ib_req = (struct iblock_req *) task->transport_req;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
-	struct scatterlist *sg = task->task_sg;
+	struct scatterlist *sg;
 	int ret = 0;
 	u32 i, sg_num = task->task_sg_num;
 	sector_t block_lba;
@@ -832,14 +832,13 @@ static int iblock_map_task_SG(struct se_task *task)
 	 * Use fs/bio.c:bio_add_pages() to setup the bio_vec maplist
 	 * from TCM struct se_mem -> task->task_sg -> struct scatterlist memory.
 	 */
-	for (i = 0; i < task->task_sg_num; i++) {
+	for_each_sg(task->task_sg, sg, task->task_sg_num, i) {
 		DEBUG_IBLOCK("task: %p bio: %p Calling bio_add_page(): page:"
-			" %p len: %u offset: %u\n", task, bio, sg_page(&sg[i]),
-				sg[i].length, sg[i].offset);
+			" %p len: %u offset: %u\n", task, bio, sg_page(sg),
+				sg->length, sg->offset);
 again:
-		ret = bio_add_page(bio, sg_page(&sg[i]), sg[i].length,
-				sg[i].offset);
-		if (ret != sg[i].length) {
+		ret = bio_add_page(bio, sg_page(sg), sg->length, sg->offset);
+		if (ret != sg->length) {
 
 			DEBUG_IBLOCK("*** Set bio->bi_sector: %llu\n",
 					bio->bi_sector);
@@ -861,7 +860,7 @@ again:
 			goto again;
 		}
 		/* Always in 512 byte units for Linux/Block */
-		block_lba += sg[i].length >> IBLOCK_LBA_SHIFT;
+		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
 		sg_num--;
 		DEBUG_IBLOCK("task: %p bio-add_page() passed!, decremented"
 			" sg_num to %u\n", task, sg_num);
-- 
1.5.6.5

