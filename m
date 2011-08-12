Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1HLKeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 06:34:21 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:25699 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1HLKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 06:34:17 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <gregkh@suse.de>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 3/5] staging: vme: add functions for bridge module refcounting
Date: Fri, 12 Aug 2011 12:30:49 +0200
Message-ID: <1313145051-13397-4-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch>
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

The functions are automatically called during .probe and .remove
for drivers.

This patch is based on the changes introduced by Emilio G. Cota
in the patch:

    https://lkml.org/lkml/2010/10/25/492

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    2 +
 drivers/staging/vme/bridges/vme_tsi148.c   |    2 +
 drivers/staging/vme/vme.c                  |   54 ++++++++++++++++++++++++++-
 drivers/staging/vme/vme.h                  |    1 -
 drivers/staging/vme/vme_bridge.h           |    1 +
 5 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 0e4feac..b80cb12 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -1673,6 +1673,8 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ca91cx42_bridge->parent = &pdev->dev;
 	strcpy(ca91cx42_bridge->name, driver_name);
 
+	ca91cx42_bridge->owner = THIS_MODULE;
+
 	/* Setup IRQ */
 	retval = ca91cx42_irq_init(ca91cx42_bridge);
 	if (retval != 0) {
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 6c1167c..b0b434a 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2312,6 +2312,8 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	tsi148_bridge->parent = &pdev->dev;
 	strcpy(tsi148_bridge->name, driver_name);
 
+	tsi148_bridge->owner = THIS_MODULE;
+
 	/* Setup IRQ */
 	retval = tsi148_irq_init(tsi148_bridge);
 	if (retval != 0) {
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index feb2d00..664eae0 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -52,6 +52,48 @@ static struct vme_bridge *dev_to_bridge(struct device *dev)
 }
 
 /*
+ * Increments the reference count of a VME bridge.
+ *
+ * On success, it can be assumed that the bridge won't be removed until
+ * the corresponding call to vme_put_bridge(). This along with
+ * vme_bridge_put are automatically called and VME device drivers need
+ * not worry about using this.
+ */
+int vme_bridge_get(unsigned int bus_id)
+{
+	int ret = -1;
+	struct vme_bridge *bridge;
+
+	mutex_lock(&vme_buses_lock);
+	list_for_each_entry(bridge, &vme_bus_list, bus_list) {
+		if (bridge->num == bus_id) {
+			if (!bridge->owner)
+				dev_warn(bridge->parent,
+					"bridge->owner not set\n");
+			else if (try_module_get(bridge->owner))
+				ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&vme_buses_lock);
+	return ret;
+}
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
+
+/*
  * Find the bridge that the resource is associated with.
  */
 static struct vme_bridge *find_bridge(struct vme_resource *resource)
@@ -1496,14 +1538,20 @@ static int vme_bus_probe(struct device *dev)
 {
 	struct vme_bridge *bridge;
 	struct vme_driver *driver;
-	int retval = -ENODEV;
+	int retval = 0;
 
 	driver = dev_to_vme_driver(dev);
 	bridge = dev_to_bridge(dev);
 
+	if (vme_bridge_get(bridge->num))
+		return -ENXIO;
+
 	if (driver->probe != NULL)
 		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
 
+	if (driver->probe && retval)
+		vme_bridge_put(bridge);
+
 	return retval;
 }
 
@@ -1511,7 +1559,7 @@ static int vme_bus_remove(struct device *dev)
 {
 	struct vme_bridge *bridge;
 	struct vme_driver *driver;
-	int retval = -ENODEV;
+	int retval = 0;
 
 	driver = dev_to_vme_driver(dev);
 	bridge = dev_to_bridge(dev);
@@ -1519,6 +1567,8 @@ static int vme_bus_remove(struct device *dev)
 	if (driver->remove != NULL)
 		retval = driver->remove(dev, bridge->num, vme_calc_slot(dev));
 
+	vme_bridge_put(bridge);
+
 	return retval;
 }
 
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 4155d8c..eb00a5e 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -165,6 +165,5 @@ int vme_slot_get(struct device *);
 int vme_register_driver(struct vme_driver *);
 void vme_unregister_driver(struct vme_driver *);
 
-
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

