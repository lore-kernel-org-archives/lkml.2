Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1J0WD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:03:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56876 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab1J0WCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:53 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=206/9=5D=20gma500=3A=20Replace=20SDVO=20code=20with=20slightly=20modified=20version=20from=20i915?=
Date: Fri, 28 Oct 2011 00:02:11 +0200
Message-Id: <1319752934-1919-7-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our current SDVO implementation is not working properly, so replace it with
a modified version of the i915.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/psb_drv.h             |   19 +
 drivers/staging/gma500/psb_intel_display.c   |    8 +
 drivers/staging/gma500/psb_intel_drv.h       |   41 +-
 drivers/staging/gma500/psb_intel_reg.h       |    2 +
 drivers/staging/gma500/psb_intel_sdvo.c      | 3059 ++++++++++++++++++--------
 drivers/staging/gma500/psb_intel_sdvo_regs.h |  591 ++++-
 6 files changed, 2744 insertions(+), 976 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index cf078db..7b91cd0 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -261,6 +261,16 @@ struct psb_intel_opregion {
 	int enabled;
 };
 
+struct sdvo_device_mapping {
+	u8 initialized;
+	u8 dvo_port;
+	u8 slave_addr;
+	u8 dvo_wiring;
+	u8 i2c_pin;
+	u8 i2c_speed;
+	u8 ddc_pin;
+};
+
 struct intel_gmbus {
 	struct i2c_adapter adapter;
 	struct i2c_adapter *force_bit;
@@ -346,6 +356,15 @@ struct drm_psb_private {
 	/* gmbus */
 	struct intel_gmbus *gmbus;
 
+	/* Used by SDVO */
+	int crt_ddc_pin;
+	/* FIXME: The mappings should be parsed from bios but for now we can
+		  pretend there are no mappings available */
+	struct sdvo_device_mapping sdvo_mappings[2];
+	u32 hotplug_supported_mask;
+	struct drm_property *broadcast_rgb_property;
+	struct drm_property *force_audio_property;
+
 	/*
 	 * LVDS info
 	 */
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 61887e9..fde56a7 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -554,6 +554,14 @@ void psb_intel_encoder_commit(struct drm_encoder *encoder)
 	encoder_funcs->dpms(encoder, DRM_MODE_DPMS_ON);
 }
 
+void psb_intel_encoder_destroy(struct drm_encoder *encoder)
+{
+	struct psb_intel_encoder *intel_encoder = to_psb_intel_encoder(encoder);
+
+	drm_encoder_cleanup(encoder);
+	kfree(intel_encoder);
+}
+
 static bool psb_intel_crtc_mode_fixup(struct drm_crtc *crtc,
 				  struct drm_display_mode *mode,
 				  struct drm_display_mode *adjusted_mode)
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index 492add1..f027431 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -39,6 +39,25 @@
 #define INTEL_I2C_BUS_DVO 1
 #define INTEL_I2C_BUS_SDVO 2
 
+/* Intel Pipe Clone Bit */
+#define INTEL_HDMIB_CLONE_BIT 1
+#define INTEL_HDMIC_CLONE_BIT 2
+#define INTEL_HDMID_CLONE_BIT 3
+#define INTEL_HDMIE_CLONE_BIT 4
+#define INTEL_HDMIF_CLONE_BIT 5
+#define INTEL_SDVO_NON_TV_CLONE_BIT 6
+#define INTEL_SDVO_TV_CLONE_BIT 7
+#define INTEL_SDVO_LVDS_CLONE_BIT 8
+#define INTEL_ANALOG_CLONE_BIT 9
+#define INTEL_TV_CLONE_BIT 10
+#define INTEL_DP_B_CLONE_BIT 11
+#define INTEL_DP_C_CLONE_BIT 12
+#define INTEL_DP_D_CLONE_BIT 13
+#define INTEL_LVDS_CLONE_BIT 14
+#define INTEL_DVO_TMDS_CLONE_BIT 15
+#define INTEL_DVO_LVDS_CLONE_BIT 16
+#define INTEL_EDP_CLONE_BIT 17
+
 /* these are outputs from the chip - integrated only
  * external chips are via DVO or SDVO output */
 #define INTEL_OUTPUT_UNUSED 0
@@ -56,6 +75,25 @@
 #define INTEL_DVO_CHIP_TMDS 2
 #define INTEL_DVO_CHIP_TVOUT 4
 
+#define INTEL_MODE_PIXEL_MULTIPLIER_SHIFT (0x0)
+#define INTEL_MODE_PIXEL_MULTIPLIER_MASK (0xf << INTEL_MODE_PIXEL_MULTIPLIER_SHIFT)
+
+static inline void
+psb_intel_mode_set_pixel_multiplier(struct drm_display_mode *mode,
+				int multiplier)
+{
+	mode->clock *= multiplier;
+	mode->private_flags |= multiplier;
+}
+
+static inline int
+psb_intel_mode_get_pixel_multiplier(const struct drm_display_mode *mode)
+{
+	return (mode->private_flags & INTEL_MODE_PIXEL_MULTIPLIER_MASK)
+	       >> INTEL_MODE_PIXEL_MULTIPLIER_SHIFT;
+}
+
+
 /*
  * Hold information useally put on the device driver privates here,
  * since it needs to be shared across multiple of devices drivers privates.
@@ -173,7 +211,7 @@ extern bool psb_intel_ddc_probe(struct i2c_adapter *adapter);
 extern void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 			    struct psb_intel_mode_device *mode_dev);
 extern void psb_intel_crt_init(struct drm_device *dev);
-extern void psb_intel_sdvo_init(struct drm_device *dev, int output_device);
+extern bool psb_intel_sdvo_init(struct drm_device *dev, int output_device);
 extern void psb_intel_dvo_init(struct drm_device *dev);
 extern void psb_intel_tv_init(struct drm_device *dev);
 extern void psb_intel_lvds_init(struct drm_device *dev,
@@ -190,6 +228,7 @@ extern void mid_dsi_init(struct drm_device *dev,
 extern void psb_intel_crtc_load_lut(struct drm_crtc *crtc);
 extern void psb_intel_encoder_prepare(struct drm_encoder *encoder);
 extern void psb_intel_encoder_commit(struct drm_encoder *encoder);
+extern void psb_intel_encoder_destroy(struct drm_encoder *encoder);
 
 static inline struct psb_intel_encoder *psb_intel_attached_encoder(
 						struct drm_connector *connector)
diff --git a/drivers/staging/gma500/psb_intel_reg.h b/drivers/staging/gma500/psb_intel_reg.h
index f5c19f5..fcc0af0 100644
--- a/drivers/staging/gma500/psb_intel_reg.h
+++ b/drivers/staging/gma500/psb_intel_reg.h
@@ -376,6 +376,8 @@
 #define SDVO_PIPE_B_SELECT		(1 << 30)
 #define SDVO_STALL_SELECT		(1 << 29)
 #define SDVO_INTERRUPT_ENABLE		(1 << 26)
+#define SDVO_COLOR_RANGE_16_235		(1 << 8)
+#define SDVO_AUDIO_ENABLE		(1 << 6)
 
 /**
  * 915G/GM SDVO pixel multiplier.
diff --git a/drivers/staging/gma500/psb_intel_sdvo.c b/drivers/staging/gma500/psb_intel_sdvo.c
index a4bad1a..52d1e7a 100644
--- a/drivers/staging/gma500/psb_intel_sdvo.c
+++ b/drivers/staging/gma500/psb_intel_sdvo.c
@@ -1,76 +1,244 @@
 /*
- * Copyright (c) 2006-2007 Intel Corporation
+ * Copyright 2006 Dave Airlie <airlied@linux.ie>
+ * Copyright © 2006-2007 Intel Corporation
+ *   Jesse Barnes <jesse.barnes@intel.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
  *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
  *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
  *
  * Authors:
  *	Eric Anholt <eric@anholt.net>
  */
-
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
-/* #include <drm/drm_crtc.h> */
-#include <drm/drmP.h>
-#include "psb_drv.h"
+#include "drmP.h"
+#include "drm.h"
+#include "drm_crtc.h"
+#include "drm_edid.h"
 #include "psb_intel_drv.h"
-#include "psb_intel_reg.h"
+#include "psb_drm.h"
+#include "psb_drv.h"
 #include "psb_intel_sdvo_regs.h"
+#include "psb_intel_reg.h"
+
+#define SDVO_TMDS_MASK (SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_TMDS1)
+#define SDVO_RGB_MASK  (SDVO_OUTPUT_RGB0 | SDVO_OUTPUT_RGB1)
+#define SDVO_LVDS_MASK (SDVO_OUTPUT_LVDS0 | SDVO_OUTPUT_LVDS1)
+#define SDVO_TV_MASK   (SDVO_OUTPUT_CVBS0 | SDVO_OUTPUT_SVID0)
+
+#define SDVO_OUTPUT_MASK (SDVO_TMDS_MASK | SDVO_RGB_MASK | SDVO_LVDS_MASK |\
+                         SDVO_TV_MASK)
+
+#define IS_TV(c)	(c->output_flag & SDVO_TV_MASK)
+#define IS_TMDS(c)	(c->output_flag & SDVO_TMDS_MASK)
+#define IS_LVDS(c)	(c->output_flag & SDVO_LVDS_MASK)
+#define IS_TV_OR_LVDS(c) (c->output_flag & (SDVO_TV_MASK | SDVO_LVDS_MASK))
 
-struct psb_intel_sdvo_priv {
-	struct psb_intel_i2c_chan *i2c_bus;
-	int slaveaddr;
-	int output_device;
 
-	u16 active_outputs;
+static const char *tv_format_names[] = {
+	"NTSC_M"   , "NTSC_J"  , "NTSC_443",
+	"PAL_B"    , "PAL_D"   , "PAL_G"   ,
+	"PAL_H"    , "PAL_I"   , "PAL_M"   ,
+	"PAL_N"    , "PAL_NC"  , "PAL_60"  ,
+	"SECAM_B"  , "SECAM_D" , "SECAM_G" ,
+	"SECAM_K"  , "SECAM_K1", "SECAM_L" ,
+	"SECAM_60"
+};
+
+#define TV_FORMAT_NUM  (sizeof(tv_format_names) / sizeof(*tv_format_names))
+
+struct psb_intel_sdvo {
+	struct psb_intel_encoder base;
+
+	struct i2c_adapter *i2c;
+	u8 slave_addr;
 
+	struct i2c_adapter ddc;
+
+	/* Register for the SDVO device: SDVOB or SDVOC */
+	int sdvo_reg;
+
+	/* Active outputs controlled by this SDVO output */
+	uint16_t controlled_output;
+
+	/*
+	 * Capabilities of the SDVO device returned by
+	 * i830_sdvo_get_capabilities()
+	 */
 	struct psb_intel_sdvo_caps caps;
+
+	/* Pixel clock limitations reported by the SDVO device, in kHz */
 	int pixel_clock_min, pixel_clock_max;
 
-	int save_sdvo_mult;
-	u16 save_active_outputs;
-	struct psb_intel_sdvo_dtd save_input_dtd_1, save_input_dtd_2;
-	struct psb_intel_sdvo_dtd save_output_dtd[16];
-	u32 save_SDVOX;
-	u8 in_out_map[4];
+	/*
+	* For multiple function SDVO device,
+	* this is for current attached outputs.
+	*/
+	uint16_t attached_output;
+
+	/**
+	 * This is used to select the color range of RBG outputs in HDMI mode.
+	 * It is only valid when using TMDS encoding and 8 bit per color mode.
+	 */
+	uint32_t color_range;
+
+	/**
+	 * This is set if we're going to treat the device as TV-out.
+	 *
+	 * While we have these nice friendly flags for output types that ought
+	 * to decide this for us, the S-Video output on our HDMI+S-Video card
+	 * shows up as RGB1 (VGA).
+	 */
+	bool is_tv;
+
+	/* This is for current tv format name */
+	int tv_format_index;
+
+	/**
+	 * This is set if we treat the device as HDMI, instead of DVI.
+	 */
+	bool is_hdmi;
+	bool has_hdmi_monitor;
+	bool has_hdmi_audio;
+
+	/**
+	 * This is set if we detect output of sdvo device as LVDS and
+	 * have a valid fixed mode to use with the panel.
+	 */
+	bool is_lvds;
+
+	/**
+	 * This is sdvo fixed pannel mode pointer
+	 */
+	struct drm_display_mode *sdvo_lvds_fixed_mode;
+
+	/* DDC bus used by this SDVO encoder */
+	uint8_t ddc_bus;
+
+	/* Input timings for adjusted_mode */
+	struct psb_intel_sdvo_dtd input_dtd;
+};
 
-	u8 by_input_wiring;
-	u32 active_device;
+struct psb_intel_sdvo_connector {
+	struct psb_intel_connector base;
+
+	/* Mark the type of connector */
+	uint16_t output_flag;
+
+	int force_audio;
+
+	/* This contains all current supported TV format */
+	u8 tv_format_supported[TV_FORMAT_NUM];
+	int   format_supported_num;
+	struct drm_property *tv_format;
+
+	/* add the property for the SDVO-TV */
+	struct drm_property *left;
+	struct drm_property *right;
+	struct drm_property *top;
+	struct drm_property *bottom;
+	struct drm_property *hpos;
+	struct drm_property *vpos;
+	struct drm_property *contrast;
+	struct drm_property *saturation;
+	struct drm_property *hue;
+	struct drm_property *sharpness;
+	struct drm_property *flicker_filter;
+	struct drm_property *flicker_filter_adaptive;
+	struct drm_property *flicker_filter_2d;
+	struct drm_property *tv_chroma_filter;
+	struct drm_property *tv_luma_filter;
+	struct drm_property *dot_crawl;
+
+	/* add the property for the SDVO-TV/LVDS */
+	struct drm_property *brightness;
+
+	/* Add variable to record current setting for the above property */
+	u32	left_margin, right_margin, top_margin, bottom_margin;
+
+	/* this is to get the range of margin.*/
+	u32	max_hscan,  max_vscan;
+	u32	max_hpos, cur_hpos;
+	u32	max_vpos, cur_vpos;
+	u32	cur_brightness, max_brightness;
+	u32	cur_contrast,	max_contrast;
+	u32	cur_saturation, max_saturation;
+	u32	cur_hue,	max_hue;
+	u32	cur_sharpness,	max_sharpness;
+	u32	cur_flicker_filter,		max_flicker_filter;
+	u32	cur_flicker_filter_adaptive,	max_flicker_filter_adaptive;
+	u32	cur_flicker_filter_2d,		max_flicker_filter_2d;
+	u32	cur_tv_chroma_filter,	max_tv_chroma_filter;
+	u32	cur_tv_luma_filter,	max_tv_luma_filter;
+	u32	cur_dot_crawl,	max_dot_crawl;
 };
 
+static struct psb_intel_sdvo *to_psb_intel_sdvo(struct drm_encoder *encoder)
+{
+	return container_of(encoder, struct psb_intel_sdvo, base.base);
+}
+
+static struct psb_intel_sdvo *intel_attached_sdvo(struct drm_connector *connector)
+{
+	return container_of(psb_intel_attached_encoder(connector),
+			    struct psb_intel_sdvo, base);
+}
+
+static struct psb_intel_sdvo_connector *to_psb_intel_sdvo_connector(struct drm_connector *connector)
+{
+	return container_of(to_psb_intel_connector(connector), struct psb_intel_sdvo_connector, base);
+}
+
+static bool
+psb_intel_sdvo_output_setup(struct psb_intel_sdvo *psb_intel_sdvo, uint16_t flags);
+static bool
+psb_intel_sdvo_tv_create_property(struct psb_intel_sdvo *psb_intel_sdvo,
+			      struct psb_intel_sdvo_connector *psb_intel_sdvo_connector,
+			      int type);
+static bool
+psb_intel_sdvo_create_enhance_property(struct psb_intel_sdvo *psb_intel_sdvo,
+				   struct psb_intel_sdvo_connector *psb_intel_sdvo_connector);
+
 /**
  * Writes the SDVOB or SDVOC with the given value, but always writes both
  * SDVOB and SDVOC to work around apparent hardware issues (according to
  * comments in the BIOS).
  */
-void psb_intel_sdvo_write_sdvox(struct psb_intel_output *psb_intel_output,
-				u32 val)
+static void psb_intel_sdvo_write_sdvox(struct psb_intel_sdvo *psb_intel_sdvo, u32 val)
 {
-	struct drm_device *dev = psb_intel_output->base.dev;
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	struct drm_device *dev = psb_intel_sdvo->base.base.dev;
 	u32 bval = val, cval = val;
 	int i;
 
-	if (sdvo_priv->output_device == SDVOB)
+	if (psb_intel_sdvo->sdvo_reg == SDVOB) {
 		cval = REG_READ(SDVOC);
-	else
+	} else {
 		bval = REG_READ(SDVOB);
+	}
 	/*
 	 * Write the registers twice for luck. Sometimes,
 	 * writing them only once doesn't appear to 'stick'.
 	 * The BIOS does this too. Yay, magic
 	 */
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < 2; i++)
+	{
 		REG_WRITE(SDVOB, bval);
 		REG_READ(SDVOB);
 		REG_WRITE(SDVOC, cval);
@@ -78,61 +246,28 @@ void psb_intel_sdvo_write_sdvox(struct psb_intel_output *psb_intel_output,
 	}
 }
 
-static bool psb_intel_sdvo_read_byte(
-				struct psb_intel_output *psb_intel_output,
-				u8 addr, u8 *ch)
+static bool psb_intel_sdvo_read_byte(struct psb_intel_sdvo *psb_intel_sdvo, u8 addr, u8 *ch)
 {
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
-	u8 out_buf[2];
-	u8 buf[2];
-	int ret;
-
 	struct i2c_msg msgs[] = {
 		{
-		 .addr = sdvo_priv->i2c_bus->slave_addr,
-		 .flags = 0,
-		 .len = 1,
-		 .buf = out_buf,
-		 },
+			.addr = psb_intel_sdvo->slave_addr,
+			.flags = 0,
+			.len = 1,
+			.buf = &addr,
+		},
 		{
-		 .addr = sdvo_priv->i2c_bus->slave_addr,
-		 .flags = I2C_M_RD,
-		 .len = 1,
-		 .buf = buf,
-		 }
+			.addr = psb_intel_sdvo->slave_addr,
+			.flags = I2C_M_RD,
+			.len = 1,
+			.buf = ch,
+		}
 	};
+	int ret;
 
-	out_buf[0] = addr;
-	out_buf[1] = 0;
-
-	ret = i2c_transfer(&sdvo_priv->i2c_bus->adapter, msgs, 2);
-	if (ret == 2) {
-		*ch = buf[0];
+	if ((ret = i2c_transfer(psb_intel_sdvo->i2c, msgs, 2)) == 2)
 		return true;
-	}
-
-	return false;
-}
-
-static bool psb_intel_sdvo_write_byte(
-			struct psb_intel_output *psb_intel_output,
-			int addr, u8 ch)
-{
-	u8 out_buf[2];
-	struct i2c_msg msgs[] = {
-		{
-		 .addr = psb_intel_output->i2c_bus->slave_addr,
-		 .flags = 0,
-		 .len = 2,
-		 .buf = out_buf,
-		 }
-	};
 
-	out_buf[0] = addr;
-	out_buf[1] = ch;
-
-	if (i2c_transfer(&psb_intel_output->i2c_bus->adapter, msgs, 1) == 1)
-		return true;
+	DRM_DEBUG_KMS("i2c transfer returned %d\n", ret);
 	return false;
 }
 
@@ -140,98 +275,147 @@ static bool psb_intel_sdvo_write_byte(
 /** Mapping of command numbers to names, for debug output */
 static const struct _sdvo_cmd_name {
 	u8 cmd;
-	char *name;
+	const char *name;
 } sdvo_cmd_names[] = {
-SDVO_CMD_NAME_ENTRY(SDVO_CMD_RESET),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DEVICE_CAPS),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FIRMWARE_REV),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TRAINED_INPUTS),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_OUTPUTS),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_OUTPUTS),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_IN_OUT_MAP),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_IN_OUT_MAP),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ATTACHED_DISPLAYS),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HOT_PLUG_SUPPORT),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_HOT_PLUG),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_HOT_PLUG),
-	    SDVO_CMD_NAME_ENTRY
-	    (SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_INPUT),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_OUTPUT),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART1),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART2),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART2),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART1),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART2),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART1),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART2),
-	    SDVO_CMD_NAME_ENTRY
-	    (SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING),
-	    SDVO_CMD_NAME_ENTRY
-	    (SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1),
-	    SDVO_CMD_NAME_ENTRY
-	    (SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2),
-	    SDVO_CMD_NAME_ENTRY
-	    (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE),
-	    SDVO_CMD_NAME_ENTRY
-	    (SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE),
-	    SDVO_CMD_NAME_ENTRY
-	    (SDVO_CMD_GET_SUPPORTED_CLOCK_RATE_MULTS),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CLOCK_RATE_MULT),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CLOCK_RATE_MULT),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_TV_FORMATS),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_FORMAT),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_FORMAT),
-	    SDVO_CMD_NAME_ENTRY
-	    (SDVO_CMD_SET_TV_RESOLUTION_SUPPORT),
-	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTROL_BUS_SWITCH),};
-
-#define SDVO_NAME(dev_priv) \
-		 ((dev_priv)->output_device == SDVOB ? "SDVOB" : "SDVOC")
-#define SDVO_PRIV(output)   ((struct psb_intel_sdvo_priv *) (output)->dev_priv)
-
-static void psb_intel_sdvo_write_cmd(struct psb_intel_output *psb_intel_output,
-				     u8 cmd,
-				     void *args,
-				     int args_len)
-{
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_RESET),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DEVICE_CAPS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FIRMWARE_REV),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TRAINED_INPUTS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_OUTPUTS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_OUTPUTS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_IN_OUT_MAP),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_IN_OUT_MAP),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ATTACHED_DISPLAYS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HOT_PLUG_SUPPORT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_HOT_PLUG),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_HOT_PLUG),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_INPUT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_OUTPUT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_CLOCK_RATE_MULTS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CLOCK_RATE_MULT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CLOCK_RATE_MULT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_TV_FORMATS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_FORMAT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_FORMAT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_POWER_STATES),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_POWER_STATE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ENCODER_POWER_STATE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_DISPLAY_POWER_STATE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTROL_BUS_SWITCH),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SDTV_RESOLUTION_SUPPORT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SCALED_HDTV_RESOLUTION_SUPPORT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS),
+
+    /* Add the op code for SDVO enhancements */
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_HPOS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HPOS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HPOS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_VPOS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_VPOS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_VPOS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_SATURATION),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SATURATION),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_SATURATION),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_HUE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HUE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HUE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_CONTRAST),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CONTRAST),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTRAST),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_BRIGHTNESS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_BRIGHTNESS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_BRIGHTNESS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_OVERSCAN_H),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OVERSCAN_H),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OVERSCAN_H),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_OVERSCAN_V),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OVERSCAN_V),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OVERSCAN_V),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER_ADAPTIVE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_FLICKER_FILTER_2D),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FLICKER_FILTER_2D),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_FLICKER_FILTER_2D),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_SHARPNESS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SHARPNESS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_SHARPNESS),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DOT_CRAWL),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_DOT_CRAWL),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_TV_CHROMA_FILTER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_CHROMA_FILTER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_CHROMA_FILTER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_MAX_TV_LUMA_FILTER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_LUMA_FILTER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_LUMA_FILTER),
+
+    /* HDMI op code */
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPP_ENCODE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ENCODE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ENCODE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_PIXEL_REPLI),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_PIXEL_REPLI),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_COLORIMETRY_CAP),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_COLORIMETRY),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_COLORIMETRY),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_AUDIO_ENCRYPT_PREFER),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_AUDIO_STAT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_AUDIO_STAT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_INDEX),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_INDEX),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_INFO),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_AV_SPLIT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_AV_SPLIT),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_TXRATE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_TXRATE),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_HBUF_DATA),
+    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HBUF_DATA),
+};
+
+#define IS_SDVOB(reg)	(reg == SDVOB)
+#define SDVO_NAME(svdo) (IS_SDVOB((svdo)->sdvo_reg) ? "SDVOB" : "SDVOC")
+
+static void psb_intel_sdvo_debug_write(struct psb_intel_sdvo *psb_intel_sdvo, u8 cmd,
+				   const void *args, int args_len)
+{
 	int i;
 
-	if (0) {
-		printk(KERN_DEBUG "%s: W: %02X ", SDVO_NAME(sdvo_priv), cmd);
-		for (i = 0; i < args_len; i++)
-			printk(KERN_CONT "%02X ", ((u8 *) args)[i]);
-		for (; i < 8; i++)
-			printk(KERN_CONT "   ");
-		for (i = 0;
-		     i <
-		     sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]);
-		     i++) {
-			if (cmd == sdvo_cmd_names[i].cmd) {
-				printk(KERN_CONT
-					"(%s)", sdvo_cmd_names[i].name);
-				break;
-			}
+	DRM_DEBUG_KMS("%s: W: %02X ",
+				SDVO_NAME(psb_intel_sdvo), cmd);
+	for (i = 0; i < args_len; i++)
+		DRM_LOG_KMS("%02X ", ((u8 *)args)[i]);
+	for (; i < 8; i++)
+		DRM_LOG_KMS("   ");
+	for (i = 0; i < ARRAY_SIZE(sdvo_cmd_names); i++) {
+		if (cmd == sdvo_cmd_names[i].cmd) {
+			DRM_LOG_KMS("(%s)", sdvo_cmd_names[i].name);
+			break;
 		}
-		if (i ==
-		    sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]))
-			printk(KERN_CONT "(%02X)", cmd);
-		printk(KERN_CONT "\n");
-	}
-
-	for (i = 0; i < args_len; i++) {
-		psb_intel_sdvo_write_byte(psb_intel_output,
-					SDVO_I2C_ARG_0 - i,
-					((u8 *) args)[i]);
 	}
