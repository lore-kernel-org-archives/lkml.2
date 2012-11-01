Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2KAGfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:35:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:9487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab2KAGfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:35:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,691,1344236400"; 
   d="scan'208,223";a="213837549"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <jbeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNs7Z0Ti91BiFLfUibRvXA4zlK85fUjX6A
Date: Thu, 1 Nov 2012 06:34:45 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233537157F@SHSMSX101.ccr.corp.intel.com>
 <5089676602000078000A4928@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923353723C7@SHSMSX101.ccr.corp.intel.com>
 <508A89CB020000780008E6ED@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
In-Reply-To: <20121026201409.GF2708@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335377346SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335377346SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thanks! updated as attached.

Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>From f514b97628945cfac00efb0d456f133d44754c9d Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Thu, 1 Nov 2012 21:02:36 +0800
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
 drivers/xen/xen_acpi_pad.c       |  206 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   17 +++
 3 files changed, 224 insertions(+), 0 deletions(-)
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
index 0000000..e8c26a4
--- /dev/null
+++ b/drivers/xen/xen_acpi_pad.c
@@ -0,0 +1,206 @@
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
+#include <xen/interface/version.h>
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
+	int ret =3D -ENOSYS;
+	unsigned int version =3D HYPERVISOR_xen_version(XENVER_version, NULL);
+	unsigned int major =3D version >> 16;
+	unsigned int minor =3D version & 0xffff;
+
+	/* Only DOM0 is responsible for Xen acpi pad */
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	/* Only Xen4.2 or later support Xen acpi pad */
+	if (((major =3D=3D 4) && (minor >=3D 2)) || (major > 4))
+		ret =3D acpi_bus_register_driver(&xen_acpi_pad_driver);
+
+	return ret;
+}
+subsys_initcall(xen_acpi_pad_init);
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 4755b5f..a3be54c 100644
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

--_002_DE8DF0795D48FD4CA783C40EC8292335377346SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-acpi-pad-implement.patch"
Content-Description: 0001-Xen-acpi-pad-implement.patch
Content-Disposition: attachment;
	filename="0001-Xen-acpi-pad-implement.patch"; size=8184;
	creation-date="Thu, 01 Nov 2012 06:25:57 GMT";
	modification-date="Thu, 01 Nov 2012 13:29:12 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmNTE0Yjk3NjI4OTQ1Y2ZhYzAwZWZiMGQ0NTZmMTMzZDQ0NzU0YzlkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogVGh1LCAxIE5vdiAyMDEyIDIxOjAyOjM2ICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IFhlbiBhY3BpIHBhZCBpbXBsZW1lbnQKClBBRCBpcyBhY3BpIFByb2Nlc3NvciBBZ2dyZWdhdG9y
