Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965235Ab1GMJog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:44:36 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:45984 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220Ab1GMJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:44:35 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E1D6900.6040500@cam.ac.uk>
Date: Wed, 13 Jul 2011 10:44:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: RFC: Boiler plate functions for ida / idr allocation?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One bit of common functionality that a lot of subsystem cores
(and some drivers) implement is allocation of unique id's.

Now we have ida / idr for this. However, given I copied someone
else's code for those in IIO, I took a look around to see how
common these 20 ish lines of code were.

The answer is fairly, though in some cases in subtly different
forms.  Seems to be from a naive standpoint to be a classic case
for a convenient library function.

Taking ida's first, how about the following patch?  I'm not at
all attached to the form it takes, merely to cutting out on the
cut and paste.

Note I've done only a few random places.  There aren't that many ida
users and I've only played with that for now.

Remaining ida cases:

drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c:  (cleans up in case of out of range)
drivers/scsi/osd/osd_uld.c: (locks not taken)

However, a few users of idr's that look like they are using them only as idas
(perhaps predating ida availability?)

e.g. 
drivers/hwmon/hwmon.c

The other thing this highlights is that I suspect quite a few are protected by
spin locks when a mutex would be fine. Hence that might be worth tidying up first.

Anyhow, a cleanup worth making? (obviously the exact form needs some work, but
I think the following is enough to start a discussion!)

Subject: [PATCH] ida utility function

---
 drivers/misc/cb710/core.c                  |   15 +-----
 drivers/scsi/sd.c                          |   10 +----
 drivers/staging/iio/iio.h                  |    1 -
 drivers/staging/iio/industrialio-core.c    |   38 ++--------------
 drivers/staging/iio/industrialio-trigger.c |   65 ++++++----------------------
 include/linux/idr.h                        |    1 +
 lib/idr.c                                  |   20 +++++++++
 7 files changed, 42 insertions(+), 108 deletions(-)

diff --git a/drivers/misc/cb710/core.c b/drivers/misc/cb710/core.c
index efec413..914be30 100644
--- a/drivers/misc/cb710/core.c
+++ b/drivers/misc/cb710/core.c
@@ -254,18 +254,9 @@ static int __devinit cb710_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
-	do {
-		if (!ida_pre_get(&cb710_ida, GFP_KERNEL))
-			return -ENOMEM;
-
-		spin_lock_irqsave(&cb710_ida_lock, flags);
-		err = ida_get_new(&cb710_ida, &chip->platform_id);
-		spin_unlock_irqrestore(&cb710_ida_lock, flags);
-
-		if (err && err != -EAGAIN)
-			return err;
-	} while (err);
-
+	err = ida_get_id(&cb710_ida_lock, &cb710_ida, &chip->platform_id);
+	if (err)
+		return err;
 
 	dev_info(&pdev->dev, "id %d, IO 0x%p, IRQ %d\n",
 		chip->platform_id, chip->iobase, pdev->irq);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773c..aadf8a3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2580,15 +2580,7 @@ static int sd_probe(struct device *dev)
 	if (!gd)
 		goto out_free;
 
-	do {
-		if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
-			goto out_put;
-
-		spin_lock(&sd_index_lock);
-		error = ida_get_new(&sd_index_ida, &index);
-		spin_unlock(&sd_index_lock);
-	} while (error == -EAGAIN);
-
+	error = ida_get_id(&sd_index_lock, &sd_index_ida, &index);
 	if (error)
 		goto out_put;
 
diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 2a8c8e2..7bdda68 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -426,6 +426,5 @@ static inline bool iio_ring_enabled(struct iio_dev *dev_info)
 
 struct ida;
 
-int iio_get_new_ida_val(struct ida *this_ida);
 void iio_free_ida_val(struct ida *this_ida, int id);
 #endif /* _INDUSTRIAL_IO_H_ */
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index a9628ed..258d68e 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -250,15 +250,8 @@ int iio_device_get_chrdev_minor(void)
 {
 	int ret, val;
 
-ida_again:
-	if (unlikely(ida_pre_get(&iio_chrdev_ida, GFP_KERNEL) == 0))
-		return -ENOMEM;
-	spin_lock(&iio_ida_lock);
-	ret = ida_get_new(&iio_chrdev_ida, &val);
-	spin_unlock(&iio_ida_lock);
-	if (unlikely(ret == -EAGAIN))
-		goto ida_again;
-	else if (unlikely(ret))
+	ret = ida_get_id(&iio_ida_lock, &iio_chrdev_ida, &val);
+	if (ret < 0)
 		return ret;
 	if (val > IIO_DEV_MAX)
 		return -ENOMEM;
@@ -794,28 +787,6 @@ static void iio_device_unregister_sysfs(struct iio_dev *dev_info)
 		sysfs_remove_group(&dev_info->dev.kobj, dev_info->info->attrs);
 }
 
