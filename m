Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab2IEKEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:04:09 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:55532 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758418Ab2IEJ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:49 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 07/17] mfd: prcmu: configurable tcdm base address
Date: Wed, 5 Sep 2012 11:59:03 +0200
Message-ID: <1346839153-6465-8-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows using same services on different hardware
having different configuration.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 195 +++++++++++++++++++++++----------------------
 1 file changed, 101 insertions(+), 94 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 1d2fb45..3df427f 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -425,6 +425,7 @@ static DEFINE_SPINLOCK(prcmu_lock);
 static DEFINE_SPINLOCK(clkout_lock);
 
 /* Global var to runtime determine TCDM base for v2 or v1 */
+static __iomem void *tcdm_legacy_base;
 static __iomem void *tcdm_base;
 
 struct clk_mgt {
@@ -778,12 +779,14 @@ int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
 
-	writeb(MB0H_POWER_STATE_TRANS, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
-	writeb(state, (tcdm_base + PRCM_REQ_MB0_AP_POWER_STATE));
-	writeb((keep_ap_pll ? 1 : 0), (tcdm_base + PRCM_REQ_MB0_AP_PLL_STATE));
+	writeb(MB0H_POWER_STATE_TRANS,
+			tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB0);
+	writeb(state, (tcdm_legacy_base + PRCM_REQ_MB0_AP_POWER_STATE));
+	writeb((keep_ap_pll ? 1 : 0),
+			tcdm_legacy_base + PRCM_REQ_MB0_AP_PLL_STATE);
 	writeb((keep_ulp_clk ? 1 : 0),
-		(tcdm_base + PRCM_REQ_MB0_ULP_CLOCK_STATE));
-	writeb(0, (tcdm_base + PRCM_REQ_MB0_DO_NOT_WFI));
+		(tcdm_legacy_base + PRCM_REQ_MB0_ULP_CLOCK_STATE));
+	writeb(0, (tcdm_legacy_base + PRCM_REQ_MB0_DO_NOT_WFI));
 	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
@@ -793,7 +796,7 @@ int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 
 u8 db8500_prcmu_get_power_state_result(void)
 {
-	return readb(tcdm_base + PRCM_ACK_MB0_AP_PWRSTTR_STATUS);
+	return readb(tcdm_legacy_base + PRCM_ACK_MB0_AP_PWRSTTR_STATUS);
 }
 
 /* This function decouple the gic from the prcmu */
@@ -933,9 +936,9 @@ static void config_wakeups(void)
 	for (i = 0; i < 2; i++) {
 		while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 			cpu_relax();
-		writel(dbb_events, (tcdm_base + PRCM_REQ_MB0_WAKEUP_8500));
-		writel(abb_events, (tcdm_base + PRCM_REQ_MB0_WAKEUP_4500));
-		writeb(header[i], (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
+		writel(dbb_events, tcdm_legacy_base + PRCM_REQ_MB0_WAKEUP_8500);
+		writel(abb_events, tcdm_legacy_base + PRCM_REQ_MB0_WAKEUP_4500);
+		writeb(header[i], tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB0);
 		writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 	}
 	last_dbb_events = dbb_events;
@@ -977,10 +980,10 @@ void db8500_prcmu_config_abb_event_readout(u32 abb_events)
 
 void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
 {
-	if (readb(tcdm_base + PRCM_ACK_MB0_READ_POINTER) & 1)
-		*buf = (tcdm_base + PRCM_ACK_MB0_WAKEUP_1_4500);
+	if (readb(tcdm_legacy_base + PRCM_ACK_MB0_READ_POINTER) & 1)
+		*buf = (tcdm_legacy_base + PRCM_ACK_MB0_WAKEUP_1_4500);
 	else
-		*buf = (tcdm_base + PRCM_ACK_MB0_WAKEUP_0_4500);
+		*buf = (tcdm_legacy_base + PRCM_ACK_MB0_WAKEUP_0_4500);
 }
 
 /**
@@ -1004,9 +1007,9 @@ int db8500_prcmu_set_arm_opp(u8 opp)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
-	writeb(MB1H_ARM_APE_OPP, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
-	writeb(opp, (tcdm_base + PRCM_REQ_MB1_ARM_OPP));
-	writeb(APE_NO_CHANGE, (tcdm_base + PRCM_REQ_MB1_APE_OPP));
+	writeb(MB1H_ARM_APE_OPP, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writeb(opp, (tcdm_legacy_base + PRCM_REQ_MB1_ARM_OPP));
+	writeb(APE_NO_CHANGE, (tcdm_legacy_base + PRCM_REQ_MB1_APE_OPP));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
@@ -1027,7 +1030,7 @@ int db8500_prcmu_set_arm_opp(u8 opp)
  */
 int db8500_prcmu_get_arm_opp(void)
 {
-	return readb(tcdm_base + PRCM_ACK_MB1_CURRENT_ARM_OPP);
+	return readb(tcdm_legacy_base + PRCM_ACK_MB1_CURRENT_ARM_OPP);
 }
 
 /**
@@ -1129,10 +1132,10 @@ int db8500_prcmu_set_ape_opp(u8 opp)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
-	writeb(MB1H_ARM_APE_OPP, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
-	writeb(ARM_NO_CHANGE, (tcdm_base + PRCM_REQ_MB1_ARM_OPP));
+	writeb(MB1H_ARM_APE_OPP, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writeb(ARM_NO_CHANGE, (tcdm_legacy_base + PRCM_REQ_MB1_ARM_OPP));
 	writeb(((opp == APE_50_PARTLY_25_OPP) ? APE_50_OPP : opp),
-		(tcdm_base + PRCM_REQ_MB1_APE_OPP));
+		(tcdm_legacy_base + PRCM_REQ_MB1_APE_OPP));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
@@ -1160,7 +1163,7 @@ skip_message:
  */
 int db8500_prcmu_get_ape_opp(void)
 {
-	return readb(tcdm_base + PRCM_ACK_MB1_CURRENT_APE_OPP);
+	return readb(tcdm_legacy_base + PRCM_ACK_MB1_CURRENT_APE_OPP);
 }
 
 /**
@@ -1194,7 +1197,7 @@ int prcmu_request_ape_opp_100_voltage(bool enable)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
-	writeb(header, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writeb(header, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
@@ -1224,7 +1227,7 @@ int prcmu_release_usb_wakeup_state(void)
 		cpu_relax();
 
 	writeb(MB1H_RELEASE_USB_WAKEUP,
-		(tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+		(tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
@@ -1254,8 +1257,8 @@ static int request_pll(u8 clock, bool enable)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
-	writeb(MB1H_PLL_ON_OFF, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
-	writeb(clock, (tcdm_base + PRCM_REQ_MB1_PLL_ON_OFF));
+	writeb(MB1H_PLL_ON_OFF, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writeb(clock, (tcdm_legacy_base + PRCM_REQ_MB1_PLL_ON_OFF));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
@@ -1308,10 +1311,11 @@ int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 
 	/* fill in mailbox */
 	for (i = 0; i < NUM_EPOD_ID; i++)
-		writeb(EPOD_STATE_NO_CHANGE, (tcdm_base + PRCM_REQ_MB2 + i));
-	writeb(epod_state, (tcdm_base + PRCM_REQ_MB2 + epod_id));
+		writeb(EPOD_STATE_NO_CHANGE,
+				tcdm_legacy_base + PRCM_REQ_MB2 + i);
+	writeb(epod_state, (tcdm_legacy_base + PRCM_REQ_MB2 + epod_id));
 
-	writeb(MB2H_DPS, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB2));
+	writeb(MB2H_DPS, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB2));
 
 	writel(MBOX_BIT(2), PRCM_MBOX_CPU_SET);
 
@@ -1371,8 +1375,8 @@ void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	 * fields in mailbox 2, but these fields are only used as shared
 	 * variables - i.e. there is no need to send a message.
 	 */
-	writel(sleep_cfg, (tcdm_base + PRCM_REQ_MB2_AUTO_PM_SLEEP));
-	writel(idle_cfg, (tcdm_base + PRCM_REQ_MB2_AUTO_PM_IDLE));
+	writel(sleep_cfg, (tcdm_legacy_base + PRCM_REQ_MB2_AUTO_PM_SLEEP));
+	writel(idle_cfg, (tcdm_legacy_base + PRCM_REQ_MB2_AUTO_PM_IDLE));
 
 	mb2_transfer.auto_pm_enabled =
 		((sleep->sva_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
@@ -1403,9 +1407,9 @@ static int request_sysclk(bool enable)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(3))
 		cpu_relax();
 
-	writeb((enable ? ON : OFF), (tcdm_base + PRCM_REQ_MB3_SYSCLK_MGT));
+	writeb((enable ? ON : OFF), tcdm_legacy_base + PRCM_REQ_MB3_SYSCLK_MGT);
 
-	writeb(MB3H_SYSCLK, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB3));
+	writeb(MB3H_SYSCLK, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB3));
 	writel(MBOX_BIT(3), PRCM_MBOX_CPU_SET);
 
 	spin_unlock_irqrestore(&mb3_transfer.lock, flags);
