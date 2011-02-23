Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1BWUom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:44:42 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:28887 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab1BWUol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:44:41 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAPf+ZE1R8sEZ/2dsb2JhbACmIHS8Hg2FUQQ
Date: Wed, 23 Feb 2011 21:44:36 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 8/10] Generic Watchdog Timer Driver
Message-ID: <20110223204436.GA7465@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5752d34c58c9b654c2fa753b94acc67602836420
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jul 18 10:51:52 2010 +0000

    watchdog: WatchDog Timer Driver Core - Part 8
    
    Add support for the nowayout feature to the
    WatchDog Timer Driver Core framework.
    This feature prevents the watchdog timer from being
    stopped.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
index 158c61d..8ba5d5f 100644
--- a/Documentation/watchdog/src/watchdog-with-timer-example.c
+++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
@@ -45,6 +45,11 @@ module_param(timeout, int, 0);
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
@@ -152,6 +157,8 @@ static int __devinit wdt_probe(struct platform_device *pdev)
 
 	/* Set watchdog_device parameters */
 	wdt_dev.timeout = timeout;
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &wdt_dev.status);
 
 	/* Register the watchdog timer device */
 	res = register_watchdogdevice(&wdt_dev);
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 036c30f..91c4299 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -57,8 +57,8 @@ It contains following fields:
   WDIOF_* status bits).
 * status: this field contains a number of status bits that give extra
   information about the status of the device (Like: is the watchdog timer
-  running/active, is the device opened via the /dev/watchdog interface or not,
-  ...)
+  running/active, is the nowayout bit set, is the device opened via
+  the /dev/watchdog interface or not, ...)
 
 The list of watchdog operations is defined as:
 
@@ -123,6 +123,8 @@ bit-operations. The status bit's that are defined are:
   is active or not. When the watchdog is active after booting, then you should
   set this status bit (Note: when you register the watchdog timer device with
   this bit set, then opening /dev/watchdog will skip the start operation)
+* WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
+  If this bit is set then the watchdog timer will not be able to stop.
 * WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
   was opened via /dev/watchdog.
   (This bit should only be used by the WatchDog Timer Driver Core).
@@ -135,6 +137,6 @@ bit-operations. The status bit's that are defined are:
   has been sent (so that we can support the magic close feature).
   (This bit should only be used by the WatchDog Timer Driver Core).
 
-Note: The WatchDog Timer Driver Core supports the magic close feauture. To use
-the magic close feauture you must set the WDIOF_MAGICCLOSE bit in the options
-field of the watchdog's info structure.
+Note: The WatchDog Timer Driver Core supports the nowayout feature and the
+magic close feauture. To use the magic close feauture you must set the
+WDIOF_MAGICCLOSE bit in the options field of the watchdog's info structure.
diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
index 4a99aeb..76be752 100644
--- a/drivers/watchdog/core/watchdog_dev.c
+++ b/drivers/watchdog/core/watchdog_dev.c
@@ -124,11 +124,15 @@ static int watchdog_start(struct watchdog_device *wddev)
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
@@ -149,7 +153,7 @@ static int watchdog_stop(struct watchdog_device *wddev)
  *
  *	A write to a watchdog device is defined as a keepalive ping.
  *	Writing the magic 'V' sequence allows the next close to turn
- *	off the watchdog.
+ *	off the watchdog (if 'nowayout' is not set).
  */
 
 static ssize_t watchdog_write(struct file *file, const char __user *data,
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 7dbb135..40ed78c 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -88,6 +88,7 @@ struct watchdog_device {
 #define WDOG_ORPHAN		2	/* is the device module still loaded
 					 * after closing /dev/watchdog */
 #define WDOG_EXPECT_RELEASE	3	/* did we receive the magic char ? */
+#define WDOG_NO_WAY_OUT		4	/* is 'nowayout' feature set ? */
 };
 
 /* drivers/watchdog/core/watchdog_core.c */
