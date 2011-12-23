Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1LWKaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:30:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:42085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab1LWKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:30:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="99639265"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Brown, Len" <len.brown@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/10] xen/acpi: Prepare for cpu hotplug
Thread-Topic: [PATCH 07/10] xen/acpi: Prepare for cpu hotplug
Thread-Index: AczBXcPLVEQJuPy+S66ViENeEjagAA==
Date: Fri, 23 Dec 2011 10:29:35 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335970B@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335970BSHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335970BSHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 0dad15c02d033d6be7e9447fbe5f645d97badc24 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Tue, 13 Dec 2011 21:14:45 +0800
Subject: [PATCH 07/10] xen/acpi: Prepare for cpu hotplug

This patch rebased from Jeremy's pvops commit
68320323a51c2378aca433c76157d9e66104ff1e

It does some prepare work for cpu hotplug

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/acpi/processor_xen.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_xen.c b/drivers/acpi/processor_xen.c
index 029e10c..38a1c05 100644
--- a/drivers/acpi/processor_xen.c
+++ b/drivers/acpi/processor_xen.c
@@ -19,6 +19,7 @@
 #include <acpi/acpi_drivers.h>
 #include <acpi/processor.h>
 #include <xen/acpi.h>
+#include <xen/pcpu.h>
=20
 #define PREFIX "ACPI: "
=20
@@ -54,6 +55,42 @@ struct acpi_driver xen_acpi_processor_driver =3D {
 		},
 };
