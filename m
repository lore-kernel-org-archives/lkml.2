Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1BWUoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:44:20 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:42996 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab1BWUoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:44:19 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADP/ZE1R8sEZ/2dsb2JhbACmIHS8Gw2CcYJgBA
Date: Wed, 23 Feb 2011 21:44:17 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 7/10] Generic Watchdog Timer Driver
Message-ID: <20110223204417.GA7449@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 440061eca5e843406368a4b9e39b9fdb84cdc691
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jul 18 10:44:44 2010 +0000

    watchdog: WatchDog Timer Driver Core - Part 7
    
    Add support for the Magic Close feature to the
    WatchDog Timer Driver Core framework.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
index 604fd91..158c61d 100644
--- a/Documentation/watchdog/src/watchdog-with-timer-example.c
+++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
@@ -123,6 +123,7 @@ static int wdt_set_timeout(struct watchdog_device *wdd, int new_timeout)
 static const struct watchdog_info wdt_info = {
 	.identity =	DRV_NAME,
 	.options =	WDIOF_SETTIMEOUT |
+			WDIOF_MAGICCLOSE |
 			WDIOF_KEEPALIVEPING,
 };
 
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 472bfea..036c30f 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -131,3 +131,10 @@ bit-operations. The status bit's that are defined are:
   When re-opening /dev/watchdog before a reboot occurs, you can then still use
   and ping the watchdog timer device.
   (This bit should only be used by the WatchDog Timer Driver Core).
+* WDOG_EXPECT_RELEASE: this bit stores whether or not the magic close character
+  has been sent (so that we can support the magic close feature).
+  (This bit should only be used by the WatchDog Timer Driver Core).
+
+Note: The WatchDog Timer Driver Core supports the magic close feauture. To use
+the magic close feauture you must set the WDIOF_MAGICCLOSE bit in the options
+field of the watchdog's info structure.
diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
index d3dfac2..4a99aeb 100644
--- a/drivers/watchdog/core/watchdog_dev.c
+++ b/drivers/watchdog/core/watchdog_dev.c
@@ -148,6 +148,8 @@ static int watchdog_stop(struct watchdog_device *wddev)
  *	@ppos: pointer to the file offset
  *
  *	A write to a watchdog device is defined as a keepalive ping.
+ *	Writing the magic 'V' sequence allows the next close to turn
+ *	off the watchdog.
  */
 
 static ssize_t watchdog_write(struct file *file, const char __user *data,
@@ -161,9 +163,18 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
 	if (len == 0)	/* Can we see this even ? */
 		return 0;
 
+	/* note: just in case someone wrote the magic character
+	 * five months ago... */
+	clear_bit(WDOG_EXPECT_RELEASE, &wdd->status);
+
+	/* scan to see whether or not we got the magic character */
 	for (i = 0; i != len; i++) {
 		if (get_user(c, data + i))
 			return -EFAULT;
+		if (c == 'V') {
+			set_bit(WDOG_EXPECT_RELEASE, &wdd->status);
+			dbg("received the magic character");
+		}
 	}
 
 	/* someone wrote to us, so we sent the watchdog a keepalive ping */
@@ -297,7 +308,9 @@ out:
  *      @inode: inode of device
  *      @file: file handle to device
  *
- *	This is the code for when /dev/watchdog get's closed.
+ *	This is the code for when /dev/watchdog get's closed. We will only
+ *	stop the watchdog when we have received the magic char, else the
+ *	watchdog will keep running.
  */
 
 static int watchdog_release(struct inode *inode, struct file *file)
@@ -305,9 +318,14 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	int err = -1;
 
 	trace("%p, %p", inode, file);
-
-	/* stop the watchdog */
-	err = watchdog_stop(wdd);
+	dbg("expect_release=%d", test_bit(WDOG_EXPECT_RELEASE, &wdd->status));
+
+	/* We only stop the watchdog if we received the magic character
+	 * or if WDIOF_MAGICCLOSE is not set */
+	if (test_and_clear_bit(WDOG_EXPECT_RELEASE, &wdd->status) ||
+	    !(wdd->info->options & WDIOF_MAGICCLOSE))
+		err = watchdog_stop(wdd);
+	else watchdog_ping(wdd);
 
 	/* If the watchdog stopped correctly we let the module unload again */
 	if (err == 0)
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index ba08f38..7dbb135 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -87,6 +87,7 @@ struct watchdog_device {
 					 * /dev/watchdog */
 #define WDOG_ORPHAN		2	/* is the device module still loaded
 					 * after closing /dev/watchdog */
+#define WDOG_EXPECT_RELEASE	3	/* did we receive the magic char ? */
 };
 
 /* drivers/watchdog/core/watchdog_core.c */
