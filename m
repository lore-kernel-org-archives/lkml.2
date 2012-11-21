Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2KULq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 06:46:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:26299 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab2KULq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 06:46:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,293,1352102400"; 
   d="scan'208,223";a="220606479"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
CC: "lenb@kernel.org" <lenb@kernel.org>
Subject: [PATCH V1 2/2] Xen acpi memory hotplug hypercall
Thread-Topic: [PATCH V1 2/2] Xen acpi memory hotplug hypercall
Thread-Index: Ac3H3eaBDCAgZnNdSMCQjopXez+hyA==
Date: Wed, 21 Nov 2012 11:46:53 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335394308@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335394308SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335394308SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From dd622978066d2cf29a26f246ad6c55f51a0a6272 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Wed, 21 Nov 2012 15:39:47 +0800
Subject: [PATCH 2/2] Xen acpi memory hotplug hypercall

This patch implement Xen acpi memory hotplug hypercall, extracting
memory information then hypercall to hypervisor.

Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 drivers/xen/xen-acpi-memhotplug.c |   44 +++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h  |    9 +++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
index f0c7990..877f5c8 100644
--- a/drivers/xen/xen-acpi-memhotplug.c
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -18,7 +18,10 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
 #include <acpi/acpi_drivers.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypercall.h>
=20
 #define ACPI_MEMORY_DEVICE_CLASS		"memory"
 #define ACPI_MEMORY_DEVICE_HID			"PNP0C80"
