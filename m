Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3ACNXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:23:04 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35909 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab3ACNXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:23:01 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] adv7343: use devm_kzalloc() instead of kzalloc()
Date: Thu,  3 Jan 2013 18:52:39 +0530
Message-Id: <1357219362-9080-1-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
simplifies their clean up paths.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/i2c/adv7343.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 2b5aa67..ceaf548 100644
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
 
@@ -428,19 +429,14 @@ static int adv7343_probe(struct i2c_client *client,
 				       ADV7343_GAIN_DEF);
 	state->sd.ctrl_handler = &state->hdl;
 	if (state->hdl.error) {
-		int err = state->hdl.error;
-
 		v4l2_ctrl_handler_free(&state->hdl);
-		kfree(state);
-		return err;
+		return state->hdl.error;
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
 
@@ -451,7 +447,6 @@ static int adv7343_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&state->hdl);
-	kfree(state);
 
 	return 0;
 }
-- 
1.7.4.1

