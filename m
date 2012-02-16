Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2BPMRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:17:50 -0500
Received: from skyrme.org ([193.175.80.135]:33899 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab2BPMRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:17:49 -0500
Date: 16 Feb 2012 12:17:45 +0000
Message-Id: <1329394665-7238-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: wim@iguana.be
Cc: s.hauer@pengutronix.de, w.sang@pengutronix.de,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH] watchdog: make imx2_wdt report boot status correctly
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ioctl WDIOC_GETBOOTSTATUS is supposed to return some information
on why the system did (re)boot recently, value WDIOF_CARDRESET
being used to indicate watchdog induced reboot.

Up to now, imx2_wdt did not provide a value here, always returning
zero to indicate normal boot.

Do evaluate the IMX Watchdog Reset Status Register and
produce WDIOF_CARDRESET with WDIOC_GETBOOTSTATUS in case
of a watchdog induced reset.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 drivers/watchdog/imx2_wdt.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index c44c333..940fd43 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -46,6 +46,9 @@
 #define IMX2_WDT_SEQ1		0x5555		/* -> service sequence 1 */
 #define IMX2_WDT_SEQ2		0xAAAA		/* -> service sequence 2 */
 
+#define IMX2_WDT_WRSR		0x04		/* Reset Status Register */
+#define IMX2_WDT_WRSR_TOUT	(1 << 1)	/* -> Reset due to Timeout */
+
 #define IMX2_WDT_MAX_TIME	128
 #define IMX2_WDT_DEFAULT_TIME	60		/* in seconds */
 
@@ -175,6 +178,7 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_value;
+	u16 val;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
@@ -182,9 +186,15 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
 			sizeof(struct watchdog_info)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 
+	case WDIOC_GETBOOTSTATUS:
+		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
+		new_value = 0;
+		if (val & IMX2_WDT_WRSR_TOUT)
+			new_value = WDIOF_CARDRESET;
+		return put_user(new_value, p);
+
 	case WDIOC_KEEPALIVE:
 		imx2_wdt_ping();
 		return 0;
-- 
1.7.5.4

