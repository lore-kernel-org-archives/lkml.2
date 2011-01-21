Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab1AUQkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:40:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:50491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1AUQkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:40:39 -0500
Date: Fri, 21 Jan 2011 16:40:13 GMT
From: tip-bot for Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1295027246-11110-1-git-send-email-johnstul@us.ibm.com>
References: <1295027246-11110-1-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] acpi_pm: Clear pmtmr_ioport if acpi_pm initialization fails
Message-ID: <tip-db6b175fa6ad1408cbb2fb62949a6d55cfece03e@git.kernel.org>
Git-Commit-ID: db6b175fa6ad1408cbb2fb62949a6d55cfece03e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 Jan 2011 16:40:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db6b175fa6ad1408cbb2fb62949a6d55cfece03e
Gitweb:     http://git.kernel.org/tip/db6b175fa6ad1408cbb2fb62949a6d55cfece03e
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Fri, 14 Jan 2011 09:47:26 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Jan 2011 17:38:19 +0100

acpi_pm: Clear pmtmr_ioport if acpi_pm initialization fails

If the acpi pm timer throws invalid data, clear pmtmr_ioport
so the pm timer won't accidentally be used.

This was found when using Xen where there is a acpi pm reported,
but gives bogus values, and other code was continuing to try
to use the pm timer after the initialization failed.

[jstultz: Catch additional failure and reword changelog message. ]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <1295027246-11110-1-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
