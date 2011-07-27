Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab1G0URb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:17:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:35084 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1G0UR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:17:28 -0400
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 7/9] watchdog: WatchDog Timer Driver Core - Add nowayout feature
Date: Wed, 27 Jul 2011 20:16:38 +0000
Message-Id: <1311797800-2706-7-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311797800-2706-1-git-send-email-wim@iguana.be>
References: <20110727201537.GA13819@infomag.iguana.be>
 <1311797800-2706-1-git-send-email-wim@iguana.be>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jul 2011 20:17:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the nowayout feature to the
WatchDog Timer Driver Core framework.
This feature prevents the watchdog timer from being
stopped.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/watchdog/watchdog-kernel-api.txt |   13 ++++++++-----
 drivers/watchdog/watchdog_dev.c                |   18 +++++++++++++-----
 include/linux/watchdog.h                       |    1 +
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 41d5526..785fa0c 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -59,8 +59,8 @@ It contains following fields:
   watchdog_get_drvdata routines.
 * status: this field contains a number of status bits that give extra
   information about the status of the device (Like: is the watchdog timer
-  running/active, is the device opened via the /dev/watchdog interface or not,
-  ...).
+  running/active, is the nowayout bit set, is the device opened via
+  the /dev/watchdog interface or not, ...).
 
 The list of watchdog operations is defined as:
 
@@ -130,10 +130,13 @@ bit-operations. The status bits that are defined are:
 * WDOG_ALLOW_RELEASE: this bit stores whether or not the magic close character
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
+The nowayout feature will overrule the magic close feature.
 
 To get or set driver specific data the following two helper functions should be
 used:
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index db40c6c..ac20f92 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -98,11 +98,18 @@ static int watchdog_start(struct watchdog_device *wddev)
  *	Stop the watchdog if it is still active and unmark it active.
  *	This function returns zero on success or a negative errno code for
  *	failure.
+ *	If the 'nowayout' feature was set, the watchdog cannot be stopped.
  */
 
 static int watchdog_stop(struct watchdog_device *wddev)
 {
-	int err;
+	int err = -EBUSY;
+
+	if (test_bit(WDOG_NO_WAY_OUT, &wdd->status)) {
+		pr_info("%s: nowayout prevents watchdog to be stopped!\n",
+							wdd->info->identity);
+		return err;
+	}
 
 	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
 		err = wddev->ops->stop(wddev);
@@ -123,7 +130,7 @@ static int watchdog_stop(struct watchdog_device *wddev)
  *
  *	A write to a watchdog device is defined as a keepalive ping.
  *	Writing the magic 'V' sequence allows the next close to turn
- *	off the watchdog.
+ *	off the watchdog (if 'nowayout' is not set).
  */
 
 static ssize_t watchdog_write(struct file *file, const char __user *data,
@@ -271,8 +278,8 @@ out:
  *      @file: file handle to device
  *
  *	This is the code for when /dev/watchdog gets closed. We will only
- *	stop the watchdog when we have received the magic char, else the
- *	watchdog will keep running.
+ *	stop the watchdog when we have received the magic char (and nowayout
+ *	was not set), else the watchdog will keep running.
  */
 
 static int watchdog_release(struct inode *inode, struct file *file)
@@ -281,7 +288,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 
 	/*
 	 * We only stop the watchdog if we received the magic character
-	 * or if WDIOF_MAGICCLOSE is not set
+	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
+	 * watchdog_stop will fail.
 	 */
 	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
 	    !(wdd->info->options & WDIOF_MAGICCLOSE))
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index e9881ca..f719883 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -113,6 +113,7 @@ struct watchdog_device {
 #define WDOG_ACTIVE		0	/* Is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
 #define WDOG_ALLOW_RELEASE	2	/* Did we receive the magic char ? */
+#define WDOG_NO_WAY_OUT		3	/* Is 'nowayout' feature set ? */
 };
 
 /* Use the following functions to manipulate watchdog driver specific data */
-- 
1.7.6

