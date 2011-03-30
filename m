Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab1C3WBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:01:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:15931 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933265Ab1C3VGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447269"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: pgf@laptop.org, dsd@laptop.org, rjw@sisk.pl, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [52/275] rtc-cmos: fix suspend/resume
Message-Id: <20110330210448.6EF483E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Paul Fox <pgf@laptop.org>

commit 2fb08e6ca9f00d1aedb3964983e9c8f84b36b807 upstream.

rtc-cmos was setting suspend/resume hooks at the device_driver level.
However, the platform bus code (drivers/base/platform.c) only looks for
resume hooks at the dev_pm_ops level, or within the platform_driver.

Switch rtc_cmos to use dev_pm_ops so that suspend/resume code is executed
again.

Paul said:

: The user visible symptom in our (XO laptop) case was that rtcwake would
: fail to wake the laptop.  The RTC alarm would expire, but the wakeup
: wasn't unmasked.
:
: As for severity, the impact may have been reduced because if I recall
: correctly, the bug only affected platforms with CONFIG_PNP disabled.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/rtc/rtc-cmos.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/drivers/rtc/rtc-cmos.c
===================================================================
--- linux-2.6.35.y.orig/drivers/rtc/rtc-cmos.c	2011-03-29 22:51:48.793474666 -0700
+++ linux-2.6.35.y/drivers/rtc/rtc-cmos.c	2011-03-29 23:02:59.249319378 -0700
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/log2.h>
+#include <linux/pm.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -850,7 +851,7 @@
 
 #ifdef	CONFIG_PM
 
-static int cmos_suspend(struct device *dev, pm_message_t mesg)
+static int cmos_suspend(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	tmp;
@@ -898,7 +899,7 @@
  */
 static inline int cmos_poweroff(struct device *dev)
 {
-	return cmos_suspend(dev, PMSG_HIBERNATE);
+	return cmos_suspend(dev);
 }
 
 static int cmos_resume(struct device *dev)
@@ -945,9 +946,9 @@
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
+
 #else
-#define	cmos_suspend	NULL
-#define	cmos_resume	NULL
 
 static inline int cmos_poweroff(struct device *dev)
 {
@@ -1083,7 +1084,7 @@
 
 static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
 {
-	return cmos_suspend(&pnp->dev, mesg);
+	return cmos_suspend(&pnp->dev);
 }
 
 static int cmos_pnp_resume(struct pnp_dev *pnp)
@@ -1163,8 +1164,9 @@
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
 		.name		= (char *) driver_name,
-		.suspend	= cmos_suspend,
-		.resume		= cmos_resume,
+#ifdef CONFIG_PM
+		.pm		= &cmos_pm_ops,
+#endif
 	}
 };
 
