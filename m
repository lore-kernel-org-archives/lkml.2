Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2INQrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:47:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40061 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab2INQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:47:00 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/platform/davinci/vpbe.c: Remove unused label and rename remaining labels
Date: Fri, 14 Sep 2012 18:46:52 +0200
Message-Id: <1347641212-26357-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Remove unused label and rename remaining labels

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
Depends on patch [v2,7/8] drivers/media/platform/davinci/vpbe.c: Removes
useless kfree() - http://patchwork.linuxtv.org/patch/14307/

 drivers/media/platform/davinci/vpbe.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 1125a87..4d8e399 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -626,11 +626,11 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 		vpbe_dev->dac_clk = clk_get(vpbe_dev->pdev, "vpss_dac");
 		if (IS_ERR(vpbe_dev->dac_clk)) {
 			ret =  PTR_ERR(vpbe_dev->dac_clk);
-			goto vpbe_unlock;
+			goto fail_mutex_unlock;
 		}
 		if (clk_enable(vpbe_dev->dac_clk)) {
 			ret =  -ENODEV;
-			goto vpbe_unlock;
+			goto fail_mutex_unlock;
 		}
 	}
 
@@ -642,7 +642,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	if (ret) {
 		v4l2_err(dev->driver,
 			"Unable to register v4l2 device.\n");
-		goto vpbe_fail_clock;
+		goto fail_clk_put;
 	}
 	v4l2_info(&vpbe_dev->v4l2_dev, "vpbe v4l2 device registered\n");
 
@@ -658,7 +658,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 		v4l2_err(&vpbe_dev->v4l2_dev,
 			"vpbe unable to init venc sub device\n");
 		ret = -ENODEV;
-		goto vpbe_fail_v4l2_device;
+		goto fail_dev_unregister;
 	}
 	/* initialize osd device */
 	osd_device = vpbe_dev->osd_device;
@@ -669,7 +669,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 			v4l2_err(&vpbe_dev->v4l2_dev,
 				 "unable to initialize the OSD device");
 			err = -ENOMEM;
-			goto vpbe_fail_v4l2_device;
+			goto fail_dev_unregister;
 		}
 	}
 
@@ -685,7 +685,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 		v4l2_err(&vpbe_dev->v4l2_dev,
 			"unable to allocate memory for encoders sub devices");
 		ret = -ENOMEM;
-		goto vpbe_fail_v4l2_device;
+		goto fail_dev_unregister;
 	}
 
 	i2c_adap = i2c_get_adapter(vpbe_dev->cfg->i2c_adapter_id);
@@ -711,7 +711,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 					 " failed to register",
 					 enc_info->module_name);
 				ret = -ENODEV;
-				goto vpbe_fail_sd_register;
+				goto fail_kfree_encoders;
 			}
 		} else
 			v4l2_warn(&vpbe_dev->v4l2_dev, "non-i2c encoders"
@@ -730,7 +730,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 					 "amplifier %s failed to register",
 					 amp_info->module_name);
 				ret = -ENODEV;
-				goto vpbe_fail_amp_register;
+				goto fail_kfree_encoders;
 			}
 			v4l2_info(&vpbe_dev->v4l2_dev,
 					  "v4l2 sub device %s registered\n",
@@ -770,15 +770,14 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	/* TBD handling of bootargs for default output and mode */
 	return 0;
 
-vpbe_fail_amp_register:
-vpbe_fail_sd_register:
+fail_kfree_encoders:
 	kfree(vpbe_dev->encoders);
-vpbe_fail_v4l2_device:
+fail_dev_unregister:
 	v4l2_device_unregister(&vpbe_dev->v4l2_dev);
-vpbe_fail_clock:
+fail_clk_put:
 	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0)
 		clk_put(vpbe_dev->dac_clk);
-vpbe_unlock:
+fail_mutex_unlock:
 	mutex_unlock(&vpbe_dev->lock);
 	return ret;
 }

