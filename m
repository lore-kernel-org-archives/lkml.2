Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab3ADFLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 00:11:37 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44684 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3ADFLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 00:11:35 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2] adv7343: use devm_kzalloc() instead of kzalloc()
Date: Fri,  4 Jan 2013 10:41:15 +0530
Message-Id: <1357276277-21812-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
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

 drivers/media/i2c/adv7343.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 2b5aa67..432eb5f 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -397,7 +397,8 @@ static int adv7343_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kzalloc(sizeof(struct adv7343_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(struct adv7343_state),
+			     GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 
@@ -431,16 +432,13 @@ static int adv7343_probe(struct i2c_client *client,
 		int err = state->hdl.error;
 
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
 		return err;
 	}
 	v4l2_ctrl_handler_setup(&state->hdl);
 
 	err = adv7343_initialize(&state->sd);
-	if (err) {
+	if (err)
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
-	}
 	return err;
 }
 
@@ -451,7 +449,6 @@ static int adv7343_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 
 	return 0;
 }
-- 
1.7.4.1

