Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1GOQof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:44:35 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35841 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1GOQod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:44:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 14/15] gma500: resync with Medfield progress
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 15 Jul 2011 17:35:36 +0100
Message-ID: <20110715163534.28759.4630.stgit@localhost.localdomain>
In-Reply-To: <20110715163117.28759.14946.stgit@localhost.localdomain>
References: <20110715163117.28759.14946.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mdfld_dsi_dbi.c        |  369 ++++++++---------------
 drivers/staging/gma500/mdfld_dsi_dbi.h        |   21 -
 drivers/staging/gma500/mdfld_dsi_dbi_dpu.h    |    3 
 drivers/staging/gma500/mdfld_dsi_dpi.c        |  319 ++++----------------
 drivers/staging/gma500/mdfld_dsi_dpi.h        |    6 
 drivers/staging/gma500/mdfld_dsi_output.c     |  250 +++++++++-------
 drivers/staging/gma500/mdfld_dsi_output.h     |  203 -------------
 drivers/staging/gma500/mdfld_dsi_pkg_sender.c |  403 +++++++++++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_pkg_sender.h |   26 ++
 drivers/staging/gma500/mdfld_intel_display.c  |    6 
 drivers/staging/gma500/mdfld_output.c         |    8 
 drivers/staging/gma500/mdfld_output.h         |   41 ---
 drivers/staging/gma500/mdfld_pyr_cmd.c        |   18 -
 drivers/staging/gma500/mdfld_tmd_vid.c        |   62 ++++
 drivers/staging/gma500/mdfld_tpo_cmd.c        |   64 +++-
 drivers/staging/gma500/mrst_lvds.c            |   35 ++
 drivers/staging/gma500/psb_drv.h              |    7 
 17 files changed, 917 insertions(+), 924 deletions(-)

diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.c b/drivers/staging/gma500/mdfld_dsi_dbi.c
index 1421f49..06424f9 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.c
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.c
@@ -39,29 +39,10 @@ extern int gfxrtdelay;
 int enter_dsr;
 struct mdfld_dsi_dbi_output *gdbi_output;
 extern bool gbgfxsuspended;
+extern int enable_gfx_rtpm;
 extern int gfxrtdelay;
 
-#ifdef CONFIG_GFX_RTPM
-static void psb_runtimepm_wq_handler(struct work_struct *work);
-DECLARE_DELAYED_WORK(rtpm_work, psb_runtimepm_wq_handler);
-
-void psb_runtimepm_wq_handler(struct work_struct *work)
-{
-	struct drm_psb_private *dev_priv =  gpDrmDevice->dev_private;
-
-	if (drm_psb_ospm && !enable_gfx_rtpm) {
-		pr_info("Enable GFX runtime_pm\n");
-		dev_priv->rpm_enabled = 1;
-		enable_gfx_rtpm = 1;
-
-		pm_runtime_enable(&gpDrmDevice->pdev->dev);
-		pm_runtime_set_active(&gpDrmDevice->pdev->dev);
-
-		pm_runtime_allow(&gpDrmDevice->pdev->dev);
-	}
-}
-#endif
-
+#define MDFLD_DSR_MAX_IDLE_COUNT	2
 
 /*
  * set refreshing area
@@ -80,8 +61,8 @@ int mdfld_dsi_dbi_update_area(struct mdfld_dsi_dbi_output *dbi_output,
 		return -EINVAL;
 	}
 
-	/*set column*/
-	cmd = set_column_address;
+	/* Set column */
+	cmd = DCS_SET_COLUMN_ADDRESS;
 	param[0] = x1 >> 8;
 	param[1] = x1;
 	param[2] = x2 >> 8;
@@ -98,8 +79,8 @@ int mdfld_dsi_dbi_update_area(struct mdfld_dsi_dbi_output *dbi_output,
 		goto err_out;
 	}
 
-	/*set page*/
-	cmd = set_page_addr;
+	/* Set page */
+	cmd = DCS_SET_PAGE_ADDRESS;
 	param[0] = y1 >> 8;
 	param[1] = y1;
 	param[2] = y2 >> 8;
@@ -139,56 +120,46 @@ int mdfld_dsi_dbi_update_power(struct mdfld_dsi_dbi_output *dbi_output,
 								int mode)
 {
 	struct drm_device *dev = dbi_output->dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct mdfld_dsi_pkg_sender *sender =
 		mdfld_dsi_encoder_get_pkg_sender(&dbi_output->base);
 	u8 param = 0;
 	u32 err = 0;
 
-	if (!dev_priv->dispstatus && mode != DRM_MODE_DPMS_ON) {
-		dev_err(dev->dev, "%s: already OFF ignoring\n", __func__);
-		return 0;
-	}
-	if (dev_priv->dispstatus && mode == DRM_MODE_DPMS_ON) {
-		dev_err(dev->dev, "%s: already ON ignoring\n", __func__);
-		return 0;
-	}
-
 	if (!sender) {
 		WARN_ON(1);
 		return -EINVAL;
 	}
 
 	if (mode == DRM_MODE_DPMS_ON) {
-		/*exit sleep mode*/
+		/* Exit sleep mode */
 		err = mdfld_dsi_send_dcs(sender,
-					 exit_sleep_mode,
+					 DCS_EXIT_SLEEP_MODE,
 					 NULL,
 					 0,
 					 CMD_DATA_SRC_SYSTEM_MEM,
 					 MDFLD_DSI_QUEUE_PACKAGE);
 		if (err) {
 			dev_err(dev->dev, "DCS 0x%x sent failed\n",
-						exit_sleep_mode);
+						DCS_EXIT_SLEEP_MODE);
 			goto power_err;
 		}
 
-		/*set display on*/
+		/* Set display on */
 		err = mdfld_dsi_send_dcs(sender,
-					 set_display_on,
+					 DCS_SET_DISPLAY_ON,
 					 NULL,
 					 0,
 					 CMD_DATA_SRC_SYSTEM_MEM,
 					 MDFLD_DSI_QUEUE_PACKAGE);
 		if (err) {
 			dev_err(dev->dev, "DCS 0x%x sent failed\n",
-							set_display_on);
+							DCS_SET_DISPLAY_ON);
 			goto power_err;
 		}
 
 		/* set tear effect on */
 		err = mdfld_dsi_send_dcs(sender,
-					 set_tear_on,
+					 DCS_SET_TEAR_ON,
 					 &param,
 					 1,
 					 CMD_DATA_SRC_SYSTEM_MEM,
@@ -203,53 +174,53 @@ int mdfld_dsi_dbi_update_power(struct mdfld_dsi_dbi_output *dbi_output,
 		 * FIXME: remove this later
 		 */
 		err = mdfld_dsi_send_dcs(sender,
-					 write_mem_start,
+					 DCS_WRITE_MEM_START,
 					 NULL,
 					 0,
 					 CMD_DATA_SRC_PIPE,
 					 MDFLD_DSI_QUEUE_PACKAGE);
 		if (err) {
 			dev_err(dev->dev, "DCS 0x%x sent failed\n",
-							set_display_on);
+						DCS_WRITE_MEM_START);
 			goto power_err;
 		}
 	} else {
-		/*set tear effect off */
+		/* Set tear effect off */
 		err = mdfld_dsi_send_dcs(sender,
-					 set_tear_off,
+					 DCS_SET_TEAR_OFF,
 					 NULL,
 					 0,
 					 CMD_DATA_SRC_SYSTEM_MEM,
 					 MDFLD_DSI_QUEUE_PACKAGE);
 		if (err) {
 			dev_err(dev->dev, "DCS 0x%x sent failed\n",
-							set_tear_off);
+							DCS_SET_TEAR_OFF);
 			goto power_err;
 		}
 
-		/*set display off*/
+		/* Turn display off */
 		err = mdfld_dsi_send_dcs(sender,
-					 set_display_off,
+					 DCS_SET_DISPLAY_OFF,
 					 NULL,
 					 0,
 					 CMD_DATA_SRC_SYSTEM_MEM,
 					 MDFLD_DSI_QUEUE_PACKAGE);
 		if (err) {
 			dev_err(dev->dev, "DCS 0x%x sent failed\n",
-							set_display_off);
+						DCS_SET_DISPLAY_OFF);
 			goto power_err;
 		}
 
-		/*enter sleep mode*/
+		/* Now enter sleep mode */
 		err = mdfld_dsi_send_dcs(sender,
-					 enter_sleep_mode,
+					 DCS_ENTER_SLEEP_MODE,
 					 NULL,
 					 0,
 					 CMD_DATA_SRC_SYSTEM_MEM,
 					 MDFLD_DSI_QUEUE_PACKAGE);
 		if (err) {
 			dev_err(dev->dev, "DCS 0x%x sent failed\n",
-							enter_sleep_mode);
+							DCS_ENTER_SLEEP_MODE);
 			goto power_err;
 		}
 	}
@@ -283,7 +254,6 @@ int mdfld_dsi_dbi_send_dcs(struct mdfld_dsi_dbi_output *dbi_output,
 	return ret;
 }
 
-
 /*
  * Enter DSR
  */
@@ -299,11 +269,12 @@ void mdfld_dsi_dbi_enter_dsr(struct mdfld_dsi_dbi_output *dbi_output, int pipe)
 	u32 pipeconf_reg = PIPEACONF;
 	u32 dspcntr_reg = DSPACNTR;
 
-	dev_priv->is_in_idle = true;
-
 	if (!dbi_output)
 		return;
 
+	/* FIXME check if can go */
+	dev_priv->is_in_idle = true;
+
 	gdbi_output = dbi_output;
 	if ((dbi_output->mode_flags & MODE_SETTING_ON_GOING) ||
 		(psb_crtc && psb_crtc->mode_flags & MODE_SETTING_ON_GOING))
@@ -319,16 +290,17 @@ void mdfld_dsi_dbi_enter_dsr(struct mdfld_dsi_dbi_output *dbi_output, int pipe)
 		dev_err(dev->dev, "hw begin failed\n");
 		return;
 	}
-	/*disable te interrupts. */
+	/* Disable te interrupts */
 	mdfld_disable_te(dev, pipe);
 
-	/*disable plane*/
+	/* Disable plane */
 	reg_val = REG_READ(dspcntr_reg);
 	if (!(reg_val & DISPLAY_PLANE_ENABLE)) {
 		REG_WRITE(dspcntr_reg, reg_val & ~DISPLAY_PLANE_ENABLE);
 		REG_READ(dspcntr_reg);
 	}
-	/*disable pipe*/
+
+	/* Disable pipe */
 	reg_val = REG_READ(pipeconf_reg);
 	if (!(reg_val & DISPLAY_PLANE_ENABLE)) {
 		reg_val &= ~DISPLAY_PLANE_ENABLE;
@@ -338,7 +310,7 @@ void mdfld_dsi_dbi_enter_dsr(struct mdfld_dsi_dbi_output *dbi_output, int pipe)
 		mdfldWaitForPipeDisable(dev, pipe);
 	}
 
-	/*disable DPLL*/
+	/* Disable DPLL */
 	reg_val = REG_READ(dpll_reg);
 	if (!(reg_val & DPLL_VCO_ENABLE)) {
 		reg_val &= ~DPLL_VCO_ENABLE;
@@ -357,10 +329,9 @@ void mdfld_dsi_dbi_enter_dsr(struct mdfld_dsi_dbi_output *dbi_output, int pipe)
 
 #ifndef CONFIG_MDFLD_DSI_DPU
 static void mdfld_dbi_output_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
-			int pipe, void *p_surfaceAddr, bool check_hw_on_only)
+			int pipe)
 {
 	struct drm_device *dev = dbi_output->dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct drm_crtc *crtc = dbi_output->base.base.crtc;
 	struct psb_intel_crtc *psb_crtc = (crtc) ?
 					to_psb_intel_crtc(crtc) : NULL;
@@ -368,7 +339,6 @@ static void mdfld_dbi_output_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 	u32 dpll_reg = MRST_DPLL_A;
 	u32 pipeconf_reg = PIPEACONF;
 	u32 dspcntr_reg = DSPACNTR;
-	u32 dspsurf_reg = DSPASURF;
 	u32 reg_offset = 0;
 
 	/*if mode setting on-going, back off*/
@@ -380,24 +350,17 @@ static void mdfld_dbi_output_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 		dpll_reg = MRST_DPLL_A;
 		pipeconf_reg = PIPECCONF;
 		dspcntr_reg = DSPCCNTR;
-		dspsurf_reg = DSPCSURF;
 		reg_offset = MIPIC_REG_OFFSET;
 	}
 
-	if (check_hw_on_only) {
-		if (0/* FIXME!ospm_power_is_hw_on(_DISPLAY_ISLAND)*/) {
-			dev_err(dev->dev, "hw begin failed\n");
-			return;
-		}
-	} else if (!gma_power_begin(dev, true)) {
+	if (!gma_power_begin(dev, true)) {
 		dev_err(dev->dev, "hw begin failed\n");
 		return;
 	}
 
-	/*enable DPLL*/
+	/* Enable DPLL */
 	reg_val = REG_READ(dpll_reg);
 	if (!(reg_val & DPLL_VCO_ENABLE)) {
-
 		if (reg_val & MDFLD_PWR_GATE_EN) {
 			reg_val &= ~MDFLD_PWR_GATE_EN;
 			REG_WRITE(dpll_reg, reg_val);
@@ -415,7 +378,7 @@ static void mdfld_dbi_output_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 			cpu_relax();
 	}
 
-	/*enable pipe*/
+	/* Enable pipe */
 	reg_val = REG_READ(pipeconf_reg);
 	if (!(reg_val & PIPEACONF_ENABLE)) {
 		reg_val |= PIPEACONF_ENABLE;
@@ -425,7 +388,7 @@ static void mdfld_dbi_output_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 		mdfldWaitForPipeEnable(dev, pipe);
 	}
 
-	/*enable plane*/
+	/* Enable plane */
 	reg_val = REG_READ(dspcntr_reg);
 	if (!(reg_val & DISPLAY_PLANE_ENABLE)) {
 		reg_val |= DISPLAY_PLANE_ENABLE;
@@ -434,15 +397,9 @@ static void mdfld_dbi_output_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 		udelay(500);
 	}
 
-	/* update the surface base address. */
-	if (p_surfaceAddr)
-		REG_WRITE(dspsurf_reg, *((u32 *)p_surfaceAddr));
-
-	if (!check_hw_on_only)
-		gma_power_end(dev);
-
-	/*enable TE interrupt on this pipe*/
+	/* Enable TE interrupt on this pipe */
 	mdfld_enable_te(dev, pipe);
+	gma_power_end(dev);
 
 	/*clean IN_DSR flag*/
 	dbi_output->mode_flags &= ~MODE_SETTING_IN_DSR;
@@ -451,33 +408,33 @@ static void mdfld_dbi_output_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 /*
  * Exit from DSR
  */
-void mdfld_dsi_dbi_exit_dsr(struct drm_device *dev, u32 update_src,
-				void *p_surfaceAddr, bool check_hw_on_only)
+void mdfld_dsi_dbi_exit_dsr(struct drm_device *dev, u32 update_src)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
 	struct mdfld_dsi_dbi_output **dbi_output;
 	int i;
+	int pipe;
 
+	/* FIXME can go ? */
 	dev_priv->is_in_idle = false;
 	dbi_output = dsr_info->dbi_outputs;
 
 #ifdef CONFIG_PM_RUNTIME
 	 if (!enable_gfx_rtpm) {
 /*                pm_runtime_allow(&gpDrmDevice->pdev->dev); */
-/*		schedule_delayed_work(&rtpm_work, 120 * 1000); */
+/*		schedule_delayed_work(&rtpm_work, 30 * 1000);*/ /* FIXME: HZ ? */
 	}
 #endif
 
-	/*for each output, exit dsr*/
+	/* For each output, exit dsr */
 	for (i = 0; i < dsr_info->dbi_output_num; i++) {
-		/*if panel has been turned off, skip*/
-		if (!dbi_output[i]->dbi_panel_on)
+		/* If panel has been turned off, skip */
+		if (!dbi_output[i] || !dbi_output[i]->dbi_panel_on)
 			continue;
-		if (dbi_output[i]->mode_flags & MODE_SETTING_IN_DSR) {
-			enter_dsr = 0;
-			mdfld_dbi_output_exit_dsr(dbi_output[i], dbi_output[i]->channel_num ? 2 : 0, p_surfaceAddr, check_hw_on_only);
-		}
+		pipe = dbi_output[i]->channel_num ? 2 : 0;
+		enter_dsr = 0;
+		mdfld_dbi_output_exit_dsr(dbi_output[i], pipe);
 	}
 	dev_priv->dsr_fb_update |= update_src;
 }
@@ -496,7 +453,7 @@ static bool mdfld_dbi_is_in_dsr(struct drm_device *dev)
 	return true;
 }
 
-/* Perodically update dbi panel */
+/* Periodically update dbi panel */
 void mdfld_dbi_update_panel(struct drm_device *dev, int pipe)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
@@ -504,8 +461,8 @@ void mdfld_dbi_update_panel(struct drm_device *dev, int pipe)
 	struct mdfld_dsi_dbi_output **dbi_outputs;
 	struct mdfld_dsi_dbi_output *dbi_output;
 	int i;
