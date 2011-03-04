Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab1CDC7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:59:20 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:37365 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1CDC7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:59:19 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.07 with qID p242x3Bw024023, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging: rts_pstor: fix a bug that a greenhouse sd card can't be recognized
Date: Fri, 4 Mar 2011 10:56:36 +0800
X-BOX-Message-Id: p242x3Bw024023
Message-ID: <1299207396-11002-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

A greenhouse sd card can't be recognized using rts5209.
To fix this bug, these modifications are applied:
1, Move some codes which clear sd internal variables from sd_init_type to
sd_prepare_reset. So sd_init_type is useless any more and is removed
entirely;
2, If a sd card can't pass sd3.0 mode, the action of tunning phase should be
avoided when retrying sd2.0 mode.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/sd.c |   56 ++++++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index 80b61e6..21bfa57 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -1265,6 +1265,7 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 
 	sd_card->func_group1_mask &= ~(sd_card->sd_switch_fail);
 
+	/* Function Group 1: Access Mode */
 	for (i = 0; i < 4; i++) {
 		switch ((u8)(chip->sd_speed_prior >> (i*8))) {
 		case SDR104_SUPPORT:
@@ -1349,6 +1350,14 @@ static int sd_switch_function(struct rtsx_chip *chip, u8 bus_width)
 		}
 	}
 
+	if (!func_to_switch || (func_to_switch == HS_SUPPORT)) {
+		/* Do not try to switch current limit if the card doesn't
+		 * support UHS mode or we don't want it to support UHS mode
+		 */
+		return STATUS_SUCCESS;
+	}
+
+	/* Function Group 4: Current Limit */
 	func_to_switch = 0xFF;
 
 	for (i = 0; i < 4; i++) {
@@ -2015,6 +2024,17 @@ static int sd_prepare_reset(struct rtsx_chip *chip)
 		sd_card->sd_clock = CLK_30;
 	}
 
+	sd_card->sd_type = 0;
+	sd_card->seq_mode = 0;
+	sd_card->sd_data_buf_ready = 0;
+	sd_card->capacity = 0;
+
+#ifdef SUPPORT_SD_LOCK
+	sd_card->sd_lock_status = 0;
+	sd_card->sd_erase_status = 0;
+#endif
+
+	chip->capacity[chip->card2lun[SD_CARD]] = 0;
 	chip->sd_io = 0;
 
 	retval = sd_set_init_para(chip);
@@ -2504,6 +2524,15 @@ SD_UNLOCK_ENTRY:
 		sd_dont_switch = 1;
 
 	if (!sd_dont_switch) {
+		if (sd20_mode) {
+			/* Set sd_switch_fail here, because we needn't
+			 * switch to UHS mode
+			 */
+			sd_card->sd_switch_fail = SDR104_SUPPORT_MASK |
+				DDR50_SUPPORT_MASK | SDR50_SUPPORT_MASK;
+		}
+
+		/* Check the card whether follow SD1.1 spec or higher */
 		retval = sd_check_spec(chip, switch_bus_width);
 		if (retval == STATUS_SUCCESS) {
 			retval = sd_switch_function(chip, switch_bus_width);
@@ -2546,7 +2575,7 @@ SD_UNLOCK_ENTRY:
 	sd_card->sd_lock_status &= ~SD_LOCK_1BIT_MODE;
 #endif
 
-	if (CHK_SD30_SPEED(sd_card)) {
+	if (!sd20_mode && CHK_SD30_SPEED(sd_card)) {
 		int read_lba0 = 1;
 
 		RTSX_WRITE_REG(chip, SD30_DRIVE_SEL, 0x07, chip->sd30_drive_sel_1v8);
@@ -3040,28 +3069,6 @@ MMC_UNLOCK_ENTRY:
 	return STATUS_SUCCESS;
 }
 
-static void sd_init_type(struct rtsx_chip *chip)
-{
-	struct sd_info *sd_card = &(chip->sd_card);
-
-	memset(sd_card, 0, sizeof(struct sd_info));
-
-	sd_card->sd_type = 0;
-	sd_card->seq_mode = 0;
-	sd_card->sd_data_buf_ready = 0;
-	sd_card->capacity = 0;
-	sd_card->sd_switch_fail = 0;
-	sd_card->mmc_dont_switch_bus = 0;
-	sd_card->need_retune = 0;
-
-#ifdef SUPPORT_SD_LOCK
-	sd_card->sd_lock_status = 0;
-	sd_card->sd_erase_status = 0;
-#endif
-
-	chip->capacity[chip->card2lun[SD_CARD]] = sd_card->capacity = 0;
-}
-
 int reset_sd_card(struct rtsx_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
@@ -3069,7 +3076,8 @@ int reset_sd_card(struct rtsx_chip *chip)
 
 	sd_init_reg_addr(chip);
 
-	sd_init_type(chip);
+	memset(sd_card, 0, sizeof(struct sd_info));
+	chip->capacity[chip->card2lun[SD_CARD]] = 0;
 
 	retval = enable_card_clock(chip, SD_CARD);
 	if (retval != STATUS_SUCCESS) {
-- 
1.7.4.1

