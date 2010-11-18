Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689Ab0KRQPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:15:06 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36030 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380Ab0KRQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:12:35 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv4 07/17] pps: move idr stuff to pps.c
Date: Thu, 18 Nov 2010 19:01:00 +0300
Message-Id: <73f5dc3f8658daf3378d7fd55ce28759637eb5d9.1290087479.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now idr is only used to manage char device id's and not used in
kernel API anymore it should be moved to pps.c. This also makes it
possible to release id only at actual device freeing so nobody can
register a pps device with the same id while our device is not freed
yet.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/kapi.c |   56 ++-------------------------------------------------
 drivers/pps/pps.c  |   50 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 54 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index fbb89c6..f5b2b78 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -27,19 +27,11 @@
 #include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/spinlock.h>
-#include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/pps_kernel.h>
 #include <linux/slab.h>
 
 /*
- * Local variables
- */
-
-static DEFINE_SPINLOCK(pps_idr_lock);
-static DEFINE_IDR(pps_idr);
-
-/*
  * Local functions
  */
 
@@ -76,7 +68,6 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 		int default_params)
 {
 	struct pps_device *pps;
-	int id;
 	int err;
 
 	/* Sanity checks */
@@ -117,54 +108,18 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 	init_waitqueue_head(&pps->queue);
 	spin_lock_init(&pps->lock);
 
-	/* Get new ID for the new PPS source */
-	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
-		err = -ENOMEM;
-		goto kfree_pps;
-	}
-
-	spin_lock_irq(&pps_idr_lock);
-
-	/* Now really allocate the PPS source.
-	 * After idr_get_new() calling the new source will be freely available
-	 * into the kernel.
-	 */
-	err = idr_get_new(&pps_idr, pps, &id);
-	if (err < 0) {
-		spin_unlock_irq(&pps_idr_lock);
-		goto kfree_pps;
-	}
-
-	id = id & MAX_ID_MASK;
-	if (id >= PPS_MAX_SOURCES) {
-		spin_unlock_irq(&pps_idr_lock);
-
-		pr_err("pps: %s: too many PPS sources in the system\n",
-					info->name);
-		err = -EBUSY;
-		goto free_idr;
-	}
-	pps->id = id;
-
-	spin_unlock_irq(&pps_idr_lock);
-
 	/* Create the char device */
 	err = pps_register_cdev(pps);
 	if (err < 0) {
 		pr_err("%s: unable to create char device\n",
 					info->name);
-		goto free_idr;
+		goto kfree_pps;
 	}
 
 	dev_info(pps->dev, "new PPS source %s\n", info->name);
 
 	return pps;
 
-free_idr:
-	spin_lock_irq(&pps_idr_lock);
-	idr_remove(&pps_idr, id);
-	spin_unlock_irq(&pps_idr_lock);
-
 kfree_pps:
 	kfree(pps);
 
@@ -184,15 +139,10 @@ EXPORT_SYMBOL(pps_register_source);
 
 void pps_unregister_source(struct pps_device *pps)
 {
-	unsigned int id = pps->id;
-
 	pps_unregister_cdev(pps);
 
-	spin_lock_irq(&pps_idr_lock);
-	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
-
-	kfree(pps);
+	/* don't have to kfree(pps) here because it will be done on
+	 * device destruction */
 }
 EXPORT_SYMBOL(pps_unregister_source);
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 9f7c2e8..79b4455 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -30,6 +30,7 @@
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/pps_kernel.h>
+#include <linux/slab.h>
 
 /*
  * Local variables
@@ -38,6 +39,9 @@
 static dev_t pps_devt;
 static struct class *pps_class;
 
+static DEFINE_SPINLOCK(pps_idr_lock);
+static DEFINE_IDR(pps_idr);
+
 /*
  * Char device methods
  */
@@ -229,11 +233,48 @@ static const struct file_operations pps_cdev_fops = {
 	.release	= pps_cdev_release,
 };
 
+static void pps_device_destruct(struct device *dev)
+{
+	struct pps_device *pps = dev_get_drvdata(dev);
+
+	/* release id here to protect others from using it while it's
+	 * still in use */
+	spin_lock_irq(&pps_idr_lock);
+	idr_remove(&pps_idr, pps->id);
+	spin_unlock_irq(&pps_idr_lock);
+
+	kfree(dev);
+	kfree(pps);
+}
+
 int pps_register_cdev(struct pps_device *pps)
 {
 	int err;
 	dev_t devt;
 
+	/* Get new ID for the new PPS source */
+	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0)
+		return -ENOMEM;
+
+	/* Now really allocate the PPS source.
+	 * After idr_get_new() calling the new source will be freely available
+	 * into the kernel.
+	 */
+	spin_lock_irq(&pps_idr_lock);
+	err = idr_get_new(&pps_idr, pps, &pps->id);
+	spin_unlock_irq(&pps_idr_lock);
+
+	if (err < 0)
+		return err;
+
+	pps->id &= MAX_ID_MASK;
+	if (pps->id >= PPS_MAX_SOURCES) {
+		pr_err("%s: too many PPS sources in the system\n",
+					pps->info.name);
+		err = -EBUSY;
+		goto free_idr;
+	}
+
 	devt = MKDEV(MAJOR(pps_devt), pps->id);
 
 	cdev_init(&pps->cdev, &pps_cdev_fops);
@@ -243,13 +284,15 @@ int pps_register_cdev(struct pps_device *pps)
 	if (err) {
 		pr_err("%s: failed to add char device %d:%d\n",
 				pps->info.name, MAJOR(pps_devt), pps->id);
-		return err;
+		goto free_idr;
 	}
 	pps->dev = device_create(pps_class, pps->info.dev, devt, pps,
 							"pps%d", pps->id);
 	if (IS_ERR(pps->dev))
 		goto del_cdev;
 
+	pps->dev->release = pps_device_destruct;
+
 	pr_debug("source %s got cdev (%d:%d)\n", pps->info.name,
 			MAJOR(pps_devt), pps->id);
 
@@ -258,6 +301,11 @@ int pps_register_cdev(struct pps_device *pps)
 del_cdev:
 	cdev_del(&pps->cdev);
 
+free_idr:
+	spin_lock_irq(&pps_idr_lock);
+	idr_remove(&pps_idr, pps->id);
+	spin_unlock_irq(&pps_idr_lock);
+
 	return err;
 }
 
-- 
1.7.2.3

