Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2COSur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:50:47 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:42880 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932425Ab2COSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:50:43 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/3] mfd: db8500-prcmu: remove obsolete hwacc implementation
Date: Thu, 15 Mar 2012 19:50:26 +0100
Message-ID: <1331837426-17761-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This patch removes the obsolete hwacc implementation in the
DB8500 PRCMU driver.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |  155 --------------------------------------
 include/linux/mfd/db8500-prcmu.h |   43 -----------
 2 files changed, 198 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 128b5f4..c1addd7 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -515,35 +515,6 @@ static struct dsiescclk dsiescclk[3] = {
 	}
 };
 
-static struct regulator *hwacc_regulator[NUM_HW_ACC];
-static struct regulator *hwacc_ret_regulator[NUM_HW_ACC];
-
-static bool hwacc_enabled[NUM_HW_ACC];
-static bool hwacc_ret_enabled[NUM_HW_ACC];
-
-static const char *hwacc_regulator_name[NUM_HW_ACC] = {
-	[HW_ACC_SVAMMDSP]	= "hwacc-sva-mmdsp",
-	[HW_ACC_SVAPIPE]	= "hwacc-sva-pipe",
-	[HW_ACC_SIAMMDSP]	= "hwacc-sia-mmdsp",
-	[HW_ACC_SIAPIPE]	= "hwacc-sia-pipe",
-	[HW_ACC_SGA]		= "hwacc-sga",
-	[HW_ACC_B2R2]		= "hwacc-b2r2",
-	[HW_ACC_MCDE]		= "hwacc-mcde",
-	[HW_ACC_ESRAM1]		= "hwacc-esram1",
-	[HW_ACC_ESRAM2]		= "hwacc-esram2",
-	[HW_ACC_ESRAM3]		= "hwacc-esram3",
-	[HW_ACC_ESRAM4]		= "hwacc-esram4",
-};
-
-static const char *hwacc_ret_regulator_name[NUM_HW_ACC] = {
-	[HW_ACC_SVAMMDSP]	= "hwacc-sva-mmdsp-ret",
-	[HW_ACC_SIAMMDSP]	= "hwacc-sia-mmdsp-ret",
-	[HW_ACC_ESRAM1]		= "hwacc-esram1-ret",
-	[HW_ACC_ESRAM2]		= "hwacc-esram2-ret",
-	[HW_ACC_ESRAM3]		= "hwacc-esram3-ret",
-	[HW_ACC_ESRAM4]		= "hwacc-esram4-ret",
-};
-
 /*
 * Used by MCDE to setup all necessary PRCMU registers
 */
