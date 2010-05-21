Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab0EUQ6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:58:43 -0400
Received: from kroah.org ([198.145.64.141]:39126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934124Ab0EUQya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/38] driver core: Implement ns directory support for device classes.
Date: Fri, 21 May 2010 09:53:54 -0700
Message-Id: <1274460848-11377-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

device_del and device_rename were modified to use
sysfs_delete_link and sysfs_rename_link respectively to ensure
when these operations happen on devices whose classes
are in namespace directories they work properly.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f069991..17e7d50 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -786,7 +786,7 @@ out_device:
 out_busid:
 	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev))
-		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
+		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj,
 				  dev_name(dev));
 #else
 	/* link in the class directory pointing to the device */
@@ -804,7 +804,7 @@ out_busid:
 	return 0;
 
 out_busid:
-	sysfs_remove_link(&dev->class->p->class_subsys.kobj, dev_name(dev));
+	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
 #endif
 
 out_subsys:
@@ -832,13 +832,13 @@ static void device_remove_class_symlinks(struct device *dev)
 
 	if (dev->kobj.parent != &dev->class->p->class_subsys.kobj &&
 	    device_is_not_partition(dev))
-		sysfs_remove_link(&dev->class->p->class_subsys.kobj,
+		sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj,
 				  dev_name(dev));
 #else
 	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 
-	sysfs_remove_link(&dev->class->p->class_subsys.kobj, dev_name(dev));
+	sysfs_delete_link(&dev->class->p->class_subsys.kobj, &dev->kobj, dev_name(dev));
 #endif
 
 	sysfs_remove_link(&dev->kobj, "subsystem");
@@ -1624,6 +1624,14 @@ int device_rename(struct device *dev, char *new_name)
 		goto out;
 	}
 
+#ifndef CONFIG_SYSFS_DEPRECATED
+	if (dev->class) {
+		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
+			&dev->kobj, old_device_name, new_name);
+		if (error)
+			goto out;
+	}
+#endif
 	error = kobject_rename(&dev->kobj, new_name);
 	if (error)
 		goto out;
@@ -1638,11 +1646,6 @@ int device_rename(struct device *dev, char *new_name)
 						  new_class_name);
 		}
 	}
-#else
-	if (dev->class) {
-		error = sysfs_rename_link(&dev->class->p->class_subsys.kobj,
-					  &dev->kobj, old_device_name, new_name);
-	}
 #endif
 
 out:
-- 
1.7.0.3

