Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2KLL7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:59:14 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:38652 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab2KLL7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:59:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node objects
Date: Mon, 12 Nov 2012 13:02:11 +0100
Message-ID: <11281928.0BBlrNprhI@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc5; KDE/4.8.5; x86_64; ; )
In-Reply-To: <2429141.J1r7BIpiiT@vostro.rjw.lan>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <2429141.J1r7BIpiiT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, whoever wants to use ACPI device resources has to call
acpi_walk_resources() to browse the buffer returned by the _CRS
method for the given device and create filters passed to that
routine to apply to the individual resource items.  This generally
is cumbersome, time-consuming and inefficient.  Moreover, it may
be problematic if resource conflicts need to be resolved, because
the different users of _CRS will need to do that in a consistent
way.

For this reason, add code to the ACPI core to execute _CRS once,
when the struct acpi_device object is created for a given device
node, and attach a list of ACPI resources returned by _CRS to that
object for future processing.

Convert the ACPI code that creates platform device objects to using
the new resources list instead of executing acpi_walk_resources() by
itself, which makes it much more straightforward and easier to
follow.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_platform.c |   90 ++++++++++++-------------------------------
 drivers/acpi/resource.c      |   12 +++++
 drivers/acpi/scan.c          |   56 ++++++++++++++++++++++++++
 include/acpi/acpi_bus.h      |    6 ++
 include/linux/acpi.h         |    1 
 5 files changed, 102 insertions(+), 63 deletions(-)

Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -259,6 +259,11 @@ struct acpi_device_physical_node {
 	struct device *dev;
 };
 
+struct acpi_resource_list_entry {
+	struct list_head node;
+	struct acpi_resource resource;
+};
+
 /* set maximum of physical nodes to 32 for expansibility */
 #define ACPI_MAX_PHYSICAL_NODE	32
 