-
-	psb_intel_sdvo_write_byte(psb_intel_output, SDVO_I2C_OPCODE, cmd);
+	if (i == ARRAY_SIZE(sdvo_cmd_names))
+		DRM_LOG_KMS("(%02X)", cmd);
+	DRM_LOG_KMS("\n");
 }
 
-static const char *const cmd_status_names[] = {
+static const char *cmd_status_names[] = {
 	"Power on",
 	"Success",
 	"Not supported",
@@ -241,52 +425,111 @@ static const char *const cmd_status_names[] = {
 	"Scaling not supported"
 };
 
-static u8 psb_intel_sdvo_read_response(
-				struct psb_intel_output *psb_intel_output,
-				void *response, int response_len)
+static bool psb_intel_sdvo_write_cmd(struct psb_intel_sdvo *psb_intel_sdvo, u8 cmd,
+				 const void *args, int args_len)
 {
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
-	int i;
+	u8 buf[args_len*2 + 2], status;
+	struct i2c_msg msgs[args_len + 3];
+	int i, ret;
+
+	psb_intel_sdvo_debug_write(psb_intel_sdvo, cmd, args, args_len);
+
+	for (i = 0; i < args_len; i++) {
+		msgs[i].addr = psb_intel_sdvo->slave_addr;
+		msgs[i].flags = 0;
+		msgs[i].len = 2;
+		msgs[i].buf = buf + 2 *i;
+		buf[2*i + 0] = SDVO_I2C_ARG_0 - i;
+		buf[2*i + 1] = ((u8*)args)[i];
+	}
+	msgs[i].addr = psb_intel_sdvo->slave_addr;
+	msgs[i].flags = 0;
+	msgs[i].len = 2;
+	msgs[i].buf = buf + 2*i;
+	buf[2*i + 0] = SDVO_I2C_OPCODE;
+	buf[2*i + 1] = cmd;
+
+	/* the following two are to read the response */
+	status = SDVO_I2C_CMD_STATUS;
+	msgs[i+1].addr = psb_intel_sdvo->slave_addr;
+	msgs[i+1].flags = 0;
+	msgs[i+1].len = 1;
+	msgs[i+1].buf = &status;
+
+	msgs[i+2].addr = psb_intel_sdvo->slave_addr;
+	msgs[i+2].flags = I2C_M_RD;
+	msgs[i+2].len = 1;
+	msgs[i+2].buf = &status;
+
+	ret = i2c_transfer(psb_intel_sdvo->i2c, msgs, i+3);
+	if (ret < 0) {
+		DRM_DEBUG_KMS("I2c transfer returned %d\n", ret);
+		return false;
+	}
+	if (ret != i+3) {
+		/* failure in I2C transfer */
+		DRM_DEBUG_KMS("I2c transfer returned %d/%d\n", ret, i+3);
+		return false;
+	}
+
+	return true;
+}
+
+static bool psb_intel_sdvo_read_response(struct psb_intel_sdvo *psb_intel_sdvo,
+				     void *response, int response_len)
+{
+	u8 retry = 5;
 	u8 status;
-	u8 retry = 50;
-
-	while (retry--) {
-		/* Read the command response */
-		for (i = 0; i < response_len; i++) {
-			psb_intel_sdvo_read_byte(psb_intel_output,
-					     SDVO_I2C_RETURN_0 + i,
-					     &((u8 *) response)[i]);
-		}
+	int i;
 
-		/* read the return status */
-		psb_intel_sdvo_read_byte(psb_intel_output,
-					 SDVO_I2C_CMD_STATUS,
-					 &status);
-
-		if (0) {
-			pr_debug("%s: R: ", SDVO_NAME(sdvo_priv));
-			for (i = 0; i < response_len; i++)
-				printk(KERN_CONT "%02X ", ((u8 *) response)[i]);
-			for (; i < 8; i++)
-				printk("   ");
-			if (status <= SDVO_CMD_STATUS_SCALING_NOT_SUPP)
-				printk(KERN_CONT "(%s)",
-					 cmd_status_names[status]);
-			else
-				printk(KERN_CONT "(??? %d)", status);
-			printk(KERN_CONT "\n");
-		}
+	DRM_DEBUG_KMS("%s: R: ", SDVO_NAME(psb_intel_sdvo));
+
+	/*
+	 * The documentation states that all commands will be
+	 * processed within 15µs, and that we need only poll
+	 * the status byte a maximum of 3 times in order for the
+	 * command to be complete.
+	 *
+	 * Check 5 times in case the hardware failed to read the docs.
+	 */
+	if (!psb_intel_sdvo_read_byte(psb_intel_sdvo,
+				  SDVO_I2C_CMD_STATUS,
+				  &status))
+		goto log_fail;
+
+	while (status == SDVO_CMD_STATUS_PENDING && retry--) {
+		udelay(15);
+		if (!psb_intel_sdvo_read_byte(psb_intel_sdvo,
+					  SDVO_I2C_CMD_STATUS,
+					  &status))
+			goto log_fail;
+	}
 
-		if (status != SDVO_CMD_STATUS_PENDING)
-			return status;
+	if (status <= SDVO_CMD_STATUS_SCALING_NOT_SUPP)
+		DRM_LOG_KMS("(%s)", cmd_status_names[status]);
+	else
+		DRM_LOG_KMS("(??? %d)", status);
 
-		mdelay(50);
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		goto log_fail;
+
+	/* Read the command response */
+	for (i = 0; i < response_len; i++) {
+		if (!psb_intel_sdvo_read_byte(psb_intel_sdvo,
+					  SDVO_I2C_RETURN_0 + i,
+					  &((u8 *)response)[i]))
+			goto log_fail;
+		DRM_LOG_KMS(" %02X", ((u8 *)response)[i]);
 	}
+	DRM_LOG_KMS("\n");
+	return true;
 
-	return status;
+log_fail:
+	DRM_LOG_KMS("... failed\n");
+	return false;
 }
 
-int psb_intel_sdvo_get_pixel_multiplier(struct drm_display_mode *mode)
+static int psb_intel_sdvo_get_pixel_multiplier(struct drm_display_mode *mode)
 {
 	if (mode->clock >= 100000)
 		return 1;
@@ -296,40 +539,38 @@ int psb_intel_sdvo_get_pixel_multiplier(struct drm_display_mode *mode)
 		return 4;
 }
 
-/**
- * Don't check status code from this as it switches the bus back to the
- * SDVO chips which defeats the purpose of doing a bus switch in the first
- * place.
- */
-void psb_intel_sdvo_set_control_bus_switch(
-				struct psb_intel_output *psb_intel_output,
-				u8 target)
+static bool psb_intel_sdvo_set_control_bus_switch(struct psb_intel_sdvo *psb_intel_sdvo,
+					      u8 ddc_bus)
 {
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				 SDVO_CMD_SET_CONTROL_BUS_SWITCH,
-				 &target,
-				 1);
+	/* This must be the immediately preceding write before the i2c xfer */
+	return psb_intel_sdvo_write_cmd(psb_intel_sdvo,
+				    SDVO_CMD_SET_CONTROL_BUS_SWITCH,
+				    &ddc_bus, 1);
 }
 
-static bool psb_intel_sdvo_set_target_input(
-				struct psb_intel_output *psb_intel_output,
-				bool target_0, bool target_1)
+static bool psb_intel_sdvo_set_value(struct psb_intel_sdvo *psb_intel_sdvo, u8 cmd, const void *data, int len)
 {
-	struct psb_intel_sdvo_set_target_input_args targets = { 0 };
-	u8 status;
-
-	if (target_0 && target_1)
-		return SDVO_CMD_STATUS_NOTSUPP;
+	if (!psb_intel_sdvo_write_cmd(psb_intel_sdvo, cmd, data, len))
+		return false;
 
-	if (target_1)
-		targets.target_1 = 1;
+	return psb_intel_sdvo_read_response(psb_intel_sdvo, NULL, 0);
+}
 
-	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_SET_TARGET_INPUT,
-			     &targets, sizeof(targets));
+static bool
+psb_intel_sdvo_get_value(struct psb_intel_sdvo *psb_intel_sdvo, u8 cmd, void *value, int len)
+{
+	if (!psb_intel_sdvo_write_cmd(psb_intel_sdvo, cmd, NULL, 0))
+		return false;
 
-	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+	return psb_intel_sdvo_read_response(psb_intel_sdvo, value, len);
+}
 
-	return status == SDVO_CMD_STATUS_SUCCESS;
+static bool psb_intel_sdvo_set_target_input(struct psb_intel_sdvo *psb_intel_sdvo)
+{
+	struct psb_intel_sdvo_set_target_input_args targets = {0};
+	return psb_intel_sdvo_set_value(psb_intel_sdvo,
+				    SDVO_CMD_SET_TARGET_INPUT,
+				    &targets, sizeof(targets));
 }
 
 /**
@@ -338,19 +579,13 @@ static bool psb_intel_sdvo_set_target_input(
  * This function is making an assumption about the layout of the response,
  * which should be checked against the docs.
  */
-static bool psb_intel_sdvo_get_trained_inputs(struct psb_intel_output
-					  *psb_intel_output, bool *input_1,
-					  bool *input_2)
+static bool psb_intel_sdvo_get_trained_inputs(struct psb_intel_sdvo *psb_intel_sdvo, bool *input_1, bool *input_2)
 {
 	struct psb_intel_sdvo_get_trained_inputs_response response;
-	u8 status;
 
-	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_GET_TRAINED_INPUTS,
-			     NULL, 0);
-	status =
-	    psb_intel_sdvo_read_response(psb_intel_output, &response,
-				     sizeof(response));
-	if (status != SDVO_CMD_STATUS_SUCCESS)
+	BUILD_BUG_ON(sizeof(response) != 1);
+	if (!psb_intel_sdvo_get_value(psb_intel_sdvo, SDVO_CMD_GET_TRAINED_INPUTS,
+				  &response, sizeof(response)))
 		return false;
 
 	*input_1 = response.input0_trained;
@@ -358,35 +593,18 @@ static bool psb_intel_sdvo_get_trained_inputs(struct psb_intel_output
 	return true;
 }
 
-static bool psb_intel_sdvo_get_active_outputs(struct psb_intel_output
-					  *psb_intel_output, u16 *outputs)
-{
-	u8 status;
-
-	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_GET_ACTIVE_OUTPUTS,
-			     NULL, 0);
-	status =
-	    psb_intel_sdvo_read_response(psb_intel_output, outputs,
-				     sizeof(*outputs));
-
-	return status == SDVO_CMD_STATUS_SUCCESS;
-}
-
-static bool psb_intel_sdvo_set_active_outputs(struct psb_intel_output
-					  *psb_intel_output, u16 outputs)
+static bool psb_intel_sdvo_set_active_outputs(struct psb_intel_sdvo *psb_intel_sdvo,
+					  u16 outputs)
 {
-	u8 status;
-
-	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_SET_ACTIVE_OUTPUTS,
-			     &outputs, sizeof(outputs));
-	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
-	return status == SDVO_CMD_STATUS_SUCCESS;
+	return psb_intel_sdvo_set_value(psb_intel_sdvo,
+				    SDVO_CMD_SET_ACTIVE_OUTPUTS,
+				    &outputs, sizeof(outputs));
 }
 
-static bool psb_intel_sdvo_set_encoder_power_state(struct psb_intel_output
-					       *psb_intel_output, int mode)
+static bool psb_intel_sdvo_set_encoder_power_state(struct psb_intel_sdvo *psb_intel_sdvo,
+					       int mode)
 {
-	u8 status, state = SDVO_ENCODER_STATE_ON;
+	u8 state = SDVO_ENCODER_STATE_ON;
 
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
@@ -403,260 +621,360 @@ static bool psb_intel_sdvo_set_encoder_power_state(struct psb_intel_output
 		break;
 	}
 
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-			     SDVO_CMD_SET_ENCODER_POWER_STATE, &state,
-			     sizeof(state));
-	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
-
-	return status == SDVO_CMD_STATUS_SUCCESS;
+	return psb_intel_sdvo_set_value(psb_intel_sdvo,
+				    SDVO_CMD_SET_ENCODER_POWER_STATE, &state, sizeof(state));
 }
 
-static bool psb_intel_sdvo_get_input_pixel_clock_range(struct psb_intel_output
-						   *psb_intel_output,
+static bool psb_intel_sdvo_get_input_pixel_clock_range(struct psb_intel_sdvo *psb_intel_sdvo,
 						   int *clock_min,
 						   int *clock_max)
 {
 	struct psb_intel_sdvo_pixel_clock_range clocks;
-	u8 status;
 
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-			     SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE, NULL,
-			     0);
-
-	status =
-	    psb_intel_sdvo_read_response(psb_intel_output, &clocks,
-				     sizeof(clocks));
-
-	if (status != SDVO_CMD_STATUS_SUCCESS)
+	BUILD_BUG_ON(sizeof(clocks) != 4);
+	if (!psb_intel_sdvo_get_value(psb_intel_sdvo,
+				  SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE,
+				  &clocks, sizeof(clocks)))
 		return false;
 
 	/* Convert the values from units of 10 kHz to kHz. */
 	*clock_min = clocks.min * 10;
 	*clock_max = clocks.max * 10;
-
 	return true;
 }
 
-static bool psb_intel_sdvo_set_target_output(
-				struct psb_intel_output *psb_intel_output,
-				u16 outputs)
+static bool psb_intel_sdvo_set_target_output(struct psb_intel_sdvo *psb_intel_sdvo,
+					 u16 outputs)
 {
-	u8 status;
-
-	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_SET_TARGET_OUTPUT,
-			     &outputs, sizeof(outputs));
+	return psb_intel_sdvo_set_value(psb_intel_sdvo,
+				    SDVO_CMD_SET_TARGET_OUTPUT,
+				    &outputs, sizeof(outputs));
+}
 
-	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
-	return status == SDVO_CMD_STATUS_SUCCESS;
+static bool psb_intel_sdvo_set_timing(struct psb_intel_sdvo *psb_intel_sdvo, u8 cmd,
+				  struct psb_intel_sdvo_dtd *dtd)
+{
+	return psb_intel_sdvo_set_value(psb_intel_sdvo, cmd, &dtd->part1, sizeof(dtd->part1)) &&
+		psb_intel_sdvo_set_value(psb_intel_sdvo, cmd + 1, &dtd->part2, sizeof(dtd->part2));
 }
 
-static bool psb_intel_sdvo_get_timing(struct psb_intel_output *psb_intel_output,
-				  u8 cmd, struct psb_intel_sdvo_dtd *dtd)
+static bool psb_intel_sdvo_set_input_timing(struct psb_intel_sdvo *psb_intel_sdvo,
+					 struct psb_intel_sdvo_dtd *dtd)
 {
-	u8 status;
+	return psb_intel_sdvo_set_timing(psb_intel_sdvo,
+				     SDVO_CMD_SET_INPUT_TIMINGS_PART1, dtd);
+}
 
-	psb_intel_sdvo_write_cmd(psb_intel_output, cmd, NULL, 0);
-	status = psb_intel_sdvo_read_response(psb_intel_output, &dtd->part1,
-					  sizeof(dtd->part1));
-	if (status != SDVO_CMD_STATUS_SUCCESS)
-		return false;
+static bool psb_intel_sdvo_set_output_timing(struct psb_intel_sdvo *psb_intel_sdvo,
+					 struct psb_intel_sdvo_dtd *dtd)
+{
+	return psb_intel_sdvo_set_timing(psb_intel_sdvo,
+				     SDVO_CMD_SET_OUTPUT_TIMINGS_PART1, dtd);
+}
 
-	psb_intel_sdvo_write_cmd(psb_intel_output, cmd + 1, NULL, 0);
-	status = psb_intel_sdvo_read_response(psb_intel_output, &dtd->part2,
-					  sizeof(dtd->part2));
-	if (status != SDVO_CMD_STATUS_SUCCESS)
-		return false;
+static bool
+psb_intel_sdvo_create_preferred_input_timing(struct psb_intel_sdvo *psb_intel_sdvo,
+					 uint16_t clock,
+					 uint16_t width,
+					 uint16_t height)
+{
+	struct psb_intel_sdvo_preferred_input_timing_args args;
+
+	memset(&args, 0, sizeof(args));
+	args.clock = clock;
+	args.width = width;
+	args.height = height;
+	args.interlace = 0;
+
+	if (psb_intel_sdvo->is_lvds &&
+	   (psb_intel_sdvo->sdvo_lvds_fixed_mode->hdisplay != width ||
+	    psb_intel_sdvo->sdvo_lvds_fixed_mode->vdisplay != height))
+		args.scaled = 1;
+
+	return psb_intel_sdvo_set_value(psb_intel_sdvo,
+				    SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING,
+				    &args, sizeof(args));
+}
 
-	return true;
+static bool psb_intel_sdvo_get_preferred_input_timing(struct psb_intel_sdvo *psb_intel_sdvo,
+						  struct psb_intel_sdvo_dtd *dtd)
+{
+	BUILD_BUG_ON(sizeof(dtd->part1) != 8);
+	BUILD_BUG_ON(sizeof(dtd->part2) != 8);
+	return psb_intel_sdvo_get_value(psb_intel_sdvo, SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1,
+				    &dtd->part1, sizeof(dtd->part1)) &&
+		psb_intel_sdvo_get_value(psb_intel_sdvo, SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2,
+				     &dtd->part2, sizeof(dtd->part2));
 }
 
-static bool psb_intel_sdvo_get_input_timing(
-				struct psb_intel_output *psb_intel_output,
-				struct psb_intel_sdvo_dtd *dtd)
+static bool psb_intel_sdvo_set_clock_rate_mult(struct psb_intel_sdvo *psb_intel_sdvo, u8 val)
 {
-	return psb_intel_sdvo_get_timing(psb_intel_output,
-				     SDVO_CMD_GET_INPUT_TIMINGS_PART1,
-				     dtd);
+	return psb_intel_sdvo_set_value(psb_intel_sdvo, SDVO_CMD_SET_CLOCK_RATE_MULT, &val, 1);
 }
 
-static bool psb_intel_sdvo_set_timing(
-				struct psb_intel_output *psb_intel_output,
-				u8 cmd,
-				struct psb_intel_sdvo_dtd *dtd)
+static void psb_intel_sdvo_get_dtd_from_mode(struct psb_intel_sdvo_dtd *dtd,
+					 const struct drm_display_mode *mode)
 {
-	u8 status;
+	uint16_t width, height;
+	uint16_t h_blank_len, h_sync_len, v_blank_len, v_sync_len;
+	uint16_t h_sync_offset, v_sync_offset;
 
-	psb_intel_sdvo_write_cmd(psb_intel_output, cmd, &dtd->part1,
-			     sizeof(dtd->part1));
-	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
-	if (status != SDVO_CMD_STATUS_SUCCESS)
-		return false;
+	width = mode->crtc_hdisplay;
+	height = mode->crtc_vdisplay;
 
-	psb_intel_sdvo_write_cmd(psb_intel_output, cmd + 1, &dtd->part2,
-			     sizeof(dtd->part2));
-	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
-	if (status != SDVO_CMD_STATUS_SUCCESS)
-		return false;
+	/* do some mode translations */
+	h_blank_len = mode->crtc_hblank_end - mode->crtc_hblank_start;
+	h_sync_len = mode->crtc_hsync_end - mode->crtc_hsync_start;
 
-	return true;
+	v_blank_len = mode->crtc_vblank_end - mode->crtc_vblank_start;
+	v_sync_len = mode->crtc_vsync_end - mode->crtc_vsync_start;
+
+	h_sync_offset = mode->crtc_hsync_start - mode->crtc_hblank_start;
+	v_sync_offset = mode->crtc_vsync_start - mode->crtc_vblank_start;
+
+	dtd->part1.clock = mode->clock / 10;
+	dtd->part1.h_active = width & 0xff;
+	dtd->part1.h_blank = h_blank_len & 0xff;
+	dtd->part1.h_high = (((width >> 8) & 0xf) << 4) |
+		((h_blank_len >> 8) & 0xf);
+	dtd->part1.v_active = height & 0xff;
+	dtd->part1.v_blank = v_blank_len & 0xff;
+	dtd->part1.v_high = (((height >> 8) & 0xf) << 4) |
+		((v_blank_len >> 8) & 0xf);
+
+	dtd->part2.h_sync_off = h_sync_offset & 0xff;
+	dtd->part2.h_sync_width = h_sync_len & 0xff;
+	dtd->part2.v_sync_off_width = (v_sync_offset & 0xf) << 4 |
+		(v_sync_len & 0xf);
+	dtd->part2.sync_off_width_high = ((h_sync_offset & 0x300) >> 2) |
+		((h_sync_len & 0x300) >> 4) | ((v_sync_offset & 0x30) >> 2) |
+		((v_sync_len & 0x30) >> 4);
+
+	dtd->part2.dtd_flags = 0x18;
+	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+		dtd->part2.dtd_flags |= 0x2;
+	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+		dtd->part2.dtd_flags |= 0x4;
+
+	dtd->part2.sdvo_flags = 0;
+	dtd->part2.v_sync_off_high = v_sync_offset & 0xc0;
+	dtd->part2.reserved = 0;
 }
 
