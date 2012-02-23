Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab2BWNdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:33:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:61472 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab2BWNc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:32:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208,223";a="113984375"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "lenb@kernel.org" <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>
Subject: [PATCH 2/2] RFC: Xen pad logic
Thread-Topic: [PATCH 2/2] RFC: Xen pad logic
Thread-Index: AczyL3DEMCwSvW3aReGRFhHGH2lzkA==
Date: Thu, 23 Feb 2012 13:31:25 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923350AD0A6@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923350AD0A6SHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923350AD0A6SHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From ba9abf6ee7e5fe0515e2d51b14743c8d5416285c Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 24 Feb 2012 02:18:02 +0800
Subject: [PATCH 2/2] Xen pad logic

This patch implement Xen pad logic, and when getting pad device
notification, it hypercalls to Xen hypervisor for core parking.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
---
 arch/x86/xen/enlighten.c         |    2 +
 arch/x86/xen/xen-ops.h           |    1 +
 drivers/xen/Makefile             |    1 +
 drivers/xen/xen_acpi_pad.c       |  190 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   14 +++
 5 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen_acpi_pad.c

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 12eb07b..3cce71f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1133,6 +1133,8 @@ asmlinkage void __init xen_start_kernel(void)
=20
 	xen_init_time_ops();
=20
+	xen_init_pad_ops();
+
 	/*
 	 * Set up some pagetable state before starting to set any ptes.
 	 */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index b095739..7eee651 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -54,6 +54,7 @@ void xen_teardown_timer(int cpu);
 cycle_t xen_clocksource_read(void);
 void xen_setup_cpu_clockevents(void);
 void __init xen_init_time_ops(void);
+void __init xen_init_pad_ops(void);
 void __init xen_hvm_init_time_ops(void);
=20
 irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index aa31337..c0268c9 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)			+=3D pci.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
+obj-$(CONFIG_XEN_DOM0)			+=3D xen_acpi_pad.o
=20
 xen-evtchn-y				:=3D evtchn.o
 xen-gntdev-y				:=3D gntdev.o
diff --git a/drivers/xen/xen_acpi_pad.c b/drivers/xen/xen_acpi_pad.c
new file mode 100644
index 0000000..4a1f2f7
--- /dev/null
+++ b/drivers/xen/xen_acpi_pad.c
@@ -0,0 +1,190 @@
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
+	.name =3D "processor_aggregator",
+	.class =3D ACPI_PROCESSOR_AGGREGATOR_CLASS,
+	.ids =3D xen_pad_device_ids,
+	.ops =3D {
+		.add =3D xen_acpi_pad_add,
+		.remove =3D xen_acpi_pad_remove,
+	},
+};
+
+static int __init xen_acpi_pad_init(void)
+{
+	return acpi_bus_register_driver(&xen_acpi_pad_driver);
+}
+
+void __init xen_init_pad_ops(void)
+{
+#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
+	acpi_pad_ops.init =3D xen_acpi_pad_init;
+#endif
+}
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

--_002_DE8DF0795D48FD4CA783C40EC82923350AD0A6SHSMSX101ccrcorpi_
Content-Type: application/octet-stream; name="0002-Xen-pad-logic.patch"
Content-Description: 0002-Xen-pad-logic.patch
Content-Disposition: attachment; filename="0002-Xen-pad-logic.patch";
	size=7954; creation-date="Thu, 23 Feb 2012 13:05:12 GMT";
	modification-date="Thu, 23 Feb 2012 20:58:38 GMT"
Content-Transfer-Encoding: base64

