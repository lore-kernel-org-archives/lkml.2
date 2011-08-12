Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1HLIai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:30:38 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:43958 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372Ab1HLIab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:30:31 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 18/23] mfd/db5500-prcmu: implement OPP handling
Date: Fri, 12 Aug 2011 10:30:02 +0200
Message-ID: <1313137802-31180-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

This implements the ARM OPP accessor functions necessary to
implement CPUfreq frequency scaling on the DB5500 PRCMU.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db5500-prcmu.c       |   94 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/dbx500-prcmu.h |    4 +-
 2 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index 91bb353..35a7a0c 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -814,6 +814,100 @@ int db5500_prcmu_abb_write(u8 slave, u8 reg, u8 *value, u8 size)
 	return r;
 }
 
+/**
+ * db5500_prcmu_set_arm_opp - set the appropriate ARM OPP
+ * @opp: The new ARM operating point to which transition is to be made
+ * Returns: 0 on success, non-zero on failure
+ *
+ * This function sets the the operating point of the ARM.
+ */
+int db5500_prcmu_set_arm_opp(u8 opp)
+{
+	int r;
+	u8 db5500_opp;
+
+	r = 0;
+
+	switch (opp) {
+	case ARM_EXTCLK:
+		db5500_opp = DB5500_ARM_EXT_OPP;
+		break;
+	case ARM_50_OPP:
+		db5500_opp = DB5500_ARM_50_OPP;
+		break;
+	case ARM_100_OPP:
+		db5500_opp = DB5500_ARM_100_OPP;
+		break;
+	default:
+		pr_err("prcmu: %s() received wrong opp value: %d\n",
+				__func__, opp);
+		r = -EINVAL;
+		goto bailout;
+	}
+
+	mutex_lock(&mb1_transfer.lock);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+		cpu_relax();
+
+	writeb(MB1H_ARM_OPP, PRCM_REQ_MB1_HEADER);
+
+	writeb(db5500_opp, PRCM_REQ_MB1_ARM_OPP);
+	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
+
+	if (!wait_for_completion_timeout(&mb1_transfer.work,
+		msecs_to_jiffies(500))) {
+		r = -EIO;
+		WARN(1, "prcmu: failed to set arm opp");
+		goto unlock_and_return;
+	}
+
+	if (mb1_transfer.ack.header != MB1H_ARM_OPP ||
+		(mb1_transfer.ack.arm_opp != db5500_opp) ||
+		(mb1_transfer.ack.arm_voltage_st != RC_SUCCESS))
+		r = -EIO;
+
+unlock_and_return:
+	mutex_unlock(&mb1_transfer.lock);
+bailout:
+	return r;
+}
+
+/**
+ * db5500_prcmu_get_arm_opp - get the current ARM OPP
+ *
+ * Returns: the current ARM OPP
+ */
+int db5500_prcmu_get_arm_opp(void)
+{
+	return readb(PRCM_ACK_MB1_CURRENT_ARM_OPP);
+}
+
+int prcmu_resetout(u8 resoutn, u8 state)
+{
+	int pin = -1;
+
+	switch (resoutn) {
+	case 0:
+		pin = PRCMU_RESOUTN0_PIN;
+		break;
+	case 1:
+		pin = PRCMU_RESOUTN1_PIN;
+		break;
+	case 2:
+		pin = PRCMU_RESOUTN2_PIN;
+	default:
+		break;
+	}
+
+	if (pin > 0)
+		writel(pin, state > 0 ? PRCM_RESOUTN_SET : PRCM_RESOUTN_CLR);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
 int db5500_prcmu_enable_dsipll(void)
 {
 	int i;
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index e8541ff..78258c4 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -295,7 +295,7 @@ int prcmu_get_ddr_opp(void);
 static inline int prcmu_set_arm_opp(u8 opp)
 {
 	if (machine_is_u5500())
-		return -EINVAL;
+		return db5500_prcmu_set_arm_opp(opp);
 	else
 		return db8500_prcmu_set_arm_opp(opp);
 }
@@ -303,7 +303,7 @@ static inline int prcmu_set_arm_opp(u8 opp)
 static inline int prcmu_get_arm_opp(void)
 {
 	if (machine_is_u5500())
-		return -EINVAL;
+		return db5500_prcmu_get_arm_opp();
 	else
 		return db8500_prcmu_get_arm_opp();
 }
-- 
1.7.3.2