=20
+static int is_processor_present(acpi_handle handle)
+{
+	acpi_status status;
+	unsigned long long sta =3D 0;
+
+
+	status =3D acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+
+	if (ACPI_SUCCESS(status) && (sta & ACPI_STA_DEVICE_PRESENT))
+		return 1;
+
+	/*
+	 * _STA is mandatory for a processor that supports hot plug
+	 */
+	if (status =3D=3D AE_NOT_FOUND)
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				"Processor does not support hot plug\n"));
+	else
+		ACPI_EXCEPTION((AE_INFO, status,
+				"Processor Device is not present"));
+	return 0;
+}
+
+static acpi_status
+xen_acpi_processor_hotadd_init(struct acpi_processor *pr, int *p_cpu)
+{
+	if (!is_processor_present(pr->handle))
+		return AE_ERROR;
+
+	if (processor_cntl_xen_notify(pr,
+				PROCESSOR_HOTPLUG, HOTPLUG_TYPE_ADD))
+		return AE_ERROR;
+
+	return AE_OK;
+}
+
 #ifdef CONFIG_CPU_FREQ
 /*
  * Existing ACPI module does parse performance states at some point,
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC8292335970BSHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0007-xen-acpi-Prepare-for-cpu-hotplug.patch"
Content-Description: 0007-xen-acpi-Prepare-for-cpu-hotplug.patch
Content-Disposition: attachment;
	filename="0007-xen-acpi-Prepare-for-cpu-hotplug.patch"; size=1986;
	creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwZGFkMTVjMDJkMDMzZDZiZTdlOTQ0N2ZiZTVmNjQ1ZDk3YmFkYzI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBUdWUsIDEzIERlYyAyMDExIDIxOjE0OjQ1ICswODAwClN1YmplY3Q6IFtQQVRDSCAwNy8x
MF0geGVuL2FjcGk6IFByZXBhcmUgZm9yIGNwdSBob3RwbHVnCgpUaGlzIHBhdGNoIHJlYmFzZWQg
ZnJvbSBKZXJlbXkncyBwdm9wcyBjb21taXQKNjgzMjAzMjNhNTFjMjM3OGFjYTQzM2M3NjE1N2Q5
ZTY2MTA0ZmYxZQoKSXQgZG9lcyBzb21lIHByZXBhcmUgd29yayBmb3IgY3B1IGhvdHBsdWcKClNp
Z25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpTaWduZWQt
b2ZmLWJ5OiBKaWFuZywgWXVuaG9uZyA8eXVuaG9uZy5qaWFuZ0BpbnRlbC5jb20+ClNpZ25lZC1v
ZmYtYnk6IEplcmVteSBGaXR6aGFyZGluZ2UgPGplcmVteS5maXR6aGFyZGluZ2VAY2l0cml4LmNv
bT4KLS0tCiBkcml2ZXJzL2FjcGkvcHJvY2Vzc29yX3hlbi5jIHwgICAzNyArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDM3IGluc2VydGlvbnMo
KyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl94
ZW4uYyBiL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfeGVuLmMKaW5kZXggMDI5ZTEwYy4uMzhhMWMw
NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl94ZW4uYworKysgYi9kcml2ZXJz
L2FjcGkvcHJvY2Vzc29yX3hlbi5jCkBAIC0xOSw2ICsxOSw3IEBACiAjaW5jbHVkZSA8YWNwaS9h
Y3BpX2RyaXZlcnMuaD4KICNpbmNsdWRlIDxhY3BpL3Byb2Nlc3Nvci5oPgogI2luY2x1ZGUgPHhl
bi9hY3BpLmg+CisjaW5jbHVkZSA8eGVuL3BjcHUuaD4KIAogI2RlZmluZSBQUkVGSVggIkFDUEk6
ICIKIApAQCAtNTQsNiArNTUsNDIgQEAgc3RydWN0IGFjcGlfZHJpdmVyIHhlbl9hY3BpX3Byb2Nl
c3Nvcl9kcml2ZXIgPSB7CiAJCX0sCiB9OwogCitzdGF0aWMgaW50IGlzX3Byb2Nlc3Nvcl9wcmVz
ZW50KGFjcGlfaGFuZGxlIGhhbmRsZSkKK3sKKwlhY3BpX3N0YXR1cyBzdGF0dXM7CisJdW5zaWdu
ZWQgbG9uZyBsb25nIHN0YSA9IDA7CisKKworCXN0YXR1cyA9IGFjcGlfZXZhbHVhdGVfaW50ZWdl
cihoYW5kbGUsICJfU1RBIiwgTlVMTCwgJnN0YSk7CisKKwlpZiAoQUNQSV9TVUNDRVNTKHN0YXR1
cykgJiYgKHN0YSAmIEFDUElfU1RBX0RFVklDRV9QUkVTRU5UKSkKKwkJcmV0dXJuIDE7CisKKwkv
KgorCSAqIF9TVEEgaXMgbWFuZGF0b3J5IGZvciBhIHByb2Nlc3NvciB0aGF0IHN1cHBvcnRzIGhv
dCBwbHVnCisJICovCisJaWYgKHN0YXR1cyA9PSBBRV9OT1RfRk9VTkQpCisJCUFDUElfREVCVUdf
UFJJTlQoKEFDUElfREJfSU5GTywKKwkJCQkiUHJvY2Vzc29yIGRvZXMgbm90IHN1cHBvcnQgaG90
IHBsdWdcbiIpKTsKKwllbHNlCisJCUFDUElfRVhDRVBUSU9OKChBRV9JTkZPLCBzdGF0dXMsCisJ
CQkJIlByb2Nlc3NvciBEZXZpY2UgaXMgbm90IHByZXNlbnQiKSk7CisJcmV0dXJuIDA7Cit9CisK
K3N0YXRpYyBhY3BpX3N0YXR1cworeGVuX2FjcGlfcHJvY2Vzc29yX2hvdGFkZF9pbml0KHN0cnVj
dCBhY3BpX3Byb2Nlc3NvciAqcHIsIGludCAqcF9jcHUpCit7CisJaWYgKCFpc19wcm9jZXNzb3Jf
cHJlc2VudChwci0+aGFuZGxlKSkKKwkJcmV0dXJuIEFFX0VSUk9SOworCisJaWYgKHByb2Nlc3Nv
cl9jbnRsX3hlbl9ub3RpZnkocHIsCisJCQkJUFJPQ0VTU09SX0hPVFBMVUcsIEhPVFBMVUdfVFlQ
RV9BREQpKQorCQlyZXR1cm4gQUVfRVJST1I7CisKKwlyZXR1cm4gQUVfT0s7Cit9CisKICNpZmRl
ZiBDT05GSUdfQ1BVX0ZSRVEKIC8qCiAgKiBFeGlzdGluZyBBQ1BJIG1vZHVsZSBkb2VzIHBhcnNl
IHBlcmZvcm1hbmNlIHN0YXRlcyBhdCBzb21lIHBvaW50LAotLSAKMS42LjUuNgoK

--_002_DE8DF0795D48FD4CA783C40EC8292335970BSHSMSX101ccrcorpint_--
