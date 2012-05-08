Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2EHEU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:20:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51254 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2EHEU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:20:56 -0400
Date: Mon, 7 May 2012 21:20:46 -0700
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-c2c21e9bb17549e8add4ff76931bcec2e2d3ad48@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dsd@laptop.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, tglx@linutronix.de
In-Reply-To: <20120418223402.D73249D401E@zog.reactivated.net>
References: <20120418223402.D73249D401E@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/olpc/xo1/sci: Report RTC wakeup events
Git-Commit-ID: c2c21e9bb17549e8add4ff76931bcec2e2d3ad48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:20:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2c21e9bb17549e8add4ff76931bcec2e2d3ad48
Gitweb:     http://git.kernel.org/tip/c2c21e9bb17549e8add4ff76931bcec2e2d3ad48
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Wed, 18 Apr 2012 23:34:02 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 15:02:26 +0200

x86/olpc/xo1/sci: Report RTC wakeup events

When the system is woken due to a RTC event, report the wakeup
event on the relevant rtc device (if it can be found).

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: dilinger@queued.net
Cc: pgf@laptop.org
Link: http://lkml.kernel.org/r/20120418223402.D73249D401E@zog.reactivated.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/olpc/olpc-xo1-sci.c |   17 +++++++++++++++--
 include/linux/cs5535.h                |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

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
