Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1GEOzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:55:02 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50620 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1GEOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:55:00 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 49/49] gma500: power can be touched in IRQ state
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:45:13 +0100
Message-ID: <20110705144510.23872.54882.stgit@localhost.localdomain>
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

So we need to use a spinlock here

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/power.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/gma500/power.c b/drivers/staging/gma500/power.c
index 79eb670..5cd5023 100644
--- a/drivers/staging/gma500/power.c
+++ b/drivers/staging/gma500/power.c
@@ -36,7 +36,7 @@
 #include <linux/pm_runtime.h>
 
 static struct mutex power_mutex;	/* Serialize power ops */
-static struct mutex power_ctrl_mutex;	/* Serialize power claim */
+static spinlock_t power_ctrl_lock;	/* Serialize power claim */
 
 /**
  *	gma_power_init		-	initialise power manager
@@ -55,8 +55,8 @@ void gma_power_init(struct drm_device *dev)
 	dev_priv->display_power = true;	/* We start active */
 	dev_priv->display_count = 0;	/* Currently no users */
 	dev_priv->suspended = false;	/* And not suspended */
+	spin_lock_init(&power_ctrl_lock);
 	mutex_init(&power_mutex);
-	mutex_init(&power_ctrl_mutex);
 
 	dev_priv->ops->init_pm(dev);
 }
@@ -247,13 +247,14 @@ bool gma_power_begin(struct drm_device *dev, bool force_on)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	int ret;
+	unsigned long flags;
 
-	mutex_lock(&power_ctrl_mutex);
+	spin_lock_irqsave(&power_ctrl_lock, flags);
 	/* Power already on ? */
 	if (dev_priv->display_power) {
 		dev_priv->display_count++;
 		pm_runtime_get(&dev->pdev->dev);
-		mutex_unlock(&power_ctrl_mutex);
+		spin_unlock_irqrestore(&power_ctrl_lock, flags);
 		return true;
 	}
 	if (force_on == false)
@@ -266,11 +267,11 @@ bool gma_power_begin(struct drm_device *dev, bool force_on)
 		psb_irq_postinstall(dev);
 		pm_runtime_get(&dev->pdev->dev);
 		dev_priv->display_count++;
-		mutex_unlock(&power_ctrl_mutex);
+		spin_unlock_irqrestore(&power_ctrl_lock, flags);
 		return true;
 	}
 out_false:
-	mutex_unlock(&power_ctrl_mutex);
+	spin_unlock_irqrestore(&power_ctrl_lock, flags);
 	return false;
 }
 
@@ -284,10 +285,11 @@ out_false:
 void gma_power_end(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	mutex_lock(&power_ctrl_mutex);
+	unsigned long flags;
+	spin_lock_irqsave(&power_ctrl_lock, flags);
 	dev_priv->display_count--;
 	WARN_ON(dev_priv->display_count < 0);
-	mutex_unlock(&power_ctrl_mutex);
+	spin_unlock_irqrestore(&power_ctrl_lock, flags);
 	pm_runtime_put(&dev->pdev->dev);
 }
 

