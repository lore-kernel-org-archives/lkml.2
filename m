Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0LQAxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:53:13 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29788 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0LQAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160023"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 07/22] msm: clock: Refactor clock-7x30 into generic clock-local driver
Date: Thu, 16 Dec 2010 16:49:51 -0800
Message-Id: <1292547006-19741-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

The generic 'clock-local' driver is introduced to facilitate
sharing of common code among local clock drivers for different
SoCs. Presently, only 7x30 makes use of this driver.

SoC-independent code is implemented in clock-local.c, while
SoC-specific code is implemented in other clock-* files (ex.
clock-7x30.c).

Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/Makefile      |    1 +
 arch/arm/mach-msm/clock-7x30.c  | 1462 +++++++++++++--------------------------
 arch/arm/mach-msm/clock-7x30.h  |  230 +++----
 arch/arm/mach-msm/clock-local.c |  679 ++++++++++++++++++
 arch/arm/mach-msm/clock-local.h |  232 +++++++
 5 files changed, 1516 insertions(+), 1088 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-local.c
 create mode 100644 arch/arm/mach-msm/clock-local.h

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 8588b57..33f0c39 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -2,6 +2,7 @@ obj-y += io.o idle.o timer.o
 ifdef CONFIG_MSM_PROC_COMM
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 endif
+obj-$(CONFIG_ARCH_MSM7X30) += clock-local.o
 obj-$(CONFIG_ARCH_MSM7X30) += clock-7x30.o
 ifndef CONFIG_ARCH_MSM8X60
 obj-y += acpuclock-arm11.o
diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index beca3a6..0637bee 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -29,16 +29,13 @@
 #include <mach/clk.h>
 
 #include "clock.h"
+#include "clock-local.h"
 #include "clock-7x30.h"
 #include "clock-pcom.h"
 #include "proc_comm.h"
 
-#define REG_BASE(off) (MSM_CLK_CTL_BASE + off)
-#define REG(off) (MSM_CLK_CTL_SH2_BASE + off)
-#define MNCNTR_EN_MASK		B(8)
-#define MNCNTR_RST_MASK		B(7)
-#define MNCNTR_MODE_MASK	BM(6, 5)
-#define MNCNTR_MODE		BVAL(6, 5, 0x2) /* Dual-edge mode. */
+#define REG_BASE(off) (MSM_CLK_CTL_BASE + (off))
+#define REG(off) (MSM_CLK_CTL_SH2_BASE + (off))
 
 /* Shadow-region 2 (SH2) registers. */
 #define	QUP_I2C_NS_REG		REG(0x04F0)
@@ -106,1142 +103,597 @@
 #define SH2_OWN_ROW1_BASE_REG	REG_BASE(0x041C)
 #define SH2_OWN_ROW2_BASE_REG	REG_BASE(0x0424)
 
-struct clk_freq_tbl {
-	uint32_t	freq_hz;
-	uint32_t	src;
-	uint32_t	md_val;
-	uint32_t	ns_val;
-	uint32_t	mode;
-	unsigned	msmc1;
-};
-
-struct clk_local {
-	uint32_t	count;
-	uint32_t	type;
-	void __iomem	*md_reg;
-	void __iomem	*ns_reg;
-	uint32_t	freq_mask;
-	uint32_t	br_en_mask;
-	uint32_t	root_en_mask;
-	int		parent;
-	uint32_t	*children;
-	const struct clk_freq_tbl	*freq_tbl;
-	const struct clk_freq_tbl	*current_freq;
-	void __iomem	*halt_reg;
-	uint32_t	halt_mask;
-	uint32_t	test_vector;
-};
-
-
-enum {
-	SRC_PLL0 = 4, /* Modem PLL */
-	SRC_PLL1 = 1, /* Global PLL */
-	SRC_PLL3 = 3, /* Multimedia/Peripheral PLL or Backup PLL1 */
-	SRC_PLL4 = 2, /* Display PLL */
-	SRC_LPXO = 6, /* Low power XO. */
-	SRC_TCXO = 0, /* Used for sources that always source from tcxo */
-	SRC_AXI  = 100, /* Used for rates that sync to AXI */
-	SRC_NONE       /* Used for sources that can't be turned on/off. */
-};
-
-static uint32_t src_pll_tbl[] = {
-	[SRC_PLL0] = PLL_0,
-	[SRC_PLL1] = PLL_1,
-	[SRC_PLL3] = PLL_3,
-	[SRC_PLL4] = PLL_4,
-};
-
-#define B(x)	BIT(x)
-#define BM(msb, lsb)	(((((uint32_t)-1) << (31-msb)) >> (31-msb+lsb)) << lsb)
-#define BVAL(msb, lsb, val)	(((val) << lsb) & BM(msb, lsb))
 
+/* MUX source input identifiers. */
+#define SRC_SEL_PLL0	4 /* Modem PLL */
+#define SRC_SEL_PLL1	1 /* Global PLL */
+#define SRC_SEL_PLL3	3 /* Multimedia/Peripheral PLL or Backup PLL1 */
+#define SRC_SEL_PLL4	2 /* Display PLL */
+#define SRC_SEL_LPXO	6 /* Low-power XO */
+#define SRC_SEL_TCXO	0 /* Used for sources that always source from TCXO */
+#define SRC_SEL_AXI	0 /* Used for rates that sync to AXI */
+
+/* Source name to PLL mappings. */
+#define SRC_PLL0	PLL_0
+#define SRC_PLL1	PLL_1
+#define SRC_PLL3	PLL_3
+#define SRC_PLL4	PLL_4
+#define SRC_LPXO	LPXO
+#define SRC_TCXO	TCXO
+#define SRC_AXI		AXI
+
+/* Clock declaration macros. */
+#define MN_MODE_DUAL_EDGE	0x2
 #define MD8(m, n)		(BVAL(15, 8, m) | BVAL(7, 0, ~(n)))
-#define N8(msb, lsb, m, n)	(BVAL(msb, lsb, ~(n-m)))
+#define N8(msb, lsb, m, n)	(BVAL(msb, lsb, ~(n-m)) | BVAL(6, 5, \
+					(MN_MODE_DUAL_EDGE * !!(n))))
 #define MD16(m, n)		(BVAL(31, 16, m) | BVAL(15, 0, ~(n)))
-#define N16(m, n)		(BVAL(31, 16, ~(n-m)))
+#define N16(m, n)		(BVAL(31, 16, ~(n-m)) | BVAL(6, 5, \
+					(MN_MODE_DUAL_EDGE * !!(n))))
 #define SPDIV(s, d)		(BVAL(4, 3, d-1) | BVAL(2, 0, s))
 #define SDIV(s, d)		(BVAL(6, 3, d-1) | BVAL(2, 0, s))
 #define F_MASK_BASIC		(BM(6, 3)|BM(2, 0))
-#define F_MASK_MND16		(BM(31, 16)|BM(4, 3)|BM(2, 0))
-#define F_MASK_MND8(m, l)	(BM(m, l)|BM(4, 3)|BM(2, 0))
-
-#define F_RAW(f, s, m_v, n_v, mde, v) { \
-	.freq_hz = f, \
-	.src = s, \
-	.md_val = m_v, \
-	.ns_val = n_v, \
-	.mode = mde, \
-	.msmc1 = v \
-	}
+#define F_MASK_MND16		(BM(31, 16)|BM(6, 5)|BM(4, 3)|BM(2, 0))
+#define F_MASK_MND8(m, l)	(BM(m, l)|BM(6, 5)|BM(4, 3)|BM(2, 0))
 
