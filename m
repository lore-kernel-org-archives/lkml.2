Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0G2NeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:34:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0G2NeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:34:18 -0400
From: Milan Broz <mbroz@redhat.com>
To: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org,
        kzak@redhat.com, axboe@kernel.dk
Cc: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] loop: add some basic read-only sysfs attributes
Date: Thu, 29 Jul 2010 15:33:55 +0200
Message-Id: <1280410435-7017-1-git-send-email-mbroz@redhat.com>
In-Reply-To: <20100722101541.GU15652@nb.net.home>
References: <20100722101541.GU15652@nb.net.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create /sys/block/loopX/loop directory and provide these attributes:
 - backing_file
 - autoclear
 - offset
 - sizelimit

To be used in util-linux-ng (and possibly elsewhere like udev rules)
where code need to get loop attributes from kernel (and not store
duplicate info in userspace).

Moreover loop ioctls are not even able to provide full backing
file info because of buffer limits.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/block/loop.c |  110 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/loop.h |    2 +
 2 files changed, 111 insertions(+), 1 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6120922..573fd5a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -73,6 +73,7 @@
 #include <linux/highmem.h>
 #include <linux/kthread.h>
 #include <linux/splice.h>
+#include <linux/sysfs.h>
 
 #include <asm/uaccess.h>
 
@@ -1542,8 +1543,112 @@ out:
 	return NULL;
 }
 
+/* loop sysfs attributes */
+
+struct loop_sysfs_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct loop_device *, char *);
+	ssize_t (*store)(struct loop_device *, char *);
+};
+
+#define LOOP_ATTR_RO(_name) \
+struct loop_sysfs_attr loop_attr_##_name = \
+	__ATTR(_name, S_IRUGO, loop_attr_##_name##_show, NULL)
+
+static ssize_t loop_attr_show(struct kobject *kobj,
+			      struct attribute *attr,
+			      char *page)
+{
+	struct loop_device *lo;
+	struct loop_sysfs_attr *loop_attr;
+
+	lo = container_of(kobj, struct loop_device, lo_kobj);
+	loop_attr = container_of(attr, struct loop_sysfs_attr, attr);
+
+	if (!loop_attr->show)
+		return -EIO;
+
+	return loop_attr->show(lo, page);
+}
+
+static ssize_t loop_attr_backing_file_show(struct loop_device *lo, char *buf)
+{
+	ssize_t ret;
+	char *p;
+
+	if (lo->lo_state != Lo_bound)
+		return 0;
+
+	mutex_lock(&lo->lo_ctl_mutex);
+	p = d_path(&lo->lo_backing_file->f_path, buf, PAGE_SIZE - 1);
+	mutex_unlock(&lo->lo_ctl_mutex);
+
+	if (IS_ERR(p))
+		ret = PTR_ERR(p);
+	else {
+		ret = strlen(p);
+		memmove(buf, p, ret);
+		buf[ret++] = '\n';
+		buf[ret] = 0;
+	}
+
+	return ret;
+}
+
+static ssize_t loop_attr_offset_show(struct loop_device *lo, char *buf)
+{
+	return sprintf(buf, "%llu\n", (unsigned long long)lo->lo_offset);
+}
+
+static ssize_t loop_attr_sizelimit_show(struct loop_device *lo, char *buf)
+{
+	return sprintf(buf, "%llu\n", (unsigned long long)lo->lo_sizelimit);
+}
+
+static ssize_t loop_attr_autoclear_show(struct loop_device *lo, char *buf)
+{
+	int autoclear = (lo->lo_flags & LO_FLAGS_AUTOCLEAR);
+
+	return sprintf(buf, "%s\n", autoclear ? "1" : "0");
+}
+
+static LOOP_ATTR_RO(backing_file);
+static LOOP_ATTR_RO(offset);
+static LOOP_ATTR_RO(sizelimit);
+static LOOP_ATTR_RO(autoclear);
+
+static struct attribute *loop_attrs[] = {
+	&loop_attr_backing_file.attr,
+	&loop_attr_offset.attr,
+	&loop_attr_sizelimit.attr,
+	&loop_attr_autoclear.attr,
+	NULL,
+};
+
+static const struct sysfs_ops loop_sysfs_ops = {
+	.show	= loop_attr_show,
+};
+
+static struct kobj_type loop_ktype = {
+	.sysfs_ops	= &loop_sysfs_ops,
+	.default_attrs	= loop_attrs,
+};
+
+static int  loop_sysfs_init(struct loop_device *lo)
+{
+	return kobject_init_and_add(&lo->lo_kobj, &loop_ktype,
+				    &disk_to_dev(lo->lo_disk)->kobj,
+				    "%s", "loop");
+}
+
+static void loop_sysfs_exit(struct loop_device *lo)
+{
+	kobject_put(&lo->lo_kobj);
+}
+
 static void loop_free(struct loop_device *lo)
 {
+	loop_sysfs_exit(lo);
 	blk_cleanup_queue(lo->lo_queue);
 	put_disk(lo->lo_disk);
 	list_del(&lo->lo_list);
@@ -1562,6 +1667,7 @@ static struct loop_device *loop_init_one(int i)
 	lo = loop_alloc(i);
 	if (lo) {
 		add_disk(lo->lo_disk);
+		loop_sysfs_init(lo);
 		list_add_tail(&lo->lo_list, &loop_devices);
 	}
 	return lo;
@@ -1635,8 +1741,10 @@ static int __init loop_init(void)
 
 	/* point of no return */
 
-	list_for_each_entry(lo, &loop_devices, lo_list)
+	list_for_each_entry(lo, &loop_devices, lo_list) {
 		add_disk(lo->lo_disk);
+		loop_sysfs_init(lo);
+	}
 
 	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
 				  THIS_MODULE, loop_probe, NULL, NULL);
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 66c194e..0b26385 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -65,6 +65,8 @@ struct loop_device {
 	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
 	struct list_head	lo_list;
+
+	struct kobject		lo_kobj;
 };
 
 #endif /* __KERNEL__ */
-- 
1.7.1

