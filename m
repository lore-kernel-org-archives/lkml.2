Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab2JOSDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:03:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2JOSDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:03:48 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Airlie <airlied@linux.ie>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm: platform: Don't initialize driver-private data
Date: Mon, 15 Oct 2012 20:03:42 +0200
Message-Id: <1350324222-26885-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12.2
X-Provags-ID: V02:K0:sPWfg7/YNYSoR47c0Ks0c3k713nr0tecAIpWOCvBhmB
 AOjPojtJzpS5Aem1cj3Gy76w4mlFo52nmXxBJQio9kpAcGlcdX
 QbF4oCqiWePPjJmI/sS9lLbRaHQqhMmNXGz+bZAsxoPA5mHSPt
 63ki5E8L/5DKYraDKjMIzgkwOgLc+xzf7vW4ZxQnttOBu8h4Kd
 yKtm8Dy3KxfXH1aDE/9+Dmo5xwIozUMwdcWBBbiJDzbovBn0zI
 NqHdQtIsprH0xAi+1vBY5k+Z2wzKRWzCUKovgUE8IV3CGZ6UFn
 VYq2rcwlVnbIQ9eEqkF9G/B1w1KQdFkw7fMogyxpC4Hh7ja7u7
 jGGg+od3XKvWz+3rLP+aqYXPOBJPb1A14m1xbhDyHdnzPwf5/w
 CcNN5SBdvMk+2OQoHV9mtY0PA1QtnUUc2mnPm4CO9B/IkgZT3I
 i+Zbg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform device drivers usually use the driver-private data for their
own purposes. Having it overwritten by drm_platform_init() is confusing
and error-prone.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Note that I don't have any hardware to test the shmobile changes on so
it would be good to get a Tested-by for that.

 drivers/gpu/drm/drm_platform.c           |  1 -
 drivers/gpu/drm/shmobile/shmob_drm_drv.c | 12 +++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_platform.c b/drivers/gpu/drm/drm_platform.c
index aaeb6f8..b8a282e 100644
--- a/drivers/gpu/drm/drm_platform.c
+++ b/drivers/gpu/drm/drm_platform.c
@@ -64,7 +64,6 @@ int drm_get_platform_dev(struct platform_device *platdev,
 	}
 
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
-		dev_set_drvdata(&platdev->dev, dev);
 		ret = drm_get_minor(dev, &dev->control, DRM_MINOR_CONTROL);
 		if (ret)
 			goto err_g1;
diff --git a/drivers/gpu/drm/shmobile/shmob_drm_drv.c b/drivers/gpu/drm/shmobile/shmob_drm_drv.c
index c71d493..1c350fc 100644
--- a/drivers/gpu/drm/shmobile/shmob_drm_drv.c
+++ b/drivers/gpu/drm/shmobile/shmob_drm_drv.c
@@ -201,6 +201,8 @@ static int shmob_drm_load(struct drm_device *dev, unsigned long flags)
 		goto done;
 	}
 
+	platform_set_drvdata(pdev, sdev);
+
 done:
 	if (ret)
 		shmob_drm_unload(dev);
@@ -299,11 +301,9 @@ static struct drm_driver shmob_drm_driver = {
 #if CONFIG_PM_SLEEP
 static int shmob_drm_pm_suspend(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct drm_device *ddev = platform_get_drvdata(pdev);
-	struct shmob_drm_device *sdev = ddev->dev_private;
+	struct shmob_drm_device *sdev = dev_get_drvdata(dev);
 
-	drm_kms_helper_poll_disable(ddev);
+	drm_kms_helper_poll_disable(sdev->ddev);
 	shmob_drm_crtc_suspend(&sdev->crtc);
 
 	return 0;
@@ -311,9 +311,7 @@ static int shmob_drm_pm_suspend(struct device *dev)
 
 static int shmob_drm_pm_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct drm_device *ddev = platform_get_drvdata(pdev);
-	struct shmob_drm_device *sdev = ddev->dev_private;
+	struct shmob_drm_device *sdev = dev_get_drvdata(dev);
 
 	mutex_lock(&sdev->ddev->mode_config.mutex);
 	shmob_drm_crtc_resume(&sdev->crtc);
-- 
1.7.12.2

