Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1GHIxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:53:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40014 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1GHIxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:53:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/12] gma500: tidy up the CDV files
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:44:20 +0100
Message-ID: <20110708084413.19581.64011.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We are close to having PSB and CDV ready for moving from staging so it's
time to get the polish out.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/cdv_device.c        |   21 +++--
 drivers/staging/gma500/cdv_intel_crt.c     |   23 +++---
 drivers/staging/gma500/cdv_intel_display.c |  115 +++++++++++++---------------
 drivers/staging/gma500/cdv_intel_hdmi.c    |   80 ++++++++++---------
 drivers/staging/gma500/cdv_intel_lvds.c    |   20 +++--
 5 files changed, 133 insertions(+), 126 deletions(-)

diff --git a/drivers/staging/gma500/cdv_device.c b/drivers/staging/gma500/cdv_device.c
index 3729a97..87614e0 100644
--- a/drivers/staging/gma500/cdv_device.c
+++ b/drivers/staging/gma500/cdv_device.c
@@ -129,7 +129,6 @@ static int cdv_backlight_setup(struct drm_device *dev)
 
 static int cdv_set_brightness(struct backlight_device *bd)
 {
-	struct drm_device *dev = bl_get_data(cdv_backlight_device);
 	int level = bd->props.brightness;
 
 	/* Percentage 1-100% being valid */
@@ -188,9 +187,9 @@ static inline u32 CDV_MSG_READ32(uint port, uint offset)
 {
 	int mcr = (0x10<<24) | (port << 16) | (offset << 8);
 	uint32_t ret_val = 0;
-	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
-	pci_write_config_dword (pci_root, 0xD0, mcr);
-	pci_read_config_dword (pci_root, 0xD4, &ret_val);
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	pci_write_config_dword(pci_root, 0xD0, mcr);
+	pci_read_config_dword(pci_root, 0xD4, &ret_val);
 	pci_dev_put(pci_root);
 	return ret_val;
 }
@@ -198,9 +197,9 @@ static inline u32 CDV_MSG_READ32(uint port, uint offset)
 static inline void CDV_MSG_WRITE32(uint port, uint offset, u32 value)
 {
 	int mcr = (0x11<<24) | (port << 16) | (offset << 8) | 0xF0;
-	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
-	pci_write_config_dword (pci_root, 0xD4, value);
-	pci_write_config_dword (pci_root, 0xD0, mcr);
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	pci_write_config_dword(pci_root, 0xD4, value);
+	pci_write_config_dword(pci_root, 0xD0, mcr);
 	pci_dev_put(pci_root);
 }
 
@@ -218,8 +217,10 @@ static void cdv_init_pm(struct drm_device *dev)
 	u32 pwr_cnt;
 	int i;
 
-	dev_priv->apm_base = CDV_MSG_READ32(PSB_PUNIT_PORT, PSB_APMBA) & 0xFFFF;
-	dev_priv->ospm_base = CDV_MSG_READ32(PSB_PUNIT_PORT, PSB_OSPMBA) & 0xFFFF;
+	dev_priv->apm_base = CDV_MSG_READ32(PSB_PUNIT_PORT,
+							PSB_APMBA) & 0xFFFF;
+	dev_priv->ospm_base = CDV_MSG_READ32(PSB_PUNIT_PORT,
+							PSB_OSPMBA) & 0xFFFF;
 
 	/* Force power on for now */
 	pwr_cnt = inl(dev_priv->apm_base + PSB_APM_CMD);
@@ -346,5 +347,5 @@ const struct psb_ops cdv_chip_ops = {
 	.save_regs = cdv_save_display_registers,
 	.restore_regs = cdv_restore_display_registers,
 	.power_down = cdv_power_down,
-	.power_up = cdv_power_up,	
+	.power_up = cdv_power_up,
 };
diff --git a/drivers/staging/gma500/cdv_intel_crt.c b/drivers/staging/gma500/cdv_intel_crt.c
index e26749c..efda63b 100644
--- a/drivers/staging/gma500/cdv_intel_crt.c
+++ b/drivers/staging/gma500/cdv_intel_crt.c
@@ -45,7 +45,7 @@ static void cdv_intel_crt_dpms(struct drm_encoder *encoder, int mode)
 	temp &= ~(ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE);
 	temp &= ~ADPA_DAC_ENABLE;
 
-	switch(mode) {
+	switch (mode) {
 	case DRM_MODE_DPMS_ON:
 		temp |= ADPA_DAC_ENABLE;
 		break;
@@ -128,11 +128,10 @@ static void cdv_intel_crt_mode_set(struct drm_encoder *encoder,
 	if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
 		adpa |= ADPA_VSYNC_ACTIVE_HIGH;
 
-	if (psb_intel_crtc->pipe == 0) {
+	if (psb_intel_crtc->pipe == 0)
 		adpa |= ADPA_PIPE_A_SELECT;
-	} else {
+	else
 		adpa |= ADPA_PIPE_B_SELECT;
-	}
 
 	REG_WRITE(adpa_reg, adpa);
 }
@@ -144,7 +143,8 @@ static void cdv_intel_crt_mode_set(struct drm_encoder *encoder,
  * \return true if CRT is connected.
  * \return false if CRT is disconnected.
  */
-static bool cdv_intel_crt_detect_hotplug(struct drm_connector *connector, bool force)
+static bool cdv_intel_crt_detect_hotplug(struct drm_connector *connector,
+								bool force)
 {
 	struct drm_device *dev = connector->dev;
 	u32 hotplug_en;
@@ -193,7 +193,8 @@ static bool cdv_intel_crt_detect_hotplug(struct drm_connector *connector, bool f
 	return ret;
 }
 
-static enum drm_connector_status cdv_intel_crt_detect(struct drm_connector *connector, bool force)
+static enum drm_connector_status cdv_intel_crt_detect(
+				struct drm_connector *connector, bool force)
 {
 	if (cdv_intel_crt_detect_hotplug(connector, force))
 		return connector_status_connected;
@@ -245,7 +246,8 @@ static const struct drm_connector_funcs cdv_intel_crt_connector_funcs = {
 	.set_property = cdv_intel_crt_set_property,
 };
 
-static const struct drm_connector_helper_funcs cdv_intel_crt_connector_helper_funcs = {
+static const struct drm_connector_helper_funcs
+				cdv_intel_crt_connector_helper_funcs = {
 	.mode_valid = cdv_intel_crt_mode_valid,
 	.get_modes = cdv_intel_crt_get_modes,
 	.best_encoder = psb_intel_best_encoder,
@@ -277,11 +279,11 @@ void cdv_intel_crt_init(struct drm_device *dev,
 	psb_intel_output->mode_dev = mode_dev;
 	connector = &psb_intel_output->base;
 	drm_connector_init(dev, connector,
-			   &cdv_intel_crt_connector_funcs, DRM_MODE_CONNECTOR_VGA);
+		&cdv_intel_crt_connector_funcs, DRM_MODE_CONNECTOR_VGA);
 
 	encoder = &psb_intel_output->enc;
 	drm_encoder_init(dev, encoder,
-				&cdv_intel_crt_enc_funcs, DRM_MODE_ENCODER_DAC);
+		&cdv_intel_crt_enc_funcs, DRM_MODE_ENCODER_DAC);
 
 	drm_mode_connector_attach_encoder(&psb_intel_output->base,
 					  &psb_intel_output->enc);
@@ -310,7 +312,8 @@ void cdv_intel_crt_init(struct drm_device *dev,
 	connector->doublescan_allowed = 0;
 
 	drm_encoder_helper_add(encoder, &cdv_intel_crt_helper_funcs);
-	drm_connector_helper_add(connector, &cdv_intel_crt_connector_helper_funcs);
+	drm_connector_helper_add(connector,
+					&cdv_intel_crt_connector_helper_funcs);
 
 	drm_sysfs_connector_add(connector);
 
diff --git a/drivers/staging/gma500/cdv_intel_display.c b/drivers/staging/gma500/cdv_intel_display.c
index 2042e98..7b97c60 100644
--- a/drivers/staging/gma500/cdv_intel_display.c
+++ b/drivers/staging/gma500/cdv_intel_display.c
@@ -11,7 +11,7 @@
  * more details.
  *
  * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 
+ * this program; if not, write to the Free Software Foundation, Inc.,
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  * Authors:
@@ -40,8 +40,7 @@ struct cdv_intel_p2_t {
 	int p2_slow, p2_fast;
 };
 
-struct cdv_intel_clock_t
-{
+struct cdv_intel_clock_t {
 	/* given values */
 	int n;
 	int m1, m2;
@@ -117,17 +116,18 @@ static const struct cdv_intel_limit_t cdv_intel_limits[] = {
 };
 
 #define _wait_for(COND, MS, W) ({ \
-        unsigned long timeout__ = jiffies + msecs_to_jiffies(MS);       \
-        int ret__ = 0;                                                  \
-        while (! (COND)) {                                              \
-                if (time_after(jiffies, timeout__)) {                   \
-                        ret__ = -ETIMEDOUT;                             \
-                        break;                                          \
-                }                                                       \
-                if (W && !in_dbg_master()) msleep(W);                   \
-        }                                                               \
-        ret__;                                                          \
-})      
+	unsigned long timeout__ = jiffies + msecs_to_jiffies(MS);	\
+	int ret__ = 0;							\
+	while (!(COND)) {						\
+		if (time_after(jiffies, timeout__)) {			\
+			ret__ = -ETIMEDOUT;				\
+			break;						\
+		}							\
+		if (W && !in_dbg_master())				\
+			msleep(W);					\
+	}								\
+	ret__;								\
+})
 
 #define wait_for(COND, MS) _wait_for(COND, MS, 1)
 
@@ -237,7 +237,7 @@ cdv_dpll_set_clock_cdv(struct drm_device *dev, struct drm_crtc *crtc,
 	ref_value = 0x68A701;
 
 	cdv_sb_write(dev, SB_REF_SFR(pipe), ref_value);
-	
+
 	/* We don't know what the other fields of these regs are, so
 	 * leave them in place.
 	 */
@@ -324,14 +324,13 @@ cdv_dpll_set_clock_cdv(struct drm_device *dev, struct drm_crtc *crtc,
 		lane_value |= LANE_PLL_ENABLE;
 		cdv_sb_write(dev, lane_reg, lane_value);
 
-		/* Program the Lane2/3 for HDMI C */	
+		/* Program the Lane2/3 for HDMI C */
 		lane_reg = PSB_LANE2;
 		cdv_sb_read(dev, lane_reg, &lane_value);
 		lane_value &= ~(LANE_PLL_MASK);
 		lane_value |= LANE_PLL_ENABLE;
 		cdv_sb_write(dev, lane_reg, lane_value);
 
-	
 		lane_reg = PSB_LANE3;
 		cdv_sb_read(dev, lane_reg, &lane_value);
 		lane_value &= ~(LANE_PLL_MASK);
@@ -362,17 +361,18 @@ bool cdv_intel_pipe_has_type(struct drm_crtc *crtc, int type)
 	return false;
 }
 
-static const struct cdv_intel_limit_t *cdv_intel_limit(struct drm_crtc *crtc, int refclk)
+static const struct cdv_intel_limit_t *cdv_intel_limit(struct drm_crtc *crtc,
+							int refclk)
 {
 	const struct cdv_intel_limit_t *limit;
 	if (cdv_intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
 		/*
- 		 * Now only single-channel LVDS is supported on CDV. If it is
- 		 * incorrect, please add the dual-channel LVDS.
- 		 */
+		 * Now only single-channel LVDS is supported on CDV. If it is
+		 * incorrect, please add the dual-channel LVDS.
+		 */
 		if (refclk == 96000)
 			limit = &cdv_intel_limits[CDV_LIMIT_SINGLE_LVDS_96];
-		else 
+		else
 			limit = &cdv_intel_limits[CDV_LIMIT_SINGLE_LVDS_100];
 	} else {
 		if (refclk == 27000)
@@ -384,7 +384,7 @@ static const struct cdv_intel_limit_t *cdv_intel_limit(struct drm_crtc *crtc, in
 }
 
 /* m1 is reserved as 0 in CDV, n is a ring counter */
-static void cdv_intel_clock(struct drm_device *dev, 
+static void cdv_intel_clock(struct drm_device *dev,
 			int refclk, struct cdv_intel_clock_t *clock)
 {
 	clock->m = clock->m2 + 2;
@@ -448,19 +448,22 @@ static bool cdv_intel_find_best_PLL(struct drm_crtc *crtc, int target,
 
 	memset(best_clock, 0, sizeof(*best_clock));
 	clock.m1 = 0;
-	/* m1 is reserved as 0 in CDV, n is a ring counter. So skip the m1 loop */
+	/* m1 is reserved as 0 in CDV, n is a ring counter.
+	   So skip the m1 loop */
 	for (clock.n = limit->n.min; clock.n <= limit->n.max; clock.n++) {
 		for (clock.m2 = limit->m2.min; clock.m2 <= limit->m2.max;
 					     clock.m2++) {
-			for (clock.p1 = limit->p1.min; clock.p1 <= limit->p1.max;
-				     clock.p1++) {
+			for (clock.p1 = limit->p1.min;
+					clock.p1 <= limit->p1.max;
+					clock.p1++) {
 				int this_err;
 
 				cdv_intel_clock(dev, refclk, &clock);
 
-				if (!cdv_intel_PLL_is_valid(crtc, limit, &clock))
+				if (!cdv_intel_PLL_is_valid(crtc,
+								limit, &clock))
 						continue;
-				
+
 				this_err = abs(clock.dot - target);
 				if (this_err < err) {
 					*best_clock = clock;
@@ -533,7 +536,7 @@ int cdv_intel_pipe_set_base(struct drm_crtc *crtc,
 	REG_WRITE(dspcntr_reg, dspcntr);
 
 	dev_dbg(dev->dev,
-	        "Writing base %08lX %08lX %d %d\n", start, offset, x, y);
+		"Writing base %08lX %08lX %d %d\n", start, offset, x, y);
 
 	REG_WRITE(dspbase, offset);
 	REG_READ(dspbase);
@@ -808,7 +811,7 @@ static int cdv_intel_crtc_mode_set(struct drm_crtc *crtc,
 		dpll |= DPLLB_MODE_LVDS;
 	else
 		dpll |= DPLLB_MODE_DAC_SERIAL;
-	//dpll |= (2 << 11);
+	/* dpll |= (2 << 11); */
 
 	/* setup pipeconf */
 	pipeconf = REG_READ(pipeconf_reg);
@@ -824,14 +827,12 @@ static int cdv_intel_crtc_mode_set(struct drm_crtc *crtc,
 	dspcntr |= DISPLAY_PLANE_ENABLE;
 	pipeconf |= PIPEACONF_ENABLE;
 
-	REG_WRITE(dpll_reg,
-                   dpll | DPLL_VGA_MODE_DIS |
-                   DPLL_SYNCLOCK_ENABLE);
-        REG_READ(dpll_reg);
+	REG_WRITE(dpll_reg, dpll | DPLL_VGA_MODE_DIS | DPLL_SYNCLOCK_ENABLE);
+	REG_READ(dpll_reg);
 
 	cdv_dpll_set_clock_cdv(dev, crtc, &clock);
 
-        udelay(150);
+	udelay(150);
 
 
 	/* The LVDS pin pair needs to be on before the DPLLs are enabled.
@@ -864,7 +865,6 @@ static int cdv_intel_crtc_mode_set(struct drm_crtc *crtc,
 
 	dpll |= DPLL_VCO_ENABLE;
 
-		
 	/* Disable the panel fitter if it was on our pipe */
 	if (cdv_intel_panel_fitter_pipe(dev) == pipe)
 		REG_WRITE(PFIT_CONTROL, 0);
@@ -873,24 +873,19 @@ static int cdv_intel_crtc_mode_set(struct drm_crtc *crtc,
 	drm_mode_debug_printmodeline(mode);
 
 	REG_WRITE(dpll_reg,
-                   (REG_READ(dpll_reg) & ~DPLL_LOCK) |
-                   DPLL_VCO_ENABLE);
-        REG_READ(dpll_reg);
+		(REG_READ(dpll_reg) & ~DPLL_LOCK) | DPLL_VCO_ENABLE);
+	REG_READ(dpll_reg);
 	/* Wait for the clocks to stabilize. */
-        udelay(150); /* 42 usec w/o calibration, 110 with.  rounded up. */
-
-        if (!(REG_READ(dpll_reg) & DPLL_LOCK)) {
-                dev_err(dev->dev, "Failed to get DPLL lock\n");
-                return -EBUSY;
-        }
-
-        {
-        	int sdvo_pixel_multiply =
-		    adjusted_mode->clock / mode->clock;
-		REG_WRITE(dpll_md_reg,
-			  (0 << DPLL_MD_UDI_DIVIDER_SHIFT) |
-			  ((sdvo_pixel_multiply -
-			    1) << DPLL_MD_UDI_MULTIPLIER_SHIFT));
+	udelay(150); /* 42 usec w/o calibration, 110 with.  rounded up. */
+
+	if (!(REG_READ(dpll_reg) & DPLL_LOCK)) {
+		dev_err(dev->dev, "Failed to get DPLL lock\n");
+		return -EBUSY;
+	}
+
+	{
+		int sdvo_pixel_multiply = adjusted_mode->clock / mode->clock;
+		REG_WRITE(dpll_md_reg, (0 << DPLL_MD_UDI_DIVIDER_SHIFT) | ((sdvo_pixel_multiply - 1) << DPLL_MD_UDI_MULTIPLIER_SHIFT));
 	}
 
 	REG_WRITE(htot_reg, (adjusted_mode->crtc_hdisplay - 1) |
@@ -956,10 +951,10 @@ void cdv_intel_crtc_load_lut(struct drm_crtc *crtc)
 		palreg = PALETTE_C;
 		break;
 	default:
-		dev_err(dev->dev, "Illegal Pipe Number. \n");
+		dev_err(dev->dev, "Illegal Pipe Number.\n");
 		return;
 	}
-	
+
 	if (gma_power_begin(dev, false)) {
 		for (i = 0; i < 256; i++) {
 			REG_WRITE(palreg + 4 * i,
@@ -1276,7 +1271,7 @@ static int cdv_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 }
 
 static void cdv_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
-				 u16 *green, u16 *blue, uint32_t start, uint32_t size)
+			 u16 *green, u16 *blue, uint32_t start, uint32_t size)
 {
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	int i;
@@ -1294,10 +1289,10 @@ static void cdv_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
 static int cdv_crtc_set_config(struct drm_mode_set *set)
 {
 	int ret = 0;
-	struct drm_device * dev = set->crtc->dev;
-	struct drm_psb_private * dev_priv = dev->dev_private;
+	struct drm_device *dev = set->crtc->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 
-	if(!dev_priv->rpm_enabled)
+	if (!dev_priv->rpm_enabled)
 		return drm_crtc_helper_set_config(set);
 
 	pm_runtime_forbid(&dev->pdev->dev);
@@ -1489,7 +1484,7 @@ void cdv_intel_cursor_init(struct drm_device *dev, int pipe)
 {
 	uint32_t control;
 	uint32_t base;
-      
+
 	switch (pipe) {
 	case 0:
 		control = CURACNTR;
diff --git a/drivers/staging/gma500/cdv_intel_hdmi.c b/drivers/staging/gma500/cdv_intel_hdmi.c
index 5acfb37..7f86c0c 100644
--- a/drivers/staging/gma500/cdv_intel_hdmi.c
+++ b/drivers/staging/gma500/cdv_intel_hdmi.c
@@ -59,8 +59,8 @@ struct mid_intel_hdmi_priv {
 };
 
 static void cdv_hdmi_mode_set(struct drm_encoder *encoder,
-                        struct drm_display_mode *mode,
-                        struct drm_display_mode *adjusted_mode)
+			struct drm_display_mode *mode,
+			struct drm_display_mode *adjusted_mode)
 {
 	struct drm_device *dev = encoder->dev;
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
@@ -83,7 +83,7 @@ static void cdv_hdmi_mode_set(struct drm_encoder *encoder,
 		hdmib |= HDMI_AUDIO_ENABLE;
 		hdmib |= HDMI_NULL_PACKETS_DURING_VSYNC;
 	}
-		
+
 	REG_WRITE(hdmi_priv->hdmi_reg, hdmib);
 	REG_READ(hdmi_priv->hdmi_reg);
 }
@@ -92,8 +92,7 @@ static bool cdv_hdmi_mode_fixup(struct drm_encoder *encoder,
 				  struct drm_display_mode *mode,
 				  struct drm_display_mode *adjusted_mode)
 {
-
-       return true;
+	return true;
 }
 
 static void cdv_hdmi_dpms(struct drm_encoder *encoder, int mode)
@@ -105,11 +104,10 @@ static void cdv_hdmi_dpms(struct drm_encoder *encoder, int mode)
 
 	hdmib = REG_READ(hdmi_priv->hdmi_reg);
 
-	if (mode != DRM_MODE_DPMS_ON) {
+	if (mode != DRM_MODE_DPMS_ON)
 		REG_WRITE(hdmi_priv->hdmi_reg, hdmib & ~HDMIB_PORT_EN);
-	} else {
+	else
 		REG_WRITE(hdmi_priv->hdmi_reg, hdmib | HDMIB_PORT_EN);
-	}
 	REG_READ(hdmi_priv->hdmi_reg);
 }
 
@@ -132,11 +130,12 @@ static void cdv_hdmi_restore(struct drm_connector *connector)
 	REG_READ(hdmi_priv->hdmi_reg);
 }
 
-static enum drm_connector_status cdv_hdmi_detect(struct drm_connector *connector, bool force)
+static enum drm_connector_status cdv_hdmi_detect(
+				struct drm_connector *connector, bool force)
 {
 	struct drm_device *dev = connector->dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct psb_intel_output *psb_intel_output = to_psb_intel_output(connector);
+	struct psb_intel_output *psb_intel_output =
+						to_psb_intel_output(connector);
 	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_output->dev_priv;
 	struct edid *edid = NULL;
 	enum drm_connector_status status = connector_status_disconnected;
@@ -149,8 +148,10 @@ static enum drm_connector_status cdv_hdmi_detect(struct drm_connector *connector
 	if (edid) {
 		if (edid->input & DRM_EDID_INPUT_DIGITAL) {
 			status = connector_status_connected;
-			hdmi_priv->has_hdmi_sink = drm_detect_hdmi_monitor(edid);
-			hdmi_priv->has_hdmi_audio = drm_detect_monitor_audio(edid);
+			hdmi_priv->has_hdmi_sink =
+						drm_detect_hdmi_monitor(edid);
+			hdmi_priv->has_hdmi_audio =
+						drm_detect_monitor_audio(edid);
 		}
 
 		psb_intel_output->base.display_info.raw_edid = NULL;
@@ -171,7 +172,7 @@ static int cdv_hdmi_set_property(struct drm_connector *connector,
 		uint64_t curValue;
 
 		if (!crtc)
-		        return -1;
+			return -1;
 
 		switch (value) {
 		case DRM_MODE_SCALE_FULLSCREEN:
@@ -181,17 +182,19 @@ static int cdv_hdmi_set_property(struct drm_connector *connector,
 		case DRM_MODE_SCALE_ASPECT:
 			break;
 		default:
-		        return -1;
+			return -1;
 		}
 
-		if (drm_connector_property_get_value(connector, property, &curValue))
-		        return -1;
+		if (drm_connector_property_get_value(connector,
+							property, &curValue))
+			return -1;
 
 		if (curValue == value)
-		        return 0;
+			return 0;
 
-		if (drm_connector_property_set_value(connector, property, value))
-		        return -1;
+		if (drm_connector_property_set_value(connector,
+							property, value))
+			return -1;
 
 		centre = (curValue == DRM_MODE_SCALE_NO_SCALE) ||
 			(value == DRM_MODE_SCALE_NO_SCALE);
@@ -203,9 +206,10 @@ static int cdv_hdmi_set_property(struct drm_connector *connector,
 					    encoder->crtc->x, encoder->crtc->y, encoder->crtc->fb))
 					return -1;
 			} else {
-				struct drm_encoder_helper_funcs *helpers  = encoder->helper_private;
+				struct drm_encoder_helper_funcs *helpers
+						    = encoder->helper_private;
 				helpers->mode_set(encoder, &crtc->saved_mode,
-						     &crtc->saved_adjusted_mode);
+					     &crtc->saved_adjusted_mode);
 			}
 		}
 	}
@@ -217,7 +221,8 @@ static int cdv_hdmi_set_property(struct drm_connector *connector,
  */
 static int cdv_hdmi_get_modes(struct drm_connector *connector)
 {
-	struct psb_intel_output *psb_intel_output = to_psb_intel_output(connector);
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
 	struct edid *edid = NULL;
 	int ret = 0;
 
@@ -250,8 +255,8 @@ static int cdv_hdmi_mode_valid(struct drm_connector *connector,
 		return MODE_NO_INTERLACE;
 
 	/*
-	 * FIXME: fornow we limit the size to 1680x1050 on CDV, otherwise it will
-	 * go beyond the stolen memory size allocated to the Framebuffer
+	 * FIXME: for now we limit the size to 1680x1050 on CDV, otherwise it
+	 * will go beyond the stolen memory size allocated to the framebuffer
 	 */
 	if (mode->hdisplay > 1680)
 		return MODE_PANEL;
@@ -280,7 +285,8 @@ static const struct drm_encoder_helper_funcs cdv_hdmi_helper_funcs = {
 	.commit = psb_intel_encoder_commit,
 };
 
-static const struct drm_connector_helper_funcs cdv_hdmi_connector_helper_funcs = {
+static const struct drm_connector_helper_funcs
+					cdv_hdmi_connector_helper_funcs = {
 	.get_modes = cdv_hdmi_get_modes,
 	.mode_valid = cdv_hdmi_mode_valid,
 	.best_encoder = psb_intel_best_encoder,
@@ -296,7 +302,8 @@ static const struct drm_connector_funcs cdv_hdmi_connector_funcs = {
 	.destroy = cdv_hdmi_destroy,
 };
 
-void cdv_hdmi_init(struct drm_device *dev, struct psb_intel_mode_device *mode_dev, int reg)
+void cdv_hdmi_init(struct drm_device *dev,
+			struct psb_intel_mode_device *mode_dev, int reg)
 {
 	struct psb_intel_output *psb_intel_output;
 	struct drm_connector *connector;
@@ -334,7 +341,8 @@ void cdv_hdmi_init(struct drm_device *dev, struct psb_intel_mode_device *mode_de
 	connector->interlace_allowed = false;
 	connector->doublescan_allowed = false;
 
-	drm_connector_attach_property(connector, dev->mode_config.scaling_mode_property, DRM_MODE_SCALE_FULLSCREEN);
+	drm_connector_attach_property(connector,
+	    dev->mode_config.scaling_mode_property, DRM_MODE_SCALE_FULLSCREEN);
 
 	switch (reg) {
 	case SDVOB:
@@ -350,19 +358,15 @@ void cdv_hdmi_init(struct drm_device *dev, struct psb_intel_mode_device *mode_de
 	}
 
 	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
-						ddc_bus, (reg == SDVOB) ? "HDMIB":"HDMIC");
+				ddc_bus, (reg == SDVOB) ? "HDMIB" : "HDMIC");
 
-	if (psb_intel_output->ddc_bus) {
-     		/* HACKS_JLIU7 */
-		DRM_INFO("Enter cdv_hdmi_init, i2c_adapter is availabe.\n");
-
-	} else {
-		printk(KERN_ALERT "No ddc adapter available!\n");
+	if (!psb_intel_output->ddc_bus) {
+		dev_err(dev->dev, "No ddc adapter available!\n");
 		goto failed_ddc;
 	}
-	psb_intel_output->hdmi_i2c_adapter = &(psb_intel_output->ddc_bus->adapter);
-
-	hdmi_priv->dev = dev; 
+	psb_intel_output->hdmi_i2c_adapter =
+				&(psb_intel_output->ddc_bus->adapter);
+	hdmi_priv->dev = dev;
 	drm_sysfs_connector_add(connector);
 	return;
 
diff --git a/drivers/staging/gma500/cdv_intel_lvds.c b/drivers/staging/gma500/cdv_intel_lvds.c
index d9b2290..19ad9bb 100644
--- a/drivers/staging/gma500/cdv_intel_lvds.c
+++ b/drivers/staging/gma500/cdv_intel_lvds.c
@@ -11,7 +11,7 @@
  * more details.
  *
  * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 
+ * this program; if not, write to the Free Software Foundation, Inc.,
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  * Authors:
@@ -200,7 +200,7 @@ static void cdv_intel_lvds_set_power(struct drm_device *dev,
 	u32 pp_status;
 
 	if (!gma_power_begin(dev, true))
-	        return;
+		return;
 
 	if (on) {
 		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) |
@@ -390,7 +390,8 @@ static void cdv_intel_lvds_mode_set(struct drm_encoder *encoder,
  * This connector should only have
  * been set up if the LVDS was actually connected anyway.
  */
-static enum drm_connector_status cdv_intel_lvds_detect(struct drm_connector *connector, bool force)
+static enum drm_connector_status cdv_intel_lvds_detect(
+				struct drm_connector *connector, bool force)
 {
 	return connector_status_connected;
 }
@@ -503,21 +504,24 @@ int cdv_intel_lvds_set_property(struct drm_connector *connector,
 			return -1;
 		else {
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-                	struct drm_psb_private *dev_priv =
+			struct drm_psb_private *dev_priv =
 						encoder->dev->dev_private;
-			struct backlight_device *bd = dev_priv->backlight_device;
+			struct backlight_device *bd =
+						dev_priv->backlight_device;
 			bd->props.brightness = value;
 			backlight_update_status(bd);
 #endif
 		}
 	} else if (!strcmp(property->name, "DPMS") && encoder) {
-		struct drm_encoder_helper_funcs *helpers = encoder->helper_private;
+		struct drm_encoder_helper_funcs *helpers =
+					encoder->helper_private;
 		helpers->dpms(encoder, value);
 	}
 	return 0;
 }
 
-static const struct drm_encoder_helper_funcs cdv_intel_lvds_helper_funcs = {
+static const struct drm_encoder_helper_funcs
+					cdv_intel_lvds_helper_funcs = {
 	.dpms = cdv_intel_lvds_encoder_dpms,
 	.mode_fixup = cdv_intel_lvds_mode_fixup,
 	.prepare = cdv_intel_lvds_prepare,
@@ -526,7 +530,7 @@ static const struct drm_encoder_helper_funcs cdv_intel_lvds_helper_funcs = {
 };
 
 static const struct drm_connector_helper_funcs
-    cdv_intel_lvds_connector_helper_funcs = {
+				cdv_intel_lvds_connector_helper_funcs = {
 	.get_modes = cdv_intel_lvds_get_modes,
 	.mode_valid = cdv_intel_lvds_mode_valid,
 	.best_encoder = psb_intel_best_encoder,

