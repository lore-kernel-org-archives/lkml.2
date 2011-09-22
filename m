Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1IVMN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 08:13:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52093 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1IVMN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 08:13:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] gma500: frame buffer locking
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 22 Sep 2011 13:20:57 +0100
Message-ID: <20110922122056.2091.88016.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

If we are the console then a printk can hit us with a spin lock held (and
in fact the kernel will do its best to take printing lock).

In that case we cannot politely sleep when synching after an accelerated op
but must behave obnixously to be sure of getting the bits out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/accel_2d.c |   10 ++++++----
 drivers/staging/gma500/psb_drv.c  |    2 +-
 drivers/staging/gma500/psb_drv.h  |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gma500/accel_2d.c b/drivers/staging/gma500/accel_2d.c
index be92371..114b99a 100644
--- a/drivers/staging/gma500/accel_2d.c
+++ b/drivers/staging/gma500/accel_2d.c
@@ -111,8 +111,9 @@ static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 	int ret = 0;
 	int i;
 	unsigned submit_size;
+	unsigned long flags;
 
-	mutex_lock(&dev_priv->mutex_2d);
+	spin_lock_irqsave(&dev_priv->lock_2d, flags);
 	while (size > 0) {
 		submit_size = (size < 0x60) ? size : 0x60;
 		size -= submit_size;
@@ -127,7 +128,7 @@ static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 
 		(void)PSB_RSGX32(PSB_SGX_2D_SLAVE_PORT + i - 4);
 	}
-	mutex_unlock(&dev_priv->mutex_2d);
+	spin_unlock_irqrestore(&dev_priv->lock_2d, flags);
 	return ret;
 }
 
@@ -327,8 +328,9 @@ int psbfb_sync(struct fb_info *info)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long _end = jiffies + DRM_HZ;
 	int busy = 0;
+	unsigned long flags;
 
-	mutex_lock(&dev_priv->mutex_2d);
+	spin_lock_irqsave(&dev_priv->lock_2d, flags);
 	/*
 	 * First idle the 2D engine.
 	 */
@@ -357,7 +359,7 @@ int psbfb_sync(struct fb_info *info)
 					_PSB_C2B_STATUS_BUSY) != 0);
 
 out:
-	mutex_unlock(&dev_priv->mutex_2d);
+	spin_unlock_irqrestore(&dev_priv->lock_2d, flags);
 	return (busy) ? -EBUSY : 0;
 }
 
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 34cf24a..9470af9 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -228,7 +228,7 @@ static int psb_do_init(struct drm_device *dev)
 
 
 	spin_lock_init(&dev_priv->irqmask_lock);
-	mutex_init(&dev_priv->mutex_2d);
+	spin_lock_init(&dev_priv->lock_2d);
 
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK0);
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK1);
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 9cbb494..11d963a 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -612,7 +612,7 @@ struct drm_psb_private {
 	void (*exit_idle)(struct drm_device *dev, u32 update_src);
 
 	/* 2D acceleration */
-	struct mutex mutex_2d;
+	spinlock_t lock_2d;
 
 	/* FIXME: Arrays anyone ? */
 	struct mdfld_dsi_encoder *encoder0;	