-	int enter_dsr = 0;
-	u32 damage_mask = 0;
+	int can_enter_dsr = 0;
+	u32 damage_mask;
 
 	dbi_outputs = dsr_info->dbi_outputs;
 	dbi_output = pipe ? dbi_outputs[1] : dbi_outputs[0];
@@ -514,13 +471,13 @@ void mdfld_dbi_update_panel(struct drm_device *dev, int pipe)
 		return;
 
 	if (pipe == 0)
-		damage_mask = dev_priv->dsr_fb_update & (MDFLD_DSR_DAMAGE_MASK_0);
+		damage_mask = dev_priv->dsr_fb_update & MDFLD_DSR_DAMAGE_MASK_0;
 	else if (pipe == 2)
-		damage_mask = dev_priv->dsr_fb_update & (MDFLD_DSR_DAMAGE_MASK_2);
+		damage_mask = dev_priv->dsr_fb_update & MDFLD_DSR_DAMAGE_MASK_2;
 	else
 		return;
 
-	/*if FB is damaged and panel is on update on-panel FB*/
+	/* If FB is damaged and panel is on update on-panel FB */
 	if (damage_mask && dbi_output->dbi_panel_on) {
 		dbi_output->dsr_fb_update_done = false;
 
@@ -538,11 +495,24 @@ void mdfld_dbi_update_panel(struct drm_device *dev, int pipe)
 		dbi_output->dsr_idle_count++;
 	}
 
