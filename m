Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab2IKG1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:27:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48021 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2IKG1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:27:11 -0400
From: Prabhakar Lad <prabhakar.lad@ti.com>
To: LAK <linux-arm-kernel@lists.infradead.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH v3 2/2] ARM: da850/omap-l138: Add EVM specific code for VPIF to work
Date: Tue, 11 Sep 2012 11:55:09 +0530
Message-ID: <1347344709-6180-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1347344709-6180-1-git-send-email-prabhakar.lad@ti.com>
References: <1347344709-6180-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Include the expander settings to select VPIF peripheral on
UI card and add registration call in EVM init. Also add platform
data to configure display and capture devices.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/Kconfig           |    7 ++
 arch/arm/mach-davinci/board-da850-evm.c |  156 +++++++++++++++++++++++++++++++
 2 files changed, 163 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index ab99c3c..026b4b2 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -186,6 +186,13 @@ config DA850_UI_RMII
 	  NOTE: Please take care while choosing this option, MII PHY will
 	  not be functional if RMII mode is selected.
 
+config DA850_UI_SD_VIDEO_PORT
+	bool "Video Port Interface"
+	help
+	  Say Y if you want to use Video Port Interface (VPIF) on the
+	  DA850/OMAP-L138 EVM. The Video decoders/encoders are found on the
+	  UI daughter card that is supplied with the EVM.
+
 endchoice
 
 config DA850_WL12XX
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 0149fb4..d0954a2 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -45,6 +45,8 @@
 #include <mach/aemif.h>
 #include <mach/spi.h>
 
+#include <media/tvp514x.h>
+
 #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
 #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
 #define DA850_LCD_BL_PIN		GPIO_TO_PIN(2, 15)
@@ -452,6 +454,15 @@ static void da850_evm_ui_keys_init(unsigned gpio)
 	}
 }
 
