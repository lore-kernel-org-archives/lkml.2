Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1BWUn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:43:59 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:6042 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839Ab1BWUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:43:58 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAHEAZU1R8sEZ/2dsb2JhbACmIHS8Fw2FUQQ
Date: Wed, 23 Feb 2011 21:43:51 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 6/10] Generic Watchdog Timer Driver
Message-ID: <20110223204350.GA7433@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit afe3de93859443b575407f39a2e655956c02e088
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jul 18 10:39:00 2010 +0000

    watchdog: WatchDog Timer Driver Core - Part 6
    
    Since we don't want that a driver module can be removed
    while the watchdog timer is still active, we lock the
    driver module (by incremeting the reference counter).
    After a clean close of the watchdog driver we unlock the
    driver module.
    If /dev/watchdog is closed uncleanly (and the watchdog is
    still active) then we do not unlock the driver module,
    but keep it, so that next time /dev/watchdog get's opened
    we can continue triggering the watchdog.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
index f1d4f217..604fd91 100644
--- a/Documentation/watchdog/src/watchdog-with-timer-example.c
+++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
@@ -127,6 +127,7 @@ static const struct watchdog_info wdt_info = {
 };
 
 static const struct watchdog_ops wdt_ops = {
+	.owner =	THIS_MODULE,
 	.start =	wdt_start,
 	.stop =		wdt_stop,
 	.ping =		wdt_ping,
diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index f15e8d4..472bfea 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -63,6 +63,7 @@ It contains following fields:
 The list of watchdog operations is defined as:
 
 struct watchdog_ops {
+	struct module *owner;
 	/* mandatory operations */
 	int (*start)(struct watchdog_device *);
 	int (*stop)(struct watchdog_device *);
@@ -72,6 +73,10 @@ struct watchdog_ops {
 	int (*set_timeout)(struct watchdog_device *, int);
 };
 
+It is important that you first define the module owner of the watchdog timer
+driver's operations. This module owner will be used to lock the module when
+the watchdog is active. (You don't want to unload the module when you're
+watchdog timer device is still active).
 Some operations are mandatory and some are optional. The mandatory operations
 are:
 * start: this is a pointer to the routine that starts the watchdog timer
@@ -121,3 +126,8 @@ bit-operations. The status bit's that are defined are:
 * WDOG_DEV_OPEN: this status bit shows whether or not the watchdog device
   was opened via /dev/watchdog.
   (This bit should only be used by the WatchDog Timer Driver Core).
+* WDOG_ORPHAN: when /dev/watchdog was closed, but the watchdog is still active
+  then we don't unload the module. This bit is set when this situation occurs.
+  When re-opening /dev/watchdog before a reboot occurs, you can then still use
+  and ping the watchdog timer device.
+  (This bit should only be used by the WatchDog Timer Driver Core).
diff --git a/drivers/watchdog/core/watchdog_core.c b/drivers/watchdog/core/watchdog_core.c
index 52bc520..d1a824e 100644
--- a/drivers/watchdog/core/watchdog_core.c
+++ b/drivers/watchdog/core/watchdog_core.c
@@ -60,6 +60,10 @@ int register_watchdogdevice(struct watchdog_device *wdd)
 	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
 		return -ENODATA;
 
+	/* Make sure that the owner of the watchdog operations exists */
+	if (wdd->ops->owner == NULL)
+		return -ENODATA;
+
 	/* Make sure that the mandatory operations are supported */
 	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
 		return -ENODATA;
diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
index b80c6e6..d3dfac2 100644
--- a/drivers/watchdog/core/watchdog_dev.c
+++ b/drivers/watchdog/core/watchdog_dev.c
@@ -259,7 +259,7 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 
 static int watchdog_open(struct inode *inode, struct file *file)
 {
-	int err;
+	int err = -EBUSY;
 
 	trace("%p, %p", inode, file);
 
@@ -267,14 +267,26 @@ static int watchdog_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(WDOG_DEV_OPEN, &wdd->status))
 		return -EBUSY;
 
+	/* if the /dev/watchdog device is open, we don't want the module
+	 * to be unloaded. */
+	if (!try_module_get(wdd->ops->owner))
+		goto out;
+
 	/* start the watchdog */
 	err = watchdog_start(wdd);
 	if (err < 0)
-		goto out;
+		goto out_mod;
+
+	/* We leaked a reference to lock the module in on close
+	 * now we can reclaim it as we re-opened before triggering */
+	if (test_and_clear_bit(WDOG_ORPHAN, &wdd->status))
+		module_put(wdd->ops->owner);
 
 	/* dev/watchdog is a virtual (and thus non-seekable) filesystem */
 	return nonseekable_open(inode, file);
 
+out_mod:
+	module_put(wdd->ops->owner);
 out:
 	clear_bit(WDOG_DEV_OPEN, &wdd->status);
 	return err;
@@ -296,8 +308,13 @@ static int watchdog_release(struct inode *inode, struct file *file)
 
 	/* stop the watchdog */
 	err = watchdog_stop(wdd);
-	if (err < 0) {
+
+	/* If the watchdog stopped correctly we let the module unload again */
+	if (err == 0)
+		module_put(wdd->ops->owner);
+	else {	/* If not we deliberately leak a module reference */
 		printk(KERN_CRIT "%s: not stopping watchdog!\n", wdd->name);
+		set_bit(WDOG_ORPHAN, &wdd->status);
 		watchdog_ping(wdd);
 	}
 
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index e35f51f..ba08f38 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -64,6 +64,7 @@ struct watchdog_device;
 
 /* The watchdog-devices operations */
 struct watchdog_ops {
+	struct module *owner;
 	/* mandatory operations */
 	int (*start)(struct watchdog_device *);
 	int (*stop)(struct watchdog_device *);
@@ -84,6 +85,8 @@ struct watchdog_device {
 #define WDOG_ACTIVE		0	/* is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
 					 * /dev/watchdog */
+#define WDOG_ORPHAN		2	/* is the device module still loaded
+					 * after closing /dev/watchdog */
 };
 
 /* drivers/watchdog/core/watchdog_core.c */
