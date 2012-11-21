Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2KULpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:45:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:8883 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab2KULpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:45:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208,223";a="170957336"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "lenb@kernel.org" <lenb@kernel.org>
Subject: [PATCH V1 1/2] Xen acpi memory hotplug driver
Thread-Topic: [PATCH V1 1/2] Xen acpi memory hotplug driver
Thread-Index: Ac3H3aWVSU3ZacIzTZWfqqryq2EEHA==
Date: Wed, 21 Nov 2012 11:45:04 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923353942F9@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923353942F9SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923353942F9SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 630c65690c878255ce71e7c1172338ed08709273 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Tue, 20 Nov 2012 21:14:37 +0800
Subject: [PATCH 1/2] Xen acpi memory hotplug driver

Xen acpi memory hotplug consists of 2 logic components:
Xen acpi memory hotplug driver and Xen hypercall.

This patch implement Xen acpi memory hotplug driver. When running
under xen platform, Xen driver will early occupy (so native driver
will be blocked). When acpi memory notify OSPM, xen driver will take
effect, adding related memory device and parsing memory information.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/Kconfig               |   11 +
 drivers/xen/Makefile              |    1 +
 drivers/xen/xen-acpi-memhotplug.c |  383 +++++++++++++++++++++++++++++++++=
++++
 3 files changed, 395 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen-acpi-memhotplug.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 126d8ce..abd0396 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -206,4 +206,15 @@ config XEN_MCE_LOG
 	  Allow kernel fetching MCE error from Xen platform and
 	  converting it into Linux mcelog format for mcelog tools
=20
+config XEN_ACPI_MEMORY_HOTPLUG
+	bool "Xen ACPI memory hotplug"
+	depends on XEN_DOM0 && X86_64 && ACPI
+	default n
+	help
+	  This is Xen acpi memory hotplug.
+
+	  Currently Xen only support acpi memory hot-add. If you want
+	  to hot-add memory at runtime (the hot-added memory cannot be
+	  removed until machine stop), select Y here, otherwise select N.
+
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 7435470..c339eb4 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_XEN_MCE_LOG)		+=3D mcelog.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+=3D xen-acpi-processor.o
+obj-$(CONFIG_XEN_ACPI_MEMORY_HOTPLUG)	+=3D xen-acpi-memhotplug.o
 xen-evtchn-y				:=3D evtchn.o
 xen-gntdev-y				:=3D gntdev.o
 xen-gntalloc-y				:=3D gntalloc.o
diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
new file mode 100644
index 0000000..f0c7990
--- /dev/null
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -0,0 +1,383 @@
+/*
+ * Copyright (C) 2012 Intel Corporation
+ *    Author: Liu Jinsong <jinsong.liu@intel.com>
+ *    Author: Jiang Yunhong <yunhong.jiang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <acpi/acpi_drivers.h>
+
+#define ACPI_MEMORY_DEVICE_CLASS		"memory"
+#define ACPI_MEMORY_DEVICE_HID			"PNP0C80"
+#define ACPI_MEMORY_DEVICE_NAME			"Hotplug Mem Device"
+
+#undef PREFIX
+#define PREFIX "ACPI:memory_hp:"
+
+static int acpi_memory_device_add(struct acpi_device *device);
+static int acpi_memory_device_remove(struct acpi_device *device, int type)=
;
+
+static const struct acpi_device_id memory_device_ids[] =3D {
+	{ACPI_MEMORY_DEVICE_HID, 0},
+	{"", 0},
+};
+
+static struct acpi_driver acpi_memory_device_driver =3D {
+	.name =3D "acpi_memhotplug",
+	.class =3D ACPI_MEMORY_DEVICE_CLASS,
+	.ids =3D memory_device_ids,
+	.ops =3D {
+		.add =3D acpi_memory_device_add,
+		.remove =3D acpi_memory_device_remove,
+		},
+};
+
+struct acpi_memory_info {
+	struct list_head list;
+	u64 start_addr;		/* Memory Range start physical addr */
+	u64 length;		/* Memory Range length */
+	unsigned short caching;	/* memory cache attribute */
+	unsigned short write_protect;	/* memory read/write attribute */
+	unsigned int enabled:1;
+};
+
+struct acpi_memory_device {
+	struct acpi_device *device;
+	struct list_head res_list;
+};
+
+static int acpi_hotmem_initialized;
+
+
+int xen_acpi_memory_enable_device(struct acpi_memory_device *mem_device)
+{
+	return 0;
+}
+
+static acpi_status
+acpi_memory_get_resource(struct acpi_resource *resource, void *context)
+{
+	struct acpi_memory_device *mem_device =3D context;
+	struct acpi_resource_address64 address64;
+	struct acpi_memory_info *info, *new;
+	acpi_status status;
+
+	status =3D acpi_resource_to_address64(resource, &address64);
+	if (ACPI_FAILURE(status) ||
+	    (address64.resource_type !=3D ACPI_MEMORY_RANGE))
+		return AE_OK;
+
+	list_for_each_entry(info, &mem_device->res_list, list) {
+		/* Can we combine the resource range information? */
+		if ((info->caching =3D=3D address64.info.mem.caching) &&
+		    (info->write_protect =3D=3D address64.info.mem.write_protect) &&
+		    (info->start_addr + info->length =3D=3D address64.minimum)) {
+			info->length +=3D address64.address_length;
+			return AE_OK;
+		}
+	}
+
+	new =3D kzalloc(sizeof(struct acpi_memory_info), GFP_KERNEL);
+	if (!new)
+		return AE_ERROR;
+
+	INIT_LIST_HEAD(&new->list);
+	new->caching =3D address64.info.mem.caching;
+	new->write_protect =3D address64.info.mem.write_protect;
+	new->start_addr =3D address64.minimum;
+	new->length =3D address64.address_length;
+	list_add_tail(&new->list, &mem_device->res_list);
+
+	return AE_OK;
+}
+
+static int
+acpi_memory_get_device_resources(struct acpi_memory_device *mem_device)
+{
+	acpi_status status;
+	struct acpi_memory_info *info, *n;
+
+	if (!list_empty(&mem_device->res_list))
+		return 0;
+
+	status =3D acpi_walk_resources(mem_device->device->handle,
+		METHOD_NAME__CRS, acpi_memory_get_resource, mem_device);
+
+	if (ACPI_FAILURE(status)) {
+		list_for_each_entry_safe(info, n, &mem_device->res_list, list)
+			kfree(info);
+		INIT_LIST_HEAD(&mem_device->res_list);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+acpi_memory_get_device(acpi_handle handle,
+		       struct acpi_memory_device **mem_device)
+{
+	acpi_status status;
+	acpi_handle phandle;
+	struct acpi_device *device =3D NULL;
+	struct acpi_device *pdevice =3D NULL;
+	int result;
+
+	if (!acpi_bus_get_device(handle, &device) && device)
+		goto end;
+
+	status =3D acpi_get_parent(handle, &phandle);
+	if (ACPI_FAILURE(status)) {
+		pr_warn(PREFIX "Cannot find acpi parent\n");
+		return -EINVAL;
+	}
+
+	/* Get the parent device */
+	result =3D acpi_bus_get_device(phandle, &pdevice);
+	if (result) {
+		pr_warn(PREFIX "Cannot get acpi bus device\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Now add the notified device.  This creates the acpi_device
+	 * and invokes .add function
+	 */
+	result =3D acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
+	if (result) {
+		pr_warn(PREFIX "Cannot add acpi bus\n");
+		return -EINVAL;
+	}
+
+end:
+	*mem_device =3D acpi_driver_data(device);
+	if (!(*mem_device)) {
+		pr_err(PREFIX "Driver data not found\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int acpi_memory_check_device(struct acpi_memory_device *mem_device)
+{
+	unsigned long long current_status;
+
+	/* Get device present/absent information from the _STA */
+	if (ACPI_FAILURE(acpi_evaluate_integer(mem_device->device->handle,
+				"_STA", NULL, &current_status)))
+		return -ENODEV;
+	/*
+	 * Check for device status. Device should be
+	 * present/enabled/functioning.
+	 */
+	if (!((current_status & ACPI_STA_DEVICE_PRESENT)
+	      && (current_status & ACPI_STA_DEVICE_ENABLED)
+	      && (current_status & ACPI_STA_DEVICE_FUNCTIONING)))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int acpi_memory_disable_device(struct acpi_memory_device *mem_devic=
e)
+{
+	pr_warn(PREFIX "Xen does not support memory hotremove\n");
+
+	return -ENOSYS;
+}
+
+static void acpi_memory_device_notify(acpi_handle handle, u32 event, void =
*data)
+{
+	struct acpi_memory_device *mem_device;
+	struct acpi_device *device;
+	u32 ost_code =3D ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
+
+	switch (event) {
+	case ACPI_NOTIFY_BUS_CHECK:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			"\nReceived BUS CHECK notification for device\n"));
+		/* Fall Through */
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		if (event =3D=3D ACPI_NOTIFY_DEVICE_CHECK)
+			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			"\nReceived DEVICE CHECK notification for device\n"));
+
+		if (acpi_memory_get_device(handle, &mem_device)) {
+			pr_err(PREFIX "Cannot find driver data\n");
+			break;
+		}
+
+		ost_code =3D ACPI_OST_SC_SUCCESS;
+		break;
+
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+			"\nReceived EJECT REQUEST notification for device\n"));
+
+		if (acpi_bus_get_device(handle, &device)) {
+			pr_err(PREFIX "Device doesn't exist\n");
+			break;
+		}
+		mem_device =3D acpi_driver_data(device);
+		if (!mem_device) {
+			pr_err(PREFIX "Driver Data is NULL\n");
+			break;
+		}
+
+		/*
+		 * TBD: implement acpi_memory_disable_device and invoke
+		 * acpi_bus_remove if Xen support hotremove in the future
+		 */
+		acpi_memory_disable_device(mem_device);
+		break;
+
+	default:
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				  "Unsupported event [0x%x]\n", event));
+		/* non-hotplug event; possibly handled by other handler */
+		return;
+	}
+
+	/* Inform firmware that the hotplug operation has completed */
+	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
+	return;
+}
+
+static int acpi_memory_device_add(struct acpi_device *device)
+{
+	int result;
+	struct acpi_memory_device *mem_device =3D NULL;
+
+
+	if (!device)
+		return -EINVAL;
+
+	mem_device =3D kzalloc(sizeof(struct acpi_memory_device), GFP_KERNEL);
+	if (!mem_device)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&mem_device->res_list);
+	mem_device->device =3D device;
+	sprintf(acpi_device_name(device), "%s", ACPI_MEMORY_DEVICE_NAME);
+	sprintf(acpi_device_class(device), "%s", ACPI_MEMORY_DEVICE_CLASS);
+	device->driver_data =3D mem_device;
+
+	/* Get the range from the _CRS */
+	result =3D acpi_memory_get_device_resources(mem_device);
+	if (result) {
+		kfree(mem_device);
+		return result;
+	}
+
+	/*
+	 * Early boot code has recognized memory area by EFI/E820.
+	 * If DSDT shows these memory devices on boot, hotplug is not necessary
+	 * for them. So, it just returns until completion of this driver's
+	 * start up.
+	 */
+	if (!acpi_hotmem_initialized)
+		return 0;
+
+	if (!acpi_memory_check_device(mem_device))
+		result =3D xen_acpi_memory_enable_device(mem_device);
+
+	return result;
+}
+
+static int acpi_memory_device_remove(struct acpi_device *device, int type)
+{
+	struct acpi_memory_device *mem_device =3D NULL;
+
+	if (!device || !acpi_driver_data(device))
+		return -EINVAL;
+
+	mem_device =3D acpi_driver_data(device);
+	kfree(mem_device);
+
+	return 0;
+}
+
+/*
+ * Helper function to check for memory device
+ */
+static acpi_status is_memory_device(acpi_handle handle)
+{
+	char *hardware_id;
+	acpi_status status;
+	struct acpi_device_info *info;
+
+	status =3D acpi_get_object_info(handle, &info);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	if (!(info->valid & ACPI_VALID_HID)) {
+		kfree(info);
+		return AE_ERROR;
+	}
+
+	hardware_id =3D info->hardware_id.string;
+	if ((hardware_id =3D=3D NULL) ||
+	    (strcmp(hardware_id, ACPI_MEMORY_DEVICE_HID)))
+		status =3D AE_ERROR;
+
+	kfree(info);
+	return status;
+}
+
+static acpi_status
+acpi_memory_register_notify_handler(acpi_handle handle,
+				    u32 level, void *ctxt, void **retv)
+{
+	acpi_status status;
+
+	status =3D is_memory_device(handle);
+	if (ACPI_FAILURE(status))
+		return AE_OK;	/* continue */
+
+	status =3D acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					     acpi_memory_device_notify, NULL);
+	/* continue */
+	return AE_OK;
+}
+
+static int __init xen_acpi_memory_device_init(void)
+{
+	int result;
+	acpi_status status;
+
+	/* only dom0 is responsible for xen acpi memory hotplug */
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	result =3D acpi_bus_register_driver(&acpi_memory_device_driver);
+	if (result < 0)
+		return -ENODEV;
+
+	status =3D acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+				     ACPI_UINT32_MAX,
+				     acpi_memory_register_notify_handler, NULL,
+				     NULL, NULL);
+
+	if (ACPI_FAILURE(status)) {
+		pr_warn(PREFIX "walk_namespace failed\n");
+		acpi_bus_unregister_driver(&acpi_memory_device_driver);
+		return -ENODEV;
+	}
+
+	acpi_hotmem_initialized =3D 1;
+	return 0;
+}
+subsys_initcall(xen_acpi_memory_device_init);
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923353942F9SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-acpi-memory-hotplug-driver.patch"
Content-Description: 0001-Xen-acpi-memory-hotplug-driver.patch
Content-Disposition: attachment;
	filename="0001-Xen-acpi-memory-hotplug-driver.patch"; size=12522;
	creation-date="Wed, 21 Nov 2012 11:38:00 GMT";
	modification-date="Wed, 21 Nov 2012 11:20:46 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2MzBjNjU2OTBjODc4MjU1Y2U3MWU3YzExNzIzMzhlZDA4NzA5MjczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUdWUsIDIwIE5vdiAyMDEyIDIxOjE0OjM3ICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IFhlbiBhY3BpIG1lbW9yeSBob3RwbHVnIGRyaXZlcgoKWGVuIGFjcGkgbWVtb3J5IGhvdHBsdWcg
