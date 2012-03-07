Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab2CGMyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:54:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8451 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab2CGMyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:54:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 07 Mar 2012 04:54:15 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com, jedu@slimlogic.co.uk,
        sameo@linux.intel.com, ldewangan@nvidia.com
Cc: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH V1] regulator: tps65910: Sleep off rails when ext sleep configured
Date: Wed,  7 Mar 2012 18:21:49 +0530
Message-Id: <1331124709-30402-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep the rails OFF in sleep mode only when the rails are
controlled by external sleep control.
The devices tps65910 and tps65911, both has the sleep input.
The tps65911's sleep input is not same as tps65910's EN3 and hence
taking care of SLEEP input as separate external sleep control input.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
In the previous change for external control support, the tps65911's
SLEEP was assumed as tps65910's EN3 becasue the tps65911 does not have
EN3 registers. But this was wrong. Both device have sleep input and
configured on same way which is independent of EN3.

 drivers/regulator/tps65910-regulator.c |   17 +++++++++++++----
 include/linux/mfd/tps65910.h           |    5 ++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 8de2835..8074d51 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -28,7 +28,8 @@
 #define TPS65910_SUPPLY_STATE_ENABLED	0x1
 #define EXT_SLEEP_CONTROL (TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1 |	\
 			TPS65910_SLEEP_CONTROL_EXT_INPUT_EN2 |		\
-			TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3)
+			TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3 |		\
+			TPS65911_SLEEP_CONTROL_EXT_INPUT_SLEEP)
 
 /* supported VIO voltages in milivolts */
 static const u16 VIO_VSEL_table[] = {
@@ -922,6 +923,8 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 				TPS65910_SLEEP_CONTROL_EXT_INPUT_EN2) != 0);
 		en_count += ((ext_sleep_config &
 				TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3) != 0);
+		en_count += ((ext_sleep_config &
+				TPS65911_SLEEP_CONTROL_EXT_INPUT_SLEEP) != 0);
 		if (en_count > 1) {
 			dev_err(mfd->dev,
 				"External sleep control flag is not proper\n");
@@ -1018,12 +1021,18 @@ static int tps65910_set_ext_sleep_config(struct tps65910_reg *pmic,
 
 	ret = tps65910_clear_bits(mfd,
 			TPS65910_SLEEP_KEEP_LDO_ON + regoffs, bit_pos);
-	if (!ret)
-		ret = tps65910_set_bits(mfd,
-			TPS65910_SLEEP_SET_LDO_OFF + regoffs, bit_pos);
+	if (!ret) {
+		if (ext_sleep_config & TPS65911_SLEEP_CONTROL_EXT_INPUT_SLEEP)
+			ret = tps65910_set_bits(mfd,
+				TPS65910_SLEEP_SET_LDO_OFF + regoffs, bit_pos);
+		else
+			ret = tps65910_clear_bits(mfd,
+				TPS65910_SLEEP_SET_LDO_OFF + regoffs, bit_pos);
+	}
 	if (ret < 0)
 		dev_err(mfd->dev,
 			"Error in configuring SLEEP register\n");
+
 	return ret;
 }
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 06a4cd6..f6021cc 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -775,12 +775,11 @@
 /* Max number of TPS65910/11 regulators */
 #define TPS65910_NUM_REGS				13
 
-/* External sleep controls through EN1/EN2/EN3 inputs*/
+/* External sleep controls through EN1/EN2/EN3/SLEEP inputs */
 #define TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1		0x1
 #define TPS65910_SLEEP_CONTROL_EXT_INPUT_EN2		0x2
 #define TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3		0x4
-/* TPS65911 names the EN3 signal as SLEEP */
-#define TPS65911_SLEEP_CONTROL_EXT_INPUT_SLEEP		0x4
+#define TPS65911_SLEEP_CONTROL_EXT_INPUT_SLEEP		0x8
 
 /**
  * struct tps65910_board
-- 
1.7.1.1

