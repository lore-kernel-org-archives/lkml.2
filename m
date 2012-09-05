Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab2IEKDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:03:14 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:46677 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758429Ab2IEJ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:52 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 13/17] mfd: prcmu: make legacy mailbox services configurable
Date: Wed, 5 Sep 2012 11:59:09 +0200
Message-ID: <1346839153-6465-14-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8500 and x540 are using same services based on prcmu legacy
mailbox but with different base address and different arguments.

Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c | 371 +++++++++++++++++++++++++++------------------
 drivers/mfd/dbx500-prcmu.h |  16 ++
 2 files changed, 243 insertions(+), 144 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 327e9f6..73c98e5 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -137,13 +137,21 @@ static DEFINE_SPINLOCK(clkout_lock);
 static __iomem void *tcdm_legacy_base;
 static __iomem void *tcdm_base;
 
+/* mailbox pointers */
+static struct mb0_transfer *mb0;
+static struct mb1_transfer *mb1;
+static struct mb2_transfer *mb2;
+static struct mb3_transfer *mb3;
+static struct mb4_transfer *mb4;
+static struct mb5_transfer *mb5;
+
 /* mailbox definition */
-static struct mb0_transfer mb0;
-static struct mb1_transfer mb1;
-static struct mb2_transfer mb2;
-static struct mb3_transfer mb3;
-static struct mb4_transfer mb4;
-static struct mb5_transfer mb5;
+static struct mb0_transfer db8500_mb0;
+static struct mb1_transfer db8500_mb1;
+static struct mb2_transfer db8500_mb2;
+static struct mb3_transfer db8500_mb3;
+static struct mb4_transfer db8500_mb4;
+static struct mb5_transfer db8500_mb5;
 
 static DEFINE_SPINLOCK(clk_mgt_lock);
 
@@ -472,20 +480,31 @@ unlock_and_return:
 	return r;
 }
 
+static u8 db8500_fw_trans[] = {
+	0x00,/* PRCMU_AP_NO_CHANGE */
+	0x01,/* PRCMU_AP_SLEEP */
+	0x04,/*	PRCMU_AP_DEEP_SLEEP */
+	0x05,/*	PRCMU_AP_IDLE */
+	0x07,/*	PRCMU_AP_DEEP_IDLE*/
+};
+
+static u8 *fw_trans;
+static u32 fw_trans_nb;
+
 int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 {
 	unsigned long flags;
 
-	BUG_ON((state < PRCMU_AP_SLEEP) || (PRCMU_AP_DEEP_IDLE < state));
-
-	spin_lock_irqsave(&mb0.lock, flags);
+	BUG_ON((state == PRCMU_AP_NO_CHANGE) ||
+			(state >= fw_trans_nb));
+	spin_lock_irqsave(&mb0->lock, flags);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
 
 	writeb(MB0H_POWER_STATE_TRANS,
 			tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB0);
-	writeb(state, (tcdm_legacy_base + PRCM_REQ_MB0_AP_POWER_STATE));
+	writeb(fw_trans[state], tcdm_legacy_base + PRCM_REQ_MB0_AP_POWER_STATE);
 	writeb((keep_ap_pll ? 1 : 0),
 			tcdm_legacy_base + PRCM_REQ_MB0_AP_PLL_STATE);
 	writeb((keep_ulp_clk ? 1 : 0),
@@ -493,7 +512,7 @@ int db8500_prcmu_set_power_state(u8 state, bool keep_ulp_clk, bool keep_ap_pll)
 	writeb(0, (tcdm_legacy_base + PRCM_REQ_MB0_DO_NOT_WFI));
 	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
-	spin_unlock_irqrestore(&mb0.lock, flags);
+	spin_unlock_irqrestore(&mb0->lock, flags);
 
 	return 0;
 }
@@ -616,7 +635,7 @@ int db8500_prcmu_copy_gic_settings(void)
 	return 0;
 }
 
