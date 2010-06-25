Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0FYIy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:54:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41064 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab0FYIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=s05q4rGgNdCrurL2AvFKAD8QKkYXQLOz97ZFiho0s9M/+L2cgr3RgHvh6m1DCB7nd5
         lUOhHnoA8KwyjvU91kfR2bGDJBcp/kBvPqrDZlz7OgXg3qhyXvyvSz/OXhPS0dYsYnwC
         AzsDuVcO1gHgZ6sljTC7QsXPWCUZvjMS+jrpc=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-doc@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
       Dmitry Torokhov <dtor@mail.ru>, Marcel Holtmann <marcel@holtmann.org>,
       Magnus Damm <magnus.damm@gmail.com>, Ming Lei <tom.leiming@gmail.com>
Date: Fri, 25 Jun 2010 17:55:11 +0900
Message-Id: <20100625085511.30949.41045.sendpatchset@t400s>
Subject: [PATCH] firmware: Update hotplug script, remove sysfs files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the in-kernel hotplug example script to work
properly with recent kernels. Without this fix the
script may load the firmware twice - both at "add"
and "remove" time.

The second load only triggers in the case when multiple
firmware images are used. A good example is the b43
driver which does not work properly without this fix.

While at it, make sure sysfs files are removed.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Documentation/firmware_class/hotplug-script |   17 +++++++++--------
 drivers/base/firmware_class.c               |    6 +++++-
 2 files changed, 14 insertions(+), 9 deletions(-)

--- 0001/Documentation/firmware_class/hotplug-script
+++ work/Documentation/firmware_class/hotplug-script	2010-06-25 14:46:17.000000000 +0900
@@ -6,11 +6,12 @@
 
 HOTPLUG_FW_DIR=/usr/lib/hotplug/firmware/
 
-echo 1 > /sys/$DEVPATH/loading
-cat $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data
-echo 0 > /sys/$DEVPATH/loading
-
-# To cancel the load in case of error:
-#
-#	echo -1 > /sys/$DEVPATH/loading
-#
+if [ "$SUBSYSTEM" == "firmware" -a "$ACTION" == "add" ]; then
+  if [ -f $HOTPLUG_FW_DIR/$FIRMWARE ]; then
+    echo 1 > /sys/$DEVPATH/loading
+    cat $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data
+    echo 0 > /sys/$DEVPATH/loading
+  else
+    echo -1 > /sys/$DEVPATH/loading
+  fi
+fi
--- 0001/drivers/base/firmware_class.c
+++ work/drivers/base/firmware_class.c	2010-06-25 14:48:53.000000000 +0900
@@ -508,7 +508,7 @@ static int fw_setup_device(struct firmwa
 	retval = device_create_file(f_dev, &dev_attr_loading);
 	if (retval) {
 		dev_err(device, "%s: device_create_file failed\n", __func__);
-		goto error_unreg;
+		goto error_unreg2;
 	}
 
 	if (uevent)
@@ -516,6 +516,8 @@ static int fw_setup_device(struct firmwa
 	*dev_p = f_dev;
 	goto out;
 
+error_unreg2:
+	sysfs_remove_bin_file(&f_dev->kobj, &fw_priv->attr_data);
 error_unreg:
 	device_unregister(f_dev);
 out:
@@ -578,6 +580,8 @@ _request_firmware(const struct firmware 
 	}
 	fw_priv->fw = NULL;
 	mutex_unlock(&fw_lock);
+	sysfs_remove_bin_file(&f_dev->kobj, &fw_priv->attr_data);
+	device_remove_file(f_dev, &dev_attr_loading);
 	device_unregister(f_dev);
 	goto out;
 