-	/*try to enter DSR*/
-	if (dbi_outputs[0]->dsr_idle_count > 1
-	    && dbi_outputs[1]->dsr_idle_count > 1) {
+	switch (dsr_info->dbi_output_num) {
+	case 1:
+		if (dbi_output->dsr_idle_count > MDFLD_DSR_MAX_IDLE_COUNT)
+			can_enter_dsr = 1;
+		break;
+	case 2:
+		if (dbi_outputs[0]->dsr_idle_count > MDFLD_DSR_MAX_IDLE_COUNT
+		   && dbi_outputs[1]->dsr_idle_count > MDFLD_DSR_MAX_IDLE_COUNT)
+			can_enter_dsr = 1;
+		break;
+	default:
+		DRM_ERROR("Wrong DBI output number\n");
+	}
+
+	/* Try to enter DSR */
+	if (can_enter_dsr) {
 		for (i = 0; i < dsr_info->dbi_output_num; i++) {
-			if (!mdfld_dbi_is_in_dsr(dev) &&
+			if (!mdfld_dbi_is_in_dsr(dev) && dbi_outputs[i] &&
 			   !(dbi_outputs[i]->mode_flags & MODE_SETTING_ON_GOING)) {
 				mdfld_dsi_dbi_enter_dsr(dbi_outputs[i],
 					dbi_outputs[i]->channel_num ? 2 : 0);
@@ -565,61 +535,6 @@ void mdfld_dbi_update_panel(struct drm_device *dev, int pipe)
 	}
 }
 
-/*timers for DSR*/
-static void mdfld_dsi_dbi_dsr_timer_func(unsigned long data)
-{
-	struct drm_device *dev = (struct drm_device *)data;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
-	struct timer_list *dsr_timer = &dsr_info->dsr_timer;
-	unsigned long flags;
-
-	mdfld_dbi_update_panel(dev, 0);
-
-	if (dsr_info->dsr_idle_count > 1)
-		return;
-
-	spin_lock_irqsave(&dsr_info->dsr_timer_lock, flags);
-	if (!timer_pending(dsr_timer)) {
-		dsr_timer->expires = jiffies + MDFLD_DSR_DELAY;
-		add_timer(dsr_timer);
-	}
-	spin_unlock_irqrestore(&dsr_info->dsr_timer_lock, flags);
-}
-
-static int mdfld_dsi_dbi_dsr_timer_init(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
-	struct timer_list *dsr_timer = &dsr_info->dsr_timer;
-	unsigned long flags;
-
-	spin_lock_init(&dsr_info->dsr_timer_lock);
-	spin_lock_irqsave(&dsr_info->dsr_timer_lock, flags);
-
-	init_timer(dsr_timer);
-
-	dsr_timer->data = (unsigned long)dev;
-	dsr_timer->function = mdfld_dsi_dbi_dsr_timer_func;
-	dsr_timer->expires = jiffies + MDFLD_DSR_DELAY;
-
-	spin_unlock_irqrestore(&dsr_info->dsr_timer_lock, flags);
-	return 0;
-}
-
-void mdfld_dbi_dsr_timer_start(struct mdfld_dbi_dsr_info *dsr_info)
-{
-	struct timer_list *dsr_timer = &dsr_info->dsr_timer;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dsr_info->dsr_timer_lock, flags);
-	if (!timer_pending(dsr_timer)) {
-		dsr_timer->expires = jiffies + MDFLD_DSR_DELAY;
-		add_timer(dsr_timer);
-	}
-	spin_unlock_irqrestore(&dsr_info->dsr_timer_lock, flags);
-}
-
 int mdfld_dbi_dsr_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
@@ -643,7 +558,6 @@ void mdfld_dbi_dsr_exit(struct drm_device *dev)
 	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
 
 	if (dsr_info) {
-		del_timer_sync(&dsr_info->dsr_timer);
 		kfree(dsr_info);
 		dev_priv->dbi_dsr_info = NULL;
 	}
@@ -660,13 +574,13 @@ void mdfld_dsi_controller_dbi_init(struct mdfld_dsi_config *dsi_config,
 
 	dev_dbg(dev->dev, "Init DBI interface on pipe %d...\n", pipe);
 
-	/*un-ready device*/
+	/* Un-ready device */
 	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000000);
 
-	/*init dsi adapter before kicking off*/
+	/* Init dsi adapter before kicking off */
 	REG_WRITE((MIPIA_CONTROL_REG + reg_offset), 0x00000018);
 
-	/*TODO: figure out how to setup these registers*/
+	/* TODO: figure out how to setup these registers */
 	REG_WRITE((MIPIA_DPHY_PARAM_REG + reg_offset), 0x150c3408);
 	REG_WRITE((MIPIA_CLK_LANE_SWITCH_TIME_CNT_REG + reg_offset),
 							0x000a0014);
@@ -674,16 +588,16 @@ void mdfld_dsi_controller_dbi_init(struct mdfld_dsi_config *dsi_config,
 	REG_WRITE((MIPIA_DBI_FIFO_THROTTLE_REG + reg_offset), 0x00000001);
 	REG_WRITE((MIPIA_HS_LS_DBI_ENABLE_REG + reg_offset), 0x00000000);
 
-	/*enable all interrupts*/
+	/* Enable all interrupts */
 	REG_WRITE((MIPIA_INTR_EN_REG + reg_offset), 0xffffffff);
-	/*max value: 20 clock cycles of txclkesc*/
+	/* Max value: 20 clock cycles of txclkesc */
 	REG_WRITE((MIPIA_TURN_AROUND_TIMEOUT_REG + reg_offset), 0x0000001f);
-	/*min 21 txclkesc, max: ffffh*/
+	/* Min 21 txclkesc, max: ffffh */
 	REG_WRITE((MIPIA_DEVICE_RESET_TIMER_REG + reg_offset), 0x0000ffff);
-	/*min: 7d0 max: 4e20*/
+	/* Min: 7d0 max: 4e20 */
 	REG_WRITE((MIPIA_INIT_COUNT_REG + reg_offset), 0x00000fa0);
 
-	/*set up func_prg*/
+	/* Set up func_prg */
 	val |= lane_count;
 	val |= (dsi_config->channel_num << DSI_DBI_VIRT_CHANNEL_OFFSET);
 	val |= DSI_DBI_COLOR_FORMAT_OPTION2;
@@ -692,7 +606,7 @@ void mdfld_dsi_controller_dbi_init(struct mdfld_dsi_config *dsi_config,
 	REG_WRITE((MIPIA_HS_TX_TIMEOUT_REG + reg_offset), 0x3fffff);
 	REG_WRITE((MIPIA_LP_RX_TIMEOUT_REG + reg_offset), 0xffff);
 
-	/*de-assert dbi_stall when half of DBI FIFO is empty*/
+	/* De-assert dbi_stall when half of DBI FIFO is empty */
 	/* REG_WRITE((MIPIA_DBI_FIFO_THROTTLE_REG + reg_offset), 0x00000000); */
 
 	REG_WRITE((MIPIA_HIGH_LOW_SWITCH_COUNT_REG + reg_offset), 0x46);
@@ -718,42 +632,6 @@ static const struct drm_encoder_funcs mdfld_dsi_dbi_encoder_funcs = {
 
 #endif
 
-static int mdfld_dbi_panel_reset(struct mdfld_dsi_dbi_output *output)
-{
-	unsigned gpio;
-	int ret;
-
-	switch (output->channel_num) {
-	case 0:
-		gpio = 128;
-		break;
-	case 1:
-		gpio = 34;
-		break;
-	default:
-		pr_err("Invalid output\n");
-		return -EINVAL;
-	}
-
-	ret = gpio_request(gpio, "gfx");
-	if (ret) {
-		pr_err("gpio_rqueset failed\n");
-		return ret;
-	}
-
-	ret = gpio_direction_output(gpio, 1);
-	if (ret) {
-		pr_err("gpio_direction_output failed\n");
-		goto gpio_error;
-	}
-	gpio_get_value(128);
-gpio_error:
-	if (gpio_is_valid(gpio))
-		gpio_free(gpio);
-
-	return ret;
-}
-
 /*
  * Init DSI DBI encoder.
  * Allocate an mdfld_dsi_encoder and attach it to given @dsi_connector
@@ -776,13 +654,44 @@ struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
 #else
 	struct mdfld_dbi_dsr_info *dsr_info = dev_priv ? (dev_priv->dbi_dsr_info) : NULL;
 #endif
+	u32 data = 0;
+	int pipe;
 	int ret;
 
-	if (!pg || !dsi_connector) {
+	if (!pg || !dsi_connector || !p_funcs) {
 		WARN_ON(1);
 		return NULL;
 	}
 
+	dsi_config = mdfld_dsi_get_config(dsi_connector);
+	pipe = dsi_connector->pipe;
+
+	/*panel hard-reset*/
+	if (p_funcs->reset) {
+		ret = p_funcs->reset(pipe);
+		if (ret) {
+			DRM_ERROR("Panel %d hard-reset failed\n", pipe);
+			return NULL;
+		}
+	}
+	/* Panel drvIC init */
+	if (p_funcs->drv_ic_init)
+		p_funcs->drv_ic_init(dsi_config, pipe);
+
+	/* Panel power mode detect */
+	ret = mdfld_dsi_get_power_mode(dsi_config,
+				       &data,
+				       MDFLD_DSI_HS_TRANSMISSION);
+	if (ret) {
+		DRM_ERROR("Panel %d get power mode failed\n", pipe);
+		dsi_connector->status = connector_status_disconnected;
+	} else {
+		DRM_INFO("pipe %d power mode 0x%x\n", pipe, data);
+		dsi_connector->status = connector_status_connected;
+	}
+
+	/*TODO: get panel info from DDB*/
+
 	dbi_output = kzalloc(sizeof(struct mdfld_dsi_dbi_output), GFP_KERNEL);
 	if (!dbi_output) {
 		dev_err(dev->dev, "No memory\n");
@@ -802,23 +711,10 @@ struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
 
 	dbi_output->dev = dev;
 	dbi_output->p_funcs = p_funcs;
-
-	/*panel reset*/
-	ret = mdfld_dbi_panel_reset(dbi_output);
-	if (ret) {
-		dev_err(dev->dev, "reset panel error\n");
-		goto out_err1;
-	}
-
-	/*TODO: get panel info from DDB*/
-
-	/*get fixed mode*/
-	dsi_config = mdfld_dsi_get_config(dsi_connector);
 	fixed_mode = dsi_config->fixed_mode;
-
 	dbi_output->panel_fixed_mode = fixed_mode;
 
-	/*create drm encoder object*/
+	/* Create drm encoder object */
 	connector = &dsi_connector->base.base;
 	encoder = &dbi_output->base.base;
 	drm_encoder_init(dev,
@@ -827,10 +723,10 @@ struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
 			DRM_MODE_ENCODER_MIPI);
 	drm_encoder_helper_add(encoder, p_funcs->encoder_helper_funcs);
 
-	/*attach to given connector*/
+	/* Attach to given connector */
 	drm_mode_connector_attach_encoder(connector, encoder);
 
-	/*set possible crtcs and clones*/
+	/* Set possible CRTCs and clones */
 	if (dsi_connector->pipe) {
 		encoder->possible_crtcs = (1 << 2);
 		encoder->possible_clones = (1 << 1);
@@ -842,28 +738,31 @@ struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
 	dev_priv->dsr_fb_update = 0;
 	dev_priv->dsr_enable = false;
 	dev_priv->exit_idle = mdfld_dsi_dbi_exit_dsr;
-#if defined(CONFIG_MDFLD_DSI_DPU) || defined(CONFIG_MDFLD_DSI_DSR)
-	dev_priv->dsr_enable_config = false;
-#endif /*CONFIG_MDFLD_DSI_DSR*/
 
 	dbi_output->first_boot = true;
 	dbi_output->mode_flags = MODE_SETTING_IN_ENCODER;
 
 #ifdef CONFIG_MDFLD_DSI_DPU
-	/*add this output to dpu_info*/
-	if (dsi_connector->pipe == 0)
-		dpu_info->dbi_outputs[0] = dbi_output;
-	} else {
-		dpu_info->dbi_outputs[1] = dbi_output;
+	/* Add this output to dpu_info */
+	if (dsi_connector->status == connector_status_connected) {
+		if (dsi_connector->pipe == 0)
+			dpu_info->dbi_outputs[0] = dbi_output;
+		else
+			dpu_info->dbi_outputs[1] = dbi_output;
+
+		dpu_info->dbi_output_num++;
 	}
-	dpu_info->dbi_output_num++;
+
 #else /*CONFIG_MDFLD_DSI_DPU*/
-	/*add this output to dsr_info*/
-	if (dsi_connector->pipe == 0)
-		dsr_info->dbi_outputs[0] = dbi_output;
-	else
-		dsr_info->dbi_outputs[1] = dbi_output;
-	dsr_info->dbi_output_num++;
+	if (dsi_connector->status == connector_status_connected) {
+		/* Add this output to dsr_info */
+		if (dsi_connector->pipe == 0)
+			dsr_info->dbi_outputs[0] = dbi_output;
+		else
+			dsr_info->dbi_outputs[1] = dbi_output;
+
+		dsr_info->dbi_output_num++;
+	}
 #endif
 	return &dbi_output->base;
 out_err1:
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.h b/drivers/staging/gma500/mdfld_dsi_dbi.h
index a51e2f8..a2ec6fd 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.h
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.h
@@ -59,9 +59,6 @@ struct mdfld_dsi_dbi_output {
 	/* Backlight operations */
 
 	/* DSR timer */
-	spinlock_t dsr_timer_lock;
-	struct timer_list dsr_timer;
-	void(*dsi_timer_func)(unsigned long data);
 	u32 dsr_idle_count;
 	bool dsr_fb_update_done;
 
@@ -81,22 +78,11 @@ struct mdfld_dbi_dsr_info {
 	int dbi_output_num;
 	struct mdfld_dsi_dbi_output *dbi_outputs[2];
 
-	spinlock_t dsr_timer_lock;
-	struct timer_list dsr_timer;
 	u32 dsr_idle_count;
 };
 
 #define DBI_CB_TIMEOUT_COUNT	0xffff
 
-/* DCS commands */
-#define enter_sleep_mode	0x10
-#define exit_sleep_mode		0x11
-#define set_display_off		0x28
-#define	set_dispaly_on		0x29
-#define set_column_address	0x2a
-#define set_page_addr		0x2b
-#define write_mem_start		0x2c
-
 /* Offsets */
 #define CMD_MEM_ADDR_OFFSET	0
 
@@ -132,7 +118,7 @@ static inline int mdfld_dsi_dbi_cmd_sent(struct mdfld_dsi_dbi_output *dbi_output
 
 	/* Query the command execution status */
 	while (retry--)
-		if (!(REG_READ(MIPIA_CMD_ADD_REG + reg_offset) & (1 << 10)))
+		if (!(REG_READ(MIPIA_CMD_ADD_REG + reg_offset) & (1 << 0)))
 			break;
 
 	if (!retry) {
@@ -164,13 +150,11 @@ static inline int mdfld_dsi_dbi_cb_ready(struct mdfld_dsi_dbi_output *dbi_output
 
 extern void mdfld_dsi_dbi_output_init(struct drm_device *dev,
 			struct psb_intel_mode_device *mode_dev, int pipe);
-extern void mdfld_dsi_dbi_exit_dsr(struct drm_device *dev, u32 update_src,
-			void *p_surfaceAddr, bool check_hw_on_only);
+extern void mdfld_dsi_dbi_exit_dsr(struct drm_device *dev, u32 update_src);
 extern void mdfld_dsi_dbi_enter_dsr(struct mdfld_dsi_dbi_output *dbi_output,
 			int pipe);
 extern int mdfld_dbi_dsr_init(struct drm_device *dev);
 extern void mdfld_dbi_dsr_exit(struct drm_device *dev);
-extern void mdfld_dbi_dsr_timer_start(struct mdfld_dbi_dsr_info *dsr_info);
 extern struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
 			struct mdfld_dsi_connector *dsi_connector,
 			struct panel_funcs *p_funcs);
@@ -178,7 +162,6 @@ extern int mdfld_dsi_dbi_send_dcs(struct mdfld_dsi_dbi_output *dbi_output,
 			u8 dcs, u8 *param, u32 num, u8 data_src);
 extern int mdfld_dsi_dbi_update_area(struct mdfld_dsi_dbi_output *dbi_output,
 			u16 x1, u16 y1, u16 x2, u16 y2);
-extern void mdfld_dbi_dsr_timer_start(struct mdfld_dbi_dsr_info *dsr_info);
 extern int mdfld_dsi_dbi_update_power(struct mdfld_dsi_dbi_output *dbi_output,
 			int mode);
 extern void mdfld_dsi_controller_dbi_init(struct mdfld_dsi_config *dsi_config,
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi_dpu.h b/drivers/staging/gma500/mdfld_dsi_dbi_dpu.h
index 4ca9682..42367ed 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi_dpu.h
+++ b/drivers/staging/gma500/mdfld_dsi_dbi_dpu.h
@@ -90,9 +90,6 @@ static inline int mdfld_dpu_region_extent(struct psb_drm_dpu_rect *origin,
 {
 	int x1, y1, x2, y2;
 
-	/* PSB_DEBUG_ENTRY("rect (%d, %d, %d, %d)\n",
-		rect->x, rect->y, rect->width, rect->height); */
-
 	x1 = origin->x + origin->width;
 	y1 = origin->y + origin->height;
 
diff --git a/drivers/staging/gma500/mdfld_dsi_dpi.c b/drivers/staging/gma500/mdfld_dsi_dpi.c
index fce3c20..6e03a91 100644
--- a/drivers/staging/gma500/mdfld_dsi_dpi.c
+++ b/drivers/staging/gma500/mdfld_dsi_dpi.c
@@ -69,26 +69,6 @@ static void mdfld_wait_for_HS_CTRL_FIFO(struct drm_device *dev, u32 pipe)
 		dev_warn(dev->dev, "MIPI: HS CMD FIFO was never cleared!\n");
 }
 
-static void mdfld_wait_for_PIPEA_DISABLE(struct drm_device *dev, u32 pipe)
-{
-        u32 pipeconf_reg = PIPEACONF;
-        int timeout = 0;
-
-        if (pipe == 2)
-                pipeconf_reg = PIPECCONF;
-
-        udelay(500);
-
-        /* This will time out after approximately 2+ seconds */
-        while ((timeout < 20000) && (REG_READ(pipeconf_reg) & 0x40000000)) {
-                udelay(100);
-                timeout++;
-        }
-
-        if (timeout == 20000)
-                dev_warn(dev->dev, "MIPI: PIPE was not disabled!\n");
-}
-
 static void mdfld_wait_for_DPI_CTRL_FIFO(struct drm_device *dev, u32 pipe)
 {
 	u32 gen_fifo_stat_reg = MIPIA_GEN_FIFO_STAT_REG;
@@ -147,8 +127,6 @@ void mdfld_dsi_tpo_ic_init(struct mdfld_dsi_config *dsi_config, u32 pipe)
 	u32 gen_ctrl_reg = MIPIA_HS_GEN_CTRL_REG;
 	u32 gen_ctrl_val = GEN_LONG_WRITE;
 
-	dev_warn(dev->dev, "Enter mrst init TPO MIPI display.\n");
-
 	if (pipe == 2) {
 		gen_data_reg = HS_GEN_DATA_REG + MIPIC_REG_OFFSET; 
 		gen_ctrl_reg = HS_GEN_CTRL_REG + MIPIC_REG_OFFSET;
@@ -331,51 +309,8 @@ void mdfld_dsi_tpo_ic_init(struct mdfld_dsi_config *dsi_config, u32 pipe)
 	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x03 << WORD_COUNTS_POS));
 }
 
-/* ************************************************************************* *\
- * FUNCTION: mdfld_init_TMD_MIPI
- *
- * DESCRIPTION:  This function is called only by mrst_dsi_mode_set and
- *               restore_display_registers.  since this function does not
- *               acquire the mutex, it is important that the calling function
- *               does!
-\* ************************************************************************* */
-
-static u32 tmd_cmd_mcap_off[] = {0x000000b2};
-static u32 tmd_cmd_enable_lane_switch[] = {0x000101ef};
-static u32 tmd_cmd_set_lane_num[] = {0x006360ef};
-static u32 tmd_cmd_set_mode[] = {0x000000b3};
-static u32 tmd_cmd_set_sync_pulse_mode[] = {0x000961ef};
-static u32 tmd_cmd_set_video_mode[] = {0x00000153};
-static u32 tmd_cmd_enable_backlight[] = {0x00005ab4};//no auto_bl,need add in furtrue
-static u32 tmd_cmd_set_backlight_dimming[] = {0x00000ebd}; 
-
-void mdfld_dsi_tmd_drv_ic_init(struct mdfld_dsi_config *dsi_config, u32 pipe)
-{
-	struct mdfld_dsi_pkg_sender *sender = mdfld_dsi_get_pkg_sender(dsi_config);
-
-	if(!sender) {
-		WARN_ON(1);
-		return;
-	}
-
-	if(dsi_config->dvr_ic_inited)
-		return;
-
-	msleep(3);
-
-	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_mcap_off, 1, 0);
-	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_enable_lane_switch, 1, 0);
-	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_lane_num, 1, 0);
-	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_mode, 1, 0);
-	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_sync_pulse_mode, 1, 0);
-	/*TODO: set page and column here*/
-	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_video_mode, 1, 0);
-	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_enable_backlight, 1, 0);
-	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_backlight_dimming,1,0);
-	dsi_config->dvr_ic_inited = 1;
-}
-
-static u16 mdfld_dsi_dpi_to_byte_clock_count(int pixel_clock_count, int num_lane, int bpp)
+static u16 mdfld_dsi_dpi_to_byte_clock_count(int pixel_clock_count,
+						int num_lane, int bpp)
 {
 	return (u16)((pixel_clock_count * bpp) / (num_lane * 8)); 
 }
@@ -387,8 +322,8 @@ static u16 mdfld_dsi_dpi_to_byte_clock_count(int pixel_clock_count, int num_lane
  * use crtc mode values later 
  */
 int mdfld_dsi_dpi_timing_calculation(struct drm_display_mode *mode, 
-									struct mdfld_dsi_dpi_timing *dpi_timing,
-									int num_lane, int bpp)
+			struct mdfld_dsi_dpi_timing *dpi_timing,
+			int num_lane, int bpp)
 {
 	int pclk_hsync, pclk_hfp, pclk_hbp, pclk_hactive;
 	int pclk_vsync, pclk_vfp, pclk_vbp, pclk_vactive;
@@ -408,16 +343,6 @@ int mdfld_dsi_dpi_timing_calculation(struct drm_display_mode *mode,
 	pclk_vsync = mode->vsync_end - mode->vsync_start;
 	pclk_vbp = mode->vtotal - mode->vsync_end;
 
-#ifdef MIPI_DEBUG_LOG
-	printk(KERN_ALERT "[DISPLAY] %s: pclk_hactive = %d\n", __func__, pclk_hactive);
-	printk(KERN_ALERT "[DISPLAY] %s: pclk_hfp = %d\n", __func__, pclk_hfp);
-	printk(KERN_ALERT "[DISPLAY] %s: pclk_hsync = %d\n", __func__, pclk_hsync);
-	printk(KERN_ALERT "[DISPLAY] %s: pclk_hbp = %d\n", __func__, pclk_hbp);
-	printk(KERN_ALERT "[DISPLAY] %s: pclk_vactive = %d\n", __func__, pclk_vactive);
-	printk(KERN_ALERT "[DISPLAY] %s: pclk_vfp = %d\n", __func__, pclk_vfp);
-	printk(KERN_ALERT "[DISPLAY] %s: pclk_vsync = %d\n", __func__, pclk_vsync);
-	printk(KERN_ALERT "[DISPLAY] %s: pclk_vbp = %d\n", __func__, pclk_vbp);
-#endif
 	/*
 	 * byte clock counts were calculated by following formula
 	 * bclock_count = pclk_count * bpp / num_lane / 8
@@ -519,7 +444,6 @@ void mdfld_dsi_dpi_controller_init(struct mdfld_dsi_config *dsi_config, int pipe
 void mdfld_dsi_dpi_turn_on(struct mdfld_dsi_dpi_output *output, int pipe)
 {
 	struct drm_device *dev = output->dev;
-	/* struct drm_psb_private *dev_priv = dev->dev_private; */
 	u32 reg_offset = 0;
 	
 	if(output->panel_on) 
@@ -555,7 +479,6 @@ void mdfld_dsi_dpi_turn_on(struct mdfld_dsi_dpi_output *output, int pipe)
 static void mdfld_dsi_dpi_shut_down(struct mdfld_dsi_dpi_output *output, int pipe)
 {
 	struct drm_device *dev = output->dev;
-	/* struct drm_psb_private *dev_priv = dev->dev_private; */
 	u32 reg_offset = 0;
 	
 	/*if output is on, or mode setting didn't happen, ignore this*/
@@ -576,6 +499,7 @@ static void mdfld_dsi_dpi_shut_down(struct mdfld_dsi_dpi_output *output, int pip
 	}
 	
 	if(REG_READ(MIPIA_DPI_CONTROL_REG + reg_offset) == DSI_DPI_CTRL_HS_SHUTDOWN) {
+		dev_warn(dev->dev, "try to send the same package again, abort!");
 		goto shutdown_out;
 	}
 	
@@ -590,6 +514,14 @@ shutdown_out:
 	/* 	dev_priv->dpi_panel_on2 = false; */
 	/* else if (pipe == 0) */
 	/* 	dev_priv->dpi_panel_on = false;	 */
+	/* #ifdef CONFIG_PM_RUNTIME*/ 
+	/*	if (drm_psb_ospm && !enable_gfx_rtpm) { */
+	/*		pm_runtime_allow(&gpDrmDevice->pdev->dev); */
+	/*	schedule_delayed_work(&dev_priv->rtpm_work, 30 * 1000); */
+	/* } */
+	/*if (enable_gfx_rtpm) */
+	/*		pm_schedule_suspend(&dev->pdev->dev, gfxrtdelay); */
+	/* #endif */
 }
 
 void mdfld_dsi_dpi_set_power(struct drm_encoder *encoder, bool on)
@@ -616,7 +548,7 @@ void mdfld_dsi_dpi_set_power(struct drm_encoder *encoder, bool on)
 		if (mdfld_get_panel_type(dev, pipe) == TMD_VID){
  			mdfld_dsi_dpi_turn_on(dpi_output, pipe);
  		} else {
-			/*enable mipi port*/
+			/* Enable mipi port */
 			REG_WRITE(mipi_reg, (REG_READ(mipi_reg) | (1 << 31)));
 			REG_READ(mipi_reg);
 
@@ -636,7 +568,7 @@ void mdfld_dsi_dpi_set_power(struct drm_encoder *encoder, bool on)
  			mdfld_dsi_dpi_shut_down(dpi_output, pipe);
  		} else {
 			mdfld_dsi_dpi_shut_down(dpi_output, pipe);
-			/*disable mipi port*/
+			/* Disable mipi port */
 			REG_WRITE(mipi_reg, (REG_READ(mipi_reg) & ~(1<<31)));
 			REG_READ(mipi_reg);
 		}
@@ -656,8 +588,15 @@ void mdfld_dsi_dpi_dpms(struct drm_encoder *encoder, int mode)
 
 	if (mode == DRM_MODE_DPMS_ON)
 		mdfld_dsi_dpi_set_power(encoder, true);
-	else
+	else {
 		mdfld_dsi_dpi_set_power(encoder, false);
+#if 0 /* FIXME */
+#ifdef CONFIG_PM_RUNTIME
+		if (enable_gfx_rtpm)
+			pm_schedule_suspend(&gpDrmDevice->pdev->dev, gfxrtdelay);
+#endif
+#endif
+	}
 }
 
 bool mdfld_dsi_dpi_mode_fixup(struct drm_encoder *encoder,
@@ -694,77 +633,6 @@ void mdfld_dsi_dpi_commit(struct drm_encoder *encoder)
 	mdfld_dsi_dpi_set_power(encoder, true);
 }
 
-void dsi_debug_MIPI_reg(struct drm_device *dev)
-{
-	u32 temp_val = 0;
-
-	temp_val = REG_READ(MIPI);
-	printk(KERN_ALERT "[DISPLAY] MIPI = %x\n", temp_val);
-
-	/* set the lane speed */
-	temp_val = REG_READ(MIPI_CONTROL_REG);
-	printk(KERN_ALERT "[DISPLAY] MIPI_CONTROL_REG = %x\n", temp_val);
-
-	/* Enable all the error interrupt */
-	temp_val = REG_READ(INTR_EN_REG);
-	printk(KERN_ALERT "[DISPLAY] INTR_EN_REG = %x\n", temp_val);
-	temp_val = REG_READ(TURN_AROUND_TIMEOUT_REG);
-	printk(KERN_ALERT "[DISPLAY] TURN_AROUND_TIMEOUT_REG = %x\n", temp_val);
-	temp_val = REG_READ(DEVICE_RESET_REG);
-	printk(KERN_ALERT "[DISPLAY] DEVICE_RESET_REG = %x\n", temp_val);
-	temp_val = REG_READ(INIT_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] INIT_COUNT_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(DSI_FUNC_PRG_REG);
-	printk(KERN_ALERT "[DISPLAY] DSI_FUNC_PRG_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(DPI_RESOLUTION_REG);
-	printk(KERN_ALERT "[DISPLAY] DPI_RESOLUTION_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(VERT_SYNC_PAD_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] VERT_SYNC_PAD_COUNT_REG = %x\n", temp_val);
-	temp_val = REG_READ(VERT_BACK_PORCH_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] VERT_BACK_PORCH_COUNT_REG = %x\n", temp_val);
-	temp_val = REG_READ(VERT_FRONT_PORCH_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] VERT_FRONT_PORCH_COUNT_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(HORIZ_SYNC_PAD_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] HORIZ_SYNC_PAD_COUNT_REG = %x\n", temp_val);
-	temp_val = REG_READ(HORIZ_BACK_PORCH_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] HORIZ_BACK_PORCH_COUNT_REG = %x\n", temp_val);
-	temp_val = REG_READ(HORIZ_FRONT_PORCH_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] HORIZ_FRONT_PORCH_COUNT_REG = %x\n", temp_val);
-	temp_val = REG_READ(HORIZ_ACTIVE_AREA_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] HORIZ_ACTIVE_AREA_COUNT_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(VIDEO_FMT_REG);
-	printk(KERN_ALERT "[DISPLAY] VIDEO_FMT_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(HS_TX_TIMEOUT_REG);
-	printk(KERN_ALERT "[DISPLAY] HS_TX_TIMEOUT_REG = %x\n", temp_val);
-	temp_val = REG_READ(LP_RX_TIMEOUT_REG);
-	printk(KERN_ALERT "[DISPLAY] LP_RX_TIMEOUT_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(HIGH_LOW_SWITCH_COUNT_REG);
-	printk(KERN_ALERT "[DISPLAY] HIGH_LOW_SWITCH_COUNT_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(EOT_DISABLE_REG);
-	printk(KERN_ALERT "[DISPLAY] EOT_DISABLE_REG = %x\n", temp_val);
-
-	temp_val = REG_READ(LP_BYTECLK_REG);
-	printk(KERN_ALERT "[DISPLAY] LP_BYTECLK_REG = %x\n", temp_val);
-	temp_val = REG_READ(MAX_RET_PAK_REG);
-	printk(KERN_ALERT "[DISPLAY] MAX_RET_PAK_REG = %x\n", temp_val);
-	temp_val = REG_READ(DPI_CONTROL_REG);
-	printk(KERN_ALERT "[DISPLAY] DPI_CONTROL_REG = %x\n", temp_val);
-	temp_val = REG_READ(DPHY_PARAM_REG);
-	printk(KERN_ALERT "[DISPLAY] DPHY_PARAM_REG = %x\n", temp_val);
-//	temp_val = REG_READ(PIPEACONF);
-//	printk(KERN_INFO "[DISPLAY] PIPEACONF = %x\n", temp_val);
-//	temp_val = REG_READ(DSPACNTR);
-//	printk(KERN_INFO "[DISPLAY] DSPACNTR = %x\n", temp_val);
-}
-
 void mdfld_dsi_dpi_mode_set(struct drm_encoder *encoder,
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *adjusted_mode)
@@ -804,14 +672,11 @@ void mdfld_dsi_dpi_mode_set(struct drm_encoder *encoder,
 	REG_WRITE(mipi_reg, mipi);
 	REG_READ(mipi_reg);
 
-	/* Set up DSI controller DPI interface*/
+	/* Set up DSI controller DPI interface */
 	mdfld_dsi_dpi_controller_init(dsi_config, pipe);
 
-	if (mdfld_get_panel_type(dev, pipe) == TMD_VID) {
- 		/* init driver ic */
- 		mdfld_dsi_tmd_drv_ic_init(dsi_config, pipe);
-	} else {
-		/*turn on DPI interface*/
+	if (mdfld_get_panel_type(dev, pipe) != TMD_VID) {
+		/* Turn on DPI interface */
 		mdfld_dsi_dpi_turn_on(dpi_output, pipe);
 	}
 	
@@ -829,81 +694,15 @@ void mdfld_dsi_dpi_mode_set(struct drm_encoder *encoder,
 		REG_READ(MIPIA_INTR_STAT_REG + reg_offset),
 		dpi_output->panel_on);
 
-	if (mdfld_get_panel_type(dev, pipe) == TMD_VID) {
-		//mdfld_dsi_dpi_turn_on(dpi_output, pipe);
-	} else {
-		/* init driver ic */
+	if (mdfld_get_panel_type(dev, pipe) != TMD_VID) {
+		/* Init driver ic */
 		mdfld_dsi_tpo_ic_init(dsi_config, pipe);
-		/*init backlight*/
+		/* Init backlight */
 		mdfld_dsi_brightness_init(dsi_config, pipe);
 	}
-	
-#ifdef MIPI_DEBUG_LOG
-	dsi_debug_MIPI_reg(dev);
-#endif
 	gma_power_end(dev);
 }
 
-static int mdfld_dpi_panel_reset(int pipe)
-{
-	unsigned gpio;
-	int ret = 0;
-	
-	switch(pipe) {
-	case 0:
-		gpio = 128;
-		break;
-	case 2:
-		gpio = 34;
-		break;
-	default:
-		DRM_ERROR("Invalid output\n");
-		return -EINVAL;
-	}
-	
-	ret = gpio_request(gpio, "gfx");
-	if(ret) {
-		DRM_ERROR("gpio_rqueset failed\n");
-		return ret;
-	}
-	ret = gpio_direction_output(gpio, 1);
-	if(ret) {
-		DRM_ERROR("gpio_direction_output failed\n");
-		goto gpio_error;
-	}
-	
-	gpio_get_value(128);
-	
-gpio_error:
-	if(gpio_is_valid(gpio))
-		gpio_free(gpio);
-	return ret;
-}
-
-/**
- * Exit from DSR
- */
-void mdfld_dsi_dpi_exit_idle (struct drm_device *dev, u32 update_src, void *p_surfaceAddr, bool check_hw_on_only)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	if (!gma_power_begin(dev, true)) {
-		DRM_ERROR("hw begin failed\n");
-		return;
-	}
-
-	/* update the surface base address. */
-	if (p_surfaceAddr) {
-		REG_WRITE(DSPASURF, *((u32 *)p_surfaceAddr));
-#if defined(CONFIG_MDFD_DUAL_MIPI)
-		REG_WRITE(DSPCSURF, *((u32 *)p_surfaceAddr));
-#endif
-	}
-	mid_enable_pipe_event(dev_priv, 0);
-	psb_enable_pipestat(dev_priv, 0, PIPE_VBLANK_INTERRUPT_ENABLE);
-	dev_priv->is_in_idle = false;
-	dev_priv->dsr_idle_count = 0;
-}
 
 /*
  * Init DSI DPI encoder. 
@@ -912,40 +711,63 @@ void mdfld_dsi_dpi_exit_idle (struct drm_device *dev, u32 update_src, void *p_su
  */ 
 struct mdfld_dsi_encoder *mdfld_dsi_dpi_init(struct drm_device *dev, 
 				struct mdfld_dsi_connector *dsi_connector,
-				struct panel_funcs*p_funcs)
+				struct panel_funcs *p_funcs)
 {
-	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct mdfld_dsi_dpi_output *dpi_output = NULL;
 	struct mdfld_dsi_config *dsi_config;
 	struct drm_connector *connector = NULL;
 	struct drm_encoder *encoder = NULL;
 	struct drm_display_mode *fixed_mode = NULL;
+	int pipe;
+	u32 data;
 	int ret;
 
-	if (!dsi_connector) {
+	if (!dsi_connector || !p_funcs) {
 		WARN_ON(1);
 		return NULL;
 	}
 
+	dsi_config = mdfld_dsi_get_config(dsi_connector);
+	pipe = dsi_connector->pipe;
+
+	/* Panel hard-reset */
+	if (p_funcs->reset) {
+		ret = p_funcs->reset(pipe);
+		if (ret) {
+			DRM_ERROR("Panel %d hard-reset failed\n", pipe);
+			return NULL;
+		}
+	}
+
+	/* Panel drvIC init */
+	if (p_funcs->drv_ic_init)
+		p_funcs->drv_ic_init(dsi_config, pipe);
+
+	/* Panel power mode detect */
+	ret = mdfld_dsi_get_power_mode(dsi_config,
+					&data,
+					MDFLD_DSI_LP_TRANSMISSION);
+	if (ret) {
+		DRM_ERROR("Panel %d get power mode failed\n", pipe);
+		dsi_connector->status = connector_status_disconnected;
+	} else {
+		DRM_INFO("pipe %d power mode 0x%x\n", pipe, data);
+		dsi_connector->status = connector_status_connected;
+	}
+
 	dpi_output = kzalloc(sizeof(struct mdfld_dsi_dpi_output), GFP_KERNEL);
 	if(!dpi_output) {
 		dev_err(dev->dev, "No memory for dsi_dpi_output\n");
 		return NULL;
 	}
-	/* Panel reset */
-	ret = mdfld_dpi_panel_reset(dsi_connector->pipe);
-	if(ret) {
-		DRM_ERROR("reset panel error\n");
-		goto out_err1;
-	}
-	
+
 	if(dsi_connector->pipe) 
 		dpi_output->panel_on = 0;
-
+	else
 		dpi_output->panel_on = 0;
 	
-	
 	dpi_output->dev = dev;
+	dpi_output->p_funcs = p_funcs;
 	dpi_output->first_boot = 1;
 	
 	/* Get fixed mode */
@@ -973,19 +795,6 @@ struct mdfld_dsi_encoder *mdfld_dsi_dpi_init(struct drm_device *dev,
 		encoder->possible_crtcs = (1 << 0);
 		encoder->possible_clones = (1 << 0);
 	}
-
-	dev_priv->dsr_fb_update = 0;
-	dev_priv->dsr_enable = false;
-	dev_priv->exit_idle = mdfld_dsi_dpi_exit_idle;
-#if defined(CONFIG_MDFLD_DSI_DPU) || defined(CONFIG_MDFLD_DSI_DSR)
-	dev_priv->dsr_enable_config = true;
-#endif /*CONFIG_MDFLD_DSI_DSR*/
-
 	return &dpi_output->base;
-	
-out_err1: 
-	if(dpi_output)
-		kfree(dpi_output);
-	return NULL;	
 }
 
diff --git a/drivers/staging/gma500/mdfld_dsi_dpi.h b/drivers/staging/gma500/mdfld_dsi_dpi.h
index 68e65cc..ed92d45 100644
--- a/drivers/staging/gma500/mdfld_dsi_dpi.h
+++ b/drivers/staging/gma500/mdfld_dsi_dpi.h
@@ -47,6 +47,8 @@ struct mdfld_dsi_dpi_output {
 
 	int panel_on;
 	int first_boot;
+
+	struct panel_funcs *p_funcs;
 };
 
 #define MDFLD_DSI_DPI_OUTPUT(dsi_encoder) \
@@ -73,8 +75,4 @@ extern void mdfld_dsi_dpi_turn_on(struct mdfld_dsi_dpi_output *output,
 			int pipe);
 extern void mdfld_dsi_dpi_controller_init(struct mdfld_dsi_config *si_config,
 			int pipe);
-extern void mid_enable_pipe_event(struct drm_psb_private *dev_priv, int pipe);
-extern void psb_enable_pipestat(struct drm_psb_private *dev_priv, int pipe,
-			u32 mask);
-
 #endif /*__MDFLD_DSI_DPI_H__*/
diff --git a/drivers/staging/gma500/mdfld_dsi_output.c b/drivers/staging/gma500/mdfld_dsi_output.c
index ff75ece..3286c3d 100644
--- a/drivers/staging/gma500/mdfld_dsi_output.c
+++ b/drivers/staging/gma500/mdfld_dsi_output.c
@@ -35,55 +35,18 @@
 
 #define MDFLD_DSI_BRIGHTNESS_MAX_LEVEL 100
 
-/* get the CABC LABC from command line. */
 static int CABC_control = 1;
 static int LABC_control = 1;
 
-#ifdef MODULE
 module_param (CABC_control, int, 0644);
 module_param (LABC_control, int, 0644);
-#else
-static int __init parse_CABC_control(char *arg)
-{
-	/* CABC control can be passed in as a cmdline parameter */
-	/* to enable this feature add CABC=1 to cmdline */
-	/* to disable this feature add CABC=0 to cmdline */
-	if (!arg)
-		return -EINVAL;
-
-	if (!strcasecmp(arg, "0"))
-		CABC_control = 0;
-	else if (!strcasecmp (arg, "1"))
-		CABC_control = 1;
-
-	return 0;
-}
-early_param ("CABC", parse_CABC_control);
-
-static int __init parse_LABC_control(char *arg)
-{
-	/* LABC control can be passed in as a cmdline parameter */
-	/* to enable this feature add LABC=1 to cmdline */
-	/* to disable this feature add LABC=0 to cmdline */
-	if (!arg)
-		return -EINVAL;
-
-	if (!strcasecmp(arg, "0"))
-		LABC_control = 0;
-	else if (!strcasecmp (arg, "1"))
-		LABC_control = 1;
-
-	return 0;
-}
-early_param ("LABC", parse_LABC_control);
-#endif
 
 /**
  * make these MCS command global 
  * we don't need 'movl' everytime we send them.
  * FIXME: these datas were provided by OEM, we should get them from GCT.
  **/
-static u32 mdfld_dbi_mcs_hysteresis[] = {
+static const u32 mdfld_dbi_mcs_hysteresis[] = {
 	0x42000f57, 0x8c006400, 0xff00bf00, 0xffffffff,
 	0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff,
 	0x38000aff, 0x82005000, 0xff00ab00, 0xffffffff,
@@ -91,25 +54,26 @@ static u32 mdfld_dbi_mcs_hysteresis[] = {
 	0x000000ff,
 };
 
-static u32 mdfld_dbi_mcs_display_profile[] = {
+static const u32 mdfld_dbi_mcs_display_profile[] = {
 	0x50281450, 0x0000c882, 0x00000000, 0x00000000,
 	0x00000000,
 };
 
-static u32 mdfld_dbi_mcs_kbbc_profile[] = {
+static const u32 mdfld_dbi_mcs_kbbc_profile[] = {
 	0x00ffcc60, 0x00000000, 0x00000000, 0x00000000,
 }; 
 	
-static u32 mdfld_dbi_mcs_gamma_profile[] = {
+static const u32 mdfld_dbi_mcs_gamma_profile[] = {
 	0x81111158, 0x88888888, 0x88888888,
 }; 
 
 /*
  * write hysteresis values.
  */
-static void mdfld_dsi_write_hysteresis (struct mdfld_dsi_config * dsi_config, int pipe)
+static void mdfld_dsi_write_hysteresis (struct mdfld_dsi_config *dsi_config,
+                                                                int pipe)
 {
-	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+	struct mdfld_dsi_pkg_sender *sender = mdfld_dsi_get_pkg_sender(dsi_config);
 
 	if(!sender) {
 	        WARN_ON(1);
@@ -124,9 +88,9 @@ static void mdfld_dsi_write_hysteresis (struct mdfld_dsi_config * dsi_config, in
 /*
  * write display profile values.
  */
-static void mdfld_dsi_write_display_profile (struct mdfld_dsi_config * dsi_config, int pipe)
+static void mdfld_dsi_write_display_profile(struct mdfld_dsi_config *dsi_config, int pipe)
 {
-	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+	struct mdfld_dsi_pkg_sender *sender = mdfld_dsi_get_pkg_sender(dsi_config);
 
 	if(!sender) {
 	        WARN_ON(1);
@@ -143,7 +107,7 @@ static void mdfld_dsi_write_display_profile (struct mdfld_dsi_config * dsi_confi
  */
 static void mdfld_dsi_write_kbbc_profile (struct mdfld_dsi_config * dsi_config, int pipe)
 {
-	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+	struct mdfld_dsi_pkg_sender *sender = mdfld_dsi_get_pkg_sender(dsi_config);
 
 	if(!sender) {
 	        WARN_ON(1);
@@ -155,12 +119,12 @@ static void mdfld_dsi_write_kbbc_profile (struct mdfld_dsi_config * dsi_config,
 				   MDFLD_DSI_SEND_PACKAGE);
 }
 
-/**
+/*
  * write gamma setting.
  */
-static void mdfld_dsi_write_gamma_setting (struct mdfld_dsi_config * dsi_config, int pipe)
+static void mdfld_dsi_write_gamma_setting (struct mdfld_dsi_config *dsi_config, int pipe)
 {
-	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+	struct mdfld_dsi_pkg_sender *sender = mdfld_dsi_get_pkg_sender(dsi_config);
 
 	if(!sender) {
 	        WARN_ON(1);
@@ -172,7 +136,7 @@ static void mdfld_dsi_write_gamma_setting (struct mdfld_dsi_config * dsi_config,
 				   MDFLD_DSI_SEND_PACKAGE);
 }
 
-/**
+/*
  * Check and see if the generic control or data buffer is empty and ready.
  */
 void mdfld_dsi_gen_fifo_ready (struct drm_device *dev, u32 gen_fifo_stat_reg, u32 fifo_stat)
@@ -193,16 +157,16 @@ void mdfld_dsi_gen_fifo_ready (struct drm_device *dev, u32 gen_fifo_stat_reg, u3
                                                 gen_fifo_stat_reg);
 }
 
-/**
+/*
  * Manage the DSI MIPI keyboard and display brightness.
  * FIXME: this is exported to OSPM code. should work out an specific 
  * display interface to OSPM. 
  */
-void mdfld_dsi_brightness_init (struct mdfld_dsi_config * dsi_config, int pipe)
+void mdfld_dsi_brightness_init(struct mdfld_dsi_config *dsi_config, int pipe)
 {
-	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
-	struct drm_device * dev = sender->dev;
-	struct drm_psb_private * dev_priv = dev->dev_private;
+	struct mdfld_dsi_pkg_sender *sender = mdfld_dsi_get_pkg_sender(dsi_config);
+	struct drm_device *dev = sender->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 gen_ctrl_val;
 	
 	if(!sender) {
@@ -223,7 +187,7 @@ void mdfld_dsi_brightness_init (struct mdfld_dsi_config * dsi_config, int pipe)
 				    1,
 				    MDFLD_DSI_SEND_PACKAGE);
 
-	mdfld_dsi_write_hysteresis (dsi_config, pipe);
+	mdfld_dsi_write_hysteresis(dsi_config, pipe);
 	mdfld_dsi_write_display_profile (dsi_config, pipe);
 	mdfld_dsi_write_kbbc_profile (dsi_config, pipe);
 	mdfld_dsi_write_gamma_setting (dsi_config, pipe);
@@ -253,7 +217,7 @@ void mdfld_dsi_brightness_init (struct mdfld_dsi_config * dsi_config, int pipe)
 				    MDFLD_DSI_SEND_PACKAGE);
 }
 
-/**
+/*
  * Manage the mipi display brightness.
  * TODO: refine this interface later
  */
@@ -262,8 +226,8 @@ void mdfld_dsi_brightness_control(struct drm_device *dev, int pipe, int level)
 	struct mdfld_dsi_pkg_sender *sender;
 	struct drm_psb_private *dev_priv;
 	struct mdfld_dsi_config *dsi_config;
-	u32 gen_ctrl_val = 0;
-	int p_type = TMD_VID;	
+	u32 gen_ctrl_val;
+	int p_type;	
 	
 	if (!dev || (pipe != 0 && pipe != 2)) {
 		dev_err(dev->dev, "Invalid parameter\n");
@@ -288,7 +252,8 @@ void mdfld_dsi_brightness_control(struct drm_device *dev, int pipe, int level)
 
 	gen_ctrl_val = ((level * 0xff) / MDFLD_DSI_BRIGHTNESS_MAX_LEVEL) & 0xff;
 
-	dev_dbg(dev->dev, "pipe = %d, gen_ctrl_val = %d.  \n", pipe, gen_ctrl_val);
+	dev_dbg(dev->dev,
+                "pipe = %d, gen_ctrl_val = %d.  \n", pipe, gen_ctrl_val);
 	
 	if(p_type == TMD_VID || p_type == TMD_CMD){
 		/* Set display backlight value */
@@ -344,7 +309,7 @@ void mdfld_dsi_controller_shutdown(struct mdfld_dsi_config * dsi_config, int pip
 	if(!(REG_READ(MIPIA_DEVICE_READY_REG + reg_offset) &  DSI_DEVICE_READY)) 
 		goto shutdown_out;
 	
-	/*send shut down package, clean packet send bit first*/
+	/* Send shut down package, clean packet send bit first */
 	if(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) & DSI_INTR_STATE_SPL_PKG_SENT) {
 		REG_WRITE((MIPIA_INTR_STAT_REG + reg_offset), 
 				(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) | DSI_INTR_STATE_SPL_PKG_SENT));
@@ -432,6 +397,53 @@ startup_out:
 	gma_power_end(dev);
 }
 
+
+static int mdfld_dsi_get_panel_status(struct mdfld_dsi_config *dsi_config,
+					u8 dcs,
+					u32 *data,
+					u8 transmission)
+{
+	struct mdfld_dsi_pkg_sender *sender
+		= mdfld_dsi_get_pkg_sender(dsi_config);
+
+	if (!sender || !data) {
+		DRM_ERROR("Invalid parameter\n");
+		return -EINVAL;
+	}
+
+	if (transmission == MDFLD_DSI_HS_TRANSMISSION)
+		return mdfld_dsi_read_mcs_hs(sender, dcs, data, 1);
+	else if (transmission == MDFLD_DSI_LP_TRANSMISSION)
+		return mdfld_dsi_read_mcs_lp(sender, dcs, data, 1);
+	else
+		return -EINVAL;
+}
+
+int mdfld_dsi_get_power_mode(struct mdfld_dsi_config *dsi_config,
+				u32 *mode,
+				u8 transmission)
+{
+	if (!dsi_config || !mode) {
+		DRM_ERROR("Invalid parameter\n");
+		return -EINVAL;
+	}
+
+	return mdfld_dsi_get_panel_status(dsi_config, 0x0a, mode, transmission);
+}
+
+int mdfld_dsi_get_diagnostic_result(struct mdfld_dsi_config *dsi_config,
+					u32 *result,
+					u8 transmission)
+{
+	if (!dsi_config || !result) {
+		DRM_ERROR("Invalid parameter\n");
+		return -EINVAL;
+	}
+
+	return mdfld_dsi_get_panel_status(dsi_config, 0x0f, result,
+					  transmission);
+}
+
 /*
  * NOTE: this function was used by OSPM.
  * TODO: will be removed later, should work out display interfaces for OSPM
@@ -459,14 +471,18 @@ static void mdfld_dsi_connector_restore(struct drm_connector * connector)
 
 static enum drm_connector_status mdfld_dsi_connector_detect(struct drm_connector * connector, bool force)
 {
-	return connector_status_connected;
+	struct psb_intel_output *psb_output
+					= to_psb_intel_output(connector);
+	struct mdfld_dsi_connector *dsi_connector
+	                                = MDFLD_DSI_CONNECTOR(psb_output);
+	return dsi_connector->status;
 }
 
-static int mdfld_dsi_connector_set_property(struct drm_connector * connector,
-											struct drm_property * property,
-											uint64_t value)
+static int mdfld_dsi_connector_set_property(struct drm_connector *connector,
+					struct drm_property *property,
+					uint64_t value)
 {
-	struct drm_encoder * encoder = connector->encoder;
+	struct drm_encoder *encoder = connector->encoder;
 
 	if (!strcmp(property->name, "scaling mode") && encoder) {
 		struct psb_intel_crtc * psb_crtc = to_psb_intel_crtc(encoder->crtc);
@@ -633,9 +649,12 @@ static void mdfld_dsi_connector_dpms(struct drm_connector *connector, int mode)
 	}
 
 	/* Then check all display panels + monitors status */
+	/* Make sure that the Display (B) sub-system status isn't i3 when
+	 * R/W the DC register, otherwise "Fabric error" issue would occur
+	 * during S0i3 state. */
 	if(!panel_on && !panel_on2 && !(REG_READ(HDMIB_CONTROL)
 	                                        & HDMIB_PORT_EN)) {
-		/*request rpm idle*/
+		/* Request rpm idle */
 		if(dev_priv->rpm_enabled)
 			pm_request_idle(&dev->pdev->dev);
 	}
@@ -652,8 +671,8 @@ static void mdfld_dsi_connector_dpms(struct drm_connector *connector, int mode)
 #endif
 }
 
-static struct drm_encoder * mdfld_dsi_connector_best_encoder(
-                                        struct drm_connector * connector) 
+static struct drm_encoder *mdfld_dsi_connector_best_encoder(
+                                        struct drm_connector *connector) 
 {
 	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
 	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
@@ -755,16 +774,6 @@ mdfld_dsi_get_configuration_mode(struct mdfld_dsi_config * dsi_config, int pipe)
 		mode->vtotal = mode->vdisplay + \
 				((ti->vblank_hi << 8) | ti->vblank_lo);
 		mode->clock = ti->pixel_clock * 10;
-
-		dev_dbg(dev->dev, "hdisplay is %d\n", mode->hdisplay);
-		dev_dbg(dev->dev, "vdisplay is %d\n", mode->vdisplay);
-		dev_dbg(dev->dev, "HSS is %d\n", mode->hsync_start);
-		dev_dbg(dev->dev, "HSE is %d\n", mode->hsync_end);
-		dev_dbg(dev->dev, "htotal is %d\n", mode->htotal);
-		dev_dbg(dev->dev, "VSS is %d\n", mode->vsync_start);
-		dev_dbg(dev->dev, "VSE is %d\n", mode->vsync_end);
-		dev_dbg(dev->dev, "vtotal is %d\n", mode->vtotal);
-		dev_dbg(dev->dev, "clock is %d\n", mode->clock);
 	} else {
 		if(dsi_config->type == MDFLD_DSI_ENCODER_DPI) { 
 			if (mdfld_get_panel_type(dev, pipe) == TMD_VID) {
@@ -810,6 +819,44 @@ mdfld_dsi_get_configuration_mode(struct mdfld_dsi_config * dsi_config, int pipe)
 	return mode;
 }
 
+int mdfld_dsi_panel_reset(int pipe)
+{
+	unsigned gpio;
+	int ret = 0;
+
+	switch (pipe) {
+	case 0:
+		gpio = 128;
+		break;
+	case 2:
+		gpio = 34;
+		break;
+	default:
+		DRM_ERROR("Invalid output\n");
+		return -EINVAL;
+	}
+
+	ret = gpio_request(gpio, "gfx");
+	if (ret) {
+		DRM_ERROR("gpio_rqueset failed\n");
+		return ret;
+	}
+
+	ret = gpio_direction_output(gpio, 1);
+	if (ret) {
+		DRM_ERROR("gpio_direction_output failed\n");
+		goto gpio_error;
+	}
+
+	gpio_get_value(128);
+
+gpio_error:
+	if (gpio_is_valid(gpio))
+		gpio_free(gpio);
+
+	return ret;
+}
+
 /*
  * MIPI output init
  * @dev drm device
@@ -819,9 +866,9 @@ mdfld_dsi_get_configuration_mode(struct mdfld_dsi_config * dsi_config, int pipe)
  * Do the initialization of a MIPI output, including create DRM mode objects
  * initialization of DSI output on @pipe 
  */
-void mdfld_dsi_output_init(struct drm_device * dev,
+void mdfld_dsi_output_init(struct drm_device *dev,
 			   int pipe, 
-			   struct mdfld_dsi_config * config,
+			   struct mdfld_dsi_config *config,
 			   struct panel_funcs* p_cmd_funcs,
 			   struct panel_funcs* p_vid_funcs)
 {
@@ -869,7 +916,7 @@ void mdfld_dsi_output_init(struct drm_device * dev,
 	dsi_config->changed = 1;
 	dsi_config->dev = dev;
 	
-	/*init fixed mode basing on DSI config type*/
+	/* Init fixed mode basing on DSI config type */
 	if(dsi_config->type == MDFLD_DSI_ENCODER_DBI) {
 		dsi_config->fixed_mode = p_cmd_funcs->get_config_mode(dev);
 		if(p_cmd_funcs->get_panel_info(dev, pipe, &dsi_panel_info))
@@ -917,12 +964,18 @@ void mdfld_dsi_output_init(struct drm_device * dev,
 	connector->interlace_allowed = false;
 	connector->doublescan_allowed = false;
 	
-	/*attach properties*/
+	/* Attach properties */
 	drm_connector_attach_property(connector, dev->mode_config.scaling_mode_property, DRM_MODE_SCALE_FULLSCREEN);
 	drm_connector_attach_property(connector, dev_priv->backlight_property, MDFLD_DSI_BRIGHTNESS_MAX_LEVEL);
 
-	/*init DBI & DPI encoders*/
-	if(p_cmd_funcs) {
+	/* Init DSI package sender on this output */
+	if (mdfld_dsi_pkg_sender_init(dsi_connector, pipe)) {
+		DRM_ERROR("Package Sender initialization failed on pipe %d\n", pipe);
+		goto dsi_init_err0;
+	}
+
+	/* Init DBI & DPI encoders */
+	if (p_cmd_funcs) {
 		encoder = mdfld_dsi_dbi_init(dev, dsi_connector, p_cmd_funcs);
 		if(!encoder) {
 			dev_err(dev->dev, "Create DBI encoder failed\n");
@@ -930,12 +983,6 @@ void mdfld_dsi_output_init(struct drm_device * dev,
 		}
 		encoder->private = dsi_config;
 		dsi_config->encoders[MDFLD_DSI_ENCODER_DBI] = encoder;
-		if(pipe == 2)
-			dev_priv->encoder2 = encoder;
-	
-		if(pipe == 0)
-			dev_priv->encoder0 = encoder;
-			
 	}
 	
 	if(p_vid_funcs) {
@@ -946,31 +993,16 @@ void mdfld_dsi_output_init(struct drm_device * dev,
 		}
 		encoder->private = dsi_config;
 		dsi_config->encoders[MDFLD_DSI_ENCODER_DPI] = encoder;
-
-        if(pipe == 2)
-            dev_priv->encoder2 = encoder;
-
-		if(pipe == 0)
-            dev_priv->encoder0 = encoder;
 	}
 	
 	drm_sysfs_connector_add(connector);
-	
-	/*init DSI package sender on this output*/
-	if(mdfld_dsi_pkg_sender_init(dsi_connector, pipe)) {
-		dev_err(dev->dev, 
-		        "Package Sender initialization failed on pipe %d\n",
-		                                                pipe);
-		goto dsi_init_err2;
-	}
-
-	dev_dbg(dev->dev, "successfully\n");
 	return;
 	
 	/*TODO: add code to destroy outputs on error*/
-dsi_init_err2:
-	drm_sysfs_connector_remove(connector);
 dsi_init_err1:
+	/*destroy sender*/
+	mdfld_dsi_pkg_sender_destroy(dsi_connector->pkg_sender);
+
 	drm_connector_cleanup(connector);
 	kfree(dsi_config->fixed_mode);
 	kfree(dsi_config);
diff --git a/drivers/staging/gma500/mdfld_dsi_output.h b/drivers/staging/gma500/mdfld_dsi_output.h
index 4300f10..4699267 100644
--- a/drivers/staging/gma500/mdfld_dsi_output.h
+++ b/drivers/staging/gma500/mdfld_dsi_output.h
@@ -42,202 +42,6 @@
 
 #include <asm/mrst.h>
 
-#define DRM_MODE_ENCODER_MIPI  5
-
-/* Medfield DSI controller registers */
-
-#define MIPIA_DEVICE_READY_REG				0xb000
-#define MIPIA_INTR_STAT_REG				0xb004
-#define MIPIA_INTR_EN_REG				0xb008
-#define MIPIA_DSI_FUNC_PRG_REG				0xb00c
-#define MIPIA_HS_TX_TIMEOUT_REG				0xb010
-#define MIPIA_LP_RX_TIMEOUT_REG				0xb014
-#define MIPIA_TURN_AROUND_TIMEOUT_REG			0xb018
-#define MIPIA_DEVICE_RESET_TIMER_REG			0xb01c
-#define MIPIA_DPI_RESOLUTION_REG			0xb020
-#define MIPIA_DBI_FIFO_THROTTLE_REG			0xb024
-#define MIPIA_HSYNC_COUNT_REG				0xb028
-#define MIPIA_HBP_COUNT_REG				0xb02c
-#define MIPIA_HFP_COUNT_REG				0xb030
-#define MIPIA_HACTIVE_COUNT_REG				0xb034
-#define MIPIA_VSYNC_COUNT_REG				0xb038
-#define MIPIA_VBP_COUNT_REG				0xb03c
-#define MIPIA_VFP_COUNT_REG				0xb040
-#define MIPIA_HIGH_LOW_SWITCH_COUNT_REG			0xb044
-#define MIPIA_DPI_CONTROL_REG				0xb048
-#define MIPIA_DPI_DATA_REG				0xb04c
-#define MIPIA_INIT_COUNT_REG				0xb050
-#define MIPIA_MAX_RETURN_PACK_SIZE_REG			0xb054
-#define MIPIA_VIDEO_MODE_FORMAT_REG			0xb058
-#define MIPIA_EOT_DISABLE_REG				0xb05c
-#define MIPIA_LP_BYTECLK_REG				0xb060
-#define MIPIA_LP_GEN_DATA_REG				0xb064
-#define MIPIA_HS_GEN_DATA_REG				0xb068
-#define MIPIA_LP_GEN_CTRL_REG				0xb06c
-#define MIPIA_HS_GEN_CTRL_REG				0xb070
-#define MIPIA_GEN_FIFO_STAT_REG				0xb074
-#define MIPIA_HS_LS_DBI_ENABLE_REG			0xb078
-#define MIPIA_DPHY_PARAM_REG				0xb080
-#define MIPIA_DBI_BW_CTRL_REG				0xb084
-#define MIPIA_CLK_LANE_SWITCH_TIME_CNT_REG		0xb088
-
-#define DSI_DEVICE_READY				(0x1)
-#define DSI_POWER_STATE_ULPS_ENTER			(0x2 << 1)
-#define DSI_POWER_STATE_ULPS_EXIT			(0x1 << 1)
-#define DSI_POWER_STATE_ULPS_OFFSET			(0x1)
-
-
-#define DSI_ONE_DATA_LANE				(0x1)
-#define DSI_TWO_DATA_LANE				(0x2)
-#define DSI_THREE_DATA_LANE				(0X3)
-#define DSI_FOUR_DATA_LANE				(0x4)
-#define DSI_DPI_VIRT_CHANNEL_OFFSET			(0x3)
-#define DSI_DBI_VIRT_CHANNEL_OFFSET			(0x5)
-#define DSI_DPI_COLOR_FORMAT_RGB565			(0x01 << 7)
-#define DSI_DPI_COLOR_FORMAT_RGB666			(0x02 << 7)
-#define DSI_DPI_COLOR_FORMAT_RGB666_UNPACK		(0x03 << 7)
-#define DSI_DPI_COLOR_FORMAT_RGB888			(0x04 << 7)
-#define DSI_DBI_COLOR_FORMAT_OPTION2			(0x05 << 13)
-
-#define DSI_INTR_STATE_RXSOTERROR			1
-
-#define DSI_INTR_STATE_SPL_PKG_SENT			(1 << 30)
-#define DSI_INTR_STATE_TE				(1 << 31)
-
-#define DSI_HS_TX_TIMEOUT_MASK				(0xffffff)
-
-#define DSI_LP_RX_TIMEOUT_MASK				(0xffffff)
-
-#define DSI_TURN_AROUND_TIMEOUT_MASK			(0x3f)
-
-#define DSI_RESET_TIMER_MASK				(0xffff)
-
-#define DSI_DBI_FIFO_WM_HALF				(0x0)
-#define DSI_DBI_FIFO_WM_QUARTER				(0x1)
-#define DSI_DBI_FIFO_WM_LOW				(0x2)
-
-#define DSI_DPI_TIMING_MASK				(0xffff)
-
-#define DSI_INIT_TIMER_MASK				(0xffff)
-
-#define DSI_DBI_RETURN_PACK_SIZE_MASK			(0x3ff)
-
-#define DSI_LP_BYTECLK_MASK				(0x0ffff)
-
-#define DSI_HS_CTRL_GEN_SHORT_W0			(0x03)
-#define DSI_HS_CTRL_GEN_SHORT_W1			(0x13)
-#define DSI_HS_CTRL_GEN_SHORT_W2			(0x23)
-#define DSI_HS_CTRL_GEN_R0				(0x04)
-#define DSI_HS_CTRL_GEN_R1				(0x14)
-#define DSI_HS_CTRL_GEN_R2				(0x24)
-#define DSI_HS_CTRL_GEN_LONG_W				(0x29)
-#define DSI_HS_CTRL_MCS_SHORT_W0			(0x05)
-#define DSI_HS_CTRL_MCS_SHORT_W1			(0x15)
-#define DSI_HS_CTRL_MCS_R0				(0x06)
-#define DSI_HS_CTRL_MCS_LONG_W				(0x39)
-#define DSI_HS_CTRL_VC_OFFSET				(0x06)
-#define DSI_HS_CTRL_WC_OFFSET				(0x08)
-
-#define	DSI_FIFO_GEN_HS_DATA_FULL			(1 << 0)
-#define DSI_FIFO_GEN_HS_DATA_HALF_EMPTY			(1 << 1)
-#define DSI_FIFO_GEN_HS_DATA_EMPTY			(1 << 2)
-#define DSI_FIFO_GEN_LP_DATA_FULL			(1 << 8)
-#define DSI_FIFO_GEN_LP_DATA_HALF_EMPTY			(1 << 9)
-#define DSI_FIFO_GEN_LP_DATA_EMPTY			(1 << 10)
-#define DSI_FIFO_GEN_HS_CTRL_FULL			(1 << 16)
-#define DSI_FIFO_GEN_HS_CTRL_HALF_EMPTY			(1 << 17)
-#define DSI_FIFO_GEN_HS_CTRL_EMPTY			(1 << 18)
-#define DSI_FIFO_GEN_LP_CTRL_FULL			(1 << 24)
-#define DSI_FIFO_GEN_LP_CTRL_HALF_EMPTY			(1 << 25)
-#define DSI_FIFO_GEN_LP_CTRL_EMPTY			(1 << 26)
-#define DSI_FIFO_DBI_EMPTY				(1 << 27)
-#define DSI_FIFO_DPI_EMPTY				(1 << 28)
-
-#define DSI_DBI_HS_LP_SWITCH_MASK			(0x1)
-
-#define DSI_HS_LP_SWITCH_COUNTER_OFFSET			(0x0)
-#define DSI_LP_HS_SWITCH_COUNTER_OFFSET			(0x16)
-
-#define DSI_DPI_CTRL_HS_SHUTDOWN			(0x00000001)
-#define DSI_DPI_CTRL_HS_TURN_ON				(0x00000002)
-
-/* Medfield DSI adapter registers */
-#define MIPIA_CONTROL_REG				0xb104
-#define MIPIA_DATA_ADD_REG				0xb108
-#define MIPIA_DATA_LEN_REG				0xb10c
-#define MIPIA_CMD_ADD_REG				0xb110
-#define MIPIA_CMD_LEN_REG				0xb114
-
-enum {
-	MDFLD_DSI_ENCODER_DBI = 0,
-	MDFLD_DSI_ENCODER_DPI,
-};
-
-enum {
-	MDFLD_DSI_VIDEO_NON_BURST_MODE_SYNC_PULSE = 1,
-	MDFLD_DSI_VIDEO_NON_BURST_MODE_SYNC_EVENTS = 2,
-	MDFLD_DSI_VIDEO_BURST_MODE = 3,
-};
-
-#define DSI_DPI_COMPLETE_LAST_LINE			(1 << 2)
-#define DSI_DPI_DISABLE_BTA				(1 << 3)
-
-struct mdfld_dsi_connector_state {
-	u32 mipi_ctrl_reg;
-};
-
-struct mdfld_dsi_encoder_state {
-
-};
-
-struct mdfld_dsi_connector {
-	/*
-	 * This is ugly, but I have to use connector in it! :-(
-	 * FIXME: use drm_connector instead.
-	 */
-	struct psb_intel_output base;
-
-	int pipe;
-	void *private;
-	void *pkg_sender;
-};
-
-struct mdfld_dsi_encoder {
-	struct drm_encoder base;
-	void *private;
-};
-
-/*
- * DSI config, consists of one DSI connector, two DSI encoders.
- * DRM will pick up on DSI encoder basing on differents configs.
- */
-struct mdfld_dsi_config {
-	struct drm_device *dev;
-	struct drm_display_mode *fixed_mode;
-	struct drm_display_mode *mode;
-
-	struct mdfld_dsi_connector *connector;
-	struct mdfld_dsi_encoder *encoders[DRM_CONNECTOR_MAX_ENCODER];
-	struct mdfld_dsi_encoder *encoder;
-
-	int changed;
-
-	int bpp;
-	int type;
-	int lane_count;
-	/*Virtual channel number for this encoder*/
-	int channel_num;
-	/*video mode configure*/
-	int video_mode;
-
-	int dvr_ic_inited;
-};
-
-#define MDFLD_DSI_CONNECTOR(psb_output) \
-		(container_of(psb_output, struct mdfld_dsi_connector, base))
-
-#define MDFLD_DSI_ENCODER(encoder) \
-		(container_of(encoder, struct mdfld_dsi_encoder, base))
 
 static inline struct mdfld_dsi_config *
 	mdfld_dsi_get_config(struct mdfld_dsi_connector *connector)
@@ -323,5 +127,12 @@ extern void mdfld_dsi_output_init(struct drm_device *dev, int pipe,
 				struct panel_funcs *p_vid_funcs);
 extern void mdfld_dsi_controller_init(struct mdfld_dsi_config *dsi_config,
 				int pipe);
+extern int mdfld_dsi_get_power_mode(struct mdfld_dsi_config *dsi_config,
+				u32 *mode,
+				u8 transmission);
+extern int mdfld_dsi_get_diagnostic_result(struct mdfld_dsi_config *dsi_config,
+				u32 *result,
+				u8 transmission);
+extern int mdfld_dsi_panel_reset(int pipe);
 
 #endif /*__MDFLD_DSI_OUTPUT_H__*/
diff --git a/drivers/staging/gma500/mdfld_dsi_pkg_sender.c b/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
index 745d4ad..9b96a5c 100644
--- a/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
+++ b/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
@@ -29,8 +29,11 @@
 #include "mdfld_dsi_output.h"
 #include "mdfld_dsi_pkg_sender.h"
 #include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dpi.h"
 
-#define MDFLD_DSI_DBI_FIFO_TIMEOUT	100
+#define MDFLD_DSI_DBI_FIFO_TIMEOUT		100
+#define MDFLD_DSI_MAX_RETURN_PACKET_SIZE	512
+#define MDFLD_DSI_READ_MAX_COUNT		5000
 
 static const char * const dsi_errors[] = {
 	"RX SOT Error",
@@ -404,8 +407,10 @@ static int send_pkg_prepare(struct mdfld_dsi_pkg_sender *sender,
 	}
 
 	/* Wait for 120 milliseconds in case exit_sleep_mode just be sent */
-	if (cmd == enter_sleep_mode)
+	if (cmd == DCS_ENTER_SLEEP_MODE) {
+ 		/*TODO: replace it with msleep later*/
 		mdelay(120);
+	}
 	return 0;
 }
 
@@ -432,16 +437,18 @@ static int send_pkg_done(struct mdfld_dsi_pkg_sender *sender,
 	}
 
 	/* Update panel status */
-	if (cmd == enter_sleep_mode) {
+	if (cmd == DCS_ENTER_SLEEP_MODE) {
 		sender->panel_mode |= MDFLD_DSI_PANEL_MODE_SLEEP;
 		/*TODO: replace it with msleep later*/
 		mdelay(120);
-	} else if (cmd == exit_sleep_mode) {
+	} else if (cmd == DCS_EXIT_SLEEP_MODE) {
 		sender->panel_mode &= ~MDFLD_DSI_PANEL_MODE_SLEEP;
 		/*TODO: replace it with msleep later*/
 		mdelay(120);
-	}
-
+	} else if (unlikely(cmd == DCS_SOFT_RESET)) {
+		/*TODO: replace it with msleep later*/
+		mdelay(5);
+ 	}
 	sender->status = MDFLD_DSI_PKG_SENDER_FREE;
 	return 0;
 
@@ -470,6 +477,9 @@ static int do_send_pkg(struct mdfld_dsi_pkg_sender *sender,
 	case MDFLD_DSI_PKG_GEN_SHORT_WRITE_0:
 	case MDFLD_DSI_PKG_GEN_SHORT_WRITE_1:
 	case MDFLD_DSI_PKG_GEN_SHORT_WRITE_2:
+	case MDFLD_DSI_PKG_GEN_READ_0:
+	case MDFLD_DSI_PKG_GEN_READ_1:
+	case MDFLD_DSI_PKG_GEN_READ_2:
 		ret = send_gen_short_pkg(sender, pkg);
 		break;
 	case MDFLD_DSI_PKG_GEN_LONG_WRITE:
@@ -477,6 +487,7 @@ static int do_send_pkg(struct mdfld_dsi_pkg_sender *sender,
 		break;
 	case MDFLD_DSI_PKG_MCS_SHORT_WRITE_0:
 	case MDFLD_DSI_PKG_MCS_SHORT_WRITE_1:
+	case MDFLD_DSI_PKG_MCS_READ:
 		ret = send_mcs_short_pkg(sender, pkg);
 		break;
 	case MDFLD_DSI_PKG_MCS_LONG_WRITE:
@@ -548,6 +559,7 @@ static int mdfld_dbi_cb_init(struct mdfld_dsi_pkg_sender *sender,
 
 	switch (pipe) {
 	case 0:
+		/* FIXME: Doesn't this collide with stolen space ? */
 		phys = pg->gtt_phys_start - 0x1000;
 		break;
 	case 2:
@@ -735,6 +747,292 @@ static int mdfld_dsi_send_gen_long(struct mdfld_dsi_pkg_sender *sender,
 	return 0;
 }
 
+static int __read_panel_data(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg,
+				u32 *data,
+				u16 len)
+{
+	unsigned long flags;
+	struct drm_device *dev = sender->dev;
+	int i;
+	u32 gen_data_reg;
+	int retry = MDFLD_DSI_READ_MAX_COUNT;
+	u8 transmission = pkg->transmission_type;
+
+	/*
+	 * do reading.
+	 * 0) send out generic read request
+	 * 1) polling read data avail interrupt
+	 * 2) read data
+	 */
+	spin_lock_irqsave(&sender->lock, flags);
+
+	REG_WRITE(sender->mipi_intr_stat_reg, 1 << 29);
+
+	if ((REG_READ(sender->mipi_intr_stat_reg) & (1 << 29)))
+		DRM_ERROR("Can NOT clean read data valid interrupt\n");
+
+	/*send out read request*/
+	send_pkg(sender, pkg);
+
+	pkg_sender_put_pkg_locked(sender, pkg);
+
+	/*polling read data avail interrupt*/
+	while (retry && !(REG_READ(sender->mipi_intr_stat_reg) & (1 << 29))) {
+		udelay(100);
+		retry--;
+	}
+
+	if (!retry) {
+		spin_unlock_irqrestore(&sender->lock, flags);
+		return -ETIMEDOUT;
+	}
+
+	REG_WRITE(sender->mipi_intr_stat_reg, (1 << 29));
+
+	/*read data*/
+	if (transmission == MDFLD_DSI_HS_TRANSMISSION)
+		gen_data_reg = sender->mipi_hs_gen_data_reg;
+	else if (transmission == MDFLD_DSI_LP_TRANSMISSION)
+		gen_data_reg = sender->mipi_lp_gen_data_reg;
+	else {
+		DRM_ERROR("Unknown transmission");
+		spin_unlock_irqrestore(&sender->lock, flags);
+		return -EINVAL;
+	}
+
+	for (i=0; i<len; i++)
+		*(data + i) = REG_READ(gen_data_reg);
+
+ 	spin_unlock_irqrestore(&sender->lock, flags);
+ 
+	return 0;
+}
+
+static int mdfld_dsi_read_gen(struct mdfld_dsi_pkg_sender *sender,
+				u8 param0,
+				u8 param1,
+				u8 param_num,
+				u32 *data,
+				u16 len,
+				u8 transmission)
+{
+	struct mdfld_dsi_pkg *pkg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sender->lock, flags);
+
+	pkg = pkg_sender_get_pkg_locked(sender);
+
+	spin_unlock_irqrestore(&sender->lock,flags);
+
+	if (!pkg) {
+		dev_err(sender->dev->dev, "No pkg memory\n");
+		return -ENOMEM;
+	}
+
+	switch (param_num) {
+	case 0:
+		pkg->pkg_type = MDFLD_DSI_PKG_GEN_READ_0;
+		pkg->pkg.short_pkg.cmd = 0;
+		pkg->pkg.short_pkg.param = 0;
+		break;
+	case 1:
+		pkg->pkg_type = MDFLD_DSI_PKG_GEN_READ_1;
+		pkg->pkg.short_pkg.cmd = param0;
+		pkg->pkg.short_pkg.param = 0;
+		break;
+ 	case 2:
+		pkg->pkg_type = MDFLD_DSI_PKG_GEN_READ_2;
+		pkg->pkg.short_pkg.cmd = param0;
+		pkg->pkg.short_pkg.param = param1;
+		break;
+	}
+
+	pkg->transmission_type = transmission;
+
+	INIT_LIST_HEAD(&pkg->entry);
+
+	return __read_panel_data(sender, pkg, data, len);
+}
+ 
+static int mdfld_dsi_read_mcs(struct mdfld_dsi_pkg_sender *sender,
+				u8 cmd,
+				u32 *data,
+				u16 len,
+				u8 transmission)
+{
+	struct mdfld_dsi_pkg *pkg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sender->lock, flags);
+
+	pkg = pkg_sender_get_pkg_locked(sender);
+
+ 	spin_unlock_irqrestore(&sender->lock, flags);
+ 
+ 	if (!pkg) {
+		dev_err(sender->dev->dev, "No pkg memory\n");
+ 		return -ENOMEM;
+	}
+
+	pkg->pkg_type = MDFLD_DSI_PKG_MCS_READ;
+	pkg->pkg.short_pkg.cmd = cmd;
+	pkg->pkg.short_pkg.param = 0;
+
+	pkg->transmission_type = transmission;
+ 
+	INIT_LIST_HEAD(&pkg->entry);
+
+	return __read_panel_data(sender, pkg, data, len);
+}
+
+void dsi_controller_dbi_init(struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct drm_device * dev = dsi_config->dev;
+	u32 reg_offset = pipe ? MIPIC_REG_OFFSET : 0;
+	int lane_count = dsi_config->lane_count;
+	u32 val = 0;
+
+	/*un-ready device*/
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000000);
+
+	/*init dsi adapter before kicking off*/
+	REG_WRITE((MIPIA_CONTROL_REG + reg_offset), 0x00000018);
+
+	/*TODO: figure out how to setup these registers*/
+	REG_WRITE((MIPIA_DPHY_PARAM_REG + reg_offset), 0x150c3408);
+	REG_WRITE((MIPIA_CLK_LANE_SWITCH_TIME_CNT_REG + reg_offset), 0x000a0014);
+	REG_WRITE((MIPIA_DBI_BW_CTRL_REG + reg_offset), 0x00000400);
+	REG_WRITE((MIPIA_DBI_FIFO_THROTTLE_REG + reg_offset), 0x00000001);
+	REG_WRITE((MIPIA_HS_LS_DBI_ENABLE_REG + reg_offset), 0x00000000);
+
+	/*enable all interrupts*/
+	REG_WRITE((MIPIA_INTR_EN_REG + reg_offset), 0xffffffff);
+	/*max value: 20 clock cycles of txclkesc*/
+	REG_WRITE((MIPIA_TURN_AROUND_TIMEOUT_REG + reg_offset), 0x0000001f);
+	/*min 21 txclkesc, max: ffffh*/
+	REG_WRITE((MIPIA_DEVICE_RESET_TIMER_REG + reg_offset), 0x0000ffff);
+	/*min: 7d0 max: 4e20*/
+	REG_WRITE((MIPIA_INIT_COUNT_REG + reg_offset), 0x00000fa0);
+
+	/*set up max return packet size*/
+	REG_WRITE((MIPIA_MAX_RETURN_PACK_SIZE_REG + reg_offset),
+			MDFLD_DSI_MAX_RETURN_PACKET_SIZE);
+
+	/*set up func_prg*/
+	val |= lane_count;
+	val |= (dsi_config->channel_num << DSI_DBI_VIRT_CHANNEL_OFFSET);
+	val |= DSI_DBI_COLOR_FORMAT_OPTION2;
+	REG_WRITE((MIPIA_DSI_FUNC_PRG_REG + reg_offset), val);
+
+	REG_WRITE((MIPIA_HS_TX_TIMEOUT_REG + reg_offset), 0x3fffff);
+	REG_WRITE((MIPIA_LP_RX_TIMEOUT_REG + reg_offset), 0xffff);
+
+	REG_WRITE((MIPIA_HIGH_LOW_SWITCH_COUNT_REG + reg_offset), 0x46);
+	REG_WRITE((MIPIA_EOT_DISABLE_REG + reg_offset), 0x00000000);
+	REG_WRITE((MIPIA_LP_BYTECLK_REG + reg_offset), 0x00000004);
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000001);
+}
+
+void dsi_controller_dpi_init(struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct drm_device * dev = dsi_config->dev;
+	u32 reg_offset = pipe ? MIPIC_REG_OFFSET : 0;
+	int lane_count = dsi_config->lane_count;
+	struct mdfld_dsi_dpi_timing dpi_timing;
+	struct drm_display_mode * mode = dsi_config->mode;
+	u32 val = 0;
+
+	/*un-ready device*/
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000000);
+
+	/*init dsi adapter before kicking off*/
+	REG_WRITE((MIPIA_CONTROL_REG + reg_offset), 0x00000018);
+
+	/*enable all interrupts*/
+	REG_WRITE((MIPIA_INTR_EN_REG + reg_offset), 0xffffffff);
+
+	/*set up func_prg*/
+	val |= lane_count;
+	val |= dsi_config->channel_num << DSI_DPI_VIRT_CHANNEL_OFFSET;
+
+	switch(dsi_config->bpp) {
+	case 16:
+		val |= DSI_DPI_COLOR_FORMAT_RGB565;
+		break;
+	case 18:
+		val |= DSI_DPI_COLOR_FORMAT_RGB666;
+		break;
+	case 24:
+		val |= DSI_DPI_COLOR_FORMAT_RGB888;
+		break;
+	default:
+		DRM_ERROR("unsupported color format, bpp = %d\n", dsi_config->bpp);
+	}
+
+	REG_WRITE((MIPIA_DSI_FUNC_PRG_REG + reg_offset), val);
+
+	REG_WRITE((MIPIA_HS_TX_TIMEOUT_REG + reg_offset),
+			(mode->vtotal * mode->htotal * dsi_config->bpp / (8 * lane_count)) & DSI_HS_TX_TIMEOUT_MASK);
+	REG_WRITE((MIPIA_LP_RX_TIMEOUT_REG + reg_offset), 0xffff & DSI_LP_RX_TIMEOUT_MASK);
+
+	/*max value: 20 clock cycles of txclkesc*/
+	REG_WRITE((MIPIA_TURN_AROUND_TIMEOUT_REG + reg_offset), 0x14 & DSI_TURN_AROUND_TIMEOUT_MASK);
+
+	/*min 21 txclkesc, max: ffffh*/
+	REG_WRITE((MIPIA_DEVICE_RESET_TIMER_REG + reg_offset), 0xffff & DSI_RESET_TIMER_MASK);
+
+	REG_WRITE((MIPIA_DPI_RESOLUTION_REG + reg_offset), mode->vdisplay << 16 | mode->hdisplay);
+
+	/*set DPI timing registers*/
+	mdfld_dsi_dpi_timing_calculation(mode, &dpi_timing, dsi_config->lane_count, dsi_config->bpp);
+
+	REG_WRITE((MIPIA_HSYNC_COUNT_REG + reg_offset), dpi_timing.hsync_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_HBP_COUNT_REG + reg_offset), dpi_timing.hbp_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_HFP_COUNT_REG + reg_offset), dpi_timing.hfp_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_HACTIVE_COUNT_REG + reg_offset), dpi_timing.hactive_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_VSYNC_COUNT_REG + reg_offset), dpi_timing.vsync_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_VBP_COUNT_REG + reg_offset), dpi_timing.vbp_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_VFP_COUNT_REG + reg_offset), dpi_timing.vfp_count & DSI_DPI_TIMING_MASK);
+
+	REG_WRITE((MIPIA_HIGH_LOW_SWITCH_COUNT_REG + reg_offset), 0x46);
+
+	/*min: 7d0 max: 4e20*/
+	REG_WRITE((MIPIA_INIT_COUNT_REG + reg_offset), 0x000007d0);
+
+	/*set up video mode*/
+	val = dsi_config->video_mode | DSI_DPI_COMPLETE_LAST_LINE;
+	REG_WRITE((MIPIA_VIDEO_MODE_FORMAT_REG + reg_offset), val);
+
+	REG_WRITE((MIPIA_EOT_DISABLE_REG + reg_offset), 0x00000000);
+
+	REG_WRITE((MIPIA_LP_BYTECLK_REG + reg_offset), 0x00000004);
+
+	/*TODO: figure out how to setup these registers*/
+	REG_WRITE((MIPIA_DPHY_PARAM_REG + reg_offset), 0x150c3408);
+
+	REG_WRITE((MIPIA_CLK_LANE_SWITCH_TIME_CNT_REG + reg_offset), (0xa << 16) | 0x14);
+
+	/*set device ready*/
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000001);
+}
+
+static void dsi_controller_init(struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	if (!dsi_config || ((pipe != 0) && (pipe != 2))) {
+		DRM_ERROR("Invalid parameters\n");
+		return;
+	}
+
+	if (dsi_config->type == MDFLD_DSI_ENCODER_DPI)
+		dsi_controller_dpi_init(dsi_config, pipe);
+	else if (dsi_config->type == MDFLD_DSI_ENCODER_DBI)
+		dsi_controller_dbi_init(dsi_config, pipe);
+	else
+		DRM_ERROR("Bad DSI encoder type\n");
+}
+
 void mdfld_dsi_cmds_kick_out(struct mdfld_dsi_pkg_sender *sender)
 {
 	process_pkg_list(sender);
@@ -774,7 +1072,7 @@ int mdfld_dsi_send_dcs(struct mdfld_dsi_pkg_sender *sender,
 	 * If dcs is write_mem_start, send it directly using DSI adapter
 	 * interface
 	 */
-	if (dcs == write_mem_start) {
+	if (dcs == DCS_WRITE_MEM_START) {
 		if (!spin_trylock(&sender->lock))
 			return -EAGAIN;
 
@@ -944,6 +1242,69 @@ int mdfld_dsi_send_gen_long_lp(struct mdfld_dsi_pkg_sender *sender,
 					MDFLD_DSI_LP_TRANSMISSION, delay);
 }
 
+int mdfld_dsi_read_gen_hs(struct mdfld_dsi_pkg_sender *sender,
+			u8 param0,
+			u8 param1,
+			u8 param_num,
+			u32 *data,
+			u16 len)
+{
+	if (!sender || !data || param_num < 0 || param_num > 2
+		|| !data || !len) {
+		DRM_ERROR("Invalid parameters\n");
+		return -EINVAL;
+	}
+
+	return mdfld_dsi_read_gen(sender, param0, param1, param_num,
+				data, len, MDFLD_DSI_HS_TRANSMISSION);
+
+}
+
+int mdfld_dsi_read_gen_lp(struct mdfld_dsi_pkg_sender *sender,
+			u8 param0,
+			u8 param1,
+			u8 param_num,
+			u32 *data,
+			u16 len)
+{
+	if (!sender || !data || param_num < 0 || param_num > 2
+		|| !data || !len) {
+		DRM_ERROR("Invalid parameters\n");
+		return -EINVAL;
+	}
+
+	return mdfld_dsi_read_gen(sender, param0, param1, param_num,
+				data, len, MDFLD_DSI_LP_TRANSMISSION);
+}
+
+int mdfld_dsi_read_mcs_hs(struct mdfld_dsi_pkg_sender *sender,
+			u8 cmd,
+			u32 *data,
+			u16 len)
+{
+	if (!sender || !data || !len) {
+		DRM_ERROR("Invalid parameters\n");
+		return -EINVAL;
+	}
+
+	return mdfld_dsi_read_mcs(sender, cmd, data, len,
+				MDFLD_DSI_HS_TRANSMISSION);
+}
+
+int mdfld_dsi_read_mcs_lp(struct mdfld_dsi_pkg_sender *sender,
+			u8 cmd,
+			u32 *data,
+			u16 len)
+{
+	if (!sender || !data || !len) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	return mdfld_dsi_read_mcs(sender, cmd, data, len,
+				MDFLD_DSI_LP_TRANSMISSION);
+}
+ 
 int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
 								int pipe)
 {
@@ -956,6 +1317,7 @@ int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
 	struct psb_gtt *pg = &dev_priv->gtt;
 	int i;
 	struct mdfld_dsi_pkg *pkg, *tmp;
+	u32 mipi_val = 0;
 
 	if (!dsi_connector) {
 		WARN_ON(1);
@@ -1018,7 +1380,7 @@ int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
 		pkg_sender->pipeconf_reg = PIPECCONF;
 		pkg_sender->dsplinoff_reg = DSPCLINOFF;
 		pkg_sender->dspsurf_reg = DSPCSURF;
-		pkg_sender->pipestat_reg = 72024;
+		pkg_sender->pipestat_reg = PIPECSTAT;
 
 		pkg_sender->mipi_intr_stat_reg =
 				MIPIA_INTR_STAT_REG + MIPIC_REG_OFFSET;
@@ -1059,6 +1421,31 @@ int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
 		INIT_LIST_HEAD(&pkg->entry);
 		list_add_tail(&pkg->entry, &pkg_sender->free_list);
 	}
+
+	/*
+	 * For video mode, don't enable DPI timing output here,
+	 * will init the DPI timing output during mode setting.
+	 */
+	if (dsi_config->type == MDFLD_DSI_ENCODER_DPI)
+		mipi_val = PASS_FROM_SPHY_TO_AFE | SEL_FLOPPED_HSTX;
+	else if (dsi_config->type == MDFLD_DSI_ENCODER_DBI)
+		mipi_val = PASS_FROM_SPHY_TO_AFE | SEL_FLOPPED_HSTX
+			| TE_TRIGGER_GPIO_PIN;
+	else
+		DRM_ERROR("Bad DSI encoder type\n");
+
+	if (pipe == 0) {
+		mipi_val |= 0x2;
+		REG_WRITE(MIPI, mipi_val);
+		REG_READ(MIPI);
+	} else if (pipe == 2) {
+		REG_WRITE(MIPI_C, mipi_val);
+		REG_READ(MIPI_C);
+	}
+
+	/*do dsi controller init*/
+	dsi_controller_init(dsi_config, pipe);
+	
 	return 0;
 
 pkg_alloc_err:
diff --git a/drivers/staging/gma500/mdfld_dsi_pkg_sender.h b/drivers/staging/gma500/mdfld_dsi_pkg_sender.h
index 296b1ea..f24abc7 100644
--- a/drivers/staging/gma500/mdfld_dsi_pkg_sender.h
+++ b/drivers/staging/gma500/mdfld_dsi_pkg_sender.h
@@ -36,9 +36,13 @@ enum {
 	MDFLD_DSI_PKG_GEN_SHORT_WRITE_0 = 0x03,
 	MDFLD_DSI_PKG_GEN_SHORT_WRITE_1 = 0x13,
 	MDFLD_DSI_PKG_GEN_SHORT_WRITE_2 = 0x23,
+	MDFLD_DSI_PKG_GEN_READ_0 = 0x04,
+	MDFLD_DSI_PKG_GEN_READ_1 = 0x14,
+	MDFLD_DSI_PKG_GEN_READ_2 = 0x24,
 	MDFLD_DSI_PKG_GEN_LONG_WRITE = 0x29,
 	MDFLD_DSI_PKG_MCS_SHORT_WRITE_0 = 0x05,
 	MDFLD_DSI_PKG_MCS_SHORT_WRITE_1 = 0x15,
+	MDFLD_DSI_PKG_MCS_READ = 0x06,
 	MDFLD_DSI_PKG_MCS_LONG_WRITE = 0x39,
 };
 
@@ -132,6 +136,18 @@ struct mdfld_dsi_pkg_sender {
 	u32 mipi_cmd_len_reg;
 };
 
+/* DCS definitions */
+#define DCS_SOFT_RESET			0x01
+#define DCS_ENTER_SLEEP_MODE		0x10
+#define DCS_EXIT_SLEEP_MODE		0x11
+#define DCS_SET_DISPLAY_OFF		0x28
+#define DCS_SET_DISPLAY_ON		0x29
+#define DCS_SET_COLUMN_ADDRESS		0x2a
+#define DCS_SET_PAGE_ADDRESS		0x2b
+#define DCS_WRITE_MEM_START		0x2c
+#define DCS_SET_TEAR_OFF		0x34
+#define DCS_SET_TEAR_ON 		0x35
+
 extern int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
 			int pipe);
 extern void mdfld_dsi_pkg_sender_destroy(struct mdfld_dsi_pkg_sender *sender);
@@ -153,6 +169,16 @@ extern int mdfld_dsi_send_gen_long_hs(struct mdfld_dsi_pkg_sender *sender,
 			u32 *data, u32 len, int delay);
 extern int mdfld_dsi_send_gen_long_lp(struct mdfld_dsi_pkg_sender *sender,
 			u32 *data, u32 len, int delay);
+
+extern int mdfld_dsi_read_gen_hs(struct mdfld_dsi_pkg_sender *sender,
+			u8 param0, u8 param1, u8 param_num, u32 *data, u16 len);
+extern int mdfld_dsi_read_gen_lp(struct mdfld_dsi_pkg_sender *sender,
+			u8 param0, u8 param1, u8 param_num, u32 *data, u16 len);
+extern int mdfld_dsi_read_mcs_hs(struct mdfld_dsi_pkg_sender *sender,
+			u8 cmd, u32 *data, u16 len);
+extern int mdfld_dsi_read_mcs_lp(struct mdfld_dsi_pkg_sender *sender,
+			u8 cmd, u32 *data, u16 len);
+
 extern void mdfld_dsi_cmds_kick_out(struct mdfld_dsi_pkg_sender *sender);
 
 #endif /* __MDFLD_DSI_PKG_SENDER_H__ */
diff --git a/drivers/staging/gma500/mdfld_intel_display.c b/drivers/staging/gma500/mdfld_intel_display.c
index fa84990..ac74a8d 100644
--- a/drivers/staging/gma500/mdfld_intel_display.c
+++ b/drivers/staging/gma500/mdfld_intel_display.c
@@ -140,7 +140,6 @@ static int mdfld_intel_crtc_cursor_set(struct drm_crtc *crtc,
 				 uint32_t width, uint32_t height)
 {
 	struct drm_device *dev = crtc->dev;
-	struct drm_psb_private * dev_priv = (struct drm_psb_private *)dev->dev_private;
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	int pipe = psb_intel_crtc->pipe;
 	uint32_t control = CURACNTR;
@@ -263,7 +262,7 @@ static int mdfld_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 	case 0:
 #ifndef CONFIG_MDFLD_DSI_DPU
 		if (!(dev_priv->dsr_fb_update & MDFLD_DSR_CURSOR_0))
-			mdfld_dsi_dbi_exit_dsr (dev, MDFLD_DSR_CURSOR_0, 0, 0);
+			mdfld_dsi_dbi_exit_dsr (dev, MDFLD_DSR_CURSOR_0);
 #else /*CONFIG_MDFLD_DSI_DPU*/
 		rect.x = x;
 		rect.y = y;
@@ -279,7 +278,7 @@ static int mdfld_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 	case 2:
 #ifndef CONFIG_MDFLD_DSI_DPU
 		if (!(dev_priv->dsr_fb_update & MDFLD_DSR_CURSOR_2))
-			mdfld_dsi_dbi_exit_dsr (dev, MDFLD_DSR_CURSOR_2, 0, 0);
+			mdfld_dsi_dbi_exit_dsr (dev, MDFLD_DSR_CURSOR_2);
 #else /*CONFIG_MDFLD_DSI_DPU*/
 		mdfld_dbi_dpu_report_damage(dev, MDFLD_CURSORC, &rect);
 		mdfld_dpu_exit_dsr(dev);
@@ -354,7 +353,6 @@ int mdfld__intel_pipe_set_base(struct drm_crtc *crtc, int x, int y, struct drm_f
 	/* struct drm_i915_master_private *master_priv; */
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
-	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
 	int pipe = psb_intel_crtc->pipe;
 	unsigned long start, offset;
 	int dsplinoff = DSPALINOFF;
diff --git a/drivers/staging/gma500/mdfld_output.c b/drivers/staging/gma500/mdfld_output.c
index 7e11401..ffa2c1f 100644
--- a/drivers/staging/gma500/mdfld_output.c
+++ b/drivers/staging/gma500/mdfld_output.c
@@ -100,7 +100,6 @@ static int init_panel(struct drm_device *dev, int mipi_pipe, int p_type)
 		mdfld_dsi_output_init(dev, mipi_pipe, NULL, p_cmd_funcs, NULL);
 		break;
 	case PYR_VID:
-		/*pyr_vid_init(dev, p_vid_funcs); */
 		mdfld_dsi_output_init(dev, mipi_pipe, NULL, NULL, p_vid_funcs);
 		break;
 	case TPO:	/* TPO panel supports both cmd & vid interfaces */
@@ -135,10 +134,15 @@ int mdfld_output_init(struct drm_device *dev)
 	dev_info(dev->dev, "panel 1: type is %d\n", type);
 	init_panel(dev, 0, type);
 
+#ifdef CONFIG_MDFD_DUAL_MIPI
 	/* MIPI panel 2 */
 	type = mdfld_get_panel_type(dev, 2);
 	dev_info(dev->dev, "panel 2: type is %d\n", type);
 	init_panel(dev, 2, type);
-
+#endif
+#ifdef CONFIG_MDFD_HDMI
+	/* HDMI panel */
+	init_panel(dev, 0, HDMI);
+#endif
 	return 0;
 }
diff --git a/drivers/staging/gma500/mdfld_output.h b/drivers/staging/gma500/mdfld_output.h
index 70f2302a..e747fdb 100644
--- a/drivers/staging/gma500/mdfld_output.h
+++ b/drivers/staging/gma500/mdfld_output.h
@@ -28,47 +28,6 @@
 #ifndef MDFLD_OUTPUT_H
 #define MDFLD_OUTPUT_H
 
-#include "psb_drv.h"
-
-/* Panel types */
-enum {
-	TPO_CMD,
-	TPO_VID,
-	TMD_CMD,
-	TMD_VID,
-	PYR_CMD,
-	PYR_VID,
-	TPO,
-	TMD,
-	PYR,
-	HDMI,
-	GCT_DETECT
-};
-
-/* Junk that belongs elsewhere */
-#define TPO_PANEL_WIDTH		84
-#define TPO_PANEL_HEIGHT	46
-#define TMD_PANEL_WIDTH		39
-#define TMD_PANEL_HEIGHT	71
-#define PYR_PANEL_WIDTH		53
-#define PYR_PANEL_HEIGHT	95
-
-/* Panel interface */
-struct panel_info {
-	u32 width_mm;
-	u32 height_mm;
-};
-
-struct mdfld_dsi_dbi_output;
-
-struct panel_funcs {
-	const struct drm_encoder_funcs *encoder_funcs;
-	const struct drm_encoder_helper_funcs *encoder_helper_funcs;
-	struct drm_display_mode *(*get_config_mode) (struct drm_device *);
-	void (*update_fb) (struct mdfld_dsi_dbi_output *, int);
-	int (*get_panel_info) (struct drm_device *, int, struct panel_info *);
-};
-
 int mdfld_output_init(struct drm_device *dev);
 int mdfld_panel_dpi(struct drm_device *dev);
 int mdfld_get_panel_type(struct drm_device *dev, int pipe);
diff --git a/drivers/staging/gma500/mdfld_pyr_cmd.c b/drivers/staging/gma500/mdfld_pyr_cmd.c
index 0d89384..5f38e8d 100644
--- a/drivers/staging/gma500/mdfld_pyr_cmd.c
+++ b/drivers/staging/gma500/mdfld_pyr_cmd.c
@@ -188,7 +188,7 @@ static void pyr_dsi_controller_dbi_init(struct mdfld_dsi_config *dsi_config,
 
 	dev_dbg(dev->dev, "Init DBI interface on pipe %d...\n", pipe);
 
-	/* In-ready device */
+	/* Un-ready device */
 	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000000);
 
 	/* Init dsi adapter before kicking off */
@@ -394,25 +394,13 @@ static void pyr_dsi_dbi_dpms(struct drm_encoder *encoder, int mode)
 	struct mdfld_dsi_dbi_output *dbi_output =
 					MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
 	struct drm_device *dev = dbi_output->dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	static bool bdispoff;
 
 	dev_dbg(dev->dev, "%s\n",  (mode == DRM_MODE_DPMS_ON ? "on" : "off"));
 
-	if (mode == DRM_MODE_DPMS_ON) {
-		if (/*gbgfxsuspended && */bdispoff) {
-			bdispoff = false;
-			dev_priv->dispstatus = true;
-			/*gbgfxsuspended = false;
-			*/
-			mdfld_dsi_dbi_exit_dsr(dev, MDFLD_DSR_2D_3D, 0, 0);
-		}
+	if (mode == DRM_MODE_DPMS_ON)
 		pyr_dsi_dbi_set_power(encoder, true);
-	} else {
-		bdispoff = true;
-		dev_priv->dispstatus = false;
+	else
 		pyr_dsi_dbi_set_power(encoder, false);
-	}
 }
 
 /*
diff --git a/drivers/staging/gma500/mdfld_tmd_vid.c b/drivers/staging/gma500/mdfld_tmd_vid.c
index b29c905..affdc09 100644
--- a/drivers/staging/gma500/mdfld_tmd_vid.c
+++ b/drivers/staging/gma500/mdfld_tmd_vid.c
@@ -114,6 +114,66 @@ static int tmd_vid_get_panel_info(struct drm_device *dev,
 	return 0;
 }
 
+/*
+ *	mdfld_init_TMD_MIPI	-	initialise a TMD interface
+ *	@dsi_config: configuration
+ *	@pipe: pipe to configure
+ *
+ *	This function is called only by mrst_dsi_mode_set and
+ *	restore_display_registers.  since this function does not
+ *	acquire the mutex, it is important that the calling function
+ *	does!
+ */
+
+
+static void mdfld_dsi_tmd_drv_ic_init(struct mdfld_dsi_config *dsi_config,
+				      int pipe)
+{
+	static u32 tmd_cmd_mcap_off[] = {0x000000b2};
+	static u32 tmd_cmd_enable_lane_switch[] = {0x000101ef};
+	static u32 tmd_cmd_set_lane_num[] = {0x006360ef};
+	static u32 tmd_cmd_pushing_clock0[] = {0x00cc2fef};
+	static u32 tmd_cmd_pushing_clock1[] = {0x00dd6eef};
+	static u32 tmd_cmd_set_mode[] = {0x000000b3};
+	static u32 tmd_cmd_set_sync_pulse_mode[] = {0x000961ef};
+	static u32 tmd_cmd_set_column[] = {0x0100002a, 0x000000df};
+	static u32 tmd_cmd_set_page[] = {0x0300002b, 0x00000055};
+	static u32 tmd_cmd_set_video_mode[] = {0x00000153};
+	/*no auto_bl,need add in furture*/
+	static u32 tmd_cmd_enable_backlight[] = {0x00005ab4};
+	static u32 tmd_cmd_set_backlight_dimming[] = {0x00000ebd};
+
+	struct mdfld_dsi_pkg_sender *sender
+			= mdfld_dsi_get_pkg_sender(dsi_config);
+
+	DRM_INFO("Enter mdfld init TMD MIPI display.\n");
+
+	if (!sender) {
+		DRM_ERROR("Cannot get sender\n");
+		return;
+	}
+
+	if (dsi_config->dvr_ic_inited)
+		return;
+
+	msleep(3);
+
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_mcap_off, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_enable_lane_switch, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_lane_num, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_pushing_clock0, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_pushing_clock1, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_mode, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_sync_pulse_mode, 1, 0);
+	mdfld_dsi_send_mcs_long_lp(sender, tmd_cmd_set_column, 2, 0);
+	mdfld_dsi_send_mcs_long_lp(sender, tmd_cmd_set_page, 2, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_video_mode, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_enable_backlight, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_backlight_dimming, 1, 0);
+
+	dsi_config->dvr_ic_inited = 1;
+}
+
 /* TMD DPI encoder helper funcs */
 static const struct drm_encoder_helper_funcs
 					mdfld_tpo_dpi_encoder_helper_funcs = {
@@ -141,4 +201,6 @@ void tmd_vid_init(struct drm_device *dev, struct panel_funcs *p_funcs)
 	p_funcs->get_config_mode = &tmd_vid_get_config_mode;
 	p_funcs->update_fb = NULL;
 	p_funcs->get_panel_info = tmd_vid_get_panel_info;
+	p_funcs->reset = mdfld_dsi_panel_reset;
+	p_funcs->drv_ic_init = mdfld_dsi_tmd_drv_ic_init;
 }
diff --git a/drivers/staging/gma500/mdfld_tpo_cmd.c b/drivers/staging/gma500/mdfld_tpo_cmd.c
index d2e1818..4cf7647 100644
--- a/drivers/staging/gma500/mdfld_tpo_cmd.c
+++ b/drivers/staging/gma500/mdfld_tpo_cmd.c
@@ -126,11 +126,15 @@ static void mdfld_dsi_dbi_set_power(struct drm_encoder *encoder, bool on)
 	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
 	struct mdfld_dsi_dbi_output *dbi_output =
 				MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
-	/*struct drm_device *dev = dbi_output->dev;*/
+	struct mdfld_dsi_config *dsi_config =
+		mdfld_dsi_encoder_get_config(dsi_encoder);
+	struct mdfld_dsi_pkg_sender *sender =
+		mdfld_dsi_encoder_get_pkg_sender(dsi_encoder);
 	struct drm_device *dev = encoder->dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 reg_offset = 0;
 	int pipe = (dbi_output->channel_num == 0) ? 0 : 2;
+	u32 data = 0;
 
 	dev_dbg(dev->dev, "pipe %d : %s, panel on: %s\n",
 			pipe, on ? "On" : "Off",
@@ -190,9 +194,33 @@ static void mdfld_dsi_dbi_set_power(struct drm_encoder *encoder, bool on)
 		}
 	}
 
+	/*
+	 * FIXME: this is a WA for TPO panel crash on DPMS on & off around
+	 * 83 times. the root cause of this issue is that Booster in
+	 * drvIC crashed. Add this WA so that we can resume the driver IC
+	 * once we found that booster has a fault
+	 */
+	mdfld_dsi_get_power_mode(dsi_config,
+				&data,
+				MDFLD_DSI_HS_TRANSMISSION);
+
+	if (on && data && !(data & (1 << 7))) {
+		/* Soft reset */
+		mdfld_dsi_send_dcs(sender,
+				   DCS_SOFT_RESET,
+				   NULL,
+				   0,
+				   CMD_DATA_SRC_PIPE,
+				   MDFLD_DSI_SEND_PACKAGE);
+
+		/* Init drvIC */
+		if (dbi_output->p_funcs->drv_ic_init)
+			dbi_output->p_funcs->drv_ic_init(dsi_config,
+							 pipe);
+	}
+ 
 out_err:
 	gma_power_end(dev);
-
 	if (ret)
 		dev_err(dev->dev, "failed\n");
 }
@@ -253,14 +281,6 @@ static void mdfld_dsi_dbi_mode_set(struct drm_encoder *encoder,
 		return;
 	}
 
-	/* Set up pipe related registers */
-	REG_WRITE(mipi_reg, mipi_val);
-	REG_READ(mipi_reg);
-
-	mdfld_dsi_controller_dbi_init(dsi_config, pipe);
-
-	msleep(20);
-
 	REG_WRITE(dspcntr_reg, dspcntr_val);
 	REG_READ(dspcntr_reg);
 
@@ -268,7 +288,7 @@ static void mdfld_dsi_dbi_mode_set(struct drm_encoder *encoder,
 	msleep(20);
 
 	/* Send exit_sleep_mode DCS */
-	ret = mdfld_dsi_dbi_send_dcs(dsi_output, exit_sleep_mode,
+	ret = mdfld_dsi_dbi_send_dcs(dsi_output, DCS_EXIT_SLEEP_MODE,
 					NULL, 0, CMD_DATA_SRC_SYSTEM_MEM);
 	if (ret) {
 		dev_err(dev->dev, "sent exit_sleep_mode faild\n");
@@ -276,7 +296,7 @@ static void mdfld_dsi_dbi_mode_set(struct drm_encoder *encoder,
 	}
 
 	/* Send set_tear_on DCS */
-	ret = mdfld_dsi_dbi_send_dcs(dsi_output, set_tear_on,
+	ret = mdfld_dsi_dbi_send_dcs(dsi_output, DCS_SET_TEAR_ON,
 					&param, 1, CMD_DATA_SRC_SYSTEM_MEM);
 	if (ret) {
 		dev_err(dev->dev, "%s - sent set_tear_on faild\n", __func__);
@@ -284,11 +304,6 @@ static void mdfld_dsi_dbi_mode_set(struct drm_encoder *encoder,
 	}
 
 	/* Do some init stuff */
-	mdfld_dsi_brightness_init(dsi_config, pipe);
-
-	mdfld_dsi_gen_fifo_ready(dev, (MIPIA_GEN_FIFO_STAT_REG + reg_offset),
-				HS_CTRL_FIFO_EMPTY | HS_DATA_FIFO_EMPTY);
-
 	REG_WRITE(pipeconf_reg, pipeconf_val | PIPEACONF_DSR);
 	REG_READ(pipeconf_reg);
 
@@ -375,23 +390,24 @@ static void mdfld_dsi_dbi_dpms(struct drm_encoder *encoder, int mode)
 		 * if everything goes right, hw_begin will resume them all
 		 * during set_power.
 		 */
-		if (bdispoff)
-			mdfld_dsi_dbi_exit_dsr(dev, MDFLD_DSR_2D_3D, 0, 0);
+		if (bdispoff /* FIXME && gbgfxsuspended */) {
+			mdfld_dsi_dbi_exit_dsr(dev, MDFLD_DSR_2D_3D);
+			bdispoff = false;
+			dev_priv->dispstatus = true;
+		}
 
 		mdfld_dsi_dbi_set_power(encoder, true);
 		/* FIXME if (gbgfxsuspended)
 			gbgfxsuspended = false; */
-		bdispoff = false;
-		dev_priv->dispstatus = true;
 	} else {
 		/*
 		 * I am not sure whether this is the perfect place to
 		 * turn rpm on since we still have a lot of CRTC turnning
 		 * on work to do.
 		 */
-		mdfld_dsi_dbi_set_power(encoder, false);
 		bdispoff = true;
 		dev_priv->dispstatus = false;
+		mdfld_dsi_dbi_set_power(encoder, false);
 	}
 }
 
@@ -446,7 +462,7 @@ static void mdfld_dsi_dbi_update_fb(struct mdfld_dsi_dbi_output *dbi_output,
 	REG_READ(dspsurf_reg);
 
 	mdfld_dsi_send_dcs(sender,
-			   write_mem_start,
+			   DCS_WRITE_MEM_START,
 			   NULL,
 			   0,
 			   CMD_DATA_SRC_PIPE,
@@ -492,4 +508,6 @@ void tpo_cmd_init(struct drm_device *dev, struct panel_funcs *p_funcs)
 	p_funcs->get_config_mode = &tpo_cmd_get_config_mode;
 	p_funcs->update_fb = mdfld_dsi_dbi_update_fb;
 	p_funcs->get_panel_info = tpo_cmd_get_panel_info;
+	p_funcs->reset = mdfld_dsi_panel_reset;
+	p_funcs->drv_ic_init = mdfld_dsi_brightness_init;
 }
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 25fde4c..ac791c4 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -58,11 +58,11 @@ static void mrst_lvds_set_power(struct drm_device *dev,
 			pp_status = REG_READ(PP_STATUS);
 		} while ((pp_status & (PP_ON | PP_READY)) == PP_READY);
 		dev_priv->is_lvds_on = true;
-	        if (dev_priv->ops->lvds_bl_power)
-	                dev_priv->ops->lvds_bl_power(dev, true);
+		if (dev_priv->ops->lvds_bl_power)
+			dev_priv->ops->lvds_bl_power(dev, true);
 	} else {
-	        if (dev_priv->ops->lvds_bl_power)
-	                dev_priv->ops->lvds_bl_power(dev, false);
+		if (dev_priv->ops->lvds_bl_power)
+			dev_priv->ops->lvds_bl_power(dev, false);
 		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) &
 			  ~POWER_TARGET_ON);
 		do {
@@ -151,6 +151,7 @@ static void mrst_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct psb_intel_mode_device *mode_dev = output->mode_dev;
 
 	if (!gma_power_begin(dev, true))
 		return;
@@ -162,23 +163,43 @@ static void mrst_lvds_prepare(struct drm_encoder *encoder)
 	gma_power_end(dev);
 }
 
+static u32 mrst_lvds_get_max_backlight(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 ret;
+
+	if (gma_power_begin(dev, false)) {
+		ret = ((REG_READ(BLC_PWM_CTL) &
+			  BACKLIGHT_MODULATION_FREQ_MASK) >>
+			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
+
+		gma_power_end(dev);
+	} else
+		ret = ((dev_priv->saveBLC_PWM_CTL &
+			  BACKLIGHT_MODULATION_FREQ_MASK) >>
+			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
+
+	return ret;
+}
+
 static void mrst_lvds_commit(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct psb_intel_mode_device *mode_dev = output->mode_dev;
 
 	if (mode_dev->backlight_duty_cycle == 0)
 		mode_dev->backlight_duty_cycle =
-		    psb_intel_lvds_get_max_backlight(dev);
+					mrst_lvds_get_max_backlight(dev);
 	mrst_lvds_set_power(dev, output, true);
 }
 
 static const struct drm_encoder_helper_funcs mrst_lvds_helper_funcs = {
 	.dpms = mrst_lvds_dpms,
 	.mode_fixup = psb_intel_lvds_mode_fixup,
-	.prepare = mrst_intel_lvds_prepare,
+	.prepare = mrst_lvds_prepare,
 	.mode_set = mrst_lvds_mode_set,
-	.commit = mrst_intel_lvds_commit,
+	.commit = mrst_lvds_commit,
 };
 
 static struct drm_display_mode lvds_configuration_modes[] = {
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 194c64f..72f487a 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -31,6 +31,7 @@
 #include "gtt.h"
 #include "power.h"
 #include "mrst.h"
+#include "medfield.h"
 
 /* Append new drm mode definition here, align with libdrm definition */
 #define DRM_MODE_SCALE_NO_SCALE   	2
@@ -216,8 +217,8 @@ enum {
 #define MDFLD_DSR_OVERLAY_0 	(1 << 4)
 #define MDFLD_DSR_OVERLAY_2 	(1 << 5)
 #define MDFLD_DSR_MIPI_CONTROL	(1 << 6)
-#define MDFLD_DSR_DAMAGE_MASK_0	(1 << 0) | (1 << 2) | (1 << 4)
-#define MDFLD_DSR_DAMAGE_MASK_2	(1 << 1) | (1 << 3) | (1 << 5)
+#define MDFLD_DSR_DAMAGE_MASK_0	((1 << 0) | (1 << 2) | (1 << 4))
+#define MDFLD_DSR_DAMAGE_MASK_2	((1 << 1) | (1 << 3) | (1 << 5))
 #define MDFLD_DSR_2D_3D 	(MDFLD_DSR_2D_3D_0 | MDFLD_DSR_2D_3D_2)
 
 #define MDFLD_DSR_RR		45
@@ -605,7 +606,7 @@ struct drm_psb_private {
 	uint32_t dsr_idle_count;
 	bool is_in_idle;
 	bool dsr_enable;
-	void (*exit_idle)(struct drm_device *dev, u32 update_src, void *p_surfaceAddr, bool check_hw_on_only);
+	void (*exit_idle)(struct drm_device *dev, u32 update_src);
 
 	/* 2D acceleration */
 	struct mutex mutex_2d;

