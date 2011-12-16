Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab1LPAR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:17:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60510 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759900Ab1LPARx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:17:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [Update][PATCH 5/5] PM / shmobile: Allow the A4R domain to be turned off at run time
Date: Fri, 16 Dec 2011 01:16:58 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201112100042.45168.rjw@sisk.pl> <201112160110.09124.rjw@sisk.pl>
In-Reply-To: <201112160110.09124.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112160116.58694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

After adding PM QoS constraints for the I2C controller in the A4R
domain, that domain can be allowed to be turned off and on by runtime
PM, so remove the "always on" governor from it.

However, the A4R domain has to be "on" when suspend_device_irqs() and
resume_device_irqs() are executed during system suspend and resume,
respectively, so that those functions don't crash while accessing the
INTCS.  For this reason, add a PM notifier to the SH7372 PM code and
make it restore power to A4R before system suspend and remove power
from all unused PM domains after system resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Magnus Damm <damm@opensource.se>
---
 arch/arm/mach-shmobile/pm-sh7372.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

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
@@ -496,9 +495,37 @@ static int sh7372_enter_suspend(suspend_
 	return 0;
 }
 
+/**
+ * sh7372_pm_notifier_fn - SH7372 PM notifier routine.
+ * @notifier: Unused.
+ * @pm_event: Event being handled.
+ * @unused: Unused.
+ */
+static int sh7372_pm_notifier_fn(struct notifier_block *notifier,
+				 unsigned long pm_event, void *unused)
+{
+	switch (pm_event) {
+	case PM_SUSPEND_PREPARE:
+		/*
+		 * This is necessary, because the A4R domain has to be "on"
+		 * when suspend_device_irqs() and resume_device_irqs() are
+		 * executed during system suspend and resume, respectively, so
+		 * that those functions don't crash while accessing the INTCS.
+		 */
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

