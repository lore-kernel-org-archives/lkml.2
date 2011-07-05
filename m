Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab1GEDIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 23:08:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:58565 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1GEDIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 23:08:13 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p6537xi9030705, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] Fix a bug that a MMCPlus card can't be accessed
Date: Tue, 5 Jul 2011 11:07:50 +0800
X-BOX-Message-Id: p6537xi9030705
Message-ID: <1309835270-9538-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

1. Don't switch bus if cmd14 timedout
2. Add a new group of return codes for mmc_test_switch_bus

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/sd.c |   62 ++++++++++++++++++++++++++-------------
 drivers/staging/rts_pstor/sd.h |    5 +++
 2 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/rts_pstor/sd.c b/drivers/staging/rts_pstor/sd.c
index cdae497..e4b3891 100644
--- a/drivers/staging/rts_pstor/sd.c
+++ b/drivers/staging/rts_pstor/sd.c
@@ -2661,7 +2661,7 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 
 	retval = sd_send_cmd_get_rsp(chip, BUSTEST_W, 0, SD_RSP_TYPE_R1, NULL, 0);
 	if (retval != STATUS_SUCCESS) {
-		TRACE_RET(chip, STATUS_FAIL);
+		TRACE_RET(chip, SWITCH_FAIL);
 	}
 
 	if (width == MMC_8BIT_BUS) {
@@ -2678,7 +2678,9 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 	}
 
 	if (!CHECK_PID(chip, 0x5209)) {
-		RTSX_WRITE_REG(chip, REG_SD_CFG3, 0x02, 0x02);
+		retval = rtsx_write_register(chip, REG_SD_CFG3, 0x02, 0x02);
+		if (retval != STATUS_SUCCESS)
+			TRACE_RET(chip, SWITCH_ERR);
 	}
 
 	retval = sd_write_data(chip, SD_TM_AUTO_WRITE_3,
@@ -2690,17 +2692,19 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 			rtsx_read_register(chip, REG_SD_STAT2, &val2);
 			rtsx_clear_sd_error(chip);
 			if ((val1 & 0xE0) || val2) {
-				TRACE_RET(chip, STATUS_FAIL);
+				TRACE_RET(chip, SWITCH_ERR);
 			}
 		} else {
 			rtsx_clear_sd_error(chip);
 			rtsx_write_register(chip, REG_SD_CFG3, 0x02, 0);
-			TRACE_RET(chip, STATUS_FAIL);
+			TRACE_RET(chip, SWITCH_ERR);
 		}
 	}
 
 	if (!CHECK_PID(chip, 0x5209)) {
-		RTSX_WRITE_REG(chip, REG_SD_CFG3, 0x02, 0);
+		retval = rtsx_write_register(chip, REG_SD_CFG3, 0x02, 0);
+		if (retval != STATUS_SUCCESS)
+			TRACE_RET(chip, SWITCH_ERR);
 	}
 
 	RTSX_DEBUGP("SD/MMC CMD %d\n", BUSTEST_R);
@@ -2733,7 +2737,7 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 	retval = rtsx_send_cmd(chip, SD_CARD, 100);
 	if (retval < 0) {
 		rtsx_clear_sd_error(chip);
-		TRACE_RET(chip, STATUS_FAIL);
+		TRACE_RET(chip, SWITCH_ERR);
 	}
 
 	ptr = rtsx_get_cmd_data(chip) + 1;
@@ -2751,7 +2755,7 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 			}
 			retval = sd_send_cmd_get_rsp(chip, SWITCH, arg, SD_RSP_TYPE_R1b, rsp, 5);
 			if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR)) {
-				return STATUS_SUCCESS;
+				return SWITCH_SUCCESS;
 			}
 		}
 	} else {
@@ -2767,12 +2771,12 @@ static int mmc_test_switch_bus(struct rtsx_chip *chip, u8 width)
 			}
 			retval = sd_send_cmd_get_rsp(chip, SWITCH, arg, SD_RSP_TYPE_R1b, rsp, 5);
 			if ((retval == STATUS_SUCCESS) && !(rsp[4] & MMC_SWITCH_ERR)) {
-				return STATUS_SUCCESS;
+				return SWITCH_SUCCESS;
 			}
 		}
 	}
 
-	TRACE_RET(chip, STATUS_FAIL);
+	TRACE_RET(chip, SWITCH_FAIL);
 }
 
 
@@ -2880,21 +2884,30 @@ static int mmc_switch_timing_bus(struct rtsx_chip *chip, int switch_ddr)
 		TRACE_RET(chip, STATUS_FAIL);
 	}
 
