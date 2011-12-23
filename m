Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1LWKah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:30:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:2107 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608Ab1LWKaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:30:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="99638929"
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
Subject: [PATCH 06/10] Xen: Add memory hotadd to pvops dom0
Thread-Topic: [PATCH 06/10] Xen: Add memory hotadd to pvops dom0
Thread-Index: AczBXZgPyRTMl0D9SUWZHviROKw3OQ==
Date: Fri, 23 Dec 2011 10:28:21 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923359700@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC82923359700SHSMSX101ccrcorpint_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC82923359700SHSMSX101ccrcorpint_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From a5d21e2a01049eef6aa64406e71f6574e7a371c1 Mon Sep 17 00:00:00 2001
From: Liu Jinsong <jinsong.liu@intel.com>
Date: Sun, 11 Dec 2011 21:51:28 +0800
Subject: [PATCH 06/10] Xen: Add memory hotadd to pvops dom0

This patch rebased from Jeremy's pvops commit
fe3cb1ebf78399fd5176ff6aa1c9ab498f2d8bd7

When memory hotadd event happen, a Xen hook will be called, to notify
hypervisor of the new added memory.

Because xen hypervisor will use the new memory to setup frametable/m2p
table, so dom0 will always return success to acpi bios, and notify xen
hypervisor later.

It add a hook in driver/acpi/acpi_memhotplug.c, but that change is
quite small, not sure if it is acceptable. Other method is to provide
a xen specific acpi_memory_device_driver, but I'm not sure if it worth
to add so much changes, to simply avoid two hooks.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/acpi/acpi_memhotplug.c    |    4 +
 drivers/xen/Makefile              |    1 +
 drivers/xen/xen_acpi_memhotplug.c |  209 +++++++++++++++++++++++++++++++++=
++++
 include/xen/acpi.h                |    5 +
 include/xen/interface/platform.h  |    9 ++
 5 files changed, 228 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/xen_acpi_memhotplug.c

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.=
c
index e28e64d..2f2169e 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -32,6 +32,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/slab.h>
 #include <acpi/acpi_drivers.h>
+#include <xen/acpi.h>
=20
 #define ACPI_MEMORY_DEVICE_CLASS		"memory"
 #define ACPI_MEMORY_DEVICE_HID			"PNP0C80"
@@ -214,6 +215,9 @@ static int acpi_memory_enable_device(struct acpi_memory=
_device *mem_device)
 		return result;
 	}
