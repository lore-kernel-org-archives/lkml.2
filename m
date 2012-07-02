Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2GBMQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:16:32 -0400
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:56369 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750803Ab2GBMQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:16:30 -0400
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/2] mmc: card: Move MMC specific attributes to mmc sub-directory
Date: Mon,  2 Jul 2012 15:15:36 +0300
Message-Id: <1341231337-6921-2-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate MMC specific attributes from general block device
attributes and move them from the /sys/block/<BLOCK_DEV> directory
to /sys/block/<BLOCK_DEV>/mmc directory

Signed-off-by: Maya Erez <merez@codeaurora.org>

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index c965f2b..c23034d 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -114,6 +114,9 @@ struct mmc_blk_data {
 	struct device_attribute force_ro;
 	struct device_attribute power_ro_lock;
 	int	area_type;
+
+	struct kobject kobj;
+	struct kobj_type kobj_type;
 };
 
 static DEFINE_MUTEX(open_lock);
@@ -185,6 +188,51 @@ static void mmc_blk_put(struct mmc_blk_data *md)
 	mutex_unlock(&open_lock);
 }
 
+static ssize_t mmc_blk_attr_show(struct kobject *kobj, struct attribute *attr,
+			    char *buf)
+{
+	struct device_attribute *dev_attr;
+	struct mmc_blk_data *md;
+	ssize_t ret;
+
+	dev_attr = container_of(attr, struct device_attribute, attr);
+	if (!dev_attr->show)
+		return -EIO;
+
+	md = container_of(kobj, struct mmc_blk_data, kobj);
+	if (!md || &md->kobj != kobj)
+		return -EINVAL;
+
+	ret = dev_attr->show(disk_to_dev(md->disk), dev_attr, buf);
+
+	return ret;
+}
+
+static ssize_t mmc_blk_attr_store(struct kobject *kobj, struct attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct device_attribute *dev_attr;
+	struct mmc_blk_data *md;
+	ssize_t ret;
+
+	dev_attr = container_of(attr, struct device_attribute, attr);
+	if (!dev_attr->store)
+		return -EIO;
+
+	md = container_of(kobj, struct mmc_blk_data, kobj);
+	if (!md || &md->kobj != kobj)
+		return -EINVAL;
+
+	ret = dev_attr->store(disk_to_dev(md->disk), dev_attr, buf, count);
+
+	return ret;
+}
+
+static const struct sysfs_ops mmc_blk_sysfs_ops = {
+	.show	= mmc_blk_attr_show,
+	.store	= mmc_blk_attr_store,
+};
+
 static ssize_t power_ro_lock_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -2004,14 +2052,15 @@ static void mmc_blk_remove_req(struct mmc_blk_data *md)
 	if (md) {
 		card = md->queue.card;
 		if (md->disk->flags & GENHD_FL_UP) {
-			device_remove_file(disk_to_dev(md->disk), &md->force_ro);
+			sysfs_remove_file(&md->kobj, &md->force_ro.attr);
 			if ((md->area_type & MMC_BLK_DATA_AREA_BOOT) &&
 					card->ext_csd.boot_ro_lockable)
-				device_remove_file(disk_to_dev(md->disk),
-					&md->power_ro_lock);
+				sysfs_remove_file(&md->kobj,
+					&md->power_ro_lock.attr);
 
 			/* Stop new requests from getting into the queue */
 			del_gendisk(md->disk);
+			kobject_put(&md->kobj);
 		}
 
 		/* Then flush out any already in there */
@@ -2040,12 +2089,19 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 	struct mmc_card *card = md->queue.card;
 
 	add_disk(md->disk);
+
+	md->kobj_type.sysfs_ops = &mmc_blk_sysfs_ops;
+	ret = kobject_init_and_add(&md->kobj, &md->kobj_type,
+		    &disk_to_dev(md->disk)->kobj, "%s", "mmc");
+	if (ret)
+		goto init_kobj_fail;
+
 	md->force_ro.show = force_ro_show;
 	md->force_ro.store = force_ro_store;
 	sysfs_attr_init(&md->force_ro.attr);
 	md->force_ro.attr.name = "force_ro";
 	md->force_ro.attr.mode = S_IRUGO | S_IWUSR;
-	ret = device_create_file(disk_to_dev(md->disk), &md->force_ro);
+	ret = sysfs_create_file(&md->kobj, &md->force_ro.attr);
 	if (ret)
 		goto force_ro_fail;
 
@@ -2064,16 +2120,17 @@ static int mmc_add_disk(struct mmc_blk_data *md)
 		md->power_ro_lock.attr.mode = mode;
 		md->power_ro_lock.attr.name =
 					"ro_lock_until_next_power_on";
-		ret = device_create_file(disk_to_dev(md->disk),
-				&md->power_ro_lock);
+		ret = sysfs_create_file(&md->kobj, &md->power_ro_lock.attr);
 		if (ret)
 			goto power_ro_lock_fail;
 	}
 	return ret;
 
 power_ro_lock_fail:
-	device_remove_file(disk_to_dev(md->disk), &md->force_ro);
+	sysfs_remove_file(&md->kobj, &md->force_ro.attr);
 force_ro_fail:
+	kobject_put(&md->kobj);
+init_kobj_fail:
 	del_gendisk(md->disk);
 
 	return ret;
-- 
1.7.3.3
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
