Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1HWR1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:27:40 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:47510 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507Ab1HWR1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:27:36 -0400
From: Bart Van Assche <bvanassche@acm.org>
Reply-To: bvanassche@acm.org
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 1/2, v3] docs/driver-model: Document device.groups
Date: Tue, 23 Aug 2011 19:27:27 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-default; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        rpearson@systemfabricworks.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108231927.27765.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several drivers use device_create_file() where device.groups should be
used instead. This patch documents that and also removes the comments
about device classes since these should not be used in new code in the
way documented until now in Documentation/driver-model/device.txt.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/driver-model/device.txt |   65 ++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/Documentation/driver-model/device.txt b/Documentation/driver-model/device.txt
index bdefe72..1e70220 100644
--- a/Documentation/driver-model/device.txt
+++ b/Documentation/driver-model/device.txt
@@ -45,33 +45,52 @@ struct device_attribute {
 			 const char *buf, size_t count);
 };
 
-Attributes of devices can be exported via drivers using a simple
-procfs-like interface. 
+Attributes of devices can be exported by a device driver through sysfs.
 
 Please see Documentation/filesystems/sysfs.txt for more information
 on how sysfs works.
 
+As explained in Documentation/kobject.txt, device attributes must be be
+created before the KOBJ_ADD uevent is generated. The only way to realize
+that is by defining an attribute group.
+
 Attributes are declared using a macro called DEVICE_ATTR:
 
 #define DEVICE_ATTR(name,mode,show,store)
 
 Example:
 
-DEVICE_ATTR(power,0644,show_power,store_power);
+static DEVICE_ATTR(type, 0444, show_type, NULL);
+static DEVICE_ATTR(power, 0644, show_power, store_power);
 
-This declares a structure of type struct device_attribute named
-'dev_attr_power'. This can then be added and removed to the device's
-directory using:
+This declares two structures of type struct device_attribute with respective
+names 'dev_attr_type' and 'dev_attr_power'. These two attributes can be
+organized as follows into a group:
 
-int device_create_file(struct device *device, struct device_attribute * entry);
-void device_remove_file(struct device * dev, struct device_attribute * attr);
+static struct attribute *dev_attrs[] = {
+	&dev_attr_type.attr,
+	&dev_attr_power.attr,
+	NULL,
+};
 
-Example:
+static struct attribute_group dev_attr_group = {
+	.attrs = dev_attrs,
+};
+
+static const struct attribute_group *dev_attr_groups[] = {
+	&dev_attr_group,
+	NULL,
+};
+
+This array of groups can then be associated with a device by setting the
+group pointer in struct device before device_register() is invoked:
 
-device_create_file(dev,&dev_attr_power);
-device_remove_file(dev,&dev_attr_power);
+      dev->groups = dev_attr_groups;
+      device_register(dev);
 
-The file name will be 'power' with a mode of 0644 (-rw-r--r--).
+The device_register() function will use the 'groups' pointer to create the
+device attributes and the device_unregister() function will use this pointer
+to remove the device attributes.
 
 Word of warning:  While the kernel allows device_create_file() and
 device_remove_file() to be called on a device at any time, userspace has
@@ -84,24 +103,4 @@ not know about the new attributes.
 This is important for device driver that need to publish additional
 attributes for a device at driver probe time.  If the device driver simply
 calls device_create_file() on the device structure passed to it, then
-userspace will never be notified of the new attributes.  Instead, it should
-probably use class_create() and class->dev_attrs to set up a list of
-desired attributes in the modules_init function, and then in the .probe()
-hook, and then use device_create() to create a new device as a child
-of the probed device.  The new device will generate a new uevent and
-properly advertise the new attributes to userspace.
-
-For example, if a driver wanted to add the following attributes:
-struct device_attribute mydriver_attribs[] = {
-	__ATTR(port_count, 0444, port_count_show),
-	__ATTR(serial_number, 0444, serial_number_show),
-	NULL
-};
-
-Then in the module init function is would do:
-	mydriver_class = class_create(THIS_MODULE, "my_attrs");
-	mydriver_class.dev_attr = mydriver_attribs;
-
-And assuming 'dev' is the struct device passed into the probe hook, the driver
-probe function would do something like:
-	device_create(&mydriver_class, dev, chrdev, &private_data, "my_name");
+userspace will never be notified of the new attributes.
-- 
1.7.3.4

