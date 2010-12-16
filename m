Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0LPAGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:06:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59489 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791Ab0LPAGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:06:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Use dev_name() in core device suspend and resume routines
Date: Thu, 16 Dec 2010 01:05:04 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012160105.04833.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use dev_name() wherever applicable in drivers/base/power/main.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -88,8 +88,7 @@ void device_pm_unlock(void)
 void device_pm_add(struct device *dev)
 {
 	pr_debug("PM: Adding info for %s:%s\n",
-		 dev->bus ? dev->bus->name : "No Bus",
-		 kobject_name(&dev->kobj));
+		 dev->bus ? dev->bus->name : "No Bus", dev_name(dev));
 	mutex_lock(&dpm_list_mtx);
 	if (dev->parent && dev->parent->power.in_suspend)
 		dev_warn(dev, "parent %s should not be sleeping\n",
@@ -105,8 +104,7 @@ void device_pm_add(struct device *dev)
 void device_pm_remove(struct device *dev)
 {
 	pr_debug("PM: Removing info for %s:%s\n",
-		 dev->bus ? dev->bus->name : "No Bus",
-		 kobject_name(&dev->kobj));
+		 dev->bus ? dev->bus->name : "No Bus", dev_name(dev));
 	complete_all(&dev->power.completion);
 	mutex_lock(&dpm_list_mtx);
 	list_del_init(&dev->power.entry);
@@ -123,10 +121,8 @@ void device_pm_remove(struct device *dev
 void device_pm_move_before(struct device *deva, struct device *devb)
 {
 	pr_debug("PM: Moving %s:%s before %s:%s\n",
-		 deva->bus ? deva->bus->name : "No Bus",
-		 kobject_name(&deva->kobj),
-		 devb->bus ? devb->bus->name : "No Bus",
-		 kobject_name(&devb->kobj));
+		 deva->bus ? deva->bus->name : "No Bus", dev_name(deva),
+		 devb->bus ? devb->bus->name : "No Bus", dev_name(devb));
 	/* Delete deva from dpm_list and reinsert before devb. */
 	list_move_tail(&deva->power.entry, &devb->power.entry);
 }
@@ -139,10 +135,8 @@ void device_pm_move_before(struct device
 void device_pm_move_after(struct device *deva, struct device *devb)
 {
 	pr_debug("PM: Moving %s:%s after %s:%s\n",
-		 deva->bus ? deva->bus->name : "No Bus",
-		 kobject_name(&deva->kobj),
-		 devb->bus ? devb->bus->name : "No Bus",
-		 kobject_name(&devb->kobj));
+		 deva->bus ? deva->bus->name : "No Bus", dev_name(deva),
+		 devb->bus ? devb->bus->name : "No Bus", dev_name(devb));
 	/* Delete deva from dpm_list and reinsert after devb. */
 	list_move(&deva->power.entry, &devb->power.entry);
 }
@@ -154,8 +148,7 @@ void device_pm_move_after(struct device
 void device_pm_move_last(struct device *dev)
 {
 	pr_debug("PM: Moving %s:%s to end of list\n",
-		 dev->bus ? dev->bus->name : "No Bus",
-		 kobject_name(&dev->kobj));
+		 dev->bus ? dev->bus->name : "No Bus", dev_name(dev));
 	list_move_tail(&dev->power.entry, &dpm_list);
 }
 
@@ -393,7 +386,7 @@ static void pm_dev_err(struct device *de
 			int error)
 {
 	printk(KERN_ERR "PM: Device %s failed to %s%s: error %d\n",
-		kobject_name(&dev->kobj), pm_verb(state.event), info, error);
+		dev_name(dev), pm_verb(state.event), info, error);
 }
 
 static void dpm_show_time(ktime_t starttime, pm_message_t state, char *info)
@@ -1028,7 +1021,7 @@ static int dpm_prepare(pm_message_t stat
 			}
 			printk(KERN_INFO "PM: Device %s not prepared "
 				"for power transition: code %d\n",
-				kobject_name(&dev->kobj), error);
+				dev_name(dev), error);
 			put_device(dev);
 			break;
 		}
