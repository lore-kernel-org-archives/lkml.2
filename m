Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2KIOAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:00:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53416 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KIN7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:59:55 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
Date: Fri,  9 Nov 2012 14:59:38 +0100
Message-Id: <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:DHOoibdysbaYTIVsSc8jMe/7E4age/bXFarMb4P+uMl
 QyZvFclymP15PftEO7cRElnnnHmI2eAoyqdjsJXUK27VXeXmcO
 bmdR/hpKO2rrHd2V407kf0KIEh0h9IqL4/g1ax/Nh7r/IFuRVg
 GFjrhqAb9T0EkF315i132Ee1jsIHySAwNiiS9SqhfhqFHLGnLH
 RxpWcXebgSAybiA/GJw918h2eiy/fEXDF730NIOe13vZHpkeSL
 lm/g59ll3J38+yJZqYS6l99wu59yheqBaGCsFgSoXOK+NRYLkV
 PundqXZB1amzATo+dUX5FC4n8tW4uCgVB2j8aD3vZrpdhwUBg5
 oXbIUr60z7H3ItIRdhuxOJaydWGC0ZgJIenXz7VudIudy20iva
 4XgsJ5d7o3008LnWbi0sS9QCOlfjr1II9e9B8acVeqqyVRQ5Qh
 PHvVx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds a KMS driver for the Tegra20 SoC. This includes basic
support for host1x and the two display controllers found on the Tegra20
SoC. Each display controller can drive a separate RGB/LVDS output.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 .../bindings/gpu/drm/nvidia,tegra20-host1x.txt     | 191 +++++
 drivers/gpu/drm/Kconfig                            |   2 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/tegra/Kconfig                      |  23 +
 drivers/gpu/drm/tegra/Makefile                     |   7 +
 drivers/gpu/drm/tegra/dc.c                         | 817 +++++++++++++++++++++
 drivers/gpu/drm/tegra/dc.h                         | 384 ++++++++++
 drivers/gpu/drm/tegra/drm.c                        | 115 +++
 drivers/gpu/drm/tegra/drm.h                        | 233 ++++++
 drivers/gpu/drm/tegra/fb.c                         |  56 ++
 drivers/gpu/drm/tegra/host1x.c                     | 313 ++++++++
 drivers/gpu/drm/tegra/output.c                     | 275 +++++++
 drivers/gpu/drm/tegra/rgb.c                        | 200 +++++
 13 files changed, 2617 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpu/drm/nvidia,tegra20-host1x.txt
 create mode 100644 drivers/gpu/drm/tegra/Kconfig
 create mode 100644 drivers/gpu/drm/tegra/Makefile
 create mode 100644 drivers/gpu/drm/tegra/dc.c
 create mode 100644 drivers/gpu/drm/tegra/dc.h
 create mode 100644 drivers/gpu/drm/tegra/drm.c
 create mode 100644 drivers/gpu/drm/tegra/drm.h
 create mode 100644 drivers/gpu/drm/tegra/fb.c
 create mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 drivers/gpu/drm/tegra/output.c
 create mode 100644 drivers/gpu/drm/tegra/rgb.c

diff --git a/Documentation/devicetree/bindings/gpu/drm/nvidia,tegra20-host1x.txt b/Documentation/devicetree/bindings/gpu/drm/nvidia,tegra20-host1x.txt
new file mode 100644
index 0000000..b4fa934
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpu/drm/nvidia,tegra20-host1x.txt
@@ -0,0 +1,191 @@
+NVIDIA Tegra host1x
+
+Required properties:
+- compatible: "nvidia,tegra<chip>-host1x"
+- reg: Physical base address and length of the controller's registers.
+- interrupts: The interrupt outputs from the controller.
+- #address-cells: The number of cells used to represent physical base addresses
+  in the host1x address space. Should be 1.
+- #size-cells: The number of cells used to represent the size of an address
+  range in the host1x address space. Should be 1.
+- ranges: The mapping of the host1x address space to the CPU address space.
+
+The host1x top-level node defines a number of children, each representing one
+of the following host1x client modules:
+
+- mpe: video encoder
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-mpe"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+
+- vi: video input
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-vi"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+
+- epp: encoder pre-processor
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-epp"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+
+- isp: image signal processor
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-isp"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+
+- gr2d: 2D graphics engine
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-gr2d"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+
+- gr3d: 3D graphics engine
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-gr3d"
+  - reg: Physical base address and length of the controller's registers.
+
+- dc: display controller
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-dc"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+
+  Each display controller node has a child node, named "rgb", that represents
+  the RGB output associated with the controller. It can take the following
+  optional properties:
+  - nvidia,ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
+  - nvidia,hpd-gpio: specifies a GPIO used for hotplug detection
+  - nvidia,edid: supplies a binary EDID blob
+
+- hdmi: High Definition Multimedia Interface
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-hdmi"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+  - vdd-supply: regulator for supply voltage
+  - pll-supply: regulator for PLL
+
+  Optional properties:
+  - nvidia,ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
+  - nvidia,hpd-gpio: specifies a GPIO used for hotplug detection
+  - nvidia,edid: supplies a binary EDID blob
+
+- tvo: TV encoder output
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-tvo"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+
+- dsi: display serial interface
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-dsi"
+  - reg: Physical base address and length of the controller's registers.
+
+Example:
+
+/ {
+	...
+
+	host1x {
+		compatible = "nvidia,tegra20-host1x", "simple-bus";
+		reg = <0x50000000 0x00024000>;
+		interrupts = <0 65 0x04   /* mpcore syncpt */
+			      0 67 0x04>; /* mpcore general */
+
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		ranges = <0x54000000 0x54000000 0x04000000>;
+
+		mpe {
+			compatible = "nvidia,tegra20-mpe";
+			reg = <0x54040000 0x00040000>;
+			interrupts = <0 68 0x04>;
+		};
+
+		vi {
+			compatible = "nvidia,tegra20-vi";
+			reg = <0x54080000 0x00040000>;
+			interrupts = <0 69 0x04>;
+		};
+
+		epp {
+			compatible = "nvidia,tegra20-epp";
+			reg = <0x540c0000 0x00040000>;
+			interrupts = <0 70 0x04>;
+		};
+
+		isp {
+			compatible = "nvidia,tegra20-isp";
+			reg = <0x54100000 0x00040000>;
+			interrupts = <0 71 0x04>;
+		};
+
+		gr2d {
+			compatible = "nvidia,tegra20-gr2d";
+			reg = <0x54140000 0x00040000>;
+			interrupts = <0 72 0x04>;
+		};
+
+		gr3d {
+			compatible = "nvidia,tegra20-gr3d";
+			reg = <0x54180000 0x00040000>;
+		};
+
+		dc@54200000 {
+			compatible = "nvidia,tegra20-dc";
+			reg = <0x54200000 0x00040000>;
+			interrupts = <0 73 0x04>;
+
+			rgb {
+				status = "disabled";
+			};
+		};
+
+		dc@54240000 {
+			compatible = "nvidia,tegra20-dc";
+			reg = <0x54240000 0x00040000>;
+			interrupts = <0 74 0x04>;
+
+			rgb {
+				status = "disabled";
+			};
+		};
+
+		hdmi {
+			compatible = "nvidia,tegra20-hdmi";
+			reg = <0x54280000 0x00040000>;
+			interrupts = <0 75 0x04>;
+			status = "disabled";
+		};
+
+		tvo {
+			compatible = "nvidia,tegra20-tvo";
+			reg = <0x542c0000 0x00040000>;
+			interrupts = <0 76 0x04>;
+			status = "disabled";
+		};
+
+		dsi {
+			compatible = "nvidia,tegra20-dsi";
+			reg = <0x54300000 0x00040000>;
+			status = "disabled";
+		};
+	};
+
+	...
+};
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 18321b68b..983201b 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -210,3 +210,5 @@ source "drivers/gpu/drm/mgag200/Kconfig"
 source "drivers/gpu/drm/cirrus/Kconfig"
 
 source "drivers/gpu/drm/shmobile/Kconfig"
+
+source "drivers/gpu/drm/tegra/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 2ff5cef..0bfda06 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -48,4 +48,5 @@ obj-$(CONFIG_DRM_GMA500) += gma500/
 obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
 obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
+obj-$(CONFIG_DRM_TEGRA) += tegra/
 obj-y			+= i2c/
diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
new file mode 100644
index 0000000..be1daf7
--- /dev/null
+++ b/drivers/gpu/drm/tegra/Kconfig
@@ -0,0 +1,23 @@
+config DRM_TEGRA
+	tristate "NVIDIA Tegra DRM"
+	depends on DRM && OF && ARCH_TEGRA
+	select DRM_KMS_HELPER
+	select DRM_GEM_CMA_HELPER
+	select DRM_KMS_CMA_HELPER
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  Choose this option if you have an NVIDIA Tegra SoC.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called tegra-drm.
+
+if DRM_TEGRA
+
+config DRM_TEGRA_DEBUG
+	bool "NVIDIA Tegra DRM debug support"
+	help
+	  Say yes here to enable debugging support.
+
+endif
diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
new file mode 100644
index 0000000..624a807
--- /dev/null
+++ b/drivers/gpu/drm/tegra/Makefile
@@ -0,0 +1,7 @@
+ccflags-y := -Iinclude/drm
+ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
+
+tegra-drm-y := drm.o fb.o dc.o host1x.o
+tegra-drm-y += output.o rgb.o
+
+obj-$(CONFIG_DRM_TEGRA) += tegra-drm.o
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
new file mode 100644
index 0000000..213a729
--- /dev/null
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -0,0 +1,817 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include <mach/clk.h>
+
+#include "drm.h"
+#include "dc.h"
+
+struct tegra_dc_window {
+	fixed20_12 x;
+	fixed20_12 y;
+	fixed20_12 w;
+	fixed20_12 h;
+	unsigned int outx;
+	unsigned int outy;
+	unsigned int outw;
+	unsigned int outh;
+	unsigned int stride;
+	unsigned int fmt;
+};
+
+static const struct drm_crtc_funcs tegra_crtc_funcs = {
+	.set_config = drm_crtc_helper_set_config,
+	.destroy = drm_crtc_cleanup,
+};
+
+static void tegra_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		if (!dc->enabled) {
+			clk_prepare_enable(dc->clk);
+			dc->enabled = true;
+		}
+		break;
+
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+	case DRM_MODE_DPMS_OFF:
+		if (dc->enabled) {
+			clk_disable_unprepare(dc->clk);
+			dc->enabled = false;
+		}
+		break;
+	}
+}
+
+static bool tegra_crtc_mode_fixup(struct drm_crtc *crtc,
+				  const struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted)
+{
+	return true;
+}
+
+static inline u32 compute_dda_inc(fixed20_12 inf, unsigned int out, bool v,
+				  unsigned int bpp)
+{
+	fixed20_12 outf = dfixed_init(out);
+	u32 dda_inc;
+	int max;
+
+	if (v)
+		max = 15;
+	else {
+		switch (bpp) {
+		case 2:
+			max = 8;
+			break;
+
+		default:
+			WARN_ON_ONCE(1);
+			/* fallthrough */
+		case 4:
+			max = 4;
+			break;
+		}
+	}
+
+	outf.full = max_t(u32, outf.full - dfixed_const(1), dfixed_const(1));
+	inf.full -= dfixed_const(1);
+
+	dda_inc = dfixed_div(inf, outf);
+	dda_inc = min_t(u32, dda_inc, dfixed_const(max));
+
+	return dda_inc;
+}
+
+static inline u32 compute_initial_dda(fixed20_12 in)
+{
+	return dfixed_frac(in);
+}
+
+static int tegra_dc_set_timings(struct tegra_dc *dc,
+				struct drm_display_mode *mode)
+{
+	/* TODO: For HDMI compliance, h & v ref_to_sync should be set to 1 */
+	unsigned int h_ref_to_sync = 0;
+	unsigned int v_ref_to_sync = 0;
+	unsigned long value;
+
+	tegra_dc_writel(dc, 0x0, DC_DISP_DISP_TIMING_OPTIONS);
+
+	value = (v_ref_to_sync << 16) | h_ref_to_sync;
+	tegra_dc_writel(dc, value, DC_DISP_REF_TO_SYNC);
+
+	value = ((mode->vsync_end - mode->vsync_start) << 16) |
+		((mode->hsync_end - mode->hsync_start) <<  0);
+	tegra_dc_writel(dc, value, DC_DISP_SYNC_WIDTH);
+
+	value = ((mode->vsync_start - mode->vdisplay) << 16) |
+		((mode->hsync_start - mode->hdisplay) <<  0);
+	tegra_dc_writel(dc, value, DC_DISP_BACK_PORCH);
+
+	value = ((mode->vtotal - mode->vsync_end) << 16) |
+		((mode->htotal - mode->hsync_end) <<  0);
+	tegra_dc_writel(dc, value, DC_DISP_FRONT_PORCH);
+
+	value = (mode->vdisplay << 16) | mode->hdisplay;
+	tegra_dc_writel(dc, value, DC_DISP_ACTIVE);
+
+	return 0;
+}
+
+static int tegra_crtc_setup_clk(struct drm_crtc *crtc,
+				struct drm_display_mode *mode,
+				unsigned long *div)
+{
+	unsigned long pclk = mode->clock * 1000, rate;
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+	struct tegra_output *output = NULL;
+	struct drm_encoder *encoder;
+	long err;
+
+	list_for_each_entry(encoder, &crtc->dev->mode_config.encoder_list, head)
+		if (encoder->crtc == crtc) {
+			output = encoder_to_output(encoder);
+			break;
+		}
+
+	if (!output)
+		return -ENODEV;
+
+	/*
+	 * This assumes that the display controller will divide its parent
+	 * clock by 2 to generate the pixel clock.
+	 */
+	err = tegra_output_setup_clock(output, dc->clk, pclk * 2);
+	if (err < 0) {
+		dev_err(dc->dev, "failed to setup clock: %ld\n", err);
+		return err;
+	}
+
+	rate = clk_get_rate(dc->clk);
+	*div = (rate * 2 / pclk) - 2;
+
+	DRM_DEBUG_KMS("rate: %lu, div: %lu\n", rate, *div);
+
+	return 0;
+}
+
+static int tegra_crtc_mode_set(struct drm_crtc *crtc,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted,
+			       int x, int y, struct drm_framebuffer *old_fb)
+{
+	struct tegra_framebuffer *fb = to_tegra_fb(crtc->fb);
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+	unsigned int h_dda, v_dda, bpp;
+	struct tegra_dc_window win;
+	unsigned long div, value;
+	int err;
+
+	err = tegra_crtc_setup_clk(crtc, mode, &div);
+	if (err) {
+		dev_err(dc->dev, "failed to setup clock for CRTC: %d\n", err);
+		return err;
+	}
+
+	/* program display mode */
+	tegra_dc_set_timings(dc, mode);
+
+	value = DE_SELECT_ACTIVE | DE_CONTROL_NORMAL;
+	tegra_dc_writel(dc, value, DC_DISP_DATA_ENABLE_OPTIONS);
+
+	value = tegra_dc_readl(dc, DC_COM_PIN_OUTPUT_POLARITY(1));
+	value &= ~LVS_OUTPUT_POLARITY_LOW;
+	value &= ~LHS_OUTPUT_POLARITY_LOW;
+	tegra_dc_writel(dc, value, DC_COM_PIN_OUTPUT_POLARITY(1));
+
+	value = DISP_DATA_FORMAT_DF1P1C | DISP_ALIGNMENT_MSB |
+		DISP_ORDER_RED_BLUE;
+	tegra_dc_writel(dc, value, DC_DISP_DISP_INTERFACE_CONTROL);
+
+	tegra_dc_writel(dc, 0x00010001, DC_DISP_SHIFT_CLOCK_OPTIONS);
+
+	value = SHIFT_CLK_DIVIDER(div) | PIXEL_CLK_DIVIDER_PCD1;
+	tegra_dc_writel(dc, value, DC_DISP_DISP_CLOCK_CONTROL);
+
+	/* setup window parameters */
+	memset(&win, 0, sizeof(win));
+	win.x.full = dfixed_const(0);
+	win.y.full = dfixed_const(0);
+	win.w.full = dfixed_const(mode->hdisplay);
+	win.h.full = dfixed_const(mode->vdisplay);
+	win.outx = 0;
+	win.outy = 0;
+	win.outw = mode->hdisplay;
+	win.outh = mode->vdisplay;
+
+	switch (crtc->fb->pixel_format) {
+	case DRM_FORMAT_XRGB8888:
+		win.fmt = WIN_COLOR_DEPTH_B8G8R8A8;
+		break;
+
+	case DRM_FORMAT_RGB565:
+		win.fmt = WIN_COLOR_DEPTH_B5G6R5;
+		break;
+
+	default:
+		win.fmt = WIN_COLOR_DEPTH_B8G8R8A8;
+		WARN_ON(1);
+		break;
+	}
+
+	bpp = crtc->fb->bits_per_pixel / 8;
+	win.stride = win.outw * bpp;
+
+	/* program window registers */
+	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_WINDOW_HEADER);
+	value |= WINDOW_A_SELECT;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_WINDOW_HEADER);
+
+	tegra_dc_writel(dc, win.fmt, DC_WIN_COLOR_DEPTH);
+	tegra_dc_writel(dc, 0, DC_WIN_BYTE_SWAP);
+
+	value = V_POSITION(win.outy) | H_POSITION(win.outx);
+	tegra_dc_writel(dc, value, DC_WIN_POSITION);
+
+	value = V_SIZE(win.outh) | H_SIZE(win.outw);
+	tegra_dc_writel(dc, value, DC_WIN_SIZE);
+
+	value = V_PRESCALED_SIZE(dfixed_trunc(win.h)) |
+		H_PRESCALED_SIZE(dfixed_trunc(win.w) * bpp);
+	tegra_dc_writel(dc, value, DC_WIN_PRESCALED_SIZE);
+
+	h_dda = compute_dda_inc(win.w, win.outw, false, bpp);
+	v_dda = compute_dda_inc(win.h, win.outh, true, bpp);
+
+	value = V_DDA_INC(v_dda) | H_DDA_INC(h_dda);
+	tegra_dc_writel(dc, value, DC_WIN_DDA_INC);
+
+	h_dda = compute_initial_dda(win.x);
+	v_dda = compute_initial_dda(win.y);
+
+	tegra_dc_writel(dc, h_dda, DC_WIN_H_INITIAL_DDA);
+	tegra_dc_writel(dc, v_dda, DC_WIN_V_INITIAL_DDA);
+
+	tegra_dc_writel(dc, 0, DC_WIN_UV_BUF_STRIDE);
+	tegra_dc_writel(dc, 0, DC_WIN_BUF_STRIDE);
+
+	tegra_dc_writel(dc, fb->obj->paddr, DC_WINBUF_START_ADDR);
+	tegra_dc_writel(dc, win.stride, DC_WIN_LINE_STRIDE);
+	tegra_dc_writel(dc, dfixed_trunc(win.x) * bpp,
+			DC_WINBUF_ADDR_H_OFFSET);
+	tegra_dc_writel(dc, dfixed_trunc(win.y), DC_WINBUF_ADDR_V_OFFSET);
+
+	value = WIN_ENABLE;
+
+	if (bpp < 24)
+		value |= COLOR_EXPAND;
+
+	tegra_dc_writel(dc, value, DC_WIN_WIN_OPTIONS);
+
+	tegra_dc_writel(dc, 0xff00, DC_WIN_BLEND_NOKEY);
+	tegra_dc_writel(dc, 0xff00, DC_WIN_BLEND_1WIN);
+
+	return 0;
+}
+
+static void tegra_crtc_prepare(struct drm_crtc *crtc)
+{
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+	unsigned int syncpt;
+	unsigned long value;
+	int err;
+
+	/* hardware initialization */
+	err = clk_prepare_enable(dc->clk);
+	if (err < 0)
+		dev_err(dc->dev, "failed to enable clock: %d\n", err);
+
+	tegra_periph_reset_deassert(dc->clk);
+	usleep_range(10000, 20000);
+	dc->enabled = true;
+
+	if (dc->pipe)
+		syncpt = SYNCPT_VBLANK1;
+	else
+		syncpt = SYNCPT_VBLANK0;
+
+	/* initialize display controller */
+	tegra_dc_writel(dc, 0x00000100, DC_CMD_GENERAL_INCR_SYNCPT_CNTRL);
+	tegra_dc_writel(dc, 0x100 | syncpt, DC_CMD_CONT_SYNCPT_VSYNC);
+
+	value = WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT | WIN_A_OF_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_TYPE);
+
+	value = WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT |
+		WIN_A_OF_INT | WIN_B_OF_INT | WIN_C_OF_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_POLARITY);
+
+	value = PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
+		PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
+
+	value = tegra_dc_readl(dc, DC_CMD_DISPLAY_COMMAND);
+	value |= DISP_CTRL_MODE_C_DISPLAY;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
+
+	/* initialize timer */
+	value = CURSOR_THRESHOLD(0) | WINDOW_A_THRESHOLD(0x20) |
+		WINDOW_B_THRESHOLD(0x20) | WINDOW_C_THRESHOLD(0x20);
+	tegra_dc_writel(dc, value, DC_DISP_DISP_MEM_HIGH_PRIORITY);
+
+	value = CURSOR_THRESHOLD(0) | WINDOW_A_THRESHOLD(1) |
+		WINDOW_B_THRESHOLD(1) | WINDOW_C_THRESHOLD(1);
+	tegra_dc_writel(dc, value, DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER);
+
+	value = VBLANK_INT | WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_MASK);
+
+	value = VBLANK_INT | WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_ENABLE);
+}
+
+static void tegra_crtc_commit(struct drm_crtc *crtc)
+{
+	struct tegra_dc *dc = to_tegra_dc(crtc);
+	unsigned long update_mask;
+	unsigned long value;
+
+	update_mask = GENERAL_ACT_REQ | WIN_A_ACT_REQ;
+
+	tegra_dc_writel(dc, update_mask << 8, DC_CMD_STATE_CONTROL);
+
+	value = tegra_dc_readl(dc, DC_CMD_INT_ENABLE);
+	value |= FRAME_END_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_ENABLE);
+
+	value = tegra_dc_readl(dc, DC_CMD_INT_MASK);
+	value |= FRAME_END_INT;
+	tegra_dc_writel(dc, value, DC_CMD_INT_MASK);
+
+	tegra_dc_writel(dc, update_mask, DC_CMD_STATE_CONTROL);
+}
+
+static void tegra_crtc_load_lut(struct drm_crtc *crtc)
+{
+}
+
+static const struct drm_crtc_helper_funcs tegra_crtc_helper_funcs = {
+	.dpms = tegra_crtc_dpms,
+	.mode_fixup = tegra_crtc_mode_fixup,
+	.mode_set = tegra_crtc_mode_set,
+	.prepare = tegra_crtc_prepare,
+	.commit = tegra_crtc_commit,
+	.load_lut = tegra_crtc_load_lut,
+};
+
+static irqreturn_t tegra_drm_irq(int irq, void *data)
+{
+	struct tegra_dc *dc = data;
+	unsigned long status;
+
+	status = tegra_dc_readl(dc, DC_CMD_INT_STATUS);
+	tegra_dc_writel(dc, status, DC_CMD_INT_STATUS);
+
+	if (status & FRAME_END_INT) {
+		/*
+		dev_dbg(dc->dev, "%s(): frame end\n", __func__);
+		*/
+	}
+
+	if (status & VBLANK_INT) {
+		/*
+		dev_dbg(dc->dev, "%s(): vertical blank\n", __func__);
+		*/
+		drm_handle_vblank(dc->base.dev, dc->pipe);
+	}
+
+	if (status & (WIN_A_UF_INT | WIN_B_UF_INT | WIN_C_UF_INT)) {
+		/*
+		dev_dbg(dc->dev, "%s(): underflow\n", __func__);
+		*/
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int regs_show(struct seq_file *s, void *ignored)
+{
+	struct tegra_dc *dc = s->private;
+
+#define DUMP_REG(name)						\
+	seq_printf(s, "%-40s %#05x %08lx\n", #name, name,	\
+		   tegra_dc_readl(dc, name))
+
+	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT);
+	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT_CNTRL);
+	DUMP_REG(DC_CMD_GENERAL_INCR_SYNCPT_ERROR);
+	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT);
+	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT_CNTRL);
+	DUMP_REG(DC_CMD_WIN_A_INCR_SYNCPT_ERROR);
+	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT);
+	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT_CNTRL);
+	DUMP_REG(DC_CMD_WIN_B_INCR_SYNCPT_ERROR);
+	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT);
+	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT_CNTRL);
+	DUMP_REG(DC_CMD_WIN_C_INCR_SYNCPT_ERROR);
+	DUMP_REG(DC_CMD_CONT_SYNCPT_VSYNC);
+	DUMP_REG(DC_CMD_DISPLAY_COMMAND_OPTION0);
+	DUMP_REG(DC_CMD_DISPLAY_COMMAND);
+	DUMP_REG(DC_CMD_SIGNAL_RAISE);
+	DUMP_REG(DC_CMD_DISPLAY_POWER_CONTROL);
+	DUMP_REG(DC_CMD_INT_STATUS);
+	DUMP_REG(DC_CMD_INT_MASK);
+	DUMP_REG(DC_CMD_INT_ENABLE);
+	DUMP_REG(DC_CMD_INT_TYPE);
+	DUMP_REG(DC_CMD_INT_POLARITY);
+	DUMP_REG(DC_CMD_SIGNAL_RAISE1);
+	DUMP_REG(DC_CMD_SIGNAL_RAISE2);
+	DUMP_REG(DC_CMD_SIGNAL_RAISE3);
+	DUMP_REG(DC_CMD_STATE_ACCESS);
+	DUMP_REG(DC_CMD_STATE_CONTROL);
+	DUMP_REG(DC_CMD_DISPLAY_WINDOW_HEADER);
+	DUMP_REG(DC_CMD_REG_ACT_CONTROL);
+	DUMP_REG(DC_COM_CRC_CONTROL);
+	DUMP_REG(DC_COM_CRC_CHECKSUM);
+	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(0));
+	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(2));
+	DUMP_REG(DC_COM_PIN_OUTPUT_ENABLE(3));
+	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(0));
+	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(2));
+	DUMP_REG(DC_COM_PIN_OUTPUT_POLARITY(3));
+	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(0));
+	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(2));
+	DUMP_REG(DC_COM_PIN_OUTPUT_DATA(3));
+	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(0));
+	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(1));
+	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(2));
+	DUMP_REG(DC_COM_PIN_INPUT_ENABLE(3));
+	DUMP_REG(DC_COM_PIN_INPUT_DATA(0));
+	DUMP_REG(DC_COM_PIN_INPUT_DATA(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(0));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(1));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(2));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(3));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(4));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(5));
+	DUMP_REG(DC_COM_PIN_OUTPUT_SELECT(6));
+	DUMP_REG(DC_COM_PIN_MISC_CONTROL);
+	DUMP_REG(DC_COM_PIN_PM0_CONTROL);
+	DUMP_REG(DC_COM_PIN_PM0_DUTY_CYCLE);
+	DUMP_REG(DC_COM_PIN_PM1_CONTROL);
+	DUMP_REG(DC_COM_PIN_PM1_DUTY_CYCLE);
+	DUMP_REG(DC_COM_SPI_CONTROL);
+	DUMP_REG(DC_COM_SPI_START_BYTE);
+	DUMP_REG(DC_COM_HSPI_WRITE_DATA_AB);
+	DUMP_REG(DC_COM_HSPI_WRITE_DATA_CD);
+	DUMP_REG(DC_COM_HSPI_CS_DC);
+	DUMP_REG(DC_COM_SCRATCH_REGISTER_A);
+	DUMP_REG(DC_COM_SCRATCH_REGISTER_B);
+	DUMP_REG(DC_COM_GPIO_CTRL);
+	DUMP_REG(DC_COM_GPIO_DEBOUNCE_COUNTER);
+	DUMP_REG(DC_COM_CRC_CHECKSUM_LATCHED);
+	DUMP_REG(DC_DISP_DISP_SIGNAL_OPTIONS0);
+	DUMP_REG(DC_DISP_DISP_SIGNAL_OPTIONS1);
+	DUMP_REG(DC_DISP_DISP_WIN_OPTIONS);
+	DUMP_REG(DC_DISP_DISP_MEM_HIGH_PRIORITY);
+	DUMP_REG(DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER);
+	DUMP_REG(DC_DISP_DISP_TIMING_OPTIONS);
+	DUMP_REG(DC_DISP_REF_TO_SYNC);
+	DUMP_REG(DC_DISP_SYNC_WIDTH);
+	DUMP_REG(DC_DISP_BACK_PORCH);
+	DUMP_REG(DC_DISP_ACTIVE);
+	DUMP_REG(DC_DISP_FRONT_PORCH);
+	DUMP_REG(DC_DISP_H_PULSE0_CONTROL);
+	DUMP_REG(DC_DISP_H_PULSE0_POSITION_A);
+	DUMP_REG(DC_DISP_H_PULSE0_POSITION_B);
+	DUMP_REG(DC_DISP_H_PULSE0_POSITION_C);
+	DUMP_REG(DC_DISP_H_PULSE0_POSITION_D);
+	DUMP_REG(DC_DISP_H_PULSE1_CONTROL);
+	DUMP_REG(DC_DISP_H_PULSE1_POSITION_A);
+	DUMP_REG(DC_DISP_H_PULSE1_POSITION_B);
+	DUMP_REG(DC_DISP_H_PULSE1_POSITION_C);
+	DUMP_REG(DC_DISP_H_PULSE1_POSITION_D);
+	DUMP_REG(DC_DISP_H_PULSE2_CONTROL);
+	DUMP_REG(DC_DISP_H_PULSE2_POSITION_A);
+	DUMP_REG(DC_DISP_H_PULSE2_POSITION_B);
+	DUMP_REG(DC_DISP_H_PULSE2_POSITION_C);
+	DUMP_REG(DC_DISP_H_PULSE2_POSITION_D);
+	DUMP_REG(DC_DISP_V_PULSE0_CONTROL);
+	DUMP_REG(DC_DISP_V_PULSE0_POSITION_A);
+	DUMP_REG(DC_DISP_V_PULSE0_POSITION_B);
+	DUMP_REG(DC_DISP_V_PULSE0_POSITION_C);
+	DUMP_REG(DC_DISP_V_PULSE1_CONTROL);
+	DUMP_REG(DC_DISP_V_PULSE1_POSITION_A);
+	DUMP_REG(DC_DISP_V_PULSE1_POSITION_B);
+	DUMP_REG(DC_DISP_V_PULSE1_POSITION_C);
+	DUMP_REG(DC_DISP_V_PULSE2_CONTROL);
+	DUMP_REG(DC_DISP_V_PULSE2_POSITION_A);
+	DUMP_REG(DC_DISP_V_PULSE3_CONTROL);
+	DUMP_REG(DC_DISP_V_PULSE3_POSITION_A);
+	DUMP_REG(DC_DISP_M0_CONTROL);
+	DUMP_REG(DC_DISP_M1_CONTROL);
+	DUMP_REG(DC_DISP_DI_CONTROL);
+	DUMP_REG(DC_DISP_PP_CONTROL);
+	DUMP_REG(DC_DISP_PP_SELECT_A);
+	DUMP_REG(DC_DISP_PP_SELECT_B);
+	DUMP_REG(DC_DISP_PP_SELECT_C);
+	DUMP_REG(DC_DISP_PP_SELECT_D);
+	DUMP_REG(DC_DISP_DISP_CLOCK_CONTROL);
+	DUMP_REG(DC_DISP_DISP_INTERFACE_CONTROL);
+	DUMP_REG(DC_DISP_DISP_COLOR_CONTROL);
+	DUMP_REG(DC_DISP_SHIFT_CLOCK_OPTIONS);
+	DUMP_REG(DC_DISP_DATA_ENABLE_OPTIONS);
+	DUMP_REG(DC_DISP_SERIAL_INTERFACE_OPTIONS);
+	DUMP_REG(DC_DISP_LCD_SPI_OPTIONS);
+	DUMP_REG(DC_DISP_BORDER_COLOR);
+	DUMP_REG(DC_DISP_COLOR_KEY0_LOWER);
+	DUMP_REG(DC_DISP_COLOR_KEY0_UPPER);
+	DUMP_REG(DC_DISP_COLOR_KEY1_LOWER);
+	DUMP_REG(DC_DISP_COLOR_KEY1_UPPER);
+	DUMP_REG(DC_DISP_CURSOR_FOREGROUND);
+	DUMP_REG(DC_DISP_CURSOR_BACKGROUND);
+	DUMP_REG(DC_DISP_CURSOR_START_ADDR);
+	DUMP_REG(DC_DISP_CURSOR_START_ADDR_NS);
+	DUMP_REG(DC_DISP_CURSOR_POSITION);
+	DUMP_REG(DC_DISP_CURSOR_POSITION_NS);
+	DUMP_REG(DC_DISP_INIT_SEQ_CONTROL);
+	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_A);
+	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_B);
+	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_C);
+	DUMP_REG(DC_DISP_SPI_INIT_SEQ_DATA_D);
+	DUMP_REG(DC_DISP_DC_MCCIF_FIFOCTRL);
+	DUMP_REG(DC_DISP_MCCIF_DISPLAY0A_HYST);
+	DUMP_REG(DC_DISP_MCCIF_DISPLAY0B_HYST);
+	DUMP_REG(DC_DISP_MCCIF_DISPLAY1A_HYST);
+	DUMP_REG(DC_DISP_MCCIF_DISPLAY1B_HYST);
+	DUMP_REG(DC_DISP_DAC_CRT_CTRL);
+	DUMP_REG(DC_DISP_DISP_MISC_CONTROL);
+	DUMP_REG(DC_DISP_SD_CONTROL);
+	DUMP_REG(DC_DISP_SD_CSC_COEFF);
+	DUMP_REG(DC_DISP_SD_LUT(0));
+	DUMP_REG(DC_DISP_SD_LUT(1));
+	DUMP_REG(DC_DISP_SD_LUT(2));
+	DUMP_REG(DC_DISP_SD_LUT(3));
+	DUMP_REG(DC_DISP_SD_LUT(4));
+	DUMP_REG(DC_DISP_SD_LUT(5));
+	DUMP_REG(DC_DISP_SD_LUT(6));
+	DUMP_REG(DC_DISP_SD_LUT(7));
+	DUMP_REG(DC_DISP_SD_LUT(8));
+	DUMP_REG(DC_DISP_SD_FLICKER_CONTROL);
+	DUMP_REG(DC_DISP_DC_PIXEL_COUNT);
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(0));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(1));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(2));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(3));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(4));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(5));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(6));
+	DUMP_REG(DC_DISP_SD_HISTOGRAM(7));
+	DUMP_REG(DC_DISP_SD_BL_TF(0));
+	DUMP_REG(DC_DISP_SD_BL_TF(1));
+	DUMP_REG(DC_DISP_SD_BL_TF(2));
+	DUMP_REG(DC_DISP_SD_BL_TF(3));
+	DUMP_REG(DC_DISP_SD_BL_CONTROL);
+	DUMP_REG(DC_DISP_SD_HW_K_VALUES);
+	DUMP_REG(DC_DISP_SD_MAN_K_VALUES);
+	DUMP_REG(DC_WIN_WIN_OPTIONS);
+	DUMP_REG(DC_WIN_BYTE_SWAP);
+	DUMP_REG(DC_WIN_BUFFER_CONTROL);
+	DUMP_REG(DC_WIN_COLOR_DEPTH);
+	DUMP_REG(DC_WIN_POSITION);
+	DUMP_REG(DC_WIN_SIZE);
+	DUMP_REG(DC_WIN_PRESCALED_SIZE);
+	DUMP_REG(DC_WIN_H_INITIAL_DDA);
+	DUMP_REG(DC_WIN_V_INITIAL_DDA);
+	DUMP_REG(DC_WIN_DDA_INC);
+	DUMP_REG(DC_WIN_LINE_STRIDE);
+	DUMP_REG(DC_WIN_BUF_STRIDE);
+	DUMP_REG(DC_WIN_UV_BUF_STRIDE);
+	DUMP_REG(DC_WIN_BUFFER_ADDR_MODE);
+	DUMP_REG(DC_WIN_DV_CONTROL);
+	DUMP_REG(DC_WIN_BLEND_NOKEY);
+	DUMP_REG(DC_WIN_BLEND_1WIN);
+	DUMP_REG(DC_WIN_BLEND_2WIN_X);
+	DUMP_REG(DC_WIN_BLEND_2WIN_Y);
+	DUMP_REG(DC_WIN_BLEND32WIN_XY);
+	DUMP_REG(DC_WIN_HP_FETCH_CONTROL);
+	DUMP_REG(DC_WINBUF_START_ADDR);
+	DUMP_REG(DC_WINBUF_START_ADDR_NS);
+	DUMP_REG(DC_WINBUF_START_ADDR_U);
+	DUMP_REG(DC_WINBUF_START_ADDR_U_NS);
+	DUMP_REG(DC_WINBUF_START_ADDR_V);
+	DUMP_REG(DC_WINBUF_START_ADDR_V_NS);
+	DUMP_REG(DC_WINBUF_ADDR_H_OFFSET);
+	DUMP_REG(DC_WINBUF_ADDR_H_OFFSET_NS);
+	DUMP_REG(DC_WINBUF_ADDR_V_OFFSET);
+	DUMP_REG(DC_WINBUF_ADDR_V_OFFSET_NS);
+	DUMP_REG(DC_WINBUF_UFLOW_STATUS);
+	DUMP_REG(DC_WINBUF_AD_UFLOW_STATUS);
+	DUMP_REG(DC_WINBUF_BD_UFLOW_STATUS);
+	DUMP_REG(DC_WINBUF_CD_UFLOW_STATUS);
+
+#undef DUMP_REG
+
+	return 0;
+}
+
+static int regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, regs_show, inode->i_private);
+}
+
+static const struct file_operations regs_fops = {
+	.open = regs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int tegra_dc_debugfs_init(struct tegra_dc *dc, struct dentry *parent)
+{
+	char *name;
+
+	name = kasprintf(GFP_KERNEL, "dc.%d", dc->pipe);
+	dc->debugfs = debugfs_create_dir(name, parent);
+	kfree(name);
+
+	debugfs_create_file("regs", 0400, dc->debugfs, dc, &regs_fops);
+
+	return 0;
+}
+
+static int tegra_dc_debugfs_exit(struct tegra_dc *dc)
+{
+	debugfs_remove_recursive(dc->debugfs);
+
+	return 0;
+}
+
+static int tegra_dc_drm_init(struct host1x_client *client,
+			     struct drm_device *drm)
+{
+	struct tegra_dc *dc = host1x_client_to_dc(client);
+	int err;
+
+	dc->pipe = drm->mode_config.num_crtc;
+
+	drm_crtc_init(drm, &dc->base, &tegra_crtc_funcs);
+	drm_mode_crtc_set_gamma_size(&dc->base, 256);
+	drm_crtc_helper_add(&dc->base, &tegra_crtc_helper_funcs);
+
+	err = tegra_dc_rgb_init(drm, dc);
+	if (err < 0 && err != -ENODEV) {
+		dev_err(dc->dev, "failed to initialize RGB output: %d\n", err);
+		return err;
+	}
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		struct dentry *parent = drm->primary->debugfs_root;
+
+		err = tegra_dc_debugfs_init(dc, parent);
+		if (err < 0)
+			dev_err(dc->dev, "debugfs setup failed: %d\n", err);
+	}
+
+	err = devm_request_irq(dc->dev, dc->irq, tegra_drm_irq, 0,
+			       dev_name(dc->dev), dc);
+	if (err < 0) {
+		dev_err(dc->dev, "faied to request IRQ#%u: %d\n", dc->irq, err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int tegra_dc_drm_exit(struct host1x_client *client)
+{
+	struct tegra_dc *dc = host1x_client_to_dc(client);
+	int err;
+
+	devm_free_irq(dc->dev, dc->irq, dc);
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_dc_debugfs_exit(dc);
+		if (err < 0)
+			dev_err(dc->dev, "debugfs cleanup failed: %d\n", err);
+	}
+
+	err = tegra_dc_rgb_exit(dc);
+	if (err) {
+		dev_err(dc->dev, "failed to shutdown RGB output: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct host1x_client_ops dc_client_ops = {
+	.drm_init = tegra_dc_drm_init,
+	.drm_exit = tegra_dc_drm_exit,
+};
+
+static int tegra_dc_probe(struct platform_device *pdev)
+{
+	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct resource *regs;
+	struct tegra_dc *dc;
+	int err;
+
+	dc = devm_kzalloc(&pdev->dev, sizeof(*dc), GFP_KERNEL);
+	if (!dc)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dc->list);
+	dc->dev = &pdev->dev;
+
+	dc->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR_OR_NULL(dc->clk)) {
+		dev_err(&pdev->dev, "failed to get clock\n");
+		return -ENXIO;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_err(&pdev->dev, "failed to get registers\n");
+		return -ENXIO;
+	}
+
+	dc->regs = devm_request_and_ioremap(&pdev->dev, regs);
+	if (!dc->regs) {
+		dev_err(&pdev->dev, "failed to remap registers\n");
+		return -ENXIO;
+	}
+
+	dc->irq = platform_get_irq(pdev, 0);
+	if (dc->irq < 0) {
+		dev_err(&pdev->dev, "failed to get IRQ\n");
+		return -ENXIO;
+	}
+
+	INIT_LIST_HEAD(&dc->client.list);
+	dc->client.ops = &dc_client_ops;
+	dc->client.dev = &pdev->dev;
+
+	err = host1x_register_client(host1x, &dc->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	platform_set_drvdata(pdev, dc);
+
+	return 0;
+}
+
+static int tegra_dc_remove(struct platform_device *pdev)
+{
+	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct tegra_dc *dc = platform_get_drvdata(pdev);
+	int err;
+
+	err = host1x_unregister_client(host1x, &dc->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	return 0;
+}
+
+static struct of_device_id tegra_dc_of_match[] = {
+	{ .compatible = "nvidia,tegra20-dc", },
+	{ .compatible = "nvidia,tegra30-dc", },
+	{ },
+};
+
+struct platform_driver tegra_dc_driver = {
+	.driver = {
+		.name = "tegra-dc",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_dc_of_match,
+	},
+	.probe = tegra_dc_probe,
+	.remove = tegra_dc_remove,
+};
diff --git a/drivers/gpu/drm/tegra/dc.h b/drivers/gpu/drm/tegra/dc.h
new file mode 100644
index 0000000..515a74f
--- /dev/null
+++ b/drivers/gpu/drm/tegra/dc.h
@@ -0,0 +1,384 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef TEGRA_DC_H
+#define TEGRA_DC_H 1
+
+#define DC_CMD_GENERAL_INCR_SYNCPT		0x000
+#define DC_CMD_GENERAL_INCR_SYNCPT_CNTRL	0x001
+#define DC_CMD_GENERAL_INCR_SYNCPT_ERROR	0x002
+#define DC_CMD_WIN_A_INCR_SYNCPT		0x008
+#define DC_CMD_WIN_A_INCR_SYNCPT_CNTRL		0x009
+#define DC_CMD_WIN_A_INCR_SYNCPT_ERROR		0x00a
+#define DC_CMD_WIN_B_INCR_SYNCPT		0x010
+#define DC_CMD_WIN_B_INCR_SYNCPT_CNTRL		0x011
+#define DC_CMD_WIN_B_INCR_SYNCPT_ERROR		0x012
+#define DC_CMD_WIN_C_INCR_SYNCPT		0x018
+#define DC_CMD_WIN_C_INCR_SYNCPT_CNTRL		0x019
+#define DC_CMD_WIN_C_INCR_SYNCPT_ERROR		0x01a
+#define DC_CMD_CONT_SYNCPT_VSYNC		0x028
+#define DC_CMD_DISPLAY_COMMAND_OPTION0		0x031
+#define DC_CMD_DISPLAY_COMMAND			0x032
+#define DISP_CTRL_MODE_STOP (0 << 5)
+#define DISP_CTRL_MODE_C_DISPLAY (1 << 5)
+#define DISP_CTRL_MODE_NC_DISPLAY (2 << 5)
+#define DC_CMD_SIGNAL_RAISE			0x033
+#define DC_CMD_DISPLAY_POWER_CONTROL		0x036
+#define PW0_ENABLE (1 <<  0)
+#define PW1_ENABLE (1 <<  2)
+#define PW2_ENABLE (1 <<  4)
+#define PW3_ENABLE (1 <<  6)
+#define PW4_ENABLE (1 <<  8)
+#define PM0_ENABLE (1 << 16)
+#define PM1_ENABLE (1 << 18)
+
+#define DC_CMD_INT_STATUS			0x037
+#define DC_CMD_INT_MASK				0x038
+#define DC_CMD_INT_ENABLE			0x039
+#define DC_CMD_INT_TYPE				0x03a
+#define DC_CMD_INT_POLARITY			0x03b
+#define CTXSW_INT     (1 << 0)
+#define FRAME_END_INT (1 << 1)
+#define VBLANK_INT    (1 << 2)
+#define WIN_A_UF_INT  (1 << 8)
+#define WIN_B_UF_INT  (1 << 9)
+#define WIN_C_UF_INT  (1 << 10)
+#define WIN_A_OF_INT  (1 << 14)
+#define WIN_B_OF_INT  (1 << 15)
+#define WIN_C_OF_INT  (1 << 16)
+
+#define DC_CMD_SIGNAL_RAISE1			0x03c
+#define DC_CMD_SIGNAL_RAISE2			0x03d
+#define DC_CMD_SIGNAL_RAISE3			0x03e
+
+#define DC_CMD_STATE_ACCESS			0x040
+
+#define DC_CMD_STATE_CONTROL			0x041
+#define GENERAL_ACT_REQ (1 <<  0)
+#define WIN_A_ACT_REQ   (1 <<  1)
+#define WIN_B_ACT_REQ   (1 <<  2)
+#define WIN_C_ACT_REQ   (1 <<  3)
+#define GENERAL_UPDATE  (1 <<  8)
+#define WIN_A_UPDATE    (1 <<  9)
+#define WIN_B_UPDATE    (1 << 10)
+#define WIN_C_UPDATE    (1 << 11)
+#define NC_HOST_TRIG    (1 << 24)
+
+#define DC_CMD_DISPLAY_WINDOW_HEADER		0x042
+#define WINDOW_A_SELECT (1 << 4)
+#define WINDOW_B_SELECT (1 << 5)
+#define WINDOW_C_SELECT (1 << 6)
+
+#define DC_CMD_REG_ACT_CONTROL			0x043
+
+#define DC_COM_CRC_CONTROL			0x300
+#define DC_COM_CRC_CHECKSUM			0x301
+#define DC_COM_PIN_OUTPUT_ENABLE(x) (0x302 + (x))
+#define DC_COM_PIN_OUTPUT_POLARITY(x) (0x306 + (x))
+#define LVS_OUTPUT_POLARITY_LOW (1 << 28)
+#define LHS_OUTPUT_POLARITY_LOW (1 << 30)
+#define DC_COM_PIN_OUTPUT_DATA(x) (0x30a + (x))
+#define DC_COM_PIN_INPUT_ENABLE(x) (0x30e + (x))
+#define DC_COM_PIN_INPUT_DATA(x) (0x312 + (x))
+#define DC_COM_PIN_OUTPUT_SELECT(x) (0x314 + (x))
+
+#define DC_COM_PIN_MISC_CONTROL			0x31b
+#define DC_COM_PIN_PM0_CONTROL			0x31c
+#define DC_COM_PIN_PM0_DUTY_CYCLE		0x31d
+#define DC_COM_PIN_PM1_CONTROL			0x31e
+#define DC_COM_PIN_PM1_DUTY_CYCLE		0x31f
+
+#define DC_COM_SPI_CONTROL			0x320
+#define DC_COM_SPI_START_BYTE			0x321
+#define DC_COM_HSPI_WRITE_DATA_AB		0x322
+#define DC_COM_HSPI_WRITE_DATA_CD		0x323
+#define DC_COM_HSPI_CS_DC			0x324
+#define DC_COM_SCRATCH_REGISTER_A		0x325
+#define DC_COM_SCRATCH_REGISTER_B		0x326
+#define DC_COM_GPIO_CTRL			0x327
+#define DC_COM_GPIO_DEBOUNCE_COUNTER		0x328
+#define DC_COM_CRC_CHECKSUM_LATCHED		0x329
+
+#define DC_DISP_DISP_SIGNAL_OPTIONS0		0x400
+#define H_PULSE_0_ENABLE (1 <<  8)
+#define H_PULSE_1_ENABLE (1 << 10)
+#define H_PULSE_2_ENABLE (1 << 12)
+
+#define DC_DISP_DISP_SIGNAL_OPTIONS1		0x401
+
+#define DC_DISP_DISP_WIN_OPTIONS		0x402
+#define HDMI_ENABLE (1 << 30)
+
+#define DC_DISP_DISP_MEM_HIGH_PRIORITY		0x403
+#define CURSOR_THRESHOLD(x)   (((x) & 0x03) << 24)
+#define WINDOW_A_THRESHOLD(x) (((x) & 0x7f) << 16)
+#define WINDOW_B_THRESHOLD(x) (((x) & 0x7f) <<  8)
+#define WINDOW_C_THRESHOLD(x) (((x) & 0xff) <<  0)
+
+#define DC_DISP_DISP_MEM_HIGH_PRIORITY_TIMER	0x404
+#define CURSOR_DELAY(x)   (((x) & 0x3f) << 24)
+#define WINDOW_A_DELAY(x) (((x) & 0x3f) << 16)
+#define WINDOW_B_DELAY(x) (((x) & 0x3f) <<  8)
+#define WINDOW_C_DELAY(x) (((x) & 0x3f) <<  0)
+
+#define DC_DISP_DISP_TIMING_OPTIONS		0x405
+#define VSYNC_H_POSITION(x) ((x) & 0xfff)
+
+#define DC_DISP_REF_TO_SYNC			0x406
+#define DC_DISP_SYNC_WIDTH			0x407
+#define DC_DISP_BACK_PORCH			0x408
+#define DC_DISP_ACTIVE				0x409
+#define DC_DISP_FRONT_PORCH			0x40a
+#define DC_DISP_H_PULSE0_CONTROL		0x40b
+#define DC_DISP_H_PULSE0_POSITION_A		0x40c
+#define DC_DISP_H_PULSE0_POSITION_B		0x40d
+#define DC_DISP_H_PULSE0_POSITION_C		0x40e
+#define DC_DISP_H_PULSE0_POSITION_D		0x40f
+#define DC_DISP_H_PULSE1_CONTROL		0x410
+#define DC_DISP_H_PULSE1_POSITION_A		0x411
+#define DC_DISP_H_PULSE1_POSITION_B		0x412
+#define DC_DISP_H_PULSE1_POSITION_C		0x413
+#define DC_DISP_H_PULSE1_POSITION_D		0x414
+#define DC_DISP_H_PULSE2_CONTROL		0x415
+#define DC_DISP_H_PULSE2_POSITION_A		0x416
+#define DC_DISP_H_PULSE2_POSITION_B		0x417
+#define DC_DISP_H_PULSE2_POSITION_C		0x418
+#define DC_DISP_H_PULSE2_POSITION_D		0x419
+#define DC_DISP_V_PULSE0_CONTROL		0x41a
+#define DC_DISP_V_PULSE0_POSITION_A		0x41b
+#define DC_DISP_V_PULSE0_POSITION_B		0x41c
+#define DC_DISP_V_PULSE0_POSITION_C		0x41d
+#define DC_DISP_V_PULSE1_CONTROL		0x41e
+#define DC_DISP_V_PULSE1_POSITION_A		0x41f
+#define DC_DISP_V_PULSE1_POSITION_B		0x420
+#define DC_DISP_V_PULSE1_POSITION_C		0x421
+#define DC_DISP_V_PULSE2_CONTROL		0x422
+#define DC_DISP_V_PULSE2_POSITION_A		0x423
+#define DC_DISP_V_PULSE3_CONTROL		0x424
+#define DC_DISP_V_PULSE3_POSITION_A		0x425
+#define DC_DISP_M0_CONTROL			0x426
+#define DC_DISP_M1_CONTROL			0x427
+#define DC_DISP_DI_CONTROL			0x428
+#define DC_DISP_PP_CONTROL			0x429
+#define DC_DISP_PP_SELECT_A			0x42a
+#define DC_DISP_PP_SELECT_B			0x42b
+#define DC_DISP_PP_SELECT_C			0x42c
+#define DC_DISP_PP_SELECT_D			0x42d
+
+#define PULSE_MODE_NORMAL    (0 << 3)
+#define PULSE_MODE_ONE_CLOCK (1 << 3)
+#define PULSE_POLARITY_HIGH  (0 << 4)
+#define PULSE_POLARITY_LOW   (1 << 4)
+#define PULSE_QUAL_ALWAYS    (0 << 6)
+#define PULSE_QUAL_VACTIVE   (2 << 6)
+#define PULSE_QUAL_VACTIVE1  (3 << 6)
+#define PULSE_LAST_START_A   (0 << 8)
+#define PULSE_LAST_END_A     (1 << 8)
+#define PULSE_LAST_START_B   (2 << 8)
+#define PULSE_LAST_END_B     (3 << 8)
+#define PULSE_LAST_START_C   (4 << 8)
+#define PULSE_LAST_END_C     (5 << 8)
+#define PULSE_LAST_START_D   (6 << 8)
+#define PULSE_LAST_END_D     (7 << 8)
+
+#define PULSE_START(x) (((x) & 0xfff) <<  0)
+#define PULSE_END(x)   (((x) & 0xfff) << 16)
+
+#define DC_DISP_DISP_CLOCK_CONTROL		0x42e
+#define PIXEL_CLK_DIVIDER_PCD1  (0 << 8)
+#define PIXEL_CLK_DIVIDER_PCD1H (1 << 8)
+#define PIXEL_CLK_DIVIDER_PCD2  (2 << 8)
+#define PIXEL_CLK_DIVIDER_PCD3  (3 << 8)
+#define PIXEL_CLK_DIVIDER_PCD4  (4 << 8)
+#define PIXEL_CLK_DIVIDER_PCD6  (5 << 8)
+#define PIXEL_CLK_DIVIDER_PCD8  (6 << 8)
+#define PIXEL_CLK_DIVIDER_PCD9  (7 << 8)
+#define PIXEL_CLK_DIVIDER_PCD12 (8 << 8)
+#define PIXEL_CLK_DIVIDER_PCD16 (9 << 8)
+#define PIXEL_CLK_DIVIDER_PCD18 (10 << 8)
+#define PIXEL_CLK_DIVIDER_PCD24 (11 << 8)
+#define PIXEL_CLK_DIVIDER_PCD13 (12 << 8)
+#define SHIFT_CLK_DIVIDER(x)    ((x) & 0xff)
+
+#define DC_DISP_DISP_INTERFACE_CONTROL		0x42f
+#define DISP_DATA_FORMAT_DF1P1C    (0 << 0)
+#define DISP_DATA_FORMAT_DF1P2C24B (1 << 0)
+#define DISP_DATA_FORMAT_DF1P2C18B (2 << 0)
+#define DISP_DATA_FORMAT_DF1P2C16B (3 << 0)
+#define DISP_DATA_FORMAT_DF2S      (4 << 0)
+#define DISP_DATA_FORMAT_DF3S      (5 << 0)
+#define DISP_DATA_FORMAT_DFSPI     (6 << 0)
+#define DISP_DATA_FORMAT_DF1P3C24B (7 << 0)
+#define DISP_DATA_FORMAT_DF1P3C18B (8 << 0)
+#define DISP_ALIGNMENT_MSB         (0 << 8)
+#define DISP_ALIGNMENT_LSB         (1 << 8)
+#define DISP_ORDER_RED_BLUE        (0 << 9)
+#define DISP_ORDER_BLUE_RED        (1 << 9)
+
+#define DC_DISP_DISP_COLOR_CONTROL		0x430
+#define BASE_COLOR_SIZE666     (0 << 0)
+#define BASE_COLOR_SIZE111     (1 << 0)
+#define BASE_COLOR_SIZE222     (2 << 0)
+#define BASE_COLOR_SIZE333     (3 << 0)
+#define BASE_COLOR_SIZE444     (4 << 0)
+#define BASE_COLOR_SIZE555     (5 << 0)
+#define BASE_COLOR_SIZE565     (6 << 0)
+#define BASE_COLOR_SIZE332     (7 << 0)
+#define BASE_COLOR_SIZE888     (8 << 0)
+#define DITHER_CONTROL_DISABLE (0 << 8)
+#define DITHER_CONTROL_ORDERED (2 << 8)
+#define DITHER_CONTROL_ERRDIFF (3 << 8)
+
+#define DC_DISP_SHIFT_CLOCK_OPTIONS		0x431
+
+#define DC_DISP_DATA_ENABLE_OPTIONS		0x432
+#define DE_SELECT_ACTIVE_BLANK  (0 << 0)
+#define DE_SELECT_ACTIVE        (1 << 0)
+#define DE_SELECT_ACTIVE_IS     (2 << 0)
+#define DE_CONTROL_ONECLK       (0 << 2)
+#define DE_CONTROL_NORMAL       (1 << 2)
+#define DE_CONTROL_EARLY_EXT    (2 << 2)
+#define DE_CONTROL_EARLY        (3 << 2)
+#define DE_CONTROL_ACTIVE_BLANK (4 << 2)
+
+#define DC_DISP_SERIAL_INTERFACE_OPTIONS	0x433
+#define DC_DISP_LCD_SPI_OPTIONS			0x434
+#define DC_DISP_BORDER_COLOR			0x435
+#define DC_DISP_COLOR_KEY0_LOWER		0x436
+#define DC_DISP_COLOR_KEY0_UPPER		0x437
+#define DC_DISP_COLOR_KEY1_LOWER		0x438
+#define DC_DISP_COLOR_KEY1_UPPER		0x439
+
+#define DC_DISP_CURSOR_FOREGROUND		0x43c
+#define DC_DISP_CURSOR_BACKGROUND		0x43d
+
+#define DC_DISP_CURSOR_START_ADDR		0x43e
+#define DC_DISP_CURSOR_START_ADDR_NS		0x43f
+
+#define DC_DISP_CURSOR_POSITION			0x440
+#define DC_DISP_CURSOR_POSITION_NS		0x441
+
+#define DC_DISP_INIT_SEQ_CONTROL		0x442
+#define DC_DISP_SPI_INIT_SEQ_DATA_A		0x443
+#define DC_DISP_SPI_INIT_SEQ_DATA_B		0x444
+#define DC_DISP_SPI_INIT_SEQ_DATA_C		0x445
+#define DC_DISP_SPI_INIT_SEQ_DATA_D		0x446
+
+#define DC_DISP_DC_MCCIF_FIFOCTRL		0x480
+#define DC_DISP_MCCIF_DISPLAY0A_HYST		0x481
+#define DC_DISP_MCCIF_DISPLAY0B_HYST		0x482
+#define DC_DISP_MCCIF_DISPLAY1A_HYST		0x483
+#define DC_DISP_MCCIF_DISPLAY1B_HYST		0x484
+
+#define DC_DISP_DAC_CRT_CTRL			0x4c0
+#define DC_DISP_DISP_MISC_CONTROL		0x4c1
+#define DC_DISP_SD_CONTROL			0x4c2
+#define DC_DISP_SD_CSC_COEFF			0x4c3
+#define DC_DISP_SD_LUT(x)			(0x4c4 + (x))
+#define DC_DISP_SD_FLICKER_CONTROL		0x4cd
+#define DC_DISP_DC_PIXEL_COUNT			0x4ce
+#define DC_DISP_SD_HISTOGRAM(x)			(0x4cf + (x))
+#define DC_DISP_SD_BL_PARAMETERS		0x4d7
+#define DC_DISP_SD_BL_TF(x)			(0x4d8 + (x))
+#define DC_DISP_SD_BL_CONTROL			0x4dc
+#define DC_DISP_SD_HW_K_VALUES			0x4dd
+#define DC_DISP_SD_MAN_K_VALUES			0x4de
+
+#define DC_WIN_WIN_OPTIONS			0x700
+#define COLOR_EXPAND (1 <<  6)
+#define WIN_ENABLE   (1 << 30)
+
+#define DC_WIN_BYTE_SWAP			0x701
+#define BYTE_SWAP_NOSWAP  (0 << 0)
+#define BYTE_SWAP_SWAP2   (1 << 0)
+#define BYTE_SWAP_SWAP4   (2 << 0)
+#define BYTE_SWAP_SWAP4HW (3 << 0)
+
+#define DC_WIN_BUFFER_CONTROL			0x702
+#define BUFFER_CONTROL_HOST  (0 << 0)
+#define BUFFER_CONTROL_VI    (1 << 0)
+#define BUFFER_CONTROL_EPP   (2 << 0)
+#define BUFFER_CONTROL_MPEGE (3 << 0)
+#define BUFFER_CONTROL_SB2D  (4 << 0)
+
+#define DC_WIN_COLOR_DEPTH			0x703
+#define WIN_COLOR_DEPTH_P1              0
+#define WIN_COLOR_DEPTH_P2              1
+#define WIN_COLOR_DEPTH_P4              2
+#define WIN_COLOR_DEPTH_P8              3
+#define WIN_COLOR_DEPTH_B4G4R4A4        4
+#define WIN_COLOR_DEPTH_B5G5R5A         5
+#define WIN_COLOR_DEPTH_B5G6R5          6
+#define WIN_COLOR_DEPTH_AB5G5R5         7
+#define WIN_COLOR_DEPTH_B8G8R8A8       12
+#define WIN_COLOR_DEPTH_R8G8B8A8       13
+#define WIN_COLOR_DEPTH_B6x2G6x2R6x2A8 14
+#define WIN_COLOR_DEPTH_R6x2G6x2B6x2A8 15
+#define WIN_COLOR_DEPTH_YCbCr422       16
+#define WIN_COLOR_DEPTH_YUV422         17
+#define WIN_COLOR_DEPTH_YCbCr420P      18
+#define WIN_COLOR_DEPTH_YUV420P        19
+#define WIN_COLOR_DEPTH_YCbCr422P      20
+#define WIN_COLOR_DEPTH_YUV422P        21
+#define WIN_COLOR_DEPTH_YCbCr422R      22
+#define WIN_COLOR_DEPTH_YUV422R        23
+#define WIN_COLOR_DEPTH_YCbCr422RA     24
+#define WIN_COLOR_DEPTH_YUV422RA       25
+
+#define DC_WIN_POSITION				0x704
+#define H_POSITION(x) (((x) & 0x1fff) <<  0)
+#define V_POSITION(x) (((x) & 0x1fff) << 16)
+
+#define DC_WIN_SIZE				0x705
+#define H_SIZE(x) (((x) & 0x1fff) <<  0)
+#define V_SIZE(x) (((x) & 0x1fff) << 16)
+
+#define DC_WIN_PRESCALED_SIZE			0x706
+#define H_PRESCALED_SIZE(x) (((x) & 0x7fff) <<  0)
+#define V_PRESCALED_SIZE(x) (((x) & 0x1fff) << 16)
+
+#define DC_WIN_H_INITIAL_DDA			0x707
+#define DC_WIN_V_INITIAL_DDA			0x708
+#define DC_WIN_DDA_INC				0x709
+#define H_DDA_INC(x) (((x) & 0xffff) <<  0)
+#define V_DDA_INC(x) (((x) & 0xffff) << 16)
+
+#define DC_WIN_LINE_STRIDE			0x70a
+#define DC_WIN_BUF_STRIDE			0x70b
+#define DC_WIN_UV_BUF_STRIDE			0x70c
+#define DC_WIN_BUFFER_ADDR_MODE			0x70d
+#define DC_WIN_DV_CONTROL			0x70e
+
+#define DC_WIN_BLEND_NOKEY			0x70f
+#define DC_WIN_BLEND_1WIN			0x710
+#define DC_WIN_BLEND_2WIN_X			0x711
+#define DC_WIN_BLEND_2WIN_Y			0x712
+#define DC_WIN_BLEND32WIN_XY			0x713
+
+#define DC_WIN_HP_FETCH_CONTROL			0x714
+
+#define DC_WINBUF_START_ADDR			0x800
+#define DC_WINBUF_START_ADDR_NS			0x801
+#define DC_WINBUF_START_ADDR_U			0x802
+#define DC_WINBUF_START_ADDR_U_NS		0x803
+#define DC_WINBUF_START_ADDR_V			0x804
+#define DC_WINBUF_START_ADDR_V_NS		0x805
+
+#define DC_WINBUF_ADDR_H_OFFSET			0x806
+#define DC_WINBUF_ADDR_H_OFFSET_NS		0x807
+#define DC_WINBUF_ADDR_V_OFFSET			0x808
+#define DC_WINBUF_ADDR_V_OFFSET_NS		0x809
+
+#define DC_WINBUF_UFLOW_STATUS			0x80a
+
+#define DC_WINBUF_AD_UFLOW_STATUS		0xbca
+#define DC_WINBUF_BD_UFLOW_STATUS		0xdca
+#define DC_WINBUF_CD_UFLOW_STATUS		0xfca
+
+#endif /* TEGRA_DC_H */
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
new file mode 100644
index 0000000..fdcff7d
--- /dev/null
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+
+#include <mach/clk.h>
+#include <linux/dma-mapping.h>
+#include <asm/dma-iommu.h>
+
+#include "drm.h"
+
+#define DRIVER_NAME "tegra"
+#define DRIVER_DESC "NVIDIA Tegra graphics"
+#define DRIVER_DATE "20120330"
+#define DRIVER_MAJOR 0
+#define DRIVER_MINOR 0
+#define DRIVER_PATCHLEVEL 0
+
+static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
+{
+	struct device *dev = drm->dev;
+	struct host1x *host1x;
+	int err;
+
+	host1x = dev_get_drvdata(dev);
+	drm->dev_private = host1x;
+	host1x->drm = drm;
+
+	drm_mode_config_init(drm);
+
+	err = host1x_drm_init(host1x, drm);
+	if (err < 0)
+		return err;
+
+	err = tegra_drm_fb_init(drm);
+	if (err < 0)
+		return err;
+
+	drm_kms_helper_poll_init(drm);
+
+	return 0;
+}
+
+static int tegra_drm_unload(struct drm_device *drm)
+{
+	drm_kms_helper_poll_fini(drm);
+	tegra_drm_fb_exit(drm);
+
+	drm_mode_config_cleanup(drm);
+
+	return 0;
+}
+
+static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
+{
+	return 0;
+}
+
+static void tegra_drm_lastclose(struct drm_device *drm)
+{
+	struct host1x *host1x = drm->dev_private;
+
+	drm_fbdev_cma_restore_mode(host1x->fbdev);
+}
+
+static struct drm_ioctl_desc tegra_drm_ioctls[] = {
+};
+
+static const struct file_operations tegra_drm_fops = {
+	.owner = THIS_MODULE,
+	.open = drm_open,
+	.release = drm_release,
+	.unlocked_ioctl = drm_ioctl,
+	.mmap = drm_gem_cma_mmap,
+	.poll = drm_poll,
+	.fasync = drm_fasync,
+	.read = drm_read,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = tegra_compat_ioctl,
+#endif
+	.llseek = noop_llseek,
+};
+
+struct drm_driver tegra_drm_driver = {
+	.driver_features = DRIVER_BUS_PLATFORM | DRIVER_MODESET | DRIVER_GEM,
+	.load = tegra_drm_load,
+	.unload = tegra_drm_unload,
+	.open = tegra_drm_open,
+	.lastclose = tegra_drm_lastclose,
+
+	.gem_free_object = drm_gem_cma_free_object,
+	.gem_vm_ops = &drm_gem_cma_vm_ops,
+	.dumb_create = drm_gem_cma_dumb_create,
+	.dumb_map_offset = drm_gem_cma_dumb_map_offset,
+	.dumb_destroy = drm_gem_cma_dumb_destroy,
+
+	.ioctls = tegra_drm_ioctls,
+	.num_ioctls = ARRAY_SIZE(tegra_drm_ioctls),
+	.fops = &tegra_drm_fops,
+
+	.name = DRIVER_NAME,
+	.desc = DRIVER_DESC,
+	.date = DRIVER_DATE,
+	.major = DRIVER_MAJOR,
+	.minor = DRIVER_MINOR,
+	.patchlevel = DRIVER_PATCHLEVEL,
+};
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
new file mode 100644
index 0000000..7334b68
--- /dev/null
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -0,0 +1,233 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef TEGRA_DRM_H
+#define TEGRA_DRM_H 1
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_fb_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_fixed.h>
+
+/* synchronization points */
+#define SYNCPT_VBLANK0 26
+#define SYNCPT_VBLANK1 27
+
+struct tegra_framebuffer {
+	struct drm_framebuffer base;
+	struct drm_gem_cma_object *obj;
+};
+
+static inline struct tegra_framebuffer *to_tegra_fb(struct drm_framebuffer *fb)
+{
+	return container_of(fb, struct tegra_framebuffer, base);
+}
+
+struct host1x {
+	struct drm_device *drm;
+	struct device *dev;
+	void __iomem *regs;
+	struct clk *clk;
+	int syncpt;
+	int irq;
+
+	struct mutex drm_clients_lock;
+	struct list_head drm_clients;
+	struct list_head drm_active;
+
+	struct mutex clients_lock;
+	struct list_head clients;
+
+	struct drm_fbdev_cma *fbdev;
+	struct tegra_framebuffer fb;
+};
+
+struct host1x_client;
+
+struct host1x_client_ops {
+	int (*drm_init)(struct host1x_client *client, struct drm_device *drm);
+	int (*drm_exit)(struct host1x_client *client);
+};
+
+struct host1x_client {
+	struct host1x *host1x;
+	struct device *dev;
+
+	const struct host1x_client_ops *ops;
+
+	struct list_head list;
+};
+
+extern int host1x_drm_init(struct host1x *host1x, struct drm_device *drm);
+extern int host1x_drm_exit(struct host1x *host1x);
+
+extern int host1x_register_client(struct host1x *host1x,
+				  struct host1x_client *client);
+extern int host1x_unregister_client(struct host1x *host1x,
+				    struct host1x_client *client);
+
+struct tegra_output;
+
+struct tegra_dc {
+	struct host1x_client client;
+
+	struct host1x *host1x;
+	struct device *dev;
+
+	struct drm_crtc base;
+	int pipe;
+
+	struct clk *clk;
+	bool enabled;
+
+	void __iomem *regs;
+	int irq;
+
+	struct tegra_output *rgb;
+
+	struct list_head list;
+
+	struct dentry *debugfs;
+};
+
+static inline struct tegra_dc *host1x_client_to_dc(struct host1x_client *client)
+{
+	return container_of(client, struct tegra_dc, client);
+}
+
+static inline struct tegra_dc *to_tegra_dc(struct drm_crtc *crtc)
+{
+	return container_of(crtc, struct tegra_dc, base);
+}
+
+static inline void tegra_dc_writel(struct tegra_dc *dc, unsigned long value,
+				   unsigned long reg)
+{
+	writel(value, dc->regs + (reg << 2));
+}
+
+static inline unsigned long tegra_dc_readl(struct tegra_dc *dc,
+					   unsigned long reg)
+{
+	return readl(dc->regs + (reg << 2));
+}
+
+struct tegra_output_ops {
+	int (*enable)(struct tegra_output *output);
+	int (*disable)(struct tegra_output *output);
+	int (*setup_clock)(struct tegra_output *output, struct clk *clk,
+			   unsigned long pclk);
+	int (*check_mode)(struct tegra_output *output,
+			  struct drm_display_mode *mode,
+			  enum drm_mode_status *status);
+};
+
+enum tegra_output_type {
+	TEGRA_OUTPUT_RGB,
+};
+
+struct tegra_output {
+	struct device_node *of_node;
+	struct device *dev;
+
+	const struct tegra_output_ops *ops;
+	enum tegra_output_type type;
+
+	struct i2c_adapter *ddc;
+	const struct edid *edid;
+	unsigned int hpd_irq;
+	int hpd_gpio;
+
+	struct drm_encoder encoder;
+	struct drm_connector connector;
+};
+
+static inline struct tegra_output *encoder_to_output(struct drm_encoder *e)
+{
+	return container_of(e, struct tegra_output, encoder);
+}
+
+static inline struct tegra_output *connector_to_output(struct drm_connector *c)
+{
+	return container_of(c, struct tegra_output, connector);
+}
+
+static inline int tegra_output_enable(struct tegra_output *output)
+{
+	if (output && output->ops && output->ops->enable)
+		return output->ops->enable(output);
+
+	return output ? -ENOSYS : -EINVAL;
+}
+
+static inline int tegra_output_disable(struct tegra_output *output)
+{
+	if (output && output->ops && output->ops->disable)
+		return output->ops->disable(output);
+
+	return output ? -ENOSYS : -EINVAL;
+}
+
+static inline int tegra_output_setup_clock(struct tegra_output *output,
+					   struct clk *clk, unsigned long pclk)
+{
+	if (output && output->ops && output->ops->setup_clock)
+		return output->ops->setup_clock(output, clk, pclk);
+
+	return output ? -ENOSYS : -EINVAL;
+}
+
+static inline int tegra_output_check_mode(struct tegra_output *output,
+					  struct drm_display_mode *mode,
+					  enum drm_mode_status *status)
+{
+	if (output && output->ops && output->ops->check_mode)
+		return output->ops->check_mode(output, mode, status);
+
+	return output ? -ENOSYS : -EINVAL;
+}
+
+/* from rgb.c */
+extern int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc);
+extern int tegra_dc_rgb_exit(struct tegra_dc *dc);
+
+/* from output.c */
+extern int tegra_output_init(struct drm_device *drm, struct tegra_output *output);
+extern int tegra_output_exit(struct tegra_output *output);
+
+/* from gem.c */
+extern struct tegra_gem_object *tegra_gem_alloc(struct drm_device *drm,
+						size_t size);
+extern int tegra_gem_handle_create(struct drm_device *drm,
+				   struct drm_file *file, size_t size,
+				   unsigned long flags, uint32_t *handle);
+extern int tegra_gem_dumb_create(struct drm_file *file, struct drm_device *drm,
+				 struct drm_mode_create_dumb *args);
+extern int tegra_gem_dumb_map_offset(struct drm_file *file,
+				     struct drm_device *drm, uint32_t handle,
+				     uint64_t *offset);
+extern int tegra_gem_dumb_destroy(struct drm_file *file,
+				  struct drm_device *drm, uint32_t handle);
+extern int tegra_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
+extern int tegra_gem_init_object(struct drm_gem_object *obj);
+extern void tegra_gem_free_object(struct drm_gem_object *obj);
+extern struct vm_operations_struct tegra_gem_vm_ops;
+
+/* from fb.c */
+extern int tegra_drm_fb_init(struct drm_device *drm);
+extern void tegra_drm_fb_exit(struct drm_device *drm);
+
+extern struct platform_driver tegra_host1x_driver;
+extern struct platform_driver tegra_dc_driver;
+extern struct drm_driver tegra_drm_driver;
+
+#endif /* TEGRA_DRM_H */
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
new file mode 100644
index 0000000..97993c6
--- /dev/null
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "drm.h"
+
+static void tegra_drm_fb_output_poll_changed(struct drm_device *drm)
+{
+	struct host1x *host1x = drm->dev_private;
+
+	drm_fbdev_cma_hotplug_event(host1x->fbdev);
+}
+
+static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
+	.fb_create = drm_fb_cma_create,
+	.output_poll_changed = tegra_drm_fb_output_poll_changed,
+};
+
+int tegra_drm_fb_init(struct drm_device *drm)
+{
+	struct host1x *host1x = drm->dev_private;
+	struct drm_fbdev_cma *fbdev;
+
+	drm->mode_config.min_width = 0;
+	drm->mode_config.min_height = 0;
+
+	drm->mode_config.max_width = 4096;
+	drm->mode_config.max_height = 4096;
+
+	drm->mode_config.funcs = &tegra_drm_mode_funcs;
+
+	fbdev = drm_fbdev_cma_init(drm, 32, drm->mode_config.num_crtc,
+				   drm->mode_config.num_connector);
+	if (IS_ERR(fbdev))
+		return PTR_ERR(fbdev);
+
+#ifndef CONFIG_FRAMEBUFFER_CONSOLE
+	drm_fbdev_cma_restore_mode(fbdev);
+#endif
+
+	host1x->fbdev = fbdev;
+
+	return 0;
+}
+
+void tegra_drm_fb_exit(struct drm_device *drm)
+{
+	struct host1x *host1x = drm->dev_private;
+
+	drm_fbdev_cma_fini(host1x->fbdev);
+}
diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
new file mode 100644
index 0000000..ed2af1a
--- /dev/null
+++ b/drivers/gpu/drm/tegra/host1x.c
@@ -0,0 +1,313 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "drm.h"
+
+struct host1x_drm_client {
+	struct host1x_client *client;
+	struct device_node *np;
+	struct list_head list;
+};
+
+static int host1x_add_drm_client(struct host1x *host1x, struct device_node *np)
+{
+	struct host1x_drm_client *client;
+
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&client->list);
+	client->np = of_node_get(np);
+
+	list_add_tail(&client->list, &host1x->drm_clients);
+
+	return 0;
+}
+
+static int host1x_activate_drm_client(struct host1x *host1x,
+				      struct host1x_drm_client *drm,
+				      struct host1x_client *client)
+{
+	mutex_lock(&host1x->drm_clients_lock);
+	list_del_init(&drm->list);
+	list_add_tail(&drm->list, &host1x->drm_active);
+	drm->client = client;
+	mutex_unlock(&host1x->drm_clients_lock);
+
+	return 0;
+}
+
+static int host1x_remove_drm_client(struct host1x *host1x,
+				    struct host1x_drm_client *client)
+{
+	mutex_lock(&host1x->drm_clients_lock);
+	list_del_init(&client->list);
+	mutex_unlock(&host1x->drm_clients_lock);
+
+	of_node_put(client->np);
+	kfree(client);
+
+	return 0;
+}
+
+static int host1x_parse_dt(struct host1x *host1x)
+{
+	static const char * const compat[] = {
+		"nvidia,tegra20-dc",
+	};
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < ARRAY_SIZE(compat); i++) {
+		struct device_node *np;
+
+		for_each_child_of_node(host1x->dev->of_node, np) {
+			if (of_device_is_compatible(np, compat[i]) &&
+			    of_device_is_available(np)) {
+				err = host1x_add_drm_client(host1x, np);
+				if (err < 0)
+					return err;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int tegra_host1x_probe(struct platform_device *pdev)
+{
+	struct host1x *host1x;
+	struct resource *regs;
+	int err;
+
+	host1x = devm_kzalloc(&pdev->dev, sizeof(*host1x), GFP_KERNEL);
+	if (!host1x)
+		return -ENOMEM;
+
+	mutex_init(&host1x->drm_clients_lock);
+	INIT_LIST_HEAD(&host1x->drm_clients);
+	INIT_LIST_HEAD(&host1x->drm_active);
+	mutex_init(&host1x->clients_lock);
+	INIT_LIST_HEAD(&host1x->clients);
+	host1x->dev = &pdev->dev;
+
+	err = host1x_parse_dt(host1x);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to parse DT: %d\n", err);
+		return err;
+	}
+
+	host1x->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR_OR_NULL(host1x->clk))
+		return PTR_ERR(host1x->clk);
+
+	err = clk_prepare_enable(host1x->clk);
+	if (err < 0)
+		return err;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		err = -ENXIO;
+		goto err;
+	}
+
+	err = platform_get_irq(pdev, 0);
+	if (err < 0)
+		goto err;
+
+	host1x->syncpt = err;
+
+	err = platform_get_irq(pdev, 1);
+	if (err < 0)
+		goto err;
+
+	host1x->irq = err;
+
+	host1x->regs = devm_request_and_ioremap(&pdev->dev, regs);
+	if (!host1x->regs) {
+		err = -EADDRNOTAVAIL;
+		goto err;
+	}
+
+	platform_set_drvdata(pdev, host1x);
+
+	return 0;
+
+err:
+	clk_disable_unprepare(host1x->clk);
+	return err;
+}
+
+static int tegra_host1x_remove(struct platform_device *pdev)
+{
+	struct host1x *host1x = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(host1x->clk);
+
+	return 0;
+}
+
+int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
+{
+	struct host1x_client *client;
+
+	mutex_lock(&host1x->clients_lock);
+
+	list_for_each_entry(client, &host1x->clients, list) {
+		if (client->ops && client->ops->drm_init) {
+			int err = client->ops->drm_init(client, drm);
+			if (err < 0) {
+				dev_err(host1x->dev,
+					"DRM setup failed for %s: %d\n",
+					dev_name(client->dev), err);
+				return err;
+			}
+		}
+	}
+
+	mutex_unlock(&host1x->clients_lock);
+
+	return 0;
+}
+
+int host1x_drm_exit(struct host1x *host1x)
+{
+	struct platform_device *pdev = to_platform_device(host1x->dev);
+	struct host1x_client *client;
+
+	if (!host1x->drm)
+		return 0;
+
+	mutex_lock(&host1x->clients_lock);
+
+	list_for_each_entry_reverse(client, &host1x->clients, list) {
+		if (client->ops && client->ops->drm_exit) {
+			int err = client->ops->drm_exit(client);
+			if (err < 0) {
+				dev_err(host1x->dev,
+					"DRM cleanup failed for %s: %d\n",
+					dev_name(client->dev), err);
+				return err;
+			}
+		}
+	}
+
+	mutex_unlock(&host1x->clients_lock);
+
+	drm_platform_exit(&tegra_drm_driver, pdev);
+	host1x->drm = NULL;
+
+	return 0;
+}
+
+int host1x_register_client(struct host1x *host1x, struct host1x_client *client)
+{
+	struct host1x_drm_client *drm, *tmp;
+	int err;
+
+	mutex_lock(&host1x->clients_lock);
+	list_add_tail(&client->list, &host1x->clients);
+	mutex_unlock(&host1x->clients_lock);
+
+	list_for_each_entry_safe(drm, tmp, &host1x->drm_clients, list)
+		if (drm->np == client->dev->of_node)
+			host1x_activate_drm_client(host1x, drm, client);
+
+	if (list_empty(&host1x->drm_clients)) {
+		struct platform_device *pdev = to_platform_device(host1x->dev);
+
+		err = drm_platform_init(&tegra_drm_driver, pdev);
+		if (err < 0) {
+			dev_err(host1x->dev, "drm_platform_init(): %d\n", err);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+int host1x_unregister_client(struct host1x *host1x,
+			     struct host1x_client *client)
+{
+	struct host1x_drm_client *drm, *tmp;
+	int err;
+
+	list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
+		if (drm->client == client) {
+			err = host1x_drm_exit(host1x);
+			if (err < 0) {
+				dev_err(host1x->dev, "host1x_drm_exit(): %d\n",
+					err);
+				return err;
+			}
+
+			host1x_remove_drm_client(host1x, drm);
+			break;
+		}
+	}
+
+	mutex_lock(&host1x->clients_lock);
+	list_del_init(&client->list);
+	mutex_unlock(&host1x->clients_lock);
+
+	return 0;
+}
+
+static struct of_device_id tegra_host1x_of_match[] = {
+	{ .compatible = "nvidia,tegra20-host1x", },
+	{ },
+};
+
+struct platform_driver tegra_host1x_driver = {
+	.driver = {
+		.name = "tegra-host1x",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_host1x_of_match,
+	},
+	.probe = tegra_host1x_probe,
+	.remove = tegra_host1x_remove,
+};
+
+static int __init tegra_host1x_init(void)
+{
+	int err;
+
+	err = platform_driver_register(&tegra_host1x_driver);
+	if (err < 0)
+		return err;
+
+	err = platform_driver_register(&tegra_dc_driver);
+	if (err < 0)
+		goto unregister_host1x;
+
+	return 0;
+
+unregister_host1x:
+	platform_driver_unregister(&tegra_host1x_driver);
+	return err;
+}
+module_init(tegra_host1x_init);
+
+static void __exit tegra_host1x_exit(void)
+{
+	platform_driver_unregister(&tegra_dc_driver);
+	platform_driver_unregister(&tegra_host1x_driver);
+}
+module_exit(tegra_host1x_exit);
+
+MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
+MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
new file mode 100644
index 0000000..f6a3bc4
--- /dev/null
+++ b/drivers/gpu/drm/tegra/output.c
@@ -0,0 +1,275 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/of_i2c.h>
+
+#include "drm.h"
+
+static int tegra_connector_get_modes(struct drm_connector *connector)
+{
+	struct tegra_output *output = connector_to_output(connector);
+	struct edid *edid = NULL;
+	int err = 0;
+
+	if (output->edid)
+		edid = kmemdup(output->edid, sizeof(*edid), GFP_KERNEL);
+	else if (output->ddc)
+		edid = drm_get_edid(connector, output->ddc);
+
+	drm_mode_connector_update_edid_property(connector, edid);
+
+	if (edid) {
+		err = drm_add_edid_modes(connector, edid);
+		kfree(edid);
+	}
+
+	return err;
+}
+
+static int tegra_connector_mode_valid(struct drm_connector *connector,
+				      struct drm_display_mode *mode)
+{
+	struct tegra_output *output = connector_to_output(connector);
+	enum drm_mode_status status = MODE_OK;
+	int err;
+
+	err = tegra_output_check_mode(output, mode, &status);
+	if (err < 0)
+		return MODE_ERROR;
+
+	return status;
+}
+
+static struct drm_encoder *
+tegra_connector_best_encoder(struct drm_connector *connector)
+{
+	struct tegra_output *output = connector_to_output(connector);
+
+	return &output->encoder;
+}
+
+static const struct drm_connector_helper_funcs connector_helper_funcs = {
+	.get_modes = tegra_connector_get_modes,
+	.mode_valid = tegra_connector_mode_valid,
+	.best_encoder = tegra_connector_best_encoder,
+};
+
+static enum drm_connector_status
+tegra_connector_detect(struct drm_connector *connector, bool force)
+{
+	struct tegra_output *output = connector_to_output(connector);
+	enum drm_connector_status status = connector_status_unknown;
+
+	if (gpio_is_valid(output->hpd_gpio)) {
+		if (gpio_get_value(output->hpd_gpio) == 0)
+			status = connector_status_disconnected;
+		else
+			status = connector_status_connected;
+	} else {
+		if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
+			status = connector_status_connected;
+	}
+
+	return status;
+}
+
+static void tegra_connector_destroy(struct drm_connector *connector)
+{
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+}
+
+static const struct drm_connector_funcs connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = tegra_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = tegra_connector_destroy,
+};
+
+static void tegra_encoder_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static const struct drm_encoder_funcs encoder_funcs = {
+	.destroy = tegra_encoder_destroy,
+};
+
+static void tegra_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+}
+
+static bool tegra_encoder_mode_fixup(struct drm_encoder *encoder,
+				     const struct drm_display_mode *mode,
+				     struct drm_display_mode *adjusted)
+{
+	return true;
+}
+
+static void tegra_encoder_prepare(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_encoder_commit(struct drm_encoder *encoder)
+{
+}
+
+static void tegra_encoder_mode_set(struct drm_encoder *encoder,
+				   struct drm_display_mode *mode,
+				   struct drm_display_mode *adjusted)
+{
+	struct tegra_output *output = encoder_to_output(encoder);
+	int err;
+
+	err = tegra_output_enable(output);
+	if (err < 0)
+		dev_err(encoder->dev->dev, "tegra_output_enable(): %d\n", err);
+}
+
+static const struct drm_encoder_helper_funcs encoder_helper_funcs = {
+	.dpms = tegra_encoder_dpms,
+	.mode_fixup = tegra_encoder_mode_fixup,
+	.prepare = tegra_encoder_prepare,
+	.commit = tegra_encoder_commit,
+	.mode_set = tegra_encoder_mode_set,
+};
+
+static irqreturn_t hpd_irq(int irq, void *data)
+{
+	struct tegra_output *output = data;
+
+	drm_helper_hpd_irq_event(output->connector.dev);
+
+	return IRQ_HANDLED;
+}
+
+int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
+{
+	struct device_node *ddc, *np;
+	int connector, encoder, err;
+	enum of_gpio_flags flags;
+	size_t size;
+
+	if (!output->of_node)
+		output->of_node = output->dev->of_node;
+
+	np = of_get_child_by_name(output->of_node, "display");
+	if (np) {
+		output->display = of_get_display(np);
+		if (IS_ERR(output->display))
+			return PTR_ERR(output->display);
+	}
+
+	output->edid = of_get_property(output->of_node, "nvidia,edid", &size);
+
+	ddc = of_parse_phandle(output->of_node, "nvidia,ddc-i2c-bus", 0);
+	if (ddc) {
+		output->ddc = of_find_i2c_adapter_by_node(ddc);
+		of_node_put(ddc);
+	}
+
+	if (!output->display && !output->edid && !output->ddc) {
+		display_put(output->display);
+		return -ENODEV;
+	}
+
+	output->hpd_gpio = of_get_named_gpio_flags(output->of_node,
+						   "nvidia,hpd-gpio", 0,
+						   &flags);
+
+	switch (output->type) {
+	case TEGRA_OUTPUT_RGB:
+		connector = DRM_MODE_CONNECTOR_LVDS;
+		encoder = DRM_MODE_ENCODER_LVDS;
+		break;
+
+	case TEGRA_OUTPUT_HDMI:
+		connector = DRM_MODE_CONNECTOR_HDMIA;
+		encoder = DRM_MODE_ENCODER_TMDS;
+		break;
+
+	default:
+		connector = DRM_MODE_CONNECTOR_Unknown;
+		encoder = DRM_MODE_ENCODER_NONE;
+		break;
+	}
+
+	drm_connector_init(drm, &output->connector, &connector_funcs,
+			   connector);
+	drm_connector_helper_add(&output->connector, &connector_helper_funcs);
+
+	drm_encoder_init(drm, &output->encoder, &encoder_funcs, encoder);
+	drm_encoder_helper_add(&output->encoder, &encoder_helper_funcs);
+
+	drm_mode_connector_attach_encoder(&output->connector, &output->encoder);
+	drm_sysfs_connector_add(&output->connector);
+
+	output->encoder.possible_crtcs = 0x3;
+
+	if (gpio_is_valid(output->hpd_gpio)) {
+		unsigned long flags;
+
+		err = gpio_request_one(output->hpd_gpio, GPIOF_DIR_IN,
+				       "HDMI hotplug detect");
+		if (err < 0) {
+			dev_err(output->dev, "gpio_request_one(): %d\n", err);
+			goto put_i2c;
+		}
+
+		err = gpio_to_irq(output->hpd_gpio);
+		if (err < 0) {
+			dev_err(output->dev, "gpio_to_irq(): %d\n", err);
+			goto free_hpd;
+		}
+
+		output->hpd_irq = err;
+
+		flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+			IRQF_ONESHOT;
+
+		err = request_threaded_irq(output->hpd_irq, NULL, hpd_irq,
+					   flags, "hpd", output);
+		if (err < 0) {
+			dev_err(output->dev, "failed to request IRQ#%u: %d\n",
+				output->hpd_irq, err);
+			goto free_hpd;
+		}
+
+		output->connector.polled = DRM_CONNECTOR_POLL_HPD;
+	}
+
+	return 0;
+
+free_hpd:
+	gpio_free(output->hpd_gpio);
+put_i2c:
+	if (output->ddc)
+		put_device(&output->ddc->dev);
+
+	display_put(output->display);
+
+	return err;
+}
+
+int tegra_output_exit(struct tegra_output *output)
+{
+	if (gpio_is_valid(output->hpd_gpio)) {
+		free_irq(output->hpd_irq, output);
+		gpio_free(output->hpd_gpio);
+	}
+
+	if (output->ddc)
+		put_device(&output->ddc->dev);
+
+	display_put(output->display);
+
+	return 0;
+}
diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
new file mode 100644
index 0000000..67ad87e
--- /dev/null
+++ b/drivers/gpu/drm/tegra/rgb.c
@@ -0,0 +1,200 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "drm.h"
+#include "dc.h"
+
+struct tegra_rgb {
+	struct tegra_output output;
+	struct clk *clk_parent;
+	struct clk *clk;
+};
+
+static inline struct tegra_rgb *to_rgb(struct tegra_output *output)
+{
+	return container_of(output, struct tegra_rgb, output);
+}
+
+struct reg_entry {
+	unsigned long offset;
+	unsigned long value;
+};
+
+static const struct reg_entry rgb_enable[] = {
+	{ DC_COM_PIN_OUTPUT_ENABLE(0),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(1),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(2),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(3),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(0), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(1), 0x01000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(2), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(3), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(0),     0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(1),     0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(2),     0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(3),     0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(0),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(1),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(2),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(3),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(4),   0x00210222 },
+	{ DC_COM_PIN_OUTPUT_SELECT(5),   0x00002200 },
+	{ DC_COM_PIN_OUTPUT_SELECT(6),   0x00020000 },
+};
+
+static const struct reg_entry rgb_disable[] = {
+	{ DC_COM_PIN_OUTPUT_SELECT(6),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(5),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(4),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(3),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(2),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(1),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_SELECT(0),   0x00000000 },
+	{ DC_COM_PIN_OUTPUT_DATA(3),     0xaaaaaaaa },
+	{ DC_COM_PIN_OUTPUT_DATA(2),     0xaaaaaaaa },
+	{ DC_COM_PIN_OUTPUT_DATA(1),     0xaaaaaaaa },
+	{ DC_COM_PIN_OUTPUT_DATA(0),     0xaaaaaaaa },
+	{ DC_COM_PIN_OUTPUT_POLARITY(3), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(2), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(1), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_POLARITY(0), 0x00000000 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(3),   0x55555555 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(2),   0x55555555 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(1),   0x55150005 },
+	{ DC_COM_PIN_OUTPUT_ENABLE(0),   0x55555555 },
+};
+
+static void tegra_dc_write_regs(struct tegra_dc *dc,
+				const struct reg_entry *table,
+				unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		tegra_dc_writel(dc, table[i].value, table[i].offset);
+}
+
+static int tegra_output_rgb_enable(struct tegra_output *output)
+{
+	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
+
+	tegra_dc_write_regs(dc, rgb_enable, ARRAY_SIZE(rgb_enable));
+
+	return 0;
+}
+
+static int tegra_output_rgb_disable(struct tegra_output *output)
+{
+	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
+
+	tegra_dc_write_regs(dc, rgb_disable, ARRAY_SIZE(rgb_disable));
+
+	return 0;
+}
+
+static int tegra_output_rgb_setup_clock(struct tegra_output *output,
+					struct clk *clk, unsigned long pclk)
+{
+	struct tegra_rgb *rgb = to_rgb(output);
+
+	return clk_set_parent(clk, rgb->clk_parent);
+}
+
+static int tegra_output_rgb_check_mode(struct tegra_output *output,
+				       struct drm_display_mode *mode,
+				       enum drm_mode_status *status)
+{
+	/*
+	 * FIXME: For now, always assume that the mode is okay. There are
+	 * unresolved issues with clk_round_rate(), which doesn't always
+	 * reliably report whether a frequency can be set or not.
+	 */
+
+	*status = MODE_OK;
+
+	return 0;
+}
+
+static const struct tegra_output_ops rgb_ops = {
+	.enable = tegra_output_rgb_enable,
+	.disable = tegra_output_rgb_disable,
+	.setup_clock = tegra_output_rgb_setup_clock,
+	.check_mode = tegra_output_rgb_check_mode,
+};
+
+int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
+{
+	struct device_node *np;
+	struct tegra_rgb *rgb;
+	int err;
+
+	np = of_get_child_by_name(dc->dev->of_node, "rgb");
+	if (!np || !of_device_is_available(np))
+		return -ENODEV;
+
+	rgb = devm_kzalloc(dc->dev, sizeof(*rgb), GFP_KERNEL);
+	if (!rgb)
+		return -ENOMEM;
+
+	rgb->clk = devm_clk_get(dc->dev, NULL);
+	if (IS_ERR_OR_NULL(rgb->clk))
+		return PTR_ERR(rgb->clk);
+
+	rgb->clk_parent = devm_clk_get(dc->dev, "parent");
+	if (IS_ERR_OR_NULL(rgb->clk_parent))
+		return PTR_ERR(rgb->clk_parent);
+
+	err = clk_set_parent(rgb->clk, rgb->clk_parent);
+	if (err < 0) {
+		dev_err(dc->dev, "failed to set parent clock: %d\n", err);
+		return err;
+	}
+
+	rgb->output.type = TEGRA_OUTPUT_RGB;
+	rgb->output.ops = &rgb_ops;
+	rgb->output.dev = dc->dev;
+	rgb->output.of_node = np;
+
+	err = tegra_output_init(dc->base.dev, &rgb->output);
+	if (err < 0) {
+		dev_err(dc->dev, "output setup failed: %d\n", err);
+		return err;
+	}
+
+	/*
+	 * By default, outputs can be associated with each display controller.
+	 * RGB outputs are an exception, so we make sure they can be attached
+	 * to only their parent display controller.
+	 */
+	rgb->output.encoder.possible_crtcs = 1 << dc->pipe;
+
+	dc->rgb = &rgb->output;
+
+	return 0;
+}
+
+int tegra_dc_rgb_exit(struct tegra_dc *dc)
+{
+	if (dc->rgb) {
+		int err = tegra_output_exit(dc->rgb);
+		if (err < 0) {
+			dev_err(dc->dev, "output cleanup failed: %d\n", err);
+			return err;
+		}
+
+		dc->rgb = NULL;
+	}
+
+	return 0;
+}
-- 
1.8.0

