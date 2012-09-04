Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2IDQPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:15:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52034 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab2IDQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:14:53 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/media/platform/davinci/vpbe.c: fix error return code
Date: Tue,  4 Sep 2012 18:14:29 +0200
Message-Id: <1346775269-12191-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/platform/davinci/vpbe.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index c4a82a1..2e4a0da 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -603,7 +603,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	int output_index;
 	int num_encoders;
 	int ret = 0;
-	int err;
 	int i;
 
 	/*
@@ -646,10 +645,10 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	}
 	v4l2_info(&vpbe_dev->v4l2_dev, "vpbe v4l2 device registered\n");
 
-	err = bus_for_each_dev(&platform_bus_type, NULL, vpbe_dev,
+	ret = bus_for_each_dev(&platform_bus_type, NULL, vpbe_dev,
 			       platform_device_get);
-	if (err < 0)
-		return err;
+	if (ret < 0)
+		return ret;
 
 	vpbe_dev->venc = venc_sub_dev_init(&vpbe_dev->v4l2_dev,
 					   vpbe_dev->cfg->venc.module_name);
@@ -664,11 +663,11 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	osd_device = vpbe_dev->osd_device;
 
 	if (NULL != osd_device->ops.initialize) {
-		err = osd_device->ops.initialize(osd_device);
-		if (err) {
+		ret = osd_device->ops.initialize(osd_device);
+		if (ret) {
 			v4l2_err(&vpbe_dev->v4l2_dev,
 				 "unable to initialize the OSD device");
-			err = -ENOMEM;
+			ret = -ENOMEM;
 			goto vpbe_fail_v4l2_device;
 		}
 	}

