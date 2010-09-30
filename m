Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0I3LBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:01:45 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41679 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0I3LA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:00:56 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 6/8] EDAC: Export edac sysfs class to users.
Date: Thu, 30 Sep 2010 13:01:47 +0200
Message-Id: <1285844509-27120-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285844509-27120-1-git-send-email-bp@amd64.org>
References: <1285844509-27120-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move toplevel sysfs class to the stub and make it available to
non-modularized code too. Add proper refcounting of its users and move
the registration functionality into the reference counting routines.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/edac_device_sysfs.c |   16 +++++---
 drivers/edac/edac_mc_sysfs.c     |    9 +++-
 drivers/edac/edac_module.c       |   79 +-------------------------------------
 drivers/edac/edac_module.h       |    1 -
 drivers/edac/edac_pci_sysfs.c    |   10 +++-
 drivers/edac/edac_stub.c         |   51 ++++++++++++++++++++++--
 include/linux/edac.h             |    4 ++
 7 files changed, 75 insertions(+), 95 deletions(-)

diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index 0709681..2941dca 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
@@ -235,7 +236,7 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 	debugf1("%s()\n", __func__);
 
 	/* get the /sys/devices/system/edac reference */
-	edac_class = edac_get_edac_class();
+	edac_class = edac_get_sysfs_class();
 	if (edac_class == NULL) {
 		debugf1("%s() no edac_class error\n", __func__);
 		err = -ENODEV;
@@ -255,7 +256,7 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 
 	if (!try_module_get(edac_dev->owner)) {
 		err = -ENODEV;
-		goto err_out;
+		goto err_mod_get;
 	}
 
 	/* register */
@@ -282,6 +283,9 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 err_kobj_reg:
 	module_put(edac_dev->owner);
 
+err_mod_get:
+	edac_put_sysfs_class();
+
 err_out:
 	return err;
 }
@@ -290,12 +294,11 @@ err_out:
  * edac_device_unregister_sysfs_main_kobj:
  *	the '..../edac/<name>' kobject
  */
-void edac_device_unregister_sysfs_main_kobj(
-					struct edac_device_ctl_info *edac_dev)
+void edac_device_unregister_sysfs_main_kobj(struct edac_device_ctl_info *dev)
 {
 	debugf0("%s()\n", __func__);
 	debugf4("%s() name of kobject is: %s\n",
-		__func__, kobject_name(&edac_dev->kobj));
+		__func__, kobject_name(&dev->kobj));
 
 	/*
 	 * Unregister the edac device's kobject and
@@ -304,7 +307,8 @@ void edac_device_unregister_sysfs_main_kobj(
 	 *   a) module_put() this module
 	 *   b) 'kfree' the memory
 	 */
-	kobject_put(&edac_dev->kobj);
+	kobject_put(&dev->kobj);
+	edac_put_sysfs_class();
 }
 
 /* edac_dev -> instance information */
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index aa93ad8..a413586 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -11,6 +11,7 @@
 
 #include <linux/ctype.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include <linux/bug.h>
 
 #include "edac_core.h"
@@ -1017,7 +1018,7 @@ int edac_sysfs_setup_mc_kset(void)
 	debugf1("%s()\n", __func__);
 
 	/* get the /sys/devices/system/edac class reference */
-	edac_class = edac_get_edac_class();
+	edac_class = edac_get_sysfs_class();
 	if (edac_class == NULL) {
 		debugf1("%s() no edac_class error=%d\n", __func__, err);
 		goto fail_out;
@@ -1028,15 +1029,16 @@ int edac_sysfs_setup_mc_kset(void)
 	if (!mc_kset) {
 		err = -ENOMEM;
 		debugf1("%s() Failed to register '.../edac/mc'\n", __func__);
-		goto fail_out;
+		goto fail_kset;
 	}
 
 	debugf1("%s() Registered '.../edac/mc' kobject\n", __func__);
 
 	return 0;
 
+fail_kset:
+	edac_put_sysfs_class();
 
-	/* error unwind stack */
 fail_out:
 	return err;
 }
@@ -1049,5 +1051,6 @@ fail_out:
 void edac_sysfs_teardown_mc_kset(void)
 {
 	kset_unregister(mc_kset);
+	edac_put_sysfs_class();
 }
 
diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index 7e1374a..be4b075 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -27,15 +27,6 @@ EXPORT_SYMBOL_GPL(edac_debug_level);
 struct workqueue_struct *edac_workqueue;
 
 /*
- * sysfs object: /sys/devices/system/edac
- *	need to export to other files in this modules
- */
-static struct sysdev_class edac_class = {
-	.name = "edac",
-};
-static int edac_class_valid;
-
-/*
  * edac_op_state_to_string()
  */
 char *edac_op_state_to_string(int opstate)
@@ -55,60 +46,6 @@ char *edac_op_state_to_string(int opstate)
 }
 
 /*
- * edac_get_edac_class()
- *
- *	return pointer to the edac class of 'edac'
- */
-struct sysdev_class *edac_get_edac_class(void)
-{
-	struct sysdev_class *classptr = NULL;
-
-	if (edac_class_valid)
-		classptr = &edac_class;
-
-	return classptr;
-}
-
-/*
- * edac_register_sysfs_edac_name()
- *
- *	register the 'edac' into /sys/devices/system
- *
- * return:
- *	0  success
- *	!0 error
- */
-static int edac_register_sysfs_edac_name(void)
-{
-	int err;
-
-	/* create the /sys/devices/system/edac directory */
-	err = sysdev_class_register(&edac_class);
-
-	if (err) {
-		debugf1("%s() error=%d\n", __func__, err);
-		return err;
-	}
-
-	edac_class_valid = 1;
-	return 0;
-}
-
-/*
- * sysdev_class_unregister()
- *
- *	unregister the 'edac' from /sys/devices/system
- */
-static void edac_unregister_sysfs_edac_name(void)
-{
-	/* only if currently registered, then unregister it */
-	if (edac_class_valid)
-		sysdev_class_unregister(&edac_class);
-
-	edac_class_valid = 0;
-}
-
-/*
  * edac_workqueue_setup
  *	initialize the edac work queue for polling operations
  */
@@ -154,21 +91,11 @@ static int __init edac_init(void)
 	edac_pci_clear_parity_errors();
 
 	/*
-	 * perform the registration of the /sys/devices/system/edac class object
-	 */
-	if (edac_register_sysfs_edac_name()) {
-		edac_printk(KERN_ERR, EDAC_MC,
-			"Error initializing 'edac' kobject\n");
-		err = -ENODEV;
-		goto error;
-	}
-
-	/*
 	 * now set up the mc_kset under the edac class object
 	 */
 	err = edac_sysfs_setup_mc_kset();
 	if (err)
-		goto sysfs_setup_fail;
+		goto error;
 
 	/* Setup/Initialize the workq for this core */
 	err = edac_workqueue_setup();
@@ -183,9 +110,6 @@ static int __init edac_init(void)
 workq_fail:
 	edac_sysfs_teardown_mc_kset();
 
-sysfs_setup_fail:
-	edac_unregister_sysfs_edac_name();
-
 error:
 	return err;
 }
@@ -201,7 +125,6 @@ static void __exit edac_exit(void)
 	/* tear down the various subsystems */
 	edac_workqueue_teardown();
 	edac_sysfs_teardown_mc_kset();
-	edac_unregister_sysfs_edac_name();
 }
 
 /*
diff --git a/drivers/edac/edac_module.h b/drivers/edac/edac_module.h
index 233d479..17aabb7 100644
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -42,7 +42,6 @@ extern void edac_device_unregister_sysfs_main_kobj(
 				struct edac_device_ctl_info *edac_dev);
 extern int edac_device_create_sysfs(struct edac_device_ctl_info *edac_dev);
 extern void edac_device_remove_sysfs(struct edac_device_ctl_info *edac_dev);
-extern struct sysdev_class *edac_get_edac_class(void);
 
 /* edac core workqueue: single CPU mode */
 extern struct workqueue_struct *edac_workqueue;
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index c39697d..023b01c 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -7,7 +7,7 @@
  *
  */
 #include <linux/module.h>
-#include <linux/sysdev.h>
+#include <linux/edac.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 
@@ -354,7 +354,7 @@ static int edac_pci_main_kobj_setup(void)
 	/* First time, so create the main kobject and its
 	 * controls and atributes
 	 */