-#define FREQ_END	0
-#define F_BASIC(f, s, div, v) F_RAW(f, s, 0, SDIV(s, div), 0, v)
+/*
+ * Clock frequency definitions and macros
+ */
+#define F_BASIC(f, s, div, v) \
+	F_RAW(f, SRC_##s, 0, SDIV(SRC_SEL_##s, div), 0, 0, v, NULL)
 #define F_MND16(f, s, div, m, n, v) \
-	F_RAW(f, s, MD16(m, n), N16(m, n)|SPDIV(s, div), !!(n), v)
+	F_RAW(f, SRC_##s, MD16(m, n), N16(m, n)|SPDIV(SRC_SEL_##s, div), \
+		0, (B(8) * !!(n)), v, NULL)
 #define F_MND8(f, nmsb, nlsb, s, div, m, n, v) \
-	F_RAW(f, s, MD8(m, n), N8(nmsb, nlsb, m, n)|SPDIV(s, div), !!(n), v)
-#define F_END	F_RAW(FREQ_END, SRC_NONE, 0, 0, 0, MSMC1_END)
-
-static const struct clk_freq_tbl clk_tbl_csi[] = {
-	F_MND8(153600000, 24, 17, SRC_PLL1, 2, 2, 5, NOMINAL),
-	F_MND8(192000000, 24, 17, SRC_PLL1, 4, 0, 0, NOMINAL),
-	F_MND8(384000000, 24, 17, SRC_PLL1, 2, 0, 0, NOMINAL),
+	F_RAW(f, SRC_##s, MD8(m, n), \
+		N8(nmsb, nlsb, m, n)|SPDIV(SRC_SEL_##s, div), 0, \
+		(B(8) * !!(n)), v, NULL)
+
+static struct clk_freq_tbl clk_tbl_csi[] = {
+	F_MND8(153600000, 24, 17, PLL1, 2, 2, 5, NOMINAL),
+	F_MND8(192000000, 24, 17, PLL1, 4, 0, 0, NOMINAL),
+	F_MND8(384000000, 24, 17, PLL1, 2, 0, 0, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_tcxo[] = {
-	F_RAW(19200000, SRC_TCXO, 0, 0, 0, NOMINAL),
+static struct clk_freq_tbl clk_tbl_tcxo[] = {
+	F_RAW(19200000, SRC_TCXO, 0, 0, 0, 0, NOMINAL, NULL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_axi[] = {
-	F_RAW(1, SRC_AXI, 0, 0, 0, NOMINAL),
+static struct clk_freq_tbl clk_tbl_axi[] = {
+	F_RAW(1, SRC_AXI, 0, 0, 0, 0, NOMINAL, NULL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_uartdm[] = {
-	F_MND16( 3686400, SRC_PLL3, 3,   3, 200, NOMINAL),
-	F_MND16( 7372800, SRC_PLL3, 3,   3, 100, NOMINAL),
-	F_MND16(14745600, SRC_PLL3, 3,   3,  50, NOMINAL),
-	F_MND16(32000000, SRC_PLL3, 3,  25, 192, NOMINAL),
-	F_MND16(40000000, SRC_PLL3, 3, 125, 768, NOMINAL),
-	F_MND16(46400000, SRC_PLL3, 3, 145, 768, NOMINAL),
-	F_MND16(48000000, SRC_PLL3, 3,  25, 128, NOMINAL),
-	F_MND16(51200000, SRC_PLL3, 3,   5,  24, NOMINAL),
-	F_MND16(56000000, SRC_PLL3, 3, 175, 768, NOMINAL),
-	F_MND16(58982400, SRC_PLL3, 3,   6,  25, NOMINAL),
-	F_MND16(64000000, SRC_PLL1, 4,   1,   3, NOMINAL),
+static struct clk_freq_tbl clk_tbl_uartdm[] = {
+	F_MND16( 3686400, PLL3, 3,   3, 200, NOMINAL),
+	F_MND16( 7372800, PLL3, 3,   3, 100, NOMINAL),
+	F_MND16(14745600, PLL3, 3,   3,  50, NOMINAL),
+	F_MND16(32000000, PLL3, 3,  25, 192, NOMINAL),
+	F_MND16(40000000, PLL3, 3, 125, 768, NOMINAL),
+	F_MND16(46400000, PLL3, 3, 145, 768, NOMINAL),
+	F_MND16(48000000, PLL3, 3,  25, 128, NOMINAL),
+	F_MND16(51200000, PLL3, 3,   5,  24, NOMINAL),
+	F_MND16(56000000, PLL3, 3, 175, 768, NOMINAL),
+	F_MND16(58982400, PLL3, 3,   6,  25, NOMINAL),
+	F_MND16(64000000, PLL1, 4,   1,   3, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_mdh[] = {
-	F_BASIC( 49150000, SRC_PLL3, 15, NOMINAL),
-	F_BASIC( 92160000, SRC_PLL3,  8, NOMINAL),
-	F_BASIC(122880000, SRC_PLL3,  6, NOMINAL),
-	F_BASIC(184320000, SRC_PLL3,  4, NOMINAL),
-	F_BASIC(245760000, SRC_PLL3,  3, NOMINAL),
-	F_BASIC(368640000, SRC_PLL3,  2, NOMINAL),
-	F_BASIC(384000000, SRC_PLL1,  2, NOMINAL),
-	F_BASIC(445500000, SRC_PLL4,  2, NOMINAL),
+static struct clk_freq_tbl clk_tbl_mdh[] = {
+	F_BASIC( 49150000, PLL3, 15, NOMINAL),
+	F_BASIC( 92160000, PLL3,  8, NOMINAL),
+	F_BASIC(122880000, PLL3,  6, NOMINAL),
+	F_BASIC(184320000, PLL3,  4, NOMINAL),
+	F_BASIC(245760000, PLL3,  3, NOMINAL),
+	F_BASIC(368640000, PLL3,  2, NOMINAL),
+	F_BASIC(384000000, PLL1,  2, NOMINAL),
+	F_BASIC(445500000, PLL4,  2, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_grp[] = {
-	F_BASIC( 24576000, SRC_LPXO,  1, NOMINAL),
-	F_BASIC( 46080000, SRC_PLL3, 16, NOMINAL),
-	F_BASIC( 49152000, SRC_PLL3, 15, NOMINAL),
-	F_BASIC( 52662875, SRC_PLL3, 14, NOMINAL),
-	F_BASIC( 56713846, SRC_PLL3, 13, NOMINAL),
-	F_BASIC( 61440000, SRC_PLL3, 12, NOMINAL),
-	F_BASIC( 67025454, SRC_PLL3, 11, NOMINAL),
-	F_BASIC( 73728000, SRC_PLL3, 10, NOMINAL),
-	F_BASIC( 81920000, SRC_PLL3,  9, NOMINAL),
-	F_BASIC( 92160000, SRC_PLL3,  8, NOMINAL),
-	F_BASIC(105325714, SRC_PLL3,  7, NOMINAL),
-	F_BASIC(122880000, SRC_PLL3,  6, NOMINAL),
-	F_BASIC(147456000, SRC_PLL3,  5, NOMINAL),
-	F_BASIC(184320000, SRC_PLL3,  4, NOMINAL),
-	F_BASIC(192000000, SRC_PLL1,  4, NOMINAL),
-	F_BASIC(245760000, SRC_PLL3,  3, HIGH),
+static struct clk_freq_tbl clk_tbl_grp[] = {
+	F_BASIC( 24576000, LPXO,  1, NOMINAL),
+	F_BASIC( 46080000, PLL3, 16, NOMINAL),
+	F_BASIC( 49152000, PLL3, 15, NOMINAL),
+	F_BASIC( 52662875, PLL3, 14, NOMINAL),
+	F_BASIC( 56713846, PLL3, 13, NOMINAL),
+	F_BASIC( 61440000, PLL3, 12, NOMINAL),
+	F_BASIC( 67025454, PLL3, 11, NOMINAL),
+	F_BASIC( 73728000, PLL3, 10, NOMINAL),
+	F_BASIC( 81920000, PLL3,  9, NOMINAL),
+	F_BASIC( 92160000, PLL3,  8, NOMINAL),
+	F_BASIC(105325714, PLL3,  7, NOMINAL),
+	F_BASIC(122880000, PLL3,  6, NOMINAL),
+	F_BASIC(147456000, PLL3,  5, NOMINAL),
+	F_BASIC(184320000, PLL3,  4, NOMINAL),
+	F_BASIC(192000000, PLL1,  4, NOMINAL),
+	F_BASIC(245760000, PLL3,  3, HIGH),
 	/* Sync to AXI. Hence this "rate" is not fixed. */
-	F_RAW(1, SRC_AXI, 0, B(14), 0, NOMINAL),
+	F_RAW(1, SRC_AXI, 0, B(14), 0, 0, NOMINAL, NULL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_sdc1_3[] = {
-	F_MND8(  144000, 19, 12, SRC_LPXO, 1,   1,  171, NOMINAL),
-	F_MND8(  400000, 19, 12, SRC_LPXO, 1,   2,  123, NOMINAL),
-	F_MND8(16027000, 19, 12, SRC_PLL3, 3,  14,  215, NOMINAL),
-	F_MND8(17000000, 19, 12, SRC_PLL3, 4,  19,  206, NOMINAL),
-	F_MND8(20480000, 19, 12, SRC_PLL3, 4,  23,  212, NOMINAL),
-	F_MND8(24576000, 19, 12, SRC_LPXO, 1,   0,    0, NOMINAL),
-	F_MND8(49152000, 19, 12, SRC_PLL3, 3,   1,    5, NOMINAL),
+static struct clk_freq_tbl clk_tbl_sdc1_3[] = {
+	F_MND8(  144000, 19, 12, LPXO, 1,   1,  171, NOMINAL),
+	F_MND8(  400000, 19, 12, LPXO, 1,   2,  123, NOMINAL),
+	F_MND8(16027000, 19, 12, PLL3, 3,  14,  215, NOMINAL),
+	F_MND8(17000000, 19, 12, PLL3, 4,  19,  206, NOMINAL),
+	F_MND8(20480000, 19, 12, PLL3, 4,  23,  212, NOMINAL),
+	F_MND8(24576000, 19, 12, LPXO, 1,   0,    0, NOMINAL),
+	F_MND8(49152000, 19, 12, PLL3, 3,   1,    5, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_sdc2_4[] = {
-	F_MND8(  144000, 20, 13, SRC_LPXO, 1,   1,  171, NOMINAL),
-	F_MND8(  400000, 20, 13, SRC_LPXO, 1,   2,  123, NOMINAL),
-	F_MND8(16027000, 20, 13, SRC_PLL3, 3,  14,  215, NOMINAL),
-	F_MND8(17000000, 20, 13, SRC_PLL3, 4,  19,  206, NOMINAL),
-	F_MND8(20480000, 20, 13, SRC_PLL3, 4,  23,  212, NOMINAL),
-	F_MND8(24576000, 20, 13, SRC_LPXO, 1,   0,    0, NOMINAL),
-	F_MND8(49152000, 20, 13, SRC_PLL3, 3,   1,    5, NOMINAL),
+static struct clk_freq_tbl clk_tbl_sdc2_4[] = {
+	F_MND8(  144000, 20, 13, LPXO, 1,   1,  171, NOMINAL),
+	F_MND8(  400000, 20, 13, LPXO, 1,   2,  123, NOMINAL),
+	F_MND8(16027000, 20, 13, PLL3, 3,  14,  215, NOMINAL),
+	F_MND8(17000000, 20, 13, PLL3, 4,  19,  206, NOMINAL),
+	F_MND8(20480000, 20, 13, PLL3, 4,  23,  212, NOMINAL),
+	F_MND8(24576000, 20, 13, LPXO, 1,   0,    0, NOMINAL),
+	F_MND8(49152000, 20, 13, PLL3, 3,   1,    5, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_mdp_core[] = {
-	F_BASIC( 46080000, SRC_PLL3, 16, NOMINAL),
-	F_BASIC( 49152000, SRC_PLL3, 15, NOMINAL),
-	F_BASIC( 52663000, SRC_PLL3, 14, NOMINAL),
-	F_BASIC( 92160000, SRC_PLL3,  8, NOMINAL),
-	F_BASIC(122880000, SRC_PLL3,  6, NOMINAL),
-	F_BASIC(147456000, SRC_PLL3,  5, NOMINAL),
-	F_BASIC(153600000, SRC_PLL1,  5, NOMINAL),
-	F_BASIC(192000000, SRC_PLL1,  4, HIGH),
+static struct clk_freq_tbl clk_tbl_mdp_core[] = {
+	F_BASIC( 46080000, PLL3, 16, NOMINAL),
+	F_BASIC( 49152000, PLL3, 15, NOMINAL),
+	F_BASIC( 52663000, PLL3, 14, NOMINAL),
+	F_BASIC( 92160000, PLL3,  8, NOMINAL),
+	F_BASIC(122880000, PLL3,  6, NOMINAL),
+	F_BASIC(147456000, PLL3,  5, NOMINAL),
+	F_BASIC(153600000, PLL1,  5, NOMINAL),
+	F_BASIC(192000000, PLL1,  4, HIGH),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_mdp_lcdc[] = {
-	F_MND16(24576000, SRC_LPXO, 1,   0,   0, NOMINAL),
-	F_MND16(30720000, SRC_PLL3, 4,   1,   6, NOMINAL),
-	F_MND16(32768000, SRC_PLL3, 3,   2,  15, NOMINAL),
-	F_MND16(40960000, SRC_PLL3, 2,   1,   9, NOMINAL),
-	F_MND16(73728000, SRC_PLL3, 2,   1,   5, NOMINAL),
+static struct clk_freq_tbl clk_tbl_mdp_lcdc[] = {
+	F_MND16(24576000, LPXO, 1,   0,   0, NOMINAL),
+	F_MND16(30720000, PLL3, 4,   1,   6, NOMINAL),
+	F_MND16(32768000, PLL3, 3,   2,  15, NOMINAL),
+	F_MND16(40960000, PLL3, 2,   1,   9, NOMINAL),
+	F_MND16(73728000, PLL3, 2,   1,   5, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_mdp_vsync[] = {
-	F_RAW(24576000, SRC_LPXO, 0, 0, 0, NOMINAL),
+static struct clk_freq_tbl clk_tbl_mdp_vsync[] = {
+	F_RAW(24576000, SRC_LPXO, 0, 0, 0, 0, NOMINAL, NULL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_mi2s_codec[] = {
-	F_MND16( 2048000, SRC_LPXO, 4,   1,   3, NOMINAL),
-	F_MND16(12288000, SRC_LPXO, 2,   0,   0, NOMINAL),
+static struct clk_freq_tbl clk_tbl_mi2s_codec[] = {
+	F_MND16( 2048000, LPXO, 4,   1,   3, NOMINAL),
+	F_MND16(12288000, LPXO, 2,   0,   0, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_mi2s[] = {
-	F_MND16(12288000, SRC_LPXO, 2,   0,   0, NOMINAL),
+static struct clk_freq_tbl clk_tbl_mi2s[] = {
+	F_MND16(12288000, LPXO, 2,   0,   0, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_midi[] = {
-	F_MND8(98304000, 19, 12, SRC_PLL3, 3,  2,  5, NOMINAL),
+static struct clk_freq_tbl clk_tbl_midi[] = {
+	F_MND8(98304000, 19, 12, PLL3, 3,  2,  5, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_sdac[] = {
-	F_MND16( 256000, SRC_LPXO, 4,   1,    24, NOMINAL),
-	F_MND16( 352800, SRC_LPXO, 1, 147, 10240, NOMINAL),
-	F_MND16( 384000, SRC_LPXO, 4,   1,    16, NOMINAL),
-	F_MND16( 512000, SRC_LPXO, 4,   1,    12, NOMINAL),
-	F_MND16( 705600, SRC_LPXO, 1, 147,  5120, NOMINAL),
-	F_MND16( 768000, SRC_LPXO, 4,   1,     8, NOMINAL),
-	F_MND16(1024000, SRC_LPXO, 4,   1,     6, NOMINAL),
-	F_MND16(1411200, SRC_LPXO, 1, 147,  2560, NOMINAL),
-	F_MND16(1536000, SRC_LPXO, 4,   1,     4, NOMINAL),
+static struct clk_freq_tbl clk_tbl_sdac[] = {
+	F_MND16( 256000, LPXO, 4,   1,    24, NOMINAL),
+	F_MND16( 352800, LPXO, 1, 147, 10240, NOMINAL),
+	F_MND16( 384000, LPXO, 4,   1,    16, NOMINAL),
+	F_MND16( 512000, LPXO, 4,   1,    12, NOMINAL),
+	F_MND16( 705600, LPXO, 1, 147,  5120, NOMINAL),
+	F_MND16( 768000, LPXO, 4,   1,     8, NOMINAL),
+	F_MND16(1024000, LPXO, 4,   1,     6, NOMINAL),
+	F_MND16(1411200, LPXO, 1, 147,  2560, NOMINAL),
+	F_MND16(1536000, LPXO, 4,   1,     4, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_tv[] = {
-	F_MND8(27000000, 23, 16, SRC_PLL4, 2,  2,  33, NOMINAL),
-	F_MND8(74250000, 23, 16, SRC_PLL4, 2,  1,   6, NOMINAL),
+static struct clk_freq_tbl clk_tbl_tv[] = {
+	F_MND8(27000000, 23, 16, PLL4, 2,  2,  33, NOMINAL),
+	F_MND8(74250000, 23, 16, PLL4, 2,  1,   6, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_usb[] = {
-	F_MND8(60000000, 23, 16, SRC_PLL1, 2,  5,  32, NOMINAL),
+static struct clk_freq_tbl clk_tbl_usb[] = {
+	F_MND8(60000000, 23, 16, PLL1, 2,  5,  32, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_vfe_jpeg[] = {
-	F_MND16( 36864000, SRC_PLL3, 4,   1,   5, NOMINAL),
-	F_MND16( 46080000, SRC_PLL3, 4,   1,   4, NOMINAL),
-	F_MND16( 61440000, SRC_PLL3, 4,   1,   3, NOMINAL),
-	F_MND16( 73728000, SRC_PLL3, 2,   1,   5, NOMINAL),
-	F_MND16( 81920000, SRC_PLL3, 3,   1,   3, NOMINAL),
-	F_MND16( 92160000, SRC_PLL3, 4,   1,   2, NOMINAL),
-	F_MND16( 98304000, SRC_PLL3, 3,   2,   5, NOMINAL),
-	F_MND16(105326000, SRC_PLL3, 2,   2,   7, NOMINAL),
-	F_MND16(122880000, SRC_PLL3, 2,   1,   3, NOMINAL),
-	F_MND16(147456000, SRC_PLL3, 2,   2,   5, NOMINAL),
-	F_MND16(153600000, SRC_PLL1, 2,   2,   5, NOMINAL),
+static struct clk_freq_tbl clk_tbl_vfe_jpeg[] = {
+	F_MND16( 36864000, PLL3, 4,   1,   5, NOMINAL),
+	F_MND16( 46080000, PLL3, 4,   1,   4, NOMINAL),
+	F_MND16( 61440000, PLL3, 4,   1,   3, NOMINAL),
+	F_MND16( 73728000, PLL3, 2,   1,   5, NOMINAL),
+	F_MND16( 81920000, PLL3, 3,   1,   3, NOMINAL),
+	F_MND16( 92160000, PLL3, 4,   1,   2, NOMINAL),
+	F_MND16( 98304000, PLL3, 3,   2,   5, NOMINAL),
+	F_MND16(105326000, PLL3, 2,   2,   7, NOMINAL),
+	F_MND16(122880000, PLL3, 2,   1,   3, NOMINAL),
+	F_MND16(147456000, PLL3, 2,   2,   5, NOMINAL),
+	F_MND16(153600000, PLL1, 2,   2,   5, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_cam[] = {
-	F_MND16( 6000000, SRC_PLL1, 4,   1,  32, NOMINAL),
-	F_MND16( 8000000, SRC_PLL1, 4,   1,  24, NOMINAL),
-	F_MND16(12000000, SRC_PLL1, 4,   1,  16, NOMINAL),
-	F_MND16(16000000, SRC_PLL1, 4,   1,  12, NOMINAL),
-	F_MND16(19200000, SRC_PLL1, 4,   1,  10, NOMINAL),
-	F_MND16(24000000, SRC_PLL1, 4,   1,   8, NOMINAL),
-	F_MND16(32000000, SRC_PLL1, 4,   1,   6, NOMINAL),
-	F_MND16(48000000, SRC_PLL1, 4,   1,   4, NOMINAL),
-	F_MND16(64000000, SRC_PLL1, 4,   1,   3, NOMINAL),
+static struct clk_freq_tbl clk_tbl_cam[] = {
+	F_MND16( 6000000, PLL1, 4,   1,  32, NOMINAL),
+	F_MND16( 8000000, PLL1, 4,   1,  24, NOMINAL),
+	F_MND16(12000000, PLL1, 4,   1,  16, NOMINAL),
+	F_MND16(16000000, PLL1, 4,   1,  12, NOMINAL),
+	F_MND16(19200000, PLL1, 4,   1,  10, NOMINAL),
+	F_MND16(24000000, PLL1, 4,   1,   8, NOMINAL),
+	F_MND16(32000000, PLL1, 4,   1,   6, NOMINAL),
+	F_MND16(48000000, PLL1, 4,   1,   4, NOMINAL),
+	F_MND16(64000000, PLL1, 4,   1,   3, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_vpe[] = {
-	F_MND8( 24576000, 22, 15, SRC_LPXO, 1,   0,   0, NOMINAL),
-	F_MND8( 30720000, 22, 15, SRC_PLL3, 4,   1,   6, NOMINAL),
-	F_MND8( 61440000, 22, 15, SRC_PLL3, 4,   1,   3, NOMINAL),
-	F_MND8( 81920000, 22, 15, SRC_PLL3, 3,   1,   3, NOMINAL),
-	F_MND8(122880000, 22, 15, SRC_PLL3, 3,   1,   2, NOMINAL),
-	F_MND8(147456000, 22, 15, SRC_PLL3, 1,   1,   5, NOMINAL),
-	F_MND8(153600000, 22, 15, SRC_PLL1, 1,   1,   5, NOMINAL),
+static struct clk_freq_tbl clk_tbl_vpe[] = {
+	F_MND8( 24576000, 22, 15, LPXO, 1,   0,   0, NOMINAL),
+	F_MND8( 30720000, 22, 15, PLL3, 4,   1,   6, NOMINAL),
+	F_MND8( 61440000, 22, 15, PLL3, 4,   1,   3, NOMINAL),
+	F_MND8( 81920000, 22, 15, PLL3, 3,   1,   3, NOMINAL),
+	F_MND8(122880000, 22, 15, PLL3, 3,   1,   2, NOMINAL),
+	F_MND8(147456000, 22, 15, PLL3, 1,   1,   5, NOMINAL),
+	F_MND8(153600000, 22, 15, PLL1, 1,   1,   5, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_mfc[] = {
-	F_MND8( 24576000, 24, 17, SRC_LPXO, 1,   0,   0, NOMINAL),
-	F_MND8( 30720000, 24, 17, SRC_PLL3, 4,   1,   6, NOMINAL),
-	F_MND8( 61440000, 24, 17, SRC_PLL3, 4,   1,   3, NOMINAL),
-	F_MND8( 81920000, 24, 17, SRC_PLL3, 3,   1,   3, NOMINAL),
-	F_MND8(122880000, 24, 17, SRC_PLL3, 3,   1,   2, NOMINAL),
-	F_MND8(147456000, 24, 17, SRC_PLL3, 1,   1,   5, NOMINAL),
-	F_MND8(153600000, 24, 17, SRC_PLL1, 1,   1,   5, NOMINAL),
-	F_MND8(170667000, 24, 17, SRC_PLL1, 1,   2,   9, NOMINAL),
+static struct clk_freq_tbl clk_tbl_mfc[] = {
+	F_MND8( 24576000, 24, 17, LPXO, 1,   0,   0, NOMINAL),
+	F_MND8( 30720000, 24, 17, PLL3, 4,   1,   6, NOMINAL),
+	F_MND8( 61440000, 24, 17, PLL3, 4,   1,   3, NOMINAL),
+	F_MND8( 81920000, 24, 17, PLL3, 3,   1,   3, NOMINAL),
+	F_MND8(122880000, 24, 17, PLL3, 3,   1,   2, NOMINAL),
+	F_MND8(147456000, 24, 17, PLL3, 1,   1,   5, NOMINAL),
+	F_MND8(153600000, 24, 17, PLL1, 1,   1,   5, NOMINAL),
+	F_MND8(170667000, 24, 17, PLL1, 1,   2,   9, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_spi[] = {
-	F_MND8( 9963243, 19, 12, SRC_PLL3, 4,   7,   129, NOMINAL),
-	F_MND8(26331429, 19, 12, SRC_PLL3, 4,  34,   241, NOMINAL),
+static struct clk_freq_tbl clk_tbl_spi[] = {
+	F_MND8( 9963243, 19, 12, PLL3, 4,   7,   129, NOMINAL),
+	F_MND8(26331429, 19, 12, PLL3, 4,  34,   241, NOMINAL),
 	F_END,
 };
 
-static const struct clk_freq_tbl clk_tbl_lpa_codec[] = {
-	F_RAW(1, SRC_NONE, 0,  0,  0, MSMC1_END), /* src = MI2S_CODEC_RX */
-	F_RAW(2, SRC_NONE, 0,  1,  0, MSMC1_END), /* src = ECODEC_CIF */
-	F_RAW(3, SRC_NONE, 0,  2,  0, MSMC1_END), /* src = MI2S */
-	F_RAW(4, SRC_NONE, 0,  3,  0, MSMC1_END), /* src = SDAC */
+static struct clk_freq_tbl clk_tbl_lpa_codec[] = {
+	F_RAW(1, SRC_NONE, 0, 0, 0, 0, LOW, NULL), /* src = MI2S_CODEC_RX */
+	F_RAW(2, SRC_NONE, 0, 1, 0, 0, LOW, NULL), /* src = ECODEC_CIF */
+	F_RAW(3, SRC_NONE, 0, 2, 0, 0, LOW, NULL), /* src = MI2S */
+	F_RAW(4, SRC_NONE, 0, 3, 0, 0, LOW, NULL), /* src = SDAC */
 	F_END,
 };
 
-static struct clk_freq_tbl dummy_freq = F_END;
-
-#define MND	1 /* Integer predivider and fractional MN:D divider. */
-#define BASIC	2 /* Integer divider. */
-#define NORATE	3 /* Just on/off. */
-
-#define C(x) L_7X30_##x##_CLK
-
-#define CLK_LOCAL(id, t, md, ns, f_msk, br, root, tbl, \
-			par, chld_lst, h, hm, tv) \
-	[C(id)] = { \
-	.type = t, \
-	.md_reg = md, \
-	.ns_reg = ns, \
-	.freq_mask = f_msk, \
-	.br_en_mask = br, \
-	.root_en_mask = root, \
-	.parent = C(par), \
-	.children = chld_lst, \
-	.freq_tbl = tbl, \
-	.current_freq = &dummy_freq, \
-	.halt_reg = h, \
-	.halt_mask = hm, \
-	.test_vector = tv, \
-	}
-
-#define CLK_BASIC(id, ns, br, root, tbl, par, h, hm, tv) \
-		CLK_LOCAL(id, BASIC, 0, ns, F_MASK_BASIC, br, root, tbl, \
-							par, NULL, h, hm, tv)
-#define CLK_MND8_P(id, ns, m, l, br, root, tbl, par, chld_lst, h, hm, tv) \
-		CLK_LOCAL(id, MND, (ns-4), ns, F_MASK_MND8(m, l), br, root, \
-						tbl, par, chld_lst, h, hm, tv)
-#define CLK_MND8(id, ns, m, l, br, root, tbl, chld_lst, h, hm, tv) \
-		CLK_MND8_P(id, ns, m, l, br, root, tbl, NONE, chld_lst, \
-								h, hm, tv)
-#define CLK_MND16(id, ns, br, root, tbl, par, chld_lst, h, hm, tv) \
-		CLK_LOCAL(id, MND, (ns-4), ns, F_MASK_MND16, br, root, tbl, \
-						par, chld_lst, h, hm, tv)
-#define CLK_1RATE(id, ns, br, root, tbl, h, hm, tv) \
-		CLK_LOCAL(id, BASIC, 0, ns, 0, br, root, tbl, NONE, NULL, \
-								h, hm, tv)
-#define CLK_SLAVE(id, ns, br, par, h, hm, tv) \
-		CLK_LOCAL(id, NORATE, 0, ns, 0, br, 0, NULL, par, NULL, \
-								h, hm, tv)
-#define CLK_NORATE(id, ns, br, root, h, hm, tv) \
-		CLK_LOCAL(id, NORATE, 0, ns, 0, br, root, NULL, NONE, NULL, \
-				h, hm, tv)
-#define CLK_GLBL(id, glbl, br, h, hm, tv) \
-		CLK_LOCAL(id, NORATE, 0, glbl, 0, br, 0, NULL, GLBL_ROOT, \
-				NULL, h, hm, tv)
-#define CLK_BRIDGE(id, glbl, br, par, h, hm, tv) \
-		CLK_LOCAL(id, NORATE, 0, glbl, 0, br, 0, NULL, par, NULL, \
-				h, hm, tv)
-
-static uint32_t *pll_status_addr[NUM_PLL] = {
-	[PLL_0] = PLL0_STATUS_BASE_REG,
-	[PLL_1] = PLL1_STATUS_BASE_REG,
-	[PLL_2] = PLL2_STATUS_BASE_REG,
-	[PLL_3] = PLL3_STATUS_BASE_REG,
-	[PLL_4] = PLL4_STATUS_BASE_REG,
-	[PLL_5] = PLL5_STATUS_BASE_REG,
-	[PLL_6] = PLL6_STATUS_BASE_REG,
-};
-
-static uint32_t pll_count[NUM_PLL];
-
-static uint32_t chld_grp_3d_src[] =	{C(IMEM), C(GRP_3D), C(NONE)};
-static uint32_t chld_mdp_lcdc_p[] =	{C(MDP_LCDC_PAD_PCLK), C(NONE)};
-static uint32_t chld_mfc[] =		{C(MFC_DIV2), C(NONE)};
-static uint32_t chld_mi2s_codec_rx[] =	{C(MI2S_CODEC_RX_S), C(NONE)};
-static uint32_t chld_mi2s_codec_tx[] =	{C(MI2S_CODEC_TX_S), C(NONE)};
-static uint32_t chld_mi2s[] =		{C(MI2S_S), C(NONE)};
-static uint32_t chld_sdac[] =		{C(SDAC_M), C(NONE)};
-static uint32_t chld_tv[] =		{C(TV_DAC), C(TV_ENC), C(TSIF_REF),
-					 C(HDMI), C(NONE)};
-static uint32_t chld_usb_src[] =	{C(USB_HS), C(USB_HS_CORE),
+/*
+ * Clock children lists
+ */
+static const uint32_t chld_grp_3d_src[] =	{C(IMEM), C(GRP_3D), C(NONE)};
+static const uint32_t chld_mdp_lcdc_p[] =	{C(MDP_LCDC_PAD_PCLK), C(NONE)};
+static const uint32_t chld_mfc[] =		{C(MFC_DIV2), C(NONE)};
+static const uint32_t chld_mi2s_codec_rx[] =	{C(MI2S_CODEC_RX_S), C(NONE)};
+static const uint32_t chld_mi2s_codec_tx[] =	{C(MI2S_CODEC_TX_S), C(NONE)};
+static const uint32_t chld_mi2s[] =		{C(MI2S_S), C(NONE)};
+static const uint32_t chld_sdac[] =		{C(SDAC_M), C(NONE)};
+static const uint32_t chld_tv[] =		{C(TV_DAC), C(TV_ENC), C(HDMI),
+						 C(TSIF_REF), C(NONE)};
+static const uint32_t chld_usb_src[] =	{C(USB_HS), C(USB_HS_CORE),
 					 C(USB_HS2), C(USB_HS2_CORE),
 					 C(USB_HS3), C(USB_HS3_CORE),
 					 C(NONE)};
-static uint32_t chld_vfe[] =		{C(VFE_MDC), C(VFE_CAMIF), C(CSI0_VFE),
+static uint32_t const chld_vfe[] =	{C(VFE_MDC), C(VFE_CAMIF), C(CSI0_VFE),
 					 C(NONE)};
 
-static struct clk_local clk_local_tbl[] = {
+/*
+ * Clock declaration macros
+ */
+#define CLK_BASIC(id, ns, br, root, tbl, par, h_r, h_c, h_b, tv) \
+		CLK(id, BASIC, ns, ns, NULL, NULL, 0, h_r, h_c, \
+			h_b, br, root, F_MASK_BASIC, 0, set_rate_basic, tbl, \
+			NULL, par, NULL, tv)
+#define CLK_MND8_P(id, ns, m, l, br, root, tbl, par, chld_lst, \
+						h_r, h_c, h_b, tv) \
+		CLK(id, MND, ns, ns, (ns-4), NULL, 0, h_r, h_c, \
+			h_b, br, root, F_MASK_MND8(m, l), 0, set_rate_mnd, \
+			tbl, NULL, par, chld_lst, tv)
+#define CLK_MND8(id, ns, m, l, br, root, tbl, chld_lst, h_r, h_c, h_b, tv) \
+		CLK_MND8_P(id, ns, m, l, br, root, tbl, NONE, chld_lst, \
+							h_r, h_c, h_b, tv)
+#define CLK_MND16(id, ns, br, root, tbl, par, chld_lst, h_r, h_c, h_b, tv) \
+		CLK(id, MND, ns, ns, (ns-4), NULL, 0, h_r, h_c, \
+			h_b, br, root, F_MASK_MND16, 0, set_rate_mnd, tbl, \
+			NULL, par, chld_lst, tv)
+#define CLK_1RATE(id, ns, br, root, tbl, h_r, h_c, h_b, tv) \
+		CLK(id, BASIC, NULL, ns, NULL, NULL, 0, h_r, h_c, \
+			h_b, br, root, 0, 0, set_rate_nop, tbl, \
+			NULL, NONE, NULL, tv)
+#define CLK_SLAVE(id, ns, br, par, h_r, h_c, h_b, tv) \
+		CLK(id, NORATE, NULL, ns, NULL, NULL, 0, h_r, h_c, \
+			h_b, br, 0, 0, 0, NULL, NULL, NULL, par, NULL, tv)
+#define CLK_NORATE(id, ns, br, root, h_r, h_c, h_b, tv) \
+		CLK(id, NORATE, NULL, ns, NULL, NULL, 0, h_r, h_c, \
+			h_b, br, root, 0, 0, NULL, NULL, NULL, NONE, NULL, tv)
+#define CLK_GLBL(id, glbl, br, h_r, h_c, h_b, tv) \
+		CLK(id, NORATE, NULL, glbl, NULL, NULL, 0, h_r, h_c, \
+			h_b, br, 0, 0, 0, NULL, NULL, NULL, NONE, NULL, tv)
+#define CLK_BRIDGE(id, glbl, br, par, h_r, h_c, h_b, tv) \
+		CLK(id, NORATE, NULL, glbl, NULL, NULL, 0, h_r, h_c, \
+			h_b, br, 0, 0, 0, NULL, NULL, NULL, par, NULL, tv)
+
+/*
+ * Clock table
+ */
+struct clk_local soc_clk_local_tbl[] = {
 	CLK_NORATE(MDC,	MDC_NS_REG, B(9), B(11),
-			CLK_HALT_STATEA_REG, 10, 0x4D56),
+			CLK_HALT_STATEA_REG, HALT, 10, 0x4D56),
 	CLK_NORATE(LPA_CORE, LPA_NS_REG, B(5), 0,
-			CLK_HALT_STATEC_REG, 5, 0x0E),
+			CLK_HALT_STATEC_REG, HALT, 5, 0x0E),
 
 	CLK_1RATE(I2C, I2C_NS_REG, B(9), B(11), clk_tbl_tcxo,
-			CLK_HALT_STATEA_REG, 15, 0x4D4D),
+			CLK_HALT_STATEA_REG, HALT, 15, 0x4D4D),
 	CLK_1RATE(I2C_2, I2C_2_NS_REG, B(0), B(2), clk_tbl_tcxo,
-			CLK_HALT_STATEC_REG, 2, 0x0B),
+			CLK_HALT_STATEC_REG, HALT, 2, 0x0B),
 	CLK_1RATE(QUP_I2C, QUP_I2C_NS_REG, B(0), B(2), clk_tbl_tcxo,
-			CLK_HALT_STATEB_REG, 31, 0x1C),
+			CLK_HALT_STATEB_REG, HALT, 31, 0x1C),
 	CLK_1RATE(UART1, UART_NS_REG, B(5), B(4), clk_tbl_tcxo,
-			CLK_HALT_STATEB_REG, 7, 0x4D6F),
+			CLK_HALT_STATEB_REG, HALT, 7, 0x4D6F),
 	CLK_1RATE(UART2, UART2_NS_REG, B(5), B(4), clk_tbl_tcxo,
-			CLK_HALT_STATEB_REG, 5, 0x4D71),
+			CLK_HALT_STATEB_REG, HALT, 5, 0x4D71),
 
 	CLK_BASIC(EMDH,	EMDH_NS_REG, 0, B(11), clk_tbl_mdh, AXI_LI_ADSP_A,
-			NULL, 0, 0x4F00),
+			NULL, DELAY, 0, 0x4F00),
 	CLK_BASIC(PMDH,	PMDH_NS_REG, 0, B(11), clk_tbl_mdh, AXI_LI_ADSP_A,
-			NULL, 0, 0x5500),
+			NULL, DELAY, 0, 0x5500),
 	CLK_BASIC(MDP,	MDP_NS_REG, B(9), B(11), clk_tbl_mdp_core, AXI_MDP,
-			CLK_HALT_STATEB_REG, 16, 0x5400),
+			CLK_HALT_STATEB_REG, HALT, 16, 0x5400),
 
 	CLK_MND8_P(VPE, VPE_NS_REG, 22, 15, B(9), B(11), clk_tbl_vpe,
-			AXI_VPE, NULL, CLK_HALT_STATEC_REG, 10, 0x6C00),
+			AXI_VPE, NULL, CLK_HALT_STATEC_REG, HALT, 10, 0x6C00),
 	CLK_MND8_P(MFC, MFC_NS_REG, 24, 17, B(9), B(11), clk_tbl_mfc,
 			AXI_MFC, chld_mfc, CLK_HALT_STATEC_REG,
-			12, 0x38),
+			HALT, 12, 0x38),
 	CLK_SLAVE(MFC_DIV2, MFC_NS_REG, B(15), MFC, CLK_HALT_STATEC_REG,
-			11, 0x1F),
+			HALT, 11, 0x1F),
 
 	CLK_MND8(SDC1,	SDCn_NS_REG(1), 19, 12, B(9), B(11), clk_tbl_sdc1_3,
-			NULL, CLK_HALT_STATEA_REG, 1, 0x4D62),
+			NULL, CLK_HALT_STATEA_REG, HALT, 1, 0x4D62),
 	CLK_MND8(SDC2,	SDCn_NS_REG(2), 20, 13, B(9), B(11), clk_tbl_sdc2_4,
-			NULL, CLK_HALT_STATEA_REG, 0, 0x4D64),
+			NULL, CLK_HALT_STATEA_REG, HALT, 0, 0x4D64),
 	CLK_MND8(SDC3,	SDCn_NS_REG(3), 19, 12, B(9), B(11), clk_tbl_sdc1_3,
-			NULL, CLK_HALT_STATEB_REG, 24, 0x4D7A),
+			NULL, CLK_HALT_STATEB_REG, HALT, 24, 0x4D7A),
 	CLK_MND8(SDC4,	SDCn_NS_REG(4), 20, 13, B(9), B(11), clk_tbl_sdc2_4,
-			NULL, CLK_HALT_STATEB_REG, 25, 0x4D7C),
+			NULL, CLK_HALT_STATEB_REG, HALT, 25, 0x4D7C),
 	CLK_MND8(SPI,	SPI_NS_REG, 19, 12, B(9), B(11), clk_tbl_spi, NULL,
-			CLK_HALT_STATEC_REG, 0, 0x09),
+			CLK_HALT_STATEC_REG, HALT, 0, 0x09),
 	CLK_MND8(MIDI,	MIDI_NS_REG, 19, 12, B(9), B(11), clk_tbl_midi,	NULL,
-			CLK_HALT_STATEC_REG, 1, 0x0A),
+			CLK_HALT_STATEC_REG, HALT, 1, 0x0A),
 	CLK_MND8_P(USB_HS_SRC, USBH_NS_REG, 23, 16, 0, B(11), clk_tbl_usb,
-			AXI_LI_ADSP_A,	chld_usb_src, NULL,  0, 0),
+			AXI_LI_ADSP_A,	chld_usb_src, NULL, NOCHECK, 0, 0),
 	CLK_SLAVE(USB_HS,	USBH_NS_REG,	B(9),	USB_HS_SRC,
-			CLK_HALT_STATEB_REG, 26, 0x4D7F),
+			CLK_HALT_STATEB_REG, HALT, 26, 0x4D7F),
 	CLK_SLAVE(USB_HS_CORE,	USBH_NS_REG,	B(13),	USB_HS_SRC,
-			CLK_HALT_STATEA_REG, 27, 0x14),
+			CLK_HALT_STATEA_REG, HALT, 27, 0x14),
 	CLK_SLAVE(USB_HS2,	USBH2_NS_REG,	B(9),	USB_HS_SRC,
-			CLK_HALT_STATEB_REG, 3, 0x4D73),
+			CLK_HALT_STATEB_REG, HALT, 3, 0x4D73),
 	CLK_SLAVE(USB_HS2_CORE,	USBH2_NS_REG,	B(4),	USB_HS_SRC,
-			CLK_HALT_STATEA_REG, 28, 0x15),
+			CLK_HALT_STATEA_REG, HALT, 28, 0x15),
 	CLK_SLAVE(USB_HS3,	USBH3_NS_REG,	B(9),	USB_HS_SRC,
-			CLK_HALT_STATEB_REG, 2, 0x4D74),
+			CLK_HALT_STATEB_REG, HALT, 2, 0x4D74),
 	CLK_SLAVE(USB_HS3_CORE,	USBH3_NS_REG,	B(4),	USB_HS_SRC,
-			CLK_HALT_STATEA_REG, 29, 0x16),
+			CLK_HALT_STATEA_REG, HALT, 29, 0x16),
 	CLK_MND8(TV,	TV_NS_REG, 23, 16, 0, B(11), clk_tbl_tv, chld_tv,
-			NULL, 0, 0),
+			NULL, NOCHECK, 0, 0),
 	CLK_SLAVE(HDMI,	HDMI_NS_REG, B(9),  TV,
-			CLK_HALT_STATEC_REG, 7, 0x13),
+			CLK_HALT_STATEC_REG, HALT, 7, 0x13),
 	CLK_SLAVE(TV_DAC, TV_NS_REG, B(12), TV,
-			CLK_HALT_STATEB_REG, 27, 0x4D6C),
+			CLK_HALT_STATEB_REG, HALT, 27, 0x4D6C),
 	CLK_SLAVE(TV_ENC, TV_NS_REG, B(9),  TV,
-			CLK_HALT_STATEB_REG, 10, 0x4D6B),
+			CLK_HALT_STATEB_REG, HALT, 10, 0x4D6B),
 	/* Hacking root & branch into one param. */
 	CLK_SLAVE(TSIF_REF, TSIF_NS_REG, B(9)|B(11), TV,
-			CLK_HALT_STATEB_REG, 11, 0x4D6A),
+			CLK_HALT_STATEB_REG, HALT, 11, 0x4D6A),
 
 	CLK_MND16(UART1DM, UART1DM_NS_REG, B(9), B(11), clk_tbl_uartdm, NONE,
-			NULL, CLK_HALT_STATEB_REG, 6, 0x4D70),
+			NULL, CLK_HALT_STATEB_REG, HALT, 6, 0x4D70),
 	CLK_MND16(UART2DM, UART2DM_NS_REG, B(9), B(11), clk_tbl_uartdm, NONE,
-			NULL, CLK_HALT_STATEB_REG, 23, 0x4D7D),
+			NULL, CLK_HALT_STATEB_REG, HALT, 23, 0x4D7D),
 	CLK_MND16(JPEG, JPEG_NS_REG, B(9), B(11), clk_tbl_vfe_jpeg, AXI_LI_JPEG,
-			NULL, CLK_HALT_STATEB_REG, 1, 0x6000),
+			NULL, CLK_HALT_STATEB_REG, HALT, 1, 0x6000),
 	CLK_MND16(CAM_M, CAM_NS_REG, 0, B(9), clk_tbl_cam, NONE, NULL,
-			NULL, 0, 0x4D44),
+			NULL, DELAY, 0, 0x4D44),
 	CLK_MND16(VFE, CAM_VFE_NS_REG, B(9), B(13), clk_tbl_vfe_jpeg,
 			AXI_LI_VFE, chld_vfe, CLK_HALT_STATEB_REG,
-			0, 0x4D76),
+			HALT, 0, 0x4D76),
 	CLK_SLAVE(VFE_MDC, CAM_VFE_NS_REG, B(11), VFE, CLK_HALT_STATEA_REG,
-			9, 0x4D57),
+			HALT, 9, 0x4D57),
 	CLK_SLAVE(VFE_CAMIF, CAM_VFE_NS_REG, B(15), VFE, CLK_HALT_STATEC_REG,
-			13, 0x7000),
+			HALT, 13, 0x7000),
 	CLK_SLAVE(CSI0_VFE, CSI_NS_REG, B(15), VFE, CLK_HALT_STATEC_REG,
-			16, 0),
+			HALT, 16, 0),
 
 	CLK_MND16(SDAC, SDAC_NS_REG, B(9), B(11), clk_tbl_sdac,
-			NONE, chld_sdac, CLK_HALT_STATEA_REG, 2, 0x4D60),
+			NONE, chld_sdac, CLK_HALT_STATEA_REG, HALT, 2, 0x4D60),
 	CLK_SLAVE(SDAC_M, SDAC_NS_REG, B(12), SDAC, CLK_HALT_STATEB_REG,
-			17, 0x4D66),
+			HALT, 17, 0x4D66),
 
 	CLK_MND16(MDP_LCDC_PCLK, MDP_LCDC_NS_REG, B(9), B(11),
 			clk_tbl_mdp_lcdc, NONE, chld_mdp_lcdc_p,
-			CLK_HALT_STATEB_REG, 28, 0x4200),
+			CLK_HALT_STATEB_REG, HALT, 28, 0x4200),
 	CLK_SLAVE(MDP_LCDC_PAD_PCLK, MDP_LCDC_NS_REG, B(12), MDP_LCDC_PCLK,
-			CLK_HALT_STATEB_REG, 29, 0x4100),
+			CLK_HALT_STATEB_REG, HALT, 29, 0x4100),
 	CLK_1RATE(MDP_VSYNC, MDP_VSYNC_REG, B(0), 0, clk_tbl_mdp_vsync,
-			CLK_HALT_STATEB_REG, 30, 0x4D53),
+			CLK_HALT_STATEB_REG, HALT, 30, 0x4D53),
 
 	CLK_MND16(MI2S_CODEC_RX_M, MI2S_RX_NS_REG, B(12), B(11),
 				clk_tbl_mi2s_codec, NONE, chld_mi2s_codec_rx,
-				CLK_HALT_STATEA_REG, 12, 0x4D4E),
+				CLK_HALT_STATEA_REG, HALT, 12, 0x4D4E),
 	CLK_SLAVE(MI2S_CODEC_RX_S, MI2S_RX_NS_REG, B(9), MI2S_CODEC_RX_M,
-			CLK_HALT_STATEA_REG, 13, 0x4D4F),
+			CLK_HALT_STATEA_REG, HALT, 13, 0x4D4F),
 
 	CLK_MND16(MI2S_CODEC_TX_M, MI2S_TX_NS_REG, B(12), B(11),
 				clk_tbl_mi2s_codec, NONE, chld_mi2s_codec_tx,
-				CLK_HALT_STATEC_REG, 8, 0x4D50),
+				CLK_HALT_STATEC_REG, HALT, 8, 0x4D50),
 	CLK_SLAVE(MI2S_CODEC_TX_S, MI2S_TX_NS_REG, B(9), MI2S_CODEC_TX_M,
-			CLK_HALT_STATEA_REG, 11, 0x17),
+			CLK_HALT_STATEA_REG, HALT, 11, 0x17),
 
 	CLK_MND16(MI2S_M, MI2S_NS_REG, B(12), B(11),
 			clk_tbl_mi2s, NONE, chld_mi2s, CLK_HALT_STATEC_REG,
-			4, 0x0D),
+			HALT, 4, 0x0D),
 	CLK_SLAVE(MI2S_S, MI2S_NS_REG, B(9), MI2S_M, CLK_HALT_STATEC_REG,
-			3, 0),
-
-	CLK_LOCAL(GRP_2D, BASIC, 0, GRP_2D_NS_REG, F_MASK_BASIC | (7 << 12),
-			B(7), B(11), clk_tbl_grp, AXI_GRP_2D, NULL,
-			CLK_HALT_STATEA_REG, 31, 0x5C00),
-	CLK_LOCAL(GRP_3D_SRC, BASIC, 0, GRP_NS_REG, F_MASK_BASIC | (7 << 12),
-			0, B(11), clk_tbl_grp, AXI_LI_GRP, chld_grp_3d_src,
-			0, 0, 0),
+			HALT, 3, 0),
+
+	CLK(GRP_2D, BASIC, GRP_2D_NS_REG, GRP_2D_NS_REG, NULL, NULL, 0,
+			CLK_HALT_STATEA_REG, HALT, 31, B(7), B(11),
+			F_MASK_BASIC | (7 << 12), 0, set_rate_basic,
+			clk_tbl_grp, NULL, AXI_GRP_2D, NULL, 0x5C00),
+	CLK(GRP_3D_SRC, BASIC, GRP_NS_REG, GRP_NS_REG, NULL, NULL, 0,
+			NULL, NOCHECK, 0, 0, B(11), F_MASK_BASIC | (7 << 12),
+			0, set_rate_basic, clk_tbl_grp, NULL, AXI_LI_GRP,
+			chld_grp_3d_src, 0),
 	CLK_SLAVE(GRP_3D, GRP_NS_REG, B(7), GRP_3D_SRC, CLK_HALT_STATEB_REG,
-			18, 0x5E00),
+			HALT, 18, 0x5E00),
 	CLK_SLAVE(IMEM, GRP_NS_REG, B(9), GRP_3D_SRC, CLK_HALT_STATEB_REG,
-			19, 0x5F00),
-	CLK_LOCAL(LPA_CODEC, BASIC, 0, LPA_NS_REG, BM(1, 0), B(9), 0,
-			clk_tbl_lpa_codec, NONE, NULL, CLK_HALT_STATEC_REG,
-			6, 0x0F),
+			HALT, 19, 0x5F00),
+	CLK(LPA_CODEC, BASIC, LPA_NS_REG, LPA_NS_REG, NULL, NULL, 0,
+			CLK_HALT_STATEC_REG, HALT, 6, B(9), 0, BM(1, 0), 0,
+			set_rate_basic,	clk_tbl_lpa_codec, NULL, NONE, NULL,
+			0x0F),
 
 	CLK_MND8(CSI0, CSI_NS_REG, 24, 17, B(9), B(11), clk_tbl_csi, NULL,
-			CLK_HALT_STATEC_REG, 17, 0x5F00),
+			CLK_HALT_STATEC_REG, HALT, 17, 0x5F00),
 
 	/* For global clocks to be on we must have GLBL_ROOT_ENA set */
 	CLK_1RATE(GLBL_ROOT, GLBL_CLK_ENA_SC_REG, 0, B(29), clk_tbl_axi,
-			NULL, 0, 0),
+			NULL, NOCHECK, 0, 0),
 
 	/* Peripheral bus clocks. */
 	CLK_BRIDGE(ADM,		GLBL_CLK_ENA_SC_REG,	B(5), AXI_LI_APPS,
-				GLBL_CLK_STATE_REG,	5, 0x4000),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 5, 0x4000),
 	CLK_GLBL(ADM_P,	GLBL_CLK_ENA_2_SC_REG,  B(15),
-				GLBL_CLK_STATE_2_REG,   15, 0x11),
+				GLBL_CLK_STATE_2_REG,   HALT_VOTED, 15, 0x11),
 	CLK_GLBL(CE,		GLBL_CLK_ENA_SC_REG,	B(6),
-				GLBL_CLK_STATE_REG,	6, 0x4D43),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 6, 0x4D43),
 	CLK_GLBL(CAMIF_PAD_P,	GLBL_CLK_ENA_SC_REG,	B(9),
-				GLBL_CLK_STATE_REG,	9, 0x1A),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 9, 0x1A),
 	CLK_GLBL(CSI0_P,	GLBL_CLK_ENA_SC_REG,	B(30),
-				GLBL_CLK_STATE_REG,	30, 0),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 30, 0),
 	CLK_GLBL(EMDH_P,	GLBL_CLK_ENA_2_SC_REG,	B(3),
-				GLBL_CLK_STATE_2_REG,	3, 0x03),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 3, 0x03),
 	CLK_GLBL(GRP_2D_P,	GLBL_CLK_ENA_SC_REG,	B(24),
-				GLBL_CLK_STATE_REG,	24, 0x4D4C),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 24, 0x4D4C),
 	CLK_GLBL(GRP_3D_P,	GLBL_CLK_ENA_2_SC_REG,	B(17),
-				GLBL_CLK_STATE_2_REG,	17, 0x4D67),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 17, 0x4D67),
 	CLK_GLBL(JPEG_P,	GLBL_CLK_ENA_2_SC_REG,	B(24),
-				GLBL_CLK_STATE_2_REG,	24, 0x4D5E),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 24, 0x4D5E),
 	CLK_GLBL(LPA_P,		GLBL_CLK_ENA_2_SC_REG,	B(7),
-				GLBL_CLK_STATE_2_REG,	7, 0x07),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 7, 0x07),
 	CLK_GLBL(MDP_P,		GLBL_CLK_ENA_2_SC_REG,	B(6),
-				GLBL_CLK_STATE_2_REG,	6, 0x06),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 6, 0x06),
 	CLK_GLBL(MFC_P,		GLBL_CLK_ENA_2_SC_REG,	B(26),
-				GLBL_CLK_STATE_2_REG,	26, 0x4D75),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 26, 0x4D75),
 	CLK_GLBL(PMDH_P,	GLBL_CLK_ENA_2_SC_REG,	B(4),
-				GLBL_CLK_STATE_2_REG,	4, 0x04),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 4, 0x04),
 	CLK_GLBL(ROTATOR_IMEM,	GLBL_CLK_ENA_2_SC_REG,	B(23),
-				GLBL_CLK_STATE_2_REG,	23, 0x6600),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 23, 0x6600),
 	CLK_GLBL(ROTATOR_P,	GLBL_CLK_ENA_2_SC_REG,	B(25),
-				GLBL_CLK_STATE_2_REG,	25, 0x4D6D),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 25, 0x4D6D),
 	CLK_GLBL(SDC1_P,	GLBL_CLK_ENA_SC_REG,	B(7),
-				GLBL_CLK_STATE_REG,	7, 0x4D61),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 7, 0x4D61),
 	CLK_GLBL(SDC2_P,	GLBL_CLK_ENA_SC_REG,	B(8),
-				GLBL_CLK_STATE_REG,	8, 0x4F63),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 8, 0x4F63),
 	CLK_GLBL(SDC3_P,	GLBL_CLK_ENA_SC_REG,	B(27),
-				GLBL_CLK_STATE_REG,	27, 0x4D79),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 27, 0x4D79),
 	CLK_GLBL(SDC4_P,	GLBL_CLK_ENA_SC_REG,	B(28),
-				GLBL_CLK_STATE_REG,	28, 0x4D7B),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 28, 0x4D7B),
 	CLK_GLBL(SPI_P,		GLBL_CLK_ENA_2_SC_REG,	B(10),
-				GLBL_CLK_STATE_2_REG,	10, 0x18),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 10, 0x18),
 	CLK_GLBL(TSIF_P,	GLBL_CLK_ENA_SC_REG,	B(18),
-				GLBL_CLK_STATE_REG,	18, 0x4D65),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 18, 0x4D65),
 	CLK_GLBL(UART1DM_P,	GLBL_CLK_ENA_SC_REG,	B(17),
-				GLBL_CLK_STATE_REG,	17, 0x4D5C),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 17, 0x4D5C),
 	CLK_GLBL(UART2DM_P,	GLBL_CLK_ENA_SC_REG,	B(26),
-				GLBL_CLK_STATE_REG,	26, 0x4D7E),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 26, 0x4D7E),
 	CLK_GLBL(USB_HS2_P,	GLBL_CLK_ENA_2_SC_REG,	B(8),
-				GLBL_CLK_STATE_2_REG,	8, 0x08),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 8, 0x08),
 	CLK_GLBL(USB_HS3_P,	GLBL_CLK_ENA_2_SC_REG,	B(9),
-				GLBL_CLK_STATE_2_REG,	9, 0x10),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 9, 0x10),
 	CLK_GLBL(USB_HS_P,	GLBL_CLK_ENA_SC_REG,	B(25),
-				GLBL_CLK_STATE_REG,	25, 0x4D58),
+				GLBL_CLK_STATE_REG,	HALT_VOTED, 25, 0x4D58),
 	CLK_GLBL(VFE_P,		GLBL_CLK_ENA_2_SC_REG,	B(27),
-				GLBL_CLK_STATE_2_REG,	27, 0x4D55),
+				GLBL_CLK_STATE_2_REG,	HALT_VOTED, 27, 0x4D55),
 
 	/* AXI bridge clocks. */
 	CLK_BRIDGE(AXI_LI_APPS,	GLBL_CLK_ENA_SC_REG,	B(2),	GLBL_ROOT,
-			GLBL_CLK_STATE_REG, 2, 0x4900),
+			GLBL_CLK_STATE_REG, HALT_VOTED, 2, 0x4900),
 	CLK_BRIDGE(AXI_LI_ADSP_A, GLBL_CLK_ENA_2_SC_REG, B(14), AXI_LI_APPS,
-			GLBL_CLK_STATE_2_REG, 14, 0x6400),
+			GLBL_CLK_STATE_2_REG, HALT_VOTED, 14, 0x6400),
 	CLK_BRIDGE(AXI_LI_JPEG,	GLBL_CLK_ENA_2_SC_REG,	B(19),	AXI_LI_APPS,
-			GLBL_CLK_STATE_2_REG, 19, 0x4E00),
+			GLBL_CLK_STATE_2_REG, HALT_VOTED, 19, 0x4E00),
 	CLK_BRIDGE(AXI_LI_VFE,	GLBL_CLK_ENA_SC_REG,	B(23),	AXI_LI_APPS,
-			GLBL_CLK_STATE_REG, 23, 0x5B00),
+			GLBL_CLK_STATE_REG, HALT_VOTED, 23, 0x5B00),
 	CLK_BRIDGE(AXI_MDP,	GLBL_CLK_ENA_2_SC_REG,	B(29),	AXI_LI_APPS,
-			GLBL_CLK_STATE_2_REG, 29, 0x6B00),
+			GLBL_CLK_STATE_2_REG, HALT_VOTED, 29, 0x6B00),
 
 	CLK_BRIDGE(AXI_IMEM,	GLBL_CLK_ENA_2_SC_REG,	B(18),	GLBL_ROOT,
-			GLBL_CLK_STATE_2_REG, 18, 0x4B00),
+			GLBL_CLK_STATE_2_REG, HALT_VOTED, 18, 0x4B00),
 
 	CLK_BRIDGE(AXI_LI_VG,	GLBL_CLK_ENA_SC_REG,	B(3),	GLBL_ROOT,
-			GLBL_CLK_STATE_REG, 3, 0x4700),
+			GLBL_CLK_STATE_REG, HALT_VOTED, 3, 0x4700),
 	CLK_BRIDGE(AXI_GRP_2D,	GLBL_CLK_ENA_SC_REG,	B(21),	AXI_LI_VG,
-			GLBL_CLK_STATE_REG, 21, 0x5900),
+			GLBL_CLK_STATE_REG, HALT_VOTED, 21, 0x5900),
 	CLK_BRIDGE(AXI_LI_GRP,	GLBL_CLK_ENA_SC_REG,	B(22),	AXI_LI_VG,
-			GLBL_CLK_STATE_REG, 22, 0x5A00),
+			GLBL_CLK_STATE_REG, HALT_VOTED, 22, 0x5A00),
 	CLK_BRIDGE(AXI_MFC,	GLBL_CLK_ENA_2_SC_REG,	B(20),	AXI_LI_VG,
-			GLBL_CLK_STATE_2_REG, 20, 0x6A00),
+			GLBL_CLK_STATE_2_REG, HALT_VOTED, 20, 0x6A00),
 	CLK_BRIDGE(AXI_ROTATOR,	GLBL_CLK_ENA_2_SC_REG,	B(22),	AXI_LI_VG,
-			GLBL_CLK_STATE_2_REG, 22, 0x4300),
+			GLBL_CLK_STATE_2_REG, HALT_VOTED, 22, 0x4300),
 	CLK_BRIDGE(AXI_VPE,	GLBL_CLK_ENA_2_SC_REG,	B(21),	AXI_LI_VG,
-			GLBL_CLK_STATE_2_REG, 21, 0x6700),
-};
-
-static DEFINE_SPINLOCK(clock_reg_lock);
-static DEFINE_SPINLOCK(pll_vote_lock);
-
-enum {
-	TCXO,
-	LPXO,
-	NUM_XO
+			GLBL_CLK_STATE_2_REG, HALT_VOTED, 21, 0x6700),
 };
