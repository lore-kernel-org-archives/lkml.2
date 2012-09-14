Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2INMsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:48:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52914 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2INMsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:48:45 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 03/14] davinci: vpfe: add IPIPE support for media controller driver
Date: Fri, 14 Sep 2012 18:16:33 +0530
Message-Id: <1347626804-5703-4-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

Add the IPIPE interfacing layer to the vpfe driver. This patch adds dm365
specific implementation of the genric imp_hw_interface interface for
programming the IPIPE block, mainly setting the resizer and previewer
configuration parameters. This is built as an independent module.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/dm365_def_para.c  |  294 ++
 drivers/media/platform/davinci/dm365_def_para.h  |   49 +
 drivers/media/platform/davinci/dm365_ipipe.c     | 3673 ++++++++++++++++++++++
 drivers/media/platform/davinci/dm365_ipipe.h     |  430 +++
 drivers/media/platform/davinci/imp_hw_if.h       |  180 ++
 drivers/media/platform/davinci/vpfe_imp_common.h |   84 +
 include/linux/davinci_vpfe.h                     |  929 ++++++
 7 files changed, 5639 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/davinci/dm365_def_para.c
 create mode 100644 drivers/media/platform/davinci/dm365_def_para.h
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe.c
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe.h
 create mode 100644 drivers/media/platform/davinci/imp_hw_if.h
 create mode 100644 drivers/media/platform/davinci/vpfe_imp_common.h
 create mode 100644 include/linux/davinci_vpfe.h

