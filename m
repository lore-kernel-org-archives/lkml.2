Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1LMON3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:13:29 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:36955 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1LMON2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:13:28 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Jason Liu <jason.hui@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 09/19] clock-imx35: fix reboot in internal boot mode
Date: Tue, 13 Dec 2011 15:13:19 +0100
Message-Id: <1323785599-22763-1-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <20111213100041.GG27267@pengutronix.de>
References: <20111213100041.GG27267@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8d75a26 "ARM: mx35: use generic function for displaying silicon revision"
disabled IIM clock after reading silicon revision which will prevent
reboot in internal boot mode.

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Jason Liu <jason.hui@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
v2: improve comment and code based on Sascha & Sergei's comments
 arch/arm/mach-imx/clock-imx35.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-imx/clock-imx35.c b/arch/arm/mach-imx/clock-imx35.c
index 8116f11..ac8238c 100644
--- a/arch/arm/mach-imx/clock-imx35.c
+++ b/arch/arm/mach-imx/clock-imx35.c
@@ -507,7 +507,7 @@ static struct clk_lookup lookups[] = {
 
 int __init mx35_clocks_init()
 {
-	unsigned int cgr2 = 3 << 26, cgr3 = 0;
+	unsigned int cgr2 = 3 << 26;
 
 #if defined(CONFIG_DEBUG_LL) && !defined(CONFIG_DEBUG_ICEDCC)
 	cgr2 |= 3 << 16;
@@ -521,6 +521,12 @@ int __init mx35_clocks_init()
 	__raw_writel((3 << 18), CCM_BASE + CCM_CGR0);
 	__raw_writel((3 << 2) | (3 << 4) | (3 << 6) | (3 << 8) | (3 << 16),
 			CCM_BASE + CCM_CGR1);
+	__raw_writel(cgr2, CCM_BASE + CCM_CGR2);
+	__raw_writel(0, CCM_BASE + CCM_CGR3);
+
+	clk_enable(&iim_clk);
+	imx_print_silicon_rev("i.MX35", mx35_revision());
+	clk_disable(&iim_clk);
 
 	/*
 	 * Check if we came up in internal boot mode. If yes, we need some
@@ -529,17 +535,11 @@ int __init mx35_clocks_init()
 	 */
 	if (!(__raw_readl(CCM_BASE + CCM_RCSR) & (3 << 10))) {
 		/* Additionally turn on UART1, SCC, and IIM clocks */
-		cgr2 |= 3 << 16 | 3 << 4;
-		cgr3 |= 3 << 2;
+		clk_enable(&iim_clk);
+		clk_enable(&uart1_clk);
+		clk_enable(&scc_clk);
 	}
 
-	__raw_writel(cgr2, CCM_BASE + CCM_CGR2);
-	__raw_writel(cgr3, CCM_BASE + CCM_CGR3);
-
-	clk_enable(&iim_clk);
-	imx_print_silicon_rev("i.MX35", mx35_revision());
-	clk_disable(&iim_clk);
-
 #ifdef CONFIG_MXC_USE_EPIT
 	epit_timer_init(&epit1_clk,
 			MX35_IO_ADDRESS(MX35_EPIT1_BASE_ADDR), MX35_INT_EPIT1);
-- 
1.7.6.4