-static bool psb_intel_sdvo_set_input_timing(
-				struct psb_intel_output *psb_intel_output,
-				struct psb_intel_sdvo_dtd *dtd)
+static void psb_intel_sdvo_get_mode_from_dtd(struct drm_display_mode * mode,
+					 const struct psb_intel_sdvo_dtd *dtd)
 {
-	return psb_intel_sdvo_set_timing(psb_intel_output,
-				     SDVO_CMD_SET_INPUT_TIMINGS_PART1,
-				     dtd);
+	mode->hdisplay = dtd->part1.h_active;
+	mode->hdisplay += ((dtd->part1.h_high >> 4) & 0x0f) << 8;
+	mode->hsync_start = mode->hdisplay + dtd->part2.h_sync_off;
+	mode->hsync_start += (dtd->part2.sync_off_width_high & 0xc0) << 2;
+	mode->hsync_end = mode->hsync_start + dtd->part2.h_sync_width;
+	mode->hsync_end += (dtd->part2.sync_off_width_high & 0x30) << 4;
+	mode->htotal = mode->hdisplay + dtd->part1.h_blank;
+	mode->htotal += (dtd->part1.h_high & 0xf) << 8;
+
+	mode->vdisplay = dtd->part1.v_active;
+	mode->vdisplay += ((dtd->part1.v_high >> 4) & 0x0f) << 8;
+	mode->vsync_start = mode->vdisplay;
+	mode->vsync_start += (dtd->part2.v_sync_off_width >> 4) & 0xf;
+	mode->vsync_start += (dtd->part2.sync_off_width_high & 0x0c) << 2;
+	mode->vsync_start += dtd->part2.v_sync_off_high & 0xc0;
+	mode->vsync_end = mode->vsync_start +
+		(dtd->part2.v_sync_off_width & 0xf);
+	mode->vsync_end += (dtd->part2.sync_off_width_high & 0x3) << 4;
+	mode->vtotal = mode->vdisplay + dtd->part1.v_blank;
+	mode->vtotal += (dtd->part1.v_high & 0xf) << 8;
+
+	mode->clock = dtd->part1.clock * 10;
+
+	mode->flags &= ~(DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC);
+	if (dtd->part2.dtd_flags & 0x2)
+		mode->flags |= DRM_MODE_FLAG_PHSYNC;
+	if (dtd->part2.dtd_flags & 0x4)
+		mode->flags |= DRM_MODE_FLAG_PVSYNC;
 }
 
-static bool psb_intel_sdvo_set_output_timing(
-				struct psb_intel_output *psb_intel_output,
-				struct psb_intel_sdvo_dtd *dtd)
+static bool psb_intel_sdvo_check_supp_encode(struct psb_intel_sdvo *psb_intel_sdvo)
 {
-	return psb_intel_sdvo_set_timing(psb_intel_output,
-				     SDVO_CMD_SET_OUTPUT_TIMINGS_PART1,
-				     dtd);
+	struct psb_intel_sdvo_encode encode;
+
+	BUILD_BUG_ON(sizeof(encode) != 2);
+	return psb_intel_sdvo_get_value(psb_intel_sdvo,
+				  SDVO_CMD_GET_SUPP_ENCODE,
+				  &encode, sizeof(encode));
 }
 
-static int psb_intel_sdvo_get_clock_rate_mult(struct psb_intel_output
-						*psb_intel_output)
+static bool psb_intel_sdvo_set_encode(struct psb_intel_sdvo *psb_intel_sdvo,
+				  uint8_t mode)
 {
-	u8 response, status;
-
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				 SDVO_CMD_GET_CLOCK_RATE_MULT,
-				 NULL,
-				 0);
+	return psb_intel_sdvo_set_value(psb_intel_sdvo, SDVO_CMD_SET_ENCODE, &mode, 1);
+}
 
-	status = psb_intel_sdvo_read_response(psb_intel_output, &response, 1);
+static bool psb_intel_sdvo_set_colorimetry(struct psb_intel_sdvo *psb_intel_sdvo,
+				       uint8_t mode)
+{
+	return psb_intel_sdvo_set_value(psb_intel_sdvo, SDVO_CMD_SET_COLORIMETRY, &mode, 1);
+}
 
-	if (status != SDVO_CMD_STATUS_SUCCESS) {
-		DRM_DEBUG("Couldn't get SDVO clock rate multiplier\n");
-		return SDVO_CLOCK_RATE_MULT_1X;
-	} else {
-		DRM_DEBUG("Current clock rate multiplier: %d\n", response);
+#if 0
+static void psb_intel_sdvo_dump_hdmi_buf(struct psb_intel_sdvo *psb_intel_sdvo)
+{
+	int i, j;
+	uint8_t set_buf_index[2];
+	uint8_t av_split;
+	uint8_t buf_size;
+	uint8_t buf[48];
+	uint8_t *pos;
+
+	psb_intel_sdvo_get_value(encoder, SDVO_CMD_GET_HBUF_AV_SPLIT, &av_split, 1);
+
+	for (i = 0; i <= av_split; i++) {
+		set_buf_index[0] = i; set_buf_index[1] = 0;
+		psb_intel_sdvo_write_cmd(encoder, SDVO_CMD_SET_HBUF_INDEX,
+				     set_buf_index, 2);
+		psb_intel_sdvo_write_cmd(encoder, SDVO_CMD_GET_HBUF_INFO, NULL, 0);
+		psb_intel_sdvo_read_response(encoder, &buf_size, 1);
+
+		pos = buf;
+		for (j = 0; j <= buf_size; j += 8) {
+			psb_intel_sdvo_write_cmd(encoder, SDVO_CMD_GET_HBUF_DATA,
+					     NULL, 0);
+			psb_intel_sdvo_read_response(encoder, pos, 8);
+			pos += 8;
+		}
 	}
-
-	return response;
 }
+#endif
 
-static bool psb_intel_sdvo_set_clock_rate_mult(struct psb_intel_output
-						*psb_intel_output, u8 val)
+static bool psb_intel_sdvo_set_avi_infoframe(struct psb_intel_sdvo *psb_intel_sdvo)
 {
-	u8 status;
+	DRM_INFO("HDMI is not supported yet");
+
+	return false;
+#if 0
+	struct dip_infoframe avi_if = {
+		.type = DIP_TYPE_AVI,
+		.ver = DIP_VERSION_AVI,
+		.len = DIP_LEN_AVI,
+	};
+	uint8_t tx_rate = SDVO_HBUF_TX_VSYNC;
+	uint8_t set_buf_index[2] = { 1, 0 };
+	uint64_t *data = (uint64_t *)&avi_if;
+	unsigned i;
 
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				SDVO_CMD_SET_CLOCK_RATE_MULT,
-				&val,
-				1);
+	intel_dip_infoframe_csum(&avi_if);
 
-	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
-	if (status != SDVO_CMD_STATUS_SUCCESS)
+	if (!psb_intel_sdvo_set_value(psb_intel_sdvo,
+				  SDVO_CMD_SET_HBUF_INDEX,
+				  set_buf_index, 2))
 		return false;
 
-	return true;
+	for (i = 0; i < sizeof(avi_if); i += 8) {
+		if (!psb_intel_sdvo_set_value(psb_intel_sdvo,
+					  SDVO_CMD_SET_HBUF_DATA,
+					  data, 8))
+			return false;
+		data++;
+	}
+
+	return psb_intel_sdvo_set_value(psb_intel_sdvo,
+				    SDVO_CMD_SET_HBUF_TXRATE,
+				    &tx_rate, 1);
+#endif
 }
 
-static bool psb_sdvo_set_current_inoutmap(struct psb_intel_output *output,
-					  u32 in0outputmask,
-					  u32 in1outputmask)
+static bool psb_intel_sdvo_set_tv_format(struct psb_intel_sdvo *psb_intel_sdvo)
 {
-	u8 byArgs[4];
-	u8 status;
-	int i;
-	struct psb_intel_sdvo_priv *sdvo_priv = output->dev_priv;
-
-	/* Make all fields of the  args/ret to zero */
-	memset(byArgs, 0, sizeof(byArgs));
+	struct psb_intel_sdvo_tv_format format;
+	uint32_t format_map;
 
-	/* Fill up the argument values; */
-	byArgs[0] = (u8) (in0outputmask & 0xFF);
-	byArgs[1] = (u8) ((in0outputmask >> 8) & 0xFF);
-	byArgs[2] = (u8) (in1outputmask & 0xFF);
-	byArgs[3] = (u8) ((in1outputmask >> 8) & 0xFF);
+	format_map = 1 << psb_intel_sdvo->tv_format_index;
+	memset(&format, 0, sizeof(format));
+	memcpy(&format, &format_map, min(sizeof(format), sizeof(format_map)));
 
+	BUILD_BUG_ON(sizeof(format) != 6);
+	return psb_intel_sdvo_set_value(psb_intel_sdvo,
+				    SDVO_CMD_SET_TV_FORMAT,
+				    &format, sizeof(format));
+}
 
-	/*save inoutmap arg here*/
-	for (i = 0; i < 4; i++)
-		sdvo_priv->in_out_map[i] = byArgs[0];
+static bool
+psb_intel_sdvo_set_output_timings_from_mode(struct psb_intel_sdvo *psb_intel_sdvo,
+					struct drm_display_mode *mode)
+{
+	struct psb_intel_sdvo_dtd output_dtd;
 
-	psb_intel_sdvo_write_cmd(output, SDVO_CMD_SET_IN_OUT_MAP, byArgs, 4);
-	status = psb_intel_sdvo_read_response(output, NULL, 0);
+	if (!psb_intel_sdvo_set_target_output(psb_intel_sdvo,
+					  psb_intel_sdvo->attached_output))
+		return false;
 
-	if (status != SDVO_CMD_STATUS_SUCCESS)
+	psb_intel_sdvo_get_dtd_from_mode(&output_dtd, mode);
+	if (!psb_intel_sdvo_set_output_timing(psb_intel_sdvo, &output_dtd))
 		return false;
+
 	return true;
 }
 
-
-static void psb_intel_sdvo_set_iomap(struct psb_intel_output *output)
+static bool
+psb_intel_sdvo_set_input_timings_for_mode(struct psb_intel_sdvo *psb_intel_sdvo,
+					struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted_mode)
 {
-	u32 dwCurrentSDVOIn0 = 0;
-	u32 dwCurrentSDVOIn1 = 0;
-	u32 dwDevMask = 0;
+	/* Reset the input timing to the screen. Assume always input 0. */
+	if (!psb_intel_sdvo_set_target_input(psb_intel_sdvo))
+		return false;
 
+	if (!psb_intel_sdvo_create_preferred_input_timing(psb_intel_sdvo,
+						      mode->clock / 10,
+						      mode->hdisplay,
+						      mode->vdisplay))
+		return false;
 
-	struct psb_intel_sdvo_priv *sdvo_priv = output->dev_priv;
+	if (!psb_intel_sdvo_get_preferred_input_timing(psb_intel_sdvo,
+						   &psb_intel_sdvo->input_dtd))
+		return false;
 
-	/* Please DO NOT change the following code. */
-	/* SDVOB_IN0 or SDVOB_IN1 ==> sdvo_in0 */
-	/* SDVOC_IN0 or SDVOC_IN1 ==> sdvo_in1 */
-	if (sdvo_priv->by_input_wiring & (SDVOB_IN0 | SDVOC_IN0)) {
-		switch (sdvo_priv->active_device) {
-		case SDVO_DEVICE_LVDS:
-			dwDevMask = SDVO_OUTPUT_LVDS0 | SDVO_OUTPUT_LVDS1;
-			break;
-		case SDVO_DEVICE_TMDS:
-			dwDevMask = SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_TMDS1;
-			break;
-		case SDVO_DEVICE_TV:
-			dwDevMask =
-			SDVO_OUTPUT_YPRPB0 | SDVO_OUTPUT_SVID0 |
-			SDVO_OUTPUT_CVBS0 | SDVO_OUTPUT_YPRPB1 |
-			SDVO_OUTPUT_SVID1 | SDVO_OUTPUT_CVBS1 |
-			SDVO_OUTPUT_SCART0 | SDVO_OUTPUT_SCART1;
-			break;
-		case SDVO_DEVICE_CRT:
-			dwDevMask = SDVO_OUTPUT_RGB0 | SDVO_OUTPUT_RGB1;
-			break;
-		}
-		dwCurrentSDVOIn0 = (sdvo_priv->active_outputs & dwDevMask);
-	} else if (sdvo_priv->by_input_wiring & (SDVOB_IN1 | SDVOC_IN1)) {
-		switch (sdvo_priv->active_device) {
-		case SDVO_DEVICE_LVDS:
-			dwDevMask = SDVO_OUTPUT_LVDS0 | SDVO_OUTPUT_LVDS1;
-			break;
-		case SDVO_DEVICE_TMDS:
-			dwDevMask = SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_TMDS1;
-			break;
-		case SDVO_DEVICE_TV:
-			dwDevMask =
-			SDVO_OUTPUT_YPRPB0 | SDVO_OUTPUT_SVID0 |
-			SDVO_OUTPUT_CVBS0 | SDVO_OUTPUT_YPRPB1 |
-			SDVO_OUTPUT_SVID1 | SDVO_OUTPUT_CVBS1 |
-			SDVO_OUTPUT_SCART0 | SDVO_OUTPUT_SCART1;
-			break;
-		case SDVO_DEVICE_CRT:
-			dwDevMask = SDVO_OUTPUT_RGB0 | SDVO_OUTPUT_RGB1;
-			break;
-		}
-		dwCurrentSDVOIn1 = (sdvo_priv->active_outputs & dwDevMask);
-	}
+	psb_intel_sdvo_get_mode_from_dtd(adjusted_mode, &psb_intel_sdvo->input_dtd);
 
-	psb_sdvo_set_current_inoutmap(output, dwCurrentSDVOIn0,
-					  dwCurrentSDVOIn1);
+	drm_mode_set_crtcinfo(adjusted_mode, 0);
+	return true;
 }
 
-
 static bool psb_intel_sdvo_mode_fixup(struct drm_encoder *encoder,
 				  struct drm_display_mode *mode,
 				  struct drm_display_mode *adjusted_mode)
 {
-	/* Make the CRTC code factor in the SDVO pixel multiplier.  The SDVO
-	 * device will be told of the multiplier during mode_set.
+	struct psb_intel_sdvo *psb_intel_sdvo = to_psb_intel_sdvo(encoder);
+	int multiplier;
+
+	/* We need to construct preferred input timings based on our
+	 * output timings.  To do that, we have to set the output
+	 * timings, even though this isn't really the right place in
+	 * the sequence to do it. Oh well.
 	 */
-	adjusted_mode->clock *= psb_intel_sdvo_get_pixel_multiplier(mode);
+	if (psb_intel_sdvo->is_tv) {
+		if (!psb_intel_sdvo_set_output_timings_from_mode(psb_intel_sdvo, mode))
+			return false;
+
+		(void) psb_intel_sdvo_set_input_timings_for_mode(psb_intel_sdvo,
+							     mode,
+							     adjusted_mode);
+	} else if (psb_intel_sdvo->is_lvds) {
+		if (!psb_intel_sdvo_set_output_timings_from_mode(psb_intel_sdvo,
+							     psb_intel_sdvo->sdvo_lvds_fixed_mode))
+			return false;
+
+		(void) psb_intel_sdvo_set_input_timings_for_mode(psb_intel_sdvo,
+							     mode,
+							     adjusted_mode);
+	}
+
+	/* Make the CRTC code factor in the SDVO pixel multiplier.  The
+	 * SDVO device will factor out the multiplier during mode_set.
+	 */
+	multiplier = psb_intel_sdvo_get_pixel_multiplier(adjusted_mode);
+	psb_intel_mode_set_pixel_multiplier(adjusted_mode, multiplier);
+
 	return true;
 }
 
