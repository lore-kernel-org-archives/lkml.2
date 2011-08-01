Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1HABzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 21:55:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35524 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1HABzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 21:55:05 -0400
Date: Mon, 1 Aug 2011 03:54:58 +0200
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
Message-ID: <20110801015457.GA10387@patrik-macbook>
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net>
 <4E2CC55B.5010307@gmail.com>
 <4E2CC6CC.5020204@gmail.com>
 <62472696.BtqhiR95vr@wuerfel>
 <20110725224250.7d6edb83@bob.linux.org.uk>
 <CAMeQTsY3T5sPCRYzf8-Xca8y_mWjXSUOOptxHZ2YK5YNL0uvuw@mail.gmail.com>
 <20110726111927.129270f7@lxorguk.ukuu.org.uk>
 <CAMeQTsYhLTPLUBGgBTQ=2xDjzw1aK2Oif+_aC+=hVikALuUXPg@mail.gmail.com>
 <20110726160758.6ce05577@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726160758.6ce05577@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't have a useful IRQ handler currently (or page flipping which
> also needs that). It might help for some cases but again in most of
> these situations if you follow the code the CRT is disabled at the
> point we wait so there isn't a vblank.
> 
> > wait_for_pipe_disable can do mdelay(20) until something better comes
> > up.
> > 
> > If that is ok with you, I'll send some patches.
> 
> Go for it.

Here is a patch that enables vblank for poulsbo. I've tested it with vbltest
from libdrm and it looks ok. I'm not sure how to handle differeces in hardware,
and I have no Medfield, Moorestown or Cedarview to play with so it's your call.
Perhaps we need one irq handler for each chip family?

I've tried to keep most of the old code but had to comment some stuff out to
not interfere with poulsbo. Not sure that the medfield stuff does much good
in it's current form anyways.

I realized that keeping vsync/vblank interrupts enabled at all times will wake
up the cpu quite a lot (thought power consumption seems unchanged). So if we
need to use irqs for wait_for_vblank they should be enabled when there are
processes in the wait queue and disabled when it's empty. Looks like DRM can do
this for us now that vblank is working.

If it's ok with you I'll resend it as a set of 3 patches.

Patrik

---

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index b2cdce7..0f7b5ae 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -410,7 +410,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	PSB_WVDC32(0x00000000, PSB_INT_ENABLE_R);
 	PSB_WVDC32(0xFFFFFFFF, PSB_INT_MASK_R);
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
-	if (drm_core_check_feature(dev, DRIVER_MODESET))
+	if (IS_PSB(dev) && drm_core_check_feature(dev, DRIVER_MODESET))
 		drm_irq_install(dev);
 
 	dev->vblank_disable_allowed = 1;
@@ -1207,9 +1207,6 @@ static struct pci_driver psb_pci_driver = {
 
 static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	/* MLD Added this from Inaky's patch */
-	if (pci_enable_msi(pdev))
-		dev_warn(&pdev->dev, "Enable MSI failed!\n");
 	return drm_get_pci_dev(pdev, ent, &driver);
 }
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 72f487a..33c5f6ea 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -44,6 +44,7 @@ enum {
 	CHIP_MFLD_0130 = 3,		/* Medfield */
 };
 
+#define IS_PSB(dev) (((dev)->pci_device & 0xfffe) == 0x8108)
 #define IS_MRST(dev) (((dev)->pci_device & 0xfffc) == 0x4100)
 #define IS_MFLD(dev) (((dev)->pci_device & 0xfff8) == 0x0130)
 
@@ -135,6 +136,9 @@ enum {
 #define _PSB_IRQ_MSVDX_FLAG	  (1<<19)
 #define _LNC_IRQ_TOPAZ_FLAG	  (1<<20)
 
+#define _PSB_PIPE_EVENT_FLAG	(_PSB_VSYNC_PIPEA_FLAG | \
+				 _PSB_VSYNC_PIPEB_FLAG)
+
 /* This flag includes all the display IRQ bits excepts the vblank irqs. */
 #define _MDFLD_DISP_ALL_IRQ_FLAG (_MDFLD_PIPEC_EVENT_FLAG | \
 				  _MDFLD_PIPEB_EVENT_FLAG | \
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index 4a0fa42..36dd630 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -139,21 +139,10 @@ void mid_disable_pipe_event(struct drm_psb_private *dev_priv, int pipe)
 }
 
 /**
- * Display controller interrupt handler for vsync/vblank.
- *
- */
-static void mid_vblank_handler(struct drm_device *dev, uint32_t pipe)
-{
-	drm_handle_vblank(dev, pipe);
-}
-
-
-/**
  * Display controller interrupt handler for pipe event.
  *
  */
