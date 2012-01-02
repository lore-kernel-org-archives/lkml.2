Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2ABHtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 02:49:45 -0500
Received: from mail.discretix.com ([192.116.217.178]:39111 "EHLO discretix.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751700Ab2ABHtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 02:49:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Properly support MMC_IOC_CMD operations without a data payload
Date: Mon, 2 Jan 2012 09:42:59 +0200
Message-ID: <1CE895C75013AF4F8284BE71FD114B5D01836C5E@exchange1.discretix.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Properly support MMC_IOC_CMD operations without a data payload
Thread-Index: AczGzAR0OzU5+T9hT1Gm4xdT5+UOkQ==
From: "Alon Ziv" <alonz@discretix.com>
To: "Chris Ball" <cjb@laptop.org>
Cc: "Alon Ziv" <alonz@discretix.com>, "Chris Ball" <cjb@laptop.org>,
        "Andrei Warkentin" <awarkentin@vmware.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Arnd Bergmann" <arnd@arndb.de>, "Venkatraman S" <svenkatr@ti.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some MMC/SD host controllers require the "data" member of
"struct mmc_request" to be NULL when the command has no data attached.
Change the MMC ioctl method to not initialize the "data" member when
the supplied data size (blksz * blocks) is zero.

Signed-off-by: Alon Ziv <alonz@discretix.com>
---
 drivers/mmc/card/block.c |   45
+++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1e0e27c..a0ab6c1 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -266,16 +266,18 @@ static struct mmc_blk_ioc_data
*mmc_blk_ioctl_copy_from_user(
 		goto idata_err;
 	}
 
-	idata->buf = kzalloc(idata->buf_bytes, GFP_KERNEL);
-	if (!idata->buf) {
-		err = -ENOMEM;
-		goto idata_err;
-	}
+	if (idata->buf_bytes != 0) {
+		idata->buf = kzalloc(idata->buf_bytes, GFP_KERNEL);
+		if (!idata->buf) {
+			err = -ENOMEM;
+			goto idata_err;
+		}
 
-	if (copy_from_user(idata->buf, (void __user *)(unsigned long)
-					idata->ic.data_ptr,
idata->buf_bytes)) {
-		err = -EFAULT;
-		goto copy_err;
+		if (copy_from_user(idata->buf, (void __user *)(unsigned
long)
+						idata->ic.data_ptr,
idata->buf_bytes)) {
+			err = -EFAULT;
+			goto copy_err;
+		}
 	}
 
 	return idata;
@@ -315,21 +317,23 @@ static int mmc_blk_ioctl_cmd(struct block_device
*bdev,
 	cmd.opcode = idata->ic.opcode;
 	cmd.arg = idata->ic.arg;
 	cmd.flags = idata->ic.flags;
+	mrq.cmd = &cmd;
 
-	data.sg = &sg;
-	data.sg_len = 1;
-	data.blksz = idata->ic.blksz;
-	data.blocks = idata->ic.blocks;
+	if (idata->buf_bytes != 0) {
+		data.sg = &sg;
+		data.sg_len = 1;
+		data.blksz = idata->ic.blksz;
+		data.blocks = idata->ic.blocks;
 
-	sg_init_one(data.sg, idata->buf, idata->buf_bytes);
+		sg_init_one(data.sg, idata->buf, idata->buf_bytes);
 
-	if (idata->ic.write_flag)
-		data.flags = MMC_DATA_WRITE;
-	else
-		data.flags = MMC_DATA_READ;
+		if (idata->ic.write_flag)
+			data.flags = MMC_DATA_WRITE;
+		else
+			data.flags = MMC_DATA_READ;
 
-	mrq.cmd = &cmd;
-	mrq.data = &data;
+		mrq.data = &data;
+	}
 
 	md = mmc_blk_get(bdev->bd_disk);
 	if (!md) {
@@ -353,6 +357,7 @@ static int mmc_blk_ioctl_cmd(struct block_device
*bdev,
 
 	/* data.flags must already be set before doing this. */
 	mmc_set_data_timeout(&data, card);
+
 	/* Allow overriding the timeout_ns for empirical tuning. */
 	if (idata->ic.data_timeout_ns)
 		data.timeout_ns = idata->ic.data_timeout_ns;
-- 
1.7.0.4

