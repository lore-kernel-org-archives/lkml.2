Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2AMPU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:20:58 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:53542 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758297Ab2AMPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:54 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/8] mfd/db8500-prcmu: OPP and sleep handling update
Date: Fri, 13 Jan 2012 16:20:43 +0100
Message-ID: <1326468043-11864-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This updates the operating point handling code by:

- Supporting the DDR OPP retention state.
- Supporting another low operating point named
  APE_50_PARTLY_25_OPP
- Adding an interface to figure out if the sleep state change
  was properly achieved.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |   73 +++++++++++++++++++++++++++++++++++++-
 include/linux/mfd/db8500-prcmu.h |   25 +++++++++++++
 include/linux/mfd/dbx500-prcmu.h |   15 +++++++-
 3 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 1385639..8056968 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -343,11 +343,13 @@ static struct {
  * mb1_transfer - state needed for mailbox 1 communication.
  * @lock:	The transaction lock.
  * @work:	The transaction completion structure.
+ * @ape_opp:	The current APE OPP.
  * @ack:	Reply ("acknowledge") data.
  */
 static struct {
 	struct mutex lock;
 	struct completion work;
+	u8 ape_opp;
 	struct {
 		u8 header;
 		u8 arm_opp;
@@ -816,6 +818,11 @@ int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 	return 0;
 }
 
+u8 db8500_prcmu_get_power_state_result(void)
+{
+	return readb(tcdm_base + PRCM_ACK_MB0_AP_PWRSTTR_STATUS);
+}
+
 /* This function should only be called while mb0_transfer.lock is held. */
 static void config_wakeups(void)
 {
@@ -965,6 +972,52 @@ int db8500_prcmu_set_ddr_opp(u8 opp)
 	return 0;
 }
 
+/* Divide the frequency of certain clocks by 2 for APE_50_PARTLY_25_OPP. */
+static void request_even_slower_clocks(bool enable)
+{
+	void __iomem *clock_reg[] = {
+		PRCM_ACLK_MGT,
+		PRCM_DMACLK_MGT
+	};
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&clk_mgt_lock, flags);
+
+	/* Grab the HW semaphore. */
+	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+		cpu_relax();
+
+	for (i = 0; i < ARRAY_SIZE(clock_reg); i++) {
+		u32 val;
+		u32 div;
+
+		val = readl(clock_reg[i]);
+		div = (val & PRCM_CLK_MGT_CLKPLLDIV_MASK);
+		if (enable) {
+			if ((div <= 1) || (div > 15)) {
+				pr_err("prcmu: Bad clock divider %d in %s\n",
+					div, __func__);
+				goto unlock_and_return;
+			}
+			div <<= 1;
+		} else {
+			if (div <= 2)
+				goto unlock_and_return;
+			div >>= 1;
+		}
+		val = ((val & ~PRCM_CLK_MGT_CLKPLLDIV_MASK) |
+			(div & PRCM_CLK_MGT_CLKPLLDIV_MASK));
+		writel(val, clock_reg[i]);
+	}
+
+unlock_and_return:
+	/* Release the HW semaphore. */
+	writel(0, PRCM_SEM);
+
+	spin_unlock_irqrestore(&clk_mgt_lock, flags);
+}
+
 /**
  * db8500_set_ape_opp - set the appropriate APE OPP
  * @opp: The new APE operating point to which transition is to be made
@@ -976,14 +1029,24 @@ int db8500_prcmu_set_ape_opp(u8 opp)
 {
 	int r = 0;
 
+	if (opp == mb1_transfer.ape_opp)
+		return 0;
+
 	mutex_lock(&mb1_transfer.lock);
 
+	if (mb1_transfer.ape_opp == APE_50_PARTLY_25_OPP)
+		request_even_slower_clocks(false);
+
+	if ((opp != APE_100_OPP) && (mb1_transfer.ape_opp != APE_100_OPP))
+		goto skip_message;
+
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
 	writeb(MB1H_ARM_APE_OPP, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
 	writeb(ARM_NO_CHANGE, (tcdm_base + PRCM_REQ_MB1_ARM_OPP));
-	writeb(opp, (tcdm_base + PRCM_REQ_MB1_APE_OPP));
+	writeb(((opp == APE_50_PARTLY_25_OPP) ? APE_50_OPP : opp),
+		(tcdm_base + PRCM_REQ_MB1_APE_OPP));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
@@ -992,6 +1055,13 @@ int db8500_prcmu_set_ape_opp(u8 opp)
 		(mb1_transfer.ack.ape_opp != opp))
 		r = -EIO;
 
+skip_message:
+	if ((!r && (opp == APE_50_PARTLY_25_OPP)) ||
+		(r && (mb1_transfer.ape_opp == APE_50_PARTLY_25_OPP)))
+		request_even_slower_clocks(true);
+	if (!r)
+		mb1_transfer.ape_opp = opp;
+
 	mutex_unlock(&mb1_transfer.lock);
 
 	return r;
@@ -2631,6 +2701,7 @@ void __init db8500_prcmu_early_init(void)
 	init_completion(&mb0_transfer.ac_wake_work);
 	mutex_init(&mb1_transfer.lock);
 	init_completion(&mb1_transfer.work);
+	mb1_transfer.ape_opp = APE_NO_CHANGE;
 	mutex_init(&mb2_transfer.lock);
 	init_completion(&mb2_transfer.work);
 	spin_lock_init(&mb2_transfer.auto_pm_lock);
diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
index c5028f1..841342c 100644
--- a/include/linux/mfd/db8500-prcmu.h
+++ b/include/linux/mfd/db8500-prcmu.h
@@ -457,6 +457,25 @@ enum hw_acc_dev {
 	NUM_HW_ACC
 };
 
+/**
+ * enum prcmu_power_status - results from set_power_state
+ * @PRCMU_SLEEP_OK: Sleep went ok
+ * @PRCMU_DEEP_SLEEP_OK: DeepSleep went ok
+ * @PRCMU_IDLE_OK: Idle went ok
+ * @PRCMU_DEEPIDLE_OK: DeepIdle went ok
+ * @PRCMU_PRCMU2ARMPENDINGIT_ER: Pending interrupt detected
+ * @PRCMU_ARMPENDINGIT_ER: Pending interrupt detected
+ *
+ */
+enum prcmu_power_status {
+	PRCMU_SLEEP_OK			= 0xf3,
+	PRCMU_DEEP_SLEEP_OK		= 0xf6,
+	PRCMU_IDLE_OK			= 0xf0,
+	PRCMU_DEEPIDLE_OK		= 0xe3,
+	PRCMU_PRCMU2ARMPENDINGIT_ER	= 0x91,
+	PRCMU_ARMPENDINGIT_ER		= 0x93,
+};
+
 /*
  * Definitions for autonomous power management configuration.
  */
@@ -544,6 +563,7 @@ int db8500_prcmu_load_a9wdog(u8 id, u32 val);
 
 void db8500_prcmu_system_reset(u16 reset_code);
 int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
+u8 db8500_prcmu_get_power_state_result(void);
 void db8500_prcmu_enable_wakeups(u32 wakeups);
 int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state);
 int db8500_prcmu_request_clock(u8 clock, bool enable);
