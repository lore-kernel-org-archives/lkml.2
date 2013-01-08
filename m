Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3AHX4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:56:25 -0500
Received: from norkia.v3.sk ([91.210.183.14]:53038 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab3AHX4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:56:19 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: David Woodhouse <dwmw2@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        libertas-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, linux-kernel@vger.kernel.org,
        lkundrak@v3.sk
Subject: [PATCH] Bluetooth: btmrvl_sdio: look for sd8688 firmware in alternate place
Date: Wed,  9 Jan 2013 00:56:01 +0100
Message-Id: <1357689361-7969-2-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
References: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-firmware ships the sd8688* firmware images that are shared with
libertas_sdio WiFi driver under libertas/. libertas_sdio looks in both places
and so should we.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/bluetooth/btmrvl_sdio.c |   24 ++++++++++++++++++++++--
 drivers/bluetooth/btmrvl_sdio.h |    6 ++++--
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 9959d4c..494f921 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -83,22 +83,28 @@ static const struct btmrvl_sdio_card_reg btmrvl_reg_87xx = {
 };
 
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8688 = {
-	.helper		= "sd8688_helper.bin",
-	.firmware	= "sd8688.bin",
+	.helper		= "libertas/sd8688_helper.bin",
+	.helper2	= "sd8688_helper.bin",
+	.firmware	= "libertas/sd8688.bin",
+	.firmware2	= "sd8688.bin",
 	.reg		= &btmrvl_reg_8688,
 	.sd_blksz_fw_dl	= 64,
 };
 
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8787 = {
 	.helper		= NULL,
+	.helper2	= NULL,
 	.firmware	= "mrvl/sd8787_uapsta.bin",
+	.firmware2	= NULL,
 	.reg		= &btmrvl_reg_87xx,
 	.sd_blksz_fw_dl	= 256,
 };
 
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8797 = {
 	.helper		= NULL,
+	.helper2	= NULL,
 	.firmware	= "mrvl/sd8797_uapsta.bin",
+	.firmware2	= NULL,
 	.reg		= &btmrvl_reg_87xx,
 	.sd_blksz_fw_dl	= 256,
 };
@@ -260,6 +266,11 @@ static int btmrvl_sdio_download_helper(struct btmrvl_sdio_card *card)
 
 	ret = request_firmware(&fw_helper, card->helper,
 						&card->func->dev);
+	if (ret < 0 && card->helper2) {
+		release_firmware(fw_helper);
+		ret = request_firmware(&fw_helper, card->helper2,
+							&card->func->dev);
+	}
 	if ((ret < 0) || !fw_helper) {
 		BT_ERR("request_firmware(helper) failed, error code = %d",
 									ret);
@@ -360,6 +371,11 @@ static int btmrvl_sdio_download_fw_w_helper(struct btmrvl_sdio_card *card)
 
 	ret = request_firmware(&fw_firmware, card->firmware,
 							&card->func->dev);
+	if (ret < 0 && card->firmware2) {
+		release_firmware(fw_firmware);
+		ret = request_firmware(&fw_firmware, card->firmware2,
+							&card->func->dev);
+	}
 	if ((ret < 0) || !fw_firmware) {
 		BT_ERR("request_firmware(firmware) failed, error code = %d",
 									ret);
@@ -970,7 +986,9 @@ static int btmrvl_sdio_probe(struct sdio_func *func,
 	if (id->driver_data) {
 		struct btmrvl_sdio_device *data = (void *) id->driver_data;
 		card->helper = data->helper;
+		card->helper2 = data->helper2;
 		card->firmware = data->firmware;
+		card->firmware2 = data->firmware2;
 		card->reg = data->reg;
 		card->sd_blksz_fw_dl = data->sd_blksz_fw_dl;
 	}
@@ -1186,6 +1204,8 @@ MODULE_DESCRIPTION("Marvell BT-over-SDIO driver ver " VERSION);
 MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE("sd8688_helper.bin");
+MODULE_FIRMWARE("libertas/sd8688_helper.bin");
 MODULE_FIRMWARE("sd8688.bin");
+MODULE_FIRMWARE("libertas/sd8688.bin");
 MODULE_FIRMWARE("mrvl/sd8787_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8797_uapsta.bin");
diff --git a/drivers/bluetooth/btmrvl_sdio.h b/drivers/bluetooth/btmrvl_sdio.h
index 43d35a6..4a5a019 100644
--- a/drivers/bluetooth/btmrvl_sdio.h
+++ b/drivers/bluetooth/btmrvl_sdio.h
@@ -84,7 +84,9 @@ struct btmrvl_sdio_card {
 	struct sdio_func *func;
 	u32 ioport;
 	const char *helper;
+	const char *helper2;
 	const char *firmware;
+	const char *firmware2;
 	const struct btmrvl_sdio_card_reg *reg;
 	u16 sd_blksz_fw_dl;
 	u8 rx_unit;
@@ -92,8 +94,8 @@ struct btmrvl_sdio_card {
 };
 
 struct btmrvl_sdio_device {
-	const char *helper;
-	const char *firmware;
+	const char *helper, *helper2;
+	const char *firmware, *firmware2;
 	const struct btmrvl_sdio_card_reg *reg;
 	u16 sd_blksz_fw_dl;
 };
-- 
1.7.1

