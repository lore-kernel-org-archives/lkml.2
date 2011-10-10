Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1JJGrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:47:22 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57041 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1JJGrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:47:21 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.15 with qID p9A6l9xQ011859, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging:rts_pstor:Fix SDIO issue
Date: Mon, 10 Oct 2011 14:47:08 +0800
X-BOX-Message-Id: p9A6l9xQ011859
Message-ID: <1318229228-16605-1-git-send-email-wei_wang@realsil.com.cn>
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
 drivers/staging/rts_pstor/sd.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index fb62eaf..aab6909 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -3134,41 +3134,40 @@ int reset_sd_card(struct rtsx_chip *chip)
 
 	if (chip->sd_ctl & RESET_MMC_FIRST) {
 		retval = reset_mmc(chip);
-		if ((retval != STATUS_SUCCESS) && !sd_check_err_code(chip, SD_NO_CARD)) {
+		if (retval != STATUS_SUCCESS) {
+			if (sd_check_err_code(chip, SD_NO_CARD))
+				TRACE_RET(chip, STATUS_FAIL);
+
 			retval = reset_sd(chip);
 			if (retval != STATUS_SUCCESS) {
-				if (CHECK_PID(chip, 0x5209)) {
-					retval = sd_change_bank_voltage(chip, SD_IO_3V3);
-					if (retval != STATUS_SUCCESS) {
-						TRACE_RET(chip, STATUS_FAIL);
-					}
-				}
+				if (CHECK_PID(chip, 0x5209))
+					sd_change_bank_voltage(chip, SD_IO_3V3);
+
+				TRACE_RET(chip, STATUS_FAIL);
 			}
 		}
 	} else {
 		retval = reset_sd(chip);
 		if (retval != STATUS_SUCCESS) {
-			if (sd_check_err_code(chip, SD_NO_CARD)) {
+			if (sd_check_err_code(chip, SD_NO_CARD))
 				TRACE_RET(chip, STATUS_FAIL);
-			}
 
 			if (CHECK_PID(chip, 0x5209)) {
 				retval = sd_change_bank_voltage(chip, SD_IO_3V3);
-				if (retval != STATUS_SUCCESS) {
+				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-				}
 			}
 
-			if (!chip->sd_io) {
+			if (chip->sd_io) {
+				TRACE_RET(chip, STATUS_FAIL);
+			} else {
 				retval = reset_mmc(chip);
+				if (retval != STATUS_SUCCESS)
+					TRACE_RET(chip, STATUS_FAIL);
 			}
 		}
 	}
 
-	if (retval != STATUS_SUCCESS) {
-		TRACE_RET(chip, STATUS_FAIL);
-	}
-
 	retval = sd_set_clock_divider(chip, SD_CLK_DIVIDE_0);
 	if (retval != STATUS_SUCCESS) {
 		TRACE_RET(chip, STATUS_FAIL);
-- 
1.7.7

