Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1K2LSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:18:06 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:10336 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751663Ab1K2LSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:18:03 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPO+1E5R8sT5/2dsb2JhbABDqnSBBoIgExwjGBFMJQMhE4gHtyMSiiljBJRTkhM
Date: Tue, 29 Nov 2011 12:14:30 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Marc Vertes <marc.vertes@sigfox.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: [PATCH] watchdog: add nowayout helpers to Watchdog Timer Driver
	Kernel API
Message-ID: <20111129111430.GA17609@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two nowayout helpers for the Watchdog Timer Driver Kernel API.

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
diff --git a/Documentation/watchdog/00-INDEX b/Documentation/watchdog/00-INDEX
index fc51128..fc9082a 100644
--- a/Documentation/watchdog/00-INDEX
+++ b/Documentation/watchdog/00-INDEX
@@ -1,5 +1,7 @@
 00-INDEX
 	- this file.
+convert_drivers_to_kernel_api.txt
+	- how-to for converting old watchdog drivers to the new kernel API.
 hpwdt.txt
 	- information on the HP iLO2 NMI watchdog
 pcwd-watchdog.txt
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 4f7c894..1c443fe 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -1,6 +1,6 @@
 The Linux WatchDog Timer Driver Core kernel API.
 ===============================================
-Last reviewed: 22-Jul-2011
+Last reviewed: 29-Nov-2011
 
 Wim Van Sebroeck <wim@iguana.be>
 
@@ -142,6 +142,14 @@ bit-operations. The status bits that are defined are:
 * WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
   If this bit is set then the watchdog timer will not be able to stop.
 
+To set the WDOG_NO_WAY_OUT status bit (before registering your watchdog
+timer device) you can either:
+* set it statically in your watchdog_device struct with
+	.status = WATCHDOG_NOWAYOUT_INIT_STATUS,
+  (this will set the value the same as CONFIG_WATCHDOG_NOWAYOUT) or
+* use the following helper function:
+static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
+
 Note: The WatchDog Timer Driver Core supports the magic close feature and
 the nowayout feature. To use the magic close feature you must set the
 WDIOF_MAGICCLOSE bit in the options field of the watchdog's info structure.
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 111843f..43ba5b3 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -53,11 +53,7 @@ struct watchdog_info {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_WATCHDOG_NOWAYOUT
-#define WATCHDOG_NOWAYOUT	1
-#else
-#define WATCHDOG_NOWAYOUT	0
-#endif
+#include <linux/bitops.h>
 
 struct watchdog_ops;
 struct watchdog_device;
@@ -122,6 +118,21 @@ struct watchdog_device {
 #define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
 };
 
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+#define WATCHDOG_NOWAYOUT		1
+#define WATCHDOG_NOWAYOUT_INIT_STATUS	(1 << WDOG_NO_WAY_OUT)
+#else
+#define WATCHDOG_NOWAYOUT		0
+#define WATCHDOG_NOWAYOUT_INIT_STATUS	0
+#endif
+
+/* Use the following function to set the nowayout feature */
+static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
+{
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &wdd->status);
+}
+
 /* Use the following functions to manipulate watchdog driver specific data */
 static inline void watchdog_set_drvdata(struct watchdog_device *wdd, void *data)
 {
