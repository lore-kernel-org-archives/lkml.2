Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2AaEtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 23:49:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:45737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2AaEtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:49:49 -0500
Date: Mon, 30 Jan 2012 20:51:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>, arjanvandeven@gmail.com
Subject: [PATCH] clocksource: Load the ACPI PM clocksource asynchronously
Message-ID: <20120130205120.652aa64f@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ef4b0d23878277dfd75828f13353e605aae2937f Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 30 Jan 2012 20:23:30 -0800
Subject: [PATCH] clocksource: Load the ACPI PM clocksource asynchronously

The ACPI clocksource takes quite some time to initialize,
and this increases the boot time of the kernel for a
double digit percentage. This while almost all modern
systems will be using the HPET already anyway.

This patch turns the clocksource loading into an asynchronous
operation; which means it won't hold up the boot while
still becoming available normally.

To make this work well, an udelay() had to be turned into an
usleep_range() so that on UP systems, we yield the CPU to
regular boot tasks instead of spinning.

CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Len Brown <lenb@kernel.org>

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/clocksource/acpi_pm.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 6b5cf02..82e8820 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/async.h>
 #include <asm/io.h>
 
 /*
@@ -179,17 +180,15 @@ static int verify_pmtmr_rate(void)
 /* Number of reads we try to get two different values */
 #define ACPI_PM_READ_CHECKS 10000
 
-static int __init init_acpi_pm_clocksource(void)
+static void __init acpi_pm_clocksource_async(void *unused, async_cookie_t cookie)
 {
 	cycle_t value1, value2;
 	unsigned int i, j = 0;
 
-	if (!pmtmr_ioport)
-		return -ENODEV;
 
 	/* "verify" this timing source: */
 	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
-		udelay(100 * j);
+		usleep_range(100 * j, 100 * j + 100);
 		value1 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
 		for (i = 0; i < ACPI_PM_READ_CHECKS; i++) {
 			value2 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
@@ -203,25 +202,34 @@ static int __init init_acpi_pm_clocksource(void)
 			       " 0x%#llx, 0x%#llx - aborting.\n",
 			       value1, value2);
 			pmtmr_ioport = 0;
-			return -EINVAL;
+			return;
 		}
 		if (i == ACPI_PM_READ_CHECKS) {
 			printk(KERN_INFO "PM-Timer failed consistency check "
 			       " (0x%#llx) - aborting.\n", value1);
 			pmtmr_ioport = 0;
-			return -ENODEV;
+			return;
 		}
 	}
 
 	if (verify_pmtmr_rate() != 0){
 		pmtmr_ioport = 0;
-		return -ENODEV;
+		return;
 	}
 
-	return clocksource_register_hz(&clocksource_acpi_pm,
+	clocksource_register_hz(&clocksource_acpi_pm,
 						PMTMR_TICKS_PER_SEC);
 }
 
+static int __init init_acpi_pm_clocksource(void)
+{
+	if (!pmtmr_ioport)
+		return -ENODEV;
+
+	async_schedule(acpi_pm_clocksource_async, NULL);
+	return 0;
+}
+
 /* We use fs_initcall because we want the PCI fixups to have run
  * but we still need to load before device_initcall
  */
-- 
1.7.6.4



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
