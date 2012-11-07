Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2KGM6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:58:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:57235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab2KGM6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:58:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,730,1344236400"; 
   d="scan'208,223";a="243622347"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>
Subject: RE: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Topic: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Thread-Index: AQHNvD3JTi91BiFLfUibRvXA4zlK85feVKOg
Date: Wed, 7 Nov 2012 12:58:19 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233537B99E@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC8292335372883@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537292E@SHSMSX101.ccr.corp.intel.com>
 <20121026201409.GF2708@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335377346@SHSMSX101.ccr.corp.intel.com>
 <20121102164937.GC27213@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1211051512260.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B10C@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537B147@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1211061455150.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B479@SHSMSX101.ccr.corp.intel.com>
 <20121106164303.GO9966@phenom.dumpdata.com>
In-Reply-To: <20121106164303.GO9966@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233537B99ESHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233537B99ESHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>>>=20
>>> If it is generic ACPI code, than it can depend only on ACPI.
>>> If it is ACPI code that contains X86 specific info, than it needs to
>>> depend on X86 too.
>>=20
>> No x86 specific so let's depend on ACPI.
>=20
> Huh? This feature is x86 specific isn't it? I mean it is in the ACPI
> spec, but only x86 does it right?

OK, updated w/ ACPI & X86 dependency, and per other comments.

Thanks,
Jinsong

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

>From d5f462cc8029863955a574f1541bece72aafb986 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Thu, 8 Nov 2012 04:29:07 +0800
Subject: [PATCH 1/2] Xen acpi pad implement

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
 drivers/xen/xen-acpi-pad.c       |  186 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   17 ++++
 include/xen/interface/version.h  |   15 +++
 4 files changed, 220 insertions(+), 1 deletions(-)
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
index 0000000..f02d3ff
--- /dev/null
+++ b/drivers/xen/xen-acpi-pad.c
@@ -0,0 +1,186 @@
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
+ *
+ * You should have received a copy of the GNU General Public License along=
 with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
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
+
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
+	/* Only DOM0 and Xen4.2 or later support Xen acpi pad */
+	if (!xen_initial_domain() ||
+		!xen_running_on_version_or_later(4, 2))
+		return -ENODEV;
+
+	return acpi_bus_register_driver(&acpi_pad_driver);
+}
+subsys_initcall(xen_acpi_pad_init);
+
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

--_002_DE8DF0795D48FD4CA783C40EC829233537B99ESHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Xen-acpi-pad-implement.patch"
Content-Description: 0001-Xen-acpi-pad-implement.patch
Content-Disposition: attachment;
	filename="0001-Xen-acpi-pad-implement.patch"; size=8743;
	creation-date="Wed, 07 Nov 2012 12:49:11 GMT";
	modification-date="Wed, 07 Nov 2012 20:32:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkNWY0NjJjYzgwMjk4NjM5NTVhNTc0ZjE1NDFiZWNlNzJhYWZiOTg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogVGh1LCA4IE5vdiAyMDEyIDA0OjI5OjA3ICswODAwClN1YmplY3Q6IFtQQVRDSCAxLzJd