@@ -699,6 +719,11 @@ static inline int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 	return 0;
 }
 
+static inline u8 db8500_prcmu_get_power_state_result(void)
+{
+	return 0;
+}
+
 static inline void db8500_prcmu_enable_wakeups(u32 wakeups) {}
 
 static inline int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 8470c7d..432a2d3 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -185,12 +185,14 @@ enum prcmu_clock {
  * @APE_NO_CHANGE: The APE operating point is unchanged
  * @APE_100_OPP: The new APE operating point is ape100opp
  * @APE_50_OPP: 50%
+ * @APE_50_PARTLY_25_OPP: 50%, except some clocks at 25%.
  */
 enum ape_opp {
 	APE_OPP_INIT = 0x00,
 	APE_NO_CHANGE = 0x01,
 	APE_100_OPP = 0x02,
-	APE_50_OPP = 0x03
+	APE_50_OPP = 0x03,
+	APE_50_PARTLY_25_OPP = 0xFF,
 };
 
 /**
@@ -271,6 +273,14 @@ static inline int prcmu_set_power_state(u8 state, bool keep_ulp_clk,
 			keep_ap_pll);
 }
 
+static inline u8 prcmu_get_power_state_result(void)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_get_power_state_result();
+}
+
 static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
 	if (cpu_is_u5500())
@@ -663,9 +673,10 @@ static inline int prcmu_stop_temp_sense(void)
 /* PRCMU QoS APE OPP class */
 #define PRCMU_QOS_APE_OPP 1
 #define PRCMU_QOS_DDR_OPP 2
+#define PRCMU_QOS_ARM_OPP 3
 #define PRCMU_QOS_DEFAULT_VALUE -1
 
-#ifdef CONFIG_UX500_PRCMU_QOS_POWER
+#ifdef CONFIG_DBX500_PRCMU_QOS_POWER
 
 unsigned long prcmu_qos_get_cpufreq_opp_delay(void);
 void prcmu_qos_set_cpufreq_opp_delay(unsigned long);
-- 
1.7.8

