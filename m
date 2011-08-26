Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1HZKXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:23:11 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49227 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1HZKXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:23:09 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/9] gma500: Add VBLANK support for Poulsbo hardware
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:18:13 +0100
Message-ID: <20110826101808.16760.6648.stgit@localhost.localdomain>
In-Reply-To: <20110826101734.16760.64364.stgit@localhost.localdomain>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.h |    3 ++
 drivers/staging/gma500/psb_irq.c |   71 ++++++++++++++++++++++----------------
 2 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 8cd4f1a..9cbb494 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -135,6 +135,9 @@ enum {
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

