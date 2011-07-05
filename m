Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1GEOwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:52:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50580 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1GEOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:52:09 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 37/49] gma500: tidy up the opregion and lid code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:42:23 +0100
Message-ID: <20110705144221.23872.23904.stgit@localhost.localdomain>
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

This is leaking an io mapping and also referencing stuff directly that
should not be directly accessed. Sort it out

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/cdv_device.c         |    2 +-
 drivers/staging/gma500/psb_device.c         |    2 +-
 drivers/staging/gma500/psb_drv.c            |    1 +
 drivers/staging/gma500/psb_drv.h            |    5 +++--
 drivers/staging/gma500/psb_intel_opregion.c |   14 +++++++++++---
 drivers/staging/gma500/psb_lid.c            |    6 +++---
 6 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/gma500/cdv_device.c b/drivers/staging/gma500/cdv_device.c
index bb0b3f9..5131106 100644
--- a/drivers/staging/gma500/cdv_device.c
+++ b/drivers/staging/gma500/cdv_device.c
@@ -321,7 +321,7 @@ static void cdv_get_core_freq(struct drm_device *dev)
 static int cdv_chip_setup(struct drm_device *dev)
 {
 	cdv_get_core_freq(dev);
-	psb_intel_opregion_init(dev);
+	intel_opregion_init(dev);
 	psb_intel_init_bios(dev);
 	return 0;
 }
diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index 1be6434..8ac9de7 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -322,7 +322,7 @@ static void psb_get_core_freq(struct drm_device *dev)
 static int psb_chip_setup(struct drm_device *dev)
 {
 	psb_get_core_freq(dev);
-	psb_intel_opregion_init(dev);
+	intel_opregion_init(dev);
 	psb_intel_init_bios(dev);
 	return 0;
 }
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 69ab61b..e9772ab 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -245,6 +245,7 @@ static int psb_driver_unload(struct drm_device *dev)
 
 	if (dev_priv) {
 		psb_lid_timer_takedown(dev_priv);
+		intel_opregion_exit(dev);
 
 		psb_do_takedown(dev);
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 307ff9c..ee782fa 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -727,9 +727,10 @@ extern int mdfld_enable_te(struct drm_device *dev, int pipe);
 extern void mdfld_disable_te(struct drm_device *dev, int pipe);
 
 /*
- * psb_opregion.c
+ * intel_opregion.c
  */
-extern int psb_intel_opregion_init(struct drm_device *dev);
+extern int intel_opregion_init(struct drm_device *dev);
+extern int intel_opregion_exit(struct drm_device *dev);
 
 /*
  * framebuffer.c
diff --git a/drivers/staging/gma500/psb_intel_opregion.c b/drivers/staging/gma500/psb_intel_opregion.c
index 97a8b00..a586f3d 100644
--- a/drivers/staging/gma500/psb_intel_opregion.c
+++ b/drivers/staging/gma500/psb_intel_opregion.c
@@ -47,10 +47,9 @@ struct opregion_acpi {
 	/*FIXME: add it later*/
 } __packed;
 
-int psb_intel_opregion_init(struct drm_device *dev)
+int intel_opregion_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	/*struct psb_intel_opregion * opregion = &dev_priv->opregion;*/
 	u32 opregion_phy;
 	void *base;
 	u32 *lid_state;
@@ -68,6 +67,15 @@ int psb_intel_opregion_init(struct drm_device *dev)
 	lid_state = base + 0x01ac;
 
 	dev_priv->lid_state = lid_state;
-	dev_priv->lid_last_state = *lid_state;
+	dev_priv->lid_last_state = readl(lid_state);
 	return 0;
 }
+
+int intel_opregion_exit(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	if (dev_priv->lid_state)
+		iounmap(dev_priv->lid_state);
+	return 0;
+}
+	
\ No newline at end of file
diff --git a/drivers/staging/gma500/psb_lid.c b/drivers/staging/gma500/psb_lid.c
index 21fd202..af32851 100644
--- a/drivers/staging/gma500/psb_lid.c
+++ b/drivers/staging/gma500/psb_lid.c
@@ -32,10 +32,10 @@ static void psb_lid_timer_func(unsigned long data)
 	u32 *lid_state = dev_priv->lid_state;
 	u32 pp_status;
 
-	if (*lid_state == dev_priv->lid_last_state)
+	if (readl(lid_state) == dev_priv->lid_last_state)
 		goto lid_timer_schedule;
 
-	if ((*lid_state) & 0x01) {
+	if ((readl(lid_state)) & 0x01) {
 		/*lid state is open*/
 		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) | POWER_TARGET_ON);
 		do {
@@ -54,7 +54,7 @@ static void psb_lid_timer_func(unsigned long data)
 	}
 		/* printk(KERN_INFO"%s: lid: closed\n", __FUNCTION__); */
 
-	dev_priv->lid_last_state =  *lid_state;
+	dev_priv->lid_last_state =  readl(lid_state);
 
 lid_timer_schedule:
 	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);

