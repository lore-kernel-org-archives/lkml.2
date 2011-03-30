Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1C3JSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:18:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51157 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932176Ab1C3JSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:18:01 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 02/18] gma500: Add moorestown lvds driver code
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 09:59:17 +0100
Message-ID: <20110330085913.5897.52373.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new files needed for the GMA500 driver to support Moorestown LVDS
displays. Don't wire them in yet.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_crtc.c |  623 ++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/mrst_lvds.c |  364 +++++++++++++++++++++
 2 files changed, 987 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/gma500/mrst_crtc.c
 create mode 100644 drivers/staging/gma500/mrst_lvds.c

diff --git a/drivers/staging/gma500/mrst_crtc.c b/drivers/staging/gma500/mrst_crtc.c
new file mode 100644
index 0000000..89b9cac
--- /dev/null
+++ b/drivers/staging/gma500/mrst_crtc.c
@@ -0,0 +1,623 @@
+/*
+ * Copyright © 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/i2c.h>
+#include <linux/pm_runtime.h>
+
+#include <drm/drmP.h>
+#include "psb_fb.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_display.h"
+#include "psb_powermgmt.h"
+
+struct psb_intel_range_t {
+	int min, max;
+};
+
+struct mrst_limit_t {
+	struct psb_intel_range_t dot, m, p1;
+};
+
+struct mrst_clock_t {
+	/* derived values */
+	int dot;
+	int m;
+	int p1;
+};
+
+#define MRST_LIMIT_LVDS_100L	    0
+#define MRST_LIMIT_LVDS_83	    1
+#define MRST_LIMIT_LVDS_100	    2
+
+#define MRST_DOT_MIN		  19750
+#define MRST_DOT_MAX		  120000
+#define MRST_M_MIN_100L		    20
+#define MRST_M_MIN_100		    10
+#define MRST_M_MIN_83		    12
+#define MRST_M_MAX_100L		    34
+#define MRST_M_MAX_100		    17
+#define MRST_M_MAX_83		    20
+#define MRST_P1_MIN		    2
+#define MRST_P1_MAX_0		    7
+#define MRST_P1_MAX_1		    8
+
+static const struct mrst_limit_t mrst_limits[] = {
+	{			/* MRST_LIMIT_LVDS_100L */
+	 .dot = {.min = MRST_DOT_MIN, .max = MRST_DOT_MAX},
+	 .m = {.min = MRST_M_MIN_100L, .max = MRST_M_MAX_100L},
+	 .p1 = {.min = MRST_P1_MIN, .max = MRST_P1_MAX_1},
+	 },
+	{			/* MRST_LIMIT_LVDS_83L */
+	 .dot = {.min = MRST_DOT_MIN, .max = MRST_DOT_MAX},
+	 .m = {.min = MRST_M_MIN_83, .max = MRST_M_MAX_83},
+	 .p1 = {.min = MRST_P1_MIN, .max = MRST_P1_MAX_0},
+	 },
+	{			/* MRST_LIMIT_LVDS_100 */
+	 .dot = {.min = MRST_DOT_MIN, .max = MRST_DOT_MAX},
+	 .m = {.min = MRST_M_MIN_100, .max = MRST_M_MAX_100},
+	 .p1 = {.min = MRST_P1_MIN, .max = MRST_P1_MAX_1},
+	 },
+};
+
+#define MRST_M_MIN	    10
+static const u32 mrst_m_converts[] = {
+	0x2B, 0x15, 0x2A, 0x35, 0x1A, 0x0D, 0x26, 0x33, 0x19, 0x2C,
+	0x36, 0x3B, 0x1D, 0x2E, 0x37, 0x1B, 0x2D, 0x16, 0x0B, 0x25,
+	0x12, 0x09, 0x24, 0x32, 0x39, 0x1c,
+};
+
+static const struct mrst_limit_t *mrst_limit(struct drm_crtc *crtc)
+{
+	const struct mrst_limit_t *limit = NULL;
+	struct drm_device *dev = crtc->dev;
+	DRM_DRIVER_PRIVATE_T *dev_priv = dev->dev_private;
+
+	if (psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)
+	    || psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_MIPI)) {
+		switch (dev_priv->core_freq) {
+		case 100:
+			limit = &mrst_limits[MRST_LIMIT_LVDS_100L];
+			break;
+		case 166:
+			limit = &mrst_limits[MRST_LIMIT_LVDS_83];
+			break;
+		case 200:
+			limit = &mrst_limits[MRST_LIMIT_LVDS_100];
+			break;
+		}
+	} else {
+		limit = NULL;
+		PSB_DEBUG_ENTRY("mrst_limit Wrong display type.\n");
+	}
+
+	return limit;
+}
+
+/** Derive the pixel clock for the given refclk and divisors for 8xx chips. */
+static void mrst_clock(int refclk, struct mrst_clock_t *clock)
+{
+	clock->dot = (refclk * clock->m) / (14 * clock->p1);
+}
+
+void mrstPrintPll(char *prefix, struct mrst_clock_t *clock)
+{
+	PSB_DEBUG_ENTRY("%s: dotclock = %d,  m = %d, p1 = %d.\n",
+	     prefix, clock->dot, clock->m, clock->p1);
+}
+
+/**
+ * Returns a set of divisors for the desired target clock with the given refclk,
+ * or FALSE.  Divisor values are the actual divisors for
+ */
+static bool
+mrstFindBestPLL(struct drm_crtc *crtc, int target, int refclk,
+		struct mrst_clock_t *best_clock)
+{
+	struct mrst_clock_t clock;
+	const struct mrst_limit_t *limit = mrst_limit(crtc);
+	int err = target;
+
+	memset(best_clock, 0, sizeof(*best_clock));
+
+	for (clock.m = limit->m.min; clock.m <= limit->m.max; clock.m++) {
+		for (clock.p1 = limit->p1.min; clock.p1 <= limit->p1.max;
+		     clock.p1++) {
+			int this_err;
+
+			mrst_clock(refclk, &clock);
+
+			this_err = abs(clock.dot - target);
+			if (this_err < err) {
+				*best_clock = clock;
+				err = this_err;
+			}
+		}
+	}
+	DRM_DEBUG("mrstFindBestPLL err = %d.\n", err);
+
+	return err != target;
+}
+
+/**
+ * Sets the power management mode of the pipe and plane.
+ *
+ * This code should probably grow support for turning the cursor off and back
+ * on appropriately at the same time as we're turning the pipe off/on.
+ */
+static void mrst_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	int dpll_reg = (pipe == 0) ? MRST_DPLL_A : DPLL_B;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	int dspbase_reg = (pipe == 0) ? MRST_DSPABASE : DSPBBASE;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	u32 temp;
+	bool enabled;
+
+	PSB_DEBUG_ENTRY("mode = %d, pipe = %d\n", mode, pipe);
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				       OSPM_UHB_FORCE_POWER_ON))
+		return;
+
+	/* XXX: When our outputs are all unaware of DPMS modes other than off
+	 * and on, we should map those modes to DRM_MODE_DPMS_OFF in the CRTC.
+	 */
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+		/* Enable the DPLL */
+		temp = REG_READ(dpll_reg);
+		if ((temp & DPLL_VCO_ENABLE) == 0) {
+			REG_WRITE(dpll_reg, temp);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+			REG_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+			REG_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+		}
+		/* Enable the pipe */
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) == 0)
+			REG_WRITE(pipeconf_reg, temp | PIPEACONF_ENABLE);
+		/* Enable the plane */
+		temp = REG_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) == 0) {
+			REG_WRITE(dspcntr_reg,
+				  temp | DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+		}
+
+		psb_intel_crtc_load_lut(crtc);
+
+		/* Give the overlay scaler a chance to enable
+		   if it's on this pipe */
+		/* psb_intel_crtc_dpms_video(crtc, true); TODO */
+		break;
+	case DRM_MODE_DPMS_OFF:
+		/* Give the overlay scaler a chance to disable
+		 * if it's on this pipe */
+		/* psb_intel_crtc_dpms_video(crtc, FALSE); TODO */
+
+		/* Disable the VGA plane that we never use */
+		REG_WRITE(VGACNTRL, VGA_DISP_DISABLE);
+		/* Disable display plane */
+		temp = REG_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) != 0) {
+			REG_WRITE(dspcntr_reg,
+				  temp & ~DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+			REG_READ(dspbase_reg);
+		}
+
+		/* Next, disable display pipes */
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) != 0) {
+			REG_WRITE(pipeconf_reg, temp & ~PIPEACONF_ENABLE);
+			REG_READ(pipeconf_reg);
+		}
+		/* Wait for for the pipe disable to take effect. */
+		psb_intel_wait_for_vblank(dev);
+
+		temp = REG_READ(dpll_reg);
+		if ((temp & DPLL_VCO_ENABLE) != 0) {
+			REG_WRITE(dpll_reg, temp & ~DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+		}
+
+		/* Wait for the clocks to turn off. */
+		udelay(150);
+		break;
+	}
+
+	enabled = crtc->enabled && mode != DRM_MODE_DPMS_OFF;
+
+	/*Set FIFO Watermarks*/
+	REG_WRITE(DSPARB, 0x3FFF);
+	REG_WRITE(DSPFW1, 0x3F88080A);
+	REG_WRITE(DSPFW2, 0x0b060808);
+	REG_WRITE(DSPFW3, 0x0);
+	REG_WRITE(DSPFW4, 0x08030404);
+	REG_WRITE(DSPFW5, 0x04040404);
+	REG_WRITE(DSPFW6, 0x78);
+	REG_WRITE(0x70400, REG_READ(0x70400) | 0x4000);
+	/* Must write Bit 14 of the Chicken Bit Register */
+
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+}
+
+/**
+ * Return the pipe currently connected to the panel fitter,
+ * or -1 if the panel fitter is not present or not in use
+ */
+static int mrst_panel_fitter_pipe(struct drm_device *dev)
+{
+	u32 pfit_control;
+
+	pfit_control = REG_READ(PFIT_CONTROL);
+
+	/* See if the panel fitter is in use */
+	if ((pfit_control & PFIT_ENABLE) == 0)
+		return -1;
+	return (pfit_control >> 29) & 3;
+}
+
+static int mrst_crtc_mode_set(struct drm_crtc *crtc,
+			      struct drm_display_mode *mode,
+			      struct drm_display_mode *adjusted_mode,
+			      int x, int y,
+			      struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	DRM_DRIVER_PRIVATE_T *dev_priv = dev->dev_private;
+	int pipe = psb_intel_crtc->pipe;
+	int fp_reg = (pipe == 0) ? MRST_FPA0 : FPB0;
+	int dpll_reg = (pipe == 0) ? MRST_DPLL_A : DPLL_B;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	int htot_reg = (pipe == 0) ? HTOTAL_A : HTOTAL_B;
+	int hblank_reg = (pipe == 0) ? HBLANK_A : HBLANK_B;
+	int hsync_reg = (pipe == 0) ? HSYNC_A : HSYNC_B;
+	int vtot_reg = (pipe == 0) ? VTOTAL_A : VTOTAL_B;
+	int vblank_reg = (pipe == 0) ? VBLANK_A : VBLANK_B;
+	int vsync_reg = (pipe == 0) ? VSYNC_A : VSYNC_B;
+	int pipesrc_reg = (pipe == 0) ? PIPEASRC : PIPEBSRC;
+	int refclk = 0;
+	struct mrst_clock_t clock;
+	u32 dpll = 0, fp = 0, dspcntr, pipeconf;
+	bool ok, is_sdvo = false;
+	bool is_crt = false, is_lvds = false, is_tv = false;
+	bool is_mipi = false;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct psb_intel_output *psb_intel_output = NULL;
+	uint64_t scalingType = DRM_MODE_SCALE_FULLSCREEN;
+	struct drm_encoder *encoder;
+
+	PSB_DEBUG_ENTRY("pipe = 0x%x\n", pipe);
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+					OSPM_UHB_FORCE_POWER_ON))
+		return 0;
+
+	memcpy(&psb_intel_crtc->saved_mode,
+		mode,
+		sizeof(struct drm_display_mode));
+	memcpy(&psb_intel_crtc->saved_adjusted_mode,
+		adjusted_mode,
+		sizeof(struct drm_display_mode));
+
+	list_for_each_entry(encoder, &mode_config->encoder_list, head) {
+
+		if (encoder->crtc != crtc)
+			continue;
+
+		psb_intel_output = enc_to_psb_intel_output(encoder);
+		switch (psb_intel_output->type) {
+		case INTEL_OUTPUT_LVDS:
+			is_lvds = true;
+			break;
+		case INTEL_OUTPUT_SDVO:
+			is_sdvo = true;
+			break;
+		case INTEL_OUTPUT_TVOUT:
+			is_tv = true;
+			break;
+		case INTEL_OUTPUT_ANALOG:
+			is_crt = true;
+			break;
+		case INTEL_OUTPUT_MIPI:
+			is_mipi = true;
+			break;
+		}
+	}
+
+	/* Disable the VGA plane that we never use */
+	REG_WRITE(VGACNTRL, VGA_DISP_DISABLE);
+
+	/* Disable the panel fitter if it was on our pipe */
+	if (mrst_panel_fitter_pipe(dev) == pipe)
+		REG_WRITE(PFIT_CONTROL, 0);
+
+	REG_WRITE(pipesrc_reg,
+		  ((mode->crtc_hdisplay - 1) << 16) |
+		  (mode->crtc_vdisplay - 1));
+
+	if (psb_intel_output)
+		drm_connector_property_get_value(&psb_intel_output->base,
+			dev->mode_config.scaling_mode_property, &scalingType);
+
+	if (scalingType == DRM_MODE_SCALE_NO_SCALE) {
+		/* Moorestown doesn't have register support for centering so
+		 * we need to mess with the h/vblank and h/vsync start and
+		 * ends to get centering */
+		int offsetX = 0, offsetY = 0;
+
+		offsetX = (adjusted_mode->crtc_hdisplay -
+			   mode->crtc_hdisplay) / 2;
+		offsetY = (adjusted_mode->crtc_vdisplay -
+			   mode->crtc_vdisplay) / 2;
+
+		REG_WRITE(htot_reg, (mode->crtc_hdisplay - 1) |
+			((adjusted_mode->crtc_htotal - 1) << 16));
+		REG_WRITE(vtot_reg, (mode->crtc_vdisplay - 1) |
+			((adjusted_mode->crtc_vtotal - 1) << 16));
+		REG_WRITE(hblank_reg,
+			(adjusted_mode->crtc_hblank_start - offsetX - 1) |
+			((adjusted_mode->crtc_hblank_end - offsetX - 1) << 16));
+		REG_WRITE(hsync_reg,
+			(adjusted_mode->crtc_hsync_start - offsetX - 1) |
+			((adjusted_mode->crtc_hsync_end - offsetX - 1) << 16));
+		REG_WRITE(vblank_reg,
+			(adjusted_mode->crtc_vblank_start - offsetY - 1) |
+			((adjusted_mode->crtc_vblank_end - offsetY - 1) << 16));
+		REG_WRITE(vsync_reg,
+			(adjusted_mode->crtc_vsync_start - offsetY - 1) |
+			((adjusted_mode->crtc_vsync_end - offsetY - 1) << 16));
+	} else {
+		REG_WRITE(htot_reg, (adjusted_mode->crtc_hdisplay - 1) |
+			((adjusted_mode->crtc_htotal - 1) << 16));
+		REG_WRITE(vtot_reg, (adjusted_mode->crtc_vdisplay - 1) |
+			((adjusted_mode->crtc_vtotal - 1) << 16));
+		REG_WRITE(hblank_reg, (adjusted_mode->crtc_hblank_start - 1) |
+			((adjusted_mode->crtc_hblank_end - 1) << 16));
+		REG_WRITE(hsync_reg, (adjusted_mode->crtc_hsync_start - 1) |
+			((adjusted_mode->crtc_hsync_end - 1) << 16));
+		REG_WRITE(vblank_reg, (adjusted_mode->crtc_vblank_start - 1) |
+			((adjusted_mode->crtc_vblank_end - 1) << 16));
+		REG_WRITE(vsync_reg, (adjusted_mode->crtc_vsync_start - 1) |
+			((adjusted_mode->crtc_vsync_end - 1) << 16));
+	}
+
+	/* Flush the plane changes */
+	{
+		struct drm_crtc_helper_funcs *crtc_funcs =
+		    crtc->helper_private;
+		crtc_funcs->mode_set_base(crtc, x, y, old_fb);
+	}
+
+	/* setup pipeconf */
+	pipeconf = REG_READ(pipeconf_reg);
+
+	/* Set up the display plane register */
+	dspcntr = REG_READ(dspcntr_reg);
+	dspcntr |= DISPPLANE_GAMMA_ENABLE;
+
+	if (pipe == 0)
+		dspcntr |= DISPPLANE_SEL_PIPE_A;
+	else
+		dspcntr |= DISPPLANE_SEL_PIPE_B;
+
+	dev_priv->dspcntr = dspcntr |= DISPLAY_PLANE_ENABLE;
+	dev_priv->pipeconf = pipeconf |= PIPEACONF_ENABLE;
+
+	if (is_mipi)
+		goto mrst_crtc_mode_set_exit;
+
+	refclk = dev_priv->core_freq * 1000;
+
+	dpll = 0;		/*BIT16 = 0 for 100MHz reference */
+
+	ok = mrstFindBestPLL(crtc, adjusted_mode->clock, refclk, &clock);
+
+	if (!ok) {
+		PSB_DEBUG_ENTRY(
+			"mrstFindBestPLL fail in mrst_crtc_mode_set.\n");
+	} else {
+		PSB_DEBUG_ENTRY("mrst_crtc_mode_set pixel clock = %d,"
+			 "m = %x, p1 = %x.\n", clock.dot, clock.m,
+			 clock.p1);
+	}
+
+	fp = mrst_m_converts[(clock.m - MRST_M_MIN)] << 8;
+
+	dpll |= DPLL_VGA_MODE_DIS;
+
+
+	dpll |= DPLL_VCO_ENABLE;
+
+	if (is_lvds)
+		dpll |= DPLLA_MODE_LVDS;
+	else
+		dpll |= DPLLB_MODE_DAC_SERIAL;
+
+	if (is_sdvo) {
+		int sdvo_pixel_multiply =
+		    adjusted_mode->clock / mode->clock;
+
+		dpll |= DPLL_DVO_HIGH_SPEED;
+		dpll |=
+		    (sdvo_pixel_multiply -
+		     1) << SDVO_MULTIPLIER_SHIFT_HIRES;
+	}
+
+
+	/* compute bitmask from p1 value */
+	dpll |= (1 << (clock.p1 - 2)) << 17;
+
+	dpll |= DPLL_VCO_ENABLE;
+
+	mrstPrintPll("chosen", &clock);
+
+	if (dpll & DPLL_VCO_ENABLE) {
+		REG_WRITE(fp_reg, fp);
+		REG_WRITE(dpll_reg, dpll & ~DPLL_VCO_ENABLE);
+		REG_READ(dpll_reg);
+		/* Check the DPLLA lock bit PIPEACONF[29] */
+		udelay(150);
+	}
+
+	REG_WRITE(fp_reg, fp);
+	REG_WRITE(dpll_reg, dpll);
+	REG_READ(dpll_reg);
+	/* Wait for the clocks to stabilize. */
+	udelay(150);
+
+	/* write it again -- the BIOS does, after all */
+	REG_WRITE(dpll_reg, dpll);
+	REG_READ(dpll_reg);
+	/* Wait for the clocks to stabilize. */
+	udelay(150);
+
+	REG_WRITE(pipeconf_reg, pipeconf);
+	REG_READ(pipeconf_reg);
+	psb_intel_wait_for_vblank(dev);
+
+	REG_WRITE(dspcntr_reg, dspcntr);
+	psb_intel_wait_for_vblank(dev);
+
+mrst_crtc_mode_set_exit:
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	return 0;
+}
+
+static bool mrst_crtc_mode_fixup(struct drm_crtc *crtc,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+int mrst_pipe_set_base(struct drm_crtc *crtc,
+			    int x, int y, struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	/* struct drm_i915_master_private *master_priv; */
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
+	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
+	int pipe = psb_intel_crtc->pipe;
+	unsigned long Start, Offset;
+	/* FIXME: check if we need this surely MRST is pipe 0 only */
+	int dspbase = (pipe == 0 ? DSPALINOFF : DSPBBASE);
+	int dspsurf = (pipe == 0 ? DSPASURF : DSPBSURF);
+	int dspstride = (pipe == 0) ? DSPASTRIDE : DSPBSTRIDE;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	u32 dspcntr;
+	int ret = 0;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	/* no fb bound */
+	if (!crtc->fb) {
+		DRM_DEBUG("No FB bound\n");
+		return 0;
+	}
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				       OSPM_UHB_FORCE_POWER_ON))
+		return 0;
+
+	Start = mode_dev->bo_offset(dev, psbfb);
+	Offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
+
+	REG_WRITE(dspstride, crtc->fb->pitch);
+
+	dspcntr = REG_READ(dspcntr_reg);
+	dspcntr &= ~DISPPLANE_PIXFORMAT_MASK;
+
+	switch (crtc->fb->bits_per_pixel) {
+	case 8:
+		dspcntr |= DISPPLANE_8BPP;
+		break;
+	case 16:
+		if (crtc->fb->depth == 15)
+			dspcntr |= DISPPLANE_15_16BPP;
+		else
+			dspcntr |= DISPPLANE_16BPP;
+		break;
+	case 24:
+	case 32:
+		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
+		break;
+	default:
+		DRM_ERROR("Unknown color depth\n");
+		ret = -EINVAL;
+		goto pipe_set_base_exit;
+	}
+	REG_WRITE(dspcntr_reg, dspcntr);
+
+	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset, x, y);
+	if (0 /* FIXMEAC - check what PSB needs */) {
+		REG_WRITE(dspbase, Offset);
+		REG_READ(dspbase);
+		REG_WRITE(dspsurf, Start);
+		REG_READ(dspsurf);
+	} else {
+		REG_WRITE(dspbase, Start + Offset);
+		REG_READ(dspbase);
+	}
+
+pipe_set_base_exit:
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	return ret;
+}
+
+static void mrst_crtc_prepare(struct drm_crtc *crtc)
+{
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+}
+
+static void mrst_crtc_commit(struct drm_crtc *crtc)
+{
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_ON);
+}
+
+const struct drm_crtc_helper_funcs mrst_helper_funcs = {
+	.dpms = mrst_crtc_dpms,
+	.mode_fixup = mrst_crtc_mode_fixup,
+	.mode_set = mrst_crtc_mode_set,
+	.mode_set_base = mrst_pipe_set_base,
+	.prepare = mrst_crtc_prepare,
+	.commit = mrst_crtc_commit,
+};
+
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
new file mode 100644
index 0000000..4628b01
--- /dev/null
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -0,0 +1,364 @@
+/*
+ * Copyright © 2006-2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ *	Dave Airlie <airlied@linux.ie>
+ *	Jesse Barnes <jesse.barnes@intel.com>
+ */
+
+#include <linux/i2c.h>
+#include <drm/drmP.h>
+
+#include "psb_intel_bios.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_powermgmt.h"
+#include <linux/pm_runtime.h>
+
+/* The max/min PWM frequency in BPCR[31:17] - */
+/* The smallest number is 1 (not 0) that can fit in the
+ * 15-bit field of the and then*/
+/* shifts to the left by one bit to get the actual 16-bit
+ * value that the 15-bits correspond to.*/
+#define MRST_BLC_MAX_PWM_REG_FREQ	    0xFFFF
+#define BRIGHTNESS_MAX_LEVEL 100
+
+/**
+ * Sets the power state for the panel.
+ */
+static void mrst_lvds_set_power(struct drm_device *dev,
+				struct psb_intel_output *output, bool on)
+{
+	u32 pp_status;
+	DRM_DRIVER_PRIVATE_T *dev_priv = dev->dev_private;
+	PSB_DEBUG_ENTRY("\n");
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+					OSPM_UHB_FORCE_POWER_ON))
+		return;
+
+	if (on) {
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) |
+			  POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while ((pp_status & (PP_ON | PP_READY)) == PP_READY);
+		dev_priv->is_lvds_on = true;
+	} else {
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) &
+			  ~POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while (pp_status & PP_ON);
+		dev_priv->is_lvds_on = false;
+		pm_request_idle(&dev->pdev->dev);
+	}
+
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+}
+
+static void mrst_lvds_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+
+	PSB_DEBUG_ENTRY("\n");
+
+	if (mode == DRM_MODE_DPMS_ON)
+		mrst_lvds_set_power(dev, output, true);
+	else
+		mrst_lvds_set_power(dev, output, false);
+
+	/* XXX: We never power down the LVDS pairs. */
+}
+
+static void mrst_lvds_mode_set(struct drm_encoder *encoder,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode)
+{
+	struct psb_intel_mode_device *mode_dev =
+				enc_to_psb_intel_output(encoder)->mode_dev;
+	struct drm_device *dev = encoder->dev;
+	u32 lvds_port;
+	uint64_t v = DRM_MODE_SCALE_FULLSCREEN;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				OSPM_UHB_FORCE_POWER_ON))
+		return;
+
+	/*
+	 * The LVDS pin pair will already have been turned on in the
+	 * psb_intel_crtc_mode_set since it has a large impact on the DPLL
+	 * settings.
+	 */
+	lvds_port = (REG_READ(LVDS) &
+		    (~LVDS_PIPEB_SELECT)) |
+		    LVDS_PORT_EN |
+		    LVDS_BORDER_EN;
+
+	if (mode_dev->panel_wants_dither)
+		lvds_port |= MRST_PANEL_8TO6_DITHER_ENABLE;
+
+	REG_WRITE(LVDS, lvds_port);
+
+	drm_connector_property_get_value(
+		&enc_to_psb_intel_output(encoder)->base,
+		dev->mode_config.scaling_mode_property,
+		&v);
+
+	if (v == DRM_MODE_SCALE_NO_SCALE)
+		REG_WRITE(PFIT_CONTROL, 0);
+	else if (v == DRM_MODE_SCALE_ASPECT) {
+		if ((mode->vdisplay != adjusted_mode->crtc_vdisplay) ||
+		    (mode->hdisplay != adjusted_mode->crtc_hdisplay)) {
+			if ((adjusted_mode->crtc_hdisplay * mode->vdisplay) ==
+			    (mode->hdisplay * adjusted_mode->crtc_vdisplay))
+				REG_WRITE(PFIT_CONTROL, PFIT_ENABLE);
+			else if ((adjusted_mode->crtc_hdisplay *
+				mode->vdisplay) > (mode->hdisplay *
+				adjusted_mode->crtc_vdisplay))
+				REG_WRITE(PFIT_CONTROL, PFIT_ENABLE |
+					  PFIT_SCALING_MODE_PILLARBOX);
+			else
+				REG_WRITE(PFIT_CONTROL, PFIT_ENABLE |
+					  PFIT_SCALING_MODE_LETTERBOX);
+		} else
+			REG_WRITE(PFIT_CONTROL, PFIT_ENABLE);
+	} else /*(v == DRM_MODE_SCALE_FULLSCREEN)*/
+		REG_WRITE(PFIT_CONTROL, PFIT_ENABLE);
+
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+}
+
+
+static const struct drm_encoder_helper_funcs mrst_lvds_helper_funcs = {
+	.dpms = mrst_lvds_dpms,
+	.mode_fixup = psb_intel_lvds_mode_fixup,
+	.prepare = psb_intel_lvds_prepare,
+	.mode_set = mrst_lvds_mode_set,
+	.commit = psb_intel_lvds_commit,
+};
+
+static struct drm_display_mode lvds_configuration_modes[] = {
+	/* hard coded fixed mode for TPO LTPS LPJ040K001A */
+	{ DRM_MODE("800x480",  DRM_MODE_TYPE_DRIVER, 33264, 800, 836,
+		   846, 1056, 0, 480, 489, 491, 525, 0, 0) },
+	/* hard coded fixed mode for LVDS 800x480 */
+	{ DRM_MODE("800x480",  DRM_MODE_TYPE_DRIVER, 30994, 800, 801,
+		   802, 1024, 0, 480, 481, 482, 525, 0, 0) },
+	/* hard coded fixed mode for Samsung 480wsvga LVDS 1024x600@75 */
+	{ DRM_MODE("1024x600", DRM_MODE_TYPE_DRIVER, 53990, 1024, 1072,
+		   1104, 1184, 0, 600, 603, 604, 608, 0, 0) },
+	/* hard coded fixed mode for Samsung 480wsvga LVDS 1024x600@75 */
+	{ DRM_MODE("1024x600", DRM_MODE_TYPE_DRIVER, 53990, 1024, 1104,
+		   1136, 1184, 0, 600, 603, 604, 608, 0, 0) },
+	/* hard coded fixed mode for Sharp wsvga LVDS 1024x600 */
+	{ DRM_MODE("1024x600", DRM_MODE_TYPE_DRIVER, 48885, 1024, 1124,
+		   1204, 1312, 0, 600, 607, 610, 621, 0, 0) },
+	/* hard coded fixed mode for LVDS 1024x768 */
+	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER, 65000, 1024, 1048,
+		   1184, 1344, 0, 768, 771, 777, 806, 0, 0) },
+	/* hard coded fixed mode for LVDS 1366x768 */
+	{ DRM_MODE("1366x768", DRM_MODE_TYPE_DRIVER, 77500, 1366, 1430,
+		   1558, 1664, 0, 768, 769, 770, 776, 0, 0) },
+};
+
+/* Returns the panel fixed mode from configuration. */
+
+static struct drm_display_mode *
+mrst_lvds_get_configuration_mode(struct drm_device *dev)
+{
+	struct drm_display_mode *mode = NULL;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_timing_info *ti = &dev_priv->gct_data.DTD;
+
+	if (dev_priv->vbt_data.size != 0x00) { /*if non-zero, then use vbt*/
+		mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+		if (!mode)
+			return NULL;
+
+		mode->hdisplay = (ti->hactive_hi << 8) | ti->hactive_lo;
+		mode->vdisplay = (ti->vactive_hi << 8) | ti->vactive_lo;
+		mode->hsync_start = mode->hdisplay + \
+				((ti->hsync_offset_hi << 8) | \
+				ti->hsync_offset_lo);
+		mode->hsync_end = mode->hsync_start + \
+				((ti->hsync_pulse_width_hi << 8) | \
+				ti->hsync_pulse_width_lo);
+		mode->htotal = mode->hdisplay + ((ti->hblank_hi << 8) | \
+							ti->hblank_lo);
+		mode->vsync_start = \
+			mode->vdisplay + ((ti->vsync_offset_hi << 4) | \
+						ti->vsync_offset_lo);
+		mode->vsync_end = \
+			mode->vsync_start + ((ti->vsync_pulse_width_hi << 4) | \
+						ti->vsync_pulse_width_lo);
+		mode->vtotal = mode->vdisplay + \
+				((ti->vblank_hi << 8) | ti->vblank_lo);
+		mode->clock = ti->pixel_clock * 10;
+#if 0
+		printk(KERN_INFO "hdisplay is %d\n", mode->hdisplay);
+		printk(KERN_INFO "vdisplay is %d\n", mode->vdisplay);
+		printk(KERN_INFO "HSS is %d\n", mode->hsync_start);
+		printk(KERN_INFO "HSE is %d\n", mode->hsync_end);
+		printk(KERN_INFO "htotal is %d\n", mode->htotal);
+		printk(KERN_INFO "VSS is %d\n", mode->vsync_start);
+		printk(KERN_INFO "VSE is %d\n", mode->vsync_end);
+		printk(KERN_INFO "vtotal is %d\n", mode->vtotal);
+		printk(KERN_INFO "clock is %d\n", mode->clock);
+#endif
+	} else
+		mode = drm_mode_duplicate(dev, &lvds_configuration_modes[2]);
+
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+
+	return mode;
+}
+
+/**
+ * mrst_lvds_init - setup LVDS connectors on this device
+ * @dev: drm device
+ *
+ * Create the connector, register the LVDS DDC bus, and try to figure out what
+ * modes we can display on the LVDS panel (if present).
+ */
+void mrst_lvds_init(struct drm_device *dev,
+		    struct psb_intel_mode_device *mode_dev)
+{
+	struct psb_intel_output *psb_intel_output;
+	struct drm_connector *connector;
+	struct drm_encoder *encoder;
+	struct drm_psb_private *dev_priv =
+				(struct drm_psb_private *) dev->dev_private;
+	struct edid *edid;
+	int ret = 0;
+	struct i2c_adapter *i2c_adap;
+	struct drm_display_mode *scan;	/* *modes, *bios_mode; */
+
+	PSB_DEBUG_ENTRY("\n");
+
+	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
+	if (!psb_intel_output)
+		return;
+
+	psb_intel_output->mode_dev = mode_dev;
+	connector = &psb_intel_output->base;
+	encoder = &psb_intel_output->enc;
+	dev_priv->is_lvds_on = true;
+	drm_connector_init(dev, &psb_intel_output->base,
+			   &psb_intel_lvds_connector_funcs,
+			   DRM_MODE_CONNECTOR_LVDS);
+
+	drm_encoder_init(dev, &psb_intel_output->enc, &psb_intel_lvds_enc_funcs,
+			 DRM_MODE_ENCODER_LVDS);
+
+	drm_mode_connector_attach_encoder(&psb_intel_output->base,
+					  &psb_intel_output->enc);
+	psb_intel_output->type = INTEL_OUTPUT_LVDS;
+
+	drm_encoder_helper_add(encoder, &mrst_lvds_helper_funcs);
+	drm_connector_helper_add(connector,
+				 &psb_intel_lvds_connector_helper_funcs);
+	connector->display_info.subpixel_order = SubPixelHorizontalRGB;
+	connector->interlace_allowed = false;
+	connector->doublescan_allowed = false;
+
+	drm_connector_attach_property(connector,
+					dev->mode_config.scaling_mode_property,
+					DRM_MODE_SCALE_FULLSCREEN);
+	drm_connector_attach_property(connector,
+					dev_priv->backlight_property,
+					BRIGHTNESS_MAX_LEVEL);
+
+	mode_dev->panel_wants_dither = false;
+	if (dev_priv->vbt_data.size != 0x00)
+		mode_dev->panel_wants_dither = (dev_priv->gct_data.
+			Panel_Port_Control & MRST_PANEL_8TO6_DITHER_ENABLE);
+
+	/*
+	 * LVDS discovery:
+	 * 1) check for EDID on DDC
+	 * 2) check for VBT data
+	 * 3) check to see if LVDS is already on
+	 *    if none of the above, no panel
+	 * 4) make sure lid is open
+	 *    if closed, act like it's not there for now
+	 */
+	i2c_adap = i2c_get_adapter(2);
+	if (i2c_adap == NULL)
+		printk(KERN_ALERT "No ddc adapter available!\n");
+	/*
+	 * Attempt to get the fixed panel mode from DDC.  Assume that the
+	 * preferred mode is the right one.
+	 */
+	if (i2c_adap) {
+		edid = drm_get_edid(connector, i2c_adap);
+		if (edid) {
+			drm_mode_connector_update_edid_property(connector,
+									edid);
+			ret = drm_add_edid_modes(connector, edid);
+			kfree(edid);
+		}
+
+		list_for_each_entry(scan, &connector->probed_modes, head) {
+			if (scan->type & DRM_MODE_TYPE_PREFERRED) {
+				mode_dev->panel_fixed_mode =
+				    drm_mode_duplicate(dev, scan);
+				goto out;	/* FIXME: check for quirks */
+			}
+		}
+	}
+
+	/*
+	 * If we didn't get EDID, try geting panel timing
+	 * from configuration data
+	 */
+	mode_dev->panel_fixed_mode = mrst_lvds_get_configuration_mode(dev);
+
+	if (mode_dev->panel_fixed_mode) {
+		mode_dev->panel_fixed_mode->type |=
+		    DRM_MODE_TYPE_PREFERRED;
+		goto out;	/* FIXME: check for quirks */
+	}
+
+	/* If we still don't have a mode after all that, give up. */
+	if (!mode_dev->panel_fixed_mode) {
+		DRM_DEBUG
+		    ("Found no modes on the lvds, ignoring the LVDS\n");
+		goto failed_find;
+	}
+
+out:
+	drm_sysfs_connector_add(connector);
+	return;
+
+failed_find:
+	DRM_DEBUG("No LVDS modes found, disabling.\n");
+	if (psb_intel_output->ddc_bus)
+		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+
+/* failed_ddc: */
+
+	drm_encoder_cleanup(encoder);
+	drm_connector_cleanup(connector);
+	kfree(connector);
+}
+

