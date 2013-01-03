Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3ACN3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:29:16 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52009 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3ACN3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:29:14 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] tvp7002: use devm_kzalloc() instead of kzalloc()
Date: Thu,  3 Jan 2013 18:52:42 +0530
Message-Id: <1357219362-9080-4-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357219362-9080-1-git-send-email-prabhakar.lad@ti.com>
References: <1357219362-9080-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
simplifies their clean up paths.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/i2c/tvp7002.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index fb6a5b5..2d4c86e 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -1036,7 +1036,7 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 		return -ENODEV;
 	}
 
-	device = kzalloc(sizeof(struct tvp7002), GFP_KERNEL);
+	device = devm_kzalloc(&c->dev, sizeof(struct tvp7002), GFP_KERNEL);
 
 	if (!device)
 		return -ENOMEM;
@@ -1088,17 +1088,12 @@ static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
 			V4L2_CID_GAIN, 0, 255, 1, 0);
 	sd->ctrl_handler = &device->hdl;
 	if (device->hdl.error) {
-		int err = device->hdl.error;
-
 		v4l2_ctrl_handler_free(&device->hdl);
-		kfree(device);
-		return err;
+		return device->hdl.error;
 	}
 	v4l2_ctrl_handler_setup(&device->hdl);
 
 found_error:
-	if (error < 0)
-		kfree(device);
 
 	return error;
 }
@@ -1120,7 +1115,6 @@ static int tvp7002_remove(struct i2c_client *c)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&device->hdl);
-	kfree(device);
 	return 0;
 }
 
-- 
1.7.4.1