@@ -667,96 +985,79 @@ static void psb_intel_sdvo_mode_set(struct drm_encoder *encoder,
 	struct drm_device *dev = encoder->dev;
 	struct drm_crtc *crtc = encoder->crtc;
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
-	struct psb_intel_output *psb_intel_output =
-					enc_to_psb_intel_output(encoder);
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
-	u16 width, height;
-	u16 h_blank_len, h_sync_len, v_blank_len, v_sync_len;
-	u16 h_sync_offset, v_sync_offset;
+	struct psb_intel_sdvo *psb_intel_sdvo = to_psb_intel_sdvo(encoder);
 	u32 sdvox;
-	struct psb_intel_sdvo_dtd output_dtd;
-	int sdvo_pixel_multiply;
+	struct psb_intel_sdvo_in_out_map in_out;
+	struct psb_intel_sdvo_dtd input_dtd;
+	int pixel_multiplier = psb_intel_mode_get_pixel_multiplier(adjusted_mode);
+	int rate;
 
 	if (!mode)
 		return;
 
-	psb_intel_sdvo_set_target_output(psb_intel_output, 0);
-
-	width = mode->crtc_hdisplay;
-	height = mode->crtc_vdisplay;
-
-	/* do some mode translations */
-	h_blank_len = mode->crtc_hblank_end - mode->crtc_hblank_start;
-	h_sync_len = mode->crtc_hsync_end - mode->crtc_hsync_start;
-
-	v_blank_len = mode->crtc_vblank_end - mode->crtc_vblank_start;
-	v_sync_len = mode->crtc_vsync_end - mode->crtc_vsync_start;
+	/* First, set the input mapping for the first input to our controlled
+	 * output. This is only correct if we're a single-input device, in
+	 * which case the first input is the output from the appropriate SDVO
+	 * channel on the motherboard.  In a two-input device, the first input
+	 * will be SDVOB and the second SDVOC.
+	 */
+	in_out.in0 = psb_intel_sdvo->attached_output;
+	in_out.in1 = 0;
 
-	h_sync_offset = mode->crtc_hsync_start - mode->crtc_hblank_start;
-	v_sync_offset = mode->crtc_vsync_start - mode->crtc_vblank_start;
+	psb_intel_sdvo_set_value(psb_intel_sdvo,
+			     SDVO_CMD_SET_IN_OUT_MAP,
+			     &in_out, sizeof(in_out));
 
-	output_dtd.part1.clock = mode->clock / 10;
-	output_dtd.part1.h_active = width & 0xff;
-	output_dtd.part1.h_blank = h_blank_len & 0xff;
-	output_dtd.part1.h_high = (((width >> 8) & 0xf) << 4) |
-	    ((h_blank_len >> 8) & 0xf);
-	output_dtd.part1.v_active = height & 0xff;
-	output_dtd.part1.v_blank = v_blank_len & 0xff;
-	output_dtd.part1.v_high = (((height >> 8) & 0xf) << 4) |
-	    ((v_blank_len >> 8) & 0xf);
-
-	output_dtd.part2.h_sync_off = h_sync_offset;
-	output_dtd.part2.h_sync_width = h_sync_len & 0xff;
-	output_dtd.part2.v_sync_off_width = (v_sync_offset & 0xf) << 4 |
-	    (v_sync_len & 0xf);
-	output_dtd.part2.sync_off_width_high =
-	    ((h_sync_offset & 0x300) >> 2) | ((h_sync_len & 0x300) >> 4) |
-	    ((v_sync_offset & 0x30) >> 2) | ((v_sync_len & 0x30) >> 4);
-
-	output_dtd.part2.dtd_flags = 0x18;
-	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
-		output_dtd.part2.dtd_flags |= 0x2;
-	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
-		output_dtd.part2.dtd_flags |= 0x4;
+	/* Set the output timings to the screen */
+	if (!psb_intel_sdvo_set_target_output(psb_intel_sdvo,
+					  psb_intel_sdvo->attached_output))
+		return;
 
-	output_dtd.part2.sdvo_flags = 0;
-	output_dtd.part2.v_sync_off_high = v_sync_offset & 0xc0;
-	output_dtd.part2.reserved = 0;
+	/* We have tried to get input timing in mode_fixup, and filled into
+	 * adjusted_mode.
+	 */
+	if (psb_intel_sdvo->is_tv || psb_intel_sdvo->is_lvds) {
+		input_dtd = psb_intel_sdvo->input_dtd;
+	} else {
+		/* Set the output timing to the screen */
+		if (!psb_intel_sdvo_set_target_output(psb_intel_sdvo,
+						  psb_intel_sdvo->attached_output))
+			return;
 
-	/* Set the output timing to the screen */
-	psb_intel_sdvo_set_target_output(psb_intel_output,
-				     sdvo_priv->active_outputs);
+		psb_intel_sdvo_get_dtd_from_mode(&input_dtd, adjusted_mode);
+		(void) psb_intel_sdvo_set_output_timing(psb_intel_sdvo, &input_dtd);
+	}
 
 	/* Set the input timing to the screen. Assume always input 0. */
-	psb_intel_sdvo_set_target_input(psb_intel_output, true, false);
+	if (!psb_intel_sdvo_set_target_input(psb_intel_sdvo))
+		return;
 
-	psb_intel_sdvo_set_output_timing(psb_intel_output, &output_dtd);
+	if (psb_intel_sdvo->has_hdmi_monitor) {
+		psb_intel_sdvo_set_encode(psb_intel_sdvo, SDVO_ENCODE_HDMI);
+		psb_intel_sdvo_set_colorimetry(psb_intel_sdvo,
+					   SDVO_COLORIMETRY_RGB256);
+		psb_intel_sdvo_set_avi_infoframe(psb_intel_sdvo);
+	} else
+		psb_intel_sdvo_set_encode(psb_intel_sdvo, SDVO_ENCODE_DVI);
 
-	/* We would like to use i830_sdvo_create_preferred_input_timing() to
-	 * provide the device with a timing it can support, if it supports that
-	 * feature.  However, presumably we would need to adjust the CRTC to
-	 * output the preferred timing, and we don't support that currently.
-	 */
-	psb_intel_sdvo_set_input_timing(psb_intel_output, &output_dtd);
+	if (psb_intel_sdvo->is_tv &&
+	    !psb_intel_sdvo_set_tv_format(psb_intel_sdvo))
+		return;
 
-	switch (psb_intel_sdvo_get_pixel_multiplier(mode)) {
-	case 1:
-		psb_intel_sdvo_set_clock_rate_mult(psb_intel_output,
-					       SDVO_CLOCK_RATE_MULT_1X);
-		break;
-	case 2:
-		psb_intel_sdvo_set_clock_rate_mult(psb_intel_output,
-					       SDVO_CLOCK_RATE_MULT_2X);
-		break;
-	case 4:
-		psb_intel_sdvo_set_clock_rate_mult(psb_intel_output,
-					       SDVO_CLOCK_RATE_MULT_4X);
-		break;
+	(void) psb_intel_sdvo_set_input_timing(psb_intel_sdvo, &input_dtd);
+
+	switch (pixel_multiplier) {
+	default:
+	case 1: rate = SDVO_CLOCK_RATE_MULT_1X; break;
+	case 2: rate = SDVO_CLOCK_RATE_MULT_2X; break;
+	case 4: rate = SDVO_CLOCK_RATE_MULT_4X; break;
 	}
+	if (!psb_intel_sdvo_set_clock_rate_mult(psb_intel_sdvo, rate))
+		return;
 
 	/* Set the SDVO control regs. */
-	sdvox = REG_READ(sdvo_priv->output_device);
-	switch (sdvo_priv->output_device) {
+	sdvox = REG_READ(psb_intel_sdvo->sdvo_reg);
+	switch (psb_intel_sdvo->sdvo_reg) {
 	case SDVOB:
 		sdvox &= SDVOB_PRESERVE_MASK;
 		break;
@@ -765,37 +1066,47 @@ static void psb_intel_sdvo_mode_set(struct drm_encoder *encoder,
 		break;
 	}
 	sdvox |= (9 << 19) | SDVO_BORDER_ENABLE;
+
 	if (psb_intel_crtc->pipe == 1)
 		sdvox |= SDVO_PIPE_B_SELECT;
+	if (psb_intel_sdvo->has_hdmi_audio)
+		sdvox |= SDVO_AUDIO_ENABLE;
 
-	sdvo_pixel_multiply = psb_intel_sdvo_get_pixel_multiplier(mode);
-
-	psb_intel_sdvo_write_sdvox(psb_intel_output, sdvox);
+	/* FIXME: Check if this is needed for PSB
+	sdvox |= (pixel_multiplier - 1) << SDVO_PORT_MULTIPLY_SHIFT;
+	*/
 
-	 psb_intel_sdvo_set_iomap(psb_intel_output);
+	if (input_dtd.part2.sdvo_flags & SDVO_NEED_TO_STALL)
+		sdvox |= SDVO_STALL_SELECT;
+	psb_intel_sdvo_write_sdvox(psb_intel_sdvo, sdvox);
 }
 
 static void psb_intel_sdvo_dpms(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
-	struct psb_intel_output *psb_intel_output =
-					enc_to_psb_intel_output(encoder);
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	struct psb_intel_sdvo *psb_intel_sdvo = to_psb_intel_sdvo(encoder);
 	u32 temp;
 
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		DRM_DEBUG("DPMS_ON");
+		break;
+	case DRM_MODE_DPMS_OFF:
+		DRM_DEBUG("DPMS_OFF");
+		break;
+	default:
+		DRM_DEBUG("DPMS: %d", mode);
+	}
+
 	if (mode != DRM_MODE_DPMS_ON) {
-		psb_intel_sdvo_set_active_outputs(psb_intel_output, 0);
+		psb_intel_sdvo_set_active_outputs(psb_intel_sdvo, 0);
 		if (0)
-			psb_intel_sdvo_set_encoder_power_state(
-							psb_intel_output,
-							mode);
+			psb_intel_sdvo_set_encoder_power_state(psb_intel_sdvo, mode);
 
 		if (mode == DRM_MODE_DPMS_OFF) {
-			temp = REG_READ(sdvo_priv->output_device);
+			temp = REG_READ(psb_intel_sdvo->sdvo_reg);
 			if ((temp & SDVO_ENABLE) != 0) {
-				psb_intel_sdvo_write_sdvox(psb_intel_output,
-						       temp &
-						       ~SDVO_ENABLE);
+				psb_intel_sdvo_write_sdvox(psb_intel_sdvo, temp & ~SDVO_ENABLE);
 			}
 		}
 	} else {
@@ -803,185 +1114,112 @@ static void psb_intel_sdvo_dpms(struct drm_encoder *encoder, int mode)
 		int i;
 		u8 status;
 
-		temp = REG_READ(sdvo_priv->output_device);
+		temp = REG_READ(psb_intel_sdvo->sdvo_reg);
 		if ((temp & SDVO_ENABLE) == 0)
-			psb_intel_sdvo_write_sdvox(psb_intel_output,
-					       temp | SDVO_ENABLE);
+			psb_intel_sdvo_write_sdvox(psb_intel_sdvo, temp | SDVO_ENABLE);
 		for (i = 0; i < 2; i++)
 			psb_intel_wait_for_vblank(dev);
 
-		status =
-		    psb_intel_sdvo_get_trained_inputs(psb_intel_output,
-							&input1,
-							&input2);
-
-
+		status = psb_intel_sdvo_get_trained_inputs(psb_intel_sdvo, &input1, &input2);
 		/* Warn if the device reported failure to sync.
 		 * A lot of SDVO devices fail to notify of sync, but it's
 		 * a given it the status is a success, we succeeded.
 		 */
 		if (status == SDVO_CMD_STATUS_SUCCESS && !input1) {
-			DRM_DEBUG
-			    ("First %s output reported failure to sync\n",
-			     SDVO_NAME(sdvo_priv));
+			DRM_DEBUG_KMS("First %s output reported failure to "
+					"sync\n", SDVO_NAME(psb_intel_sdvo));
 		}
 
 		if (0)
-			psb_intel_sdvo_set_encoder_power_state(
-							psb_intel_output,
-							mode);
-		psb_intel_sdvo_set_active_outputs(psb_intel_output,
-					      sdvo_priv->active_outputs);
+			psb_intel_sdvo_set_encoder_power_state(psb_intel_sdvo, mode);
+		psb_intel_sdvo_set_active_outputs(psb_intel_sdvo, psb_intel_sdvo->attached_output);
 	}
 	return;
 }
 
-static void psb_intel_sdvo_save(struct drm_connector *connector)
+static int psb_intel_sdvo_mode_valid(struct drm_connector *connector,
+				 struct drm_display_mode *mode)
 {
-	struct drm_device *dev = connector->dev;
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
-	/*int o;*/
-
-	sdvo_priv->save_sdvo_mult =
-	    psb_intel_sdvo_get_clock_rate_mult(psb_intel_output);
-	psb_intel_sdvo_get_active_outputs(psb_intel_output,
-				      &sdvo_priv->save_active_outputs);
-
-	if (sdvo_priv->caps.sdvo_inputs_mask & 0x1) {
-		psb_intel_sdvo_set_target_input(psb_intel_output,
-						true,
-						false);
-		psb_intel_sdvo_get_input_timing(psb_intel_output,
-					    &sdvo_priv->save_input_dtd_1);
-	}
+	struct psb_intel_sdvo *psb_intel_sdvo = intel_attached_sdvo(connector);
 
-	if (sdvo_priv->caps.sdvo_inputs_mask & 0x2) {
-		psb_intel_sdvo_set_target_input(psb_intel_output,
-						false,
-						true);
-		psb_intel_sdvo_get_input_timing(psb_intel_output,
-					    &sdvo_priv->save_input_dtd_2);
-	}
-	sdvo_priv->save_SDVOX = REG_READ(sdvo_priv->output_device);
+	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
+		return MODE_NO_DBLESCAN;
 
-	/*TODO: save the in_out_map state*/
-}
+	if (psb_intel_sdvo->pixel_clock_min > mode->clock)
+		return MODE_CLOCK_LOW;
 
-static void psb_intel_sdvo_restore(struct drm_connector *connector)
-{
-	struct drm_device *dev = connector->dev;
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
-	/*int o;*/
-	int i;
-	bool input1, input2;
-	u8 status;
-
-	psb_intel_sdvo_set_active_outputs(psb_intel_output, 0);
-
-	if (sdvo_priv->caps.sdvo_inputs_mask & 0x1) {
-		psb_intel_sdvo_set_target_input(psb_intel_output, true, false);
-		psb_intel_sdvo_set_input_timing(psb_intel_output,
-					    &sdvo_priv->save_input_dtd_1);
-	}
-
-	if (sdvo_priv->caps.sdvo_inputs_mask & 0x2) {
-		psb_intel_sdvo_set_target_input(psb_intel_output, false, true);
-		psb_intel_sdvo_set_input_timing(psb_intel_output,
-					    &sdvo_priv->save_input_dtd_2);
-	}
-
-	psb_intel_sdvo_set_clock_rate_mult(psb_intel_output,
-				       sdvo_priv->save_sdvo_mult);
+	if (psb_intel_sdvo->pixel_clock_max < mode->clock)
+		return MODE_CLOCK_HIGH;
 
-	REG_WRITE(sdvo_priv->output_device, sdvo_priv->save_SDVOX);
+	if (psb_intel_sdvo->is_lvds) {
+		if (mode->hdisplay > psb_intel_sdvo->sdvo_lvds_fixed_mode->hdisplay)
+			return MODE_PANEL;
 
-	if (sdvo_priv->save_SDVOX & SDVO_ENABLE) {
-		for (i = 0; i < 2; i++)
-			psb_intel_wait_for_vblank(dev);
-		status =
-		    psb_intel_sdvo_get_trained_inputs(psb_intel_output,
-							&input1,
-							&input2);
-		if (status == SDVO_CMD_STATUS_SUCCESS && !input1)
-			DRM_DEBUG
-			    ("First %s output reported failure to sync\n",
-			     SDVO_NAME(sdvo_priv));
+		if (mode->vdisplay > psb_intel_sdvo->sdvo_lvds_fixed_mode->vdisplay)
+			return MODE_PANEL;
 	}
 
-	psb_intel_sdvo_set_active_outputs(psb_intel_output,
-				      sdvo_priv->save_active_outputs);
-
-	/*TODO: restore in_out_map*/
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				 SDVO_CMD_SET_IN_OUT_MAP,
-				 sdvo_priv->in_out_map,
-				 4);
-
-	psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
-}
-
-static int psb_intel_sdvo_mode_valid(struct drm_connector *connector,
-				 struct drm_display_mode *mode)
-{
-	struct psb_intel_output *psb_intel_output =
-				to_psb_intel_output(connector);
-	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
-
-	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
-		return MODE_NO_DBLESCAN;
-
-	if (sdvo_priv->pixel_clock_min > mode->clock)
-		return MODE_CLOCK_LOW;
-
-	if (sdvo_priv->pixel_clock_max < mode->clock)
-		return MODE_CLOCK_HIGH;
-
 	return MODE_OK;
 }
 
-static bool psb_intel_sdvo_get_capabilities(
-				struct psb_intel_output *psb_intel_output,
-				struct psb_intel_sdvo_caps *caps)
+static bool psb_intel_sdvo_get_capabilities(struct psb_intel_sdvo *psb_intel_sdvo, struct psb_intel_sdvo_caps *caps)
 {
-	u8 status;
-
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				 SDVO_CMD_GET_DEVICE_CAPS,
-				 NULL,
-				 0);
-	status = psb_intel_sdvo_read_response(psb_intel_output,
-						caps,
-						sizeof(*caps));
-	if (status != SDVO_CMD_STATUS_SUCCESS)
+	BUILD_BUG_ON(sizeof(*caps) != 8);
+	if (!psb_intel_sdvo_get_value(psb_intel_sdvo,
+				  SDVO_CMD_GET_DEVICE_CAPS,
+				  caps, sizeof(*caps)))
 		return false;
 
+	DRM_DEBUG_KMS("SDVO capabilities:\n"
+		      "  vendor_id: %d\n"
+		      "  device_id: %d\n"
+		      "  device_rev_id: %d\n"
+		      "  sdvo_version_major: %d\n"
+		      "  sdvo_version_minor: %d\n"
+		      "  sdvo_inputs_mask: %d\n"
+		      "  smooth_scaling: %d\n"
+		      "  sharp_scaling: %d\n"
+		      "  up_scaling: %d\n"
+		      "  down_scaling: %d\n"
+		      "  stall_support: %d\n"
+		      "  output_flags: %d\n",
+		      caps->vendor_id,
+		      caps->device_id,
+		      caps->device_rev_id,
+		      caps->sdvo_version_major,
+		      caps->sdvo_version_minor,
+		      caps->sdvo_inputs_mask,
+		      caps->smooth_scaling,
+		      caps->sharp_scaling,
+		      caps->up_scaling,
+		      caps->down_scaling,
+		      caps->stall_support,
+		      caps->output_flags);
+
 	return true;
 }
 
-struct drm_connector *psb_intel_sdvo_find(struct drm_device *dev, int sdvoB)
+/* No use! */
+#if 0
+struct drm_connector* psb_intel_sdvo_find(struct drm_device *dev, int sdvoB)
 {
 	struct drm_connector *connector = NULL;
-	struct psb_intel_output *iout = NULL;
-	struct psb_intel_sdvo_priv *sdvo;
+	struct psb_intel_sdvo *iout = NULL;
+	struct psb_intel_sdvo *sdvo;
 
 	/* find the sdvo connector */
-	list_for_each_entry(connector, &dev->mode_config.connector_list,
-			    head) {
-		iout = to_psb_intel_output(connector);
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		iout = to_psb_intel_sdvo(connector);
 
 		if (iout->type != INTEL_OUTPUT_SDVO)
 			continue;
 
 		sdvo = iout->dev_priv;
 
-		if (sdvo->output_device == SDVOB && sdvoB)
+		if (sdvo->sdvo_reg == SDVOB && sdvoB)
 			return connector;
 
-		if (sdvo->output_device == SDVOC && !sdvoB)
+		if (sdvo->sdvo_reg == SDVOC && !sdvoB)
 			return connector;
 
 	}
@@ -993,112 +1231,607 @@ int psb_intel_sdvo_supports_hotplug(struct drm_connector *connector)
 {
 	u8 response[2];
 	u8 status;
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_sdvo *psb_intel_sdvo;
+	DRM_DEBUG_KMS("\n");
 
 	if (!connector)
 		return 0;
 
-	psb_intel_output = to_psb_intel_output(connector);
-
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				 SDVO_CMD_GET_HOT_PLUG_SUPPORT,
-				 NULL,
-				 0);
-	status = psb_intel_sdvo_read_response(psb_intel_output,
-						&response,
-						2);
+	psb_intel_sdvo = to_psb_intel_sdvo(connector);
 
-	if (response[0] != 0)
-		return 1;
-
-	return 0;
+	return psb_intel_sdvo_get_value(psb_intel_sdvo, SDVO_CMD_GET_HOT_PLUG_SUPPORT,
+				    &response, 2) && response[0];
 }
 
 void psb_intel_sdvo_set_hotplug(struct drm_connector *connector, int on)
 {
 	u8 response[2];
 	u8 status;
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
+	struct psb_intel_sdvo *psb_intel_sdvo = to_psb_intel_sdvo(connector);
 
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				 SDVO_CMD_GET_ACTIVE_HOT_PLUG,
-				 NULL,
-				 0);
-	psb_intel_sdvo_read_response(psb_intel_output, &response, 2);
+	psb_intel_sdvo_write_cmd(psb_intel_sdvo, SDVO_CMD_GET_ACTIVE_HOT_PLUG, NULL, 0);
+	psb_intel_sdvo_read_response(psb_intel_sdvo, &response, 2);
 
 	if (on) {
-		psb_intel_sdvo_write_cmd(psb_intel_output,
-				     SDVO_CMD_GET_HOT_PLUG_SUPPORT, NULL,
-				     0);
-		status = psb_intel_sdvo_read_response(psb_intel_output,
-						      &response,
-						      2);
-
-		psb_intel_sdvo_write_cmd(psb_intel_output,
-				     SDVO_CMD_SET_ACTIVE_HOT_PLUG,
-				     &response, 2);
+		psb_intel_sdvo_write_cmd(psb_intel_sdvo, SDVO_CMD_GET_HOT_PLUG_SUPPORT, NULL, 0);
+		status = psb_intel_sdvo_read_response(psb_intel_sdvo, &response, 2);
+
+		psb_intel_sdvo_write_cmd(psb_intel_sdvo, SDVO_CMD_SET_ACTIVE_HOT_PLUG, &response, 2);
 	} else {
 		response[0] = 0;
 		response[1] = 0;
-		psb_intel_sdvo_write_cmd(psb_intel_output,
-				     SDVO_CMD_SET_ACTIVE_HOT_PLUG,
-				     &response, 2);
+		psb_intel_sdvo_write_cmd(psb_intel_sdvo, SDVO_CMD_SET_ACTIVE_HOT_PLUG, &response, 2);
 	}
 
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				 SDVO_CMD_GET_ACTIVE_HOT_PLUG,
-				 NULL,
-				 0);
-	psb_intel_sdvo_read_response(psb_intel_output, &response, 2);
+	psb_intel_sdvo_write_cmd(psb_intel_sdvo, SDVO_CMD_GET_ACTIVE_HOT_PLUG, NULL, 0);
+	psb_intel_sdvo_read_response(psb_intel_sdvo, &response, 2);
 }
+#endif
 
-static enum drm_connector_status psb_intel_sdvo_detect(struct drm_connector
-						   *connector, bool force)
+static bool
+psb_intel_sdvo_multifunc_encoder(struct psb_intel_sdvo *psb_intel_sdvo)
 {
-	u8 response[2];
-	u8 status;
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
-
-	psb_intel_sdvo_write_cmd(psb_intel_output,
-				 SDVO_CMD_GET_ATTACHED_DISPLAYS,
-				 NULL,
-				 0);
-	status = psb_intel_sdvo_read_response(psb_intel_output, &response, 2);
-
-	DRM_DEBUG("SDVO response %d %d\n", response[0], response[1]);
-	if ((response[0] != 0) || (response[1] != 0))
-		return connector_status_connected;
-	else
+	/* Is there more than one type of output? */
+	int caps = psb_intel_sdvo->caps.output_flags & 0xf;
+	return caps & -caps;
+}
+
+static struct edid *
+psb_intel_sdvo_get_edid(struct drm_connector *connector)
+{
+	struct psb_intel_sdvo *sdvo = intel_attached_sdvo(connector);
+	return drm_get_edid(connector, &sdvo->ddc);
+}
+
+/* Mac mini hack -- use the same DDC as the analog connector */
+static struct edid *
+psb_intel_sdvo_get_analog_edid(struct drm_connector *connector)
+{
+	struct drm_psb_private *dev_priv = connector->dev->dev_private;
+
+	return drm_get_edid(connector,
+			    &dev_priv->gmbus[dev_priv->crt_ddc_pin].adapter);
+	return NULL;
+}
+
+enum drm_connector_status
+psb_intel_sdvo_hdmi_sink_detect(struct drm_connector *connector)
+{
+	struct psb_intel_sdvo *psb_intel_sdvo = intel_attached_sdvo(connector);
+	enum drm_connector_status status;
+	struct edid *edid;
+
+	edid = psb_intel_sdvo_get_edid(connector);
+
+	if (edid == NULL && psb_intel_sdvo_multifunc_encoder(psb_intel_sdvo)) {
+		u8 ddc, saved_ddc = psb_intel_sdvo->ddc_bus;
+
+		/*
+		 * Don't use the 1 as the argument of DDC bus switch to get
+		 * the EDID. It is used for SDVO SPD ROM.
+		 */
+		for (ddc = psb_intel_sdvo->ddc_bus >> 1; ddc > 1; ddc >>= 1) {
+			psb_intel_sdvo->ddc_bus = ddc;
+			edid = psb_intel_sdvo_get_edid(connector);
+			if (edid)
+				break;
+		}
+		/*
+		 * If we found the EDID on the other bus,
+		 * assume that is the correct DDC bus.
+		 */
+		if (edid == NULL)
+			psb_intel_sdvo->ddc_bus = saved_ddc;
+	}
+
+	/*
+	 * When there is no edid and no monitor is connected with VGA
+	 * port, try to use the CRT ddc to read the EDID for DVI-connector.
+	 */
+	if (edid == NULL)
+		edid = psb_intel_sdvo_get_analog_edid(connector);
+
+	status = connector_status_unknown;
+	if (edid != NULL) {
+		/* DDC bus is shared, match EDID to connector type */
+		if (edid->input & DRM_EDID_INPUT_DIGITAL) {
+			status = connector_status_connected;
+			if (psb_intel_sdvo->is_hdmi) {
+				psb_intel_sdvo->has_hdmi_monitor = drm_detect_hdmi_monitor(edid);
+				psb_intel_sdvo->has_hdmi_audio = drm_detect_monitor_audio(edid);
+			}
+		} else
+			status = connector_status_disconnected;
+		connector->display_info.raw_edid = NULL;
+		kfree(edid);
+	}
+
+	if (status == connector_status_connected) {
+		struct psb_intel_sdvo_connector *psb_intel_sdvo_connector = to_psb_intel_sdvo_connector(connector);
+		if (psb_intel_sdvo_connector->force_audio)
+			psb_intel_sdvo->has_hdmi_audio = psb_intel_sdvo_connector->force_audio > 0;
+	}
+
+	return status;
+}
+
+static enum drm_connector_status
+psb_intel_sdvo_detect(struct drm_connector *connector, bool force)
+{
+	uint16_t response;
+	struct psb_intel_sdvo *psb_intel_sdvo = intel_attached_sdvo(connector);
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector = to_psb_intel_sdvo_connector(connector);
+	enum drm_connector_status ret;
+
+	if (!psb_intel_sdvo_write_cmd(psb_intel_sdvo,
+				  SDVO_CMD_GET_ATTACHED_DISPLAYS, NULL, 0))
+		return connector_status_unknown;
+
+	/* add 30ms delay when the output type might be TV */
+	if (psb_intel_sdvo->caps.output_flags &
+	    (SDVO_OUTPUT_SVID0 | SDVO_OUTPUT_CVBS0))
+		mdelay(30);
+
+	if (!psb_intel_sdvo_read_response(psb_intel_sdvo, &response, 2))
+		return connector_status_unknown;
+
+	DRM_DEBUG_KMS("SDVO response %d %d [%x]\n",
+		      response & 0xff, response >> 8,
+		      psb_intel_sdvo_connector->output_flag);
+
+	if (response == 0)
 		return connector_status_disconnected;
+
+	psb_intel_sdvo->attached_output = response;
+
+	psb_intel_sdvo->has_hdmi_monitor = false;
+	psb_intel_sdvo->has_hdmi_audio = false;
+
+	if ((psb_intel_sdvo_connector->output_flag & response) == 0)
+		ret = connector_status_disconnected;
+	else if (IS_TMDS(psb_intel_sdvo_connector))
+		ret = psb_intel_sdvo_hdmi_sink_detect(connector);
+	else {
+		struct edid *edid;
+
+		/* if we have an edid check it matches the connection */
+		edid = psb_intel_sdvo_get_edid(connector);
+		if (edid == NULL)
+			edid = psb_intel_sdvo_get_analog_edid(connector);
+		if (edid != NULL) {
+			if (edid->input & DRM_EDID_INPUT_DIGITAL)
+				ret = connector_status_disconnected;
+			else
+				ret = connector_status_connected;
+			connector->display_info.raw_edid = NULL;
+			kfree(edid);
+		} else
+			ret = connector_status_connected;
+	}
+
+	/* May update encoder flag for like clock for SDVO TV, etc.*/
+	if (ret == connector_status_connected) {
+		psb_intel_sdvo->is_tv = false;
+		psb_intel_sdvo->is_lvds = false;
+		psb_intel_sdvo->base.needs_tv_clock = false;
+
+		if (response & SDVO_TV_MASK) {
+			psb_intel_sdvo->is_tv = true;
+			psb_intel_sdvo->base.needs_tv_clock = true;
+		}
+		if (response & SDVO_LVDS_MASK)
+			psb_intel_sdvo->is_lvds = psb_intel_sdvo->sdvo_lvds_fixed_mode != NULL;
+	}
+
+	return ret;
 }
 
