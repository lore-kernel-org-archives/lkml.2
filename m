Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1G1FR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 01:17:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:51315 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab1G1FQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 01:16:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: mingo@elte.hu, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: [PATCH 10/11] include: convert various register fcns to macros to avoid include chaining
Date: Thu, 28 Jul 2011 01:16:17 -0400
Message-Id: <1311830178-30314-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original implementations reference THIS_MODULE in an inline.
We could include <linux/export.h>, but it is better to avoid chaining.

Fortunately someone else already thought of this, and made a similar
inline into a #define in <linux/device.h> for device_schedule_callback(),
[see commit 523ded71de0] so follow that precedent here.

Also bubble up any __must_check that were used on the prev. wrapper inline
functions up one to the real __register functions, to preserve any prev.
sanity checks that were used in those instances.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/bcma/bcma.h   |    7 +++----
 include/linux/device.h      |   12 ++++++++----
 include/linux/gameport.h    |   17 ++++++++---------
 include/linux/hid.h         |    9 +++++----
 include/linux/i2c.h         |    7 +++----
 include/linux/pci_hotplug.h |   10 +++-------
 include/linux/serio.h       |   20 +++++++++++---------
 include/linux/ssb/ssb.h     |    7 +++----
 include/linux/uio_driver.h  |   10 +++++-----
 include/linux/usb.h         |    9 +++++----
 include/linux/uwb/umc.h     |    7 +++----
 11 files changed, 57 insertions(+), 58 deletions(-)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 8c96654..1fb7166 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -165,10 +165,9 @@ struct bcma_driver {
 };
 extern
 int __bcma_driver_register(struct bcma_driver *drv, struct module *owner);
-static inline int bcma_driver_register(struct bcma_driver *drv)
-{
-	return __bcma_driver_register(drv, THIS_MODULE);
-}
+#define bcma_driver_register(drv) \
+	__bcma_driver_register(drv, THIS_MODULE)
+
 extern void bcma_driver_unregister(struct bcma_driver *drv);
 
 struct bcma_bus {
diff --git a/include/linux/device.h b/include/linux/device.h
index c20dfbf..2ee926c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -710,10 +710,14 @@ extern int dev_set_drvdata(struct device *dev, void *data);
  */
 extern struct device *__root_device_register(const char *name,
 					     struct module *owner);
-static inline struct device *root_device_register(const char *name)
-{
-	return __root_device_register(name, THIS_MODULE);
-}
+
+/*
+ * This is a macro to avoid include problems with THIS_MODULE,
+ * just as per what is done for device_schedule_callback() above.
+ */
+#define root_device_register(name) \
+	__root_device_register(name, THIS_MODULE)
+
 extern void root_device_unregister(struct device *root);
 
 static inline void *dev_get_platdata(const struct device *dev)
diff --git a/include/linux/gameport.h b/include/linux/gameport.h
index b65a6f4..e74073e 100644
--- a/include/linux/gameport.h
+++ b/include/linux/gameport.h
@@ -71,10 +71,9 @@ void gameport_close(struct gameport *gameport);
 #if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
 
 void __gameport_register_port(struct gameport *gameport, struct module *owner);
-static inline void gameport_register_port(struct gameport *gameport)
-{
-	__gameport_register_port(gameport, THIS_MODULE);
-}
+/* use a define to avoid include chaining to get THIS_MODULE */
+#define gameport_register_port(gameport) \
+	__gameport_register_port(gameport, THIS_MODULE)
 
 void gameport_unregister_port(struct gameport *gameport);
 
@@ -145,12 +144,12 @@ static inline void gameport_unpin_driver(struct gameport *gameport)
 	mutex_unlock(&gameport->drv_mutex);
 }
 
-int __gameport_register_driver(struct gameport_driver *drv,
+int __must_check __gameport_register_driver(struct gameport_driver *drv,
 				struct module *owner, const char *mod_name);
-static inline int __must_check gameport_register_driver(struct gameport_driver *drv)
-{
-	return __gameport_register_driver(drv, THIS_MODULE, KBUILD_MODNAME);
-}
+
+/* use a define to avoid include chaining to get THIS_MODULE & friends */
+#define gameport_register_driver(drv) \
+	__gameport_register_driver(drv, THIS_MODULE, KBUILD_MODNAME)
 
 void gameport_unregister_driver(struct gameport_driver *drv);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 9cf8e7a..830632d 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -694,10 +694,11 @@ extern void hid_destroy_device(struct hid_device *);
 
 extern int __must_check __hid_register_driver(struct hid_driver *,
 		struct module *, const char *mod_name);
-static inline int __must_check hid_register_driver(struct hid_driver *driver)
-{
-	return __hid_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
-}
+
+/* use a define to avoid include chaining to get THIS_MODULE & friends */
+#define hid_register_driver(driver) \
+	__hid_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
+
 extern void hid_unregister_driver(struct hid_driver *);
 
 extern void hidinput_hid_event(struct hid_device *, struct hid_field *, struct hid_usage *, __s32);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index a6c652e..ce472e3 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -434,10 +434,9 @@ extern int i2c_add_numbered_adapter(struct i2c_adapter *);
 extern int i2c_register_driver(struct module *, struct i2c_driver *);
 extern void i2c_del_driver(struct i2c_driver *);
 
-static inline int i2c_add_driver(struct i2c_driver *driver)
-{
-	return i2c_register_driver(THIS_MODULE, driver);
-}
+/* use a define to avoid include chaining to get THIS_MODULE */
+#define i2c_add_driver(driver) \
+	i2c_register_driver(THIS_MODULE, driver)
 
 extern struct i2c_client *i2c_use_client(struct i2c_client *client);
 extern void i2c_release_client(struct i2c_client *client);
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 5d09cba..45fc162 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -132,13 +132,9 @@ extern int pci_hp_deregister(struct hotplug_slot *slot);
 extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
 						 struct hotplug_slot_info *info);
 