Y29uc2lzdHMgb2YgMiBsb2dpYyBjb21wb25lbnRzOgpYZW4gYWNwaSBtZW1vcnkgaG90cGx1ZyBk
cml2ZXIgYW5kIFhlbiBoeXBlcmNhbGwuCgpUaGlzIHBhdGNoIGltcGxlbWVudCBYZW4gYWNwaSBt
ZW1vcnkgaG90cGx1ZyBkcml2ZXIuIFdoZW4gcnVubmluZwp1bmRlciB4ZW4gcGxhdGZvcm0sIFhl
biBkcml2ZXIgd2lsbCBlYXJseSBvY2N1cHkgKHNvIG5hdGl2ZSBkcml2ZXIKd2lsbCBiZSBibG9j
a2VkKS4gV2hlbiBhY3BpIG1lbW9yeSBub3RpZnkgT1NQTSwgeGVuIGRyaXZlciB3aWxsIHRha2UK
ZWZmZWN0LCBhZGRpbmcgcmVsYXRlZCBtZW1vcnkgZGV2aWNlIGFuZCBwYXJzaW5nIG1lbW9yeSBp
bmZvcm1hdGlvbi4KClNpZ25lZC1vZmYtYnk6IExpdSBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRl
bC5jb20+Ci0tLQogZHJpdmVycy94ZW4vS2NvbmZpZyAgICAgICAgICAgICAgIHwgICAxMSArCiBk
cml2ZXJzL3hlbi9NYWtlZmlsZSAgICAgICAgICAgICAgfCAgICAxICsKIGRyaXZlcnMveGVuL3hl
bi1hY3BpLW1lbWhvdHBsdWcuYyB8ICAzODMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKwogMyBmaWxlcyBjaGFuZ2VkLCAzOTUgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMo
LSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3hlbi94ZW4tYWNwaS1tZW1ob3RwbHVnLmMK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9LY29uZmlnIGIvZHJpdmVycy94ZW4vS2NvbmZpZwpp
bmRleCAxMjZkOGNlLi5hYmQwMzk2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9LY29uZmlnCisr
KyBiL2RyaXZlcnMveGVuL0tjb25maWcKQEAgLTIwNiw0ICsyMDYsMTUgQEAgY29uZmlnIFhFTl9N
Q0VfTE9HCiAJICBBbGxvdyBrZXJuZWwgZmV0Y2hpbmcgTUNFIGVycm9yIGZyb20gWGVuIHBsYXRm
b3JtIGFuZAogCSAgY29udmVydGluZyBpdCBpbnRvIExpbnV4IG1jZWxvZyBmb3JtYXQgZm9yIG1j
ZWxvZyB0b29scwogCitjb25maWcgWEVOX0FDUElfTUVNT1JZX0hPVFBMVUcKKwlib29sICJYZW4g
QUNQSSBtZW1vcnkgaG90cGx1ZyIKKwlkZXBlbmRzIG9uIFhFTl9ET00wICYmIFg4Nl82NCAmJiBB
Q1BJCisJZGVmYXVsdCBuCisJaGVscAorCSAgVGhpcyBpcyBYZW4gYWNwaSBtZW1vcnkgaG90cGx1
Zy4KKworCSAgQ3VycmVudGx5IFhlbiBvbmx5IHN1cHBvcnQgYWNwaSBtZW1vcnkgaG90LWFkZC4g
SWYgeW91IHdhbnQKKwkgIHRvIGhvdC1hZGQgbWVtb3J5IGF0IHJ1bnRpbWUgKHRoZSBob3QtYWRk
ZWQgbWVtb3J5IGNhbm5vdCBiZQorCSAgcmVtb3ZlZCB1bnRpbCBtYWNoaW5lIHN0b3ApLCBzZWxl
Y3QgWSBoZXJlLCBvdGhlcndpc2Ugc2VsZWN0IE4uCisKIGVuZG1lbnUKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMveGVuL01ha2VmaWxlIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKaW5kZXggNzQzNTQ3MC4u
YzMzOWViNCAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94
ZW4vTWFrZWZpbGUKQEAgLTMwLDYgKzMwLDcgQEAgb2JqLSQoQ09ORklHX1hFTl9NQ0VfTE9HKQkJ
Kz0gbWNlbG9nLm8KIG9iai0kKENPTkZJR19YRU5fUENJREVWX0JBQ0tFTkQpCSs9IHhlbi1wY2li
YWNrLwogb2JqLSQoQ09ORklHX1hFTl9QUklWQ01EKQkJKz0geGVuLXByaXZjbWQubwogb2JqLSQo
Q09ORklHX1hFTl9BQ1BJX1BST0NFU1NPUikJKz0geGVuLWFjcGktcHJvY2Vzc29yLm8KK29iai0k
KENPTkZJR19YRU5fQUNQSV9NRU1PUllfSE9UUExVRykJKz0geGVuLWFjcGktbWVtaG90cGx1Zy5v
CiB4ZW4tZXZ0Y2huLXkJCQkJOj0gZXZ0Y2huLm8KIHhlbi1nbnRkZXYteQkJCQk6PSBnbnRkZXYu
bwogeGVuLWdudGFsbG9jLXkJCQkJOj0gZ250YWxsb2MubwpkaWZmIC0tZ2l0IGEvZHJpdmVycy94
ZW4veGVuLWFjcGktbWVtaG90cGx1Zy5jIGIvZHJpdmVycy94ZW4veGVuLWFjcGktbWVtaG90cGx1
Zy5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmYwYzc5OTAKLS0tIC9kZXYv
bnVsbAorKysgYi9kcml2ZXJzL3hlbi94ZW4tYWNwaS1tZW1ob3RwbHVnLmMKQEAgLTAsMCArMSwz
ODMgQEAKKy8qCisgKiBDb3B5cmlnaHQgKEMpIDIwMTIgSW50ZWwgQ29ycG9yYXRpb24KKyAqICAg
IEF1dGhvcjogTGl1IEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KKyAqICAgIEF1dGhv
cjogSmlhbmcgWXVuaG9uZyA8eXVuaG9uZy5qaWFuZ0BpbnRlbC5jb20+CisgKgorICogVGhpcyBw
cm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBt
b2RpZnkKKyAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExp
Y2Vuc2UgYXMgcHVibGlzaGVkIGJ5CisgKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBl
aXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQKKyAqIHlvdXIgb3B0aW9uKSBh
bnkgbGF0ZXIgdmVyc2lvbi4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4g
dGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwgYnV0CisgKiBXSVRIT1VUIEFOWSBXQVJS
QU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mCisgKiBNRVJDSEFOVEFC
SUxJVFkgT1IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UsIEdPT0QgVElUTEUgb3IK
KyAqIE5PTiBJTkZSSU5HRU1FTlQuICBTZWUgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
IGZvciBtb3JlCisgKiBkZXRhaWxzLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4K
KyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNs
dWRlIDxhY3BpL2FjcGlfZHJpdmVycy5oPgorCisjZGVmaW5lIEFDUElfTUVNT1JZX0RFVklDRV9D
TEFTUwkJIm1lbW9yeSIKKyNkZWZpbmUgQUNQSV9NRU1PUllfREVWSUNFX0hJRAkJCSJQTlAwQzgw
IgorI2RlZmluZSBBQ1BJX01FTU9SWV9ERVZJQ0VfTkFNRQkJCSJIb3RwbHVnIE1lbSBEZXZpY2Ui
CisKKyN1bmRlZiBQUkVGSVgKKyNkZWZpbmUgUFJFRklYICJBQ1BJOm1lbW9yeV9ocDoiCisKK3N0
YXRpYyBpbnQgYWNwaV9tZW1vcnlfZGV2aWNlX2FkZChzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmlj
ZSk7CitzdGF0aWMgaW50IGFjcGlfbWVtb3J5X2RldmljZV9yZW1vdmUoc3RydWN0IGFjcGlfZGV2
aWNlICpkZXZpY2UsIGludCB0eXBlKTsKKworc3RhdGljIGNvbnN0IHN0cnVjdCBhY3BpX2Rldmlj
ZV9pZCBtZW1vcnlfZGV2aWNlX2lkc1tdID0geworCXtBQ1BJX01FTU9SWV9ERVZJQ0VfSElELCAw
fSwKKwl7IiIsIDB9LAorfTsKKworc3RhdGljIHN0cnVjdCBhY3BpX2RyaXZlciBhY3BpX21lbW9y
eV9kZXZpY2VfZHJpdmVyID0geworCS5uYW1lID0gImFjcGlfbWVtaG90cGx1ZyIsCisJLmNsYXNz
ID0gQUNQSV9NRU1PUllfREVWSUNFX0NMQVNTLAorCS5pZHMgPSBtZW1vcnlfZGV2aWNlX2lkcywK
Kwkub3BzID0geworCQkuYWRkID0gYWNwaV9tZW1vcnlfZGV2aWNlX2FkZCwKKwkJLnJlbW92ZSA9
IGFjcGlfbWVtb3J5X2RldmljZV9yZW1vdmUsCisJCX0sCit9OworCitzdHJ1Y3QgYWNwaV9tZW1v
cnlfaW5mbyB7CisJc3RydWN0IGxpc3RfaGVhZCBsaXN0OworCXU2NCBzdGFydF9hZGRyOwkJLyog
TWVtb3J5IFJhbmdlIHN0YXJ0IHBoeXNpY2FsIGFkZHIgKi8KKwl1NjQgbGVuZ3RoOwkJLyogTWVt
b3J5IFJhbmdlIGxlbmd0aCAqLworCXVuc2lnbmVkIHNob3J0IGNhY2hpbmc7CS8qIG1lbW9yeSBj
YWNoZSBhdHRyaWJ1dGUgKi8KKwl1bnNpZ25lZCBzaG9ydCB3cml0ZV9wcm90ZWN0OwkvKiBtZW1v
cnkgcmVhZC93cml0ZSBhdHRyaWJ1dGUgKi8KKwl1bnNpZ25lZCBpbnQgZW5hYmxlZDoxOworfTsK
Kworc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSB7CisJc3RydWN0IGFjcGlfZGV2aWNlICpkZXZp
Y2U7CisJc3RydWN0IGxpc3RfaGVhZCByZXNfbGlzdDsKK307CisKK3N0YXRpYyBpbnQgYWNwaV9o
b3RtZW1faW5pdGlhbGl6ZWQ7CisKKworaW50IHhlbl9hY3BpX21lbW9yeV9lbmFibGVfZGV2aWNl
KHN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UpCit7CisJcmV0dXJuIDA7Cit9
CisKK3N0YXRpYyBhY3BpX3N0YXR1cworYWNwaV9tZW1vcnlfZ2V0X3Jlc291cmNlKHN0cnVjdCBh
Y3BpX3Jlc291cmNlICpyZXNvdXJjZSwgdm9pZCAqY29udGV4dCkKK3sKKwlzdHJ1Y3QgYWNwaV9t
ZW1vcnlfZGV2aWNlICptZW1fZGV2aWNlID0gY29udGV4dDsKKwlzdHJ1Y3QgYWNwaV9yZXNvdXJj
ZV9hZGRyZXNzNjQgYWRkcmVzczY0OworCXN0cnVjdCBhY3BpX21lbW9yeV9pbmZvICppbmZvLCAq
bmV3OworCWFjcGlfc3RhdHVzIHN0YXR1czsKKworCXN0YXR1cyA9IGFjcGlfcmVzb3VyY2VfdG9f
YWRkcmVzczY0KHJlc291cmNlLCAmYWRkcmVzczY0KTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1
cykgfHwKKwkgICAgKGFkZHJlc3M2NC5yZXNvdXJjZV90eXBlICE9IEFDUElfTUVNT1JZX1JBTkdF
KSkKKwkJcmV0dXJuIEFFX09LOworCisJbGlzdF9mb3JfZWFjaF9lbnRyeShpbmZvLCAmbWVtX2Rl
dmljZS0+cmVzX2xpc3QsIGxpc3QpIHsKKwkJLyogQ2FuIHdlIGNvbWJpbmUgdGhlIHJlc291cmNl
IHJhbmdlIGluZm9ybWF0aW9uPyAqLworCQlpZiAoKGluZm8tPmNhY2hpbmcgPT0gYWRkcmVzczY0
LmluZm8ubWVtLmNhY2hpbmcpICYmCisJCSAgICAoaW5mby0+d3JpdGVfcHJvdGVjdCA9PSBhZGRy
ZXNzNjQuaW5mby5tZW0ud3JpdGVfcHJvdGVjdCkgJiYKKwkJICAgIChpbmZvLT5zdGFydF9hZGRy
ICsgaW5mby0+bGVuZ3RoID09IGFkZHJlc3M2NC5taW5pbXVtKSkgeworCQkJaW5mby0+bGVuZ3Ro
ICs9IGFkZHJlc3M2NC5hZGRyZXNzX2xlbmd0aDsKKwkJCXJldHVybiBBRV9PSzsKKwkJfQorCX0K
KworCW5ldyA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBhY3BpX21lbW9yeV9pbmZvKSwgR0ZQX0tF
Uk5FTCk7CisJaWYgKCFuZXcpCisJCXJldHVybiBBRV9FUlJPUjsKKworCUlOSVRfTElTVF9IRUFE
KCZuZXctPmxpc3QpOworCW5ldy0+Y2FjaGluZyA9IGFkZHJlc3M2NC5pbmZvLm1lbS5jYWNoaW5n
OworCW5ldy0+d3JpdGVfcHJvdGVjdCA9IGFkZHJlc3M2NC5pbmZvLm1lbS53cml0ZV9wcm90ZWN0
OworCW5ldy0+c3RhcnRfYWRkciA9IGFkZHJlc3M2NC5taW5pbXVtOworCW5ldy0+bGVuZ3RoID0g
YWRkcmVzczY0LmFkZHJlc3NfbGVuZ3RoOworCWxpc3RfYWRkX3RhaWwoJm5ldy0+bGlzdCwgJm1l
bV9kZXZpY2UtPnJlc19saXN0KTsKKworCXJldHVybiBBRV9PSzsKK30KKworc3RhdGljIGludAor
YWNwaV9tZW1vcnlfZ2V0X2RldmljZV9yZXNvdXJjZXMoc3RydWN0IGFjcGlfbWVtb3J5X2Rldmlj
ZSAqbWVtX2RldmljZSkKK3sKKwlhY3BpX3N0YXR1cyBzdGF0dXM7CisJc3RydWN0IGFjcGlfbWVt
b3J5X2luZm8gKmluZm8sICpuOworCisJaWYgKCFsaXN0X2VtcHR5KCZtZW1fZGV2aWNlLT5yZXNf
bGlzdCkpCisJCXJldHVybiAwOworCisJc3RhdHVzID0gYWNwaV93YWxrX3Jlc291cmNlcyhtZW1f
ZGV2aWNlLT5kZXZpY2UtPmhhbmRsZSwKKwkJTUVUSE9EX05BTUVfX0NSUywgYWNwaV9tZW1vcnlf
Z2V0X3Jlc291cmNlLCBtZW1fZGV2aWNlKTsKKworCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkg
eworCQlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoaW5mbywgbiwgJm1lbV9kZXZpY2UtPnJlc19s
aXN0LCBsaXN0KQorCQkJa2ZyZWUoaW5mbyk7CisJCUlOSVRfTElTVF9IRUFEKCZtZW1fZGV2aWNl
LT5yZXNfbGlzdCk7CisJCXJldHVybiAtRUlOVkFMOworCX0KKworCXJldHVybiAwOworfQorCitz
dGF0aWMgaW50CithY3BpX21lbW9yeV9nZXRfZGV2aWNlKGFjcGlfaGFuZGxlIGhhbmRsZSwKKwkJ
ICAgICAgIHN0cnVjdCBhY3BpX21lbW9yeV9kZXZpY2UgKiptZW1fZGV2aWNlKQoreworCWFjcGlf
c3RhdHVzIHN0YXR1czsKKwlhY3BpX2hhbmRsZSBwaGFuZGxlOworCXN0cnVjdCBhY3BpX2Rldmlj
ZSAqZGV2aWNlID0gTlVMTDsKKwlzdHJ1Y3QgYWNwaV9kZXZpY2UgKnBkZXZpY2UgPSBOVUxMOwor
CWludCByZXN1bHQ7CisKKwlpZiAoIWFjcGlfYnVzX2dldF9kZXZpY2UoaGFuZGxlLCAmZGV2aWNl
KSAmJiBkZXZpY2UpCisJCWdvdG8gZW5kOworCisJc3RhdHVzID0gYWNwaV9nZXRfcGFyZW50KGhh
bmRsZSwgJnBoYW5kbGUpOworCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkgeworCQlwcl93YXJu
KFBSRUZJWCAiQ2Fubm90IGZpbmQgYWNwaSBwYXJlbnRcbiIpOworCQlyZXR1cm4gLUVJTlZBTDsK
Kwl9CisKKwkvKiBHZXQgdGhlIHBhcmVudCBkZXZpY2UgKi8KKwlyZXN1bHQgPSBhY3BpX2J1c19n
ZXRfZGV2aWNlKHBoYW5kbGUsICZwZGV2aWNlKTsKKwlpZiAocmVzdWx0KSB7CisJCXByX3dhcm4o
UFJFRklYICJDYW5ub3QgZ2V0IGFjcGkgYnVzIGRldmljZVxuIik7CisJCXJldHVybiAtRUlOVkFM
OworCX0KKworCS8qCisJICogTm93IGFkZCB0aGUgbm90aWZpZWQgZGV2aWNlLiAgVGhpcyBjcmVh
dGVzIHRoZSBhY3BpX2RldmljZQorCSAqIGFuZCBpbnZva2VzIC5hZGQgZnVuY3Rpb24KKwkgKi8K
KwlyZXN1bHQgPSBhY3BpX2J1c19hZGQoJmRldmljZSwgcGRldmljZSwgaGFuZGxlLCBBQ1BJX0JV
U19UWVBFX0RFVklDRSk7CisJaWYgKHJlc3VsdCkgeworCQlwcl93YXJuKFBSRUZJWCAiQ2Fubm90
IGFkZCBhY3BpIGJ1c1xuIik7CisJCXJldHVybiAtRUlOVkFMOworCX0KKworZW5kOgorCSptZW1f
ZGV2aWNlID0gYWNwaV9kcml2ZXJfZGF0YShkZXZpY2UpOworCWlmICghKCptZW1fZGV2aWNlKSkg
eworCQlwcl9lcnIoUFJFRklYICJEcml2ZXIgZGF0YSBub3QgZm91bmRcbiIpOworCQlyZXR1cm4g
LUVOT0RFVjsKKwl9CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBhY3BpX21lbW9yeV9j
aGVja19kZXZpY2Uoc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSAqbWVtX2RldmljZSkKK3sKKwl1
bnNpZ25lZCBsb25nIGxvbmcgY3VycmVudF9zdGF0dXM7CisKKwkvKiBHZXQgZGV2aWNlIHByZXNl
bnQvYWJzZW50IGluZm9ybWF0aW9uIGZyb20gdGhlIF9TVEEgKi8KKwlpZiAoQUNQSV9GQUlMVVJF
KGFjcGlfZXZhbHVhdGVfaW50ZWdlcihtZW1fZGV2aWNlLT5kZXZpY2UtPmhhbmRsZSwKKwkJCQki
X1NUQSIsIE5VTEwsICZjdXJyZW50X3N0YXR1cykpKQorCQlyZXR1cm4gLUVOT0RFVjsKKwkvKgor
CSAqIENoZWNrIGZvciBkZXZpY2Ugc3RhdHVzLiBEZXZpY2Ugc2hvdWxkIGJlCisJICogcHJlc2Vu
dC9lbmFibGVkL2Z1bmN0aW9uaW5nLgorCSAqLworCWlmICghKChjdXJyZW50X3N0YXR1cyAmIEFD
UElfU1RBX0RFVklDRV9QUkVTRU5UKQorCSAgICAgICYmIChjdXJyZW50X3N0YXR1cyAmIEFDUElf
U1RBX0RFVklDRV9FTkFCTEVEKQorCSAgICAgICYmIChjdXJyZW50X3N0YXR1cyAmIEFDUElfU1RB
X0RFVklDRV9GVU5DVElPTklORykpKQorCQlyZXR1cm4gLUVOT0RFVjsKKworCXJldHVybiAwOwor
fQorCitzdGF0aWMgaW50IGFjcGlfbWVtb3J5X2Rpc2FibGVfZGV2aWNlKHN0cnVjdCBhY3BpX21l
bW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UpCit7CisJcHJfd2FybihQUkVGSVggIlhlbiBkb2VzIG5v
dCBzdXBwb3J0IG1lbW9yeSBob3RyZW1vdmVcbiIpOworCisJcmV0dXJuIC1FTk9TWVM7Cit9CisK
K3N0YXRpYyB2b2lkIGFjcGlfbWVtb3J5X2RldmljZV9ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxl
LCB1MzIgZXZlbnQsIHZvaWQgKmRhdGEpCit7CisJc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSAq
bWVtX2RldmljZTsKKwlzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZTsKKwl1MzIgb3N0X2NvZGUg
PSBBQ1BJX09TVF9TQ19OT05fU1BFQ0lGSUNfRkFJTFVSRTsgLyogZGVmYXVsdCAqLworCisJc3dp
dGNoIChldmVudCkgeworCWNhc2UgQUNQSV9OT1RJRllfQlVTX0NIRUNLOgorCQlBQ1BJX0RFQlVH
X1BSSU5UKChBQ1BJX0RCX0lORk8sCisJCQkiXG5SZWNlaXZlZCBCVVMgQ0hFQ0sgbm90aWZpY2F0
aW9uIGZvciBkZXZpY2VcbiIpKTsKKwkJLyogRmFsbCBUaHJvdWdoICovCisJY2FzZSBBQ1BJX05P
VElGWV9ERVZJQ0VfQ0hFQ0s6CisJCWlmIChldmVudCA9PSBBQ1BJX05PVElGWV9ERVZJQ0VfQ0hF
Q0spCisJCQlBQ1BJX0RFQlVHX1BSSU5UKChBQ1BJX0RCX0lORk8sCisJCQkiXG5SZWNlaXZlZCBE
RVZJQ0UgQ0hFQ0sgbm90aWZpY2F0aW9uIGZvciBkZXZpY2VcbiIpKTsKKworCQlpZiAoYWNwaV9t
ZW1vcnlfZ2V0X2RldmljZShoYW5kbGUsICZtZW1fZGV2aWNlKSkgeworCQkJcHJfZXJyKFBSRUZJ
WCAiQ2Fubm90IGZpbmQgZHJpdmVyIGRhdGFcbiIpOworCQkJYnJlYWs7CisJCX0KKworCQlvc3Rf
Y29kZSA9IEFDUElfT1NUX1NDX1NVQ0NFU1M7CisJCWJyZWFrOworCisJY2FzZSBBQ1BJX05PVElG
WV9FSkVDVF9SRVFVRVNUOgorCQlBQ1BJX0RFQlVHX1BSSU5UKChBQ1BJX0RCX0lORk8sCisJCQki
XG5SZWNlaXZlZCBFSkVDVCBSRVFVRVNUIG5vdGlmaWNhdGlvbiBmb3IgZGV2aWNlXG4iKSk7CisK
KwkJaWYgKGFjcGlfYnVzX2dldF9kZXZpY2UoaGFuZGxlLCAmZGV2aWNlKSkgeworCQkJcHJfZXJy
KFBSRUZJWCAiRGV2aWNlIGRvZXNuJ3QgZXhpc3RcbiIpOworCQkJYnJlYWs7CisJCX0KKwkJbWVt
X2RldmljZSA9IGFjcGlfZHJpdmVyX2RhdGEoZGV2aWNlKTsKKwkJaWYgKCFtZW1fZGV2aWNlKSB7
CisJCQlwcl9lcnIoUFJFRklYICJEcml2ZXIgRGF0YSBpcyBOVUxMXG4iKTsKKwkJCWJyZWFrOwor
CQl9CisKKwkJLyoKKwkJICogVEJEOiBpbXBsZW1lbnQgYWNwaV9tZW1vcnlfZGlzYWJsZV9kZXZp
Y2UgYW5kIGludm9rZQorCQkgKiBhY3BpX2J1c19yZW1vdmUgaWYgWGVuIHN1cHBvcnQgaG90cmVt
b3ZlIGluIHRoZSBmdXR1cmUKKwkJICovCisJCWFjcGlfbWVtb3J5X2Rpc2FibGVfZGV2aWNlKG1l
bV9kZXZpY2UpOworCQlicmVhazsKKworCWRlZmF1bHQ6CisJCUFDUElfREVCVUdfUFJJTlQoKEFD
UElfREJfSU5GTywKKwkJCQkgICJVbnN1cHBvcnRlZCBldmVudCBbMHgleF1cbiIsIGV2ZW50KSk7
CisJCS8qIG5vbi1ob3RwbHVnIGV2ZW50OyBwb3NzaWJseSBoYW5kbGVkIGJ5IG90aGVyIGhhbmRs
ZXIgKi8KKwkJcmV0dXJuOworCX0KKworCS8qIEluZm9ybSBmaXJtd2FyZSB0aGF0IHRoZSBob3Rw
bHVnIG9wZXJhdGlvbiBoYXMgY29tcGxldGVkICovCisJKHZvaWQpIGFjcGlfZXZhbHVhdGVfaG90
cGx1Z19vc3QoaGFuZGxlLCBldmVudCwgb3N0X2NvZGUsIE5VTEwpOworCXJldHVybjsKK30KKwor
c3RhdGljIGludCBhY3BpX21lbW9yeV9kZXZpY2VfYWRkKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2
aWNlKQoreworCWludCByZXN1bHQ7CisJc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSAqbWVtX2Rl
dmljZSA9IE5VTEw7CisKKworCWlmICghZGV2aWNlKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCW1l
bV9kZXZpY2UgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgYWNwaV9tZW1vcnlfZGV2aWNlKSwgR0ZQ
X0tFUk5FTCk7CisJaWYgKCFtZW1fZGV2aWNlKQorCQlyZXR1cm4gLUVOT01FTTsKKworCUlOSVRf
TElTVF9IRUFEKCZtZW1fZGV2aWNlLT5yZXNfbGlzdCk7CisJbWVtX2RldmljZS0+ZGV2aWNlID0g
ZGV2aWNlOworCXNwcmludGYoYWNwaV9kZXZpY2VfbmFtZShkZXZpY2UpLCAiJXMiLCBBQ1BJX01F
TU9SWV9ERVZJQ0VfTkFNRSk7CisJc3ByaW50ZihhY3BpX2RldmljZV9jbGFzcyhkZXZpY2UpLCAi
JXMiLCBBQ1BJX01FTU9SWV9ERVZJQ0VfQ0xBU1MpOworCWRldmljZS0+ZHJpdmVyX2RhdGEgPSBt
ZW1fZGV2aWNlOworCisJLyogR2V0IHRoZSByYW5nZSBmcm9tIHRoZSBfQ1JTICovCisJcmVzdWx0
ID0gYWNwaV9tZW1vcnlfZ2V0X2RldmljZV9yZXNvdXJjZXMobWVtX2RldmljZSk7CisJaWYgKHJl
c3VsdCkgeworCQlrZnJlZShtZW1fZGV2aWNlKTsKKwkJcmV0dXJuIHJlc3VsdDsKKwl9CisKKwkv
KgorCSAqIEVhcmx5IGJvb3QgY29kZSBoYXMgcmVjb2duaXplZCBtZW1vcnkgYXJlYSBieSBFRkkv
RTgyMC4KKwkgKiBJZiBEU0RUIHNob3dzIHRoZXNlIG1lbW9yeSBkZXZpY2VzIG9uIGJvb3QsIGhv
dHBsdWcgaXMgbm90IG5lY2Vzc2FyeQorCSAqIGZvciB0aGVtLiBTbywgaXQganVzdCByZXR1cm5z
IHVudGlsIGNvbXBsZXRpb24gb2YgdGhpcyBkcml2ZXIncworCSAqIHN0YXJ0IHVwLgorCSAqLwor
CWlmICghYWNwaV9ob3RtZW1faW5pdGlhbGl6ZWQpCisJCXJldHVybiAwOworCisJaWYgKCFhY3Bp
X21lbW9yeV9jaGVja19kZXZpY2UobWVtX2RldmljZSkpCisJCXJlc3VsdCA9IHhlbl9hY3BpX21l
bW9yeV9lbmFibGVfZGV2aWNlKG1lbV9kZXZpY2UpOworCisJcmV0dXJuIHJlc3VsdDsKK30KKwor
c3RhdGljIGludCBhY3BpX21lbW9yeV9kZXZpY2VfcmVtb3ZlKHN0cnVjdCBhY3BpX2RldmljZSAq
ZGV2aWNlLCBpbnQgdHlwZSkKK3sKKwlzdHJ1Y3QgYWNwaV9tZW1vcnlfZGV2aWNlICptZW1fZGV2
aWNlID0gTlVMTDsKKworCWlmICghZGV2aWNlIHx8ICFhY3BpX2RyaXZlcl9kYXRhKGRldmljZSkp
CisJCXJldHVybiAtRUlOVkFMOworCisJbWVtX2RldmljZSA9IGFjcGlfZHJpdmVyX2RhdGEoZGV2
aWNlKTsKKwlrZnJlZShtZW1fZGV2aWNlKTsKKworCXJldHVybiAwOworfQorCisvKgorICogSGVs
cGVyIGZ1bmN0aW9uIHRvIGNoZWNrIGZvciBtZW1vcnkgZGV2aWNlCisgKi8KK3N0YXRpYyBhY3Bp
X3N0YXR1cyBpc19tZW1vcnlfZGV2aWNlKGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwljaGFyICpo
YXJkd2FyZV9pZDsKKwlhY3BpX3N0YXR1cyBzdGF0dXM7CisJc3RydWN0IGFjcGlfZGV2aWNlX2lu
Zm8gKmluZm87CisKKwlzdGF0dXMgPSBhY3BpX2dldF9vYmplY3RfaW5mbyhoYW5kbGUsICZpbmZv
KTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpCisJCXJldHVybiBzdGF0dXM7CisKKwlpZiAo
IShpbmZvLT52YWxpZCAmIEFDUElfVkFMSURfSElEKSkgeworCQlrZnJlZShpbmZvKTsKKwkJcmV0
dXJuIEFFX0VSUk9SOworCX0KKworCWhhcmR3YXJlX2lkID0gaW5mby0+aGFyZHdhcmVfaWQuc3Ry
aW5nOworCWlmICgoaGFyZHdhcmVfaWQgPT0gTlVMTCkgfHwKKwkgICAgKHN0cmNtcChoYXJkd2Fy
ZV9pZCwgQUNQSV9NRU1PUllfREVWSUNFX0hJRCkpKQorCQlzdGF0dXMgPSBBRV9FUlJPUjsKKwor
CWtmcmVlKGluZm8pOworCXJldHVybiBzdGF0dXM7Cit9CisKK3N0YXRpYyBhY3BpX3N0YXR1cwor
YWNwaV9tZW1vcnlfcmVnaXN0ZXJfbm90aWZ5X2hhbmRsZXIoYWNwaV9oYW5kbGUgaGFuZGxlLAor
CQkJCSAgICB1MzIgbGV2ZWwsIHZvaWQgKmN0eHQsIHZvaWQgKipyZXR2KQoreworCWFjcGlfc3Rh
dHVzIHN0YXR1czsKKworCXN0YXR1cyA9IGlzX21lbW9yeV9kZXZpY2UoaGFuZGxlKTsKKwlpZiAo
QUNQSV9GQUlMVVJFKHN0YXR1cykpCisJCXJldHVybiBBRV9PSzsJLyogY29udGludWUgKi8KKwor
CXN0YXR1cyA9IGFjcGlfaW5zdGFsbF9ub3RpZnlfaGFuZGxlcihoYW5kbGUsIEFDUElfU1lTVEVN
X05PVElGWSwKKwkJCQkJICAgICBhY3BpX21lbW9yeV9kZXZpY2Vfbm90aWZ5LCBOVUxMKTsKKwkv
KiBjb250aW51ZSAqLworCXJldHVybiBBRV9PSzsKK30KKworc3RhdGljIGludCBfX2luaXQgeGVu
X2FjcGlfbWVtb3J5X2RldmljZV9pbml0KHZvaWQpCit7CisJaW50IHJlc3VsdDsKKwlhY3BpX3N0
YXR1cyBzdGF0dXM7CisKKwkvKiBvbmx5IGRvbTAgaXMgcmVzcG9uc2libGUgZm9yIHhlbiBhY3Bp
IG1lbW9yeSBob3RwbHVnICovCisJaWYgKCF4ZW5faW5pdGlhbF9kb21haW4oKSkKKwkJcmV0dXJu
IC1FTk9ERVY7CisKKwlyZXN1bHQgPSBhY3BpX2J1c19yZWdpc3Rlcl9kcml2ZXIoJmFjcGlfbWVt
b3J5X2RldmljZV9kcml2ZXIpOworCWlmIChyZXN1bHQgPCAwKQorCQlyZXR1cm4gLUVOT0RFVjsK
KworCXN0YXR1cyA9IGFjcGlfd2Fsa19uYW1lc3BhY2UoQUNQSV9UWVBFX0RFVklDRSwgQUNQSV9S
T09UX09CSkVDVCwKKwkJCQkgICAgIEFDUElfVUlOVDMyX01BWCwKKwkJCQkgICAgIGFjcGlfbWVt
b3J5X3JlZ2lzdGVyX25vdGlmeV9oYW5kbGVyLCBOVUxMLAorCQkJCSAgICAgTlVMTCwgTlVMTCk7
CisKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpIHsKKwkJcHJfd2FybihQUkVGSVggIndhbGtf
bmFtZXNwYWNlIGZhaWxlZFxuIik7CisJCWFjcGlfYnVzX3VucmVnaXN0ZXJfZHJpdmVyKCZhY3Bp
X21lbW9yeV9kZXZpY2VfZHJpdmVyKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQorCisJYWNwaV9o
b3RtZW1faW5pdGlhbGl6ZWQgPSAxOworCXJldHVybiAwOworfQorc3Vic3lzX2luaXRjYWxsKHhl
bl9hY3BpX21lbW9yeV9kZXZpY2VfaW5pdCk7Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC82923353942F9SHSMSX101ccrcorpi_--
