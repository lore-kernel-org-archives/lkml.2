Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1BVClb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:41:31 -0500
Received: from smtp-out.google.com ([216.239.44.51]:62666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1BVCl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:41:29 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: konkers@android.com, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mike@compulab.co.il,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 5/7] ARM: tegra: timer: Enable timer and rtc clocks
Date: Mon, 21 Feb 2011 18:39:50 -0800
Message-Id: <1298342392-21236-6-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298342392-21236-1-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the timer and rtc clocks to prevent them being
turned off by the bootloader clock disabling code.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/timer.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index ffa6a68..31b4f56 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/interrupt.h>
@@ -193,9 +194,20 @@ static struct irqaction tegra_timer_irq = {
 
 static void __init tegra_init_timer(void)
 {
+	struct clk *clk;
 	unsigned long rate = clk_measure_input_freq();
 	int ret;
 
+	clk = clk_get_sys("timer", NULL);
+	BUG_ON(IS_ERR(clk));
+	clk_enable(clk);
+	clk_put(clk);
+
+	clk = clk_get_sys("rtc-tegra", NULL);
+	BUG_ON(IS_ERR(clk));
+	clk_enable(clk);
+	clk_put(clk);
+
 #ifdef CONFIG_HAVE_ARM_TWD
 	twd_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x600);
 #endif
@@ -239,8 +251,6 @@ static void __init tegra_init_timer(void)
 	tegra_clockevent.cpumask = cpu_all_mask;
 	tegra_clockevent.irq = tegra_timer_irq.irq;
 	clockevents_register_device(&tegra_clockevent);
-
-	return;
 }
 
 struct sys_timer tegra_timer = {
-- 
1.7.3.1