-	if (mmc_test_switch_bus(chip, MMC_8BIT_BUS) == STATUS_SUCCESS) {
+	/* Test Bus Procedure */
+	retval = mmc_test_switch_bus(chip, MMC_8BIT_BUS);
+	if (retval == SWITCH_SUCCESS) {
 		SET_MMC_8BIT(sd_card);
 		chip->card_bus_width[chip->card2lun[SD_CARD]] = 8;
 #ifdef SUPPORT_SD_LOCK
 		sd_card->sd_lock_status &= ~SD_LOCK_1BIT_MODE;
 #endif
-	} else if (mmc_test_switch_bus(chip, MMC_4BIT_BUS) == STATUS_SUCCESS) {
-		SET_MMC_4BIT(sd_card);
-		chip->card_bus_width[chip->card2lun[SD_CARD]] = 4;
+	} else if (retval == SWITCH_FAIL) {
+		retval = mmc_test_switch_bus(chip, MMC_4BIT_BUS);
+		if (retval == SWITCH_SUCCESS) {
+			SET_MMC_4BIT(sd_card);
+			chip->card_bus_width[chip->card2lun[SD_CARD]] = 4;
 #ifdef SUPPORT_SD_LOCK
-		sd_card->sd_lock_status &= ~SD_LOCK_1BIT_MODE;
+			sd_card->sd_lock_status &= ~SD_LOCK_1BIT_MODE;
 #endif
+		} else if (retval == SWITCH_FAIL) {
+			CLR_MMC_8BIT(sd_card);
+			CLR_MMC_4BIT(sd_card);
+		} else {
+			TRACE_RET(chip, STATUS_FAIL);
+		}
 	} else {
-		CLR_MMC_8BIT(sd_card);
-		CLR_MMC_4BIT(sd_card);
+		TRACE_RET(chip, STATUS_FAIL);
 	}
 
 	return STATUS_SUCCESS;
@@ -2915,8 +2928,7 @@ static int reset_mmc(struct rtsx_chip *chip)
 		goto MMC_UNLOCK_ENTRY;
 #endif
 
-DDR_TUNING_FAIL:
-
+Switch_Fail:
 	retval = sd_prepare_reset(chip);
 	if (retval != STATUS_SUCCESS) {
 		TRACE_RET(chip, retval);
@@ -3017,7 +3029,15 @@ MMC_UNLOCK_ENTRY:
 
 	if (!sd_card->mmc_dont_switch_bus) {
 		if (spec_ver == 4) {
-			(void)mmc_switch_timing_bus(chip, switch_ddr);
+			/* MMC 4.x Cards */
+			retval = mmc_switch_timing_bus(chip, switch_ddr);
+			if (retval != STATUS_SUCCESS) {
+				retval = sd_init_power(chip);
+				if (retval != STATUS_SUCCESS)
+					TRACE_RET(chip, STATUS_FAIL);
+				sd_card->mmc_dont_switch_bus = 1;
+				TRACE_GOTO(chip, Switch_Fail);
+			}
 		}
 
 		if (CHK_MMC_SECTOR_MODE(sd_card) && (sd_card->capacity == 0)) {
@@ -3037,7 +3057,7 @@ MMC_UNLOCK_ENTRY:
 					TRACE_RET(chip, STATUS_FAIL);
 				}
 				switch_ddr = 0;
-				goto DDR_TUNING_FAIL;
+				TRACE_GOTO(chip, Switch_Fail);
 			}
 
 			retval = sd_wait_state_data_ready(chip, 0x08, 1, 1000);
@@ -3049,7 +3069,7 @@ MMC_UNLOCK_ENTRY:
 						TRACE_RET(chip, STATUS_FAIL);
 					}
 					switch_ddr = 0;
-					goto DDR_TUNING_FAIL;
+					TRACE_GOTO(chip, Switch_Fail);
 				}
 			}
 		}
diff --git a/drivers/staging/rts_pstor/sd.h b/drivers/staging/rts_pstor/sd.h
index d62e690..1df1aa7 100644
--- a/drivers/staging/rts_pstor/sd.h
+++ b/drivers/staging/rts_pstor/sd.h
@@ -38,6 +38,11 @@
 #define SD_RSP_TIMEOUT		0x04
 #define SD_IO_ERR		0x02
 
+/* Return code for MMC switch bus */
+#define SWITCH_SUCCESS		0
+#define SWITCH_ERR		1
+#define SWITCH_FAIL		2
+
 /* MMC/SD Command Index */
 /* Basic command (class 0) */
 #define GO_IDLE_STATE		0
-- 
1.7.6