=20
+	if (xen_initial_domain())
+		return xen_hotadd_memory(mem_device);
+
 	node =3D acpi_get_node(mem_device->device->handle);
 	/*
 	 * Tell the VM there is more memory here...
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index aedaf48..7dc3c0b 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_XEN_TMEM)			+=3D tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)			+=3D pci.o acpi.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
+obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+=3D xen_acpi_memhotplug.o
 ifdef CONFIG_ACPI_PROCESSOR_XEN
 obj-$(CONFIG_ACPI_PROCESSOR)		+=3D acpi_processor.o
 endif
diff --git a/drivers/xen/xen_acpi_memhotplug.c b/drivers/xen/xen_acpi_memho=
tplug.c
new file mode 100644
index 0000000..0c4af99
--- /dev/null
+++ b/drivers/xen/xen_acpi_memhotplug.c
@@ -0,0 +1,209 @@
+/*
+ *  xen_acpi_memhotplug.c - interface to notify Xen on memory device hotad=
d
+ *
+ *  Copyright (C) 2008, Intel corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
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
+ *
+ *  You should have received a copy of the GNU General Public License alon=
g
+ *  with this program; if not, write to the Free Software Foundation, Inc.=
,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/memory_hotplug.h>
+#include <acpi/acpi_drivers.h>
+#include <xen/interface/platform.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+#include <xen/acpi.h>
+
+struct xen_hotmem_entry {
+	struct list_head hotmem_list;
+	uint64_t start;
+	uint64_t end;
+	uint32_t flags;
+	uint32_t pxm;
+};
+
+struct xen_hotmem_list {
+	struct list_head list;
+	int entry_nr;
+} xen_hotmem;
+
+DEFINE_SPINLOCK(xen_hotmem_lock);
+
+static int xen_hyper_addmem(struct xen_hotmem_entry *entry)
+{
+	int ret;
+
+	xen_platform_op_t op =3D {
+		.cmd            =3D XENPF_mem_hotadd,
+		.interface_version  =3D XENPF_INTERFACE_VERSION,
+	};
+	op.u.mem_add.spfn =3D entry->start >> PAGE_SHIFT;
+	op.u.mem_add.epfn =3D entry->end >> PAGE_SHIFT;
+	op.u.mem_add.flags =3D entry->flags;
+	op.u.mem_add.pxm =3D entry->pxm;
+
+	ret =3D HYPERVISOR_dom0_op(&op);
+	return ret;
+}
+
+static int add_hotmem_entry(int pxm, uint64_t start,
+			uint64_t length, uint32_t flags)
+{
+	struct xen_hotmem_entry *entry;
+
+	if (pxm < 0 || !length)
+		return -EINVAL;
+
+	entry =3D kzalloc(sizeof(struct xen_hotmem_entry), GFP_ATOMIC);
+	if (!entry)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&entry->hotmem_list);
+	entry->start =3D start;
+	entry->end =3D start + length;
+	entry->flags =3D flags;
+	entry->pxm =3D pxm;
+
+	spin_lock(&xen_hotmem_lock);
+
+	list_add_tail(&entry->hotmem_list, &xen_hotmem.list);
+	xen_hotmem.entry_nr++;
+
+	spin_unlock(&xen_hotmem_lock);
+
+	return 0;
+}
+
+static int free_hotmem_entry(struct xen_hotmem_entry *entry)
+{
+	list_del(&entry->hotmem_list);
+	kfree(entry);
+
+	return 0;
+}
+
+static void xen_hotadd_mem_dpc(struct work_struct *work)
+{
+	struct list_head *elem, *tmp;
+	struct xen_hotmem_entry *entry;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&xen_hotmem_lock, flags);
+	list_for_each_safe(elem, tmp, &xen_hotmem.list) {
+		entry =3D list_entry(elem, struct xen_hotmem_entry, hotmem_list);
+		ret =3D xen_hyper_addmem(entry);
+		if (ret)
+			printk(KERN_WARNING "xen addmem failed with %x\n", ret);
+		free_hotmem_entry(entry);
+		xen_hotmem.entry_nr--;
+	}
+	spin_unlock_irqrestore(&xen_hotmem_lock, flags);
+}
+
+static DECLARE_WORK(xen_hotadd_mem_work, xen_hotadd_mem_dpc);
+
+static int xen_acpi_get_pxm(acpi_handle h)
+{
+	unsigned long long pxm;
+	acpi_status status;
+	acpi_handle handle;
+	acpi_handle phandle =3D h;
+
+	do {
+		handle =3D phandle;
+		status =3D acpi_evaluate_integer(handle, "_PXM", NULL, &pxm);
+		if (ACPI_SUCCESS(status))
+			return pxm;
+		status =3D acpi_get_parent(handle, &phandle);
+	} while (ACPI_SUCCESS(status));
+
+	return -1;
+}
+
+int xen_hotadd_memory(struct acpi_memory_device *mem_device)
+{
+	int pxm, result;
+	int num_enabled =3D 0;
+	struct acpi_memory_info *info;
+
+	if (!mem_device)
+		return -EINVAL;
+
+	pxm =3D xen_acpi_get_pxm(mem_device->device->handle);
+
+	if (pxm < 0)
+		return -EINVAL;
+
+	/*
+	 * Always return success to ACPI driver, and notify hypervisor later
+	 * because hypervisor will utilize the memory in memory hotadd hypercall
+	 */
+	list_for_each_entry(info, &mem_device->res_list, list) {
+		if (info->enabled) { /* just sanity check...*/
+			num_enabled++;
+			continue;
+		}
+		/*
+		 * If the memory block size is zero, please ignore it.
+		 * Don't try to do the following memory hotplug flowchart.
+		 */
+		if (!info->length)
+			continue;
+
+		result =3D add_hotmem_entry(pxm, info->start_addr,
+					info->length, 0);
+		if (result)
+			continue;
+		info->enabled =3D 1;
+		num_enabled++;
+	}
+
+	if (!num_enabled)
+		return -EINVAL;
+
+	schedule_work(&xen_hotadd_mem_work);
+
+	return 0;
+}
+EXPORT_SYMBOL(xen_hotadd_memory);
+
+static int xen_hotadd_mem_init(void)
+{
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	INIT_LIST_HEAD(&xen_hotmem.list);
+	xen_hotmem.entry_nr =3D 0;
+
+	return 0;
+}
+
+static void xen_hotadd_mem_exit(void)
+{
+	flush_scheduled_work();
+}
+
+module_init(xen_hotadd_mem_init);
+module_exit(xen_hotadd_mem_exit);
+MODULE_LICENSE("GPL");
diff --git a/include/xen/acpi.h b/include/xen/acpi.h
index 7aa282d..8b3462e 100644
--- a/include/xen/acpi.h
+++ b/include/xen/acpi.h
@@ -107,6 +107,11 @@ static inline int xen_acpi_processor_get_performance(s=
truct acpi_processor *pr)
 }
 #endif