-/* This function should only be called while mb0.lock is held. */
+/* This function should only be called while mb0->lock is held. */
 static void config_wakeups(void)
 {
 	const u8 header[2] = {
@@ -629,10 +648,10 @@ static void config_wakeups(void)
 	u32 abb_events;
 	unsigned int i;
 
-	dbb_events = mb0.req.dbb_irqs | mb0.req.dbb_wakeups;
+	dbb_events = mb0->req.dbb_irqs | mb0->req.dbb_wakeups;
 	dbb_events |= (WAKEUP_BIT_AC_WAKE_ACK | WAKEUP_BIT_AC_SLEEP_ACK);
 
-	abb_events = mb0.req.abb_events;
+	abb_events = mb0->req.abb_events;
 
 	if ((dbb_events == last_dbb_events) && (abb_events == last_abb_events))
 		return;
@@ -662,24 +681,24 @@ static void db8500_prcmu_enable_wakeups(u32 wakeups)
 			bits |= prcmu_wakeup_bit[i];
 	}
 
-	spin_lock_irqsave(&mb0.lock, flags);
+	spin_lock_irqsave(&mb0->lock, flags);
 
-	mb0.req.dbb_wakeups = bits;
+	mb0->req.dbb_wakeups = bits;
 	config_wakeups();
 
-	spin_unlock_irqrestore(&mb0.lock, flags);
+	spin_unlock_irqrestore(&mb0->lock, flags);
 }
 
 static void db8500_prcmu_config_abb_event_readout(u32 abb_events)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0.lock, flags);
+	spin_lock_irqsave(&mb0->lock, flags);
 
-	mb0.req.abb_events = abb_events;
+	mb0->req.abb_events = abb_events;
 	config_wakeups();
 
-	spin_unlock_irqrestore(&mb0.lock, flags);
+	spin_unlock_irqrestore(&mb0->lock, flags);
 }
 
 static void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
@@ -706,7 +725,7 @@ static int db8500_prcmu_set_arm_opp(u8 opp)
 
 	r = 0;
 
-	mutex_lock(&mb1.lock);
+	mutex_lock(&mb1->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
@@ -716,13 +735,13 @@ static int db8500_prcmu_set_arm_opp(u8 opp)
 	writeb(APE_NO_CHANGE, (tcdm_legacy_base + PRCM_REQ_MB1_APE_OPP));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1.work);
+	wait_for_completion(&mb1->work);
 
-	if ((mb1.ack.header != MB1H_ARM_APE_OPP) ||
-		(mb1.ack.arm_opp != opp))
+	if ((mb1->ack.header != MB1H_ARM_APE_OPP) ||
+		(mb1->ack.arm_opp != opp))
 		r = -EIO;
 
-	mutex_unlock(&mb1.lock);
+	mutex_unlock(&mb1->lock);
 
 	return r;
 }
@@ -822,15 +841,15 @@ static int db8500_prcmu_set_ape_opp(u8 opp)
 {
 	int r = 0;
 
-	if (opp == mb1.ape_opp)
+	if (opp == mb1->ape_opp)
 		return 0;
 
-	mutex_lock(&mb1.lock);
+	mutex_lock(&mb1->lock);
 
-	if (mb1.ape_opp == APE_50_PARTLY_25_OPP)
+	if (mb1->ape_opp == APE_50_PARTLY_25_OPP)
 		request_even_slower_clocks(false);
 
-	if ((opp != APE_100_OPP) && (mb1.ape_opp != APE_100_OPP))
+	if ((opp != APE_100_OPP) && (mb1->ape_opp != APE_100_OPP))
 		goto skip_message;
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
@@ -842,20 +861,20 @@ static int db8500_prcmu_set_ape_opp(u8 opp)
 		(tcdm_legacy_base + PRCM_REQ_MB1_APE_OPP));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1.work);
+	wait_for_completion(&mb1->work);
 
-	if ((mb1.ack.header != MB1H_ARM_APE_OPP) ||
-		(mb1.ack.ape_opp != opp))
+	if ((mb1->ack.header != MB1H_ARM_APE_OPP) ||
+		(mb1->ack.ape_opp != opp))
 		r = -EIO;
 
 skip_message:
 	if ((!r && (opp == APE_50_PARTLY_25_OPP)) ||
-		(r && (mb1.ape_opp == APE_50_PARTLY_25_OPP)))
+		(r && (mb1->ape_opp == APE_50_PARTLY_25_OPP)))
 		request_even_slower_clocks(true);
 	if (!r)
-		mb1.ape_opp = opp;
+		mb1->ape_opp = opp;
 
-	mutex_unlock(&mb1.lock);
+	mutex_unlock(&mb1->lock);
 
 	return r;
 }
@@ -882,7 +901,7 @@ static int db8500_prcmu_request_ape_opp_100_voltage(bool enable)
 	u8 header;
 	static unsigned int requests;
 
