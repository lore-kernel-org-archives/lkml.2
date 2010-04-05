Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab0DETH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:07:29 -0400
Received: from mail.perches.com ([173.55.12.10]:1368 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755988Ab0DETFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:05:50 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] drivers/s390/block/dcssblk.c: Rename dev_info to ddi
Date: Mon,  5 Apr 2010 12:05:34 -0700
Message-Id: <9424ffcd4b90ad8ba280e1a389115a6d27d0b94c.1270493677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
References: <20100304232928.2e45bdd1.akpm@linux-foundation.org>
In-Reply-To: <cover.1270493677.git.joe@perches.com>
References: <cover.1270493677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro called dev_info that prints struct device specific
information.  Having variables with the same name can be confusing and
prevents conversion of the macro to a function.

Rename the existing dev_info variables to something else in preparation
to converting the dev_info macro to a function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/block/dcssblk.c |  328 +++++++++++++++++++++---------------------
 1 files changed, 164 insertions(+), 164 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 9b43ae9..46003b9 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -98,15 +98,15 @@ static struct rw_semaphore dcssblk_devices_sem;
 static void
 dcssblk_release_segment(struct device *dev)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct segment_info *entry, *temp;
 
-	dev_info = container_of(dev, struct dcssblk_dev_info, dev);
-	list_for_each_entry_safe(entry, temp, &dev_info->seg_list, lh) {
+	ddi = container_of(dev, struct dcssblk_dev_info, dev);
+	list_for_each_entry_safe(entry, temp, &ddi->seg_list, lh) {
 		list_del(&entry->lh);
 		kfree(entry);
 	}
-	kfree(dev_info);
+	kfree(ddi);
 	module_put(THIS_MODULE);
 }
 
@@ -117,12 +117,12 @@ dcssblk_release_segment(struct device *dev)
  * freed.
  */
 static int
-dcssblk_assign_free_minor(struct dcssblk_dev_info *dev_info)
+dcssblk_assign_free_minor(struct dcssblk_dev_info *ddi)
 {
 	int minor, found;
 	struct dcssblk_dev_info *entry;
 
-	if (dev_info == NULL)
+	if (ddi == NULL)
 		return -EINVAL;
 	for (minor = 0; minor < (1<<MINORBITS); minor++) {
 		found = 0;
@@ -134,7 +134,7 @@ dcssblk_assign_free_minor(struct dcssblk_dev_info *dev_info)
 	}
 	if (found)
 		return -EBUSY;
-	dev_info->gd->first_minor = minor;
+	ddi->gd->first_minor = minor;
 	return 0;
 }
 
@@ -164,11 +164,11 @@ dcssblk_get_device_by_name(char *name)
 static struct segment_info *
 dcssblk_get_segment_by_name(char *name)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct segment_info *entry;
 
