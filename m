Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1HLIu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:50:58 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:43058 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab1HLIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:50:57 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 17/23] mfd/db5500-prcmu: sleep handling
Date: Fri, 12 Aug 2011 10:29:54 +0200
Message-ID: <1313137794-31147-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vijaya Kumar Kilari <vijay.kilari@stericsson.com>

This implements accessors for requesting system sleep states
including the onchip RAM retention.

Signed-off-by: Vijaya Kumar Kilari <vijay.kilari@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db5500-prcmu.c       |   61 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/dbx500-prcmu.h |    2 +-
 2 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index e374481..91bb353 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -626,6 +626,67 @@ static void config_wakeups(void)
 	last_abb_events = abb_events;
 }
 
+int db5500_prcmu_config_esram0_deep_sleep(u8 state)
+{
+	unsigned long flags;
+
+	if ((state > ESRAM0_DEEP_SLEEP_STATE_RET) ||
+	    (state < ESRAM0_DEEP_SLEEP_STATE_OFF))
+		return -EINVAL;
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	if (state == ESRAM0_DEEP_SLEEP_STATE_RET)
+		writeb(RET_ST, PRCM_REQ_MB0_ESRAM0_STATE);
+	else
+		writeb(OFF_ST, PRCM_REQ_MB0_ESRAM0_STATE);
+
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+
+	return 0;
+}
+
+int db5500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
+{
+	int r = 0;
+	unsigned long flags;
+
+	/* Deep Idle is not supported in DB5500 */
+	BUG_ON((state < PRCMU_AP_SLEEP) || (state >= PRCMU_AP_DEEP_IDLE));
+
+	spin_lock_irqsave(&mb0_transfer.lock, flags);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
+		cpu_relax();
+
+	switch (state) {
+	case PRCMU_AP_IDLE:
+		writeb(DB5500_AP_IDLE, PRCM_REQ_MB0_AP_POWER_STATE);
+		/* TODO: Can be high latency */
+		writeb(DDR_PWR_STATE_UNCHANGED, PRCM_REQ_MB0_DDR_STATE);
+		break;
+	case PRCMU_AP_SLEEP:
+		writeb(DB5500_AP_SLEEP, PRCM_REQ_MB0_AP_POWER_STATE);
+		break;
+	case PRCMU_AP_DEEP_SLEEP:
+		writeb(DB5500_AP_DEEP_SLEEP, PRCM_REQ_MB0_AP_POWER_STATE);
+		break;
+	default:
+		r = -EINVAL;
+		goto unlock_return;
+	}
+	writeb((keep_ap_pll ? 1 : 0), PRCM_REQ_MB0_AP_PLL_STATE);
+	writeb((keep_ulp_clk ? 1 : 0), PRCM_REQ_MB0_ULP_CLOCK_STATE);
+
+	writeb(MB0H_PWR_STATE_TRANS, PRCM_REQ_MB0_HEADER);
+	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
+
+unlock_return:
+	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
+
+	return r;
+}
+
 void db5500_prcmu_enable_wakeups(u32 wakeups)
 {
 	unsigned long flags;
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index bac942f..e8541ff 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -362,7 +362,7 @@ static inline int prcmu_enable_dsipll(void)
 static inline int prcmu_config_esram0_deep_sleep(u8 state)
 {
 	if (machine_is_u5500())
-		return -EINVAL;
+		return db5500_prcmu_config_esram0_deep_sleep(state);
 	else
 		return db8500_prcmu_config_esram0_deep_sleep(state);
 }
-- 
1.7.3.2

