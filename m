Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1FYRnE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 13:43:04 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:61867 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778Ab1FYRm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 13:42:57 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH v3 09/11] x86, olpc-xo1-sci: Propagate power supply/battery events
Date: Sat, 25 Jun 2011 17:34:16 +0100
Message-Id: <1309019658-1712-10-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309019658-1712-1-git-send-email-dsd@laptop.org>
References: <1309019658-1712-1-git-send-email-dsd@laptop.org>
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=4ARsk6zbupsA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=2e74Odasz0AQKh-OockA:9 a=it6nxELkiGw0hyAR_YgA:7 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
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
index f5bc969..38af371 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2084,7 +2084,7 @@ config OLPC_XO1_PM
 
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
-	depends on OLPC && OLPC_XO1_PM
+	depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
 	select GPIO_CS5535
 	select MFD_CORE
 	---help---
@@ -2093,6 +2093,8 @@ config OLPC_XO1_SCI
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
1.7.5.4

