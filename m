Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1LBKDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:03:37 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56048 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab1LBKDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:03:32 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 1/3] wl128x: fmdrv_common: fix signedness bugs
Date: Fri,  2 Dec 2011 05:01:11 -0500
Message-Id: <1322820073-19347-2-git-send-email-xi.wang@gmail.com>
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
 drivers/media/radio/wl128x/fmdrv_common.c |   58 ++++++++++++++---------------
 drivers/media/radio/wl128x/fmdrv_common.h |   28 +++++++-------
 2 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 5991ab6..bf867a6 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -387,7 +387,7 @@ static void send_tasklet(unsigned long arg)
  * Queues FM Channel-8 packet to FM TX queue and schedules FM TX tasklet for
  * transmission
  */
-static u32 fm_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type,	void *payload,
+static int fm_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type,	void *payload,
 		int payload_len, struct completion *wait_completion)
 {
 	struct sk_buff *skb;
@@ -456,13 +456,13 @@ static u32 fm_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type,	void *payload,
 }
 
 /* Sends FM Channel-8 command to the chip and waits for the response */
-u32 fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
+int fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
 		unsigned int payload_len, void *response, int *response_len)
 {
 	struct sk_buff *skb;
 	struct fm_event_msg_hdr *evt_hdr;
 	unsigned long flags;
-	u32 ret;
+	int ret;
 
 	init_completion(&fmdev->maintask_comp);
 	ret = fm_send_cmd(fmdev, fm_op, type, payload, payload_len,
@@ -470,8 +470,8 @@ u32 fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
 	if (ret)
 		return ret;
 
-	ret = wait_for_completion_timeout(&fmdev->maintask_comp, FM_DRV_TX_TIMEOUT);
-	if (!ret) {
+	if (!wait_for_completion_timeout(&fmdev->maintask_comp,
+					 FM_DRV_TX_TIMEOUT)) {
 		fmerr("Timeout(%d sec),didn't get reg"
 			   "completion signal from RX tasklet\n",
 			   jiffies_to_msecs(FM_DRV_TX_TIMEOUT) / 1000);
@@ -508,7 +508,7 @@ u32 fmc_send_cmd(struct fmdev *fmdev, u8 fm_op, u16 type, void *payload,
 }
 
 /* --- Helper functions used in FM interrupt handlers ---*/
-static inline u32 check_cmdresp_status(struct fmdev *fmdev,
+static inline int check_cmdresp_status(struct fmdev *fmdev,
 		struct sk_buff **skb)
 {
 	struct fm_event_msg_hdr *fm_evt_hdr;
@@ -1058,7 +1058,7 @@ static void fm_irq_handle_intmsk_cmd_resp(struct fmdev *fmdev)
 }
 
 /* Returns availability of RDS data in internel buffer */
-u32 fmc_is_rds_data_available(struct fmdev *fmdev, struct file *file,
+int fmc_is_rds_data_available(struct fmdev *fmdev, struct file *file,
 				struct poll_table_struct *pts)
 {
 	poll_wait(file, &fmdev->rx.rds.read_queue, pts);
@@ -1069,7 +1069,7 @@ u32 fmc_is_rds_data_available(struct fmdev *fmdev, struct file *file,
 }
 
 /* Copies RDS data from internal buffer to user buffer */
-u32 fmc_transfer_rds_from_internal_buff(struct fmdev *fmdev, struct file *file,
+int fmc_transfer_rds_from_internal_buff(struct fmdev *fmdev, struct file *file,
 		u8 __user *buf, size_t count)
 {
 	u32 block_count;
@@ -1113,7 +1113,7 @@ u32 fmc_transfer_rds_from_internal_buff(struct fmdev *fmdev, struct file *file,
 	return ret;
 }
 
-u32 fmc_set_freq(struct fmdev *fmdev, u32 freq_to_set)
+int fmc_set_freq(struct fmdev *fmdev, u32 freq_to_set)
 {
 	switch (fmdev->curr_fmmode) {
 	case FM_MODE_RX:
@@ -1127,7 +1127,7 @@ u32 fmc_set_freq(struct fmdev *fmdev, u32 freq_to_set)
 	}
 }
 
-u32 fmc_get_freq(struct fmdev *fmdev, u32 *cur_tuned_frq)
+int fmc_get_freq(struct fmdev *fmdev, u32 *cur_tuned_frq)
 {
 	if (fmdev->rx.freq == FM_UNDEFINED_FREQ) {
 		fmerr("RX frequency is not set\n");
@@ -1153,7 +1153,7 @@ u32 fmc_get_freq(struct fmdev *fmdev, u32 *cur_tuned_frq)
 
 }
 
-u32 fmc_set_region(struct fmdev *fmdev, u8 region_to_set)
+int fmc_set_region(struct fmdev *fmdev, u8 region_to_set)
 {
 	switch (fmdev->curr_fmmode) {
 	case FM_MODE_RX:
@@ -1167,7 +1167,7 @@ u32 fmc_set_region(struct fmdev *fmdev, u8 region_to_set)
 	}
 }
 
-u32 fmc_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
+int fmc_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
 {
 	switch (fmdev->curr_fmmode) {
 	case FM_MODE_RX:
@@ -1181,7 +1181,7 @@ u32 fmc_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
 	}
 }
 
-u32 fmc_set_stereo_mono(struct fmdev *fmdev, u16 mode)
+int fmc_set_stereo_mono(struct fmdev *fmdev, u16 mode)
 {
 	switch (fmdev->curr_fmmode) {
 	case FM_MODE_RX:
@@ -1195,7 +1195,7 @@ u32 fmc_set_stereo_mono(struct fmdev *fmdev, u16 mode)
 	}
 }
 
-u32 fmc_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
+int fmc_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
 {
 	switch (fmdev->curr_fmmode) {
 	case FM_MODE_RX:
@@ -1210,10 +1210,10 @@ u32 fmc_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
 }
 
 /* Sends power off command to the chip */
-static u32 fm_power_down(struct fmdev *fmdev)
+static int fm_power_down(struct fmdev *fmdev)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
 		fmerr("FM core is not ready\n");
@@ -1234,7 +1234,7 @@ static u32 fm_power_down(struct fmdev *fmdev)
 }
 
 /* Reads init command from FM firmware file and loads to the chip */
-static u32 fm_download_firmware(struct fmdev *fmdev, const u8 *fw_name)
+static int fm_download_firmware(struct fmdev *fmdev, const u8 *fw_name)
 {
 	const struct firmware *fw_entry;
 	struct bts_header *fw_header;
@@ -1299,7 +1299,7 @@ rel_fw:
 }
 
 /* Loads default RX configuration to the chip */
-static u32 load_default_rx_configuration(struct fmdev *fmdev)
+static int load_default_rx_configuration(struct fmdev *fmdev)
 {
 	int ret;
 
@@ -1311,7 +1311,7 @@ static u32 load_default_rx_configuration(struct fmdev *fmdev)
 }
 
 /* Does FM power on sequence */
-static u32 fm_power_up(struct fmdev *fmdev, u8 mode)
+static int fm_power_up(struct fmdev *fmdev, u8 mode)
 {
 	u16 payload, asic_id, asic_ver;
 	int resp_len, ret;
@@ -1374,7 +1374,7 @@ rel:
 }
 
 /* Set FM Modes(TX, RX, OFF) */
-u32 fmc_set_mode(struct fmdev *fmdev, u8 fm_mode)
+int fmc_set_mode(struct fmdev *fmdev, u8 fm_mode)
 {
 	int ret = 0;
 
@@ -1427,7 +1427,7 @@ u32 fmc_set_mode(struct fmdev *fmdev, u8 fm_mode)
 }
 
 /* Returns current FM mode (TX, RX, OFF) */
-u32 fmc_get_mode(struct fmdev *fmdev, u8 *fmmode)
+int fmc_get_mode(struct fmdev *fmdev, u8 *fmmode)
 {
 	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
 		fmerr("FM core is not ready\n");
@@ -1483,10 +1483,10 @@ static void fm_st_reg_comp_cb(void *arg, char data)
  * This function will be called from FM V4L2 open function.
  * Register with ST driver and initialize driver data.
  */
-u32 fmc_prepare(struct fmdev *fmdev)
+int fmc_prepare(struct fmdev *fmdev)
 {
 	static struct st_proto_s fm_st_proto;
-	u32 ret;
+	int ret;
 
 	if (test_bit(FM_CORE_READY, &fmdev->flag)) {
 		fmdbg("FM Core is already up\n");
@@ -1512,10 +1512,8 @@ u32 fmc_prepare(struct fmdev *fmdev)
 		fmdev->streg_cbdata = -EINPROGRESS;
 		fmdbg("%s waiting for ST reg completion signal\n", __func__);
 
-		ret = wait_for_completion_timeout(&wait_for_fmdrv_reg_comp,
-				FM_ST_REG_TIMEOUT);
-
-		if (!ret) {
+		if (!wait_for_completion_timeout(&wait_for_fmdrv_reg_comp,
+						 FM_ST_REG_TIMEOUT)) {
 			fmerr("Timeout(%d sec), didn't get reg "
 					"completion signal from ST\n",
 					jiffies_to_msecs(FM_ST_REG_TIMEOUT) / 1000);
@@ -1589,10 +1587,10 @@ u32 fmc_prepare(struct fmdev *fmdev)
  * This function will be called from FM V4L2 release function.
  * Unregister from ST driver.
  */
-u32 fmc_release(struct fmdev *fmdev)
+int fmc_release(struct fmdev *fmdev)
 {
 	static struct st_proto_s fm_st_proto;
-	u32 ret;
+	int ret;
 
 	if (!test_bit(FM_CORE_READY, &fmdev->flag)) {
 		fmdbg("FM Core is already down\n");
@@ -1631,7 +1629,7 @@ u32 fmc_release(struct fmdev *fmdev)
 static int __init fm_drv_init(void)
 {
 	struct fmdev *fmdev = NULL;
-	u32 ret = -ENOMEM;
+	int ret = -ENOMEM;
 
 	fmdbg("FM driver version %s\n", FM_DRV_VERSION);
 
diff --git a/drivers/media/radio/wl128x/fmdrv_common.h b/drivers/media/radio/wl128x/fmdrv_common.h
index aee243b..d9b9c6c 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.h
+++ b/drivers/media/radio/wl128x/fmdrv_common.h
@@ -368,27 +368,27 @@ struct fm_event_msg_hdr {
 #define FM_TX_ANT_IMP_500		2
 
 /* Functions exported by FM common sub-module */
-u32 fmc_prepare(struct fmdev *);
-u32 fmc_release(struct fmdev *);
+int fmc_prepare(struct fmdev *);
+int fmc_release(struct fmdev *);
 
 void fmc_update_region_info(struct fmdev *, u8);
-u32 fmc_send_cmd(struct fmdev *, u8, u16,
+int fmc_send_cmd(struct fmdev *, u8, u16,
 				void *, unsigned int, void *, int *);
-u32 fmc_is_rds_data_available(struct fmdev *, struct file *,
+int fmc_is_rds_data_available(struct fmdev *, struct file *,
 				struct poll_table_struct *);
-u32 fmc_transfer_rds_from_internal_buff(struct fmdev *, struct file *,
+int fmc_transfer_rds_from_internal_buff(struct fmdev *, struct file *,
 					u8 __user *, size_t);
 
-u32 fmc_set_freq(struct fmdev *, u32);
-u32 fmc_set_mode(struct fmdev *, u8);
-u32 fmc_set_region(struct fmdev *, u8);
-u32 fmc_set_mute_mode(struct fmdev *, u8);
-u32 fmc_set_stereo_mono(struct fmdev *, u16);
-u32 fmc_set_rds_mode(struct fmdev *, u8);
+int fmc_set_freq(struct fmdev *, u32);
+int fmc_set_mode(struct fmdev *, u8);
+int fmc_set_region(struct fmdev *, u8);
+int fmc_set_mute_mode(struct fmdev *, u8);
+int fmc_set_stereo_mono(struct fmdev *, u16);
+int fmc_set_rds_mode(struct fmdev *, u8);
 
-u32 fmc_get_freq(struct fmdev *, u32 *);
-u32 fmc_get_region(struct fmdev *, u8 *);
-u32 fmc_get_mode(struct fmdev *, u8 *);
+int fmc_get_freq(struct fmdev *, u32 *);
+int fmc_get_region(struct fmdev *, u8 *);
+int fmc_get_mode(struct fmdev *, u8 *);
 
 /*
  * channel spacing
-- 
1.7.5.4

