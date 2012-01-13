Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab2AMPVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:21:45 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:35536 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451Ab2AMPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:20:41 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/8] mfd/db8500-prcmu: clock handling update
Date: Fri, 13 Jan 2012 16:20:28 +0100
Message-ID: <1326468028-11792-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Nilsson <mattias.i.nilsson@stericsson.com>

This updates the clock handling in the DB8500 PRCMU driver with
the latest findings and API changes related to changes in the
backing firmware in the PRCMU.

- Add the necessary interfaces to get the frequencies of the
  clocks and set the rate of some of the clocks.
- Add support for controlling the clocks PLLSOC0, PLLDSI,
  DSI0, DSI1 and DSI escape clocks (DSInESCCLK).
- Correct the PLLSDI enable/disable sequence by using the
  DSIPLL_CLAMPI bit.

After this we will have the interfaces and code to implement the
U8500 clock framework properly.

Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/db8500-prcmu.c       |  666 +++++++++++++++++++++++++++++++++-----
 drivers/mfd/dbx500-prcmu-regs.h  |  128 +++++---
 include/linux/mfd/dbx500-prcmu.h |   47 +++
 3 files changed, 720 insertions(+), 121 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 5179abf..9459327 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -132,6 +132,8 @@
 #define PRCM_REQ_MB1_ARM_OPP			(PRCM_REQ_MB1 + 0x0)
 #define PRCM_REQ_MB1_APE_OPP			(PRCM_REQ_MB1 + 0x1)
 #define PRCM_REQ_MB1_PLL_ON_OFF			(PRCM_REQ_MB1 + 0x4)
+#define PLL_SOC0_OFF	0x1
+#define PLL_SOC0_ON	0x2
 #define PLL_SOC1_OFF	0x4
 #define PLL_SOC1_ON	0x8
 
@@ -420,43 +422,95 @@ static DEFINE_SPINLOCK(gpiocr_lock);
 static __iomem void *tcdm_base;
 
 struct clk_mgt {
-	unsigned int offset;
+	void __iomem *reg;
 	u32 pllsw;
+	int branch;
+	bool clk38div;
+};
+
+enum {
+	PLL_RAW,
+	PLL_FIX,
+	PLL_DIV
 };
 
 static DEFINE_SPINLOCK(clk_mgt_lock);
 