@@ -61,9 +64,50 @@ struct acpi_memory_device {
=20
 static int acpi_hotmem_initialized;
=20
+static int xen_hotadd_memory(int pxm, struct acpi_memory_info *info)
+{
+	struct xen_platform_op op;
+
+	op.cmd =3D XENPF_mem_hotadd;
+	op.u.mem_add.spfn =3D info->start_addr >> PAGE_SHIFT;
+	op.u.mem_add.epfn =3D (info->start_addr + info->length) >> PAGE_SHIFT;
+	op.u.mem_add.pxm =3D pxm;
+
+	return HYPERVISOR_dom0_op(&op);
+}
=20
 int xen_acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 {
+	int pxm, result;
+	int num_enabled =3D 0;
+	struct acpi_memory_info *info;
+
+	if (!mem_device)
+		return -EINVAL;
+
+	pxm =3D acpi_get_pxm(mem_device->device->handle);
+	if (pxm < 0)
+		return -EINVAL;
+
+	list_for_each_entry(info, &mem_device->res_list, list) {
+		if (info->enabled) { /* just sanity check...*/
+			num_enabled++;
+			continue;
+		}
+
+		if (!info->length)
+			continue;
+
+		result =3D xen_hotadd_memory(pxm, info);
+		if (result)
+			continue;
+		info->enabled =3D 1;
+		num_enabled++;
+	}
+
+	if (!num_enabled)
+		return -EINVAL;
+
 	return 0;
 }
=20
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 4755b5f..45215d9 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -324,6 +324,14 @@ struct xenpf_cpu_ol {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
=20
+#define XENPF_mem_hotadd    59
+struct xenpf_mem_hotadd {
+	uint64_t spfn;
+	uint64_t epfn;
+	uint32_t pxm;
+	uint32_t flags;
+};
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -341,6 +349,7 @@ struct xen_platform_op {
 		struct xenpf_set_processor_pminfo set_pminfo;
 		struct xenpf_pcpuinfo          pcpu_info;
 		struct xenpf_cpu_ol            cpu_ol;
+		struct xenpf_mem_hotadd        mem_add;
 		uint8_t                        pad[128];
 	} u;
 };
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335394308SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0002-Xen-acpi-memory-hotplug-hypercall.patch"
Content-Description: 0002-Xen-acpi-memory-hotplug-hypercall.patch
Content-Disposition: attachment;
	filename="0002-Xen-acpi-memory-hotplug-hypercall.patch"; size=2928;
	creation-date="Wed, 21 Nov 2012 11:38:00 GMT";
	modification-date="Wed, 21 Nov 2012 11:20:46 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkZDYyMjk3ODA2NmQyY2YyOWEyNmYyNDZhZDZjNTVmNTFhMGE2MjcyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBXZWQsIDIxIE5vdiAyMDEyIDE1OjM5OjQ3ICswODAwClN1YmplY3Q6IFtQQVRDSCAyLzJd
IFhlbiBhY3BpIG1lbW9yeSBob3RwbHVnIGh5cGVyY2FsbAoKVGhpcyBwYXRjaCBpbXBsZW1lbnQg
WGVuIGFjcGkgbWVtb3J5IGhvdHBsdWcgaHlwZXJjYWxsLCBleHRyYWN0aW5nCm1lbW9yeSBpbmZv
cm1hdGlvbiB0aGVuIGh5cGVyY2FsbCB0byBoeXBlcnZpc29yLgoKU2lnbmVkLW9mZi1ieTogTGl1
IEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL3hlbi94ZW4tYWNw
aS1tZW1ob3RwbHVnLmMgfCAgIDQ0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysKIGluY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oICB8ICAgIDkgKysrKysrKwogMiBm
aWxlcyBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMveGVuL3hlbi1hY3BpLW1lbWhvdHBsdWcuYyBiL2RyaXZlcnMveGVuL3hlbi1h
Y3BpLW1lbWhvdHBsdWcuYwppbmRleCBmMGM3OTkwLi44NzdmNWM4IDEwMDY0NAotLS0gYS9kcml2
ZXJzL3hlbi94ZW4tYWNwaS1tZW1ob3RwbHVnLmMKKysrIGIvZHJpdmVycy94ZW4veGVuLWFjcGkt
bWVtaG90cGx1Zy5jCkBAIC0xOCw3ICsxOCwxMCBAQAogI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5o
PgogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgorI2lu
Y2x1ZGUgPGxpbnV4L2FjcGkuaD4KICNpbmNsdWRlIDxhY3BpL2FjcGlfZHJpdmVycy5oPgorI2lu
Y2x1ZGUgPHhlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaD4KKyNpbmNsdWRlIDxhc20veGVuL2h5cGVy
Y2FsbC5oPgogCiAjZGVmaW5lIEFDUElfTUVNT1JZX0RFVklDRV9DTEFTUwkJIm1lbW9yeSIKICNk
ZWZpbmUgQUNQSV9NRU1PUllfREVWSUNFX0hJRAkJCSJQTlAwQzgwIgpAQCAtNjEsOSArNjQsNTAg
QEAgc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSB7CiAKIHN0YXRpYyBpbnQgYWNwaV9ob3RtZW1f
aW5pdGlhbGl6ZWQ7CiAKK3N0YXRpYyBpbnQgeGVuX2hvdGFkZF9tZW1vcnkoaW50IHB4bSwgc3Ry
dWN0IGFjcGlfbWVtb3J5X2luZm8gKmluZm8pCit7CisJc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBv
cDsKKworCW9wLmNtZCA9IFhFTlBGX21lbV9ob3RhZGQ7CisJb3AudS5tZW1fYWRkLnNwZm4gPSBp
bmZvLT5zdGFydF9hZGRyID4+IFBBR0VfU0hJRlQ7CisJb3AudS5tZW1fYWRkLmVwZm4gPSAoaW5m
by0+c3RhcnRfYWRkciArIGluZm8tPmxlbmd0aCkgPj4gUEFHRV9TSElGVDsKKwlvcC51Lm1lbV9h
ZGQucHhtID0gcHhtOworCisJcmV0dXJuIEhZUEVSVklTT1JfZG9tMF9vcCgmb3ApOworfQogCiBp
bnQgeGVuX2FjcGlfbWVtb3J5X2VuYWJsZV9kZXZpY2Uoc3RydWN0IGFjcGlfbWVtb3J5X2Rldmlj
ZSAqbWVtX2RldmljZSkKIHsKKwlpbnQgcHhtLCByZXN1bHQ7CisJaW50IG51bV9lbmFibGVkID0g
MDsKKwlzdHJ1Y3QgYWNwaV9tZW1vcnlfaW5mbyAqaW5mbzsKKworCWlmICghbWVtX2RldmljZSkK
KwkJcmV0dXJuIC1FSU5WQUw7CisKKwlweG0gPSBhY3BpX2dldF9weG0obWVtX2RldmljZS0+ZGV2
aWNlLT5oYW5kbGUpOworCWlmIChweG0gPCAwKQorCQlyZXR1cm4gLUVJTlZBTDsKKworCWxpc3Rf
Zm9yX2VhY2hfZW50cnkoaW5mbywgJm1lbV9kZXZpY2UtPnJlc19saXN0LCBsaXN0KSB7CisJCWlm
IChpbmZvLT5lbmFibGVkKSB7IC8qIGp1c3Qgc2FuaXR5IGNoZWNrLi4uKi8KKwkJCW51bV9lbmFi
bGVkKys7CisJCQljb250aW51ZTsKKwkJfQorCisJCWlmICghaW5mby0+bGVuZ3RoKQorCQkJY29u
dGludWU7CisKKwkJcmVzdWx0ID0geGVuX2hvdGFkZF9tZW1vcnkocHhtLCBpbmZvKTsKKwkJaWYg
KHJlc3VsdCkKKwkJCWNvbnRpbnVlOworCQlpbmZvLT5lbmFibGVkID0gMTsKKwkJbnVtX2VuYWJs
ZWQrKzsKKwl9CisKKwlpZiAoIW51bV9lbmFibGVkKQorCQlyZXR1cm4gLUVJTlZBTDsKKwogCXJl
dHVybiAwOwogfQogCmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0u
aCBiL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCmluZGV4IDQ3NTViNWYuLjQ1MjE1
ZDkgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCisrKyBiL2lu
Y2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oCkBAIC0zMjQsNiArMzI0LDE0IEBAIHN0cnVj
dCB4ZW5wZl9jcHVfb2wgewogfTsKIERFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbnBmX2Nw
dV9vbCk7CiAKKyNkZWZpbmUgWEVOUEZfbWVtX2hvdGFkZCAgICA1OQorc3RydWN0IHhlbnBmX21l
bV9ob3RhZGQgeworCXVpbnQ2NF90IHNwZm47CisJdWludDY0X3QgZXBmbjsKKwl1aW50MzJfdCBw
eG07CisJdWludDMyX3QgZmxhZ3M7Cit9OworCiBzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIHsKIAl1
aW50MzJfdCBjbWQ7CiAJdWludDMyX3QgaW50ZXJmYWNlX3ZlcnNpb247IC8qIFhFTlBGX0lOVEVS
RkFDRV9WRVJTSU9OICovCkBAIC0zNDEsNiArMzQ5LDcgQEAgc3RydWN0IHhlbl9wbGF0Zm9ybV9v
cCB7CiAJCXN0cnVjdCB4ZW5wZl9zZXRfcHJvY2Vzc29yX3BtaW5mbyBzZXRfcG1pbmZvOwogCQlz
dHJ1Y3QgeGVucGZfcGNwdWluZm8gICAgICAgICAgcGNwdV9pbmZvOwogCQlzdHJ1Y3QgeGVucGZf
Y3B1X29sICAgICAgICAgICAgY3B1X29sOworCQlzdHJ1Y3QgeGVucGZfbWVtX2hvdGFkZCAgICAg
ICAgbWVtX2FkZDsKIAkJdWludDhfdCAgICAgICAgICAgICAgICAgICAgICAgIHBhZFsxMjhdOwog
CX0gdTsKIH07Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC8292335394308SHSMSX101ccrcorpi_--
