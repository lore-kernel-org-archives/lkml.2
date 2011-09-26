Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1IZTOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:14:50 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33782 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab1IZTOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:14:48 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [PATCH 3/6] [RFC] rtc: rtc-cmos: Add pm_stay_awake/pm_relax calls around IRQ
Date: Mon, 26 Sep 2011 12:13:51 -0700
Message-Id: <1317064434-1829-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flag the rtc-cmos IRQ event as a wakeup event using pm_stay_awake
and pm_relax()

CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: arve@android.com
CC: markgross@thegnar.org
CC: Alan Stern <stern@rowland.harvard.edu>
CC: amit.kucheria@linaro.org
CC: farrowg@sg.ibm.com
CC: Dmitry Fink (Palm GBU) <Dmitry.Fink@palm.com>
CC: linux-pm@lists.linux-foundation.org
CC: khilman@ti.com
CC: Magnus Damm <damm@opensource.se>
CC: mjg@redhat.com 
CC: peterz@infradead.org 
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-cmos.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 05beb6c..1cc4688 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -538,11 +538,15 @@ static struct bin_attribute nvram = {
 
 static struct cmos_rtc	cmos_rtc;
 
+static struct wakeup_source *rtc_cmos_wakelock;
+
 static irqreturn_t cmos_interrupt(int irq, void *p)
 {
 	u8		irqstat;
 	u8		rtc_control;
 
+	__pm_stay_awake(rtc_cmos_wakelock);
+
 	spin_lock(&rtc_lock);
 
 	/* When the HPET interrupt handler calls us, the interrupt
@@ -573,9 +577,12 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 
 	if (is_intr(irqstat)) {
 		rtc_update_irq(p, 1, irqstat);
+		__pm_relax(rtc_cmos_wakelock);
 		return IRQ_HANDLED;
-	} else
-		return IRQ_NONE;
+	}
+
+	__pm_relax(rtc_cmos_wakelock);
+	return IRQ_NONE;
 }
 
 #ifdef	CONFIG_PNP
@@ -1153,6 +1160,8 @@ static int __init cmos_init(void)
 {
 	int retval = 0;
 
+	rtc_cmos_wakelock = wakeup_source_register("rtc_cmos");
+
 #ifdef	CONFIG_PNP
 	retval = pnp_register_driver(&cmos_pnp_driver);
 	if (retval == 0)
-- 
1.7.3.2.146.gca209

