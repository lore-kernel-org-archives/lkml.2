Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1HLI2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:28:35 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:46844 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752661Ab1HLI2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:28:30 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/23] mfd/db8500-prcmu: add accessors for PLL and SGA clock
Date: Fri, 12 Aug 2011 10:28:18 +0200
Message-ID: <1313137698-30782-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This extends the DB8500 PRCMU driver with accessor calls for the
PRCMU PLL and SGA clocks.

Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c |   83 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index cea8145..af36999 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -459,6 +459,35 @@ struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
 	CLK_MGT_ENTRY(UICCCLK),
 };
 
+static struct regulator *hwacc_regulator[NUM_HW_ACC];
+static struct regulator *hwacc_ret_regulator[NUM_HW_ACC];
+
+static bool hwacc_enabled[NUM_HW_ACC];
+static bool hwacc_ret_enabled[NUM_HW_ACC];
+
+static const char *hwacc_regulator_name[NUM_HW_ACC] = {
+	[HW_ACC_SVAMMDSP]	= "hwacc-sva-mmdsp",
+	[HW_ACC_SVAPIPE]	= "hwacc-sva-pipe",
+	[HW_ACC_SIAMMDSP]	= "hwacc-sia-mmdsp",
+	[HW_ACC_SIAPIPE]	= "hwacc-sia-pipe",
+	[HW_ACC_SGA]		= "hwacc-sga",
+	[HW_ACC_B2R2]		= "hwacc-b2r2",
+	[HW_ACC_MCDE]		= "hwacc-mcde",
+	[HW_ACC_ESRAM1]		= "hwacc-esram1",
+	[HW_ACC_ESRAM2]		= "hwacc-esram2",
+	[HW_ACC_ESRAM3]		= "hwacc-esram3",
+	[HW_ACC_ESRAM4]		= "hwacc-esram4",
+};
+
+static const char *hwacc_ret_regulator_name[NUM_HW_ACC] = {
+	[HW_ACC_SVAMMDSP]	= "hwacc-sva-mmdsp-ret",
+	[HW_ACC_SIAMMDSP]	= "hwacc-sia-mmdsp-ret",
+	[HW_ACC_ESRAM1]		= "hwacc-esram1-ret",
+	[HW_ACC_ESRAM2]		= "hwacc-esram2-ret",
+	[HW_ACC_ESRAM3]		= "hwacc-esram3-ret",
+	[HW_ACC_ESRAM4]		= "hwacc-esram4-ret",
+};
+
 /*
 * Used by MCDE to setup all necessary PRCMU registers
 */
@@ -1023,6 +1052,34 @@ int prcmu_release_usb_wakeup_state(void)
 	return r;
 }
 
+static int request_pll(u8 clock, bool enable)
+{
+	int r = 0;
+
+	if (clock == PRCMU_PLLSOC1)
+		clock = (enable ? PLL_SOC1_ON : PLL_SOC1_OFF);
+	else
+		return -EINVAL;
+
+	mutex_lock(&mb1_transfer.lock);
+
+	while (readl(PRCM_MBOX_CPU_VAL) & MBOX_BIT(1))
+		cpu_relax();
+
+	writeb(MB1H_PLL_ON_OFF, (tcdm_base + PRCM_MBOX_HEADER_REQ_MB1));
+	writeb(clock, (tcdm_base + PRCM_REQ_MB1_PLL_ON_OFF));
+
+	writel(MBOX_BIT(1), PRCM_MBOX_CPU_SET);
+	wait_for_completion(&mb1_transfer.work);
+
+	if (mb1_transfer.ack.header != MB1H_PLL_ON_OFF)
+		r = -EIO;
+
+	mutex_unlock(&mb1_transfer.lock);
+
+	return r;
+}
+
 /**
  * db8500_prcmu_set_epod - set the state of a EPOD (power domain)
  * @epod_id: The EPOD to set
@@ -1220,6 +1277,26 @@ static int request_reg_clock(u8 clock, bool enable)
 	return 0;
 }
 
+static int request_sga_clock(u8 clock, bool enable)
+{
+	u32 val;
+	int ret;
+
+	if (enable) {
+		val = readl(PRCM_CGATING_BYPASS);
+		writel(val | PRCM_CGATING_BYPASS_ICN2, PRCM_CGATING_BYPASS);
+	}
+
+	ret = request_reg_clock(clock, enable);
+
+	if (!ret && !enable) {
+		val = readl(PRCM_CGATING_BYPASS);
+		writel(val & ~PRCM_CGATING_BYPASS_ICN2, PRCM_CGATING_BYPASS);
+	}
+
+	return ret;
+}
+
 /**
  * db8500_prcmu_request_clock() - Request for a clock to be enabled or disabled.
  * @clock:      The clock for which the request is made.
@@ -1230,12 +1307,16 @@ static int request_reg_clock(u8 clock, bool enable)
  */
 int db8500_prcmu_request_clock(u8 clock, bool enable)
 {
-	if (clock < PRCMU_NUM_REG_CLOCKS)
+	if (clock == PRCMU_SGACLK)
+		return request_sga_clock(clock, enable);
+	else if (clock < PRCMU_NUM_REG_CLOCKS)
 		return request_reg_clock(clock, enable);
 	else if (clock == PRCMU_TIMCLK)
 		return request_timclk(enable);
 	else if (clock == PRCMU_SYSCLK)
 		return request_sysclk(enable);
+	else if (clock == PRCMU_PLLSOC1)
+		return request_pll(clock, enable);
 	else
 		return -EINVAL;
 }
-- 
1.7.3.2

