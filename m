Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab1FRRZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:25:42 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:2031 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab1FRRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:25:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFXe/E1tgyeh/2dsb2JhbABSpl54iHW9Eg6GHAShYQ
Date: Sat, 18 Jun 2011 19:25:37 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 7/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172537.GH3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 7

Add support for the nowayout feature to the
WatchDog Timer Driver Core framework.
This feature prevents the watchdog timer from being
stopped.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part6/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part7/Documentation/watchdog/src/watchdog-with-timer-example.c
--- linux-2.6.38-generic-part6/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 21:04:06.283940741 +0200
+++ linux-2.6.38-generic-part7/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-17 09:52:32.866632635 +0200
@@ -45,6 +45,11 @@
 MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
 	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
 
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started. "
+	"(default = " __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
 static struct watchdog_device wdt_dev;
 static void wdt_timer_tick(unsigned long data);
 static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
@@ -152,6 +157,8 @@
 
 	/* Set watchdog_device parameters */
 	wdt_dev.timeout = timeout;
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &wdt_dev.status);
 
 	/* Register the watchdog timer device */
 	res = watchdog_register_device(&wdt_dev);
diff -urN linux-2.6.38-generic-part6/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part7/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part6/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 21:04:06.287940722 +0200
+++ linux-2.6.38-generic-part7/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-17 09:58:20.754629453 +0200
@@ -57,8 +57,8 @@
   WDIOF_* status bits).
 * status: this field contains a number of status bits that give extra
   information about the status of the device (Like: is the watchdog timer
-  running/active, is the device opened via the /dev/watchdog interface or not,
-  ...)
+  running/active, is the nowayout bit set, is the device opened via
+  the /dev/watchdog interface or not, ...)
 
 The list of watchdog operations is defined as:
 
@@ -129,7 +129,9 @@
 * WDOG_EXPECT_RELEASE: this bit stores whether or not the magic close character
   has been sent (so that we can support the magic close feature).
   (This bit should only be used by the WatchDog Timer Driver Core).
+* WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
+  If this bit is set then the watchdog timer will not be able to stop.
 
-Note: The WatchDog Timer Driver Core supports the magic close feature. To use
-the magic close feature you must set the WDIOF_MAGICCLOSE bit in the options
-field of the watchdog's info structure.
+Note: The WatchDog Timer Driver Core supports the magic close feature and
+the nowayout feature. To use the magic close feature you must set the
+WDIOF_MAGICCLOSE bit in the options field of the watchdog's info structure.
diff -urN linux-2.6.38-generic-part6/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part7/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part6/drivers/watchdog/core/watchdog_dev.c	2011-06-16 22:52:56.763937624 +0200
+++ linux-2.6.38-generic-part7/drivers/watchdog/core/watchdog_dev.c	2011-06-17 09:52:32.870632731 +0200
@@ -126,11 +126,15 @@
  *	Stop the watchdog if it is still active and unmark it active.
  *	This function returns zero on success or a negative errno code for
  *	failure.
+ *	If the 'nowayout' feature was set, the watchdog cannot be stopped.
  */
 
 static int watchdog_stop(struct watchdog_device *wddev)
 {
-	int err;
+	int err = -1;
+
+	if (test_bit(WDOG_NO_WAY_OUT, &wdd->status))
+		return err;
 
 	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
 		err = wddev->ops->stop(wddev);
@@ -151,7 +155,7 @@
  *
  *	A write to a watchdog device is defined as a keepalive ping.
  *	Writing the magic 'V' sequence allows the next close to turn
- *	off the watchdog.
+ *	off the watchdog (if 'nowayout' is not set).
  */
 
 static ssize_t watchdog_write(struct file *file, const char __user *data,
diff -urN linux-2.6.38-generic-part6/include/linux/watchdog.h linux-2.6.38-generic-part7/include/linux/watchdog.h
--- linux-2.6.38-generic-part6/include/linux/watchdog.h	2011-06-17 12:17:15.285063678 +0200
+++ linux-2.6.38-generic-part7/include/linux/watchdog.h	2011-06-17 12:17:39.205063756 +0200
@@ -86,6 +86,7 @@
 #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
 					 * /dev/watchdog */
 #define WDOG_EXPECT_RELEASE	2	/* did we receive the magic char ? */
+#define WDOG_NO_WAY_OUT		3	/* is 'nowayout' feature set ? */
 };
 
 /* drivers/watchdog/core/watchdog_core.c */
