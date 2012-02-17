Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2BQI7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:59:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:38161 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab2BQI7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:59:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="118566289"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
CC: "Li, Shaohua" <shaohua.li@intel.com>, Jan Beulich <JBeulich@suse.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>
Subject: [PATCH 3/3] Xen pad logic and notification
Thread-Topic: [PATCH 3/3] Xen pad logic and notification
Thread-Index: AcztUlYS1HfHeb7nTGSKH/iUASruog==
Date: Fri, 17 Feb 2012 08:58:38 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233509D87E@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233509D87ESHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233509D87ESHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From fee39804d2634dfba7b369dc82dac19b57400f84 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Sat, 18 Feb 2012 00:46:29 +0800
Subject: [PATCH 3/3] Xen pad logic and notification

This patch implement Xen pad logic, and when getting pad device
notification, it hypercalls to Xen hypervisor for core parking.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen_acpi_pad.c       |  189 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   14 +++
 2 files changed, 203 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xen_acpi_pad.c b/drivers/xen/xen_acpi_pad.c
index 63ab2fb..ba66d51 100644
--- a/drivers/xen/xen_acpi_pad.c
+++ b/drivers/xen/xen_acpi_pad.c
@@ -1,8 +1,197 @@
+/*
+ * xen_acpi_pad.c - Xen pad interface
+ *
+ * Copyright (c) 2012, Intel Corporation.
+ *    Author: Liu, Jinsong <jinsong.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License f=
or
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+
+#include <asm/xen/hypercall.h>
+
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS "xen_acpi_pad"
+#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Xen Processor Aggregator"
+#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
+static DEFINE_MUTEX(xen_cpu_lock);
+
+static int xen_acpi_pad_idle_cpus(int *num_cpus)
+{
+	int ret;
+
+	struct xen_platform_op op =3D {
+		.cmd =3D XENPF_core_parking,
+		.interface_version =3D XENPF_INTERFACE_VERSION,
+	};
+
+	/* set cpu nums expected to be idled */
+	op.u.core_parking.type =3D XEN_CORE_PARKING_SET;
+	op.u.core_parking.idle_nums =3D (uint32_t)*num_cpus;
+	ret =3D HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return ret;
+
+	/*
+	 * get cpu nums actually be idled
+	 * cannot get it by using hypercall once (shared with _SET)
+	 * because of the characteristic of Xen continue_hypercall_on_cpu
+	 */
+	op.u.core_parking.type =3D XEN_CORE_PARKING_GET;
+	ret =3D HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return ret;
+
+	*num_cpus =3D op.u.core_parking.idle_nums;
+	return 0;
+}
+
+/*
+ * Query firmware how many CPUs should be idle
+ * return -1 on failure
+ */
+static int xen_acpi_pad_pur(acpi_handle handle)
+{
+	struct acpi_buffer buffer =3D {ACPI_ALLOCATE_BUFFER, NULL};
+	union acpi_object *package;
+	int num =3D -1;
+
+	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_PUR", NULL, &buffer)))
+		return num;
+
+	if (!buffer.length || !buffer.pointer)
+		return num;
+
+	package =3D buffer.pointer;
+
+	if (package->type =3D=3D ACPI_TYPE_PACKAGE &&
+		package->package.count =3D=3D 2 &&
+		package->package.elements[0].integer.value =3D=3D 1) /* rev 1 */
+
+		num =3D package->package.elements[1].integer.value;
+
+	kfree(buffer.pointer);
+	return num;
+}
+
+/* Notify firmware how many CPUs are idle */
+static void xen_acpi_pad_ost(acpi_handle handle, int stat,
+	uint32_t idle_cpus)
+{
+	union acpi_object params[3] =3D {
+		{.type =3D ACPI_TYPE_INTEGER,},
+		{.type =3D ACPI_TYPE_INTEGER,},
+		{.type =3D ACPI_TYPE_BUFFER,},
+	};
+	struct acpi_object_list arg_list =3D {3, params};
+
+	params[0].integer.value =3D ACPI_PROCESSOR_AGGREGATOR_NOTIFY;
+	params[1].integer.value =3D  stat;
+	params[2].buffer.length =3D 4;
+	params[2].buffer.pointer =3D (void *)&idle_cpus;
+	acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
+}
+
+static void xen_acpi_pad_handle_notify(acpi_handle handle)
+{
+	int ret, num_cpus;
+
+	mutex_lock(&xen_cpu_lock);
+	num_cpus =3D xen_acpi_pad_pur(handle);
+	if (num_cpus < 0) {
+		mutex_unlock(&xen_cpu_lock);
+		return;
+	}
+
+	ret =3D xen_acpi_pad_idle_cpus(&num_cpus);
+	if (ret) {
+		mutex_unlock(&xen_cpu_lock);
+		return;
+	}
+
+	xen_acpi_pad_ost(handle, 0, num_cpus);
+	mutex_unlock(&xen_cpu_lock);
+}
+
+static void xen_acpi_pad_notify(acpi_handle handle, u32 event,
+	void *data)
+{
+	switch (event) {
+	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
+		xen_acpi_pad_handle_notify(handle);
+		break;
+	default:
+		printk(KERN_WARNING "Unsupported event [0x%x]\n", event);
+		break;
+	}
+}
+
+static int xen_acpi_pad_add(struct acpi_device *device)
+{
+	acpi_status status;
+
+	strcpy(acpi_device_name(device), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
+
+	status =3D acpi_install_notify_handler(device->handle,
+		 ACPI_DEVICE_NOTIFY, xen_acpi_pad_notify, device);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int xen_acpi_pad_remove(struct acpi_device *device,
+	int type)
+{
+	int num_cpus =3D 0;
+
+	mutex_lock(&xen_cpu_lock);
+	xen_acpi_pad_idle_cpus(&num_cpus);
+	mutex_unlock(&xen_cpu_lock);
+
+	acpi_remove_notify_handler(device->handle,
+		ACPI_DEVICE_NOTIFY, xen_acpi_pad_notify);
+	return 0;
+}
+
+static const struct acpi_device_id xen_pad_device_ids[] =3D {
+	{"ACPI000C", 0},
+	{"", 0},
+};
+
+static struct acpi_driver xen_acpi_pad_driver =3D {
+	.name =3D "xen_processor_aggregator",
+	.class =3D ACPI_PROCESSOR_AGGREGATOR_CLASS,
+	.ids =3D xen_pad_device_ids,
+	.ops =3D {
+		.add =3D xen_acpi_pad_add,
+		.remove =3D xen_acpi_pad_remove,
+	},
+};
+
 int xen_acpi_pad_init(void)
 {
+#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
+	return acpi_bus_register_driver(&xen_acpi_pad_driver);
+#else
 	return 0;
+#endif
 }
=20
 void xen_acpi_pad_exit(void)
 {
+#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
+	acpi_bus_unregister_driver(&xen_acpi_pad_driver);
+#endif
 }
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index c168468..56ec72a 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -297,6 +297,19 @@ struct xenpf_set_processor_pminfo {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_set_processor_pminfo);
=20
+#define XENPF_core_parking      60
+
+#define XEN_CORE_PARKING_SET    1
+#define XEN_CORE_PARKING_GET    2
+struct xenpf_core_parking {
+	/* IN variables */
+	uint32_t type;
+	/* IN variables:  set cpu nums expected to be idled */
+	/* OUT variables: get cpu nums actually be idled */
+	uint32_t idle_nums;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_core_parking);
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -312,6 +325,7 @@ struct xen_platform_op {
 		struct xenpf_change_freq       change_freq;
 		struct xenpf_getidletime       getidletime;
 		struct xenpf_set_processor_pminfo set_pminfo;
+		struct xenpf_core_parking      core_parking;
 		uint8_t                        pad[128];
 	} u;
 };
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233509D87ESHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0003-Xen-pad-logic-and-notification.patch"
Content-Description: 0003-Xen-pad-logic-and-notification.patch
Content-Disposition: attachment;
	filename="0003-Xen-pad-logic-and-notification.patch"; size=6797;
	creation-date="Fri, 17 Feb 2012 08:52:46 GMT";
	modification-date="Fri, 17 Feb 2012 16:49:16 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmZWUzOTgwNGQyNjM0ZGZiYTdiMzY5ZGM4MmRhYzE5YjU3NDAwZjg0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogU2F0LCAxOCBGZWIgMjAxMiAwMDo0NjoyOSArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMy8z
XSBYZW4gcGFkIGxvZ2ljIGFuZCBub3RpZmljYXRpb24KClRoaXMgcGF0Y2ggaW1wbGVtZW50IFhl
biBwYWQgbG9naWMsIGFuZCB3aGVuIGdldHRpbmcgcGFkIGRldmljZQpub3RpZmljYXRpb24sIGl0
IGh5cGVyY2FsbHMgdG8gWGVuIGh5cGVydmlzb3IgZm9yIGNvcmUgcGFya2luZy4KClNpZ25lZC1v
ZmYtYnk6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMv
eGVuL3hlbl9hY3BpX3BhZC5jICAgICAgIHwgIDE4OSArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKwogaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmggfCAgIDE0ICsr
KwogMiBmaWxlcyBjaGFuZ2VkLCAyMDMgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3hlbi94ZW5fYWNwaV9wYWQuYyBiL2RyaXZlcnMveGVuL3hlbl9h
Y3BpX3BhZC5jCmluZGV4IDYzYWIyZmIuLmJhNjZkNTEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVu
L3hlbl9hY3BpX3BhZC5jCisrKyBiL2RyaXZlcnMveGVuL3hlbl9hY3BpX3BhZC5jCkBAIC0xLDgg
KzEsMTk3IEBACisvKgorICogeGVuX2FjcGlfcGFkLmMgLSBYZW4gcGFkIGludGVyZmFjZQorICoK
KyAqIENvcHlyaWdodCAoYykgMjAxMiwgSW50ZWwgQ29ycG9yYXRpb24uCisgKiAgICBBdXRob3I6
IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgorICoKKyAqIFRoaXMgcHJvZ3Jh
bSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5
IGl0CisgKiB1bmRlciB0aGUgdGVybXMgYW5kIGNvbmRpdGlvbnMgb2YgdGhlIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlLAorICogdmVyc2lvbiAyLCBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUg
U29mdHdhcmUgRm91bmRhdGlvbi4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQg
aW4gdGhlIGhvcGUgaXQgd2lsbCBiZSB1c2VmdWwsIGJ1dCBXSVRIT1VUCisgKiBBTlkgV0FSUkFO
VFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZiBNRVJDSEFOVEFCSUxJVFkg
b3IKKyAqIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZSBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IKKyAqIG1vcmUgZGV0YWlscy4KKyAqLworCisjaW5jbHVk
ZSA8bGludXgva2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxh
Y3BpL2FjcGlfYnVzLmg+CisjaW5jbHVkZSA8YWNwaS9hY3BpX2RyaXZlcnMuaD4KKworI2luY2x1
ZGUgPGFzbS94ZW4vaHlwZXJjYWxsLmg+CisKKyNkZWZpbmUgQUNQSV9QUk9DRVNTT1JfQUdHUkVH
QVRPUl9DTEFTUyAieGVuX2FjcGlfcGFkIgorI2RlZmluZSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdB
VE9SX0RFVklDRV9OQU1FICJYZW4gUHJvY2Vzc29yIEFnZ3JlZ2F0b3IiCisjZGVmaW5lIEFDUElf
UFJPQ0VTU09SX0FHR1JFR0FUT1JfTk9USUZZIDB4ODAKK3N0YXRpYyBERUZJTkVfTVVURVgoeGVu
X2NwdV9sb2NrKTsKKworc3RhdGljIGludCB4ZW5fYWNwaV9wYWRfaWRsZV9jcHVzKGludCAqbnVt
X2NwdXMpCit7CisJaW50IHJldDsKKworCXN0cnVjdCB4ZW5fcGxhdGZvcm1fb3Agb3AgPSB7CisJ
CS5jbWQgPSBYRU5QRl9jb3JlX3BhcmtpbmcsCisJCS5pbnRlcmZhY2VfdmVyc2lvbiA9IFhFTlBG
X0lOVEVSRkFDRV9WRVJTSU9OLAorCX07CisKKwkvKiBzZXQgY3B1IG51bXMgZXhwZWN0ZWQgdG8g
YmUgaWRsZWQgKi8KKwlvcC51LmNvcmVfcGFya2luZy50eXBlID0gWEVOX0NPUkVfUEFSS0lOR19T
RVQ7CisJb3AudS5jb3JlX3BhcmtpbmcuaWRsZV9udW1zID0gKHVpbnQzMl90KSpudW1fY3B1czsK
KwlyZXQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwlpZiAocmV0KQorCQlyZXR1cm4gcmV0
OworCisJLyoKKwkgKiBnZXQgY3B1IG51bXMgYWN0dWFsbHkgYmUgaWRsZWQKKwkgKiBjYW5ub3Qg
Z2V0IGl0IGJ5IHVzaW5nIGh5cGVyY2FsbCBvbmNlIChzaGFyZWQgd2l0aCBfU0VUKQorCSAqIGJl
Y2F1c2Ugb2YgdGhlIGNoYXJhY3RlcmlzdGljIG9mIFhlbiBjb250aW51ZV9oeXBlcmNhbGxfb25f
Y3B1CisJICovCisJb3AudS5jb3JlX3BhcmtpbmcudHlwZSA9IFhFTl9DT1JFX1BBUktJTkdfR0VU
OworCXJldCA9IEhZUEVSVklTT1JfZG9tMF9vcCgmb3ApOworCWlmIChyZXQpCisJCXJldHVybiBy
ZXQ7CisKKwkqbnVtX2NwdXMgPSBvcC51LmNvcmVfcGFya2luZy5pZGxlX251bXM7CisJcmV0dXJu
IDA7Cit9CisKKy8qCisgKiBRdWVyeSBmaXJtd2FyZSBob3cgbWFueSBDUFVzIHNob3VsZCBiZSBp
ZGxlCisgKiByZXR1cm4gLTEgb24gZmFpbHVyZQorICovCitzdGF0aWMgaW50IHhlbl9hY3BpX3Bh
ZF9wdXIoYWNwaV9oYW5kbGUgaGFuZGxlKQoreworCXN0cnVjdCBhY3BpX2J1ZmZlciBidWZmZXIg
PSB7QUNQSV9BTExPQ0FURV9CVUZGRVIsIE5VTEx9OworCXVuaW9uIGFjcGlfb2JqZWN0ICpwYWNr
YWdlOworCWludCBudW0gPSAtMTsKKworCWlmIChBQ1BJX0ZBSUxVUkUoYWNwaV9ldmFsdWF0ZV9v
YmplY3QoaGFuZGxlLCAiX1BVUiIsIE5VTEwsICZidWZmZXIpKSkKKwkJcmV0dXJuIG51bTsKKwor
CWlmICghYnVmZmVyLmxlbmd0aCB8fCAhYnVmZmVyLnBvaW50ZXIpCisJCXJldHVybiBudW07CisK
KwlwYWNrYWdlID0gYnVmZmVyLnBvaW50ZXI7CisKKwlpZiAocGFja2FnZS0+dHlwZSA9PSBBQ1BJ
X1RZUEVfUEFDS0FHRSAmJgorCQlwYWNrYWdlLT5wYWNrYWdlLmNvdW50ID09IDIgJiYKKwkJcGFj
a2FnZS0+cGFja2FnZS5lbGVtZW50c1swXS5pbnRlZ2VyLnZhbHVlID09IDEpIC8qIHJldiAxICov
CisKKwkJbnVtID0gcGFja2FnZS0+cGFja2FnZS5lbGVtZW50c1sxXS5pbnRlZ2VyLnZhbHVlOwor
CisJa2ZyZWUoYnVmZmVyLnBvaW50ZXIpOworCXJldHVybiBudW07Cit9CisKKy8qIE5vdGlmeSBm
aXJtd2FyZSBob3cgbWFueSBDUFVzIGFyZSBpZGxlICovCitzdGF0aWMgdm9pZCB4ZW5fYWNwaV9w
YWRfb3N0KGFjcGlfaGFuZGxlIGhhbmRsZSwgaW50IHN0YXQsCisJdWludDMyX3QgaWRsZV9jcHVz
KQoreworCXVuaW9uIGFjcGlfb2JqZWN0IHBhcmFtc1szXSA9IHsKKwkJey50eXBlID0gQUNQSV9U
WVBFX0lOVEVHRVIsfSwKKwkJey50eXBlID0gQUNQSV9UWVBFX0lOVEVHRVIsfSwKKwkJey50eXBl
ID0gQUNQSV9UWVBFX0JVRkZFUix9LAorCX07CisJc3RydWN0IGFjcGlfb2JqZWN0X2xpc3QgYXJn
X2xpc3QgPSB7MywgcGFyYW1zfTsKKworCXBhcmFtc1swXS5pbnRlZ2VyLnZhbHVlID0gQUNQSV9Q
Uk9DRVNTT1JfQUdHUkVHQVRPUl9OT1RJRlk7CisJcGFyYW1zWzFdLmludGVnZXIudmFsdWUgPSAg
c3RhdDsKKwlwYXJhbXNbMl0uYnVmZmVyLmxlbmd0aCA9IDQ7CisJcGFyYW1zWzJdLmJ1ZmZlci5w
b2ludGVyID0gKHZvaWQgKikmaWRsZV9jcHVzOworCWFjcGlfZXZhbHVhdGVfb2JqZWN0KGhhbmRs
ZSwgIl9PU1QiLCAmYXJnX2xpc3QsIE5VTEwpOworfQorCitzdGF0aWMgdm9pZCB4ZW5fYWNwaV9w
YWRfaGFuZGxlX25vdGlmeShhY3BpX2hhbmRsZSBoYW5kbGUpCit7CisJaW50IHJldCwgbnVtX2Nw
dXM7CisKKwltdXRleF9sb2NrKCZ4ZW5fY3B1X2xvY2spOworCW51bV9jcHVzID0geGVuX2FjcGlf
cGFkX3B1cihoYW5kbGUpOworCWlmIChudW1fY3B1cyA8IDApIHsKKwkJbXV0ZXhfdW5sb2NrKCZ4
ZW5fY3B1X2xvY2spOworCQlyZXR1cm47CisJfQorCisJcmV0ID0geGVuX2FjcGlfcGFkX2lkbGVf
Y3B1cygmbnVtX2NwdXMpOworCWlmIChyZXQpIHsKKwkJbXV0ZXhfdW5sb2NrKCZ4ZW5fY3B1X2xv
Y2spOworCQlyZXR1cm47CisJfQorCisJeGVuX2FjcGlfcGFkX29zdChoYW5kbGUsIDAsIG51bV9j
cHVzKTsKKwltdXRleF91bmxvY2soJnhlbl9jcHVfbG9jayk7Cit9CisKK3N0YXRpYyB2b2lkIHhl
bl9hY3BpX3BhZF9ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxlLCB1MzIgZXZlbnQsCisJdm9pZCAq
ZGF0YSkKK3sKKwlzd2l0Y2ggKGV2ZW50KSB7CisJY2FzZSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdB
VE9SX05PVElGWToKKwkJeGVuX2FjcGlfcGFkX2hhbmRsZV9ub3RpZnkoaGFuZGxlKTsKKwkJYnJl
YWs7CisJZGVmYXVsdDoKKwkJcHJpbnRrKEtFUk5fV0FSTklORyAiVW5zdXBwb3J0ZWQgZXZlbnQg
WzB4JXhdXG4iLCBldmVudCk7CisJCWJyZWFrOworCX0KK30KKworc3RhdGljIGludCB4ZW5fYWNw
aV9wYWRfYWRkKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlKQoreworCWFjcGlfc3RhdHVzIHN0
YXR1czsKKworCXN0cmNweShhY3BpX2RldmljZV9uYW1lKGRldmljZSksIEFDUElfUFJPQ0VTU09S
X0FHR1JFR0FUT1JfREVWSUNFX05BTUUpOworCXN0cmNweShhY3BpX2RldmljZV9jbGFzcyhkZXZp
Y2UpLCBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX0NMQVNTKTsKKworCXN0YXR1cyA9IGFjcGlf
aW5zdGFsbF9ub3RpZnlfaGFuZGxlcihkZXZpY2UtPmhhbmRsZSwKKwkJIEFDUElfREVWSUNFX05P
VElGWSwgeGVuX2FjcGlfcGFkX25vdGlmeSwgZGV2aWNlKTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0
YXR1cykpCisJCXJldHVybiAtRU5PREVWOworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQg
eGVuX2FjcGlfcGFkX3JlbW92ZShzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSwKKwlpbnQgdHlw
ZSkKK3sKKwlpbnQgbnVtX2NwdXMgPSAwOworCisJbXV0ZXhfbG9jaygmeGVuX2NwdV9sb2NrKTsK
Kwl4ZW5fYWNwaV9wYWRfaWRsZV9jcHVzKCZudW1fY3B1cyk7CisJbXV0ZXhfdW5sb2NrKCZ4ZW5f
Y3B1X2xvY2spOworCisJYWNwaV9yZW1vdmVfbm90aWZ5X2hhbmRsZXIoZGV2aWNlLT5oYW5kbGUs
CisJCUFDUElfREVWSUNFX05PVElGWSwgeGVuX2FjcGlfcGFkX25vdGlmeSk7CisJcmV0dXJuIDA7
Cit9CisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgYWNwaV9kZXZpY2VfaWQgeGVuX3BhZF9kZXZpY2Vf
aWRzW10gPSB7CisJeyJBQ1BJMDAwQyIsIDB9LAorCXsiIiwgMH0sCit9OworCitzdGF0aWMgc3Ry
dWN0IGFjcGlfZHJpdmVyIHhlbl9hY3BpX3BhZF9kcml2ZXIgPSB7CisJLm5hbWUgPSAieGVuX3By
b2Nlc3Nvcl9hZ2dyZWdhdG9yIiwKKwkuY2xhc3MgPSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9S
X0NMQVNTLAorCS5pZHMgPSB4ZW5fcGFkX2RldmljZV9pZHMsCisJLm9wcyA9IHsKKwkJLmFkZCA9
IHhlbl9hY3BpX3BhZF9hZGQsCisJCS5yZW1vdmUgPSB4ZW5fYWNwaV9wYWRfcmVtb3ZlLAorCX0s
Cit9OworCiBpbnQgeGVuX2FjcGlfcGFkX2luaXQodm9pZCkKIHsKKyNpZmRlZiBDT05GSUdfQUNQ
SV9QUk9DRVNTT1JfQUdHUkVHQVRPUgorCXJldHVybiBhY3BpX2J1c19yZWdpc3Rlcl9kcml2ZXIo
Jnhlbl9hY3BpX3BhZF9kcml2ZXIpOworI2Vsc2UKIAlyZXR1cm4gMDsKKyNlbmRpZgogfQogCiB2
b2lkIHhlbl9hY3BpX3BhZF9leGl0KHZvaWQpCiB7CisjaWZkZWYgQ09ORklHX0FDUElfUFJPQ0VT
U09SX0FHR1JFR0FUT1IKKwlhY3BpX2J1c191bnJlZ2lzdGVyX2RyaXZlcigmeGVuX2FjcGlfcGFk
X2RyaXZlcik7CisjZW5kaWYKIH0KZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9w
bGF0Zm9ybS5oIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKaW5kZXggYzE2ODQ2
OC4uNTZlYzcyYSAxMDA2NDQKLS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgK
KysrIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKQEAgLTI5Nyw2ICsyOTcsMTkg
QEAgc3RydWN0IHhlbnBmX3NldF9wcm9jZXNzb3JfcG1pbmZvIHsKIH07CiBERUZJTkVfR1VFU1Rf
SEFORExFX1NUUlVDVCh4ZW5wZl9zZXRfcHJvY2Vzc29yX3BtaW5mbyk7CiAKKyNkZWZpbmUgWEVO
UEZfY29yZV9wYXJraW5nICAgICAgNjAKKworI2RlZmluZSBYRU5fQ09SRV9QQVJLSU5HX1NFVCAg
ICAxCisjZGVmaW5lIFhFTl9DT1JFX1BBUktJTkdfR0VUICAgIDIKK3N0cnVjdCB4ZW5wZl9jb3Jl
X3BhcmtpbmcgeworCS8qIElOIHZhcmlhYmxlcyAqLworCXVpbnQzMl90IHR5cGU7CisJLyogSU4g
dmFyaWFibGVzOiAgc2V0IGNwdSBudW1zIGV4cGVjdGVkIHRvIGJlIGlkbGVkICovCisJLyogT1VU
IHZhcmlhYmxlczogZ2V0IGNwdSBudW1zIGFjdHVhbGx5IGJlIGlkbGVkICovCisJdWludDMyX3Qg
aWRsZV9udW1zOworfTsKK0RFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbnBmX2NvcmVfcGFy
a2luZyk7CisKIHN0cnVjdCB4ZW5fcGxhdGZvcm1fb3AgewogCXVpbnQzMl90IGNtZDsKIAl1aW50
MzJfdCBpbnRlcmZhY2VfdmVyc2lvbjsgLyogWEVOUEZfSU5URVJGQUNFX1ZFUlNJT04gKi8KQEAg
LTMxMiw2ICszMjUsNyBAQCBzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIHsKIAkJc3RydWN0IHhlbnBm
X2NoYW5nZV9mcmVxICAgICAgIGNoYW5nZV9mcmVxOwogCQlzdHJ1Y3QgeGVucGZfZ2V0aWRsZXRp
bWUgICAgICAgZ2V0aWRsZXRpbWU7CiAJCXN0cnVjdCB4ZW5wZl9zZXRfcHJvY2Vzc29yX3BtaW5m
byBzZXRfcG1pbmZvOworCQlzdHJ1Y3QgeGVucGZfY29yZV9wYXJraW5nICAgICAgY29yZV9wYXJr
aW5nOwogCQl1aW50OF90ICAgICAgICAgICAgICAgICAgICAgICAgcGFkWzEyOF07CiAJfSB1Owog
fTsKLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC829233509D87ESHSMSX101ccrcorpi_--
