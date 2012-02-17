Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab2BQI56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:57:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:45447 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab2BQI55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:57:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="118565975"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
CC: "Li, Shaohua" <shaohua.li@intel.com>, Jan Beulich <JBeulich@suse.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>
Subject: [PATCH 1/3] PAD helper for native and paravirt platform
Thread-Topic: [PATCH 1/3] PAD helper for native and paravirt platform
Thread-Index: AcztUhHG6RKQx7+6TLaQA8tFAlSyZg==
Date: Fri, 17 Feb 2012 08:56:43 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233509D853SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233509D853SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From f66a2df1392bbe69426387657a220177be50d58a Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 10 Feb 2012 20:32:50 +0800
Subject: [PATCH 1/3] PAD helper for native and paravirt platform

This patch is PAD (Processor Aggregator Device) helper.
It provides a native interface for natvie platform, and a template
for paravirt platform, so that os can implicitly hook to proper ops accordi=
ngly.
The paravirt template will further redirect to Xen pv ops in later patch fo=
r Xen
 core parking.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/include/asm/paravirt.h       |   10 +++++
 arch/x86/include/asm/paravirt_types.h |    7 ++++
 arch/x86/kernel/paravirt.c            |    9 +++++
 drivers/acpi/acpi_pad.c               |   15 +++-----
 include/acpi/acpi_pad.h               |   61 +++++++++++++++++++++++++++++=
++++
 5 files changed, 93 insertions(+), 9 deletions(-)
 create mode 100644 include/acpi/acpi_pad.h

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravir=
t.h
index a7d2db9..02e6df0 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -54,6 +54,16 @@ static inline unsigned long read_cr0(void)
 	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr0);
 }
=20
+static inline int __acpi_pad_init(void)
+{
+	return PVOP_CALL0(int, pv_pad_ops.acpi_pad_init);
+}
+
+static inline void __acpi_pad_exit(void)
+{
+	PVOP_VCALL0(pv_pad_ops.acpi_pad_exit);
+}
+
 static inline void write_cr0(unsigned long x)
 {
 	PVOP_VCALL1(pv_cpu_ops.write_cr0, x);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/p=
aravirt_types.h
index 8e8b9a4..61e20de 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -336,6 +336,11 @@ struct pv_lock_ops {
 	void (*spin_unlock)(struct arch_spinlock *lock);
 };
=20
+struct pv_pad_ops {
+	int (*acpi_pad_init)(void);
+	void (*acpi_pad_exit)(void);
+};
+
 /* This contains all the paravirt structures: we get a convenient
  * number for each function using the offset which we use to indicate
  * what to patch. */
@@ -347,6 +352,7 @@ struct paravirt_patch_template {
 	struct pv_apic_ops pv_apic_ops;
 	struct pv_mmu_ops pv_mmu_ops;
 	struct pv_lock_ops pv_lock_ops;
+	struct pv_pad_ops pv_pad_ops;
 };
=20
 extern struct pv_info pv_info;
@@ -357,6 +363,7 @@ extern struct pv_irq_ops pv_irq_ops;
 extern struct pv_apic_ops pv_apic_ops;
 extern struct pv_mmu_ops pv_mmu_ops;
 extern struct pv_lock_ops pv_lock_ops;
+extern struct pv_pad_ops pv_pad_ops;
=20
 #define PARAVIRT_PATCH(x)					\
 	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index d90272e..ec778f6 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -38,6 +38,8 @@
 #include <asm/tlbflush.h>
 #include <asm/timer.h>
=20
+#include <acpi/acpi_pad.h>
+
 /* nop stub */
 void _paravirt_nop(void)
 {
@@ -132,6 +134,7 @@ static void *get_call_destination(u8 type)
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 		.pv_lock_ops =3D pv_lock_ops,
 #endif
+		.pv_pad_ops =3D pv_pad_ops,
 	};
 	return *((void **)&tmpl + type);
 }
