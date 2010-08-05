Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab0HEWcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:32:46 -0400
Received: from kroah.org ([198.145.64.141]:37786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934552Ab0HEWYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:55 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/28] sysfs: fix discrepancies between implementation and documentation
Date: Thu,  5 Aug 2010 15:24:06 -0700
Message-Id: <1281047058-23716-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Fix all discrepancies I know of between the sysfs implementation and its
documentation.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/sysfs.txt |   44 +++++++++++++++++++---------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 931c806..d78ed0b 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -4,7 +4,7 @@ sysfs - _The_ filesystem for exporting kernel objects.
 Patrick Mochel	<mochel@osdl.org>
 Mike Murphy <mamurph@cs.clemson.edu>
 
-Revised:    22 February 2009
+Revised:    10 July 2010
 Original:   10 January 2003
 
 
@@ -124,7 +124,7 @@ show and store methods of the attribute owners.
 
 struct sysfs_ops {
         ssize_t (*show)(struct kobject *, struct attribute *, char *);
-        ssize_t (*store)(struct kobject *, struct attribute *, const char *);
+        ssize_t (*store)(struct kobject *, struct attribute *, const char *, size_t);
 };
 
 [ Subsystems should have already defined a struct kobj_type as a
@@ -139,18 +139,22 @@ calls the associated methods.
 
 To illustrate:
 
+#define to_dev(obj) container_of(obj, struct device, kobj)
 #define to_dev_attr(_attr) container_of(_attr, struct device_attribute, attr)
-#define to_dev(d) container_of(d, struct device, kobj)
 
-static ssize_t
-dev_attr_show(struct kobject * kobj, struct attribute * attr, char * buf)
+static ssize_t dev_attr_show(struct kobject *kobj, struct attribute *attr,
+                             char *buf)
 {
-        struct device_attribute * dev_attr = to_dev_attr(attr);
-        struct device * dev = to_dev(kobj);
-        ssize_t ret = 0;
+        struct device_attribute *dev_attr = to_dev_attr(attr);
+        struct device *dev = to_dev(kobj);
+        ssize_t ret = -EIO;
 
         if (dev_attr->show)
-                ret = dev_attr->show(dev, buf);
+                ret = dev_attr->show(dev, dev_attr, buf);
+        if (ret >= (ssize_t)PAGE_SIZE) {
+                print_symbol("dev_attr_show: %s returned bad count\n",
+                                (unsigned long)dev_attr->show);
+        }
         return ret;
 }
 
@@ -163,10 +167,9 @@ To read or write attributes, show() or store() methods must be
 specified when declaring the attribute. The method types should be as
 simple as those defined for device attributes:
 
-ssize_t (*show)(struct device * dev, struct device_attribute * attr,
-                char * buf);
-ssize_t (*store)(struct device * dev, struct device_attribute * attr,
-                 const char * buf);
+ssize_t (*show)(struct device *dev, struct device_attribute *attr, char *buf);
+ssize_t (*store)(struct device *dev, struct device_attribute *attr,
+                 const char *buf, size_t count);
 
 IOW, they should take only an object, an attribute, and a buffer as parameters.
 
@@ -209,8 +212,8 @@ Other notes:
 
 - show() should always use snprintf(). 
 
-- store() should return the number of bytes used from the buffer. This
-  can be done using strlen().
+- store() should return the number of bytes used from the buffer. If the
+  entire buffer has been used, just return the count argument.
 
 - show() or store() can always return errors. If a bad value comes
   through, be sure to return an error.
@@ -223,15 +226,18 @@ Other notes:
 
 A very simple (and naive) implementation of a device attribute is:
 
-static ssize_t show_name(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t show_name(struct device *dev, struct device_attribute *attr,
+                         char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", dev->name);
 }
 
-static ssize_t store_name(struct device * dev, const char * buf)
+static ssize_t store_name(struct device *dev, struct device_attribute *attr,
+                          const char *buf, size_t count)
 {
-	sscanf(buf, "%20s", dev->name);
-	return strnlen(buf, PAGE_SIZE);
+        snprintf(dev->name, sizeof(dev->name), "%.*s",
+                 (int)min(count, sizeof(dev->name) - 1), buf);
+	return count;
 }
 
 static DEVICE_ATTR(name, S_IRUGO, show_name, store_name);
-- 
1.7.2

