Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0KEMKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 08:10:21 -0400
Received: from smtp.nokia.com ([192.100.105.134]:55303 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0KEMKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 08:10:19 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: hmh@hmh.eng.br, alan@linux.intel.com, akpm@linux-foundation.org,
        gregkh@suse.de
Cc: samu.p.onkalo@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] sysfs: device-core: open - close notifier
Date: Fri,  5 Nov 2010 14:09:46 +0200
Message-Id: <1288958986-26511-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 05 Nov 2010 12:09:54.0673 (UTC) FILETIME=[5B51C610:01CB7CE2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device drivers have no idea when somebody in userspace keeps some sysfs entry
open. The driver just receives read or write calls. The driver may want to
control HW state based on activity so it either have to turn HW on and off
for each sysfs access or it needs separate enable disable entry which controls
the HW state. In cases where sysfs is used to pass some events under interrupt
control (like proximity events from the proximity sensors) it is not enough to
just keep sysfs entry open in userspace.

This patch adds a possibility for driver to know when some sysfs entry is
open.

Device driver structure is enhanced with sysfs_open_close method.
With the help from sysfs file control, device core calls that function
when ever a sysfs attribute is opened or closed.

Driver just have to provide function pointer to by setting up sysfs_open_close
in device_driver struct. Otherwise sysfs file creation or removal is not
affected.

In my test compilation in 32 bit system total impact to memory consumption
is about 500 bytes.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/base/core.c    |   14 ++++++++++++++
 fs/sysfs/file.c        |   17 ++++++++++++++++-
 include/linux/device.h |    2 ++
 include/linux/sysfs.h  |    4 ++++
 4 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6ed6454..879404b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -112,9 +112,23 @@ static ssize_t dev_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
+static int dev_attr_open_close(struct kobject *kobj, struct attribute *attr,
+	int mode)
+{
+	struct device *dev = to_dev(kobj);
+	int ret = 0;
+	if (dev->driver && unlikely(dev->driver->sysfs_open_close)) {
+		ret = dev->driver->sysfs_open_close(dev, attr, mode);
+		if (unlikely(ret > 0))
+			ret = 0; /* Caller expects error code or zero */
+	}
+	return ret;
+}
+
 static const struct sysfs_ops dev_sysfs_ops = {
 	.show	= dev_attr_show,
 	.store	= dev_attr_store,
+	.open_close = dev_attr_open_close,
 };
 
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index da3fefe..0a1cc2f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -392,10 +392,19 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (error)
 		goto err_free;
 
+	/* Notify about open dirent */
+	if (ops->open_close) {
+		error = ops->open_close(kobj, attr_sd->s_attr.attr,
+					SYSFS_OPEN_NOTIFY);
+		if (error)
+			goto err_open;
+	}
+
 	/* open succeeded, put active references */
 	sysfs_put_active(attr_sd);
 	return 0;
-
+err_open:
+	sysfs_put_open_dirent(attr_sd, buffer);
  err_free:
 	kfree(buffer);
  err_out:
@@ -407,6 +416,12 @@ static int sysfs_release(struct inode *inode, struct file *filp)
 {
 	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_buffer *buffer = filp->private_data;
+	struct kobject *kobj = sd->s_parent->s_dir.kobj;
+	const struct sysfs_ops *ops = kobj->ktype->sysfs_ops;
+
+	/* Notify about dirent release */
+	if (ops->open_close)
+		ops->open_close(kobj, sd->s_attr.attr, SYSFS_CLOSE_NOTIFY);
 
 	sysfs_put_open_dirent(sd, buffer);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index dd48953..599ff9f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -138,6 +138,8 @@ struct device_driver {
 	void (*shutdown) (struct device *dev);
 	int (*suspend) (struct device *dev, pm_message_t state);
 	int (*resume) (struct device *dev);
+	int (*sysfs_open_close) (struct device *dev, struct attribute *,
+				int mode);
 	const struct attribute_group **groups;
 
 	const struct dev_pm_ops *pm;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 30b8815..a8fe118 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -112,8 +112,12 @@ struct bin_attribute {
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
+	int (*open_close)(struct kobject *, struct attribute *, int mode);
 };
 
+#define SYSFS_CLOSE_NOTIFY 0
+#define SYSFS_OPEN_NOTIFY  1
+
 struct sysfs_dirent;
 
 #ifdef CONFIG_SYSFS
-- 
1.6.0.4