=20
+#if defined(CONFIG_ACPI_HOTPLUG_MEMORY) || \
+defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
+int xen_hotadd_memory(struct acpi_memory_device *mem_device);
+#endif
+
 #if defined(CONFIG_ACPI_PROCESSOR_XEN) || \
 defined(CONFIG_ACPI_PROCESSOR_XEN_MODULE)
=20
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 9fd6b07..0787c68 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -329,6 +329,14 @@ struct xenpf_cpu_hotadd {
 	uint32_t pxm;
 };
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
@@ -347,6 +355,7 @@ struct xen_platform_op {
 		struct xenpf_pcpuinfo          pcpu_info;
 		struct xenpf_cpu_ol            cpu_ol;
 		struct xenpf_cpu_hotadd        cpu_add;
+		struct xenpf_mem_hotadd        mem_add;
 		uint8_t                        pad[128];
 	} u;
 };
--=20
1.6.5.6

--_002_DE8DF0795D48FD4CA783C40EC82923359700SHSMSX101ccrcorpint_
Content-Type: application/octet-stream;
	name="0006-Xen-Add-memory-hotadd-to-pvops-dom0.patch"
Content-Description: 0006-Xen-Add-memory-hotadd-to-pvops-dom0.patch
Content-Disposition: attachment;
	filename="0006-Xen-Add-memory-hotadd-to-pvops-dom0.patch"; size=9113;
	creation-date="Wed, 14 Dec 2011 15:20:15 GMT";
	modification-date="Wed, 14 Dec 2011 15:03:34 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhNWQyMWUyYTAxMDQ5ZWVmNmFhNjQ0MDZlNzFmNjU3NGU3YTM3MWMxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpE
YXRlOiBTdW4sIDExIERlYyAyMDExIDIxOjUxOjI4ICswODAwClN1YmplY3Q6IFtQQVRDSCAwNi8x
MF0gWGVuOiBBZGQgbWVtb3J5IGhvdGFkZCB0byBwdm9wcyBkb20wCgpUaGlzIHBhdGNoIHJlYmFz
ZWQgZnJvbSBKZXJlbXkncyBwdm9wcyBjb21taXQKZmUzY2IxZWJmNzgzOTlmZDUxNzZmZjZhYTFj
OWFiNDk4ZjJkOGJkNwoKV2hlbiBtZW1vcnkgaG90YWRkIGV2ZW50IGhhcHBlbiwgYSBYZW4gaG9v
ayB3aWxsIGJlIGNhbGxlZCwgdG8gbm90aWZ5Cmh5cGVydmlzb3Igb2YgdGhlIG5ldyBhZGRlZCBt
ZW1vcnkuCgpCZWNhdXNlIHhlbiBoeXBlcnZpc29yIHdpbGwgdXNlIHRoZSBuZXcgbWVtb3J5IHRv
IHNldHVwIGZyYW1ldGFibGUvbTJwCnRhYmxlLCBzbyBkb20wIHdpbGwgYWx3YXlzIHJldHVybiBz
dWNjZXNzIHRvIGFjcGkgYmlvcywgYW5kIG5vdGlmeSB4ZW4KaHlwZXJ2aXNvciBsYXRlci4KCkl0
IGFkZCBhIGhvb2sgaW4gZHJpdmVyL2FjcGkvYWNwaV9tZW1ob3RwbHVnLmMsIGJ1dCB0aGF0IGNo
YW5nZSBpcwpxdWl0ZSBzbWFsbCwgbm90IHN1cmUgaWYgaXQgaXMgYWNjZXB0YWJsZS4gT3RoZXIg
bWV0aG9kIGlzIHRvIHByb3ZpZGUKYSB4ZW4gc3BlY2lmaWMgYWNwaV9tZW1vcnlfZGV2aWNlX2Ry
aXZlciwgYnV0IEknbSBub3Qgc3VyZSBpZiBpdCB3b3J0aAp0byBhZGQgc28gbXVjaCBjaGFuZ2Vz
LCB0byBzaW1wbHkgYXZvaWQgdHdvIGhvb2tzLgoKU2lnbmVkLW9mZi1ieTogTGl1LCBKaW5zb25n
IDxqaW5zb25nLmxpdUBpbnRlbC5jb20+ClNpZ25lZC1vZmYtYnk6IEppYW5nLCBZdW5ob25nIDx5
dW5ob25nLmppYW5nQGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogSmVyZW15IEZpdHpoYXJkaW5n
ZSA8amVyZW15LmZpdHpoYXJkaW5nZUBjaXRyaXguY29tPgotLS0KIGRyaXZlcnMvYWNwaS9hY3Bp
X21lbWhvdHBsdWcuYyAgICB8ICAgIDQgKwogZHJpdmVycy94ZW4vTWFrZWZpbGUgICAgICAgICAg
ICAgIHwgICAgMSArCiBkcml2ZXJzL3hlbi94ZW5fYWNwaV9tZW1ob3RwbHVnLmMgfCAgMjA5ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGluY2x1ZGUveGVuL2FjcGkuaCAg
ICAgICAgICAgICAgICB8ICAgIDUgKwogaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgg
IHwgICAgOSArKwogNSBmaWxlcyBjaGFuZ2VkLCAyMjggaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlv
bnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3hlbi94ZW5fYWNwaV9tZW1ob3RwbHVn
LmMKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2FjcGkvYWNwaV9tZW1ob3RwbHVnLmMgYi9kcml2ZXJz
L2FjcGkvYWNwaV9tZW1ob3RwbHVnLmMKaW5kZXggZTI4ZTY0ZC4uMmYyMTY5ZSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9hY3BpL2FjcGlfbWVtaG90cGx1Zy5jCisrKyBiL2RyaXZlcnMvYWNwaS9hY3Bp
X21lbWhvdHBsdWcuYwpAQCAtMzIsNiArMzIsNyBAQAogI2luY2x1ZGUgPGxpbnV4L21lbW9yeV9o
b3RwbHVnLmg+CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogI2luY2x1ZGUgPGFjcGkvYWNwaV9k
cml2ZXJzLmg+CisjaW5jbHVkZSA8eGVuL2FjcGkuaD4KIAogI2RlZmluZSBBQ1BJX01FTU9SWV9E
RVZJQ0VfQ0xBU1MJCSJtZW1vcnkiCiAjZGVmaW5lIEFDUElfTUVNT1JZX0RFVklDRV9ISUQJCQki
UE5QMEM4MCIKQEAgLTIxNCw2ICsyMTUsOSBAQCBzdGF0aWMgaW50IGFjcGlfbWVtb3J5X2VuYWJs
ZV9kZXZpY2Uoc3RydWN0IGFjcGlfbWVtb3J5X2RldmljZSAqbWVtX2RldmljZSkKIAkJcmV0dXJu
IHJlc3VsdDsKIAl9CiAKKwlpZiAoeGVuX2luaXRpYWxfZG9tYWluKCkpCisJCXJldHVybiB4ZW5f
aG90YWRkX21lbW9yeShtZW1fZGV2aWNlKTsKKwogCW5vZGUgPSBhY3BpX2dldF9ub2RlKG1lbV9k
ZXZpY2UtPmRldmljZS0+aGFuZGxlKTsKIAkvKgogCSAqIFRlbGwgdGhlIFZNIHRoZXJlIGlzIG1v
cmUgbWVtb3J5IGhlcmUuLi4KZGlmZiAtLWdpdCBhL2RyaXZlcnMveGVuL01ha2VmaWxlIGIvZHJp
dmVycy94ZW4vTWFrZWZpbGUKaW5kZXggYWVkYWY0OC4uN2RjM2MwYiAxMDA2NDQKLS0tIGEvZHJp
dmVycy94ZW4vTWFrZWZpbGUKKysrIGIvZHJpdmVycy94ZW4vTWFrZWZpbGUKQEAgLTIwLDYgKzIw
LDcgQEAgb2JqLSQoQ09ORklHX1hFTl9UTUVNKQkJCSs9IHRtZW0ubwogb2JqLSQoQ09ORklHX1NX
SU9UTEJfWEVOKQkJKz0gc3dpb3RsYi14ZW4ubwogb2JqLSQoQ09ORklHX1hFTl9ET00wKQkJCSs9
IHBjaS5vIGFjcGkubwogb2JqLSQoQ09ORklHX1hFTl9QQ0lERVZfQkFDS0VORCkJKz0geGVuLXBj
aWJhY2svCitvYmotJChDT05GSUdfQUNQSV9IT1RQTFVHX01FTU9SWSkJKz0geGVuX2FjcGlfbWVt
aG90cGx1Zy5vCiBpZmRlZiBDT05GSUdfQUNQSV9QUk9DRVNTT1JfWEVOCiBvYmotJChDT05GSUdf
QUNQSV9QUk9DRVNTT1IpCQkrPSBhY3BpX3Byb2Nlc3Nvci5vCiBlbmRpZgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy94ZW4veGVuX2FjcGlfbWVtaG90cGx1Zy5jIGIvZHJpdmVycy94ZW4veGVuX2FjcGlf
bWVtaG90cGx1Zy5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjBjNGFmOTkK
LS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL3hlbi94ZW5fYWNwaV9tZW1ob3RwbHVnLmMKQEAg
LTAsMCArMSwyMDkgQEAKKy8qCisgKiAgeGVuX2FjcGlfbWVtaG90cGx1Zy5jIC0gaW50ZXJmYWNl
IHRvIG5vdGlmeSBYZW4gb24gbWVtb3J5IGRldmljZSBob3RhZGQKKyAqCisgKiAgQ29weXJpZ2h0
IChDKSAyMDA4LCBJbnRlbCBjb3Jwb3JhdGlvbgorICoKKyAqIH5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Cisg
KgorICogIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0
ZSBpdCBhbmQvb3IgbW9kaWZ5CisgKiAgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKKyAqICB0aGUgRnJlZSBTb2Z0d2Fy
ZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQKKyAq
ICB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCisgKgorICogIFRoaXMgcHJvZ3JhbSBp
cyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQKKyAq
ICBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5
IG9mCisgKiAgTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQ
T1NFLiAgU2VlIHRoZSBHTlUKKyAqICBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRl
dGFpbHMuCisgKgorICogIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdO
VSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFsb25nCisgKiAgd2l0aCB0aGlzIHByb2dyYW07IGlm
IG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbiwgSW5jLiwKKyAqICA1
OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMzMCwgQm9zdG9uLCBNQSAwMjExMS0xMzA3IFVTQS4KKyAq
CisgKi8KKworI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVs
ZS5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgor
I2luY2x1ZGUgPGxpbnV4L21lbW9yeV9ob3RwbHVnLmg+CisjaW5jbHVkZSA8YWNwaS9hY3BpX2Ry
aXZlcnMuaD4KKyNpbmNsdWRlIDx4ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmg+CisjaW5jbHVkZSA8
bGludXgvaW50ZXJydXB0Lmg+CisjaW5jbHVkZSA8bGludXgvc3BpbmxvY2suaD4KKyNpbmNsdWRl
IDxhc20veGVuL2h5cGVydmlzb3IuaD4KKyNpbmNsdWRlIDxhc20veGVuL2h5cGVyY2FsbC5oPgor
I2luY2x1ZGUgPHhlbi9hY3BpLmg+CisKK3N0cnVjdCB4ZW5faG90bWVtX2VudHJ5IHsKKwlzdHJ1
Y3QgbGlzdF9oZWFkIGhvdG1lbV9saXN0OworCXVpbnQ2NF90IHN0YXJ0OworCXVpbnQ2NF90IGVu
ZDsKKwl1aW50MzJfdCBmbGFnczsKKwl1aW50MzJfdCBweG07Cit9OworCitzdHJ1Y3QgeGVuX2hv
dG1lbV9saXN0IHsKKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CisJaW50IGVudHJ5X25yOworfSB4
ZW5faG90bWVtOworCitERUZJTkVfU1BJTkxPQ0soeGVuX2hvdG1lbV9sb2NrKTsKKworc3RhdGlj
IGludCB4ZW5faHlwZXJfYWRkbWVtKHN0cnVjdCB4ZW5faG90bWVtX2VudHJ5ICplbnRyeSkKK3sK
KwlpbnQgcmV0OworCisJeGVuX3BsYXRmb3JtX29wX3Qgb3AgPSB7CisJCS5jbWQgICAgICAgICAg
ICA9IFhFTlBGX21lbV9ob3RhZGQsCisJCS5pbnRlcmZhY2VfdmVyc2lvbiAgPSBYRU5QRl9JTlRF
UkZBQ0VfVkVSU0lPTiwKKwl9OworCW9wLnUubWVtX2FkZC5zcGZuID0gZW50cnktPnN0YXJ0ID4+
IFBBR0VfU0hJRlQ7CisJb3AudS5tZW1fYWRkLmVwZm4gPSBlbnRyeS0+ZW5kID4+IFBBR0VfU0hJ
RlQ7CisJb3AudS5tZW1fYWRkLmZsYWdzID0gZW50cnktPmZsYWdzOworCW9wLnUubWVtX2FkZC5w
eG0gPSBlbnRyeS0+cHhtOworCisJcmV0ID0gSFlQRVJWSVNPUl9kb20wX29wKCZvcCk7CisJcmV0
dXJuIHJldDsKK30KKworc3RhdGljIGludCBhZGRfaG90bWVtX2VudHJ5KGludCBweG0sIHVpbnQ2
NF90IHN0YXJ0LAorCQkJdWludDY0X3QgbGVuZ3RoLCB1aW50MzJfdCBmbGFncykKK3sKKwlzdHJ1
Y3QgeGVuX2hvdG1lbV9lbnRyeSAqZW50cnk7CisKKwlpZiAocHhtIDwgMCB8fCAhbGVuZ3RoKQor
CQlyZXR1cm4gLUVJTlZBTDsKKworCWVudHJ5ID0ga3phbGxvYyhzaXplb2Yoc3RydWN0IHhlbl9o
b3RtZW1fZW50cnkpLCBHRlBfQVRPTUlDKTsKKwlpZiAoIWVudHJ5KQorCQlyZXR1cm4gLUVOT01F
TTsKKworCUlOSVRfTElTVF9IRUFEKCZlbnRyeS0+aG90bWVtX2xpc3QpOworCWVudHJ5LT5zdGFy
dCA9IHN0YXJ0OworCWVudHJ5LT5lbmQgPSBzdGFydCArIGxlbmd0aDsKKwllbnRyeS0+ZmxhZ3Mg
PSBmbGFnczsKKwllbnRyeS0+cHhtID0gcHhtOworCisJc3Bpbl9sb2NrKCZ4ZW5faG90bWVtX2xv
Y2spOworCisJbGlzdF9hZGRfdGFpbCgmZW50cnktPmhvdG1lbV9saXN0LCAmeGVuX2hvdG1lbS5s
aXN0KTsKKwl4ZW5faG90bWVtLmVudHJ5X25yKys7CisKKwlzcGluX3VubG9jaygmeGVuX2hvdG1l
bV9sb2NrKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGZyZWVfaG90bWVtX2VudHJ5
KHN0cnVjdCB4ZW5faG90bWVtX2VudHJ5ICplbnRyeSkKK3sKKwlsaXN0X2RlbCgmZW50cnktPmhv
dG1lbV9saXN0KTsKKwlrZnJlZShlbnRyeSk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIHZv
aWQgeGVuX2hvdGFkZF9tZW1fZHBjKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKK3sKKwlzdHJ1
Y3QgbGlzdF9oZWFkICplbGVtLCAqdG1wOworCXN0cnVjdCB4ZW5faG90bWVtX2VudHJ5ICplbnRy
eTsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOworCWludCByZXQ7CisKKwlzcGluX2xvY2tfaXJxc2F2
ZSgmeGVuX2hvdG1lbV9sb2NrLCBmbGFncyk7CisJbGlzdF9mb3JfZWFjaF9zYWZlKGVsZW0sIHRt
cCwgJnhlbl9ob3RtZW0ubGlzdCkgeworCQllbnRyeSA9IGxpc3RfZW50cnkoZWxlbSwgc3RydWN0
IHhlbl9ob3RtZW1fZW50cnksIGhvdG1lbV9saXN0KTsKKwkJcmV0ID0geGVuX2h5cGVyX2FkZG1l
bShlbnRyeSk7CisJCWlmIChyZXQpCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICJ4ZW4gYWRkbWVt
IGZhaWxlZCB3aXRoICV4XG4iLCByZXQpOworCQlmcmVlX2hvdG1lbV9lbnRyeShlbnRyeSk7CisJ
CXhlbl9ob3RtZW0uZW50cnlfbnItLTsKKwl9CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmeGVu
X2hvdG1lbV9sb2NrLCBmbGFncyk7Cit9CisKK3N0YXRpYyBERUNMQVJFX1dPUksoeGVuX2hvdGFk
ZF9tZW1fd29yaywgeGVuX2hvdGFkZF9tZW1fZHBjKTsKKworc3RhdGljIGludCB4ZW5fYWNwaV9n
ZXRfcHhtKGFjcGlfaGFuZGxlIGgpCit7CisJdW5zaWduZWQgbG9uZyBsb25nIHB4bTsKKwlhY3Bp
X3N0YXR1cyBzdGF0dXM7CisJYWNwaV9oYW5kbGUgaGFuZGxlOworCWFjcGlfaGFuZGxlIHBoYW5k
bGUgPSBoOworCisJZG8geworCQloYW5kbGUgPSBwaGFuZGxlOworCQlzdGF0dXMgPSBhY3BpX2V2
YWx1YXRlX2ludGVnZXIoaGFuZGxlLCAiX1BYTSIsIE5VTEwsICZweG0pOworCQlpZiAoQUNQSV9T
VUNDRVNTKHN0YXR1cykpCisJCQlyZXR1cm4gcHhtOworCQlzdGF0dXMgPSBhY3BpX2dldF9wYXJl
bnQoaGFuZGxlLCAmcGhhbmRsZSk7CisJfSB3aGlsZSAoQUNQSV9TVUNDRVNTKHN0YXR1cykpOwor
CisJcmV0dXJuIC0xOworfQorCitpbnQgeGVuX2hvdGFkZF9tZW1vcnkoc3RydWN0IGFjcGlfbWVt
b3J5X2RldmljZSAqbWVtX2RldmljZSkKK3sKKwlpbnQgcHhtLCByZXN1bHQ7CisJaW50IG51bV9l
bmFibGVkID0gMDsKKwlzdHJ1Y3QgYWNwaV9tZW1vcnlfaW5mbyAqaW5mbzsKKworCWlmICghbWVt
X2RldmljZSkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlweG0gPSB4ZW5fYWNwaV9nZXRfcHhtKG1l
bV9kZXZpY2UtPmRldmljZS0+aGFuZGxlKTsKKworCWlmIChweG0gPCAwKQorCQlyZXR1cm4gLUVJ
TlZBTDsKKworCS8qCisJICogQWx3YXlzIHJldHVybiBzdWNjZXNzIHRvIEFDUEkgZHJpdmVyLCBh
bmQgbm90aWZ5IGh5cGVydmlzb3IgbGF0ZXIKKwkgKiBiZWNhdXNlIGh5cGVydmlzb3Igd2lsbCB1
dGlsaXplIHRoZSBtZW1vcnkgaW4gbWVtb3J5IGhvdGFkZCBoeXBlcmNhbGwKKwkgKi8KKwlsaXN0
X2Zvcl9lYWNoX2VudHJ5KGluZm8sICZtZW1fZGV2aWNlLT5yZXNfbGlzdCwgbGlzdCkgeworCQlp
ZiAoaW5mby0+ZW5hYmxlZCkgeyAvKiBqdXN0IHNhbml0eSBjaGVjay4uLiovCisJCQludW1fZW5h
YmxlZCsrOworCQkJY29udGludWU7CisJCX0KKwkJLyoKKwkJICogSWYgdGhlIG1lbW9yeSBibG9j
ayBzaXplIGlzIHplcm8sIHBsZWFzZSBpZ25vcmUgaXQuCisJCSAqIERvbid0IHRyeSB0byBkbyB0
aGUgZm9sbG93aW5nIG1lbW9yeSBob3RwbHVnIGZsb3djaGFydC4KKwkJICovCisJCWlmICghaW5m
by0+bGVuZ3RoKQorCQkJY29udGludWU7CisKKwkJcmVzdWx0ID0gYWRkX2hvdG1lbV9lbnRyeShw
eG0sIGluZm8tPnN0YXJ0X2FkZHIsCisJCQkJCWluZm8tPmxlbmd0aCwgMCk7CisJCWlmIChyZXN1
bHQpCisJCQljb250aW51ZTsKKwkJaW5mby0+ZW5hYmxlZCA9IDE7CisJCW51bV9lbmFibGVkKys7
CisJfQorCisJaWYgKCFudW1fZW5hYmxlZCkKKwkJcmV0dXJuIC1FSU5WQUw7CisKKwlzY2hlZHVs
ZV93b3JrKCZ4ZW5faG90YWRkX21lbV93b3JrKTsKKworCXJldHVybiAwOworfQorRVhQT1JUX1NZ
TUJPTCh4ZW5faG90YWRkX21lbW9yeSk7CisKK3N0YXRpYyBpbnQgeGVuX2hvdGFkZF9tZW1faW5p
dCh2b2lkKQoreworCWlmICgheGVuX2luaXRpYWxfZG9tYWluKCkpCisJCXJldHVybiAtRU5PREVW
OworCisJSU5JVF9MSVNUX0hFQUQoJnhlbl9ob3RtZW0ubGlzdCk7CisJeGVuX2hvdG1lbS5lbnRy
eV9uciA9IDA7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIHZvaWQgeGVuX2hvdGFkZF9tZW1f
ZXhpdCh2b2lkKQoreworCWZsdXNoX3NjaGVkdWxlZF93b3JrKCk7Cit9CisKK21vZHVsZV9pbml0
KHhlbl9ob3RhZGRfbWVtX2luaXQpOworbW9kdWxlX2V4aXQoeGVuX2hvdGFkZF9tZW1fZXhpdCk7
CitNT0RVTEVfTElDRU5TRSgiR1BMIik7CmRpZmYgLS1naXQgYS9pbmNsdWRlL3hlbi9hY3BpLmgg
Yi9pbmNsdWRlL3hlbi9hY3BpLmgKaW5kZXggN2FhMjgyZC4uOGIzNDYyZSAxMDA2NDQKLS0tIGEv
aW5jbHVkZS94ZW4vYWNwaS5oCisrKyBiL2luY2x1ZGUveGVuL2FjcGkuaApAQCAtMTA3LDYgKzEw
NywxMSBAQCBzdGF0aWMgaW5saW5lIGludCB4ZW5fYWNwaV9wcm9jZXNzb3JfZ2V0X3BlcmZvcm1h
bmNlKHN0cnVjdCBhY3BpX3Byb2Nlc3NvciAqcHIpCiB9CiAjZW5kaWYKIAorI2lmIGRlZmluZWQo
Q09ORklHX0FDUElfSE9UUExVR19NRU1PUlkpIHx8IFwKK2RlZmluZWQoQ09ORklHX0FDUElfSE9U
UExVR19NRU1PUllfTU9EVUxFKQoraW50IHhlbl9ob3RhZGRfbWVtb3J5KHN0cnVjdCBhY3BpX21l
bW9yeV9kZXZpY2UgKm1lbV9kZXZpY2UpOworI2VuZGlmCisKICNpZiBkZWZpbmVkKENPTkZJR19B
Q1BJX1BST0NFU1NPUl9YRU4pIHx8IFwKIGRlZmluZWQoQ09ORklHX0FDUElfUFJPQ0VTU09SX1hF
Tl9NT0RVTEUpCiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5o
IGIvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKaW5kZXggOWZkNmIwNy4uMDc4N2M2
OCAxMDA2NDQKLS0tIGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKKysrIGIvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmgKQEAgLTMyOSw2ICszMjksMTQgQEAgc3RydWN0
IHhlbnBmX2NwdV9ob3RhZGQgewogCXVpbnQzMl90IHB4bTsKIH07CiAKKyNkZWZpbmUgWEVOUEZf
bWVtX2hvdGFkZCAgICA1OQorc3RydWN0IHhlbnBmX21lbV9ob3RhZGQgeworCXVpbnQ2NF90IHNw
Zm47CisJdWludDY0X3QgZXBmbjsKKwl1aW50MzJfdCBweG07CisJdWludDMyX3QgZmxhZ3M7Cit9
OworCiBzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIHsKIAl1aW50MzJfdCBjbWQ7CiAJdWludDMyX3Qg
aW50ZXJmYWNlX3ZlcnNpb247IC8qIFhFTlBGX0lOVEVSRkFDRV9WRVJTSU9OICovCkBAIC0zNDcs
NiArMzU1LDcgQEAgc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCB7CiAJCXN0cnVjdCB4ZW5wZl9wY3B1
aW5mbyAgICAgICAgICBwY3B1X2luZm87CiAJCXN0cnVjdCB4ZW5wZl9jcHVfb2wgICAgICAgICAg
ICBjcHVfb2w7CiAJCXN0cnVjdCB4ZW5wZl9jcHVfaG90YWRkICAgICAgICBjcHVfYWRkOworCQlz
dHJ1Y3QgeGVucGZfbWVtX2hvdGFkZCAgICAgICAgbWVtX2FkZDsKIAkJdWludDhfdCAgICAgICAg
ICAgICAgICAgICAgICAgIHBhZFsxMjhdOwogCX0gdTsKIH07Ci0tIAoxLjYuNS42Cgo=

--_002_DE8DF0795D48FD4CA783C40EC82923359700SHSMSX101ccrcorpint_--
