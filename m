Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab2GCQp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:45:58 -0400
Received: from smtp-out-143.synserver.de ([212.40.185.143]:1093 "EHLO
	smtp-out-143.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2GCQpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:45:53 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8920
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] driver-core: Use kobj_to_dev instead of re-implementing it
Date: Tue,  3 Jul 2012 18:49:36 +0200
Message-Id: <1341334176-8801-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341334176-8801-1-git-send-email-lars@metafoo.de>
References: <1341334176-8801-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/core.c           |   17 ++++++++---------
 drivers/base/firmware_class.c |    6 ++----
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 846d12b..c2cca47 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -85,14 +85,13 @@ const char *dev_driver_string(const struct device *dev)
 }
 EXPORT_SYMBOL(dev_driver_string);
 
-#define to_dev(obj) container_of(obj, struct device, kobj)
 #define to_dev_attr(_attr) container_of(_attr, struct device_attribute, attr)
 
 static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
 			     char *buf)
 {
 	struct device_attribute *dev_attr = to_dev_attr(attr);
-	struct device *dev = to_dev(kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	ssize_t ret = -EIO;
 
 	if (dev_attr->show)
@@ -108,7 +107,7 @@ static ssize_t dev_attr_store(struct kobject *kobj, struct attribute *attr,
 			      const char *buf, size_t count)
 {
 	struct device_attribute *dev_attr = to_dev_attr(attr);
-	struct device *dev = to_dev(kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	ssize_t ret = -EIO;
 
 	if (dev_attr->store)
@@ -182,7 +181,7 @@ EXPORT_SYMBOL_GPL(device_show_int);
  */
 static void device_release(struct kobject *kobj)
 {
-	struct device *dev = to_dev(kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct device_private *p = dev->p;
 
 	if (dev->release)
@@ -200,7 +199,7 @@ static void device_release(struct kobject *kobj)
 
 static const void *device_namespace(struct kobject *kobj)
 {
-	struct device *dev = to_dev(kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	const void *ns = NULL;
 
 	if (dev->class && dev->class->ns_type)
@@ -221,7 +220,7 @@ static int dev_uevent_filter(struct kset *kset, struct kobject *kobj)
 	struct kobj_type *ktype = get_ktype(kobj);
 
 	if (ktype == &device_ktype) {
-		struct device *dev = to_dev(kobj);
+		struct device *dev = kobj_to_dev(kobj);
 		if (dev->bus)
 			return 1;
 		if (dev->class)
@@ -232,7 +231,7 @@ static int dev_uevent_filter(struct kset *kset, struct kobject *kobj)
 
 static const char *dev_uevent_name(struct kset *kset, struct kobject *kobj)
 {
-	struct device *dev = to_dev(kobj);
+	struct device *dev = kobj_to_dev(kobj);
 
 	if (dev->bus)
 		return dev->bus->name;
@@ -244,7 +243,7 @@ static const char *dev_uevent_name(struct kset *kset, struct kobject *kobj)
 static int dev_uevent(struct kset *kset, struct kobject *kobj,
 		      struct kobj_uevent_env *env)
 {
-	struct device *dev = to_dev(kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	int retval = 0;
 
 	/* add device node properties if present */
@@ -1132,7 +1131,7 @@ int device_register(struct device *dev)
  */
 struct device *get_device(struct device *dev)
 {
-	return dev ? to_dev(kobject_get(&dev->kobj)) : NULL;
+	return dev ? kobj_to_dev(kobject_get(&dev->kobj)) : NULL;
 }
 
 /**
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 5401814..803cfc1 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -22,8 +22,6 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
-#define to_dev(obj) container_of(obj, struct device, kobj)
-
 MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
@@ -290,7 +288,7 @@ static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
 				  struct bin_attribute *bin_attr,
 				  char *buffer, loff_t offset, size_t count)
 {
-	struct device *dev = to_dev(kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	struct firmware *fw;
 	ssize_t ret_count;
@@ -384,7 +382,7 @@ static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
 				   struct bin_attribute *bin_attr,
 				   char *buffer, loff_t offset, size_t count)
 {
-	struct device *dev = to_dev(kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
 	struct firmware *fw;
 	ssize_t retval;
-- 
1.7.10