-static unsigned xo_votes[NUM_XO]; /* Tracks the number of users for each XO */
-
-/* Map PLLs to which XO they use */
-static const unsigned pll_to_xo[] = {
-	[PLL_0] = TCXO,
-	[PLL_1] = TCXO,
-	[PLL_2] = TCXO,
-	[PLL_3] = LPXO,
-	[PLL_4] = LPXO,
-	[PLL_5] = TCXO,
-	[PLL_6] = TCXO,
-};
-
-static void vote_for_xo(unsigned xo)
-{
-	BUG_ON(xo >= NUM_XO);
-
-	if (!xo_votes[xo]) {
-		int enable = 1;
-		unsigned p_xo = xo;
-		msm_proc_comm(PCOM_CLKCTL_RPC_SRC_REQUEST, &p_xo, &enable);
-	}
-	xo_votes[xo]++;
-}
-
-static void unvote_for_xo(unsigned xo)
-{
-	BUG_ON(xo >= NUM_XO);
 
-	if (xo_votes[xo]) {
-		xo_votes[xo]--;
-	} else {
-		pr_warning("%s: Reference count mismatch!\n", __func__);
-		return;
-	}
-
-	if (xo_votes[xo] == 0) {
-		int enable = 0;
-		msm_proc_comm(PCOM_CLKCTL_RPC_SRC_REQUEST, &xo, &enable);
-	}
-}
-
-#define PLL_ACTIVE_MASK	B(16)
-void pll_enable(uint32_t pll)
-{
-	uint32_t reg_val;
-	unsigned long flags;
-
-	BUG_ON(pll >= NUM_PLL);
-
-	spin_lock_irqsave(&pll_vote_lock, flags);
-	if (!pll_count[pll]) {
-		vote_for_xo(pll_to_xo[pll]);
-		reg_val = readl(PLL_ENA_REG);
-		reg_val |= (1 << pll);
-		writel(reg_val, PLL_ENA_REG);
-	}
-	pll_count[pll]++;
-	spin_unlock_irqrestore(&pll_vote_lock, flags);
-
-	/* Wait until PLL is enabled. */
-	while ((readl(pll_status_addr[pll]) & PLL_ACTIVE_MASK) == 0)
-		cpu_relax();
-}
-
-void pll_disable(uint32_t pll)
-{
-	uint32_t reg_val;
-	unsigned long flags;
-
-	BUG_ON(pll >= NUM_PLL);
-
-	spin_lock_irqsave(&pll_vote_lock, flags);
-	if (pll_count[pll]) {
-		pll_count[pll]--;
-	} else {
-		pr_warning("Reference count mismatch in PLL disable!\n");
-		goto out;
-	}
-
-	if (pll_count[pll] == 0) {
-		reg_val = readl(PLL_ENA_REG);
-		reg_val &= ~(1 << pll);
-		writel(reg_val, PLL_ENA_REG);
-		unvote_for_xo(pll_to_xo[pll]);
-	}
-out:
-	spin_unlock_irqrestore(&pll_vote_lock, flags);
-}
-
-static void src_enable(uint32_t src)
-{
-	switch (src) {
-	case SRC_NONE:
-		/*
-		 * SRC_NONE is used as a placeholder for some freqencies that
-		 * don't have any direct PLL dependency. Instead they source
-		 * off an external/internal clock which takes care of any
-		 * PLL or XO dependency.
-		 */
-		break;
-	case SRC_TCXO:
-		vote_for_xo(TCXO);
-		break;
-	case SRC_AXI:
-	case SRC_LPXO:
-		/*
-		 * AXI could use LPXO or TCXO. Map it to LPXO to make sure
-		 * there is at least once XO available for the AXI (LPXO is
-		 * the lower powered one so just use that).
-		 */
-		vote_for_xo(LPXO);
-		break;
-	default:
-		pll_enable(src_pll_tbl[src]);
-		break;
-	}
-}
-
-static void src_disable(uint32_t src)
-{
-	switch (src) {
-	case SRC_NONE:
-		/*
-		 * SRC_NONE is used as a placeholder for some freqencies that
-		 * don't have any direct PLL dependency. Instead they source
-		 * off an external/internal clock which takes care of any
-		 * PLL or XO dependency.
-		 */
-		break;
-	case SRC_TCXO:
-		unvote_for_xo(TCXO);
-		break;
-	case SRC_AXI:
-	case SRC_LPXO:
-		/*
-		 * AXI could use LPXO or TCXO. Map it to LPXO to make sure
-		 * there is at least once XO available for the AXI (LPXO is
-		 * the lower powered one so just use that).
-		 */
-		unvote_for_xo(LPXO);
-		break;
-	default:
-		pll_disable(src_pll_tbl[src]);
-		break;
-	}
-}
-
-static unsigned msmc1_votes[MSMC1_END];
-static unsigned msmc1_level;
+/*
+ * SoC-specific functions required by clock-local driver
+ */
 
