Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1LBKDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:03:42 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:48579 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1LBKDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:03:34 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 2/3] wl128x: fmdrv_rx: fix signedness bugs
Date: Fri,  2 Dec 2011 05:01:12 -0500
Message-Id: <1322820073-19347-3-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322820073-19347-1-git-send-email-xi.wang@gmail.com>
References: <1322820073-19347-1-git-send-email-xi.wang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error handling with (ret < 0) didn't work where ret is a u32.
Use int instead.  To be consistent we also change the functions to
return an int.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/media/radio/wl128x/fmdrv_rx.c |   84 +++++++++++++++++----------------
 drivers/media/radio/wl128x/fmdrv_rx.h |   50 ++++++++++----------
 2 files changed, 68 insertions(+), 66 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_rx.c b/drivers/media/radio/wl128x/fmdrv_rx.c
index ec529b5..43fb722 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.c
+++ b/drivers/media/radio/wl128x/fmdrv_rx.c
@@ -43,12 +43,13 @@ void fm_rx_reset_station_info(struct fmdev *fmdev)
 	fmdev->rx.stat_info.af_list_max = 0;
 }
 
-u32 fm_rx_set_freq(struct fmdev *fmdev, u32 freq)
+int fm_rx_set_freq(struct fmdev *fmdev, u32 freq)
 {
 	unsigned long timeleft;
 	u16 payload, curr_frq, intr_flag;
 	u32 curr_frq_in_khz;
-	u32 ret, resp_len;
+	u32 resp_len;
+	int ret;
 
 	if (freq < fmdev->rx.region.bot_freq || freq > fmdev->rx.region.top_freq) {
 		fmerr("Invalid frequency %d\n", freq);
@@ -141,10 +142,10 @@ exit:
 	return ret;
 }
 
-static u32 fm_rx_set_channel_spacing(struct fmdev *fmdev, u32 spacing)
+static int fm_rx_set_channel_spacing(struct fmdev *fmdev, u32 spacing)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (spacing > 0 && spacing <= 50000)
 		spacing = FM_CHANNEL_SPACING_50KHZ;
@@ -165,7 +166,7 @@ static u32 fm_rx_set_channel_spacing(struct fmdev *fmdev, u32 spacing)
 	return ret;
 }
 
