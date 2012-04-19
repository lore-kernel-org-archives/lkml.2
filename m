Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2DSNdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:33:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:50987 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab2DSNdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208,223";a="90897483"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] Xen physical cpus interface
Thread-Topic: [PATCH 3/3] Xen physical cpus interface
Thread-Index: Ac0eMPIz1b8pDRiwSFiwkpXixs4X8A==
Date: Thu, 19 Apr 2012 13:33:03 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335154F3E@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC8292335154F3ESHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC8292335154F3ESHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From afdd30a7769e706e9be64f80d64136e2e267ecb9 Mon Sep 17 00:00:00 2001
From: Liu, Jinsong <jinsong.liu@intel.com>
Date: Fri, 20 Apr 2012 05:11:58 +0800
Subject: [PATCH 3/3] Xen physical cpus interface

Manage physical cpus in dom0, get physical cpus info and provide sys interf=
ace.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>
Signed-off-by: Jiang, Yunhong <yunhong.jiang@intel.com>
---
 drivers/xen/Makefile             |    1 +
 drivers/xen/pcpu.c               |  393 ++++++++++++++++++++++++++++++++++=
++++
 include/xen/interface/platform.h |   10 +-
 include/xen/interface/xen.h      |    1 +
 4 files changed, 404 insertions(+), 1 deletions(-)
 create mode 100644 drivers/xen/pcpu.c

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 1d3e763..d12d14d 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_XEN_PVHVM)			+=3D platform-pci.o
 obj-$(CONFIG_XEN_TMEM)			+=3D tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+=3D swiotlb-xen.o
 obj-$(CONFIG_XEN_DOM0)			+=3D pci.o
