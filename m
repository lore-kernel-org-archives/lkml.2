Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab2EURM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:12:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60776 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2EURML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:12:11 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V7 5/5] WL12xx: Add support for FM new features
Date: Mon, 21 May 2012 12:12:06 -0500
Message-ID: <1337620326-18593-6-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1337620326-18593-1-git-send-email-manjunatha_halli@ti.com>
References: <1337620326-18593-1-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

This patch adds below features to TI's V4l2 FM driver for Wilink
chipsets,

	1) FM RX RDS AF turn ON/OFF
	2) FM RX De-Emphasis mode set/get
	3) FM TX Alternate Frequency set/get

Also this patch fixes below issues

	1) FM audio volume gain setting
	2) Default rssi level is set to	8 instead of 20
	3) Enable FM RX AF support in driver
	4) In wrap_around seek mode try for once

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/media/radio/wl128x/fmdrv.h        |    2 +-
 drivers/media/radio/wl128x/fmdrv_common.c |   13 +++++++------
 drivers/media/radio/wl128x/fmdrv_common.h |   10 +++++++---
 drivers/media/radio/wl128x/fmdrv_rx.c     |   11 +++++++++--
 drivers/media/radio/wl128x/fmdrv_v4l2.c   |   27 +++++++++++++++++++++++++++
 5 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index d84ad9d..e1a3c78 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -203,7 +203,7 @@ struct fmtx_data {
 struct fmdev {
 	struct video_device *radio_dev;	/* V4L2 video device pointer */
 	struct snd_card *card;	/* Card which holds FM mixer controls */
-	u16 asci_id;
+	u16 asic_id;
 	spinlock_t rds_buff_lock; /* To protect access to RDS buffer */
 	spinlock_t resp_skb_lock; /* To protect access to received SKB */
 
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index fcce61a..9ab7a63 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -596,7 +596,6 @@ static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
 	memcpy(&fmdev->irq_info.flag, skb->data, fm_evt_hdr->dlen);
 
 	fmdev->irq_info.flag = be16_to_cpu(fmdev->irq_info.flag);
-	fmdbg("irq: flag register(0x%x)\n", fmdev->irq_info.flag);
 
 	/* Continue next function in interrupt handler table */
 	fm_irq_call_stage(fmdev, FM_HW_MAL_FUNC_IDX);
@@ -702,7 +701,7 @@ static void fm_rdsparse_swapbytes(struct fmdev *fmdev,
 	 * in Dolphin they are in big endian, the parsing of the RDS data
 	 * is chip dependent
 	 */
-	if (fmdev->asci_id != 0x6350) {
+	if (fmdev->asic_id != 0x6350) {
 		rds_buff = &rds_format->data.groupdatabuff.buff[0];
 		while (index + 1 < FM_RX_RDS_INFO_FIELD_MAX) {
 			byte1 = rds_buff[index];
@@ -1353,11 +1352,13 @@ static int fm_power_up(struct fmdev *fmdev, u8 mode)
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
@@ -1366,7 +1367,7 @@ static int fm_power_up(struct fmdev *fmdev, u8 mode)
 	}
 	sprintf(fw_name, "%s_%x.%d.bts", (mode == FM_MODE_RX) ?
 			FM_RX_FW_FILE_START : FM_TX_FW_FILE_START,
-			be16_to_cpu(asic_id), be16_to_cpu(asic_ver));
+			fmdev->asic_id, be16_to_cpu(asic_ver));
 
 	ret = fm_download_firmware(fmdev, fw_name);
 	if (ret < 0) {
@@ -1576,7 +1577,7 @@ int fmc_prepare(struct fmdev *fmdev)
 	fmdev->rx.rds.flag = FM_RDS_DISABLE;
 	fmdev->rx.freq = FM_UNDEFINED_FREQ;
 	fmdev->rx.rds_mode = FM_RDS_SYSTEM_RDS;
-	fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_OFF;
+	fmdev->rx.af_mode = FM_RX_RDS_AF_SWITCH_MODE_ON;
 	fmdev->irq_info.retry = 0;
 
 	fmdev->tx_data.tx_frq = FM_UNDEFINED_FREQ;
diff --git a/drivers/media/radio/wl128x/fmdrv_common.h b/drivers/media/radio/wl128x/fmdrv_common.h
index 196ff7d..a57c662 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.h
+++ b/drivers/media/radio/wl128x/fmdrv_common.h
@@ -201,8 +201,8 @@ struct fm_event_msg_hdr {
 #define FM_UNDEFINED_FREQ		   0xFFFFFFFF
 
 /* Band types */
-#define FM_BAND_EUROPE_US	0
-#define FM_BAND_JAPAN		1
+#define FM_BAND_EUROPE_US      0
+#define FM_BAND_JAPAN          1
 
 /* Seek directions */
 #define FM_SEARCH_DIRECTION_DOWN	0
@@ -213,6 +213,10 @@ struct fm_event_msg_hdr {
 #define FM_TUNER_PRESET_MODE		1
 #define FM_TUNER_AUTONOMOUS_SEARCH_MODE	2
 #define FM_TUNER_AF_JUMP_MODE		3
+#define FM_TUNER_PI_MATCH_MODE		4
+#define FM_TUNER_BULK_SEARCH_MODE	5
+#define FM_TUNER_WRAP_SEARCH_MODE	6
+#define FM_TUNER_WEATHER_MODE		7
 
 /* Min and Max volume */
 #define FM_RX_VOLUME_MIN	0
@@ -353,7 +357,7 @@ struct fm_event_msg_hdr {
  * with this default values after loading RX firmware.
  */
 #define FM_DEFAULT_RX_VOLUME		10
-#define FM_DEFAULT_RSSI_THRESHOLD	20
+#define FM_DEFAULT_RSSI_THRESHOLD	8
 
 /* Range for TX power level in units for dB/uV */
 #define FM_PWR_LVL_LOW			91
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index a806bda..aae4e6d 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -276,6 +276,10 @@ again:
 			/* Calculate frequency index to write */
 			next_frq = (fmdev->rx.freq -
 					fmdev->rx.region.bot_freq) / FM_FREQ_MUL;
+
+			/* If no valid chanel then report default frequency */
+			wrap_around = 0;
+
 			goto again;
 		}
 	} else {
@@ -636,8 +640,11 @@ int fm_rx_set_deemphasis_mode(struct fmdev *fmdev, u16 mode)
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
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 494faaf..22ffb39 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -258,6 +258,22 @@ static int fm_v4l2_s_ctrl(struct v4l2_ctrl *ctrl)
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
@@ -320,6 +336,7 @@ static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
 	((fmdev->rx.rds.flag == FM_RDS_ENABLE) ? V4L2_TUNER_SUB_RDS : 0);
 	tuner->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
 			    V4L2_TUNER_CAP_LOW;
+
 	tuner->audmode = (stereo_mono_mode ?
 			  V4L2_TUNER_MODE_MONO : V4L2_TUNER_MODE_STEREO);
 
@@ -596,6 +613,9 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
 			V4L2_CID_RDS_TX_RADIO_TEXT, 0, 0xff, 1, 0);
 
+	v4l2_ctrl_new_std(&fmdev->ctrl_handler, &fm_ctrl_ops,
+			V4L2_CID_RDS_TX_AF_FREQ, 76000, 180000, 1, 87500);
+
 	v4l2_ctrl_new_std_menu(&fmdev->ctrl_handler, &fm_ctrl_ops,
 			V4L2_CID_TUNE_PREEMPHASIS, V4L2_PREEMPHASIS_75_uS,
 			0, V4L2_PREEMPHASIS_75_uS);
@@ -611,6 +631,13 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
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

