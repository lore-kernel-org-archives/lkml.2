Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761275Ab1EASuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 14:50:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35217 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab1EASun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 14:50:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 1 May 2011 20:50:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] firewire: sbp2: parallelize login, reconnect, logout
Message-ID: <20110501205031.4f20866d@stein>
In-Reply-To: <20110501204853.2060ab25@stein>
References: <20110501204853.2060ab25@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct sbp2_logical_unit.work items can all be executed in parallel
but are not reentrant.  Furthermore, reconnect or re-login work must be
executed in a WQ_MEM_RECLAIM workqueue.

Hence replace the old single-threaded firewire-sbp2 workqueue by a
concurrency-managed but non-reentrant workqueue with rescuer.
firewire-core already maintains one, hence use this one.

In earlier versions of this change, I observed occasional failures of
parallel INQUIRY to an Initio INIC-2430 FireWire 800 to dual IDE bridge.
More testing indicates that parallel INQUIRY is not actually a problem,
but too quick successions of logout and login + INQUIRY, e.g. a quick
sequence of cable plugout and plugin, can result in failed INQUIRY.
This does not seem to be something that should or could be addressed by
serialization.

Another dual-LU device to which I currently have access to, an
OXUF924DSB FireWire 800 to dual SATA bridge with firmware from MacPower,
has been successfully tested with this too.

This change is beneficial to environments with two or more FireWire
storage devices, especially if they are located on the same bus.
Management tasks that should be performed as soon and as quickly as
possible, especially reconnect, are no longer held up by tasks on other
devices that may take a long time, especially login with INQUIRY and sd
or sr driver probe.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c        |    4 ++--
 drivers/firewire/core-cdev.c        |    2 +-
 drivers/firewire/core-device.c      |    5 +++--
 drivers/firewire/core-transaction.c |   12 ++++++------
 drivers/firewire/core.h             |    2 --
 drivers/firewire/sbp2.c             |    9 +--------
 include/linux/firewire.h            |    2 ++
 7 files changed, 15 insertions(+), 21 deletions(-)

Index: b/drivers/firewire/core-card.c
===================================================================
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -228,7 +228,7 @@ void fw_schedule_bus_reset(struct fw_car
 
 	/* Use an arbitrary short delay to combine multiple reset requests. */
 	fw_card_get(card);
-	if (!queue_delayed_work(fw_wq, &card->br_work,
+	if (!queue_delayed_work(fw_workqueue, &card->br_work,
 				delayed ? DIV_ROUND_UP(HZ, 100) : 0))
 		fw_card_put(card);
 }
@@ -241,7 +241,7 @@ static void br_work(struct work_struct *
 	/* Delay for 2s after last reset per IEEE 1394 clause 8.2.1. */
 	if (card->reset_jiffies != 0 &&
 	    time_before64(get_jiffies_64(), card->reset_jiffies + 2 * HZ)) {
-		if (!queue_delayed_work(fw_wq, &card->br_work, 2 * HZ))
+		if (!queue_delayed_work(fw_workqueue, &card->br_work, 2 * HZ))
 			fw_card_put(card);
 		return;
 	}
Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -149,7 +149,7 @@ static void release_iso_resource(struct 
 static void schedule_iso_resource(struct iso_resource *r, unsigned long delay)
 {
 	client_get(r->client);
-	if (!queue_delayed_work(fw_wq, &r->work, delay))
+	if (!queue_delayed_work(fw_workqueue, &r->work, delay))
 		client_put(r->client);
 }
 
Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -725,12 +725,13 @@ struct fw_device *fw_device_get_by_devt(
 	return device;
 }
 
-struct workqueue_struct *fw_wq;
+struct workqueue_struct *fw_workqueue;
+EXPORT_SYMBOL(fw_workqueue);
 
 static void fw_schedule_device_work(struct fw_device *device,
 				    unsigned long delay)
 {
-	queue_delayed_work(fw_wq, &device->work, delay);
+	queue_delayed_work(fw_workqueue, &device->work, delay);
 }
 
 /*
Index: b/drivers/firewire/core-transaction.c
===================================================================
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -1214,21 +1214,21 @@ static int __init fw_core_init(void)
 {
 	int ret;
 
-	fw_wq = alloc_workqueue(KBUILD_MODNAME,
-				WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
-	if (!fw_wq)
+	fw_workqueue = alloc_workqueue("firewire",
+				       WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
+	if (!fw_workqueue)
 		return -ENOMEM;
 
 	ret = bus_register(&fw_bus_type);
 	if (ret < 0) {
-		destroy_workqueue(fw_wq);
+		destroy_workqueue(fw_workqueue);
 		return ret;
 	}
 
 	fw_cdev_major = register_chrdev(0, "firewire", &fw_device_ops);
 	if (fw_cdev_major < 0) {
 		bus_unregister(&fw_bus_type);
-		destroy_workqueue(fw_wq);
+		destroy_workqueue(fw_workqueue);
 		return fw_cdev_major;
 	}
 
@@ -1244,7 +1244,7 @@ static void __exit fw_core_cleanup(void)
 {
 	unregister_chrdev(fw_cdev_major, "firewire");
 	bus_unregister(&fw_bus_type);
-	destroy_workqueue(fw_wq);
+	destroy_workqueue(fw_workqueue);
 	idr_destroy(&fw_device_idr);
 }
 
Index: b/drivers/firewire/core.h
===================================================================
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -138,8 +138,6 @@ void fw_cdev_handle_phy_packet(struct fw
 extern struct rw_semaphore fw_device_rwsem;
 extern struct idr fw_device_idr;
 extern int fw_cdev_major;
-struct workqueue_struct;
-extern struct workqueue_struct *fw_wq;
 
 struct fw_device *fw_device_get_by_devt(dev_t devt);
 int fw_device_set_broadcast_channel(struct device *dev, void *gen);
Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -826,8 +826,6 @@ static void sbp2_target_put(struct sbp2_
 	kref_put(&tgt->kref, sbp2_release_target);
 }
 
-static struct workqueue_struct *sbp2_wq;
-
 /*
  * Always get the target's kref when scheduling work on one its units.
  * Each workqueue job is responsible to call sbp2_target_put() upon return.
@@ -835,7 +833,7 @@ static struct workqueue_struct *sbp2_wq;
 static void sbp2_queue_work(struct sbp2_logical_unit *lu, unsigned long delay)
 {
 	sbp2_target_get(lu->tgt);
-	if (!queue_delayed_work(sbp2_wq, &lu->work, delay))
+	if (!queue_delayed_work(fw_workqueue, &lu->work, delay))
 		sbp2_target_put(lu->tgt);
 }
 
@@ -1645,17 +1643,12 @@ MODULE_ALIAS("sbp2");
 
 static int __init sbp2_init(void)
 {
-	sbp2_wq = create_singlethread_workqueue(KBUILD_MODNAME);
-	if (!sbp2_wq)
-		return -ENOMEM;
-
 	return driver_register(&sbp2_driver.driver);
 }
 
 static void __exit sbp2_cleanup(void)
 {
 	driver_unregister(&sbp2_driver.driver);
-	destroy_workqueue(sbp2_wq);
 }
 
 module_init(sbp2_init);
Index: b/include/linux/firewire.h
===================================================================
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -448,4 +448,6 @@ void fw_iso_resource_manage(struct fw_ca
 			    u64 channels_mask, int *channel, int *bandwidth,
 			    bool allocate);
 
+extern struct workqueue_struct *fw_workqueue;
+
 #endif /* _LINUX_FIREWIRE_H */


-- 
Stefan Richter
-=====-==-== -=-= ----=
http://arcgraph.de/sr/
