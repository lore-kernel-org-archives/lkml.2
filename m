Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1FRRYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:24:50 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:3706 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab1FRRYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:24:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFXe/E1tgyeh/2dsb2JhbABFDaZeeIh1vRIOgxCDDAShYQ
Date: Sat, 18 Jun 2011 19:24:47 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172447.GG3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 6

Add support for the Magic Close feature to the
WatchDog Timer Driver Core framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part5/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part6/Documentation/watchdog/src/watchdog-with-timer-example.c
--- linux-2.6.38-generic-part5/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:13:58.331178125 +0200
+++ linux-2.6.38-generic-part6/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 21:04:06.283940741 +0200
@@ -123,6 +123,7 @@
 static const struct watchdog_info wdt_info = {
 	.identity =	DRV_NAME,
 	.options =	WDIOF_SETTIMEOUT |
+			WDIOF_MAGICCLOSE |
 			WDIOF_KEEPALIVEPING,
 };
 
diff -urN linux-2.6.38-generic-part5/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part6/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part5/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 20:09:01.759178229 +0200
+++ linux-2.6.38-generic-part6/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 21:04:06.287940722 +0200
@@ -126,3 +126,10 @@
 * WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
   was opened via /dev/watchdog.
   (This bit should only be used by the WatchDog Timer Driver Core).
+* WDOG_EXPECT_RELEASE: this bit stores whether or not the magic close character
+  has been sent (so that we can support the magic close feature).
+  (This bit should only be used by the WatchDog Timer Driver Core).
+
+Note: The WatchDog Timer Driver Core supports the magic close feature. To use
+the magic close feature you must set the WDIOF_MAGICCLOSE bit in the options
+field of the watchdog's info structure.
diff -urN linux-2.6.38-generic-part5/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part6/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part5/drivers/watchdog/core/watchdog_dev.c	2011-06-16 20:09:01.759178229 +0200
+++ linux-2.6.38-generic-part6/drivers/watchdog/core/watchdog_dev.c	2011-06-16 22:52:56.763937624 +0200
@@ -150,6 +150,8 @@
  *	@ppos: pointer to the file offset
  *
  *	A write to a watchdog device is defined as a keepalive ping.
+ *	Writing the magic 'V' sequence allows the next close to turn
+ *	off the watchdog.
  */
 
 static ssize_t watchdog_write(struct file *file, const char __user *data,
@@ -163,9 +165,18 @@
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
@@ -294,7 +305,9 @@
  *      @inode: inode of device
  *      @file: file handle to device
  *
- *	This is the code for when /dev/watchdog get's closed.
+ *	This is the code for when /dev/watchdog get's closed. We will only
+ *	stop the watchdog when we have received the magic char, else the
+ *	watchdog will keep running.
  */
 
 static int watchdog_release(struct inode *inode, struct file *file)
@@ -302,9 +315,15 @@
 	int err = -1;
 
 	trace("%p, %p", inode, file);
+	dbg("expect_release=%d", test_bit(WDOG_EXPECT_RELEASE, &wdd->status));
+
+	/* We only stop the watchdog if we received the magic character
+	 * or if WDIOF_MAGICCLOSE is not set */
+	if (test_and_clear_bit(WDOG_EXPECT_RELEASE, &wdd->status) ||
+	    !(wdd->info->options & WDIOF_MAGICCLOSE))
+		err = watchdog_stop(wdd);
 
-	/* stop the watchdog */
-	err = watchdog_stop(wdd);
+	/* If the watchdog was not stopped, sent a keepalive ping */
 	if (err < 0) {
 		pr_crit("%s: not stopping watchdog!\n", wdd->name);
 		watchdog_ping(wdd);
diff -urN linux-2.6.38-generic-part5/include/linux/watchdog.h linux-2.6.38-generic-part6/include/linux/watchdog.h
--- linux-2.6.38-generic-part5/include/linux/watchdog.h	2011-06-16 20:09:01.759178229 +0200
+++ linux-2.6.38-generic-part6/include/linux/watchdog.h	2011-06-17 12:17:15.285063678 +0200
@@ -85,6 +85,7 @@
 #define WDOG_ACTIVE		0	/* is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
 					 * /dev/watchdog */
+#define WDOG_EXPECT_RELEASE	2	/* did we receive the magic char ? */
 };
 
 /* drivers/watchdog/core/watchdog_core.c */
