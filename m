Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab1ANRrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:47:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33560 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab1ANRrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:47:37 -0500
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH] acpi_pm: Clear pmtmr_ioport if acpi_pm initialization fails
Date: Fri, 14 Jan 2011 09:47:26 -0800
Message-Id: <1295027246-11110-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

If the acpi pm timer throws invalid data, clear pmtmr_ioport
so the pm timer won't accidentally be used.

This was found when using Xen where there is a acpi pm reported,
but gives bogus values, and other code was continuing to try
to use the pm timer after the initialization failed.

[jstultz: Catch additional failure and reword changelog message. ]

CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 drivers/clocksource/acpi_pm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index cfb0f52..effe797 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -202,17 +202,21 @@ static int __init init_acpi_pm_clocksource(void)
 			printk(KERN_INFO "PM-Timer had inconsistent results:"
 			       " 0x%#llx, 0x%#llx - aborting.\n",
 			       value1, value2);
+			pmtmr_ioport = 0;
 			return -EINVAL;
 		}
 		if (i == ACPI_PM_READ_CHECKS) {
 			printk(KERN_INFO "PM-Timer failed consistency check "
 			       " (0x%#llx) - aborting.\n", value1);
+			pmtmr_ioport = 0;
 			return -ENODEV;
 		}
 	}
 
-	if (verify_pmtmr_rate() != 0)
+	if (verify_pmtmr_rate() != 0){
+		pmtmr_ioport = 0;
 		return -ENODEV;
+	}
 
 	return clocksource_register_hz(&clocksource_acpi_pm,
 						PMTMR_TICKS_PER_SEC);
-- 
1.7.3.2.146.gca209

