Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab2ENU1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:27:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42196 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab2ENU1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:27:30 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V6 5/5] WL12xx: Add support for FM new features.
Date: Mon, 14 May 2012 15:27:24 -0500
Message-ID: <1337027244-2595-6-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1337027244-2595-1-git-send-email-manjunatha_halli@ti.com>
References: <1337027244-2595-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

This patch adds below features to TI's V4l2 FM driver for Wilink
chipsets,

	1) FM RX Set frequency allows to set frequency anywhere between
	65.5 MHz till 108 MHz (if chip is Wilink8 then till 164.55 MHz)
	2) FM RX seek caters for band switch
	3) FM RX RDS AF turn ON/OFF
	4) FM RX De-Emphasis mode set/get
	5) FM TX Alternate Frequency set/get

Also this patch fixes below issues

	1) FM audio volume gain setting
	2) Default rssi level is set to 8 instead of 20
	3) Issue related to audio mute/unmute
	4) Enable FM RX AF support in driver
	5) In wrap_around seek mode try for once

Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/media/radio/wl128x/fmdrv.h        |    3 +-
 drivers/media/radio/wl128x/fmdrv_common.c |   38 +++++++++--
 drivers/media/radio/wl128x/fmdrv_common.h |   28 +++++++-
 drivers/media/radio/wl128x/fmdrv_rx.c     |   90 ++++++++++++++++++++-----
 drivers/media/radio/wl128x/fmdrv_rx.h     |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c   |  101 +++++++++++++++++++++++++++--
 6 files changed, 224 insertions(+), 38 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index d84ad9d..c806c85 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -150,6 +150,7 @@ struct fm_rx {
 	struct region_info region;	/* Current selected band */
 	u32 freq;	/* Current RX frquency */
 	u8 mute_mode;	/* Current mute mode */
+	u8 bl_flag;	/* Band limit reached flag */
 	u8 deemphasis_mode; /* Current deemphasis mode */
 	/* RF dependent soft mute mode */
 	u8 rf_depend_mute;
@@ -203,7 +204,7 @@ struct fmtx_data {
 struct fmdev {
 	struct video_device *radio_dev;	/* V4L2 video device pointer */
 	struct snd_card *card;	/* Card which holds FM mixer controls */
-	u16 asci_id;
+	u16 asic_id;
 	spinlock_t rds_buff_lock; /* To protect access to RDS buffer */
 	spinlock_t resp_skb_lock; /* To protect access to received SKB */
 
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index fcce61a..ac20556 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -44,20 +44,41 @@
 
 /* Region info */
 static struct region_info region_configs[] = {
+	/* Super set of all bands */
+	{
+	 .chanl_space = FM_CHANNEL_SPACING_200KHZ * FM_FREQ_MUL,
+	 .bot_freq = 65800,	/* 87.5 MHz */
+	 .top_freq = 162550,	/* 108 MHz */
+	 .fm_band = 0,
+	 },
 	/* Europe/US */
 	{
 	 .chanl_space = FM_CHANNEL_SPACING_200KHZ * FM_FREQ_MUL,
 	 .bot_freq = 87500,	/* 87.5 MHz */
 	 .top_freq = 108000,	/* 108 MHz */
-	 .fm_band = 0,
+	 .fm_band = 1,
 	 },
 	/* Japan */
 	{
 	 .chanl_space = FM_CHANNEL_SPACING_200KHZ * FM_FREQ_MUL,
 	 .bot_freq = 76000,	/* 76 MHz */
 	 .top_freq = 90000,	/* 90 MHz */
-	 .fm_band = 1,
+	 .fm_band = 2,
 	 },
+	/* Russian (OIRT) band */
+	{
+	.chanl_space = FM_CHANNEL_SPACING_50KHZ * FM_FREQ_MUL_RUS,
+	.bot_freq = 65800,     /* 65.8 MHz */
+	.top_freq = 74000,     /* 74 MHz */
+	.fm_band = 3,
+	},
+	/* Wether Band */
+	{
+	.chanl_space = FM_CHANNEL_SPACING_50KHZ * FM_FREQ_MUL_WB,
+	.bot_freq = 162400,     /* 162.4 MHz */
+	.top_freq = 162550,     /* 162.55 MHz */
+	.fm_band = 4,
+	}
 };
 
 /* Band selection */
@@ -596,7 +617,6 @@ static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
 	memcpy(&fmdev->irq_info.flag, skb->data, fm_evt_hdr->dlen);
 
 	fmdev->irq_info.flag = be16_to_cpu(fmdev->irq_info.flag);
-	fmdbg("irq: flag register(0x%x)\n", fmdev->irq_info.flag);
 
 	/* Continue next function in interrupt handler table */
 	fm_irq_call_stage(fmdev, FM_HW_MAL_FUNC_IDX);
@@ -702,7 +722,7 @@ static void fm_rdsparse_swapbytes(struct fmdev *fmdev,
 	 * in Dolphin they are in big endian, the parsing of the RDS data
 	 * is chip dependent
 	 */
-	if (fmdev->asci_id != 0x6350) {
+	if (fmdev->asic_id != 0x6350) {
 		rds_buff = &rds_format->data.groupdatabuff.buff[0];
 		while (index + 1 < FM_RX_RDS_INFO_FIELD_MAX) {
 			byte1 = rds_buff[index];
@@ -1353,11 +1373,13 @@ static int fm_power_up(struct fmdev *fmdev, u8 mode)
 			sizeof(asic_ver), &asic_ver, &resp_len))
 		goto rel;
 
+	fmdev->asic_id = be16_to_cpu(asic_id);
+
 	fmdbg("ASIC ID: 0x%x , ASIC Version: %d\n",
-		be16_to_cpu(asic_id), be16_to_cpu(asic_ver));
+		fmdev->asic_id, be16_to_cpu(asic_ver));
 
 	sprintf(fw_name, "%s_%x.%d.bts", FM_FMC_FW_FILE_START,
-		be16_to_cpu(asic_id), be16_to_cpu(asic_ver));
+		fmdev->asic_id, be16_to_cpu(asic_ver));
 
 	ret = fm_download_firmware(fmdev, fw_name);
 	if (ret < 0) {
@@ -1366,7 +1388,7 @@ static int fm_power_up(struct fmdev *fmdev, u8 mode)
 	}
 	sprintf(fw_name, "%s_%x.%d.bts", (mode == FM_MODE_RX) ?
 			FM_RX_FW_FILE_START : FM_TX_FW_FILE_START,
-			be16_to_cpu(asic_id), be16_to_cpu(asic_ver));
+			fmdev->asic_id, be16_to_cpu(asic_ver));
 
 	ret = fm_download_firmware(fmdev, fw_name);
 	if (ret < 0) {
@@ -1576,7 +1598,7 @@ int fmc_prepare(struct fmdev *fmdev)
 	fmdev->rx.rds.flag = FM_RDS_DISABLE;
 	fmdev->rx.freq = FM_UNDEFINED_FREQ;
 	fmdev->rx.rds_mode = FM_RDS_SYSTEM_RDS;
-	fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_OFF;
+	fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_ON;
 	fmdev->irq_info.retry = 0;
 
 	fmdev->tx_data.tx_frq = FM_UNDEFINED_FREQ;
diff --git a/drivers/media/radio/wl128x/fmdrv_common.h b/drivers/media/radio/wl128x/fmdrv_common.h
index 196ff7d..b25c49e 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.h
+++ b/drivers/media/radio/wl128x/fmdrv_common.h
@@ -201,8 +201,24 @@ struct fm_event_msg_hdr {
 #define FM_UNDEFINED_FREQ		   0xFFFFFFFF
 
 /* Band types */
-#define FM_BAND_EUROPE_US	0
-#define FM_BAND_JAPAN		1
+#define FM_BAND_ALL		0
+#define FM_BAND_EUROPE_US	1
+#define FM_BAND_JAPAN		2
+#define FM_BAND_RUSSIAN		3
+#define FM_BAND_WEATHER		4
+
+/* Frequencies */
+#define FM_RUSSIAN_BAND_LOW	65800
+#define FM_RUSSIAN_BAND_HIGH	74000
+
+#define FM_JAPAN_BAND_LOW       76000
+#define FM_JAPAN_BAND_HIGH      90000
+
+#define FM_US_BAND_LOW          87500
+#define FM_US_BAND_HIGH         108000
+
+#define FM_WEATHER_BAND_LOW	162400
+#define FM_WEATHER_BAND_HIGH	162550
 
 /* Seek directions */
 #define FM_SEARCH_DIRECTION_DOWN	0
@@ -213,6 +229,10 @@ struct fm_event_msg_hdr {
 #define FM_TUNER_PRESET_MODE		1
 #define FM_TUNER_AUTONOMOUS_SEARCH_MODE	2
 #define FM_TUNER_AF_JUMP_MODE		3
+#define FM_TUNER_PI_MATCH_MODE		4
+#define FM_TUNER_BULK_SEARCH_MODE	5
+#define FM_TUNER_WRAP_SEARCH_MODE	6
+#define FM_TUNER_WEATHER_MODE		7
 
 /* Min and Max volume */
 #define FM_RX_VOLUME_MIN	0
@@ -353,7 +373,7 @@ struct fm_event_msg_hdr {
  * with this default values after loading RX firmware.
  */
 #define FM_DEFAULT_RX_VOLUME		10
-#define FM_DEFAULT_RSSI_THRESHOLD	20
+#define FM_DEFAULT_RSSI_THRESHOLD	8
 
 /* Range for TX power level in units for dB/uV */
 #define FM_PWR_LVL_LOW			91
@@ -402,6 +422,8 @@ int fmc_get_mode(struct fmdev *, u8 *);
 #define FM_CHANNEL_SPACING_100KHZ 2
 #define FM_CHANNEL_SPACING_200KHZ 4
 #define FM_FREQ_MUL 50
+#define FM_FREQ_MUL_RUS 10
+#define FM_FREQ_MUL_WB 25
 
 #endif
 
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index a806bda..77824d14 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -51,7 +51,19 @@ int fm_rx_set_freq(struct fmdev *fmdev, u32 freq)
 	u32 resp_len;
 	int ret;
 
-	if (freq < fmdev->rx.region.bot_freq || freq > fmdev->rx.region.top_freq) {
+
+	if (freq >= FM_RUSSIAN_BAND_LOW && freq <= FM_RUSSIAN_BAND_HIGH)
+		fm_rx_set_region(fmdev, FM_BAND_RUSSIAN);
+	else if (freq >= FM_JAPAN_BAND_LOW && freq <= FM_JAPAN_BAND_HIGH)
+		fm_rx_set_region(fmdev, FM_BAND_JAPAN);
+	else if (freq >= FM_US_BAND_LOW && freq <= FM_US_BAND_HIGH)
+		fm_rx_set_region(fmdev, FM_BAND_EUROPE_US);
+	else if (freq >= FM_WEATHER_BAND_LOW && freq <= FM_WEATHER_BAND_HIGH) {
+		if (fmdev->asic_id < 0x1800)
+			return -ERANGE;
+
+		fm_rx_set_region(fmdev, FM_BAND_WEATHER);
+	} else {
 		fmerr("Invalid frequency %d\n", freq);
 		return -EINVAL;
 	}
@@ -72,7 +84,12 @@ int fm_rx_set_freq(struct fmdev *fmdev, u32 freq)
 		return ret;
 
 	/* Calculate frequency index and set*/
-	payload = (freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
+	if (fmdev->rx.region.fm_band == FM_BAND_RUSSIAN)
+		payload = (freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL_RUS;
+	else if (fmdev->rx.region.fm_band == FM_BAND_WEATHER)
+		payload = (freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL_WB;
+	else
+		payload = (freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
 
 	ret = fmc_send_cmd(fmdev, FREQ_SET, REG_WR, &payload,
 			sizeof(payload), NULL, NULL);
@@ -117,7 +134,13 @@ int fm_rx_set_freq(struct fmdev *fmdev, u32 freq)
 		goto exit;
 
 	curr_frq = be16_to_cpu(curr_frq);
-	curr_frq_in_khz = (fmdev->rx.region.bot_freq + ((u32)curr_frq * FM_FREQ_MUL));
+
+	if (fmdev->rx.region.fm_band == FM_BAND_RUSSIAN)
+		curr_frq_in_khz = (fmdev->rx.region.bot_freq + ((u32)curr_frq * FM_FREQ_MUL_RUS));
+	else if (fmdev->rx.region.fm_band == FM_BAND_WEATHER)
+		curr_frq_in_khz = (fmdev->rx.region.bot_freq + ((u32)curr_frq * FM_FREQ_MUL_WB));
+	else
+		curr_frq_in_khz = (fmdev->rx.region.bot_freq + ((u32)curr_frq * FM_FREQ_MUL));
 
 	if (curr_frq_in_khz != freq) {
 		pr_info("Frequency is set to (%d) but "
@@ -167,15 +190,22 @@ static int fm_rx_set_channel_spacing(struct fmdev *fmdev, u32 spacing)
 }
 
 int fm_rx_seek(struct fmdev *fmdev, u32 seek_upward,
-		u32 wrap_around, u32 spacing)
+		u32 wrap_around, u32 spacing, u32 fm_band)
 {
 	u32 resp_len;
-	u16 curr_frq, next_frq, last_frq;
+	u16 curr_frq, next_frq, last_frq, fm_frq_mul;
 	u16 payload, int_reason, intr_flag;
 	u16 offset, space_idx;
 	unsigned long timeleft;
 	int ret;
 
+	if (fmdev->rx.region.fm_band != fm_band) {
+		if ((fmdev->asic_id < 0x1800) && (fm_band == FM_BAND_WEATHER))
+			return -EINVAL;
+
+		fm_rx_set_region(fmdev, fm_band);
+	}
+
 	/* Set channel spacing */
 	ret = fm_rx_set_channel_spacing(fmdev, spacing);
 	if (ret < 0) {
@@ -190,10 +220,22 @@ int fm_rx_seek(struct fmdev *fmdev, u32 seek_upward,
 		return ret;
 
 	curr_frq = be16_to_cpu(curr_frq);
-	last_frq = (fmdev->rx.region.top_freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
 
 	/* Check the offset in order to be aligned to the channel spacing*/
-	space_idx = fmdev->rx.region.chanl_space / FM_FREQ_MUL;
+	if (fmdev->rx.region.fm_band == FM_BAND_RUSSIAN) {
+		last_frq = (fmdev->rx.region.top_freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL_RUS;
+		space_idx = fmdev->rx.region.chanl_space / FM_FREQ_MUL_RUS;
+		fm_frq_mul = FM_FREQ_MUL_RUS;
+	} else if (fmdev->rx.region.fm_band == FM_BAND_WEATHER) {
+		last_frq = (fmdev->rx.region.top_freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL_WB;
+		space_idx = 1;
+		fm_frq_mul = FM_FREQ_MUL_WB;
+	} else {
+		last_frq = (fmdev->rx.region.top_freq - fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
+		space_idx = fmdev->rx.region.chanl_space / FM_FREQ_MUL;
+		fm_frq_mul = FM_FREQ_MUL;
+	}
+
 	offset = curr_frq % space_idx;
 
 	next_frq = seek_upward ? curr_frq + space_idx /* Seek Up */ :
@@ -238,7 +280,11 @@ again:
 		return ret;
 
 	/* Start seek */
-	payload = FM_TUNER_AUTONOMOUS_SEARCH_MODE;
+	if (fmdev->rx.region.fm_band == FM_BAND_WEATHER)
+		payload = FM_TUNER_WEATHER_MODE;
+	else
+		payload = FM_TUNER_AUTONOMOUS_SEARCH_MODE;
+
 	ret = fmc_send_cmd(fmdev, TUNER_MODE_SET, REG_WR, &payload,
 			sizeof(payload), NULL, NULL);
 	if (ret < 0)
@@ -265,6 +311,7 @@ again:
 		return ret;
 
 	if (int_reason & FM_BL_EVENT) {
+		fmdev->rx.bl_flag = 1;
 		if (wrap_around == 0) {
 			fmdev->rx.freq = seek_upward ?
 				fmdev->rx.region.top_freq :
@@ -274,8 +321,11 @@ again:
 				fmdev->rx.region.bot_freq :
 				fmdev->rx.region.top_freq;
 			/* Calculate frequency index to write */
-			next_frq = (fmdev->rx.freq -
-					fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
+			next_frq = (fmdev->rx.freq - fmdev->rx.region.bot_freq) / fm_frq_mul;
+
+			/* If no valid chanel then report default frequency */
+			wrap_around = 0;
+
 			goto again;
 		}
 	} else {
@@ -286,9 +336,7 @@ again:
 			return ret;
 
 		curr_frq = be16_to_cpu(curr_frq);
-		fmdev->rx.freq = (fmdev->rx.region.bot_freq +
-				((u32)curr_frq * FM_FREQ_MUL));
-
+		fmdev->rx.freq = (fmdev->rx.region.bot_freq + ((u32)curr_frq * fm_frq_mul));
 	}
 	/* Reset RDS cache and current station pointers */
 	fm_rx_reset_rds_cache(fmdev);
@@ -364,18 +412,21 @@ int fm_rx_set_region(struct fmdev *fmdev, u8 region_to_set)
 	int ret;
 
 	if (region_to_set != FM_BAND_EUROPE_US &&
-	    region_to_set != FM_BAND_JAPAN) {
+	    region_to_set != FM_BAND_JAPAN &&
+	    region_to_set != FM_BAND_RUSSIAN &&
+	    region_to_set != FM_BAND_WEATHER) {
 		fmerr("Invalid band\n");
 		return -EINVAL;
 	}
 
 	if (fmdev->rx.region.fm_band == region_to_set) {
-		fmerr("Requested band is already configured\n");
+		fmdbg("Requested band is already configured\n");
 		return 0;
 	}
 
 	/* Send cmd to set the band  */
-	payload = (u16)region_to_set;
+	/* Since 0 indicates super band actual payload should be payload - 1*/
+	payload = (u16)(region_to_set - 1);
 	ret = fmc_send_cmd(fmdev, BAND_SET, REG_WR, &payload,
 			sizeof(payload), NULL, NULL);
 	if (ret < 0)
@@ -636,8 +687,11 @@ int fm_rx_set_deemphasis_mode(struct fmdev *fmdev, u16 mode)
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
 
-	if (mode != FM_RX_EMPHASIS_FILTER_50_USEC &&
-			mode != FM_RX_EMPHASIS_FILTER_75_USEC) {
+	if (mode == V4L2_PREEMPHASIS_DISABLED)
+		return 0;
+
+	if (mode != V4L2_PREEMPHASIS_50_uS &&
+			mode != V4L2_PREEMPHASIS_75_uS) {
 		fmerr("Invalid rx de-emphasis mode (%d)\n", mode);
 		return -EINVAL;
 	}
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.h b/drivers/media/radio/wl128x/fmdrv_rx.h
index 32add81..261420e 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.h
+++ b/drivers/media/radio/wl128x/fmdrv_rx.h
@@ -37,7 +37,7 @@ int fm_rx_set_af_switch(struct fmdev *, u8);
 void fm_rx_reset_rds_cache(struct fmdev *);
 void fm_rx_reset_station_info(struct fmdev *);
 
-int fm_rx_seek(struct fmdev *, u32, u32, u32);
+int fm_rx_seek(struct fmdev *, u32, u32, u32, u32);
 
 int fm_rx_get_rds_mode(struct fmdev *, u8 *);
 int fm_rx_get_rds_system(struct fmdev *, u8 *);
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 494faaf..65ba08d 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -212,6 +212,7 @@ static int fm_v4l2_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	int ret;
 
+	fmdbg(" fm_v4l2_s_ctrl - AF bit = %d\n", ctrl->val);
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:	/* set volume */
 		return fm_rx_set_volume(fmdev, (u16)ctrl->val);
@@ -258,6 +259,22 @@ static int fm_v4l2_s_ctrl(struct v4l2_ctrl *ctrl)
 		}
 		return 0;
 
+	case V4L2_CID_RDS_TX_AF_FREQ:
+		ret = fm_tx_set_af(fmdev, ctrl->val);
+		if (ret < 0) {
+			fmerr("Failed to set FM TX AF Frequency\n");
+			return ret;
+		}
+		return 0;
+
+	case V4L2_CID_RDS_AF_SWITCH:	/* enable/disable FM RX RDS AF*/
+		fmdbg("V4L2_CID_RDS_AF_SWITCH:\n");
+		return fm_rx_set_af_switch(fmdev, (u8)ctrl->val);
+
+	case V4L2_CID_TUNE_DEEMPHASIS:
+		fmdbg("V4L2_CID_TUNE_DEEMPHASIS\n");
+		return fm_rx_set_deemphasis_mode(fmdev, (u8) ctrl->val);
+
 	default:
 		return -EINVAL;
 	}
@@ -319,7 +336,15 @@ static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
 	tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO |
 	((fmdev->rx.rds.flag == FM_RDS_ENABLE) ? V4L2_TUNER_SUB_RDS : 0);
 	tuner->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
-			    V4L2_TUNER_CAP_LOW;
+			    V4L2_TUNER_CAP_LOW |
+			    V4L2_TUNER_CAP_BAND_TYPE_DEFAULT |
+			    V4L2_TUNER_CAP_BAND_TYPE_EUROPE_US |
+			    V4L2_TUNER_CAP_BAND_TYPE_JAPAN |
+			    V4L2_TUNER_CAP_BAND_TYPE_RUSSIAN;
+
+	if (fmdev->asic_id > 0x1800)
+		tuner->capability = tuner->capability | V4L2_TUNER_CAP_BAND_TYPE_WEATHER;
+
 	tuner->audmode = (stereo_mono_mode ?
 			  V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO);
 
@@ -420,7 +445,7 @@ static int fm_v4l2_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 		struct v4l2_hw_freq_seek *seek)
 {
 	struct fmdev *fmdev = video_drvdata(file);
-	int ret;
+	int ret, curr_band = fmdev->rx.region.fm_band;
 
 	if (fmdev->curr_fmmode != FM_MODE_RX) {
 		ret = fmc_set_mode(fmdev, FM_MODE_RX);
@@ -430,12 +455,64 @@ static int fm_v4l2_vidioc_s_hw_freq_seek(struct file *file, void *priv,
 		}
 	}
 
-	ret = fm_rx_seek(fmdev, seek->seek_upward, seek->wrap_around,
-			seek->spacing);
-	if (ret < 0)
-		fmerr("RX seek failed - %d\n", ret);
+	if (seek->band != 0) {
+		ret = fm_rx_seek(fmdev, seek->seek_upward, seek->wrap_around,
+			seek->spacing, seek->band);
+		if (ret < 0)
+			fmerr("RX seek failed - %d\n", ret);
 
-	return ret;
+		return ret;
+	} else {
+		do {
+			ret = fm_rx_seek(fmdev, seek->seek_upward, seek->wrap_around,
+					seek->spacing, curr_band);
+			if (ret < 0)
+				fmerr("RX seek failed - %d\n", ret);
+
+			if (fmdev->rx.bl_flag != 1) {
+				return ret;
+			}
+
+			/* If reached the 162.55 or 65.8 then return the same*/
+			if (!seek->seek_upward && (fmdev->rx.region.fm_band == FM_BAND_RUSSIAN))
+				return ret;
+
+			if (seek->seek_upward && (fmdev->rx.region.fm_band == FM_BAND_WEATHER)) {
+				if (fmdev->asic_id < 0x1800) {
+					fmdev->rx.freq = FM_US_BAND_HIGH;
+					return FM_US_BAND_HIGH;
+				}
+
+				return ret;
+			}
+
+			if (seek->seek_upward) {
+				switch (fmdev->rx.region.fm_band) {
+				case FM_BAND_RUSSIAN:
+					curr_band = FM_BAND_JAPAN;
+					break;
+				case FM_BAND_JAPAN:
+					curr_band = FM_BAND_EUROPE_US;
+					break;
+				case FM_BAND_EUROPE_US:
+					curr_band = FM_BAND_WEATHER;
+					break;
+				}
+			} else {
+				switch (fmdev->rx.region.fm_band) {
+				case FM_BAND_WEATHER:
+					curr_band = FM_BAND_EUROPE_US;
+					break;
+				case FM_BAND_EUROPE_US:
+					curr_band = FM_BAND_JAPAN;
+					break;
+				case FM_BAND_JAPAN:
+					curr_band = FM_BAND_RUSSIAN;
+					break;
+				}
+			}
+		} while (1);
+	}
 }
 /* Get modulator attributes. If mode is not TX, return no attributes. */
 static int fm_v4l2_vidioc_g_modulator(struct file *file, void *priv,
@@ -596,6 +673,9 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
 			V4L2_CID_RDS_TX_RADIO_TEXT, 0, 0xff, 1, 0);
 
+	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
+			V4L2_CID_RDS_TX_AF_FREQ, 76000, 180000, 1, 87500);
+
 	v4l2_ctrl_new_std_menu(&fmdev->ctrl_handler, &fm_ctrl_ops,
 			V4L2_CID_TUNE_PREEMPHASIS, V4L2_PREEMPHASIS_75_uS,
 			0, V4L2_PREEMPHASIS_75_uS);
@@ -611,6 +691,13 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	if (ctrl)
 		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
 
+	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
+			V4L2_CID_RDS_AF_SWITCH, 0, 1, 1, 0);
+
+	v4l2_ctrl_new_std_menu(&fmdev->ctrl_handler, &fm_ctrl_ops,
+			V4L2_CID_TUNE_PREEMPHASIS, V4L2_PREEMPHASIS_75_uS,
+			0, V4L2_PREEMPHASIS_75_uS);
+
 	return 0;
 }
 
-- 
1.7.4.1