-#define CLK_MGT_ENTRY(_name)[PRCMU_##_name] = { (PRCM_##_name##_MGT_OFF), 0 }
+#define CLK_MGT_ENTRY(_name, _branch, _clk38div)[PRCMU_##_name] = \
+	{ (PRCM_##_name##_MGT), 0 , _branch, _clk38div}
 struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
-	CLK_MGT_ENTRY(SGACLK),
-	CLK_MGT_ENTRY(UARTCLK),
-	CLK_MGT_ENTRY(MSP02CLK),
-	CLK_MGT_ENTRY(MSP1CLK),
-	CLK_MGT_ENTRY(I2CCLK),
-	CLK_MGT_ENTRY(SDMMCCLK),
-	CLK_MGT_ENTRY(SLIMCLK),
-	CLK_MGT_ENTRY(PER1CLK),
-	CLK_MGT_ENTRY(PER2CLK),
-	CLK_MGT_ENTRY(PER3CLK),
-	CLK_MGT_ENTRY(PER5CLK),
-	CLK_MGT_ENTRY(PER6CLK),
-	CLK_MGT_ENTRY(PER7CLK),
-	CLK_MGT_ENTRY(LCDCLK),
-	CLK_MGT_ENTRY(BMLCLK),
-	CLK_MGT_ENTRY(HSITXCLK),
-	CLK_MGT_ENTRY(HSIRXCLK),
-	CLK_MGT_ENTRY(HDMICLK),
-	CLK_MGT_ENTRY(APEATCLK),
-	CLK_MGT_ENTRY(APETRACECLK),
-	CLK_MGT_ENTRY(MCDECLK),
-	CLK_MGT_ENTRY(IPI2CCLK),
-	CLK_MGT_ENTRY(DSIALTCLK),
-	CLK_MGT_ENTRY(DMACLK),
-	CLK_MGT_ENTRY(B2R2CLK),
-	CLK_MGT_ENTRY(TVCLK),
-	CLK_MGT_ENTRY(SSPCLK),
-	CLK_MGT_ENTRY(RNGCLK),
-	CLK_MGT_ENTRY(UICCCLK),
+	CLK_MGT_ENTRY(SGACLK, PLL_DIV, false),
+	CLK_MGT_ENTRY(UARTCLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(MSP02CLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(MSP1CLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(I2CCLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(SDMMCCLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(SLIMCLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(PER1CLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(PER2CLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(PER3CLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(PER5CLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(PER6CLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(PER7CLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(LCDCLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(BMLCLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(HSITXCLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(HSIRXCLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(HDMICLK, PLL_FIX, false),
+	CLK_MGT_ENTRY(APEATCLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(APETRACECLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(MCDECLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(IPI2CCLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(DSIALTCLK, PLL_FIX, false),
+	CLK_MGT_ENTRY(DMACLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(B2R2CLK, PLL_DIV, true),
+	CLK_MGT_ENTRY(TVCLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(SSPCLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(RNGCLK, PLL_FIX, true),
+	CLK_MGT_ENTRY(UICCCLK, PLL_FIX, false),
+};
+
+struct dsiclk {
+	u32 divsel_mask;
+	u32 divsel_shift;
+	u32 divsel;
+};
+
+static struct dsiclk dsiclk[2] = {
+	{
+		.divsel_mask = PRCM_DSI_PLLOUT_SEL_DSI0_PLLOUT_DIVSEL_MASK,
+		.divsel_shift = PRCM_DSI_PLLOUT_SEL_DSI0_PLLOUT_DIVSEL_SHIFT,
+		.divsel = PRCM_DSI_PLLOUT_SEL_PHI,
+	},
+	{
+		.divsel_mask = PRCM_DSI_PLLOUT_SEL_DSI1_PLLOUT_DIVSEL_MASK,
+		.divsel_shift = PRCM_DSI_PLLOUT_SEL_DSI1_PLLOUT_DIVSEL_SHIFT,
+		.divsel = PRCM_DSI_PLLOUT_SEL_PHI,
+	}
+};
+
+struct dsiescclk {
+	u32 en;
+	u32 div_mask;
+	u32 div_shift;
+};
+
+static struct dsiescclk dsiescclk[3] = {
+	{
+		.en = PRCM_DSITVCLK_DIV_DSI0_ESC_CLK_EN,
+		.div_mask = PRCM_DSITVCLK_DIV_DSI0_ESC_CLK_DIV_MASK,
+		.div_shift = PRCM_DSITVCLK_DIV_DSI0_ESC_CLK_DIV_SHIFT,
+	},
+	{
+		.en = PRCM_DSITVCLK_DIV_DSI1_ESC_CLK_EN,
+		.div_mask = PRCM_DSITVCLK_DIV_DSI1_ESC_CLK_DIV_MASK,
+		.div_shift = PRCM_DSITVCLK_DIV_DSI1_ESC_CLK_DIV_SHIFT,
+	},
+	{
+		.en = PRCM_DSITVCLK_DIV_DSI2_ESC_CLK_EN,
+		.div_mask = PRCM_DSITVCLK_DIV_DSI2_ESC_CLK_DIV_MASK,
+		.div_shift = PRCM_DSITVCLK_DIV_DSI2_ESC_CLK_DIV_SHIFT,
+	}
 };
 
 static struct regulator *hwacc_regulator[NUM_HW_ACC];
@@ -910,6 +964,7 @@ int db8500_prcmu_set_ddr_opp(u8 opp)
 
 	return 0;
 }
+
 /**
  * db8500_set_ape_opp - set the appropriate APE OPP
  * @opp: The new APE operating point to which transition is to be made
@@ -1031,7 +1086,9 @@ static int request_pll(u8 clock, bool enable)
 {
 	int r = 0;
 
-	if (clock == PRCMU_PLLSOC1)
+	if (clock == PRCMU_PLLSOC0)
+		clock = (enable ? PLL_SOC0_ON : PLL_SOC0_OFF);
+	else if (clock == PRCMU_PLLSOC1)
 		clock = (enable ? PLL_SOC1_ON : PLL_SOC1_OFF);
 	else
 		return -EINVAL;
@@ -1350,7 +1407,7 @@ static int request_timclk(bool enable)
 	return 0;
 }
 
-static int request_reg_clock(u8 clock, bool enable)
+static int request_clock(u8 clock, bool enable)
 {
 	u32 val;
 	unsigned long flags;
@@ -1361,14 +1418,14 @@ static int request_reg_clock(u8 clock, bool enable)
 	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
 		cpu_relax();
 
-	val = readl(_PRCMU_BASE + clk_mgt[clock].offset);
+	val = readl(clk_mgt[clock].reg);
 	if (enable) {
 		val |= (PRCM_CLK_MGT_CLKEN | clk_mgt[clock].pllsw);
 	} else {
 		clk_mgt[clock].pllsw = (val & PRCM_CLK_MGT_CLKPLLSW_MASK);
 		val &= ~(PRCM_CLK_MGT_CLKEN | PRCM_CLK_MGT_CLKPLLSW_MASK);
 	}
-	writel(val, (_PRCMU_BASE + clk_mgt[clock].offset));
+	writel(val, clk_mgt[clock].reg);
 
 	/* Release the HW semaphore. */
 	writel(0, PRCM_SEM);
@@ -1388,7 +1445,7 @@ static int request_sga_clock(u8 clock, bool enable)
 		writel(val | PRCM_CGATING_BYPASS_ICN2, PRCM_CGATING_BYPASS);
 	}
 
-	ret = request_reg_clock(clock, enable);
+	ret = request_clock(clock, enable);
 
 	if (!ret && !enable) {
 		val = readl(PRCM_CGATING_BYPASS);
@@ -1398,6 +1455,78 @@ static int request_sga_clock(u8 clock, bool enable)
 	return ret;
 }
 
+static inline bool plldsi_locked(void)
+{
+	return (readl(PRCM_PLLDSI_LOCKP) &
+		(PRCM_PLLDSI_LOCKP_PRCM_PLLDSI_LOCKP10 |
+		 PRCM_PLLDSI_LOCKP_PRCM_PLLDSI_LOCKP3)) ==
+		(PRCM_PLLDSI_LOCKP_PRCM_PLLDSI_LOCKP10 |
+		 PRCM_PLLDSI_LOCKP_PRCM_PLLDSI_LOCKP3);
+}
+
+static int request_plldsi(bool enable)
+{
+	int r = 0;
+	u32 val;
+
+	writel((PRCM_MMIP_LS_CLAMP_DSIPLL_CLAMP |
+		PRCM_MMIP_LS_CLAMP_DSIPLL_CLAMPI), (enable ?
+		PRCM_MMIP_LS_CLAMP_CLR : PRCM_MMIP_LS_CLAMP_SET));
+
+	val = readl(PRCM_PLLDSI_ENABLE);
+	if (enable)
+		val |= PRCM_PLLDSI_ENABLE_PRCM_PLLDSI_ENABLE;
+	else
+		val &= ~PRCM_PLLDSI_ENABLE_PRCM_PLLDSI_ENABLE;
+	writel(val, PRCM_PLLDSI_ENABLE);
+
+	if (enable) {
+		unsigned int i;
+		bool locked = plldsi_locked();
+
+		for (i = 10; !locked && (i > 0); --i) {
+			udelay(100);
+			locked = plldsi_locked();
+		}
+		if (locked) {
+			writel(PRCM_APE_RESETN_DSIPLL_RESETN,
+				PRCM_APE_RESETN_SET);
+		} else {
+			writel((PRCM_MMIP_LS_CLAMP_DSIPLL_CLAMP |
+				PRCM_MMIP_LS_CLAMP_DSIPLL_CLAMPI),
+				PRCM_MMIP_LS_CLAMP_SET);
+			val &= ~PRCM_PLLDSI_ENABLE_PRCM_PLLDSI_ENABLE;
+			writel(val, PRCM_PLLDSI_ENABLE);
+			r = -EAGAIN;
+		}
+	} else {
+		writel(PRCM_APE_RESETN_DSIPLL_RESETN, PRCM_APE_RESETN_CLR);
+	}
+	return r;
+}
+
+static int request_dsiclk(u8 n, bool enable)
+{
+	u32 val;
+
+	val = readl(PRCM_DSI_PLLOUT_SEL);
+	val &= ~dsiclk[n].divsel_mask;
+	val |= ((enable ? dsiclk[n].divsel : PRCM_DSI_PLLOUT_SEL_OFF) <<
+		dsiclk[n].divsel_shift);
+	writel(val, PRCM_DSI_PLLOUT_SEL);
+	return 0;
+}
+
+static int request_dsiescclk(u8 n, bool enable)
+{
+	u32 val;
+
+	val = readl(PRCM_DSITVCLK_DIV);
+	enable ? (val |= dsiescclk[n].en) : (val &= ~dsiescclk[n].en);
+	writel(val, PRCM_DSITVCLK_DIV);
+	return 0;
+}
+
 /**
  * db8500_prcmu_request_clock() - Request for a clock to be enabled or disabled.
  * @clock:      The clock for which the request is made.
@@ -1408,21 +1537,435 @@ static int request_sga_clock(u8 clock, bool enable)
  */
 int db8500_prcmu_request_clock(u8 clock, bool enable)
 {
-	switch(clock) {
-	case PRCMU_SGACLK:
+	if (clock == PRCMU_SGACLK)
 		return request_sga_clock(clock, enable);
-	case PRCMU_TIMCLK:
+	else if (clock < PRCMU_NUM_REG_CLOCKS)
+		return request_clock(clock, enable);
+	else if (clock == PRCMU_TIMCLK)
 		return request_timclk(enable);
-	case PRCMU_SYSCLK:
+	else if ((clock == PRCMU_DSI0CLK) || (clock == PRCMU_DSI1CLK))
+		return request_dsiclk((clock - PRCMU_DSI0CLK), enable);
+	else if ((PRCMU_DSI0ESCCLK <= clock) && (clock <= PRCMU_DSI2ESCCLK))
+		return request_dsiescclk((clock - PRCMU_DSI0ESCCLK), enable);
+	else if (clock == PRCMU_PLLDSI)
+		return request_plldsi(enable);
+	else if (clock == PRCMU_SYSCLK)
 		return request_sysclk(enable);
-	case PRCMU_PLLSOC1:
+	else if ((clock == PRCMU_PLLSOC0) || (clock == PRCMU_PLLSOC1))
 		return request_pll(clock, enable);
+	else
+		return -EINVAL;
+}
+
+static unsigned long pll_rate(void __iomem *reg, unsigned long src_rate,
+	int branch)
+{
+	u64 rate;
+	u32 val;
+	u32 d;
+	u32 div = 1;
+
+	val = readl(reg);
+
+	rate = src_rate;
+	rate *= ((val & PRCM_PLL_FREQ_D_MASK) >> PRCM_PLL_FREQ_D_SHIFT);
+
+	d = ((val & PRCM_PLL_FREQ_N_MASK) >> PRCM_PLL_FREQ_N_SHIFT);
+	if (d > 1)
+		div *= d;
+
+	d = ((val & PRCM_PLL_FREQ_R_MASK) >> PRCM_PLL_FREQ_R_SHIFT);
+	if (d > 1)
+		div *= d;
+
+	if (val & PRCM_PLL_FREQ_SELDIV2)
+		div *= 2;
+
+	if ((branch == PLL_FIX) || ((branch == PLL_DIV) &&
+		(val & PRCM_PLL_FREQ_DIV2EN) &&
+		((reg == PRCM_PLLSOC0_FREQ) ||
+		 (reg == PRCM_PLLDDR_FREQ))))
+		div *= 2;
+
+	(void)do_div(rate, div);
+
+	return (unsigned long)rate;
+}
+
+#define ROOT_CLOCK_RATE 38400000
+
+static unsigned long clock_rate(u8 clock)
+{
+	u32 val;
+	u32 pllsw;
+	unsigned long rate = ROOT_CLOCK_RATE;
+
+	val = readl(clk_mgt[clock].reg);
+
+	if (val & PRCM_CLK_MGT_CLK38) {
+		if (clk_mgt[clock].clk38div && (val & PRCM_CLK_MGT_CLK38DIV))
+			rate /= 2;
+		return rate;
+	}
+
+	val |= clk_mgt[clock].pllsw;
+	pllsw = (val & PRCM_CLK_MGT_CLKPLLSW_MASK);
+
+	if (pllsw == PRCM_CLK_MGT_CLKPLLSW_SOC0)
+		rate = pll_rate(PRCM_PLLSOC0_FREQ, rate, clk_mgt[clock].branch);
+	else if (pllsw == PRCM_CLK_MGT_CLKPLLSW_SOC1)
+		rate = pll_rate(PRCM_PLLSOC1_FREQ, rate, clk_mgt[clock].branch);
+	else if (pllsw == PRCM_CLK_MGT_CLKPLLSW_DDR)
+		rate = pll_rate(PRCM_PLLDDR_FREQ, rate, clk_mgt[clock].branch);
+	else
+		return 0;
+
+	if ((clock == PRCMU_SGACLK) &&
+		(val & PRCM_SGACLK_MGT_SGACLKDIV_BY_2_5_EN)) {
+		u64 r = (rate * 10);
+
+		(void)do_div(r, 25);
+		return (unsigned long)r;
+	}
+	val &= PRCM_CLK_MGT_CLKPLLDIV_MASK;
+	if (val)
+		return rate / val;
+	else
+		return 0;
+}
+
+static unsigned long dsiclk_rate(u8 n)
+{
+	u32 divsel;
+	u32 div = 1;
+
+	divsel = readl(PRCM_DSI_PLLOUT_SEL);
+	divsel = ((divsel & dsiclk[n].divsel_mask) >> dsiclk[n].divsel_shift);
+
+	if (divsel == PRCM_DSI_PLLOUT_SEL_OFF)
+		divsel = dsiclk[n].divsel;
+
+	switch (divsel) {
+	case PRCM_DSI_PLLOUT_SEL_PHI_4:
+		div *= 2;
+	case PRCM_DSI_PLLOUT_SEL_PHI_2:
+		div *= 2;
+	case PRCM_DSI_PLLOUT_SEL_PHI:
+		return pll_rate(PRCM_PLLDSI_FREQ, clock_rate(PRCMU_HDMICLK),
+			PLL_RAW) / div;
 	default:
-		break;
+		return 0;
 	}
+}
+
+static unsigned long dsiescclk_rate(u8 n)
+{
+	u32 div;
+
+	div = readl(PRCM_DSITVCLK_DIV);
+	div = ((div & dsiescclk[n].div_mask) >> (dsiescclk[n].div_shift));
+	return clock_rate(PRCMU_TVCLK) / max((u32)1, div);
+}
+
+unsigned long prcmu_clock_rate(u8 clock)
+{
 	if (clock < PRCMU_NUM_REG_CLOCKS)
-		return request_reg_clock(clock, enable);
-	return -EINVAL;
+		return clock_rate(clock);
+	else if (clock == PRCMU_TIMCLK)
+		return ROOT_CLOCK_RATE / 16;
+	else if (clock == PRCMU_SYSCLK)
+		return ROOT_CLOCK_RATE;
+	else if (clock == PRCMU_PLLSOC0)
+		return pll_rate(PRCM_PLLSOC0_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
+	else if (clock == PRCMU_PLLSOC1)
+		return pll_rate(PRCM_PLLSOC1_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
+	else if (clock == PRCMU_PLLDDR)
+		return pll_rate(PRCM_PLLDDR_FREQ, ROOT_CLOCK_RATE, PLL_RAW);
+	else if (clock == PRCMU_PLLDSI)
+		return pll_rate(PRCM_PLLDSI_FREQ, clock_rate(PRCMU_HDMICLK),
+			PLL_RAW);
+	else if ((clock == PRCMU_DSI0CLK) || (clock == PRCMU_DSI1CLK))
+		return dsiclk_rate(clock - PRCMU_DSI0CLK);
+	else if ((PRCMU_DSI0ESCCLK <= clock) && (clock <= PRCMU_DSI2ESCCLK))
+		return dsiescclk_rate(clock - PRCMU_DSI0ESCCLK);
+	else
+		return 0;
+}
+
+static unsigned long clock_source_rate(u32 clk_mgt_val, int branch)
+{
+	if (clk_mgt_val & PRCM_CLK_MGT_CLK38)
+		return ROOT_CLOCK_RATE;
+	clk_mgt_val &= PRCM_CLK_MGT_CLKPLLSW_MASK;
+	if (clk_mgt_val == PRCM_CLK_MGT_CLKPLLSW_SOC0)
+		return pll_rate(PRCM_PLLSOC0_FREQ, ROOT_CLOCK_RATE, branch);
+	else if (clk_mgt_val == PRCM_CLK_MGT_CLKPLLSW_SOC1)
+		return pll_rate(PRCM_PLLSOC1_FREQ, ROOT_CLOCK_RATE, branch);
+	else if (clk_mgt_val == PRCM_CLK_MGT_CLKPLLSW_DDR)
+		return pll_rate(PRCM_PLLDDR_FREQ, ROOT_CLOCK_RATE, branch);
+	else
+		return 0;
+}
+
+static u32 clock_divider(unsigned long src_rate, unsigned long rate)
+{
+	u32 div;
+
+	div = (src_rate / rate);
+	if (div == 0)
+		return 1;
+	if (rate < (src_rate / div))
+		div++;
+	return div;
+}
+
+static long round_clock_rate(u8 clock, unsigned long rate)
+{
+	u32 val;
+	u32 div;
+	unsigned long src_rate;
+	long rounded_rate;
+
+	val = readl(clk_mgt[clock].reg);
+	src_rate = clock_source_rate((val | clk_mgt[clock].pllsw),
+		clk_mgt[clock].branch);
+	div = clock_divider(src_rate, rate);
+	if (val & PRCM_CLK_MGT_CLK38) {
+		if (clk_mgt[clock].clk38div) {
+			if (div > 2)
+				div = 2;
+		} else {
+			div = 1;
+		}
+	} else if ((clock == PRCMU_SGACLK) && (div == 3)) {
+		u64 r = (src_rate * 10);
+
+		(void)do_div(r, 25);
+		if (r <= rate)
+			return (unsigned long)r;
+	}
+	rounded_rate = (src_rate / min(div, (u32)31));
+
+	return rounded_rate;
+}
+
+#define MIN_PLL_VCO_RATE 600000000ULL
+#define MAX_PLL_VCO_RATE 1680640000ULL
+
+static long round_plldsi_rate(unsigned long rate)
+{
+	long rounded_rate = 0;
+	unsigned long src_rate;
+	unsigned long rem;
+	u32 r;
+
+	src_rate = clock_rate(PRCMU_HDMICLK);
+	rem = rate;
+
+	for (r = 7; (rem > 0) && (r > 0); r--) {
+		u64 d;
+
+		d = (r * rate);
+		(void)do_div(d, src_rate);
+		if (d < 6)
+			d = 6;
+		else if (d > 255)
+			d = 255;
+		d *= src_rate;
+		if (((2 * d) < (r * MIN_PLL_VCO_RATE)) ||
+			((r * MAX_PLL_VCO_RATE) < (2 * d)))
+			continue;
+		(void)do_div(d, r);
+		if (rate < d) {
+			if (rounded_rate == 0)
+				rounded_rate = (long)d;
+			break;
+		}
+		if ((rate - d) < rem) {
+			rem = (rate - d);
+			rounded_rate = (long)d;
+		}
+	}
+	return rounded_rate;
+}
+
+static long round_dsiclk_rate(unsigned long rate)
+{
+	u32 div;
+	unsigned long src_rate;
+	long rounded_rate;
+
+	src_rate = pll_rate(PRCM_PLLDSI_FREQ, clock_rate(PRCMU_HDMICLK),
+		PLL_RAW);
+	div = clock_divider(src_rate, rate);
+	rounded_rate = (src_rate / ((div > 2) ? 4 : div));
+
+	return rounded_rate;
+}
+
+static long round_dsiescclk_rate(unsigned long rate)
+{
+	u32 div;
+	unsigned long src_rate;
+	long rounded_rate;
+
+	src_rate = clock_rate(PRCMU_TVCLK);
+	div = clock_divider(src_rate, rate);
+	rounded_rate = (src_rate / min(div, (u32)255));
+
+	return rounded_rate;
+}
+
+long prcmu_round_clock_rate(u8 clock, unsigned long rate)
+{
+	if (clock < PRCMU_NUM_REG_CLOCKS)
+		return round_clock_rate(clock, rate);
+	else if (clock == PRCMU_PLLDSI)
+		return round_plldsi_rate(rate);
+	else if ((clock == PRCMU_DSI0CLK) || (clock == PRCMU_DSI1CLK))
+		return round_dsiclk_rate(rate);
+	else if ((PRCMU_DSI0ESCCLK <= clock) && (clock <= PRCMU_DSI2ESCCLK))
+		return round_dsiescclk_rate(rate);
+	else
+		return (long)prcmu_clock_rate(clock);
+}
+
+static void set_clock_rate(u8 clock, unsigned long rate)
+{
+	u32 val;
+	u32 div;
+	unsigned long src_rate;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clk_mgt_lock, flags);
+
+	/* Grab the HW semaphore. */
+	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
+		cpu_relax();
+
+	val = readl(clk_mgt[clock].reg);
+	src_rate = clock_source_rate((val | clk_mgt[clock].pllsw),
+		clk_mgt[clock].branch);
+	div = clock_divider(src_rate, rate);
+	if (val & PRCM_CLK_MGT_CLK38) {
+		if (clk_mgt[clock].clk38div) {
+			if (div > 1)
+				val |= PRCM_CLK_MGT_CLK38DIV;
+			else
+				val &= ~PRCM_CLK_MGT_CLK38DIV;
+		}
+	} else if (clock == PRCMU_SGACLK) {
+		val &= ~(PRCM_CLK_MGT_CLKPLLDIV_MASK |
+			PRCM_SGACLK_MGT_SGACLKDIV_BY_2_5_EN);
+		if (div == 3) {
+			u64 r = (src_rate * 10);
+
+			(void)do_div(r, 25);
+			if (r <= rate) {
+				val |= PRCM_SGACLK_MGT_SGACLKDIV_BY_2_5_EN;
+				div = 0;
+			}
+		}
+		val |= min(div, (u32)31);
+	} else {
+		val &= ~PRCM_CLK_MGT_CLKPLLDIV_MASK;
+		val |= min(div, (u32)31);
+	}
+	writel(val, clk_mgt[clock].reg);
+
+	/* Release the HW semaphore. */
+	writel(0, PRCM_SEM);
+
+	spin_unlock_irqrestore(&clk_mgt_lock, flags);
+}
+
+static int set_plldsi_rate(unsigned long rate)
+{
+	unsigned long src_rate;
+	unsigned long rem;
+	u32 pll_freq = 0;
+	u32 r;
+
+	src_rate = clock_rate(PRCMU_HDMICLK);
+	rem = rate;
+
+	for (r = 7; (rem > 0) && (r > 0); r--) {
+		u64 d;
+		u64 hwrate;
+
+		d = (r * rate);
+		(void)do_div(d, src_rate);
+		if (d < 6)
+			d = 6;
+		else if (d > 255)
+			d = 255;
+		hwrate = (d * src_rate);
+		if (((2 * hwrate) < (r * MIN_PLL_VCO_RATE)) ||
+			((r * MAX_PLL_VCO_RATE) < (2 * hwrate)))
+			continue;
+		(void)do_div(hwrate, r);
+		if (rate < hwrate) {
+			if (pll_freq == 0)
+				pll_freq = (((u32)d << PRCM_PLL_FREQ_D_SHIFT) |
+					(r << PRCM_PLL_FREQ_R_SHIFT));
+			break;
+		}
+		if ((rate - hwrate) < rem) {
+			rem = (rate - hwrate);
+			pll_freq = (((u32)d << PRCM_PLL_FREQ_D_SHIFT) |
+				(r << PRCM_PLL_FREQ_R_SHIFT));
+		}
+	}
+	if (pll_freq == 0)
+		return -EINVAL;
+
+	pll_freq |= (1 << PRCM_PLL_FREQ_N_SHIFT);
+	writel(pll_freq, PRCM_PLLDSI_FREQ);
+
+	return 0;
+}
+
+static void set_dsiclk_rate(u8 n, unsigned long rate)
+{
+	u32 val;
+	u32 div;
+
+	div = clock_divider(pll_rate(PRCM_PLLDSI_FREQ,
+			clock_rate(PRCMU_HDMICLK), PLL_RAW), rate);
+
+	dsiclk[n].divsel = (div == 1) ? PRCM_DSI_PLLOUT_SEL_PHI :
+			   (div == 2) ? PRCM_DSI_PLLOUT_SEL_PHI_2 :
+			   /* else */	PRCM_DSI_PLLOUT_SEL_PHI_4;
+
+	val = readl(PRCM_DSI_PLLOUT_SEL);
+	val &= ~dsiclk[n].divsel_mask;
+	val |= (dsiclk[n].divsel << dsiclk[n].divsel_shift);
+	writel(val, PRCM_DSI_PLLOUT_SEL);
+}
+
+static void set_dsiescclk_rate(u8 n, unsigned long rate)
+{
+	u32 val;
+	u32 div;
+
+	div = clock_divider(clock_rate(PRCMU_TVCLK), rate);
+	val = readl(PRCM_DSITVCLK_DIV);
+	val &= ~dsiescclk[n].div_mask;
+	val |= (min(div, (u32)255) << dsiescclk[n].div_shift);
+	writel(val, PRCM_DSITVCLK_DIV);
+}
+
+int prcmu_set_clock_rate(u8 clock, unsigned long rate)
+{
+	if (clock < PRCMU_NUM_REG_CLOCKS)
+		set_clock_rate(clock, rate);
+	else if (clock == PRCMU_PLLDSI)
+		return set_plldsi_rate(rate);
+	else if ((clock == PRCMU_DSI0CLK) || (clock == PRCMU_DSI1CLK))
+		set_dsiclk_rate((clock - PRCMU_DSI0CLK), rate);
+	else if ((PRCMU_DSI0ESCCLK <= clock) && (clock <= PRCMU_DSI2ESCCLK))
+		set_dsiescclk_rate((clock - PRCMU_DSI0ESCCLK), rate);
+	return 0;
 }
 
 int db8500_prcmu_config_esram0_deep_sleep(u8 state)
@@ -1594,41 +2137,6 @@ int db8500_prcmu_load_a9wdog(u8 id, u32 timeout)
 }
 
 /**
- * prcmu_set_clock_divider() - Configure the clock divider.
- * @clock:	The clock for which the request is made.
- * @divider:	The clock divider. (< 32)
- *
- * This function should only be used by the clock implementation.
- * Do not use it from any other place!
- */
-int prcmu_set_clock_divider(u8 clock, u8 divider)
-{
-	u32 val;
-	unsigned long flags;
-
-	if ((clock >= PRCMU_NUM_REG_CLOCKS) || (divider < 1) || (31 < divider))
-		return -EINVAL;
-
-	spin_lock_irqsave(&clk_mgt_lock, flags);
-
-	/* Grab the HW semaphore. */
-	while ((readl(PRCM_SEM) & PRCM_SEM_PRCM_SEM) != 0)
-		cpu_relax();
-
-	val = readl(_PRCMU_BASE + clk_mgt[clock].offset);
-	val &= ~(PRCM_CLK_MGT_CLKPLLDIV_MASK);
-	val |= (u32)divider;
-	writel(val, (_PRCMU_BASE + clk_mgt[clock].offset));
-
-	/* Release the HW semaphore. */
-	writel(0, PRCM_SEM);
-
-	spin_unlock_irqrestore(&clk_mgt_lock, flags);
-
-	return 0;
-}
-
-/**
  * prcmu_abb_read() - Read register value(s) from the ABB.
  * @slave:	The I2C slave address.
  * @reg:	The (start) register address.
diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
index ec22e9f..b9ab4ce 100644
--- a/drivers/mfd/dbx500-prcmu-regs.h
+++ b/drivers/mfd/dbx500-prcmu-regs.h
@@ -17,41 +17,41 @@
 
 #define BITS(_start, _end) ((BIT(_end) - BIT(_start)) + BIT(_end))
 
-#define PRCM_SVACLK_MGT_OFF		0x008
-#define PRCM_SIACLK_MGT_OFF		0x00C
-#define PRCM_SGACLK_MGT_OFF		0x014
-#define PRCM_UARTCLK_MGT_OFF		0x018
-#define PRCM_MSP02CLK_MGT_OFF		0x01C
-#define PRCM_I2CCLK_MGT_OFF		0x020
-#define PRCM_SDMMCCLK_MGT_OFF		0x024
-#define PRCM_SLIMCLK_MGT_OFF		0x028
-#define PRCM_PER1CLK_MGT_OFF		0x02C
-#define PRCM_PER2CLK_MGT_OFF		0x030
-#define PRCM_PER3CLK_MGT_OFF		0x034
-#define PRCM_PER5CLK_MGT_OFF		0x038
-#define PRCM_PER6CLK_MGT_OFF		0x03C
-#define PRCM_PER7CLK_MGT_OFF		0x040
-#define PRCM_PWMCLK_MGT_OFF		0x044 /* for DB5500 */
-#define PRCM_IRDACLK_MGT_OFF		0x048 /* for DB5500 */
-#define PRCM_IRRCCLK_MGT_OFF		0x04C /* for DB5500 */
-#define PRCM_LCDCLK_MGT_OFF		0x044
-#define PRCM_BMLCLK_MGT_OFF		0x04C
-#define PRCM_HSITXCLK_MGT_OFF		0x050
-#define PRCM_HSIRXCLK_MGT_OFF		0x054
-#define PRCM_HDMICLK_MGT_OFF		0x058
-#define PRCM_APEATCLK_MGT_OFF		0x05C
-#define PRCM_APETRACECLK_MGT_OFF	0x060
-#define PRCM_MCDECLK_MGT_OFF		0x064
-#define PRCM_IPI2CCLK_MGT_OFF		0x068
-#define PRCM_DSIALTCLK_MGT_OFF		0x06C
-#define PRCM_DMACLK_MGT_OFF		0x074
-#define PRCM_B2R2CLK_MGT_OFF		0x078
-#define PRCM_TVCLK_MGT_OFF		0x07C
-#define PRCM_UNIPROCLK_MGT_OFF		0x278
-#define PRCM_SSPCLK_MGT_OFF		0x280
-#define PRCM_RNGCLK_MGT_OFF		0x284
-#define PRCM_UICCCLK_MGT_OFF		0x27C
-#define PRCM_MSP1CLK_MGT_OFF		0x288
+#define PRCM_CLK_MGT(_offset) (void __iomem *)(IO_ADDRESS(U8500_PRCMU_BASE) \
+	+ _offset)
+#define PRCM_ACLK_MGT		PRCM_CLK_MGT(0x004)
+#define PRCM_SVACLK_MGT		PRCM_CLK_MGT(0x008)
+#define PRCM_SIACLK_MGT		PRCM_CLK_MGT(0x00C)
+#define PRCM_SGACLK_MGT		PRCM_CLK_MGT(0x014)
+#define PRCM_UARTCLK_MGT	PRCM_CLK_MGT(0x018)
+#define PRCM_MSP02CLK_MGT	PRCM_CLK_MGT(0x01C)
+#define PRCM_I2CCLK_MGT		PRCM_CLK_MGT(0x020)
+#define PRCM_SDMMCCLK_MGT	PRCM_CLK_MGT(0x024)
+#define PRCM_SLIMCLK_MGT	PRCM_CLK_MGT(0x028)
+#define PRCM_PER1CLK_MGT	PRCM_CLK_MGT(0x02C)
+#define PRCM_PER2CLK_MGT	PRCM_CLK_MGT(0x030)
+#define PRCM_PER3CLK_MGT	PRCM_CLK_MGT(0x034)
+#define PRCM_PER5CLK_MGT	PRCM_CLK_MGT(0x038)
+#define PRCM_PER6CLK_MGT	PRCM_CLK_MGT(0x03C)
+#define PRCM_PER7CLK_MGT	PRCM_CLK_MGT(0x040)
+#define PRCM_LCDCLK_MGT		PRCM_CLK_MGT(0x044)
+#define PRCM_BMLCLK_MGT		PRCM_CLK_MGT(0x04C)
+#define PRCM_HSITXCLK_MGT	PRCM_CLK_MGT(0x050)
+#define PRCM_HSIRXCLK_MGT	PRCM_CLK_MGT(0x054)
+#define PRCM_HDMICLK_MGT	PRCM_CLK_MGT(0x058)
+#define PRCM_APEATCLK_MGT	PRCM_CLK_MGT(0x05C)
+#define PRCM_APETRACECLK_MGT	PRCM_CLK_MGT(0x060)
+#define PRCM_MCDECLK_MGT	PRCM_CLK_MGT(0x064)
+#define PRCM_IPI2CCLK_MGT	PRCM_CLK_MGT(0x068)
+#define PRCM_DSIALTCLK_MGT	PRCM_CLK_MGT(0x06C)
+#define PRCM_DMACLK_MGT		PRCM_CLK_MGT(0x074)
+#define PRCM_B2R2CLK_MGT	PRCM_CLK_MGT(0x078)
+#define PRCM_TVCLK_MGT		PRCM_CLK_MGT(0x07C)
+#define PRCM_UNIPROCLK_MGT	PRCM_CLK_MGT(0x278)
+#define PRCM_SSPCLK_MGT		PRCM_CLK_MGT(0x280)
+#define PRCM_RNGCLK_MGT		PRCM_CLK_MGT(0x284)
+#define PRCM_UICCCLK_MGT	PRCM_CLK_MGT(0x27C)
+#define PRCM_MSP1CLK_MGT	PRCM_CLK_MGT(0x288)
 
 #define PRCM_ARM_PLLDIVPS	(_PRCMU_BASE + 0x118)
 #define PRCM_ARM_PLLDIVPS_ARM_BRM_RATE		0x3f
@@ -131,20 +131,58 @@
 #define PRCM_MMIP_LS_CLAMP_SET     (_PRCMU_BASE + 0x420)
 #define PRCM_MMIP_LS_CLAMP_CLR     (_PRCMU_BASE + 0x424)
 
+#define PRCM_MMIP_LS_CLAMP_DSIPLL_CLAMP		BIT(11)
+#define PRCM_MMIP_LS_CLAMP_DSIPLL_CLAMPI	BIT(22)
+
 /* PRCMU clock/PLL/reset registers */
+#define PRCM_PLLSOC0_FREQ	   (_PRCMU_BASE + 0x080)
+#define PRCM_PLLSOC1_FREQ	   (_PRCMU_BASE + 0x084)
+#define PRCM_PLLDDR_FREQ	   (_PRCMU_BASE + 0x08C)
+#define PRCM_PLL_FREQ_D_SHIFT	0
+#define PRCM_PLL_FREQ_D_MASK	BITS(0, 7)
+#define PRCM_PLL_FREQ_N_SHIFT	8
+#define PRCM_PLL_FREQ_N_MASK	BITS(8, 13)
+#define PRCM_PLL_FREQ_R_SHIFT	16
+#define PRCM_PLL_FREQ_R_MASK	BITS(16, 18)
+#define PRCM_PLL_FREQ_SELDIV2	BIT(24)
+#define PRCM_PLL_FREQ_DIV2EN	BIT(25)
+
 #define PRCM_PLLDSI_FREQ           (_PRCMU_BASE + 0x500)
 #define PRCM_PLLDSI_ENABLE         (_PRCMU_BASE + 0x504)
 #define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
-#define PRCM_LCDCLK_MGT            (_PRCMU_BASE + PRCM_LCDCLK_MGT_OFF)
-#define PRCM_MCDECLK_MGT           (_PRCMU_BASE + PRCM_MCDECLK_MGT_OFF)
-#define PRCM_HDMICLK_MGT           (_PRCMU_BASE + PRCM_HDMICLK_MGT_OFF)
-#define PRCM_TVCLK_MGT             (_PRCMU_BASE + PRCM_TVCLK_MGT_OFF)
 #define PRCM_DSI_PLLOUT_SEL        (_PRCMU_BASE + 0x530)
 #define PRCM_DSITVCLK_DIV          (_PRCMU_BASE + 0x52C)
 #define PRCM_PLLDSI_LOCKP          (_PRCMU_BASE + 0x508)
 #define PRCM_APE_RESETN_SET        (_PRCMU_BASE + 0x1E4)
 #define PRCM_APE_RESETN_CLR        (_PRCMU_BASE + 0x1E8)
 
+#define PRCM_PLLDSI_ENABLE_PRCM_PLLDSI_ENABLE BIT(0)
+
+#define PRCM_PLLDSI_LOCKP_PRCM_PLLDSI_LOCKP10	BIT(0)
+#define PRCM_PLLDSI_LOCKP_PRCM_PLLDSI_LOCKP3	BIT(1)
+
+#define PRCM_DSI_PLLOUT_SEL_DSI0_PLLOUT_DIVSEL_SHIFT	0
+#define PRCM_DSI_PLLOUT_SEL_DSI0_PLLOUT_DIVSEL_MASK	BITS(0, 2)
+#define PRCM_DSI_PLLOUT_SEL_DSI1_PLLOUT_DIVSEL_SHIFT	8
+#define PRCM_DSI_PLLOUT_SEL_DSI1_PLLOUT_DIVSEL_MASK	BITS(8, 10)
+
+#define PRCM_DSI_PLLOUT_SEL_OFF		0
+#define PRCM_DSI_PLLOUT_SEL_PHI		1
+#define PRCM_DSI_PLLOUT_SEL_PHI_2	2
+#define PRCM_DSI_PLLOUT_SEL_PHI_4	3
+
+#define PRCM_DSITVCLK_DIV_DSI0_ESC_CLK_DIV_SHIFT	0
+#define PRCM_DSITVCLK_DIV_DSI0_ESC_CLK_DIV_MASK		BITS(0, 7)
+#define PRCM_DSITVCLK_DIV_DSI1_ESC_CLK_DIV_SHIFT	8
+#define PRCM_DSITVCLK_DIV_DSI1_ESC_CLK_DIV_MASK		BITS(8, 15)
+#define PRCM_DSITVCLK_DIV_DSI2_ESC_CLK_DIV_SHIFT	16
+#define PRCM_DSITVCLK_DIV_DSI2_ESC_CLK_DIV_MASK		BITS(16, 23)
+#define PRCM_DSITVCLK_DIV_DSI0_ESC_CLK_EN		BIT(24)
+#define PRCM_DSITVCLK_DIV_DSI1_ESC_CLK_EN		BIT(25)
+#define PRCM_DSITVCLK_DIV_DSI2_ESC_CLK_EN		BIT(26)
+
+#define PRCM_APE_RESETN_DSIPLL_RESETN BIT(14)
+
 #define PRCM_CLKOCR		   (_PRCMU_BASE + 0x1CC)
 #define PRCM_CLKOCR_CLKOUT0_REF_CLK	(1 << 0)
 #define PRCM_CLKOCR_CLKOUT0_MASK	BITS(0, 13)
@@ -183,9 +221,15 @@
 #define PRCM_CLKOCR_CLKOSEL1_MASK	BITS(22, 24)
 #define PRCM_CLKOCR_CLK1TYPE		BIT(28)
 
-#define PRCM_CLK_MGT_CLKPLLDIV_MASK	BITS(0, 4)
-#define PRCM_CLK_MGT_CLKPLLSW_MASK	BITS(5, 7)
-#define PRCM_CLK_MGT_CLKEN		BIT(8)
+#define PRCM_CLK_MGT_CLKPLLDIV_MASK		BITS(0, 4)
+#define PRCM_CLK_MGT_CLKPLLSW_SOC0		BIT(5)
+#define PRCM_CLK_MGT_CLKPLLSW_SOC1		BIT(6)
+#define PRCM_CLK_MGT_CLKPLLSW_DDR		BIT(7)
+#define PRCM_CLK_MGT_CLKPLLSW_MASK		BITS(5, 7)
+#define PRCM_CLK_MGT_CLKEN			BIT(8)
+#define PRCM_CLK_MGT_CLK38			BIT(9)
+#define PRCM_CLK_MGT_CLK38DIV			BIT(11)
+#define PRCM_SGACLK_MGT_SGACLKDIV_BY_2_5_EN	BIT(12)
 
 /* GPIOCR register */
 #define PRCM_GPIOCR_SPI2_SELECT BIT(23)
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index f73b9d9..8470c7d 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -80,6 +80,29 @@ enum prcmu_wakeup_index {
 #define EPOD_STATE_ON_CLK_OFF	0x03
 #define EPOD_STATE_ON		0x04
 
+/* DB5500 CLKOUT IDs */
+enum {
+	DB5500_CLKOUT0 = 0,
+	DB5500_CLKOUT1,
+};
+
+/* DB5500 CLKOUTx sources */
+enum {
+	DB5500_CLKOUT_REF_CLK_SEL0,
+	DB5500_CLKOUT_RTC_CLK0_SEL0,
+	DB5500_CLKOUT_ULP_CLK_SEL0,
+	DB5500_CLKOUT_STATIC0,
+	DB5500_CLKOUT_REFCLK,
+	DB5500_CLKOUT_ULPCLK,
+	DB5500_CLKOUT_ARMCLK,
+	DB5500_CLKOUT_SYSACC0CLK,
+	DB5500_CLKOUT_SOC0PLLCLK,
+	DB5500_CLKOUT_SOC1PLLCLK,
+	DB5500_CLKOUT_DDRPLLCLK,
+	DB5500_CLKOUT_TVCLK,
+	DB5500_CLKOUT_IRDACLK,
+};
+
 /*
  * CLKOUT sources
  */
@@ -111,6 +134,7 @@ enum prcmu_clock {
 	PRCMU_MSP1CLK,
 	PRCMU_I2CCLK,
 	PRCMU_SDMMCCLK,
+	PRCMU_SPARE1CLK,
 	PRCMU_SLIMCLK,
 	PRCMU_PER1CLK,
 	PRCMU_PER2CLK,
@@ -139,12 +163,20 @@ enum prcmu_clock {
 	PRCMU_IRRCCLK,
 	PRCMU_SIACLK,
 	PRCMU_SVACLK,
+	PRCMU_ACLK,
 	PRCMU_NUM_REG_CLOCKS,
 	PRCMU_SYSCLK = PRCMU_NUM_REG_CLOCKS,
+	PRCMU_CDCLK,
 	PRCMU_TIMCLK,
 	PRCMU_PLLSOC0,
 	PRCMU_PLLSOC1,
 	PRCMU_PLLDDR,
+	PRCMU_PLLDSI,
+	PRCMU_DSI0CLK,
+	PRCMU_DSI1CLK,
+	PRCMU_DSI0ESCCLK,
+	PRCMU_DSI1ESCCLK,
+	PRCMU_DSI2ESCCLK,
 };
 
 /**
@@ -516,6 +548,21 @@ static inline int prcmu_request_clock(u8 clock, bool enable)
 	return 0;
 }
 
+static inline long prcmu_round_clock_rate(u8 clock, unsigned long rate)
+{
+	return 0;
+}
+
+static inline int prcmu_set_clock_rate(u8 clock, unsigned long rate)
+{
+	return 0;
+}
+
+static inline unsigned long prcmu_clock_rate(u8 clock)
+{
+	return 0;
+}
+
 static inline int prcmu_set_ape_opp(u8 opp)
 {
 	return 0;
-- 
1.7.8