@@ -268,6 +273,7 @@ struct acpi_device {
 	acpi_handle handle;		/* no handle for fixed hardware */
 	struct acpi_device *parent;
 	struct list_head children;
+	struct list_head resources;	/* Device resources. */
 	struct list_head node;
 	struct list_head wakeup_list;
 	struct acpi_device_status status;
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -382,6 +382,52 @@ static void acpi_device_remove_files(str
 			ACPI Bus operations
    -------------------------------------------------------------------------- */
 
+static void acpi_bus_drop_resources(struct acpi_device *adev)
+{
+	struct acpi_resource_list_entry *entry, *s;
+
+	list_for_each_entry_safe(entry, s, &adev->resources, node) {
+		list_del(&entry->node);
+		kfree(entry);
+	}
+}
+
+static acpi_status acpi_bus_add_resource(struct acpi_resource *res,
+					 void *context)
+{
+	struct list_head *list = context;
+	struct acpi_resource_list_entry *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return AE_NO_MEMORY;
+
+	entry->resource = *res;
+	INIT_LIST_HEAD(&entry->node);
+	list_add_tail(&entry->node, list);
+	return AE_OK;
+}
+
+static int acpi_bus_get_resources(struct acpi_device *adev)
+{
+	acpi_status status;
+	acpi_handle not_used;
+	int ret = 0;
+
+	status = acpi_get_handle(adev->handle, METHOD_NAME__CRS, &not_used);
+	if (ACPI_FAILURE(status))
+		return 0;
+
+	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
+				     acpi_bus_add_resource, &adev->resources);
+	if (ACPI_FAILURE(status)) {
+		acpi_bus_drop_resources(adev);
+		ret = status == AE_NO_MEMORY ? -ENOMEM : -EIO;
+	}
+
+	return ret;
+}
+
 static const struct acpi_device_id *__acpi_match_device(
 	struct acpi_device *device, const struct acpi_device_id *ids)
 {
@@ -681,6 +727,7 @@ static void acpi_device_unregister(struc
 
 	acpi_device_remove_files(device);
 	device_unregister(&device->dev);
+	acpi_bus_drop_resources(device);
 }
 
 /* --------------------------------------------------------------------------
@@ -1412,6 +1459,15 @@ static int acpi_add_single_object(struct
 	acpi_device_set_id(device);
 
 	/*
+	 * Device Resources
+	 * ----------------
+	 */
+	INIT_LIST_HEAD(&device->resources);
+	result = acpi_bus_get_resources(device);
+	if (result)
+		goto end;
+
+	/*
 	 * Power Management
 	 * ----------------
 	 */
Index: linux/drivers/acpi/resource.c
===================================================================
--- linux.orig/drivers/acpi/resource.c
+++ linux/drivers/acpi/resource.c
@@ -391,3 +391,15 @@ bool acpi_dev_resource_interrupt(struct
 	return true;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
+
+unsigned int acpi_dev_resource_count(struct acpi_resource *ares)
+{
+	switch (ares->type) {
+	case ACPI_RESOURCE_TYPE_IRQ:
+		return ares->data.irq.interrupt_count;
+	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
+		return ares->data.extended_irq.interrupt_count;
+	}
+	return 1;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_resource_count);
Index: linux/drivers/acpi/acpi_platform.c
===================================================================
--- linux.orig/drivers/acpi/acpi_platform.c
+++ linux/drivers/acpi/acpi_platform.c
@@ -19,59 +19,26 @@
 
 ACPI_MODULE_NAME("platform");
 
-struct resource_info {
-	struct device *dev;
-	struct resource *res;
-	size_t n, cur;
-};
-
-static acpi_status acpi_platform_count_resources(struct acpi_resource *res,
-						 void *data)
+static unsigned int acpi_platform_add_resource(struct acpi_resource *res,
+					       struct resource *r)
 {
-	struct acpi_resource_extended_irq *acpi_xirq;
-	struct acpi_resource_irq *acpi_irq;
-	struct resource_info *ri = data;
-
-	switch (res->type) {
-	case ACPI_RESOURCE_TYPE_IRQ:
-		acpi_irq = &res->data.irq;
-		ri->n += acpi_irq->interrupt_count;
-		break;
-	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
-		acpi_xirq = &res->data.extended_irq;
-		ri->n += acpi_xirq->interrupt_count;
-		break;
-	default:
-		ri->n++;
-	}
-
-	return AE_OK;
-}
-
-static acpi_status acpi_platform_add_resources(struct acpi_resource *res,
-					       void *data)
-{
-	struct resource_info *ri = data;
-	struct resource *r;
-
-	r = ri->res + ri->cur;
 	if (acpi_dev_resource_memory(res, r)
 	    || acpi_dev_resource_io(res, r)
 	    || acpi_dev_resource_address_space(res, r)
-	    || acpi_dev_resource_ext_address_space(res, r)) {
-		ri->cur++;
-		return AE_OK;
-	}
+	    || acpi_dev_resource_ext_address_space(res, r))
+		return 1;
+
 	if (acpi_dev_resource_interrupt(res, 0, r)) {
-		int i;
+		unsigned int i;
 
 		r++;
 		for (i = 1; acpi_dev_resource_interrupt(res, i, r); i++)
 			r++;
 
-		ri->cur += i;
+		return i;
 	}
-	return AE_OK;
+
+	return 0;
 }
 
 /**
@@ -89,35 +56,32 @@ struct platform_device *acpi_create_plat
 	struct platform_device *pdev = NULL;
 	struct acpi_device *acpi_parent;
 	struct device *parent = NULL;
-	struct resource_info ri;
-	acpi_status status;
+	struct acpi_resource_list_entry *entry;
+	struct resource *resources;
+	unsigned int count;
 
 	/* If the ACPI node already has a physical device attached, skip it. */
 	if (adev->physical_node_count)
 		return NULL;
 
-	memset(&ri, 0, sizeof(ri));
-	/* First, count the resources. */
-	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
-				     acpi_platform_count_resources, &ri);
-	if (ACPI_FAILURE(status) || !ri.n)
+	count = 0;
+	list_for_each_entry(entry, &adev->resources, node)
+		count += acpi_dev_resource_count(&entry->resource);
+
+	if (!count)
 		return NULL;
 
 	/* Next, allocate memory for all the resources and populate it. */
-	ri.dev = &adev->dev;
-	ri.res = kzalloc(ri.n * sizeof(struct resource), GFP_KERNEL);
-	if (!ri.res) {
-		dev_err(&adev->dev,
-			"failed to allocate memory for resources\n");
+	resources = kzalloc(count * sizeof(struct resource), GFP_KERNEL);
+	if (!resources) {
+		dev_err(&adev->dev, "No memory for resources\n");
 		return NULL;
 	}
 
-	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
-				     acpi_platform_add_resources, &ri);
-	if (ACPI_FAILURE(status)) {
-		dev_err(&adev->dev, "failed to walk resources\n");
-		goto out;
-	}
+	count = 0;
+	list_for_each_entry(entry, &adev->resources, node)
+		count += acpi_platform_add_resource(&entry->resource,
+						    resources + count);
 
 	/*
 	 * If the ACPI node has a parent and that parent has a physical device
@@ -139,8 +103,9 @@ struct platform_device *acpi_create_plat
 		}
 		mutex_unlock(&acpi_parent->physical_node_lock);
 	}
+
 	pdev = platform_device_register_resndata(parent, dev_name(&adev->dev),
-						 -1, ri.res, ri.cur, NULL, 0);
+						 -1, resources, count, NULL, 0);
 	if (IS_ERR(pdev)) {
 		dev_err(&adev->dev, "platform device creation failed: %ld\n",
 			PTR_ERR(pdev));
@@ -150,8 +115,7 @@ struct platform_device *acpi_create_plat
 			dev_name(&pdev->dev));
 	}
 
- out:
-	kfree(ri.res);
+	kfree(resources);
 	return pdev;
 }
 
Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -260,6 +260,7 @@ bool acpi_dev_resource_ext_address_space
 unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
 bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 				 struct resource *res);
+unsigned int acpi_dev_resource_count(struct acpi_resource *ares);
 
 int acpi_check_resource_conflict(const struct resource *res);
 

