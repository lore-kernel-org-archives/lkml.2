Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1FIUHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:07:48 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:57279 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289Ab1FIUHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:07:45 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH v2 09/11] x86, olpc-xo1-sci: Propagate power supply/battery events
Date: Thu,  9 Jun 2011 21:05:34 +0100
Message-Id: <1307649936-23655-10-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307649936-23655-1-git-send-email-dsd@laptop.org>
References: <1307649936-23655-1-git-send-email-dsd@laptop.org>
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=nh7iIpWOl4UA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=2e74Odasz0AQKh-OockA:9 a=IHrSQcabL504I30XEaMA:7 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EC events indicate change in AC power connectivity, battery state of
charge, battery error, battery presence, etc. Send notifications to
the power supply subsystem when changes are detected.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig                      |    4 ++-
 arch/x86/platform/olpc/olpc-xo1-sci.c |   37 +++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3494348..267a887 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2081,13 +2081,15 @@ config OLPC_XO1_PM
 
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
-	depends on OLPC && OLPC_XO1_PM
+	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
 	---help---
 	  Add support for SCI-based features of the OLPC XO-1 laptop:
 	   - EC-driven system wakeups
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
 
-- 
1.7.5.2