-	mutex_lock(&mb1.lock);
+	mutex_lock(&mb1->lock);
 
 	if (enable) {
 		if (0 != requests++)
@@ -904,14 +923,14 @@ static int db8500_prcmu_request_ape_opp_100_voltage(bool enable)
 	writeb(header, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1.work);
+	wait_for_completion(&mb1->work);
 
-	if ((mb1.ack.header != header) ||
-		((mb1.ack.ape_voltage_status & BIT(0)) != 0))
+	if ((mb1->ack.header != header) ||
+		((mb1->ack.ape_voltage_status & BIT(0)) != 0))
 		r = -EIO;
 
 unlock_and_return:
-	mutex_unlock(&mb1.lock);
+	mutex_unlock(&mb1->lock);
 
 	return r;
 }
@@ -925,7 +944,7 @@ int prcmu_release_usb_wakeup_state(void)
 {
 	int r = 0;
 
-	mutex_lock(&mb1.lock);
+	mutex_lock(&mb1->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
@@ -934,13 +953,13 @@ int prcmu_release_usb_wakeup_state(void)
 		(tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1.work);
+	wait_for_completion(&mb1->work);
 
-	if ((mb1.ack.header != MB1H_RELEASE_USB_WAKEUP) ||
-		((mb1.ack.ape_voltage_status & BIT(0)) != 0))
+	if ((mb1->ack.header != MB1H_RELEASE_USB_WAKEUP) ||
+		((mb1->ack.ape_voltage_status & BIT(0)) != 0))
 		r = -EIO;
 
-	mutex_unlock(&mb1.lock);
+	mutex_unlock(&mb1->lock);
 
 	return r;
 }
@@ -956,7 +975,7 @@ static int request_pll(u8 clock, bool enable)
 	else
 		return -EINVAL;
 
-	mutex_lock(&mb1.lock);
+	mutex_lock(&mb1->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
@@ -965,12 +984,12 @@ static int request_pll(u8 clock, bool enable)
 	writeb(clock, (tcdm_legacy_base + PRCM_REQ_MB1_PLL_ON_OFF));
 
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1.work);
+	wait_for_completion(&mb1->work);
 
-	if (mb1.ack.header != MB1H_PLL_ON_OFF)
+	if (mb1->ack.header != MB1H_PLL_ON_OFF)
 		r = -EIO;
 
-	mutex_unlock(&mb1.lock);
+	mutex_unlock(&mb1->lock);
 
 	return r;
 }
@@ -1007,7 +1026,7 @@ static int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 	BUG_ON(epod_state == EPOD_STATE_RAMRET && !ram_retention);
 
 	/* get lock */
-	mutex_lock(&mb2.lock);
+	mutex_lock(&mb2->lock);
 
 	/* wait for mailbox */
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(2))
@@ -1028,7 +1047,7 @@ static int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 	 * and we cannot recover if there is an error.
 	 * This is expected to change when the firmware is updated.
 	 */
-	if (!wait_for_completion_timeout(&mb2.work,
+	if (!wait_for_completion_timeout(&mb2->work,
 			msecs_to_jiffies(20000))) {
 		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
 			__func__);
@@ -1036,11 +1055,11 @@ static int db8500_prcmu_set_epod(u16 epod_id, u8 epod_state)
 		goto unlock_and_return;
 	}
 
-	if (mb2.ack.status != HWACC_PWR_ST_OK)
+	if (mb2->ack.status != HWACC_PWR_ST_OK)
 		r = -EIO;
 
 unlock_and_return:
-	mutex_unlock(&mb2.lock);
+	mutex_unlock(&mb2->lock);
 	return r;
 }
 
@@ -1072,7 +1091,7 @@ static void db8500_prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	idle_cfg = ((idle_cfg << 4) | (idle->sva_policy & 0xF));
 	idle_cfg = ((idle_cfg << 4) | (idle->sia_policy & 0xF));
 
