Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1FRR2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:28:37 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:46024 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798Ab1FRR2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:28:35 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EABre/E1tgyeh/2dsb2JhbABSpl54iHW9EQ6GHAShYQ
Date: Sat, 18 Jun 2011 19:28:32 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172832.GK3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 10

Add min_timeout (minimum timeout) and max_timeout
values so that the framework can check if the new
timeout value is between the minimum and maximum
timeout values. If both values are 0, then the
framework will leave the check for the watchdog
device driver itself.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part9/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-partA/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part9/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-17 10:14:55.514632632 +0200
+++ linux-2.6.38-generic-partA/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-17 12:20:35.765063301 +0200
@@ -44,6 +44,8 @@
 	const struct watchdog_ops *ops;
 	struct device *parent;
 	int timeout;
+	int min_timeout;
+	int max_timeout;
 	int bootstatus;
 	long status;
 };
@@ -56,6 +58,8 @@
 * parent: a pointer to the parent device of the watchdog. This will be set
   as the parent of the misc device.
 * timeout: the watchdog timer's timeout value (in seconds).
+* min_timeout: the watchdog timer's minimum timeout value (in seconds).
+* max_timeout: the watchdog timer's maximum timeout value (in seconds).
 * bootstatus: status of the device after booting (reported with watchdog
   WDIOF_* status bits).
 * status: this field contains a number of status bits that give extra
diff -urN linux-2.6.38-generic-part9/drivers/watchdog/core/watchdog_core.c linux-2.6.38-generic-partA/drivers/watchdog/core/watchdog_core.c
--- linux-2.6.38-generic-part9/drivers/watchdog/core/watchdog_core.c	2011-06-16 19:35:42.731177562 +0200
+++ linux-2.6.38-generic-partA/drivers/watchdog/core/watchdog_core.c	2011-06-17 13:43:20.661062411 +0200
@@ -66,6 +66,13 @@
 	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
 		return -ENODATA;
 
+	/* Check that we have valid min and max timeout values, if
+	 * not reset them both to 0 (=not used or unknown) */
+	if (wdd->min_timeout > wdd->max_timeout) {
+		wdd->min_timeout = 0;
+		wdd->max_timeout = 0;
+	}
+
 	/* Note: now that all watchdog_device data has been verified, we
 	 * will not check this anymore in other functions. If data get's
 	 * corrupted in a later stage then we expect a kernel panic! */
diff -urN linux-2.6.38-generic-part9/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-partA/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part9/drivers/watchdog/core/watchdog_dev.c	2011-06-17 10:14:55.522632632 +0200
+++ linux-2.6.38-generic-partA/drivers/watchdog/core/watchdog_dev.c	2011-06-17 13:48:31.493062339 +0200
@@ -250,6 +250,9 @@
 			return -EOPNOTSUPP;
 		if (get_user(val, p))
 			return -EFAULT;
+		if ((wdd->max_timeout != 0) &&
+		    (val < wdd->min_timeout || val > wdd->max_timeout))
+				return -EINVAL;
 		err = wdd->ops->set_timeout(wdd, val);
 		if (err < 0)
 			return err;
diff -urN linux-2.6.38-generic-part9/include/linux/watchdog.h linux-2.6.38-generic-partA/include/linux/watchdog.h
--- linux-2.6.38-generic-part9/include/linux/watchdog.h	2011-06-17 12:18:05.261063514 +0200
+++ linux-2.6.38-generic-partA/include/linux/watchdog.h	2011-06-17 12:19:20.637064105 +0200
@@ -83,6 +83,8 @@
 	struct device *parent;
 	int bootstatus;
 	int timeout;
+	int min_timeout;
+	int max_timeout;
 	long status;
 #define WDOG_ACTIVE		0	/* is the watchdog running/active */
 #define WDOG_DEV_OPEN		1	/* is the watchdog opened via
