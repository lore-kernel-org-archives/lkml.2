Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0K1MN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 07:13:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab0K1MNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 07:13:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Prevent dpm_prepare() from returning errors unnecessarily
Date: Sun, 28 Nov 2010 13:12:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011281312.49949.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently dpm_prepare() returns error code if it finds that a device
being suspended has a pending runtime resume request.  However, it
should not do that if the checking for wakeup events is not enabled.
On the other hand, if the checking for wakeup events is enabled, it
can return error when a wakeup event is detected, regardless of its
source.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/async.h>
+#include <linux/suspend.h>
 
 #include "../base.h"
 #include "power.h"
@@ -1052,8 +1053,10 @@ static int dpm_prepare(pm_message_t stat
 		mutex_unlock(&dpm_list_mtx);
 
 		pm_runtime_get_noresume(dev);
-		if (pm_runtime_barrier(dev) && device_may_wakeup(dev)) {
-			/* Wake-up requested during system sleep transition. */
+		if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
+			pm_wakeup_event(dev, 0);
+
+		if (pm_check_wakeup_events()) {
 			pm_runtime_put_sync(dev);
 			error = -EBUSY;
 		} else {
@@ -1068,8 +1071,8 @@ static int dpm_prepare(pm_message_t stat
 				error = 0;
 				continue;
 			}
-			printk(KERN_ERR "PM: Failed to prepare device %s "
-				"for power transition: error %d\n",
+			printk(KERN_INFO "PM: Device %s not prepared "
+				"for power transition: code %d\n",
 				kobject_name(&dev->kobj), error);
 			put_device(dev);
 			break;
