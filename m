Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1HPUA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:00:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40759 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1HPUA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:00:27 -0400
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 16 Aug 2011 22:00:07 +0200
X-Google-Sender-Auth: XZznW9q2rIun4hZL0A9Iwv6JDa4
Message-ID: <CAO+b5-prWOxkXcKLM+KctdMjV9YhT8zyyBxjaR6ofnP944hGKw@mail.gmail.com>
Subject: [PATCH] docs/driver-model: Document device.groups
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        rpearson@systemfabricworks.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many drivers use device_create_file() where device.groups should be
used instead. This patch documents that and also removes the comments
about device classes since these should not be used in new code.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/driver-model/device.txt |   78 +++++++++++++++------------------
 1 files changed, 35 insertions(+), 43 deletions(-)

diff --git a/Documentation/driver-model/device.txt
b/Documentation/driver-model/device.txt
index bdefe72..e064ca5 100644
--- a/Documentation/driver-model/device.txt
+++ b/Documentation/driver-model/device.txt
@@ -45,63 +45,55 @@ struct device_attribute {
 			 const char *buf, size_t count);
 };

-Attributes of devices can be exported via drivers using a simple
-procfs-like interface.
+Attributes of devices can be exported by a device driver through sysfs.

 Please see Documentation/filesystems/sysfs.txt for more information
 on how sysfs works.

+As explained in Documentation/kobject.txt, it is crucial that device
+attributes are created before the KOBJ_ADD uevent is generated. The only way
+to realize that is by defining an attribute group.
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

-device_create_file(dev,&dev_attr_power);
-device_remove_file(dev,&dev_attr_power);
-
-The file name will be 'power' with a mode of 0644 (-rw-r--r--).
-
-Word of warning:  While the kernel allows device_create_file() and
-device_remove_file() to be called on a device at any time, userspace has
-strict expectations on when attributes get created.  When a new device is
-registered in the kernel, a uevent is generated to notify userspace (like
-udev) that a new device is available.  If attributes are added after the
-device is registered, then userspace won't get notified and userspace will
-not know about the new attributes.
-
-This is important for device driver that need to publish additional
-attributes for a device at driver probe time.  If the device driver simply
-calls device_create_file() on the device structure passed to it, then
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
+static const struct attribute_group *dev_attr_groups[] = {
+	&dev_attr_group,
+	NULL,
 };

-Then in the module init function is would do:
-	mydriver_class = class_create(THIS_MODULE, "my_attrs");
-	mydriver_class.dev_attr = mydriver_attribs;
+This array of groups can then be associated with a device by setting the
+group pointer in struct device before device_register() is invoked:
+
+      dev->groups = dev_attr_groups;
+      device_register(dev);
+
+The device_register() function will use the 'groups' pointer to create the
+device attributes and the device_unregister() function will use this pointer
+to remove the device attributes.

-And assuming 'dev' is the struct device passed into the probe hook, the driver
-probe function would do something like:
-	device_create(&mydriver_class, dev, chrdev, &private_data, "my_name");
+Note: several documents about writing Linux device drivers recommend to use
+the functions device_create_file() and device_remove_file() to manipulate
+device attributes. That advice is incorrect unfortunately. It is important to
+realize that if attributes are added after a device is registered userspace
+won't get notified and userspace will not know about the new attributes.
-- 
1.7.3.4