-static int update_msmc1(void)
+/* Update the sys_vdd voltage given a level. */
+int soc_update_sys_vdd(enum sys_vdd_level level)
 {
-	int err, target, mvolts;
-
-	if (msmc1_votes[HIGH])
-		target = 1200;
-	else if (msmc1_votes[NOMINAL])
-		target = 1100;
-	else
-		target = 1000;
-
-	if (target == msmc1_level)
-		return 0;
-
-	mvolts = target;
-	err = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_MSMC1, &mvolts, NULL);
-	if (err)
+	int rc, target_mv;
+	static const int mv[NUM_SYS_VDD_LEVELS] = {
+		[NONE...LOW] = 1000,
+		[NOMINAL] = 1100,
+		[HIGH]    = 1200,
+	};
+
+	target_mv = mv[level];
+	rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_MSMC1, &target_mv, NULL);
+	if (rc)
 		goto out;
-
-	if (mvolts) {
-		err = -EINVAL;
+	if (target_mv) {
+		rc = -EINVAL;
 		goto out;
 	}
-	msmc1_level = target;
 out:
-	return err;
-}
-
-static void unvote_msmc1(unsigned level)
-{
-	if (level >= ARRAY_SIZE(msmc1_votes))
-		return;
-
-	if (msmc1_votes[level]) {
-		msmc1_votes[level]--;
-	} else {
-		pr_warning("%s: Reference counts are incorrect\n", __func__);
-		return;
-	}
-
-	update_msmc1();
-}
-
-static int vote_msmc1(unsigned level)
-{
-	int ret;
-
-	if (level >= ARRAY_SIZE(msmc1_votes))
-		return 0;
-
-	msmc1_votes[level]++;
-	ret = update_msmc1();
-	if (ret)
-		msmc1_votes[level]--;
-
-	return ret;
-}
-
-/*
- * SoC specific register-based control of clocks.
- */
-static int _soc_clk_enable(unsigned id)
-{
-	struct clk_local *t = &clk_local_tbl[id];
-	void *ns_reg = t->ns_reg;
-	uint32_t reg_val = 0;
-
-	WARN((t->type != NORATE) && (t->current_freq == &dummy_freq),
-		"Attempting to enable clock %d before setting its rate. "
-		"Set the rate first!\n", id);
-
-	reg_val = readl(ns_reg);
-	if (t->type == MND) {
-		/* mode can be either 0 or 1. So the R-value of the
-		 * expression will evaluate to MNCNTR_EN_MASK or 0. This
-		 * avoids the need for a "if(mode == 1)". A "&" will not work
-		 * here. */
-		reg_val |= (MNCNTR_EN_MASK * t->current_freq->mode);
-		writel(reg_val, ns_reg);
-	}
-	if (t->root_en_mask) {
-		reg_val |= t->root_en_mask;
-		writel(reg_val, ns_reg);
-	}
-	if (t->br_en_mask) {
-		reg_val |= t->br_en_mask;
-		writel(reg_val, ns_reg);
-	}
-	if (t->halt_reg) {
-		uint32_t halted, count = 0;
-
-		/* Wait for the halt bit to clear, but timeout after 100usecs
-		 * since the halt bit may be buggy. */
-		while ((halted = readl(t->halt_reg) & BIT(t->halt_mask))
-			&& count++ < 100)
-			udelay(1);
-		if (halted)
-			pr_warning("%s: clock %d never turned on\n", __func__,
-					id);
-	}
-	return 0;
-}
-
-static void _soc_clk_disable(unsigned id)
-{
-	struct clk_local *t = &clk_local_tbl[id];
-	void *ns_reg = t->ns_reg;
-	uint32_t reg_val = 0;
-
-	reg_val = readl(ns_reg);
-
-	if (t->br_en_mask) {
-		reg_val &= ~(t->br_en_mask);
-		writel(reg_val, ns_reg);
-	}
-	if (t->halt_reg) {
-		uint32_t halted, count = 0;
-
-		/* Wait for the halt bit to be set, but timeout after 100usecs
-		 * since the halt bit may be buggy. */
-		while (!(halted = readl(t->halt_reg) & BIT(t->halt_mask))
-			&& count++ < 100)
-			udelay(1);
-		if (!halted)
-			pr_warning("%s: clock %d never turned off\n", __func__,
-					id);
-	}
-	if (t->root_en_mask) {
-		reg_val &= ~(t->root_en_mask);
-		writel(reg_val, ns_reg);
-	}
-	if (t->type == MND) {
-		reg_val &= ~MNCNTR_EN_MASK;
-		writel(reg_val, ns_reg);
-	}
+	return rc;
 }
 
