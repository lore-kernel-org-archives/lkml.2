Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3ADFL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 00:11:59 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52103 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3ADFLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 00:11:54 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2] tvp7002: use devm_kzalloc() instead of kzalloc()
Date: Fri,  4 Jan 2013 10:41:17 +0530
Message-Id: <1357276277-21812-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357276277-21812-1-git-send-email-prabhakar.lad@ti.com>
References: <1357276277-21812-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
simplifies their clean up paths.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 Changes for v2:
 1: Fixed comments pointed out by Laurent.

 drivers/media/i2c/tvp7002.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index fb6a5b5..537f6b4 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -1036,7 +1036,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 		return -ENODEV;
 	}
 
-	device = kzalloc(sizeof(struct tvp7002), GFP_KERNEL);
+	device = devm_kzalloc(&c->dev, sizeof(struct tvp7002), GFP_KERNEL);
 
 	if (!device)
 		return -ENOMEM;
@@ -1052,7 +1052,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 
 	error = tvp7002_read(sd, TVP7002_CHIP_REV, &revision);
 	if (error < 0)
-		goto found_error;
+		return error;
 
 	/* Get revision number */
 	v4l2_info(sd, "Rev. %02x detected.\n", revision);
@@ -1063,21 +1063,21 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 	error = tvp7002_write_inittab(sd, tvp7002_init_default);
 
 	if (error < 0)
-		goto found_error;
+		return error;
 
 	/* Set polarity information after registers have been set */
 	polarity_a = 0x20 | device->pdata->hs_polarity << 5
 			| device->pdata->vs_polarity << 2;
 	error = tvp7002_write(sd, TVP7002_SYNC_CTL_1, polarity_a);
 	if (error < 0)
-		goto found_error;
+		return error;
 
 	polarity_b = 0x01  | device->pdata->fid_polarity << 2
 			| device->pdata->sog_polarity << 1
 			| device->pdata->clk_polarity;
 	error = tvp7002_write(sd, TVP7002_MISC_CTL_3, polarity_b);
 	if (error < 0)
-		goto found_error;
+		return error;
 
 	/* Set registers according to default video mode */
 	preset.preset = device->current_preset->preset;
@@ -1091,16 +1091,11 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 		int err = device->hdl.error;
 
 		v4l2_ctrl_handler_free(&device->hdl);
-		kfree(device);
 		return err;
 	}
 	v4l2_ctrl_handler_setup(&device->hdl);
 
-found_error:
-	if (error < 0)
-		kfree(device);
-
-	return error;
+	return 0;
 }
 
 /*
@@ -1120,7 +1115,6 @@ static int tvp7002_remove(struct i2c_client *c)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&device->hdl);
-	kfree(device);
 	return 0;
 }
 
-- 
1.7.4.1

