Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0EaCGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 22:06:18 -0400
Received: from ossa.mas.viperplatform.net.au ([202.147.75.25]:60123 "EHLO
	ossa.mas.viperplatform.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891Ab0EaCGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 22:06:17 -0400
X-Greylist: delayed 4265 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 May 2010 22:06:17 EDT
From: Stuart Longland <redhatter@gentoo.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
       Stuart Longland <redhatter@gentoo.org>
Subject: [RFC PATCH] ARM: Add SSI Clock Adjustment for i.MX27 TO2
Date: Mon, 31 May 2010 10:55:00 +1000
Message-Id: <1275267300-30687-1-git-send-email-redhatter@gentoo.org>
X-Mailer: git-send-email 1.6.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Clarity-Outbound-SpamScanned: YES
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for adjusting the SSI clocks using the generic clock
infrastructure.

Known bug:
	The generated clock is approximately 1/4 of what is requested.
	I'm not sure if this is due to a bug in reading MCLK, or
	something else dividing the clock down.  Hence the printk's in
	get_rate_ssix, and the patch's "RFC" status.

This should open the door to using the SSI ports on the i.MX27 in I²S
Master mode amongst other things.

Signed-off-by: Stuart Longland <redhatter@gentoo.org>
---
 arch/arm/mach-mx2/clock_imx27.c |   75 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-mx2/clock_imx27.c b/arch/arm/mach-mx2/clock_imx27.c
index 0f0823c..48a4f62 100644
--- a/arch/arm/mach-mx2/clock_imx27.c
+++ b/arch/arm/mach-mx2/clock_imx27.c
@@ -244,12 +244,59 @@ static unsigned long get_rate_ssix(struct clk *clk, unsigned long pdf)
 
 	parent_rate = clk_get_rate(clk->parent);
 
+	printk("%s: parent = %ld Hz; raw pdf = %ld\n",
+		__FUNCTION__, parent_rate, pdf );
+
 	if (mx27_revision() >= CHIP_REV_2_0)
 		pdf += 4;  /* MX27 TO2+ */
 	else
 		pdf = (pdf < 2) ? 124UL : pdf;  /* MX21 & MX27 TO1 */
 
-	return 2UL * parent_rate / pdf;
+	printk("%s: parent = %ld Hz;     pdf = %ld\n",
+		__FUNCTION__, parent_rate, pdf );
+
+	return (2UL * parent_rate) / pdf;
+}
+
+static unsigned long set_rate_ssix(struct clk *clk, unsigned long rate)
+{
+	unsigned long parent_rate;
+	unsigned long pdf;
+
+	parent_rate = clk_get_rate(clk->parent);
+	pdf = (2UL * parent_rate) / rate;
+
+	if (mx27_revision() >= CHIP_REV_2_0)
+		pdf -= 4;  /* MX27 TO2+ */
+
+	/* TODO: Not sure how to handle other CPU types */
+#if 0
+	else
+		pdf = (pdf < 2) ? 124UL : pdf;  /* MX21 & MX27 TO1 */
+#endif
+	printk("%s: %ld Hz => %ld; pdf = %ld\n",
+			__FUNCTION__, parent_rate, rate, pdf );
+
+	return pdf & 0x3f;
+}
+
+static unsigned long round_rate_ssix(struct clk *clk, unsigned long rate)
+{
+	unsigned long div;
+	unsigned long parent_rate = clk_get_rate(clk->parent);
+
+	div = (2UL * parent_rate) / rate;
+	printk("%s: 2* %ld Hz / %ld Hz = %ld\n",
+			__FUNCTION__, parent_rate, rate, div );
+
+	if ( ( div < 4 ) || ( div > 67 ) )
+		/* Corresponds to divider value < 2 or > 33.5 */
+		return -EINVAL;
+
+	printk("%s: 2* %ld Hz / %ld = %ld\n",
+			__FUNCTION__, parent_rate, div, (2UL*parent_rate) / div);
+
+	return (2UL * parent_rate) / div;
 }
 
 static unsigned long get_rate_ssi1(struct clk *clk)
@@ -257,11 +304,33 @@ static unsigned long get_rate_ssi1(struct clk *clk)
 	return get_rate_ssix(clk, (__raw_readl(CCM_PCDR0) >> 16) & 0x3f);
 }
 
+static int set_rate_ssi1(struct clk *clk, unsigned long rate)
+{
+	__raw_writel( set_rate_ssix(clk, rate) << 16, CCM_PCDR0 );
+	return 0;
+}
+
+static unsigned long round_rate_ssi1(struct clk *clk, unsigned long rate)
+{
+	return round_rate_ssix(clk, rate);
+}
+
 static unsigned long get_rate_ssi2(struct clk *clk)
 {
 	return get_rate_ssix(clk, (__raw_readl(CCM_PCDR0) >> 26) & 0x3f);
 }
 
+static int set_rate_ssi2(struct clk *clk, unsigned long rate)
+{
+	__raw_writel( set_rate_ssix(clk, rate) << 26, CCM_PCDR0 );
+	return 0;
+}
+
+static unsigned long round_rate_ssi2(struct clk *clk, unsigned long rate)
+{
+	return round_rate_ssix(clk, rate);
+}
+
 static unsigned long get_rate_nfc(struct clk *clk)
 {
 	unsigned long nfc_pdf;
@@ -564,8 +633,8 @@ DEFINE_CLOCK(cspi1_clk1,   0, PCCR0, 31, NULL, NULL, &ipg_clk);
 
 DEFINE_CLOCK(mstick_clk,   0, PCCR1,  2, NULL, &mstick_clk1, &ipg_clk);
 DEFINE_CLOCK(nfc_clk,      0, PCCR1,  3, get_rate_nfc, NULL, &cpu_clk);
-DEFINE_CLOCK(ssi2_clk,     1, PCCR1,  4, get_rate_ssi2, &ssi2_clk1, &mpll_main2_clk);
-DEFINE_CLOCK(ssi1_clk,     0, PCCR1,  5, get_rate_ssi1, &ssi1_clk1, &mpll_main2_clk);
+DEFINE_CLOCK1(ssi2_clk,     1, PCCR1,  4, ssi2, &ssi2_clk1, &mpll_main2_clk);
+DEFINE_CLOCK1(ssi1_clk,     0, PCCR1,  5, ssi1, &ssi1_clk1, &mpll_main2_clk);
 DEFINE_CLOCK(vpu_clk,      0, PCCR1,  6, get_rate_vpu, &vpu_clk1, &mpll_main2_clk);
 DEFINE_CLOCK1(per4_clk,    3, PCCR1,  7, per, NULL, &mpll_main2_clk);
 DEFINE_CLOCK1(per3_clk,    2, PCCR1,  8, per, NULL, &mpll_main2_clk);
-- 
1.6.4.4

