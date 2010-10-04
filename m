Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0JDJpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 05:45:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59281 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab0JDJpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 05:45:43 -0400
From: vkuzmichev@mvista.com
To: linux-arm-kernel@lists.infradead.org
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH 1/4] ARM: smp_twd: mpcore_wdt: Fix watchdog counter loading
Date: Mon,  4 Oct 2010 13:45:37 +0400
Message-Id: <1286185540-19569-2-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuzmichev <vkuzmichev@mvista.com>

Although upstream commit "98af057 ARM: 6126/1: ARM mpcore_wdt: fix
build failure and other fixes" resolved long standing mpcore_wdt
driver build problems, it introduced an error in the relationship
between the MPcore watchdog timer clock rate and mpcore_margin,
"MPcore timer margin in seconds", such that watchdog timeouts are now
arbitrary rather than the number of seconds specified by mpcore_margin.
This change restores mpcore_wdt_keepalive() to its equivalent
implementation prior to commit 98af057 such that watchdog timeouts now
occur as specified by mpcore_margin.
The variable 'mpcore_timer_rate' which caused that build failure was
replaced by 'twd_timer_rate'. Adding exported function to obtain
twd_timer_rate value in mpcore_wdt driver.
A build error will not occur because MPCORE_WATCHDOG needed to build
'mpcore_wdt' depends on HAVE_ARM_TWD needed to build 'smp_twd'.

Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---
 arch/arm/include/asm/smp_twd.h |    1 +
 arch/arm/kernel/smp_twd.c      |    6 ++++++
 drivers/watchdog/mpcore_wdt.c  |   11 ++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/smp_twd.h b/arch/arm/include/asm/smp_twd.h
index 634f357..c6328d8 100644
--- a/arch/arm/include/asm/smp_twd.h
+++ b/arch/arm/include/asm/smp_twd.h
@@ -25,5 +25,6 @@ extern void __iomem *twd_base;
 void twd_timer_stop(void);
 int twd_timer_ack(void);
 void twd_timer_setup(struct clock_event_device *);
+unsigned long twd_get_timer_rate(void);
 
 #endif
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 35882fb..7bc1173 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -160,3 +160,9 @@ void twd_timer_stop(void)
 	__raw_writel(0, twd_base + TWD_TIMER_CONTROL);
 }
 #endif
+
+unsigned long twd_get_timer_rate(void)
+{
+	return twd_timer_rate;
+}
+EXPORT_SYMBOL(twd_get_timer_rate);
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index b8ec7ac..1bd3529 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -47,6 +47,11 @@ struct mpcore_wdt {
 static struct platform_device *mpcore_wdt_dev;
 static DEFINE_SPINLOCK(wdt_lock);
 
+static unsigned long mpcore_wdt_rate;
+module_param_named(rate, mpcore_wdt_rate, ulong, 0);
+MODULE_PARM_DESC(rate,
+	"MPcore watchdog timer rate in Hz. (default=0 - autodetect)");
+
 #define TIMER_MARGIN	60
 static int mpcore_margin = TIMER_MARGIN;
 module_param(mpcore_margin, int, 0);
@@ -99,9 +104,7 @@ static void mpcore_wdt_keepalive(struct mpcore_wdt *wdt)
 
 	spin_lock(&wdt_lock);
 	/* Assume prescale is set to 256 */
-	count =  __raw_readl(wdt->base + TWD_WDOG_COUNTER);
-	count = (0xFFFFFFFFU - count) * (HZ / 5);
-	count = (count / 256) * mpcore_margin;
+	count = (mpcore_wdt_rate / 256) * mpcore_margin;
 
 	/* Reload the counter */
 	writel(count + wdt->perturb, wdt->base + TWD_WDOG_LOAD);
@@ -434,6 +437,8 @@ static int __init mpcore_wdt_init(void)
 		printk(KERN_INFO "mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
+	if (!mpcore_wdt_rate)
+		mpcore_wdt_rate = twd_get_timer_rate();
 
 	printk(banner, mpcore_noboot, mpcore_margin, nowayout);
 
-- 
1.7.2.2