-static int soc_clk_enable_nolock(unsigned id)
-{
-	struct clk_local *t = &clk_local_tbl[id];
-	int ret = 0;
-
-	if (!t->count) {
-		ret = vote_msmc1(t->current_freq->msmc1);
-		if (ret)
-			return ret;
-		if (t->parent != C(NONE)) {
-			ret = soc_clk_enable_nolock(t->parent);
-			if (ret)
-				return ret;
-		}
-		src_enable(t->current_freq->src);
-		ret = _soc_clk_enable(id);
-	}
-	t->count++;
-
-	return ret;
-}
-
-static void soc_clk_disable_nolock(unsigned id)
-{
-	struct clk_local *t = &clk_local_tbl[id];
-
-	if (!t->count) {
-		pr_warning("Reference count mismatch in clock disable!\n");
-		return;
-	}
-	if (t->count)
-		t->count--;
-	if (t->count == 0) {
-		_soc_clk_disable(id);
-		src_disable(t->current_freq->src);
-		unvote_msmc1(t->current_freq->msmc1);
-		if (t->parent != C(NONE))
-			soc_clk_disable_nolock(t->parent);
-	}
-
-	return;
-}
-
-static int update_pwr_rail(unsigned id, int enable)
+/* Enable/disable a power rail associated with a clock. */
+int soc_set_pwr_rail(unsigned id, int enable)
 {
 	/* TODO: Implement internal power rail control */
 	return 0;
 }
 
-static int soc_clk_enable(unsigned id)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&clock_reg_lock, flags);
-	ret = soc_clk_enable_nolock(id);
-	if (ret)
-		goto unlock;
-	/*
-	 * The modem might modify the register bits for the clock branch when
-	 * the rail is enabled/disabled, so enable the rail inside the lock
-	 * instead of outside it.
-	 */
-	ret = update_pwr_rail(id, 1);
-	if (ret)
-		soc_clk_disable_nolock(id);
-unlock:
-	spin_unlock_irqrestore(&clock_reg_lock, flags);
-
-	return ret;
-}
-
-static void soc_clk_disable(unsigned id)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&clock_reg_lock, flags);
-	update_pwr_rail(id, 0);
-	soc_clk_disable_nolock(id);
-	spin_unlock_irqrestore(&clock_reg_lock, flags);
-}
-
-static void soc_clk_auto_off(unsigned id)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&clock_reg_lock, flags);
-	_soc_clk_disable(id);
-	spin_unlock_irqrestore(&clock_reg_lock, flags);
-}
-
-static long soc_clk_round_rate(unsigned id, unsigned rate)
-{
-	struct clk_local *t = &clk_local_tbl[id];
-	const struct clk_freq_tbl *f;
-
-	if (t->type != MND && t->type != BASIC)
-		return -EINVAL;
-
-	for (f = t->freq_tbl; f->freq_hz != FREQ_END; f++)
-		if (f->freq_hz >= rate)
-			return f->freq_hz;
-
-	return -EPERM;
-}
-
-static int soc_clk_set_rate(unsigned id, unsigned rate)
-{
-	struct clk_local *t = &clk_local_tbl[id];
-	const struct clk_freq_tbl *cf;
-	const struct clk_freq_tbl *nf;
-	uint32_t *chld = t->children;
-	void *ns_reg = t->ns_reg;
-	void *md_reg = t->md_reg;
-	uint32_t reg_val = 0;
-	int i, ret = 0;
-	unsigned long flags;
-	long rounded;
-
-	rounded = soc_clk_round_rate(id, rate);
-	if (rounded != rate)
-		pr_warning("Use clk_round_rate() before clk_set_rate() with "
-			   "clock %u\n", id);
-	rate = rounded;
-
-	if (t->type != MND && t->type != BASIC)
-		return -EPERM;
-
-	spin_lock_irqsave(&clock_reg_lock, flags);
-	cf = t->current_freq;
-
-	if (rate == cf->freq_hz)
-		goto release_lock;
-
-	for (nf = t->freq_tbl; nf->freq_hz != FREQ_END; nf++)
-		if (nf->freq_hz == rate)
-			break;
-
-	if (nf->freq_hz == FREQ_END) {
-		ret = -EINVAL;
-		goto release_lock;
-	}
-
-	if (t->freq_mask == 0) {
-		t->current_freq = nf;
-		goto release_lock;
-	}
-
-	/* Disable all branches before changing rate to prevent jitter. */
-	for (i = 0; chld && chld[i] != C(NONE); i++) {
-		struct clk_local *ch = &clk_local_tbl[chld[i]];
-		/* Don't bother turning off if it is already off.
-		 * Checking ch->count is cheaper (cache) than reading and
-		 * writing to a register (uncached/unbuffered). */
-		if (ch->count) {
-			reg_val = readl(ch->ns_reg);
-			reg_val &= ~(ch->br_en_mask);
-			writel(reg_val, ch->ns_reg);
-		}
-	}
-
-	if (t->count) {
-		_soc_clk_disable(id);
-
-		ret = vote_msmc1(nf->msmc1);
-		if (ret)
-			goto msmc1_err;
-		/* Turn on PLL of the new freq. */
-		src_enable(nf->src);
-	}
-
-	/* Some clocks share the same register, so must be careful when
-	 * assuming a register doesn't need to be re-read. */
-	reg_val = readl(ns_reg);
-	if (t->type == MND) {
-		reg_val |= MNCNTR_RST_MASK;
-		writel(reg_val, ns_reg);
-		/* TODO: Currently writing 0's into reserved bits for 8-bit
-		 * MND. Can be avoided by adding md_mask. */
-		if (nf->mode)
-			writel(nf->md_val, md_reg);
-		reg_val &= ~MNCNTR_MODE_MASK;
-		reg_val |= (MNCNTR_MODE * nf->mode);
-	}
-	reg_val &= ~(t->freq_mask);
-	reg_val |= nf->ns_val;
-	writel(reg_val, ns_reg);
-
-	if (t->type == MND) {
-		reg_val &= ~MNCNTR_RST_MASK;
-		writel(reg_val, ns_reg);
-	}
-
-	if (t->count) {
-		/* Turn off PLL of the old freq. */
-		src_disable(cf->src);
-		unvote_msmc1(cf->msmc1);
-	}
-
-	/* Current freq must be updated before _soc_clk_enable() is called to
-	 * make sure the MNCNTR_E bit is set correctly. */
-	t->current_freq = nf;
-
-msmc1_err:
-	if (t->count)
-		_soc_clk_enable(id);
-	/* Enable only branches that were ON before. */
-	for (i = 0; chld && chld[i] != C(NONE); i++) {
-		struct clk_local *ch = &clk_local_tbl[chld[i]];
-		if (ch->count) {
-			reg_val = readl(ch->ns_reg);
-			reg_val |= ch->br_en_mask;
-			writel(reg_val, ch->ns_reg);
-		}
-	}
-
-release_lock:
-	spin_unlock_irqrestore(&clock_reg_lock, flags);
-	return ret;
-}
-
-static int soc_clk_set_min_rate(unsigned id, unsigned rate)
-{
-	long rounded = soc_clk_round_rate(id, rate);
-	return soc_clk_set_rate(id, rounded);
-}
-
-static int soc_clk_set_max_rate(unsigned id, unsigned rate)
-{
-	return -EPERM;
-}
-
-static int soc_clk_set_flags(unsigned id, unsigned clk_flags)
+/* Implementation for clk_set_flags(). */
+int soc_clk_set_flags(unsigned id, unsigned clk_flags)
 {
 	uint32_t regval, ret = 0;
 	unsigned long flags;
 
-	spin_lock_irqsave(&clock_reg_lock, flags);
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
 	switch (id) {
 	case C(VFE):
 		regval = readl(CAM_VFE_NS_REG);
@@ -1261,50 +713,102 @@ static int soc_clk_set_flags(unsigned id, unsigned clk_flags)
 	default:
 		ret = -EPERM;
 	}
-	spin_unlock_irqrestore(&clock_reg_lock, flags);
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
 
 	return ret;
 }
 
