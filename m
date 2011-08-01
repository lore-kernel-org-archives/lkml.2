Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1HAKaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:30:14 -0400
Received: from cernmx31.cern.ch ([137.138.144.179]:18500 "EHLO
	CERNMX31.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1HAK3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:29:37 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 5/8] staging: vme: add functions for bridge module refcounting
Date: Mon, 1 Aug 2011 12:20:50 +0200
Message-ID: <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functions that allow for reference counting
bridge modules. The patch introduces the functions
'vme_bridge_get()' and 'vme_bridge_put()'.

This patch is based on the changes introduced by Emilio G. Cota
in the patch:

    https://lkml.org/lkml/2010/10/25/492

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    2 +
 drivers/staging/vme/bridges/vme_tsi148.c   |    2 +
 drivers/staging/vme/devices/vme_user.c     |   20 +++++++++++
 drivers/staging/vme/vme.c                  |   48 ++++++++++++++++++++++++++++
 drivers/staging/vme/vme.h                  |    2 +
 drivers/staging/vme/vme_bridge.h           |    1 +
 6 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 15a0b19..2f9c22b 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -1680,6 +1680,8 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ca91cx42_bridge->parent = &pdev->dev;
 	strcpy(ca91cx42_bridge->name, driver_name);
 
+	ca91cx42_bridge->owner = THIS_MODULE;
+
 	/* Setup IRQ */
 	retval = ca91cx42_irq_init(ca91cx42_bridge);
 	if (retval != 0) {
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 5c147d6..9db89dc 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2320,6 +2320,8 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	tsi148_bridge->parent = &pdev->dev;
 	strcpy(tsi148_bridge->name, driver_name);
 
+	tsi148_bridge->owner = THIS_MODULE;
+
 	/* Setup IRQ */
 	retval = tsi148_irq_init(tsi148_bridge);
 	if (retval != 0) {
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 3cbeb2a..7ed4a5c 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -118,6 +118,8 @@ static struct cdev *vme_user_cdev;		/* Character device */
 static struct class *vme_user_sysfs_class;	/* Sysfs class */
 static struct device *vme_user_bridge;		/* Pointer to bridge device */
 
+static struct vme_bridge *vme_user_bus;		/* Pointer to bridge */
+
 
 static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
 					MASTER_MINOR,	MASTER_MINOR,
@@ -824,10 +826,25 @@ static int __devinit vme_user_probe(struct device *dev, int cur_bus,
 		}
 	}
 
+	/*
+	 * Increment reference count of bridge module. We don't want things
+	 * to fall over in case the bridge module is removed while the vme_user
+	 * driver is still loaded.
+	 */
+	vme_user_bus = vme_bridge_get(cur_bus);
+	if (!vme_user_bus) {
+		printk(KERN_ERR "%s: vme_bridge_get failed\n", driver_name);
+		err = -EINVAL;
+		goto err_bridge_get;
+	}
+
 	return 0;
 
 	/* Ensure counter set correcty to destroy all sysfs devices */
 	i = VME_DEVS;
+err_bridge_get:
+	for (i = 0; i < VME_DEVS; i++)
+		device_destroy(vme_user_sysfs_class, MKDEV(VME_MAJOR, i));
 err_sysfs:
 	while (i > 0) {
 		i--;
@@ -892,6 +909,9 @@ static int __devexit vme_user_remove(struct device *dev, int cur_bus,
 	/* Unregiser the major and minor device numbers */
 	unregister_chrdev_region(MKDEV(VME_MAJOR, 0), VME_DEVS);
 
+	/* decrement bridge module reference */
+	vme_bridge_put(vme_user_bus);
+
 	return 0;
 }
 
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 11e28ca..759ec2b 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -52,6 +52,54 @@ static struct vme_bridge *dev_to_bridge(struct device *dev)
 }
 
 /*
+ * Increments the reference count of a VME bridge.
+ *
+ * If found, a pointer to the bridge is returned and the reference count
+ * of the module that owns it is incremented.
+ *
+ * On success, it can be assumed that the bridge won't be removed until
+ * the corresponding call to vme_put_bridge().
+ *
+ * Normally drivers should call vme_get_bridge() on a successfull .probe,
+ * and vme_put_bridge() when releasing the device, e.g. in .remove.
+ */
+struct vme_bridge *vme_bridge_get(unsigned int bus_id)
+{
+	struct vme_bridge *bridge;
+	struct vme_bridge *retp = NULL;
+
+	mutex_lock(&vme_buses_lock);
+	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
+		if (bridge->num == bus_id) {
+			if (!bridge->owner)
+				dev_warn(bridge->parent,
+					"bridge->owner not set\n");
+			else if (try_module_get(bridge->owner))
+				retp = bridge;
+			break;
+		}
+	}
+	mutex_unlock(&vme_buses_lock);
+	return retp;
+}
+EXPORT_SYMBOL(vme_bridge_get);
+
+/*
+ * Decrements the reference count of a bridge
+ *
+ * This function decrements the reference count of the module that controls
+ * the bridge. It must come after a call to vme_get_bridge().
+ */
+void vme_bridge_put(struct vme_bridge *bridge)
+{
+	if (!bridge->owner)
+		dev_warn(bridge->parent, "bridge->owner not set\n");
+	else
+		module_put(bridge->owner);
+}
+EXPORT_SYMBOL(vme_bridge_put);
+
+/*
  * Find the bridge that the resource is associated with.
  */
 static struct vme_bridge *find_bridge(struct vme_resource *resource)
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 3ccb497..8fb35e2 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -167,6 +167,8 @@ int vme_slot_get(struct device *);
 int vme_register_driver(struct vme_driver *);
 void vme_unregister_driver(struct vme_driver *);
 
+struct vme_bridge *vme_bridge_get(unsigned int bus_id);
+void vme_bridge_put(struct vme_bridge *bridge);
 
 #endif /* _VME_H_ */
 
diff --git a/drivers/staging/vme/vme_bridge.h b/drivers/staging/vme/vme_bridge.h
index 8959670..ef751a4 100644
--- a/drivers/staging/vme/vme_bridge.h
+++ b/drivers/staging/vme/vme_bridge.h
@@ -113,6 +113,7 @@ struct vme_bridge {
 	struct device *parent;	/* Parent device (eg. pdev->dev for PCI) */
 	void *driver_priv;	/* Private pointer for the bridge driver */
 	struct list_head bus_list; /* list of VME buses */
+	struct module *owner;	/* module that owns the bridge */
 
 	struct device dev[VME_SLOTS_MAX];	/* Device registered with
 						 * device model on VME bus
-- 
1.7.4.1

