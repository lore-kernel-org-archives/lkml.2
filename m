Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab2JZOAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:00:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:25219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab2JZOAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:00:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="scan'208,223";a="232926308"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNs3G2Ti91BiFLfUibRvXA4zlK85fLgkyggAAZxiA=
Date: Fri, 26 Oct 2012 14:00:36 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
	<5089676602000078000A4928@nat28.tlf.novell.com>
	<DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
	<508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233537292ESHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233537292ESHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Updated per Jan's comments.

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

>From e6d4eceba9538c6873f9c970425e65e257fd9bf0 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Sat, 27 Oct 2012 05:34:50 +0800
Subject: [PATCH 1/2] Xen acpi pad implement

PAD is acpi Processor Aggregator Device which provides a control point
that enables the platform to perform specific processor configuration
and control that applies to all processors in the platform.

This patch is to implement Xen acpi pad logic. When running under Xen
virt platform, native pad driver would not work. Instead Xen pad driver,
a self-contained and very thin logic level, would take over acpi pad staff.
When acpi pad notify OSPM, xen pad logic intercept and parse _PUR object
and then hypercall to hyervisor for the rest work, say, core parking.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/Makefile             |    1 +
 drivers/xen/xen_acpi_pad.c       |  201 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   17 +++
 3 files changed, 219 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen_acpi_pad.c

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 0e86370..a2af622 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_XEN_MCE_LOG)		+=3D mcelog.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+=3D xen-acpi-processor.o
+obj-$(CONFIG_XEN_DOM0)			+=3D xen_acpi_pad.o
 xen-evtchn-y				:=3D evtchn.o
 xen-gntdev-y				:=3D gntdev.o
 xen-gntalloc-y				:=3D gntalloc.o
