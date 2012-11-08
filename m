Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2KHFlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 00:41:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:18902 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab2KHFlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 00:41:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,736,1344236400"; 
   d="scan'208,223";a="238866839"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <jbeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH v2 1/2] Xen/acpi: ACPI PAD driver
Thread-Topic: [PATCH v2 1/2] Xen/acpi: ACPI PAD driver
Thread-Index: Ac29c6k/ou550tv2Qn224u0n9s+KjA==
Date: Thu, 8 Nov 2012 05:41:13 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537BF47@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233537BF47SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233537BF47SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

PAD is acpi Processor Aggregator Device which provides a control point
that enables the platform to perform specific processor configuration
and control that applies to all processors in the platform.

This patch is to implement Xen acpi pad logic. When running under Xen
virt platform, native pad driver would not work. Instead Xen pad driver,
a self-contained and thin logic level, would take over acpi pad logic.

When acpi pad notify OSPM, xen pad logic intercept and parse _PUR object
to get the expected idle cpu number, and then hypercall to hypervisor.
Xen hypervisor would then do the rest work, say, core parking, to idle
specific number of cpus on its own policy.

Signed-off-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/Makefile             |    3 +-
 drivers/xen/xen-acpi-pad.c       |  181 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   17 ++++
 include/xen/interface/version.h  |   15 +++
 4 files changed, 215 insertions(+), 1 deletions(-)
 create mode 100644 drivers/xen/xen-acpi-pad.c

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 0e86370..3c39717 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -10,7 +10,8 @@ CFLAGS_features.o			:=3D $(nostackp)
=20
 dom0-$(CONFIG_PCI) +=3D pci.o
 dom0-$(CONFIG_USB_SUPPORT) +=3D dbgp.o
-dom0-$(CONFIG_ACPI) +=3D acpi.o
+dom0-$(CONFIG_ACPI) +=3D acpi.o $(xen-pad-y)
+xen-pad-$(CONFIG_X86) +=3D xen-acpi-pad.o
 dom0-$(CONFIG_X86) +=3D pcpu.o
 obj-$(CONFIG_XEN_DOM0)			+=3D $(dom0-y)
 obj-$(CONFIG_BLOCK)			+=3D biomerge.o
