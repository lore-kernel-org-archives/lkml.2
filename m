Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1FWRdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:33:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:65216 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab1FWR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:29:46 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Paul Fox <pgf@laptop.org>,
        Daniel Drake <dsd@laptop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 048/247] rtc-cmos: fix suspend/resume
Date: Thu, 23 Jun 2011 13:25:47 -0400
Message-Id: <1308850146-15061-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850146-15061-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/rtc/rtc-cmos.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index aa13875..af5fd61 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/log2.h>
+#include <linux/pm.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -851,7 +852,7 @@ static void __exit cmos_do_remove(struct device *dev)
 
 #ifdef	CONFIG_PM
 
-static int cmos_suspend(struct device *dev, pm_message_t mesg)
+static int cmos_suspend(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	tmp;
@@ -899,7 +900,7 @@ static int cmos_suspend(struct device *dev, pm_message_t mesg)
  */
 static inline int cmos_poweroff(struct device *dev)
 {
-	return cmos_suspend(dev, PMSG_HIBERNATE);
+	return cmos_suspend(dev);
 }
 
 static int cmos_resume(struct device *dev)
@@ -946,9 +947,9 @@ static int cmos_resume(struct device *dev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
+
 #else
-#define	cmos_suspend	NULL
-#define	cmos_resume	NULL
 
 static inline int cmos_poweroff(struct device *dev)
 {
@@ -1084,7 +1085,7 @@ static void __exit cmos_pnp_remove(struct pnp_dev *pnp)
 
 static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
 {
-	return cmos_suspend(&pnp->dev, mesg);
+	return cmos_suspend(&pnp->dev);
 }
 
 static int cmos_pnp_resume(struct pnp_dev *pnp)
@@ -1164,8 +1165,9 @@ static struct platform_driver cmos_platform_driver = {
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
 
-- 
1.7.4.4