-static unsigned soc_clk_get_rate(unsigned id)
+/* Enable function for TCXO and LPXO. */
+static int soc_xo_enable(unsigned src, unsigned enable)
 {
-	struct clk_local *t = &clk_local_tbl[id];
-	unsigned long flags;
-	unsigned ret = 0;
+	unsigned pcom_xo_id;
 
-	if (t->type == NORATE)
+	if (src == TCXO)
+		pcom_xo_id = 0;
+	else if (src == LPXO)
+		pcom_xo_id = 1;
+	else
 		return 0;
 
-	spin_lock_irqsave(&clock_reg_lock, flags);
-	ret = t->current_freq->freq_hz;
-	spin_unlock_irqrestore(&clock_reg_lock, flags);
-
-	/* Return 0 if the rate has never been set. Might not be correct,
-	 * but it's good enough. */
-	if (ret == FREQ_END)
-		ret = 0;
-
-	return ret;
+	return msm_proc_comm(PCOM_CLKCTL_RPC_SRC_REQUEST, &pcom_xo_id, &enable);
 }
 
-static unsigned soc_clk_is_enabled(unsigned id)
+/* Enable function for PLLs. */
+static int soc_pll_enable(unsigned src, unsigned enable)
 {
-	return !!(clk_local_tbl[id].count);
-}
+	static const struct pll_ena {
+		uint32_t *const reg;
+		const uint32_t mask;
+	} soc_pll_ena[NUM_SRC] = {
+		[PLL_0] = {PLL_ENA_REG, B(0)},
+		[PLL_1] = {PLL_ENA_REG, B(1)},
+		[PLL_2] = {PLL_ENA_REG, B(2)},
+		[PLL_3] = {PLL_ENA_REG, B(3)},
+		[PLL_4] = {PLL_ENA_REG, B(4)},
+		[PLL_5] = {PLL_ENA_REG, B(5)},
+		[PLL_6] = {PLL_ENA_REG, B(6)},
+	};
+	uint32_t *const soc_pll_status_reg[NUM_SRC] = {
+
+		[PLL_0] = PLL0_STATUS_BASE_REG,
+		[PLL_1] = PLL1_STATUS_BASE_REG,
+		[PLL_2] = PLL2_STATUS_BASE_REG,
+		[PLL_3] = PLL3_STATUS_BASE_REG,
+		[PLL_4] = PLL4_STATUS_BASE_REG,
+		[PLL_5] = PLL5_STATUS_BASE_REG,
+		[PLL_6] = PLL6_STATUS_BASE_REG,
+	};
+	uint32_t reg_val;
 
+	reg_val = readl(soc_pll_ena[src].reg);
 