@@ -2009,12 +2013,12 @@ int db8500_prcmu_config_esram0_deep_sleep(u8 state)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
-	writeb(MB4H_MEM_ST, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+	writeb(MB4H_MEM_ST, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 	writeb(((DDR_PWR_STATE_OFFHIGHLAT << 4) | DDR_PWR_STATE_ON),
-	       (tcdm_base + PRCM_REQ_MB4_DDR_ST_AP_SLEEP_IDLE));
+	       (tcdm_legacy_base + PRCM_REQ_MB4_DDR_ST_AP_SLEEP_IDLE));
 	writeb(DDR_PWR_STATE_ON,
-	       (tcdm_base + PRCM_REQ_MB4_DDR_ST_AP_DEEP_IDLE));
-	writeb(state, (tcdm_base + PRCM_REQ_MB4_ESRAM0_ST));
+	       (tcdm_legacy_base + PRCM_REQ_MB4_DDR_ST_AP_DEEP_IDLE));
+	writeb(state, (tcdm_legacy_base + PRCM_REQ_MB4_ESRAM0_ST));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
@@ -2031,8 +2035,8 @@ int db8500_prcmu_config_hotdog(u8 threshold)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
-	writeb(threshold, (tcdm_base + PRCM_REQ_MB4_HOTDOG_THRESHOLD));
-	writeb(MB4H_HOTDOG, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+	writeb(threshold, (tcdm_legacy_base + PRCM_REQ_MB4_HOTDOG_THRESHOLD));
+	writeb(MB4H_HOTDOG, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
@@ -2049,11 +2053,11 @@ int db8500_prcmu_config_hotmon(u8 low, u8 high)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
-	writeb(low, (tcdm_base + PRCM_REQ_MB4_HOTMON_LOW));
-	writeb(high, (tcdm_base + PRCM_REQ_MB4_HOTMON_HIGH));
+	writeb(low, (tcdm_legacy_base + PRCM_REQ_MB4_HOTMON_LOW));
+	writeb(high, (tcdm_legacy_base + PRCM_REQ_MB4_HOTMON_HIGH));
 	writeb((HOTMON_CONFIG_LOW | HOTMON_CONFIG_HIGH),
-		(tcdm_base + PRCM_REQ_MB4_HOTMON_CONFIG));
-	writeb(MB4H_HOTMON, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+		(tcdm_legacy_base + PRCM_REQ_MB4_HOTMON_CONFIG));
+	writeb(MB4H_HOTMON, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
@@ -2070,8 +2074,8 @@ static int config_hot_period(u16 val)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
-	writew(val, (tcdm_base + PRCM_REQ_MB4_HOT_PERIOD));
-	writeb(MB4H_HOT_PERIOD, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+	writew(val, (tcdm_legacy_base + PRCM_REQ_MB4_HOT_PERIOD));
+	writeb(MB4H_HOT_PERIOD, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
@@ -2102,12 +2106,12 @@ static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
 
-	writeb(d0, (tcdm_base + PRCM_REQ_MB4_A9WDOG_0));
-	writeb(d1, (tcdm_base + PRCM_REQ_MB4_A9WDOG_1));
-	writeb(d2, (tcdm_base + PRCM_REQ_MB4_A9WDOG_2));
-	writeb(d3, (tcdm_base + PRCM_REQ_MB4_A9WDOG_3));
+	writeb(d0, (tcdm_legacy_base + PRCM_REQ_MB4_A9WDOG_0));
+	writeb(d1, (tcdm_legacy_base + PRCM_REQ_MB4_A9WDOG_1));
+	writeb(d2, (tcdm_legacy_base + PRCM_REQ_MB4_A9WDOG_2));
+	writeb(d3, (tcdm_legacy_base + PRCM_REQ_MB4_A9WDOG_3));
 
-	writeb(cmd, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB4));
+	writeb(cmd, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb4_transfer.work);
@@ -2180,11 +2184,12 @@ int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
-	writeb(0, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB5));
-	writeb(PRCMU_I2C_READ(slave), (tcdm_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
-	writeb(PRCMU_I2C_STOP_EN, (tcdm_base + PRCM_REQ_MB5_I2C_HW_BITS));
-	writeb(reg, (tcdm_base + PRCM_REQ_MB5_I2C_REG));
-	writeb(0, (tcdm_base + PRCM_REQ_MB5_I2C_VAL));
+	writeb(0, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB5));
+	writeb(PRCMU_I2C_READ(slave),
+			tcdm_legacy_base + PRCM_REQ_MB5_I2C_SLAVE_OP);
+	writeb(PRCMU_I2C_STOP_EN, tcdm_legacy_base + PRCM_REQ_MB5_I2C_HW_BITS);
+	writeb(reg, (tcdm_legacy_base + PRCM_REQ_MB5_I2C_REG));
+	writeb(0, (tcdm_legacy_base + PRCM_REQ_MB5_I2C_VAL));
 
 	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 
@@ -2230,11 +2235,12 @@ int prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask, u8 size)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
 
-	writeb(~*mask, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB5));
-	writeb(PRCMU_I2C_WRITE(slave), (tcdm_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
-	writeb(PRCMU_I2C_STOP_EN, (tcdm_base + PRCM_REQ_MB5_I2C_HW_BITS));
-	writeb(reg, (tcdm_base + PRCM_REQ_MB5_I2C_REG));
-	writeb(*value, (tcdm_base + PRCM_REQ_MB5_I2C_VAL));
+	writeb(~*mask, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB5));
+	writeb(PRCMU_I2C_WRITE(slave),
+			(tcdm_legacy_base + PRCM_REQ_MB5_I2C_SLAVE_OP));
+	writeb(PRCMU_I2C_STOP_EN, tcdm_legacy_base + PRCM_REQ_MB5_I2C_HW_BITS);
+	writeb(reg, (tcdm_legacy_base + PRCM_REQ_MB5_I2C_REG));
+	writeb(*value, (tcdm_legacy_base + PRCM_REQ_MB5_I2C_VAL));
 
 	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 
@@ -2354,7 +2360,7 @@ bool db8500_prcmu_is_ac_wake_requested(void)
  */
 void db8500_prcmu_system_reset(u16 reset_code)
 {
-	writew(reset_code, (tcdm_base + PRCM_SW_RST_REASON));
+	writew(reset_code, (tcdm_legacy_base + PRCM_SW_RST_REASON));
 	writel(1, PRCM_APE_SOFTRST);
 }
 
@@ -2366,7 +2372,7 @@ void db8500_prcmu_system_reset(u16 reset_code)
  */
 u16 db8500_prcmu_get_reset_code(void)
 {
-	return readw(tcdm_base + PRCM_SW_RST_REASON);
+	return readw(tcdm_legacy_base + PRCM_SW_RST_REASON);
 }
 
 /**
@@ -2379,7 +2385,7 @@ void db8500_prcmu_modem_reset(void)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
-	writeb(MB1H_RESET_MODEM, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writeb(MB1H_RESET_MODEM, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
 	wait_for_completion(&mb1_transfer.work);
 
@@ -2400,7 +2406,8 @@ static void ack_dbb_wakeup(void)
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
 
-	writeb(MB0H_READ_WAKEUP_ACK, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB0));
+	writeb(MB0H_READ_WAKEUP_ACK,
+			tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB0);
 	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
 	spin_unlock_irqrestore(&mb0_transfer.lock, flags);
@@ -2419,14 +2426,16 @@ static bool read_mailbox_0(void)
 	unsigned int n;
 	u8 header;
 
-	header = readb(tcdm_base + PRCM_MBOX_HEADER_ACK_MB0);
+	header = readb(tcdm_legacy_base + PRCM_MBOX_HEADER_ACK_MB0);
 	switch (header) {
 	case MB0H_WAKEUP_EXE:
 	case MB0H_WAKEUP_SLEEP:
-		if (readb(tcdm_base + PRCM_ACK_MB0_READ_POINTER) & 1)
-			ev = readl(tcdm_base + PRCM_ACK_MB0_WAKEUP_1_8500);
+		if (readb(tcdm_legacy_base + PRCM_ACK_MB0_READ_POINTER) & 1)
+			ev = readl(tcdm_legacy_base +
+					PRCM_ACK_MB0_WAKEUP_1_8500);
 		else
-			ev = readl(tcdm_base + PRCM_ACK_MB0_WAKEUP_0_8500);
+			ev = readl(tcdm_legacy_base +
+					PRCM_ACK_MB0_WAKEUP_0_8500);
 
 		if (ev & (WAKEUP_BIT_AC_WAKE_ACK | WAKEUP_BIT_AC_SLEEP_ACK))
 			complete(&mb0_transfer.ac_wake_work);
@@ -2452,12 +2461,13 @@ static bool read_mailbox_0(void)
 
 static bool read_mailbox_1(void)
 {
-	mb1_transfer.ack.header = readb(tcdm_base + PRCM_MBOX_HEADER_REQ_MB1);
-	mb1_transfer.ack.arm_opp = readb(tcdm_base +
+	mb1_transfer.ack.header = readb(tcdm_legacy_base +
+			PRCM_MBOX_HEADER_REQ_MB1);
+	mb1_transfer.ack.arm_opp = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_CURRENT_ARM_OPP);
-	mb1_transfer.ack.ape_opp = readb(tcdm_base +
+	mb1_transfer.ack.ape_opp = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_CURRENT_APE_OPP);
-	mb1_transfer.ack.ape_voltage_status = readb(tcdm_base +
+	mb1_transfer.ack.ape_voltage_status = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_APE_VOLTAGE_STATUS);
 	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLR);
 	complete(&mb1_transfer.work);
@@ -2466,7 +2476,8 @@ static bool read_mailbox_1(void)
 
 static bool read_mailbox_2(void)
 {
-	mb2_transfer.ack.status = readb(tcdm_base + PRCM_ACK_MB2_DPS_STATUS);
+	mb2_transfer.ack.status = readb(tcdm_legacy_base
+			+ PRCM_ACK_MB2_DPS_STATUS);
 	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLR);
 	complete(&mb2_transfer.work);
 	return false;
@@ -2483,7 +2494,7 @@ static bool read_mailbox_4(void)
 	u8 header;
 	bool do_complete = true;
 
-	header = readb(tcdm_base + PRCM_MBOX_HEADER_REQ_MB4);
+	header = readb(tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4);
 	switch (header) {
 	case MB4H_MEM_ST:
 	case MB4H_HOTDOG:
@@ -2511,8 +2522,9 @@ static bool read_mailbox_4(void)
 
 static bool read_mailbox_5(void)
 {
-	mb5_transfer.ack.status = readb(tcdm_base + PRCM_ACK_MB5_I2C_STATUS);
-	mb5_transfer.ack.value = readb(tcdm_base + PRCM_ACK_MB5_I2C_VAL);
+	mb5_transfer.ack.status = readb(tcdm_legacy_base
+			+ PRCM_ACK_MB5_I2C_STATUS);
+	mb5_transfer.ack.value = readb(tcdm_legacy_base + PRCM_ACK_MB5_I2C_VAL);
 	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLR);
 	complete(&mb5_transfer.work);
 	return false;
@@ -2670,29 +2682,24 @@ static int db8500_irq_init(struct device_node *np)
 
 void __init db8500_prcmu_early_init(struct prcmu_tcdm_map *map)
 {
-	if (cpu_is_u8500v2()) {
 		void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);
 
-		if (tcpm_base != NULL) {
-			u32 version;
-			version = readl(tcpm_base + PRCMU_FW_VERSION_OFFSET);
-			fw_info.version.project = version & 0xFF;
-			fw_info.version.api_version = (version >> 8) & 0xFF;
-			fw_info.version.func_version = (version >> 16) & 0xFF;
-			fw_info.version.errata = (version >> 24) & 0xFF;
-			fw_info.valid = true;
-			pr_info("PRCMU firmware: %s, version %d.%d.%d\n",
-				fw_project_name(fw_info.version.project),
-				(version >> 8) & 0xFF, (version >> 16) & 0xFF,
-				(version >> 24) & 0xFF);
-			iounmap(tcpm_base);
-		}
-
-		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE);
-	} else {
-		pr_err("prcmu: Unsupported chip version\n");
-		BUG();
+	if (tcpm_base != NULL) {
+		u32 version;
+		version = readl(tcpm_base + PRCMU_FW_VERSION_OFFSET);
+		fw_info.version.project = version & 0xFF;
+		fw_info.version.api_version = (version >> 8) & 0xFF;
+		fw_info.version.func_version = (version >> 16) & 0xFF;
+		fw_info.version.errata = (version >> 24) & 0xFF;
+		fw_info.valid = true;
+		pr_info("PRCMU firmware: %s, version %d.%d.%d\n",
+			fw_project_name(fw_info.version.project),
+			(version >> 8) & 0xFF, (version >> 16) & 0xFF,
+			(version >> 24) & 0xFF);
+		iounmap(tcpm_base);
 	}
+	tcdm_base = ioremap_nocache(U8500_PRCMU_TCDM_BASE, map->tcdm_size);
+	tcdm_legacy_base = tcdm_base + map->legacy_offset;
 
 	spin_lock_init(&mb0_transfer.lock);
 	spin_lock_init(&mb0_transfer.dbb_irqs_lock);
-- 
1.7.11.1

