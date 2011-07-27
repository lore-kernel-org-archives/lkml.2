Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1G0URk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:17:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:35090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754821Ab1G0URg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:17:36 -0400
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 6/9] watchdog: WatchDog Timer Driver Core - Add Magic Close feature
Date: Wed, 27 Jul 2011 20:16:37 +0000
Message-Id: <1311797800-2706-6-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311797800-2706-1-git-send-email-wim@iguana.be>
References: <20110727201537.GA13819@infomag.iguana.be>
 <1311797800-2706-1-git-send-email-wim@iguana.be>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Jul 2011 20:17:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Magic Close feature to the
WatchDog Timer Driver Core framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    7 ++++++
 drivers/watchdog/watchdog_dev.c                |   27 +++++++++++++++++++++--
 include/linux/watchdog.h                       |    1 +
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index acdee39..41d5526 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -127,6 +127,13 @@ bit-operations. The status bits that are defined are:
 * WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
   was opened via /dev/watchdog.
   (This bit should only be used by the WatchDog Timer Driver Core).
+* WDOG_ALLOW_RELEASE: this bit stores whether or not the magic close character
+  has been sent (so that we can support the magic close feature).
+  (This bit should only be used by the WatchDog Timer Driver Core).
+
+Note: The WatchDog Timer Driver Core supports the magic close feature. To use
+the magic close feature you must set the WDIOF_MAGICCLOSE bit in the options
+field of the watchdog's info structure.
 
 To get or set driver specific data the following two helper functions should be
 used:
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 2c0289d..db40c6c 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -122,6 +122,8 @@ static int watchdog_stop(struct watchdog_device *wddev)
  *	@ppos: pointer to the file offset
  *
  *	A write to a watchdog device is defined as a keepalive ping.
+ *	Writing the magic 'V' sequence allows the next close to turn
+ *	off the watchdog.
  */
 
 static ssize_t watchdog_write(struct file *file, const char __user *data,
@@ -133,9 +135,18 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
 	if (len == 0)
 		return 0;
 
+	/*
+	 * Note: just in case someone wrote the magic character
+	 * five months ago...
+	 */
+	clear_bit(WDOG_ALLOW_RELEASE, &wdd->status);
+
+	/* scan to see whether or not we got the magic character */
 	for (i = 0; i != len; i++) {
 		if (get_user(c, data + i))
 			return -EFAULT;
+		if (c == 'V')
+			set_bit(WDOG_ALLOW_RELEASE, &wdd->status);
 	}
 
 	/* someone wrote to us, so we send the watchdog a keepalive ping */
@@ -259,14 +270,24 @@ out:
  *      @inode: inode of device
  *      @file: file handle to device
  *
- *	This is the code for when /dev/watchdog gets closed.
+ *	This is the code for when /dev/watchdog gets closed. We will only
+ *	stop the watchdog when we have received the magic char, else the
+ *	watchdog will keep running.
  */
 
 static int watchdog_release(struct inode *inode, struct file *file)
 {
-	int err;
+	int err = -EBUSY;
+
+	/*
+	 * We only stop the watchdog if we received the magic character
+	 * or if WDIOF_MAGICCLOSE is not set
+	 */
+	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
+	    !(wdd->info->options & WDIOF_MAGICCLOSE))
+		err = watchdog_stop(wdd);
 
-	err = watchdog_stop(wdd);
+	/* If the watchdog was not stopped, send a keepalive ping */
 	if (err < 0) {
 		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
 		watchdog_ping(wdd);
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 9f33efe..e9881ca 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -112,6 +112,7 @@ struct watchdog_device {
 /* Bit numbers for status flags */
 #define WDOG_ACTIVE		0	/* Is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
+#define WDOG_ALLOW_RELEASE	2	/* Did we receive the magic char ? */
 };
 
 /* Use the following functions to manipulate watchdog driver specific data */
-- 
1.7.6