-	list_for_each_entry(dev_info, &dcssblk_devices, lh) {
-		list_for_each_entry(entry, &dev_info->seg_list, lh) {
+	list_for_each_entry(ddi, &dcssblk_devices, lh) {
+		list_for_each_entry(entry, &ddi->seg_list, lh) {
 			if (!strcmp(name, entry->segment_name))
 				return entry;
 		}
@@ -180,13 +180,13 @@ dcssblk_get_segment_by_name(char *name)
  * get the highest address of the multi-segment block.
  */
 static unsigned long
-dcssblk_find_highest_addr(struct dcssblk_dev_info *dev_info)
+dcssblk_find_highest_addr(struct dcssblk_dev_info *ddi)
 {
 	unsigned long highest_addr;
 	struct segment_info *entry;
 
 	highest_addr = 0;
-	list_for_each_entry(entry, &dev_info->seg_list, lh) {
+	list_for_each_entry(entry, &ddi->seg_list, lh) {
 		if (highest_addr < entry->end)
 			highest_addr = entry->end;
 	}
@@ -197,7 +197,7 @@ dcssblk_find_highest_addr(struct dcssblk_dev_info *dev_info)
  * get the lowest address of the multi-segment block.
  */
 static unsigned long
-dcssblk_find_lowest_addr(struct dcssblk_dev_info *dev_info)
+dcssblk_find_lowest_addr(struct dcssblk_dev_info *ddi)
 {
 	int set_first;
 	unsigned long lowest_addr;
@@ -205,7 +205,7 @@ dcssblk_find_lowest_addr(struct dcssblk_dev_info *dev_info)
 
 	set_first = 0;
 	lowest_addr = 0;
-	list_for_each_entry(entry, &dev_info->seg_list, lh) {
+	list_for_each_entry(entry, &ddi->seg_list, lh) {
 		if (set_first == 0) {
 			lowest_addr = entry->start;
 			set_first = 1;
@@ -221,28 +221,28 @@ dcssblk_find_lowest_addr(struct dcssblk_dev_info *dev_info)
  * Check continuity of segments.
  */
 static int
-dcssblk_is_continuous(struct dcssblk_dev_info *dev_info)
+dcssblk_is_continuous(struct dcssblk_dev_info *ddi)
 {
 	int i, j, rc;
 	struct segment_info *sort_list, *entry, temp;
 
-	if (dev_info->num_of_segments <= 1)
+	if (ddi->num_of_segments <= 1)
 		return 0;
 
 	sort_list = kzalloc(
-			sizeof(struct segment_info) * dev_info->num_of_segments,
+			sizeof(struct segment_info) * ddi->num_of_segments,
 			GFP_KERNEL);
 	if (sort_list == NULL)
 		return -ENOMEM;
 	i = 0;
-	list_for_each_entry(entry, &dev_info->seg_list, lh) {
+	list_for_each_entry(entry, &ddi->seg_list, lh) {
 		memcpy(&sort_list[i], entry, sizeof(struct segment_info));
 		i++;
 	}
 
 	/* sort segments */
-	for (i = 0; i < dev_info->num_of_segments; i++)
-		for (j = 0; j < dev_info->num_of_segments; j++)
+	for (i = 0; i < ddi->num_of_segments; i++)
+		for (j = 0; j < ddi->num_of_segments; j++)
 			if (sort_list[j].start > sort_list[i].start) {
 				memcpy(&temp, &sort_list[i],
 					sizeof(struct segment_info));
@@ -253,7 +253,7 @@ dcssblk_is_continuous(struct dcssblk_dev_info *dev_info)
 			}
 
 	/* check continuity */
-	for (i = 0; i < dev_info->num_of_segments - 1; i++) {
+	for (i = 0; i < ddi->num_of_segments - 1; i++) {
 		if ((sort_list[i].end + 1) != sort_list[i+1].start) {
 			pr_err("Adjacent DCSSs %s and %s are not "
 			       "contiguous\n", sort_list[i].segment_name,
@@ -331,30 +331,30 @@ static void dcssblk_unregister_callback(struct device *dev)
 static ssize_t
 dcssblk_shared_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 
-	dev_info = container_of(dev, struct dcssblk_dev_info, dev);
-	return sprintf(buf, dev_info->is_shared ? "1\n" : "0\n");
+	ddi = container_of(dev, struct dcssblk_dev_info, dev);
+	return sprintf(buf, ddi->is_shared ? "1\n" : "0\n");
 }
 
 static ssize_t
 dcssblk_shared_store(struct device *dev, struct device_attribute *attr, const char *inbuf, size_t count)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct segment_info *entry, *temp;
 	int rc;
 
 	if ((count > 1) && (inbuf[1] != '\n') && (inbuf[1] != '\0'))
 		return -EINVAL;
 	down_write(&dcssblk_devices_sem);
-	dev_info = container_of(dev, struct dcssblk_dev_info, dev);
-	if (atomic_read(&dev_info->use_count)) {
+	ddi = container_of(dev, struct dcssblk_dev_info, dev);
+	if (atomic_read(&ddi->use_count)) {
 		rc = -EBUSY;
 		goto out;
 	}
 	if (inbuf[0] == '1') {
 		/* reload segments in shared mode */
-		list_for_each_entry(entry, &dev_info->seg_list, lh) {
+		list_for_each_entry(entry, &ddi->seg_list, lh) {
 			rc = segment_modify_shared(entry->segment_name,
 						SEGMENT_SHARED);
 			if (rc < 0) {
@@ -363,23 +363,23 @@ dcssblk_shared_store(struct device *dev, struct device_attribute *attr, const ch
 					goto removeseg;
 			}
 		}
-		dev_info->is_shared = 1;
-		switch (dev_info->segment_type) {
+		ddi->is_shared = 1;
+		switch (ddi->segment_type) {
 		case SEG_TYPE_SR:
 		case SEG_TYPE_ER:
 		case SEG_TYPE_SC:
-			set_disk_ro(dev_info->gd, 1);
+			set_disk_ro(ddi->gd, 1);
 		}
 	} else if (inbuf[0] == '0') {
 		/* reload segments in exclusive mode */
-		if (dev_info->segment_type == SEG_TYPE_SC) {
+		if (ddi->segment_type == SEG_TYPE_SC) {
 			pr_err("DCSS %s is of type SC and cannot be "
 			       "loaded as exclusive-writable\n",
-			       dev_info->segment_name);
+			       ddi->segment_name);
 			rc = -EINVAL;
 			goto out;
 		}
-		list_for_each_entry(entry, &dev_info->seg_list, lh) {
+		list_for_each_entry(entry, &ddi->seg_list, lh) {
 			rc = segment_modify_shared(entry->segment_name,
 						   SEGMENT_EXCLUSIVE);
 			if (rc < 0) {
@@ -388,8 +388,8 @@ dcssblk_shared_store(struct device *dev, struct device_attribute *attr, const ch
 					goto removeseg;
 			}
 		}
-		dev_info->is_shared = 0;
-		set_disk_ro(dev_info->gd, 0);
+		ddi->is_shared = 0;
+		set_disk_ro(ddi->gd, 0);
 	} else {
 		rc = -EINVAL;
 		goto out;
@@ -399,18 +399,18 @@ dcssblk_shared_store(struct device *dev, struct device_attribute *attr, const ch
 
 removeseg:
 	pr_err("DCSS device %s is removed after a failed access mode "
-	       "change\n", dev_info->segment_name);
+	       "change\n", ddi->segment_name);
 	temp = entry;
-	list_for_each_entry(entry, &dev_info->seg_list, lh) {
+	list_for_each_entry(entry, &ddi->seg_list, lh) {
 		if (entry != temp)
 			segment_unload(entry->segment_name);
 	}
-	list_del(&dev_info->lh);
+	list_del(&ddi->lh);
 
-	del_gendisk(dev_info->gd);
-	blk_cleanup_queue(dev_info->dcssblk_queue);
-	dev_info->gd->queue = NULL;
-	put_disk(dev_info->gd);
+	del_gendisk(ddi->gd);
+	blk_cleanup_queue(ddi->dcssblk_queue);
+	ddi->gd->queue = NULL;
+	put_disk(ddi->gd);
 	rc = device_schedule_callback(dev, dcssblk_unregister_callback);
 out:
 	up_write(&dcssblk_devices_sem);
@@ -427,29 +427,29 @@ out:
 static ssize_t
 dcssblk_save_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 
-	dev_info = container_of(dev, struct dcssblk_dev_info, dev);
-	return sprintf(buf, dev_info->save_pending ? "1\n" : "0\n");
+	ddi = container_of(dev, struct dcssblk_dev_info, dev);
+	return sprintf(buf, ddi->save_pending ? "1\n" : "0\n");
 }
 
 static ssize_t
 dcssblk_save_store(struct device *dev, struct device_attribute *attr, const char *inbuf, size_t count)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct segment_info *entry;
 
 	if ((count > 1) && (inbuf[1] != '\n') && (inbuf[1] != '\0'))
 		return -EINVAL;
-	dev_info = container_of(dev, struct dcssblk_dev_info, dev);
+	ddi = container_of(dev, struct dcssblk_dev_info, dev);
 
 	down_write(&dcssblk_devices_sem);
 	if (inbuf[0] == '1') {
-		if (atomic_read(&dev_info->use_count) == 0) {
+		if (atomic_read(&ddi->use_count) == 0) {
 			// device is idle => we save immediately
 			pr_info("All DCSSs that map to device %s are "
-				"saved\n", dev_info->segment_name);
-			list_for_each_entry(entry, &dev_info->seg_list, lh) {
+				"saved\n", ddi->segment_name);
+			list_for_each_entry(entry, &ddi->seg_list, lh) {
 				segment_save(entry->segment_name);
 			}
 		}  else {
@@ -457,17 +457,17 @@ dcssblk_save_store(struct device *dev, struct device_attribute *attr, const char
 			// idle in dcssblk_release
 			pr_info("Device %s is in use, its DCSSs will be "
 				"saved when it becomes idle\n",
-				dev_info->segment_name);
-			dev_info->save_pending = 1;
+				ddi->segment_name);
+			ddi->save_pending = 1;
 		}
 	} else if (inbuf[0] == '0') {
-		if (dev_info->save_pending) {
+		if (ddi->save_pending) {
 			// device is busy & the user wants to undo his save
 			// request
-			dev_info->save_pending = 0;
+			ddi->save_pending = 0;
 			pr_info("A pending save request for device %s "
 				"has been canceled\n",
-				dev_info->segment_name);
+				ddi->segment_name);
 		}
 	} else {
 		up_write(&dcssblk_devices_sem);
@@ -486,14 +486,14 @@ dcssblk_seglist_show(struct device *dev, struct device_attribute *attr,
 {
 	int i;
 
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct segment_info *entry;
 
 	down_read(&dcssblk_devices_sem);
-	dev_info = container_of(dev, struct dcssblk_dev_info, dev);
+	ddi = container_of(dev, struct dcssblk_dev_info, dev);
 	i = 0;
 	buf[0] = '\0';
-	list_for_each_entry(entry, &dev_info->seg_list, lh) {
+	list_for_each_entry(entry, &ddi->seg_list, lh) {
 		strcpy(&buf[i], entry->segment_name);
 		i += strlen(entry->segment_name);
 		buf[i] = '\n';
@@ -510,12 +510,12 @@ static ssize_t
 dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	int rc, i, j, num_of_segments;
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct segment_info *seg_info, *temp;
 	char *local_buf;
 	unsigned long seg_byte_size;
 
-	dev_info = NULL;
+	ddi = NULL;
 	seg_info = NULL;
 	if (dev != dcssblk_root_dev) {
 		rc = -EINVAL;
@@ -556,17 +556,17 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 		 * get a struct dcssblk_dev_info
 		 */
 		if (num_of_segments == 0) {
-			dev_info = kzalloc(sizeof(struct dcssblk_dev_info),
+			ddi = kzalloc(sizeof(struct dcssblk_dev_info),
 					GFP_KERNEL);
-			if (dev_info == NULL) {
+			if (ddi == NULL) {
 				rc = -ENOMEM;
 				goto out;
 			}
-			strcpy(dev_info->segment_name, local_buf);
-			dev_info->segment_type = seg_info->segment_type;
-			INIT_LIST_HEAD(&dev_info->seg_list);
+			strcpy(ddi->segment_name, local_buf);
+			ddi->segment_type = seg_info->segment_type;
+			INIT_LIST_HEAD(&ddi->seg_list);
 		}
-		list_add_tail(&seg_info->lh, &dev_info->seg_list);
+		list_add_tail(&seg_info->lh, &ddi->seg_list);
 		num_of_segments++;
 		i = j;
 
@@ -580,39 +580,39 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 		goto seg_list_del;
 	}
 	strlcpy(local_buf, buf, i + 1);
-	dev_info->num_of_segments = num_of_segments;
-	rc = dcssblk_is_continuous(dev_info);
+	ddi->num_of_segments = num_of_segments;
+	rc = dcssblk_is_continuous(ddi);
 	if (rc < 0)
 		goto seg_list_del;
 
-	dev_info->start = dcssblk_find_lowest_addr(dev_info);
-	dev_info->end = dcssblk_find_highest_addr(dev_info);
+	ddi->start = dcssblk_find_lowest_addr(ddi);
+	ddi->end = dcssblk_find_highest_addr(ddi);
 
-	dev_set_name(&dev_info->dev, dev_info->segment_name);
-	dev_info->dev.release = dcssblk_release_segment;
-	INIT_LIST_HEAD(&dev_info->lh);
-	dev_info->gd = alloc_disk(DCSSBLK_MINORS_PER_DISK);
-	if (dev_info->gd == NULL) {
+	dev_set_name(&ddi->dev, ddi->segment_name);
+	ddi->dev.release = dcssblk_release_segment;
+	INIT_LIST_HEAD(&ddi->lh);
+	ddi->gd = alloc_disk(DCSSBLK_MINORS_PER_DISK);
+	if (ddi->gd == NULL) {
 		rc = -ENOMEM;
 		goto seg_list_del;
 	}
-	dev_info->gd->major = dcssblk_major;
-	dev_info->gd->fops = &dcssblk_devops;
-	dev_info->dcssblk_queue = blk_alloc_queue(GFP_KERNEL);
-	dev_info->gd->queue = dev_info->dcssblk_queue;
-	dev_info->gd->private_data = dev_info;
-	dev_info->gd->driverfs_dev = &dev_info->dev;
-	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
-	blk_queue_logical_block_size(dev_info->dcssblk_queue, 4096);
-
-	seg_byte_size = (dev_info->end - dev_info->start + 1);
-	set_capacity(dev_info->gd, seg_byte_size >> 9); // size in sectors
+	ddi->gd->major = dcssblk_major;
+	ddi->gd->fops = &dcssblk_devops;
+	ddi->dcssblk_queue = blk_alloc_queue(GFP_KERNEL);
+	ddi->gd->queue = ddi->dcssblk_queue;
+	ddi->gd->private_data = ddi;
+	ddi->gd->driverfs_dev = &ddi->dev;
+	blk_queue_make_request(ddi->dcssblk_queue, dcssblk_make_request);
+	blk_queue_logical_block_size(ddi->dcssblk_queue, 4096);
+
+	seg_byte_size = (ddi->end - ddi->start + 1);
+	set_capacity(ddi->gd, seg_byte_size >> 9); // size in sectors
 	pr_info("Loaded %s with total size %lu bytes and capacity %lu "
 		"sectors\n", local_buf, seg_byte_size, seg_byte_size >> 9);
 
-	dev_info->save_pending = 0;
-	dev_info->is_shared = 1;
-	dev_info->dev.parent = dcssblk_root_dev;
+	ddi->save_pending = 0;
+	ddi->is_shared = 1;
+	ddi->dev.parent = dcssblk_root_dev;
 
 	/*
 	 *get minor, add to list
@@ -622,12 +622,12 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 		rc = -EEXIST;
 		goto release_gd;
 	}
-	rc = dcssblk_assign_free_minor(dev_info);
+	rc = dcssblk_assign_free_minor(ddi);
 	if (rc)
 		goto release_gd;
-	sprintf(dev_info->gd->disk_name, "dcssblk%d",
-		dev_info->gd->first_minor);
-	list_add_tail(&dev_info->lh, &dcssblk_devices);
+	sprintf(ddi->gd->disk_name, "dcssblk%d",
+		ddi->gd->first_minor);
+	list_add_tail(&ddi->lh, &dcssblk_devices);
 
 	if (!try_module_get(THIS_MODULE)) {
 		rc = -ENODEV;
@@ -636,32 +636,32 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	/*
 	 * register the device
 	 */
-	rc = device_register(&dev_info->dev);
+	rc = device_register(&ddi->dev);
 	if (rc) {
 		module_put(THIS_MODULE);
 		goto dev_list_del;
 	}
-	get_device(&dev_info->dev);
-	rc = device_create_file(&dev_info->dev, &dev_attr_shared);
+	get_device(&ddi->dev);
+	rc = device_create_file(&ddi->dev, &dev_attr_shared);
 	if (rc)
 		goto unregister_dev;
-	rc = device_create_file(&dev_info->dev, &dev_attr_save);
+	rc = device_create_file(&ddi->dev, &dev_attr_save);
 	if (rc)
 		goto unregister_dev;
-	rc = device_create_file(&dev_info->dev, &dev_attr_seglist);
+	rc = device_create_file(&ddi->dev, &dev_attr_seglist);
 	if (rc)
 		goto unregister_dev;
 
-	add_disk(dev_info->gd);
+	add_disk(ddi->gd);
 
-	switch (dev_info->segment_type) {
+	switch (ddi->segment_type) {
 		case SEG_TYPE_SR:
 		case SEG_TYPE_ER:
 		case SEG_TYPE_SC:
-			set_disk_ro(dev_info->gd,1);
+			set_disk_ro(ddi->gd,1);
 			break;
 		default:
-			set_disk_ro(dev_info->gd,0);
+			set_disk_ro(ddi->gd,0);
 			break;
 	}
 	up_write(&dcssblk_devices_sem);
@@ -669,33 +669,33 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	goto out;
 
 unregister_dev:
-	list_del(&dev_info->lh);
-	blk_cleanup_queue(dev_info->dcssblk_queue);
-	dev_info->gd->queue = NULL;
-	put_disk(dev_info->gd);
-	device_unregister(&dev_info->dev);
-	list_for_each_entry(seg_info, &dev_info->seg_list, lh) {
+	list_del(&ddi->lh);
+	blk_cleanup_queue(ddi->dcssblk_queue);
+	ddi->gd->queue = NULL;
+	put_disk(ddi->gd);
+	device_unregister(&ddi->dev);
+	list_for_each_entry(seg_info, &ddi->seg_list, lh) {
 		segment_unload(seg_info->segment_name);
 	}
-	put_device(&dev_info->dev);
+	put_device(&ddi->dev);
 	up_write(&dcssblk_devices_sem);
 	goto out;
 dev_list_del:
-	list_del(&dev_info->lh);
+	list_del(&ddi->lh);
 release_gd:
-	blk_cleanup_queue(dev_info->dcssblk_queue);
-	dev_info->gd->queue = NULL;
-	put_disk(dev_info->gd);
+	blk_cleanup_queue(ddi->dcssblk_queue);
+	ddi->gd->queue = NULL;
+	put_disk(ddi->gd);
 	up_write(&dcssblk_devices_sem);
 seg_list_del:
-	if (dev_info == NULL)
+	if (ddi == NULL)
 		goto out;
-	list_for_each_entry_safe(seg_info, temp, &dev_info->seg_list, lh) {
+	list_for_each_entry_safe(seg_info, temp, &ddi->seg_list, lh) {
 		list_del(&seg_info->lh);
 		segment_unload(seg_info->segment_name);
 		kfree(seg_info);
 	}
-	kfree(dev_info);
+	kfree(ddi);
 out:
 	kfree(local_buf);
 out_nobuf:
@@ -708,7 +708,7 @@ out_nobuf:
 static ssize_t
 dcssblk_remove_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct segment_info *entry;
 	int rc, i;
 	char *local_buf;
@@ -733,15 +733,15 @@ dcssblk_remove_store(struct device *dev, struct device_attribute *attr, const ch
 	}
 
 	down_write(&dcssblk_devices_sem);
-	dev_info = dcssblk_get_device_by_name(local_buf);
-	if (dev_info == NULL) {
+	ddi = dcssblk_get_device_by_name(local_buf);
+	if (ddi == NULL) {
 		up_write(&dcssblk_devices_sem);
 		pr_warning("Device %s cannot be removed because it is not a "
 			   "known device\n", local_buf);
 		rc = -ENODEV;
 		goto out_buf;
 	}
-	if (atomic_read(&dev_info->use_count) != 0) {
+	if (atomic_read(&ddi->use_count) != 0) {
 		up_write(&dcssblk_devices_sem);
 		pr_warning("Device %s cannot be removed while it is in "
 			   "use\n", local_buf);
@@ -749,18 +749,18 @@ dcssblk_remove_store(struct device *dev, struct device_attribute *attr, const ch
 		goto out_buf;
 	}
 
-	list_del(&dev_info->lh);
-	del_gendisk(dev_info->gd);
-	blk_cleanup_queue(dev_info->dcssblk_queue);
-	dev_info->gd->queue = NULL;
-	put_disk(dev_info->gd);
-	device_unregister(&dev_info->dev);
+	list_del(&ddi->lh);
+	del_gendisk(ddi->gd);
+	blk_cleanup_queue(ddi->dcssblk_queue);
+	ddi->gd->queue = NULL;
+	put_disk(ddi->gd);
+	device_unregister(&ddi->dev);
 
 	/* unload all related segments */
-	list_for_each_entry(entry, &dev_info->seg_list, lh)
+	list_for_each_entry(entry, &ddi->seg_list, lh)
 		segment_unload(entry->segment_name);
 
-	put_device(&dev_info->dev);
+	put_device(&ddi->dev);
 	up_write(&dcssblk_devices_sem);
 
 	rc = count;
@@ -772,15 +772,15 @@ out_buf:
 static int
 dcssblk_open(struct block_device *bdev, fmode_t mode)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	int rc;
 
-	dev_info = bdev->bd_disk->private_data;
-	if (NULL == dev_info) {
+	ddi = bdev->bd_disk->private_data;
+	if (NULL == ddi) {
 		rc = -ENODEV;
 		goto out;
 	}
-	atomic_inc(&dev_info->use_count);
+	atomic_inc(&ddi->use_count);
 	bdev->bd_block_size = 4096;
 	rc = 0;
 out:
@@ -790,23 +790,23 @@ out:
 static int
 dcssblk_release(struct gendisk *disk, fmode_t mode)
 {
-	struct dcssblk_dev_info *dev_info = disk->private_data;
+	struct dcssblk_dev_info *ddi = disk->private_data;
 	struct segment_info *entry;
 	int rc;
 
-	if (!dev_info) {
+	if (!ddi) {
 		rc = -ENODEV;
 		goto out;
 	}
 	down_write(&dcssblk_devices_sem);
-	if (atomic_dec_and_test(&dev_info->use_count)
-	    && (dev_info->save_pending)) {
+	if (atomic_dec_and_test(&ddi->use_count)
+	    && (ddi->save_pending)) {
 		pr_info("Device %s has become idle and is being saved "
-			"now\n", dev_info->segment_name);
-		list_for_each_entry(entry, &dev_info->seg_list, lh) {
+			"now\n", ddi->segment_name);
+		list_for_each_entry(entry, &ddi->seg_list, lh) {
 			segment_save(entry->segment_name);
 		}
-		dev_info->save_pending = 0;
+		ddi->save_pending = 0;
 	}
 	up_write(&dcssblk_devices_sem);
 	rc = 0;
@@ -817,7 +817,7 @@ out:
 static int
 dcssblk_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct bio_vec *bvec;
 	unsigned long index;
 	unsigned long page_addr;
@@ -826,8 +826,8 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	int i;
 
 	bytes_done = 0;
-	dev_info = bio->bi_bdev->bd_disk->private_data;
-	if (dev_info == NULL)
+	ddi = bio->bi_bdev->bd_disk->private_data;
+	if (ddi == NULL)
 		goto fail;
 	if ((bio->bi_sector & 7) != 0 || (bio->bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
@@ -838,8 +838,8 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 		goto fail;
 	}
 	/* verify data transfer direction */
-	if (dev_info->is_shared) {
-		switch (dev_info->segment_type) {
+	if (ddi->is_shared) {
+		switch (ddi->segment_type) {
 		case SEG_TYPE_SR:
 		case SEG_TYPE_ER:
 		case SEG_TYPE_SC:
@@ -847,7 +847,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 			if (bio_data_dir(bio) == WRITE) {
 				pr_warning("Writing to %s failed because it "
 					   "is a read-only device\n",
-					   dev_name(&dev_info->dev));
+					   dev_name(&ddi->dev));
 				goto fail;
 			}
 		}
@@ -857,7 +857,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	bio_for_each_segment(bvec, bio, i) {
 		page_addr = (unsigned long)
 			page_address(bvec->bv_page) + bvec->bv_offset;
-		source_addr = dev_info->start + (index<<12) + bytes_done;
+		source_addr = ddi->start + (index<<12) + bytes_done;
 		if (unlikely((page_addr & 4095) != 0) || (bvec->bv_len & 4095) != 0)
 			// More paranoia.
 			goto fail;
@@ -881,18 +881,18 @@ static int
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
 			void **kaddr, unsigned long *pfn)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	unsigned long pgoff;
 
-	dev_info = bdev->bd_disk->private_data;
-	if (!dev_info)
+	ddi = bdev->bd_disk->private_data;
+	if (!ddi)
 		return -ENODEV;
 	if (secnum % (PAGE_SIZE/512))
 		return -EINVAL;
 	pgoff = secnum / (PAGE_SIZE / 512);
-	if ((pgoff+1)*PAGE_SIZE-1 > dev_info->end - dev_info->start)
+	if ((pgoff+1)*PAGE_SIZE-1 > ddi->end - ddi->start)
 		return -ERANGE;
-	*kaddr = (void *) (dev_info->start+pgoff*PAGE_SIZE);
+	*kaddr = (void *) (ddi->start+pgoff*PAGE_SIZE);
 	*pfn = virt_to_phys(*kaddr) >> PAGE_SHIFT;
 
 	return 0;
@@ -903,7 +903,7 @@ dcssblk_check_params(void)
 {
 	int rc, i, j, k;
 	char buf[DCSSBLK_PARM_LEN + 1];
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 
 	for (i = 0; (i < DCSSBLK_PARM_LEN) && (dcssblk_segments[i] != '\0');
 	     i++) {
@@ -922,10 +922,10 @@ dcssblk_check_params(void)
 			buf[k] = '\0';
 			if (!strncmp(&dcssblk_segments[j], "(local)", 7)) {
 				down_read(&dcssblk_devices_sem);
-				dev_info = dcssblk_get_device_by_name(buf);
+				ddi = dcssblk_get_device_by_name(buf);
 				up_read(&dcssblk_devices_sem);
-				if (dev_info)
-					dcssblk_shared_store(&dev_info->dev,
+				if (ddi)
+					dcssblk_shared_store(&ddi->dev,
 							     NULL, "0\n", 2);
 			}
 		}
@@ -945,15 +945,15 @@ dcssblk_check_params(void)
  */
 static int dcssblk_freeze(struct device *dev)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	int rc = 0;
 
-	list_for_each_entry(dev_info, &dcssblk_devices, lh) {
-		switch (dev_info->segment_type) {
+	list_for_each_entry(ddi, &dcssblk_devices, lh) {
+		switch (ddi->segment_type) {
 			case SEG_TYPE_SR:
 			case SEG_TYPE_ER:
 			case SEG_TYPE_SC:
-				if (!dev_info->is_shared)
+				if (!ddi->is_shared)
 					rc = -EINVAL;
 				break;
 			default:
@@ -966,19 +966,19 @@ static int dcssblk_freeze(struct device *dev)
 	if (rc)
 		pr_err("Suspending the system failed because DCSS device %s "
 		       "is writable\n",
-		       dev_info->segment_name);
+		       ddi->segment_name);
 	return rc;
 }
 
 static int dcssblk_restore(struct device *dev)
 {
-	struct dcssblk_dev_info *dev_info;
+	struct dcssblk_dev_info *ddi;
 	struct segment_info *entry;
 	unsigned long start, end;
 	int rc = 0;
 
-	list_for_each_entry(dev_info, &dcssblk_devices, lh) {
-		list_for_each_entry(entry, &dev_info->seg_list, lh) {
+	list_for_each_entry(ddi, &dcssblk_devices, lh) {
+		list_for_each_entry(entry, &ddi->seg_list, lh) {
 			segment_unload(entry->segment_name);
 			rc = segment_load(entry->segment_name, SEGMENT_SHARED,
 					  &start, &end);
-- 
1.7.0.3.311.g6a6955

