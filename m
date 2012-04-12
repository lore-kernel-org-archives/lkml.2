Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2DLRSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:18:31 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:63083 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab2DLRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:18:29 -0400
From: Daniel Drake <dsd@laptop.org>
To: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-input@vger.kernel.org, dilinger@queued.net, pgf@laptop.org
Subject: [PATCH] x86, olpc-xo1-sci: Produce wakeup events for buttons and switches
Message-Id: <20120412171824.D14C49D401E@zog.reactivated.net>
Date: Thu, 12 Apr 2012 18:18:24 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=gwIB5jAOEEQA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=4mTk9UXv_ITk2oZpGjEA:9 a=k3ooy2haN7zSfsvdTHgA:7 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Produce wakeup events for the XO-1's power button, lid switch and
ebook switch, taking care to only produce events when the states
have changed.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/platform/olpc/olpc-xo1-sci.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index 1d4c783..4b93ff4 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
+#include <linux/pm_wakeup.h>
 #include <linux/mfd/core.h>
 #include <linux/power_supply.h>
 #include <linux/suspend.h>
@@ -83,8 +84,12 @@ static void send_ebook_state(void)
 		return;
 	}
 
+	if (!!test_bit(SW_TABLET_MODE, ebook_switch_idev->sw) == state)
+		return; /* Nothing new to report. */
+
 	input_report_switch(ebook_switch_idev, SW_TABLET_MODE, state);
 	input_sync(ebook_switch_idev);
+	pm_wakeup_event(&ebook_switch_idev->dev, 0);
 }
 
 static void flip_lid_inverter(void)
@@ -123,8 +128,12 @@ static void detect_lid_state(void)
 /* Report current lid switch state through input layer */
 static void send_lid_state(void)
 {
+	if (!!test_bit(SW_LID, lid_switch_idev->sw) == !lid_open)
+		return; /* Nothing new to report. */
+
 	input_report_switch(lid_switch_idev, SW_LID, !lid_open);
 	input_sync(lid_switch_idev);
+	pm_wakeup_event(&lid_switch_idev->dev, 0);
 }
 
 static ssize_t lid_wake_mode_show(struct device *dev,
@@ -213,11 +222,18 @@ static irqreturn_t xo1_sci_intr(int irq, void *dev_id)
 
 	dev_dbg(&pdev->dev, "sts %x gpe %x\n", sts, gpe);
 
-	if (sts & CS5536_PWRBTN_FLAG && !(sts & CS5536_WAK_FLAG)) {
-		input_report_key(power_button_idev, KEY_POWER, 1);
-		input_sync(power_button_idev);
-		input_report_key(power_button_idev, KEY_POWER, 0);
-		input_sync(power_button_idev);
+	if (sts & CS5536_PWRBTN_FLAG) {
+		if (!(sts & CS5536_WAK_FLAG)) {
+			/* Only report power button input when it was pressed
+			 * during regular operation (as opposed to when it
+			 * was used to wake the system). */
+			input_report_key(power_button_idev, KEY_POWER, 1);
+			input_sync(power_button_idev);
+			input_report_key(power_button_idev, KEY_POWER, 0);
+			input_sync(power_button_idev);
+		}
+		/* Report the wakeup event in all cases. */
+		pm_wakeup_event(&power_button_idev->dev, 0);
 	}
 
 	if (gpe & CS5536_GPIOM7_PME_FLAG) { /* EC GPIO */
-- 
1.7.7.6