-	spin_lock_irqsave(&mb2.auto_pm_lock, flags);
+	spin_lock_irqsave(&mb2->auto_pm_lock, flags);
 
 	/*
 	 * The autonomous power management configuration is done through
@@ -1082,18 +1101,18 @@ static void db8500_prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
 	writel(sleep_cfg, (tcdm_legacy_base + PRCM_REQ_MB2_AUTO_PM_SLEEP));
 	writel(idle_cfg, (tcdm_legacy_base + PRCM_REQ_MB2_AUTO_PM_IDLE));
 
-	mb2.auto_pm_enabled =
+	mb2->auto_pm_enabled =
 		((sleep->sva_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
 		 (sleep->sia_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
 		 (idle->sva_auto_pm_enable == PRCMU_AUTO_PM_ON) ||
 		 (idle->sia_auto_pm_enable == PRCMU_AUTO_PM_ON));
 
-	spin_unlock_irqrestore(&mb2.auto_pm_lock, flags);
+	spin_unlock_irqrestore(&mb2->auto_pm_lock, flags);
 }
 
 bool prcmu_is_auto_pm_enabled(void)
 {
-	return mb2.auto_pm_enabled;
+	return mb2->auto_pm_enabled;
 }
 
 static int request_sysclk(bool enable)
@@ -1103,9 +1122,9 @@ static int request_sysclk(bool enable)
 
 	r = 0;
 
-	mutex_lock(&mb3.sysclk_lock);
+	mutex_lock(&mb3->sysclk_lock);
 
-	spin_lock_irqsave(&mb3.lock, flags);
+	spin_lock_irqsave(&mb3->lock, flags);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(3))
 		cpu_relax();
@@ -1115,20 +1134,20 @@ static int request_sysclk(bool enable)
 	writeb(MB3H_SYSCLK, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB3));
 	writel(MBOX_BIT(3), PRCM_MBOX_CPU_SET);
 
-	spin_unlock_irqrestore(&mb3.lock, flags);
+	spin_unlock_irqrestore(&mb3->lock, flags);
 
 	/*
 	 * The firmware only sends an ACK if we want to enable the
 	 * SysClk, and it succeeds.
 	 */
-	if (enable && !wait_for_completion_timeout(&mb3.sysclk_work,
+	if (enable && !wait_for_completion_timeout(&mb3->sysclk_work,
 			msecs_to_jiffies(20000))) {
 		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
 			__func__);
 		r = -EIO;
 	}
 
-	mutex_unlock(&mb3.sysclk_lock);
+	mutex_unlock(&mb3->sysclk_lock);
 
 	return r;
 }
@@ -1711,7 +1730,7 @@ static int db8500_prcmu_config_esram0_deep_sleep(u8 state)
 	    (state < ESRAM0_DEEP_SLEEP_STATE_OFF))
 		return -EINVAL;
 
-	mutex_lock(&mb4.lock);
+	mutex_lock(&mb4->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -1724,16 +1743,16 @@ static int db8500_prcmu_config_esram0_deep_sleep(u8 state)
 	writeb(state, (tcdm_legacy_base + PRCM_REQ_MB4_ESRAM0_ST));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4.work);
+	wait_for_completion(&mb4->work);
 
