Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1FRR1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:27:30 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:34889 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab1FRR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:27:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANXe/E1tgyeh/2dsb2JhbABSpl54iHW9Dg6GHAShYQ
Date: Sat, 18 Jun 2011 19:27:27 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 9/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172727.GJ3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 9

Add support for extra ioctl calls by adding a
ioctl watchdog operation. This operation will be
called before we do our own handling of ioctl
commands. This way we can override the internal
ioctl command handling and we can also add
extra ioctl commands. The ioctl watchdog operation
should return the appropriate error codes or
-ENOIOCTLCMD if the ioctl command should be handled
through the internal ioctl handling of the framework.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part8/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part9/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part8/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-17 10:03:41.326632851 +0200
+++ linux-2.6.38-generic-part9/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-17 10:14:55.514632632 +0200
@@ -74,6 +74,7 @@
 	int (*ping)(struct watchdog_device *);
 	int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -119,6 +120,10 @@
   was just used to re-program the watchdog timer device.
   (Note: the WDIOF_SETTIMEOUT needs to be set in the options field of the
   watchdog's info structure).
+* ioctl: if this routine is present then it will be called first before we do
+  our own internal ioctl call handling. This routine should return -ENOIOCTLCMD
+  if a command is not supported. The parameters that are passsed to the ioctl
+  call are: watchdog_device, cmd and arg.
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bit's that are defined are:
diff -urN linux-2.6.38-generic-part8/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part9/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part8/drivers/watchdog/core/watchdog_dev.c	2011-06-17 10:03:41.326632851 +0200
+++ linux-2.6.38-generic-part9/drivers/watchdog/core/watchdog_dev.c	2011-06-17 10:14:55.522632632 +0200
@@ -209,6 +209,12 @@
 
 	trace("%p, %u, %li", file, cmd, arg);
 
+	if (wdd->ops->ioctl) {
+		err = wdd->ops->ioctl(wdd, cmd, arg);
+		if (err != -ENOIOCTLCMD)
+			return err;
+	}
+
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, wdd->info,
diff -urN linux-2.6.38-generic-part8/include/linux/watchdog.h linux-2.6.38-generic-part9/include/linux/watchdog.h
--- linux-2.6.38-generic-part8/include/linux/watchdog.h	2011-06-17 12:17:52.893063162 +0200
+++ linux-2.6.38-generic-part9/include/linux/watchdog.h	2011-06-17 12:18:05.261063514 +0200
@@ -72,6 +72,7 @@
 	int (*ping)(struct watchdog_device *);
 	int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 /* The structure that defines a watchdog device */