-struct clk_ops clk_ops_7x30 = {
-	.enable = soc_clk_enable,
-	.disable = soc_clk_disable,
-	.auto_off = soc_clk_auto_off,
-	.set_rate = soc_clk_set_rate,
-	.set_min_rate = soc_clk_set_min_rate,
-	.set_max_rate = soc_clk_set_max_rate,
-	.reset = pc_clk_reset,
-	.set_flags = soc_clk_set_flags,
-	.get_rate = soc_clk_get_rate,
-	.is_enabled = soc_clk_is_enabled,
-	.round_rate = soc_clk_round_rate,
+	if (enable)
+		reg_val |= soc_pll_ena[src].mask;
+	else
+		reg_val &= ~(soc_pll_ena[src].mask);
+
+	writel(reg_val, soc_pll_ena[src].reg);
+
+	if (enable) {
+		/* Wait until PLL is enabled */
+		while ((readl(soc_pll_status_reg[src]) & B(16)) == 0)
+			cpu_relax();
+	}
+
+	return 0;
+}
+
+struct clk_source soc_clk_sources[NUM_SRC] = {
+	[TCXO] =	{	.enable_func = soc_xo_enable,
+				.par = SRC_NONE,
+			},
+	[LPXO] =	{	.enable_func = soc_xo_enable,
+				.par = SRC_NONE,
+			},
+	[AXI] =		{	.enable_func = NULL,
+				.par = LPXO,
+			},
+	[PLL_0] =	{	.enable_func = soc_pll_enable,
+				.par = TCXO,
+			},
+	[PLL_1] =	{	.enable_func = soc_pll_enable,
+				.par = TCXO,
+			},
+	[PLL_2] =	{	.enable_func = soc_pll_enable,
+				.par = TCXO,
+			},
+	[PLL_3] =	{	.enable_func = soc_pll_enable,
+				.par = LPXO,
+			},
+	[PLL_4] =	{	.enable_func = soc_pll_enable,
+				.par = LPXO,
+			},
+	[PLL_5] =	{	.enable_func = soc_pll_enable,
+				.par = TCXO,
+			},
+	[PLL_6] =	{	.enable_func = soc_pll_enable,
+				.par = TCXO,
+			},
 };
 
 /*
@@ -1454,6 +958,22 @@ static bool __init clk_is_local(uint32_t id)
 	return *reg & bit;
 }
 
+/* SoC-specific clk_ops initialization. */
+void __init msm_clk_soc_set_ops(struct clk *clk)
+{
+	if (!clk->ops) {
+		if (clk_is_local(clk->id))
+			clk->ops = &soc_clk_ops_7x30;
+		else {
+			clk->ops = &clk_ops_pcom;
+			clk->id = clk->remote_id;
+		}
+	}
+}
+
+/*
+ * Miscellaneous clock register initializations
+ */
 static const struct reg_init {
 	const void __iomem *reg;
 	uint32_t mask;
@@ -1490,21 +1010,7 @@ static const struct reg_init {
 	{USBH3_NS_REG, B(6), B(6)},
 };
 
-/* SoC-specific clk_ops initialization. */
-void __init msm_clk_soc_set_ops(struct clk *clk)
-{
-	if (!clk->ops) {
-		if (clk_is_local(clk->id))
-			clk->ops = &clk_ops_7x30;
-		else {
-			clk->ops = &clk_ops_pcom;
-			clk->id = clk->remote_id;
-		}
-	}
-}
-
-#define set_1rate(clk) \
-	soc_clk_set_rate(C(clk), clk_local_tbl[C(clk)].freq_tbl->freq_hz)
+/* Local clock driver initialization. */
 void __init msm_clk_soc_init(void)
 {
 	int i;
@@ -1522,10 +1028,10 @@ void __init msm_clk_soc_init(void)
 	 * USB HS core clocks. */
 	for (i = 0; chld_usb_src[i] != C(NONE); i++)
 		if (clk_is_local(chld_usb_src[i]))
-			_soc_clk_disable(chld_usb_src[i]);
+			local_clk_disable_reg(chld_usb_src[i]);
 
 	if (clk_is_local(C(USB_HS_SRC)))
-		soc_clk_set_rate(C(USB_HS_SRC), clk_tbl_usb[0].freq_hz);
+		local_clk_set_rate(C(USB_HS_SRC), clk_tbl_usb[0].freq_hz);
 
 	for (i = 0; i < ARRAY_SIZE(ri_list); i++) {
 		val = readl(ri_list[i].reg);
@@ -1546,5 +1052,23 @@ void __init msm_clk_soc_init(void)
 	set_1rate(GLBL_ROOT);
 
 	/* Sync the GRP2D clock to AXI */
-	soc_clk_set_rate(C(GRP_2D), 1);
+	local_clk_set_rate(C(GRP_2D), 1);
 }
+
+
+/*
+ * Clock operation handler registration
+ */
+struct clk_ops soc_clk_ops_7x30 = {
+	.enable = local_clk_enable,
+	.disable = local_clk_disable,
+	.auto_off = local_clk_auto_off,
+	.set_rate = local_clk_set_rate,
+	.set_min_rate = local_clk_set_min_rate,
+	.set_max_rate = local_clk_set_max_rate,
+	.get_rate = local_clk_get_rate,
+	.is_enabled = local_clk_is_enabled,
+	.round_rate = local_clk_round_rate,
+	.reset = pc_clk_reset,
+	.set_flags = soc_clk_set_flags,
+};
diff --git a/arch/arm/mach-msm/clock-7x30.h b/arch/arm/mach-msm/clock-7x30.h
index d41acb7..01c49c7 100644
--- a/arch/arm/mach-msm/clock-7x30.h
+++ b/arch/arm/mach-msm/clock-7x30.h
@@ -31,116 +31,112 @@
 #define __ARCH_ARM_MACH_MSM_CLOCK_7X30_H
 
 enum {
-	L_7X30_NONE_CLK = -1,
-	L_7X30_ADM_CLK,
-	L_7X30_ADM_P_CLK,
-	L_7X30_CE_CLK,
-	L_7X30_I2C_CLK,
-	L_7X30_I2C_2_CLK,
-	L_7X30_QUP_I2C_CLK,
-	L_7X30_UART1DM_CLK,
-	L_7X30_UART1DM_P_CLK,
-	L_7X30_UART2DM_CLK,
-	L_7X30_UART2DM_P_CLK,
-	L_7X30_EMDH_CLK,
-	L_7X30_EMDH_P_CLK,
-	L_7X30_PMDH_CLK,
-	L_7X30_PMDH_P_CLK,
-	L_7X30_GRP_2D_CLK,
-	L_7X30_GRP_2D_P_CLK,
-	L_7X30_GRP_3D_SRC_CLK,
-	L_7X30_GRP_3D_CLK,
-	L_7X30_GRP_3D_P_CLK,
-	L_7X30_IMEM_CLK,
-	L_7X30_SDC1_CLK,
-	L_7X30_SDC1_P_CLK,
-	L_7X30_SDC2_CLK,
-	L_7X30_SDC2_P_CLK,
-	L_7X30_SDC3_CLK,
-	L_7X30_SDC3_P_CLK,
-	L_7X30_SDC4_CLK,
-	L_7X30_SDC4_P_CLK,
-	L_7X30_MDP_CLK,
-	L_7X30_MDP_P_CLK,
-	L_7X30_MDP_LCDC_PCLK_CLK,
-	L_7X30_MDP_LCDC_PAD_PCLK_CLK,
-	L_7X30_MDP_VSYNC_CLK,
-	L_7X30_MI2S_CODEC_RX_M_CLK,
-	L_7X30_MI2S_CODEC_RX_S_CLK,
-	L_7X30_MI2S_CODEC_TX_M_CLK,
-	L_7X30_MI2S_CODEC_TX_S_CLK,
-	L_7X30_MI2S_M_CLK,
-	L_7X30_MI2S_S_CLK,
-	L_7X30_LPA_CODEC_CLK,
-	L_7X30_LPA_CORE_CLK,
-	L_7X30_LPA_P_CLK,
-	L_7X30_MIDI_CLK,
-	L_7X30_MDC_CLK,
-	L_7X30_ROTATOR_IMEM_CLK,
-	L_7X30_ROTATOR_P_CLK,
-	L_7X30_SDAC_M_CLK,
-	L_7X30_SDAC_CLK,
-	L_7X30_UART1_CLK,
-	L_7X30_UART2_CLK,
-	L_7X30_UART3_CLK,
-	L_7X30_TV_CLK,
-	L_7X30_TV_DAC_CLK,
-	L_7X30_TV_ENC_CLK,
-	L_7X30_HDMI_CLK,
-	L_7X30_TSIF_REF_CLK,
-	L_7X30_TSIF_P_CLK,
-	L_7X30_USB_HS_SRC_CLK,
-	L_7X30_USB_HS_CLK,
-	L_7X30_USB_HS_CORE_CLK,
-	L_7X30_USB_HS_P_CLK,
-	L_7X30_USB_HS2_CLK,
-	L_7X30_USB_HS2_CORE_CLK,
-	L_7X30_USB_HS2_P_CLK,
-	L_7X30_USB_HS3_CLK,
-	L_7X30_USB_HS3_CORE_CLK,
-	L_7X30_USB_HS3_P_CLK,
-	L_7X30_VFE_CLK,
-	L_7X30_VFE_P_CLK,
-	L_7X30_VFE_MDC_CLK,
-	L_7X30_VFE_CAMIF_CLK,
-	L_7X30_CAMIF_PAD_P_CLK,
-	L_7X30_CAM_M_CLK,
-	L_7X30_JPEG_CLK,
-	L_7X30_JPEG_P_CLK,
-	L_7X30_VPE_CLK,
-	L_7X30_MFC_CLK,
-	L_7X30_MFC_DIV2_CLK,
-	L_7X30_MFC_P_CLK,
-	L_7X30_SPI_CLK,
-	L_7X30_SPI_P_CLK,
-	L_7X30_CSI0_CLK,
-	L_7X30_CSI0_VFE_CLK,
-	L_7X30_CSI0_P_CLK,
-	L_7X30_CSI1_CLK,
-	L_7X30_CSI1_VFE_CLK,
-	L_7X30_CSI1_P_CLK,
-	L_7X30_GLBL_ROOT_CLK,
+	L_ADM_CLK,
+	L_ADM_P_CLK,
+	L_CE_CLK,
+	L_I2C_CLK,
+	L_I2C_2_CLK,
+	L_QUP_I2C_CLK,
+	L_UART1DM_CLK,
+	L_UART1DM_P_CLK,
+	L_UART2DM_CLK,
+	L_UART2DM_P_CLK,
+	L_EMDH_CLK,
+	L_EMDH_P_CLK,
+	L_PMDH_CLK,
+	L_PMDH_P_CLK,
+	L_GRP_2D_CLK,
+	L_GRP_2D_P_CLK,
+	L_GRP_3D_SRC_CLK,
+	L_GRP_3D_CLK,
+	L_GRP_3D_P_CLK,
+	L_IMEM_CLK,
+	L_SDC1_CLK,
+	L_SDC1_P_CLK,
+	L_SDC2_CLK,
+	L_SDC2_P_CLK,
+	L_SDC3_CLK,
+	L_SDC3_P_CLK,
+	L_SDC4_CLK,
+	L_SDC4_P_CLK,
+	L_MDP_CLK,
+	L_MDP_P_CLK,
+	L_MDP_LCDC_PCLK_CLK,
+	L_MDP_LCDC_PAD_PCLK_CLK,
+	L_MDP_VSYNC_CLK,
+	L_MI2S_CODEC_RX_M_CLK,
+	L_MI2S_CODEC_RX_S_CLK,
+	L_MI2S_CODEC_TX_M_CLK,
+	L_MI2S_CODEC_TX_S_CLK,
+	L_MI2S_M_CLK,
+	L_MI2S_S_CLK,
+	L_LPA_CODEC_CLK,
+	L_LPA_CORE_CLK,
+	L_LPA_P_CLK,
+	L_MIDI_CLK,
+	L_MDC_CLK,
+	L_ROTATOR_IMEM_CLK,
+	L_ROTATOR_P_CLK,
+	L_SDAC_M_CLK,
+	L_SDAC_CLK,
+	L_UART1_CLK,
+	L_UART2_CLK,
+	L_UART3_CLK,
+	L_TV_CLK,
+	L_TV_DAC_CLK,
+	L_TV_ENC_CLK,
+	L_HDMI_CLK,
+	L_TSIF_REF_CLK,
+	L_TSIF_P_CLK,
+	L_USB_HS_SRC_CLK,
+	L_USB_HS_CLK,
+	L_USB_HS_CORE_CLK,
+	L_USB_HS_P_CLK,
+	L_USB_HS2_CLK,
+	L_USB_HS2_CORE_CLK,
+	L_USB_HS2_P_CLK,
+	L_USB_HS3_CLK,
+	L_USB_HS3_CORE_CLK,
+	L_USB_HS3_P_CLK,
+	L_VFE_CLK,
+	L_VFE_P_CLK,
+	L_VFE_MDC_CLK,
+	L_VFE_CAMIF_CLK,
+	L_CAMIF_PAD_P_CLK,
+	L_CAM_M_CLK,
+	L_JPEG_CLK,
+	L_JPEG_P_CLK,
+	L_VPE_CLK,
+	L_MFC_CLK,
+	L_MFC_DIV2_CLK,
+	L_MFC_P_CLK,
+	L_SPI_CLK,
+	L_SPI_P_CLK,
+	L_CSI0_CLK,
+	L_CSI0_VFE_CLK,
+	L_CSI0_P_CLK,
+	L_CSI1_CLK,
+	L_CSI1_VFE_CLK,
+	L_CSI1_P_CLK,
+	L_GLBL_ROOT_CLK,
 
-	L_7X30_AXI_LI_VG_CLK,
-	L_7X30_AXI_LI_GRP_CLK,
-	L_7X30_AXI_LI_JPEG_CLK,
-	L_7X30_AXI_GRP_2D_CLK,
-	L_7X30_AXI_MFC_CLK,
-	L_7X30_AXI_VPE_CLK,
-	L_7X30_AXI_LI_VFE_CLK,
-	L_7X30_AXI_LI_APPS_CLK,
-	L_7X30_AXI_MDP_CLK,
-	L_7X30_AXI_IMEM_CLK,
-	L_7X30_AXI_LI_ADSP_A_CLK,
-	L_7X30_AXI_ROTATOR_CLK,
+	L_AXI_LI_VG_CLK,
+	L_AXI_LI_GRP_CLK,
+	L_AXI_LI_JPEG_CLK,
+	L_AXI_GRP_2D_CLK,
+	L_AXI_MFC_CLK,
+	L_AXI_VPE_CLK,
+	L_AXI_LI_VFE_CLK,
+	L_AXI_LI_APPS_CLK,
+	L_AXI_MDP_CLK,
+	L_AXI_IMEM_CLK,
+	L_AXI_LI_ADSP_A_CLK,
+	L_AXI_ROTATOR_CLK,
 
-	L_7X30_NR_CLKS
+	L_NR_CLKS
 };
 
-void pll_enable(uint32_t pll);
-void pll_disable(uint32_t pll);
-
-enum {
+enum clk_sources {
 	PLL_0 = 0,
 	PLL_1,
 	PLL_2,
@@ -148,22 +144,18 @@ enum {
 	PLL_4,
 	PLL_5,
 	PLL_6,
-	NUM_PLL
-};
-
-enum {
-	LOW,
-	NOMINAL,
-	HIGH,
-	MSMC1_END
+	AXI,
+	LPXO,
+	TCXO,
+	NUM_SRC
 };
 
 extern int internal_pwr_rail_ctl_auto(unsigned rail_id, bool enable);
 
-extern struct clk_ops clk_ops_7x30;
+extern struct clk_ops soc_clk_ops_7x30;
 #define CLK_7X30(clk_name, clk_id, clk_dev, clk_flags) {	\
 	.name = clk_name, \
-	.id = L_7X30_##clk_id, \
+	.id = L_##clk_id, \
 	.remote_id = P_##clk_id, \
 	.flags = clk_flags, \
 	.dev = clk_dev, \
@@ -172,7 +164,7 @@ extern struct clk_ops clk_ops_7x30;
 
 #define CLK_7X30S(clk_name, l_id, r_id, clk_dev, clk_flags) {	\
 	.name = clk_name, \
-	.id = L_7X30_##l_id, \
+	.id = L_##l_id, \
 	.remote_id = P_##r_id, \
 	.flags = clk_flags, \
 	.dev = clk_dev, \
@@ -181,11 +173,11 @@ extern struct clk_ops clk_ops_7x30;
 
 #define CLK_7X30L(clk_name, l_id, clk_dev, clk_flags) {	\
 	.name = clk_name, \
-	.id = L_7X30_##l_id, \
+	.id = L_##l_id, \
 	.flags = clk_flags, \
 	.dev = clk_dev, \
 	.dbg_name = #l_id, \
-	.ops = &clk_ops_7x30, \
+	.ops = &soc_clk_ops_7x30, \
 	}
 
 #endif
diff --git a/arch/arm/mach-msm/clock-local.c b/arch/arm/mach-msm/clock-local.c
new file mode 100644
index 0000000..d6eb6c6
--- /dev/null
+++ b/arch/arm/mach-msm/clock-local.c
@@ -0,0 +1,679 @@
+/* Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/ctype.h>
+#include <linux/bitops.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <mach/msm_iomap.h>
+#include <mach/clk.h>
+
+#include "clock.h"
+#include "clock-local.h"
+
+/* When enabling/disabling a clock, check the halt bit up to this number
+ * number of times (with a 1 us delay in between) before continuing. */
+#define HALT_CHECK_MAX_LOOPS	100
+/* For clock without halt checking, wait this long after enables/disables. */
+#define HALT_CHECK_DELAY_US	10
+
+DEFINE_SPINLOCK(local_clock_reg_lock);
+struct clk_freq_tbl local_dummy_freq = F_END;
+
+#define MAX_SOURCES 20
+static int src_votes[MAX_SOURCES];
+static DEFINE_SPINLOCK(src_vote_lock);
+
+unsigned local_sys_vdd_votes[NUM_SYS_VDD_LEVELS];
+static DEFINE_SPINLOCK(sys_vdd_vote_lock);
+
+static int local_clk_enable_nolock(unsigned id);
+static int local_clk_disable_nolock(unsigned id);
+static int local_src_enable_nolock(int src);
+static int local_src_disable_nolock(int src);
+
+/*
+ * Common Set-Rate Functions
+ */
+/* For clocks with integer dividers only. */
+void set_rate_basic(struct clk_local *clk, struct clk_freq_tbl *nf)
+{
+	uint32_t reg_val;
+
+	reg_val = readl(clk->ns_reg);
+	reg_val &= ~(clk->ns_mask);
+	reg_val |= nf->ns_val;
+	writel(reg_val, clk->ns_reg);
+}
+
+/* For clocks with MND dividers. */
+void set_rate_mnd(struct clk_local *clk, struct clk_freq_tbl *nf)
+{
+	uint32_t ns_reg_val, cc_reg_val;
+
+	/* Assert MND reset. */
+	ns_reg_val = readl(clk->ns_reg);
+	ns_reg_val |= B(7);
+	writel(ns_reg_val, clk->ns_reg);
+
+	/* Program M and D values. */
+	writel(nf->md_val, clk->md_reg);
+
+	/* Program NS register. */
+	ns_reg_val &= ~(clk->ns_mask);
+	ns_reg_val |= nf->ns_val;
+	writel(ns_reg_val, clk->ns_reg);
+
+	/* If the clock has a separate CC register, program it. */
+	if (clk->ns_reg != clk->cc_reg) {
+		cc_reg_val = readl(clk->cc_reg);
+		cc_reg_val &= ~(clk->cc_mask);
+		cc_reg_val |= nf->cc_val;
+		writel(cc_reg_val, clk->cc_reg);
+	}
+
+	/* Deassert MND reset. */
+	ns_reg_val &= ~B(7);
+	writel(ns_reg_val, clk->ns_reg);
+}
+
+void set_rate_nop(struct clk_local *clk, struct clk_freq_tbl *nf)
+{
+	/* Nothing to do for fixed-rate clocks. */
+}
+
+/*
+ * SYS_VDD voting functions
+ */
+
+/* Update system voltage level given the current votes. */
+static int local_update_sys_vdd(void)
+{
+	static int cur_level = NUM_SYS_VDD_LEVELS;
+	int level, rc = 0;
+
+	if (local_sys_vdd_votes[HIGH])
+		level = HIGH;
+	else if (local_sys_vdd_votes[NOMINAL])
+		level = NOMINAL;
+	else if (local_sys_vdd_votes[LOW])
+		level = LOW;
+	else
+		level = NONE;
+
+	if (level == cur_level)
+		return rc;
+
+	rc = soc_update_sys_vdd(level);
+	if (!rc)
+		cur_level = level;
+
+	return rc;
+}
+
+/* Vote for a system voltage level. */
+int local_vote_sys_vdd(unsigned level)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	/* Bounds checking. */
+	if (level >= ARRAY_SIZE(local_sys_vdd_votes))
+		return -EINVAL;
+
+	spin_lock_irqsave(&sys_vdd_vote_lock, flags);
+	local_sys_vdd_votes[level]++;
+	rc = local_update_sys_vdd();
+	if (rc)
+		local_sys_vdd_votes[level]--;
+	spin_unlock_irqrestore(&sys_vdd_vote_lock, flags);
+
+	return rc;
+}
+
+/* Remove vote for a system voltage level. */
+int local_unvote_sys_vdd(unsigned level)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	/* Bounds checking. */
+	if (level >= ARRAY_SIZE(local_sys_vdd_votes))
+		return -EINVAL;
+
+	spin_lock_irqsave(&sys_vdd_vote_lock, flags);
+	if (local_sys_vdd_votes[level])
+		local_sys_vdd_votes[level]--;
+	else {
+		pr_warning("%s: Reference counts are incorrect for level %d!\n",
+			__func__, level);
+		goto out;
+	}
+
+	rc = local_update_sys_vdd();
+	if (rc)
+		local_sys_vdd_votes[level]++;
+out:
+	spin_unlock_irqrestore(&sys_vdd_vote_lock, flags);
+	return rc;
+}
+
+/*
+ * Clock source (PLL/XO) control functions
+ */
+
+/* Enable clock source without taking the lock. */
+static int local_src_enable_nolock(int src)
+{
+	int rc = 0;
+
+	if (!src_votes[src]) {
+		if (soc_clk_sources[src].par != SRC_NONE)
+			rc = local_src_enable_nolock(soc_clk_sources[src].par);
+			if (rc)
+				goto err_par;
+		/* Perform source-specific enable operations. */
+		if (soc_clk_sources[src].enable_func)
+			rc = soc_clk_sources[src].enable_func(src, 1);
+			if (rc)
+				goto err_enable;
+	}
+	src_votes[src]++;
+
+	return rc;
+
+err_enable:
+	if (soc_clk_sources[src].par != SRC_NONE)
+		local_src_disable_nolock(soc_clk_sources[src].par);
+err_par:
+	return rc;
+}
+
+/* Enable clock source. */
+int local_src_enable(int src)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (src == SRC_NONE)
+		return rc;
+
+	spin_lock_irqsave(&src_vote_lock, flags);
+	rc = local_src_enable_nolock(src);
+	spin_unlock_irqrestore(&src_vote_lock, flags);
+
+	return rc;
+}
+
+/* Disable clock source without taking the lock. */
+static int local_src_disable_nolock(int src)
+{
+	int rc = 0;
+
+	if (src_votes[src] > 0)
+		src_votes[src]--;
+	else {
+		pr_warning("%s: Reference counts are incorrect for "
+			   "src %d!\n", __func__, src);
+		return rc;
+	}
+
+	if (src_votes[src] == 0) {
+		/* Perform source-specific disable operations. */
+		if (soc_clk_sources[src].enable_func)
+			rc = soc_clk_sources[src].enable_func(src, 0);
+			if (rc)
+				goto err_disable;
+		if (soc_clk_sources[src].par != SRC_NONE)
+			rc = local_src_disable_nolock(soc_clk_sources[src].par);
+			if (rc)
+				goto err_disable_par;
+
+	}
+
+	return rc;
+
+err_disable_par:
+	soc_clk_sources[src].enable_func(src, 1);
+err_disable:
+	src_votes[src]++;
+	return rc;
+}
+
+/* Disable clock source. */
+int local_src_disable(int src)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (src == SRC_NONE)
+		return rc;
+
+	spin_lock_irqsave(&src_vote_lock, flags);
+	rc = local_src_disable_nolock(src);
+	spin_unlock_irqrestore(&src_vote_lock, flags);
+
+	return rc;
+}
+
+/*
+ * Clock enable/disable functions
+ */
+
+/* Return non-zero if a clock status registers shows the clock is halted. */
+static int local_clk_is_halted(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	int invert = (clk->halt_check == ENABLE);
+	int status_bit = readl(clk->halt_reg) & B(clk->halt_bit);
+	return invert ? !status_bit : status_bit;
+}
+
+/* Perform any register operations required to enable the clock. */
+void local_clk_enable_reg(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	void *reg = clk->cc_reg;
+	uint32_t reg_val;
+
+	WARN((clk->type != NORATE) && (clk->current_freq == &local_dummy_freq),
+		"Attempting to enable clock %d before setting its rate. "
+		"Set the rate first!\n", id);
+
+	/* Enable MN counter, if applicable. */
+	reg_val = readl(reg);
+	if (clk->type == MND) {
+		reg_val |= clk->current_freq->mnd_en_mask;
+		writel(reg_val, reg);
+	}
+	/* Enable root. */
+	if (clk->root_en_mask) {
+		reg_val |= clk->root_en_mask;
+		writel(reg_val, reg);
+	}
+	/* Enable branch. */
+	if (clk->br_en_mask) {
+		reg_val |= clk->br_en_mask;
+		writel(reg_val, reg);
+	}
+
+	/* Wait for clock to enable before returning. */
+	if (clk->halt_check == DELAY)
+		udelay(HALT_CHECK_DELAY_US);
+	else if (clk->halt_check == ENABLE || clk->halt_check == HALT
+			|| clk->halt_check == ENABLE_VOTED
+			|| clk->halt_check == HALT_VOTED) {
+		int count;
+
+		/* Wait up to HALT_CHECK_MAX_LOOPS for clock to enable. */
+		for (count = HALT_CHECK_MAX_LOOPS; local_clk_is_halted(id)
+					&& count > 0; count--)
+			udelay(1);
+		if (count == 0)
+			pr_warning("%s: clock %d status stuck at 'off' (bit %d "
+				   "of 0x%p).\n", __func__, id, clk->halt_bit,
+				   clk->halt_reg);
+	}
+}
+
+/* Perform any register operations required to enable the clock. */
+void local_clk_disable_reg(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	void *reg = clk->cc_reg;
+	uint32_t reg_val;
+
+	/* Disable branch. */
+	reg_val = readl(reg);
+	if (clk->br_en_mask) {
+		reg_val &= ~(clk->br_en_mask);
+		writel(reg_val, reg);
+	}
+
+	/* Wait for clock to disable before continuing. */
+	if (clk->halt_check == DELAY || clk->halt_check == ENABLE_VOTED
+				     || clk->halt_check == HALT_VOTED)
+		udelay(HALT_CHECK_DELAY_US);
+	else if (clk->halt_check == ENABLE || clk->halt_check == HALT) {
+		int count;
+
+		/* Wait up to HALT_CHECK_MAX_LOOPS for clock to disable. */
+		for (count = HALT_CHECK_MAX_LOOPS; !local_clk_is_halted(id)
+					&& count > 0; count--)
+			udelay(1);
+		if (count == 0)
+			pr_warning("%s: clock %d status stuck at 'on' (bit %d "
+				   "of 0x%p).\n", __func__, id, clk->halt_bit,
+				   clk->halt_reg);
+	}
+
+	/* Disable root. */
+	if (clk->root_en_mask) {
+		reg_val &= ~(clk->root_en_mask);
+		writel(reg_val, reg);
+	}
+	/* Disable MN counter, if applicable. */
+	if (clk->type == MND) {
+		reg_val &= ~(clk->current_freq->mnd_en_mask);
+		writel(reg_val, reg);
+	}
+}
+
+/* Enable a clock with no locking, enabling parent clocks as needed. */
+static int local_clk_enable_nolock(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	int rc = 0;
+
+	if (clk->type == RESET)
+		return -EPERM;
+
+	if (!clk->count) {
+		rc = local_vote_sys_vdd(clk->current_freq->sys_vdd);
+		if (rc)
+			goto err_vdd;
+		if (clk->parent != C(NONE)) {
+			rc = local_clk_enable_nolock(clk->parent);
+			if (rc)
+				goto err_par;
+		}
+		rc = local_src_enable(clk->current_freq->src);
+		if (rc)
+			goto err_src;
+		local_clk_enable_reg(id);
+	}
+	clk->count++;
+
+	return rc;
+
+err_src:
+	if (clk->parent != C(NONE))
+		rc = local_clk_disable_nolock(clk->parent);
+err_par:
+	local_unvote_sys_vdd(clk->current_freq->sys_vdd);
+err_vdd:
+	return rc;
+}
+
+/* Disable a clock with no locking, disabling unused parents, too. */
+static int local_clk_disable_nolock(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	int rc = 0;
+
+	if (clk->count > 0)
+		clk->count--;
+	else {
+		pr_warning("%s: Reference counts are incorrect for clock %d!\n",
+			__func__, id);
+		return rc;
+	}
+
+	if (clk->count == 0) {
+		local_clk_disable_reg(id);
+		rc = local_src_disable(clk->current_freq->src);
+		if (rc)
+			goto err_src;
+		if (clk->parent != C(NONE))
+			rc = local_clk_disable_nolock(clk->parent);
+			if (rc)
+				goto err_par;
+		rc = local_unvote_sys_vdd(clk->current_freq->sys_vdd);
+		if (rc)
+			goto err_vdd;
+	}
+
+	return rc;
+
+err_vdd:
+	if (clk->parent != C(NONE))
+		rc = local_clk_enable_nolock(clk->parent);
+err_par:
+	local_src_enable(clk->current_freq->src);
+err_src:
+	local_clk_enable_reg(id);
+	clk->count++;
+
+	return rc;
+}
+
+/* Enable a clock and any related power rail. */
+int local_clk_enable(unsigned id)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+	rc = local_clk_enable_nolock(id);
+	if (rc)
+		goto unlock;
+	/*
+	 * With remote rail control, the remote processor might modify
+	 * the clock control register when the rail is enabled/disabled.
+	 * Enable the rail inside the lock to protect against this.
+	 */
+	rc = soc_set_pwr_rail(id, 1);
+	if (rc)
+		local_clk_disable_nolock(id);
+unlock:
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+
+	return rc;
+}
+
+/* Disable a clock and any related power rail. */
+void local_clk_disable(unsigned id)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+	soc_set_pwr_rail(id, 0);
+	local_clk_disable_nolock(id);
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+}
+
+/* Turn off a clock at boot, without checking refcounts or disabling parents. */
+void local_clk_auto_off(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	unsigned long flags;
+
+	if (clk->type == RESET)
+		return;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+	local_clk_disable_reg(id);
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+}
+
+/*
+ * Frequency-related functions
+ */
+
+/* Set a clock's frequency. */
+static int _local_clk_set_rate(unsigned id, struct clk_freq_tbl *nf)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	struct clk_freq_tbl *cf;
+	const int32_t *chld = clk->children;
+	int i, rc = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+
+	/* Check if frequency is actually changed. */
+	cf = clk->current_freq;
+	if (nf == cf)
+		goto release_lock;
+
+	/* Disable branch if clock isn't dual-banked with a glitch-free MUX. */
+	if (clk->banked_mnd_masks == NULL) {
+		/* Disable all branches to prevent glitches. */
+		for (i = 0; chld && chld[i] != C(NONE); i++) {
+			struct clk_local *ch = &soc_clk_local_tbl[chld[i]];
+			/* Don't bother turning off if it is already off.
+			 * Checking ch->count is cheaper (cache) than reading
+			 * and writing to a register (uncached/unbuffered). */
+			if (ch->count)
+				local_clk_disable_reg(chld[i]);
+		}
+		if (clk->count)
+			local_clk_disable_reg(id);
+	}
+
+	if (clk->count) {
+		/* Vote for voltage and source for new freq. */
+		rc = local_vote_sys_vdd(nf->sys_vdd);
+		if (rc)
+			goto sys_vdd_vote_failed;
+		rc = local_src_enable(nf->src);
+		if (rc) {
+			local_unvote_sys_vdd(nf->sys_vdd);
+			goto src_enable_failed;
+		}
+	}
+
+	/* Perform clock-specific frequency switch operations. */
+	BUG_ON(!clk->set_rate);
+	clk->set_rate(clk, nf);
+
+	/* Release requirements of the old freq. */
+	if (clk->count) {
+		local_src_disable(cf->src);
+		local_unvote_sys_vdd(cf->sys_vdd);
+	}
+
+	/* Current freq must be updated before local_clk_enable_reg()
+	 * is called to make sure the MNCNTR_EN bit is set correctly. */
+	clk->current_freq = nf;
+
+src_enable_failed:
+sys_vdd_vote_failed:
+	/* Enable any clocks that were disabled. */
+	if (clk->banked_mnd_masks == NULL) {
+		if (clk->count)
+			local_clk_enable_reg(id);
+		/* Enable only branches that were ON before. */
+		for (i = 0; chld && chld[i] != C(NONE); i++) {
+			struct clk_local *ch = &soc_clk_local_tbl[chld[i]];
+			if (ch->count)
+				local_clk_enable_reg(chld[i]);
+		}
+	}
+
+release_lock:
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+	return rc;
+}
+
+/* Set a clock to an exact rate. */
+int local_clk_set_rate(unsigned id, unsigned rate)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	struct clk_freq_tbl *nf;
+
+	if (clk->type == NORATE || clk->type == RESET)
+		return -EPERM;
+
+	for (nf = clk->freq_tbl; nf->freq_hz != FREQ_END
+			&& nf->freq_hz != rate; nf++)
+		;
+
+	if (nf->freq_hz == FREQ_END)
+		return -EINVAL;
+
+	return _local_clk_set_rate(id, nf);
+}
+
+/* Set a clock to a rate greater than some minimum. */
+int local_clk_set_min_rate(unsigned id, unsigned rate)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	struct clk_freq_tbl *nf;
+
+	if (clk->type == NORATE || clk->type == RESET)
+		return -EPERM;
+
+	for (nf = clk->freq_tbl; nf->freq_hz != FREQ_END
+			&& nf->freq_hz < rate; nf++)
+		;
+
+	if (nf->freq_hz == FREQ_END)
+		return -EINVAL;
+
+	return _local_clk_set_rate(id, nf);
+}
+
+/* Set a clock to a maximum rate. */
+int local_clk_set_max_rate(unsigned id, unsigned rate)
+{
+	return -EPERM;
+}
+
+/* Get the currently-set rate of a clock in Hz. */
+unsigned local_clk_get_rate(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	unsigned long flags;
+	unsigned ret = 0;
+
+	if (clk->type == NORATE || clk->type == RESET)
+		return 0;
+
+	spin_lock_irqsave(&local_clock_reg_lock, flags);
+	ret = clk->current_freq->freq_hz;
+	spin_unlock_irqrestore(&local_clock_reg_lock, flags);
+
+	/* Return 0 if the rate has never been set. Might not be correct,
+	 * but it's good enough. */
+	if (ret == FREQ_END)
+		ret = 0;
+
+	return ret;
+}
+
+/* Check if a clock is currently enabled. */
+unsigned local_clk_is_enabled(unsigned id)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+
+	if (clk->type == RESET)
+		return -EPERM;
+
+	return !!(soc_clk_local_tbl[id].count);
+}
+
+/* Return a supported rate that's at least the specified rate. */
+long local_clk_round_rate(unsigned id, unsigned rate)
+{
+	struct clk_local *clk = &soc_clk_local_tbl[id];
+	struct clk_freq_tbl *f;
+
+	if (clk->type == NORATE || clk->type == RESET)
+		return -EINVAL;
+
+	for (f = clk->freq_tbl; f->freq_hz != FREQ_END; f++)
+		if (f->freq_hz >= rate)
+			return f->freq_hz;
+
+	return -EPERM;
+}
diff --git a/arch/arm/mach-msm/clock-local.h b/arch/arm/mach-msm/clock-local.h
new file mode 100644
index 0000000..ebefad5
--- /dev/null
+++ b/arch/arm/mach-msm/clock-local.h
@@ -0,0 +1,232 @@
+/* Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#ifndef __ARCH_ARM_MACH_MSM_CLOCK_LOCAL_H
+#define __ARCH_ARM_MACH_MSM_CLOCK_LOCAL_H
+
+#include <linux/spinlock.h>
+#include "clock.h"
+
+/*
+ * Bit manipulation macros
+ */
+#define B(x)	BIT(x)
+#define BM(msb, lsb)	(((((uint32_t)-1) << (31-msb)) >> (31-msb+lsb)) << lsb)
+#define BVAL(msb, lsb, val)	(((val) << lsb) & BM(msb, lsb))
+
+/*
+ * Clock types
+ */
+#define MND		1 /* Integer predivider and fractional MN:D divider. */
+#define BASIC		2 /* Integer divider. */
+#define NORATE		3 /* Just on/off. */
+#define RESET		4 /* Reset only. */
+
+/*
+ * IDs for invalid sources, source selects, and XOs
+ */
+#define SRC_NONE	-1
+#define SRC_SEL_NONE	-1
+#define XO_NONE		-1
+
+/*
+ * Halt/Status Checking Mode Macros
+ */
+#define NOCHECK		0	/* No bit to check, do nothing */
+#define HALT		1	/* Bit pol: 1 = halted */
+#define HALT_VOTED	2	/* Bit pol: 1 = halted; delay on disable */
+#define ENABLE		3	/* Bit pol: 1 = running */
+#define ENABLE_VOTED	4	/* Bit pol: 1 = running; delay on disable */
+#define DELAY		5	/* No bit to check, just delay */
+
+/*
+ * Generic frequency-definition structs and macros
+ */
+struct clk_freq_tbl {
+	const uint32_t	freq_hz;
+	const int	src;
+	const uint32_t	md_val;
+	const uint32_t	ns_val;
+	const uint32_t	cc_val;
+	uint32_t	mnd_en_mask;
+	const unsigned	sys_vdd;
+	void		*const extra_freq_data;
+};
+
+/* Some clocks have two banks to avoid glitches when switching frequencies.
+ * The unused bank is programmed while running on the other bank, and
+ * switched to afterwards. The following two structs describe the banks. */
+struct bank_mask_info {
+	void *const md_reg;
+	const uint32_t	ns_mask;
+	const uint32_t	rst_mask;
+	const uint32_t	mnd_en_mask;
+	const uint32_t	mode_mask;
+};
+
+struct banked_mnd_masks {
+	const uint32_t			bank_sel_mask;
+	const struct bank_mask_info	bank0_mask;
+	const struct bank_mask_info	bank1_mask;
+};
+
+#define F_RAW(f, s, m_v, n_v, c_v, m_m, v, e) { \
+	.freq_hz = f, \
+	.src = s, \
+	.md_val = m_v, \
+	.ns_val = n_v, \
+	.cc_val = c_v, \
+	.mnd_en_mask = m_m, \
+	.sys_vdd = v, \
+	.extra_freq_data = e, \
+	}
+#define FREQ_END	(UINT_MAX-1)
+#define F_END	F_RAW(FREQ_END, SRC_NONE, 0, 0, 0, 0, LOW, NULL)
+#define PLL_RATE(l, m, n, v, d) { l, m, n, v, (d>>1) }
+
+/*
+ * Generic clock-definition struct and macros
+ */
+struct clk_local {
+	int		count;
+	const uint32_t	type;
+	void		*const ns_reg;
+	void		*const cc_reg;
+	void		*const md_reg;
+	void		*const reset_reg;
+	void		*const halt_reg;
+	const uint32_t	reset_mask;
+	const uint16_t	halt_check;
+	const uint16_t	halt_bit;
+	const uint32_t	br_en_mask;
+	const uint32_t	root_en_mask;
+	const uint32_t	ns_mask;
+	const uint32_t	cc_mask;
+	const uint32_t	test_vector;
+	struct banked_mnd_masks *const banked_mnd_masks;
+	const int	parent;
+	const uint32_t	*const children;
+	void		(*set_rate)(struct clk_local *, struct clk_freq_tbl *);
+	struct clk_freq_tbl *const freq_tbl;
+	struct clk_freq_tbl *current_freq;
+};
+
+#define C(x)		L_##x##_CLK
+#define L_NONE_CLK	-1
+#define CLK(id, t, ns_r, cc_r, md_r, r_r, r_m, h_r, h_c, h_b, br, root, \
+		n_m, c_m, s_fn, tbl, bmnd, par, chld_lst, tv) \
+	[C(id)] = { \
+	.type = t, \
+	.ns_reg = ns_r, \
+	.cc_reg = cc_r, \
+	.md_reg = md_r, \
+	.reset_reg = r_r, \
+	.halt_reg = h_r, \
+	.halt_check = h_c, \
+	.halt_bit = h_b, \
+	.reset_mask = r_m, \
+	.br_en_mask = br, \
+	.root_en_mask = root, \
+	.ns_mask = n_m, \
+	.cc_mask = c_m, \
+	.test_vector = tv, \
+	.banked_mnd_masks = bmnd, \
+	.parent = C(par), \
+	.children = chld_lst, \
+	.set_rate = s_fn, \
+	.freq_tbl = tbl, \
+	.current_freq = &local_dummy_freq, \
+	}
+
+/*
+ * Convenience macros
+ */
+#define set_1rate(clk) \
+	local_clk_set_rate(C(clk), soc_clk_local_tbl[C(clk)].freq_tbl->freq_hz)
+
+/*
+ * SYS_VDD voltage levels
+ */
+enum sys_vdd_level {
+	NONE,
+	LOW,
+	NOMINAL,
+	HIGH,
+	NUM_SYS_VDD_LEVELS
+};
+
+/*
+ * Clock source descriptions
+ */
+struct clk_source {
+	int		(*enable_func)(unsigned src, unsigned enable);
+	const signed	par;
+};
+
+/*
+ * Variables from SoC-specific clock drivers
+ */
+extern struct clk_local		soc_clk_local_tbl[];
+extern struct clk_source	soc_clk_sources[];
+
+/*
+ * Variables from clock-local driver
+ */
+extern spinlock_t		local_clock_reg_lock;
+extern struct clk_freq_tbl	local_dummy_freq;
+
+/*
+ * Local-clock APIs
+ */
+int local_src_enable(int src);
+int local_src_disable(int src);
+void local_clk_enable_reg(unsigned id);
+void local_clk_disable_reg(unsigned id);
+int local_vote_sys_vdd(enum sys_vdd_level level);
+int local_unvote_sys_vdd(enum sys_vdd_level level);
+
+/*
+ * clk_ops APIs
+ */
+int local_clk_enable(unsigned id);
+void local_clk_disable(unsigned id);
+void local_clk_auto_off(unsigned id);
+int local_clk_set_rate(unsigned id, unsigned rate);
+int local_clk_set_min_rate(unsigned id, unsigned rate);
+int local_clk_set_max_rate(unsigned id, unsigned rate);
+unsigned local_clk_get_rate(unsigned id);
+unsigned local_clk_is_enabled(unsigned id);
+long local_clk_round_rate(unsigned id, unsigned rate);
+
+/*
+ * Required SoC-specific functions, implemented for every supported SoC
+ */
+int soc_update_sys_vdd(enum sys_vdd_level level);
+int soc_set_pwr_rail(unsigned id, int enable);
+int soc_clk_set_flags(unsigned id, unsigned flags);
+int soc_clk_reset(unsigned id, enum clk_reset_action action);
+
+/*
+ * Generic set-rate implementations
+ */
+void set_rate_basic(struct clk_local *clk, struct clk_freq_tbl *nf);
+void set_rate_mnd(struct clk_local *clk, struct clk_freq_tbl *nf);
+void set_rate_nop(struct clk_local *clk, struct clk_freq_tbl *nf);
+
+#endif /* __ARCH_ARM_MACH_MSM_CLOCK_LOCAL_H */
+
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

