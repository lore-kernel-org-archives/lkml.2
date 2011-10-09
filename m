Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab1JICDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 22:03:46 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:41914 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1JICDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 22:03:45 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.15 with qID p9923VVf029248, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging:rts_pstor:Fix SDIO issue
Date: Sun, 9 Oct 2011 10:03:30 +0800
X-BOX-Message-Id: p9923VVf029248
Message-ID: <1318125810-30505-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Fix a bug that SDIO and SD normal card would appear simultaneously if a SDIO card inserted.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/sd.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index fb62eaf..9ce63f7 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3094,6 +3094,7 @@ int reset_sd_card(struct rtsx_chip *chip)
 {
 	struct sd_info *sd_card = &(chip->sd_card);
 	int retval;
+	int reset_pass = 0;
 
 	sd_init_reg_addr(chip);
 
@@ -3134,7 +3135,10 @@ int reset_sd_card(struct rtsx_chip *chip)
 
 	if (chip->sd_ctl & RESET_MMC_FIRST) {
 		retval = reset_mmc(chip);
-		if ((retval != STATUS_SUCCESS) && !sd_check_err_code(chip, SD_NO_CARD)) {
+		if (retval != STATUS_SUCCESS) {
+			if (sd_check_err_code(chip, SD_NO_CARD))
+				TRACE_RET(chip, STATUS_FAIL);
+
 			retval = reset_sd(chip);
 			if (retval != STATUS_SUCCESS) {
 				if (CHECK_PID(chip, 0x5209)) {
@@ -3143,7 +3147,11 @@ int reset_sd_card(struct rtsx_chip *chip)
 						TRACE_RET(chip, STATUS_FAIL);
 					}
 				}
+			} else {
+				reset_pass = 1;
 			}
+		} else {
+			reset_pass = 1;
 		}
 	} else {
 		retval = reset_sd(chip);
@@ -3161,13 +3169,16 @@ int reset_sd_card(struct rtsx_chip *chip)
 
 			if (!chip->sd_io) {
 				retval = reset_mmc(chip);
+				if (retval == STATUS_SUCCESS)
+					reset_pass = 1;
 			}
+		} else {
+			reset_pass = 1;
 		}
 	}
 
-	if (retval != STATUS_SUCCESS) {
+	if (!reset_pass)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
 	if (retval != STATUS_SUCCESS) {
-- 
1.7.7