RnJvbSBiYTlhYmY2ZWU3ZTVmZTA1MTVlMmQ1MWIxNDc0M2M4ZDU0MTYyODVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAyNCBGZWIgMjAxMiAwMjoxODowMiArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBYZW4gcGFkIGxvZ2ljCgpUaGlzIHBhdGNoIGltcGxlbWVudCBYZW4gcGFkIGxvZ2ljLCBhbmQg
d2hlbiBnZXR0aW5nIHBhZCBkZXZpY2UKbm90aWZpY2F0aW9uLCBpdCBoeXBlcmNhbGxzIHRvIFhl
biBoeXBlcnZpc29yIGZvciBjb3JlIHBhcmtpbmcuCgpTaWduZWQtb2ZmLWJ5OiBMaXUsIEppbnNv
bmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4KLS0tCiBhcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMg
ICAgICAgICB8ICAgIDIgKwogYXJjaC94ODYveGVuL3hlbi1vcHMuaCAgICAgICAgICAgfCAgICAx
ICsKIGRyaXZlcnMveGVuL01ha2VmaWxlICAgICAgICAgICAgIHwgICAgMSArCiBkcml2ZXJzL3hl
bi94ZW5fYWNwaV9wYWQuYyAgICAgICB8ICAxOTAgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysKIGluY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oIHwgICAxNCArKysK
IDUgZmlsZXMgY2hhbmdlZCwgMjA4IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCiBjcmVh
dGUgbW9kZSAxMDA2NDQgZHJpdmVycy94ZW4veGVuX2FjcGlfcGFkLmMKCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni94ZW4vZW5saWdodGVuLmMgYi9hcmNoL3g4Ni94ZW4vZW5saWdodGVuLmMKaW5kZXgg
MTJlYjA3Yi4uM2NjZTcxZiAxMDA2NDQKLS0tIGEvYXJjaC94ODYveGVuL2VubGlnaHRlbi5jCisr
KyBiL2FyY2gveDg2L3hlbi9lbmxpZ2h0ZW4uYwpAQCAtMTEzMyw2ICsxMTMzLDggQEAgYXNtbGlu
a2FnZSB2b2lkIF9faW5pdCB4ZW5fc3RhcnRfa2VybmVsKHZvaWQpCiAKIAl4ZW5faW5pdF90aW1l
X29wcygpOwogCisJeGVuX2luaXRfcGFkX29wcygpOworCiAJLyoKIAkgKiBTZXQgdXAgc29tZSBw
YWdldGFibGUgc3RhdGUgYmVmb3JlIHN0YXJ0aW5nIHRvIHNldCBhbnkgcHRlcy4KIAkgKi8KZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L3hlbi94ZW4tb3BzLmggYi9hcmNoL3g4Ni94ZW4veGVuLW9wcy5o
CmluZGV4IGIwOTU3MzkuLjdlZWU2NTEgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3hlbi94ZW4tb3Bz
LmgKKysrIGIvYXJjaC94ODYveGVuL3hlbi1vcHMuaApAQCAtNTQsNiArNTQsNyBAQCB2b2lkIHhl
bl90ZWFyZG93bl90aW1lcihpbnQgY3B1KTsKIGN5Y2xlX3QgeGVuX2Nsb2Nrc291cmNlX3JlYWQo
dm9pZCk7CiB2b2lkIHhlbl9zZXR1cF9jcHVfY2xvY2tldmVudHModm9pZCk7CiB2b2lkIF9faW5p
dCB4ZW5faW5pdF90aW1lX29wcyh2b2lkKTsKK3ZvaWQgX19pbml0IHhlbl9pbml0X3BhZF9vcHMo
dm9pZCk7CiB2b2lkIF9faW5pdCB4ZW5faHZtX2luaXRfdGltZV9vcHModm9pZCk7CiAKIGlycXJl
dHVybl90IHhlbl9kZWJ1Z19pbnRlcnJ1cHQoaW50IGlycSwgdm9pZCAqZGV2X2lkKTsKZGlmZiAt
LWdpdCBhL2RyaXZlcnMveGVuL01ha2VmaWxlIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKaW5kZXgg
YWEzMTMzNy4uYzAyNjhjOSAxMDA2NDQKLS0tIGEvZHJpdmVycy94ZW4vTWFrZWZpbGUKKysrIGIv
ZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAgLTIwLDYgKzIwLDcgQEAgb2JqLSQoQ09ORklHX1NXSU9U
TEJfWEVOKQkJKz0gc3dpb3RsYi14ZW4ubwogb2JqLSQoQ09ORklHX1hFTl9ET00wKQkJCSs9IHBj
aS5vCiBvYmotJChDT05GSUdfWEVOX1BDSURFVl9CQUNLRU5EKQkrPSB4ZW4tcGNpYmFjay8KIG9i
ai0kKENPTkZJR19YRU5fUFJJVkNNRCkJCSs9IHhlbi1wcml2Y21kLm8KK29iai0kKENPTkZJR19Y
RU5fRE9NMCkJCQkrPSB4ZW5fYWNwaV9wYWQubwogCiB4ZW4tZXZ0Y2huLXkJCQkJOj0gZXZ0Y2hu
Lm8KIHhlbi1nbnRkZXYteQkJCQk6PSBnbnRkZXYubwpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4v
eGVuX2FjcGlfcGFkLmMgYi9kcml2ZXJzL3hlbi94ZW5fYWNwaV9wYWQuYwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwLi40YTFmMmY3Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy94ZW4veGVuX2FjcGlfcGFkLmMKQEAgLTAsMCArMSwxOTAgQEAKKy8qCisgKiB4ZW5fYWNwaV9w
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
Y3BpL2FjcGlfZHJpdmVycy5oPgorCisjaW5jbHVkZSA8YXNtL3hlbi9oeXBlcmNhbGwuaD4KKwor
c3RhdGljIERFRklORV9NVVRFWCh4ZW5fY3B1X2xvY2spOworCitzdGF0aWMgaW50IHhlbl9hY3Bp
X3BhZF9pZGxlX2NwdXMoaW50ICpudW1fY3B1cykKK3sKKwlpbnQgcmV0OworCisJc3RydWN0IHhl
bl9wbGF0Zm9ybV9vcCBvcCA9IHsKKwkJLmNtZCA9IFhFTlBGX2NvcmVfcGFya2luZywKKwkJLmlu
dGVyZmFjZV92ZXJzaW9uID0gWEVOUEZfSU5URVJGQUNFX1ZFUlNJT04sCisJfTsKKworCS8qIHNl
dCBjcHUgbnVtcyBleHBlY3RlZCB0byBiZSBpZGxlZCAqLworCW9wLnUuY29yZV9wYXJraW5nLnR5
cGUgPSBYRU5fQ09SRV9QQVJLSU5HX1NFVDsKKwlvcC51LmNvcmVfcGFya2luZy5pZGxlX251bXMg
PSAodWludDMyX3QpKm51bV9jcHVzOworCXJldCA9IEhZUEVSVklTT1JfZG9tMF9vcCgmb3ApOwor
CWlmIChyZXQpCisJCXJldHVybiByZXQ7CisKKwkvKgorCSAqIGdldCBjcHUgbnVtcyBhY3R1YWxs
eSBiZSBpZGxlZAorCSAqIGNhbm5vdCBnZXQgaXQgYnkgdXNpbmcgaHlwZXJjYWxsIG9uY2UgKHNo
YXJlZCB3aXRoIF9TRVQpCisJICogYmVjYXVzZSBvZiB0aGUgY2hhcmFjdGVyaXN0aWMgb2YgWGVu
IGNvbnRpbnVlX2h5cGVyY2FsbF9vbl9jcHUKKwkgKi8KKwlvcC51LmNvcmVfcGFya2luZy50eXBl
ID0gWEVOX0NPUkVfUEFSS0lOR19HRVQ7CisJcmV0ID0gSFlQRVJWSVNPUl9kb20wX29wKCZvcCk7
CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKworCSpudW1fY3B1cyA9IG9wLnUuY29yZV9wYXJr
aW5nLmlkbGVfbnVtczsKKwlyZXR1cm4gMDsKK30KKworLyoKKyAqIFF1ZXJ5IGZpcm13YXJlIGhv
dyBtYW55IENQVXMgc2hvdWxkIGJlIGlkbGUKKyAqIHJldHVybiAtMSBvbiBmYWlsdXJlCisgKi8K
K3N0YXRpYyBpbnQgeGVuX2FjcGlfcGFkX3B1cihhY3BpX2hhbmRsZSBoYW5kbGUpCit7CisJc3Ry
dWN0IGFjcGlfYnVmZmVyIGJ1ZmZlciA9IHtBQ1BJX0FMTE9DQVRFX0JVRkZFUiwgTlVMTH07CisJ
dW5pb24gYWNwaV9vYmplY3QgKnBhY2thZ2U7CisJaW50IG51bSA9IC0xOworCisJaWYgKEFDUElf
RkFJTFVSRShhY3BpX2V2YWx1YXRlX29iamVjdChoYW5kbGUsICJfUFVSIiwgTlVMTCwgJmJ1ZmZl
cikpKQorCQlyZXR1cm4gbnVtOworCisJaWYgKCFidWZmZXIubGVuZ3RoIHx8ICFidWZmZXIucG9p
bnRlcikKKwkJcmV0dXJuIG51bTsKKworCXBhY2thZ2UgPSBidWZmZXIucG9pbnRlcjsKKworCWlm
IChwYWNrYWdlLT50eXBlID09IEFDUElfVFlQRV9QQUNLQUdFICYmCisJCXBhY2thZ2UtPnBhY2th
Z2UuY291bnQgPT0gMiAmJgorCQlwYWNrYWdlLT5wYWNrYWdlLmVsZW1lbnRzWzBdLmludGVnZXIu
dmFsdWUgPT0gMSkgLyogcmV2IDEgKi8KKworCQludW0gPSBwYWNrYWdlLT5wYWNrYWdlLmVsZW1l
bnRzWzFdLmludGVnZXIudmFsdWU7CisKKwlrZnJlZShidWZmZXIucG9pbnRlcik7CisJcmV0dXJu
IG51bTsKK30KKworLyogTm90aWZ5IGZpcm13YXJlIGhvdyBtYW55IENQVXMgYXJlIGlkbGUgKi8K
K3N0YXRpYyB2b2lkIHhlbl9hY3BpX3BhZF9vc3QoYWNwaV9oYW5kbGUgaGFuZGxlLCBpbnQgc3Rh
dCwKKwl1aW50MzJfdCBpZGxlX2NwdXMpCit7CisJdW5pb24gYWNwaV9vYmplY3QgcGFyYW1zWzNd
ID0geworCQl7LnR5cGUgPSBBQ1BJX1RZUEVfSU5URUdFUix9LAorCQl7LnR5cGUgPSBBQ1BJX1RZ
UEVfSU5URUdFUix9LAorCQl7LnR5cGUgPSBBQ1BJX1RZUEVfQlVGRkVSLH0sCisJfTsKKwlzdHJ1
Y3QgYWNwaV9vYmplY3RfbGlzdCBhcmdfbGlzdCA9IHszLCBwYXJhbXN9OworCisJcGFyYW1zWzBd
LmludGVnZXIudmFsdWUgPSBBQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SX05PVElGWTsKKwlwYXJh
bXNbMV0uaW50ZWdlci52YWx1ZSA9ICBzdGF0OworCXBhcmFtc1syXS5idWZmZXIubGVuZ3RoID0g
NDsKKwlwYXJhbXNbMl0uYnVmZmVyLnBvaW50ZXIgPSAodm9pZCAqKSZpZGxlX2NwdXM7CisJYWNw
aV9ldmFsdWF0ZV9vYmplY3QoaGFuZGxlLCAiX09TVCIsICZhcmdfbGlzdCwgTlVMTCk7Cit9CisK
K3N0YXRpYyB2b2lkIHhlbl9hY3BpX3BhZF9oYW5kbGVfbm90aWZ5KGFjcGlfaGFuZGxlIGhhbmRs
ZSkKK3sKKwlpbnQgcmV0LCBudW1fY3B1czsKKworCW11dGV4X2xvY2soJnhlbl9jcHVfbG9jayk7
CisJbnVtX2NwdXMgPSB4ZW5fYWNwaV9wYWRfcHVyKGhhbmRsZSk7CisJaWYgKG51bV9jcHVzIDwg
MCkgeworCQltdXRleF91bmxvY2soJnhlbl9jcHVfbG9jayk7CisJCXJldHVybjsKKwl9CisKKwly
ZXQgPSB4ZW5fYWNwaV9wYWRfaWRsZV9jcHVzKCZudW1fY3B1cyk7CisJaWYgKHJldCkgeworCQlt
dXRleF91bmxvY2soJnhlbl9jcHVfbG9jayk7CisJCXJldHVybjsKKwl9CisKKwl4ZW5fYWNwaV9w
YWRfb3N0KGhhbmRsZSwgMCwgbnVtX2NwdXMpOworCW11dGV4X3VubG9jaygmeGVuX2NwdV9sb2Nr
KTsKK30KKworc3RhdGljIHZvaWQgeGVuX2FjcGlfcGFkX25vdGlmeShhY3BpX2hhbmRsZSBoYW5k
bGUsIHUzMiBldmVudCwKKwl2b2lkICpkYXRhKQoreworCXN3aXRjaCAoZXZlbnQpIHsKKwljYXNl
IEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfTk9USUZZOgorCQl4ZW5fYWNwaV9wYWRfaGFuZGxl
X25vdGlmeShoYW5kbGUpOworCQlicmVhazsKKwlkZWZhdWx0OgorCQlwcmludGsoS0VSTl9XQVJO
SU5HICJVbnN1cHBvcnRlZCBldmVudCBbMHgleF1cbiIsIGV2ZW50KTsKKwkJYnJlYWs7CisJfQor
fQorCitzdGF0aWMgaW50IHhlbl9hY3BpX3BhZF9hZGQoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZp
Y2UpCit7CisJYWNwaV9zdGF0dXMgc3RhdHVzOworCisJc3RyY3B5KGFjcGlfZGV2aWNlX25hbWUo
ZGV2aWNlKSwgQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUl9ERVZJQ0VfTkFNRSk7CisJc3RyY3B5
KGFjcGlfZGV2aWNlX2NsYXNzKGRldmljZSksIEFDUElfUFJPQ0VTU09SX0FHR1JFR0FUT1JfQ0xB
U1MpOworCisJc3RhdHVzID0gYWNwaV9pbnN0YWxsX25vdGlmeV9oYW5kbGVyKGRldmljZS0+aGFu
ZGxlLAorCQkgQUNQSV9ERVZJQ0VfTk9USUZZLCB4ZW5fYWNwaV9wYWRfbm90aWZ5LCBkZXZpY2Up
OworCWlmIChBQ1BJX0ZBSUxVUkUoc3RhdHVzKSkKKwkJcmV0dXJuIC1FTk9ERVY7CisKKwlyZXR1
cm4gMDsKK30KKworc3RhdGljIGludCB4ZW5fYWNwaV9wYWRfcmVtb3ZlKHN0cnVjdCBhY3BpX2Rl
dmljZSAqZGV2aWNlLAorCWludCB0eXBlKQoreworCWludCBudW1fY3B1cyA9IDA7CisKKwltdXRl
eF9sb2NrKCZ4ZW5fY3B1X2xvY2spOworCXhlbl9hY3BpX3BhZF9pZGxlX2NwdXMoJm51bV9jcHVz
KTsKKwltdXRleF91bmxvY2soJnhlbl9jcHVfbG9jayk7CisKKwlhY3BpX3JlbW92ZV9ub3RpZnlf
aGFuZGxlcihkZXZpY2UtPmhhbmRsZSwKKwkJQUNQSV9ERVZJQ0VfTk9USUZZLCB4ZW5fYWNwaV9w
YWRfbm90aWZ5KTsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBhY3BpX2Rl
dmljZV9pZCB4ZW5fcGFkX2RldmljZV9pZHNbXSA9IHsKKwl7IkFDUEkwMDBDIiwgMH0sCisJeyIi
LCAwfSwKK307CisKK3N0YXRpYyBzdHJ1Y3QgYWNwaV9kcml2ZXIgeGVuX2FjcGlfcGFkX2RyaXZl
ciA9IHsKKwkubmFtZSA9ICJwcm9jZXNzb3JfYWdncmVnYXRvciIsCisJLmNsYXNzID0gQUNQSV9Q
Uk9DRVNTT1JfQUdHUkVHQVRPUl9DTEFTUywKKwkuaWRzID0geGVuX3BhZF9kZXZpY2VfaWRzLAor
CS5vcHMgPSB7CisJCS5hZGQgPSB4ZW5fYWNwaV9wYWRfYWRkLAorCQkucmVtb3ZlID0geGVuX2Fj
cGlfcGFkX3JlbW92ZSwKKwl9LAorfTsKKworc3RhdGljIGludCBfX2luaXQgeGVuX2FjcGlfcGFk
X2luaXQodm9pZCkKK3sKKwlyZXR1cm4gYWNwaV9idXNfcmVnaXN0ZXJfZHJpdmVyKCZ4ZW5fYWNw
aV9wYWRfZHJpdmVyKTsKK30KKwordm9pZCBfX2luaXQgeGVuX2luaXRfcGFkX29wcyh2b2lkKQor
eworI2lmZGVmIENPTkZJR19BQ1BJX1BST0NFU1NPUl9BR0dSRUdBVE9SCisJYWNwaV9wYWRfb3Bz
LmluaXQgPSB4ZW5fYWNwaV9wYWRfaW5pdDsKKyNlbmRpZgorfQpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZv
cm0uaAppbmRleCBjMTY4NDY4Li41NmVjNzJhIDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9pbnRl
cmZhY2UvcGxhdGZvcm0uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaApA
QCAtMjk3LDYgKzI5NywxOSBAQCBzdHJ1Y3QgeGVucGZfc2V0X3Byb2Nlc3Nvcl9wbWluZm8gewog
fTsKIERFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbnBmX3NldF9wcm9jZXNzb3JfcG1pbmZv
KTsKIAorI2RlZmluZSBYRU5QRl9jb3JlX3BhcmtpbmcgICAgICA2MAorCisjZGVmaW5lIFhFTl9D
T1JFX1BBUktJTkdfU0VUICAgIDEKKyNkZWZpbmUgWEVOX0NPUkVfUEFSS0lOR19HRVQgICAgMgor
c3RydWN0IHhlbnBmX2NvcmVfcGFya2luZyB7CisJLyogSU4gdmFyaWFibGVzICovCisJdWludDMy
X3QgdHlwZTsKKwkvKiBJTiB2YXJpYWJsZXM6ICBzZXQgY3B1IG51bXMgZXhwZWN0ZWQgdG8gYmUg
aWRsZWQgKi8KKwkvKiBPVVQgdmFyaWFibGVzOiBnZXQgY3B1IG51bXMgYWN0dWFsbHkgYmUgaWRs
ZWQgKi8KKwl1aW50MzJfdCBpZGxlX251bXM7Cit9OworREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJV
Q1QoeGVucGZfY29yZV9wYXJraW5nKTsKKwogc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCB7CiAJdWlu
dDMyX3QgY21kOwogCXVpbnQzMl90IGludGVyZmFjZV92ZXJzaW9uOyAvKiBYRU5QRl9JTlRFUkZB
Q0VfVkVSU0lPTiAqLwpAQCAtMzEyLDYgKzMyNSw3IEBAIHN0cnVjdCB4ZW5fcGxhdGZvcm1fb3Ag
ewogCQlzdHJ1Y3QgeGVucGZfY2hhbmdlX2ZyZXEgICAgICAgY2hhbmdlX2ZyZXE7CiAJCXN0cnVj
dCB4ZW5wZl9nZXRpZGxldGltZSAgICAgICBnZXRpZGxldGltZTsKIAkJc3RydWN0IHhlbnBmX3Nl
dF9wcm9jZXNzb3JfcG1pbmZvIHNldF9wbWluZm87CisJCXN0cnVjdCB4ZW5wZl9jb3JlX3Bhcmtp
bmcgICAgICBjb3JlX3Bhcmtpbmc7CiAJCXVpbnQ4X3QgICAgICAgICAgICAgICAgICAgICAgICBw
YWRbMTI4XTsKIAl9IHU7CiB9OwotLSAKMS43LjEKCg==

--_002_DE8DF0795D48FD4CA783C40EC82923350AD0A6SHSMSX101ccrcorpi_--
