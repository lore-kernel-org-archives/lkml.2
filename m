Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2JYMUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:20:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:55005 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab2JYMUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:20:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,646,1344236400"; 
   d="scan'208,223";a="232379272"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [PATCH 1/2] Xen acpi pad implement
Thread-Index: Ac2yqwziy4ng7bX0TLqjDy8/5OpTbg==
Date: Thu, 25 Oct 2012 12:19:59 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233537157FSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233537157FSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From f233ad06cf924116693d7d38be9ae9d8c11f8a9b Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 26 Oct 2012 02:32:48 +0800
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
 drivers/xen/xen_acpi_pad.c       |  173 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   17 ++++
 3 files changed, 191 insertions(+), 0 deletions(-)
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
index 0000000..e7b7dca
--- /dev/null
+++ b/drivers/xen/xen_acpi_pad.c
@@ -0,0 +1,173 @@
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
+	num_cpus =3D xen_acpi_pad_pur(handle);
+	if (num_cpus < 0)
+		return;
+
+	ret =3D xen_acpi_pad_idle_cpus(&num_cpus);
+	if (ret)
+		return;
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

--_002_DE8DF0795D48FD4CA783C40EC829233537157FSHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-acpi-pad-implement.patch"
Content-Description: 0001-Xen-acpi-pad-implement.patch
Content-Disposition: attachment;
	filename="0001-Xen-acpi-pad-implement.patch"; size=7390;
	creation-date="Thu, 25 Oct 2012 12:15:46 GMT";
	modification-date="Thu, 25 Oct 2012 20:07:22 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmMjMzYWQwNmNmOTI0MTE2NjkzZDdkMzhiZTlhZTlkOGMxMWY4YTliIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAyNiBPY3QgMjAxMiAwMjozMjo0OCArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
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
ICAxICsKIGRyaXZlcnMveGVuL3hlbl9hY3BpX3BhZC5jICAgICAgIHwgIDE3MyArKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKwogaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRm
b3JtLmggfCAgIDE3ICsrKysKIDMgZmlsZXMgY2hhbmdlZCwgMTkxIGluc2VydGlvbnMoKyksIDAg
ZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy94ZW4veGVuX2FjcGlfcGFk
LmMKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9NYWtlZmlsZSBiL2RyaXZlcnMveGVuL01ha2Vm
aWxlCmluZGV4IDBlODYzNzAuLmEyYWY2MjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMveGVuL01ha2Vm
aWxlCisrKyBiL2RyaXZlcnMveGVuL01ha2VmaWxlCkBAIC0yOSw2ICsyOSw3IEBAIG9iai0kKENP
TkZJR19YRU5fTUNFX0xPRykJCSs9IG1jZWxvZy5vCiBvYmotJChDT05GSUdfWEVOX1BDSURFVl9C
QUNLRU5EKQkrPSB4ZW4tcGNpYmFjay8KIG9iai0kKENPTkZJR19YRU5fUFJJVkNNRCkJCSs9IHhl
bi1wcml2Y21kLm8KIG9iai0kKENPTkZJR19YRU5fQUNQSV9QUk9DRVNTT1IpCSs9IHhlbi1hY3Bp
LXByb2Nlc3Nvci5vCitvYmotJChDT05GSUdfWEVOX0RPTTApCQkJKz0geGVuX2FjcGlfcGFkLm8K
IHhlbi1ldnRjaG4teQkJCQk6PSBldnRjaG4ubwogeGVuLWdudGRldi15CQkJCTo9IGdudGRldi5v
CiB4ZW4tZ250YWxsb2MteQkJCQk6PSBnbnRhbGxvYy5vCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hl
bi94ZW5fYWNwaV9wYWQuYyBiL2RyaXZlcnMveGVuL3hlbl9hY3BpX3BhZC5jCm5ldyBmaWxlIG1v
ZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmU3YjdkY2EKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2
ZXJzL3hlbi94ZW5fYWNwaV9wYWQuYwpAQCAtMCwwICsxLDE3MyBAQAorLyoKKyAqIHhlbl9hY3Bp
X3BhZC5jIC0gWGVuIHBhZCBpbnRlcmZhY2UKKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTIsIElu
dGVsIENvcnBvcmF0aW9uLgorICogICAgQXV0aG9yOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1
QGludGVsLmNvbT4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNh
biByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeSBpdAorICogdW5kZXIgdGhlIHRlcm1zIGFu
ZCBjb25kaXRpb25zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSwKKyAqIHZlcnNp
b24gMiwgYXMgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24uCisgKgor
ICogVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIGl0IHdpbGwgYmUgdXNl
ZnVsLCBidXQgV0lUSE9VVAorICogQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxp
ZWQgd2FycmFudHkgb2YgTUVSQ0hBTlRBQklMSVRZIG9yCisgKiBGSVRORVNTIEZPUiBBIFBBUlRJ
Q1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yCisg
KiBtb3JlIGRldGFpbHMuCisgKi8KKworI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1
ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8YWNwaS9hY3BpX2J1cy5oPgorI2luY2x1ZGUg
PGFjcGkvYWNwaV9kcml2ZXJzLmg+CisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNhbGwuaD4KKwor
I2lmIGRlZmluZWQoQ09ORklHX0FDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1IpIHx8IFwKKwkJZGVm
aW5lZChDT05GSUdfQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9NT0RVTEUpCisKKyNkZWZpbmUg
QUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9DTEFTUwkiYWNwaV9wYWQiCisjZGVmaW5lIEFDUElf
UFJPQ0VTU09SX0FHR1JFR0FUT1JfREVWSUNFX05BTUUgIlByb2Nlc3NvciBBZ2dyZWdhdG9yIgor
I2RlZmluZSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX05PVElGWSAweDgwCisKK3N0YXRpYyBp
bnQgeGVuX2FjcGlfcGFkX2lkbGVfY3B1cyhpbnQgKm51bV9jcHVzKQoreworCWludCByZXQ7CisK
KwlzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9wID0geworCQkuY21kID0gWEVOUEZfY29yZV9wYXJr
aW5nLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24gPSBYRU5QRl9JTlRFUkZBQ0VfVkVSU0lPTiwKKwl9
OworCisJLyogc2V0IGNwdSBudW1zIGV4cGVjdGVkIHRvIGJlIGlkbGVkICovCisJb3AudS5jb3Jl
X3BhcmtpbmcudHlwZSA9IFhFTl9DT1JFX1BBUktJTkdfU0VUOworCW9wLnUuY29yZV9wYXJraW5n
LmlkbGVfbnVtcyA9ICh1aW50MzJfdCkqbnVtX2NwdXM7CisJcmV0ID0gSFlQRVJWSVNPUl9kb20w
X29wKCZvcCk7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKworCS8qCisJICogZ2V0IGNwdSBu
dW1zIGFjdHVhbGx5IGJlIGlkbGVkCisJICogY2Fubm90IGdldCBpdCBieSB1c2luZyBoeXBlcmNh
bGwgb25jZSAoc2hhcmVkIHdpdGggX1NFVCkKKwkgKiBiZWNhdXNlIG9mIHRoZSBjaGFyYWN0ZXJp
c3RpYyBvZiBYZW4gY29udGludWVfaHlwZXJjYWxsX29uX2NwdQorCSAqLworCW9wLnUuY29yZV9w
YXJraW5nLnR5cGUgPSBYRU5fQ09SRV9QQVJLSU5HX0dFVDsKKwlyZXQgPSBIWVBFUlZJU09SX2Rv
bTBfb3AoJm9wKTsKKwlpZiAocmV0KQorCQlyZXR1cm4gcmV0OworCisJKm51bV9jcHVzID0gb3Au
dS5jb3JlX3BhcmtpbmcuaWRsZV9udW1zOworCXJldHVybiAwOworfQorCisvKgorICogUXVlcnkg
ZmlybXdhcmUgaG93IG1hbnkgQ1BVcyBzaG91bGQgYmUgaWRsZQorICogcmV0dXJuIC0xIG9uIGZh
aWx1cmUKKyAqLworc3RhdGljIGludCB4ZW5fYWNwaV9wYWRfcHVyKGFjcGlfaGFuZGxlIGhhbmRs
ZSkKK3sKKwlzdHJ1Y3QgYWNwaV9idWZmZXIgYnVmZmVyID0ge0FDUElfQUxMT0NBVEVfQlVGRkVS
LCBOVUxMfTsKKwl1bmlvbiBhY3BpX29iamVjdCAqcGFja2FnZTsKKwlpbnQgbnVtID0gLTE7CisK
KwlpZiAoQUNQSV9GQUlMVVJFKGFjcGlfZXZhbHVhdGVfb2JqZWN0KGhhbmRsZSwgIl9QVVIiLCBO
VUxMLCAmYnVmZmVyKSkpCisJCXJldHVybiBudW07CisKKwlpZiAoIWJ1ZmZlci5sZW5ndGggfHwg
IWJ1ZmZlci5wb2ludGVyKQorCQlyZXR1cm4gbnVtOworCisJcGFja2FnZSA9IGJ1ZmZlci5wb2lu
dGVyOworCisJaWYgKHBhY2thZ2UtPnR5cGUgPT0gQUNQSV9UWVBFX1BBQ0tBR0UgJiYKKwkJcGFj
a2FnZS0+cGFja2FnZS5jb3VudCA9PSAyICYmCisJCXBhY2thZ2UtPnBhY2thZ2UuZWxlbWVudHNb
MF0uaW50ZWdlci52YWx1ZSA9PSAxKSAvKiByZXYgMSAqLworCisJCW51bSA9IHBhY2thZ2UtPnBh
Y2thZ2UuZWxlbWVudHNbMV0uaW50ZWdlci52YWx1ZTsKKworCWtmcmVlKGJ1ZmZlci5wb2ludGVy
KTsKKwlyZXR1cm4gbnVtOworfQorCisvKiBOb3RpZnkgZmlybXdhcmUgaG93IG1hbnkgQ1BVcyBh
cmUgaWRsZSAqLworc3RhdGljIHZvaWQgeGVuX2FjcGlfcGFkX29zdChhY3BpX2hhbmRsZSBoYW5k
bGUsIGludCBzdGF0LAorCXVpbnQzMl90IGlkbGVfY3B1cykKK3sKKwl1bmlvbiBhY3BpX29iamVj
dCBwYXJhbXNbM10gPSB7CisJCXsudHlwZSA9IEFDUElfVFlQRV9JTlRFR0VSLH0sCisJCXsudHlw
ZSA9IEFDUElfVFlQRV9JTlRFR0VSLH0sCisJCXsudHlwZSA9IEFDUElfVFlQRV9CVUZGRVIsfSwK
Kwl9OworCXN0cnVjdCBhY3BpX29iamVjdF9saXN0IGFyZ19saXN0ID0gezMsIHBhcmFtc307CisK
KwlwYXJhbXNbMF0uaW50ZWdlci52YWx1ZSA9IEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfTk9U
SUZZOworCXBhcmFtc1sxXS5pbnRlZ2VyLnZhbHVlID0gIHN0YXQ7CisJcGFyYW1zWzJdLmJ1ZmZl
ci5sZW5ndGggPSA0OworCXBhcmFtc1syXS5idWZmZXIucG9pbnRlciA9ICh2b2lkICopJmlkbGVf
Y3B1czsKKwlhY3BpX2V2YWx1YXRlX29iamVjdChoYW5kbGUsICJfT1NUIiwgJmFyZ19saXN0LCBO
VUxMKTsKK30KKworc3RhdGljIHZvaWQgeGVuX2FjcGlfcGFkX2hhbmRsZV9ub3RpZnkoYWNwaV9o
YW5kbGUgaGFuZGxlKQoreworCWludCByZXQsIG51bV9jcHVzOworCisJbnVtX2NwdXMgPSB4ZW5f
YWNwaV9wYWRfcHVyKGhhbmRsZSk7CisJaWYgKG51bV9jcHVzIDwgMCkKKwkJcmV0dXJuOworCisJ
cmV0ID0geGVuX2FjcGlfcGFkX2lkbGVfY3B1cygmbnVtX2NwdXMpOworCWlmIChyZXQpCisJCXJl
dHVybjsKKworCXhlbl9hY3BpX3BhZF9vc3QoaGFuZGxlLCAwLCBudW1fY3B1cyk7Cit9CisKK3N0
YXRpYyB2b2lkIHhlbl9hY3BpX3BhZF9ub3RpZnkoYWNwaV9oYW5kbGUgaGFuZGxlLCB1MzIgZXZl
bnQsCisJdm9pZCAqZGF0YSkKK3sKKwlzd2l0Y2ggKGV2ZW50KSB7CisJY2FzZSBBQ1BJX1BST0NF
U1NPUl9BR0dSRUdBVE9SX05PVElGWToKKwkJeGVuX2FjcGlfcGFkX2hhbmRsZV9ub3RpZnkoaGFu
ZGxlKTsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJcHJfd2FybigiVW5zdXBwb3J0ZWQgZXZlbnQg
WzB4JXhdXG4iLCBldmVudCk7CisJCWJyZWFrOworCX0KK30KKworc3RhdGljIGludCB4ZW5fYWNw
aV9wYWRfYWRkKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlKQoreworCWFjcGlfc3RhdHVzIHN0
YXR1czsKKworCXN0cmNweShhY3BpX2RldmljZV9uYW1lKGRldmljZSksIEFDUElfUFJPQ0VTU09S
X0FHR1JFR0FUT1JfREVWSUNFX05BTUUpOworCXN0cmNweShhY3BpX2RldmljZV9jbGFzcyhkZXZp
Y2UpLCBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX0NMQVNTKTsKKworCXN0YXR1cyA9IGFjcGlf
aW5zdGFsbF9ub3RpZnlfaGFuZGxlcihkZXZpY2UtPmhhbmRsZSwKKwkJIEFDUElfREVWSUNFX05P
VElGWSwgeGVuX2FjcGlfcGFkX25vdGlmeSwgZGV2aWNlKTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0
YXR1cykpCisJCXJldHVybiAtRU5PREVWOworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBjb25z
dCBzdHJ1Y3QgYWNwaV9kZXZpY2VfaWQgcGFkX2RldmljZV9pZHNbXSA9IHsKKwl7IkFDUEkwMDBD
IiwgMH0sCisJeyIiLCAwfSwKK307CisKK3N0YXRpYyBzdHJ1Y3QgYWNwaV9kcml2ZXIgeGVuX2Fj
cGlfcGFkX2RyaXZlciA9IHsKKwkubmFtZSA9ICJwcm9jZXNzb3JfYWdncmVnYXRvciIsCisJLmNs
YXNzID0gQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9DTEFTUywKKwkuaWRzID0gcGFkX2Rldmlj
ZV9pZHMsCisJLm9wcyA9IHsKKwkJLmFkZCA9IHhlbl9hY3BpX3BhZF9hZGQsCisJfSwKK307CisK
K3N0YXRpYyBpbnQgX19pbml0IHhlbl9hY3BpX3BhZF9pbml0KHZvaWQpCit7CisJLyogT25seSBE
T00wIGlzIHJlc3BvbnNpYmxlIGZvciBYZW4gYWNwaSBwYWQgKi8KKwlpZiAoeGVuX2luaXRpYWxf
ZG9tYWluKCkpCisJCXJldHVybiBhY3BpX2J1c19yZWdpc3Rlcl9kcml2ZXIoJnhlbl9hY3BpX3Bh
ZF9kcml2ZXIpOworCisJcmV0dXJuIC1FTk9ERVY7Cit9CitzdWJzeXNfaW5pdGNhbGwoeGVuX2Fj
cGlfcGFkX2luaXQpOworCisjZW5kaWYKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFj
ZS9wbGF0Zm9ybS5oIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKaW5kZXggNDc1
NWI1Zi4uMGY0NDM3NiAxMDA2NDQKLS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3Jt
LmgKKysrIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKQEAgLTMyNCw2ICszMjQs
MjIgQEAgc3RydWN0IHhlbnBmX2NwdV9vbCB7CiB9OwogREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJV
Q1QoeGVucGZfY3B1X29sKTsKIAorLyoKKyAqIENNRCA1OCBhbmQgNTkgYXJlIHJlc2VydmVkIGZv
ciBjcHUgaG90YWRkIGFuZCBtZW1vcnkgaG90YWRkLAorICogd2hpY2ggYWxyZWFkeSBvY2N1cGll
ZCBhdCBYZW4gaHlwZXJ2aXNvciBzaWRlLgorICovCisjZGVmaW5lIFhFTlBGX2NvcmVfcGFya2lu
Zwk2MAorc3RydWN0IHhlbnBmX2NvcmVfcGFya2luZyB7CisJLyogSU4gdmFyaWFibGVzICovCisj
ZGVmaW5lIFhFTl9DT1JFX1BBUktJTkdfU0VUCTEKKyNkZWZpbmUgWEVOX0NPUkVfUEFSS0lOR19H
RVQJMgorCXVpbnQzMl90IHR5cGU7CisJLyogSU4gdmFyaWFibGVzOiAgc2V0IGNwdSBudW1zIGV4
cGVjdGVkIHRvIGJlIGlkbGVkICovCisJLyogT1VUIHZhcmlhYmxlczogZ2V0IGNwdSBudW1zIGFj
dHVhbGx5IGJlIGlkbGVkICovCisJdWludDMyX3QgaWRsZV9udW1zOworfTsKK0RFRklORV9HVUVT
VF9IQU5ETEVfU1RSVUNUKHhlbnBmX2NvcmVfcGFya2luZyk7CisKIHN0cnVjdCB4ZW5fcGxhdGZv
cm1fb3AgewogCXVpbnQzMl90IGNtZDsKIAl1aW50MzJfdCBpbnRlcmZhY2VfdmVyc2lvbjsgLyog
WEVOUEZfSU5URVJGQUNFX1ZFUlNJT04gKi8KQEAgLTM0MSw2ICszNTcsNyBAQCBzdHJ1Y3QgeGVu
X3BsYXRmb3JtX29wIHsKIAkJc3RydWN0IHhlbnBmX3NldF9wcm9jZXNzb3JfcG1pbmZvIHNldF9w
bWluZm87CiAJCXN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAgICAgICAgICBwY3B1X2luZm87CiAJCXN0
cnVjdCB4ZW5wZl9jcHVfb2wgICAgICAgICAgICBjcHVfb2w7CisJCXN0cnVjdCB4ZW5wZl9jb3Jl
X3BhcmtpbmcgICAgICBjb3JlX3Bhcmtpbmc7CiAJCXVpbnQ4X3QgICAgICAgICAgICAgICAgICAg
ICAgICBwYWRbMTI4XTsKIAl9IHU7CiB9OwotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC829233537157FSHSMSX101ccrcorpi_--
