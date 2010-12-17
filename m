Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0LQAxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:53:19 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36886 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab0LQAuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="66953207"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 10/22] msm: Move 8x60 to the real clock driver
Date: Thu, 16 Dec 2010 16:49:54 -0800
Message-Id: <1292547006-19741-11-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dummy clock driver was added to make 8x60 compile due to
proc_comm references in clock.c. Now that those references are
gone we can compile the original clock.c with no errors and
support clocks on 8x60.

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile          |    7 +-
 arch/arm/mach-msm/board-msm8x60.c   |    3 +
 arch/arm/mach-msm/devices-msm8x60.c |  180 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/devices.h         |    3 +
 4 files changed, 189 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-msm/devices-msm8x60.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index fa01510..fb44992 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -1,7 +1,6 @@
 obj-y += io.o idle.o timer.o
-ifdef CONFIG_MSM_PROC_COMM
+obj-y += clock.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
-endif
 obj-$(CONFIG_ARCH_MSM7X30) += clock-local.o
 obj-$(CONFIG_ARCH_MSM8X60) += clock-local.o
 obj-$(CONFIG_ARCH_MSM7X30) += clock-7x30.o
@@ -19,9 +18,9 @@ obj-y += irq.o
 endif
 endif
 
-obj-$(CONFIG_ARCH_MSM8X60) += clock-dummy.o iommu.o iommu_dev.o devices-msm8x60-iommu.o
+obj-$(CONFIG_ARCH_MSM8X60) += iommu.o iommu_dev.o devices-msm8x60-iommu.o
+obj-$(CONFIG_ARCH_MSM8X60) += devices-msm8x60.o
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
-obj-$(CONFIG_MSM_PROC_COMM) += clock.o
 obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
 obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
 obj-$(CONFIG_MSM_SMD) += last_radio_log.o
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 852428b..a584d38 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -28,6 +28,8 @@
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
 
+#include "devices.h"
+
 void __iomem *gic_cpu_base_addr;
 
 static void __init msm8x60_map_io(void)
@@ -64,6 +66,7 @@ static void __init msm8x60_init_irq(void)
 
 static void __init msm8x60_init(void)
 {
+	msm_clock_init(msm_clocks_8x60, msm_num_clocks_8x60);
 }
 
 MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
