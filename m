Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1HZKZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:25:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49248 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab1HZKZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:25:16 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 9/9] gma500: Fix up suspend/resume
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:20:17 +0100
Message-ID: <20110826102009.16760.66603.stgit@localhost.localdomain>
In-Reply-To: <20110826101734.16760.64364.stgit@localhost.localdomain>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This isn't ideal as we could do with deferring the power on a lot more on
Oaktrail and Medfield. We can't however do that without fixing other things
first.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/power.c             |    6 +++--
 drivers/staging/gma500/psb_drv.c           |   36 ++++++++++++----------------
 drivers/staging/gma500/psb_intel_display.c |    4 ---
 3 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/gma500/power.c b/drivers/staging/gma500/power.c
index 9402569..436fe97 100644
--- a/drivers/staging/gma500/power.c
+++ b/drivers/staging/gma500/power.c
@@ -83,7 +83,7 @@ static void gma_suspend_display(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	if (dev_priv->suspended)
+	if (!dev_priv->display_power)
 		return;
 	dev_priv->ops->save_regs(dev);
 	dev_priv->ops->power_down(dev);
@@ -101,7 +101,7 @@ static void gma_resume_display(struct pci_dev *pdev)
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	if (dev_priv->suspended == false)
+	if (dev_priv->display_power)
 		return;
 
 	/* turn on the display power island */
@@ -265,6 +265,8 @@ bool gma_power_begin(struct drm_device *dev, bool force_on)
 	/* Ok power up needed */
 	ret = gma_resume_pci(dev->pdev);
 	if (ret == 0) {
+		/* FIXME: we want to defer this for Medfield/Oaktrail */
+		gma_resume_display(dev);
 		psb_irq_preinstall(dev);
 		psb_irq_postinstall(dev);
 		pm_runtime_get(&dev->pdev->dev);
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 9470af9..dc676c2 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -448,12 +448,9 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	if (ret)
 		return ret;
-#if 0
-	/*enable runtime pm at last*/
-	pm_runtime_enable(&dev->pdev->dev);
+
+	/* Enable runtime pm at last */
 	pm_runtime_set_active(&dev->pdev->dev);
-#endif
-	/*Intel drm driver load is done, continue doing pvr load*/
 	return 0;
 out_err:
 	psb_driver_unload(dev);
@@ -470,14 +467,13 @@ static int psb_sizes_ioctl(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv)
 {
 	struct drm_psb_private *dev_priv = psb_priv(dev);
-	struct drm_psb_sizes_arg *arg =
-		(struct drm_psb_sizes_arg *) data;
+	struct drm_psb_sizes_arg *arg = data;
 
 	*arg = dev_priv->sizes;
 	return 0;
 }
 
-static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
+static int psb_dc_state_ioctl(struct drm_device *dev, void *data,
 				struct drm_file *file_priv)
 {
 	uint32_t flags;
@@ -485,8 +481,7 @@ static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
 	struct drm_mode_object *obj;
 	struct drm_connector *connector;
 	struct drm_crtc *crtc;
-	struct drm_psb_dc_state_arg *arg =
-		(struct drm_psb_dc_state_arg *)data;
+	struct drm_psb_dc_state_arg *arg = data;
 
 
 	/* Double check MRST case */
@@ -1114,15 +1109,12 @@ static long psb_unlocked_ioctl(struct file *filp, unsigned int cmd,
 {
 	struct drm_file *file_priv = filp->private_data;
 	struct drm_device *dev = file_priv->minor->dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	static unsigned int runtime_allowed;
-
-	if (runtime_allowed == 1 && dev_priv->is_lvds_on) {
-		runtime_allowed++;
-		pm_runtime_allow(&dev->pdev->dev);
-		dev_priv->rpm_enabled = 1;
-	}
-	return drm_ioctl(filp, cmd, arg);
+	int ret;
+	
+	pm_runtime_forbid(dev->dev);
+	ret = drm_ioctl(filp, cmd, arg);
+	pm_runtime_allow(dev->dev);
+	return ret;
 	/* FIXME: do we need to wrap the other side of this */
 }
 
@@ -1141,8 +1133,12 @@ static void psb_remove(struct pci_dev *pdev)
 }
 
 static const struct dev_pm_ops psb_pm_ops = {
-	.resume = gma_power_resume,
 	.suspend = gma_power_suspend,
+	.resume = gma_power_resume,
+	.freeze = gma_power_suspend,
+	.thaw = gma_power_resume,
+	.poweroff = gma_power_suspend,
+	.restore = gma_power_resume,
 	.runtime_suspend = psb_runtime_suspend,
 	.runtime_resume = psb_runtime_resume,
 	.runtime_idle = psb_runtime_idle,
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 4afa671..caa9d86 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1102,10 +1102,6 @@ static int psb_crtc_set_config(struct drm_mode_set *set)
 {
 	int ret;
 	struct drm_device *dev = set->crtc->dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	if (!dev_priv->rpm_enabled)
-		return drm_crtc_helper_set_config(set);
 
 	pm_runtime_forbid(&dev->pdev->dev);
 	ret = drm_crtc_helper_set_config(set);