+obj-$(CONFIG_XEN_DOM0)			+=3D pcpu.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+=3D xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+=3D xen-privcmd.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+=3D xen-acpi-processor.o
diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
new file mode 100644
index 0000000..9295def
--- /dev/null
+++ b/drivers/xen/pcpu.c
@@ -0,0 +1,393 @@
+/*************************************************************************=
*****
+ * pcpu.c
+ * Management physical cpu in dom0, get pcpu info and provide sys interfac=
e
+ *
+ * Copyright (c) 2012 Intel Corporation
+ * Author: Liu, Jinsong <jinsong.liu@intel.com>
+ * Author: Jiang, Yunhong <yunhong.jiang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a=
 copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modi=
fy,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Softw=
are,
+ * and to permit persons to whom the Software is furnished to do so, subje=
ct to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included=
 in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS=
 OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY=
,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL=
 THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEA=
LINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/cpu.h>
+#include <linux/stat.h>
+#include <xen/xen.h>
+#include <xen/xenbus.h>
+#include <xen/events.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+struct pcpu {
+	struct list_head pcpu_list;
+	struct device dev;
+	uint32_t xen_id;
+	uint32_t apic_id;
+	uint32_t acpi_id;
+	uint32_t flags;
+};
+
+static struct bus_type xen_pcpu_subsys =3D {
+	.name =3D "xen_cpu",
+	.dev_name =3D "xen_cpu",
+};
+
+static DEFINE_MUTEX(xen_pcpu_lock);
+#define get_pcpu_lock() mutex_lock(&xen_pcpu_lock);
+#define put_pcpu_lock() mutex_unlock(&xen_pcpu_lock);
+
+#define XEN_PCPU "xen_cpu: "
+
+struct xen_pcpus {
+	struct list_head list;
+};
+static struct xen_pcpus xen_pcpus;
+
+static int xen_pcpu_down(uint32_t xen_id)
+{
+	int ret;
+	struct xen_platform_op op =3D {
+		.cmd			=3D XENPF_cpu_offline,
+		.interface_version	=3D XENPF_INTERFACE_VERSION,
+		.u.cpu_ol.cpuid		=3D xen_id,
+	};
+
+	ret =3D HYPERVISOR_dom0_op(&op);
+	return ret;
+}
+
+static int xen_pcpu_up(uint32_t xen_id)
+{
+	int ret;
+	struct xen_platform_op op =3D {
+		.cmd			=3D XENPF_cpu_online,
+		.interface_version	=3D XENPF_INTERFACE_VERSION,
+		.u.cpu_ol.cpuid		=3D xen_id,
+	};
+
+	ret =3D HYPERVISOR_dom0_op(&op);
+	return ret;
+}
+
+static ssize_t show_online(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct pcpu *cpu =3D container_of(dev, struct pcpu, dev);
+
+	return sprintf(buf, "%u\n", !!(cpu->flags & XEN_PCPU_FLAGS_ONLINE));
+}
+
+static ssize_t __ref store_online(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct pcpu *cpu =3D container_of(dev, struct pcpu, dev);
+	ssize_t ret;
+
+	switch (buf[0]) {
+	case '0':
+		ret =3D xen_pcpu_down(cpu->xen_id);
+		break;
+	case '1':
+		ret =3D xen_pcpu_up(cpu->xen_id);
+		break;
+	default:
+		ret =3D -EINVAL;
+	}
+
+	if (ret >=3D 0)
+		ret =3D count;
+	return ret;
+}
+static DEVICE_ATTR(online, S_IRUGO | S_IWUSR, show_online, store_online);
+
+static ssize_t show_apicid(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct pcpu *cpu =3D container_of(dev, struct pcpu, dev);
+
+	return sprintf(buf, "%u\n", cpu->apic_id);
+}
+
+static ssize_t show_acpiid(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct pcpu *cpu =3D container_of(dev, struct pcpu, dev);
+
+	return sprintf(buf, "%u\n", cpu->acpi_id);
+}
+static DEVICE_ATTR(apic_id, S_IRUGO, show_apicid, NULL);
+static DEVICE_ATTR(acpi_id, S_IRUGO, show_acpiid, NULL);
+
+static bool xen_pcpu_online(uint32_t flags)
+{
+	return !!(flags & XEN_PCPU_FLAGS_ONLINE);
+}
+
+static void pcpu_online_status(struct xenpf_pcpuinfo *info,
+			       struct pcpu *pcpu)
+{
+	if (xen_pcpu_online(info->flags) &&
+	   !xen_pcpu_online(pcpu->flags)) {
+		/* the pcpu is onlined */
+		pcpu->flags |=3D XEN_PCPU_FLAGS_ONLINE;
+		kobject_uevent(&pcpu->dev.kobj, KOBJ_ONLINE);
+	} else if (!xen_pcpu_online(info->flags) &&
+		    xen_pcpu_online(pcpu->flags)) {
+		/* The pcpu is offlined */
+		pcpu->flags &=3D ~XEN_PCPU_FLAGS_ONLINE;
+		kobject_uevent(&pcpu->dev.kobj, KOBJ_OFFLINE);
+	}
+}
+
+static struct pcpu *get_pcpu(uint32_t xen_id)
+{
+	struct pcpu *pcpu =3D NULL;
+
+	list_for_each_entry(pcpu, &xen_pcpus.list, pcpu_list) {
+		if (pcpu->xen_id =3D=3D xen_id)
+			return pcpu;
+	}
+	return NULL;
+}
+
+static void pcpu_sys_remove(struct pcpu *pcpu)
+{
+	struct device *dev;
+
+	if (!pcpu)
+		return;
+
+	dev =3D &pcpu->dev;
+	if (dev->id)
+		device_remove_file(dev, &dev_attr_online);
+	device_remove_file(dev, &dev_attr_acpi_id);
+	device_remove_file(dev, &dev_attr_apic_id);
+	device_unregister(dev);
+}
+
+static void free_pcpu(struct pcpu *pcpu)
+{
+	if (!pcpu)
+		return;
+
+	pcpu_sys_remove(pcpu);
+	list_del(&pcpu->pcpu_list);
+	kfree(pcpu);
+}
+
+static int pcpu_sys_create(struct pcpu *pcpu)
+{
+	struct device *dev;
+	int err =3D -EINVAL;
+
+	if (!pcpu)
+		return err;
+
+	dev =3D &pcpu->dev;
+	dev->bus =3D &xen_pcpu_subsys;
+	dev->id =3D pcpu->xen_id;
+
+	err =3D device_register(dev);
+	if (err)
+		goto err1;
+
+	err =3D device_create_file(dev, &dev_attr_apic_id);
+	if (err)
+		goto err2;
+	err =3D device_create_file(dev, &dev_attr_acpi_id);
+	if (err)
+		goto err3;
+	/* Not open pcpu0 online access to user */
+	if (dev->id) {
+		err =3D device_create_file(dev, &dev_attr_online);
+		if (err)
+			goto err4;
+	}
+
+	return 0;
+
+err4:
+	device_remove_file(dev, &dev_attr_acpi_id);
+err3:
+	device_remove_file(dev, &dev_attr_apic_id);
+err2:
+	device_unregister(dev);
+err1:
+	return err;
+}
+
+static struct pcpu *init_pcpu(struct xenpf_pcpuinfo *info)
+{
+	struct pcpu *pcpu;
+	int err;
+
+	if (info->flags & XEN_PCPU_FLAGS_INVALID)
+		return ERR_PTR(-ENODEV);
+
+	pcpu =3D kzalloc(sizeof(struct pcpu), GFP_KERNEL);
+	if (!pcpu)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&pcpu->pcpu_list);
+	pcpu->xen_id =3D info->xen_cpuid;
+	pcpu->apic_id =3D info->apic_id;
+	pcpu->acpi_id =3D info->acpi_id;
+	pcpu->flags =3D info->flags;
+
+	err =3D pcpu_sys_create(pcpu);
+	if (err) {
+		pr_warning(XEN_PCPU "Failed to register pcpu%d\n",
+			   info->xen_cpuid);
+		kfree(pcpu);
+		return ERR_PTR(-ENOENT);
+	}
+
+	list_add_tail(&pcpu->pcpu_list, &xen_pcpus.list);
+	return pcpu;
+}
+
+/*
+ * Caller should hold the pcpu lock
+ */
+static int _sync_pcpu(uint32_t cpu_num, uint32_t *ptr_max_cpu_num)
+{
+	int ret;
+	struct pcpu *pcpu =3D NULL;
+	struct xenpf_pcpuinfo *info;
+	struct xen_platform_op op =3D {
+		.cmd                   =3D XENPF_get_cpuinfo,
+		.interface_version     =3D XENPF_INTERFACE_VERSION,
+		.u.pcpu_info.xen_cpuid =3D cpu_num,
+	};
+
+	ret =3D HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return ret;
+
+	info =3D &op.u.pcpu_info;
+	if (ptr_max_cpu_num)
+		*ptr_max_cpu_num =3D info->max_present;
+
+	pcpu =3D get_pcpu(cpu_num);
+
+	if (info->flags & XEN_PCPU_FLAGS_INVALID) {
+		/* The pcpu has been removed */
+		if (pcpu)
+			free_pcpu(pcpu);
+		return 0;
+	}
+
+	if (!pcpu) {
+		pcpu =3D init_pcpu(info);
+		if (IS_ERR_OR_NULL(pcpu))
+			return -ENODEV;
+	} else
+		pcpu_online_status(info, pcpu);
+
+	return 0;
+}
+
+/*
+ * Sync dom0's pcpu information with xen hypervisor's
+ */
+static int xen_sync_pcpus(void)
+{
+	/*
+	 * Boot cpu always have cpu_id 0 in xen
+	 */
+	uint32_t cpu_num =3D 0, max_cpu_num =3D 0;
+	int err =3D 0;
+	struct list_head *elem, *tmp;
+	struct pcpu *pcpu;
+
+	get_pcpu_lock();
+
+	while (!err && (cpu_num <=3D max_cpu_num)) {
+		err =3D _sync_pcpu(cpu_num, &max_cpu_num);
+		cpu_num++;
+	}
+
+	if (err) {
+		list_for_each_safe(elem, tmp, &xen_pcpus.list) {
+			pcpu =3D list_entry(elem, struct pcpu, pcpu_list);
+			free_pcpu(pcpu);
+		}
+	}
+
+	put_pcpu_lock();
+
+	return err;
+}
+
+static void xen_pcpu_dpc(struct work_struct *work)
+{
+	xen_sync_pcpus();
+}
+static DECLARE_WORK(xen_pcpu_work, xen_pcpu_dpc);
+
+static irqreturn_t xen_pcpu_interrupt(int irq, void *dev_id)
+{
+	schedule_work(&xen_pcpu_work);
+	return IRQ_HANDLED;
+}
+
+static int __init xen_pcpu_init(void)
+{
+	int ret;
+
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	ret =3D subsys_system_register(&xen_pcpu_subsys, NULL);
+	if (ret) {
+		pr_warning(XEN_PCPU "Failed to register pcpu subsys\n");
+		return ret;
+	}
+
+	INIT_LIST_HEAD(&xen_pcpus.list);
+
+	ret =3D xen_sync_pcpus();
+	if (ret) {
+		pr_warning(XEN_PCPU "Failed to sync pcpu info\n");
+		return ret;
+	}
+
+	ret =3D bind_virq_to_irqhandler(VIRQ_PCPU_STATE, 0,
+				      xen_pcpu_interrupt, 0,
+				      "pcpu", NULL);
+	if (ret < 0) {
+		pr_warning(XEN_PCPU "Failed to bind pcpu virq\n");
+		return ret;
+	}
+
+	return 0;
+}
+arch_initcall(xen_pcpu_init);
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platf=
orm.h
index 486653f..2c56d4f 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -298,7 +298,7 @@ struct xenpf_set_processor_pminfo {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_set_processor_pminfo);
=20
-#define XENPF_get_cpuinfo 55
+#define XENPF_get_cpuinfo	55
 struct xenpf_pcpuinfo {
 	/* IN */
 	uint32_t xen_cpuid;
@@ -314,6 +314,13 @@ struct xenpf_pcpuinfo {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_pcpuinfo);
=20
+#define XENPF_cpu_online	56
+#define XENPF_cpu_offline	57
+struct xenpf_cpu_ol {
+	uint32_t cpuid;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_cpu_ol);
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -330,6 +337,7 @@ struct xen_platform_op {
 		struct xenpf_getidletime       getidletime;
 		struct xenpf_set_processor_pminfo set_pminfo;
 		struct xenpf_pcpuinfo          pcpu_info;
+		struct xenpf_cpu_ol            cpu_ol;
 		uint8_t                        pad[128];
 	} u;
 };
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index a890804..0801468 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -80,6 +80,7 @@
 #define VIRQ_CONSOLE    2  /* (DOM0) Bytes received on emergency console. =
