Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1LIXoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:44:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51432 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1LIXoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:44:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [RFC][PATCH 4/4] PM / input / touchscreen: Make st1232 use device PM QoS constraints
Date: Sat, 10 Dec 2011 00:46:31 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201112100042.45168.rjw@sisk.pl>
In-Reply-To: <201112100042.45168.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100046.32206.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the st1232 driver use dev_pm_qos_add_ancestor_request() to
add a device PM QoS latency constraint for the I2C controller it
depends on, so that the controller won't go into an overly deep
low-power state when the touchscreen has to be particularly
responsive (e.g. when the user moves his or her finger on it)
and allow the A4R domain to be turned off if that doesn't violate
the PM QoS latency constraints.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   28 +++++++++++++++++++++++++++-
 drivers/input/touchscreen/st1232.c |   14 +++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -239,7 +239,6 @@ struct sh7372_pm_domain sh7372_d4 = {
 struct sh7372_pm_domain sh7372_a4r = {
 	.genpd.name = "A4R",
 	.bit_shift = 5,
-	.gov = &pm_domain_always_on_gov,
 	.suspend = sh7372_a4r_suspend,
 	.resume = sh7372_intcs_resume,
 };
@@ -496,9 +495,36 @@ static int sh7372_enter_suspend(suspend_
 	return 0;
 }
 
+/**
+ * sh7372_pm_notifier_fn - SH7372 PM notifier routine.
+ * @notifier: Unused.
+ * @pm_event: Event being handled.
+ * @unused: Unused.
+ *
+ * This is necessary, because the A4R domain has to be "on" when
+ * suspend_device_irqs() and resume_device_irqs() are executed during system
+ * suspend and resume, respectively, so that those functions don't crash
+ * while accessing the INTCS.
+ */
+static int sh7372_pm_notifier_fn(struct notifier_block *notifier,
+				 unsigned long pm_event, void *unused)
+{
+	switch (pm_event) {
+	case PM_SUSPEND_PREPARE:
+		pm_genpd_poweron(&sh7372_a4r.genpd);
+		break;
+	case PM_POST_SUSPEND:
+		pm_genpd_poweroff_unused();
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static void sh7372_suspend_init(void)
 {
 	shmobile_suspend_ops.enter = sh7372_enter_suspend;
+	pm_notifier(sh7372_pm_notifier_fn, 0);
 }
 #else
 static void sh7372_suspend_init(void) {}
Index: linux/drivers/input/touchscreen/st1232.c
===================================================================
--- linux.orig/drivers/input/touchscreen/st1232.c
+++ linux/drivers/input/touchscreen/st1232.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/pm_qos.h>
 
 #define ST1232_TS_NAME	"st1232-ts"
 
@@ -46,6 +47,8 @@ struct st1232_ts_data {
 	struct i2c_client *client;
 	struct input_dev *input_dev;
 	struct st1232_ts_finger finger[MAX_FINGERS];
+	struct dev_pm_qos_request low_latency_req;
+	bool pen_down;
 };
 
 static int st1232_ts_read_data(struct st1232_ts_data *ts)
@@ -118,8 +121,17 @@ static irqreturn_t st1232_ts_irq_handler
 	}
 
 	/* SYN_MT_REPORT only if no contact */
-	if (!count)
+	if (!count) {
 		input_mt_sync(input_dev);
+		if (ts->pen_down) {
+			dev_pm_qos_remove_request(&ts->low_latency_req);
+			ts->pen_down = false;
+		}
+	} else if (!ts->pen_down) {
+		/* First contact, request 100 mcs latency. */
+		dev_pm_qos_add_ancestor_request(&ts->client->dev,
+						&ts->low_latency_req, 100);
+	}
 
 	/* SYN_REPORT */
 	input_sync(input_dev);