-#define WAIT_STATUS_CLEAR_LOOP_COUNT 0xffff
-static void mid_pipe_event_handler(struct drm_device *dev, uint32_t pipe)
+static void mid_pipe_event_handler(struct drm_device *dev, int pipe)
 {
 	struct drm_psb_private *dev_priv =
 	    (struct drm_psb_private *) dev->dev_private;
@@ -162,6 +151,7 @@ static void mid_pipe_event_handler(struct drm_device *dev, uint32_t pipe)
 	uint32_t pipe_stat_reg = psb_pipestat(pipe);
 	uint32_t pipe_enable = dev_priv->pipestat[pipe];
 	uint32_t pipe_status = dev_priv->pipestat[pipe] >> 16;
+	uint32_t pipe_clear;
 	uint32_t i = 0;
 
 	spin_lock(&dev_priv->irqmask_lock);
@@ -172,27 +162,23 @@ static void mid_pipe_event_handler(struct drm_device *dev, uint32_t pipe)
 
 	spin_unlock(&dev_priv->irqmask_lock);
 
-	/* clear the 2nd level interrupt status bits */
-	/**
-	* FIXME: shouldn't use while loop here. However, the interrupt
-	* status 'sticky' bits cannot be cleared by setting '1' to that
-	* bit once...
-	*/
-	for (i = 0; i < WAIT_STATUS_CLEAR_LOOP_COUNT; i++) {
+	/* Clear the 2nd level interrupt status bits
+	 * Sometimes the bits are very sticky so we repeat until they unstick */
+	for (i = 0; i < 0xffff; i++) {
 		PSB_WVDC32(PSB_RVDC32(pipe_stat_reg), pipe_stat_reg);
-		(void) PSB_RVDC32(pipe_stat_reg);
+		pipe_clear = PSB_RVDC32(pipe_stat_reg) & pipe_status;
 
-		if ((PSB_RVDC32(pipe_stat_reg) & pipe_status) == 0)
+		if (pipe_clear == 0)
 			break;
 	}
 
-	if (i == WAIT_STATUS_CLEAR_LOOP_COUNT)
+	if (pipe_clear)
 		dev_err(dev->dev,
-	"%s, can't clear the status bits in pipe_stat_reg, its value = 0x%x.\n",
-			__func__, PSB_RVDC32(pipe_stat_reg));
+		"%s, can't clear status bits for pipe %d, its value = 0x%x.\n",
+		__func__, pipe, PSB_RVDC32(pipe_stat_reg));
 
 	if (pipe_stat_val & PIPE_VBLANK_STATUS)
-		mid_vblank_handler(dev, pipe);
+		drm_handle_vblank(dev, pipe);
 
 	if (pipe_stat_val & PIPE_TE_STATUS)
 		drm_handle_vblank(dev, pipe);
@@ -203,8 +189,11 @@ static void mid_pipe_event_handler(struct drm_device *dev, uint32_t pipe)
  */
 static void psb_vdc_interrupt(struct drm_device *dev, uint32_t vdc_stat)
 {
-	if (vdc_stat & _PSB_PIPEA_EVENT_FLAG)
+	if (vdc_stat & _PSB_VSYNC_PIPEA_FLAG)
 		mid_pipe_event_handler(dev, 0);
+
+	if (vdc_stat & _PSB_VSYNC_PIPEB_FLAG)
+		mid_pipe_event_handler(dev, 1);
 }
 
 irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
@@ -220,8 +209,13 @@ irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
 
 	vdc_stat = PSB_RVDC32(PSB_INT_IDENTITY_R);
 
+	if (vdc_stat & _PSB_PIPE_EVENT_FLAG)
+		dsp_int = 1;
+
+	/* FIXME: Handle Medfield
 	if (vdc_stat & _MDFLD_DISP_ALL_IRQ_FLAG)
 		dsp_int = 1;
+	*/
 
 	if (vdc_stat & _PSB_IRQ_SGX_FLAG)
 		sgx_int = 1;
@@ -267,13 +261,18 @@ void psb_irq_preinstall(struct drm_device *dev)
 	if (gma_power_is_on(dev))
 		PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
 	if (dev->vblank_enabled[0])
-		dev_priv->vdc_irq_mask |= _PSB_PIPEA_EVENT_FLAG;
+		dev_priv->vdc_irq_mask |= _PSB_VSYNC_PIPEA_FLAG;
+	if (dev->vblank_enabled[1])
+		dev_priv->vdc_irq_mask |= _PSB_VSYNC_PIPEB_FLAG;
+
+	/* FIXME: Handle Medfield irq mask
 	if (dev->vblank_enabled[1])
 		dev_priv->vdc_irq_mask |= _MDFLD_PIPEB_EVENT_FLAG;
 	if (dev->vblank_enabled[2])
 		dev_priv->vdc_irq_mask |= _MDFLD_PIPEC_EVENT_FLAG;
+	*/
 
-	/*This register is safe even if display island is off*/
+	/* This register is safe even if display island is off */
 	PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
 }
@@ -471,7 +470,13 @@ int psb_enable_vblank(struct drm_device *dev, int pipe)
 
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
-	mid_enable_pipe_event(dev_priv, pipe);
+	if (pipe == 0)
+		dev_priv->vdc_irq_mask |= _PSB_VSYNC_PIPEA_FLAG;
+	else if (pipe == 1)
+		dev_priv->vdc_irq_mask |= _PSB_VSYNC_PIPEB_FLAG;
+
+	PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
+	PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
 	psb_enable_pipestat(dev_priv, pipe, PIPE_VBLANK_INTERRUPT_ENABLE);
 
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
@@ -493,7 +498,13 @@ void psb_disable_vblank(struct drm_device *dev, int pipe)
 #endif
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
-	mid_disable_pipe_event(dev_priv, pipe);
+	if (pipe == 0)
+		dev_priv->vdc_irq_mask &= ~_PSB_VSYNC_PIPEA_FLAG;
+	else if (pipe == 1)
+		dev_priv->vdc_irq_mask &= ~_PSB_VSYNC_PIPEB_FLAG;
+
+	PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
+	PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
 	psb_disable_pipestat(dev_priv, pipe, PIPE_VBLANK_INTERRUPT_ENABLE);
 
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