*/
 #define VIRQ_DOM_EXC    3  /* (DOM0) Exceptional event for some domain.   =
*/
 #define VIRQ_DEBUGGER   6  /* (DOM0) A domain has paused for debugging.   =
*/
+#define VIRQ_PCPU_STATE 9  /* (DOM0) PCPU state changed                   =
*/
=20
 /* Architecture-specific VIRQ definitions. */
 #define VIRQ_ARCH_0    16
--=20
1.7.1

--_002_DE8DF0795D48FD4CA783C40EC8292335154F3ESHSMSX101ccrcorpi_
Content-Type: application/octet-stream;
	name="0003-Xen-physical-cpus-interface.patch"
Content-Description: 0003-Xen-physical-cpus-interface.patch
Content-Disposition: attachment;
	filename="0003-Xen-physical-cpus-interface.patch"; size=12339;
	creation-date="Thu, 19 Apr 2012 13:21:53 GMT";
	modification-date="Thu, 19 Apr 2012 21:16:56 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhZmRkMzBhNzc2OWU3MDZlOWJlNjRmODBkNjQxMzZlMmUyNjdlY2I5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVsLmNvbT4K
RGF0ZTogRnJpLCAyMCBBcHIgMjAxMiAwNToxMTo1OCArMDgwMApTdWJqZWN0OiBbUEFUQ0ggMy8z
XSBYZW4gcGh5c2ljYWwgY3B1cyBpbnRlcmZhY2UKCk1hbmFnZSBwaHlzaWNhbCBjcHVzIGluIGRv
bTAsIGdldCBwaHlzaWNhbCBjcHVzIGluZm8gYW5kIHByb3ZpZGUgc3lzIGludGVyZmFjZS4KClNp
Z25lZC1vZmYtYnk6IExpdSwgSmluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgpTaWduZWQt
b2ZmLWJ5OiBKaWFuZywgWXVuaG9uZyA8eXVuaG9uZy5qaWFuZ0BpbnRlbC5jb20+Ci0tLQogZHJp
dmVycy94ZW4vTWFrZWZpbGUgICAgICAgICAgICAgfCAgICAxICsKIGRyaXZlcnMveGVuL3BjcHUu
YyAgICAgICAgICAgICAgIHwgIDM5MyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKwogaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmggfCAgIDEwICstCiBpbmNsdWRl
L3hlbi9pbnRlcmZhY2UveGVuLmggICAgICB8ICAgIDEgKwogNCBmaWxlcyBjaGFuZ2VkLCA0MDQg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L3hlbi9wY3B1LmMKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi9NYWtlZmlsZSBiL2RyaXZlcnMv
eGVuL01ha2VmaWxlCmluZGV4IDFkM2U3NjMuLmQxMmQxNGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
eGVuL01ha2VmaWxlCisrKyBiL2RyaXZlcnMveGVuL01ha2VmaWxlCkBAIC0xOSw2ICsxOSw3IEBA
IG9iai0kKENPTkZJR19YRU5fUFZIVk0pCQkJKz0gcGxhdGZvcm0tcGNpLm8KIG9iai0kKENPTkZJ
R19YRU5fVE1FTSkJCQkrPSB0bWVtLm8KIG9iai0kKENPTkZJR19TV0lPVExCX1hFTikJCSs9IHN3
aW90bGIteGVuLm8KIG9iai0kKENPTkZJR19YRU5fRE9NMCkJCQkrPSBwY2kubworb2JqLSQoQ09O
RklHX1hFTl9ET00wKQkJCSs9IHBjcHUubwogb2JqLSQoQ09ORklHX1hFTl9QQ0lERVZfQkFDS0VO
RCkJKz0geGVuLXBjaWJhY2svCiBvYmotJChDT05GSUdfWEVOX1BSSVZDTUQpCQkrPSB4ZW4tcHJp
dmNtZC5vCiBvYmotJChDT05GSUdfWEVOX0FDUElfUFJPQ0VTU09SKQkrPSB4ZW4tYWNwaS1wcm9j
ZXNzb3IubwpkaWZmIC0tZ2l0IGEvZHJpdmVycy94ZW4vcGNwdS5jIGIvZHJpdmVycy94ZW4vcGNw
dS5jCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLjkyOTVkZWYKLS0tIC9kZXYv
bnVsbAorKysgYi9kcml2ZXJzL3hlbi9wY3B1LmMKQEAgLTAsMCArMSwzOTMgQEAKKy8qKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioKKyAqIHBjcHUuYworICogTWFuYWdlbWVudCBwaHlzaWNhbCBjcHUgaW4g
ZG9tMCwgZ2V0IHBjcHUgaW5mbyBhbmQgcHJvdmlkZSBzeXMgaW50ZXJmYWNlCisgKgorICogQ29w
eXJpZ2h0IChjKSAyMDEyIEludGVsIENvcnBvcmF0aW9uCisgKiBBdXRob3I6IExpdSwgSmluc29u
ZyA8amluc29uZy5saXVAaW50ZWwuY29tPgorICogQXV0aG9yOiBKaWFuZywgWXVuaG9uZyA8eXVu
aG9uZy5qaWFuZ0BpbnRlbC5jb20+CisgKgorICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdh
cmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcgorICogbW9kaWZ5IGl0IHVuZGVyIHRo
ZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgdmVyc2lvbiAyCisgKiBh
cyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgb3IsIHdoZW4gZGlz
dHJpYnV0ZWQKKyAqIHNlcGFyYXRlbHkgZnJvbSB0aGUgTGludXgga2VybmVsIG9yIGluY29ycG9y
YXRlZCBpbnRvIG90aGVyCisgKiBzb2Z0d2FyZSBwYWNrYWdlcywgc3ViamVjdCB0byB0aGUgZm9s
bG93aW5nIGxpY2Vuc2U6CisgKgorICogUGVybWlzc2lvbiBpcyBoZXJlYnkgZ3JhbnRlZCwgZnJl
ZSBvZiBjaGFyZ2UsIHRvIGFueSBwZXJzb24gb2J0YWluaW5nIGEgY29weQorICogb2YgdGhpcyBz
b3VyY2UgZmlsZSAodGhlICJTb2Z0d2FyZSIpLCB0byBkZWFsIGluIHRoZSBTb2Z0d2FyZSB3aXRo
b3V0CisgKiByZXN0cmljdGlvbiwgaW5jbHVkaW5nIHdpdGhvdXQgbGltaXRhdGlvbiB0aGUgcmln
aHRzIHRvIHVzZSwgY29weSwgbW9kaWZ5LAorICogbWVyZ2UsIHB1Ymxpc2gsIGRpc3RyaWJ1dGUs
IHN1YmxpY2Vuc2UsIGFuZC9vciBzZWxsIGNvcGllcyBvZiB0aGUgU29mdHdhcmUsCisgKiBhbmQg
dG8gcGVybWl0IHBlcnNvbnMgdG8gd2hvbSB0aGUgU29mdHdhcmUgaXMgZnVybmlzaGVkIHRvIGRv
IHNvLCBzdWJqZWN0IHRvCisgKiB0aGUgZm9sbG93aW5nIGNvbmRpdGlvbnM6CisgKgorICogVGhl
IGFib3ZlIGNvcHlyaWdodCBub3RpY2UgYW5kIHRoaXMgcGVybWlzc2lvbiBub3RpY2Ugc2hhbGwg
YmUgaW5jbHVkZWQgaW4KKyAqIGFsbCBjb3BpZXMgb3Igc3Vic3RhbnRpYWwgcG9ydGlvbnMgb2Yg
dGhlIFNvZnR3YXJlLgorICoKKyAqIFRIRSBTT0ZUV0FSRSBJUyBQUk9WSURFRCAiQVMgSVMiLCBX
SVRIT1VUIFdBUlJBTlRZIE9GIEFOWSBLSU5ELCBFWFBSRVNTIE9SCisgKiBJTVBMSUVELCBJTkNM
VURJTkcgQlVUIE5PVCBMSU1JVEVEIFRPIFRIRSBXQVJSQU5USUVTIE9GIE1FUkNIQU5UQUJJTElU
WSwKKyAqIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFIEFORCBOT05JTkZSSU5HRU1F
TlQuIElOIE5PIEVWRU5UIFNIQUxMIFRIRQorICogQVVUSE9SUyBPUiBDT1BZUklHSFQgSE9MREVS
UyBCRSBMSUFCTEUgRk9SIEFOWSBDTEFJTSwgREFNQUdFUyBPUiBPVEhFUgorICogTElBQklMSVRZ
LCBXSEVUSEVSIElOIEFOIEFDVElPTiBPRiBDT05UUkFDVCwgVE9SVCBPUiBPVEhFUldJU0UsIEFS
SVNJTkcKKyAqIEZST00sIE9VVCBPRiBPUiBJTiBDT05ORUNUSU9OIFdJVEggVEhFIFNPRlRXQVJF
IE9SIFRIRSBVU0UgT1IgT1RIRVIgREVBTElOR1MKKyAqIElOIFRIRSBTT0ZUV0FSRS4KKyAqLwor
CisjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+CisjaW5jbHVkZSA8bGludXgvc3BpbmxvY2su
aD4KKyNpbmNsdWRlIDxsaW51eC9jcHUuaD4KKyNpbmNsdWRlIDxsaW51eC9zdGF0Lmg+CisjaW5j
bHVkZSA8eGVuL3hlbi5oPgorI2luY2x1ZGUgPHhlbi94ZW5idXMuaD4KKyNpbmNsdWRlIDx4ZW4v
ZXZlbnRzLmg+CisjaW5jbHVkZSA8eGVuL2ludGVyZmFjZS9wbGF0Zm9ybS5oPgorI2luY2x1ZGUg
PGFzbS94ZW4vaHlwZXJ2aXNvci5oPgorI2luY2x1ZGUgPGFzbS94ZW4vaHlwZXJjYWxsLmg+CisK
K3N0cnVjdCBwY3B1IHsKKwlzdHJ1Y3QgbGlzdF9oZWFkIHBjcHVfbGlzdDsKKwlzdHJ1Y3QgZGV2
aWNlIGRldjsKKwl1aW50MzJfdCB4ZW5faWQ7CisJdWludDMyX3QgYXBpY19pZDsKKwl1aW50MzJf
dCBhY3BpX2lkOworCXVpbnQzMl90IGZsYWdzOworfTsKKworc3RhdGljIHN0cnVjdCBidXNfdHlw
ZSB4ZW5fcGNwdV9zdWJzeXMgPSB7CisJLm5hbWUgPSAieGVuX2NwdSIsCisJLmRldl9uYW1lID0g
Inhlbl9jcHUiLAorfTsKKworc3RhdGljIERFRklORV9NVVRFWCh4ZW5fcGNwdV9sb2NrKTsKKyNk
ZWZpbmUgZ2V0X3BjcHVfbG9jaygpIG11dGV4X2xvY2soJnhlbl9wY3B1X2xvY2spOworI2RlZmlu
ZSBwdXRfcGNwdV9sb2NrKCkgbXV0ZXhfdW5sb2NrKCZ4ZW5fcGNwdV9sb2NrKTsKKworI2RlZmlu
ZSBYRU5fUENQVSAieGVuX2NwdTogIgorCitzdHJ1Y3QgeGVuX3BjcHVzIHsKKwlzdHJ1Y3QgbGlz
dF9oZWFkIGxpc3Q7Cit9Oworc3RhdGljIHN0cnVjdCB4ZW5fcGNwdXMgeGVuX3BjcHVzOworCitz
dGF0aWMgaW50IHhlbl9wY3B1X2Rvd24odWludDMyX3QgeGVuX2lkKQoreworCWludCByZXQ7CisJ
c3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBvcCA9IHsKKwkJLmNtZAkJCT0gWEVOUEZfY3B1X29mZmxp
bmUsCisJCS5pbnRlcmZhY2VfdmVyc2lvbgk9IFhFTlBGX0lOVEVSRkFDRV9WRVJTSU9OLAorCQku
dS5jcHVfb2wuY3B1aWQJCT0geGVuX2lkLAorCX07CisKKwlyZXQgPSBIWVBFUlZJU09SX2RvbTBf
b3AoJm9wKTsKKwlyZXR1cm4gcmV0OworfQorCitzdGF0aWMgaW50IHhlbl9wY3B1X3VwKHVpbnQz
Ml90IHhlbl9pZCkKK3sKKwlpbnQgcmV0OworCXN0cnVjdCB4ZW5fcGxhdGZvcm1fb3Agb3AgPSB7
CisJCS5jbWQJCQk9IFhFTlBGX2NwdV9vbmxpbmUsCisJCS5pbnRlcmZhY2VfdmVyc2lvbgk9IFhF
TlBGX0lOVEVSRkFDRV9WRVJTSU9OLAorCQkudS5jcHVfb2wuY3B1aWQJCT0geGVuX2lkLAorCX07
CisKKwlyZXQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwlyZXR1cm4gcmV0OworfQorCitz
dGF0aWMgc3NpemVfdCBzaG93X29ubGluZShzdHJ1Y3QgZGV2aWNlICpkZXYsCisJCQkgICBzdHJ1
Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwKKwkJCSAgIGNoYXIgKmJ1ZikKK3sKKwlzdHJ1Y3Qg
cGNwdSAqY3B1ID0gY29udGFpbmVyX29mKGRldiwgc3RydWN0IHBjcHUsIGRldik7CisKKwlyZXR1
cm4gc3ByaW50ZihidWYsICIldVxuIiwgISEoY3B1LT5mbGFncyAmIFhFTl9QQ1BVX0ZMQUdTX09O
TElORSkpOworfQorCitzdGF0aWMgc3NpemVfdCBfX3JlZiBzdG9yZV9vbmxpbmUoc3RydWN0IGRl
dmljZSAqZGV2LAorCQkJCSAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsCisJCQkJICBj
b25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkKK3sKKwlzdHJ1Y3QgcGNwdSAqY3B1ID0gY29u
dGFpbmVyX29mKGRldiwgc3RydWN0IHBjcHUsIGRldik7CisJc3NpemVfdCByZXQ7CisKKwlzd2l0
Y2ggKGJ1ZlswXSkgeworCWNhc2UgJzAnOgorCQlyZXQgPSB4ZW5fcGNwdV9kb3duKGNwdS0+eGVu
X2lkKTsKKwkJYnJlYWs7CisJY2FzZSAnMSc6CisJCXJldCA9IHhlbl9wY3B1X3VwKGNwdS0+eGVu
X2lkKTsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJcmV0ID0gLUVJTlZBTDsKKwl9CisKKwlpZiAo
cmV0ID49IDApCisJCXJldCA9IGNvdW50OworCXJldHVybiByZXQ7Cit9CitzdGF0aWMgREVWSUNF
X0FUVFIob25saW5lLCBTX0lSVUdPIHwgU19JV1VTUiwgc2hvd19vbmxpbmUsIHN0b3JlX29ubGlu
ZSk7CisKK3N0YXRpYyBzc2l6ZV90IHNob3dfYXBpY2lkKHN0cnVjdCBkZXZpY2UgKmRldiwKKwkJ
CSAgIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLAorCQkJICAgY2hhciAqYnVmKQorewor
CXN0cnVjdCBwY3B1ICpjcHUgPSBjb250YWluZXJfb2YoZGV2LCBzdHJ1Y3QgcGNwdSwgZGV2KTsK
KworCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiV1XG4iLCBjcHUtPmFwaWNfaWQpOworfQorCitzdGF0
aWMgc3NpemVfdCBzaG93X2FjcGlpZChzdHJ1Y3QgZGV2aWNlICpkZXYsCisJCQkgICBzdHJ1Y3Qg
ZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwKKwkJCSAgIGNoYXIgKmJ1ZikKK3sKKwlzdHJ1Y3QgcGNw
dSAqY3B1ID0gY29udGFpbmVyX29mKGRldiwgc3RydWN0IHBjcHUsIGRldik7CisKKwlyZXR1cm4g
c3ByaW50ZihidWYsICIldVxuIiwgY3B1LT5hY3BpX2lkKTsKK30KK3N0YXRpYyBERVZJQ0VfQVRU
UihhcGljX2lkLCBTX0lSVUdPLCBzaG93X2FwaWNpZCwgTlVMTCk7CitzdGF0aWMgREVWSUNFX0FU
VFIoYWNwaV9pZCwgU19JUlVHTywgc2hvd19hY3BpaWQsIE5VTEwpOworCitzdGF0aWMgYm9vbCB4
ZW5fcGNwdV9vbmxpbmUodWludDMyX3QgZmxhZ3MpCit7CisJcmV0dXJuICEhKGZsYWdzICYgWEVO
X1BDUFVfRkxBR1NfT05MSU5FKTsKK30KKworc3RhdGljIHZvaWQgcGNwdV9vbmxpbmVfc3RhdHVz
KHN0cnVjdCB4ZW5wZl9wY3B1aW5mbyAqaW5mbywKKwkJCSAgICAgICBzdHJ1Y3QgcGNwdSAqcGNw
dSkKK3sKKwlpZiAoeGVuX3BjcHVfb25saW5lKGluZm8tPmZsYWdzKSAmJgorCSAgICF4ZW5fcGNw
dV9vbmxpbmUocGNwdS0+ZmxhZ3MpKSB7CisJCS8qIHRoZSBwY3B1IGlzIG9ubGluZWQgKi8KKwkJ
cGNwdS0+ZmxhZ3MgfD0gWEVOX1BDUFVfRkxBR1NfT05MSU5FOworCQlrb2JqZWN0X3VldmVudCgm
cGNwdS0+ZGV2LmtvYmosIEtPQkpfT05MSU5FKTsKKwl9IGVsc2UgaWYgKCF4ZW5fcGNwdV9vbmxp
bmUoaW5mby0+ZmxhZ3MpICYmCisJCSAgICB4ZW5fcGNwdV9vbmxpbmUocGNwdS0+ZmxhZ3MpKSB7
CisJCS8qIFRoZSBwY3B1IGlzIG9mZmxpbmVkICovCisJCXBjcHUtPmZsYWdzICY9IH5YRU5fUENQ
VV9GTEFHU19PTkxJTkU7CisJCWtvYmplY3RfdWV2ZW50KCZwY3B1LT5kZXYua29iaiwgS09CSl9P
RkZMSU5FKTsKKwl9Cit9CisKK3N0YXRpYyBzdHJ1Y3QgcGNwdSAqZ2V0X3BjcHUodWludDMyX3Qg
eGVuX2lkKQoreworCXN0cnVjdCBwY3B1ICpwY3B1ID0gTlVMTDsKKworCWxpc3RfZm9yX2VhY2hf
ZW50cnkocGNwdSwgJnhlbl9wY3B1cy5saXN0LCBwY3B1X2xpc3QpIHsKKwkJaWYgKHBjcHUtPnhl
bl9pZCA9PSB4ZW5faWQpCisJCQlyZXR1cm4gcGNwdTsKKwl9CisJcmV0dXJuIE5VTEw7Cit9CisK
K3N0YXRpYyB2b2lkIHBjcHVfc3lzX3JlbW92ZShzdHJ1Y3QgcGNwdSAqcGNwdSkKK3sKKwlzdHJ1
Y3QgZGV2aWNlICpkZXY7CisKKwlpZiAoIXBjcHUpCisJCXJldHVybjsKKworCWRldiA9ICZwY3B1
LT5kZXY7CisJaWYgKGRldi0+aWQpCisJCWRldmljZV9yZW1vdmVfZmlsZShkZXYsICZkZXZfYXR0
cl9vbmxpbmUpOworCWRldmljZV9yZW1vdmVfZmlsZShkZXYsICZkZXZfYXR0cl9hY3BpX2lkKTsK
KwlkZXZpY2VfcmVtb3ZlX2ZpbGUoZGV2LCAmZGV2X2F0dHJfYXBpY19pZCk7CisJZGV2aWNlX3Vu
cmVnaXN0ZXIoZGV2KTsKK30KKworc3RhdGljIHZvaWQgZnJlZV9wY3B1KHN0cnVjdCBwY3B1ICpw
Y3B1KQoreworCWlmICghcGNwdSkKKwkJcmV0dXJuOworCisJcGNwdV9zeXNfcmVtb3ZlKHBjcHUp
OworCWxpc3RfZGVsKCZwY3B1LT5wY3B1X2xpc3QpOworCWtmcmVlKHBjcHUpOworfQorCitzdGF0
aWMgaW50IHBjcHVfc3lzX2NyZWF0ZShzdHJ1Y3QgcGNwdSAqcGNwdSkKK3sKKwlzdHJ1Y3QgZGV2
aWNlICpkZXY7CisJaW50IGVyciA9IC1FSU5WQUw7CisKKwlpZiAoIXBjcHUpCisJCXJldHVybiBl
cnI7CisKKwlkZXYgPSAmcGNwdS0+ZGV2OworCWRldi0+YnVzID0gJnhlbl9wY3B1X3N1YnN5czsK
KwlkZXYtPmlkID0gcGNwdS0+eGVuX2lkOworCisJZXJyID0gZGV2aWNlX3JlZ2lzdGVyKGRldik7
CisJaWYgKGVycikKKwkJZ290byBlcnIxOworCisJZXJyID0gZGV2aWNlX2NyZWF0ZV9maWxlKGRl
diwgJmRldl9hdHRyX2FwaWNfaWQpOworCWlmIChlcnIpCisJCWdvdG8gZXJyMjsKKwllcnIgPSBk
ZXZpY2VfY3JlYXRlX2ZpbGUoZGV2LCAmZGV2X2F0dHJfYWNwaV9pZCk7CisJaWYgKGVycikKKwkJ
Z290byBlcnIzOworCS8qIE5vdCBvcGVuIHBjcHUwIG9ubGluZSBhY2Nlc3MgdG8gdXNlciAqLwor
CWlmIChkZXYtPmlkKSB7CisJCWVyciA9IGRldmljZV9jcmVhdGVfZmlsZShkZXYsICZkZXZfYXR0
cl9vbmxpbmUpOworCQlpZiAoZXJyKQorCQkJZ290byBlcnI0OworCX0KKworCXJldHVybiAwOwor
CitlcnI0OgorCWRldmljZV9yZW1vdmVfZmlsZShkZXYsICZkZXZfYXR0cl9hY3BpX2lkKTsKK2Vy
cjM6CisJZGV2aWNlX3JlbW92ZV9maWxlKGRldiwgJmRldl9hdHRyX2FwaWNfaWQpOworZXJyMjoK
KwlkZXZpY2VfdW5yZWdpc3RlcihkZXYpOworZXJyMToKKwlyZXR1cm4gZXJyOworfQorCitzdGF0
aWMgc3RydWN0IHBjcHUgKmluaXRfcGNwdShzdHJ1Y3QgeGVucGZfcGNwdWluZm8gKmluZm8pCit7
CisJc3RydWN0IHBjcHUgKnBjcHU7CisJaW50IGVycjsKKworCWlmIChpbmZvLT5mbGFncyAmIFhF
Tl9QQ1BVX0ZMQUdTX0lOVkFMSUQpCisJCXJldHVybiBFUlJfUFRSKC1FTk9ERVYpOworCisJcGNw
dSA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBwY3B1KSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFwY3B1
KQorCQlyZXR1cm4gRVJSX1BUUigtRU5PTUVNKTsKKworCUlOSVRfTElTVF9IRUFEKCZwY3B1LT5w
Y3B1X2xpc3QpOworCXBjcHUtPnhlbl9pZCA9IGluZm8tPnhlbl9jcHVpZDsKKwlwY3B1LT5hcGlj
X2lkID0gaW5mby0+YXBpY19pZDsKKwlwY3B1LT5hY3BpX2lkID0gaW5mby0+YWNwaV9pZDsKKwlw
Y3B1LT5mbGFncyA9IGluZm8tPmZsYWdzOworCisJZXJyID0gcGNwdV9zeXNfY3JlYXRlKHBjcHUp
OworCWlmIChlcnIpIHsKKwkJcHJfd2FybmluZyhYRU5fUENQVSAiRmFpbGVkIHRvIHJlZ2lzdGVy
IHBjcHUlZFxuIiwKKwkJCSAgIGluZm8tPnhlbl9jcHVpZCk7CisJCWtmcmVlKHBjcHUpOworCQly
ZXR1cm4gRVJSX1BUUigtRU5PRU5UKTsKKwl9CisKKwlsaXN0X2FkZF90YWlsKCZwY3B1LT5wY3B1
X2xpc3QsICZ4ZW5fcGNwdXMubGlzdCk7CisJcmV0dXJuIHBjcHU7Cit9CisKKy8qCisgKiBDYWxs
ZXIgc2hvdWxkIGhvbGQgdGhlIHBjcHUgbG9jaworICovCitzdGF0aWMgaW50IF9zeW5jX3BjcHUo
dWludDMyX3QgY3B1X251bSwgdWludDMyX3QgKnB0cl9tYXhfY3B1X251bSkKK3sKKwlpbnQgcmV0
OworCXN0cnVjdCBwY3B1ICpwY3B1ID0gTlVMTDsKKwlzdHJ1Y3QgeGVucGZfcGNwdWluZm8gKmlu
Zm87CisJc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCBvcCA9IHsKKwkJLmNtZCAgICAgICAgICAgICAg
ICAgICA9IFhFTlBGX2dldF9jcHVpbmZvLAorCQkuaW50ZXJmYWNlX3ZlcnNpb24gICAgID0gWEVO
UEZfSU5URVJGQUNFX1ZFUlNJT04sCisJCS51LnBjcHVfaW5mby54ZW5fY3B1aWQgPSBjcHVfbnVt
LAorCX07CisKKwlyZXQgPSBIWVBFUlZJU09SX2RvbTBfb3AoJm9wKTsKKwlpZiAocmV0KQorCQly
ZXR1cm4gcmV0OworCisJaW5mbyA9ICZvcC51LnBjcHVfaW5mbzsKKwlpZiAocHRyX21heF9jcHVf
bnVtKQorCQkqcHRyX21heF9jcHVfbnVtID0gaW5mby0+bWF4X3ByZXNlbnQ7CisKKwlwY3B1ID0g
Z2V0X3BjcHUoY3B1X251bSk7CisKKwlpZiAoaW5mby0+ZmxhZ3MgJiBYRU5fUENQVV9GTEFHU19J
TlZBTElEKSB7CisJCS8qIFRoZSBwY3B1IGhhcyBiZWVuIHJlbW92ZWQgKi8KKwkJaWYgKHBjcHUp
CisJCQlmcmVlX3BjcHUocGNwdSk7CisJCXJldHVybiAwOworCX0KKworCWlmICghcGNwdSkgewor
CQlwY3B1ID0gaW5pdF9wY3B1KGluZm8pOworCQlpZiAoSVNfRVJSX09SX05VTEwocGNwdSkpCisJ
CQlyZXR1cm4gLUVOT0RFVjsKKwl9IGVsc2UKKwkJcGNwdV9vbmxpbmVfc3RhdHVzKGluZm8sIHBj
cHUpOworCisJcmV0dXJuIDA7Cit9CisKKy8qCisgKiBTeW5jIGRvbTAncyBwY3B1IGluZm9ybWF0
aW9uIHdpdGggeGVuIGh5cGVydmlzb3IncworICovCitzdGF0aWMgaW50IHhlbl9zeW5jX3BjcHVz
KHZvaWQpCit7CisJLyoKKwkgKiBCb290IGNwdSBhbHdheXMgaGF2ZSBjcHVfaWQgMCBpbiB4ZW4K
KwkgKi8KKwl1aW50MzJfdCBjcHVfbnVtID0gMCwgbWF4X2NwdV9udW0gPSAwOworCWludCBlcnIg
PSAwOworCXN0cnVjdCBsaXN0X2hlYWQgKmVsZW0sICp0bXA7CisJc3RydWN0IHBjcHUgKnBjcHU7
CisKKwlnZXRfcGNwdV9sb2NrKCk7CisKKwl3aGlsZSAoIWVyciAmJiAoY3B1X251bSA8PSBtYXhf
Y3B1X251bSkpIHsKKwkJZXJyID0gX3N5bmNfcGNwdShjcHVfbnVtLCAmbWF4X2NwdV9udW0pOwor
CQljcHVfbnVtKys7CisJfQorCisJaWYgKGVycikgeworCQlsaXN0X2Zvcl9lYWNoX3NhZmUoZWxl
bSwgdG1wLCAmeGVuX3BjcHVzLmxpc3QpIHsKKwkJCXBjcHUgPSBsaXN0X2VudHJ5KGVsZW0sIHN0
cnVjdCBwY3B1LCBwY3B1X2xpc3QpOworCQkJZnJlZV9wY3B1KHBjcHUpOworCQl9CisJfQorCisJ
cHV0X3BjcHVfbG9jaygpOworCisJcmV0dXJuIGVycjsKK30KKworc3RhdGljIHZvaWQgeGVuX3Bj
cHVfZHBjKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKK3sKKwl4ZW5fc3luY19wY3B1cygpOwor
fQorc3RhdGljIERFQ0xBUkVfV09SSyh4ZW5fcGNwdV93b3JrLCB4ZW5fcGNwdV9kcGMpOworCitz
dGF0aWMgaXJxcmV0dXJuX3QgeGVuX3BjcHVfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9p
ZCkKK3sKKwlzY2hlZHVsZV93b3JrKCZ4ZW5fcGNwdV93b3JrKTsKKwlyZXR1cm4gSVJRX0hBTkRM
RUQ7Cit9CisKK3N0YXRpYyBpbnQgX19pbml0IHhlbl9wY3B1X2luaXQodm9pZCkKK3sKKwlpbnQg
cmV0OworCisJaWYgKCF4ZW5faW5pdGlhbF9kb21haW4oKSkKKwkJcmV0dXJuIC1FTk9ERVY7CisK
KwlyZXQgPSBzdWJzeXNfc3lzdGVtX3JlZ2lzdGVyKCZ4ZW5fcGNwdV9zdWJzeXMsIE5VTEwpOwor
CWlmIChyZXQpIHsKKwkJcHJfd2FybmluZyhYRU5fUENQVSAiRmFpbGVkIHRvIHJlZ2lzdGVyIHBj
cHUgc3Vic3lzXG4iKTsKKwkJcmV0dXJuIHJldDsKKwl9CisKKwlJTklUX0xJU1RfSEVBRCgmeGVu
X3BjcHVzLmxpc3QpOworCisJcmV0ID0geGVuX3N5bmNfcGNwdXMoKTsKKwlpZiAocmV0KSB7CisJ
CXByX3dhcm5pbmcoWEVOX1BDUFUgIkZhaWxlZCB0byBzeW5jIHBjcHUgaW5mb1xuIik7CisJCXJl
dHVybiByZXQ7CisJfQorCisJcmV0ID0gYmluZF92aXJxX3RvX2lycWhhbmRsZXIoVklSUV9QQ1BV
X1NUQVRFLCAwLAorCQkJCSAgICAgIHhlbl9wY3B1X2ludGVycnVwdCwgMCwKKwkJCQkgICAgICAi
cGNwdSIsIE5VTEwpOworCWlmIChyZXQgPCAwKSB7CisJCXByX3dhcm5pbmcoWEVOX1BDUFUgIkZh
aWxlZCB0byBiaW5kIHBjcHUgdmlycVxuIik7CisJCXJldHVybiByZXQ7CisJfQorCisJcmV0dXJu
IDA7Cit9CithcmNoX2luaXRjYWxsKHhlbl9wY3B1X2luaXQpOwpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS94ZW4vaW50ZXJmYWNlL3BsYXRmb3JtLmggYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZv
cm0uaAppbmRleCA0ODY2NTNmLi4yYzU2ZDRmIDEwMDY0NAotLS0gYS9pbmNsdWRlL3hlbi9pbnRl
cmZhY2UvcGxhdGZvcm0uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZhY2UvcGxhdGZvcm0uaApA
QCAtMjk4LDcgKzI5OCw3IEBAIHN0cnVjdCB4ZW5wZl9zZXRfcHJvY2Vzc29yX3BtaW5mbyB7CiB9
OwogREVGSU5FX0dVRVNUX0hBTkRMRV9TVFJVQ1QoeGVucGZfc2V0X3Byb2Nlc3Nvcl9wbWluZm8p
OwogCi0jZGVmaW5lIFhFTlBGX2dldF9jcHVpbmZvIDU1CisjZGVmaW5lIFhFTlBGX2dldF9jcHVp
bmZvCTU1CiBzdHJ1Y3QgeGVucGZfcGNwdWluZm8gewogCS8qIElOICovCiAJdWludDMyX3QgeGVu
X2NwdWlkOwpAQCAtMzE0LDYgKzMxNCwxMyBAQCBzdHJ1Y3QgeGVucGZfcGNwdWluZm8gewogfTsK
IERFRklORV9HVUVTVF9IQU5ETEVfU1RSVUNUKHhlbnBmX3BjcHVpbmZvKTsKIAorI2RlZmluZSBY
RU5QRl9jcHVfb25saW5lCTU2CisjZGVmaW5lIFhFTlBGX2NwdV9vZmZsaW5lCTU3CitzdHJ1Y3Qg
eGVucGZfY3B1X29sIHsKKwl1aW50MzJfdCBjcHVpZDsKK307CitERUZJTkVfR1VFU1RfSEFORExF
X1NUUlVDVCh4ZW5wZl9jcHVfb2wpOworCiBzdHJ1Y3QgeGVuX3BsYXRmb3JtX29wIHsKIAl1aW50
MzJfdCBjbWQ7CiAJdWludDMyX3QgaW50ZXJmYWNlX3ZlcnNpb247IC8qIFhFTlBGX0lOVEVSRkFD
RV9WRVJTSU9OICovCkBAIC0zMzAsNiArMzM3LDcgQEAgc3RydWN0IHhlbl9wbGF0Zm9ybV9vcCB7
CiAJCXN0cnVjdCB4ZW5wZl9nZXRpZGxldGltZSAgICAgICBnZXRpZGxldGltZTsKIAkJc3RydWN0
IHhlbnBmX3NldF9wcm9jZXNzb3JfcG1pbmZvIHNldF9wbWluZm87CiAJCXN0cnVjdCB4ZW5wZl9w
Y3B1aW5mbyAgICAgICAgICBwY3B1X2luZm87CisJCXN0cnVjdCB4ZW5wZl9jcHVfb2wgICAgICAg
ICAgICBjcHVfb2w7CiAJCXVpbnQ4X3QgICAgICAgICAgICAgICAgICAgICAgICBwYWRbMTI4XTsK
IAl9IHU7CiB9OwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS94ZW4vaW50ZXJmYWNlL3hlbi5oIGIvaW5j
bHVkZS94ZW4vaW50ZXJmYWNlL3hlbi5oCmluZGV4IGE4OTA4MDQuLjA4MDE0NjggMTAwNjQ0Ci0t
LSBhL2luY2x1ZGUveGVuL2ludGVyZmFjZS94ZW4uaAorKysgYi9pbmNsdWRlL3hlbi9pbnRlcmZh
Y2UveGVuLmgKQEAgLTgwLDYgKzgwLDcgQEAKICNkZWZpbmUgVklSUV9DT05TT0xFICAgIDIgIC8q
IChET00wKSBCeXRlcyByZWNlaXZlZCBvbiBlbWVyZ2VuY3kgY29uc29sZS4gKi8KICNkZWZpbmUg
VklSUV9ET01fRVhDICAgIDMgIC8qIChET00wKSBFeGNlcHRpb25hbCBldmVudCBmb3Igc29tZSBk
b21haW4uICAgKi8KICNkZWZpbmUgVklSUV9ERUJVR0dFUiAgIDYgIC8qIChET00wKSBBIGRvbWFp
biBoYXMgcGF1c2VkIGZvciBkZWJ1Z2dpbmcuICAgKi8KKyNkZWZpbmUgVklSUV9QQ1BVX1NUQVRF
IDkgIC8qIChET00wKSBQQ1BVIHN0YXRlIGNoYW5nZWQgICAgICAgICAgICAgICAgICAgKi8KIAog
LyogQXJjaGl0ZWN0dXJlLXNwZWNpZmljIFZJUlEgZGVmaW5pdGlvbnMuICovCiAjZGVmaW5lIFZJ
UlFfQVJDSF8wICAgIDE2Ci0tIAoxLjcuMQoK

--_002_DE8DF0795D48FD4CA783C40EC8292335154F3ESHSMSX101ccrcorpi_--