-u32 fm_rx_seek(struct fmdev *fmdev, u32 seek_upward,
+int fm_rx_seek(struct fmdev *fmdev, u32 seek_upward,
 		u32 wrap_around, u32 spacing)
 {
 	u32 resp_len;
@@ -173,7 +174,7 @@ u32 fm_rx_seek(struct fmdev *fmdev, u32 seek_upward,
 	u16 payload, int_reason, intr_flag;
 	u16 offset, space_idx;
 	unsigned long timeleft;
-	u32 ret;
+	int ret;
 
 	/* Set channel spacing */
 	ret = fm_rx_set_channel_spacing(fmdev, spacing);
@@ -296,10 +297,10 @@ again:
 	return ret;
 }
 
-u32 fm_rx_set_volume(struct fmdev *fmdev, u16 vol_to_set)
+int fm_rx_set_volume(struct fmdev *fmdev, u16 vol_to_set)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -322,7 +323,7 @@ u32 fm_rx_set_volume(struct fmdev *fmdev, u16 vol_to_set)
 }
 
 /* Get volume */
-u32 fm_rx_get_volume(struct fmdev *fmdev, u16 *curr_vol)
+int fm_rx_get_volume(struct fmdev *fmdev, u16 *curr_vol)
 {
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -338,7 +339,7 @@ u32 fm_rx_get_volume(struct fmdev *fmdev, u16 *curr_vol)
 }
 
 /* To get current band's bottom and top frequency */
-u32 fm_rx_get_band_freq_range(struct fmdev *fmdev, u32 *bot_freq, u32 *top_freq)
+int fm_rx_get_band_freq_range(struct fmdev *fmdev, u32 *bot_freq, u32 *top_freq)
 {
 	if (bot_freq != NULL)
 		*bot_freq = fmdev->rx.region.bot_freq;
@@ -356,11 +357,11 @@ void fm_rx_get_region(struct fmdev *fmdev, u8 *region)
 }
 
 /* Sets band (0-Europe/US; 1-Japan) */
-u32 fm_rx_set_region(struct fmdev *fmdev, u8 region_to_set)
+int fm_rx_set_region(struct fmdev *fmdev, u8 region_to_set)
 {
 	u16 payload;
 	u32 new_frq = 0;
-	u32 ret;
+	int ret;
 
 	if (region_to_set != FM_BAND_EUROPE_US &&
 	    region_to_set != FM_BAND_JAPAN) {
@@ -399,7 +400,7 @@ u32 fm_rx_set_region(struct fmdev *fmdev, u8 region_to_set)
 }
 
 /* Reads current mute mode (Mute Off/On/Attenuate)*/
-u32 fm_rx_get_mute_mode(struct fmdev *fmdev, u8 *curr_mute_mode)
+int fm_rx_get_mute_mode(struct fmdev *fmdev, u8 *curr_mute_mode)
 {
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -414,10 +415,10 @@ u32 fm_rx_get_mute_mode(struct fmdev *fmdev, u8 *curr_mute_mode)
 	return 0;
 }
 
-static u32 fm_config_rx_mute_reg(struct fmdev *fmdev)
+static int fm_config_rx_mute_reg(struct fmdev *fmdev)
 {
 	u16 payload, muteval;
-	u32 ret;
+	int ret;
 
 	muteval = 0;
 	switch (fmdev->rx.mute_mode) {
@@ -448,10 +449,10 @@ static u32 fm_config_rx_mute_reg(struct fmdev *fmdev)
 }
 
 /* Configures mute mode (Mute Off/On/Attenuate) */
-u32 fm_rx_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
+int fm_rx_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
 {
 	u8 org_state;
-	u32 ret;
+	int ret;
 
 	if (fmdev->rx.mute_mode == mute_mode_toset)
 		return 0;
@@ -469,7 +470,7 @@ u32 fm_rx_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
 }
 
 /* Gets RF dependent soft mute mode enable/disable status */
-u32 fm_rx_get_rfdepend_softmute(struct fmdev *fmdev, u8 *curr_mute_mode)
+int fm_rx_get_rfdepend_softmute(struct fmdev *fmdev, u8 *curr_mute_mode)
 {
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -485,10 +486,10 @@ u32 fm_rx_get_rfdepend_softmute(struct fmdev *fmdev, u8 *curr_mute_mode)
 }
 
 /* Sets RF dependent soft mute mode */
-u32 fm_rx_set_rfdepend_softmute(struct fmdev *fmdev, u8 rfdepend_mute)
+int fm_rx_set_rfdepend_softmute(struct fmdev *fmdev, u8 rfdepend_mute)
 {
 	u8 org_state;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -514,11 +515,11 @@ u32 fm_rx_set_rfdepend_softmute(struct fmdev *fmdev, u8 rfdepend_mute)
 }
 
 /* Returns the signal strength level of current channel */
-u32 fm_rx_get_rssi_level(struct fmdev *fmdev, u16 *rssilvl)
+int fm_rx_get_rssi_level(struct fmdev *fmdev, u16 *rssilvl)
 {
 	u16 curr_rssi_lel;
 	u32 resp_len;
-	u32 ret;
+	int ret;
 
 	if (rssilvl == NULL) {
 		fmerr("Invalid memory\n");
@@ -539,10 +540,10 @@ u32 fm_rx_get_rssi_level(struct fmdev *fmdev, u16 *rssilvl)
  * Sets the signal strength level that once reached
  * will stop the auto search process
  */
-u32 fm_rx_set_rssi_threshold(struct fmdev *fmdev, short rssi_lvl_toset)
+int fm_rx_set_rssi_threshold(struct fmdev *fmdev, short rssi_lvl_toset)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (rssi_lvl_toset < FM_RX_RSSI_THRESHOLD_MIN ||
 			rssi_lvl_toset > FM_RX_RSSI_THRESHOLD_MAX) {
@@ -561,7 +562,7 @@ u32 fm_rx_set_rssi_threshold(struct fmdev *fmdev, short rssi_lvl_toset)
 }
 
 /* Returns current RX RSSI threshold value */
-u32 fm_rx_get_rssi_threshold(struct fmdev *fmdev, short *curr_rssi_lvl)
+int fm_rx_get_rssi_threshold(struct fmdev *fmdev, short *curr_rssi_lvl)
 {
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -577,10 +578,10 @@ u32 fm_rx_get_rssi_threshold(struct fmdev *fmdev, short *curr_rssi_lvl)
 }
 
 /* Sets RX stereo/mono modes */
-u32 fm_rx_set_stereo_mono(struct fmdev *fmdev, u16 mode)
+int fm_rx_set_stereo_mono(struct fmdev *fmdev, u16 mode)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (mode != FM_STEREO_MODE && mode != FM_MONO_MODE) {
 		fmerr("Invalid mode\n");
@@ -605,10 +606,11 @@ u32 fm_rx_set_stereo_mono(struct fmdev *fmdev, u16 mode)
 }
 
 /* Gets current RX stereo/mono mode */
-u32 fm_rx_get_stereo_mono(struct fmdev *fmdev, u16 *mode)
+int fm_rx_get_stereo_mono(struct fmdev *fmdev, u16 *mode)
 {
 	u16 curr_mode;
-	u32 ret, resp_len;
+	u32 resp_len;
+	int ret;
 
 	if (mode == NULL) {
 		fmerr("Invalid memory\n");
@@ -626,10 +628,10 @@ u32 fm_rx_get_stereo_mono(struct fmdev *fmdev, u16 *mode)
 }
 
 /* Choose RX de-emphasis filter mode (50us/75us) */
-u32 fm_rx_set_deemphasis_mode(struct fmdev *fmdev, u16 mode)
+int fm_rx_set_deemphasis_mode(struct fmdev *fmdev, u16 mode)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -652,7 +654,7 @@ u32 fm_rx_set_deemphasis_mode(struct fmdev *fmdev, u16 mode)
 }
 
 /* Gets current RX de-emphasis filter mode */
-u32 fm_rx_get_deemph_mode(struct fmdev *fmdev, u16 *curr_deemphasis_mode)
+int fm_rx_get_deemph_mode(struct fmdev *fmdev, u16 *curr_deemphasis_mode)
 {
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -668,10 +670,10 @@ u32 fm_rx_get_deemph_mode(struct fmdev *fmdev, u16 *curr_deemphasis_mode)
 }
 
 /* Enable/Disable RX RDS */
-u32 fm_rx_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
+int fm_rx_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (rds_en_dis != FM_RDS_ENABLE && rds_en_dis != FM_RDS_DISABLE) {
 		fmerr("Invalid rds option\n");
@@ -743,7 +745,7 @@ u32 fm_rx_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
 }
 
 /* Returns current RX RDS enable/disable status */
-u32 fm_rx_get_rds_mode(struct fmdev *fmdev, u8 *curr_rds_en_dis)
+int fm_rx_get_rds_mode(struct fmdev *fmdev, u8 *curr_rds_en_dis)
 {
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -759,10 +761,10 @@ u32 fm_rx_get_rds_mode(struct fmdev *fmdev, u8 *curr_rds_en_dis)
 }
 
 /* Sets RDS operation mode (RDS/RDBS) */
-u32 fm_rx_set_rds_system(struct fmdev *fmdev, u8 rds_mode)
+int fm_rx_set_rds_system(struct fmdev *fmdev, u8 rds_mode)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -784,7 +786,7 @@ u32 fm_rx_set_rds_system(struct fmdev *fmdev, u8 rds_mode)
 }
 
 /* Returns current RDS operation mode */
-u32 fm_rx_get_rds_system(struct fmdev *fmdev, u8 *rds_mode)
+int fm_rx_get_rds_system(struct fmdev *fmdev, u8 *rds_mode)
 {
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -800,10 +802,10 @@ u32 fm_rx_get_rds_system(struct fmdev *fmdev, u8 *rds_mode)
 }
 
 /* Configures Alternate Frequency switch mode */
-u32 fm_rx_set_af_switch(struct fmdev *fmdev, u8 af_mode)
+int fm_rx_set_af_switch(struct fmdev *fmdev, u8 af_mode)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
@@ -831,7 +833,7 @@ u32 fm_rx_set_af_switch(struct fmdev *fmdev, u8 af_mode)
 }
 
 /* Returns Alternate Frequency switch status */
-u32 fm_rx_get_af_switch(struct fmdev *fmdev, u8 *af_mode)
+int fm_rx_get_af_switch(struct fmdev *fmdev, u8 *af_mode)
 {
 	if (fmdev->curr_fmmode != FM_MODE_RX)
 		return -EPERM;
diff --git a/drivers/media/radio/wl128x/fmdrv_rx.h b/drivers/media/radio/wl128x/fmdrv_rx.h
index 329e62f..32add81 100644
--- a/drivers/media/radio/wl128x/fmdrv_rx.h
+++ b/drivers/media/radio/wl128x/fmdrv_rx.h
@@ -22,38 +22,38 @@
 #ifndef _FMDRV_RX_H
 #define _FMDRV_RX_H
 
-u32 fm_rx_set_freq(struct fmdev *, u32);
-u32 fm_rx_set_mute_mode(struct fmdev *, u8);
-u32 fm_rx_set_stereo_mono(struct fmdev *, u16);
-u32 fm_rx_set_rds_mode(struct fmdev *, u8);
-u32 fm_rx_set_rds_system(struct fmdev *, u8);
-u32 fm_rx_set_volume(struct fmdev *, u16);
-u32 fm_rx_set_rssi_threshold(struct fmdev *, short);
-u32 fm_rx_set_region(struct fmdev *, u8);
-u32 fm_rx_set_rfdepend_softmute(struct fmdev *, u8);
-u32 fm_rx_set_deemphasis_mode(struct fmdev *, u16);
-u32 fm_rx_set_af_switch(struct fmdev *, u8);
+int fm_rx_set_freq(struct fmdev *, u32);
+int fm_rx_set_mute_mode(struct fmdev *, u8);
+int fm_rx_set_stereo_mono(struct fmdev *, u16);
+int fm_rx_set_rds_mode(struct fmdev *, u8);
+int fm_rx_set_rds_system(struct fmdev *, u8);
+int fm_rx_set_volume(struct fmdev *, u16);
+int fm_rx_set_rssi_threshold(struct fmdev *, short);
+int fm_rx_set_region(struct fmdev *, u8);
+int fm_rx_set_rfdepend_softmute(struct fmdev *, u8);
+int fm_rx_set_deemphasis_mode(struct fmdev *, u16);
+int fm_rx_set_af_switch(struct fmdev *, u8);
 
 void fm_rx_reset_rds_cache(struct fmdev *);
 void fm_rx_reset_station_info(struct fmdev *);
 
-u32 fm_rx_seek(struct fmdev *, u32, u32, u32);
+int fm_rx_seek(struct fmdev *, u32, u32, u32);
 
-u32 fm_rx_get_rds_mode(struct fmdev *, u8 *);
-u32 fm_rx_get_rds_system(struct fmdev *, u8 *);
-u32 fm_rx_get_mute_mode(struct fmdev *, u8 *);
-u32 fm_rx_get_volume(struct fmdev *, u16 *);
-u32 fm_rx_get_band_freq_range(struct fmdev *,
+int fm_rx_get_rds_mode(struct fmdev *, u8 *);
+int fm_rx_get_rds_system(struct fmdev *, u8 *);
+int fm_rx_get_mute_mode(struct fmdev *, u8 *);
+int fm_rx_get_volume(struct fmdev *, u16 *);
+int fm_rx_get_band_freq_range(struct fmdev *,
 					u32 *, u32 *);
-u32 fm_rx_get_stereo_mono(struct fmdev *, u16 *);
-u32 fm_rx_get_rssi_level(struct fmdev *, u16 *);
-u32 fm_rx_get_rssi_threshold(struct fmdev *, short *);
-u32 fm_rx_get_rfdepend_softmute(struct fmdev *, u8 *);
-u32 fm_rx_get_deemph_mode(struct fmdev *, u16 *);
-u32 fm_rx_get_af_switch(struct fmdev *, u8 *);
+int fm_rx_get_stereo_mono(struct fmdev *, u16 *);
+int fm_rx_get_rssi_level(struct fmdev *, u16 *);
+int fm_rx_get_rssi_threshold(struct fmdev *, short *);
+int fm_rx_get_rfdepend_softmute(struct fmdev *, u8 *);
+int fm_rx_get_deemph_mode(struct fmdev *, u16 *);
+int fm_rx_get_af_switch(struct fmdev *, u8 *);
 void fm_rx_get_region(struct fmdev *, u8 *);
 
-u32 fm_rx_set_chanl_spacing(struct fmdev *, u8);
-u32 fm_rx_get_chanl_spacing(struct fmdev *, u8 *);
+int fm_rx_set_chanl_spacing(struct fmdev *, u8);
+int fm_rx_get_chanl_spacing(struct fmdev *, u8 *);
 #endif
 
-- 
1.7.5.4

