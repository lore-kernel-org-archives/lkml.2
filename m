Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab0HDVTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:19:08 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57581 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926Ab0HDVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:18:55 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCHv3 07/16] pps: move idr stuff to pps.c
Date: Thu,  5 Aug 2010 01:06:44 +0400
Message-Id: <379213887efb85e8e0e77bfab35c7a9fb2c759f1.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
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
 drivers/pps/kapi.c |   53 +---------------------------------------------------
 drivers/pps/pps.c  |   51 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 54 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index eddf41e..041c27e 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -26,19 +26,11 @@
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
 
@@ -75,7 +67,6 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 		int default_params)
 {
 	struct pps_device *pps;
-	int id;
 	int err;
 
 	/* Sanity checks */
@@ -116,54 +107,18 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
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
 		pr_err("pps: %s: unable to create char device\n",
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
 
@@ -183,13 +138,7 @@ EXPORT_SYMBOL(pps_register_source);
 
 void pps_unregister_source(struct pps_device *pps)
 {
-	unsigned int id = pps->id;
-
 	pps_unregister_cdev(pps);
-	
-	spin_lock_irq(&pps_idr_lock);
-	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
 }
 EXPORT_SYMBOL(pps_unregister_source);
 
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index a5ca1c0..d81f13b 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -29,6 +29,7 @@
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/pps_kernel.h>
+#include <linux/slab.h>
 
 /*
  * Local variables
@@ -37,6 +38,9 @@
 static dev_t pps_devt;
 static struct class *pps_class;
 
+static DEFINE_SPINLOCK(pps_idr_lock);
+static DEFINE_IDR(pps_idr);
+
 /*
  * Char device methods
  */
@@ -228,11 +232,47 @@ static const struct file_operations pps_cdev_fops = {
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
+}
+
 int pps_register_cdev(struct pps_device *pps)
 {
 	int err;
 	dev_t devt;
-	
+
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
+		pr_err("pps: %s: too many PPS sources in the system\n",
+					pps->info.name);
+		err = -EBUSY;
+		goto free_idr;
+	}
+
 	devt = MKDEV(MAJOR(pps_devt), pps->id);
 
 	cdev_init(&pps->cdev, &pps_cdev_fops);
@@ -242,13 +282,15 @@ int pps_register_cdev(struct pps_device *pps)
 	if (err) {
 		pr_err("pps: %s: failed to add char device %d:%d\n",
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
 
@@ -257,6 +299,11 @@ int pps_register_cdev(struct pps_device *pps)
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
1.7.1

