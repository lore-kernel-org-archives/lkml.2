Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab0IFKSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:18:09 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:58258 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab0IFKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:18:08 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, avictor.za@gmail.com,
        Fabian Godehardt <fg@emlix.com>
Subject: [PATCH] AT91: SAM9G45 - add a separate clock entry for every single TC block
Date: Mon,  6 Sep 2010 13:23:21 +0200
Message-Id: <1283772201-15453-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <201009060548.18521.fg@emlix.com>
References: <201009060548.18521.fg@emlix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Godehardt <fg@emlix.com>

Without this patch you will not be able to register the first block
because of the second association call on at91_add_device_tc().

Signed-off-by: Fabian Godehardt <fg@emlix.com>
[nicolas.ferre@atmel.com: change tcb1_clk to fake child clock of tcb0_clk]
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9g45.c         |   15 ++++++++++++---
 arch/arm/mach-at91/at91sam9g45_devices.c |    4 ++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 753c0d3..c67b47f 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -121,8 +121,8 @@ static struct clk ssc1_clk = {
 	.pmc_mask	= 1 << AT91SAM9G45_ID_SSC1,
 	.type		= CLK_TYPE_PERIPHERAL,
 };
-static struct clk tcb_clk = {
-	.name		= "tcb_clk",
+static struct clk tcb0_clk = {
+	.name		= "tcb0_clk",
 	.pmc_mask	= 1 << AT91SAM9G45_ID_TCB,
 	.type		= CLK_TYPE_PERIPHERAL,
 };
@@ -192,6 +192,14 @@ static struct clk ohci_clk = {
 	.parent		= &uhphs_clk,
 };
 
+/* One additional fake clock for second TC block */
+static struct clk tcb1_clk = {
+	.name		= "tcb1_clk",
+	.pmc_mask	= 0,
+	.type		= CLK_TYPE_PERIPHERAL,
+	.parent		= &tcb0_clk,
+};
+
 static struct clk *periph_clocks[] __initdata = {
 	&pioA_clk,
 	&pioB_clk,
@@ -208,7 +216,7 @@ static struct clk *periph_clocks[] __initdata = {
 	&spi1_clk,
 	&ssc0_clk,
 	&ssc1_clk,
-	&tcb_clk,
+	&tcb0_clk,
 	&pwm_clk,
 	&tsc_clk,
 	&dma_clk,
@@ -221,6 +229,7 @@ static struct clk *periph_clocks[] __initdata = {
 	&mmc1_clk,
 	// irq0
 	&ohci_clk,
+	&tcb1_clk,
 };
 
 /*
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 809114d..4822019 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -835,9 +835,9 @@ static struct platform_device at91sam9g45_tcb1_device = {
 static void __init at91_add_device_tc(void)
 {
 	/* this chip has one clock and irq for all six TC channels */
-	at91_clock_associate("tcb_clk", &at91sam9g45_tcb0_device.dev, "t0_clk");
+	at91_clock_associate("tcb0_clk", &at91sam9g45_tcb0_device.dev, "t0_clk");
 	platform_device_register(&at91sam9g45_tcb0_device);
-	at91_clock_associate("tcb_clk", &at91sam9g45_tcb1_device.dev, "t0_clk");
+	at91_clock_associate("tcb1_clk", &at91sam9g45_tcb1_device.dev, "t0_clk");
 	platform_device_register(&at91sam9g45_tcb1_device);
 }
 #else
-- 
1.5.6.5

