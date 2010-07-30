Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab0G3OWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:22:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab0G3OWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:22:16 -0400
Message-ID: <4C52E013.7010105@redhat.com>
Date: Fri, 30 Jul 2010 16:22:11 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Karel Zak <kzak@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH v2] loop: add some basic read-only sysfs attributes
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> 	<AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> 	<4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> 	<20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com> 	<20100729195616.GF1981@nb.net.home> <4C51E36F.6060906@redhat.com> <AANLkTimq0UVtR-ooutKTfOOE=cS-vxR4gR-aVc1feOzJ@mail.gmail.com>
In-Reply-To: <AANLkTimq0UVtR-ooutKTfOOE=cS-vxR4gR-aVc1feOzJ@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/30/2010 06:36 AM, Kay Sievers wrote:

> Alternatively, these attributes could be created and removed/created
> with the ioctl, and before the 'change' event, only if there is an
> active backing file, but I would expect the attribute group at the
> device to work just fine.
I have no idea how you can add attribute group before add_disk() which
initializes kobj (it ends with BUG_ON in internal_create_group
- because !kobj->sd). Perhaps I missed something?

Anyway, second approach works - now is loop attributes available only
when loop is configured and before CHANGE uevent is sent.

Ok with that?

Milan
-

loop: add some basic read-only sysfs attributes

Create /sys/block/loopX/loop directory and provide these attributes:
 - backing_file
 - autoclear
 - offset
 - sizelimit

This loop directory is present only if loop device is configured.

To be used in util-linux-ng (and possibly elsewhere like udev rules)
where code need to get loop attributes from kernel (and not store
duplicate info in userspace).

Moreover loop ioctls are not even able to provide full backing
file info because of buffer limits.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/block/loop.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6120922..fea84d1 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -73,6 +73,7 @@
 #include <linux/highmem.h>
 #include <linux/kthread.h>
 #include <linux/splice.h>
+#include <linux/sysfs.h>
 
 #include <asm/uaccess.h>
 
@@ -736,6 +737,103 @@ static inline int is_loop_device(struct file *file)
 	return i && S_ISBLK(i->i_mode) && MAJOR(i->i_rdev) == LOOP_MAJOR;
 }
 
+/* loop sysfs attributes */
+
+static ssize_t loop_attr_show(struct device *dev, char *page,
+			      ssize_t (*callback)(struct loop_device *, char *))
+{
+	struct loop_device *l, *lo = NULL;
+
+	mutex_lock(&loop_devices_mutex);
+	list_for_each_entry(l, &loop_devices, lo_list)
+		if (disk_to_dev(l->lo_disk) == dev) {
+			lo = l;
+			break;
+		}
+	mutex_unlock(&loop_devices_mutex);
+
+	return lo ? callback(lo, page) : -EIO;
+}
+
+#define LOOP_ATTR_RO(_name)						\
+static ssize_t loop_attr_##_name##_show(struct loop_device *, char *);	\
+static ssize_t loop_attr_do_show_##_name(struct device *d,		\
+				struct device_attribute *attr, char *b)	\
+{									\
+	return loop_attr_show(d, b, loop_attr_##_name##_show);		\
+}									\
+static struct device_attribute loop_attr_##_name =			\
+	__ATTR(_name, S_IRUGO, loop_attr_do_show_##_name, NULL);
+
+static ssize_t loop_attr_backing_file_show(struct loop_device *lo, char *buf)
+{
+	ssize_t ret;
+	char *p = NULL;
+
+	mutex_lock(&lo->lo_ctl_mutex);
+	if (lo->lo_backing_file)
+		p = d_path(&lo->lo_backing_file->f_path, buf, PAGE_SIZE - 1);
+	mutex_unlock(&lo->lo_ctl_mutex);
+
+	if (IS_ERR_OR_NULL(p))
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
+LOOP_ATTR_RO(backing_file);
+LOOP_ATTR_RO(offset);
+LOOP_ATTR_RO(sizelimit);
+LOOP_ATTR_RO(autoclear);
+
+static struct attribute *loop_attrs[] = {
+	&loop_attr_backing_file.attr,
+	&loop_attr_offset.attr,
+	&loop_attr_sizelimit.attr,
+	&loop_attr_autoclear.attr,
+	NULL,
+};
+
+static struct attribute_group loop_attribute_group = {
+	.name = "loop",
+	.attrs= loop_attrs,
+};
+
+static int loop_sysfs_init(struct loop_device *lo)
+{
+	return sysfs_create_group(&disk_to_dev(lo->lo_disk)->kobj,
+				  &loop_attribute_group);
+}
+
+static void loop_sysfs_exit(struct loop_device *lo)
+{
+	sysfs_remove_group(&disk_to_dev(lo->lo_disk)->kobj,
+			   &loop_attribute_group);
+}
+
 static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 		       struct block_device *bdev, unsigned int arg)
 {
@@ -835,6 +933,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 
 	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
+	loop_sysfs_init(lo);
 	/* let user-space know about the new size */
 	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 
@@ -853,6 +952,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	return 0;
 
 out_clr:
+	loop_sysfs_exit(lo);
 	lo->lo_thread = NULL;
 	lo->lo_device = NULL;
 	lo->lo_backing_file = NULL;
@@ -949,6 +1049,7 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	set_capacity(lo->lo_disk, 0);
 	if (bdev) {
 		bd_set_size(bdev, 0);
+		loop_sysfs_exit(lo);
 		/* let user-space know about this change */
 		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	}


