Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1BGXaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:30:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51905 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab1BGXan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:30:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <len.brown@intel.com>
Subject: [PATCH] thermal: Use freezable workqueue
Date: Tue, 8 Feb 2011 00:29:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102080029.57195.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If thermal polling is enabled, which for example is the case for
ACPI thermal zones with the _TZP object defined, the thermal driver
uses delayed work items for this purpose.  Unfortunately, since
they are queued up using schedule_delayed_work(), the work function
may be executed during system suspend or resume, which is not
desirable.

To prevent that from happening, use a freezable workqueue for
queuing up delayed work items in the thermal driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/thermal/thermal_sys.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/thermal/thermal_sys.c
===================================================================
--- linux-2.6.orig/drivers/thermal/thermal_sys.c
+++ linux-2.6/drivers/thermal/thermal_sys.c
@@ -62,6 +62,20 @@ static DEFINE_MUTEX(thermal_list_lock);
 
 static unsigned int thermal_event_seqnum;
 
+static struct workqueue_struct *thermal_wq;
+
+static int __init thermal_start_workqueue(void)
+{
+	thermal_wq = alloc_workqueue("thermal", WQ_FREEZEABLE, 0);
+	return thermal_wq ? 0 : -ENOMEM;
+}
+
+static inline void thermal_destroy_workqueue(void)
+{
+	if (thermal_wq)
+		destroy_workqueue(thermal_wq);
+}
+
 static struct genl_family thermal_event_genl_family = {
 	.id = GENL_ID_GENERATE,
 	.name = THERMAL_GENL_FAMILY_NAME,
@@ -611,10 +625,10 @@ static void thermal_zone_device_set_poll
 		return;
 
 	if (delay > 1000)
-		schedule_delayed_work(&(tz->poll_queue),
+		queue_delayed_work(thermal_wq, &(tz->poll_queue),
 				      round_jiffies(msecs_to_jiffies(delay)));
 	else
-		schedule_delayed_work(&(tz->poll_queue),
+		queue_delayed_work(thermal_wq, &(tz->poll_queue),
 				      msecs_to_jiffies(delay));
 }
 
@@ -1306,11 +1320,14 @@ static int __init thermal_init(void)
 	int result = 0;
 
 	result = class_register(&thermal_class);
+	if (!result)
+		result = thermal_start_workqueue();
 	if (result) {
 		idr_destroy(&thermal_tz_idr);
 		idr_destroy(&thermal_cdev_idr);
 		mutex_destroy(&thermal_idr_lock);
 		mutex_destroy(&thermal_list_lock);
+		thermal_destroy_workqueue();
 	}
 	result = genetlink_init();
 	return result;
@@ -1328,6 +1345,7 @@ static void __exit thermal_exit(void)
 	idr_destroy(&thermal_cdev_idr);
 	mutex_destroy(&thermal_idr_lock);
 	mutex_destroy(&thermal_list_lock);
+	thermal_destroy_workqueue();
 	genetlink_exit();
 }
 