@@ -1181,132 +1152,6 @@ static int request_pll(u8 clock, bool enable)
 }
 
 /**
- * prcmu_set_hwacc - set the power state of a h/w accelerator
- * @hwacc_dev: The hardware accelerator (enum hw_acc_dev).
- * @state: The new power state (enum hw_acc_state).
- *
- * This function sets the power state of a hardware accelerator.
- * This function should not be called from interrupt context.
- *
- * NOTE! Deprecated, to be removed when all users switched over to use the
- * regulator framework API.
- */
-int prcmu_set_hwacc(u16 hwacc_dev, u8 state)
-{
-	int r = 0;
-	bool ram_retention = false;
-	bool enable, enable_ret;
-
-	/* check argument */
-	BUG_ON(hwacc_dev >= NUM_HW_ACC);
-
-	/* get state of switches */
-	enable = hwacc_enabled[hwacc_dev];
-	enable_ret = hwacc_ret_enabled[hwacc_dev];
-
-	/* set flag if retention is possible */
-	switch (hwacc_dev) {
-	case HW_ACC_SVAMMDSP:
-	case HW_ACC_SIAMMDSP:
-	case HW_ACC_ESRAM1:
-	case HW_ACC_ESRAM2:
-	case HW_ACC_ESRAM3:
-	case HW_ACC_ESRAM4:
-		ram_retention = true;
-		break;
-	}
-
-	/* check argument */
-	BUG_ON(state > HW_ON);
-	BUG_ON(state == HW_OFF_RAMRET && !ram_retention);
-
-	/* modify enable flags */
-	switch (state) {
-	case HW_OFF:
-		enable_ret = false;
-		enable = false;
-		break;
-	case HW_ON:
-		enable = true;
-		break;
-	case HW_OFF_RAMRET:
-		enable_ret = true;
-		enable = false;
-		break;
-	}
-
-	/* get regulator (lazy) */
-	if (hwacc_regulator[hwacc_dev] == NULL) {
-		hwacc_regulator[hwacc_dev] = regulator_get(NULL,
-			hwacc_regulator_name[hwacc_dev]);
-		if (IS_ERR(hwacc_regulator[hwacc_dev])) {
-			pr_err("prcmu: failed to get supply %s\n",
-				hwacc_regulator_name[hwacc_dev]);
-			r = PTR_ERR(hwacc_regulator[hwacc_dev]);
-			goto out;
-		}
-	}
-
-	if (ram_retention) {
-		if (hwacc_ret_regulator[hwacc_dev] == NULL) {
-			hwacc_ret_regulator[hwacc_dev] = regulator_get(NULL,
-				hwacc_ret_regulator_name[hwacc_dev]);
-			if (IS_ERR(hwacc_ret_regulator[hwacc_dev])) {
-				pr_err("prcmu: failed to get supply %s\n",
-					hwacc_ret_regulator_name[hwacc_dev]);
-				r = PTR_ERR(hwacc_ret_regulator[hwacc_dev]);
-				goto out;
-			}
-		}
-	}
-
-	/* set regulators */
-	if (ram_retention) {
-		if (enable_ret && !hwacc_ret_enabled[hwacc_dev]) {
-			r = regulator_enable(hwacc_ret_regulator[hwacc_dev]);
-			if (r < 0) {
-				pr_err("prcmu_set_hwacc: ret enable failed\n");
-				goto out;
-			}
-			hwacc_ret_enabled[hwacc_dev] = true;
-		}
-	}
-
-	if (enable && !hwacc_enabled[hwacc_dev]) {
-		r = regulator_enable(hwacc_regulator[hwacc_dev]);
-		if (r < 0) {
-			pr_err("prcmu_set_hwacc: enable failed\n");
-			goto out;
-		}
-		hwacc_enabled[hwacc_dev] = true;
-	}
-
-	if (!enable && hwacc_enabled[hwacc_dev]) {
-		r = regulator_disable(hwacc_regulator[hwacc_dev]);
-		if (r < 0) {
-			pr_err("prcmu_set_hwacc: disable failed\n");
-			goto out;
-		}
-		hwacc_enabled[hwacc_dev] = false;
-	}
-
-	if (ram_retention) {
-		if (!enable_ret && hwacc_ret_enabled[hwacc_dev]) {
-			r = regulator_disable(hwacc_ret_regulator[hwacc_dev]);
-			if (r < 0) {
-				pr_err("prcmu_set_hwacc: ret disable failed\n");
-				goto out;
-			}
-			hwacc_ret_enabled[hwacc_dev] = false;
-		}
-	}
-
-out:
-	return r;
-}
-EXPORT_SYMBOL(prcmu_set_hwacc);
-
-/**
  * db8500_prcmu_set_epod - set the state of a EPOD (power domain)
  * @epod_id: The EPOD to set
  * @epod_state: The new EPOD state
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index 636423b..a0ac1d2 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -439,43 +439,6 @@ enum auto_enable {
 /* End of file previously known as prcmu-fw-defs_v1.h */
 
 /**
- * enum hw_acc_dev - enum for hw accelerators
- * @HW_ACC_SVAMMDSP: for SVAMMDSP
- * @HW_ACC_SVAPIPE:  for SVAPIPE
- * @HW_ACC_SIAMMDSP: for SIAMMDSP
- * @HW_ACC_SIAPIPE: for SIAPIPE
- * @HW_ACC_SGA: for SGA
- * @HW_ACC_B2R2: for B2R2
- * @HW_ACC_MCDE: for MCDE
- * @HW_ACC_ESRAM1: for ESRAM1
- * @HW_ACC_ESRAM2: for ESRAM2
- * @HW_ACC_ESRAM3: for ESRAM3
- * @HW_ACC_ESRAM4: for ESRAM4
- * @NUM_HW_ACC: number of hardware accelerators
- *
- * Different hw accelerators which can be turned ON/
- * OFF or put into retention (MMDSPs and ESRAMs).
- * Used with EPOD API.
- *
- * NOTE! Deprecated, to be removed when all users switched over to use the
- * regulator API.
- */
-enum hw_acc_dev {
-	HW_ACC_SVAMMDSP,
-	HW_ACC_SVAPIPE,
-	HW_ACC_SIAMMDSP,
-	HW_ACC_SIAPIPE,
-	HW_ACC_SGA,
-	HW_ACC_B2R2,
-	HW_ACC_MCDE,
-	HW_ACC_ESRAM1,
-	HW_ACC_ESRAM2,
-	HW_ACC_ESRAM3,
-	HW_ACC_ESRAM4,
-	NUM_HW_ACC
-};
-
-/**
  * enum prcmu_power_status - results from set_power_state
  * @PRCMU_SLEEP_OK: Sleep went ok
  * @PRCMU_DEEP_SLEEP_OK: DeepSleep went ok
@@ -552,8 +515,6 @@ bool prcmu_has_arm_maxopp(void);
 struct prcmu_fw_version *prcmu_get_fw_version(void);
 int prcmu_request_ape_opp_100_voltage(bool enable);
 int prcmu_release_usb_wakeup_state(void);
-/* NOTE! Use regulator framework instead */
-int prcmu_set_hwacc(u16 hw_acc_dev, u8 state);
 void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	struct prcmu_auto_pm_config *idle);
 bool prcmu_is_auto_pm_enabled(void);
@@ -661,10 +622,6 @@ static inline int db8500_prcmu_get_ddr_opp(void)
 	return DDR_100_OPP;
 }
 
-static inline int prcmu_set_hwacc(u16 hw_acc_dev, u8 state)
-{
-	return 0;
-}
 static inline void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	struct prcmu_auto_pm_config *idle)
 {
-- 
1.7.9.2

