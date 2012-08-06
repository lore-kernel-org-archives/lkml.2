Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2HFMX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:23:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40028 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2HFMX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:23:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 1/6] ARM: dove: unify clock setup
Date: Mon,  6 Aug 2012 14:23:29 +0200
Message-Id: <1344255815-4457-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344255815-4457-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch synchronizes the clock setup of dove with other orion-based
platforms.

In dove_find_tclk there was a note about DOVE_SAMPLE_HI/LO register to
detect tclk. While it might be possible to set a different tclk frequency 
with reset strapping the Dove datasheets don't tell anything about tclk 
frequency here. Therefore, I removed that comment.

Also, the patch ensures that tclk is always clocked by prepare/enable.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Rabeeh Khoury <rabeeh@solid-run.com>
Cc: Ian Molton <ian.molton@codethink.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Maen Suleiman <maen@marvell.com>
Cc: Olof Johansson <olof@lixom.net>
---
 arch/arm/mach-dove/common.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 4db5de5..20b765c 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -33,8 +33,6 @@
 #include <plat/addr-map.h>
 #include "common.h"
 
-static int get_tclk(void);
-
 /*****************************************************************************
  * I/O Address Mapping
  ****************************************************************************/
@@ -70,14 +68,18 @@ void __init dove_map_io(void)
 /*****************************************************************************
  * CLK tree
  ****************************************************************************/
+static int dove_tclk;
 static struct clk *tclk;
 
-static void __init clk_init(void)
+static void __init dove_clk_init(void)
 {
 	tclk = clk_register_fixed_rate(NULL, "tclk", NULL, CLK_IS_ROOT,
-				       get_tclk());
+				       dove_tclk);
 
 	orion_clkdev_init(tclk);
+
+	/* Ensure tclk is always clocked */
+	clk_prepare_enable(tclk);
 }
 
 /*****************************************************************************
@@ -187,16 +189,16 @@ void __init dove_init_early(void)
 	orion_time_set_base(TIMER_VIRT_BASE);
 }
 
-static int get_tclk(void)
+static int __init dove_find_tclk(void)
 {
-	/* use DOVE_RESET_SAMPLE_HI/LO to detect tclk */
 	return 166666667;
 }
 
 static void __init dove_timer_init(void)
 {
+	dove_tclk = dove_find_tclk();
 	orion_time_init(BRIDGE_VIRT_BASE, BRIDGE_INT_TIMER1_CLR,
-			IRQ_DOVE_BRIDGE, get_tclk());
+			IRQ_DOVE_BRIDGE, dove_tclk);
 }
 
 struct sys_timer dove_timer = {
@@ -284,8 +286,8 @@ void __init dove_sdio1_init(void)
 
 void __init dove_init(void)
 {
-	printk(KERN_INFO "Dove 88AP510 SoC, ");
-	printk(KERN_INFO "TCLK = %dMHz\n", (get_tclk() + 499999) / 1000000);
+	pr_info("Dove 88AP510 SoC, TCLK = %d MHz.\n",
+		(dove_tclk + 499999) / 1000000);
 
 #ifdef CONFIG_CACHE_TAUROS2
 	tauros2_init();
@@ -293,7 +295,7 @@ void __init dove_init(void)
 	dove_setup_cpu_mbus();
 
 	/* Setup root of clk tree */
-	clk_init();
+	dove_clk_init();
 
 	/* internal devices that every board has */
 	dove_rtc_init();
-- 
1.7.10.4