@@ -480,9 +483,15 @@ struct pv_mmu_ops pv_mmu_ops =3D {
 	.set_fixmap =3D native_set_fixmap,
 };
=20
+struct pv_pad_ops pv_pad_ops =3D {
+	.acpi_pad_init =3D native_acpi_pad_init,
+	.acpi_pad_exit =3D native_acpi_pad_exit,
+};
+
 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL    (pv_cpu_ops);
 EXPORT_SYMBOL    (pv_mmu_ops);
 EXPORT_SYMBOL_GPL(pv_apic_ops);
 EXPORT_SYMBOL_GPL(pv_info);
 EXPORT_SYMBOL    (pv_irq_ops);
+EXPORT_SYMBOL_GPL(pv_pad_ops);
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index a43fa1a..3f0fd27 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include <acpi/acpi_pad.h>
 #include <asm/mwait.h>
=20
 #define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
@@ -37,14 +38,14 @@
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
=20
-static unsigned long power_saving_mwait_eax;
+unsigned long power_saving_mwait_eax;
=20
 static unsigned char tsc_detected_unstable;
 static unsigned char tsc_marked_unstable;
 static unsigned char lapic_detected_unstable;
 static unsigned char lapic_marked_unstable;
=20
-static void power_saving_mwait_init(void)
+void power_saving_mwait_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int highest_cstate =3D 0;
@@ -500,7 +501,7 @@ static const struct acpi_device_id pad_device_ids[] =3D=
 {
 };
 MODULE_DEVICE_TABLE(acpi, pad_device_ids);
