Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab1FRRYB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:24:01 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:47982 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab1FRRX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:23:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANjd/E1tgyeh/2dsb2JhbABFDaZeeIh1vREOgxCDDAShYQ
Date: Sat, 18 Jun 2011 19:23:57 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172357.GF3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 5

This part add's the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
functionality to the WatchDog Timer Driver Core framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part4/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part5/Documentation/watchdog/src/watchdog-with-timer-example.c
--- linux-2.6.38-generic-part4/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:08:16.987178248 +0200
+++ linux-2.6.38-generic-part5/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:13:58.331178125 +0200
@@ -110,12 +110,20 @@
 	return 0;
 }
 
+static int wdt_set_timeout(struct watchdog_device *wdd, int new_timeout)
+{
+	if (new_timeout < 1)
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * The watchdog kernel structures
  */
 static const struct watchdog_info wdt_info = {
 	.identity =	DRV_NAME,
-	.options =	WDIOF_KEEPALIVEPING,
+	.options =	WDIOF_SETTIMEOUT |
+			WDIOF_KEEPALIVEPING,
 };
 
 static const struct watchdog_ops wdt_ops = {
@@ -123,6 +131,7 @@
 	.start =	wdt_start,
 	.stop =		wdt_stop,
 	.ping =		wdt_ping,
+	.set_timeout =	wdt_set_timeout,
 };
 
 static struct watchdog_device wdt_dev = {
@@ -140,6 +149,9 @@
 
 	/* Register other stuff */
 
+	/* Set watchdog_device parameters */
+	wdt_dev.timeout = timeout;
+
 	/* Register the watchdog timer device */
 	res = watchdog_register_device(&wdt_dev);
 	if (res) {
diff -urN linux-2.6.38-generic-part4/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part5/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part4/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 19:14:34.603180137 +0200
+++ linux-2.6.38-generic-part5/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 20:09:01.759178229 +0200
@@ -42,6 +42,7 @@
 	char *name;
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
+	int timeout;
 	int bootstatus;
 	long status;
 };
@@ -51,6 +52,7 @@
 * info: a pointer to a watchdog_info structure. This structure gives some
   additional information about the watchdog timer itself.
 * ops: a pointer to the list of watchdog operations that the watchdog supports.
+* timeout: the watchdog timer's timeout value (in seconds).
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
 * status: this field contains a number of status bits that give extra
@@ -68,6 +70,7 @@
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
 	int (*status)(struct watchdog_device *);
+	int (*set_timeout)(struct watchdog_device *, int);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -107,6 +110,12 @@
   info structure).
 * status: this routine checks the status of the watchdog timer device. The
   status of the device is reported with watchdog WDIOF_* status flags/bits.
+* set_timeout: this routine checks and changes the timeout of the watchdog
+  timer device. It returns 0 on success and an errno code on failure. On success
+  the timeout value of the watchdog_device will be changed to the value that
+  was just used to re-program the watchdog timer device.
+  (Note: the WDIOF_SETTIMEOUT needs to be set in the options field of the
+  watchdog's info structure).
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bit's that are defined are:
diff -urN linux-2.6.38-generic-part4/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part5/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part4/drivers/watchdog/core/watchdog_dev.c	2011-06-16 19:36:11.571178880 +0200
+++ linux-2.6.38-generic-part5/drivers/watchdog/core/watchdog_dev.c	2011-06-16 20:09:01.759178229 +0200
@@ -223,6 +223,26 @@
 			return -EOPNOTSUPP;
 		watchdog_ping(wdd);
 		return 0;
+	case WDIOC_SETTIMEOUT:
+		if ((wdd->ops->set_timeout == NULL) ||
+		    !(wdd->info->options & WDIOF_SETTIMEOUT))
+			return -EOPNOTSUPP;
+		if (get_user(val, p))
+			return -EFAULT;
+		err = wdd->ops->set_timeout(wdd, val);
+		if (err < 0)
+			return err;
+		wdd->timeout = val;
+		/* If the watchdog is active then we sent a keepalive ping
+		 * to make sure that the watchdog keep's running (and if
+		 * possible that it takes the new timeout) */
+		watchdog_ping(wdd);
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		/* timeout == 0 means that we don't know the timeout */
+		if (wdd->timeout)
+			return put_user(wdd->timeout, p);
+		return -EOPNOTSUPP;
 	default:
 		return -ENOTTY;
 	}
diff -urN linux-2.6.38-generic-part4/include/linux/watchdog.h linux-2.6.38-generic-part5/include/linux/watchdog.h
--- linux-2.6.38-generic-part4/include/linux/watchdog.h	2011-06-16 19:14:34.603180137 +0200
+++ linux-2.6.38-generic-part5/include/linux/watchdog.h	2011-06-16 20:09:01.759178229 +0200
@@ -71,6 +71,7 @@
 	/* optional operations */
 	int (*ping)(struct watchdog_device *);
 	int (*status)(struct watchdog_device *);
+	int (*set_timeout)(struct watchdog_device *, int);
 };
 
 /* The structure that defines a watchdog device */
@@ -79,6 +80,7 @@
 	const struct watchdog_info *info;
 	const struct watchdog_ops *ops;
 	int bootstatus;
+	int timeout;
 	long status;
 #define WDOG_ACTIVE		0	/* is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
