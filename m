Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2BWN3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:29:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:2112 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab2BWN3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:29:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208,223";a="111188421"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "lenb@kernel.org" <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>
Subject: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
Thread-Topic: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
Thread-Index: AczyLzHym4MGy1d3TzK01xgwJYdnxQ==
Date: Thu, 23 Feb 2012 13:29:40 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923350AD088SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923350AD088SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 9a12d7c610bffb900015e8947a57e4e428058abf Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 24 Feb 2012 01:51:18 +0800
Subject: [PATCH 1/2] Prepare PAD for native and xen platform

This patch is to prepare PAD (Processor Aggregator Device) for native and x=
en platform.
When working under baremetal it initializes native acpi_pad, while working =
under
xen platform it would hook to xen acpi_pad (would implement at later patch)=
.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 drivers/acpi/Kconfig        |    3 ++-
 drivers/acpi/acpi_pad.c     |   21 +++++++++------------
 include/acpi/acpi_drivers.h |   15 +++++++++++++++
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 7556913..2653a98 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -213,10 +213,11 @@ config ACPI_HOTPLUG_CPU
 	default y
=20
 config ACPI_PROCESSOR_AGGREGATOR
-	tristate "Processor Aggregator"
+	bool "Processor Aggregator"
 	depends on ACPI_PROCESSOR
 	depends on EXPERIMENTAL
 	depends on X86
+	default n
 	help
 	  ACPI 4.0 defines processor Aggregator, which enables OS to perform
 	  specific processor configuration and control that applies to all
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index a43fa1a..8aebbe5 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -2,6 +2,7 @@
  * acpi_pad.c ACPI Processor Aggregator Driver
  *
  * Copyright (c) 2009, Intel Corporation.
+ *    Author: Li, Shaohua <shaohua.li@intel.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -32,9 +33,6 @@
 #include <acpi/acpi_drivers.h>
 #include <asm/mwait.h>
=20
-#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
-#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
-#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
=20
 static unsigned long power_saving_mwait_eax;
@@ -510,7 +508,7 @@ static struct acpi_driver acpi_pad_driver =3D {
 	},
 };
=20
-static int __init acpi_pad_init(void)
+static int __init native_acpi_pad_init(void)
 {
 	power_saving_mwait_init();
 	if (power_saving_mwait_eax =3D=3D 0)
@@ -519,13 +517,12 @@ static int __init acpi_pad_init(void)
 	return acpi_bus_register_driver(&acpi_pad_driver);
 }
=20
-static void __exit acpi_pad_exit(void)
+struct acpi_pad_ops acpi_pad_ops =3D {
+	.init =3D native_acpi_pad_init,
+};
+
+static int __init acpi_pad_init(void)
 {
-	acpi_bus_unregister_driver(&acpi_pad_driver);
+	return acpi_pad_ops.init();
 }
-
-module_init(acpi_pad_init);
-module_exit(acpi_pad_exit);
-MODULE_AUTHOR("Shaohua Li<shaohua.li@intel.com>");
-MODULE_DESCRIPTION("ACPI Processor Aggregator Driver");
-MODULE_LICENSE("GPL");
+device_initcall(acpi_pad_init);
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index bb145e4..d40abbc 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -115,6 +115,21 @@ void pci_acpi_crs_quirks(void);
 #define ACPI_PROCESSOR_LIMIT_INCREMENT	0x01
 #define ACPI_PROCESSOR_LIMIT_DECREMENT	0x02
=20
+/* -----------------------------------------------------------------------=
---
+			PAD (Processor Aggregator Device)
+   -----------------------------------------------------------------------=
--- */
+
+#define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
+#define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
+#define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
+
+struct acpi_pad_ops {
+	int (*init)(void);
+};
+#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
+extern struct acpi_pad_ops acpi_pad_ops;
+#endif
+
 /*------------------------------------------------------------------------=
--
                                   Dock Station
   ------------------------------------------------------------------------=
-- */
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC82923350AD088SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-Prepare-PAD-for-native-and-xen-platform.patch"
Content-Description: 0001-Prepare-PAD-for-native-and-xen-platform.patch
Content-Disposition: attachment;
	filename="0001-Prepare-PAD-for-native-and-xen-platform.patch"; size=3905;
	creation-date="Thu, 23 Feb 2012 13:05:12 GMT";
	modification-date="Thu, 23 Feb 2012 20:58:38 GMT"
Content-Transfer-Encoding: base64

