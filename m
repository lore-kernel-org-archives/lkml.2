Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0CTOO4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:14:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59108 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0CTOOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:14:53 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: kernel-janitors@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
Date: Sat, 20 Mar 2010 15:12:53 +0100
Message-Id: <1269094385-16114-13-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: w.sang@pengutronix.de
Subject: [PATCH 12/24] media/video: fix dangling pointers
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix I2C-drivers which missed setting clientdata to NULL before freeing the
structure it points to. Also fix drivers which do this _after_ the structure
was freed already.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---

Found using coccinelle, then reviewed. Full patchset is available via
kernel-janitors, linux-i2c, and LKML.
---
 drivers/media/video/cs5345.c     |    1 +
 drivers/media/video/cs53l32a.c   |    1 +
 drivers/media/video/ir-kbd-i2c.c |    2 ++
 drivers/media/video/tda9840.c    |    1 +
 drivers/media/video/tea6415c.c   |    1 +
 drivers/media/video/tea6420.c    |    1 +
 drivers/media/video/ths7303.c    |    1 +
 7 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
index 57dc170..cd21aa8 100644
--- a/drivers/media/video/cs5345.c
+++ b/drivers/media/video/cs5345.c
@@ -196,6 +196,7 @@ static int cs5345_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
+	i2c_set_clientdata(client, NULL);
 	kfree(sd);
 	return 0;
 }
diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
index 80bca8d..527f731 100644
--- a/drivers/media/video/cs53l32a.c
+++ b/drivers/media/video/cs53l32a.c
@@ -199,6 +199,7 @@ static int cs53l32a_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
+	i2c_set_clientdata(client, NULL);
 	kfree(sd);
 	return 0;
 }
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index da18d69..f29c5cd 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -461,6 +461,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	return 0;
 
  err_out_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(ir);
 	return err;
 }
@@ -476,6 +477,7 @@ static int ir_remove(struct i2c_client *client)
 	ir_input_unregister(ir->input);
 
 	/* free memory */
+	i2c_set_clientdata(client, NULL);
 	kfree(ir);
 	return 0;
 }
diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
index d381fce..b608aaf 100644
--- a/drivers/media/video/tda9840.c
+++ b/drivers/media/video/tda9840.c
@@ -188,6 +188,7 @@ static int tda9840_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
+	i2c_set_clientdata(client, NULL);
 	kfree(sd);
 	return 0;
 }
diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
index 1585839..49a6606 100644
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -164,6 +164,7 @@ static int tea6415c_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
+	i2c_set_clientdata(client, NULL);
 	kfree(sd);
 	return 0;
 }
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index 6bf6bc7..821085d 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -146,6 +146,7 @@ static int tea6420_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
+	i2c_set_clientdata(client, NULL);
 	kfree(sd);
 	return 0;
 }
diff --git a/drivers/media/video/ths7303.c b/drivers/media/video/ths7303.c
index 21781f8..d411a73 100644
--- a/drivers/media/video/ths7303.c
+++ b/drivers/media/video/ths7303.c
@@ -114,6 +114,7 @@ static int ths7303_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
+	i2c_set_clientdata(client, NULL);
 	kfree(sd);
 
 	return 0;
-- 
1.7.0

