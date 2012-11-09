Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2KIOA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:00:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2KIN7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:59:51 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drm: tegra: Add HDMI support
Date: Fri,  9 Nov 2012 14:59:39 +0100
Message-Id: <1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:viZNWT/ysSPL866tVGjs7iOGBNKMCt+ahdr4g7WnJuG
 VqpM955Y7Ts5KcxXwpNTWaSKbWCyUciCMHCMOGzFbSq8JzufR3
 pkG/qQIiAWbZRaWeoDL59hyTEpxrJ3JpFuPMaHKMG3raZ1vHbj
 oRJ/0Frzk6aRMBJSmW7Zu/YDg9yo9eRguOSLZL+Sogn7E0jHXs
 M4cSYXbmBwm1c91O4CuHcIi4v2stmq2NCordKuMcX/m2/ZuqSi
 nSaRQ4JMhxWy+bWWS0lAIGtxFxgzpklaT7oo4Z88QpOmYV+b/4
 YEzJ5QuNU7xpwSAhD9XcqWCXvj2DELyJW2xL4i1fk4ooiE9kbx
 U6D5O6t/1qF7oolFKGegoPL2j4vQeP1mmLBHhwgCQG8FodAN4H
 J+3S2WgbAX/tyDfLgHA7grgYLGCgGOCShZ/JQ2lPdW4AaSOJem
 rFoza
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for the HDMI output on the Tegra20 SoC. Only
one such output is available, but it can be driven by either of the two
display controllers.

A lot of work on this patch has been contributed by NVIDIA's Mark Zhang
<markz@nvidia.com> and many other people at NVIDIA were very helpful in
getting the HDMI support and surrounding infrastructure to work.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/gpu/drm/tegra/Makefile |    2 +-
 drivers/gpu/drm/tegra/drm.h    |    2 +
 drivers/gpu/drm/tegra/hdmi.c   | 1290 ++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tegra/hdmi.h   |  575 ++++++++++++++++++
 drivers/gpu/drm/tegra/host1x.c |    8 +
 5 files changed, 1876 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/tegra/hdmi.c
 create mode 100644 drivers/gpu/drm/tegra/hdmi.h

diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
index 624a807..80f73d1 100644
--- a/drivers/gpu/drm/tegra/Makefile
+++ b/drivers/gpu/drm/tegra/Makefile
@@ -2,6 +2,6 @@ ccflags-y := -Iinclude/drm
 ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
 
 tegra-drm-y := drm.o fb.o dc.o host1x.o
-tegra-drm-y += output.o rgb.o
+tegra-drm-y += output.o rgb.o hdmi.o
 
 obj-$(CONFIG_DRM_TEGRA) += tegra-drm.o
diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
index 7334b68..03cb06f 100644
--- a/drivers/gpu/drm/tegra/drm.h
+++ b/drivers/gpu/drm/tegra/drm.h
@@ -133,6 +133,7 @@ struct tegra_output_ops {
 
 enum tegra_output_type {
 	TEGRA_OUTPUT_RGB,
+	TEGRA_OUTPUT_HDMI,
 };
 
 struct tegra_output {
@@ -227,6 +228,7 @@ extern int tegra_drm_fb_init(struct drm_device *drm);
 extern void tegra_drm_fb_exit(struct drm_device *drm);
 
 extern struct platform_driver tegra_host1x_driver;
+extern struct platform_driver tegra_hdmi_driver;
 extern struct platform_driver tegra_dc_driver;
 extern struct drm_driver tegra_drm_driver;
 
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
new file mode 100644
index 0000000..907a855
--- /dev/null
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -0,0 +1,1290 @@
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
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+
+#include <mach/clk.h>
+
+#include "hdmi.h"
+#include "drm.h"
+#include "dc.h"
+
+struct tegra_hdmi {
+	struct host1x_client client;
+	struct tegra_output output;
+	struct device *dev;
+
+	struct regulator *vdd;
+	struct regulator *pll;
+
+	void __iomem *regs;
+	unsigned int irq;
+
+	struct clk *clk_parent;
+	struct clk *clk;
+
+	unsigned int audio_source;
+	unsigned int audio_freq;
+	bool stereo;
+	bool dvi;
+
+	struct dentry *debugfs;
+};
+
+static inline struct tegra_hdmi *
+host1x_client_to_hdmi(struct host1x_client *client)
+{
+	return container_of(client, struct tegra_hdmi, client);
+}
+
+static inline struct tegra_hdmi *to_hdmi(struct tegra_output *output)
+{
+	return container_of(output, struct tegra_hdmi, output);
+}
+
+#define HDMI_AUDIOCLK_FREQ 216000000
+#define HDMI_REKEY_DEFAULT 56
+
+enum {
+	AUTO = 0,
+	SPDIF,
+	HDA,
+};
+
+static inline unsigned long tegra_hdmi_readl(struct tegra_hdmi *hdmi,
+					     unsigned long reg)
+{
+	return readl(hdmi->regs + (reg << 2));
+}
+
+static inline void tegra_hdmi_writel(struct tegra_hdmi *hdmi, unsigned long val,
+				     unsigned long reg)
+{
+	writel(val, hdmi->regs + (reg << 2));
+}
+
+struct tegra_hdmi_audio_config {
+	unsigned int pclk;
+	unsigned int n;
+	unsigned int cts;
+	unsigned int aval;
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_32k[] = {
+	{  25200000, 4096,  25200, 24000 },
+	{  27000000, 4096,  27000, 24000 },
+	{  74250000, 4096,  74250, 24000 },
+	{ 148500000, 4096, 148500, 24000 },
+	{         0,    0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_44_1k[] = {
+	{  25200000, 5880,  26250, 25000 },
+	{  27000000, 5880,  28125, 25000 },
+	{  74250000, 4704,  61875, 20000 },
+	{ 148500000, 4704, 123750, 20000 },
+	{         0,    0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_48k[] = {
+	{  25200000, 6144,  25200, 24000 },
+	{  27000000, 6144,  27000, 24000 },
+	{  74250000, 6144,  74250, 24000 },
+	{ 148500000, 6144, 148500, 24000 },
+	{         0,    0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_88_2k[] = {
+	{  25200000, 11760,  26250, 25000 },
+	{  27000000, 11760,  28125, 25000 },
+	{  74250000,  9408,  61875, 20000 },
+	{ 148500000,  9408, 123750, 20000 },
+	{         0,     0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_96k[] = {
+	{  25200000, 12288,  25200, 24000 },
+	{  27000000, 12288,  27000, 24000 },
+	{  74250000, 12288,  74250, 24000 },
+	{ 148500000, 12288, 148500, 24000 },
+	{         0,     0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_176_4k[] = {
+	{  25200000, 23520,  26250, 25000 },
+	{  27000000, 23520,  28125, 25000 },
+	{  74250000, 18816,  61875, 20000 },
+	{ 148500000, 18816, 123750, 20000 },
+	{         0,     0,      0,     0 },
+};
+
+static const struct tegra_hdmi_audio_config tegra_hdmi_audio_192k[] = {
+	{  25200000, 24576,  25200, 24000 },
+	{  27000000, 24576,  27000, 24000 },
+	{  74250000, 24576,  74250, 24000 },
+	{ 148500000, 24576, 148500, 24000 },
+	{         0,     0,      0,     0 },
+};
+
+struct tmds_config {
+	unsigned int pclk;
+	u32 pll0;
+	u32 pll1;
+	u32 pe_current;
+	u32 drive_current;
+};
+
+static const struct tmds_config tegra2_tmds_config[] = {
+	{ /* 480p modes */
+		.pclk = 27000000,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(0) |
+			SOR_PLL_TX_REG_LOAD(3),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE,
+		.pe_current = PE_CURRENT0(PE_CURRENT_0_0_mA) |
+			PE_CURRENT1(PE_CURRENT_0_0_mA) |
+			PE_CURRENT2(PE_CURRENT_0_0_mA) |
+			PE_CURRENT3(PE_CURRENT_0_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_7_125_mA),
+	}, { /* 720p modes */
+		.pclk = 74250000,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(1) |
+			SOR_PLL_TX_REG_LOAD(3),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
+		.pe_current = PE_CURRENT0(PE_CURRENT_6_0_mA) |
+			PE_CURRENT1(PE_CURRENT_6_0_mA) |
+			PE_CURRENT2(PE_CURRENT_6_0_mA) |
+			PE_CURRENT3(PE_CURRENT_6_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_7_125_mA),
+	}, { /* 1080p modes */
+		.pclk = UINT_MAX,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(1) |
+			SOR_PLL_TX_REG_LOAD(3),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
+		.pe_current = PE_CURRENT0(PE_CURRENT_6_0_mA) |
+			PE_CURRENT1(PE_CURRENT_6_0_mA) |
+			PE_CURRENT2(PE_CURRENT_6_0_mA) |
+			PE_CURRENT3(PE_CURRENT_6_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_7_125_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_7_125_mA),
+	},
+};
+
+static const struct tmds_config tegra3_tmds_config[] = {
+	{ /* 480p modes */
+		.pclk = 27000000,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(0) |
+			SOR_PLL_TX_REG_LOAD(0),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE,
+		.pe_current = PE_CURRENT0(PE_CURRENT_0_0_mA) |
+			PE_CURRENT1(PE_CURRENT_0_0_mA) |
+			PE_CURRENT2(PE_CURRENT_0_0_mA) |
+			PE_CURRENT3(PE_CURRENT_0_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
+	}, { /* 720p modes */
+		.pclk = 74250000,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(1) |
+			SOR_PLL_TX_REG_LOAD(0),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
+		.pe_current = PE_CURRENT0(PE_CURRENT_5_0_mA) |
+			PE_CURRENT1(PE_CURRENT_5_0_mA) |
+			PE_CURRENT2(PE_CURRENT_5_0_mA) |
+			PE_CURRENT3(PE_CURRENT_5_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
+	}, { /* 1080p modes */
+		.pclk = UINT_MAX,
+		.pll0 = SOR_PLL_BG_V17_S(3) | SOR_PLL_ICHPMP(1) |
+			SOR_PLL_RESISTORSEL | SOR_PLL_VCOCAP(3) |
+			SOR_PLL_TX_REG_LOAD(0),
+		.pll1 = SOR_PLL_TMDS_TERM_ENABLE | SOR_PLL_PE_EN,
+		.pe_current = PE_CURRENT0(PE_CURRENT_5_0_mA) |
+			PE_CURRENT1(PE_CURRENT_5_0_mA) |
+			PE_CURRENT2(PE_CURRENT_5_0_mA) |
+			PE_CURRENT3(PE_CURRENT_5_0_mA),
+		.drive_current = DRIVE_CURRENT_LANE0(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE1(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE2(DRIVE_CURRENT_5_250_mA) |
+			DRIVE_CURRENT_LANE3(DRIVE_CURRENT_5_250_mA),
+	},
+};
+
+static const struct tegra_hdmi_audio_config *
+tegra_hdmi_get_audio_config(unsigned int audio_freq, unsigned int pclk)
+{
+	const struct tegra_hdmi_audio_config *table;
+
+	switch (audio_freq) {
+	case 32000:
+		table = tegra_hdmi_audio_32k;
+		break;
+
+	case 44100:
+		table = tegra_hdmi_audio_44_1k;
+		break;
+
+	case 48000:
+		table = tegra_hdmi_audio_48k;
+		break;
+
+	case 88200:
+		table = tegra_hdmi_audio_88_2k;
+		break;
+
+	case 96000:
+		table = tegra_hdmi_audio_96k;
+		break;
+
+	case 176400:
+		table = tegra_hdmi_audio_176_4k;
+		break;
+
+	case 192000:
+		table = tegra_hdmi_audio_192k;
+		break;
+
+	default:
+		return NULL;
+	}
+
+	while (table->pclk) {
+		if (table->pclk == pclk)
+			return table;
+
+		table++;
+	}
+
+	return NULL;
+}
+
+static void tegra_hdmi_setup_audio_fs_tables(struct tegra_hdmi *hdmi)
+{
+	const unsigned int freqs[] = {
+		32000, 44100, 48000, 88200, 96000, 176400, 192000
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(freqs); i++) {
+		unsigned int f = freqs[i];
+		unsigned int eight_half;
+		unsigned long value;
+		unsigned int delta;
+
+		if (f > 96000)
+			delta = 2;
+		else if (f > 480000)
+			delta = 6;
+		else
+			delta = 9;
+
+		eight_half = (8 * HDMI_AUDIOCLK_FREQ) / (f * 128);
+		value = AUDIO_FS_LOW(eight_half - delta) |
+			AUDIO_FS_HIGH(eight_half + delta);
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_FS(i));
+	}
+}
+
+static int tegra_hdmi_setup_audio(struct tegra_hdmi *hdmi, unsigned int pclk)
+{
+	struct device_node *node = hdmi->dev->of_node;
+	const struct tegra_hdmi_audio_config *config;
+	unsigned int offset = 0;
+	unsigned long value;
+
+	switch (hdmi->audio_source) {
+	case HDA:
+		value = AUDIO_CNTRL0_SOURCE_SELECT_HDAL;
+		break;
+
+	case SPDIF:
+		value = AUDIO_CNTRL0_SOURCE_SELECT_SPDIF;
+		break;
+
+	default:
+		value = AUDIO_CNTRL0_SOURCE_SELECT_AUTO;
+		break;
+	}
+
+	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
+		value |= AUDIO_CNTRL0_ERROR_TOLERANCE(6) |
+			 AUDIO_CNTRL0_FRAMES_PER_BLOCK(0xc0);
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_CNTRL0);
+	} else {
+		value |= AUDIO_CNTRL0_INJECT_NULLSMPL;
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_AUDIO_CNTRL0);
+
+		value = AUDIO_CNTRL0_ERROR_TOLERANCE(6) |
+			AUDIO_CNTRL0_FRAMES_PER_BLOCK(0xc0);
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_CNTRL0);
+	}
+
+	config = tegra_hdmi_get_audio_config(hdmi->audio_freq, pclk);
+	if (!config) {
+		dev_err(hdmi->dev, "cannot set audio to %u at %u pclk\n",
+			hdmi->audio_freq, pclk);
+		return -EINVAL;
+	}
+
+	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_HDMI_ACR_CTRL);
+
+	value = AUDIO_N_RESETF | AUDIO_N_GENERATE_ALTERNATE |
+		AUDIO_N_VALUE(config->n - 1);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_N);
+
+	tegra_hdmi_writel(hdmi, ACR_SUBPACK_N(config->n) | ACR_ENABLE,
+			  HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH);
+
+	value = ACR_SUBPACK_CTS(config->cts);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW);
+
+	value = SPARE_HW_CTS | SPARE_FORCE_SW_CTS | SPARE_CTS_RESET_VAL(1);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_SPARE);
+
+	value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_AUDIO_N);
+	value &= ~AUDIO_N_RESETF;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_AUDIO_N);
+
+	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
+		switch (hdmi->audio_freq) {
+		case 32000:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0320;
+			break;
+
+		case 44100:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0441;
+			break;
+
+		case 48000:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0480;
+			break;
+
+		case 88200:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0882;
+			break;
+
+		case 96000:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_0960;
+			break;
+
+		case 176400:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_1764;
+			break;
+
+		case 192000:
+			offset = HDMI_NV_PDISP_SOR_AUDIO_AVAL_1920;
+			break;
+		}
+
+		tegra_hdmi_writel(hdmi, config->aval, offset);
+	}
+
+	tegra_hdmi_setup_audio_fs_tables(hdmi);
+
+	return 0;
+}
+
+static void tegra_hdmi_write_infopack(struct tegra_hdmi *hdmi,
+				      unsigned int offset, u8 type,
+				      u8 version, void *data, size_t size)
+{
+	unsigned long value;
+	u8 *ptr = data;
+	u32 subpack[2];
+	size_t i;
+	u8 csum;
+
+	/* first byte of data is the checksum */
+	csum = type + version + size - 1;
+
+	for (i = 1; i < size; i++)
+		csum += ptr[i];
+
+	ptr[0] = 0x100 - csum;
+
+	value = INFOFRAME_HEADER_TYPE(type) |
+		INFOFRAME_HEADER_VERSION(version) |
+		INFOFRAME_HEADER_LEN(size - 1);
+	tegra_hdmi_writel(hdmi, value, offset);
+
+	/* The audio inforame only has one set of subpack registers.  The hdmi
+	 * block pads the rest of the data as per the spec so we have to fixup
+	 * the length before filling in the subpacks.
+	 */
+	if (offset == HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER)
+		size = 6;
+
+	/* each subpack 7 bytes devided into:
+	 *   subpack_low - bytes 0 - 3
+	 *   subpack_high - bytes 4 - 6 (with byte 7 padded to 0x00)
+	 */
+	for (i = 0; i < size; i++) {
+		size_t index = i % 7;
+
+		if (index == 0)
+			memset(subpack, 0x0, sizeof(subpack));
+
+		((u8 *)subpack)[index] = ptr[i];
+
+		if (index == 6 || (i + 1 == size)) {
+			unsigned int reg = offset + 1 + (i / 7) * 2;
+
+			tegra_hdmi_writel(hdmi, subpack[0], reg);
+			tegra_hdmi_writel(hdmi, subpack[1], reg + 1);
+		}
+	}
+}
+
+static void tegra_hdmi_setup_avi_infoframe(struct tegra_hdmi *hdmi,
+					   struct drm_display_mode *mode)
+{
+	struct hdmi_avi_infoframe frame;
+	unsigned int h_front_porch;
+	unsigned int hsize = 16;
+	unsigned int vsize = 9;
+
+	if (hdmi->dvi) {
+		tegra_hdmi_writel(hdmi, 0,
+				  HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
+		return;
+	}
+
+	h_front_porch = mode->htotal - mode->hsync_end;
+	memset(&frame, 0, sizeof(frame));
+	frame.r = HDMI_AVI_R_SAME;
+
+	switch (mode->vdisplay) {
+	case 480:
+		if (mode->hdisplay == 640) {
+			frame.m = HDMI_AVI_M_4_3;
+			frame.vic = 1;
+		} else {
+			frame.m = HDMI_AVI_M_16_9;
+			frame.vic = 3;
+		}
+		break;
+
+	case 576:
+		if (((hsize * 10) / vsize) > 14) {
+			frame.m = HDMI_AVI_M_16_9;
+			frame.vic = 18;
+		} else {
+			frame.m = HDMI_AVI_M_4_3;
+			frame.vic = 17;
+		}
+		break;
+
+	case 720:
+	case 1470: /* stereo mode */
+		frame.m = HDMI_AVI_M_16_9;
+
+		if (h_front_porch == 110)
+			frame.vic = 4;
+		else
+			frame.vic = 19;
+		break;
+
+	case 1080:
+	case 2205: /* stereo mode */
+		frame.m = HDMI_AVI_M_16_9;
+
+		switch (h_front_porch) {
+		case 88:
+			frame.vic = 16;
+			break;
+
+		case 528:
+			frame.vic = 31;
+			break;
+
+		default:
+			frame.vic = 32;
+			break;
+		}
+		break;
+
+	default:
+		frame.m = HDMI_AVI_M_16_9;
+		frame.vic = 0;
+		break;
+	}
+
+	tegra_hdmi_write_infopack(hdmi, HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER,
+				  HDMI_INFOFRAME_TYPE_AVI, HDMI_AVI_VERSION,
+				  &frame, sizeof(frame));
+
+	tegra_hdmi_writel(hdmi, INFOFRAME_CTRL_ENABLE,
+			  HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
+}
+
+static void tegra_hdmi_setup_audio_infoframe(struct tegra_hdmi *hdmi)
+{
+	struct hdmi_audio_infoframe frame;
+
+	if (hdmi->dvi) {
+		tegra_hdmi_writel(hdmi, 0,
+				  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
+		return;
+	}
+
+	memset(&frame, 0, sizeof(frame));
+	frame.cc = HDMI_AUDIO_CC_2;
+
+	tegra_hdmi_write_infopack(hdmi,
+				  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER,
+				  HDMI_INFOFRAME_TYPE_AUDIO,
+				  HDMI_AUDIO_VERSION,
+				  &frame, sizeof(frame));
+
+	tegra_hdmi_writel(hdmi, INFOFRAME_CTRL_ENABLE,
+			  HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
+}
+
+static void tegra_hdmi_setup_stereo_infoframe(struct tegra_hdmi *hdmi)
+{
+	struct hdmi_stereo_infoframe frame;
+	unsigned long value;
+
+	if (!hdmi->stereo) {
+		value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+		value &= ~GENERIC_CTRL_ENABLE;
+		tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+		return;
+	}
+
+	memset(&frame, 0, sizeof(frame));
+	frame.regid0 = 0x03;
+	frame.regid1 = 0x0c;
+	frame.regid2 = 0x00;
+	frame.hdmi_video_format = 2;
+
+	/* TODO: 74 MHz limit? */
+	if (1) {
+		frame._3d_structure = 0;
+	} else {
+		frame._3d_structure = 8;
+		frame._3d_ext_data = 0;
+	}
+
+	tegra_hdmi_write_infopack(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_HEADER,
+				  HDMI_INFOFRAME_TYPE_VENDOR,
+				  HDMI_VENDOR_VERSION, &frame, 6);
+
+	value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+	value |= GENERIC_CTRL_ENABLE;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+}
+
+static void tegra_hdmi_setup_tmds(struct tegra_hdmi *hdmi,
+				  const struct tmds_config *tmds)
+{
+	unsigned long value;
+
+	tegra_hdmi_writel(hdmi, tmds->pll0, HDMI_NV_PDISP_SOR_PLL0);
+	tegra_hdmi_writel(hdmi, tmds->pll1, HDMI_NV_PDISP_SOR_PLL1);
+	tegra_hdmi_writel(hdmi, tmds->pe_current, HDMI_NV_PDISP_PE_CURRENT);
+
+	value = tmds->drive_current | DRIVE_CURRENT_FUSE_OVERRIDE;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
+}
+
+static int tegra_output_hdmi_enable(struct tegra_output *output)
+{
+	unsigned int h_sync_width, h_front_porch, h_back_porch, i, rekey;
+	struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
+	struct drm_display_mode *mode = &dc->base.mode;
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	struct device_node *node = hdmi->dev->of_node;
+	unsigned int pulse_start, div82, pclk;
+	const struct tmds_config *tmds;
+	unsigned int num_tmds;
+	unsigned long value;
+	int retries = 1000;
+	int err;
+
+	pclk = mode->clock * 1000;
+	h_sync_width = mode->hsync_end - mode->hsync_start;
+	h_front_porch = mode->htotal - mode->hsync_end;
+	h_back_porch = mode->hsync_start - mode->hdisplay;
+	dev_dbg(output->dev, "SW/FP/BP: %u %u %u\n",
+			h_sync_width, h_front_porch, h_back_porch);
+
+	err = regulator_enable(hdmi->vdd);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable VDD regulator: %d\n", err);
+		return err;
+	}
+
+	err = regulator_enable(hdmi->pll);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable PLL regulator: %d\n", err);
+		return err;
+	}
+
+	/*
+	 * This assumes that the display controller will divide its parent
+	 * clock by 2 to generate the pixel clock.
+	 */
+	err = tegra_output_setup_clock(output, hdmi->clk, pclk * 2);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to setup clock: %d\n", err);
+		return err;
+	}
+
+	err = clk_set_rate(hdmi->clk, pclk);
+	if (err < 0)
+		return err;
+
+	err = clk_enable(hdmi->clk);
+	if (err < 0) {
+		dev_err(hdmi->dev, "failed to enable clock: %d\n", err);
+		return err;
+	}
+
+	tegra_periph_reset_assert(hdmi->clk);
+	usleep_range(1000, 2000);
+	tegra_periph_reset_deassert(hdmi->clk);
+
+	tegra_dc_writel(dc, VSYNC_H_POSITION(1),
+			DC_DISP_DISP_TIMING_OPTIONS);
+	tegra_dc_writel(dc, DITHER_CONTROL_DISABLE | BASE_COLOR_SIZE888,
+			DC_DISP_DISP_COLOR_CONTROL);
+
+	/* video_preamble uses h_pulse2 */
+	pulse_start = 1 + h_sync_width + h_back_porch - 10;
+
+	tegra_dc_writel(dc, H_PULSE_2_ENABLE, DC_DISP_DISP_SIGNAL_OPTIONS0);
+
+	value = PULSE_MODE_NORMAL | PULSE_POLARITY_HIGH | PULSE_QUAL_VACTIVE |
+		PULSE_LAST_END_A;
+	tegra_dc_writel(dc, value, DC_DISP_H_PULSE2_CONTROL);
+
+	value = PULSE_START(pulse_start) | PULSE_END(pulse_start + 8);
+	tegra_dc_writel(dc, value, DC_DISP_H_PULSE2_POSITION_A);
+
+	value = VSYNC_WINDOW_END(0x210) | VSYNC_WINDOW_START(0x200) |
+		VSYNC_WINDOW_ENABLE;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_VSYNC_WINDOW);
+
+	if (dc->pipe)
+		value = HDMI_SRC_DISPLAYB;
+	else
+		value = HDMI_SRC_DISPLAYA;
+
+	if ((mode->hdisplay == 720) && ((mode->vdisplay == 480) ||
+					(mode->vdisplay == 576)))
+		tegra_hdmi_writel(hdmi,
+				  value | ARM_VIDEO_RANGE_FULL,
+				  HDMI_NV_PDISP_INPUT_CONTROL);
+	else
+		tegra_hdmi_writel(hdmi,
+				  value | ARM_VIDEO_RANGE_LIMITED,
+				  HDMI_NV_PDISP_INPUT_CONTROL);
+
+	div82 = clk_get_rate(hdmi->clk) / 1000000 * 4;
+	value = SOR_REFCLK_DIV_INT(div82 >> 2) | SOR_REFCLK_DIV_FRAC(div82);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_REFCLK);
+
+	if (!hdmi->dvi) {
+		err = tegra_hdmi_setup_audio(hdmi, pclk);
+		if (err < 0)
+			hdmi->dvi = true;
+	}
+
+	if (of_device_is_compatible(node, "nvidia,tegra20-hdmi")) {
+		/*
+		 * TODO: add ELD support
+		 */
+	}
+
+	rekey = HDMI_REKEY_DEFAULT;
+	value = HDMI_CTRL_REKEY(rekey);
+	value |= HDMI_CTRL_MAX_AC_PACKET((h_sync_width + h_back_porch +
+					  h_front_porch - rekey - 18) / 32);
+
+	if (!hdmi->dvi)
+		value |= HDMI_CTRL_ENABLE;
+
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_HDMI_CTRL);
+
+	if (hdmi->dvi)
+		tegra_hdmi_writel(hdmi, 0x0,
+				  HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+	else
+		tegra_hdmi_writel(hdmi, GENERIC_CTRL_AUDIO,
+				  HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+
+	tegra_hdmi_setup_avi_infoframe(hdmi, mode);
+	tegra_hdmi_setup_audio_infoframe(hdmi);
+	tegra_hdmi_setup_stereo_infoframe(hdmi);
+
+	/* TMDS CONFIG */
+	if (of_device_is_compatible(node, "nvidia,tegra30-hdmi")) {
+		num_tmds = ARRAY_SIZE(tegra3_tmds_config);
+		tmds = tegra3_tmds_config;
+	} else {
+		num_tmds = ARRAY_SIZE(tegra2_tmds_config);
+		tmds = tegra2_tmds_config;
+	}
+
+	for (i = 0; i < num_tmds; i++) {
+		if (pclk <= tmds[i].pclk) {
+			tegra_hdmi_setup_tmds(hdmi, &tmds[i]);
+			break;
+		}
+	}
+
+	tegra_hdmi_writel(hdmi,
+			  SOR_SEQ_CTL_PU_PC(0) |
+			  SOR_SEQ_PU_PC_ALT(0) |
+			  SOR_SEQ_PD_PC(8) |
+			  SOR_SEQ_PD_PC_ALT(8),
+			  HDMI_NV_PDISP_SOR_SEQ_CTL);
+
+	value = SOR_SEQ_INST_WAIT_TIME(1) |
+		SOR_SEQ_INST_WAIT_UNITS_VSYNC |
+		SOR_SEQ_INST_HALT |
+		SOR_SEQ_INST_PIN_A_LOW |
+		SOR_SEQ_INST_PIN_B_LOW |
+		SOR_SEQ_INST_DRIVE_PWM_OUT_LO;
+
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_SEQ_INST(0));
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_SEQ_INST(8));
+
+	value = 0x1c800;
+	value &= ~SOR_CSTM_ROTCLK(~0);
+	value |= SOR_CSTM_ROTCLK(2);
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_CSTM);
+
+	tegra_dc_writel(dc, DISP_CTRL_MODE_STOP, DC_CMD_DISPLAY_COMMAND);
+	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
+	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+
+	/* start SOR */
+	tegra_hdmi_writel(hdmi,
+			  SOR_PWR_NORMAL_STATE_PU |
+			  SOR_PWR_NORMAL_START_NORMAL |
+			  SOR_PWR_SAFE_STATE_PD |
+			  SOR_PWR_SETTING_NEW_TRIGGER,
+			  HDMI_NV_PDISP_SOR_PWR);
+	tegra_hdmi_writel(hdmi,
+			  SOR_PWR_NORMAL_STATE_PU |
+			  SOR_PWR_NORMAL_START_NORMAL |
+			  SOR_PWR_SAFE_STATE_PD |
+			  SOR_PWR_SETTING_NEW_DONE,
+			  HDMI_NV_PDISP_SOR_PWR);
+
+	do {
+		BUG_ON(--retries < 0);
+		value = tegra_hdmi_readl(hdmi, HDMI_NV_PDISP_SOR_PWR);
+	} while (value & SOR_PWR_SETTING_NEW_PENDING);
+
+	value = SOR_STATE_ASY_CRCMODE_COMPLETE |
+		SOR_STATE_ASY_OWNER_HEAD0 |
+		SOR_STATE_ASY_SUBOWNER_BOTH |
+		SOR_STATE_ASY_PROTOCOL_SINGLE_TMDS_A |
+		SOR_STATE_ASY_DEPOL_POS;
+
+	/* setup sync polarities */
+	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+		value |= SOR_STATE_ASY_HSYNCPOL_POS;
+
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
+		value |= SOR_STATE_ASY_HSYNCPOL_NEG;
+
+	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+		value |= SOR_STATE_ASY_VSYNCPOL_POS;
+
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
+		value |= SOR_STATE_ASY_VSYNCPOL_NEG;
+
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_STATE2);
+
+	value = SOR_STATE_ASY_HEAD_OPMODE_AWAKE | SOR_STATE_ASY_ORMODE_NORMAL;
+	tegra_hdmi_writel(hdmi, value, HDMI_NV_PDISP_SOR_STATE1);
+
+	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_SOR_STATE0);
+	tegra_hdmi_writel(hdmi, SOR_STATE_UPDATE, HDMI_NV_PDISP_SOR_STATE0);
+	tegra_hdmi_writel(hdmi, value | SOR_STATE_ATTACHED,
+			  HDMI_NV_PDISP_SOR_STATE1);
+	tegra_hdmi_writel(hdmi, 0, HDMI_NV_PDISP_SOR_STATE0);
+
+	tegra_dc_writel(dc, HDMI_ENABLE, DC_DISP_DISP_WIN_OPTIONS);
+
+	value = PW0_ENABLE | PW1_ENABLE | PW2_ENABLE | PW3_ENABLE |
+		PW4_ENABLE | PM0_ENABLE | PM1_ENABLE;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_POWER_CONTROL);
+
+	value = DISP_CTRL_MODE_C_DISPLAY;
+	tegra_dc_writel(dc, value, DC_CMD_DISPLAY_COMMAND);
+
+	tegra_dc_writel(dc, GENERAL_ACT_REQ << 8, DC_CMD_STATE_CONTROL);
+	tegra_dc_writel(dc, GENERAL_ACT_REQ, DC_CMD_STATE_CONTROL);
+
+	/* TODO: add HDCP support */
+
+	return 0;
+}
+
+static int tegra_output_hdmi_disable(struct tegra_output *output)
+{
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+
+	tegra_periph_reset_assert(hdmi->clk);
+	clk_disable(hdmi->clk);
+	regulator_disable(hdmi->pll);
+	regulator_disable(hdmi->vdd);
+
+	return 0;
+}
+
+static int tegra_output_hdmi_setup_clock(struct tegra_output *output,
+					 struct clk *clk, unsigned long pclk)
+{
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	struct clk *base;
+	int err;
+
+	err = clk_set_parent(clk, hdmi->clk_parent);
+	if (err < 0) {
+		dev_err(output->dev, "failed to set parent: %d\n", err);
+		return err;
+	}
+
+	base = clk_get_parent(hdmi->clk_parent);
+
+	/*
+	 * This assumes that the parent clock is pll_d_out0 or pll_d2_out
+	 * respectively, each of which divides the base pll_d by 2.
+	 */
+	err = clk_set_rate(base, pclk * 2);
+	if (err < 0)
+		dev_err(output->dev,
+			"failed to set base clock rate to %lu Hz\n",
+			pclk * 2);
+
+	return 0;
+}
+
+static int tegra_output_hdmi_check_mode(struct tegra_output *output,
+					struct drm_display_mode *mode,
+					enum drm_mode_status *status)
+{
+	struct tegra_hdmi *hdmi = to_hdmi(output);
+	unsigned long pclk = mode->clock * 1000;
+	struct clk *parent;
+	long err;
+
+	parent = clk_get_parent(hdmi->clk_parent);
+
+	err = clk_round_rate(parent, pclk * 4);
+	if (err < 0)
+		*status = MODE_NOCLOCK;
+	else
+		*status = MODE_OK;
+
+	return 0;
+}
+
+static const struct tegra_output_ops hdmi_ops = {
+	.enable = tegra_output_hdmi_enable,
+	.disable = tegra_output_hdmi_disable,
+	.setup_clock = tegra_output_hdmi_setup_clock,
+	.check_mode = tegra_output_hdmi_check_mode,
+};
+
+static int regs_show(struct seq_file *s, void *ignored)
+{
+	struct tegra_hdmi *hdmi = s->private;
+
+#define DUMP_REG(name)						\
+	seq_printf(s, "%-56s %#05x %08lx\n", #name, name,	\
+		tegra_hdmi_readl(hdmi, name))
+
+	DUMP_REG(HDMI_CTXSW);
+	DUMP_REG(HDMI_NV_PDISP_SOR_STATE0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_STATE1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_STATE2);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AN_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AN_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CN_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CN_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AKSV_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_AKSV_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_BKSV_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_BKSV_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CKSV_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CKSV_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_DKSV_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_DKSV_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CMODE);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_MPRIME_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_MPRIME_LSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB2);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB1);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_RI);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CS_MSB);
+	DUMP_REG(HDMI_NV_PDISP_RG_HDCP_CS_LSB);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU0);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU_RDATA0);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU1);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_EMU2);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_STATUS);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_STATUS);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_STATUS);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_HEADER);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_LOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_HIGH);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_VSYNC_KEEPOUT);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_VSYNC_WINDOW);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_STATUS);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_GCP_SUBPACK);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_CHANNEL_STATUS1);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_CHANNEL_STATUS2);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU0);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU1);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_EMU1_RDATA);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_SPARE);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS1);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS2);
+	DUMP_REG(HDMI_NV_PDISP_HDMI_HDCPRIF_ROM_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CAP);
+	DUMP_REG(HDMI_NV_PDISP_SOR_PWR);
+	DUMP_REG(HDMI_NV_PDISP_SOR_TEST);
+	DUMP_REG(HDMI_NV_PDISP_SOR_PLL0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_PLL1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_PLL2);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CSTM);
+	DUMP_REG(HDMI_NV_PDISP_SOR_LVDS);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CRCA);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CRCB);
+	DUMP_REG(HDMI_NV_PDISP_SOR_BLANK);
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_CTL);
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(0));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(1));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(2));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(3));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(4));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(5));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(6));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(7));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(8));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(9));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(10));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(11));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(12));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(13));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(14));
+	DUMP_REG(HDMI_NV_PDISP_SOR_SEQ_INST(15));
+	DUMP_REG(HDMI_NV_PDISP_SOR_VCRCA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_VCRCA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CCRCA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_CCRCA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_EDATAA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_EDATAA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_COUNTA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_COUNTA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_DEBUGA0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_DEBUGA1);
+	DUMP_REG(HDMI_NV_PDISP_SOR_TRIG);
+	DUMP_REG(HDMI_NV_PDISP_SOR_MSCHECK);
+	DUMP_REG(HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG0);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG1);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_DEBUG2);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(0));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(1));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(2));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(3));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(4));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(5));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_FS(6));
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_PULSE_WIDTH);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_THRESHOLD);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_CNTRL0);
+	DUMP_REG(HDMI_NV_PDISP_AUDIO_N);
+	DUMP_REG(HDMI_NV_PDISP_HDCPRIF_ROM_TIMING);
+	DUMP_REG(HDMI_NV_PDISP_SOR_REFCLK);
+	DUMP_REG(HDMI_NV_PDISP_CRC_CONTROL);
+	DUMP_REG(HDMI_NV_PDISP_INPUT_CONTROL);
+	DUMP_REG(HDMI_NV_PDISP_SCRATCH);
+	DUMP_REG(HDMI_NV_PDISP_PE_CURRENT);
+	DUMP_REG(HDMI_NV_PDISP_KEY_CTRL);
+	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG0);
+	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG1);
+	DUMP_REG(HDMI_NV_PDISP_KEY_DEBUG2);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_0);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_1);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_2);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_3);
+	DUMP_REG(HDMI_NV_PDISP_KEY_HDCP_KEY_TRIG);
+	DUMP_REG(HDMI_NV_PDISP_KEY_SKEY_INDEX);
+	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_CNTRL0);
+	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_HDA_ELD_BUFWR);
+	DUMP_REG(HDMI_NV_PDISP_SOR_AUDIO_HDA_PRESENSE);
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
+static int tegra_hdmi_debugfs_init(struct tegra_hdmi *hdmi,
+				   struct dentry *parent)
+{
+	hdmi->debugfs = debugfs_create_dir("hdmi", parent);
+	debugfs_create_file("regs", 0400, hdmi->debugfs, hdmi, &regs_fops);
+
+	return 0;
+}
+
+static int tegra_hdmi_debugfs_exit(struct tegra_hdmi *hdmi)
+{
+	debugfs_remove_recursive(hdmi->debugfs);
+
+	return 0;
+}
+
+static int tegra_hdmi_drm_init(struct host1x_client *client,
+			       struct drm_device *drm)
+{
+	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
+	int err;
+
+	hdmi->output.type = TEGRA_OUTPUT_HDMI;
+	hdmi->output.dev = client->dev;
+	hdmi->output.ops = &hdmi_ops;
+
+	err = tegra_output_init(drm, &hdmi->output);
+	if (err < 0) {
+		dev_err(client->dev, "output setup failed: %d\n", err);
+		return err;
+	}
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_hdmi_debugfs_init(hdmi, drm->primary->debugfs_root);
+		if (err < 0)
+			dev_err(client->dev, "debugfs setup failed: %d\n", err);
+	}
+
+	return 0;
+}
+
+static int tegra_hdmi_drm_exit(struct host1x_client *client)
+{
+	struct tegra_hdmi *hdmi = host1x_client_to_hdmi(client);
+	int err;
+
+	if (IS_ENABLED(CONFIG_DEBUG_FS)) {
+		err = tegra_hdmi_debugfs_exit(hdmi);
+		if (err < 0)
+			dev_err(client->dev, "debugfs cleanup failed: %d\n",
+				err);
+	}
+
+	err = tegra_output_exit(&hdmi->output);
+	if (err < 0) {
+		dev_err(client->dev, "output cleanup failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static const struct host1x_client_ops hdmi_client_ops = {
+	.drm_init = tegra_hdmi_drm_init,
+	.drm_exit = tegra_hdmi_drm_exit,
+};
+
+static int tegra_hdmi_probe(struct platform_device *pdev)
+{
+	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct tegra_hdmi *hdmi;
+	struct resource *regs;
+	int err;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	hdmi->dev = &pdev->dev;
+	hdmi->audio_source = AUTO;
+	hdmi->audio_freq = 44100;
+	hdmi->stereo = false;
+	hdmi->dvi = false;
+
+	hdmi->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR_OR_NULL(hdmi->clk))
+		return PTR_ERR(hdmi->clk);
+
+	err = clk_prepare(hdmi->clk);
+	if (err < 0)
+		return err;
+
+	hdmi->clk_parent = devm_clk_get(&pdev->dev, "parent");
+	if (IS_ERR_OR_NULL(hdmi->clk_parent))
+		return PTR_ERR(hdmi->clk_parent);
+
+	err = clk_prepare(hdmi->clk_parent);
+	if (err < 0)
+		return err;
+
+	err = clk_set_parent(hdmi->clk, hdmi->clk_parent);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to setup clocks: %d\n", err);
+		return err;
+	}
+
+	hdmi->vdd = devm_regulator_get(&pdev->dev, "vdd");
+	if (IS_ERR_OR_NULL(hdmi->vdd)) {
+		err = PTR_ERR(hdmi->vdd);
+		dev_err(&pdev->dev, "failed to get VDD regulator: %d\n", err);
+		return err;
+	}
+
+	hdmi->pll = devm_regulator_get(&pdev->dev, "pll");
+	if (IS_ERR_OR_NULL(hdmi->pll)) {
+		err = PTR_ERR(hdmi->pll);
+		dev_err(&pdev->dev, "failed to get PLL regulator: %d\n", err);
+		return err;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+
+	hdmi->regs = devm_request_and_ioremap(&pdev->dev, regs);
+	if (!hdmi->regs)
+		return -EADDRNOTAVAIL;
+
+	err = platform_get_irq(pdev, 0);
+	if (err < 0)
+		return err;
+
+	hdmi->irq = err;
+
+	hdmi->client.ops = &hdmi_client_ops;
+	INIT_LIST_HEAD(&hdmi->client.list);
+	hdmi->client.dev = &pdev->dev;
+
+	err = host1x_register_client(host1x, &hdmi->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to register host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	platform_set_drvdata(pdev, hdmi);
+
+	return 0;
+}
+
+static int tegra_hdmi_remove(struct platform_device *pdev)
+{
+	struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
+	struct tegra_hdmi *hdmi = platform_get_drvdata(pdev);
+	int err;
+
+	err = host1x_unregister_client(host1x, &hdmi->client);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
+			err);
+		return err;
+	}
+
+	clk_unprepare(hdmi->clk_parent);
+	clk_unprepare(hdmi->clk);
+
+	return 0;
+}
+
+static struct of_device_id tegra_hdmi_of_match[] = {
+	{ .compatible = "nvidia,tegra20-hdmi", },
+	{ .compatible = "nvidia,tegra30-hdmi", },
+	{ },
+};
+
+struct platform_driver tegra_hdmi_driver = {
+	.driver = {
+		.name = "tegra-hdmi",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_hdmi_of_match,
+	},
+	.probe = tegra_hdmi_probe,
+	.remove = tegra_hdmi_remove,
+};
diff --git a/drivers/gpu/drm/tegra/hdmi.h b/drivers/gpu/drm/tegra/hdmi.h
new file mode 100644
index 0000000..1477f36
--- /dev/null
+++ b/drivers/gpu/drm/tegra/hdmi.h
@@ -0,0 +1,575 @@
+/*
+ * Copyright (C) 2012 Avionic Design GmbH
+ * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef TEGRA_HDMI_H
+#define TEGRA_HDMI_H 1
+
+#define HDMI_INFOFRAME_TYPE_VENDOR   0x81
+#define HDMI_INFOFRAME_TYPE_AVI      0x82
+#define HDMI_INFOFRAME_TYPE_SPD      0x83
+#define HDMI_INFOFRAME_TYPE_AUDIO    0x84
+#define HDMI_INFOFRAME_TYPE_MPEG_SRC 0x85
+#define HDMI_INFOFRAME_TYPE_NTSC_VBI 0x86
+
+/* all fields little endian */
+struct hdmi_avi_infoframe {
+	/* PB0 */
+	u8 csum;
+
+	/* PB1 */
+	unsigned s:2; /* scan information */
+	unsigned b:2; /* bar info data valid */
+	unsigned a:1; /* active info present */
+	unsigned y:2; /* RGB or YCbCr */
+	unsigned res1:1;
+
+	/* PB2 */
+	unsigned r:4; /* active format aspect ratio */
+	unsigned m:2; /* picture aspect ratio */
+	unsigned c:2; /* colorimetry */
+
+	/* PB3 */
+	unsigned sc:2;  /* scan information */
+	unsigned q:2;   /* quantization range */
+	unsigned ec:3;  /* extended colorimetry */
+	unsigned itc:1; /* it content */
+
+	/* PB4 */
+	unsigned vic:7; /* video format id code */
+	unsigned res4:1;
+
+	/* PB5 */
+	unsigned pr:4; /* pixel repetition factor */
+	unsigned cn:2; /* it content type*/
+	unsigned yq:2; /* ycc quantization range */
+
+	/* PB6-7 */
+	u16 top_bar_end_line;
+
+	/* PB8-9 */
+	u16 bot_bar_start_line;
+
+	/* PB10-11 */
+	u16 left_bar_end_pixel;
+
+	/* PB12-13 */
+	u16 right_bar_start_pixel;
+} __packed;
+
+#define HDMI_AVI_VERSION 0x02
+
+#define HDMI_AVI_Y_RGB       0x0
+#define HDMI_AVI_Y_YCBCR_422 0x1
+#define HDMI_AVI_Y_YCBCR_444 0x2
+
+#define HDMI_AVI_B_VERT  0x1
+#define HDMI_AVI_B_HORIZ 0x2
+
+#define HDMI_AVI_S_NONE      0x0
+#define HDMI_AVI_S_OVERSCAN  0x1
+#define HDMI_AVI_S_UNDERSCAN 0x2
+
+#define HDMI_AVI_C_NONE     0x0
+#define HDMI_AVI_C_SMPTE    0x1
+#define HDMI_AVI_C_ITU_R    0x2
+#define HDMI_AVI_C_EXTENDED 0x4
+
+#define HDMI_AVI_M_4_3  0x1
+#define HDMI_AVI_M_16_9 0x2
+
+#define HDMI_AVI_R_SAME        0x8
+#define HDMI_AVI_R_4_3_CENTER  0x9
+#define HDMI_AVI_R_16_9_CENTER 0xa
+#define HDMI_AVI_R_14_9_CENTER 0xb
+
+/* all fields little endian */
+struct hdmi_audio_infoframe {
+	/* PB0 */
+	u8 csum;
+
+	/* PB1 */
+	unsigned cc:3; /* channel count */
+	unsigned res1:1;
+	unsigned ct:4; /* coding type */
+
+	/* PB2 */
+	unsigned ss:2; /* sample size */
+	unsigned sf:3; /* sample frequency */
+	unsigned res2:3;
+
+	/* PB3 */
+	unsigned cxt:5; /* coding extention type */
+	unsigned res3:3;
+
+	/* PB4 */
+	u8 ca; /* channel/speaker allocation */
+
+	/* PB5 */
+	unsigned res5:3;
+	unsigned lsv:4; /* level shift value */
+	unsigned dm_inh:1; /* downmix inhibit */
+
+	/* PB6-10 reserved */
+	u8 res6;
+	u8 res7;
+	u8 res8;
+	u8 res9;
+	u8 res10;
+} __packed;
+
+#define HDMI_AUDIO_VERSION 0x01
+
+#define HDMI_AUDIO_CC_STREAM 0x0 /* specified by audio stream */
+#define HDMI_AUDIO_CC_2      0x1
+#define HDMI_AUDIO_CC_3      0x2
+#define HDMI_AUDIO_CC_4      0x3
+#define HDMI_AUDIO_CC_5      0x4
+#define HDMI_AUDIO_CC_6      0x5
+#define HDMI_AUDIO_CC_7      0x6
+#define HDMI_AUDIO_CC_8      0x7
+
+#define HDMI_AUDIO_CT_STREAM  0x0 /* specified by audio stream */
+#define HDMI_AUDIO_CT_PCM     0x1
+#define HDMI_AUDIO_CT_AC3     0x2
+#define HDMI_AUDIO_CT_MPEG1   0x3
+#define HDMI_AUDIO_CT_MP3     0x4
+#define HDMI_AUDIO_CT_MPEG2   0x5
+#define HDMI_AUDIO_CT_AAC_LC  0x6
+#define HDMI_AUDIO_CT_DTS     0x7
+#define HDMI_AUDIO_CT_ATRAC   0x8
+#define HDMI_AUDIO_CT_DSD     0x9
+#define HDMI_AUDIO_CT_E_AC3   0xa
+#define HDMI_AUDIO_CT_DTS_HD  0xb
+#define HDMI_AUDIO_CT_MLP     0xc
+#define HDMI_AUDIO_CT_DST     0xd
+#define HDMI_AUDIO_CT_WMA_PRO 0xe
+#define HDMI_AUDIO_CT_CXT     0xf
+
+#define HDMI_AUDIO_SF_STREAM 0x0 /* specified by audio stream */
+#define HDMI_AUIDO_SF_32K    0x1
+#define HDMI_AUDIO_SF_44_1K  0x2
+#define HDMI_AUDIO_SF_48K    0x3
+#define HDMI_AUDIO_SF_88_2K  0x4
+#define HDMI_AUDIO_SF_96K    0x5
+#define HDMI_AUDIO_SF_176_4K 0x6
+#define HDMI_AUDIO_SF_192K   0x7
+
+#define HDMI_AUDIO_SS_STREAM 0x0 /* specified by audio stream */
+#define HDMI_AUDIO_SS_16BIT  0x1
+#define HDMI_AUDIO_SS_20BIT  0x2
+#define HDMI_AUDIO_SS_24BIT  0x3
+
+#define HDMI_AUDIO_CXT_CT            0x0 /* refer to coding in CT */
+#define HDMI_AUDIO_CXT_HE_AAC        0x1
+#define HDMI_AUDIO_CXT_HE_AAC_V2     0x2
+#define HDMI_AUDIO_CXT_MPEG_SURROUND 0x3
+
+/* all fields little endian */
+struct hdmi_stereo_infoframe {
+	/* PB0 */
+	u8 csum;
+
+	/* PB1 */
+	u8 regid0;
+
+	/* PB2 */
+	u8 regid1;
+
+	/* PB3 */
+	u8 regid2;
+
+	/* PB4 */
+	unsigned res1:5;
+	unsigned hdmi_video_format:3;
+
+	/* PB5 */
+	unsigned res2:4;
+	unsigned _3d_structure:4;
+
+	/* PB6*/
+	unsigned res3:4;
+	unsigned _3d_ext_data:4;
+} __packed;
+
+#define HDMI_VENDOR_VERSION 0x01
+
+/* register definitions */
+#define HDMI_CTXSW						0x00
+
+#define HDMI_NV_PDISP_SOR_STATE0				0x01
+#define SOR_STATE_UPDATE (1 << 0)
+
+#define HDMI_NV_PDISP_SOR_STATE1				0x02
+#define SOR_STATE_ASY_HEAD_OPMODE_AWAKE (2 << 0)
+#define SOR_STATE_ASY_ORMODE_NORMAL     (1 << 2)
+#define SOR_STATE_ATTACHED              (1 << 3)
+
+#define HDMI_NV_PDISP_SOR_STATE2				0x03
+#define SOR_STATE_ASY_OWNER_NONE         (0 <<  0)
+#define SOR_STATE_ASY_OWNER_HEAD0        (1 <<  0)
+#define SOR_STATE_ASY_SUBOWNER_NONE      (0 <<  4)
+#define SOR_STATE_ASY_SUBOWNER_SUBHEAD0  (1 <<  4)
+#define SOR_STATE_ASY_SUBOWNER_SUBHEAD1  (2 <<  4)
+#define SOR_STATE_ASY_SUBOWNER_BOTH      (3 <<  4)
+#define SOR_STATE_ASY_CRCMODE_ACTIVE     (0 <<  6)
+#define SOR_STATE_ASY_CRCMODE_COMPLETE   (1 <<  6)
+#define SOR_STATE_ASY_CRCMODE_NON_ACTIVE (2 <<  6)
+#define SOR_STATE_ASY_PROTOCOL_SINGLE_TMDS_A (1 << 8)
+#define SOR_STATE_ASY_PROTOCOL_CUSTOM        (15 << 8)
+#define SOR_STATE_ASY_HSYNCPOL_POS       (0 << 12)
+#define SOR_STATE_ASY_HSYNCPOL_NEG       (1 << 12)
+#define SOR_STATE_ASY_VSYNCPOL_POS       (0 << 13)
+#define SOR_STATE_ASY_VSYNCPOL_NEG       (1 << 13)
+#define SOR_STATE_ASY_DEPOL_POS          (0 << 14)
+#define SOR_STATE_ASY_DEPOL_NEG          (1 << 14)
+
+#define HDMI_NV_PDISP_RG_HDCP_AN_MSB				0x04
+#define HDMI_NV_PDISP_RG_HDCP_AN_LSB				0x05
+#define HDMI_NV_PDISP_RG_HDCP_CN_MSB				0x06
+#define HDMI_NV_PDISP_RG_HDCP_CN_LSB				0x07
+#define HDMI_NV_PDISP_RG_HDCP_AKSV_MSB				0x08
+#define HDMI_NV_PDISP_RG_HDCP_AKSV_LSB				0x09
+#define HDMI_NV_PDISP_RG_HDCP_BKSV_MSB				0x0a
+#define HDMI_NV_PDISP_RG_HDCP_BKSV_LSB				0x0b
+#define HDMI_NV_PDISP_RG_HDCP_CKSV_MSB				0x0c
+#define HDMI_NV_PDISP_RG_HDCP_CKSV_LSB				0x0d
+#define HDMI_NV_PDISP_RG_HDCP_DKSV_MSB				0x0e
+#define HDMI_NV_PDISP_RG_HDCP_DKSV_LSB				0x0f
+#define HDMI_NV_PDISP_RG_HDCP_CTRL				0x10
+#define HDMI_NV_PDISP_RG_HDCP_CMODE				0x11
+#define HDMI_NV_PDISP_RG_HDCP_MPRIME_MSB			0x12
+#define HDMI_NV_PDISP_RG_HDCP_MPRIME_LSB			0x13
+#define HDMI_NV_PDISP_RG_HDCP_SPRIME_MSB			0x14
+#define HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB2			0x15
+#define HDMI_NV_PDISP_RG_HDCP_SPRIME_LSB1			0x16
+#define HDMI_NV_PDISP_RG_HDCP_RI				0x17
+#define HDMI_NV_PDISP_RG_HDCP_CS_MSB				0x18
+#define HDMI_NV_PDISP_RG_HDCP_CS_LSB				0x19
+#define HDMI_NV_PDISP_HDMI_AUDIO_EMU0				0x1a
+#define HDMI_NV_PDISP_HDMI_AUDIO_EMU_RDATA0			0x1b
+#define HDMI_NV_PDISP_HDMI_AUDIO_EMU1				0x1c
+#define HDMI_NV_PDISP_HDMI_AUDIO_EMU2				0x1d
+
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_CTRL			0x1e
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_STATUS		0x1f
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_HEADER		0x20
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_LOW		0x21
+#define HDMI_NV_PDISP_HDMI_AUDIO_INFOFRAME_SUBPACK0_HIGH	0x22
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_CTRL			0x23
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_STATUS			0x24
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_HEADER			0x25
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_LOW		0x26
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK0_HIGH		0x27
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_LOW		0x28
+#define HDMI_NV_PDISP_HDMI_AVI_INFOFRAME_SUBPACK1_HIGH		0x29
+
+#define INFOFRAME_CTRL_ENABLE (1 << 0)
+
+#define INFOFRAME_HEADER_TYPE(x)    (((x) & 0xff) <<  0)
+#define INFOFRAME_HEADER_VERSION(x) (((x) & 0xff) <<  8)
+#define INFOFRAME_HEADER_LEN(x)     (((x) & 0x0f) << 16)
+
+#define HDMI_NV_PDISP_HDMI_GENERIC_CTRL				0x2a
+#define GENERIC_CTRL_ENABLE (1 <<  0)
+#define GENERIC_CTRL_OTHER  (1 <<  4)
+#define GENERIC_CTRL_SINGLE (1 <<  8)
+#define GENERIC_CTRL_HBLANK (1 << 12)
+#define GENERIC_CTRL_AUDIO  (1 << 16)
+
+#define HDMI_NV_PDISP_HDMI_GENERIC_STATUS			0x2b
+#define HDMI_NV_PDISP_HDMI_GENERIC_HEADER			0x2c
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_LOW			0x2d
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK0_HIGH		0x2e
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_LOW			0x2f
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK1_HIGH		0x30
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_LOW			0x31
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK2_HIGH		0x32
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_LOW			0x33
+#define HDMI_NV_PDISP_HDMI_GENERIC_SUBPACK3_HIGH		0x34
+
+#define HDMI_NV_PDISP_HDMI_ACR_CTRL				0x35
+#define HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_LOW			0x36
+#define HDMI_NV_PDISP_HDMI_ACR_0320_SUBPACK_HIGH		0x37
+#define HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_LOW			0x38
+#define HDMI_NV_PDISP_HDMI_ACR_0441_SUBPACK_HIGH		0x39
+#define HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_LOW			0x3a
+#define HDMI_NV_PDISP_HDMI_ACR_0882_SUBPACK_HIGH		0x3b
+#define HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_LOW			0x3c
+#define HDMI_NV_PDISP_HDMI_ACR_1764_SUBPACK_HIGH		0x3d
+#define HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_LOW			0x3e
+#define HDMI_NV_PDISP_HDMI_ACR_0480_SUBPACK_HIGH		0x3f
+#define HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_LOW			0x40
+#define HDMI_NV_PDISP_HDMI_ACR_0960_SUBPACK_HIGH		0x41
+#define HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_LOW			0x42
+#define HDMI_NV_PDISP_HDMI_ACR_1920_SUBPACK_HIGH		0x43
+
+#define ACR_SUBPACK_CTS(x) (((x) & 0xffffff) << 8)
+#define ACR_SUBPACK_N(x)   (((x) & 0xffffff) << 0)
+#define ACR_ENABLE         (1 << 31)
+
+#define HDMI_NV_PDISP_HDMI_CTRL					0x44
+#define HDMI_CTRL_REKEY(x)         (((x) & 0x7f) <<  0)
+#define HDMI_CTRL_MAX_AC_PACKET(x) (((x) & 0x1f) << 16)
+#define HDMI_CTRL_ENABLE           (1 << 30)
+
+#define HDMI_NV_PDISP_HDMI_VSYNC_KEEPOUT			0x45
+#define HDMI_NV_PDISP_HDMI_VSYNC_WINDOW				0x46
+#define VSYNC_WINDOW_END(x)   (((x) & 0x3ff) <<  0)
+#define VSYNC_WINDOW_START(x) (((x) & 0x3ff) << 16)
+#define VSYNC_WINDOW_ENABLE   (1 << 31)
+
+#define HDMI_NV_PDISP_HDMI_GCP_CTRL				0x47
+#define HDMI_NV_PDISP_HDMI_GCP_STATUS				0x48
+#define HDMI_NV_PDISP_HDMI_GCP_SUBPACK				0x49
+#define HDMI_NV_PDISP_HDMI_CHANNEL_STATUS1			0x4a
+#define HDMI_NV_PDISP_HDMI_CHANNEL_STATUS2			0x4b
+#define HDMI_NV_PDISP_HDMI_EMU0					0x4c
+#define HDMI_NV_PDISP_HDMI_EMU1					0x4d
+#define HDMI_NV_PDISP_HDMI_EMU1_RDATA				0x4e
+
+#define HDMI_NV_PDISP_HDMI_SPARE				0x4f
+#define SPARE_HW_CTS           (1 << 0)
+#define SPARE_FORCE_SW_CTS     (1 << 1)
+#define SPARE_CTS_RESET_VAL(x) (((x) & 0x7) << 16)
+
+#define HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS1			0x50
+#define HDMI_NV_PDISP_HDMI_SPDIF_CHN_STATUS2			0x51
+#define HDMI_NV_PDISP_HDMI_HDCPRIF_ROM_CTRL			0x53
+#define HDMI_NV_PDISP_SOR_CAP					0x54
+#define HDMI_NV_PDISP_SOR_PWR					0x55
+#define SOR_PWR_NORMAL_STATE_PD     (0 <<  0)
+#define SOR_PWR_NORMAL_STATE_PU     (1 <<  0)
+#define SOR_PWR_NORMAL_START_NORMAL (0 <<  1)
+#define SOR_PWR_NORMAL_START_ALT    (1 <<  1)
+#define SOR_PWR_SAFE_STATE_PD       (0 << 16)
+#define SOR_PWR_SAFE_STATE_PU       (1 << 16)
+#define SOR_PWR_SETTING_NEW_DONE    (0 << 31)
+#define SOR_PWR_SETTING_NEW_PENDING (1 << 31)
+#define SOR_PWR_SETTING_NEW_TRIGGER (1 << 31)
+
+#define HDMI_NV_PDISP_SOR_TEST					0x56
+#define HDMI_NV_PDISP_SOR_PLL0					0x57
+#define SOR_PLL_PWR            (1 << 0)
+#define SOR_PLL_PDBG           (1 << 1)
+#define SOR_PLL_VCAPD          (1 << 2)
+#define SOR_PLL_PDPORT         (1 << 3)
+#define SOR_PLL_RESISTORSEL    (1 << 4)
+#define SOR_PLL_PULLDOWN       (1 << 5)
+#define SOR_PLL_VCOCAP(x)      (((x) & 0xf) <<  8)
+#define SOR_PLL_BG_V17_S(x)    (((x) & 0xf) << 12)
+#define SOR_PLL_FILTER(x)      (((x) & 0xf) << 16)
+#define SOR_PLL_ICHPMP(x)      (((x) & 0xf) << 24)
+#define SOR_PLL_TX_REG_LOAD(x) (((x) & 0xf) << 28)
+
+#define HDMI_NV_PDISP_SOR_PLL1					0x58
+#define SOR_PLL_TMDS_TERM_ENABLE (1 << 8)
+#define SOR_PLL_TMDS_TERMADJ(x)  (((x) & 0xf) <<  9)
+#define SOR_PLL_LOADADJ(x)       (((x) & 0xf) << 20)
+#define SOR_PLL_PE_EN            (1 << 28)
+#define SOR_PLL_HALF_FULL_PE     (1 << 29)
+#define SOR_PLL_S_D_PIN_PE       (1 << 30)
+
+#define HDMI_NV_PDISP_SOR_PLL2					0x59
+
+#define HDMI_NV_PDISP_SOR_CSTM					0x5a
+#define SOR_CSTM_ROTCLK(x) (((x) & 0xf) << 24)
+
+#define HDMI_NV_PDISP_SOR_LVDS					0x5b
+#define HDMI_NV_PDISP_SOR_CRCA					0x5c
+#define HDMI_NV_PDISP_SOR_CRCB					0x5d
+#define HDMI_NV_PDISP_SOR_BLANK					0x5e
+#define HDMI_NV_PDISP_SOR_SEQ_CTL				0x5f
+#define SOR_SEQ_CTL_PU_PC(x) (((x) & 0xf) <<  0)
+#define SOR_SEQ_PU_PC_ALT(x) (((x) & 0xf) <<  4)
+#define SOR_SEQ_PD_PC(x)     (((x) & 0xf) <<  8)
+#define SOR_SEQ_PD_PC_ALT(x) (((x) & 0xf) << 12)
+#define SOR_SEQ_PC(x)        (((x) & 0xf) << 16)
+#define SOR_SEQ_STATUS       (1 << 28)
+#define SOR_SEQ_SWITCH       (1 << 30)
+
+#define HDMI_NV_PDISP_SOR_SEQ_INST(x)				(0x60 + (x))
+
+#define SOR_SEQ_INST_WAIT_TIME(x)     (((x) & 0x3ff) << 0)
+#define SOR_SEQ_INST_WAIT_UNITS_VSYNC (2 << 12)
+#define SOR_SEQ_INST_HALT             (1 << 15)
+#define SOR_SEQ_INST_PIN_A_LOW        (0 << 21)
+#define SOR_SEQ_INST_PIN_A_HIGH       (1 << 21)
+#define SOR_SEQ_INST_PIN_B_LOW        (0 << 22)
+#define SOR_SEQ_INST_PIN_B_HIGH       (1 << 22)
+#define SOR_SEQ_INST_DRIVE_PWM_OUT_LO (1 << 23)
+
+#define HDMI_NV_PDISP_SOR_VCRCA0				0x72
+#define HDMI_NV_PDISP_SOR_VCRCA1				0x73
+#define HDMI_NV_PDISP_SOR_CCRCA0				0x74
+#define HDMI_NV_PDISP_SOR_CCRCA1				0x75
+#define HDMI_NV_PDISP_SOR_EDATAA0				0x76
+#define HDMI_NV_PDISP_SOR_EDATAA1				0x77
+#define HDMI_NV_PDISP_SOR_COUNTA0				0x78
+#define HDMI_NV_PDISP_SOR_COUNTA1				0x79
+#define HDMI_NV_PDISP_SOR_DEBUGA0				0x7a
+#define HDMI_NV_PDISP_SOR_DEBUGA1				0x7b
+#define HDMI_NV_PDISP_SOR_TRIG					0x7c
+#define HDMI_NV_PDISP_SOR_MSCHECK				0x7d
+
+#define HDMI_NV_PDISP_SOR_LANE_DRIVE_CURRENT			0x7e
+#define DRIVE_CURRENT_LANE0(x)      (((x) & 0x3f) <<  0)
+#define DRIVE_CURRENT_LANE1(x)      (((x) & 0x3f) <<  8)
+#define DRIVE_CURRENT_LANE2(x)      (((x) & 0x3f) << 16)
+#define DRIVE_CURRENT_LANE3(x)      (((x) & 0x3f) << 24)
+#define DRIVE_CURRENT_FUSE_OVERRIDE (1 << 31)
+
+#define DRIVE_CURRENT_1_500_mA  0x00
+#define DRIVE_CURRENT_1_875_mA  0x01
+#define DRIVE_CURRENT_2_250_mA  0x02
+#define DRIVE_CURRENT_2_625_mA  0x03
+#define DRIVE_CURRENT_3_000_mA  0x04
+#define DRIVE_CURRENT_3_375_mA  0x05
+#define DRIVE_CURRENT_3_750_mA  0x06
+#define DRIVE_CURRENT_4_125_mA  0x07
+#define DRIVE_CURRENT_4_500_mA  0x08
+#define DRIVE_CURRENT_4_875_mA  0x09
+#define DRIVE_CURRENT_5_250_mA  0x0a
+#define DRIVE_CURRENT_5_625_mA  0x0b
+#define DRIVE_CURRENT_6_000_mA  0x0c
+#define DRIVE_CURRENT_6_375_mA  0x0d
+#define DRIVE_CURRENT_6_750_mA  0x0e
+#define DRIVE_CURRENT_7_125_mA  0x0f
+#define DRIVE_CURRENT_7_500_mA  0x10
+#define DRIVE_CURRENT_7_875_mA  0x11
+#define DRIVE_CURRENT_8_250_mA  0x12
+#define DRIVE_CURRENT_8_625_mA  0x13
+#define DRIVE_CURRENT_9_000_mA  0x14
+#define DRIVE_CURRENT_9_375_mA  0x15
+#define DRIVE_CURRENT_9_750_mA  0x16
+#define DRIVE_CURRENT_10_125_mA 0x17
+#define DRIVE_CURRENT_10_500_mA 0x18
+#define DRIVE_CURRENT_10_875_mA 0x19
+#define DRIVE_CURRENT_11_250_mA 0x1a
+#define DRIVE_CURRENT_11_625_mA 0x1b
+#define DRIVE_CURRENT_12_000_mA 0x1c
+#define DRIVE_CURRENT_12_375_mA 0x1d
+#define DRIVE_CURRENT_12_750_mA 0x1e
+#define DRIVE_CURRENT_13_125_mA 0x1f
+#define DRIVE_CURRENT_13_500_mA 0x20
+#define DRIVE_CURRENT_13_875_mA 0x21
+#define DRIVE_CURRENT_14_250_mA 0x22
+#define DRIVE_CURRENT_14_625_mA 0x23
+#define DRIVE_CURRENT_15_000_mA 0x24
+#define DRIVE_CURRENT_15_375_mA 0x25
+#define DRIVE_CURRENT_15_750_mA 0x26
+#define DRIVE_CURRENT_16_125_mA 0x27
+#define DRIVE_CURRENT_16_500_mA 0x28
+#define DRIVE_CURRENT_16_875_mA 0x29
+#define DRIVE_CURRENT_17_250_mA 0x2a
+#define DRIVE_CURRENT_17_625_mA 0x2b
+#define DRIVE_CURRENT_18_000_mA 0x2c
+#define DRIVE_CURRENT_18_375_mA 0x2d
+#define DRIVE_CURRENT_18_750_mA 0x2e
+#define DRIVE_CURRENT_19_125_mA 0x2f
+#define DRIVE_CURRENT_19_500_mA 0x30
+#define DRIVE_CURRENT_19_875_mA 0x31
+#define DRIVE_CURRENT_20_250_mA 0x32
+#define DRIVE_CURRENT_20_625_mA 0x33
+#define DRIVE_CURRENT_21_000_mA 0x34
+#define DRIVE_CURRENT_21_375_mA 0x35
+#define DRIVE_CURRENT_21_750_mA 0x36
+#define DRIVE_CURRENT_22_125_mA 0x37
+#define DRIVE_CURRENT_22_500_mA 0x38
+#define DRIVE_CURRENT_22_875_mA 0x39
+#define DRIVE_CURRENT_23_250_mA 0x3a
+#define DRIVE_CURRENT_23_625_mA 0x3b
+#define DRIVE_CURRENT_24_000_mA 0x3c
+#define DRIVE_CURRENT_24_375_mA 0x3d
+#define DRIVE_CURRENT_24_750_mA 0x3e
+
+#define HDMI_NV_PDISP_AUDIO_DEBUG0				0x7f
+#define HDMI_NV_PDISP_AUDIO_DEBUG1				0x80
+#define HDMI_NV_PDISP_AUDIO_DEBUG2				0x81
+
+#define HDMI_NV_PDISP_AUDIO_FS(x)				(0x82 + (x))
+#define AUDIO_FS_LOW(x)  (((x) & 0xfff) <<  0)
+#define AUDIO_FS_HIGH(x) (((x) & 0xfff) << 16)
+
+#define HDMI_NV_PDISP_AUDIO_PULSE_WIDTH				0x89
+#define HDMI_NV_PDISP_AUDIO_THRESHOLD				0x8a
+#define HDMI_NV_PDISP_AUDIO_CNTRL0				0x8b
+#define AUDIO_CNTRL0_ERROR_TOLERANCE(x)  (((x) & 0xff) << 0)
+#define AUDIO_CNTRL0_SOURCE_SELECT_AUTO  (0 << 20)
+#define AUDIO_CNTRL0_SOURCE_SELECT_SPDIF (1 << 20)
+#define AUDIO_CNTRL0_SOURCE_SELECT_HDAL  (2 << 20)
+#define AUDIO_CNTRL0_FRAMES_PER_BLOCK(x) (((x) & 0xff) << 24)
+
+#define HDMI_NV_PDISP_AUDIO_N					0x8c
+#define AUDIO_N_VALUE(x)           (((x) & 0xfffff) << 0)
+#define AUDIO_N_RESETF             (1 << 20)
+#define AUDIO_N_GENERATE_NORMAL    (0 << 24)
+#define AUDIO_N_GENERATE_ALTERNATE (1 << 24)
+
+#define HDMI_NV_PDISP_HDCPRIF_ROM_TIMING			0x94
+#define HDMI_NV_PDISP_SOR_REFCLK				0x95
+#define SOR_REFCLK_DIV_INT(x)  (((x) & 0xff) << 8)
+#define SOR_REFCLK_DIV_FRAC(x) (((x) & 0x03) << 6)
+
+#define HDMI_NV_PDISP_CRC_CONTROL				0x96
+#define HDMI_NV_PDISP_INPUT_CONTROL				0x97
+#define HDMI_SRC_DISPLAYA       (0 << 0)
+#define HDMI_SRC_DISPLAYB       (1 << 0)
+#define ARM_VIDEO_RANGE_FULL    (0 << 1)
+#define ARM_VIDEO_RANGE_LIMITED (1 << 1)
+
+#define HDMI_NV_PDISP_SCRATCH					0x98
+#define HDMI_NV_PDISP_PE_CURRENT				0x99
+#define PE_CURRENT0(x) (((x) & 0xf) << 0)
+#define PE_CURRENT1(x) (((x) & 0xf) << 8)
+#define PE_CURRENT2(x) (((x) & 0xf) << 16)
+#define PE_CURRENT3(x) (((x) & 0xf) << 24)
+
+#define PE_CURRENT_0_0_mA 0x0
+#define PE_CURRENT_0_5_mA 0x1
+#define PE_CURRENT_1_0_mA 0x2
+#define PE_CURRENT_1_5_mA 0x3
+#define PE_CURRENT_2_0_mA 0x4
+#define PE_CURRENT_2_5_mA 0x5
+#define PE_CURRENT_3_0_mA 0x6
+#define PE_CURRENT_3_5_mA 0x7
+#define PE_CURRENT_4_0_mA 0x8
+#define PE_CURRENT_4_5_mA 0x9
+#define PE_CURRENT_5_0_mA 0xa
+#define PE_CURRENT_5_5_mA 0xb
+#define PE_CURRENT_6_0_mA 0xc
+#define PE_CURRENT_6_5_mA 0xd
+#define PE_CURRENT_7_0_mA 0xe
+#define PE_CURRENT_7_5_mA 0xf
+
+#define HDMI_NV_PDISP_KEY_CTRL					0x9a
+#define HDMI_NV_PDISP_KEY_DEBUG0				0x9b
+#define HDMI_NV_PDISP_KEY_DEBUG1				0x9c
+#define HDMI_NV_PDISP_KEY_DEBUG2				0x9d
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_0				0x9e
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_1				0x9f
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_2				0xa0
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_3				0xa1
+#define HDMI_NV_PDISP_KEY_HDCP_KEY_TRIG				0xa2
+#define HDMI_NV_PDISP_KEY_SKEY_INDEX				0xa3
+
+#define HDMI_NV_PDISP_SOR_AUDIO_CNTRL0				0xac
+#define AUDIO_CNTRL0_INJECT_NULLSMPL (1 << 29)
+#define HDMI_NV_PDISP_SOR_AUDIO_HDA_ELD_BUFWR			0xbc
+#define HDMI_NV_PDISP_SOR_AUDIO_HDA_PRESENSE			0xbd
+
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0320    0xbf
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0441    0xc0
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0882    0xc1
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_1764    0xc2
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0480    0xc3
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_0960    0xc4
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_1920    0xc5
+#define HDMI_NV_PDISP_SOR_AUDIO_AVAL_DEFAULT 0xc5
+
+#endif /* TEGRA_HDMI_H */
diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
index ed2af1a..9624326 100644
--- a/drivers/gpu/drm/tegra/host1x.c
+++ b/drivers/gpu/drm/tegra/host1x.c
@@ -67,6 +67,7 @@ static int host1x_parse_dt(struct host1x *host1x)
 {
 	static const char * const compat[] = {
 		"nvidia,tegra20-dc",
+		"nvidia,tegra20-hdmi",
 	};
 	unsigned int i;
 	int err;
@@ -293,8 +294,14 @@ static int __init tegra_host1x_init(void)
 	if (err < 0)
 		goto unregister_host1x;
 
+	err = platform_driver_register(&tegra_hdmi_driver);
+	if (err < 0)
+		goto unregister_dc;
+
 	return 0;
 
+unregister_dc:
+	platform_driver_unregister(&tegra_dc_driver);
 unregister_host1x:
 	platform_driver_unregister(&tegra_host1x_driver);
 	return err;
@@ -303,6 +310,7 @@ module_init(tegra_host1x_init);
 
 static void __exit tegra_host1x_exit(void)
 {
+	platform_driver_unregister(&tegra_hdmi_driver);
 	platform_driver_unregister(&tegra_dc_driver);
 	platform_driver_unregister(&tegra_host1x_driver);
 }
-- 
1.8.0

