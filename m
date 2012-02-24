Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab2BXUP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:15:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52121 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab2BXUOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:14:33 -0500
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <shahed@ti.com>, <linux-kernel@vger.kernel.org>,
        Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH 2/3] wl128x: Add support for FM TX RDS
Date: Fri, 24 Feb 2012 14:14:30 -0600
Message-ID: <1330114471-26435-3-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1330114471-26435-2-git-send-email-manjunatha_halli@ti.com>
References: <1330114471-26435-1-git-send-email-manjunatha_halli@ti.com>
 <1330114471-26435-2-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

This patch adds support for following FM TX RDS features,
     1. Radio Text
     2. PS Name
     3. PI Code
     4. PTY Code.

Along with above this patch fixes few other minor issues(like
fm tx get frequency, unnecessary error messages etc).

Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c |   17 +++++++---
 drivers/media/radio/wl128x/fmdrv_common.h |   17 +++++++----
 drivers/media/radio/wl128x/fmdrv_rx.c     |    2 +-
 drivers/media/radio/wl128x/fmdrv_tx.c     |   41 ++++++++++---------------
 drivers/media/radio/wl128x/fmdrv_tx.h     |    3 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c   |   47 +++++++++++++++++++++++++++++
 6 files changed, 90 insertions(+), 37 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index bf867a6..fcce61a 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -354,7 +354,7 @@ static void send_tasklet(unsigned long arg)
 
 	/* Check, is there any timeout happened to last transmitted packet */
 	if ((jiffies - fmdev->last_tx_jiffies) > FM_DRV_TX_TIMEOUT) {
-		fmerr("TX timeout occurred\n");
+		fmdbg("TX timeout occurred\n");
 		atomic_set(&fmdev->tx_cnt, 1);
 	}
 
