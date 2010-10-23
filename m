Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab0JWU7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 16:59:25 -0400
Received: from nm13.bullet.mail.ne1.yahoo.com ([98.138.90.76]:25033 "HELO
	nm13.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751518Ab0JWU7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 16:59:22 -0400
X-Yahoo-Newman-Id: 286328.98740.bm@omp1021.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: WPLU6YUVM1k7cd3HanKbgVkzJbZEE3ShvFCRLlZWoLECaQa
 44gMvvbr2iGa9dvKMrZ0be0X07b6Czgk5jtSfhn6okk9y2Ma1XQZh6fhiiqP
 zHKfX0pxcQXknoQLx5VOCuSlO.xCi1B3Kna7sX9FbY990peanuq0q0aWOkVG
 pIEUcIqjRu7T.STFBkFYeiiIL8kJyIGQmP2heiKYacUzYwmI5Qrj.LYM2.7i
 S3mhwyhH5QN97SaG96GdAn8lxrfp8iMfRc4UdVOjVRrj97WWXhSViX19lSxk
 cFj87BHNLUAZHyKwIuGR9LV86dr903LGex42rQ.CYFUCIL3FUGutN31wxQHw
 -
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] tcm/iblock: Update blkdev_issue_flush() parameter usage
Date: Sat, 23 Oct 2010 13:59:15 -0700
Message-Id: <1287867555-5796-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This patch follows Jen's for-2.6.37/core branch merged as commit 35da7a307c535
to convert blkdev_issue_flush() to use the new 'sector_t error_sector' and
drop legacy BLKDEV_IFL_WAIT usage.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index e7840da..a8267a8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -410,12 +410,14 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 static int __iblock_do_sync_cache(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
+	sector_t error_sector;
 	int ret;
 
-	ret = blkdev_issue_flush(ib_dev->ibd_bd, GFP_KERNEL, NULL,
-				BLKDEV_IFL_WAIT);
+	ret = blkdev_issue_flush(ib_dev->ibd_bd, GFP_KERNEL, &error_sector);
 	if (ret != 0) {
-		printk(KERN_ERR "IBLOCK: block_issue_flush() failed: %d\n", ret);
+		printk(KERN_ERR "IBLOCK: block_issue_flush() failed: %d "
+			" error_sector: %llu\n", ret,
+			(unsigned long long)error_sector);
 		return -1;
 	}
 	DEBUG_IBLOCK("IBLOCK: Called block_issue_flush()\n");
-- 
1.7.3.2