-/* Return a negative errno on failure */
-int iio_get_new_ida_val(struct ida *this_ida)
-{
-	int ret;
-	int val;
-
-ida_again:
-	if (unlikely(ida_pre_get(this_ida, GFP_KERNEL) == 0))
-		return -ENOMEM;
-
-	spin_lock(&iio_ida_lock);
-	ret = ida_get_new(this_ida, &val);
-	spin_unlock(&iio_ida_lock);
-	if (unlikely(ret == -EAGAIN))
-		goto ida_again;
-	else if (unlikely(ret))
-		return ret;
-
-	return val;
-}
-EXPORT_SYMBOL(iio_get_new_ida_val);
-
 void iio_free_ida_val(struct ida *this_ida, int id)
 {
 	spin_lock(&iio_ida_lock);
@@ -1179,9 +1150,8 @@ int iio_device_register(struct iio_dev *dev_info)
 {
 	int ret;
 
-	dev_info->id = iio_get_new_ida_val(&iio_ida);
-	if (dev_info->id < 0) {
-		ret = dev_info->id;
+	ret = ida_get_id(&iio_ida_lock, &iio_ida, &dev_info->id);
+	if (ret < 0) {
 		dev_err(&dev_info->dev, "Failed to get id\n");
 		goto error_ret;
 	}
diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
index 6940f8c..75d19f6 100644
--- a/drivers/staging/iio/industrialio-trigger.c
+++ b/drivers/staging/iio/industrialio-trigger.c
@@ -31,8 +31,8 @@
  * Any other suggestions?
  */
 
-static DEFINE_IDR(iio_trigger_idr);
-static DEFINE_SPINLOCK(iio_trigger_idr_lock);
+static DEFINE_IDA(iio_trigger_ida);
+static DEFINE_SPINLOCK(iio_trigger_ida_lock);
 
 /* Single list of all available triggers */
 static LIST_HEAD(iio_trigger_list);
@@ -52,65 +52,22 @@ static ssize_t iio_trigger_read_name(struct device *dev,
 static DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
 
 /**
- * iio_trigger_register_sysfs() - create a device for this trigger
- * @trig_info:	the trigger
- *
- * Also adds any control attribute registered by the trigger driver
- **/
-static int iio_trigger_register_sysfs(struct iio_trigger *trig_info)
-{
-	return sysfs_add_file_to_group(&trig_info->dev.kobj,
-				       &dev_attr_name.attr,
-				       NULL);
-}
-
-static void iio_trigger_unregister_sysfs(struct iio_trigger *trig_info)
-{
-	sysfs_remove_file_from_group(&trig_info->dev.kobj,
-					   &dev_attr_name.attr,
-					   NULL);
-}
-
-
-/**
- * iio_trigger_register_id() - get a unique id for this trigger
- * @trig_info:	the trigger
- **/
-static int iio_trigger_register_id(struct iio_trigger *trig_info)
-{
-	int ret = 0;
-
-idr_again:
-	if (unlikely(idr_pre_get(&iio_trigger_idr, GFP_KERNEL) == 0))
-		return -ENOMEM;
-
-	spin_lock(&iio_trigger_idr_lock);
-	ret = idr_get_new(&iio_trigger_idr, NULL, &trig_info->id);
-	spin_unlock(&iio_trigger_idr_lock);
-	if (unlikely(ret == -EAGAIN))
-		goto idr_again;
-	else if (likely(!ret))
-		trig_info->id = trig_info->id & MAX_ID_MASK;
-
-	return ret;
-}
-
-/**
  * iio_trigger_unregister_id() - free up unique id for use by another trigger
  * @trig_info: the trigger
  **/
 static void iio_trigger_unregister_id(struct iio_trigger *trig_info)
 {
-	spin_lock(&iio_trigger_idr_lock);
-	idr_remove(&iio_trigger_idr, trig_info->id);
-	spin_unlock(&iio_trigger_idr_lock);
+	spin_lock(&iio_trigger_ida_lock);
+	ida_remove(&iio_trigger_ida, trig_info->id);
+	spin_unlock(&iio_trigger_ida_lock);
 }
 
 int iio_trigger_register(struct iio_trigger *trig_info)
 {
 	int ret;
 
-	ret = iio_trigger_register_id(trig_info);
+	ret = ida_get_id(&iio_trigger_ida_lock,
+			 &iio_trigger_ida, &trig_info->id);
 	if (ret)
 		goto error_ret;
 	/* Set the name used for the sysfs directory etc */
@@ -121,7 +78,9 @@ int iio_trigger_register(struct iio_trigger *trig_info)
 	if (ret)
 		goto error_unregister_id;
 
-	ret = iio_trigger_register_sysfs(trig_info);
+	ret = sysfs_add_file_to_group(&trig_info->dev.kobj,
+				      &dev_attr_name.attr,
+				      NULL);
 	if (ret)
 		goto error_device_del;
 
@@ -147,7 +106,9 @@ void iio_trigger_unregister(struct iio_trigger *trig_info)
 	list_del(&trig_info->list);
 	mutex_unlock(&iio_trigger_list_lock);
 
-	iio_trigger_unregister_sysfs(trig_info);
+	sysfs_remove_file_from_group(&trig_info->dev.kobj,
+				     &dev_attr_name.attr,
+				     NULL);
 	iio_trigger_unregister_id(trig_info);
 	/* Possible issue in here */
 	device_unregister(&trig_info->dev);
diff --git a/include/linux/idr.h b/include/linux/idr.h
index 13a801f..412b46c 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -147,5 +147,6 @@ void ida_destroy(struct ida *ida);
 void ida_init(struct ida *ida);
 
 void __init idr_init_cache(void);
+int ida_get_id(spinlock_t *lock, struct ida *ida, int *val);
 
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
index e15502e..d68e222 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -939,3 +939,23 @@ void ida_init(struct ida *ida)
 
 }
 EXPORT_SYMBOL(ida_init);
+
+int ida_get_id(spinlock_t *lock, struct ida *ida, int *val)
+{
+	int ret = 0;
+ida_again:
+	if (unlikely(ida_pre_get(ida, GFP_KERNEL) == 0))
+		return -ENOMEM;
+
+	spin_lock(lock);
+	ret = ida_get_new(ida, val);
+	spin_unlock(lock);
+
+	if (unlikely (ret == -EAGAIN))
+		goto ida_again;
+	else if (likely(!ret))
+		*val = *val & MAX_ID_MASK;
+
+	return ret;
+}
+EXPORT_SYMBOL(ida_get_id);
-- 
1.7.3.4