@@ -615,7 +615,11 @@ static void fm_irq_handle_rds_start(struct fmdev *fmdev)
 {
 	if (fmdev->irq_info.flag & FM_RDS_EVENT & fmdev->irq_info.mask) {
 		fmdbg("irq: rds threshold reached\n");
-		fmdev->irq_info.stage = FM_RDS_SEND_RDS_GETCMD_IDX;
+		/* If RSSI reached below threshold then dont get RDS data */
+		if (fmdev->irq_info.flag & FM_LEV_EVENT)
+			fmdev->irq_info.stage = FM_HW_TUNE_OP_ENDED_IDX;
+		else
+			fmdev->irq_info.stage = FM_RDS_SEND_RDS_GETCMD_IDX;
 	} else {
 		/* Continue next function in interrupt handler table */
 		fmdev->irq_info.stage = FM_HW_TUNE_OP_ENDED_IDX;
@@ -1129,8 +1133,9 @@ int fmc_set_freq(struct fmdev *fmdev, u32 freq_to_set)
 
 int fmc_get_freq(struct fmdev *fmdev, u32 *cur_tuned_frq)
 {
-	if (fmdev->rx.freq == FM_UNDEFINED_FREQ) {
-		fmerr("RX frequency is not set\n");
+	if (fmdev->rx.freq == FM_UNDEFINED_FREQ &&
+			fmdev->tx_data.tx_frq == FM_UNDEFINED_FREQ) {
+		fmerr("RX/TX frequency is not set\n");
 		return -EPERM;
 	}
 	if (cur_tuned_frq == NULL) {
@@ -1144,7 +1149,7 @@ int fmc_get_freq(struct fmdev *fmdev, u32 *cur_tuned_frq)
 		return 0;
 
 	case FM_MODE_TX:
-		*cur_tuned_frq = 0;	/* TODO : Change this later */
+		*cur_tuned_frq = fmdev->tx_data.tx_frq;
 		return 0;
 
 	default:
@@ -1574,6 +1579,8 @@ int fmc_prepare(struct fmdev *fmdev)
 	fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_OFF;
 	fmdev->irq_info.retry = 0;
 
+	fmdev->tx_data.tx_frq = FM_UNDEFINED_FREQ;
+
 	fm_rx_reset_rds_cache(fmdev);
 	init_waitqueue_head(&fmdev->rx.rds.read_queue);
 
diff --git a/drivers/media/radio/wl128x/fmdrv_common.h b/drivers/media/radio/wl128x/fmdrv_common.h
index d9b9c6c..196ff7d 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.h
+++ b/drivers/media/radio/wl128x/fmdrv_common.h
@@ -48,8 +48,8 @@ struct fm_reg_table {
 #define SEARCH_LVL_SET           15
 #define BAND_SET                 16
 #define MUTE_STATUS_SET          17
-#define RDS_PAUSE_LVL_SET        18
-#define RDS_PAUSE_DUR_SET        19
+#define AUD_PAUSE_LVL_SET        18
+#define AUD_PAUSE_DUR_SET        19
 #define RDS_MEM_SET              20
 #define RDS_BLK_B_SET            21
 #define RDS_MSK_B_SET            22
@@ -84,11 +84,12 @@ struct fm_reg_table {
 
 #define FM_POWER_MODE            254
 #define FM_INTERRUPT             255
+#define STATION_VALID		 123
 
 /* Transmitter API */
 
 #define CHANL_SET                55
-#define CHANL_BW_SET		56
+#define SCAN_SPACING_SET         56
 #define REF_SET                  57
 #define POWER_ENB_SET            90
 #define POWER_ATT_SET            58
@@ -103,7 +104,8 @@ struct fm_reg_table {
 #define MONO_SET                 66
 #define MUTE                     92
 #define MPX_LMT_ENABLE           67
-#define PI_SET                   93
+#define REF_ERR_SET		 93
+#define PI_SET                   68
 #define ECC_SET                  69
 #define PTY                      70
 #define AF                       71
@@ -120,6 +122,10 @@ struct fm_reg_table {
 #define TX_AUDIO_LEVEL_TEST      96
 #define TX_AUDIO_LEVEL_TEST_THRESHOLD    73
 #define TX_AUDIO_INPUT_LEVEL_RANGE_SET   54
+#define TX_AUDIO_LEVEL_GET		 7
+#define READ_FMANT_TUNE_VALUE            104
+
+/* New FM APIs (Rx and Tx) */
 #define RX_ANTENNA_SELECT        87
 #define I2C_DEV_ADDR_SET         86
 #define REF_ERR_CALIB_PARAM_SET          88
@@ -131,7 +137,6 @@ struct fm_reg_table {
 #define RSSI_BLOCK_SCAN_FREQ_SET 95
 #define RSSI_BLOCK_SCAN_START    97
 #define RSSI_BLOCK_SCAN_DATA_GET  5
-#define READ_FMANT_TUNE_VALUE            104
 
 /* SKB helpers */
 struct fm_skb_cb {
@@ -348,7 +353,7 @@ struct fm_event_msg_hdr {
  * with this default values after loading RX firmware.
  */
 #define FM_DEFAULT_RX_VOLUME		10
-#define FM_DEFAULT_RSSI_THRESHOLD	3
+#define FM_DEFAULT_RSSI_THRESHOLD	20
 
 /* Range for TX power level in units for dB/uV */
 #define FM_PWR_LVL_LOW			91
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index 43fb722..a806bda 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -156,7 +156,7 @@ static int fm_rx_set_channel_spacing(struct fmdev *fmdev, u32 spacing)
 
 	/* set channel spacing */
 	payload = spacing;
-	ret = fmc_send_cmd(fmdev, CHANL_BW_SET, REG_WR, &payload,
+	ret = fmc_send_cmd(fmdev, SCAN_SPACING_SET, REG_WR, &payload,
 			sizeof(payload), NULL, NULL);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/radio/wl128x/fmdrv_tx.c b/drivers/media/radio/wl128x/fmdrv_tx.c
index 6ea33e0..6d879fb 100644
--- a/drivers/media/radio/wl128x/fmdrv_tx.c
+++ b/drivers/media/radio/wl128x/fmdrv_tx.c
@@ -51,6 +51,7 @@ static int set_rds_text(struct fmdev *fmdev, u8 *rds_text)
 	u16 payload;
 	int ret;
 
+	*(u16 *)rds_text = cpu_to_be16(*(u16 *)rds_text);
 	ret = fmc_send_cmd(fmdev, RDS_DATA_SET, REG_WR, rds_text,
 			strlen(rds_text), NULL, NULL);
 	if (ret < 0)
@@ -66,26 +67,31 @@ static int set_rds_text(struct fmdev *fmdev, u8 *rds_text)
 	return 0;
 }
 
-static int set_rds_data_mode(struct fmdev *fmdev, u8 mode)
+int set_rds_picode(struct fmdev *fmdev, u16 pi_val)
 {
 	u16 payload;
 	int ret;
 
-	/* Setting unique PI TODO: how unique? */
-	payload = (u16)0xcafe;
+	payload = pi_val;
 	ret = fmc_send_cmd(fmdev, PI_SET, REG_WR, &payload,
 			sizeof(payload), NULL, NULL);
 	if (ret < 0)
 		return ret;
 
-	/* Set decoder id */
-	payload = (u16)0xa;
-	ret = fmc_send_cmd(fmdev, DI_SET, REG_WR, &payload,
+	return 0;
+}
+
+int set_rds_pty(struct fmdev *fmdev, u16 pty)
+{
+	u16 payload;
+	u32 ret;
+
+	payload = pty;
+	ret = fmc_send_cmd(fmdev, PTY, REG_WR, &payload,
 			sizeof(payload), NULL, NULL);
 	if (ret < 0)
 		return ret;
 
-	/* TODO: RDS_MODE_GET? */
 	return 0;
 }
 
@@ -101,7 +107,6 @@ static int set_rds_len(struct fmdev *fmdev, u8 type, u16 len)
 	if (ret < 0)
 		return ret;
 
-	/* TODO: LENGTH_GET? */
 	return 0;
 }
 
@@ -109,20 +114,17 @@ int fm_tx_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
 {
 	u16 payload;
 	int ret;
-	u8 rds_text[] = "Zoom2\n";
+	u8 rds_text[] = "WL12XX Radio\n";
 
 	fmdbg("rds_en_dis:%d(E:%d, D:%d)\n", rds_en_dis,
 		   FM_RDS_ENABLE, FM_RDS_DISABLE);
 
 	if (rds_en_dis == FM_RDS_ENABLE) {
 		/* Set RDS length */
-		set_rds_len(fmdev, 0, strlen(rds_text));
+		set_rds_len(fmdev, 2, strlen(rds_text));
 
 		/* Set RDS text */
 		set_rds_text(fmdev, rds_text);
-
-		/* Set RDS mode */
-		set_rds_data_mode(fmdev, 0x0);
 	}
 
 	/* Send command to enable RDS */
@@ -136,13 +138,6 @@ int fm_tx_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
 	if (ret < 0)
 		return ret;
 
-	if (rds_en_dis == FM_RDS_ENABLE) {
-		/* Set RDS length */
-		set_rds_len(fmdev, 0, strlen(rds_text));
-
-		/* Set RDS text */
-		set_rds_text(fmdev, rds_text);
-	}
 	fmdev->tx_data.rds.flag = rds_en_dis;
 
 	return 0;
@@ -156,7 +151,6 @@ int fm_tx_set_radio_text(struct fmdev *fmdev, u8 *rds_text, u8 rds_type)
 	if (fmdev->curr_fmmode != FM_MODE_TX)
 		return -EPERM;
 
-	fm_tx_set_rds_mode(fmdev, 0);
 
 	/* Set RDS length */
 	set_rds_len(fmdev, rds_type, strlen(rds_text));
@@ -164,9 +158,6 @@ int fm_tx_set_radio_text(struct fmdev *fmdev, u8 *rds_text, u8 rds_type)
 	/* Set RDS text */
 	set_rds_text(fmdev, rds_text);
 
-	/* Set RDS mode */
-	set_rds_data_mode(fmdev, 0x0);
-
 	payload = 1;
 	ret = fmc_send_cmd(fmdev, RDS_DATA_ENB, REG_WR, &payload,
 			sizeof(payload), NULL, NULL);
@@ -421,6 +412,8 @@ int fm_tx_set_freq(struct fmdev *fmdev, u32 freq_to_set)
 	tx->aud_mode = FM_STEREO_MODE;
 	tx->rds.flag = FM_RDS_DISABLE;
 
+	tx->tx_frq = freq_to_set * 1000; /* in KHz */
+
 	return 0;
 }
 
diff --git a/drivers/media/radio/wl128x/fmdrv_tx.h b/drivers/media/radio/wl128x/fmdrv_tx.h
index 11ae2e4..8ed71bd 100644
--- a/drivers/media/radio/wl128x/fmdrv_tx.h
+++ b/drivers/media/radio/wl128x/fmdrv_tx.h
@@ -32,6 +32,7 @@ int fm_tx_set_radio_text(struct fmdev *, u8 *, u8);
 int fm_tx_set_af(struct fmdev *, u32);
 int fm_tx_set_preemph_filter(struct fmdev *, u32);
 int fm_tx_get_tune_cap_val(struct fmdev *);
-
+int set_rds_picode(struct fmdev *, u16);
+int set_rds_pty(struct fmdev *, u16);
 #endif
 
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 077d369..b9da1ae 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -210,6 +210,8 @@ static int fm_v4l2_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct fmdev *fmdev = container_of(ctrl->handler,
 			struct fmdev, ctrl_handler);
 
+	int ret;
+
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:	/* set volume */
 		return fm_rx_set_volume(fmdev, (u16)ctrl->val);
@@ -224,6 +226,38 @@ static int fm_v4l2_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_TUNE_PREEMPHASIS:
 		return fm_tx_set_preemph_filter(fmdev, (u8) ctrl->val);
 
+	case V4L2_CID_RDS_TX_PI:
+		ret = set_rds_picode(fmdev, ctrl->val);
+		if (ret < 0) {
+			fmerr("Failed to set RDS Radio PS Name\n");
+			return ret;
+		}
+		return 0;
+
+	case V4L2_CID_RDS_TX_PTY:
+		ret = set_rds_pty(fmdev, ctrl->val);
+		if (ret < 0) {
+			fmerr("Failed to set RDS Radio PS Name\n");
+			return ret;
+		}
+		return 0;
+
+	case V4L2_CID_RDS_TX_PS_NAME:
+		ret = fm_tx_set_radio_text(fmdev, ctrl->string, 1);
+		if (ret < 0) {
+			fmerr("Failed to set RDS Radio PS Name\n");
+			return ret;
+		}
+		return 0;
+
+	case V4L2_CID_RDS_TX_RADIO_TEXT:
+		ret = fm_tx_set_radio_text(fmdev, ctrl->string, 2);
+		if (ret < 0) {
+			fmerr("Failed to set RDS Radio Text\n");
+			return ret;
+		}
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -455,6 +489,7 @@ static int fm_v4l2_vidioc_s_modulator(struct file *file, void *priv,
 		fmerr("Failed to set mono/stereo mode for TX\n");
 		return ret;
 	}
+
 	ret = fm_tx_set_rds_mode(fmdev, rds_mode);
 	if (ret < 0)
 		fmerr("Failed to set rds mode for TX\n");
@@ -549,6 +584,18 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
 			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
 
+	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
+			V4L2_CID_RDS_TX_PI, 0x0, 0xffff, 1, 0x0);
+
+	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
+			V4L2_CID_RDS_TX_PTY, 0, 32, 1, 0);
+
+	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
+			V4L2_CID_RDS_TX_PS_NAME, 0, 0xffff, 1, 0);
+
+	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
+			V4L2_CID_RDS_TX_RADIO_TEXT, 0, 0xffff, 1, 0);
+
 	v4l2_ctrl_new_std_menu(&fmdev->ctrl_handler, &fm_ctrl_ops,
 			V4L2_CID_TUNE_PREEMPHASIS, V4L2_PREEMPHASIS_75_uS,
 			0, V4L2_PREEMPHASIS_75_uS);
-- 
1.7.4.1