-	edac_class = edac_get_edac_class();
+	edac_class = edac_get_sysfs_class();
 	if (edac_class == NULL) {
 		debugf1("%s() no edac_class\n", __func__);
 		err = -ENODEV;
@@ -368,7 +368,7 @@ static int edac_pci_main_kobj_setup(void)
 	if (!try_module_get(THIS_MODULE)) {
 		debugf1("%s() try_module_get() failed\n", __func__);
 		err = -ENODEV;
-		goto decrement_count_fail;
+		goto mod_get_fail;
 	}
 
 	edac_pci_top_main_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
@@ -403,6 +403,9 @@ kobject_init_and_add_fail:
 kzalloc_fail:
 	module_put(THIS_MODULE);
 
+mod_get_fail:
+	edac_put_sysfs_class();
+
 decrement_count_fail:
 	/* if are on this error exit, nothing to tear down */
 	atomic_dec(&edac_pci_sysfs_refcount);
@@ -429,6 +432,7 @@ static void edac_pci_main_kobj_teardown(void)
 			__func__);
 		kobject_put(edac_pci_top_main_kobj);
 	}
+	edac_put_sysfs_class();
 }
 
 /*
diff --git a/drivers/edac/edac_stub.c b/drivers/edac/edac_stub.c
index 20b428a..aab9707 100644
--- a/drivers/edac/edac_stub.c
+++ b/drivers/edac/edac_stub.c
@@ -3,10 +3,13 @@
  *
  * Author: Dave Jiang <djiang@mvista.com>
  *
- * 2007 (c) MontaVista Software, Inc. This file is licensed under
- * the terms of the GNU General Public License version 2. This program
- * is licensed "as is" without any warranty of any kind, whether express
- * or implied.
+ * 2007 (c) MontaVista Software, Inc.
+ * 2010 (c) Advanced Micro Devices Inc.
+ *	    Borislav Petkov <borislav.petkov@amd.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
  *
  */
 #include <linux/module.h>
@@ -23,6 +26,8 @@ EXPORT_SYMBOL_GPL(edac_handlers);
 int edac_err_assert = 0;
 EXPORT_SYMBOL_GPL(edac_err_assert);
 
+static atomic_t edac_class_valid = ATOMIC_INIT(0);
+
 /*
  * called to determine if there is an EDAC driver interested in
  * knowing an event (such as NMI) occurred
@@ -44,3 +49,41 @@ void edac_atomic_assert_error(void)
 	edac_err_assert++;
 }
 EXPORT_SYMBOL_GPL(edac_atomic_assert_error);
+
+/*
+ * sysfs object: /sys/devices/system/edac
+ *	need to export to other files
+ */
+struct sysdev_class edac_class = {
+	.name = "edac",
+};
+EXPORT_SYMBOL_GPL(edac_class);
+
+/* return pointer to the 'edac' node in sysfs */
+struct sysdev_class *edac_get_sysfs_class(void)
+{
+	int err = 0;
+
+	if (atomic_read(&edac_class_valid))
+		goto out;
+
+	/* create the /sys/devices/system/edac directory */
+	err = sysdev_class_register(&edac_class);
+	if (err) {
+		printk(KERN_ERR "Error registering toplevel EDAC sysfs dir\n");
+		return NULL;
+	}
+
+out:
+	atomic_inc(&edac_class_valid);
+	return &edac_class;
+}
+EXPORT_SYMBOL_GPL(edac_get_sysfs_class);
+
+void edac_put_sysfs_class(void)
+{
+	/* last user unregisters it */
+	if (atomic_dec_and_test(&edac_class_valid))
+		sysdev_class_unregister(&edac_class);
+}
+EXPORT_SYMBOL_GPL(edac_put_sysfs_class);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 7cf92e8..36c6644 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -13,6 +13,7 @@
 #define _LINUX_EDAC_H_
 
 #include <asm/atomic.h>
+#include <linux/sysdev.h>
 
 #define EDAC_OPSTATE_INVAL	-1
 #define EDAC_OPSTATE_POLL	0
@@ -22,9 +23,12 @@
 extern int edac_op_state;
 extern int edac_err_assert;
 extern atomic_t edac_handlers;
+extern struct sysdev_class edac_class;
 
 extern int edac_handler_set(void);
 extern void edac_atomic_assert_error(void);
+extern struct sysdev_class *edac_get_sysfs_class(void);
+extern void edac_put_sysfs_class(void);
 
 static inline void opstate_init(void)
 {
-- 
1.7.1

