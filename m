Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1HLIaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:30:02 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:59599 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916Ab1HLI36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:29:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jimmy Rubin <jimmy.rubin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 16/23] mfd/db5500-prcmu: implement clock handling
Date: Fri, 12 Aug 2011 10:29:45 +0200
Message-ID: <1313137785-31114-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

This adds accessor functions for clock handling to the
DB5500 PRCMU driver.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Jimmy Rubin <jimmy.rubin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db5500-prcmu.c |  198 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 198 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/db5500-prcmu.c b/drivers/mfd/db5500-prcmu.c
index 5550ac9..e374481 100644
--- a/drivers/mfd/db5500-prcmu.c
+++ b/drivers/mfd/db5500-prcmu.c
@@ -401,6 +401,204 @@ static struct {
 /* PRCMU TCDM base IO address. */
 static __iomem void *tcdm_base;
 
+struct clk_mgt {
+	unsigned int offset;
+	u32 pllsw;
+};
+
+static DEFINE_SPINLOCK(clk_mgt_lock);
+
+#define CLK_MGT_ENTRY(_name)[PRCMU_##_name] = {	\
+	(PRCM_##_name##_MGT_OFF), 0			\
+}
+static struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
+	CLK_MGT_ENTRY(SGACLK),
+	CLK_MGT_ENTRY(UARTCLK),
+	CLK_MGT_ENTRY(MSP02CLK),
+	CLK_MGT_ENTRY(I2CCLK),
+	CLK_MGT_ENTRY(SDMMCCLK),
+	CLK_MGT_ENTRY(PER1CLK),
+	CLK_MGT_ENTRY(PER2CLK),
+	CLK_MGT_ENTRY(PER3CLK),
+	CLK_MGT_ENTRY(PER5CLK),
+	CLK_MGT_ENTRY(PER6CLK),
+	CLK_MGT_ENTRY(PWMCLK),
+	CLK_MGT_ENTRY(IRDACLK),
+	CLK_MGT_ENTRY(IRRCCLK),
+	CLK_MGT_ENTRY(HDMICLK),
+	CLK_MGT_ENTRY(APEATCLK),
+	CLK_MGT_ENTRY(APETRACECLK),
+	CLK_MGT_ENTRY(MCDECLK),
+	CLK_MGT_ENTRY(DSIALTCLK),
+	CLK_MGT_ENTRY(DMACLK),
+	CLK_MGT_ENTRY(B2R2CLK),
+	CLK_MGT_ENTRY(TVCLK),
+	CLK_MGT_ENTRY(RNGCLK),
+	CLK_MGT_ENTRY(SIACLK),
+	CLK_MGT_ENTRY(SVACLK),
+};
+
+bool db5500_prcmu_is_ac_wake_requested(void)
+{
+	return false;
+}
+
+static int request_sysclk(bool enable)
+{
+	int r;
+
+	r = 0;
+	mutex_lock(&mb3_transfer.sysclk_lock);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(3))
+		cpu_relax();
+
+	if (enable)
+		mb3_transfer.req_st = SYSCLK_ON;
+	else
+		mb3_transfer.req_st = SYSCLK_OFF;
+
+	writeb(mb3_transfer.req_st, (PRCM_REQ_MB3_REFCLK_MGT));
+
+	writeb(MB3H_REFCLK_REQUEST, (PRCM_REQ_MB3_HEADER));
+	writel(MBOX_BIT(3), PRCM_MBOX_CPU_SET);
+
+	/*
+	 * The firmware only sends an ACK if we want to enable the
+	 * SysClk, and it succeeds.
+	 */
+	if (!wait_for_completion_timeout(&mb3_transfer.sysclk_work,
+			msecs_to_jiffies(20000))) {
+		pr_err("prcmu: %s timed out (20 s) waiting for a reply.\n",
+			__func__);
+		r = -EIO;
+		WARN(1, "Failed to set sysclk");
+		goto unlock_and_return;
+	}
+
+	if ((mb3_transfer.ack.header != MB3H_REFCLK_REQUEST) ||
+			(mb3_transfer.ack.status != mb3_transfer.req_st)) {
+		r = -EIO;
+	}
+
+unlock_and_return:
+	mutex_unlock(&mb3_transfer.sysclk_lock);
+
+	return r;
+}
+
+static int request_timclk(bool enable)
+{
+	u32 val = (PRCM_TCR_DOZE_MODE | PRCM_TCR_TENSEL_MASK);
+
+	if (!enable)
+		val |= PRCM_TCR_STOP_TIMERS;
+	writel(val, PRCM_TCR);
+
+	return 0;
+}
+
+static int request_reg_clock(u8 clock, bool enable)
+{
+	u32 val;
+	unsigned long flags;
+
+	WARN_ON(!clk_mgt[clock].offset);
+
+	spin_lock_irqsave(&clk_mgt_lock, flags);
+
+	/* Grab the HW semaphore. */
+	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+		cpu_relax();
+
+	val = readl(_PRCMU_BASE + clk_mgt[clock].offset);
+	if (enable) {
+		val |= (PRCM_CLK_MGT_CLKEN | clk_mgt[clock].pllsw);
+	} else {
+		clk_mgt[clock].pllsw = (val & PRCM_CLK_MGT_CLKPLLSW_MASK);
+		val &= ~(PRCM_CLK_MGT_CLKEN | PRCM_CLK_MGT_CLKPLLSW_MASK);
+	}
+	writel(val, (_PRCMU_BASE + clk_mgt[clock].offset));
+
+	/* Release the HW semaphore. */
+	writel(0, PRCM_SEM);
+
+	spin_unlock_irqrestore(&clk_mgt_lock, flags);
+
+	return 0;
+}
+
+/*
+ * request_pll() - Request for a pll to be enabled or disabled.
+ * @pll:        The pll for which the request is made.
+ * @enable:     Whether the clock should be enabled (true) or disabled (false).
+ *
+ * This function should only be used by the clock implementation.
+ * Do not use it from any other place!
+ */
+static int request_pll(u8 pll, bool enable)
+{
+	int r = 0;
+
+	BUG_ON(pll >= DB5500_NUM_PLL_ID);
+	mutex_lock(&mb2_transfer.lock);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(2))
+		cpu_relax();
+
+	mb2_transfer.req.pll_st[pll] = enable;
+
+	/* fill in mailbox */
+	writeb(pll, PRCM_REQ_MB2_PLL_CLIENT);
+	writeb(mb2_transfer.req.pll_st[pll], PRCM_REQ_MB2_PLL_STATE);
+
+	writeb(MB2H_PLL_REQUEST, PRCM_REQ_MB2_HEADER);
+
+	writel(MBOX_BIT(2), PRCM_MBOX_CPU_SET);
+	if (!wait_for_completion_timeout(&mb2_transfer.work,
+		msecs_to_jiffies(500))) {
+		pr_err("prcmu: set_pll() failed.\n"
+			"prcmu: Please check your firmware version.\n");
+		r = -EIO;
+		WARN(1, "Failed to set pll");
+		goto unlock_and_return;
+	}
+	if (mb2_transfer.ack.status != RC_SUCCESS ||
+		mb2_transfer.ack.header != MB2H_PLL_REQUEST)
+		r = -EIO;
+
+unlock_and_return:
+	mutex_unlock(&mb2_transfer.lock);
+
+	return r;
+}
+
+/**
+ * db5500_prcmu_request_clock() - Request for a clock to be enabled or disabled.
+ * @clock:      The clock for which the request is made.
+ * @enable:     Whether the clock should be enabled (true) or disabled (false).
+ *
+ * This function should only be used by the clock implementation.
+ * Do not use it from any other place!
+ */
+int db5500_prcmu_request_clock(u8 clock, bool enable)
+{
+	if (clock < PRCMU_NUM_REG_CLOCKS)
+		return request_reg_clock(clock, enable);
+	else if (clock == PRCMU_TIMCLK)
+		return request_timclk(enable);
+	else if (clock == PRCMU_PLLSOC0)
+		return request_pll(DB5500_PLL_SOC0, enable);
+	else if (clock == PRCMU_PLLSOC1)
+		return request_pll(DB5500_PLL_SOC1, enable);
+	else if (clock == PRCMU_PLLDDR)
+		return request_pll(DB5500_PLL_DDR, enable);
+	else if (clock == PRCMU_SYSCLK)
+		return request_sysclk(enable);
+	else
+		return -EINVAL;
+}
+
 /* This function should only be called while mb0_transfer.lock is held. */
 static void config_wakeups(void)
 {
-- 
1.7.3.2