diff --git a/arch/arm/mach-msm/devices-msm8x60.c b/arch/arm/mach-msm/devices-msm8x60.c
new file mode 100644
index 0000000..1f2b189
--- /dev/null
+++ b/arch/arm/mach-msm/devices-msm8x60.c
@@ -0,0 +1,180 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+
+#include "clock.h"
+#include "clock-8x60.h"
+
+struct clk msm_clocks_8x60[] = {
+	CLK_8X60("ce_clk",		CE2_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI1_UART_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI2_UART_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI3_UART_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI4_UART_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI5_UART_CLK,		NULL, OFF),
+	CLK_8X60("uartdm_clk",		GSBI6_UART_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI7_UART_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI8_UART_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI9_UART_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI10_UART_CLK,	NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI11_UART_CLK,	NULL, OFF),
+	CLK_8X60("gsbi_uart_clk",	GSBI12_UART_CLK,	NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI1_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI2_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI3_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI4_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI5_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI6_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI7_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI8_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI9_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI10_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI11_QUP_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_qup_clk",	GSBI12_QUP_CLK,		NULL, OFF),
+	CLK_8X60("pdm_clk",		PDM_CLK,		NULL, OFF),
+	CLK_8X60("pmem_clk",		PMEM_CLK,		NULL, OFF),
+	CLK_8X60("prng_clk",		PRNG_CLK,		NULL, OFF),
+	CLK_8X60("sdc_clk",		SDC1_CLK,		NULL, OFF),
+	CLK_8X60("sdc_clk",		SDC2_CLK,		NULL, OFF),
+	CLK_8X60("sdc_clk",		SDC3_CLK,		NULL, OFF),
+	CLK_8X60("sdc_clk",		SDC4_CLK,		NULL, OFF),
+	CLK_8X60("sdc_clk",		SDC5_CLK,		NULL, OFF),
+	CLK_8X60("tsif_ref_clk",	TSIF_REF_CLK,		NULL, OFF),
+	CLK_8X60("tssc_clk",		TSSC_CLK,		NULL, OFF),
+	CLK_8X60("usb_hs_clk",		USB_HS1_XCVR_CLK,	NULL, OFF),
+	CLK_8X60("usb_phy_clk",		USB_PHY0_CLK,		NULL, OFF),
+	CLK_8X60("usb_fs_src_clk",	USB_FS1_SRC_CLK,	NULL, OFF),
+	CLK_8X60("usb_fs_clk",		USB_FS1_XCVR_CLK,	NULL, OFF),
+	CLK_8X60("usb_fs_sys_clk",	USB_FS1_SYS_CLK,	NULL, OFF),
+	CLK_8X60("usb_fs_src_clk",	USB_FS2_SRC_CLK,	NULL, OFF),
+	CLK_8X60("usb_fs_clk",		USB_FS2_XCVR_CLK,	NULL, OFF),
+	CLK_8X60("usb_fs_sys_clk",	USB_FS2_SYS_CLK,	NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI1_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI2_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI3_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI4_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI5_P_CLK,		NULL, OFF),
+	CLK_8X60("uartdm_pclk",		GSBI6_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI7_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI8_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI9_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI10_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI11_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI12_P_CLK,		NULL, OFF),
+	CLK_8X60("gsbi_pclk",		GSBI12_P_CLK,		NULL, OFF),
+	CLK_8X60("ppss_pclk",		PPSS_P_CLK,		NULL, OFF),
+	CLK_8X60("tsif_pclk",		TSIF_P_CLK,		NULL, OFF),
+	CLK_8X60("usb_fs_pclk",		USB_FS1_P_CLK,		NULL, OFF),
+	CLK_8X60("usb_fs_pclk",		USB_FS2_P_CLK,		NULL, OFF),
+	CLK_8X60("usb_hs_pclk",		USB_HS1_P_CLK,		NULL, OFF),
+	CLK_8X60("sdc_pclk",		SDC1_P_CLK,		NULL, OFF),
+	CLK_8X60("sdc_pclk",		SDC2_P_CLK,		NULL, OFF),
+	CLK_8X60("sdc_pclk",		SDC3_P_CLK,		NULL, OFF),
+	CLK_8X60("sdc_pclk",		SDC4_P_CLK,		NULL, OFF),
+	CLK_8X60("sdc_pclk",		SDC5_P_CLK,		NULL, OFF),
+	CLK_8X60("adm_clk",		ADM0_CLK,		NULL, OFF),
+	CLK_8X60("adm_pclk",		ADM0_P_CLK,		NULL, OFF),
+	CLK_8X60("adm_clk",		ADM1_CLK,		NULL, OFF),
+	CLK_8X60("adm_pclk",		ADM1_P_CLK,		NULL, OFF),
+	CLK_8X60("modem_ahb1_pclk",	MODEM_AHB1_P_CLK,	NULL, OFF),
+	CLK_8X60("modem_ahb2_pclk",	MODEM_AHB2_P_CLK,	NULL, OFF),
+	CLK_8X60("pmic_arb_pclk",	PMIC_ARB0_P_CLK,	NULL, OFF),
+	CLK_8X60("pmic_arb_pclk",	PMIC_ARB1_P_CLK,	NULL, OFF),
+	CLK_8X60("pmic_ssbi2",		PMIC_SSBI2_CLK,		NULL, OFF),
+	CLK_8X60("rpm_msg_ram_pclk",	RPM_MSG_RAM_P_CLK,	NULL, OFF),
+	CLK_8X60("amp_clk",		AMP_CLK,		NULL, OFF),
+	CLK_8X60("cam_clk",		CAM_CLK,		NULL, OFF),
+	CLK_8X60("csi_src_clk",		CSI_SRC_CLK,		NULL, OFF),
+	CLK_8X60("csi_clk",		CSI0_CLK,		NULL, OFF),
+	CLK_8X60("csi_clk",		CSI1_CLK,		NULL, OFF),
+	CLK_8X60("dsi_byte_div_clk",	DSI_BYTE_CLK,		NULL, OFF),
+	CLK_8X60("dsi_esc_clk",		DSI_ESC_CLK,		NULL, OFF),
+	CLK_8X60("gfx2d0_clk",		GFX2D0_CLK,		NULL, OFF),
+	CLK_8X60("gfx2d1_clk",		GFX2D1_CLK,		NULL, OFF),
+	CLK_8X60("gfx3d_clk",		GFX3D_CLK,		NULL, OFF),
+	CLK_8X60("ijpeg_clk",		IJPEG_CLK,		NULL, OFF),
+	CLK_8X60("imem_clk",		IMEM_CLK,		NULL, OFF),
+	CLK_8X60("jpegd_clk",		JPEGD_CLK,		NULL, OFF),
+	CLK_8X60("mdp_clk",		MDP_CLK,		NULL, OFF),
+	CLK_8X60("mdp_vsync_clk",	MDP_VSYNC_CLK,		NULL, OFF),
+	CLK_8X60("pixel_mdp_clk",	PIXEL_MDP_CLK,		NULL, OFF),
+	CLK_8X60("pixel_lcdc_clk",	PIXEL_LCDC_CLK,		NULL, OFF),
+	CLK_8X60("rot_clk",		ROT_CLK,		NULL, OFF),
+	CLK_8X60("tv_src_clk",		TV_SRC_CLK,		NULL, OFF),
+	CLK_8X60("tv_enc_clk",		TV_ENC_CLK,		NULL, OFF),
+	CLK_8X60("tv_dac_clk",		TV_DAC_CLK,		NULL, OFF),
+	CLK_8X60("vcodec_clk",		VCODEC_CLK,		NULL, OFF),
+	CLK_8X60("mdp_tv_clk",		MDP_TV_CLK,		NULL, OFF),
+	CLK_8X60("hdmi_clk",		HDMI_TV_CLK,		NULL, OFF),
+	CLK_8X60("hdmi_app_clk",	HDMI_APP_CLK,		NULL, OFF),
+	CLK_8X60("vpe_clk",		VPE_CLK,		NULL, OFF),
+	CLK_8X60("vfe_clk",		VFE_CLK,		NULL, OFF),
+	CLK_8X60("csi_vfe_clk",		CSI0_VFE_CLK,		NULL, OFF),
+	CLK_8X60("csi_vfe_clk",		CSI1_VFE_CLK,		NULL, OFF),
+	CLK_8X60("smmu_jpegd_clk",	JPEGD_AXI_CLK,		NULL, OFF),
+	CLK_8X60("smmu_vfe_clk",	VFE_AXI_CLK,		NULL, OFF),
+	CLK_8X60("vfe_axi_clk",		VFE_AXI_CLK,		NULL, OFF),
+	CLK_8X60("ijpeg_axi_clk",	IJPEG_AXI_CLK,		NULL, OFF),
+	CLK_8X60("mdp_axi_clk",		MDP_AXI_CLK,		NULL, OFF),
+	CLK_8X60("rot_axi_clk",		ROT_AXI_CLK,		NULL, OFF),
+	CLK_8X60("vcodec_axi_clk",	VCODEC_AXI_CLK,		NULL, OFF),
+	CLK_8X60("vpe_axi_clk",		VPE_AXI_CLK,		NULL, OFF),
+	CLK_8X60("amp_pclk",		AMP_P_CLK,		NULL, OFF),
+	CLK_8X60("csi_pclk",		CSI0_P_CLK,		NULL, OFF),
+	CLK_8X60("csi_pclk",		CSI1_P_CLK,		NULL, OFF),
+	CLK_8X60("dsi_m_pclk",		DSI_M_P_CLK,		NULL, OFF),
+	CLK_8X60("dsi_s_pclk",		DSI_S_P_CLK,		NULL, OFF),
+	CLK_8X60("gfx2d0_pclk",		GFX2D0_P_CLK,		NULL, OFF),
+	CLK_8X60("gfx2d1_pclk",		GFX2D1_P_CLK,		NULL, OFF),
+	CLK_8X60("gfx3d_pclk",		GFX3D_P_CLK,		NULL, OFF),
+	CLK_8X60("hdmi_m_pclk",		HDMI_M_P_CLK,		NULL, OFF),
+	CLK_8X60("hdmi_s_pclk",		HDMI_S_P_CLK,		NULL, OFF),
+	CLK_8X60("ijpeg_pclk",		IJPEG_P_CLK,		NULL, OFF),
+	CLK_8X60("jpegd_pclk",		JPEGD_P_CLK,		NULL, OFF),
+	CLK_8X60("imem_pclk",		IMEM_P_CLK,		NULL, OFF),
+	CLK_8X60("mdp_pclk",		MDP_P_CLK,		NULL, OFF),
+	CLK_8X60("smmu_pclk",		SMMU_P_CLK,		NULL, OFF),
+	CLK_8X60("rotator_pclk",	ROT_P_CLK,		NULL, OFF),
+	CLK_8X60("tv_enc_pclk",		TV_ENC_P_CLK,		NULL, OFF),
+	CLK_8X60("vcodec_pclk",		VCODEC_P_CLK,		NULL, OFF),
+	CLK_8X60("vfe_pclk",		VFE_P_CLK,		NULL, OFF),
+	CLK_8X60("vpe_pclk",		VPE_P_CLK,		NULL, OFF),
+	CLK_8X60("mi2s_osr_clk",	MI2S_OSR_CLK,		NULL, OFF),
+	CLK_8X60("mi2s_bit_clk",	MI2S_BIT_CLK,		NULL, OFF),
+	CLK_8X60("i2s_mic_osr_clk",	CODEC_I2S_MIC_OSR_CLK,	NULL, OFF),
+	CLK_8X60("i2s_mic_bit_clk",	CODEC_I2S_MIC_BIT_CLK,	NULL, OFF),
+	CLK_8X60("i2s_mic_osr_clk",	SPARE_I2S_MIC_OSR_CLK,	NULL, OFF),
+	CLK_8X60("i2s_mic_bit_clk",	SPARE_I2S_MIC_BIT_CLK,	NULL, OFF),
+	CLK_8X60("i2s_spkr_osr_clk",	CODEC_I2S_SPKR_OSR_CLK,	NULL, OFF),
+	CLK_8X60("i2s_spkr_bit_clk",	CODEC_I2S_SPKR_BIT_CLK,	NULL, OFF),
+	CLK_8X60("i2s_spkr_osr_clk",	SPARE_I2S_SPKR_OSR_CLK,	NULL, OFF),
+	CLK_8X60("i2s_spkr_bit_clk",	SPARE_I2S_SPKR_BIT_CLK,	NULL, OFF),
+	CLK_8X60("pcm_clk",		PCM_CLK,		NULL, OFF),
+	CLK_8X60("iommu_clk",           JPEGD_AXI_CLK, NULL, 0),
+	CLK_8X60("iommu_clk",           VFE_AXI_CLK, NULL, 0),
+	CLK_8X60("iommu_clk",           VCODEC_AXI_CLK, NULL, 0),
+	CLK_8X60("iommu_clk",           VCODEC_AXI_CLK, NULL, 0),
+	CLK_8X60("iommu_clk",           GFX3D_CLK, NULL, 0),
+	CLK_8X60("iommu_clk",           GFX2D0_CLK, NULL, 0),
+	CLK_8X60("iommu_clk",           GFX2D1_CLK, NULL, 0),
+};
+
+unsigned msm_num_clocks_8x60 = ARRAY_SIZE(msm_clocks_8x60);
+
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 68b8075..81d2b5d8 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -48,4 +48,7 @@ extern unsigned msm_num_clocks_7x30;
 extern struct clk msm_clocks_8x50[];
 extern unsigned msm_num_clocks_8x50;
 
+extern struct clk msm_clocks_8x60[];
+extern unsigned msm_num_clocks_8x60;
+
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

