Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2BTLa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:30:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51044 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2BTLa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:30:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel.lezcano@linaro.org designates 10.216.134.5 as permitted sender) smtp.mail=daniel.lezcano@linaro.org
MIME-Version: 1.0
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: sameo@linux.intel.com
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V3] ux500 : decouple/recouple gic from the PRCMU
Date: Mon, 20 Feb 2012 12:30:26 +0100
Message-Id: <1329737426-12855-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to decouple and recouple the gic from the PRCMU.
This is needed to put the A9 core in retention mode with the cpuidle
driver.

It is based on top of the "DB8500 PRCMU update" patchset.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |   32 ++++++++++++++++++++++++++++++++
 include/linux/mfd/db8500-prcmu.h |    2 ++
 include/linux/mfd/dbx500-prcmu.h |   16 ++++++++++++++++
 3 files changed, 50 insertions(+)

Index: mfd-2.6/drivers/mfd/db8500-prcmu.c
===================================================================
--- mfd-2.6.orig/drivers/mfd/db8500-prcmu.c
+++ mfd-2.6/drivers/mfd/db8500-prcmu.c
@@ -821,6 +821,38 @@ u8 db8500_prcmu_get_power_state_result(v
 	return readb(tcdm_base + PRCM_ACK_MB0_AP_PWRSTTR_STATUS);
 }
 
+#define PRCMU_A9_MASK_REQ               0x00000328
+#define PRCMU_A9_MASK_REQ_MASK          0x00000001
+#define PRCMU_GIC_DELAY                 1
+
+/* This function decouple the gic from the prcmu */
+int db8500_prcmu_gic_decouple(void)
+{
+	u32 val = readl(_PRCMU_BASE + PRCMU_A9_MASK_REQ);
+
+	/* Set bit 0 register value to 1 */
+	writel(val | PRCMU_A9_MASK_REQ_MASK, _PRCMU_BASE + PRCMU_A9_MASK_REQ);
+
+	/* Make sure the register is updated */
+	readl(_PRCMU_BASE + PRCMU_A9_MASK_REQ);
+
+	/* Wait a few cycles for the gic mask completion */
+	udelay(PRCMU_GIC_DELAY);
+
+	return 0;
+}
+
+/* This function recouple the gic with the prcmu */
+int db8500_prcmu_gic_recouple(void)
+{
+	u32 val = readl(_PRCMU_BASE + PRCMU_A9_MASK_REQ);
+
+	/* Set bit 0 register value to 0 */
+	writel(val & ~PRCMU_A9_MASK_REQ_MASK, _PRCMU_BASE + PRCMU_A9_MASK_REQ);
+
+	return 0;
+}
+
 /* This function should only be called while mb0_transfer.lock is held. */
 static void config_wakeups(void)
 {
Index: mfd-2.6/include/linux/mfd/db8500-prcmu.h
===================================================================
--- mfd-2.6.orig/include/linux/mfd/db8500-prcmu.h
+++ mfd-2.6/include/linux/mfd/db8500-prcmu.h
@@ -580,6 +580,8 @@ int db8500_prcmu_load_a9wdog(u8 id, u32
 void db8500_prcmu_system_reset(u16 reset_code);
 int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll);
 u8 db8500_prcmu_get_power_state_result(void);
+int db8500_prcmu_gic_decouple(void);
+int db8500_prcmu_gic_recouple(void);
 void db8500_prcmu_enable_wakeups(u32 wakeups);
 int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state);
 int db8500_prcmu_request_clock(u8 clock, bool enable);
Index: mfd-2.6/include/linux/mfd/dbx500-prcmu.h
===================================================================
--- mfd-2.6.orig/include/linux/mfd/dbx500-prcmu.h
+++ mfd-2.6/include/linux/mfd/dbx500-prcmu.h
@@ -281,6 +281,22 @@ static inline u8 prcmu_get_power_state_r
 		return db8500_prcmu_get_power_state_result();
 }
 
+static inline int prcmu_gic_decouple(void)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_gic_decouple();
+}
+
+static inline int prcmu_gic_recouple(void)
+{
+	if (cpu_is_u5500())
+		return -EINVAL;
+	else
+		return db8500_prcmu_gic_recouple();
+}
+
 static inline int prcmu_set_epod(u16 epod_id, u8 epod_state)
 {
 	if (cpu_is_u5500())