diff --git a/drivers/media/platform/davinci/dm365_def_para.c b/drivers/media/platform/davinci/dm365_def_para.c
new file mode 100644
index 0000000..fe82298
--- /dev/null
+++ b/drivers/media/platform/davinci/dm365_def_para.c
@@ -0,0 +1,294 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#include <linux/v4l2-mediabus.h>
+
+#include "dm365_ipipe.h"
+
+/* Defaults for lutdpc */
+struct prev_lutdpc dm365_lutdpc_defaults;
+
+/* Defaults for otfdpc */
+struct prev_otfdpc dm365_otfdpc_defaults;
+
+/* Defaults for 2D - nf */
+struct prev_nf dm365_nf_defaults;
+
+/* defaults for GIC */
+struct prev_gic dm365_gic_defaults;
+
+/* Defaults for white balance */
+struct prev_wb dm365_wb_defaults = {
+	.gain_r  = {2, 0x0},
+	.gain_gr = {2, 0x0},
+	.gain_gb = {2, 0x0},
+	.gain_b  = {2, 0x0}
+};
+
+/* Defaults for CFA */
+struct prev_cfa dm365_cfa_defaults = {
+	.alg = IPIPE_CFA_ALG_2DIRAC,
+};
+
+/* Defaults for rgb2rgb */
+struct prev_rgb2rgb dm365_rgb2rgb_defaults = {
+	.coef_rr = {1, 0},	/* 256 */
+	.coef_gr = {0, 0},
+	.coef_br = {0, 0},
+	.coef_rg = {0, 0},
+	.coef_gg = {1, 0},	/* 256 */
+	.coef_bg = {0, 0},
+	.coef_rb = {0, 0},
+	.coef_gb = {0, 0},
+	.coef_bb = {1, 0},	/* 256 */
+};
+
+/* Defaults for gamma correction */
+struct prev_gamma dm365_gamma_defaults = {
+	.tbl_sel = IPIPE_GAMMA_TBL_ROM
+};
+
+/* Defaults for 3d lut */
+struct prev_3d_lut dm365_3d_lut_defaults;
+
+/* Defaults for rgb2yuv conversion */
+struct prev_rgb2yuv dm365_rgb2yuv_defaults = {
+	.coef_ry  = {0, 0x4d},
+	.coef_gy  = {0, 0x96},
+	.coef_by  = {0, 0x1d},
+	.coef_rcb = {0xf, 0xd5},
+	.coef_gcb = {0xf, 0xab},
+	.coef_bcb = {0, 0x80},
+	.coef_rcr = {0, 0x80},
+	.coef_gcr = {0xf, 0x95},
+	.coef_bcr = {0xf, 0xeb},
+	.out_ofst_cb = 0x80,
+	.out_ofst_cr = 0x80,
+};
+
+/* Defaults for GBCE */
+struct prev_gbce dm365_gbce_defaults;
+
+/* Defaults for yuv 422 conversion */
+struct prev_yuv422_conv dm365_yuv422_conv_defaults = {
+	.chrom_pos = IPIPE_YUV422_CHR_POS_COSITE
+};
+
+/* Defaults for Edge Ehnancements  */
+struct prev_yee dm365_yee_defaults;
+
+/* Defaults for CAR conversion */
+struct prev_car dm365_car_defaults;
+
+/* Defaults for CGS */
+struct prev_cgs dm365_cgs_defaults;
+
+#define  WIDTH_I 640
+#define  HEIGHT_I 480
+#define  WIDTH_O 640
+#define  HEIGHT_O 480
+
+/* default ipipeif settings */
+struct ipipeif_5_1 ipipeif_5_1_defaults = {
+	.pack_mode = IPIPEIF_5_1_PACK_16_BIT,
+	.data_shift = IPIPEIF_BITS11_0,
+	.source1 = IPIPEIF_SRC1_PARALLEL_PORT,
+	.clk_div = {
+		.m = 1,	/* clock = sdram clock * (m/n) */
+		.n = 6
+	},
+	.dpcm = {
+		.type = IPIPEIF_DPCM_8BIT_12BIT,
+		.pred = V4L2_DPCM_PREDICTOR_SIMPLE
+	},
+	.chroma_phase = IPIPEIF_CBCR_Y,
+	.isif_port = {
+		.if_type = V4L2_MBUS_FMT_SGRBG12_1X12,
+		.hdpol = VPFE_PINPOL_POSITIVE,
+		.vdpol = VPFE_PINPOL_POSITIVE
+	},
+	.clip = 4095,
+};
+
+struct ipipe_params dm365_ipipe_defs = {
+	.ipipeif_param = {
+		.mode = IPIPEIF_ONE_SHOT,
+		.source = IPIPEIF_SDRAM_RAW,
+		.clock_select = IPIPEIF_SDRAM_CLK,
+		.glob_hor_size = WIDTH_I + 8,
+		.glob_ver_size = HEIGHT_I + 10,
+		.hnum = WIDTH_I,
+		.vnum = HEIGHT_I,
+		.adofs = WIDTH_I * 2,
+		.rsz = 16,	/* resize ratio 16/rsz */
+		.decimation = IPIPEIF_DECIMATION_OFF,
+		.avg_filter = IPIPEIF_AVG_OFF,
+		.gain = 0x200,	/* U10Q9 */
+	},
+	.ipipe_mode = IPIPEIF_ONE_SHOT,
+	.ipipe_dpaths_fmt = IPIPE_RAW2YUV,
+	.ipipe_vsz = HEIGHT_I - 1,
+	.ipipe_hsz = WIDTH_I - 1,
+	.ipipe_colpat = ipipe_sgrbg_pattern,
+	.rsz_common = {
+		.vsz = HEIGHT_I - 1,
+		.hsz = WIDTH_I - 1,
+		.src_img_fmt = RSZ_IMG_422,
+		.raw_flip = 1,	/* flip preserve Raw format */
+		.source = IPIPE_DATA,
+		.passthrough = IPIPE_BYPASS_OFF,
+		.yuv_y_max = 255,
+		.yuv_c_max = 255,
+		.rsz_seq_crv = DISABLE,
+		.out_chr_pos = IPIPE_YUV422_CHR_POS_COSITE
+	},
+	.rsz_rsc_param = {
+		{
+			.mode = IPIPEIF_ONE_SHOT,
+			.h_flip = DISABLE,
+			.v_flip = DISABLE,
+			.cen = DISABLE,
+			.yen = DISABLE,
+			.o_vsz = HEIGHT_O - 1,
+			.o_hsz = WIDTH_O - 1,
+			.v_dif = 256,
+			.v_typ_y = RSZ_INTP_CUBIC,
+			.h_typ_c = RSZ_INTP_CUBIC,
+			.h_dif = 256,
+			.h_typ_y = RSZ_INTP_CUBIC,
+			.h_typ_c = RSZ_INTP_CUBIC,
+			.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+			.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		},
+		{
+			.mode = IPIPEIF_ONE_SHOT,
+			.h_flip = DISABLE,
+			.v_flip = DISABLE,
+			.cen = DISABLE,
+			.yen = DISABLE,
+			.o_vsz = HEIGHT_O - 1,
+			.o_hsz = WIDTH_O - 1,
+			.v_dif = 256,
+			.v_typ_y = RSZ_INTP_CUBIC,
+			.h_typ_c = RSZ_INTP_CUBIC,
+			.h_dif = 256,
+			.h_typ_y = RSZ_INTP_CUBIC,
+			.h_typ_c = RSZ_INTP_CUBIC,
+			.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+			.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		},
+	},
+	.rsz2rgb = {
+		{
+			.rgb_en = DISABLE
+		},
+		{
+			.rgb_en = DISABLE
+		}
+	},
+	.ext_mem_param = {
+		{
+			.rsz_sdr_oft_y = WIDTH_O << 1,
+			.rsz_sdr_ptr_e_y = HEIGHT_O,
+			.rsz_sdr_oft_c = WIDTH_O,
+			.rsz_sdr_ptr_e_c = HEIGHT_O >> 1,
+		},
+		{
+			.rsz_sdr_oft_y = WIDTH_O << 1,
+			.rsz_sdr_ptr_e_y = HEIGHT_O,
+			.rsz_sdr_oft_c = WIDTH_O,
+			.rsz_sdr_ptr_e_c = HEIGHT_O,
+		},
+	},
+	.rsz_en[0] = ENABLE,
+	.rsz_en[1] = DISABLE
+};
+
+struct prev_ipipeif_config dm365_prev_ss_config_defs = {
+	.bypass = IPIPE_BYPASS_OFF,
+	.input_spec = {
+		.ppln = WIDTH_I + 8,
+		.lpfr = HEIGHT_I + 10,
+		.clk_div = {1, 6},
+	},
+	.rsz = 16,	/* resize ratio 16/rsz */
+	.avg_filter_en = IPIPEIF_AVG_OFF,
+	.dpc = {0, 0},
+	.clip = 4095,
+};
+
+struct prev_ipipeif_config dm365_prev_cont_config_defs = {
+	.bypass = IPIPE_BYPASS_OFF,
+	.rsz = 16,
+	.avg_filter_en = IPIPEIF_AVG_OFF,
+	.clip = 4095,
+};
+
+struct rsz_config dm365_rsz_ss_config_defs = {
+	.input = {
+		.ppln = WIDTH_I + 8,
+		.lpfr = HEIGHT_I + 10,
+		.clk_div = {1, 6},
+		.rsz = 16,	/* resize ratio 16/rsz */
+		.avg_filter_en = IPIPEIF_AVG_OFF,
+	},
+	.output1 = {
+		.v_typ_y = RSZ_INTP_CUBIC,
+		.v_typ_c = RSZ_INTP_CUBIC,
+		.h_typ_y = RSZ_INTP_CUBIC,
+		.h_typ_c = RSZ_INTP_CUBIC,
+		.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+	},
+	.output2 = {
+		.v_typ_y = RSZ_INTP_CUBIC,
+		.v_typ_c = RSZ_INTP_CUBIC,
+		.h_typ_y = RSZ_INTP_CUBIC,
+		.h_typ_c = RSZ_INTP_CUBIC,
+		.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+	},
+	.yuv_y_max = 255,
+	.yuv_c_max = 255,
+	.out_chr_pos = IPIPE_YUV422_CHR_POS_COSITE,
+};
+
+struct rsz_config dm365_rsz_cont_config_defs = {
+	.output1 = {
+		.v_typ_y = RSZ_INTP_CUBIC,
+		.v_typ_c = RSZ_INTP_CUBIC,
+		.h_typ_y = RSZ_INTP_CUBIC,
+		.h_typ_c = RSZ_INTP_CUBIC,
+		.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+	},
+	.output2 = {
+		.v_typ_y = RSZ_INTP_CUBIC,
+		.v_typ_c = RSZ_INTP_CUBIC,
+		.h_typ_y = RSZ_INTP_CUBIC,
+		.h_typ_c = RSZ_INTP_CUBIC,
+		.h_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+		.v_dscale_ave_sz = IPIPE_DWN_SCALE_1_OVER_2,
+	},
+	.yuv_y_max = 255,
+	.yuv_c_max = 255,
+	.out_chr_pos = IPIPE_YUV422_CHR_POS_COSITE,
+};
diff --git a/drivers/media/platform/davinci/dm365_def_para.h b/drivers/media/platform/davinci/dm365_def_para.h
new file mode 100644
index 0000000..6b3281e
--- /dev/null
+++ b/drivers/media/platform/davinci/dm365_def_para.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _DM365_DEF_PARA_H
+#define _DM365_DEF_PARA_H
+
+#include "dm365_ipipe.h"
+
+extern struct prev_lutdpc dm365_lutdpc_defaults;
+extern struct prev_otfdpc dm365_otfdpc_defaults;
+extern struct prev_nf dm365_nf_defaults;
+extern struct prev_gic dm365_gic_defaults;
+extern struct prev_wb dm365_wb_defaults;
+extern struct prev_cfa dm365_cfa_defaults;
+extern struct prev_rgb2rgb dm365_rgb2rgb_defaults;
+extern struct prev_gamma dm365_gamma_defaults;
+extern struct prev_3d_lut dm365_3d_lut_defaults;
+extern struct prev_rgb2yuv dm365_rgb2yuv_defaults;
+extern struct prev_yuv422_conv dm365_yuv422_conv_defaults;
+extern struct prev_gbce dm365_gbce_defaults;
+extern struct prev_yee dm365_yee_defaults;
+extern struct prev_car dm365_car_defaults;
+extern struct prev_cgs dm365_cgs_defaults;
+extern struct ipipe_params dm365_ipipe_defs;
+extern struct prev_single_shot_config dm365_prev_ss_config_defs;
+extern struct prev_continuous_config dm365_prev_cont_config_defs;
+extern struct rsz_single_shot_config dm365_rsz_ss_config_defs;
+extern struct rsz_continuous_config dm365_rsz_cont_config_defs;
+extern struct ipipeif_5_1 ipipeif_5_1_defaults;
+
+#endif
diff --git a/drivers/media/platform/davinci/dm365_ipipe.c b/drivers/media/platform/davinci/dm365_ipipe.c
new file mode 100644
index 0000000..5ca1138
--- /dev/null
+++ b/drivers/media/platform/davinci/dm365_ipipe.c
@@ -0,0 +1,3673 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/videodev2.h>
+#include <linux/dma-mapping.h>
+#include <linux/v4l2-mediabus.h>
+
+#include "dm365_ipipe.h"
+#include "imp_hw_if.h"
+#include "dm365_ipipe_hw.h"
+#include "dm365_def_para.h"
+
+static int dpcm_predictor;
+static int ipipeif_gain;
+
+static int ipipe_enum_pix(void *ipipe, u32 *pix, int i)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (i >= ARRAY_SIZE(oper_state->ipipe_raw_yuv_pix_formats))
+		return -EINVAL;
+
+	*pix = oper_state->ipipe_raw_yuv_pix_formats[i];
+	return 0;
+}
+
+/* IPIPE hardware limits */
+#define IPIPE_MAX_OUTPUT_WIDTH_A	2176
+#define IPIPE_MAX_OUTPUT_WIDTH_B	640
+
+static int ipipe_get_max_output_width(int rsz)
+{
+	if (rsz == RSZ_A)
+		return IPIPE_MAX_OUTPUT_WIDTH_A;
+	return IPIPE_MAX_OUTPUT_WIDTH_B;
+}
+
+/* Based on max resolution supported. QXGA */
+#define IPIPE_MAX_OUTPUT_HEIGHT_A	1536
+/* Based on max resolution supported. VGA */
+#define IPIPE_MAX_OUTPUT_HEIGHT_B	480
+
+static int ipipe_get_max_output_height(int rsz)
+{
+	if (rsz == RSZ_A)
+		return IPIPE_MAX_OUTPUT_HEIGHT_A;
+	return IPIPE_MAX_OUTPUT_HEIGHT_B;
+}
+
+static int ipipe_serialize(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->en_serializer;
+}
+
+static int ipipe_set_ipipe_if_address(void *config, unsigned int address)
+{
+	struct ipipeif *if_params;
+
+	if (!config)
+		return -EINVAL;
+
+	if_params = &((struct ipipe_params *)config)->ipipeif_param;
+
+	return ipipeif_set_address(if_params, address);
+}
+
+static void ipipe_lock_chain(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	mutex_lock(&oper_state->lock);
+	oper_state->resource_in_use = 1;
+	mutex_unlock(&oper_state->lock);
+}
+
+static void ipipe_unlock_chain(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	mutex_lock(&oper_state->lock);
+	oper_state->resource_in_use = 0;
+	oper_state->prev_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_chained = 0;
+	mutex_unlock(&oper_state->lock);
+}
+
+static int
+ipipe_process_pix_fmts(enum v4l2_mbus_pixelcode in_pix_fmt,
+		       enum v4l2_mbus_pixelcode out_pix_fmt,
+		       struct ipipe_params *param)
+{
+	enum v4l2_mbus_pixelcode temp_pix_fmt;
+
+	switch (in_pix_fmt) {
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+		temp_pix_fmt = V4L2_MBUS_FMT_SGRBG12_1X12;
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_8_BIT;
+		break;
+	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_8_BIT_A_LAW;
+		temp_pix_fmt = V4L2_MBUS_FMT_SGRBG12_1X12;
+		break;
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_8_BIT;
+		param->ipipeif_param.var.if_5_1.dpcm.en = 1;
+		temp_pix_fmt = V4L2_MBUS_FMT_SGRBG12_1X12;
+		break;
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_16_BIT;
+		temp_pix_fmt = V4L2_MBUS_FMT_SGRBG12_1X12;
+		break;
+	case V4L2_MBUS_FMT_SBGGR12_1X12:
+		param->ipipeif_param.var.if_5_1.pack_mode
+		    = IPIPEIF_5_1_PACK_12_BIT;
+		temp_pix_fmt = V4L2_MBUS_FMT_SGRBG12_1X12;
+		break;
+	case V4L2_MBUS_FMT_Y8_1X8:
+		param->ipipeif_param.var.if_5_1.pack_mode
+			= IPIPEIF_5_1_PACK_8_BIT;
+		temp_pix_fmt = V4L2_MBUS_FMT_UYVY8_2X8;
+		break;
+	case V4L2_MBUS_FMT_UV8_1X8:
+		param->ipipeif_param.var.if_5_1.pack_mode
+			= IPIPEIF_5_1_PACK_8_BIT;
+		temp_pix_fmt = V4L2_MBUS_FMT_UYVY8_2X8;
+		break;
+	default:
+		temp_pix_fmt = V4L2_MBUS_FMT_UYVY8_2X8;
+	}
+
+	if (temp_pix_fmt == V4L2_MBUS_FMT_SGRBG12_1X12) {
+		if (out_pix_fmt == V4L2_MBUS_FMT_SGRBG12_1X12)
+			param->ipipe_dpaths_fmt = IPIPE_RAW2RAW;
+		else if (out_pix_fmt == V4L2_MBUS_FMT_UYVY8_2X8 ||
+			 out_pix_fmt == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+			param->ipipe_dpaths_fmt = IPIPE_RAW2YUV;
+		else
+			return -EINVAL;
+	} else if (temp_pix_fmt == V4L2_MBUS_FMT_UYVY8_2X8) {
+		switch (out_pix_fmt) {
+		case V4L2_MBUS_FMT_UYVY8_2X8:
+		case V4L2_MBUS_FMT_YDYUYDYV8_1X16:
+		case V4L2_MBUS_FMT_Y8_1X8:
+		case V4L2_MBUS_FMT_UV8_1X8:
+			param->ipipe_dpaths_fmt = IPIPE_YUV2YUV;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+/*
+ * calculate_resize_ratios() - Calculates resize ratio for resizer A or B.
+ *			       This is called after setting the input size
+ *			       or output size.
+ */
+static void calculate_resize_ratios(struct ipipe_params *param, int index)
+{
+	param->rsz_rsc_param[index].h_dif = ((param->ipipe_hsz + 1) * 256) /
+					(param->rsz_rsc_param[index].o_hsz + 1);
+	param->rsz_rsc_param[index].v_dif = ((param->ipipe_vsz + 1) * 256) /
+					(param->rsz_rsc_param[index].o_vsz + 1);
+}
+
+static int ipipe_do_hw_setup(struct device *dev, void *ipipe, void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = (struct ipipe_params *)config;
+	int ret;
+
+	dev_dbg(dev, "ipipe_do_hw_setup\n");
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+
+	if (!config && oper_state->oper_mode == IMP_MODE_CONTINUOUS) {
+		/* continuous mode */
+		param = oper_state->shared_config_param;
+		if (param->rsz_en[RSZ_A])
+			calculate_resize_ratios(param, RSZ_A);
+		if (param->rsz_en[RSZ_B])
+			calculate_resize_ratios(param, RSZ_B);
+		ret = ipipe_hw_setup(param);
+	}
+	mutex_unlock(&oper_state->lock);
+
+	return ret;
+}
+
+static unsigned int ipipe_rsz_chain_state(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->rsz_chained;
+}
+
+static void
+ipipe_update_outbuf1_address(void *ipipe, void *config, unsigned int address)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (!config && oper_state->oper_mode == IMP_MODE_CONTINUOUS)
+		return rsz_set_output_address(oper_state->shared_config_param,
+					      0, address);
+
+	rsz_set_output_address((struct ipipe_params *)config, 0, address);
+}
+
+static void
+ipipe_update_outbuf2_address(void *ipipe, void *config, unsigned int address)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (!config && oper_state->oper_mode == IMP_MODE_CONTINUOUS)
+		return rsz_set_output_address(oper_state->shared_config_param,
+					      1, address);
+
+	rsz_set_output_address((struct ipipe_params *)config, 1, address);
+}
+
+static void ipipe_enable(void *ipipe, unsigned char en, void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = (struct ipipe_params *)config;
+	unsigned char ret;
+
+	if (en)
+		en = !!en;
+
+	if (oper_state->oper_mode == IMP_MODE_CONTINUOUS)
+		param = oper_state->shared_config_param;
+
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT && en) {
+		/* for single-shot mode, need to wait for h/w to
+		   reset many register bits */
+		if (param->rsz_common.source == IPIPE_DATA) {
+			do {
+				ret = regr_ip(IPIPE_SRC_EN);
+			} while (ret);
+		}
+		do {
+			ret = regr_rsz(RSZ_SRC_EN);
+		} while (ret);
+		if (param->rsz_en[RSZ_A]) {
+			do {
+				ret = regr_rsz(RSZ_A);
+			} while (ret);
+		}
+		if (en && param->rsz_en[RSZ_B]) {
+			do {
+				ret = regr_rsz(RSZ_B);
+			} while (ret);
+		}
+		do {
+			ret = ipipeif_get_enable();
+		} while (ret & 0x1);
+	}
+
+	if (param->rsz_common.source == IPIPE_DATA)
+		regw_ip(en, IPIPE_SRC_EN);
+
+	if (param->rsz_en[RSZ_A])
+		rsz_enable(RSZ_A, en);
+
+	if (param->rsz_en[RSZ_B])
+		rsz_enable(RSZ_B, en);
+
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT)
+		ipipeif_set_enable();
+}
+
+static int
+validate_lutdpc_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	int i;
+
+	if (oper_state->lutdpc.en > 1 ||
+	    oper_state->lutdpc.repl_white > 1 ||
+	    oper_state->lutdpc.dpc_size > LUT_DPC_MAX_SIZE)
+		return -EINVAL;
+
+	if (oper_state->lutdpc.en && !oper_state->lutdpc.table)
+		return -EINVAL;
+
+	for (i = 0; i < oper_state->lutdpc.dpc_size; i++) {
+		if (oper_state->lutdpc.table[i].horz_pos > LUT_DPC_H_POS_MASK ||
+		    oper_state->lutdpc.table[i].vert_pos > LUT_DPC_V_POS_MASK)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+set_lutdpc_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_lutdpc *dpc_param;
+
+	if (!param) {
+		/* Copy defaults for lut dfc */
+		memcpy((void *)&oper_state->lutdpc,
+		       (void *)&dm365_lutdpc_defaults,
+		       sizeof(struct prev_lutdpc));
+		goto success;
+	}
+
+	if (len != sizeof(struct prev_lutdpc)) {
+		dev_err(dev,
+			"set_lutdpc_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	dpc_param = (struct prev_lutdpc *)param;
+	oper_state->lutdpc.en = dpc_param->en;
+	oper_state->lutdpc.repl_white = dpc_param->repl_white;
+	oper_state->lutdpc.dpc_size = dpc_param->dpc_size;
+
+	if (!memcpy((void *)&oper_state->lutdpc.table,
+		(void *)&dpc_param->table, (oper_state->lutdpc.dpc_size *
+		sizeof(struct ipipe_lutdpc_entry)))) {
+		dev_err(dev, "set_lutdpc_params: Error in copying dfc table\n");
+		return -EFAULT;
+	}
+	if (validate_lutdpc_params(dev, oper_state) < 0)
+		return -EINVAL;
+
+success:
+	ipipe_set_lutdpc_regs(&oper_state->lutdpc);
+
+	return 0;
+}
+
+static int
+get_lutdpc_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_lutdpc *lut_param = (struct prev_lutdpc *)param;
+
+	if (len != sizeof(struct prev_lutdpc)) {
+		dev_err(dev,
+			"get_lutdpc_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+
+	lut_param->en = oper_state->lutdpc.en;
+	lut_param->repl_white = oper_state->lutdpc.repl_white;
+	lut_param->dpc_size = oper_state->lutdpc.dpc_size;
+	if (!memcpy((void *)lut_param->table, (void *)oper_state->lutdpc.table,
+		(oper_state->lutdpc.dpc_size *
+		sizeof(struct ipipe_lutdpc_entry)))) {
+		dev_err(dev,
+			"get_lutdpc_params: Table Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_otfdpc_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	struct prev_otfdpc *dpc_param =
+				(struct prev_otfdpc *)&oper_state->otfdpc;
+	struct prev_otfdpc_2_0 *dpc_2_0;
+	struct prev_otfdpc_3_0 *dpc_3_0;
+
+	if (dpc_param->en > 1)
+		return -EINVAL;
+	if (dpc_param->alg == IPIPE_OTFDPC_2_0) {
+		dpc_2_0 = &dpc_param->alg_cfg.dpc_2_0;
+		if (dpc_2_0->det_thr.r > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->det_thr.gr > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->det_thr.gb > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->det_thr.b > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->corr_thr.r > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->corr_thr.gr > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->corr_thr.gb > OTFDPC_DPC2_THR_MASK ||
+		    dpc_2_0->corr_thr.b > OTFDPC_DPC2_THR_MASK)
+			return -EINVAL;
+		return 0;
+	}
+
+	dpc_3_0 = &dpc_param->alg_cfg.dpc_3_0;
+	if (dpc_3_0->act_adj_shf > OTF_DPC3_0_SHF_MASK ||
+	    dpc_3_0->det_thr > OTF_DPC3_0_DET_MASK ||
+	    dpc_3_0->det_slp > OTF_DPC3_0_SLP_MASK ||
+	    dpc_3_0->det_thr_min > OTF_DPC3_0_DET_MASK ||
+	    dpc_3_0->det_thr_max > OTF_DPC3_0_DET_MASK ||
+	    dpc_3_0->corr_thr > OTF_DPC3_0_CORR_MASK ||
+	    dpc_3_0->corr_slp > OTF_DPC3_0_SLP_MASK ||
+	    dpc_3_0->corr_thr_min > OTF_DPC3_0_CORR_MASK ||
+	    dpc_3_0->corr_thr_max > OTF_DPC3_0_CORR_MASK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int
+set_otfdpc_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_otfdpc *dpc_param = (struct prev_otfdpc *)param;
+
+	if (!param) {
+		/* Copy defaults for dpc2.0 defaults */
+		memcpy((void *)&oper_state->otfdpc,
+		       (void *)&dm365_otfdpc_defaults,
+		       sizeof(struct ipipe_otfdpc_2_0));
+	} else {
+		if (len != sizeof(struct prev_otfdpc)) {
+			dev_err(dev,
+			  "set_otfdpc_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->otfdpc, (void *)dpc_param,
+				   sizeof(struct prev_otfdpc))) {
+			dev_err(dev, "set_otfdpc_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+
+		if (validate_otfdpc_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_otfdpc_regs(&oper_state->otfdpc);
+
+	return 0;
+}
+
+static int
+get_otfdpc_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_otfdpc *dpc_param = (struct prev_otfdpc *)param;
+
+	if (len != sizeof(struct prev_otfdpc)) {
+		dev_err(dev,
+			"get_otfdpc_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)dpc_param, (void *)&oper_state->otfdpc,
+				sizeof(struct prev_otfdpc))) {
+		dev_err(dev,
+			"get_otfdpc_params: Error in copy dpc table to user\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_nf_params(struct device *dev,
+		   struct ipipe_oper_state *oper_state,
+		   unsigned int id)
+{
+	struct prev_nf *nf_param = &oper_state->nf1;
+	int i;
+
+	if (id)
+		nf_param = &oper_state->nf2;
+	if (nf_param->en > 1 ||
+	    nf_param->shft_val > D2F_SHFT_VAL_MASK ||
+	    nf_param->spread_val > D2F_SPR_VAL_MASK ||
+	    nf_param->apply_lsc_gain > 1 ||
+	    nf_param->edge_det_min_thr > D2F_EDGE_DET_THR_MASK ||
+	    nf_param->edge_det_max_thr > D2F_EDGE_DET_THR_MASK)
+		return -EINVAL;
+
+	for (i = 0; i < IPIPE_NF_THR_TABLE_SIZE; i++)
+		if (nf_param->thr[i] > D2F_THR_VAL_MASK)
+			return -EINVAL;
+	for (i = 0; i < IPIPE_NF_STR_TABLE_SIZE; i++)
+		if (nf_param->str[i] > D2F_STR_VAL_MASK)
+			return -EINVAL;
+	return 0;
+}
+
+static int
+set_nf_params(struct device *dev, struct ipipe_oper_state *oper_state,
+	      unsigned int id, void *param, int len)
+{
+	struct prev_nf *nf_param = (struct prev_nf *)param;
+	struct prev_nf *nf = &oper_state->nf1;
+
+	if (id)
+		nf = &oper_state->nf2;
+	if (!nf_param) {
+		/* Copy defaults for nf */
+		memcpy((void *)nf, (void *)&dm365_nf_defaults,
+					sizeof(struct prev_nf));
+		memset((void *)nf->thr, 0, IPIPE_NF_THR_TABLE_SIZE);
+		memset((void *)nf->str, 0, IPIPE_NF_THR_TABLE_SIZE);
+	} else {
+		if (len != sizeof(struct prev_nf)) {
+			dev_err(dev,
+			       "set_nf_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)nf, (void *)nf_param,
+					sizeof(struct prev_nf))) {
+			dev_err(dev, "set_nf_params: Error in copy\n");
+			return -EFAULT;
+		}
+		if (validate_nf_params(dev, oper_state, id) < 0)
+			return -EINVAL;
+	}
+	/* Now set the values in the hw */
+	ipipe_set_d2f_regs(id, nf);
+
+	return 0;
+}
+
+static int set_nf1_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return set_nf_params(dev, oper_state, 0, param, len);
+}
+
+static int set_nf2_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return set_nf_params(dev, oper_state, 1, param, len);
+}
+
+static int
+get_nf_params(struct device *dev, struct ipipe_oper_state *oper_state,
+	      unsigned int id, void *param, int len)
+{
+	struct prev_nf *nf_param = (struct prev_nf *)param;
+	struct prev_nf *nf = &oper_state->nf1;
+
+	if (len != sizeof(struct prev_nf)) {
+		dev_err(dev, "get_nf_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (id)
+		nf = &oper_state->nf2;
+	if (!memcpy((void *)nf_param, (void *)nf, sizeof(struct prev_nf))) {
+		dev_err(dev, "get_nf_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int get_nf1_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return get_nf_params(dev, oper_state, 0, param, len);
+}
+
+static int get_nf2_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return get_nf_params(dev, oper_state, 1, param, len);
+}
+
+static int
+validate_gic_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	if (oper_state->gic.en > 1 ||
+	    oper_state->gic.gain > GIC_GAIN_MASK ||
+	    oper_state->gic.thr > GIC_THR_MASK ||
+	    oper_state->gic.slope > GIC_SLOPE_MASK ||
+	    oper_state->gic.apply_lsc_gain > 1 ||
+	    oper_state->gic.nf2_thr_gain.integer > GIC_NFGAN_INT_MASK ||
+	    oper_state->gic.nf2_thr_gain.decimal > GIC_NFGAN_DECI_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int set_gic_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gic *gic_param = (struct prev_gic *)param;
+
+	if (!gic_param) {
+		/* Copy defaults for nf */
+		memcpy((void *)&oper_state->gic, (void *)&dm365_gic_defaults,
+					sizeof(struct prev_gic));
+	} else {
+		if (len != sizeof(struct prev_gic)) {
+			dev_err(dev,
+			      "set_gic_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->gic, (void *)gic_param,
+					sizeof(struct prev_gic))) {
+			dev_err(dev, "set_gic_params: Error in copy\n");
+			return -EFAULT;
+		}
+		if (validate_gic_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+	/* Now set the values in the hw */
+	ipipe_set_gic_regs(&oper_state->gic);
+
+	return 0;
+}
+
+static int get_gic_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gic *gic_param = (struct prev_gic *)param;
+
+	if (len != sizeof(struct prev_gic)) {
+		dev_err(dev, "get_gic_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+
+	if (!memcpy((void *)gic_param, (void *)&oper_state->gic,
+		sizeof(struct prev_gic))) {
+		dev_err(dev, "get_gic_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_wb_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	if (oper_state->wb.ofst_r > WB_OFFSET_MASK ||
+	    oper_state->wb.ofst_gr > WB_OFFSET_MASK ||
+	    oper_state->wb.ofst_gb > WB_OFFSET_MASK ||
+	    oper_state->wb.ofst_b > WB_OFFSET_MASK ||
+	    oper_state->wb.gain_r.integer > WB_GAIN_INT_MASK ||
+	    oper_state->wb.gain_r.decimal > WB_GAIN_DECI_MASK ||
+	    oper_state->wb.gain_gr.integer > WB_GAIN_INT_MASK ||
+	    oper_state->wb.gain_gr.decimal > WB_GAIN_DECI_MASK ||
+	    oper_state->wb.gain_gb.integer > WB_GAIN_INT_MASK ||
+	    oper_state->wb.gain_gb.decimal > WB_GAIN_DECI_MASK ||
+	    oper_state->wb.gain_b.integer > WB_GAIN_INT_MASK ||
+	    oper_state->wb.gain_b.decimal > WB_GAIN_DECI_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int set_wb_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_wb *wb_param = (struct prev_wb *)param;
+
+	dev_dbg(dev, "set_wb_params\n");
+	if (!wb_param) {
+		/* Copy defaults for wb */
+		memcpy((void *)&oper_state->wb, (void *)&dm365_wb_defaults,
+						sizeof(struct prev_wb));
+	} else {
+		if (len != sizeof(struct prev_wb)) {
+			dev_err(dev,
+			      "set_wb_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->wb, (void *)wb_param,
+						sizeof(struct prev_wb))) {
+			dev_err(dev, "set_wb_params: Error in copy\n");
+			return -EFAULT;
+		}
+		if (validate_wb_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+	/* Now set the values in the hw */
+	ipipe_set_wb_regs(&oper_state->wb);
+
+	return 0;
+}
+
+static int get_wb_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_wb *wb_param = (struct prev_wb *)param;
+
+	if (len != sizeof(struct prev_wb)) {
+		dev_err(dev, "get_wb_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)wb_param, (void *)&oper_state->wb,
+		sizeof(struct prev_wb))) {
+		dev_err(dev, "get_wb_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_cfa_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	if (oper_state->cfa.hpf_thr_2dir > CFA_HPF_THR_2DIR_MASK ||
+	    oper_state->cfa.hpf_slp_2dir > CFA_HPF_SLOPE_2DIR_MASK ||
+	    oper_state->cfa.hp_mix_thr_2dir > CFA_HPF_MIX_THR_2DIR_MASK ||
+	    oper_state->cfa.hp_mix_slope_2dir > CFA_HPF_MIX_SLP_2DIR_MASK ||
+	    oper_state->cfa.dir_thr_2dir > CFA_DIR_THR_2DIR_MASK ||
+	    oper_state->cfa.dir_slope_2dir > CFA_DIR_SLP_2DIR_MASK ||
+	    oper_state->cfa.nd_wt_2dir > CFA_ND_WT_2DIR_MASK ||
+	    oper_state->cfa.hue_fract_daa > CFA_DAA_HUE_FRA_MASK ||
+	    oper_state->cfa.edge_thr_daa > CFA_DAA_EDG_THR_MASK ||
+	    oper_state->cfa.thr_min_daa > CFA_DAA_THR_MIN_MASK ||
+	    oper_state->cfa.thr_slope_daa > CFA_DAA_THR_SLP_MASK ||
+	    oper_state->cfa.slope_min_daa > CFA_DAA_SLP_MIN_MASK ||
+	    oper_state->cfa.slope_slope_daa > CFA_DAA_SLP_SLP_MASK ||
+	    oper_state->cfa.lp_wt_daa > CFA_DAA_LP_WT_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int set_cfa_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_cfa *cfa_param = (struct prev_cfa *)param;
+
+	dev_dbg(dev, "set_cfa_params\n");
+	if (!cfa_param) {
+		/* Copy defaults for wb */
+		memcpy((void *)&oper_state->cfa, (void *)&dm365_cfa_defaults,
+						sizeof(struct prev_cfa));
+	} else {
+		if (len != sizeof(struct prev_cfa)) {
+			dev_err(dev,
+			       "set_cfa_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->cfa, (void *)cfa_param,
+					sizeof(struct prev_cfa))) {
+			dev_err(dev, "set_cfa_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+		if (validate_cfa_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+	/* Now set the values in the hw */
+	ipipe_set_cfa_regs(&oper_state->cfa);
+
+	return 0;
+}
+
+static int get_cfa_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_cfa *cfa_param = (struct prev_cfa *)param;
+
+	if (len != sizeof(struct prev_cfa)) {
+		dev_err(dev, "get_cfa_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)cfa_param, (void *)&oper_state->cfa,
+		sizeof(struct prev_cfa))) {
+		dev_err(dev, "get_cfa_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_rgb2rgb_params(struct device *dev, struct ipipe_oper_state *oper_state,
+			unsigned int id)
+{
+	struct prev_rgb2rgb *rgb2rgb = &oper_state->rgb2rgb_1;
+	u32 gain_int_upper = RGB2RGB_1_GAIN_INT_MASK;
+	u32 offset_upper = RGB2RGB_1_OFST_MASK;
+
+	if (id) {
+		rgb2rgb = &oper_state->rgb2rgb_2;
+		offset_upper = RGB2RGB_2_OFST_MASK;
+		gain_int_upper = RGB2RGB_2_GAIN_INT_MASK;
+	}
+	if (rgb2rgb->coef_rr.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_rr.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_gr.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_gr.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_br.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_br.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_rg.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_rg.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_gg.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_gg.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_bg.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_bg.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_rb.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_rb.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_gb.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_gb.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->coef_bb.decimal > RGB2RGB_GAIN_DECI_MASK ||
+	    rgb2rgb->coef_bb.integer > gain_int_upper)
+		return -EINVAL;
+
+	if (rgb2rgb->out_ofst_r > offset_upper ||
+	    rgb2rgb->out_ofst_g > offset_upper ||
+	    rgb2rgb->out_ofst_b > offset_upper)
+		return -EINVAL;
+	return 0;
+}
+
+static int
+set_rgb2rgb_params(struct device *dev, struct ipipe_oper_state *oper_state,
+		   unsigned int id, void *param, int len)
+{
+	struct prev_rgb2rgb *rgb2rgb_param = (struct prev_rgb2rgb *)param;
+	struct prev_rgb2rgb *rgb2rgb = &oper_state->rgb2rgb_1;
+
+	if (id)
+		rgb2rgb = &oper_state->rgb2rgb_2;
+	if (!rgb2rgb_param) {
+		/* Copy defaults for rgb2rgb conversion */
+		memcpy((void *)rgb2rgb, (void *)&dm365_rgb2rgb_defaults,
+					sizeof(struct prev_rgb2rgb));
+	} else {
+		if (len != sizeof(struct prev_rgb2rgb)) {
+			dev_err(dev,
+			"set_rgb2rgb_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+
+		if (!memcpy((void *)rgb2rgb, (void *)rgb2rgb_param,
+					  sizeof(struct prev_rgb2rgb))) {
+			dev_err(dev, "set_rgb2rgb_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+		if (validate_rgb2rgb_params(dev, oper_state, id) < 0)
+			return -EINVAL;
+	}
+	ipipe_set_rgb2rgb_regs(id, rgb2rgb);
+
+	return 0;
+}
+
+static int
+set_rgb2rgb_1_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return set_rgb2rgb_params(dev, oper_state, 0, param, len);
+}
+
+static int
+set_rgb2rgb_2_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return set_rgb2rgb_params(dev, oper_state, 1, param, len);
+}
+
+static int
+get_rgb2rgb_params(struct device *dev, struct ipipe_oper_state *oper_state,
+		   unsigned int id, void *param, int len)
+{
+	struct prev_rgb2rgb *rgb2rgb_param = (struct prev_rgb2rgb *)param;
+	struct prev_rgb2rgb *rgb2rgb = &oper_state->rgb2rgb_1;
+
+	if (len != sizeof(struct prev_rgb2rgb)) {
+		dev_err(dev,
+			"get_rgb2rgb_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (id)
+		rgb2rgb = &oper_state->rgb2rgb_2;
+	if (!memcpy((void *)rgb2rgb_param, (void *)rgb2rgb,
+		sizeof(struct prev_rgb2rgb))) {
+		dev_err(dev, "get_rgb2rgb_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+get_rgb2rgb_1_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return get_rgb2rgb_params(dev, oper_state, 0, param, len);
+}
+
+static int
+get_rgb2rgb_2_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return get_rgb2rgb_params(dev, oper_state, 1, param, len);
+}
+
+static int validate_gamma_entry(struct ipipe_gamma_entry *table, int size)
+{
+	int i;
+
+	if (!table)
+		return -EINVAL;
+
+	for (i = 0; i < size; i++) {
+		if (table[i].slope > GAMMA_MASK ||
+		    table[i].offset > GAMMA_MASK)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+validate_gamma_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	int table_size;
+	int err;
+
+	if (oper_state->gamma.bypass_r > 1 ||
+	    oper_state->gamma.bypass_b > 1 ||
+	    oper_state->gamma.bypass_g > 1)
+		return -EINVAL;
+
+	if (oper_state->gamma.tbl_sel != IPIPE_GAMMA_TBL_RAM)
+		return 0;
+
+	table_size = oper_state->gamma.tbl_size;
+	if (!oper_state->gamma.bypass_r) {
+		err = validate_gamma_entry(oper_state->gamma.table_r,
+							table_size);
+		if (err) {
+			dev_err(dev, "GAMMA R - table entry invalid\n");
+			return err;
+		}
+	}
+	if (!oper_state->gamma.bypass_b) {
+		err = validate_gamma_entry(oper_state->gamma.table_b,
+							table_size);
+		if (err) {
+			dev_err(dev, "GAMMA B - table entry invalid\n");
+			return err;
+		}
+	}
+	if (!oper_state->gamma.bypass_g) {
+		err = validate_gamma_entry(oper_state->gamma.table_g,
+							table_size);
+		if (err) {
+			dev_err(dev, "GAMMA G - table entry invalid\n");
+			return err;
+		}
+	}
+	return 0;
+}
+
+static int
+set_gamma_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gamma *gamma_param = (struct prev_gamma *)param;
+	int table_size;
+
+	if (!gamma_param) {
+		/* Copy defaults for gamma */
+		oper_state->gamma.bypass_r = dm365_gamma_defaults.bypass_r;
+		oper_state->gamma.bypass_g = dm365_gamma_defaults.bypass_g;
+		oper_state->gamma.bypass_b = dm365_gamma_defaults.bypass_b;
+		oper_state->gamma.tbl_sel = dm365_gamma_defaults.tbl_sel;
+		oper_state->gamma.tbl_size = dm365_gamma_defaults.tbl_size;
+		/* By default, we bypass the gamma correction.
+		 * So no values by default for tables
+		 */
+		goto success;
+	}
+	if (len != sizeof(struct prev_gamma)) {
+		dev_err(dev,
+			"set_gamma_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+
+	oper_state->gamma.bypass_r = gamma_param->bypass_r;
+	oper_state->gamma.bypass_b = gamma_param->bypass_b;
+	oper_state->gamma.bypass_g = gamma_param->bypass_g;
+	oper_state->gamma.tbl_sel = gamma_param->tbl_sel;
+	oper_state->gamma.tbl_size = gamma_param->tbl_size;
+
+	if (validate_gamma_params(dev, oper_state) < 0)
+		return -EINVAL;
+
+	if (gamma_param->tbl_sel != IPIPE_GAMMA_TBL_RAM)
+		goto success;
+
+	table_size = oper_state->gamma.tbl_size;
+
+	if (!gamma_param->bypass_r) {
+		if (!memcpy((void *)&oper_state->gamma.table_r,
+				    (void *)&gamma_param->table_r, (table_size *
+				    sizeof(struct ipipe_gamma_entry)))) {
+			dev_err(dev,
+			"set_gamma_params: Error in copying bypass_r table\n");
+			return -EFAULT;
+		}
+	}
+
+	if (!gamma_param->bypass_b) {
+		if (!memcpy((void *)&oper_state->gamma.table_b,
+				    (void *)&gamma_param->table_b, (table_size *
+				    sizeof(struct ipipe_gamma_entry)))) {
+			dev_err(dev,
+			"set_gamma_params: Error in copying bypass_b table\n");
+			return -EFAULT;
+		}
+	}
+
+	if (!gamma_param->bypass_g) {
+		if (!memcpy((void *)&oper_state->gamma.table_g,
+				    (void *)&gamma_param->table_g, (table_size *
+				    sizeof(struct ipipe_gamma_entry)))) {
+			dev_err(dev,
+			"set_gamma_params: Error in copying bypass_g table\n");
+			return -EFAULT;
+		}
+	}
+
+success:
+	ipipe_set_gamma_regs(&oper_state->gamma);
+
+	return 0;
+}
+
+static int
+get_gamma_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gamma *gamma_param = (struct prev_gamma *)param;
+	int table_size;
+
+	if (len != sizeof(struct prev_gamma)) {
+		dev_err(dev,
+			"get_gamma_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	gamma_param->bypass_r = oper_state->gamma.bypass_r;
+	gamma_param->bypass_g = oper_state->gamma.bypass_g;
+	gamma_param->bypass_b = oper_state->gamma.bypass_b;
+	gamma_param->tbl_sel = oper_state->gamma.tbl_sel;
+	gamma_param->tbl_size = oper_state->gamma.tbl_size;
+
+	if (oper_state->gamma.tbl_sel != IPIPE_GAMMA_TBL_RAM)
+		return 0;
+
+	table_size = oper_state->gamma.tbl_size;
+	if (!oper_state->gamma.bypass_r && !gamma_param->table_r) {
+		dev_err(dev,
+			"get_gamma_params: table ptr empty for R\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)gamma_param->table_r,
+		(void *)oper_state->gamma.table_r, (table_size *
+				sizeof(struct ipipe_gamma_entry)))) {
+		dev_err(dev, "get_gamma_params: R-Table Error in copy\n");
+		return -EFAULT;
+	}
+
+	if (!oper_state->gamma.bypass_g && !gamma_param->table_g) {
+		dev_err(dev, "get_gamma_params: table ptr empty for G\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)gamma_param->table_g,
+		(void *)oper_state->gamma.table_g, (table_size *
+		sizeof(struct ipipe_gamma_entry)))) {
+		dev_err(dev, "get_gamma_params: G-Table copy error\n");
+		return -EFAULT;
+	}
+
+	if (!oper_state->gamma.bypass_b && !gamma_param->table_b) {
+		dev_err(dev, "get_gamma_params: table ptr empty for B\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)gamma_param->table_b,
+		(void *)oper_state->gamma.table_b, (table_size *
+				sizeof(struct ipipe_gamma_entry)))) {
+		dev_err(dev, "set_gamma_params: B-Table Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_3d_lut_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	int i;
+
+	if (!oper_state->lut_3d.en)
+		return 0;
+
+	for (i = 0; i < MAX_SIZE_3D_LUT; i++) {
+		if (oper_state->lut_3d.table[i].r > D3_LUT_ENTRY_MASK ||
+		    oper_state->lut_3d.table[i].g > D3_LUT_ENTRY_MASK ||
+		    oper_state->lut_3d.table[i].b > D3_LUT_ENTRY_MASK)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static int get_3d_lut_params(struct device *dev, void *ipipe,
+						void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_3d_lut *lut_param = (struct prev_3d_lut *)param;
+
+	if (len != sizeof(struct prev_3d_lut)) {
+		dev_err(dev,
+			"get_3d_lut_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+
+	lut_param->en = oper_state->lut_3d.en;
+	if (!lut_param->table) {
+		dev_err(dev, "get_3d_lut_params: Invalid table ptr\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)lut_param->table, (void *)oper_state->lut_3d.table,
+		(MAX_SIZE_3D_LUT * sizeof(struct ipipe_3d_lut_entry)))) {
+		dev_err(dev, "get_3d_lut_params:Table Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+set_3d_lut_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_3d_lut *lut_param = (struct prev_3d_lut *)param;
+
+	if (!lut_param) {
+		/* Copy defaults for gamma */
+		oper_state->lut_3d.en = dm365_3d_lut_defaults.en;
+		/* By default, 3D lut is disabled
+		 */
+	} else {
+		if (len != sizeof(struct prev_3d_lut)) {
+			dev_err(dev,
+			"set_3d_lut_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->lut_3d, (void *)lut_param,
+				   sizeof(struct prev_3d_lut))) {
+			dev_err(dev, "set_3d_lut_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+		if (validate_3d_lut_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_3d_lut_regs(&oper_state->lut_3d);
+
+	return 0;
+}
+
+static int
+validate_rgb2yuv_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	if (oper_state->rgb2yuv.coef_ry.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_ry.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_gy.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_gy.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_by.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_by.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_rcb.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_rcb.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_gcb.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_gcb.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_bcb.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_bcb.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_rcr.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_rcr.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_gcr.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_gcr.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.coef_bcr.decimal > RGB2YCBCR_COEF_DECI_MASK ||
+	    oper_state->rgb2yuv.coef_bcr.integer > RGB2YCBCR_COEF_INT_MASK)
+		return -EINVAL;
+
+	if (oper_state->rgb2yuv.out_ofst_y > RGB2YCBCR_OFST_MASK ||
+	    oper_state->rgb2yuv.out_ofst_cb > RGB2YCBCR_OFST_MASK ||
+	    oper_state->rgb2yuv.out_ofst_cr > RGB2YCBCR_OFST_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int
+set_rgb2yuv_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_rgb2yuv *rgb2yuv_param = (struct prev_rgb2yuv *)param;
+
+	if (!rgb2yuv_param) {
+		/* Copy defaults for rgb2yuv conversion  */
+		memcpy((void *)&oper_state->rgb2yuv,
+		       (void *)&dm365_rgb2yuv_defaults,
+		       sizeof(struct prev_rgb2yuv));
+	} else {
+		if (len != sizeof(struct prev_rgb2yuv)) {
+			dev_err(dev,
+			"set_rgb2yuv_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->rgb2yuv,
+			(void *)rgb2yuv_param, sizeof(struct prev_rgb2yuv))) {
+			dev_err(dev, "set_rgb2yuv_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+		if (validate_rgb2yuv_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_rgb2ycbcr_regs(&oper_state->rgb2yuv);
+
+	return 0;
+}
+
+static int
+get_rgb2yuv_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_rgb2yuv *rgb2yuv_param = (struct prev_rgb2yuv *)param;
+
+	if (len != sizeof(struct prev_rgb2yuv)) {
+		dev_err(dev,
+			"get_rgb2yuv_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)rgb2yuv_param, (void *)&oper_state->rgb2yuv,
+		sizeof(struct prev_rgb2yuv))) {
+		dev_err(dev, "get_rgb2yuv_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_gbce_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	u32 max = GBCE_Y_VAL_MASK;
+	int i;
+
+	if (!oper_state->gbce.en)
+		return 0;
+
+	if (oper_state->gbce.type == IPIPE_GBCE_GAIN_TBL)
+		max = GBCE_GAIN_VAL_MASK;
+	for (i = 0; i < MAX_SIZE_GBCE_LUT; i++)
+		if (oper_state->gbce.table[i] > max)
+			return -EINVAL;
+	return 0;
+}
+
+static int
+set_gbce_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gbce *gbce_param = (struct prev_gbce *)param;
+
+	if (!gbce_param) {
+		/* Copy defaults for gamma */
+		oper_state->gbce.en = dm365_gbce_defaults.en;
+		/* By default, GBCE is disabled
+		 */
+	} else {
+		if (len != sizeof(struct prev_gbce)) {
+			dev_err(dev,
+			"set_gbce_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->gbce, (void *)gbce_param,
+				   sizeof(struct prev_gbce))) {
+			dev_err(dev, "set_gbce_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+		if (validate_gbce_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_gbce_regs(&oper_state->gbce);
+
+	return 0;
+}
+
+static int
+get_gbce_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_gbce *gbce_param = (struct prev_gbce *)param;
+
+	if (len != sizeof(struct prev_gbce)) {
+		dev_err(dev,
+			"get_gbce_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+
+	gbce_param->en = oper_state->gbce.en;
+	gbce_param->type = oper_state->gbce.type;
+	if (!gbce_param->table) {
+		dev_err(dev, "get_gbce_params: Invalid table ptr\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)gbce_param->table, (void *)oper_state->gbce.table,
+		(MAX_SIZE_GBCE_LUT * sizeof(unsigned short)))) {
+		dev_err(dev, "get_gbce_params:Table Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_yuv422_conv_params(struct device *dev,
+			    struct ipipe_oper_state *oper_state)
+{
+	if (oper_state->yuv422_conv.en_chrom_lpf > 1)
+		return -EINVAL;
+	return 0;
+}
+
+static int
+set_yuv422_conv_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_yuv422_conv *yuv422_conv_param =
+					(struct prev_yuv422_conv *)param;
+
+	if (!yuv422_conv_param) {
+		/* Copy defaults for yuv 422 conversion */
+		memcpy((void *)&oper_state->yuv422_conv,
+		       (void *)&dm365_yuv422_conv_defaults,
+		       sizeof(struct prev_yuv422_conv));
+	} else {
+		if (len != sizeof(struct prev_yuv422_conv)) {
+			dev_err(dev,
+			"set_yuv422_conv_params: struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->yuv422_conv,
+		  (void *)yuv422_conv_param, sizeof(struct prev_yuv422_conv))) {
+			dev_err(dev, "set_yuv422_conv_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+		if (validate_yuv422_conv_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_yuv422_conv_regs(&oper_state->yuv422_conv);
+
+	return 0;
+}
+
+static int
+get_yuv422_conv_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_yuv422_conv *yuv422_conv_param =
+				(struct prev_yuv422_conv *)param;
+
+	if (len != sizeof(struct prev_yuv422_conv)) {
+		dev_err(dev,
+		     "get_yuv422_conv_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)yuv422_conv_param, (void *)&oper_state->yuv422_conv,
+				sizeof(struct prev_yuv422_conv))) {
+		dev_err(dev, "get_yuv422_conv_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_yee_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	int i;
+
+	if (oper_state->yee.en > 1 ||
+	    oper_state->yee.en_halo_red > 1 ||
+	    oper_state->yee.hpf_shft > YEE_HPF_SHIFT_MASK)
+		return -EINVAL;
+
+	if (oper_state->yee.hpf_coef_00 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_01 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_02 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_10 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_11 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_12 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_20 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_21 > YEE_COEF_MASK ||
+	    oper_state->yee.hpf_coef_22 > YEE_COEF_MASK)
+		return -EINVAL;
+
+	if (oper_state->yee.yee_thr > YEE_THR_MASK ||
+	    oper_state->yee.es_gain > YEE_ES_GAIN_MASK ||
+	    oper_state->yee.es_thr1 > YEE_ES_THR1_MASK ||
+	    oper_state->yee.es_thr2 > YEE_THR_MASK ||
+	    oper_state->yee.es_gain_grad > YEE_THR_MASK ||
+	    oper_state->yee.es_ofst_grad > YEE_THR_MASK)
+		return -EINVAL;
+
+	for (i = 0; i < MAX_SIZE_YEE_LUT ; i++)
+		if (oper_state->yee.table[i] > YEE_ENTRY_MASK)
+			return -EINVAL;
+	return 0;
+}
+
+static int
+set_yee_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_yee *yee_param = (struct prev_yee *)param;
+
+	if (!yee_param) {
+		/* Copy defaults for ns */
+		memcpy((void *)&oper_state->yee, (void *)&dm365_yee_defaults,
+		       sizeof(struct prev_yee));
+	} else {
+		if (len != sizeof(struct prev_yee)) {
+			dev_err(dev,
+			     "set_yee_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->yee, (void *)yee_param,
+				   sizeof(struct prev_yee))) {
+			dev_err(dev, "set_yee_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+
+		if (validate_yee_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_ee_regs(&oper_state->yee);
+
+	return 0;
+}
+
+static int
+get_yee_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_yee *yee_param = (struct prev_yee *)param;
+
+	if (len != sizeof(struct prev_yee)) {
+		dev_err(dev, "get_yee_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	yee_param->en = oper_state->yee.en;
+	yee_param->en_halo_red = oper_state->yee.en_halo_red;
+	yee_param->merge_meth = oper_state->yee.merge_meth;
+	yee_param->hpf_shft = oper_state->yee.hpf_shft;
+	yee_param->hpf_coef_00 = oper_state->yee.hpf_coef_00;
+	yee_param->hpf_coef_01 = oper_state->yee.hpf_coef_01;
+	yee_param->hpf_coef_02 = oper_state->yee.hpf_coef_02;
+	yee_param->hpf_coef_10 = oper_state->yee.hpf_coef_10;
+	yee_param->hpf_coef_11 = oper_state->yee.hpf_coef_11;
+	yee_param->hpf_coef_12 = oper_state->yee.hpf_coef_12;
+	yee_param->hpf_coef_20 = oper_state->yee.hpf_coef_20;
+	yee_param->hpf_coef_21 = oper_state->yee.hpf_coef_21;
+	yee_param->hpf_coef_22 = oper_state->yee.hpf_coef_22;
+	yee_param->yee_thr = oper_state->yee.yee_thr;
+	yee_param->es_gain = oper_state->yee.es_gain;
+	yee_param->es_thr1 = oper_state->yee.es_thr1;
+	yee_param->es_thr2 = oper_state->yee.es_thr2;
+	yee_param->es_gain_grad = oper_state->yee.es_gain_grad;
+	yee_param->es_ofst_grad = oper_state->yee.es_ofst_grad;
+	if (!memcpy((void *)yee_param->table, (void *)oper_state->yee.table,
+		(MAX_SIZE_YEE_LUT * sizeof(short)))) {
+		dev_err(dev, "get_yee_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_car_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	if (oper_state->car.en > 1 ||
+	    oper_state->car.hpf_shft > CAR_HPF_SHIFT_MASK ||
+	    oper_state->car.gain1.shft > CAR_GAIN1_SHFT_MASK ||
+	    oper_state->car.gain1.gain_min > CAR_GAIN_MIN_MASK ||
+	    oper_state->car.gain2.shft > CAR_GAIN2_SHFT_MASK ||
+	    oper_state->car.gain2.gain_min > CAR_GAIN_MIN_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int
+set_car_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_car *car_param = (struct prev_car *)param;
+
+	if (!car_param) {
+		/* Copy defaults for ns */
+		memcpy((void *)&oper_state->car, (void *)&dm365_car_defaults,
+				sizeof(struct prev_car));
+	} else {
+		if (len != sizeof(struct prev_car)) {
+			dev_err(dev,
+			    "set_car_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->car, (void *)car_param,
+					sizeof(struct prev_car))) {
+			dev_err(dev, "set_car_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+		if (validate_car_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_car_regs(&oper_state->car);
+
+	return 0;
+}
+
+static int
+get_car_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_car *car_param = (struct prev_car *)param;
+
+	if (len != sizeof(struct prev_car)) {
+		dev_err(dev, "get_car_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)car_param, (void *)&oper_state->car,
+		sizeof(struct prev_car))) {
+		dev_err(dev, "get_car_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int
+validate_cgs_params(struct device *dev, struct ipipe_oper_state *oper_state)
+{
+	if (oper_state->cgs.en > 1 ||
+			oper_state->cgs.h_shft > CAR_SHIFT_MASK)
+		return -EINVAL;
+	return 0;
+}
+
+static int
+set_cgs_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_cgs *cgs_param = (struct prev_cgs *)param;
+
+	if (!cgs_param) {
+		/* Copy defaults for ns */
+		memcpy((void *)&oper_state->cgs, (void *)&dm365_cgs_defaults,
+				sizeof(struct prev_cgs));
+	} else {
+		if (len != sizeof(struct prev_cgs)) {
+			dev_err(dev,
+			    "set_cgs_params: param struct length mismatch\n");
+			return -EINVAL;
+		}
+		if (!memcpy((void *)&oper_state->cgs, (void *)cgs_param,
+					sizeof(struct prev_cgs))) {
+			dev_err(dev, "set_cgs_params: Error in memcpy\n");
+			return -EFAULT;
+		}
+		if (validate_cgs_params(dev, oper_state) < 0)
+			return -EINVAL;
+	}
+
+	ipipe_set_cgs_regs(&oper_state->cgs);
+
+	return 0;
+}
+
+static int
+get_cgs_params(struct device *dev, void *ipipe, void *param, int len)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct prev_cgs *cgs_param = (struct prev_cgs *)param;
+
+	if (len != sizeof(struct prev_cgs)) {
+		dev_err(dev,
+			"get_cgs_params: param struct length mismatch\n");
+		return -EINVAL;
+	}
+	if (!memcpy((void *)cgs_param, (void *)&oper_state->cgs,
+		sizeof(struct prev_cgs))) {
+		dev_err(dev, "get_cgs_params: Error in copy\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static struct prev_module_if prev_modules[PREV_MAX_MODULES] = {
+	/* PREV_IPIPEIF */ {
+		offsetof(struct vpfe_prev_params, ipipeif_config),
+		FIELD_SIZEOF(struct vpfe_prev_params, ipipeif_config),
+		offsetof(struct vpfe_prev_config, ipipeif_config),
+		NULL,
+		NULL,
+	}, /* PREV_LUTDPC */ {
+		offsetof(struct vpfe_prev_params, lutdpc),
+		FIELD_SIZEOF(struct vpfe_prev_params, lutdpc),
+		offsetof(struct vpfe_prev_config, lutdpc),
+		set_lutdpc_params,
+		get_lutdpc_params,
+	}, /* PREV_OTFDPC */ {
+		offsetof(struct vpfe_prev_params, otfdpc),
+		FIELD_SIZEOF(struct vpfe_prev_params, otfdpc),
+		offsetof(struct vpfe_prev_config, otfdpc),
+		set_otfdpc_params,
+		get_otfdpc_params,
+	}, /* PREV_NF1 */ {
+		offsetof(struct vpfe_prev_params, nf1),
+		FIELD_SIZEOF(struct vpfe_prev_params, nf1),
+		offsetof(struct vpfe_prev_config, nf1),
+		set_nf1_params,
+		get_nf1_params,
+	}, /* PREV_NF2 */ {
+		offsetof(struct vpfe_prev_params, nf2),
+		FIELD_SIZEOF(struct vpfe_prev_params, nf2),
+		offsetof(struct vpfe_prev_config, nf2),
+		set_nf2_params,
+		get_nf2_params,
+	}, /* PREV_WB */ {
+		offsetof(struct vpfe_prev_params, wbal),
+		FIELD_SIZEOF(struct vpfe_prev_params, wbal),
+		offsetof(struct vpfe_prev_config, wbal),
+		set_wb_params,
+		get_wb_params,
+	}, /* PREV_RGB2RGB_1 */ {
+		offsetof(struct vpfe_prev_params, rgb2rgb1),
+		FIELD_SIZEOF(struct vpfe_prev_params, rgb2rgb1),
+		offsetof(struct vpfe_prev_config, rgb2rgb1),
+		set_rgb2rgb_1_params,
+		get_rgb2rgb_1_params,
+	}, /*PREV_RGB2RGB_2 */ {
+		offsetof(struct vpfe_prev_params, rgb2rgb2),
+		FIELD_SIZEOF(struct vpfe_prev_params, rgb2rgb2),
+		offsetof(struct vpfe_prev_config, rgb2rgb2),
+		set_rgb2rgb_2_params,
+		get_rgb2rgb_2_params,
+	}, /* PREV_GAMMA */ {
+		offsetof(struct vpfe_prev_params, gamma),
+		FIELD_SIZEOF(struct vpfe_prev_params, gamma),
+		offsetof(struct vpfe_prev_config, gamma),
+		set_gamma_params,
+		get_gamma_params,
+	}, /* PREV_3D_LUT */ {
+		offsetof(struct vpfe_prev_params, lut),
+		FIELD_SIZEOF(struct vpfe_prev_params, lut),
+		offsetof(struct vpfe_prev_config, lut),
+		set_3d_lut_params,
+		get_3d_lut_params,
+	}, /* PREV_RGB2YUV */ {
+		offsetof(struct vpfe_prev_params, rgb2yuv),
+		FIELD_SIZEOF(struct vpfe_prev_params, rgb2yuv),
+		offsetof(struct vpfe_prev_config, rgb2yuv),
+		set_rgb2yuv_params,
+		get_rgb2yuv_params,
+	}, /* PREV_YUV422_CONV */ {
+		offsetof(struct vpfe_prev_params, yuv422_conv),
+		FIELD_SIZEOF(struct vpfe_prev_params, yuv422_conv),
+		offsetof(struct vpfe_prev_config, yuv422_conv),
+		set_yuv422_conv_params,
+		get_yuv422_conv_params,
+	}, /* PREV_YEE */ {
+		offsetof(struct vpfe_prev_params, yee),
+		FIELD_SIZEOF(struct vpfe_prev_params, yee),
+		offsetof(struct vpfe_prev_config, yee),
+		set_yee_params,
+		get_yee_params,
+	}, /* PREV_GIC */ {
+		offsetof(struct vpfe_prev_params, gic),
+		FIELD_SIZEOF(struct vpfe_prev_params, gic),
+		offsetof(struct vpfe_prev_config, gic),
+		set_gic_params,
+		get_gic_params,
+	}, /* PREV_CFA */ {
+		offsetof(struct vpfe_prev_params, cfa),
+		FIELD_SIZEOF(struct vpfe_prev_params, cfa),
+		offsetof(struct vpfe_prev_config, cfa),
+		set_cfa_params,
+		get_cfa_params,
+	}, /* PREV_CAR */ {
+		offsetof(struct vpfe_prev_params, car),
+		FIELD_SIZEOF(struct vpfe_prev_params, car),
+		offsetof(struct vpfe_prev_config, car),
+		set_car_params,
+		get_car_params,
+	}, /* PREV_CGS */ {
+		offsetof(struct vpfe_prev_params, cgs),
+		FIELD_SIZEOF(struct vpfe_prev_params, cgs),
+		offsetof(struct vpfe_prev_config, cgs),
+		set_cgs_params,
+		get_cgs_params,
+	}, /* PREV_GBCE */ {
+		offsetof(struct vpfe_prev_params, gbce),
+		FIELD_SIZEOF(struct vpfe_prev_params, gbce),
+		offsetof(struct vpfe_prev_config, gbce),
+		set_gbce_params,
+		get_gbce_params,
+	},
+};
+
+static int
+ipipe_set_preview_module_params(struct device *dev, void *ipipe,
+				struct vpfe_prev_config *cfg)
+{
+	unsigned int i;
+	int rval = 0;
+
+	for (i = 1; i < ARRAY_SIZE(prev_modules); i++) {
+		unsigned int bit = 1 << i;
+		if (cfg->flag & bit) {
+			const struct prev_module_if *module_if =
+						&prev_modules[i];
+			struct vpfe_prev_params *params;
+			void __user *from = *(void * __user *)
+				((void *)cfg + module_if->config_offset);
+			size_t size;
+			void *to;
+
+			params =
+			   kmalloc(sizeof(struct vpfe_prev_params), GFP_KERNEL);
+			to = (void *)params + module_if->param_offset;
+			size = module_if->param_size;
+
+			if (to && from && size) {
+				if (copy_from_user(to, from, size)) {
+					rval = -EFAULT;
+					break;
+				}
+				rval = module_if->set(dev, ipipe, to, size);
+				if (rval)
+					goto error;
+			} else if (to && !from && size) {
+				rval = module_if->set(dev, ipipe, NULL, size);
+				if (rval)
+					goto error;
+			}
+			kfree(params);
+		}
+	}
+error:
+	return rval;
+}
+
+static int
+ipipe_get_preview_module_params(struct device *dev, void *ipipe,
+				struct vpfe_prev_config *cfg)
+{
+	unsigned int i;
+	int rval = 0;
+
+	for (i = 1; i < ARRAY_SIZE(prev_modules); i++) {
+		unsigned int bit = 1 << i;
+		if (cfg->flag & bit) {
+			const struct prev_module_if *module_if =
+						&prev_modules[i];
+			struct vpfe_prev_params *params;
+			void __user *to = *(void * __user *)
+				((void *)cfg + module_if->config_offset);
+			size_t size;
+			void *from;
+
+			params =  kmalloc(sizeof(struct vpfe_prev_params),
+						GFP_KERNEL);
+			from = (void *)params + module_if->param_offset;
+			size = module_if->param_size;
+
+			if (to && from && size) {
+				rval = module_if->get(dev, ipipe, from, size);
+				if (rval)
+					goto error;
+				if (copy_to_user(to, from, size)) {
+					rval = -EFAULT;
+					break;
+				}
+			}
+			kfree(params);
+		}
+	}
+error:
+	return rval;
+}
+
+static int preview_s_ctrl(void *ipipe, u32 ctrl_id, s32 val)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	switch (ctrl_id) {
+	case V4L2_CID_BRIGHTNESS:
+		oper_state->lum_adj.brightness = val;
+		ipipe_set_lum_adj_regs(&oper_state->lum_adj);
+		break;
+	case V4L2_CID_CONTRAST:
+		oper_state->lum_adj.contrast = val;
+		ipipe_set_lum_adj_regs(&oper_state->lum_adj);
+		break;
+	case V4L2_CID_DPCM_PREDICTOR:
+		dpcm_predictor = val;
+		break;
+	case V4L2_CID_GAIN:
+		ipipeif_gain = val;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct prev_module_if *prev_enum_preview_cap(struct device *dev,
+						    unsigned int index)
+{
+	dev_dbg(dev, "prev_enum_preview_cap: index = %d\n", index);
+
+	if (index < 0 || index >= PREV_MAX_MODULES)
+		return NULL;
+
+	return &prev_modules[index];
+}
+
+static int ipipe_set_oper_mode(void *ipipe, unsigned int mode)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (oper_state->oper_mode != IMP_MODE_NOT_CONFIGURED) {
+		pr_err("IPIPE is already active!\n");
+		return -EINVAL;
+	}
+	oper_state->oper_mode = mode;
+
+	return 0;
+}
+
+static void ipipe_reset_oper_mode(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	oper_state->oper_mode = IMP_MODE_NOT_CONFIGURED;
+	oper_state->prev_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_chained = 0;
+	oper_state->rsz_output_enabled[RSZ_A] = DISABLE;
+	oper_state->rsz_output_enabled[RSZ_B] = DISABLE;
+}
+
+static unsigned int prev_get_oper_mode(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->oper_mode;
+}
+
+static unsigned int ipipe_get_oper_state(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->state;
+}
+
+static void ipipe_set_oper_state(void *ipipe, unsigned int state)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	mutex_lock(&oper_state->lock);
+	oper_state->state = state;
+	mutex_unlock(&oper_state->lock);
+}
+
+static unsigned int ipipe_get_prev_config_state(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->prev_config_state;
+}
+
+static unsigned int ipipe_get_rsz_config_state(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	return oper_state->rsz_config_state;
+}
+
+/* function: calculate_normal_f_div_param
+ * Algorithm to calculate the frame division parameters for resizer.
+ * in normal mode. Please refer the application note in DM360 functional
+ * spec for details of the algorithm
+ */
+static int
+calculate_normal_f_div_param(struct device *dev,
+			     int input_width,
+			     int output_width,
+			     struct ipipe_rsz_rescale_param *param)
+{
+	/* rsz = R, input_width = H, output width = h in the equation */
+	unsigned int val1;
+	unsigned int rsz;
+	unsigned int val;
+	unsigned int h1;
+	unsigned int h2;
+	unsigned int o;
+
+	if (output_width > input_width) {
+		dev_err(dev, "frame div mode is used for scale down only\n");
+		return -EINVAL;
+	}
+
+	rsz = (input_width << 8) / output_width;
+	val = rsz << 1;
+	val = ((input_width << 8) / val) + 1;
+	o = 14;
+	if (!(val % 2)) {
+		h1 = val;
+	} else {
+		val = (input_width << 7);
+		val -= rsz >> 1;
+		val /= rsz << 1;
+		val <<= 1;
+		val += 2;
+		o += ((CEIL(rsz, 1024)) << 1);
+		h1 = val;
+	}
+	h2 = output_width - h1;
+	/* phi */
+	val = (h1 * rsz) - (((input_width >> 1) - o) << 8);
+	/* skip */
+	val1 = ((val - 1024) >> 9) << 1;
+	param->f_div.num_passes = IPIPE_MAX_PASSES;
+	param->f_div.pass[0].o_hsz = h1 - 1;
+	param->f_div.pass[0].i_hps = 0;
+	param->f_div.pass[0].h_phs = 0;
+	param->f_div.pass[0].src_hps = 0;
+	param->f_div.pass[0].src_hsz = (input_width >> 2) + o;
+	param->f_div.pass[1].o_hsz = h2 - 1;
+	param->f_div.pass[1].i_hps = val1;
+	param->f_div.pass[1].h_phs = (val - (val1 << 8));
+	param->f_div.pass[1].src_hps = (input_width >> 2) - o;
+	param->f_div.pass[1].src_hsz = (input_width >> 2) + o;
+
+	return 0;
+}
+
+/* function: calculate_down_scale_f_div_param
+ * Algorithm to calculate the frame division parameters for resizer in
+ * downscale mode. Please refer the application note in DM360 functional
+ * spec for details of the algorithm
+ */
+static int
+calculate_down_scale_f_div_param(struct device *dev,
+				 int input_width, int output_width,
+				 struct ipipe_rsz_rescale_param *param)
+{
+	/* rsz = R, input_width = H, output width = h in the equation */
+	unsigned int two_power;
+	unsigned int upper_h1;
+	unsigned int upper_h2;
+	unsigned int val1;
+	unsigned int val;
+	unsigned int rsz;
+	unsigned int h1;
+	unsigned int h2;
+	unsigned int o;
+	unsigned int n;
+
+	upper_h1 = input_width >> 1;
+	n = param->h_dscale_ave_sz;
+	/* 2 ^ (scale+1) */
+	two_power = 1 << (n + 1);
+	upper_h1 = (upper_h1 >> (n + 1)) << (n + 1);
+	upper_h2 = input_width - upper_h1;
+	if (upper_h2 % two_power) {
+		dev_err(dev, "frame halves to be a multiple of 2 power n+1\n");
+		return -EINVAL;
+	}
+	two_power = 1 << n;
+	rsz = (input_width << 8) / output_width;
+	val = rsz * two_power;
+	val = ((upper_h1 << 8) / val) + 1;
+	if (!(val % 2))
+		h1 = val;
+	else {
+		val = upper_h1 << 8;
+		val >>= n + 1;
+		val -= rsz >> 1;
+		val /= rsz << 1;
+		val <<= 1;
+		val += 2;
+		h1 = val;
+	}
+	o = 10 + (two_power << 2);
+	if (((input_width << 7) / rsz) % 2)
+		o += (((CEIL(rsz, 1024)) << 1) << n);
+	h2 = output_width - h1;
+	/* phi */
+	val = (h1 * rsz) - (((upper_h1 - (o - 10)) / two_power) << 8);
+	/* skip */
+	val1 = ((val - 1024) >> 9) << 1;
+	param->f_div.num_passes = IPIPE_MAX_PASSES;
+	param->f_div.pass[0].o_hsz = h1 - 1;
+	param->f_div.pass[0].i_hps = 0;
+	param->f_div.pass[0].h_phs = 0;
+	param->f_div.pass[0].src_hps = 0;
+	param->f_div.pass[0].src_hsz = upper_h1 + o;
+	param->f_div.pass[1].o_hsz = h2 - 1;
+	param->f_div.pass[1].i_hps = 10 + (val1 * two_power);
+	param->f_div.pass[1].h_phs = (val - (val1 << 8));
+	param->f_div.pass[1].src_hps = upper_h1 - o;
+	param->f_div.pass[1].src_hsz = upper_h2 + o;
+
+	return 0;
+}
+
+/* update the parameter in param for a given input and output width */
+static int
+update_preview_f_div_params(struct device *dev,
+			    int input_width, int output_width,
+			    struct ipipe_rsz_rescale_param *param)
+{
+	unsigned int val;
+
+	val = input_width >> 1;
+	if (val < 8) {
+		dev_err(dev, "input width must me atleast 16 pixels\n");
+		return -EINVAL;
+	}
+	param->f_div.en = 1;
+	param->f_div.num_passes = IPIPE_MAX_PASSES;
+	param->f_div.pass[0].o_hsz = val;
+	param->f_div.pass[0].i_hps = 0;
+	param->f_div.pass[0].h_phs = 0;
+	param->f_div.pass[0].src_hps = 0;
+	param->f_div.pass[0].src_hsz = val + 10;
+	param->f_div.pass[1].o_hsz = val;
+	param->f_div.pass[1].i_hps = 0;
+	param->f_div.pass[1].h_phs = 0;
+	param->f_div.pass[1].src_hps = val - 8;
+	param->f_div.pass[1].src_hsz = val + 10;
+
+	return 0;
+}
+
+/* Use shared to allocate exclusive blocks as required
+ * by resize applications in single shot mode
+ */
+static void *ipipe_alloc_config_block(struct device *dev, void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	/* return common data block */
+	mutex_lock(&oper_state->lock);
+	if (oper_state->resource_in_use) {
+		dev_err(dev, "resource in use\n");
+		mutex_unlock(&oper_state->lock);
+		return NULL;
+	}
+	mutex_unlock(&oper_state->lock);
+
+	return oper_state->shared_config_param;
+}
+
+/* Used to free only non-shared config block allocated through
+ * imp_alloc_config_block
+ */
+static void
+ipipe_dealloc_config_block(struct device *dev, void *ipipe,
+			   void *config_block)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	if (!config_block)
+		return;
+
+	if (config_block != oper_state->shared_config_param)
+		kfree(config_block);
+	else
+		dev_err(dev, "Trying to free shared config block\n");
+}
+
+static void
+ipipe_dealloc_user_config_block(struct device *dev,
+				void *ipipe, void *config_block)
+{
+	kfree(config_block);
+}
+
+static void *
+ipipe_alloc_user_config_block(struct device *dev, void *ipipe,
+			      enum imp_log_chan_t chan_type)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	void *config = NULL;
+
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT) {
+		if (chan_type == IMP_PREVIEWER) {
+			config =
+			    kmalloc(sizeof(struct prev_ipipeif_config),
+				    GFP_KERNEL);
+		} else if (chan_type == IMP_RESIZER) {
+			config =
+			    kmalloc(sizeof(struct rsz_config),
+				    GFP_KERNEL);
+		}
+		return config;
+	}
+
+	if (chan_type == IMP_PREVIEWER) {
+		config = kmalloc(sizeof(struct prev_ipipeif_config),
+			    GFP_KERNEL);
+	} else if (chan_type == IMP_RESIZER) {
+		config = kmalloc(sizeof(struct rsz_config),
+			    GFP_KERNEL);
+	}
+
+	return config;
+}
+
+static void
+ipipe_set_user_config_defaults(struct device *dev, void *ipipe,
+			       enum imp_log_chan_t chan_type, void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	dev_dbg(dev, "ipipe_set_user_config_defaults\n");
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT) {
+		if (chan_type == IMP_PREVIEWER) {
+			dev_dbg(dev, "SS-Preview\n");
+			/* preview channel in single shot mode */
+			memcpy(config, (void *)&dm365_prev_ss_config_defs,
+			       sizeof(struct prev_ipipeif_config));
+		} else {
+			dev_dbg(dev, "SS-Resize\n");
+			/* resizer channel in single shot mode */
+			memcpy(config, (void *)&dm365_rsz_ss_config_defs,
+			       sizeof(struct rsz_config));
+		}
+	} else if (oper_state->oper_mode == IMP_MODE_CONTINUOUS) {
+		/* Continuous mode */
+		if (chan_type == IMP_PREVIEWER) {
+			dev_dbg(dev, "Continuous Preview\n");
+			/* previewer defaults */
+			memcpy(config, (void *)&dm365_prev_cont_config_defs,
+			       sizeof(struct prev_ipipeif_config));
+		} else {
+			dev_dbg(dev, "Continuous resize\n");
+			/* resizer defaults */
+			memcpy(config, (void *)&dm365_rsz_cont_config_defs,
+			       sizeof(struct rsz_config));
+		}
+	} else {
+		dev_err(dev, "Incorrect mode used\n");
+	}
+}
+
+/* function :calculate_sdram_offsets()
+ *	This function calculates the offsets from start of buffer for the C
+ *	plane when output format is YUV420SP. It also calculates the offsets
+ *	from the start of the buffer when the image is flipped vertically
+ *	or horizontally for ycbcr/y/c planes
+ */
+static int calculate_sdram_offsets(struct ipipe_params *param, int index)
+{
+	int bytesperpixel = 2;
+	int image_height;
+	int image_width;
+	int yuv_420;
+	int offset;
+
+	if (!param->rsz_en[index])
+		return -EINVAL;
+
+	image_height = param->rsz_rsc_param[index].o_vsz + 1;
+	image_width = param->rsz_rsc_param[index].o_hsz + 1;
+	param->ext_mem_param[index].c_offset = 0;
+	param->ext_mem_param[index].flip_ofst_y = 0;
+	param->ext_mem_param[index].flip_ofst_c = 0;
+	if (param->ipipe_dpaths_fmt != IPIPE_RAW2RAW &&
+	    param->ipipe_dpaths_fmt != IPIPE_RAW2BOX &&
+	    param->rsz_rsc_param[index].cen &&
+	    param->rsz_rsc_param[index].yen) {
+		/* YUV 420 */
+		yuv_420 = 1;
+		bytesperpixel = 1;
+	}
+
+	/* set offset value */
+	offset = 0;
+
+	if (param->rsz_rsc_param[index].h_flip)
+		/* width * bytesperpixel - 1 */
+		offset = (image_width * bytesperpixel) - 1;
+	if (param->rsz_rsc_param[index].v_flip)
+		offset += (image_height - 1) *
+			param->ext_mem_param[index].rsz_sdr_oft_y;
+	param->ext_mem_param[index].flip_ofst_y = offset;
+	if (yuv_420) {
+		offset = 0;
+		/* half height for c-plane */
+		if (param->rsz_rsc_param[index].h_flip)
+			/* width * bytesperpixel - 1 */
+			offset = image_width - 1;
+		if (param->rsz_rsc_param[index].v_flip)
+			offset += (((image_height >> 1) - 1) *
+			param->ext_mem_param[index].
+			rsz_sdr_oft_c);
+		param->ext_mem_param[index].flip_ofst_c =
+			offset;
+		param->ext_mem_param[index].c_offset =
+		    param->ext_mem_param[index].
+		    rsz_sdr_oft_y * image_height;
+	}
+
+	return 0;
+}
+
+static void
+enable_422_420_conversion(struct ipipe_params *param, int index, boolean_t en)
+{
+	/* Enable 422 to 420 conversion */
+	param->rsz_rsc_param[index].cen = en;
+	param->rsz_rsc_param[index].yen = en;
+}
+
+static void
+configure_resizer_out_params(struct ipipe_oper_state *oper_state,
+			     struct ipipe_params *param,
+			     int index, void *output_spec,
+			     unsigned char partial, unsigned flag)
+{
+	struct rsz_output_spec *output = (struct rsz_output_spec *)output_spec;
+
+	if (partial) {
+		if (!oper_state->rsz_output_enabled[index]) {
+			param->rsz_en[index] = DISABLE;
+			return;
+		}
+		param->rsz_en[index] = ENABLE;
+		param->rsz_rsc_param[index].h_flip = output->h_flip;
+		param->rsz_rsc_param[index].v_flip = output->v_flip;
+		param->rsz_rsc_param[index].v_typ_y = output->v_typ_y;
+		param->rsz_rsc_param[index].v_typ_c = output->v_typ_c;
+		param->rsz_rsc_param[index].v_lpf_int_y =
+						output->v_lpf_int_y;
+		param->rsz_rsc_param[index].v_lpf_int_c =
+						output->v_lpf_int_c;
+		param->rsz_rsc_param[index].h_typ_y = output->h_typ_y;
+		param->rsz_rsc_param[index].h_typ_c = output->h_typ_c;
+		param->rsz_rsc_param[index].h_lpf_int_y =
+						output->h_lpf_int_y;
+		param->rsz_rsc_param[index].h_lpf_int_c =
+						output->h_lpf_int_c;
+		param->rsz_rsc_param[index].dscale_en =
+						output->en_down_scale;
+		param->rsz_rsc_param[index].h_dscale_ave_sz =
+						output->h_dscale_ave_sz;
+		param->rsz_rsc_param[index].v_dscale_ave_sz =
+						output->v_dscale_ave_sz;
+		param->ext_mem_param[index].user_y_ofst =
+				    (output->user_y_ofst + 31) & ~0x1f;
+		param->ext_mem_param[index].user_c_ofst =
+				    (output->user_c_ofst + 31) & ~0x1f;
+		return;
+	}
+
+	if (!oper_state->rsz_output_enabled[index]) {
+		param->rsz_en[index] = DISABLE;
+		return;
+	}
+
+	param->rsz_en[index] = ENABLE;
+	param->rsz_rsc_param[index].o_vsz =
+		oper_state->out_mbus_format[index].height - 1;
+	param->rsz_rsc_param[index].o_hsz =
+		oper_state->out_mbus_format[index].width - 1;
+	param->ext_mem_param[index].rsz_sdr_ptr_s_y =
+				output->vst_y;
+	param->ext_mem_param[index].rsz_sdr_ptr_e_y =
+		oper_state->out_mbus_format[index].height;
+	param->ext_mem_param[index].rsz_sdr_ptr_s_c =
+				output->vst_c;
+	param->ext_mem_param[index].rsz_sdr_ptr_e_c =
+		oper_state->out_mbus_format[index].height;
+
+	if (!flag)
+		return;
+	/* update common parameters */
+	param->rsz_rsc_param[index].h_flip = output->h_flip;
+	param->rsz_rsc_param[index].v_flip = output->v_flip;
+	param->rsz_rsc_param[index].v_typ_y = output->v_typ_y;
+	param->rsz_rsc_param[index].v_typ_c = output->v_typ_c;
+	param->rsz_rsc_param[index].v_lpf_int_y = output->v_lpf_int_y;
+	param->rsz_rsc_param[index].v_lpf_int_c = output->v_lpf_int_c;
+	param->rsz_rsc_param[index].h_typ_y = output->h_typ_y;
+	param->rsz_rsc_param[index].h_typ_c = output->h_typ_c;
+	param->rsz_rsc_param[index].h_lpf_int_y = output->h_lpf_int_y;
+	param->rsz_rsc_param[index].h_lpf_int_c = output->h_lpf_int_c;
+	param->rsz_rsc_param[index].dscale_en = output->en_down_scale;
+	param->rsz_rsc_param[index].h_dscale_ave_sz = output->h_dscale_ave_sz;
+	param->rsz_rsc_param[index].v_dscale_ave_sz = output->h_dscale_ave_sz;
+	param->ext_mem_param[index].user_y_ofst =
+					(output->user_y_ofst + 31) & ~0x1f;
+	param->ext_mem_param[index].user_c_ofst =
+					(output->user_c_ofst + 31) & ~0x1f;
+}
+
+/* function :calculate_line_length()
+ *	This function calculates the line length of various image
+ *	planes at the input and output
+ */
+static void
+calculate_line_length(enum v4l2_mbus_pixelcode pix,
+		      int width, int height, int *line_len, int *line_len_c)
+{
+	*line_len = 0;
+	*line_len_c = 0;
+
+	if (pix == V4L2_MBUS_FMT_UYVY8_2X8 ||
+				pix == V4L2_MBUS_FMT_SGRBG12_1X12) {
+		*line_len = width << 1;
+	} else if (pix == V4L2_MBUS_FMT_Y8_1X8 ||
+				pix == V4L2_MBUS_FMT_UV8_1X8) {
+		*line_len = width;
+		*line_len_c = width;
+	} else {
+		/* YUV 420 */
+		/* round width to upper 32 byte boundary */
+		*line_len = width;
+		*line_len_c = width;
+	}
+	/* adjust the line len to be a multiple of 32 */
+	*line_len += 31;
+	*line_len &= ~0x1f;
+	*line_len_c += 31;
+	*line_len_c &= ~0x1f;
+}
+
+static inline int
+rsz_validate_input_image_format(struct device *dev,
+				enum v4l2_mbus_pixelcode pix,
+				int width, int height, int *line_len)
+{
+	int val;
+
+	if (pix != V4L2_MBUS_FMT_UYVY8_2X8 && pix != V4L2_MBUS_FMT_Y8_1X8 &&
+						pix != V4L2_MBUS_FMT_UV8_1X8) {
+		dev_err(dev,
+		"resizer validate output: pix format not supported, %d\n", pix);
+		return -EINVAL;
+	}
+
+	if (width == 0 || height == 0) {
+		dev_err(dev,
+			"resizer validate input: invalid width or height\n");
+		return -EINVAL;
+	}
+
+	if (pix == V4L2_MBUS_FMT_UV8_1X8)
+		calculate_line_length(pix, width, height, &val, line_len);
+	else
+		calculate_line_length(pix, width, height, line_len, &val);
+
+	return 0;
+}
+
+static inline int
+rsz_validate_output_image_format(struct device *dev,
+				 enum v4l2_mbus_pixelcode pix, int width,
+				 int height, int *in_line_len,
+				 int *in_line_len_c)
+{
+	if (pix != V4L2_MBUS_FMT_UYVY8_2X8 && pix != V4L2_MBUS_FMT_Y8_1X8 &&
+	    pix != V4L2_MBUS_FMT_UV8_1X8 && pix !=
+	    V4L2_MBUS_FMT_YDYUYDYV8_1X16 && pix != V4L2_MBUS_FMT_SGRBG12_1X12) {
+		dev_err(dev,
+		"resizer validate output: pix format not supported, %d\n", pix);
+		return -EINVAL;
+	}
+
+	if (width == 0 || height == 0) {
+		dev_err(dev,
+			"resizer validate output: invalid width or height\n");
+		return -EINVAL;
+	}
+
+	calculate_line_length(pix, width, height, in_line_len, in_line_len_c);
+	return 0;
+}
+
+static void
+configure_common_rsz_params(struct device *dev,
+			    struct ipipe_params *param,
+			    struct rsz_config *ss_config)
+{
+	param->rsz_common.yuv_y_min = ss_config->yuv_y_min;
+	param->rsz_common.yuv_y_max = ss_config->yuv_y_max;
+	param->rsz_common.yuv_c_min = ss_config->yuv_c_min;
+	param->rsz_common.yuv_c_max = ss_config->yuv_c_max;
+	param->rsz_common.out_chr_pos = ss_config->out_chr_pos;
+	param->rsz_common.rsz_seq_crv = ss_config->chroma_sample_even;
+
+}
+
+static int
+configure_common_rsz_in_params(struct device *dev,
+			       struct ipipe_oper_state *oper_state,
+			       struct ipipe_params *param,
+			       int flag, int rsz_chained,
+			       int vst, int hst)
+{
+	enum v4l2_mbus_pixelcode pix;
+
+	pix = oper_state->in_mbus_format.code;
+
+	if (!flag) {
+		param->rsz_common.vsz = oper_state->in_mbus_format.width - 1;
+		param->rsz_common.hsz = oper_state->in_mbus_format.height - 1;
+	} else {
+		if (!rsz_chained) {
+			param->rsz_common.vps = vst;
+			param->rsz_common.hps = hst;
+		}
+		param->rsz_common.vsz = oper_state->in_mbus_format.height - 1;
+		param->rsz_common.hsz = oper_state->in_mbus_format.width - 1;
+	}
+	switch (pix) {
+	case V4L2_MBUS_FMT_SBGGR8_1X8:
+	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SBGGR12_1X12:
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		param->rsz_common.src_img_fmt = RSZ_IMG_422;
+		param->rsz_common.source = IPIPE_DATA;
+		break;
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		param->rsz_common.src_img_fmt = RSZ_IMG_422;
+		if (rsz_chained)
+			param->rsz_common.source = IPIPE_DATA;
+		else
+			param->rsz_common.source = IPIPEIF_DATA;
+		param->rsz_common.raw_flip = 0;
+		break;
+	case V4L2_MBUS_FMT_Y8_1X8:
+		param->rsz_common.src_img_fmt = RSZ_IMG_420;
+		/* Select y */
+		param->rsz_common.y_c = 0;
+		param->rsz_common.source = IPIPEIF_DATA;
+		param->rsz_common.raw_flip = 0;
+		break;
+	case V4L2_MBUS_FMT_UV8_1X8:
+		param->rsz_common.src_img_fmt = RSZ_IMG_420;
+		/* Select y */
+		param->rsz_common.y_c = 1;
+		param->rsz_common.source = IPIPEIF_DATA;
+		param->rsz_common.raw_flip = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+validate_ipipeif_decimation(struct device *dev,
+			    enum ipipeif_decimation dec_en,
+			    unsigned char rsz, unsigned char frame_div_mode_en,
+			    int width)
+{
+	if (dec_en && frame_div_mode_en) {
+		dev_err(dev,
+		 "dec_en & frame_div_mode_en can not enabled simultaneously\n");
+		return -EINVAL;
+	}
+	if (frame_div_mode_en) {
+		dev_err(dev, "frame_div_mode mode not supported\n");
+		return -EINVAL;
+	}
+	if (!dec_en)
+		return 0;
+
+	if (width <= IPIPE_MAX_INPUT_WIDTH) {
+		dev_err(dev,
+			"image width to be more than %d for decimation\n",
+			IPIPE_MAX_INPUT_WIDTH);
+		return -EINVAL;
+	}
+	if (rsz < IPIPEIF_RSZ_MIN || rsz > IPIPEIF_RSZ_MAX) {
+		dev_err(dev, "rsz range is %d to %d\n",
+			IPIPEIF_RSZ_MIN, IPIPEIF_RSZ_MAX);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+ipipe_set_input_win(struct ipipe_oper_state *oper_state,
+		    struct v4l2_mbus_framefmt *format)
+{
+	struct ipipe_params *param = oper_state->shared_config_param;
+	struct imp_window win;
+
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT)
+		return 0;
+
+	/* init */
+	win.width = format->width;
+	win.height = format->height;
+	win.hst = 0;
+	win.vst = 1;
+
+	if (param->ipipeif_param.decimation)
+		param->ipipe_hsz = ((win.width * IPIPEIF_RSZ_CONST) /
+				param->ipipeif_param.rsz) - 1;
+	else
+		param->ipipe_hsz = win.width - 1;
+
+	if (oper_state->in_mbus_format.field == V4L2_FIELD_INTERLACED) {
+		param->ipipe_vsz = (win.height >> 1) - 1;
+		param->ipipe_vps = win.vst >> 1;
+	} else {
+		param->ipipe_vsz = win.height - 1;
+		param->ipipe_vps = win.vst;
+	}
+	param->ipipe_hps = win.hst;
+	param->rsz_common.vsz = param->ipipe_vsz;
+	param->rsz_common.hsz = param->ipipe_hsz;
+
+	return 0;
+}
+
+static int
+ipipe_set_out_pixel_format(struct ipipe_oper_state *oper_state,
+			   struct v4l2_mbus_framefmt *format)
+{
+	struct ipipe_params *param = oper_state->shared_config_param;
+	enum v4l2_mbus_pixelcode output_pix;
+	enum v4l2_mbus_pixelcode input_pix;
+
+	input_pix = oper_state->in_mbus_format.code;
+	output_pix = oper_state->out_mbus_format[RSZ_A].code;
+
+	/* if image is RAW, preserve raw image format while flipping.
+	 * otherwise preserve, preserve ycbcr format while flipping
+	 */
+	if (output_pix == V4L2_MBUS_FMT_SGRBG12_1X12)
+		param->rsz_common.raw_flip = 1;
+	else
+		param->rsz_common.raw_flip = 0;
+
+	return ipipe_process_pix_fmts(input_pix, output_pix, param);
+}
+
+static int
+ipipe_set_output_win(struct ipipe_oper_state *oper_state,
+		     struct v4l2_mbus_framefmt *format)
+{
+	struct ipipe_params *param = oper_state->shared_config_param;
+	struct rsz_output_spec output_specs;
+	enum v4l2_mbus_pixelcode out_pix;
+	struct imp_window win;
+	int ret = -EINVAL;
+	int line_len_c;
+	int line_len;
+
+	/* for single-shot output window settings
+	   are done as part of set config */
+	if (oper_state->oper_mode == IMP_MODE_SINGLE_SHOT)
+		return 0;
+
+	win.width = format->width;
+	/* Always set output height same as in height
+	   for de-interlacing
+	 */
+	win.height = format->height;
+	win.hst = 0;
+	win.vst = 0;
+
+	if (!param->rsz_en[RSZ_A]) {
+		pr_err("Resizer output1 not enabled\n");
+		return ret;
+	}
+
+	output_specs.vst_y = win.vst;
+
+	if (oper_state->out_mbus_format[RSZ_A].code ==
+				V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+		output_specs.vst_c = win.vst;
+
+	configure_resizer_out_params(oper_state, param, RSZ_A,
+						&output_specs, 0, 0);
+	out_pix = oper_state->out_mbus_format[RSZ_A].code;
+	calculate_line_length(out_pix, param->rsz_rsc_param[0].o_hsz + 1,
+			param->rsz_rsc_param[0].o_vsz + 1, &line_len,
+					&line_len_c);
+	param->ext_mem_param[0].rsz_sdr_oft_y = line_len;
+	param->ext_mem_param[0].rsz_sdr_oft_c = line_len_c;
+	calculate_resize_ratios(param, RSZ_A);
+
+	if (param->rsz_en[RSZ_B])
+		calculate_resize_ratios(param, RSZ_B);
+
+	if (oper_state->out_mbus_format[RSZ_A].code ==
+				V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+		enable_422_420_conversion(param, RSZ_A, ENABLE);
+	else
+		enable_422_420_conversion(param, RSZ_A, DISABLE);
+
+	ret = calculate_sdram_offsets(param, RSZ_A);
+	if (param->rsz_en[RSZ_B])
+		ret = calculate_sdram_offsets(param, RSZ_B);
+
+	if (ret)
+		pr_err("Error in calculating sdram offsets\n");
+
+	return ret;
+}
+
+static int configure_formats_in_cont_mode(struct ipipe_oper_state *oper_state)
+{
+	struct v4l2_mbus_framefmt *in_format = &oper_state->in_mbus_format;
+	struct v4l2_mbus_framefmt *out_format =
+					&oper_state->out_mbus_format[RSZ_A];
+	struct ipipe_params *param = oper_state->shared_config_param;
+	int ret = 0;
+
+	param->rsz_common.src_img_fmt = RSZ_IMG_422;
+
+	ret = ipipe_set_input_win(oper_state, in_format);
+	if (ret)
+		return ret;
+
+	/* output format */
+	ret = ipipe_set_out_pixel_format(oper_state, out_format);
+	if (ret)
+		return ret;
+
+	return ipipe_set_output_win(oper_state, out_format);
+}
+
+static int
+configure_resizer_in_ss_mode(struct device *dev,
+			     struct ipipe_oper_state *oper_state,
+			     void *user_config, int resizer_chained,
+			     struct ipipe_params *param)
+{
+	/* resizer in standalone mode. In this mode if serializer
+	 * is enabled, we need to set config params in the hw.
+	 */
+	struct rsz_config *ss_config = (struct rsz_config *)user_config;
+	enum v4l2_mbus_pixelcode output1_pix;
+	enum v4l2_mbus_pixelcode output2_pix;
+	enum v4l2_mbus_pixelcode input_pix;
+	int line_len_c;
+	int line_len;
+	int ret;
+
+	input_pix = oper_state->in_mbus_format.code;
+	/* If input to IPIPE is BAYER format, for resizer it will
+	   be UYVY.
+	 */
+	if (input_pix == V4L2_MBUS_FMT_SGRBG12_1X12)
+		input_pix = V4L2_MBUS_FMT_UYVY8_2X8;
+
+	ret = rsz_validate_input_image_format(dev, input_pix, oper_state->
+					      in_mbus_format.width,
+					      oper_state->in_mbus_format.height,
+					      &line_len);
+
+	if (ret)
+		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	if (!ss_config->input.line_length)
+		param->ipipeif_param.adofs = line_len;
+	else {
+		param->ipipeif_param.adofs = ss_config->input.line_length;
+		param->ipipeif_param.adofs =
+				(param->ipipeif_param.adofs + 31) & ~0x1f;
+	}
+
+	if (oper_state->rsz_output_enabled[RSZ_A]) {
+		param->rsz_en[RSZ_A] = ENABLE;
+		param->rsz_rsc_param[RSZ_A].mode = IPIPEIF_ONE_SHOT;
+
+		output1_pix = oper_state->out_mbus_format[RSZ_A].code;
+
+		ret = rsz_validate_output_image_format(dev, output1_pix,
+						oper_state->
+						out_mbus_format[RSZ_A].
+						width, oper_state->
+						out_mbus_format[RSZ_A].
+						height, &line_len, &line_len_c);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return ret;
+		}
+		param->ext_mem_param[RSZ_A].rsz_sdr_oft_y = line_len;
+		param->ext_mem_param[RSZ_A].rsz_sdr_oft_c = line_len_c;
+		configure_resizer_out_params(oper_state, param, RSZ_A,
+					&ss_config->output1, 0, 1);
+
+		if (output1_pix == V4L2_MBUS_FMT_SGRBG12_1X12)
+			param->rsz_common.raw_flip = 1;
+		else
+			param->rsz_common.raw_flip = 0;
+
+		if (output1_pix == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+			enable_422_420_conversion(param, RSZ_A, ENABLE);
+		else
+			enable_422_420_conversion(param, RSZ_A, DISABLE);
+	}
+
+	if (oper_state->rsz_output_enabled[RSZ_B]) {
+		param->rsz_en[RSZ_B] = ENABLE;
+		param->rsz_rsc_param[RSZ_B].mode = IPIPEIF_ONE_SHOT;
+
+		output2_pix = oper_state->out_mbus_format[RSZ_B].code;
+		ret = rsz_validate_output_image_format(dev, output2_pix,
+						oper_state->
+						out_mbus_format[RSZ_B].
+						width, oper_state->
+						out_mbus_format[RSZ_B].
+						height, &line_len, &line_len_c);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return ret;
+		}
+		param->ext_mem_param[RSZ_B].rsz_sdr_oft_y = line_len;
+		param->ext_mem_param[RSZ_B].rsz_sdr_oft_c = line_len_c;
+		configure_resizer_out_params(oper_state, param, RSZ_B,
+					&ss_config->output2, 0, 1);
+		if (output2_pix == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+			enable_422_420_conversion(param, RSZ_B, ENABLE);
+		else
+			enable_422_420_conversion(param, RSZ_B, DISABLE);
+	}
+	configure_common_rsz_params(dev, param, ss_config);
+	if (resizer_chained) {
+		oper_state->rsz_chained = 1;
+		oper_state->rsz_config_state = STATE_CONFIGURED;
+	} else {
+		oper_state->rsz_chained = 0;
+		ret = validate_ipipeif_decimation(dev, ss_config->input.dec_en,
+						  ss_config->input.rsz,
+						  ss_config->input.
+						  frame_div_mode_en,
+						  oper_state->
+						  in_mbus_format.width);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return ret;
+		}
+		output1_pix = oper_state->out_mbus_format[RSZ_A].code;
+		if (ipipe_process_pix_fmts(input_pix, output1_pix, param) < 0) {
+			dev_err(dev, "Error in input or output pix format\n");
+			mutex_unlock(&oper_state->lock);
+			return -EINVAL;
+		}
+
+		param->ipipeif_param.source = IPIPEIF_SDRAM_YUV;
+		param->ipipeif_param.glob_hor_size = ss_config->input.ppln;
+		param->ipipeif_param.glob_ver_size = ss_config->input.lpfr;
+		param->ipipeif_param.hnum = oper_state->in_mbus_format.width;
+		param->ipipeif_param.vnum = oper_state->in_mbus_format.height;
+		param->ipipeif_param.var.if_5_1.clk_div =
+						ss_config->input.clk_div;
+		if (ss_config->input.dec_en) {
+			param->ipipeif_param.decimation = IPIPEIF_DECIMATION_ON;
+			param->ipipeif_param.rsz = ss_config->input.rsz;
+			param->ipipeif_param.avg_filter =
+			    (enum ipipeif_avg_filter)ss_config->input.
+								avg_filter_en;
+			param->ipipe_hsz =
+					(((oper_state->in_mbus_format.width *
+				IPIPEIF_RSZ_CONST) / ss_config->input.rsz) - 1);
+		}
+		if (input_pix == V4L2_MBUS_FMT_Y8_1X8 ||
+					  input_pix == V4L2_MBUS_FMT_UV8_1X8) {
+			param->ipipeif_param.var.if_5_1.pack_mode =
+							IPIPEIF_5_1_PACK_8_BIT;
+			param->ipipeif_param.var.if_5_1.source1 = IPIPEIF_CCDC;
+			param->ipipeif_param.var.if_5_1.isif_port.if_type =
+						      V4L2_MBUS_FMT_YUYV8_1X16;
+			param->ipipeif_param.var.if_5_1.data_shift =
+							IPIPEIF_5_1_BITS11_0;
+			param->ipipeif_param.source = IPIPEIF_SDRAM_RAW;
+		}
+		if (input_pix == V4L2_MBUS_FMT_UV8_1X8)
+			param->ipipeif_param.var.if_5_1.isif_port.if_type =
+						V4L2_MBUS_FMT_SGRBG12_1X12;
+		param->ipipe_hsz = oper_state->in_mbus_format.width - 1;
+		param->ipipe_vsz = oper_state->in_mbus_format.height - 1;
+		param->ipipe_vps = ss_config->input.vst;
+		param->ipipe_hps = ss_config->input.hst;
+		param->ipipe_dpaths_fmt = IPIPE_YUV2YUV;
+		configure_common_rsz_in_params(dev, oper_state, param, 1,
+				resizer_chained, ss_config->input.vst,
+				 ss_config->input.hst);
+		if (param->rsz_en[RSZ_A]) {
+			calculate_resize_ratios(param, RSZ_A);
+			calculate_sdram_offsets(param, RSZ_A);
+			/* Overriding resize ratio calculation */
+			if (input_pix == V4L2_MBUS_FMT_UV8_1X8) {
+				param->rsz_rsc_param[RSZ_A].v_dif =
+				    (((param->ipipe_vsz + 1) * 2) * 256) /
+				    (param->rsz_rsc_param[RSZ_A].o_vsz + 1);
+			}
+		}
+
+		if (param->rsz_en[RSZ_B]) {
+			calculate_resize_ratios(param, RSZ_B);
+			calculate_sdram_offsets(param, RSZ_B);
+			/* Overriding resize ratio calculation */
+			if (input_pix == V4L2_MBUS_FMT_UV8_1X8) {
+				param->rsz_rsc_param[RSZ_B].v_dif =
+				    (((param->ipipe_vsz + 1) * 2) * 256) /
+				    (param->rsz_rsc_param[RSZ_B].o_vsz + 1);
+			}
+		}
+	}
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int
+configure_resizer_in_cont_mode(struct device *dev,
+			       struct ipipe_oper_state *oper_state,
+			       void *user_config, int resizer_chained,
+			       struct ipipe_params *param)
+{
+	/* Continuous mode. This is a shared config block */
+	struct rsz_config *cont_config = (struct rsz_config *)user_config;
+	int line_len_c;
+	int line_len;
+	int ret;
+
+	if (!resizer_chained) {
+		dev_err(dev,
+		"Resizer cannot be configured standalone in continuous mode\n");
+		return -EINVAL;
+	}
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+
+	if (!oper_state->rsz_output_enabled[RSZ_A]) {
+		dev_err(dev, "enable resizer - 0\n");
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+	param->rsz_en[RSZ_A] = ENABLE;
+	param->rsz_rsc_param[RSZ_A].mode = IPIPEIF_CONTINUOUS;
+	configure_resizer_out_params(oper_state, param, RSZ_A,
+				&cont_config->output1, 1, 0);
+	param->rsz_en[RSZ_B] = DISABLE;
+
+	if (oper_state->rsz_output_enabled[RSZ_B]) {
+		enum v4l2_mbus_pixelcode out2_pix;
+
+		out2_pix = oper_state->out_mbus_format[RSZ_B].code;
+		param->rsz_rsc_param[RSZ_B].mode = IPIPEIF_CONTINUOUS;
+		ret = rsz_validate_output_image_format(dev, out2_pix,
+						       oper_state->
+						       out_mbus_format[RSZ_B].
+						       width, oper_state->
+						       out_mbus_format[RSZ_B].
+						       height, &line_len,
+						       &line_len_c);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return ret;
+		}
+		param->ext_mem_param[RSZ_B].rsz_sdr_oft_y = line_len;
+		param->ext_mem_param[RSZ_B].rsz_sdr_oft_c = line_len_c;
+		configure_resizer_out_params(oper_state, param, RSZ_B,
+						&cont_config->output2, 0, 1);
+		if (out2_pix == V4L2_MBUS_FMT_YDYUYDYV8_1X16)
+			enable_422_420_conversion(param, RSZ_B, ENABLE);
+		else
+			enable_422_420_conversion(param, RSZ_B, DISABLE);
+	}
+	oper_state->rsz_chained = 1;
+	oper_state->rsz_config_state = STATE_CONFIGURED;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int
+ipipe_set_resize_config(struct device *dev, void *ipipe,
+			int resizer_chained, void *user_config, void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = (struct ipipe_params *)config;
+	int ret;
+
+	dev_dbg(dev, "ipipe_set_resize_config, resizer_chained = %d\n",
+						resizer_chained);
+	if (!user_config || !config) {
+		dev_err(dev, "Invalid user_config or config ptr\n");
+		return -EINVAL;
+	}
+
+	memcpy((void *)config, (void *)&dm365_ipipe_defs,
+			sizeof(struct ipipe_params));
+
+	/* restore if_param */
+	if (oper_state->oper_mode == IMP_MODE_CONTINUOUS)
+		param->ipipeif_param.var.if_5_1.isif_port =
+						oper_state->if_param;
+
+	if (oper_state->oper_mode != IMP_MODE_SINGLE_SHOT) {
+		ret =  configure_resizer_in_cont_mode(dev, oper_state,
+					user_config, resizer_chained, param);
+		if (ret)
+			return ret;
+
+		/* In continuous mode, after setting config,
+		   set input and output format for IPIPE */
+		return configure_formats_in_cont_mode(oper_state);
+	}
+
+	ret = configure_resizer_in_ss_mode(dev, oper_state,
+				user_config, resizer_chained, param);
+	if (!ret && !oper_state->en_serializer && !resizer_chained)
+		ret = ipipe_hw_setup(config);
+
+	return ret;
+}
+
+static void configure_resize_passthru(struct ipipe_params *param, int bypass)
+{
+	param->rsz_rsc_param[RSZ_A].cen = DISABLE;
+	param->rsz_rsc_param[RSZ_A].yen = DISABLE;
+	param->rsz_rsc_param[RSZ_A].v_phs_y = 0;
+	param->rsz_rsc_param[RSZ_A].v_phs_c = 0;
+	param->rsz_rsc_param[RSZ_A].v_dif = 256;
+	param->rsz_rsc_param[RSZ_A].v_lpf_int_y = 0;
+	param->rsz_rsc_param[RSZ_A].v_lpf_int_c = 0;
+	param->rsz_rsc_param[RSZ_A].h_phs = 0;
+	param->rsz_rsc_param[RSZ_A].h_dif = 256;
+	param->rsz_rsc_param[RSZ_A].h_lpf_int_y = 0;
+	param->rsz_rsc_param[RSZ_A].h_lpf_int_c = 0;
+	param->rsz_rsc_param[RSZ_A].dscale_en = DISABLE;
+	param->rsz2rgb[RSZ_A].rgb_en = DISABLE;
+	param->rsz_en[RSZ_A] = ENABLE;
+	param->rsz_en[RSZ_B] = DISABLE;
+	if (bypass) {
+		param->rsz_rsc_param[RSZ_A].i_vps = 0;
+		param->rsz_rsc_param[RSZ_A].i_hps = 0;
+		/* Raw Bypass */
+		param->rsz_common.passthrough = IPIPE_BYPASS_ON;
+	}
+}
+
+static inline int
+prev_validate_output_image_format(struct device *dev,
+				  enum v4l2_mbus_pixelcode pix, int *line_len,
+				  int in_width, int in_height)
+{
+	if (pix != V4L2_MBUS_FMT_UYVY8_2X8 &&
+				  pix != V4L2_MBUS_FMT_SGRBG12_1X12) {
+		dev_err(dev,
+		       "previewer output: pix format not supported, %d\n", pix);
+		return -EINVAL;
+	}
+
+	if (in_width == 0 || in_height == 0) {
+		dev_err(dev, "previewer output: invalid width or height\n");
+		return -EINVAL;
+	}
+
+	*line_len = in_width * 2;
+
+	/* Adjust line length to be a multiple of 32 */
+	*line_len += 31;
+	*line_len &= ~0x1f;
+
+	return 0;
+}
+
+static inline int
+validate_preview_input_spec(struct device *dev,
+			    enum v4l2_mbus_pixelcode pix,
+			    int width,
+			    int height, int *line_len)
+{
+	if (pix != V4L2_MBUS_FMT_UYVY8_2X8 &&
+	    pix != V4L2_MBUS_FMT_SGRBG12_1X12 &&
+	    pix != V4L2_MBUS_FMT_SBGGR8_1X8 &&
+	    pix != V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 &&
+	    pix != V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 &&
+			pix != V4L2_MBUS_FMT_SBGGR12_1X12) {
+		dev_err(dev,
+		"validate_preview_input_spec:pix format not supported, %d\n",
+		pix);
+		return -EINVAL;
+	}
+	if (width == 0 || height == 0) {
+		dev_err(dev,
+		    "validate_preview_input_spec: invalid width or height\n");
+		return -EINVAL;
+	}
+
+	if (pix == V4L2_MBUS_FMT_UYVY8_2X8 || pix == V4L2_MBUS_FMT_SGRBG12_1X12)
+		*line_len = width * 2;
+	else if (pix == V4L2_MBUS_FMT_SBGGR8_1X8 ||
+		 pix == V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 ||
+		 pix == V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8)
+		*line_len = width;
+	else
+		/* 12 bit */
+		*line_len = width + (width >> 1);
+	/* Adjust line length to be a multiple of 32 */
+	*line_len += 31;
+	*line_len &= ~0x1f;
+
+	return 0;
+}
+
+static int
+configure_previewer_in_cont_mode(struct device *dev,
+				 struct ipipe_oper_state *oper_state,
+				 void *user_config,
+				 struct ipipe_params *param)
+{
+	struct prev_ipipeif_config *config =
+			(struct prev_ipipeif_config *)user_config;
+	int ret;
+
+	if (config->dec_en && (config->rsz <
+		IPIPEIF_RSZ_MIN || config->rsz > IPIPEIF_RSZ_MAX)) {
+		dev_err(dev, "Resizer range is %d to %d\n",
+			IPIPEIF_RSZ_MIN, IPIPEIF_RSZ_MAX);
+		return -EINVAL;
+	}
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+
+	param->rsz_common.passthrough = config->bypass;
+	param->ipipeif_param.source = IPIPEIF_CCDC;
+	param->ipipeif_param.clock_select = IPIPEIF_PIXCEL_CLK;
+	param->ipipeif_param.mode = IPIPEIF_CONTINUOUS;
+
+	if (config->dec_en) {
+		param->ipipeif_param.decimation = IPIPEIF_DECIMATION_ON;
+		param->ipipeif_param.rsz = config->rsz;
+		param->ipipeif_param.avg_filter =
+			(enum ipipeif_avg_filter)config->avg_filter_en;
+	}
+	/* IPIPE mode */
+	param->ipipe_mode = IPIPEIF_CONTINUOUS;
+
+	switch (oper_state->in_mbus_format.code) {
+	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		param->ipipe_colpat = ipipe_sgrbg_pattern;
+		break;
+	default:
+		param->ipipe_colpat = ipipe_srggb_pattern;
+		break;
+	}
+
+	param->ipipeif_param.gain = ipipeif_gain;
+	param->ipipeif_param.var.if_5_1.clip = config->clip;
+	param->ipipeif_param.var.if_5_1.dpc = config->dpc;
+	param->ipipeif_param.var.if_5_1.align_sync = config->align_sync;
+	param->ipipeif_param.var.if_5_1.rsz_start = config->rsz_start;
+
+	if (!oper_state->rsz_chained) {
+		param->rsz_rsc_param[0].mode = IPIPEIF_CONTINUOUS;
+		/* setup bypass resizer */
+		configure_resize_passthru(param, 0);
+	}
+
+	if (config->bypass)
+		configure_resize_passthru(param, 1);
+
+	oper_state->prev_config_state = STATE_CONFIGURED;
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+/*
+ * preview_chroma_phase - Configure byte layout of YUV image.
+ */
+static int preview_chroma_phase(enum v4l2_mbus_pixelcode pixelcode)
+{
+	switch (pixelcode) {
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		return IPIPEIF_CBCR_Y;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int
+configure_previewer_in_ss_mode(struct device *dev,
+			       struct ipipe_oper_state *oper_state,
+			       void *user_config, struct ipipe_params *param)
+{
+	struct prev_ipipeif_config *config =
+			(struct prev_ipipeif_config *)user_config;
+	enum v4l2_mbus_pixelcode output_pix;
+	enum v4l2_mbus_pixelcode input_pix;
+	int chroma_phase;
+	int line_len;
+	int ret;
+
+	output_pix = oper_state->out_mbus_format[RSZ_A].code;
+	input_pix = oper_state->in_mbus_format.code;
+
+	ret = validate_preview_input_spec(dev, input_pix,
+					  oper_state->in_mbus_format.width,
+					  oper_state->in_mbus_format.height,
+					  &line_len);
+	if (ret)
+		return -EINVAL;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+
+	if (!config->input_spec.line_length) {
+		param->ipipeif_param.adofs = line_len;
+	} else {
+		param->ipipeif_param.adofs = config->input_spec.line_length;
+		param->ipipeif_param.adofs =
+				(param->ipipeif_param.adofs + 31) & ~0x1f;
+	}
+	if (config->dec_en && config->input_spec.frame_div_mode_en) {
+		dev_err(dev,
+		"dec_en & frame_div_mode_en cannot enabled simultaneously\n");
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+
+	ret = validate_ipipeif_decimation(dev, config->dec_en,
+					  config->rsz,
+					  config->input_spec.frame_div_mode_en,
+					  oper_state->in_mbus_format.width);
+	if (ret) {
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+
+	if (!oper_state->rsz_chained) {
+		ret = prev_validate_output_image_format(dev, output_pix,
+							&line_len,
+							oper_state->
+							in_mbus_format.width,
+							oper_state->
+							in_mbus_format.height);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return -EINVAL;
+		}
+		param->ext_mem_param[RSZ_A].rsz_sdr_oft_y = line_len;
+		if (config->input_spec.frame_div_mode_en)
+			ret = update_preview_f_div_params(dev, oper_state->
+							  in_mbus_format.width,
+							  oper_state->
+							  in_mbus_format.width,
+							  &param->
+							  rsz_rsc_param[RSZ_A]);
+		if (ret) {
+			mutex_unlock(&oper_state->lock);
+			return -EINVAL;
+		}
+	} else {
+		if (config->input_spec.frame_div_mode_en &&
+		    param->rsz_en[RSZ_A]) {
+			if (!param->rsz_rsc_param[RSZ_A].dscale_en)
+				ret = calculate_normal_f_div_param(dev,
+							oper_state->
+							in_mbus_format.width,
+							param->rsz_rsc_param
+							  [RSZ_A].
+							  o_vsz + 1,
+							&param->rsz_rsc_param
+							  [RSZ_A]);
+			else
+				ret = calculate_down_scale_f_div_param(dev,
+							oper_state->
+							in_mbus_format.width,
+							param->rsz_rsc_param
+							  [RSZ_A].o_vsz + 1,
+							&param->rsz_rsc_param
+							  [RSZ_A]);
+			if (ret) {
+				mutex_unlock(&oper_state->lock);
+				return -EINVAL;
+			}
+		}
+		if (config->input_spec.frame_div_mode_en &&
+		    param->rsz_en[RSZ_B]) {
+			if (!param->rsz_rsc_param[RSZ_B].dscale_en)
+				ret = calculate_normal_f_div_param(dev,
+							oper_state->
+							in_mbus_format.width,
+							param->rsz_rsc_param
+							   [RSZ_B].o_vsz + 1,
+							&param->rsz_rsc_param
+							   [RSZ_B]);
+			else
+				ret = calculate_down_scale_f_div_param(dev,
+							oper_state->
+							in_mbus_format.width,
+							param->rsz_rsc_param
+							   [RSZ_B].o_vsz + 1,
+							&param->rsz_rsc_param
+							   [RSZ_B]);
+			if (ret) {
+				mutex_unlock(&oper_state->lock);
+				return -EINVAL;
+			}
+		}
+	}
+	if (ipipe_process_pix_fmts(input_pix, output_pix, param) < 0) {
+		dev_err(dev, "Error in input or output pix format\n");
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+	param->ipipeif_param.hnum = oper_state->in_mbus_format.width;
+	param->ipipeif_param.vnum = oper_state->in_mbus_format.height;
+	param->ipipeif_param.glob_hor_size = config->input_spec.ppln;
+	param->ipipeif_param.glob_ver_size = config->input_spec.lpfr;
+	param->ipipeif_param.var.if_5_1.clk_div = config->input_spec.clk_div;
+	chroma_phase = preview_chroma_phase(output_pix);
+	if (chroma_phase < 0) {
+		dev_err(dev, "Error in calculating chroma phase\n");
+		mutex_unlock(&oper_state->lock);
+		return -EINVAL;
+	}
+	param->ipipeif_param.var.if_5_1.chroma_phase = chroma_phase;
+	param->ipipeif_param.var.if_5_1.align_sync = config->align_sync;
+	param->ipipeif_param.var.if_5_1.rsz_start = config->rsz_start;
+	if (param->ipipeif_param.var.if_5_1.dpcm.en) {
+		param->ipipeif_param.var.if_5_1.dpcm.pred = dpcm_predictor;
+		param->ipipeif_param.var.if_5_1.dpcm.type =
+					IPIPEIF_DPCM_8BIT_12BIT;
+	}
+	/*
+	 * currently V4L2_MBUS_FMT_SGRBG12_1X12 is supported
+	 * add case's when different MBUS is also supported.
+	 */
+	switch (oper_state->in_mbus_format.code) {
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		param->ipipeif_param.var.if_5_1.data_shift =
+				IPIPEIF_5_1_BITS11_0;
+		break;
+	default:
+		param->ipipeif_param.var.if_5_1.data_shift =
+				IPIPEIF_5_1_BITS11_0;
+	}
+
+	param->ipipe_hsz = oper_state->in_mbus_format.width - 1;
+	if (config->dec_en) {
+		if (config->rsz < IPIPEIF_RSZ_MIN ||
+		    config->rsz > IPIPEIF_RSZ_MAX) {
+			dev_err(dev, "Resizer range is %d to %d\n",
+				IPIPEIF_RSZ_MIN, IPIPEIF_RSZ_MAX);
+			mutex_unlock(&oper_state->lock);
+			return -EINVAL;
+		}
+		param->ipipeif_param.decimation = IPIPEIF_DECIMATION_ON;
+		param->ipipeif_param.rsz = config->rsz;
+		param->ipipeif_param.avg_filter =
+		    (enum ipipeif_avg_filter)config->avg_filter_en;
+		param->ipipe_hsz =
+		    (((oper_state->in_mbus_format.width * IPIPEIF_RSZ_CONST) /
+					config->rsz) - 1);
+	}
+	param->ipipeif_param.gain = ipipeif_gain;
+	param->ipipeif_param.var.if_5_1.clip = config->clip;
+	param->ipipeif_param.var.if_5_1.dpc = config->dpc;
+	switch (oper_state->in_mbus_format.code) {
+	case V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8:
+	case V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8:
+	case V4L2_MBUS_FMT_SGRBG12_1X12:
+		param->ipipe_colpat = ipipe_sgrbg_pattern;
+		break;
+	default:
+		param->ipipe_colpat = ipipe_srggb_pattern;
+		break;
+	}
+	param->ipipe_vps = config->input_spec.vst;
+	param->ipipe_hps = config->input_spec.hst;
+	param->ipipe_vsz = oper_state->in_mbus_format.height - 1;
+	if (input_pix == V4L2_MBUS_FMT_UYVY8_2X8)
+		param->ipipeif_param.source = IPIPEIF_SDRAM_YUV;
+	else
+		param->ipipeif_param.source = IPIPEIF_SDRAM_RAW;
+
+	configure_common_rsz_in_params(dev, oper_state, param, 1,
+		oper_state->rsz_chained, config->input_spec.vst,
+		config->input_spec.hst);
+
+	param->rsz_common.passthrough = config->bypass;
+	/* update the resize parameters */
+	if (config->bypass == IPIPE_BYPASS_ON ||
+			param->ipipe_dpaths_fmt == IPIPE_RAW2RAW) {
+		/* Bypass resizer */
+		configure_resize_passthru(param, 1);
+	} else {
+		if (oper_state->rsz_chained) {
+			if (param->rsz_en[RSZ_A]) {
+				calculate_resize_ratios(param, RSZ_A);
+				calculate_sdram_offsets(param, RSZ_A);
+			}
+			if (param->rsz_en[RSZ_B]) {
+				calculate_resize_ratios(param, RSZ_B);
+				calculate_sdram_offsets(param, RSZ_B);
+			}
+		} else {
+			struct rsz_output_spec *output_specs =
+				kmalloc(sizeof(struct rsz_output_spec),
+					GFP_KERNEL);
+			if (!output_specs) {
+				dev_err(dev, "Failed to allocate memory\n");
+				mutex_unlock(&oper_state->lock);
+				return -EINVAL;
+			}
+				/* Using resizer as pass through */
+			configure_resize_passthru(param, 0);
+			memset((void *)output_specs, 0,
+				sizeof(struct rsz_output_spec));
+
+			output_specs->vst_y = config->input_spec.vst;
+			configure_resizer_out_params(oper_state, param, RSZ_A,
+						output_specs, 0, 0);
+			calculate_sdram_offsets(param, RSZ_A);
+			kfree(output_specs);
+		}
+	}
+	mutex_unlock(&oper_state->lock);
+
+	return 0;
+}
+
+static int
+ipipe_set_preview_config(struct device *dev, void *ipipe,
+			 void *user_config, void *config)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = (struct ipipe_params *)config;
+	int ret;
+
+	dev_dbg(dev, "ipipe_set_preview_config\n");
+
+	if (!user_config || !config) {
+		dev_err(dev, "Invalid user_config or config ptr\n");
+		return -EINVAL;
+	}
+
+	if (!oper_state->rsz_chained) {
+		/* For chained resizer, defaults are set by resizer */
+		memcpy((void *)config, (void *)&dm365_ipipe_defs,
+				sizeof(struct ipipe_params));
+
+		/* restore if_param */
+		if (oper_state->oper_mode == IMP_MODE_CONTINUOUS)
+			param->ipipeif_param.var.if_5_1.isif_port =
+							oper_state->if_param;
+
+		/* for previewer only continuous mode, RSZ_A should be on */
+		oper_state->rsz_output_enabled[RSZ_A] = 1;
+	}
+
+	/* continuous mode */
+	if (oper_state->oper_mode == IMP_MODE_CONTINUOUS) {
+		ret = configure_previewer_in_cont_mode(dev, oper_state,
+						  user_config, param);
+		if (ret)
+			return ret;
+
+		/* In continuous mode, after setting config,
+		   set input and output format for IPIPE */
+		return configure_formats_in_cont_mode(oper_state);
+	}
+
+	/* previewer in standalone mode. In this mode if serializer
+	 * is enabled, we need to set config params for hw.
+	 */
+	ret = configure_previewer_in_ss_mode(dev, oper_state,
+							user_config, param);
+
+	if (!ret && !oper_state->en_serializer)
+		ret = ipipe_hw_setup(config);
+
+	return ret;
+}
+
+static void
+ipipe_set_in_mbus_format(void *ipipe, struct v4l2_mbus_framefmt *format)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	memcpy((void *)&oper_state->in_mbus_format, (void *)format,
+				sizeof(struct v4l2_mbus_framefmt));
+}
+
+static void
+ipipe_set_out_mbus_format(void *ipipe, struct v4l2_mbus_framefmt *format)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	memcpy((void *)&oper_state->out_mbus_format[RSZ_A], (void *)format,
+					sizeof(struct v4l2_mbus_framefmt));
+	oper_state->rsz_output_enabled[RSZ_A] = ENABLE;
+}
+
+static void
+ipipe_set_out2_mbus_format(void *ipipe, struct v4l2_mbus_framefmt *format)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	memcpy((void *)&oper_state->out_mbus_format[RSZ_B], (void *)format,
+					sizeof(struct v4l2_mbus_framefmt));
+	oper_state->rsz_output_enabled[RSZ_B] = ENABLE;
+}
+
+static int ipipe_get_output_state(void *ipipe, unsigned char out_sel)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+
+	if (out_sel != RSZ_A && out_sel != RSZ_B)
+		return 0;
+	return param->rsz_en[out_sel];
+}
+
+/* This should be called only after setting the output
+ * window params. This also assumes the corresponding
+ * output is configured prior to calling this.
+ */
+static int ipipe_get_line_length(void *ipipe, unsigned char out_sel)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+
+	if (out_sel != RSZ_A && out_sel != RSZ_B)
+		return -EINVAL;
+	/* assume output is always UYVY. Change this if we
+	 * support RGB
+	 */
+	if (!param->rsz_en[out_sel])
+		return -EINVAL;
+	return param->ext_mem_param[out_sel].rsz_sdr_oft_y;
+}
+
+static int ipipe_get_image_height(void *ipipe, unsigned char out_sel)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	struct ipipe_params *param = oper_state->shared_config_param;
+
+	if (out_sel != RSZ_A && out_sel != RSZ_B)
+		return -EINVAL;
+	if (!param->rsz_en[out_sel])
+		return -EINVAL;
+	return param->rsz_rsc_param[out_sel].o_vsz + 1;
+}
+
+/* Assume valid param ptr */
+static int ipipe_set_hw_if_param(void *ipipe, struct vpfe_hw_if_param *if_param)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+	int ret;
+
+	ret = mutex_lock_interruptible(&oper_state->lock);
+	if (ret)
+		return ret;
+	/* save if_param locally */
+	memcpy((void *)&oper_state->if_param, (void *)if_param,
+				sizeof(struct vpfe_hw_if_param));
+	mutex_unlock(&oper_state->lock);
+	return 0;
+}
+
+static struct imp_hw_interface dm365_ipipe_interface = {
+	.name = "DM365 IPIPE",
+	.owner = THIS_MODULE,
+	.prev_enum_modules = prev_enum_preview_cap,
+	.set_oper_mode = ipipe_set_oper_mode,
+	.reset_oper_mode = ipipe_reset_oper_mode,
+	.get_oper_mode = prev_get_oper_mode,
+	.get_hw_state = ipipe_get_oper_state,
+	.set_hw_state = ipipe_set_oper_state,
+	.resizer_chain = ipipe_rsz_chain_state,
+	.lock_chain = ipipe_lock_chain,
+	.unlock_chain = ipipe_unlock_chain,
+	.serialize = ipipe_serialize,
+	.alloc_config_block = ipipe_alloc_config_block,
+	.dealloc_config_block = ipipe_dealloc_config_block,
+	.alloc_user_config_block = ipipe_alloc_user_config_block,
+	.dealloc_config_block = ipipe_dealloc_user_config_block,
+	.set_user_config_defaults = ipipe_set_user_config_defaults,
+	.set_preview_config = ipipe_set_preview_config,
+	.set_resizer_config = ipipe_set_resize_config,
+	.set_preview_module_params = ipipe_set_preview_module_params,
+	.get_preview_module_params = ipipe_get_preview_module_params,
+	.update_inbuf_address = ipipe_set_ipipe_if_address,
+	.update_outbuf1_address = ipipe_update_outbuf1_address,
+	.update_outbuf2_address = ipipe_update_outbuf2_address,
+	.enable = ipipe_enable,
+	.enable_resize = rsz_src_enable,
+	.hw_setup = ipipe_do_hw_setup,
+	.get_resizer_config_state = ipipe_get_rsz_config_state,
+	.get_previewer_config_state = ipipe_get_prev_config_state,
+	.set_hw_if_param = ipipe_set_hw_if_param,
+	.set_in_mbus_format = ipipe_set_in_mbus_format,
+	.set_out_mbus_format = ipipe_set_out_mbus_format,
+	.set_out2_mbus_format = ipipe_set_out2_mbus_format,
+	.get_output_state = ipipe_get_output_state,
+	.get_line_length = ipipe_get_line_length,
+	.get_image_height = ipipe_get_image_height,
+	.get_image_height = ipipe_get_image_height,
+	.get_max_output_width = ipipe_get_max_output_width,
+	.get_max_output_height = ipipe_get_max_output_height,
+	.enum_pix = ipipe_enum_pix,
+	.prv_s_ctrl = preview_s_ctrl,
+};
+
+struct imp_hw_interface *imp_get_hw_if(void)
+{
+	return &dm365_ipipe_interface;
+}
+
+void enable_serializer(void *ipipe, int val)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	oper_state->en_serializer = val;
+}
+
+int ipipe_init(void **ipipe)
+{
+	struct ipipe_oper_state *oper_state;
+
+	*ipipe = kmalloc(sizeof(struct ipipe_oper_state), GFP_KERNEL);
+	if (!*ipipe) {
+		pr_err("dm365_ipipe_init: Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	oper_state = (struct ipipe_oper_state *)*ipipe;
+
+	/* ipipe module operation state & configuration */
+	oper_state->oper_mode = IMP_MODE_NOT_CONFIGURED;
+	oper_state->ipipe_raw_yuv_pix_formats[0] = V4L2_PIX_FMT_UYVY;
+	oper_state->ipipe_raw_yuv_pix_formats[1] = V4L2_PIX_FMT_NV12;
+
+	oper_state->shared_config_param =
+			kmalloc(sizeof(struct ipipe_params), GFP_KERNEL);
+
+	if (!oper_state->shared_config_param) {
+		pr_err("dm365_ipipe_init: failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	memcpy(&dm365_ipipe_defs.ipipeif_param.var.if_5_1,
+		&ipipeif_5_1_defaults, sizeof(struct ipipeif_5_1));
+	memcpy(&oper_state->lutdpc.table, &oper_state->ipipe_lutdpc_table,
+	       sizeof(oper_state->lutdpc.table));
+	memcpy(&oper_state->lut_3d.table , &oper_state->ipipe_3d_lut_table,
+		sizeof(oper_state->lut_3d.table));
+	memcpy(&oper_state->gbce.table, &oper_state->ipipe_gbce_table,
+		sizeof(oper_state->gbce.table));
+	memcpy(&oper_state->gamma.table_r, &oper_state->ipipe_gamma_table_r,
+		sizeof(oper_state->gamma.table_r));
+	memcpy(&oper_state->gamma.table_g, &oper_state->ipipe_gamma_table_g,
+		sizeof(oper_state->gamma.table_g));
+	memcpy(&oper_state->gamma.table_b, &oper_state->ipipe_gamma_table_b,
+		sizeof(oper_state->gamma.table_b));
+	memcpy(&oper_state->yee.table, &oper_state->ipipe_yee_table,
+		sizeof(oper_state->yee.table));
+	mutex_init(&oper_state->lock);
+	oper_state->state = CHANNEL_FREE;
+	oper_state->prev_config_state = STATE_NOT_CONFIGURED;
+	oper_state->rsz_config_state = STATE_NOT_CONFIGURED;
+	oper_state->out_mbus_format[RSZ_A].code = V4L2_MBUS_FMT_UYVY8_2X8;
+	oper_state->out_mbus_format[RSZ_B].code = V4L2_MBUS_FMT_UYVY8_2X8;
+	oper_state->resource_in_use = 0;
+	oper_state->rsz_chained = 0;
+
+	return 0;
+}
+
+void ipipe_cleanup(void *ipipe)
+{
+	struct ipipe_oper_state *oper_state = (struct ipipe_oper_state *)ipipe;
+
+	kfree(oper_state->shared_config_param);
+	kfree(oper_state);
+}
diff --git a/drivers/media/platform/davinci/dm365_ipipe.h b/drivers/media/platform/davinci/dm365_ipipe.h
new file mode 100644
index 0000000..2611498
--- /dev/null
+++ b/drivers/media/platform/davinci/dm365_ipipe.h
@@ -0,0 +1,430 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ *
+ * Feature description
+ * ===================
+ *
+ * VPFE hardware setup
+ *
+ * case 1: Capture to SDRAM with out IPIPE
+ * ****************************************
+ *
+ *            parallel
+ *                port
+ *
+ * Image sensor/       ________
+ * Yuv decoder    ---->| CCDC |--> SDRAM
+ *                     |______|
+ *
+ * case 2: Capture to SDRAM with IPIPE Preview modules in Continuous
+ *          (On the Fly mode)
+ *
+ * Image sensor/       ________    ____________________
+ * Yuv decoder    ---->| CCDC |--> | Previewer modules |--> SDRAM
+ *                     |______|    |___________________|
+ *
+ * case 3: Capture to SDRAM with IPIPE Preview modules  & Resizer
+ *         in continuous (On the Fly mode)
+ *
+ * Image sensor/       ________    _____________   ___________
+ * Yuv decoder    ---->| CCDC |--> | Previewer  |->| Resizer  |-> SDRAM
+ *                     |______|    |____________|  |__________|
+ *
+ * case 4: Capture to SDRAM with IPIPE Resizer
+ *         in continuous (On the Fly mode)
+ *
+ * Image sensor/       ________    ___________
+ * Yuv decoder    ---->| CCDC |--> | Resizer  |-> SDRAM
+ *                     |______|    |__________|
+ *
+ * case 5: Read from SDRAM and do preview and/or Resize
+ *         in Single shot mode
+ *
+ *                   _____________   ___________
+ *    SDRAM   ----> | Previewer  |->| Resizer  |-> SDRAM
+ *                  |____________|  |__________|
+ *
+ *
+ * Previewer allows fine tuning of the input image using different
+ * tuning modules in IPIPE. Some examples :- Noise filter, Defect
+ * pixel correction etc. It essentially operate on Bayer Raw data
+ * or YUV raw data. To do image tuning, application call,
+ * PREV_QUERY_CAP, and then call PREV_SET_PARAM to set parameter
+ * for a module.
+ *
+ *
+ * Resizer allows upscaling or downscaling a image to a desired
+ * resolution. There are 2 resizer modules. both operating on the
+ * same input image, but can have different output resolution.
+ */
+
+#ifndef _DM365_IPIPE_H
+#define _DM365_IPIPE_H
+
+#include <linux/davinci_vpfe.h>
+
+#include "dm3xx_ipipeif.h"
+
+#define CEIL(a, b)	(((a) + (b-1)) / (b))
+
+/* Used for driver storage */
+struct ipipe_otfdpc_2_0 {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* defect detection method */
+	enum ipipe_otfdpc_det_meth det_method;
+	/* Algorith used. Applicable only when IPIPE_DPC_OTF_MIN_MAX2 is
+	 * used
+	 */
+	enum ipipe_otfdpc_alg alg;
+	struct prev_otfdpc_2_0 otfdpc_2_0;
+};
+
+struct ipipe_otfdpc_3_0 {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* defect detection method */
+	enum ipipe_otfdpc_det_meth det_method;
+	/* Algorith used. Applicable only when IPIPE_DPC_OTF_MIN_MAX2 is
+	 * used
+	 */
+	enum ipipe_otfdpc_alg alg;
+	struct prev_otfdpc_3_0 otfdpc_3_0;
+};
+
+struct f_div_pass {
+	unsigned int o_hsz;
+	unsigned int i_hps;
+	unsigned int h_phs;
+	unsigned int src_hps;
+	unsigned int src_hsz;
+};
+
+#define IPIPE_MAX_PASSES	2
+
+struct f_div_param {
+	unsigned char en;
+	unsigned int num_passes;
+	struct f_div_pass pass[IPIPE_MAX_PASSES];
+};
+
+#define boolean_t	int
+#define ENABLE		1
+#define DISABLE		(!ENABLE)
+
+/* Resizer Rescale Parameters*/
+struct ipipe_rsz_rescale_param {
+	enum ipipe_oper_mode mode;
+	boolean_t h_flip;
+	boolean_t v_flip;
+	boolean_t cen;
+	boolean_t yen;
+	unsigned short i_vps;
+	unsigned short i_hps;
+	unsigned short o_vsz;
+	unsigned short o_hsz;
+	unsigned short v_phs_y;
+	unsigned short v_phs_c;
+	unsigned short v_dif;
+	/* resize method - Luminance */
+	enum rsz_intp_t v_typ_y;
+	/* resize method - Chrominance */
+	enum rsz_intp_t v_typ_c;
+	/* vertical lpf intensity - Luminance */
+	unsigned char v_lpf_int_y;
+	/* vertical lpf intensity - Chrominance */
+	unsigned char v_lpf_int_c;
+	unsigned short h_phs;
+	unsigned short h_dif;
+	/* resize method - Luminance */
+	enum rsz_intp_t h_typ_y;
+	/* resize method - Chrominance */
+	enum rsz_intp_t h_typ_c;
+	/* horizontal lpf intensity - Luminance */
+	unsigned char h_lpf_int_y;
+	/* horizontal lpf intensity - Chrominance */
+	unsigned char h_lpf_int_c;
+	boolean_t dscale_en;
+	enum down_scale_ave_sz h_dscale_ave_sz;
+	enum down_scale_ave_sz v_dscale_ave_sz;
+	/* store the calculated frame division parameter */
+	struct f_div_param f_div;
+};
+
+enum ipipe_rsz_rgb_t {
+	OUTPUT_32BIT,
+	OUTPUT_16BIT
+};
+
+enum ipipe_rsz_rgb_msk_t {
+	NOMASK,
+	MASKLAST2
+};
+
+/* Resizer RGB Conversion Parameters */
+struct ipipe_rsz_resize2rgb {
+	boolean_t rgb_en;
+	enum ipipe_rsz_rgb_t rgb_typ;
+	enum ipipe_rsz_rgb_msk_t rgb_msk0;
+	enum ipipe_rsz_rgb_msk_t rgb_msk1;
+	unsigned int rgb_alpha_val;
+};
+
+/* Resizer External Memory Parameters */
+struct ipipe_ext_mem_param {
+	unsigned int rsz_sdr_oft_y;
+	unsigned int rsz_sdr_ptr_s_y;
+	unsigned int rsz_sdr_ptr_e_y;
+	unsigned int rsz_sdr_oft_c;
+	unsigned int rsz_sdr_ptr_s_c;
+	unsigned int rsz_sdr_ptr_e_c;
+	/* offset to be added to buffer start when flipping for y/ycbcr */
+	unsigned int flip_ofst_y;
+	/* offset to be added to buffer start when flipping for c */
+	unsigned int flip_ofst_c;
+	/* c offset for YUV 420SP */
+	unsigned int c_offset;
+	/* User Defined Y offset for YUV 420SP or YUV420ILE data */
+	unsigned int user_y_ofst;
+	/* User Defined C offset for YUV 420SP data */
+	unsigned int user_c_ofst;
+};
+
+enum rsz_data_source {
+	IPIPE_DATA,
+	IPIPEIF_DATA
+};
+
+/* data paths */
+enum ipipe_data_paths {
+	IPIPE_RAW2YUV,
+	/* Bayer RAW input to YCbCr output */
+	IPIPE_RAW2RAW,
+	/* Bayer Raw to Bayer output */
+	IPIPE_RAW2BOX,
+	/* Bayer Raw to Boxcar output */
+	IPIPE_YUV2YUV
+	/* YUV Raw to YUV Raw output */
+};
+
+enum rsz_src_img_fmt {
+	RSZ_IMG_422,
+	RSZ_IMG_420
+};
+
+struct rsz_common_params {
+	unsigned int vps;
+	unsigned int vsz;
+	unsigned int hps;
+	unsigned int hsz;
+	/* 420 or 422 */
+	enum rsz_src_img_fmt src_img_fmt;
+	/* Y or C when src_fmt is 420, 0 - y, 1 - c */
+	unsigned char y_c;
+	/* flip raw or ycbcr */
+	unsigned char raw_flip;
+	/* IPIPE or IPIPEIF data */
+	enum rsz_data_source source;
+	enum ipipe_dpaths_bypass_t passthrough;
+	unsigned char yuv_y_min;
+	unsigned char yuv_y_max;
+	unsigned char yuv_c_min;
+	unsigned char yuv_c_max;
+	boolean_t rsz_seq_crv;
+	enum ipipe_chr_pos out_chr_pos;
+};
+
+struct ipipe_params {
+	struct ipipeif ipipeif_param;
+	enum ipipe_oper_mode ipipe_mode;
+	/* input/output datapath through IPIPE */
+	enum ipipe_data_paths ipipe_dpaths_fmt;
+	u32 ipipe_colpat;
+	/* horizontal/vertical start, horizontal/vertical size
+	 * for both IPIPE and RSZ input
+	 */
+	unsigned int ipipe_vps;
+	unsigned int ipipe_vsz;
+	unsigned int ipipe_hps;
+	unsigned int ipipe_hsz;
+
+	struct rsz_common_params rsz_common;
+	struct ipipe_rsz_rescale_param rsz_rsc_param[2];
+	struct ipipe_rsz_resize2rgb rsz2rgb[2];
+	struct ipipe_ext_mem_param ext_mem_param[2];
+	boolean_t rsz_en[2];
+};
+
+/* Struct for configuring Luminance Adjustment module */
+struct prev_lum_adj {
+	/* Brightness adjustments */
+	unsigned char brightness;
+	/* contrast adjustments */
+	unsigned char contrast;
+};
+
+#define MAX_IPIPE_RAW_YUV_PIX_FORMATS		2
+
+/* IPIPE module operation state */
+struct ipipe_oper_state {
+	/* Channel state 0 - free, 1 - busy */
+	unsigned int state;
+	/* Semaphore to protect the common hardware configuration */
+	struct mutex lock;
+	/* previewer config state */
+	unsigned int prev_config_state;
+	/* Shared configuration of the hardware */
+	struct ipipe_params *shared_config_param;
+	/* shared resource in use */
+	unsigned int resource_in_use;
+	/* resizer config state */
+	unsigned int rsz_config_state;
+	/* resizer chained with previewer */
+	unsigned int rsz_chained;
+	/* resizer output A/B is enabled? */
+	unsigned int rsz_output_enabled[2];
+	/* input mbus frame format */
+	struct v4l2_mbus_framefmt in_mbus_format;
+	/* output mbus frame format */
+	struct v4l2_mbus_framefmt out_mbus_format[2];
+	/* if_param for IPIPEIF */
+	struct vpfe_hw_if_param if_param;
+	/* Operation mode of image processor (imp)
+	 * 0 - continuous mode, 1 - single shot mode
+	 * 2 - invalid mode, 4 - not configured
+	 */
+	u32 oper_mode;
+	/* enable/disable serializer */
+	u32 en_serializer;
+	/* LUT Defect pixel correction data */
+	struct prev_lutdpc lutdpc;
+	/* LUT Defect pixel correction data */
+	struct prev_otfdpc otfdpc;
+	/* Noise filter */
+	struct prev_nf nf1;
+	struct prev_nf nf2;
+	/* Green Imbalance Correction */
+	struct prev_gic gic;
+	/* White Balance */
+	struct prev_wb wb;
+	/* CFA */
+	struct prev_cfa cfa;
+	/* RGB2RGB conversion */
+	struct prev_rgb2rgb rgb2rgb_1;
+	struct prev_rgb2rgb rgb2rgb_2;
+	/* Gamma correction */
+	struct prev_gamma gamma;
+	/* 3D LUT */
+	struct prev_3d_lut lut_3d;
+	/* Lumina Adjustment */
+	struct prev_lum_adj lum_adj;
+	/* RGB2YUV conversion */
+	struct prev_rgb2yuv rgb2yuv;
+	/* YUV 422 conversion */
+	struct prev_yuv422_conv yuv422_conv;
+	/* GBCE */
+	struct prev_gbce gbce;
+	/* Edge Enhancement */
+	struct prev_yee yee;
+	/* Chromatic Artifact Reduction, CAR */
+	struct prev_car car;
+	/* Chromatic Artifact Reduction, CAR */
+	struct prev_cgs cgs;
+	/* Tables for various tuning modules */
+	struct ipipe_lutdpc_entry ipipe_lutdpc_table[MAX_SIZE_DPC];
+	struct ipipe_3d_lut_entry ipipe_3d_lut_table[MAX_SIZE_3D_LUT];
+	unsigned short ipipe_gbce_table[MAX_SIZE_GBCE_LUT];
+	struct ipipe_gamma_entry ipipe_gamma_table_r[MAX_SIZE_GAMMA];
+	struct ipipe_gamma_entry ipipe_gamma_table_b[MAX_SIZE_GAMMA];
+	struct ipipe_gamma_entry ipipe_gamma_table_g[MAX_SIZE_GAMMA];
+	short ipipe_yee_table[MAX_SIZE_YEE_LUT];
+
+	/* Raw YUV formats */
+	u32 ipipe_raw_yuv_pix_formats[MAX_IPIPE_RAW_YUV_PIX_FORMATS];
+};
+
+#define IPIPE_COLPTN_R_Ye	0x0
+#define IPIPE_COLPTN_Gr_Cy	0x1
+#define IPIPE_COLPTN_Gb_G	0x2
+#define IPIPE_COLPTN_B_Mg	0x3
+
+#define COLPAT_EE_SHIFT		0
+#define COLPAT_EO_SHIFT		2
+#define COLPAT_OE_SHIFT		4
+#define COLPAT_OO_SHIFT		6
+
+#define ipipe_sgrbg_pattern \
+	(IPIPE_COLPTN_Gr_Cy <<  COLPAT_EE_SHIFT | \
+	IPIPE_COLPTN_R_Ye  << COLPAT_EO_SHIFT | \
+	IPIPE_COLPTN_B_Mg  << COLPAT_OE_SHIFT | \
+	IPIPE_COLPTN_Gb_G  << COLPAT_OO_SHIFT)
+
+#define ipipe_srggb_pattern \
+	(IPIPE_COLPTN_R_Ye <<  COLPAT_EE_SHIFT | \
+	IPIPE_COLPTN_Gr_Cy  << COLPAT_EO_SHIFT | \
+	IPIPE_COLPTN_Gb_G  << COLPAT_OE_SHIFT | \
+	IPIPE_COLPTN_B_Mg  << COLPAT_OO_SHIFT)
+
+struct vpfe_prev_params {
+	__u32 flag;
+	struct prev_ipipeif_config ipipeif_config;
+	struct prev_lutdpc lutdpc;
+	struct prev_otfdpc otfdpc;
+	struct prev_nf nf1;
+	struct prev_nf nf2;
+	struct prev_gic gic;
+	struct prev_wb wbal;
+	struct prev_cfa cfa;
+	struct prev_rgb2rgb rgb2rgb1;
+	struct prev_rgb2rgb rgb2rgb2;
+	struct prev_gamma gamma;
+	struct prev_3d_lut lut;
+	struct prev_rgb2yuv rgb2yuv;
+	struct prev_gbce gbce;
+	struct prev_yuv422_conv yuv422_conv;
+	struct prev_yee yee;
+	struct prev_car car;
+	struct prev_cgs cgs;
+};
+
+void ipipe_set_d2f_regs(unsigned int id, struct prev_nf *noise_filter);
+void ipipe_set_rgb2rgb_regs(unsigned int id, struct prev_rgb2rgb *rgb);
+void rsz_set_output_address(struct ipipe_params *params,
+			      int resize_no, unsigned int address);
+void ipipe_set_yuv422_conv_regs(struct prev_yuv422_conv *conv);
+void ipipe_set_lum_adj_regs(struct prev_lum_adj *lum_adj);
+void ipipe_set_rgb2ycbcr_regs(struct prev_rgb2yuv *yuv);
+void ipipe_set_lutdpc_regs(struct prev_lutdpc *lutdpc);
+void ipipe_set_otfdpc_regs(struct prev_otfdpc *otfdpc);
+void ipipe_set_3d_lut_regs(struct prev_3d_lut *lut_3d);
+void ipipe_set_gamma_regs(struct prev_gamma *gamma);
+int ipipe_hw_setup(struct ipipe_params *config);
+void ipipe_set_gbce_regs(struct prev_gbce *gbce);
+void ipipe_set_gic_regs(struct prev_gic *gic);
+void ipipe_set_cfa_regs(struct prev_cfa *cfa);
+void ipipe_set_car_regs(struct prev_car *car);
+void ipipe_set_cgs_regs(struct prev_cgs *cgs);
+void rsz_set_in_pix_format(unsigned char y_c);
+void ipipe_set_ee_regs(struct prev_yee *ee);
+void ipipe_set_wb_regs(struct prev_wb *wb);
+int rsz_enable(int rsz_id, int enable);
+void rsz_src_enable(int enable);
+
+#endif
diff --git a/drivers/media/platform/davinci/imp_hw_if.h b/drivers/media/platform/davinci/imp_hw_if.h
new file mode 100644
index 0000000..14187c9
--- /dev/null
+++ b/drivers/media/platform/davinci/imp_hw_if.h
@@ -0,0 +1,180 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _IMP_HW_IF_H
+#define _IMP_HW_IF_H
+
+#include "vpfe_imp_common.h"
+
+struct prev_module_if {
+	unsigned int param_offset;
+	unsigned int param_size;
+	unsigned int config_offset;
+	int (*set)(struct device *dev, void *ipipe, void *param, int len);
+	int (*get)(struct device *dev, void *ipipe, void *param, int len);
+};
+
+struct imp_window {
+	/* horizontal size */
+	unsigned int width;
+	/* vertical size */
+	unsigned int height;
+	/* horizontal start position */
+	unsigned int hst;
+	/* vertical start position */
+	unsigned int vst;
+};
+
+struct imp_hw_interface {
+	/* Name of the image processor hardware */
+	char *name;
+	/* module owner */
+	struct module *owner;
+	/*
+	 * enumerate preview modules. Return interface to the
+	 * the module
+	 */
+	struct prev_module_if *(*prev_enum_modules) (struct device *dev,
+							unsigned int index);
+	/*
+	 * set operating mode for IPIPE; 1-single shot, 0-continous
+	 */
+	int (*set_oper_mode) (void *ipipe, unsigned int mode);
+	/*
+	 * reset operating mode for IPIPE;
+	 */
+	void (*reset_oper_mode) (void *ipipe);
+	/*
+	 *  get IPIPE operation mode
+	 */
+	unsigned int (*get_oper_mode) (void *ipipe);
+	/* check if hw is busy in continuous mode.
+	 * Used for checking if hw is used by ccdc driver in
+	 * continuous mode. If streaming is ON, this will be
+	 * set to busy
+	 */
+	unsigned int (*get_hw_state) (void *ipipe);
+	/* set hw state */
+	void (*set_hw_state) (void *ipipe, unsigned int state);
+	/* is resizer chained ? */
+	unsigned int (*resizer_chain) (void *ipipe);
+	/* this is used to lock shared resource */
+	void (*lock_chain) (void *ipipe);
+	/* this is used unlock shared resouce */
+	void (*unlock_chain) (void *ipipe);
+	/* Allocate a shared or exclusive config block for hardware
+	 * configuration
+	 */
+	void *(*alloc_config_block) (struct device *dev, void *ipipe);
+	/* hw serialization enabled ?? */
+	int (*serialize) (void *ipipe);
+	/* De-allocate the exclusive config block */
+	void (*dealloc_config_block) (struct device *dev, void *ipipe,
+						void *config);
+	/* Allocate a user confguration block */
+	void *(*alloc_user_config_block) (struct device *dev, void *ipipe,
+					  enum imp_log_chan_t chan_type);
+
+	/* de-allocate user config block */
+	void (*dealloc_user_config_block) (struct device *dev, void *ipipe,
+							  void *config);
+
+	/* set default configuration in the config block */
+	void (*set_user_config_defaults) (struct device *dev, void *ipipe,
+					  enum imp_log_chan_t chan_type,
+					  void *user_config);
+	/* set user configuration for preview */
+	int (*set_preview_config) (struct device *dev, void *ipipe,
+				   void *user_config, void *config);
+	/* set user configuration for resize */
+	int (*set_resizer_config) (struct device *dev, void *ipipe,
+				   int resizer_chained,
+				   void *user_config, void *config);
+	/* set previewer module params */
+	int (*set_preview_module_params) (struct device *dev, void *ipipe,
+				struct vpfe_prev_config *cfg);
+	/* get previewer module params */
+	int (*get_preview_module_params) (struct device *dev, void *ipipe,
+				struct vpfe_prev_config *cfg);
+	/* update output buffer address for a channel
+	 * if config is NULL, the shared config is assumed
+	 * this is used only in single shot mode
+	 */
+	int (*update_inbuf_address) (void *config, unsigned int address);
+	/* update output buffer address for a channel
+	 * if config is NULL, the shared config is assumed
+	 */
+	void (*update_outbuf1_address) (void *ipipe, void *config,
+						  unsigned int address);
+	/* update output buffer address for a channel
+	 * if config is NULL, the shared config is assumed
+	 */
+	void (*update_outbuf2_address) (void *ipipe, void *config,
+						  unsigned int address);
+	/* enable or disable hw */
+	void (*enable) (void *ipipe, unsigned char en, void *config);
+	/* enable or disable resizer to allow frame by frame resize in
+	 * continuous mode
+	 */
+	void (*enable_resize) (int en);
+	/* setup hardware for processing. if config is NULL,
+	 * shared channel is assumed
+	 */
+	int (*hw_setup) (struct device *dev, void *ipipe, void *config);
+	/* Get configuration state of resizer in continuous mode */
+	unsigned int (*get_resizer_config_state) (void *ipipe);
+	/* Get configuration state of previewer in continuous mode */
+	unsigned int (*get_previewer_config_state) (void *ipipe);
+	/* Get current input crop window param at the IMP */
+	int (*get_input_win) (void *ipipe, struct imp_window *win);
+	/* Set interface parameter at IPIPEIF. Only valid for DM360 */
+	int (*set_hw_if_param) (void *ipipe, struct vpfe_hw_if_param *param);
+	/* Set input mbus format */
+	void (*set_in_mbus_format) (void *ipipe,
+					struct v4l2_mbus_framefmt *format);
+	/* set output mbus format */
+	void (*set_out_mbus_format) (void *ipipe,
+					struct v4l2_mbus_framefmt *format);
+	/* set output2(resizer-B) mbus format */
+	void (*set_out2_mbus_format) (void *ipipe,
+					struct v4l2_mbus_framefmt *format);
+	/* Get output enable/disable status */
+	int (*get_output_state) (void *ipipe, unsigned char out_sel);
+	/* Get output line lenght */
+	int (*get_line_length) (void *ipipe, unsigned char out_sel);
+	/* Get the output image height */
+	int (*get_image_height) (void *ipipe, unsigned char out_sel);
+	/* Get current output window param at the IMP */
+	int (*get_output_win) (void *ipipe, struct imp_window *win);
+	/* get maximum output width of rsz-a or rsz_b*/
+	int (*get_max_output_width) (int rsz);
+	/* get maximum output height of rsa-a or rsz-b */
+	int (*get_max_output_height) (int rsz);
+	/* Enumerate pixel format for a given input format */
+	int (*enum_pix) (void *ipipe, u32 *output_pix, int index);
+	/* set control */
+	int (*prv_s_ctrl) (void *ipipe, u32 ctrl_id, s32 val);
+
+};
+
+struct imp_hw_interface *imp_get_hw_if(void);
+
+#endif
diff --git a/drivers/media/platform/davinci/vpfe_imp_common.h b/drivers/media/platform/davinci/vpfe_imp_common.h
new file mode 100644
index 0000000..89aea31
--- /dev/null
+++ b/drivers/media/platform/davinci/vpfe_imp_common.h
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _DAVINCI_VPFE_IMP_COMMON_H
+#define _DAVINCI_VPFE_IMP_COMMON_H
+
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/completion.h>
+#include <linux/davinci_vpfe.h>
+
+#define MAX_CHANNELS		2
+#define MAX_BUFFERS		6
+#define MAX_PRIORITY		5
+#define MIN_PRIORITY		0
+#define DEFAULT_PRIORITY	3
+#define ENABLED			1
+#define DISABLED		0
+#define CHANNEL_BUSY		1
+#define CHANNEL_FREE		0
+
+#define IMP_MODE_CONTINUOUS	0
+#define IMP_MODE_SINGLE_SHOT	1
+#define IMP_MODE_INVALID	2
+#define IMP_MODE_NOT_CONFIGURED	4
+
+/* driver configured by application */
+#define STATE_CONFIGURED	1
+/* driver not configured by application */
+#define STATE_NOT_CONFIGURED	0
+
+enum imp_log_chan_t {
+	IMP_PREVIEWER,
+	IMP_RESIZER,
+	IMP_HISTOGRAM,
+	IMP_BOXCAR
+};
+
+/* IMP channel structure */
+struct imp_logical_channel {
+	/* channel type */
+	enum imp_log_chan_t type;
+	/* channel configuration for this logial channel */
+	void *config;
+	/* Saves the user configuration */
+	void *user_config;
+	/* configure State of the channel */
+	unsigned int config_state;
+};
+
+/* Where hardware channel is shared, this is used for serialisation */
+struct imp_serializer {
+	/* channel config array for serialization */
+	struct imp_logical_channel *channel_config[MAX_CHANNELS];
+	/* number of elements in the array */
+	int array_count;
+	/* Semaphore for above config array */
+	struct mutex array_sem;
+	/* Completion semaphore when hw channel is common
+	 * Use device specific completion semaphore when request is serialized
+	 */
+	struct completion sem_isr;
+};
+
+#endif
diff --git a/include/linux/davinci_vpfe.h b/include/linux/davinci_vpfe.h
new file mode 100644
index 0000000..35a5dd9
--- /dev/null
+++ b/include/linux/davinci_vpfe.h
@@ -0,0 +1,929 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * Contributors:
+ *      Manjunath Hadli <manjunath.hadli@ti.com>
+ *      Prabhakar Lad <prabhakar.lad@ti.com>
+ */
+
+#ifndef _DAVINCI_VPFE_H
+#define _DAVINCI_VPFE_H
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+#include "dm3xx_ipipeif.h"
+
+/**********************************************************************
+      Previewer API Structures
+**********************************************************************/
+
+/* Preview module configurations */
+
+/* IPIEIF configuration */
+#define PREV_IPIPEIF		(1 << 0)
+/* LUT based Defect Pixel Correction */
+#define PREV_LUTDPC		(1 << 1)
+/* On the fly (OTF) Defect Pixel Correction */
+#define PREV_OTFDPC		(1 << 2)
+/* Noise Filter - 1 */
+#define PREV_NF1		(1 << 3)
+/* Noise Filter - 2 */
+#define PREV_NF2		(1 << 4)
+/* White Balance.  Also a control ID */
+#define PREV_WB			(1 << 5)
+/* 1st RGB to RBG Blend module */
+#define PREV_RGB2RGB_1		(1 << 6)
+/* 2nd RGB to RBG Blend module */
+#define PREV_RGB2RGB_2		(1 << 7)
+/* Gamma Correction */
+#define PREV_GAMMA		(1 << 8)
+/* 3D LUT color conversion */
+#define PREV_3D_LUT		(1 << 9)
+/* RGB to YCbCr module */
+#define PREV_RGB2YUV		(1 << 10)
+/* YUV 422 conversion module */
+#define PREV_YUV422_CONV	(1 << 11)
+/* Edge Enhancement */
+#define PREV_YEE		(1 << 12)
+/* Green Imbalance Correction */
+#define PREV_GIC		(1 << 13)
+/* CFA Interpolation */
+#define PREV_CFA		(1 << 14)
+/* Chroma Artifact Reduction */
+#define PREV_CAR		(1 << 15)
+/* Chroma Gain Suppression */
+#define PREV_CGS		(1 << 16)
+/* Global brighness and contrast control */
+#define PREV_GBCE		(1 << 17)
+/* Last module ID */
+#define PREV_MAX_MODULES	18
+
+struct ipipe_float_u16 {
+	unsigned short integer;
+	unsigned short decimal;
+};
+
+struct ipipe_float_s16 {
+	short integer;
+	unsigned short decimal;
+};
+
+struct ipipe_float_u8 {
+	unsigned char integer;
+	unsigned char decimal;
+};
+
+/* Copy method selection for vertical correction
+ *  Used when ipipe_dfc_corr_meth is PREV_DPC_CTORB_AFTER_HINT
+ */
+enum ipipe_dpc_corr_meth {
+	/* replace by black or white dot specified by repl_white */
+	IPIPE_DPC_REPL_BY_DOT = 0,
+	/* Copy from left */
+	IPIPE_DPC_CL,
+	/* Copy from right */
+	IPIPE_DPC_CR,
+	/* Horizontal interpolation */
+	IPIPE_DPC_H_INTP,
+	/* Vertical interpolation */
+	IPIPE_DPC_V_INTP,
+	/* Copy from top  */
+	IPIPE_DPC_CT,
+	/* Copy from bottom */
+	IPIPE_DPC_CB,
+	/* 2D interpolation */
+	IPIPE_DPC_2D_INTP,
+};
+
+struct ipipe_lutdpc_entry {
+	/* Horizontal position */
+	unsigned short horz_pos;
+	/* vertical position */
+	unsigned short vert_pos;
+	enum ipipe_dpc_corr_meth method;
+};
+
+#define MAX_SIZE_DPC 256
+/* Struct for configuring DPC module */
+struct prev_lutdpc {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* 0 - replace with black dot, 1 - white dot when correction
+	 * method is  IPIPE_DFC_REPL_BY_DOT=0,
+	 */
+	unsigned char repl_white;
+	/* number of entries in the correction table. Currently only
+	 * support upto 256 entries. infinite mode is not supported
+	 */
+	unsigned short dpc_size;
+	struct ipipe_lutdpc_entry table[MAX_SIZE_DPC];
+};
+
+enum ipipe_otfdpc_det_meth {
+	IPIPE_DPC_OTF_MIN_MAX,
+	IPIPE_DPC_OTF_MIN_MAX2
+};
+
+struct ipipe_otfdpc_thr {
+	unsigned short r;
+	unsigned short gr;
+	unsigned short gb;
+	unsigned short b;
+};
+
+enum ipipe_otfdpc_alg {
+	IPIPE_OTFDPC_2_0,
+	IPIPE_OTFDPC_3_0
+};
+
+struct prev_otfdpc_2_0 {
+	/* defect detection threshold for MIN_MAX2 method  (DPC 2.0 alg) */
+	struct ipipe_otfdpc_thr det_thr;
+	/* defect correction threshold for MIN_MAX2 method (DPC 2.0 alg) or
+	 * maximum value for MIN_MAX method
+	 */
+	struct ipipe_otfdpc_thr corr_thr;
+};
+
+struct prev_otfdpc_3_0 {
+	/* DPC3.0 activity adj shf. activity = (max2-min2) >> (6 -shf)
+	 */
+	unsigned char act_adj_shf;
+	/* DPC3.0 detection threshold, THR */
+	unsigned short det_thr;
+	/* DPC3.0 detection threshold slope, SLP */
+	unsigned short det_slp;
+	/* DPC3.0 detection threshold min, MIN */
+	unsigned short det_thr_min;
+	/* DPC3.0 detection threshold max, MAX */
+	unsigned short det_thr_max;
+	/* DPC3.0 correction threshold, THR */
+	unsigned short corr_thr;
+	/* DPC3.0 correction threshold slope, SLP */
+	unsigned short corr_slp;
+	/* DPC3.0 correction threshold min, MIN */
+	unsigned short corr_thr_min;
+	/* DPC3.0 correction threshold max, MAX */
+	unsigned short corr_thr_max;
+};
+
+struct prev_otfdpc {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* defect detection method */
+	enum ipipe_otfdpc_det_meth det_method;
+	/* Algorith used. Applicable only when IPIPE_DPC_OTF_MIN_MAX2 is
+	 * used
+	 */
+	enum ipipe_otfdpc_alg alg;
+	union {
+		/* if alg is IPIPE_OTFDPC_2_0 */
+		struct prev_otfdpc_2_0 dpc_2_0;
+		/* if alg is IPIPE_OTFDPC_3_0 */
+		struct prev_otfdpc_3_0 dpc_3_0;
+	} alg_cfg;
+};
+
+/* Threshold values table size */
+#define IPIPE_NF_THR_TABLE_SIZE 8
+/* Intensity values table size */
+#define IPIPE_NF_STR_TABLE_SIZE 8
+
+/* NF, sampling method for green pixels */
+enum ipipe_nf_sampl_meth {
+	/* Same as R or B */
+	IPIPE_NF_BOX,
+	/* Diamond mode */
+	IPIPE_NF_DIAMOND
+};
+
+/* Struct for configuring NF module */
+struct prev_nf {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* Sampling method for green pixels */
+	enum ipipe_nf_sampl_meth gr_sample_meth;
+	/* Down shift value in LUT reference address
+	 */
+	unsigned char shft_val;
+	/* Spread value in NF algorithm
+	 */
+	unsigned char spread_val;
+	/* Apply LSC gain to threshold. Enable this only if
+	 * LSC is enabled in ISIF
+	 */
+	unsigned char apply_lsc_gain;
+	/* Threshold values table */
+	unsigned short thr[IPIPE_NF_THR_TABLE_SIZE];
+	/* intensity values table */
+	unsigned char str[IPIPE_NF_STR_TABLE_SIZE];
+	/* Edge detection minimum threshold */
+	unsigned short edge_det_min_thr;
+	/* Edge detection maximum threshold */
+	unsigned short edge_det_max_thr;
+};
+
+enum ipipe_gic_alg {
+	IPIPE_GIC_ALG_CONST_GAIN,
+	IPIPE_GIC_ALG_ADAPT_GAIN
+};
+
+enum ipipe_gic_thr_sel {
+	IPIPE_GIC_THR_REG,
+	IPIPE_GIC_THR_NF
+};
+
+enum ipipe_gic_wt_fn_type {
+	/* Use difference as index */
+	IPIPE_GIC_WT_FN_TYP_DIF,
+	/* Use weight function as index */
+	IPIPE_GIC_WT_FN_TYP_HP_VAL
+};
+
+/* structure for Green Imbalance Correction */
+struct prev_gic {
+	/* 0 - disable, 1 - enable */
+	unsigned char en;
+	/* 0 - Constant gain , 1 - Adaptive gain algorithm */
+	enum ipipe_gic_alg gic_alg;
+	/* GIC gain or weight. Used for Constant gain and Adaptive algorithms
+	 */
+	unsigned short gain;
+	/* Threshold selection. GIC register values or NF2 thr table */
+	enum ipipe_gic_thr_sel thr_sel;
+	/* thr1. Used when thr_sel is  IPIPE_GIC_THR_REG */
+	unsigned short thr;
+	/* this value is used for thr2-thr1, thr3-thr2 or
+	 * thr4-thr3 when wt_fn_type is index. Otherwise it
+	 * is the
+	 */
+	unsigned short slope;
+	/* Apply LSC gain to threshold. Enable this only if
+	 * LSC is enabled in ISIF & thr_sel is IPIPE_GIC_THR_REG
+	 */
+	unsigned char apply_lsc_gain;
+	/* Multiply Nf2 threshold by this gain. Use this when thr_sel
+	 * is IPIPE_GIC_THR_NF
+	 */
+	struct ipipe_float_u8 nf2_thr_gain;
+	/* Weight function uses difference as index or high pass value.
+	 * Used for adaptive gain algorithm
+	 */
+	enum ipipe_gic_wt_fn_type wt_fn_type;
+};
+
+/* Struct for configuring WB module */
+struct prev_wb {
+	/* Offset (S12) for R */
+	short ofst_r;
+	/* Offset (S12) for Gr */
+	short ofst_gr;
+	/* Offset (S12) for Gb */
+	short ofst_gb;
+	/* Offset (S12) for B */
+	short ofst_b;
+	/* Gain (U13Q9) for Red */
+	struct ipipe_float_u16 gain_r;
+	/* Gain (U13Q9) for Gr */
+	struct ipipe_float_u16 gain_gr;
+	/* Gain (U13Q9) for Gb */
+	struct ipipe_float_u16 gain_gb;
+	/* Gain (U13Q9) for Blue */
+	struct ipipe_float_u16 gain_b;
+};
+
+enum ipipe_cfa_alg {
+	/* Algorithm is 2DirAC */
+	IPIPE_CFA_ALG_2DIRAC,
+	/* Algorithm is 2DirAC + Digital Antialiasing (DAA) */
+	IPIPE_CFA_ALG_2DIRAC_DAA,
+	/* Algorithm is DAA */
+	IPIPE_CFA_ALG_DAA
+};
+
+/* Structure for CFA Interpolation */
+struct prev_cfa {
+	/* 2DirAC or 2DirAC + DAA */
+	enum ipipe_cfa_alg alg;
+	/* 2Dir CFA HP value Low Threshold */
+	unsigned short hpf_thr_2dir;
+	/* 2Dir CFA HP value slope */
+	unsigned short hpf_slp_2dir;
+	/* 2Dir CFA HP mix threshold */
+	unsigned short hp_mix_thr_2dir;
+	/* 2Dir CFA HP mix slope */
+	unsigned short hp_mix_slope_2dir;
+	/* 2Dir Direction threshold */
+	unsigned short dir_thr_2dir;
+	/* 2Dir Direction slope */
+	unsigned short dir_slope_2dir;
+	/* 2Dir NonDirectional Weight */
+	unsigned short nd_wt_2dir;
+	/* DAA Mono Hue Fraction */
+	unsigned short hue_fract_daa;
+	/* DAA Mono Edge threshold */
+	unsigned short edge_thr_daa;
+	/* DAA Mono threshold minimum */
+	unsigned short thr_min_daa;
+	/* DAA Mono threshold slope */
+	unsigned short thr_slope_daa;
+	/* DAA Mono slope minimum */
+	unsigned short slope_min_daa;
+	/* DAA Mono slope slope */
+	unsigned short slope_slope_daa;
+	/* DAA Mono LP wight */
+	unsigned short lp_wt_daa;
+};
+
+/* Struct for configuring RGB2RGB blending module */
+struct prev_rgb2rgb {
+	/* Matrix coefficient for RR S12Q8 for ID = 1 and S11Q8 for ID = 2 */
+	struct ipipe_float_s16 coef_rr;
+	/* Matrix coefficient for GR S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gr;
+	/* Matrix coefficient for BR S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_br;
+	/* Matrix coefficient for RG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_rg;
+	/* Matrix coefficient for GG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gg;
+	/* Matrix coefficient for BG S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_bg;
+	/* Matrix coefficient for RB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_rb;
+	/* Matrix coefficient for GB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_gb;
+	/* Matrix coefficient for BB S12Q8/S11Q8 */
+	struct ipipe_float_s16 coef_bb;
+	/* Output offset for R S13/S11 */
+	int out_ofst_r;
+	/* Output offset for G S13/S11 */
+	int out_ofst_g;
+	/* Output offset for B S13/S11 */
+	int out_ofst_b;
+};
+
+#define MAX_SIZE_GAMMA 512
+
+enum ipipe_gamma_tbl_size {
+	IPIPE_GAMMA_TBL_SZ_64 = 64,
+	IPIPE_GAMMA_TBL_SZ_128 = 128,
+	IPIPE_GAMMA_TBL_SZ_256 = 256,
+	IPIPE_GAMMA_TBL_SZ_512 = 512
+};
+
+enum ipipe_gamma_tbl_sel {
+	IPIPE_GAMMA_TBL_RAM,
+	IPIPE_GAMMA_TBL_ROM
+};
+
+struct ipipe_gamma_entry {
+	/* 10 bit slope */
+	short slope;
+	/* 10 bit offset */
+	unsigned short offset;
+};
+
+/* Struct for configuring Gamma correction module */
+struct prev_gamma {
+	/* 0 - Enable Gamma correction for Red
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_r;
+	/* 0 - Enable Gamma correction for Blue
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_b;
+	/* 0 - Enable Gamma correction for Green
+	 * 1 - bypass Gamma correction. Data is divided by 16
+	 */
+	unsigned char bypass_g;
+	/* PREV_GAMMA_TBL_RAM or PREV_GAMMA_TBL_ROM */
+	enum ipipe_gamma_tbl_sel tbl_sel;
+	/* Table size for RAM gamma table.
+	 */
+	enum ipipe_gamma_tbl_size tbl_size;
+	/* R table */
+	struct ipipe_gamma_entry table_r[MAX_SIZE_GAMMA];
+	/* Blue table */
+	struct ipipe_gamma_entry table_b[MAX_SIZE_GAMMA];
+	/* Green table */
+	struct ipipe_gamma_entry table_g[MAX_SIZE_GAMMA];
+};
+
+#define MAX_SIZE_3D_LUT		729
+
+struct ipipe_3d_lut_entry {
+	/* 10 bit entry for red */
+	unsigned short r;
+	/* 10 bit entry for green */
+	unsigned short g;
+	/* 10 bit entry for blue */
+	unsigned short b;
+};
+
+/* structure for 3D-LUT */
+struct prev_3d_lut {
+	/* enable/disable 3D lut */
+	unsigned char en;
+	/* 3D - LUT table entry */
+	struct ipipe_3d_lut_entry table[MAX_SIZE_3D_LUT];
+};
+
+/* Struct for configuring rgb2ycbcr module */
+struct prev_rgb2yuv {
+	/* Matrix coefficient for RY S12Q8 */
+	struct ipipe_float_s16 coef_ry;
+	/* Matrix coefficient for GY S12Q8 */
+	struct ipipe_float_s16 coef_gy;
+	/* Matrix coefficient for BY S12Q8 */
+	struct ipipe_float_s16 coef_by;
+	/* Matrix coefficient for RCb S12Q8 */
+	struct ipipe_float_s16 coef_rcb;
+	/* Matrix coefficient for GCb S12Q8 */
+	struct ipipe_float_s16 coef_gcb;
+	/* Matrix coefficient for BCb S12Q8 */
+	struct ipipe_float_s16 coef_bcb;
+	/* Matrix coefficient for RCr S12Q8 */
+	struct ipipe_float_s16 coef_rcr;
+	/* Matrix coefficient for GCr S12Q8 */
+	struct ipipe_float_s16 coef_gcr;
+	/* Matrix coefficient for BCr S12Q8 */
+	struct ipipe_float_s16 coef_bcr;
+	/* Output offset for R S11 */
+	int out_ofst_y;
+	/* Output offset for Cb S11 */
+	int out_ofst_cb;
+	/* Output offset for Cr S11 */
+	int out_ofst_cr;
+};
+
+enum ipipe_gbce_type {
+	IPIPE_GBCE_Y_VAL_TBL,
+	IPIPE_GBCE_GAIN_TBL
+};
+
+#define MAX_SIZE_GBCE_LUT 1024
+
+/* structure for Global brighness and Contrast */
+struct prev_gbce {
+	/* enable/disable GBCE */
+	unsigned char en;
+	/* Y - value table or Gain table */
+	enum ipipe_gbce_type type;
+	/* ptr to LUT for GBCE with 1024 entries */
+	unsigned short table[MAX_SIZE_GBCE_LUT];
+};
+
+/* Chrominance position. Applicable only for YCbCr input
+ * Applied after edge enhancement
+ */
+enum ipipe_chr_pos {
+	/* Cositing, same position with luminance */
+	IPIPE_YUV422_CHR_POS_COSITE,
+	/* Centering, In the middle of luminance */
+	IPIPE_YUV422_CHR_POS_CENTRE
+};
+
+/* Struct for configuring yuv422 conversion module */
+struct prev_yuv422_conv {
+	/* Max Chrominance value */
+	unsigned char en_chrom_lpf;
+	/* 1 - enable LPF for chrminance, 0 - disable */
+	enum ipipe_chr_pos chrom_pos;
+};
+
+#define MAX_SIZE_YEE_LUT 1024
+
+enum ipipe_yee_merge_meth {
+	IPIPE_YEE_ABS_MAX,
+	IPIPE_YEE_EE_ES
+};
+
+/* Struct for configuring YUV Edge Enhancement module */
+struct prev_yee {
+	/* 1 - enable enhancement, 0 - disable */
+	unsigned char en;
+	/* enable/disable halo reduction in edge sharpner */
+	unsigned char en_halo_red;
+	/* Merge method between Edge Enhancer and Edge sharpner */
+	enum ipipe_yee_merge_meth merge_meth;
+	/* HPF Shift length */
+	unsigned char hpf_shft;
+	/* HPF Coefficient 00, S10 */
+	short hpf_coef_00;
+	/* HPF Coefficient 01, S10 */
+	short hpf_coef_01;
+	/* HPF Coefficient 02, S10 */
+	short hpf_coef_02;
+	/* HPF Coefficient 10, S10 */
+	short hpf_coef_10;
+	/* HPF Coefficient 11, S10 */
+	short hpf_coef_11;
+	/* HPF Coefficient 12, S10 */
+	short hpf_coef_12;
+	/* HPF Coefficient 20, S10 */
+	short hpf_coef_20;
+	/* HPF Coefficient 21, S10 */
+	short hpf_coef_21;
+	/* HPF Coefficient 22, S10 */
+	short hpf_coef_22;
+	/* Lower threshold before refering to LUT */
+	unsigned short yee_thr;
+	/* Edge sharpener Gain */
+	unsigned short es_gain;
+	/* Edge sharpener lowe threshold */
+	unsigned short es_thr1;
+	/* Edge sharpener upper threshold */
+	unsigned short es_thr2;
+	/* Edge sharpener gain on gradient */
+	unsigned short es_gain_grad;
+	/* Edge sharpener offset on gradient */
+	unsigned short es_ofst_grad;
+	/* Ptr to EE table. Must have 1024 entries */
+	short table[MAX_SIZE_YEE_LUT];
+};
+
+enum ipipe_car_meth {
+	/* Chromatic Gain Control */
+	IPIPE_CAR_CHR_GAIN_CTRL,
+	/* Dynamic switching between CHR_GAIN_CTRL
+	 * and MED_FLTR
+	 */
+	IPIPE_CAR_DYN_SWITCH,
+	/* Median Filter */
+	IPIPE_CAR_MED_FLTR
+};
+
+enum ipipe_car_hpf_type {
+	IPIPE_CAR_HPF_Y,
+	IPIPE_CAR_HPF_H,
+	IPIPE_CAR_HPF_V,
+	IPIPE_CAR_HPF_2D,
+	/* 2D HPF from YUV Edge Enhancement */
+	IPIPE_CAR_HPF_2D_YEE
+};
+
+struct ipipe_car_gain {
+	/* csup_gain */
+	unsigned char gain;
+	/* csup_shf. */
+	unsigned char shft;
+	/* gain minimum */
+	unsigned short gain_min;
+};
+
+/* Structure for Chromatic Artifact Reduction */
+struct prev_car {
+	/* enable/disable */
+	unsigned char en;
+	/* Gain control or Dynamic switching */
+	enum ipipe_car_meth meth;
+	/* Gain1 function configuration for Gain control */
+	struct ipipe_car_gain gain1;
+	/* Gain2 function configuration for Gain control */
+	struct ipipe_car_gain gain2;
+	/* HPF type used for CAR */
+	enum ipipe_car_hpf_type hpf;
+	/* csup_thr: HPF threshold for Gain control */
+	unsigned char hpf_thr;
+	/* Down shift value for hpf. 2 bits */
+	unsigned char hpf_shft;
+	/* switch limit for median filter */
+	unsigned char sw0;
+	/* switch coefficient for Gain control */
+	unsigned char sw1;
+};
+
+/* structure for Chromatic Gain Suppression */
+struct prev_cgs {
+	/* enable/disable */
+	unsigned char en;
+	/* gain1 bright side threshold */
+	unsigned char h_thr;
+	/* gain1 bright side slope */
+	unsigned char h_slope;
+	/* gain1 down shift value for bright side */
+	unsigned char h_shft;
+	/* gain1 bright side minimum gain */
+	unsigned char h_min;
+};
+
+enum ipipe_dpaths_bypass_t {
+	IPIPE_BYPASS_OFF,
+	IPIPE_BYPASS_ON
+};
+
+/* Max pixels allowed in the input. If above this either decimation
+ * or frame division mode to be enabled
+ */
+#define IPIPE_MAX_INPUT_WIDTH 2600
+
+/* Max pixels in resizer - A output. In downscale
+ * (DSCALE) mode, image quality is better, but has lesser
+ * maximum width allowed
+ */
+#define IPIPE_MAX_OUTPUT1_WIDTH_NORMAL 2176
+#define IPIPE_MAX_OUTPUT1_WIDTH_DSCALE 1088
+
+/* Max pixels in resizer - B output. In downscale
+ * (DSCALE) mode, image quality is better, but has lesser
+ * maximum width allowed
+ */
+#define IPIPE_MAX_OUTPUT2_WIDTH_NORMAL 1088
+#define IPIPE_MAX_OUTPUT2_WIDTH_DSCALE 544
+
+struct prev_ipipef_input_spec {
+	/* line length. This will allow application to set a
+	 * different line length than that calculated based on
+	 * width. Set it to zero, if not used,
+	 */
+	unsigned int line_length;
+	/* vertical start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int vst;
+	/* horizontal start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int hst;
+	/* Global frame HD rate */
+	unsigned int ppln;
+	/* Global frame VD rate */
+	unsigned int lpfr;
+	/* clock divide to bring down the pixel clock */
+	struct ipipeif_5_1_clkdiv clk_div;
+	/* When input image width is greater that line buffer
+	 * size, use this to do resize using frame division. The
+	 * frame is divided into two vertical slices and resize
+	 * is performed on each slice. Use either frame division
+	 *  mode or decimation, NOT both
+	 */
+	unsigned char frame_div_mode_en;
+};
+
+struct prev_ipipeif_config {
+	/* used for single shot mode */
+	struct prev_ipipef_input_spec input_spec;
+	/* Bypass image processing. RAW -> RAW */
+	enum ipipe_dpaths_bypass_t bypass;
+	/* Enable decimation 1 - enable, 0 - disable
+	 * This is used when image width is greater than
+	 * ipipe line buffer size
+	 */
+	enum ipipeif_decimation dec_en;
+	/* used when en_dec = 1. Resize ratio for decimation
+	 * when frame size is  greater than what hw can handle.
+	 * 16 to 112. IPIPE input width is calculated as follows.
+	 * width = image_width * 16/ipipeif_rsz. For example
+	 * if image_width is 1920 and user want to scale it down
+	 * to 1280, use ipipeif_rsz = 24. 1920*16/24 = 1280
+	 */
+	unsigned char rsz;
+	/* Enable/Disable avg filter at IPIPEIF.
+	 * 1 - enable, 0 - disable
+	 */
+	unsigned char avg_filter_en;
+	/* clipped to this value at the ipipeif */
+	unsigned short clip;
+	/* Align HSync and VSync to rsz_start */
+	unsigned char align_sync;
+	/* ipipeif resize start position */
+	unsigned int rsz_start;
+	/* Simple defect pixel correction based on a threshold value */
+	struct ipipeif_dpc dpc;
+};
+
+/**
+ * struct vpfe_prev_config - Preview engine configuration (user)
+ * @ipipeif_config: Pointer to structure for ipipeif configuration.
+ * @flag: Specifies which ISP Preview functions should be enabled.
+ * @lutdpc: Pointer to luma enhancement structure.
+ * @otfdpc: Pointer to structure for defect correction.
+ * @nf1: Pointer to structure for Noise Filter.
+ * @nf2: Pointer to structure for Noise Filter.
+ * @gic: Pointer to structure for Green Imbalance.
+ * @wbal: Pointer to structure for White Balance.
+ * @cfa: Pointer to structure containing the CFA interpolation.
+ * @rgb2rgb1: Pointer to structure for RGB to RGB Blending.
+ * @rgb2rgb2: Pointer to structure for RGB to RGB Blending.
+ * @gamma: Pointer to gamma structure.
+ * @lut: Pointer to structure for 3D LUT.
+ * @rgb2yuv: Pointer to structure for RGB-YCbCr conversion.
+ * @gbce: Pointer to structure for Global Brightness,Contrast Control.
+ * @yuv422_conv: Pointer to structure for YUV 422 conversion.
+ * @yee: Pointer to structure for Edge Enhancer.
+ * @car: Pointer to structure for Chromatic Artifact Reduction.
+ * @cgs: Pointer to structure for Chromatic Gain Suppression.
+ */
+struct vpfe_prev_config {
+	__u32 flag;
+	struct prev_ipipeif_config __user *ipipeif_config;
+	struct prev_lutdpc __user *lutdpc;
+	struct prev_otfdpc __user *otfdpc;
+	struct prev_nf __user *nf1;
+	struct prev_nf __user *nf2;
+	struct prev_gic __user *gic;
+	struct prev_wb __user *wbal;
+	struct prev_cfa __user *cfa;
+	struct prev_rgb2rgb __user *rgb2rgb1;
+	struct prev_rgb2rgb __user *rgb2rgb2;
+	struct prev_gamma __user *gamma;
+	struct prev_3d_lut __user *lut;
+	struct prev_rgb2yuv __user *rgb2yuv;
+	struct prev_gbce __user *gbce;
+	struct prev_yuv422_conv __user *yuv422_conv;
+	struct prev_yee __user *yee;
+	struct prev_car __user *car;
+	struct prev_cgs __user *cgs;
+};
+
+/*******************************************************************
+**  Resizer API structures
+*******************************************************************/
+/* Interpolation types used for horizontal rescale */
+enum rsz_intp_t {
+	RSZ_INTP_CUBIC,
+	RSZ_INTP_LINEAR
+};
+
+/* Horizontal LPF intensity selection */
+enum rsz_h_lpf_lse_t {
+	RSZ_H_LPF_LSE_INTERN,
+	RSZ_H_LPF_LSE_USER_VAL
+};
+
+enum down_scale_ave_sz {
+	IPIPE_DWN_SCALE_1_OVER_2,
+	IPIPE_DWN_SCALE_1_OVER_4,
+	IPIPE_DWN_SCALE_1_OVER_8,
+	IPIPE_DWN_SCALE_1_OVER_16,
+	IPIPE_DWN_SCALE_1_OVER_32,
+	IPIPE_DWN_SCALE_1_OVER_64,
+	IPIPE_DWN_SCALE_1_OVER_128,
+	IPIPE_DWN_SCALE_1_OVER_256
+};
+
+/* Structure for configuring resizer in single shot mode.
+ * This structure is used when operation mode of the
+ * resizer is single shot. The related IOCTL is
+ * RSZ_S_CONFIG & RSZ_G_CONFIG. When chained, data to
+ * resizer comes from previewer. When not chained, only
+ * UYVY data input is allowed for resizer operation.
+ */
+
+struct rsz_ipipeif_input_spec {
+	/* line length. This will allow application to set a
+	 * different line length than that calculated based on
+	 * width. Set it to zero, if not used,
+	 */
+	unsigned int line_length;
+	/* vertical start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int vst;
+	/* horizontal start position of the image
+	 * data to IPIPE
+	 */
+	unsigned int hst;
+	/* Global frame HD rate */
+	unsigned int ppln;
+	/* Global frame VD rate */
+	unsigned int lpfr;
+	/* clock divide to bring down the pixel clock */
+	struct ipipeif_5_1_clkdiv clk_div;
+	/* Enable decimation 1 - enable, 0 - disable.
+	 * Used when input image width is greater than ipipe
+	 * line buffer size, this is enabled to do resize
+	 * at the input of the IPIPE to clip the size
+	 */
+	enum ipipeif_decimation dec_en;
+	/* used when en_dec = 1. Resize ratio for decimation
+	 * when frame size is  greater than what hw can handle.
+	 * 16 to 112. IPIPE input width is calculated as follows.
+	 * width = image_width * 16/ipipeif_rsz. For example
+	 * if image_width is 1920 and user want to scale it down
+	 * to 1280, use ipipeif_rsz = 24. 1920*16/24 = 1280
+	 */
+	unsigned char rsz;
+	/* When input image width is greater that line buffer
+	 * size, use this to do resize using frame division. The
+	 * frame is divided into two vertical slices and resize
+	 * is performed on each slice
+	 */
+	unsigned char frame_div_mode_en;
+	/* Enable/Disable avg filter at IPIPEIF.
+	 * 1 - enable, 0 - disable
+	 */
+	unsigned char avg_filter_en;
+	/* Align HSync and VSync to rsz_start */
+	unsigned char align_sync;
+	/* ipipeif resize start position */
+	unsigned int rsz_start;
+};
+
+struct rsz_output_spec {
+	/* enable horizontal flip */
+	unsigned char h_flip;
+	/* enable vertical flip */
+	unsigned char v_flip;
+	/* line start offset for y. */
+	unsigned int vst_y;
+	/* line start offset for c. Only for 420 */
+	unsigned int vst_c;
+	/* vertical rescale interpolation type, YCbCr or Luminance */
+	enum rsz_intp_t v_typ_y;
+	/* vertical rescale interpolation type for Chrominance */
+	enum rsz_intp_t v_typ_c;
+	/* vertical lpf intensity - Luminance */
+	unsigned char v_lpf_int_y;
+	/* vertical lpf intensity - Chrominance */
+	unsigned char v_lpf_int_c;
+	/* horizontal rescale interpolation types, YCbCr or Luminance  */
+	enum rsz_intp_t h_typ_y;
+	/* horizontal rescale interpolation types, Chrominance */
+	enum rsz_intp_t h_typ_c;
+	/* horizontal lpf intensity - Luminance */
+	unsigned char h_lpf_int_y;
+	/* horizontal lpf intensity - Chrominance */
+	unsigned char h_lpf_int_c;
+	/* Use down scale mode for scale down */
+	unsigned char en_down_scale;
+	/* if downscale, set the downscale more average size for horizontal
+	 * direction. Used only if output width and height is less than
+	 * input sizes
+	 */
+	enum down_scale_ave_sz h_dscale_ave_sz;
+	/* if downscale, set the downscale more average size for vertical
+	 * direction. Used only if output width and height is less than
+	 * input sizes
+	 */
+	enum down_scale_ave_sz v_dscale_ave_sz;
+	/* Y offset. If set, the offset would be added to the base address
+	 */
+	unsigned int user_y_ofst;
+	/* C offset. If set, the offset would be added to the base address
+	 */
+	unsigned int user_c_ofst;
+};
+
+struct rsz_config {
+	/* input spec of the image data (UYVY). non-chained
+	 * mode. Only valid when not chained. For chained
+	 * operation, previewer settings are used. Mainly
+	 * used for single shot.
+	 */
+	struct rsz_ipipeif_input_spec input;
+	/* output spec of the image data coming out of resizer - 0(UYVY).
+	 */
+	struct rsz_output_spec output1;
+	/* output spec of the image data coming out of resizer - 1(UYVY).
+	 */
+	struct rsz_output_spec output2;
+	/* 0 , chroma sample at odd pixel, 1 - even pixel */
+	unsigned char chroma_sample_even;
+	unsigned char yuv_y_min;
+	unsigned char yuv_y_max;
+	unsigned char yuv_c_min;
+	unsigned char yuv_c_max;
+	enum ipipe_chr_pos out_chr_pos;
+};
+
+/* Structure for VIDIOC_VPFE_RSZ_[S/G]_CONFIG IOCTLs */
+struct vpfe_rsz_config {
+	struct rsz_config *config;
+};
+
+/*
+ * Private IOCTL
+ *
+ * VIDIOC_VPFE_PRV_S_CONFIG: Set preview engine configuration
+ * VIDIOC_VPFE_PRV_G_CONFIG: Get preview engine configuration
+ * VIDIOC_VPFE_RSZ_S_CONFIG: Set resizer engine configuration
+ * VIDIOC_VPFE_RSZ_G_CONFIG: Get resizer engine configuration
+ */
+
+#define VIDIOC_VPFE_PRV_S_CONFIG \
+	_IOWR('P', BASE_VIDIOC_PRIVATE + 1, struct vpfe_prev_config)
+#define VIDIOC_VPFE_PRV_G_CONFIG \
+	_IOWR('P', BASE_VIDIOC_PRIVATE + 2, struct vpfe_prev_config)
+#define VIDIOC_VPFE_RSZ_S_CONFIG \
+	_IOWR('R', BASE_VIDIOC_PRIVATE + 3, struct vpfe_rsz_config)
+#define VIDIOC_VPFE_RSZ_G_CONFIG \
+	_IOWR('R', BASE_VIDIOC_PRIVATE + 4, struct vpfe_rsz_config)
+
+#endif
-- 
1.7.4.1