+#ifdef CONFIG_DA850_UI_SD_VIDEO_PORT
+static inline void da850_evm_setup_video_port(int video_sel)
+{
+	gpio_set_value_cansleep(video_sel, 0);
+}
+#else
+static inline void da850_evm_setup_video_port(int video_sel) { }
+#endif
+
 static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
 						unsigned ngpio, void *c)
 {
@@ -497,6 +508,8 @@ static int da850_evm_ui_expander_setup(struct i2c_client *client, unsigned gpio,
 
 	da850_evm_setup_emac_rmii(sel_a);
 
+	da850_evm_setup_video_port(sel_c);
+
 	return 0;
 
 exp_setup_keys_fail:
@@ -1149,6 +1162,147 @@ static __init int da850_evm_init_cpufreq(void)
 static __init int da850_evm_init_cpufreq(void) { return 0; }
 #endif
 
+#if defined(CONFIG_DA850_UI_SD_VIDEO_PORT)
+
+#define TVP5147_CH0		"tvp514x-0"
+#define TVP5147_CH1		"tvp514x-1"
+
+/* VPIF capture configuration */
+static struct tvp514x_platform_data tvp5146_pdata = {
+		.clk_polarity = 0,
+		.hs_polarity  = 1,
+		.vs_polarity  = 1,
+};
+
+#define TVP514X_STD_ALL (V4L2_STD_NTSC | V4L2_STD_PAL)
+
+static const struct vpif_input da850_ch0_inputs[] = {
+	{
+		.input = {
+			.index = 0,
+			.name  = "Composite",
+			.type  = V4L2_INPUT_TYPE_CAMERA,
+			.std   = TVP514X_STD_ALL,
+		},
+		.subdev_name = TVP5147_CH0,
+	},
+};
+
+static const struct vpif_input da850_ch1_inputs[] = {
+	{
+		.input = {
+			.index = 0,
+			.name  = "S-Video",
+			.type  = V4L2_INPUT_TYPE_CAMERA,
+			.std   = TVP514X_STD_ALL,
+		},
+		.subdev_name = TVP5147_CH1,
+	},
+};
+
+static struct vpif_subdev_info da850_vpif_capture_sdev_info[] = {
+	{
+		.name = TVP5147_CH0,
+		.board_info = {
+			I2C_BOARD_INFO("tvp5146", 0x5d),
+			.platform_data = &tvp5146_pdata,
+		},
+		.input = INPUT_CVBS_VI2B,
+		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
+		.can_route = 1,
+		.vpif_if = {
+			.if_type = VPIF_IF_BT656,
+			.hd_pol  = 1,
+			.vd_pol  = 1,
+			.fid_pol = 0,
+		},
+	},
+	{
+		.name = TVP5147_CH1,
+		.board_info = {
+			I2C_BOARD_INFO("tvp5146", 0x5c),
+			.platform_data = &tvp5146_pdata,
+		},
+		.input = INPUT_SVIDEO_VI2C_VI1C,
+		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
+		.can_route = 1,
+		.vpif_if = {
+			.if_type = VPIF_IF_BT656,
+			.hd_pol  = 1,
+			.vd_pol  = 1,
+			.fid_pol = 0,
+		},
+	},
+};
+
+static struct vpif_capture_config da850_vpif_capture_config = {
+	.subdev_info = da850_vpif_capture_sdev_info,
+	.subdev_count = ARRAY_SIZE(da850_vpif_capture_sdev_info),
+	.chan_config[0] = {
+		.inputs = da850_ch0_inputs,
+		.input_count = ARRAY_SIZE(da850_ch0_inputs),
+	},
+	.chan_config[1] = {
+		.inputs = da850_ch1_inputs,
+		.input_count = ARRAY_SIZE(da850_ch1_inputs),
+	},
+	.card_name = "DA850/OMAP-L138 Video Capture",
+};
+
+/* VPIF display configuration */
+static struct vpif_subdev_info da850_vpif_subdev[] = {
+	{
+		.name = "adv7343",
+		.board_info = {
+			I2C_BOARD_INFO("adv7343", 0x2a),
+		},
+	},
+};
+
+static const char const *vpif_output[] = {
+		"Composite",
+		"S-Video",
+};
+
+static struct vpif_display_config da850_vpif_display_config = {
+	.subdevinfo   = da850_vpif_subdev,
+	.subdev_count = ARRAY_SIZE(da850_vpif_subdev),
+	.output       = vpif_output,
+	.output_count = ARRAY_SIZE(vpif_output),
+	.card_name    = "DA850/OMAP-L138 Video Display",
+};
+
+static __init void da850_vpif_init(void)
+{
+	int ret;
+
+	ret = da850_register_vpif();
+	if (ret)
+		pr_warn("da850_evm_init: VPIF setup failed: %d\n", ret);
+
+	ret = davinci_cfg_reg_list(da850_vpif_capture_pins);
+	if (ret)
+		pr_warn("da850_evm_init: VPIF capture mux setup failed: %d\n",
+			ret);
+
+	ret = da850_register_vpif_capture(&da850_vpif_capture_config);
+	if (ret)
+		pr_warn("da850_evm_init: VPIF capture setup failed: %d\n", ret);
+
+	ret = davinci_cfg_reg_list(da850_vpif_display_pins);
+	if (ret)
+		pr_warn("da850_evm_init: VPIF display mux setup failed: %d\n",
+			ret);
+
+	ret = da850_register_vpif_display(&da850_vpif_display_config);
+	if (ret)
+		pr_warn("da850_evm_init: VPIF display setup failed: %d\n", ret);
+}
+
+#else
+static __init void da850_vpif_init(void) {}
+#endif
+
 #ifdef CONFIG_DA850_WL12XX
 
 static void wl12xx_set_power(int index, bool power_on)
@@ -1375,6 +1529,8 @@ static __init void da850_evm_init(void)
 		pr_warning("da850_evm_init: suspend registration failed: %d\n",
 				ret);
 
+	da850_vpif_init();
+
 	ret = da8xx_register_spi(1, da850evm_spi_info,
 				 ARRAY_SIZE(da850evm_spi_info));
 	if (ret)
-- 
1.7.0.4