diff --git a/drivers/xen/xen_acpi_pad.c b/drivers/xen/xen_acpi_pad.c
new file mode 100644
index 0000000..0f1a1e6
--- /dev/null
+++ b/drivers/xen/xen_acpi_pad.c
@@ -0,0 +1,201 @@
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
+#include <asm/xen/hypercall.h>
+
+#if defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) || \
+		defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)
+
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
+#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
+#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
+
+static DEFINE_MUTEX(xen_pad_lock);
+
+static int xen_pad_set_idle_cpus(int num_cpus)
+{
+	struct xen_platform_op op;
+
+	if (num_cpus < 0)
+		return -EINVAL;
+
+	/* set cpu nums expected to be idled */
+	op.cmd =3D XENPF_core_parking;
+	op.u.core_parking.type =3D XEN_CORE_PARKING_SET;
+	op.u.core_parking.idle_nums =3D num_cpus;
+
+	return HYPERVISOR_dom0_op(&op);
+}
+
+/*
+ * Cannot get idle cpus by using hypercall once (shared with _SET)
+ * because of the characteristic of Xen continue_hypercall_on_cpu
+ */
+static int xen_pad_get_idle_cpus(void)
+{
+	int ret;
+	struct xen_platform_op op;
+
+	/* get cpu nums actually be idled */
+	op.cmd =3D XENPF_core_parking;
+	op.u.core_parking.type =3D XEN_CORE_PARKING_GET;
+	ret =3D HYPERVISOR_dom0_op(&op);
+	if (ret < 0)
+		return ret;
+
+	return op.u.core_parking.idle_nums;
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
+	int num_cpus;
+
+	num_cpus =3D xen_acpi_pad_pur(handle);
+	if (num_cpus < 0)
+		return;
+
+	mutex_lock(&xen_pad_lock);
+	if (xen_pad_set_idle_cpus(num_cpus)) {
+		mutex_unlock(&xen_pad_lock);
+		return;
+	}
+
+	num_cpus =3D xen_pad_get_idle_cpus();
+	if (num_cpus < 0) {
+		mutex_unlock(&xen_pad_lock);
+		return;
+	}
+	mutex_unlock(&xen_pad_lock);
+
+	xen_acpi_pad_ost(handle, 0, num_cpus);
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
+		pr_warn("Unsupported event [0x%x]\n", event);
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
+	mutex_lock(&xen_pad_lock);
+	xen_pad_set_idle_cpus(0);
+	mutex_unlock(&xen_pad_lock);
+
+	acpi_remove_notify_handler(device->handle,
+		ACPI_DEVICE_NOTIFY, xen_acpi_pad_notify);
+	return 0;
+}
+
+static const struct acpi_device_id pad_device_ids[] =3D {
+	{"ACPI000C", 0},
+	{"", 0},
+};
+
+static struct acpi_driver xen_acpi_pad_driver =3D {
+	.name =3D "processor_aggregator",
+	.class =3D ACPI_PROCESSOR_AGGREGATOR_CLASS,
+	.ids =3D pad_device_ids,
+	.ops =3D {
+		.add =3D xen_acpi_pad_add,
+		.remove =3D xen_acpi_pad_remove,
+	},
+};
+
+static int __init xen_acpi_pad_init(void)
+{
+	/* Only DOM0 is responsible for Xen acpi pad */
+	if (xen_initial_domain())
+		return acpi_bus_register_driver(&xen_acpi_pad_driver);
+
+	return -ENODEV;
+}
+subsys_initcall(xen_acpi_pad_init);
+
+#endif
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 4755b5f..0f44376 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -324,6 +324,22 @@ struct xenpf_cpu_ol {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
=20
+/*
+ * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
+ * which already occupied at Xen hypervisor side.
+ */
+#define XENPF_core_parking	60
+struct xenpf_core_parking {
+	/* IN variables */
+#define XEN_CORE_PARKING_SET	1
+#define XEN_CORE_PARKING_GET	2
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
@@ -341,6 +357,7 @@ struct xen_platform_op {
 		struct xenpf_set_processor_pminfo set_pminfo;
 		struct xenpf_pcpuinfo          pcpu_info;
 		struct xenpf_cpu_ol            cpu_ol;
+		struct xenpf_core_parking      core_parking;
 		uint8_t                        pad[128];
 	} u;
 };
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233537292ESHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-acpi-pad-implement.patch"
Content-Description: 0001-Xen-acpi-pad-implement.patch
Content-Disposition: attachment;
	filename="0001-Xen-acpi-pad-implement.patch"; size=7968;
	creation-date="Fri, 26 Oct 2012 13:48:06 GMT";
	modification-date="Fri, 26 Oct 2012 21:38:58 GMT"
Content-Transfer-Encoding: base64

RnJvbSBlNmQ0ZWNlYmE5NTM4YzY4NzNmOWM5NzA0MjVlNjVlMjU3ZmQ5YmYwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogU2F0LCAyNyBPY3QgMjAxMiAwNTozNDo1MCArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBYZW4gYWNwaSBwYWQgaW1wbGVtZW50CgpQQUQgaXMgYWNwaSBQcm9jZXNzb3IgQWdncmVnYXRv
ciBEZXZpY2Ugd2hpY2ggcHJvdmlkZXMgYSBjb250cm9sIHBvaW50CnRoYXQgZW5hYmxlcyB0aGUg
cGxhdGZvcm0gdG8gcGVyZm9ybSBzcGVjaWZpYyBwcm9jZXNzb3IgY29uZmlndXJhdGlvbgphbmQg
Y29udHJvbCB0aGF0IGFwcGxpZXMgdG8gYWxsIHByb2Nlc3NvcnMgaW4gdGhlIHBsYXRmb3JtLgoK
VGhpcyBwYXRjaCBpcyB0byBpbXBsZW1lbnQgWGVuIGFjcGkgcGFkIGxvZ2ljLiBXaGVuIHJ1bm5p
bmcgdW5kZXIgWGVuCnZpcnQgcGxhdGZvcm0sIG5hdGl2ZSBwYWQgZHJpdmVyIHdvdWxkIG5vdCB3
b3JrLiBJbnN0ZWFkIFhlbiBwYWQgZHJpdmVyLAphIHNlbGYtY29udGFpbmVkIGFuZCB2ZXJ5IHRo
aW4gbG9naWMgbGV2ZWwsIHdvdWxkIHRha2Ugb3ZlciBhY3BpIHBhZCBzdGFmZi4KV2hlbiBhY3Bp
IHBhZCBub3RpZnkgT1NQTSwgeGVuIHBhZCBsb2dpYyBpbnRlcmNlcHQgYW5kIHBhcnNlIF9QVVIg
b2JqZWN0CmFuZCB0aGVuIGh5cGVyY2FsbCB0byBoeWVydmlzb3IgZm9yIHRoZSByZXN0IHdvcmss
IHNheSwgY29yZSBwYXJraW5nLgoKU2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25n
LmxpdUBpbnRlbC5jb20+Ci0tLQogZHJpdmVycy94ZW4vTWFrZWZpbGUgICAgICAgICAgICAgfCAg
ICAxICsKIGRyaXZlcnMveGVuL3hlbl9hY3BpX3BhZC5jICAgICAgIHwgIDIwMSArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKwogaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRm
b3JtLmggfCAgIDE3ICsrKwogMyBmaWxlcyBjaGFuZ2VkLCAyMTkgaW5zZXJ0aW9ucygrKSwgMCBk
ZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3hlbi94ZW5fYWNwaV9wYWQu
YwoKZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2VmaWxlIGIvZHJpdmVycy94ZW4vTWFrZWZp
bGUKaW5kZXggMGU4NjM3MC4uYTJhZjYyMiAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vTWFrZWZp
bGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAgLTI5LDYgKzI5LDcgQEAgb2JqLSQoQ09O
RklHX1hFTl9NQ0VfTE9HKQkJKz0gbWNlbG9nLm8KIG9iai0kKENPTkZJR19YRU5fUENJREVWX0JB
Q0tFTkQpCSs9IHhlbi1wY2liYWNrLwogb2JqLSQoQ09ORklHX1hFTl9QUklWQ01EKQkJKz0geGVu
LXByaXZjbWQubwogb2JqLSQoQ09ORklHX1hFTl9BQ1BJX1BST0NFU1NPUikJKz0geGVuLWFjcGkt
cHJvY2Vzc29yLm8KK29iai0kKENPTkZJR19YRU5fRE9NMCkJCQkrPSB4ZW5fYWNwaV9wYWQubwog
eGVuLWV2dGNobi15CQkJCTo9IGV2dGNobi5vCiB4ZW4tZ250ZGV2LXkJCQkJOj0gZ250ZGV2Lm8K
IHhlbi1nbnRhbGxvYy15CQkJCTo9IGdudGFsbG9jLm8KZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVu
L3hlbl9hY3BpX3BhZC5jIGIvZHJpdmVycy94ZW4veGVuX2FjcGlfcGFkLmMKbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uMGYxYTFlNgotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZl
cnMveGVuL3hlbl9hY3BpX3BhZC5jCkBAIC0wLDAgKzEsMjAxIEBACisvKgorICogeGVuX2FjcGlf
cGFkLmMgLSBYZW4gcGFkIGludGVyZmFjZQorICoKKyAqIENvcHlyaWdodCAoYykgMjAxMiwgSW50
ZWwgQ29ycG9yYXRpb24uCisgKiAgICBBdXRob3I6IExpdSwgSmluc29uZyA8amluc29uZy5saXVA
aW50ZWwuY29tPgorICoKKyAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2Fu
IHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0CisgKiB1bmRlciB0aGUgdGVybXMgYW5k
IGNvbmRpdGlvbnMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlLAorICogdmVyc2lv
biAyLCBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbi4KKyAqCisg
KiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgaXQgd2lsbCBiZSB1c2Vm
dWwsIGJ1dCBXSVRIT1VUCisgKiBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGll
ZCB3YXJyYW50eSBvZiBNRVJDSEFOVEFCSUxJVFkgb3IKKyAqIEZJVE5FU1MgRk9SIEEgUEFSVElD
VUxBUiBQVVJQT1NFLiAgU2VlIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IKKyAq
IG1vcmUgZGV0YWlscy4KKyAqLworCisjaW5jbHVkZSA8bGludXgva2VybmVsLmg+CisjaW5jbHVk
ZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxhY3BpL2FjcGlfYnVzLmg+CisjaW5jbHVkZSA8
YWNwaS9hY3BpX2RyaXZlcnMuaD4KKyNpbmNsdWRlIDxhc20veGVuL2h5cGVyY2FsbC5oPgorCisj
aWYgZGVmaW5lZChDT05GSUdfQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUikgfHwgXAorCQlkZWZp
bmVkKENPTkZJR19BQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX01PRFVMRSkKKworI2RlZmluZSBB
Q1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX0NMQVNTCSJhY3BpX3BhZCIKKyNkZWZpbmUgQUNQSV9Q
Uk9DRVNTT1JfQUdHUkVHQVRPUl9ERVZJQ0VfTkFNRSAiUHJvY2Vzc29yIEFnZ3JlZ2F0b3IiCisj
ZGVmaW5lIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfTk9USUZZIDB4ODAKKworc3RhdGljIERF
RklORV9NVVRFWCh4ZW5fcGFkX2xvY2spOworCitzdGF0aWMgaW50IHhlbl9wYWRfc2V0X2lkbGVf
Y3B1cyhpbnQgbnVtX2NwdXMpCit7CisJc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBvcDsKKworCWlm
IChudW1fY3B1cyA8IDApCisJCXJldHVybiAtRUlOVkFMOworCisJLyogc2V0IGNwdSBudW1zIGV4
cGVjdGVkIHRvIGJlIGlkbGVkICovCisJb3AuY21kID0gWEVOUEZfY29yZV9wYXJraW5nOworCW9w
LnUuY29yZV9wYXJraW5nLnR5cGUgPSBYRU5fQ09SRV9QQVJLSU5HX1NFVDsKKwlvcC51LmNvcmVf
cGFya2luZy5pZGxlX251bXMgPSBudW1fY3B1czsKKworCXJldHVybiBIWVBFUlZJU09SX2RvbTBf
b3AoJm9wKTsKK30KKworLyoKKyAqIENhbm5vdCBnZXQgaWRsZSBjcHVzIGJ5IHVzaW5nIGh5cGVy
Y2FsbCBvbmNlIChzaGFyZWQgd2l0aCBfU0VUKQorICogYmVjYXVzZSBvZiB0aGUgY2hhcmFjdGVy
aXN0aWMgb2YgWGVuIGNvbnRpbnVlX2h5cGVyY2FsbF9vbl9jcHUKKyAqLworc3RhdGljIGludCB4
ZW5fcGFkX2dldF9pZGxlX2NwdXModm9pZCkKK3sKKwlpbnQgcmV0OworCXN0cnVjdCB4ZW5fcGxh
dGZvcm1fb3Agb3A7CisKKwkvKiBnZXQgY3B1IG51bXMgYWN0dWFsbHkgYmUgaWRsZWQgKi8KKwlv
cC5jbWQgPSBYRU5QRl9jb3JlX3Bhcmtpbmc7CisJb3AudS5jb3JlX3BhcmtpbmcudHlwZSA9IFhF
Tl9DT1JFX1BBUktJTkdfR0VUOworCXJldCA9IEhZUEVSVklTT1JfZG9tMF9vcCgmb3ApOworCWlm
IChyZXQgPCAwKQorCQlyZXR1cm4gcmV0OworCisJcmV0dXJuIG9wLnUuY29yZV9wYXJraW5nLmlk
bGVfbnVtczsKK30KKworLyoKKyAqIFF1ZXJ5IGZpcm13YXJlIGhvdyBtYW55IENQVXMgc2hvdWxk
IGJlIGlkbGUKKyAqIHJldHVybiAtMSBvbiBmYWlsdXJlCisgKi8KK3N0YXRpYyBpbnQgeGVuX2Fj
cGlfcGFkX3B1cihhY3BpX2hhbmRsZSBoYW5kbGUpCit7CisJc3RydWN0IGFjcGlfYnVmZmVyIGJ1
ZmZlciA9IHtBQ1BJX0FMTE9DQVRFX0JVRkZFUiwgTlVMTH07CisJdW5pb24gYWNwaV9vYmplY3Qg
KnBhY2thZ2U7CisJaW50IG51bSA9IC0xOworCisJaWYgKEFDUElfRkFJTFVSRShhY3BpX2V2YWx1
YXRlX29iamVjdChoYW5kbGUsICJfUFVSIiwgTlVMTCwgJmJ1ZmZlcikpKQorCQlyZXR1cm4gbnVt
OworCisJaWYgKCFidWZmZXIubGVuZ3RoIHx8ICFidWZmZXIucG9pbnRlcikKKwkJcmV0dXJuIG51
bTsKKworCXBhY2thZ2UgPSBidWZmZXIucG9pbnRlcjsKKworCWlmIChwYWNrYWdlLT50eXBlID09
IEFDUElfVFlQRV9QQUNLQUdFICYmCisJCXBhY2thZ2UtPnBhY2thZ2UuY291bnQgPT0gMiAmJgor
CQlwYWNrYWdlLT5wYWNrYWdlLmVsZW1lbnRzWzBdLmludGVnZXIudmFsdWUgPT0gMSkgLyogcmV2
IDEgKi8KKworCQludW0gPSBwYWNrYWdlLT5wYWNrYWdlLmVsZW1lbnRzWzFdLmludGVnZXIudmFs
dWU7CisKKwlrZnJlZShidWZmZXIucG9pbnRlcik7CisJcmV0dXJuIG51bTsKK30KKworLyogTm90
aWZ5IGZpcm13YXJlIGhvdyBtYW55IENQVXMgYXJlIGlkbGUgKi8KK3N0YXRpYyB2b2lkIHhlbl9h
Y3BpX3BhZF9vc3QoYWNwaV9oYW5kbGUgaGFuZGxlLCBpbnQgc3RhdCwKKwl1aW50MzJfdCBpZGxl
X2NwdXMpCit7CisJdW5pb24gYWNwaV9vYmplY3QgcGFyYW1zWzNdID0geworCQl7LnR5cGUgPSBB
Q1BJX1RZUEVfSU5URUdFUix9LAorCQl7LnR5cGUgPSBBQ1BJX1RZUEVfSU5URUdFUix9LAorCQl7
LnR5cGUgPSBBQ1BJX1RZUEVfQlVGRkVSLH0sCisJfTsKKwlzdHJ1Y3QgYWNwaV9vYmplY3RfbGlz
dCBhcmdfbGlzdCA9IHszLCBwYXJhbXN9OworCisJcGFyYW1zWzBdLmludGVnZXIudmFsdWUgPSBB
Q1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX05PVElGWTsKKwlwYXJhbXNbMV0uaW50ZWdlci52YWx1
ZSA9ICBzdGF0OworCXBhcmFtc1syXS5idWZmZXIubGVuZ3RoID0gNDsKKwlwYXJhbXNbMl0uYnVm
ZmVyLnBvaW50ZXIgPSAodm9pZCAqKSZpZGxlX2NwdXM7CisJYWNwaV9ldmFsdWF0ZV9vYmplY3Qo
aGFuZGxlLCAiX09TVCIsICZhcmdfbGlzdCwgTlVMTCk7Cit9CisKK3N0YXRpYyB2b2lkIHhlbl9h
Y3BpX3BhZF9oYW5kbGVfbm90aWZ5KGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwlpbnQgbnVtX2Nw
dXM7CisKKwludW1fY3B1cyA9IHhlbl9hY3BpX3BhZF9wdXIoaGFuZGxlKTsKKwlpZiAobnVtX2Nw
dXMgPCAwKQorCQlyZXR1cm47CisKKwltdXRleF9sb2NrKCZ4ZW5fcGFkX2xvY2spOworCWlmICh4
ZW5fcGFkX3NldF9pZGxlX2NwdXMobnVtX2NwdXMpKSB7CisJCW11dGV4X3VubG9jaygmeGVuX3Bh
ZF9sb2NrKTsKKwkJcmV0dXJuOworCX0KKworCW51bV9jcHVzID0geGVuX3BhZF9nZXRfaWRsZV9j
cHVzKCk7CisJaWYgKG51bV9jcHVzIDwgMCkgeworCQltdXRleF91bmxvY2soJnhlbl9wYWRfbG9j
ayk7CisJCXJldHVybjsKKwl9CisJbXV0ZXhfdW5sb2NrKCZ4ZW5fcGFkX2xvY2spOworCisJeGVu
X2FjcGlfcGFkX29zdChoYW5kbGUsIDAsIG51bV9jcHVzKTsKK30KKworc3RhdGljIHZvaWQgeGVu
X2FjcGlfcGFkX25vdGlmeShhY3BpX2hhbmRsZSBoYW5kbGUsIHUzMiBldmVudCwKKwl2b2lkICpk
YXRhKQoreworCXN3aXRjaCAoZXZlbnQpIHsKKwljYXNlIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FU
T1JfTk9USUZZOgorCQl4ZW5fYWNwaV9wYWRfaGFuZGxlX25vdGlmeShoYW5kbGUpOworCQlicmVh
azsKKwlkZWZhdWx0OgorCQlwcl93YXJuKCJVbnN1cHBvcnRlZCBldmVudCBbMHgleF1cbiIsIGV2
ZW50KTsKKwkJYnJlYWs7CisJfQorfQorCitzdGF0aWMgaW50IHhlbl9hY3BpX3BhZF9hZGQoc3Ry
dWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpCit7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3Ry
Y3B5KGFjcGlfZGV2aWNlX25hbWUoZGV2aWNlKSwgQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9E
RVZJQ0VfTkFNRSk7CisJc3RyY3B5KGFjcGlfZGV2aWNlX2NsYXNzKGRldmljZSksIEFDUElfUFJP
Q0VTU09SX0FHR1JFR0FUT1JfQ0xBU1MpOworCisJc3RhdHVzID0gYWNwaV9pbnN0YWxsX25vdGlm
eV9oYW5kbGVyKGRldmljZS0+aGFuZGxlLAorCQkgQUNQSV9ERVZJQ0VfTk9USUZZLCB4ZW5fYWNw
aV9wYWRfbm90aWZ5LCBkZXZpY2UpOworCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkKKwkJcmV0
dXJuIC1FTk9ERVY7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCB4ZW5fYWNwaV9wYWRf
cmVtb3ZlKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLAorCWludCB0eXBlKQoreworCW11dGV4
X2xvY2soJnhlbl9wYWRfbG9jayk7CisJeGVuX3BhZF9zZXRfaWRsZV9jcHVzKDApOworCW11dGV4
X3VubG9jaygmeGVuX3BhZF9sb2NrKTsKKworCWFjcGlfcmVtb3ZlX25vdGlmeV9oYW5kbGVyKGRl
dmljZS0+aGFuZGxlLAorCQlBQ1BJX0RFVklDRV9OT1RJRlksIHhlbl9hY3BpX3BhZF9ub3RpZnkp
OworCXJldHVybiAwOworfQorCitzdGF0aWMgY29uc3Qgc3RydWN0IGFjcGlfZGV2aWNlX2lkIHBh
ZF9kZXZpY2VfaWRzW10gPSB7CisJeyJBQ1BJMDAwQyIsIDB9LAorCXsiIiwgMH0sCit9OworCitz
dGF0aWMgc3RydWN0IGFjcGlfZHJpdmVyIHhlbl9hY3BpX3BhZF9kcml2ZXIgPSB7CisJLm5hbWUg
PSAicHJvY2Vzc29yX2FnZ3JlZ2F0b3IiLAorCS5jbGFzcyA9IEFDUElfUFJPQ0VTU09SX0FHR1JF
R0FUT1JfQ0xBU1MsCisJLmlkcyA9IHBhZF9kZXZpY2VfaWRzLAorCS5vcHMgPSB7CisJCS5hZGQg
PSB4ZW5fYWNwaV9wYWRfYWRkLAorCQkucmVtb3ZlID0geGVuX2FjcGlfcGFkX3JlbW92ZSwKKwl9
LAorfTsKKworc3RhdGljIGludCBfX2luaXQgeGVuX2FjcGlfcGFkX2luaXQodm9pZCkKK3sKKwkv
KiBPbmx5IERPTTAgaXMgcmVzcG9uc2libGUgZm9yIFhlbiBhY3BpIHBhZCAqLworCWlmICh4ZW5f
aW5pdGlhbF9kb21haW4oKSkKKwkJcmV0dXJuIGFjcGlfYnVzX3JlZ2lzdGVyX2RyaXZlcigmeGVu
X2FjcGlfcGFkX2RyaXZlcik7CisKKwlyZXR1cm4gLUVOT0RFVjsKK30KK3N1YnN5c19pbml0Y2Fs
bCh4ZW5fYWNwaV9wYWRfaW5pdCk7CisKKyNlbmRpZgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4v
aW50ZXJmYWNlL3BsYXRmb3JtLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaApp
bmRleCA0NzU1YjVmLi4wZjQ0Mzc2IDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2Uv
cGxhdGZvcm0uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaApAQCAtMzI0
LDYgKzMyNCwyMiBAQCBzdHJ1Y3QgeGVucGZfY3B1X29sIHsKIH07CiBERUZJTkVfR1VFU1RfSEFO
RExFX1NUUlVDVCh4ZW5wZl9jcHVfb2wpOwogCisvKgorICogQ01EIDU4IGFuZCA1OSBhcmUgcmVz
ZXJ2ZWQgZm9yIGNwdSBob3RhZGQgYW5kIG1lbW9yeSBob3RhZGQsCisgKiB3aGljaCBhbHJlYWR5
IG9jY3VwaWVkIGF0IFhlbiBoeXBlcnZpc29yIHNpZGUuCisgKi8KKyNkZWZpbmUgWEVOUEZfY29y
ZV9wYXJraW5nCTYwCitzdHJ1Y3QgeGVucGZfY29yZV9wYXJraW5nIHsKKwkvKiBJTiB2YXJpYWJs
ZXMgKi8KKyNkZWZpbmUgWEVOX0NPUkVfUEFSS0lOR19TRVQJMQorI2RlZmluZSBYRU5fQ09SRV9Q
QVJLSU5HX0dFVAkyCisJdWludDMyX3QgdHlwZTsKKwkvKiBJTiB2YXJpYWJsZXM6ICBzZXQgY3B1
IG51bXMgZXhwZWN0ZWQgdG8gYmUgaWRsZWQgKi8KKwkvKiBPVVQgdmFyaWFibGVzOiBnZXQgY3B1
IG51bXMgYWN0dWFsbHkgYmUgaWRsZWQgKi8KKwl1aW50MzJfdCBpZGxlX251bXM7Cit9OworREVG
SU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVucGZfY29yZV9wYXJraW5nKTsKKwogc3RydWN0IHhl
bl9wbGF0Zm9ybV9vcCB7CiAJdWludDMyX3QgY21kOwogCXVpbnQzMl90IGludGVyZmFjZV92ZXJz
aW9uOyAvKiBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lPTiAqLwpAQCAtMzQxLDYgKzM1Nyw3IEBAIHN0
cnVjdCB4ZW5fcGxhdGZvcm1fb3AgewogCQlzdHJ1Y3QgeGVucGZfc2V0X3Byb2Nlc3Nvcl9wbWlu
Zm8gc2V0X3BtaW5mbzsKIAkJc3RydWN0IHhlbnBmX3BjcHVpbmZvICAgICAgICAgIHBjcHVfaW5m
bzsKIAkJc3RydWN0IHhlbnBmX2NwdV9vbCAgICAgICAgICAgIGNwdV9vbDsKKwkJc3RydWN0IHhl
bnBmX2NvcmVfcGFya2luZyAgICAgIGNvcmVfcGFya2luZzsKIAkJdWludDhfdCAgICAgICAgICAg
ICAgICAgICAgICAgIHBhZFsxMjhdOwogCX0gdTsKIH07Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC829233537292ESHSMSX101ccrcorpi_--
