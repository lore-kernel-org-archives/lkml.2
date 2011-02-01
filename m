Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1BAQTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:19:19 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44316 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1BAQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:19:10 -0500
From: Borislav Petkov <bp@amd64.org>
To: <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] sysdev: Do not register with sysdev when erroring on add
Date: Tue,  1 Feb 2011 17:19:56 +0100
Message-Id: <1296577197-9766-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When encountering an error while executing the driver's ->add method, we
should cancel registration and unwind what we've regged so far. The low
level ->add methods do return proper error codes but those aren't looked
at in sysdev_driver_register(). Fix that by sharing the unregistering
code.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

Patch against next-20110201.

 drivers/base/sys.c |   61 +++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 1667aaf..a1eeff0 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -166,6 +166,36 @@ EXPORT_SYMBOL_GPL(sysdev_class_unregister);
 
 static DEFINE_MUTEX(sysdev_drivers_lock);
 
+/*
+ * @dev != NULL means that we're unwinding because some drv->add()
+ * failed for some reason. You need to grab sysdev_drivers_lock before
+ * calling this.
+ */
+static void __sysdev_driver_remove(struct sysdev_class *cls,
+				   struct sysdev_driver *drv,
+				   struct sys_device *from_dev)
+{
+	struct sys_device *dev = from_dev;
+
+	list_del_init(&drv->entry);
+	if (!cls)
+		return;
+
+	if (!drv->remove)
+		goto kset_put;
+
+	if (dev)
+		list_for_each_entry_continue_reverse(dev, &cls->kset.list,
+						     kobj.entry)
+			drv->remove(dev);
+	else
+		list_for_each_entry(dev, &cls->kset.list, kobj.entry)
+			drv->remove(dev);
+
+kset_put:
+	kset_put(&cls->kset);
+}
+
 /**
  *	sysdev_driver_register - Register auxillary driver
  *	@cls:	Device class driver belongs to.
@@ -175,9 +205,9 @@ static DEFINE_MUTEX(sysdev_drivers_lock);
  *	called on each operation on devices of that class. The refcount
  *	of @cls is incremented.
  */
-
 int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 {
+	struct sys_device *dev = NULL;
 	int err = 0;
 
 	if (!cls) {
@@ -198,19 +228,27 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 
 		/* If devices of this class already exist, tell the driver */
 		if (drv->add) {
-			struct sys_device *dev;
-			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
-				drv->add(dev);
+			list_for_each_entry(dev, &cls->kset.list, kobj.entry) {
+				err = drv->add(dev);
+				if (err)
+					goto unwind;
+			}
 		}
 	} else {
 		err = -EINVAL;
 		WARN(1, KERN_ERR "%s: invalid device class\n", __func__);
 	}
+
+	goto unlock;
+
+unwind:
+	__sysdev_driver_remove(cls, drv, dev);
+
+unlock:
 	mutex_unlock(&sysdev_drivers_lock);
 	return err;
 }
 
-
 /**
  *	sysdev_driver_unregister - Remove an auxillary driver.
  *	@cls:	Class driver belongs to.
@@ -220,23 +258,12 @@ void sysdev_driver_unregister(struct sysdev_class *cls,
 			      struct sysdev_driver *drv)
 {
 	mutex_lock(&sysdev_drivers_lock);
-	list_del_init(&drv->entry);
-	if (cls) {
-		if (drv->remove) {
-			struct sys_device *dev;
-			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
-				drv->remove(dev);
-		}
-		kset_put(&cls->kset);
-	}
+	__sysdev_driver_remove(cls, drv, NULL);
 	mutex_unlock(&sysdev_drivers_lock);
 }
-
 EXPORT_SYMBOL_GPL(sysdev_driver_register);
 EXPORT_SYMBOL_GPL(sysdev_driver_unregister);
 
-
-
 /**
  *	sysdev_register - add a system device to the tree
  *	@sysdev:	device in question
-- 
1.7.4.rc2

