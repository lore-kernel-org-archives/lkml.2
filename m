Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2INMsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:48:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52914 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2INMsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:48:33 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 02/14] davinci: vpfe: add IPIPE hardware layer support
Date: Fri, 14 Sep 2012 18:16:32 +0530
Message-Id: <1347626804-5703-3-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1347626804-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add dm365 IPIPE hardware support. IPIPE is the hardware IP which
implements the functionality required for resizer, previewer and
the associated feature support. This is built along with the vpfe
driver, and implements hardware setup including coeffcient
programming for various hardware filters, gamma, cfa and clock
enable.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/dm365_ipipe_hw.c |  936 +++++++++++++++++++++++
 drivers/media/platform/davinci/dm365_ipipe_hw.h |  538 +++++++++++++
 2 files changed, 1474 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe_hw.c
 create mode 100644 drivers/media/platform/davinci/dm365_ipipe_hw.h

diff --git a/drivers/media/platform/davinci/dm365_ipipe_hw.c b/drivers/media/platform/davinci/dm365_ipipe_hw.c
new file mode 100644
index 0000000..4ce6d95
--- /dev/null
+++ b/drivers/media/platform/davinci/dm365_ipipe_hw.c
@@ -0,0 +1,936 @@
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
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/v4l2-mediabus.h>
+
+#include "dm365_ipipe.h"
+#include "dm3xx_ipipeif.h"
+#include "dm365_ipipe_hw.h"
+
+static void ipipe_clock_enable(void)
+{
+	/* enable IPIPE MMR for register write access */
+	regw_ip(IPIPE_GCK_MMR_DEFAULT, IPIPE_GCK_MMR);
+	/* enable the clock wb,cfa,dfc,d2f,pre modules */
+	regw_ip(IPIPE_GCK_PIX_DEFAULT, IPIPE_GCK_PIX);
+	/* enable RSZ MMR for register write access */
+}
+
+/* Set input channel format to either 420 Y or C format */
+void rsz_set_in_pix_format(unsigned char y_c)
+{
+	u32 val;
+
+	val = regr_rsz(RSZ_SRC_FMT1);
+	val |= y_c & 1;
+	regw_rsz(val, RSZ_SRC_FMT1);
+}
+
+static void rsz_set_common_params(struct ipipe_params *params)
+{
+	struct rsz_common_params *rsz_common = &params->rsz_common;
+	u32 val;
+
+	/* Set mode */
+	regw_rsz(params->ipipe_mode, RSZ_SRC_MODE);
+
+	/* data source selection  and bypass */
+	val = (rsz_common->passthrough << RSZ_BYPASS_SHIFT) |
+		rsz_common->source;
+
+	regw_rsz(val, RSZ_SRC_FMT0);
+	val = regr_rsz(RSZ_SRC_MODE);
+	/* src image selection */
+	val = (rsz_common->raw_flip & 1) |
+		(rsz_common->src_img_fmt << RSZ_SRC_IMG_FMT_SHIFT) |
+		((rsz_common->y_c & 1) << RSZ_SRC_Y_C_SEL_SHIFT);
+
+	regw_rsz(val, RSZ_SRC_FMT1);
+	regw_rsz(rsz_common->vps & IPIPE_RSZ_VPS_MASK, RSZ_SRC_VPS);
+	regw_rsz(rsz_common->hps & IPIPE_RSZ_HPS_MASK, RSZ_SRC_HPS);
+	regw_rsz(rsz_common->vsz & IPIPE_RSZ_VSZ_MASK, RSZ_SRC_VSZ);
+	regw_rsz(rsz_common->hsz & IPIPE_RSZ_HSZ_MASK, RSZ_SRC_HSZ);
+	regw_rsz(rsz_common->yuv_y_min, RSZ_YUV_Y_MIN);
+	regw_rsz(rsz_common->yuv_y_max, RSZ_YUV_Y_MAX);
+	regw_rsz(rsz_common->yuv_c_min, RSZ_YUV_C_MIN);
+	regw_rsz(rsz_common->yuv_c_max, RSZ_YUV_C_MAX);
+	/* chromatic position */
+	regw_rsz(rsz_common->out_chr_pos, RSZ_YUV_PHS);
+	val = regr_rsz(RSZ_SRC_MODE);
+}
+
+static void rsz_set_rsz_regs(unsigned int rsz_id, struct ipipe_params *params)
+{
+	struct ipipe_rsz_rescale_param *rsc_params;
+	struct ipipe_ext_mem_param *ext_mem;
+	struct ipipe_rsz_resize2rgb *rgb;
+	u32 reg_base;
+	u32 val;
+
+	val = regr_rsz(RSZ_SEQ);
+	rsc_params = &params->rsz_rsc_param[rsz_id];
+	rgb = &params->rsz2rgb[rsz_id];
+	ext_mem = &params->ext_mem_param[rsz_id];
+
+	if (rsz_id == RSZ_A) {
+		val = rsc_params->h_flip << RSZA_H_FLIP_SHIFT;
+		val |= rsc_params->v_flip << RSZA_V_FLIP_SHIFT;
+		reg_base = RSZ_EN_A;
+	} else {
+		val = rsc_params->h_flip << RSZB_H_FLIP_SHIFT;
+		val |= rsc_params->v_flip << RSZB_V_FLIP_SHIFT;
+		reg_base = RSZ_EN_B;
+	}
+	/* update flip settings */
+	regw_rsz(val, RSZ_SEQ);
+
+	regw_rsz(rsc_params->mode, reg_base + RSZ_MODE);
+	val = (rsc_params->cen << RSZ_CEN_SHIFT) | rsc_params->yen;
+	regw_rsz(val, reg_base + RSZ_420);
+	regw_rsz(rsc_params->i_vps & RSZ_VPS_MASK, reg_base + RSZ_I_VPS);
+	regw_rsz(rsc_params->i_hps & RSZ_HPS_MASK, reg_base + RSZ_I_HPS);
+	regw_rsz(rsc_params->o_vsz & RSZ_O_VSZ_MASK, reg_base + RSZ_O_VSZ);
+	regw_rsz(rsc_params->o_hsz & RSZ_O_HSZ_MASK, reg_base + RSZ_O_HSZ);
+	regw_rsz(rsc_params->v_phs_y & RSZ_V_PHS_MASK, reg_base + RSZ_V_PHS_Y);
+	regw_rsz(rsc_params->v_phs_c & RSZ_V_PHS_MASK, reg_base + RSZ_V_PHS_C);
+	/* keep this additional adjustment to zero for now */
+	regw_rsz(rsc_params->v_dif & RSZ_V_DIF_MASK, reg_base + RSZ_V_DIF);
+
+	val = (rsc_params->v_typ_y & 1) | ((rsc_params->v_typ_c & 1) <<
+							RSZ_TYP_C_SHIFT);
+	regw_rsz(val, reg_base + RSZ_V_TYP);
+
+	val = (rsc_params->v_lpf_int_y & RSZ_LPF_INT_MASK) |
+			((rsc_params->v_lpf_int_c & RSZ_LPF_INT_MASK) <<
+				RSZ_LPF_INT_C_SHIFT);
+	regw_rsz(val, reg_base + RSZ_V_LPF);
+
+	regw_rsz(rsc_params->h_phs & RSZ_H_PHS_MASK, reg_base + RSZ_H_PHS);
+	regw_rsz(0, reg_base + RSZ_H_PHS_ADJ);
+	regw_rsz(rsc_params->h_dif & RSZ_H_DIF_MASK, reg_base + RSZ_H_DIF);
+	val = (rsc_params->h_typ_y & 1) | ((rsc_params->h_typ_c & 1) <<
+							RSZ_TYP_C_SHIFT);
+	regw_rsz(val, reg_base + RSZ_H_TYP);
+	val = (rsc_params->h_lpf_int_y & RSZ_LPF_INT_MASK) |
+		 ((rsc_params->h_lpf_int_c & RSZ_LPF_INT_MASK) <<
+		 RSZ_LPF_INT_C_SHIFT);
+	regw_rsz(val, reg_base + RSZ_H_LPF);
+
+	regw_rsz(rsc_params->dscale_en & 1, reg_base + RSZ_DWN_EN);
+	val = rsc_params->h_dscale_ave_sz & RSZ_DWN_SCALE_AV_SZ_MASK;
+	val |= (rsc_params->v_dscale_ave_sz & RSZ_DWN_SCALE_AV_SZ_MASK) <<
+				  RSZ_DWN_SCALE_AV_SZ_V_SHIFT;
+	regw_rsz(val, reg_base + RSZ_DWN_AV);
+
+	/* setting rgb conversion parameters */
+	regw_rsz(rgb->rgb_en, reg_base + RSZ_RGB_EN);
+	val = (rgb->rgb_typ << RSZ_RGB_TYP_SHIFT) |
+		 (rgb->rgb_msk0 << RSZ_RGB_MSK0_SHIFT) |
+		 (rgb->rgb_msk1 << RSZ_RGB_MSK1_SHIFT);
+	regw_rsz(val, reg_base + RSZ_RGB_TYP);
+	regw_rsz(rgb->rgb_alpha_val & RSZ_RGB_ALPHA_MASK,
+		reg_base + RSZ_RGB_BLD);
+
+	/* setting external memory parameters */
+	regw_rsz(ext_mem->rsz_sdr_oft_y, reg_base + RSZ_SDR_Y_OFT);
+	regw_rsz(ext_mem->rsz_sdr_ptr_s_y, reg_base + RSZ_SDR_Y_PTR_S);
+	regw_rsz(ext_mem->rsz_sdr_ptr_e_y, reg_base + RSZ_SDR_Y_PTR_E);
+	regw_rsz(ext_mem->rsz_sdr_oft_c, reg_base + RSZ_SDR_C_OFT);
+	regw_rsz(ext_mem->rsz_sdr_ptr_s_c, reg_base + RSZ_SDR_C_PTR_S);
+	regw_rsz((ext_mem->rsz_sdr_ptr_e_c >> 1), reg_base + RSZ_SDR_C_PTR_E);
+}
+
+/*set the registers of either RSZ0 or RSZ1 */
+static void ipipe_setup_resizer(struct ipipe_params *params)
+{
+	/* enable MMR gate to write to Resizer */
+	regw_rsz(1, RSZ_GCK_MMR);
+
+	/* Enable resizer if it is not in bypass mode */
+	if (params->rsz_common.passthrough)
+		regw_rsz(0, RSZ_GCK_SDR);
+	else
+		regw_rsz(1, RSZ_GCK_SDR);
+
+	rsz_set_common_params(params);
+
+	regw_rsz(params->rsz_en[RSZ_A], RSZ_EN_A);
+	if (params->rsz_en[RSZ_A])
+		/*setting rescale parameters */
+		rsz_set_rsz_regs(RSZ_A, params);
+
+	regw_rsz(params->rsz_en[RSZ_B], RSZ_EN_B);
+	if (params->rsz_en[RSZ_B])
+		rsz_set_rsz_regs(RSZ_B, params);
+
+	regr_rsz(RSZ_SRC_MODE);
+}
+
+/*
+ * ipipe_hw_setup() - Performs hardware setup of ipipe.
+ */
+int ipipe_hw_setup(struct ipipe_params *config)
+{
+	u32 data_format;
+	u32 val;
+
+	if (!config) {
+		pr_err("ipipe_hw_setup- Invalid config\n");
+		return -EINVAL;
+	}
+
+	if (ipipeif_hw_setup(&config->ipipeif_param, DM365) < 0) {
+		pr_err("ipipe_hw_setup- Failed to configure IPIPEIF");
+		return -EINVAL;
+	}
+
+	/* enable clock to IPIPE */
+	vpss_enable_clock(VPSS_IPIPE_CLOCK, 1);
+	/* enable clock to MMR and modules before writting
+	 * to ipipe registers
+	 */
+	ipipe_clock_enable();
+
+	if (config->rsz_common.source == IPIPEIF_DATA) {
+		/* we need to skip configuring IPIPE */
+		regw_ip(0, IPIPE_SRC_EN);
+	} else {
+		/* enable ipipe mode to either one shot or continuous */
+		val = config->ipipe_mode;
+		regw_ip(val, IPIPE_SRC_MODE);
+		data_format = config->ipipe_dpaths_fmt;
+		regw_ip(data_format, IPIPE_SRC_FMT);
+		/* set size */
+		regw_ip(config->ipipe_vps & IPIPE_RSZ_VPS_MASK, IPIPE_SRC_VPS);
+		regw_ip(config->ipipe_hps & IPIPE_RSZ_HPS_MASK, IPIPE_SRC_HPS);
+		regw_ip(config->ipipe_vsz & IPIPE_RSZ_VSZ_MASK, IPIPE_SRC_VSZ);
+		regw_ip(config->ipipe_hsz & IPIPE_RSZ_HSZ_MASK, IPIPE_SRC_HSZ);
+
+		if (data_format == IPIPE_RAW2YUV ||
+					data_format == IPIPE_RAW2RAW)
+			regw_ip(config->ipipe_colpat, IPIPE_SRC_COL);
+	}
+
+	ipipe_setup_resizer(config);
+
+	return 0;
+}
+
+static void rsz_set_y_address(unsigned int address, unsigned int offset)
+{
+	u32 val;
+
+	val = address & SET_LOW_ADD;
+	regw_rsz(val, offset + RSZ_SDR_Y_BAD_L);
+	regw_rsz(val, offset + RSZ_SDR_Y_SAD_L);
+	val = (address & SET_HIGH_ADD) >> 16;
+	regw_rsz(val, offset + RSZ_SDR_Y_BAD_H);
+	regw_rsz(val, offset + RSZ_SDR_Y_SAD_H);
+}
+
+static void rsz_set_c_address(unsigned int address, unsigned int offset)
+{
+	u32 val;
+
+	val = address & SET_LOW_ADD;
+
+	regw_rsz(val, offset + RSZ_SDR_C_BAD_L);
+	regw_rsz(val, offset + RSZ_SDR_C_SAD_L);
+	val = (address & SET_HIGH_ADD) >> 16;
+	regw_rsz(val, offset + RSZ_SDR_C_BAD_H);
+	regw_rsz(val, offset + RSZ_SDR_C_SAD_H);
+}
+
+/* Assume we get a valid params ptr and resize_no set to RSZ_A
+ * or RSZ_B. This could be called in the interrupt context and
+ * must be efficient
+ */
+void rsz_set_output_address(struct ipipe_params *params,
+			   int resize_no, unsigned int address)
+{
+	unsigned int rsz_start_add;
+	unsigned int val;
+
+	struct ipipe_ext_mem_param *mem_param =
+		&params->ext_mem_param[resize_no];
+	struct rsz_common_params *rsz_common =
+		&params->rsz_common;
+	struct ipipe_rsz_rescale_param *rsc_param =
+		&params->rsz_rsc_param[resize_no];
+
+	if (resize_no == RSZ_A)
+		rsz_start_add = RSZ_EN_A;
+	else
+		rsz_start_add = RSZ_EN_B;
+	/* y_c = 0 for y, = 1 for c */
+	if (rsz_common->src_img_fmt == RSZ_IMG_420) {
+		if (rsz_common->y_c) {
+			/* C channel */
+			val = address + mem_param->flip_ofst_c;
+			rsz_set_c_address(val, rsz_start_add);
+		} else {
+			val = address + mem_param->flip_ofst_y;
+			rsz_set_y_address(val, rsz_start_add);
+		}
+	} else {
+		if (rsc_param->cen && rsc_param->yen) {
+			/* 420 */
+			val = address + mem_param->c_offset;
+			val = address + mem_param->c_offset +
+				mem_param->flip_ofst_c;
+			val += mem_param->user_y_ofst +
+				mem_param->user_c_ofst;
+			if (resize_no == RSZ_B)
+				val +=
+				params->ext_mem_param[RSZ_A].user_y_ofst +
+				params->ext_mem_param[RSZ_A].user_c_ofst;
+			/* set C address */
+			rsz_set_c_address(val, rsz_start_add);
+		}
+		val = address + mem_param->flip_ofst_y;
+		val += mem_param->user_y_ofst;
+		if (resize_no == RSZ_B)
+			val += params->ext_mem_param[RSZ_A].user_y_ofst +
+				params->ext_mem_param[RSZ_A].user_c_ofst;
+		/* set Y address */
+		rsz_set_y_address(val, rsz_start_add);
+	}
+	/* resizer must be enabled */
+	regw_rsz(params->rsz_en[resize_no], rsz_start_add);
+
+}
+
+void ipipe_set_lutdpc_regs(struct prev_lutdpc *dpc)
+{
+	u32 max_tbl_size = LUT_DPC_MAX_SIZE >> 1;
+	u32 lut_start_addr = DPC_TB0_START_ADDR;
+	u32 val;
+	u32 count;
+
+	ipipe_clock_enable();
+	regw_ip(dpc->en, DPC_LUT_EN);
+	if (dpc->en != 1)
+		return;
+
+	/* if dpc is enabled */
+	val = LUTDPC_TBL_256_EN;
+	val |= dpc->repl_white & 1;
+	regw_ip(val, DPC_LUT_SEL);
+	regw_ip(LUT_DPC_START_ADDR, DPC_LUT_ADR);
+	regw_ip(dpc->dpc_size, DPC_LUT_SIZ & LUT_DPC_SIZE_MASK);
+
+	if (dpc->table == NULL)
+		return;
+
+	for (count = 0; count < dpc->dpc_size; count++) {
+		if (count >= max_tbl_size)
+			lut_start_addr = DPC_TB1_START_ADDR;
+		val = dpc->table[count].horz_pos & LUT_DPC_H_POS_MASK;
+		val |= (dpc->table[count].vert_pos & LUT_DPC_V_POS_MASK) <<
+			LUT_DPC_V_POS_SHIFT;
+		val |= dpc->table[count].method << LUT_DPC_CORR_METH_SHIFT;
+		w_ip_table(val, (lut_start_addr +
+						((count % max_tbl_size) << 2)));
+	}
+}
+
+static void set_dpc_thresholds(struct prev_otfdpc_2_0 *dpc_thr)
+{
+	regw_ip((dpc_thr->corr_thr.r & OTFDPC_DPC2_THR_MASK),
+		DPC_OTF_2C_THR_R);
+	regw_ip((dpc_thr->corr_thr.gr & OTFDPC_DPC2_THR_MASK),
+		DPC_OTF_2C_THR_GR);
+	regw_ip((dpc_thr->corr_thr.gb & OTFDPC_DPC2_THR_MASK),
+		DPC_OTF_2C_THR_GB);
+	regw_ip((dpc_thr->corr_thr.b & OTFDPC_DPC2_THR_MASK),
+		DPC_OTF_2C_THR_B);
+	regw_ip((dpc_thr->det_thr.r & OTFDPC_DPC2_THR_MASK),
+		DPC_OTF_2D_THR_R);
+	regw_ip((dpc_thr->det_thr.gr & OTFDPC_DPC2_THR_MASK),
+		DPC_OTF_2D_THR_GR);
+	regw_ip((dpc_thr->det_thr.gb & OTFDPC_DPC2_THR_MASK),
+		DPC_OTF_2D_THR_GB);
+	regw_ip((dpc_thr->det_thr.b & OTFDPC_DPC2_THR_MASK),
+		DPC_OTF_2D_THR_B);
+}
+
+void ipipe_set_otfdpc_regs(struct prev_otfdpc *otfdpc)
+{
+	struct prev_otfdpc_2_0 *dpc_2_0 = &otfdpc->alg_cfg.dpc_2_0;
+	struct prev_otfdpc_3_0 *dpc_3_0 = &otfdpc->alg_cfg.dpc_3_0;
+	u32 val;
+
+	ipipe_clock_enable();
+
+	regw_ip((otfdpc->en & 1), DPC_OTF_EN);
+	if (otfdpc->en != 1)
+		return;
+
+	/* dpc enabled */
+	val = otfdpc->det_method << OTF_DET_METHOD_SHIFT;
+	val |= otfdpc->alg;
+	regw_ip(val, DPC_OTF_TYP);
+	if (otfdpc->det_method == IPIPE_DPC_OTF_MIN_MAX) {
+		/* ALG= 0, TYP = 0, DPC_OTF_2D_THR_[x]=0
+		 * DPC_OTF_2C_THR_[x] = Maximum thresohld
+		 * MinMax method
+		 */
+		dpc_2_0->det_thr.r = dpc_2_0->det_thr.gb =
+		dpc_2_0->det_thr.gr = dpc_2_0->det_thr.b = 0;
+		set_dpc_thresholds(dpc_2_0);
+		return;
+	}
+	/* MinMax2 */
+	if (otfdpc->alg == IPIPE_OTFDPC_2_0) {
+		set_dpc_thresholds(dpc_2_0);
+		return;
+	}
+	regw_ip((dpc_3_0->act_adj_shf & OTF_DPC3_0_SHF_MASK), DPC_OTF_3_SHF);
+	/* Detection thresholds */
+	regw_ip(((dpc_3_0->det_thr & OTF_DPC3_0_THR_MASK) <<
+		OTF_DPC3_0_THR_SHIFT), DPC_OTF_3D_THR);
+	regw_ip((dpc_3_0->det_slp & OTF_DPC3_0_SLP_MASK), DPC_OTF_3D_SLP);
+	regw_ip((dpc_3_0->det_thr_min & OTF_DPC3_0_DET_MASK), DPC_OTF_3D_MIN);
+	regw_ip((dpc_3_0->det_thr_max & OTF_DPC3_0_DET_MASK), DPC_OTF_3D_MAX);
+	/* Correction thresholds */
+	regw_ip(((dpc_3_0->corr_thr & OTF_DPC3_0_THR_MASK) <<
+		OTF_DPC3_0_THR_SHIFT), DPC_OTF_3C_THR);
+	regw_ip((dpc_3_0->corr_slp & OTF_DPC3_0_SLP_MASK), DPC_OTF_3C_SLP);
+	regw_ip((dpc_3_0->corr_thr_min & OTF_DPC3_0_CORR_MASK), DPC_OTF_3C_MIN);
+	regw_ip((dpc_3_0->corr_thr_max & OTF_DPC3_0_CORR_MASK), DPC_OTF_3C_MAX);
+}
+
+/* 2D Noise filter */
+void ipipe_set_d2f_regs(unsigned int id, struct prev_nf *noise_filter)
+{
+
+	u32 offset = D2F_1ST;
+	int count;
+	u32 val;
+
+	/* id = 0 , NF1 & id = 1, NF 2 */
+	if (id)
+		offset = D2F_2ND;
+	ipipe_clock_enable();
+	regw_ip(noise_filter->en & 1, offset + D2F_EN);
+	if (noise_filter->en != 1)
+		return;
+
+	/*noise filter enabled */
+	/* Combine all the fields to make D2F_CFG register of IPIPE */
+	val = ((noise_filter->spread_val & D2F_SPR_VAL_MASK) <<
+		 D2F_SPR_VAL_SHIFT) |
+		 ((noise_filter->shft_val & D2F_SHFT_VAL_MASK) <<
+		 D2F_SHFT_VAL_SHIFT) |
+		 (noise_filter->gr_sample_meth <<
+		 D2F_SAMPLE_METH_SHIFT) |
+		 ((noise_filter->apply_lsc_gain & 1) <<
+		 D2F_APPLY_LSC_GAIN_SHIFT) | D2F_USE_SPR_REG_VAL;
+
+	regw_ip(val, offset + D2F_TYP);
+	/* edge detection minimum */
+	regw_ip(noise_filter->edge_det_min_thr & D2F_EDGE_DET_THR_MASK,
+		offset + D2F_EDG_MIN);
+	/* edge detection maximum */
+	regw_ip(noise_filter->edge_det_max_thr & D2F_EDGE_DET_THR_MASK,
+		offset + D2F_EDG_MAX);
+	for (count = 0; count < IPIPE_NF_STR_TABLE_SIZE; count++) {
+		regw_ip((noise_filter->str[count] & D2F_STR_VAL_MASK),
+			offset + D2F_STR + count * 4);
+
+	}
+	for (count = 0; count < IPIPE_NF_THR_TABLE_SIZE; count++) {
+		regw_ip(noise_filter->thr[count] & D2F_THR_VAL_MASK,
+			offset + D2F_THR + count * 4);
+	}
+}
+
+#define IPIPE_U8Q5(decimal, integer) \
+	(((decimal & 0x1f) | ((integer & 0x7) << 5)))
+
+/* Green Imbalance Correction */
+void ipipe_set_gic_regs(struct prev_gic *gic)
+{
+	u32 val;
+
+	ipipe_clock_enable();
+	regw_ip(gic->en & 1, GIC_EN);
+
+	if (!gic->en)
+		return;
+
+	/*gic enabled */
+	val = gic->wt_fn_type << GIC_TYP_SHIFT;
+	val |= gic->thr_sel << GIC_THR_SEL_SHIFT;
+	val |= (gic->apply_lsc_gain & 1) << GIC_APPLY_LSC_GAIN_SHIFT;
+	regw_ip(val, GIC_TYP);
+	regw_ip(gic->gain & GIC_GAIN_MASK, GIC_GAN);
+
+	if (gic->gic_alg != IPIPE_GIC_ALG_ADAPT_GAIN) {
+		/* Constant Gain. Set threshold to maximum */
+		regw_ip(GIC_THR_MASK, GIC_THR);
+		return;
+	}
+
+	if (gic->thr_sel == IPIPE_GIC_THR_REG) {
+		regw_ip(gic->thr & GIC_THR_MASK, GIC_THR);
+		regw_ip(gic->slope & GIC_SLOPE_MASK, GIC_SLP);
+	} else {
+		/* Use NF thresholds */
+		val = IPIPE_U8Q5(gic->nf2_thr_gain.decimal,
+				gic->nf2_thr_gain.integer);
+		regw_ip(val, GIC_NFGAN);
+	}
+}
+
+#define IPIPE_U13Q9(decimal, integer) \
+	(((decimal & 0x1ff) | ((integer & 0xf) << 9)))
+/* White balance */
+void ipipe_set_wb_regs(struct prev_wb *wb)
+{
+	u32 val;
+
+	ipipe_clock_enable();
+	/* Ofsets. S12 */
+	regw_ip(wb->ofst_r & WB_OFFSET_MASK, WB2_OFT_R);
+	regw_ip(wb->ofst_gr & WB_OFFSET_MASK, WB2_OFT_GR);
+	regw_ip(wb->ofst_gb & WB_OFFSET_MASK, WB2_OFT_GB);
+	regw_ip(wb->ofst_b & WB_OFFSET_MASK, WB2_OFT_B);
+
+	/* Gains. U13Q9 */
+	val = IPIPE_U13Q9(wb->gain_r.decimal, wb->gain_r.integer);
+	regw_ip(val, WB2_WGN_R);
+	val = IPIPE_U13Q9(wb->gain_gr.decimal, wb->gain_gr.integer);
+	regw_ip(val, WB2_WGN_GR);
+	val = IPIPE_U13Q9(wb->gain_gb.decimal, wb->gain_gb.integer);
+	regw_ip(val, WB2_WGN_GB);
+	val = IPIPE_U13Q9(wb->gain_b.decimal, wb->gain_b.integer);
+	regw_ip(val, WB2_WGN_B);
+}
+
+/* CFA */
+void ipipe_set_cfa_regs(struct prev_cfa *cfa)
+{
+	ipipe_clock_enable();
+	regw_ip(cfa->alg, CFA_MODE);
+	regw_ip(cfa->hpf_thr_2dir & CFA_HPF_THR_2DIR_MASK, CFA_2DIR_HPF_THR);
+	regw_ip(cfa->hpf_slp_2dir & CFA_HPF_SLOPE_2DIR_MASK, CFA_2DIR_HPF_SLP);
+	regw_ip(cfa->hp_mix_thr_2dir & CFA_HPF_MIX_THR_2DIR_MASK,
+			CFA_2DIR_MIX_THR);
+	regw_ip(cfa->hp_mix_slope_2dir & CFA_HPF_MIX_SLP_2DIR_MASK,
+			CFA_2DIR_MIX_SLP);
+	regw_ip(cfa->dir_thr_2dir & CFA_DIR_THR_2DIR_MASK, CFA_2DIR_DIR_THR);
+	regw_ip(cfa->dir_slope_2dir & CFA_DIR_SLP_2DIR_MASK, CFA_2DIR_DIR_SLP);
+	regw_ip(cfa->nd_wt_2dir & CFA_ND_WT_2DIR_MASK, CFA_2DIR_NDWT);
+	regw_ip(cfa->hue_fract_daa & CFA_DAA_HUE_FRA_MASK, CFA_MONO_HUE_FRA);
+	regw_ip(cfa->edge_thr_daa & CFA_DAA_EDG_THR_MASK, CFA_MONO_EDG_THR);
+	regw_ip(cfa->thr_min_daa & CFA_DAA_THR_MIN_MASK, CFA_MONO_THR_MIN);
+	regw_ip(cfa->thr_slope_daa & CFA_DAA_THR_SLP_MASK, CFA_MONO_THR_SLP);
+	regw_ip(cfa->slope_min_daa & CFA_DAA_SLP_MIN_MASK, CFA_MONO_SLP_MIN);
+	regw_ip(cfa->slope_slope_daa & CFA_DAA_SLP_SLP_MASK, CFA_MONO_SLP_SLP);
+	regw_ip(cfa->lp_wt_daa & CFA_DAA_LP_WT_MASK, CFA_MONO_LPWT);
+}
+
+void ipipe_set_rgb2rgb_regs(unsigned int id, struct prev_rgb2rgb *rgb)
+{
+	u32 offset_mask = RGB2RGB_1_OFST_MASK;
+	u32 offset = RGB1_MUL_BASE;
+	u32 integ_mask = 0xf;
+	u32 val;
+
+	ipipe_clock_enable();
+
+	if (id) {
+		/* For second RGB module, gain integer is 3 bits instead
+		of 4, offset has 11 bits insread of 13 */
+		offset = RGB2_MUL_BASE;
+		integ_mask = 0x7;
+		offset_mask = RGB2RGB_2_OFST_MASK;
+	}
+	/* Gains */
+	val = (rgb->coef_rr.decimal & 0xff) |
+		((rgb->coef_rr.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_RR);
+	val = (rgb->coef_gr.decimal & 0xff) |
+		((rgb->coef_gr.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_GR);
+	val = (rgb->coef_br.decimal & 0xff) |
+		((rgb->coef_br.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_BR);
+	val = (rgb->coef_rg.decimal & 0xff) |
+		((rgb->coef_rg.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_RG);
+	val = (rgb->coef_gg.decimal & 0xff) |
+		((rgb->coef_gg.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_GG);
+	val = (rgb->coef_bg.decimal & 0xff) |
+		((rgb->coef_bg.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_BG);
+	val = (rgb->coef_rb.decimal & 0xff) |
+		((rgb->coef_rb.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_RB);
+	val = (rgb->coef_gb.decimal & 0xff) |
+		((rgb->coef_gb.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_GB);
+	val = (rgb->coef_bb.decimal & 0xff) |
+		((rgb->coef_bb.integer & integ_mask) << 8);
+	regw_ip(val, offset + RGB_MUL_BB);
+
+	/* Offsets */
+	regw_ip(rgb->out_ofst_r & offset_mask, offset + RGB_OFT_OR);
+	regw_ip(rgb->out_ofst_g & offset_mask, offset + RGB_OFT_OG);
+	regw_ip(rgb->out_ofst_b & offset_mask, offset + RGB_OFT_OB);
+}
+
+static void ipipe_update_gamma_tbl(struct ipipe_gamma_entry *table,
+				   int size, u32 addr)
+{
+	int count;
+	u32 val;
+
+	for (count = 0; count < size; count++) {
+		val = table[count].slope & GAMMA_MASK;
+		val |= (table[count].offset & GAMMA_MASK) << GAMMA_SHIFT;
+		w_ip_table(val, (addr + (count * 4)));
+	}
+}
+
+/* Gamma correction */
+void ipipe_set_gamma_regs(struct prev_gamma *gamma)
+{
+	int table_size;
+	u32 val;
+
+	ipipe_clock_enable();
+	val = (gamma->bypass_r << GAMMA_BYPR_SHIFT) |
+		(gamma->bypass_b << GAMMA_BYPG_SHIFT) |
+		(gamma->bypass_g << GAMMA_BYPB_SHIFT) |
+		(gamma->tbl_sel << GAMMA_TBL_SEL_SHIFT) |
+		(gamma->tbl_size << GAMMA_TBL_SIZE_SHIFT);
+
+	regw_ip(val, GMM_CFG);
+
+	if (gamma->tbl_sel != IPIPE_GAMMA_TBL_RAM)
+		return;
+
+	table_size = gamma->tbl_size;
+
+	if (!gamma->bypass_r && gamma->table_r != NULL) {
+		ipipe_update_gamma_tbl(gamma->table_r, table_size,
+					GAMMA_R_START_ADDR);
+	}
+	if (!gamma->bypass_b && gamma->table_b != NULL) {
+		ipipe_update_gamma_tbl(gamma->table_b, table_size,
+					GAMMA_B_START_ADDR);
+	}
+	if (!gamma->bypass_g && gamma->table_g != NULL) {
+		ipipe_update_gamma_tbl(gamma->table_g, table_size,
+					GAMMA_G_START_ADDR);
+	}
+}
+
+/* 3D LUT */
+void ipipe_set_3d_lut_regs(struct prev_3d_lut *lut_3d)
+{
+	struct ipipe_3d_lut_entry *tbl;
+	u32 bnk_index;
+	u32 tbl_index;
+	u32 val;
+	u32 i;
+
+	ipipe_clock_enable();
+	regw_ip(lut_3d->en, D3LUT_EN);
+
+	if (!lut_3d->en)
+		return;
+
+	/* lut_3d enabled */
+	if (!lut_3d->table)
+		return;
+
+	/* valied table */
+	tbl = lut_3d->table;
+	for (i = 0 ; i < MAX_SIZE_3D_LUT; i++) {
+		/* Each entry has 0-9 (B), 10-19 (G) and
+		20-29 R values */
+		val = tbl[i].b & D3_LUT_ENTRY_MASK;
+		val |= (tbl[i].g & D3_LUT_ENTRY_MASK) <<
+			 D3_LUT_ENTRY_G_SHIFT;
+		val |= (tbl[i].r & D3_LUT_ENTRY_MASK) <<
+			 D3_LUT_ENTRY_R_SHIFT;
+		bnk_index = i % 4;
+		tbl_index = i >> 2;
+		tbl_index <<= 2;
+		if (bnk_index == 0)
+			w_ip_table(val, tbl_index + D3L_TB0_START_ADDR);
+		else if (bnk_index == 1)
+			w_ip_table(val, tbl_index + D3L_TB1_START_ADDR);
+		else if (bnk_index == 2)
+			w_ip_table(val, tbl_index + D3L_TB2_START_ADDR);
+		else
+			w_ip_table(val, tbl_index + D3L_TB3_START_ADDR);
+	}
+}
+
+/* Lumina adjustments */
+void ipipe_set_lum_adj_regs(struct prev_lum_adj *lum_adj)
+{
+	u32 val;
+
+	ipipe_clock_enable();
+	/* combine fields of YUV_ADJ to set brightness and contrast */
+	val = lum_adj->contrast << LUM_ADJ_CONTR_SHIFT |
+			lum_adj->brightness << LUM_ADJ_BRIGHT_SHIFT;
+	regw_ip(val, YUV_ADJ);
+}
+
+#define IPIPE_S12Q8(decimal, integer) \
+	(((decimal & 0xff) | ((integer & 0xf) << 8)))
+/* RGB2YUV */
+void ipipe_set_rgb2ycbcr_regs(struct prev_rgb2yuv *yuv)
+{
+	u32 val;
+
+	/* S10Q8 */
+	ipipe_clock_enable();
+	val = IPIPE_S12Q8(yuv->coef_ry.decimal, yuv->coef_ry.integer);
+	regw_ip(val, YUV_MUL_RY);
+	val = IPIPE_S12Q8(yuv->coef_gy.decimal, yuv->coef_gy.integer);
+	regw_ip(val, YUV_MUL_GY);
+	val = IPIPE_S12Q8(yuv->coef_by.decimal, yuv->coef_by.integer);
+	regw_ip(val, YUV_MUL_BY);
+	val = IPIPE_S12Q8(yuv->coef_rcb.decimal, yuv->coef_rcb.integer);
+	regw_ip(val, YUV_MUL_RCB);
+	val = IPIPE_S12Q8(yuv->coef_gcb.decimal, yuv->coef_gcb.integer);
+	regw_ip(val, YUV_MUL_GCB);
+	val = IPIPE_S12Q8(yuv->coef_bcb.decimal, yuv->coef_bcb.integer);
+	regw_ip(val, YUV_MUL_BCB);
+	val = IPIPE_S12Q8(yuv->coef_rcr.decimal, yuv->coef_rcr.integer);
+	regw_ip(val, YUV_MUL_RCR);
+	val = IPIPE_S12Q8(yuv->coef_gcr.decimal, yuv->coef_gcr.integer);
+	regw_ip(val, YUV_MUL_GCR);
+	val = IPIPE_S12Q8(yuv->coef_bcr.decimal, yuv->coef_bcr.integer);
+	regw_ip(val, YUV_MUL_BCR);
+	regw_ip(yuv->out_ofst_y & RGB2YCBCR_OFST_MASK, YUV_OFT_Y);
+	regw_ip(yuv->out_ofst_cb & RGB2YCBCR_OFST_MASK, YUV_OFT_CB);
+	regw_ip(yuv->out_ofst_cr & RGB2YCBCR_OFST_MASK, YUV_OFT_CR);
+}
+
+/* YUV 422 conversion */
+void ipipe_set_yuv422_conv_regs(struct prev_yuv422_conv *conv)
+{
+	u32 val;
+
+	ipipe_clock_enable();
+	/* Combine all the fields to make YUV_PHS register of IPIPE */
+	val = (conv->chrom_pos << 0) | (conv->en_chrom_lpf << 1);
+	regw_ip(val, YUV_PHS);
+}
+
+/* GBCE */
+void ipipe_set_gbce_regs(struct prev_gbce *gbce)
+{
+	unsigned int tbl_index;
+	unsigned int count;
+	u32 mask = GBCE_Y_VAL_MASK;
+	u32 val;
+
+	if (gbce->type == IPIPE_GBCE_GAIN_TBL)
+		mask = GBCE_GAIN_VAL_MASK;
+
+	ipipe_clock_enable();
+	regw_ip(gbce->en & 1, GBCE_EN);
+
+	if (!gbce->en)
+		return;
+
+	regw_ip(gbce->type, GBCE_TYP);
+
+	if (!gbce->table)
+		return;
+
+	/* set to 0 */
+	val = 0;
+
+	for (count = 0; count < MAX_SIZE_GBCE_LUT; count++) {
+		tbl_index = count >> 1;
+		tbl_index <<= 2;
+		/* Each table has 2 LUT entries, first in LS
+		  * and second in MS positions
+		  */
+		if (count % 2) {
+			val |=
+				(gbce->table[count] & mask) <<
+				GBCE_ENTRY_SHIFT;
+			w_ip_table(val, tbl_index + GBCE_TB_START_ADDR);
+		} else {
+			val = gbce->table[count] & mask;
+		}
+	}
+}
+
+/* Edge Enhancement */
+void ipipe_set_ee_regs(struct prev_yee *ee)
+{
+	unsigned int tbl_index;
+	unsigned int count;
+	u32 val;
+
+	ipipe_clock_enable();
+	regw_ip(ee->en, YEE_EN);
+
+	if (!ee->en)
+		return;
+
+	val = ee->en_halo_red & 1;
+	val |= ee->merge_meth << YEE_HALO_RED_EN_SHIFT;
+	regw_ip(val, YEE_TYP);
+	regw_ip(ee->hpf_shft, YEE_SHF);
+	regw_ip(ee->hpf_coef_00 & YEE_COEF_MASK, YEE_MUL_00);
+	regw_ip(ee->hpf_coef_01 & YEE_COEF_MASK, YEE_MUL_01);
+	regw_ip(ee->hpf_coef_02 & YEE_COEF_MASK, YEE_MUL_02);
+	regw_ip(ee->hpf_coef_10 & YEE_COEF_MASK, YEE_MUL_10);
+	regw_ip(ee->hpf_coef_11 & YEE_COEF_MASK, YEE_MUL_11);
+	regw_ip(ee->hpf_coef_12 & YEE_COEF_MASK, YEE_MUL_12);
+	regw_ip(ee->hpf_coef_20 & YEE_COEF_MASK, YEE_MUL_20);
+	regw_ip(ee->hpf_coef_21 & YEE_COEF_MASK, YEE_MUL_21);
+	regw_ip(ee->hpf_coef_22 & YEE_COEF_MASK, YEE_MUL_22);
+	regw_ip(ee->yee_thr & YEE_THR_MASK, YEE_THR);
+	regw_ip(ee->es_gain & YEE_ES_GAIN_MASK, YEE_E_GAN);
+	regw_ip(ee->es_thr1 & YEE_ES_THR1_MASK, YEE_E_THR1);
+	regw_ip(ee->es_thr2 & YEE_THR_MASK, YEE_E_THR2);
+	regw_ip(ee->es_gain_grad & YEE_THR_MASK, YEE_G_GAN);
+	regw_ip(ee->es_ofst_grad & YEE_THR_MASK, YEE_G_OFT);
+
+	if (ee->table == NULL)
+		return;
+
+	for (count = 0; count < MAX_SIZE_YEE_LUT; count++) {
+		tbl_index = count >> 1;
+		tbl_index <<= 2;
+		/* Each table has 2 LUT entries, first in LS
+		  * and second in MS positions
+		  */
+		if (count % 2) {
+			val |= (ee->table[count] & YEE_ENTRY_MASK) <<
+				YEE_ENTRY_SHIFT;
+			w_ip_table(val, tbl_index + YEE_TB_START_ADDR);
+		} else {
+			val = ee->table[count] & YEE_ENTRY_MASK;
+		}
+	}
+}
+
+/* Chromatic Artifact Correction. CAR */
+static void ipipe_set_mf(void)
+{
+	/* typ to dynamic switch */
+	regw_ip(IPIPE_CAR_DYN_SWITCH, CAR_TYP);
+	/* Set SW0 to maximum */
+	regw_ip(CAR_MF_THR, CAR_SW);
+}
+
+static void ipipe_set_gain_ctrl(struct prev_car *car)
+{
+	regw_ip(IPIPE_CAR_CHR_GAIN_CTRL, CAR_TYP);
+	regw_ip(car->hpf, CAR_HPF_TYP);
+	regw_ip(car->hpf_shft & CAR_HPF_SHIFT_MASK, CAR_HPF_SHF);
+	regw_ip(car->hpf_thr, CAR_HPF_THR);
+	regw_ip(car->gain1.gain, CAR_GN1_GAN);
+	regw_ip(car->gain1.shft & CAR_GAIN1_SHFT_MASK, CAR_GN1_SHF);
+	regw_ip(car->gain1.gain_min & CAR_GAIN_MIN_MASK, CAR_GN1_MIN);
+	regw_ip(car->gain2.gain, CAR_GN2_GAN);
+	regw_ip(car->gain2.shft & CAR_GAIN2_SHFT_MASK, CAR_GN2_SHF);
+	regw_ip(car->gain2.gain_min & CAR_GAIN_MIN_MASK, CAR_GN2_MIN);
+}
+
+void ipipe_set_car_regs(struct prev_car *car)
+{
+	u32 val;
+
+	ipipe_clock_enable();
+	regw_ip(car->en, CAR_EN);
+
+	if (!car->en)
+		return;
+
+	switch (car->meth) {
+	case IPIPE_CAR_MED_FLTR:
+		ipipe_set_mf();
+		break;
+	case IPIPE_CAR_CHR_GAIN_CTRL:
+		ipipe_set_gain_ctrl(car);
+		break;
+	default:
+		/* Dynamic switch between MF and Gain Ctrl. */
+		ipipe_set_mf();
+		ipipe_set_gain_ctrl(car);
+		/* Set the threshold for switching between
+		  * the two Here we overwrite the MF SW0 value
+		  */
+		regw_ip(IPIPE_CAR_DYN_SWITCH, CAR_TYP);
+		val = car->sw1;
+		val <<= CAR_SW1_SHIFT;
+		val |= car->sw0;
+		regw_ip(val, CAR_SW);
+	}
+}
+
+/* Chromatic Gain Suppression */
+void ipipe_set_cgs_regs(struct prev_cgs *cgs)
+{
+	ipipe_clock_enable();
+	regw_ip(cgs->en, CGS_EN);
+
+	if (!cgs->en)
+		return;
+
+	/* Set the bright side parameters */
+	regw_ip(cgs->h_thr, CGS_GN1_H_THR);
+	regw_ip(cgs->h_slope, CGS_GN1_H_GAN);
+	regw_ip(cgs->h_shft & CAR_SHIFT_MASK, CGS_GN1_H_SHF);
+	regw_ip(cgs->h_min, CGS_GN1_H_MIN);
+}
+
+void rsz_src_enable(int enable)
+{
+	regw_rsz(enable, RSZ_SRC_EN);
+}
+
+int rsz_enable(int rsz_id, int enable)
+{
+	if (rsz_id == RSZ_A) {
+		regw_rsz(enable, RSZ_EN_A);
+		/* We always enable RSZ_A. RSZ_B is enable upon request from
+		 * application. So enable RSZ_SRC_EN along with RSZ_A
+		 */
+		regw_rsz(enable, RSZ_SRC_EN);
+	} else if (rsz_id == RSZ_B) {
+		regw_rsz(enable, RSZ_EN_B);
+	} else {
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/media/platform/davinci/dm365_ipipe_hw.h b/drivers/media/platform/davinci/dm365_ipipe_hw.h
new file mode 100644
index 0000000..7e92633
--- /dev/null
+++ b/drivers/media/platform/davinci/dm365_ipipe_hw.h
@@ -0,0 +1,538 @@
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
+#ifndef _DM365_IPIPE_HW_H
+#define _DM365_IPIPE_HW_H
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+
+#define IPIPE_IOBASE_VADDR		IO_ADDRESS(0x01c70800)
+#define RSZ_IOBASE_VADDR		IO_ADDRESS(0x01c70400)
+#define IPIPE_INT_TABLE_IOBASE_VADDR	IO_ADDRESS(0x01c70000)
+
+#define SET_LOW_ADD     0x0000ffff
+#define SET_HIGH_ADD    0xffff0000
+
+/* Below are the internal tables */
+#define DPC_TB0_START_ADDR	0x8000
+#define DPC_TB1_START_ADDR	0x8400
+
+#define GAMMA_R_START_ADDR	0xa800
+#define GAMMA_G_START_ADDR	0xb000
+#define GAMMA_B_START_ADDR	0xb800
+
+/* RAM table addresses for edge enhancement correction*/
+#define YEE_TB_START_ADDR	0x8800
+
+/* RAM table address for GBC LUT */
+#define GBCE_TB_START_ADDR	0x9000
+
+/* RAM table for 3D NF LUT */
+#define D3L_TB0_START_ADDR	0x9800
+#define D3L_TB1_START_ADDR	0x9c00
+#define D3L_TB2_START_ADDR	0xa000
+#define D3L_TB3_START_ADDR	0xa400
+
+/* IPIPE Register Offsets from the base address */
+#define IPIPE_SRC_EN		0x0000
+#define IPIPE_SRC_MODE		0x0004
+#define IPIPE_SRC_FMT		0x0008
+#define IPIPE_SRC_COL		0x000c
+#define IPIPE_SRC_VPS		0x0010
+#define IPIPE_SRC_VSZ		0x0014
+#define IPIPE_SRC_HPS		0x0018
+#define IPIPE_SRC_HSZ		0x001c
+
+#define IPIPE_SEL_SBU		0x0020
+
+#define IPIPE_DMA_STA		0x0024
+#define IPIPE_GCK_MMR		0x0028
+#define IPIPE_GCK_PIX		0x002c
+#define IPIPE_RESERVED0		0x0030
+
+/* Defect Correction */
+#define DPC_LUT_EN		0x0034
+#define DPC_LUT_SEL		0x0038
+#define DPC_LUT_ADR		0x003c
+#define DPC_LUT_SIZ		0x0040
+#define DPC_OTF_EN		0x0044
+#define DPC_OTF_TYP		0x0048
+#define DPC_OTF_2D_THR_R	0x004c
+#define DPC_OTF_2D_THR_GR	0x0050
+#define DPC_OTF_2D_THR_GB	0x0054
+#define DPC_OTF_2D_THR_B	0x0058
+#define DPC_OTF_2C_THR_R	0x005c
+#define DPC_OTF_2C_THR_GR	0x0060
+#define DPC_OTF_2C_THR_GB	0x0064
+#define DPC_OTF_2C_THR_B	0x0068
+#define DPC_OTF_3_SHF		0x006c
+#define DPC_OTF_3D_THR		0x0070
+#define DPC_OTF_3D_SLP		0x0074
+#define DPC_OTF_3D_MIN		0x0078
+#define DPC_OTF_3D_MAX		0x007c
+#define DPC_OTF_3C_THR		0x0080
+#define DPC_OTF_3C_SLP		0x0084
+#define DPC_OTF_3C_MIN		0x0088
+#define DPC_OTF_3C_MAX		0x008c
+
+/* Lense Shading Correction */
+#define LSC_VOFT		0x90
+#define LSC_VA2			0x94
+#define LSC_VA1			0x98
+#define LSC_VS			0x9c
+#define LSC_HOFT		0xa0
+#define LSC_HA2			0xa4
+#define LSC_HA1			0xa8
+#define LSC_HS			0xac
+#define LSC_GAIN_R		0xb0
+#define LSC_GAIN_GR		0xb4
+#define LSC_GAIN_GB		0xb8
+#define LSC_GAIN_B		0xbc
+#define LSC_OFT_R		0xc0
+#define LSC_OFT_GR		0xc4
+#define LSC_OFT_GB		0xc8
+#define LSC_OFT_B		0xcc
+#define LSC_SHF			0xd0
+#define LSC_MAX			0xd4
+
+/* Noise Filter 1. Ofsets from start address given */
+#define D2F_1ST			0xd8
+#define D2F_EN			0x0
+#define D2F_TYP			0x4
+#define D2F_THR			0x8
+#define D2F_STR			0x28
+#define D2F_SPR			0x48
+#define D2F_EDG_MIN		0x68
+#define D2F_EDG_MAX		0x6c
+
+/* Noise Filter 2 */
+#define D2F_2ND			0x148
+
+/* GIC */
+#define GIC_EN			0x1b8
+#define GIC_TYP			0x1bc
+#define GIC_GAN			0x1c0
+#define GIC_NFGAN		0x1c4
+#define GIC_THR			0x1c8
+#define GIC_SLP			0x1cc
+
+/* White Balance */
+#define WB2_OFT_R		0x1d0
+#define WB2_OFT_GR		0x1d4
+#define WB2_OFT_GB		0x1d8
+#define WB2_OFT_B		0x1dc
+#define WB2_WGN_R		0x1e0
+#define WB2_WGN_GR		0x1e4
+#define WB2_WGN_GB		0x1e8
+#define WB2_WGN_B		0x1ec
+
+/* CFA interpolation */
+#define CFA_MODE		0x1f0
+#define CFA_2DIR_HPF_THR	0x1f4
+#define CFA_2DIR_HPF_SLP	0x1f8
+#define CFA_2DIR_MIX_THR	0x1fc
+#define CFA_2DIR_MIX_SLP	0x200
+#define CFA_2DIR_DIR_THR	0x204
+#define CFA_2DIR_DIR_SLP	0x208
+#define CFA_2DIR_NDWT		0x20c
+#define CFA_MONO_HUE_FRA	0x210
+#define CFA_MONO_EDG_THR	0x214
+#define CFA_MONO_THR_MIN	0x218
+#define CFA_MONO_THR_SLP	0x21c
+#define CFA_MONO_SLP_MIN	0x220
+#define CFA_MONO_SLP_SLP	0x224
+#define CFA_MONO_LPWT		0x228
+
+/* RGB to RGB conversiona - 1st */
+#define RGB1_MUL_BASE		0x22c
+/* Offsets from base */
+#define RGB_MUL_RR		0x0
+#define RGB_MUL_GR		0x4
+#define RGB_MUL_BR		0x8
+#define RGB_MUL_RG		0xc
+#define RGB_MUL_GG		0x10
+#define RGB_MUL_BG		0x14
+#define RGB_MUL_RB		0x18
+#define RGB_MUL_GB		0x1c
+#define RGB_MUL_BB		0x20
+#define RGB_OFT_OR		0x24
+#define RGB_OFT_OG		0x28
+#define RGB_OFT_OB		0x2c
+
+/* Gamma */
+#define GMM_CFG			0x25c
+
+/* RGB to RGB conversiona - 2nd */
+#define RGB2_MUL_BASE		0x260
+
+/* 3D LUT */
+#define D3LUT_EN		0x290
+
+/* RGB to YUV(YCbCr) conversion */
+#define YUV_ADJ			0x294
+#define YUV_MUL_RY		0x298
+#define YUV_MUL_GY		0x29c
+#define YUV_MUL_BY		0x2a0
+#define YUV_MUL_RCB		0x2a4
+#define YUV_MUL_GCB		0x2a8
+#define YUV_MUL_BCB		0x2ac
+#define YUV_MUL_RCR		0x2b0
+#define YUV_MUL_GCR		0x2b4
+#define YUV_MUL_BCR		0x2b8
+#define YUV_OFT_Y		0x2bc
+#define YUV_OFT_CB		0x2c0
+#define YUV_OFT_CR		0x2c4
+#define YUV_PHS			0x2c8
+
+/* Global Brightness and Contrast */
+#define GBCE_EN			0x2cc
+#define GBCE_TYP		0x2d0
+
+/* Edge Enhancer */
+#define YEE_EN			0x2d4
+#define YEE_TYP			0x2d8
+#define YEE_SHF			0x2dc
+#define YEE_MUL_00		0x2e0
+#define YEE_MUL_01		0x2e4
+#define YEE_MUL_02		0x2e8
+#define YEE_MUL_10		0x2ec
+#define YEE_MUL_11		0x2f0
+#define YEE_MUL_12		0x2f4
+#define YEE_MUL_20		0x2f8
+#define YEE_MUL_21		0x2fc
+#define YEE_MUL_22		0x300
+#define YEE_THR			0x304
+#define YEE_E_GAN		0x308
+#define YEE_E_THR1		0x30c
+#define YEE_E_THR2		0x310
+#define YEE_G_GAN		0x314
+#define YEE_G_OFT		0x318
+
+/* Chroma Artifact Reduction */
+#define CAR_EN			0x31c
+#define CAR_TYP			0x320
+#define CAR_SW			0x324
+#define CAR_HPF_TYP		0x328
+#define CAR_HPF_SHF		0x32c
+#define	CAR_HPF_THR		0x330
+#define CAR_GN1_GAN		0x334
+#define CAR_GN1_SHF		0x338
+#define CAR_GN1_MIN		0x33c
+#define CAR_GN2_GAN		0x340
+#define CAR_GN2_SHF		0x344
+#define CAR_GN2_MIN		0x348
+
+/* Chroma Gain Suppression */
+#define CGS_EN			0x34c
+#define CGS_GN1_L_THR		0x350
+#define CGS_GN1_L_GAN		0x354
+#define CGS_GN1_L_SHF		0x358
+#define CGS_GN1_L_MIN		0x35c
+#define CGS_GN1_H_THR		0x360
+#define CGS_GN1_H_GAN		0x364
+#define CGS_GN1_H_SHF		0x368
+#define CGS_GN1_H_MIN		0x36c
+#define CGS_GN2_L_THR		0x370
+#define CGS_GN2_L_GAN		0x374
+#define CGS_GN2_L_SHF		0x378
+#define CGS_GN2_L_MIN		0x37c
+
+/* Resizer */
+#define RSZ_SRC_EN		0x0
+#define RSZ_SRC_MODE		0x4
+#define RSZ_SRC_FMT0		0x8
+#define RSZ_SRC_FMT1		0xc
+#define RSZ_SRC_VPS		0x10
+#define RSZ_SRC_VSZ		0x14
+#define RSZ_SRC_HPS		0x18
+#define RSZ_SRC_HSZ		0x1c
+#define RSZ_DMA_RZA		0x20
+#define RSZ_DMA_RZB		0x24
+#define RSZ_DMA_STA		0x28
+#define RSZ_GCK_MMR		0x2c
+#define RSZ_RESERVED0		0x30
+#define RSZ_GCK_SDR		0x34
+#define RSZ_IRQ_RZA		0x38
+#define RSZ_IRQ_RZB		0x3c
+#define RSZ_YUV_Y_MIN		0x40
+#define RSZ_YUV_Y_MAX		0x44
+#define RSZ_YUV_C_MIN		0x48
+#define RSZ_YUV_C_MAX		0x4c
+#define RSZ_YUV_PHS		0x50
+#define RSZ_SEQ			0x54
+
+/* Resizer Rescale Parameters */
+#define RSZ_EN_A		0x58
+#define RSZ_EN_B		0xe8
+/* offset of the registers to be added with base register of
+   either RSZ0 or RSZ1
+*/
+#define RSZ_MODE		0x4
+#define RSZ_420			0x8
+#define RSZ_I_VPS		0xc
+#define RSZ_I_HPS		0x10
+#define RSZ_O_VSZ		0x14
+#define RSZ_O_HSZ		0x18
+#define RSZ_V_PHS_Y		0x1c
+#define RSZ_V_PHS_C		0x20
+#define RSZ_V_DIF		0x24
+#define RSZ_V_TYP		0x28
+#define RSZ_V_LPF		0x2c
+#define RSZ_H_PHS		0x30
+#define RSZ_H_PHS_ADJ		0x34
+#define RSZ_H_DIF		0x38
+#define RSZ_H_TYP		0x3c
+#define RSZ_H_LPF		0x40
+#define RSZ_DWN_EN		0x44
+#define RSZ_DWN_AV		0x48
+
+/* Resizer RGB Conversion Parameters */
+#define RSZ_RGB_EN		0x4c
+#define RSZ_RGB_TYP		0x50
+#define RSZ_RGB_BLD		0x54
+
+/* Resizer External Memory Parameters */
+#define RSZ_SDR_Y_BAD_H		0x58
+#define RSZ_SDR_Y_BAD_L		0x5c
+#define RSZ_SDR_Y_SAD_H		0x60
+#define RSZ_SDR_Y_SAD_L		0x64
+#define RSZ_SDR_Y_OFT		0x68
+#define RSZ_SDR_Y_PTR_S		0x6c
+#define RSZ_SDR_Y_PTR_E		0x70
+#define RSZ_SDR_C_BAD_H		0x74
+#define RSZ_SDR_C_BAD_L		0x78
+#define RSZ_SDR_C_SAD_H		0x7c
+#define RSZ_SDR_C_SAD_L		0x80
+#define RSZ_SDR_C_OFT		0x84
+#define RSZ_SDR_C_PTR_S		0x88
+#define RSZ_SDR_C_PTR_E		0x8c
+
+/* Macro for resizer */
+#define IPIPE_RESIZER_A(i)	(RSZ_IOBASE_VADDR + RSZ_EN_A + i)
+#define IPIPE_RESIZER_B(i)	(RSZ_IOBASE_VADDR + RSZ_EN_B + i)
+
+#define RSZ_YUV_Y_MIN		0x40
+#define RSZ_YUV_Y_MAX		0x44
+#define RSZ_YUV_C_MIN		0x48
+#define RSZ_YUV_C_MAX		0x4c
+
+#define IPIPE_GCK_MMR_DEFAULT	1
+#define IPIPE_GCK_PIX_DEFAULT	0xe
+#define RSZ_GCK_MMR_DEFAULT	1
+#define RSZ_GCK_SDR_DEFAULT	1
+
+/* LUTDPC */
+#define LUTDPC_TBL_256_EN	0
+#define LUTDPC_INF_TBL_EN	1
+#define LUT_DPC_START_ADDR	0
+#define LUT_DPC_H_POS_MASK	0x1fff
+#define LUT_DPC_V_POS_MASK	0x1fff
+#define LUT_DPC_V_POS_SHIFT	13
+#define LUT_DPC_CORR_METH_SHIFT	26
+#define LUT_DPC_MAX_SIZE	256
+#define LUT_DPC_SIZE_MASK	0x3ff
+
+/* OTFDPC */
+#define OTFDPC_DPC2_THR_MASK	0xfff
+#define OTF_DET_METHOD_SHIFT	1
+#define OTF_DPC3_0_SHF_MASK	3
+#define OTF_DPC3_0_THR_SHIFT	6
+#define OTF_DPC3_0_THR_MASK	0x3f
+#define OTF_DPC3_0_SLP_MASK	0x3f
+#define OTF_DPC3_0_DET_MASK	0xfff
+#define OTF_DPC3_0_CORR_MASK	0xfff
+
+/* NF (D2F) */
+#define D2F_SPR_VAL_MASK		0x1f
+#define D2F_SPR_VAL_SHIFT		0
+#define D2F_SHFT_VAL_MASK		3
+#define D2F_SHFT_VAL_SHIFT		5
+#define D2F_SAMPLE_METH_SHIFT		7
+#define D2F_APPLY_LSC_GAIN_SHIFT	8
+#define D2F_USE_SPR_REG_VAL		0
+#define D2F_STR_VAL_MASK		0x1f
+#define D2F_THR_VAL_MASK		0x3ff
+#define D2F_EDGE_DET_THR_MASK		0x7ff
+
+/* Green Imbalance Correction */
+#define GIC_TYP_SHIFT			0
+#define GIC_THR_SEL_SHIFT		1
+#define	GIC_APPLY_LSC_GAIN_SHIFT	2
+#define GIC_GAIN_MASK			0xff
+#define GIC_THR_MASK			0xfff
+#define GIC_SLOPE_MASK			0xfff
+#define GIC_NFGAN_INT_MASK		7
+#define GIC_NFGAN_DECI_MASK		0x1f
+
+/* WB */
+#define WB_OFFSET_MASK			0xfff
+#define WB_GAIN_INT_MASK		0xf
+#define WB_GAIN_DECI_MASK		0x1ff
+
+/* CFA */
+#define CFA_HPF_THR_2DIR_MASK		0x1fff
+#define CFA_HPF_SLOPE_2DIR_MASK		0x3ff
+#define CFA_HPF_MIX_THR_2DIR_MASK	0x1fff
+#define CFA_HPF_MIX_SLP_2DIR_MASK	0x3ff
+#define CFA_DIR_THR_2DIR_MASK		0x3ff
+#define CFA_DIR_SLP_2DIR_MASK		0x7f
+#define CFA_ND_WT_2DIR_MASK		0x3f
+#define CFA_DAA_HUE_FRA_MASK		0x3f
+#define CFA_DAA_EDG_THR_MASK		0xff
+#define CFA_DAA_THR_MIN_MASK		0x3ff
+#define CFA_DAA_THR_SLP_MASK		0x3ff
+#define CFA_DAA_SLP_MIN_MASK		0x3ff
+#define CFA_DAA_SLP_SLP_MASK		0x3ff
+#define CFA_DAA_LP_WT_MASK		0x3f
+
+/* RGB2RGB */
+#define RGB2RGB_1_OFST_MASK		0x1fff
+#define RGB2RGB_1_GAIN_INT_MASK		0xf
+#define RGB2RGB_GAIN_DECI_MASK		0xff
+#define RGB2RGB_2_OFST_MASK		0x7ff
+#define RGB2RGB_2_GAIN_INT_MASK		0x7
+
+/* Gamma */
+#define GAMMA_BYPR_SHIFT		0
+#define GAMMA_BYPG_SHIFT		1
+#define GAMMA_BYPB_SHIFT		2
+#define GAMMA_TBL_SEL_SHIFT		4
+#define GAMMA_TBL_SIZE_SHIFT		5
+#define GAMMA_MASK			0x3ff
+#define GAMMA_SHIFT			10
+
+/* 3D LUT */
+#define D3_LUT_ENTRY_MASK		0x3ff
+#define D3_LUT_ENTRY_R_SHIFT		20
+#define D3_LUT_ENTRY_G_SHIFT		10
+#define D3_LUT_ENTRY_B_SHIFT		0
+
+/* Lumina adj */
+#define	LUM_ADJ_CONTR_SHIFT		0
+#define	LUM_ADJ_BRIGHT_SHIFT		8
+
+/* RGB2YCbCr */
+#define RGB2YCBCR_OFST_MASK		0x7ff
+#define RGB2YCBCR_COEF_INT_MASK		0xf
+#define RGB2YCBCR_COEF_DECI_MASK	0xff
+
+/* GBCE */
+#define GBCE_Y_VAL_MASK			0xff
+#define GBCE_GAIN_VAL_MASK		0x3ff
+#define GBCE_ENTRY_SHIFT		10
+
+/* Edge Enhancements */
+#define YEE_HALO_RED_EN_SHIFT		1
+#define YEE_HPF_SHIFT_MASK		0xf
+#define YEE_COEF_MASK			0x3ff
+#define YEE_THR_MASK			0x3f
+#define YEE_ES_GAIN_MASK		0xfff
+#define YEE_ES_THR1_MASK		0xfff
+#define YEE_ENTRY_SHIFT			9
+#define YEE_ENTRY_MASK			0x1ff
+
+/* CAR */
+#define CAR_MF_THR			0xff
+#define CAR_SW1_SHIFT			8
+#define CAR_GAIN1_SHFT_MASK		7
+#define CAR_GAIN_MIN_MASK		0x1ff
+#define CAR_GAIN2_SHFT_MASK		0xf
+#define CAR_HPF_SHIFT_MASK		3
+
+/* CGS */
+#define CAR_SHIFT_MASK			3
+
+/* Resizer */
+#define RSZ_BYPASS_SHIFT		1
+#define RSZ_SRC_IMG_FMT_SHIFT		1
+#define RSZ_SRC_Y_C_SEL_SHIFT		2
+#define IPIPE_RSZ_VPS_MASK		0xffff
+#define IPIPE_RSZ_HPS_MASK		0xffff
+#define IPIPE_RSZ_VSZ_MASK		0x1fff
+#define IPIPE_RSZ_HSZ_MASK		0x1fff
+#define RSZ_HPS_MASK			0x1fff
+#define RSZ_VPS_MASK			0x1fff
+#define RSZ_O_HSZ_MASK			0x1fff
+#define RSZ_O_VSZ_MASK			0x1fff
+#define RSZ_V_PHS_MASK			0x3fff
+#define RSZ_V_DIF_MASK			0x3fff
+
+#define RSZA_H_FLIP_SHIFT		0
+#define RSZA_V_FLIP_SHIFT		1
+#define RSZB_H_FLIP_SHIFT		2
+#define RSZB_V_FLIP_SHIFT		3
+#define RSZ_A				0
+#define RSZ_B				1
+#define RSZ_CEN_SHIFT			1
+#define RSZ_YEN_SHIFT			0
+#define RSZ_TYP_Y_SHIFT			0
+#define RSZ_TYP_C_SHIFT			1
+#define RSZ_LPF_INT_MASK		0x3f
+#define RSZ_LPF_INT_MASK		0x3f
+#define RSZ_LPF_INT_C_SHIFT		6
+#define RSZ_H_PHS_MASK			0x3fff
+#define RSZ_H_DIF_MASK			0x3fff
+#define RSZ_DIFF_DOWN_THR		256
+#define RSZ_DWN_SCALE_AV_SZ_V_SHIFT	3
+#define RSZ_DWN_SCALE_AV_SZ_MASK	7
+#define RSZ_RGB_MSK1_SHIFT		2
+#define RSZ_RGB_MSK0_SHIFT		1
+#define RSZ_RGB_TYP_SHIFT		0
+#define RSZ_RGB_ALPHA_MASK		0xff
+
+static inline u32 regr_ip(u32 offset)
+{
+	return readl(IPIPE_IOBASE_VADDR + offset);
+}
+
+static inline u32 regw_ip(u32 val, u32 offset)
+{
+	writel(val, IPIPE_IOBASE_VADDR + offset);
+
+	return val;
+}
+
+static inline u32 r_ip_table(u32 offset)
+{
+	return readl(IPIPE_INT_TABLE_IOBASE_VADDR + offset);
+}
+
+static inline u32 w_ip_table(u32 val, u32 offset)
+{
+	writel(val, IPIPE_INT_TABLE_IOBASE_VADDR + offset);
+
+	return val;
+}
+
+static inline u32 regr_rsz(u32 offset)
+{
+	return readl(RSZ_IOBASE_VADDR + offset);
+}
+
+static inline u32 regw_rsz(u32 val, u32 offset)
+{
+	writel(val, RSZ_IOBASE_VADDR + offset);
+
+	return val;
+}
+
+#endif  /* End of #ifdef _DM365_IPIPE_HW_H */
-- 
1.7.4.1

