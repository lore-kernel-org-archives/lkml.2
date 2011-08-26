Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab1HZKZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:25:05 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49245 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab1HZKZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:25:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 8/9] gma500: frame buffer locking
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:19:58 +0100
Message-ID: <20110826101945.16760.8598.stgit@localhost.localdomain>
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

If we are the console then a printk can hit us with a spin lock held (and
in fact the kernel will do its best to take printing lock).

In that case we cannot politely sleep when synching after an accelerated op
but must behave obnixously to be sure of getting the bits out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/accel_2d.c |   10 ++++++----
 drivers/staging/gma500/psb_drv.c  |    2 +-
 drivers/staging/gma500/psb_drv.h  |    2 +-
 kernel/printk.c                   |    2 +-
 4 files changed, 9 insertions(+), 7 deletions(-)

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
diff --git a/kernel/printk.c b/kernel/printk.c
index e861488..af2eec8 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -512,7 +512,7 @@ static void __call_console_drivers(unsigned start, unsigned end)
 	struct console *con;
 
 	for_each_console(con) {
-		if (exclusive_console && con != exclusive_console)
+		if (0 && exclusive_console && con != exclusive_console)
 			continue;
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||

