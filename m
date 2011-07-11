Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab1GKOWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:22:47 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:63714 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801Ab1GKOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:22:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIMFG05tg34q/2dsb2JhbABGDac5eIh8v0AOgxWDFwSSVJBJ
Date: Mon, 11 Jul 2011 16:22:43 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/11] watchdog: WatchDog Timer Driver Core - Add Magic
	Close feature
Message-ID: <1310392522-9949-6-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310392522-9949-1-git-send-email-wim@iguana.be>
X-Mailer: git-send-email 1.7.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Magic Close feature to the
WatchDog Timer Driver Core framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 Documentation/watchdog/watchdog-kernel-api.txt |    7 ++++++
 drivers/watchdog/watchdog_dev.c                |   28 ++++++++++++++++++++---
 include/linux/watchdog.h                       |    1 +
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index 3085c5c..8e5867c 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -125,3 +125,10 @@ bit-operations. The status bits that are defined are:
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
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 0d4b16d..c9ab89e 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -133,6 +133,8 @@ static int watchdog_stop(struct watchdog_device *wddev)
  *	@ppos: pointer to the file offset
  *
  *	A write to a watchdog device is defined as a keepalive ping.
+ *	Writing the magic 'V' sequence allows the next close to turn
+ *	off the watchdog.
  */
 
 static ssize_t watchdog_write(struct file *file, const char __user *data,
@@ -144,9 +146,18 @@ static ssize_t watchdog_write(struct file *file, const char __user *data,
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
@@ -272,15 +283,24 @@ out:
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
 
-	/* stop the watchdog */
-	err = watchdog_stop(wdd);
+	/* If the watchdog was not stopped, sent a keepalive ping */
 	if (err < 0) {
 		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
 		watchdog_ping(wdd);
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index 7e37fdf..8406ed5 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -85,6 +85,7 @@ struct watchdog_device {
 /* Bit numbers for status flags */
 #define WDOG_ACTIVE		0	/* Is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* Opened via /dev/watchdog ? */
+#define WDOG_ALLOW_RELEASE	2	/* Did we receive the magic char ? */
 };
 
 /* drivers/watchdog/core/watchdog_core.c */
-- 
1.7.6