diff --git a/drivers/xen/xen-acpi-pad.c b/drivers/xen/xen-acpi-pad.c
new file mode 100644
index 0000000..f23ecf3
--- /dev/null
+++ b/drivers/xen/xen-acpi-pad.c
@@ -0,0 +1,181 @@
+/*
+ * xen-acpi-pad.c - Xen pad interface
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
+#include <xen/interface/version.h>
+
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
+#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
+#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
+static DEFINE_MUTEX(xen_cpu_lock);
+
+static int xen_acpi_pad_idle_cpus(unsigned int idle_nums)
+{
+	struct xen_platform_op op;
+
+	op.cmd =3D XENPF_core_parking;
+	op.u.core_parking.type =3D XEN_CORE_PARKING_SET;
+	op.u.core_parking.idle_nums =3D idle_nums;
+
+	return HYPERVISOR_dom0_op(&op);
+}
+
+static int xen_acpi_pad_idle_cpus_num(void)
+{
+	struct xen_platform_op op;
+
+	op.cmd =3D XENPF_core_parking;
+	op.u.core_parking.type =3D XEN_CORE_PARKING_GET;
+
+	return HYPERVISOR_dom0_op(&op)
+	       ?: op.u.core_parking.idle_nums;
+}
+
+/*
+ * Query firmware how many CPUs should be idle
+ * return -1 on failure
+ */
+static int acpi_pad_pur(acpi_handle handle)
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
+		num =3D package->package.elements[1].integer.value;
+
+	kfree(buffer.pointer);
+	return num;
+}
+
+/* Notify firmware how many CPUs are idle */
+static void acpi_pad_ost(acpi_handle handle, int stat,
+	uint32_t idle_nums)
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
+	params[2].buffer.pointer =3D (void *)&idle_nums;
+	acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
+}
+
+static void acpi_pad_handle_notify(acpi_handle handle)
+{
+	int idle_nums;
+
+	mutex_lock(&xen_cpu_lock);
+	idle_nums =3D acpi_pad_pur(handle);
+	if (idle_nums < 0) {
+		mutex_unlock(&xen_cpu_lock);
+		return;
+	}
+
+	idle_nums =3D xen_acpi_pad_idle_cpus(idle_nums)
+		    ?: xen_acpi_pad_idle_cpus_num();
+	if (idle_nums >=3D 0)
+		acpi_pad_ost(handle, 0, idle_nums);
+	mutex_unlock(&xen_cpu_lock);
+}
+
+static void acpi_pad_notify(acpi_handle handle, u32 event,
+	void *data)
+{
+	switch (event) {
+	case ACPI_PROCESSOR_AGGREGATOR_NOTIFY:
+		acpi_pad_handle_notify(handle);
+		break;
+	default:
+		pr_warn("Unsupported event [0x%x]\n", event);
+		break;
+	}
+}
+
+static int acpi_pad_add(struct acpi_device *device)
+{
+	acpi_status status;
+
+	strcpy(acpi_device_name(device), ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME);
+	strcpy(acpi_device_class(device), ACPI_PROCESSOR_AGGREGATOR_CLASS);
+
+	status =3D acpi_install_notify_handler(device->handle,
+		ACPI_DEVICE_NOTIFY, acpi_pad_notify, device);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int acpi_pad_remove(struct acpi_device *device,
+	int type)
+{
+	mutex_lock(&xen_cpu_lock);
+	xen_acpi_pad_idle_cpus(0);
+	mutex_unlock(&xen_cpu_lock);
+
+	acpi_remove_notify_handler(device->handle,
+		ACPI_DEVICE_NOTIFY, acpi_pad_notify);
+	return 0;
+}
+
+static const struct acpi_device_id pad_device_ids[] =3D {
+	{"ACPI000C", 0},
+	{"", 0},
+};
+
+static struct acpi_driver acpi_pad_driver =3D {
+	.name =3D "processor_aggregator",
+	.class =3D ACPI_PROCESSOR_AGGREGATOR_CLASS,
+	.ids =3D pad_device_ids,
+	.ops =3D {
+		.add =3D acpi_pad_add,
+		.remove =3D acpi_pad_remove,
+	},
+};
+
+static int __init xen_acpi_pad_init(void)
+{
+	/* Only DOM0 is responsible for Xen acpi pad */
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* Only Xen4.2 or later support Xen acpi pad */
+	if (!xen_running_on_version_or_later(4, 2))
+		return -ENODEV;
+
+	return acpi_bus_register_driver(&acpi_pad_driver);
+}
+subsys_initcall(xen_acpi_pad_init);
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 4755b5f..5e36932 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -324,6 +324,22 @@ struct xenpf_cpu_ol {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
=20
+/*
+ * CMD 58 and 59 are reserved for cpu hotadd and memory hotadd,
+ * which are already occupied at Xen hypervisor side.
+ */
+#define XENPF_core_parking     60
+struct xenpf_core_parking {
+	/* IN variables */
+#define XEN_CORE_PARKING_SET   1
+#define XEN_CORE_PARKING_GET   2
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
diff --git a/include/xen/interface/version.h b/include/xen/interface/versio=
n.h
index 7ff6498..96d8d3d 100644
--- a/include/xen/interface/version.h
+++ b/include/xen/interface/version.h
@@ -63,4 +63,19 @@ struct xen_feature_info {
 /* arg =3D=3D xen_domain_handle_t. */
 #define XENVER_guest_handle 8
=20
+/* Check if running on Xen version (major, minor) or later */
+static inline bool
+xen_running_on_version_or_later(unsigned int major, unsigned int minor)
+{
+	unsigned int version;
+
+	if (!xen_domain())
+		return false;
+
+	version =3D HYPERVISOR_xen_version(XENVER_version, NULL);
+	if ((((version >> 16) =3D=3D major) && ((version & 0xffff) >=3D minor)) |=
|
+		((version >> 16) > major))
+		return true;
+	return false;
+}
 #endif /* __XEN_PUBLIC_VERSION_H__ */
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233537BF47SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-acpi-ACPI-PAD-driver.patch"
Content-Description: 0001-Xen-acpi-ACPI-PAD-driver.patch
Content-Disposition: attachment;
	filename="0001-Xen-acpi-ACPI-PAD-driver.patch"; size=8582;
	creation-date="Wed, 07 Nov 2012 17:23:53 GMT";
	modification-date="Thu, 08 Nov 2012 01:12:02 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3NzZiOGYzMTg1OGY5OTIwZTA3MTJhMjIzMmZjNWZiZDg1MDE4NzVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogVGh1LCA4IE5vdiAyMDEyIDA5OjA2OjIyICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IFhlbi9hY3BpOiBBQ1BJIFBBRCBkcml2ZXIKClBBRCBpcyBhY3BpIFByb2Nlc3NvciBBZ2dyZWdh
dG9yIERldmljZSB3aGljaCBwcm92aWRlcyBhIGNvbnRyb2wgcG9pbnQKdGhhdCBlbmFibGVzIHRo
ZSBwbGF0Zm9ybSB0byBwZXJmb3JtIHNwZWNpZmljIHByb2Nlc3NvciBjb25maWd1cmF0aW9uCmFu
ZCBjb250cm9sIHRoYXQgYXBwbGllcyB0byBhbGwgcHJvY2Vzc29ycyBpbiB0aGUgcGxhdGZvcm0u
CgpUaGlzIHBhdGNoIGlzIHRvIGltcGxlbWVudCBYZW4gYWNwaSBwYWQgbG9naWMuIFdoZW4gcnVu
bmluZyB1bmRlciBYZW4KdmlydCBwbGF0Zm9ybSwgbmF0aXZlIHBhZCBkcml2ZXIgd291bGQgbm90
IHdvcmsuIEluc3RlYWQgWGVuIHBhZCBkcml2ZXIsCmEgc2VsZi1jb250YWluZWQgYW5kIHRoaW4g
bG9naWMgbGV2ZWwsIHdvdWxkIHRha2Ugb3ZlciBhY3BpIHBhZCBsb2dpYy4KCldoZW4gYWNwaSBw
YWQgbm90aWZ5IE9TUE0sIHhlbiBwYWQgbG9naWMgaW50ZXJjZXB0IGFuZCBwYXJzZSBfUFVSIG9i
amVjdAp0byBnZXQgdGhlIGV4cGVjdGVkIGlkbGUgY3B1IG51bWJlciwgYW5kIHRoZW4gaHlwZXJj
YWxsIHRvIGh5cGVydmlzb3IuClhlbiBoeXBlcnZpc29yIHdvdWxkIHRoZW4gZG8gdGhlIHJlc3Qg
d29yaywgc2F5LCBjb3JlIHBhcmtpbmcsIHRvIGlkbGUKc3BlY2lmaWMgbnVtYmVyIG9mIGNwdXMg
b24gaXRzIG93biBwb2xpY3kuCgpTaWduZWQtb2ZmLWJ5OiBKYW4gQmV1bGljaCA8SkJldWxpY2hA
c3VzZS5jb20+ClNpZ25lZC1vZmYtYnk6IExpdSBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5j
b20+Ci0tLQogZHJpdmVycy94ZW4vTWFrZWZpbGUgICAgICAgICAgICAgfCAgICAzICstCiBkcml2
ZXJzL3hlbi94ZW4tYWNwaS1wYWQuYyAgICAgICB8ICAxODEgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysKIGluY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oIHwgICAx
NyArKysrCiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UvdmVyc2lvbi5oICB8ICAgMTUgKysrCiA0IGZp
bGVzIGNoYW5nZWQsIDIxNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQogY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMveGVuL3hlbi1hY3BpLXBhZC5jCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy94ZW4vTWFrZWZpbGUgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQppbmRleCAwZTg2MzcwLi4zYzM5
NzE3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3hlbi9N
YWtlZmlsZQpAQCAtMTAsNyArMTAsOCBAQCBDRkxBR1NfZmVhdHVyZXMubwkJCTo9ICQobm9zdGFj
a3ApCiAKIGRvbTAtJChDT05GSUdfUENJKSArPSBwY2kubwogZG9tMC0kKENPTkZJR19VU0JfU1VQ
UE9SVCkgKz0gZGJncC5vCi1kb20wLSQoQ09ORklHX0FDUEkpICs9IGFjcGkubworZG9tMC0kKENP
TkZJR19BQ1BJKSArPSBhY3BpLm8gJCh4ZW4tcGFkLXkpCit4ZW4tcGFkLSQoQ09ORklHX1g4Nikg
Kz0geGVuLWFjcGktcGFkLm8KIGRvbTAtJChDT05GSUdfWDg2KSArPSBwY3B1Lm8KIG9iai0kKENP
TkZJR19YRU5fRE9NMCkJCQkrPSAkKGRvbTAteSkKIG9iai0kKENPTkZJR19CTE9DSykJCQkrPSBi
aW9tZXJnZS5vCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi94ZW4tYWNwaS1wYWQuYyBiL2RyaXZl
cnMveGVuL3hlbi1hY3BpLXBhZC5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAu
LmYyM2VjZjMKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL3hlbi94ZW4tYWNwaS1wYWQuYwpA
QCAtMCwwICsxLDE4MSBAQAorLyoKKyAqIHhlbi1hY3BpLXBhZC5jIC0gWGVuIHBhZCBpbnRlcmZh
Y2UKKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTIsIEludGVsIENvcnBvcmF0aW9uLgorICogICAg
QXV0aG9yOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KKyAqCisgKiBUaGlz
IHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29y
IG1vZGlmeSBpdAorICogdW5kZXIgdGhlIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHRoZSBHTlUg
R2VuZXJhbCBQdWJsaWMgTGljZW5zZSwKKyAqIHZlcnNpb24gMiwgYXMgcHVibGlzaGVkIGJ5IHRo
ZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24uCisgKgorICogVGhpcyBwcm9ncmFtIGlzIGRpc3Ry
aWJ1dGVkIGluIHRoZSBob3BlIGl0IHdpbGwgYmUgdXNlZnVsLCBidXQgV0lUSE9VVAorICogQU5Z
IFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YgTUVSQ0hBTlRB
QklMSVRZIG9yCisgKiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUg
R05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yCisgKiBtb3JlIGRldGFpbHMuCisgKi8KKwor
I2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5j
bHVkZSA8YWNwaS9hY3BpX2J1cy5oPgorI2luY2x1ZGUgPGFjcGkvYWNwaV9kcml2ZXJzLmg+Cisj
aW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNhbGwuaD4KKyNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3Zl
cnNpb24uaD4KKworI2RlZmluZSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX0NMQVNTCSJhY3Bp
X3BhZCIKKyNkZWZpbmUgQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9ERVZJQ0VfTkFNRSAiUHJv
Y2Vzc29yIEFnZ3JlZ2F0b3IiCisjZGVmaW5lIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfTk9U
SUZZIDB4ODAKK3N0YXRpYyBERUZJTkVfTVVURVgoeGVuX2NwdV9sb2NrKTsKKworc3RhdGljIGlu
dCB4ZW5fYWNwaV9wYWRfaWRsZV9jcHVzKHVuc2lnbmVkIGludCBpZGxlX251bXMpCit7CisJc3Ry
dWN0IHhlbl9wbGF0Zm9ybV9vcCBvcDsKKworCW9wLmNtZCA9IFhFTlBGX2NvcmVfcGFya2luZzsK
KwlvcC51LmNvcmVfcGFya2luZy50eXBlID0gWEVOX0NPUkVfUEFSS0lOR19TRVQ7CisJb3AudS5j
b3JlX3BhcmtpbmcuaWRsZV9udW1zID0gaWRsZV9udW1zOworCisJcmV0dXJuIEhZUEVSVklTT1Jf
ZG9tMF9vcCgmb3ApOworfQorCitzdGF0aWMgaW50IHhlbl9hY3BpX3BhZF9pZGxlX2NwdXNfbnVt
KHZvaWQpCit7CisJc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBvcDsKKworCW9wLmNtZCA9IFhFTlBG
X2NvcmVfcGFya2luZzsKKwlvcC51LmNvcmVfcGFya2luZy50eXBlID0gWEVOX0NPUkVfUEFSS0lO
R19HRVQ7CisKKwlyZXR1cm4gSFlQRVJWSVNPUl9kb20wX29wKCZvcCkKKwkgICAgICAgPzogb3Au
dS5jb3JlX3BhcmtpbmcuaWRsZV9udW1zOworfQorCisvKgorICogUXVlcnkgZmlybXdhcmUgaG93
IG1hbnkgQ1BVcyBzaG91bGQgYmUgaWRsZQorICogcmV0dXJuIC0xIG9uIGZhaWx1cmUKKyAqLwor
c3RhdGljIGludCBhY3BpX3BhZF9wdXIoYWNwaV9oYW5kbGUgaGFuZGxlKQoreworCXN0cnVjdCBh
Y3BpX2J1ZmZlciBidWZmZXIgPSB7QUNQSV9BTExPQ0FURV9CVUZGRVIsIE5VTEx9OworCXVuaW9u
IGFjcGlfb2JqZWN0ICpwYWNrYWdlOworCWludCBudW0gPSAtMTsKKworCWlmIChBQ1BJX0ZBSUxV
UkUoYWNwaV9ldmFsdWF0ZV9vYmplY3QoaGFuZGxlLCAiX1BVUiIsIE5VTEwsICZidWZmZXIpKSkK
KwkJcmV0dXJuIG51bTsKKworCWlmICghYnVmZmVyLmxlbmd0aCB8fCAhYnVmZmVyLnBvaW50ZXIp
CisJCXJldHVybiBudW07CisKKwlwYWNrYWdlID0gYnVmZmVyLnBvaW50ZXI7CisKKwlpZiAocGFj
a2FnZS0+dHlwZSA9PSBBQ1BJX1RZUEVfUEFDS0FHRSAmJgorCQlwYWNrYWdlLT5wYWNrYWdlLmNv
dW50ID09IDIgJiYKKwkJcGFja2FnZS0+cGFja2FnZS5lbGVtZW50c1swXS5pbnRlZ2VyLnZhbHVl
ID09IDEpIC8qIHJldiAxICovCisJCW51bSA9IHBhY2thZ2UtPnBhY2thZ2UuZWxlbWVudHNbMV0u
aW50ZWdlci52YWx1ZTsKKworCWtmcmVlKGJ1ZmZlci5wb2ludGVyKTsKKwlyZXR1cm4gbnVtOwor
fQorCisvKiBOb3RpZnkgZmlybXdhcmUgaG93IG1hbnkgQ1BVcyBhcmUgaWRsZSAqLworc3RhdGlj
IHZvaWQgYWNwaV9wYWRfb3N0KGFjcGlfaGFuZGxlIGhhbmRsZSwgaW50IHN0YXQsCisJdWludDMy
X3QgaWRsZV9udW1zKQoreworCXVuaW9uIGFjcGlfb2JqZWN0IHBhcmFtc1szXSA9IHsKKwkJey50
eXBlID0gQUNQSV9UWVBFX0lOVEVHRVIsfSwKKwkJey50eXBlID0gQUNQSV9UWVBFX0lOVEVHRVIs
fSwKKwkJey50eXBlID0gQUNQSV9UWVBFX0JVRkZFUix9LAorCX07CisJc3RydWN0IGFjcGlfb2Jq
ZWN0X2xpc3QgYXJnX2xpc3QgPSB7MywgcGFyYW1zfTsKKworCXBhcmFtc1swXS5pbnRlZ2VyLnZh
bHVlID0gQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9OT1RJRlk7CisJcGFyYW1zWzFdLmludGVn
ZXIudmFsdWUgPSAgc3RhdDsKKwlwYXJhbXNbMl0uYnVmZmVyLmxlbmd0aCA9IDQ7CisJcGFyYW1z
WzJdLmJ1ZmZlci5wb2ludGVyID0gKHZvaWQgKikmaWRsZV9udW1zOworCWFjcGlfZXZhbHVhdGVf
b2JqZWN0KGhhbmRsZSwgIl9PU1QiLCAmYXJnX2xpc3QsIE5VTEwpOworfQorCitzdGF0aWMgdm9p
ZCBhY3BpX3BhZF9oYW5kbGVfbm90aWZ5KGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwlpbnQgaWRs
ZV9udW1zOworCisJbXV0ZXhfbG9jaygmeGVuX2NwdV9sb2NrKTsKKwlpZGxlX251bXMgPSBhY3Bp
X3BhZF9wdXIoaGFuZGxlKTsKKwlpZiAoaWRsZV9udW1zIDwgMCkgeworCQltdXRleF91bmxvY2so
Jnhlbl9jcHVfbG9jayk7CisJCXJldHVybjsKKwl9CisKKwlpZGxlX251bXMgPSB4ZW5fYWNwaV9w
YWRfaWRsZV9jcHVzKGlkbGVfbnVtcykKKwkJICAgID86IHhlbl9hY3BpX3BhZF9pZGxlX2NwdXNf
bnVtKCk7CisJaWYgKGlkbGVfbnVtcyA+PSAwKQorCQlhY3BpX3BhZF9vc3QoaGFuZGxlLCAwLCBp
ZGxlX251bXMpOworCW11dGV4X3VubG9jaygmeGVuX2NwdV9sb2NrKTsKK30KKworc3RhdGljIHZv
aWQgYWNwaV9wYWRfbm90aWZ5KGFjcGlfaGFuZGxlIGhhbmRsZSwgdTMyIGV2ZW50LAorCXZvaWQg
KmRhdGEpCit7CisJc3dpdGNoIChldmVudCkgeworCWNhc2UgQUNQSV9QUk9DRVNTT1JfQUdHUkVH
QVRPUl9OT1RJRlk6CisJCWFjcGlfcGFkX2hhbmRsZV9ub3RpZnkoaGFuZGxlKTsKKwkJYnJlYWs7
CisJZGVmYXVsdDoKKwkJcHJfd2FybigiVW5zdXBwb3J0ZWQgZXZlbnQgWzB4JXhdXG4iLCBldmVu
dCk7CisJCWJyZWFrOworCX0KK30KKworc3RhdGljIGludCBhY3BpX3BhZF9hZGQoc3RydWN0IGFj
cGlfZGV2aWNlICpkZXZpY2UpCit7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3RyY3B5KGFj
cGlfZGV2aWNlX25hbWUoZGV2aWNlKSwgQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9ERVZJQ0Vf
TkFNRSk7CisJc3RyY3B5KGFjcGlfZGV2aWNlX2NsYXNzKGRldmljZSksIEFDUElfUFJPQ0VTU09S
X0FHR1JFR0FUT1JfQ0xBU1MpOworCisJc3RhdHVzID0gYWNwaV9pbnN0YWxsX25vdGlmeV9oYW5k
bGVyKGRldmljZS0+aGFuZGxlLAorCQlBQ1BJX0RFVklDRV9OT1RJRlksIGFjcGlfcGFkX25vdGlm
eSwgZGV2aWNlKTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpCisJCXJldHVybiAtRU5PREVW
OworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgYWNwaV9wYWRfcmVtb3ZlKHN0cnVjdCBh
Y3BpX2RldmljZSAqZGV2aWNlLAorCWludCB0eXBlKQoreworCW11dGV4X2xvY2soJnhlbl9jcHVf
bG9jayk7CisJeGVuX2FjcGlfcGFkX2lkbGVfY3B1cygwKTsKKwltdXRleF91bmxvY2soJnhlbl9j
cHVfbG9jayk7CisKKwlhY3BpX3JlbW92ZV9ub3RpZnlfaGFuZGxlcihkZXZpY2UtPmhhbmRsZSwK
KwkJQUNQSV9ERVZJQ0VfTk9USUZZLCBhY3BpX3BhZF9ub3RpZnkpOworCXJldHVybiAwOworfQor
CitzdGF0aWMgY29uc3Qgc3RydWN0IGFjcGlfZGV2aWNlX2lkIHBhZF9kZXZpY2VfaWRzW10gPSB7
CisJeyJBQ1BJMDAwQyIsIDB9LAorCXsiIiwgMH0sCit9OworCitzdGF0aWMgc3RydWN0IGFjcGlf
ZHJpdmVyIGFjcGlfcGFkX2RyaXZlciA9IHsKKwkubmFtZSA9ICJwcm9jZXNzb3JfYWdncmVnYXRv
ciIsCisJLmNsYXNzID0gQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9DTEFTUywKKwkuaWRzID0g
cGFkX2RldmljZV9pZHMsCisJLm9wcyA9IHsKKwkJLmFkZCA9IGFjcGlfcGFkX2FkZCwKKwkJLnJl
bW92ZSA9IGFjcGlfcGFkX3JlbW92ZSwKKwl9LAorfTsKKworc3RhdGljIGludCBfX2luaXQgeGVu
X2FjcGlfcGFkX2luaXQodm9pZCkKK3sKKwkvKiBPbmx5IERPTTAgaXMgcmVzcG9uc2libGUgZm9y
IFhlbiBhY3BpIHBhZCAqLworCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkpCisJCXJldHVybiAt
RU5PREVWOworCisJLyogT25seSBYZW40LjIgb3IgbGF0ZXIgc3VwcG9ydCBYZW4gYWNwaSBwYWQg
Ki8KKwlpZiAoIXhlbl9ydW5uaW5nX29uX3ZlcnNpb25fb3JfbGF0ZXIoNCwgMikpCisJCXJldHVy
biAtRU5PREVWOworCisJcmV0dXJuIGFjcGlfYnVzX3JlZ2lzdGVyX2RyaXZlcigmYWNwaV9wYWRf
ZHJpdmVyKTsKK30KK3N1YnN5c19pbml0Y2FsbCh4ZW5fYWNwaV9wYWRfaW5pdCk7CmRpZmYgLS1n
aXQgYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaCBiL2luY2x1ZGUveGVuL2ludGVy
ZmFjZS9wbGF0Zm9ybS5oCmluZGV4IDQ3NTViNWYuLjVlMzY5MzIgMTAwNjQ0Ci0tLSBhL2luY2x1
ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCisrKyBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9w
bGF0Zm9ybS5oCkBAIC0zMjQsNiArMzI0LDIyIEBAIHN0cnVjdCB4ZW5wZl9jcHVfb2wgewogfTsK
IERFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbnBmX2NwdV9vbCk7CiAKKy8qCisgKiBDTUQg
NTggYW5kIDU5IGFyZSByZXNlcnZlZCBmb3IgY3B1IGhvdGFkZCBhbmQgbWVtb3J5IGhvdGFkZCwK
KyAqIHdoaWNoIGFyZSBhbHJlYWR5IG9jY3VwaWVkIGF0IFhlbiBoeXBlcnZpc29yIHNpZGUuCisg
Ki8KKyNkZWZpbmUgWEVOUEZfY29yZV9wYXJraW5nICAgICA2MAorc3RydWN0IHhlbnBmX2NvcmVf
cGFya2luZyB7CisJLyogSU4gdmFyaWFibGVzICovCisjZGVmaW5lIFhFTl9DT1JFX1BBUktJTkdf
U0VUICAgMQorI2RlZmluZSBYRU5fQ09SRV9QQVJLSU5HX0dFVCAgIDIKKwl1aW50MzJfdCB0eXBl
OworCS8qIElOIHZhcmlhYmxlczogIHNldCBjcHUgbnVtcyBleHBlY3RlZCB0byBiZSBpZGxlZCAq
LworCS8qIE9VVCB2YXJpYWJsZXM6IGdldCBjcHUgbnVtcyBhY3R1YWxseSBiZSBpZGxlZCAqLwor
CXVpbnQzMl90IGlkbGVfbnVtczsKK307CitERUZJTkVfR1VFU1RfSEFORExFX1NUUlVDVCh4ZW5w
Zl9jb3JlX3BhcmtpbmcpOworCiBzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIHsKIAl1aW50MzJfdCBj
bWQ7CiAJdWludDMyX3QgaW50ZXJmYWNlX3ZlcnNpb247IC8qIFhFTlBGX0lOVEVSRkFDRV9WRVJT
SU9OICovCkBAIC0zNDEsNiArMzU3LDcgQEAgc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCB7CiAJCXN0
cnVjdCB4ZW5wZl9zZXRfcHJvY2Vzc29yX3BtaW5mbyBzZXRfcG1pbmZvOwogCQlzdHJ1Y3QgeGVu
cGZfcGNwdWluZm8gICAgICAgICAgcGNwdV9pbmZvOwogCQlzdHJ1Y3QgeGVucGZfY3B1X29sICAg
ICAgICAgICAgY3B1X29sOworCQlzdHJ1Y3QgeGVucGZfY29yZV9wYXJraW5nICAgICAgY29yZV9w
YXJraW5nOwogCQl1aW50OF90ICAgICAgICAgICAgICAgICAgICAgICAgcGFkWzEyOF07CiAJfSB1
OwogfTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS92ZXJzaW9uLmggYi9pbmNs
dWRlL3hlbi9pbnRlcmZhY2UvdmVyc2lvbi5oCmluZGV4IDdmZjY0OTguLjk2ZDhkM2QgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS92ZXJzaW9uLmgKKysrIGIvaW5jbHVkZS94ZW4v
aW50ZXJmYWNlL3ZlcnNpb24uaApAQCAtNjMsNCArNjMsMTkgQEAgc3RydWN0IHhlbl9mZWF0dXJl
X2luZm8gewogLyogYXJnID09IHhlbl9kb21haW5faGFuZGxlX3QuICovCiAjZGVmaW5lIFhFTlZF
Ul9ndWVzdF9oYW5kbGUgOAogCisvKiBDaGVjayBpZiBydW5uaW5nIG9uIFhlbiB2ZXJzaW9uICht
YWpvciwgbWlub3IpIG9yIGxhdGVyICovCitzdGF0aWMgaW5saW5lIGJvb2wKK3hlbl9ydW5uaW5n
X29uX3ZlcnNpb25fb3JfbGF0ZXIodW5zaWduZWQgaW50IG1ham9yLCB1bnNpZ25lZCBpbnQgbWlu
b3IpCit7CisJdW5zaWduZWQgaW50IHZlcnNpb247CisKKwlpZiAoIXhlbl9kb21haW4oKSkKKwkJ
cmV0dXJuIGZhbHNlOworCisJdmVyc2lvbiA9IEhZUEVSVklTT1JfeGVuX3ZlcnNpb24oWEVOVkVS
X3ZlcnNpb24sIE5VTEwpOworCWlmICgoKCh2ZXJzaW9uID4+IDE2KSA9PSBtYWpvcikgJiYgKCh2
ZXJzaW9uICYgMHhmZmZmKSA+PSBtaW5vcikpIHx8CisJCSgodmVyc2lvbiA+PiAxNikgPiBtYWpv
cikpCisJCXJldHVybiB0cnVlOworCXJldHVybiBmYWxzZTsKK30KICNlbmRpZiAvKiBfX1hFTl9Q
VUJMSUNfVkVSU0lPTl9IX18gKi8KLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC829233537BF47SHSMSX101ccrcorpi_--
