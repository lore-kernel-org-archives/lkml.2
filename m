Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1GGAuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:50:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:60010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab1GGAus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:50:48 -0400
Date: Thu, 7 Jul 2011 00:50:42 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-e1040ac693bac19eaeafbd6c5fd24d9429b5eeb8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, dilinger@queued.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1309019658-1712-10-git-send-email-dsd@laptop.org>
References: <1309019658-1712-10-git-send-email-dsd@laptop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc-xo1-sci: Propagate power supply/battery events
Git-Commit-ID: e1040ac693bac19eaeafbd6c5fd24d9429b5eeb8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Jul 2011 00:50:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1040ac693bac19eaeafbd6c5fd24d9429b5eeb8
Gitweb:     http://git.kernel.org/tip/e1040ac693bac19eaeafbd6c5fd24d9429b5eeb8
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Sat, 25 Jun 2011 17:34:16 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 6 Jul 2011 14:44:40 -0700

x86, olpc-xo1-sci: Propagate power supply/battery events

EC events indicate change in AC power connectivity, battery state of
charge, battery error, battery presence, etc. Send notifications to
the power supply subsystem when changes are detected.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/1309019658-1712-10-git-send-email-dsd@laptop.org
Acked-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                      |    4 ++-
 arch/x86/platform/olpc/olpc-xo1-sci.c |   37 +++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 350ccbb..a6aefbb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2082,7 +2082,7 @@ config OLPC_XO1_PM
 
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
-	depends on OLPC && OLPC_XO1_PM
+	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
 	select GPIO_CS5535
 	select MFD_CORE
 	---help---
@@ -2091,6 +2091,8 @@ config OLPC_XO1_SCI
 	   - Power button
 	   - Ebook switch
 	   - Lid switch
+	   - AC adapter status updates
+	   - Battery status updates
 
 endif # X86_32
 
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index ad0670b..1d4c783 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/mfd/core.h>
+#include <linux/power_supply.h>
 #include <linux/suspend.h>
 #include <linux/workqueue.h>
 
@@ -52,6 +53,26 @@ static const char * const lid_wake_mode_names[] = {
 	[LID_WAKE_CLOSE] = "close",
 };
 
+static void battery_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-battery");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
+static void ac_status_changed(void)
+{
+	struct power_supply *psy = power_supply_get_by_name("olpc-ac");
+
+	if (psy) {
+		power_supply_changed(psy);
+		put_device(psy->dev);
+	}
+}
+
 /* Report current ebook switch state through input layer */
 static void send_ebook_state(void)
 {
@@ -151,6 +172,18 @@ static void process_sci_queue(bool propagate_events)
 
 		pr_debug(PFX "SCI 0x%x received\n", data);
 
+		switch (data) {
+		case EC_SCI_SRC_BATERR:
+		case EC_SCI_SRC_BATSOC:
+		case EC_SCI_SRC_BATTERY:
+		case EC_SCI_SRC_BATCRIT:
+			battery_status_changed();
+			break;
+		case EC_SCI_SRC_ACPWR:
+			ac_status_changed();
+			break;
+		}
+
 		if (data == EC_SCI_SRC_EBOOK && propagate_events)
 			send_ebook_state();
 	} while (data);
@@ -240,6 +273,10 @@ static int xo1_sci_resume(struct platform_device *pdev)
 
 	/* Enable all EC events */
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	/* Power/battery status might have changed too */
+	battery_status_changed();
+	ac_status_changed();
 	return 0;
 }
 