-	mutex_unlock(&mb4.lock);
+	mutex_unlock(&mb4->lock);
 
 	return 0;
 }
 
 int db8500_prcmu_config_hotdog(u8 threshold)
 {
-	mutex_lock(&mb4.lock);
+	mutex_lock(&mb4->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -1742,16 +1761,16 @@ int db8500_prcmu_config_hotdog(u8 threshold)
 	writeb(MB4H_HOTDOG, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4.work);
+	wait_for_completion(&mb4->work);
 
-	mutex_unlock(&mb4.lock);
+	mutex_unlock(&mb4->lock);
 
 	return 0;
 }
 
 int db8500_prcmu_config_hotmon(u8 low, u8 high)
 {
-	mutex_lock(&mb4.lock);
+	mutex_lock(&mb4->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -1763,16 +1782,16 @@ int db8500_prcmu_config_hotmon(u8 low, u8 high)
 	writeb(MB4H_HOTMON, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4.work);
+	wait_for_completion(&mb4->work);
 
-	mutex_unlock(&mb4.lock);
+	mutex_unlock(&mb4->lock);
 
 	return 0;
 }
 
 static int config_hot_period(u16 val)
 {
-	mutex_lock(&mb4.lock);
+	mutex_lock(&mb4->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -1781,9 +1800,9 @@ static int config_hot_period(u16 val)
 	writeb(MB4H_HOT_PERIOD, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4.work);
+	wait_for_completion(&mb4->work);
 
-	mutex_unlock(&mb4.lock);
+	mutex_unlock(&mb4->lock);
 
 	return 0;
 }
@@ -1804,7 +1823,7 @@ int db8500_prcmu_stop_temp_sense(void)
 static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
 {
 
-	mutex_lock(&mb4.lock);
+	mutex_lock(&mb4->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(4))
 		cpu_relax();
@@ -1817,9 +1836,9 @@ static int prcmu_a9wdog(u8 cmd, u8 d0, u8 d1, u8 d2, u8 d3)
 	writeb(cmd, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB4));
 
 	writel(MBOX_BIT(4), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb4.work);
+	wait_for_completion(&mb4->work);
 
-	mutex_unlock(&mb4.lock);
+	mutex_unlock(&mb4->lock);
 
 	return 0;
 
@@ -1882,7 +1901,7 @@ static int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 	if (size != 1)
 		return -EINVAL;
 
-	mutex_lock(&mb5.lock);
+	mutex_lock(&mb5->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
@@ -1896,19 +1915,19 @@ static int db8500_prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size)
 
 	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 
-	if (!wait_for_completion_timeout(&mb5.work,
+	if (!wait_for_completion_timeout(&mb5->work,
 				msecs_to_jiffies(20000))) {
 		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
 			__func__);
 		r = -EIO;
 	} else {
-		r = ((mb5.ack.status == I2C_RD_OK) ? 0 : -EIO);
+		r = ((mb5->ack.status == I2C_RD_OK) ? 0 : -EIO);
 	}
 
 	if (!r)
-		*value = mb5.ack.value;
+		*value = mb5->ack.value;
 
-	mutex_unlock(&mb5.lock);
+	mutex_unlock(&mb5->lock);
 
 	return r;
 }
@@ -1934,7 +1953,7 @@ static int db8500_prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
 	if (size != 1)
 		return -EINVAL;
 
-	mutex_lock(&mb5.lock);
+	mutex_lock(&mb5->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(5))
 		cpu_relax();
@@ -1948,16 +1967,16 @@ static int db8500_prcmu_abb_write_masked(u8 slave, u8 reg, u8 *value, u8 *mask,
 
 	writel(MBOX_BIT(5), PRCM_MBOX_CPU_SET);
 
-	if (!wait_for_completion_timeout(&mb5.work,
+	if (!wait_for_completion_timeout(&mb5->work,
 				msecs_to_jiffies(20000))) {
 		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
 			__func__);
 		r = -EIO;
 	} else {
-		r = ((mb5.ack.status == I2C_WR_OK) ? 0 : -EIO);
+		r = ((mb5->ack.status == I2C_WR_OK) ? 0 : -EIO);
 	}
 
-	mutex_unlock(&mb5.lock);
+	mutex_unlock(&mb5->lock);
 
 	return r;
 }
@@ -1987,7 +2006,7 @@ int prcmu_ac_wake_req(void)
 	u32 val;
 	int ret = 0;
 
-	mutex_lock(&mb0.ac_wake_lock);
+	mutex_lock(&mb0->ac_wake_lock);
 
 	val = readl(PRCM_HOSTACCESS_REQ);
 	if (val & PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ)
@@ -2008,7 +2027,7 @@ int prcmu_ac_wake_req(void)
 	val |= PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ;
 	writel(val, PRCM_HOSTACCESS_REQ);
 
-	if (!wait_for_completion_timeout(&mb0.ac_wake_work,
+	if (!wait_for_completion_timeout(&mb0->ac_wake_work,
 			msecs_to_jiffies(5000))) {
 #if defined(CONFIG_DBX500_PRCMU_DEBUG)
 		db8500_prcmu_debug_dump(__func__, true, true);
@@ -2019,7 +2038,7 @@ int prcmu_ac_wake_req(void)
 	}
 
 unlock_and_return:
-	mutex_unlock(&mb0.ac_wake_lock);
+	mutex_unlock(&mb0->ac_wake_lock);
 	return ret;
 }
 
@@ -2030,7 +2049,7 @@ void prcmu_ac_sleep_req()
 {
 	u32 val;
 
-	mutex_lock(&mb0.ac_wake_lock);
+	mutex_lock(&mb0->ac_wake_lock);
 
 	val = readl(PRCM_HOSTACCESS_REQ);
 	if (!(val & PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ))
@@ -2039,7 +2058,7 @@ void prcmu_ac_sleep_req()
 	writel((val & ~PRCM_HOSTACCESS_REQ_HOSTACCESS_REQ),
 		PRCM_HOSTACCESS_REQ);
 
-	if (!wait_for_completion_timeout(&mb0.ac_wake_work,
+	if (!wait_for_completion_timeout(&mb0->ac_wake_work,
 			msecs_to_jiffies(5000))) {
 		pr_crit("prcmu: %s timed out (5 s) waiting for a reply.\n",
 			__func__);
@@ -2048,7 +2067,7 @@ void prcmu_ac_sleep_req()
 	atomic_set(&ac_wake_req_state, 0);
 
 unlock_and_return:
-	mutex_unlock(&mb0.ac_wake_lock);
+	mutex_unlock(&mb0->ac_wake_lock);
 }
 
 static bool db8500_prcmu_is_ac_wake_requested(void)
@@ -2084,28 +2103,28 @@ static u16 db8500_prcmu_get_reset_code(void)
  */
 static void db8500_prcmu_modem_reset(void)
 {
-	mutex_lock(&mb1.lock);
+	mutex_lock(&mb1->lock);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
 		cpu_relax();
 
 	writeb(MB1H_RESET_MODEM, (tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB1));
 	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
-	wait_for_completion(&mb1.work);
+	wait_for_completion(&mb1->work);
 
 	/*
 	 * No need to check return from PRCMU as modem should go in reset state
 	 * This state is already managed by upper layer
 	 */
 
-	mutex_unlock(&mb1.lock);
+	mutex_unlock(&mb1->lock);
 }
 
 static void ack_dbb_wakeup(void)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0.lock, flags);
+	spin_lock_irqsave(&mb0->lock, flags);
 
 	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(0))
 		cpu_relax();
@@ -2114,7 +2133,7 @@ static void ack_dbb_wakeup(void)
 			tcdm_legacy_base + PRCM_MBOX_HEADER_REQ_MB0);
 	writel(MBOX_BIT(0), PRCM_MBOX_CPU_SET);
 
-	spin_unlock_irqrestore(&mb0.lock, flags);
+	spin_unlock_irqrestore(&mb0->lock, flags);
 }
 
 static inline void print_unknown_header_warning(u8 n, u8 header)
@@ -2142,11 +2161,11 @@ static bool read_mailbox_0(void)
 					PRCM_ACK_MB0_WAKEUP_0_8500);
 
 		if (ev & (WAKEUP_BIT_AC_WAKE_ACK | WAKEUP_BIT_AC_SLEEP_ACK))
-			complete(&mb0.ac_wake_work);
+			complete(&mb0->ac_wake_work);
 		if (ev & WAKEUP_BIT_SYSCLK_OK)
-			complete(&mb3.sysclk_work);
+			complete(&mb3->sysclk_work);
 
-		ev &= mb0.req.dbb_irqs;
+		ev &= mb0->req.dbb_irqs;
 
 		for (n = 0; n < NUM_PRCMU_WAKEUPS; n++) {
 			if (ev & prcmu_irq_bit[n])
@@ -2165,25 +2184,25 @@ static bool read_mailbox_0(void)
 
 static bool read_mailbox_1(void)
 {
-	mb1.ack.header = readb(tcdm_legacy_base +
+	mb1->ack.header = readb(tcdm_legacy_base +
 			PRCM_MBOX_HEADER_REQ_MB1);
-	mb1.ack.arm_opp = readb(tcdm_legacy_base +
+	mb1->ack.arm_opp = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_CURRENT_ARM_OPP);
-	mb1.ack.ape_opp = readb(tcdm_legacy_base +
+	mb1->ack.ape_opp = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_CURRENT_APE_OPP);
-	mb1.ack.ape_voltage_status = readb(tcdm_legacy_base +
+	mb1->ack.ape_voltage_status = readb(tcdm_legacy_base +
 		PRCM_ACK_MB1_APE_VOLTAGE_STATUS);
 	writel(MBOX_BIT(1), PRCM_ARM_IT1_CLR);
-	complete(&mb1.work);
+	complete(&mb1->work);
 	return false;
 }
 
 static bool read_mailbox_2(void)
 {
-	mb2.ack.status = readb(tcdm_legacy_base
+	mb2->ack.status = readb(tcdm_legacy_base
 			+ PRCM_ACK_MB2_DPS_STATUS);
 	writel(MBOX_BIT(2), PRCM_ARM_IT1_CLR);
-	complete(&mb2.work);
+	complete(&mb2->work);
 	return false;
 }
 
@@ -2219,18 +2238,18 @@ static bool read_mailbox_4(void)
 	writel(MBOX_BIT(4), PRCM_ARM_IT1_CLR);
 
 	if (do_complete)
-		complete(&mb4.work);
+		complete(&mb4->work);
 
 	return false;
 }
 
 static bool read_mailbox_5(void)
 {
-	mb5.ack.status = readb(tcdm_legacy_base
+	mb5->ack.status = readb(tcdm_legacy_base
 			+ PRCM_ACK_MB5_I2C_STATUS);
-	mb5.ack.value = readb(tcdm_legacy_base + PRCM_ACK_MB5_I2C_VAL);
+	mb5->ack.value = readb(tcdm_legacy_base + PRCM_ACK_MB5_I2C_VAL);
 	writel(MBOX_BIT(5), PRCM_ARM_IT1_CLR);
-	complete(&mb5.work);
+	complete(&mb5->work);
 	return false;
 }
 
@@ -2246,7 +2265,7 @@ static bool read_mailbox_7(void)
 	return false;
 }
 
-static bool (* const read_mailbox[NUM_MB])(void) = {
+static bool (*db8500_read_mailbox[NUM_MB])(void) = {
 	read_mailbox_0,
 	read_mailbox_1,
 	read_mailbox_2,
@@ -2257,6 +2276,8 @@ static bool (* const read_mailbox[NUM_MB])(void) = {
 	read_mailbox_7
 };
 
+static bool (**read_mailbox)(void);
+
 static irqreturn_t prcmu_irq_handler(int irq, void *data)
 {
 	u32 bits;
@@ -2288,39 +2309,39 @@ static void prcmu_mask_work(struct work_struct *work)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0.lock, flags);
+	spin_lock_irqsave(&mb0->lock, flags);
 
 	config_wakeups();
 
-	spin_unlock_irqrestore(&mb0.lock, flags);
+	spin_unlock_irqrestore(&mb0->lock, flags);
 }
 
 static void prcmu_irq_mask(struct irq_data *d)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0.dbb_irqs_lock, flags);
+	spin_lock_irqsave(&mb0->dbb_irqs_lock, flags);
 
-	mb0.req.dbb_irqs &= ~prcmu_irq_bit[d->hwirq];
+	mb0->req.dbb_irqs &= ~prcmu_irq_bit[d->hwirq];
 
-	spin_unlock_irqrestore(&mb0.dbb_irqs_lock, flags);
+	spin_unlock_irqrestore(&mb0->dbb_irqs_lock, flags);
 
 	if (d->irq != IRQ_PRCMU_CA_SLEEP)
-		schedule_work(&mb0.mask_work);
+		schedule_work(&mb0->mask_work);
 }
 
 static void prcmu_irq_unmask(struct irq_data *d)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&mb0.dbb_irqs_lock, flags);
+	spin_lock_irqsave(&mb0->dbb_irqs_lock, flags);
 
-	mb0.req.dbb_irqs |= prcmu_irq_bit[d->hwirq];
+	mb0->req.dbb_irqs |= prcmu_irq_bit[d->hwirq];
 
-	spin_unlock_irqrestore(&mb0.dbb_irqs_lock, flags);
+	spin_unlock_irqrestore(&mb0->dbb_irqs_lock, flags);
 
 	if (d->irq != IRQ_PRCMU_CA_SLEEP)
-		schedule_work(&mb0.mask_work);
+		schedule_work(&mb0->mask_work);
 }
 
 static void noop(struct irq_data *d)
@@ -2553,6 +2574,62 @@ struct prcmu_fops_register_data db8500_probe_data = {
 	.tab = db8500_probe_tab,
 };
 
+int __init db8500_prcmu_init_mb0(struct mb0_transfer *mb)
+{
+	mb0 = mb;
+	spin_lock_init(&mb0->lock);
+	spin_lock_init(&mb0->dbb_irqs_lock);
+	mutex_init(&mb0->ac_wake_lock);
+	init_completion(&mb0->ac_wake_work);
+	INIT_WORK(&mb0->mask_work, prcmu_mask_work);
+
+	return 0;
+}
+
+int __init db8500_prcmu_init_mb1(struct mb1_transfer *mb)
+{
+	mb1 = mb;
+	mutex_init(&mb1->lock);
+	init_completion(&mb1->work);
+	mb1->ape_opp = APE_NO_CHANGE;
+	return 0;
+}
+
+int __init db8500_prcmu_init_mb2(struct mb2_transfer *mb)
+{
+	mb2 = mb;
+	mutex_init(&mb2->lock);
+	init_completion(&mb2->work);
+	spin_lock_init(&mb2->auto_pm_lock);
+	return 0;
+}
+
+int __init db8500_prcmu_init_mb3(struct mb3_transfer *mb)
+{
+	mb3 = mb;
+	spin_lock_init(&mb3->lock);
+	mutex_init(&mb3->sysclk_lock);
+	init_completion(&mb3->sysclk_work);
+	spin_lock_init(&mb3->fw_log_lock);
+	return 0;
+}
+
+int __init db8500_prcmu_init_mb4(struct mb4_transfer *mb)
+{
+	mb4 = mb;
+	mutex_init(&mb4->lock);
+	init_completion(&mb4->work);
+	return 0;
+}
+
+int __init db8500_prcmu_init_mb5(struct mb5_transfer *mb)
+{
+	mb5 = mb;
+	mutex_init(&mb5->lock);
+	init_completion(&mb5->work);
+	return 0;
+}
+
 static int db8500_irq_map(struct irq_domain *d, unsigned int virq,
 				irq_hw_number_t hwirq)
 {
@@ -2582,10 +2659,23 @@ static int db8500_irq_init(struct device_node *np)
 	return 0;
 }
 
+int __init db8500_prcmu_context_init(struct prcmu_context *context)
+{
+	/* initialize PRCMU driver context */
+	tcdm_base = context->tcdm_base;
+	tcdm_legacy_base = context->tcdm_legacy_base;
+	fw_trans = context->fw_trans;
+	fw_trans_nb = context->fw_trans_nb;
+	read_mailbox = context->read_mbox;
+
+	return 0;
+}
+
 struct prcmu_fops_register_data *__init
 			db8500_prcmu_early_init(struct prcmu_tcdm_map *map)
 {
 		void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);
+	struct prcmu_context context;
 
 	if (tcpm_base != NULL) {
 		u32 version;
@@ -2601,28 +2691,21 @@ struct prcmu_fops_register_data *__init
 			(version >> 24) & 0xFF);
 		iounmap(tcpm_base);
 	}
-	tcdm_base = ioremap_nocache(U8500_PRCMU_TCDM_BASE, map->tcdm_size);
-	tcdm_legacy_base = tcdm_base + map->legacy_offset;
-
-	spin_lock_init(&mb0.lock);
-	spin_lock_init(&mb0.dbb_irqs_lock);
-	mutex_init(&mb0.ac_wake_lock);
-	init_completion(&mb0.ac_wake_work);
-	mutex_init(&mb1.lock);
-	init_completion(&mb1.work);
-	mb1.ape_opp = APE_NO_CHANGE;
-	mutex_init(&mb2.lock);
-	init_completion(&mb2.work);
-	spin_lock_init(&mb2.auto_pm_lock);
-	spin_lock_init(&mb3.lock);
-	mutex_init(&mb3.sysclk_lock);
-	init_completion(&mb3.sysclk_work);
-	mutex_init(&mb4.lock);
-	init_completion(&mb4.work);
-	mutex_init(&mb5.lock);
-	init_completion(&mb5.work);
-
-	INIT_WORK(&mb0.mask_work, prcmu_mask_work);
+
+	context.tcdm_base = ioremap_nocache(U8500_PRCMU_TCDM_BASE,
+			map->tcdm_size);
+	context.tcdm_legacy_base = context.tcdm_base + map->legacy_offset;
+	context.fw_trans = db8500_fw_trans;
+	context.fw_trans_nb = ARRAY_SIZE(db8500_fw_trans);
+	context.read_mbox = db8500_read_mailbox;
+	db8500_prcmu_context_init(&context);
+
+	db8500_prcmu_init_mb0(&db8500_mb0);
+	db8500_prcmu_init_mb1(&db8500_mb1);
+	db8500_prcmu_init_mb2(&db8500_mb2);
+	db8500_prcmu_init_mb3(&db8500_mb3);
+	db8500_prcmu_init_mb4(&db8500_mb4);
+	db8500_prcmu_init_mb5(&db8500_mb5);
 
 	/*  early init of dbx500-prcmu */
 	return &db8500_early_data;
diff --git a/drivers/mfd/dbx500-prcmu.h b/drivers/mfd/dbx500-prcmu.h
index 79cba24..ce0e519 100644
--- a/drivers/mfd/dbx500-prcmu.h
+++ b/drivers/mfd/dbx500-prcmu.h
@@ -376,3 +376,19 @@ struct mb5_transfer {
 	} ack;
 };
 
+/*
+ * prcmu_context - PRCMU common layer need to be configured
+ * @tcdm_base:	PRCMU TCDM base address
+ * @tcdm_legacy_base:	Base address for legacy mailbox
+ * @fw_trans:  Firmware power transition list
+ * @fw_trans_nb: Nb of firmware power transitions
+ * @read_mbox: Pointer on mailbox interrupt management
+ */
+struct prcmu_context {
+	void *tcdm_base;
+	void *tcdm_legacy_base;
+	u8 *fw_trans;
+	u32 fw_trans_nb;
+	bool (**read_mbox)(void);
+};
+
-- 
1.7.11.1

