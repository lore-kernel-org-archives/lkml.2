Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab2DRWeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:34:09 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:30797 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466Ab2DRWeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:34:07 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, x86@kernel.org, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, pgf@laptop.org,
        linux-pm@vger.kernel.org
Subject: [PATCH] x86, olpc-xo1-sci: report RTC wakeup events
Message-Id: <20120418223402.D73249D401E@zog.reactivated.net>
Date: Wed, 18 Apr 2012 23:34:02 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=uX6l4b1_zicA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=W_26XlkqmHc6Sl9jF5EA:9 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system is woken due to a RTC event, report the wakeup event
on the relevant rtc device (if it can be found).

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/platform/olpc/olpc-xo1-sci.c |   17 +++++++++++++++--
 include/linux/cs5535.h                |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

Depends on earlier patch:
    x86, olpc-xo1-sci: Produce wakeup events for buttons and switches
because the code changes in these 2 patches are close to each other.

diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index 4b93ff4..04b8c73 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -236,6 +236,18 @@ static irqreturn_t xo1_sci_intr(int irq, void *dev_id)
 		pm_wakeup_event(&power_button_idev->dev, 0);
 	}
 
+	if ((sts & (CS5536_RTC_FLAG | CS5536_WAK_FLAG)) ==
+			(CS5536_RTC_FLAG | CS5536_WAK_FLAG)) {
+		/* When the system is woken by the RTC alarm, report the
+		 * event on the rtc device. */
+		struct device *rtc = bus_find_device_by_name(
+			&platform_bus_type, NULL, "rtc_cmos");
+		if (rtc) {
+			pm_wakeup_event(rtc, 0);
+			put_device(rtc);
+		}
+	}
+
 	if (gpe & CS5536_GPIOM7_PME_FLAG) { /* EC GPIO */
 		cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_NEGATIVE_EDGE_STS);
 		schedule_work(&sci_work);
@@ -326,9 +338,10 @@ static int __devinit setup_sci_interrupt(struct platform_device *pdev)
 		outb(lo, CS5536_PIC_INT_SEL2);
 	}
 
-	/* Enable SCI from power button, and clear pending interrupts */
+	/* Enable interesting SCI events, and clear pending interrupts */
 	sts = inl(acpi_base + CS5536_PM1_STS);
-	outl((CS5536_PM_PWRBTN << 16) | 0xffff, acpi_base + CS5536_PM1_STS);
+	outl(((CS5536_PM_PWRBTN | CS5536_PM_RTC) << 16) | 0xffff,
+	     acpi_base + CS5536_PM1_STS);
 
 	r = request_irq(sci_irq, xo1_sci_intr, 0, DRV_NAME, pdev);
 	if (r)
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index c077aec..cfe8323 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -95,6 +95,7 @@ static inline int cs5535_pic_unreqz_select_high(unsigned int group,
 
 /* CS5536_PM1_STS bits */
 #define CS5536_WAK_FLAG		(1 << 15)
+#define CS5536_RTC_FLAG		(1 << 10)
 #define CS5536_PWRBTN_FLAG	(1 << 8)
 
 /* CS5536_PM1_EN bits */
-- 
1.7.7.6

