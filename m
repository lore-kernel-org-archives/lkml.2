Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687Ab2J2LFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:05:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53624 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663Ab2J2LFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:05:36 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 5/7] staging/gdm72xx: Use dev_ printks in sdio_boot.c
Date: Mon, 29 Oct 2012 20:05:30 +0900
Message-Id: <1351508730-1857-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
References: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/gdm72xx/sdio_boot.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/gdm72xx/sdio_boot.c b/drivers/staging/gdm72xx/sdio_boot.c
index 38feb1a..6291829 100644
--- a/drivers/staging/gdm72xx/sdio_boot.c
+++ b/drivers/staging/gdm72xx/sdio_boot.c
@@ -65,15 +65,15 @@ static int download_image(struct sdio_func *func, const char *img_name)
 
 	ret = request_firmware(&firm, img_name, &func->dev);
 	if (ret < 0) {
-		printk(KERN_ERR
-		       "requesting firmware %s failed with error %d\n",
+		dev_err(&func->dev,
+			"requesting firmware %s failed with error %d\n",
 			img_name, ret);
 		return ret;
 	}
 
 	buf = kmalloc(DOWNLOAD_SIZE + TYPE_A_HEADER_SIZE, GFP_KERNEL);
 	if (buf == NULL) {
-		printk(KERN_ERR "Error: kmalloc\n");
+		dev_err(&func->dev, "Error: kmalloc\n");
 		return -ENOMEM;
 	}
 
@@ -101,8 +101,9 @@ static int download_image(struct sdio_func *func, const char *img_name)
 		memcpy(buf+TYPE_A_HEADER_SIZE, firm->data + pos, len);
 		ret = sdio_memcpy_toio(func, 0, buf, len + TYPE_A_HEADER_SIZE);
 		if (ret < 0) {
-			printk(KERN_ERR "gdmwm: send image error: "
-				"packet number = %d ret = %d\n", pno, ret);
+			dev_err(&func->dev,
+				"send image error: packet number = %d ret = %d\n",
+				pno, ret);
 			goto out;
 		}
 
@@ -110,13 +111,14 @@ static int download_image(struct sdio_func *func, const char *img_name)
 			break;
 		if (!ack_ready(func)) {
 			ret = -EIO;
-			printk(KERN_ERR "gdmwm: Ack is not ready.\n");
+			dev_err(&func->dev, "Ack is not ready.\n");
 			goto out;
 		}
 		ret = sdio_memcpy_fromio(func, buf, 0, TYPE_A_LOOKAHEAD_SIZE);
 		if (ret < 0) {
-			printk(KERN_ERR "gdmwm: receive ack error: "
-				"packet number = %d ret = %d\n", pno, ret);
+			dev_err(&func->dev,
+				"receive ack error: packet number = %d ret = %d\n",
+				pno, ret);
 			goto out;
 		}
 		sdio_writeb(func, 0x01, 0x13, &ret);
@@ -140,19 +142,20 @@ int sdio_boot(struct sdio_func *func)
 
 	tx_buf = kmalloc(YMEM0_SIZE, GFP_KERNEL);
 	if (tx_buf == NULL) {
-		printk(KERN_ERR "Error: kmalloc: %s %d\n", __func__, __LINE__);
+		dev_err(&func->dev, "Error: kmalloc: %s %d\n",
+			__func__, __LINE__);
 		return -ENOMEM;
 	}
 
 	ret = download_image(func, krn_name);
 	if (ret)
 		goto restore_fs;
-	printk(KERN_INFO "GCT: Kernel download success.\n");
+	dev_info(&func->dev, "GCT: Kernel download success.\n");
 
 	ret = download_image(func, rfs_name);
 	if (ret)
 		goto restore_fs;
-	printk(KERN_INFO "GCT: Filesystem download success.\n");
+	dev_info(&func->dev, "GCT: Filesystem download success.\n");
 
 restore_fs:
 	kfree(tx_buf);
-- 
1.7.9.5