-static inline int pci_hp_register(struct hotplug_slot *slot,
-				  struct pci_bus *pbus,
-				  int devnr, const char *name)
-{
-	return __pci_hp_register(slot, pbus, devnr, name,
-				 THIS_MODULE, KBUILD_MODNAME);
-}
+/* use a define to avoid include chaining to get THIS_MODULE & friends */
+#define pci_hp_register(slot, pbus, devnr, name) \
+	__pci_hp_register(slot, pbus, devnr, name, THIS_MODULE, KBUILD_MODNAME)
 
 /* PCI Setting Record (Type 0) */
 struct hpp_type0 {
diff --git a/include/linux/serio.h b/include/linux/serio.h
index e26f478..c588f38 100644
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -79,19 +79,21 @@ void serio_reconnect(struct serio *serio);
 irqreturn_t serio_interrupt(struct serio *serio, unsigned char data, unsigned int flags);
 
 void __serio_register_port(struct serio *serio, struct module *owner);
-static inline void serio_register_port(struct serio *serio)
-{
-	__serio_register_port(serio, THIS_MODULE);
-}
+
+/* use a define to avoid include chaining to get THIS_MODULE */
+#define serio_register_port(serio) \
+	__serio_register_port(serio, THIS_MODULE)
 
 void serio_unregister_port(struct serio *serio);
 void serio_unregister_child_port(struct serio *serio);
 
-int __serio_register_driver(struct serio_driver *drv, struct module *owner, const char *mod_name);
-static inline int __must_check serio_register_driver(struct serio_driver *drv)
-{
-	return __serio_register_driver(drv, THIS_MODULE, KBUILD_MODNAME);
-}
+int __must_check __serio_register_driver(struct serio_driver *drv,
+				struct module *owner, const char *mod_name);
+
+/* use a define to avoid include chaining to get THIS_MODULE & friends */
+#define serio_register_driver(drv) \
+	__serio_register_driver(drv, THIS_MODULE, KBUILD_MODNAME)
+
 void serio_unregister_driver(struct serio_driver *drv);
 
 static inline int serio_write(struct serio *serio, unsigned char data)
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 8623217..4c5d09a 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -231,10 +231,9 @@ struct ssb_driver {
 #define drv_to_ssb_drv(_drv) container_of(_drv, struct ssb_driver, drv)
 
 extern int __ssb_driver_register(struct ssb_driver *drv, struct module *owner);
-static inline int ssb_driver_register(struct ssb_driver *drv)
-{
-	return __ssb_driver_register(drv, THIS_MODULE);
-}
+#define ssb_driver_register(drv) \
+	__ssb_driver_register(drv, THIS_MODULE)
+
 extern void ssb_driver_unregister(struct ssb_driver *drv);
 
 
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 665517c..04cdc47 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -98,11 +98,11 @@ extern int __must_check
 	__uio_register_device(struct module *owner,
 			      struct device *parent,
 			      struct uio_info *info);
-static inline int __must_check
-	uio_register_device(struct device *parent, struct uio_info *info)
-{
-	return __uio_register_device(THIS_MODULE, parent, info);
-}
+
+/* use a define to avoid include chaining to get THIS_MODULE */
+#define uio_register_device(parent, info) \
+	__uio_register_device(THIS_MODULE, parent, info)
+
 extern void uio_unregister_device(struct uio_info *info);
 extern void uio_event_notify(struct uio_info *info);
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 73c7df4..c454f5a 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -928,10 +928,11 @@ struct usb_class_driver {
  */
 extern int usb_register_driver(struct usb_driver *, struct module *,
 			       const char *);
-static inline int usb_register(struct usb_driver *driver)
-{
-	return usb_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
-}
+
+/* use a define to avoid include chaining to get THIS_MODULE & friends */
+#define usb_register(driver) \
+	usb_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
+
 extern void usb_deregister(struct usb_driver *);
 
 extern int usb_register_device_driver(struct usb_device_driver *,
diff --git a/include/linux/uwb/umc.h b/include/linux/uwb/umc.h
index 7b48420..891d1d5 100644
--- a/include/linux/uwb/umc.h
+++ b/include/linux/uwb/umc.h
@@ -111,10 +111,9 @@ int __must_check __umc_driver_register(struct umc_driver *umc_drv,
  * umc_driver_register - register a UMC capabiltity driver.
  * @umc_drv:  pointer to the driver.
  */
-static inline int __must_check umc_driver_register(struct umc_driver *umc_drv)
-{
-	return __umc_driver_register(umc_drv, THIS_MODULE, KBUILD_MODNAME);
-}
+#define umc_driver_register(umc_drv) \
+	__umc_driver_register(umc_drv, THIS_MODULE, KBUILD_MODNAME)
+
 void umc_driver_unregister(struct umc_driver *umc_drv);
 
 /*
-- 
1.7.6