-static int psb_intel_sdvo_get_modes(struct drm_connector *connector)
+static void psb_intel_sdvo_get_ddc_modes(struct drm_connector *connector)
 {
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
+	struct edid *edid;
 
 	/* set the bus switch and get the modes */
-	psb_intel_sdvo_set_control_bus_switch(psb_intel_output,
-					  SDVO_CONTROL_BUS_DDC2);
-	psb_intel_ddc_get_modes(psb_intel_output);
+	edid = psb_intel_sdvo_get_edid(connector);
 
-	if (list_empty(&connector->probed_modes))
-		return 0;
-	return 1;
+	/*
+	 * Mac mini hack.  On this device, the DVI-I connector shares one DDC
+	 * link between analog and digital outputs. So, if the regular SDVO
+	 * DDC fails, check to see if the analog output is disconnected, in
+	 * which case we'll look there for the digital DDC data.
+	 */
+	if (edid == NULL)
+		edid = psb_intel_sdvo_get_analog_edid(connector);
+
+	if (edid != NULL) {
+		struct psb_intel_sdvo_connector *psb_intel_sdvo_connector = to_psb_intel_sdvo_connector(connector);
+		bool monitor_is_digital = !!(edid->input & DRM_EDID_INPUT_DIGITAL);
+		bool connector_is_digital = !!IS_TMDS(psb_intel_sdvo_connector);
+
+		if (connector_is_digital == monitor_is_digital) {
+			drm_mode_connector_update_edid_property(connector, edid);
+			drm_add_edid_modes(connector, edid);
+		}
+
+		connector->display_info.raw_edid = NULL;
+		kfree(edid);
+	}
+}
+
+/*
+ * Set of SDVO TV modes.
+ * Note!  This is in reply order (see loop in get_tv_modes).
+ * XXX: all 60Hz refresh?
+ */
+static const struct drm_display_mode sdvo_tv_modes[] = {
+	{ DRM_MODE("320x200", DRM_MODE_TYPE_DRIVER, 5815, 320, 321, 384,
+		   416, 0, 200, 201, 232, 233, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("320x240", DRM_MODE_TYPE_DRIVER, 6814, 320, 321, 384,
+		   416, 0, 240, 241, 272, 273, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("400x300", DRM_MODE_TYPE_DRIVER, 9910, 400, 401, 464,
+		   496, 0, 300, 301, 332, 333, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("640x350", DRM_MODE_TYPE_DRIVER, 16913, 640, 641, 704,
+		   736, 0, 350, 351, 382, 383, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("640x400", DRM_MODE_TYPE_DRIVER, 19121, 640, 641, 704,
+		   736, 0, 400, 401, 432, 433, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("640x480", DRM_MODE_TYPE_DRIVER, 22654, 640, 641, 704,
+		   736, 0, 480, 481, 512, 513, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("704x480", DRM_MODE_TYPE_DRIVER, 24624, 704, 705, 768,
+		   800, 0, 480, 481, 512, 513, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("704x576", DRM_MODE_TYPE_DRIVER, 29232, 704, 705, 768,
+		   800, 0, 576, 577, 608, 609, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("720x350", DRM_MODE_TYPE_DRIVER, 18751, 720, 721, 784,
+		   816, 0, 350, 351, 382, 383, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("720x400", DRM_MODE_TYPE_DRIVER, 21199, 720, 721, 784,
+		   816, 0, 400, 401, 432, 433, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("720x480", DRM_MODE_TYPE_DRIVER, 25116, 720, 721, 784,
+		   816, 0, 480, 481, 512, 513, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("720x540", DRM_MODE_TYPE_DRIVER, 28054, 720, 721, 784,
+		   816, 0, 540, 541, 572, 573, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("720x576", DRM_MODE_TYPE_DRIVER, 29816, 720, 721, 784,
+		   816, 0, 576, 577, 608, 609, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("768x576", DRM_MODE_TYPE_DRIVER, 31570, 768, 769, 832,
+		   864, 0, 576, 577, 608, 609, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("800x600", DRM_MODE_TYPE_DRIVER, 34030, 800, 801, 864,
+		   896, 0, 600, 601, 632, 633, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("832x624", DRM_MODE_TYPE_DRIVER, 36581, 832, 833, 896,
+		   928, 0, 624, 625, 656, 657, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("920x766", DRM_MODE_TYPE_DRIVER, 48707, 920, 921, 984,
+		   1016, 0, 766, 767, 798, 799, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER, 53827, 1024, 1025, 1088,
+		   1120, 0, 768, 769, 800, 801, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+	{ DRM_MODE("1280x1024", DRM_MODE_TYPE_DRIVER, 87265, 1280, 1281, 1344,
+		   1376, 0, 1024, 1025, 1056, 1057, 0,
+		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC) },
+};
+
+static void psb_intel_sdvo_get_tv_modes(struct drm_connector *connector)
+{
+	struct psb_intel_sdvo *psb_intel_sdvo = intel_attached_sdvo(connector);
+	struct psb_intel_sdvo_sdtv_resolution_request tv_res;
+	uint32_t reply = 0, format_map = 0;
+	int i;
+
+	/* Read the list of supported input resolutions for the selected TV
+	 * format.
+	 */
+	format_map = 1 << psb_intel_sdvo->tv_format_index;
+	memcpy(&tv_res, &format_map,
+	       min(sizeof(format_map), sizeof(struct psb_intel_sdvo_sdtv_resolution_request)));
+
+	if (!psb_intel_sdvo_set_target_output(psb_intel_sdvo, psb_intel_sdvo->attached_output))
+		return;
+
+	BUILD_BUG_ON(sizeof(tv_res) != 3);
+	if (!psb_intel_sdvo_write_cmd(psb_intel_sdvo,
+				  SDVO_CMD_GET_SDTV_RESOLUTION_SUPPORT,
+				  &tv_res, sizeof(tv_res)))
+		return;
+	if (!psb_intel_sdvo_read_response(psb_intel_sdvo, &reply, 3))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(sdvo_tv_modes); i++)
+		if (reply & (1 << i)) {
+			struct drm_display_mode *nmode;
+			nmode = drm_mode_duplicate(connector->dev,
+						   &sdvo_tv_modes[i]);
+			if (nmode)
+				drm_mode_probed_add(connector, nmode);
+		}
+}
+
+static void psb_intel_sdvo_get_lvds_modes(struct drm_connector *connector)
+{
+	struct psb_intel_sdvo *psb_intel_sdvo = intel_attached_sdvo(connector);
+	struct drm_psb_private *dev_priv = connector->dev->dev_private;
+	struct drm_display_mode *newmode;
+
+	/*
+	 * Attempt to get the mode list from DDC.
+	 * Assume that the preferred modes are
+	 * arranged in priority order.
+	 */
+	psb_intel_ddc_get_modes(connector, psb_intel_sdvo->i2c);
+	if (list_empty(&connector->probed_modes) == false)
+		goto end;
+
+	/* Fetch modes from VBT */
+	if (dev_priv->sdvo_lvds_vbt_mode != NULL) {
+		newmode = drm_mode_duplicate(connector->dev,
+					     dev_priv->sdvo_lvds_vbt_mode);
+		if (newmode != NULL) {
+			/* Guarantee the mode is preferred */
+			newmode->type = (DRM_MODE_TYPE_PREFERRED |
+					 DRM_MODE_TYPE_DRIVER);
+			drm_mode_probed_add(connector, newmode);
+		}
+	}
+
+end:
+	list_for_each_entry(newmode, &connector->probed_modes, head) {
+		if (newmode->type & DRM_MODE_TYPE_PREFERRED) {
+			psb_intel_sdvo->sdvo_lvds_fixed_mode =
+				drm_mode_duplicate(connector->dev, newmode);
+
+			drm_mode_set_crtcinfo(psb_intel_sdvo->sdvo_lvds_fixed_mode,
+					      0);
+
+			psb_intel_sdvo->is_lvds = true;
+			break;
+		}
+	}
+
+}
+
+static int psb_intel_sdvo_get_modes(struct drm_connector *connector)
+{
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector = to_psb_intel_sdvo_connector(connector);
+
+	if (IS_TV(psb_intel_sdvo_connector))
+		psb_intel_sdvo_get_tv_modes(connector);
+	else if (IS_LVDS(psb_intel_sdvo_connector))
+		psb_intel_sdvo_get_lvds_modes(connector);
+	else
+		psb_intel_sdvo_get_ddc_modes(connector);
+
+	return !list_empty(&connector->probed_modes);
+}
+
+static void
+psb_intel_sdvo_destroy_enhance_property(struct drm_connector *connector)
+{
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector = to_psb_intel_sdvo_connector(connector);
+	struct drm_device *dev = connector->dev;
+
+	if (psb_intel_sdvo_connector->left)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->left);
+	if (psb_intel_sdvo_connector->right)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->right);
+	if (psb_intel_sdvo_connector->top)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->top);
+	if (psb_intel_sdvo_connector->bottom)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->bottom);
+	if (psb_intel_sdvo_connector->hpos)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->hpos);
+	if (psb_intel_sdvo_connector->vpos)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->vpos);
+	if (psb_intel_sdvo_connector->saturation)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->saturation);
+	if (psb_intel_sdvo_connector->contrast)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->contrast);
+	if (psb_intel_sdvo_connector->hue)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->hue);
+	if (psb_intel_sdvo_connector->sharpness)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->sharpness);
+	if (psb_intel_sdvo_connector->flicker_filter)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->flicker_filter);
+	if (psb_intel_sdvo_connector->flicker_filter_2d)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->flicker_filter_2d);
+	if (psb_intel_sdvo_connector->flicker_filter_adaptive)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->flicker_filter_adaptive);
+	if (psb_intel_sdvo_connector->tv_luma_filter)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->tv_luma_filter);
+	if (psb_intel_sdvo_connector->tv_chroma_filter)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->tv_chroma_filter);
+	if (psb_intel_sdvo_connector->dot_crawl)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->dot_crawl);
+	if (psb_intel_sdvo_connector->brightness)
+		drm_property_destroy(dev, psb_intel_sdvo_connector->brightness);
 }
 
 static void psb_intel_sdvo_destroy(struct drm_connector *connector)
 {
-	struct psb_intel_output *psb_intel_output =
-				to_psb_intel_output(connector);
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector = to_psb_intel_sdvo_connector(connector);
 
-	if (psb_intel_output->i2c_bus)
-		psb_intel_i2c_destroy(psb_intel_output->i2c_bus);
+	if (psb_intel_sdvo_connector->tv_format)
+		drm_property_destroy(connector->dev,
+				     psb_intel_sdvo_connector->tv_format);
+
+	psb_intel_sdvo_destroy_enhance_property(connector);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
-	kfree(psb_intel_output);
+	kfree(connector);
+}
+
+static bool psb_intel_sdvo_detect_hdmi_audio(struct drm_connector *connector)
+{
+	struct psb_intel_sdvo *psb_intel_sdvo = intel_attached_sdvo(connector);
+	struct edid *edid;
+	bool has_audio = false;
+
+	if (!psb_intel_sdvo->is_hdmi)
+		return false;
+
+	edid = psb_intel_sdvo_get_edid(connector);
+	if (edid != NULL && edid->input & DRM_EDID_INPUT_DIGITAL)
+		has_audio = drm_detect_monitor_audio(edid);
+
+	return has_audio;
+}
+
+static int
+psb_intel_sdvo_set_property(struct drm_connector *connector,
+			struct drm_property *property,
+			uint64_t val)
+{
+	struct psb_intel_sdvo *psb_intel_sdvo = intel_attached_sdvo(connector);
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector = to_psb_intel_sdvo_connector(connector);
+	struct drm_psb_private *dev_priv = connector->dev->dev_private;
+	uint16_t temp_value;
+	uint8_t cmd;
+	int ret;
+
+	ret = drm_connector_property_set_value(connector, property, val);
+	if (ret)
+		return ret;
+
+	if (property == dev_priv->force_audio_property) {
+		int i = val;
+		bool has_audio;
+
+		if (i == psb_intel_sdvo_connector->force_audio)
+			return 0;
+
+		psb_intel_sdvo_connector->force_audio = i;
+
+		if (i == 0)
+			has_audio = psb_intel_sdvo_detect_hdmi_audio(connector);
+		else
+			has_audio = i > 0;
+
+		if (has_audio == psb_intel_sdvo->has_hdmi_audio)
+			return 0;
+
+		psb_intel_sdvo->has_hdmi_audio = has_audio;
+		goto done;
+	}
+
+	if (property == dev_priv->broadcast_rgb_property) {
+		if (val == !!psb_intel_sdvo->color_range)
+			return 0;
+
+		psb_intel_sdvo->color_range = val ? SDVO_COLOR_RANGE_16_235 : 0;
+		goto done;
+	}
+
+#define CHECK_PROPERTY(name, NAME) \
+	if (psb_intel_sdvo_connector->name == property) { \
+		if (psb_intel_sdvo_connector->cur_##name == temp_value) return 0; \
+		if (psb_intel_sdvo_connector->max_##name < temp_value) return -EINVAL; \
+		cmd = SDVO_CMD_SET_##NAME; \
+		psb_intel_sdvo_connector->cur_##name = temp_value; \
+		goto set_value; \
+	}
+
+	if (property == psb_intel_sdvo_connector->tv_format) {
+		if (val >= TV_FORMAT_NUM)
+			return -EINVAL;
+
+		if (psb_intel_sdvo->tv_format_index ==
+		    psb_intel_sdvo_connector->tv_format_supported[val])
+			return 0;
+
+		psb_intel_sdvo->tv_format_index = psb_intel_sdvo_connector->tv_format_supported[val];
+		goto done;
+	} else if (IS_TV_OR_LVDS(psb_intel_sdvo_connector)) {
+		temp_value = val;
+		if (psb_intel_sdvo_connector->left == property) {
+			drm_connector_property_set_value(connector,
+							 psb_intel_sdvo_connector->right, val);
+			if (psb_intel_sdvo_connector->left_margin == temp_value)
+				return 0;
+
+			psb_intel_sdvo_connector->left_margin = temp_value;
+			psb_intel_sdvo_connector->right_margin = temp_value;
+			temp_value = psb_intel_sdvo_connector->max_hscan -
+				psb_intel_sdvo_connector->left_margin;
+			cmd = SDVO_CMD_SET_OVERSCAN_H;
+			goto set_value;
+		} else if (psb_intel_sdvo_connector->right == property) {
+			drm_connector_property_set_value(connector,
+							 psb_intel_sdvo_connector->left, val);
+			if (psb_intel_sdvo_connector->right_margin == temp_value)
+				return 0;
+
+			psb_intel_sdvo_connector->left_margin = temp_value;
+			psb_intel_sdvo_connector->right_margin = temp_value;
+			temp_value = psb_intel_sdvo_connector->max_hscan -
+				psb_intel_sdvo_connector->left_margin;
+			cmd = SDVO_CMD_SET_OVERSCAN_H;
+			goto set_value;
+		} else if (psb_intel_sdvo_connector->top == property) {
+			drm_connector_property_set_value(connector,
+							 psb_intel_sdvo_connector->bottom, val);
+			if (psb_intel_sdvo_connector->top_margin == temp_value)
+				return 0;
+
+			psb_intel_sdvo_connector->top_margin = temp_value;
+			psb_intel_sdvo_connector->bottom_margin = temp_value;
+			temp_value = psb_intel_sdvo_connector->max_vscan -
+				psb_intel_sdvo_connector->top_margin;
+			cmd = SDVO_CMD_SET_OVERSCAN_V;
+			goto set_value;
+		} else if (psb_intel_sdvo_connector->bottom == property) {
+			drm_connector_property_set_value(connector,
+							 psb_intel_sdvo_connector->top, val);
+			if (psb_intel_sdvo_connector->bottom_margin == temp_value)
+				return 0;
+
+			psb_intel_sdvo_connector->top_margin = temp_value;
+			psb_intel_sdvo_connector->bottom_margin = temp_value;
+			temp_value = psb_intel_sdvo_connector->max_vscan -
+				psb_intel_sdvo_connector->top_margin;
+			cmd = SDVO_CMD_SET_OVERSCAN_V;
+			goto set_value;
+		}
+		CHECK_PROPERTY(hpos, HPOS)
+		CHECK_PROPERTY(vpos, VPOS)
+		CHECK_PROPERTY(saturation, SATURATION)
+		CHECK_PROPERTY(contrast, CONTRAST)
+		CHECK_PROPERTY(hue, HUE)
+		CHECK_PROPERTY(brightness, BRIGHTNESS)
+		CHECK_PROPERTY(sharpness, SHARPNESS)
+		CHECK_PROPERTY(flicker_filter, FLICKER_FILTER)
+		CHECK_PROPERTY(flicker_filter_2d, FLICKER_FILTER_2D)
+		CHECK_PROPERTY(flicker_filter_adaptive, FLICKER_FILTER_ADAPTIVE)
+		CHECK_PROPERTY(tv_chroma_filter, TV_CHROMA_FILTER)
+		CHECK_PROPERTY(tv_luma_filter, TV_LUMA_FILTER)
+		CHECK_PROPERTY(dot_crawl, DOT_CRAWL)
+	}
+
+	return -EINVAL; /* unknown property */
+
+set_value:
+	if (!psb_intel_sdvo_set_value(psb_intel_sdvo, cmd, &temp_value, 2))
+		return -EIO;
+
+
+done:
+	if (psb_intel_sdvo->base.base.crtc) {
+		struct drm_crtc *crtc = psb_intel_sdvo->base.base.crtc;
+		drm_crtc_helper_set_mode(crtc, &crtc->mode, crtc->x,
+					 crtc->y, crtc->fb);
+	}
+
+	return 0;
+#undef CHECK_PROPERTY
 }
 
 static const struct drm_encoder_helper_funcs psb_intel_sdvo_helper_funcs = {
@@ -1111,183 +1844,765 @@ static const struct drm_encoder_helper_funcs psb_intel_sdvo_helper_funcs = {
 
 static const struct drm_connector_funcs psb_intel_sdvo_connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
-	.save = psb_intel_sdvo_save,
-	.restore = psb_intel_sdvo_restore,
 	.detect = psb_intel_sdvo_detect,
 	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = psb_intel_sdvo_set_property,
 	.destroy = psb_intel_sdvo_destroy,
 };
 
-static const struct drm_connector_helper_funcs
-				psb_intel_sdvo_connector_helper_funcs = {
+static const struct drm_connector_helper_funcs psb_intel_sdvo_connector_helper_funcs = {
 	.get_modes = psb_intel_sdvo_get_modes,
 	.mode_valid = psb_intel_sdvo_mode_valid,
 	.best_encoder = psb_intel_best_encoder,
 };
 
-void psb_intel_sdvo_enc_destroy(struct drm_encoder *encoder)
+static void psb_intel_sdvo_enc_destroy(struct drm_encoder *encoder)
 {
-	drm_encoder_cleanup(encoder);
+	struct psb_intel_sdvo *psb_intel_sdvo = to_psb_intel_sdvo(encoder);
+
+	if (psb_intel_sdvo->sdvo_lvds_fixed_mode != NULL)
+		drm_mode_destroy(encoder->dev,
+				 psb_intel_sdvo->sdvo_lvds_fixed_mode);
+
+	i2c_del_adapter(&psb_intel_sdvo->ddc);
+	psb_intel_encoder_destroy(encoder);
 }
 
 static const struct drm_encoder_funcs psb_intel_sdvo_enc_funcs = {
 	.destroy = psb_intel_sdvo_enc_destroy,
 };
 
-
-void psb_intel_sdvo_init(struct drm_device *dev, int output_device)
+static void
+psb_intel_sdvo_guess_ddc_bus(struct psb_intel_sdvo *sdvo)
 {
-	struct drm_connector *connector;
-	struct psb_intel_output *psb_intel_output;
-	struct psb_intel_sdvo_priv *sdvo_priv;
-	struct psb_intel_i2c_chan *i2cbus = NULL;
-	int connector_type;
-	u8 ch[0x40];
-	int i;
-	int encoder_type, output_id;
+	uint16_t mask = 0;
+	unsigned int num_bits;
 
-	psb_intel_output =
-	    kcalloc(sizeof(struct psb_intel_output) +
-		    sizeof(struct psb_intel_sdvo_priv), 1, GFP_KERNEL);
-	if (!psb_intel_output)
-		return;
+	/* Make a mask of outputs less than or equal to our own priority in the
+	 * list.
+	 */
+	switch (sdvo->controlled_output) {
+	case SDVO_OUTPUT_LVDS1:
+		mask |= SDVO_OUTPUT_LVDS1;
+	case SDVO_OUTPUT_LVDS0:
+		mask |= SDVO_OUTPUT_LVDS0;
+	case SDVO_OUTPUT_TMDS1:
+		mask |= SDVO_OUTPUT_TMDS1;
+	case SDVO_OUTPUT_TMDS0:
+		mask |= SDVO_OUTPUT_TMDS0;
+	case SDVO_OUTPUT_RGB1:
+		mask |= SDVO_OUTPUT_RGB1;
+	case SDVO_OUTPUT_RGB0:
+		mask |= SDVO_OUTPUT_RGB0;
+		break;
+	}
 
-	connector = &psb_intel_output->base;
+	/* Count bits to find what number we are in the priority list. */
+	mask &= sdvo->caps.output_flags;
+	num_bits = hweight16(mask);
+	/* If more than 3 outputs, default to DDC bus 3 for now. */
+	if (num_bits > 3)
+		num_bits = 3;
 
-	drm_connector_init(dev, connector, &psb_intel_sdvo_connector_funcs,
-			   DRM_MODE_CONNECTOR_Unknown);
-	drm_connector_helper_add(connector,
-				 &psb_intel_sdvo_connector_helper_funcs);
-	sdvo_priv = (struct psb_intel_sdvo_priv *) (psb_intel_output + 1);
-	psb_intel_output->type = INTEL_OUTPUT_SDVO;
+	/* Corresponds to SDVO_CONTROL_BUS_DDCx */
+	sdvo->ddc_bus = 1 << num_bits;
+}
 
-	connector->interlace_allowed = 0;
-	connector->doublescan_allowed = 0;
+/**
+ * Choose the appropriate DDC bus for control bus switch command for this
+ * SDVO output based on the controlled output.
+ *
+ * DDC bus number assignment is in a priority order of RGB outputs, then TMDS
+ * outputs, then LVDS outputs.
+ */
+static void
+psb_intel_sdvo_select_ddc_bus(struct drm_psb_private *dev_priv,
+			  struct psb_intel_sdvo *sdvo, u32 reg)
+{
+	struct sdvo_device_mapping *mapping;
+
+	if (IS_SDVOB(reg))
+		mapping = &(dev_priv->sdvo_mappings[0]);
+	else
+		mapping = &(dev_priv->sdvo_mappings[1]);
+
+	if (mapping->initialized)
+		sdvo->ddc_bus = 1 << ((mapping->ddc_pin & 0xf0) >> 4);
+	else
+		psb_intel_sdvo_guess_ddc_bus(sdvo);
+}
+
+static void
+psb_intel_sdvo_select_i2c_bus(struct drm_psb_private *dev_priv,
+			  struct psb_intel_sdvo *sdvo, u32 reg)
+{
+	struct sdvo_device_mapping *mapping;
+	u8 pin, speed;
 
-	/* setup the DDC bus. */
-	if (output_device == SDVOB)
-		i2cbus =
-		    psb_intel_i2c_create(dev, GPIOE, "SDVOCTRL_E for SDVOB");
+	if (IS_SDVOB(reg))
+		mapping = &dev_priv->sdvo_mappings[0];
 	else
-		i2cbus =
-		    psb_intel_i2c_create(dev, GPIOE, "SDVOCTRL_E for SDVOC");
+		mapping = &dev_priv->sdvo_mappings[1];
 
-	if (!i2cbus)
-		goto err_connector;
+	pin = GMBUS_PORT_DPB;
+	speed = GMBUS_RATE_1MHZ >> 8;
+	if (mapping->initialized) {
+		pin = mapping->i2c_pin;
+		speed = mapping->i2c_speed;
+	}
 
-	sdvo_priv->i2c_bus = i2cbus;
+	if (pin < GMBUS_NUM_PORTS) {
+		sdvo->i2c = &dev_priv->gmbus[pin].adapter;
+		gma_intel_gmbus_set_speed(sdvo->i2c, speed);
+		gma_intel_gmbus_force_bit(sdvo->i2c, true);
+	} else
+		sdvo->i2c = &dev_priv->gmbus[GMBUS_PORT_DPB].adapter;
+}
 
-	if (output_device == SDVOB) {
-		output_id = 1;
-		sdvo_priv->by_input_wiring = SDVOB_IN0;
-		sdvo_priv->i2c_bus->slave_addr = 0x38;
+static bool
+psb_intel_sdvo_is_hdmi_connector(struct psb_intel_sdvo *psb_intel_sdvo, int device)
+{
+	return psb_intel_sdvo_check_supp_encode(psb_intel_sdvo);
+}
+
+static u8
+psb_intel_sdvo_get_slave_addr(struct drm_device *dev, int sdvo_reg)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct sdvo_device_mapping *my_mapping, *other_mapping;
+
+	if (IS_SDVOB(sdvo_reg)) {
+		my_mapping = &dev_priv->sdvo_mappings[0];
+		other_mapping = &dev_priv->sdvo_mappings[1];
 	} else {
-		output_id = 2;
-		sdvo_priv->i2c_bus->slave_addr = 0x39;
+		my_mapping = &dev_priv->sdvo_mappings[1];
+		other_mapping = &dev_priv->sdvo_mappings[0];
+	}
+
+	/* If the BIOS described our SDVO device, take advantage of it. */
+	if (my_mapping->slave_addr)
+		return my_mapping->slave_addr;
+
+	/* If the BIOS only described a different SDVO device, use the
+	 * address that it isn't using.
+	 */
+	if (other_mapping->slave_addr) {
+		if (other_mapping->slave_addr == 0x70)
+			return 0x72;
+		else
+			return 0x70;
+	}
+
+	/* No SDVO device info is found for another DVO port,
+	 * so use mapping assumption we had before BIOS parsing.
+	 */
+	if (IS_SDVOB(sdvo_reg))
+		return 0x70;
+	else
+		return 0x72;
+}
+
+static void
+psb_intel_sdvo_connector_init(struct psb_intel_sdvo_connector *connector,
+			  struct psb_intel_sdvo *encoder)
+{
+	drm_connector_init(encoder->base.base.dev,
+			   &connector->base.base,
+			   &psb_intel_sdvo_connector_funcs,
+			   connector->base.base.connector_type);
+
+	drm_connector_helper_add(&connector->base.base,
+				 &psb_intel_sdvo_connector_helper_funcs);
+
+	connector->base.base.interlace_allowed = 0;
+	connector->base.base.doublescan_allowed = 0;
+	connector->base.base.display_info.subpixel_order = SubPixelHorizontalRGB;
+
+	psb_intel_connector_attach_encoder(&connector->base, &encoder->base);
+	drm_sysfs_connector_add(&connector->base.base);
+}
+
+static void
+psb_intel_sdvo_add_hdmi_properties(struct psb_intel_sdvo_connector *connector)
+{
+	/* FIXME: We don't support HDMI at the moment
+	struct drm_device *dev = connector->base.base.dev;
+
+	intel_attach_force_audio_property(&connector->base.base);
+	if (INTEL_INFO(dev)->gen >= 4 && IS_MOBILE(dev))
+		intel_attach_broadcast_rgb_property(&connector->base.base);
+	*/
+}
+
+static bool
+psb_intel_sdvo_dvi_init(struct psb_intel_sdvo *psb_intel_sdvo, int device)
+{
+	struct drm_encoder *encoder = &psb_intel_sdvo->base.base;
+	struct drm_connector *connector;
+	struct psb_intel_connector *intel_connector;
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector;
+
+	psb_intel_sdvo_connector = kzalloc(sizeof(struct psb_intel_sdvo_connector), GFP_KERNEL);
+	if (!psb_intel_sdvo_connector)
+		return false;
+
+	if (device == 0) {
+		psb_intel_sdvo->controlled_output |= SDVO_OUTPUT_TMDS0;
+		psb_intel_sdvo_connector->output_flag = SDVO_OUTPUT_TMDS0;
+	} else if (device == 1) {
+		psb_intel_sdvo->controlled_output |= SDVO_OUTPUT_TMDS1;
+		psb_intel_sdvo_connector->output_flag = SDVO_OUTPUT_TMDS1;
+	}
+
+	intel_connector = &psb_intel_sdvo_connector->base;
+	connector = &intel_connector->base;
+	// connector->polled = DRM_CONNECTOR_POLL_CONNECT | DRM_CONNECTOR_POLL_DISCONNECT;
+	encoder->encoder_type = DRM_MODE_ENCODER_TMDS;
+	connector->connector_type = DRM_MODE_CONNECTOR_DVID;
+
+	if (psb_intel_sdvo_is_hdmi_connector(psb_intel_sdvo, device)) {
+		connector->connector_type = DRM_MODE_CONNECTOR_HDMIA;
+		psb_intel_sdvo->is_hdmi = true;
+	}
+	psb_intel_sdvo->base.clone_mask = ((1 << INTEL_SDVO_NON_TV_CLONE_BIT) |
+				       (1 << INTEL_ANALOG_CLONE_BIT));
+
+	psb_intel_sdvo_connector_init(psb_intel_sdvo_connector, psb_intel_sdvo);
+	if (psb_intel_sdvo->is_hdmi)
+		psb_intel_sdvo_add_hdmi_properties(psb_intel_sdvo_connector);
+
+	return true;
+}
+
+static bool
+psb_intel_sdvo_tv_init(struct psb_intel_sdvo *psb_intel_sdvo, int type)
+{
+	struct drm_encoder *encoder = &psb_intel_sdvo->base.base;
+	struct drm_connector *connector;
+	struct psb_intel_connector *intel_connector;
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector;
+
+	psb_intel_sdvo_connector = kzalloc(sizeof(struct psb_intel_sdvo_connector), GFP_KERNEL);
+	if (!psb_intel_sdvo_connector)
+		return false;
+
+	intel_connector = &psb_intel_sdvo_connector->base;
+	connector = &intel_connector->base;
+	encoder->encoder_type = DRM_MODE_ENCODER_TVDAC;
+	connector->connector_type = DRM_MODE_CONNECTOR_SVIDEO;
+
+	psb_intel_sdvo->controlled_output |= type;
+	psb_intel_sdvo_connector->output_flag = type;
+
+	psb_intel_sdvo->is_tv = true;
+	psb_intel_sdvo->base.needs_tv_clock = true;
+	psb_intel_sdvo->base.clone_mask = 1 << INTEL_SDVO_TV_CLONE_BIT;
+
+	psb_intel_sdvo_connector_init(psb_intel_sdvo_connector, psb_intel_sdvo);
+
+	if (!psb_intel_sdvo_tv_create_property(psb_intel_sdvo, psb_intel_sdvo_connector, type))
+		goto err;
+
+	if (!psb_intel_sdvo_create_enhance_property(psb_intel_sdvo, psb_intel_sdvo_connector))
+		goto err;
+
+	return true;
+
+err:
+	psb_intel_sdvo_destroy(connector);
+	return false;
+}
+
+static bool
+psb_intel_sdvo_analog_init(struct psb_intel_sdvo *psb_intel_sdvo, int device)
+{
+	struct drm_encoder *encoder = &psb_intel_sdvo->base.base;
+	struct drm_connector *connector;
+	struct psb_intel_connector *intel_connector;
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector;
+
+	psb_intel_sdvo_connector = kzalloc(sizeof(struct psb_intel_sdvo_connector), GFP_KERNEL);
+	if (!psb_intel_sdvo_connector)
+		return false;
+
+	intel_connector = &psb_intel_sdvo_connector->base;
+	connector = &intel_connector->base;
+	connector->polled = DRM_CONNECTOR_POLL_CONNECT;
+	encoder->encoder_type = DRM_MODE_ENCODER_DAC;
+	connector->connector_type = DRM_MODE_CONNECTOR_VGA;
+
+	if (device == 0) {
+		psb_intel_sdvo->controlled_output |= SDVO_OUTPUT_RGB0;
+		psb_intel_sdvo_connector->output_flag = SDVO_OUTPUT_RGB0;
+	} else if (device == 1) {
+		psb_intel_sdvo->controlled_output |= SDVO_OUTPUT_RGB1;
+		psb_intel_sdvo_connector->output_flag = SDVO_OUTPUT_RGB1;
+	}
+
+	psb_intel_sdvo->base.clone_mask = ((1 << INTEL_SDVO_NON_TV_CLONE_BIT) |
+				       (1 << INTEL_ANALOG_CLONE_BIT));
+
+	psb_intel_sdvo_connector_init(psb_intel_sdvo_connector,
+				  psb_intel_sdvo);
+	return true;
+}
+
+static bool
+psb_intel_sdvo_lvds_init(struct psb_intel_sdvo *psb_intel_sdvo, int device)
+{
+	struct drm_encoder *encoder = &psb_intel_sdvo->base.base;
+	struct drm_connector *connector;
+	struct psb_intel_connector *intel_connector;
+	struct psb_intel_sdvo_connector *psb_intel_sdvo_connector;
+
+	psb_intel_sdvo_connector = kzalloc(sizeof(struct psb_intel_sdvo_connector), GFP_KERNEL);
+	if (!psb_intel_sdvo_connector)
+		return false;
+
+	intel_connector = &psb_intel_sdvo_connector->base;
+	connector = &intel_connector->base;
+	encoder->encoder_type = DRM_MODE_ENCODER_LVDS;
+	connector->connector_type = DRM_MODE_CONNECTOR_LVDS;
+
+	if (device == 0) {
+		psb_intel_sdvo->controlled_output |= SDVO_OUTPUT_LVDS0;
+		psb_intel_sdvo_connector->output_flag = SDVO_OUTPUT_LVDS0;
+	} else if (device == 1) {
+		psb_intel_sdvo->controlled_output |= SDVO_OUTPUT_LVDS1;
+		psb_intel_sdvo_connector->output_flag = SDVO_OUTPUT_LVDS1;
+	}
+
+	psb_intel_sdvo->base.clone_mask = ((1 << INTEL_ANALOG_CLONE_BIT) |
+				       (1 << INTEL_SDVO_LVDS_CLONE_BIT));
+
+	psb_intel_sdvo_connector_init(psb_intel_sdvo_connector, psb_intel_sdvo);
+	if (!psb_intel_sdvo_create_enhance_property(psb_intel_sdvo, psb_intel_sdvo_connector))
+		goto err;
+
+	return true;
+
+err:
+	psb_intel_sdvo_destroy(connector);
+	return false;
+}
+
+static bool
+psb_intel_sdvo_output_setup(struct psb_intel_sdvo *psb_intel_sdvo, uint16_t flags)
+{
+	psb_intel_sdvo->is_tv = false;
+	psb_intel_sdvo->base.needs_tv_clock = false;
+	psb_intel_sdvo->is_lvds = false;
+
+	/* SDVO requires XXX1 function may not exist unless it has XXX0 function.*/
+
+	if (flags & SDVO_OUTPUT_TMDS0)
+		if (!psb_intel_sdvo_dvi_init(psb_intel_sdvo, 0))
+			return false;
+
+	if ((flags & SDVO_TMDS_MASK) == SDVO_TMDS_MASK)
+		if (!psb_intel_sdvo_dvi_init(psb_intel_sdvo, 1))
+			return false;
+
+	/* TV has no XXX1 function block */
+	if (flags & SDVO_OUTPUT_SVID0)
+		if (!psb_intel_sdvo_tv_init(psb_intel_sdvo, SDVO_OUTPUT_SVID0))
+			return false;
+
+	if (flags & SDVO_OUTPUT_CVBS0)
+		if (!psb_intel_sdvo_tv_init(psb_intel_sdvo, SDVO_OUTPUT_CVBS0))
+			return false;
+
+	if (flags & SDVO_OUTPUT_RGB0)
+		if (!psb_intel_sdvo_analog_init(psb_intel_sdvo, 0))
+			return false;
+
+	if ((flags & SDVO_RGB_MASK) == SDVO_RGB_MASK)
+		if (!psb_intel_sdvo_analog_init(psb_intel_sdvo, 1))
+			return false;
+
+	if (flags & SDVO_OUTPUT_LVDS0)
+		if (!psb_intel_sdvo_lvds_init(psb_intel_sdvo, 0))
+			return false;
+
+	if ((flags & SDVO_LVDS_MASK) == SDVO_LVDS_MASK)
+		if (!psb_intel_sdvo_lvds_init(psb_intel_sdvo, 1))
+			return false;
+
+	if ((flags & SDVO_OUTPUT_MASK) == 0) {
+		unsigned char bytes[2];
+
+		psb_intel_sdvo->controlled_output = 0;
+		memcpy(bytes, &psb_intel_sdvo->caps.output_flags, 2);
+		DRM_DEBUG_KMS("%s: Unknown SDVO output type (0x%02x%02x)\n",
+			      SDVO_NAME(psb_intel_sdvo),
+			      bytes[0], bytes[1]);
+		return false;
+	}
+	psb_intel_sdvo->base.crtc_mask = (1 << 0) | (1 << 1);
+
+	return true;
+}
+
+static bool psb_intel_sdvo_tv_create_property(struct psb_intel_sdvo *psb_intel_sdvo,
+					  struct psb_intel_sdvo_connector *psb_intel_sdvo_connector,
+					  int type)
+{
+	struct drm_device *dev = psb_intel_sdvo->base.base.dev;
+	struct psb_intel_sdvo_tv_format format;
+	uint32_t format_map, i;
+
+	if (!psb_intel_sdvo_set_target_output(psb_intel_sdvo, type))
+		return false;
+
+	BUILD_BUG_ON(sizeof(format) != 6);
+	if (!psb_intel_sdvo_get_value(psb_intel_sdvo,
+				  SDVO_CMD_GET_SUPPORTED_TV_FORMATS,
+				  &format, sizeof(format)))
+		return false;
+
+	memcpy(&format_map, &format, min(sizeof(format_map), sizeof(format)));
+
+	if (format_map == 0)
+		return false;
+
+	psb_intel_sdvo_connector->format_supported_num = 0;
+	for (i = 0 ; i < TV_FORMAT_NUM; i++)
+		if (format_map & (1 << i))
+			psb_intel_sdvo_connector->tv_format_supported[psb_intel_sdvo_connector->format_supported_num++] = i;
+
+
+	psb_intel_sdvo_connector->tv_format =
+			drm_property_create(dev, DRM_MODE_PROP_ENUM,
+					    "mode", psb_intel_sdvo_connector->format_supported_num);
+	if (!psb_intel_sdvo_connector->tv_format)
+		return false;
+
+	for (i = 0; i < psb_intel_sdvo_connector->format_supported_num; i++)
+		drm_property_add_enum(
+				psb_intel_sdvo_connector->tv_format, i,
+				i, tv_format_names[psb_intel_sdvo_connector->tv_format_supported[i]]);
+
+	psb_intel_sdvo->tv_format_index = psb_intel_sdvo_connector->tv_format_supported[0];
+	drm_connector_attach_property(&psb_intel_sdvo_connector->base.base,
+				      psb_intel_sdvo_connector->tv_format, 0);
+	return true;
+
+}
+
+#define ENHANCEMENT(name, NAME) do { \
+	if (enhancements.name) { \
+		if (!psb_intel_sdvo_get_value(psb_intel_sdvo, SDVO_CMD_GET_MAX_##NAME, &data_value, 4) || \
+		    !psb_intel_sdvo_get_value(psb_intel_sdvo, SDVO_CMD_GET_##NAME, &response, 2)) \
+			return false; \
+		psb_intel_sdvo_connector->max_##name = data_value[0]; \
+		psb_intel_sdvo_connector->cur_##name = response; \
+		psb_intel_sdvo_connector->name = \
+			drm_property_create(dev, DRM_MODE_PROP_RANGE, #name, 2); \
+		if (!psb_intel_sdvo_connector->name) return false; \
+		psb_intel_sdvo_connector->name->values[0] = 0; \
+		psb_intel_sdvo_connector->name->values[1] = data_value[0]; \
+		drm_connector_attach_property(connector, \
+					      psb_intel_sdvo_connector->name, \
+					      psb_intel_sdvo_connector->cur_##name); \
+		DRM_DEBUG_KMS(#name ": max %d, default %d, current %d\n", \
+			      data_value[0], data_value[1], response); \
+	} \
+} while(0)
+
+static bool
+psb_intel_sdvo_create_enhance_property_tv(struct psb_intel_sdvo *psb_intel_sdvo,
+				      struct psb_intel_sdvo_connector *psb_intel_sdvo_connector,
+				      struct psb_intel_sdvo_enhancements_reply enhancements)
+{
+	struct drm_device *dev = psb_intel_sdvo->base.base.dev;
+	struct drm_connector *connector = &psb_intel_sdvo_connector->base.base;
+	uint16_t response, data_value[2];
+
+	/* when horizontal overscan is supported, Add the left/right  property */
+	if (enhancements.overscan_h) {
+		if (!psb_intel_sdvo_get_value(psb_intel_sdvo,
+					  SDVO_CMD_GET_MAX_OVERSCAN_H,
+					  &data_value, 4))
+			return false;
+
+		if (!psb_intel_sdvo_get_value(psb_intel_sdvo,
+					  SDVO_CMD_GET_OVERSCAN_H,
+					  &response, 2))
+			return false;
+
+		psb_intel_sdvo_connector->max_hscan = data_value[0];
+		psb_intel_sdvo_connector->left_margin = data_value[0] - response;
+		psb_intel_sdvo_connector->right_margin = psb_intel_sdvo_connector->left_margin;
+		psb_intel_sdvo_connector->left =
+			drm_property_create(dev, DRM_MODE_PROP_RANGE,
+					    "left_margin", 2);
+		if (!psb_intel_sdvo_connector->left)
+			return false;
+
+		psb_intel_sdvo_connector->left->values[0] = 0;
+		psb_intel_sdvo_connector->left->values[1] = data_value[0];
+		drm_connector_attach_property(connector,
+					      psb_intel_sdvo_connector->left,
+					      psb_intel_sdvo_connector->left_margin);
+
+		psb_intel_sdvo_connector->right =
+			drm_property_create(dev, DRM_MODE_PROP_RANGE,
+					    "right_margin", 2);
+		if (!psb_intel_sdvo_connector->right)
+			return false;
+
+		psb_intel_sdvo_connector->right->values[0] = 0;
+		psb_intel_sdvo_connector->right->values[1] = data_value[0];
+		drm_connector_attach_property(connector,
+					      psb_intel_sdvo_connector->right,
+					      psb_intel_sdvo_connector->right_margin);
+		DRM_DEBUG_KMS("h_overscan: max %d, "
+			      "default %d, current %d\n",
+			      data_value[0], data_value[1], response);
+	}
+
+	if (enhancements.overscan_v) {
+		if (!psb_intel_sdvo_get_value(psb_intel_sdvo,
+					  SDVO_CMD_GET_MAX_OVERSCAN_V,
+					  &data_value, 4))
+			return false;
+
+		if (!psb_intel_sdvo_get_value(psb_intel_sdvo,
+					  SDVO_CMD_GET_OVERSCAN_V,
+					  &response, 2))
+			return false;
+
+		psb_intel_sdvo_connector->max_vscan = data_value[0];
+		psb_intel_sdvo_connector->top_margin = data_value[0] - response;
+		psb_intel_sdvo_connector->bottom_margin = psb_intel_sdvo_connector->top_margin;
+		psb_intel_sdvo_connector->top =
+			drm_property_create(dev, DRM_MODE_PROP_RANGE,
+					    "top_margin", 2);
+		if (!psb_intel_sdvo_connector->top)
+			return false;
+
+		psb_intel_sdvo_connector->top->values[0] = 0;
+		psb_intel_sdvo_connector->top->values[1] = data_value[0];
+		drm_connector_attach_property(connector,
+					      psb_intel_sdvo_connector->top,
+					      psb_intel_sdvo_connector->top_margin);
+
+		psb_intel_sdvo_connector->bottom =
+			drm_property_create(dev, DRM_MODE_PROP_RANGE,
+					    "bottom_margin", 2);
+		if (!psb_intel_sdvo_connector->bottom)
+			return false;
+
+		psb_intel_sdvo_connector->bottom->values[0] = 0;
+		psb_intel_sdvo_connector->bottom->values[1] = data_value[0];
+		drm_connector_attach_property(connector,
+					      psb_intel_sdvo_connector->bottom,
+					      psb_intel_sdvo_connector->bottom_margin);
+		DRM_DEBUG_KMS("v_overscan: max %d, "
+			      "default %d, current %d\n",
+			      data_value[0], data_value[1], response);
+	}
+
+	ENHANCEMENT(hpos, HPOS);
+	ENHANCEMENT(vpos, VPOS);
+	ENHANCEMENT(saturation, SATURATION);
+	ENHANCEMENT(contrast, CONTRAST);
+	ENHANCEMENT(hue, HUE);
+	ENHANCEMENT(sharpness, SHARPNESS);
+	ENHANCEMENT(brightness, BRIGHTNESS);
+	ENHANCEMENT(flicker_filter, FLICKER_FILTER);
+	ENHANCEMENT(flicker_filter_adaptive, FLICKER_FILTER_ADAPTIVE);
+	ENHANCEMENT(flicker_filter_2d, FLICKER_FILTER_2D);
+	ENHANCEMENT(tv_chroma_filter, TV_CHROMA_FILTER);
+	ENHANCEMENT(tv_luma_filter, TV_LUMA_FILTER);
+
+	if (enhancements.dot_crawl) {
+		if (!psb_intel_sdvo_get_value(psb_intel_sdvo, SDVO_CMD_GET_DOT_CRAWL, &response, 2))
+			return false;
+
+		psb_intel_sdvo_connector->max_dot_crawl = 1;
+		psb_intel_sdvo_connector->cur_dot_crawl = response & 0x1;
+		psb_intel_sdvo_connector->dot_crawl =
+			drm_property_create(dev, DRM_MODE_PROP_RANGE, "dot_crawl", 2);
+		if (!psb_intel_sdvo_connector->dot_crawl)
+			return false;
+
+		psb_intel_sdvo_connector->dot_crawl->values[0] = 0;
+		psb_intel_sdvo_connector->dot_crawl->values[1] = 1;
+		drm_connector_attach_property(connector,
+					      psb_intel_sdvo_connector->dot_crawl,
+					      psb_intel_sdvo_connector->cur_dot_crawl);
+		DRM_DEBUG_KMS("dot crawl: current %d\n", response);
+	}
+
+	return true;
+}
+
+static bool
+psb_intel_sdvo_create_enhance_property_lvds(struct psb_intel_sdvo *psb_intel_sdvo,
+					struct psb_intel_sdvo_connector *psb_intel_sdvo_connector,
+					struct psb_intel_sdvo_enhancements_reply enhancements)
+{
+	struct drm_device *dev = psb_intel_sdvo->base.base.dev;
+	struct drm_connector *connector = &psb_intel_sdvo_connector->base.base;
+	uint16_t response, data_value[2];
+
+	ENHANCEMENT(brightness, BRIGHTNESS);
+
+	return true;
+}
+#undef ENHANCEMENT
+
+static bool psb_intel_sdvo_create_enhance_property(struct psb_intel_sdvo *psb_intel_sdvo,
+					       struct psb_intel_sdvo_connector *psb_intel_sdvo_connector)
+{
+	union {
+		struct psb_intel_sdvo_enhancements_reply reply;
+		uint16_t response;
+	} enhancements;
+
+	BUILD_BUG_ON(sizeof(enhancements) != 2);
+
+	enhancements.response = 0;
+	psb_intel_sdvo_get_value(psb_intel_sdvo,
+			     SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS,
+			     &enhancements, sizeof(enhancements));
+	if (enhancements.response == 0) {
+		DRM_DEBUG_KMS("No enhancement is supported\n");
+		return true;
 	}
 
-	sdvo_priv->output_device = output_device;
-	psb_intel_output->i2c_bus = i2cbus;
-	psb_intel_output->dev_priv = sdvo_priv;
+	if (IS_TV(psb_intel_sdvo_connector))
+		return psb_intel_sdvo_create_enhance_property_tv(psb_intel_sdvo, psb_intel_sdvo_connector, enhancements.reply);
+	else if(IS_LVDS(psb_intel_sdvo_connector))
+		return psb_intel_sdvo_create_enhance_property_lvds(psb_intel_sdvo, psb_intel_sdvo_connector, enhancements.reply);
+	else
+		return true;
+}
+
+static int psb_intel_sdvo_ddc_proxy_xfer(struct i2c_adapter *adapter,
+				     struct i2c_msg *msgs,
+				     int num)
+{
+	struct psb_intel_sdvo *sdvo = adapter->algo_data;
+
+	if (!psb_intel_sdvo_set_control_bus_switch(sdvo, sdvo->ddc_bus))
+		return -EIO;
+
+	return sdvo->i2c->algo->master_xfer(sdvo->i2c, msgs, num);
+}
+
+static u32 psb_intel_sdvo_ddc_proxy_func(struct i2c_adapter *adapter)
+{
+	struct psb_intel_sdvo *sdvo = adapter->algo_data;
+	return sdvo->i2c->algo->functionality(sdvo->i2c);
+}
+
+static const struct i2c_algorithm psb_intel_sdvo_ddc_proxy = {
+	.master_xfer	= psb_intel_sdvo_ddc_proxy_xfer,
+	.functionality	= psb_intel_sdvo_ddc_proxy_func
+};
+
+static bool
+psb_intel_sdvo_init_ddc_proxy(struct psb_intel_sdvo *sdvo,
+			  struct drm_device *dev)
+{
+	sdvo->ddc.owner = THIS_MODULE;
+	sdvo->ddc.class = I2C_CLASS_DDC;
+	snprintf(sdvo->ddc.name, I2C_NAME_SIZE, "SDVO DDC proxy");
+	sdvo->ddc.dev.parent = &dev->pdev->dev;
+	sdvo->ddc.algo_data = sdvo;
+	sdvo->ddc.algo = &psb_intel_sdvo_ddc_proxy;
+
+	return i2c_add_adapter(&sdvo->ddc) == 0;
+}
+
+bool psb_intel_sdvo_init(struct drm_device *dev, int sdvo_reg)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_encoder *psb_intel_encoder;
+	struct psb_intel_sdvo *psb_intel_sdvo;
+	int i;
+
+	psb_intel_sdvo = kzalloc(sizeof(struct psb_intel_sdvo), GFP_KERNEL);
+	if (!psb_intel_sdvo)
+		return false;
+
+	psb_intel_sdvo->sdvo_reg = sdvo_reg;
+	psb_intel_sdvo->slave_addr = psb_intel_sdvo_get_slave_addr(dev, sdvo_reg) >> 1;
+	psb_intel_sdvo_select_i2c_bus(dev_priv, psb_intel_sdvo, sdvo_reg);
+	if (!psb_intel_sdvo_init_ddc_proxy(psb_intel_sdvo, dev)) {
+		kfree(psb_intel_sdvo);
+		return false;
+	}
 
+	/* encoder type will be decided later */
+	psb_intel_encoder = &psb_intel_sdvo->base;
+	psb_intel_encoder->type = INTEL_OUTPUT_SDVO;
+	drm_encoder_init(dev, &psb_intel_encoder->base, &psb_intel_sdvo_enc_funcs, 0);
 
 	/* Read the regs to test if we can talk to the device */
 	for (i = 0; i < 0x40; i++) {
-		if (!psb_intel_sdvo_read_byte(psb_intel_output, i, &ch[i])) {
-			dev_dbg(dev->dev, "No SDVO device found on SDVO%c\n",
-				  output_device == SDVOB ? 'B' : 'C');
-			goto err_i2c;
+		u8 byte;
+
+		if (!psb_intel_sdvo_read_byte(psb_intel_sdvo, i, &byte)) {
+			DRM_DEBUG_KMS("No SDVO device found on SDVO%c\n",
+				      IS_SDVOB(sdvo_reg) ? 'B' : 'C');
+			goto err;
 		}
 	}
 
-	psb_intel_sdvo_get_capabilities(psb_intel_output, &sdvo_priv->caps);
-
-	memset(&sdvo_priv->active_outputs, 0,
-	       sizeof(sdvo_priv->active_outputs));
-
-	/* TODO, CVBS, SVID, YPRPB & SCART outputs. */
-	if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB0) {
-		sdvo_priv->active_outputs = SDVO_OUTPUT_RGB0;
-		sdvo_priv->active_device = SDVO_DEVICE_CRT;
-		connector->display_info.subpixel_order =
-		    SubPixelHorizontalRGB;
-		encoder_type = DRM_MODE_ENCODER_DAC;
-		connector_type = DRM_MODE_CONNECTOR_VGA;
-	} else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB1) {
-		sdvo_priv->active_outputs = SDVO_OUTPUT_RGB1;
-		sdvo_priv->active_outputs = SDVO_DEVICE_CRT;
-		connector->display_info.subpixel_order =
-		    SubPixelHorizontalRGB;
-		encoder_type = DRM_MODE_ENCODER_DAC;
-		connector_type = DRM_MODE_CONNECTOR_VGA;
-	} else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_TMDS0) {
-		sdvo_priv->active_outputs = SDVO_OUTPUT_TMDS0;
-		sdvo_priv->active_device = SDVO_DEVICE_TMDS;
-		connector->display_info.subpixel_order =
-		    SubPixelHorizontalRGB;
-		encoder_type = DRM_MODE_ENCODER_TMDS;
-		connector_type = DRM_MODE_CONNECTOR_DVID;
-	} else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_TMDS1) {
-		sdvo_priv->active_outputs = SDVO_OUTPUT_TMDS1;
-		sdvo_priv->active_device = SDVO_DEVICE_TMDS;
-		connector->display_info.subpixel_order =
-		    SubPixelHorizontalRGB;
-		encoder_type = DRM_MODE_ENCODER_TMDS;
-		connector_type = DRM_MODE_CONNECTOR_DVID;
-	} else {
-		unsigned char bytes[2];
+	if (IS_SDVOB(sdvo_reg))
+		dev_priv->hotplug_supported_mask |= SDVOB_HOTPLUG_INT_STATUS;
+	else
+		dev_priv->hotplug_supported_mask |= SDVOC_HOTPLUG_INT_STATUS;
 
-		memcpy(bytes, &sdvo_priv->caps.output_flags, 2);
-		dev_dbg(dev->dev, "%s: No active RGB or TMDS outputs (0x%02x%02x)\n",
-		     SDVO_NAME(sdvo_priv), bytes[0], bytes[1]);
-		goto err_i2c;
-	}
+	drm_encoder_helper_add(&psb_intel_encoder->base, &psb_intel_sdvo_helper_funcs);
 
-	drm_encoder_init(dev, &psb_intel_output->enc, &psb_intel_sdvo_enc_funcs,
-			 encoder_type);
-	drm_encoder_helper_add(&psb_intel_output->enc,
-			       &psb_intel_sdvo_helper_funcs);
-	connector->connector_type = connector_type;
+	/* In default case sdvo lvds is false */
+	if (!psb_intel_sdvo_get_capabilities(psb_intel_sdvo, &psb_intel_sdvo->caps))
+		goto err;
 
-	drm_mode_connector_attach_encoder(&psb_intel_output->base,
-					  &psb_intel_output->enc);
-	drm_sysfs_connector_add(connector);
+	if (psb_intel_sdvo_output_setup(psb_intel_sdvo,
+				    psb_intel_sdvo->caps.output_flags) != true) {
+		DRM_DEBUG_KMS("SDVO output failed to setup on SDVO%c\n",
+			      IS_SDVOB(sdvo_reg) ? 'B' : 'C');
+		goto err;
+	}
 
-	/* Set the input timing to the screen. Assume always input 0. */
-	psb_intel_sdvo_set_target_input(psb_intel_output, true, false);
-
-	psb_intel_sdvo_get_input_pixel_clock_range(psb_intel_output,
-					       &sdvo_priv->pixel_clock_min,
-					       &sdvo_priv->
-					       pixel_clock_max);
-
-
-	dev_dbg(dev->dev, "%s device VID/DID: %02X:%02X.%02X, "
-		  "clock range %dMHz - %dMHz, "
-		  "input 1: %c, input 2: %c, "
-		  "output 1: %c, output 2: %c\n",
-		  SDVO_NAME(sdvo_priv),
-		  sdvo_priv->caps.vendor_id, sdvo_priv->caps.device_id,
-		  sdvo_priv->caps.device_rev_id,
-		  sdvo_priv->pixel_clock_min / 1000,
-		  sdvo_priv->pixel_clock_max / 1000,
-		  (sdvo_priv->caps.sdvo_inputs_mask & 0x1) ? 'Y' : 'N',
-		  (sdvo_priv->caps.sdvo_inputs_mask & 0x2) ? 'Y' : 'N',
-		  /* check currently supported outputs */
-		  sdvo_priv->caps.output_flags &
-		  (SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_RGB0) ? 'Y' : 'N',
-		  sdvo_priv->caps.output_flags &
-		  (SDVO_OUTPUT_TMDS1 | SDVO_OUTPUT_RGB1) ? 'Y' : 'N');
-
-	psb_intel_output->ddc_bus = i2cbus;
+	psb_intel_sdvo_select_ddc_bus(dev_priv, psb_intel_sdvo, sdvo_reg);
 
-	return;
+	/* Set the input timing to the screen. Assume always input 0. */
+	if (!psb_intel_sdvo_set_target_input(psb_intel_sdvo))
+		goto err;
+
+	if (!psb_intel_sdvo_get_input_pixel_clock_range(psb_intel_sdvo,
+						    &psb_intel_sdvo->pixel_clock_min,
+						    &psb_intel_sdvo->pixel_clock_max))
+		goto err;
+
+	DRM_DEBUG_KMS("%s device VID/DID: %02X:%02X.%02X, "
+			"clock range %dMHz - %dMHz, "
+			"input 1: %c, input 2: %c, "
+			"output 1: %c, output 2: %c\n",
+			SDVO_NAME(psb_intel_sdvo),
+			psb_intel_sdvo->caps.vendor_id, psb_intel_sdvo->caps.device_id,
+			psb_intel_sdvo->caps.device_rev_id,
+			psb_intel_sdvo->pixel_clock_min / 1000,
+			psb_intel_sdvo->pixel_clock_max / 1000,
+			(psb_intel_sdvo->caps.sdvo_inputs_mask & 0x1) ? 'Y' : 'N',
+			(psb_intel_sdvo->caps.sdvo_inputs_mask & 0x2) ? 'Y' : 'N',
+			/* check currently supported outputs */
+			psb_intel_sdvo->caps.output_flags &
+			(SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_RGB0) ? 'Y' : 'N',
+			psb_intel_sdvo->caps.output_flags &
+			(SDVO_OUTPUT_TMDS1 | SDVO_OUTPUT_RGB1) ? 'Y' : 'N');
+	return true;
 
-err_i2c:
-	psb_intel_i2c_destroy(psb_intel_output->i2c_bus);
-err_connector:
-	drm_connector_cleanup(connector);
-	kfree(psb_intel_output);
+err:
+	drm_encoder_cleanup(&psb_intel_encoder->base);
+	i2c_del_adapter(&psb_intel_sdvo->ddc);
+	kfree(psb_intel_sdvo);
 
-	return;
+	return false;
 }
diff --git a/drivers/staging/gma500/psb_intel_sdvo_regs.h b/drivers/staging/gma500/psb_intel_sdvo_regs.h
index 96862ea..24e1ede 100644
--- a/drivers/staging/gma500/psb_intel_sdvo_regs.h
+++ b/drivers/staging/gma500/psb_intel_sdvo_regs.h
@@ -1,25 +1,33 @@
 /*
- * SDVO command definitions and structures.
+ * Copyright � 2006-2007 Intel Corporation
  *
- * Copyright (c) 2008, Intel Corporation
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
  *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
  *
  * Authors:
  *	Eric Anholt <eric@anholt.net>
  */
 
+/**
+ * @file SDVO command definitions and structures.
+ */
+
 #define SDVO_OUTPUT_FIRST   (0)
 #define SDVO_OUTPUT_TMDS0   (1 << 0)
 #define SDVO_OUTPUT_RGB0    (1 << 1)
@@ -38,62 +46,64 @@
 #define SDVO_OUTPUT_LAST    (14)
 
 struct psb_intel_sdvo_caps {
-	u8 vendor_id;
-	u8 device_id;
-	u8 device_rev_id;
-	u8 sdvo_version_major;
-	u8 sdvo_version_minor;
-	unsigned int sdvo_inputs_mask:2;
-	unsigned int smooth_scaling:1;
-	unsigned int sharp_scaling:1;
-	unsigned int up_scaling:1;
-	unsigned int down_scaling:1;
-	unsigned int stall_support:1;
-	unsigned int pad:1;
-	u16 output_flags;
-} __packed;
+    u8 vendor_id;
+    u8 device_id;
+    u8 device_rev_id;
+    u8 sdvo_version_major;
+    u8 sdvo_version_minor;
+    unsigned int sdvo_inputs_mask:2;
+    unsigned int smooth_scaling:1;
+    unsigned int sharp_scaling:1;
+    unsigned int up_scaling:1;
+    unsigned int down_scaling:1;
+    unsigned int stall_support:1;
+    unsigned int pad:1;
+    u16 output_flags;
+} __attribute__((packed));
 
 /** This matches the EDID DTD structure, more or less */
 struct psb_intel_sdvo_dtd {
-	struct {
-		u16 clock;	/**< pixel clock, in 10kHz units */
-		u8 h_active;	/**< lower 8 bits (pixels) */
-		u8 h_blank;	/**< lower 8 bits (pixels) */
-		u8 h_high;	/**< upper 4 bits each h_active, h_blank */
-		u8 v_active;	/**< lower 8 bits (lines) */
-		u8 v_blank;	/**< lower 8 bits (lines) */
-		u8 v_high;	/**< upper 4 bits each v_active, v_blank */
-	} part1;
-
-	struct {
-		u8 h_sync_off;
-			/**< lower 8 bits, from hblank start */
-		u8 h_sync_width;/**< lower 8 bits (pixels) */
+    struct {
+	u16 clock;		/**< pixel clock, in 10kHz units */
+	u8 h_active;		/**< lower 8 bits (pixels) */
+	u8 h_blank;		/**< lower 8 bits (pixels) */
+	u8 h_high;		/**< upper 4 bits each h_active, h_blank */
+	u8 v_active;		/**< lower 8 bits (lines) */
+	u8 v_blank;		/**< lower 8 bits (lines) */
+	u8 v_high;		/**< upper 4 bits each v_active, v_blank */
+    } part1;
+
+    struct {
+	u8 h_sync_off;	/**< lower 8 bits, from hblank start */
+	u8 h_sync_width;	/**< lower 8 bits (pixels) */
 	/** lower 4 bits each vsync offset, vsync width */
-		u8 v_sync_off_width;
+	u8 v_sync_off_width;
 	/**
 	 * 2 high bits of hsync offset, 2 high bits of hsync width,
 	 * bits 4-5 of vsync offset, and 2 high bits of vsync width.
 	 */
-		u8 sync_off_width_high;
-		u8 dtd_flags;
-		u8 sdvo_flags;
+	u8 sync_off_width_high;
+	u8 dtd_flags;
+	u8 sdvo_flags;
 	/** bits 6-7 of vsync offset at bits 6-7 */
-		u8 v_sync_off_high;
-		u8 reserved;
-	} part2;
-} __packed;
+	u8 v_sync_off_high;
+	u8 reserved;
+    } part2;
+} __attribute__((packed));
 
 struct psb_intel_sdvo_pixel_clock_range {
-	u16 min;		/**< pixel clock, in 10kHz units */
-	u16 max;		/**< pixel clock, in 10kHz units */
-} __packed;
+    u16 min;			/**< pixel clock, in 10kHz units */
+    u16 max;			/**< pixel clock, in 10kHz units */
+} __attribute__((packed));
 
 struct psb_intel_sdvo_preferred_input_timing_args {
-	u16 clock;
-	u16 width;
-	u16 height;
-} __packed;
+    u16 clock;
+    u16 width;
+    u16 height;
+    u8	interlace:1;
+    u8	scaled:1;
+    u8	pad:6;
+} __attribute__((packed));
 
 /* I2C registers for SDVO */
 #define SDVO_I2C_ARG_0				0x07
@@ -129,7 +139,7 @@ struct psb_intel_sdvo_preferred_input_timing_args {
 
 #define SDVO_CMD_RESET					0x01
 
-/** Returns a struct psb_intel_sdvo_caps */
+/** Returns a struct intel_sdvo_caps */
 #define SDVO_CMD_GET_DEVICE_CAPS			0x02
 
 #define SDVO_CMD_GET_FIRMWARE_REV			0x86
@@ -144,19 +154,18 @@ struct psb_intel_sdvo_preferred_input_timing_args {
  */
 #define SDVO_CMD_GET_TRAINED_INPUTS			0x03
 struct psb_intel_sdvo_get_trained_inputs_response {
-	unsigned int input0_trained:1;
-	unsigned int input1_trained:1;
-	unsigned int pad:6;
-} __packed;
+    unsigned int input0_trained:1;
+    unsigned int input1_trained:1;
+    unsigned int pad:6;
+} __attribute__((packed));
 
-/** Returns a struct psb_intel_sdvo_output_flags of active outputs. */
+/** Returns a struct intel_sdvo_output_flags of active outputs. */
 #define SDVO_CMD_GET_ACTIVE_OUTPUTS			0x04
 
 /**
  * Sets the current set of active outputs.
  *
- * Takes a struct psb_intel_sdvo_output_flags.
- * Must be preceded by a SET_IN_OUT_MAP
+ * Takes a struct intel_sdvo_output_flags.  Must be preceded by a SET_IN_OUT_MAP
  * on multi-output devices.
  */
 #define SDVO_CMD_SET_ACTIVE_OUTPUTS			0x05
@@ -164,9 +173,12 @@ struct psb_intel_sdvo_get_trained_inputs_response {
 /**
  * Returns the current mapping of SDVO inputs to outputs on the device.
  *
- * Returns two struct psb_intel_sdvo_output_flags structures.
+ * Returns two struct intel_sdvo_output_flags structures.
  */
 #define SDVO_CMD_GET_IN_OUT_MAP				0x06
+struct psb_intel_sdvo_in_out_map {
+    u16 in0, in1;
+};
 
 /**
  * Sets the current mapping of SDVO inputs to outputs on the device.
@@ -176,32 +188,33 @@ struct psb_intel_sdvo_get_trained_inputs_response {
 #define SDVO_CMD_SET_IN_OUT_MAP				0x07
 
 /**
- * Returns a struct psb_intel_sdvo_output_flags of attached displays.
+ * Returns a struct intel_sdvo_output_flags of attached displays.
  */
 #define SDVO_CMD_GET_ATTACHED_DISPLAYS			0x0b
 
 /**
- * Returns a struct psb_intel_sdvo_ouptut_flags of displays supporting hot plugging.
+ * Returns a struct intel_sdvo_ouptut_flags of displays supporting hot plugging.
  */
 #define SDVO_CMD_GET_HOT_PLUG_SUPPORT			0x0c
 
 /**
- * Takes a struct psb_intel_sdvo_output_flags.
+ * Takes a struct intel_sdvo_output_flags.
  */
 #define SDVO_CMD_SET_ACTIVE_HOT_PLUG			0x0d
 
 /**
- * Returns a struct psb_intel_sdvo_output_flags of displays with hot plug
+ * Returns a struct intel_sdvo_output_flags of displays with hot plug
  * interrupts enabled.
  */
 #define SDVO_CMD_GET_ACTIVE_HOT_PLUG			0x0e
 
 #define SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE		0x0f
-struct psb_intel_sdvo_get_interrupt_event_source_response {
-	u16 interrupt_status;
-	unsigned int ambient_light_interrupt:1;
-	unsigned int pad:7;
-} __packed;
+struct intel_sdvo_get_interrupt_event_source_response {
+    u16 interrupt_status;
+    unsigned int ambient_light_interrupt:1;
+    unsigned int hdmi_audio_encrypt_change:1;
+    unsigned int pad:6;
+} __attribute__((packed));
 
 /**
  * Selects which input is affected by future input commands.
@@ -212,12 +225,12 @@ struct psb_intel_sdvo_get_interrupt_event_source_response {
  */
 #define SDVO_CMD_SET_TARGET_INPUT			0x10
 struct psb_intel_sdvo_set_target_input_args {
-	unsigned int target_1:1;
-	unsigned int pad:7;
-} __packed;
+    unsigned int target_1:1;
+    unsigned int pad:7;
+} __attribute__((packed));
 
 /**
- * Takes a struct psb_intel_sdvo_output_flags of which outputs are targeted by
+ * Takes a struct intel_sdvo_output_flags of which outputs are targeted by
  * future output commands.
  *
  * Affected commands inclue SET_OUTPUT_TIMINGS_PART[12],
@@ -282,9 +295,9 @@ struct psb_intel_sdvo_set_target_input_args {
 #define SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1	0x1b
 #define SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2	0x1c
 
-/** Returns a struct psb_intel_sdvo_pixel_clock_range */
+/** Returns a struct intel_sdvo_pixel_clock_range */
 #define SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE		0x1d
-/** Returns a struct psb_intel_sdvo_pixel_clock_range */
+/** Returns a struct intel_sdvo_pixel_clock_range */
 #define SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE		0x1e
 
 /** Returns a byte bitfield containing SDVO_CLOCK_RATE_MULT_* flags */
@@ -299,40 +312,412 @@ struct psb_intel_sdvo_set_target_input_args {
 # define SDVO_CLOCK_RATE_MULT_4X				(1 << 3)
 
 #define SDVO_CMD_GET_SUPPORTED_TV_FORMATS		0x27
+/** 6 bytes of bit flags for TV formats shared by all TV format functions */
+struct psb_intel_sdvo_tv_format {
+    unsigned int ntsc_m:1;
+    unsigned int ntsc_j:1;
+    unsigned int ntsc_443:1;
+    unsigned int pal_b:1;
+    unsigned int pal_d:1;
+    unsigned int pal_g:1;
+    unsigned int pal_h:1;
+    unsigned int pal_i:1;
+
+    unsigned int pal_m:1;
+    unsigned int pal_n:1;
+    unsigned int pal_nc:1;
+    unsigned int pal_60:1;
+    unsigned int secam_b:1;
+    unsigned int secam_d:1;
+    unsigned int secam_g:1;
+    unsigned int secam_k:1;
+
+    unsigned int secam_k1:1;
+    unsigned int secam_l:1;
+    unsigned int secam_60:1;
+    unsigned int hdtv_std_smpte_240m_1080i_59:1;
+    unsigned int hdtv_std_smpte_240m_1080i_60:1;
+    unsigned int hdtv_std_smpte_260m_1080i_59:1;
+    unsigned int hdtv_std_smpte_260m_1080i_60:1;
+    unsigned int hdtv_std_smpte_274m_1080i_50:1;
+
+    unsigned int hdtv_std_smpte_274m_1080i_59:1;
+    unsigned int hdtv_std_smpte_274m_1080i_60:1;
+    unsigned int hdtv_std_smpte_274m_1080p_23:1;
+    unsigned int hdtv_std_smpte_274m_1080p_24:1;
+    unsigned int hdtv_std_smpte_274m_1080p_25:1;
+    unsigned int hdtv_std_smpte_274m_1080p_29:1;
+    unsigned int hdtv_std_smpte_274m_1080p_30:1;
+    unsigned int hdtv_std_smpte_274m_1080p_50:1;
+
+    unsigned int hdtv_std_smpte_274m_1080p_59:1;
+    unsigned int hdtv_std_smpte_274m_1080p_60:1;
+    unsigned int hdtv_std_smpte_295m_1080i_50:1;
+    unsigned int hdtv_std_smpte_295m_1080p_50:1;
+    unsigned int hdtv_std_smpte_296m_720p_59:1;
+    unsigned int hdtv_std_smpte_296m_720p_60:1;
+    unsigned int hdtv_std_smpte_296m_720p_50:1;
+    unsigned int hdtv_std_smpte_293m_480p_59:1;
+
+    unsigned int hdtv_std_smpte_170m_480i_59:1;
+    unsigned int hdtv_std_iturbt601_576i_50:1;
+    unsigned int hdtv_std_iturbt601_576p_50:1;
+    unsigned int hdtv_std_eia_7702a_480i_60:1;
+    unsigned int hdtv_std_eia_7702a_480p_60:1;
+    unsigned int pad:3;
+} __attribute__((packed));
 
 #define SDVO_CMD_GET_TV_FORMAT				0x28
 
 #define SDVO_CMD_SET_TV_FORMAT				0x29
 
+/** Returns the resolutiosn that can be used with the given TV format */
+#define SDVO_CMD_GET_SDTV_RESOLUTION_SUPPORT		0x83
+struct psb_intel_sdvo_sdtv_resolution_request {
+    unsigned int ntsc_m:1;
+    unsigned int ntsc_j:1;
+    unsigned int ntsc_443:1;
+    unsigned int pal_b:1;
+    unsigned int pal_d:1;
+    unsigned int pal_g:1;
+    unsigned int pal_h:1;
+    unsigned int pal_i:1;
+
+    unsigned int pal_m:1;
+    unsigned int pal_n:1;
+    unsigned int pal_nc:1;
+    unsigned int pal_60:1;
+    unsigned int secam_b:1;
+    unsigned int secam_d:1;
+    unsigned int secam_g:1;
+    unsigned int secam_k:1;
+
+    unsigned int secam_k1:1;
+    unsigned int secam_l:1;
+    unsigned int secam_60:1;
+    unsigned int pad:5;
+} __attribute__((packed));
+
+struct psb_intel_sdvo_sdtv_resolution_reply {
+    unsigned int res_320x200:1;
+    unsigned int res_320x240:1;
+    unsigned int res_400x300:1;
+    unsigned int res_640x350:1;
+    unsigned int res_640x400:1;
+    unsigned int res_640x480:1;
+    unsigned int res_704x480:1;
+    unsigned int res_704x576:1;
+
+    unsigned int res_720x350:1;
+    unsigned int res_720x400:1;
+    unsigned int res_720x480:1;
+    unsigned int res_720x540:1;
+    unsigned int res_720x576:1;
+    unsigned int res_768x576:1;
+    unsigned int res_800x600:1;
+    unsigned int res_832x624:1;
+
+    unsigned int res_920x766:1;
+    unsigned int res_1024x768:1;
+    unsigned int res_1280x1024:1;
+    unsigned int pad:5;
+} __attribute__((packed));
+
+/* Get supported resolution with squire pixel aspect ratio that can be
+   scaled for the requested HDTV format */
+#define SDVO_CMD_GET_SCALED_HDTV_RESOLUTION_SUPPORT		0x85
+
+struct psb_intel_sdvo_hdtv_resolution_request {
+    unsigned int hdtv_std_smpte_240m_1080i_59:1;
+    unsigned int hdtv_std_smpte_240m_1080i_60:1;
+    unsigned int hdtv_std_smpte_260m_1080i_59:1;
+    unsigned int hdtv_std_smpte_260m_1080i_60:1;
+    unsigned int hdtv_std_smpte_274m_1080i_50:1;
+    unsigned int hdtv_std_smpte_274m_1080i_59:1;
+    unsigned int hdtv_std_smpte_274m_1080i_60:1;
+    unsigned int hdtv_std_smpte_274m_1080p_23:1;
+
+    unsigned int hdtv_std_smpte_274m_1080p_24:1;
+    unsigned int hdtv_std_smpte_274m_1080p_25:1;
+    unsigned int hdtv_std_smpte_274m_1080p_29:1;
+    unsigned int hdtv_std_smpte_274m_1080p_30:1;
+    unsigned int hdtv_std_smpte_274m_1080p_50:1;
+    unsigned int hdtv_std_smpte_274m_1080p_59:1;
+    unsigned int hdtv_std_smpte_274m_1080p_60:1;
+    unsigned int hdtv_std_smpte_295m_1080i_50:1;
+
+    unsigned int hdtv_std_smpte_295m_1080p_50:1;
+    unsigned int hdtv_std_smpte_296m_720p_59:1;
+    unsigned int hdtv_std_smpte_296m_720p_60:1;
+    unsigned int hdtv_std_smpte_296m_720p_50:1;
+    unsigned int hdtv_std_smpte_293m_480p_59:1;
+    unsigned int hdtv_std_smpte_170m_480i_59:1;
+    unsigned int hdtv_std_iturbt601_576i_50:1;
+    unsigned int hdtv_std_iturbt601_576p_50:1;
+
+    unsigned int hdtv_std_eia_7702a_480i_60:1;
+    unsigned int hdtv_std_eia_7702a_480p_60:1;
+    unsigned int pad:6;
+} __attribute__((packed));
+
+struct psb_intel_sdvo_hdtv_resolution_reply {
+    unsigned int res_640x480:1;
+    unsigned int res_800x600:1;
+    unsigned int res_1024x768:1;
+    unsigned int res_1280x960:1;
+    unsigned int res_1400x1050:1;
+    unsigned int res_1600x1200:1;
+    unsigned int res_1920x1440:1;
+    unsigned int res_2048x1536:1;
+
+    unsigned int res_2560x1920:1;
+    unsigned int res_3200x2400:1;
+    unsigned int res_3840x2880:1;
+    unsigned int pad1:5;
+
+    unsigned int res_848x480:1;
+    unsigned int res_1064x600:1;
+    unsigned int res_1280x720:1;
+    unsigned int res_1360x768:1;
+    unsigned int res_1704x960:1;
+    unsigned int res_1864x1050:1;
+    unsigned int res_1920x1080:1;
+    unsigned int res_2128x1200:1;
+
+    unsigned int res_2560x1400:1;
+    unsigned int res_2728x1536:1;
+    unsigned int res_3408x1920:1;
+    unsigned int res_4264x2400:1;
+    unsigned int res_5120x2880:1;
+    unsigned int pad2:3;
+
+    unsigned int res_768x480:1;
+    unsigned int res_960x600:1;
+    unsigned int res_1152x720:1;
+    unsigned int res_1124x768:1;
+    unsigned int res_1536x960:1;
+    unsigned int res_1680x1050:1;
+    unsigned int res_1728x1080:1;
+    unsigned int res_1920x1200:1;
+
+    unsigned int res_2304x1440:1;
+    unsigned int res_2456x1536:1;
+    unsigned int res_3072x1920:1;
+    unsigned int res_3840x2400:1;
+    unsigned int res_4608x2880:1;
+    unsigned int pad3:3;
+
+    unsigned int res_1280x1024:1;
+    unsigned int pad4:7;
+
+    unsigned int res_1280x768:1;
+    unsigned int pad5:7;
+} __attribute__((packed));
+
+/* Get supported power state returns info for encoder and monitor, rely on
+   last SetTargetInput and SetTargetOutput calls */
 #define SDVO_CMD_GET_SUPPORTED_POWER_STATES		0x2a
+/* Get power state returns info for encoder and monitor, rely on last
+   SetTargetInput and SetTargetOutput calls */
+#define SDVO_CMD_GET_POWER_STATE			0x2b
 #define SDVO_CMD_GET_ENCODER_POWER_STATE		0x2b
 #define SDVO_CMD_SET_ENCODER_POWER_STATE		0x2c
 # define SDVO_ENCODER_STATE_ON					(1 << 0)
 # define SDVO_ENCODER_STATE_STANDBY				(1 << 1)
 # define SDVO_ENCODER_STATE_SUSPEND				(1 << 2)
 # define SDVO_ENCODER_STATE_OFF					(1 << 3)
-
-#define SDVO_CMD_SET_TV_RESOLUTION_SUPPORT		0x93
+# define SDVO_MONITOR_STATE_ON					(1 << 4)
+# define SDVO_MONITOR_STATE_STANDBY				(1 << 5)
+# define SDVO_MONITOR_STATE_SUSPEND				(1 << 6)
+# define SDVO_MONITOR_STATE_OFF					(1 << 7)
+
+#define SDVO_CMD_GET_MAX_PANEL_POWER_SEQUENCING		0x2d
+#define SDVO_CMD_GET_PANEL_POWER_SEQUENCING		0x2e
+#define SDVO_CMD_SET_PANEL_POWER_SEQUENCING		0x2f
+/**
+ * The panel power sequencing parameters are in units of milliseconds.
+ * The high fields are bits 8:9 of the 10-bit values.
+ */
+struct psb_sdvo_panel_power_sequencing {
+    u8 t0;
+    u8 t1;
+    u8 t2;
+    u8 t3;
+    u8 t4;
+
+    unsigned int t0_high:2;
+    unsigned int t1_high:2;
+    unsigned int t2_high:2;
+    unsigned int t3_high:2;
+
+    unsigned int t4_high:2;
+    unsigned int pad:6;
+} __attribute__((packed));
+
+#define SDVO_CMD_GET_MAX_BACKLIGHT_LEVEL		0x30
+struct sdvo_max_backlight_reply {
+    u8 max_value;
+    u8 default_value;
+} __attribute__((packed));
+
+#define SDVO_CMD_GET_BACKLIGHT_LEVEL			0x31
+#define SDVO_CMD_SET_BACKLIGHT_LEVEL			0x32
+
+#define SDVO_CMD_GET_AMBIENT_LIGHT			0x33
+struct sdvo_get_ambient_light_reply {
+    u16 trip_low;
+    u16 trip_high;
+    u16 value;
+} __attribute__((packed));
+#define SDVO_CMD_SET_AMBIENT_LIGHT			0x34
+struct sdvo_set_ambient_light_reply {
+    u16 trip_low;
+    u16 trip_high;
+    unsigned int enable:1;
+    unsigned int pad:7;
+} __attribute__((packed));
+
+/* Set display power state */
+#define SDVO_CMD_SET_DISPLAY_POWER_STATE		0x7d
+# define SDVO_DISPLAY_STATE_ON				(1 << 0)
+# define SDVO_DISPLAY_STATE_STANDBY			(1 << 1)
+# define SDVO_DISPLAY_STATE_SUSPEND			(1 << 2)
+# define SDVO_DISPLAY_STATE_OFF				(1 << 3)
+
+#define SDVO_CMD_GET_SUPPORTED_ENHANCEMENTS		0x84
+struct psb_intel_sdvo_enhancements_reply {
+    unsigned int flicker_filter:1;
+    unsigned int flicker_filter_adaptive:1;
+    unsigned int flicker_filter_2d:1;
+    unsigned int saturation:1;
+    unsigned int hue:1;
+    unsigned int brightness:1;
+    unsigned int contrast:1;
+    unsigned int overscan_h:1;
+
+    unsigned int overscan_v:1;
+    unsigned int hpos:1;
+    unsigned int vpos:1;
+    unsigned int sharpness:1;
+    unsigned int dot_crawl:1;
+    unsigned int dither:1;
+    unsigned int tv_chroma_filter:1;
+    unsigned int tv_luma_filter:1;
+} __attribute__((packed));
+
+/* Picture enhancement limits below are dependent on the current TV format,
+ * and thus need to be queried and set after it.
+ */
+#define SDVO_CMD_GET_MAX_FLICKER_FILTER			0x4d
+#define SDVO_CMD_GET_MAX_FLICKER_FILTER_ADAPTIVE	0x7b
+#define SDVO_CMD_GET_MAX_FLICKER_FILTER_2D		0x52
+#define SDVO_CMD_GET_MAX_SATURATION			0x55
+#define SDVO_CMD_GET_MAX_HUE				0x58
+#define SDVO_CMD_GET_MAX_BRIGHTNESS			0x5b
+#define SDVO_CMD_GET_MAX_CONTRAST			0x5e
+#define SDVO_CMD_GET_MAX_OVERSCAN_H			0x61
+#define SDVO_CMD_GET_MAX_OVERSCAN_V			0x64
+#define SDVO_CMD_GET_MAX_HPOS				0x67
+#define SDVO_CMD_GET_MAX_VPOS				0x6a
+#define SDVO_CMD_GET_MAX_SHARPNESS			0x6d
+#define SDVO_CMD_GET_MAX_TV_CHROMA_FILTER		0x74
+#define SDVO_CMD_GET_MAX_TV_LUMA_FILTER			0x77
+struct psb_intel_sdvo_enhancement_limits_reply {
+    u16 max_value;
+    u16 default_value;
+} __attribute__((packed));
+
+#define SDVO_CMD_GET_LVDS_PANEL_INFORMATION		0x7f
+#define SDVO_CMD_SET_LVDS_PANEL_INFORMATION		0x80
+# define SDVO_LVDS_COLOR_DEPTH_18			(0 << 0)
+# define SDVO_LVDS_COLOR_DEPTH_24			(1 << 0)
+# define SDVO_LVDS_CONNECTOR_SPWG			(0 << 2)
+# define SDVO_LVDS_CONNECTOR_OPENLDI			(1 << 2)
+# define SDVO_LVDS_SINGLE_CHANNEL			(0 << 4)
+# define SDVO_LVDS_DUAL_CHANNEL				(1 << 4)
+
+#define SDVO_CMD_GET_FLICKER_FILTER			0x4e
+#define SDVO_CMD_SET_FLICKER_FILTER			0x4f
+#define SDVO_CMD_GET_FLICKER_FILTER_ADAPTIVE		0x50
+#define SDVO_CMD_SET_FLICKER_FILTER_ADAPTIVE		0x51
+#define SDVO_CMD_GET_FLICKER_FILTER_2D			0x53
+#define SDVO_CMD_SET_FLICKER_FILTER_2D			0x54
+#define SDVO_CMD_GET_SATURATION				0x56
+#define SDVO_CMD_SET_SATURATION				0x57
+#define SDVO_CMD_GET_HUE				0x59
+#define SDVO_CMD_SET_HUE				0x5a
+#define SDVO_CMD_GET_BRIGHTNESS				0x5c
+#define SDVO_CMD_SET_BRIGHTNESS				0x5d
+#define SDVO_CMD_GET_CONTRAST				0x5f
+#define SDVO_CMD_SET_CONTRAST				0x60
+#define SDVO_CMD_GET_OVERSCAN_H				0x62
+#define SDVO_CMD_SET_OVERSCAN_H				0x63
+#define SDVO_CMD_GET_OVERSCAN_V				0x65
+#define SDVO_CMD_SET_OVERSCAN_V				0x66
+#define SDVO_CMD_GET_HPOS				0x68
+#define SDVO_CMD_SET_HPOS				0x69
+#define SDVO_CMD_GET_VPOS				0x6b
+#define SDVO_CMD_SET_VPOS				0x6c
+#define SDVO_CMD_GET_SHARPNESS				0x6e
+#define SDVO_CMD_SET_SHARPNESS				0x6f
+#define SDVO_CMD_GET_TV_CHROMA_FILTER			0x75
+#define SDVO_CMD_SET_TV_CHROMA_FILTER			0x76
+#define SDVO_CMD_GET_TV_LUMA_FILTER			0x78
+#define SDVO_CMD_SET_TV_LUMA_FILTER			0x79
+struct psb_intel_sdvo_enhancements_arg {
+    u16 value;
+}__attribute__((packed));
+
+#define SDVO_CMD_GET_DOT_CRAWL				0x70
+#define SDVO_CMD_SET_DOT_CRAWL				0x71
+# define SDVO_DOT_CRAWL_ON					(1 << 0)
+# define SDVO_DOT_CRAWL_DEFAULT_ON				(1 << 1)
+
+#define SDVO_CMD_GET_DITHER				0x72
+#define SDVO_CMD_SET_DITHER				0x73
+# define SDVO_DITHER_ON						(1 << 0)
+# define SDVO_DITHER_DEFAULT_ON					(1 << 1)
 
 #define SDVO_CMD_SET_CONTROL_BUS_SWITCH			0x7a
-# define SDVO_CONTROL_BUS_PROM				0x0
-# define SDVO_CONTROL_BUS_DDC1				0x1
-# define SDVO_CONTROL_BUS_DDC2				0x2
-# define SDVO_CONTROL_BUS_DDC3				0x3
-
-/* SDVO Bus & SDVO Inputs wiring details*/
-/* Bit 0: Is SDVOB connected to In0 (1 = yes, 0 = no*/
-/* Bit 1: Is SDVOB connected to In1 (1 = yes, 0 = no*/
-/* Bit 2: Is SDVOC connected to In0 (1 = yes, 0 = no*/
-/* Bit 3: Is SDVOC connected to In1 (1 = yes, 0 = no*/
-#define SDVOB_IN0 0x01
-#define SDVOB_IN1 0x02
-#define SDVOC_IN0 0x04
-#define SDVOC_IN1 0x08
-
-#define SDVO_DEVICE_NONE 0x00
-#define        SDVO_DEVICE_CRT 0x01
-#define        SDVO_DEVICE_TV 0x02
-#define        SDVO_DEVICE_LVDS 0x04
-#define        SDVO_DEVICE_TMDS 0x08
-
+# define SDVO_CONTROL_BUS_PROM				(1 << 0)
+# define SDVO_CONTROL_BUS_DDC1				(1 << 1)
+# define SDVO_CONTROL_BUS_DDC2				(1 << 2)
+# define SDVO_CONTROL_BUS_DDC3				(1 << 3)
+
+/* HDMI op codes */
+#define SDVO_CMD_GET_SUPP_ENCODE	0x9d
+#define SDVO_CMD_GET_ENCODE		0x9e
+#define SDVO_CMD_SET_ENCODE		0x9f
+  #define SDVO_ENCODE_DVI	0x0
+  #define SDVO_ENCODE_HDMI	0x1
+#define SDVO_CMD_SET_PIXEL_REPLI	0x8b
+#define SDVO_CMD_GET_PIXEL_REPLI	0x8c
+#define SDVO_CMD_GET_COLORIMETRY_CAP	0x8d
+#define SDVO_CMD_SET_COLORIMETRY	0x8e
+  #define SDVO_COLORIMETRY_RGB256   0x0
+  #define SDVO_COLORIMETRY_RGB220   0x1
+  #define SDVO_COLORIMETRY_YCrCb422 0x3
+  #define SDVO_COLORIMETRY_YCrCb444 0x4
+#define SDVO_CMD_GET_COLORIMETRY	0x8f
+#define SDVO_CMD_GET_AUDIO_ENCRYPT_PREFER 0x90
+#define SDVO_CMD_SET_AUDIO_STAT		0x91
+#define SDVO_CMD_GET_AUDIO_STAT		0x92
+#define SDVO_CMD_SET_HBUF_INDEX		0x93
+#define SDVO_CMD_GET_HBUF_INDEX		0x94
+#define SDVO_CMD_GET_HBUF_INFO		0x95
+#define SDVO_CMD_SET_HBUF_AV_SPLIT	0x96
+#define SDVO_CMD_GET_HBUF_AV_SPLIT	0x97
+#define SDVO_CMD_SET_HBUF_DATA		0x98
+#define SDVO_CMD_GET_HBUF_DATA		0x99
+#define SDVO_CMD_SET_HBUF_TXRATE	0x9a
+#define SDVO_CMD_GET_HBUF_TXRATE	0x9b
+  #define SDVO_HBUF_TX_DISABLED	(0 << 6)
+  #define SDVO_HBUF_TX_ONCE	(2 << 6)
+  #define SDVO_HBUF_TX_VSYNC	(3 << 6)
+#define SDVO_CMD_GET_AUDIO_TX_INFO	0x9c
+#define SDVO_NEED_TO_STALL  (1 << 7)
+
+struct psb_intel_sdvo_encode {
+    u8 dvi_rev;
+    u8 hdmi_rev;
+} __attribute__ ((packed));
-- 
1.7.4.1

