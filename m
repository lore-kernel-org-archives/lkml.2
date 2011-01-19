Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1ASECB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:02:01 -0500
Received: from ixqw-mail-out.ixiacom.com ([66.77.12.12]:5373 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab1ASECA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:02:00 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2011 23:02:00 EST
Message-ID: <4D366104.1000400@ixiacom.com>
Date: Tue, 18 Jan 2011 19:56:52 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: "Hans J. Koch" <hjk@linutronix.de>
Subject: RFC: UIO  null parent for __uio_register_device and uio_device_name()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans,

I had a two UIO changes queued up from earlier which I
forgot to ask you about.

Would you consider these changes for inclusion in the mainline ?


o Allow a null parent during uio_register_device. We've had
  situations where there was no convenient parent. We could
  concoct a parent, but it seemed to make sense to allow
  for a null.

  The commentary for device_create() say:

 * device_create - creates a device and registers it with sysfs
 * @class: pointer to the struct class that this device should be registered to
 * @parent: pointer to the parent struct device of this new device, if any

 The "if any" suggests that a null parent is possibility that is catered for.

 Our implementation with a null parent seems to work fine.

o Introduce uio_device_name() to allow callers to query for the
  name of the created uio device. Without this, there doesn't seem
  to be a straightforward way for a client to figure out the name of the
  device.




--- /tmp/uio.c.orig     2011-01-18 17:38:17.157452875 -0800
+++ /tmp/uio.c  2011-01-18 19:46:48.367453578 -0800
@@ -808,6 +808,18 @@
 }

 /**
+ * uio_device_name - obtain the name of the registered device
+ * @info:      UIO device capabilities
+ *
+ * returns name of device.
+ */
+const char *uio_device_name(struct uio_info *info)
+{
+       return dev_name(info->uio_dev->dev);
+}
+EXPORT_SYMBOL_GPL(uio_device_name);
+
+/**
  * uio_register_device - register a new userspace IO device
  * @owner:     module that creates the new device
  * @parent:    parent device
@@ -822,7 +834,7 @@
        struct uio_device *idev;
        int ret = 0;

-       if (!parent || !info || !info->name || !info->version)
+       if (!info || !info->name || !info->version)
                return -EINVAL;

        info->uio_dev = NULL;

--- /tmp/uio.c.orig     2011-01-18 17:38:17.157452875 -0800
+++ /tmp/uio.c  2011-01-18 17:38:56.307452064 -0800
@@ -822,7 +822,7 @@
        struct uio_device *idev;
        int ret = 0;

-       if (!parent || !info || !info->name || !info->version)
+       if (!info || !info->name || !info->version)
                return -EINVAL;

        info->uio_dev = NULL;


--- /tmp/uio_driver.h.orig      2011-01-18 19:42:13.777452360 -0800
+++ /tmp/uio_driver.h   2011-01-18 19:45:03.507453695 -0800
@@ -105,6 +105,7 @@
 }
 extern void uio_unregister_device(struct uio_info *info);
 extern void uio_event_notify(struct uio_info *info);
+extern const char *uio_device_name(struct uio_device *info);

 /* defines for uio_info->irq */
 #define UIO_IRQ_CUSTOM -1