RnJvbSA5YTEyZDdjNjEwYmZmYjkwMDAxNWU4OTQ3YTU3ZTRlNDI4MDU4YWJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAyNCBGZWIgMjAxMiAwMTo1MToxOCArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBQcmVwYXJlIFBBRCBmb3IgbmF0aXZlIGFuZCB4ZW4gcGxhdGZvcm0KClRoaXMgcGF0Y2ggaXMg
dG8gcHJlcGFyZSBQQUQgKFByb2Nlc3NvciBBZ2dyZWdhdG9yIERldmljZSkgZm9yIG5hdGl2ZSBh
bmQgeGVuIHBsYXRmb3JtLgpXaGVuIHdvcmtpbmcgdW5kZXIgYmFyZW1ldGFsIGl0IGluaXRpYWxp
emVzIG5hdGl2ZSBhY3BpX3BhZCwgd2hpbGUgd29ya2luZyB1bmRlcgp4ZW4gcGxhdGZvcm0gaXQg
d291bGQgaG9vayB0byB4ZW4gYWNwaV9wYWQgKHdvdWxkIGltcGxlbWVudCBhdCBsYXRlciBwYXRj
aCkuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
LS0tCiBkcml2ZXJzL2FjcGkvS2NvbmZpZyAgICAgICAgfCAgICAzICsrLQogZHJpdmVycy9hY3Bp
L2FjcGlfcGFkLmMgICAgIHwgICAyMSArKysrKysrKystLS0tLS0tLS0tLS0KIGluY2x1ZGUvYWNw
aS9hY3BpX2RyaXZlcnMuaCB8ICAgMTUgKysrKysrKysrKysrKysrCiAzIGZpbGVzIGNoYW5nZWQs
IDI2IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
YWNwaS9LY29uZmlnIGIvZHJpdmVycy9hY3BpL0tjb25maWcKaW5kZXggNzU1NjkxMy4uMjY1M2E5
OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9hY3BpL0tjb25maWcKKysrIGIvZHJpdmVycy9hY3BpL0tj
b25maWcKQEAgLTIxMywxMCArMjEzLDExIEBAIGNvbmZpZyBBQ1BJX0hPVFBMVUdfQ1BVCiAJZGVm
YXVsdCB5CiAKIGNvbmZpZyBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SCi0JdHJpc3RhdGUgIlBy
b2Nlc3NvciBBZ2dyZWdhdG9yIgorCWJvb2wgIlByb2Nlc3NvciBBZ2dyZWdhdG9yIgogCWRlcGVu
ZHMgb24gQUNQSV9QUk9DRVNTT1IKIAlkZXBlbmRzIG9uIEVYUEVSSU1FTlRBTAogCWRlcGVuZHMg
b24gWDg2CisJZGVmYXVsdCBuCiAJaGVscAogCSAgQUNQSSA0LjAgZGVmaW5lcyBwcm9jZXNzb3Ig
QWdncmVnYXRvciwgd2hpY2ggZW5hYmxlcyBPUyB0byBwZXJmb3JtCiAJICBzcGVjaWZpYyBwcm9j
ZXNzb3IgY29uZmlndXJhdGlvbiBhbmQgY29udHJvbCB0aGF0IGFwcGxpZXMgdG8gYWxsCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2FjcGkvYWNwaV9wYWQuYyBiL2RyaXZlcnMvYWNwaS9hY3BpX3BhZC5j
CmluZGV4IGE0M2ZhMWEuLjhhZWJiZTUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNwaS9hY3BpX3Bh
ZC5jCisrKyBiL2RyaXZlcnMvYWNwaS9hY3BpX3BhZC5jCkBAIC0yLDYgKzIsNyBAQAogICogYWNw
aV9wYWQuYyBBQ1BJIFByb2Nlc3NvciBBZ2dyZWdhdG9yIERyaXZlcgogICoKICAqIENvcHlyaWdo
dCAoYykgMjAwOSwgSW50ZWwgQ29ycG9yYXRpb24uCisgKiAgICBBdXRob3I6IExpLCBTaGFvaHVh
IDxzaGFvaHVhLmxpQGludGVsLmNvbT4KICAqCiAgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0
d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeSBpdAogICogdW5kZXIg
dGhlIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZSwKQEAgLTMyLDkgKzMzLDYgQEAKICNpbmNsdWRlIDxhY3BpL2FjcGlfZHJpdmVycy5oPgogI2lu
Y2x1ZGUgPGFzbS9td2FpdC5oPgogCi0jZGVmaW5lIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1Jf
Q0xBU1MJImFjcGlfcGFkIgotI2RlZmluZSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX0RFVklD
RV9OQU1FICJQcm9jZXNzb3IgQWdncmVnYXRvciIKLSNkZWZpbmUgQUNQSV9QUk9DRVNTT1JfQUdH
UkVHQVRPUl9OT1RJRlkgMHg4MAogc3RhdGljIERFRklORV9NVVRFWChpc29sYXRlZF9jcHVzX2xv
Y2spOwogCiBzdGF0aWMgdW5zaWduZWQgbG9uZyBwb3dlcl9zYXZpbmdfbXdhaXRfZWF4OwpAQCAt
NTEwLDcgKzUwOCw3IEBAIHN0YXRpYyBzdHJ1Y3QgYWNwaV9kcml2ZXIgYWNwaV9wYWRfZHJpdmVy
ID0gewogCX0sCiB9OwogCi1zdGF0aWMgaW50IF9faW5pdCBhY3BpX3BhZF9pbml0KHZvaWQpCitz
dGF0aWMgaW50IF9faW5pdCBuYXRpdmVfYWNwaV9wYWRfaW5pdCh2b2lkKQogewogCXBvd2VyX3Nh
dmluZ19td2FpdF9pbml0KCk7CiAJaWYgKHBvd2VyX3NhdmluZ19td2FpdF9lYXggPT0gMCkKQEAg
LTUxOSwxMyArNTE3LDEyIEBAIHN0YXRpYyBpbnQgX19pbml0IGFjcGlfcGFkX2luaXQodm9pZCkK
IAlyZXR1cm4gYWNwaV9idXNfcmVnaXN0ZXJfZHJpdmVyKCZhY3BpX3BhZF9kcml2ZXIpOwogfQog
Ci1zdGF0aWMgdm9pZCBfX2V4aXQgYWNwaV9wYWRfZXhpdCh2b2lkKQorc3RydWN0IGFjcGlfcGFk
X29wcyBhY3BpX3BhZF9vcHMgPSB7CisJLmluaXQgPSBuYXRpdmVfYWNwaV9wYWRfaW5pdCwKK307
CisKK3N0YXRpYyBpbnQgX19pbml0IGFjcGlfcGFkX2luaXQodm9pZCkKIHsKLQlhY3BpX2J1c191
bnJlZ2lzdGVyX2RyaXZlcigmYWNwaV9wYWRfZHJpdmVyKTsKKwlyZXR1cm4gYWNwaV9wYWRfb3Bz
LmluaXQoKTsKIH0KLQotbW9kdWxlX2luaXQoYWNwaV9wYWRfaW5pdCk7Ci1tb2R1bGVfZXhpdChh
Y3BpX3BhZF9leGl0KTsKLU1PRFVMRV9BVVRIT1IoIlNoYW9odWEgTGk8c2hhb2h1YS5saUBpbnRl
bC5jb20+Iik7Ci1NT0RVTEVfREVTQ1JJUFRJT04oIkFDUEkgUHJvY2Vzc29yIEFnZ3JlZ2F0b3Ig
RHJpdmVyIik7Ci1NT0RVTEVfTElDRU5TRSgiR1BMIik7CitkZXZpY2VfaW5pdGNhbGwoYWNwaV9w
YWRfaW5pdCk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2FjcGkvYWNwaV9kcml2ZXJzLmggYi9pbmNs
dWRlL2FjcGkvYWNwaV9kcml2ZXJzLmgKaW5kZXggYmIxNDVlNC4uZDQwYWJiYyAxMDA2NDQKLS0t
IGEvaW5jbHVkZS9hY3BpL2FjcGlfZHJpdmVycy5oCisrKyBiL2luY2x1ZGUvYWNwaS9hY3BpX2Ry
aXZlcnMuaApAQCAtMTE1LDYgKzExNSwyMSBAQCB2b2lkIHBjaV9hY3BpX2Nyc19xdWlya3Modm9p
ZCk7CiAjZGVmaW5lIEFDUElfUFJPQ0VTU09SX0xJTUlUX0lOQ1JFTUVOVAkweDAxCiAjZGVmaW5l
IEFDUElfUFJPQ0VTU09SX0xJTUlUX0RFQ1JFTUVOVAkweDAyCiAKKy8qIC0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCisJCQlQQUQgKFByb2Nlc3NvciBBZ2dyZWdhdG9yIERldmljZSkKKyAgIC0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tICovCisKKyNkZWZpbmUgQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9DTEFTUwkiYWNw
aV9wYWQiCisjZGVmaW5lIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfREVWSUNFX05BTUUgIlBy
b2Nlc3NvciBBZ2dyZWdhdG9yIgorI2RlZmluZSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX05P
VElGWSAweDgwCisKK3N0cnVjdCBhY3BpX3BhZF9vcHMgeworCWludCAoKmluaXQpKHZvaWQpOwor
fTsKKyNpZmRlZiBDT05GSUdfQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUgorZXh0ZXJuIHN0cnVj
dCBhY3BpX3BhZF9vcHMgYWNwaV9wYWRfb3BzOworI2VuZGlmCisKIC8qLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBEb2NrIFN0YXRpb24KICAgLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0gKi8KLS0gCjEuNy4xCgo=

--_002_DE8DF0795D48FD4CA783C40EC82923350AD088SHSMSX101ccrcorpi_--
