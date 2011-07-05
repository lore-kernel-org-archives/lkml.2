Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1GERz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:55:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44515 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab1GERzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:55:25 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] gma500: oops.. thou shalt stg add...
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 18:45:40 +0100
Message-ID: <20110705174539.28250.30108.stgit@localhost.localdomain>
In-Reply-To: <20110705174527.28250.53338.stgit@localhost.localdomain>
References: <20110705174527.28250.53338.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/cdv_device.h     |   36 +++
 drivers/staging/gma500/cdv_intel_crt.c  |  323 +++++++++++++++++++++++++++
 drivers/staging/gma500/cdv_intel_hdmi.c |  373 +++++++++++++++++++++++++++++++
 3 files changed, 732 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/gma500/cdv_device.h
 create mode 100644 drivers/staging/gma500/cdv_intel_crt.c
 create mode 100644 drivers/staging/gma500/cdv_intel_hdmi.c

diff --git a/drivers/staging/gma500/cdv_device.h b/drivers/staging/gma500/cdv_device.h
new file mode 100644
index 0000000..2a88b7b
--- /dev/null
+++ b/drivers/staging/gma500/cdv_device.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright © 2011 Intel Corporation
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
+extern const struct drm_crtc_helper_funcs cdv_intel_helper_funcs;
+extern const struct drm_crtc_funcs cdv_intel_crtc_funcs;
+extern void cdv_intel_crt_init(struct drm_device *dev,
+			struct psb_intel_mode_device *mode_dev);
+extern void cdv_intel_lvds_init(struct drm_device *dev,
+			struct psb_intel_mode_device *mode_dev);
+extern void cdv_hdmi_init(struct drm_device *dev, struct psb_intel_mode_device *mode_dev,
+			int reg);
+extern struct drm_display_mode *cdv_intel_crtc_mode_get(struct drm_device *dev,
+					     struct drm_crtc *crtc);
+
+extern inline void cdv_intel_wait_for_vblank(struct drm_device *dev)
+{
+	/* Wait for 20ms, i.e. one cycle at 50hz. */
+        /* FIXME: msleep ?? */
+	mdelay(20);
+}
+
+
diff --git a/drivers/staging/gma500/cdv_intel_crt.c b/drivers/staging/gma500/cdv_intel_crt.c
new file mode 100644
index 0000000..e26749c
--- /dev/null
+++ b/drivers/staging/gma500/cdv_intel_crt.c
@@ -0,0 +1,323 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include <linux/i2c.h>
+#include <drm/drmP.h>
+
+#include "intel_bios.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "power.h"
+#include <linux/pm_runtime.h>
+
+
+static void cdv_intel_crt_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct drm_device *dev = encoder->dev;
+	u32 temp, reg;
+	reg = ADPA;
+
+	temp = REG_READ(reg);
+	temp &= ~(ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE);
+	temp &= ~ADPA_DAC_ENABLE;
+
+	switch(mode) {
+	case DRM_MODE_DPMS_ON:
+		temp |= ADPA_DAC_ENABLE;
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+		temp |= ADPA_DAC_ENABLE | ADPA_HSYNC_CNTL_DISABLE;
+		break;
+	case DRM_MODE_DPMS_SUSPEND:
+		temp |= ADPA_DAC_ENABLE | ADPA_VSYNC_CNTL_DISABLE;
+		break;
+	case DRM_MODE_DPMS_OFF:
+		temp |= ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE;
+		break;
+	}
+
+	REG_WRITE(reg, temp);
+}
+
+static int cdv_intel_crt_mode_valid(struct drm_connector *connector,
+				struct drm_display_mode *mode)
+{
+	int max_clock = 0;
+	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
+		return MODE_NO_DBLESCAN;
+
+	/* The lowest clock for CDV is 20000KHz */
+	if (mode->clock < 20000)
+		return MODE_CLOCK_LOW;
+
+	/* The max clock for CDV is 355 instead of 400 */
+	max_clock = 355000;
+	if (mode->clock > max_clock)
+		return MODE_CLOCK_HIGH;
+
+	if (mode->hdisplay > 1680 || mode->vdisplay > 1050)
+		return MODE_PANEL;
+
+	return MODE_OK;
+}
+
+static bool cdv_intel_crt_mode_fixup(struct drm_encoder *encoder,
+				 struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void cdv_intel_crt_mode_set(struct drm_encoder *encoder,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode)
+{
+
+	struct drm_device *dev = encoder->dev;
+	struct drm_crtc *crtc = encoder->crtc;
+	struct psb_intel_crtc *psb_intel_crtc =
+					to_psb_intel_crtc(crtc);
+	int dpll_md_reg;
+	u32 adpa, dpll_md;
+	u32 adpa_reg;
+
+	if (psb_intel_crtc->pipe == 0)
+		dpll_md_reg = DPLL_A_MD;
+	else
+		dpll_md_reg = DPLL_B_MD;
+
+	adpa_reg = ADPA;
+
+	/*
+	 * Disable separate mode multiplier used when cloning SDVO to CRT
+	 * XXX this needs to be adjusted when we really are cloning
+	 */
+	{
+		dpll_md = REG_READ(dpll_md_reg);
+		REG_WRITE(dpll_md_reg,
+			   dpll_md & ~DPLL_MD_UDI_MULTIPLIER_MASK);
+	}
+
+	adpa = 0;
+	if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
+		adpa |= ADPA_HSYNC_ACTIVE_HIGH;
+	if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
+		adpa |= ADPA_VSYNC_ACTIVE_HIGH;
+
+	if (psb_intel_crtc->pipe == 0) {
+		adpa |= ADPA_PIPE_A_SELECT;
+	} else {
+		adpa |= ADPA_PIPE_B_SELECT;
+	}
+
+	REG_WRITE(adpa_reg, adpa);
+}
+
+
+/**
+ * Uses CRT_HOTPLUG_EN and CRT_HOTPLUG_STAT to detect CRT presence.
+ *
+ * \return true if CRT is connected.
+ * \return false if CRT is disconnected.
+ */
+static bool cdv_intel_crt_detect_hotplug(struct drm_connector *connector, bool force)
+{
+	struct drm_device *dev = connector->dev;
+	u32 hotplug_en;
+	int i, tries = 0, ret = false;
+	u32 adpa_orig;
+
+	/* disable the DAC when doing the hotplug detection */
+
+	adpa_orig = REG_READ(ADPA);
+
+	REG_WRITE(ADPA, adpa_orig & ~(ADPA_DAC_ENABLE));
+
+	/*
+	 * On a CDV thep, CRT detect sequence need to be done twice
+	 * to get a reliable result.
+	 */
+	tries = 2;
+
+	hotplug_en = REG_READ(PORT_HOTPLUG_EN);
+	hotplug_en &= ~(CRT_HOTPLUG_DETECT_MASK);
+	hotplug_en |= CRT_HOTPLUG_FORCE_DETECT;
+
+	hotplug_en |= CRT_HOTPLUG_ACTIVATION_PERIOD_64;
+	hotplug_en |= CRT_HOTPLUG_VOLTAGE_COMPARE_50;
+
+	for (i = 0; i < tries ; i++) {
+		unsigned long timeout;
+		/* turn on the FORCE_DETECT */
+		REG_WRITE(PORT_HOTPLUG_EN, hotplug_en);
+		timeout = jiffies + msecs_to_jiffies(1000);
+		/* wait for FORCE_DETECT to go off */
+		do {
+			if (!(REG_READ(PORT_HOTPLUG_EN) &
+					CRT_HOTPLUG_FORCE_DETECT))
+				break;
+			msleep(1);
+		} while (time_after(timeout, jiffies));
+	}
+
+	if ((REG_READ(PORT_HOTPLUG_STAT) & CRT_HOTPLUG_MONITOR_MASK) !=
+	    CRT_HOTPLUG_MONITOR_NONE)
+		ret = true;
+
+	/* Restore the saved ADPA */
+	REG_WRITE(ADPA, adpa_orig);
+	return ret;
+}
+
+static enum drm_connector_status cdv_intel_crt_detect(struct drm_connector *connector, bool force)
+{
+	if (cdv_intel_crt_detect_hotplug(connector, force))
+		return connector_status_connected;
+	else
+		return connector_status_disconnected;
+}
+
+static void cdv_intel_crt_destroy(struct drm_connector *connector)
+{
+	struct psb_intel_output *intel_output = to_psb_intel_output(connector);
+
+	psb_intel_i2c_destroy(intel_output->ddc_bus);
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	kfree(connector);
+}
+
+static int cdv_intel_crt_get_modes(struct drm_connector *connector)
+{
+	struct psb_intel_output *intel_output =
+				to_psb_intel_output(connector);
+	return psb_intel_ddc_get_modes(intel_output);
+}
+
+static int cdv_intel_crt_set_property(struct drm_connector *connector,
+				  struct drm_property *property,
+				  uint64_t value)
+{
+	return 0;
+}
+
+/*
+ * Routines for controlling stuff on the analog port
+ */
+
+static const struct drm_encoder_helper_funcs cdv_intel_crt_helper_funcs = {
+	.dpms = cdv_intel_crt_dpms,
+	.mode_fixup = cdv_intel_crt_mode_fixup,
+	.prepare = psb_intel_encoder_prepare,
+	.commit = psb_intel_encoder_commit,
+	.mode_set = cdv_intel_crt_mode_set,
+};
+
+static const struct drm_connector_funcs cdv_intel_crt_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = cdv_intel_crt_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = cdv_intel_crt_destroy,
+	.set_property = cdv_intel_crt_set_property,
+};
+
+static const struct drm_connector_helper_funcs cdv_intel_crt_connector_helper_funcs = {
+	.mode_valid = cdv_intel_crt_mode_valid,
+	.get_modes = cdv_intel_crt_get_modes,
+	.best_encoder = psb_intel_best_encoder,
+};
+
+static void cdv_intel_crt_enc_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static const struct drm_encoder_funcs cdv_intel_crt_enc_funcs = {
+	.destroy = cdv_intel_crt_enc_destroy,
+};
+
+void cdv_intel_crt_init(struct drm_device *dev,
+			struct psb_intel_mode_device *mode_dev)
+{
+
+	struct psb_intel_output *psb_intel_output;
+	struct drm_connector *connector;
+	struct drm_encoder *encoder;
+
+	u32 i2c_reg;
+
+	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
+	if (!psb_intel_output)
+		return;
+
+	psb_intel_output->mode_dev = mode_dev;
+	connector = &psb_intel_output->base;
+	drm_connector_init(dev, connector,
+			   &cdv_intel_crt_connector_funcs, DRM_MODE_CONNECTOR_VGA);
+
+	encoder = &psb_intel_output->enc;
+	drm_encoder_init(dev, encoder,
+				&cdv_intel_crt_enc_funcs, DRM_MODE_ENCODER_DAC);
+
+	drm_mode_connector_attach_encoder(&psb_intel_output->base,
+					  &psb_intel_output->enc);
+
+	/* Set up the DDC bus. */
+	i2c_reg = GPIOA;
+	/* Remove the following code for CDV */
+	/*
+	if (dev_priv->crt_ddc_bus != 0)
+		i2c_reg = dev_priv->crt_ddc_bus;
+	}*/
+	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
+						i2c_reg, "CRTDDC_A");
+	if (!psb_intel_output->ddc_bus) {
+		dev_printk(KERN_ERR, &dev->pdev->dev, "DDC bus registration "
+			   "failed.\n");
+		goto failed_ddc;
+	}
+
+	psb_intel_output->type = INTEL_OUTPUT_ANALOG;
+	/*
+	psb_intel_output->clone_mask = (1 << INTEL_ANALOG_CLONE_BIT);
+	psb_intel_output->crtc_mask = (1 << 0) | (1 << 1);
+	*/
+	connector->interlace_allowed = 0;
+	connector->doublescan_allowed = 0;
+
+	drm_encoder_helper_add(encoder, &cdv_intel_crt_helper_funcs);
+	drm_connector_helper_add(connector, &cdv_intel_crt_connector_helper_funcs);
+
+	drm_sysfs_connector_add(connector);
+
+	return;
+failed_ddc:
+	drm_encoder_cleanup(&psb_intel_output->enc);
+	drm_connector_cleanup(&psb_intel_output->base);
+	kfree(psb_intel_output);
+	return;
+}
diff --git a/drivers/staging/gma500/cdv_intel_hdmi.c b/drivers/staging/gma500/cdv_intel_hdmi.c
new file mode 100644
index 0000000..5acfb37
--- /dev/null
+++ b/drivers/staging/gma500/cdv_intel_hdmi.c
@@ -0,0 +1,373 @@
+/*
+ * Copyright © 2006-2011 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	jim liu <jim.liu@intel.com>
+ *
+ * FIXME:
+ *	We should probably make this generic and share it with Medfield
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_edid.h>
+#include "psb_intel_drv.h"
+#include "psb_drv.h"
+#include "psb_intel_reg.h"
+#include <linux/pm_runtime.h>
+
+/* hdmi control bits */
+#define HDMI_NULL_PACKETS_DURING_VSYNC	(1 << 9)
+#define HDMI_BORDER_ENABLE		(1 << 7)
+#define HDMI_AUDIO_ENABLE		(1 << 6)
+#define HDMI_VSYNC_ACTIVE_HIGH		(1 << 4)
+#define HDMI_HSYNC_ACTIVE_HIGH		(1 << 3)
+/* hdmi-b control bits */
+#define	HDMIB_PIPE_B_SELECT		(1 << 30)
+
+
+struct mid_intel_hdmi_priv {
+	u32 hdmi_reg;
+	u32 save_HDMIB;
+	bool has_hdmi_sink;
+	bool has_hdmi_audio;
+	/* Should set this when detect hotplug */
+	bool hdmi_device_connected;
+	struct mdfld_hdmi_i2c *i2c_bus;
+	struct i2c_adapter *hdmi_i2c_adapter;	/* for control functions */
+	struct drm_device *dev;
+};
+
+static void cdv_hdmi_mode_set(struct drm_encoder *encoder,
+                        struct drm_display_mode *mode,
+                        struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct mid_intel_hdmi_priv *hdmi_priv = output->dev_priv;
+	u32 hdmib;
+	struct drm_crtc *crtc = encoder->crtc;
+	struct psb_intel_crtc *intel_crtc = to_psb_intel_crtc(crtc);
+
+	hdmib = (2 << 10);
+
+	if (adjusted_mode->flags & DRM_MODE_FLAG_PVSYNC)
+		hdmib |= HDMI_VSYNC_ACTIVE_HIGH;
+	if (adjusted_mode->flags & DRM_MODE_FLAG_PHSYNC)
+		hdmib |= HDMI_HSYNC_ACTIVE_HIGH;
+
+	if (intel_crtc->pipe == 1)
+		hdmib |= HDMIB_PIPE_B_SELECT;
+
+	if (hdmi_priv->has_hdmi_audio) {
+		hdmib |= HDMI_AUDIO_ENABLE;
+		hdmib |= HDMI_NULL_PACKETS_DURING_VSYNC;
+	}
+		
+	REG_WRITE(hdmi_priv->hdmi_reg, hdmib);
+	REG_READ(hdmi_priv->hdmi_reg);
+}
+
+static bool cdv_hdmi_mode_fixup(struct drm_encoder *encoder,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+
+       return true;
+}
+
+static void cdv_hdmi_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct mid_intel_hdmi_priv *hdmi_priv = output->dev_priv;
+	u32 hdmib;
+
+	hdmib = REG_READ(hdmi_priv->hdmi_reg);
+
+	if (mode != DRM_MODE_DPMS_ON) {
+		REG_WRITE(hdmi_priv->hdmi_reg, hdmib & ~HDMIB_PORT_EN);
+	} else {
+		REG_WRITE(hdmi_priv->hdmi_reg, hdmib | HDMIB_PORT_EN);
+	}
+	REG_READ(hdmi_priv->hdmi_reg);
+}
+
+static void cdv_hdmi_save(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct psb_intel_output *output = to_psb_intel_output(connector);
+	struct mid_intel_hdmi_priv *hdmi_priv = output->dev_priv;
+
+	hdmi_priv->save_HDMIB = REG_READ(hdmi_priv->hdmi_reg);
+}
+
+static void cdv_hdmi_restore(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct psb_intel_output *output = to_psb_intel_output(connector);
+	struct mid_intel_hdmi_priv *hdmi_priv = output->dev_priv;
+
+	REG_WRITE(hdmi_priv->hdmi_reg, hdmi_priv->save_HDMIB);
+	REG_READ(hdmi_priv->hdmi_reg);
+}
+
+static enum drm_connector_status cdv_hdmi_detect(struct drm_connector *connector, bool force)
+{
+	struct drm_device *dev = connector->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_output *psb_intel_output = to_psb_intel_output(connector);
+	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_output->dev_priv;
+	struct edid *edid = NULL;
+	enum drm_connector_status status = connector_status_disconnected;
+
+	edid = drm_get_edid(&psb_intel_output->base,
+			 psb_intel_output->hdmi_i2c_adapter);
+
+	hdmi_priv->has_hdmi_sink = false;
+	hdmi_priv->has_hdmi_audio = false;
+	if (edid) {
+		if (edid->input & DRM_EDID_INPUT_DIGITAL) {
+			status = connector_status_connected;
+			hdmi_priv->has_hdmi_sink = drm_detect_hdmi_monitor(edid);
+			hdmi_priv->has_hdmi_audio = drm_detect_monitor_audio(edid);
+		}
+
+		psb_intel_output->base.display_info.raw_edid = NULL;
+		kfree(edid);
+	}
+	return status;
+}
+
+static int cdv_hdmi_set_property(struct drm_connector *connector,
+				       struct drm_property *property,
+				       uint64_t value)
+{
+	struct drm_encoder *encoder = connector->encoder;
+
+	if (!strcmp(property->name, "scaling mode") && encoder) {
+		struct psb_intel_crtc *crtc = to_psb_intel_crtc(encoder->crtc);
+		bool centre;
+		uint64_t curValue;
+
+		if (!crtc)
+		        return -1;
+
+		switch (value) {
+		case DRM_MODE_SCALE_FULLSCREEN:
+			break;
+		case DRM_MODE_SCALE_NO_SCALE:
+			break;
+		case DRM_MODE_SCALE_ASPECT:
+			break;
+		default:
+		        return -1;
+		}
+
+		if (drm_connector_property_get_value(connector, property, &curValue))
+		        return -1;
+
+		if (curValue == value)
+		        return 0;
+
+		if (drm_connector_property_set_value(connector, property, value))
+		        return -1;
+
+		centre = (curValue == DRM_MODE_SCALE_NO_SCALE) ||
+			(value == DRM_MODE_SCALE_NO_SCALE);
+
+		if (crtc->saved_mode.hdisplay != 0 &&
+		    crtc->saved_mode.vdisplay != 0) {
+			if (centre) {
+				if (!drm_crtc_helper_set_mode(encoder->crtc, &crtc->saved_mode,
+					    encoder->crtc->x, encoder->crtc->y, encoder->crtc->fb))
+					return -1;
+			} else {
+				struct drm_encoder_helper_funcs *helpers  = encoder->helper_private;
+				helpers->mode_set(encoder, &crtc->saved_mode,
+						     &crtc->saved_adjusted_mode);
+			}
+		}
+	}
+	return 0;
+}
+
+/*
+ * Return the list of HDMI DDC modes if available.
+ */
+static int cdv_hdmi_get_modes(struct drm_connector *connector)
+{
+	struct psb_intel_output *psb_intel_output = to_psb_intel_output(connector);
+	struct edid *edid = NULL;
+	int ret = 0;
+
+	edid = drm_get_edid(&psb_intel_output->base,
+			 psb_intel_output->hdmi_i2c_adapter);
+	if (edid) {
+		drm_mode_connector_update_edid_property(&psb_intel_output->
+							base, edid);
+		ret = drm_add_edid_modes(&psb_intel_output->base, edid);
+		kfree(edid);
+	}
+	return ret;
+}
+
+static int cdv_hdmi_mode_valid(struct drm_connector *connector,
+				 struct drm_display_mode *mode)
+{
+
+	if (mode->clock > 165000)
+		return MODE_CLOCK_HIGH;
+	if (mode->clock < 20000)
+		return MODE_CLOCK_HIGH;
+
+	/* just in case */
+	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
+		return MODE_NO_DBLESCAN;
+
+	/* just in case */
+	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
+		return MODE_NO_INTERLACE;
+
+	/*
+	 * FIXME: fornow we limit the size to 1680x1050 on CDV, otherwise it will
+	 * go beyond the stolen memory size allocated to the Framebuffer
+	 */
+	if (mode->hdisplay > 1680)
+		return MODE_PANEL;
+	if (mode->vdisplay > 1050)
+		return MODE_PANEL;
+	return MODE_OK;
+}
+
+static void cdv_hdmi_destroy(struct drm_connector *connector)
+{
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+
+	if (psb_intel_output->ddc_bus)
+		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	kfree(connector);
+}
+
+static const struct drm_encoder_helper_funcs cdv_hdmi_helper_funcs = {
+	.dpms = cdv_hdmi_dpms,
+	.mode_fixup = cdv_hdmi_mode_fixup,
+	.prepare = psb_intel_encoder_prepare,
+	.mode_set = cdv_hdmi_mode_set,
+	.commit = psb_intel_encoder_commit,
+};
+
+static const struct drm_connector_helper_funcs cdv_hdmi_connector_helper_funcs = {
+	.get_modes = cdv_hdmi_get_modes,
+	.mode_valid = cdv_hdmi_mode_valid,
+	.best_encoder = psb_intel_best_encoder,
+};
+
+static const struct drm_connector_funcs cdv_hdmi_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.save = cdv_hdmi_save,
+	.restore = cdv_hdmi_restore,
+	.detect = cdv_hdmi_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = cdv_hdmi_set_property,
+	.destroy = cdv_hdmi_destroy,
+};
+
+void cdv_hdmi_init(struct drm_device *dev, struct psb_intel_mode_device *mode_dev, int reg)
+{
+	struct psb_intel_output *psb_intel_output;
+	struct drm_connector *connector;
+	struct drm_encoder *encoder;
+	struct mid_intel_hdmi_priv *hdmi_priv;
+	int ddc_bus;
+
+	psb_intel_output = kzalloc(sizeof(struct psb_intel_output) +
+			       sizeof(struct mid_intel_hdmi_priv), GFP_KERNEL);
+	if (!psb_intel_output)
+		return;
+
+	hdmi_priv = (struct mid_intel_hdmi_priv *)(psb_intel_output + 1);
+	psb_intel_output->mode_dev = mode_dev;
+	connector = &psb_intel_output->base;
+	encoder = &psb_intel_output->enc;
+	drm_connector_init(dev, &psb_intel_output->base,
+			   &cdv_hdmi_connector_funcs,
+			   DRM_MODE_CONNECTOR_DVID);
+
+	drm_encoder_init(dev, &psb_intel_output->enc, &psb_intel_lvds_enc_funcs,
+			 DRM_MODE_ENCODER_TMDS);
+
+	drm_mode_connector_attach_encoder(&psb_intel_output->base,
+					  &psb_intel_output->enc);
+	psb_intel_output->type = INTEL_OUTPUT_HDMI;
+	hdmi_priv->hdmi_reg = reg;
+	hdmi_priv->has_hdmi_sink = false;
+	psb_intel_output->dev_priv = hdmi_priv;
+
+	drm_encoder_helper_add(encoder, &cdv_hdmi_helper_funcs);
+	drm_connector_helper_add(connector,
+				 &cdv_hdmi_connector_helper_funcs);
+	connector->display_info.subpixel_order = SubPixelHorizontalRGB;
+	connector->interlace_allowed = false;
+	connector->doublescan_allowed = false;
+
+	drm_connector_attach_property(connector, dev->mode_config.scaling_mode_property, DRM_MODE_SCALE_FULLSCREEN);
+
+	switch (reg) {
+	case SDVOB:
+		ddc_bus = GPIOE;
+		break;
+	case SDVOC:
+		ddc_bus = GPIOD;
+		break;
+	default:
+		DRM_ERROR("unknown reg 0x%x for HDMI\n", reg);
+		goto failed_ddc;
+		break;
+	}
+
+	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
+						ddc_bus, (reg == SDVOB) ? "HDMIB":"HDMIC");
+
+	if (psb_intel_output->ddc_bus) {
+     		/* HACKS_JLIU7 */
+		DRM_INFO("Enter cdv_hdmi_init, i2c_adapter is availabe.\n");
+
+	} else {
+		printk(KERN_ALERT "No ddc adapter available!\n");
+		goto failed_ddc;
+	}
+	psb_intel_output->hdmi_i2c_adapter = &(psb_intel_output->ddc_bus->adapter);
+
+	hdmi_priv->dev = dev; 
+	drm_sysfs_connector_add(connector);
+	return;
+
+failed_ddc:
+	drm_encoder_cleanup(&psb_intel_output->enc);
+	drm_connector_cleanup(&psb_intel_output->base);
+	kfree(psb_intel_output);
+}

