Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab2HHKr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:47:58 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46512 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab2HHKr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:47:56 -0400
Subject: [PATCH] pci: convert "new_id"/"remove_id" into generic pci_bus driver
 attributes
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Wed, 08 Aug 2012 14:47:51 +0400
Message-ID: <20120808104751.28854.76212.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes hardcoded sysfs attributes manipulation and
converts them into generic pci_bus->dev_attrs. This saves several bytes.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 drivers/pci/pci-driver.c |   57 ++++++++--------------------------------------
 1 file changed, 10 insertions(+), 47 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 185be37..4c361e5 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -139,7 +139,6 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
 		return retval;
 	return count;
 }
-static DRIVER_ATTR(new_id, S_IWUSR, NULL, store_new_id);
 
 /**
  * store_remove_id - remove a PCI device ID from this driver
@@ -185,38 +184,16 @@ store_remove_id(struct device_driver *driver, const char *buf, size_t count)
 		return retval;
 	return count;
 }
-static DRIVER_ATTR(remove_id, S_IWUSR, NULL, store_remove_id);
 
-static int
-pci_create_newid_files(struct pci_driver *drv)
-{
-	int error = 0;
+static struct driver_attribute pci_drv_attrs[] = {
+	__ATTR(new_id, S_IWUSR, NULL, store_new_id),
+	__ATTR(remove_id, S_IWUSR, NULL, store_remove_id),
+	__ATTR_NULL,
+};
 
-	if (drv->probe != NULL) {
-		error = driver_create_file(&drv->driver, &driver_attr_new_id);
-		if (error == 0) {
-			error = driver_create_file(&drv->driver,
-					&driver_attr_remove_id);
-			if (error)
-				driver_remove_file(&drv->driver,
-						&driver_attr_new_id);
-		}
-	}
-	return error;
-}
-
-static void pci_remove_newid_files(struct pci_driver *drv)
-{
-	driver_remove_file(&drv->driver, &driver_attr_remove_id);
-	driver_remove_file(&drv->driver, &driver_attr_new_id);
-}
-#else /* !CONFIG_HOTPLUG */
-static inline int pci_create_newid_files(struct pci_driver *drv)
-{
-	return 0;
-}
-static inline void pci_remove_newid_files(struct pci_driver *drv) {}
-#endif
+#else
+#define pci_drv_attrs	NULL
+#endif /* CONFIG_HOTPLUG */
 
 /**
  * pci_match_id - See if a pci device matches a given pci_id table
@@ -1149,8 +1126,6 @@ const struct dev_pm_ops pci_dev_pm_ops = {
 int __pci_register_driver(struct pci_driver *drv, struct module *owner,
 			  const char *mod_name)
 {
-	int error;
-
 	/* initialize common driver fields */
 	drv->driver.name = drv->name;
 	drv->driver.bus = &pci_bus_type;
@@ -1161,19 +1136,7 @@ int __pci_register_driver(struct pci_driver *drv, struct module *owner,
 	INIT_LIST_HEAD(&drv->dynids.list);
 
 	/* register with core */
-	error = driver_register(&drv->driver);
-	if (error)
-		goto out;
-
-	error = pci_create_newid_files(drv);
-	if (error)
-		goto out_newid;
-out:
-	return error;
-
-out_newid:
-	driver_unregister(&drv->driver);
-	goto out;
+	return driver_register(&drv->driver);
 }
 
 /**
@@ -1189,7 +1152,6 @@ out_newid:
 void
 pci_unregister_driver(struct pci_driver *drv)
 {
-	pci_remove_newid_files(drv);
 	driver_unregister(&drv->driver);
 	pci_free_dynids(drv);
 }
@@ -1289,6 +1251,7 @@ struct bus_type pci_bus_type = {
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
 	.bus_attrs	= pci_bus_attrs,
+	.drv_attrs	= pci_drv_attrs,
 	.pm		= PCI_PM_OPS_PTR,
 };
 

