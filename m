Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1HCWjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 18:39:18 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:3297 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab1HCWjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 18:39:13 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1312411150!29131129!10
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog: WatchDog Timer Driver Core - use passed watchdog_device
Date: Wed, 3 Aug 2011 15:38:20 -0700
User-Agent: KMail/1.9.9
CC: <linux-watchdog@vger.kernel.org>, <wim@iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201108031538.21137.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the passed watchdog_device instead of the static global variable when
testing and setting the status in watchdog_ping, watchdog_start, and
watchdog_stop.  Note that the callers of these functions are actually
passing the static global variable.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index d33520d..1199da0f 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -59,7 +59,7 @@ static struct watchdog_device *wdd;
 
 static int watchdog_ping(struct watchdog_device *wddev)
 {
-	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+	if (test_bit(WDOG_ACTIVE, &wddev->status)) {
 		if (wddev->ops->ping)
 			return wddev->ops->ping(wddev);  /* ping the watchdog */
 		else
@@ -81,12 +81,12 @@ static int watchdog_start(struct watchdog_device *wddev)
 {
 	int err;
 
-	if (!test_bit(WDOG_ACTIVE, &wdd->status)) {
+	if (!test_bit(WDOG_ACTIVE, &wddev->status)) {
 		err = wddev->ops->start(wddev);
 		if (err < 0)
 			return err;
 
-		set_bit(WDOG_ACTIVE, &wdd->status);
+		set_bit(WDOG_ACTIVE, &wddev->status);
 	}
 	return 0;
 }
@@ -105,18 +105,18 @@ static int watchdog_stop(struct watchdog_device *wddev)
 {
 	int err = -EBUSY;
 
-	if (test_bit(WDOG_NO_WAY_OUT, &wdd->status)) {
+	if (test_bit(WDOG_NO_WAY_OUT, &wddev->status)) {
 		pr_info("%s: nowayout prevents watchdog to be stopped!\n",
-							wdd->info->identity);
+							wddev->info->identity);
 		return err;
 	}
 
-	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+	if (test_bit(WDOG_ACTIVE, &wddev->status)) {
 		err = wddev->ops->stop(wddev);
 		if (err < 0)
 			return err;
 
-		clear_bit(WDOG_ACTIVE, &wdd->status);
+		clear_bit(WDOG_ACTIVE, &wddev->status);
 	}
 	return 0;
 }
