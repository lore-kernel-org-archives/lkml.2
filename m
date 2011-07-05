Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1GEOxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:53:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50594 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab1GEOxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:53:06 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 41/49] gma500: tidying up the power stuff a spot
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:43:21 +0100
Message-ID: <20110705144318.23872.7219.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

In particular don't destroy static mutexes, it upsets things

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/power.c |   33 +++++++++++++--------------------
 1 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/gma500/power.c b/drivers/staging/gma500/power.c
index fc2324e..0eee7fb 100644
--- a/drivers/staging/gma500/power.c
+++ b/drivers/staging/gma500/power.c
@@ -27,6 +27,7 @@
  * Massively reworked
  *    Alan Cox <alan@linux.intel.com>
  */
+
 #include "psb_powermgmt.h"
 #include "psb_drv.h"
 #include "psb_reg.h"
@@ -34,7 +35,8 @@
 #include <linux/mutex.h>
 #include <linux/pm_runtime.h>
 
-static struct mutex power_mutex;
+static struct mutex power_mutex;	/* Serialize power ops */
+static struct mutex power_ctrl_mutex;	/* Serialize power claim */
 
 /**
  *	gma_power_init		-	initialise power manager
@@ -46,8 +48,7 @@ void gma_power_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	/* FIXME: need to sort out fetching apm_reg for both platforms ?? */
-
+	/* FIXME: Move APM/OSPM base into relevant device code */
 	dev_priv->apm_base = dev_priv->apm_reg & 0xffff;
 	dev_priv->ospm_base &= 0xffff;
 
@@ -55,6 +56,7 @@ void gma_power_init(struct drm_device *dev)
 	dev_priv->display_count = 0;	/* Currently no users */
 	dev_priv->suspended = false;	/* And not suspended */
 	mutex_init(&power_mutex);
+	mutex_init(&power_ctrl_mutex);
 
 	dev_priv->ops->init_pm(dev);
 }
@@ -67,23 +69,15 @@ void gma_power_init(struct drm_device *dev)
  */
 void gma_power_uninit(struct drm_device *dev)
 {
-	mutex_destroy(&power_mutex);
 	pm_runtime_disable(&dev->pdev->dev);
 	pm_runtime_set_suspended(&dev->pdev->dev);
 }
 
-
-
-
 /**
  *	gma_suspend_display	-	suspend the display logic
  *	@dev: our DRM device
  *
  *	Suspend the display logic of the graphics interface
- *
- *	FIXME: This ought to be replaced by a dev_priv-> ops interface
- *	where the various platforms register their save/restore methods
- *	and keep them in their own support files.
  */
 static void gma_suspend_display(struct drm_device *dev)
 {
@@ -210,7 +204,6 @@ int gma_power_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-
 /**
  *	gma_power_resume		-	resume power
  *	@pdev: PCI device
@@ -230,8 +223,6 @@ int gma_power_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-
-
 /**
  *	gma_power_is_on		-	returne true if power is on
  *	@dev: our DRM device
@@ -244,7 +235,6 @@ bool gma_power_is_on(struct drm_device *dev)
 	return dev_priv->display_power;
 }
 
-
 /**
  *	gma_power_begin		-	begin requiring power
  *	@dev: our DRM device
@@ -252,22 +242,22 @@ bool gma_power_is_on(struct drm_device *dev)
  *
  *	Begin an action that requires the display power island is enabled.
  *	We refcount the islands.
- *
- *	FIXME: locking
  */
 bool gma_power_begin(struct drm_device *dev, bool force_on)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	int ret;
 
+	mutex_lock(&power_ctrl_mutex);
 	/* Power already on ? */
 	if (dev_priv->display_power) {
 		dev_priv->display_count++;
 		pm_runtime_get(&dev->pdev->dev);
+		mutex_unlock(&power_ctrl_mutex);
 		return true;
 	}
 	if (force_on == false)
-		return false;
+		goto out_false;
 
 	/* Ok power up needed */
 	ret = gma_resume_pci(dev->pdev);
@@ -276,12 +266,14 @@ bool gma_power_begin(struct drm_device *dev, bool force_on)
 		psb_irq_postinstall(dev);
 		pm_runtime_get(&dev->pdev->dev);
 		dev_priv->display_count++;
+		mutex_unlock(&power_ctrl_mutex);
 		return true;
 	}
+out_false:
+	mutex_unlock(&power_ctrl_mutex);
 	return false;
 }
 
-
 /**
  *	gma_power_end		-	end use of power
  *	@dev: Our DRM device
@@ -292,8 +284,10 @@ bool gma_power_begin(struct drm_device *dev, bool force_on)
 void gma_power_end(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
+	mutex_lock(&power_ctrl_mutex);
 	dev_priv->display_count--;
 	WARN_ON(dev_priv->display_count < 0);
+	mutex_unlock(&power_ctrl_mutex);
 	pm_runtime_put(&dev->pdev->dev);
 }
 
@@ -317,4 +311,3 @@ int psb_runtime_idle(struct device *dev)
 	else
 		return 1;
 }
-

