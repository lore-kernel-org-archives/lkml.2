Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2GXNKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:10:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37290 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2GXNKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:10:05 -0400
MIME-Version: 1.0
Date: Tue, 24 Jul 2012 22:10:04 +0900
Message-ID: <CAPOY1bUqm1Lb4ppf5UYqUA+cbK3_sHE=zJu3x6-UNb+uKiYiWg@mail.gmail.com>
Subject: [PATCH] mmc: core: Remove bounce buffer in mmc_send_cxd_data()
From: Andy Lee <raphael.andy.lee@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is expected that Extended CSD register(the size of this register
is larger than CID/CSD) will be referenced more frequently as more
fields have been added to Extended CSD.
This patch is intended to avoid the use of bounce buffer for reading
Extended CSD register in mmc_send_cxd_data(). It seems that it is
not a good option to double the memory used.

Signed-off-by: kyungsik.lee <kyungsik.lee@lge.com>
---
 drivers/mmc/core/mmc_ops.c |   45 ++++++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 0ed2cc5..b1a7df3 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -238,14 +238,6 @@ mmc_send_cxd_data(struct mmc_card *card, struct
mmc_host *host,
 	struct mmc_command cmd = {0};
 	struct mmc_data data = {0};
 	struct scatterlist sg;
-	void *data_buf;
-
-	/* dma onto stack is unsafe/nonportable, but callers to this
-	 * routine normally provide temporary on-stack buffers ...
-	 */
-	data_buf = kmalloc(len, GFP_KERNEL);
-	if (data_buf == NULL)
-		return -ENOMEM;

 	mrq.cmd = &cmd;
 	mrq.data = &data;
@@ -266,7 +258,7 @@ mmc_send_cxd_data(struct mmc_card *card, struct
mmc_host *host,
 	data.sg = &sg;
 	data.sg_len = 1;

-	sg_init_one(&sg, data_buf, len);
+	sg_init_one(&sg, buf, len);

 	if (opcode == MMC_SEND_CSD || opcode == MMC_SEND_CID) {
 		/*
@@ -280,9 +272,6 @@ mmc_send_cxd_data(struct mmc_card *card, struct
mmc_host *host,

 	mmc_wait_for_req(host, &mrq);

-	memcpy(buf, data_buf, len);
-	kfree(data_buf);
-
 	if (cmd.error)
 		return cmd.error;
 	if (data.error)
@@ -294,24 +283,37 @@ mmc_send_cxd_data(struct mmc_card *card, struct
mmc_host *host,
 int mmc_send_csd(struct mmc_card *card, u32 *csd)
 {
 	int ret, i;
+	u32 *csd_t;

 	if (!mmc_host_is_spi(card->host))
 		return mmc_send_cxd_native(card->host, card->rca << 16,
 				csd, MMC_SEND_CSD);

-	ret = mmc_send_cxd_data(card, card->host, MMC_SEND_CSD, csd, 16);
+	csd_t = kmalloc(16, GFP_KERNEL);
+	if (!csd_t)
+		return -ENOMEM;
+
+	ret = mmc_send_cxd_data(card, card->host, MMC_SEND_CSD, csd_t, 16);
 	if (ret)
-		return ret;
+		goto err;
+
+	memcpy(csd, csd_t, 16);

 	for (i = 0;i < 4;i++)
 		csd[i] = be32_to_cpu(csd[i]);

+	kfree(csd_t);
 	return 0;
+
+err:
+	kfree(csd_t);
+	return ret;
 }

 int mmc_send_cid(struct mmc_host *host, u32 *cid)
 {
 	int ret, i;
+	u32 *cid_t;

 	if (!mmc_host_is_spi(host)) {
 		if (!host->card)
@@ -320,14 +322,25 @@ int mmc_send_cid(struct mmc_host *host, u32 *cid)
 				cid, MMC_SEND_CID);
 	}

-	ret = mmc_send_cxd_data(NULL, host, MMC_SEND_CID, cid, 16);
+	cid_t = kmalloc(16, GFP_KERNEL);
+	if (!cid_t)
+		return -ENOMEM;
+
+	ret = mmc_send_cxd_data(NULL, host, MMC_SEND_CID, cid_t, 16);
 	if (ret)
-		return ret;
+		goto err;
+
+	memcpy(cid, cid_t, 16);

 	for (i = 0;i < 4;i++)
 		cid[i] = be32_to_cpu(cid[i]);

+	kfree(cid_t);
 	return 0;
+
+err:
+	kfree(cid_t);
+	return ret;
 }

 int mmc_send_ext_csd(struct mmc_card *card, u8 *ext_csd)
-- 
1.7.0.4
