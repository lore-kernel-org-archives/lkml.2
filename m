Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1ABMkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 07:40:53 -0500
Received: from mail-ew0-f66.google.com ([209.85.215.66]:36443 "EHLO
	mail-ew0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab1ABMkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 07:40:46 -0500
Message-ID: <4d207249.cc7e0e0a.6f59.376c@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Sun, 2 Jan 2011 14:02:00 +0200
Subject: [PATCH 3/9 v2] Support for stv0367 multi-standard demodulator.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STV0367 is a multi-standard demodulator which is
capable of processing DVB-T as well as DVB-C signals.
It is fully compliant with DVB-T and DVB-C
recommendations for broadcast services.

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/dvb/frontends/Kconfig        |    7 +
 drivers/media/dvb/frontends/Makefile       |    1 +
 drivers/media/dvb/frontends/stv0367.c      | 3401 ++++++++++++++++++++++++++
 drivers/media/dvb/frontends/stv0367.h      |   62 +
 drivers/media/dvb/frontends/stv0367_priv.h |  211 ++
 drivers/media/dvb/frontends/stv0367_regs.h | 3614 ++++++++++++++++++++++++++++
 6 files changed, 7296 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/stv0367.c
 create mode 100644 drivers/media/dvb/frontends/stv0367.h
 create mode 100644 drivers/media/dvb/frontends/stv0367_priv.h
 create mode 100644 drivers/media/dvb/frontends/stv0367_regs.h

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index cc6ff60..2f2b9e2 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -371,6 +371,13 @@ config DVB_EC100
 	help
 	  Say Y when you want to support this frontend.
 
+config DVB_STV0367
+	tristate "ST STV0367 based"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  A DVB-T/C tuner module. Say Y when you want to support this frontend.
+
 comment "DVB-C (cable) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index b1d9525..a6c9406 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -83,3 +83,4 @@ obj-$(CONFIG_DVB_DS3000) += ds3000.o
 obj-$(CONFIG_DVB_MB86A16) += mb86a16.o
 obj-$(CONFIG_DVB_MB86A20S) += mb86a20s.o
 obj-$(CONFIG_DVB_IX2505V) += ix2505v.o
+obj-$(CONFIG_DVB_STV0367) += stv0367.o
diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
new file mode 100644
index 0000000..68d7d7d
--- /dev/null
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -0,0 +1,3401 @@
+/*
+ * stv0367.c
+ *
+ * Driver for ST STV0367 DVB-T & DVB-C demodulator IC.
+ *
+ * Copyright (C) ST Microelectronics.
+ * Copyright (C) 2010 NetUP Inc.
+ * Copyright (C) 2010 Igor M. Liplianin <liplianin@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+
+#include "stv0367.h"
+#include "stv0367_regs.h"
+#include "stv0367_priv.h"
+
+static int stvdebug = 0;
+module_param_named(debug, stvdebug, int, 0644);
+
+static int i2cdebug = 0;
+module_param_named(i2c_debug, i2cdebug, int, 0644);
+
+#define dprintk(args...) \
+	do { \
+		if (stvdebug) \
+			printk(KERN_DEBUG args); \
+	} while (0)
+	/* DVB-C */
+
+struct stv0367cab_state {
+	fe_stv0367_cab_signal_type_t	state;
+	u32	mclk;
+	u32	adc_clk;
+	s32	search_range;
+	s32	derot_offset;
+	/* results */
+	int locked;			/* channel found	 	*/
+	u32 freq_khz;			/* found frequency (in kHz)	*/
+	u32 symbol_rate;		/* found symbol rate (in Bds)	*/
+	stv0367cab_mod_t modulation;	/* modulation			*/
+	fe_spectral_inversion_t	spect_inv; /* Spectrum Inversion	*/
+};
+
+struct stv0367ter_state {
+	/* DVB-T */
+	fe_stv0367_ter_signal_type_t state;
+	fe_stv0367_ter_if_iq_mode_t if_iq_mode;
+	fe_stv0367_ter_mode_t mode;/* mode 2K or 8K */
+	fe_guard_interval_t guard;
+	fe_stv0367_ter_hierarchy_t hierarchy;
+	u32 frequency;
+	fe_spectral_inversion_t  sense; /*  current search spectrum */
+	u8  force; /* force mode/guard */
+	u8  bw; /* channel width 6, 7 or 8 in MHz */
+	u8  pBW; /* channel width used during previous lock */
+	u32 pBER;
+	u32 pPER;
+	u32 ucblocks;
+	s8  echo_pos; /* echo position */
+	u8  first_lock;
+	u8  unlock_counter;
+	u32 agc_val;
+};
+
+struct stv0367_state {
+	struct dvb_frontend fe;
+	struct i2c_adapter *i2c;
+	/* config settings */
+	const struct stv0367_config *config;
+	u8 chip_id;
+	/* DVB-C */
+	struct stv0367cab_state *cab_state;
+	/* DVB-T */
+	struct stv0367ter_state *ter_state;
+};
+
+struct st_register {
+	u16	addr;
+	u8	value;
+};
+
+/* values for STV4100 XTAL=30M int clk=53.125M*/
+static struct st_register def0367ter[STV0367TER_NBREGS] = {
+	{R367TER_ID,		0x60},
+	{R367TER_I2CRPT,	0xa0},
+	/* {R367TER_I2CRPT,	0x22},*/
+	{R367TER_TOPCTRL,	0x00},/* for xc5000; was 0x02 */
+	{R367TER_IOCFG0,	0x40},
+	{R367TER_DAC0R,		0x00},
+	{R367TER_IOCFG1,	0x00},
+	{R367TER_DAC1R,		0x00},
+	{R367TER_IOCFG2,	0x62},
+	{R367TER_SDFR,		0x00},
+	{R367TER_STATUS,	0xf8},
+	{R367TER_AUX_CLK,	0x0a},
+	{R367TER_FREESYS1,	0x00},
+	{R367TER_FREESYS2,	0x00},
+	{R367TER_FREESYS3,	0x00},
+	{R367TER_GPIO_CFG,	0x55},
+	{R367TER_GPIO_CMD,	0x00},
+	{R367TER_AGC2MAX,	0xff},
+	{R367TER_AGC2MIN,	0x00},
+	{R367TER_AGC1MAX,	0xff},
+	{R367TER_AGC1MIN,	0x00},
+	{R367TER_AGCR,		0xbc},
+	{R367TER_AGC2TH,	0x00},
+	{R367TER_AGC12C,	0x00},
+	{R367TER_AGCCTRL1,	0x85},
+	{R367TER_AGCCTRL2,	0x1f},
+	{R367TER_AGC1VAL1,	0x00},
+	{R367TER_AGC1VAL2,	0x00},
+	{R367TER_AGC2VAL1,	0x6f},
+	{R367TER_AGC2VAL2,	0x05},
+	{R367TER_AGC2PGA,	0x00},
+	{R367TER_OVF_RATE1,	0x00},
+	{R367TER_OVF_RATE2,	0x00},
+	{R367TER_GAIN_SRC1,	0xaa},/* for xc5000; was 0x2b */
+	{R367TER_GAIN_SRC2,	0xd6},/* for xc5000; was 0x04 */
+	{R367TER_INC_DEROT1,	0x55},
+	{R367TER_INC_DEROT2,	0x55},
+	{R367TER_PPM_CPAMP_DIR,	0x2c},
+	{R367TER_PPM_CPAMP_INV,	0x00},
+	{R367TER_FREESTFE_1,	0x00},
+	{R367TER_FREESTFE_2,	0x1c},
+	{R367TER_DCOFFSET,	0x00},
+	{R367TER_EN_PROCESS,	0x05},
+	{R367TER_SDI_SMOOTHER,	0x80},
+	{R367TER_FE_LOOP_OPEN,	0x1c},
+	{R367TER_FREQOFF1,	0x00},
+	{R367TER_FREQOFF2,	0x00},
+	{R367TER_FREQOFF3,	0x00},
+	{R367TER_TIMOFF1,	0x00},
+	{R367TER_TIMOFF2,	0x00},
+	{R367TER_EPQ,		0x02},
+	{R367TER_EPQAUTO,	0x01},
+	{R367TER_SYR_UPDATE,	0xf5},
+	{R367TER_CHPFREE,	0x00},
+	{R367TER_PPM_STATE_MAC,	0x23},
+	{R367TER_INR_THRESHOLD,	0xff},
+	{R367TER_EPQ_TPS_ID_CELL, 0xf9},
+	{R367TER_EPQ_CFG,	0x00},
+	{R367TER_EPQ_STATUS,	0x01},
+	{R367TER_AUTORELOCK,	0x81},
+	{R367TER_BER_THR_VMSB,	0x00},
+	{R367TER_BER_THR_MSB,	0x00},
+	{R367TER_BER_THR_LSB,	0x00},
+	{R367TER_CCD,		0x83},
+	{R367TER_SPECTR_CFG,	0x00},
+	{R367TER_CHC_DUMMY,	0x18},
+	{R367TER_INC_CTL,	0x88},
+	{R367TER_INCTHRES_COR1,	0xb4},
+	{R367TER_INCTHRES_COR2,	0x96},
+	{R367TER_INCTHRES_DET1,	0x0e},
+	{R367TER_INCTHRES_DET2,	0x11},
+	{R367TER_IIR_CELLNB,	0x8d},
+	{R367TER_IIRCX_COEFF1_MSB, 0x00},
+	{R367TER_IIRCX_COEFF1_LSB, 0x00},
+	{R367TER_IIRCX_COEFF2_MSB, 0x09},
+	{R367TER_IIRCX_COEFF2_LSB, 0x18},
+	{R367TER_IIRCX_COEFF3_MSB, 0x14},
+	{R367TER_IIRCX_COEFF3_LSB, 0x9c},
+	{R367TER_IIRCX_COEFF4_MSB, 0x00},
+	{R367TER_IIRCX_COEFF4_LSB, 0x00},
+	{R367TER_IIRCX_COEFF5_MSB, 0x36},
+	{R367TER_IIRCX_COEFF5_LSB, 0x42},
+	{R367TER_FEPATH_CFG,	0x00},
+	{R367TER_PMC1_FUNC,	0x65},
+	{R367TER_PMC1_FOR,	0x00},
+	{R367TER_PMC2_FUNC,	0x00},
+	{R367TER_STATUS_ERR_DA,	0xe0},
+	{R367TER_DIG_AGC_R,	0xfe},
+	{R367TER_COMAGC_TARMSB,	0x0b},
+	{R367TER_COM_AGC_TAR_ENMODE, 0x41},
+	{R367TER_COM_AGC_CFG,	0x3e},
+	{R367TER_COM_AGC_GAIN1, 0x39},
+	{R367TER_AUT_AGC_TARGETMSB, 0x0b},
+	{R367TER_LOCK_DET_MSB,	0x01},
+	{R367TER_AGCTAR_LOCK_LSBS, 0x40},
+	{R367TER_AUT_GAIN_EN,	0xf4},
+	{R367TER_AUT_CFG,	0xf0},
+	{R367TER_LOCKN,		0x23},
+	{R367TER_INT_X_3,	0x00},
+	{R367TER_INT_X_2,	0x03},
+	{R367TER_INT_X_1,	0x8d},
+	{R367TER_INT_X_0,	0xa0},
+	{R367TER_MIN_ERRX_MSB,	0x00},
+	{R367TER_COR_CTL,	0x23},
+	{R367TER_COR_STAT,	0xf6},
+	{R367TER_COR_INTEN,	0x00},
+	{R367TER_COR_INTSTAT,	0x3f},
+	{R367TER_COR_MODEGUARD,	0x03},
+	{R367TER_AGC_CTL,	0x08},
+	{R367TER_AGC_MANUAL1,	0x00},
+	{R367TER_AGC_MANUAL2,	0x00},
+	{R367TER_AGC_TARG,	0x16},
+	{R367TER_AGC_GAIN1,	0x53},
+	{R367TER_AGC_GAIN2,	0x1d},
+	{R367TER_RESERVED_1,	0x00},
+	{R367TER_RESERVED_2,	0x00},
+	{R367TER_RESERVED_3,	0x00},
+	{R367TER_CAS_CTL,	0x44},
+	{R367TER_CAS_FREQ,	0xb3},
+	{R367TER_CAS_DAGCGAIN,	0x12},
+	{R367TER_SYR_CTL,	0x04},
+	{R367TER_SYR_STAT,	0x10},
+	{R367TER_SYR_NCO1,	0x00},
+	{R367TER_SYR_NCO2,	0x00},
+	{R367TER_SYR_OFFSET1,	0x00},
+	{R367TER_SYR_OFFSET2,	0x00},
+	{R367TER_FFT_CTL,	0x00},
+	{R367TER_SCR_CTL,	0x70},
+	{R367TER_PPM_CTL1,	0xf8},
+	{R367TER_TRL_CTL,	0x14},/* for xc5000; was 0xac */
+	{R367TER_TRL_NOMRATE1,	0xae},/* for xc5000; was 0x1e */
+	{R367TER_TRL_NOMRATE2,	0x56},/* for xc5000; was 0x58 */
+	{R367TER_TRL_TIME1,	0x1d},
+	{R367TER_TRL_TIME2,	0xfc},
+	{R367TER_CRL_CTL,	0x24},
+	{R367TER_CRL_FREQ1,	0xad},
+	{R367TER_CRL_FREQ2,	0x9d},
+	{R367TER_CRL_FREQ3,	0xff},
+	{R367TER_CHC_CTL,	0x01},
+	{R367TER_CHC_SNR,	0xf0},
+	{R367TER_BDI_CTL,	0x00},
+	{R367TER_DMP_CTL,	0x00},
+	{R367TER_TPS_RCVD1,	0x30},
+	{R367TER_TPS_RCVD2,	0x02},
+	{R367TER_TPS_RCVD3,	0x01},
+	{R367TER_TPS_RCVD4,	0x00},
+	{R367TER_TPS_ID_CELL1,	0x00},
+	{R367TER_TPS_ID_CELL2,	0x00},
+	{R367TER_TPS_RCVD5_SET1, 0x02},
+	{R367TER_TPS_SET2,	0x02},
+	{R367TER_TPS_SET3,	0x01},
+	{R367TER_TPS_CTL,	0x00},
+	{R367TER_CTL_FFTOSNUM,	0x34},
+	{R367TER_TESTSELECT,	0x09},
+	{R367TER_MSC_REV,	0x0a},
+	{R367TER_PIR_CTL,	0x00},
+	{R367TER_SNR_CARRIER1,	0xa1},
+	{R367TER_SNR_CARRIER2,	0x9a},
+	{R367TER_PPM_CPAMP,	0x2c},
+	{R367TER_TSM_AP0,	0x00},
+	{R367TER_TSM_AP1,	0x00},
+	{R367TER_TSM_AP2 ,	0x00},
+	{R367TER_TSM_AP3,	0x00},
+	{R367TER_TSM_AP4,	0x00},
+	{R367TER_TSM_AP5,	0x00},
+	{R367TER_TSM_AP6,	0x00},
+	{R367TER_TSM_AP7,	0x00},
+	{R367TER_TSTRES,	0x00},
+	{R367TER_ANACTRL,	0x0D},/* PLL stoped, restart at init!!! */
+	{R367TER_TSTBUS,	0x00},
+	{R367TER_TSTRATE,	0x00},
+	{R367TER_CONSTMODE,	0x01},
+	{R367TER_CONSTCARR1,	0x00},
+	{R367TER_CONSTCARR2,	0x00},
+	{R367TER_ICONSTEL,	0x0a},
+	{R367TER_QCONSTEL,	0x15},
+	{R367TER_TSTBISTRES0,	0x00},
+	{R367TER_TSTBISTRES1,	0x00},
+	{R367TER_TSTBISTRES2,	0x28},
+	{R367TER_TSTBISTRES3,	0x00},
+	{R367TER_RF_AGC1,	0xff},
+	{R367TER_RF_AGC2,	0x83},
+	{R367TER_ANADIGCTRL,	0x19},
+	{R367TER_PLLMDIV,	0x01},/* for xc5000; was 0x0c */
+	{R367TER_PLLNDIV,	0x06},/* for xc5000; was 0x55 */
+	{R367TER_PLLSETUP,	0x18},
+	{R367TER_DUAL_AD12,	0x04},/* for xc5000; was 0x00 */
+	{R367TER_TSTBIST,	0x00},
+	{R367TER_PAD_COMP_CTRL,	0x00},
+	{R367TER_PAD_COMP_WR,	0x00},
+	{R367TER_PAD_COMP_RD,	0xe0},
+	{R367TER_SYR_TARGET_FFTADJT_MSB, 0x00},
+	{R367TER_SYR_TARGET_FFTADJT_LSB, 0x00},
+	{R367TER_SYR_TARGET_CHCADJT_MSB, 0x00},
+	{R367TER_SYR_TARGET_CHCADJT_LSB, 0x00},
+	{R367TER_SYR_FLAG,	0x00},
+	{R367TER_CRL_TARGET1,	0x00},
+	{R367TER_CRL_TARGET2,	0x00},
+	{R367TER_CRL_TARGET3,	0x00},
+	{R367TER_CRL_TARGET4,	0x00},
+	{R367TER_CRL_FLAG,	0x00},
+	{R367TER_TRL_TARGET1,	0x00},
+	{R367TER_TRL_TARGET2,	0x00},
+	{R367TER_TRL_CHC,	0x00},
+	{R367TER_CHC_SNR_TARG,	0x00},
+	{R367TER_TOP_TRACK,	0x00},
+	{R367TER_TRACKER_FREE1,	0x00},
+	{R367TER_ERROR_CRL1,	0x00},
+	{R367TER_ERROR_CRL2,	0x00},
+	{R367TER_ERROR_CRL3,	0x00},
+	{R367TER_ERROR_CRL4,	0x00},
+	{R367TER_DEC_NCO1,	0x2c},
+	{R367TER_DEC_NCO2,	0x0f},
+	{R367TER_DEC_NCO3,	0x20},
+	{R367TER_SNR,		0xf1},
+	{R367TER_SYR_FFTADJ1,	0x00},
+	{R367TER_SYR_FFTADJ2,	0x00},
+	{R367TER_SYR_CHCADJ1,	0x00},
+	{R367TER_SYR_CHCADJ2,	0x00},
+	{R367TER_SYR_OFF,	0x00},
+	{R367TER_PPM_OFFSET1,	0x00},
+	{R367TER_PPM_OFFSET2,	0x03},
+	{R367TER_TRACKER_FREE2,	0x00},
+	{R367TER_DEBG_LT10,	0x00},
+	{R367TER_DEBG_LT11,	0x00},
+	{R367TER_DEBG_LT12,	0x00},
+	{R367TER_DEBG_LT13,	0x00},
+	{R367TER_DEBG_LT14,	0x00},
+	{R367TER_DEBG_LT15,	0x00},
+	{R367TER_DEBG_LT16,	0x00},
+	{R367TER_DEBG_LT17,	0x00},
+	{R367TER_DEBG_LT18,	0x00},
+	{R367TER_DEBG_LT19,	0x00},
+	{R367TER_DEBG_LT1A,	0x00},
+	{R367TER_DEBG_LT1B,	0x00},
+	{R367TER_DEBG_LT1C,	0x00},
+	{R367TER_DEBG_LT1D,	0x00},
+	{R367TER_DEBG_LT1E,	0x00},
+	{R367TER_DEBG_LT1F,	0x00},
+	{R367TER_RCCFGH,	0x00},
+	{R367TER_RCCFGM,	0x00},
+	{R367TER_RCCFGL,	0x00},
+	{R367TER_RCINSDELH,	0x00},
+	{R367TER_RCINSDELM,	0x00},
+	{R367TER_RCINSDELL,	0x00},
+	{R367TER_RCSTATUS,	0x00},
+	{R367TER_RCSPEED,	0x6f},
+	{R367TER_RCDEBUGM,	0xe7},
+	{R367TER_RCDEBUGL,	0x9b},
+	{R367TER_RCOBSCFG,	0x00},
+	{R367TER_RCOBSM,	0x00},
+	{R367TER_RCOBSL,	0x00},
+	{R367TER_RCFECSPY,	0x00},
+	{R367TER_RCFSPYCFG,	0x00},
+	{R367TER_RCFSPYDATA,	0x00},
+	{R367TER_RCFSPYOUT,	0x00},
+	{R367TER_RCFSTATUS,	0x00},
+	{R367TER_RCFGOODPACK,	0x00},
+	{R367TER_RCFPACKCNT,	0x00},
+	{R367TER_RCFSPYMISC,	0x00},
+	{R367TER_RCFBERCPT4,	0x00},
+	{R367TER_RCFBERCPT3,	0x00},
+	{R367TER_RCFBERCPT2,	0x00},
+	{R367TER_RCFBERCPT1,	0x00},
+	{R367TER_RCFBERCPT0,	0x00},
+	{R367TER_RCFBERERR2,	0x00},
+	{R367TER_RCFBERERR1,	0x00},
+	{R367TER_RCFBERERR0,	0x00},
+	{R367TER_RCFSTATESM,	0x00},
+	{R367TER_RCFSTATESL,	0x00},
+	{R367TER_RCFSPYBER,	0x00},
+	{R367TER_RCFSPYDISTM,	0x00},
+	{R367TER_RCFSPYDISTL,	0x00},
+	{R367TER_RCFSPYOBS7,	0x00},
+	{R367TER_RCFSPYOBS6,	0x00},
+	{R367TER_RCFSPYOBS5,	0x00},
+	{R367TER_RCFSPYOBS4,	0x00},
+	{R367TER_RCFSPYOBS3,	0x00},
+	{R367TER_RCFSPYOBS2,	0x00},
+	{R367TER_RCFSPYOBS1,	0x00},
+	{R367TER_RCFSPYOBS0,	0x00},
+	{R367TER_TSGENERAL,	0x00},
+	{R367TER_RC1SPEED,	0x6f},
+	{R367TER_TSGSTATUS,	0x18},
+	{R367TER_FECM,		0x01},
+	{R367TER_VTH12,		0xff},
+	{R367TER_VTH23,		0xa1},
+	{R367TER_VTH34,		0x64},
+	{R367TER_VTH56,		0x40},
+	{R367TER_VTH67,		0x00},
+	{R367TER_VTH78,		0x2c},
+	{R367TER_VITCURPUN,	0x12},
+	{R367TER_VERROR,	0x01},
+	{R367TER_PRVIT,		0x3f},
+	{R367TER_VAVSRVIT,	0x00},
+	{R367TER_VSTATUSVIT,	0xbd},
+	{R367TER_VTHINUSE,	0xa1},
+	{R367TER_KDIV12,	0x20},
+	{R367TER_KDIV23,	0x40},
+	{R367TER_KDIV34,	0x20},
+	{R367TER_KDIV56,	0x30},
+	{R367TER_KDIV67,	0x00},
+	{R367TER_KDIV78,	0x30},
+	{R367TER_SIGPOWER,	0x54},
+	{R367TER_DEMAPVIT,	0x40},
+	{R367TER_VITSCALE,	0x00},
+	{R367TER_FFEC1PRG,	0x00},
+	{R367TER_FVITCURPUN,	0x12},
+	{R367TER_FVERROR,	0x01},
+	{R367TER_FVSTATUSVIT,	0xbd},
+	{R367TER_DEBUG_LT1,	0x00},
+	{R367TER_DEBUG_LT2,	0x00},
+	{R367TER_DEBUG_LT3,	0x00},
+	{R367TER_TSTSFMET,	0x00},
+	{R367TER_SELOUT,	0x00},
+	{R367TER_TSYNC,		0x00},
+	{R367TER_TSTERR,	0x00},
+	{R367TER_TSFSYNC,	0x00},
+	{R367TER_TSTSFERR,	0x00},
+	{R367TER_TSTTSSF1,	0x01},
+	{R367TER_TSTTSSF2,	0x1f},
+	{R367TER_TSTTSSF3,	0x00},
+	{R367TER_TSTTS1,	0x00},
+	{R367TER_TSTTS2,	0x1f},
+	{R367TER_TSTTS3,	0x01},
+	{R367TER_TSTTS4,	0x00},
+	{R367TER_TSTTSRC,	0x00},
+	{R367TER_TSTTSRS,	0x00},
+	{R367TER_TSSTATEM,	0xb0},
+	{R367TER_TSSTATEL,	0x40},
+	{R367TER_TSCFGH,	0xC0},
+	{R367TER_TSCFGM,	0xc0},/* for xc5000; was 0x00 */
+	{R367TER_TSCFGL,	0x20},
+	{R367TER_TSSYNC,	0x00},
+	{R367TER_TSINSDELH,	0x00},
+	{R367TER_TSINSDELM,	0x00},
+	{R367TER_TSINSDELL,	0x00},
+	{R367TER_TSDIVN,	0x03},
+	{R367TER_TSDIVPM,	0x00},
+	{R367TER_TSDIVPL,	0x00},
+	{R367TER_TSDIVQM,	0x00},
+	{R367TER_TSDIVQL,	0x00},
+	{R367TER_TSDILSTKM,	0x00},
+	{R367TER_TSDILSTKL,	0x00},
+	{R367TER_TSSPEED,	0x40},/* for xc5000; was 0x6f */
+	{R367TER_TSSTATUS,	0x81},
+	{R367TER_TSSTATUS2,	0x6a},
+	{R367TER_TSBITRATEM,	0x0f},
+	{R367TER_TSBITRATEL,	0xc6},
+	{R367TER_TSPACKLENM,	0x00},
+	{R367TER_TSPACKLENL,	0xfc},
+	{R367TER_TSBLOCLENM,	0x0a},
+	{R367TER_TSBLOCLENL,	0x80},
+	{R367TER_TSDLYH,	0x90},
+	{R367TER_TSDLYM,	0x68},
+	{R367TER_TSDLYL,	0x01},
+	{R367TER_TSNPDAV,	0x00},
+	{R367TER_TSBUFSTATH,	0x00},
+	{R367TER_TSBUFSTATM,	0x00},
+	{R367TER_TSBUFSTATL,	0x00},
+	{R367TER_TSDEBUGM,	0xcf},
+	{R367TER_TSDEBUGL,	0x1e},
+	{R367TER_TSDLYSETH,	0x00},
+	{R367TER_TSDLYSETM,	0x68},
+	{R367TER_TSDLYSETL,	0x00},
+	{R367TER_TSOBSCFG,	0x00},
+	{R367TER_TSOBSM,	0x47},
+	{R367TER_TSOBSL,	0x1f},
+	{R367TER_ERRCTRL1,	0x95},
+	{R367TER_ERRCNT1H,	0x80},
+	{R367TER_ERRCNT1M,	0x00},
+	{R367TER_ERRCNT1L,	0x00},
+	{R367TER_ERRCTRL2,	0x95},
+	{R367TER_ERRCNT2H,	0x00},
+	{R367TER_ERRCNT2M,	0x00},
+	{R367TER_ERRCNT2L,	0x00},
+	{R367TER_FECSPY,	0x88},
+	{R367TER_FSPYCFG,	0x2c},
+	{R367TER_FSPYDATA,	0x3a},
+	{R367TER_FSPYOUT,	0x06},
+	{R367TER_FSTATUS,	0x61},
+	{R367TER_FGOODPACK,	0xff},
+	{R367TER_FPACKCNT,	0xff},
+	{R367TER_FSPYMISC,	0x66},
+	{R367TER_FBERCPT4,	0x00},
+	{R367TER_FBERCPT3,	0x00},
+	{R367TER_FBERCPT2,	0x36},
+	{R367TER_FBERCPT1,	0x36},
+	{R367TER_FBERCPT0,	0x14},
+	{R367TER_FBERERR2,	0x00},
+	{R367TER_FBERERR1,	0x03},
+	{R367TER_FBERERR0,	0x28},
+	{R367TER_FSTATESM,	0x00},
+	{R367TER_FSTATESL,	0x02},
+	{R367TER_FSPYBER,	0x00},
+	{R367TER_FSPYDISTM,	0x01},
+	{R367TER_FSPYDISTL,	0x9f},
+	{R367TER_FSPYOBS7,	0xc9},
+	{R367TER_FSPYOBS6,	0x99},
+	{R367TER_FSPYOBS5,	0x08},
+	{R367TER_FSPYOBS4,	0xec},
+	{R367TER_FSPYOBS3,	0x01},
+	{R367TER_FSPYOBS2,	0x0f},
+	{R367TER_FSPYOBS1,	0xf5},
+	{R367TER_FSPYOBS0,	0x08},
+	{R367TER_SFDEMAP,	0x40},
+	{R367TER_SFERROR,	0x00},
+	{R367TER_SFAVSR,	0x30},
+	{R367TER_SFECSTATUS,	0xcc},
+	{R367TER_SFKDIV12,	0x20},
+	{R367TER_SFKDIV23,	0x40},
+	{R367TER_SFKDIV34,	0x20},
+	{R367TER_SFKDIV56,	0x20},
+	{R367TER_SFKDIV67,	0x00},
+	{R367TER_SFKDIV78,	0x20},
+	{R367TER_SFDILSTKM,	0x00},
+	{R367TER_SFDILSTKL,	0x00},
+	{R367TER_SFSTATUS,	0xb5},
+	{R367TER_SFDLYH,	0x90},
+	{R367TER_SFDLYM,	0x60},
+	{R367TER_SFDLYL,	0x01},
+	{R367TER_SFDLYSETH,	0xc0},
+	{R367TER_SFDLYSETM,	0x60},
+	{R367TER_SFDLYSETL,	0x00},
+	{R367TER_SFOBSCFG,	0x00},
+	{R367TER_SFOBSM,	0x47},
+	{R367TER_SFOBSL,	0x05},
+	{R367TER_SFECINFO,	0x40},
+	{R367TER_SFERRCTRL,	0x74},
+	{R367TER_SFERRCNTH,	0x80},
+	{R367TER_SFERRCNTM ,	0x00},
+	{R367TER_SFERRCNTL,	0x00},
+	{R367TER_SYMBRATEM,	0x2f},
+	{R367TER_SYMBRATEL,	0x50},
+	{R367TER_SYMBSTATUS,	0x7f},
+	{R367TER_SYMBCFG,	0x00},
+	{R367TER_SYMBFIFOM,	0xf4},
+	{R367TER_SYMBFIFOL,	0x0d},
+	{R367TER_SYMBOFFSM,	0xf0},
+	{R367TER_SYMBOFFSL,	0x2d},
+	{R367TER_DEBUG_LT4,	0x00},
+	{R367TER_DEBUG_LT5,	0x00},
+	{R367TER_DEBUG_LT6,	0x00},
+	{R367TER_DEBUG_LT7,	0x00},
+	{R367TER_DEBUG_LT8,	0x00},
+	{R367TER_DEBUG_LT9,	0x00},
+};
+
+#define RF_LOOKUP_TABLE_SIZE  31
+#define RF_LOOKUP_TABLE2_SIZE 16
+/* RF Level (for RF AGC->AGC1) Lookup Table, depends on the board and tuner.*/
+s32 stv0367cab_RF_LookUp1[RF_LOOKUP_TABLE_SIZE][RF_LOOKUP_TABLE_SIZE] = {
+	{/*AGC1*/
+		48, 50, 51, 53, 54, 56, 57, 58, 60, 61, 62, 63,
+		64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75,
+		76, 77, 78, 80, 83, 85, 88,
+	}, {/*RF(dbm)*/
+		22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33,
+		34, 35, 36, 37, 38, 39, 41, 42, 43, 44, 46, 47,
+		49, 50, 52, 53, 54, 55, 56,
+	}
+};
+/* RF Level (for IF AGC->AGC2) Lookup Table, depends on the board and tuner.*/
+s32 stv0367cab_RF_LookUp2[RF_LOOKUP_TABLE2_SIZE][RF_LOOKUP_TABLE2_SIZE] = {
+	{/*AGC2*/
+		28, 29, 31, 32, 34, 35, 36, 37,
+		38, 39, 40, 41, 42, 43, 44, 45,
+	}, {/*RF(dbm)*/
+		57, 58, 59, 60, 61, 62, 63, 64,
+		65, 66, 67, 68, 69, 70, 71, 72,
+	}
+};
+
+static struct st_register def0367cab[STV0367CAB_NBREGS] = {
+	{R367CAB_ID,		0x60},
+	{R367CAB_I2CRPT,	0xa0},
+	/*{R367CAB_I2CRPT,	0x22},*/
+	{R367CAB_TOPCTRL,	0x10},
+	{R367CAB_IOCFG0,	0x80},
+	{R367CAB_DAC0R,		0x00},
+	{R367CAB_IOCFG1,	0x00},
+	{R367CAB_DAC1R,		0x00},
+	{R367CAB_IOCFG2,	0x00},
+	{R367CAB_SDFR,		0x00},
+	{R367CAB_AUX_CLK,	0x00},
+	{R367CAB_FREESYS1,	0x00},
+	{R367CAB_FREESYS2,	0x00},
+	{R367CAB_FREESYS3,	0x00},
+	{R367CAB_GPIO_CFG,	0x55},
+	{R367CAB_GPIO_CMD,	0x01},
+	{R367CAB_TSTRES,	0x00},
+	{R367CAB_ANACTRL,	0x0d},/* was 0x00 need to check - I.M.L.*/
+	{R367CAB_TSTBUS,	0x00},
+	{R367CAB_RF_AGC1,	0xea},
+	{R367CAB_RF_AGC2,	0x82},
+	{R367CAB_ANADIGCTRL,	0x0b},
+	{R367CAB_PLLMDIV,	0x01},
+	{R367CAB_PLLNDIV,	0x08},
+	{R367CAB_PLLSETUP,	0x18},
+	{R367CAB_DUAL_AD12,	0x04},
+	{R367CAB_TSTBIST,	0x00},
+	{R367CAB_CTRL_1,	0x00},
+	{R367CAB_CTRL_2,	0x03},
+	{R367CAB_IT_STATUS1,	0x2b},
+	{R367CAB_IT_STATUS2,	0x08},
+	{R367CAB_IT_EN1,	0x00},
+	{R367CAB_IT_EN2,	0x00},
+	{R367CAB_CTRL_STATUS,	0x04},
+	{R367CAB_TEST_CTL,	0x00},
+	{R367CAB_AGC_CTL,	0x73},
+	{R367CAB_AGC_IF_CFG,	0x50},
+	{R367CAB_AGC_RF_CFG,	0x00},
+	{R367CAB_AGC_PWM_CFG,	0x03},
+	{R367CAB_AGC_PWR_REF_L,	0x5a},
+	{R367CAB_AGC_PWR_REF_H,	0x00},
+	{R367CAB_AGC_RF_TH_L,	0xff},
+	{R367CAB_AGC_RF_TH_H,	0x07},
+	{R367CAB_AGC_IF_LTH_L,	0x00},
+	{R367CAB_AGC_IF_LTH_H,	0x08},
+	{R367CAB_AGC_IF_HTH_L,	0xff},
+	{R367CAB_AGC_IF_HTH_H,	0x07},
+	{R367CAB_AGC_PWR_RD_L,	0xa0},
+	{R367CAB_AGC_PWR_RD_M,	0xe9},
+	{R367CAB_AGC_PWR_RD_H,	0x03},
+	{R367CAB_AGC_PWM_IFCMD_L,	0xe4},
+	{R367CAB_AGC_PWM_IFCMD_H,	0x00},
+	{R367CAB_AGC_PWM_RFCMD_L,	0xff},
+	{R367CAB_AGC_PWM_RFCMD_H,	0x07},
+	{R367CAB_IQDEM_CFG,	0x01},
+	{R367CAB_MIX_NCO_LL,	0x22},
+	{R367CAB_MIX_NCO_HL,	0x96},
+	{R367CAB_MIX_NCO_HH,	0x55},
+	{R367CAB_SRC_NCO_LL,	0xff},
+	{R367CAB_SRC_NCO_LH,	0x0c},
+	{R367CAB_SRC_NCO_HL,	0xf5},
+	{R367CAB_SRC_NCO_HH,	0x20},
+	{R367CAB_IQDEM_GAIN_SRC_L,	0x06},
+	{R367CAB_IQDEM_GAIN_SRC_H,	0x01},
+	{R367CAB_IQDEM_DCRM_CFG_LL,	0xfe},
+	{R367CAB_IQDEM_DCRM_CFG_LH,	0xff},
+	{R367CAB_IQDEM_DCRM_CFG_HL,	0x0f},
+	{R367CAB_IQDEM_DCRM_CFG_HH,	0x00},
+	{R367CAB_IQDEM_ADJ_COEFF0,	0x34},
+	{R367CAB_IQDEM_ADJ_COEFF1,	0xae},
+	{R367CAB_IQDEM_ADJ_COEFF2,	0x46},
+	{R367CAB_IQDEM_ADJ_COEFF3,	0x77},
+	{R367CAB_IQDEM_ADJ_COEFF4,	0x96},
+	{R367CAB_IQDEM_ADJ_COEFF5,	0x69},
+	{R367CAB_IQDEM_ADJ_COEFF6,	0xc7},
+	{R367CAB_IQDEM_ADJ_COEFF7,	0x01},
+	{R367CAB_IQDEM_ADJ_EN,	0x04},
+	{R367CAB_IQDEM_ADJ_AGC_REF,	0x94},
+	{R367CAB_ALLPASSFILT1,	0xc9},
+	{R367CAB_ALLPASSFILT2,	0x2d},
+	{R367CAB_ALLPASSFILT3,	0xa3},
+	{R367CAB_ALLPASSFILT4,	0xfb},
+	{R367CAB_ALLPASSFILT5,	0xf6},
+	{R367CAB_ALLPASSFILT6,	0x45},
+	{R367CAB_ALLPASSFILT7,	0x6f},
+	{R367CAB_ALLPASSFILT8,	0x7e},
+	{R367CAB_ALLPASSFILT9,	0x05},
+	{R367CAB_ALLPASSFILT10,	0x0a},
+	{R367CAB_ALLPASSFILT11,	0x51},
+	{R367CAB_TRL_AGC_CFG,	0x20},
+	{R367CAB_TRL_LPF_CFG,	0x28},
+	{R367CAB_TRL_LPF_ACQ_GAIN,	0x44},
+	{R367CAB_TRL_LPF_TRK_GAIN,	0x22},
+	{R367CAB_TRL_LPF_OUT_GAIN,	0x03},
+	{R367CAB_TRL_LOCKDET_LTH,	0x04},
+	{R367CAB_TRL_LOCKDET_HTH,	0x11},
+	{R367CAB_TRL_LOCKDET_TRGVAL,	0x20},
+	{R367CAB_IQ_QAM,	0x01},
+	{R367CAB_FSM_STATE,	0xa0},
+	{R367CAB_FSM_CTL,	0x08},
+	{R367CAB_FSM_STS,	0x0c},
+	{R367CAB_FSM_SNR0_HTH,	0x00},
+	{R367CAB_FSM_SNR1_HTH,	0x00},
+	{R367CAB_FSM_SNR2_HTH,	0x23},/* 0x00 */
+	{R367CAB_FSM_SNR0_LTH,	0x00},
+	{R367CAB_FSM_SNR1_LTH,	0x00},
+	{R367CAB_FSM_EQA1_HTH,	0x00},
+	{R367CAB_FSM_TEMPO,	0x32},
+	{R367CAB_FSM_CONFIG,	0x03},
+	{R367CAB_EQU_I_TESTTAP_L,	0x11},
+	{R367CAB_EQU_I_TESTTAP_M,	0x00},
+	{R367CAB_EQU_I_TESTTAP_H,	0x00},
+	{R367CAB_EQU_TESTAP_CFG,	0x00},
+	{R367CAB_EQU_Q_TESTTAP_L,	0xff},
+	{R367CAB_EQU_Q_TESTTAP_M,	0x00},
+	{R367CAB_EQU_Q_TESTTAP_H,	0x00},
+	{R367CAB_EQU_TAP_CTRL,	0x00},
+	{R367CAB_EQU_CTR_CRL_CONTROL_L,	0x11},
+	{R367CAB_EQU_CTR_CRL_CONTROL_H,	0x05},
+	{R367CAB_EQU_CTR_HIPOW_L,	0x00},
+	{R367CAB_EQU_CTR_HIPOW_H,	0x00},
+	{R367CAB_EQU_I_EQU_LO,	0xef},
+	{R367CAB_EQU_I_EQU_HI,	0x00},
+	{R367CAB_EQU_Q_EQU_LO,	0xee},
+	{R367CAB_EQU_Q_EQU_HI,	0x00},
+	{R367CAB_EQU_MAPPER,	0xc5},
+	{R367CAB_EQU_SWEEP_RATE,	0x80},
+	{R367CAB_EQU_SNR_LO,	0x64},
+	{R367CAB_EQU_SNR_HI,	0x03},
+	{R367CAB_EQU_GAMMA_LO,	0x00},
+	{R367CAB_EQU_GAMMA_HI,	0x00},
+	{R367CAB_EQU_ERR_GAIN,	0x36},
+	{R367CAB_EQU_RADIUS,	0xaa},
+	{R367CAB_EQU_FFE_MAINTAP,	0x00},
+	{R367CAB_EQU_FFE_LEAKAGE,	0x63},
+	{R367CAB_EQU_FFE_MAINTAP_POS,	0xdf},
+	{R367CAB_EQU_GAIN_WIDE,	0x88},
+	{R367CAB_EQU_GAIN_NARROW,	0x41},
+	{R367CAB_EQU_CTR_LPF_GAIN,	0xd1},
+	{R367CAB_EQU_CRL_LPF_GAIN,	0xa7},
+	{R367CAB_EQU_GLOBAL_GAIN,	0x06},
+	{R367CAB_EQU_CRL_LD_SEN,	0x85},
+	{R367CAB_EQU_CRL_LD_VAL,	0xe2},
+	{R367CAB_EQU_CRL_TFR,	0x20},
+	{R367CAB_EQU_CRL_BISTH_LO,	0x00},
+	{R367CAB_EQU_CRL_BISTH_HI,	0x00},
+	{R367CAB_EQU_SWEEP_RANGE_LO,	0x00},
+	{R367CAB_EQU_SWEEP_RANGE_HI,	0x00},
+	{R367CAB_EQU_CRL_LIMITER,	0x40},
+	{R367CAB_EQU_MODULUS_MAP,	0x90},
+	{R367CAB_EQU_PNT_GAIN,	0xa7},
+	{R367CAB_FEC_AC_CTR_0,	0x16},
+	{R367CAB_FEC_AC_CTR_1,	0x0b},
+	{R367CAB_FEC_AC_CTR_2,	0x88},
+	{R367CAB_FEC_AC_CTR_3,	0x02},
+	{R367CAB_FEC_STATUS,	0x12},
+	{R367CAB_RS_COUNTER_0,	0x7d},
+	{R367CAB_RS_COUNTER_1,	0xd0},
+	{R367CAB_RS_COUNTER_2,	0x19},
+	{R367CAB_RS_COUNTER_3,	0x0b},
+	{R367CAB_RS_COUNTER_4,	0xa3},
+	{R367CAB_RS_COUNTER_5,	0x00},
+	{R367CAB_BERT_0,	0x01},
+	{R367CAB_BERT_1,	0x25},
+	{R367CAB_BERT_2,	0x41},
+	{R367CAB_BERT_3,	0x39},
+	{R367CAB_OUTFORMAT_0,	0xc2},
+	{R367CAB_OUTFORMAT_1,	0x22},
+	{R367CAB_SMOOTHER_2,	0x28},
+	{R367CAB_TSMF_CTRL_0,	0x01},
+	{R367CAB_TSMF_CTRL_1,	0xc6},
+	{R367CAB_TSMF_CTRL_3,	0x43},
+	{R367CAB_TS_ON_ID_0,	0x00},
+	{R367CAB_TS_ON_ID_1,	0x00},
+	{R367CAB_TS_ON_ID_2,	0x00},
+	{R367CAB_TS_ON_ID_3,	0x00},
+	{R367CAB_RE_STATUS_0,	0x00},
+	{R367CAB_RE_STATUS_1,	0x00},
+	{R367CAB_RE_STATUS_2,	0x00},
+	{R367CAB_RE_STATUS_3,	0x00},
+	{R367CAB_TS_STATUS_0,	0x00},
+	{R367CAB_TS_STATUS_1,	0x00},
+	{R367CAB_TS_STATUS_2,	0xa0},
+	{R367CAB_TS_STATUS_3,	0x00},
+	{R367CAB_T_O_ID_0,	0x00},
+	{R367CAB_T_O_ID_1,	0x00},
+	{R367CAB_T_O_ID_2,	0x00},
+	{R367CAB_T_O_ID_3,	0x00},
+};
+
+static
+int stv0367_writeregs (struct stv0367_state *state, u16 reg, u8 *data, int len)
+{
+	u8 buf[len + 2];
+	struct i2c_msg msg = {
+		.addr = state->config->demod_address,
+		.flags = 0,
+		.buf = buf,
+		.len = len + 2
+	};
+	int ret;
+
+	buf[0] = MSB(reg);
+	buf[1] = LSB(reg);
+	memcpy(buf + 2, data, len);
+
+	if (i2cdebug) printk("%s: %02x: %02x\n", __func__, reg, buf[2]);
+
+	ret = i2c_transfer (state->i2c, &msg, 1);
+	if (ret != 1)
+		printk("%s: i2c write error!\n", __func__);
+
+	return (ret != 1) ? -EREMOTEIO : 0;
+}
+
+static int stv0367_writereg (struct stv0367_state *state, u16 reg, u8 data)
+{
+	return stv0367_writeregs (state, reg, &data, 1);
+}
+
+static u8 stv0367_readreg (struct stv0367_state *state, u16 reg)
+{
+	u8 b0[] = { 0, 0 };
+	u8 b1[] = { 0 };
+	struct i2c_msg msg [] = {
+		{
+			.addr = state->config->demod_address,
+			.flags = 0,
+			.buf = b0,
+			.len = 2
+		}, {
+			.addr = state->config->demod_address,
+			.flags = I2C_M_RD,
+			.buf = b1,
+			.len = 1
+		}
+	};
+	int ret;
+
+	b0[0] = MSB(reg);
+	b0[1] = LSB(reg);
+
+	ret = i2c_transfer(state->i2c, msg, 2);
+	if (ret != 2)
+		printk("%s: i2c read error\n", __func__);
+
+	if (i2cdebug) printk("%s: %02x: %02x\n", __func__, reg, b1[0]);
+
+	return b1[0];
+}
+
+static void extract_mask_pos(u32 label, u8 *mask, u8 *pos)
+{
+	u8 position = 0, i = 0;
+
+	(*mask) = label & 0xff;
+
+	while ((position == 0) && (i < 8)) {
+		position = ((*mask) >> i) & 0x01;
+		i++;
+	}
+
+	(*pos) = (i - 1);
+}
+
+static void stv0367_writebits(struct stv0367_state *state, u32 label, u8 val)
+{
+	u8 reg, mask, pos;
+
+	reg = stv0367_readreg(state, (label >> 16) & 0xffff);
+	extract_mask_pos(label, &mask, &pos);
+
+	val = mask & (val << pos);
+
+	reg = (reg & (~mask)) | val;
+	stv0367_writereg(state, (label >> 16) & 0xffff, reg);
+
+}
+
+static void stv0367_setbits(u8 *reg, u32 label, u8 val)
+{
+	u8 mask, pos;
+
+	extract_mask_pos(label, &mask, &pos);
+
+	val = mask & (val << pos);
+
+	(*reg) = ((*reg) & (~mask)) | val;
+}
+
+static u8 stv0367_readbits(struct stv0367_state *state, u32 label)
+{
+	u8 val = 0xff;
+	u8 mask, pos;
+
+	extract_mask_pos(label, &mask, &pos);
+
+	val = stv0367_readreg(state, label >> 16);
+	val = (val & mask) >> pos;
+
+	return val;
+}
+
+u8 stv0367_getbits(u8 reg, u32 label)
+{
+	u8 mask, pos;
+
+	extract_mask_pos(label, &mask, &pos);
+
+	return (reg & mask) >> pos;
+}
+
+static int stv0367ter_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	u8 tmp = stv0367_readreg(state, R367TER_I2CRPT);
+
+	dprintk("%s:\n", __func__);
+
+	if (enable) {
+		stv0367_setbits(&tmp, F367TER_STOP_ENABLE,0);
+		stv0367_setbits(&tmp, F367TER_I2CT_ON, 1);
+	} else {
+		stv0367_setbits(&tmp, F367TER_STOP_ENABLE,1);
+		stv0367_setbits(&tmp, F367TER_I2CT_ON, 0);
+	}
+
+	stv0367_writereg(state, R367TER_I2CRPT, tmp);
+
+	return 0;
+}
+
+static u32 stv0367_get_tuner_freq(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_ops	*frontend_ops = NULL;
+	struct dvb_tuner_ops	*tuner_ops = NULL;
+	u32 freq = 0;
+	int err = 0;
+
+	dprintk("%s:\n", __func__);
+
+
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->get_frequency) {
+		if ((err = tuner_ops->get_frequency(fe, &freq)) < 0) {
+			printk("%s: Invalid parameter\n", __func__);
+			return err;
+		}
+
+		printk("%s: frequency=%d\n", __func__, freq);
+
+	} else
+		return -1;
+
+	return freq;
+}
+
+static u16 CellsCoeffs_8MHz_367cofdm[3][6][5] = {
+	{
+		{0x10EF, 0xE205, 0x10EF, 0xCE49, 0x6DA7}, /* CELL 1 COEFFS 27M*/
+		{0x2151, 0xc557, 0x2151, 0xc705, 0x6f93}, /* CELL 2 COEFFS */
+		{0x2503, 0xc000, 0x2503, 0xc375, 0x7194}, /* CELL 3 COEFFS */
+		{0x20E9, 0xca94, 0x20e9, 0xc153, 0x7194}, /* CELL 4 COEFFS */
+		{0x06EF, 0xF852, 0x06EF, 0xC057, 0x7207}, /* CELL 5 COEFFS */
+		{0x0000, 0x0ECC, 0x0ECC, 0x0000, 0x3647} /* CELL 6 COEFFS */
+	}, {
+		{0x10A0, 0xE2AF, 0x10A1, 0xCE76, 0x6D6D}, /* CELL 1 COEFFS 25M*/
+		{0x20DC, 0xC676, 0x20D9, 0xC80A, 0x6F29},
+		{0x2532, 0xC000, 0x251D, 0xC391, 0x706F},
+		{0x1F7A, 0xCD2B, 0x2032, 0xC15E, 0x711F},
+		{0x0698, 0xFA5E, 0x0568, 0xC059, 0x7193},
+		{0x0000, 0x0918, 0x149C, 0x0000, 0x3642} /* CELL 6 COEFFS */
+	}, {
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000}, /* 30M */
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000}
+	}
+};
+
+static u16 CellsCoeffs_7MHz_367cofdm[3][6][5] = {
+	{
+		{0x12CA, 0xDDAF, 0x12CA, 0xCCEB, 0x6FB1}, /* CELL 1 COEFFS 27M*/
+		{0x2329, 0xC000, 0x2329, 0xC6B0, 0x725F}, /* CELL 2 COEFFS */
+		{0x2394, 0xC000, 0x2394, 0xC2C7, 0x7410}, /* CELL 3 COEFFS */
+		{0x251C, 0xC000, 0x251C, 0xC103, 0x74D9}, /* CELL 4 COEFFS */
+		{0x0804, 0xF546, 0x0804, 0xC040, 0x7544}, /* CELL 5 COEFFS */
+		{0x0000, 0x0CD9, 0x0CD9, 0x0000, 0x370A} /* CELL 6 COEFFS */
+	}, {
+		{0x1285, 0xDE47, 0x1285, 0xCD17, 0x6F76}, /*25M*/
+		{0x234C, 0xC000, 0x2348, 0xC6DA, 0x7206},
+		{0x23B4, 0xC000, 0x23AC, 0xC2DB, 0x73B3},
+		{0x253D, 0xC000, 0x25B6, 0xC10B, 0x747F},
+		{0x0721, 0xF79C, 0x065F, 0xC041, 0x74EB},
+		{0x0000, 0x08FA, 0x1162, 0x0000, 0x36FF}
+	}, {
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000}, /* 30M */
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000}
+	}
+};
+
+static u16 CellsCoeffs_6MHz_367cofdm[3][6][5] = {
+	{
+		{0x1699, 0xD5B8, 0x1699, 0xCBC3, 0x713B}, /* CELL 1 COEFFS 27M*/
+		{0x2245, 0xC000, 0x2245, 0xC568, 0x74D5}, /* CELL 2 COEFFS */
+		{0x227F, 0xC000, 0x227F, 0xC1FC, 0x76C6}, /* CELL 3 COEFFS */
+		{0x235E, 0xC000, 0x235E, 0xC0A7, 0x778A}, /* CELL 4 COEFFS */
+		{0x0ECB, 0xEA0B, 0x0ECB, 0xC027, 0x77DD}, /* CELL 5 COEFFS */
+		{0x0000, 0x0B68, 0x0B68, 0x0000, 0xC89A}, /* CELL 6 COEFFS */
+	}, {
+		{0x1655, 0xD64E, 0x1658, 0xCBEF, 0x70FE}, /*25M*/
+		{0x225E, 0xC000, 0x2256, 0xC589, 0x7489},
+		{0x2293, 0xC000, 0x2295, 0xC209, 0x767E},
+		{0x2377, 0xC000, 0x23AA, 0xC0AB, 0x7746},
+		{0x0DC7, 0xEBC8, 0x0D07, 0xC027, 0x7799},
+		{0x0000, 0x0888, 0x0E9C, 0x0000, 0x3757}
+
+	}, {
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000}, /* 30M */
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000},
+		{0x0000, 0x0000, 0x0000, 0x0000, 0x0000}
+	}
+};
+
+static u32 stv0367ter_get_mclk(struct stv0367_state *state, u32 ExtClk_Hz)
+{
+	u32 mclk_Hz = 0; /* master clock frequency (Hz) */
+	u32 m, n, p;
+
+	dprintk("%s:\n", __func__);
+
+	if (stv0367_readbits(state, F367TER_BYPASS_PLLXN) == 0) {
+		n = (u32)stv0367_readbits(state, F367TER_PLL_NDIV);
+		if (n == 0)
+			n = n + 1;
+
+		m = (u32)stv0367_readbits(state, F367TER_PLL_MDIV);
+		if (m == 0)
+			m = m + 1;
+
+		p = (u32)stv0367_readbits(state, F367TER_PLL_PDIV);
+		if (p > 5)
+			p = 5;
+
+		mclk_Hz = ((ExtClk_Hz / 2) * n) / (m * (1 << p));
+
+		printk("N=%d M=%d P=%d mclk_Hz=%d ExtClk_Hz=%d\n",
+				n, m, p, mclk_Hz, ExtClk_Hz);
+	} else
+		mclk_Hz = ExtClk_Hz;
+
+	printk("%s: mclk_Hz=%d\n", __func__, mclk_Hz);
+
+	return mclk_Hz;
+}
+
+static int stv0367ter_filt_coeff_init(struct stv0367_state *state,
+				u16 CellsCoeffs[2][6][5], u32 DemodXtal)
+{
+	int i, j, k, freq;
+
+	dprintk("%s:\n", __func__);
+
+	freq = stv0367ter_get_mclk(state, DemodXtal);
+
+	if (freq == 53125000)
+		k = 1; /* equivalent to Xtal 25M on 362*/
+	else if (freq == 54000000)
+		k = 0; /* equivalent to Xtal 27M on 362*/
+	else if (freq == 52500000)
+		k = 2; /* equivalent to Xtal 30M on 362*/
+	else
+		return 0;
+
+	for (i = 1; i <= 6; i++) {
+		stv0367_writebits(state, F367TER_IIR_CELL_NB, i - 1);
+
+		for (j = 1; j <= 5; j++) {
+			stv0367_writereg(state,
+				(R367TER_IIRCX_COEFF1_MSB + 2 * (j - 1)),
+				MSB(CellsCoeffs[k][i-1][j-1]));
+			stv0367_writereg(state,
+				(R367TER_IIRCX_COEFF1_LSB + 2 * (j - 1)),
+				LSB(CellsCoeffs[k][i-1][j-1]));
+		}
+	}
+
+	return 1;
+
+}
+
+static void stv0367ter_agc_iir_lock_detect_set(struct stv0367_state *state)
+{
+	dprintk("%s:\n", __func__);
+
+	stv0367_writebits(state, F367TER_LOCK_DETECT_LSB, 0x00);
+
+	/* Lock detect 1 */
+	stv0367_writebits(state, F367TER_LOCK_DETECT_CHOICE, 0x00);
+	stv0367_writebits(state, F367TER_LOCK_DETECT_MSB, 0x06);
+	stv0367_writebits(state, F367TER_AUT_AGC_TARGET_LSB, 0x04);
+
+	/* Lock detect 2 */
+	stv0367_writebits(state, F367TER_LOCK_DETECT_CHOICE, 0x01);
+	stv0367_writebits(state, F367TER_LOCK_DETECT_MSB, 0x06);
+	stv0367_writebits(state, F367TER_AUT_AGC_TARGET_LSB, 0x04);
+
+	/* Lock detect 3 */
+	stv0367_writebits(state, F367TER_LOCK_DETECT_CHOICE, 0x02);
+	stv0367_writebits(state, F367TER_LOCK_DETECT_MSB, 0x01);
+	stv0367_writebits(state, F367TER_AUT_AGC_TARGET_LSB, 0x00);
+
+	/* Lock detect 4 */
+	stv0367_writebits(state, F367TER_LOCK_DETECT_CHOICE, 0x03);
+	stv0367_writebits(state, F367TER_LOCK_DETECT_MSB, 0x01);
+	stv0367_writebits(state, F367TER_AUT_AGC_TARGET_LSB, 0x00);
+
+}
+
+static int stv0367_iir_filt_init(struct stv0367_state *state, u8 Bandwidth,
+							u32 DemodXtalValue)
+{
+	dprintk("%s:\n", __func__);
+
+	stv0367_writebits(state, F367TER_NRST_IIR, 0);
+
+	switch (Bandwidth) {
+	case 6:
+		if (!stv0367ter_filt_coeff_init(state,
+				CellsCoeffs_6MHz_367cofdm,
+				DemodXtalValue))
+			return 0;
+		break;
+	case 7:
+		if (!stv0367ter_filt_coeff_init(state,
+				CellsCoeffs_7MHz_367cofdm,
+				DemodXtalValue))
+			return 0;
+		break;
+	case 8:
+		if (!stv0367ter_filt_coeff_init(state,
+				CellsCoeffs_8MHz_367cofdm,
+				DemodXtalValue))
+			return 0;
+		break;
+	default:
+		return 0;
+	}
+
+	stv0367_writebits(state, F367TER_NRST_IIR, 1);
+
+	return 1;
+}
+
+static void stv0367ter_agc_iir_rst(struct stv0367_state *state)
+{
+
+	u8 com_n;
+
+	dprintk("%s:\n", __func__);
+
+	com_n = stv0367_readbits(state, F367TER_COM_N);
+
+	stv0367_writebits(state, F367TER_COM_N, 0x07);
+
+	stv0367_writebits(state, F367TER_COM_SOFT_RSTN, 0x00);
+	stv0367_writebits(state, F367TER_COM_AGC_ON, 0x00);
+
+	stv0367_writebits(state, F367TER_COM_SOFT_RSTN, 0x01);
+	stv0367_writebits(state, F367TER_COM_AGC_ON, 0x01);
+
+	stv0367_writebits(state, F367TER_COM_N, com_n);
+
+}
+
+static int stv0367ter_duration(s32 mode, int tempo1, int tempo2, int tempo3)
+{
+	int local_tempo = 0;
+	switch (mode) {
+	case 0:
+		local_tempo = tempo1;
+		break;
+	case 1:
+		local_tempo = tempo2;
+		break ;
+
+	case 2:
+		local_tempo = tempo3;
+		break;
+
+	default:
+		break;
+	}
+	/*	msleep(local_tempo);  */
+	return local_tempo;
+}
+
+static
+fe_stv0367_ter_signal_type_t stv0367ter_check_syr(struct stv0367_state *state)
+{
+	int wd = 100;
+	unsigned short int SYR_var;
+	s32 SYRStatus;
+
+	dprintk("%s:\n", __func__);
+
+	SYR_var = stv0367_readbits(state, F367TER_SYR_LOCK);
+
+	while ((!SYR_var) && (wd > 0)) {
+		msleep(2);
+		wd -= 2;
+		SYR_var = stv0367_readbits(state, F367TER_SYR_LOCK);
+	}
+
+	if (!SYR_var)
+		SYRStatus = FE_TER_NOSYMBOL;
+	else
+		SYRStatus =  FE_TER_SYMBOLOK;
+
+	dprintk("stv0367ter_check_syr SYRStatus %s\n",
+				SYR_var == 0 ? "No Symbol" : "OK");
+
+	return SYRStatus;
+}
+
+static
+fe_stv0367_ter_signal_type_t stv0367ter_check_cpamp(struct stv0367_state *state,
+								s32 FFTmode)
+{
+
+	s32  CPAMPvalue = 0, CPAMPStatus, CPAMPMin;
+	int wd = 0;
+
+	dprintk("%s:\n", __func__);
+
+	switch (FFTmode) {
+	case 0: /*2k mode*/
+		CPAMPMin = 20;
+		wd = 10;
+		break;
+	case 1: /*8k mode*/
+		CPAMPMin = 80;
+		wd = 55;
+		break;
+	case 2: /*4k mode*/
+		CPAMPMin = 40;
+		wd = 30;
+		break;
+	default:
+		CPAMPMin = 0xffff;  /*drives to NOCPAMP	*/
+		break;
+	}
+
+	dprintk("%s: CPAMPMin=%d wd=%d\n", __func__, CPAMPMin, wd);
+
+	CPAMPvalue = stv0367_readbits(state, F367TER_PPM_CPAMP_DIRECT);
+	while ((CPAMPvalue < CPAMPMin) && (wd > 0)) {
+		msleep(1);
+		wd -= 1;
+		CPAMPvalue = stv0367_readbits(state, F367TER_PPM_CPAMP_DIRECT);
+		/*printk("CPAMPvalue= %d at wd=%d\n",CPAMPvalue,wd); */
+	}
+	printk("******last CPAMPvalue= %d at wd=%d\n", CPAMPvalue, wd);
+	if (CPAMPvalue < CPAMPMin) {
+		CPAMPStatus = FE_TER_NOCPAMP;
+		printk("CPAMP failed\n");
+	} else {
+		printk("CPAMP OK !\n");
+		CPAMPStatus = FE_TER_CPAMPOK;
+	}
+
+	return CPAMPStatus;
+}
+
+fe_stv0367_ter_signal_type_t stv0367ter_lock_algo(struct stv0367_state *state)
+{
+	fe_stv0367_ter_signal_type_t ret_flag;
+	short int wd, tempo;
+	u8 try, u_var1 = 0, u_var2 = 0, u_var3 = 0, u_var4 = 0, mode, guard;
+	u8 tmp, tmp2;
+
+	dprintk("%s:\n", __func__);
+
+	if (state == NULL)
+		return FE_TER_SWNOK;
+
+	try = 0;
+	do {
+		ret_flag = FE_TER_LOCKOK;
+
+		stv0367_writebits(state, F367TER_CORE_ACTIVE, 0);
+
+		if (state->config->if_iq_mode != 0)
+			stv0367_writebits(state, F367TER_COM_N, 0x07);
+
+		stv0367_writebits(state, F367TER_GUARD, 3); /* suggest 2k 1/4 */
+		stv0367_writebits(state, F367TER_MODE, 0);
+		stv0367_writebits(state, F367TER_SYR_TR_DIS, 0);
+		msleep(5);
+
+
+		stv0367_writebits(state, F367TER_CORE_ACTIVE, 1);
+
+
+		if (stv0367ter_check_syr(state) == FE_TER_NOSYMBOL)
+			return FE_TER_NOSYMBOL;
+		else { /*
+			if chip locked on wrong mode first try,
+			it must lock correctly second try */
+			mode = stv0367_readbits(state, F367TER_SYR_MODE);
+			if (stv0367ter_check_cpamp(state, mode) == FE_TER_NOCPAMP) {
+				if (try == 0)
+					ret_flag = FE_TER_NOCPAMP;
+
+			}
+		}
+
+		try++;
+	} while ((try < 10) && (ret_flag != FE_TER_LOCKOK));
+
+	tmp  = stv0367_readreg(state, R367TER_SYR_STAT);
+	tmp2 = stv0367_readreg(state, R367TER_STATUS);
+	printk("state=0x%x\n", (int)state);
+	printk("LOCK OK! mode=%d SYR_STAT=0x%x R367TER_STATUS=0x%x\n",
+							mode, tmp, tmp2);
+
+	tmp  = stv0367_readreg(state, R367TER_PRVIT);
+	tmp2 = stv0367_readreg(state, R367TER_I2CRPT);
+	printk("PRVIT=0x%x I2CRPT=0x%x\n", tmp, tmp2);
+
+	tmp  = stv0367_readreg(state, R367TER_GAIN_SRC1);
+	printk("GAIN_SRC1=0x%x\n", tmp);
+
+	if ((mode != 0) && (mode != 1) && (mode != 2)) {
+		return FE_TER_SWNOK;
+	}
+	/*guard=stv0367_readbits(state,F367TER_SYR_GUARD); */
+
+	/*supress EPQ auto for SYR_GARD 1/16 or 1/32
+	and set channel predictor in automatic */
+#if 0
+	switch (guard) {
+
+	case 0:
+	case 1:
+		stv0367_writebits(state, F367TER_AUTO_LE_EN, 0);
+		stv0367_writereg(state, R367TER_CHC_CTL, 0x01);
+		break;
+	case 2:
+	case 3:
+		stv0367_writebits(state, F367TER_AUTO_LE_EN, 1);
+		stv0367_writereg(state, R367TER_CHC_CTL, 0x11);
+		break;
+
+	default:
+		return FE_TER_SWNOK;
+	}
+#endif
+
+	/*reset fec an reedsolo FOR 367 only*/
+	stv0367_writebits(state, F367TER_RST_SFEC, 1);
+	stv0367_writebits(state, F367TER_RST_REEDSOLO, 1);
+	msleep(1);
+	stv0367_writebits(state, F367TER_RST_SFEC, 0);
+	stv0367_writebits(state, F367TER_RST_REEDSOLO, 0);
+
+	u_var1 = stv0367_readbits(state, F367TER_LK);
+	u_var2 = stv0367_readbits(state, F367TER_PRF);
+	u_var3 = stv0367_readbits(state, F367TER_TPS_LOCK);
+	/*	u_var4=stv0367_readbits(state,F367TER_TSFIFO_LINEOK); */
+
+	wd = stv0367ter_duration(mode, 125, 500, 250);
+	tempo = stv0367ter_duration(mode, 4, 16, 8);
+
+	/*while ( ((!u_var1)||(!u_var2)||(!u_var3)||(!u_var4))  && (wd>=0)) */
+	while (((!u_var1) || (!u_var2) || (!u_var3)) && (wd >= 0)) {
+		msleep(tempo);
+		wd -= tempo;
+		u_var1 = stv0367_readbits(state, F367TER_LK);
+		u_var2 = stv0367_readbits(state, F367TER_PRF);
+		u_var3 = stv0367_readbits(state, F367TER_TPS_LOCK);
+		/*u_var4=stv0367_readbits(state, F367TER_TSFIFO_LINEOK); */
+	}
+
+	if (!u_var1)
+		return FE_TER_NOLOCK;
+
+
+	if (!u_var2)
+		return FE_TER_NOPRFOUND;
+
+	if (!u_var3)
+		return FE_TER_NOTPS;
+
+	guard = stv0367_readbits(state, F367TER_SYR_GUARD);
+	stv0367_writereg(state, R367TER_CHC_CTL, 0x11);
+	switch (guard) {
+	case 0:
+	case 1:
+		stv0367_writebits(state, F367TER_AUTO_LE_EN, 0);
+		/*stv0367_writereg(state,R367TER_CHC_CTL, 0x1);*/
+		stv0367_writebits(state, F367TER_SYR_FILTER, 0);
+		break;
+	case 2:
+	case 3:
+		stv0367_writebits(state, F367TER_AUTO_LE_EN, 1);
+		/*stv0367_writereg(state,R367TER_CHC_CTL, 0x11);*/
+		stv0367_writebits(state, F367TER_SYR_FILTER, 1);
+		break;
+
+	default:
+		return FE_TER_SWNOK;
+	}
+
+	/* apply Sfec workaround if 8K 64QAM CR!=1/2*/
+	if ((stv0367_readbits(state, F367TER_TPS_CONST) == 2) &&
+			(mode == 1) &&
+			(stv0367_readbits(state, F367TER_TPS_HPCODE) != 0)) {
+		stv0367_writereg(state, R367TER_SFDLYSETH, 0xc0);
+		stv0367_writereg(state, R367TER_SFDLYSETM, 0x60);
+		stv0367_writereg(state, R367TER_SFDLYSETL, 0x0);
+	} else
+		stv0367_writereg(state, R367TER_SFDLYSETH, 0x0);
+
+	wd = stv0367ter_duration(mode, 125, 500, 250);
+	u_var4 = stv0367_readbits(state, F367TER_TSFIFO_LINEOK);
+
+	while ((!u_var4) && (wd >= 0)) {
+		msleep(tempo);
+		wd -= tempo;
+		u_var4 = stv0367_readbits(state, F367TER_TSFIFO_LINEOK);
+	}
+
+	if (!u_var4)
+		return FE_TER_NOLOCK;
+
+	/* for 367 leave COM_N at 0x7 for IQ_mode*/
+	/*if(ter_state->if_iq_mode!=FE_TER_NORMAL_IF_TUNER) {
+		tempo=0;
+		while ((stv0367_readbits(state,F367TER_COM_USEGAINTRK)!=1) &&
+		(stv0367_readbits(state,F367TER_COM_AGCLOCK)!=1)&&(tempo<100)) {
+			ChipWaitOrAbort(state,1);
+			tempo+=1;
+		}
+
+		stv0367_writebits(state,F367TER_COM_N,0x17);
+	} */
+
+	stv0367_writebits(state, F367TER_SYR_TR_DIS, 1);
+
+	printk("FE_TER_LOCKOK !!!\n");
+
+	return	FE_TER_LOCKOK;
+
+}
+
+static void stv0367ter_set_ts_mode(struct stv0367_state *state,
+					stv0367_ts_mode_t PathTS)
+{
+
+	dprintk("%s:\n", __func__);
+
+	if (state == NULL)
+		return;
+
+	stv0367_writebits(state, F367TER_TS_DIS, 0);
+	switch (PathTS) {
+	default:
+		/*for removing warning :default we can assume in parallel mode*/
+	case STV0367_PARALLEL_PUNCT_CLOCK:
+		stv0367_writebits(state, F367TER_TSFIFO_SERIAL, 0);
+		stv0367_writebits(state, F367TER_TSFIFO_DVBCI, 0);
+		break;
+	case STV0367_SERIAL_PUNCT_CLOCK:
+		stv0367_writebits(state, F367TER_TSFIFO_SERIAL, 1);
+		stv0367_writebits(state, F367TER_TSFIFO_DVBCI, 1);
+		break;
+	}
+}
+
+static void stv0367ter_set_clk_pol(struct stv0367_state *state,
+					stv0367_clk_pol_t clock)
+{
+
+	dprintk("%s:\n", __func__);
+
+	if (state == NULL)
+		return;
+
+	switch (clock) {
+	case STV0367_RISINGEDGE_CLOCK:
+		stv0367_writebits(state, F367TER_TS_BYTE_CLK_INV, 1);
+		break;
+	case STV0367_FALLINGEDGE_CLOCK:
+		stv0367_writebits(state, F367TER_TS_BYTE_CLK_INV, 0);
+		break;
+		/*case FE_TER_CLOCK_POLARITY_DEFAULT:*/
+	default:
+		stv0367_writebits(state, F367TER_TS_BYTE_CLK_INV, 0);
+		break;
+	}
+}
+
+#if 0
+static void stv0367ter_core_sw(struct stv0367_state *state) {
+
+	dprintk("%s:\n", __func__);
+
+	stv0367_writebits(state, F367TER_CORE_ACTIVE, 0);
+	stv0367_writebits(state, F367TER_CORE_ACTIVE, 1);
+	msleep(350);
+}
+#endif
+static int stv0367ter_standby(struct dvb_frontend * fe, u8 StandbyOn)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	dprintk("%s:\n", __func__);
+
+	if (StandbyOn) {
+		stv0367_writebits(state, F367TER_STDBY, 1);
+		stv0367_writebits(state, F367TER_STDBY_FEC, 1);
+		stv0367_writebits(state, F367TER_STDBY_CORE, 1);
+	} else {
+		stv0367_writebits(state, F367TER_STDBY, 0);
+		stv0367_writebits(state, F367TER_STDBY_FEC, 0);
+		stv0367_writebits(state, F367TER_STDBY_CORE, 0);
+	}
+
+	return 0;
+}
+
+static int stv0367ter_sleep(struct dvb_frontend *fe)
+{
+	return stv0367ter_standby(fe, 1);
+}
+
+int stv0367ter_init(struct dvb_frontend *fe)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367ter_state *ter_state = state->ter_state;
+	int i;
+
+	dprintk("%s:\n", __func__);
+
+	ter_state->pBER = 0;
+
+	for (i = 0; i < STV0367TER_NBREGS; i++)
+		stv0367_writereg(state, def0367ter[i].addr, def0367ter[i].value);
+
+	switch (state->config->xtal) {
+		/*set internal freq to 53.125MHz */
+	case 25000000:
+		stv0367_writereg(state, R367TER_PLLMDIV, 0xa);
+		stv0367_writereg(state, R367TER_PLLNDIV, 0x55);
+		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
+		break;
+	default:
+	case 27000000:
+		printk("FE_STV0367TER_SetCLKgen for 27Mhz\n");
+		stv0367_writereg(state, R367TER_PLLMDIV, 0x1);
+		stv0367_writereg(state, R367TER_PLLNDIV, 0x8);
+		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
+		break;
+	case 30000000:
+		stv0367_writereg(state, R367TER_PLLMDIV, 0xc);
+		stv0367_writereg(state, R367TER_PLLNDIV, 0x55);
+		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
+		break;
+	}
+
+	stv0367_writereg(state, R367TER_I2CRPT, 0xa0);
+	stv0367_writereg(state, R367TER_ANACTRL, 0x00);
+
+	/*Set TS1 and TS2 to serial or parallel mode */
+	stv0367ter_set_ts_mode(state, state->config->ts_mode);
+	stv0367ter_set_clk_pol(state, state->config->clk_pol);
+
+	state->chip_id = stv0367_readreg(state, R367TER_ID);
+	ter_state->first_lock = 0;
+	ter_state->unlock_counter = 2;
+
+	return 0;
+}
+
+static int stv0367ter_algo(struct dvb_frontend *fe,
+				struct dvb_frontend_parameters *param)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367ter_state *ter_state = state->ter_state;
+	int offset = 0, tempo = 0;
+	u8 u_var;
+	u8 /*constell,*/ counter, tps_rcvd[2];
+	s8 step;
+	s32 timing_offset = 0;
+	u32 trl_nomrate = 0, InternalFreq = 0, temp = 0;
+
+	dprintk("%s:\n", __func__);
+
+	ter_state->frequency = param->frequency;
+	ter_state->force = FE_TER_FORCENONE
+			+ stv0367_readbits(state, F367TER_FORCE) * 2;
+	ter_state->if_iq_mode = state->config->if_iq_mode;
+	switch (state->config->if_iq_mode) {
+	case FE_TER_NORMAL_IF_TUNER:  /* Normal IF mode */
+		printk("ALGO: FE_TER_NORMAL_IF_TUNER selected\n");
+		stv0367_writebits(state, F367TER_TUNER_BB, 0);
+		stv0367_writebits(state, F367TER_LONGPATH_IF, 0);
+		stv0367_writebits(state, F367TER_DEMUX_SWAP, 0);
+		break;
+	case FE_TER_LONGPATH_IF_TUNER:  /* Long IF mode */
+		printk("ALGO: FE_TER_LONGPATH_IF_TUNER selected\n");
+		stv0367_writebits(state, F367TER_TUNER_BB, 0);
+		stv0367_writebits(state, F367TER_LONGPATH_IF, 1);
+		stv0367_writebits(state, F367TER_DEMUX_SWAP, 1);
+		break;
+	case FE_TER_IQ_TUNER:  /* IQ mode */
+		printk("ALGO: FE_TER_IQ_TUNER selected\n");
+		stv0367_writebits(state, F367TER_TUNER_BB, 1);
+		stv0367_writebits(state, F367TER_PPM_INVSEL, 0);
+		break;
+	default:
+		printk("ALGO: wrong TUNER type selected\n");
+		return -EINVAL;
+	}
+
+	msleep(5);
+
+	switch (param->inversion) {
+	case INVERSION_AUTO:
+	default:
+		printk("%s: inversion AUTO\n", __func__);
+		if (ter_state->if_iq_mode == FE_TER_IQ_TUNER)
+			stv0367_writebits(state, F367TER_IQ_INVERT,
+						ter_state->sense);
+		else
+			stv0367_writebits(state, F367TER_INV_SPECTR,
+						ter_state->sense);
+
+		break;
+	case INVERSION_ON:
+	case INVERSION_OFF:
+		if (ter_state->if_iq_mode == FE_TER_IQ_TUNER)
+			stv0367_writebits(state, F367TER_IQ_INVERT,
+						param->inversion);
+		else
+			stv0367_writebits(state, F367TER_INV_SPECTR,
+						param->inversion);
+
+		break;
+	}
+
+	if ((ter_state->if_iq_mode != FE_TER_NORMAL_IF_TUNER) &&
+				(ter_state->pBW != ter_state->bw)) {
+		stv0367ter_agc_iir_lock_detect_set(state);
+
+		/*set fine agc target to 180 for LPIF or IQ mode*/
+		/* set Q_AGCTarget */
+		stv0367_writebits(state, F367TER_SEL_IQNTAR, 1);
+		stv0367_writebits(state, F367TER_AUT_AGC_TARGET_MSB, 0xB);
+		/*stv0367_writebits(state,AUT_AGC_TARGET_LSB,0x04); */
+
+		/* set Q_AGCTarget */
+		stv0367_writebits(state, F367TER_SEL_IQNTAR, 0);
+		stv0367_writebits(state, F367TER_AUT_AGC_TARGET_MSB, 0xB);
+		/*stv0367_writebits(state,AUT_AGC_TARGET_LSB,0x04); */
+
+		if (!stv0367_iir_filt_init(state, ter_state->bw,
+						state->config->xtal))
+			return -EINVAL;
+		/*set IIR filter once for 6,7 or 8MHz BW*/
+		ter_state->pBW = ter_state->bw;
+
+		stv0367ter_agc_iir_rst(state);
+	}
+
+	if (ter_state->hierarchy == FE_TER_HIER_LOW_PRIO)
+		stv0367_writebits(state, F367TER_BDI_LPSEL, 0x01);
+	else
+		stv0367_writebits(state, F367TER_BDI_LPSEL, 0x00);
+
+	InternalFreq = stv0367ter_get_mclk(state, state->config->xtal) / 1000;
+	temp = (int)
+		((((ter_state->bw * 64 * (1 << 15) * 100)
+						/ (InternalFreq)) * 10) / 7);
+
+	stv0367_writebits(state, F367TER_TRL_NOMRATE_LSB, temp % 2);
+	temp = temp / 2;
+	stv0367_writebits(state, F367TER_TRL_NOMRATE_HI, temp / 256);
+	stv0367_writebits(state, F367TER_TRL_NOMRATE_LO, temp % 256);
+
+	temp = stv0367_readbits(state, F367TER_TRL_NOMRATE_HI) * 512 +
+			stv0367_readbits(state, F367TER_TRL_NOMRATE_LO) * 2 +
+			stv0367_readbits(state, F367TER_TRL_NOMRATE_LSB);
+	temp = (int)(((1 << 17) * ter_state->bw * 1000) / (7 * (InternalFreq)));
+	stv0367_writebits(state, F367TER_GAIN_SRC_HI, temp / 256);
+	stv0367_writebits(state, F367TER_GAIN_SRC_LO, temp % 256);
+	temp = stv0367_readbits(state, F367TER_GAIN_SRC_HI) * 256 +
+			stv0367_readbits(state, F367TER_GAIN_SRC_LO);
+
+	temp = (int)
+		((InternalFreq - state->config->if_khz) * (1 << 16)
+							/ (InternalFreq));
+
+	printk("DEROT temp=0x%x\n", temp);
+	stv0367_writebits(state, F367TER_INC_DEROT_HI, temp / 256);
+	stv0367_writebits(state, F367TER_INC_DEROT_LO, temp % 256);
+
+	ter_state->echo_pos = 0;
+	ter_state->ucblocks = 0; /* liplianin */
+	ter_state->pBER = 0; /* liplianin */
+	stv0367_writebits(state, F367TER_LONG_ECHO, ter_state->echo_pos);
+
+	if (stv0367ter_lock_algo(state) != FE_TER_LOCKOK)
+		return 0;
+
+	ter_state->state = FE_TER_LOCKOK;
+	/* update results */
+	tps_rcvd[0] = stv0367_readreg(state, R367TER_TPS_RCVD2);
+	tps_rcvd[1] = stv0367_readreg(state, R367TER_TPS_RCVD3);
+
+	ter_state->mode = stv0367_readbits(state, F367TER_SYR_MODE);
+	ter_state->guard = stv0367_readbits(state, F367TER_SYR_GUARD);
+
+	ter_state->first_lock = 1; /* we know sense now :) */
+
+	ter_state->agc_val = (stv0367_readbits(state, F367TER_AGC1_VAL_LO) << 16) +
+		(stv0367_readbits(state, F367TER_AGC1_VAL_HI) << 24) +
+		stv0367_readbits(state, F367TER_AGC2_VAL_LO) +
+		(stv0367_readbits(state, F367TER_AGC2_VAL_HI) << 8);
+
+	/* Carrier offset calculation */
+	stv0367_writebits(state, F367TER_FREEZE, 1);
+	offset = (stv0367_readbits(state, F367TER_CRL_FOFFSET_VHI) << 16) ;
+	offset += (stv0367_readbits(state, F367TER_CRL_FOFFSET_HI) << 8);
+	offset += (stv0367_readbits(state, F367TER_CRL_FOFFSET_LO));
+	stv0367_writebits(state, F367TER_FREEZE, 0);
+	if (offset > 8388607)
+		offset -= 16777216;
+
+	offset = offset * 2 / 16384;
+
+	if (ter_state->mode == FE_TER_MODE_2K)
+		offset = (offset * 4464) / 1000;/*** 1 FFT BIN=4.464khz***/
+	else if (ter_state->mode == FE_TER_MODE_4K)
+		offset = (offset * 223) / 100;/*** 1 FFT BIN=2.23khz***/
+	else  if (ter_state->mode == FE_TER_MODE_8K)
+		offset = (offset * 111) / 100;/*** 1 FFT BIN=1.1khz***/
+
+	if (stv0367_readbits(state, F367TER_PPM_INVSEL) == 1) {
+		if ((stv0367_readbits(state, F367TER_INV_SPECTR) ==
+				(stv0367_readbits(state, F367TER_STATUS_INV_SPECRUM) == 1)))
+			offset = offset * -1;
+	}
+
+	if (ter_state->bw == 6)
+		offset = (offset * 6) / 8;
+	else if (ter_state->bw == 7)
+		offset = (offset * 7) / 8;
+
+	ter_state->frequency += offset;
+
+	tempo = 10;  /* exit even if timing_offset stays null */
+	while ((timing_offset == 0) && (tempo > 0)) {
+		msleep(10);	/*was 20ms  */
+		/* fine tuning of timing offset if required */
+		timing_offset = stv0367_readbits(state, F367TER_TRL_TOFFSET_LO)
+				+ 256 * stv0367_readbits(state, F367TER_TRL_TOFFSET_HI);
+		if (timing_offset >= 32768) timing_offset -= 65536;
+		trl_nomrate = (512 * stv0367_readbits(state, F367TER_TRL_NOMRATE_HI)
+			+ stv0367_readbits(state, F367TER_TRL_NOMRATE_LO) * 2
+			+ stv0367_readbits(state, F367TER_TRL_NOMRATE_LSB));
+
+		timing_offset = ((signed)(1000000 / trl_nomrate) * timing_offset) / 2048;
+		tempo--;
+	}
+
+	if (timing_offset <= 0) {
+		timing_offset = (timing_offset - 11) / 22;
+		step = -1;
+	} else {
+		timing_offset = (timing_offset + 11) / 22;
+		step = 1;
+	}
+
+	for (counter = 0;counter < abs(timing_offset);counter++) {
+		trl_nomrate += step;
+		stv0367_writebits(state, F367TER_TRL_NOMRATE_LSB,
+						trl_nomrate % 2);
+		stv0367_writebits(state, F367TER_TRL_NOMRATE_LO,
+						trl_nomrate / 2);
+		msleep(1);
+	}
+
+	msleep(5);
+	/* unlocks could happen in case of trl centring big step,
+	then a core off/on restarts demod */
+	u_var = stv0367_readbits(state, F367TER_LK);
+
+	if (!u_var) {
+		stv0367_writebits(state, F367TER_CORE_ACTIVE, 0);
+		msleep(20);
+		stv0367_writebits(state, F367TER_CORE_ACTIVE, 1);
+	}
+
+	return 0;
+}
+
+static int stv0367ter_set_frontend(struct dvb_frontend *fe,
+				struct dvb_frontend_parameters *param)
+{
+	struct dvb_ofdm_parameters *op = &param->u.ofdm;
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367ter_state *ter_state = state->ter_state;
+
+	/*u8 trials[2]; */
+	s8 num_trials, index;
+	u8 SenseTrials[] = { INVERSION_ON, INVERSION_OFF };
+
+	stv0367ter_init(fe);
+
+	if (fe->ops.tuner_ops.set_params) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+		fe->ops.tuner_ops.set_params(fe, param);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+	}
+
+	switch (op->transmission_mode) {
+	default:
+	case TRANSMISSION_MODE_AUTO:
+	case TRANSMISSION_MODE_2K:
+		ter_state->mode = FE_TER_MODE_2K;
+		break;
+/*	case TRANSMISSION_MODE_4K:
+		pLook.mode = FE_TER_MODE_4K;
+		break;*/
+	case TRANSMISSION_MODE_8K:
+		ter_state->mode = FE_TER_MODE_8K;
+		break;
+	}
+
+	switch (op->guard_interval) {
+	default:
+	case GUARD_INTERVAL_1_32:
+	case GUARD_INTERVAL_1_16:
+	case GUARD_INTERVAL_1_8:
+	case GUARD_INTERVAL_1_4:
+		ter_state->guard = op->guard_interval;
+		break;
+	case GUARD_INTERVAL_AUTO:
+		ter_state->guard = GUARD_INTERVAL_1_32;
+		break;
+	}
+
+	switch (op->bandwidth) {
+	case BANDWIDTH_6_MHZ:
+		ter_state->bw = FE_TER_CHAN_BW_6M;
+		break;
+	case BANDWIDTH_7_MHZ:
+		ter_state->bw = FE_TER_CHAN_BW_7M;
+		break;
+	case BANDWIDTH_8_MHZ:
+	default:
+		ter_state->bw = FE_TER_CHAN_BW_8M;
+	}
+
+	ter_state->hierarchy = FE_TER_HIER_NONE;
+
+	switch (param->inversion) {
+	case INVERSION_OFF:
+	case INVERSION_ON:
+		num_trials = 1;
+		break;
+	default:
+		num_trials = 2;
+		if (ter_state->first_lock)
+			num_trials = 1;
+		break;
+	}
+
+	ter_state->state = FE_TER_NOLOCK;
+	index = 0;
+
+	while (((index) < num_trials) && (ter_state->state != FE_TER_LOCKOK)) {
+		if (!ter_state->first_lock) {
+			if (param->inversion == INVERSION_AUTO)
+				ter_state->sense = SenseTrials[index];
+
+		}
+		stv0367ter_algo(fe,/* &pLook, result,*/ param);
+
+		if ((ter_state->state == FE_TER_LOCKOK) &&
+				(param->inversion == INVERSION_AUTO) && (index == 1)) {
+			SenseTrials[index] = SenseTrials[0];/* invert spectrum sense */
+			SenseTrials[(index + 1) % 2] = (SenseTrials[1] + 1) % 2;
+		}
+
+		index++;
+	}
+
+	return 0;
+}
+
+static int stv0367ter_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367ter_state *ter_state = state->ter_state;
+	u32 errs = 0;
+
+	/*wait for counting completion*/
+	if (stv0367_readbits(state, F367TER_SFERRC_OLDVALUE) == 0) {
+		errs =
+			((u32)stv0367_readbits(state, F367TER_ERR_CNT1)
+			* (1 << 16))
+			+ ((u32)stv0367_readbits(state, F367TER_ERR_CNT1_HI)
+			* (1 << 8))
+			+ ((u32)stv0367_readbits(state, F367TER_ERR_CNT1_LO));
+		ter_state->ucblocks = errs;
+	}
+
+	(*ucblocks) = ter_state->ucblocks;
+
+	return 0;
+}
+
+static int stv0367ter_get_frontend(struct dvb_frontend *fe,
+				  struct dvb_frontend_parameters *param)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367ter_state *ter_state = state->ter_state;
+	struct dvb_ofdm_parameters *op = &param->u.ofdm;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	int error = 0;
+	fe_stv0367_ter_mode_t mode;
+
+	int constell = 0,/* snr = 0,*/ Data = 0;
+	if ((param->frequency = stv0367_get_tuner_freq(fe)) < 0)
+		param->frequency = c->frequency;
+
+	constell = stv0367_readbits(state, F367TER_TPS_CONST);
+	if (constell == 0)
+		op->constellation = QPSK;
+	else if (constell == 1)
+		op->constellation = QAM_16;
+	else
+		op->constellation = QAM_64;
+
+	param->inversion = stv0367_readbits(state, F367TER_INV_SPECTR);
+
+	/* Get the Hierarchical mode */
+	Data = stv0367_readbits(state, F367TER_TPS_HIERMODE);
+
+	switch (Data) {
+	case 0 :
+		op->hierarchy_information = HIERARCHY_NONE;
+		break;
+	case 1 :
+		op->hierarchy_information = HIERARCHY_1;
+		break;
+	case 2 :
+		op->hierarchy_information = HIERARCHY_2;
+		break;
+	case 3 :
+		op->hierarchy_information = HIERARCHY_4;
+		break;
+	default :
+		op->hierarchy_information = HIERARCHY_AUTO;
+		break; /* error */
+	}
+
+	/* Get the FEC Rate */
+	if (ter_state->hierarchy == FE_TER_HIER_LOW_PRIO)
+		Data = stv0367_readbits(state, F367TER_TPS_LPCODE);
+	else
+		Data = stv0367_readbits(state, F367TER_TPS_HPCODE);
+
+	switch (Data) {
+	case 0:
+		op->code_rate_HP = FEC_1_2;
+		break;
+	case 1:
+		op->code_rate_HP = FEC_2_3;
+		break;
+	case 2:
+		op->code_rate_HP = FEC_3_4;
+		break;
+	case 3:
+		op->code_rate_HP = FEC_5_6;
+		break;
+	case 4:
+		op->code_rate_HP = FEC_7_8;
+		break;
+	default:
+		op->code_rate_HP = FEC_AUTO;
+		break; /* error */
+	}
+
+	mode = stv0367_readbits(state, F367TER_SYR_MODE);
+
+	switch (mode) {
+	case FE_TER_MODE_2K:
+		op->transmission_mode = TRANSMISSION_MODE_2K;
+		break;
+/*	case FE_TER_MODE_4K:
+		op->transmission_mode = TRANSMISSION_MODE_4K;
+		break;*/
+	case FE_TER_MODE_8K:
+		op->transmission_mode = TRANSMISSION_MODE_8K;
+		break;
+	default:
+		op->transmission_mode = TRANSMISSION_MODE_AUTO;
+	}
+
+	op->guard_interval = stv0367_readbits(state, F367TER_SYR_GUARD);
+
+	return error;
+}
+
+static int stv0367ter_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	u32 snru32 = 0;
+	int cpt = 0;
+	u8 cut = stv0367_readbits(state, F367TER_IDENTIFICATIONREG);
+
+	while (cpt < 10) {
+		msleep(2);
+		if (cut == 0x50) /*cut 1.0 cut 1.1*/
+			snru32 += stv0367_readbits(state, F367TER_CHCSNR) / 4;
+		else /*cu2.0*/
+			snru32 += 125 * stv0367_readbits(state, F367TER_CHCSNR);
+
+		cpt++;
+	}
+
+	snru32 /= 10;/*average on 10 values*/
+
+	*snr = snru32 / 1000;
+
+	return 0;
+}
+
+#if 0
+static int stv0367ter_status(struct dvb_frontend *fe)
+{
+
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367ter_state *ter_state = state->ter_state;
+	int locked = FALSE;
+
+	locked = (stv0367_readbits(state, F367TER_LK));
+	if (!locked)
+		ter_state->unlock_counter += 1;
+	else
+		ter_state->unlock_counter = 0;
+
+	if (ter_state->unlock_counter > 2) {
+		if (!stv0367_readbits(state, F367TER_TPS_LOCK) ||
+				(!stv0367_readbits(state, F367TER_LK))) {
+			stv0367_writebits(state, F367TER_CORE_ACTIVE, 0);
+			msleep(2);
+			stv0367_writebits(state, F367TER_CORE_ACTIVE, 1);
+			msleep(350);
+			locked = (stv0367_readbits(state, F367TER_TPS_LOCK)) &&
+					(stv0367_readbits(state, F367TER_LK));
+		}
+
+	}
+
+	return locked;
+}
+#endif
+static int stv0367ter_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	dprintk("%s:\n", __func__);
+
+	*status = 0;
+
+	if (stv0367_readbits(state, F367TER_LK)) {
+		*status |= FE_HAS_LOCK;
+		dprintk("%s: stv0367 has locked\n", __func__);
+	}
+
+	return 0;
+}
+
+static int stv0367ter_read_ber(struct dvb_frontend* fe, u32* ber)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367ter_state *ter_state = state->ter_state;
+	u32 Errors = 0, tber = 0, temporary = 0;
+	int abc = 0, def = 0;
+
+
+	/*wait for counting completion*/
+	if (stv0367_readbits(state, F367TER_SFERRC_OLDVALUE) == 0)
+		Errors = ((u32)stv0367_readbits(state, F367TER_SFEC_ERR_CNT)
+			* (1 << 16))
+			+ ((u32)stv0367_readbits(state, F367TER_SFEC_ERR_CNT_HI)
+			* (1 << 8))
+			+ ((u32)stv0367_readbits(state, F367TER_SFEC_ERR_CNT_LO));
+	/*measurement not completed, load previous value*/
+	else {
+		tber = ter_state->pBER;
+		return 0;
+	}
+
+	abc = stv0367_readbits(state, F367TER_SFEC_ERR_SOURCE);
+	def = stv0367_readbits(state, F367TER_SFEC_NUM_EVENT);
+
+	if (Errors == 0) {
+		tber = 0;
+	} else if (abc == 0x7) {
+		if (Errors <= 4) {
+			temporary = (Errors * 1000000000) / (8 * (1 << 14));
+			temporary =  temporary;
+		} else if (Errors <= 42) {
+			temporary = (Errors * 100000000) / (8 * (1 << 14));
+			temporary = temporary * 10;
+		} else if (Errors <= 429) {
+			temporary = (Errors * 10000000) / (8 * (1 << 14));
+			temporary = temporary * 100;
+		} else if (Errors <= 4294) {
+			temporary = (Errors * 1000000) / (8 * (1 << 14));
+			temporary = temporary * 1000;
+		} else if (Errors <= 42949) {
+			temporary = (Errors * 100000) / (8 * (1 << 14));
+			temporary = temporary * 10000;
+		} else if (Errors <= 429496) {
+			temporary = (Errors * 10000) / (8 * (1 << 14));
+			temporary = temporary * 100000;
+		} else { /*if (Errors<4294967) 2^22 max error*/
+			temporary = (Errors * 1000) / (8 * (1 << 14));
+			temporary = temporary * 100000;	/* still to *10 */
+		}
+
+		/* Byte error*/
+		if (def == 2)
+			/*tber=Errors/(8*(1 <<14));*/
+			tber = temporary;
+		else if (def == 3)
+			/*tber=Errors/(8*(1 <<16));*/
+			tber = temporary / 4;
+		else if (def == 4)
+			/*tber=Errors/(8*(1 <<18));*/
+			tber = temporary / 16;
+		else if (def == 5)
+			/*tber=Errors/(8*(1 <<20));*/
+			tber = temporary / 64;
+		else if (def == 6)
+			/*tber=Errors/(8*(1 <<22));*/
+			tber = temporary / 256;
+		else
+			/* should not pass here*/
+			tber = 0;
+
+		if ((Errors < 4294967) && (Errors > 429496))
+			tber *= 10;
+
+	}
+
+	/* save actual value */
+	ter_state->pBER = tber;
+
+	(*ber) = tber;
+
+	return 0;
+}
+#if 0
+static u32 stv0367ter_get_per(struct stv0367_state * state)
+{
+	struct stv0367ter_state *ter_state = state->ter_state;
+	u32 Errors = 0, Per = 0, temporary = 0;
+	int abc = 0, def = 0, cpt = 0;
+
+	while (((stv0367_readbits(state, F367TER_SFERRC_OLDVALUE) == 1) &&
+			(cpt < 400)) || ((Errors == 0) && (cpt < 400))) {
+		msleep(1);
+		Errors = ((u32)stv0367_readbits(state, F367TER_ERR_CNT1)
+			* (1 << 16))
+			+ ((u32)stv0367_readbits(state, F367TER_ERR_CNT1_HI)
+			* (1 << 8))
+			+ ((u32)stv0367_readbits(state, F367TER_ERR_CNT1_LO));
+		cpt++;
+	}
+	abc = stv0367_readbits(state, F367TER_ERR_SRC1);
+	def = stv0367_readbits(state, F367TER_NUM_EVT1);
+
+	if (Errors == 0)
+		Per = 0;
+	else if (abc == 0x9) {
+		if (Errors <= 4) {
+			temporary = (Errors * 1000000000) / (8 * (1 << 8));
+			temporary =  temporary;
+		} else if (Errors <= 42) {
+			temporary = (Errors * 100000000) / (8 * (1 << 8));
+			temporary = temporary * 10;
+		} else if (Errors <= 429) {
+			temporary = (Errors * 10000000) / (8 * (1 << 8));
+			temporary = temporary * 100;
+		} else if (Errors <= 4294) {
+			temporary = (Errors * 1000000) / (8 * (1 << 8));
+			temporary = temporary * 1000;
+		} else if (Errors <= 42949) {
+			temporary = (Errors * 100000) / (8 * (1 << 8));
+			temporary = temporary * 10000;
+		} else { /*if(Errors<=429496)  2^16 errors max*/
+			temporary = (Errors * 10000) / (8 * (1 << 8));
+			temporary = temporary * 100000;
+		}
+
+		/* pkt error*/
+		if (def == 2)
+			/*Per=Errors/(1 << 8);*/
+			Per = temporary;
+		else if (def == 3)
+			/*Per=Errors/(1 << 10);*/
+			Per = temporary / 4;
+		else if (def == 4)
+			/*Per=Errors/(1 << 12);*/
+			Per = temporary / 16;
+		else if (def == 5)
+			/*Per=Errors/(1 << 14);*/
+			Per = temporary / 64;
+		else if (def == 6)
+			/*Per=Errors/(1 << 16);*/
+			Per = temporary / 256;
+		else
+			Per = 0;
+
+	}
+	/* save actual value */
+	ter_state->pPER = Per;
+
+	return Per;
+}
+#endif
+static int stv0367_get_tune_settings(struct dvb_frontend *fe,
+					struct dvb_frontend_tune_settings
+					*fe_tune_settings)
+{
+	fe_tune_settings->min_delay_ms = 1000;
+	fe_tune_settings->step_size = 0;
+	fe_tune_settings->max_drift = 0;
+
+	return 0;
+}
+
+static void stv0367_release(struct dvb_frontend* fe)
+{
+	struct stv0367_state* state = fe->demodulator_priv;
+
+	kfree(state->ter_state);
+	kfree(state->cab_state);
+	kfree(state);
+}
+
+static struct dvb_frontend_ops stv0367ter_ops = {
+	.info = {
+		.name			= "ST STV0367 DVB-T",
+		.type			= FE_OFDM,
+		.frequency_min		= 47000000,
+		.frequency_max		= 862000000,
+		.frequency_stepsize	= 15625,
+		.frequency_tolerance	= 0,
+		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
+			FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
+			FE_CAN_QAM_128 | FE_CAN_QAM_256 | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_RECOVER |
+			FE_CAN_INVERSION_AUTO |
+			FE_CAN_MUTE_TS
+	},
+	.release = stv0367_release,
+	.init = stv0367ter_init,
+	.sleep = stv0367ter_sleep,
+	.i2c_gate_ctrl = stv0367ter_gate_ctrl,
+	.set_frontend = stv0367ter_set_frontend,
+	.get_frontend = stv0367ter_get_frontend,
+	.get_tune_settings = stv0367_get_tune_settings,
+	.read_status = stv0367ter_read_status,
+	.read_ber = stv0367ter_read_ber,/* too slow */
+/*	.read_signal_strength = stv0367_read_signal_strength,*/
+	.read_snr = stv0367ter_read_snr,
+	.read_ucblocks = stv0367ter_read_ucblocks,
+};
+
+struct dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
+				   struct i2c_adapter *i2c)
+{
+	struct stv0367_state *state = NULL;
+	struct stv0367ter_state *ter_state = NULL;
+
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof (struct stv0367_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+	ter_state = kzalloc(sizeof (struct stv0367ter_state), GFP_KERNEL);
+	if (ter_state == NULL)
+		goto error;
+
+	/* setup the state */
+	state->i2c = i2c;
+	state->config = config;
+	state->ter_state = ter_state;
+	state->fe.ops = stv0367ter_ops;
+	state->fe.demodulator_priv = state;
+	state->chip_id = stv0367_readreg(state, 0xf000);
+
+	printk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
+
+	/* check if the demod is there */
+	if ((state->chip_id != 0x50) && (state->chip_id != 0x60))
+		goto error;
+
+	return &state->fe;
+
+error:
+	kfree(ter_state);
+	kfree(state);
+	return NULL;
+}
+EXPORT_SYMBOL(stv0367ter_attach);
+
+static int stv0367cab_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	dprintk("%s:\n", __func__);
+
+	stv0367_writebits(state, F367CAB_I2CT_ON, (enable > 0) ? 1 : 0);
+
+	return 0;
+}
+
+static u32 stv0367cab_get_mclk(struct dvb_frontend *fe, u32 ExtClk_Hz)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	u32 mclk_Hz = 0;/* master clock frequency (Hz) */
+	u32 M, N, P;
+
+
+	if (stv0367_readbits(state, F367CAB_BYPASS_PLLXN) == 0) {
+		N = (u32)stv0367_readbits(state, F367CAB_PLL_NDIV);
+		if (N == 0)
+			N = N + 1;
+
+		M = (u32)stv0367_readbits(state, F367CAB_PLL_MDIV);
+		if (M == 0)
+			M = M + 1;
+
+		P = (u32)stv0367_readbits(state, F367CAB_PLL_PDIV);
+
+		if (P > 5)
+			P = 5;
+
+		mclk_Hz = ((ExtClk_Hz / 2) * N) / (M * (1 << P));
+		printk("stv0367cab_get_mclk BYPASS_PLLXN mclk_Hz=%d\n", mclk_Hz);
+	} else
+		mclk_Hz = ExtClk_Hz;
+
+	printk("stv0367cab_get_mclk final mclk_Hz=%d\n", mclk_Hz);
+
+	return mclk_Hz;
+}
+
+static u32 stv0367cab_get_adc_freq(struct dvb_frontend *fe, u32 ExtClk_Hz)
+{
+	u32 ADCClk_Hz = ExtClk_Hz;
+
+	ADCClk_Hz = stv0367cab_get_mclk(fe, ExtClk_Hz);
+
+	return ADCClk_Hz;
+}
+
+stv0367cab_mod_t stv0367cab_SetQamSize(struct stv0367_state *state,
+					u32 SymbolRate,
+					stv0367cab_mod_t QAMSize)
+{
+	/* Set QAM size */
+	stv0367_writebits(state, F367CAB_QAM_MODE, QAMSize);
+
+	/* Set Registers settings specific to the QAM size */
+	switch (QAMSize) {
+	case FE_CAB_MOD_QAM4:
+		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x00);
+		break;
+	case FE_CAB_MOD_QAM16:
+		stv0367_writereg(state, R367CAB_AGC_PWR_REF_L, 0x64);
+		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x00);
+		stv0367_writereg(state, R367CAB_FSM_STATE, 0x90);
+		stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa7);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LD_SEN, 0x95);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LIMITER, 0x40);
+		stv0367_writereg(state, R367CAB_EQU_PNT_GAIN, 0x8a);
+		break;
+	case FE_CAB_MOD_QAM32:
+		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x00);
+		stv0367_writereg(state, R367CAB_AGC_PWR_REF_L, 0x6e);
+		stv0367_writereg(state, R367CAB_FSM_STATE, 0xb0);
+		stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xb7);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LD_SEN, 0x9d);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LIMITER, 0x7f);
+		stv0367_writereg(state, R367CAB_EQU_PNT_GAIN, 0xa7);
+		break;
+	case FE_CAB_MOD_QAM64:
+		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x82);
+		stv0367_writereg(state, R367CAB_AGC_PWR_REF_L, 0x5a);
+		if (SymbolRate > 45000000) {
+			stv0367_writereg(state, R367CAB_FSM_STATE, 0xb0);
+			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
+			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa5);
+		} else if (SymbolRate > 25000000) {
+			stv0367_writereg(state, R367CAB_FSM_STATE, 0xa0);
+			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
+			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa6);
+		} else {
+			stv0367_writereg(state, R367CAB_FSM_STATE, 0xa0);
+			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xd1);
+			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa7);
+		}
+		stv0367_writereg(state, R367CAB_EQU_CRL_LD_SEN, 0x95);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LIMITER, 0x40);
+		stv0367_writereg(state, R367CAB_EQU_PNT_GAIN, 0x99);
+		break;
+	case FE_CAB_MOD_QAM128:
+		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x00);
+		stv0367_writereg(state, R367CAB_AGC_PWR_REF_L, 0x76);
+		stv0367_writereg(state, R367CAB_FSM_STATE, 0x90);
+		stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xb1);
+		if (SymbolRate > 45000000) {
+			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa7);
+		} else if (SymbolRate > 25000000) {
+			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa6);
+		} else {
+			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0x97);
+		}
+		stv0367_writereg(state, R367CAB_EQU_CRL_LD_SEN, 0x8e);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LIMITER, 0x7f);
+		stv0367_writereg(state, R367CAB_EQU_PNT_GAIN, 0xa7);
+		break;
+	case FE_CAB_MOD_QAM256:
+		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x94);
+		stv0367_writereg(state, R367CAB_AGC_PWR_REF_L, 0x5a);
+		stv0367_writereg(state, R367CAB_FSM_STATE, 0xa0);
+		if (SymbolRate > 45000000) {
+			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
+		} else if (SymbolRate > 25000000) {
+			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
+		} else {
+			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xd1);
+		}
+		stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa7);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LD_SEN, 0x85);
+		stv0367_writereg(state, R367CAB_EQU_CRL_LIMITER, 0x40);
+		stv0367_writereg(state, R367CAB_EQU_PNT_GAIN, 0xa7);
+		break;
+	case FE_CAB_MOD_QAM512:
+		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x00);
+		break;
+	case FE_CAB_MOD_QAM1024:
+		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x00);
+		break;
+	default:
+		break;
+	}
+
+	return QAMSize;
+}
+
+static u32 stv0367cab_set_derot_freq(struct stv0367_state *state,
+					u32 adc_hz, s32 derot_hz)
+{
+	u32 sampled_if = 0;
+	u32 adc_khz;
+
+	adc_khz = adc_hz / 1000;
+
+	printk("%s: adc_hz=%d derot_hz=%d\n", __func__, adc_hz, derot_hz);
+
+	if (adc_khz != 0) {
+		if (derot_hz < 1000000)
+			derot_hz = adc_hz / 4; /* ZIF operation */
+		if (derot_hz > adc_hz)
+			derot_hz = derot_hz - adc_hz;
+		sampled_if = (u32)derot_hz / 1000;
+		sampled_if *= 32768;
+		sampled_if /= adc_khz;
+		sampled_if *= 256;
+	}
+
+	if (sampled_if > 8388607)
+		sampled_if = 8388607;
+
+	printk("%s: sampled_if=0x%x\n", __func__, sampled_if);
+
+	stv0367_writereg(state, R367CAB_MIX_NCO_LL, sampled_if);
+	stv0367_writereg(state, R367CAB_MIX_NCO_HL, (sampled_if >> 8));
+	stv0367_writebits(state, F367CAB_MIX_NCO_INC_HH, (sampled_if >> 16));
+
+	return derot_hz;
+}
+
+static u32 stv0367cab_get_derot_freq(struct stv0367_state *state, u32 adc_hz)
+{
+	u32 sampled_if;
+
+	sampled_if = stv0367_readbits(state, F367CAB_MIX_NCO_INC_LL)
+			+ (stv0367_readbits(state, F367CAB_MIX_NCO_INC_HL) << 8)
+			+ (stv0367_readbits(state, F367CAB_MIX_NCO_INC_HH) << 16);
+
+	sampled_if /= 256;
+	sampled_if *= (adc_hz / 1000);
+	sampled_if += 1;
+	sampled_if /= 32768;
+
+	return sampled_if;
+}
+
+static u32 stv0367cab_set_srate(struct stv0367_state *state, u32 adc_hz,
+			u32 mclk_hz, u32 SymbolRate,
+			stv0367cab_mod_t QAMSize)
+{
+	u32 QamSizeCorr = 0;
+	u32 u32_tmp = 0, u32_tmp1 = 0;
+	u32 adp_khz;
+
+	printk("%s:\n", __func__);
+
+	/* Set Correction factor of SRC gain */
+	switch (QAMSize) {
+	case FE_CAB_MOD_QAM4:
+		QamSizeCorr = 1110;
+		break;
+	case FE_CAB_MOD_QAM16:
+		QamSizeCorr = 1032;
+		break;
+	case FE_CAB_MOD_QAM32:
+		QamSizeCorr =  954;
+		break;
+	case FE_CAB_MOD_QAM64:
+		QamSizeCorr =  983;
+		break;
+	case FE_CAB_MOD_QAM128:
+		QamSizeCorr =  957;
+		break;
+	case FE_CAB_MOD_QAM256:
+		QamSizeCorr =  948;
+		break;
+	case FE_CAB_MOD_QAM512:
+		QamSizeCorr =    0;
+		break;
+	case FE_CAB_MOD_QAM1024:
+		QamSizeCorr =  944;
+		break;
+	default:
+		break;
+	}
+
+	/* Transfer ratio calculation */
+	if (adc_hz != 0) {
+		u32_tmp = 256 * SymbolRate;
+		u32_tmp = u32_tmp / adc_hz;
+	}
+	stv0367_writereg(state, R367CAB_EQU_CRL_TFR, (u8)u32_tmp);
+
+	/* Symbol rate and SRC gain calculation */
+	adp_khz = (mclk_hz >> 1) / 1000; /* TRL works at half the system clock */
+	if (adp_khz != 0) {
+		u32_tmp = SymbolRate;
+		u32_tmp1 = SymbolRate;
+
+		if (u32_tmp < 2097152) { /* 2097152 = 2^21 */
+			/* Symbol rate calculation */
+			u32_tmp *= 2048; /* 2048 = 2^11 */
+			u32_tmp = u32_tmp / adp_khz;
+			u32_tmp = u32_tmp * 16384; /* 16384 = 2^14 */
+			u32_tmp /= 125 ; /* 125 = 1000/2^3 */
+			u32_tmp = u32_tmp * 8; /* 8 = 2^3 */
+
+			/* SRC Gain Calculation */
+			u32_tmp1 *= 2048; /* *2*2^10 */
+			u32_tmp1 /= 439; /* *2/878 */
+			u32_tmp1 *= 256; /* *2^8 */
+			u32_tmp1 = u32_tmp1 / adp_khz; /* /(AdpClk in kHz) */
+			u32_tmp1 *= QamSizeCorr * 9; /* *1000*corr factor */
+			u32_tmp1 = u32_tmp1 / 10000000;
+
+		} else if (u32_tmp < 4194304) { /* 4194304 = 2**22 */
+			/* Symbol rate calculation */
+			u32_tmp *= 1024 ; /* 1024 = 2**10 */
+			u32_tmp = u32_tmp / adp_khz;
+			u32_tmp = u32_tmp * 16384; /* 16384 = 2**14 */
+			u32_tmp /= 125 ; /* 125 = 1000/2**3 */
+			u32_tmp = u32_tmp * 16; /* 16 = 2**4 */
+
+			/* SRC Gain Calculation */
+			u32_tmp1 *= 1024; /* *2*2^9 */
+			u32_tmp1 /= 439; /* *2/878 */
+			u32_tmp1 *= 256; /* *2^8 */
+			u32_tmp1 = u32_tmp1 / adp_khz; /* /(AdpClk in kHz)*/
+			u32_tmp1 *= QamSizeCorr * 9; /* *1000*corr factor */
+			u32_tmp1 = u32_tmp1 / 5000000;
+		} else if (u32_tmp < 8388607) { /* 8388607 = 2**23 */
+			/* Symbol rate calculation */
+			u32_tmp *= 512 ; /* 512 = 2**9 */
+			u32_tmp = u32_tmp / adp_khz;
+			u32_tmp = u32_tmp * 16384; /* 16384 = 2**14 */
+			u32_tmp /= 125 ; /* 125 = 1000/2**3 */
+			u32_tmp = u32_tmp * 32; /* 32 = 2**5 */
+
+			/* SRC Gain Calculation */
+			u32_tmp1 *= 512; /* *2*2^8 */
+			u32_tmp1 /= 439; /* *2/878 */
+			u32_tmp1 *= 256; /* *2^8 */
+			u32_tmp1 = u32_tmp1 / adp_khz; /* /(AdpClk in kHz) */
+			u32_tmp1 *= QamSizeCorr * 9; /* *1000*corr factor */
+			u32_tmp1 = u32_tmp1 / 2500000;
+		} else {
+			/* Symbol rate calculation */
+			u32_tmp *= 256 ; /* 256 = 2**8 */
+			u32_tmp = u32_tmp / adp_khz;
+			u32_tmp = u32_tmp * 16384; /* 16384 = 2**13 */
+			u32_tmp /= 125 ; /* 125 = 1000/2**3 */
+			u32_tmp = u32_tmp * 64; /* 64 = 2**6 */
+
+			/* SRC Gain Calculation */
+			u32_tmp1 *= 256; /* 2*2^7 */
+			u32_tmp1 /= 439; /* *2/878 */
+			u32_tmp1 *= 256; /* *2^8 */
+			u32_tmp1 = u32_tmp1 / adp_khz; /* /(AdpClk in kHz) */
+			u32_tmp1 *= QamSizeCorr * 9; /* *1000*corr factor */
+			u32_tmp1 = u32_tmp1 / 1250000;
+		}
+	}
+#if 0
+	/* Filters' coefficients are calculated and written
+	into registers only if the filters are enabled */
+	if (stv0367_readbits(state, F367CAB_ADJ_EN)) {
+		stv0367cab_SetIirAdjacentcoefficient(state, mclk_hz, SymbolRate);
+		/* AllPass filter must be enabled
+		when the adjacents filter is used */
+		stv0367_writebits(state, F367CAB_ALLPASSFILT_EN, 1);
+		stv0367cab_SetAllPasscoefficient(state, mclk_hz, SymbolRate);
+	} else
+		/* AllPass filter must be disabled
+		when the adjacents filter is not used */
+#endif
+	stv0367_writebits(state, F367CAB_ALLPASSFILT_EN, 0);
+
+	stv0367_writereg(state, R367CAB_SRC_NCO_LL, u32_tmp);
+	stv0367_writereg(state, R367CAB_SRC_NCO_LH, (u32_tmp >> 8));
+	stv0367_writereg(state, R367CAB_SRC_NCO_HL, (u32_tmp >> 16));
+	stv0367_writereg(state, R367CAB_SRC_NCO_HH, (u32_tmp >> 24));
+
+	stv0367_writereg(state, R367CAB_IQDEM_GAIN_SRC_L, u32_tmp1 & 0x00ff);
+	stv0367_writebits(state, F367CAB_GAIN_SRC_HI, (u32_tmp1 >> 8) & 0x00ff);
+
+	return(SymbolRate) ;
+}
+
+static u32 stv0367cab_GetSymbolRate(struct stv0367_state *state, u32 mclk_hz)
+{
+	u32 regsym;
+	u32 adp_khz;
+
+	regsym = stv0367_readreg(state, R367CAB_SRC_NCO_LL) +
+		(stv0367_readreg(state, R367CAB_SRC_NCO_LH) << 8) +
+		(stv0367_readreg(state, R367CAB_SRC_NCO_HL) << 16) +
+		(stv0367_readreg(state, R367CAB_SRC_NCO_HH) << 24);
+
+
+	/*ChipGetRegisters(hChip, R367CAB_SRC_NCO_LL, 4);
+	regsym = ChipGetFieldImage(hChip, F367CAB_SRC_NCO_INC_LL)
+	         + (ChipGetFieldImage(hChip, F367CAB_SRC_NCO_INC_LH) << 8)
+	         + (ChipGetFieldImage(hChip, F367CAB_SRC_NCO_INC_HL) << 16)
+	         + (ChipGetFieldImage(hChip, F367CAB_SRC_NCO_INC_HH) << 24);*/
+
+	adp_khz = (mclk_hz >> 1) / 1000; /* TRL works at half the system clock */
+
+	if (regsym < 134217728) {		/* 134217728L = 2**27*/
+		regsym = regsym * 32;		/* 32 = 2**5 */
+		regsym = regsym / 32768;	/* 32768L = 2**15 */
+		regsym = adp_khz * regsym;	/* AdpClk in kHz */
+		regsym = regsym / 128;		/* 128 = 2**7 */
+		regsym *= 125 ;			/* 125 = 1000/2**3 */
+		regsym /= 2048 ;		/* 2048 = 2**11	*/
+	} else if (regsym < 268435456) {	/* 268435456L = 2**28 */
+		regsym = regsym * 16;		/* 16 = 2**4 */
+		regsym = regsym / 32768;	/* 32768L = 2**15 */
+		regsym = adp_khz * regsym;	/* AdpClk in kHz */
+		regsym = regsym / 128;		/* 128 = 2**7 */
+		regsym *= 125 ;			/* 125 = 1000/2**3*/
+		regsym /= 1024 ;		/* 256 = 2**10*/
+	} else if (regsym < 536870912) {	/* 536870912L = 2**29*/
+		regsym = regsym * 8;		/* 8 = 2**3 */
+		regsym = regsym / 32768;	/* 32768L = 2**15 */
+		regsym = adp_khz * regsym;	/* AdpClk in kHz */
+		regsym = regsym / 128;		/* 128 = 2**7 */
+		regsym *= 125 ;			/* 125 = 1000/2**3 */
+		regsym /= 512 ;			/* 128 = 2**9 */
+	} else {
+		regsym = regsym * 4;		/* 4 = 2**2 */
+		regsym = regsym / 32768;	/* 32768L = 2**15 */
+		regsym = adp_khz * regsym;	/* AdpClk in kHz */
+		regsym = regsym / 128;		/* 128 = 2**7 */
+		regsym *= 125 ;			/* 125 = 1000/2**3 */
+		regsym /= 256 ;			/* 64 = 2**8 */
+	}
+	return(regsym);
+}
+
+static int stv0367cab_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	dprintk("%s:\n", __func__);
+
+	*status = 0;
+
+	if (stv0367_readbits(state, F367CAB_QAMFEC_LOCK)) {
+		*status |= FE_HAS_LOCK;
+		dprintk("%s: stv0367 has locked\n", __func__);
+	}
+
+	return 0;
+}
+
+static int stv0367cab_standby(struct dvb_frontend * fe, u8 StandbyOn)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	dprintk("%s:\n", __func__);
+
+	if (StandbyOn) {
+		stv0367_writebits(state, F367CAB_BYPASS_PLLXN, 0x03);
+		stv0367_writebits(state, F367CAB_STDBY_PLLXN, 0x01);
+		stv0367_writebits(state, F367CAB_STDBY, 1);
+		stv0367_writebits(state, F367CAB_STDBY_CORE, 1);
+		stv0367_writebits(state, F367CAB_EN_BUFFER_I, 0);
+		stv0367_writebits(state, F367CAB_EN_BUFFER_Q, 0);
+		stv0367_writebits(state, F367CAB_POFFQ, 1);
+		stv0367_writebits(state, F367CAB_POFFI, 1);
+	} else {
+		stv0367_writebits(state, F367CAB_STDBY_PLLXN, 0x00);
+		stv0367_writebits(state, F367CAB_BYPASS_PLLXN, 0x00);
+		stv0367_writebits(state, F367CAB_STDBY, 0);
+		stv0367_writebits(state, F367CAB_STDBY_CORE, 0);
+		stv0367_writebits(state, F367CAB_EN_BUFFER_I, 1);
+		stv0367_writebits(state, F367CAB_EN_BUFFER_Q, 1);
+		stv0367_writebits(state, F367CAB_POFFQ, 0);
+		stv0367_writebits(state, F367CAB_POFFI, 0);
+	}
+
+	return 0;
+}
+
+static int stv0367cab_sleep(struct dvb_frontend *fe)
+{
+	return stv0367cab_standby(fe, 1);
+}
+
+int stv0367cab_init(struct dvb_frontend *fe)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367cab_state *cab_state = state->cab_state;
+	int i;
+
+	printk("%s:\n", __func__);
+
+	for (i = 0; i < STV0367CAB_NBREGS; i++)
+		stv0367_writereg(state, def0367cab[i].addr, def0367cab[i].value);
+
+	switch (state->config->ts_mode) {
+	case STV0367_DVBCI_CLOCK:
+		printk("Setting TSMode = STV0367_DVBCI_CLOCK\n");
+		stv0367_writebits(state, F367CAB_OUTFORMAT, 0x03);
+		break;
+	case STV0367_SERIAL_PUNCT_CLOCK:
+	case STV0367_SERIAL_CONT_CLOCK:
+		stv0367_writebits(state, F367CAB_OUTFORMAT, 0x01);
+		break;
+	case STV0367_PARALLEL_PUNCT_CLOCK:
+	case STV0367_OUTPUTMODE_DEFAULT:
+		stv0367_writebits(state, F367CAB_OUTFORMAT, 0x00);
+		break;
+	}
+
+	switch (state->config->clk_pol) {
+	case STV0367_RISINGEDGE_CLOCK:
+		stv0367_writebits(state, F367CAB_CLK_POLARITY, 0x00);
+		break;
+	case STV0367_FALLINGEDGE_CLOCK:
+	case STV0367_CLOCKPOLARITY_DEFAULT:
+		stv0367_writebits(state, F367CAB_CLK_POLARITY, 0x01);
+		break;
+	}
+
+	stv0367_writebits(state, F367CAB_SYNC_STRIP, 0x00);
+
+	stv0367_writebits(state, F367CAB_CT_NBST, 0x01);
+
+	stv0367_writebits(state, F367CAB_TS_SWAP, 0x01);
+
+	stv0367_writebits(state, F367CAB_FIFO_BYPASS, 0x00);
+
+	stv0367_writereg(state, R367CAB_ANACTRL, 0x00); /* PLL enabled and used */
+
+	cab_state->mclk = stv0367cab_get_mclk(fe, state->config->xtal);
+	cab_state->adc_clk = stv0367cab_get_adc_freq(fe, state->config->xtal);
+
+	return 0;
+}
+static
+fe_stv0367_cab_signal_type_t stv0367cab_algo(struct stv0367_state *state,
+				struct dvb_frontend_parameters *param)
+{
+	struct dvb_qam_parameters *op = &param->u.qam;
+	struct stv0367cab_state *cab_state = state->cab_state;
+	fe_stv0367_cab_signal_type_t signalType = FE_CAB_NOAGC;
+	u32	QAMFEC_Lock, QAM_Lock, u32_tmp,
+		LockTime, TRLTimeOut, AGCTimeOut, CRLSymbols,
+		CRLTimeOut, EQLTimeOut, DemodTimeOut, FECTimeOut;
+	u8	TrackAGCAccum;
+	s32	tmp;
+
+	printk("%s:\n", __func__);
+
+	/* Timeouts calculation */
+	/* A max lock time of 25 ms is allowed for delayed AGC */
+	AGCTimeOut = 25;
+	/* 100000 symbols needed by the TRL as a maximum value */
+	TRLTimeOut = 100000000 / op->symbol_rate;
+	/* CRLSymbols is the needed number of symbols to achieve a lock
+	   within [-4%, +4%] of the symbol rate.
+	   CRL timeout is calculated
+	   for a lock within [-search_range, +search_range].
+	   EQL timeout can be changed depending on
+	   the micro-reflections we want to handle.
+	   A characterization must be performed
+	   with these echoes to get new timeout values.
+	*/
+	switch (op->modulation) {
+	case QAM_16:
+		CRLSymbols = 150000;
+		EQLTimeOut = 100;
+		break;
+	case QAM_32:
+		CRLSymbols = 250000;
+		EQLTimeOut = 100;
+		break;
+	case QAM_64:
+		CRLSymbols = 200000;
+		EQLTimeOut = 100;
+		break;
+	case QAM_128:
+		CRLSymbols = 250000;
+		EQLTimeOut = 100;
+		break;
+	case QAM_256:
+		CRLSymbols = 250000;
+		EQLTimeOut = 100;
+		break;
+	default:
+		CRLSymbols = 200000;
+		EQLTimeOut = 100;
+		break;
+	}
+#if 0
+	if (pIntParams->search_range < 0) {
+		CRLTimeOut = (25 * CRLSymbols * (-pIntParams->search_range / 1000)) /
+					(pIntParams->symbol_rate / 1000);
+	} else
+#endif
+	CRLTimeOut = (25 * CRLSymbols * (cab_state->search_range / 1000)) /
+					(op->symbol_rate / 1000);
+
+	CRLTimeOut = (1000 * CRLTimeOut) / op->symbol_rate;
+	/* Timeouts below 50ms are coerced */
+	if (CRLTimeOut < 50)	CRLTimeOut = 50;
+	/* A maximum of 100 TS packets is needed to get FEC lock even in case
+	the spectrum inversion needs to be changed.
+	   This is equal to 20 ms in case of the lowest symbol rate of 0.87Msps
+	*/
+	FECTimeOut = 20;
+	DemodTimeOut = AGCTimeOut + TRLTimeOut + CRLTimeOut + EQLTimeOut;
+
+	printk("%s: DemodTimeOut=%d\n", __func__, DemodTimeOut);
+
+	/* Reset the TRL to ensure nothing starts until the
+	   AGC is stable which ensures a better lock time
+	*/
+	stv0367_writereg(state, R367CAB_CTRL_1, 0x04);
+	/* Set AGC accumulation time to minimum and lock threshold to maximum
+	in order to speed up the AGC lock */
+	TrackAGCAccum = stv0367_readbits(state, F367CAB_AGC_ACCUMRSTSEL);
+	stv0367_writebits(state, F367CAB_AGC_ACCUMRSTSEL, 0x0);
+	/* Modulus Mapper is disabled */
+	stv0367_writebits(state, F367CAB_MODULUSMAP_EN, 0);
+	/* Disable the sweep function */
+	stv0367_writebits(state, F367CAB_SWEEP_EN, 0);
+	/* The sweep function is never used, Sweep rate must be set to 0 */
+	/* Set the derotator frequency in Hz */
+	stv0367cab_set_derot_freq(state, cab_state->adc_clk,
+		(1000 * (s32)state->config->if_khz + cab_state->derot_offset));
+	/* Disable the Allpass Filter when the symbol rate is out of range */
+	if ((op->symbol_rate > 10800000) | (op->symbol_rate < 1800000)) {
+		stv0367_writebits(state, F367CAB_ADJ_EN, 0);
+		stv0367_writebits(state, F367CAB_ALLPASSFILT_EN, 0);
+	}
+#if 0
+	/* Check if the tuner is locked */
+	tuner_lock = stv0367cab_tuner_get_status(fe);
+	if (tuner_lock == 0)
+		return FE_367CAB_NOTUNER;
+#endif
+	/* Relase the TRL to start demodulator acquisition */
+	/* Wait for QAM lock */
+	LockTime = 0;
+	stv0367_writereg(state, R367CAB_CTRL_1, 0x00);
+	do {
+		QAM_Lock = stv0367_readbits(state, F367CAB_FSM_STATUS);
+		if ((LockTime >= (DemodTimeOut - EQLTimeOut)) && (QAM_Lock == 0x04))
+			/* We don't wait longer, the frequency/phase offset must be too big */
+			LockTime = DemodTimeOut;
+		else if ((LockTime >= (AGCTimeOut + TRLTimeOut)) && (QAM_Lock == 0x02))
+			/* We don't wait longer, either there is no signal or
+			it is not the right symbol rate or it is an analog carrier */
+		{
+			LockTime = DemodTimeOut;
+			u32_tmp = stv0367_readbits(state, F367CAB_AGC_PWR_WORD_LO)
+				+ (stv0367_readbits(state, F367CAB_AGC_PWR_WORD_ME) << 8)
+				+ (stv0367_readbits(state, F367CAB_AGC_PWR_WORD_HI) << 16);
+			if (u32_tmp >= 131072)
+				u32_tmp = 262144 - u32_tmp;
+			u32_tmp = u32_tmp / (1 << (11 - stv0367_readbits(state, F367CAB_AGC_IF_BWSEL)));
+
+			if (u32_tmp < stv0367_readbits(state, F367CAB_AGC_PWRREF_LO)
+					+ 256 * stv0367_readbits(state, F367CAB_AGC_PWRREF_HI) - 10)
+				QAM_Lock = 0x0f;
+		} else {
+			msleep(10);
+			LockTime += 10;
+		}
+		printk("QAM_Lock=0x%x LockTime=%d\n", QAM_Lock, LockTime);
+		tmp = stv0367_readreg(state, R367CAB_IT_STATUS1);
+
+		printk("R367CAB_IT_STATUS1=0x%x\n", tmp);
+
+	} while (((QAM_Lock != 0x0c) && (QAM_Lock != 0x0b)) &&
+						(LockTime < DemodTimeOut));
+
+	printk("QAM_Lock=0x%x\n", QAM_Lock);
+
+	tmp = stv0367_readreg(state, R367CAB_IT_STATUS1);
+	printk("R367CAB_IT_STATUS1=0x%x\n", tmp);
+	tmp = stv0367_readreg(state, R367CAB_IT_STATUS2);
+	printk("R367CAB_IT_STATUS2=0x%x\n", tmp);
+
+	tmp  = stv0367cab_get_derot_freq(state, cab_state->adc_clk);
+	printk("stv0367cab_get_derot_freq=0x%x\n", tmp);
+
+	if ((QAM_Lock == 0x0c) || (QAM_Lock == 0x0b)) {
+		/* Wait for FEC lock */
+		LockTime = 0;
+		do {
+			msleep(5);
+			LockTime += 5;
+			QAMFEC_Lock = stv0367_readbits(state, F367CAB_QAMFEC_LOCK);
+		} while (!QAMFEC_Lock && (LockTime < FECTimeOut));
+	} else
+		QAMFEC_Lock = 0;
+
+	if (QAMFEC_Lock) {
+		signalType = FE_CAB_DATAOK;
+		cab_state->modulation = op->modulation;
+		cab_state->spect_inv = stv0367_readbits(state, F367CAB_QUAD_INV);
+#if 0
+/* not clear for me */
+		if (state->config->if_khz != 0) {
+			if (state->config->if_khz > cab_state->adc_clk / 1000) {
+				cab_state->freq_khz =
+					FE_Cab_TunerGetFrequency(pIntParams->hTuner)
+				- stv0367cab_get_derot_freq(state, cab_state->adc_clk)
+				- cab_state->adc_clk / 1000 + state->config->if_khz;
+			} else {
+				cab_state->freq_khz =
+						FE_Cab_TunerGetFrequency(pIntParams->hTuner)
+						- stv0367cab_get_derot_freq(state, cab_state->adc_clk)
+										+ state->config->if_khz;
+			}
+		} else {
+			cab_state->freq_khz = FE_Cab_TunerGetFrequency(pIntParams->hTuner)
+			+ stv0367cab_get_derot_freq(state, cab_state->adc_clk) - cab_state->adc_clk / 4000;
+		}
+#endif
+		cab_state->symbol_rate = stv0367cab_GetSymbolRate(state, cab_state->mclk);
+		cab_state->locked = 1;
+
+		/* stv0367_setbits(state, F367CAB_AGC_ACCUMRSTSEL,7);*/
+	} else {
+		switch (QAM_Lock) {
+		case 1:
+			signalType = FE_CAB_NOAGC;
+			break;
+		case 2:
+			signalType = FE_CAB_NOTIMING;
+			break;
+		case 3:
+			signalType = FE_CAB_TIMINGOK;
+			break;
+		case 4:
+			signalType = FE_CAB_NOCARRIER;
+			break;
+		case 5:
+			signalType = FE_CAB_CARRIEROK;
+			break;
+		case 7:
+			signalType = FE_CAB_NOBLIND;
+			break;
+		case 8:
+			signalType = FE_CAB_BLINDOK;
+			break;
+		case 10:
+			signalType = FE_CAB_NODEMOD;
+			break;
+		case 11:
+			signalType = FE_CAB_DEMODOK;
+			break;
+		case 12:
+			signalType = FE_CAB_DEMODOK;
+			break;
+		case 13:
+			signalType = FE_CAB_NODEMOD;
+			break;
+		case 14:
+			signalType = FE_CAB_NOBLIND;
+			break;
+		case 15:
+			signalType = FE_CAB_NOSIGNAL;
+			break;
+		default:
+			break;
+		}
+
+	}
+
+	/* Set the AGC control values to tracking values */
+	stv0367_writebits(state, F367CAB_AGC_ACCUMRSTSEL, TrackAGCAccum);
+	return signalType;
+}
+
+static int stv0367cab_set_frontend(struct dvb_frontend *fe,
+				struct dvb_frontend_parameters *param)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367cab_state *cab_state = state->cab_state;
+	struct dvb_qam_parameters *op = &param->u.qam;
+	stv0367cab_mod_t QAMSize = 0;
+
+	printk("%s: freq = %d, srate = %d\n", __func__,
+					param->frequency, op->symbol_rate);
+
+	cab_state->derot_offset = 0;
+
+	switch (op->modulation) {
+	case QAM_16:
+		QAMSize= FE_CAB_MOD_QAM16;
+		break;
+	case QAM_32:
+		QAMSize= FE_CAB_MOD_QAM32;
+		break;
+	case QAM_64:
+		QAMSize= FE_CAB_MOD_QAM64;
+		break;
+	case QAM_128:
+		QAMSize= FE_CAB_MOD_QAM128;
+		break;
+	case QAM_256:
+		QAMSize= FE_CAB_MOD_QAM256;
+		break;
+	default:
+		break;
+	}
+
+	stv0367cab_init(fe);
+
+	/* Tuner Frequency Setting */
+	if (fe->ops.tuner_ops.set_params) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+		fe->ops.tuner_ops.set_params(fe, param);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+	}
+
+	stv0367cab_SetQamSize(
+			state,
+			op->symbol_rate,
+			QAMSize);
+
+	stv0367cab_set_srate(state,
+			cab_state->adc_clk,
+			cab_state->mclk,
+			op->symbol_rate,
+			QAMSize);
+	/* Search algorithm launch, [-1.1*RangeOffset, +1.1*RangeOffset] scan */
+	cab_state->state = stv0367cab_algo(state, param);
+	return 0;
+}
+
+static int stv0367cab_get_frontend(struct dvb_frontend *fe,
+				  struct dvb_frontend_parameters *param)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	struct stv0367cab_state *cab_state = state->cab_state;
+	struct dvb_qam_parameters *op = &param->u.qam;
+
+	stv0367cab_mod_t QAMSize;
+
+	printk("%s:\n", __func__);
+
+	op->symbol_rate = stv0367cab_GetSymbolRate(state, cab_state->mclk);
+
+	QAMSize = stv0367_readbits(state, F367CAB_QAM_MODE);
+	switch (QAMSize) {
+	case FE_CAB_MOD_QAM16:
+		op->modulation = QAM_16;
+		break;
+	case FE_CAB_MOD_QAM32:
+		op->modulation = QAM_32;
+		break;
+	case FE_CAB_MOD_QAM64:
+		op->modulation = QAM_64;
+		break;
+	case FE_CAB_MOD_QAM128:
+		op->modulation = QAM_128;
+		break;
+	case QAM_256:
+		op->modulation = QAM_256;
+		break;
+	default:
+		break;
+	}
+
+	param->frequency = stv0367_get_tuner_freq(fe);
+
+	printk("%s: tuner frequency = %d\n", __func__, param->frequency);
+
+	if (state->config->if_khz == 0) {
+		param->frequency +=(stv0367cab_get_derot_freq(state, cab_state->adc_clk)
+				- cab_state->adc_clk / 4000);
+		return 0;
+	}
+
+	if (state->config->if_khz > cab_state->adc_clk / 1000)
+		param->frequency +=(state->config->if_khz
+			- stv0367cab_get_derot_freq(state, cab_state->adc_clk)
+			- cab_state->adc_clk / 1000);
+	else
+		param->frequency +=(state->config->if_khz
+			- stv0367cab_get_derot_freq(state, cab_state->adc_clk));
+
+	return 0;
+}
+
+#if 0
+void stv0367cab_GetErrorCount(state, stv0367cab_mod_t QAMSize,
+			u32 symbol_rate, FE_367qam_Monitor *Monitor_results)
+{
+	stv0367cab_OptimiseNByteAndGetBER(state, QAMSize, symbol_rate, Monitor_results);
+	stv0367cab_GetPacketsCount(state, Monitor_results);
+
+	return;
+}
+
+static int stv0367cab_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	return 0;
+}
+#endif
+static s32 stv0367cab_get_rf_lvl(struct stv0367_state *state)
+{
+	s32 rfLevel = 0;
+	s32 RfAgcPwm = 0, IfAgcPwm = 0;
+	u8 i;
+
+	stv0367_writebits(state, F367CAB_STDBY_ADCGP, 0x0);
+
+	RfAgcPwm = (stv0367_readbits(state, F367CAB_RF_AGC1_LEVEL_LO) & 0x03)
+			+ (stv0367_readbits(state, F367CAB_RF_AGC1_LEVEL_HI) << 2);
+	RfAgcPwm = 100 * RfAgcPwm / 1023;
+
+	IfAgcPwm = stv0367_readbits(state, F367CAB_AGC_IF_PWMCMD_LO)
+			+ (stv0367_readbits(state, F367CAB_AGC_IF_PWMCMD_HI) << 8);
+	if (IfAgcPwm >= 2048)
+		IfAgcPwm -= 2048;
+	else
+		IfAgcPwm += 2048;
+
+	IfAgcPwm = 100 * IfAgcPwm / 4095;
+
+	/* For DTT75467 on NIM */
+	if (RfAgcPwm < 90  && IfAgcPwm < 28) {
+		for (i = 0; i < RF_LOOKUP_TABLE_SIZE; i++) {
+			if (RfAgcPwm <= stv0367cab_RF_LookUp1[0][i]) {
+				rfLevel = (-1) * stv0367cab_RF_LookUp1[1][i];
+				break;
+			}
+		}
+		if (i == RF_LOOKUP_TABLE_SIZE) rfLevel = -56;
+	} else { /*if IF AGC>10*/
+		for (i = 0;i < RF_LOOKUP_TABLE2_SIZE;i++) {
+			if (IfAgcPwm <= stv0367cab_RF_LookUp2[0][i]) {
+				rfLevel = (-1) * stv0367cab_RF_LookUp2[1][i];
+				break;
+			}
+		}
+		if (i == RF_LOOKUP_TABLE2_SIZE) rfLevel = -72;
+	}
+	return rfLevel;
+}
+
+static int stv0367cab_read_strength(struct dvb_frontend *fe, u16 *strength)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+
+	s32 signal =  stv0367cab_get_rf_lvl(state);
+
+	dprintk("%s: signal=%d dBm\n", __func__, signal);
+
+	if (signal <= -72)
+		*strength = 65535;
+	else
+		*strength = (22 + signal) * (-1311);
+
+	dprintk("%s: strength=%d\n", __func__, (*strength));
+
+	return 0;
+}
+
+static int stv0367cab_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct stv0367_state* state = fe->demodulator_priv;
+	u32 noisepercentage;
+	stv0367cab_mod_t QAMSize;
+	u32 regval = 0, temp = 0;
+	int power, i;
+
+	QAMSize = stv0367_readbits(state, F367CAB_QAM_MODE);
+	switch (QAMSize) {
+	case FE_CAB_MOD_QAM4:
+		power = 21904;
+		break;
+	case FE_CAB_MOD_QAM16:
+		power = 20480;
+		break;
+	case FE_CAB_MOD_QAM32:
+		power = 23040;
+		break;
+	case FE_CAB_MOD_QAM64:
+		power = 21504;
+		break;
+	case FE_CAB_MOD_QAM128:
+		power = 23616;
+		break;
+	case FE_CAB_MOD_QAM256:
+		power = 21760;
+		break;
+	case FE_CAB_MOD_QAM512:
+		power = 1;
+		break;
+	case FE_CAB_MOD_QAM1024:
+		power = 21280;
+		break;
+	default:
+		power = 1;
+		break;
+	}
+
+	for (i = 0; i < 10; i++) {
+		regval += (stv0367_readbits(state, F367CAB_SNR_LO)
+			+ 256 * stv0367_readbits(state, F367CAB_SNR_HI));
+	}
+
+	regval /= 10; /*for average over 10 times in for loop above*/
+	if (regval != 0) {
+		temp = power
+			* (1 << (3 + stv0367_readbits(state, F367CAB_SNR_PER)));
+		temp /= regval;
+	}
+
+	/* table values, not needed to calculate logarithms */
+	if (temp >= 5012)
+		noisepercentage = 100;
+	else if (temp >= 3981)
+		noisepercentage = 93;
+	else if (temp >= 3162)
+		noisepercentage = 86;
+	else if (temp >= 2512)
+		noisepercentage = 79;
+	else if (temp >= 1995)
+		noisepercentage = 72;
+	else if (temp >= 1585)
+		noisepercentage = 65;
+	else if (temp >= 1259)
+		noisepercentage = 58;
+	else if (temp >= 1000)
+		noisepercentage = 50;
+	else if (temp >= 794)
+		noisepercentage = 43;
+	else if (temp >= 501)
+		noisepercentage = 36;
+	else if (temp >= 316)
+		noisepercentage = 29;
+	else if (temp >= 200)
+		noisepercentage = 22;
+	else if (temp >= 158)
+		noisepercentage = 14;
+	else if (temp >= 126)
+		noisepercentage = 7;
+	else
+		noisepercentage = 0;
+
+	dprintk("%s: noisepercentage=%d\n", __func__, noisepercentage);
+
+	*snr = (noisepercentage * 65535) / 100;
+
+	return 0;
+}
+
+static struct dvb_frontend_ops stv0367cab_ops = {
+	.info = {
+		.name = "ST STV0367 DVB-C",
+		.type = FE_QAM,
+		.frequency_min = 47000000,
+		.frequency_max = 862000000,
+		.frequency_stepsize = 62500,
+		.symbol_rate_min = 870000,
+		.symbol_rate_max = 11700000,
+		.caps = 0x400 |/* FE_CAN_QAM_4 */
+			FE_CAN_QAM_16 | FE_CAN_QAM_32  |
+			FE_CAN_QAM_64 | FE_CAN_QAM_128 |
+			FE_CAN_QAM_256 | FE_CAN_FEC_AUTO
+	},
+	.release				= stv0367_release,
+	.init					= stv0367cab_init,
+	.sleep					= stv0367cab_sleep,
+	.i2c_gate_ctrl				= stv0367cab_gate_ctrl,
+	.set_frontend				= stv0367cab_set_frontend,
+	.get_frontend				= stv0367cab_get_frontend,
+	.read_status				= stv0367cab_read_status,
+/*	.read_ber				= stv0367cab_read_ber,*/
+	.read_signal_strength			= stv0367cab_read_strength,
+	.read_snr				= stv0367cab_read_snr,
+/* 	.read_ucblocks				= stv0367cab_read_ucblcks,*/
+	.get_tune_settings			= stv0367_get_tune_settings,
+};
+
+struct dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
+				   struct i2c_adapter *i2c)
+{
+	struct stv0367_state *state = NULL;
+	struct stv0367cab_state *cab_state = NULL;
+
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof (struct stv0367_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+	cab_state = kzalloc(sizeof (struct stv0367cab_state), GFP_KERNEL);
+	if (cab_state == NULL)
+		goto error;
+
+	/* setup the state */
+	state->i2c = i2c;
+	state->config = config;
+	cab_state->search_range = 280000;
+	state->cab_state = cab_state;
+	state->fe.ops = stv0367cab_ops;
+	state->fe.demodulator_priv = state;
+	state->chip_id = stv0367_readreg(state, 0xf000);
+
+	printk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
+
+	/* check if the demod is there */
+	if ((state->chip_id != 0x50) && (state->chip_id != 0x60))
+		goto error;
+
+	return &state->fe;
+
+error:
+	kfree(cab_state);
+	kfree(state);
+	return NULL;
+}
+EXPORT_SYMBOL(stv0367cab_attach);
+
+MODULE_PARM_DESC(debug, "Set debug");
+MODULE_PARM_DESC(i2c_debug, "Set i2c debug");
+
+MODULE_AUTHOR("Igor M. Liplianin");
+MODULE_DESCRIPTION("ST STV0367 DVB-C/T demodulator driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/stv0367.h b/drivers/media/dvb/frontends/stv0367.h
new file mode 100644
index 0000000..028f0dc
--- /dev/null
+++ b/drivers/media/dvb/frontends/stv0367.h
@@ -0,0 +1,62 @@
+/*
+ * stv0367.h
+ *
+ * Driver for ST STV0367 DVB-T & DVB-C demodulator IC.
+ *
+ * Copyright (C) ST Microelectronics.
+ * Copyright (C) 2010 NetUP Inc.
+ * Copyright (C) 2010 Igor M. Liplianin <liplianin@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef STV0367_H
+#define STV0367_H
+
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+
+struct stv0367_config {
+	u8 demod_address;
+	u32 xtal;
+	u32 if_khz;/*4500*/
+	int if_iq_mode;
+	int ts_mode;
+	int clk_pol;
+};
+
+#if defined(CONFIG_DVB_STV0367) || (defined(CONFIG_DVB_STV0367_MODULE) \
+							&& defined(MODULE))
+extern struct dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
+					struct i2c_adapter *i2c);
+extern struct dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
+					struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
+					struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+static inline struct dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
+					struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
diff --git a/drivers/media/dvb/frontends/stv0367_priv.h b/drivers/media/dvb/frontends/stv0367_priv.h
new file mode 100644
index 0000000..5653c2a
--- /dev/null
+++ b/drivers/media/dvb/frontends/stv0367_priv.h
@@ -0,0 +1,211 @@
+/*
+ * stv0367_priv.h
+ *
+ * Driver for ST STV0367 DVB-T & DVB-C demodulator IC.
+ *
+ * Copyright (C) ST Microelectronics.
+ * Copyright (C) 2010 NetUP Inc.
+ * Copyright (C) 2010 Igor M. Liplianin <liplianin@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+/* Common driver error constants */
+
+#ifndef STV0367_PRIV_H
+#define STV0367_PRIV_H
+
+#ifndef TRUE
+    #define TRUE (1 == 1)
+#endif
+#ifndef FALSE
+    #define FALSE (!TRUE)
+#endif
+
+#ifndef NULL
+#define NULL 0
+#endif
+
+/* MACRO definitions */
+#define ABS(X) ((X)<0 ? (-1*(X)) : (X))
+#define MAX(X,Y) ((X)>=(Y) ? (X) : (Y))
+#define MIN(X,Y) ((X)<=(Y) ? (X) : (Y))
+#define INRANGE(X,Y,Z) ((((X)<=(Y)) && ((Y)<=(Z)))||(((Z)<=(Y)) && ((Y)<=(X))) ? 1 : 0)
+
+#ifndef MAKEWORD
+#define MAKEWORD(X,Y) (( (X) <<8)+(Y))
+#endif
+
+#define LSB(X) ( ( (X) & 0xFF ) )
+#define MSB(Y) ( ( (Y)>>8  ) & 0xFF )
+#define MMSB(Y)( ( (Y)>>16 ) & 0xFF )
+
+typedef enum {
+	FE_TER_NOAGC = 0,
+	FE_TER_AGCOK = 5,
+	FE_TER_NOTPS = 6,
+	FE_TER_TPSOK = 7,
+	FE_TER_NOSYMBOL = 8,
+	FE_TER_BAD_CPQ = 9,
+	FE_TER_PRFOUNDOK = 10,
+	FE_TER_NOPRFOUND = 11,
+	FE_TER_LOCKOK = 12,
+	FE_TER_NOLOCK = 13,
+	FE_TER_SYMBOLOK = 15,
+	FE_TER_CPAMPOK = 16,
+	FE_TER_NOCPAMP = 17,
+	FE_TER_SWNOK = 18
+
+} fe_stv0367_ter_signal_type_t;
+
+typedef enum {
+	STV0367_OUTPUTMODE_DEFAULT,
+	STV0367_SERIAL_PUNCT_CLOCK,
+	STV0367_SERIAL_CONT_CLOCK,
+	STV0367_PARALLEL_PUNCT_CLOCK,
+	STV0367_DVBCI_CLOCK
+
+} stv0367_ts_mode_t;
+
+typedef enum {
+	STV0367_CLOCKPOLARITY_DEFAULT,
+	STV0367_RISINGEDGE_CLOCK,
+	STV0367_FALLINGEDGE_CLOCK
+} stv0367_clk_pol_t;
+
+typedef enum {
+	FE_TER_CHAN_BW_6M = 6,
+	FE_TER_CHAN_BW_7M = 7,
+	FE_TER_CHAN_BW_8M = 8
+}
+FE_TER_ChannelBW_t;
+typedef enum {
+	FE_TER_TPS_1_2 =0,
+	FE_TER_TPS_2_3 = 1,
+	FE_TER_TPS_3_4 = 2,
+	FE_TER_TPS_5_6 = 3,
+	FE_TER_TPS_7_8 = 4
+} FE_TER_Rate_TPS_t;
+
+typedef enum {
+	FE_TER_MODE_2K,
+	FE_TER_MODE_8K,
+	FE_TER_MODE_4K
+}
+fe_stv0367_ter_mode_t;
+#if 0
+typedef enum {
+	FE_TER_HIER_ALPHA_NONE,	/* Regular modulation */
+	FE_TER_HIER_ALPHA_1,	/* Hierarchical modulation a = 1*/
+	FE_TER_HIER_ALPHA_2,	/* Hierarchical modulation a = 2*/
+	FE_TER_HIER_ALPHA_4	/* Hierarchical modulation a = 4*/
+}
+FE_TER_Hierarchy_Alpha_t;
+#endif
+typedef enum {
+	FE_TER_HIER_NONE,	/*Hierarchy None*/
+	FE_TER_HIER_LOW_PRIO,  	/*Hierarchy : Low Priority*/
+	FE_TER_HIER_HIGH_PRIO,	/*Hierarchy : High Priority*/
+	FE_TER_HIER_PRIO_ANY	/*Hierarchy  :Any*/
+} fe_stv0367_ter_hierarchy_t;
+
+#if 0
+typedef enum {
+	FE_TER_INVERSION_NONE = 0,
+	FE_TER_INVERSION = 1,
+	FE_TER_INVERSION_AUTO = 2,
+	FE_TER_INVERSION_UNK  = 4
+}
+fe_stv0367_ter_spec_t;
+#endif
+
+typedef enum {
+	FE_TER_NORMAL_IF_TUNER = 0,
+	FE_TER_LONGPATH_IF_TUNER = 1,
+	FE_TER_IQ_TUNER = 2
+
+}fe_stv0367_ter_if_iq_mode_t;
+
+typedef enum {
+	FE_TER_FEC_NONE = 0x00,	/* no FEC rate specified */
+	FE_TER_FEC_ALL = 0xFF,	 /* Logical OR of all FECs */
+	FE_TER_FEC_1_2 = 1,
+	FE_TER_FEC_2_3 = (1 << 1),
+	FE_TER_FEC_3_4 = (1 << 2),
+	FE_TER_FEC_4_5 = (1 << 3),
+	FE_TER_FEC_5_6 = (1 << 4),
+	FE_TER_FEC_6_7 = (1 << 5),
+	FE_TER_FEC_7_8 = (1 << 6),
+	FE_TER_FEC_8_9 = (1 << 7)
+}
+FE_TER_FECRate_t;
+typedef enum {
+	FE_TER_FE_1_2 = 0,
+	FE_TER_FE_2_3 = 1,
+	FE_TER_FE_3_4 = 2,
+	FE_TER_FE_5_6 = 3,
+	FE_TER_FE_6_7 = 4,
+	FE_TER_FE_7_8 = 5
+} FE_TER_Rate_t;
+
+typedef enum {
+	FE_TER_FORCENONE = 0,
+	FE_TER_FORCE_M_G = 1
+} FE_TER_Force_t;
+
+typedef enum {
+	FE_CAB_MOD_QAM4,
+	FE_CAB_MOD_QAM16,
+	FE_CAB_MOD_QAM32,
+	FE_CAB_MOD_QAM64,
+	FE_CAB_MOD_QAM128,
+	FE_CAB_MOD_QAM256,
+	FE_CAB_MOD_QAM512,
+	FE_CAB_MOD_QAM1024
+} stv0367cab_mod_t;
+#if 0
+typedef enum {
+	FE_CAB_FEC_A = 1,	/* J83 Annex A */
+	FE_CAB_FEC_B = (1 << 1),/* J83 Annex B */
+	FE_CAB_FEC_C = (1 << 2)	/* J83 Annex C */
+} FE_CAB_FECType_t;
+#endif
+typedef struct {
+	int locked;
+	u32 frequency; /* kHz */
+	u32 symbol_rate; /* Mbds */
+	stv0367cab_mod_t modulation;
+	fe_spectral_inversion_t spect_inv;
+	s32 Power_dBmx10;	/* Power of the RF signal (dBm x 10) */
+	u32	CN_dBx10;	/* Carrier to noise ratio (dB x 10) */
+	u32	BER;		/* Bit error rate (x 10000000)	*/
+} FE_CAB_SignalInfo_t;
+
+typedef enum {
+	FE_CAB_NOTUNER,
+	FE_CAB_NOAGC,
+	FE_CAB_NOSIGNAL,
+	FE_CAB_NOTIMING,
+	FE_CAB_TIMINGOK,
+	FE_CAB_NOCARRIER,
+	FE_CAB_CARRIEROK,
+	FE_CAB_NOBLIND,
+	FE_CAB_BLINDOK,
+	FE_CAB_NODEMOD,
+	FE_CAB_DEMODOK,
+	FE_CAB_DATAOK
+} fe_stv0367_cab_signal_type_t;
+
+#endif
diff --git a/drivers/media/dvb/frontends/stv0367_regs.h b/drivers/media/dvb/frontends/stv0367_regs.h
new file mode 100644
index 0000000..d3eeaeb
--- /dev/null
+++ b/drivers/media/dvb/frontends/stv0367_regs.h
@@ -0,0 +1,3614 @@
+/*
+ * stv0367_regs.h
+ *
+ * Driver for ST STV0367 DVB-T & DVB-C demodulator IC.
+ *
+ * Copyright (C) ST Microelectronics.
+ * Copyright (C) 2010 NetUP Inc.
+ * Copyright (C) 2010 Igor M. Liplianin <liplianin@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef STV0367_REGS_H
+#define STV0367_REGS_H
+
+/* ID */
+#define	R367TER_ID	0xf000
+#define	F367TER_IDENTIFICATIONREG	0xf00000ff
+
+/* I2CRPT */
+#define	R367TER_I2CRPT	0xf001
+#define	F367TER_I2CT_ON	0xf0010080
+#define	F367TER_ENARPT_LEVEL	0xf0010070
+#define	F367TER_SCLT_DELAY	0xf0010008
+#define	F367TER_SCLT_NOD	0xf0010004
+#define	F367TER_STOP_ENABLE	0xf0010002
+#define	F367TER_SDAT_NOD	0xf0010001
+
+/* TOPCTRL */
+#define	R367TER_TOPCTRL	0xf002
+#define	F367TER_STDBY	0xf0020080
+#define	F367TER_STDBY_FEC	0xf0020040
+#define	F367TER_STDBY_CORE	0xf0020020
+#define	F367TER_QAM_COFDM	0xf0020010
+#define	F367TER_TS_DIS	0xf0020008
+#define	F367TER_DIR_CLK_216	0xf0020004
+#define	F367TER_TUNER_BB	0xf0020002
+#define	F367TER_DVBT_H	0xf0020001
+
+/* IOCFG0 */
+#define	R367TER_IOCFG0	0xf003
+#define	F367TER_OP0_SD	0xf0030080
+#define	F367TER_OP0_VAL	0xf0030040
+#define	F367TER_OP0_OD	0xf0030020
+#define	F367TER_OP0_INV	0xf0030010
+#define	F367TER_OP0_DACVALUE_HI	0xf003000f
+
+/* DAc0R */
+#define	R367TER_DAC0R	0xf004
+#define	F367TER_OP0_DACVALUE_LO	0xf00400ff
+
+/* IOCFG1 */
+#define	R367TER_IOCFG1	0xf005
+#define	F367TER_IP0	0xf0050040
+#define	F367TER_OP1_OD	0xf0050020
+#define	F367TER_OP1_INV	0xf0050010
+#define	F367TER_OP1_DACVALUE_HI	0xf005000f
+
+/* DAC1R */
+#define	R367TER_DAC1R	0xf006
+#define	F367TER_OP1_DACVALUE_LO	0xf00600ff
+
+/* IOCFG2 */
+#define	R367TER_IOCFG2	0xf007
+#define	F367TER_OP2_LOCK_CONF	0xf00700e0
+#define	F367TER_OP2_OD	0xf0070010
+#define	F367TER_OP2_VAL	0xf0070008
+#define	F367TER_OP1_LOCK_CONF	0xf0070007
+
+/* SDFR */
+#define	R367TER_SDFR	0xf008
+#define	F367TER_OP0_FREQ	0xf00800f0
+#define	F367TER_OP1_FREQ	0xf008000f
+
+/* STATUS */
+#define	R367TER_STATUS	0xf009
+#define	F367TER_TPS_LOCK	0xf0090080
+#define	F367TER_SYR_LOCK	0xf0090040
+#define	F367TER_AGC_LOCK	0xf0090020
+#define	F367TER_PRF	0xf0090010
+#define	F367TER_LK	0xf0090008
+#define	F367TER_PR	0xf0090007
+
+/* AUX_CLK */
+#define	R367TER_AUX_CLK	0xf00a
+#define	F367TER_AUXFEC_CTL	0xf00a00c0
+#define	F367TER_DIS_CKX4	0xf00a0020
+#define	F367TER_CKSEL	0xf00a0018
+#define	F367TER_CKDIV_PROG	0xf00a0006
+#define	F367TER_AUXCLK_ENA	0xf00a0001
+
+/* FREESYS1 */
+#define	R367TER_FREESYS1	0xf00b
+#define	F367TER_FREE_SYS1	0xf00b00ff
+
+/* FREESYS2 */
+#define	R367TER_FREESYS2	0xf00c
+#define	F367TER_FREE_SYS2	0xf00c00ff
+
+/* FREESYS3 */
+#define	R367TER_FREESYS3	0xf00d
+#define	F367TER_FREE_SYS3	0xf00d00ff
+
+/* GPIO_CFG */
+#define	R367TER_GPIO_CFG	0xf00e
+#define	F367TER_GPIO7_NOD	0xf00e0080
+#define	F367TER_GPIO7_CFG	0xf00e0040
+#define	F367TER_GPIO6_NOD	0xf00e0020
+#define	F367TER_GPIO6_CFG	0xf00e0010
+#define	F367TER_GPIO5_NOD	0xf00e0008
+#define	F367TER_GPIO5_CFG	0xf00e0004
+#define	F367TER_GPIO4_NOD	0xf00e0002
+#define	F367TER_GPIO4_CFG	0xf00e0001
+
+/* GPIO_CMD */
+#define	R367TER_GPIO_CMD	0xf00f
+#define	F367TER_GPIO7_VAL	0xf00f0008
+#define	F367TER_GPIO6_VAL	0xf00f0004
+#define	F367TER_GPIO5_VAL	0xf00f0002
+#define	F367TER_GPIO4_VAL	0xf00f0001
+
+/* AGC2MAX */
+#define	R367TER_AGC2MAX	0xf010
+#define	F367TER_AGC2_MAX	0xf01000ff
+
+/* AGC2MIN */
+#define	R367TER_AGC2MIN	0xf011
+#define	F367TER_AGC2_MIN	0xf01100ff
+
+/* AGC1MAX */
+#define	R367TER_AGC1MAX	0xf012
+#define	F367TER_AGC1_MAX	0xf01200ff
+
+/* AGC1MIN */
+#define	R367TER_AGC1MIN	0xf013
+#define	F367TER_AGC1_MIN	0xf01300ff
+
+/* AGCR */
+#define	R367TER_AGCR	0xf014
+#define	F367TER_RATIO_A	0xf01400e0
+#define	F367TER_RATIO_B	0xf0140018
+#define	F367TER_RATIO_C	0xf0140007
+
+/* AGC2TH */
+#define	R367TER_AGC2TH	0xf015
+#define	F367TER_AGC2_THRES	0xf01500ff
+
+/* AGC12c */
+#define	R367TER_AGC12C	0xf016
+#define	F367TER_AGC1_IV	0xf0160080
+#define	F367TER_AGC1_OD	0xf0160040
+#define	F367TER_AGC1_LOAD	0xf0160020
+#define	F367TER_AGC2_IV	0xf0160010
+#define	F367TER_AGC2_OD	0xf0160008
+#define	F367TER_AGC2_LOAD	0xf0160004
+#define	F367TER_AGC12_MODE	0xf0160003
+
+/* AGCCTRL1 */
+#define	R367TER_AGCCTRL1	0xf017
+#define	F367TER_DAGC_ON	0xf0170080
+#define	F367TER_INVERT_AGC12	0xf0170040
+#define	F367TER_AGC1_MODE	0xf0170008
+#define	F367TER_AGC2_MODE	0xf0170007
+
+/* AGCCTRL2 */
+#define	R367TER_AGCCTRL2	0xf018
+#define	F367TER_FRZ2_CTRL	0xf0180060
+#define	F367TER_FRZ1_CTRL	0xf0180018
+#define	F367TER_TIME_CST	0xf0180007
+
+/* AGC1VAL1 */
+#define	R367TER_AGC1VAL1	0xf019
+#define	F367TER_AGC1_VAL_LO	0xf01900ff
+
+/* AGC1VAL2 */
+#define	R367TER_AGC1VAL2	0xf01a
+#define	F367TER_AGC1_VAL_HI	0xf01a000f
+
+/* AGC2VAL1 */
+#define	R367TER_AGC2VAL1	0xf01b
+#define	F367TER_AGC2_VAL_LO	0xf01b00ff
+
+/* AGC2VAL2 */
+#define	R367TER_AGC2VAL2	0xf01c
+#define	F367TER_AGC2_VAL_HI	0xf01c000f
+
+/* AGC2PGA */
+#define	R367TER_AGC2PGA	0xf01d
+#define	F367TER_AGC2_PGA	0xf01d00ff
+
+/* OVF_RATE1 */
+#define	R367TER_OVF_RATE1	0xf01e
+#define	F367TER_OVF_RATE_HI	0xf01e000f
+
+/* OVF_RATE2 */
+#define	R367TER_OVF_RATE2	0xf01f
+#define	F367TER_OVF_RATE_LO	0xf01f00ff
+
+/* GAIN_SRC1 */
+#define	R367TER_GAIN_SRC1	0xf020
+#define	F367TER_INV_SPECTR	0xf0200080
+#define	F367TER_IQ_INVERT	0xf0200040
+#define	F367TER_INR_BYPASS	0xf0200020
+#define	F367TER_STATUS_INV_SPECRUM	0xf0200010
+#define	F367TER_GAIN_SRC_HI	0xf020000f
+
+/* GAIN_SRC2 */
+#define	R367TER_GAIN_SRC2	0xf021
+#define	F367TER_GAIN_SRC_LO	0xf02100ff
+
+/* INC_DEROT1 */
+#define	R367TER_INC_DEROT1	0xf022
+#define	F367TER_INC_DEROT_HI	0xf02200ff
+
+/* INC_DEROT2 */
+#define	R367TER_INC_DEROT2	0xf023
+#define	F367TER_INC_DEROT_LO	0xf02300ff
+
+/* PPM_CPAMP_DIR */
+#define	R367TER_PPM_CPAMP_DIR	0xf024
+#define	F367TER_PPM_CPAMP_DIRECT	0xf02400ff
+
+/* PPM_CPAMP_INV */
+#define	R367TER_PPM_CPAMP_INV	0xf025
+#define	F367TER_PPM_CPAMP_INVER	0xf02500ff
+
+/* FREESTFE_1 */
+#define	R367TER_FREESTFE_1	0xf026
+#define	F367TER_SYMBOL_NUMBER_INC	0xf02600c0
+#define	F367TER_SEL_LSB	0xf0260004
+#define	F367TER_AVERAGE_ON	0xf0260002
+#define	F367TER_DC_ADJ	0xf0260001
+
+/* FREESTFE_2 */
+#define	R367TER_FREESTFE_2	0xf027
+#define	F367TER_SEL_SRCOUT	0xf02700c0
+#define	F367TER_SEL_SYRTHR	0xf027001f
+
+/* DCOFFSET */
+#define	R367TER_DCOFFSET	0xf028
+#define	F367TER_SELECT_I_Q	0xf0280080
+#define	F367TER_DC_OFFSET	0xf028007f
+
+/* EN_PROCESS */
+#define	R367TER_EN_PROCESS	0xf029
+#define	F367TER_FREE	0xf02900f0
+#define	F367TER_ENAB_MANUAL	0xf0290001
+
+/* SDI_SMOOTHER */
+#define	R367TER_SDI_SMOOTHER	0xf02a
+#define	F367TER_DIS_SMOOTH	0xf02a0080
+#define	F367TER_SDI_INC_SMOOTHER	0xf02a007f
+
+/* FE_LOOP_OPEN */
+#define	R367TER_FE_LOOP_OPEN	0xf02b
+#define	F367TER_TRL_LOOP_OP	0xf02b0002
+#define	F367TER_CRL_LOOP_OP	0xf02b0001
+
+/* FREQOFF1 */
+#define	R367TER_FREQOFF1	0xf02c
+#define	F367TER_FREQ_OFFSET_LOOP_OPEN_VHI	0xf02c00ff
+
+/* FREQOFF2 */
+#define	R367TER_FREQOFF2	0xf02d
+#define	F367TER_FREQ_OFFSET_LOOP_OPEN_HI	0xf02d00ff
+
+/* FREQOFF3 */
+#define	R367TER_FREQOFF3	0xf02e
+#define	F367TER_FREQ_OFFSET_LOOP_OPEN_LO	0xf02e00ff
+
+/* TIMOFF1 */
+#define	R367TER_TIMOFF1	0xf02f
+#define	F367TER_TIM_OFFSET_LOOP_OPEN_HI	0xf02f00ff
+
+/* TIMOFF2 */
+#define	R367TER_TIMOFF2	0xf030
+#define	F367TER_TIM_OFFSET_LOOP_OPEN_LO	0xf03000ff
+
+/* EPQ */
+#define	R367TER_EPQ	0xf031
+#define	F367TER_EPQ1	0xf03100ff
+
+/* EPQAUTO */
+#define	R367TER_EPQAUTO	0xf032
+#define	F367TER_EPQ2	0xf03200ff
+
+/* SYR_UPDATE */
+#define	R367TER_SYR_UPDATE	0xf033
+#define	F367TER_SYR_PROTV	0xf0330080
+#define	F367TER_SYR_PROTV_GAIN	0xf0330060
+#define	F367TER_SYR_FILTER	0xf0330010
+#define	F367TER_SYR_TRACK_THRES	0xf033000c
+
+/* CHPFREE */
+#define	R367TER_CHPFREE	0xf034
+#define	F367TER_CHP_FREE	0xf03400ff
+
+/* PPM_STATE_MAC */
+#define	R367TER_PPM_STATE_MAC	0xf035
+#define	F367TER_PPM_STATE_MACHINE_DECODER	0xf035003f
+
+/* INR_THRESHOLD */
+#define	R367TER_INR_THRESHOLD	0xf036
+#define	F367TER_INR_THRESH	0xf03600ff
+
+/* EPQ_TPS_ID_CELL */
+#define	R367TER_EPQ_TPS_ID_CELL	0xf037
+#define	F367TER_ENABLE_LGTH_TO_CF	0xf0370080
+#define	F367TER_DIS_TPS_RSVD	0xf0370040
+#define	F367TER_DIS_BCH	0xf0370020
+#define	F367TER_DIS_ID_CEL	0xf0370010
+#define	F367TER_TPS_ADJUST_SYM	0xf037000f
+
+/* EPQ_CFG */
+#define	R367TER_EPQ_CFG	0xf038
+#define	F367TER_EPQ_RANGE	0xf0380002
+#define	F367TER_EPQ_SOFT	0xf0380001
+
+/* EPQ_STATUS */
+#define	R367TER_EPQ_STATUS	0xf039
+#define	F367TER_SLOPE_INC	0xf03900fc
+#define	F367TER_TPS_FIELD	0xf0390003
+
+/* AUTORELOCK */
+#define	R367TER_AUTORELOCK	0xf03a
+#define	F367TER_BYPASS_BER_TEMPO	0xf03a0080
+#define	F367TER_BER_TEMPO	0xf03a0070
+#define	F367TER_BYPASS_COFDM_TEMPO	0xf03a0008
+#define	F367TER_COFDM_TEMPO	0xf03a0007
+
+/* BER_THR_VMSB */
+#define	R367TER_BER_THR_VMSB	0xf03b
+#define	F367TER_BER_THRESHOLD_HI	0xf03b00ff
+
+/* BER_THR_MSB */
+#define	R367TER_BER_THR_MSB	0xf03c
+#define	F367TER_BER_THRESHOLD_MID	0xf03c00ff
+
+/* BER_THR_LSB */
+#define	R367TER_BER_THR_LSB	0xf03d
+#define	F367TER_BER_THRESHOLD_LO	0xf03d00ff
+
+/* CCD */
+#define	R367TER_CCD	0xf03e
+#define	F367TER_CCD_DETECTED	0xf03e0080
+#define	F367TER_CCD_RESET	0xf03e0040
+#define	F367TER_CCD_THRESHOLD	0xf03e000f
+
+/* SPECTR_CFG */
+#define	R367TER_SPECTR_CFG	0xf03f
+#define	F367TER_SPECT_CFG	0xf03f0003
+
+/* CONSTMU_MSB */
+#define	R367TER_CONSTMU_MSB	0xf040
+#define	F367TER_CONSTMU_FREEZE	0xf0400080
+#define	F367TER_CONSTNU_FORCE_EN	0xf0400040
+#define	F367TER_CONST_MU_MSB	0xf040003f
+
+/* CONSTMU_LSB */
+#define	R367TER_CONSTMU_LSB	0xf041
+#define	F367TER_CONST_MU_LSB	0xf04100ff
+
+/* CONSTMU_MAX_MSB */
+#define	R367TER_CONSTMU_MAX_MSB	0xf042
+#define	F367TER_CONST_MU_MAX_MSB	0xf042003f
+
+/* CONSTMU_MAX_LSB */
+#define	R367TER_CONSTMU_MAX_LSB	0xf043
+#define	F367TER_CONST_MU_MAX_LSB	0xf04300ff
+
+/* ALPHANOISE */
+#define	R367TER_ALPHANOISE	0xf044
+#define	F367TER_USE_ALLFILTER	0xf0440080
+#define	F367TER_INTER_ON	0xf0440040
+#define	F367TER_ALPHA_NOISE	0xf044001f
+
+/* MAXGP_MSB */
+#define	R367TER_MAXGP_MSB	0xf045
+#define	F367TER_MUFILTER_LENGTH	0xf04500f0
+#define	F367TER_MAX_GP_MSB	0xf045000f
+
+/* MAXGP_LSB */
+#define	R367TER_MAXGP_LSB	0xf046
+#define	F367TER_MAX_GP_LSB	0xf04600ff
+
+/* ALPHAMSB */
+#define	R367TER_ALPHAMSB	0xf047
+#define	F367TER_CHC_DATARATE	0xf04700c0
+#define	F367TER_ALPHA_MSB	0xf047003f
+
+/* ALPHALSB */
+#define	R367TER_ALPHALSB	0xf048
+#define	F367TER_ALPHA_LSB	0xf04800ff
+
+/* PILOT_ACCU */
+#define	R367TER_PILOT_ACCU	0xf049
+#define	F367TER_USE_SCAT4ADDAPT	0xf0490080
+#define	F367TER_PILOT_ACC	0xf049001f
+
+/* PILOTMU_ACCU */
+#define	R367TER_PILOTMU_ACCU	0xf04a
+#define	F367TER_DISCARD_BAD_SP	0xf04a0080
+#define	F367TER_DISCARD_BAD_CP	0xf04a0040
+#define	F367TER_PILOT_MU_ACCU	0xf04a001f
+
+/* FILT_CHANNEL_EST */
+#define	R367TER_FILT_CHANNEL_EST	0xf04b
+#define	F367TER_USE_FILT_PILOT	0xf04b0080
+#define	F367TER_FILT_CHANNEL	0xf04b007f
+
+/* ALPHA_NOPISE_FREQ */
+#define	R367TER_ALPHA_NOPISE_FREQ	0xf04c
+#define	F367TER_NOISE_FREQ_FILT	0xf04c0040
+#define	F367TER_ALPHA_NOISE_FREQ	0xf04c003f
+
+/* RATIO_PILOT */
+#define	R367TER_RATIO_PILOT	0xf04d
+#define	F367TER_RATIO_MEAN_SP	0xf04d00f0
+#define	F367TER_RATIO_MEAN_CP	0xf04d000f
+
+/* CHC_CTL */
+#define	R367TER_CHC_CTL	0xf04e
+#define	F367TER_TRACK_EN	0xf04e0080
+#define	F367TER_NOISE_NORM_EN	0xf04e0040
+#define	F367TER_FORCE_CHC_RESET	0xf04e0020
+#define	F367TER_SHORT_TIME	0xf04e0010
+#define	F367TER_FORCE_STATE_EN	0xf04e0008
+#define	F367TER_FORCE_STATE	0xf04e0007
+
+/* EPQ_ADJUST */
+#define	R367TER_EPQ_ADJUST	0xf04f
+#define	F367TER_ADJUST_SCAT_IND	0xf04f00c0
+#define	F367TER_ONE_SYMBOL	0xf04f0010
+#define	F367TER_EPQ_DECAY	0xf04f000e
+#define	F367TER_HOLD_SLOPE	0xf04f0001
+
+/* EPQ_THRES */
+#define	R367TER_EPQ_THRES	0xf050
+#define	F367TER_EPQ_THR	0xf05000ff
+
+/* OMEGA_CTL */
+#define	R367TER_OMEGA_CTL	0xf051
+#define	F367TER_OMEGA_RST	0xf0510080
+#define	F367TER_FREEZE_OMEGA	0xf0510040
+#define	F367TER_OMEGA_SEL	0xf051003f
+
+/* GP_CTL */
+#define	R367TER_GP_CTL	0xf052
+#define	F367TER_CHC_STATE	0xf05200e0
+#define	F367TER_FREEZE_GP	0xf0520010
+#define	F367TER_GP_SEL	0xf052000f
+
+/* MUMSB */
+#define	R367TER_MUMSB	0xf053
+#define	F367TER_MU_MSB	0xf053007f
+
+/* MULSB */
+#define	R367TER_MULSB	0xf054
+#define	F367TER_MU_LSB	0xf05400ff
+
+/* GPMSB */
+#define	R367TER_GPMSB	0xf055
+#define	F367TER_CSI_THRESHOLD	0xf05500e0
+#define	F367TER_GP_MSB	0xf055000f
+
+/* GPLSB */
+#define	R367TER_GPLSB	0xf056
+#define	F367TER_GP_LSB	0xf05600ff
+
+/* OMEGAMSB */
+#define	R367TER_OMEGAMSB	0xf057
+#define	F367TER_OMEGA_MSB	0xf057007f
+
+/* OMEGALSB */
+#define	R367TER_OMEGALSB	0xf058
+#define	F367TER_OMEGA_LSB	0xf05800ff
+
+/* SCAT_NB */
+#define	R367TER_SCAT_NB	0xf059
+#define	F367TER_CHC_TEST	0xf05900f8
+#define	F367TER_SCAT_NUMB	0xf0590003
+
+/* CHC_DUMMY */
+#define	R367TER_CHC_DUMMY	0xf05a
+#define	F367TER_CHC_DUM	0xf05a00ff
+
+/* INC_CTL */
+#define	R367TER_INC_CTL	0xf05b
+#define	F367TER_INC_BYPASS	0xf05b0080
+#define	F367TER_INC_NDEPTH	0xf05b000c
+#define	F367TER_INC_MADEPTH	0xf05b0003
+
+/* INCTHRES_COR1 */
+#define	R367TER_INCTHRES_COR1	0xf05c
+#define	F367TER_INC_THRES_COR1	0xf05c00ff
+
+/* INCTHRES_COR2 */
+#define	R367TER_INCTHRES_COR2	0xf05d
+#define	F367TER_INC_THRES_COR2	0xf05d00ff
+
+/* INCTHRES_DET1 */
+#define	R367TER_INCTHRES_DET1	0xf05e
+#define	F367TER_INC_THRES_DET1	0xf05e003f
+
+/* INCTHRES_DET2 */
+#define	R367TER_INCTHRES_DET2	0xf05f
+#define	F367TER_INC_THRES_DET2	0xf05f003f
+
+/* IIR_CELLNB */
+#define	R367TER_IIR_CELLNB	0xf060
+#define	F367TER_NRST_IIR	0xf0600080
+#define	F367TER_IIR_CELL_NB	0xf0600007
+
+/* IIRCX_COEFF1_MSB */
+#define	R367TER_IIRCX_COEFF1_MSB	0xf061
+#define	F367TER_IIR_CX_COEFF1_MSB	0xf06100ff
+
+/* IIRCX_COEFF1_LSB */
+#define	R367TER_IIRCX_COEFF1_LSB	0xf062
+#define	F367TER_IIR_CX_COEFF1_LSB	0xf06200ff
+
+/* IIRCX_COEFF2_MSB */
+#define	R367TER_IIRCX_COEFF2_MSB	0xf063
+#define	F367TER_IIR_CX_COEFF2_MSB	0xf06300ff
+
+/* IIRCX_COEFF2_LSB */
+#define	R367TER_IIRCX_COEFF2_LSB	0xf064
+#define	F367TER_IIR_CX_COEFF2_LSB	0xf06400ff
+
+/* IIRCX_COEFF3_MSB */
+#define	R367TER_IIRCX_COEFF3_MSB	0xf065
+#define	F367TER_IIR_CX_COEFF3_MSB	0xf06500ff
+
+/* IIRCX_COEFF3_LSB */
+#define	R367TER_IIRCX_COEFF3_LSB	0xf066
+#define	F367TER_IIR_CX_COEFF3_LSB	0xf06600ff
+
+/* IIRCX_COEFF4_MSB */
+#define	R367TER_IIRCX_COEFF4_MSB	0xf067
+#define	F367TER_IIR_CX_COEFF4_MSB	0xf06700ff
+
+/* IIRCX_COEFF4_LSB */
+#define	R367TER_IIRCX_COEFF4_LSB	0xf068
+#define	F367TER_IIR_CX_COEFF4_LSB	0xf06800ff
+
+/* IIRCX_COEFF5_MSB */
+#define	R367TER_IIRCX_COEFF5_MSB	0xf069
+#define	F367TER_IIR_CX_COEFF5_MSB	0xf06900ff
+
+/* IIRCX_COEFF5_LSB */
+#define	R367TER_IIRCX_COEFF5_LSB	0xf06a
+#define	F367TER_IIR_CX_COEFF5_LSB	0xf06a00ff
+
+/* FEPATH_CFG */
+#define	R367TER_FEPATH_CFG	0xf06b
+#define	F367TER_DEMUX_SWAP	0xf06b0004
+#define	F367TER_DIGAGC_SWAP	0xf06b0002
+#define	F367TER_LONGPATH_IF	0xf06b0001
+
+/* PMC1_FUNC */
+#define	R367TER_PMC1_FUNC	0xf06c
+#define	F367TER_SOFT_RSTN	0xf06c0080
+#define	F367TER_PMC1_AVERAGE_TIME	0xf06c0078
+#define	F367TER_PMC1_WAIT_TIME	0xf06c0006
+#define	F367TER_PMC1_2N_SEL	0xf06c0001
+
+/* PMC1_FOR */
+#define	R367TER_PMC1_FOR	0xf06d
+#define	F367TER_PMC1_FORCE	0xf06d0080
+#define	F367TER_PMC1_FORCE_VALUE	0xf06d007c
+
+/* PMC2_FUNC */
+#define	R367TER_PMC2_FUNC	0xf06e
+#define	F367TER_PMC2_SOFT_STN	0xf06e0080
+#define	F367TER_PMC2_ACCU_TIME	0xf06e0070
+#define	F367TER_PMC2_CMDP_MN	0xf06e0008
+#define	F367TER_PMC2_SWAP	0xf06e0004
+
+/* STATUS_ERR_DA */
+#define	R367TER_STATUS_ERR_DA	0xf06f
+#define	F367TER_COM_USEGAINTRK	0xf06f0080
+#define	F367TER_COM_AGCLOCK	0xf06f0040
+#define	F367TER_AUT_AGCLOCK	0xf06f0020
+#define	F367TER_MIN_ERR_X_LSB	0xf06f000f
+
+/* DIG_AGC_R */
+#define	R367TER_DIG_AGC_R	0xf070
+#define	F367TER_COM_SOFT_RSTN	0xf0700080
+#define	F367TER_COM_AGC_ON	0xf0700040
+#define	F367TER_COM_EARLY	0xf0700020
+#define	F367TER_AUT_SOFT_RESETN	0xf0700010
+#define	F367TER_AUT_AGC_ON	0xf0700008
+#define	F367TER_AUT_EARLY	0xf0700004
+#define	F367TER_AUT_ROT_EN	0xf0700002
+#define	F367TER_LOCK_SOFT_RESETN	0xf0700001
+
+/* COMAGC_TARMSB */
+#define	R367TER_COMAGC_TARMSB	0xf071
+#define	F367TER_COM_AGC_TARGET_MSB	0xf07100ff
+
+/* COM_AGC_TAR_ENMODE */
+#define	R367TER_COM_AGC_TAR_ENMODE	0xf072
+#define	F367TER_COM_AGC_TARGET_LSB	0xf07200f0
+#define	F367TER_COM_ENMODE	0xf072000f
+
+/* COM_AGC_CFG */
+#define	R367TER_COM_AGC_CFG	0xf073
+#define	F367TER_COM_N	0xf07300f8
+#define	F367TER_COM_STABMODE	0xf0730006
+#define	F367TER_ERR_SEL	0xf0730001
+
+/* COM_AGC_GAIN1 */
+#define	R367TER_COM_AGC_GAIN1	0xf074
+#define	F367TER_COM_GAIN1aCK	0xf07400f0
+#define	F367TER_COM_GAIN1TRK	0xf074000f
+
+/* AUT_AGC_TARGETMSB */
+#define	R367TER_AUT_AGC_TARGETMSB	0xf075
+#define	F367TER_AUT_AGC_TARGET_MSB	0xf07500ff
+
+/* LOCK_DET_MSB */
+#define	R367TER_LOCK_DET_MSB	0xf076
+#define	F367TER_LOCK_DETECT_MSB	0xf07600ff
+
+/* AGCTAR_LOCK_LSBS */
+#define	R367TER_AGCTAR_LOCK_LSBS	0xf077
+#define	F367TER_AUT_AGC_TARGET_LSB	0xf07700f0
+#define	F367TER_LOCK_DETECT_LSB	0xf077000f
+
+/* AUT_GAIN_EN */
+#define	R367TER_AUT_GAIN_EN	0xf078
+#define	F367TER_AUT_ENMODE	0xf07800f0
+#define	F367TER_AUT_GAIN2	0xf078000f
+
+/* AUT_CFG */
+#define	R367TER_AUT_CFG	0xf079
+#define	F367TER_AUT_N	0xf07900f8
+#define	F367TER_INT_CHOICE	0xf0790006
+#define	F367TER_INT_LOAD	0xf0790001
+
+/* LOCKN */
+#define	R367TER_LOCKN	0xf07a
+#define	F367TER_LOCK_N	0xf07a00f8
+#define	F367TER_SEL_IQNTAR	0xf07a0004
+#define	F367TER_LOCK_DETECT_CHOICE	0xf07a0003
+
+/* INT_X_3 */
+#define	R367TER_INT_X_3	0xf07b
+#define	F367TER_INT_X3	0xf07b00ff
+
+/* INT_X_2 */
+#define	R367TER_INT_X_2	0xf07c
+#define	F367TER_INT_X2	0xf07c00ff
+
+/* INT_X_1 */
+#define	R367TER_INT_X_1	0xf07d
+#define	F367TER_INT_X1	0xf07d00ff
+
+/* INT_X_0 */
+#define	R367TER_INT_X_0	0xf07e
+#define	F367TER_INT_X0	0xf07e00ff
+
+/* MIN_ERRX_MSB */
+#define	R367TER_MIN_ERRX_MSB	0xf07f
+#define	F367TER_MIN_ERR_X_MSB	0xf07f00ff
+
+/* COR_CTL */
+#define	R367TER_COR_CTL	0xf080
+#define	F367TER_CORE_ACTIVE	0xf0800020
+#define	F367TER_HOLD	0xf0800010
+#define	F367TER_CORE_STATE_CTL	0xf080000f
+
+/* COR_STAT */
+#define	R367TER_COR_STAT	0xf081
+#define	F367TER_SCATT_LOCKED	0xf0810080
+#define	F367TER_TPS_LOCKED	0xf0810040
+#define	F367TER_SYR_LOCKED_COR	0xf0810020
+#define	F367TER_AGC_LOCKED_STAT	0xf0810010
+#define	F367TER_CORE_STATE_STAT	0xf081000f
+
+/* COR_INTEN */
+#define	R367TER_COR_INTEN	0xf082
+#define	F367TER_INTEN	0xf0820080
+#define	F367TER_INTEN_SYR	0xf0820020
+#define	F367TER_INTEN_FFT	0xf0820010
+#define	F367TER_INTEN_AGC	0xf0820008
+#define	F367TER_INTEN_TPS1	0xf0820004
+#define	F367TER_INTEN_TPS2	0xf0820002
+#define	F367TER_INTEN_TPS3	0xf0820001
+
+/* COR_INTSTAT */
+#define	R367TER_COR_INTSTAT	0xf083
+#define	F367TER_INTSTAT_SYR	0xf0830020
+#define	F367TER_INTSTAT_FFT	0xf0830010
+#define	F367TER_INTSAT_AGC	0xf0830008
+#define	F367TER_INTSTAT_TPS1	0xf0830004
+#define	F367TER_INTSTAT_TPS2	0xf0830002
+#define	F367TER_INTSTAT_TPS3	0xf0830001
+
+/* COR_MODEGUARD */
+#define	R367TER_COR_MODEGUARD	0xf084
+#define	F367TER_FORCE	0xf0840010
+#define	F367TER_MODE	0xf084000c
+#define	F367TER_GUARD	0xf0840003
+
+/* AGC_CTL */
+#define	R367TER_AGC_CTL	0xf085
+#define	F367TER_AGC_TIMING_FACTOR	0xf08500e0
+#define	F367TER_AGC_LAST	0xf0850010
+#define	F367TER_AGC_GAIN	0xf085000c
+#define	F367TER_AGC_NEG	0xf0850002
+#define	F367TER_AGC_SET	0xf0850001
+
+/* AGC_MANUAL1 */
+#define	R367TER_AGC_MANUAL1	0xf086
+#define	F367TER_AGC_VAL_LO	0xf08600ff
+
+/* AGC_MANUAL2 */
+#define	R367TER_AGC_MANUAL2	0xf087
+#define	F367TER_AGC_VAL_HI	0xf087000f
+
+/* AGC_TARG */
+#define	R367TER_AGC_TARG	0xf088
+#define	F367TER_AGC_TARGET	0xf08800ff
+
+/* AGC_GAIN1 */
+#define	R367TER_AGC_GAIN1	0xf089
+#define	F367TER_AGC_GAIN_LO	0xf08900ff
+
+/* AGC_GAIN2 */
+#define	R367TER_AGC_GAIN2	0xf08a
+#define	F367TER_AGC_LOCKED_GAIN2	0xf08a0010
+#define	F367TER_AGC_GAIN_HI	0xf08a000f
+
+/* RESERVED_1 */
+#define	R367TER_RESERVED_1	0xf08b
+#define	F367TER_RESERVED1	0xf08b00ff
+
+/* RESERVED_2 */
+#define	R367TER_RESERVED_2	0xf08c
+#define	F367TER_RESERVED2	0xf08c00ff
+
+/* RESERVED_3 */
+#define	R367TER_RESERVED_3	0xf08d
+#define	F367TER_RESERVED3	0xf08d00ff
+
+/* CAS_CTL */
+#define	R367TER_CAS_CTL	0xf08e
+#define	F367TER_CCS_ENABLE	0xf08e0080
+#define	F367TER_ACS_DISABLE	0xf08e0040
+#define	F367TER_DAGC_DIS	0xf08e0020
+#define	F367TER_DAGC_GAIN	0xf08e0018
+#define	F367TER_CCSMU	0xf08e0007
+
+/* CAS_FREQ */
+#define	R367TER_CAS_FREQ	0xf08f
+#define	F367TER_CCS_FREQ	0xf08f00ff
+
+/* CAS_DAGCGAIN */
+#define	R367TER_CAS_DAGCGAIN	0xf090
+#define	F367TER_CAS_DAGC_GAIN	0xf09000ff
+
+/* SYR_CTL */
+#define	R367TER_SYR_CTL	0xf091
+#define	F367TER_SICTH_ENABLE	0xf0910080
+#define	F367TER_LONG_ECHO	0xf0910078
+#define	F367TER_AUTO_LE_EN	0xf0910004
+#define	F367TER_SYR_BYPASS	0xf0910002
+#define	F367TER_SYR_TR_DIS	0xf0910001
+
+/* SYR_STAT */
+#define	R367TER_SYR_STAT	0xf092
+#define	F367TER_SYR_LOCKED_STAT	0xf0920010
+#define	F367TER_SYR_MODE	0xf092000c
+#define	F367TER_SYR_GUARD	0xf0920003
+
+/* SYR_NCO1 */
+#define	R367TER_SYR_NCO1	0xf093
+#define	F367TER_SYR_NCO_LO	0xf09300ff
+
+/* SYR_NCO2 */
+#define	R367TER_SYR_NCO2	0xf094
+#define	F367TER_SYR_NCO_HI	0xf094003f
+
+/* SYR_OFFSET1 */
+#define	R367TER_SYR_OFFSET1	0xf095
+#define	F367TER_SYR_OFFSET_LO	0xf09500ff
+
+/* SYR_OFFSET2 */
+#define	R367TER_SYR_OFFSET2	0xf096
+#define	F367TER_SYR_OFFSET_HI	0xf096003f
+
+/* FFT_CTL */
+#define	R367TER_FFT_CTL	0xf097
+#define	F367TER_SHIFT_FFT_TRIG	0xf0970018
+#define	F367TER_FFT_TRIGGER	0xf0970004
+#define	F367TER_FFT_MANUAL	0xf0970002
+#define	F367TER_IFFT_MODE	0xf0970001
+
+/* SCR_CTL */
+#define	R367TER_SCR_CTL	0xf098
+#define	F367TER_SYRADJDECAY	0xf0980070
+#define	F367TER_SCR_CPEDIS	0xf0980002
+#define	F367TER_SCR_DIS	0xf0980001
+
+/* PPM_CTL1 */
+#define	R367TER_PPM_CTL1	0xf099
+#define	F367TER_PPM_MAXFREQ	0xf0990030
+#define	F367TER_PPM_MAXTIM	0xf0990008
+#define	F367TER_PPM_INVSEL	0xf0990004
+#define	F367TER_PPM_SCATDIS	0xf0990002
+#define	F367TER_PPM_BYP	0xf0990001
+
+/* TRL_CTL */
+#define	R367TER_TRL_CTL	0xf09a
+#define	F367TER_TRL_NOMRATE_LSB	0xf09a0080
+#define	F367TER_TRL_GAIN_FACTOR	0xf09a0078
+#define	F367TER_TRL_LOOPGAIN	0xf09a0007
+
+/* TRL_NOMRATE1 */
+#define	R367TER_TRL_NOMRATE1	0xf09b
+#define	F367TER_TRL_NOMRATE_LO	0xf09b00ff
+
+/* TRL_NOMRATE2 */
+#define	R367TER_TRL_NOMRATE2	0xf09c
+#define	F367TER_TRL_NOMRATE_HI	0xf09c00ff
+
+/* TRL_TIME1 */
+#define	R367TER_TRL_TIME1	0xf09d
+#define	F367TER_TRL_TOFFSET_LO	0xf09d00ff
+
+/* TRL_TIME2 */
+#define	R367TER_TRL_TIME2	0xf09e
+#define	F367TER_TRL_TOFFSET_HI	0xf09e00ff
+
+/* CRL_CTL */
+#define	R367TER_CRL_CTL	0xf09f
+#define	F367TER_CRL_DIS	0xf09f0080
+#define	F367TER_CRL_GAIN_FACTOR	0xf09f0078
+#define	F367TER_CRL_LOOPGAIN	0xf09f0007
+
+/* CRL_FREQ1 */
+#define	R367TER_CRL_FREQ1	0xf0a0
+#define	F367TER_CRL_FOFFSET_LO	0xf0a000ff
+
+/* CRL_FREQ2 */
+#define	R367TER_CRL_FREQ2	0xf0a1
+#define	F367TER_CRL_FOFFSET_HI	0xf0a100ff
+
+/* CRL_FREQ3 */
+#define	R367TER_CRL_FREQ3	0xf0a2
+#define	F367TER_CRL_FOFFSET_VHI	0xf0a200ff
+
+/* TPS_SFRAME_CTL */
+#define	R367TER_TPS_SFRAME_CTL	0xf0a3
+#define	F367TER_TPS_SFRAME_SYNC	0xf0a30001
+
+/* CHC_SNR */
+#define	R367TER_CHC_SNR	0xf0a4
+#define	F367TER_CHCSNR	0xf0a400ff
+
+/* BDI_CTL */
+#define	R367TER_BDI_CTL	0xf0a5
+#define	F367TER_BDI_LPSEL	0xf0a50002
+#define	F367TER_BDI_SERIAL	0xf0a50001
+
+/* DMP_CTL */
+#define	R367TER_DMP_CTL	0xf0a6
+#define	F367TER_DMP_SCALING_FACTOR	0xf0a6001e
+#define	F367TER_DMP_SDDIS	0xf0a60001
+
+/* TPS_RCVD1 */
+#define	R367TER_TPS_RCVD1	0xf0a7
+#define	F367TER_TPS_CHANGE	0xf0a70040
+#define	F367TER_BCH_OK	0xf0a70020
+#define	F367TER_TPS_SYNC	0xf0a70010
+#define	F367TER_TPS_FRAME	0xf0a70003
+
+/* TPS_RCVD2 */
+#define	R367TER_TPS_RCVD2	0xf0a8
+#define	F367TER_TPS_HIERMODE	0xf0a80070
+#define	F367TER_TPS_CONST	0xf0a80003
+
+/* TPS_RCVD3 */
+#define	R367TER_TPS_RCVD3	0xf0a9
+#define	F367TER_TPS_LPCODE	0xf0a90070
+#define	F367TER_TPS_HPCODE	0xf0a90007
+
+/* TPS_RCVD4 */
+#define	R367TER_TPS_RCVD4	0xf0aa
+#define	F367TER_TPS_GUARD	0xf0aa0030
+#define	F367TER_TPS_MODE	0xf0aa0003
+
+/* TPS_ID_CELL1 */
+#define	R367TER_TPS_ID_CELL1	0xf0ab
+#define	F367TER_TPS_ID_CELL_LO	0xf0ab00ff
+
+/* TPS_ID_CELL2 */
+#define	R367TER_TPS_ID_CELL2	0xf0ac
+#define	F367TER_TPS_ID_CELL_HI	0xf0ac00ff
+
+/* TPS_RCVD5_SET1 */
+#define	R367TER_TPS_RCVD5_SET1	0xf0ad
+#define	F367TER_TPS_NA	0xf0ad00fC
+#define	F367TER_TPS_SETFRAME	0xf0ad0003
+
+/* TPS_SET2 */
+#define	R367TER_TPS_SET2	0xf0ae
+#define	F367TER_TPS_SETHIERMODE	0xf0ae0070
+#define	F367TER_TPS_SETCONST	0xf0ae0003
+
+/* TPS_SET3 */
+#define	R367TER_TPS_SET3	0xf0af
+#define	F367TER_TPS_SETLPCODE	0xf0af0070
+#define	F367TER_TPS_SETHPCODE	0xf0af0007
+
+/* TPS_CTL */
+#define	R367TER_TPS_CTL	0xf0b0
+#define	F367TER_TPS_IMM	0xf0b00004
+#define	F367TER_TPS_BCHDIS	0xf0b00002
+#define	F367TER_TPS_UPDDIS	0xf0b00001
+
+/* CTL_FFTOSNUM */
+#define	R367TER_CTL_FFTOSNUM	0xf0b1
+#define	F367TER_SYMBOL_NUMBER	0xf0b1007f
+
+/* TESTSELECT */
+#define	R367TER_TESTSELECT	0xf0b2
+#define	F367TER_TEST_SELECT	0xf0b2001f
+
+/* MSC_REV */
+#define	R367TER_MSC_REV	0xf0b3
+#define	F367TER_REV_NUMBER	0xf0b300ff
+
+/* PIR_CTL */
+#define	R367TER_PIR_CTL	0xf0b4
+#define	F367TER_FREEZE	0xf0b40001
+
+/* SNR_CARRIER1 */
+#define	R367TER_SNR_CARRIER1	0xf0b5
+#define	F367TER_SNR_CARRIER_LO	0xf0b500ff
+
+/* SNR_CARRIER2 */
+#define	R367TER_SNR_CARRIER2	0xf0b6
+#define	F367TER_MEAN	0xf0b600c0
+#define	F367TER_SNR_CARRIER_HI	0xf0b6001f
+
+/* PPM_CPAMP */
+#define	R367TER_PPM_CPAMP	0xf0b7
+#define	F367TER_PPM_CPC	0xf0b700ff
+
+/* TSM_AP0 */
+#define	R367TER_TSM_AP0	0xf0b8
+#define	F367TER_ADDRESS_BYTE_0	0xf0b800ff
+
+/* TSM_AP1 */
+#define	R367TER_TSM_AP1	0xf0b9
+#define	F367TER_ADDRESS_BYTE_1	0xf0b900ff
+
+/* TSM_AP2 */
+#define	R367TER_TSM_AP2	0xf0bA
+#define	F367TER_DATA_BYTE_0	0xf0ba00ff
+
+/* TSM_AP3 */
+#define	R367TER_TSM_AP3	0xf0bB
+#define	F367TER_DATA_BYTE_1	0xf0bb00ff
+
+/* TSM_AP4 */
+#define	R367TER_TSM_AP4	0xf0bC
+#define	F367TER_DATA_BYTE_2	0xf0bc00ff
+
+/* TSM_AP5 */
+#define	R367TER_TSM_AP5	0xf0bD
+#define	F367TER_DATA_BYTE_3	0xf0bd00ff
+
+/* TSM_AP6 */
+#define	R367TER_TSM_AP6	0xf0bE
+#define	F367TER_TSM_AP_6	0xf0be00ff
+
+/* TSM_AP7 */
+#define	R367TER_TSM_AP7	0xf0bF
+#define	F367TER_MEM_SELECT_BYTE	0xf0bf00ff
+
+/* TSTRES */
+#define	R367TER_TSTRES	0xf0c0
+#define	F367TER_FRES_DISPLAY	0xf0c00080
+#define	F367TER_FRES_FIFO_AD	0xf0c00020
+#define	F367TER_FRESRS	0xf0c00010
+#define	F367TER_FRESACS	0xf0c00008
+#define	F367TER_FRESFEC	0xf0c00004
+#define	F367TER_FRES_PRIF	0xf0c00002
+#define	F367TER_FRESCORE	0xf0c00001
+
+/* ANACTRL */
+#define	R367TER_ANACTRL	0xf0c1
+#define	F367TER_BYPASS_XTAL	0xf0c10040
+#define	F367TER_BYPASS_PLLXN	0xf0c1000c
+#define	F367TER_DIS_PAD_OSC	0xf0c10002
+#define	F367TER_STDBY_PLLXN	0xf0c10001
+
+/* TSTBUS */
+#define	R367TER_TSTBUS	0xf0c2
+#define	F367TER_TS_BYTE_CLK_INV	0xf0c20080
+#define	F367TER_CFG_IP	0xf0c20070
+#define	F367TER_CFG_TST	0xf0c2000f
+
+/* TSTRATE */
+#define	R367TER_TSTRATE	0xf0c6
+#define	F367TER_FORCEPHA	0xf0c60080
+#define	F367TER_FNEWPHA	0xf0c60010
+#define	F367TER_FROT90	0xf0c60008
+#define	F367TER_FR	0xf0c60007
+
+/* CONSTMODE */
+#define	R367TER_CONSTMODE	0xf0cb
+#define	F367TER_TST_PRIF	0xf0cb00e0
+#define	F367TER_CAR_TYPE	0xf0cb0018
+#define	F367TER_CONST_MODE	0xf0cb0003
+
+/* CONSTCARR1 */
+#define	R367TER_CONSTCARR1	0xf0cc
+#define	F367TER_CONST_CARR_LO	0xf0cc00ff
+
+/* CONSTCARR2 */
+#define	R367TER_CONSTCARR2	0xf0cd
+#define	F367TER_CONST_CARR_HI	0xf0cd001f
+
+/* ICONSTEL */
+#define	R367TER_ICONSTEL	0xf0ce
+#define	F367TER_PICONSTEL	0xf0ce00ff
+
+/* QCONSTEL */
+#define	R367TER_QCONSTEL	0xf0cf
+#define	F367TER_PQCONSTEL	0xf0cf00ff
+
+/* TSTBISTRES0 */
+#define	R367TER_TSTBISTRES0	0xf0d0
+#define	F367TER_BEND_PPM	0xf0d00080
+#define	F367TER_BBAD_PPM	0xf0d00040
+#define	F367TER_BEND_FFTW	0xf0d00020
+#define	F367TER_BBAD_FFTW	0xf0d00010
+#define	F367TER_BEND_FFT_BUF	0xf0d00008
+#define	F367TER_BBAD_FFT_BUF	0xf0d00004
+#define	F367TER_BEND_SYR	0xf0d00002
+#define	F367TER_BBAD_SYR	0xf0d00001
+
+/* TSTBISTRES1 */
+#define	R367TER_TSTBISTRES1	0xf0d1
+#define	F367TER_BEND_CHC_CP	0xf0d10080
+#define	F367TER_BBAD_CHC_CP	0xf0d10040
+#define	F367TER_BEND_CHCI	0xf0d10020
+#define	F367TER_BBAD_CHCI	0xf0d10010
+#define	F367TER_BEND_BDI	0xf0d10008
+#define	F367TER_BBAD_BDI	0xf0d10004
+#define	F367TER_BEND_SDI	0xf0d10002
+#define	F367TER_BBAD_SDI	0xf0d10001
+
+/* TSTBISTRES2 */
+#define	R367TER_TSTBISTRES2	0xf0d2
+#define	F367TER_BEND_CHC_INC	0xf0d20080
+#define	F367TER_BBAD_CHC_INC	0xf0d20040
+#define	F367TER_BEND_CHC_SPP	0xf0d20020
+#define	F367TER_BBAD_CHC_SPP	0xf0d20010
+#define	F367TER_BEND_CHC_CPP	0xf0d20008
+#define	F367TER_BBAD_CHC_CPP	0xf0d20004
+#define	F367TER_BEND_CHC_SP	0xf0d20002
+#define	F367TER_BBAD_CHC_SP	0xf0d20001
+
+/* TSTBISTRES3 */
+#define	R367TER_TSTBISTRES3	0xf0d3
+#define	F367TER_BEND_QAM	0xf0d30080
+#define	F367TER_BBAD_QAM	0xf0d30040
+#define	F367TER_BEND_SFEC_VIT	0xf0d30020
+#define	F367TER_BBAD_SFEC_VIT	0xf0d30010
+#define	F367TER_BEND_SFEC_DLINE	0xf0d30008
+#define	F367TER_BBAD_SFEC_DLINE	0xf0d30004
+#define	F367TER_BEND_SFEC_HW	0xf0d30002
+#define	F367TER_BBAD_SFEC_HW	0xf0d30001
+
+/* RF_AGC1 */
+#define	R367TER_RF_AGC1	0xf0d4
+#define	F367TER_RF_AGC1_LEVEL_HI	0xf0d400ff
+
+/* RF_AGC2 */
+#define	R367TER_RF_AGC2	0xf0d5
+#define	F367TER_REF_ADGP	0xf0d50080
+#define	F367TER_STDBY_ADCGP	0xf0d50020
+#define	F367TER_CHANNEL_SEL	0xf0d5001c
+#define	F367TER_RF_AGC1_LEVEL_LO	0xf0d50003
+
+/* ANADIGCTRL */
+#define	R367TER_ANADIGCTRL	0xf0d7
+#define	F367TER_SEL_CLKDEM	0xf0d70020
+#define	F367TER_EN_BUFFER_Q	0xf0d70010
+#define	F367TER_EN_BUFFER_I	0xf0d70008
+#define	F367TER_ADC_RIS_EGDE	0xf0d70004
+#define	F367TER_SGN_ADC	0xf0d70002
+#define	F367TER_SEL_AD12_SYNC	0xf0d70001
+
+/* PLLMDIV */
+#define	R367TER_PLLMDIV	0xf0d8
+#define	F367TER_PLL_MDIV	0xf0d800ff
+
+/* PLLNDIV */
+#define	R367TER_PLLNDIV	0xf0d9
+#define	F367TER_PLL_NDIV	0xf0d900ff
+
+/* PLLSETUP */
+#define	R367TER_PLLSETUP	0xf0dA
+#define	F367TER_PLL_PDIV	0xf0da0070
+#define	F367TER_PLL_KDIV	0xf0da000f
+
+/* DUAL_AD12 */
+#define	R367TER_DUAL_AD12	0xf0dB
+#define	F367TER_FS20M	0xf0db0020
+#define	F367TER_FS50M	0xf0db0010
+#define	F367TER_INMODe0	0xf0db0008
+#define	F367TER_POFFQ	0xf0db0004
+#define	F367TER_POFFI	0xf0db0002
+#define	F367TER_INMODE1	0xf0db0001
+
+/* TSTBIST */
+#define	R367TER_TSTBIST	0xf0dC
+#define	F367TER_TST_BYP_CLK	0xf0dc0080
+#define	F367TER_TST_GCLKENA_STD	0xf0dc0040
+#define	F367TER_TST_GCLKENA	0xf0dc0020
+#define	F367TER_TST_MEMBIST	0xf0dc001f
+
+/* PAD_COMP_CTRL */
+#define	R367TER_PAD_COMP_CTRL	0xf0dD
+#define	F367TER_COMPTQ	0xf0dd0010
+#define	F367TER_COMPEN	0xf0dd0008
+#define	F367TER_FREEZE2	0xf0dd0004
+#define	F367TER_SLEEP_INHBT	0xf0dd0002
+#define	F367TER_CHIP_SLEEP	0xf0dd0001
+
+/* PAD_COMP_WR */
+#define	R367TER_PAD_COMP_WR	0xf0de
+#define	F367TER_WR_ASRC	0xf0de007f
+
+/* PAD_COMP_RD */
+#define	R367TER_PAD_COMP_RD	0xf0df
+#define	F367TER_COMPOK	0xf0df0080
+#define	F367TER_RD_ASRC	0xf0df007f
+
+/* SYR_TARGET_FFTADJT_MSB */
+#define	R367TER_SYR_TARGET_FFTADJT_MSB	0xf100
+#define	F367TER_SYR_START	0xf1000080
+#define	F367TER_SYR_TARGET_FFTADJ_HI	0xf100000f
+
+/* SYR_TARGET_FFTADJT_LSB */
+#define	R367TER_SYR_TARGET_FFTADJT_LSB	0xf101
+#define	F367TER_SYR_TARGET_FFTADJ_LO	0xf10100ff
+
+/* SYR_TARGET_CHCADJT_MSB */
+#define	R367TER_SYR_TARGET_CHCADJT_MSB	0xf102
+#define	F367TER_SYR_TARGET_CHCADJ_HI	0xf102000f
+
+/* SYR_TARGET_CHCADJT_LSB */
+#define	R367TER_SYR_TARGET_CHCADJT_LSB	0xf103
+#define	F367TER_SYR_TARGET_CHCADJ_LO	0xf10300ff
+
+/* SYR_FLAG */
+#define	R367TER_SYR_FLAG	0xf104
+#define	F367TER_TRIG_FLG1	0xf1040080
+#define	F367TER_TRIG_FLG0	0xf1040040
+#define	F367TER_FFT_FLG1	0xf1040008
+#define	F367TER_FFT_FLG0	0xf1040004
+#define	F367TER_CHC_FLG1	0xf1040002
+#define	F367TER_CHC_FLG0	0xf1040001
+
+/* CRL_TARGET1 */
+#define	R367TER_CRL_TARGET1	0xf105
+#define	F367TER_CRL_START	0xf1050080
+#define	F367TER_CRL_TARGET_VHI	0xf105000f
+
+/* CRL_TARGET2 */
+#define	R367TER_CRL_TARGET2	0xf106
+#define	F367TER_CRL_TARGET_HI	0xf10600ff
+
+/* CRL_TARGET3 */
+#define	R367TER_CRL_TARGET3	0xf107
+#define	F367TER_CRL_TARGET_LO	0xf10700ff
+
+/* CRL_TARGET4 */
+#define	R367TER_CRL_TARGET4	0xf108
+#define	F367TER_CRL_TARGET_VLO	0xf10800ff
+
+/* CRL_FLAG */
+#define	R367TER_CRL_FLAG	0xf109
+#define	F367TER_CRL_FLAG1	0xf1090002
+#define	F367TER_CRL_FLAG0	0xf1090001
+
+/* TRL_TARGET1 */
+#define	R367TER_TRL_TARGET1	0xf10a
+#define	F367TER_TRL_TARGET_HI	0xf10a00ff
+
+/* TRL_TARGET2 */
+#define	R367TER_TRL_TARGET2	0xf10b
+#define	F367TER_TRL_TARGET_LO	0xf10b00ff
+
+/* TRL_CHC */
+#define	R367TER_TRL_CHC	0xf10c
+#define	F367TER_TRL_START	0xf10c0080
+#define	F367TER_CHC_START	0xf10c0040
+#define	F367TER_TRL_FLAG1	0xf10c0002
+#define	F367TER_TRL_FLAG0	0xf10c0001
+
+/* CHC_SNR_TARG */
+#define	R367TER_CHC_SNR_TARG	0xf10d
+#define	F367TER_CHC_SNR_TARGET	0xf10d00ff
+
+/* TOP_TRACK */
+#define	R367TER_TOP_TRACK	0xf10e
+#define	F367TER_TOP_START	0xf10e0080
+#define	F367TER_FIRST_FLAG	0xf10e0070
+#define	F367TER_TOP_FLAG1	0xf10e0008
+#define	F367TER_TOP_FLAG0	0xf10e0004
+#define	F367TER_CHC_FLAG1	0xf10e0002
+#define	F367TER_CHC_FLAG0	0xf10e0001
+
+/* TRACKER_FREE1 */
+#define	R367TER_TRACKER_FREE1	0xf10f
+#define	F367TER_TRACKER_FREE_1	0xf10f00ff
+
+/* ERROR_CRL1 */
+#define	R367TER_ERROR_CRL1	0xf110
+#define	F367TER_ERROR_CRL_VHI	0xf11000ff
+
+/* ERROR_CRL2 */
+#define	R367TER_ERROR_CRL2	0xf111
+#define	F367TER_ERROR_CRL_HI	0xf11100ff
+
+/* ERROR_CRL3 */
+#define	R367TER_ERROR_CRL3	0xf112
+#define	F367TER_ERROR_CRL_LOI	0xf11200ff
+
+/* ERROR_CRL4 */
+#define	R367TER_ERROR_CRL4	0xf113
+#define	F367TER_ERROR_CRL_VLO	0xf11300ff
+
+/* DEC_NCO1 */
+#define	R367TER_DEC_NCO1	0xf114
+#define	F367TER_DEC_NCO_VHI	0xf11400ff
+
+/* DEC_NCO2 */
+#define	R367TER_DEC_NCO2	0xf115
+#define	F367TER_DEC_NCO_HI	0xf11500ff
+
+/* DEC_NCO3 */
+#define	R367TER_DEC_NCO3	0xf116
+#define	F367TER_DEC_NCO_LO	0xf11600ff
+
+/* SNR */
+#define	R367TER_SNR	0xf117
+#define	F367TER_SNRATIO	0xf11700ff
+
+/* SYR_FFTADJ1 */
+#define	R367TER_SYR_FFTADJ1	0xf118
+#define	F367TER_SYR_FFTADJ_HI	0xf11800ff
+
+/* SYR_FFTADJ2 */
+#define	R367TER_SYR_FFTADJ2	0xf119
+#define	F367TER_SYR_FFTADJ_LO	0xf11900ff
+
+/* SYR_CHCADJ1 */
+#define	R367TER_SYR_CHCADJ1	0xf11a
+#define	F367TER_SYR_CHCADJ_HI	0xf11a00ff
+
+/* SYR_CHCADJ2 */
+#define	R367TER_SYR_CHCADJ2	0xf11b
+#define	F367TER_SYR_CHCADJ_LO	0xf11b00ff
+
+/* SYR_OFF */
+#define	R367TER_SYR_OFF	0xf11c
+#define	F367TER_SYR_OFFSET	0xf11c00ff
+
+/* PPM_OFFSET1 */
+#define	R367TER_PPM_OFFSET1	0xf11d
+#define	F367TER_PPM_OFFSET_HI	0xf11d00ff
+
+/* PPM_OFFSET2 */
+#define	R367TER_PPM_OFFSET2	0xf11e
+#define	F367TER_PPM_OFFSET_LO	0xf11e00ff
+
+/* TRACKER_FREE2 */
+#define	R367TER_TRACKER_FREE2	0xf11f
+#define	F367TER_TRACKER_FREE_2	0xf11f00ff
+
+/* DEBG_LT10 */
+#define	R367TER_DEBG_LT10	0xf120
+#define	F367TER_DEBUG_LT10	0xf12000ff
+
+/* DEBG_LT11 */
+#define	R367TER_DEBG_LT11	0xf121
+#define	F367TER_DEBUG_LT11	0xf12100ff
+
+/* DEBG_LT12 */
+#define	R367TER_DEBG_LT12	0xf122
+#define	F367TER_DEBUG_LT12	0xf12200ff
+
+/* DEBG_LT13 */
+#define	R367TER_DEBG_LT13	0xf123
+#define	F367TER_DEBUG_LT13	0xf12300ff
+
+/* DEBG_LT14 */
+#define	R367TER_DEBG_LT14	0xf124
+#define	F367TER_DEBUG_LT14	0xf12400ff
+
+/* DEBG_LT15 */
+#define	R367TER_DEBG_LT15	0xf125
+#define	F367TER_DEBUG_LT15	0xf12500ff
+
+/* DEBG_LT16 */
+#define	R367TER_DEBG_LT16	0xf126
+#define	F367TER_DEBUG_LT16	0xf12600ff
+
+/* DEBG_LT17 */
+#define	R367TER_DEBG_LT17	0xf127
+#define	F367TER_DEBUG_LT17	0xf12700ff
+
+/* DEBG_LT18 */
+#define	R367TER_DEBG_LT18	0xf128
+#define	F367TER_DEBUG_LT18	0xf12800ff
+
+/* DEBG_LT19 */
+#define	R367TER_DEBG_LT19	0xf129
+#define	F367TER_DEBUG_LT19	0xf12900ff
+
+/* DEBG_LT1a */
+#define	R367TER_DEBG_LT1A	0xf12a
+#define	F367TER_DEBUG_LT1A	0xf12a00ff
+
+/* DEBG_LT1b */
+#define	R367TER_DEBG_LT1B	0xf12b
+#define	F367TER_DEBUG_LT1B	0xf12b00ff
+
+/* DEBG_LT1c */
+#define	R367TER_DEBG_LT1C	0xf12c
+#define	F367TER_DEBUG_LT1C	0xf12c00ff
+
+/* DEBG_LT1D */
+#define	R367TER_DEBG_LT1D	0xf12d
+#define	F367TER_DEBUG_LT1D	0xf12d00ff
+
+/* DEBG_LT1E */
+#define	R367TER_DEBG_LT1E	0xf12e
+#define	F367TER_DEBUG_LT1E	0xf12e00ff
+
+/* DEBG_LT1F */
+#define	R367TER_DEBG_LT1F	0xf12f
+#define	F367TER_DEBUG_LT1F	0xf12f00ff
+
+/* RCCFGH */
+#define	R367TER_RCCFGH	0xf200
+#define	F367TER_TSRCFIFO_DVBCI	0xf2000080
+#define	F367TER_TSRCFIFO_SERIAL	0xf2000040
+#define	F367TER_TSRCFIFO_DISABLE	0xf2000020
+#define	F367TER_TSFIFO_2TORC	0xf2000010
+#define	F367TER_TSRCFIFO_HSGNLOUT	0xf2000008
+#define	F367TER_TSRCFIFO_ERRMODE	0xf2000006
+#define	F367TER_RCCFGH_0	0xf2000001
+
+/* RCCFGM */
+#define	R367TER_RCCFGM	0xf201
+#define	F367TER_TSRCFIFO_MANSPEED	0xf20100c0
+#define	F367TER_TSRCFIFO_PERMDATA	0xf2010020
+#define	F367TER_TSRCFIFO_NONEWSGNL	0xf2010010
+#define	F367TER_RCBYTE_OVERSAMPLING	0xf201000e
+#define	F367TER_TSRCFIFO_INVDATA	0xf2010001
+
+/* RCCFGL */
+#define	R367TER_RCCFGL	0xf202
+#define	F367TER_TSRCFIFO_BCLKDEL1cK	0xf20200c0
+#define	F367TER_RCCFGL_5	0xf2020020
+#define	F367TER_TSRCFIFO_DUTY50	0xf2020010
+#define	F367TER_TSRCFIFO_NSGNL2dATA	0xf2020008
+#define	F367TER_TSRCFIFO_DISSERMUX	0xf2020004
+#define	F367TER_RCCFGL_1	0xf2020002
+#define	F367TER_TSRCFIFO_STOPCKDIS	0xf2020001
+
+/* RCINSDELH */
+#define	R367TER_RCINSDELH	0xf203
+#define	F367TER_TSRCDEL_SYNCBYTE	0xf2030080
+#define	F367TER_TSRCDEL_XXHEADER	0xf2030040
+#define	F367TER_TSRCDEL_BBHEADER	0xf2030020
+#define	F367TER_TSRCDEL_DATAFIELD	0xf2030010
+#define	F367TER_TSRCINSDEL_ISCR	0xf2030008
+#define	F367TER_TSRCINSDEL_NPD	0xf2030004
+#define	F367TER_TSRCINSDEL_RSPARITY	0xf2030002
+#define	F367TER_TSRCINSDEL_CRC8	0xf2030001
+
+/* RCINSDELM */
+#define	R367TER_RCINSDELM	0xf204
+#define	F367TER_TSRCINS_BBPADDING	0xf2040080
+#define	F367TER_TSRCINS_BCHFEC	0xf2040040
+#define	F367TER_TSRCINS_LDPCFEC	0xf2040020
+#define	F367TER_TSRCINS_EMODCOD	0xf2040010
+#define	F367TER_TSRCINS_TOKEN	0xf2040008
+#define	F367TER_TSRCINS_XXXERR	0xf2040004
+#define	F367TER_TSRCINS_MATYPE	0xf2040002
+#define	F367TER_TSRCINS_UPL	0xf2040001
+
+/* RCINSDELL */
+#define	R367TER_RCINSDELL	0xf205
+#define	F367TER_TSRCINS_DFL	0xf2050080
+#define	F367TER_TSRCINS_SYNCD	0xf2050040
+#define	F367TER_TSRCINS_BLOCLEN	0xf2050020
+#define	F367TER_TSRCINS_SIGPCOUNT	0xf2050010
+#define	F367TER_TSRCINS_FIFO	0xf2050008
+#define	F367TER_TSRCINS_REALPACK	0xf2050004
+#define	F367TER_TSRCINS_TSCONFIG	0xf2050002
+#define	F367TER_TSRCINS_LATENCY	0xf2050001
+
+/* RCSTATUS */
+#define	R367TER_RCSTATUS	0xf206
+#define	F367TER_TSRCFIFO_LINEOK	0xf2060080
+#define	F367TER_TSRCFIFO_ERROR	0xf2060040
+#define	F367TER_TSRCFIFO_DATA7	0xf2060020
+#define	F367TER_RCSTATUS_4	0xf2060010
+#define	F367TER_TSRCFIFO_DEMODSEL	0xf2060008
+#define	F367TER_TSRC1FIFOSPEED_STORE	0xf2060004
+#define	F367TER_RCSTATUS_1	0xf2060002
+#define	F367TER_TSRCSERIAL_IMPOSSIBLE	0xf2060001
+
+/* RCSPEED */
+#define	R367TER_RCSPEED	0xf207
+#define	F367TER_TSRCFIFO_OUTSPEED	0xf20700ff
+
+/* RCDEBUGM */
+#define	R367TER_RCDEBUGM	0xf208
+#define	F367TER_SD_UNSYNC	0xf2080080
+#define	F367TER_ULFLOCK_DETECTM	0xf2080040
+#define	F367TER_SUL_SELECTOS	0xf2080020
+#define	F367TER_DILUL_NOSCRBLE	0xf2080010
+#define	F367TER_NUL_SCRB	0xf2080008
+#define	F367TER_UL_SCRB	0xf2080004
+#define	F367TER_SCRAULBAD	0xf2080002
+#define	F367TER_SCRAUL_UNSYNC	0xf2080001
+
+/* RCDEBUGL */
+#define	R367TER_RCDEBUGL	0xf209
+#define	F367TER_RS_ERR	0xf2090080
+#define	F367TER_LLFLOCK_DETECTM	0xf2090040
+#define	F367TER_NOT_SUL_SELECTOS	0xf2090020
+#define	F367TER_DILLL_NOSCRBLE	0xf2090010
+#define	F367TER_NLL_SCRB	0xf2090008
+#define	F367TER_LL_SCRB	0xf2090004
+#define	F367TER_SCRALLBAD	0xf2090002
+#define	F367TER_SCRALL_UNSYNC	0xf2090001
+
+/* RCOBSCFG */
+#define	R367TER_RCOBSCFG	0xf20a
+#define	F367TER_TSRCFIFO_OBSCFG	0xf20a00ff
+
+/* RCOBSM */
+#define	R367TER_RCOBSM	0xf20b
+#define	F367TER_TSRCFIFO_OBSDATA_HI	0xf20b00ff
+
+/* RCOBSL */
+#define	R367TER_RCOBSL	0xf20c
+#define	F367TER_TSRCFIFO_OBSDATA_LO	0xf20c00ff
+
+/* RCFECSPY */
+#define	R367TER_RCFECSPY	0xf210
+#define	F367TER_SPYRC_ENABLE	0xf2100080
+#define	F367TER_RCNO_SYNCBYTE	0xf2100040
+#define	F367TER_RCSERIAL_MODE	0xf2100020
+#define	F367TER_RCUNUSUAL_PACKET	0xf2100010
+#define	F367TER_BERRCMETER_DATAMODE	0xf210000c
+#define	F367TER_BERRCMETER_LMODE	0xf2100002
+#define	F367TER_BERRCMETER_RESET	0xf2100001
+
+/* RCFSPYCFG */
+#define	R367TER_RCFSPYCFG	0xf211
+#define	F367TER_FECSPYRC_INPUT	0xf21100c0
+#define	F367TER_RCRST_ON_ERROR	0xf2110020
+#define	F367TER_RCONE_SHOT	0xf2110010
+#define	F367TER_RCI2C_MODE	0xf211000c
+#define	F367TER_SPYRC_HSTERESIS	0xf2110003
+
+/* RCFSPYDATA */
+#define	R367TER_RCFSPYDATA	0xf212
+#define	F367TER_SPYRC_STUFFING	0xf2120080
+#define	F367TER_RCNOERR_PKTJITTER	0xf2120040
+#define	F367TER_SPYRC_CNULLPKT	0xf2120020
+#define	F367TER_SPYRC_OUTDATA_MODE	0xf212001f
+
+/* RCFSPYOUT */
+#define	R367TER_RCFSPYOUT	0xf213
+#define	F367TER_FSPYRC_DIRECT	0xf2130080
+#define	F367TER_RCFSPYOUT_6	0xf2130040
+#define	F367TER_SPYRC_OUTDATA_BUS	0xf2130038
+#define	F367TER_RCSTUFF_MODE	0xf2130007
+
+/* RCFSTATUS */
+#define	R367TER_RCFSTATUS	0xf214
+#define	F367TER_SPYRC_ENDSIM	0xf2140080
+#define	F367TER_RCVALID_SIM	0xf2140040
+#define	F367TER_RCFOUND_SIGNAL	0xf2140020
+#define	F367TER_RCDSS_SYNCBYTE	0xf2140010
+#define	F367TER_RCRESULT_STATE	0xf214000f
+
+/* RCFGOODPACK */
+#define	R367TER_RCFGOODPACK	0xf215
+#define	F367TER_RCGOOD_PACKET	0xf21500ff
+
+/* RCFPACKCNT */
+#define	R367TER_RCFPACKCNT	0xf216
+#define	F367TER_RCPACKET_COUNTER	0xf21600ff
+
+/* RCFSPYMISC */
+#define	R367TER_RCFSPYMISC	0xf217
+#define	F367TER_RCLABEL_COUNTER	0xf21700ff
+
+/* RCFBERCPT4 */
+#define	R367TER_RCFBERCPT4	0xf218
+#define	F367TER_FBERRCMETER_CPT_MMMMSB	0xf21800ff
+
+/* RCFBERCPT3 */
+#define	R367TER_RCFBERCPT3	0xf219
+#define	F367TER_FBERRCMETER_CPT_MMMSB	0xf21900ff
+
+/* RCFBERCPT2 */
+#define	R367TER_RCFBERCPT2	0xf21a
+#define	F367TER_FBERRCMETER_CPT_MMSB	0xf21a00ff
+
+/* RCFBERCPT1 */
+#define	R367TER_RCFBERCPT1	0xf21b
+#define	F367TER_FBERRCMETER_CPT_MSB	0xf21b00ff
+
+/* RCFBERCPT0 */
+#define	R367TER_RCFBERCPT0	0xf21c
+#define	F367TER_FBERRCMETER_CPT_LSB	0xf21c00ff
+
+/* RCFBERERR2 */
+#define	R367TER_RCFBERERR2	0xf21d
+#define	F367TER_FBERRCMETER_ERR_HI	0xf21d00ff
+
+/* RCFBERERR1 */
+#define	R367TER_RCFBERERR1	0xf21e
+#define	F367TER_FBERRCMETER_ERR	0xf21e00ff
+
+/* RCFBERERR0 */
+#define	R367TER_RCFBERERR0	0xf21f
+#define	F367TER_FBERRCMETER_ERR_LO	0xf21f00ff
+
+/* RCFSTATESM */
+#define	R367TER_RCFSTATESM	0xf220
+#define	F367TER_RCRSTATE_F	0xf2200080
+#define	F367TER_RCRSTATE_E	0xf2200040
+#define	F367TER_RCRSTATE_D	0xf2200020
+#define	F367TER_RCRSTATE_C	0xf2200010
+#define	F367TER_RCRSTATE_B	0xf2200008
+#define	F367TER_RCRSTATE_A	0xf2200004
+#define	F367TER_RCRSTATE_9	0xf2200002
+#define	F367TER_RCRSTATE_8	0xf2200001
+
+/* RCFSTATESL */
+#define	R367TER_RCFSTATESL	0xf221
+#define	F367TER_RCRSTATE_7	0xf2210080
+#define	F367TER_RCRSTATE_6	0xf2210040
+#define	F367TER_RCRSTATE_5	0xf2210020
+#define	F367TER_RCRSTATE_4	0xf2210010
+#define	F367TER_RCRSTATE_3	0xf2210008
+#define	F367TER_RCRSTATE_2	0xf2210004
+#define	F367TER_RCRSTATE_1	0xf2210002
+#define	F367TER_RCRSTATE_0	0xf2210001
+
+/* RCFSPYBER */
+#define	R367TER_RCFSPYBER	0xf222
+#define	F367TER_RCFSPYBER_7	0xf2220080
+#define	F367TER_SPYRCOBS_XORREAD	0xf2220040
+#define	F367TER_FSPYRCBER_OBSMODE	0xf2220020
+#define	F367TER_FSPYRCBER_SYNCBYT	0xf2220010
+#define	F367TER_FSPYRCBER_UNSYNC	0xf2220008
+#define	F367TER_FSPYRCBER_CTIME	0xf2220007
+
+/* RCFSPYDISTM */
+#define	R367TER_RCFSPYDISTM	0xf223
+#define	F367TER_RCPKTTIME_DISTANCE_HI	0xf22300ff
+
+/* RCFSPYDISTL */
+#define	R367TER_RCFSPYDISTL	0xf224
+#define	F367TER_RCPKTTIME_DISTANCE_LO	0xf22400ff
+
+/* RCFSPYOBS7 */
+#define	R367TER_RCFSPYOBS7	0xf228
+#define	F367TER_RCSPYOBS_SPYFAIL	0xf2280080
+#define	F367TER_RCSPYOBS_SPYFAIL1	0xf2280040
+#define	F367TER_RCSPYOBS_ERROR	0xf2280020
+#define	F367TER_RCSPYOBS_STROUT	0xf2280010
+#define	F367TER_RCSPYOBS_RESULTSTATE1	0xf228000f
+
+/* RCFSPYOBS6 */
+#define	R367TER_RCFSPYOBS6	0xf229
+#define	F367TER_RCSPYOBS_RESULTSTATe0	0xf22900f0
+#define	F367TER_RCSPYOBS_RESULTSTATEM1	0xf229000f
+
+/* RCFSPYOBS5 */
+#define	R367TER_RCFSPYOBS5	0xf22a
+#define	F367TER_RCSPYOBS_BYTEOFPACKET1	0xf22a00ff
+
+/* RCFSPYOBS4 */
+#define	R367TER_RCFSPYOBS4	0xf22b
+#define	F367TER_RCSPYOBS_BYTEVALUE1	0xf22b00ff
+
+/* RCFSPYOBS3 */
+#define	R367TER_RCFSPYOBS3	0xf22c
+#define	F367TER_RCSPYOBS_DATA1	0xf22c00ff
+
+/* RCFSPYOBS2 */
+#define	R367TER_RCFSPYOBS2	0xf22d
+#define	F367TER_RCSPYOBS_DATa0	0xf22d00ff
+
+/* RCFSPYOBS1 */
+#define	R367TER_RCFSPYOBS1	0xf22e
+#define	F367TER_RCSPYOBS_DATAM1	0xf22e00ff
+
+/* RCFSPYOBS0 */
+#define	R367TER_RCFSPYOBS0	0xf22f
+#define	F367TER_RCSPYOBS_DATAM2	0xf22f00ff
+
+/* TSGENERAL */
+#define	R367TER_TSGENERAL	0xf230
+#define	F367TER_TSGENERAL_7	0xf2300080
+#define	F367TER_TSGENERAL_6	0xf2300040
+#define	F367TER_TSFIFO_BCLK1aLL	0xf2300020
+#define	F367TER_TSGENERAL_4	0xf2300010
+#define	F367TER_MUXSTREAM_OUTMODE	0xf2300008
+#define	F367TER_TSFIFO_PERMPARAL	0xf2300006
+#define	F367TER_RST_REEDSOLO	0xf2300001
+
+/* RC1SPEED */
+#define	R367TER_RC1SPEED	0xf231
+#define	F367TER_TSRCFIFO1_OUTSPEED	0xf23100ff
+
+/* TSGSTATUS */
+#define	R367TER_TSGSTATUS	0xf232
+#define	F367TER_TSGSTATUS_7	0xf2320080
+#define	F367TER_TSGSTATUS_6	0xf2320040
+#define	F367TER_RSMEM_FULL	0xf2320020
+#define	F367TER_RS_MULTCALC	0xf2320010
+#define	F367TER_RSIN_OVERTIME	0xf2320008
+#define	F367TER_TSFIFO3_DEMODSEL	0xf2320004
+#define	F367TER_TSFIFO2_DEMODSEL	0xf2320002
+#define	F367TER_TSFIFO1_DEMODSEL	0xf2320001
+
+
+/* FECM */
+#define	R367TER_FECM	0xf233
+#define	F367TER_DSS_DVB	0xf2330080
+#define	F367TER_DEMOD_BYPASS	0xf2330040
+#define	F367TER_CMP_SLOWMODE	0xf2330020
+#define	F367TER_DSS_SRCH	0xf2330010
+#define	F367TER_FECM_3	0xf2330008
+#define	F367TER_DIFF_MODEVIT	0xf2330004
+#define	F367TER_SYNCVIT	0xf2330002
+#define	F367TER_I2CSYM	0xf2330001
+
+/* VTH12 */
+#define	R367TER_VTH12	0xf234
+#define	F367TER_VTH_12	0xf23400ff
+
+/* VTH23 */
+#define	R367TER_VTH23	0xf235
+#define	F367TER_VTH_23	0xf23500ff
+
+/* VTH34 */
+#define	R367TER_VTH34	0xf236
+#define	F367TER_VTH_34	0xf23600ff
+
+/* VTH56 */
+#define	R367TER_VTH56	0xf237
+#define	F367TER_VTH_56	0xf23700ff
+
+/* VTH67 */
+#define	R367TER_VTH67	0xf238
+#define	F367TER_VTH_67	0xf23800ff
+
+/* VTH78 */
+#define	R367TER_VTH78	0xf239
+#define	F367TER_VTH_78	0xf23900ff
+
+/* VITCURPUN */
+#define	R367TER_VITCURPUN	0xf23a
+#define	F367TER_VIT_MAPPING	0xf23a00e0
+#define	F367TER_VIT_CURPUN	0xf23a001f
+
+/* VERROR */
+#define	R367TER_VERROR	0xf23b
+#define	F367TER_REGERR_VIT	0xf23b00ff
+
+/* PRVIT */
+#define	R367TER_PRVIT	0xf23c
+#define	F367TER_PRVIT_7	0xf23c0080
+#define	F367TER_DIS_VTHLOCK	0xf23c0040
+#define	F367TER_E7_8VIT	0xf23c0020
+#define	F367TER_E6_7VIT	0xf23c0010
+#define	F367TER_E5_6VIT	0xf23c0008
+#define	F367TER_E3_4VIT	0xf23c0004
+#define	F367TER_E2_3VIT	0xf23c0002
+#define	F367TER_E1_2VIT	0xf23c0001
+
+/* VAVSRVIT */
+#define	R367TER_VAVSRVIT	0xf23d
+#define	F367TER_AMVIT	0xf23d0080
+#define	F367TER_FROZENVIT	0xf23d0040
+#define	F367TER_SNVIT	0xf23d0030
+#define	F367TER_TOVVIT	0xf23d000c
+#define	F367TER_HYPVIT	0xf23d0003
+
+/* VSTATUSVIT */
+#define	R367TER_VSTATUSVIT	0xf23e
+#define	F367TER_VITERBI_ON	0xf23e0080
+#define	F367TER_END_LOOPVIT	0xf23e0040
+#define	F367TER_VITERBI_DEPRF	0xf23e0020
+#define	F367TER_PRFVIT	0xf23e0010
+#define	F367TER_LOCKEDVIT	0xf23e0008
+#define	F367TER_VITERBI_DELOCK	0xf23e0004
+#define	F367TER_VIT_DEMODSEL	0xf23e0002
+#define	F367TER_VITERBI_COMPOUT	0xf23e0001
+
+/* VTHINUSE */
+#define	R367TER_VTHINUSE	0xf23f
+#define	F367TER_VIT_INUSE	0xf23f00ff
+
+/* KDIV12 */
+#define	R367TER_KDIV12	0xf240
+#define	F367TER_KDIV12_MANUAL	0xf2400080
+#define	F367TER_K_DIVIDER_12	0xf240007f
+
+/* KDIV23 */
+#define	R367TER_KDIV23	0xf241
+#define	F367TER_KDIV23_MANUAL	0xf2410080
+#define	F367TER_K_DIVIDER_23	0xf241007f
+
+/* KDIV34 */
+#define	R367TER_KDIV34	0xf242
+#define	F367TER_KDIV34_MANUAL	0xf2420080
+#define	F367TER_K_DIVIDER_34	0xf242007f
+
+/* KDIV56 */
+#define	R367TER_KDIV56	0xf243
+#define	F367TER_KDIV56_MANUAL	0xf2430080
+#define	F367TER_K_DIVIDER_56	0xf243007f
+
+/* KDIV67 */
+#define	R367TER_KDIV67	0xf244
+#define	F367TER_KDIV67_MANUAL	0xf2440080
+#define	F367TER_K_DIVIDER_67	0xf244007f
+
+/* KDIV78 */
+#define	R367TER_KDIV78	0xf245
+#define	F367TER_KDIV78_MANUAL	0xf2450080
+#define	F367TER_K_DIVIDER_78	0xf245007f
+
+/* SIGPOWER */
+#define	R367TER_SIGPOWER	0xf246
+#define	F367TER_SIGPOWER_MANUAL	0xf2460080
+#define	F367TER_SIG_POWER	0xf246007f
+
+/* DEMAPVIT */
+#define	R367TER_DEMAPVIT	0xf247
+#define	F367TER_DEMAPVIT_7	0xf2470080
+#define	F367TER_K_DIVIDER_VIT	0xf247007f
+
+/* VITSCALE */
+#define	R367TER_VITSCALE	0xf248
+#define	F367TER_NVTH_NOSRANGE	0xf2480080
+#define	F367TER_VERROR_MAXMODE	0xf2480040
+#define	F367TER_KDIV_MODE	0xf2480030
+#define	F367TER_NSLOWSN_LOCKED	0xf2480008
+#define	F367TER_DELOCK_PRFLOSS	0xf2480004
+#define	F367TER_DIS_RSFLOCK	0xf2480002
+#define	F367TER_VITSCALE_0	0xf2480001
+
+/* FFEC1PRG */
+#define	R367TER_FFEC1PRG	0xf249
+#define	F367TER_FDSS_DVB	0xf2490080
+#define	F367TER_FDSS_SRCH	0xf2490040
+#define	F367TER_FFECPROG_5	0xf2490020
+#define	F367TER_FFECPROG_4	0xf2490010
+#define	F367TER_FFECPROG_3	0xf2490008
+#define	F367TER_FFECPROG_2	0xf2490004
+#define	F367TER_FTS1_DISABLE	0xf2490002
+#define	F367TER_FTS2_DISABLE	0xf2490001
+
+/* FVITCURPUN */
+#define	R367TER_FVITCURPUN	0xf24a
+#define	F367TER_FVIT_MAPPING	0xf24a00e0
+#define	F367TER_FVIT_CURPUN	0xf24a001f
+
+/* FVERROR */
+#define	R367TER_FVERROR	0xf24b
+#define	F367TER_FREGERR_VIT	0xf24b00ff
+
+/* FVSTATUSVIT */
+#define	R367TER_FVSTATUSVIT	0xf24c
+#define	F367TER_FVITERBI_ON	0xf24c0080
+#define	F367TER_F1END_LOOPVIT	0xf24c0040
+#define	F367TER_FVITERBI_DEPRF	0xf24c0020
+#define	F367TER_FPRFVIT	0xf24c0010
+#define	F367TER_FLOCKEDVIT	0xf24c0008
+#define	F367TER_FVITERBI_DELOCK	0xf24c0004
+#define	F367TER_FVIT_DEMODSEL	0xf24c0002
+#define	F367TER_FVITERBI_COMPOUT	0xf24c0001
+
+/* DEBUG_LT1 */
+#define	R367TER_DEBUG_LT1	0xf24d
+#define	F367TER_DBG_LT1	0xf24d00ff
+
+/* DEBUG_LT2 */
+#define	R367TER_DEBUG_LT2	0xf24e
+#define	F367TER_DBG_LT2	0xf24e00ff
+
+/* DEBUG_LT3 */
+#define	R367TER_DEBUG_LT3	0xf24f
+#define	F367TER_DBG_LT3	0xf24f00ff
+
+/*	TSTSFMET */
+#define	R367TER_TSTSFMET	0xf250
+#define F367TER_TSTSFEC_METRIQUES	0xf25000ff
+
+/*	SELOUT */
+#define	R367TER_SELOUT	0xf252
+#define	F367TER_EN_SYNC	0xf2520080
+#define	F367TER_EN_TBUSDEMAP	0xf2520040
+#define	F367TER_SELOUT_5	0xf2520020
+#define	F367TER_SELOUT_4	0xf2520010
+#define	F367TER_TSTSYNCHRO_MODE	0xf2520002
+
+/*	TSYNC */
+#define R367TER_TSYNC	0xf253
+#define F367TER_CURPUN_INCMODE	0xf2530080
+#define F367TER_CERR_TSTMODE	0xf2530040
+#define F367TER_SHIFTSOF_MODE	0xf2530030
+#define F367TER_SLOWPHA_MODE	0xf2530008
+#define F367TER_PXX_BYPALL	0xf2530004
+#define F367TER_FROTA45_FIRST	0xf2530002
+#define F367TER_TST_BCHERROR	0xf2530001
+
+/*	TSTERR */
+#define R367TER_TSTERR	0xf254
+#define F367TER_TST_LONGPKT	0xf2540080
+#define F367TER_TST_ISSYION	0xf2540040
+#define F367TER_TST_NPDON	0xf2540020
+#define F367TER_TSTERR_4	0xf2540010
+#define F367TER_TRACEBACK_MODE	0xf2540008
+#define F367TER_TST_RSPARITY	0xf2540004
+#define F367TER_METRIQUE_MODE	0xf2540003
+
+/*	TSFSYNC */
+#define R367TER_TSFSYNC	0xf255
+#define F367TER_EN_SFECSYNC	0xf2550080
+#define F367TER_EN_SFECDEMAP	0xf2550040
+#define F367TER_SFCERR_TSTMODE	0xf2550020
+#define F367TER_SFECPXX_BYPALL	0xf2550010
+#define F367TER_SFECTSTSYNCHRO_MODE 0xf255000f
+
+/*	TSTSFERR */
+#define R367TER_TSTSFERR	0xf256
+#define F367TER_TSTSTERR_7	0xf2560080
+#define F367TER_TSTSTERR_6	0xf2560040
+#define F367TER_TSTSTERR_5 	0xf2560020
+#define F367TER_TSTSTERR_4	0xf2560010
+#define F367TER_SFECTRACEBACK_MODE	0xf2560008
+#define F367TER_SFEC_NCONVPROG	0xf2560004
+#define F367TER_SFECMETRIQUE_MODE	0xf2560003
+
+/*	TSTTSSF1 */
+#define R367TER_TSTTSSF1	0xf258
+#define F367TER_TSTERSSF	0xf2580080
+#define F367TER_TSTTSSFEN	0xf2580040
+#define F367TER_SFEC_OUTMODE	0xf2580030
+#define F367TER_XLSF_NOFTHRESHOLD  0xf2580008
+#define F367TER_TSTTSSF_STACKSEL	0xf2580007
+
+/*	TSTTSSF2 */
+#define R367TER_TSTTSSF2	0xf259
+#define F367TER_DILSF_DBBHEADER	0xf2590080
+#define F367TER_TSTTSSF_DISBUG	0xf2590040
+#define F367TER_TSTTSSF_NOBADSTART	0xf2590020
+#define F367TER_TSTTSSF_SELECT 	0xf259001f
+
+/*	TSTTSSF3 */
+#define R367TER_TSTTSSF3	0xf25a
+#define F367TER_TSTTSSF3_7	0xf25a0080
+#define F367TER_TSTTSSF3_6	0xf25a0040
+#define F367TER_TSTTSSF3_5	0xf25a0020
+#define F367TER_TSTTSSF3_4	0xf25a0010
+#define F367TER_TSTTSSF3_3	0xf25a0008
+#define F367TER_TSTTSSF3_2	0xf25a0004
+#define F367TER_TSTTSSF3_1	0xf25a0002
+#define F367TER_DISSF_CLKENABLE	0xf25a0001
+
+/*	TSTTS1 */
+#define R367TER_TSTTS1	0xf25c
+#define F367TER_TSTERS	0xf25c0080
+#define F367TER_TSFIFO_DSSSYNCB	0xf25c0040
+#define F367TER_TSTTS_FSPYBEFRS	0xf25c0020
+#define F367TER_NFORCE_SYNCBYTE	0xf25c0010
+#define F367TER_XL_NOFTHRESHOLD	0xf25c0008
+#define F367TER_TSTTS_FRFORCEPKT	0xf25c0004
+#define F367TER_DESCR_NOTAUTO	0xf25c0002
+#define F367TER_TSTTSEN	0xf25c0001
+
+/*	TSTTS2 */
+#define R367TER_TSTTS2	0xf25d
+#define F367TER_DIL_DBBHEADER	0xf25d0080
+#define F367TER_TSTTS_NOBADXXX	0xf25d0040
+#define F367TER_TSFIFO_DELSPEEDUP	0xf25d0020
+#define F367TER_TSTTS_SELECT	0xf25d001f
+
+/*	TSTTS3 */
+#define R367TER_TSTTS3	0xf25e
+#define F367TER_TSTTS_NOPKTGAIN	0xf25e0080
+#define F367TER_TSTTS_NOPKTENE	0xf25e0040
+#define F367TER_TSTTS_ISOLATION	0xf25e0020
+#define F367TER_TSTTS_DISBUG	0xf25e0010
+#define F367TER_TSTTS_NOBADSTART	0xf25e0008
+#define F367TER_TSTTS_STACKSEL	0xf25e0007
+
+/*	TSTTS4 */
+#define R367TER_TSTTS4	0xf25f
+#define F367TER_TSTTS4_7	0xf25f0080
+#define F367TER_TSTTS4_6	0xf25f0040
+#define F367TER_TSTTS4_5	0xf25f0020
+#define F367TER_TSTTS_DISDSTATE	0xf25f0010
+#define F367TER_TSTTS_FASTNOSYNC	0xf25f0008
+#define F367TER_EXT_FECSPYIN	0xf25f0004
+#define F367TER_TSTTS_NODPZERO	0xf25f0002
+#define F367TER_TSTTS_NODIV3	0xf25f0001
+
+/*	TSTTSRC */
+#define R367TER_TSTTSRC	0xf26c
+#define F367TER_TSTTSRC_7	0xf26c0080
+#define F367TER_TSRCFIFO_DSSSYNCB	0xf26c0040
+#define F367TER_TSRCFIFO_DPUNACTIVE	0xf26c0020
+#define F367TER_TSRCFIFO_DELSPEEDUP	0xf26c0010
+#define F367TER_TSTTSRC_NODIV3	0xf26c0008
+#define F367TER_TSTTSRC_FRFORCEPKT	0xf26c0004
+#define F367TER_SAT25_SDDORIGINE	0xf26c0002
+#define F367TER_TSTTSRC_INACTIVE	0xf26c0001
+
+/*	TSTTSRS */
+#define R367TER_TSTTSRS	0xf26d
+#define F367TER_TSTTSRS_7	0xf26d0080
+#define F367TER_TSTTSRS_6	0xf26d0040
+#define F367TER_TSTTSRS_5	0xf26d0020
+#define F367TER_TSTTSRS_4	0xf26d0010
+#define F367TER_TSTTSRS_3	0xf26d0008
+#define F367TER_TSTTSRS_2	0xf26d0004
+#define F367TER_TSTRS_DISRS2	0xf26d0002
+#define F367TER_TSTRS_DISRS1	0xf26d0001
+
+/* TSSTATEM */
+#define	R367TER_TSSTATEM	0xf270
+#define	F367TER_TSDIL_ON	0xf2700080
+#define	F367TER_TSSKIPRS_ON	0xf2700040
+#define	F367TER_TSRS_ON	0xf2700020
+#define	F367TER_TSDESCRAMB_ON	0xf2700010
+#define	F367TER_TSFRAME_MODE	0xf2700008
+#define	F367TER_TS_DISABLE	0xf2700004
+#define	F367TER_TSACM_MODE	0xf2700002
+#define	F367TER_TSOUT_NOSYNC	0xf2700001
+
+/* TSSTATEL */
+#define	R367TER_TSSTATEL	0xf271
+#define	F367TER_TSNOSYNCBYTE	0xf2710080
+#define	F367TER_TSPARITY_ON	0xf2710040
+#define	F367TER_TSSYNCOUTRS_ON	0xf2710020
+#define	F367TER_TSDVBS2_MODE	0xf2710010
+#define	F367TER_TSISSYI_ON	0xf2710008
+#define	F367TER_TSNPD_ON	0xf2710004
+#define	F367TER_TSCRC8_ON	0xf2710002
+#define	F367TER_TSDSS_PACKET	0xf2710001
+
+/* TSCFGH */
+#define	R367TER_TSCFGH	0xf272
+#define	F367TER_TSFIFO_DVBCI	0xf2720080
+#define	F367TER_TSFIFO_SERIAL	0xf2720040
+#define	F367TER_TSFIFO_TEIUPDATE	0xf2720020
+#define	F367TER_TSFIFO_DUTY50	0xf2720010
+#define	F367TER_TSFIFO_HSGNLOUT	0xf2720008
+#define	F367TER_TSFIFO_ERRMODE	0xf2720006
+#define	F367TER_RST_HWARE	0xf2720001
+
+/* TSCFGM */
+#define	R367TER_TSCFGM	0xf273
+#define	F367TER_TSFIFO_MANSPEED	0xf27300c0
+#define	F367TER_TSFIFO_PERMDATA	0xf2730020
+#define	F367TER_TSFIFO_NONEWSGNL	0xf2730010
+#define	F367TER_TSFIFO_BITSPEED	0xf2730008
+#define	F367TER_NPD_SPECDVBS2	0xf2730004
+#define	F367TER_TSFIFO_STOPCKDIS	0xf2730002
+#define	F367TER_TSFIFO_INVDATA	0xf2730001
+
+/* TSCFGL */
+#define	R367TER_TSCFGL	0xf274
+#define	F367TER_TSFIFO_BCLKDEL1cK	0xf27400c0
+#define	F367TER_BCHERROR_MODE	0xf2740030
+#define	F367TER_TSFIFO_NSGNL2dATA	0xf2740008
+#define	F367TER_TSFIFO_EMBINDVB	0xf2740004
+#define	F367TER_TSFIFO_DPUNACT	0xf2740002
+#define	F367TER_TSFIFO_NPDOFF	0xf2740001
+
+/* TSSYNC */
+#define	R367TER_TSSYNC	0xf275
+#define	F367TER_TSFIFO_PERMUTE	0xf2750080
+#define	F367TER_TSFIFO_FISCR3B	0xf2750060
+#define	F367TER_TSFIFO_SYNCMODE	0xf2750018
+#define	F367TER_TSFIFO_SYNCSEL	0xf2750007
+
+/* TSINSDELH */
+#define	R367TER_TSINSDELH	0xf276
+#define	F367TER_TSDEL_SYNCBYTE	0xf2760080
+#define	F367TER_TSDEL_XXHEADER	0xf2760040
+#define	F367TER_TSDEL_BBHEADER	0xf2760020
+#define	F367TER_TSDEL_DATAFIELD	0xf2760010
+#define	F367TER_TSINSDEL_ISCR	0xf2760008
+#define	F367TER_TSINSDEL_NPD	0xf2760004
+#define	F367TER_TSINSDEL_RSPARITY	0xf2760002
+#define	F367TER_TSINSDEL_CRC8	0xf2760001
+
+/* TSINSDELM */
+#define	R367TER_TSINSDELM	0xf277
+#define	F367TER_TSINS_BBPADDING	0xf2770080
+#define	F367TER_TSINS_BCHFEC	0xf2770040
+#define	F367TER_TSINS_LDPCFEC	0xf2770020
+#define	F367TER_TSINS_EMODCOD	0xf2770010
+#define	F367TER_TSINS_TOKEN	0xf2770008
+#define	F367TER_TSINS_XXXERR	0xf2770004
+#define	F367TER_TSINS_MATYPE	0xf2770002
+#define	F367TER_TSINS_UPL	0xf2770001
+
+/* TSINSDELL */
+#define	R367TER_TSINSDELL	0xf278
+#define	F367TER_TSINS_DFL	0xf2780080
+#define	F367TER_TSINS_SYNCD	0xf2780040
+#define	F367TER_TSINS_BLOCLEN	0xf2780020
+#define	F367TER_TSINS_SIGPCOUNT	0xf2780010
+#define	F367TER_TSINS_FIFO	0xf2780008
+#define	F367TER_TSINS_REALPACK	0xf2780004
+#define	F367TER_TSINS_TSCONFIG	0xf2780002
+#define	F367TER_TSINS_LATENCY	0xf2780001
+
+/* TSDIVN */
+#define	R367TER_TSDIVN	0xf279
+#define	F367TER_TSFIFO_LOWSPEED	0xf2790080
+#define	F367TER_BYTE_OVERSAMPLING	0xf2790070
+#define	F367TER_TSMANUAL_PACKETNBR	0xf279000f
+
+/* TSDIVPM */
+#define	R367TER_TSDIVPM	0xf27a
+#define	F367TER_TSMANUAL_P_HI	0xf27a00ff
+
+/* TSDIVPL */
+#define	R367TER_TSDIVPL	0xf27b
+#define	F367TER_TSMANUAL_P_LO	0xf27b00ff
+
+/* TSDIVQM */
+#define	R367TER_TSDIVQM	0xf27c
+#define	F367TER_TSMANUAL_Q_HI	0xf27c00ff
+
+/* TSDIVQL */
+#define	R367TER_TSDIVQL	0xf27d
+#define	F367TER_TSMANUAL_Q_LO	0xf27d00ff
+
+/* TSDILSTKM */
+#define	R367TER_TSDILSTKM	0xf27e
+#define	F367TER_TSFIFO_DILSTK_HI	0xf27e00ff
+
+/* TSDILSTKL */
+#define	R367TER_TSDILSTKL	0xf27f
+#define	F367TER_TSFIFO_DILSTK_LO	0xf27f00ff
+
+/* TSSPEED */
+#define	R367TER_TSSPEED	0xf280
+#define	F367TER_TSFIFO_OUTSPEED	0xf28000ff
+
+/* TSSTATUS */
+#define	R367TER_TSSTATUS	0xf281
+#define	F367TER_TSFIFO_LINEOK	0xf2810080
+#define	F367TER_TSFIFO_ERROR	0xf2810040
+#define	F367TER_TSFIFO_DATA7	0xf2810020
+#define	F367TER_TSFIFO_NOSYNC	0xf2810010
+#define	F367TER_ISCR_INITIALIZED	0xf2810008
+#define	F367TER_ISCR_UPDATED	0xf2810004
+#define	F367TER_SOFFIFO_UNREGUL	0xf2810002
+#define	F367TER_DIL_READY	0xf2810001
+
+/* TSSTATUS2 */
+#define	R367TER_TSSTATUS2	0xf282
+#define	F367TER_TSFIFO_DEMODSEL	0xf2820080
+#define	F367TER_TSFIFOSPEED_STORE	0xf2820040
+#define	F367TER_DILXX_RESET	0xf2820020
+#define	F367TER_TSSERIAL_IMPOSSIBLE	0xf2820010
+#define	F367TER_TSFIFO_UNDERSPEED	0xf2820008
+#define	F367TER_BITSPEED_EVENT	0xf2820004
+#define	F367TER_UL_SCRAMBDETECT	0xf2820002
+#define	F367TER_ULDTV67_FALSELOCK	0xf2820001
+
+/* TSBITRATEM */
+#define	R367TER_TSBITRATEM	0xf283
+#define	F367TER_TSFIFO_BITRATE_HI	0xf28300ff
+
+/* TSBITRATEL */
+#define	R367TER_TSBITRATEL	0xf284
+#define	F367TER_TSFIFO_BITRATE_LO	0xf28400ff
+
+/* TSPACKLENM */
+#define	R367TER_TSPACKLENM	0xf285
+#define	F367TER_TSFIFO_PACKCPT	0xf28500e0
+#define	F367TER_DIL_RPLEN_HI	0xf285001f
+
+/* TSPACKLENL */
+#define	R367TER_TSPACKLENL	0xf286
+#define	F367TER_DIL_RPLEN_LO	0xf28600ff
+
+/* TSBLOCLENM */
+#define	R367TER_TSBLOCLENM	0xf287
+#define	F367TER_TSFIFO_PFLEN_HI	0xf28700ff
+
+/* TSBLOCLENL */
+#define	R367TER_TSBLOCLENL	0xf288
+#define	F367TER_TSFIFO_PFLEN_LO	0xf28800ff
+
+/* TSDLYH */
+#define	R367TER_TSDLYH	0xf289
+#define	F367TER_SOFFIFO_TSTIMEVALID	0xf2890080
+#define	F367TER_SOFFIFO_SPEEDUP	0xf2890040
+#define	F367TER_SOFFIFO_STOP	0xf2890020
+#define	F367TER_SOFFIFO_REGULATED	0xf2890010
+#define	F367TER_SOFFIFO_REALSBOFF_HI	0xf289000f
+
+/* TSDLYM */
+#define	R367TER_TSDLYM	0xf28a
+#define	F367TER_SOFFIFO_REALSBOFF_MED	0xf28a00ff
+
+/* TSDLYL */
+#define	R367TER_TSDLYL	0xf28b
+#define	F367TER_SOFFIFO_REALSBOFF_LO	0xf28b00ff
+
+/* TSNPDAV */
+#define	R367TER_TSNPDAV	0xf28c
+#define	F367TER_TSNPD_AVERAGE	0xf28c00ff
+
+/* TSBUFSTATH */
+#define	R367TER_TSBUFSTATH	0xf28d
+#define	F367TER_TSISCR_3BYTES	0xf28d0080
+#define	F367TER_TSISCR_NEWDATA	0xf28d0040
+#define	F367TER_TSISCR_BUFSTAT_HI	0xf28d003f
+
+/* TSBUFSTATM */
+#define	R367TER_TSBUFSTATM	0xf28e
+#define	F367TER_TSISCR_BUFSTAT_MED	0xf28e00ff
+
+/* TSBUFSTATL */
+#define	R367TER_TSBUFSTATL	0xf28f
+#define	F367TER_TSISCR_BUFSTAT_LO	0xf28f00ff
+
+/* TSDEBUGM */
+#define	R367TER_TSDEBUGM	0xf290
+#define	F367TER_TSFIFO_ILLPACKET	0xf2900080
+#define	F367TER_DIL_NOSYNC	0xf2900040
+#define	F367TER_DIL_ISCR	0xf2900020
+#define	F367TER_DILOUT_BSYNCB	0xf2900010
+#define	F367TER_TSFIFO_EMPTYPKT	0xf2900008
+#define	F367TER_TSFIFO_EMPTYRD	0xf2900004
+#define	F367TER_SOFFIFO_STOPM	0xf2900002
+#define	F367TER_SOFFIFO_SPEEDUPM	0xf2900001
+
+/* TSDEBUGL */
+#define	R367TER_TSDEBUGL	0xf291
+#define	F367TER_TSFIFO_PACKLENFAIL	0xf2910080
+#define	F367TER_TSFIFO_SYNCBFAIL	0xf2910040
+#define	F367TER_TSFIFO_VITLIBRE	0xf2910020
+#define	F367TER_TSFIFO_BOOSTSPEEDM	0xf2910010
+#define	F367TER_TSFIFO_UNDERSPEEDM	0xf2910008
+#define	F367TER_TSFIFO_ERROR_EVNT	0xf2910004
+#define	F367TER_TSFIFO_FULL	0xf2910002
+#define	F367TER_TSFIFO_OVERFLOWM	0xf2910001
+
+/* TSDLYSETH */
+#define	R367TER_TSDLYSETH	0xf292
+#define	F367TER_SOFFIFO_OFFSET	0xf29200e0
+#define	F367TER_SOFFIFO_SYMBOFFSET_HI	0xf292001f
+
+/* TSDLYSETM */
+#define	R367TER_TSDLYSETM	0xf293
+#define	F367TER_SOFFIFO_SYMBOFFSET_MED	0xf29300ff
+
+/* TSDLYSETL */
+#define	R367TER_TSDLYSETL	0xf294
+#define	F367TER_SOFFIFO_SYMBOFFSET_LO	0xf29400ff
+
+/* TSOBSCFG */
+#define	R367TER_TSOBSCFG	0xf295
+#define	F367TER_TSFIFO_OBSCFG	0xf29500ff
+
+/* TSOBSM */
+#define	R367TER_TSOBSM	0xf296
+#define	F367TER_TSFIFO_OBSDATA_HI	0xf29600ff
+
+/* TSOBSL */
+#define	R367TER_TSOBSL	0xf297
+#define	F367TER_TSFIFO_OBSDATA_LO	0xf29700ff
+
+/* ERRCTRL1 */
+#define	R367TER_ERRCTRL1	0xf298
+#define	F367TER_ERR_SRC1	0xf29800f0
+#define	F367TER_ERRCTRL1_3	0xf2980008
+#define	F367TER_NUM_EVT1	0xf2980007
+
+/* ERRCNT1H */
+#define	R367TER_ERRCNT1H	0xf299
+#define	F367TER_ERRCNT1_OLDVALUE	0xf2990080
+#define	F367TER_ERR_CNT1	0xf299007f
+
+/* ERRCNT1M */
+#define	R367TER_ERRCNT1M	0xf29a
+#define	F367TER_ERR_CNT1_HI	0xf29a00ff
+
+/* ERRCNT1L */
+#define	R367TER_ERRCNT1L	0xf29b
+#define	F367TER_ERR_CNT1_LO	0xf29b00ff
+
+/* ERRCTRL2 */
+#define	R367TER_ERRCTRL2	0xf29c
+#define	F367TER_ERR_SRC2	0xf29c00f0
+#define	F367TER_ERRCTRL2_3	0xf29c0008
+#define	F367TER_NUM_EVT2	0xf29c0007
+
+/* ERRCNT2H */
+#define	R367TER_ERRCNT2H	0xf29d
+#define	F367TER_ERRCNT2_OLDVALUE	0xf29d0080
+#define	F367TER_ERR_CNT2_HI	0xf29d007f
+
+/* ERRCNT2M */
+#define	R367TER_ERRCNT2M	0xf29e
+#define	F367TER_ERR_CNT2_MED	0xf29e00ff
+
+/* ERRCNT2L */
+#define	R367TER_ERRCNT2L	0xf29f
+#define	F367TER_ERR_CNT2_LO	0xf29f00ff
+
+/* FECSPY */
+#define	R367TER_FECSPY	0xf2a0
+#define	F367TER_SPY_ENABLE	0xf2a00080
+#define	F367TER_NO_SYNCBYTE	0xf2a00040
+#define	F367TER_SERIAL_MODE	0xf2a00020
+#define	F367TER_UNUSUAL_PACKET	0xf2a00010
+#define	F367TER_BERMETER_DATAMODE	0xf2a0000c
+#define	F367TER_BERMETER_LMODE	0xf2a00002
+#define	F367TER_BERMETER_RESET	0xf2a00001
+
+/* FSPYCFG */
+#define	R367TER_FSPYCFG	0xf2a1
+#define	F367TER_FECSPY_INPUT	0xf2a100c0
+#define	F367TER_RST_ON_ERROR	0xf2a10020
+#define	F367TER_ONE_SHOT	0xf2a10010
+#define	F367TER_I2C_MOD	0xf2a1000c
+#define	F367TER_SPY_HYSTERESIS	0xf2a10003
+
+/* FSPYDATA */
+#define	R367TER_FSPYDATA	0xf2a2
+#define	F367TER_SPY_STUFFING	0xf2a20080
+#define	F367TER_NOERROR_PKTJITTER	0xf2a20040
+#define	F367TER_SPY_CNULLPKT	0xf2a20020
+#define	F367TER_SPY_OUTDATA_MODE	0xf2a2001f
+
+/* FSPYOUT */
+#define	R367TER_FSPYOUT	0xf2a3
+#define	F367TER_FSPY_DIRECT	0xf2a30080
+#define	F367TER_FSPYOUT_6	0xf2a30040
+#define	F367TER_SPY_OUTDATA_BUS	0xf2a30038
+#define	F367TER_STUFF_MODE	0xf2a30007
+
+/* FSTATUS */
+#define	R367TER_FSTATUS	0xf2a4
+#define	F367TER_SPY_ENDSIM	0xf2a40080
+#define	F367TER_VALID_SIM	0xf2a40040
+#define	F367TER_FOUND_SIGNAL	0xf2a40020
+#define	F367TER_DSS_SYNCBYTE	0xf2a40010
+#define	F367TER_RESULT_STATE	0xf2a4000f
+
+/* FGOODPACK */
+#define	R367TER_FGOODPACK	0xf2a5
+#define	F367TER_FGOOD_PACKET	0xf2a500ff
+
+/* FPACKCNT */
+#define	R367TER_FPACKCNT	0xf2a6
+#define	F367TER_FPACKET_COUNTER	0xf2a600ff
+
+/* FSPYMISC */
+#define	R367TER_FSPYMISC	0xf2a7
+#define	F367TER_FLABEL_COUNTER	0xf2a700ff
+
+/* FBERCPT4 */
+#define	R367TER_FBERCPT4	0xf2a8
+#define	F367TER_FBERMETER_CPT5	0xf2a800ff
+
+/* FBERCPT3 */
+#define	R367TER_FBERCPT3	0xf2a9
+#define	F367TER_FBERMETER_CPT4	0xf2a900ff
+
+/* FBERCPT2 */
+#define	R367TER_FBERCPT2	0xf2aa
+#define	F367TER_FBERMETER_CPT3	0xf2aa00ff
+
+/* FBERCPT1 */
+#define	R367TER_FBERCPT1	0xf2ab
+#define	F367TER_FBERMETER_CPT2	0xf2ab00ff
+
+/* FBERCPT0 */
+#define	R367TER_FBERCPT0	0xf2ac
+#define	F367TER_FBERMETER_CPT1	0xf2ac00ff
+
+/* FBERERR2 */
+#define	R367TER_FBERERR2	0xf2ad
+#define	F367TER_FBERMETER_ERR_HI	0xf2ad00ff
+
+/* FBERERR1 */
+#define	R367TER_FBERERR1	0xf2ae
+#define	F367TER_FBERMETER_ERR_MED	0xf2ae00ff
+
+/* FBERERR0 */
+#define	R367TER_FBERERR0	0xf2af
+#define	F367TER_FBERMETER_ERR_LO	0xf2af00ff
+
+/* FSTATESM */
+#define	R367TER_FSTATESM	0xf2b0
+#define	F367TER_RSTATE_F	0xf2b00080
+#define	F367TER_RSTATE_E	0xf2b00040
+#define	F367TER_RSTATE_D	0xf2b00020
+#define	F367TER_RSTATE_C	0xf2b00010
+#define	F367TER_RSTATE_B	0xf2b00008
+#define	F367TER_RSTATE_A	0xf2b00004
+#define	F367TER_RSTATE_9	0xf2b00002
+#define	F367TER_RSTATE_8	0xf2b00001
+
+/* FSTATESL */
+#define	R367TER_FSTATESL	0xf2b1
+#define	F367TER_RSTATE_7	0xf2b10080
+#define	F367TER_RSTATE_6	0xf2b10040
+#define	F367TER_RSTATE_5	0xf2b10020
+#define	F367TER_RSTATE_4	0xf2b10010
+#define	F367TER_RSTATE_3	0xf2b10008
+#define	F367TER_RSTATE_2	0xf2b10004
+#define	F367TER_RSTATE_1	0xf2b10002
+#define	F367TER_RSTATE_0	0xf2b10001
+
+/* FSPYBER */
+#define	R367TER_FSPYBER	0xf2b2
+#define	F367TER_FSPYBER_7	0xf2b20080
+#define	F367TER_FSPYOBS_XORREAD	0xf2b20040
+#define	F367TER_FSPYBER_OBSMODE	0xf2b20020
+#define	F367TER_FSPYBER_SYNCBYTE	0xf2b20010
+#define	F367TER_FSPYBER_UNSYNC	0xf2b20008
+#define	F367TER_FSPYBER_CTIME	0xf2b20007
+
+/* FSPYDISTM */
+#define	R367TER_FSPYDISTM	0xf2b3
+#define	F367TER_PKTTIME_DISTANCE_HI	0xf2b300ff
+
+/* FSPYDISTL */
+#define	R367TER_FSPYDISTL	0xf2b4
+#define	F367TER_PKTTIME_DISTANCE_LO	0xf2b400ff
+
+/* FSPYOBS7 */
+#define	R367TER_FSPYOBS7	0xf2b8
+#define	F367TER_FSPYOBS_SPYFAIL	0xf2b80080
+#define	F367TER_FSPYOBS_SPYFAIL1	0xf2b80040
+#define	F367TER_FSPYOBS_ERROR	0xf2b80020
+#define	F367TER_FSPYOBS_STROUT	0xf2b80010
+#define	F367TER_FSPYOBS_RESULTSTATE1	0xf2b8000f
+
+/* FSPYOBS6 */
+#define	R367TER_FSPYOBS6	0xf2b9
+#define	F367TER_FSPYOBS_RESULTSTATe0	0xf2b900f0
+#define	F367TER_FSPYOBS_RESULTSTATEM1	0xf2b9000f
+
+/* FSPYOBS5 */
+#define	R367TER_FSPYOBS5	0xf2ba
+#define	F367TER_FSPYOBS_BYTEOFPACKET1	0xf2ba00ff
+
+/* FSPYOBS4 */
+#define	R367TER_FSPYOBS4	0xf2bb
+#define	F367TER_FSPYOBS_BYTEVALUE1	0xf2bb00ff
+
+/* FSPYOBS3 */
+#define	R367TER_FSPYOBS3	0xf2bc
+#define	F367TER_FSPYOBS_DATA1	0xf2bc00ff
+
+/* FSPYOBS2 */
+#define	R367TER_FSPYOBS2	0xf2bd
+#define	F367TER_FSPYOBS_DATa0	0xf2bd00ff
+
+/* FSPYOBS1 */
+#define	R367TER_FSPYOBS1	0xf2be
+#define	F367TER_FSPYOBS_DATAM1	0xf2be00ff
+
+/* FSPYOBS0 */
+#define	R367TER_FSPYOBS0	0xf2bf
+#define	F367TER_FSPYOBS_DATAM2	0xf2bf00ff
+
+/* SFDEMAP */
+#define	R367TER_SFDEMAP	0xf2c0
+#define	F367TER_SFDEMAP_7	0xf2c00080
+#define	F367TER_SFEC_K_DIVIDER_VIT	0xf2c0007f
+
+/* SFERROR */
+#define	R367TER_SFERROR	0xf2c1
+#define	F367TER_SFEC_REGERR_VIT	0xf2c100ff
+
+/* SFAVSR */
+#define	R367TER_SFAVSR	0xf2c2
+#define	F367TER_SFEC_SUMERRORS	0xf2c20080
+#define	F367TER_SERROR_MAXMODE	0xf2c20040
+#define	F367TER_SN_SFEC	0xf2c20030
+#define	F367TER_KDIV_MODE_SFEC	0xf2c2000c
+#define	F367TER_SFAVSR_1	0xf2c20002
+#define	F367TER_SFAVSR_0	0xf2c20001
+
+/* SFECSTATUS */
+#define	R367TER_SFECSTATUS	0xf2c3
+#define	F367TER_SFEC_ON	0xf2c30080
+#define	F367TER_SFSTATUS_6	0xf2c30040
+#define	F367TER_SFSTATUS_5	0xf2c30020
+#define	F367TER_SFSTATUS_4	0xf2c30010
+#define	F367TER_LOCKEDSFEC	0xf2c30008
+#define	F367TER_SFEC_DELOCK	0xf2c30004
+#define	F367TER_SFEC_DEMODSEL1	0xf2c30002
+#define	F367TER_SFEC_OVFON	0xf2c30001
+
+/* SFKDIV12 */
+#define	R367TER_SFKDIV12	0xf2c4
+#define	F367TER_SFECKDIV12_MAN	0xf2c40080
+#define	F367TER_SFEC_K_DIVIDER_12	0xf2c4007f
+
+/* SFKDIV23 */
+#define	R367TER_SFKDIV23	0xf2c5
+#define	F367TER_SFECKDIV23_MAN	0xf2c50080
+#define	F367TER_SFEC_K_DIVIDER_23	0xf2c5007f
+
+/* SFKDIV34 */
+#define	R367TER_SFKDIV34	0xf2c6
+#define	F367TER_SFECKDIV34_MAN	0xf2c60080
+#define	F367TER_SFEC_K_DIVIDER_34	0xf2c6007f
+
+/* SFKDIV56 */
+#define	R367TER_SFKDIV56	0xf2c7
+#define	F367TER_SFECKDIV56_MAN	0xf2c70080
+#define	F367TER_SFEC_K_DIVIDER_56	0xf2c7007f
+
+/* SFKDIV67 */
+#define	R367TER_SFKDIV67	0xf2c8
+#define	F367TER_SFECKDIV67_MAN	0xf2c80080
+#define	F367TER_SFEC_K_DIVIDER_67	0xf2c8007f
+
+/* SFKDIV78 */
+#define	R367TER_SFKDIV78	0xf2c9
+#define	F367TER_SFECKDIV78_MAN	0xf2c90080
+#define	F367TER_SFEC_K_DIVIDER_78	0xf2c9007f
+
+/* SFDILSTKM */
+#define	R367TER_SFDILSTKM	0xf2ca
+#define	F367TER_SFEC_PACKCPT	0xf2ca00e0
+#define	F367TER_SFEC_DILSTK_HI	0xf2ca001f
+
+/* SFDILSTKL */
+#define	R367TER_SFDILSTKL	0xf2cb
+#define	F367TER_SFEC_DILSTK_LO	0xf2cb00ff
+
+/* SFSTATUS */
+#define	R367TER_SFSTATUS	0xf2cc
+#define	F367TER_SFEC_LINEOK	0xf2cc0080
+#define	F367TER_SFEC_ERROR	0xf2cc0040
+#define	F367TER_SFEC_DATA7	0xf2cc0020
+#define	F367TER_SFEC_OVERFLOW	0xf2cc0010
+#define	F367TER_SFEC_DEMODSEL2	0xf2cc0008
+#define	F367TER_SFEC_NOSYNC	0xf2cc0004
+#define	F367TER_SFEC_UNREGULA	0xf2cc0002
+#define	F367TER_SFEC_READY	0xf2cc0001
+
+/* SFDLYH */
+#define	R367TER_SFDLYH	0xf2cd
+#define	F367TER_SFEC_TSTIMEVALID	0xf2cd0080
+#define	F367TER_SFEC_SPEEDUP	0xf2cd0040
+#define	F367TER_SFEC_STOP	0xf2cd0020
+#define	F367TER_SFEC_REGULATED	0xf2cd0010
+#define	F367TER_SFEC_REALSYMBOFFSET	0xf2cd000f
+
+/* SFDLYM */
+#define	R367TER_SFDLYM	0xf2ce
+#define	F367TER_SFEC_REALSYMBOFFSET_HI	0xf2ce00ff
+
+/* SFDLYL */
+#define	R367TER_SFDLYL	0xf2cf
+#define	F367TER_SFEC_REALSYMBOFFSET_LO	0xf2cf00ff
+
+/* SFDLYSETH */
+#define	R367TER_SFDLYSETH	0xf2d0
+#define	F367TER_SFEC_OFFSET	0xf2d000e0
+#define	F367TER_SFECDLYSETH_4	0xf2d00010
+#define	F367TER_RST_SFEC	0xf2d00008
+#define	F367TER_SFECDLYSETH_2	0xf2d00004
+#define	F367TER_SFEC_DISABLE	0xf2d00002
+#define	F367TER_SFEC_UNREGUL	0xf2d00001
+
+/* SFDLYSETM */
+#define	R367TER_SFDLYSETM	0xf2d1
+#define	F367TER_SFECDLYSETM_7	0xf2d10080
+#define	F367TER_SFEC_SYMBOFFSET_HI	0xf2d1007f
+
+/* SFDLYSETL */
+#define	R367TER_SFDLYSETL	0xf2d2
+#define	F367TER_SFEC_SYMBOFFSET_LO	0xf2d200ff
+
+/* SFOBSCFG */
+#define	R367TER_SFOBSCFG	0xf2d3
+#define	F367TER_SFEC_OBSCFG	0xf2d300ff
+
+/* SFOBSM */
+#define	R367TER_SFOBSM	0xf2d4
+#define	F367TER_SFEC_OBSDATA_HI	0xf2d400ff
+
+/* SFOBSL */
+#define	R367TER_SFOBSL	0xf2d5
+#define	F367TER_SFEC_OBSDATA_LO	0xf2d500ff
+
+/* SFECINFO */
+#define	R367TER_SFECINFO	0xf2d6
+#define	F367TER_SFECINFO_7	0xf2d60080
+#define	F367TER_SFEC_SYNCDLSB	0xf2d60070
+#define	F367TER_SFCE_S1cPHASE	0xf2d6000f
+
+/* SFERRCTRL */
+#define	R367TER_SFERRCTRL	0xf2d8
+#define	F367TER_SFEC_ERR_SOURCE	0xf2d800f0
+#define	F367TER_SFERRCTRL_3	0xf2d80008
+#define	F367TER_SFEC_NUM_EVENT	0xf2d80007
+
+/* SFERRCNTH */
+#define	R367TER_SFERRCNTH	0xf2d9
+#define	F367TER_SFERRC_OLDVALUE	0xf2d90080
+#define	F367TER_SFEC_ERR_CNT	0xf2d9007f
+
+/* SFERRCNTM */
+#define	R367TER_SFERRCNTM	0xf2da
+#define	F367TER_SFEC_ERR_CNT_HI	0xf2da00ff
+
+/* SFERRCNTL */
+#define	R367TER_SFERRCNTL	0xf2db
+#define	F367TER_SFEC_ERR_CNT_LO	0xf2db00ff
+
+/* SYMBRATEM */
+#define	R367TER_SYMBRATEM	0xf2e0
+#define	F367TER_DEFGEN_SYMBRATE_HI	0xf2e000ff
+
+/* SYMBRATEL */
+#define	R367TER_SYMBRATEL	0xf2e1
+#define	F367TER_DEFGEN_SYMBRATE_LO	0xf2e100ff
+
+/* SYMBSTATUS */
+#define	R367TER_SYMBSTATUS	0xf2e2
+#define	F367TER_SYMBDLINE2_OFF	0xf2e20080
+#define	F367TER_SDDL_REINIT1	0xf2e20040
+#define	F367TER_SDD_REINIT1	0xf2e20020
+#define	F367TER_TOKENID_ERROR	0xf2e20010
+#define	F367TER_SYMBRATE_OVERFLOW	0xf2e20008
+#define	F367TER_SYMBRATE_UNDERFLOW	0xf2e20004
+#define	F367TER_TOKENID_RSTEVENT	0xf2e20002
+#define	F367TER_TOKENID_RESET1	0xf2e20001
+
+/* SYMBCFG */
+#define	R367TER_SYMBCFG	0xf2e3
+#define	F367TER_SYMBCFG_7	0xf2e30080
+#define	F367TER_SYMBCFG_6	0xf2e30040
+#define	F367TER_SYMBCFG_5	0xf2e30020
+#define	F367TER_SYMBCFG_4	0xf2e30010
+#define	F367TER_SYMRATE_FSPEED	0xf2e3000c
+#define	F367TER_SYMRATE_SSPEED	0xf2e30003
+
+/* SYMBFIFOM */
+#define	R367TER_SYMBFIFOM	0xf2e4
+#define	F367TER_SYMBFIFOM_7	0xf2e40080
+#define	F367TER_SYMBFIFOM_6	0xf2e40040
+#define	F367TER_DEFGEN_SYMFIFO_HI	0xf2e4003f
+
+/* SYMBFIFOL */
+#define	R367TER_SYMBFIFOL	0xf2e5
+#define	F367TER_DEFGEN_SYMFIFO_LO	0xf2e500ff
+
+/* SYMBOFFSM */
+#define	R367TER_SYMBOFFSM	0xf2e6
+#define	F367TER_TOKENID_RESET2	0xf2e60080
+#define	F367TER_SDDL_REINIT2	0xf2e60040
+#define	F367TER_SDD_REINIT2	0xf2e60020
+#define	F367TER_SYMBOFFSM_4	0xf2e60010
+#define	F367TER_SYMBOFFSM_3	0xf2e60008
+#define	F367TER_DEFGEN_SYMBOFFSET_HI	0xf2e60007
+
+/* SYMBOFFSL */
+#define	R367TER_SYMBOFFSL	0xf2e7
+#define	F367TER_DEFGEN_SYMBOFFSET_LO	0xf2e700ff
+
+/* DEBUG_LT4 */
+#define	R367TER_DEBUG_LT4	0xf400
+#define	F367TER_F_DEBUG_LT4	0xf40000ff
+
+/* DEBUG_LT5 */
+#define	R367TER_DEBUG_LT5	0xf401
+#define	F367TER_F_DEBUG_LT5	0xf40100ff
+
+/* DEBUG_LT6 */
+#define	R367TER_DEBUG_LT6	0xf402
+#define	F367TER_F_DEBUG_LT6	0xf40200ff
+
+/* DEBUG_LT7 */
+#define	R367TER_DEBUG_LT7	0xf403
+#define	F367TER_F_DEBUG_LT7	0xf40300ff
+
+/* DEBUG_LT8 */
+#define	R367TER_DEBUG_LT8	0xf404
+#define	F367TER_F_DEBUG_LT8	0xf40400ff
+
+/* DEBUG_LT9 */
+#define	R367TER_DEBUG_LT9	0xf405
+#define	F367TER_F_DEBUG_LT9	0xf40500ff
+
+#define STV0367TER_NBREGS	445
+
+/* ID */
+#define	R367CAB_ID	0xf000
+#define	F367CAB_IDENTIFICATIONREGISTER	0xf00000ff
+
+/* I2CRPT */
+#define	R367CAB_I2CRPT	0xf001
+#define	F367CAB_I2CT_ON	0xf0010080
+#define	F367CAB_ENARPT_LEVEL	0xf0010070
+#define	F367CAB_SCLT_DELAY	0xf0010008
+#define	F367CAB_SCLT_NOD	0xf0010004
+#define	F367CAB_STOP_ENABLE	0xf0010002
+#define	F367CAB_SDAT_NOD	0xf0010001
+
+/* TOPCTRL */
+#define	R367CAB_TOPCTRL	0xf002
+#define	F367CAB_STDBY	0xf0020080
+#define	F367CAB_STDBY_CORE	0xf0020020
+#define	F367CAB_QAM_COFDM	0xf0020010
+#define	F367CAB_TS_DIS	0xf0020008
+#define	F367CAB_DIR_CLK_216	0xf0020004
+
+/* IOCFG0 */
+#define	R367CAB_IOCFG0	0xf003
+#define	F367CAB_OP0_SD	0xf0030080
+#define	F367CAB_OP0_VAL	0xf0030040
+#define	F367CAB_OP0_OD	0xf0030020
+#define	F367CAB_OP0_INV	0xf0030010
+#define	F367CAB_OP0_DACVALUE_HI	0xf003000f
+
+/* DAc0R */
+#define	R367CAB_DAC0R	0xf004
+#define	F367CAB_OP0_DACVALUE_LO	0xf00400ff
+
+/* IOCFG1 */
+#define	R367CAB_IOCFG1	0xf005
+#define	F367CAB_IP0	0xf0050040
+#define	F367CAB_OP1_OD	0xf0050020
+#define	F367CAB_OP1_INV	0xf0050010
+#define	F367CAB_OP1_DACVALUE_HI	0xf005000f
+
+/* DAC1R */
+#define	R367CAB_DAC1R	0xf006
+#define	F367CAB_OP1_DACVALUE_LO	0xf00600ff
+
+/* IOCFG2 */
+#define	R367CAB_IOCFG2	0xf007
+#define	F367CAB_OP2_LOCK_CONF	0xf00700e0
+#define	F367CAB_OP2_OD	0xf0070010
+#define	F367CAB_OP2_VAL	0xf0070008
+#define	F367CAB_OP1_LOCK_CONF	0xf0070007
+
+/* SDFR */
+#define	R367CAB_SDFR	0xf008
+#define	F367CAB_OP0_FREQ	0xf00800f0
+#define	F367CAB_OP1_FREQ	0xf008000f
+
+/* AUX_CLK */
+#define	R367CAB_AUX_CLK	0xf00a
+#define	F367CAB_AUXFEC_CTL	0xf00a00c0
+#define	F367CAB_DIS_CKX4	0xf00a0020
+#define	F367CAB_CKSEL	0xf00a0018
+#define	F367CAB_CKDIV_PROG	0xf00a0006
+#define	F367CAB_AUXCLK_ENA	0xf00a0001
+
+/* FREESYS1 */
+#define	R367CAB_FREESYS1	0xf00b
+#define	F367CAB_FREESYS_1	0xf00b00ff
+
+/* FREESYS2 */
+#define	R367CAB_FREESYS2	0xf00c
+#define	F367CAB_FREESYS_2	0xf00c00ff
+
+/* FREESYS3 */
+#define	R367CAB_FREESYS3	0xf00d
+#define	F367CAB_FREESYS_3	0xf00d00ff
+
+/* GPIO_CFG */
+#define	R367CAB_GPIO_CFG	0xf00e
+#define	F367CAB_GPIO7_OD	0xf00e0080
+#define	F367CAB_GPIO7_CFG	0xf00e0040
+#define	F367CAB_GPIO6_OD	0xf00e0020
+#define	F367CAB_GPIO6_CFG	0xf00e0010
+#define	F367CAB_GPIO5_OD	0xf00e0008
+#define	F367CAB_GPIO5_CFG	0xf00e0004
+#define	F367CAB_GPIO4_OD	0xf00e0002
+#define	F367CAB_GPIO4_CFG	0xf00e0001
+
+/* GPIO_CMD */
+#define	R367CAB_GPIO_CMD	0xf00f
+#define	F367CAB_GPIO7_VAL	0xf00f0008
+#define	F367CAB_GPIO6_VAL	0xf00f0004
+#define	F367CAB_GPIO5_VAL	0xf00f0002
+#define	F367CAB_GPIO4_VAL	0xf00f0001
+
+/* TSTRES */
+#define	R367CAB_TSTRES	0xf0c0
+#define	F367CAB_FRES_DISPLAY	0xf0c00080
+#define	F367CAB_FRES_FIFO_AD	0xf0c00020
+#define	F367CAB_FRESRS	0xf0c00010
+#define	F367CAB_FRESACS	0xf0c00008
+#define	F367CAB_FRESFEC	0xf0c00004
+#define	F367CAB_FRES_PRIF	0xf0c00002
+#define	F367CAB_FRESCORE	0xf0c00001
+
+/* ANACTRL */
+#define	R367CAB_ANACTRL	0xf0c1
+#define	F367CAB_BYPASS_XTAL	0xf0c10040
+#define	F367CAB_BYPASS_PLLXN	0xf0c1000c
+#define	F367CAB_DIS_PAD_OSC	0xf0c10002
+#define	F367CAB_STDBY_PLLXN	0xf0c10001
+
+/* TSTBUS */
+#define	R367CAB_TSTBUS	0xf0c2
+#define	F367CAB_TS_BYTE_CLK_INV	0xf0c20080
+#define	F367CAB_CFG_IP	0xf0c20070
+#define	F367CAB_CFG_TST	0xf0c2000f
+
+/* RF_AGC1 */
+#define	R367CAB_RF_AGC1	0xf0d4
+#define	F367CAB_RF_AGC1_LEVEL_HI	0xf0d400ff
+
+/* RF_AGC2 */
+#define	R367CAB_RF_AGC2	0xf0d5
+#define	F367CAB_REF_ADGP	0xf0d50080
+#define	F367CAB_STDBY_ADCGP	0xf0d50020
+#define	F367CAB_RF_AGC1_LEVEL_LO	0xf0d50003
+
+/* ANADIGCTRL */
+#define	R367CAB_ANADIGCTRL	0xf0d7
+#define	F367CAB_SEL_CLKDEM	0xf0d70020
+#define	F367CAB_EN_BUFFER_Q	0xf0d70010
+#define	F367CAB_EN_BUFFER_I	0xf0d70008
+#define	F367CAB_ADC_RIS_EGDE	0xf0d70004
+#define	F367CAB_SGN_ADC	0xf0d70002
+#define	F367CAB_SEL_AD12_SYNC	0xf0d70001
+
+/* PLLMDIV */
+#define	R367CAB_PLLMDIV	0xf0d8
+#define	F367CAB_PLL_MDIV	0xf0d800ff
+
+/* PLLNDIV */
+#define	R367CAB_PLLNDIV	0xf0d9
+#define	F367CAB_PLL_NDIV	0xf0d900ff
+
+/* PLLSETUP */
+#define	R367CAB_PLLSETUP	0xf0da
+#define	F367CAB_PLL_PDIV	0xf0da0070
+#define	F367CAB_PLL_KDIV	0xf0da000f
+
+/* DUAL_AD12 */
+#define	R367CAB_DUAL_AD12	0xf0db
+#define	F367CAB_FS20M	0xf0db0020
+#define	F367CAB_FS50M	0xf0db0010
+#define	F367CAB_INMODe0	0xf0db0008
+#define	F367CAB_POFFQ	0xf0db0004
+#define	F367CAB_POFFI	0xf0db0002
+#define	F367CAB_INMODE1	0xf0db0001
+
+/* TSTBIST */
+#define	R367CAB_TSTBIST	0xf0dc
+#define	F367CAB_TST_BYP_CLK	0xf0dc0080
+#define	F367CAB_TST_GCLKENA_STD	0xf0dc0040
+#define	F367CAB_TST_GCLKENA	0xf0dc0020
+#define	F367CAB_TST_MEMBIST	0xf0dc001f
+
+/* CTRL_1 */
+#define	R367CAB_CTRL_1	0xf402
+#define	F367CAB_SOFT_RST	0xf4020080
+#define	F367CAB_EQU_RST	0xf4020008
+#define	F367CAB_CRL_RST	0xf4020004
+#define	F367CAB_TRL_RST	0xf4020002
+#define	F367CAB_AGC_RST	0xf4020001
+
+/* CTRL_2 */
+#define	R367CAB_CTRL_2	0xf403
+#define	F367CAB_DEINT_RST	0xf4030008
+#define	F367CAB_RS_RST	0xf4030004
+
+/* IT_STATUS1 */
+#define	R367CAB_IT_STATUS1	0xf408
+#define	F367CAB_SWEEP_OUT	0xf4080080
+#define	F367CAB_FSM_CRL	0xf4080040
+#define	F367CAB_CRL_LOCK	0xf4080020
+#define	F367CAB_MFSM	0xf4080010
+#define	F367CAB_TRL_LOCK	0xf4080008
+#define	F367CAB_TRL_AGC_LIMIT	0xf4080004
+#define	F367CAB_ADJ_AGC_LOCK	0xf4080002
+#define	F367CAB_AGC_QAM_LOCK	0xf4080001
+
+/* IT_STATUS2 */
+#define	R367CAB_IT_STATUS2	0xf409
+#define	F367CAB_TSMF_CNT	0xf4090080
+#define	F367CAB_TSMF_EOF	0xf4090040
+#define	F367CAB_TSMF_RDY	0xf4090020
+#define	F367CAB_FEC_NOCORR	0xf4090010
+#define	F367CAB_SYNCSTATE	0xf4090008
+#define	F367CAB_DEINT_LOCK	0xf4090004
+#define	F367CAB_FADDING_FRZ	0xf4090002
+#define	F367CAB_TAPMON_ALARM	0xf4090001
+
+/* IT_EN1 */
+#define	R367CAB_IT_EN1	0xf40a
+#define	F367CAB_SWEEP_OUTE	0xf40a0080
+#define	F367CAB_FSM_CRLE	0xf40a0040
+#define	F367CAB_CRL_LOCKE	0xf40a0020
+#define	F367CAB_MFSME	0xf40a0010
+#define	F367CAB_TRL_LOCKE	0xf40a0008
+#define	F367CAB_TRL_AGC_LIMITE	0xf40a0004
+#define	F367CAB_ADJ_AGC_LOCKE	0xf40a0002
+#define	F367CAB_AGC_LOCKE	0xf40a0001
+
+/* IT_EN2 */
+#define	R367CAB_IT_EN2	0xf40b
+#define	F367CAB_TSMF_CNTE	0xf40b0080
+#define	F367CAB_TSMF_EOFE	0xf40b0040
+#define	F367CAB_TSMF_RDYE	0xf40b0020
+#define	F367CAB_FEC_NOCORRE	0xf40b0010
+#define	F367CAB_SYNCSTATEE	0xf40b0008
+#define	F367CAB_DEINT_LOCKE	0xf40b0004
+#define	F367CAB_FADDING_FRZE	0xf40b0002
+#define	F367CAB_TAPMON_ALARME	0xf40b0001
+
+/* CTRL_STATUS */
+#define	R367CAB_CTRL_STATUS	0xf40c
+#define	F367CAB_QAMFEC_LOCK	0xf40c0004
+#define	F367CAB_TSMF_LOCK	0xf40c0002
+#define	F367CAB_TSMF_ERROR	0xf40c0001
+
+/* TEST_CTL */
+#define	R367CAB_TEST_CTL	0xf40f
+#define	F367CAB_TST_BLK_SEL	0xf40f0060
+#define	F367CAB_TST_BUS_SEL	0xf40f001f
+
+/* AGC_CTL */
+#define	R367CAB_AGC_CTL	0xf410
+#define	F367CAB_AGC_LCK_TH	0xf41000f0
+#define	F367CAB_AGC_ACCUMRSTSEL	0xf4100007
+
+/* AGC_IF_CFG */
+#define	R367CAB_AGC_IF_CFG	0xf411
+#define	F367CAB_AGC_IF_BWSEL	0xf41100f0
+#define	F367CAB_AGC_IF_FREEZE	0xf4110002
+
+/* AGC_RF_CFG */
+#define	R367CAB_AGC_RF_CFG	0xf412
+#define	F367CAB_AGC_RF_BWSEL	0xf4120070
+#define	F367CAB_AGC_RF_FREEZE	0xf4120002
+
+/* AGC_PWM_CFG */
+#define	R367CAB_AGC_PWM_CFG	0xf413
+#define	F367CAB_AGC_RF_PWM_TST	0xf4130080
+#define	F367CAB_AGC_RF_PWM_INV	0xf4130040
+#define	F367CAB_AGC_IF_PWM_TST	0xf4130008
+#define	F367CAB_AGC_IF_PWM_INV	0xf4130004
+#define	F367CAB_AGC_PWM_CLKDIV	0xf4130003
+
+/* AGC_PWR_REF_L */
+#define	R367CAB_AGC_PWR_REF_L	0xf414
+#define	F367CAB_AGC_PWRREF_LO	0xf41400ff
+
+/* AGC_PWR_REF_H */
+#define	R367CAB_AGC_PWR_REF_H	0xf415
+#define	F367CAB_AGC_PWRREF_HI	0xf4150003
+
+/* AGC_RF_TH_L */
+#define	R367CAB_AGC_RF_TH_L	0xf416
+#define	F367CAB_AGC_RF_TH_LO	0xf41600ff
+
+/* AGC_RF_TH_H */
+#define	R367CAB_AGC_RF_TH_H	0xf417
+#define	F367CAB_AGC_RF_TH_HI	0xf417000f
+
+/* AGC_IF_LTH_L */
+#define	R367CAB_AGC_IF_LTH_L	0xf418
+#define	F367CAB_AGC_IF_THLO_LO	0xf41800ff
+
+/* AGC_IF_LTH_H */
+#define	R367CAB_AGC_IF_LTH_H	0xf419
+#define	F367CAB_AGC_IF_THLO_HI	0xf419000f
+
+/* AGC_IF_HTH_L */
+#define	R367CAB_AGC_IF_HTH_L	0xf41a
+#define	F367CAB_AGC_IF_THHI_LO	0xf41a00ff
+
+/* AGC_IF_HTH_H */
+#define	R367CAB_AGC_IF_HTH_H	0xf41b
+#define	F367CAB_AGC_IF_THHI_HI	0xf41b000f
+
+/* AGC_PWR_RD_L */
+#define	R367CAB_AGC_PWR_RD_L	0xf41c
+#define	F367CAB_AGC_PWR_WORD_LO	0xf41c00ff
+
+/* AGC_PWR_RD_M */
+#define	R367CAB_AGC_PWR_RD_M	0xf41d
+#define	F367CAB_AGC_PWR_WORD_ME	0xf41d00ff
+
+/* AGC_PWR_RD_H */
+#define	R367CAB_AGC_PWR_RD_H	0xf41e
+#define	F367CAB_AGC_PWR_WORD_HI	0xf41e0003
+
+/* AGC_PWM_IFCMD_L */
+#define	R367CAB_AGC_PWM_IFCMD_L	0xf420
+#define	F367CAB_AGC_IF_PWMCMD_LO	0xf42000ff
+
+/* AGC_PWM_IFCMD_H */
+#define	R367CAB_AGC_PWM_IFCMD_H	0xf421
+#define	F367CAB_AGC_IF_PWMCMD_HI	0xf421000f
+
+/* AGC_PWM_RFCMD_L */
+#define	R367CAB_AGC_PWM_RFCMD_L	0xf422
+#define	F367CAB_AGC_RF_PWMCMD_LO	0xf42200ff
+
+/* AGC_PWM_RFCMD_H */
+#define	R367CAB_AGC_PWM_RFCMD_H	0xf423
+#define	F367CAB_AGC_RF_PWMCMD_HI	0xf423000f
+
+/* IQDEM_CFG */
+#define	R367CAB_IQDEM_CFG	0xf424
+#define	F367CAB_IQDEM_CLK_SEL	0xf4240004
+#define	F367CAB_IQDEM_INVIQ	0xf4240002
+#define	F367CAB_IQDEM_A2dTYPE	0xf4240001
+
+/* MIX_NCO_LL */
+#define	R367CAB_MIX_NCO_LL	0xf425
+#define	F367CAB_MIX_NCO_INC_LL	0xf42500ff
+
+/* MIX_NCO_HL */
+#define	R367CAB_MIX_NCO_HL	0xf426
+#define	F367CAB_MIX_NCO_INC_HL	0xf42600ff
+
+/* MIX_NCO_HH */
+#define	R367CAB_MIX_NCO_HH	0xf427
+#define	F367CAB_MIX_NCO_INVCNST	0xf4270080
+#define	F367CAB_MIX_NCO_INC_HH	0xf427007f
+
+/* SRC_NCO_LL */
+#define	R367CAB_SRC_NCO_LL	0xf428
+#define	F367CAB_SRC_NCO_INC_LL	0xf42800ff
+
+/* SRC_NCO_LH */
+#define	R367CAB_SRC_NCO_LH	0xf429
+#define	F367CAB_SRC_NCO_INC_LH	0xf42900ff
+
+/* SRC_NCO_HL */
+#define	R367CAB_SRC_NCO_HL	0xf42a
+#define	F367CAB_SRC_NCO_INC_HL	0xf42a00ff
+
+/* SRC_NCO_HH */
+#define	R367CAB_SRC_NCO_HH	0xf42b
+#define	F367CAB_SRC_NCO_INC_HH	0xf42b007f
+
+/* IQDEM_GAIN_SRC_L */
+#define	R367CAB_IQDEM_GAIN_SRC_L	0xf42c
+#define	F367CAB_GAIN_SRC_LO	0xf42c00ff
+
+/* IQDEM_GAIN_SRC_H */
+#define	R367CAB_IQDEM_GAIN_SRC_H	0xf42d
+#define	F367CAB_GAIN_SRC_HI	0xf42d0003
+
+/* IQDEM_DCRM_CFG_LL */
+#define	R367CAB_IQDEM_DCRM_CFG_LL	0xf430
+#define	F367CAB_DCRM0_DCIN_L	0xf43000ff
+
+/* IQDEM_DCRM_CFG_LH */
+#define	R367CAB_IQDEM_DCRM_CFG_LH	0xf431
+#define	F367CAB_DCRM1_I_DCIN_L	0xf43100fc
+#define	F367CAB_DCRM0_DCIN_H	0xf4310003
+
+/* IQDEM_DCRM_CFG_HL */
+#define	R367CAB_IQDEM_DCRM_CFG_HL	0xf432
+#define	F367CAB_DCRM1_Q_DCIN_L	0xf43200f0
+#define	F367CAB_DCRM1_I_DCIN_H	0xf432000f
+
+/* IQDEM_DCRM_CFG_HH */
+#define	R367CAB_IQDEM_DCRM_CFG_HH	0xf433
+#define	F367CAB_DCRM1_FRZ	0xf4330080
+#define	F367CAB_DCRM0_FRZ	0xf4330040
+#define	F367CAB_DCRM1_Q_DCIN_H	0xf433003f
+
+/* IQDEM_ADJ_COEFf0 */
+#define	R367CAB_IQDEM_ADJ_COEFF0	0xf434
+#define	F367CAB_ADJIIR_COEFF10_L	0xf43400ff
+
+/* IQDEM_ADJ_COEFF1 */
+#define	R367CAB_IQDEM_ADJ_COEFF1	0xf435
+#define	F367CAB_ADJIIR_COEFF11_L	0xf43500fc
+#define	F367CAB_ADJIIR_COEFF10_H	0xf4350003
+
+/* IQDEM_ADJ_COEFF2 */
+#define	R367CAB_IQDEM_ADJ_COEFF2	0xf436
+#define	F367CAB_ADJIIR_COEFF12_L	0xf43600f0
+#define	F367CAB_ADJIIR_COEFF11_H	0xf436000f
+
+/* IQDEM_ADJ_COEFF3 */
+#define	R367CAB_IQDEM_ADJ_COEFF3	0xf437
+#define	F367CAB_ADJIIR_COEFF20_L	0xf43700c0
+#define	F367CAB_ADJIIR_COEFF12_H	0xf437003f
+
+/* IQDEM_ADJ_COEFF4 */
+#define	R367CAB_IQDEM_ADJ_COEFF4	0xf438
+#define	F367CAB_ADJIIR_COEFF20_H	0xf43800ff
+
+/* IQDEM_ADJ_COEFF5 */
+#define	R367CAB_IQDEM_ADJ_COEFF5	0xf439
+#define	F367CAB_ADJIIR_COEFF21_L	0xf43900ff
+
+/* IQDEM_ADJ_COEFF6 */
+#define	R367CAB_IQDEM_ADJ_COEFF6	0xf43a
+#define	F367CAB_ADJIIR_COEFF22_L	0xf43a00fc
+#define	F367CAB_ADJIIR_COEFF21_H	0xf43a0003
+
+/* IQDEM_ADJ_COEFF7 */
+#define	R367CAB_IQDEM_ADJ_COEFF7	0xf43b
+#define	F367CAB_ADJIIR_COEFF22_H	0xf43b000f
+
+/* IQDEM_ADJ_EN */
+#define	R367CAB_IQDEM_ADJ_EN	0xf43c
+#define	F367CAB_ALLPASSFILT_EN	0xf43c0008
+#define	F367CAB_ADJ_AGC_EN	0xf43c0004
+#define	F367CAB_ADJ_COEFF_FRZ	0xf43c0002
+#define	F367CAB_ADJ_EN	0xf43c0001
+
+/* IQDEM_ADJ_AGC_REF */
+#define	R367CAB_IQDEM_ADJ_AGC_REF	0xf43d
+#define	F367CAB_ADJ_AGC_REF	0xf43d00ff
+
+/* ALLPASSFILT1 */
+#define	R367CAB_ALLPASSFILT1	0xf440
+#define	F367CAB_ALLPASSFILT_COEFF1_LO	0xf44000ff
+
+/* ALLPASSFILT2 */
+#define	R367CAB_ALLPASSFILT2	0xf441
+#define	F367CAB_ALLPASSFILT_COEFF1_ME	0xf44100ff
+
+/* ALLPASSFILT3 */
+#define	R367CAB_ALLPASSFILT3	0xf442
+#define	F367CAB_ALLPASSFILT_COEFF2_LO	0xf44200c0
+#define	F367CAB_ALLPASSFILT_COEFF1_HI	0xf442003f
+
+/* ALLPASSFILT4 */
+#define	R367CAB_ALLPASSFILT4	0xf443
+#define	F367CAB_ALLPASSFILT_COEFF2_MEL	0xf44300ff
+
+/* ALLPASSFILT5 */
+#define	R367CAB_ALLPASSFILT5	0xf444
+#define	F367CAB_ALLPASSFILT_COEFF2_MEH	0xf44400ff
+
+/* ALLPASSFILT6 */
+#define	R367CAB_ALLPASSFILT6	0xf445
+#define	F367CAB_ALLPASSFILT_COEFF3_LO	0xf44500f0
+#define	F367CAB_ALLPASSFILT_COEFF2_HI	0xf445000f
+
+/* ALLPASSFILT7 */
+#define	R367CAB_ALLPASSFILT7	0xf446
+#define	F367CAB_ALLPASSFILT_COEFF3_MEL	0xf44600ff
+
+/* ALLPASSFILT8 */
+#define	R367CAB_ALLPASSFILT8	0xf447
+#define	F367CAB_ALLPASSFILT_COEFF3_MEH	0xf44700ff
+
+/* ALLPASSFILT9 */
+#define	R367CAB_ALLPASSFILT9	0xf448
+#define	F367CAB_ALLPASSFILT_COEFF4_LO	0xf44800fc
+#define	F367CAB_ALLPASSFILT_COEFF3_HI	0xf4480003
+
+/* ALLPASSFILT10 */
+#define	R367CAB_ALLPASSFILT10	0xf449
+#define	F367CAB_ALLPASSFILT_COEFF4_ME	0xf44900ff
+
+/* ALLPASSFILT11 */
+#define	R367CAB_ALLPASSFILT11	0xf44a
+#define	F367CAB_ALLPASSFILT_COEFF4_HI	0xf44a00ff
+
+/* TRL_AGC_CFG */
+#define	R367CAB_TRL_AGC_CFG	0xf450
+#define	F367CAB_TRL_AGC_FREEZE	0xf4500080
+#define	F367CAB_TRL_AGC_REF	0xf450007f
+
+/* TRL_LPF_CFG */
+#define	R367CAB_TRL_LPF_CFG	0xf454
+#define	F367CAB_NYQPOINT_INV	0xf4540040
+#define	F367CAB_TRL_SHIFT	0xf4540030
+#define	F367CAB_NYQ_COEFF_SEL	0xf454000c
+#define	F367CAB_TRL_LPF_FREEZE	0xf4540002
+#define	F367CAB_TRL_LPF_CRT	0xf4540001
+
+/* TRL_LPF_ACQ_GAIN */
+#define	R367CAB_TRL_LPF_ACQ_GAIN	0xf455
+#define	F367CAB_TRL_GDIR_ACQ	0xf4550070
+#define	F367CAB_TRL_GINT_ACQ	0xf4550007
+
+/* TRL_LPF_TRK_GAIN */
+#define	R367CAB_TRL_LPF_TRK_GAIN	0xf456
+#define	F367CAB_TRL_GDIR_TRK	0xf4560070
+#define	F367CAB_TRL_GINT_TRK	0xf4560007
+
+/* TRL_LPF_OUT_GAIN */
+#define	R367CAB_TRL_LPF_OUT_GAIN	0xf457
+#define	F367CAB_TRL_GAIN_OUT	0xf4570007
+
+/* TRL_LOCKDET_LTH */
+#define	R367CAB_TRL_LOCKDET_LTH	0xf458
+#define	F367CAB_TRL_LCK_THLO	0xf4580007
+
+/* TRL_LOCKDET_HTH */
+#define	R367CAB_TRL_LOCKDET_HTH	0xf459
+#define	F367CAB_TRL_LCK_THHI	0xf45900ff
+
+/* TRL_LOCKDET_TRGVAL */
+#define	R367CAB_TRL_LOCKDET_TRGVAL	0xf45a
+#define	F367CAB_TRL_LCK_TRG	0xf45a00ff
+
+/* IQ_QAM */
+#define	R367CAB_IQ_QAM	0xf45c
+#define	F367CAB_IQ_INPUT	0xf45c0008
+#define	F367CAB_DETECT_MODE	0xf45c0007
+
+/* FSM_STATE */
+#define	R367CAB_FSM_STATE	0xf460
+#define	F367CAB_CRL_DFE	0xf4600080
+#define	F367CAB_DFE_START	0xf4600040
+#define	F367CAB_CTRLG_START	0xf4600030
+#define	F367CAB_FSM_FORCESTATE	0xf460000f
+
+/* FSM_CTL */
+#define	R367CAB_FSM_CTL	0xf461
+#define	F367CAB_FEC2_EN	0xf4610040
+#define	F367CAB_SIT_EN	0xf4610020
+#define	F367CAB_TRL_AHEAD	0xf4610010
+#define	F367CAB_TRL2_EN	0xf4610008
+#define	F367CAB_FSM_EQA1_EN	0xf4610004
+#define	F367CAB_FSM_BKP_DIS	0xf4610002
+#define	F367CAB_FSM_FORCE_EN	0xf4610001
+
+/* FSM_STS */
+#define	R367CAB_FSM_STS	0xf462
+#define	F367CAB_FSM_STATUS	0xf462000f
+
+/* FSM_SNR0_HTH */
+#define	R367CAB_FSM_SNR0_HTH	0xf463
+#define	F367CAB_SNR0_HTH	0xf46300ff
+
+/* FSM_SNR1_HTH */
+#define	R367CAB_FSM_SNR1_HTH	0xf464
+#define	F367CAB_SNR1_HTH	0xf46400ff
+
+/* FSM_SNR2_HTH */
+#define	R367CAB_FSM_SNR2_HTH	0xf465
+#define	F367CAB_SNR2_HTH	0xf46500ff
+
+/* FSM_SNR0_LTH */
+#define	R367CAB_FSM_SNR0_LTH	0xf466
+#define	F367CAB_SNR0_LTH	0xf46600ff
+
+/* FSM_SNR1_LTH */
+#define	R367CAB_FSM_SNR1_LTH	0xf467
+#define	F367CAB_SNR1_LTH	0xf46700ff
+
+/* FSM_EQA1_HTH */
+#define	R367CAB_FSM_EQA1_HTH	0xf468
+#define	F367CAB_SNR3_HTH_LO	0xf46800f0
+#define	F367CAB_EQA1_HTH	0xf468000f
+
+/* FSM_TEMPO */
+#define	R367CAB_FSM_TEMPO	0xf469
+#define	F367CAB_SIT	0xf46900c0
+#define	F367CAB_WST	0xf4690038
+#define	F367CAB_ELT	0xf4690006
+#define	F367CAB_SNR3_HTH_HI	0xf4690001
+
+/* FSM_CONFIG */
+#define	R367CAB_FSM_CONFIG	0xf46a
+#define	F367CAB_FEC2_DFEOFF	0xf46a0004
+#define	F367CAB_PRIT_STATE	0xf46a0002
+#define	F367CAB_MODMAP_STATE	0xf46a0001
+
+/* EQU_I_TESTTAP_L */
+#define	R367CAB_EQU_I_TESTTAP_L	0xf474
+#define	F367CAB_I_TEST_TAP_L	0xf47400ff
+
+/* EQU_I_TESTTAP_M */
+#define	R367CAB_EQU_I_TESTTAP_M	0xf475
+#define	F367CAB_I_TEST_TAP_M	0xf47500ff
+
+/* EQU_I_TESTTAP_H */
+#define	R367CAB_EQU_I_TESTTAP_H	0xf476
+#define	F367CAB_I_TEST_TAP_H	0xf476001f
+
+/* EQU_TESTAP_CFG */
+#define	R367CAB_EQU_TESTAP_CFG	0xf477
+#define	F367CAB_TEST_FFE_DFE_SEL	0xf4770040
+#define	F367CAB_TEST_TAP_SELECT	0xf477003f
+
+/* EQU_Q_TESTTAP_L */
+#define	R367CAB_EQU_Q_TESTTAP_L	0xf478
+#define	F367CAB_Q_TEST_TAP_L	0xf47800ff
+
+/* EQU_Q_TESTTAP_M */
+#define	R367CAB_EQU_Q_TESTTAP_M	0xf479
+#define	F367CAB_Q_TEST_TAP_M	0xf47900ff
+
+/* EQU_Q_TESTTAP_H */
+#define	R367CAB_EQU_Q_TESTTAP_H	0xf47a
+#define	F367CAB_Q_TEST_TAP_H	0xf47a001f
+
+/* EQU_TAP_CTRL */
+#define	R367CAB_EQU_TAP_CTRL	0xf47b
+#define	F367CAB_MTAP_FRZ	0xf47b0010
+#define	F367CAB_PRE_FREEZE	0xf47b0008
+#define	F367CAB_DFE_TAPMON_EN	0xf47b0004
+#define	F367CAB_FFE_TAPMON_EN	0xf47b0002
+#define	F367CAB_MTAP_ONLY	0xf47b0001
+
+/* EQU_CTR_CRL_CONTROL_L */
+#define	R367CAB_EQU_CTR_CRL_CONTROL_L	0xf47c
+#define	F367CAB_EQU_CTR_CRL_CONTROL_LO	0xf47c00ff
+
+/* EQU_CTR_CRL_CONTROL_H */
+#define	R367CAB_EQU_CTR_CRL_CONTROL_H	0xf47d
+#define	F367CAB_EQU_CTR_CRL_CONTROL_HI	0xf47d00ff
+
+/* EQU_CTR_HIPOW_L */
+#define	R367CAB_EQU_CTR_HIPOW_L	0xf47e
+#define	F367CAB_CTR_HIPOW_L	0xf47e00ff
+
+/* EQU_CTR_HIPOW_H */
+#define	R367CAB_EQU_CTR_HIPOW_H	0xf47f
+#define	F367CAB_CTR_HIPOW_H	0xf47f00ff
+
+/* EQU_I_EQU_LO */
+#define	R367CAB_EQU_I_EQU_LO	0xf480
+#define	F367CAB_EQU_I_EQU_L	0xf48000ff
+
+/* EQU_I_EQU_HI */
+#define	R367CAB_EQU_I_EQU_HI	0xf481
+#define	F367CAB_EQU_I_EQU_H	0xf4810003
+
+/* EQU_Q_EQU_LO */
+#define	R367CAB_EQU_Q_EQU_LO	0xf482
+#define	F367CAB_EQU_Q_EQU_L	0xf48200ff
+
+/* EQU_Q_EQU_HI */
+#define	R367CAB_EQU_Q_EQU_HI	0xf483
+#define	F367CAB_EQU_Q_EQU_H	0xf4830003
+
+/* EQU_MAPPER */
+#define	R367CAB_EQU_MAPPER	0xf484
+#define	F367CAB_QUAD_AUTO	0xf4840080
+#define	F367CAB_QUAD_INV	0xf4840040
+#define	F367CAB_QAM_MODE	0xf4840007
+
+/* EQU_SWEEP_RATE */
+#define	R367CAB_EQU_SWEEP_RATE	0xf485
+#define	F367CAB_SNR_PER	0xf48500c0
+#define	F367CAB_SWEEP_RATE	0xf485003f
+
+/* EQU_SNR_LO */
+#define	R367CAB_EQU_SNR_LO	0xf486
+#define	F367CAB_SNR_LO	0xf48600ff
+
+/* EQU_SNR_HI */
+#define	R367CAB_EQU_SNR_HI	0xf487
+#define	F367CAB_SNR_HI	0xf48700ff
+
+/* EQU_GAMMA_LO */
+#define	R367CAB_EQU_GAMMA_LO	0xf488
+#define	F367CAB_GAMMA_LO	0xf48800ff
+
+/* EQU_GAMMA_HI */
+#define	R367CAB_EQU_GAMMA_HI	0xf489
+#define	F367CAB_GAMMA_ME	0xf48900ff
+
+/* EQU_ERR_GAIN */
+#define	R367CAB_EQU_ERR_GAIN	0xf48a
+#define	F367CAB_EQA1MU	0xf48a0070
+#define	F367CAB_CRL2MU	0xf48a000e
+#define	F367CAB_GAMMA_HI	0xf48a0001
+
+/* EQU_RADIUS */
+#define	R367CAB_EQU_RADIUS	0xf48b
+#define	F367CAB_RADIUS	0xf48b00ff
+
+/* EQU_FFE_MAINTAP */
+#define	R367CAB_EQU_FFE_MAINTAP	0xf48c
+#define	F367CAB_FFE_MAINTAP_INIT	0xf48c00ff
+
+/* EQU_FFE_LEAKAGE */
+#define	R367CAB_EQU_FFE_LEAKAGE	0xf48e
+#define	F367CAB_LEAK_PER	0xf48e00f0
+#define	F367CAB_EQU_OUTSEL	0xf48e0002
+#define	F367CAB_PNT2dFE	0xf48e0001
+
+/* EQU_FFE_MAINTAP_POS */
+#define	R367CAB_EQU_FFE_MAINTAP_POS	0xf48f
+#define	F367CAB_FFE_LEAK_EN	0xf48f0080
+#define	F367CAB_DFE_LEAK_EN	0xf48f0040
+#define	F367CAB_FFE_MAINTAP_POS	0xf48f003f
+
+/* EQU_GAIN_WIDE */
+#define	R367CAB_EQU_GAIN_WIDE	0xf490
+#define	F367CAB_DFE_GAIN_WIDE	0xf49000f0
+#define	F367CAB_FFE_GAIN_WIDE	0xf490000f
+
+/* EQU_GAIN_NARROW */
+#define	R367CAB_EQU_GAIN_NARROW	0xf491
+#define	F367CAB_DFE_GAIN_NARROW	0xf49100f0
+#define	F367CAB_FFE_GAIN_NARROW	0xf491000f
+
+/* EQU_CTR_LPF_GAIN */
+#define	R367CAB_EQU_CTR_LPF_GAIN	0xf492
+#define	F367CAB_CTR_GTO	0xf4920080
+#define	F367CAB_CTR_GDIR	0xf4920070
+#define	F367CAB_SWEEP_EN	0xf4920008
+#define	F367CAB_CTR_GINT	0xf4920007
+
+/* EQU_CRL_LPF_GAIN */
+#define	R367CAB_EQU_CRL_LPF_GAIN	0xf493
+#define	F367CAB_CRL_GTO	0xf4930080
+#define	F367CAB_CRL_GDIR	0xf4930070
+#define	F367CAB_SWEEP_DIR	0xf4930008
+#define	F367CAB_CRL_GINT	0xf4930007
+
+/* EQU_GLOBAL_GAIN */
+#define	R367CAB_EQU_GLOBAL_GAIN	0xf494
+#define	F367CAB_CRL_GAIN	0xf49400f8
+#define	F367CAB_CTR_INC_GAIN	0xf4940004
+#define	F367CAB_CTR_FRAC	0xf4940003
+
+/* EQU_CRL_LD_SEN */
+#define	R367CAB_EQU_CRL_LD_SEN	0xf495
+#define	F367CAB_CTR_BADPOINT_EN	0xf4950080
+#define	F367CAB_CTR_GAIN	0xf4950070
+#define	F367CAB_LIMANEN	0xf4950008
+#define	F367CAB_CRL_LD_SEN	0xf4950007
+
+/* EQU_CRL_LD_VAL */
+#define	R367CAB_EQU_CRL_LD_VAL	0xf496
+#define	F367CAB_CRL_BISTH_LIMIT	0xf4960080
+#define	F367CAB_CARE_EN	0xf4960040
+#define	F367CAB_CRL_LD_PER	0xf4960030
+#define	F367CAB_CRL_LD_WST	0xf496000c
+#define	F367CAB_CRL_LD_TFS	0xf4960003
+
+/* EQU_CRL_TFR */
+#define	R367CAB_EQU_CRL_TFR	0xf497
+#define	F367CAB_CRL_LD_TFR	0xf49700ff
+
+/* EQU_CRL_BISTH_LO */
+#define	R367CAB_EQU_CRL_BISTH_LO	0xf498
+#define	F367CAB_CRL_BISTH_LO	0xf49800ff
+
+/* EQU_CRL_BISTH_HI */
+#define	R367CAB_EQU_CRL_BISTH_HI	0xf499
+#define	F367CAB_CRL_BISTH_HI	0xf49900ff
+
+/* EQU_SWEEP_RANGE_LO */
+#define	R367CAB_EQU_SWEEP_RANGE_LO	0xf49a
+#define	F367CAB_SWEEP_RANGE_LO	0xf49a00ff
+
+/* EQU_SWEEP_RANGE_HI */
+#define	R367CAB_EQU_SWEEP_RANGE_HI	0xf49b
+#define	F367CAB_SWEEP_RANGE_HI	0xf49b00ff
+
+/* EQU_CRL_LIMITER */
+#define	R367CAB_EQU_CRL_LIMITER	0xf49c
+#define	F367CAB_BISECTOR_EN	0xf49c0080
+#define	F367CAB_PHEST128_EN	0xf49c0040
+#define	F367CAB_CRL_LIM	0xf49c003f
+
+/* EQU_MODULUS_MAP */
+#define	R367CAB_EQU_MODULUS_MAP	0xf49d
+#define	F367CAB_PNT_DEPTH	0xf49d00e0
+#define	F367CAB_MODULUS_CMP	0xf49d001f
+
+/* EQU_PNT_GAIN */
+#define	R367CAB_EQU_PNT_GAIN	0xf49e
+#define	F367CAB_PNT_EN	0xf49e0080
+#define	F367CAB_MODULUSMAP_EN	0xf49e0040
+#define	F367CAB_PNT_GAIN	0xf49e003f
+
+/* FEC_AC_CTR_0 */
+#define	R367CAB_FEC_AC_CTR_0	0xf4a8
+#define	F367CAB_BE_BYPASS	0xf4a80020
+#define	F367CAB_REFRESH47	0xf4a80010
+#define	F367CAB_CT_NBST	0xf4a80008
+#define	F367CAB_TEI_ENA	0xf4a80004
+#define	F367CAB_DS_ENA	0xf4a80002
+#define	F367CAB_TSMF_EN	0xf4a80001
+
+/* FEC_AC_CTR_1 */
+#define	R367CAB_FEC_AC_CTR_1	0xf4a9
+#define	F367CAB_DEINT_DEPTH	0xf4a900ff
+
+/* FEC_AC_CTR_2 */
+#define	R367CAB_FEC_AC_CTR_2	0xf4aa
+#define	F367CAB_DEINT_M	0xf4aa00f8
+#define	F367CAB_DIS_UNLOCK	0xf4aa0004
+#define	F367CAB_DESCR_MODE	0xf4aa0003
+
+/* FEC_AC_CTR_3 */
+#define	R367CAB_FEC_AC_CTR_3	0xf4ab
+#define	F367CAB_DI_UNLOCK	0xf4ab0080
+#define	F367CAB_DI_FREEZE	0xf4ab0040
+#define	F367CAB_MISMATCH	0xf4ab0030
+#define	F367CAB_ACQ_MODE	0xf4ab000c
+#define	F367CAB_TRK_MODE	0xf4ab0003
+
+/* FEC_STATUS */
+#define	R367CAB_FEC_STATUS	0xf4ac
+#define	F367CAB_DEINT_SMCNTR	0xf4ac00e0
+#define	F367CAB_DEINT_SYNCSTATE	0xf4ac0018
+#define	F367CAB_DEINT_SYNLOST	0xf4ac0004
+#define	F367CAB_DESCR_SYNCSTATE	0xf4ac0002
+
+/* RS_COUNTER_0 */
+#define	R367CAB_RS_COUNTER_0	0xf4ae
+#define	F367CAB_BK_CT_L	0xf4ae00ff
+
+/* RS_COUNTER_1 */
+#define	R367CAB_RS_COUNTER_1	0xf4af
+#define	F367CAB_BK_CT_H	0xf4af00ff
+
+/* RS_COUNTER_2 */
+#define	R367CAB_RS_COUNTER_2	0xf4b0
+#define	F367CAB_CORR_CT_L	0xf4b000ff
+
+/* RS_COUNTER_3 */
+#define	R367CAB_RS_COUNTER_3	0xf4b1
+#define	F367CAB_CORR_CT_H	0xf4b100ff
+
+/* RS_COUNTER_4 */
+#define	R367CAB_RS_COUNTER_4	0xf4b2
+#define	F367CAB_UNCORR_CT_L	0xf4b200ff
+
+/* RS_COUNTER_5 */
+#define	R367CAB_RS_COUNTER_5	0xf4b3
+#define	F367CAB_UNCORR_CT_H	0xf4b300ff
+
+/* BERT_0 */
+#define	R367CAB_BERT_0	0xf4b4
+#define	F367CAB_RS_NOCORR	0xf4b40004
+#define	F367CAB_CT_HOLD	0xf4b40002
+#define	F367CAB_CT_CLEAR	0xf4b40001
+
+/* BERT_1 */
+#define	R367CAB_BERT_1	0xf4b5
+#define	F367CAB_BERT_ON	0xf4b50020
+#define	F367CAB_BERT_ERR_SRC	0xf4b50010
+#define	F367CAB_BERT_ERR_MODE	0xf4b50008
+#define	F367CAB_BERT_NBYTE	0xf4b50007
+
+/* BERT_2 */
+#define	R367CAB_BERT_2	0xf4b6
+#define	F367CAB_BERT_ERRCOUNT_L	0xf4b600ff
+
+/* BERT_3 */
+#define	R367CAB_BERT_3	0xf4b7
+#define	F367CAB_BERT_ERRCOUNT_H	0xf4b700ff
+
+/* OUTFORMAT_0 */
+#define	R367CAB_OUTFORMAT_0	0xf4b8
+#define	F367CAB_CLK_POLARITY	0xf4b80080
+#define	F367CAB_FEC_TYPE	0xf4b80040
+#define	F367CAB_SYNC_STRIP	0xf4b80008
+#define	F367CAB_TS_SWAP	0xf4b80004
+#define	F367CAB_OUTFORMAT	0xf4b80003
+
+/* OUTFORMAT_1 */
+#define	R367CAB_OUTFORMAT_1	0xf4b9
+#define	F367CAB_CI_DIVRANGE	0xf4b900ff
+
+/* SMOOTHER_2 */
+#define	R367CAB_SMOOTHER_2	0xf4be
+#define	F367CAB_FIFO_BYPASS	0xf4be0020
+
+/* TSMF_CTRL_0 */
+#define	R367CAB_TSMF_CTRL_0	0xf4c0
+#define	F367CAB_TS_NUMBER	0xf4c0001e
+#define	F367CAB_SEL_MODE	0xf4c00001
+
+/* TSMF_CTRL_1 */
+#define	R367CAB_TSMF_CTRL_1	0xf4c1
+#define	F367CAB_CHECK_ERROR_BIT	0xf4c10080
+#define	F367CAB_CHCK_F_SYNC	0xf4c10040
+#define	F367CAB_H_MODE	0xf4c10008
+#define	F367CAB_D_V_MODE	0xf4c10004
+#define	F367CAB_MODE	0xf4c10003
+
+/* TSMF_CTRL_3 */
+#define	R367CAB_TSMF_CTRL_3	0xf4c3
+#define	F367CAB_SYNC_IN_COUNT	0xf4c300f0
+#define	F367CAB_SYNC_OUT_COUNT	0xf4c3000f
+
+/* TS_ON_ID_0 */
+#define	R367CAB_TS_ON_ID_0	0xf4c4
+#define	F367CAB_TS_ID_L	0xf4c400ff
+
+/* TS_ON_ID_1 */
+#define	R367CAB_TS_ON_ID_1	0xf4c5
+#define	F367CAB_TS_ID_H	0xf4c500ff
+
+/* TS_ON_ID_2 */
+#define	R367CAB_TS_ON_ID_2	0xf4c6
+#define	F367CAB_ON_ID_L	0xf4c600ff
+
+/* TS_ON_ID_3 */
+#define	R367CAB_TS_ON_ID_3	0xf4c7
+#define	F367CAB_ON_ID_H	0xf4c700ff
+
+/* RE_STATUS_0 */
+#define	R367CAB_RE_STATUS_0	0xf4c8
+#define	F367CAB_RECEIVE_STATUS_L	0xf4c800ff
+
+/* RE_STATUS_1 */
+#define	R367CAB_RE_STATUS_1	0xf4c9
+#define	F367CAB_RECEIVE_STATUS_LH	0xf4c900ff
+
+/* RE_STATUS_2 */
+#define	R367CAB_RE_STATUS_2	0xf4ca
+#define	F367CAB_RECEIVE_STATUS_HL	0xf4ca00ff
+
+/* RE_STATUS_3 */
+#define	R367CAB_RE_STATUS_3	0xf4cb
+#define	F367CAB_RECEIVE_STATUS_HH	0xf4cb003f
+
+/* TS_STATUS_0 */
+#define	R367CAB_TS_STATUS_0	0xf4cc
+#define	F367CAB_TS_STATUS_L	0xf4cc00ff
+
+/* TS_STATUS_1 */
+#define	R367CAB_TS_STATUS_1	0xf4cd
+#define	F367CAB_TS_STATUS_H	0xf4cd007f
+
+/* TS_STATUS_2 */
+#define	R367CAB_TS_STATUS_2	0xf4ce
+#define	F367CAB_ERROR	0xf4ce0080
+#define	F367CAB_EMERGENCY	0xf4ce0040
+#define	F367CAB_CRE_TS	0xf4ce0030
+#define	F367CAB_VER	0xf4ce000e
+#define	F367CAB_M_LOCK	0xf4ce0001
+
+/* TS_STATUS_3 */
+#define	R367CAB_TS_STATUS_3	0xf4cf
+#define	F367CAB_UPDATE_READY	0xf4cf0080
+#define	F367CAB_END_FRAME_HEADER	0xf4cf0040
+#define	F367CAB_CONTCNT	0xf4cf0020
+#define	F367CAB_TS_IDENTIFIER_SEL	0xf4cf000f
+
+/* T_O_ID_0 */
+#define	R367CAB_T_O_ID_0	0xf4d0
+#define	F367CAB_ON_ID_I_L	0xf4d000ff
+
+/* T_O_ID_1 */
+#define	R367CAB_T_O_ID_1	0xf4d1
+#define	F367CAB_ON_ID_I_H	0xf4d100ff
+
+/* T_O_ID_2 */
+#define	R367CAB_T_O_ID_2	0xf4d2
+#define	F367CAB_TS_ID_I_L	0xf4d200ff
+
+/* T_O_ID_3 */
+#define	R367CAB_T_O_ID_3	0xf4d3
+#define	F367CAB_TS_ID_I_H	0xf4d300ff
+
+#define STV0367CAB_NBREGS	187
+
+#endif
-- 
1.7.1

