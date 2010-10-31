Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0JaMrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 08:47:01 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37372 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab0JaMq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 08:46:59 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: gregkh@suse.de, hmh@hmh.eng.br, alan@linux.intel.com,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] device-core: sysfs open - close notify
Date: Sun, 31 Oct 2010 14:46:10 +0200
Message-Id: <1288529170-28890-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 31 Oct 2010 12:46:14.0532 (UTC) FILETIME=[9A8D1C40:01CB78F9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device drivers have no idea when somebody in userspace keeps some sysfs entry
open. The driver just received read or write calls. The driver may want to
control HW state based on activity so it either have to turn HW on and off
for each sysfs access or it needs separate enable disable entry which controls
the HW state. In cases where sysfs is used to pass some events under interrupt
control (like proximity events from the proximity sensors) it is not enough to
just keep sysfs entry open in userspace.

This patch adds a possibility for driver to know when some sysfs entry is
open.

Device driver structure is enhanced with optional open and close methods.
Device driver can provide those if it needs information about the sysfs
activity. Device core is enhanced to provide open / close methods for
sysfs file operations. Sysfs open / close operations call open / close
methods if they are provided.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/base/core.c    |   24 ++++++++++++++++++++++++
 fs/sysfs/file.c        |   16 +++++++++++++++-
 include/linux/device.h |    2 ++
 include/linux/sysfs.h  |    2 ++
 4 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6ed6454..f9c5810 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -112,9 +112,33 @@ static ssize_t dev_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
+static int dev_attr_open(struct kobject *kobj, struct attribute *attr)
+{
+	struct device *dev = to_dev(kobj);
+	int ret = 0;
+	if (dev->driver && unlikely(dev->driver->open)) {
+		ret = dev->driver->open(dev, attr);
+		if (unlikely(ret > 0)) {
+			WARN(1, KERN_ERR "%s driver open call returned "
+				"positive value\n", dev->driver->name);
+			ret = -EPERM;
+		}
+	}
+	return ret;
+}
+
+static void dev_attr_close(struct kobject *kobj, struct attribute *attr)
+{
+	struct device *dev = to_dev(kobj);
+	if (dev->driver && dev->driver->close)
+		dev->driver->close(dev, attr);
+}
+
 static const struct sysfs_ops dev_sysfs_ops = {
 	.show	= dev_attr_show,
 	.store	= dev_attr_store,
+	.open	= dev_attr_open,
+	.close	= dev_attr_close,
 };
 
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index da3fefe..4feaec2 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -392,10 +392,18 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (error)
 		goto err_free;
 
+	/* Notify about open dirent */
+	if (ops->open) {
+		error = ops->open(kobj, attr_sd->s_attr.attr);
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
@@ -407,6 +415,12 @@ static int sysfs_release(struct inode *inode, struct file *filp)
 {
 	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_buffer *buffer = filp->private_data;
+	struct kobject *kobj = sd->s_parent->s_dir.kobj;
+	const struct sysfs_ops *ops = kobj->ktype->sysfs_ops;
+
+	/* Notify about dirent release */
+	if (ops->close)
+		ops->close(kobj, sd->s_attr.attr);
 
 	sysfs_put_open_dirent(sd, buffer);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index dd48953..788d982 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -138,6 +138,8 @@ struct device_driver {
 	void (*shutdown) (struct device *dev);
 	int (*suspend) (struct device *dev, pm_message_t state);
 	int (*resume) (struct device *dev);
+	int (*open) (struct device *dev, struct attribute *);
+	void (*close) (struct device *dev, struct attribute *);
 	const struct attribute_group **groups;
 
 	const struct dev_pm_ops *pm;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 30b8815..9b92c29 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -112,6 +112,8 @@ struct bin_attribute {
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
+	int (*open)(struct kobject *, struct attribute *);
+	void (*close)(struct kobject *, struct attribute *);
 };
 
 struct sysfs_dirent;
-- 
1.6.0.4

