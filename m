Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0KDJEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:04:37 -0400
Received: from smtp.nokia.com ([147.243.1.47]:56493 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab0KDJEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:04:34 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: hmh@hmh.eng.br, alan@linux.intel.com, akpm@linux-foundation.org,
        gregkh@suse.de
Cc: samu.p.onkalo@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: device-core: sysfs open close notify
Date: Thu,  4 Nov 2010 11:03:37 +0200
Message-Id: <1288861417-469-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds possibility for a driver to get open and close
notifications from the sysfs accesses. Driver may need this
information for enabling features and for runtime
power management control.

Patch causes quite small overhead compared to current implementation.
Sysfs_ops is enhanced with open_close notify method which causes
some increase to static memory consumption. Sysfs attribute defition
is not changed.

Device core is modified with open_close_notification function and
corresponding sysfs_ops change. New macro is introduced which can
be used to setup sysfs attributes with open_close notification
in a device driver.

Sysfs control itself contains new optional calls to open_close_
notifications and a function which controls the feature.
By default nothing it changed at runtime.

Normal sysfs creation and remove functions can be used to control
attributes in device drivers.

Change needed device drivers:
For sysfs attributes which needs open_close_notification:
Use DEVICE_ATTR_NOTIFY instead of DEVICE_ATTR with sysfs attributes.
Call sysfs_set_open_notify for those attributes after the creation.

I my environment total change in vmlinux is less than 400 bytes.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---

Note! If the mode parameter is used to pass information that the
attribute uses open_close_notify, sysfs_set_open_notify is not needed.
i.e. DEVICE_ATTR_NOTIFY adds a bit to _mode like:
(_mode) | USE_SYSFS_NOTIFY. This way control bit could be set automatically
during the creation of the sysfs directory entry. Question is that is it
acceptable to use mode parameter in that way?


 drivers/base/core.c    |   19 ++++++++++++++++++
 fs/sysfs/file.c        |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h       |    1 +
 include/linux/device.h |   12 +++++++++++
 include/linux/sysfs.h  |   13 ++++++++++++
 5 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6ed6454..089d92d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -112,9 +112,28 @@ static ssize_t dev_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
+static int dev_attr_open_close(struct kobject *kobj, struct attribute *attr,
+			int mode)
+{
+	struct device_attribute_notify *attr_n = container_of(attr,
+				 struct device_attribute_notify, d_attr.attr);
+	struct device *dev = to_dev(kobj);
+	struct device_attribute *dev_attr = to_dev_attr(attr);
+	int ret = 0;
+
+	if (attr_n->open_close_notify) {
+		ret = attr_n->open_close_notify(dev, dev_attr, mode);
+		/* Caller doesn't tolerate > 0 success values */
+		if (ret > 0)
+			ret = 0;
+	}
+	return ret;
+}
+
 static const struct sysfs_ops dev_sysfs_ops = {
 	.show	= dev_attr_show,
 	.store	= dev_attr_store,
+	.open_close_notify = dev_attr_open_close,
 };
 
 
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index da3fefe..73b5d2d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -392,10 +392,20 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (error)
 		goto err_free;
 
+	if (unlikely(attr_sd->s_flags & SYSFS_FLAG_OPEN_NOTIFY) &&
+		ops->open_close_notify) {
+		error = ops->open_close_notify(kobj, attr_sd->s_attr.attr,
+					SYSFS_OPEN_NOTIFY);
+		if (error < 0)
+			goto err_open_notify;
+	}
+
 	/* open succeeded, put active references */
 	sysfs_put_active(attr_sd);
 	return 0;
 
+err_open_notify:
+	sysfs_put_open_dirent(attr_sd, buffer);
  err_free:
 	kfree(buffer);
  err_out:
@@ -407,6 +417,13 @@ static int sysfs_release(struct inode *inode, struct file *filp)
 {
 	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_buffer *buffer = filp->private_data;
+	struct kobject *kobj = sd->s_parent->s_dir.kobj;
+	const struct sysfs_ops *ops = kobj->ktype->sysfs_ops;
+
+	if (unlikely(sd->s_flags & SYSFS_FLAG_OPEN_NOTIFY) &&
+		ops->open_close_notify)
+		ops->open_close_notify(kobj, sd->s_attr.attr,
+				SYSFS_CLOSE_NOTIFY);
 
 	sysfs_put_open_dirent(sd, buffer);
 
@@ -617,6 +634,38 @@ int sysfs_chmod_file(struct kobject *kobj, const struct attribute *attr,
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
 
+/**
+ * sysfs_set_open_notify - Control open notify feature for an attribute
+ * @kobj: object we're acting for.
+ * @attr: attribute descriptor.
+ *
+ * Other writes to s_flags are protected by sysfs_mutex after the creation of
+ * the sysfs_dirent.
+ */
+int sysfs_set_open_notify(struct kobject *kobj, const struct attribute *attr,
+		     bool mode)
+{
+	struct sysfs_dirent *sd;
+	int rc;
+
+	mutex_lock(&sysfs_mutex);
+
+	rc = -ENOENT;
+	sd = sysfs_find_dirent(kobj->sd, NULL, attr->name);
+	if (!sd)
+		goto out;
+
+	if (mode)
+		sd->s_flags |= SYSFS_FLAG_OPEN_NOTIFY;
+	else
+		sd->s_flags &= ~SYSFS_FLAG_OPEN_NOTIFY;
+	rc = 0;
+out:
+	mutex_unlock(&sysfs_mutex);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sysfs_set_open_notify);
+
 
 /**
  *	sysfs_remove_file - remove an object attribute.
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index d9be60a..d558770 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -88,6 +88,7 @@ struct sysfs_dirent {
 
 #define SYSFS_FLAG_MASK			~(SYSFS_NS_TYPE_MASK|SYSFS_TYPE_MASK)
 #define SYSFS_FLAG_REMOVED		0x020000
+#define SYSFS_FLAG_OPEN_NOTIFY          0x040000
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index dd48953..1c13464 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -342,6 +342,18 @@ struct device_attribute {
 			 const char *buf, size_t count);
 };
 
+struct device_attribute_notify {
+	int (*open_close_notify)(struct device *dev,
+				struct device_attribute *attr, int op);
+	struct device_attribute d_attr;
+};
+
+#define DEVICE_ATTR_NOTIFY(_name, _mode, _show, _store, _notify) \
+	struct device_attribute_notify dev_attr_notify_##_name = {\
+		.open_close_notify = _notify,				 \
+		.d_attr = __ATTR(_name, _mode, _show, _store)	 \
+	}
+
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
 struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 30b8815..f04c85e 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -112,8 +112,12 @@ struct bin_attribute {
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
+	int (*open_close_notify)(struct kobject *, struct attribute *, int op);
 };
 
+#define SYSFS_OPEN_NOTIFY	1
+#define SYSFS_CLOSE_NOTIFY	0
+
 struct sysfs_dirent;
 
 #ifdef CONFIG_SYSFS
@@ -183,6 +187,9 @@ void sysfs_exit_ns(enum kobj_ns_type type, const void *tag);
 
 int __must_check sysfs_init(void);
 
+int sysfs_set_open_notify(struct kobject *kobj, const struct attribute *attr,
+			bool mode);
+
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_schedule_callback(struct kobject *kobj,
@@ -352,6 +359,12 @@ static inline void sysfs_printk_last_file(void)
 {
 }
 
+int sysfs_set_open_notify(struct kobject *kobj, const struct attribute *attr,
+		     bool mode)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SYSFS */
 
 #endif /* _SYSFS_H_ */
-- 
1.6.0.4

