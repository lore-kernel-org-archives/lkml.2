Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1KUEHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 23:07:40 -0500
Received: from mail-iy0-f194.google.com ([209.85.210.194]:59839 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1KUEHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 23:07:24 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/3] sound/soc/lapis: add platform driver
Date: Mon, 21 Nov 2011 13:08:52 +0900
Message-Id: <1321848532-8784-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform driver for LAPIS Semiconductor ML7213 IOH

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 sound/soc/lapis/Kconfig          |    6 +
 sound/soc/lapis/Makefile         |    2 +
 sound/soc/lapis/ioh_i2s.h        |  118 ++
 sound/soc/lapis/ioh_i2s_config.h | 1978 ++++++++++++++++++++++++++++++
 sound/soc/lapis/ml7213ioh-plat.c | 2488 ++++++++++++++++++++++++++++++++++++++
 sound/soc/lapis/ml7213ioh-plat.h |  213 ++++
 6 files changed, 4805 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/lapis/ioh_i2s.h
 create mode 100644 sound/soc/lapis/ioh_i2s_config.h
 create mode 100644 sound/soc/lapis/ml7213ioh-plat.c
 create mode 100644 sound/soc/lapis/ml7213ioh-plat.h

diff --git a/sound/soc/lapis/Kconfig b/sound/soc/lapis/Kconfig
index 1bd5200..fc7774f 100644
--- a/sound/soc/lapis/Kconfig
+++ b/sound/soc/lapis/Kconfig
@@ -1,3 +1,9 @@
+config SND_SOC_ML7213_PLATFORM
+	tristate "ML7213 IOH ASoC platform driver"
+	depends on HAS_TXX9_ACLC && TXX9_DMAC
+	help
+	  This option enables support for the AC Link Controllers in ML7213 IOH SoC.
+
 config SND_SOC_ML7213_MACHINE
 	tristate "ML7213 IOH ASoC machine driver"
 	depends on SND_SOC_TXX9ACLC
diff --git a/sound/soc/lapis/Makefile b/sound/soc/lapis/Makefile
index 468d922..142ba96 100644
--- a/sound/soc/lapis/Makefile
+++ b/sound/soc/lapis/Makefile
@@ -1,4 +1,6 @@
 # Platform
 snd-soc-ml7213-machine-objs := ml7213ioh-machine.o
+snd-soc-ml7213-plat-objs := ml7213ioh-plat.o
 
+obj-$(CONFIG_SND_SOC_ML7213_PLATFORM) += snd-soc-ml7213-machine.o
 obj-$(CONFIG_SND_SOC_ML7213_MACHINE) += snd-soc-ml7213-plat.o
