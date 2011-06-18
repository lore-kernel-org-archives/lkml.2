Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1FRRVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:21:41 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:6188 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab1FRRVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:21:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKTd/E1tgyeh/2dsb2JhbABFDaZeeIh1vRsOgxCDDAShYQ
Date: Sat, 18 Jun 2011 19:21:36 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110618172136.GD3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

watchdog: WatchDog Timer Driver Core - Part 3

This part add's the WDIOC_KEEPALIVE ioctl functionality to the
WatchDog Timer Driver Core framework. Please note that the
WDIOF_KEEPALIVEPING bit has to be set in the watchdog_info
options field.

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff -urN linux-2.6.38-generic-part2/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part3/Documentation/watchdog/src/watchdog-with-timer-example.c
--- linux-2.6.38-generic-part2/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:07:44.671177621 +0200
+++ linux-2.6.38-generic-part3/Documentation/watchdog/src/watchdog-with-timer-example.c	2011-06-16 20:07:53.631174037 +0200
@@ -117,6 +117,7 @@
  */
 static const struct watchdog_info wdt_info = {
 	.identity =	DRV_NAME,
+	.options =	WDIOF_KEEPALIVEPING,
 };
 
 static const struct watchdog_ops wdt_ops = {
diff -urN linux-2.6.38-generic-part2/Documentation/watchdog/watchdog-kernel-api.txt linux-2.6.38-generic-part3/Documentation/watchdog/watchdog-kernel-api.txt
--- linux-2.6.38-generic-part2/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 16:57:31.388541823 +0200
+++ linux-2.6.38-generic-part3/Documentation/watchdog/watchdog-kernel-api.txt	2011-06-16 18:44:20.747179936 +0200
@@ -101,6 +101,9 @@
   the watchdog timer driver core does: to send a keepalive ping to the watchdog
   timer hardware it will either use the ping operation (when available) or the
   start operation (when the ping operation is not available).
+  (Note: the WDIOC_KEEPALIVE ioctl call will only be active when the
+  WDIOF_KEEPALIVEPING bit has been set in the option field on the watchdog's
+  info structure).
 * status: this routine checks the status of the watchdog timer device. The
   status of the device is reported with watchdog WDIOF_* status flags/bits.
 
diff -urN linux-2.6.38-generic-part2/drivers/watchdog/core/watchdog_dev.c linux-2.6.38-generic-part3/drivers/watchdog/core/watchdog_dev.c
--- linux-2.6.38-generic-part2/drivers/watchdog/core/watchdog_dev.c	2011-06-16 19:34:22.927178838 +0200
+++ linux-2.6.38-generic-part3/drivers/watchdog/core/watchdog_dev.c	2011-06-16 19:35:22.415178710 +0200
@@ -153,6 +153,11 @@
 		return put_user(val, p);
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(wdd->bootstatus, p);
+	case WDIOC_KEEPALIVE:
+		if (!(wdd->info->options & WDIOF_KEEPALIVEPING))
+			return -EOPNOTSUPP;
+		watchdog_ping(wdd);
+		return 0;
 	default:
 		return -ENOTTY;
 	}
