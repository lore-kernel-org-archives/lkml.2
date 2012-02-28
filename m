Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082Ab2B1BJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:09:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46792 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965036Ab2B1BI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:08:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.211.167 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.661369143@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Rudholm <johan.rudholm@stericsson.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 14/72] mmc: core: check for zero length ioctl data
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Rudholm <johan.rudholm@stericsson.com>

commit 4d6144de8ba263eb3691a737c547e5b2fdc45287 upstream.

If the read or write buffer size associated with the command sent
through the mmc_blk_ioctl is zero, do not prepare data buffer.

This enables a ioctl(2) call to for instance send a MMC_SWITCH to set
a byte in the ext_csd.

Signed-off-by: Johan Rudholm <johan.rudholm@stericsson.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/block.c |   82 +++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 37 deletions(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -266,6 +266,9 @@ static struct mmc_blk_ioc_data *mmc_blk_
 		goto idata_err;
 	}
 
+	if (!idata->buf_bytes)
+		return idata;
+
 	idata->buf = kzalloc(idata->buf_bytes, GFP_KERNEL);
 	if (!idata->buf) {
 		err = -ENOMEM;
@@ -312,25 +315,6 @@ static int mmc_blk_ioctl_cmd(struct bloc
 	if (IS_ERR(idata))
 		return PTR_ERR(idata);
 
-	cmd.opcode = idata->ic.opcode;
-	cmd.arg = idata->ic.arg;
-	cmd.flags = idata->ic.flags;
-
-	data.sg = &sg;
-	data.sg_len = 1;
-	data.blksz = idata->ic.blksz;
-	data.blocks = idata->ic.blocks;
-
-	sg_init_one(data.sg, idata->buf, idata->buf_bytes);
-
-	if (idata->ic.write_flag)
-		data.flags = MMC_DATA_WRITE;
-	else
-		data.flags = MMC_DATA_READ;
-
-	mrq.cmd = &cmd;
-	mrq.data = &data;
-
 	md = mmc_blk_get(bdev->bd_disk);
 	if (!md) {
 		err = -EINVAL;
@@ -343,6 +327,48 @@ static int mmc_blk_ioctl_cmd(struct bloc
 		goto cmd_done;
 	}
 
+	cmd.opcode = idata->ic.opcode;
+	cmd.arg = idata->ic.arg;
+	cmd.flags = idata->ic.flags;
+
+	if (idata->buf_bytes) {
+		data.sg = &sg;
+		data.sg_len = 1;
+		data.blksz = idata->ic.blksz;
+		data.blocks = idata->ic.blocks;
+
+		sg_init_one(data.sg, idata->buf, idata->buf_bytes);
+
+		if (idata->ic.write_flag)
+			data.flags = MMC_DATA_WRITE;
+		else
+			data.flags = MMC_DATA_READ;
+
+		/* data.flags must already be set before doing this. */
+		mmc_set_data_timeout(&data, card);
+
+		/* Allow overriding the timeout_ns for empirical tuning. */
+		if (idata->ic.data_timeout_ns)
+			data.timeout_ns = idata->ic.data_timeout_ns;
+
+		if ((cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
+			/*
+			 * Pretend this is a data transfer and rely on the
+			 * host driver to compute timeout.  When all host
+			 * drivers support cmd.cmd_timeout for R1B, this
+			 * can be changed to:
+			 *
+			 *     mrq.data = NULL;
+			 *     cmd.cmd_timeout = idata->ic.cmd_timeout_ms;
+			 */
+			data.timeout_ns = idata->ic.cmd_timeout_ms * 1000000;
+		}
+
+		mrq.data = &data;
+	}
+
+	mrq.cmd = &cmd;
+
 	mmc_claim_host(card->host);
 
 	if (idata->ic.is_acmd) {
@@ -351,24 +377,6 @@ static int mmc_blk_ioctl_cmd(struct bloc
 			goto cmd_rel_host;
 	}
 
-	/* data.flags must already be set before doing this. */
-	mmc_set_data_timeout(&data, card);
-	/* Allow overriding the timeout_ns for empirical tuning. */
-	if (idata->ic.data_timeout_ns)
-		data.timeout_ns = idata->ic.data_timeout_ns;
-
-	if ((cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
-		/*
-		 * Pretend this is a data transfer and rely on the host driver
-		 * to compute timeout.  When all host drivers support
-		 * cmd.cmd_timeout for R1B, this can be changed to:
-		 *
-		 *     mrq.data = NULL;
-		 *     cmd.cmd_timeout = idata->ic.cmd_timeout_ms;
-		 */
-		data.timeout_ns = idata->ic.cmd_timeout_ms * 1000000;
-	}
-
 	mmc_wait_for_req(card->host, &mrq);
 
 	if (cmd.error) {