=20
-static struct acpi_driver acpi_pad_driver =3D {
+struct acpi_driver acpi_pad_driver =3D {
 	.name =3D "processor_aggregator",
 	.class =3D ACPI_PROCESSOR_AGGREGATOR_CLASS,
 	.ids =3D pad_device_ids,
@@ -512,16 +513,12 @@ static struct acpi_driver acpi_pad_driver =3D {
=20
 static int __init acpi_pad_init(void)
 {
-	power_saving_mwait_init();
-	if (power_saving_mwait_eax =3D=3D 0)
-		return -EINVAL;
-
-	return acpi_bus_register_driver(&acpi_pad_driver);
+	return __acpi_pad_init();
 }
=20
 static void __exit acpi_pad_exit(void)
 {
-	acpi_bus_unregister_driver(&acpi_pad_driver);
+	__acpi_pad_exit();
 }
=20
 module_init(acpi_pad_init);
diff --git a/include/acpi/acpi_pad.h b/include/acpi/acpi_pad.h
new file mode 100644
index 0000000..1a1471d
--- /dev/null
+++ b/include/acpi/acpi_pad.h
@@ -0,0 +1,61 @@
+/*
+ *  acpi_pad.h - pad device helper for native and paravirt platform
+ *
+ *  Copyright (C) 2012, Intel Corporation.
+ *     Author: Liu, Jinsong <jinsong.liu@intel.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ */
+
+#ifndef __ACPI_PAD_H__
+#define __ACPI_PAD_H__
+
+#include <acpi/acpi_bus.h>
+
+extern unsigned long power_saving_mwait_eax;
+extern struct acpi_driver acpi_pad_driver;
+extern void power_saving_mwait_init(void);
+
+static inline int native_acpi_pad_init(void)
+{
+#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
+	power_saving_mwait_init();
+	if (power_saving_mwait_eax =3D=3D 0)
+		return -EINVAL;
+
+	return acpi_bus_register_driver(&acpi_pad_driver);
+#else
+	return 0;
+#endif
+}
+
+static inline void native_acpi_pad_exit(void)
+{
+#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
+	acpi_bus_unregister_driver(&acpi_pad_driver);
+#endif
+}
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+static inline int __acpi_pad_init(void)
+{
+	return native_acpi_pad_init();
+}
+
+static inline void __acpi_pad_exit(void)
+{
+	native_acpi_pad_exit();
+}
+#endif
+
+#endif /* __ACPI_PAD_H__ */
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC829233509D853SHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0001-PAD-helper-for-native-and-paravirt-platform.patch"
Content-Description: 0001-PAD-helper-for-native-and-paravirt-platform.patch
Content-Disposition: attachment;
	filename="0001-PAD-helper-for-native-and-paravirt-platform.patch"; size=7005;
	creation-date="Fri, 17 Feb 2012 08:52:46 GMT";
	modification-date="Fri, 17 Feb 2012 16:49:16 GMT"
Content-Transfer-Encoding: base64

RnJvbSBmNjZhMmRmMTM5MmJiZTY5NDI2Mzg3NjU3YTIyMDE3N2JlNTBkNThhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAxMCBGZWIgMjAxMiAyMDozMjo1MCArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMS8z
XSBQQUQgaGVscGVyIGZvciBuYXRpdmUgYW5kIHBhcmF2aXJ0IHBsYXRmb3JtCgpUaGlzIHBhdGNo
IGlzIFBBRCAoUHJvY2Vzc29yIEFnZ3JlZ2F0b3IgRGV2aWNlKSBoZWxwZXIuCkl0IHByb3ZpZGVz
IGEgbmF0aXZlIGludGVyZmFjZSBmb3IgbmF0dmllIHBsYXRmb3JtLCBhbmQgYSB0ZW1wbGF0ZQpm
b3IgcGFyYXZpcnQgcGxhdGZvcm0sIHNvIHRoYXQgb3MgY2FuIGltcGxpY2l0bHkgaG9vayB0byBw
cm9wZXIgb3BzIGFjY29yZGluZ2x5LgpUaGUgcGFyYXZpcnQgdGVtcGxhdGUgd2lsbCBmdXJ0aGVy
IHJlZGlyZWN0IHRvIFhlbiBwdiBvcHMgaW4gbGF0ZXIgcGF0Y2ggZm9yIFhlbgogY29yZSBwYXJr
aW5nLgoKU2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+
Ci0tLQogYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQuaCAgICAgICB8ICAgMTAgKysrKysK
IGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X3R5cGVzLmggfCAgICA3ICsrKysKIGFyY2gv
eDg2L2tlcm5lbC9wYXJhdmlydC5jICAgICAgICAgICAgfCAgICA5ICsrKysrCiBkcml2ZXJzL2Fj
cGkvYWNwaV9wYWQuYyAgICAgICAgICAgICAgIHwgICAxNSArKystLS0tLQogaW5jbHVkZS9hY3Bp
L2FjcGlfcGFkLmggICAgICAgICAgICAgICB8ICAgNjEgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrCiA1IGZpbGVzIGNoYW5nZWQsIDkzIGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25z
KC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgaW5jbHVkZS9hY3BpL2FjcGlfcGFkLmgKCmRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydC5oIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vcGFyYXZpcnQuaAppbmRleCBhN2QyZGI5Li4wMmU2ZGYwIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9wYXJhdmlydC5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2
aXJ0LmgKQEAgLTU0LDYgKzU0LDE2IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9uZyByZWFk
X2NyMCh2b2lkKQogCXJldHVybiBQVk9QX0NBTEwwKHVuc2lnbmVkIGxvbmcsIHB2X2NwdV9vcHMu
cmVhZF9jcjApOwogfQogCitzdGF0aWMgaW5saW5lIGludCBfX2FjcGlfcGFkX2luaXQodm9pZCkK
K3sKKwlyZXR1cm4gUFZPUF9DQUxMMChpbnQsIHB2X3BhZF9vcHMuYWNwaV9wYWRfaW5pdCk7Cit9
CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBfX2FjcGlfcGFkX2V4aXQodm9pZCkKK3sKKwlQVk9QX1ZD
QUxMMChwdl9wYWRfb3BzLmFjcGlfcGFkX2V4aXQpOworfQorCiBzdGF0aWMgaW5saW5lIHZvaWQg
d3JpdGVfY3IwKHVuc2lnbmVkIGxvbmcgeCkKIHsKIAlQVk9QX1ZDQUxMMShwdl9jcHVfb3BzLndy
aXRlX2NyMCwgeCk7CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF90
eXBlcy5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnRfdHlwZXMuaAppbmRleCA4ZThi
OWE0Li42MWUyMGRlIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF90
eXBlcy5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X3R5cGVzLmgKQEAgLTMz
Niw2ICszMzYsMTEgQEAgc3RydWN0IHB2X2xvY2tfb3BzIHsKIAl2b2lkICgqc3Bpbl91bmxvY2sp
KHN0cnVjdCBhcmNoX3NwaW5sb2NrICpsb2NrKTsKIH07CiAKK3N0cnVjdCBwdl9wYWRfb3BzIHsK
KwlpbnQgKCphY3BpX3BhZF9pbml0KSh2b2lkKTsKKwl2b2lkICgqYWNwaV9wYWRfZXhpdCkodm9p
ZCk7Cit9OworCiAvKiBUaGlzIGNvbnRhaW5zIGFsbCB0aGUgcGFyYXZpcnQgc3RydWN0dXJlczog
d2UgZ2V0IGEgY29udmVuaWVudAogICogbnVtYmVyIGZvciBlYWNoIGZ1bmN0aW9uIHVzaW5nIHRo
ZSBvZmZzZXQgd2hpY2ggd2UgdXNlIHRvIGluZGljYXRlCiAgKiB3aGF0IHRvIHBhdGNoLiAqLwpA
QCAtMzQ3LDYgKzM1Miw3IEBAIHN0cnVjdCBwYXJhdmlydF9wYXRjaF90ZW1wbGF0ZSB7CiAJc3Ry
dWN0IHB2X2FwaWNfb3BzIHB2X2FwaWNfb3BzOwogCXN0cnVjdCBwdl9tbXVfb3BzIHB2X21tdV9v
cHM7CiAJc3RydWN0IHB2X2xvY2tfb3BzIHB2X2xvY2tfb3BzOworCXN0cnVjdCBwdl9wYWRfb3Bz
IHB2X3BhZF9vcHM7CiB9OwogCiBleHRlcm4gc3RydWN0IHB2X2luZm8gcHZfaW5mbzsKQEAgLTM1
Nyw2ICszNjMsNyBAQCBleHRlcm4gc3RydWN0IHB2X2lycV9vcHMgcHZfaXJxX29wczsKIGV4dGVy
biBzdHJ1Y3QgcHZfYXBpY19vcHMgcHZfYXBpY19vcHM7CiBleHRlcm4gc3RydWN0IHB2X21tdV9v
cHMgcHZfbW11X29wczsKIGV4dGVybiBzdHJ1Y3QgcHZfbG9ja19vcHMgcHZfbG9ja19vcHM7Citl
eHRlcm4gc3RydWN0IHB2X3BhZF9vcHMgcHZfcGFkX29wczsKIAogI2RlZmluZSBQQVJBVklSVF9Q
QVRDSCh4KQkJCQkJXAogCShvZmZzZXRvZihzdHJ1Y3QgcGFyYXZpcnRfcGF0Y2hfdGVtcGxhdGUs
IHgpIC8gc2l6ZW9mKHZvaWQgKikpCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvcGFyYXZp
cnQuYyBiL2FyY2gveDg2L2tlcm5lbC9wYXJhdmlydC5jCmluZGV4IGQ5MDI3MmUuLmVjNzc4ZjYg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9wYXJhdmlydC5jCisrKyBiL2FyY2gveDg2L2tl
cm5lbC9wYXJhdmlydC5jCkBAIC0zOCw2ICszOCw4IEBACiAjaW5jbHVkZSA8YXNtL3RsYmZsdXNo
Lmg+CiAjaW5jbHVkZSA8YXNtL3RpbWVyLmg+CiAKKyNpbmNsdWRlIDxhY3BpL2FjcGlfcGFkLmg+
CisKIC8qIG5vcCBzdHViICovCiB2b2lkIF9wYXJhdmlydF9ub3Aodm9pZCkKIHsKQEAgLTEzMiw2
ICsxMzQsNyBAQCBzdGF0aWMgdm9pZCAqZ2V0X2NhbGxfZGVzdGluYXRpb24odTggdHlwZSkKICNp
ZmRlZiBDT05GSUdfUEFSQVZJUlRfU1BJTkxPQ0tTCiAJCS5wdl9sb2NrX29wcyA9IHB2X2xvY2tf
b3BzLAogI2VuZGlmCisJCS5wdl9wYWRfb3BzID0gcHZfcGFkX29wcywKIAl9OwogCXJldHVybiAq
KCh2b2lkICoqKSZ0bXBsICsgdHlwZSk7CiB9CkBAIC00ODAsOSArNDgzLDE1IEBAIHN0cnVjdCBw
dl9tbXVfb3BzIHB2X21tdV9vcHMgPSB7CiAJLnNldF9maXhtYXAgPSBuYXRpdmVfc2V0X2ZpeG1h
cCwKIH07CiAKK3N0cnVjdCBwdl9wYWRfb3BzIHB2X3BhZF9vcHMgPSB7CisJLmFjcGlfcGFkX2lu
aXQgPSBuYXRpdmVfYWNwaV9wYWRfaW5pdCwKKwkuYWNwaV9wYWRfZXhpdCA9IG5hdGl2ZV9hY3Bp
X3BhZF9leGl0LAorfTsKKwogRVhQT1JUX1NZTUJPTF9HUEwocHZfdGltZV9vcHMpOwogRVhQT1JU
X1NZTUJPTCAgICAocHZfY3B1X29wcyk7CiBFWFBPUlRfU1lNQk9MICAgIChwdl9tbXVfb3BzKTsK
IEVYUE9SVF9TWU1CT0xfR1BMKHB2X2FwaWNfb3BzKTsKIEVYUE9SVF9TWU1CT0xfR1BMKHB2X2lu
Zm8pOwogRVhQT1JUX1NZTUJPTCAgICAocHZfaXJxX29wcyk7CitFWFBPUlRfU1lNQk9MX0dQTChw
dl9wYWRfb3BzKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9hY3BpX3BhZC5jIGIvZHJpdmVy
cy9hY3BpL2FjcGlfcGFkLmMKaW5kZXggYTQzZmExYS4uM2YwZmQyNyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9hY3BpL2FjcGlfcGFkLmMKKysrIGIvZHJpdmVycy9hY3BpL2FjcGlfcGFkLmMKQEAgLTMw
LDYgKzMwLDcgQEAKICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CiAjaW5jbHVkZSA8YWNwaS9hY3Bp
X2J1cy5oPgogI2luY2x1ZGUgPGFjcGkvYWNwaV9kcml2ZXJzLmg+CisjaW5jbHVkZSA8YWNwaS9h
Y3BpX3BhZC5oPgogI2luY2x1ZGUgPGFzbS9td2FpdC5oPgogCiAjZGVmaW5lIEFDUElfUFJPQ0VT
U09SX0FHR1JFR0FUT1JfQ0xBU1MJImFjcGlfcGFkIgpAQCAtMzcsMTQgKzM4LDE0IEBACiAjZGVm
aW5lIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfTk9USUZZIDB4ODAKIHN0YXRpYyBERUZJTkVf
TVVURVgoaXNvbGF0ZWRfY3B1c19sb2NrKTsKIAotc3RhdGljIHVuc2lnbmVkIGxvbmcgcG93ZXJf
c2F2aW5nX213YWl0X2VheDsKK3Vuc2lnbmVkIGxvbmcgcG93ZXJfc2F2aW5nX213YWl0X2VheDsK
IAogc3RhdGljIHVuc2lnbmVkIGNoYXIgdHNjX2RldGVjdGVkX3Vuc3RhYmxlOwogc3RhdGljIHVu
c2lnbmVkIGNoYXIgdHNjX21hcmtlZF91bnN0YWJsZTsKIHN0YXRpYyB1bnNpZ25lZCBjaGFyIGxh
cGljX2RldGVjdGVkX3Vuc3RhYmxlOwogc3RhdGljIHVuc2lnbmVkIGNoYXIgbGFwaWNfbWFya2Vk
X3Vuc3RhYmxlOwogCi1zdGF0aWMgdm9pZCBwb3dlcl9zYXZpbmdfbXdhaXRfaW5pdCh2b2lkKQor
dm9pZCBwb3dlcl9zYXZpbmdfbXdhaXRfaW5pdCh2b2lkKQogewogCXVuc2lnbmVkIGludCBlYXgs
IGVieCwgZWN4LCBlZHg7CiAJdW5zaWduZWQgaW50IGhpZ2hlc3RfY3N0YXRlID0gMDsKQEAgLTUw
MCw3ICs1MDEsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGFjcGlfZGV2aWNlX2lkIHBhZF9kZXZp
Y2VfaWRzW10gPSB7CiB9OwogTU9EVUxFX0RFVklDRV9UQUJMRShhY3BpLCBwYWRfZGV2aWNlX2lk
cyk7CiAKLXN0YXRpYyBzdHJ1Y3QgYWNwaV9kcml2ZXIgYWNwaV9wYWRfZHJpdmVyID0geworc3Ry
dWN0IGFjcGlfZHJpdmVyIGFjcGlfcGFkX2RyaXZlciA9IHsKIAkubmFtZSA9ICJwcm9jZXNzb3Jf
YWdncmVnYXRvciIsCiAJLmNsYXNzID0gQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9DTEFTUywK
IAkuaWRzID0gcGFkX2RldmljZV9pZHMsCkBAIC01MTIsMTYgKzUxMywxMiBAQCBzdGF0aWMgc3Ry
dWN0IGFjcGlfZHJpdmVyIGFjcGlfcGFkX2RyaXZlciA9IHsKIAogc3RhdGljIGludCBfX2luaXQg
YWNwaV9wYWRfaW5pdCh2b2lkKQogewotCXBvd2VyX3NhdmluZ19td2FpdF9pbml0KCk7Ci0JaWYg
KHBvd2VyX3NhdmluZ19td2FpdF9lYXggPT0gMCkKLQkJcmV0dXJuIC1FSU5WQUw7Ci0KLQlyZXR1
cm4gYWNwaV9idXNfcmVnaXN0ZXJfZHJpdmVyKCZhY3BpX3BhZF9kcml2ZXIpOworCXJldHVybiBf
X2FjcGlfcGFkX2luaXQoKTsKIH0KIAogc3RhdGljIHZvaWQgX19leGl0IGFjcGlfcGFkX2V4aXQo
dm9pZCkKIHsKLQlhY3BpX2J1c191bnJlZ2lzdGVyX2RyaXZlcigmYWNwaV9wYWRfZHJpdmVyKTsK
KwlfX2FjcGlfcGFkX2V4aXQoKTsKIH0KIAogbW9kdWxlX2luaXQoYWNwaV9wYWRfaW5pdCk7CmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2FjcGkvYWNwaV9wYWQuaCBiL2luY2x1ZGUvYWNwaS9hY3BpX3Bh
ZC5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjFhMTQ3MWQKLS0tIC9kZXYv
bnVsbAorKysgYi9pbmNsdWRlL2FjcGkvYWNwaV9wYWQuaApAQCAtMCwwICsxLDYxIEBACisvKgor
ICogIGFjcGlfcGFkLmggLSBwYWQgZGV2aWNlIGhlbHBlciBmb3IgbmF0aXZlIGFuZCBwYXJhdmly
dCBwbGF0Zm9ybQorICoKKyAqICBDb3B5cmlnaHQgKEMpIDIwMTIsIEludGVsIENvcnBvcmF0aW9u
LgorICogICAgIEF1dGhvcjogTGl1LCBKaW5zb25nIDxqaW5zb25nLmxpdUBpbnRlbC5jb20+Cisg
KgorICogIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0
ZSBpdCBhbmQvb3IgbW9kaWZ5CisgKiAgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKKyAqICB0aGUgRnJlZSBTb2Z0d2Fy
ZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQKKyAq
ICB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCisgKgorICogIFRoaXMgcHJvZ3JhbSBp
cyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQKKyAq
ICBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5
IG9mCisgKiAgTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQ
T1NFLiAgU2VlIHRoZSBHTlUKKyAqICBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRl
dGFpbHMuCisgKi8KKworI2lmbmRlZiBfX0FDUElfUEFEX0hfXworI2RlZmluZSBfX0FDUElfUEFE
X0hfXworCisjaW5jbHVkZSA8YWNwaS9hY3BpX2J1cy5oPgorCitleHRlcm4gdW5zaWduZWQgbG9u
ZyBwb3dlcl9zYXZpbmdfbXdhaXRfZWF4OworZXh0ZXJuIHN0cnVjdCBhY3BpX2RyaXZlciBhY3Bp
X3BhZF9kcml2ZXI7CitleHRlcm4gdm9pZCBwb3dlcl9zYXZpbmdfbXdhaXRfaW5pdCh2b2lkKTsK
Kworc3RhdGljIGlubGluZSBpbnQgbmF0aXZlX2FjcGlfcGFkX2luaXQodm9pZCkKK3sKKyNpZmRl
ZiBDT05GSUdfQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUgorCXBvd2VyX3NhdmluZ19td2FpdF9p
bml0KCk7CisJaWYgKHBvd2VyX3NhdmluZ19td2FpdF9lYXggPT0gMCkKKwkJcmV0dXJuIC1FSU5W
QUw7CisKKwlyZXR1cm4gYWNwaV9idXNfcmVnaXN0ZXJfZHJpdmVyKCZhY3BpX3BhZF9kcml2ZXIp
OworI2Vsc2UKKwlyZXR1cm4gMDsKKyNlbmRpZgorfQorCitzdGF0aWMgaW5saW5lIHZvaWQgbmF0
aXZlX2FjcGlfcGFkX2V4aXQodm9pZCkKK3sKKyNpZmRlZiBDT05GSUdfQUNQSV9QUk9DRVNTT1Jf
QUdHUkVHQVRPUgorCWFjcGlfYnVzX3VucmVnaXN0ZXJfZHJpdmVyKCZhY3BpX3BhZF9kcml2ZXIp
OworI2VuZGlmCit9CisKKyNpZmRlZiBDT05GSUdfUEFSQVZJUlQKKyNpbmNsdWRlIDxhc20vcGFy
YXZpcnQuaD4KKyNlbHNlCitzdGF0aWMgaW5saW5lIGludCBfX2FjcGlfcGFkX2luaXQodm9pZCkK
K3sKKwlyZXR1cm4gbmF0aXZlX2FjcGlfcGFkX2luaXQoKTsKK30KKworc3RhdGljIGlubGluZSB2
b2lkIF9fYWNwaV9wYWRfZXhpdCh2b2lkKQoreworCW5hdGl2ZV9hY3BpX3BhZF9leGl0KCk7Cit9
CisjZW5kaWYKKworI2VuZGlmIC8qIF9fQUNQSV9QQURfSF9fICovCi0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC829233509D853SHSMSX101ccrcorpi_--