IFhlbiBhY3BpIHBhZCBpbXBsZW1lbnQKClBBRCBpcyBhY3BpIFByb2Nlc3NvciBBZ2dyZWdhdG9y
IERldmljZSB3aGljaCBwcm92aWRlcyBhIGNvbnRyb2wgcG9pbnQKdGhhdCBlbmFibGVzIHRoZSBw
bGF0Zm9ybSB0byBwZXJmb3JtIHNwZWNpZmljIHByb2Nlc3NvciBjb25maWd1cmF0aW9uCmFuZCBj
b250cm9sIHRoYXQgYXBwbGllcyB0byBhbGwgcHJvY2Vzc29ycyBpbiB0aGUgcGxhdGZvcm0uCgpU
aGlzIHBhdGNoIGlzIHRvIGltcGxlbWVudCBYZW4gYWNwaSBwYWQgbG9naWMuIFdoZW4gcnVubmlu
ZyB1bmRlciBYZW4KdmlydCBwbGF0Zm9ybSwgbmF0aXZlIHBhZCBkcml2ZXIgd291bGQgbm90IHdv
cmsuIEluc3RlYWQgWGVuIHBhZCBkcml2ZXIsCmEgc2VsZi1jb250YWluZWQgYW5kIHRoaW4gbG9n
aWMgbGV2ZWwsIHdvdWxkIHRha2Ugb3ZlciBhY3BpIHBhZCBsb2dpYy4KCldoZW4gYWNwaSBwYWQg
bm90aWZ5IE9TUE0sIHhlbiBwYWQgbG9naWMgaW50ZXJjZXB0IGFuZCBwYXJzZSBfUFVSIG9iamVj
dAp0byBnZXQgdGhlIGV4cGVjdGVkIGlkbGUgY3B1IG51bWJlciwgYW5kIHRoZW4gaHlwZXJjYWxs
IHRvIGh5cGVydmlzb3IuClhlbiBoeXBlcnZpc29yIHdvdWxkIHRoZW4gZG8gdGhlIHJlc3Qgd29y
aywgc2F5LCBjb3JlIHBhcmtpbmcsIHRvIGlkbGUKc3BlY2lmaWMgbnVtYmVyIG9mIGNwdXMgb24g
aXRzIG93biBwb2xpY3kuCgpTaWduZWQtb2ZmLWJ5OiBKYW4gQmV1bGljaCA8SkJldWxpY2hAc3Vz
ZS5jb20+ClNpZ25lZC1vZmYtYnk6IExpdSBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+
Ci0tLQogZHJpdmVycy94ZW4vTWFrZWZpbGUgICAgICAgICAgICAgfCAgICAzICstCiBkcml2ZXJz
L3hlbi94ZW4tYWNwaS1wYWQuYyAgICAgICB8ICAxODYgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKIGluY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oIHwgICAxNyAr
KysrCiBpbmNsdWRlL3hlbi9pbnRlcmZhY2UvdmVyc2lvbi5oICB8ICAgMTUgKysrCiA0IGZpbGVz
IGNoYW5nZWQsIDIyMCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUg
MTAwNjQ0IGRyaXZlcnMveGVuL3hlbi1hY3BpLXBhZC5jCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy94
ZW4vTWFrZWZpbGUgYi9kcml2ZXJzL3hlbi9NYWtlZmlsZQppbmRleCAwZTg2MzcwLi4zYzM5NzE3
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3hlbi9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3hlbi9NYWtl
ZmlsZQpAQCAtMTAsNyArMTAsOCBAQCBDRkxBR1NfZmVhdHVyZXMubwkJCTo9ICQobm9zdGFja3Ap
CiAKIGRvbTAtJChDT05GSUdfUENJKSArPSBwY2kubwogZG9tMC0kKENPTkZJR19VU0JfU1VQUE9S
VCkgKz0gZGJncC5vCi1kb20wLSQoQ09ORklHX0FDUEkpICs9IGFjcGkubworZG9tMC0kKENPTkZJ
R19BQ1BJKSArPSBhY3BpLm8gJCh4ZW4tcGFkLXkpCit4ZW4tcGFkLSQoQ09ORklHX1g4NikgKz0g
eGVuLWFjcGktcGFkLm8KIGRvbTAtJChDT05GSUdfWDg2KSArPSBwY3B1Lm8KIG9iai0kKENPTkZJ
R19YRU5fRE9NMCkJCQkrPSAkKGRvbTAteSkKIG9iai0kKENPTkZJR19CTE9DSykJCQkrPSBiaW9t
ZXJnZS5vCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi94ZW4tYWNwaS1wYWQuYyBiL2RyaXZlcnMv
eGVuL3hlbi1hY3BpLXBhZC5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmYw
MmQzZmYKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL3hlbi94ZW4tYWNwaS1wYWQuYwpAQCAt
MCwwICsxLDE4NiBAQAorLyoKKyAqIHhlbi1hY3BpLXBhZC5jIC0gWGVuIHBhZCBpbnRlcmZhY2UK
KyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTIsIEludGVsIENvcnBvcmF0aW9uLgorICogICAgQXV0
aG9yOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KKyAqCisgKiBUaGlzIHBy
b2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1v
ZGlmeSBpdAorICogdW5kZXIgdGhlIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHRoZSBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZSwKKyAqIHZlcnNpb24gMiwgYXMgcHVibGlzaGVkIGJ5IHRoZSBG
cmVlIFNvZnR3YXJlIEZvdW5kYXRpb24uCisgKgorICogVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1
dGVkIGluIHRoZSBob3BlIGl0IHdpbGwgYmUgdXNlZnVsLCBidXQgV0lUSE9VVAorICogQU5ZIFdB
UlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YgTUVSQ0hBTlRBQklM
SVRZIG9yCisgKiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUgR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yCisgKiBtb3JlIGRldGFpbHMuCisgKgorICogWW91
IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExp
Y2Vuc2UgYWxvbmcgd2l0aAorICogdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRlIHRvIHRoZSBG
cmVlIFNvZnR3YXJlIEZvdW5kYXRpb24sIEluYy4sCisgKiA1MSBGcmFua2xpbiBTdCAtIEZpZnRo
IEZsb29yLCBCb3N0b24sIE1BIDAyMTEwLTEzMDEgVVNBLgorICoKKyAqLworCisjaW5jbHVkZSA8
bGludXgva2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxhY3Bp
L2FjcGlfYnVzLmg+CisjaW5jbHVkZSA8YWNwaS9hY3BpX2RyaXZlcnMuaD4KKyNpbmNsdWRlIDxh
c20veGVuL2h5cGVyY2FsbC5oPgorI2luY2x1ZGUgPHhlbi9pbnRlcmZhY2UvdmVyc2lvbi5oPgor
CisjZGVmaW5lIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfQ0xBU1MJImFjcGlfcGFkIgorI2Rl
ZmluZSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX0RFVklDRV9OQU1FICJQcm9jZXNzb3IgQWdn
cmVnYXRvciIKKyNkZWZpbmUgQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9OT1RJRlkgMHg4MAor
CitzdGF0aWMgREVGSU5FX01VVEVYKHhlbl9jcHVfbG9jayk7CisKK3N0YXRpYyBpbnQgeGVuX2Fj
cGlfcGFkX2lkbGVfY3B1cyh1bnNpZ25lZCBpbnQgaWRsZV9udW1zKQoreworCXN0cnVjdCB4ZW5f
cGxhdGZvcm1fb3Agb3A7CisKKwlvcC5jbWQgPSBYRU5QRl9jb3JlX3Bhcmtpbmc7CisJb3AudS5j
b3JlX3BhcmtpbmcudHlwZSA9IFhFTl9DT1JFX1BBUktJTkdfU0VUOworCW9wLnUuY29yZV9wYXJr
aW5nLmlkbGVfbnVtcyA9IGlkbGVfbnVtczsKKworCXJldHVybiBIWVBFUlZJU09SX2RvbTBfb3Ao
Jm9wKTsKK30KKworc3RhdGljIGludCB4ZW5fYWNwaV9wYWRfaWRsZV9jcHVzX251bSh2b2lkKQor
eworCXN0cnVjdCB4ZW5fcGxhdGZvcm1fb3Agb3A7CisKKwlvcC5jbWQgPSBYRU5QRl9jb3JlX3Bh
cmtpbmc7CisJb3AudS5jb3JlX3BhcmtpbmcudHlwZSA9IFhFTl9DT1JFX1BBUktJTkdfR0VUOwor
CisJcmV0dXJuIEhZUEVSVklTT1JfZG9tMF9vcCgmb3ApCisJICAgICAgID86IG9wLnUuY29yZV9w
YXJraW5nLmlkbGVfbnVtczsKK30KKworLyoKKyAqIFF1ZXJ5IGZpcm13YXJlIGhvdyBtYW55IENQ
VXMgc2hvdWxkIGJlIGlkbGUKKyAqIHJldHVybiAtMSBvbiBmYWlsdXJlCisgKi8KK3N0YXRpYyBp
bnQgYWNwaV9wYWRfcHVyKGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwlzdHJ1Y3QgYWNwaV9idWZm
ZXIgYnVmZmVyID0ge0FDUElfQUxMT0NBVEVfQlVGRkVSLCBOVUxMfTsKKwl1bmlvbiBhY3BpX29i
amVjdCAqcGFja2FnZTsKKwlpbnQgbnVtID0gLTE7CisKKwlpZiAoQUNQSV9GQUlMVVJFKGFjcGlf
ZXZhbHVhdGVfb2JqZWN0KGhhbmRsZSwgIl9QVVIiLCBOVUxMLCAmYnVmZmVyKSkpCisJCXJldHVy
biBudW07CisKKwlpZiAoIWJ1ZmZlci5sZW5ndGggfHwgIWJ1ZmZlci5wb2ludGVyKQorCQlyZXR1
cm4gbnVtOworCisJcGFja2FnZSA9IGJ1ZmZlci5wb2ludGVyOworCisJaWYgKHBhY2thZ2UtPnR5
cGUgPT0gQUNQSV9UWVBFX1BBQ0tBR0UgJiYKKwkJcGFja2FnZS0+cGFja2FnZS5jb3VudCA9PSAy
ICYmCisJCXBhY2thZ2UtPnBhY2thZ2UuZWxlbWVudHNbMF0uaW50ZWdlci52YWx1ZSA9PSAxKSAv
KiByZXYgMSAqLworCisJCW51bSA9IHBhY2thZ2UtPnBhY2thZ2UuZWxlbWVudHNbMV0uaW50ZWdl
ci52YWx1ZTsKKworCWtmcmVlKGJ1ZmZlci5wb2ludGVyKTsKKwlyZXR1cm4gbnVtOworfQorCisv
KiBOb3RpZnkgZmlybXdhcmUgaG93IG1hbnkgQ1BVcyBhcmUgaWRsZSAqLworc3RhdGljIHZvaWQg
YWNwaV9wYWRfb3N0KGFjcGlfaGFuZGxlIGhhbmRsZSwgaW50IHN0YXQsCisJdWludDMyX3QgaWRs
ZV9udW1zKQoreworCXVuaW9uIGFjcGlfb2JqZWN0IHBhcmFtc1szXSA9IHsKKwkJey50eXBlID0g
QUNQSV9UWVBFX0lOVEVHRVIsfSwKKwkJey50eXBlID0gQUNQSV9UWVBFX0lOVEVHRVIsfSwKKwkJ
ey50eXBlID0gQUNQSV9UWVBFX0JVRkZFUix9LAorCX07CisJc3RydWN0IGFjcGlfb2JqZWN0X2xp
c3QgYXJnX2xpc3QgPSB7MywgcGFyYW1zfTsKKworCXBhcmFtc1swXS5pbnRlZ2VyLnZhbHVlID0g
QUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9OT1RJRlk7CisJcGFyYW1zWzFdLmludGVnZXIudmFs
dWUgPSAgc3RhdDsKKwlwYXJhbXNbMl0uYnVmZmVyLmxlbmd0aCA9IDQ7CisJcGFyYW1zWzJdLmJ1
ZmZlci5wb2ludGVyID0gKHZvaWQgKikmaWRsZV9udW1zOworCWFjcGlfZXZhbHVhdGVfb2JqZWN0
KGhhbmRsZSwgIl9PU1QiLCAmYXJnX2xpc3QsIE5VTEwpOworfQorCitzdGF0aWMgdm9pZCBhY3Bp
X3BhZF9oYW5kbGVfbm90aWZ5KGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwlpbnQgaWRsZV9udW1z
OworCisJbXV0ZXhfbG9jaygmeGVuX2NwdV9sb2NrKTsKKwlpZGxlX251bXMgPSBhY3BpX3BhZF9w
dXIoaGFuZGxlKTsKKwlpZiAoaWRsZV9udW1zIDwgMCkgeworCQltdXRleF91bmxvY2soJnhlbl9j
cHVfbG9jayk7CisJCXJldHVybjsKKwl9CisKKwlpZGxlX251bXMgPSB4ZW5fYWNwaV9wYWRfaWRs
ZV9jcHVzKGlkbGVfbnVtcykKKwkJICAgID86IHhlbl9hY3BpX3BhZF9pZGxlX2NwdXNfbnVtKCk7
CisJaWYgKGlkbGVfbnVtcyA+PSAwKQorCQlhY3BpX3BhZF9vc3QoaGFuZGxlLCAwLCBpZGxlX251
bXMpOworCW11dGV4X3VubG9jaygmeGVuX2NwdV9sb2NrKTsKK30KKworc3RhdGljIHZvaWQgYWNw
aV9wYWRfbm90aWZ5KGFjcGlfaGFuZGxlIGhhbmRsZSwgdTMyIGV2ZW50LAorCXZvaWQgKmRhdGEp
Cit7CisJc3dpdGNoIChldmVudCkgeworCWNhc2UgQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9O
T1RJRlk6CisJCWFjcGlfcGFkX2hhbmRsZV9ub3RpZnkoaGFuZGxlKTsKKwkJYnJlYWs7CisJZGVm
YXVsdDoKKwkJcHJfd2FybigiVW5zdXBwb3J0ZWQgZXZlbnQgWzB4JXhdXG4iLCBldmVudCk7CisJ
CWJyZWFrOworCX0KK30KKworc3RhdGljIGludCBhY3BpX3BhZF9hZGQoc3RydWN0IGFjcGlfZGV2
aWNlICpkZXZpY2UpCit7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3RyY3B5KGFjcGlfZGV2
aWNlX25hbWUoZGV2aWNlKSwgQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9ERVZJQ0VfTkFNRSk7
CisJc3RyY3B5KGFjcGlfZGV2aWNlX2NsYXNzKGRldmljZSksIEFDUElfUFJPQ0VTU09SX0FHR1JF
R0FUT1JfQ0xBU1MpOworCisJc3RhdHVzID0gYWNwaV9pbnN0YWxsX25vdGlmeV9oYW5kbGVyKGRl
dmljZS0+aGFuZGxlLAorCQlBQ1BJX0RFVklDRV9OT1RJRlksIGFjcGlfcGFkX25vdGlmeSwgZGV2
aWNlKTsKKwlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykpCisJCXJldHVybiAtRU5PREVWOworCisJ
cmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgYWNwaV9wYWRfcmVtb3ZlKHN0cnVjdCBhY3BpX2Rl
dmljZSAqZGV2aWNlLAorCWludCB0eXBlKQoreworCW11dGV4X2xvY2soJnhlbl9jcHVfbG9jayk7
CisJeGVuX2FjcGlfcGFkX2lkbGVfY3B1cygwKTsKKwltdXRleF91bmxvY2soJnhlbl9jcHVfbG9j
ayk7CisKKwlhY3BpX3JlbW92ZV9ub3RpZnlfaGFuZGxlcihkZXZpY2UtPmhhbmRsZSwKKwkJQUNQ
SV9ERVZJQ0VfTk9USUZZLCBhY3BpX3BhZF9ub3RpZnkpOworCXJldHVybiAwOworfQorCitzdGF0
aWMgY29uc3Qgc3RydWN0IGFjcGlfZGV2aWNlX2lkIHBhZF9kZXZpY2VfaWRzW10gPSB7CisJeyJB
Q1BJMDAwQyIsIDB9LAorCXsiIiwgMH0sCit9OworCitzdGF0aWMgc3RydWN0IGFjcGlfZHJpdmVy
IGFjcGlfcGFkX2RyaXZlciA9IHsKKwkubmFtZSA9ICJwcm9jZXNzb3JfYWdncmVnYXRvciIsCisJ
LmNsYXNzID0gQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9DTEFTUywKKwkuaWRzID0gcGFkX2Rl
dmljZV9pZHMsCisJLm9wcyA9IHsKKwkJLmFkZCA9IGFjcGlfcGFkX2FkZCwKKwkJLnJlbW92ZSA9
IGFjcGlfcGFkX3JlbW92ZSwKKwl9LAorfTsKKworc3RhdGljIGludCBfX2luaXQgeGVuX2FjcGlf
cGFkX2luaXQodm9pZCkKK3sKKwkvKiBPbmx5IERPTTAgYW5kIFhlbjQuMiBvciBsYXRlciBzdXBw
b3J0IFhlbiBhY3BpIHBhZCAqLworCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkgfHwKKwkJIXhl
bl9ydW5uaW5nX29uX3ZlcnNpb25fb3JfbGF0ZXIoNCwgMikpCisJCXJldHVybiAtRU5PREVWOwor
CisJcmV0dXJuIGFjcGlfYnVzX3JlZ2lzdGVyX2RyaXZlcigmYWNwaV9wYWRfZHJpdmVyKTsKK30K
K3N1YnN5c19pbml0Y2FsbCh4ZW5fYWNwaV9wYWRfaW5pdCk7CisKZGlmZiAtLWdpdCBhL2luY2x1
ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRm
b3JtLmgKaW5kZXggNDc1NWI1Zi4uNWUzNjkzMiAxMDA2NDQKLS0tIGEvaW5jbHVkZS94ZW4vaW50
ZXJmYWNlL3BsYXRmb3JtLmgKKysrIGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgK
QEAgLTMyNCw2ICszMjQsMjIgQEAgc3RydWN0IHhlbnBmX2NwdV9vbCB7CiB9OwogREVGSU5FX0dV
RVNUX0hBTkRMRV9TVFJVQ1QoeGVucGZfY3B1X29sKTsKIAorLyoKKyAqIENNRCA1OCBhbmQgNTkg
YXJlIHJlc2VydmVkIGZvciBjcHUgaG90YWRkIGFuZCBtZW1vcnkgaG90YWRkLAorICogd2hpY2gg
YXJlIGFscmVhZHkgb2NjdXBpZWQgYXQgWGVuIGh5cGVydmlzb3Igc2lkZS4KKyAqLworI2RlZmlu
ZSBYRU5QRl9jb3JlX3BhcmtpbmcgICAgIDYwCitzdHJ1Y3QgeGVucGZfY29yZV9wYXJraW5nIHsK
KwkvKiBJTiB2YXJpYWJsZXMgKi8KKyNkZWZpbmUgWEVOX0NPUkVfUEFSS0lOR19TRVQgICAxCisj
ZGVmaW5lIFhFTl9DT1JFX1BBUktJTkdfR0VUICAgMgorCXVpbnQzMl90IHR5cGU7CisJLyogSU4g
dmFyaWFibGVzOiAgc2V0IGNwdSBudW1zIGV4cGVjdGVkIHRvIGJlIGlkbGVkICovCisJLyogT1VU
IHZhcmlhYmxlczogZ2V0IGNwdSBudW1zIGFjdHVhbGx5IGJlIGlkbGVkICovCisJdWludDMyX3Qg
aWRsZV9udW1zOworfTsKK0RFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbnBmX2NvcmVfcGFy
a2luZyk7CisKIHN0cnVjdCB4ZW5fcGxhdGZvcm1fb3AgewogCXVpbnQzMl90IGNtZDsKIAl1aW50
MzJfdCBpbnRlcmZhY2VfdmVyc2lvbjsgLyogWEVOUEZfSU5URVJGQUNFX1ZFUlNJT04gKi8KQEAg
LTM0MSw2ICszNTcsNyBAQCBzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIHsKIAkJc3RydWN0IHhlbnBm
X3NldF9wcm9jZXNzb3JfcG1pbmZvIHNldF9wbWluZm87CiAJCXN0cnVjdCB4ZW5wZl9wY3B1aW5m
byAgICAgICAgICBwY3B1X2luZm87CiAJCXN0cnVjdCB4ZW5wZl9jcHVfb2wgICAgICAgICAgICBj
cHVfb2w7CisJCXN0cnVjdCB4ZW5wZl9jb3JlX3BhcmtpbmcgICAgICBjb3JlX3Bhcmtpbmc7CiAJ
CXVpbnQ4X3QgICAgICAgICAgICAgICAgICAgICAgICBwYWRbMTI4XTsKIAl9IHU7CiB9OwpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3ZlcnNpb24uaCBiL2luY2x1ZGUveGVuL2lu
dGVyZmFjZS92ZXJzaW9uLmgKaW5kZXggN2ZmNjQ5OC4uOTZkOGQzZCAxMDA2NDQKLS0tIGEvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL3ZlcnNpb24uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2Uv
dmVyc2lvbi5oCkBAIC02Myw0ICs2MywxOSBAQCBzdHJ1Y3QgeGVuX2ZlYXR1cmVfaW5mbyB7CiAv
KiBhcmcgPT0geGVuX2RvbWFpbl9oYW5kbGVfdC4gKi8KICNkZWZpbmUgWEVOVkVSX2d1ZXN0X2hh
bmRsZSA4CiAKKy8qIENoZWNrIGlmIHJ1bm5pbmcgb24gWGVuIHZlcnNpb24gKG1ham9yLCBtaW5v
cikgb3IgbGF0ZXIgKi8KK3N0YXRpYyBpbmxpbmUgYm9vbAoreGVuX3J1bm5pbmdfb25fdmVyc2lv
bl9vcl9sYXRlcih1bnNpZ25lZCBpbnQgbWFqb3IsIHVuc2lnbmVkIGludCBtaW5vcikKK3sKKwl1
bnNpZ25lZCBpbnQgdmVyc2lvbjsKKworCWlmICgheGVuX2RvbWFpbigpKQorCQlyZXR1cm4gZmFs
c2U7CisKKwl2ZXJzaW9uID0gSFlQRVJWSVNPUl94ZW5fdmVyc2lvbihYRU5WRVJfdmVyc2lvbiwg
TlVMTCk7CisJaWYgKCgoKHZlcnNpb24gPj4gMTYpID09IG1ham9yKSAmJiAoKHZlcnNpb24gJiAw
eGZmZmYpID49IG1pbm9yKSkgfHwKKwkJKCh2ZXJzaW9uID4+IDE2KSA+IG1ham9yKSkKKwkJcmV0
dXJuIHRydWU7CisJcmV0dXJuIGZhbHNlOworfQogI2VuZGlmIC8qIF9fWEVOX1BVQkxJQ19WRVJT
SU9OX0hfXyAqLwotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC829233537B99ESHSMSX101ccrcorpi_--
