Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab2CTKhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:37:02 -0400
Received: from mail.meprolight.com ([194.90.149.17]:39378 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756697Ab2CTKhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:37:00 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <g.liakhovetski@gmx.de>,
        <fabio.estevam@freescale.com>, Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH] ARM: i.MX35: Add set_rate and round_rate calls to csi_clk
Date: Tue, 20 Mar 2012 12:29:52 +0200
Message-ID: <1332239392-12639-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add set_rate and round_rate calls to csi_clk. This is needed
to give mx3-camera control over master clock rate to camera.

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 arch/arm/mach-imx/clock-imx35.c |   57 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/clock-imx35.c b/arch/arm/mach-imx/clock-imx35.c
index ac8238c..3202b56 100644
--- a/arch/arm/mach-imx/clock-imx35.c
+++ b/arch/arm/mach-imx/clock-imx35.c
@@ -254,7 +254,7 @@ static unsigned long get_rate_ssi(struct clk *clk)
 	return rate / ((div1 + 1) * (div2 + 1));
 }
 
-static unsigned long get_rate_csi(struct clk *clk)
+static unsigned long csi_get_rate(struct clk *clk)
 {
 	unsigned long pdr2 = __raw_readl(CCM_BASE + CCM_PDR2);
 	unsigned long rate;
@@ -267,6 +267,45 @@ static unsigned long get_rate_csi(struct clk *clk)
 	return rate / (((pdr2 >> 16) & 0x3f) + 1);
 }
 
+static int csi_set_rate(struct clk *clk, unsigned long rate)
+{
+	unsigned long div;
+	unsigned long parent_rate;
+	unsigned long pdr2 = __raw_readl(CCM_BASE + CCM_PDR2);
+
+	if (pdr2 & (1 << 7))
+		parent_rate = get_rate_arm();
+	else
+		parent_rate = get_rate_ppll();
+
+	div = parent_rate / rate;
+
+	/* Set clock divider */
+	pdr2 |= ((div - 1) & 0x3f) << 16;
+	__raw_writel(pdr2, CCM_BASE + CCM_PDR2);
+
+	return 0;
+}
+
+static unsigned long csi_round_rate(struct clk *clk, unsigned long rate)
+{
+	unsigned long div;
+	unsigned long parent_rate;
+	unsigned long pdr2 = __raw_readl(CCM_BASE + CCM_PDR2);
+
+	if (pdr2 & (1 << 7))
+		parent_rate = get_rate_arm();
+	else
+		parent_rate = get_rate_ppll();
+
+	div = parent_rate / rate;
+
+	if (parent_rate % rate)
+		div++;
+
+	return parent_rate / div;
+}
+
 static unsigned long get_rate_otg(struct clk *clk)
 {
 	unsigned long pdr4 = __raw_readl(CCM_BASE + CCM_PDR4);
@@ -353,6 +392,20 @@ static void clk_cgr_disable(struct clk *clk)
 		.disable	= clk_cgr_disable,	\
 	}
 
+#define DEFINE_CLOCK1(name, i, er, es, getsetround, s, p)	\
+	static struct clk name = {                              \
+		.id             = i,                            \
+		.enable_reg     = CCM_BASE + er,                \
+		.enable_shift   = es,                           \
+		.get_rate       = getsetround##_get_rate,       \
+		.set_rate       = getsetround##_set_rate,       \
+		.round_rate     = getsetround##_round_rate,     \
+		.enable         = clk_cgr_enable,               \
+		.disable        = clk_cgr_disable,              \
+		.secondary      = s,                            \
+		.parent         = p,                            \
+	}
+
 DEFINE_CLOCK(asrc_clk,   0, CCM_CGR0,  0, NULL, NULL);
 DEFINE_CLOCK(pata_clk,    0, CCM_CGR0,  2, get_rate_ipg, NULL);
 /* DEFINE_CLOCK(audmux_clk, 0, CCM_CGR0,  4, NULL, NULL); */
@@ -403,7 +456,7 @@ DEFINE_CLOCK(wdog_clk,   0, CCM_CGR2, 24, NULL, NULL);
 DEFINE_CLOCK(max_clk,    0, CCM_CGR2, 26, NULL, NULL);
 DEFINE_CLOCK(audmux_clk, 0, CCM_CGR2, 30, NULL, NULL);
 
-DEFINE_CLOCK(csi_clk,    0, CCM_CGR3,  0, get_rate_csi, NULL);
+DEFINE_CLOCK1(csi_clk,    0, CCM_CGR3,  0, csi, NULL, NULL);
 DEFINE_CLOCK(iim_clk,    0, CCM_CGR3,  2, NULL, NULL);
 DEFINE_CLOCK(gpu2d_clk,  0, CCM_CGR3,  4, NULL, NULL);
 
-- 
1.7.0.4