IERldmljZSB3aGljaCBwcm92aWRlcyBhIGNvbnRyb2wgcG9pbnQKdGhhdCBlbmFibGVzIHRoZSBw
bGF0Zm9ybSB0byBwZXJmb3JtIHNwZWNpZmljIHByb2Nlc3NvciBjb25maWd1cmF0aW9uCmFuZCBj
b250cm9sIHRoYXQgYXBwbGllcyB0byBhbGwgcHJvY2Vzc29ycyBpbiB0aGUgcGxhdGZvcm0uCgpU
aGlzIHBhdGNoIGlzIHRvIGltcGxlbWVudCBYZW4gYWNwaSBwYWQgbG9naWMuIFdoZW4gcnVubmlu
ZyB1bmRlciBYZW4KdmlydCBwbGF0Zm9ybSwgbmF0aXZlIHBhZCBkcml2ZXIgd291bGQgbm90IHdv
cmsuIEluc3RlYWQgWGVuIHBhZCBkcml2ZXIsCmEgc2VsZi1jb250YWluZWQgYW5kIHZlcnkgdGhp
biBsb2dpYyBsZXZlbCwgd291bGQgdGFrZSBvdmVyIGFjcGkgcGFkIHN0YWZmLgpXaGVuIGFjcGkg
cGFkIG5vdGlmeSBPU1BNLCB4ZW4gcGFkIGxvZ2ljIGludGVyY2VwdCBhbmQgcGFyc2UgX1BVUiBv
YmplY3QKYW5kIHRoZW4gaHlwZXJjYWxsIHRvIGh5ZXJ2aXNvciBmb3IgdGhlIHJlc3Qgd29yaywg
c2F5LCBjb3JlIHBhcmtpbmcuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcu
bGl1QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hlbi9NYWtlZmlsZSAgICAgICAgICAgICB8ICAg
IDEgKwogZHJpdmVycy94ZW4veGVuX2FjcGlfcGFkLmMgICAgICAgfCAgMjA2ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrCiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZv
cm0uaCB8ICAgMTcgKysrCiAzIGZpbGVzIGNoYW5nZWQsIDIyNCBpbnNlcnRpb25zKCspLCAwIGRl
bGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMveGVuL3hlbl9hY3BpX3BhZC5j
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vTWFrZWZpbGUgYi9kcml2ZXJzL3hlbi9NYWtlZmls
ZQppbmRleCAwZTg2MzcwLi5hMmFmNjIyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9NYWtlZmls
ZQorKysgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQpAQCAtMjksNiArMjksNyBAQCBvYmotJChDT05G
SUdfWEVOX01DRV9MT0cpCQkrPSBtY2Vsb2cubwogb2JqLSQoQ09ORklHX1hFTl9QQ0lERVZfQkFD
S0VORCkJKz0geGVuLXBjaWJhY2svCiBvYmotJChDT05GSUdfWEVOX1BSSVZDTUQpCQkrPSB4ZW4t
cHJpdmNtZC5vCiBvYmotJChDT05GSUdfWEVOX0FDUElfUFJPQ0VTU09SKQkrPSB4ZW4tYWNwaS1w
cm9jZXNzb3Iubworb2JqLSQoQ09ORklHX1hFTl9ET00wKQkJCSs9IHhlbl9hY3BpX3BhZC5vCiB4
ZW4tZXZ0Y2huLXkJCQkJOj0gZXZ0Y2huLm8KIHhlbi1nbnRkZXYteQkJCQk6PSBnbnRkZXYubwog
eGVuLWdudGFsbG9jLXkJCQkJOj0gZ250YWxsb2MubwpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4v
eGVuX2FjcGlfcGFkLmMgYi9kcml2ZXJzL3hlbi94ZW5fYWNwaV9wYWQuYwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwLi5lOGMyNmE0Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy94ZW4veGVuX2FjcGlfcGFkLmMKQEAgLTAsMCArMSwyMDYgQEAKKy8qCisgKiB4ZW5fYWNwaV9w
YWQuYyAtIFhlbiBwYWQgaW50ZXJmYWNlCisgKgorICogQ29weXJpZ2h0IChjKSAyMDEyLCBJbnRl
bCBDb3Jwb3JhdGlvbi4KKyAqICAgIEF1dGhvcjogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBp
bnRlbC5jb20+CisgKgorICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4g
cmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkgaXQKKyAqIHVuZGVyIHRoZSB0ZXJtcyBhbmQg
Y29uZGl0aW9ucyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UsCisgKiB2ZXJzaW9u
IDIsIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLgorICoKKyAq
IFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSBpdCB3aWxsIGJlIHVzZWZ1
bCwgYnV0IFdJVEhPVVQKKyAqIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVk
IHdhcnJhbnR5IG9mIE1FUkNIQU5UQUJJTElUWSBvcgorICogRklUTkVTUyBGT1IgQSBQQVJUSUNV
TEFSIFBVUlBPU0UuICBTZWUgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvcgorICog
bW9yZSBkZXRhaWxzLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNpbmNsdWRl
IDxsaW51eC90eXBlcy5oPgorI2luY2x1ZGUgPGFjcGkvYWNwaV9idXMuaD4KKyNpbmNsdWRlIDxh
Y3BpL2FjcGlfZHJpdmVycy5oPgorI2luY2x1ZGUgPGFzbS94ZW4vaHlwZXJjYWxsLmg+CisjaW5j
bHVkZSA8eGVuL2ludGVyZmFjZS92ZXJzaW9uLmg+CisKKyNkZWZpbmUgQUNQSV9QUk9DRVNTT1Jf
QUdHUkVHQVRPUl9DTEFTUwkiYWNwaV9wYWQiCisjZGVmaW5lIEFDUElfUFJPQ0VTU09SX0FHR1JF
R0FUT1JfREVWSUNFX05BTUUgIlByb2Nlc3NvciBBZ2dyZWdhdG9yIgorI2RlZmluZSBBQ1BJX1BS
T0NFU1NPUl9BR0dSRUdBVE9SX05PVElGWSAweDgwCisKK3N0YXRpYyBERUZJTkVfTVVURVgoeGVu
X3BhZF9sb2NrKTsKKworc3RhdGljIGludCB4ZW5fcGFkX3NldF9pZGxlX2NwdXMoaW50IG51bV9j
cHVzKQoreworCXN0cnVjdCB4ZW5fcGxhdGZvcm1fb3Agb3A7CisKKwlpZiAobnVtX2NwdXMgPCAw
KQorCQlyZXR1cm4gLUVJTlZBTDsKKworCS8qIHNldCBjcHUgbnVtcyBleHBlY3RlZCB0byBiZSBp
ZGxlZCAqLworCW9wLmNtZCA9IFhFTlBGX2NvcmVfcGFya2luZzsKKwlvcC51LmNvcmVfcGFya2lu
Zy50eXBlID0gWEVOX0NPUkVfUEFSS0lOR19TRVQ7CisJb3AudS5jb3JlX3BhcmtpbmcuaWRsZV9u
dW1zID0gbnVtX2NwdXM7CisKKwlyZXR1cm4gSFlQRVJWSVNPUl9kb20wX29wKCZvcCk7Cit9CisK
Ky8qCisgKiBDYW5ub3QgZ2V0IGlkbGUgY3B1cyBieSB1c2luZyBoeXBlcmNhbGwgb25jZSAoc2hh
cmVkIHdpdGggX1NFVCkKKyAqIGJlY2F1c2Ugb2YgdGhlIGNoYXJhY3RlcmlzdGljIG9mIFhlbiBj
b250aW51ZV9oeXBlcmNhbGxfb25fY3B1CisgKi8KK3N0YXRpYyBpbnQgeGVuX3BhZF9nZXRfaWRs
ZV9jcHVzKHZvaWQpCit7CisJaW50IHJldDsKKwlzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIG9wOwor
CisJLyogZ2V0IGNwdSBudW1zIGFjdHVhbGx5IGJlIGlkbGVkICovCisJb3AuY21kID0gWEVOUEZf
Y29yZV9wYXJraW5nOworCW9wLnUuY29yZV9wYXJraW5nLnR5cGUgPSBYRU5fQ09SRV9QQVJLSU5H
X0dFVDsKKwlyZXQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwlpZiAocmV0IDwgMCkKKwkJ
cmV0dXJuIHJldDsKKworCXJldHVybiBvcC51LmNvcmVfcGFya2luZy5pZGxlX251bXM7Cit9CisK
Ky8qCisgKiBRdWVyeSBmaXJtd2FyZSBob3cgbWFueSBDUFVzIHNob3VsZCBiZSBpZGxlCisgKiBy
ZXR1cm4gLTEgb24gZmFpbHVyZQorICovCitzdGF0aWMgaW50IHhlbl9hY3BpX3BhZF9wdXIoYWNw
aV9oYW5kbGUgaGFuZGxlKQoreworCXN0cnVjdCBhY3BpX2J1ZmZlciBidWZmZXIgPSB7QUNQSV9B
TExPQ0FURV9CVUZGRVIsIE5VTEx9OworCXVuaW9uIGFjcGlfb2JqZWN0ICpwYWNrYWdlOworCWlu
dCBudW0gPSAtMTsKKworCWlmIChBQ1BJX0ZBSUxVUkUoYWNwaV9ldmFsdWF0ZV9vYmplY3QoaGFu
ZGxlLCAiX1BVUiIsIE5VTEwsICZidWZmZXIpKSkKKwkJcmV0dXJuIG51bTsKKworCWlmICghYnVm
ZmVyLmxlbmd0aCB8fCAhYnVmZmVyLnBvaW50ZXIpCisJCXJldHVybiBudW07CisKKwlwYWNrYWdl
ID0gYnVmZmVyLnBvaW50ZXI7CisKKwlpZiAocGFja2FnZS0+dHlwZSA9PSBBQ1BJX1RZUEVfUEFD
S0FHRSAmJgorCQlwYWNrYWdlLT5wYWNrYWdlLmNvdW50ID09IDIgJiYKKwkJcGFja2FnZS0+cGFj
a2FnZS5lbGVtZW50c1swXS5pbnRlZ2VyLnZhbHVlID09IDEpIC8qIHJldiAxICovCisKKwkJbnVt
ID0gcGFja2FnZS0+cGFja2FnZS5lbGVtZW50c1sxXS5pbnRlZ2VyLnZhbHVlOworCisJa2ZyZWUo
YnVmZmVyLnBvaW50ZXIpOworCXJldHVybiBudW07Cit9CisKKy8qIE5vdGlmeSBmaXJtd2FyZSBo
b3cgbWFueSBDUFVzIGFyZSBpZGxlICovCitzdGF0aWMgdm9pZCB4ZW5fYWNwaV9wYWRfb3N0KGFj
cGlfaGFuZGxlIGhhbmRsZSwgaW50IHN0YXQsCisJdWludDMyX3QgaWRsZV9jcHVzKQoreworCXVu
aW9uIGFjcGlfb2JqZWN0IHBhcmFtc1szXSA9IHsKKwkJey50eXBlID0gQUNQSV9UWVBFX0lOVEVH
RVIsfSwKKwkJey50eXBlID0gQUNQSV9UWVBFX0lOVEVHRVIsfSwKKwkJey50eXBlID0gQUNQSV9U
WVBFX0JVRkZFUix9LAorCX07CisJc3RydWN0IGFjcGlfb2JqZWN0X2xpc3QgYXJnX2xpc3QgPSB7
MywgcGFyYW1zfTsKKworCXBhcmFtc1swXS5pbnRlZ2VyLnZhbHVlID0gQUNQSV9QUk9DRVNTT1Jf
QUdHUkVHQVRPUl9OT1RJRlk7CisJcGFyYW1zWzFdLmludGVnZXIudmFsdWUgPSAgc3RhdDsKKwlw
YXJhbXNbMl0uYnVmZmVyLmxlbmd0aCA9IDQ7CisJcGFyYW1zWzJdLmJ1ZmZlci5wb2ludGVyID0g
KHZvaWQgKikmaWRsZV9jcHVzOworCWFjcGlfZXZhbHVhdGVfb2JqZWN0KGhhbmRsZSwgIl9PU1Qi
LCAmYXJnX2xpc3QsIE5VTEwpOworfQorCitzdGF0aWMgdm9pZCB4ZW5fYWNwaV9wYWRfaGFuZGxl
X25vdGlmeShhY3BpX2hhbmRsZSBoYW5kbGUpCit7CisJaW50IG51bV9jcHVzOworCisJbnVtX2Nw
dXMgPSB4ZW5fYWNwaV9wYWRfcHVyKGhhbmRsZSk7CisJaWYgKG51bV9jcHVzIDwgMCkKKwkJcmV0
dXJuOworCisJbXV0ZXhfbG9jaygmeGVuX3BhZF9sb2NrKTsKKwlpZiAoeGVuX3BhZF9zZXRfaWRs
ZV9jcHVzKG51bV9jcHVzKSkgeworCQltdXRleF91bmxvY2soJnhlbl9wYWRfbG9jayk7CisJCXJl
dHVybjsKKwl9CisKKwludW1fY3B1cyA9IHhlbl9wYWRfZ2V0X2lkbGVfY3B1cygpOworCWlmIChu
dW1fY3B1cyA8IDApIHsKKwkJbXV0ZXhfdW5sb2NrKCZ4ZW5fcGFkX2xvY2spOworCQlyZXR1cm47
CisJfQorCW11dGV4X3VubG9jaygmeGVuX3BhZF9sb2NrKTsKKworCXhlbl9hY3BpX3BhZF9vc3Qo
aGFuZGxlLCAwLCBudW1fY3B1cyk7Cit9CisKK3N0YXRpYyB2b2lkIHhlbl9hY3BpX3BhZF9ub3Rp
ZnkoYWNwaV9oYW5kbGUgaGFuZGxlLCB1MzIgZXZlbnQsCisJdm9pZCAqZGF0YSkKK3sKKwlzd2l0
Y2ggKGV2ZW50KSB7CisJY2FzZSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX05PVElGWToKKwkJ
eGVuX2FjcGlfcGFkX2hhbmRsZV9ub3RpZnkoaGFuZGxlKTsKKwkJYnJlYWs7CisJZGVmYXVsdDoK
KwkJcHJfd2FybigiVW5zdXBwb3J0ZWQgZXZlbnQgWzB4JXhdXG4iLCBldmVudCk7CisJCWJyZWFr
OworCX0KK30KKworc3RhdGljIGludCB4ZW5fYWNwaV9wYWRfYWRkKHN0cnVjdCBhY3BpX2Rldmlj
ZSAqZGV2aWNlKQoreworCWFjcGlfc3RhdHVzIHN0YXR1czsKKworCXN0cmNweShhY3BpX2Rldmlj
ZV9uYW1lKGRldmljZSksIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfREVWSUNFX05BTUUpOwor
CXN0cmNweShhY3BpX2RldmljZV9jbGFzcyhkZXZpY2UpLCBBQ1BJX1BST0NFU1NPUl9BR0dSRUdB
VE9SX0NMQVNTKTsKKworCXN0YXR1cyA9IGFjcGlfaW5zdGFsbF9ub3RpZnlfaGFuZGxlcihkZXZp
Y2UtPmhhbmRsZSwKKwkJIEFDUElfREVWSUNFX05PVElGWSwgeGVuX2FjcGlfcGFkX25vdGlmeSwg
ZGV2aWNlKTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpCisJCXJldHVybiAtRU5PREVWOwor
CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgeGVuX2FjcGlfcGFkX3JlbW92ZShzdHJ1Y3Qg
YWNwaV9kZXZpY2UgKmRldmljZSwKKwlpbnQgdHlwZSkKK3sKKwltdXRleF9sb2NrKCZ4ZW5fcGFk
X2xvY2spOworCXhlbl9wYWRfc2V0X2lkbGVfY3B1cygwKTsKKwltdXRleF91bmxvY2soJnhlbl9w
YWRfbG9jayk7CisKKwlhY3BpX3JlbW92ZV9ub3RpZnlfaGFuZGxlcihkZXZpY2UtPmhhbmRsZSwK
KwkJQUNQSV9ERVZJQ0VfTk9USUZZLCB4ZW5fYWNwaV9wYWRfbm90aWZ5KTsKKwlyZXR1cm4gMDsK
K30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBhY3BpX2RldmljZV9pZCBwYWRfZGV2aWNlX2lkc1td
ID0geworCXsiQUNQSTAwMEMiLCAwfSwKKwl7IiIsIDB9LAorfTsKKworc3RhdGljIHN0cnVjdCBh
Y3BpX2RyaXZlciB4ZW5fYWNwaV9wYWRfZHJpdmVyID0geworCS5uYW1lID0gInByb2Nlc3Nvcl9h
Z2dyZWdhdG9yIiwKKwkuY2xhc3MgPSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX0NMQVNTLAor
CS5pZHMgPSBwYWRfZGV2aWNlX2lkcywKKwkub3BzID0geworCQkuYWRkID0geGVuX2FjcGlfcGFk
X2FkZCwKKwkJLnJlbW92ZSA9IHhlbl9hY3BpX3BhZF9yZW1vdmUsCisJfSwKK307CisKK3N0YXRp
YyBpbnQgX19pbml0IHhlbl9hY3BpX3BhZF9pbml0KHZvaWQpCit7CisJaW50IHJldCA9IC1FTk9T
WVM7CisJdW5zaWduZWQgaW50IHZlcnNpb24gPSBIWVBFUlZJU09SX3hlbl92ZXJzaW9uKFhFTlZF
Ul92ZXJzaW9uLCBOVUxMKTsKKwl1bnNpZ25lZCBpbnQgbWFqb3IgPSB2ZXJzaW9uID4+IDE2Owor
CXVuc2lnbmVkIGludCBtaW5vciA9IHZlcnNpb24gJiAweGZmZmY7CisKKwkvKiBPbmx5IERPTTAg
aXMgcmVzcG9uc2libGUgZm9yIFhlbiBhY3BpIHBhZCAqLworCWlmICgheGVuX2luaXRpYWxfZG9t
YWluKCkpCisJCXJldHVybiAtRU5PREVWOworCisJLyogT25seSBYZW40LjIgb3IgbGF0ZXIgc3Vw
cG9ydCBYZW4gYWNwaSBwYWQgKi8KKwlpZiAoKChtYWpvciA9PSA0KSAmJiAobWlub3IgPj0gMikp
IHx8IChtYWpvciA+IDQpKQorCQlyZXQgPSBhY3BpX2J1c19yZWdpc3Rlcl9kcml2ZXIoJnhlbl9h
Y3BpX3BhZF9kcml2ZXIpOworCisJcmV0dXJuIHJldDsKK30KK3N1YnN5c19pbml0Y2FsbCh4ZW5f
YWNwaV9wYWRfaW5pdCk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZv
cm0uaCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCmluZGV4IDQ3NTViNWYuLmEz
YmU1NGMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCisrKyBi
L2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCkBAIC0zMjQsNiArMzI0LDIyIEBAIHN0
cnVjdCB4ZW5wZl9jcHVfb2wgewogfTsKIERFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbnBm
X2NwdV9vbCk7CiAKKy8qCisgKiBDTUQgNTggYW5kIDU5IGFyZSByZXNlcnZlZCBmb3IgY3B1IGhv
dGFkZCBhbmQgbWVtb3J5IGhvdGFkZCwKKyAqIHdoaWNoIGFyZSBhbHJlYWR5IG9jY3VwaWVkIGF0
IFhlbiBoeXBlcnZpc29yIHNpZGUuCisgKi8KKyNkZWZpbmUgWEVOUEZfY29yZV9wYXJraW5nCTYw
CitzdHJ1Y3QgeGVucGZfY29yZV9wYXJraW5nIHsKKwkvKiBJTiB2YXJpYWJsZXMgKi8KKyNkZWZp
bmUgWEVOX0NPUkVfUEFSS0lOR19TRVQJMQorI2RlZmluZSBYRU5fQ09SRV9QQVJLSU5HX0dFVAky
CisJdWludDMyX3QgdHlwZTsKKwkvKiBJTiB2YXJpYWJsZXM6ICBzZXQgY3B1IG51bXMgZXhwZWN0
ZWQgdG8gYmUgaWRsZWQgKi8KKwkvKiBPVVQgdmFyaWFibGVzOiBnZXQgY3B1IG51bXMgYWN0dWFs
bHkgYmUgaWRsZWQgKi8KKwl1aW50MzJfdCBpZGxlX251bXM7Cit9OworREVGSU5FX0dVRVNUX0hB
TkRMRV9TVFJVQ1QoeGVucGZfY29yZV9wYXJraW5nKTsKKwogc3RydWN0IHhlbl9wbGF0Zm9ybV9v
cCB7CiAJdWludDMyX3QgY21kOwogCXVpbnQzMl90IGludGVyZmFjZV92ZXJzaW9uOyAvKiBYRU5Q
Rl9JTlRFUkZBQ0VfVkVSU0lPTiAqLwpAQCAtMzQxLDYgKzM1Nyw3IEBAIHN0cnVjdCB4ZW5fcGxh
dGZvcm1fb3AgewogCQlzdHJ1Y3QgeGVucGZfc2V0X3Byb2Nlc3Nvcl9wbWluZm8gc2V0X3BtaW5m
bzsKIAkJc3RydWN0IHhlbnBmX3BjcHVpbmZvICAgICAgICAgIHBjcHVfaW5mbzsKIAkJc3RydWN0
IHhlbnBmX2NwdV9vbCAgICAgICAgICAgIGNwdV9vbDsKKwkJc3RydWN0IHhlbnBmX2NvcmVfcGFy
a2luZyAgICAgIGNvcmVfcGFya2luZzsKIAkJdWludDhfdCAgICAgICAgICAgICAgICAgICAgICAg
IHBhZFsxMjhdOwogCX0gdTsKIH07Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC8292335377346SHSMSX101ccrcorpi_--
