Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2KOKE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:04:29 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45456 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab2KOKEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:04:24 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, jonas.aberg@stericsson.com,
        linux@arm.linux.org.uk, will.deacon@arm.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/2] clocksource: clksrc-dbx500-prcmu: Add boottime support
Date: Thu, 15 Nov 2012 10:04:07 +0000
Message-Id: <1352973847-21605-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
References: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a call-back to provide boottime functionality with a means
to gain access to CPU run time information. This call-back will be
invoked numerous times during system boot in order to obtain and
log various time increments throughout the booting process precisely.

Based heavily on the original driver by Jonas Aaberg.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clocksource/clksrc-dbx500-prcmu.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index c26c369..0069cd9 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -14,6 +14,7 @@
  */
 #include <linux/clockchips.h>
 #include <linux/clksrc-dbx500-prcmu.h>
+#include <linux/boottime.h>
 
 #include <asm/sched_clock.h>
 
@@ -68,6 +69,23 @@ static u32 notrace dbx500_prcmu_sched_clock_read(void)
 
 #endif
 
+#ifdef CONFIG_BOOTTIME
+static unsigned long __init boottime_get_time(void)
+{
+	return div_s64(clocksource_cyc2ns(clocksource_dbx500_prcmu.read(
+						  &clocksource_dbx500_prcmu),
+					  clocksource_dbx500_prcmu.mult,
+					  clocksource_dbx500_prcmu.shift),
+		       1000);
+}
+
+static struct boottime_timer __initdata boottime_timer = {
+	.init     = NULL,
+	.get_time = boottime_get_time,
+	.finalize = NULL,
+};
+#endif
+
 void __init clksrc_dbx500_prcmu_init(void __iomem *base)
 {
 	clksrc_dbx500_timer_base = base;
@@ -90,4 +108,6 @@ void __init clksrc_dbx500_prcmu_init(void __iomem *base)
 			 32, RATE_32K);
 #endif
 	clocksource_register_hz(&clocksource_dbx500_prcmu, RATE_32K);
+
+	boottime_activate(&boottime_timer);
 }
-- 
1.7.9.5

