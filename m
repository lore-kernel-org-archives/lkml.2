Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2E1OiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:38:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58644 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754656Ab2E1OiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:38:17 -0400
From: Emil Goode <emilgoode@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] video: bfin_adv7393fb: Fix cleanup code
Date: Mon, 28 May 2012 16:40:19 +0200
Message-Id: <1338216019-1288-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the cleanup code of the bfin_adv7393_fb_probe
function by changing the order in which cleanup is performed
and by adding one label.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/video/bfin_adv7393fb.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/video/bfin_adv7393fb.c b/drivers/video/bfin_adv7393fb.c
index 1a268a2..ddbd031 100644
--- a/drivers/video/bfin_adv7393fb.c
+++ b/drivers/video/bfin_adv7393fb.c
@@ -414,7 +414,7 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
 		if (ret) {
 			dev_err(&client->dev, "PPI0_FS3 GPIO request failed\n");
 			ret = -EBUSY;
-			goto out_8;
+			goto out_9;
 		}
 	}
 
@@ -528,15 +528,18 @@ static int __devinit bfin_adv7393_fb_probe(struct i2c_client *client,
  out_3:
 	free_dma(CH_PPI);
  out_4:
-	dma_free_coherent(NULL, fbdev->fb_len, fbdev->fb_mem,
-			  fbdev->dma_handle);
- out_5:
 	fb_dealloc_cmap(&fbdev->info.cmap);
- out_6:
+ out_5:
 	kfree(fbdev->info.pseudo_palette);
+ out_6:
+	dma_free_coherent(NULL, fbdev->fb_len, fbdev->fb_mem,
+			  fbdev->dma_handle);
  out_7:
 	peripheral_free_list(ppi_pins);
  out_8:
+	if (ANOMALY_05000400)
+		gpio_free(P_IDENT(P_PPI0_FS3));
+ out_9:
 	kfree(fbdev);
 
 	return ret;
-- 
1.7.10

