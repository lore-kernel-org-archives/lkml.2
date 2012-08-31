Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2HaMWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:22:19 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:45676 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab2HaMWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:22:16 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Rickard Andersson <rickard.andersson@stericsson.com>
Subject: [PATCH 3/4] mfd: dbx500: Provide a more accurate smp_twd clock
Date: Fri, 31 Aug 2012 14:21:30 +0200
Message-ID: <1346415691-13371-4-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Jaouen <michel.jaouen@stericsson.com>

The local timer clock is based on ARM subsystem clock. This patch
obtains a more exact value of that clock by reading PRCMU registers.
Using this increases the accuracy of the local timer events.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Signed-off-by: Michel Jaouen <michel.jaouen@stericsson.com>
---
 drivers/mfd/db8500-prcmu.c       |   42 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/dbx500-prcmu-regs.h  |    4 +++-
 include/linux/mfd/dbx500-prcmu.h |    1 +
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 4f74529..e7f9539 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -418,6 +418,9 @@ static struct {
 
 static atomic_t ac_wake_req_state = ATOMIC_INIT(0);
 
+/* Functions definition */
+static void compute_armss_rate(void);
+
 /* Spinlocks */
 static DEFINE_SPINLOCK(prcmu_lock);
 static DEFINE_SPINLOCK(clkout_lock);
@@ -517,6 +520,7 @@ static struct dsiescclk dsiescclk[3] = {
 	}
 };
 
+
 /*
 * Used by MCDE to setup all necessary PRCMU registers
 */
@@ -1013,6 +1017,7 @@ int db8500_prcmu_set_arm_opp(u8 opp)
 		(mb1_transfer.ack.arm_opp != opp))
 		r = -EIO;
 
+	compute_armss_rate();
 	mutex_unlock(&mb1_transfer.lock);
 
 	return r;
@@ -1612,6 +1617,7 @@ static unsigned long pll_rate(void __iomem *reg, unsigned long src_rate,
 	if ((branch == PLL_FIX) || ((branch == PLL_DIV) &&
 		(val & PRCM_PLL_FREQ_DIV2EN) &&
 		((reg == PRCM_PLLSOC0_FREQ) ||
+		 (reg == PRCM_PLLARM_FREQ) ||
 		 (reg == PRCM_PLLDDR_FREQ))))
 		div *= 2;
 
@@ -1661,6 +1667,39 @@ static unsigned long clock_rate(u8 clock)
 	else
 		return 0;
 }
+static unsigned long latest_armss_rate;
+static unsigned long armss_rate(void)
+{
+	return latest_armss_rate;
+}
+
+static void compute_armss_rate(void)
+{
+	u32 r;
+	unsigned long rate;
+
+	r = readl(PRCM_ARM_CHGCLKREQ);
+
+	if (r & PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ) {
+		/* External ARMCLKFIX clock */
+
+		rate = pll_rate(PRCM_PLLDDR_FREQ, ROOT_CLOCK_RATE, PLL_FIX);
+
+		/* Check PRCM_ARM_CHGCLKREQ divider */
+		if (!(r & PRCM_ARM_CHGCLKREQ_PRCM_ARM_DIVSEL))
+			rate /= 2;
+
+		/* Check PRCM_ARMCLKFIX_MGT divider */
+		r = readl(PRCM_ARMCLKFIX_MGT);
+		r &= PRCM_CLK_MGT_CLKPLLDIV_MASK;
+		rate /= r;
+
+	} else {/* ARM PLL */
+		rate = pll_rate(PRCM_PLLARM_FREQ, ROOT_CLOCK_RATE, PLL_DIV);
+	}
+
+	latest_armss_rate = rate;
+}
 
 static unsigned long dsiclk_rate(u8 n)
 {
@@ -1707,6 +1746,8 @@ unsigned long prcmu_clock_rate(u8 clock)
 		return pll_rate(PRCM_PLLSOC0_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
 	else if (clock == PRCMU_PLLSOC1)
 		return pll_rate(PRCM_PLLSOC1_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
+	else if (clock == PRCMU_ARMSS)
+		return armss_rate();
 	else if (clock == PRCMU_PLLDDR)
 		return pll_rate(PRCM_PLLDDR_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
 	else if (clock == PRCMU_PLLDSI)
@@ -2693,6 +2734,7 @@ void __init db8500_prcmu_early_init(void)
 					 handle_simple_irq);
 		set_irq_flags(irq, IRQF_VALID);
 	}
+	compute_armss_rate();
 }
 
 static void __init init_prcm_registers(void)
diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
index 23108a6..79c76eb 100644
--- a/drivers/mfd/dbx500-prcmu-regs.h
+++ b/drivers/mfd/dbx500-prcmu-regs.h
@@ -61,7 +61,8 @@
 #define PRCM_PLLARM_LOCKP_PRCM_PLLARM_LOCKP3	0x2
 
 #define PRCM_ARM_CHGCLKREQ	(_PRCMU_BASE + 0x114)
-#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ	0x1
+#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_CHGCLKREQ	BIT(0)
+#define PRCM_ARM_CHGCLKREQ_PRCM_ARM_DIVSEL	BIT(16)
 
 #define PRCM_PLLARM_ENABLE	(_PRCMU_BASE + 0x98)
 #define PRCM_PLLARM_ENABLE_PRCM_PLLARM_ENABLE	0x1
@@ -140,6 +141,7 @@
 /* PRCMU clock/PLL/reset registers */
 #define PRCM_PLLSOC0_FREQ	   (_PRCMU_BASE + 0x080)
 #define PRCM_PLLSOC1_FREQ	   (_PRCMU_BASE + 0x084)
+#define PRCM_PLLARM_FREQ	   (_PRCMU_BASE + 0x088)
 #define PRCM_PLLDDR_FREQ	   (_PRCMU_BASE + 0x08C)
 #define PRCM_PLL_FREQ_D_SHIFT	0
 #define PRCM_PLL_FREQ_D_MASK	BITS(0, 7)
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 5b90e94..c410d99 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -136,6 +136,7 @@ enum prcmu_clock {
 	PRCMU_TIMCLK,
 	PRCMU_PLLSOC0,
 	PRCMU_PLLSOC1,
+	PRCMU_ARMSS,
 	PRCMU_PLLDDR,
 	PRCMU_PLLDSI,
 	PRCMU_DSI0CLK,
-- 
1.7.10

