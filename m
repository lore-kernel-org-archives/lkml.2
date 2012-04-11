Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2DKWQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:16:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457Ab2DKWQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:16:17 -0400
Date: Wed, 11 Apr 2012 15:15:51 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-d48fc63f6f3f485ed5aa9cf019d8e8e3a7d10263@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, arjanvandeven@gmail.com, hpa@zytor.com,
        mingo@kernel.org, johnstul@us.ibm.com, arjan@infradead.org,
        mfwitten@gmail.com, lenb@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, arjanvandeven@gmail.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com, arjan@infradead.org,
        mfwitten@gmail.com, lenb@kernel.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.02.1204112303270.2542@ionos>
References: <alpine.LFD.2.02.1204112303270.2542@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] Revert "clocksource:
  Load the ACPI PM clocksource asynchronously"
Git-Commit-ID: d48fc63f6f3f485ed5aa9cf019d8e8e3a7d10263
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 11 Apr 2012 15:15:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d48fc63f6f3f485ed5aa9cf019d8e8e3a7d10263
Gitweb:     http://git.kernel.org/tip/d48fc63f6f3f485ed5aa9cf019d8e8e3a7d10263
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Apr 2012 23:49:16 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 12 Apr 2012 00:05:05 +0200

Revert "clocksource: Load the ACPI PM clocksource asynchronously"

This reverts commit b519508298e0292e1771eecf14aaf67755adc39d.

The reason for this revert is that making the frequency verification
preemptible and interruptible is not working reliably. Michaels
machine failed to use PM-timer with the message:

  PM-Timer running at invalid rate: 113% of normal - aborting.

That's not a surprise as the frequency verification does rely on
interrupts being disabled. With a async scheduled thread there is no
guarantee to achieve the same result. Also some driver might fiddle
with the CTC channel 2 during the verification period, which makes the
result even more random and unpredictable.

This can be solved by using the same mechanism as we use in the
deferred TSC validation code, but that only will work if we verified a
working HPET _BEFORE_ trying to do the PM-Timer lazy validation.

So for now reverting is the safe option.

Bisected-by: Michael Witten <mfwitten@gmail.com>
Cc: Arjan van de Ven <arjanvandeven@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <alpine.LFD.2.02.1204112303270.2542@ionos>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/acpi_pm.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 82e8820..6b5cf02 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -23,7 +23,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/async.h>
 #include <asm/io.h>
 
 /*
@@ -180,15 +179,17 @@ static int verify_pmtmr_rate(void)
 /* Number of reads we try to get two different values */
 #define ACPI_PM_READ_CHECKS 10000
 
-static void __init acpi_pm_clocksource_async(void *unused, async_cookie_t cookie)
+static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
 	unsigned int i, j = 0;
 
+	if (!pmtmr_ioport)
+		return -ENODEV;
 
 	/* "verify" this timing source: */
 	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
-		usleep_range(100 * j, 100 * j + 100);
+		udelay(100 * j);
 		value1 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
 		for (i = 0; i < ACPI_PM_READ_CHECKS; i++) {
 			value2 = clocksource_acpi_pm.read(&clocksource_acpi_pm);
@@ -202,34 +203,25 @@ static void __init acpi_pm_clocksource_async(void *unused, async_cookie_t cookie
 			       " 0x%#llx, 0x%#llx - aborting.\n",
 			       value1, value2);
 			pmtmr_ioport = 0;
-			return;
+			return -EINVAL;
 		}
 		if (i == ACPI_PM_READ_CHECKS) {
 			printk(KERN_INFO "PM-Timer failed consistency check "
 			       " (0x%#llx) - aborting.\n", value1);
 			pmtmr_ioport = 0;
-			return;
+			return -ENODEV;
 		}
 	}
 
 	if (verify_pmtmr_rate() != 0){
 		pmtmr_ioport = 0;
-		return;
+		return -ENODEV;
 	}
 
-	clocksource_register_hz(&clocksource_acpi_pm,
+	return clocksource_register_hz(&clocksource_acpi_pm,
 						PMTMR_TICKS_PER_SEC);
 }
 
-static int __init init_acpi_pm_clocksource(void)
-{
-	if (!pmtmr_ioport)
-		return -ENODEV;
-
-	async_schedule(acpi_pm_clocksource_async, NULL);
-	return 0;
-}
-
 /* We use fs_initcall because we want the PCI fixups to have run
  * but we still need to load before device_initcall
  */