diff --git a/sound/soc/lapis/ioh_i2s.h b/sound/soc/lapis/ioh_i2s.h
new file mode 100644
index 0000000..7474d6f
--- /dev/null
+++ b/sound/soc/lapis/ioh_i2s.h
@@ -0,0 +1,118 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#ifndef ML7213_IOH_I2S
+#define ML7213_IOH_I2S
+
+#define I2S_AEMPTY_THRESH	64	/* Almost  Empty Threshold */
+#define I2S_AFULL_THRESH	64	/* Almost  Full Threshold */
+
+#define MAX_I2S_RX_CH	MAX_I2S_CH
+#define MAX_I2S_TX_CH	MAX_I2S_CH
+
+#define	INTER_BUFF_SIZE		(I2S_AEMPTY_THRESH*4 \
+				 *I2S_DMA_SG_NUM \
+				 *I2S_DMA_SG_MAX)
+#define	I2S_DMA_SG_NUM		(128)
+#define	I2S_DMA_SG_MAX		(64)
+
+struct ioh_i2s_data;
+
+
+enum ioh_direction {
+	IOH_PLAYBACK = 0,
+	IOH_CAPTURE,
+};
+
+enum ioh_i2s_fifo_type {
+	IOH_FIFO_32  = 4,
+	IOH_FIFO_16 = 2,
+	IOH_FIFO_8 = 1,
+};
+
+enum ioh_i2s_status {
+	IOH_EOK = 0,
+	IOH_EDONE = 1,
+	IOH_EUNDERRUN = 2,
+	IOH_EOVERRUN = 3,
+	IOH_EFRAMESYNC = 4,
+};
+
+struct ioh_i2s_config_common_reg {
+	u32 i2sclkcnt;	/*clock control register(ch0~5) */
+	u32 i2sistatus;	/*interrupt status */
+	u32 i2sidisp;		/*active interrupts */
+	u32 i2simask;		/*interrupt mask */
+	u32 i2simaskclr;	/*interrupt mask clear */
+};
+
+struct ioh_i2s_config_tx_reg {
+	u32 i2sdrtx;	/*data register */
+	u32 i2scnttx; /*control register */
+	u32 i2sfifoctx;	/*FIFO control register */
+	u32 i2saftx;	/*almost full threshold setting */
+	u32 i2saetx;	/*almost empty threshold setting */
+	u32 i2smsktx;	/*interrupt mask settings */
+	u32 i2sisttx;	/*for acknowledging interrupts */
+	u32 i2smontx;	/*monitor register */
+};
+
+struct ioh_i2s_config_rx_reg {
+	u32 i2sdrrx;	/* data register */
+	u32 i2scntrx;	/* control register */
+	u32 i2sfifocrx;/* FIFO control register */
+	u32 i2safrx;	/* almost full threshold setting */
+	u32 i2saerx;	/* almost empty threshold setting */
+	u32 i2smskrx;	/* interrupt mask settings */
+	u32 i2sistrx;	/* for acknowledging interrupts */
+	u32 i2smonrx;	/* monitor register */
+};
+
+struct ioh_i2s_config_reg {
+	/* The common register settings */
+	struct ioh_i2s_config_common_reg cmn;
+
+	/* TX channel settings */
+	struct ioh_i2s_config_tx_reg tx;
+
+	/* RX channel settings */
+	struct ioh_i2s_config_rx_reg rx;
+};
+
+/* For power management save/retore use */
+struct ioh_i2s_pm_common_reg {
+	u32 i2sclkcnt[6];
+	u32 i2simask;
+};
+
+struct ioh_i2s_pm_ch_reg {
+	u32 i2sdrtx;	/* Tx: data register */
+	u32 i2scnttx; /* Tx: control register */
+	u32 i2sfifoctx;	/* Tx: FIFO control register */
+	u32 i2saftx;	/* Tx: almost full threshold setting */
+	u32 i2saetx;	/* Tx: almost empty threshold setting */
+	u32 i2smsktx;	/* Tx: interrupt mask settings */
+	u32 i2sisttx;	/* Tx: for acknowledging interrupts */
+	u32 i2scntrx;	/* Rx: control register */
+	u32 i2sfifocrx; /* Rx: FIFO control register */
+	u32 i2safrx;	/* Rx: almost full threshold setting */
+	u32 i2saerx;	/* Rx: almost empty threshold setting */
+	u32 i2smskrx;	/* Rx: interrupt mask settings */
+	u32 i2sistrx;	/* Rx: for acknowledging interrupts */
+};
+
+#endif
diff --git a/sound/soc/lapis/ioh_i2s_config.h b/sound/soc/lapis/ioh_i2s_config.h
new file mode 100644
index 0000000..a71d7dd
--- /dev/null
+++ b/sound/soc/lapis/ioh_i2s_config.h
@@ -0,0 +1,1978 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#ifndef ML7213_IOH_I2S_CONFIG
+#define ML7213_IOH_I2S_CONFIG
+
+#include "ioh_i2s.h"
+
+#define	IOH_I2S_USE_PARAM	(1)
+#define	I2S_SUPPORT_FS_NUM	(7)
+
+#define	PERIOD_POS_MAX		(I2S_DMA_SG_NUM)
+#define	PERIOD_LEN_TX		(I2S_AEMPTY_THRESH * PERIOD_POS_MAX)
+#define	PERIOD_LEN_RX		(I2S_AFULL_THRESH * PERIOD_POS_MAX)
+
+#define	SUPPORT_FORMAT		(SNDRV_PCM_FMTBIT_U8 | \
+				 SNDRV_PCM_FMTBIT_S16_LE | \
+				 SNDRV_PCM_FMTBIT_S32_LE)
+#define	MAX_PERIOD_SIZE_TX	(PERIOD_LEN_TX*4)
+#define	MAX_PERIOD_SIZE_RX	(PERIOD_LEN_RX*4)
+
+#if (PERIOD_LEN_TX < (I2S_AEMPTY_THRESH*I2S_DMA_SG_NUM))
+	#error IOH_I2S_CONFIG Error : PERIOD_LEN_TX is enlarged more.
+#endif
+
+#if (PERIOD_LEN_RX < (I2S_AFULL_THRESH*I2S_DMA_SG_NUM))
+	#error IOH_I2S_CONFIG Error : PERIOD_LEN_RX is enlarged more.
+#endif
+
+
+/* ######################################################################## */
+/* ###		Parameter setup possible value				### */
+/* ######################################################################## */
+/* ioh_mssel_t */
+#define	ioh_mssel_slave		(0)
+#define	ioh_mssel_master	(1)
+
+enum ioh_bclkpol_t {
+	ioh_bclkpol_falling = 0,
+	ioh_bclkpol_rising,
+};
+
+enum ioh_masterclksel_t {
+	ioh_masterclksel_mclk = 0,
+	ioh_masterclksel_mlbclk,
+};
+
+enum ioh_lrckfmt_t {
+	ioh_lrclkfmt_i2s = 1,
+	ioh_lrclkfmt_longframe,
+	ioh_lrclkfmt_shortframe,
+};
+
+enum ioh_mclkfs_t {
+	ioh_mclkfs_64fs = 0,
+	ioh_mclkfs_128fs,
+	ioh_mclkfs_192fs,
+	ioh_mclkfs_256fs,
+	ioh_mclkfs_384fs,
+	ioh_mclkfs_512fs,
+	ioh_mclkfs_768fs,
+	ioh_mclkfs_1024fs,
+};
+
+/* ioh_dabit_t */
+#define	ioh_dabit_8bit		(0)
+#define	ioh_dabit_16bit		(2)
+#define	ioh_dabit_24bit		(5)
+
+/* ioh_bclkfs_t */
+#define	ioh_bclkfs_8fs		(0)
+#define	ioh_bclkfs_16fs		(1)
+#define	ioh_bclkfs_32fs		(2)
+#define	ioh_bclkfs_64fs		(3)
+
+/* ioh_tel_t */
+#define	ioh_tel_i2s_fmt		(0)
+#define	ioh_tel_tel_fmt		(1)
+
+enum ioh_dlyoff_t {
+	ioh_dlyoff_dly_on = 0,		/* date delat on */
+	ioh_dlyoff_dly_off,		/* date delat off */
+};
+
+/* ioh_lsb_t */
+#define	ioh_lsb_msb_first	(0)
+#define	ioh_lsb_lsb_first	(1)
+
+enum ioh_lrpol_t {
+	ioh_lrpol_no_invert = 0,	/* Low of LRCLK is L data.
+					   High of LRCLK is R data. */
+	ioh_lrpol_invert,		/* Low of LRCLK is R data.
+					   High of LRCLK is L data. */
+};
+
+enum ioh_aft_t {
+	ioh_aft_front = 0,
+	ioh_aft_back,
+};
+
+
+struct i2s_config_tab_t {
+	unsigned int i2sclkcnt;
+	unsigned int i2scnttx;
+	unsigned int i2scntrx;
+	unsigned int i2s_mclk;
+};
+
+struct i2s_config_rate_sub_t {
+	unsigned int rate;
+	unsigned int mclkfs;
+};
+
+struct i2s_config_rate_t {
+	struct i2s_config_rate_sub_t i2s_config_rate_sub[I2S_SUPPORT_FS_NUM];
+};
+
+
+/* ######################################################################## */
+/* ###		Parameter Config PreProcessor				### */
+/* ######################################################################## */
+
+/* I2S Config Value */
+#define USE_CHANNELS_MIN	1
+#define USE_CHANNELS_MAX	2
+
+#define	MAX_I2S_CH		6		/*I2S0 ~ I2S5*/
+
+
+/* =================== I2S CH0 config =================== */
+#define	I2S_CH0_MCLK		(12288000) /* Master Clock Frequency[Hz] */
+  #if IOH_I2S_USE_PARAM
+	#define	I2S_CH0_FS_16000	16000
+	#define	I2S_CH0_FS_32000	32000
+	#define	I2S_CH0_FS_48000	48000
+  #else
+	#define	I2S_CH0_FS_8000		8000
+	#define	I2S_CH0_FS_11025	11025
+	#define	I2S_CH0_FS_22050	22050
+	#define	I2S_CH0_FS_44100	44100
+  #endif
+
+/* select master or slave. The value is ioh_mssel_t */
+#define	I2S_CH0_MSSEL			(ioh_mssel_master)
+/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
+#define	I2S_CH0_MASTERCLKSEL		(ioh_masterclksel_mclk)
+
+	/* I2S CH0 stereo config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH0_BCLKPOL_STEREO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH0_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH0_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH0_TX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
+#define	I2S_CH0_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of TX side. The value is ioh_aft_t */
+#define	I2S_CH0_TX_AFT_STEREO		(ioh_aft_front)
+
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH0_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH0_RX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
+#define	I2S_CH0_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of RX side. The value is ioh_aft_t */
+#define	I2S_CH0_RX_AFT_STEREO		(ioh_aft_front)
+
+	/* I2S CH0 monaural config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH0_BCLKPOL_MONO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH0_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH0_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH0_TX_LSB_MONO		(ioh_lsb_msb_first)
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH0_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH0_RX_LSB_MONO		(ioh_lsb_msb_first)
+
+
+/* =================== I2S CH1 config =================== */
+#define	I2S_CH1_MCLK		(12288000) /* Master Clock Frequency[Hz] */
+  #if IOH_I2S_USE_PARAM
+	#define	I2S_CH1_FS_16000	16000
+	#define	I2S_CH1_FS_32000	32000
+	#define	I2S_CH1_FS_48000	48000
+  #else
+	#define	I2S_CH1_FS_8000		8000
+	#define	I2S_CH1_FS_11025	11025
+	#define	I2S_CH1_FS_22050	22050
+	#define	I2S_CH1_FS_44100	44100
+  #endif
+
+/* select master or slave. The value is ioh_mssel_t */
+#define	I2S_CH1_MSSEL			(ioh_mssel_master)
+/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
+#define	I2S_CH1_MASTERCLKSEL		(ioh_masterclksel_mclk)
+
+	/* I2S CH1 stereo config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH1_BCLKPOL_STEREO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH1_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH1_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH1_TX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
+#define	I2S_CH1_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of TX side. The value is ioh_aft_t */
+#define	I2S_CH1_TX_AFT_STEREO		(ioh_aft_front)
+
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH1_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH1_RX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
+#define	I2S_CH1_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of RX side. The value is ioh_aft_t */
+#define	I2S_CH1_RX_AFT_STEREO		(ioh_aft_front)
+
+	/* I2S CH1 monaural config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH1_BCLKPOL_MONO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH1_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH1_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH1_TX_LSB_MONO		(ioh_lsb_msb_first)
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH1_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH1_RX_LSB_MONO		(ioh_lsb_msb_first)
+
+
+/* =================== I2S CH2 config =================== */
+#define	I2S_CH2_MCLK		(12288000) /* Master Clock Frequency[Hz] */
+  #if IOH_I2S_USE_PARAM
+	#define	I2S_CH2_FS_16000	16000
+	#define	I2S_CH2_FS_32000	32000
+	#define	I2S_CH2_FS_48000	48000
+  #else
+	#define	I2S_CH2_FS_8000		8000
+	#define	I2S_CH2_FS_11025	11025
+	#define	I2S_CH2_FS_22050	22050
+	#define	I2S_CH2_FS_44100	44100
+  #endif
+
+/* select master or slave. The value is ioh_mssel_t */
+#define	I2S_CH2_MSSEL			(ioh_mssel_master)
+/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
+#define	I2S_CH2_MASTERCLKSEL		(ioh_masterclksel_mclk)
+
+	/* I2S CH2 stereo config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH2_BCLKPOL_STEREO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH2_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH2_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH2_TX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
+#define	I2S_CH2_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of TX side. The value is ioh_aft_t */
+#define	I2S_CH2_TX_AFT_STEREO		(ioh_aft_front)
+
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH2_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH2_RX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
+#define	I2S_CH2_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of RX side. The value is ioh_aft_t */
+#define	I2S_CH2_RX_AFT_STEREO		(ioh_aft_front)
+
+	/* I2S CH2 monaural config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH2_BCLKPOL_MONO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH2_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH2_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH2_TX_LSB_MONO		(ioh_lsb_msb_first)
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH2_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH2_RX_LSB_MONO		(ioh_lsb_msb_first)
+
+
+/* =================== I2S CH3 config =================== */
+#define	I2S_CH3_MCLK		(12288000) /* Master Clock Frequency[Hz] */
+  #if IOH_I2S_USE_PARAM
+	#define	I2S_CH3_FS_16000	16000
+	#define	I2S_CH3_FS_32000	32000
+	#define	I2S_CH3_FS_48000	48000
+  #else
+	#define	I2S_CH3_FS_8000		8000
+	#define	I2S_CH3_FS_11025	11025
+	#define	I2S_CH3_FS_22050	22050
+	#define	I2S_CH3_FS_44100	44100
+  #endif
+
+/* select master or slave. The value is ioh_mssel_t */
+#define	I2S_CH3_MSSEL			(ioh_mssel_master)
+/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
+#define	I2S_CH3_MASTERCLKSEL		(ioh_masterclksel_mclk)
+
+	/* I2S CH3 stereo config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH3_BCLKPOL_STEREO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH3_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH3_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH3_TX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
+#define	I2S_CH3_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of TX side. The value is ioh_aft_t */
+#define	I2S_CH3_TX_AFT_STEREO		(ioh_aft_front)
+
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH3_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH3_RX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
+#define	I2S_CH3_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of RX side. The value is ioh_aft_t */
+#define	I2S_CH3_RX_AFT_STEREO		(ioh_aft_front)
+
+	/* I2S CH3 monaural config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH3_BCLKPOL_MONO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH3_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH3_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH3_TX_LSB_MONO		(ioh_lsb_msb_first)
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH3_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH3_RX_LSB_MONO		(ioh_lsb_msb_first)
+
+
+/* =================== I2S CH4 config =================== */
+#define	I2S_CH4_MCLK		(12288000) /* Master Clock Frequency[Hz] */
+  #if IOH_I2S_USE_PARAM
+	#define	I2S_CH4_FS_16000	16000
+	#define	I2S_CH4_FS_32000	32000
+	#define	I2S_CH4_FS_48000	48000
+  #else
+	#define	I2S_CH4_FS_8000		8000
+	#define	I2S_CH4_FS_11025	11025
+	#define	I2S_CH4_FS_22050	22050
+	#define	I2S_CH4_FS_44100	44100
+  #endif
+
+/* select master or slave. The value is ioh_mssel_t */
+#define	I2S_CH4_MSSEL			(ioh_mssel_master)
+/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
+#define	I2S_CH4_MASTERCLKSEL		(ioh_masterclksel_mclk)
+
+	/* I2S CH4 stereo config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH4_BCLKPOL_STEREO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH4_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH4_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH4_TX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
+#define	I2S_CH4_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of TX side. The value is ioh_aft_t */
+#define	I2S_CH4_TX_AFT_STEREO		(ioh_aft_front)
+
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH4_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH4_RX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
+#define	I2S_CH4_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of RX side. The value is ioh_aft_t */
+#define	I2S_CH4_RX_AFT_STEREO		(ioh_aft_front)
+
+	/* I2S CH4 monaural config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH4_BCLKPOL_MONO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH4_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH4_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH4_TX_LSB_MONO		(ioh_lsb_msb_first)
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH4_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH4_RX_LSB_MONO		(ioh_lsb_msb_first)
+
+
+/* =================== I2S CH5 config =================== */
+#define	I2S_CH5_MCLK		(12288000) /* Master Clock Frequency[Hz] */
+  #if IOH_I2S_USE_PARAM
+	#define	I2S_CH5_FS_16000	16000
+	#define	I2S_CH5_FS_32000	32000
+	#define	I2S_CH5_FS_48000	48000
+  #else
+	#define	I2S_CH5_FS_8000		8000
+	#define	I2S_CH5_FS_11025	11025
+	#define	I2S_CH5_FS_22050	22050
+	#define	I2S_CH5_FS_44100	44100
+  #endif
+
+/* select master or slave. The value is ioh_mssel_t */
+#define	I2S_CH5_MSSEL			(ioh_mssel_master)
+/* select MCLK or MLBCLK into Master Clock. The value is enum ioh_masterclk_t */
+#define	I2S_CH5_MASTERCLKSEL		(ioh_masterclksel_mclk)
+
+	/* I2S CH5 stereo config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH5_BCLKPOL_STEREO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH5_LRCKFMT_STEREO		(ioh_lrclkfmt_i2s)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH5_TX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH5_TX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of TX side. The value is ioh_lrpol_t */
+#define	I2S_CH5_TX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of TX side. The value is ioh_aft_t */
+#define	I2S_CH5_TX_AFT_STEREO		(ioh_aft_front)
+
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH5_RX_DLYOFF_STEREO	(ioh_dlyoff_dly_on)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH5_RX_LSB_STEREO		(ioh_lsb_msb_first)
+/* select LRCLK polarity of RX side. The value is ioh_lrpol_t */
+#define	I2S_CH5_RX_LRPOL_STEREO		(ioh_lrpol_no_invert)
+/* select transmit data front or back of RX side. The value is ioh_aft_t */
+#define	I2S_CH5_RX_AFT_STEREO		(ioh_aft_front)
+
+	/* I2S CH5 monaural config */
+/* select BCLK polarity. The value is enum ioh_bclkpol_t */
+#define	I2S_CH5_BCLKPOL_MONO		(ioh_bclkpol_falling)
+/* select DAI format. The value is enum ioh_lrckfmt_t */
+#define	I2S_CH5_LRCKFMT_MONO		(ioh_lrclkfmt_longframe)
+
+/* select TX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH5_TX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select TX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH5_TX_LSB_MONO		(ioh_lsb_msb_first)
+/* select RX data delay on or off. The value is enum ioh_dlyoff_t */
+#define	I2S_CH5_RX_DLYOFF_MONO		(ioh_dlyoff_dly_off)
+/* select RX data format LSB or MSB first. The value is ioh_lsb_t */
+#define	I2S_CH5_RX_LSB_MONO		(ioh_lsb_msb_first)
+
+
+/* ######################################################################## */
+/* ###		Parameter Check PreProcessor				### */
+/* ######################################################################## */
+
+/* ===== CH0 Parameter Error Check ==== */
+#define	USE_RATE_MAX_CH0	(0)
+#ifdef	I2S_CH0_FS_8000
+	#define	USE_RATE_CH0_8000	SNDRV_PCM_RATE_8000
+	#define	USE_RATE_MIN_CH0	(8000)
+	#if (USE_RATE_MAX_CH0 < 8000)
+		#undef	USE_RATE_MAX_CH0
+		#define	USE_RATE_MAX_CH0	(8000)
+	#endif
+#else
+	#define	USE_RATE_CH0_8000	0
+#endif
+
+#ifdef	I2S_CH0_FS_11025
+	#define	USE_RATE_CH0_11025	SNDRV_PCM_RATE_11025
+	#ifndef	USE_RATE_MIN_CH0
+		#define	USE_RATE_MIN_CH0	(11025)
+	#endif
+	#if (USE_RATE_MAX_CH0 < 11025)
+		#undef	USE_RATE_MAX_CH0
+		#define	USE_RATE_MAX_CH0	(11025)
+	#endif
+#else
+	#define	USE_RATE_CH0_11025	0
+#endif
+
+#ifdef	I2S_CH0_FS_16000
+	#define	USE_RATE_CH0_16000	SNDRV_PCM_RATE_16000
+	#ifndef	USE_RATE_MIN_CH0
+		#define	USE_RATE_MIN_CH0	(16000)
+	#endif
+	#if (USE_RATE_MAX_CH0 < 16000)
+		#undef	USE_RATE_MAX_CH0
+		#define	USE_RATE_MAX_CH0	(16000)
+	#endif
+#else
+	#define	USE_RATE_CH0_16000	0
+#endif
+
+#ifdef	I2S_CH0_FS_22050
+	#define	USE_RATE_CH0_22050	SNDRV_PCM_RATE_22050
+	#ifndef	USE_RATE_MIN_CH0
+		#define	USE_RATE_MIN_CH0	(22050)
+	#endif
+	#if (USE_RATE_MAX_CH0 < 22050)
+		#undef	USE_RATE_MAX_CH0
+		#define	USE_RATE_MAX_CH0	(22050)
+	#endif
+#else
+	#define	USE_RATE_CH0_22050	0
+#endif
+
+#ifdef	I2S_CH0_FS_32000
+	#define	USE_RATE_CH0_32000	SNDRV_PCM_RATE_32000
+	#ifndef	USE_RATE_MIN_CH0
+		#define	USE_RATE_MIN_CH0	(32000)
+	#endif
+	#if (USE_RATE_MAX_CH0 < 32000)
+		#undef	USE_RATE_MAX_CH0
+		#define	USE_RATE_MAX_CH0	(32000)
+	#endif
+#else
+	#define	USE_RATE_CH0_32000	0
+#endif
+
+#ifdef	I2S_CH0_FS_44100
+	#define	USE_RATE_CH0_44100	SNDRV_PCM_RATE_44100
+	#ifndef	USE_RATE_MIN_CH0
+		#define	USE_RATE_MIN_CH0	(44100)
+	#endif
+	#if (USE_RATE_MAX_CH0 < 44100)
+		#undef	USE_RATE_MAX_CH0
+		#define	USE_RATE_MAX_CH0	(44100)
+	#endif
+#else
+	#define	USE_RATE_CH0_44100	0
+#endif
+
+#ifdef	I2S_CH0_FS_48000
+	#define	USE_RATE_CH0_48000	SNDRV_PCM_RATE_48000
+	#ifndef	USE_RATE_MIN_CH0
+		#define	USE_RATE_MIN_CH0	(48000)
+	#endif
+	#if (USE_RATE_MAX_CH0 < 48000)
+		#undef	USE_RATE_MAX_CH0
+		#define	USE_RATE_MAX_CH0	(48000)
+	#endif
+#else
+	#define	USE_RATE_CH0_48000	0
+#endif
+
+#define	USE_RATE_CH0	(USE_RATE_CH0_8000|USE_RATE_CH0_11025 |		\
+			 USE_RATE_CH0_16000|USE_RATE_CH0_22050 |	\
+			 USE_RATE_CH0_32000|USE_RATE_CH0_44100 |	\
+			 USE_RATE_CH0_48000)
+
+
+#define I2S_CH0_64FS		(I2S_CH0_MCLK/64)
+#define I2S_CH0_128FS		(I2S_CH0_MCLK/128)
+#define I2S_CH0_192FS		(I2S_CH0_MCLK/192)
+#define I2S_CH0_256FS		(I2S_CH0_MCLK/256)
+#define I2S_CH0_384FS		(I2S_CH0_MCLK/384)
+#define I2S_CH0_512FS		(I2S_CH0_MCLK/512)
+#define I2S_CH0_768FS		(I2S_CH0_MCLK/768)
+#define I2S_CH0_1024FS		(I2S_CH0_MCLK/1024)
+
+
+#if (I2S_CH0_MSSEL == ioh_mssel_master)
+#ifdef	I2S_CH0_FS_8000
+	#if (I2S_CH0_64FS != I2S_CH0_FS_8000) && \
+		(I2S_CH0_128FS != I2S_CH0_FS_8000) && \
+		(I2S_CH0_192FS != I2S_CH0_FS_8000) && \
+		(I2S_CH0_256FS != I2S_CH0_FS_8000) && \
+		(I2S_CH0_384FS != I2S_CH0_FS_8000) && \
+		(I2S_CH0_512FS != I2S_CH0_FS_8000) && \
+		(I2S_CH0_768FS != I2S_CH0_FS_8000) && \
+		(I2S_CH0_1024FS != I2S_CH0_FS_8000)
+		#error IOH_I2S_CH0_CONFIG Error : \
+			Sampling frequency 8000Hz can not generate.
+	#endif
+#endif
+
+#ifdef	I2S_CH0_FS_11025
+	#if (I2S_CH0_64FS != I2S_CH0_FS_11025) && \
+		(I2S_CH0_128FS != I2S_CH0_FS_11025) && \
+		(I2S_CH0_192FS != I2S_CH0_FS_11025) && \
+		(I2S_CH0_256FS != I2S_CH0_FS_11025) && \
+		(I2S_CH0_384FS != I2S_CH0_FS_11025) && \
+		(I2S_CH0_512FS != I2S_CH0_FS_11025) && \
+		(I2S_CH0_768FS != I2S_CH0_FS_11025) && \
+		(I2S_CH0_1024FS != I2S_CH0_FS_11025)
+		#error IOH_I2S_CH0_CONFIG Error : \
+			Sampling frequency 11025Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH0_FS_16000
+	#if (I2S_CH0_64FS != I2S_CH0_FS_16000) && \
+		(I2S_CH0_128FS != I2S_CH0_FS_16000) && \
+		(I2S_CH0_192FS != I2S_CH0_FS_16000) && \
+		(I2S_CH0_256FS != I2S_CH0_FS_16000) && \
+		(I2S_CH0_384FS != I2S_CH0_FS_16000) && \
+		(I2S_CH0_512FS != I2S_CH0_FS_16000) && \
+		(I2S_CH0_768FS != I2S_CH0_FS_16000) && \
+		(I2S_CH0_1024FS != I2S_CH0_FS_16000)
+		#error IOH_I2S_CH0_CONFIG Error : \
+			Sampling frequency 16000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH0_FS_22050
+	#if (I2S_CH0_64FS != I2S_CH0_FS_22050) && \
+		(I2S_CH0_128FS != I2S_CH0_FS_22050) && \
+		(I2S_CH0_192FS != I2S_CH0_FS_22050) && \
+		(I2S_CH0_256FS != I2S_CH0_FS_22050) && \
+		(I2S_CH0_384FS != I2S_CH0_FS_22050) && \
+		(I2S_CH0_512FS != I2S_CH0_FS_22050) && \
+		(I2S_CH0_768FS != I2S_CH0_FS_22050) && \
+		(I2S_CH0_1024FS != I2S_CH0_FS_22050)
+		#error IOH_I2S_CH0_CONFIG Error : \
+			Sampling frequency 22050Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH0_FS_32000
+	#if (I2S_CH0_64FS != I2S_CH0_FS_32000) && \
+		(I2S_CH0_128FS != I2S_CH0_FS_32000) && \
+		(I2S_CH0_192FS != I2S_CH0_FS_32000) && \
+		(I2S_CH0_256FS != I2S_CH0_FS_32000) && \
+		(I2S_CH0_384FS != I2S_CH0_FS_32000) && \
+		(I2S_CH0_512FS != I2S_CH0_FS_32000) && \
+		(I2S_CH0_768FS != I2S_CH0_FS_32000) && \
+		(I2S_CH0_1024FS != I2S_CH0_FS_32000)
+		#error IOH_I2S_CH0_CONFIG Error : \
+			Sampling frequency 32000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH0_FS_44100
+	#if (I2S_CH0_64FS != I2S_CH0_FS_44100) && \
+		(I2S_CH0_128FS != I2S_CH0_FS_44100) && \
+		(I2S_CH0_192FS != I2S_CH0_FS_44100) && \
+		(I2S_CH0_256FS != I2S_CH0_FS_44100) && \
+		(I2S_CH0_384FS != I2S_CH0_FS_44100) && \
+		(I2S_CH0_512FS != I2S_CH0_FS_44100) && \
+		(I2S_CH0_768FS != I2S_CH0_FS_44100) && \
+		(I2S_CH0_1024FS != I2S_CH0_FS_44100)
+		#error IOH_I2S_CH0_CONFIG Error : \
+			Sampling frequency 44100Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH0_FS_48000
+	#if (I2S_CH0_64FS != I2S_CH0_FS_48000) && \
+		(I2S_CH0_128FS != I2S_CH0_FS_48000) && \
+		(I2S_CH0_192FS != I2S_CH0_FS_48000) && \
+		(I2S_CH0_256FS != I2S_CH0_FS_48000) && \
+		(I2S_CH0_384FS != I2S_CH0_FS_48000) && \
+		(I2S_CH0_512FS != I2S_CH0_FS_48000) && \
+		(I2S_CH0_768FS != I2S_CH0_FS_48000) && \
+		(I2S_CH0_1024FS != I2S_CH0_FS_48000)
+		#error IOH_I2S_CH0_CONFIG Error : \
+			Sampling frequency 48000Hz can not generate.
+	#endif
+#endif
+#endif	/* end of [#if (I2S_CH0_MSSEL == ioh_mssel_master)] */
+
+
+/* ===== CH1 Parameter Error Check ==== */
+#define	USE_RATE_MAX_CH1	(0)
+#ifdef	I2S_CH1_FS_8000
+	#define	USE_RATE_CH1_8000	SNDRV_PCM_RATE_8000
+	#define	USE_RATE_MIN_CH1	(8000)
+	#if (USE_RATE_MAX_CH1 < 8000)
+		#undef	USE_RATE_MAX_CH1
+		#define	USE_RATE_MAX_CH1	(8000)
+	#endif
+#else
+	#define	USE_RATE_CH1_8000	0
+#endif
+
+#ifdef	I2S_CH1_FS_11025
+	#define	USE_RATE_CH1_11025	SNDRV_PCM_RATE_11025
+	#ifndef	USE_RATE_MIN_CH1
+		#define	USE_RATE_MIN_CH1	(11025)
+	#endif
+	#if (USE_RATE_MAX_CH1 < 11025)
+		#undef	USE_RATE_MAX_CH1
+		#define	USE_RATE_MAX_CH1	(11025)
+	#endif
+#else
+	#define	USE_RATE_CH1_11025	0
+#endif
+
+#ifdef	I2S_CH1_FS_16000
+	#define	USE_RATE_CH1_16000	SNDRV_PCM_RATE_16000
+	#ifndef	USE_RATE_MIN_CH1
+		#define	USE_RATE_MIN_CH1	(16000)
+	#endif
+	#if (USE_RATE_MAX_CH1 < 16000)
+		#undef	USE_RATE_MAX_CH1
+		#define	USE_RATE_MAX_CH1	(16000)
+	#endif
+#else
+	#define	USE_RATE_CH1_16000	0
+#endif
+
+#ifdef	I2S_CH1_FS_22050
+	#define	USE_RATE_CH1_22050	SNDRV_PCM_RATE_22050
+	#ifndef	USE_RATE_MIN_CH1
+		#define	USE_RATE_MIN_CH1	(22050)
+	#endif
+	#if (USE_RATE_MAX_CH1 < 22050)
+		#undef	USE_RATE_MAX_CH1
+		#define	USE_RATE_MAX_CH1	(22050)
+	#endif
+#else
+	#define	USE_RATE_CH1_22050	0
+#endif
+
+#ifdef	I2S_CH1_FS_32000
+	#define	USE_RATE_CH1_32000	SNDRV_PCM_RATE_32000
+	#ifndef	USE_RATE_MIN_CH1
+		#define	USE_RATE_MIN_CH1	(32000)
+	#endif
+	#if (USE_RATE_MAX_CH1 < 32000)
+		#undef	USE_RATE_MAX_CH1
+		#define	USE_RATE_MAX_CH1	(32000)
+	#endif
+#else
+	#define	USE_RATE_CH1_32000	0
+#endif
+
+#ifdef	I2S_CH1_FS_44100
+	#define	USE_RATE_CH1_44100	SNDRV_PCM_RATE_44100
+	#ifndef	USE_RATE_MIN_CH1
+		#define	USE_RATE_MIN_CH1	(44100)
+	#endif
+	#if (USE_RATE_MAX_CH1 < 44100)
+		#undef	USE_RATE_MAX_CH1
+		#define	USE_RATE_MAX_CH1	(44100)
+	#endif
+#else
+	#define	USE_RATE_CH1_44100	0
+#endif
+
+#ifdef	I2S_CH1_FS_48000
+	#define	USE_RATE_CH1_48000	SNDRV_PCM_RATE_48000
+	#ifndef	USE_RATE_MIN_CH1
+		#define	USE_RATE_MIN_CH1	(48000)
+	#endif
+	#if (USE_RATE_MAX_CH1 < 48000)
+		#undef	USE_RATE_MAX_CH1
+		#define	USE_RATE_MAX_CH1	(48000)
+	#endif
+#else
+	#define	USE_RATE_CH1_48000	0
+#endif
+
+#define	USE_RATE_CH1	(USE_RATE_CH1_8000|USE_RATE_CH1_11025 |		\
+			 USE_RATE_CH1_16000|USE_RATE_CH1_22050 |	\
+			 USE_RATE_CH1_32000|USE_RATE_CH1_44100 |	\
+			 USE_RATE_CH1_48000)
+
+
+#define I2S_CH1_64FS		(I2S_CH1_MCLK/64)
+#define I2S_CH1_128FS		(I2S_CH1_MCLK/128)
+#define I2S_CH1_192FS		(I2S_CH1_MCLK/192)
+#define I2S_CH1_256FS		(I2S_CH1_MCLK/256)
+#define I2S_CH1_384FS		(I2S_CH1_MCLK/384)
+#define I2S_CH1_512FS		(I2S_CH1_MCLK/512)
+#define I2S_CH1_768FS		(I2S_CH1_MCLK/768)
+#define I2S_CH1_1024FS		(I2S_CH1_MCLK/1024)
+
+
+#if (I2S_CH1_MSSEL == ioh_mssel_master)
+#ifdef	I2S_CH1_FS_8000
+	#if (I2S_CH1_64FS != I2S_CH1_FS_8000) && \
+		(I2S_CH1_128FS != I2S_CH1_FS_8000) && \
+		(I2S_CH1_192FS != I2S_CH1_FS_8000) && \
+		(I2S_CH1_256FS != I2S_CH1_FS_8000) && \
+		(I2S_CH1_384FS != I2S_CH1_FS_8000) && \
+		(I2S_CH1_512FS != I2S_CH1_FS_8000) && \
+		(I2S_CH1_768FS != I2S_CH1_FS_8000) && \
+		(I2S_CH1_1024FS != I2S_CH1_FS_8000)
+		#error IOH_I2S_CH1_CONFIG Error : \
+			Sampling frequency 8000Hz can not generate.
+	#endif
+#endif
+
+#ifdef	I2S_CH1_FS_11025
+	#if (I2S_CH1_64FS != I2S_CH1_FS_11025) && \
+		(I2S_CH1_128FS != I2S_CH1_FS_11025) && \
+		(I2S_CH1_192FS != I2S_CH1_FS_11025) && \
+		(I2S_CH1_256FS != I2S_CH1_FS_11025) && \
+		(I2S_CH1_384FS != I2S_CH1_FS_11025) && \
+		(I2S_CH1_512FS != I2S_CH1_FS_11025) && \
+		(I2S_CH1_768FS != I2S_CH1_FS_11025) && \
+		(I2S_CH1_1024FS != I2S_CH1_FS_11025)
+		#error IOH_I2S_CH1_CONFIG Error : \
+			Sampling frequency 11025Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH1_FS_16000
+	#if (I2S_CH1_64FS != I2S_CH1_FS_16000) && \
+		(I2S_CH1_128FS != I2S_CH1_FS_16000) && \
+		(I2S_CH1_192FS != I2S_CH1_FS_16000) && \
+		(I2S_CH1_256FS != I2S_CH1_FS_16000) && \
+		(I2S_CH1_384FS != I2S_CH1_FS_16000) && \
+		(I2S_CH1_512FS != I2S_CH1_FS_16000) && \
+		(I2S_CH1_768FS != I2S_CH1_FS_16000) && \
+		(I2S_CH1_1024FS != I2S_CH1_FS_16000)
+		#error IOH_I2S_CH1_CONFIG Error : \
+			Sampling frequency 16000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH1_FS_22050
+	#if (I2S_CH1_64FS != I2S_CH1_FS_22050) && \
+		(I2S_CH1_128FS != I2S_CH1_FS_22050) && \
+		(I2S_CH1_192FS != I2S_CH1_FS_22050) && \
+		(I2S_CH1_256FS != I2S_CH1_FS_22050) && \
+		(I2S_CH1_384FS != I2S_CH1_FS_22050) && \
+		(I2S_CH1_512FS != I2S_CH1_FS_22050) && \
+		(I2S_CH1_768FS != I2S_CH1_FS_22050) && \
+		(I2S_CH1_1024FS != I2S_CH1_FS_22050)
+		#error IOH_I2S_CH1_CONFIG Error : \
+			Sampling frequency 22050Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH1_FS_32000
+	#if (I2S_CH1_64FS != I2S_CH1_FS_32000) && \
+		(I2S_CH1_128FS != I2S_CH1_FS_32000) && \
+		(I2S_CH1_192FS != I2S_CH1_FS_32000) && \
+		(I2S_CH1_256FS != I2S_CH1_FS_32000) && \
+		(I2S_CH1_384FS != I2S_CH1_FS_32000) && \
+		(I2S_CH1_512FS != I2S_CH1_FS_32000) && \
+		(I2S_CH1_768FS != I2S_CH1_FS_32000) && \
+		(I2S_CH1_1024FS != I2S_CH1_FS_32000)
+		#error IOH_I2S_CH1_CONFIG Error : \
+			Sampling frequency 32000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH1_FS_44100
+	#if (I2S_CH1_64FS != I2S_CH1_FS_44100) && \
+		(I2S_CH1_128FS != I2S_CH1_FS_44100) && \
+		(I2S_CH1_192FS != I2S_CH1_FS_44100) && \
+		(I2S_CH1_256FS != I2S_CH1_FS_44100) && \
+		(I2S_CH1_384FS != I2S_CH1_FS_44100) && \
+		(I2S_CH1_512FS != I2S_CH1_FS_44100) && \
+		(I2S_CH1_768FS != I2S_CH1_FS_44100) && \
+		(I2S_CH1_1024FS != I2S_CH1_FS_44100)
+		#error IOH_I2S_CH1_CONFIG Error : \
+			Sampling frequency 44100Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH1_FS_48000
+	#if (I2S_CH1_64FS != I2S_CH1_FS_48000) && \
+		(I2S_CH1_128FS != I2S_CH1_FS_48000) && \
+		(I2S_CH1_192FS != I2S_CH1_FS_48000) && \
+		(I2S_CH1_256FS != I2S_CH1_FS_48000) && \
+		(I2S_CH1_384FS != I2S_CH1_FS_48000) && \
+		(I2S_CH1_512FS != I2S_CH1_FS_48000) && \
+		(I2S_CH1_768FS != I2S_CH1_FS_48000) && \
+		(I2S_CH1_1024FS != I2S_CH1_FS_48000)
+		#error IOH_I2S_CH1_CONFIG Error : \
+			Sampling frequency 48000Hz can not generate.
+	#endif
+#endif
+#endif	/* end of [#if (I2S_CH1_MSSEL == ioh_mssel_master)] */
+
+
+/* ===== CH2 Parameter Error Check ==== */
+#define	USE_RATE_MAX_CH2	(0)
+#ifdef	I2S_CH2_FS_8000
+	#define	USE_RATE_CH2_8000	SNDRV_PCM_RATE_8000
+	#define	USE_RATE_MIN_CH2	(8000)
+	#if (USE_RATE_MAX_CH2 < 8000)
+		#undef	USE_RATE_MAX_CH2
+		#define	USE_RATE_MAX_CH2	(8000)
+	#endif
+#else
+	#define	USE_RATE_CH2_8000	0
+#endif
+
+#ifdef	I2S_CH2_FS_11025
+	#define	USE_RATE_CH2_11025	SNDRV_PCM_RATE_11025
+	#ifndef	USE_RATE_MIN_CH2
+		#define	USE_RATE_MIN_CH2	(11025)
+	#endif
+	#if (USE_RATE_MAX_CH2 < 11025)
+		#undef	USE_RATE_MAX_CH2
+		#define	USE_RATE_MAX_CH2	(11025)
+	#endif
+#else
+	#define	USE_RATE_CH2_11025	0
+#endif
+
+#ifdef	I2S_CH2_FS_16000
+	#define	USE_RATE_CH2_16000	SNDRV_PCM_RATE_16000
+	#ifndef	USE_RATE_MIN_CH2
+		#define	USE_RATE_MIN_CH2	(16000)
+	#endif
+	#if (USE_RATE_MAX_CH2 < 16000)
+		#undef	USE_RATE_MAX_CH2
+		#define	USE_RATE_MAX_CH2	(16000)
+	#endif
+#else
+	#define	USE_RATE_CH2_16000	0
+#endif
+
+#ifdef	I2S_CH2_FS_22050
+	#define	USE_RATE_CH2_22050	SNDRV_PCM_RATE_22050
+	#ifndef	USE_RATE_MIN_CH2
+		#define	USE_RATE_MIN_CH2	(22050)
+	#endif
+	#if (USE_RATE_MAX_CH2 < 22050)
+		#undef	USE_RATE_MAX_CH2
+		#define	USE_RATE_MAX_CH2	(22050)
+	#endif
+#else
+	#define	USE_RATE_CH2_22050	0
+#endif
+
+#ifdef	I2S_CH2_FS_32000
+	#define	USE_RATE_CH2_32000	SNDRV_PCM_RATE_32000
+	#ifndef	USE_RATE_MIN_CH2
+		#define	USE_RATE_MIN_CH2	(32000)
+	#endif
+	#if (USE_RATE_MAX_CH2 < 32000)
+		#undef	USE_RATE_MAX_CH2
+		#define	USE_RATE_MAX_CH2	(32000)
+	#endif
+#else
+	#define	USE_RATE_CH2_32000	0
+#endif
+
+#ifdef	I2S_CH2_FS_44100
+	#define	USE_RATE_CH2_44100	SNDRV_PCM_RATE_44100
+	#ifndef	USE_RATE_MIN_CH2
+		#define	USE_RATE_MIN_CH2	(44100)
+	#endif
+	#if (USE_RATE_MAX_CH2 < 44100)
+		#undef	USE_RATE_MAX_CH2
+		#define	USE_RATE_MAX_CH2	(44100)
+	#endif
+#else
+	#define	USE_RATE_CH2_44100	0
+#endif
+
+#ifdef	I2S_CH2_FS_48000
+	#define	USE_RATE_CH2_48000	SNDRV_PCM_RATE_48000
+	#ifndef	USE_RATE_MIN_CH2
+		#define	USE_RATE_MIN_CH2	(48000)
+	#endif
+	#if (USE_RATE_MAX_CH2 < 48000)
+		#undef	USE_RATE_MAX_CH2
+		#define	USE_RATE_MAX_CH2	(48000)
+	#endif
+#else
+	#define	USE_RATE_CH2_48000	0
+#endif
+
+#define	USE_RATE_CH2	(USE_RATE_CH2_8000|USE_RATE_CH2_11025 |		\
+			 USE_RATE_CH2_16000|USE_RATE_CH2_22050 |	\
+			 USE_RATE_CH2_32000|USE_RATE_CH2_44100 |	\
+			 USE_RATE_CH2_48000)
+
+
+#define I2S_CH2_64FS		(I2S_CH2_MCLK/64)
+#define I2S_CH2_128FS		(I2S_CH2_MCLK/128)
+#define I2S_CH2_192FS		(I2S_CH2_MCLK/192)
+#define I2S_CH2_256FS		(I2S_CH2_MCLK/256)
+#define I2S_CH2_384FS		(I2S_CH2_MCLK/384)
+#define I2S_CH2_512FS		(I2S_CH2_MCLK/512)
+#define I2S_CH2_768FS		(I2S_CH2_MCLK/768)
+#define I2S_CH2_1024FS		(I2S_CH2_MCLK/1024)
+
+
+#if (I2S_CH2_MSSEL == ioh_mssel_master)
+#ifdef	I2S_CH2_FS_8000
+	#if (I2S_CH2_64FS != I2S_CH2_FS_8000) && \
+		(I2S_CH2_128FS != I2S_CH2_FS_8000) && \
+		(I2S_CH2_192FS != I2S_CH2_FS_8000) && \
+		(I2S_CH2_256FS != I2S_CH2_FS_8000) && \
+		(I2S_CH2_384FS != I2S_CH2_FS_8000) && \
+		(I2S_CH2_512FS != I2S_CH2_FS_8000) && \
+		(I2S_CH2_768FS != I2S_CH2_FS_8000) && \
+		(I2S_CH2_1024FS != I2S_CH2_FS_8000)
+		#error IOH_I2S_CH2_CONFIG Error : \
+			Sampling frequency 8000Hz can not generate.
+	#endif
+#endif
+
+#ifdef	I2S_CH2_FS_11025
+	#if (I2S_CH2_64FS != I2S_CH2_FS_11025) && \
+		(I2S_CH2_128FS != I2S_CH2_FS_11025) && \
+		(I2S_CH2_192FS != I2S_CH2_FS_11025) && \
+		(I2S_CH2_256FS != I2S_CH2_FS_11025) && \
+		(I2S_CH2_384FS != I2S_CH2_FS_11025) && \
+		(I2S_CH2_512FS != I2S_CH2_FS_11025) && \
+		(I2S_CH2_768FS != I2S_CH2_FS_11025) && \
+		(I2S_CH2_1024FS != I2S_CH2_FS_11025)
+		#error IOH_I2S_CH2_CONFIG Error : \
+			Sampling frequency 11025Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH2_FS_16000
+	#if (I2S_CH2_64FS != I2S_CH2_FS_16000) && \
+		(I2S_CH2_128FS != I2S_CH2_FS_16000) && \
+		(I2S_CH2_192FS != I2S_CH2_FS_16000) && \
+		(I2S_CH2_256FS != I2S_CH2_FS_16000) && \
+		(I2S_CH2_384FS != I2S_CH2_FS_16000) && \
+		(I2S_CH2_512FS != I2S_CH2_FS_16000) && \
+		(I2S_CH2_768FS != I2S_CH2_FS_16000) && \
+		(I2S_CH2_1024FS != I2S_CH2_FS_16000)
+		#error IOH_I2S_CH2_CONFIG Error : \
+			Sampling frequency 16000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH2_FS_22050
+	#if (I2S_CH2_64FS != I2S_CH2_FS_22050) && \
+		(I2S_CH2_128FS != I2S_CH2_FS_22050) && \
+		(I2S_CH2_192FS != I2S_CH2_FS_22050) && \
+		(I2S_CH2_256FS != I2S_CH2_FS_22050) && \
+		(I2S_CH2_384FS != I2S_CH2_FS_22050) && \
+		(I2S_CH2_512FS != I2S_CH2_FS_22050) && \
+		(I2S_CH2_768FS != I2S_CH2_FS_22050) && \
+		(I2S_CH2_1024FS != I2S_CH2_FS_22050)
+		#error IOH_I2S_CH2_CONFIG Error : \
+			Sampling frequency 22050Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH2_FS_32000
+	#if (I2S_CH2_64FS != I2S_CH2_FS_32000) && \
+		(I2S_CH2_128FS != I2S_CH2_FS_32000) && \
+		(I2S_CH2_192FS != I2S_CH2_FS_32000) && \
+		(I2S_CH2_256FS != I2S_CH2_FS_32000) && \
+		(I2S_CH2_384FS != I2S_CH2_FS_32000) && \
+		(I2S_CH2_512FS != I2S_CH2_FS_32000) && \
+		(I2S_CH2_768FS != I2S_CH2_FS_32000) && \
+		(I2S_CH2_1024FS != I2S_CH2_FS_32000)
+		#error IOH_I2S_CH2_CONFIG Error : \
+			Sampling frequency 32000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH2_FS_44100
+	#if (I2S_CH2_64FS != I2S_CH2_FS_44100) && \
+		(I2S_CH2_128FS != I2S_CH2_FS_44100) && \
+		(I2S_CH2_192FS != I2S_CH2_FS_44100) && \
+		(I2S_CH2_256FS != I2S_CH2_FS_44100) && \
+		(I2S_CH2_384FS != I2S_CH2_FS_44100) && \
+		(I2S_CH2_512FS != I2S_CH2_FS_44100) && \
+		(I2S_CH2_768FS != I2S_CH2_FS_44100) && \
+		(I2S_CH2_1024FS != I2S_CH2_FS_44100)
+		#error IOH_I2S_CH2_CONFIG Error : \
+			Sampling frequency 44100Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH2_FS_48000
+	#if (I2S_CH2_64FS != I2S_CH2_FS_48000) && \
+		(I2S_CH2_128FS != I2S_CH2_FS_48000) && \
+		(I2S_CH2_192FS != I2S_CH2_FS_48000) && \
+		(I2S_CH2_256FS != I2S_CH2_FS_48000) && \
+		(I2S_CH2_384FS != I2S_CH2_FS_48000) && \
+		(I2S_CH2_512FS != I2S_CH2_FS_48000) && \
+		(I2S_CH2_768FS != I2S_CH2_FS_48000) && \
+		(I2S_CH2_1024FS != I2S_CH2_FS_48000)
+		#error IOH_I2S_CH2_CONFIG Error : \
+			Sampling frequency 48000Hz can not generate.
+	#endif
+#endif
+#endif	/* end of [#if (I2S_CH2_MSSEL == ioh_mssel_master)] */
+
+
+/* ===== CH3 Parameter Error Check ==== */
+#define	USE_RATE_MAX_CH3	(0)
+#ifdef	I2S_CH3_FS_8000
+	#define	USE_RATE_CH3_8000	SNDRV_PCM_RATE_8000
+	#define	USE_RATE_MIN_CH3	(8000)
+	#if (USE_RATE_MAX_CH3 < 8000)
+		#undef	USE_RATE_MAX_CH3
+		#define	USE_RATE_MAX_CH3	(8000)
+	#endif
+#else
+	#define	USE_RATE_CH3_8000	0
+#endif
+
+#ifdef	I2S_CH3_FS_11025
+	#define	USE_RATE_CH3_11025	SNDRV_PCM_RATE_11025
+	#ifndef	USE_RATE_MIN_CH3
+		#define	USE_RATE_MIN_CH3	(11025)
+	#endif
+	#if (USE_RATE_MAX_CH3 < 11025)
+		#undef	USE_RATE_MAX_CH3
+		#define	USE_RATE_MAX_CH3	(11025)
+	#endif
+#else
+	#define	USE_RATE_CH3_11025	0
+#endif
+
+#ifdef	I2S_CH3_FS_16000
+	#define	USE_RATE_CH3_16000	SNDRV_PCM_RATE_16000
+	#ifndef	USE_RATE_MIN_CH3
+		#define	USE_RATE_MIN_CH3	(16000)
+	#endif
+	#if (USE_RATE_MAX_CH3 < 16000)
+		#undef	USE_RATE_MAX_CH3
+		#define	USE_RATE_MAX_CH3	(16000)
+	#endif
+#else
+	#define	USE_RATE_CH3_16000	0
+#endif
+
+#ifdef	I2S_CH3_FS_22050
+	#define	USE_RATE_CH3_22050	SNDRV_PCM_RATE_22050
+	#ifndef	USE_RATE_MIN_CH3
+		#define	USE_RATE_MIN_CH3	(22050)
+	#endif
+	#if (USE_RATE_MAX_CH3 < 22050)
+		#undef	USE_RATE_MAX_CH3
+		#define	USE_RATE_MAX_CH3	(22050)
+	#endif
+#else
+	#define	USE_RATE_CH3_22050	0
+#endif
+
+#ifdef	I2S_CH3_FS_32000
+	#define	USE_RATE_CH3_32000	SNDRV_PCM_RATE_32000
+	#ifndef	USE_RATE_MIN_CH3
+		#define	USE_RATE_MIN_CH3	(32000)
+	#endif
+	#if (USE_RATE_MAX_CH3 < 32000)
+		#undef	USE_RATE_MAX_CH3
+		#define	USE_RATE_MAX_CH3	(32000)
+	#endif
+#else
+	#define	USE_RATE_CH3_32000	0
+#endif
+
+#ifdef	I2S_CH3_FS_44100
+	#define	USE_RATE_CH3_44100	SNDRV_PCM_RATE_44100
+	#ifndef	USE_RATE_MIN_CH3
+		#define	USE_RATE_MIN_CH3	(44100)
+	#endif
+	#if (USE_RATE_MAX_CH3 < 44100)
+		#undef	USE_RATE_MAX_CH3
+		#define	USE_RATE_MAX_CH3	(44100)
+	#endif
+#else
+	#define	USE_RATE_CH3_44100	0
+#endif
+
+#ifdef	I2S_CH3_FS_48000
+	#define	USE_RATE_CH3_48000	SNDRV_PCM_RATE_48000
+	#ifndef	USE_RATE_MIN_CH3
+		#define	USE_RATE_MIN_CH3	(48000)
+	#endif
+	#if (USE_RATE_MAX_CH3 < 48000)
+		#undef	USE_RATE_MAX_CH3
+		#define	USE_RATE_MAX_CH3	(48000)
+	#endif
+#else
+	#define	USE_RATE_CH3_48000	0
+#endif
+
+#define	USE_RATE_CH3	(USE_RATE_CH3_8000|USE_RATE_CH3_11025 |		\
+			 USE_RATE_CH3_16000|USE_RATE_CH3_22050 |	\
+			 USE_RATE_CH3_32000|USE_RATE_CH3_44100 |	\
+			 USE_RATE_CH3_48000)
+
+
+#define I2S_CH3_64FS		(I2S_CH3_MCLK/64)
+#define I2S_CH3_128FS		(I2S_CH3_MCLK/128)
+#define I2S_CH3_192FS		(I2S_CH3_MCLK/192)
+#define I2S_CH3_256FS		(I2S_CH3_MCLK/256)
+#define I2S_CH3_384FS		(I2S_CH3_MCLK/384)
+#define I2S_CH3_512FS		(I2S_CH3_MCLK/512)
+#define I2S_CH3_768FS		(I2S_CH3_MCLK/768)
+#define I2S_CH3_1024FS		(I2S_CH3_MCLK/1024)
+
+
+#if (I2S_CH3_MSSEL == ioh_mssel_master)
+#ifdef	I2S_CH3_FS_8000
+	#if (I2S_CH3_64FS != I2S_CH3_FS_8000) && \
+		(I2S_CH3_128FS != I2S_CH3_FS_8000) && \
+		(I2S_CH3_192FS != I2S_CH3_FS_8000) && \
+		(I2S_CH3_256FS != I2S_CH3_FS_8000) && \
+		(I2S_CH3_384FS != I2S_CH3_FS_8000) && \
+		(I2S_CH3_512FS != I2S_CH3_FS_8000) && \
+		(I2S_CH3_768FS != I2S_CH3_FS_8000) && \
+		(I2S_CH3_1024FS != I2S_CH3_FS_8000)
+		#error IOH_I2S_CH3_CONFIG Error : \
+			Sampling frequency 8000Hz can not generate.
+	#endif
+#endif
+
+#ifdef	I2S_CH3_FS_11025
+	#if (I2S_CH3_64FS != I2S_CH3_FS_11025) && \
+		(I2S_CH3_128FS != I2S_CH3_FS_11025) && \
+		(I2S_CH3_192FS != I2S_CH3_FS_11025) && \
+		(I2S_CH3_256FS != I2S_CH3_FS_11025) && \
+		(I2S_CH3_384FS != I2S_CH3_FS_11025) && \
+		(I2S_CH3_512FS != I2S_CH3_FS_11025) && \
+		(I2S_CH3_768FS != I2S_CH3_FS_11025) && \
+		(I2S_CH3_1024FS != I2S_CH3_FS_11025)
+		#error IOH_I2S_CH3_CONFIG Error : \
+			Sampling frequency 11025Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH3_FS_16000
+	#if (I2S_CH3_64FS != I2S_CH3_FS_16000) && \
+		(I2S_CH3_128FS != I2S_CH3_FS_16000) && \
+		(I2S_CH3_192FS != I2S_CH3_FS_16000) && \
+		(I2S_CH3_256FS != I2S_CH3_FS_16000) && \
+		(I2S_CH3_384FS != I2S_CH3_FS_16000) && \
+		(I2S_CH3_512FS != I2S_CH3_FS_16000) && \
+		(I2S_CH3_768FS != I2S_CH3_FS_16000) && \
+		(I2S_CH3_1024FS != I2S_CH3_FS_16000)
+		#error IOH_I2S_CH3_CONFIG Error : \
+			Sampling frequency 16000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH3_FS_22050
+	#if (I2S_CH3_64FS != I2S_CH3_FS_22050) && \
+		(I2S_CH3_128FS != I2S_CH3_FS_22050) && \
+		(I2S_CH3_192FS != I2S_CH3_FS_22050) && \
+		(I2S_CH3_256FS != I2S_CH3_FS_22050) && \
+		(I2S_CH3_384FS != I2S_CH3_FS_22050) && \
+		(I2S_CH3_512FS != I2S_CH3_FS_22050) && \
+		(I2S_CH3_768FS != I2S_CH3_FS_22050) && \
+		(I2S_CH3_1024FS != I2S_CH3_FS_22050)
+		#error IOH_I2S_CH3_CONFIG Error : \
+			Sampling frequency 22050Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH3_FS_32000
+	#if (I2S_CH3_64FS != I2S_CH3_FS_32000) && \
+		(I2S_CH3_128FS != I2S_CH3_FS_32000) && \
+		(I2S_CH3_192FS != I2S_CH3_FS_32000) && \
+		(I2S_CH3_256FS != I2S_CH3_FS_32000) && \
+		(I2S_CH3_384FS != I2S_CH3_FS_32000) && \
+		(I2S_CH3_512FS != I2S_CH3_FS_32000) && \
+		(I2S_CH3_768FS != I2S_CH3_FS_32000) && \
+		(I2S_CH3_1024FS != I2S_CH3_FS_32000)
+		#error IOH_I2S_CH3_CONFIG Error : \
+			Sampling frequency 32000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH3_FS_44100
+	#if (I2S_CH3_64FS != I2S_CH3_FS_44100) && \
+		(I2S_CH3_128FS != I2S_CH3_FS_44100) && \
+		(I2S_CH3_192FS != I2S_CH3_FS_44100) && \
+		(I2S_CH3_256FS != I2S_CH3_FS_44100) && \
+		(I2S_CH3_384FS != I2S_CH3_FS_44100) && \
+		(I2S_CH3_512FS != I2S_CH3_FS_44100) && \
+		(I2S_CH3_768FS != I2S_CH3_FS_44100) && \
+		(I2S_CH3_1024FS != I2S_CH3_FS_44100)
+		#error IOH_I2S_CH3_CONFIG Error : \
+			Sampling frequency 44100Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH3_FS_48000
+	#if (I2S_CH3_64FS != I2S_CH3_FS_48000) && \
+		(I2S_CH3_128FS != I2S_CH3_FS_48000) && \
+		(I2S_CH3_192FS != I2S_CH3_FS_48000) && \
+		(I2S_CH3_256FS != I2S_CH3_FS_48000) && \
+		(I2S_CH3_384FS != I2S_CH3_FS_48000) && \
+		(I2S_CH3_512FS != I2S_CH3_FS_48000) && \
+		(I2S_CH3_768FS != I2S_CH3_FS_48000) && \
+		(I2S_CH3_1024FS != I2S_CH3_FS_48000)
+		#error IOH_I2S_CH3_CONFIG Error : \
+			Sampling frequency 48000Hz can not generate.
+	#endif
+#endif
+#endif	/* end of [#if (I2S_CH3_MSSEL == ioh_mssel_master)] */
+
+
+/* ===== CH4 Parameter Error Check ==== */
+#define	USE_RATE_MAX_CH4	(0)
+#ifdef	I2S_CH4_FS_8000
+	#define	USE_RATE_CH4_8000	SNDRV_PCM_RATE_8000
+	#define	USE_RATE_MIN_CH4	(8000)
+	#if (USE_RATE_MAX_CH4 < 8000)
+		#undef	USE_RATE_MAX_CH4
+		#define	USE_RATE_MAX_CH4	(8000)
+	#endif
+#else
+	#define	USE_RATE_CH4_8000	0
+#endif
+
+#ifdef	I2S_CH4_FS_11025
+	#define	USE_RATE_CH4_11025	SNDRV_PCM_RATE_11025
+	#ifndef	USE_RATE_MIN_CH4
+		#define	USE_RATE_MIN_CH4	(11025)
+	#endif
+	#if (USE_RATE_MAX_CH4 < 11025)
+		#undef	USE_RATE_MAX_CH4
+		#define	USE_RATE_MAX_CH4	(11025)
+	#endif
+#else
+	#define	USE_RATE_CH4_11025	0
+#endif
+
+#ifdef	I2S_CH4_FS_16000
+	#define	USE_RATE_CH4_16000	SNDRV_PCM_RATE_16000
+	#ifndef	USE_RATE_MIN_CH4
+		#define	USE_RATE_MIN_CH4	(16000)
+	#endif
+	#if (USE_RATE_MAX_CH4 < 16000)
+		#undef	USE_RATE_MAX_CH4
+		#define	USE_RATE_MAX_CH4	(16000)
+	#endif
+#else
+	#define	USE_RATE_CH4_16000	0
+#endif
+
+#ifdef	I2S_CH4_FS_22050
+	#define	USE_RATE_CH4_22050	SNDRV_PCM_RATE_22050
+	#ifndef	USE_RATE_MIN_CH4
+		#define	USE_RATE_MIN_CH4	(22050)
+	#endif
+	#if (USE_RATE_MAX_CH4 < 22050)
+		#undef	USE_RATE_MAX_CH4
+		#define	USE_RATE_MAX_CH4	(22050)
+	#endif
+#else
+	#define	USE_RATE_CH4_22050	0
+#endif
+
+#ifdef	I2S_CH4_FS_32000
+	#define	USE_RATE_CH4_32000	SNDRV_PCM_RATE_32000
+	#ifndef	USE_RATE_MIN_CH4
+		#define	USE_RATE_MIN_CH4	(32000)
+	#endif
+	#if (USE_RATE_MAX_CH4 < 32000)
+		#undef	USE_RATE_MAX_CH4
+		#define	USE_RATE_MAX_CH4	(32000)
+	#endif
+#else
+	#define	USE_RATE_CH4_32000	0
+#endif
+
+#ifdef	I2S_CH4_FS_44100
+	#define	USE_RATE_CH4_44100	SNDRV_PCM_RATE_44100
+	#ifndef	USE_RATE_MIN_CH4
+		#define	USE_RATE_MIN_CH4	(44100)
+	#endif
+	#if (USE_RATE_MAX_CH4 < 44100)
+		#undef	USE_RATE_MAX_CH4
+		#define	USE_RATE_MAX_CH4	(44100)
+	#endif
+#else
+	#define	USE_RATE_CH4_44100	0
+#endif
+
+#ifdef	I2S_CH4_FS_48000
+	#define	USE_RATE_CH4_48000	SNDRV_PCM_RATE_48000
+	#ifndef	USE_RATE_MIN_CH4
+		#define	USE_RATE_MIN_CH4	(48000)
+	#endif
+	#if (USE_RATE_MAX_CH4 < 48000)
+		#undef	USE_RATE_MAX_CH4
+		#define	USE_RATE_MAX_CH4	(48000)
+	#endif
+#else
+	#define	USE_RATE_CH4_48000	0
+#endif
+
+#define	USE_RATE_CH4	(USE_RATE_CH4_8000|USE_RATE_CH4_11025 |		\
+			 USE_RATE_CH4_16000|USE_RATE_CH4_22050 |	\
+			 USE_RATE_CH4_32000|USE_RATE_CH4_44100 |	\
+			 USE_RATE_CH4_48000)
+
+
+#define I2S_CH4_64FS		(I2S_CH4_MCLK/64)
+#define I2S_CH4_128FS		(I2S_CH4_MCLK/128)
+#define I2S_CH4_192FS		(I2S_CH4_MCLK/192)
+#define I2S_CH4_256FS		(I2S_CH4_MCLK/256)
+#define I2S_CH4_384FS		(I2S_CH4_MCLK/384)
+#define I2S_CH4_512FS		(I2S_CH4_MCLK/512)
+#define I2S_CH4_768FS		(I2S_CH4_MCLK/768)
+#define I2S_CH4_1024FS		(I2S_CH4_MCLK/1024)
+
+
+#if (I2S_CH4_MSSEL == ioh_mssel_master)
+#ifdef	I2S_CH4_FS_8000
+	#if (I2S_CH4_64FS != I2S_CH4_FS_8000) && \
+		(I2S_CH4_128FS != I2S_CH4_FS_8000) && \
+		(I2S_CH4_192FS != I2S_CH4_FS_8000) && \
+		(I2S_CH4_256FS != I2S_CH4_FS_8000) && \
+		(I2S_CH4_384FS != I2S_CH4_FS_8000) && \
+		(I2S_CH4_512FS != I2S_CH4_FS_8000) && \
+		(I2S_CH4_768FS != I2S_CH4_FS_8000) && \
+		(I2S_CH4_1024FS != I2S_CH4_FS_8000)
+		#error IOH_I2S_CH4_CONFIG Error : \
+			Sampling frequency 8000Hz can not generate.
+	#endif
+#endif
+
+#ifdef	I2S_CH4_FS_11025
+	#if (I2S_CH4_64FS != I2S_CH4_FS_11025) && \
+		(I2S_CH4_128FS != I2S_CH4_FS_11025) && \
+		(I2S_CH4_192FS != I2S_CH4_FS_11025) && \
+		(I2S_CH4_256FS != I2S_CH4_FS_11025) && \
+		(I2S_CH4_384FS != I2S_CH4_FS_11025) && \
+		(I2S_CH4_512FS != I2S_CH4_FS_11025) && \
+		(I2S_CH4_768FS != I2S_CH4_FS_11025) && \
+		(I2S_CH4_1024FS != I2S_CH4_FS_11025)
+		#error IOH_I2S_CH4_CONFIG Error : \
+			Sampling frequency 11025Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH4_FS_16000
+	#if (I2S_CH4_64FS != I2S_CH4_FS_16000) && \
+		(I2S_CH4_128FS != I2S_CH4_FS_16000) && \
+		(I2S_CH4_192FS != I2S_CH4_FS_16000) && \
+		(I2S_CH4_256FS != I2S_CH4_FS_16000) && \
+		(I2S_CH4_384FS != I2S_CH4_FS_16000) && \
+		(I2S_CH4_512FS != I2S_CH4_FS_16000) && \
+		(I2S_CH4_768FS != I2S_CH4_FS_16000) && \
+		(I2S_CH4_1024FS != I2S_CH4_FS_16000)
+		#error IOH_I2S_CH4_CONFIG Error : \
+			Sampling frequency 16000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH4_FS_22050
+	#if (I2S_CH4_64FS != I2S_CH4_FS_22050) && \
+		(I2S_CH4_128FS != I2S_CH4_FS_22050) && \
+		(I2S_CH4_192FS != I2S_CH4_FS_22050) && \
+		(I2S_CH4_256FS != I2S_CH4_FS_22050) && \
+		(I2S_CH4_384FS != I2S_CH4_FS_22050) && \
+		(I2S_CH4_512FS != I2S_CH4_FS_22050) && \
+		(I2S_CH4_768FS != I2S_CH4_FS_22050) && \
+		(I2S_CH4_1024FS != I2S_CH4_FS_22050)
+		#error IOH_I2S_CH4_CONFIG Error : \
+			Sampling frequency 22050Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH4_FS_32000
+	#if (I2S_CH4_64FS != I2S_CH4_FS_32000) && \
+		(I2S_CH4_128FS != I2S_CH4_FS_32000) && \
+		(I2S_CH4_192FS != I2S_CH4_FS_32000) && \
+		(I2S_CH4_256FS != I2S_CH4_FS_32000) && \
+		(I2S_CH4_384FS != I2S_CH4_FS_32000) && \
+		(I2S_CH4_512FS != I2S_CH4_FS_32000) && \
+		(I2S_CH4_768FS != I2S_CH4_FS_32000) && \
+		(I2S_CH4_1024FS != I2S_CH4_FS_32000)
+		#error IOH_I2S_CH4_CONFIG Error : \
+			Sampling frequency 32000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH4_FS_44100
+	#if (I2S_CH4_64FS != I2S_CH4_FS_44100) && \
+		(I2S_CH4_128FS != I2S_CH4_FS_44100) && \
+		(I2S_CH4_192FS != I2S_CH4_FS_44100) && \
+		(I2S_CH4_256FS != I2S_CH4_FS_44100) && \
+		(I2S_CH4_384FS != I2S_CH4_FS_44100) && \
+		(I2S_CH4_512FS != I2S_CH4_FS_44100) && \
+		(I2S_CH4_768FS != I2S_CH4_FS_44100) && \
+		(I2S_CH4_1024FS != I2S_CH4_FS_44100)
+		#error IOH_I2S_CH4_CONFIG Error : \
+			Sampling frequency 44100Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH4_FS_48000
+	#if (I2S_CH4_64FS != I2S_CH4_FS_48000) && \
+		(I2S_CH4_128FS != I2S_CH4_FS_48000) && \
+		(I2S_CH4_192FS != I2S_CH4_FS_48000) && \
+		(I2S_CH4_256FS != I2S_CH4_FS_48000) && \
+		(I2S_CH4_384FS != I2S_CH4_FS_48000) && \
+		(I2S_CH4_512FS != I2S_CH4_FS_48000) && \
+		(I2S_CH4_768FS != I2S_CH4_FS_48000) && \
+		(I2S_CH4_1024FS != I2S_CH4_FS_48000)
+		#error IOH_I2S_CH4_CONFIG Error : \
+			Sampling frequency 48000Hz can not generate.
+	#endif
+#endif
+#endif	/* end of [#if (I2S_CH4_MSSEL == ioh_mssel_master)] */
+
+
+/* ===== CH5 Parameter Error Check ==== */
+#define	USE_RATE_MAX_CH5	(0)
+#ifdef	I2S_CH5_FS_8000
+	#define	USE_RATE_CH5_8000	SNDRV_PCM_RATE_8000
+	#define	USE_RATE_MIN_CH5	(8000)
+	#if (USE_RATE_MAX_CH5 < 8000)
+		#undef	USE_RATE_MAX_CH5
+		#define	USE_RATE_MAX_CH5	(8000)
+	#endif
+#else
+	#define	USE_RATE_CH5_8000	0
+#endif
+
+#ifdef	I2S_CH5_FS_11025
+	#define	USE_RATE_CH5_11025	SNDRV_PCM_RATE_11025
+	#ifndef	USE_RATE_MIN_CH5
+		#define	USE_RATE_MIN_CH5	(11025)
+	#endif
+	#if (USE_RATE_MAX_CH5 < 11025)
+		#undef	USE_RATE_MAX_CH5
+		#define	USE_RATE_MAX_CH5	(11025)
+	#endif
+#else
+	#define	USE_RATE_CH5_11025	0
+#endif
+
+#ifdef	I2S_CH5_FS_16000
+	#define	USE_RATE_CH5_16000	SNDRV_PCM_RATE_16000
+	#ifndef	USE_RATE_MIN_CH5
+		#define	USE_RATE_MIN_CH5	(16000)
+	#endif
+	#if (USE_RATE_MAX_CH5 < 16000)
+		#undef	USE_RATE_MAX_CH5
+		#define	USE_RATE_MAX_CH5	(16000)
+	#endif
+#else
+	#define	USE_RATE_CH5_16000	0
+#endif
+
+#ifdef	I2S_CH5_FS_22050
+	#define	USE_RATE_CH5_22050	SNDRV_PCM_RATE_22050
+	#ifndef	USE_RATE_MIN_CH5
+		#define	USE_RATE_MIN_CH5	(22050)
+	#endif
+	#if (USE_RATE_MAX_CH5 < 22050)
+		#undef	USE_RATE_MAX_CH5
+		#define	USE_RATE_MAX_CH5	(22050)
+	#endif
+#else
+	#define	USE_RATE_CH5_22050	0
+#endif
+
+#ifdef	I2S_CH5_FS_32000
+	#define	USE_RATE_CH5_32000	SNDRV_PCM_RATE_32000
+	#ifndef	USE_RATE_MIN_CH5
+		#define	USE_RATE_MIN_CH5	(32000)
+	#endif
+	#if (USE_RATE_MAX_CH5 < 32000)
+		#undef	USE_RATE_MAX_CH5
+		#define	USE_RATE_MAX_CH5	(32000)
+	#endif
+#else
+	#define	USE_RATE_CH5_32000	0
+#endif
+
+#ifdef	I2S_CH5_FS_44100
+	#define	USE_RATE_CH5_44100	SNDRV_PCM_RATE_44100
+	#ifndef	USE_RATE_MIN_CH5
+		#define	USE_RATE_MIN_CH5	(44100)
+	#endif
+	#if (USE_RATE_MAX_CH5 < 44100)
+		#undef	USE_RATE_MAX_CH5
+		#define	USE_RATE_MAX_CH5	(44100)
+	#endif
+#else
+	#define	USE_RATE_CH5_44100	0
+#endif
+
+#ifdef	I2S_CH5_FS_48000
+	#define	USE_RATE_CH5_48000	SNDRV_PCM_RATE_48000
+	#ifndef	USE_RATE_MIN_CH5
+		#define	USE_RATE_MIN_CH5	(48000)
+	#endif
+	#if (USE_RATE_MAX_CH5 < 48000)
+		#undef	USE_RATE_MAX_CH5
+		#define	USE_RATE_MAX_CH5	(48000)
+	#endif
+#else
+	#define	USE_RATE_CH5_48000	0
+#endif
+
+#define	USE_RATE_CH5	(USE_RATE_CH5_8000|USE_RATE_CH5_11025 |		\
+			 USE_RATE_CH5_16000|USE_RATE_CH5_22050 |	\
+			 USE_RATE_CH5_32000|USE_RATE_CH5_44100 |	\
+			 USE_RATE_CH5_48000)
+
+
+#define I2S_CH5_64FS		(I2S_CH5_MCLK/64)
+#define I2S_CH5_128FS		(I2S_CH5_MCLK/128)
+#define I2S_CH5_192FS		(I2S_CH5_MCLK/192)
+#define I2S_CH5_256FS		(I2S_CH5_MCLK/256)
+#define I2S_CH5_384FS		(I2S_CH5_MCLK/384)
+#define I2S_CH5_512FS		(I2S_CH5_MCLK/512)
+#define I2S_CH5_768FS		(I2S_CH5_MCLK/768)
+#define I2S_CH5_1024FS		(I2S_CH5_MCLK/1024)
+
+
+#if (I2S_CH5_MSSEL == ioh_mssel_master)
+#ifdef	I2S_CH5_FS_8000
+	#if (I2S_CH5_64FS != I2S_CH5_FS_8000) && \
+		(I2S_CH5_128FS != I2S_CH5_FS_8000) && \
+		(I2S_CH5_192FS != I2S_CH5_FS_8000) && \
+		(I2S_CH5_256FS != I2S_CH5_FS_8000) && \
+		(I2S_CH5_384FS != I2S_CH5_FS_8000) && \
+		(I2S_CH5_512FS != I2S_CH5_FS_8000) && \
+		(I2S_CH5_768FS != I2S_CH5_FS_8000) && \
+		(I2S_CH5_1024FS != I2S_CH5_FS_8000)
+		#error IOH_I2S_CH5_CONFIG Error : \
+			Sampling frequency 8000Hz can not generate.
+	#endif
+#endif
+
+#ifdef	I2S_CH5_FS_11025
+	#if (I2S_CH5_64FS != I2S_CH5_FS_11025) && \
+		(I2S_CH5_128FS != I2S_CH5_FS_11025) && \
+		(I2S_CH5_192FS != I2S_CH5_FS_11025) && \
+		(I2S_CH5_256FS != I2S_CH5_FS_11025) && \
+		(I2S_CH5_384FS != I2S_CH5_FS_11025) && \
+		(I2S_CH5_512FS != I2S_CH5_FS_11025) && \
+		(I2S_CH5_768FS != I2S_CH5_FS_11025) && \
+		(I2S_CH5_1024FS != I2S_CH5_FS_11025)
+		#error IOH_I2S_CH5_CONFIG Error : \
+			Sampling frequency 11025Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH5_FS_16000
+	#if (I2S_CH5_64FS != I2S_CH5_FS_16000) && \
+		(I2S_CH5_128FS != I2S_CH5_FS_16000) && \
+		(I2S_CH5_192FS != I2S_CH5_FS_16000) && \
+		(I2S_CH5_256FS != I2S_CH5_FS_16000) && \
+		(I2S_CH5_384FS != I2S_CH5_FS_16000) && \
+		(I2S_CH5_512FS != I2S_CH5_FS_16000) && \
+		(I2S_CH5_768FS != I2S_CH5_FS_16000) && \
+		(I2S_CH5_1024FS != I2S_CH5_FS_16000)
+		#error IOH_I2S_CH5_CONFIG Error : \
+			Sampling frequency 16000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH5_FS_22050
+	#if (I2S_CH5_64FS != I2S_CH5_FS_22050) && \
+		(I2S_CH5_128FS != I2S_CH5_FS_22050) && \
+		(I2S_CH5_192FS != I2S_CH5_FS_22050) && \
+		(I2S_CH5_256FS != I2S_CH5_FS_22050) && \
+		(I2S_CH5_384FS != I2S_CH5_FS_22050) && \
+		(I2S_CH5_512FS != I2S_CH5_FS_22050) && \
+		(I2S_CH5_768FS != I2S_CH5_FS_22050) && \
+		(I2S_CH5_1024FS != I2S_CH5_FS_22050)
+		#error IOH_I2S_CH5_CONFIG Error : \
+			Sampling frequency 22050Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH5_FS_32000
+	#if (I2S_CH5_64FS != I2S_CH5_FS_32000) && \
+		(I2S_CH5_128FS != I2S_CH5_FS_32000) && \
+		(I2S_CH5_192FS != I2S_CH5_FS_32000) && \
+		(I2S_CH5_256FS != I2S_CH5_FS_32000) && \
+		(I2S_CH5_384FS != I2S_CH5_FS_32000) && \
+		(I2S_CH5_512FS != I2S_CH5_FS_32000) && \
+		(I2S_CH5_768FS != I2S_CH5_FS_32000) && \
+		(I2S_CH5_1024FS != I2S_CH5_FS_32000)
+		#error IOH_I2S_CH5_CONFIG Error : \
+			Sampling frequency 32000Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH5_FS_44100
+	#if (I2S_CH5_64FS != I2S_CH5_FS_44100) && \
+		(I2S_CH5_128FS != I2S_CH5_FS_44100) && \
+		(I2S_CH5_192FS != I2S_CH5_FS_44100) && \
+		(I2S_CH5_256FS != I2S_CH5_FS_44100) && \
+		(I2S_CH5_384FS != I2S_CH5_FS_44100) && \
+		(I2S_CH5_512FS != I2S_CH5_FS_44100) && \
+		(I2S_CH5_768FS != I2S_CH5_FS_44100) && \
+		(I2S_CH5_1024FS != I2S_CH5_FS_44100)
+		#error IOH_I2S_CH5_CONFIG Error : \
+			Sampling frequency 44100Hz can not generate.
+	#endif
+#endif
+#ifdef	I2S_CH5_FS_48000
+	#if (I2S_CH5_64FS != I2S_CH5_FS_48000) && \
+		(I2S_CH5_128FS != I2S_CH5_FS_48000) && \
+		(I2S_CH5_192FS != I2S_CH5_FS_48000) && \
+		(I2S_CH5_256FS != I2S_CH5_FS_48000) && \
+		(I2S_CH5_384FS != I2S_CH5_FS_48000) && \
+		(I2S_CH5_512FS != I2S_CH5_FS_48000) && \
+		(I2S_CH5_768FS != I2S_CH5_FS_48000) && \
+		(I2S_CH5_1024FS != I2S_CH5_FS_48000)
+		#error IOH_I2S_CH5_CONFIG Error : \
+			Sampling frequency 48000Hz can not generate.
+	#endif
+#endif
+#endif	/* end of [#if (I2S_CH5_MSSEL == ioh_mssel_master)] */
+
+
+
+/* ######################################################################## */
+/* ###		Parameter Table Data					### */
+/* ######################################################################## */
+
+#define	I2SCLKCNT_MSSEL_OFFSET		(0)
+#define	I2SCLKCNT_BCLKPOL_OFFSET	(1)
+#define	I2SCLKCNT_MASTERCLKSEL_OFFSET	(2)
+#define	I2SCLKCNT_LRCKFMT_OFFSET	(4)
+#define	I2SCLKCNT_MCLKFS_OFFSET		(8)
+#define	I2SCLKCNT_BCLKFS_OFFSET		(12)
+
+#define	I2SCNT_DABIT_OFFSET		(8)
+
+#define	I2SCNTTX_TX_TEL_OFFSET		(0)
+#define	I2SCNTTX_TX_DLYOFF_OFFSET	(12)
+#define	I2SCNTTX_TX_LSB_OFFSET		(13)
+#define	I2SCNTTX_TX_LRPOL_OFFSET	(14)
+#define	I2SCNTTX_TX_AFT_OFFSET		(15)
+
+#define	I2SCNTRX_RX_TEL_OFFSET		(0)
+#define	I2SCNTRX_RX_DLYOFF_OFFSET	(12)
+#define	I2SCNTRX_RX_LSB_OFFSET		(13)
+#define	I2SCNTRX_RX_LRPOL_OFFSET	(14)
+#define	I2SCNTRX_RX_AFT_OFFSET		(15)
+
+
+#define	STEREO_OFFSET			0
+#define	MONAURAL_OFFSET			MAX_I2S_CH
+static const struct i2s_config_tab_t i2s_config_table[MAX_I2S_CH*2] = {
+	/* CH0 Stereo */
+	{
+		(I2S_CH0_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH0_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH0_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH0_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH0_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH0_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (I2S_CH0_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (I2S_CH0_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH0_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH0_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (I2S_CH0_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (I2S_CH0_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH0_MCLK,
+	},
+	/* CH1 Stereo */
+	{
+		(I2S_CH1_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH1_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH1_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH1_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH1_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH1_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (I2S_CH1_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (I2S_CH1_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH1_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH1_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (I2S_CH1_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (I2S_CH1_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH1_MCLK,
+	},
+	/* CH2 Stereo */
+	{
+		(I2S_CH2_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH2_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH2_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH2_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH2_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH2_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (I2S_CH2_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (I2S_CH2_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH2_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH2_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (I2S_CH2_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (I2S_CH2_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH2_MCLK,
+	},
+	/* CH3 Stereo */
+	{
+		(I2S_CH3_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH3_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH3_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH3_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH3_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH3_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (I2S_CH3_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (I2S_CH3_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH3_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH3_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (I2S_CH3_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (I2S_CH3_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH3_MCLK,
+	},
+	/* CH4 Stereo */
+	{
+		(I2S_CH4_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH4_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH4_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH4_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH4_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH4_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (I2S_CH4_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (I2S_CH4_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH4_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH4_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (I2S_CH4_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (I2S_CH4_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH4_MCLK,
+	},
+	/* CH5 Stereo */
+	{
+		(I2S_CH5_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH5_BCLKPOL_STEREO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH5_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH5_LRCKFMT_STEREO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH5_TX_DLYOFF_STEREO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH5_TX_LSB_STEREO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (I2S_CH5_TX_LRPOL_STEREO << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (I2S_CH5_TX_AFT_STEREO << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH5_RX_DLYOFF_STEREO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH5_RX_LSB_STEREO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (I2S_CH5_RX_LRPOL_STEREO << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (I2S_CH5_RX_AFT_STEREO << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH5_MCLK,
+	},
+
+
+	/* CH0 Mono */
+	{
+		(I2S_CH0_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH0_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH0_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH0_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH0_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH0_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH0_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH0_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH0_MCLK,
+	},
+	/* CH1 Mono */
+	{
+		(I2S_CH1_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH1_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH1_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH1_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH1_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH1_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH1_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH1_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH1_MCLK,
+	},
+	/* CH2 Mono */
+	{
+		(I2S_CH2_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH2_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH2_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH2_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH2_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH2_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH2_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH2_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH2_MCLK,
+	},
+	/* CH3 Mono */
+	{
+		(I2S_CH3_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH3_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH3_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH3_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH3_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH3_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH3_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH3_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH3_MCLK,
+	},
+	/* CH4 Mono */
+	{
+		(I2S_CH4_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH4_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH4_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH4_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH4_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH4_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH4_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH4_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH4_MCLK,
+	},
+	/* CH5 Mono */
+	{
+		(I2S_CH5_MSSEL << I2SCLKCNT_MSSEL_OFFSET) | \
+		  (I2S_CH5_BCLKPOL_MONO << I2SCLKCNT_BCLKPOL_OFFSET) | \
+		  (I2S_CH5_MASTERCLKSEL << I2SCLKCNT_MASTERCLKSEL_OFFSET) | \
+		  (I2S_CH5_LRCKFMT_MONO << I2SCLKCNT_LRCKFMT_OFFSET),
+
+		  (I2S_CH5_TX_DLYOFF_MONO << I2SCNTTX_TX_DLYOFF_OFFSET) | \
+		  (I2S_CH5_TX_LSB_MONO << I2SCNTTX_TX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTTX_TX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTTX_TX_AFT_OFFSET),
+
+		  (I2S_CH5_RX_DLYOFF_MONO << I2SCNTRX_RX_DLYOFF_OFFSET) | \
+		  (I2S_CH5_RX_LSB_MONO << I2SCNTRX_RX_LSB_OFFSET) | \
+		  (ioh_lrpol_no_invert << I2SCNTRX_RX_LRPOL_OFFSET) | \
+		  (ioh_aft_front << I2SCNTRX_RX_AFT_OFFSET),
+
+		I2S_CH5_MCLK,
+	},
+
+};
+
+
+#endif
diff --git a/sound/soc/lapis/ml7213ioh-plat.c b/sound/soc/lapis/ml7213ioh-plat.c
new file mode 100644
index 0000000..9093a43
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-plat.c
@@ -0,0 +1,2488 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/initval.h>
+
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+
+#include "ioh_i2s.h"
+#include "ioh_i2s_config.h"
+#include "ml7213ioh-plat.h"
+
+#define USE_PERIODS_MIN		(I2S_DMA_SG_MAX)
+#define USE_PERIODS_MAX		(I2S_DMA_SG_MAX)
+#ifndef add_capture_constraints
+#define add_capture_constraints(x) 0
+#endif
+
+#define	I2S_WRITE_MASTER_BIT	(0)
+#define	I2S_READ_MASTER_BIT	(8)
+
+#define	I2S_WRITE_ENABLE_BIT	(0)
+#define	I2S_READ_ENABLE_BIT	(8)
+
+/* RW flag */
+#define	SND_CAPTURE_SUBSTREAM	0
+#define	SND_PLAYBACK_SUBSTREAM	1
+
+/* Codec Device Address */
+
+#define	I2SCNTRX_RXTEL		BIT(0)
+#define I2SCNTRX_RXDABIT_8BIT	0
+#define I2SCNTRX_RXDABIT_14BIT	BIT(8)
+#define I2SCNTRX_RXDABIT_16BIT	BIT(9)
+#define I2SCNTRX_RXDABIT_18BIT	(BIT(8) | BIT(9))
+#define I2SCNTRX_RXDABIT_20BIT	BIT(10)
+#define I2SCNTRX_RXDABIT_24BIT	(BIT(8) | BIT(10))
+#define	I2SCNTRX_RXDLYOFF	BIT(12)
+#define	I2SCNTRX_RX_LSB		BIT(13)
+
+#define	I2SCNTTX_TXTEL		I2SCNTRX_RXTEL
+#define I2SCNTTX_TXDABIT_8BIT	I2SCNTRX_RXDABIT_8BIT
+#define I2SCNTTX_TXDABIT_14BIT	I2SCNTRX_RXDABIT_14BIT
+#define I2SCNTTX_TXDABIT_16BIT	I2SCNTRX_RXDABIT_16BIT
+#define I2SCNTTX_TXDABIT_18BIT	I2SCNTRX_RXDABIT_18BIT
+#define I2SCNTTX_TXDABIT_20BIT	I2SCNTRX_RXDABIT_20BIT
+#define I2SCNTTX_TXDABIT_24BIT	I2SCNTRX_RXDABIT_24BIT
+#define	I2SCNTTX_TXDLYOFF	I2SCNTRX_RXDLYOFF
+#define	I2SCNTTX_TX_LSB		I2SCNTRX_RX_LSB
+
+#define I2SCLKCNT_MCLKFS_64FS	0
+#define I2SCLKCNT_MCLKFS_128FS	BIT(8)
+#define I2SCLKCNT_MCLKFS_192FS	BIT(9)
+#define I2SCLKCNT_MCLKFS_256FS	(BIT(8) | BIT(9))
+#define I2SCLKCNT_MCLKFS_384FS	BIT(10)
+#define I2SCLKCNT_MCLKFS_512FS	(BIT(8) | BIT(10))
+#define I2SCLKCNT_MCLKFS_768FS	(BIT(9) | BIT(10))
+#define I2SCLKCNT_MCLKFS_1024FS	(BIT(8) | BIT(9) | BIT(10))
+
+#define I2SCLKCNT_BCLKFS_8FS	0
+#define I2SCLKCNT_BCLKFS_16FS	BIT(12)
+#define I2SCLKCNT_BCLKFS_32FS	BIT(13)
+#define I2SCLKCNT_BCLKFS_64FS	(BIT(12) | BIT(13))
+
+#define I2SCLKCNT_MSSEL		BIT(0)
+#define I2SCLKCNT_BCLKPOL	BIT(1)
+
+#define I2SCLKCNT_LRCKFMT_I2S	0
+#define I2SCLKCNT_LRCKFMT_LONG	BIT(5)
+#define I2SCLKCNT_LRCKFMT_SHORT	(BIT(4)|BIT(5))
+
+#define DRV_NAME "ml7213_ioh_i2s"
+#define PCI_VENDOR_ID_ROHM	0X10DB
+#define PCI_DEVICE_ID_ML7213_I2S	0X8033
+
+struct snd_ml7213i2s {
+	struct snd_card *card;
+	struct snd_pcm *pcm;
+	struct ioh_i2s_data_pci *pci_dat;
+};
+
+struct cbdata {
+	struct ioh_i2s_data *priv;
+	int stop;
+	int cnt;
+};
+
+struct snd_ml7213i2s_pcm {
+	unsigned int channels;
+	unsigned int rate;
+	unsigned int ch;
+	unsigned int format;
+	unsigned int bclkfs;
+};
+
+struct snd_ml7213i2s_dma {
+	unsigned int master_mode;
+	spinlock_t lock;
+	unsigned int irq_pos;
+	unsigned int buf_pos;
+	struct snd_pcm_substream *substream;
+	struct cbdata cbd;              /* i2s callback info */
+	unsigned int rw;
+};
+
+
+static struct snd_pcm_hardware snd_card_ml7213i2s_capture[MAX_I2S_CH] = {
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH0,
+		.rate_min =		USE_RATE_MIN_CH0,
+		.rate_max =		USE_RATE_MAX_CH0,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH1,
+		.rate_min =		USE_RATE_MIN_CH1,
+		.rate_max =		USE_RATE_MAX_CH1,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH2,
+		.rate_min =		USE_RATE_MIN_CH2,
+		.rate_max =		USE_RATE_MAX_CH2,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH3,
+		.rate_min =		USE_RATE_MIN_CH3,
+		.rate_max =		USE_RATE_MAX_CH3,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH4,
+		.rate_min =		USE_RATE_MIN_CH4,
+		.rate_max =		USE_RATE_MAX_CH4,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH5,
+		.rate_min =		USE_RATE_MIN_CH5,
+		.rate_max =		USE_RATE_MAX_CH5,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_RX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_RX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_RX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+};
+
+static struct snd_pcm_hardware snd_card_ml7213i2s_playback[MAX_I2S_CH] = {
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH0,
+		.rate_min =		USE_RATE_MIN_CH0,
+		.rate_max =		USE_RATE_MAX_CH0,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH1,
+		.rate_min =		USE_RATE_MIN_CH1,
+		.rate_max =		USE_RATE_MAX_CH1,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH2,
+		.rate_min =		USE_RATE_MIN_CH2,
+		.rate_max =		USE_RATE_MAX_CH2,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH3,
+		.rate_min =		USE_RATE_MIN_CH3,
+		.rate_max =		USE_RATE_MAX_CH3,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH4,
+		.rate_min =		USE_RATE_MIN_CH4,
+		.rate_max =		USE_RATE_MAX_CH4,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+	{
+		.info =			(SNDRV_PCM_INFO_MMAP |
+					 SNDRV_PCM_INFO_INTERLEAVED |
+					 SNDRV_PCM_INFO_RESUME |
+					 SNDRV_PCM_INFO_MMAP_VALID),
+		.formats =		SUPPORT_FORMAT,
+		.rates =		USE_RATE_CH5,
+		.rate_min =		USE_RATE_MIN_CH5,
+		.rate_max =		USE_RATE_MAX_CH5,
+		.channels_min =		USE_CHANNELS_MIN,
+		.channels_max =		USE_CHANNELS_MAX,
+		.buffer_bytes_max =	(MAX_PERIOD_SIZE_TX *
+					 USE_PERIODS_MAX),
+		.period_bytes_min =	MAX_PERIOD_SIZE_TX,
+		.period_bytes_max =	MAX_PERIOD_SIZE_TX,
+		.periods_min =		USE_PERIODS_MIN,
+		.periods_max =		USE_PERIODS_MAX,
+		.fifo_size =		0,
+	},
+};
+
+static struct ioh_i2s_dma dmadata[6];
+static int ignore_overrun = 1;
+static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
+module_param(ignore_overrun, int, 0444);
+module_param(index, int, 0444);
+MODULE_PARM_DESC(ignore_overrun, "ignore RX overruns (default=0)");
+MODULE_PARM_DESC(index, "Index value for ML7213 IOH I2S Controller Reference");
+
+/*****************************************************************************
+ *	I2S HAL (Hardware Abstruction Layer)
+ *****************************************************************************/
+static void ioh_i2s_reset(struct ioh_i2s_data *priv, int ch)
+{
+	iowrite32(1 << ch, priv->iobase + I2SSRST_OFFSET);
+	iowrite32(0, priv->iobase + I2SSRST_OFFSET);
+}
+
+static void ioh_i2s_enable_interrupts(struct ioh_i2s_data *priv,
+				      enum dma_data_direction dir)
+{
+	int channel = priv->ch;
+	unsigned int intr_lines;
+
+	if (dir)
+		intr_lines = 1 << (I2S_IMASK_RX_BIT_START + channel);
+
+	else
+		intr_lines = 1 << (I2S_IMASK_TX_BIT_START + channel);
+
+	/*enable interrupts for specified channel */
+	iowrite32(intr_lines, priv->iobase + I2SIMASKCLR_OFFSET);
+}
+
+static void ioh_i2s_disable_interrupts(struct ioh_i2s_data *priv,
+				       enum dma_data_direction dir)
+{
+	int channel = priv->ch;
+	unsigned int intr_lines;
+
+	/*intr_lines&=I2S_ALL_INTERRUPT_BITS; */
+	intr_lines = ioread32(priv->iobase + I2SIMASK_OFFSET);
+
+	/*disable interrupts for specified channel */
+	if (dir)
+		intr_lines |= 1 << (I2S_IMASK_RX_BIT_START + channel);
+	else
+		intr_lines |= 1 << (I2S_IMASK_TX_BIT_START + channel);
+
+	/*Mask the specific interrupt bits */
+	iowrite32(intr_lines, priv->iobase + I2SIMASK_OFFSET);
+}
+
+/* Run FIFO */
+static void ioh_i2s_run_tx_fifo(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SFIFOCTX_OFFSET + offset);
+	val |= I2S_FIFO_TX_RUN;
+
+	iowrite32(val, priv->iobase + I2SFIFOCTX_OFFSET + offset);
+}
+
+/* Clear TX FIFO */
+static void ioh_i2s_clear_tx_fifo(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SFIFOCTX_OFFSET + offset);
+	val |= I2S_FIFO_TX_FCLR;
+
+	iowrite32(val, priv->iobase + I2SFIFOCTX_OFFSET + offset);
+}
+
+/* Clear interrupt status */
+static void ioh_i2s_clear_tx_sts_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+
+	iowrite32(I2S_TX_FINT | I2S_TX_AFINT | I2S_TX_EINT | I2S_TX_AEINT,
+		priv->iobase + I2SISTTX_OFFSET + offset);
+}
+
+/* Run FIFO */
+static void ioh_i2s_run_rx_fifo(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SFIFOCRX_OFFSET + offset);
+	val |= I2S_FIFO_RX_RUN;
+	iowrite32(val, priv->iobase + I2SFIFOCRX_OFFSET + offset);
+}
+
+/* Clear RX FIFO */
+static void ioh_i2s_clear_rx_fifo(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SFIFOCRX_OFFSET + offset);
+	val |= I2S_FIFO_RX_FCLR;
+	iowrite32(val, priv->iobase + I2SFIFOCRX_OFFSET + offset);
+}
+
+/* Clear interrupt status */
+static void ioh_i2s_clear_rx_sts_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+
+	iowrite32(I2S_RX_FINT | I2S_RX_AFINT | I2S_RX_EINT | I2S_RX_AEINT,
+		priv->iobase + I2SISTRX_OFFSET + offset);
+}
+
+/* Clear DMA mask setting */
+static void ioh_i2s_tx_clear_dma_mask(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
+	val &= ~TX_BIT_DMAMSK; /* Enable Tx DMA Request */
+
+	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+/* Clear DMA mask setting */
+static void ioh_i2s_rx_clear_dma_mask(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);
+	val &= ~RX_BIT_DMAMSK; /* Enable Rx DMA Request */
+	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+/* Clear the mask setting of the corresponding interrupt source bit */
+static void ioh_i2s_enable_tx_empty_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
+	val &= ~TX_BIT_AEIMSK; /* Enable Almost empty interrupt */
+	val &= ~TX_BIT_EIMSK; /* Enable Empty interrupt */
+
+	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+/* Clear the mask setting of the corresponding interrupt source bit */
+static void ioh_i2s_enable_rx_full_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);
+
+	val &= ~RX_BIT_AFIMSK; /* Enable Almost empty interrupt */
+	val &= ~RX_BIT_FIMSK; /* Enable Empty interrupt */
+
+	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+static void ioh_i2s_disable_tx_empty_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKTX_OFFSET + offset);
+	val |= TX_BIT_AEIMSK; /* Disble Almost empty interrupt */
+	val |= TX_BIT_EIMSK; /* Disble Empty interrupt */
+
+	iowrite32(val, priv->iobase + I2SMSKTX_OFFSET + offset);
+}
+
+static void ioh_i2s_disable_rx_full_ir(struct ioh_i2s_data *priv)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+	u32 val;
+
+	val = ioread32(priv->iobase + I2SMSKRX_OFFSET + offset);
+	val |= RX_BIT_AFIMSK; /* Disble Almost full interrupt */
+	val |= RX_BIT_FIMSK; /* Disble full interrupt */
+
+	iowrite32(val, priv->iobase + I2SMSKRX_OFFSET + offset);
+}
+
+/*****************************************************************************
+ *	I2S Middle ware
+ *****************************************************************************/
+static bool filter(struct dma_chan *chan, void *slave)
+{
+	struct pch_dma_slave *param = slave;
+
+	if ((chan->chan_id == param->chan_id) && (param->dma_dev ==
+						  chan->device->dev)) {
+		chan->private = param;
+		return true;
+	} else {
+		return false;
+	}
+}
+
+static	struct dma_chan *ioh_request_dma_channel(
+			struct ioh_i2s_data *priv, struct ioh_i2s_dma *dma,
+			enum dma_data_direction dir)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+	struct pci_dev *dma_dev;
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	dma_dev = pci_get_bus_and_slot(2, PCI_DEVFN(0, 1)); /* Get DMA's dev
+								information */
+
+	if (dir == DMA_FROM_DEVICE) { /* Rx */
+		dma->param_rx.width = dma->dma_rx_width;
+		dma->param_rx.dma_dev = &dma_dev->dev;
+		dma->param_rx.chan_id = priv->ch * 2 + 1; /* ch Rx=1,3,...11 */
+		dma->param_rx.rx_reg = (dma_addr_t)(priv->mapbase +\
+					priv->ch * 0x800 +\
+					I2SDRRXMIRROR_OFFSET);
+		chan = dma_request_channel(mask, filter, &dma->param_rx);
+		if (chan == NULL) {
+			dev_err(priv->dev, "Failed dma_request_channel %s for"
+				" I2S %d\n", dma->dma_config->rx_chan, priv->ch);
+			return NULL;
+		}
+		dma->chan_rx = chan;
+
+	} else if (dir == DMA_TO_DEVICE) { /* Tx */
+		dma->param_tx.width = dma->dma_tx_width;
+		dma->param_tx.dma_dev = &dma_dev->dev;
+		dma->param_tx.chan_id = priv->ch * 2; /* DMA ch Tx=0,2,...10 */
+
+		dma->param_tx.tx_reg = (dma_addr_t)(priv->mapbase +\
+					priv->ch * 0x800 +\
+					I2SDRTXMIRROR_OFFSET);
+
+		dma->param_tx.tx_reg_list = NULL;
+
+		chan = dma_request_channel(mask, filter, &dma->param_tx);
+		if (chan == NULL) {
+			dev_err(priv->dev, "Failed dma_request_channel %s for"
+				" I2S %d\n", dma->dma_config->tx_chan, priv->ch);
+			return NULL;
+		}
+		dma->chan_tx = chan;
+	} else {
+		dev_err(priv->dev, "Invalid direction (%d)\n", dir);
+		return NULL;
+	}
+
+	return chan;
+}
+
+static void ioh_i2s_ignore_rx_overrun(struct ioh_i2s_data *priv)
+{
+	priv->ignore_rx_overrun = 1;
+}
+
+static void ioh_i2s_write(struct ioh_i2s_data *priv,
+		       const void *data,
+		       int len)
+{
+	int rem1;
+	int rem2;
+	int tx_index;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	struct scatterlist *sg = dma->sg_tx_p;
+	int t_num = 0;
+	int l;
+	int *ptr_fmt;
+	int *ptr32;
+	short *ptr16;
+	char *ptr8;
+	int tx_unit = dmadata[priv->ch].dma_tx_unit;
+
+	if (dma->tx_avail >= INTER_BUFF_SIZE) {
+		dev_err(priv->dev, "%s[%d]: internal buffer full\n",
+			__func__, priv->ch);
+		return;
+	}
+
+	dev_dbg(priv->dev, "%s: [ch%d] len=%d data_head=%p data_complete=%p",
+		__func__, priv->ch, len, dma->tx_data_head, dma->tx_complete);
+
+	if ((dma->tx_data_head + ((len/tx_unit)*4)) <=
+	    dma->tx_tail) {
+		tx_index = (int)(dma->tx_data_head - dma->tx_head) /
+				(I2S_AEMPTY_THRESH * 4);
+		sg = sg + tx_index;
+		t_num = len/(I2S_AEMPTY_THRESH * tx_unit);
+		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_TO_DEVICE);
+
+		ptr_fmt = (int *)dma->tx_data_head;
+		switch (tx_unit) {
+		case 1:
+			ptr8 = (char *)data;
+			for (l = 0; l < (len/tx_unit); l++)
+				*ptr_fmt++ = (int)*ptr8++;
+			break;
+		case 2:
+			ptr16 = (short *)data;
+			for (l = 0; l < (len/tx_unit); l++)
+				*ptr_fmt++ = (int)*ptr16++;
+			break;
+		case 4:
+			ptr32 = (int *)data;
+			for (l = 0; l < (len/tx_unit); l++)
+				*ptr_fmt++ = *ptr32++;
+			break;
+		}
+		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_TO_DEVICE);
+		dma->tx_data_head += (len/tx_unit)*4;
+	} else {
+		rem1 = (dma->tx_tail - dma->tx_data_head)/4;
+		rem2 = (len/tx_unit) - rem1;
+		tx_index = (int)(dma->tx_data_head-dma->tx_head) /
+				(I2S_AEMPTY_THRESH * 4);
+		sg = sg + tx_index;
+		t_num = rem1/I2S_AEMPTY_THRESH;
+		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_TO_DEVICE);
+		ptr_fmt = (int *)dma->tx_data_head;
+		switch (tx_unit) {
+		case 1:
+			ptr8 = (char *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr_fmt++ = (int)*ptr8++;
+			break;
+		case 2:
+			ptr16 = (short *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr_fmt++ = (int)*ptr16++;
+			break;
+		case 4:
+			ptr32 = (int *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr_fmt++ = *ptr32++;
+			break;
+		}
+
+		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_TO_DEVICE);
+		dma->tx_data_head = dma->tx_head;
+		sg = dma->sg_tx_p;
+		t_num = rem2/I2S_AEMPTY_THRESH;
+		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_TO_DEVICE);
+
+		ptr_fmt = (int *)dma->tx_data_head;
+
+		switch (tx_unit) {
+		case 1:
+			ptr8 = (char *)(data+rem1*tx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr_fmt++ = (int)*ptr8++;
+			break;
+		case 2:
+			ptr16 = (short *)(data+rem1*tx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr_fmt++ = (int)*ptr16++;
+			break;
+		case 4:
+			ptr32 = (int *)(data+rem1*tx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr_fmt++ = *ptr32++;
+			break;
+		}
+
+		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_TO_DEVICE);
+		dma->tx_data_head += rem2*4;
+	}
+
+	if (dma->tx_data_head >= dma->tx_tail)
+		dma->tx_data_head = dma->tx_head;
+
+	dev_dbg(priv->dev, "-->data_head=%p\n", dma->tx_data_head);
+
+	dma->tx_avail += (len/tx_unit)*4;
+}
+
+static void ioh_i2s_stop_i2s_regs(struct ioh_i2s_data *priv,
+			       unsigned long bitrate,
+			       struct ioh_i2s_config_reg *config,
+			       enum ioh_direction dir,
+			       unsigned int flag)
+{
+	int ch = priv->ch;
+
+	if (dir) {
+		/* Interrupt stop */
+		ioh_i2s_disable_rx_full_ir(priv);
+
+		/* FIFO setting */
+		ioh_i2s_clear_rx_fifo(priv);
+		ioh_i2s_clear_rx_sts_ir(priv);
+	} else {
+		/* Interrupt stop */
+		ioh_i2s_disable_tx_empty_ir(priv);
+
+		/* FIFO setting */
+		ioh_i2s_clear_tx_fifo(priv);
+		ioh_i2s_clear_tx_sts_ir(priv);
+	}
+
+	/* Common register */
+	if (!flag) {
+		iowrite32(config->cmn.i2sclkcnt,
+			  priv->iobase + I2SCLKCNT0_OFFSET + 0x10*ch);
+	}
+}
+
+static void ioh_i2s_configure_i2s_regs(struct ioh_i2s_data *priv,
+				    unsigned long bitrate,
+				    struct ioh_i2s_config_reg *config,
+				    enum ioh_direction dir,
+				    unsigned int unit)
+{
+	int ch = priv->ch;
+	int offset = ch * 0x800;
+
+	/* Common register */
+	iowrite32(config->cmn.i2sclkcnt,
+		  priv->iobase + I2SCLKCNT0_OFFSET + 0x10*ch);
+
+	if (dir) {
+		dmadata[ch].dma_rx_unit = unit;
+		/* Rx register */
+		iowrite32(config->rx.i2scntrx,
+			  priv->iobase + I2SCNTRX_OFFSET + offset);
+		iowrite32(config->rx.i2sfifocrx,
+			  priv->iobase + I2SFIFOCRX_OFFSET + offset);
+		iowrite32(config->rx.i2safrx,
+			  priv->iobase + I2SAFRX_OFFSET + offset);
+		iowrite32(config->rx.i2saerx,
+			  priv->iobase + I2SAERX_OFFSET + offset);
+		iowrite32(config->rx.i2smskrx,
+			  priv->iobase + I2SMSKRX_OFFSET + offset);
+		iowrite32(config->rx.i2sistrx,
+			  priv->iobase + I2SISTRX_OFFSET + offset);
+
+		/* FIFO setting */
+		ioh_i2s_clear_rx_fifo(priv);
+		ioh_i2s_run_rx_fifo(priv);
+
+		/* Interrupt setting */
+		ioh_i2s_clear_rx_sts_ir(priv);
+		ioh_i2s_enable_rx_full_ir(priv);
+
+	} else {
+		dmadata[ch].dma_tx_unit = unit;
+		/* Tx register */
+		iowrite32(config->tx.i2scnttx,
+			  priv->iobase + I2SCNTTX_OFFSET + offset);
+		iowrite32(config->tx.i2sfifoctx,
+			  priv->iobase + I2SFIFOCTX_OFFSET + offset);
+		iowrite32(config->tx.i2saftx,
+			  priv->iobase + I2SAFTX_OFFSET + offset);
+		iowrite32(config->tx.i2saetx,
+			  priv->iobase + I2SAETX_OFFSET + offset);
+		iowrite32(config->tx.i2smsktx,
+			  priv->iobase + I2SMSKTX_OFFSET + offset);
+		iowrite32(config->tx.i2sisttx,
+			  priv->iobase + I2SISTTX_OFFSET + offset);
+
+		/* FIFO setting */
+		ioh_i2s_clear_tx_fifo(priv);
+		ioh_i2s_run_tx_fifo(priv);
+
+		/* Interrupt setting */
+		ioh_i2s_clear_tx_sts_ir(priv);
+		ioh_i2s_enable_tx_empty_ir(priv);
+	}
+}
+
+static void i2s_rx_tasklet(unsigned long data)
+{
+	struct ioh_i2s_data *priv = (struct ioh_i2s_data *)data;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	int num = 0;
+
+	if (dma->rxexe_flag) {
+		if (dma->rx_done) {
+			switch (dma->dma_rx_unit) {
+			case 1:
+				num = dma->rx_avail/4;
+				break;
+			case 2:
+				num = dma->rx_avail/2;
+				break;
+			case 4:
+				num = dma->rx_avail;
+				break;
+			}
+			dma->rx_done(dma->rx_callback_data,
+				      IOH_EOK, num, num);
+		}
+	}
+}
+
+static void i2s_tx_tasklet(unsigned long data)
+{
+	struct ioh_i2s_data *priv = (struct ioh_i2s_data *)data;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	int num = 0;
+	int avail = 0;
+
+	if (dma->txexe_flag) {
+		if (dma->tx_done) {
+			switch (dmadata[priv->ch].dma_tx_unit) {
+			case 1:
+				num = (INTER_BUFF_SIZE - dma->tx_avail)/4;
+				avail = dma->tx_avail/4;
+				break;
+			case 2:
+				num = (INTER_BUFF_SIZE - dma->tx_avail)/2;
+				avail = dma->tx_avail/2;
+				break;
+			case 4:
+				num = (INTER_BUFF_SIZE - dma->tx_avail);
+				avail = dma->tx_avail;
+				break;
+			}
+			dma->tx_done(dma->tx_callback_data,
+				      IOH_EOK, num, avail);
+		}
+	}
+}
+
+static void ioh_i2s_release(struct ioh_i2s_data *priv, enum ioh_direction dir)
+{
+	struct ioh_i2s_dma *dma;
+
+	if (!priv) {
+		dev_err(priv->dev, "%s: i2s is NULL\n", __func__);
+		return;
+	}
+
+	dma = &dmadata[priv->ch];
+	if (dir) {
+		dma_sync_sg_for_cpu(priv->dev, dma->sg_rx_p, dma->rx_nent,
+				    DMA_FROM_DEVICE);
+
+		ioh_i2s_disable_interrupts(priv, IOH_CAPTURE);
+		ioh_i2s_disable_rx_full_ir(priv);
+		if (dma->chan_rx) {
+			dma->chan_rx->device->device_control(dma->chan_rx,
+							     DMA_TERMINATE_ALL,
+							     0);
+			dma_release_channel(dma->chan_rx);
+			dma->chan_rx = NULL;
+		}
+
+		kfree(dma->sg_rx_p);
+		if (dma->rxbuf_virt)
+			dma_free_coherent(priv->dev, INTER_BUFF_SIZE,
+					  dma->rxbuf_virt,
+					  dma->rx_buf_dma);
+
+		dma->rxbuf_virt = NULL;
+		dma->rx_buf_dma = 0;
+		atomic_dec(&dma->rx_busy);
+
+		tasklet_disable(&dma->rx_tasklet);
+		tasklet_kill(&dma->rx_tasklet);
+
+	} else {
+		dma_sync_sg_for_cpu(priv->dev, dma->sg_tx_p, dma->tx_nent,
+				    DMA_TO_DEVICE);
+
+		ioh_i2s_disable_interrupts(priv, IOH_PLAYBACK);
+		ioh_i2s_disable_tx_empty_ir(priv);
+		if (dma->chan_tx) {
+			dma->chan_tx->device->device_control(dma->chan_tx,
+							     DMA_TERMINATE_ALL,
+							     0);
+			dma_release_channel(dma->chan_tx);
+			dma->chan_tx = NULL;
+		}
+
+		kfree(dma->sg_tx_p);
+		if (dma->txbuf_virt)
+			dma_free_coherent(priv->dev, INTER_BUFF_SIZE,
+					  dma->txbuf_virt,
+					  dma->tx_buf_dma);
+
+		dma->txbuf_virt = NULL;
+		dma->tx_buf_dma = 0;
+		atomic_dec(&dma->tx_busy);
+
+		tasklet_disable(&dma->tx_tasklet);
+		tasklet_kill(&dma->tx_tasklet);
+	}
+}
+
+static struct ioh_i2s_data *ioh_i2s_open(int ch, enum ioh_direction dir,
+				     const char *name)
+{
+	struct ioh_i2s_data *obj = NULL;
+	struct scatterlist *sg;
+	int rx_size;
+	int rx_num;
+	int tx_size;
+	int tx_num;
+	int i;
+	struct ioh_i2s_dma *dma;
+
+	if (ch >= MAX_I2S_IF) {
+		dev_err(obj->dev,
+			"Tried to open i2s with number %d which is more then"
+			" the available number\n", ch);
+		return 0;
+	}
+
+	dma = &dmadata[ch];
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	obj->ignore_rx_overrun = 0;
+	obj->ch = ch;
+
+	atomic_set(&dma->rx_busy, 0);
+	atomic_set(&dma->tx_busy, 0);
+
+	dma->dma_tx_width = PCH_DMA_WIDTH_4_BYTES;
+	dma->dma_rx_width = PCH_DMA_WIDTH_4_BYTES;
+
+	if (dir) {
+		/* Rx configuration */
+		if (atomic_read(&dma->rx_busy)) {
+			dev_err(obj->dev, "rx i2s%d have already opened\n", ch);
+			atomic_dec(&dma->rx_busy);
+			return 0;
+		}
+		atomic_inc(&dma->rx_busy);
+
+		ioh_request_dma_channel(obj, dma, DMA_FROM_DEVICE);
+		if (!dma->chan_rx) {
+			dev_err(obj->dev, "%s:ioh_setup_rx_dma failed\n",
+				__func__);
+			return NULL;
+		}
+
+		dma->rxbuf_virt = dma_alloc_coherent(obj->dev, INTER_BUFF_SIZE,
+						&dma->rx_buf_dma, GFP_KERNEL);
+		if (!dma->rxbuf_virt) {
+			dev_err(obj->dev, "dma_alloc_coherent Failed\n");
+			return NULL;
+		}
+
+		rx_size = I2S_AFULL_THRESH * 4;
+		/* The number of scatter list (Franction area is not used) */
+		rx_num = INTER_BUFF_SIZE / rx_size;
+
+		dev_dbg(obj->dev, "%s: rx: scatter_num=%d scatter_size=%d\n",
+			__func__, rx_num, rx_size);
+
+		dma->sg_rx_p =\
+		       kzalloc(sizeof(struct scatterlist) *rx_num, GFP_ATOMIC);
+
+		sg = dma->sg_rx_p;
+		sg_init_table(sg, rx_num); /* Initialize SG table */
+
+		for (i = 0; i < rx_num; i++, sg++) {
+			sg_set_page(sg, virt_to_page(dma->rxbuf_virt), rx_size,
+				    rx_size * i);
+			sg_dma_len(sg) = rx_size / 4;
+			sg_dma_address(sg) = dma->rx_buf_dma + sg->offset;
+		}
+
+		dma->rx_head = (unsigned char *)dma->rxbuf_virt;
+		dma->rx_tail = (unsigned char *)dma->rxbuf_virt +
+			       rx_num * rx_size;
+		dma->rx_data_head = (unsigned char *)dma->rxbuf_virt;
+		dma->rx_complete = (unsigned char *)dma->rxbuf_virt;
+		dma->rx_avail = 0;
+
+		dma->rx_nent = rx_num;
+		dma_sync_sg_for_device(obj->dev, dma->sg_rx_p, dma->rx_nent,
+				       DMA_FROM_DEVICE);
+
+		tasklet_init(&dma->rx_tasklet, i2s_rx_tasklet,
+			     (unsigned long)obj);
+	} else {
+		/* Tx configuration */
+		if (atomic_read(&dma->tx_busy)) {
+			dev_err(obj->dev, "tx i2s%d have already opened\n", ch);
+			atomic_dec(&dma->tx_busy);
+			return 0;
+		}
+		atomic_inc(&dma->tx_busy);
+
+		ioh_request_dma_channel(obj, dma, DMA_TO_DEVICE);
+
+		if (!dma->chan_tx) {
+			dev_err(obj->dev, "%s:ioh_setup_tx_dma failed\n",
+				__func__);
+			return NULL;
+		}
+
+		tx_size = I2S_AEMPTY_THRESH * 4;
+		if (INTER_BUFF_SIZE % tx_size)
+			/* tx_num = The number of scatter list */
+			tx_num = INTER_BUFF_SIZE / tx_size + 1;
+		else
+			tx_num = INTER_BUFF_SIZE / tx_size;
+
+		dma->txbuf_virt = dma_alloc_coherent(obj->dev, INTER_BUFF_SIZE,
+						&dma->tx_buf_dma, GFP_KERNEL);
+
+		if (!dma->txbuf_virt) {
+			dev_err(obj->dev, "dma_alloc_coherent Failed\n");
+			return NULL;
+		}
+
+		dma->tx_head = (unsigned char *)dma->txbuf_virt;
+		dma->tx_tail = (unsigned char *)dma->txbuf_virt +
+			       INTER_BUFF_SIZE;
+		dma->tx_data_head = (unsigned char *)dma->txbuf_virt;
+		dma->tx_complete = (unsigned char *)dma->txbuf_virt;
+		dma->tx_avail = 0;
+
+		dev_dbg(obj->dev, "%s: tx: scatter_num=%d scatter_size=%d\n",
+			__func__, tx_num, tx_size);
+
+		dma->sg_tx_p =\
+		       kzalloc(sizeof(struct scatterlist) *tx_num, GFP_ATOMIC);
+
+		sg_init_table(dma->sg_tx_p, tx_num); /* Initialize SG table */
+		sg = dma->sg_tx_p;
+
+		for (i = 0; i < tx_num; i++, sg++) {
+			if (i == (tx_num - 1)) {
+				if (INTER_BUFF_SIZE % tx_size) {
+					sg_set_page(sg,
+						  virt_to_page(dma->txbuf_virt),
+						  INTER_BUFF_SIZE % tx_size,
+						  tx_size * i);
+					sg_dma_len(sg) =
+						  (INTER_BUFF_SIZE % tx_size)
+						  / 4;
+				} else {
+					sg_set_page(sg,
+						  virt_to_page(dma->txbuf_virt),
+						  tx_size, tx_size * i);
+					sg_dma_len(sg) = tx_size\
+							/ 4;
+				}
+			} else {
+				sg_set_page(sg, virt_to_page(dma->txbuf_virt),
+					    tx_size, tx_size * i);
+				sg_dma_len(sg) = tx_size / 4;
+			}
+			sg_dma_address(sg) = dma->tx_buf_dma + sg->offset;
+		}
+		dma->tx_nent = tx_num;
+		dma_sync_sg_for_device(obj->dev, dma->sg_tx_p, dma->tx_nent,
+				       DMA_TO_DEVICE);
+
+		tasklet_init(&dma->tx_tasklet, i2s_tx_tasklet,
+			     (unsigned long)obj);
+	}
+
+	return obj;
+}
+
+static void ioh_i2s_read(struct ioh_i2s_data *priv,
+		      void *data,
+		      int len)
+{
+	unsigned int rem1 = 0, rem2 = 0;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	struct scatterlist *sg = dma->sg_rx_p;
+	int rx_index;
+	int t_num = 0;
+	int *ptr_fmt;
+	int *ptr32;
+	short *ptr16;
+	char *ptr8;
+	int l;
+	int rx_unit = dma->dma_rx_unit;
+
+	switch (rx_unit) {
+	case 1:
+		t_num = dma->rx_avail/4;
+		break;
+	case 2:
+		t_num = dma->rx_avail/2;
+		break;
+	case 4:
+		t_num = dma->rx_avail;
+		break;
+	}
+
+	if (t_num < len) {
+		dev_err(priv->dev, "%s[%d]: internal buffer empty\n",
+			__func__, priv->ch);
+		return;
+	}
+
+	if ((dma->rx_complete + ((len/rx_unit)*4)) <=
+	    dma->rx_tail) {
+		rx_index = (int)(dma->rx_complete - dma->rx_head) /
+				(I2S_AFULL_THRESH * 4);
+		sg = sg + rx_index;
+		t_num = len/(I2S_AFULL_THRESH * rx_unit);
+		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_FROM_DEVICE);
+
+		ptr_fmt = (int *)dma->rx_complete;
+		switch (rx_unit) {
+		case 1:
+			ptr8 = (char *)data;
+			for (l = 0; l < (len/rx_unit); l++)
+				*ptr8++ = (char)*ptr_fmt++;
+			break;
+		case 2:
+			ptr16 = (short *)data;
+			for (l = 0; l < (len/rx_unit); l++)
+				*ptr16++ = (short)*ptr_fmt++;
+			break;
+		case 4:
+			ptr32 = (int *)data;
+			for (l = 0; l < (len/rx_unit); l++)
+				*ptr32++ = *ptr_fmt++;
+			break;
+		}
+		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_FROM_DEVICE);
+		dma->rx_complete += (len/rx_unit)*4;
+	} else {
+		rem1 = (dma->rx_tail - dma->rx_complete)/4;
+		rem2 = (len/rx_unit) - rem1;
+		rx_index = (int)(dma->rx_complete-dma->rx_head) /
+				(I2S_AFULL_THRESH * 4);
+		sg = sg + rx_index;
+		t_num = rem1/I2S_AFULL_THRESH;
+		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_FROM_DEVICE);
+		ptr_fmt = (int *)dma->rx_complete;
+		switch (rx_unit) {
+		case 1:
+			ptr8 = (char *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr8++ = (char)*ptr_fmt++;
+			break;
+		case 2:
+			ptr16 = (short *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr16++ = (short)*ptr_fmt++;
+			break;
+		case 4:
+			ptr32 = (int *)data;
+			for (l = 0; l < rem1; l++)
+				*ptr32++ = *ptr_fmt++;
+			break;
+		}
+		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_FROM_DEVICE);
+		dma->rx_complete = dma->rx_head;
+		sg = dma->sg_rx_p;
+		t_num = rem2/I2S_AFULL_THRESH;
+		dma_sync_sg_for_cpu(priv->dev, sg, t_num, DMA_FROM_DEVICE);
+		ptr_fmt = (int *)dma->rx_complete;
+		switch (rx_unit) {
+		case 1:
+			ptr8 = (char *)(data+rem1*rx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr8++ = (char)*ptr_fmt++;
+			break;
+		case 2:
+			ptr16 = (short *)(data+rem1*rx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr16++ = (short)*ptr_fmt++;
+			break;
+		case 4:
+			ptr32 = (int *)(data+rem1*rx_unit);
+			for (l = 0; l < rem2; l++)
+				*ptr32++ = *ptr_fmt++;
+			break;
+		}
+		dma_sync_sg_for_device(priv->dev, sg, t_num, DMA_FROM_DEVICE);
+		dma->rx_complete += rem2*4;
+	}
+
+	if (dma->rx_complete >= dma->rx_tail)
+		dma->rx_complete = dma->rx_head;
+
+	dma->rx_avail -= (len/rx_unit)*4;
+}
+
+static void i2s_dma_rx_complete(void *arg)
+{
+	struct ioh_i2s_data *priv = arg;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	struct scatterlist *sg = dma->sg_rx_cur;
+	int num = dma->rx_num;
+	int i;
+
+	async_tx_ack(dma->desc_rx);
+
+	for (i = 0; i < num; i++, sg++) {
+		dma->rx_data_head += sg_dma_len(sg) * 4;
+		dma->rx_avail += sg_dma_len(sg) * 4;
+	}
+
+	if (dma->rx_data_head >= dma->rx_tail)
+		dma->rx_data_head = dma->rx_head;
+
+	ioh_i2s_clear_rx_sts_ir(priv);
+	ioh_i2s_enable_rx_full_ir(priv);
+}
+
+static void i2s_dma_tx_complete(void *arg)
+{
+	struct ioh_i2s_data *priv = arg;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	struct scatterlist *sg = dma->sg_tx_cur;
+	int num = dma->tx_num;
+	int i;
+
+	async_tx_ack(dma->desc_tx);
+
+	for (i = 0; i < num; i++, sg++) {
+		dma->tx_complete += sg_dma_len(sg) * 4;
+		dma->tx_avail -= sg_dma_len(sg) * 4;
+	}
+
+	if (dma->tx_complete >= dma->tx_tail)
+		dma->tx_complete = dma->tx_head;
+	ioh_i2s_clear_tx_sts_ir(priv);
+	ioh_i2s_enable_tx_empty_ir(priv);
+}
+
+/*****************************************************************************
+ *	Interrupt control
+ *****************************************************************************/
+static void i2s_tx_almost_empty_ir(struct ioh_i2s_data *priv)
+{
+	struct dma_async_tx_descriptor *desc;
+	int num;
+	int tx_comp_index;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+	struct scatterlist *sg = dma->sg_tx_p;
+
+	dev_dbg(priv->dev, "%s: data_head=%p data_complete=%p\n", __func__,
+		dma->tx_data_head, dma->tx_complete);
+
+	num = ((int)dma->tx_avail) / (I2S_AEMPTY_THRESH * 4);
+
+	tx_comp_index = (((int)(dma->tx_complete - dma->tx_head))) /\
+			(I2S_AEMPTY_THRESH * 4);
+
+	if ((tx_comp_index + num) >= dma->tx_nent)
+		num = dma->tx_nent - tx_comp_index;
+
+	if (num > I2S_DMA_SG_NUM)
+		num = I2S_DMA_SG_NUM;
+
+	if (!num) {
+		dev_err(priv->dev, "%s:Internal buffer empty\n",
+			__func__);
+		tasklet_schedule(&dma->tx_tasklet);
+		return; /* No data to transmit */
+	}
+
+	sg = sg + tx_comp_index; /* Point head of sg must be sent */
+	dma->sg_tx_cur = sg; /* Save tx condition */
+	dma->tx_num = num; /* Save tx condition */
+
+	desc = dma->chan_tx->device->device_prep_slave_sg(dma->chan_tx,
+					sg, num, DMA_TO_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+
+	if (!desc) {
+		dev_err(priv->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+
+	/* To prevent this function from calling again before DMA completion */
+	ioh_i2s_disable_tx_empty_ir(priv);
+
+	dma->desc_tx = desc;
+	desc->callback = i2s_dma_tx_complete;
+	desc->callback_param = priv;
+
+	atomic_inc(&dma->pending_tx);
+	desc->tx_submit(desc);
+
+	tasklet_schedule(&dma->tx_tasklet);
+}
+
+void i2s_tx_empty_ir(struct ioh_i2s_data *priv, int ch)
+{
+	dev_warn(priv->dev, "%s:I2S under flow occurs(ch=%d)\n", __func__, ch);
+}
+
+void i2s_rx_full_ir(struct ioh_i2s_data *priv, int ch)
+{
+	dev_warn(priv->dev, "%s:I2S overrun occurs(ch=%d)\n", __func__, ch);
+}
+
+static inline void ioh_i2s_interrupt_sub_tx(struct ioh_i2s_data *priv)
+{
+	unsigned int status;
+	int channel = priv->ch;
+	int offset = channel * 0x800;
+
+	status = ioread32(priv->iobase + I2SISTTX_OFFSET + offset);
+	if (status & I2S_TX_EINT)
+		i2s_tx_empty_ir(priv, channel);
+	if (status & I2S_TX_AEINT)
+		i2s_tx_almost_empty_ir(priv);
+
+	/*Clear the interrupt status */
+	iowrite32(status, priv->iobase + I2SISTTX_OFFSET + offset);
+}
+
+static void i2s_rx_almost_full_ir(struct ioh_i2s_data *priv)
+{
+	struct dma_async_tx_descriptor *desc;
+	struct scatterlist *sg;
+	int rx_data_index;
+	int num;
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+
+	num = (int)(INTER_BUFF_SIZE - dma->rx_avail) / (I2S_AFULL_THRESH * 4);
+	if (num < 1) {
+		dev_err(priv->dev, "%s:Internal buffer full\n",
+			__func__);
+		tasklet_schedule(&dma->rx_tasklet);
+		return;
+	}
+
+	sg = dma->sg_rx_p;
+	rx_data_index = ((int)(dma->rx_data_head - dma->rx_head)) /\
+			(I2S_AFULL_THRESH * 4);
+
+	if ((rx_data_index + num) >= dma->rx_nent)
+		num = dma->rx_nent - rx_data_index;
+
+	if (num > I2S_DMA_SG_NUM)
+		num = I2S_DMA_SG_NUM;
+
+	sg += rx_data_index;
+
+	desc = dma->chan_rx->device->device_prep_slave_sg(dma->chan_rx,
+			sg, num, DMA_FROM_DEVICE,
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(priv->dev, "%s:device_prep_slave_sg Failed\n",
+			__func__);
+		return;
+	}
+
+	dma->sg_rx_cur = sg; /* Save rx condition */
+	ioh_i2s_disable_rx_full_ir(priv);
+	dma->rx_num = num;
+
+	dma->desc_rx = desc;
+	desc->callback = i2s_dma_rx_complete;
+	desc->callback_param = priv;
+	desc->tx_submit(desc);
+
+	tasklet_schedule(&dma->rx_tasklet);
+}
+
+static inline void ioh_i2s_interrupt_sub_rx(struct ioh_i2s_data *priv)
+{
+	unsigned int status;
+	int channel = priv->ch;
+	int offset = channel * 0x800;
+
+	status = ioread32(priv->iobase + I2SISTRX_OFFSET + offset);
+	if (status & I2S_RX_FINT)
+		i2s_rx_full_ir(priv, channel);
+	if (status & I2S_RX_AFINT)
+		i2s_rx_almost_full_ir(priv);
+
+	/*Clear the interrupt status */
+	iowrite32(status, priv->iobase + I2SISTRX_OFFSET + offset);
+}
+
+void ioh_i2s_event(struct ioh_i2s_data *priv, u32 idisp, int ch)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->tx_lock, flags);
+
+	if (idisp & BIT(ch + 16)) {
+		dev_dbg(priv->dev, "Rx%d interrupt occures\n", ch);
+		ioh_i2s_interrupt_sub_rx(priv);
+	}
+
+	if (idisp & BIT(ch)) {
+		dev_dbg(priv->dev, "Tx%d interrupt occures\n", ch);
+		ioh_i2s_interrupt_sub_tx(priv);
+	}
+
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
+	return;
+}
+
+static irqreturn_t ioh_i2s_irq(int irq, void *data)
+{
+	struct pci_dev *pdev = (struct pci_dev *)data;
+	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
+	int i;
+	u32 idisp;
+
+	idisp = ioread32(drvdata->devs.iobase + I2SIDISP_OFFSET);
+	for (i = 0; i < MAX_I2S_IF; i++)
+		ioh_i2s_event(&drvdata->devs, idisp, i);
+
+	return IRQ_HANDLED;
+}
+
+/*****************************************************************************
+ *	Sound Card
+ *****************************************************************************/
+static void i2s_read_period(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_dma *dma;
+	struct cbdata *cbd;
+	int period;
+	void *read_ptr;
+	int read_size;
+
+	dma = substream->runtime->private_data;
+	cbd = &dma->cbd;
+
+	if (!cbd->priv)
+		return;
+
+	period = substream->runtime->period_size;
+
+	read_ptr = substream->runtime->dma_area
+	  +(snd_pcm_lib_period_bytes(substream) * dma->irq_pos);
+	read_size = period * (substream->runtime->sample_bits/8) *
+		    (substream->runtime->channels);
+
+	ioh_i2s_read(cbd->priv,
+			 read_ptr,
+			 read_size);
+
+	dma->irq_pos = (dma->irq_pos + 1) % substream->runtime->periods;
+}
+
+static void read_done(void *callback_data, int status, int num, int avail)
+{
+	struct snd_pcm_substream *substream =
+		(struct snd_pcm_substream *)callback_data;
+	struct snd_ml7213i2s_dma *dma;
+	struct cbdata *cbd;
+	dma = substream->runtime->private_data;
+
+	if (num < snd_card_ml7213i2s_capture[substream->number].period_bytes_max)
+		return;
+
+	cbd = &dma->cbd;
+	switch (status) {
+	case IOH_EOK:
+		if (!cbd->stop) {
+			i2s_read_period(substream);
+			dma->buf_pos = (dma->buf_pos + 1) %
+				substream->runtime->periods;
+			snd_pcm_period_elapsed(substream);
+		}
+
+		cbd->cnt++;
+		break;
+	case IOH_EDONE:
+		pr_debug("Done stopping channel %d\n", cbd->stop);
+		cbd->stop = 2;
+		break;
+
+	case IOH_EOVERRUN:
+		if (ignore_overrun)
+			pr_debug("overrun ignore\n");
+		else {
+			pr_err("RX overrun\n");
+			cbd->stop = 2;
+		}
+		break;
+
+	case IOH_EFRAMESYNC:
+		pr_err("Frame sync error\n");
+		cbd->stop = 2;
+		break;
+	}
+	if (cbd->stop)
+		pr_debug("stopping... %d\n", cbd->stop);
+}
+
+static int i2s_config_rate_reg(struct ioh_i2s_config_reg *config,
+				    unsigned int rate,
+				    struct snd_ml7213i2s_pcm *dpcm)
+{
+	unsigned int i2s_mclk;
+	unsigned int ret;
+
+	i2s_mclk = i2s_config_table[dpcm->ch+STEREO_OFFSET].i2s_mclk;
+	if ((i2s_mclk/64) == rate)
+		ret = ioh_mclkfs_64fs << I2SCLKCNT_MCLKFS_OFFSET;
+	else if ((i2s_mclk/128) == rate)
+		ret = ioh_mclkfs_128fs << I2SCLKCNT_MCLKFS_OFFSET;
+	else if ((i2s_mclk/192) == rate)
+		ret = ioh_mclkfs_192fs << I2SCLKCNT_MCLKFS_OFFSET;
+	else if ((i2s_mclk/256) == rate)
+		ret = ioh_mclkfs_256fs << I2SCLKCNT_MCLKFS_OFFSET;
+	else if ((i2s_mclk/384) == rate)
+		ret = ioh_mclkfs_384fs << I2SCLKCNT_MCLKFS_OFFSET;
+	else if ((i2s_mclk/512) == rate)
+		ret = ioh_mclkfs_512fs << I2SCLKCNT_MCLKFS_OFFSET;
+	else if ((i2s_mclk/768) == rate)
+		ret = ioh_mclkfs_768fs << I2SCLKCNT_MCLKFS_OFFSET;
+	else if ((i2s_mclk/1024) == rate)
+		ret = ioh_mclkfs_1024fs << I2SCLKCNT_MCLKFS_OFFSET;
+	else
+		ret = 0;
+
+	return ret;
+}
+
+static int i2s_rx_configure_reg(struct ioh_i2s_config_reg *config,
+				    unsigned int rate,
+				    struct snd_ml7213i2s_pcm *dpcm)
+{
+	int ret = 0;
+
+	memset(config, 0, sizeof(*config));
+
+	/* Set ML7213 IOH register default value */
+	config->cmn.i2simask = 0x003f003f;
+
+	config->rx.i2saerx = 0x1F;
+	config->rx.i2smskrx = 0x1F;
+	config->rx.i2sistrx = 0xC;
+
+	/* Configuration */
+	if (dpcm->channels == 1) {
+		config->rx.i2scntrx =
+			i2s_config_table[dpcm->ch+MONAURAL_OFFSET].i2scntrx |
+			dpcm->format |
+			(ioh_tel_tel_fmt << I2SCNTRX_RX_TEL_OFFSET);
+		config->cmn.i2sclkcnt = dpcm->bclkfs |
+			i2s_config_table[dpcm->ch+MONAURAL_OFFSET].i2sclkcnt;
+	} else {
+		config->rx.i2scntrx =
+			i2s_config_table[dpcm->ch+STEREO_OFFSET].i2scntrx |
+			dpcm->format |
+			(ioh_tel_i2s_fmt << I2SCNTRX_RX_TEL_OFFSET);
+		config->cmn.i2sclkcnt = dpcm->bclkfs |
+			i2s_config_table[dpcm->ch+STEREO_OFFSET].i2sclkcnt;
+	}
+
+	config->cmn.i2sclkcnt |= i2s_config_rate_reg(config, rate, dpcm);
+	config->rx.i2safrx = I2S_AFULL_THRESH / 2; /* Almost full threshold */
+	if (((config->cmn.i2sclkcnt & 0x3000) == 0x3000) &&
+	    ((config->cmn.i2sclkcnt & 0x7) == 0x2)) {
+		pr_err("%s: Failed not support setting\n", __func__);
+		ret = -1;
+	}
+	return ret;
+}
+
+static int setup_i2s_read(struct snd_pcm_substream *substream,
+			  struct snd_ml7213i2s_pcm *dpcm)
+{
+	struct snd_ml7213i2s_dma *dma;
+	struct ioh_i2s_config_reg config;
+	unsigned int master;
+	int ret = 0;
+	unsigned int byte;
+	int ch = substream->number;
+
+	master = (i2s_config_table[ch].i2sclkcnt >> I2SCLKCNT_MSSEL_OFFSET) & 1;
+	dma = substream->runtime->private_data;
+
+	dma->cbd.priv = ioh_i2s_open(ch, IOH_CAPTURE, "radio-i2s-in");
+
+	if (!dma->cbd.priv) {
+		pr_err("%s: Cannot open the device\n", __func__);
+		return -1;
+	}
+
+	if (ignore_overrun)
+		ioh_i2s_ignore_rx_overrun(dma->cbd.priv);
+
+	ret = i2s_rx_configure_reg(&config, dpcm->rate, dpcm);
+	if (master)
+		dma->master_mode |= 1 << (ch + I2S_READ_MASTER_BIT);
+	else
+		dma->master_mode |= 0 << (ch + I2S_READ_MASTER_BIT);
+
+	switch (dpcm->format) {
+	case (ioh_dabit_8bit << I2SCNT_DABIT_OFFSET):
+		byte = 1;
+		break;
+	case (ioh_dabit_16bit << I2SCNT_DABIT_OFFSET):
+		byte = 2;
+		break;
+	case (ioh_dabit_24bit << I2SCNT_DABIT_OFFSET):
+		byte = 4;
+		break;
+	default:
+		pr_err("%s: format error\n", __func__);
+		return -1;
+		break;
+	}
+
+	ioh_i2s_configure_i2s_regs(dma->cbd.priv, 0, &config, IOH_CAPTURE,
+				   byte);
+	return ret;
+}
+
+static void i2s_write_period(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_dma *dma;
+	struct cbdata *cbd;
+	int period;
+	void *write_ptr;
+	int write_size;
+
+	dma = substream->runtime->private_data;
+	cbd = &dma->cbd;
+
+	if (!cbd->priv)
+		return;
+
+	period = substream->runtime->period_size;
+	write_ptr = substream->runtime->dma_area
+	  +(snd_pcm_lib_period_bytes(substream) * dma->irq_pos);
+	write_size = period * (substream->runtime->sample_bits/8) *
+		     (substream->runtime->channels);
+
+	ioh_i2s_write(cbd->priv, write_ptr, write_size);
+
+	dma->irq_pos = (dma->irq_pos + 1) % substream->runtime->periods;
+}
+
+static void write_done(void *callback_data, int status, int num, int avail)
+{
+	struct snd_pcm_substream *substream =
+		(struct snd_pcm_substream *)callback_data;
+	struct snd_ml7213i2s_dma *dma;
+	struct cbdata *cbd;
+	int ch = substream->number;
+
+	dma = substream->runtime->private_data;
+
+	if (num < snd_card_ml7213i2s_playback[ch].period_bytes_max)
+		return;
+	if (avail >= snd_card_ml7213i2s_playback[ch].period_bytes_max*2)
+		return;
+
+	if (!substream) {
+		pr_debug("%s:!substream NULL\n", __func__);
+		return;
+	}
+	if (!substream->runtime) {
+		pr_debug("%s:!substream->runtime NULL\n", __func__);
+		return;
+	}
+	if (!substream->runtime->private_data) {
+		pr_debug("%s:!substream->runtime->private_data NULL\n",
+			__func__);
+		return;
+	}
+	cbd = &dma->cbd;
+
+	switch (status) {
+	case IOH_EOK:
+		if (!cbd->stop) {
+			i2s_write_period(substream);
+			dma->buf_pos = (dma->buf_pos + 1) %
+				substream->runtime->periods;
+			snd_pcm_period_elapsed(dma->substream);
+		}
+		cbd->cnt++;
+		break;
+	case IOH_EDONE:
+		pr_debug("Done stopping channel %d\n", cbd->stop);
+		cbd->stop = 2;
+		break;
+	default:
+		pr_debug("%s:default(%d)\n", __func__, status);
+	break;
+	}
+}
+
+static int i2s_tx_configure_reg(struct ioh_i2s_config_reg *config,
+				    unsigned int rate,
+				    struct snd_ml7213i2s_pcm *dpcm)
+{
+	int ret = 0;
+
+	memset(config, 0, sizeof(*config));
+
+	/* Set ML7213 IOH register default value */
+	config->cmn.i2simask = 0x003f003f;
+
+	config->tx.i2saftx = 0x0;
+	config->tx.i2smsktx = 0x1F;
+	config->tx.i2sisttx = 0xC;
+
+	/* Configuration */
+	if (dpcm->channels == 1) {
+		config->tx.i2scnttx =
+			i2s_config_table[dpcm->ch+MONAURAL_OFFSET].i2scnttx |
+			dpcm->format |
+			(ioh_tel_tel_fmt << I2SCNTTX_TX_TEL_OFFSET);
+		config->cmn.i2sclkcnt = dpcm->bclkfs |
+			i2s_config_table[dpcm->ch+MONAURAL_OFFSET].i2sclkcnt;
+	} else {
+		config->tx.i2scnttx =
+			i2s_config_table[dpcm->ch+STEREO_OFFSET].i2scnttx |
+			dpcm->format |
+			(ioh_tel_i2s_fmt << I2SCNTTX_TX_TEL_OFFSET);
+		config->cmn.i2sclkcnt = dpcm->bclkfs |
+			i2s_config_table[dpcm->ch+STEREO_OFFSET].i2sclkcnt;
+	}
+
+	config->cmn.i2sclkcnt |= i2s_config_rate_reg(config, rate, dpcm);
+	config->tx.i2saetx = I2S_AEMPTY_THRESH / 2; /* Almost empty threshold */
+	if (((config->cmn.i2sclkcnt & 0x3000) == 0x3000) &&
+	    ((config->cmn.i2sclkcnt & 0x7) == 0x2)) {
+		pr_err("%s: Failed not support setting\n", __func__);
+		ret = -1;
+	}
+	return ret;
+}
+
+static int setup_i2s_write(struct snd_pcm_substream *substream,
+			   struct snd_ml7213i2s_pcm *dpcm)
+{
+	struct ioh_i2s_config_reg config;
+	unsigned int master;
+	int ret = 0;
+	unsigned int byte;
+	struct snd_ml7213i2s_dma *dma;
+	int ch = substream->number;
+
+	master = (i2s_config_table[ch].i2sclkcnt >> I2SCLKCNT_MSSEL_OFFSET) & 1;
+	dma = substream->runtime->private_data;
+
+	dma->cbd.priv = ioh_i2s_open(ch, IOH_PLAYBACK, "radio-i2s-out");
+
+	if (!dma->cbd.priv) {
+		pr_err("%s: Cannot open the device\n", __func__);
+		return -1;
+	}
+
+	if (ignore_overrun)
+		ioh_i2s_ignore_rx_overrun(dma->cbd.priv);
+
+	ret = i2s_tx_configure_reg(&config, dpcm->rate, dpcm);
+	if (master)
+		dma->master_mode |= 1 << (ch + I2S_WRITE_MASTER_BIT);
+	else
+		dma->master_mode |= 0 << (ch + I2S_WRITE_MASTER_BIT);
+
+	switch (dpcm->format) {
+	case (ioh_dabit_8bit << I2SCNT_DABIT_OFFSET):
+		byte = 1;
+		break;
+	case (ioh_dabit_16bit << I2SCNT_DABIT_OFFSET):
+		byte = 2;
+		break;
+	case (ioh_dabit_24bit << I2SCNT_DABIT_OFFSET):
+		byte = 4;
+		break;
+	default:
+		pr_err("%s: format error\n", __func__);
+		return -1;
+		break;
+	}
+
+	ioh_i2s_configure_i2s_regs(dma->cbd.priv, 0, &config, IOH_PLAYBACK,
+				   byte);
+	return ret;
+}
+
+static void __snd_card_ml7213i2s_runtime_free(struct snd_pcm_runtime *runtime)
+{
+	struct snd_ml7213i2s_dma *dma;
+	static int cnt;
+
+	dma = (struct snd_ml7213i2s_dma *)runtime->private_data;
+	/* FIXME: This is just a big ball of race right now...
+	 */
+	if (!dma->cbd.stop)
+		dma->cbd.stop = 1;
+	else {
+		while (dma->cbd.stop != 2) {
+			if (cnt++ > 100) {
+				pr_debug("oops, failed to close ml7213i2s..\n");
+				pr_debug("it's ok if i2s isn't running\n");
+				break;
+			}
+			msleep(20);
+		}
+	}
+}
+
+static void snd_card_ml7213i2s_runtime_capture_free
+					(struct snd_pcm_runtime *runtime)
+{
+	struct snd_ml7213i2s_dma *dma = runtime->private_data;
+
+	__snd_card_ml7213i2s_runtime_free(runtime);
+
+	ioh_i2s_release(dma->cbd.priv, IOH_CAPTURE);
+	kfree(runtime->private_data);
+}
+
+static struct snd_ml7213i2s_dma *
+new_pcm_stream(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_dma *dma;
+
+	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
+	if (!dma)
+		return dma;
+	spin_lock_init(&dma->lock);
+	dma->substream = substream;
+	return dma;
+}
+
+static int snd_card_ml7213i2s_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_dma *dma;
+	int err;
+
+	dma = new_pcm_stream(substream);
+	if (dma == NULL)
+		return -ENOMEM;
+
+	runtime->private_data = dma;
+	/* makes the infrastructure responsible for freeing dma */
+	runtime->private_free = snd_card_ml7213i2s_runtime_capture_free;
+
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+		dma->rw = SND_CAPTURE_SUBSTREAM;
+		runtime->hw = snd_card_ml7213i2s_capture[substream->number];
+	} else {
+		dma->rw = SND_PLAYBACK_SUBSTREAM;
+		runtime->hw = snd_card_ml7213i2s_playback[substream->number];
+	}
+
+	err = add_capture_constraints(runtime);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int snd_card_ml7213i2s_close(struct snd_pcm_substream *substream)
+{
+	return 0;
+}
+
+static int snd_card_ml7213i2s_hw_params(struct snd_pcm_substream *substream,
+				    struct snd_pcm_hw_params *hw_params)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_pcm dpcm;
+	struct snd_ml7213i2s_dma *dma = runtime->private_data;
+
+	memset(&dpcm, 0, sizeof(dpcm));
+	dpcm.channels = params_channels(hw_params);
+	dpcm.ch = substream->number;
+	dpcm.rate = params_rate(hw_params);
+	switch (params_format(hw_params)) {
+	case SNDRV_PCM_FORMAT_U8:
+		dpcm.format = ioh_dabit_8bit << I2SCNT_DABIT_OFFSET;
+		if (dpcm.channels == 1)
+			dpcm.bclkfs = ioh_bclkfs_32fs <<
+				       I2SCLKCNT_BCLKFS_OFFSET;
+		else
+			dpcm.bclkfs = ioh_bclkfs_32fs <<
+				       I2SCLKCNT_BCLKFS_OFFSET;
+		break;
+	case SNDRV_PCM_FORMAT_S16_LE:
+		dpcm.format = ioh_dabit_16bit << I2SCNT_DABIT_OFFSET;
+		if (dpcm.channels == 1)
+			dpcm.bclkfs = ioh_bclkfs_32fs <<
+				       I2SCLKCNT_BCLKFS_OFFSET;
+		else
+			dpcm.bclkfs = ioh_bclkfs_32fs <<
+				       I2SCLKCNT_BCLKFS_OFFSET;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		dpcm.format = ioh_dabit_24bit << I2SCNT_DABIT_OFFSET;
+		if (dpcm.channels == 1)
+			dpcm.bclkfs = ioh_bclkfs_64fs <<
+				       I2SCLKCNT_BCLKFS_OFFSET;
+		else
+			dpcm.bclkfs = ioh_bclkfs_64fs <<
+				       I2SCLKCNT_BCLKFS_OFFSET;
+		break;
+	default:
+		pr_err("%s: Failed not support format\n", __func__);
+		return -1;
+		break;
+	}
+
+	switch (dma->rw) {
+	case SND_CAPTURE_SUBSTREAM:
+		if (setup_i2s_read(substream, &dpcm))
+			return -1;
+		break;
+	case SND_PLAYBACK_SUBSTREAM:
+		if (setup_i2s_write(substream, &dpcm))
+			return -1;
+		break;
+	default:
+		return -1;
+	}
+
+	return snd_pcm_lib_malloc_pages(substream,
+					params_buffer_bytes(hw_params));
+}
+
+static int snd_card_ml7213i2s_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_dma *dma = substream->runtime->private_data;
+	unsigned int flag;
+	unsigned int ch = substream->number;
+
+	switch (dma->rw) {
+	case SND_CAPTURE_SUBSTREAM:
+		dma->master_mode &= ~(1<<(ch+I2S_READ_MASTER_BIT));
+		flag = (dma->master_mode >> (ch+I2S_WRITE_MASTER_BIT)) & 1;
+		ioh_i2s_stop_i2s_regs(dma->cbd.priv, 0, NULL,
+				      IOH_CAPTURE, 1);
+		kfree(dma->cbd.priv);
+		break;
+
+	case SND_PLAYBACK_SUBSTREAM:
+		dma->master_mode &= ~(1<<(ch+I2S_WRITE_MASTER_BIT));
+		flag = (dma->master_mode >> (ch+I2S_READ_MASTER_BIT)) & 1;
+		ioh_i2s_stop_i2s_regs(dma->cbd.priv, 0, NULL,
+				      IOH_PLAYBACK, 1);
+		kfree(dma->cbd.priv);
+		break;
+
+	default:
+		return -1;
+	}
+
+	return snd_pcm_lib_free_pages(substream);
+}
+
+void ioh_i2s_irq_stop(struct ioh_i2s_data *priv, enum ioh_direction dir)
+{
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+
+	if (!priv) {
+		dev_err(priv->dev, "%s: i2s is NULL\n", __func__);
+		return;
+	}
+
+	if (dir) {
+		ioh_i2s_disable_interrupts(priv, IOH_CAPTURE);
+		ioh_i2s_disable_rx_full_ir(priv);
+		ioh_i2s_clear_rx_sts_ir(priv);
+		dma->rxexe_flag = 0;
+
+	} else {
+		ioh_i2s_disable_interrupts(priv, IOH_PLAYBACK);
+		ioh_i2s_disable_tx_empty_ir(priv);
+		ioh_i2s_clear_tx_sts_ir(priv);
+		dma->txexe_flag = 0;
+	}
+}
+
+void ioh_i2s_write_start(struct ioh_i2s_data *priv, void *callback_data,
+			 void (*done) (void *callback_data, int status,
+				       int num, int avail))
+{
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+
+	dma->txexe_flag = 1;
+
+	dma->tx_data_head = dma->tx_head;
+	dma->tx_complete = dma->tx_head;
+	dma->tx_avail = 0;
+
+	dma->tx_callback_data = callback_data;
+	dma->tx_done = done;
+
+	ioh_i2s_clear_tx_sts_ir(priv);
+	ioh_i2s_tx_clear_dma_mask(priv);
+	ioh_i2s_enable_interrupts(priv, IOH_PLAYBACK);
+}
+
+void ioh_i2s_read_start(struct ioh_i2s_data *priv, void *callback_data,
+			void (*done) (void *callback_data, int status,
+				      int num, int avail))
+{
+	struct ioh_i2s_dma *dma = &dmadata[priv->ch];
+
+	dma->rxexe_flag = 1;
+
+	dma->rx_data_head = dma->rx_head;
+	dma->rx_complete = dma->rx_head;
+	dma->rx_avail = 0;
+
+	dma->rx_callback_data = callback_data;
+	dma->rx_done = done;
+
+	ioh_i2s_clear_rx_sts_ir(priv);
+	ioh_i2s_rx_clear_dma_mask(priv);
+	ioh_i2s_enable_interrupts(priv, IOH_CAPTURE);
+}
+
+static inline void
+snd_card_ml7213i2s_pcm_i2s_start(struct snd_pcm_substream *substream)
+{
+	struct snd_ml7213i2s_dma *dma;
+	struct cbdata *cbd;
+	dma = substream->runtime->private_data;
+	cbd = &dma->cbd;
+
+	if (!cbd->priv)
+		return;
+
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
+		ioh_i2s_read_start(cbd->priv, substream, read_done);
+	} else {
+		ioh_i2s_write_start(cbd->priv, substream, write_done);
+		i2s_write_period(substream);
+	}
+}
+
+static int snd_card_ml7213i2s_pcm_trigger
+				(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_dma *dma = runtime->private_data;
+	int err = 0;
+
+	spin_lock(&dma->lock);
+
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+	case SNDRV_PCM_TRIGGER_RESUME:
+		dma->cbd.stop = 0;
+		snd_card_ml7213i2s_pcm_i2s_start(substream);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+		pr_debug("stop..\n");
+		if (!dma->cbd.stop)
+			dma->cbd.stop = 1;
+		else
+			pr_debug("already stopped %d\n", dma->cbd.stop);
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+			ioh_i2s_irq_stop(dma->cbd.priv, IOH_CAPTURE);
+		else
+			ioh_i2s_irq_stop(dma->cbd.priv, IOH_PLAYBACK);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	spin_unlock(&dma->lock);
+	return 0;
+}
+
+static int snd_card_ml7213i2s_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_dma *dma = runtime->private_data;
+
+	dma->irq_pos = 0;
+	dma->buf_pos = 0;
+
+	snd_pcm_format_set_silence(runtime->format, runtime->dma_area,
+			bytes_to_samples(runtime, runtime->dma_bytes));
+
+	return 0;
+}
+
+static snd_pcm_uframes_t
+snd_card_ml7213i2s_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct snd_ml7213i2s_dma *dma = runtime->private_data;
+
+	return substream->runtime->period_size*dma->buf_pos;
+}
+
+static struct snd_pcm_ops snd_card_ml7213i2s_capture_ops = {
+	.open =			snd_card_ml7213i2s_open,
+	.close =		snd_card_ml7213i2s_close,
+	.ioctl =		snd_pcm_lib_ioctl,
+	.hw_params =		snd_card_ml7213i2s_hw_params,
+	.hw_free =		snd_card_ml7213i2s_hw_free,
+	.prepare =		snd_card_ml7213i2s_pcm_prepare,
+	.trigger =		snd_card_ml7213i2s_pcm_trigger,
+	.pointer =		snd_card_ml7213i2s_pcm_pointer,
+};
+
+static int ml7213ioh_pcm_probe(struct snd_soc_platform *platform)
+{
+	return 0;
+}
+
+static int ml7213ioh_pcm_remove(struct snd_soc_platform *platform)
+{
+	return 0;
+}
+
+static struct snd_soc_platform_driver ml7213ioh_soc_platform = {
+	.probe		= ml7213ioh_pcm_probe,
+	.remove		= ml7213ioh_pcm_remove,
+	.ops		= &snd_card_ml7213i2s_capture_ops,
+};
+
+static int __devinit snd_card_ml7213i2s_pcm(struct snd_ml7213i2s *ml7213i2s,
+					     int device)
+{
+	struct snd_pcm *pcm;
+	int err;
+
+	/* The number of I2S interface is (Rx + Tx) x 6CH */
+	err = snd_pcm_new(ml7213i2s->card, "ml7213i2s PCM", device,
+			       MAX_I2S_TX_CH, MAX_I2S_RX_CH, &pcm);
+	if (err < 0)
+		return err;
+	ml7213i2s->pcm = pcm;
+	pcm->private_data = ml7213i2s;
+	pcm->info_flags = 0;
+	strcpy(pcm->name, "ml7213i2s PCM");
+
+	snd_pcm_lib_preallocate_pages_for_all(
+		pcm, SNDRV_DMA_TYPE_CONTINUOUS,
+		snd_dma_continuous_data(GFP_KERNEL),
+		0, 64*1024);
+	return 0;
+}
+
+static struct snd_device_ops ops = {NULL};
+
+/*****************************************************************************
+ *	PCI functions
+ *****************************************************************************/
+DEFINE_PCI_DEVICE_TABLE(ioh_pci_tbl) = {
+	{
+		.vendor = PCI_VENDOR_ID_ROHM,
+		.device = PCI_DEVICE_ID_ML7213_I2S,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+	},
+	{0,}
+};
+
+static int ioh_i2s_pci_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *id)
+{
+	int rv = 0;
+	int i;
+	int err;
+	struct ioh_i2s_data_pci *drvdata;
+	void __iomem *tbl;
+	unsigned int mapbase;
+	struct snd_card *card;
+	struct snd_ml7213i2s *ml7213i2s;
+	int dev = 0;
+
+	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
+	if (!drvdata)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, drvdata);
+
+	rv = pci_enable_device(pdev);
+	if (rv)
+		goto out_free;
+
+	tbl = pci_iomap(pdev, 1, 0);
+	if (!tbl) {
+		rv = -ENOMEM;
+		printk(KERN_ERR "pci_iomap failed\n");
+		goto out_ipmap;
+	}
+
+	mapbase = pci_resource_start(pdev, 1);
+	if (!mapbase) {
+		rv = -ENOMEM;
+		printk(KERN_ERR "pci_resource_start failed\n");
+		goto out_pci_resource_start;
+	}
+
+	drvdata->devs.dev = &pdev->dev;
+	drvdata->devs.iobase = tbl;
+	drvdata->devs.mapbase = mapbase;
+	spin_lock_init(&drvdata->devs.tx_lock);
+
+	for (i = 0; i < MAX_I2S_IF; i++)
+		dmadata[i].dma_config = &ioh_dma_config[i];
+
+	rv = request_irq(pdev->irq, ioh_i2s_irq, IRQF_SHARED, "ml7213_ioh",
+			 pdev);
+	if (rv != 0) {
+		printk(KERN_ERR "Failed to allocate irq\n");
+		goto out_irq;
+	}
+
+	err = snd_card_create(index, "ml7213i2s", THIS_MODULE,
+			      sizeof(struct snd_ml7213i2s), &card);
+
+	if (err < 0)
+		goto out_snd_card_create;
+
+	ml7213i2s = card->private_data;
+	ml7213i2s->card = card;
+	ml7213i2s->pci_dat = drvdata;
+	err = snd_card_ml7213i2s_pcm(ml7213i2s, 0);
+	if (err < 0)
+		goto snd_card_ml7213i2s_pc;
+
+	strcpy(card->driver, "ml7213i2s");
+	strcpy(card->shortname, "ml7213i2s");
+	sprintf(card->longname, "ml7213i2s %i", dev + 1);
+
+	snd_card_set_dev(card, &pdev->dev);
+	snd_device_new(card, SNDRV_DEV_LOWLEVEL, ml7213i2s, &ops);
+	err = snd_card_register(card);
+	if (err)
+		goto out_snd_card_register;
+
+	drvdata->card = card;
+
+	snd_soc_register_platform(&pdev->dev, &ml7213ioh_soc_platform);
+
+	return 0;
+
+out_snd_card_register:
+snd_card_ml7213i2s_pc:
+	snd_card_free(card);
+out_snd_card_create:
+	free_irq(pdev->irq, pdev);
+out_irq:
+out_pci_resource_start:
+	pci_iounmap(pdev, tbl);
+out_ipmap:
+	pci_disable_device(pdev);
+out_free:
+	kfree(drvdata);
+
+	return rv;
+}
+
+static void ioh_i2s_pci_remove(struct pci_dev *pdev)
+{
+	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < MAX_I2S_IF; i++)
+		ioh_i2s_reset(&drvdata->devs, i);
+
+	snd_soc_unregister_platform(&pdev->dev);
+	kfree(drvdata);
+	pci_disable_device(pdev);
+	pci_iounmap(pdev, drvdata->devs.iobase);
+	free_irq(pdev->irq, pdev);
+	snd_card_free(drvdata->card);
+	pci_set_drvdata(pdev, NULL);
+}
+
+static void ioh_i2s_save_reg_conf(struct pci_dev *pdev)
+{
+	int i;
+	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
+	void *iobase;
+	struct ioh_i2s_pm_ch_reg *save;
+	int offset;
+
+	for (i = 0, offset = 0; i < MAX_I2S_IF; i++, offset = i * 0x800) {
+		iobase = drvdata->devs.iobase;
+		save = &drvdata->devs.ch_reg_save[i];
+
+		save->i2sdrtx = ioread32(iobase + offset + I2SDRTX_OFFSET);
+		save->i2scnttx = ioread32(iobase + offset + I2SCNTTX_OFFSET);
+		save->i2sfifoctx =
+				ioread32(iobase + offset + I2SFIFOCTX_OFFSET);
+		save->i2saftx = ioread32(iobase + offset + I2SAFTX_OFFSET);
+		save->i2saetx = ioread32(iobase + offset + I2SAETX_OFFSET);
+		save->i2smsktx = ioread32(iobase + offset + I2SMSKTX_OFFSET);
+		save->i2sisttx = ioread32(iobase + offset + I2SISTTX_OFFSET);
+
+		save->i2scntrx = ioread32(iobase + offset + I2SCNTRX_OFFSET);
+		save->i2sfifocrx =
+				ioread32(iobase + offset + I2SFIFOCRX_OFFSET);
+		save->i2safrx = ioread32(iobase + offset + I2SAFRX_OFFSET);
+		save->i2saerx = ioread32(iobase + offset + I2SAERX_OFFSET);
+		save->i2smskrx = ioread32(iobase + offset + I2SMSKRX_OFFSET);
+		save->i2sistrx = ioread32(iobase + offset + I2SISTRX_OFFSET);
+	}
+
+	for (i = 0; i < MAX_I2S_IF; i++) {
+		drvdata->cmn_reg_save.i2sclkcnt[i] =
+		ioread32(drvdata->devs.iobase + I2SCLKCNT0_OFFSET + 0x10*i);
+	}
+	drvdata->cmn_reg_save.i2simask =
+			   ioread32(drvdata->devs.iobase + I2SIMASK_OFFSET);
+}
+
+static int ioh_i2s_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	int ret;
+
+	ioh_i2s_save_reg_conf(pdev);
+	ret = pci_save_state(pdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+			" %s -pci_save_state returns %d\n", __func__, ret);
+		return ret;
+	}
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
+static void ioh_i2s_restore_reg_conf(struct pci_dev *pdev)
+{
+	int i;
+	struct ioh_i2s_data_pci *drvdata = pci_get_drvdata(pdev);
+	void *iobase;
+	struct ioh_i2s_pm_ch_reg *save;
+	int offset;
+
+	for (i = 0, offset = 0; i < MAX_I2S_IF; i++, offset = i * 0x800) {
+		iobase = drvdata->devs.iobase;
+		save = &drvdata->devs.ch_reg_save[i];
+
+		iowrite32(save->i2sdrtx, iobase + offset + I2SDRTX_OFFSET);
+		iowrite32(save->i2scnttx, iobase + offset + I2SCNTTX_OFFSET);
+		iowrite32(save->i2sfifoctx,
+			  iobase + offset + I2SFIFOCTX_OFFSET);
+		iowrite32(save->i2saftx, iobase + offset + I2SAFTX_OFFSET);
+		iowrite32(save->i2saetx, iobase + offset + I2SAETX_OFFSET);
+		iowrite32(save->i2smsktx, iobase + offset + I2SMSKTX_OFFSET);
+		iowrite32(save->i2sisttx, iobase + offset + I2SISTTX_OFFSET);
+
+		iowrite32(save->i2scntrx, iobase + offset + I2SCNTRX_OFFSET);
+		iowrite32(save->i2sfifocrx,
+			  iobase + offset + I2SFIFOCRX_OFFSET);
+		iowrite32(save->i2safrx, iobase + offset + I2SAFRX_OFFSET);
+		iowrite32(save->i2saerx, iobase + offset + I2SAERX_OFFSET);
+		iowrite32(save->i2smskrx, iobase + offset + I2SMSKRX_OFFSET);
+		iowrite32(save->i2sistrx, iobase + offset + I2SISTRX_OFFSET);
+	}
+
+	for (i = 0; i < MAX_I2S_IF; i++) {
+		iowrite32(drvdata->cmn_reg_save.i2sclkcnt[i],
+			 drvdata->devs.iobase + I2SCLKCNT0_OFFSET + 0x10*i);
+	}
+
+	iowrite32(drvdata->cmn_reg_save.i2simask,
+		  drvdata->devs.iobase + I2SIMASK_OFFSET);
+}
+
+static int ioh_i2s_pci_resume(struct pci_dev *pdev)
+{
+	int ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev,
+		"%s-pci_enable_device failed(ret=%d) ", __func__, ret);
+		return ret;
+	}
+
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	ioh_i2s_restore_reg_conf(pdev);
+
+	return 0;
+}
+
+static struct pci_driver ioh_i2s_driver = {
+	.name = DRV_NAME,
+	.probe = ioh_i2s_pci_probe,
+	.remove = __devexit_p(ioh_i2s_pci_remove),
+	.id_table = ioh_pci_tbl,
+#ifdef CONFIG_PM
+	.suspend = ioh_i2s_pci_suspend,
+	.resume = ioh_i2s_pci_resume,
+#endif
+};
+
+static int __init ioh_i2s_init(void)
+{
+	return pci_register_driver(&ioh_i2s_driver);
+}
+
+static void __exit ioh_i2s_cleanup(void)
+{
+	pci_unregister_driver(&ioh_i2s_driver);
+}
+
+module_init(ioh_i2s_init);
+module_exit(ioh_i2s_cleanup);
+
+MODULE_AUTHOR("Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>");
+MODULE_DESCRIPTION("LAPIS Semiconductor ML7213 IOH ALSA SoC platform driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/lapis/ml7213ioh-plat.h b/sound/soc/lapis/ml7213ioh-plat.h
new file mode 100644
index 0000000..1dbc5cd
--- /dev/null
+++ b/sound/soc/lapis/ml7213ioh-plat.h
@@ -0,0 +1,213 @@
+/*
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#ifndef ML7213IOH_PLAT_H
+#define ML7213IOH_PLAT_H
+
+#include <linux/interrupt.h>
+#include <linux/pch_dma.h>
+
+#define I2SCLKCNT0_OFFSET	0x3000
+#define I2SCLKCNT1_OFFSET	0x3010
+#define I2SCLKCNT2_OFFSET	0x3020
+#define I2SCLKCNT3_OFFSET	0x3030
+#define I2SCLKCNT4_OFFSET	0x3040
+#define I2SCLKCNT5_OFFSET	0x3050
+#define I2SISTATUS_OFFSET	0x3080
+#define I2SIDISP_OFFSET		0x3084
+#define I2SIMASK_OFFSET		0x3088
+#define I2SIMASKCLR_OFFSET	0x308C
+#define I2SSRST_OFFSET		0x3FFC
+#define I2SDRTX_OFFSET		0x0
+#define I2SCNTTX_OFFSET		0x4
+#define I2SFIFOCTX_OFFSET	0x8
+#define I2SAFTX_OFFSET		0xC
+#define I2SAETX_OFFSET		0x10
+#define I2SMSKTX_OFFSET		0x14
+#define I2SISTTX_OFFSET		0x18
+#define I2SMONTX_OFFSET		0x1C
+#define I2SDRRX_OFFSET		0x20
+#define I2SCNTRX_OFFSET		0x24
+#define I2SFIFOCRX_OFFSET	0x28
+#define I2SAFRX_OFFSET		0x2C
+#define I2SAERX_OFFSET		0x30
+#define I2SMSKRX_OFFSET		0x34
+#define I2SISTRX_OFFSET		0x38
+#define I2SMONRX_OFFSET		0x3C
+#define FIRST_TX_OFFSET		0x0
+#define FIRST_RX_OFFSET		0x0
+
+#define I2SDRTXMIRROR_OFFSET	0x100
+#define I2SDRRXMIRROR_OFFSET	0x400
+
+#define TX_OFFSET_INCREMENT	0x800
+
+#define I2S_ALL_INTERRUPT_BITS	0x3F003F
+#define I2S_IDISP_BITS		0x3F003F
+#define I2S_IDISP_TX_BITS	0x00003F
+#define I2S_IDISP_RX_BITS	0x3F0000
+#define TX_BIT_FIMSK	0x1	/*Fifo full interrupt mask bit*/
+#define TX_BIT_AFIMSK	0x2	/*Fifo Almost full interrupt mask bit*/
+#define TX_BIT_EIMSK	0x4	/*Fifo empty interrupt mask bit*/
+#define TX_BIT_AEIMSK	0x8	/*Fifo Almost empty interrupt mask bit*/
+#define TX_BIT_DMAMSK	0x10	/*Masks DMA*/
+#define TX_BIT_DMATC	0x100
+#define I2S_TX_ALL_INTR_MASK_BITS (TX_BIT_FIMSK | TX_BIT_AFIMSK | TX_BIT_EIMSK \
+							| TX_BIT_AEIMSK)
+#define I2S_TX_NORMAL_INTR_MASK_BITS (TX_BIT_FIMSK | TX_BIT_AFIMSK)
+#define RX_BIT_FIMSK	0x1	/*Fifo full interrupt mask bit*/
+#define RX_BIT_AFIMSK	0x2	/*Fifo Almost full interrupt mask bit*/
+#define RX_BIT_EIMSK	0x4	/*Fifo empty interrupt mask bit*/
+#define RX_BIT_AEIMSK	0x8	/*Fifo Almost empty interrupt mask bit*/
+#define RX_BIT_DMAMSK	0x10	/*Masks DMA*/
+#define RX_BIT_DMATC	0x100
+#define I2S_RX_ALL_INTR_MASK_BITS (RX_BIT_FIMSK | RX_BIT_AFIMSK | RX_BIT_EIMSK \
+							| RX_BIT_AEIMSK)
+#define I2S_RX_NORMAL_INTR_MASK_BITS (RX_BIT_EIMSK | RX_BIT_AEIMSK)
+#define I2S_TX_FINT	0x1	/*Full Interrupt*/
+#define I2S_TX_AFINT	0x2	/*Almost full interrupt*/
+#define I2S_TX_EINT	0x4	/*Empty interrupt*/
+#define I2S_TX_AEINT	0x8	/*Almost empty interrupt*/
+#define I2S_RX_FINT	0x1	/*Full Interrupt*/
+#define I2S_RX_AFINT	0x2	/*Almost full interrupt*/
+#define I2S_RX_EINT	0x4	/*Empty interrupt*/
+#define I2S_RX_AEINT	0x8	/*Almost empty interrupt*/
+
+#define I2S_FIFO_TX_FCLR	BIT(0)
+#define I2S_FIFO_TX_RUN		BIT(4)
+#define I2S_FIFO_RX_FCLR	BIT(0)
+#define I2S_FIFO_RX_RUN		BIT(4)
+
+#define FIFO_CTRL_BIT_TX_RUN	0x10
+#define FIFO_CTRL_BIT_RX_RUN	0x10
+#define I2S_CNT_BIT_TEL		0x1
+#define I2S_IMASK_TX_BIT_START	0
+#define I2S_IMASK_RX_BIT_START	16
+
+#define MAX_I2S_IF	MAX_I2S_CH
+
+/* DMA channel name configuration */
+static struct ioh_dma_config {
+	char rx_chan[8];
+	char tx_chan[8];
+} ioh_dma_config[] = {
+	{ /* I2S0 */
+		.tx_chan = "i2s_tx0",
+		.rx_chan = "i2s_rx0",
+	},
+	{ /* I2S1 */
+		.tx_chan = "i2s_tx1",
+		.rx_chan = "i2s_rx1",
+	},
+	{ /* I2S2 */
+		.tx_chan = "i2s_tx2",
+		.rx_chan = "i2s_rx2",
+	},
+	{ /* I2S3 */
+		.tx_chan = "i2s_tx3",
+		.rx_chan = "i2s_rx3",
+	},
+	{ /* I2S4 */
+		.tx_chan = "i2s_tx4",
+		.rx_chan = "i2s_rx4",
+	},
+	{ /* I2S5 */
+		.tx_chan = "i2s_tx5",
+		.rx_chan = "i2s_rx5",
+	},
+};
+
+struct ioh_i2s_data {
+	struct device *dev;
+	void *iobase;
+	int ch;
+	int ignore_rx_overrun;
+	spinlock_t tx_lock;
+	unsigned int mapbase;
+	struct ioh_i2s_pm_ch_reg ch_reg_save[6];
+};
+
+struct ioh_i2s_dma {
+	atomic_t rx_busy;
+	atomic_t tx_busy;
+
+	/* Transmit side DMA */
+	atomic_t pending_tx;
+
+	struct ioh_dma_config *dma_config;
+
+	struct scatterlist	*sg_tx_p;
+	struct scatterlist	*sg_rx_p;
+
+	struct scatterlist	*sg_tx_cur; /* current head of tx sg */
+	struct scatterlist	*sg_rx_cur; /* current head of tx sg */
+
+	int tx_num;	/* The number of sent sg */
+	int rx_num;	/* The number of sent sg */
+
+	void *rxbuf_virt;
+	void *txbuf_virt;
+	unsigned char *tx_tail;
+	unsigned char *tx_head;
+	unsigned char *tx_data_head;
+	unsigned char *tx_complete;
+	unsigned int  tx_avail;
+	unsigned char *rx_tail;
+	unsigned char *rx_head;
+	unsigned char *rx_data_head;
+	unsigned char *rx_complete;
+	unsigned int rx_avail;
+
+	struct dma_chan			*chan_tx;
+	struct dma_chan			*chan_rx;
+
+	int rx_nent;	/* The number of rx scatter list  */
+	int tx_nent;	/* The number of tx scatter list */
+
+	struct dma_async_tx_descriptor	*desc_tx;
+	struct dma_async_tx_descriptor	*desc_rx;
+
+	dma_addr_t			tx_buf_dma;
+	dma_addr_t			rx_buf_dma;
+
+	struct pch_dma_slave		param_tx;
+	struct pch_dma_slave		param_rx;
+
+	void *rx_callback_data;
+	void (*rx_done) (void *callback_data, int status, int num, int avail);
+	void *tx_callback_data;
+	void (*tx_done) (void *callback_data, int status, int num, int avail);
+
+	int dma_tx_unit; /* 1Byte of 2Byte or 4Byte */
+	int dma_rx_unit; /* 1Byte of 2Byte or 4Byte */
+	int dma_tx_width;
+	int dma_rx_width;
+
+	int txexe_flag;
+	int rxexe_flag;
+
+	struct tasklet_struct	tx_tasklet;
+	struct tasklet_struct	rx_tasklet;
+};
+
+struct ioh_i2s_data_pci {
+	struct ioh_i2s_data devs;
+	struct ioh_i2s_pm_common_reg cmn_reg_save;
+	struct snd_card *card;
+};
+
+#endif
-- 
1.7.4.4

