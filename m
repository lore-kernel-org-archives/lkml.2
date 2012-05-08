Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2EHEUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:20:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2EHEUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:20:19 -0400
Date: Mon, 7 May 2012 21:19:56 -0700
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-d2aa37411b8e65d57d2c5ae36f0222274292020d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dsd@laptop.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, tglx@linutronix.de
In-Reply-To: <20120412171824.D14C49D401E@zog.reactivated.net>
References: <20120412171824.D14C49D401E@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/olpc/xo1/sci:
  Produce wakeup events for buttons and switches
Git-Commit-ID: d2aa37411b8e65d57d2c5ae36f0222274292020d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:20:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2aa37411b8e65d57d2c5ae36f0222274292020d
Gitweb:     http://git.kernel.org/tip/d2aa37411b8e65d57d2c5ae36f0222274292020d
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Thu, 12 Apr 2012 18:18:24 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 15:02:25 +0200

x86/olpc/xo1/sci: Produce wakeup events for buttons and switches

Produce wakeup events for the XO-1's power button, lid switch
and ebook switch, taking care to only produce events when the
states have changed.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: dilinger@queued.net
Cc: pgf@laptop.org
Link: http://lkml.kernel.org/r/20120412171824.D14C49D401E@zog.reactivated.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
