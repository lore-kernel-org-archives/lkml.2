Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2KRVLD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 16:11:03 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:51912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab2KRVLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 16:11:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/2] ACPI / platform: Initialize ACPI handles of platform devices in advance
Date: Sun, 18 Nov 2012 22:13:59 +0100
Message-ID: <676649340.5Y2WB7IFNB@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc6; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1758879.PKgPhTGcB7@vostro.rjw.lan>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <20121118155539.GE17774@intel.com> <1758879.PKgPhTGcB7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The current platform device creation and registration code in
acpi_create_platform_device() is quite convoluted.  This function
takes an ACPI device node as an argument and eventually calls
platform_device_register_resndata() to create and register a
platform device object on the basis of the information contained
in that code.  However, it doesn't associate the new platform
device with the ACPI node directly, but instead it relies on
acpi_platform_notify(), called from within device_add(), to find
that ACPI node again with the help of acpi_platform_find_device()
and acpi_platform_match() and then attach the new platform device
to it.  This causes an additional ACPI namespace walk to happen and
is clearly suboptimal.

Use the observation that it is now possible to initialize the ACPI
handle of a device before calling device_add() for it to make this
code more straightforward.  Namely, add a new field to struct
platform_device_info allowing us to pass the ACPI handle of interest
to platform_device_register_full(), which will then use it to
initialize the new device's ACPI handle before registering it.
This will cause acpi_platform_notify() to use the ACPI handle from
the device structure directly instead of using the .find_device()
routine provided by the device's bus type.  In consequence,
acpi_platform_bus, acpi_platform_find_device(), and
acpi_platform_match() are not necessary any more, so remove them.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_platform.c    |   76 +++++-----------------------------------
 drivers/base/platform.c         |    2 +
 include/linux/platform_device.h |    1 
 3 files changed, 13 insertions(+), 66 deletions(-)

Index: linux/include/linux/platform_device.h
===================================================================
--- linux.orig/include/linux/platform_device.h
+++ linux/include/linux/platform_device.h
@@ -55,6 +55,7 @@ extern int platform_add_devices(struct p
 
 struct platform_device_info {
 		struct device *parent;
+		void *acpi_handle;
 
 		const char *name;
 		int id;
Index: linux/drivers/acpi/acpi_platform.c
===================================================================
--- linux.orig/drivers/acpi/acpi_platform.c
+++ linux/drivers/acpi/acpi_platform.c
@@ -33,7 +33,7 @@ struct platform_device *acpi_create_plat
 {
 	struct platform_device *pdev = NULL;
 	struct acpi_device *acpi_parent;
-	struct device *parent = NULL;
+	struct platform_device_info pdevinfo;
 	struct resource_list_entry *rentry;
 	struct list_head resource_list;
 	struct resource *resources;
@@ -60,11 +60,13 @@ struct platform_device *acpi_create_plat
 
 	acpi_dev_free_resource_list(&resource_list);
 
+	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	/*
 	 * If the ACPI node has a parent and that parent has a physical device
 	 * attached to it, that physical device should be the parent of the
 	 * platform device we are about to create.
 	 */
+	pdevinfo.parent = NULL;
 	acpi_parent = adev->parent;
 	if (acpi_parent) {
 		struct acpi_device_physical_node *entry;
@@ -76,12 +78,16 @@ struct platform_device *acpi_create_plat
 			entry = list_first_entry(list,
 					struct acpi_device_physical_node,
 					node);
-			parent = entry->dev;
+			pdevinfo.parent = entry->dev;
 		}
 		mutex_unlock(&acpi_parent->physical_node_lock);
 	}
-	pdev = platform_device_register_resndata(parent, dev_name(&adev->dev),
-						 -1, resources, count, NULL, 0);
+	pdevinfo.name = dev_name(&adev->dev);
+	pdevinfo.id = -1;
+	pdevinfo.res = resources;
+	pdevinfo.num_res = count;
+	pdevinfo.acpi_handle = adev->handle;
+	pdev = platform_device_register_full(&pdevinfo);
 	if (IS_ERR(pdev)) {
 		dev_err(&adev->dev, "platform device creation failed: %ld\n",
 			PTR_ERR(pdev));
@@ -94,65 +100,3 @@ struct platform_device *acpi_create_plat
 	kfree(resources);
 	return pdev;
 }
-
-static acpi_status acpi_platform_match(acpi_handle handle, u32 depth,
-				       void *data, void **return_value)
-{
-	struct platform_device *pdev = data;
-	struct acpi_device *adev;
-	acpi_status status;
-
-	status = acpi_bus_get_device(handle, &adev);
-	if (ACPI_FAILURE(status))
-		return status;
-
-	/* Skip ACPI devices that have physical device attached */
-	if (adev->physical_node_count)
-		return AE_OK;
-
-	if (!strcmp(dev_name(&pdev->dev), dev_name(&adev->dev))) {
-		*(acpi_handle *)return_value = handle;
-		return AE_CTRL_TERMINATE;
-	}
-
-	return AE_OK;
-}
-
-static int acpi_platform_find_device(struct device *dev, acpi_handle *handle)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	char *name, *tmp, *hid;
-
-	/*
-	 * The platform device is named using the ACPI device name
-	 * _HID:INSTANCE so we strip the INSTANCE out in order to find the
-	 * correct device using its _HID.
-	 */
-	name = kstrdup(dev_name(dev), GFP_KERNEL);
-	if (!name)
-		return -ENOMEM;
-
-	tmp = name;
-	hid = strsep(&tmp, ":");
-	if (!hid) {
-		kfree(name);
-		return -ENODEV;
-	}
-
-	*handle = NULL;
-	acpi_get_devices(hid, acpi_platform_match, pdev, handle);
-
-	kfree(name);
-	return *handle ? 0 : -ENODEV;
-}
-
-static struct acpi_bus_type acpi_platform_bus = {
-	.bus = &platform_bus_type,
-	.find_device = acpi_platform_find_device,
-};
-
-static int __init acpi_platform_init(void)
-{
-	return register_acpi_bus_type(&acpi_platform_bus);
-}
-arch_initcall(acpi_platform_init);
Index: linux/drivers/base/platform.c
===================================================================
--- linux.orig/drivers/base/platform.c
+++ linux/drivers/base/platform.c
@@ -437,6 +437,7 @@ struct platform_device *platform_device_
 		goto err_alloc;
 
 	pdev->dev.parent = pdevinfo->parent;
+	pdev->dev.acpi_handle = pdevinfo->acpi_handle;
 
 	if (pdevinfo->dma_mask) {
 		/*
@@ -467,6 +468,7 @@ struct platform_device *platform_device_
 	ret = platform_device_add(pdev);
 	if (ret) {
 err:
+		pdev->dev.acpi_handle = NULL;
 		kfree(pdev->dev.dma_mask);
 
 err_alloc:

