Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748Ab2DLSsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:48:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43812 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab2DLSpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:22 -0400
Date: Thu, 12 Apr 2012 20:45:28 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 09/13] s5p-tv: Move HDMIPHY and MHL subdev probing to dedicated
 function
In-reply-to: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Message-id: <1334256332-29867-10-git-send-email-k.lewandowsk@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.9.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/video/s5p-tv/hdmi_drv.c |   90 ++++++++++++++++++---------------
 1 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index 4865d25..fff3cab 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -865,11 +865,47 @@ fail:
 	return -ENODEV;
 }
 
+static struct v4l2_subdev *hdmi_get_subdev(
+	struct hdmi_device *hdmi_dev,
+	struct i2c_board_info *bdinfo,
+	int bus,
+	const char *propname)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct i2c_adapter *adapter;
+	struct device *dev = hdmi_dev->dev;
+
+	if (!bdinfo) {
+		dev_err(dev, "%s info is missing in platform data\n",
+			propname);
+		return ERR_PTR(-ENXIO);
+	}
+
+	adapter = i2c_get_adapter(bus);
+	if (adapter == NULL) {
+		dev_err(dev, "%s adapter request failed, name\n",
+			propname);
+		return ERR_PTR(-ENXIO);
+	}
+
+	sd = v4l2_i2c_new_subdev_board(&hdmi_dev->v4l2_dev,
+				       adapter, bdinfo, NULL);
+
+	/* on failure or not adapter is no longer useful */
+	i2c_put_adapter(adapter);
+
+	if (sd == NULL) {
+		dev_err(dev, "missing subdev for %s\n", propname);
+		return ERR_PTR(-ENODEV);
+	}
+
+	return sd;
+}
+
 static int __devinit hdmi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
-	struct i2c_adapter *adapter;
 	struct v4l2_subdev *sd;
 	struct hdmi_device *hdmi_dev = NULL;
 	struct s5p_hdmi_platform_data *pdata = dev->platform_data;
@@ -937,51 +973,23 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 		goto fail_init;
 	}
 
-	/* testing if hdmiphy info is present */
-	if (!pdata->hdmiphy_info) {
-		dev_err(dev, "hdmiphy info is missing in platform data\n");
-		ret = -ENXIO;
+	hdmi_dev->phy_sd = hdmi_get_subdev(hdmi_dev,
+					   pdata ? pdata->hdmiphy_info : NULL,
+					   pdata ? pdata->hdmiphy_bus : -1,
+					   "phy");
+	if (IS_ERR_OR_NULL(hdmi_dev->phy_sd)) {
+		ret = PTR_ERR(hdmi_dev->phy_sd);
 		goto fail_vdev;
 	}
-
-	adapter = i2c_get_adapter(pdata->hdmiphy_bus);
-	if (adapter == NULL) {
-		dev_err(dev, "hdmiphy adapter request failed\n");
-		ret = -ENXIO;
+	hdmi_dev->mhl_sd = hdmi_get_subdev(hdmi_dev,
+					   pdata ? pdata->mhl_info : NULL ,
+					   pdata ? pdata->mhl_bus : -1,
+					   "mhl");
+	if (IS_ERR_OR_NULL(hdmi_dev->mhl_sd)) {
+		ret = PTR_ERR(hdmi_dev->mhl_sd);
 		goto fail_vdev;
 	}
 
-	hdmi_dev->phy_sd = v4l2_i2c_new_subdev_board(&hdmi_dev->v4l2_dev,
-		adapter, pdata->hdmiphy_info, NULL);
-	/* on failure or not adapter is no longer useful */
-	i2c_put_adapter(adapter);
-	if (hdmi_dev->phy_sd == NULL) {
-		dev_err(dev, "missing subdev for hdmiphy\n");
-		ret = -ENODEV;
-		goto fail_vdev;
-	}
-
-	/* initialization of MHL interface if present */
-	if (pdata->mhl_info) {
-		adapter = i2c_get_adapter(pdata->mhl_bus);
-		if (adapter == NULL) {
-			dev_err(dev, "MHL adapter request failed\n");
-			ret = -ENXIO;
-			goto fail_vdev;
-		}
-
-		hdmi_dev->mhl_sd = v4l2_i2c_new_subdev_board(
-			&hdmi_dev->v4l2_dev, adapter,
-			pdata->mhl_info, NULL);
-		/* on failure or not adapter is no longer useful */
-		i2c_put_adapter(adapter);
-		if (hdmi_dev->mhl_sd == NULL) {
-			dev_err(dev, "missing subdev for MHL\n");
-			ret = -ENODEV;
-			goto fail_vdev;
-		}
-	}
-
 	clk_enable(hdmi_dev->res.hdmi);
 
 	pm_runtime_enable(dev);
-- 
1.7.9.1

